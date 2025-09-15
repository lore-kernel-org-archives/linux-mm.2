Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD7A0CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:55:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04AB38E0008; Mon, 15 Sep 2025 09:55:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2DE78E001F; Mon, 15 Sep 2025 09:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE4738E0008; Mon, 15 Sep 2025 09:55:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B3C6F8E000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:55:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E7D313B90C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:55:14 +0000 (UTC)
X-FDA: 83891631348.06.B68B5E6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0631740011
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:55:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sMZHxzxT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZvB3dreT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sMZHxzxT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZvB3dreT;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757944512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MVmn++9xJB9GpxveASuMULaQTKTMrSj+26tW8lFK6LI=;
	b=VA6UJvBHgjDTWtqoqCC3Knq6okmc+GFrZZX0f51xy5sR3QN7PwpSUxU6XIaf4Dh5rmV2VF
	kQGDVaHU6MhZfW2NiSbhPuQYpE0jOM+i75jdX+59qadvhIA1o8jAcWRZGxiKiJ3vn7PK7O
	POQPTYxYfW0QgawuL/0YBY2k/z6fplc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757944512; a=rsa-sha256;
	cv=none;
	b=7/7owK0hA1brj7ZiOE4WIMzIsH+gnPUu8QZxGG5nwM4hPp36m+qlC/bKzNJCkaufhSxy5u
	RRQYkMGA6TF+xvX6649jA7nzIY/PH2H8G00WpJeP1SFcQV4gi6iR3hI+rX2bPnnobHEKTf
	UHhTRGmG50aWw5WboDpXt3k+nazVNMY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sMZHxzxT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZvB3dreT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sMZHxzxT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZvB3dreT;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5C936336BF;
	Mon, 15 Sep 2025 13:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757944510; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MVmn++9xJB9GpxveASuMULaQTKTMrSj+26tW8lFK6LI=;
	b=sMZHxzxT/K4//pDSK5b0FvXDxnPAklwI8Jqhin6x4U/N00Wp1kKG6NHeIjRISYSrMLuDkW
	3heY/FBZ+ksOrq1k1wAo+ByP6DVNJay6TR4bJv+fpXtioNrp/RUNdnBpe3oORGWc6Ne3GQ
	UL6R5ZiPS6AcoLjDUEurUaQzg0aglOI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757944510;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MVmn++9xJB9GpxveASuMULaQTKTMrSj+26tW8lFK6LI=;
	b=ZvB3dreTfm43G16xd6mRYRFIm3Ocd6F2n/Ls0ww1kbdrjpV/IO7uRpkxoFqbEJKBIbO3/z
	V5bfC1Qm/qMSsZBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757944510; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MVmn++9xJB9GpxveASuMULaQTKTMrSj+26tW8lFK6LI=;
	b=sMZHxzxT/K4//pDSK5b0FvXDxnPAklwI8Jqhin6x4U/N00Wp1kKG6NHeIjRISYSrMLuDkW
	3heY/FBZ+ksOrq1k1wAo+ByP6DVNJay6TR4bJv+fpXtioNrp/RUNdnBpe3oORGWc6Ne3GQ
	UL6R5ZiPS6AcoLjDUEurUaQzg0aglOI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757944510;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MVmn++9xJB9GpxveASuMULaQTKTMrSj+26tW8lFK6LI=;
	b=ZvB3dreTfm43G16xd6mRYRFIm3Ocd6F2n/Ls0ww1kbdrjpV/IO7uRpkxoFqbEJKBIbO3/z
	V5bfC1Qm/qMSsZBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 483CB13A92;
	Mon, 15 Sep 2025 13:55:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wB9LEb4ayGhnVgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 15 Sep 2025 13:55:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 15 Sep 2025 15:55:09 +0200
Subject: [PATCH v2 2/6] slab: wrap debug slab validation in
 validate_slab_ptr()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250915-slub-slab-validation-v2-2-314690fc1532@suse.cz>
