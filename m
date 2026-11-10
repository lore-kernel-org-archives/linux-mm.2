Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7F6360A2630
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=d42QnZwE
Received: by kanga.kvack.org (Postfix)
	id CD2276B05B2; Tue, 10 Nov 2026 06:24:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C83756B05B3; Tue, 10 Nov 2026 06:24:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98326B05B4; Tue, 10 Nov 2026 06:24:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9AF6F6B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:24:36 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4081F1A059E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:24:36 +0000 (UTC)
X-FDA: 85418976552.29.7FE564E
Received: from mta1.migadu.com (out-77.mta1.migadu.com [95.215.58.77])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3F256140003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:24:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d42QnZwE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.77 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794309874;
	b=l5r/VKSXpDGkZgQLGyZnN23JA9xqveJWYY/bdsYOdzDlUc0GxriUdzkMuby76XmLZoId8L
	PB3RZ802HhIgBRGLQAl/6IP52JU+HTxnyuSMPmUbpTWylkqshqYsXjoKVz4NwDjlFcGD3v
	lY68Ub+/DSXNXVd3gPCXtJAal3CIiKM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794309874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ZVwT9JPvcRTq2+d66tI0z/MQ/l0urBNTSlvpkLaL2M=;
	b=yZH2tJyd3QEBCueejyc0sLUa3F6+7ilLf5TaMDyWqqjRXC8O6vPE+I4qy761FBxIaypy+A
	jYDo9RnRxPbiJPNu13A2m20Jqs6z23/Q3x8PsRYnVeJ2ktrQYcvzS1xXrCM1M7Y7viaVbM
	8ywkeAu0z07s+XvwY2dx984bQJD/0MI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d42QnZwE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.77 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jkqaTN7aNaAhIxRpBgAN2fcj9pQU8jMWqyvdyAyPO+g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794309872; v=1; x=1794914672;
 b=d42QnZwE/WUex9hyCFK+onRk/zm7eIFT8JL5ZzEBQjF6wv/5LUNkcW1452q7+jBGpM/61zy8
 2qFjJD3ycPtGdP2Xu80odf+Qi8AJqkOVIRJjw1M7QfoacnfSGPaHXvRiIZR7lhUddg/s8e1KheQ
 ZcmADtPZGwdbi19tOnzD2V9Q=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 272fed88d5b8e528;
	Tue, 10 Nov 2026 11:24:32 +0000
X-Mizu-Trace-ID: 272fed88d5b8e528
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Uladzislau Rezki <urezki@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
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
Subject: [PATCH v4 1/9] mm/kmsan: undo the shadow mapping when the origin mapping fails
Date: Tue, 10 Nov 2026 19:25:38 +0800
Message-Id: <20261110112546.261415-2-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261110112546.261415-1-hao.ge@linux.dev>
References: <20261110112546.261415-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3F256140003
X-Rspamd-Server: rspam12
X-Stat-Signature: msf99xe8mpxrwmbzuo3snjd974xx6yum
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794309874-322202
X-HE-Meta: U2FsdGVkX18aKP1VkxEsthEZjO8RFejY6LSuW8ekCg5dnZ0o/cK5neaHsZh9xEKK4fOLbq6sQliWzv42V+HIwEV7e+fsLwwts90rphyYgVTJuigWUt9K3aMBhBgwL2+tIzQWvuWt/81obPEMoG7zeqPq+slVoWN9y7iErZK0YkrWp8nY2zXq9CZmmFin+TBo9rdK0YfJXJGq9CcA4/MQGAv0ZmS5k/vvApdCyRneGw5LamX7MPW97T7XZx+LmIKb98LqrCsY30EUwkPJRmdu5dA9Gwu6r+I8Vxndj/dgUKVn0BqkqIZ9VbJiworfCIX5H/xPwbOD4ODUdLBkcKT5glDF6CnSY7vyVZJHAsU2eN5vU36mhVUR74PDvZIFMAnKAS76x1y97LSVwNDforVawz7kXi6f3Ij67GLp1MbMCAeBkjK5B33JuaTg8vBhQOK8/JfRFaUU7y4sB8db6VKtCoum+2AvAb0D4n/yovv9dPgLNgaKOBYDwyT1ydm+iI/jiHSGyM9+tmbTGW8i3w1M5JfvDshlFovTCZDHvhykdNrYe7tx+4roIrg94bMY2+HP1hqOX6Cmxi5bkPczJepWEyAABRFW4CFoP4M2xsh0uyTffcqyYx7nWKFtadWxLgm+iHIW9mXbJNCC+tXCjiiu+bQ/QPYLiow2exuy14s5A2DOao7KJFGg2DbqAZZ80DcjPt18sleVqVyg3qOK05/nYFjAwXtcoLQgtZVolKP79QHtQj84Byirhu0iYplpOBaoQXFzsivteXPbPd5063drGrhf6FkeRUEM/0uiHpDbCpfF4Aq1XmaFTsim8LUfGr4kCarWtJgtaSicQ0hW5iCojSCXkF6L8OEGaUd/tRedbISinZieCL8cERav7licMDjyYzRsk3KHZUpIC0zMRqIHuFAA5t+WAUWOLO+O+B5PECX4x8WI9eQFP6TnYYs8HAojF3xxRTOY/hwvYZx+f8W
 TM5mYn74
 qPmEymiOwvgWqxkUCWIHjkUWzS0DlmFTOVilQo0sxF51jqGV9x4k1jxxaYcYSKRLUH33/RkblTZ9atCFGRIGU6encjQoMQFPVED+qX1mDy3Iz1bogCs9v8ks/DH++XO0DGtJitpwIJqWydCal6TT3B1UHVpBpgd/d4GCn8gbbjoS6+7WTtiBJjFb3iBH+FZ9nQ41zED0EIrL0uKyXb5phtI8tkog11h+Nq3jIpXvl6kFQwjk8KHujCCwz14s0mB7Iv+ApdFz+UMgcOAszzdqFFzzeVQIjFQvKI6/lN1c31oLrNJD+/+RLtjzkAIGB/SXc8NYZ5Q/MqUzKuytgZJAdYIbkvdziOV6exejfBwCkOOZ6wqQlP52+9/AriM5gUPZ+jfZ/j6eWfjkYZnSo7vcDuQIdNRRde0YcSdLEUMNbgxeaSpAx2mQBFlaLhNeIAz2fEtvzbal3QIoiJAbIYie72V2ueV9G7RyoROtPkKFiHcKcQKnIwmlSAknzN6tC2yNgoJ+pJqpVZiKin+SyjrXKYMUwpVbTBsgYPXHzEd6i8c6HWkl0Ein3bga/akiItXhfTHHCDL8fnT+nPaEYeC3jFY0nTL6yqegnItHv+Z/scEDoPQk=
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
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/kmsan/shadow.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
index 0c88d89bf0d6..2166086d3dc3 100644
--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -258,6 +258,10 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
 					    o_pages, page_shift);
 	kmsan_leave_runtime();
 	if (mapped) {
+		/* Undo the shadow mapping set up above. */
+		kmsan_enter_runtime();
+		__vunmap_range_noflush(shadow_start, shadow_end);
+		kmsan_leave_runtime();
 		err = mapped;
 		goto ret;
 	}
-- 
2.25.1


