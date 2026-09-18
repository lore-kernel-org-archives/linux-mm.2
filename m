Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FD27C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CBC86B0093; Fri, 18 Sep 2026 09:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67C786B0095; Fri, 18 Sep 2026 09:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56B456B0096; Fri, 18 Sep 2026 09:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E1686B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:47:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B126380332
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:47:03 +0000 (UTC)
X-FDA: 85227009126.05.F054B53
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf18.hostedemail.com (Postfix) with ESMTP id D573A1C0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:47:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WXz4IdPf;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789739221;
	b=hm7vEZ5VMtqizEkJOJlcLntOHQmSlCN64kGpiZxZO0s96q8vFaPRKr/SgVATQ1GE/ymH6t
	pC8NeuHq3K7HxfpKW1BM9FkrRLGVFFwFhBaCQGA/Tj0Ky3b+fiZt14uueETZn57t+6Klx0
	fwrxG/fhVQAS7KF/sm6nflWubwSJfuE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WXz4IdPf;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789739221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pC80FFx3P+R/wVH2EKfilVtA17zP1wc/C+ZmKYlpplI=;
	b=VU9JuSrRRER9ZCTi0ng6gGznMdGebMCZaaf5CI+sw6+fjxiwNvKRo0QM9f2x6r6gE1zdli
	tZun1uVAYeCd2apPv0pGRpMV/r/64yokj6yqiW1bUkfPpuiP/lKCSXxxp/bGxVwc9DhpiL
	S09OJ6PvUseLXus+6D5JpnZ0YdVjTKY=
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-939109f067fso97808385a.2
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789739221; x=1790344021; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pC80FFx3P+R/wVH2EKfilVtA17zP1wc/C+ZmKYlpplI=;
        b=WXz4IdPfcIkTDKogdHPAaaHoYnGn63qpWPF7S9MreueJPCOwhHWM++2d3o29O1moFf
         5sExo+4LuDHKy33gVr2/QJgU+fkATrcu8OvdObR9ZYmgomVaLLqMTxqdWdGGVLMFs0xS
         d8MTZ2Bnk1Uyq5QSW3BeA0PgMEFAS7oQRaNhaNdwWl94Cm9OjwF/cn6LRDrsSDQY/j6s
         DyJk/Spe+DGF1LQrAJ8qqahx+SJEZ7QzYCR2tO7Qeg1+bV7B0ts58SxP7juI2XXgS3wS
         LaUJeiWHPg7nRp0v6sHUr5jwBPv17g8lETZ4rQqhwvr2Wwor9GHL17I9faHG6th1h6kl
         aKzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789739221; x=1790344021;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pC80FFx3P+R/wVH2EKfilVtA17zP1wc/C+ZmKYlpplI=;
        b=ypRmGvJ4QBXnzFTsfrttwNvxa3N2znVUTEOS6tOZxqupxb3xzzS7DUDaXfavkCq58q
         B7dTvsTPGwugTuB02qpSwMGxl2p688apFq6twfL/aD+dU96ecWINYw3kZnyivEi8Ve6F
         useZNNTHKMYTJGi1psaFXwzOWCmg2RboQNBXm+AjVXE4bvdUIs7UNUwQY5MXsmp9qkxa
         f8icoJyXsTAILKwAPbokrDZ73ecWZUKfLclYzwZqVyJKA3lVD5SR/ubRFVpH/nIwQmJB
         HluesuVLkEJqHhB2BBTPWMCQNIinVLWVgcPIu5NXsM/2WaC1U2k5hrgB2NCLTYJaDTnD
         KbJQ==
X-Gm-Message-State: AFuF++kfRXaRGo9UogjLsiwDt30jtMvHpGUEsk9Stw1FvE3kvA36dL3r
	tTLbAuTNvnJXHbVmGdW1A9gcVLXffmZT874auC3OfTv54H67muZDzwY5Md+zQBrKR7w=
