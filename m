Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DA10CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 17:51:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85EB86B0088; Tue,  2 Jun 2026 13:51:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836676B008A; Tue,  2 Jun 2026 13:51:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74C546B008C; Tue,  2 Jun 2026 13:51:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 636866B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:51:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F17C740A23
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:51:53 +0000 (UTC)
X-FDA: 84835715706.15.2EAFB21
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id D87C840004
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:51:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wwoT85iY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IEshOL8y;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wwoT85iY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IEshOL8y;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780422712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MvITR44WCuFYVJmAIwWLkD9hwei9C/qyk5kTPLnWeLM=;
	b=yzjAeXJnR1/qjx7Oy+ibGnRmwCwfE/82zoCcFQ1QMLS0xiAbF49OFE7gjWG/J9HI2tq476
	4UxsHlZJATUShP/I6Kx/i/yJW1MhABcFZyIjBi2vLJupr4r1+zIcJQlsIDUY4EUtckBwn+
	9bxMGTg2GmzH0k3i6BKsS3DIOVkozP4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780422712;
	b=fjTA/s+BpovMfq9vC3CUFrDqw/mk+t13MEDlDj8caIkgZTO9wibqmrXt13PMJtMySieP+e
	eBHtFlL2a3On9ORbCsq4Unq0a1WFG7/OOz2vMl5CrhqVviFg+Qai7NWrfs3mVLVg+CvftA
	9srtZEjTfsBPbDXv5PvXUhb8wZvgT3o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wwoT85iY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IEshOL8y;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wwoT85iY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IEshOL8y;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 371D26ABEB;
	Tue,  2 Jun 2026 17:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780422710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MvITR44WCuFYVJmAIwWLkD9hwei9C/qyk5kTPLnWeLM=;
	b=wwoT85iYQDuk9420zJxLqa2JQmMyA2iGfLx1QWmD0jLBFbkHmKt2/D3n5VEe9SJZdD1w/M
	eLofZGn6DnoflSIFovA/36b3XmgGQBF8EXDNhkyRmarBNffcIammF/KCplv9NqwXFH+DVV
	SIjWMO0alybgfoV7i3tMMABhWkQDIc4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780422710;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MvITR44WCuFYVJmAIwWLkD9hwei9C/qyk5kTPLnWeLM=;
	b=IEshOL8yfHLc8hClgbRdHQV6SC4ySrGwPP11nDbFMV595zfO6nna0dkk3ZK9U3/n4KqSXE
	fPkPTHeuAWRKIYCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780422710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MvITR44WCuFYVJmAIwWLkD9hwei9C/qyk5kTPLnWeLM=;
	b=wwoT85iYQDuk9420zJxLqa2JQmMyA2iGfLx1QWmD0jLBFbkHmKt2/D3n5VEe9SJZdD1w/M
	eLofZGn6DnoflSIFovA/36b3XmgGQBF8EXDNhkyRmarBNffcIammF/KCplv9NqwXFH+DVV
	SIjWMO0alybgfoV7i3tMMABhWkQDIc4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780422710;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MvITR44WCuFYVJmAIwWLkD9hwei9C/qyk5kTPLnWeLM=;
	b=IEshOL8yfHLc8hClgbRdHQV6SC4ySrGwPP11nDbFMV595zfO6nna0dkk3ZK9U3/n4KqSXE
	fPkPTHeuAWRKIYCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 07C41779A7;
	Tue,  2 Jun 2026 17:51:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BXvYOTQYH2pVOQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 02 Jun 2026 17:51:48 +0000
Date: Tue, 2 Jun 2026 18:51:47 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, jannh@google.com, 
	liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	vbabka@kernel.org, chrisl@kernel.org, kasong@tencent.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, 
	kas@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/mincore: handle non-swap entries before !CONFIG_SWAP
 guard
