Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B56F3CEE343
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 18:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DB976B00A1; Tue, 18 Nov 2025 13:22:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B32F6B00A5; Tue, 18 Nov 2025 13:22:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F01A6B00A6; Tue, 18 Nov 2025 13:22:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F31C36B00A1
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:22:25 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB395B65B4
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:22:25 +0000 (UTC)
X-FDA: 84124547850.25.65571B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2874B1C0004
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:22:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N2Lpuo2g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763490144; a=rsa-sha256;
	cv=none;
	b=iq3pvs1Tuu1ZREeuAlBkMmQVf40LDwFRHLIyn6qpS9KqvCXFAXf5xLEbHvMY7I7+vITosv
	v4gKq82oKwaxaTp/MrddHv4DChh2ztTgFcuRPXneS/jvTxdE/QsI0ZdEzHH6CcPlqq58VW
	RdvPDSJOWi3l4lXmYFrhCkFUzzA83g4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N2Lpuo2g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763490144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=394+H/Toca3IhEDlevEbnwpMVzzRkjVMci3ILAhLtJM=;
	b=bRhknod11Zot9JJXxbJP1iN/OpXN/idnyJZhhYuOQMA9gBt5Hdxm3LgHPYgnLSKO0bZNjq
	NGNCColug5+8gxFCwAYQlkTPAiewVJEG8SdfR4avkSeWPqRgLR3bRdrTr4z+DSUWMRAl73
	Ve+6ifvb0hd2lBW9w2kLyP8n9FPWogA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A8F841A35;
	Tue, 18 Nov 2025 18:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E85EC116B1;
	Tue, 18 Nov 2025 18:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763490142;
	bh=uzS720AirCAjrMk0zf7E+fhaADPKoEUqjQkc9kLBcHM=;
	h=From:To:Cc:Subject:Date:From;
	b=N2Lpuo2gjYgnW1qXmgvYExPmrxjrbXMnmciJEvMO2ppCTNo9jYroJ4Qt5fNf5Dejm
	 2Eoi5IKxD7jLGCpyN49cQ3ynn7AyFb4n9DveQ+GsmXnBX4wsVd/0yJXJ4PbYF3JCOU
	 2HbUAWCaJtfVer2FyB7TzlipCCzuWoMpHlykP8oVOjdtALt6fBOrzVJN5WU55CbhYW
	 pYd4sovXWm1lsYK/3pSbyup1udeW0/RTPfRXV/OIgaKEcs1qCDPQPStXxyJPCpyEL1
	 g63+BWAOExeD3zpDrPJyBSmqeX6T3Rk+RMfbwdTvw48MsE1DlszyWusQ/efDdc0vS7
	 yP49q1AvL5VJA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] kho: free chunks using free_page() instead of kfree()
Date: Tue, 18 Nov 2025 19:22:16 +0100
Message-ID: <20251118182218.63044-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2874B1C0004
X-Stat-Signature: 53riniike5aptwai7wgi7p3ut16c1jug
X-HE-Tag: 1763490143-266172
X-HE-Meta: U2FsdGVkX19tqLlynNUHi9dm734GB1gMSd1ETr8TH2wG0RPJUztNcPoNIEPBa5XeCZXjQXB8x5vHbfaMm7gPIZbGMvSq9iythq1az0dxhUKVuBhirXBoPr0ulYqeC5qGOVaBJs8Oww+uEYXjV7ID6nkl9Kl3UEXE52+6sxQO04iyP1+Be1W5iASuyPXzRprLSfHsLE1gOsErJqRdzM7eHoU79dMtfF18sQuSuVmBpoAErIjlm1RA23sSVKPXCO8WGq6Yvxvvvk7j7G865MCVS4O4wFPqIyUCH5I1R2fwbby4TKD2vikKn3FMXZu6tMcJ+n95JZ8Rup87ptEjlTcI2w5CkvrDsZq4iD31Nb4bAp3m3qF9YRVVEd/0DYwNaq1FsVXU30ks/kHa06G6QGTYj3SllIzr9Rj1PIB69QODE6FF2EvLDM0yjmIGSYoQYl5DsYEj2ZeHrPyhyj495hs4wSc3xRisFIYThhmsRrN2X8NdkPlZL8+8ytmcLue5e/khst76VLc2To+yy4gOqUQzVc6alqATtd81XzB3f378LT13dX8ZRhb6/mo1WPkQu9Ck5vbNNPlx+KuHPI3XlL68ZidRQK4+NEBbNMbSQrOlCwKcgiSSZ1PrIHhYyPaipRS2PlVHmPtoirTEwT89Kggjo62e2+Hz8j5BaD8Qyy9jwkdzwBS3p5QV+3GkomvfFzagrkTCTA2IqJwc3znE5g0Go5e9n9fgsnrnreGUuzlqhwl2gj0WD1srVykf/vHnNPgyI7bP0SCJiMu4WES7ayPDHIaw/iOTfSFG/QgvUv3WhqrC8Asb27Le+77ULE/q3Bc8CYKfTU7VRkNcpaD023LI9zjkzXdjF+lXPzcHz/QdaSBlVYpYE4q7npiwPu6gK4aBul0hJNZcyGJfyoVvXdBsGPY0j1+/FbGpQlfaXOow8KFOTGxGHYGjNXgN2O7MeVBvLq/ggWg11u2BIjB3nOL
 50cw0Jlc
 K9L+3RwlknfcCzdRZdIA64vyih+KYIlO6L6yz/XxB1QPMplKJ/HsKBO68KJnxi8WuutpfFpzQYoQTWaLGR3jFk5lR3z/tmb2c2RGtUbOl09/T2TCtKkZ+lvn5ppK0PjZIItrYZF2VJkgJAiAAT5wt3rdWzJW17xwxr7E2u5HtP6g3kdR76tB6/i+Zw6OYv6MIVqYQndNm/7U52c2KvXzgJIVOglwNxlvetI8ZhNjnziOmVI89ujR8VoxAy/+htDU98oUA5WnBnDN8uczoWEA+ifpsrhYlbYHVaHEhVkPxfxs8yWgmur7HjE4hSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Before commit fa759cd75bce5 ("kho: allocate metadata directly from the
buddy allocator"), the chunks were allocated from the slab allocator
using kzalloc(). Those were rightly freed using kfree().

When the commit switched to using the buddy allocator directly, it
missed updating kho_mem_ser_free() to use free_page() instead of
kfree().

Fixes: fa759cd75bce5 ("kho: allocate metadata directly from the buddy allocator")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---

Notes:
    Commit 73976b0f7cefe ("kho: remove abort functionality and support state
    refresh") made this bug easier to trigger by providing a deterministic
    method to trigger freeing of the chunks.

 kernel/liveupdate/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 515339fa526e0..6497fe68c2d24 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -360,7 +360,7 @@ static void kho_mem_ser_free(struct khoser_mem_chunk *first_chunk)
 		struct khoser_mem_chunk *tmp = chunk;
 
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
-		kfree(tmp);
+		free_page((unsigned long)tmp);
 	}
 }
 

base-commit: f0bfdc2b69f5c600b88ee484c01b213712c63d94
prerequisite-patch-id: f54df1de9bdcb4fe396940cdcc578f5adcc9397c
prerequisite-patch-id: 800ec910c37120fd77aff1fad8ec10daaeaeddb1
-- 
2.47.3


