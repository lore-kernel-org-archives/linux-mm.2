Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9D73CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 09:08:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCE086B0005; Fri, 29 May 2026 05:08:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D57426B0088; Fri, 29 May 2026 05:08:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1EB46B008A; Fri, 29 May 2026 05:08:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC7306B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:08:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5480DC61D3
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:08:23 +0000 (UTC)
X-FDA: 84819881286.24.5A00FA0
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5DF3F40013
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:08:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uR94ETpr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of aliceryhl@google.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780045701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e745whoSa5vzM90WeK3+bwMAXyaue7z4o6Mvdg4X6Lg=;
	b=UMYJA14QEUCx+fcbYHLGRmKSDjEQvnltcJWBq/vvKHLoNfXBzUWEI0ttNFaelDpy4dBrlz
	5CFAg1GEuKTWvvfcdoUf2kxPWKXBgnJfpIwqfePC0U5L0gQnjSloz3BCdtlfsmK1A6LNAI
	Vo+7foXw9hK+/9pwDpVyvb9fBjxSJ7s=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uR94ETpr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of aliceryhl@google.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780045701; a=rsa-sha256;
	cv=pass;
	b=EtIITXja3t4PQYDqLxTOkSAFzMJGNNVFDx3AhSvM3rSpFUoHeThOLvfqRIJQVRl3kWostq
	mHMJBJRy6unqpYJCG+NM9gw5orTt7K15iWINvkw2oUk1w/Q/5OwOf0dw3bJFRNjFcKHO8K
	6UymTDnIr1R6U6azOVYNNdXWZFIEjEA=
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-304c520fe9aso4842975eec.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 02:08:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780045700; cv=none;
        d=google.com; s=arc-20240605;
        b=hS/Vw0QUcm4KTWCwo/isC8adgAn5sEwVgmpT7SYiluKgcWOnYZRitc+Zsd2efTyqI0
         G/l/RPNmJ2X3HKfJ0/hJJPHlpyHngv81vnxL3PEwAAkyTO70YNNacIXRjQm0OiiMrlk8
         sWPZrR4Zj/bwRUGf2Wqw51bLx6Zruljg2NGTI7uCOcdJaaldR7IvOJzscrQmKevGMtvt
         g12x3ihxPpG2YIPDbSFwHpfH9XKKX1fbJCuZgV3vh7Fc/FmMC1R1DnySSLdo9gTgdsMr
         X2zOKiq4YLjHB1wzVrGmkqk9xqChE5wQPCXIEEevD17q3E5sxpdMTtQ8/Mw/vRDrHhzE
         O1TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=e745whoSa5vzM90WeK3+bwMAXyaue7z4o6Mvdg4X6Lg=;
        fh=AQ4qoSyLQkr/CTj2QlqucAjqqW4xdAhuKf5oDwrlLUY=;
        b=iLADZRXSHX5nbFi3OloY2DLfw2nkw73yqyrAdUsoTfmWgtenrHQozE5dbyXrhzr1dZ
         pQnOWAcEPSEu6wK/oG+tAIhLLMFifQQr6aD6ZG7NeZrFVMIfelXIIRv6h+nDekpwEMUd
         qQJqvi2b2b4b7yeZR1atpnuQu7gCr+BUO0ZyC5dqJNIFjbCI/amXAf0eZ5s4XBJ/EF9t
         bRf4GlPMq9dUm0HPZEvrxdKFaPMrNChJpvpxWx0NYK96lGZkEDbXKaQDVSU7dqJbflSD
         z3SRP4ASnTgbVbN7vFYb+0kdJsR7KIfVtN0vrlcJkfhc32f8ViyQ69ipk4Q4IVUqZj+E
         Q0pg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780045700; x=1780650500; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e745whoSa5vzM90WeK3+bwMAXyaue7z4o6Mvdg4X6Lg=;
        b=uR94ETprJWRSEUHZiGOYyBkCV3fofA0rZWAK2XzQbsCjL1djJmTIhnjsJsg64S9mIM
         XW5kN1b3oPPhbcKJESKtdITtjYWn6ie2e7LrWjI4vcEEh/ZoDCMThVrY9gWlhPVEcwbI
         ss0vREWjXMZ7uuGBMQwnDuuNxL9f1APU+mx9Axtx6qk4UO6I7cntcpUqnAM2rcLRzEyB
         rgjyjqOat+rpIj35pFgiT+H7keOMkf+Vi49sby6wRKwpEyWPH24pkSjVM/h7ApKkBW02
         Erk9TJm8sW6e17pG9FAYca/3pxbC1H27RhA+y/ej3f9jmIXvd1VZA884gvoHaN3qlArg
         7HgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780045700; x=1780650500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e745whoSa5vzM90WeK3+bwMAXyaue7z4o6Mvdg4X6Lg=;
        b=AwziRkuQ3A4nqRuS6fJid7zf0/ZW72DF7hVn+eqoY6pvWMEm7NBF5EIBmfhbymNHVf
         UHZpIBcuDHxe1fBNC9mGelxQ1Za5gU3TNhV/YXjXOALjj8Ajj7a4eR+v5BY4bg4FDugv
         QAst7s/DkYkQRtZR4gpZs0P0un8aL7S8LuaN3rePkeUoJKpG7Zmv+m8B62YwfWsdqUHc
         8gU+oFB7TaULHyB4/Kmr/SwTPSFgKjnfogvoqZxvgU+OZofOOIoVmZYi324Fw2ZYycRm
         SJxzOI5j+30uemMZNyujav6NsZPm4I8BIz3viLUP2Z22pvtw+wQUkEw+lhfDjp/2lI3w
         e+/A==
