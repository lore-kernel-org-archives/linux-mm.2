Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A410C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 09:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 243FE6B00A1; Mon, 13 Jul 2026 05:34:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F4C16B00A2; Mon, 13 Jul 2026 05:34:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E3486B00A3; Mon, 13 Jul 2026 05:34:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D70636B00A1
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:34:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 778341A09C9
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:34:49 +0000 (UTC)
X-FDA: 84983243898.05.D3D6547
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id C81D41C0003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:34:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=hws3o1OG;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf18.hostedemail.com: domain of BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783935287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D88P2s75qGA5uxR0r7OKzJ/uLvFvl1fYzQcrFQBZ8NM=;
	b=q2U85JA3UmPSI2mCQAcMs6vu+x8p1MAFYzHaQEAua42UcVgRBejO9a3VcMcV1Workiut/t
	kXyFRTl+RlcFOIm6p1PzbRIItWR7o4BswB2paIShhJu09A1nYUy6fMxaD+OKXUSgxi4yYT
	B7GpKNIHfFDgkq6rjZyhY4ywG1zey34=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=hws3o1OG;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf18.hostedemail.com: domain of BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783935287;
	b=VE6DcCeGID2GCxrMx6OTKZUPMB94d5+xVtMPJAbGQ9D2FSHdL3jkSnLK9WAR3gTMb4+5Nq
	wkkXn/hsLlIn0Zr7uCFN84THdal+gn9DHFsxx9rLPK3luaSeekWtRYDr0zF/0e884mnZD5
	XHdV6iO9AySIULtIplZNJDYXcMx1D2A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=D88P2s75qGA5uxR0r7OKzJ/uLvFvl1fYzQcrFQBZ8NM=; b=hws3o1OGosZk3G21iabnVxjt2u
	GiRe51OfmMHgVkPbjTEAPEAXDB+6k30Wz91ssA87tO4SXyScZolCoL/CYqreIVmi/X2qmKwE1oaGT
	sUGv5G7pFriQCtXZmBoHhv020UYUdi/zSSOO0X/wre/2phR8YNt8bu5xmGXld1B2vTCj9wdnyvnsO
	MPsFl5wzyVdpvPk4oNxfHCISMHo9iTw7p09q6N3T6o8iWdaQsHDBe5pipyVLbpJpyYmHYVery3GRS
	oESWxOeNPjdPSag/dw00+uZ5ObmHTPSeHGr/Mun56Le4ZZImIcb0Us2HB0h3gsolnovW9at/j/00L
	lbB8YVhg==;
Received: from [2001:4bb8:2c2:7dc3:4a7a:b4de:3d88:bc44] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjD3i-00000008koW-1kJ1;
	Mon, 13 Jul 2026 09:34:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Cc: baoquan.he@linux.dev,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: [PATCH 7/7] mm/vmstat: add NRSWP{IN,OUT} counters
