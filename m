Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE995C98318
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 00:35:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 602B26B0088; Thu, 24 Sep 2026 20:35:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DA666B008A; Thu, 24 Sep 2026 20:35:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F0996B008C; Thu, 24 Sep 2026 20:35:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2AFF66B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:35:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB710C01AA
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 00:35:07 +0000 (UTC)
X-FDA: 85250415054.28.281DE19
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf20.hostedemail.com (Postfix) with ESMTP id DE6751C0004
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 00:35:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VkTOCBrX;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790296506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hT0C0mvf6r5FuTfZclgfx4VcRqH28SXA1w/+lQNjyOc=;
	b=FmkaM5Lp/bxL+NZzHGnu40L9RldrtFN6UxCX63eR02jFqRoLGyZZrRcm7xdEJjUccQYY3x
	7JEl/nbEmQgBk+ofB5KXjSjOFJId0Jww/g3UgOlfjADvUXYlbtCNQu3qT/4ewRYA9IRJCG
	kgB+myeGQWDlTRhMPrMWlDbHXyIYF0I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VkTOCBrX;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790296506;
	b=VBpC56aFNM2VKzwvBvItfldDRBdJTyVB/nCu7mj38ctPU8iaO7640XmAwVBpDrg2HfviT2
	D66lkwkvapQlPGRKpwvEbpuNSPWi6DPdTqrQz+AZb4gt0L183t4qxPVzU09CE14w5XfxWa
	nlkHaYvOp/m0Z/aIXAgpzi0z2U++EMU=
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfe60d5fso2064506d6.1
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790296505; x=1790901305; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hT0C0mvf6r5FuTfZclgfx4VcRqH28SXA1w/+lQNjyOc=;
        b=VkTOCBrXy90mVvhhkX1ydZsUMYjKUS7SETPkfi+/2j+gqgc6YtjFiNapOVXzQtsKiV
         tXXSSLKvOU28QFaKBkmcRc8KwTV8la2oEVX5DOp7+8XU03iV7brNr2tJsiRaDCcGBltm
         CAeDwbkxP3ULpk1I0ZKj8YAT8VvEtFa+Wq8126mkdJqOAfXpUH1Ji9kS78yAENlnhRY7
         irXj1kf8aVEPEmQXzLNru3A3HZh7J7+F707Ds6Em1mJTDDWlfUDEbdJ6PD+zbNCbExQu
         2g6U7eblTuqZTx5D3M6bupYC7Uclr42NIy/pac3D4P0HU9Rx6RPfE2D5U/T5PlLJOhg4
         gPLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790296505; x=1790901305;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hT0C0mvf6r5FuTfZclgfx4VcRqH28SXA1w/+lQNjyOc=;
        b=IoOUkFdbvW06FwRL8ORoKRfFwyPmO3rClKip+dn5oxXJHi6nIJilKlHKfi+ev/R+SO
         97SShVeRoD+UR8X20xkuyYl3mFxb7Mm0NimVOpWmOQIQADHsUWCAIqE/ZWN4S4kK85hs
         qG0UiHXJIpAHC9QyYwA2ZdD3YFOaAochB1T45vV6PaBHHWKKZNaed2QSLtcDXmlC97bJ
         wPI3AXynrLa0LVn3rS5rM1wfFUTZlmZNuW+Q6GvXbvvljpJR1KqIBAUWifu2tEOE0asv
         AlloqF2ZniuIU28/gKpCvVejO6buDlTCO/HYYME6IaWOmshGzvLh/rQNuYq3FgbSFiGI
         ZiOA==
X-Gm-Message-State: AFuF++mlXGBJqHW4a5DP8QtFdmnoKXg74t0QL/Z2tGgGPwPeqKXx593l
	Md4I8rF9MmUT92NOpIv6bUbMGu8RoLxCmgIZxR8xgKnRfMqtTn2gEK8zKK9GCXgVRxM=
