Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 463D1606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 21:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=sQl5GewC
Received: by kanga.kvack.org (Postfix)
	id 905196B05B4; Wed, 28 Oct 2026 17:19:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88E5E6B05B5; Wed, 28 Oct 2026 17:19:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 755C96B05B8; Wed, 28 Oct 2026 17:19:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48AE16B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:19:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 490AE1401FE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:19:37 +0000 (UTC)
X-FDA: 85373301594.24.C8F1455
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 87E8C1C0004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:19:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sQl5GewC;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793222375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qyE3BvZ22dE3cQ/ON5Q1I/RqepT+3oR0Tr4bDbH+x1w=;
	b=DtXO2H7OPKAZ1uBCGSvGfwbbgOGqkgEIO6vrVs2Q4w9UMQ+gyOt6FrZtzRRZXJXefUvdbn
	1wb5uSUY9B2mVaTpH5VKdQtfUkPQVKb6nEV0IyBaSLnLKuZWh6H3gZgEfC9OldMSjSCf6J
	DYomildYMvsA1x32NfphDTKbZd5Ct8U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793222375;
	b=UzS4cCmSRYVie4PJ/Q1G9EQ9T8xZpLCsQth96e9aTmK2ixa+vB+JdNZoL2sSHOM1Nx4Nzy
	tA7g+eckTsRhMa04Ap7ItCTv4qRD1P/fNa1L3XWIlojZsOqlz0KkNpgA5eRKqsh2+e1Z1Q
	fASEAF6j1xnBkJiejCva+98v4moI4NM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sQl5GewC;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-53634b8328eso13916151cf.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793222375; x=1793827175; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qyE3BvZ22dE3cQ/ON5Q1I/RqepT+3oR0Tr4bDbH+x1w=;
        b=sQl5GewC3nLjNqmXj5RuNBXr33AAjIZXuZSn/ZEKwXKjdXSa/MNxDykxux8EfeRGlX
         xU/PJ/15/BfFZioB04iO78pJfX+gF3NyV5zi4VZagsXa5beEtnrMNk4/96baUZYcslyt
         K4EWaq1Zs5HT++KorqJGefX8QgsgwDM3JEsm9QwxXQOMw0xYTmlCIQzvMbeLBxw+vHq0
         67NyetgFIGU1Yigpn82Nrf4smzyQ49vOf4x74JrHDIhhb43YpfGIFq76PwD9bVhLBPCs
         SqLTw8hDW/PwvqgOyLTayAl+pSpepJeYxsuYuMc+l6TSFt2AfAUfclssIFWzyaHXxW90
         UruA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793222375; x=1793827175;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qyE3BvZ22dE3cQ/ON5Q1I/RqepT+3oR0Tr4bDbH+x1w=;
        b=r4mRv72ZVLxcE8KgvzDuGfD8fXxhRXWq752LT6v/1e+86+EjAAEp7q7kqlRhyIy3xU
         uXvgfPr6irBHZ8iKQq2GeIN+7BBB2UY5s8yZDEzsTgn0yfbrub0STMhV7PP00SJgRLJS
         pUAbIS4eSvIq5UNMnu5YgXlSzDVQXXuGf3WISziurXNfY7Ez73p7tK+aoJ7Sqsw00hGt
         o18Ux3ji93LYku271dttD8M6EQQVbsOzqPTs0GSUzLGB6e//k1Hw5XQTv1JRLKl6XXRi
         iGjYRifl+ah4eF6Eo/rDhApZiZ4uCEDrtYTEfuMdXSLG/GW3ARabG60UI2gXqGjuDUzw
         EUDA==
X-Gm-Message-State: AFq9FYK5MhS1iMaIMW5JJUiNgl8a9ZXT9kco0mGgQRKVeoMldjMW+c2d
	7qpfaK8abUtFsDXe/mLEiMqQmNBfTpm7zl+WmDoQjFJdgMLF96QkeW4KAkj+/93jGYHM6hXD7Am
	6stjqyq4=
X-Gm-Gg: AYBFou3PYMVxasO1KE1I+4yMokBmO8hxBnobwoOeDD0gjRPTfkI6Xs9JZ7VFhxeBwD2
	eJ3mX/ghfp+HaNDL72TV3j9aqNb5Ls4rVJprKQA8NnuQFPoZxCmYVXgf+Czl9cXjCa9Qzu6bQtG
	vF3rGNOv82wE5SoQiHjrerpPbeUeEkvPoO90gpDn9ZGiUCXvp5aZ1dEYPxZ3X7hMfIOhABE2ND4
	Ve/+YgXSvtKR+hKOk1VpLvD3GJ28NZXwg/Lc4UOLI2Yb3P2uINzau39LM8tZ+gZPIWJ5U6HN61M
	orIiFbG9D85toD7UWEoIqzO8oToTL/sVCyR1KmOjN1HVzUQMR9BEhgiMGGHEAT505huj82TkK2J
	NK9A0b1OGnbdUoKvC1p+LZ4llo7qCPITy9eXLV54LM6EgTFGgfmSh1waXho3PXINBCecaM234FI
	9EBoL5YbNatkCkE/pzrz3EwsOY4ODtsxEXndkvCaFmqjolykkfJjSeQAl3dV1aP6I3gU+SStECK
	EbtrcBwpcH7AmH4QdDgmJU4r92o+j7xLy/QftbCw3whIebSKaASXPNP1seVcPdrtFJolz4Btxvy
	YZKfvjoVwK6oymEUYX6YHjQFs40Zv0Np+Tgz7UlSwsZrziVLzIpsOk8/LNQcrpsI6DyfA3kiLQc
	Xc2LSFOkY4K6IJ9U=
