Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E198606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 10:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass header.d=nod.at header.i=@nod.at header.a=ed25519-sha256 header.s=v1-ed25519-20260901 header.b=fdQj63iR;
	dkim=pass (2048-bit key) header.d=nod.at header.i=@nod.at header.a=rsa-sha256 header.s=v1-rsa-20260901 header.b=MdRe7Szl
Received: by kanga.kvack.org (Postfix)
	id 164A96B05B0; Wed, 18 Nov 2026 05:47:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13C766B05B1; Wed, 18 Nov 2026 05:47:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07A236B05B2; Wed, 18 Nov 2026 05:47:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D3CFE6B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:47:29 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5DE59406C6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:47:29 +0000 (UTC)
X-FDA: 85447913418.25.CAD7568
Received: from calculus.sigma-star.at (calculus.sigma-star.at [188.245.196.96])
	by imf16.hostedemail.com (Postfix) with ESMTP id 523F218000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:47:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=nod.at header.s=v1-ed25519-20260901 header.b=fdQj63iR;
	dkim=pass header.d=nod.at header.s=v1-rsa-20260901 header.b=MdRe7Szl;
	dmarc=pass (policy=reject) header.from=nod.at;
	spf=pass (imf16.hostedemail.com: domain of richard@nod.at designates 188.245.196.96 as permitted sender) smtp.mailfrom=richard@nod.at
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794998847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJynymlG3cwjTCUtbWU2VLC+dEMiT0uwRnlq30YDBBI=;
	b=fdu/J7txHsnDMTxXKu4uOP04wOdqwyXGtOAndpCg/RgK7+aTfLyBCo0+hXSaPWh18SbEPO
	mIVTUGMyp8r4lLS83vqIvpEJQwc+rED+f82uH3sUWrYVybYl+BzU4TNJ+bNAGsI3UiOJw9
	dN4+LfKZJ3R1VO4jry1drwUNBuJqbaI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=nod.at header.s=v1-ed25519-20260901 header.b=fdQj63iR;
	dkim=pass header.d=nod.at header.s=v1-rsa-20260901 header.b=MdRe7Szl;
	dmarc=pass (policy=reject) header.from=nod.at;
	spf=pass (imf16.hostedemail.com: domain of richard@nod.at designates 188.245.196.96 as permitted sender) smtp.mailfrom=richard@nod.at
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794998847;
	b=un/8Z3yCJ13LGqCWfH4n8CZ47TtBQzbw2GbGT9E1fDIJMlkvRgPzQiQ4QDTqsGq9h16rNQ
	rFSJCJaF2eIzWaKWVZ6bccXqgsvce/lRE/cYpi+DXjICAytWXOpnxhQe3RXM09SlGIrzpw
	ogfnBhKcAy8vZp1JLSTu8wT+oSKa4gw=
DKIM-Signature: v=1; a=ed25519-sha256; s=v1-ed25519-20260901; d=nod.at; c=relaxed/relaxed; r=y;
	h=Date:Message-ID:Subject:To:From; t=1794998592; bh=PJynymlG3cwjTCUtbWU2VLC
	+dEMiT0uwRnlq30YDBBI=; b=fdQj63iRkU1oWMWfBe0XDFdpP0BAnPMau5ZJaoU21EbLZnER6A
	vIhL4On2dwD/TzFjzc/72o30iw9dTvGXeyAw==;
DKIM-Signature: v=1; a=rsa-sha256; s=v1-rsa-20260901; d=nod.at; c=relaxed/relaxed; r=y;
	h=Date:Message-ID:Subject:To:From; t=1794998592; bh=PJynymlG3cwjTCUtbWU2VLC
	+dEMiT0uwRnlq30YDBBI=; b=MdRe7Szl8T2ELeiYlByW4qh54ue1HSlfwmNAWubC+sKJOPgHUS
	/KhFc35/3ERfnqjmXE0/Kg3JC8fwSNiIjoMvB3HQpciomoefWzA+J+EXdbGrgmbgjuu9Ng5AmmK
	jc+x4ZJ1dlC2jujt9jUGNLIIKQ4ToISx1mB5o8o4t3Xy13a5HkdUFXkd4xfP59zUHS91dWezHEa
	iPLPcH3mv50PY/FB1xg6Oa6iokZUfxM/yvZeZoPAqhSCY+cJEaQ18uA7q0077weTCGLyDlGumgF
	6zW6sqZvSX84JH/KSQXDVRjjgPIS90GdxRFmkCeYrAQHw7pr4xbqu+85avTbJOaLBeA==;
From: "Richard Weinberger" <richard@nod.at>
To: <arnd@arndb.de>, <sashiko-reviews@lists.linux.dev>, <arnd@kernel.org>,
 <linux-mm@kvack.org>
Cc: <andreas@gaisler.com>, <akpm@linux-foundation.org>, <chleroy@kernel.org>,
 <dave.hansen@linux.intel.com>, <david@kernel.org>, <hpa@zytor.com>,
 <mingo@redhat.com>, <jgg@nvidia.com>, <linusw@kernel.org>, <ljs@kernel.org>,
 <l.stach@pengutronix.de>, <maddy@linux.ibm.com>, <malin.jonsson@est.tech>,
 <willy@infradead.org>, <mpe@ellerman.id.au>, <monstr@monstr.eu>,
 <rppt@kernel.org>, <npiggin@gmail.com>, <nm@ti.com>, <linux@armlinux.org.uk>,
 <tglx@linutronix.de>, <x86@kernel.org>, <bp@alien8.de>,
 <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
 <surenb@google.com>, <mhocko@suse.com>, <david.oberhollenzer@sigma-star.at>,
 <Julian.FRIEDRICH@frequentis.com>
