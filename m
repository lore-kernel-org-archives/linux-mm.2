Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51000C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 09:03:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 471A06B008A; Tue, 28 Jul 2026 05:03:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 422C06B008C; Tue, 28 Jul 2026 05:03:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3120E6B0093; Tue, 28 Jul 2026 05:03:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0F7A6B008A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:03:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 704A4160369
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:03:03 +0000 (UTC)
X-FDA: 85037595846.15.D189A05
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 730F68000B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:03:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wYb8resh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2fmHCJd2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YtuIeJiX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qCzd+wAK;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785229381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JiBhapS4yd3JBk3wJMMLnPaSViFMEz/i6gX+eA+O2Vw=;
	b=TFMzYa5UM8oYGKZ0+b2DQ54e8Lp1gKPYh/MbveQnWkCgNQ1v6PX8QnKY/dmttYmnJiVuuK
	E7uJtakgGA8UINZxrjoUa63Hp7YdYCkDMupXjbfrmgXvyvCWif6oSOXaCfJc6rUA1Nenhf
	0bdPpVEnXfDRcfqffqkiOdoMj2VrNeg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wYb8resh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2fmHCJd2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YtuIeJiX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qCzd+wAK;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785229381;
	b=Qx6l+jFLHGDV30Au7FxzM0NgQrc0fMfllF3GrhA1BvqWEwTiMjaWNPl3GtyuBYOYYu6Lsm
	2FfvU+EW2AHCTKKI6zayxU5NyVUgb/6RNUzOvXWl8qCj2m7Kwlvk1bdQaMgStPs7XVld6K
	pYiuaXlSGoMvUvdHyLmQgif4xlf+vws=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A8DCB7BFED;
	Tue, 28 Jul 2026 09:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785229375; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JiBhapS4yd3JBk3wJMMLnPaSViFMEz/i6gX+eA+O2Vw=;
	b=wYb8reshhb4u0odztJ4Ng+smZ5J/g0IrHOApYodJP5HrMPW3BPbXz66qTehSjGLKS5TPMW
	IufzoIzv3NhZofGV8MrrD6vVVY0XE9PJDgJaaxH/EI957SzxW6GXDJpA0cmesNZk3+bvXh
	jfpO1OI/R71BOdq6tm1KxaVwcOdAxTc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785229375;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JiBhapS4yd3JBk3wJMMLnPaSViFMEz/i6gX+eA+O2Vw=;
	b=2fmHCJd2idKLYwAG+LkZgqszy4AFjM4N5MUlg7YvQJguxz/QLAaz7wrsfD2ra0aK7EgmGu
	KL65yyCf1wAPVuDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785229371; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JiBhapS4yd3JBk3wJMMLnPaSViFMEz/i6gX+eA+O2Vw=;
	b=YtuIeJiXTMplrLFSdAxB66MlqasaLVnU1LDXcuVat/qqWUTXIbj02psFQaGNvhoiILuMv/
	lmfU1TUpshjZDU9yES5Ib//lY6CLu+v3FOsibGfxv2mAvX02t94bYdvUjN8PlXiXfxIPTt
	p96Euc/+3XFdZWZKJlcxHtJ/mrG95yQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785229371;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JiBhapS4yd3JBk3wJMMLnPaSViFMEz/i6gX+eA+O2Vw=;
	b=qCzd+wAKRqGnVNA1kDTbGrTP60YRDlO94dCbG1lOIlVEkDB0FNtXMblzA/P4RmwE2USyE6
	RfP08vH81oxFEeAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C269F779B3;
	Tue, 28 Jul 2026 09:02:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8zFPKzpwaGrJVAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 28 Jul 2026 09:02:50 +0000
Date: Tue, 28 Jul 2026 10:02:49 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, Jan Kara <jack@suse.cz>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: do file ownership checks with the proper mount idmap
Message-ID: <amhoqhLlYROZXOLh@pedro-suse.lan>
References: <20260625153853.913949-1-pfalcato@suse.de>
 <20260728-kreieren-innehalten-anbot-d92ce2dd10bd@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728-kreieren-innehalten-anbot-d92ce2dd10bd@brauner>
