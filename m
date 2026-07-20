Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F891C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:29:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DB646B008C; Mon, 20 Jul 2026 10:29:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B3566B0093; Mon, 20 Jul 2026 10:29:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A25A6B00B8; Mon, 20 Jul 2026 10:29:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11F8A6B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:29:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8BE3A801B9
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:29:20 +0000 (UTC)
X-FDA: 85009387680.23.2E3C1B7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id A76D31C0007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:29:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=v2SA3G9y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Dj8vYSKu;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=v2SA3G9y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Dj8vYSKu;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yVNSjruTRvkgKwULiFKDTtGJLmy5SDueID1ZIQoyfW4=;
	b=naqnI9sCNjZhUR/CHo96fZuZVRdG39rnV/lDaFwa5fKoQHoouwIcUs4Tc5HOEk+BufsI3Q
	1V4VGG6U7znG7Z0/qlTPtQDviPt4mMM/D3o9es0FCUI4glCAKoSl4h20D0dgBaxReXWWmT
	EjaAsbAHyg/UXdZw3d/V/SulhKZlijg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557758;
	b=tTpe9Dns8Iutc5h4GNhzeOxdiNJepLf4IIGPML6pDDEuvcWIJEt4P93wg5FV+F92soFTWD
	2wlwaDyh4vlt7mUHMwa4pUuv1WKCBI0Rs84lEPT3HIEEILgWjqrBfbPQcUGxjXgTHKn5iC
	RmeD2rVxHNkzEUnffnwFCey5Yg41DaE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=v2SA3G9y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Dj8vYSKu;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=v2SA3G9y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Dj8vYSKu;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 150733E09;
	Mon, 20 Jul 2026 14:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784557757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=yVNSjruTRvkgKwULiFKDTtGJLmy5SDueID1ZIQoyfW4=;
	b=v2SA3G9yXNOvtCol/w9ycYvhZKF3BS5tghx4427DetpsYQkDgsVow2bELlfb/r72nB8HWN
	nws+XJwmrWvuFDZCEwe1ZHVozq+ckMCoonY/KGHjF5/vSN31h52IJcp8eWoVkdwMcc2FnO
	Xa5NybIaXqkIlEpTiP6Btm324B7RTtM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784557757;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=yVNSjruTRvkgKwULiFKDTtGJLmy5SDueID1ZIQoyfW4=;
	b=Dj8vYSKuzxxNYUwY+x02bgtF2KBZIgdvPuzC9fr8Gy/kcDqptOpN+snje/C3mwy6vcntGt
	VRDyomCgJsYozKCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784557757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=yVNSjruTRvkgKwULiFKDTtGJLmy5SDueID1ZIQoyfW4=;
	b=v2SA3G9yXNOvtCol/w9ycYvhZKF3BS5tghx4427DetpsYQkDgsVow2bELlfb/r72nB8HWN
	nws+XJwmrWvuFDZCEwe1ZHVozq+ckMCoonY/KGHjF5/vSN31h52IJcp8eWoVkdwMcc2FnO
	Xa5NybIaXqkIlEpTiP6Btm324B7RTtM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784557757;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=yVNSjruTRvkgKwULiFKDTtGJLmy5SDueID1ZIQoyfW4=;
	b=Dj8vYSKuzxxNYUwY+x02bgtF2KBZIgdvPuzC9fr8Gy/kcDqptOpN+snje/C3mwy6vcntGt
	VRDyomCgJsYozKCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A0CE779AA;
	Mon, 20 Jul 2026 14:29:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NcfTArwwXmrKTQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 20 Jul 2026 14:29:16 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] mm/khugepaged: collapse_file() cleanups
