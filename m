Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2186606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bu46ZPCU
Received: by kanga.kvack.org (Postfix)
	id BAE306B00EF; Mon, 16 Nov 2026 02:55:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86E06B05B0; Mon, 16 Nov 2026 02:55:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC28A6B05B1; Mon, 16 Nov 2026 02:55:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A6AD6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:55:50 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 134FC160604
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:55:50 +0000 (UTC)
X-FDA: 85440223260.29.0A1CCDE
Received: from mta1.migadu.com (out-94.mta1.migadu.com [95.215.58.94])
	by imf02.hostedemail.com (Postfix) with ESMTP id F1E8E80002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:55:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bu46ZPCU;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.94 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794815748;
	b=esozPiMG6O7/WhQS6RbSPzGrvTSlVCJz4Jtoai5RNY106Hz4vc0O6IY3QQZvJl0CFw9x5w
	FT8B3So9WLoA/0o6awVKksl3WtAu/+mousY6cWkWW7m/TZUOvRSLNttBfLi3O1wLQfM7e3
	KjzZ7ip+3wW7gFgpvcRxIzL992D3Gb4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bu46ZPCU;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.94 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794815748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jdhXKIihT2dq6nnPB/zLM5Tz5DslhafhE4G3biwkqn0=;
	b=pnNprfAo/bOZwR5PGMKxMpTVneY5QjD18lv9BO1ox2PtSZUb57sI773U3/ajxWIj9URtV1
	4QYMiPDKF5uwSaa/HQeFCK2p5jc2Ei8LYuwY8WVQLwF1rrvZKIAfmbKXzCirLgCgYRewed
	jPnUXQWsmyWFEL5ElBq1SmTPiFU5iCU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=P3aWyo9qWXr+tiJ3CVI0TxPUiud8q0JaCtkx0CdstEc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794815746; v=1; x=1795420546;
 b=bu46ZPCUJLj7jhQVy6BLO/fx9drzfdKaV7Wi4+gmm7DttpIEz38dSEKnS2wDfwHWPquQYxt3
 cTD7neVdTQ9nE/fcQNmQOyp91KWt0Hf2RoZg8kg2AayqVh50gmqczVsA9agnr3kMxCEFpdTudlv
 alNGfxzZqbcIObh1jPN2B9Ts=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 112ad70d5ab5acbf;
	Mon, 16 Nov 2026 07:55:46 +0000
X-Mizu-Trace-ID: 112ad70d5ab5acbf
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: muchun.song@linux.dev
Cc: sashiko-reviews@lists.linux.dev,
	songmuchun@bytedance.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de,
	rppt@kernel.org,
	lizhe.67@bytedance.com,
	apopple@nvidia.com,
	balbirs@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jthoughton@google.com,
	lance.yang@linux.dev,
	qi.zheng@linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 02/14] mm/hugetlb: optimize bootmem hugepage tail vmemmap init
Date: Mon, 16 Nov 2026 15:55:40 +0800
Message-ID: <20261116075540.51374-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <D1F34237-066F-43E8-89F5-2D7A6217D72B@linux.dev>
References: <D1F34237-066F-43E8-89F5-2D7A6217D72B@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t6owjspiq8khqdah7y7amng65g1odaaq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F1E8E80002
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794815747-158256
X-HE-Meta: U2FsdGVkX189ijF7PC0Wc65uVAVg0Xpi9zWujaM7fNMfSATZL5XFWhb6bSFIzefECrRN7E3QSv9SIiUIUUXimfQTxtk5mqzAAVH85jWIiGYdikN4KBvozcLMUZNRy09+9s6hw8QikTqQcCyLF6hXV/JqP5HEzgeZlTV142032Mww9KxPcfFauPdKGqRkJdi5FyjR7rSPjQIWLpqtAv5hz6insA/PxWLyrsrUKo8ThLEjVn9Bh90HY8cnCqS2xX8a8uSSKN8DoWz7W8raUceN8sded5FPQylWnhSvWGx+RpslK1Qav2hLdiA6tD7pyBMB3YAbf2FDhIrSRYXq+PrUWfH+K8tWSo4igYzg9MauKQU/ub3Uyutzd7q8D6Jtot+YMDYlbkhEaV2hCX9dpAoPyOenw2p8Uct6U5b19PC2LU6VKkh5A7i15YisStPmjOeFcKZrk1v0s7Wil/BTMtVPisOKDVLAPMEqnmfLHFhYSrhXR+wQvTI+LDEmWXluK7kC7SZIkTbQZlQg7vrB0+TSYM7rAmIyDyB5Ybpjrgvxk4+4CwfkNjEh1zWRPFWO0qmlHIMJaGpFo83WkM00JVfQjj/wQMUCx2q/ZUU4W7BFT05AOPOQx3KrN/OArZHiR9ep9LU7IywCmw/xpSe75yjcjWMb2uxqsWNpFhQggLdvttPTR1JMZy3tujPyEf6W/OpDJ4768PMpbBeggFxgXn686I3GK6cHJgCqwzCszhz3dunOg8zVJSZ/lJpDRS5fEeBIcERvV1SRDP7RRrvfMVZE7/StYTW/5ptZEnF+ZqI8oesH4cPW4g251pHKkxB2S+xzaXCSK3k3tb5uq1inQc2OFJfALPYEigCcus3e+0353iFiSCVx6yng9sx/zDXRjBXXM8kcDaB8KCKai3mXznWR3qTMQR848LTh3ltSzrpWPglQTkbJzXbJNrH2Whh/Zo2cR2Kb6k9fbmvp2FG9H/p
 QsyKitnm
 RoasCG3QIjp0j5s8s2QlPk5IUTYix3ZOK0ezj47TWXfWP19Yj2uW70jo3GlGAWjnZQwMQo8pEr+d8rT3GwdInqQXkoq4IFtkHDMUlDv5Mikiv+L9CdKJ7u6JCf1kzCzKz/wxwbbz9/2osSnELdYE3wK6ViGo9KVrRgkDWNP7ih7ck/wRCCK0kWjzv9Xr0ioD4JyY6bKwuAi6GpDJZDyPBdt5A+jLX4VPDZfWlaNpaZ236nZqrRgOJ2DWGBXyWT6MOHlgwYAEv8bsQP1hA4vgOdnh2+wudydWEpX2x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Fri, Nov 13, 2026 at 12:10:13PM +0800, Muchun Song wrote:
