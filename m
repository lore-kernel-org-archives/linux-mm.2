Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEE12CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 11:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17ACC8E0002; Mon, 17 Nov 2025 06:15:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12B938E0003; Mon, 17 Nov 2025 06:15:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0204C8E0002; Mon, 17 Nov 2025 06:15:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E12E78E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:15:07 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 844E45CF5E
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:15:07 +0000 (UTC)
X-FDA: 84119842254.15.ED1D50D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5CC804000A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:15:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fgWmHfwd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FsHHCzg5;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fgWmHfwd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FsHHCzg5;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf11.hostedemail.com: domain of jdelvare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=jdelvare@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763378105; a=rsa-sha256;
	cv=none;
	b=SNaA9agIMqv6deaaYrzKEUh5GFwQbds4L5IR7SQbJmEceEHJRUUKCXqFNosQwcXovOxP/T
	Ld6vOBv/1tzFpNo8qX4MGHTCLKdaMdFBcySpPlRDWbp3uNAmp1l638DTTl9Hi2wkHgqby2
	7QbFjybZHOkx6FcqRN7Mmqm6dptvqCk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fgWmHfwd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FsHHCzg5;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fgWmHfwd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FsHHCzg5;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf11.hostedemail.com: domain of jdelvare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=jdelvare@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763378105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u8LX1CW21QZOgAC8hwcxilXQWcwm8K+BwFeQUI1VU0A=;
	b=mg/DFDEK8y8NQgXT2pshLfptOALZTmSSugW1lWdRy91czIT0mdvRfvLQb+Gn7Qc4TiG7cg
	KiMDzVP5CR8jJFvtWvoRwE83VaE2nuEQt3UlsHQIcLFUOFjsxq1RBwh9UH74S7zw45S66O
	51RaOSkZf0TPgla+0r/yAKivqqOrOGw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C666721224;
	Mon, 17 Nov 2025 11:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763378103; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u8LX1CW21QZOgAC8hwcxilXQWcwm8K+BwFeQUI1VU0A=;
	b=fgWmHfwdFCVvoYUGCjyesWkdlVvHfuKOodgpWU00s3MQhoLQWa5rTchwzSMXsew026IAz/
	VbRooUVi1WbJY6rTy49h2SXvSTZuCcpN25GGMiQXFUO02HEdbR0ZssFAQ2r00yW5G5cY1a
	mHl35KmEQxZps38AKb2eKH9MQk4cjDk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763378103;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u8LX1CW21QZOgAC8hwcxilXQWcwm8K+BwFeQUI1VU0A=;
	b=FsHHCzg5meUB/o4OdfBARNkCJMJCr9yjawIEZtb1Op3vKvvEO3x9oi90LI4rCJZDQwl+sz
	VYX+LKWMLidYagDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763378103; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u8LX1CW21QZOgAC8hwcxilXQWcwm8K+BwFeQUI1VU0A=;
	b=fgWmHfwdFCVvoYUGCjyesWkdlVvHfuKOodgpWU00s3MQhoLQWa5rTchwzSMXsew026IAz/
	VbRooUVi1WbJY6rTy49h2SXvSTZuCcpN25GGMiQXFUO02HEdbR0ZssFAQ2r00yW5G5cY1a
	mHl35KmEQxZps38AKb2eKH9MQk4cjDk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763378103;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u8LX1CW21QZOgAC8hwcxilXQWcwm8K+BwFeQUI1VU0A=;
	b=FsHHCzg5meUB/o4OdfBARNkCJMJCr9yjawIEZtb1Op3vKvvEO3x9oi90LI4rCJZDQwl+sz
	VYX+LKWMLidYagDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 87FCC3EA61;
	Mon, 17 Nov 2025 11:15:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EOAsH7cDG2lDcwAAD6G6ig
	(envelope-from <jdelvare@suse.de>); Mon, 17 Nov 2025 11:15:03 +0000
Date: Mon, 17 Nov 2025 12:15:02 +0100
From: Jean Delvare <jdelvare@suse.de>
To: linux-mm@kvack.org
Cc: LKML <linux-kernel@vger.kernel.org>, David Hildenbrand
 <david@redhat.com>, Oscar Salvador <osalvador@suse.de>, SeongJae Park
 <sj@kernel.org>
Subject: [PATCH RFC 2/2] mm/cma: Consolidate accounting in dedicated
 functions
