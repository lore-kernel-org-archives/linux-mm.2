Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3694AC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:55:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 061056B00BE; Tue, 30 Jun 2026 15:55:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 010066B00C0; Tue, 30 Jun 2026 15:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E41636B00C1; Tue, 30 Jun 2026 15:55:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C2DAF6B00BE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:55:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4E8B11A05FD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:55:18 +0000 (UTC)
X-FDA: 84937633116.22.091A1B4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id 31FEF12000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:55:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=l4uDvqPR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EvXkTdni;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=l4uDvqPR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EvXkTdni;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782849316;
	b=ltuST7cxz03WYyS2QbLmVWXDGJtluBIVW0ZXUbHI7b/5l9n/F2BbZ3xMhAkHBlOyV12JRB
	YlQZQxJ22mySyVEe2rEi5oOesb+/zMUGZVzpRAuMlF4+uF71MnTCyZYJTeSu64d+h24pJ0
	XuxzYJN5+w/w+82F8h8XlENGQMHKkII=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782849316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WwdnebGwB/sLJNe437cxhYb4KK11UT4zCtFlTfRqt+E=;
	b=M9elFa6ml4yokeIMpY7HaKsQ8pJKxu6QlUu0dolSfIpjeWtvS81aMf85ACbK1xZOST/gzn
	6qYpevURD3ujlbj1o4Km8IROSKKrD7LoGg++sHdg6pJsvzRg1rA/q5v2lqvEJhqvtagIET
	2vqowwD0/XZ7JLSVZYRfMqzr5r4CYRg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=l4uDvqPR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EvXkTdni;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=l4uDvqPR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EvXkTdni;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A2E4173718;
	Tue, 30 Jun 2026 19:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782849314; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WwdnebGwB/sLJNe437cxhYb4KK11UT4zCtFlTfRqt+E=;
	b=l4uDvqPRPPFIFtaW2YjtlgadFm/dKGwcKNWxFAUNhNdCK1LXSBg/X/6TqbnveP9N5TtgHR
	aiqSPY5yz/sREyqORl9LyuDf06UjirUXvkSA+cY6+RhfIXUmjkpQIA0v5Kie1a/MunMJ+s
	JYdaWvfbFinFiTo8xNSwsRiMDrqNdZ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782849314;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WwdnebGwB/sLJNe437cxhYb4KK11UT4zCtFlTfRqt+E=;
	b=EvXkTdniK68q5f+czCz7c4P5SrmTsyg/ApETSL37zzcVgQSk4fXOEzynZOGWB+n7lVZw17
	GMdmkkRVi2+7wBBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782849314; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WwdnebGwB/sLJNe437cxhYb4KK11UT4zCtFlTfRqt+E=;
	b=l4uDvqPRPPFIFtaW2YjtlgadFm/dKGwcKNWxFAUNhNdCK1LXSBg/X/6TqbnveP9N5TtgHR
	aiqSPY5yz/sREyqORl9LyuDf06UjirUXvkSA+cY6+RhfIXUmjkpQIA0v5Kie1a/MunMJ+s
	JYdaWvfbFinFiTo8xNSwsRiMDrqNdZ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782849314;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WwdnebGwB/sLJNe437cxhYb4KK11UT4zCtFlTfRqt+E=;
	b=EvXkTdniK68q5f+czCz7c4P5SrmTsyg/ApETSL37zzcVgQSk4fXOEzynZOGWB+n7lVZw17
	GMdmkkRVi2+7wBBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AF4D6779A8;
	Tue, 30 Jun 2026 19:55:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8NDfJiEfRGrtQQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 30 Jun 2026 19:55:13 +0000
Date: Tue, 30 Jun 2026 20:55:12 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Gregg Leventhal <gleventhal@janestreet.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Song Liu <song@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Eric Hagberg <ehagberg@janestreet.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: Subject: [BUG/RFC] write-open file THP cache purge can discard
 dirty page cache
Message-ID: <akQekZUyoKadiGCH@pedro-suse.lan>
References: <CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com>
 <akQIIav_zaK6RmIC@pedro-suse.lan>
 <akQO8JtTxmp89GS8@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2hgan5khfldrqqbn"
