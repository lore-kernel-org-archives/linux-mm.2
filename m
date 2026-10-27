Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20D01606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NyhzH+Up
Received: by kanga.kvack.org (Postfix)
	id 1120D6B0813; Tue, 27 Oct 2026 12:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EA1B6B0815; Tue, 27 Oct 2026 12:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F41AB6B0816; Tue, 27 Oct 2026 12:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CBD0E6B0813
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:08:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5AD5816010B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:08:41 +0000 (UTC)
X-FDA: 85368889242.09.7C1914C
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9EA734000E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:08:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NyhzH+Up;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793117319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QVxxN3pOPGXBhWxV8G2yXfM8qxwN8twHCdwdAriEeWA=;
	b=unzNj/pHwFMzGCs5KaRuf0zC1WCx0kTVEJJTVI6pKT/WfrwgBBhAY2/41z7gBRCJ4KDqS1
	mIwYyrzOs7tSWBkBow93WYAZnmDlaD+gQcbOTrknvAbkPT2Y4QSIeQKEKTlD3jxT7+W67v
	xorSO3rGQIrtpPPX7LB6P2TnXNo8DtU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NyhzH+Up;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793117319;
	b=pcrU7excBXX5If2jQsJX30m9H7yfXisgmmAbwNECF9KI4TH5WLWxl5iFT/AlHkOMRvW8VQ
	wNmVQRd7o5FP3DKQcn8N207vXLBazTIEbz2PhGR/2cTuhRjzZT7/ILV0/i13i2kpVCI2rv
	OqA++C/rz1zsf1TJg6aOiFPpXMPh+qM=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-ca766c1c9ccso57320a12.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793117318; x=1793722118; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QVxxN3pOPGXBhWxV8G2yXfM8qxwN8twHCdwdAriEeWA=;
        b=NyhzH+UpHj7xaB8N8ovobgNpyweCki5jK3xvMKW0GhaaXNofzRbpfvoYdtv4HF2MAh
         3CoxeR0qraShq23Z/3d2FBvs1QP7yPw6ok90DiDuI/K59to0yUtBBKqAfwNkIfwC2U08
         rL9jhSND4Y7rXncIVAIGRJmaBljibHpI/aQkX2waVVGMr3CJLK/DDDX3lDngEDQCnBW8
         kFDIE77zlKf2nBKGlZlbjDfisRc0kIv0UHqNCRELzXiRXAMAUGcTHYYjb8qWOSR+1/XJ
         WD8nB69LIALXLDxHqksSuC+CGupDAjqy+Xri3ouhknFYahRxCyI0+wrBLo7Xh1RgJ+pe
         akJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793117318; x=1793722118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QVxxN3pOPGXBhWxV8G2yXfM8qxwN8twHCdwdAriEeWA=;
        b=jUrfCbKRPJbTAt4RNA4ZdV7cIg8duBUCM30kUcL5GptF7tEAVoD8eb69UXf12x+DOG
         Zb6HGxbtSvVBQS3vQ17grG6pmll2XbtSSktJzFRkdpYI0ssEWnkIgshgj7JyiYehuX8g
         qhasubg7jL//WaPIvE/GO8tpA79pD8y8cBgOPaVZaWSV3vReUzHMrpgyLk19jqzfQoNA
         994NTNKqqzSnfRlNQ9uzVmEpem0DUq/ohj10dEvY/prVGv4aYrHu2NTIgdX5TAv+6FUw
         YmITILkxDYd6QYx9o9ac4BciM0OOyIBt8Vfkf9zctf+oaDiIjbeuEW9N8NrPcM+NNAlp
         ApwA==
X-Gm-Message-State: AFq9FYKAF794J0dkB5mXjxcn3NLxyEcFuoHqwf2zvxBVK4V9xVdgsXpK
	oGmfaviqvoxJtQ795ixs0ZXD3Qs8DoBUKv47KV/Cn1t/sXAS2X1v9X56fCrskw==
