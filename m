Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 660AEEA4FCB
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 14:55:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 688226B0005; Mon, 23 Feb 2026 09:55:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65FDB6B0089; Mon, 23 Feb 2026 09:55:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 537A56B008A; Mon, 23 Feb 2026 09:55:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3EDFE6B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:55:10 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB38DB6B35
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:55:09 +0000 (UTC)
X-FDA: 84476019138.26.9F971A7
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0882A40003
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:55:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BLIT0Ngg;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771858508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qpjmdBXuQUotNZnT57UveTMGt/2pk8eLf+dmkyC2/50=;
	b=FlyHzCHoXs01uVaJYYQxO+UdoW/PBrxi5eWNKnVU9Vu8uj+9RlbseheUAPfoCk0zBE0O+n
	qnmjmFDBwj/nBwWBofH8VzOSvTaDyMC3Lu0g6yskJ+xIcE5TyTJ1XEmyetwzoWBdR8QS8w
	l6/oEcxZ+B9rqtlRTPvYkqUrpJ/0zwc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771858508; a=rsa-sha256;
	cv=none;
	b=fHiS4o4WtEAe15bZtuw/qm2Ej3z7Ox9ihk+R7z5lqESh99eAWs6vhRzMuys9xILojEee7J
	faCfEFqHU28RNTpTRWOgBrMNaPtLKgE6voW1j6W5ptf3G0lRySLK6GWx1BYbDt6B3stv24
	Ed6mgQddn/c2g0U0kJooKB2wyqwFC/s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BLIT0Ngg;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8cb40030be5so426507285a.3
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 06:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771858507; x=1772463307; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qpjmdBXuQUotNZnT57UveTMGt/2pk8eLf+dmkyC2/50=;
        b=BLIT0Nggc7hHHo2HJMXbXp+uo9J/5rE6oJEpkyhi/YwLrUa8+s0tpVaLGi+mo9pC+3
         +pnqC7gRHTycInmE0uFKrs7A9q3VU76RKXAHaNnNIdZ6ryQ+zDEp6sDiKYqh2K9o2Bg2
         5GSOBlch2uxpetM1nhAu7nMZbiaNyH2xnxvGmbGWX4yxYYLrvfINEjJiq8FnRGPR6z3t
         nJ7icZFJyHtjJZDWWqnBmoDddSjoIeo82XxfRztwuAETRZ3T2TALCxHHfP7tguXSgfT7
         dQVCzxwBWLkT8HcUA4Ji9eWn++c6MeI7dZ4bl+yQ56mT2YSkfTtnu3lDf2QiuJ61z/5A
         yfwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771858507; x=1772463307;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qpjmdBXuQUotNZnT57UveTMGt/2pk8eLf+dmkyC2/50=;
        b=dvRaG7I6y4DtX58cjTSpJyyndHwXsiGFco8tSJCk/PFwPKBW8eFsV7+YuQWTkFcbLo
         pFqBHmc+Sh1Qo1JNHOBsc8scTrST8Sx71IaOlhN4Hhbcjre2WNTALEPY59KbroaJAUN0
         MfcJlkR/tG409HFhmkVKR100MAkKU9vN4o8ruk4xpCRa9PakUsOnP7iJxt9loWWGWc0C
         +8bqQjFzU3jSvlxwAS51jCGBwr4hmWx8fa7USm4JjW0QFA7GbJn4jHJSFqmdz3mBMWyQ
         I1LsW2KSx58d+cJU+iJMcyrr8ps4pUuna7aWf/lSlDfxsPL44SGatCpDLwBSMSNMCmcM
         O6GQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUEcuU/ZoEHfqgmCNjWTVAkbme9dvJAPg1NYiWl6t/lKKMd2DebuV3fXgKLvvUUUJHiheUabAEWQ==@kvack.org
X-Gm-Message-State: AOJu0YxBElwxFkiU7eGMaP65ozIvDn4B9OaI08OCgN6OtmIQXq7g2AQo
	XxaSzSwrkQQ6+cIkoj4fGBpsNUTgwh4DJAA2CUq7KKr2KpHlGCEejUojcAiNAp1Szs4=