Date: Mon, 20 Jul 2026 15:29:05 +0100
Message-ID: <20260720142913.846902-1-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A76D31C0007
X-Stat-Signature: rg8z8qrny67gfw5ei9zp71rzx588kn54
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784557758-592757
X-HE-Meta: U2FsdGVkX19Jvgopj1RkhsQwt+IqknLKcJzY6dviiMxsoXjSpmlCkiJBO776Ejl5jhjy8eVQtPiTIlNqFc/K6E4RBlgHo76pLMIuRZKZZFd84fLYZ/igjXUWcUe5rTZOeiOi/bDJycive2FUNjpb5IEA0wLx+Ei19cByshUfEX0lXQSD6UHGJvNs31djYzVmJ48nCH1jlhefUYUnrW7jZRYeA+MUL5XR6R5ru8M4XzibYRJcGn4zqutD8SeiQlle/DwVrcQHW6LLEFwlwBQlpW9JSqp31eohDUiAp6mf8nRXLPvorOsDzpLtZWJ53SbpdYvjFuP2jksLU5SMig2Ry5Ba/kBZ1XqXnx27cvfY4G+Zd7IXKKeO+P+ApZkD+zeO7/Lw5DbexkCn5KLh8dGmvXC9pR4gcgIwmEqO21jebWZqSIuLamBswOltwxB5bEfBiB1MZNI3bvODIrqlQZC12SYAbplQWpUZqxGU3z2uiNubEn4oT+9slIeIQ53Tnq1q7ElvkI9gA2nJPbh9erMdBz3Wdclh8Sc5OERtO6K6SkBQVsJEEc1qyDNG0f5SCi2/hJTaw3KAY3Gy6lQl1JPDntlf5dQ0x/ioZE7kctRCiW8nJptlLagn/dew8ZKICd/VjlLGUyRmQcL9js8O64LqXg/7XXKwLM5hBNXPqMgmFaRSasIB78tYSWoQ3sRumIb/6nNA1O7fQ4knisNgp1e7vSdnruqSftQGtvDF13BcaRAc3CTs0+8JnGM7HONHxbhxpNIk2RAcqrD5xt/2e20ZBPzF4GVokOyFchQKIMdp/3vcXFbaElnOOb3Arv8tSxdx/C2khY7+vsrGGTuK2m86P7/b/nytq3Ccd3nZY4AKg961bbImGjHO97R1hgeQZ/tVcWj1sWU8ZUM9FO+BWFEcr65cHjdlTEm4cUnNKybmjG5gMQrmBliTG58sGVnQX7OCJNfRk3sgnsL5XrdvJxF
 549EiERL
 TOcDcRtvvZ57cTTJdg8OFENibS4V5dTxBM4xoNoYHN5k5glGvxbJ0yKNEUlmvP/1gA6yCa53XLye5Uj7zwCH6Bf5lPc6II2fSARPFfRSh6/gMjsqFUPkwehoI0pVdqW0EOUBin2fIIl4YHGjZMAW7aNg7Qjum6lyN7UnyI90vAICs3gdbksTtn+ZqB7lYFYrfPDk5iwjugJ2XvLb16kBJcjeYojuTBOMnCPsyqmZGWZaAxZdJuxF0dCEao4NEPgzhCiSaUpKYg4BBdMw2XBYpsI77Of++4az/hGkXps+khpxgU5Tt+Vp8PjIf1T5/n0nvEc2jUT8qMfMo+dWObXcYKWdBJXFt1GvbDXuGT6FuawMha/mFs9a5p3cZ5jcDSLG0HbaOQfjNb+X/eA9+PFIysDyRiI2vhd4MiWdIyWg5holbbXp7v4zAocMxO4Gxz/KoMh2vjzPRS+fyfJEz6DweFXZHtPwbNKWUJxAamY54bSgJ4N4R9+ToI8vptc//vgL3lLiOTMDeuslneLf0I5GJ4CcxvV6VT2V7T5pjsm3cVZu+HhnEE2OpcUNV5hCCUHdiTXD4eEQkZ9YdKms=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here are a bunch of cleanups for collapse_file() that attempt to aid
code readability and understanding. This is part 1 out of N, and only
attempts to address the main collapse loop. The exit path is still a
mess but I figure it's much easier to review if I send this batch as-is,
versus sending the whole thing.

Based on top of latest mm-unstable.

Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Pedro Falcato (8):
  mm/khugepaged: separate out windy folio logic from collapse_file
  mm/khugepaged: factor out page cache folio reading
  mm/khugepaged: factor out and simplify dirty/writeback handling
  mm/khugepaged: simplify prepare folio locking and exit paths
  mm/khugepaged: add kerneldoc to prepare_collapse_file_folio()
  mm/khugepaged: hoist isolation into collapse_isolate_folio()
  mm/khugepaged: hoist more code into collapse_isolate_folio()
  mm/khugepaged: fix and flesh out try_to_unmap_flush() comment

 mm/khugepaged.c | 424 ++++++++++++++++++++++++++++--------------------
 1 file changed, 248 insertions(+), 176 deletions(-)

-- 
2.55.0