X-Gm-Gg: AYBFou18YHXxLRIt+90cj5iAIWeil6RNfKpWhtasV1KRXwuyx+larzl6d3Dh5E7oWQT
	eDinF9tB66WrTKcpgT7qL9A+c7m9GkoXRKrQDJv0TsB69CaX2sjvx3enEZLohJOK3U1E/504ct9
	6wWZrC+1k2RCZN5m2Jdpr32w8Kt7ZxTOQTGr4DrY+xPdxNTnlqLlhGj9fmIQ+pkLISDTTgOcpnp
	xOI8fZgGK5nNhg5n2yI4oGWZbyDvN2w+bU2bg6a+fIRV4r8Z9//VFF6yRFdJbf6xNaWuwgUtZ7X
	Rh3e4ME9eWZ8PhdqBQdX6/JYSozWwPUO0zmYBC4eDdtXIrXIV/1RuxpuyY/gdN4Js+0aMUtaUfA
	wJEQubQZ4IBlpGrNzXUgTU+8oRVIzcHbMTzOSiI83jagyIpawtb63sdZytwchztfZ5HQHlfyozj
	KWN234nYGlt56e65zBKNLCsSI7Momqa52i1XzVM7IOPCmfsmT8GpzMn9H8QW5Jrq70EcPIueCjp
	VblVtMATm/ARKWbVf4YNz3tSMpV8532XN4+aIac+yxUiTExCNcPmNczKmsEYVeLdiV/wmjd3yGf
	+qR4gTpgZ6t/ogMT+nQsF0LSe9P4KyCABR9A7mYO
X-Received: by 2002:a17:90b:4fd0:b0:3a0:cbe2:9e0c with SMTP id 98e67ed59e1d1-3adeb10f4b9mr8694182a91.63.1793117318387;
        Tue, 27 Oct 2026 09:08:38 -0700 (PDT)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebaddd45sm8500624a91.2.2026.10.27.09.08.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 09:08:38 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	linjh22s@gmail.com,
	kunwu.chan@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org,
	tglx@kernel.org,
	linux-hardening@vger.kernel.org
Subject: [RFC PATCH v3 09/18] mm/swap: avoid direct reclaim when populating swap cluster metadata
Date: Wed, 28 Oct 2026 00:08:12 +0800
Message-ID: <3dcf416531542280b8b01b2bc6bde6f1d094f105.1793106426.git.lianux.mm@gmail.com>
In-Reply-To: <cover.1793106426.git.lianux.mm@gmail.com>
References: <cover.1793106426.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9EA734000E
X-Stat-Signature: poot6tnc8cxme5sstesxzg1dbzkom3wb
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793117319-3470
X-HE-Meta: U2FsdGVkX1/YNGgKZ4J66qHiB+v6ILJNt38MznssNzj0ROR5bOfqv6r3XplmkUzULW35OzbSdAH00NrbGzmmnIsCN4smKxtPpa2EWW6FNyA4kPKeBiCsAB8uhX25kqiesxvuunk1KO5sYSr77Rct+QWMxAWY56k4ufW4Nr2LA7WbKOjHb6Ewg/2R3Tuuq2uqeBlKntUGJ4FKL+CJ9TUZMoxbsAl93l+3Xh5LZmKIw1aPkGYGmPmPIlxKqAe8cFmCZApauyiXCMRJV07Tpy7OD95yenE6NnSCI4WBmhbiGkDVJXVYoNZAj/S7pwPOxomHnRHB+S10VrQ2TgqPG3fcBXY0i/E6T7j70+DdkchWud46cBNrSsGelT/PHBAwcjWbc8FNrbPFATbJmnqDt4dTyFac83HtN3stHpLnzkcC7jOw1HT3+Zt9AExfKnKE+WeUVWPLccyzv562OElx+MCoadEgUuLVZ8U+GUizAQBDNRokxK9MyG+2pxIFy/qGtF2om9qR8P1nnxGpkybN6tUktYZZpXGGaJHlCX/ZACt0PQ7zZSz1C1tc5ObnjhNi/G4K6O5dpb5rHU1MMjH2hLh6J5F0key7gw8DdzTWQeyhHUxUUudITMNR6t331rsOsy4vcil0ZdrOB2EPHjD9HSKdRSGgi58pJurV+3N2UK63dFPMD8/6DOLxP03MHWoFKW+UhXq7Swh5GXQhpzB4hZL3R0ac4xT+yWtjOOj7QuaAKoMRF1kfydYLT+WC52V9X+DFjeelMLllQJE4yYyHkI3WMycLA8joRlEKk0r6jaIXCeJccNfqGhdtKe2uoKfv2WmI/MMygpdgx56VSvG25LZzK2oxPkp9RJK3cpzfjvvA9zRZlGV2pgrNibsIXUFDABi7NuMukxZH3yoRuLBCO3djrs959Jz2cMqi4t4wg1+E2LmfeiBGP1igDcoOONHok5C0IsiPMC7Y8qjgnd22WEE
 x9pE6Wwo
 9W9EX63gR884hq3kv1+hobrVPBLXNohHuvupBpkd9fNQfqT+ELWlxMq0mR1kTlFHx8Ug91Tv5R3qhUF1bCQHSnzb+HHRBrN57yc0Qg5JgrGzKizwTku8bDIZbamOz4DAuo8Ugmi5DyAZZbOqGPTnUSW0mvUWeByazMWFmNPwmpH8GiGKNxQJDmUa5d1emRcNdfu+cPJ5iyNtc6z+zHA5yimtneptu9Ml2LK847BiZ5znP3d+oI9V034qsAayJmAc6UPteq6KuzQc8dkwiLoDS9H8o/kVfSLZf7fmNIYawMfYlUDKXfj4KZ64MrpieRZ/jRxOSNduboA6fjVXPWgqj8N3JhBoVEL+gzWqY8k7/1cxvrv0ZIaFrzN7dJR9ob8ntjliNh48ibKeidWhqMg1nEI5aBHv0ZCvSOn6w7E8OM7n6ph7gyGlDIbO/3zEMdoz02uvJkll/u5e0K3jF/joVcYi48Jh9w+Gz5LA0yL3+ihBPAyI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Swap cluster population is entered from swap allocation and may itself
