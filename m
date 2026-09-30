Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3EB3CA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 10:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80FBC6B0093; Wed, 30 Sep 2026 06:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C0F66B0095; Wed, 30 Sep 2026 06:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B05F6B0096; Wed, 30 Sep 2026 06:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32E546B0093
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 06:12:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 91DA9A7267
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:12:55 +0000 (UTC)
X-FDA: 85270015110.21.78DA951
Received: from mail-ed2-f32.google.com (mail-ed2-f32.google.com [74.125.228.96])
	by imf03.hostedemail.com (Postfix) with ESMTP id BAD7420004
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:12:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JAsBKsW9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.96 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790763173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VNZxYOPgHhHVtE3mtugzmk7TyFgX/vhP/aUVA52RJRU=;
	b=NGxP4HmncxJN/z57D+SijhKp/ul8v076u9HjEtHUfB6YrsD5fc3W6xox/xU7F17e/LhWeQ
	61HFkeNO2aI4dpqWz85BX6VblSErEhArCJqWkfoeYhn1zJGAtsRmrF9p9rn4F1BBgIJX1a
	ma0X8en/Ty8XjW9s85NhD/0Hl+A1fEY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JAsBKsW9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.96 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790763173;
	b=6p5pdmOyjnEEge/5ucOw/y67YN3flGuM/NsLymx1bPp9Z9vL6AbefYyiDTkasZljtp5iQs
	EHNbec48OnMgZ2dUxZI1rh3tlNKxRiuvhotvX7DsBBGA2yPjBBJU9YYR67K2Laa62C67U7
	t9A3yFMCoyxcUFhKjv0cprAtdMbmVd4=
Received: by mail-ed2-f32.google.com with SMTP id 4fb4d7f45d1cf-6acae8342d2so2942533a12.3
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 03:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790763172; x=1791367972; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VNZxYOPgHhHVtE3mtugzmk7TyFgX/vhP/aUVA52RJRU=;
        b=JAsBKsW9xoCvZPdcFtiRTDvWI9YSghfFujEfKH1iApZPs8IxTDEZLfffHNoq5aOk5B
         OmktfZ/Igym1xDf1XGlouGf7IA9p6syYt46LRwh+8udvFlKmGf3bZpGsR+Ix/GtW+zlM
         CRr4UH0j331ZF+HVZi5RSeGGZi05ru13Ip14RH/2M/SWpka9OF//sABab6rF+lnO3d+n
         TTDdLRO8p74W01c23biNXyverWglNREEs6plkFnnZLheerL43BcvQZ00ofCJXD+DXMGt
         r3t/M1QuPI4xF3Pa7At/hWREd2E83p5HYU5yVxJptCgY9lLTywSdiiAlsAm3fLEErnmz
         N77w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790763172; x=1791367972;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VNZxYOPgHhHVtE3mtugzmk7TyFgX/vhP/aUVA52RJRU=;
        b=jnkD9ZA4qzksl1YNri6SJSt2oTi3L7mKqJblMZ/zAtvy0IoZXliYGGfnwARk83b9D5
         UT6Hvx01RY5PUbQ2gOErQlyulPDsZ6yuekKP/YBcKzyRyZ9SFIOC/6ECgJoZUJTHWP2Z
         X/ejliIGCIv2WDOEYi7gUWEIXm6hUiIqOY0gDCUl4ibRtq61kkK9h4YoBUrUt4IAnKJx
         a6NVLw8q1mbgmjZ4n8n5QFYrOAlqGiCWTI0fjSM4Dn+XCfn8PoOPqI3WCnEdZVo/gVQU
         LxrgASTimIiRlC2H88i+GmApbon2pq94N/JCfm3OKYXVU27s37fIAh4EbjJq2Xb6d3jJ
         BO7Q==
