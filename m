Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65A27CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 07:38:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE1E58E000E; Wed, 22 Oct 2025 03:38:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB92B8E0002; Wed, 22 Oct 2025 03:38:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACEF28E000E; Wed, 22 Oct 2025 03:38:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9C3D58E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:38:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5063088B73
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:38:45 +0000 (UTC)
X-FDA: 84024948210.01.550B380
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id EC95110000C
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:38:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KukVtGGW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=veJQOarc;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RBDxyTiE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QYPrHAhn;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761118723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Myzl7tA1DnESjNsonDhfQ1k0YqDE7S12DaYO8n4h//c=;
	b=4dskNqWq/VaKpGoOKvknrMTWkSIEmW2wH7ohaFVT/6UJOZv1BoKDs0rDI8kGpgfwjAiWhl
	T+3SMZ/DEc09WqNXqXXO/m9TlgUZo1kbCo3kY/By0Xtu0PZJMzrYGPBpH/yZCtq6BRBOzT
	YUcAcH5ul6r9wQfPLqAr0tamMoLj7EU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KukVtGGW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=veJQOarc;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RBDxyTiE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QYPrHAhn;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761118723; a=rsa-sha256;
	cv=none;
	b=RCdDePa9M7Hpcpnr0dwgCP/YC2iYqRdJZrY5GowouJtixnMbgSd/d2348VsT5GMFwJ9MjF
	QNSO606vsWsFtlPJ94PXxejKwFf+YXzLvdfm2Loh+VweItuhaiQUDIqlhmxLyz29BOOpVw
	05Qan2v7k9eJNLWesHgSNXoLEqaB0h8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 399731F391;
	Wed, 22 Oct 2025 07:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761118717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Myzl7tA1DnESjNsonDhfQ1k0YqDE7S12DaYO8n4h//c=;
	b=KukVtGGWqSuem/LJklYW0q+zc5HKvfxVuJPkcHLDHZx8D7vROffVpcP73HtODiay68RRay
	QN8gAZIdga1NdvQUAg3k1InyPvsKc8O7qNSsf4EgjVJ16tMsksmsvaU2nwQFvt7Qgs1Awz
	hTNqcp+LKLH6PpY5Cijtjh1i7w05Wyg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761118717;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Myzl7tA1DnESjNsonDhfQ1k0YqDE7S12DaYO8n4h//c=;
	b=veJQOarcKigKf26sRa6IuzSsBqRioFdBls/D4dmszIC6X38QE3qFdg7IZiEegurQGVUvZ9
	Yc7a8PLBih3CcJCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761118713; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Myzl7tA1DnESjNsonDhfQ1k0YqDE7S12DaYO8n4h//c=;
	b=RBDxyTiEJNM7tQqrsbbtjGRrg2f1678Z4QNrLli+dxOSiPMBbJgnOL8ogYjvPpA6JvLqqD
	yK8Ix6a2uHQgo2neTu596fnX7CxdF645RlJCn2YJFFp6LQAr5Asv4zyQYAE+nCLOxOLnoN
	d4pY55cHObJe9y2OsWBtn4s8B+V6D10=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761118713;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Myzl7tA1DnESjNsonDhfQ1k0YqDE7S12DaYO8n4h//c=;
	b=QYPrHAhnO5Xk2QgbkFCm383lUU/0V5g5zF/efIyre3pCxn7kENc2pz342o23/KhxzU8tTe
	4Xg11GUsOf/GhqDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6651F1339F;
	Wed, 22 Oct 2025 07:38:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7gOsFfiJ+GiKHAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 22 Oct 2025 07:38:32 +0000
Date: Wed, 22 Oct 2025 08:38:30 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
Message-ID: <2dyj6zrxbd2wjnor2wswis5p5z7brtfgzjnhbexhjsd3kqnvx2@y6i2wnvr6gdr>
References: <20251017141536.577466-1-kirill@shutemov.name>
 <zuzs6ucmgxujim4fb67tw5izp3w2t5k6dzk2ktntqyuwjva73d@tqgwkk6stpgz>
 <CAHk-=wgw8oZwA6k8rVuzczkZUP26P2MAtFmM4k8TqdtfDr9eTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgw8oZwA6k8rVuzczkZUP26P2MAtFmM4k8TqdtfDr9eTg@mail.gmail.com>
