Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1A75C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 16:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 928E76B0088; Wed,  8 Jul 2026 12:29:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D9586B008A; Wed,  8 Jul 2026 12:29:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C83B6B008C; Wed,  8 Jul 2026 12:29:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5BFFB6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:29:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C7A1F1201DA
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:29:36 +0000 (UTC)
X-FDA: 84966145152.26.77A3F19
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id C172C180007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:29:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EaOYvba+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YMvQUPMc;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EaOYvba+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YMvQUPMc;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783528174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j/5vL0gtxnVlH2N135h4PQDZCX0YmGfUctk3tp3zRJI=;
	b=QXQIw+DWPhDP0keEf7LmjOapjVWbpMvn3zfaG0mGJNNNlFqoW4atMpseA2VB9bHqGrO+Al
	NqeZYokci2by1BLGQVEHF4p+KegQneokUJpCJIQxagdCqMdu3hUjl1u/t0TrdMXBaBCJK1
	6+iEUr73BpmVqwKCShXlUsD/3NrWu28=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783528174;
	b=ifHGQjEecj36P8+Kv4rwXbqMAaG2l7AS6JvqP0j0R/KLas0USsIESsU2XI3/OH7/7VBnDR
	yyFN66xIpvO2XQ37Wi3BI+GD8SvDNlHdM3XJCMJuvYnABMLmGzcUwrfSIN1cMmmG6e+DUf
	UimweIn1mRn5d/PS0f9lHLq7P8pok1U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EaOYvba+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YMvQUPMc;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EaOYvba+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YMvQUPMc;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9207C75E8A;
	Wed,  8 Jul 2026 16:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783528173; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j/5vL0gtxnVlH2N135h4PQDZCX0YmGfUctk3tp3zRJI=;
	b=EaOYvba+ARiTsxtWUrYDBPR91BTRtXJsdTCLw0wNxhImLHwujj3dJv3h6cCGHlzp977dwE
	dIFixPE0pstyi4E9xED3cWLPtkgkfPJlBRlLF7KoOoeIks09dRwL71VB5xwNHvOu19Ks7M
	f6YOoObWR6FseQ6/IWOt8xy1k9VtSCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783528173;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j/5vL0gtxnVlH2N135h4PQDZCX0YmGfUctk3tp3zRJI=;
	b=YMvQUPMc+wnAmpwZbJQ/e5jUHFTTPHF8iv6B8qO+/rMFuQCGHrdiC6JQ6JXIlbiMj+vuvf
	ZWYh9doHo6nNVsDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783528173; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j/5vL0gtxnVlH2N135h4PQDZCX0YmGfUctk3tp3zRJI=;
	b=EaOYvba+ARiTsxtWUrYDBPR91BTRtXJsdTCLw0wNxhImLHwujj3dJv3h6cCGHlzp977dwE
	dIFixPE0pstyi4E9xED3cWLPtkgkfPJlBRlLF7KoOoeIks09dRwL71VB5xwNHvOu19Ks7M
	f6YOoObWR6FseQ6/IWOt8xy1k9VtSCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783528173;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j/5vL0gtxnVlH2N135h4PQDZCX0YmGfUctk3tp3zRJI=;
	b=YMvQUPMc+wnAmpwZbJQ/e5jUHFTTPHF8iv6B8qO+/rMFuQCGHrdiC6JQ6JXIlbiMj+vuvf
	ZWYh9doHo6nNVsDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8B315779AE;
	Wed,  8 Jul 2026 16:29:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id r222Hux6TmpHdwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 08 Jul 2026 16:29:32 +0000
Date: Wed, 8 Jul 2026 17:29:30 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, stable@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Song Liu <song@kernel.org>, Eric Hagberg <ehagberg@janestreet.com>, Zi Yan <ziy@nvidia.com>, 
	Gregg Leventhal <gleventhal@janestreet.com>, Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable v2] mm/khugepaged: write all dirty file folios
 when collapsing
Message-ID: <ak56uatKoDR-TAIn@pedro-suse.lan>
References: <20260708151357.353173-1-pfalcato@suse.de>
 <ak5tKPfX99kdkhIG@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak5tKPfX99kdkhIG@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C172C180007