X-Gm-Gg: AYBFou0GW2VXWovien3Mr7+24ywntWgLrsoJJDX+fjXCg52RZ9L0aWa9bsJB/Cb9Ucr
	5sOMb/8jflVX70ugLKRYnwrStgVNiwEvdjvp0UUKn/6QLDKAxTTxCVuCzTL90xrSIMIzmIJ5yLs
	2bBXaRr0cZcO9znvKcvML/OjhYV8G3wG3npFcCslM+/dUMp0R81BH5yq3b8bjD92NHGfsUQmOyh
	v6uZNsuKrkTv7wMKOrND7NOwnjiD7xtR1P4D9nKjLU7Yyacs8lQV+OhQSdex73cLRqgS1DIRk4G
	4XAD9E9zmn18rc9B73Ktxf82d7W1FHqCZGZC59bHKTeDIBr3UiXnhA9IWWqhGDn7ULmoxnJ15aV
	w/oADE9Zd/FZHcSq0zeuEu4U03CZpQfor8BcylHwGnYJffW6jXrdI+H6yU3raNrvAdE6mLdRVS/
	djVMZXtVLyQXUGymicGqaaz8XTDQEfOrg9Oo/5Wpn5IG8pg9z6xr5MyAwUaDVBIRMHuYne9Axq2
	i0KI0MAJS9orPcQ4DeSyGYvXQfmYzlpCRf9pRm5e78JT2N8x1I2fwA=
X-Received: by 2002:a05:6214:5910:b0:912:bd1:49f5 with SMTP id 6a1803df08f44-9142f681cf9mr18652786d6.10.1790296504108;
        Thu, 24 Sep 2026 17:35:04 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91430e87fa4sm5357886d6.41.2026.09.24.17.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 17:35:03 -0700 (PDT)
Date: Thu, 24 Sep 2026 20:35:01 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, kprateek.nayak@amd.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, 
	hannes@cmpxchg.org, shy828301@gmail.com, raghavendra.kt@amd.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH v3 3/7] sched/numa: scan read-only file mappings in
 tiering mode
Message-ID: <arXBari1QNJ-aIW8@gourry-fedora-PF4VCD3F>
References: <20260922182928.2199090-1-gourry@gourry.net>
 <20260922182928.2199090-4-gourry@gourry.net>
 <c73021d4-60c8-4446-9c08-f9d7807a3a0f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c73021d4-60c8-4446-9c08-f9d7807a3a0f@kernel.org>