X-Forwarded-Encrypted: i=1; AFNElJ919W285IOhEFIe0p4cE4qly1HC+qkRVlXnMMXAF2ounReA5RQI8uoVCidIQhhXMJxXLlHzX/Qhkw==@kvack.org
X-Gm-Message-State: AOJu0YzgmLVaBZmHmTqZN5kc10XGkLtjH6dvTX/920YNqgYYaeVciVjv
	oI7kKixWIGvcZBNR06ibj+5RqL8oK0Z0gZFAdz4+2QGw43WJ9uK4xP57l6fiOHI3uN8bHEW0b5N
	LcTCzb4+yFMPQerNKHMcJj2EZgfMgxkSwidoLgPl4
X-Gm-Gg: Acq92OHGaRnpJzIIorlv3bZRRk8JLnBku4PvBqe5s7ld8oUzXSTSl/xHLTY6NIOOoEG
	3y2hdcX/V5EFCaiRj5LT9+5+eo5DHq9qnognvLd4zQ5IXFHNsJCbWRhSrFDEN25PeA5Dun3YppL
	R0dUThdcl6yQu4fuSp3EbLG0irQY8Ij9G56q/Y+nwE3tbtkTgpzT+y5JaEubKGf0u/fd/FmCKsX
	pCCxDM5TYzLDiWSsS2imBLAixf2ZlPZlhGFFwkzZNCikd4Kef+hjjzwfH6q3I1O8Etge1OBaAzW
	yYaDncL7sMkjugfT1IgmOQmoEs7kE2+nJO6ZiiZ17+gqgIdSH7jMAC9IOPItWOnAKh84pyRN/J/
	eyOU3
X-Received: by 2002:a05:7300:1892:b0:2c5:b23e:48a6 with SMTP id
 5a478bee46e88-304eb107726mr814082eec.23.1780045699362; Fri, 29 May 2026
 02:08:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260529085316.27432-1-nakamura.shuta@gmail.com>
