Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 312B7CD6E4C
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 02:01:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC2FF6B00D9; Sat, 30 May 2026 22:01:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E74626B00DA; Sat, 30 May 2026 22:01:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8A1A6B00DB; Sat, 30 May 2026 22:01:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C95406B00D9
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:01:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 30030160BBD
	for <linux-mm@kvack.org>; Sun, 31 May 2026 02:01:04 +0000 (UTC)
X-FDA: 84826062048.13.ABA54FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 336E0A000D
	for <linux-mm@kvack.org>; Sun, 31 May 2026 02:01:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kTyrgpdv;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780192862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DfKxkGTv8SgxNfKI+1PVKR9pWP6VWfGRSXWODKg5SuQ=;
	b=fhJfsJRC0duIxsueViBZLdD8nzzkNhTwYZLS3AyxtCs4tPaMWzM9sXHXOl3Kbj5YkFuf16
	GUvEmZc6NPzlNmv80z0QryTFbFfEhs+pZFXYZeh+FktkROPp8nxofSzUjqWXH2udIaSyUL
	7oQrjY9UrYJkrDk/43ha4Bis5D/0Svw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780192862; a=rsa-sha256;
	cv=none;
	b=5CPXWlWSf7XNGH0ffBF083a06Sv82qR1dby8XblEDUvSy84E3XMMOduJR1cM6lm0V21f6d
	koounON44ZQJd+nlpznTIzsDHEck4e9NLvqohbdR+JG7jWMDAME2p7rb43TXtGQzrTnwKm
	q15JUF+i2khQXgntrvKGozvDBNgR8b4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kTyrgpdv;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 121904459D
	for <linux-mm@kvack.org>; Sun, 31 May 2026 02:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F2B1F0089D
	for <linux-mm@kvack.org>; Sun, 31 May 2026 02:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780192860;
	bh=DfKxkGTv8SgxNfKI+1PVKR9pWP6VWfGRSXWODKg5SuQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kTyrgpdvFxPfAIZupFbuUEBBacngoo8dusMFWXFn2mhs9IqS0PkmH0aKHGBM7LctT
	 rrYd49sPH0wmQVKwhwdUlzhm59aBsuDzQEljAHTphEYqVpVrO5c7aigOBb+7bLW4hL
	 P22kOAUnJwQXr7ieOOOKpjZ70Ja4c+cFZLhFrIqzKjUnrt6BZLEjR4mSBzEryM+aRO
	 1CJQZBqaiyh/fbYTju/sCLE1sqZmSzZ1hLZNRsnxW9B4A4kwbBbR1+015YkWuVIyVc
	 6j62WPBDxBgLXOAeEHWglaNNQxaSJjF5ayWAYIkzDX0nirbPHFY34ghsAOPNk/H5W6
	 W+6YXFgcUpTzA==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-914b5f85129so772784585a.3
        for <linux-mm@kvack.org>; Sat, 30 May 2026 19:01:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9B4Kg/wdc/SOkkc8zTalVlvsL9D6JdiXMBgykrCaslvfHS8J6EJq8xMQ8BIl6oEcoLFc41sqgdHQ==@kvack.org
X-Gm-Message-State: AOJu0Yzaim0EancGwus9WnUiMc2FqEgilyNmNWgtTnF4IPpTaO+mQgay
	5mROkAxoXF/cDYVDAiaC6Tuqz/NQfSBCyzxn5RaWyOrzXsQrMBFgsGeifJi9DLfG5Y1f8qSXgrE
	eyUIWw16rNXD/vHSijioRluNadPuih0M=
X-Received: by 2002:a05:620a:a0d2:20b0:915:3542:ff72 with SMTP id
 af79cd13be357-9153d975b86mr596576685a.22.1780192860300; Sat, 30 May 2026
 19:01:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260527115930.3138213-1-haowenchao@xiaomi.com> <20260527115930.3138213-2-haowenchao@xiaomi.com>