X-Rspam-User: 
X-Rspamd-Queue-Id: 730F68000B
X-Rspamd-Server: rspam01
X-Stat-Signature: u84mzgf8t5m9yw4mrepdtihyy4uzd7rm
X-HE-Tag: 1785229381-17669
X-HE-Meta: U2FsdGVkX1/T3yHKzHr0BG1k+221sJd7+AVcxDZKuLwhHJxabdy4jNBsClA+Q1oSHd41abvfgOOSGyQiLwkcBqZqjsFTXsCAmRVyj9TQ7u7rdWhUEvfYbeYLk2RkMnDApaCp1TeUDJ8aCRRp1xlBivz0MAYHhbjoTqH58lx1oiza1RByXKUB2j2ZqX5mfxoGoyj1EYMHPcuQR9CB+lZElq/R9AFQHFxOTVlRSrYBWC96bNQ/k55M4nFnbXGF2R2CpVBOMmPcPr3UtcwmUPMribKZr4Ck8YjL1Nn81iFEV2UN8H+498iPzPGH3KKmkmzfa7QbDECOzKIkA0bWfY2CEztq4i3XU2Lbc97NiJUCMj7tzYCnEtQn4swEyJJT1QS6LJpCeYPIyzLcaC6G1QQvRuHl6dS2/5Pf7r2xUNDQohe3eav96GbVVN8TcNjR4P/bJQ6na/M0toFyLCSBvSwkfzhYaCPltl+0RntGc3d6I9f6v6G0o4lfy9+RY7OUXhCmv5pkq00ayEVKnBKYiC60RR1I9ZDMfDb6x+OL/JUuUWgBZNyUrPMq0iXIapfR1mCGrG6lVlvZ3ALOI//npkST0f9/HHRDZm3rXQjA5C2Ig3Vk6WSxrhba4ykM2w9SERNXzVpeKvqTV19GN8kfjwsRltDSPf+hBHj5AqfkdqjoSI+VO5p0Qtk6qxsUN/QBO6hThCadJnLYe8FI4b4sNyq7KXqvwTx+DgMZNstEAMFPqVQFRZLstvOan7Yk/4iI1l+ZX7ov3S3DNT2d2cwTsQSvokfaG6Nb8SCSv4iabTlLVbbQfo1Fm0BdTJC+wktBoHzBKv4foiH6xb6ibskCbIHOShpwRLOKiEEBDaPbJEw2C+7qf+LXJVigH40k4tTq0z0SsHNPbo4qglBQqDYA6gceUBwgQMQeCKZ84PuQrDssDW5vCUrDl57SXhPeJQAKOhXalHELDp3Cih3aQcuWM3L
 HPiJ5EEA
 kqO0vwMOjsFcVQHuBzdAZvSaZzkQ3ibVhhDt8rQvzUzp+fVvylN2+FkuVp9KDbrGcXyTbTkuRU/uSrER+ZYcBa3HnD3ng5kzdOmF1EwEBQOm8g+XVLn7IHvqJsfQJeV53a2YctqdmtdItWobYaPnUzfuYQeptC+UEVsRUpPS3FdyBizFSNmCp4KJVc4moM3cp1muGZckwi5bsH4q13KjpaPmOEjSYAcqAGnwE1e6l8JbCMKzX/3ASuuFH3awqn+3ecRsVYuHiYd0PXDsjXo+KnWFX9s4GmfaX7sGT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 09:52:26AM +0200, Christian Brauner wrote:
> > Ever since idmapped mounts were introduced, inode ownership checks
> > (for side-channel protection) in mincore() and madvise(MADV_PAGEOUT) were
> > done against the nop_mnt_idmap, which completely ignores the file's mount's
> > idmap. This results in odd edgecases like:
> > 
> > 1) mount/bind-mount with an idmap userA:userB:1
> > 2) userB runs an owner_or_capable() check on file that is owned by userA
> > on-disk/in-memory, but owned by userB after idmap translation
> > 3) owner_or_capable() mysteriously fails as the correct idmap wasn't supplied
> > 
> > In the case of mincore/madvise MADV_PAGEOUT, this is usually benign, because
> > file_permission(file, MAY_WRITE) will probably succeed, as it uses the proper
> > idmap internally, but it does not need to be the case on e.g a 0444 file
> > where even the owner itself doesn't have permissions to write to it.
> > 
> > Since this is clearly not trivial to get right, introduce a
> > file_owner_or_capable() that can carry the correct semantics, and switch
> > the various users in mm to it.
> > 
> > The issue was found by manual code inspection & an off-list discussion with
> > Jan Kara.
> > 
> > Fixes: 9caccd41541a ("fs: introduce MOUNT_ATTR_IDMAP")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> 
> Did that go in?

Yes, this is e187bc02f8fa4226d62814592cf064ee4557c470 in v7.2-rc3.

-- 
Pedro