In-Reply-To: <20260529085316.27432-1-nakamura.shuta@gmail.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Fri, 29 May 2026 11:07:58 +0200
X-Gm-Features: AVHnY4KdbqFop7gAUoSFk0g3VT9LHEluTblKAcqrVk4AKyd1QN-AOVNxjh-_9-4
Message-ID: <CAH5fLggLuiX9_Fk+dc9W=tW3PYkUvAWmBPTnN4Ht9DaprdDMYA@mail.gmail.com>
Subject: Re: [PATCH] rust: page: mark Page::nid as inline
To: Nakamura Shuta <nakamura.shuta@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5DF3F40013
X-Stat-Signature: i9c751d73gdbjhr4y9nckdb1epwczs87
X-Rspam-User: 
X-HE-Tag: 1780045701-774559
X-HE-Meta: U2FsdGVkX19mm7eOMCTaCmI1Lx7iTn8h0Ky56TWI5izFK5xKLJm9/TY/ObTieTF2MBRdBhf7mtZ4lkHZdllKpYqPOdpWyJo7YRrl32cggV80u1MQZG3gj4c+uYNtHMRQXcxp3EQprEv8wqMXcwOgerpFiXt2tR5ciHXBLp1TIfxb5p/IpZkEyMCZfz1VDO7blWhZYGgGikmuWno1G/zXM0jthmTf+oxo0S/nU4C1VbxvU5ysqSw9CehXVMpqZEEFvoAD91Gnb3d0Yc/LA3sXAtdTlPYEzysT0/ZHF8emoEVhkMy4GMZiZbgeDVo7kQ5bMll/xO3+IcBf/+mBkjWxfvoQUAqMBv081HzMaMlkKr5Bj7VsTX9dCbnDmN2YKQ/N56W+k1Ia4PfGlatpWcxCMe6EoDeZXQM6oCS77HTYEhDtwHlv+5mMyOAQ0iNMScvQK/O1cofySq0TUOGUhBzp3hlyr8bi1qifT3mhm9hNPauHuVUgKe66OChnMGbZhIFr+oJPgzpqVBQteYEPz8VFcgfn1bW2LvtBqvcrINVpvo9D8GQkWLZOxOmcASPdkBnnX1Qo7G9Nxu+CJ2s/4iNM4zjTNVY2UW8/k78jDIDL2N3prVKW/jakmCJo8lXvQ0vFTQlQkdQp78/Q9H1nQdgcsmgFWmvuZ7MEjIYpT5M9CcVAUz23lQj8/yjdYGmQjUl4yKnADvck2kkEC2fKpY57lEBR6oW33dySPyWwlaNvcQxyOmVl95dpuwsJCesh/I7Ry62QMz0bogYxHa/maaAX+vDDVTgcMeCXQxUKplmGZA4+XXUVr4ADJjb58HPBqCWebOVLbI92PihU8th07CHDVSZg5hhKhqW/rL+wn8w8zOoBxdn59EtvYN0zsXLpDJ5p0e+/b3m0zYDAC2DXe4hIpw5uuMU0qQUEf+5aKJjhDj6tcGPhLhFerdoply1sNS8iQ8GOBrJJatvrtUQQjUO
 9CrV1fGK
 ve3yPgxKthRGIKsxa22GFpfhWE89j0Y0DfSeyNBU/HuL7q9ByQEeOO7vAYUo8JUaouU+z2XAkQXbWRXLU0L1FGiXANeuDV6gluC/E8Jrm+UGUxiUMn0F/95aaYH6hktHY0SVEXvJkuLbpn8FZjY7+zmEF4YNugB0iXeSiT4ewOteJSe201NjiNEaLJD2/hTvKAUyp3P5KJQtve4cj05DT10aW6PGVsnqlOTcKVYxED/juUz2kP9vDnsg42O4QSBK19YKTRWNo9K9v7g0OOATjVaOoP0X7po0aeyu8Gq68/bGRLL2xTSiAkdTPPac5o5C4Z1X3VZYSjgUTz4eqq0IAwz1E/tTo89fVjiVsFOvIBbQPMyRPR/0rF2nGMWq7TOEkkd+TnyTWs/rHfjS1IQSH4IFMClMgMXAnRZtpE9oq77/pUIL8SeCBmGd+lTbZYMRXTQl+rqOY1Go7wSk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 10:55=E2=80=AFAM Nakamura Shuta
<nakamura.shuta@gmail.com> wrote:
>
> When building the kernel, the following Rust symbol is generated:
>
>   $ nm vmlinux | grep ' _R'.*Page | rustfilt
>   <kernel::page::Page>::nid
>
> `Page::nid` is a trivial wrapper around the C function `page_to_nid`.
> It does not make sense to go through a trivial wrapper for this function,
> so mark it inline.
>
> This follows commit 878620c5a93a ("rust: page: optimize rust symbol
> generation for Page"), which did the same for `alloc_page` and `drop`.
>
> Link: https://github.com/Rust-for-Linux/linux/issues/1145
> Signed-off-by: Nakamura Shuta <nakamura.shuta@gmail.com>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

Andrew, can you pick this? Thanks!

