Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A850ACAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 01:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CDC98E0011; Mon,  8 Sep 2025 21:00:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07E588E0002; Mon,  8 Sep 2025 21:00:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87F08E0011; Mon,  8 Sep 2025 21:00:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D26738E0002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:00:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 94EF716037D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:00:18 +0000 (UTC)
X-FDA: 83867905716.09.52FB9FC
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id B3F6720008
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:00:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GiAz00Yb;
	spf=pass (imf13.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757379616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mha16x92fV++DlMun1mfAi0mcQgqv+XgnRVTVIJwwCA=;
	b=BLPqnzTEpNHq8C9SbGETmzdlxXGMfCPSXEOVRuzLolpWpKbO2xsWcORNR2m4lx83ToBI3G
	oYlrO7uYWWp/d5mWPOFYElLojbok4dLU2w9FSC7Z6CYrUBVW4jaIKrYObyUh+7OlblDh22
	cMkTDKTpN4FeJ815sM4+tOIgry+WnBg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757379616; a=rsa-sha256;
	cv=none;
	b=eOx98s4lDdscx64KcxhJl1DBr/sNIfLgFqkupEUOwU2XdanWZsbDCySarsbdRIlqlOSz3L
	UiAvrUutBjVMrCHwEHEruwXXSlZJ0QJHffuO/mgSFm+O3P3Gl+eR09nhOutDDt8RsOTE8Y
	WkayuHOKgGUw2HZniC0uroJK+nT/eJs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GiAz00Yb;
	spf=pass (imf13.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-77246079bc9so6014781b3a.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 18:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757379615; x=1757984415; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mha16x92fV++DlMun1mfAi0mcQgqv+XgnRVTVIJwwCA=;
        b=GiAz00Ybu/VP+DhSIAd0HdU/S4V8NWyyWpRqwKuEI0V764RX5MPdq4eiZaBO4G3c7m
         Gs/xTQAwn7TQTl9asNOGKWv6X4CYlhoIahIOUe5NSxvQL5GuIT/Uq4yI0nJxRHNzj3SU
         VHnlvrMUxS+9Lpzsc/YE9PZ5CHZm5nrBQZK7oZpruht+vx+hFWCl5PiXok0jHNeg82lY
         pIDVDKr1gyV5yLwvyIuj4RZBNIFCRt3MNNBwyty6hkAxv3nWrk7r2cFjQvCvtGaW5D6y
         UWyXhwq6h4OBLQxhaSPcUUkPebWnStnEUvcUvrIMb2Thaelg1dKwf+f3FEi2LH5dt8++
         Iw9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757379615; x=1757984415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mha16x92fV++DlMun1mfAi0mcQgqv+XgnRVTVIJwwCA=;
        b=E502mRW3tRDl2+oWIwhsRUGyTNNF3y2j+Q9tEVCvCP7W3nQmWy5nBDdj+TvL+szGTM
         AdJ/Cqz1sTDaWcwj6W0Vn/2T8TV3eshe9iGuzRx02JoA+ynPPKALMTCGy9uSCp8D0N5B
         yYHGTUYaVraam6JxT9+sQnaLXKvuXQE37miggzhmXmRbNfB6vEb9mSmYN9joZDGCAuK/
         K0AZxR+L0MOiJURe9hCsOAbrcz1idsuNV2swHjd/AO5zfxdSHovwkt422ms8iuUp2+WO
         Wg0MI+5wRQIE+o/PrfDkEkLZhGIVjuwDlrrS88CXqBffmWTxpxAcrUui9+V+hkmXo7fu
         gSog==
X-Forwarded-Encrypted: i=1; AJvYcCWiaRkWP3SBj1uy7+bAR2dfuDSlQgK8IGGuf16M79y697EhZqiRydS6WK4Z/nQ7HC7Z/zSSoG86Og==@kvack.org
X-Gm-Message-State: AOJu0YxkNzTX4tPr2Ie9l6XjpqeFySXgusc2Wi1XP3+dpApmahcBg3IT
	4uKDnUsSALeucSr2200o3olCB67mDCcx5aFuhDq58rkwomxulUfZbcm/
X-Gm-Gg: ASbGncusfNIpRJE/+AVEmtNO2LwsYBoPF+KS6t1kK0pxLcto5cZV7roq3U2F8A+IBlD
	9+JM3f3mmuG4+mRM8KQaz7r+IEXcBlFNpA4ljGhJ5hwNgZF0nwOveE/RO/m1M0R9kc2wJ/HR0dX
	u7kxC/Mh4pJKqRwrOLU8JWzKrogZkd0Nj5g3fuK2RAHTU89g+apdJkjlC7aBzrmCTcMlnUsrpTi
	IqM9Ow+RKcTV9aHnUbpF23g0pOYr+9zfyYp656UrbiARJoK6G0NG91dvB3lPKmNOAErxvFv4Lub
	oKrI1WT3+pGVBpNaQ/dFk0zOGB0jpjQC80jvnV6vO/s8eaiF0OOt9OZJbtOHa2OjxgA4fLDj4Ah
	mOcVirVJRGiqHUH0XC/283mU1DXYGgXxDjvmQ8bQN1kFCYiyxXi+1EpgfJBzZxJ5dmfq+PRT9MA
	==
X-Google-Smtp-Source: AGHT+IFYn9l+IK6z2LyWWy+j6eUu0dD4kgCsi91i0dMipO5RiDiPMrX4zFLHwlaFU3VoW1F2PUEuvA==
X-Received: by 2002:a05:6a00:1789:b0:772:48c5:c758 with SMTP id d2e1a72fcca58-7742dde288bmr14089090b3a.8.1757379615253;
        Mon, 08 Sep 2025 18:00:15 -0700 (PDT)
Received: from localhost.localdomain ([2001:558:600a:7:44e6:767e:cc5a:a060])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77466118d15sm215227b3a.27.2025.09.08.18.00.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 08 Sep 2025 18:00:14 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org
Cc: vbabka@suse.cz,
	harry.yoo@oracle.com,
	shakeel.butt@linux.dev,
	mhocko@suse.com,
	bigeasy@linutronix.de,
	andrii@kernel.org,
	memxor@gmail.com,
	akpm@linux-foundation.org,
	peterz@infradead.org,
	rostedt@goodmis.org,
	hannes@cmpxchg.org
Subject: [PATCH slab v5 2/6] mm: Allow GFP_ACCOUNT to be used in alloc_pages_nolock().
Date: Mon,  8 Sep 2025 18:00:03 -0700
Message-Id: <20250909010007.1660-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u75i538nqzuq8pkmqq3dy14dxeyrknsx
X-Rspamd-Queue-Id: B3F6720008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757379616-795904
X-HE-Meta: U2FsdGVkX18PX46duLZrB9ZiGGm+up5IpBTVbzbJOu3ZIxCHijlAfWf5WZ+g6T71Z7PLoJRPUm7bHVkY4eaUeYyP0DFvCkEusrIH+oYcJ2Qu/MbQBTVb5nL61++Qf4DsCsitHfItqCzrsKkNPfMeAyAmV55MuO2oTT7z/mpXWJjhQxSvQsHSE1bLdguLZiQ8B0JJK0/uN/oyb8n1PjOYR+U9ao2AHcOXbLBOy7C8fM3JnMkmepVXfEp8gZ08opVVcwtMTfD9TEycB7Ij2K858VOA2tWSneTsMSCrxDRfbfWoioGr0nRURglcdiOVc5EQXwk5J1GoFLpQjvbcsYOycVHGjI9mFRxwEg+eq0UiZuB0zprlrWdfb5sG6AysV1lbx070WPhy+v2GEXFI1Kg90xdRwmuS7wD+yhZJaoSk59C+jhfw98RnHcUHBurjNjxqacoM4C+PI0hmhZjrxdtzgEKQM/1W9TGIYI81hLns8f+77Ll25QC4wAeyFieNmBaIONbofkgrBeGydHr9AodaGTK5RhQFeZrKPMxy0+ETXaO0BcLE/AcFzqq40ozbepeXwuDNFzXNkitDssJbiforj9u4cOOJ9T81FZ2yVSwTyENsiGXAdT4DqRSCcNASJy+/kIla2uzlrm2A9rV8RN+78cy3mvLgh0RuJUUqLNTyL56GAi+nOSh/Y6XaXgVFQ6hqtI1zoDCeV36yOrqvvM+RGpZxAXcbnyRJ5SVGN964PcQHnkK0x0S8HU4hO2WCAsgTLxkKW5gqjUh2f89gunjrsNWcsiJ+YCAf6U3VDqSC9NSCqZ1lTr7i56NxXuAH9MU/iw5wzHlnz7YN5IitdvK9lhDYLdSAkW9WDIwqAr5IVC2dePXnWiI31WyNQzIVjaVzMF2ErEAEwtDKqiDoPKlg7e9U+a8jQwQEMz1qzojXSJbyxuWst8+KM6SYc07HxGWG0Tju8IbKkhk99dj8xlD
 RULdZIPj
 cwIDl3e42MFfVQqiwZfShilXL3cI/4TW/MeQahkpXrDtvLFK3Va4qWOevUBSLqOGoTx+X1ZwRCzhJJ4pxRgzGQmRHPdpWYxWZhAEF0T2UOWWQbHnLEJY+LVUZ9ESh6gDP1JOWNvpZGboe72rBh/PQL+8oNfV2cUTGxFC5+lzdyZCbjIF0lCXgpVPcuxm8W8ibeb75UBYWfflaxa34jr3sHEPHW99TyDpVZ/MAeRrAye3lZlnuEvKKUFHJYi994NhRRmMcxpsAKrYhlalTkxTWaHCmR4LxI4zpchLT2I90YUnmLwDjTjYQ48eKCDXZLC3UQ2UQcl8wNPcLbr/3n6+Yd4w1weOaf05XpTgG7qvUthOjLvZzGDUJ92VMv0Sqe2b6ypwgbE2BOj8WpWwB2pMWOMk+k6sk3IudqjploE4JGwLyBrPKsHbttEwhjfA1j85rYU0LNx2lZjOkWb8r4OB6KuLJSIqLEM6+OKjru27VZR9sokN2hMlCeBkV1R2joE0+HwIbb5+7gDp0pgmkiRLLk1yS/reA0+ndWBAx47keVBLPbgwRZlUcb7zDOnvKNh1OAUJV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexei Starovoitov <ast@kernel.org>

Change alloc_pages_nolock() to default to __GFP_COMP when allocating
pages, since upcoming reentrant alloc_slab_page() needs __GFP_COMP.
Also allow __GFP_ACCOUNT flag to be specified,
since most of BPF infra needs __GFP_ACCOUNT except BPF streams.

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/gfp.h  |  2 +-
 kernel/bpf/stream.c  |  2 +-
 kernel/bpf/syscall.c |  2 +-
 mm/page_alloc.c      | 10 ++++++----
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 5ebf26fcdcfa..0ceb4e09306c 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -354,7 +354,7 @@ static inline struct page *alloc_page_vma_noprof(gfp_t gfp,
 }
 #define alloc_page_vma(...)			alloc_hooks(alloc_page_vma_noprof(__VA_ARGS__))
 
-struct page *alloc_pages_nolock_noprof(int nid, unsigned int order);
+struct page *alloc_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int order);
 #define alloc_pages_nolock(...)			alloc_hooks(alloc_pages_nolock_noprof(__VA_ARGS__))
 
 extern unsigned long get_free_pages_noprof(gfp_t gfp_mask, unsigned int order);
diff --git a/kernel/bpf/stream.c b/kernel/bpf/stream.c
index ab592db4a4bf..eb6c5a21c2ef 100644
--- a/kernel/bpf/stream.c
+++ b/kernel/bpf/stream.c
@@ -83,7 +83,7 @@ static struct bpf_stream_page *bpf_stream_page_replace(void)
 	struct bpf_stream_page *stream_page, *old_stream_page;
 	struct page *page;
 
-	page = alloc_pages_nolock(NUMA_NO_NODE, 0);
+	page = alloc_pages_nolock(/* Don't account */ 0, NUMA_NO_NODE, 0);
 	if (!page)
 		return NULL;
 	stream_page = page_address(page);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 0fbfa8532c39..dbf86f8014de 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -581,7 +581,7 @@ static bool can_alloc_pages(void)
 static struct page *__bpf_alloc_page(int nid)
 {
 	if (!can_alloc_pages())
-		return alloc_pages_nolock(nid, 0);
+		return alloc_pages_nolock(__GFP_ACCOUNT, nid, 0);
 
 	return alloc_pages_node(nid,
 				GFP_KERNEL | __GFP_ZERO | __GFP_ACCOUNT
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d1d037f97c5f..30ccff0283fd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7480,6 +7480,7 @@ static bool __free_unaccepted(struct page *page)
 
 /**
  * alloc_pages_nolock - opportunistic reentrant allocation from any context
+ * @gfp_flags: GFP flags. Only __GFP_ACCOUNT allowed.
  * @nid: node to allocate from
  * @order: allocation order size
  *
@@ -7493,7 +7494,7 @@ static bool __free_unaccepted(struct page *page)
  * Return: allocated page or NULL on failure. NULL does not mean EBUSY or EAGAIN.
  * It means ENOMEM. There is no reason to call it again and expect !NULL.
  */
-struct page *alloc_pages_nolock_noprof(int nid, unsigned int order)
+struct page *alloc_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int order)
 {
 	/*
 	 * Do not specify __GFP_DIRECT_RECLAIM, since direct claim is not allowed.
@@ -7515,12 +7516,13 @@ struct page *alloc_pages_nolock_noprof(int nid, unsigned int order)
 	 * specify it here to highlight that alloc_pages_nolock()
 	 * doesn't want to deplete reserves.
 	 */
-	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC
-			| __GFP_ACCOUNT;
+	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC | __GFP_COMP
+			| gfp_flags;
 	unsigned int alloc_flags = ALLOC_TRYLOCK;
 	struct alloc_context ac = { };
 	struct page *page;
 
+	VM_WARN_ON_ONCE(gfp_flags & ~__GFP_ACCOUNT);
 	/*
 	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
 	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
@@ -7558,7 +7560,7 @@ struct page *alloc_pages_nolock_noprof(int nid, unsigned int order)
 	if (page)
 		set_page_refcounted(page);
 
-	if (memcg_kmem_online() && page &&
+	if (memcg_kmem_online() && page && (gfp_flags & __GFP_ACCOUNT) &&
 	    unlikely(__memcg_kmem_charge_page(page, alloc_gfp, order) != 0)) {
 		free_pages_nolock(page, order);
 		page = NULL;
-- 
2.47.3


