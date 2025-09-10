Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B68ECA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 20:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 799068E0019; Wed, 10 Sep 2025 16:33:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 722428E0009; Wed, 10 Sep 2025 16:33:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EA898E0019; Wed, 10 Sep 2025 16:33:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 482608E0009
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:33:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 008B6854D6
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:33:10 +0000 (UTC)
X-FDA: 83874490182.03.3F763E1
Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	by imf15.hostedemail.com (Postfix) with ESMTP id CCCD6A000D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:33:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757536389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xn32CgfsCdcgiZc5xVsldvxbovwbLiKF6pDU6aeqlX8=;
	b=xVBDvBL5w7jmXr6VaKy5xl1H0JO8obVEJSdAcW9Dpd/NHfLpi5Zgyhk1OLW/Yr0UhzNTyX
	6N1nn6xltkK3IJOhxcupHBUciKPrLlIPgbJL2aBvWhwFVz7G8LdHzMq6Pbp4dRl5FGmo5Z
	IAHQkSphriw34kb3osecAJILC8vqUns=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757536389; a=rsa-sha256;
	cv=none;
	b=kVHQMmH19IQuNgUrXQ0jJIv8Irj0ECN9/Ai1J/OiA4r7Ugma0kZ8Ukd1aXqVM/ZeHo0f7G
	lgeUjnE2ctUxz2cOMKiNn2jZi4uL44nhvAbOZ5f+Qsb/cP7KP5Ond67e/BuGwuEGAniv4e
	jqUcRw40XgBOZdd1B0pgF3ANnFd9u0c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at;
	dmarc=none
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 511D5CE34D;
	Wed, 10 Sep 2025 22:33:07 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id aSKreuvdlGXI; Wed, 10 Sep 2025 22:33:06 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 4BFD3CE34E;
	Wed, 10 Sep 2025 22:33:06 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id YO9RM-IU3T_L; Wed, 10 Sep 2025 22:33:06 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id 082B5CE34D;
	Wed, 10 Sep 2025 22:33:06 +0200 (CEST)
Date: Wed, 10 Sep 2025 22:33:05 +0200 (CEST)
From: Richard Weinberger <richard@nod.at>
To: Dave Hansen <dave@sr71.net>
Cc: Arnd Bergmann <arnd@arndb.de>, ksummit <ksummit@lists.linux.dev>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, 
	linux-mips <linux-mips@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, imx <imx@lists.linux.dev>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Lucas Stach <l.stach@pengutronix.de>, 
	Linus Walleij <linus.walleij@linaro.org>, 
	Geert Uytterhoeven <geert+renesas@glider.be>, 
	Ankur Arora <ankur.a.arora@oracle.com>, 
	David Hildenbrand <david@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, vbabka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, 
	Ira Weiny <ira.weiny@intel.com>, Nishanth Menon <nm@ti.com>, 
	heiko <heiko@sntech.de>, 
	Alexander Sverdlin <alexander.sverdlin@gmail.com>, 
	"Chester A. Unal" <chester.a.unal@arinc9.com>, 
	Sergio Paracuellos <sergio.paracuellos@gmail.com>, 
	Andreas Larsson <andreas@gaisler.com>
