Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DADFCC44507
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 06:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0C836B009F; Fri, 10 Jul 2026 02:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBC796B00A0; Fri, 10 Jul 2026 02:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAB6B6B00A1; Fri, 10 Jul 2026 02:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DB3E6B009F
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:40:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 120B48D94E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:40:18 +0000 (UTC)
X-FDA: 84971917716.21.833CC1E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id 844081A0006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:40:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=rLCCKjKE;
	spf=none (imf19.hostedemail.com: domain of BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783665615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gw0KIsyz0BHgm0TvwsQ1Rk+84aGGAWVbBXV8GHDW6oQ=;
	b=CiRlmr9NUvcTcdYdIKdBIaS6Lt6tqaJzPdc4Pf3UkMXxIRn2J1LAzx28d3xDeRd8SoPX/y
	iC0kZ57xz/R7gViVBdP54LadtoWhCBc2fY5UegxTkNkAB0KokJF7U227ynNonMkpC/ZVeK
	8m5us6Z0nPvsxGCjhSiVA3xiFT1l1OQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=rLCCKjKE;
	spf=none (imf19.hostedemail.com: domain of BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783665615;
	b=is0+ZryeihGopa5kpvzIc7eGRcZfqmbo01xfzNinV3cg4voViBbh75INAbGJValo+OkfjM
	8z6EK5ubAjJSHPYlVrMGWrYwvxythAEI4+ZwCY2O8wMcI/DeVTmnJaPI0qbjacO1oVhAry
	E8wBEWkFsyf/Hp+TFw3Pia5ymVUiz+0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gw0KIsyz0BHgm0TvwsQ1Rk+84aGGAWVbBXV8GHDW6oQ=; b=rLCCKjKEauudtc4E1D8tXx2VBH
	J7FI7y+pnX7QafYCDq4YWbOj9lF517v90r3R9DLyL8bT/5sK1+5pxBQFSHxglfWOvnvwzyh+sXXkQ
	VnWX3Yc2cgLxZ86YN4upM7/reswYG7erB7MB4Ggp+0f1wCMKpNqEt0Umsao0jdZCUrD3gY53BNz7y
	zSbim7Ngh8F8g1Hv5xGdZcBWVdzKy4Wb+XUf5aaawskF7n3+5ALsQyvF8nYGSQ1DFTfJo5ufccIgj
	S5ZTTVfbAkMd1k5rgRWTx3BR+WZBra8rYaIukSiBIHkfixu8kiTFvgM9CftlxPd2sVL6vfZjbxLNT
	wAH2a9JQ==;
Received: from [2001:4bb8:2cc:d72d:4dff:292f:a943:a4b9] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wi4u9-00000004HWQ-3eF5;
	Fri, 10 Jul 2026 06:40:10 +0000
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
Date: Fri, 10 Jul 2026 08:39:18 +0200
Message-ID: <20260710063927.1891452-8-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260710063927.1891452-1-hch@lst.de>
References: <20260710063927.1891452-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 844081A0006
X-Stat-Signature: d7z1bju366dne7jcrgfebqnaozsakh4u
X-HE-Tag: 1783665615-854161
X-HE-Meta: U2FsdGVkX1+kb2L0MCJx0MoOvq5Z2NLPIK7woSyKvycg5PRYE4Jm0oD5a/I/QweNLATh8XADIrVH2OPXbLmpEULGfWdfJNlah5VNCOJOWHGd1fTSiFQuCQmoX+89iV+hFNedsTFENv/5D0WyJsuqYybRXFpbEZsYuhP8HEt7nnS+b5AzlJHAQ62WFSyu0RoM10oOQXMF7zHZQ85Vjr+3yF1wXftxh+Cr4lbsJRorZI62IE2T0Kbq0fSg/EK+aodAEqdUlcPZzIl35q8WlPNg+kKwR27/GOZLHhAG0yxdB4dMimAu/fdZEejB4YDIrwxgA6ilOR/R0oBBYsPGuMi8tzRp63MyLgwlRG93LMYMDWpfrXDD3hAJm0N+xdfZv0Op8eFbPa8TsZkgt8A9w5GIvhX0D/UNte93rmUomQkHCCd1fvIi1qF1UBtX0+DgNQVc+3I2wWIhY/DdbLCLrb9EguEiZfe02ZkjKqJoGWkld5kvt3llcRBemiNy/T5XyqGek5mpnsbR33udcyjqqZS4Fpelt3QjXGTKzJI4/2vzjMTERR1exAMWqGkMsl+z09BYaoTcInWgb+U4uj41RYSXYHnyJ18TufcTJ+ACZxnCEYTFl8E4elf55CBAYH7fhzdCZhXslIteY/BtuBfOQJ0bk2WpnDZki2Y+pOBXDc24ipT3Huy0XcbqJ6/gAu/6Z/jDw0K9et5Z2ut9ZKyy0Zc2AJ73DO0LcoIPpU2Cwfl3khbusdF3kegf3d1yf0uvQLKY4Q2KQ97Xr30qgTXc4sOCVBDClZlaxmOsxuSgiCsW4z/eZUXeg6OVXT4LmJ85u9rZAHHNQGtW576iAGZgx76t3Y93odQRBRQ/jrdIvSdgKoFjwCRLZZH00echwF/lTIwtkzpX5+949k2VMMpx3aT4dUtiEsn/T3X/ktNDJ4mcHuVvH1sr2coOxzYRBLYsJkIKj9/Tp6vxPxUsMvfh9h5
 Bu4LnXB+
 GZVFYuuc3qXZLDgkBzNtSijMOlpp9x8qAncXfqtguyE5mMGpARsp5eze4Y5yIBkc5TDP+Ag2GzMAtG48ENR5ndF3qd6HTLNFZmvqNmvjjihY5zmBRowAX33vodrQojNpzhS0ktbPtqu/xukqLWyC5DEYiSiuzyFanl3uEhTnYX/1lUYGZnkr9BUVsfeQo7dWdPmhRTuifJninUInV1ExbhetDdh/GnaQfkDJUy+QshH2NNftmVlcArVPj+x00kYfiifWSq9ovuuxF/owyfJs2rkSNa/fmW6ijDEY03wvgKKX7crlQoE23Gg60KiPs84Hdlqmn/wlIBlRiKnGm5DSfQFoisnecgTViwXmnSKLorJBbJoFx+1nN0dQxzdG77MhzNJs8VuNf2Yfxy5uzMHwMQ3d89MPi+KxBbWiT2oIN1AXe3dta/wlHoTa1SJ5N9EaMZYivxEXIVDBNYpOCZcfzG/633qk28rimr9cWSxDLsddZ10Rkxs+VZd+tbP6+j6yj9GQtBl+Kj9UlIhrh2P/PBrmAd7i0bPpjkO3KXDvOrdzsCtdTRW7xGu3W8d+pB9+PLSU8xYw17fCtB3lD0X+Jzq031tCoaUVKvDgBFYHezbjrzvA=
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
index 9b981270d45e..673f759d5ac2 100644
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


