Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2492DFF4923
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 01:08:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D9D56B008C; Sun, 29 Mar 2026 21:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58ABE6B0095; Sun, 29 Mar 2026 21:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478D76B0096; Sun, 29 Mar 2026 21:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 318786B008C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 21:08:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B486E1A0567
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 01:08:57 +0000 (UTC)
X-FDA: 84600945114.05.EB3B957
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id DF4A4140003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 01:08:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MBECF3To;
	spf=pass (imf26.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774832935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bSxailGNhRbcV3r6KP78FzNOZYKnveomaypLipLphEw=;
	b=z1orCaY8CEhReYqRI7e4jUtPwIyCuLHxVOdaD5VuK08lCAjs4LF5edQ6ALHBwy0JGWzuS2
	WRdxlTlTXgMyZQIVYg+yPD/y4OrrOyVz895Y/eXLfpETCWLuBPz+1VEFg8JAlDFuqHPEtZ
	uMGP/dezxMaxkEsFS+BinGBJNT+ZC/w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774832935; a=rsa-sha256;
	cv=none;
	b=aCSXr8q4V2dwFfXX1D/2P8MmpU+PcKMtl4f1jjA7GE9PM9J2rd+KkaJwuhRAH6HOelQU/j
	h1U8tGjVJpY+Tk4KlG8UDrwqPEd51QplgNEtDEs1diWS1S/GSR4MjchluBPjJevhP02yv3
	hSJzuEOLvid/ouISnhkumwIwAY7RGfA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MBECF3To;
	spf=pass (imf26.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2b052562254so122745ad.0
        for <linux-mm@kvack.org>; Sun, 29 Mar 2026 18:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774832935; x=1775437735; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bSxailGNhRbcV3r6KP78FzNOZYKnveomaypLipLphEw=;
        b=MBECF3To8Ija8Zdj7oDemYEM7J8J+O8rhm1s8WA+SS2roxM527P5H2p28IKf4m70uG
         H3WR/gNeSZTOr0/e6TMiLAvfOQF/rgtR3u9jAgZFPVWmC+5wkSoTKullfMZOCp4Fa7T8
         zBQDNcDGsp8/1XAXeICHZqsWYyDtSKHWY9HPFeAU7KdczHu/YALp/GFzC5jp+k6HStzA
         dd37iVzKi4EybUvXDhn+MGMA0LpvQ1/reUZIscgTx4VJUuugW7wdUFJca1xCQE8Lu5R4
         LLdO7zh0LASBtWztMNUWBjYuvHMhfgb2pdkhyH+Blf7BHmgA4HmDFLr24iS0EsV0RcXI
         JVZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774832935; x=1775437735;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bSxailGNhRbcV3r6KP78FzNOZYKnveomaypLipLphEw=;
        b=gJGkKogj0ftSC77zv/i7B++tAmn8I892awswf3dFU4us+m3f5IWDAXcyPZVd1SVO64
         kx0+zF9GC2uTHSYfaYeJ1Q1CB9sq6xJem8rtI3pnMRUsSC2pCCBitx5sH2nlIOefGIla
         YbYx3thxn98dc+ks+owM3AyagOYGGbxsvwI7C8mrrCWwIHum+07pgBtL09C11seG8I00
         YkgbpOmJgThgcFXrxAnu2nUnAKonaoAVVQ2V76AbDVsBFsV0SaRPpByQvUngfCFM4c7T
         KiIj0JjKmYLknIO9eKOhP4/N23ldps1tPPnMApmLm7ip4NwGuqE1BfxXUb6o4O/VGhp1
         pz3w==
X-Forwarded-Encrypted: i=1; AJvYcCUaK/4TaIcTJ5BRvW/3d6YS4UVjwG/QDiYEJPVhZktSleu/qXjax1svVPN8jFjIxhLFhH3ognH/Eg==@kvack.org
X-Gm-Message-State: AOJu0YznZEJYMw7pQRZO+bhuSRKtqhqpk7noZCTazp4OLbOttUuzbHRJ
	FX870jhbT5IXckVBDPmXk//Ptb+TaMvyFlbyfpUx/q6Vlms0Om6H93GxZ7m03AmlHQ==
X-Gm-Gg: ATEYQzyLv31/881v3xSLGQLMGilnoOFKygKrvI50n0Q3snVD0NbHFHRD4FiUYETKcxE
	JQ77mQoDnYe+39iAN0KmKBFKR7FBvbz/ecWO4lUWsQ6fphGvHcPDjWlpD2oZcgtSMBrBO/iQkUv
	GbIDH9nn1BoavWd8NXGftVHnPBfovthTzdqmtoxraRteaMu8GuKPpjpCY4qBcW4akPK25vSIRiS
	RAaLNAetyiLsoqL45pDiLyZXrBi2MS3fe/i4YeP3vrjdrmaNswChp/1TzNfbkj1L1hW9hJewRO3
	8wdLnZiODU4Jk26Zmxkws0x9qUDNsbi/iFH+YBXk8RzRvE8xZWfUllMICx6Uh7DYmHK5xrMKhmP
	S6PvCbPhNTmtCXqSWYq35432RiTbnqFBwWPmugEAMjiR19ffjicQ2eqURCcIq0XaAsC5QzhUIsN
	mfm0ZYnrsxjRViGuwuxz8tzwUITY5bO86MkU/mR8+27cRXaeeUv2wfF8F24P2V0v1IXiCIKUSfF
	LbZU1Tl/Ct4r6q1Gtj9zUS95EWhjRj0XhoBiM9MRlGPmPhasXDlwA==
X-Received: by 2002:a17:902:f78a:b0:2b0:be7d:a25e with SMTP id d9443c01a7336-2b241d59310mr3989985ad.18.1774832934233;
        Sun, 29 Mar 2026 18:08:54 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:1044:279f:2a49:f6d0] ([2a00:79e0:2eb0:8:1044:279f:2a49:f6d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24264287csm58867195ad.3.2026.03.29.18.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 18:08:53 -0700 (PDT)
Date: Sun, 29 Mar 2026 18:08:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
    Vlastimil Babka <vbabka@kernel.org>
cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
    Brendan Jackman <jackmanb@google.com>, 
    Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
    Petr Mladek <pmladek@suse.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: [patch] mm, page_alloc: reintroduce page allocation stall warning
In-Reply-To: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com>
Message-ID: <231154f8-a3c3-229a-31a7-f91ab8ec1773@google.com>
References: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: DF4A4140003
X-Stat-Signature: ds8rcditiq1h7sd45y6skq8iif4iogoc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774832935-833094
X-HE-Meta: U2FsdGVkX18+z2hTtVYP3p4xf9GVKrVin20unY2QNtH/n1dvFi+/psgtVgqHaqRsFGpohVMuF/yNTs5I8ozgQrIjxLaw0NpDgL9ct/t1DNON00dQZvP5I+iECa6vvrbhW9Sxxv2kZNmOzSaNcyXA8++ztdmUfyqS10DpcXv6P5dEl0+2v7enD+/ZX4SnpIdjGdXBundcFNzjF4XhkMfkicRLWeHKzVfb0jlA77gnCSvW2kbW47we6/4f/ZQfcuVxyLe3XsunmJ/nC1cA4jpldl2t99TJHDr5fsvveY6y+KBAvF6b/YSSVWCcXp2oziNobAqu9WsXfohd6M/vU7lUdRr6eeqZ3NQpSU1Z+1WWzhpNkVZrOl398RzknQ/wfWFGPs607RjUXrM134ZURqjytsIPotccKjSuPfwKcJXToR8Ik90kyYU7vWlM4/q9GCYWGIWbpId3hQB66WsteGG/airliVilyMv56i21d6r1XAdGvrlo4MZBdaAVCa7YVbkxqzGHA94/8vEeKdBbOE+Uk4szPHhsTL0kWYgUpQ/QeQw9BgKJormdEo5BLrREbCRG4++x1N+HqmWiaC9m8dJiMtN3YvSXpTigIp8eKO9l5ZSuzSCQkv6qgk6PZEv9D9Vkw0LV6Kb/RKSRTJvcBxaRavkBhJnDBgR1TpK7MiDXZcLmMrckGz1y3sgjbCyBFPMCKgbM9xsH91UcTziONVlYyxgDxsoTxXY5sszu1X1b6x+nTXjQTAFZeFAHizCSKJAlCc0sGL6tire5JWG5cJaTMKGBtaMFtqEkKK7AVttHyk/Scoo75W4zAGOBPNT7l9Z1uWD/S+IHUyC+TiKYFONocqAm/Ap0GKiTeFuon4dcV8QzWxostH6M7apPGNqilicqQhNkO1IlSVNuBBjZ/YOLg0kTyK0q369FPwDd+xSlDN2KuMd5dC14rx31IUXqjfK5/tUSbBNjFTtzDhZulyh
 iNmp/fVN
 vpRSiuVrCb6g+ZkohmGqJ6+OAPYrk2UGwYp5oqRqfYTFxh8CkUt/mBXPUntVQQRi3FW8KhhhYWB1cXcVOZHCAqi8M5G9C8mke6y8B2rDGl7ptG949U+bzhBjnHNT2b6mz0eV/rCKkHsPKw3rWXfBF21sz0crMWcjyMphbSls/5QyHu5ZqF0XUYkRgttFarApzLOGCabRMho8LAGcO1UouPaUOpFy+n41n+ayu3TepL0QsL3UrdIAm0lk5e+8rM8feFrws6ivwNgLEygaQ3nP+92UtGx28PUXByt4v5AxbhtC5RmVmAYOS3yFUhHReC75lZSVTkoPG5QlcqhlwvRmd2V0pwL/AIgWqIQO72BXj6g51HjI0s1B6anqXFIj3oG0cbR319yWbZFP7NGy/Re2aOS66iQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previously, we had warnings when a single page allocation took longer
than reasonably expected.  This was introduced in commit 63f53dea0c98
("mm: warn about allocations which stall for too long").

The warning was subsequently reverted in commit 400e22499dd9 ("mm: don't
warn about allocations which stall for too long") but for reasons
unrelated to the warning itself.

Page allocation stalls in excess of 10 seconds are always useful to debug
because they can result in severe userspace unresponsiveness.  Adding
this artifact can be used to correlate with userspace going out to lunch
and to understand the state of memory at the time.

There should be a reasonable expectation that this warning will never
trigger given it is very passive, it will only be emitted when a page
allocation takes longer than 10 seconds.  If it does trigger, this
reveals an issue that should be fixed: a single page allocation should
never loop for more than 10 seconds without oom killing to make memory
available.

Unlike the original implementation, this implementation only reports
stalls once for the system every 10 seconds.  Otherwise, many concurrent
reclaimers could spam the kernel log unnecessarily.  Stalls are only
reported when calling into direct reclaim.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/page_alloc.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -316,6 +316,14 @@ EXPORT_SYMBOL(nr_node_ids);
 EXPORT_SYMBOL(nr_online_nodes);
 #endif
 
+/*
+ * When page allocations stall for longer than a threshold,
+ * ALLOC_STALL_WARN_MSECS, leave a warning in the kernel log.  Only one warning
+ * will be printed during this duration for the entire system.
+ */
+#define ALLOC_STALL_WARN_MSECS (10 * 1000UL)
+static unsigned long alloc_stall_warn_jiffies;
+
 static bool page_contains_unaccepted(struct page *page, unsigned int order);
 static bool cond_accept_memory(struct zone *zone, unsigned int order,
 			       int alloc_flags);
@@ -4706,6 +4714,40 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
 	return false;
 }
 
+static void check_alloc_stall_warn(gfp_t gfp_mask, nodemask_t *nodemask,
+				unsigned int order, unsigned long alloc_start_time)
+{
+	static DEFINE_SPINLOCK(alloc_stall_lock);
+	unsigned long stall_msecs = jiffies_to_msecs(jiffies - alloc_start_time);
+
+	if (likely(stall_msecs < ALLOC_STALL_WARN_MSECS))
+		return;
+	if (time_before(jiffies, READ_ONCE(alloc_stall_warn_jiffies)))
+		return;
+	if (gfp_mask & __GFP_NOWARN)
+		return;
+
+	if (!spin_trylock(&alloc_stall_lock))
+		return;
+
+	if (time_after_eq(jiffies, alloc_stall_warn_jiffies)) {
+		WRITE_ONCE(alloc_stall_warn_jiffies,
+			   jiffies + msecs_to_jiffies(ALLOC_STALL_WARN_MSECS));
+		spin_unlock(&alloc_stall_lock);
+
+		pr_warn("%s: page allocation stall for %lu secs: order:%d, mode:%#x(%pGg) nodemask=%*pbl",
+			current->comm, stall_msecs / MSEC_PER_SEC, order, gfp_mask, &gfp_mask,
+			nodemask_pr_args(nodemask));
+		cpuset_print_current_mems_allowed();
+		pr_cont("\n");
+		dump_stack();
+		warn_alloc_show_mem(gfp_mask, nodemask);
+		return;
+	}
+
+	spin_unlock(&alloc_stall_lock);
+}
+
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
@@ -4726,6 +4768,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	int reserve_flags;
 	bool compact_first = false;
 	bool can_retry_reserves = true;
+	unsigned long alloc_start_time = jiffies;
 
 	if (unlikely(nofail)) {
 		/*
@@ -4841,6 +4884,9 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (current->flags & PF_MEMALLOC)
 		goto nopage;
 
+	/* If allocation has taken excessively long, warn about it */
+	check_alloc_stall_warn(gfp_mask, ac->nodemask, order, alloc_start_time);
+
 	/* Try direct reclaim and then allocating */
 	if (!compact_first) {
 		page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags,

