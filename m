Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65116FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 11:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A30ED6B008A; Tue, 28 Apr 2026 07:57:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E1596B008C; Tue, 28 Apr 2026 07:57:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D0806B0092; Tue, 28 Apr 2026 07:57:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B55F6B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:57:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3AE4816057A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:57:10 +0000 (UTC)
X-FDA: 84707813820.25.DE8E16C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 62B92140002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:57:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RvD9bT6w;
	spf=pass (imf23.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777377428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AgBBjKG/PS5Dz1DwpETM5k/BFvsOUmL0XkfBNTKeCf4=;
	b=2JxMaU2XlxwGilDEifFg5xiwm4UhfUrpm/2XXxxoHaSvQyk5duaDUg5LfWqUWml7Qs8R5R
	L8PweJnSseSfWdT4BOJNAsTIAiNJ6yJQfP8QSQtywDX/adiaZovIsKRXe38QzE6wk74bF8
	GGtnXOcQy+3WyhhaQFXm35LM/Nh8DJM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RvD9bT6w;
	spf=pass (imf23.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777377428; a=rsa-sha256;
	cv=none;
	b=U2XiQjJpMRD7IGsbmmcNF4m1CxAXWoZ9imYjbdMVXa7TN4s1Tc9ipVyyt5+8ET7td6bMoA
	1jpfW71KkdqP0fcf/RuQuO1BN4pMxuOSbhkWur3jzwNMAvC2Om5xFHfebEFRA64I/LGw+o
	mLtUmJFkKw5yulFtVK87uWIx5vsEXbc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777377425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AgBBjKG/PS5Dz1DwpETM5k/BFvsOUmL0XkfBNTKeCf4=;
	b=RvD9bT6wn8/5HU6Dc1sIYgs5dZLPywAa50NumtznAJxKJTxIX08FiD24owOxyhmILjK8ZJ
	Dd+evUe9ffLENjtrSR7KHTHasFBY7AhahX2S6jmQIyrTYpo6WbSmzcWbXVR91XipSlKBs4
	tACxAya7qvhW3yPHRe7exZxcQOiaGVo=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-398bvOnMNV2_zQmSLnmi-Q-1; Tue, 28 Apr 2026 07:57:04 -0400
X-MC-Unique: 398bvOnMNV2_zQmSLnmi-Q-1
X-Mimecast-MFC-AGG-ID: 398bvOnMNV2_zQmSLnmi-Q_1777377424
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-8a8ea3f1becso193673856d6.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:57:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777377424; x=1777982224;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AgBBjKG/PS5Dz1DwpETM5k/BFvsOUmL0XkfBNTKeCf4=;
        b=hMeY9pRMNicKGmrWzoejVGv+R+4Lp+XevCYTswiNfxsntEKoPIxR1+Va0iiBK6hh8L
         9gKIuqGny1w9KIJ34jS5AAPTLpMrEQ36cIZu9QtAw9WIojR/o/ds3J04F+B+exDcP9Yx
         HA4EjTEUw6zVJh57gTdl8kXebMAyfbJd+IzV4s9/sLdrgrJj7ppH5Rm+XASZqjs7cOVN
         qndx1D1+zn9bNzaezoMvQX/GL+4KnH1mX41Gc9oGnydB8IND2kd2VM+ZjbCDEyvVmXx4
         i17sEGPbjRYYLdyHCW1Q4MAoZ7rEY9rx9KyPoPa1YQU6Jw43u3OQ1x7hNKVLGAsvbbOS
         epYw==
X-Forwarded-Encrypted: i=1; AFNElJ+fdA3nNyaXV+HIFM6t4AHqu+GpXTRyqaL/BJAOkHLeARMPvF41m2RYrvf5dqzhaSd0Rdv0Y1N+JQ==@kvack.org
X-Gm-Message-State: AOJu0YwpmDrxpqhujI1lZE+ufsUgErdoonl0AKBKtJJ7pG+PHMvpHfK8
	oFi/C8xT2kxKP+hk5oWvfzgxoAGKTQlWEq8166xK+GhWIwu2Z7xz2RE2V+M6aK1H1Ki16euKb4D
	jezx119eEDiaBaOzf3ebE3dDMY45p5iD5kTWaJTq6NcqMtHieIxKp
X-Gm-Gg: AeBDieuPF2v02QVdSBfKWTfTZeeCOhypzKenOzzuYAEOAcXOL/11cMxuEpb+hxfGLU+
	m/brzo/6+LM4Zt+oApw90UWjexEpx2FrZeWcYtpgTEV8R5aVJ7RyOG71B99MYdOMthMJb5oXSnm
	M4JknmdD9aY7m3eP3KSsza8mIhU17uusQAnNppYkP2PsKN7s44xOpkU3r61g28xYYYR4hXAhcVF
	iomHvQVSTt5lLDTKmwpahkDxr7e7GOl8ee6fBvFtUKgoC2m2Ius0yNF26NA73o8vbu1d4GPEh0/
	Q0fgR+mrWg/WR28pGoGEV0PfgHcBApsdgMW80EhnccB6jz/OYPm3pN5H0J95ddRcb67E1h5MlB/
	lecDldlIgBiuUSas7W7gIaTtPyzfWtgAjHf4jQlhOE9W/QvPcZ/miu2oX7WDg7qT9/qnjf77y2F
	8uhkg+U8xSrGQiljt5LvwCxag=
X-Received: by 2002:a05:6214:311b:b0:8ac:ab31:0 with SMTP id 6a1803df08f44-8b3e31fb96dmr42764046d6.40.1777377423785;
        Tue, 28 Apr 2026 04:57:03 -0700 (PDT)
X-Received: by 2002:a05:6214:311b:b0:8ac:ab31:0 with SMTP id 6a1803df08f44-8b3e31fb96dmr42763486d6.40.1777377423235;
        Tue, 28 Apr 2026 04:57:03 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-22-70-53-202-134.dsl.bell.ca. [70.53.202.134])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b3e2956a8bsm18295396d6.31.2026.04.28.04.57.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 04:57:02 -0700 (PDT)
Message-ID: <09847e2f-0397-44cc-b517-75bffa7124e2@redhat.com>
Date: Tue, 28 Apr 2026 07:57:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 43/53] selftests/mm: migration: add setup of HugeTLB
 pages
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Donet Tom <donettom@linux.ibm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lance Yang <lance.yang@linux.dev>, Leon Romanovsky <leon@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Mark Brown <broonie@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Sarthak Sharma <sarthak.sharma@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-44-rppt@kernel.org>
 <a8510cbd-4a30-460c-b870-a250ceb8a522@redhat.com>
 <ae3v1cyMLbcvJtYW@kernel.org>
 <67d7b067-97a8-4600-a9a6-46f3e797ffed@redhat.com>
 <ae-UCVba16jg3-gR@kernel.org>
 <0e2ef2c0-d74e-4aff-bba0-6dd91dbd4e41@redhat.com>
 <afBKJn_EjaTAe4A-@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <afBKJn_EjaTAe4A-@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: X-tW5paGSSh4gW8fuHjMXtEShikSqsNlfpXHpX5nqe8_1777377424
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: o8zfcxfbxoyta1dwxh386awks9m3yqxf
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 62B92140002
X-Rspam-User: 
X-HE-Tag: 1777377426-286339
X-HE-Meta: U2FsdGVkX19lSx3ZFyHOYgNFA7Ajzk5EJoo1C75avlsWaFybvq7KeLDT1ZTfse/L/IRSkveISYi+fkSZBXKON+n9AJNo+fGuMk2os/LVOaitagJljuR2odQkvyt6BzBR3I2UeproCyb0fth55mcWRvU2g5qwcpBm7hsnB6b2yuwiCHhPDn8UrR35OTLrOwfkQkBZ4EfMALlvsR5KfdDZzOqnmzWLXiU3HNeoqg9AeA96WD//v+lqbbCHGPUsypUVBsXb/EEByZ3C6vOHutP2BugtjjjK86lXT1KN56bSyFr604M37FmtubapbL4iyccufovgYs4zf09/ZGnm1HJmd1Am1qT6GD9T89LZ0raIxwzFuruN4dsNDgCPZL5/uZlK3ffT29fu46/0NfdNt0lpH7DSYedLmZjYeBPstQ49rMXVbwHBj9IMLd0mgED28Hn/UjQRM4Tj36nGR8yLX63708KjB1OE0hv3L02vTByZ3zNuW39OeJsUIJRaG+iZNvm1hji+TNuWG0MlyPr7mJ3hiX1Vol9DP+R0BZFNMdcLPs0iI5hu2fH6E0qhv6XKfKeBPeuLsbvjAfxGei5/Z51ravTximmp+5C5dQS1eVAY3mja/HB7Lan6r9ciSzGeAMhFe6DSRQjX/qRt0ZZISzDWpgBREoUN4fcTPaNcVQ77Rr3cCLr9LJUw15kl1OAzopJ+cHgKxQKBDIYb86NUc+PtBYPf7SZoyAluYO2vkHI5vdjGVV581OwlBAllPRx56/CarudcNZnbjDtiGSD3MrflhIcsECcJ2q36VFGXUjt/M4fHG8IIgwivwnJY/fiULOWEHR3RtaJ/8ZZjSASLTIa9OeZsskH100Tny1sFyrFNEcvv0bLWOV6S5LfRUuFQOttwiTgGVFBcfSHDKvGWhc85SiEpLkxwYGz2N6IdL1QMFtJMfJHrXKSY65WZx6ui4DNAjjLbXk1fzn+cEsaehD3
 NrRQPRC6
 k0YpVy8aXNdcgtdVyGgVXtLjLSQccpzEF6zvS6smYnwaKtdRigvWntpGgsMgD9U4uGTgarj1tmvK11xE7OTi/fzivR763t0jjOeTMHhmTai+ebNeb1fA6Qu6iy0auiLyvSyzeMFFuB/15BkflBWoUPLHMwDzl8d/90Kv1hd7YIqJnlT3pIbSLOzWzJ5rTiNkb/qv2WJX0HAVVleeC7eWt1agvITAF0UVzfiyU5wcbWjD9g4xj9JBcz+EvekRfJ8cC4UMZNEe5dnQ1IXsJbq6xMbrDHF7et2KmObpDY7cf3UvyEbVXG+tV1j8TdeogM4RcAEd+wLtB6eqQa6dpetyoT7PnWxjPrWIcZReiz57WAHLLY30QUClW1dtSNxaFwGkLnV3FXmpXumw306X5MN0on/TvTfUYWm7HTzz/0b3fpT8N90dwPqh2Hdef/oFOeXxFcauaGHItrel5y+E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-28 01:48, Mike Rapoport wrote:
> On Mon, Apr 27, 2026 at 01:19:07PM -0400, Luiz Capitulino wrote:
>> On 2026-04-27 12:51, Mike Rapoport wrote:
>>> On Mon, Apr 27, 2026 at 08:56:27AM -0400, Luiz Capitulino wrote:
>>>> On 2026-04-26 06:58, Mike Rapoport wrote:
>>>>>> And there's another issue: when running the migration test individually,
>>>>>> private_anon_htlb gets skipped. I guess it's because the previous test
>>>>>> is restoring the HugeTLB state:
>>>>>
>>>>> It could be.
>>>>>
>>>>> I pushed the updated version that has the fixes for both zombie and
>>>>> signal issues:
>>>>>
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=mm-selftest/v3
>>>>>
>>>>> Would be great if you can test it in your setup.
>>>>
>>>> This works! Both issues are fixed: the migration test completes w/o
>>>> hanging and when I run it individually all tests run.
>>>
>>> Thanks for confirming!
>>>> One last question: should we munmap() the mappings in this test? Though
>>>> I understand this goes beyond your series goal.
>>>
>>> We could, but the tests _exit() anyway as a part of kselftest_harness, so
>>> it does not really matter.
>>
>> OK. Just to clarify that I meant exercising the munmap() path, not that
>> we're not freeing resources. But if we know that _exit() is sufficient
>> for this, then it's fine.
> 
> exit tears down all the mappings, but the code path is slightly different
> than calling munmap().
> 
> We can add munmap() calls there, but let's do it separately from this
> series.

Agreed.