X-Gm-Gg: AYBFou1XA23TWU55hrNC60UumFMLsM+ww6ZWZtG3BnhN25iwIcuSf50FgNLfOWqtdLi
	zPfqB8YGP99YEvpDz9Ab1EP3cJS/Gn08BN/v9RmNWVW3xPtBqT49IF9jkPgK6Ev2Q5sHB6eEYLG
	e4pthO68fYgNXr/CiJPEWn4VPEVi/vFAZiaZ6AGYeei/PSbfUUK/s6Bp+qlr68aWQgewiwUbt5v
	6TQzl8+BijkTfXMspAe7CwbglYj7fabiIqBaVDNct2d/WTBCptKwf8FOA2nUI8AI9p3WBy7kZm6
	V5uHzSF1Tt3Ms3YDblRpMO99oQJUAvLI3kxyCQlpBTCWOjYtsQ/qmo/YXTiWTVUx9nqeeH+/QD/
	w1jeNY1M4m3nZ5JAVHqIU8np+jrZkSWMxU0TkfKnq+GXM7clOywoHkNip8wkAgHYJBjVBD8/3k2
	lqORNCnk0q2OCshr+2yiGZkilSkT64Pl9fLM707tNiGz1sS0PFsE9QrOoQISr8+kYqU6vhhwAs9
	9baYznhWjr5Tzka2gD10ErCW8XcbE7QKgE6Yoef85v2BdOknWUAVlI=
X-Received: by 2002:a05:620a:1b99:b0:939:7835:8f87 with SMTP id af79cd13be357-93bdc6a6dacmr356633385a.17.1789739220927;
        Fri, 18 Sep 2026 06:47:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93be0e9e752sm144316085a.22.2026.09.18.06.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 06:47:00 -0700 (PDT)
Date: Fri, 18 Sep 2026 09:46:58 -0400
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
	osalvador@suse.de, hannes@cmpxchg.org, raghavendra.kt@amd.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm: support promotion-only NUMA hinting scans
Message-ID: <aq08OIJ5mCnDVIfs@gourry-fedora-PF4VCD3F>
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260911001826.2109390-2-gourry@gourry.net>
 <9b5e1573-6fd8-48a5-a274-a6e7ff83d2fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b5e1573-6fd8-48a5-a274-a6e7ff83d2fe@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D573A1C0002
X-Stat-Signature: sx4xck1h3ygwj5tzamzaenfucdebarqh
X-HE-Tag: 1789739221-830598
X-HE-Meta: U2FsdGVkX1+0olBI8gKGFhGBccXLqn4JU9ZoCOq2hJrJ97hb5BieU0KBIKaE1UacpJ9UUy79Sn8Q7E8sB96ly147/20zjEihzj8MxXfFQacVSEYXUZz2bbEx2Zyg1XJn5z33WDPdPGtOjXNPr1FuvBMv0h7DXKR/nQCYyzDIwbDKFAdBvi+TrcMwxFDYJD6J3vl6cMcgHRvgcsSbgz+UXAoVwMceh6t3HDlJwiieNBZE5b+GheotxpGRZYpJl0ozcFRdXBJEVSf4Iho4G+etXa3OkyowBaVnXNK137Cwm5JuVH4XGwHRomRGizzh6pgi1W3FJ3mQ7uLnUumQ45uPqKnieOr4E+OWRcnRp20DzwZg6VQIY0GPndweI5scA5bDmFaiRoE98hz+1UyS1M9J+bQ6dUCF/vxyqxw7USQtuiMGRQdDjnv1aIEB6vz2n9mYgr8Gwqhzz19Lf9NcJeOLdWmIswl7mo8wy/e7UWaSIimv/UU3qQcPNtnWhWiZPWPfvLy0K92hm/fGXDGKFIqr0E/ySJcgmHRvVcJRfRTzDYXGOaS+N8jFX12wUar6ZOeiYLUT1tj7vgJt83QyYn6d1iVmckh7xLGe/Rby+LFjcn+obTSIZd8rHfYX0DWLOnASBZTHndwXoUCBjxGQprkWBQJvGQX06KLf1xzgS8InoBFtac+oCQmbW1CRwzCZql9qPifCZzqNeGAYArKTEIlY8yJYmJnQ6xKICwwZfNMO/c1kA4BNYalbjN0fpYQouF8CJekiqn3vSgvOgdgoqxjgrrT3+B4eE3SxlRzsK9EsJhKaCZ/PbLuWZttqmVo44hGBLdSnHLhHX0HLnRTSAjku955sJg3VU3It+TNM1LZd4dSOikExWf/liuonCrBbi83SLVgxnmCmLWt1ViwnEju+xAMPGVvu5Sj30nymMFXKw215e5BclPVdHq5IVlTZhP3jyaY5DBBrx7ZPf/8yFBa
 LedY5Ios
 tb881QHX0hJzVHBMikKmFAPF50wCtQ4fns15hIbREukvGgZBAbsl2IqkbJV3+eyjuN3PgdWCITBDWDCmCQO87qN4vjHzbA08XnWqj401VlhPFsCnWWYI2UV9DnqCKBD4oKR/v/kmpyk6Y5tW4YckF5AUWw/nbU7Xkqvgztm/8fVZB3B1tDpXWOs3rdiXl6dllmlfzUNVVO+KCH1J13q2YipWA9Zc23LdbUaYpRTOK3h7Y6ikVmSkgeqL7QcZW0kpslYQohd+/rfRKr3jETp7Uo392iNEfdxwLJtmTwG3DiSRIDVpNhLOv7pAEBQLdFHC3SPcO14CapWn7tVE+iHOVj/Sx8MtpHXp+2azadTU6XKRixYg85bGu3jO5Pru1UnpzdWXfCNc+W+QU/YfjGwaRarhTaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 02:37:52PM +0200, David Hildenbrand (Arm) wrote:
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 969594074fd2..2d1b59a27629 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -3408,6 +3408,8 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
> >  #define  MM_CP_UFFD_RWP_RESOLVE            (1UL << 5) /* resolve rwp */
> >  #define  MM_CP_UFFD_RWP_ALL                (MM_CP_UFFD_RWP | \
> >  					    MM_CP_UFFD_RWP_RESOLVE)
> > +/* Whether a MM_CP_PROT_NUMA change is for promotion only */
> > +#define  MM_CP_PROT_NUMA_PROMO_ONLY        (1UL << 6)
> 
> BTW, shouldn't we just be using BIT()?
>

