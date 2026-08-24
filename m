Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDC57C5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 19:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2EEB6B0095; Mon, 24 Aug 2026 15:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05A86B0096; Mon, 24 Aug 2026 15:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A43DB6B0099; Mon, 24 Aug 2026 15:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D14D6B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:34:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D6D6DA021D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 19:34:11 +0000 (UTC)
X-FDA: 85137163902.27.7FDDB0E
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf08.hostedemail.com (Postfix) with ESMTP id F289C160009
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 19:34:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="kUlwIR r";
	spf=pass (imf08.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787600050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e856r2XdSovK3s46tfjF7qqNQSSG6k7Xd9AJzciOatU=;
	b=Ultcx/S0bdNKySp6RftkUyr64CHYfT7A0GCYXiRWtANTNalwFuZ/cYSu4Fm391jAKbyN9z
	miEIsQrsWZJKQQ9jKSbouOqvIIeA/heQcJvZyH+2wtEveoRvgx80stUQjX3vGPylhUsBOV
	6pvYgLRdWY9wIuPx0m9HjgZKIhcpyaA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="kUlwIR r";
	spf=pass (imf08.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787600050;
	b=lIS1VvIoR2lgiKmJGgwZQuReKSC1JUlTKryLWkq+6a1+8QRutSTQ0XV0HOIYeOVLth+SFV
	EFqKpOkIn1REzPASaF0RluOGTNGblDW0Mvxppe7kcBl5W20arLGT+Unq16MAhbl9jZRhPx
	3MVvijwsHxWf6x4khZSfZbKaCpJgUeQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=e856r2XdSovK3s46tfjF7qqNQSSG6k7Xd9AJzciOatU=; b=kUlwIR
	rM9b3PMYhiTB2ZzcglWmkYwdqJmum7Yr9yLS+0pnHE0rt/ENWEENaxynSpa0bl4C/LI4/Xwqa1QZt
	LzDUVSkI8BVfOuQ+ad+upzsEcZiluRho8D2+C8AbG0Mb7FPgxDtYnHrANWSPsKpJXN+DEO4h2vx7B
	IJL57OpS684UxqO0KtAwB7dj33I/ZOf+cnSEoZCWVAsmjnzkzqQ4yEWaCSuFicOHlhipbOJtWiYlv
	Oss220Q4JuquNEbuhQ53VR+jVhnGhX2IH8de4HUyrojx/eNO0a7v2gTlRsjJN/DG609haBjOUgEU7
	IAYyq0bPGD5ajDBC1bAmNCIF68uA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wyaQ0-000000038ub-1E9K;
	Mon, 24 Aug 2026 19:33:16 +0000
Message-ID: <b067b26d9d0bc224b5916c7e064277863e7bbc55.camel@surriel.com>
Subject: Re: Removing ->dirty_folio
From: Rik van Riel <riel@surriel.com>
To: Matthew Wilcox <willy@infradead.org>, Pedro Falcato <pfalcato@suse.de>, 
 Christoph Hellwig	 <hch@lst.de>, Jann Horn <jannh@google.com>, David
 Howells <dhowells@redhat.com>,  John Hubbard <jhubbard@nvidia.com>, Jan
 Kara <jack@suse.cz>, Qu Wenruo <wqu@suse.com>, "Darrick J. Wong"	
 <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, 	linux-mm@kvack.org,
 linux-xfs@vger.kernel.org
Cc: David Hildenbrand <davidhildenbrand@gmail.com>
Date: Mon, 24 Aug 2026 15:33:15 -0400
In-Reply-To: <aoyWln-Gt-yvZQkE@casper.infradead.org>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F289C160009
X-Stat-Signature: ging9q65a99cy9x1odp8etbxwag5pbwb
X-Rspam-User: 
X-HE-Tag: 1787600049-31759
X-HE-Meta: U2FsdGVkX1/Ryzmd+vCXqoKMv1kUKie5cJ+FWO9xI1Yj4hNBXiIofAtxNb1i8Q5q3Z4rEZDH61/APXu1Fyhiv169Kxfp96rFVau3dH08BdNuukm4U8ODspj1emErc1trZsWiPx8RRR3vyyBrgLzVdMSU3eCBX0k6pOdH8joG4zhysUQhdgxNOnxIm0twcjiRGh730H71UtDUOzL/Bvz//6EH6NFMwgfM+Ts1N3hSB2c9wvF8dVPYSAI+ZrBqihVtwH2DoVagZsjEYwoCmeHk/0aUgAGivmgnXcxQcnnAHrydgIBm1zwUmMGLjD2AZtMcI14x6a/ixEChILVpNlCpzT8yqILJh7VgF1/IbK/dAOZqAH+rooqcOy8bLE43XWP+TqnhjE0yl0R11B+sJmGahRVhR7dP7rwaw/ZNjx6+hbVT8fPckFOT1G3e+jEclZyBekt/qZhHNzJna/aQdXyF9+v0diRUxCEEdm0aqN3PtLtlxftx5qGsJLyxdg0TIre7Ef8eZ6xEiYlxw1L+Ag58WWZmEUe5grJH3IhCSN0GvU7jfO9UW5jlxeip2qcuLskq7dAddhuS2Et+SM+NbHipfwAZnluyfUPp6wou+Tecey2YBRElDTnvtjJV1uk8k5XIXHfJiBI2R35P8S2GIJlIuXMs6V6Gnj3EVULqUvKGBMnorxhNiTbzQNHk8LK9NIArIGejAqV+1MjKTRxW9+HDiz8EHGu8gLjb6Xifh3OalA3sIQ8DPf8gkNXNfFJYUPCwoIitGQGEpXD4U1ewKzGWfIu3pw8GzyYEqdu8bH14ghr7hVuUnVogsAGkGci6Y4yzesI926ukB1Wi3nEzPAYOSq+MxF17kWeMFy7XcoX4pGVAeuGHPRK2jvhxyuapXqpz1lkrg/tp4f40i0fscHBR/88Kvjb2UvtmwLiTl36RZBLYfvwEuSL9FOh/+3+m/SO/44x6QmH21JyGW2P8DVp
 wk5wqxAz
 V6HA+OBGrvj4nhjjK773H5MqkKyAcovRtuXgmUUQwHP4Z64HUi082oL7NcKsRmtz6CxNX6xs4JiDXs0qzctARMMdz6LR85HntRp9cJbrtr+VUfxgDd1ZRAvsKBwoc698cy+iVcmotku/2N2/GNq44CuvFFqKZSgQuYRQMXKjyTgBCAKmwD3d7txzzhwS6H7R0XlJr0CApbajZWBwixiA9gw5VMW/aklcA853CCX+Et4Sl6lUMx+r88rxgIizGU5vYbCSsXnMgaPuVr/elVVRW+KURMq2FJQIc1tgbAyxMvip2foOkW+3yl9138zorgBARRE2UIToqwVdF578=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-08-24 at 20:08 +0100, Matthew Wilcox wrote:
> I think it's time to remove folio_mark_dirty(), ->dirty_folio() and
> so on.
>=20
> This is not how filesystems want to be informed of folio dirtying.
>=20
This sounds like I should leave the folio_mark_dirty()
stuff in the get_user_pages() code alone for now, and
leave the shaving of that yak to another day?

In that case, I'll prepare my next version of the
get_user_pages() series.

--=20
All Rights Reversed.