X-Stat-Signature: 1m1kenbwgxs6d5ksgp47qrcomwmbn37h
X-HE-Tag: 1783528174-17215
X-HE-Meta: U2FsdGVkX1+nmcFnQ7+6L55JKLUBPk8qUvsZZz2LvLZQuOW+03Uy3Yqjk1gDoW8d2aAvBOF+55U+2FjkAsrVjcysUR/qCgzgeta+qCjJJFShNc37usxzCE5f57Nva2hI9TnUZ2gBCcF9nLQxzb51XI+WMI4VVikpoEnlvdjHssNg3OiFFIQVWP3BAayitJgRdpTkXHc5xrBgj2jyy4MovCXxh5/XTa2BLB+tFM6SAm3FKKjssTsef1pnHkECSZ71reNlC4rYGNvadWf6UumNY4iyXbTJr1Y4/Jb2SdnFJiLH89CeryPyltKvzHm22kNKJp5A8Q/lA1vdHdMYK6kHMSZmMJsRzqlvYWFDffs/c/Z7KLgK2GQiyQsZPQPX3r00Ws1TX/7lOGA0zwaaS7b1N5YY05RdsEEtrFnIeP0diqWpvfFRrHOgUVeEeYbyUDz3KV9PAtLspwy6mD1r3izjNiXEBbHlhK/hsvgiZwjUCI8hN27AEhUn7DW8Rr8KJTmFNII29QBNLkbWQtqQRenP2iN5k9hfgCzYwQhwCmjf96xU6sUrDX7ZLJmyT8UidLi9VLR2RQIt3c/ZDWaUXwW/5BMd+Mk6n8IYvfQSxQ42yPOV9gRtH1Z2MXuWAMT43oNwoJBZCOysbtMPw4HsFD1nQU1Pb3GCc6G5dk3svvYdqJTZWKk8EjUtNPN6d43Mqks5oeBHyYm/uKHNJz9v/DFWWZfTam7+2uBUnGdvkfOtlNIChb+58myieKxRhJkGP5R/yLZCbYWYWP5agutuLci6qzTxdi+RRFd1Fe1CYXCqbRc1qsCsqOWAZtmlVnemjiXRCpam9d1PIgWhrLD0a5Z6+gP1FPXV8qJFn5N2y3TBeAGpvhDPEdOhLq1Hm+U4qbmO/hAEXHiW0RajC2mJzv6RxN1sa9qKTjLUOw9OcjH/uXSLsZIs79Y2TjOZ9tfvOSWMXVdFmNHlQDtzmFsN7nx
 oODcHO/a
 Z4GHbtVXnWl7JmWd9+VRvHLhlMkdtAbhX/BqEIb8Y2BR+seCc6vtZTsiJnC7T/ncnK3Ll3WXnjX+6pMcp6GYM0R3gS/eaC4mpoEs4quPjLQ9uuYETjKtm9EKUlQ9vXvBIPT9h/p3SKkVax75yc1+Nz7uFBqV2Fso0Y6K2aH5TRmOvwf2M6mVwbWnrIdQ2UPNmFWk7JBguR1BcV9Jc1iRobDUEO+UQLdoMr0WbPJDfFMnnKMQ+o6vt4MEDpZ3jQ9AIlpAcYfCmbccrv0HpgHZ0w/8xhHpHXZ/wsDJ+wD7Lj76sgBVrvG4cXJmOBzKW6hnyKCSvjDCaSYDpj/npPI4NDNGMFEgQZEEre5mQjMnLIjITm5dlZ1jSbYBlEIT2XzAkU/fzrjyMDExEqeYLLpNVKSLwCZ62trlBDk2L2yoSyJc6E1vnP6cfNcoUT5vJTnVZ3bhphGZz3UpgtTGBsSqkTgUDsio1WZ2BNlP+1wGwmpQh6LMeHAVzJFBXjE3KtAl20Sd2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 04:30:48PM +0100, Matthew Wilcox wrote:
> On Wed, Jul 08, 2026 at 04:13:57PM +0100, Pedro Falcato wrote:
> > [There is no upstream commit, as this code was removed by upstream
> >  commit 044925f9b565 ("mm: fs: remove filemap_nr_thps*() functions and their users")]
> > 
> > Cc: stable@vger.kernel.org
> > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > Cc: Christian Brauner <brauner@kernel.org>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Matthew Wilcox <willy@infradead.org>
> > Cc: Song Liu <song@kernel.org>
> > Cc: Eric Hagberg <ehagberg@janestreet.com>
> > Cc: Zi Yan <ziy@nvidia.com>
> > Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> > Reported-by: Gregg Leventhal <gleventhal@janestreet.com>
> > Closes: https://lore.kernel.org/linux-mm/CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com/
> > Tested-by: Zi Yan <ziy@nvidia.com>
> > Tested-by: Lance Yang <lance.yang@linux.dev>
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> 
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Thanks!

-- 
Pedro

