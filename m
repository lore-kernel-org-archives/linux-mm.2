Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D44DCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 23:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E2C68E0005; Tue,  2 Sep 2025 19:09:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 693528E0001; Tue,  2 Sep 2025 19:09:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A9A78E0005; Tue,  2 Sep 2025 19:09:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 479278E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:09:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC8B385943
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 23:09:41 +0000 (UTC)
X-FDA: 83845854162.24.39C0365
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8D4C92000C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 23:09:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=canb.auug.org.au header.s=202503 header.b=PLcdi6Xf;
	spf=pass (imf13.hostedemail.com: domain of sfr@canb.auug.org.au designates 150.107.74.76 as permitted sender) smtp.mailfrom=sfr@canb.auug.org.au;
	dmarc=pass (policy=none) header.from=canb.auug.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756854580; a=rsa-sha256;
	cv=none;
	b=mWcZgrE5HWTJsyyyPjv1qx+2o7x+ey4rjvtzIpQ86Pe/2dX04/bYxu/mbNWYlfAlJbVZK1
	PVK85JFLVyaa2XZD6x9Bq42KgO9eTECY++E7/b0N+EUYts8EOFv8U4yuW94pwchyvmy6ZN
	A9OGWGkhKWc7GUayWM/6Ouwz0TWtyUg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=canb.auug.org.au header.s=202503 header.b=PLcdi6Xf;
	spf=pass (imf13.hostedemail.com: domain of sfr@canb.auug.org.au designates 150.107.74.76 as permitted sender) smtp.mailfrom=sfr@canb.auug.org.au;
	dmarc=pass (policy=none) header.from=canb.auug.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756854580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lmd19YEM6DwJTRO3boTZW63QHXm1N7rR6wiqw+ejDUQ=;
	b=msSYIqHKBrmiw07dkoxmnbnVeB+sO8WPxQl97boQl1EIdw7ugIzyhHHmJQ5S5NQyh3NNqH
	ZQG5wO/mnYgKWTPKgYuptHjf+oc5l+nO3tqOMfjqEejjAilgca49Cx7PMzDHdOYvcsPCZe
	FccMd5oC48Lt8H/Um7Dmqlf66THXfUg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=202503; t=1756854576;
	bh=lmd19YEM6DwJTRO3boTZW63QHXm1N7rR6wiqw+ejDUQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PLcdi6XfnW7YUKeGYPwl38hmYQAlCEWbwD3AW+D2Ojsfajd84Mu7yu3styXm/xE3e
	 o+9OWx1HbhCnFuCd7GA+SqCJSPTNRd9ISdgrl7mfa9T4jpPDilAmsGl3JlIZKKBfJm
	 Wnkr4ElhuP4cxcKrcCwoT+L61dJJw7UryTZXyfib6mc4NraQMXmHN6VJkYIDebHNZU
	 0AHgChNxAilkoUWMElFJPBY8kuLqxghLLT4ujw4k/dQd7pzBt18ooezsdiBc7m/58Z
	 KE2aahQIM/JbInVC2FRcaF2tPSeqWetl3m0vaJybwvhrnnWFhijoj2Kg+pqJetJMb1
	 /zczHoHTqJ3PA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4cGhJv4fYdz4w9S;
	Wed,  3 Sep 2025 09:09:35 +1000 (AEST)
Date: Wed, 3 Sep 2025 09:09:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aleksandr Nogikh <nogikh@google.com>, david@redhat.com,
 joannelkoong@gmail.com, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, m.szyprowski@samsung.com,
 mszeredi@redhat.com, willy@infradead.org, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] mm: fix lockdep issues in writeback handling
Message-ID: <20250903090934.4b5479d8@canb.auug.org.au>
In-Reply-To: <20250902154043.7214448ff3a9cb68c8d231d5@linux-foundation.org>
References: <345d49d2-5b6b-4307-824b-5167db737ad2@redhat.com>
	<20250902095250.1319807-1-nogikh@google.com>
	<20250902154043.7214448ff3a9cb68c8d231d5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/51YENCBeuS5sHhgM6ma6l5W";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8D4C92000C