X-Gm-Gg: AZuq6aKZK1s48n/2zLBTnG5n4bZJIsFJiJVCtEHLikEVqBIYmlpISNJmgr02X9Dg0qp
	xbJ4qTEIDYMMUv8Ze+JOU12VRc62kqW7Pl66c9CdDuJPygke+GwJdlct9MLTjlzOn5tHMAfO0Un
	19ewzeGV/BWQYB28v07uSUUTKHuOYEUCNJVXZeMgtLEiWRv/aeyDScSVfj2Ya7OLE7jpa9Nz+6K
	Zp+MXlqktyc+RfCiOKjrSM4Rp7QlUKlyISGHoydB5j8Qv5pRRGa0AbEmgSYrGLIe2yFYDn9mg01
	D/tdTRjiIjyELjbWyjihj5KUDfnu76895xhSBb9LhHXlOQn5gS6lXsNNjHMW7O7GJyaoOU84AZ4
	tFki8psOwH/pFgTXu6ONsb0gumYwAuCSAfqrMbbyRZRgf0kgHn/K/NpLoUi36oWcE1SFmvhMgFs
	7vPp859osIsO17Uc3HamVh6CpdqP7qLjpjgu6ma54IbWHSB6ppYuZvbtLZGAXli8UYUlAihEXgE
	QEo1ArR5w==
X-Received: by 2002:a05:620a:1a18:b0:8cb:3288:6777 with SMTP id af79cd13be357-8cb8ca0e16fmr993255985a.28.1771858506861;
        Mon, 23 Feb 2026 06:55:06 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb8d0ebcd0sm845419885a.28.2026.02.23.06.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 06:55:06 -0800 (PST)
Date: Mon, 23 Feb 2026 09:54:55 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, osalvador@suse.de,
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk,
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, jackmanb@google.com,
	sj@kernel.org, baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <aZxqP7J1kOClQUPQ@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <c10400db-2259-4465-a07e-19d0691101a4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c10400db-2259-4465-a07e-19d0691101a4@kernel.org>
X-Rspamd-Server: rspam09
X-Stat-Signature: b59f8zfwimco4kt4uo668kftg7mb3x81
X-Rspamd-Queue-Id: 0882A40003
X-Rspam-User: 
X-HE-Tag: 1771858507-86532
X-HE-Meta: U2FsdGVkX1+3urH1eh1cataLc6RF3IsaZWqhvOiRv5/l9ySyryjOhlGhQfmVCBL97t03FkVEjomAbQbeDjgh1tQSIfqwDeD32daN9ax8ZLhBLVtc2nzUsvuZVl1QIYdZsZ0EGneDwmNfe752gMSliScYrc3h1kj4iDZNHO4biTojgYXLDct5RuB0VwHScLeRYF3WIrgyGhpFXe1ew4F5DwtfdDWcls2c3/ln4cQb5e6sMrnCQj8JBUVPJJFFpkfvYaywoPPbHLXpH+Bb/GghrlSZssthHXZyKn/Ooi9cRaT6rxXwyoIEyivazGeqLWekKahP3JoyLvCkDz2u98RRTaLOGlqvMKYkfjWQ4ySu9eu6v7TjxW6uXxF6f0Ft5mwC+uxlHFAxU/RVot/9C/UF+Fu5GBWz5AhHAFlmZtnaoSkGUbc2zgLyhJF7qF2vKkxYbf34PBWQSRwvo7vKZg3A7a4qBAEppBbMkkMO+d79Ri/xVlZlmlJ/Kw88gcxRYunjH1Ww12u2favGfzvkQWpuWorCBK4odB5a8mJRHHMiuvGmjrfH6d7TijNhQyAI3mRyWgzBm/Djb+lLiWyvLtGtRoefENqaPquxuck0ZmwqtY++8LfRI3wiS0FdPoyssdujDoelgejgXN/sk4awEDD5B6QX8u0TeUGnry+OmpgDK+dk5gto1jW0/wUqf8C1O6GL2vjDnajpvaHomfyedR4QONC8G7bQvgW7xrFJ6mdYXP2Jncc5fE0Vg1HVZmdhdyT6+CcBR5OuDNPXaNG7gmWX8ImMkMkgjOqWkcs8b6sGmP5pTSyVxjYkpn9XCQmkHrEgsvyxGR3Iawyupw/C0IJ4pplEkbsWcaJGFQ6DQmtrMlqUXqUEMFLQ399evfoafvspoC8Ra8mPq0uL4k1HhN0qZGbe4VRTMPyFvse8cFC6DOW//m3L3UCCfzdJUD/CY2YtKedWvmaH+YoJgk4c7Q7
 5gjIaDwh
 9pWdPF1mLpwMmbI+t7B6qx1uZbbJj3hnkP+hxpCqrAZ8GWYpbSsUajmv5QuTnjJ+QU3JBr8ShmzFk4mnFC/jUQacXZ3dVaVy5VQnB+IggH84QCQwnLvz1i7BurIBwu4qG1BTYrC7awHZve7uv/0zRyd5X9NDOuO0cgStO4XeWuwoqfEJQn4vsoQRZJ8NzrVRs1gePEsMBXlqERYT2dnjG0HRp2N3exf4wxnXNBgXGXSLdI9dmqNkf+TaqFRHmyjXH9eilxjdldaeXxrI4b08+6I45zir4YOzTl/Ke3v1FeRuB3q1DRH43fmt58rsdsL2oqWgq1MNu4nKv/C2yutVkmCgdybQGjkHqjr08iq6s8zTazFOEqE5noGSmteSGuFMQWe8At+p3d6UBk7f+h1zOzs391w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 02:07:15PM +0100, David Hildenbrand (Arm) wrote:
> > 
> > Gregory Price (27):
> >    numa: introduce N_MEMORY_PRIVATE node state
> >    mm,cpuset: gate allocations from N_MEMORY_PRIVATE behind __GFP_PRIVATE
> >    mm/page_alloc: add numa_zone_allowed() and wire it up
> >    mm/page_alloc: Add private node handling to build_zonelists
> >    mm: introduce folio_is_private_managed() unified predicate
> >    mm/mlock: skip mlock for managed-memory folios
> >    mm/madvise: skip madvise for managed-memory folios
> >    mm/ksm: skip KSM for managed-memory folios
> >    mm/khugepaged: skip private node folios when trying to collapse.
> >    mm/swap: add free_folio callback for folio release cleanup
> >    mm/huge_memory.c: add private node folio split notification callback
> >    mm/migrate: NP_OPS_MIGRATION - support private node user migration
> >    mm/mempolicy: NP_OPS_MEMPOLICY - support private node mempolicy
> >    mm/memory-tiers: NP_OPS_DEMOTION - support private node demotion
> >    mm/mprotect: NP_OPS_PROTECT_WRITE - gate PTE/PMD write-upgrades
> 
> I'm concerned about adding more special-casing (similar to what we already
> added for ZONE_DEVICE) all over the place.
> 
> Like the whole folio_managed_() stuff in mprotect.c
> 
> Having that said, sounds like a reasonable topic to discuss.
> 

It's a valid concern - and is why I tried to re-use as many of the
zone_device hooks as possible.  It does not seem zone_device has quite
the same semantics for a case like this, so I had to make something new.

DEVICE_COHERENT injects a temporary swap entry to allow the device to do
a large atomic operation - then the page table is restored and the CPU
is free to change entries as it pleases.

Another option would be to add the hook to vma_wants_writenotify()
instead of the page table code - and mask MM_CP_TRY_CHANGE_WRITABLE.

This would require adding a vma flag - or maybe a count of protected /
device pages.

int mprotect_fixup() {
    ...
    if (vma_wants_manual_pte_write_upgrade(vma))
        mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
}

bool vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
{
    if (vma->managed_wrprotect)
        return true;
}

That would localize the change in folio_managed_fixup_migration_pte() :

static inline pte_t folio_managed_fixup_migration_pte(struct page *new,
                                                      pte_t pte,
                                                      pte_t old_pte,
                                                      struct vm_area_struct *vma)
{
    ...
    } else if (folio_managed_wrprotect(page_folio(new))) {
        pte = pte_wrprotect(pte);
+       atomic_inc(&vma->managed_wrprotect);
    }
    return pte;
}

This would cover both the huge_memory.c and mprotect, and maybe that's
just generally cleaner? I can try that to see if it actually works.

~Gregory

