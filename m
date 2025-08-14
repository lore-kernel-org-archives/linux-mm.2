Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D962CCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5176B90013D; Thu, 14 Aug 2025 06:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A1DD900121; Thu, 14 Aug 2025 06:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B7D090013D; Thu, 14 Aug 2025 06:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 27461900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:43:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D177F1DDAE8
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:43:24 +0000 (UTC)
X-FDA: 83775026328.19.6C21FF6
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id DD1091A0003
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:43:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cUvGJ0rz;
	spf=pass (imf19.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755168203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YLtt5xMhmDFA2ShL0rr0DmKUZACD1c7sVV5qlbjjBKA=;
	b=PEh+f4RK/EaXq2Hgr0+tvjapyxWQe6TrvQYhlFUbQ6N/6Cjv8KJpPV1Iiag3n9Q5jihJjh
	bo0lGeLVgw2TkYo4TSdtaQKRN2RmmEKJsLDXIKFaOzobMrzZs49YtrBsmuBwQJn/vlvoyy
	4oA4G3ieNbW/yfSiIrHegEozuBY4r/M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755168203; a=rsa-sha256;
	cv=none;
	b=OTjqCGJvs7OKyyTOIzsCst/2azhwobbPoT07WEJozRJMpznn12xTDZcVgI4cMVfpJ851J8
	TNMyt8NuiGSpG4CfFo2XY+mIUJjCh+4RCQpUvXKrymp2NFk/5KEAAskvHVmyEJiavhh7/K
	NzzcqaT1XYiSwHw/r5kNBbkhlfBeoUw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cUvGJ0rz;
	spf=pass (imf19.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3b916fda762so891648f8f.0
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755168201; x=1755773001; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YLtt5xMhmDFA2ShL0rr0DmKUZACD1c7sVV5qlbjjBKA=;
        b=cUvGJ0rzLvbSWI4RDb1Bw1EG4aZywQHpZ+tf7GepUhtqPyE7TMWeKfdBAOGNG+elJB
         or7ZYH/sBmdwjML30KJp2DlL4ohObjTsX7rj1Xa+Z7BQvDe5v+E5z/qe4+AcWcROMyx3
         RBEReanWYPh/vUkJ/wRQsWwTpoDtVPWwnio8UIMSc9nlBgczmNhcAGqcrZL2FIcFHZnm
         EaP8fr9HnOCy+OqqFqRKx7/q4iOiH488DiU7wh0d1TKCVfdMZApuE+V1NQqCX3pFscKq
         S+4fh0kYQnYeADeH+WRJFAlFKeTIAKRH7DS+9M3sNB0jbus4QJ7Us+4w2TV13SzjiXk/
         EG7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755168201; x=1755773001;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YLtt5xMhmDFA2ShL0rr0DmKUZACD1c7sVV5qlbjjBKA=;
        b=M7lV7ieuddXe2Okuow80KY0hL0p6yT6tA/3MnC0Bet7qDtuUxZzZywVzuS1jugi/0V
         DTTNP8niRCt0g3VKwxMiaeNgG3dURCtT9Qk1b4txgp20C6dJB9ybb0DIa5PCjSE8LaeF
         glMlbcsZic8apChDGE73qLrJYK97sxebgUX4p8Le/APjakMtXy/X9mx/8Tz1m5J90Ddu
         GR+dkoTsFgbMHY7t4KdM6qxK5w9cwJFzCu+ZegJgqP3b4Gjgg32lXMHDDrqbE6HP6gQb
         dWIFopuNzuDp2lgQNLcPP+hRg6hJvJNlU/tysRoedPb+BJMBaTbAbgcVTk3aUyCrCBzD
         4pvA==
X-Gm-Message-State: AOJu0YzYYpqS6NEJs1rxiA4ZyE8rQuYbvADRAPTpFOQMEfPHW42nK9i8
	1gPR4D9nXmsYzd8FEp2FmDvSTUZALbZr1C9ufwFRwJAUykCxkwK0U3ch
X-Gm-Gg: ASbGncux41ViVDRqc3WMSs2chiG7bQx5ZhUY5ImBqvzsND5H85lBWTsxnaWbJq/gmZ3
	KwcBqZ2EJQUolLvaimnxkxR414rnWi3lcqgcfMAKrUTIY1lvOvs9ahXXYL9FXbmnBNhKF2WtT1A
	ZTLui4Tmpeq0FkVybovrNKql5CzH/x3STjLlRba9WaI/NO886YTfArSFNJDxyetPMXJhym7HNz+
	S5oi8WAnY0uLesYQcMYhTrFvkJtEOoDk+GHLhyex3r6tr+oUV/yw5DkaNa4cJC24ue6+8J01QmM
	ZneBWdF9sfLG7WdNVO/DDL0uxc8rSdTPSysAuNG4fJ331LhZ3HYcq5G/HjtiafzLp2vKw4+JfvY
	bAnOA9yfQuyz0mjh6zJRdzNP74S0CDdwdRVr6FCLIFk9J+NbIpsfVD64Ae+nwjDj3CvekRKXeeP
	mQFWWdkg==
X-Google-Smtp-Source: AGHT+IHHxD/2V76qZjPAaomdu2zzYXxDs5OzsF/We/4FunFKZx8JdJGlm4zSbvh7T4zkS/IvSG5F2w==
X-Received: by 2002:a05:6000:2891:b0:3b8:de54:6e64 with SMTP id ffacd0b85a97d-3ba50d5c0fdmr1738678f8f.26.1755168200966;
        Thu, 14 Aug 2025 03:43:20 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::7:8979])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9eddsm50514108f8f.22.2025.08.14.03.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Aug 2025 03:43:20 -0700 (PDT)