X-Stat-Signature: ymp14o5skbxo7q4y5o3adacd1w6q7hii
X-Rspam-User: 
X-HE-Tag: 1756854579-142960
X-HE-Meta: U2FsdGVkX1+8c1uF9vBTY/6JeD4p3gSYPwKQ8+9koWDz0xT7dkyW0GqeqYS/ryahn2ndBpYTOvzraYeim1pFj5DGFguQ+ZdYUWHx9j+reF0DkP4np72+CoQI0gWYn9/lt8nA+Hc5CHrxiPse4miopVVKtnyckH1/Uv2Na5Lb7uF0moVOipOyrlQvIswucXcqXPtxbF7wA93amABqiynMKbwJchnRCaRHdcIYaFi7QHz/8SnhA6IanE5LibBjrXDyARIJe9ZJCA9RwUgAM9YOewPnowZMuRpZzpNhK/3ONUaLkTKCQZqVj/wWpet/nQNAiQQmXrRbf2eIRiObYf0aRIlLZFKztROi3LC56guMmu7+gI7Le8vrSYiM1YNAy9HUbBBBIa8R0yEOFSFV7kzqUkd73qiqNXKxBBeKs25HxK7MarCrMGrIJbO9cOGDfOYT9BTfgJdd3jrgtwLudEe3jDOF7XVyOwBB7JXRPZAm3+u3kddyC6G4ejMJcqUkmxg55EXkDpgZptPxSFfmlWMjhYIWm71cRtHG0d7fK5ZLL+VX4F6ezK736CGjXbtXJ7gJXt4GgVZRSzEK34FPRvIIzXiP7A6tGQCXCgdMZkBizRd107N35WJn2r9vW+q5jdg/cItKdP9Ps57KYD2PPORXjq5d+arqU7tpIQrX4j7sn0R8jf4RsvaivT9QduGHfd1U5Ixdj9Sg7EYLzoOyfzHR0mV4au8PuarsC+Wl/AZddj2pQwqsv17F8f6ha3ga9uBD9jlQjXYFLC8wDNW8eX/WPmyxSdtearWwAIAMHjFtS/G7Latcq9UXbtVo/4PIR6LuI3l0VfHysYNQ/U89FPSu9hDBEsHAPaMmhgBB4ftuJ3+DE6rIBLkCVka8z8+3i5k8Tz8/4wUD6Q/nzOeA+3EhQOMFCNJjRLoJC0XaLRhfwSYmfxJ3nKgQPSmZZOmNbYTDu6w9IEhEgJOU6rPPeXE
 ohcgAw/q
 GpNCW0qzL88N63o2hFnecZgcpfvyfYkksr0GLUp2Hzar6GQWCSZkOeYPhOw1ceYW3Xwj+QSfDboXvXxABLS9RSxUfy4QeQUYA2VGlj5+2Vo1sDa7iqBoxvOWFSZ4lV5j/aPyyGh+JWXj8Cgaa9cWROk+BKU76GkiYpVWNJW5Cgb+kWwWRqQEbEUQiCstOPq06OTQ+OFromCaBck2KQW12EMyVG10LfCN+r90opjRrAvAIdUy5+q0YYCV/qI/X06w+SgmkHAgP7Ifvuxz65FseJTiEFfZxgcshQEjkn51S0Copv98ai3O1ffqdqe48p1tsrR1UOz8P/HvzAV4aI7xONzn0ELsyzs6Ld9L5UEXenw9O1+OXQ+JTi+nVshj3rX5ZfLTD1+jcBNd+vEQhLBF3dfM2H9b6Ch/KRiif6RC9cfwNN3w0PBCBSp/yDy21wzSs2oO0ZHHohVWSrSxCnrbh38LjPp3bZwmtDNdKQTPWxjXiNXEwqWJhuXeuFHaOGOE9ar8VJbD0CJsrheELgjH5tUgQ/heYzi5KugHIUzjHfcAfmgIF7EDFDdgDGatK5seff1PhYDKNZ0g9D5j6u2GdgRHeTJct+nlUkMpE6p+mWIXHehBgzTfc95jB06OnxLY9m0NaRnj79v8uD9Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--Sig_/51YENCBeuS5sHhgM6ma6l5W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, 2 Sep 2025 15:40:43 -0700 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> Perhaps Stephen can directly add it to linux-next for a while?

I will add it to linux-next from today (until Miklos sorts it out).
Note that the fuse tree was updated since yesterday's linux-next, but
this patch is still not included.

> From: Marek Szyprowski <m.szyprowski@samsung.com>
> To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.=
kernel.org
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>, "Matthew Wilcox (Oracle)=
" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, David H=
ildenbrand <david@redhat.com>, Miklos Szeredi <mszeredi@redhat.com>, Joanne=
 Koong <joannelkoong@gmail.com>
> Subject: [PATCH] mm: fix lockdep issues in writeback handling
> Date: Tue, 26 Aug 2025 15:09:48 +0200
> Sender: owner-linux-mm@kvack.org
> X-Mailer: git-send-email 2.34.1
>=20
> Commit 167f21a81a9c ("mm: remove BDI_CAP_WRITEBACK_ACCT") removed
> BDI_CAP_WRITEBACK_ACCT flag and refactored code that depend on it.
> Unfortunately it also moved some variable intialization out of guarded
> scope in writeback handling, what triggers a true lockdep warning. Fix
> this by moving initialization to the proper place.
>=20
> Fixes: 167f21a81a9c ("mm: remove BDI_CAP_WRITEBACK_ACCT")

This is now commit

  2841808f35ee ("mm: remove BDI_CAP_WRITEBACK_ACCT")

in the fuse tree.

> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

--=20
Cheers,
Stephen Rothwell

--Sig_/51YENCBeuS5sHhgM6ma6l5W
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmi3eS4ACgkQAVBC80lX
0Gybxwf/Uv3fpc9804shY5OAElYnQfg2+iEGw0IZHoAf6i8/EloaC7OQL/sm06/o
eSck0xYXKM5k6aPUaKC7v6Y990fW/b9GKyQVO3+KVWPEH393Q5PoU01Lazp6LgvE
4eaLnLYlFhlZwLgHtFcVWHEq8BeYjXl/wE/g9UDxOuyZ6M0UXF75o1Rnofib25tF
38AwQf1Vxzptzts2zFyVoFbqL+/PioS0C1OBlcM77DUOKvFCOKD9dFuqNkCm5tF4
Cf5RaO2UcQVFo1KHClvNNzw2dHP2fy81TsDuhG0vHnoEDO+S4bH+oaGjwIyKQsj5
uP8Ajs97yivTnWBOKh5JeZx3JerJ2Q==
=i4KV
-----END PGP SIGNATURE-----

--Sig_/51YENCBeuS5sHhgM6ma6l5W--