need memory for slot metadata. Its fallback drops the device and cluster
locks before allocating with GFP_KERNEL, which can reenter swap
allocation through direct reclaim.

Make this allocation boundary explicitly non-reclaiming so callers can
retain outer synchronization without a recursive swap allocation.
Clear __GFP_DIRECT_RECLAIM from the fallback request while retaining
__GFP_HIGH and __GFP_NOMEMALLOC. The retry can still wake kswapd, but
fails without direct reclaim when memory is unavailable.

This can make metadata allocation fail earlier under memory pressure.
Keep the existing isolated-cluster rollback and restrict this request
without adding a task-wide PF_MEMALLOC scope.

Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 2035513d3c61..68bed5023299 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -545,13 +545,14 @@ static void swap_cluster_assert_empty(struct swap_cluster_info *ci,
 }
 
 /*
- * Allocate swap table for one cluster. Attempt an atomic allocation first,
- * then fallback to sleeping allocation.
+ * Allocate swap table for one cluster. Attempt allocation under the locks
+ * first, then retry with the locks dropped without entering direct reclaim.
  */
 static struct swap_cluster_info *
 swap_cluster_populate(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci)
 {
+	gfp_t gfp;
 	int ret;
 
 	/*
@@ -569,9 +570,11 @@ swap_cluster_populate(struct swap_info_struct *si,
 		return ci;
 
 	/*
-	 * Try a sleep allocation. Each isolated free cluster may cause
-	 * a sleep allocation, but there is a limited number of them, so
-	 * the potential recursive allocation is limited.
+	 * Drop the device and cluster locks before retrying. Metadata allocation
+	 * must not recurse into swap allocation through direct reclaim: callers
+	 * can retain outer synchronization across cluster population. Restrict
+	 * this request instead of granting the task PF_MEMALLOC, which could
+	 * give allocator hooks and failure cleanup reserve access.
 	 */
 	spin_unlock(&ci->lock);
 	if (si->flags & SWP_SOLIDSTATE)
@@ -579,8 +582,9 @@ swap_cluster_populate(struct swap_info_struct *si,
 	else
 		spin_unlock(&si->global_cluster->lock);
 
-	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
-					   GFP_KERNEL);
+	gfp = (GFP_KERNEL | __GFP_HIGH | __GFP_NOMEMALLOC) &
+		~__GFP_DIRECT_RECLAIM;
+	ret = swap_cluster_alloc_table(ci, gfp);
 
 	/*
 	 * Back to atomic context. We might have migrated to a new CPU with a
@@ -3095,9 +3099,8 @@ unlock:
 	del_from_avail_list(si, true);
 
 	/*
-	 * The swap allocator doesn't take swapon_rwsem. Looping through every
-	 * cluster lock after clearing SWP_WRITEOK ensures that allocators see
-	 * the updated flag and that no allocation remains in flight.
+	 * Drain cluster-lock users after clearing SWP_WRITEOK, so swapoff
+	 * does not race with operations that started before the transition.
 	 */
 	for (offset = 0; offset < end; offset += SWAPFILE_CLUSTER) {
 		ci = swap_cluster_lock(si, offset);