X-Received: by 2002:ac8:5d47:0:b0:535:b506:11c6 with SMTP id d75a77b69052e-53fcc7ca8e2mr64934561cf.57.1793222374554;
        Wed, 28 Oct 2026 14:19:34 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47a6d598sm139778966d6.3.2026.10.28.14.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 14:19:34 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH v4 1/8] mm/page_alloc: reset can_retry_reserves when the slowpath restarts
Date: Wed, 28 Oct 2026 17:19:23 -0400
Message-ID: <20261028211930.3504634-2-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028211930.3504634-1-gourry@gourry.net>
References: <20261028211930.3504634-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 87E8C1C0004
X-Stat-Signature: xqx6oi7s8678bsy5ie8e9rk8oq1yhfox
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793222375-543888
X-HE-Meta: U2FsdGVkX19USz/rVhw92XI7VxQTwM/7QVwJ1k7+OHoS/Rn0qHTFOxJiRhLDwKVnIOXAIsocsITd1KxRQfwHImfnyk/n+8kixZgD8ukZeSn4ew6QHqVc7u/yf3/O3+KpeU5MCTveWSTcp0St77XiIvWphuOkEiKryluom2qjHg/9bu5+Y0IaD2Cg03nZXk7K4pyUh9Fw+NvsyWVT5CgT+N4vfisnhZ4hIh40pOvs1+/Ugf0i6dlReE9+o1yKwqLGPqXiiNz7HBtQp3NDUY82PvlZj0qXrogUVA5rirl8k4ChWR0O2FDWuLmiCVWonmmjDx8vPVmhZCM0a8itJoAAItf0xPYO9+nc7f5R3+YW7+ERafkekYbirBnpS1WayimAq5AtVCf7lg92f3cHQiRw8tHX3pN6AHjn6tMulpD577awj7/u0pnrYGEjNSFIe999UGRoRIuj2hqcA47WuDhOaCRJzpf7R36chcVzYgOaEw1tB/TPhGtuH0K+xQYP9oes15cef5iVjIU420lrdytrc6JyXQ7sgtjAU5eAbmUQ16DXyTliHIThBR5Rc10Z/rudttmfEx9FE6I7SQubc6jf6Wz5MDQBrDfJJeqU52FcRdDwQ5ceJGpWtEofZ9RPcgA2tcfqmaYj9w0lABEErtNf6yFNQ7n5zRml9w/MoB/QFqweJ7d5xXk+gafhk3UwH73B6dUHnpIC5ze0rQdOwTq4cebxaXyCIigSYObJzTWPt/pP6j8QO4k+aIWnBU1+RNEZGEV/iNMOvubRY4eqzAX+qsjdwbLMPQp80lYljhWrin/yidalnqsOTI85euxtDZurMQmnu6A4TAxP3N14coFhyHh5JmbdQfavhSpMm5oCy8NiuM96/qrAdYjbgltC2oT7uEz7kmTr1/C6NFDfNYoJmazx3iezGX5WqqC+n+VrtxlVkhXzANO480qeeicS/0yQK6sqlyNxDghBlgMYIoV
 0oF87GEN
 mU/oQtBw2RaZkR1JT7+VggyFlgnL98dwq/k8zvLlpszleBw2h0baLZUvBh0mDvDAwgf2lX6TWsMxupt+MzRxuAVGdpjZEofmoOMUrZo6/Mdb4klGRJsMLvGFKFuWoIUtzbfP/RO6W8g5jz0Gnn9oplFDV5Vs7Eyoi+Jo5Yj6zhiCm4c40mtIqdkkY1U5Q6jxjm5cmTy+LJVRTj93y72acMGt2Z9ZRqZnnNpZrwt9LbIjrAnqht/XtkOZSF22YvyQ5R6o433PpuV/FBqEzypytnAG8xbi9rwu9BrZl+dFzGIkaFW1/GV3XL9eWMGZswweSMCIkWPl6fn3DaHepzHwhVr8yUkzJ9PkkTcmz7UKPTV9+vjyqLQFSIH+gAA8XRCDjovBtaButddcpLZ6FwtO+lwSyjUIuutJV/BBAb0ipJbfGS8IOclIwcgBBHXJgbgJOs+lF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 2c4c3e29897d ("mm/page_alloc: simplify __alloc_pages_slowpath()
flow") retries an allocation once with reserve_flags when the caller
becomes eligible for reserves, guarded by can_retry_reserves.  The flag
is set at its declaration and never reset.

A restart after a cpuset update or a zonelist rebuild drops
reserve_flags and comes back with can_retry_reserves already false, so a
caller that cannot reclaim, such as GFP_NOWAIT | __GFP_MEMALLOC, fails
without trying the reserves again.

Reset can_retry_reserves at restart.  Only a cpuset or zonelist change
restarts the slowpath, so the retry still runs at most once per change.

With kprobes failing every attempt without reserves and the first with
them, and a memory block onlined during the walk, the allocation
returned NULL in 3 of 3 runs, and a page in 3 of 3 with this change.

Fixes: 2c4c3e29897d ("mm/page_alloc: simplify __alloc_pages_slowpath() flow")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2daf358269ae..78569ac6f2d9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4783,7 +4783,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	unsigned int zonelist_iter_cookie;
 	int reserve_flags;
 	bool compact_first = false;
-	bool can_retry_reserves = true;
+	bool can_retry_reserves;
 	unsigned long alloc_start_time = jiffies;
 
 	/*
@@ -4817,6 +4817,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	no_progress_loops = 0;
 	compact_result = COMPACT_SKIPPED;
 	compact_priority = DEF_COMPACT_PRIORITY;
+	can_retry_reserves = true;
 	cpuset_mems_cookie = read_mems_allowed_begin();
 	zonelist_iter_cookie = zonelist_iter_begin();
 
-- 
2.56.0


