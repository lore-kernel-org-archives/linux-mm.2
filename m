Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00B3EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4A726B00F6; Mon, 29 Jun 2026 14:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFB026B00F8; Mon, 29 Jun 2026 14:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC4E06B00FA; Mon, 29 Jun 2026 14:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 871486B00F6
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:30:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 178771A022B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:30:51 +0000 (UTC)
X-FDA: 84933791502.17.4803D77
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0D8CE40007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:30:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZSKW5IWI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="XiK/ozan";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0Ip6Kwgp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EeYyMfbh;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782757849;
	b=uLe5HKdyWz3NoZ1LHVBnojVe/Gi74+4H86ymffGpP81cgX0cD5WPn7Pskq489WeZuJCR9d
	ZBP9qYvt9BlSfa/aHPODhjz/MyjrGLqHdt2K7WqQlx5NqDmkhXivhghJge5k/Sh1M8nsA6
	AhxOpAgLPIaGAvhoEHwytuYpmquhFb8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782757849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4unOw1kC7PDoCyOC3Zep6sOEjf/lsnW9nQUlS74aFs=;
	b=WngGP3IzciYv3pP/Ncn/7vhEV4n0WJ0Irrc/tsRJ/TRl+stL5rR9/T9QFSXJoRQuuR5Mi0
	V/7H1x2Umj4aFGzif+4uPIa1/pwK5xsF/kc4VBJhrjj1rVOHrEU4TJWStguYanXnmvHkuL
	/UClAfQp6LoXBMx0dLTrsG2oaUgZLuw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZSKW5IWI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="XiK/ozan";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0Ip6Kwgp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EeYyMfbh;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8C5DC73213;
	Mon, 29 Jun 2026 18:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782757847; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+4unOw1kC7PDoCyOC3Zep6sOEjf/lsnW9nQUlS74aFs=;
	b=ZSKW5IWIhLmI75H5Ru137+UQ9cwp0wZYNWh0wLLIwO5UeUdvIAf2J7wD49hRckfFtQs5te
	KCzC0YssaeSjr9FGF/D0OVQ2YRkDRna7X85nfuOKVE/gp+B0yhLSpINVrqY3eRm3M7t9q+
	m/I00eAYwiTNDvSUCNHwMzn1k11kjAA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782757847;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+4unOw1kC7PDoCyOC3Zep6sOEjf/lsnW9nQUlS74aFs=;
	b=XiK/ozan+2lMDL5Detpi57el9beS/jZlYoacw9yUkD5LGELLMmDbFuIPMzf6NDHVdguh8N
	ri9mJsShahj+JlAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782757846; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+4unOw1kC7PDoCyOC3Zep6sOEjf/lsnW9nQUlS74aFs=;
	b=0Ip6KwgpFhy8F4Ou3+lH/mzi+xCwIOYpRGCQ3A3XNcrAfHKigDU/sszYi08H5tg4Xv6+1R
	xdZV1ik8foXtGbd1KHMUkOLd9PFKWatLgTqBU/lEqi7pgcAv4zo/Ll41gcTaMmwmOWKLxP
	wJEC8RthywEFKzfWtAYS9zFXCNRqa/E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782757846;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+4unOw1kC7PDoCyOC3Zep6sOEjf/lsnW9nQUlS74aFs=;
	b=EeYyMfbhRr8oQQjM/Igb3SEFQJcXtgZp4ynHWIVDTLcZcStgOopApUqSajIw8RiD8N7NHY
	ZiPQqv8eCeLo1ZDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8D138779A8;
	Mon, 29 Jun 2026 18:30:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uIrYHtW5Qmr0dwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 29 Jun 2026 18:30:45 +0000
Date: Mon, 29 Jun 2026 19:30:43 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: do file ownership checks with the proper mount idmap
Message-ID: <akK4CRgiv9G29UiM@pedro-suse.lan>
References: <20260625153853.913949-1-pfalcato@suse.de>
 <s6mr3j7gew2cgerzrvqzenjctctrtnhvlynmcccxb24uszcauz@5iapd6wnbfxg>
 <20260629-sektor-gaben-gepokert-58db0a3528a3@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629-sektor-gaben-gepokert-58db0a3528a3@brauner>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0D8CE40007
