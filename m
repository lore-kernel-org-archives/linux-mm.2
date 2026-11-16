Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68425606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nU15+g6Q
Received: by kanga.kvack.org (Postfix)
	id 89F3A6B05B3; Mon, 16 Nov 2026 02:13:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 876AC6B05B4; Mon, 16 Nov 2026 02:13:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B37B6B05B5; Mon, 16 Nov 2026 02:13:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 603456B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:13:51 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EDF601C42A4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:13:50 +0000 (UTC)
X-FDA: 85440117420.01.D41190C
Received: from mta1.migadu.com (out-213.mta1.migadu.com [95.215.58.213])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1C35640003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:13:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nU15+g6Q;
	spf=pass (imf11.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.213 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794813229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9qeNI2RHXZCXvhzDDakVQtkHGPRaeLXMhl6FMpu6bHw=;
	b=qnu21xelhw0A8A8QKC2z7izgAHuIqMiH7D+WI5+5TINvoNtzAytdSvkiRVkK0KK/REwbkl
	ZMdmtabTF6n5FIU+kLSbJ1rYzAq6IAgX3vvnTIu96lpBhtslS+JsL7xKAqKZrU3kDv5VR8
	XieflaZR83Ev5h9cOjPUqUgkpf6JulE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794813229;
	b=XWgTQMugnCnbCPrl+64n7AHaRaHbMG/laWOBYdZ52bdN/yQAtKno6KPDmSSonFJvE5dyiy
	2aw2aJvfAlc7ylPu5/4PrPviRXNI/sxkrHocFrqVTRXqKa65Zfkjpk+gJLwTmfw+wZV0NU
	KZ/zvaHMgO/sWPMzfkQ8eohzIzaGME0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nU15+g6Q;
	spf=pass (imf11.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.213 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HYLuc3Z03vn3hRM0Gt/LGf7o33deLempu7jZPgTKBzU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794813227; v=1; x=1795418027;
 b=nU15+g6Q9HTaGT+miFGfGHMPjGWb7cORDoEa5n5P3MH0yxa9DNG/JyTDSj9BR65gUJ5vob7O
 y5UDPO64mHapryatDOO8bqIaNQvgqYeBr9zvdXwzMcZC6pyCcPzgR39tSCVJ2YJeAsD21ULMd4H
 3y0HAq6MGcSIbAR7cZdqQGI8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0051f0c538c6aaeb;
	Mon, 16 Nov 2026 07:13:47 +0000
X-Mizu-Trace-ID: 0051f0c538c6aaeb
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v5 02/11] mm/kmsan: undo the shadow mapping when the origin mapping fails
Date: Mon, 16 Nov 2026 15:13:16 +0800
Message-Id: <20261116071325.263682-3-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261116071325.263682-1-hao.ge@linux.dev>
References: <20261116071325.263682-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: k67j7dfbpuicu3pfbsybom9nea9tagja
X-Rspamd-Queue-Id: 1C35640003
X-Rspam-User: 
X-HE-Tag: 1794813228-479404
X-HE-Meta: U2FsdGVkX1/mfOU1/D4ONc9w94wezlJKkLkd7cZMSgX3w67A0eHf1058k3ciPM+W9sCZvLsNsom05JilvMTVnAVTFEI4SN4bvkXAxDmwIv/6hvOxlkHWrs2e3cpldqil6B0WEQ2c/Xv+Jm1CLk7i4FTBmPOV2iogTxjhzDhQNTgyi2A+pKCD8J53siODqKhB3ooKce4unG4wzrCBJF1279Ct9H+DAjdgE1ikRyGd2dBC76rA58QTAQr/1PcYKK+1fBoDd/5cZjOoowmCfhbaJZrX1SOTw8E5A/v90Cw/9iYBQA1VcxcHA4b7SXAxgiVWSLy0ZoKY8doQd/v+zgOX3e4EwblCLu+gvIy9T/K3yFXrA3s7S8M0HC7jTsJ/Lrwa+oBXxwhtnBouNFlMzhWmrlPJU0OhwEfyJ/BGhTzt3WiZrIpFdFYYAOg1E3QqAmo5HM4oat2zcPjUndn6csjWx55pgeg78OEceMRGfpV6iN88DayVKTaMLP1gFrsHXNKcmu/DxG/BggJX8jWjl+QiGAJRJvLLMiH9BmIcD7W5nSRVPaoKOz4wZT5fip59uf1lJ4BlLNyR0LMy/a1KWxrJSFHVdtW0dkXVzP6JCoJ0m1hr7hujaBtEES3aK5T2V0zy0oCSvsKSRmv2yyc1RviKg2SXXyztIasU70xQ0C+f/b+3nNvfmYLr/OOFeMoiDUpDJpGQYqqAWrL4d5oNgEEHqKGtJyljMEIchhVd+oVNKiWk5suCFaCXdX+0HE3QAXW4sgsB5z0TNT7VCR4i2UXvXgQYEx1TQppej0Mb2yT3jC0vFrLRjAZ4bHkfBv82+GPZB5umWsCEgIidC0Ink9C7oeftocRsGMxrju3z+LNjGqANbTKUy5XzL+sjdgosep/C8W+91s7VpbUZ//zlv0cJtpgWQIrasnbVyk7WauxjdOMHAUkQG63yinHSfAoxxcmfh6yZRIHJy5kJrqOv0rh
 Q75t9ut0
 O5VS2s1NgCxO373Z0eASOdn2Mx4LfcRNy12zXaMD8PGE+R7/S5C04WqLzKKZRXP5qXZT7ktDCuCFiT7tilhA2O69EE6JGlgdT7Fc6UcRXbdCFNMQao1cxsgn8kEgxcojTC0HgMtrfiAJ44d9C43xWrmhtsxbLggUhDeBeJaIybcq9BqtHIrEm91R0EBKf5CO8pmy05370dKMA1F4gt/2AiPBi/gvWFscKoqX2Pxozxer0oXqxcPobZNr6LnfjdEJeJ9HbEbUhuuvT7HFKeHC8EwMGyywiy+uAL0W5/UzASj0GbOa1yh8jYoBOn9KyMSD52r2tI2YSQD5ILQ+cNMw70VywtE80ZQ44UK3J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kmsan_vmap_pages_range_noflush() first maps the shadow pages and then
the origin pages. If the second mapping fails, the first one is left
mapped, and the callers do not roll it back. The next vmap of the
same metadata range hits the stale PTEs again and fails with a
WARN_ON() and -EBUSY in vmap_pages_pte_range().

Undo the shadow mapping on that error path, the same way
kmsan_ioremap_page_range() cleans up after a partial failure.
__vunmap_range_noflush() only clears the PTEs; nothing has touched
the shadow mapping, so no TLB flush is needed.

Fixes: 47ebd0310e89 ("mm: kmsan: handle alloc failures in kmsan_vmap_pages_range_noflush()")
Cc: stable@vger.kernel.org
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/kmsan/shadow.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
index 0c88d89bf0d6..212449db34a1 100644
--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -258,6 +258,11 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
 					    o_pages, page_shift);
 	kmsan_leave_runtime();
 	if (mapped) {
+		/* Undo the shadow mapping set up above. */
+		kmsan_enter_runtime();
+		__vunmap_range_noflush(shadow_start, shadow_end,
+				       gfpflags_allow_blocking(gfp_mask));
+		kmsan_leave_runtime();
 		err = mapped;
 		goto ret;
 	}
-- 
2.25.1


