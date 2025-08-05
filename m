Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E59EC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1088A8E0008; Tue,  5 Aug 2025 10:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E11C8E0001; Tue,  5 Aug 2025 10:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F38E48E0008; Tue,  5 Aug 2025 10:26:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E2ED88E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:26:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 919DC564E4
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:26:25 +0000 (UTC)
X-FDA: 83742929130.12.D7A6C85
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id AD9D318000B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:26:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KHtF0RNk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754403983; a=rsa-sha256;
	cv=none;
	b=S9IRpHwzqZ+uEx+ha+hk8r5W+lXCdPRHoo/NQVp9o4EBNgaLZ5V+iieVmHJ2yfVlrwcGut
	hxPCFaAe2OmzNltChyPVL+FUaBTGhx6eyLYgjPEtoezAWbHwcicYPSK4PfIUoNhyVRaTD3
	L2TAYR3TtGXmj451GruMewDLDXKDAtk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KHtF0RNk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754403983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ry5Dfhvc2U44AmB7UaxhnygbevOBppFjf0G6WuFTeXE=;
	b=j9PzObRTxc5+6hYe/DTA6FdzNQ6feBkKc2XXH0rCUkF1eK6O29VrS0QfiTdhZ/hEji6Cdv
	3vDz4Raz4GpFS0BHz9UHNUuZ+LhR23guGTk7lgs4wPZNhK5WfY6ZSZSd0O4K5/HxrfS+IX
	a+Fs0uYSJwVEQPncwO/6uxPIuueSaUc=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-459d4d7c745so24844345e9.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 07:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754403982; x=1755008782; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ry5Dfhvc2U44AmB7UaxhnygbevOBppFjf0G6WuFTeXE=;
        b=KHtF0RNkTBOdOT5gQNWHZEQN2C7lbId/FpngqrfTZdW4IpDlb9vRgJuYOgVAA9vEPe
         I6XL4ja1PZIh8V8MBZih+5rq4JTrasHN6FxxzO/kjz7djztju4BkFDYSoqM/NqeR0pdV
         4e3MuBn0WDBhkb65P/y2Rs298ZPILaNfRhWQD4CNRRF3yx6etXmka0Tef/ihqE98NHNp
         f8MRkmeQenoepTXvhAMEScjepvE1Vk3LRPlpRr8O97KrpE3AFqMa0zMhqEzvYNsac6Ns
         OUkmAeHtrIgSvnsxpRYvyG3F8L2b/OwYfu/9lG6dfYirEGyiZKs+NAlqe0n+QajyT7z4
         S6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754403982; x=1755008782;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ry5Dfhvc2U44AmB7UaxhnygbevOBppFjf0G6WuFTeXE=;
        b=RHMFgvlM0YQUkUyYA2/RG991WbwZGK66M01y/0bkkKEWQoQrr8bsieo4FoGogm9PUl
         t3UVwV0nNTuv3YCb4AH4ktUKpwly8B0RWsCsSOcXIOMHT3q1Vj+0D182QQRTytrRllj9
         PF7qhvTUI3yC4L1fWEyNBvjG/+eZb2nogwoNnlXTkK/mt+/j5ASrVxORHjEoroy9tSre
         mXsfOZ5EvclS0I/SfX2zgBQllF/9f0Ysz7GtEYNd360PFaN5nJkNxS2L4JZ+GuwpPJX/
         l1QDNHSKD3IBTTL6e1532x9EPDzxa90LQKI6bsbEEI2eP/aMAQBB30wj4TcMNXNoTR6D
         AaAg==
X-Forwarded-Encrypted: i=1; AJvYcCWRA7pdExIOqlO7QY77akKffit7vrKkdBmkeOUmZvvZGO9DjaaA0Kb3AgTgkP1nN2lVXSCT+mP2RQ==@kvack.org
X-Gm-Message-State: AOJu0YyCI7d+L1RpM+ShT89OZw7G7facljqRraE96lYjtkztdEI1dPEc
	uvmkwm4sNX+d09fWQ/0I1s4We846evkStBbTLevGrkgpBOXe+35Yed5R
X-Gm-Gg: ASbGncuLoue0ujHnM5udGQQeFVjirM9tuvKmEcIjACWDax3dLkNziPijig30s+iihGY
	U5IUv7c01zln9Ur1GHs/36bO3nsc0cTlh6fM+xtr5eg/0UOVOGlqSsUX+qyCu/JqALtuuJo8fW6
	KxGPD7u1XToDOiSgv1ihVWdNwBFuz2PAysX/Oy0xBR4kyuEyGeh3sBbthTB2/jAhwVwHW3djJO2
	hK/l3yUqnXKv+9TJf8IB9sCkvGjIfaXERngt8Btb1E4VdAPnvfTWU9dwz4K1eUvo9jzpkW1EPac
	pp9Hd8Epzr2yirvJpUnuLyL5fo7gsRybBw+9+N94Npq1I1HHEWacMmohmCXnzzoBBfj0xhSeEhl
	+TGY5fQIZ/y2B5QKL41O+F0Y18HVxMzSAeRrKM5uiAS/nYkrZHBhw5aqGdi6GLXZkrsYMda3jkJ
	VUdt9diQ==
