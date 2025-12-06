Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12490D3B7DB
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 19:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 216286B0005; Sat,  6 Dec 2025 14:53:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C76E6B0006; Sat,  6 Dec 2025 14:53:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B6B36B0008; Sat,  6 Dec 2025 14:53:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E4F9C6B0005
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 14:53:24 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7C31DC0661
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 19:53:24 +0000 (UTC)
X-FDA: 84190095528.15.3394DD4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 163D8160015
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 19:53:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=deD02HSm;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of loberman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=loberman@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765050802; a=rsa-sha256;
	cv=none;
	b=IjHTohuuk1n3WoR1eivjX8T7iU2ddTT2CDpjliQ1N4/3lnx94jRun2N5Qu8HVTJ/HVFfkm
	Y5yG8psd/H4fR6TU0vLvX/HRq4KfKs4rTP+LjU+IwnMvGD0HIRDRLo7TSgqqRwyhUBosYm
	Nn6sDzw8LjQeVCF5OXYuzbV+MfdEcws=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=deD02HSm;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of loberman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=loberman@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765050802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qrpYMWO98nw/C1zuKpSbDBvFxM74soYI7+nWen4/2Ko=;
	b=UdZugc0Um/j2VD4fXtimbioEfUIQMkCmxlI5+T92wpc+Dmu/u+I4mQogcGdIijxEA8QGYl
	qBZRc+uL6jhhvRQIlun5HYxiUhmFgPrARpyCGbSz/dItYGYsxSO0e/Ng0cThWsfV9DL0Uh
	u3hx0jxdVTaX25iOdGLcsboeld5TZ1w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765050801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qrpYMWO98nw/C1zuKpSbDBvFxM74soYI7+nWen4/2Ko=;
	b=deD02HSmUuYFJ0K1UyifIlayx/fOBwMNMXKqujlg93eNfBGEG8ZfO2KCVGD8lIw7pRoHpA
	MbU+7I7cj/sh36fbCKnr3GFJEMJWzQ36we6GUiyf4JykDwa/pcPtg9oc4vVASyMKTr5ZJQ
	nbG+DnVeWWURBYBo2ML25RW9hCsEuhw=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-192-VwcsFthGNWSPDI3PVQwaBA-1; Sat, 06 Dec 2025 14:53:18 -0500
X-MC-Unique: VwcsFthGNWSPDI3PVQwaBA-1
X-Mimecast-MFC-AGG-ID: VwcsFthGNWSPDI3PVQwaBA_1765050797
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-7b89ee2c1a4so5644745b3a.2
        for <linux-mm@kvack.org>; Sat, 06 Dec 2025 11:53:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765050797; x=1765655597;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qrpYMWO98nw/C1zuKpSbDBvFxM74soYI7+nWen4/2Ko=;
        b=QL82FagRzB54VYcgzn741xFOlMx9MQzlLWtZQBUoTlYH8vYDkUezb+WwlqqMyKchjt
         4T9ligoNRaCx7WVowEAtIofPu/RirF+OviNTh7CbQ9jFPB3cF+mfxu0tHshs4vqW9DsO
         BfRmYjGb0xBGsLikrYi5EYDIUpisNIPX1l8I4apZyfgby8QdsGETN/oYk7JPfK2nd8Pi
         Y4PToFaLNqCY7DNj9J0f45x54GsGdYwpv4AuRMJK5qgnH77qDzWu0tcMIUWpSrq0iBzu
         fuUS9Ey7sDwkaJreDGPunrc8cbhaXgYAZrAdsNJCXchJK0l1ss2WIlJacd7pFM2Y5TS6
         6VRA==
X-Forwarded-Encrypted: i=1; AJvYcCXNAoVBaCTLrtMYzJZAINIlIFfrb5Bo9C9PqRGHTBHO1UjXHcyPLPZkdKVLoAdXwPx/GxO133P88A==@kvack.org
X-Gm-Message-State: AOJu0YxnBTVTF5G039vtM9iFBsO/fIvbMByCVg56FqX5WVXGL1r7IeNl
	0E9U+dxnYA9AMnYtbPTSAFluuO4zSq4GhkqZ54fv1Rrh/i0AJ6n1qkJbs179RcbMpqqn1W/bqpG
	klkq8Npr9bocJtOspWtyBz3xKH0/bXiWC9SGemLiTcAH7d10LqbmI
X-Gm-Gg: ASbGncszk0oPQmqjvwX7IHVffM0ge0PipPqvuTxt+B2JmzhtQfat/WQGQ4IAZ5aaoE1
	reqMeWP0YjldAzaGHES9eLMCQow3NJgNr5HrnvxJma+xoMO6FQtd/9paCpx1ARIFUbmOXoPH+rY
	Om1yN9k2xl3Emb9by+lXFsm8paiyxGRJ+4i8Dh5J4yniYZMDny5/yT2RvwPbNDC14O640xkeOkb
	vxTFrYXNi3WgjoOmgUoKHrHgrNchl/1yjnY472B8y4f+sayD5+e8YWge1oM2X55pa0kCCo0mkCa
	7sgxFvFFBgAubpWF7JHrqDs4NKk8ZpT8GDdoSIXsu2kWD+hxs1vlvp25e09rNoyun+Q07F51aX6
	9S3xzbzUvDHkqWaGMXNxeka1JqWnaH4dbLANO0Xhz21PO035k7ag4UX3OftRHawGiA3XYk7ILau
	OyRBE=