References: <20250915-slub-slab-validation-v2-0-314690fc1532@suse.cz>
In-Reply-To: <20250915-slub-slab-validation-v2-0-314690fc1532@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0631740011
X-Stat-Signature: rpionrd5xpt9hgdw9gofi1x5czs1hz9t
X-Rspam-User: 
X-HE-Tag: 1757944511-516545
X-HE-Meta: U2FsdGVkX1+O6rpcL1ZO5EQSBiSlsukx8UWZO3NSinqesPvFxIWODY2eqA65SzT/WTHeHgOBrUymszX2jCGunpsZL/m0A/PtJVFQF4G11emXps6VFthXW4rFIHcJQ+RYjqk7jh8mtkEkyTG8nYRIOAq3YtE/EA90xr/q0yxXT/SG0bNj8tsii8/buOMwDwL85K9wMvAh/fc000g6vkGncmbu8M02GvdNf4hr1+FLsL5v3sfDw0AqkubCcidqNln5FY/rl5C3R/8K7lGrKGsTjGxvfuSk3GIUs7PgTDPo802mxK+shlrjhBnHmR+9LpBzrlUHORbd+B89DOh+ICHaHwDidU1+zW2IGtJkwIDBGR3CgksQI0Ajohh+nayj0vkGKKksIT+k1LXMXDtQbAGa/CHXM3hm501dRbqZ02mihLpHxB6uLzCunWTnajcH/XDT2EtVCrgIWefZez1IQRGhjePDeinGzA8Jmo7DaOdQ7V8eE29McYYIQdyoCcev1Y9kSo19DHJMUoeVNDjZK8Kyy9akBmaIO4UV6649It35NGVV7yDWp1eYtOkFK5+AWJKWowteYiTzQMRRlg19ybAMT13f8PN4sTz5xgAXJbQXcLpN1IyQEQ3oWn9jGt5y5DxP3AiqYadoOJd2K3rBXDuc9ZpFd5YQZ2V/wUnE9YHuPxbTcOSfG6xjf5QaDoDSQ7Pb5o4lS26lxnzS8N/AV9MMc/txJlg1hLqSGNCFumoFCiJv4TiAM6pgjvWq+wBlzgG/xcQmln2nZeh+p/nsTCH/AyrPn/rBnm3cT3b04pDHza0TrfeDwsXYk9zmeoFI4jqFMHH2gglVAup+3Mkon9z2VFui9RM1w3ZVh4mkh91wh2VnxVsFCmbis4OkJjn1JoVc0V4hb7O3pESWxvGgP/vh8Da0a8NBLuG2dJIOHG1yM7v/yB5tpNLmJ6KDg1o93kbFEkbJeF/OqGcbnyogHHv
 TJM9Ah73
 0hraLz+bp+zd9z5mv6DGBF0Q4nlnOp5lxWIHXjmtzOKAL0e7AcecsmiT9yesRE91Le6Y5Rk8dyeEj/cbbjZ2IS9UsxEPu2HzfDkIWvR7XV99U8MAm3x4RSVcQh4CgMyrS89nGK2P8mmNvf8QWiyuqnGWZ+EV3GehqXoScVF7t1RJ8hQe0NyC3ATPfbNWU8PmP9RZegCr8fBdsoyw8DxDBTkt2Gx+EO4nGpVfTHX16T3fzOfLnCJ5IdGP2MDUivDZ31L82qp1wS6Hv7a9QEBDjYCLHlpT1nhScsvYD/UA72JjWno4Sbs8K6x51VoBfdYYJzkaZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This will make it clear where we currently cast struct slab to folio
only to check the slab type, and allow to change the implementation
later with memdesc conversion.

For now use a struct page based implementation instead of struct folio
to be compatible with further upcoming changes.

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 56143bfd1ae319d384981c810a5ed84af00f4afa..75e4388d507d1abcbce8c7d5d2581381de46cf4d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -821,6 +821,15 @@ static inline unsigned int get_orig_size(struct kmem_cache *s, void *object)
 	return *(unsigned int *)p;
 }
 
+/*
+ * For debugging context when we want to check if the struct slab pointer
+ * appears to be valid.
+ */
+static inline bool validate_slab_ptr(struct slab *slab)
+{
+	return PageSlab(slab_page(slab));
+}
+
 #ifdef CONFIG_SLUB_DEBUG
 static unsigned long object_map[BITS_TO_LONGS(MAX_OBJS_PER_PAGE)];
 static DEFINE_SPINLOCK(object_map_lock);
@@ -1453,7 +1462,7 @@ static int check_slab(struct kmem_cache *s, struct slab *slab)
 {
 	int maxobj;
 
-	if (!folio_test_slab(slab_folio(slab))) {
+	if (!validate_slab_ptr(slab)) {
 		slab_err(s, slab, "Not a valid slab page");
 		return 0;
 	}
@@ -1653,7 +1662,7 @@ static noinline bool alloc_debug_processing(struct kmem_cache *s,
 	return true;
 
 bad:
-	if (folio_test_slab(slab_folio(slab))) {
+	if (validate_slab_ptr(slab)) {
 		/*
 		 * If this is a slab page then lets do the best we can
 		 * to avoid issues in the future. Marking all objects
@@ -2818,7 +2827,7 @@ static void *alloc_single_from_partial(struct kmem_cache *s,
 	slab->inuse++;
 
 	if (!alloc_debug_processing(s, slab, object, orig_size)) {
-		if (folio_test_slab(slab_folio(slab)))
+		if (validate_slab_ptr(slab))
 			remove_partial(n, slab);
 		return NULL;
 	}

-- 
2.51.0


