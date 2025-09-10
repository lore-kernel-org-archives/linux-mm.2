Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73515CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:04:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB54E8E0015; Wed, 10 Sep 2025 10:04:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C65F78E000C; Wed, 10 Sep 2025 10:04:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B54A68E0015; Wed, 10 Sep 2025 10:04:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A4FA18E000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:04:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4FC291A0900
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:04:40 +0000 (UTC)
X-FDA: 83873511120.19.E9368A1
Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	by imf18.hostedemail.com (Postfix) with ESMTP id D54FF1C000F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:04:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757513078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XGf6An9pkuacotas4PAUho44h/2LaY9ZaYpivcI6rZY=;
	b=3hxY+vDnIzLCeWnLqAC993vqz+FiBX6yP4NQPtpuhEv3dBY9/A2fjyntzfuRXC9DG2BZmq
	26K4fVOdzSbmYV4zB6y6fEdlBKiZUOldgysO0snbFuoXY+rygfEkbL8d2hrluJ6JOkTok3
	q9t7CUP3Vx+gUKmWqYt7Eod1KedTpa4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757513078; a=rsa-sha256;
	cv=none;
	b=33U7Bf4P9ojGzCo/gQzdMa/FFKAHAGl8zm69cC/lhWCSE2TLF4Kb+JtNLL9qzSgvTP2UY1
	m7MQLdWenZqu8NpnruoUFK2rkOF1hB1TTcnHXYe7IZA0NeSa/heviKnlTU8CuKl2mCSbY/
	HgaNfxWk5dMozlQ0Lmud5mc2Gl91lp0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id D2E8683E14;
	Wed, 10 Sep 2025 16:04:34 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id LaIcEPcDfBsv; Wed, 10 Sep 2025 16:04:34 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 1A4472FFDA5;
	Wed, 10 Sep 2025 16:04:34 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id X4a51J5LvQXj; Wed, 10 Sep 2025 16:04:33 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id C16AD83E14;
	Wed, 10 Sep 2025 16:04:33 +0200 (CEST)