Message-ID: <ah8XqXQycZdbYFG9@pedro-suse.lan>
References: <20260602172247.279421-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602172247.279421-1-usama.arif@linux.dev>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D87C840004
X-Stat-Signature: j1i7tt4qxqk1zyb9kxqrj5s7crfqruxy
X-HE-Tag: 1780422711-773832
X-HE-Meta: U2FsdGVkX1/aMmfX1b7zPBcUPFQtnSjlguJX4cv4ZLa0MKKRd/QdHgwOM6K+uq1ju0Q+BYCFvKOmQ3GgnFMmm31FkjjbPfZ1V6VweUIHAItCj3ypFgiSJhCvQCe9+PnC14QeSlu1WkxiHEELc3uc3nrtwci9Pi5qWkBgXj1jKLFcqf+qCLAZnrOqOdjWjNBA/Zj20uiBSgvPGdlNSlwQONL9LN95hec4Tc8RR1TNQXN97PBdzgaVAHBAizrlRiD3bxxrCEVG/cB89h6wLxUugpc5g3RSlBZSXalBSPKM59gGh3eF8h7jpKogoFRHCzwt+qBZSakdZjIjPhsSdjiNSrR+FL8XJdYjYweHQEQ+bQTDXhd3VyY7u44YKkSSTPDnnX/1O+zXOf+m/2ix3kdzLYpx9ReIx41/E62KtsGr8tK6pZhPnjC+VIooVxgfckMD3TXrXYKKs+ryZZVYvjpAU6j8TTgAWEe9uUexYyRoQzbdUUpJazfs/WfgCQUpMgFjHNS83s5WWlSD5pD1Wp2JzbjwvsdiM1V54XYyK3gFlUBrB8W5yNSCNTcF8h8hWry6F7GQtCXr84horDcYOACjJ+VvmKUI/Np/VUiDGIQyO6ccMFzVwmumRutrv99zEh3VPw831Tidf0yYMPz/AcQixRZtxi8RIr4R8OjJWW0u/XmnKi4gRq/LcpUCziF92KjTL/7ZCiOs6gd60HsvpdIzzaRqtp1y1qGS7CYqyyaKrFPth6l1iGZS9YAnya9LLomONx/C0Lmm/xV4EXfa9/I7TjPn82nnnHhWJhRBuACIYqo/08ZiwH8jwIOiK8H/OsRGkb3Y17FPv71sXCSAvRUYHbX7yRvbY08PN6A46t30o9z0PWzFL1MhIGwAIo0/xf3jQa6iIlMQ/W7NaT6rT+YeboRBhlmsEyAlhGTrb3PESs/clr8JcQmRVqrHeV/3ju4DftBMFAPIdP7f0vx81JQ
 mAgHiltP
 CKVmwNdc/ZG5uLKIeKyNdqWTrV+cfAMB7K7WzAp8cyjqQUaCz8dK1Fcd4tGYUySOncEJvmG8SQ6/7h9MClf1V2O6Provag7vF8Y9JmlBlTbzM14aO/RRxkku//DUhgHxpDGbRHq/h1JXN0DLnasLd3MrbSmBoKDr8/bIy6k0JvJj/J8eDJmZiSX5spG6ZblNTqK/k5+MXaIks4S1wEzKYLmBVmRbsG5lz1fz2cjbWcxfaazAipmFSkjN3TkgfJj0/ovOB0vw2FWZDcpV5cfz2vVMM0aF7CnvtswWoITOLCK76Cvet2nJjfHmiA/xVqSxvwA90DAfP0/0GDOFk1/I/pfd3++JtMcslIO3TQSDWDQVUsg1FzcvZXpGkwk1aV/8/NkmnD93PsOSNIlDoB9i4mbjvxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 10:22:47AM -0700, Usama Arif wrote:
> mincore_swap() also fields migration/hwpoison entries (and shmem
> swapin-error entries), which can exist on !CONFIG_SWAP builds when
> CONFIG_MIGRATION or CONFIG_MEMORY_FAILURE is enabled.  The
> !IS_ENABLED(CONFIG_SWAP) guard ran before the non-swap-entry early
> return, so mincore_pte_range() can spuriously WARN and report these
> pages nonresident on !CONFIG_SWAP kernels.
> 
> Move the guard below the non-swap-entry check so only true swap
> entries trip the WARN, and migration/hwpoison entries take the
> existing "uptodate / non-shmem" path.
> 
> Fixes: 1f2052755c15 ("mm/mincore: use a helper for checking the swap cache")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

LGTM, thanks!

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Maybe Cc: stable@kernel.org ?

-- 
Pedro

