Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D67FCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 11:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2D7F8E001D; Mon, 10 Nov 2025 06:39:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F05058E0002; Mon, 10 Nov 2025 06:39:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1BC38E001D; Mon, 10 Nov 2025 06:39:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CCE2F8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 06:39:17 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D93713C31D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:39:17 +0000 (UTC)
X-FDA: 84094501554.12.3428B9D
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf16.hostedemail.com (Postfix) with ESMTP id 954DE180004
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:39:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=OnKYx94E;
	spf=pass (imf16.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762774754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4AGg5z7WB7yGesyFSg8uTe5UjZWoCr/Y1LVg0PE2ceo=;
	b=eYXhGrpiAR2hEk+5kzafecDdL5V5Myle6BLpALb/aktkHPBhq9DFuGSInhZ4dZ+ETVLCJn
	sO5ipqH8MU/qyROA4nf5dUfA4oYVRrIiVJ3ui7pENf2pMkH6DJFZEk5zO34WNddmGXzQsP
	Yiii+Q/knaVRHxQN7lCAp/6ofgP4t00=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=OnKYx94E;
	spf=pass (imf16.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762774754; a=rsa-sha256;
	cv=none;
	b=TZvhjxgb+CBRTSun3XFBa4gVBmDhXUZq6GA8Z5uXX5JyBkgGJEqIDGOmwd7XmZ5/0Wstu4
	wSkoFJ74eMkOWMmXwHPQztjdc67WXDwUDECFon7+OyIGHclmYVd7+pFUn+wYwz2MSSE19M
	mZjRSEpZ/dtgCYor//uOc1n4uUdq/fo=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 65E2D40E01CD;
	Mon, 10 Nov 2025 11:39:11 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Pa7YrT3kZa47; Mon, 10 Nov 2025 11:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1762774747; bh=4AGg5z7WB7yGesyFSg8uTe5UjZWoCr/Y1LVg0PE2ceo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OnKYx94EZoFO51ta5Dmjmjm9Z1BzOqlpQpurxAu2RH2jxL/klCqkKRPXfJ7bZoXx1
	 OykubkkOd+ElmoatXs9ULH2vnFxBxZohjAu60D7FgSNa147RWigXSOpcfa4MmN9HSm
	 l1DilJRbrV/Pt9IT9BoBZ/FN0uwOChO52wGInrFIAjMPwd9V/4VVKzwWCvRe9mrFqo
	 I8xOcmoFnKPeYsFAnKjZXfHb3muAZFOEBXlVDlGlvpikRJ7Hkgugf9/beU9Hmb61pl
	 hBaFsZppnk1A6oXvrtAZqaNRbbqmkrCAD7pxYuTTVd3OIPk+HrIeAKuk3qqMtcLbVd
	 MyF9dWkGKGansiGSc9XGE4yxgn2w+U8my5i6a40oxP/u0llQoL4jFZVTC35BMF7HI4
	 gbj3tpvfgsFE3Djw0Cqhpz/EiqluSy7o45TxdZPquITE0f2fDSHzKgE4XwcXOmjSY3
	 enzG/IelEdOWvy28swqsTG6KYyAqHP5HVLljO8k+Yo+I9Am01ey5P3CV6dIxJMe408
	 tMx/nrVEL7j2TyvtMT3RkGBflvvBYhfsrrhFPyPCBBtjBSR1V5gm+H32TwsvBCZrMF
	 8LUsKN4ASRk1ZjqInQA6EqBp1vVQu+jRH03KNjeHlqsI9safg7a2QTjM2GiuX/7/MD
	 s72XT/NweEXDx8CdQNYeuvFo=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 42BCB40E016E;
	Mon, 10 Nov 2025 11:38:40 +0000 (UTC)
Date: Mon, 10 Nov 2025 12:38:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andy Lutomirski <luto@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, peterz@infradead.org,
	dave.hansen@linux.intel.com, mingo@redhat.com, tglx@linutronix.de,
	akpm@linux-foundation.org, david@redhat.com, derkling@google.com,
	junaids@google.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, reijiw@google.com, rientjes@google.com,
	rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
	yosry.ahmed@linux.dev
Subject: Re: [PATCH 03/21] x86/mm: factor out phys_pgd_init()
Message-ID: <20251110113834.GWaRHOuqnXgNa0UiFn@fat_crate.local>
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-3-2d861768041f@google.com>
 <20251025114801.GWaPy48dhlZ_EVoqKi@fat_crate.local>
 <DDSLXKU87HTE.G0XUZ5BG5M8K@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DDSLXKU87HTE.G0XUZ5BG5M8K@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 954DE180004
X-Stat-Signature: dhx33cprabpj6opb687pyb59qkfa9nir
X-Rspam-User: 
X-HE-Tag: 1762774754-968239
X-HE-Meta: U2FsdGVkX18vyq3B/3VzXh+FHjUlBAcpHL8VIcZHNM+2LAV0ttX1NwIjOGyb5DH2i34hVIs4P3c+VLReIYazbDid3oyFABRjvk32vo8czW3U++6InGOXN0lVQJjLhbKNJAYHZCgFPPNHqyRqaTdI/EKNPSCYj5dE9UDbfj59/sw35wOz4Guu1/YLOT0tkKh6guroWQkvxyKLT5vXxR1Fit5RztdhYe85XkmjcsRi8kJg9RqOi8GIrKZ6sRiR+pauu4RFK7vSt0DSmDmABlibHvkF68wALqaROexJkDjV8w6nbNYMyyO0Ffsx3LtKtCdhB0tHSkj3Rzyl1s+Sw24k1DOdPme0EC6z/FE4Or+X6ueA8bBh1MjG5gR2xrBPR0/faivbjZP24IBc4TivwrnLS8QCkI7ki1+/MlBclpzKETMh4UlBY0jChGAN+76RFACDmrkieWeDk5N5JYhVde5uOjS9kvnlHFHfBQU0Ng2KRmKffhDeuUbAEupPHM4VGDvJUXn/omUJ6QTENLzYya3wnRVp4dXTlrRwL5SP1hW58/Rg6+M6wtBouSkyB78DaA5Lpf9VAnY7T6xL/jYqWtc9DhawRl+P8cEjf0zP87V5mVAtrd8UcWYdZlCKQ59ZMLq5CDdhnxK3ScGSKOmrVxhr9WLUohCJtNG+N1i1Km3DM7WuGaQaIGJjYxeNAfd1xl/fX9Vuopgk2j/6G61XEZMI7qtiGMGqSK6Wd31ObcUnPRixFkmvfTbuVlf16KFNUomd/gwkUpUQydLHYzNRNMGz5QoPbZMvIr6iowD6UDbxTfLUVYtiWoHQbRsJ7fzKcwl0IGauon+/HXszwFMp4zXo4954faVwtpgp2TJ0ikxaIVVDx6AmXjDcoSxWZEsBDHrbLQCv3vaW9xE3urxQZdo3wntEHooBr/OBk/aRC0dYxx1DpNqo2ZStyRf7i2gqmRJa15YDxDs+k2e6YgJ+Eel
 WL+x5BdM
 eh7NVhQ8T5MfyWazPFhD7LtdX9wnXlXvYyYE41yZ2uIZs8t2oKMMCHcPcZGE7NjwpqHEFnOC1e6c5YiJxBvvz2xksmKK/CG3Zaho3Pm2ekWWekaMi4t83t5oxqeA4qPPOmcVNCEX4YlwwJcwp/xQ9tBs9eRpWsXC/AfJtCkQ16NgK8Of2JJO3dlSp6TaoOhowauvinprWr+9VNR1BTiHLnkJX31pQnhmqmiv90kAjqOouCSM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 26, 2025 at 10:29:23PM +0000, Brendan Jackman wrote:
> Per Dave's feedback I am still slightly hopeful I can find a way to
> come in and refactor this code so that it's gets cleaner for you guys
> and then ASI becomes a natural addition. So far I don't come up with
> anything in init_64.c but I'm still planning to stare at set_memory.c a
> while longer and see if anything comes to mind. So maybe we'll be able
> to reduce the yuck factor a bit.

Cleanups like that are always more than welcome!

:-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