>
>
>> On Nov 13, 2026, at 12:07, sashiko-bot@kernel.org wrote:
>> 
>> Thank you for your contribution! Sashiko AI review found 1 potential
>> issue to consider:
>> - [Low] mm/hugetlb: commit message mismatches
>>  memmap_init_page_from_template()
>> --
>> 
>> commit 7cc97c08b2296fc2518d9ae6da5950cb731c48eb
>> Author: Li Zhe <lizhe.67@bytedance.com>
>> 
>> mm/hugetlb: optimize bootmem hugepage tail vmemmap init
>> 
>> This commit speeds up boot-time HugeTLB tail page vmemmap initialization
>> by seeding a template from the first tail page and initializing the
>> remaining tail pages with memmap_init_page_from_template().
>> 
>>> Initialize the first tail page normally, then initialize the remaining
>>> tails with hugetlb_init_tail_page().  This copies the already
>>> initialized first tail page with memcpy() and refreshes only the
>>> PFN-dependent fields in the destination page, while avoiding the full
>>> __init_single_page() and prep_compound_tail() sequence for state that is
>>> identical across tail pages in the same huge page.
>> 
>> [Severity: Low]
>> This isn't a bug, but the commit message appears to describe an earlier
>> version of the patch.  hugetlb_folio_init_tail_vmemmap() copies the first
>> tail page into a stack template and calls memmap_init_page_from_template()
>> (which refreshes the template before copying) rather than a
>> hugetlb_init_tail_page() helper.  The commit message also omits the change
>> in memmap_init_page_from_template() that restricts memcpy_nontemporal() to
>> ZONE_DEVICE pages and uses memcpy() for other zones.
>
>My bad. I forgot to update the commit message, the corrected commit message
>is as follows:
>
>Boot-time HugeTLB allocation has to initialize tail struct pages itself
>when HugeTLB vmemmap optimization (HVO) is unavailable or fails.  For
>gigantic pages, this can cover a large number of tail pages.  Most state
>installed by __init_single_page() and prep_compound_tail() is identical
>for every tail page in the same huge page, so repeating the full
>initialization sequence for each tail page is unnecessary.
>
>Initialize the first tail page normally and use it as a template for the
>remaining tail pages.  Before each copy,
>memmap_init_page_from_template() refreshes the PFN-dependent fields in
>the template, avoiding repeated initialization of state shared by all
>tail pages.
>
>This extends memmap_init_page_from_template() from ZONE_DEVICE to normal
>memory.  Keep memcpy_nontemporal() for ZONE_DEVICE pages and use
>memcpy() for pages in other zones.  memcpy_nontemporal() was also tested
>for the HugeTLB path, but did not provide a similar benefit; on x86-64,
>memcpy() performed better for this workload.
>
>The fallback path was measured on a v7.4-rc2 base with a temporary
>jiffies-based printk modeled after the existing timing in
>memmap_init_zone_device(), using 4K base pages and 64 boot-time 1G
>hugepages.  HVO is unavailable on arm64; on x86-64,
>hugetlb_free_vmemmap=off was used to exercise the fallback path.
>
>  arch    base      with this patch  reduction
>  arm64   360.8 ms  256.0 ms         29.05%
>  x86-64  171.0 ms  165.0 ms          3.51%
>

with the updated commit message, LGTM!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