Subject: AW: [PATCH v3 06/10] arch/*: increase lowmem size to avoid highmem
 use
Message-ID: <mwlztee3.a0fc160f-3d4a-41a1-880d-7b9f8ef19767@nod.at>
In-Reply-To: <0829a44d-fab9-439a-b80e-4791fc72ba0b@app.fastmail.com>
References: <20261116124832.662455-1-arnd@kernel.org>
 <20261116124832.662455-7-arnd@kernel.org> <sashiko-outbox-218801@kernel.org>
 <0829a44d-fab9-439a-b80e-4791fc72ba0b@app.fastmail.com>
Date: Wed, 18 Nov 2026 10:43:12 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: q1wmdfhwocodegquxmnd8r79rjrcjfje
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 523F218000A
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794998847-3149
X-HE-Meta: U2FsdGVkX19MzcUDs2IWVl6hIII+OC+u7npVijKPftQgvXzFf1AxDJf3A6nrIZs+G5Et9khGHLD6p1uN8N2psF+6t9GdWn/AObQT48YhVQnHm+OEnJov+BWbvpD1Eq6xZz+6ys+D5Ec2vCBmL5sAp0KIf8A6YNFbnpAb793l6dJqNYiOJ1t93r5AMgTVQxNlKPpUQcuHrtkHCE3Tqd6TRKOhimoQgIwC2GsJof2R0QpHohRuxoeLzvmuJL3BWiBvKPwu+mLjhtoZZblEV9rD62PhcgTT2NhimZ447PKKMopax2xCXk1F/SeoxRZi4dhs73fR2nu/XzyPk2LONLs8nEsXW75EBXd9TIfplUHi1T8KW5pomKO2tfqplu5puxCWA28+a3h75nWzEGZCsVcuLNQWRjVu2UY4cnhYQZVNflXTE04YcZHSVBeLcKb2evTG1y1VWSwaz2SDcXEgMnlHtItevtOjFyPaj8Cd9l9t7io+wFSPmk5FnBb69HbSypZV9mxXSdLtnHHsIapSuu37g1FlV3aW1LjxwXlO4zMRL1w2+AirZzHystkvXCDw1SzPDVIn4BgrGNdOF+IXhM0Ooorn8BTE4/f/weCCHguSwaL+VJU8GHE4Jme2w2wiuQLtVVJSwjSRg06QpghZk6f5A1oXmx9iNn/IyxXH3HWeqZlCv4ooUYw6XmOh4e2IAQdqseCb/txoVhWW8An/taKPAqXAlo5I/rxJJ3TZqJCcSTbSoCWqexdxR93GIR6Q+1gVQtO51dmcQQbknD9c6MaOZqTtKwnOGU2yCbxXJnMRLuwmC3zm8uCDXtHWTx84fx1U8f91WmbwEeIpwQij2S9CaRNtdPaDpZ2O/6wKFtHJKnTxVZynU8icek88kOdQGCNQg9X/1ahsStubdgFLMb7sngLmhCFA7QBiS0sWCRy+SFWDuXCiChKm9USuYnai6u52t0IJVTIMZ9NhfsVOPZ8
 lkLEWoXz
 PROTlfCdGNCIGyUwQL1tczIXb6BNFd4ZpifBbQE/dPh84RK44pzrl4lXJ4t7xOqiMAM77ZEl7r/voYz3tGXvp7awjgk+/6d1N5snlYm+31yZtmjg9eROuDv5wSiFF52e/dLshdBw8us2m8ga4RRpMENu4GkFfScndQmLuj+dpEiNDiS/hjUHfoSGVsDORljDpG6i9qCE5Zm5o6sqUZfoZ1o6x66HilzVehyMIcLVsB9TBrQsjwUn+Dj++AyMeRhbtDSxFD1zlMHmS0OY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Am Wed, Nov 18, 2026, 10:36 schrieb Arnd Bergmann <arnd@arndb.de>:
> > Because PAGE_OFFSET is now 0xb0000000 or 0x70000000 (an odd multiple of
> > 256MiB), calc_cam_sz() caps each CAM at 256MiB even on e500v2.  When
> > CONFIG_STRICT_KERNEL_RWX=3Dy and CONFIG_DATA_SHIFT is set below 24, map=
ping
> > 1GiB or 2GiB of RAM reaches index 15 and overwrites the active AS=3D1 e=
ntry in
> > TLB1[15] (and wraps the 4-bit MAS0[ESEL] field at index 16 onto TLB1[0]=
),
> > crashing during boot.
>=20
> Ah, this would explain why Richard was able to boot using my patch
> with 1.75GiB but not 2GiB, at least if he was using DATA_SHIFT=3D22.
> Hopefully this should still work as expected if we force DATA_SHIFT=3D24
> for larger lowmem sizes like.

Hmm, David and I have CONFIG_DATA_SHIFT=3D24 in our setup.

I'm currently fighting with a different problem in the board.
As soon as I have more input, I'll let you know!

Thanks,
//richard