X-Forwarded-Encrypted: i=1; AKwUvBxN41Vnbvc7kMawl87Awe6n5GOfr0t99hpofhlZIL41KIZ26MbBbR+cyVsgn+moO4dIE6ZU5L8bkg==@kvack.org
X-Gm-Message-State: AFq9FYITFIuTiM3qQ0/ZI718eZRz4EJXJz18sXSceWQdbIMvgFOZ3doo
	/tEk60OUk94ZsWhbzhlaxqa9gSafPcnFIo2z7F5XAVx7/OPUdnWCJMjO
X-Gm-Gg: AYBFou2GK7Uo1D0c/OYV0koZanZc7ZmKCkS3Rxg8QAzQgHTbTko1GGEghU9BWdPdU8c
	OzKVgEo2v3iGjmgR5DM81V7U52z9Xg+EDtYTLzrTJ3hrMKbYMQv6tQK8cuY7R9hQSTZ4WrsNtMr
	GzKNOqWCd8xllSkLTSiGubbBPpi9QLWXzUtEyC+1FeZWDErjDtfFgzarWjxAFGHCNU3fRTdApTp
	VwSJED2YG/VUjtSvpvfqWeNvxYjTvlYxuSqB5iEjv+KStJ8z/AIEPWwbOovuxc970IBlrN7Ba2L
	3W3WfxP94bdneKm7Gc8+idymRSizXrIIBUsBmc3DXM9ZIh5VXQIJ+lvz2q2TYHldN0qowKQaRlf
	ulolTRK42ynJwV+a/8NPCbGJ0YSlqaW16O7gD5Xu1myWnRQZ15w0xmTsuWLV20n4hJfoV4tf0Zb
	ALWICAFUB03dRRuMgmrbZ7KpcjQ7PHk/qHcl0=
X-Received: by 2002:a05:6402:324e:b0:6a9:dc6a:689c with SMTP id 4fb4d7f45d1cf-6ae199462e8mr462834a12.22.1790763172073;
        Wed, 30 Sep 2026 03:12:52 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6ae15898cf4sm532500a12.36.2026.09.30.03.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 03:12:51 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 30 Sep 2026 12:12:49 +0200
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>,
	=Kent Overstreet <kent.overstreet@linux.dev>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
	kasan-dev@googlegroups.com, Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH v11 2/7] mm/vmalloc: undo partial mappings inside the
 mapping functions
Message-ID: <arzgoe-bXAz1poAt@milan>
References: <20260929082014.160587-1-hao.ge@linux.dev>
 <20260929082014.160587-3-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929082014.160587-3-hao.ge@linux.dev>
