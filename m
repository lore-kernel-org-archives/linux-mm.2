Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47087606A323
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=YnjyECYZ;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=EoYAqh2K
Received: by kanga.kvack.org (Postfix)
	id 4B2CF6B05B1; Thu, 12 Nov 2026 06:35:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 489DA6B05B2; Thu, 12 Nov 2026 06:35:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378F26B05B3; Thu, 12 Nov 2026 06:35:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 049846B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:35:09 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 887781A0598
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:35:09 +0000 (UTC)
X-FDA: 85426260738.14.D3C7654
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3855CA0011
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:35:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=YnjyECYZ;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="E oYAqh2";
	spf=pass (imf15.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.157 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794483307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FpibZxpHOkegx/nWCVPd2wzoEHQ0LrdmDgeGw81ilYs=;
	b=EUZlTDGD+J8TmCWZ7DgxKmuZ48S32kvL5HB7/+MI5PS6DZjGn8QJr4pR65vA29peQtnf3A
	CxKwqpTpdD5rscivGmHB3vSzLxdA63gfoKJlcLvtT/c9ftb2yWjUUpXz6lRvbt7sk6Hs1P
	AldPt18fp/d3h37xwNMkf6riPnfJVEM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794483307;
	b=vE472Q6x2EQ+HydTumLmVL/KFyH2fJXATjbyjiOjBZJVcD/uBkmY+Uo4y/xFzD75CeqBFY
	8upgQuy/7eC6wEl1dwjLu3Oxr13N2cR1fzvIzL8sdPkPW5DHj2yBv5J7DgBcTOa3ZUGP2H
	LxkxdPDDu0VdhcVTJkJoHb96uVwUGsE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=YnjyECYZ;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="E oYAqh2";
	spf=pass (imf15.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.157 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 278997A0050
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:35:05 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Thu, 12 Nov 2026 06:35:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794483296;
	 x=1794569696; bh=FpibZxpHOkegx/nWCVPd2wzoEHQ0LrdmDgeGw81ilYs=; b=
	YnjyECYZ5KqjOOxhuESWXFBKhCb+g4+aQMsE/ayy4dx7HTII8DY5qC6L8N5Oq4B9
	aFFXcVADNerTxuZ4qxGAhtHAqG7Ds9FiWH14HZS5/r8aFrj90hogyx0r63B7GN4c
	HTIWiMrRFywAvU3cu6PSxo2mEo2wHUJDFH+hYNAWajiu/5LbHOW97cdZvILz0fXn
	zhXASZyR+cnTWGJUeUnrDTYmxAotShzqzAc1UE0CnIEEVgGEdHO51b+oEE2B2vkk
	EwZnIwY5apX3sJ8oP4as/cbvF9EiHf3aJu6JQzQ//ouQdy8tS+4ndhErxFr8A4/6
	Tmv0hIqSBbeHpYbwFYmXBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794483296; x=
	1794569696; bh=FpibZxpHOkegx/nWCVPd2wzoEHQ0LrdmDgeGw81ilYs=; b=E
	oYAqh2Knmf/M2+WL/lYcoYF9Ubw58FO6mJetTaHFy5/LP16KrM7LNtkQamogUqAp
	X7qOCs4RlUds7Dc8mnpN9h2grKnPJ044gBRfEW1iMn2iEBAFLPpMj9oeDvbhgMLq
	b6uWz+Nbru7IoqVwpNkOKvRNUjKULEjAX6ea+yAVxCmTyRnMRXeVafaghHJ5HyIS
	1ULFS78SN1e76eEVZlzBDFGTJ05IuWbSK4eaq6hnSXhgZHneGIY0notj7lBz74rL
	uL+9I12v2l4s1bQvCH1OtwBpPFca9Z1PmeL2NX+n5X1QzfSwPjyPMXPwQxPltDzp
	cspv0AX5xv2pYGnj9IjMw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794483296; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:R/koFqVaZraVsuT7GWQBZ9jf9O+h4M72d0z2sDeHDNzhKMH
	3ZeXmTgbJuTgECayyBpIKHmEhSmWHa6XH205RcCIzQKEt/yOUvfgW7ztqfjYUBZq
	KFjLaNEQMbMkD5Sz9SuSKBX0hB/8CL6gUb1WmeHVZKPKUQjrCsOEtRLWf8P2JEq8
	2A2yFDwxCWd3O0OWGgejzZoLWSyGf8PtxccGyhNVuKZ3n+xwypMBafoBmTA3XKsN
	2GB2mirIj+gSyhRrWYwoHkJTsl2SqPNOEbpQWMW9XkjS4wZKY/qWNLJes+uGGaQD
	4L7QveFLgecr8i3GAvyT02pofwiml54pkDw03+Q==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:LrLjs6XTKWCSSNotOqYUK9bd4P/Tv2a4idtoIaia+Eo=:caBZPj8plx3VSvs+ge8aezudfEqyHYXFIacZdzWX234=;
X-ME-Sender: <xms:UqT1asJlqyiyyIypv7wjKPJ9lHZ4L4cP4JeT9jTkIAnyAnwO4uj5ag>
    <xme:UqT1am9zzTRNILYWl5sBNEECXIDd5mHUoOkovydHISaB_MfOSPgBXKFeqXG6sUAnm
    TIuHDmjBLIa78wscurRNaxv9g-jg67zFAV3PTKaOBf_HtICSd0ADG0cUA>
X-ME-Proxy-Cause: dmFkZTFK6NqHhcvznJICrUy/D/REKnqcZEEPxcmeVbqSM/sH0tEH4MlhHzwubOud3I7xCZ
    nREf/SCeRN3WTSxr53ekKjNkoeLgpEJs5urD1/PA3o2atIbiI/NqMdbga4WzwAwMLtYZ6M
    g9wFUGTEOmpXYzjzK9On5HW9cVzMWqAYlx/bYQ1R5RVqZZARJ3ah6bS6Hb7DKTN+3ITNhN
    25hYTSTE4KFT5WWR/bCD1zQulC9fpiIoQTwVpHiOO+TXtva9ezDSSYqcNMlUs3dVzLB8Ua
    ee6nq1ZeuK2wjkieQK44K9yCD1LxPt5h9F/VCy4zZBHyLneRDGN3aphYXMbGTO/eMhh4gw
    7Q+tYUI3Sw8I1/2TcdjW9OAK76ncriH2Jy6uu5YDDZkP4V5JFV1lzBZYxM1KSpUhkFLJqD
    FUUlY5ijAMmgVcahPXUKnn7ptM5Dhp146Pjp7t9LKG0hp4H3j2ebQrUYk7CPa7R47HZqcZ
    wRDqG8Hz0RFTRI4CWwU7sEvcIBC8qXuTl3Oqhc1vbL/iMEd9V0FDMtz9h0kXFz3WpA3EGE
    +AR168DYzFjnr/nkbQWNuy98Ow3hAGNAOq6kMs1UJBkgZaKywh5q6uVbvRPEX4kb5XLPwo
    KQ5vszXkt/F7xUNHFSFfdp/7RRpRLdvaE03bFNZPayUSgxOd+8xrqM+yvkng
X-ME-Proxy: <xmx:WKT1ate0JSmoljTP-1RvObYglimMb3meuI6LWzSKhIqS161hEmakMg>
    <xmx:WKT1alkRLCwtkeL289w15sRJI_h9Kl2o7gWJq1zj_lp9iyEoMvFfGw>
    <xmx:WKT1aiHaPi7iX7ijag6QKLzhk2icR_DyPcoc7lQI6QBRB_C_Cep4ag>
    <xmx:WKT1ag9ByCoR9wJ701SeJXf3gCON-Apr0Pu_xNxmAv_ysbIxA8BZ8w>
    <xmx:YKT1at2vfJVpoavGotgby5sfMSO1WVKloXsk31C4yR7PRsWzAogLoiYV>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 1866332A009F; Thu, 12 Nov 2026 06:34:42 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AD8wiEBgakfZ
Date: Thu, 12 Nov 2026 12:34:21 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Christian Brauner" <brauner@kernel.org>
Cc: "Matthew Wilcox" <willy@infradead.org>,
 "Kirill A. Shutemov" <kas@kernel.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Miklos Szeredi" <miklos@szeredi.hu>, "Amit Shah" <amit@kernel.org>,
 "Jan Kara" <jack@suse.cz>, "Zi Yan" <ziy@nvidia.com>,
 "Bernd Schubert" <bschubert@ddn.com>, "Hugh Dickins" <hughd@google.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>, "Simon Horman" <horms@kernel.org>,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 virtualization@lists.linux.dev, Netdev <netdev@vger.kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Malin Jonsson" <malin.jonsson@est.tech>,
 "Richard Weinberger" <richard@nod.at>,
 "Geert Uytterhoeven" <geert+renesas@glider.be>, "Nishanth Menon" <nm@ti.com>,
 "Frank Li" <frank.li@nxp.com>
Message-Id: <b90d4bcb-b865-4a41-8496-78d751c03dfb@app.fastmail.com>
In-Reply-To: <bf186643-780c-40e0-bde6-f2af90404a18@app.fastmail.com>
References: <20261110145241.536019-1-kas@kernel.org>
 <20261110145241.536019-2-kas@kernel.org>
 <avNuQqLf9CG9dSsE@casper.infradead.org>
 <20261111-heimreisen-ungeziefer-empfunden-a892571f2c07@brauner>
 <20261111-thunfisch-wirbt-waldrand-822275b2d3b1@brauner>
 <CAHk-=wjPY=kfgnmtx4COEQjD5UzKx9m2-=KLGAZP4d=RKEH+pg@mail.gmail.com>
 <20261111-stumpf-montag-miterleben-c4e2feac8090@brauner>
 <CAHk-=wjGXBnme-N+HvbzHH40ftb7Suc=kZVT5cuintQWyMHJ7Q@mail.gmail.com>
 <e94bdf7c-eae6-4f64-bf93-0aeedca1a22e@app.fastmail.com>
 <32ad880e-5946-4703-9c6f-43ff59da39af@kernel.org>
 <3eb60948-8fc9-4682-87c2-c113e54e7d4e@app.fastmail.com>
 <4d6a3d68-3fc7-446e-9f59-f61d7475e22e@kernel.org>
 <bf186643-780c-40e0-bde6-f2af90404a18@app.fastmail.com>
Subject: Re: [PATCH 1/4] virtio_console: copy pipe buffers in splice_write()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: wi1wgwdnjazbn4s4e11wu5fdnbzug7rx
X-Rspamd-Queue-Id: 3855CA0011
X-Rspam-User: 
X-HE-Tag: 1794483307-820078
X-HE-Meta: U2FsdGVkX18QBzjZK76DPQtFZpHwPoTrjFIEdGQ6KZCrMtwUFeF3QhJdinna8SYQvO0eB/U64jLcws+scl7uz9njx9F2UdDessApbcEvoTjnOB7gxNznYb046d4UwjGK/SM2eFI9lDy7ZJyHR+Bpz0dGbhNiN5AIDJPH/5sE3cdMnaPjc1PuJysEJML5cublC6SIxT2G1BHbeL8KJP5jQIOKI7kpXW9Rx1ncc41aMtx1p2waZRw5UYfNuEdawNd4pnWOK6tLIvsLskGC55EACrRULF78jt/rpSXOce5fLDr8lkuVF3HX3VXB4jDRdGqCmboPntsTd9nptaocTO0RtnH33C92d5wIGYJw48oepso11NkZccsoUISUN5UFcfToPIKOhXNw/Em5u6a5ac2+4M9/O+tvbwe3RhH74HndGb9ZRwLDQAqsIeTzZ0x0/A9SXNaoShZEoBFkSwT3AiWjqdlHOFsrlTEpD+qHKqG3nyn9iDyNkTEcfrs1yABHq9+x9ZrBXfGmxKObd4VnH2OmR9qaxoHFG6eqyvYkJRla1RhJmXFE0gDNWjYZGm6UN1g90+f6Rg9sSJfxfNQrJHwfv/ExUgdVqwemof50n2UEmW79jHsoNDT0MD1g26kXhZjHbX061WHL3vu4rUtXJZsC1ZPgUrdPPx4WT1HTRc8fkxUihLUNXK4pr0ax0Loj9CKLK591AMQyT2E1nBGQEXANTBEcQGMv6uCmjO06LM4M82ZPYtJU1u1xbcCOloLuh5WsJYDBd3BS2KfWhIzvCx46IVnZuuLn+i/iLnhX4tBw/zj4aids2PldVBXK1G8ppOlT2Nrijk2EjvN/oUOnJkmr092qCjwYqb7Lrbm0Ues+FC45/Oyi2VnBt7LiXvLfbHh+B9A4TJ/WOL0FjD1uq/RqUK8Yb9RhYZppcnJAOmWTANud/9V79+ctfRJilpuEAOl3l+VySVcJtIHW69vUSp+
 k3CL1fIQ
 jgsIDRWRi2Eig7Bsq38kzOH6I12ml+45qN7nAip0+3Vb3+R7QKf8V46smDrYVmWhaGBK2xQDpWq2QYjCVayfqhVjFv8U1i0/TZ5A6CnpZyslKkegPvo2ykljLdzBjJv4sjXE9ZDfSmG7HxvTaslDn+5IGZim+zK8QP9yuav7pO/h8fWk7Y2ecA4XYYa4c1LF2txrZIgdOIFSN3HVzvPaLmQMX3VyN6QnuWFx347vEvHCug+mAKpHXGOocnGolQn91DP+QqikRp/lkKTDvjLx2teWYkj1a0YuDl3dEM+10kIdKaoyHMZTUKQ3G7e55MyP8VPKaG/3A2PNBcvSacjNk/+cs6qdu+jRT78gzeM7eMyXVaAMbIBbzPYGD+4jyvHytWRBHTcnW6GGzLiUMS8LBqnI2dfA6Ju0Bk6OByJJEstYqUHNxKEt23PCaF+QNxICRPSDcCoV4mM8NxVJ2g44IbpNtEC9JUVjZNliNohf6GvesOvjAFxi3Rxv0Iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026, at 11:56, Arnd Bergmann wrote:
>
> I'll do some more build testing on this version before I post
> them to the list.

Posted with a somewhat shorter Cc list at
https://lore.kernel.org/linux-arm-kernel/20261112112528.1116405-1-arnd@kernel.org/T/#t

    Arnd

