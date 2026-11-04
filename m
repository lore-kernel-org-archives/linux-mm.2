Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90C4E606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BcEaKSaA
Received: by kanga.kvack.org (Postfix)
	id A96686B05C3; Wed,  4 Nov 2026 04:20:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6EF36B05C4; Wed,  4 Nov 2026 04:20:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB3B6B05C5; Wed,  4 Nov 2026 04:20:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B0E96B05C3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:20:51 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E4C180642
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:20:50 +0000 (UTC)
X-FDA: 85396891902.09.B02DFD9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 68C6C1C0005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:20:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BcEaKSaA;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793784049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/cNspokMh0UNXOA6wOkvv54jlnPVAhKOKNo3zScL80=;
	b=HRvRtEjlW5KkmE7HRHFwrZwwdbsl4KwZ9r0k1Vua48JMKr9AGeKztCG3s1UukBlN1D0NJc
	yfwy7CBGr5xZTEQX74Txw5EsrOb4okwjsTsv7GMS3uE41XaVPRjI+BBL/xjtrmOFy7v8mS
	+kVy8I8Cdn0umxdBKNa0Gk5XVabkoPo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BcEaKSaA;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793784049;
	b=hSPTOn09jiVypAIuuJztB9ogPoUQjKEAeEYF3GUJrhXwhkdsoe5qgTv68N2UDzr+fEtp+p
	ZdOiMaFzetsOLq9LR1qCFO4DG8O/2gHUZs6k7S4kPGn/ZWkrG6ePXqyB2dXAlVV6Rrk0rL
	mE+CaWiX/I//u4RDlPk5GsfOpiEYtC8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B40B54344C;
	Wed,  4 Nov 2026 09:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884BF1F000C1;
	Wed,  4 Nov 2026 09:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793784048;
	bh=O/cNspokMh0UNXOA6wOkvv54jlnPVAhKOKNo3zScL80=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BcEaKSaAGlv24CwtAidx4vgcs6qvpVaJft+GsrdUwgsUzcXrxh3uKvNOUoNaojM0u
	 zeaAufJdghxwNsRVYbDAL/xLeKpNsJ3Qayq8R/yEjD/hXG6tybWAoeeY/Tcg+J2REY
	 2VHx7FHMLCTTzYzu20RNN6+W/eGKH3XQSxBPLu21a3FQK4L4xV10mVduwGQuGwRq6Y
	 1A0ZHeMOGLNd3RiETXNw1XPlv0+sn3aHbmYt6VyuIs0KUjdL9KaF/E0tjXUuJZvvKv
	 OzKIqB04C/jh70SwJGTPrT4CcqF9fgN0yPVMCzRgZsEpdaIpp/2cLp+CNRnZLAYstK
	 OnLeMUpNmqPkw==
Date: Wed, 4 Nov 2026 10:20:35 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
	Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Eric Dumazet <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
	Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados <joel.granados@kernel.org>, 
	Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, 
	linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-modules@vger.kernel.org, Chuck Lever <cel@kernel.org>, tytso@mit.edu, 
	dmitry.torokhov@gmail.com, Petr Pavlu <petr.pavlu@suse.com>, 
	Anna Schumaker <anna@kernel.org>, yukuai@fygo.io, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH RFC 36/38] selftests/proc: check that faulting sysctl
 accesses don't hold up removal
Message-ID: <20261104-aktionen-endlich-ruhmreich-92f35a0ee397@brauner>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-36-59422ed3e465@kernel.org>
 <sashiko-outbox-195508@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-195508@kernel.org>
X-Stat-Signature: 588f7dtjtktttkkh76w9bbjoghfrq8fr
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 68C6C1C0005
X-HE-Tag: 1793784049-505246
X-HE-Meta: U2FsdGVkX18wFD67kxR5HuOnH4D1mQB3enUlg7rMy6RNonp3tJRUuSADaPkThPeh8UTSNEjA4+rt81ZlY/nxouWZ7MUjdzY1LvVK3K0I1PDJ7674bgI5QPZpY4ZqJaPx+TwzfNvgmzDK/H3L7heTIw881Z3mzFi0uv2o1WR2h8e+3D+4G6Pb5hqj9nMEtcBmlrHrcZ5eK1JnU9VJl4Kl1FrFAUs6o2YHGAfhS0NDvDbnAKo5QkBWg9rJ4sxSQ3Lqp1QO3Q3geQdyO0Mt3kPSjsGzvyulANlSEuz4/9PwwGIBJtz88ORArleqRexwv7HbIThJtJ9WYgcdQLGKzY7zPAY/+CNHFI6F4JAF5YnBFZdFbXTyOJoIs4Q8iEbx6WOGUNm7O9MyT9ofeB+dr/iIDMMJUIO/QCkR8Cc+QbnQocDdwLuNpzFiM06dDwJjvRtWHCYSGiDim3UEx+4J/6mY2+ZlDKHYcAZL4IKUWNrRUK1A2AB4f6OWYQEhtjiXjtcjoD0ebe9rnHLMy6c1D3WGh6gm/jdcap4ncRnpICtkvDaCDqqOFFWkT4waCPtxnHB6OzHGNmUAoNwx3s0/H0uVOfg3PlEivsI3sZSxei9FkooQjEU/vqLMX3V8PqL+5DTN5lCDnhrl5DnlIiasi10PkoXPipqIxFReF1QZiYG4863qnOff9g9GSz6JWytcGzq3NkkbRwTzoDfBZK8tVLkP0jQj0o+B5QvZBRb+CbB/qLmL6NHSLcyD2p6xq4OvqaTfjo9YGmhXDMj2MUysO0ooGgN+kYwmEVdWK4AGlja8/g1IAvNoh3SK8b70LYU4t+38hT+uobDbeJQZiDGWQn4EvbnCB2839DKpIE/43Uvez8AH/l5QSzbsB12ShdjEzIUnl2e6emXjwNwRdeN4r0I3U5vGYrtFpbkIywGZ1e3OCV5nTVD/CoVDSu2u2ZR6Ll2JQKd+h0Q5x2Q8GjXERAd
 O3VmuVAC
 HFBnHxTCT4oEkn8Fb5/u/Bwd9mvcfyD2TGZlasqJiuu+uQhXHTwytQ6EQbc3K9LZTc9mtNMV4nQA4FUgY+U7vYppFqIKlDRYWUvrdpghPX2d6nz9EF4CgYq1frp+2fTT6xkgSGKDRNv81JCOxnSbeASZPdytT3Iz3Jns8CMR8zbRvXE7CMWl06J1PxT4+T6aNU2gelHrwpB3U/4q6nsR9j7Xizz2PvYLdJPC7IaYB3dnzHWJnXV41DPaHBLRLjSRozt7P2VLMa/dnx3FrPfdXotcncjJ/YBvDZTRZnu5zLqOPfKWsPmBPvpG2DPrCb5Wj4jextRILXr/o8XFEQuJVpEsrsEn3tLwNtoUmzmOndMu++Fi1vLlb2iFU5VAZt8Xj/3opBZxKTgtX6irdHpBIeETH0qJkOA8cAhv6yku3CdSZniY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 02:48:40PM +0000, sashiko-bot@kernel.org wrote:
> - [Medium] selftests/proc: getdents test faults in dir_emit_dots() before entry lookup

Fixed.

