Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75DE2CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 15:14:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF4918E0130; Thu, 18 Sep 2025 11:14:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA5798E00F6; Thu, 18 Sep 2025 11:14:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B93378E0130; Thu, 18 Sep 2025 11:14:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E9B48E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:14:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 52AAE1A022E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:14:23 +0000 (UTC)
X-FDA: 83902717206.27.FD77437
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8C1BA20013
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:14:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dyx37ooM;
	spf=pass (imf03.hostedemail.com: domain of conor@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=conor@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758208461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e37jPrqR9E8heaYU5Fw0c1p4mhM/UmeLs+VMIVzgSZE=;
	b=mBFcVvjoTMvM8Ybab5pLRqoXKghRTUXp4qSkOF7lNqozJWKZJHMcRCw+RWlkjF3h/YvEOl
	pazCiBnSId3kfdRBrMv6U2n/XUDt/Ip6wWRDEbZyWx/a/Jx5LjpdHhAxrCDpwgx5TOA+vX
	bAsnteC4oPn5We3EbZTA4HRTv9iWFZw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dyx37ooM;
	spf=pass (imf03.hostedemail.com: domain of conor@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=conor@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758208461; a=rsa-sha256;
	cv=none;
	b=tnrqZebIXc1RH1M90UzTrFKu1HW0khA3eHA3iIpsb0dhgOGpzzs3i3e6JcwIAg/5Xhwged
	sIyhW/b3HkwOX6tSnYRK+tqtS81cA5f1XCiLeGwKhdIu5lhcJsyNT+Ak1lGmqMsbmT8Kh4
	yzM++eMk6tJ7mQXvMLDjfu0B5yEKMVs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2AB034451D;
	Thu, 18 Sep 2025 15:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84D7C4CEE7;
	Thu, 18 Sep 2025 15:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758208460;
	bh=e37jPrqR9E8heaYU5Fw0c1p4mhM/UmeLs+VMIVzgSZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dyx37ooMvHHb8c2sv5ewsfpuJtmCBzSabR83O1NgTFpdz8Z/WZ2OJfpZPLSHPAOTj
	 f26qGMh6giX3o7w25KYRJjZZlZYAyKI0w5E4csToLEmUKG7ymqX5vZN4kNtOYsYJuK
	 aZiouhU6Yheg0iQC0Kqk/TbZpTdCBCJde0+fOjJONutiDEGcx6nB/8KQCOoBrM62Ex
	 ucKITNtFN4+nAw1QHFF5cbsY2wcvDQhIcOpoK14AEFv1j+ymWVNhIR2tgVKTv4pbxf
	 FsrwjSN8lBpLrKgUDlWA0P1+wfg0R10wopAEqZCgvdRgEsox15caWrQjvlsmO/FROT
	 3hY+hk1liNTfg==
Date: Thu, 18 Sep 2025 16:14:12 +0100
From: Conor Dooley <conor@kernel.org>
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Cc: linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Ved Shanbhogue <ved@rivosinc.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH V14 6/6] dt-bindings: riscv: Add Svrsw60t59b extension
 description
Message-ID: <20250918-hamburger-dyslexia-4f28f632ba2e@spud>
References: <20250918083731.1820327-1-zhangchunyan@iscas.ac.cn>
 <20250918083731.1820327-7-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="FffgZ+UbWyVNp4c4"
Content-Disposition: inline
In-Reply-To: <20250918083731.1820327-7-zhangchunyan@iscas.ac.cn>
X-Rspamd-Queue-Id: 8C1BA20013
X-Rspamd-Server: rspam05
X-Stat-Signature: uafcj1hdrsh4y7w4aw1akjzzjn731iy9
X-Rspam-User: 
X-HE-Tag: 1758208461-336576
X-HE-Meta: U2FsdGVkX19fIZi4ZkzDvFbDOny2DF9zLnxj+rELBmkuyM/OyWkgjtaJMNYZaffJiJkrY9WWSizo3I4xeWFNDzfNBk7VsDTJEklQEYVMN+C7MNQMd96ZopnpliYVIg1lyqiRJTbuSM4SzPNF/kFrtp8aDEtppuULTQPGlkMaG0TPmQpZnEqZWVGJXLBfsfErkdKVMAomi/G02K3/fj85gDL2CnMzXxbRgaNQ0PUyTzTF/t6gBYaBT/ihBhn3hTf85vuVYFoXHoYpUnePcjTGDX77FQ2gXTQtEHKEiahcjhOD6bK9XpxEbCyjge+0VoRy77FiFDSqFWrc/HqdteuLs//KSRDxq/r0L29zjgBo/u+tDvovFEB8lGUyI7Y2M+ztiswRlT146ROK2yr3lIxasO5eK3dVrRLEvEWaFHvUkU0H/8gQbvX3bZawy6cMyZqpQLGlBYdKVjUpll7pIJ16ToEiB+pMLhleYcBQF81oUV8WOMDvA46R8Ue/Tg5fX0cXm5eDNaO3oC3G4bc1kbYDduJURx2X0qrX5FkS+/OxHDRjYpnEVwRX9qPEk0mEdHERX6A0RNY8OZNVYslgth9dOna3uPDgdo6KtDfdfnp6Evt0bachye983bMXBZv46yS+xTQAtHBjoHdUOStCtA0oahZwUvKACwOL8XkrhIe0gjUnNYvwgCLDCrCjz2kKqJHelAS8loObtvt4ASgQHmi/MsQvsahFHHsYLPu/FhCEN8eQmi8AVBSOrX3FGL30Khb9JY6PhZxEUv2B7sAKTEyo5QBf/yE6QGliso6+F9MO00WcPPLzDxqZYgahVGsev/MA1tGmKVdfZEACYZKPIDX2r9umuL4Hxa/d+cwEGbO72CuycfJA8zkXj4faAWRwlb6UQbHX0ZUUwGIdCBGeH4B+TEBL6IL2V0aWDdIN/xeBRu8DcUFImYXCbpOYvjKyv7c2YP1vNnzppTluyYYj2ZI
 DcGvIhFj
 j1URQCZ2u2lcCyfijkfzqaVs6iXeOldym04W/mIjYhApUJe3+BzEueslaB2FGMOtL5+n72/AW81ngLujNn5yAk9T+4GeGp3s2Jt/n5e92TAxzynd5kr3XnhBbhTOM1LfbxZlux/ONlGF+8Q7fBe6na/pr6yIrcrjJaDwqMPuvfyV9f4ojFpAUwdQcSOMgJnqzzsVQaptpiwTjliyoVlsAjcK04pW7VhRTkwc5JD9F+DYWsgJQySZ0Zs+LzoxwnI7bMq4jkJvauk4APvfxmTTWoOhNCltSB76DUYBTuUsnl0kcJPgNmq1trRbA2soQeHNkk+TM1hG5jJik9vIATV70uHDI6DGod7OkGC0CUPFMzDEm1s8CPSkKDMCxlT6fFVBDBByQbBf7DnNbGAH4/S2aeEitKogg9l6LSNhVsn6Dq0cnpTEjo/3urbR3TEE429mzwySsbuMf9WIcEmA9Nz4c1PFdzwKjZuR3SRbl1d9FvZm9Lz71NERbnU92Gft6xJIS2xtA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--FffgZ+UbWyVNp4c4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Acked-by: Conor Dooley <conor.dooley@microchip.com>

--FffgZ+UbWyVNp4c4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaMwhxAAKCRB4tDGHoIJi
0iAsAQD7ScZJcmETkRnAWwXKaeLSK+AK6nQi41/FAWzfFHlGdwEA7piCtUIt1/yB
fVjprhuNZVfc3qSe20i1DS2O+/jVCgw=
=VlWO
-----END PGP SIGNATURE-----

--FffgZ+UbWyVNp4c4--

