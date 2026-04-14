Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CB1AED7B96
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 10:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97D286B0088; Tue, 14 Apr 2026 06:24:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 954BE6B008A; Tue, 14 Apr 2026 06:24:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8919A6B0092; Tue, 14 Apr 2026 06:24:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7A0896B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:24:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 378651B8125
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:24:12 +0000 (UTC)
X-FDA: 84656776344.17.51BF2F3
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 069CA4000D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:24:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HJHri+FZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D1Xd3iMg;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HJHri+FZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D1Xd3iMg;
	spf=pass (imf01.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776162250; a=rsa-sha256;
	cv=none;
	b=To77wlxJIMq4nwuCpYMgq9hWFez3DZ1bCXs6FqCf3k0oDb/pfH3li31kyhRV1WaG1SjqDb
	//ADU4iwvj/Q5hw7OdQUFRXmzzuJ2TP80D0i12XI9TMVpiybG4ZA8xNGkKUO8W7JDON67O
	p4TH5YiTL49zI+h4ll/8ldYax/UClL8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776162250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wSxrZ6WcjGESr28Ykjg3UuGrekyih0+Pqu8H/Jh6JWg=;
	b=lKc+VVJmfstQqciG99/zMQqfASEJ/k4yTXicnmbODEx6qb4JhpQlG+UMYCz9P7fwW54Uuo
	UZnMQ74YPOMqYkha86XIawtC8+N1CUbKcDsIuwsu31rzAN7ARdM6fx7b+OAXShZnAN3YDu
	5F9su6/MH/EUraEv1WaxV/l0PvLP1JM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HJHri+FZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D1Xd3iMg;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HJHri+FZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D1Xd3iMg;
	spf=pass (imf01.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4D6B15BDBD;
	Tue, 14 Apr 2026 10:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776162248; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wSxrZ6WcjGESr28Ykjg3UuGrekyih0+Pqu8H/Jh6JWg=;
	b=HJHri+FZcOxFxW6g2tJoBiNgbeAio4SlL5/Mz1S5HzbPGAFzom40S6mSUw885yd2Z6WjUb
	XL3ww6C1XnOlbqojJcnnCfviHoBEbezbiSwljJ8wL2n+M1EdR+i40VbKWVF5y9HoBEw71Y
	ngiX3UHWqjiF+FOfuYJlIIHU4X7Ljic=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776162248;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wSxrZ6WcjGESr28Ykjg3UuGrekyih0+Pqu8H/Jh6JWg=;
	b=D1Xd3iMgkMYrzrmT//KFF50MmPDMgidUo/Lfl4pTg2qbm6bGw3zwklTyQSF+NU3YKUBiOq
	XM5CTBxLXAK4lTBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776162248; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wSxrZ6WcjGESr28Ykjg3UuGrekyih0+Pqu8H/Jh6JWg=;
	b=HJHri+FZcOxFxW6g2tJoBiNgbeAio4SlL5/Mz1S5HzbPGAFzom40S6mSUw885yd2Z6WjUb
	XL3ww6C1XnOlbqojJcnnCfviHoBEbezbiSwljJ8wL2n+M1EdR+i40VbKWVF5y9HoBEw71Y
	ngiX3UHWqjiF+FOfuYJlIIHU4X7Ljic=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776162248;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wSxrZ6WcjGESr28Ykjg3UuGrekyih0+Pqu8H/Jh6JWg=;
	b=D1Xd3iMgkMYrzrmT//KFF50MmPDMgidUo/Lfl4pTg2qbm6bGw3zwklTyQSF+NU3YKUBiOq
	XM5CTBxLXAK4lTBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 63D8A4B3C5;
	Tue, 14 Apr 2026 10:24:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IuzNFccV3mkaBwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 14 Apr 2026 10:24:07 +0000
Date: Tue, 14 Apr 2026 12:23:57 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Jane Chu <jane.chu@oracle.com>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org,
	hughd@google.com, baolin.wang@linux.alibaba.com, peterx@redhat.com,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] hugetlb: make hugetlb_add_to_page_cache() use
 PAGE_SIZE-based index
Message-ID: <ad4VvdlMEGN9PaUm@localhost.localdomain>
References: <20260409234158.837786-1-jane.chu@oracle.com>
 <20260409234158.837786-6-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409234158.837786-6-jane.chu@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 069CA4000D
X-Stat-Signature: oy9ck8e8seox5uu36cwg6uw4ztm8kba3
X-HE-Tag: 1776162249-847910
X-HE-Meta: U2FsdGVkX1/zBWwoiOfsbQCAKACInc4PCa/nm2Tlz7oqiJ7JVAfrP00BREZ8H+DaPyM+Y2jUawVPvpFgJuzJZ/Yzl1BEp2n0UHukeTDDrT/eFAC6vKxMV7RVy2Y+NNSv47YXwREfmkgOYpde3EUzGFv3E93BzJhhBW6M2vy6Nf5kFwk8L8TyEB9yHJzCt+TMmoTi+qeyy+NnhCKTTXMgP9ebelX94D6SZlB4PKHQFcIXUTcUY6AnZbmKwXHrLbSQn15grU2S6iVZqG7XaL445dA/XtfTXUT0oo7+0NeBbtR9lN23r6hJzN7JINX/LlFUll/vNOqbWhPPrwnet0tQ5gVGggTjbYg+q3Iok+UtYAuaFG8JkzQT3wpA8kc41At/Zi4GeHzzsILmfAKLbP+0XpKRsFW2KAnj/p86QDIFeiP1MuwJ1tWjMytDyuL2/G/ikCHT6EL4ZHmMZlzKyYdrGLtTHDSrZnX50keYpCGSYlaiyiN0YHsYcU+I6MNRc/9ihlDhhdqHx3IQUYmZTuAGHg2d1+VG91l6GpR4ZYbJyZi+MxKX3Nuqv7u1zgT0qrq2BNyGE/XiycUyubO3k6WYB7u+uBlasMYqxRlbPjyCykqNWywyduqaI6rJ0Ujop53y6w8AfQu2HsNUjhbqjY0s+srG9ei062g+pSKkr7N+VTa1AAFYYMn7pyxEANAy1LnuMerHs6h+HSK52Yiw0nX7+gCU4pMus4Ao8fCzyTJ7HpAas4q15J+ScsSrP0MAEqncBWzC/PdXOt5HQuux5Y4nCAcWpwjnrhZjZ+PkR6Vg3tKiaPPy9AypFZKqJzZSR0IXnZ0nQ5Z49DelH76tt3qi8u0HLNc0WpcAfPMF61X1BwL6Q82gb2W6kFtDqd+WZTN1YegFHGIs9wC/VBj4QFOPOd0/dh3n6Hw05ufUI41QjUU0F3R9MM17QQd2yKJQqZRHh2QGQVbgmBHCTW0pGJw
 6+el7Dk5
 afLc0FA3aSgiFPAV9Mj/fiEnDOzUlg5SguIdp+NlOZcmrJj6fzOWqI6AuDeuhwuLXCmfrGMnPDrosoWYmI+dqwsjlBgGXuNHJfa/IEk8TqJ8t5Y22XYK5lI4ClFIxzim+cX2NKOJlWEDskNJTYkft7XEDusUGxQfZqmNXAHM1fOcvQNGn3JMTyIzPI2/Rg7Xe2+MZ2T8DhpzAXR56QhozSJp9y7dLL1LVWXSV5H6lMN10onhMAl2Wlxh44Ed34XitpFbUlsGygXqugGMeCo64g5j2wCoCtt7BLLa9s5Fk6GlQ7bv1u0A+Mp41DRLW1GrAZHHlLHprZTCuL8k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 05:41:56PM -0600, Jane Chu wrote:
> hugetlb_add_to_page_cache() currently takes a parameter named 'idx',
> but internally converts it from hugetlb page units into PAGE_SIZE-based
> page-cache index units before calling __filemap_add_folio().
> 
> Make hugetlb_add_to_page_cache() take a PAGE_SIZE-based index directly
> and update its callers accordingly.  This removes the internal shift,
> keeps the index units consistent with filemap_lock_folio() and
> __filemap_add_folio(), and simplifies the surrounding code.
> 
> Signed-off-by: Jane Chu <jane.chu@oracle.com>

Acked-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

