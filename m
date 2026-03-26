Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81EA810A88ED
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 17:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF0F16B0088; Thu, 26 Mar 2026 13:30:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDB536B008A; Thu, 26 Mar 2026 13:30:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB71C6B008C; Thu, 26 Mar 2026 13:30:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA50C6B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:30:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 848DD5D86D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:30:28 +0000 (UTC)
X-FDA: 84588903336.19.FE0A2BC
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id 73A34160015
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:30:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I8gs6lPV;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf08.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774546226; a=rsa-sha256;
	cv=pass;
	b=iw5oNOMq2T0oEDN++ShItHcXsk9xEJMyN0t15e/JWlY19VDUOXHgnTaTmeWhQanslTAkmY
	IPplXpIqrk0CJByK0B0iLhLpZLBcbHoOmzuD4J8WZ4KmwpDlYmgwxK/G+0OsPV2zxP6bg3
	6PQbuRxvpas5Soe/b6L5ccrs5np96z4=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I8gs6lPV;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf08.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774546226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wEHEk0yDT5R/njghDq/hVwJN3s1AoJzI3r+2gD7Cnqg=;
	b=8Z95ZxPz6CGdlNbfA7Dwjgog8h5QhPQ7UgbEoFyKcisRyjCX8M5pLVxYQ6ocFIfShD/GbF
	l3UKvqnMPvLoD7ivd63W4rjzj0uVv+9zdB+eWD4tuWqtTgVlCBvU1lzptTwedE/yrfP092
	mJUI8lLd8zOStbUofcSjtGNR116Fppk=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-127148c2112so102812c88.3
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:30:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774546225; cv=none;
        d=google.com; s=arc-20240605;
        b=kftbezNgbLRx16y7vq9FRrMhdsdsfHixNRsew2tjDyJIwps7+k2h7CDFFgEYd3Val4
         RYesr9PMt70GziaK8vIjv9kRZJeDmY0UpN14ZDBuQGtRz5mz8KIVpinqKn26l6C6RG9G
         i/YEHpRQx6recdrl7iYL2J6GSeyj0v3hjNPn89iC/tySBB2NMVuVTIDtu/p7hFIlqh7q
         Keiw79z75yYM7fydzAFunovwoyimLIyJ3VqsHEJWFhDRhd6UYCWXlC/5oKOIsG7iACjU
         ib68b4lr5C+XCzXPd0MPMjvdtmaFBxldfwaG4zV4JyZQHLz++3YteNwelGHhxxQaLupZ
         +v7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wEHEk0yDT5R/njghDq/hVwJN3s1AoJzI3r+2gD7Cnqg=;
        fh=HR+SFRS1lha3/LCTi++x11jShyjw0wX/s0186bgKUYQ=;
        b=CbGd4i2q0UVZk7MCozcnxUzOLqgmi5FUWF1A7wxTKb/GLEbKPqdaRjAskyDODpOY3G
         N+vRSFSX4QINTWhSeNmw8aAuWH0zGpJNQ7HEPV3PsMbhhJ3avrLsRV3OLOuPbo22dFgM
         MUBQ6PlmVxOXP1/zA8E8rhDdC2oNcLwp+LrWo9J/mFBRoso71cGBjwR26Sv8GYrzZ7Ei
         w1UIXH61yC/OfPvqhkeBJCnq/MtDte+7gPDKa9SDoCjjMKcIYwH6oeZdMM+P5SVGNS7w
         6GcK1TISnSYG/gHk65FKOaIEDyGh1BIE+4lRzuIb9F9+kdT8/hPAgCHBKyMUqjj2Vxkc
         KKsg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774546225; x=1775151025; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wEHEk0yDT5R/njghDq/hVwJN3s1AoJzI3r+2gD7Cnqg=;
        b=I8gs6lPViNiqqCRbV+rQ48ymymDIEiGnOgiriKkqtP9utc+8p+Ia003WOFUJBygapO
         o995aLTlBMujPfXvGPycp3YHkx3/zu0rhu8f7YP3TDMU2fnKCm7nVirlf0ECUtleLsqB
         LPg40NXAn13ZmI+N4fBF0VFvGdGkKhUAZ6jYo0rVlMj7S2hEQuXPKI7nvFlrKExQYnKo
         d8Nzn42UxWmE47xmxDEX3Bm4L8ponO+iTioHPfL/KuhGQcnApFQQ1CiJlh3c4UeaAOI/
         RI9u+NAcdAcQFLIP5rFMVqtKxDJ0dMVXYAwDSfO68LJ9RuD7Z6wmSr0bpTjGW/Vyxqyi
         Fkkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774546225; x=1775151025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wEHEk0yDT5R/njghDq/hVwJN3s1AoJzI3r+2gD7Cnqg=;
        b=NHp0RLGiYK+4L3+6XEXVTCJj5jaRLOiXg8irdXub63ZlvSv9CJ2TAuoO97RboX58aj
         +To1v/Gzq2gMyX2/Z8jsMzVGOInG97QJ7ZmKfleQAZC6RpHroke0882GFp3qdQUxnE/K
         M7r5lbPdakqdt2wQAlM+ZBXc4JV1SaHznyyDcbdSZlY5/Kj7K3g+jp8p8BN+bbPB9fkt
         cjUV/NecMsS0Nk3b3vsqDe2EdgQdQcGVPh2pNSgIjCevV32mpGi1qT+txPvcQ0WikHv3
         19Hp596p264XiNv+MLAyTAa4dMhn4qaULaZ5l50zXRGTPXa7q7LLY1MxwB/HJWSMJKp+
         gBZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXShs9H40xHCFWOHini4T2kwBaCy7rh0rn5XE17I5zbd6l2bZJctl/443LuhVVbGsIY7QDLetg+kg==@kvack.org