Date: Wed, 10 Sep 2025 16:04:33 +0200 (CEST)
From: Richard Weinberger <richard@nod.at>
To: Arnd Bergmann <arnd@arndb.de>
Cc: ksummit <ksummit@lists.linux.dev>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linuxppc-dev@lists.ozlabs.org, 
	linux-mips <linux-mips@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, imx@lists.linux.dev, 
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
Message-ID: <497308537.21756.1757513073548.JavaMail.zimbra@nod.at>
In-Reply-To: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF141 (Linux)/8.8.12_GA_3809)
Thread-Topic: Reaching consensus on CONFIG_HIGHMEM phaseout
Thread-Index: xOQifXk0CYTOSYO4gO/z6lk9BLmNXg==
X-Stat-Signature: 8wp5cgm6wfwyi8ponxyzci3bzjip3jg8
X-Rspam-User: 
X-Rspamd-Queue-Id: D54FF1C000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1757513077-904625
X-HE-Meta: U2FsdGVkX1+vGhQW7d7a4PXp2AJ/+GXaeAA6HnGuRRubL8plA/qO9vkckoMBflnqgf3GsDUn4XoOmqSvcljgwIyuJhAq+WUE7c2gp7BBYGTIggLISxL6aOevlLVUGyGNvvAQoYSgrisuQkuvLVtwEeiZVys3/GczdCTU8+G6KT4S/dVP+zDFsmaexP1G4njF0tyzHqu1URRlWYkxGaCA1XphYT2JZbEHO4vnC0+P38qLTy4doU40wopsl76yVhJpQkpH0lyVx+Uye2BNLZC9Kek6H0OOzbEDI+K9Dg7Yaf/5FQMMA0ojwSRf21T3KW0Tw72jT3tivdg7BODLxZ9IGfl6cBTGlwTAoFmR7V2HJ7dI+Cchuq1A9VkAOiwAdz+7IR33Sfc4Su7e7EtMFNZ5wwKo3pzZ+QZyrOkzw06XVhuZgIT9oIdN+3Sro5bjQhG1piQsnxgOSV7KEQyDmT2jiNq4GPml5c2NAUBq5tFs91XXrCbJ78BKt1oi0OUWP03EpiRE8SKKm/c0tjS+Hj5D47WSTNricE94W5U/nEuETK6HXO089/03dAztW/wYBejZ/npbUFzfwar02L0eJwTk1U7Y0aDy4wWpoVE7GWaarC03YgK6QyT8YWVSVEYNJnSeG3EPRaKXw/Gy11d/qqmVomv7EFzOTA1nB+8dAJDBOSCMQJ73ozQvjQWR6/fYSO7WNYg7CyqYJk37Lee1KkzkosTSUJz8cs2Fm01fnFkrcOQQ9p0rRpbsIH/V+r8zLqXUfGc3lP4WlRCdAtshUvFW5t8EZUrovLGog96UZpMIj8CzywV6AceJhNyz+ixovAtnxUe2D8qz4Vqp0YjqusGt78uK29ZyRuHf7qaV9B3YpHy/W0oZhpJj7w0GNdDh40rF7/hW5AllbM0xigZsOIRIb0AShZelGJZFvSbm4MRMD9n1AJRDwu5ZS0zDIioPwL2ZQWVaILvPqxZsjHdohJE
 cSDTeQ/k
 zvjTwfMZGU6Ti5MX72mThV5IDAd0tao29Gc5XZGEbJxOPe4FE2uOh2Uwie+qvY83u1+WUexD6nODQTUS87o6gp4Agp7X6aX7SaAnBOWe6+vjQHelOBpaPiKltJXOOmya7Mz9VVRQopo2xFzt2s8jXSWfJmCILKOquFwMlaJVdOpSusFBbsGkwpaiJC9d9BQbrqT5HqHRp5lUNfi0sx+4esPqC4ISruglkrKnJJ1XUIAS9V/9xa/JCkvPESEDs8CnfVgsbnqbLOKGXy4Q7OagCHmEriVNZwKWcyzZLa88Pe83EigKfaOP1U05LieAqLlfWf3w/GTXR9xoYxGYa6ZRkyVIQqY/4L0zJOsz6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Arnd,

----- Urspr=C3=BCngliche Mail -----
> Von: "Arnd Bergmann" <arnd@arndb.de>
> High memory is one of the least popular features of the Linux kernel.
> Added in 1999 for linux-2.3.16 to support large x86 machines, there
> are very few systems that still need it. I talked about about this
> recently at the Embedded Linux Conference on 32-bit systems [1][2][3]
> and there were a few older discussions before[4][5][6].
>=20
> While removing a feature that is actively used is clearly a regression
> and not normally done, I expect removing highmem is going to happen
> at some point anyway when there are few enough users, but the question
> is when that time will be.
>=20
> I'm still collecting information about which of the remaining highmem
> users plan to keep updating their kernels and for what reason. Some
> users obviously are alarmed about potentially losing this ability,
> so I hope to get a broad consensus on a specific timeline for how long
> we plan to support highmem in the page cache and to give every user
> sufficient time to migrate to a well-tested alternative setup if that
> is possible, or stay on a highmem-enabled LTS kernel for as long
> as necessary.

I am part of a team responsible for products based on various 32-bit SoCs,
so I'm alarmed.
These products, which include ARMv7 and PPC32 architectures with up to 2 Gi=
B of RAM,
are communication systems with five-figure deployments worldwide.

Removing high memory will have an impact on these systems.
The oldest kernel version they run is 4.19 LTS, with upgrades to a more rec=
ent
LTS release currently in progress.
We typically upgrade the kernel every few years and will continue to suppor=
t
these systems for at least the next 10 years.

Even with a new memory split, which could utilize most of the available mem=
ory,
I expect there to be issues with various applications and FPGA device drive=
rs.

Thanks,
//richard