Date: Mon, 13 Jul 2026 11:33:44 +0200
Message-ID: <20260713093350.2154226-8-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260713093350.2154226-1-hch@lst.de>
References: <20260713093350.2154226-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: C81D41C0003
X-Stat-Signature: njrznstmsrbdbgqqwzrx8ffgedwm6cip
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783935287-156924
X-HE-Meta: U2FsdGVkX1+KuJPV70sIo0LZH7o1yJsDBz1xJl/HunZ3EvKAWkN7iw+hHcsapyp0E851DjOHgnuIlFrEmjUU9Y2Ne4tLvvhL7UeRaT7aquI8f9K7hQVDeXDhnUrju/GZuP+nsSLXvGaR2FUm1o33ecYTMOUir95wxj9fXdviR+xAmfOoGrnS9hoDJT4Y4R+8qclP8J3RGok0R3XC6V8b8eQbOHp67XjupQrFIVfHj1DlwLzUsX2LjDpWrn23pGHA9q2eaBNi52Oi+M3+Ws1Uh7U34nJvt1bQ9lGzjC06CtoynhOXnFqnVRtSSSunZETiTcQPrRrtV0MM8k7HCvq6xiCiiiuyndSlj7IYxRo6kwKEbn/8dzL0n+ov1KCGvt2dXE3AGAibRCrJUKDKiEq/eBSfM9z6oDC64iKLwre1lM4lpa923goiG0Tt9KfLhD/qPq49BqnJWAfsdSg6CcK/R8Emj/qR23KMV0Uh2WpBIUyViCRf5IbNOBN4r2WBz31KA7hz1pdhKGIZI7VXVy4ddy8xO5CiGDY7DpfrIhMpQBgVnt2D73gesMIPeolAr2KpOE9zshZZsOKhbUspN+gLKpEtJI69wdfHaYwh/pbLQLSOVewATc8amCPlbDQFUtJoFlhG7lAl8FmXJ2VjBgCkdL4VWYrJdc8PxLdNbXVjEUdtZQkhVSG0uhOv4P5/q+wSOlQXl+Qjl1nX7Q7uZMQUf8K/fVJRojiiDk5/UAp0E8yMFkL5cBYKG73NeqI09ftYBnMxy/IPouhE159Xzbc1B2sLo4ZpPxMsXVWLRPR51JgwYrhqu48ql5SJ76KhQw2tlcroa29eNnyB2eUDcSJoL6grzoJBpY5njBfq81F6rK9N1dnE26xP+ceJL7b/okrT2GWM+RkyQgMqJ3iJK7dYv279t2IqbD33ExbWsR6dMUVAxQ0zFza0Qras+bsyp/zsCx3BEY8dB6dxvzjLfsb
 yVDGOZWM
 J39FsADkNuiq53FziftxgDdpPSMFGD+5JSESuqWpM4Xf/ikaDXViSHXGZFWlyXoXbzxkRZ2iSgdrJURvJx6Nw+DcYh8+2xDNiuekctLCh95OqOkl3KXwiuRQGLnFI1dE+Rl6E0xo5CG+M4XIgUQ6PFRtnGDo7UpP0H5gF+gnrShTeNMKcV3ScbJOdxbdMwDhp6OQldMDQH6f73Q+cahs1u0EZ8vs0iuLA+hBj23WM89SPmirlG9kmRCAoKRVc3W2rFTMprVvECJMW0gQtDaHB0PxXHGPesDsdkvgyEorOGIwGP7mTPo4QLDIkortz77QhIFEL/enEliJ0nBpvVCoiMWNwIUDfRqoXajc5C3iCqpbrsdrmftQ3AcSfLtAM4+KrDrSyVIAN7JYl8QjtgZuvJ9lm/Qh7/TvLEJZHVPJCVBHIUC/m7buu2KJeyFnXki7cTZp6ZjsYEd06pkgwggtgoIFLVI7whSxq133z1NY6AcMcYPImli3a7KXc6bH1V/Q7AVVipa/4EzfsJInz1QVpSKcptdTVvC1M59qDPsYA005Bth5FB+Hg3Ak95LV+yVvIuoo4UXzRR7WD8IL70rqIjgEQsMqC8UQIvf4pKw1m8Hnh0NM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Count how many swap I/Os we cause.  Due to batching this can be different
than the current counter number of pages written/read, and tracking this
information is useful to see how efficient the batching is.

The counters are added at the end of enum vm_event_item and the
vmstat_text array under the assumption that the order of fields in
/proc/vmstat is an ABI.  If that is not the case, they could be grouped
with the other swap counters.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/vm_event_item.h | 4 ++++
 mm/page_io.c                  | 2 ++
 mm/vmstat.c                   | 6 +++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 03fe95f5a020..2628ccda076a 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -175,6 +175,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		KSTACK_REST,
 #endif
 #endif /* CONFIG_DEBUG_STACK_USAGE */
+#ifdef CONFIG_SWAP
+		NRSWPIN,
+		NRSWPOUT,
+#endif /* CONFIG_SWAP */
 		NR_VM_EVENT_ITEMS
 };
 
diff --git a/mm/page_io.c b/mm/page_io.c
index cea438b66bce..e4fa7ffffe8b 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -704,6 +704,7 @@ void swap_write_submit(struct swap_io_ctx *ctx)
 {
 	if (!ctx->sio)
 		return;
+	count_vm_events(NRSWPOUT, 1);
 	ctx->sis->ops->submit_write(ctx);
 	ctx->sio = NULL;
 	ctx->sis = NULL;
@@ -713,6 +714,7 @@ void swap_read_submit(struct swap_io_ctx *ctx)
 {
 	if (!ctx->sio)
 		return;
+	count_vm_events(NRSWPIN, 1);
 	ctx->sis->ops->submit_read(ctx);
 	ctx->sio = NULL;
 	ctx->sis = NULL;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 3b5cb1031f72..4e26e5fd6666 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1489,7 +1489,11 @@ const char * const vmstat_text[] = {
 #if THREAD_SIZE > 65536
 	[I(KSTACK_REST)]			= "kstack_rest",
 #endif
-#endif
+#endif /* CONFIG_DEBUG_STACK_USAGE */
+#ifdef CONFIG_SWAP
+	[I(NRSWPIN)]				= "nrswpin",
+	[I(NRSWPOUT)]				= "nrswpout",
+#endif /* CONFIG_SWAP */
 #undef I
 #endif /* CONFIG_VM_EVENT_COUNTERS */
 };
-- 
2.53.0