X-Gm-Message-State: AOJu0Yz67WQJT2lF6L9UQMy4up0HQVg6uWdGx+fzzOhz1Y83W6ooqMPN
	IuUUotb81lFi57Xdx/eSr2TpPnalbbStdpRGyp12Mc9aQb5vw7cby3UzWTDKfsCZPZ8lQAUaIue
	lz+6q48rlXlCayEJd7ZMMUOddnGfJcus=
X-Gm-Gg: ATEYQzx6fr0C0XCVyuHtR1WXt/vYQuPTiH3AgszUVLA7+utjgCpDRID1HzLsvdkGbsy
	Xs3sG46lDMXEZw1te5pKfUrQVdDW40qL4P0SJvvCMTWzJB2fFaTAF9ogauqsuPMB2MAEnpXjTh0
	v0S9GuyoRl9L4eu/XJnrn2FZgc5hYEOjuvGmNc9L3lrQ3NunpQRUx0nJmkJ5UHqnJRZkFC96pPO
	fH5L8zH0AMKmeBtywGYTa4E4OAhqwkrQOI1It+JSeaM8ZI1J15mWfjfVs8k1O31Z8EMy0AEvzrO
	qHBRh2CBep1ljiSIRIl/kU4FaC3KncTsCxqYNIW2ARV8G1/RRXVn3mmZKLfqF6x4frLKn5tslkS
	u4kWhx0xV5EQPOKnZbgU9gBY=
X-Received: by 2002:a05:7300:d50c:b0:2c1:6416:2a07 with SMTP id
 5a478bee46e88-2c164162eaemr1927580eec.4.1774546224910; Thu, 26 Mar 2026
 10:30:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260322192159.88138-1-ojeda@kernel.org> <20260323000327.111235-1-ojeda@kernel.org>
 <acEP7tl8pqFA3tK8@shell.armlinux.org.uk> <acUGAsjYvNvTEO92@google.com>
 <CANiq72mzPpkELXis1CiSbKUmBXNQYMiMmjj-7-sYiLh4T_JSOQ@mail.gmail.com>
 <9cf5a94c-0f37-446c-b63d-ddac5674d220@gmail.com> <acVOL5Psz6kHlhq2@shell.armlinux.org.uk>
In-Reply-To: <acVOL5Psz6kHlhq2@shell.armlinux.org.uk>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 26 Mar 2026 18:30:12 +0100
X-Gm-Features: AQROBzD8mk75r53XPOqmRDfmWXx9t0jf0bYbL_Ww497XzqV4mLKwGQ6QIr12vEg
Message-ID: <CANiq72=b+cr7Stxph_hXQTmD5crCvwWTqdaGKOJ7W1-66v4i_w@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Christian Schrefl <chrisi.schrefl@gmail.com>, Alice Ryhl <aliceryhl@google.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Jamie Cunliffe <Jamie.Cunliffe@arm.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Miguel Ojeda <ojeda@kernel.org>, a.hindborg@kernel.org, 
	acourbot@nvidia.com, akpm@linux-foundation.org, 
	anton.ivanov@cambridgegreys.com, bjorn3_gh@protonmail.com, 
	boqun.feng@gmail.com, dakr@kernel.org, david@davidgow.net, gary@garyguo.net, 
	johannes@sipsolutions.net, justinstitt@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-um@lists.infradead.org, llvm@lists.linux.dev, lossin@kernel.org, 
	mark.rutland@arm.com, mmaurer@google.com, morbo@google.com, nathan@kernel.org, 
	nick.desaulniers+lkml@gmail.com, nicolas.schier@linux.dev, nsc@kernel.org, 
	peterz@infradead.org, richard@nod.at, rust-for-linux@vger.kernel.org, 
	tmgross@umich.edu, urezki@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 73A34160015