X-Stat-Signature: 6fkui76rzacch9rbep6ed7j9ss48jotr
X-HE-Tag: 1782757848-147323
X-HE-Meta: U2FsdGVkX18RxMlVjnO5c5g9LkzTH27WkyNZ++Qk2N0fne4huL0lJpnsClcU1pDHWzRnJDE4iIE/z+qBAeO+Luk/WNyIB0YoBhpaHzG3YHhZXSk6nboZTTFUEuHmauPJON8NrftDUFryisKcrCVNjC+ChHVnAF6Wpv+OfaBrtcUjLW711MTL7hwLNzyLYepm4eHhJ5Q/MVmctseQtkzflOBzHfTqKvMakGcGbqpapEuVx7etxMg+rRONmQogg1ycJ9lRTxmztUl7GLVDe3Z7dDMqsYrj0kUMfomeCDIUIvQWOKl693Pwyvy82ZS5qtoLxHIyO+N9oEB/5Z3jCpjfYWuTllSE09I4P+mEooDmchj1kgYxFf2eIoGxB8n7Om//Hc6giJPBUESpZf6yFnUfyuMvT1zMgSsQP+UPC5EtNZjgM9N/CtXRekL0/2WX0Uuo9F+HAwK/N2viY337XDlc91jr2Hxucc1nOsWkKuKWs3sllni5eM6EyLeCGfE/qWpcyyZq7RPeCk+Tmp9JO67jxPPaqlDgDMyAkFk+xCppnosiPxOlna7rpWrRa6lB4yx876vSJQo5l1QgI7Mbu8DYGeG0fsAqgduANlwmEuO3WclqQwfWdb6NEdRS/tjG7Yxya2ONk8iBDGDtY1jTf3nvIz7IrJOuO9C6eF/xO0c89HZZOdqDojegpjtDGmG7UrAHc/u+RtrgF+w61jRrjmfZBfv/2aNfE8OsU9wYSsS2g0JSSrmTXqVu44s4BBWHwUaeAfw0Gw7NbWkE5YDd8CmWPLytA5NBJpZ/RwUQiA+XF78VRRFdEpnkP4FpuULgki6xbpfl9DZ8p04Nk6HlRHf4unC7DpVdSItVEHkf5X8sB3A4+6A0bNngeTHX/bNnf+mWNVblPa4AK3zouBdfm0hJrVBqkjC2aiz4t10uo6GT8UHM0z4IaIEEfoScRS9WorkMLYHerO4h/2wOd9WNRMy
 B4JwHeN6
 oTaJbWUdXcmX5x6sSVjutCXL5NncrDRqvSYjcrloph4dENouXm5qJ3BItn2BqUsS7qSotgV3Oqf7UCfTEtqGPaYm56lDt0L+zc2Lz0aVATfaVAIMpgRxL8d6co9CGXD5RJwBWuP1O1+42WFXlhUikjaAP4bhP7XhXnxe783AHrTmMW9JoVrT36N6bHqvw+5obhC/4j1+BtmhDhY5CGbQZFcx2yeKSx1gaPDvt64tyRet1HsOpHh5vGaBoIpTQGxnaHyUSMeZ6V6WzYxJ9OJhjXZ40uMTI+yf9xgay
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 02:15:19PM +0200, Christian Brauner wrote:
> On 2026-06-26 16:19:18+02:00, Jan Kara wrote:
> > On Thu 25-06-26 16:38:53, Pedro Falcato wrote:
> > 
> > > Ever since idmapped mounts were introduced, inode ownership checks
> > > (for side-channel protection) in mincore() and madvise(MADV_PAGEOUT) were
> > > done against the nop_mnt_idmap, which completely ignores the file's mount's
> > > idmap. This results in odd edgecases like:
> > > 
> > > 1) mount/bind-mount with an idmap userA:userB:1
> > > 2) userB runs an owner_or_capable() check on file that is owned by userA
> > > on-disk/in-memory, but owned by userB after idmap translation
> > > 3) owner_or_capable() mysteriously fails as the correct idmap wasn't supplied
> > > 
> > > In the case of mincore/madvise MADV_PAGEOUT, this is usually benign, because
> > > file_permission(file, MAY_WRITE) will probably succeed, as it uses the proper
> > > idmap internally, but it does not need to be the case on e.g a 0444 file
> > > where even the owner itself doesn't have permissions to write to it.
> > > 
> > > Since this is clearly not trivial to get right, introduce a
> > > file_owner_or_capable() that can carry the correct semantics, and switch
> > > the various users in mm to it.
> > > 
> > > The issue was found by manual code inspection & an off-list discussion with
> > > Jan Kara.
> > > 
> > > Fixes: 9caccd41541a ("fs: introduce MOUNT_ATTR_IDMAP")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> > 
> > This looks good to me. I'm a bit curious why Christian initially (in 2021)
> > used init_user_ns here instead of the file namespace... Anyway feel free to
> > add:
> 
> Back when this was added only the do_mincore() codepath existed and that
> was intentionally left unconverted because it exposes the cache
> residency status. So it was effectively a massive side-channel.

Hmm. I'm not sure what you mean by this. Wouldn't it be more correct to respect
the mount idmap (given that a mount-ns-capable user mounted it with an idmap for
someone else, or itself) for mincore? Am I missing something? Or maybe I'm
misunderstanding that paragraph.

> 
> Both fd3b1bc3c86e ("mm/madvise: fix madvise_pageout for private file mappings")
> and specifically cachestat() came way after all that.
> 
> I'm otherwise fine with the change.
> 
> Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org> 

Thanks!

-- 
Pedro