In-Reply-To: <20260527115930.3138213-2-haowenchao@xiaomi.com>
From: Barry Song <baohua@kernel.org>
Date: Sun, 31 May 2026 10:00:48 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y9E6GqiEDSXjAYcbLR+pdnkU0dO7FOKXzO7A3OsHFy4A@mail.gmail.com>
X-Gm-Features: AVHnY4JtJBzAiF9leI5aqRkaNreKfFN8AhgDihjdhWed0daDwo4kNGIcQbAOGl4
Message-ID: <CAGsJ_4y9E6GqiEDSXjAYcbLR+pdnkU0dO7FOKXzO7A3OsHFy4A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/3] mm/zsmalloc: encode class index in obj value
 for lockless class lookup
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: scc5dfth7c4oteggefenh5py7fzok7tp
X-Rspamd-Queue-Id: 336E0A000D
X-Rspam-User: 
X-HE-Tag: 1780192862-215684
X-HE-Meta: U2FsdGVkX1/P/deeOs2aG03oruoaVoIKNvqJoFkjwuKagTI4J4mrpPIxsNNv9ZAkXVMIPm5oaYd1dClxj+LD17NJzwzq3+mo3kEmAhwO055SbYpsF6UGBQ5mT67rsSW+QgVB4d/1364qkrYrC9kJ4LoYKBeLrejstgqiD1q+6af2XWih46sCCPOYOGviszM+QhuKyxJftGZGm55cztyAFB511USA/OvaLEmqMLPymevYX7CGPn/uf0ehqij+7ATbpB2Y/ap68b8qD+QBPw/sJPaEHhqXVohvhgXrSE7AQc1jgcoLTnKaP1rBtsrtNEISulgcxsq49kWI1LIJ1VExBCiesFmVmWDMiwe6DCf4qdTvOcyO3j9HbXpPxizxbfuhYB8VI4+sU967eaqUbRXU86xk43975aKirukYHRgDAu0KPwYY01531bx2Q8oVDL4uQ8yJvLpQVDN778hU4N30uYBdmBRLZHl45PW3NfQfjcR5EsgZ5yPi85daBSTx6yQbEW+fGgWBBPtIL28mym2kPdDtZ/2kbMuYwtf2/dV3cXA6MPLWybtEmhJWQoAegX5RTCKI9S0cB9zFN1GAiTPhus++Wk/G6HgxmTIiFE1MuGnK0MiDFYKGwjskbGaFNATfmqefIot+VUgdFY1XN8Nu5xCEAksr7BvkGacCWHij0rWcz9D9kQKe3inv7zWQdEFzN9OU78u5qEIh/oM0UEBPLxnMOBOKBJ947TXnvM9en1NSzO2IuBGe12RwFkgln3J7oG9vp/SOAG5SChGqFhYeofzo7m1qU2alW8n/Q/ulRHzCrUHJ4x/t6L3wF1TaL5cCMp0LBRsWpoBvqyPJ+0YH8+m5pu0xdnfA2mTVRYoJm47FrEqFl/HY2krUGOLwSyjfW/DDMLOQttFl8BHlKNBmyY01gsvDwVHHKHgdrgynobGG3OSgFI6W672qrUMHgLPRz+vHD81P9yCvXmOdMb7
 qxF3m+Yx
 Bbz8g9+lGq3tn29xEBR7Xj0PdLoYXX9g7ITqmkSaWccq0Cs5i164mmv9S9KIIdapdsGr1PvHIPHojr9jOJtuvwdzA+JYgwd0hPV3nkZz7it3gIE9Kyees9bwBhNl32stkb7Gk7bMSkGg4SEvkckWRTLErxqCHBMWh7KH5Z5+Mm7tffdWhPmOCaMjC/33cvteP6yLLlc+gWL2PbRZq0MYye7/1vtEtS2o7Bdxg7VONwac/DYxnjPSYiE7mWzBB27XwwA2cJOIc74dPKg/HsVa4Zml35hTEAiY7J2C/JBIrHeK3e4ikDTEGpkMwsJ7ELIeZd+i4v4zJh0nUlvQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 8:02=E2=80=AFPM Wenchao Hao <haowenchao22@gmail.com=
> wrote:
>
> Encode the size_class index (class_idx) into the obj value so that
> zs_free() can determine the correct size_class without dereferencing
> the handle->obj->PFN->zpdesc->zspage->class chain under pool->lock.
> class_idx is invariant across page migration (only PFN is rewritten),
> so a lockless read of obj always yields a valid class_idx.
>
> The space below the PFN field in obj is over-provisioned on 64-bit
> systems, with more bits than obj_idx needs. Split that space into
> class_idx and obj_idx subfields:
>
>  |<-- _PFN_BITS -->|<-- ZS_OBJ_CLASS_BITS -->|<-- ZS_OBJ_IDX_BITS -->|
>  +-----------------+-------------------------+-----------------------+
>  |       PFN       |        class_idx        |        obj_idx        |
>  +-----------------+-------------------------+-----------------------+
> MSB                ^                                                LSB
>                    |
>                    +-- ZS_OBJ_PFN_SHIFT
>
> The macro layout changes as follows:
>
>     Before            After               Meaning
>     ----------------  ------------------  ----------------------------
>     OBJ_INDEX_BITS    ZS_OBJ_IDX_BITS     width of obj_idx subfield
>     OBJ_INDEX_MASK    ZS_OBJ_IDX_MASK     mask  of obj_idx subfield
>     (n/a)             ZS_OBJ_CLASS_BITS   width of class_idx subfield
>     (n/a)             ZS_OBJ_CLASS_MASK   mask  of class_idx subfield
>     (n/a)             ZS_OBJ_PFN_SHIFT    bit offset of PFN in obj
>
> On 32-bit systems there is no spare room for class_idx, so the
> encoding is disabled (ZS_OBJ_CLASS_BITS =3D 0) and the obj layout
> remains [PFN | obj_idx].
>
> Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
> ---

Much better than v1.

Please make sure that the From: field matches the Signed-off-by: line next =
time.

Please commit the patch on your machine using:

Wenchao Hao <haowenchao@xiaomi.com>

as the author.
Then git send-email will automatically generate the correct From: line
in the email.

