Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73352D4A5E2
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 02:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58676B0005; Thu, 15 Jan 2026 21:32:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C06866B0088; Thu, 15 Jan 2026 21:32:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B12066B0089; Thu, 15 Jan 2026 21:32:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9CE716B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:32:22 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 33DB158E44
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:32:22 +0000 (UTC)
X-FDA: 84336252924.24.3DCDCF4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id BA73940012
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:32:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xy+M5dZs;
	spf=pass (imf04.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768530740; a=rsa-sha256;
	cv=none;
	b=vavm/CM3CsM6dQmPmAgFCFxrOHfRIciTuPHGFgBn8CYfXivf19V2U6uHe8AEewc7WanDQI
	a+bgORulEr6sLNlM8ujfFjpuPnC7cSgSodO4PN5Ccdw9t+iuJZ0KR86kf2L+dIBEDSIpte
	lAJfSqCg7+hJ5sD0zWWx/Hfrp1a1LGk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xy+M5dZs;
	spf=pass (imf04.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768530740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1J/sqBQMvvwKfGH1gikCATlYLSULx3+mykhMgq3a+tw=;
	b=JS60+wJdfjHEArGktcZq4Vq7KIdvNpI/bdFqeba196c7z26KbE8o5RjF2Umoa3rqWyLN/p
	Zz/3ADTXjRcUiUYUF5JIgojoofUJZGo/gmdyVljEVkNIvfhGRVb2TrhuCuK+z9m7yWeeDZ
	L3Aqd3YFRREQ33FfL/Mz/ZcsWOE8Spk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8EA4F60160;
	Fri, 16 Jan 2026 02:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF32C116D0;
	Fri, 16 Jan 2026 02:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768530739;
	bh=50lxjWm2xLHtsHn/f7Sy+PMwP7CKRZI/eYECykWLSwQ=;
	h=From:To:Cc:Subject:Date:From;
	b=Xy+M5dZs4Q6by0Gp0XwqJ8DUZd014WGYO31wGuNYzFMQzoes089vGjHJw04OTMTET
	 5IAe9TecsiUAqbd7OL/d7KqVHGPeJSeuRLxQANDDD8Z6CvXrmdizCWoPTAckEUs8M3
	 aZQK0VcDj8J900jznU5wuX59qLqzK75GhTmlhWIGxRPOlJaOZ0mUjJCt62nsh9lNFC
	 m1GoVL9u80DbPEyh+7AJ/N5xWU+fZVo+l6A6VN43Ad64gmrgy+4sKzMPDzw0U3RClz
	 NT0ZAWYUxA4wxcWegVLLLklqaypHk9Dvh+x26Ekvn5JwfwDWBSzqc1jAKutEt6/bkW
	 sHzy2GmaRo7Uw==
From: Dennis Zhou <dennis@kernel.org>
To: Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <clm@meta.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dennis Zhou <dennis@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v2] percpu: add basic double free check
Date: Thu, 15 Jan 2026 18:32:16 -0800
Message-ID: <20260116023216.14515-1-dennis@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BA73940012
X-Stat-Signature: fi4p7pmaryf5jpzfnew6aocp4a4x3jhh
X-Rspam-User: 
X-HE-Tag: 1768530740-391688
X-HE-Meta: U2FsdGVkX194dLbkLUHibBBHWAp8jS+9KbbH02PVB3BODYbL3+UimZyclZUW9wwFdVxZaeKkbxm7HA9gFELYt6YduEUoeWvEl4RsgIy2LowU3VrtNGLQRf9XuZdz+Dvw+bpme9IgAOr9e5+eTA8a6mEKkt4CuOFoF1CuiPGRhASL2wGJf251kF4T1T2ZzxN1UF7zBuCsosmlbeqlAgbF0oMH0MZYHxoc4aFq/xXuYWYBvnAnTq1BBc/4hVxFKNLegLywpHY0BOwGPD2DDamHgufFcXZ4fsZj7DQOf1qt2E55momfhXTzyy3NNtKea+7FUVB5PWFmLAKEcbsdEq5ECKclQoCIHcC1uaKMZi9TvVj9ImsfnGlmg951r8cFXWDAFmiuE0J+N5v+2lBxIMKFNjAJ9By6n4Phl/uG9mR46QPWi5ua6kP+3sY0D0bamDjYOWoIM/BSwLBdKSa1eYZv8CPMK/+CKwxsMAzh/8LvQvvmshdldy2zdRDWDVxOBgV8/2WslwZsUovErLeRq/9fGDFDdSV9Wx6xeyX21NebP4VopWiHNdhLKtxNOiRh1nuGMQfInQmu6FJGCeXjZ4yP8jhAeBCJI09wgYN37B/F/XFK9+CozD0dCYPOmrLI/gHGif/Me0xsJlCjb3bXpIu3CY97aqFl10xtsIr5NOGyrGN4A9JGVW+EBRvk80M0gpOAO4CZ35aVb93qT7Edj+rOVN/b1T3tijaYUC3n5/x4U/VHKLzJaGEABAjMY6ECw81V5MEWYeuPuGhZmacJ1Y8AYYn3QB1ub6XbbMhuCaLaM0xCP7lmr/mGSx+bmKBXviX80O7Q2RB4HhF4rNlGlDI8ak3iEFfNEQvsI7uG6uigQmETWw7tNty82HEsLb+4WEYHePdRoXHkLzOV1kOLgjNhm+anv/We2NhHlEZeBrf2R80dOnu1hH5A2+VNX7peFrNub+Swl/F2WcvAjdVNFIB
 CCHF3Cfm
 gDQvhXvMwwmD02IBUGNiJOGmV9tf2SfRjR+ryPCzSk0A6qvq3U5Hr5FZXwF6nyq8iDouAg7vMEBZRQ5ZTz4S1DJue2SGfDN+qrSSBMeHbjcZgsA9UoE0AatN0vKKNJcTNkjCm1fgTQWZMdFj3CYcW6Eh209Sv/CkZ0fBfbgVnPIpTnt+h8Mzg58BU2wuhReVSJOgKtHOiv7ECTufKHJYCvIEymkcnu+RDnYKD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This adds a basic double free check by validating the first bit of the
allocation in alloc_map and bound_map are set. If the alloc_map bit is
not set, then this means the area is currently unallocated. If the
bound_map bit is not set, then we are not freeing from the beginning of
the allocation.

This is a respin of [1] adding the requested changes from me and
Christoph.

[1] https://lore.kernel.org/linux-mm/20250904143514.Yk6Ap-jy@linutronix.de/

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
v2:
- moved pcpu_stats_area_dealloc()
- added additional check for bit_off out of bounds

 mm/percpu.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 81462ce5866e..2f1ac2059a15 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -79,6 +79,7 @@
 #include <linux/mutex.h>
 #include <linux/percpu.h>
 #include <linux/pfn.h>
+#include <linux/ratelimit.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
@@ -1276,18 +1277,24 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int alloc_bits,
 static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
 {
 	struct pcpu_block_md *chunk_md = &chunk->chunk_md;
+	int region_bits = pcpu_chunk_map_bits(chunk);
 	int bit_off, bits, end, oslot, freed;
 
 	lockdep_assert_held(&pcpu_lock);
-	pcpu_stats_area_dealloc(chunk);
 
 	oslot = pcpu_chunk_slot(chunk);
 
 	bit_off = off / PCPU_MIN_ALLOC_SIZE;
+	if (unlikely(bit_off < 0 || bit_off >= region_bits))
+		return 0;
+
+	/* check double free */
+	if (!test_bit(bit_off, chunk->alloc_map) ||
+	    !test_bit(bit_off, chunk->bound_map))
+		return 0;
 
 	/* find end index */
-	end = find_next_bit(chunk->bound_map, pcpu_chunk_map_bits(chunk),
-			    bit_off + 1);
+	end = find_next_bit(chunk->bound_map, region_bits, bit_off + 1);
 	bits = end - bit_off;
 	bitmap_clear(chunk->alloc_map, bit_off, bits);
 
@@ -1303,6 +1310,8 @@ static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
 
 	pcpu_chunk_relocate(chunk, oslot);
 
+	pcpu_stats_area_dealloc(chunk);
+
 	return freed;
 }
 
@@ -2225,6 +2234,7 @@ static void pcpu_balance_workfn(struct work_struct *work)
  */
 void free_percpu(void __percpu *ptr)
 {
+	static DEFINE_RATELIMIT_STATE(_rs, 60 * HZ, DEFAULT_RATELIMIT_BURST);
 	void *addr;
 	struct pcpu_chunk *chunk;
 	unsigned long flags;
@@ -2242,6 +2252,13 @@ void free_percpu(void __percpu *ptr)
 
 	spin_lock_irqsave(&pcpu_lock, flags);
 	size = pcpu_free_area(chunk, off);
+	if (size == 0) {
+		spin_unlock_irqrestore(&pcpu_lock, flags);
+
+		if (__ratelimit(&_rs))
+			WARN(1, "percpu double free or bad ptr\n");
+		return;
+	}
 
 	pcpu_alloc_tag_free_hook(chunk, off, size);
 
-- 
2.43.0