Message-ID: <640041197.22387.1757536385810.JavaMail.zimbra@nod.at>
In-Reply-To: <dec53524-97ee-4e56-8795-c7549c295fac@sr71.net>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com> <497308537.21756.1757513073548.JavaMail.zimbra@nod.at> <dec53524-97ee-4e56-8795-c7549c295fac@sr71.net>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF141 (Linux)/8.8.12_GA_3809)
Thread-Topic: Reaching consensus on CONFIG_HIGHMEM phaseout
Thread-Index: qX92QwLBi0un/69XQpQP6tb4aScRlQ==
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CCCD6A000D
X-Stat-Signature: bqoojkw43rfci4gz4m7bb7ffndzikmzw
X-Rspam-User: 
X-HE-Tag: 1757536388-693694
X-HE-Meta: U2FsdGVkX1+CGTOHfeADmsd+CnZleQzjl/xwzbCLhaeqPzIwKYVeX3tITIsQu8EwDHrRf0FwAq6Av/RL6JtBQUb4jTHiHFUiOV84Z6pDZdbhAY44dPcDW2/wN6DmOk4qdsLcDrwwkqZPil1rpctvzyMJkz30WEPMWwEmrJdtWrgU/vjnvFE1nKBTRy0jM3O2WfV4aJDFjyBeHAE1uo91i2jHcRHaxFQYrATSbSwmjnXL1mfu4iKs+6tR0GZc9BqPc8rfbzqe+gNavZzY9skcEwiIhq3d1outNInhqKwAI1vgyuWqALkBmqjKOhYJS8Oq1H+be8Jzexdyu6qUM1tbe15iXgaJStGm6/KZ34Yt6PgT4PQb4BKyyoNvNL0JG8UYldwvYWnFOMYllqzUGS3abN8di4PgS4S6/VTkvwJX7IO7nxWY+bzBC9My5UnlOPQN7rgXZltr/OYjnfRPRTU6zj0NdH866psdAiCjdaXSa7CHNyOMHAk/ein33dlkM0XnDpBF7gYMMkNwwfKixVYOgYGbjxkGoclWD0KlARBhhINt6UBLbNMX8/NoWsr9NMv+VkIO/3Z5boST6OyCqVUphHAdCwjHZn7D1qnJHFNQhmyr3kKAwo40rIi2BUCiPZh9c324mpqpSCRk1AQ8hT+ueiGlOZUeHcYBB64kbut6VB6M8/N/a+/AN8QLFr9SH3foo0C8diO5FLyFlap95x2t1Bm1TPaG212FVfyPf8RK7bupOnBfT7S3DDOCcXkoehTh1zfRRTls0pwTS2Fg93zrjoxQreJXrLw6f0IvqAiSJ1IlAbgNR7i0hR3iXez8m1rSRzPbCRv53FJ6jihjvw75InrZVo1ZwU5NnHgYTP2f52wN1ZN3V4Gg/eULcApRxS4gLJq/GSMMrnWAtTwLRBSPFiCKCLngqvPKAei36KL16b5WTcDH/0ktUjptxqMs2zMZo3wUK9KObt+nRbomywT
 nhDGSgJc
 RESF70KFrULKa455ftCjQouBAFkXuWe9G63fUEXFcr9kdg7T+oWZK/1ngN28ZZx3/2YmQsZSI5Lw7CxiTGz0Qc61aF55BtlCL2s6TncA+gNxaP4DIge23XBvhN2Xe7Ubs3wNnin/de5i5f/UO8nmOyUKC79Ymx/49m+87kaUFOH5BOMk5yRUzUxTtH5OYzPbSWsYZU94vu1a2proBmE4kAubabMvjoitcpQ5vKMFe0ywvorCLN6+1AW0ZJAnFXYKPqRIP4vlLwBajC3EIxxaZckMSySJ72YApBli3YIQGP+oI1Oo7znBD4H5P0uU+ljsSJhhwlBdyvtG/0+sw7lgDDYDeI7fry2u4IYIapcCs2w/RvIEt2Bv5olz75cNFCuCSz4zER5z1ls/p0uPC/hXpQPFfqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dave,

----- Urspr=C3=BCngliche Mail -----
> Von: "Dave Hansen" <dave@sr71.net>
>> Even with a new memory split, which could utilize most of the
>> available memory, I expect there to be issues with various
>> applications and FPGA device drivers.
> I'd be really curious what the _actual_ issues would be with a
> non-standard split. There are a lot of "maybe" problems and solutions
> here, but it's hard to move forward without known practical problems to
> tackle.
>=20
> Has anybody run into actual end user visible problems when using one of
> weirdo PAGE_OFFSET configs?

In the past I saw that programs such as the Java Runtime (JRE) ran into
address space limitations due to a 2G/2G split on embedded systems.
Reverting to a 3G/1G split fixed the problems.

Thanks,
//richard