Message-ID: <c8a47a7d-3810-426f-a2cf-7c020ce25c7d@gmail.com>
Date: Thu, 14 Aug 2025 11:43:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/7] mm/huge_memory: convert "tva_flags" to "enum
 tva_type"
To: Yafang Shao <laoar.shao@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, david@redhat.com
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, corbet@lwn.net,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
 baohua@kernel.org, shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com
References: <20250813135642.1986480-1-usamaarif642@gmail.com>
 <20250813135642.1986480-3-usamaarif642@gmail.com>
 <CALOAHbAe9Rbb2iC3Vnw29jxHEQiWA83jw72fb_CQKGDFHv6+FQ@mail.gmail.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <CALOAHbAe9Rbb2iC3Vnw29jxHEQiWA83jw72fb_CQKGDFHv6+FQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DD1091A0003
X-Stat-Signature: 8o9o3xs6r5cyodzbakiz5am97xpmjb4b
X-Rspam-User: 
X-HE-Tag: 1755168202-478404
X-HE-Meta: U2FsdGVkX1/WAYNFEO3zs+xFWn/yYCYPc1/M4n1Qa38+OJ11UXPLg60H+5Nmx849VLlQhuHuRxjj98bN0WQOpeKarp4huUr7q0SvzjejQfnoVJgE1SkKsWNh6TXngpban2LQfqV0lFQmlDjzq83tRAzz5A0NEVCTmG4o6LCaSN11BC5vhDHBOfCUY6cgtmsyOWfMocGiBqwz/PpXFymfbwdkfDfFkl3VGXXTBBFiMzhUGo8cacJP7h0+uHmgC21n1SsBENDBi1UTA8tFj+LeL7u4ZAQ3chRtXGqniCC69icvewxk4u7ViGWXirKiWQpx+GHbu03M+YTwLw3nANrToMhONbEwviz9PUL229aS5IFcvkjdsUZxXQ3zG/on/QHAeGh0vfZ4X2hI17nNR3kZ6Yz56HSRLWDG3yUOe5moGlG1mEbew6ph3EL0ITaxSqO0dVty32xHy+jvd+82J+117pJLU0YIZcf4CNrpgvR9FjWFDmZ454weHZ3WfKwi37blJMeBTanDjHUr5uZwDhDrmXHLkDtu60ntaLaA5jnrg8FpQNM4NtYaYJzgCVenxf8BfRgF8kVi5wOMcSPTQbaEDLTwvqlHz57esTiOwhp/9suhOhShkN2ys4AXGRSZwnSmcN3RRqynqm/xS3goFmqE9Kp7y5lYgS7epk6iMJqx5XI2I1DIaK7+JopLzjULzk21LnYcyjTwXrpFKMBtr5S6xry1RKauIgkAB+jiq1ldtgJVCJOWRU+8ULwu7RBY3yjhlXBjH+qpTjWuBj/xRRr+9Dxix+CBflGgrPa50XogTKfL6xm+OYyCeMrRHohQlT9UTKQ3rhLJpsajNmO5xGDTPj5TZDhNIgE7Gro56b63UuvxjU4a9eCgNK48exw9FUxaF7g8vRHZfGm9J2LACwutWZlHTMxwTJN9e2q3XuqWQA0rMoL5nuqpOZL89nAGoYSEWr2cMonBN7/IG3bDbOW
 QVy0Rptm
 ALw0DvJZ90nCLkcCyThkt0NUkIcJPrYlB1FCrNkV9Cwt4FwOQg56XCtgLq8/eWBzgYYC0zsPaAhDBzDpebuOWtYjzwuHUTpLiAVYbtcljPV76Ln/+TK2TRIhpcUuy1ewckuAkjw7Vm6qaFPq2G4TW3z0hnLKRJHlua6vT9Rsve9Ayn0SoXpfCFCUNnAXndpQy6zshxmBisvdzOORNsB1MB3Bjy/IbklL7NpQXxaOjWorXXYrf2wplBgm/+gEQp7YCuRw9DrI4mLNKmhTVLOyYCLRSygoEzGpWykQR/fQeaQzO+NUQ6Yc3V0xQ2BWZX4Qh5ynDmIm5Uj5luvb7fKKHZ7tbUCPKDA42kWtrfs2eLP9uYh2bySNDuurOYRZPZHg1ZFoXyr6nUDj7hUr7u2PozAkE/JhfSZ21qsTWcAopyu5UVmxsc5vjji4aG2qNjJuUY5J7wGsmHgROx7LwsejBIDGoT4juibX8h/nsC+/jr+4U/AyK35oop40E5nmO31fEny1Bsbr7APcSNmFS1vxIZQ79ZjrN0a9aZx2B1XoJjD1XOxagB2QcLATrd5ZBZ/YgX3QC5PGbqvp3v081w/ao1WvdE24vHQ6gePjgP08xASY5PGPLetvLVag6eWla0v6HrGbdoHTbVoParsmJsdVjJHuwG8YRAQYz1S4MoZB0MK41ehy3vij5pHW0Mro+i2iDFYbHIE5yz8z2yNcNH0zadPzlZtuNBcUuvYevR/FunnOnyJSKs02ZbOzmX9e30XpqoSUpY0ZTsM/8zjE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 14/08/2025 04:07, Yafang Shao wrote:
> On Wed, Aug 13, 2025 at 9:57 PM Usama Arif <usamaarif642@gmail.com> wrote:
>>
>> From: David Hildenbrand <david@redhat.com>
>>
>> When determining which THP orders are eligible for a VMA mapping,
>> we have previously specified tva_flags, however it turns out it is
>> really not necessary to treat these as flags.
>>
>> Rather, we distinguish between distinct modes.
>>
>> The only case where we previously combined flags was with
>> TVA_ENFORCE_SYSFS, but we can avoid this by observing that this
>> is the default, except for MADV_COLLAPSE or an edge cases in
>> collapse_pte_mapped_thp() and hugepage_vma_revalidate(), and
>> adding a mode specifically for this case - TVA_FORCED_COLLAPSE.
>>
>> We have:
>> * smaps handling for showing "THPeligible"
>> * Pagefault handling
>> * khugepaged handling
>> * Forced collapse handling: primarily MADV_COLLAPSE, but also for
>>   an edge case in collapse_pte_mapped_thp()
>>
>> Disregarding the edge cases, we only want to ignore sysfs settings only
>> when we are forcing a collapse through MADV_COLLAPSE, otherwise we
>> want to enforce it, hence this patch does the following flag to enum
>> conversions:
>>
>> * TVA_SMAPS | TVA_ENFORCE_SYSFS -> TVA_SMAPS
>> * TVA_IN_PF | TVA_ENFORCE_SYSFS -> TVA_PAGEFAULT
>> * TVA_ENFORCE_SYSFS             -> TVA_KHUGEPAGED
>> * 0                             -> TVA_FORCED_COLLAPSE
>>
>> With this change, we immediately know if we are in the forced collapse
>> case, which will be valuable next.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> Acked-by: Usama Arif <usamaarif642@gmail.com>
>> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
> Acked-by: Yafang Shao <laoar.shao@gmail.com>
> 
> Hello Usama,
> 
> This change is also required by my BPF-based THP order selection
> series [0]. Since this patch appears to be independent of the series,
> could we merge it first into mm-new or mm-everything if the series
> itself won't be merged shortly?
> 
> Link: https://lwn.net/Articles/1031829/ [0]
> 

Thanks for reviewing!

All of the patches in the series have several acks/reviews. Only a small change
might be required in selftest, so hopefully the next revision is the last one.

Andrew - would it be ok to start including this entire series in the mm-new now?

Thanks!