Content-Disposition: inline
In-Reply-To: <akQO8JtTxmp89GS8@pedro-suse.lan>
X-Rspamd-Queue-Id: 31FEF12000B
X-Stat-Signature: wnnzj9wkpk46mryq8qwh3q6fgugpnr59
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782849316-715183
X-HE-Meta: U2FsdGVkX18vt7h3sRA/+66DHjiYyQhKvfFDGQeHcPEknG5E/04InP2giINKLK0CcxB1vioi9b75tMCwn2r10Lhmq/tu7y87nj9kM0Sdvrh4AXj+Url3vR8JL/l8R2wgE/DgOg4zvy1ddhmx48e2GKHPq3b7c1sihObUZE1WKgf827s3OWxGxSDI0ZaTNJheNJ/CHZ6jPfMD5PlNMufAUj+uAU9juPg+FEiu4kNy0Yk2VsrhB2RPDUffMFpi2+UvDAVmbYaOpP7VSCgzqvdAspZTG0TaEhFm2/9fUzd2ztWA+kf3xj1HeHcQ/Qw0hLm58sQ7GVlQSrN4+uUIUgZhy0NUgI7sGQcdY/mB0QhyNb+uGu6rxSfFAPMsmKDmOhyX1taJzTegLF67tXoK4aGe+TcRKHtcL/M9PnOiDmG2oaMuKMxFAaQs1RqdCQ0wdUVf3BYQqXU2IpFClI5jByDYHMgr0JYJGbjHwIS7F1ceh58n74KWBsU/mscHPhthl5PY85hzC5sEuRVKOC69HZH7qeTYO8u753DODr025wwgBgyEPAjUwa1A8VrzC8lJ6z3utPCkWEdS9HP+Jccg+gO2Onr/I4TB+8IC+N871g3Zb3pfnmFhtBjDRiNfHiMpzFlW1NdJMdMoyuYbJEY268QaQCcAsDLObgejMcvFz/Lb4sxrl+9PL45tpkVFEKMvrI3VyRwQcMRcKGHO/WpQ4GeulBnffMNmcRm4SfxPMzvdEc9raGwkhH/bGfWHV/K/Gp6v97Z2D69efbGWjNx3kUE2Z8OeQqYcHUr7X2AMV8l4IQKoqTugWsS69j6wIgWS0ZcBMyUPcFABUrw8NsXKfXwu9/T6K1GarSZMzYW0J7gYHsdThZlotMlY39vmxOmK5aDgKkE6WlYrG60yCh58qYIbEihgfOb64Smwz1g7VRAKOs7MjOXhj9FiuNCyL12QVn0Rm5TuoTZhg1FLP2wUWLQ
 x6pjSI2/
 FA58z0Dbjyr9OPwwLtpxpbPiLV76RsSZx6P1tGppFaSPVaBRTO1yzL5e36bKgfy/P51AQmLdoT8YwqYo+ckTO+7w1RDMc4UzcgTSJL4ulbk8JJmorIUsFXeP7RgrkPDlJxSR2zj68eBfTPSVHt4DszUJxvglSSGwHHQwYStCEpDtEE4XPwGgA5AVdDsEvFjbBWKzgEQBwHhBBWx21t7YBW1Xss0LMul1s1uEBVdx6Fcx1DNhp3V9uxYA1DYINANQCUfDkyIo2RRJuyMShpvDraygZl+bLcft/H/554DzyOzuK0Pb7+gLcJLxD77ohKRA6Is9VnfWuGYflkeXh42rgyx+VIUw7/JhWn1iqnmJNbcCFbkU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--2hgan5khfldrqqbn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 30, 2026 at 07:49:12PM +0100, Pedro Falcato wrote:
snip
> 
> Other idea: perhaps doing filemap_write_and_wait() after the nr_thps
> increment in collapse_file() will Just Work and result in a _much_
> simpler fix. And it avoids any weird forward-progress issues as no one can
> write to folios at that point.
> 

Gregg, if you could test this patch, it would be much appreciated. This patch
(hopefully) makes it so no dirty folio will ever coexist with a ro-THP, thus
hopefully sidestepping the entire issue in a simple way. Only compile-tested
and not reviewed.

-- 
Pedro

--2hgan5khfldrqqbn
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-mm-khugepaged-write-all-dirty-folios-when-collapsing.patch"

From 43d90a937f0b24656a8d0405035c3efcfdf0961e Mon Sep 17 00:00:00 2001
From: Pedro Falcato <pfalcato@suse.de>
Date: Tue, 30 Jun 2026 20:48:41 +0100
Subject: [PATCH] mm/khugepaged: write all dirty folios when collapsing

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/khugepaged.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a97b20617869..3f0f90ab16ba 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -60,6 +60,7 @@ enum scan_result {
 	SCAN_STORE_FAILED,
 	SCAN_COPY_MC,
 	SCAN_PAGE_FILLED,
+	SCAN_WRITEBACK_FAIL,
 };
 
 #define CREATE_TRACE_POINTS
@@ -1812,7 +1813,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
-	int nr_none = 0, result = SCAN_SUCCEED;
+	int nr_none = 0, result = SCAN_SUCCEED, err;
 	bool is_shmem = shmem_file(file);
 
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
@@ -2043,6 +2044,17 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	 */
 	try_to_unmap_flush();
 
+	/*
+	 * If collapse looks to be successful, flush any dirty pages
+	 * out the page cache. With the nr_thps incremented, there won't be
+	 * any new writers (nor new dirties).
+	 */
+	if (result == SCAN_SUCCEED && !is_shmem) {
+		err = filemap_write_and_wait(mapping);
+		if (err)
+			result = SCAN_WRITEBACK_FAIL;
+	}
+
 	if (result == SCAN_SUCCEED && nr_none &&
 	    !shmem_charge(mapping->host, nr_none))
 		result = SCAN_FAIL;
@@ -2210,9 +2222,10 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	/*
 	 * Undo the updates of filemap_nr_thps_inc for non-SHMEM
 	 * file only. This undo is not needed unless failure is
-	 * due to SCAN_COPY_MC.
+	 * due to SCAN_COPY_MC or SCAN_WRITEBACK_FAIL.
 	 */
-	if (!is_shmem && result == SCAN_COPY_MC) {
+	if (!is_shmem && (result == SCAN_COPY_MC ||
+	    result == SCAN_WRITEBACK_FAIL)) {
 		filemap_nr_thps_dec(mapping);
 		/*
 		 * Paired with the fence in do_dentry_open() -> get_write_access()
-- 
2.55.0


--2hgan5khfldrqqbn--