X-Rspamd-Action: no action
X-Stat-Signature: m95nabrub41i7mwr4sahwm1ihighmmj8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EC95110000C
X-HE-Tag: 1761118722-572615
X-HE-Meta: U2FsdGVkX19FOMogrjQuNYP4ruJ27TpH34Fg5MJgF7mLFl2CJ4tzdjyuwXoQxVJMWSWw3ByIEbE23qmYlHYpTx1cDNneNNWkk08lrpa8pG3oQZta0aa/uWuta6YYPioDxIWir0eycwofMEwuZGaekTkNHZt5tL7UTRAaypDx/jtVCAiMUq+T7z5bSPpNcVIrL/8egSMFfx9zHB+y46sMCo5VP6YVE00kZbQLxwCxXa1zuYxMu7I2l7PXGqTxPqs2XTfyc4v1r2+SQWLXCxeXpk5ESUltraOLHM26FuWby/gwN+5jDXrM9JOmguGuvY2GGoYU6Qj3M399YAtcq4ZqfIEPGPyf+MZOy0YB3A8Ro4muCo/8CwnZszhV/NXNEPIn1lMCosPBIZnIv3ZWMQmeuFskwUw2WliwJNfX8v9vB8kLvzs9L3gyA4DO5JwMWrnC9hX86dgF/7x0Zvy+yXDUDjypz7iOTzPG9Dslu5pQi1Pb0AhjppcMBwhA1jaRaRlRjQLR2MGlSgKMbB+89ALX9JVsdx/WiVRdV5+DYArX7YiDW0lRbpQ/+yH0YbVxzUq75zdhvZNYJlw1Cj9uN7Zrqic1DFkiFOBIaUIrkdEN9/DOjq3SA3mhpIYpFVeWAstKu/Ourp6jYrByFJml1wVQezS2h3haUeIO//TxxYeTn3P2nDUfq8KXbISADhWWsSwkFp7iKaumSTrikzMM5yOIYCuOojq+zl2xeQoNjbG+J8nHdEkW+fgLgseN9eswUm9Qc8qn9msvlmLzn+uQ+lbTQ/u+3ugL13zr+LpMGGk2ygquGSjpitR2p3QJXr9Uv74RnslVQd0fbvpCkBCActsh/3Mx/IeyQakp0j/Jt2JcE972uVZCbZTIrjZ/cyACIhc7+NvF/Ad2LYAWq92nlJw89nH8Be7rN5cOhWgvlyRImR6Acks+FfjoumVtRuK/+XIWylbyGXfwScZKvP/Hlnk
 4VUp40D9
 wG9pY5afr/kla4yAaMAbjTUcjLfCJJv40yDogNsqmKzzq795iFdHT5kW1lqyWxoKy004Z9HvbeMdaJv+ou+m/A8T8QD6j2VpHFyIbVeg+GF/XrIffmFDCK5tvfKOdfPbwfwk87BTp4WNbnFUpKfSnpL9Dz0gO0BfQ91kTviFEwEgKAR6sMa9ykTejeCIuP5fSni1X2Gxs5VlUAoGrZUZB37VrbC6usERgdprdBZCahj8CbtF/H48Xb7BVma9pa/cg4q76HFLr6cafv1CGHRs8YAVJI3by/blp1rEiJeQ85S2Gpus=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 09:13:28PM -1000, Linus Torvalds wrote:
> On Tue, 21 Oct 2025 at 21:08, Pedro Falcato <pfalcato@suse.de> wrote:
> >
> > I think we may still have a problematic (rare, possibly theoretical) race here where:
> >
> >    T0                                           T1                                              T3
> > filemap_read_fast_rcu()    |                                                    |
> >   folio = xas_load(&xas);  |                                                    |
> >   /* ... */                |  /* truncate or reclaim frees folio, bumps delete  |
> >                            |     seq */                                         |       folio_alloc() from e.g secretmem
> >                            |                                                    |       set_direct_map_invalid_noflush(!!)
> > memcpy_from_file_folio()   |                                                    |
> >
> > We may have to use copy_from_kernel_nofault() here? Or is something else stopping this from happening?
> 
> Explain how the sequence count doesn't catch this?
> 
> We read the sequence count before we do the xas_load(), and we verify
> it after we've done the memcpy_from_folio.
> 
> The whole *point* is that the copy itself is not race-free. That's
> *why* we do the sequence count.
> 
> And only after the sequence count has been verified do we then copy
> the result to user space.
> 
> So the "maybe this buffer content is garbage" happens, but it only
> happens in the temporary kernel on-stack buffer, not visibly to the
> user.

The problem isn't that the contents might be garbage, but that the direct map
may be swept from under us, as we don't have a reference to the folio. So the
folio can be transparently freed under us (as designed), but some user can
call fun stuff like set_direct_map_invalid_noflush() and we're not handling
any "oopsie we faulted reading the folio" here. The sequence count doesn't
help here, because we, uhh, faulted. Does this make sense?

TL;DR I don't think it's safe to touch the direct map of folios we don't own
without the seatbelt of a copy_from_kernel_nofault or so.

-- 
Pedro