X-Stat-Signature: cfykbb6ukfezmg7bi4p9mqbofssqtgs3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BAD7420004
X-HE-Tag: 1790763173-167032
X-HE-Meta: U2FsdGVkX1+mQoCuHxvXMmwlphqCwzFFy/UL/mEAP4wl4F/VmgT3hiF4t+T7oJKPKE2kkR9ItAl6boNXwHT5wKbcPCprKmQkn8lKMo/R3WR/t0EBrc9SVDIRpJcrR5qV6gNFYeu0ij9T3xDWZBiikdzsUxP9lfGtVl23NNMi0nwNv/BFuaAAdGXsGVNATHDQw/FGLqttZ/+rrf/AJb9CQ2yGdv4saYz6WeoEHPGk/twjjLaWPC4wgB5536xFvVvflZlh58X+fuyqCY7Me8IdHnv0jUapRtNiqzdF5B4/KYeW++c9ikxk1Cpjjke2utuoW0nfhs8QyH0IR9derJi1f903gN8qMss+GMs5kVm3pTj0/h4V1Ltsa4CdoQhGhMZCYJcW6kNr0REzZ3BzGpdoElEV0BDFVeSVQ2vnZZFUjh2YXIUfZ+M8JYtSPOvVIu6JzUH8L8CI8DnuxO7/w3P77dsp64CE2XbS2pTirc6DMCGIFEcE3scM4x5CSQukWyqki5jywFM02sSYOpiUGHnB6hWlRRGXbH/0Q83gG7iNVD/O1yFnr26N70Rn4sqY1EeR3pMmrMWJoZKFS9Ys9ElBASV4ErKU7arOh8q1wi62Aq0h1kXF4c5EdKmUvjs+HU+d0qBl78qa5AZ8mXsdZkJSd0y8Nq4xB+pPtepTotC+jFsfTaFJkMiuel09FpWpy6j1EavJirqJWIsmDvLcdZF6k0JbRdvYxPzEFt3GXBmS0anINQr4KNOXFQSeE3gQpZoAG+nKeHvefhQxWV7rmoPuIYjtnuP+DkNhvrxI8IwPbKxC59h6j8r6SIB7hjt/PAhzLebPnIqd6yCQllGtX8X0kZObZphcb+QWeQSGAjdtXN+BNlze7Vzo4h7oFpq0WznUJxQxp8OUhcnmnbEKpDx++FypaTF8WoGwItxN2G6e+uc3lrOALCuayB3alG7vbnppA5FtP8OPCjUdhjfR+AS
 k27b1XWt
 ITX7Ov7lnHSHjbsBlbW5f5b68YyD/XNdT/baH4Y5dOagkto9cFRQkUwxwv86sPDR+wBe37GRiOSx7ksl+lBlqcLkRiDTrTp1H+BKuPy/WKM78mGVSSB/F/QDoVB9Bith3CoKbSEz52oROYYhJ6XbjltuS622d2yifa13frJdpNjWkv+xqmsXzVo8CMpR8AVuCyZGMg02M4Td4PfOWYok2shlrY3mh7Qb0b6rxewt+D6i1lzFqBF9AkX9V14PMV5B+RIekh624QnM/K0v/mqh/luw/5x2AvxHTqp0dIqg+q/Wh749E9XQICWcjly/RLCqGsYucniYHfv6nnzwUAl7XxeITz1Cflk0kbiygB76iLbYlg3y8E7kvPF4e2nMHLZpVwOsHt4IS9CrKH/z797MNVoXAFbuQdgrZakgL47M53nFBp8r67GXsDqoKSLGXynmITfuMcSKXezNJbVlUtawclB2dWgOZnEp10U0qPbnow7PGo7mpZaXPej3lYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 04:20:09PM +0800, Hao Ge wrote:
> __vmap_pages_range_noflush() and friends can install some PTEs before
> failing and leave them mapped, and the kernel callers do not agree on
> who cleans them up. For example, pcpu_map_pages() and
> kmsan_ioremap_page_range() unmap the leftovers themselves, while
> vm_module_tags_populate() and the __GFP_NOFAIL retry loop in
> __vmalloc_area_node() relied on the mapping functions cleaning up and
> did not call anything like vunmap_range() themselves. When the same
> range is mapped again, the attempt hits the leftovers and fails, with
> BUG() in vmap_pte_range() for huge mappings.
> 
> After discussing with Suren and Ulad, we decided the cleanup belongs
> to __vmap_pages_range_noflush() and friends, so the callers no longer
> need to unmap the partial mappings themselves. Each function now
> undoes the PTEs it installed itself.
> 
> The rollback calls the low-level __vunmap_range_noflush(), it just
> clears the PTEs of the range it is given, which is all a rollback
> needs. It cannot use vunmap_range_noflush() because these mapping
> functions also map the KMSAN shadow and origin, and for a metadata
> range its hook would look up the metadata of the metadata, get 0
> and BUG() on addr >= end. The failed mappings were never accessed,
> no TLB flush needed.
> 
> Fixes: 9376130c390a ("mm/vmalloc: add support for __GFP_NOFAIL")
> Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as needed")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/kmsan/shadow.c |  4 ++++
>  mm/vmalloc.c      | 31 +++++++++++++++++++++++++++++--
>  2 files changed, 33 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
> index 0c88d89bf0d6..2166086d3dc3 100644
> --- a/mm/kmsan/shadow.c
> +++ b/mm/kmsan/shadow.c
> @@ -258,6 +258,10 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
>  					    o_pages, page_shift);
>  	kmsan_leave_runtime();
>  	if (mapped) {
> +		/* Undo the shadow mapping set up above. */
> +		kmsan_enter_runtime();
> +		__vunmap_range_noflush(shadow_start, shadow_end);
> +		kmsan_leave_runtime();
>  		err = mapped;
>  		goto ret;
>  	}
>
Can we just do that inside the vmalloc? For example in the
__vmap_pages_range_noflush() as entry function for all(?) helpers?
So we do not need do it manually?

> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 859e6d2d57a3..9bbf75706627 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -349,6 +349,10 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
>  	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
>  		arch_sync_kernel_mappings(start, end);
>  
> +	/* Undo the PTEs installed before the failure. */
> +	if (err)
> +		__vunmap_range_noflush(start, end);
> +
>  	return err;
>  }
>  
> @@ -363,6 +367,9 @@ int vmap_page_range(unsigned long addr, unsigned long end,
>  	if (!err)
>  		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>  					       ioremap_max_page_shift);
> +	if (err)
> +		__vunmap_range_noflush(addr, end);
> +
>  	return err;
>  }
>  
> @@ -667,6 +674,10 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>  	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
>  		arch_sync_kernel_mappings(start, end);
>  
> +	/* Undo the PTEs installed before the failure. */
> +	if (err)
> +		__vunmap_range_noflush(start, end);
> +
>  	return err;
>  }
>  
The only one user of that function is __vmap_pages_range_noflush()
so we can cover both cases there small and huge path.

Is that enough just to do unroll in the below:

__vmap_pages_range_noflush()
vmap_page_range()

functions? It will also fix NOFAIL case:

<snip>
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 89c327a6ce7d..fa1f357ecf3f 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -359,10 +359,19 @@ int vmap_page_range(unsigned long addr, unsigned long end,
 
 	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
 				 ioremap_max_page_shift);
+	if (err)
+		goto error_cleanup_range;
+
 	flush_cache_vmap(addr, end);
-	if (!err)
-		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
+	err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
 					       ioremap_max_page_shift);
+	if (err)
+		goto error_cleanup_range;
+
+	return 0;
+
+error_cleanup_range:
+	__vunmap_range_noflush(addr, end);
 	return err;
 }
 
@@ -683,26 +692,35 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
 	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
+	unsigned long start = addr;
+	int err;
 
-	WARN_ON(page_shift < PAGE_SHIFT);
-
-	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
-			page_shift == PAGE_SHIFT)
-		return vmap_small_pages_range_noflush(addr, end, prot, pages);
+	if (WARN_ON(addr >= end))
+		return -EINVAL;
 
-	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
-		int err;
+	if (WARN_ON(page_shift < PAGE_SHIFT))
+		return -EINVAL;
 
-		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
+		page_shift == PAGE_SHIFT) {
+		err = vmap_small_pages_range_noflush(addr, end, prot, pages);
+	} else {
+		for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
+			err = vmap_range_noflush(addr, addr + (1UL << page_shift),
 					page_to_phys(pages[i]), prot,
 					page_shift);
-		if (err)
-			return err;
+			if (err)
+				break;
 
-		addr += 1UL << page_shift;
+			addr += 1UL << page_shift;
+		}
 	}
 
-	return 0;
+	if (err)
+		__vunmap_range_noflush(start, end);
+
+	/* 0 on success. */
+	return err;
 }
 
 int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
@@ -714,7 +732,13 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 
 	if (ret)
 		return ret;
-	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
+
+	ret = __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
+	if (ret)
+		/* Cleanup KMSAN metadata. */
+		kmsan_vunmap_range_noflush(addr, end);
+
+	return ret;
 }
 
 static int __vmap_pages_range(unsigned long addr, unsigned long end,
<snip>

--
Uladzislau Rezki