Message-ID: <20251117121502.6db0fd7a@endymion>
In-Reply-To: <20251117115602.7b9c7ccd@endymion>
References: <20251117115602.7b9c7ccd@endymion>
Organization: SUSE Linux
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.43; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5CC804000A
X-Stat-Signature: xzpi4bkn16fbapki8cmr3411z7g9zwm7
X-HE-Tag: 1763378105-552357
X-HE-Meta: U2FsdGVkX18DNJHkOBwv69E2lKbyAPA1utr5BRosbnkXedw4V2GTEqDLnz7DkuHsajHhxUAajcdT4K/Nvr3Gwj+UPzDNdxslk24qMWKF3taP+xMhNe/avE2xmrtguF2oSfejWg603ZqgcON4+b8T6rKGwuwlScx+oFvJJXDM3ehlOXgqpxbWHjyIysyDzim5c+qc3SJqxdGRVx0Fsulp8zC6xGKL1QGDZ8NgphJCqwF12O5CmIPQ4OzVLnJ9kBGRBC/wfJft36geFFvfOLkkpQ3kc8bZlpJe/sFO92inP1byEwc0p6f+YqcRUD8rTwICrmVYMsWfaoqd+No/kcltShWz5wzr0s+GiI9AwnC5HLzjwvG3H9blJa0HpxsazO/7aACGdZk4xjeVQYfIvc6uyuPfvJ4H7codsVKpgO4YcZh5sCXt3QVGCNMpzKgFr/ggH0p90KB7Idc5CJzoOc4fokoUjH4TyHyQu6Ktn/p7zKjSizikb6wFT60kiQwT3cn1K6hfkCo/B0F7T7FoCOXD4BzOsiP0DGfZSkZpufvgawfSO+mlT6xqyF7X4Em1ddF5t522LUt+AHeEW0UgzHcSwSuYLUMoJmjSwuos1oErnkcmbiOTsu69cUvkaSe8xUE/ZqkLQsGSgxiHMEBV6ZPYBiJdpdomLyfMuhYYi9u5L/O7LplHUoeH/5l0TvydnwYA2RoFbqtQ9xJA6Ue0a+W7hLnlXus9R3lNEQhzknL7IrwgDtKEXS9nI+6HMp8EmcsR5VCiWKBELOAP7pbOMP5uLnTNhQnNUM96w5UhCpt0gf6IBtbd0UB1oJ57TyUOKe8RXQ183M/MLmdxp7800jy3h7BGIRKaXdFCyI7HEGo9hvZiHS2szCGeYz7xK2EqYVjwRvA+GjbZarsJcoO6hSGSMx8wVcvJPj2EDCYxBekb2aghtuyo3SZvV6bFdsUPxOIbGSRCJWX9G+E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move all accounting to dedicated functions and rename them
accordingly.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
---
This is based on a suggestion by SeongJae Park. Comments welcome.

 mm/cma.c |   43 ++++++++++++++++++-------------------------
 1 file changed, 18 insertions(+), 25 deletions(-)

--- linux-6.17.orig/mm/cma.c
+++ linux-6.17/mm/cma.c
@@ -37,31 +37,27 @@ struct cma cma_areas[MAX_CMA_AREAS];
 unsigned int cma_area_count;
 
 #ifdef CONFIG_SYSFS
-static void cma_sysfs_account_success_pages(struct cma *cma,
-					    unsigned long nr_pages)
+#define cma_inc_page_counter(n, a)	atomic64_add((n), (a))
+#else
+#define cma_inc_page_counter(n, a)	do {} while (0)
+#endif
+
+static void cma_account_success(struct cma *cma, unsigned long nr_pages)
 {
-	atomic64_add(nr_pages, &cma->nr_pages_succeeded);
+	count_vm_event(CMA_ALLOC_SUCCESS);
+	cma_inc_page_counter(nr_pages, &cma->nr_pages_succeeded);
 }
 
-static void cma_sysfs_account_fail_pages(struct cma *cma,
-					 unsigned long nr_pages)
+static void cma_account_fail(struct cma *cma, unsigned long nr_pages)
 {
-	atomic64_add(nr_pages, &cma->nr_pages_failed);
+	count_vm_event(CMA_ALLOC_FAIL);
+	cma_inc_page_counter(nr_pages, &cma->nr_pages_failed);
 }
 
-static void cma_sysfs_account_release_pages(struct cma *cma,
-					    unsigned long nr_pages)
+static void cma_account_release(struct cma *cma, unsigned long nr_pages)
 {
-	atomic64_add(nr_pages, &cma->nr_pages_released);
+	cma_inc_page_counter(nr_pages, &cma->nr_pages_released);
 }
-#else
-static void cma_sysfs_account_success_pages(struct cma *cma,
-					    unsigned long nr_pages) {};
-static void cma_sysfs_account_fail_pages(struct cma *cma,
-					 unsigned long nr_pages) {};
-static void cma_sysfs_account_release_pages(struct cma *cma,
-					    unsigned long nr_pages) {};
-#endif
 
 phys_addr_t cma_get_base(const struct cma *cma)
 {
@@ -921,13 +917,10 @@ static struct page *__cma_alloc(struct c
 	pr_debug("%s(): returned %p\n", __func__, page);
 	trace_cma_alloc_finish(name, page ? page_to_pfn(page) : 0,
 			       page, count, align, ret);
-	if (page) {
-		count_vm_event(CMA_ALLOC_SUCCESS);
-		cma_sysfs_account_success_pages(cma, count);
-	} else {
-		count_vm_event(CMA_ALLOC_FAIL);
-		cma_sysfs_account_fail_pages(cma, count);
-	}
+	if (page)
+		cma_account_success(cma, count);
+	else
+		cma_account_fail(cma, count);
 
 	return page;
 }
@@ -1029,7 +1022,7 @@ bool cma_release(struct cma *cma, const
 
 	free_contig_range(pfn, count);
 	cma_clear_bitmap(cma, cmr, pfn, count);
-	cma_sysfs_account_release_pages(cma, count);
+	cma_account_release(cma, count);
 	trace_cma_release(cma->name, pfn, pages, count);
 
 	return true;

-- 
Jean Delvare
SUSE L3 Support