I originally had a 5th patch to convert it, but i dropped it while
making multiple attempts to avoid a CP bit at all.

I can add it back to the end of the series if you like.

> > +		promo_only = !(numab_mode & NUMA_BALANCING_NORMAL);
> 
> bool promo_only = !(numab_mode & NUMA_BALANCING_NORMAL);
> 
> 
> and in the later patch
> 
> if (vma_is_ro_file(vma))
> 	promo_only = true;
> 
> ?

Yeah this is confusing, but it is correct.

1) If we're in the code at all, balancing was on at some point.

2) If !NORMAL - then TIERING must have been set - so always true
   (promo_only says: only PROT_NONE low-tier folios)

3) In (NORMAL | TIERING) mode.  promo_only = !NORMAL = false
   (so in numab=3 - we PROT_NONE top-tier folios)

4) But this causes socket-to-socket bouncing when (NORMAL) is set
   so we retain the "no R/O file" filter by checking it and setting
   the promo_only filter back it.

It is, decidedly, quite awful.

But the problem isn't the fix - the introduction of the R/O filter broke
TIERING first.  The problem is that these filters never took both modes
(NORMAL, TIERING) into account in the first place.  They optimized for
NORMAL and broke TIERING.

> 
> Stupid question: why can't/shouldn't change_prot_numa() query
> sysctl_numa_balancing_mode? Why do we have to query this outside of the function
> and forward it?
> 

We need to calculate it anyway for patch #4 to track when the last full
vma scan occurred in numab=3 mode.

We certainly can, but then we calculate it twice in the stack and it can
change out from under us.  I didn't want to have to think about that
split-state problem, so I err'd on the side of calculate-once and do the
whole operation based on that state.

I'll need to pull up some investigation notes, but I also remember there
being a situation where checking it underneath this caused more scanning
work - didn't want to regress anyone. This might be resolved by patch #4.

> I mean, change_prot_numa() gets the vma and can query
> sysctl_numa_balancing_mode. Why not move that into the function and avoid the
> boolean parameter?
> 
> We do have a single change_prot_numa() caller in the tree ...
> 
> >  
> >  			/*
> >  			 * Try to scan sysctl_numa_balancing_size worth of
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 30b7c63b0e35..2f9ada1bbcfc 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -2784,7 +2784,8 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >  			goto unlock;
> >  
> >  		if (!folio_can_map_prot_numa(pmd_folio(*pmd), vma,
> > -					     vma_is_single_threaded_private(vma)))
> > +					     vma_is_single_threaded_private(vma),
> > +					     cp_flags & MM_CP_PROT_NUMA_PROMO_ONLY))
> 
> As raised, maybe just forward cp_flags
> 

Yeah fair, i'll do that and just add (or eliminate) the
single_threaded_private argument if possible.

~Gregory