X-Google-Smtp-Source: AGHT+IH9EpTWoImUYJcCr9my5UTeO92YxiB5fFdInePVkEEtZ/CAl5u4VV1vdMFHKZwzOROQeDzq4Q==
X-Received: by 2002:a05:600c:470d:b0:459:d709:e5a1 with SMTP id 5b1f17b1804b1-459d709e91emr78434045e9.6.1754403981789;
        Tue, 05 Aug 2025 07:26:21 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::6:98ea])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e5c40eb1sm1458615e9.6.2025.08.05.07.26.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 07:26:21 -0700 (PDT)
Message-ID: <955ed533-dd7e-45e6-a2cb-f379a5878ef7@gmail.com>
Date: Tue, 5 Aug 2025 15:26:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] selftests: prctl: introduce tests for disabling
 THPs completely
To: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
 <20250804154317.1648084-6-usamaarif642@gmail.com>
 <66c2b413-fa60-476a-b88f-542bbda9c89c@redhat.com>
 <a22beba8-17ae-4c40-88f0-d4027d17fdbc@gmail.com>
 <e608f766-8750-4781-bd23-8fa95b6d683a@redhat.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <e608f766-8750-4781-bd23-8fa95b6d683a@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AD9D318000B
X-Stat-Signature: xr3u9g9sjhzg7rhfksycysuhf7qgz6f8
X-Rspam-User: 
X-HE-Tag: 1754403983-715274
X-HE-Meta: U2FsdGVkX1+mPJE9NwXiVPh6tLh8944bBaYNVObbPpvvOjb3J617wNzXM5ALTUHGKD6I9MKcG/YCDiSOthmGZTbwsaqVIKfvKTZ3MgXlrBqs8HKjfiZCecnmJBS6mEKA0cT/P2inxYtz0LqHI7sj/Pz1zQtOL+gmfoMZz1gfWnYhxDq7eGlQU1MKyD5MKk40/MYLyyJKd8fIrW442TxIsNPfC9rUH+Apd/c04+yhIZBQgnoHEh2CpZNdFesghp1YTSbSa6PpZa4tu5rFURatYrLwA4/Wd1MrmG5FXKqQyyQXfdZ9TbgziIj5YvIzr1l45VzOYMJXlox/OLw5GnUWZUp6gku5lkmKImyQu2AjGjI+x8rgHjtBC+vBnCguOQ2MoR7tlaueSEM5unmqIGGxVduVCo0u4STX2yFJZOj+Hl3Wec1fCopI1l10oEFD4z9GM6HcWpZ6s65IlFdKfFXinZxN/cL9Yccs4fIl9VEO0+ADXKqHYOXMxZF7f3Z5aEWCpgm6P8ROAjGKWvhO4fyNKlNOlxB0JQANaf6NC5xCdbGs1Ej9WcNUJW7SOPultGrlLZpJKb4smxfRGUQzeN5w2Uy6DelDCeWCjOhsdZAIviFtfEK8+8vA/vr/ZQFIl4XHxUWIRg/mLYARCkB8nemhEsbkN5/KWiBVhr0r8Rvp0YQCkaf0xJCTRJqxb9u+Gdc0XlWv283rWUed+HAy6FKA00daWrUsCNdzwqx48rcogGc2Tt8vmNCSMARxk9Qe9RjHeZDou+DYpe7rUYMWVLG4Yj8EQQL3CsVVKN9OLJ/HAsZHMiG5IOoSD2jaEPW4ZOJS+u/m+LMnNHo0W4aNITG42aWVNkhCta4k2phGUzNctwhVE19oYBErUnYDXZ+s4BNiQNP9HjtubwQJsyYQkYWt4gSfKTZz0Ovsk1IrXaLwhAAJj7SbUEz/kaNF8Qpdp2tLDzqY6VQHnHapsq8dxvG
 xAfLiiAF
 Q5auRrrhU2vLd8yE4kYqdvH13SZhzMsONDb13Qw28OfVEna8rmAS6tq+uujN7YQoYTG8YkaCjKp91HGr6Zw5ndBmMsvVS3GpjvcsGJ46COn1ZOPvkvaftrOKVpDVhTi7yOOU/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/08/2025 13:55, David Hildenbrand wrote:
> On 05.08.25 14:46, Usama Arif wrote:
>>
>>
>> On 05/08/2025 13:39, David Hildenbrand wrote:
>>>> +FIXTURE_SETUP(prctl_thp_disable_completely)
>>>> +{
>>>> +    if (!thp_available())
>>>> +        SKIP(return, "Transparent Hugepages not available\n");
>>>> +
>>>> +    self->pmdsize = read_pmd_pagesize();
>>>> +    if (!self->pmdsize)
>>>> +        SKIP(return, "Unable to read PMD size\n");
>>>> +
>>>> +    thp_save_settings();
>>>> +    thp_read_settings(&self->settings);
>>>> +    self->settings.thp_enabled = variant->thp_policy;
>>>> +    self->settings.hugepages[sz2ord(self->pmdsize, getpagesize())].enabled = THP_INHERIT;
>>>
>>> Oh, one more thing: should we set all other sizes also to THP_INHERIT or (for simplicity) THP_NEVER?
>>>
>>
>> hmm do we need to? I am hoping that we should always get the PMD size THP no matter what the policy
>> for others is in the scenario we have?
> 
> Assuming 64K is set to "always", couldn't it mislead us in the "madvise"/"never" test cases in some scenarios?
> 

I tried it with 64K to always and seems to be ok. check_huge_anon checks AnonHugepages from smaps which
only indicates the pmd mapped THPs only. So I think should be ok?
Happy to set them to never and the change is probably something simple like below (untested), but
just trying to understand better the need for it.

diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
index 4b072d4ecc30..ee692c397835 100644
--- a/tools/testing/selftests/mm/prctl_thp_disable.c
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -142,6 +142,8 @@ FIXTURE_SETUP(prctl_thp_disable_completely)
        thp_save_settings();
        thp_read_settings(&self->settings);
        self->settings.thp_enabled = variant->thp_policy;
+       for (int i = 1; i < sz2ord(self->pmdsize, getpagesize()); i++)
+               self->settings.hugepages[i].enabled = THP_INHERIT;
        self->settings.hugepages[sz2ord(self->pmdsize, getpagesize())].enabled = THP_INHERIT;
        thp_write_settings(&self->settings);
 }
@@ -244,6 +246,8 @@ FIXTURE_SETUP(prctl_thp_disable_except_madvise)
        thp_save_settings();
        thp_read_settings(&self->settings);
        self->settings.thp_enabled = variant->thp_policy;
+       for (int i = 1; i < sz2ord(self->pmdsize, getpagesize()); i++)
+               self->settings.hugepages[i].enabled = THP_INHERIT;
        self->settings.hugepages[sz2ord(self->pmdsize, getpagesize())].enabled = THP_INHERIT;
        thp_write_settings(&self->settings);
 }
 


[root@vm7 vmuser]# echo always >  /sys/kernel/mm/transparent_hugepage/hugepages-64kB/enabled                                                                                                                                                                                                                        
[root@vm7 vmuser]# ./prctl_thp_disable                                                                                                                                                                                                                                                                              
TAP version 13                                                                                                                                                                                                                                                                                                      
1..12                                                                                                                                                                                                                                                                                                               
# Starting 12 tests from 6 test cases.                                                                                                                                                                                                                                                                              
#  RUN           prctl_thp_disable_completely.never.nofork ...
#            OK  prctl_thp_disable_completely.never.nofork
ok 1 prctl_thp_disable_completely.never.nofork
#  RUN           prctl_thp_disable_completely.never.fork ...
#            OK  prctl_thp_disable_completely.never.fork
ok 2 prctl_thp_disable_completely.never.fork
#  RUN           prctl_thp_disable_completely.madvise.nofork ...
#            OK  prctl_thp_disable_completely.madvise.nofork
ok 3 prctl_thp_disable_completely.madvise.nofork
#  RUN           prctl_thp_disable_completely.madvise.fork ...
#            OK  prctl_thp_disable_completely.madvise.fork
ok 4 prctl_thp_disable_completely.madvise.fork
#  RUN           prctl_thp_disable_completely.always.nofork ...
#            OK  prctl_thp_disable_completely.always.nofork
ok 5 prctl_thp_disable_completely.always.nofork
#  RUN           prctl_thp_disable_completely.always.fork ...
#            OK  prctl_thp_disable_completely.always.fork
ok 6 prctl_thp_disable_completely.always.fork
#  RUN           prctl_thp_disable_except_madvise.never.nofork ...
#            OK  prctl_thp_disable_except_madvise.never.nofork
ok 7 prctl_thp_disable_except_madvise.never.nofork
#  RUN           prctl_thp_disable_except_madvise.never.fork ...
#            OK  prctl_thp_disable_except_madvise.never.fork
ok 8 prctl_thp_disable_except_madvise.never.fork
#  RUN           prctl_thp_disable_except_madvise.madvise.nofork ...
#            OK  prctl_thp_disable_except_madvise.madvise.nofork
ok 9 prctl_thp_disable_except_madvise.madvise.nofork
#  RUN           prctl_thp_disable_except_madvise.madvise.fork ...
#            OK  prctl_thp_disable_except_madvise.madvise.fork
ok 10 prctl_thp_disable_except_madvise.madvise.fork
#  RUN           prctl_thp_disable_except_madvise.always.nofork ...
#            OK  prctl_thp_disable_except_madvise.always.nofork
ok 11 prctl_thp_disable_except_madvise.always.nofork
#  RUN           prctl_thp_disable_except_madvise.always.fork ...
#            OK  prctl_thp_disable_except_madvise.always.fork
ok 12 prctl_thp_disable_except_madvise.always.fork
# PASSED: 12 / 12 tests passed.
# Totals: pass:12 fail:0 xfail:0 xpass:0 skip:0 error:0

