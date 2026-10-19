Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB532CCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 05:44:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EB326B0130; Mon, 19 Oct 2026 01:44:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99BC76B0132; Mon, 19 Oct 2026 01:44:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B19F6B0133; Mon, 19 Oct 2026 01:44:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 653BF6B0130
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:44:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D7907160676
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:44:40 +0000 (UTC)
X-FDA: 85338286320.11.05B92CF
Received: from mta0.migadu.com (out-243.mta0.migadu.com [91.218.175.243])
	by imf23.hostedemail.com (Postfix) with ESMTP id E95E1140009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:44:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t0oYIfWa;
	spf=pass (imf23.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.243 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792388679;
	b=ylo5PViCpYKKpDNgjzyzXYkf9CMrpCg3Nk+nkv638WUcpIhFh9aL5+5tBmk7UAu0TNEHuC
	dLOmvs5DIEX4VMKV0yFk1s4vZF4fdCaJ03+xgchNkYUcfNN3Oc7R4u9PmaCLw66BAjQ3rD
	tMECmzQE6QReAaJjcSvdDLbMkbv4W2k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t0oYIfWa;
	spf=pass (imf23.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.243 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792388679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AhkHf4s7BbKXUCIlMDjh8Q2uCCWvm2zU6GzW8nRjKEc=;
	b=cvSv7kQM66oQCbM3ZvBfcOKHcBHSnIBec5tbzbAVzcnCuO+XPHXv6MSQ2Z82kP3Ncv9NM9
	B2r5OtEjHrWOWHqto9C5DTRJEwxK9+Y3c4A4tv5SqKD+OI9NmxJLTCBghfDlfLroffIMb0
	arz9CaniNckCHmUVSLYTAW/J+Uk7y2E=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6N7uwP3rCC6GNCQQInhTH/OwMfzrHTS2Jh/5l+ygl5s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792388677; v=1; x=1792993477;
 b=t0oYIfWaL8HWPSXoAcn0OQ0Vy0MgYHgr8VtN3BKpp9Du6V5yhCZLzag5GMVZwQE/xbp063HW
 KXSUkyScJvMMR2EjvWXkSprQJjUpmGE8c8P5UfPYA6KydR26K76oH6E64XoDeRaILiR0B+LznQo
 WrmjnlALaTYwhVgjvZbsO1uY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d648b1f8ce06a9d5;
	Mon, 19 Oct 2026 05:44:37 +0000
X-Mizu-Trace-ID: d648b1f8ce06a9d5
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>,
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
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>,
	Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/5] mm/kmsan: skip vunmap_range_noflush when KMSAN is disabled
Date: Mon, 19 Oct 2026 13:45:27 +0800
Message-Id: <20261019054531.87652-3-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261019054531.87652-1-hao.ge@linux.dev>
References: <20261019054531.87652-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: E95E1140009
X-Stat-Signature: nf4qd74aowwypqaq4mpourqfg6bx6g7f
X-HE-Tag: 1792388678-143807
X-HE-Meta: U2FsdGVkX1+fdfpeTBme736hhRDw18JZOmm7pLQCB9F3LLlZ+AwLXpIyAzVKeyWvQkeVNO83VICplivZmcn0CfHTXP0ZEKS4qQRZlqgG8Vdafpf1Z6UXshKOp1Oe9bhlxSwDIBMQ1sjiQ3RZSeWVSOwZTMM+Zm8d66QiyyBYKovx81W8XiKYArbkrWDXFgdNpCx5G+TFTh9uzPyR+xO7CRuleyiKaG3Vknt+E8EOwCsPtkxfvtWkgWlXXkNeH1HZQkwRxDBhxU09Rr+R0SpfvE8PJdtbYQYmQ0tfma4y6yYuKWUj69mwb65unZrbXHkGxoxdSKOh+bBToTxa5GHhIF7ci2bSFtqZ5eil7qqYo75oixu1BVDVO9cHSL4nWJYYmltri5g+LeGuohytOqY7hk6erqQV448tyRrLh4ghYLvsAXqhyRxGxQMIARAObzvHOE9ED7NJa9iyx7SET5jOKh5zlXaEnoJHHuXtXRY3jT5oWk2Li0un08WFBe+lMs8KTj49bXeOlneSSijeXiYnp7u/iNVpVZCZDzujX7UEgMFiQJv39c8vGZwXSc4tbVtMSNyS8mAvM8QEexCtq4Le2fycHqlXIO/uSdk/JKyDMWPt5/+9wTjKgi5jbVYblFf6bL27FQknnmkdcufcNINjYjTqFhx7P/8+hPh8WS+K6mBXVbuEPViXDkWKKMF+HA8k7Vuf29HxJ8gxyBUdr+B1RD+/VrF0zMTKD0XSTPZ328iM0sYDBPMNf1gGY2EseCcgfpr8ttVu4U6DCoIj+YE0asqvwcphSS8l8ph5QNftShFFRO+7l/OweA2CeSBAqauOb3dGgzXMODZc8YkHwnvgT4kN2VKFzbdFj2u/XoPsbj+mhwJCsTbjRbm5/gJ7ezrH5uLzatz+Ss5xIiIVYKLGke3nP22uBX8KUmzhpVn2bo0IRnhHN7gY0yTeCCZskgi/xtp0N7hekCFjPYmlrTB
 VEe++cvc
 BTFZfEB6F2XUh9jUanGf1fLWDRkRzME9+z3XwYNtxHRc9EcczAESadWC5sI3SCKcvXNIvHh1zWxFBbenWhV/Hqzmknyz2JcMC1mmOe0UjK47RNp60+rxm6q5JGXzoTgU/vOtQ9UAtibfxMKt/ekE2h/Uq8Ne8YVBUW5BkHZHeUI1Aaq4BUlfGYXRHOZll4BDRRUP6uTsO+42Zo4Ngr18XdUwJY7VqtP7s2BRKW5WDKQsqijaascuc8YkjwMJc3wg/GZvxh7BAfgXZQSF0Ppg4tfdZFyHZlIEIGNQCWJU5ILCyWIxQyjNpFEtTz30ybL8BhE6w00IbkdqG+gNZnkbKZwWhh0bNWFXIQr45CNW8Um/g50/3HVUBn634Ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmsan_vmap_pages_range_noflush() returns 0 when kmsan_enabled is
false.  The unmap side does not, so it still walks the shadow and
origin page tables even though KMSAN never installed any metadata
there.

Add the matching early return.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/kmsan/hooks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
index a706666db097..107f66841274 100644
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -138,6 +138,9 @@ static unsigned long vmalloc_origin(unsigned long addr)
 
 void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end)
 {
+	if (!kmsan_enabled)
+		return;
+
 	__vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end));
 	__vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end));
 	flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
-- 
2.25.1


