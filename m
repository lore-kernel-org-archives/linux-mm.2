Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FD08C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:32:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 467AC6B00BD; Tue, 30 Jun 2026 03:32:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EC866B00C0; Tue, 30 Jun 2026 03:32:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28EA36B00BE; Tue, 30 Jun 2026 03:32:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 02DC36B00BD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:32:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7477AA0408
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:32:06 +0000 (UTC)
X-FDA: 84935760252.10.C95DE37
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf26.hostedemail.com (Postfix) with ESMTP id 99EB1140003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:32:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=eiDf87lu;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=rWqMlZZF;
	spf=pass (imf26.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782804724;
	b=qND3dzyBmr7orDkX27yaOPrLc6QFA8JS4ly0qSEIjwGI5FaRx2GMoQwxvRXHmGSm1ThkUj
	M0h6ZadI82oKx+4L89OBRd/o6vAONqrz3+ix0lElpjRBfFpd4S67XeXS0uCqXvTa6/aw8y
	MwYhO4zfmlvWbA1/Qod+EEzR9UvUUwA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BBTKfhi8DDDyz3/pIu8r5DjBjCuk6Pd7FRij9VQbeeQ=;
	b=zD4K2H6jkit8wTZtpIgBU/jAYymJR1yIZs47UUMm6/LOGXmFDfgBPbykmmJ/BLlB/wxhqG
	k9I5xUDY2ZS3HzYE2f3v417qIwV/JeTRfPATw5ULZL514Da87hBCglyTY80olnmP3PEbtq
	sL3pnSYVWaNGvwe+s1QodITNkDmGKBM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=eiDf87lu;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=rWqMlZZF;
	spf=pass (imf26.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1782804722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BBTKfhi8DDDyz3/pIu8r5DjBjCuk6Pd7FRij9VQbeeQ=;
	b=eiDf87lufpJJoY3iD6mQ0w0B6QIUE09ZDskb6AgMO+sf71FQgS7RAQOce+ARO0skITSxrn
	agEGiv7CK6Ikl3BebB9h218K47Z8NVdcI6qA3nVsgebVFcDPI7IkZ9nwK5jhVLYog+ePde
	fIRVmY4LIjuJVbrsiwvWnkFHAwO9W2mlO8fsdJegJMVrCZwOocfWjgB2PqyRvSNFZti0+X
	sQXkhDCg4aQCxg218vV+LZ95DPYBI7wihE/lcgiU7TmmOyjFofnNbFP//rWUXNAyN21xd5
	enm3aX0W1RVc8uW0ypEe1ksGka3IU4J5Od1I8B0wQawzoD5SeQkITa8GhG0ifg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1782804722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BBTKfhi8DDDyz3/pIu8r5DjBjCuk6Pd7FRij9VQbeeQ=;
	b=rWqMlZZF2MS5qVv6fHEEhtXM74/WsfsRswKtW3YUexgHCpKNerGt1aQHz8Ru+1UMUO4O+b
	K1vZ4SoHsEvcNJAQ==
Date: Tue, 30 Jun 2026 09:31:55 +0200
Subject: [PATCH v4 1/6] vdso/datastore: Rename data pages variable
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260630-vdso-mlockall-v4-1-6c93708ce723@linutronix.de>
References: <20260630-vdso-mlockall-v4-0-6c93708ce723@linutronix.de>
In-Reply-To: <20260630-vdso-mlockall-v4-0-6c93708ce723@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Nam Cao <namcao@linutronix.de>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
 "Liam R. Howlett" <liam@infradead.org>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782804721; l=2343;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=H61r2K6PkZFx+YOky6g0kT8W3xUvIBmiUExOyg2VP9I=;
 b=oqvB2zhbeTcP1JB5vofh+nb3w2d/ACNvZWrzXlUpwrY03dnQ1Tq0ZAbb53F1l8+qUuTzLcx+E
 8oU5V9IQbuuCHP7XQ7R2LQd2pEhiyEBvfZeP1sZLQXQ1B40VLRmKeGx
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 99EB1140003
X-Stat-Signature: wtwmyfj1ikaahmehepcxf9u7wajuisir
X-HE-Tag: 1782804724-574991
X-HE-Meta: U2FsdGVkX1/7w/idxRFMFNoJ9TGaWKr9FYHJXhs7vY6DRDhVs3RGwRa5eya3CG6FPL9ekVHpKGFSQ9tRUtujlmDLTTcQcGBgMT8ljIPXmlLtyyLy2Pe5pDMILEb4x3OEjnypNv+t6Eaz0jxQNyQazEV6zyUMUndeOSH5605/wtsWf8yA1IQ2kBt2Gho4vVg7i+pH6CHKxgr9O6p7c+IK2STXmDXJzozxvygupqwAMZ9tB+wwvBeLKcj6tSlTc0/W/IzQDpRbvhWZRCh01fbyRYY02iFftGJFb5lJ3bRaEmxRydtplPNTpVToqZkVIz9PSKBeK7BwK0Ny+MTaKHi2hNkcd0cdRcijJokX/FgY/zQl0diRZNrSvg+NraRQHsL7Pulv1Ra7aTujWtx2inZ+wF2mMvQGDMCTLppaKLgYZPt7BQchW0fuaYX184c4tW8rr5iQaGoO62H8jRRDVUk4GJlvqGOwI6GYqc1uJ7thn6NvldOARyi5NqLc6LWdMkqRAv52AA4ohXVnOICNLuQ2cLK7nroT3NfarWv9myY2kcbSNVKGDzCRxg5Ep/5U3ptyaVfxOPLs/yr3iCkIBr+2cAFZF0O6Y5YRN35JpJ+xnirEGH9rHWi1zA3z9zBQkWIvC41z7dvNvkIycq3lkv8fvkq66KV6NBLswQXwDncFglSbLCE/7g15vQ83JvGkcCbWToiGI2jpvhxOx20HuBCJojk7nMH8cmEb2Afb+jGdplxqRY6VmHqLIa56jXyWsef00CWYXFmxS2gnVgbqtwfQlGOJIXla/cALyqzQWfAwE5mPZWp3j2vYRBZvGOrYz6atq9CLkZ8yg551+RNGvxsKvYgAo5+qWW4IpabfvPiqxPii1Eu/2YAmvXRlhqaaJNsrL6Ox2spOD/1iB2LaR1aX+V6hbZMhidBolqvMI3phhCrDpdGHApJej4kOrigUZEL+t/DJh3c5TFv3eGA6rAX
 zWcVBb4S
 Qd9dhyUJWY6dJSTshLz3lYIXTaGqoUtELuzPks/BY+PsnGQhnK2jaFaQpsDa6UIeOSFgzzTY90uFfP84/MYiHwLsrsclA57Wm/M+nTWjhCqxtr3c/mdebJabBd0+bU4cjx4J0PbGs0iXHNF7nIkZ0VWpA+EDGmVCoKfqIRMLwWYRuKLwgOjWqFV+NGWtzLeiAEgvA+iwId2XCMoOOkt1hOnBm2WzB3eeaYpBDfSJHZBJbLWZVZjTw2UfRlRkWA9hfRk2DwnhKn72iGgbagAo+bkJKxYkR0X/s5mI6rlVJL5aX9y4hS2pCqgGE0zvgAW2mhLVOfNn7X91WYDlg1JeMQVhBciIfyUG1r6NWfD4WafzVkm9QFVyOwES0XON+gthjZxHgyT7dXDpSkXqb5kBePZOByqOF2y16pX+tV+HiqHVfgLfHYuuWro/1yg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An upcoming change will make this a file-scoped variable, for which it
should have a clearer name.

Rename the variable to prepare for that.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Tested-by: Nam Cao <namcao@linutronix.de>
---
 lib/vdso/datastore.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/vdso/datastore.c b/lib/vdso/datastore.c
index 17d37b82ebc6..7f78a32656aa 100644
--- a/lib/vdso/datastore.c
+++ b/lib/vdso/datastore.c
@@ -32,7 +32,7 @@ struct vdso_arch_data *vdso_k_arch_data __ro_after_init =
 void __init vdso_setup_data_pages(void)
 {
 	unsigned int order = get_order(VDSO_NR_PAGES * PAGE_SIZE);
-	struct page *pages;
+	struct page *vdso_data_pages;
 
 	/*
 	 * Allocate the data pages dynamically. SPARC does not support mapping
@@ -42,24 +42,24 @@ void __init vdso_setup_data_pages(void)
 	 * Do not use folios. In time namespaces the pages are mapped in a different order
 	 * to userspace, which is not handled by the folio optimizations in finish_fault().
 	 */
-	pages = alloc_pages(GFP_KERNEL, order);
-	if (!pages)
+	vdso_data_pages = alloc_pages(GFP_KERNEL, order);
+	if (!vdso_data_pages)
 		panic("Unable to allocate VDSO storage pages");
 
 	/* The pages are mapped one-by-one into userspace and each one needs to be refcounted. */
-	split_page(pages, order);
+	split_page(vdso_data_pages, order);
 
 	/* Move the data already written by other subsystems to the new pages */
-	memcpy(page_address(pages), vdso_initdata, VDSO_NR_PAGES * PAGE_SIZE);
+	memcpy(page_address(vdso_data_pages), vdso_initdata, VDSO_NR_PAGES * PAGE_SIZE);
 
 	if (IS_ENABLED(CONFIG_GENERIC_GETTIMEOFDAY))
-		vdso_k_time_data = page_address(pages + VDSO_TIME_PAGE_OFFSET);
+		vdso_k_time_data = page_address(vdso_data_pages + VDSO_TIME_PAGE_OFFSET);
 
 	if (IS_ENABLED(CONFIG_VDSO_GETRANDOM))
-		vdso_k_rng_data = page_address(pages + VDSO_RNG_PAGE_OFFSET);
+		vdso_k_rng_data = page_address(vdso_data_pages + VDSO_RNG_PAGE_OFFSET);
 
 	if (IS_ENABLED(CONFIG_ARCH_HAS_VDSO_ARCH_DATA))
-		vdso_k_arch_data = page_address(pages + VDSO_ARCH_PAGES_START);
+		vdso_k_arch_data = page_address(vdso_data_pages + VDSO_ARCH_PAGES_START);
 }
 
 static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,

-- 
2.55.0


