Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB309D4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 11:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9B246B0005; Sun, 18 Jan 2026 06:58:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A494D6B0089; Sun, 18 Jan 2026 06:58:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92A7B6B008A; Sun, 18 Jan 2026 06:58:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 82C5B6B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 06:58:48 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D3B4F59392
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 11:58:47 +0000 (UTC)
X-FDA: 84344937894.03.3B964BA
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	by imf29.hostedemail.com (Postfix) with ESMTP id EAAE2120004
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 11:58:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=rthH8fLr;
	spf=pass (imf29.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.67 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768737526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=AUS6KPBiAsk5Gc60fxXkLOLhxKKt9tw936tORAV/B3w=;
	b=WR55a8aI1H0ySu8/9fYJvprNhNcwXYD6rO0DItePnUL78PklsvFO/3LzUenqgt6B6R5KQG
	lnovEwzXjyMa0uOWT5QVBqP7cSAFNtCFOegDO9uKvAdCkmmtYoVkL1Nj00xise1rINwj2C
	d9UgjR41EdD5jrh95SV5GtVlZAaIULY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=rthH8fLr;
	spf=pass (imf29.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.67 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768737526; a=rsa-sha256;
	cv=none;
	b=Xz/RWVVXi4u05Gc/mccIwO0ZoNZuwUap6tLe/sgv1HItkoA4K0o56m0xzcf8YQwQbUm6HC
	JOZhGwWNmigYl8vtdVxSE/XMyLNavQ5/QNnzdrRS0nFnwVUl7/z7U0O6H+WSjLobo5rxOL
	3KqO0qArIj7Ch9XG/8OiuoYwX3dgUOQ=
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-47ee301a06aso30334975e9.0
        for <linux-mm@kvack.org>; Sun, 18 Jan 2026 03:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1768737524; x=1769342324; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AUS6KPBiAsk5Gc60fxXkLOLhxKKt9tw936tORAV/B3w=;
        b=rthH8fLr30L3NvJ+OHZz8s+di6gSYk1td58x1H3Rt4HvMCtNlPk+vCjk6wZcQFenx4
         fwdNEEg3QxPASrfymRQUJrDt8c5cLrAmkOBeGBGZ5GLjqrzcOtUm2H01hNe0MDCzTtQG
         bZ3/GMnxcGrOXlt+ax9w3SaFu5nS8ZdTn6ZzWeMnnhiVIAYQas777Ey2Et0tqD+x7iGW
         aqzqgCE6dlwIfoqfDn3nycP+SL0ly8VSbzHAWgnUl8xY910ZxHJXt0xUyxr9P4fDVniO
         C+MR5V0h1qc/c0LrRZRqSxBMsQcYeD5f74sg28e6B4JsGn0bMI2UcstHXEHk+3zpigOW
         J7Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768737524; x=1769342324;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AUS6KPBiAsk5Gc60fxXkLOLhxKKt9tw936tORAV/B3w=;
        b=mzoNzGnTJ0Nzwf7ZH0pPwqqw4WkEnN+c/79A5xHPbgMZ94mBhxy1hVrjgA2KPRXEuE
         Ik8TxMdV2qhL+vdoRbLqtxhABmgszx+/3wI5BRN0aKddvXhf5coJqsalk6lja5s0wxba
         uvcdbZtZoyw6dhmGWmNKjbemYvRu2TQGpVz8OD6esR3KEyc0VyCnuPwuFDa8QyVA52Z+
         t3XphTzBBwoB7iuijkFHjB2vuCQx2mDgtYxTa2FxE5IAVymaMDQUdXFRKVfrbFGsbft0
         NE3SzYkxq5Ef72dRK6y5w+POjxKBlzHI5k0F5MtBCQTXFEgcQKnUVC+2PkZAyQefXGU0
         6B6g==
X-Forwarded-Encrypted: i=1; AJvYcCWO/kYaj9fzuYxGOs0WZFmnPQysbLLz3vbcIhcCqPH3jtqShubtlq+ZGuQ/QE1km/hzAsxMbqOmUQ==@kvack.org
X-Gm-Message-State: AOJu0YyYwhc5Ao9L92XV2GIocibrhG6AzDXjTk6uraDnnIQ+J6wsaDjJ
	fcx203/1ARDpXKb4ooyIdEpY4h+RY+E5rY/F8ZxTt0KiLACdFoA0VkR8K8JQEl5P2jw=
X-Gm-Gg: AY/fxX4vOHAySeGPZyfS9/ufYqBNnJwou9UjvptvfC1TAe5ziAmPt5Di22UVQL6lKey
	8YtIeIMTk8jGeH7OLup3GdkURJFucUqwPH928Ad1zni1EBap7B9+MOYxOdDeECW5cPK0rC9mnno
	av/b0/FG4RZWFjP6wmnYFALOAhX0VAtdrZpLSd87T6Fec8UX0scfcgwIF0SJk/d3XX0+oKfPV2J
	wOUPGxOV8A1mG3fMFsaE67sYoJ+DJfzSM4lP6VSi4xadzGIRSMAMFZbp2xxHxCx1m3UvYMJNevP
	RzOHCy0AuGJ7I8c1kn4OzbRqJi8rNdwDzLRGQ4frzw+yVNLkm+NJ1+cp7mhsOmWDsmgf4GId8ad
	JfdoLkPNzOAI0JC6bV81QzH4onp1FWeIsGnSAhiPuBjQLOOv71hdqFfS6XQfZxxHu/Zx/Mik+T6
	plq2AD/0FOLgucqdxG
X-Received: by 2002:a05:600c:37c8:b0:477:af07:dd21 with SMTP id 5b1f17b1804b1-4801eb0d71cmr83998295e9.25.1768737524204;
        Sun, 18 Jan 2026 03:58:44 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f428ac749sm197059975e9.5.2026.01.18.03.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jan 2026 03:58:43 -0800 (PST)
Date: Sun, 18 Jan 2026 14:58:41 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Muchun Song <songmuchun@bytedance.com>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [akpm-mm:mm-new 331/335] mm/memcontrol-v1.c:685 memcg1_swapout()
 warn: inconsistent returns 'rcu_read'.
Message-ID: <202601151810.ie4EgP4S-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EAAE2120004
X-Stat-Signature: ex5otyp5ewf8dg37yipmo1z84wxnwmrh
X-HE-Tag: 1768737525-621923
X-HE-Meta: U2FsdGVkX19+0p9YUJ8Ei/Gae9lSybdcYYo6d+wHywJGPJB4BXpE8C+Ye1vtgUdDb4WycJJbvQuyP1/cmBZ8wIIWTzhyFhu9PQrahYnGxqQ9CkH6fw7wuzsgfZSaIIsc6jOR8IPz+Bq0VI8UL4I1vOJpim48qAmb+e2V080DKkSjeQeuXEfjhtL9i+lpPMu4JD4EZd2oH8RukvJxHSC2dl+9fypIjZdY381yquRtTX6jzccF8HfQvTgqULwIrmdx0nl8pnJXvMjtkhN+4puQglbk8GPBuISURDvjhBYxxI/IiaUtROzkMU6l27xSpupl01xY2dvIQq5QT0OrfsgtpAlYKRu/R1N1xVAYYOO1Tl/IaiVaQSslKQjVpgQWzeTTVFXeIACAgsGeZKe4ReYTdGB6JxUyKefx+S6yo567ZhrCA+q01nZAr7Az52kSrXeP5PIp0rwCWM71pmPHE7qcErrUjm1RTNOyC3sJLj1Z7+4bvGP9DLBtap3xkidTVTPLcNmVwrC4FhUT0ma95Uro5WhYVucnVxCRYVT6gbR29Bvikfzg/z8gZ+8dljvwOy1LHfKmFHlh+KjMC30jmTZbrG/PHRLdce/4mi4yGewP60yJyvZOigRQBNNCivPgKoEtMLjnmN3tpPQ1vMZcN5nzbm/AboPTX3aChFIpseBvfvgAfo2R08XdjWSyNt7o5GKPcK0bWBn4EZedGt2oG5te1vulxQUC6yMQStJqBpQME++ZMoJURJK7s/wCRqBLlQChTezTl2UzE5BvVwPsQOxQaVgAruq+Tfos9rgzjtXQIfZme8ObrwtyY81mck55+R2bA91htSpZ9IaP78Bn/IWNLu8RpMo8ujxsbRPWws2sOHROxkVTLVbZaQ4QlcTc+eoeJvDt1ScA0ivLdpBi1tUq149OekaZaqWiRbht1Fnx+DuA+SdcwGTfM9w0sgxTpJxpjAeBbiQm2mdZ1nTNre1
 pGlSwLxp
 /0yTiMsQ1aJxriAafEJ9ye+QJI1eY9RNlpxfPJQBPSDUQWhh1yf4QODDNhWhPCvL40rOx9x+UIeidaKgLAVmUjY/NXnA+JmfkE/pUpV3fDbV64fn/xKb6+GLoOzqicU2j+uojf/6XGN8G78pm8A797+UPOTUaqTDoTWdAl5dPRh+wF4BP8XUlNbqprNZwHr4X+b3XPI2FtodQkRSpWyd+FaJT1K20F1khvGJji4+xUs+6EyudulFSxdm8ppaoKAfB2+lkM6VJ1BW2Ud38vxgxLskpWjLhqUyx4vHw6e5r1F9vjgWNVmRiD3u0mH0vvYkAVnGVOChoRT2F5PZv/wZQIP5Us/U+zY4UO9FVcNA9bKZiZbt31Vg06XYYvZhG8nwprrrpGhcipohkOME1BKLuxNNgxB+khXHKQ5ICxnHLNJXsLBPrda0W20KC9GjuwcaWy9pdDADDEjYvdfUEitLiqM3YkPkvmN8esKLPKwmCVvnU5tfTemsFvbwozQqyDMxNnk3v8kir2vjzgtLV09MiyGFqWD5jacG1JUWkEv4VJTyyqcVYt0q6Y5TIF630gHgvrhOJRP+D+KZlSvhLluG284nO4c9DUWCBqa4gZZBBYd3iPoDsRf+SB/zNhMR9Rd0UJ9ml
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   78d5565acc4516dfe1fe5a3779a53bc7aaedc2e1
commit: 8e5f42f2bf326f0efb1e565fa57b5ef99b40e646 [331/335] mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios
config: parisc-randconfig-r072-20260115 (https://download.01.org/0day-ci/archive/20260115/202601151810.ie4EgP4S-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 13.4.0
smatch version: v0.5.0-8985-g2614ff1a

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202601151810.ie4EgP4S-lkp@intel.com/

smatch warnings:
mm/memcontrol-v1.c:685 memcg1_swapout() warn: inconsistent returns 'rcu_read'.

vim +/rcu_read +685 mm/memcontrol-v1.c

89ce924f0bd447 Johannes Weiner    2025-01-24  613  void memcg1_swapout(struct folio *folio, swp_entry_t entry)
f7d49ba03ae755 Shakeel Butt       2024-08-14  614  {
89ce924f0bd447 Johannes Weiner    2025-01-24  615  	struct mem_cgroup *memcg, *swap_memcg;
8e5f42f2bf326f Muchun Song        2026-01-14  616  	struct obj_cgroup *objcg;
89ce924f0bd447 Johannes Weiner    2025-01-24  617  	unsigned int nr_entries;
8cb494d6e92a26 Deepanshu Kartikey 2026-01-10  618  	unsigned short oldid;
89ce924f0bd447 Johannes Weiner    2025-01-24  619  
89ce924f0bd447 Johannes Weiner    2025-01-24  620  	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
89ce924f0bd447 Johannes Weiner    2025-01-24  621  	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
89ce924f0bd447 Johannes Weiner    2025-01-24  622  
89ce924f0bd447 Johannes Weiner    2025-01-24  623  	if (mem_cgroup_disabled())
89ce924f0bd447 Johannes Weiner    2025-01-24  624  		return;
89ce924f0bd447 Johannes Weiner    2025-01-24  625  
89ce924f0bd447 Johannes Weiner    2025-01-24  626  	if (!do_memsw_account())
89ce924f0bd447 Johannes Weiner    2025-01-24  627  		return;
89ce924f0bd447 Johannes Weiner    2025-01-24  628  
8e5f42f2bf326f Muchun Song        2026-01-14  629  	objcg = folio_objcg(folio);
8e5f42f2bf326f Muchun Song        2026-01-14  630  	VM_WARN_ON_ONCE_FOLIO(!objcg, folio);
8e5f42f2bf326f Muchun Song        2026-01-14  631  	if (!objcg)
89ce924f0bd447 Johannes Weiner    2025-01-24  632  		return;
89ce924f0bd447 Johannes Weiner    2025-01-24  633  
8e5f42f2bf326f Muchun Song        2026-01-14  634  	rcu_read_lock();
8e5f42f2bf326f Muchun Song        2026-01-14  635  	memcg = obj_cgroup_memcg(objcg);
8cb494d6e92a26 Deepanshu Kartikey 2026-01-10  636  	/*
8cb494d6e92a26 Deepanshu Kartikey 2026-01-10  637  	 * Check if this swap entry is already recorded. This can happen
8cb494d6e92a26 Deepanshu Kartikey 2026-01-10  638  	 * when MADV_PAGEOUT is called multiple times on pages that remain
8cb494d6e92a26 Deepanshu Kartikey 2026-01-10  639  	 * in swapcache, reusing the same swap entries.
8cb494d6e92a26 Deepanshu Kartikey 2026-01-10  640  	 */
8cb494d6e92a26 Deepanshu Kartikey 2026-01-10  641  	oldid = lookup_swap_cgroup_id(entry);
8cb494d6e92a26 Deepanshu Kartikey 2026-01-10  642  	if (oldid == mem_cgroup_id(memcg))
8cb494d6e92a26 Deepanshu Kartikey 2026-01-10  643  		return;


rcu_read_unlock() before returning

8cb494d6e92a26 Deepanshu Kartikey 2026-01-10  644  	VM_WARN_ON_ONCE(oldid != 0);
8cb494d6e92a26 Deepanshu Kartikey 2026-01-10  645  
89ce924f0bd447 Johannes Weiner    2025-01-24  646  	/*
89ce924f0bd447 Johannes Weiner    2025-01-24  647  	 * In case the memcg owning these pages has been offlined and doesn't
89ce924f0bd447 Johannes Weiner    2025-01-24  648  	 * have an ID allocated to it anymore, charge the closest online
89ce924f0bd447 Johannes Weiner    2025-01-24  649  	 * ancestor for the swap instead and transfer the memory+swap charge.
89ce924f0bd447 Johannes Weiner    2025-01-24  650  	 */
1d7634095c770c Shakeel Butt       2025-12-25  651  	swap_memcg = mem_cgroup_private_id_get_online(memcg);
89ce924f0bd447 Johannes Weiner    2025-01-24  652  	nr_entries = folio_nr_pages(folio);
89ce924f0bd447 Johannes Weiner    2025-01-24  653  	/* Get references for the tail pages, too */
89ce924f0bd447 Johannes Weiner    2025-01-24  654  	if (nr_entries > 1)
1d7634095c770c Shakeel Butt       2025-12-25  655  		mem_cgroup_private_id_get_many(swap_memcg, nr_entries - 1);
89ce924f0bd447 Johannes Weiner    2025-01-24  656  	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
89ce924f0bd447 Johannes Weiner    2025-01-24  657  
1d7634095c770c Shakeel Butt       2025-12-25  658  	swap_cgroup_record(folio, mem_cgroup_private_id(swap_memcg), entry);
89ce924f0bd447 Johannes Weiner    2025-01-24  659  
89ce924f0bd447 Johannes Weiner    2025-01-24  660  	folio_unqueue_deferred_split(folio);
89ce924f0bd447 Johannes Weiner    2025-01-24  661  	folio->memcg_data = 0;
89ce924f0bd447 Johannes Weiner    2025-01-24  662  
8e5f42f2bf326f Muchun Song        2026-01-14  663  	if (!obj_cgroup_is_root(objcg))
89ce924f0bd447 Johannes Weiner    2025-01-24  664  		page_counter_uncharge(&memcg->memory, nr_entries);
89ce924f0bd447 Johannes Weiner    2025-01-24  665  
89ce924f0bd447 Johannes Weiner    2025-01-24  666  	if (memcg != swap_memcg) {
89ce924f0bd447 Johannes Weiner    2025-01-24  667  		if (!mem_cgroup_is_root(swap_memcg))
89ce924f0bd447 Johannes Weiner    2025-01-24  668  			page_counter_charge(&swap_memcg->memsw, nr_entries);
89ce924f0bd447 Johannes Weiner    2025-01-24  669  		page_counter_uncharge(&memcg->memsw, nr_entries);
89ce924f0bd447 Johannes Weiner    2025-01-24  670  	}
89ce924f0bd447 Johannes Weiner    2025-01-24  671  
f7d49ba03ae755 Shakeel Butt       2024-08-14  672  	/*
f7d49ba03ae755 Shakeel Butt       2024-08-14  673  	 * Interrupts should be disabled here because the caller holds the
f7d49ba03ae755 Shakeel Butt       2024-08-14  674  	 * i_pages lock which is taken with interrupts-off. It is
f7d49ba03ae755 Shakeel Butt       2024-08-14  675  	 * important here to have the interrupts disabled because it is the
f7d49ba03ae755 Shakeel Butt       2024-08-14  676  	 * only synchronisation we have for updating the per-CPU variables.
f7d49ba03ae755 Shakeel Butt       2024-08-14  677  	 */
f7d49ba03ae755 Shakeel Butt       2024-08-14  678  	preempt_disable_nested();
f7d49ba03ae755 Shakeel Butt       2024-08-14  679  	VM_WARN_ON_IRQS_ENABLED();
f7d49ba03ae755 Shakeel Butt       2024-08-14  680  	memcg1_charge_statistics(memcg, -folio_nr_pages(folio));
f7d49ba03ae755 Shakeel Butt       2024-08-14  681  	preempt_enable_nested();
f7d49ba03ae755 Shakeel Butt       2024-08-14  682  	memcg1_check_events(memcg, folio_nid(folio));
89ce924f0bd447 Johannes Weiner    2025-01-24  683  
8e5f42f2bf326f Muchun Song        2026-01-14  684  	rcu_read_unlock();
8e5f42f2bf326f Muchun Song        2026-01-14 @685  	obj_cgroup_put(objcg);
89ce924f0bd447 Johannes Weiner    2025-01-24  686  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