X-Received: by 2002:a05:7023:b01:b0:11b:d4a8:d24d with SMTP id a92af1059eb24-11e03260ecamr2282830c88.12.1765050796770;
        Sat, 06 Dec 2025 11:53:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH2aPGE6vYb1dltrITpg8eumtVfZJj4Id5GKymqQwmguys9MRcgGbHoYX1yIz3YPyGVGfbLsw==
X-Received: by 2002:a05:7023:b01:b0:11b:d4a8:d24d with SMTP id a92af1059eb24-11e03260ecamr2282813c88.12.1765050796257;
        Sat, 06 Dec 2025 11:53:16 -0800 (PST)
Received: from syn-2600-6c64-4e7f-603b-9b92-b2ac-3267-27e9.biz6.spectrum.com ([2600:6c64:4e7f:603b:9b92:b2ac:3267:27e9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df7703bd7sm35128784c88.10.2025.12.06.11.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Dec 2025 11:53:15 -0800 (PST)
Message-ID: <6640379f1ef7e9305b77d1e322b04d9534a3fff5.camel@redhat.com>
Subject: Re: [PATCH v1 0/4] mm/hugetlb: fixes for PMD table sharing (incl.
 using mmu_gather)
From: Laurence Oberman <loberman@redhat.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-mm@kvack.org, Will Deacon
 <will@kernel.org>,  "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>,  Peter
 Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>, Muchun Song
 <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Rik van Riel
 <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, Prakash Sangappa
 <prakash.sangappa@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
Date: Sat, 06 Dec 2025 14:53:02 -0500
In-Reply-To: <20251205213558.2980480-1-david@kernel.org>
References: <20251205213558.2980480-1-david@kernel.org>
User-Agent: Evolution 3.40.4 (3.40.4-11.el9_6.1)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1WuJf6EPsToq5o5Ev1Ej-_MLdpRNWmRoJR7bMDnsQQ8_1765050797
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 163D8160015
X-Stat-Signature: y9sme944wekz88bqwwmf89sx1bo545mi
X-Rspam-User: 
X-HE-Tag: 1765050801-606344
X-HE-Meta: U2FsdGVkX1/PE4A/HVzDrhoPW6Sa/4MtOiPyffti48JurR+Lz0Sh7TmCGpq5fT9Lr6C7azQpLkaPx34WaAzbi4jgCruKw7NzZBcwbXcAfEgbQAwJzT4tUuBWPqL+jfN8Cj+2SRSAiAclU8Lzx6Donn0eZ1YrSjkrh4zF/ZLoohhTEcUJhzNqUIZhyvDBoYxFCvTCDANP9xhimIOsUyK1CrL7n00e5ecjLZMCyFbEQKSNS8qevD0SAIZsZ2Tqi7ZVdqSy+Jy/i3BCE+P3yQovn7vAEn7GDPGgqRKXAYGMK1S5n11j/XuugJBPIUoUxTkAdhZsKrvSP69+7LV7y+POFNwNgEgI1Jxhwme9cI2XVYwOmXo25G0fRqWao71tqo9uErtTqvGFqoto0rj79De9f0wbZAEya55DNhM9aRzOoDNgPEJ0YEYolt59XmzMwIAq2XK2mKn6ucsLODV5sDflejqER5YDE77yiy6Auz8wIrD2gCJdkThev2f+anTrd6tXpItd++P9O+qKr9MEQ8ILmZYcGs8dunF+oKlqhWBifW0h9S0sxxV2+9mS8a8X28RDh3IHJgevxSsfCdPMS8agFIhgfbFmxjnQJx5RKV/tWRpNkO6WaEmtlnFYBLAhEjG6g24EACLZK5Ijmfkodv1hL8kkANX8aHYzlVj6OZPfIrfhJSR3tRuvbun3/HkQKNSDEwS8x6RFnUpFzsr6XomQnh+ZuS9+nTQLTnL2SVcMPQhDOWH5ZARC9IIzUAxJBsVF7CoGo8gwb2bf3X+nlSg4qC0QQeab6gWJ/ysygUap1t3LzzGb/rhuOLs8H7Cz98BgwVUIiEF9s3iBd6kiPzUDQce4UCwav8UDt2KK7dye1wmo/HzBADWdtq4AS9wfJ4FiFCqKMKBcr7EhpTCcRYfGOzSqLA4AsETrk/vP4VmEaskoWKxh+0tLi4jOLWjJ/go9AEE6tTuZkAp6MMRZRJc
 IIPKzDqD
 nOuW+aj4upVndrkNyVNlUUq3girAFlJwY5+uM+t7Yod+omAjkci39IfauPQW4+v6Q5iVohlLxU+Qkwo1ugq2WpBxhyWBdLq7tdfkst02tEetzXV0L8csZ84+k2uIFCohcejHA922De/fxd7Ycct8mM95tBZBiZjKt7VH5LCbJBa0TMyP3e4XBko2JLThzF+FQTeE8me2+XAHAZqC1I8Ng3Dnp6cyTxH5trBFnDKanTLSUfo2EwjPuwhV860IQtIUEbwO2A5pEBjt9l4Ne70/k5/Z4zG8o6eJwOdJRfy5Q5kYYHbNxZhYd4A7UaDuYLC1cq79Q5IWJVmGUcJ1I28myIzfl15NmkicGgCS2GkLsspJl+am4tT+tCOWMh8uT+D9vscveXHKDYkLRSfrCmgTuRtF7fxQeQ9H/umOJFxkPv9Fc8J+q5yFRqCG4fphO9YHzvpgo7g8bqPfnBL4wds+5H63StIb70G1Y3LyBagixu8QFocTYtIZXAwrfkXaSChXkAeTf5gk6EeXcHpkNrvUrlMwZ0p43pd8I51dKmVYFxoWmnOhk4c7kSeg2Ah8IyBAFMv3Wu1Iq52kuKXlEh7U1foR231efD5TG04vERZk24e84FyNKy3O7mpf3QF8VLkHfNSZWrZO45ZVck7DUEW+sROP2HEAAM3ihYJBTKP6qexIGlBmgLNNqrJmLCjhQpy0iJjxhhX6tuBgmOCLyRMx3Q6ZEEaq/6xIoDfTJHgZ7SNdJc8W/EQnTzBHHkyp6trEcok0SgNlTPo8N82CILMiSIxSTjXQ0HjEc/mDnqdD+uTyWwg8CyTvq1cGJeD+0lXbrYYnDGG90/mAASPS54l2Qiczu18RdR9xRM4Dt0DJ++fwmQTmTgNOpie7TuFjZasEu3LYhp3QlJHtuSWd0ZVFxH8M5ymlWUBf1cnVK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2025-12-05 at 22:35 +0100, David Hildenbrand (Red Hat) wrote:
> One functional fix, one performance regression fix, and two related
> comment fixes.
> 
> I cleaned up my prototype I recently shared [1] for the performance
> fix,
> deferring most of the cleanups I had in the prototype to a later
> point.
> While doing that I identified the other things.
> 
> The goal of this patch set is to be backported to stable trees
> "fairly"
> easily. At least patch #1 and #4.
> 
> Patch #1 fixes hugetlb_pmd_shared() not detecting any sharing
> Patch #2 + #3 are simple comment fixes that patch #4 interacts with.
> Patch #4 is a fix for the reported performance regression due to
> excessive
> IPI broadcasts during fork()+exit().
> 
> The last patch is all about TLB flushes, IPIs and mmu_gather.
> Read: complicated
> 
> I added as much comments + description that I possibly could, and I
> am
> hoping for review from Jann.
> 
> There are plenty of cleanups in the future to be had + one reasonable
> optimization on x86. But that's all out of scope for this series.
> 
> Compile tested on plenty of architectures.
> 
> Runtime tested, with a focus on fixing the performance regression
> using
> the original reproducer [2] on x86.
> 
> I'm still busy with more testing (making sure that my TLB flushing
> changes
> are good), but sending this out already so people can test and review
> while I am soon heading for LPC.
> 
> [1]
> https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org/
> [2]
> https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org/
> 
> Cc: Will Deacon <will@kernel.org>
> Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Nick Piggin <npiggin@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Jann Horn <jannh@google.com>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Cc: Rik van Riel <riel@surriel.com>
> Cc: Harry Yoo <harry.yoo@oracle.com>
> Cc: Uschakow, Stanislav" <suschako@amazon.de>
> Cc: Laurence Oberman <loberman@redhat.com>
> Cc: Prakash Sangappa <prakash.sangappa@oracle.com>
> Cc: Nadav Amit <nadav.amit@gmail.com>
> 
> David Hildenbrand (Red Hat) (4):
>   mm/hugetlb: fix hugetlb_pmd_shared()
>   mm/hugetlb: fix two comments related to huge_pmd_unshare()
>   mm/rmap: fix two comments related to huge_pmd_unshare()
>   mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables
>     using mmu_gather
> 
>  include/asm-generic/tlb.h |  69 +++++++++++++++++++-
>  include/linux/hugetlb.h   |  21 ++++---
>  mm/hugetlb.c              | 129 ++++++++++++++++++++----------------
> --
>  mm/mmu_gather.c           |   6 ++
>  mm/mprotect.c             |   2 +-
>  mm/rmap.c                 |  45 +++++++------
>  6 files changed, 178 insertions(+), 94 deletions(-)
> 

For the Series passed generic testing with a focus on the CVE
regression and looks good.

Tested-by: Laurence Oberman <loberman@redhat.com>



