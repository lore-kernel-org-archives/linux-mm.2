Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9307A606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 08:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=drf6L/9Y
Received: by kanga.kvack.org (Postfix)
	id BD1D56B05B0; Mon, 26 Oct 2026 04:02:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA9286B05B2; Mon, 26 Oct 2026 04:02:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABEB66B05B3; Mon, 26 Oct 2026 04:02:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D8FA6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:02:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 95D851A047C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:02:44 +0000 (UTC)
X-FDA: 85364035848.01.C6822E5
Received: from mta0.migadu.com (out-82.mta0.migadu.com [91.218.175.82])
	by imf24.hostedemail.com (Postfix) with ESMTP id A69EB180002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:02:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="drf6L/9Y";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.82 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793001762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hfZXr5B4QU7BP5U94Iy0bbprGRMIU7jhwwRUqW3NVmE=;
	b=7i7ogFUQ4DZJhl7hHuBRNDlJH0feUhTef4VMYof+beggSoRD4AynDNQKBWjNxCAkQ/iuZG
	4IGbKs1AWY/CP0Vy82Ar1cVEdmi+GIaRLjtUqJON7WNI9qiP70BgQK00wi0AT+CIa70+l1
	zIRPHtde67IwxNgLjrgSUhrI9itGHSQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="drf6L/9Y";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.82 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793001762;
	b=z8iHr0xiKfnz3h4oWAnZK3AWUPWGfoe7G8o6+LwOfQIu1aqF33u/BRIqD52ux3tMnAvF6f
	EWx3fxI3EtJlXTqWm0YJTWPzbuB1ihmW3KpZDpAnUdNMlsIFolwT37nmIVIqPadH+znoA1
	5DwQukoVLfvwqAiSeE8rXHaKnuDlBjQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=oeHSWM4q5xftJC3Ex7Fav4XAopE6RwVOINuuoKO7m0c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793001761; v=1; x=1793606561;
 b=drf6L/9Y2ANMwz7OLHgvyXSgRtBP5A91HYPS9zwd2ypvpeHLD4AsQW2rZToy81jjeYql77ut
 C5OyZfLmvP44UJHVFsdr9XxNwIgvwGrtOy0DKJa74gVIRPSYRlstHsMLMTuPu3JwCbl9RLr3yat
 n641TwF9RCUQ2JtgvMyVAO/k=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9a1cb61258a50e8b;
	Mon, 26 Oct 2026 08:02:40 +0000
X-Mizu-Trace-ID: 9a1cb61258a50e8b
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
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
	Uladzislau Rezki <urezki@gmail.com>,
	Hao Ge <hao.ge@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Dev Jain <dev.jain@arm.com>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [PATCH v3 01/10] mm/kmsan: undo the shadow mapping when the origin mapping fails
Date: Mon, 26 Oct 2026 16:03:20 +0800
Message-Id: <20261026080329.140244-2-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261026080329.140244-1-hao.ge@linux.dev>
References: <20261026080329.140244-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A69EB180002
X-Stat-Signature: 5nem8x3ymxmhimqofu644yum9muagd3n
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793001762-374494
X-HE-Meta: U2FsdGVkX192jzyn4ioHsmji/vHMM7KaaGrXKEzLPF0aM0Wex4EK1hUcxKq3ivzhsblppSpunvw4E4G+LRnguTIMIvNW2CRO6eA7g9OH9dwPk6gW1F4aj5Hr3HkpRabI5nqsCYRw/VQHpwtBKbn+EZiGk9q+i+zmLhehB13bhxvdMRvTYHimJc9GfXDAUYvfg6o5JCzHW+G6YRttgmaezuxXx3MJdC2PzGWD0wwQCh7qEonTccxGCAlFmMF4IhSsvZwcLVtRoWhW5YEYpxpf2/ltIxXT6JcZjeWDUio9Ed7qoiCP0Xmu/GlPFuCge24wyt4IVyYQBDrFa3dp0ndL8bse0tVGEPtadcC+/0yWyaYQzqlQ/F2AK+T3XsPhcowzwg9c/INc4ExvagDP8oPuK2dSIl1felZ/ZhGTEjzrIbMis/jAeRMKqH3PZDsHW1vvryfI5FxScNZYUPvpXSqRF1/0FBI2uvx47ry0KpZY3mjt4Rf2vLcTS6EkLm1eS9WMn/oaXdl/GL0G05FiUIEyHXTxRTCqp7MjYwa/u6ZJFacXONaFdxWUl3A+S0qZVwDNo404+QvZhsj7eoVn/EwHnDLRWyAAM3W7cDQEOke0QjNZTWuHZ2SZFJlZhluAsPNSTFzc+cB6LaBHMyXf+DZEWx+gxHdqaJ+TkbZlt+p/Y+0NspOeqQKBEqcc0bTVyR/Q05YrGk8YGTYTBOnBdtiECvcKSNYfMP9pfoA44GAfA715ZbBYc+dKByrk179F6+WWIIJI5sQS7gBTzDazg5MW3yaGT3DcAH9qza/edO2QyY+F3Yz8szn83M7qFlIo3AucsIPQcH/S4B11+PoSrEgLrbRXF0rvqpe8EgRi40DO1/eYLqlw3FwexNt2WAZK6LSXorIf67/+KZbKSKZgJjmR2quI5hN4j0fkJbAJxAhAO0c3CIZZQdomklc+L4j1YV9+EN04O7gaiVKrSU121i/
 MKijoydd
 4RgN2HJxYgY7NYVt0yx2IJn/QOqjJ/VmbGdI836WpKaRXGmdio5TbztbM6vl34U9fjpRWZP4A1hRfwIngzbc3x4ZDOcI69nbGDrWygZOTSIF0M9N+XPNrvx+NYJpF4u4k9LRl3tvSVJEiF3qeI9d3kQKOcD/SSBVG9nOd+GojYSac8GUDs43u784P+Rt+Jrpv4y3dAetvBIkgGv7HbKz2ToisJpLqXlEdw7XhZQ1h3xEDikjx8eZQJf2AEOtihtwFnbuhzpKsXV9/k/TsqwnmfmdGVH6+39mCiI2nhdvBGsui327YyyOxhrkziKQ8jEyJkR9TTXT22O1IfjyeofizbijzaqlBEYPlEbSB5kxQeIIUA5RwJog1h5g0iWtWZTbSnp+o/y8v7NF59fg1eEVTEEPG8cD/SsaISm0b
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
same metadata range hits the stale PTEs again and BUG()s on the huge
mapping path, or gets -EBUSY with a WARN_ON() on the small page one.

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