X-Stat-Signature: rs3saj5ibke7ht18a65zg1yi844q7wx8
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774546226-827413
X-HE-Meta: U2FsdGVkX19bTqmPwlv4IXXFJxePrjfhWcKpBQ9m67IGNmQi8a6T727IyP5dxXL8xoTxGTWbxP099Fu0Ua9VTAoENYn2Jw3ldRZqVSPWuxD/gIjnrxIKqD2ZVUwJdbNKwwM3rsPuq0PBp8KPOJeKRQr4mO3DpfWAKXJRhXSEiA9WK0udU2fNSq8Z9TY76IQRZSMGUP3bysf9lOAMHKJYfR/YSrUAB0Qjr7Vc6wvtLUQy5/CidksODMuwc6XIo1h+A5f2iv3686e4lpHmYe5iimesl1DcpOcLNsjeaNIsVH/AZwWRlCIzSTG+xX8NYE+L2IzoAPqZcDmVlodnfdYlfY+U2tuoJjiL3d+UBequNZNtkWLT1FfK5xLeozUnyeY3OcrvDRS/bdaQD3QmmEMapFbVjrdAJWDx2wAomyKSrWI03RFNSfOnh55vdaFL2jX5Rb9uVxOomc+dkoyZ5vB0ITF4CX5uHlo1pZ8qcQoFCho6NSAP1nqC5ct9MiuUz8gpxR3qUm0AXX0maQxnJBQo48asGMO/+MjYFZyw4Uki8S4YQ0q9a6h8uZebFjO0AjVHaOshGnFbo9DND5qWEyeTTiWmAWmsld3Be08TmmXIFoJBzjHOb/ZwUJj3USPe2otb7uq4ASJVc37W7yyHUKI7IjMbJpA6ATffU1YlWWv9AgBajJf7RX78q0eQSH2IjLXdHI78CWxWgDFpo315XQ5uQaBc3tE+54OQznqeQfxfhFP1kn5eTsdBZOGNU47FoTRPxR3GQeLAskfbfYB5r++FKCutzZd9FQrZCn4Lm3jcAtrc8hxAxrg9ga1h9Z9pVJk+L2TGNpc6z1dmEg9GQFfXvdmgbp0JcQUvVe2thL67FyNvXJzPTlu56tVDlA4LuqcFnkeZYjmsvC0xoQBZQPX/6vMIeAtwmXzLHtAJK93SdjEmcFw9y/YeFNHddNG9ajqE++xUB+QaqfWdLAAKxTG
 TbFam6VV
 gV6EJSJFp7FyFGwHr1VK5Ej93ZpxgHtXWYG7gdgEx2Gi+t7xsy6Ws1RGyKJSwp0j6bLpYtlgXcqVIYVmczA0ilbEJR2HOpd0Axffg8mxz1w4DJ2HV3m0IkIAKDOujs96OEam7h+xyDQXSrpP0vLmnEO/xxL3/aet9WklsAIMlWMsMyVP9qwbsPy/FaV/Cf+8vNohJzuKj/BiT8wn3WS1ppRRUYYBTBo+RqrBPMJ1RKbfMyrenCQNIKj9RVw5jMluDvFstqfIUkktc7ItXqpWYo6fJPJhS8o3OvkfwJco2+rcUw/fFJliUjLrFgOjm8CXf11M3FDZbHNgWqg6j6u7nQrfRYedIXTLLc7iIj6WX2PyZXBc87mUaRe2stMaa7jjOI1F/JMTkLRNkzg4z60KtRkBwX8WCPg4WQ43UElAiDuVIrTri0tEhevfW1St+4IXhvGeI3IIVp7hiQ6GHBwuyBJfyKC57/kpSYOFsCmA+WbrsE/UGpLiwFJ+d911o2QPWK/mOlznEQJ83jpUM70aHXlh4TNifE5rgPG7fEhsQn+4khlLx8aS0s2+kbcWR/i8DJBIfiMEAwOLpNWKU9MIda3qdVHkJ5dlXAPkurrSKY3P+iTaXqF2F+YWkI0ZPOpRonxxpgJEQRkgyg4A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 4:18=E2=80=AFPM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> I'm not sure if this is still true, but I believe it used to be the case
> that the -linux-gnueabi target has one behaviour for enums (fixed size)
> whereas -none-eabi, the size of the type depends on the range of values
> included in the enum.
>
> Certianly, when Arm Ltd were proposing EABI, EABI had the latter
> behaviour, and I think there were cases where Linux used "enum" in
> its UAPI.

Short enums? I see `c-enum-min-bits` in the armv7a-none-eabi built-in
`rustc` target, and indeed:

    #![no_std]

    #[repr(C)]
    enum T {
        A,
        B,
    }

    pub static S: usize =3D core::mem::size_of::<T>();

is 1 for that one, and 4 for the other.

Thanks!

Cheers,
Miguel

