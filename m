Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46765E9A767
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 10:53:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A63C06B0089; Tue, 24 Mar 2026 06:53:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A14B06B008A; Tue, 24 Mar 2026 06:53:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 902CF6B0092; Tue, 24 Mar 2026 06:53:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FC676B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:53:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 101E2C21D9
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:53:34 +0000 (UTC)
X-FDA: 84580645548.26.7EB15C2
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 927F240018
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:53:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VWCQHOFs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=06TEXqDA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=X8CO5d1D;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Z+11IdvD;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774349612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/4S5XjHKz0DZYQMim8XLyACc+SBQ9v7y1dKFSSo7LOA=;
	b=ALGa51hDc5AEEDPjGfv/A67cMmXmZxWjgIMKvz9JMcDuclxXmLA35HIAsEe9UDhYt0rB6x
	ZNWob5RXlkYFRhpn95qhsI5Bs72t+bhJioUuSOhPcwkIW8UbjxlBG8YLH2kF4dC1u3WLjq
	rxZbcuwOdHBTqBaBQMnq/gErGg1WHVE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VWCQHOFs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=06TEXqDA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=X8CO5d1D;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Z+11IdvD;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774349612; a=rsa-sha256;
	cv=none;
	b=YLVKQ52jvXDjHG7geG2JKKgC1639Sz0eVNg9aEoIAQ34JZIqPD+YjQAk2NhWz20bDOVgQm
	6MdTDQSE7tBZ00KdB5o8bPgwEMipiiQAtxOyGWtCqEFYWztNMAj22twA6buEfhZ1LulHOe
	gIFJ2yrYXJJFOkd4miPvsl1NDN4BqNE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B3CEE4D1D4;
	Tue, 24 Mar 2026 10:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774349610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/4S5XjHKz0DZYQMim8XLyACc+SBQ9v7y1dKFSSo7LOA=;
	b=VWCQHOFsw+C3++nfrnccFjgcIse/w7jQNnbsrHUAA4xU+x2G86bgRGQDDMbfL5H8ryOy70
	7H2vtRvNyJFoE8FW0JgsOmeKK+pqUF57b+Q7Bwr2NXsBpvQe8vsFF8RW5ytbeqIm/lT6w5
	BTPZDqyARKjc5CH+3jQQ0XfqzWheg3I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774349610;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/4S5XjHKz0DZYQMim8XLyACc+SBQ9v7y1dKFSSo7LOA=;
	b=06TEXqDAAYcnNLT5SVI7823gppHVrxWZpGicSL4cu8cGDQYCmECGW7zmQrAV9KlOTDTq1K
	ie/ID0wPh0P/lwAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774349608; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/4S5XjHKz0DZYQMim8XLyACc+SBQ9v7y1dKFSSo7LOA=;
	b=X8CO5d1DUmHp2VO4QyI0H5v+ba+GcIH7FXU6W867cFUtwBKXab+U543IyJJg3wO2N+jd/P
	SMoMKTe8k460Rd3x8qeH9dy57himSdROQA+6xJlCBJjVd8arMeao3pv0qtSyg2jzasxPDY
	5xsiLVV4lzg3mUSgT2XB/ROKcoWmtMk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774349608;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/4S5XjHKz0DZYQMim8XLyACc+SBQ9v7y1dKFSSo7LOA=;
	b=Z+11IdvDXlya3KDoXCFUESeCdvU7wkcRKE0CUx7NvJDpwOT0/9AfAZQyYyYAiuRwwOa3NK
	4nUR6oWd/KUd8SDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AA88243DD2;
	Tue, 24 Mar 2026 10:53:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id G9CeKShtwmnQBgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Mar 2026 10:53:28 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 61743A0B32; Tue, 24 Mar 2026 11:53:20 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 0/2] udf: Fix race between file type conversion and writeback