X-Stat-Signature: tauamemde99d7qm7p8gtzhr7oeiw5zqs
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DE6751C0004
X-HE-Tag: 1790296505-37331
X-HE-Meta: U2FsdGVkX18Ppu6AiB6otO5ebkvycP5FlpQ9qd/PM+hIGplLuPy8Xyz0z0rOpcwJQOAOJFBY8iaJ5ZmZsjGj0eBL3vyRUmUiuw+yEL2KkdD7E5jmn8Kpvyj9vD4TPHUtLkuZx9YGNwB5POSDHs5jW1a1DHCKVJFdGXIsX+kraVf2Pa0AsmfzDljPOMc9ZTz2/xbQJ6uYRU75QOJNf3Dw8giet/Q0gp+tJpd2Q18+jm2BG+7cf8vlnENaCQxpZ0efLhA7GfAAzyOUVrludS3vokDX8jgR4tCWnQruWt2bIDBDgClDb10Kf+ctZScQaXOyFMvSFbpyg4jGrhTv5UPYp9j9F+oPO/gKQ/3FtHhSJQTnsWtnq92Wdcww2yU0zZKhVachQ52WU99w6jYBMacJgZWMi8wH1qUAHWRDQFrIsVGG3eoNYJJKuvo0jUKFKHHwF2jWQJ1DDpCUe1dyp71hTYDPRR3TPIOseyjYO1lmTBociLVvTtFfRCxup4RHFivvYIeukF42Ybx62gx8XObWHl1veAziOkeJ4RaKnr5KtD4o9SvzXDTC53CAbdZVVm1UwGBdqJpR+v7nHHIP+fyU68utsR59HlE36NmjIBpfbBpbAMiCkPMaBDI4ZVNVb5/hneP+OdnzUWmNc4jySCixfCX8k2DvziSCqrvgl9kyOWjBQBjO2WiYlabQ1ZINc4Hyfp4PnPrKckOkhOlzD+ETL+2thwt/i1fKbLr9aW09iKhqK/XqWht2KO002LQh3ysWOgL4C1Fzb08LiJYcPjm35piVJ2GrkNbUSOj2NSDZ+fcwoT5DDgWZEr/TGwt6w7/ut3xk29B+xcil94QqWTuWr0uovA6aPK+z5D2Cdd9x56zFIqmlemXE9ZsOZNCGEkExxVbS66FQxrS3DA+ZiP0CsEEKrIIn/fgg9p1iSP+WlLWD2xDnFnoZjgc9T1ifjFUgHGO7KByJ8C2846M4SNC
 xnK3Fk0q
 g8eDcHaM+oo2Zvd8UymFff9/QIl+I0PPAEA8XeHPg1lz833uXhhF3sP8881iYdsohPX8yYayioDt78ZdGbZaAUw8Aoy/mYNfVBMd31WB3XQO8zIDXVn9Z/y3i3fpH+GOGZ9wOFW7+3DnMYtbSdKDCNyujhvdcx5BDnwlM2a8fKWeBv+FnP/0n2LQZDA5ptartTShJt3Aen0G4OF9DP5RrzkUHke0xt3dnqUXhS/yFaBSuZ6NVbPgLXVtw0/yx5oXqZM+rXqr16JZt5vwpVN38WtijvgBOK7MB7b5rwtlp2zsgedxDzO74ojCeHYcRMkuDUXzaAhkAnXa1ri4graDQqWPMpjvVe7ThEoXO+KySElNmaJNZwTzOBnpcOt51fkDj2UpMHGfRUWInMqPquWTXd2mG5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 10:53:56PM +0200, David Hildenbrand (Arm) wrote:
> > +		placement_scan &= numab_mode & NUMA_BALANCING_NORMAL;
> 
> Do we have to update placement_scan at all?

in the following commits this composes:

	placement_scan &= numab_mode & NUMA_BALANCING_NORMAL;
	if (scan_started)
		placement_scan &= vma->numab_state->placement_scan;
	else if (tiering)
		placement_scan &= placement_due;

But i'll think about this when I update the function name.

> 
> Can't we do:
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 8a4687f67d82f..fc8862ee31442 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4121,6 +4121,7 @@ static void task_numa_work(struct callback_head *work)
>  {
>         const unsigned int numab_mode = READ_ONCE(sysctl_numa_balancing_mode);
>         const bool tiering = numab_mode & NUMA_BALANCING_MEMORY_TIERING;
> +       const bool balancing = numab_mode & NUMA_BALANCING_NORMAL;
>         unsigned long migrate, next_scan, now = jiffies;
>         struct task_struct *p = current;
>         struct mm_struct *mm = p->mm;
> @@ -4313,9 +4314,8 @@ static void task_numa_work(struct callback_head *work)
>                         continue;
>                 }
> 
> -               placement_scan &= numab_mode & NUMA_BALANCING_NORMAL;
>                 cp_flags = MM_CP_PROT_NUMA;
> -               if (!placement_scan)
> +               if (!placement_scan || !balancing)
>                         cp_flags |= MM_CP_PROT_NUMA_PROMO_ONLY;
> 
>                 do {
> 
> (maybe I messed up my boolean algreba, it's late)
> 
> -- 
> Cheers,
> 
> David
> 

