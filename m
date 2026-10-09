Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BFA4CA6012
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 06:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58D9A6B009B; Fri,  9 Oct 2026 02:35:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53E5E6B009D; Fri,  9 Oct 2026 02:35:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47A936B009E; Fri,  9 Oct 2026 02:35:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 26D136B009B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:35:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 401A3A0286
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:35:58 +0000 (UTC)
X-FDA: 85302127596.17.A9CAB41
Received: from mta0.migadu.com (out-54.mta0.migadu.com [91.218.175.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4175240002
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:35:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wkWSnT7a;
	spf=pass (imf07.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.54 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791527756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3T1cwjr/qd2WwT/cXpfp9e0p3U1bnDfIv9R8Ke7D3k=;
	b=qy06UVcf4yF97gwXvEV0AkIrOU3MLoVNZMYiciHU5ZRSGEhIFdAPQyt558/04wldugccnu
	FR+TPNCwKYuS8qrwqL3HDM6/KJWuJ6BLjIfBAGItcmlIbo3V6XF1e2ul1JR91Fli5YzZgz
	nbXRju5MiQ/X2C0yt8ow5jo6LP8I3G4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wkWSnT7a;
	spf=pass (imf07.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.54 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791527756;
	b=U/sGaR/4wRBGtwT3xRQpVPfhJoWpj0EMqa72Ao3v4vHC6k3t4ds8GqTEmk+vuNojqgyBuK
	Gk/ZyFHmFA/N88kaDpOEujyV3B9vDEZ4IHemFqW3BepQftpMgjjOtT8nGroyLvQVY2GgrS
	5Z7/b3DA/QUE7JGP2ktsDdIoNxRqAFU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Kt3m90GxEd2pntG610a36JDfeeYmcBGJyCrnR//SRJc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791527754; v=1; x=1792132554;
 b=wkWSnT7ahSyReEbXS0EDzEyhlllyNbMacSosLJzdp12xqpjeVbG9xmgSyfTPdw6K26GNv4Jg
 NUY4YTMQcaA2ibzU+Limastt/AQ0w32w6vQeoNJ3NGyJeBQaN/MYlIrWTCgaTRME2DwqRKWiA7j
 qefiYxtdWDjCgfGxH6A1i8Mc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b474d1347a814fa6;
	Fri, 09 Oct 2026 06:35:22 +0000
X-Mizu-Trace-ID: b474d1347a814fa6
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Uladzislau Rezki <urezki@gmail.com>
Cc: Hao Ge <hao.ge@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [RFC PATCH 1/4] mm/kmsan: undo the shadow mapping when the origin mapping fails
Date: Fri,  9 Oct 2026 14:36:16 +0800
Message-Id: <20261009063619.112313-2-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261009063619.112313-1-hao.ge@linux.dev>
References: <20261009063619.112313-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4175240002
X-Stat-Signature: sj6yh4jepskxr5s6q183aqtawjt4dhca
X-HE-Tag: 1791527756-746740
X-HE-Meta: U2FsdGVkX1+q+MhwUJUM7U/Hn+QAWyiGT94Lv2mkVbpoA8/QdnSFlzAEzY2BHs22mB3T7PN9Rt2o3dn0dbjcsdVSPuGBGY/Zrol4abyQvEOy8R0n9v1Ckw2UEHUPVYo7S0/0eVAmHfJyjhqL8U8oNqDFM+9vXH/QX5BS8/auGjm64zEBtZkUcXmVg4ABLMgG/L/6RxjhV0fdbrC31iAegAityOGy4GgFYLH8haUewypKsXHTflKni2sjhzF07NnYdglIZlgTaWE7RDvbcSAz2IOtWDx8pceHL96TPTDfaqFGGQqU4fPg620YR9Pc0CQThmt4TvPrGYr2D9a1wRSoEehRZhWadX9DSLDnz0sK5npJVtAguwvRLkvozQGL3rXXK0Jk2cn7hu1h8oA81/vUWaACiGjdtWmO8Uu0chzEEdb8GsIx0o3Ea8PnRlvpXXIzo2PhaSpafiahZMR27msYKk3G3cPzKruYZVkPUx7EYkAHkLhnWt4OPgFRzR1/ltFkEczPAIt53Ae2D+vBL2GhQwzWekViJ2lcyxSVUOKpIlGprqVlycUswIVYM63NLGpMolJ1RdJugATheitZZ/omcz5DaTWzXf9rmnipYquDUuaJonkRit7c1XR4A8pmIWc9IMjc+v+AXXYhCIZYl30FtpKzXWWs2/KIyHR4f6lcwfhDxHaFW7NYUIsY8MsRMmj262gCx1zjI+qKzDvlfkJKZ8n8Tn2gBQvdqoGEYQhEcJhFhDrh7KeLZLFBAGfZbsOsBK9ak7ZdFGi3IEhF7eyIzVB8S814Mmy0ugXUzQbTty2KXl/+kk69ivjfKvfqArT2LMaJy28+GfIzhs+WTq9x57dRJWxJAInM26x5NV2Dg/j7ckA3eNrlDAwk0X+4CGtqxPg4TBC94NYw6Cyc9ooERnSZkWz6l5TE8DLJzmbwg0NblPIXFuMOV8CCtE0/FAuSqjT3T+0es61FI/bPAal
 ypFweG15
 b9jPpZIYPsyBuAdfSVWSeTAh6YpfLTdIlSGQ/7qFKxSyOsbAL1MMeXiV5KSdze0IDFR+q0XYY8JHHjHt+EcFnlJXwpDI6yvM1gdAht9R7LUPwhiUsw3FjiSGIeSfbWr6Q3Y6HKCgR6v/G2+qC9g0s5YUJcl/b0Kar5DL2ka+VN8LLw/j6AL0IhfVFCozhaAWln/Z9VbNCQZWcQftv4QROtG12ZCIWEalRm1dWBDu/zdb7o1ysz9S0KHNdObcQeCOu+Ivd2SkWeZ1tTqGX9FnYb/1rISnCUEUHZzU4Eyq8/OMt4SleufJeNkB1yN+uZnSSkh49WGKiVoRjN0Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmsan_vmap_pages_range_noflush() first maps the shadow pages and then
the origin pages. If the second mapping fails, the first one is left
mapped, and the callers do not roll it back. The next vmap of the
same metadata range hits the stale PTEs again and BUG()s on the huge
mapping path, or gets -EBUSY with a WARN_ON() on the small page one.

Undo the shadow mapping on that error path, the same way
kmsan_ioremap_page_range() cleans up after a partial failure.
__vunmap_range_noflush() only clears the PTEs; nothing has touched
the shadow mapping, so no TLB flush is needed.

Fixes: 47ebd0310e89 ("mm: kmsan: handle alloc failures in kmsan_vmap_pages_range_noflush()")
Cc: stable@vger.kernel.org
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


