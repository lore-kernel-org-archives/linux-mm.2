Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2595FCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:41:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DE638E001A; Mon, 15 Sep 2025 09:40:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 068438E0018; Mon, 15 Sep 2025 09:40:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFC9F8E001A; Mon, 15 Sep 2025 09:40:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C48AD8E0018
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:40:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8D9CC86AEF
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:40:55 +0000 (UTC)
X-FDA: 83891595270.04.673A2D1
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id B1D7314000F
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:40:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jIDv2KXK;
	spf=pass (imf09.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757943653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cGnhxqw7K3FLu3AtNhDK+aUKQwK3uD8HExSuo45tTA=;
	b=aaUBarTBZ73j37z+bCrpBtoivOIADFCEVx1OlmXa1OLTGCfrqqfyguCwau40YnJppmJxvm
	lqrALkOOGO+NIZ92xQcnsD+HZIodIAA/fe6aaynQfGU1N8tHJOD6qIQuyEdhJdyfeuaRB7
	tZD1U/j2vDtPveMERrydKZ+cUdA3FZw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757943653; a=rsa-sha256;
	cv=none;
	b=kj/FyO3HVo57RK2e9Ba9L2eNA/fUSUmhMTI66b58xo/bqeAjOASZEhErwQiQo52fsWWmdH
	BRkE6CjxOvasrUqlvepWImNy2isD33sU2NVwKkU2hWCfgRFRtxXElkQTEpc/ZkbRnJDUSu
	uchZ6ASLKDBDX0qOW7eHBGuIVio5GGM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jIDv2KXK;
	spf=pass (imf09.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-55f78e3cdf9so4832935e87.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757943652; x=1758548452; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5cGnhxqw7K3FLu3AtNhDK+aUKQwK3uD8HExSuo45tTA=;
        b=jIDv2KXKaLEYxP1nHdnP7WZxBsDONwUAkS2lcVpsdz3hVMl5YdxVb0PjkTxZn4VD4I
         beDiiBPXP6LvD6TXS5Er3ajayev5vnlgt3yxbTDREeuLz2TnsfHL5Ak2AT+xi1F4a7w0
         GNDCkB1W6gTZTnSy/nVhVVxhTnhfgOpgQhhGp4RadiwTyeVbr8o2awZWaTmyQHF+oHwm
         YshSYE7TfW7cl9aa5Z9nz7N1JIfgXtvz4KJ7EGN5wZQ7sixMHwJzDK4tHB3Ucex+ub5U
         cvPOALzHsBybyLmfSr5XPlAm65ZZivI1yc9PCs1scxoaBMm8uDBWiDAZ6r0Cg+c2Fl0Z
         v8sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757943652; x=1758548452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5cGnhxqw7K3FLu3AtNhDK+aUKQwK3uD8HExSuo45tTA=;
        b=G32eQtBOamZvOZFq82LyVs4aw/IOFiKEgn1RfjDad3n/7mr3SHms/MAnPqrkPwlBTc
         C1tcBQtC6GndyytFoHZgEDm0UPjWNncpSw6NhSmNfWNK6RSCEXkNagcY1K2c/0YOue0a
         nYNxnGI0PFTb/NIvTDxuEbG1VrEp6iY/I+LdT5raAdHw3133zTlfRzRmDxgNMybtHZzB
         j7euUbpC9w9njYqXFVDGaU9WW0EAbdCu6UYDX76Vp76e2fr4HRskyuXm26JbZOTGdSWS
         wk7/KNmYlO/9iE5QzRL20onfNj5WGEzvYYJ8uO1rzfQM+9NhFPizJW9WGPxjBOMKjqxO
         fvaA==
X-Gm-Message-State: AOJu0YzcL0Qn0cC25VI4XCHGKM9ZtMB5FVQ+iHaDjwzqSUmdqOBVRAR0
	trKThOT7gjUCIwe0Nx72CiNHxOR9SR4Ap/lT/i5DncGKEpRpNeeLeHyei7Gkog==
X-Gm-Gg: ASbGnct83UTQ53Yjc6QwY2OygtCHn+Xs7oPeRvFz8+c9bzd9hWeDGKWgVxgUNQPhgdY
	q40MgPW8CMnCZXTuOUTkAp+2b0migLRoFlnf3nlnAXeDu7ME1T4K3cQ1tqmTIvwe9z2ZDK9GrCM
	L2uH/wbMxRjiFcV1Sp+pm7zlS5jaql74jRAR3kRxjwtmf1HOh+YEU6RQ3euIl9sgqopVWLvKN75
	iYGbZ05I1f8Ec5PZfPT/1ubkQLTz0uIuE8vQaMVaojeXTbYTAUyuDAl7I7pjDOCvPcmcuNVpGO5
	d4NG25KxVcjHArpfjwufIalle1J1b4tlByBlGaaanyMgrIQbNHTgBCz7fYZkRAMRZe7VLQ03l54
	Vfi8/A2BnOTxs54pCBjVy3yxiGd0=
X-Google-Smtp-Source: AGHT+IHKa7vjk8urMi0MJsQZzlSJv6bCL5W2V3cj7dJf0fQ0uTCa5kr5MJF0Y73xS+PSGi4QMIZRnQ==
X-Received: by 2002:a05:6512:661b:b0:55f:4107:ac46 with SMTP id 2adb3069b0e04-5704ad8173cmr2175163e87.25.1757943651896;
        Mon, 15 Sep 2025 06:40:51 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-573c8330e54sm1150719e87.63.2025.09.15.06.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 06:40:51 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH v2 10/10] mm/vmalloc: Update __vmalloc_node_range() documentation
Date: Mon, 15 Sep 2025 15:40:40 +0200
Message-ID: <20250915134041.151462-11-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915134041.151462-1-urezki@gmail.com>
References: <20250915134041.151462-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B1D7314000F
X-Stat-Signature: 5ihrx9jumfysu5xfonrzujgwh1xyqejr
X-Rspam-User: 
X-HE-Tag: 1757943653-216485
X-HE-Meta: U2FsdGVkX1+HeT1Ec/tQ/oGl6q6C2XgfA7ykdfjcvphlZE9FFX1AyglZOTaade9NVb/LmAEnbL5EwTacAYRT+HadQPPsA6bRNPwTwzaB4+nB9Pr2bWaA/y533WymARtlQUbXl3u816e0jz777qWa9T2j3SUjf0xyAp64vDFYe3RGt7sNa4LQhx2qM1+XSkD1iUTJHfh/DHC/L9efYbzZPTj1R5O68idRHGprjPEi2epaSKt5zwcyPTOQDEo7b3167MAiUSGvcBjm+uzJG5OBWlawo/uYbxVc9dgz1DlCpZEI+Ncpsyd81Hj8Umuukd95gemDQRxMb+nh1zoMY6lDzvfiqBD755CO0Xh4Xj+ebbrlhYPsem1nYgftnLx2j5lUThgV6yNtZns6j/iu9axEay2m3t0l7BGJrcWUEC690Vt8451swaFZpKDSZwgrE8PNirp8dM0DJePdIqP/o891p0r68nYK6K+Lw3GFygWEHObjheoDK0AV+zmONUFskERfKbvtlZs5MG2dVznHuFe34UL3wtjlaxKsCLEOPvSgEosny2A8D6pqhkM6E3mGspKTleW+FtYpkhKj8XkSSIWoh45PEVU5VS9D6L8xLlCfYN1VN80nnIDsxGSi0R7WywCGXYzvG392YYh+M40RPVuz4vVZEDWl8x3aY49r964D8EvLDm0uYJkAeFOyHGZJraiz9/kl4f9aiUotkn4wVJ8aMzejYg9BWqOESCJWWQVLfgFxPB9YghjNClPdk3q7Bn/Jo4Rcifl5XSC4hiFax4cNaq3h5bQuWaPHhFcsVgmMRFy35L82yNFZeFaTO0j8FlZ4OfgdXnygC1f5dDgfEj3JSGOcVsqUsINA8OhGsOMheXXOBUNZ1bOuRWTVWlJGDBXzqPzzd9i9djULzniiNZafdgXfPVJGO9Sg0Or1rabLlarpQy0oFr81H6WN658JaJHlb2y8Jm5xhjL1eGRE/Nq
 G5mji38L
 C43mblfq9E9BFqB0XFfPieo2ZWBrT6n7Tk0aLmqNk+uL4YXfUHxriM3gD2Li6n1glxkBouS89p5bMLrcwwmI/ykGq527tlg7CuZnXJCvDnXFv4vu9Wk0P62hCBk6h7JMB8dqzEqpcFGXsYjKLr1Qvi59Bx/hkvM+TgqBdOcdGMctLOdDxzNw+Vr1rsv/29E8qeUshTwZiPKvWMsKq8XTZMmnNKdBDU5xfCugh5lPjwu1W2tNYAxDCICXDp5sPqSkAJfxOPhECpiRI8UnAOotWa4UqjD0KNndCysOL6ZPWj9ThbDmuxuoI1insxSKZLoIWIg6Gz+2ks+qVlTcDPzu3cIzuiWhzenF1Bv1bKqKs8O5j0Wyb9OBejUGoMKEstY/bfLs260+YsqTzaofke7lb7i7/qu+A2SWbk5IyMSeLxSytm4ayegVIN/piopoWfHGK8WOHUSXrjr9U2rqzk8mEz9Xhpu4aU0x+Xq4Bipr4kL6AXkc2dd6vkl/d8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__vmalloc() function now supports non-blocking flags such as
GFP_ATOMIC and GFP_NOWAIT. Update the documentation accordingly.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 2d4e22dd04f7..e56d576b46c8 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3880,19 +3880,20 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
  * @caller:		  caller's return address
  *
  * Allocate enough pages to cover @size from the page level
- * allocator with @gfp_mask flags. Please note that the full set of gfp
- * flags are not supported. GFP_KERNEL, GFP_NOFS and GFP_NOIO are all
- * supported.
- * Zone modifiers are not supported. From the reclaim modifiers
- * __GFP_DIRECT_RECLAIM is required (aka GFP_NOWAIT is not supported)
- * and only __GFP_NOFAIL is supported (i.e. __GFP_NORETRY and
- * __GFP_RETRY_MAYFAIL are not supported).
+ * allocator with @gfp_mask flags and map them into contiguous
+ * virtual range with protection @prot.
  *
- * __GFP_NOWARN can be used to suppress failures messages.
+ * Supported GFP classes: %GFP_KERNEL, %GFP_ATOMIC, %GFP_NOWAIT,
+ * %GFP_NOFS and %GFP_NOIO. Zone modifiers are not supported.
+ * Please note %GFP_ATOMIC and %GFP_NOWAIT are supported only
+ * by __vmalloc().
+
+ * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
+ * and %__GFP_RETRY_MAYFAIL are not supported.
  *
- * Map them into contiguous kernel virtual space, using a pagetable
- * protection of @prot.
+ * %__GFP_NOWARN can be used to suppress failure messages.
  *
+ * Can not be called from interrupt nor NMI contexts.
  * Return: the address of the area or %NULL on failure
  */
 void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
-- 
2.47.3