Date: Tue, 24 Mar 2026 11:53:11 +0100
Message-ID: <20260324105132.30490-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=547; i=jack@suse.cz; h=from:subject:message-id; bh=CwJlZ2F2j9UsEK5kSvG6l7TjTKlTSfs3n/eqtsjvywo=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpwm0WsUFOhPgucO5Dgi0d1wsakUOnBDCw7v+/w UxeyuMVBf+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacJtFgAKCRCcnaoHP2RA 2cXeB/9qge8TluLLC2ZDJUdJDmU9+x6/Vc3RSdp6QzsvevXoWz/m1wnJgCwlLZzpTEuQKyHbLUm 8zVaGHWawVhqK9do5cFLlDK7YC2Jh0ymblMFLuD9VpSAoT2Hbmigel1IHOFyt6HkpFiXrM/XV5b +QE9pBm/+CteZ8bPZuP65fWz0m19mqFCy3GphJj5EVkxJgwxMSj3IhiHP1d4gopJF0KoW3I/KVe SkOP7sefaFojzxFWu9jIYdt9i1qOXATgFyQYYIfKtxzOfJ03njfhi0gWFab4MlyTh1bh2HcrLrn +p4kdO2Iec2sEeeC0Qm4QM9SuChhNOgj3ybC0ZCyi7z7wUVG
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 927F240018
X-Stat-Signature: 6gfag65gkkfs6nbxwsi3ukzuy49ygq7s
X-Rspamd-Server: rspam06
X-HE-Tag: 1774349611-961062
X-HE-Meta: U2FsdGVkX1/jKtbC8F1bAC3sBkSXtzGOLY0Bv/hMq1IycbudBfnSBClXmQnZ/3gCryZibd+sIJAU4gv846/sxqCjAV7hCBv9Lj73RW5DvQWYg5Phsjg+GXuJaaa9perl/ibk9qt/78CMGdBTnr0fhOKEJ2ezvqjDpNVR7e2xTmW65C+ABYHfrQevAhQvyup1CFpLoyJx62BiK1X/dsRrCRkxTe5u4ylH/dsENCnU93LinDNbBL2U7xOkJ5sL7MgZ1K881fyNAc/3uiTCGRysbPygE4zwgRsz78e6RWPpdzcUcZXrXXf4XWTb1/kOt1e9XNQqjmKJt/DmdIsJN6GKs+WZrhgddRLsIgn253tzzqc7TXcEgIGcJyV4jtRbjjaLiVGKfbjuT8NhiSEA5rwdxccFnBGy9nPGFfUHrwPbWGJLf8a2mT/fpcA5xkoocy3vSpWHxln/rGxxoPnYYnjZHXWX4iJzA3dHRhYaksW46AV2d0S3xtx1FwBrSLdtu7YrusXs7rPAT8COOBvVZWqMtLE2fYHy1xibcAYtPtkzXveCIpR/AMnE2voPpzdwzxolPzKNgo1IshocmybeS32NOxbwG11pZNmd/mvgj0ltUTSZxYxKnFB1iU4xt9F3sQtcwmmYlJRQ3QEaHol7YWEZO47w74IHFf90lOpECYGSmGHht0mvxt+MWyPq8xaKqStuEHaUP16CLhLkZhu9UvLIxjBWg8je9OuJCB00uszbIotdyikydoiFiesuMgcg494hIwK8xT/odryU/SspxKdJuPfJfKEet+aGp7Uc1Mp7AGWYW8Uf9s1SCFmtkgNGMnLZRaZESiAwSQGV7DlEzMGtGRhUqkaVJbzNyetirX24eDcS+sDVVcBzI7yvWdWw64UfDEepnUhuuD/1BullSni2qSsOuu21Qyu/CqFW4nonOPKMgwo81o7p9nDybzcRBRo0+rnr0CEJNfjv/uIa4Yo
 37aPqTGc
 avFhCfTgbw/tpuERt0x2sK9cH2uu/EIq5MyqONuR/XCC9TRC/JmQWnDeBW2Soq3cHpwNMN8slU76ssSWt6Y2UhaARoWuL6OnnBTP7vYmXl+qdAFl8znLr86UiubDl/Hxm2mbjt6UoqzmXDBvAM8qkeGzUBoDJRNBXc6IY2RuPgULPPkghwIzCiU+rpFJMvEWFX/Avd3M477Ypj1Ie5jpO4ac0GU+e4LKN4TEk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

here is a second version of patches to fix a race between conversion of UDF
file from inline format to the standard format and writeback resulting in
possible memory corruption. Review/Acks are welcome in particular for the
export of folio_prepare_writeback(). I'd like to push the fix to Linus soon as
it's kind of nasty issue.

Changes since v1:
* Fix crash in udf_writepages() when file had no folio in the mapping


								Honza
Previous versions:
Link: http://lore.kernel.org/r/20260323162617.2421-1-jack@suse.cz # v1

