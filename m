Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE1C7C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 18:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFF666B00A2; Tue, 11 Aug 2026 14:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED6686B00A3; Tue, 11 Aug 2026 14:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEE9D6B00A4; Tue, 11 Aug 2026 14:21:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5F0F6B00A2
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:21:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 53877401D1
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:21:10 +0000 (UTC)
X-FDA: 85089805500.14.25A50D7
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5A23AA000F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:21:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qRr9CSih;
	spf=pass (imf15.hostedemail.com: domain of jyescas@google.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=jyescas@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786472468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SidcrzD+3N4Z9gUfmMlCvG/9oP2syRc8UCagR7fv1Mg=;
	b=T3X6B1jOKTxe+WeopubuaucQeVBIoGEHRgs4R038G2u3FfSKOnvfUBcpH64SBJw8+w3QOH
	vYyohNgZuF/xHDUa3z6znPgKAzZZjHipfcv9+jidjYJvcaPXL9lMFpMjjW3pA+nd7v/RdQ
	4ZpkToHVk3kevU2H1gt+nRySIM/83V4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786472468;
	b=bQ5GQNKrK1Rc8Mq5FCQa4iFQcBpyS5vrywg5E7/bMkyW4bDET4XRka297VUFv6ErZDUXm1
	FSn3dAjhgDUmgDJQt2CpD7gusvcQsAq0GA52FeC0Jh/oLdEjJs7at0CRtfM8W+N6Njf0GS
	XelX+0Z39n/W4HbpkQgc0n9U59iFHA0=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qRr9CSih;
	spf=pass (imf15.hostedemail.com: domain of jyescas@google.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=jyescas@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5b2a73da7e1so1068e87.0
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:21:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786472467; cv=none;
        d=google.com; s=arc-20260327;
        b=hxfL9zNb2Ia0OwC6VoxDFmiOL9cKH/Rz0TlvdPMM5pfUYTxnOAA5w43T67XJxbIdx4
         AncqMAwWnwzN5UvBpc5jljdvkc7T3ZVS0P0naL3GdZDaf2Tq6SaWkSKf8xqs2KbwjHij
         o+H5kR0mU9j9WjTrwULBJUK90u0Uzz7DnAwInCVXcrtyD1hjQG9uRGzcHKz3HD8vM1dY
         xF65ZJlA+RhSxgN3tmy3Uoy/nd6dtllkpOUCIXpjDPJuCOe2t+iyK5lURsUdsPzTaXST
         mkA4RieMVr9rxPd81YMUq4qm1ef3bL3dak+nnZzLN3j/a2j276EzJ1B1DDcCz+juy0Pp
         Epxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SidcrzD+3N4Z9gUfmMlCvG/9oP2syRc8UCagR7fv1Mg=;
        fh=vYmebGit0g2QW8i/gK55ySJqlYuPY92p05jnC5TBppc=;
        b=Y35LPTjmPC2K7E2/q98UsAjoEyn3XqFw9MibFHtK8oGdELtn0djiXQOBhJGkSS5Qe3
         qkm/JJnlS9F241SezhXNusqfbg82Yuc3pG7NEVnq7EZSFSJIC/Urq2vZ3HqdyXiRZhgv
         2Hu0i5W1eXH4x/9N1s7cEXe0MNzXrfGRdBslkFM5t7M2f7jYmb8fS/UqkFTDBykuJFqT
         yUBG3k46JTy9qrAoQ8cG7DM5nnT8TPxEan0Ikxef7llOy2IiNmjQUKZVAngi/sCtd7S7
         CvKqmFyi7MdkRdCBx98r6IF2yjj+Ja//PNlC0TwIw9+fVg0EeZe592euPzmz06Mi0H0i
         hfgw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786472467; x=1787077267; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SidcrzD+3N4Z9gUfmMlCvG/9oP2syRc8UCagR7fv1Mg=;
        b=qRr9CSihUHH42neyT3vXOlEw1QIKvialkrYFsHMGYqmKi/R1FfOvMH4C7ZEg+/+Ir1
         J5QUfkLayM9yh7BUN/nHgY9Xy9QLeAxevNid1DPHjo8JLEViYneV3MRs29RjPul0JWjG
         Mr2SBoIf1yPHl2RpRGBW9+/jt0TyjNZPxrK322P2a6FVOzfM/QAa5Eiw/LBq9eX3BdhV
         RrWmbPZElmSJRPdvgZP25p/BphTrQo5+/F1Qubz4OLC1YAotiuWih6+p/Oby9xHY8jS/
         sCyVD/Y1CTRBrs/JuUHAJsRZO/dimo+rdIIi4C5nbt0GV7zdOPbEBSa4vxfVS5XR0aIp
         dURg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786472467; x=1787077267;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SidcrzD+3N4Z9gUfmMlCvG/9oP2syRc8UCagR7fv1Mg=;
        b=c++r7Y4dK7HbVx1ejovHGaV/xRkOFY91J+jHATEKG083CzWELTb9rKF7xN+uHql1Kr
         yzF7B/xiM8zr78FKcU3JmNjtdXcA4F3W6Qd2vp8qlbUU5klAMCK2LEv50T88VC9B+YYX
         CbZFG5hN+26RMne1m04CUJvppzhcdJQmy7qMDVLhFnkMMWw1bF39h8C2wc+mtPAeeCit
         u4TCB7C6RbMAN+D3thNyzB3Veei6aJhv7wwgOobNRrGYjltF2DEs0IsFLc1p7PRMtdqe
         gFpu/nesMZcUoPg/Gs3fu03qprphWGjpwzNeAaGcWV3pvjgmG5ZhnWblgimB+MshHjNA
         zOpw==
X-Forwarded-Encrypted: i=1; AHgh+RrUYdrRFwmJ4FUQ4FWPAndhxU8YYmWkDYcj+o3Aj2AoPsYAfU49dJhdOPmHOnVL0hlWLwaB8aofWw==@kvack.org
X-Gm-Message-State: AOJu0YyHhf2ycdNo0UMFkUIzVRHVryxgw4Rxi3cQ1zQ20ABZldYx9YGN
	YamFctt0z4Yi9fcb1TIEVa3b/q+PUckbeW5E5WjQqeCAGjaWsJjszimXE61AG8TqH812IAn0hG6
	Ed+EKZrcqB+JB/KvJEUJat8nEW7nl7DnD8i4idDnw
X-Gm-Gg: AR+sD103owEexYd9KGGoFySuKUHXtuM3NzKwhOya+II0qXqKoLvivRaWOXwPfKNFmJ9
	tjVyNUZuNjYnzovdz9WgDXiD9eZlN4z51RfJmIh+bL6huGKxE7zBUj/jjxNxyvtq1TmIvDdDJv8
	fGM+6OpX4+BSlznwqfQBuXZkK+Ufmkn40KXoPgkCKCZ/q8rVeeNx/dzde14TY2kGBZmjaiilH1f
	ZM7W0g1FNHArJuoKbJRnzL0/22KFk6dG4Nrk0eWi3SO00FXUlU19OaVfJ1CQ79nmTb9+2CBc1tW
	kWVS37d/vmLdsj2a9ta2YhL0V51xVncJv0D+lWxE09YnYcXACLYn4o6TiHT7kmXu4vIxgjTcGGC
	lA2g=
X-Received: by 2002:a05:6512:1089:b0:5b1:5141:9156 with SMTP id
 2adb3069b0e04-5b44d13f5c3mr18608e87.9.1786472466176; Tue, 11 Aug 2026
 11:21:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260806011048.517229-1-jyescas@google.com> <anRRLwa3N5bVCHET@lucifer>
In-Reply-To: <anRRLwa3N5bVCHET@lucifer>
From: Juan Yescas <jyescas@google.com>
Date: Tue, 11 Aug 2026 11:20:54 -0700
X-Gm-Features: AUfX_mzTwRJlvsI3r3fWSCJukfVrB8EoJ3kv8vAfsnBGQPoCIaduX5MiWIoM87M
Message-ID: <CAJDx_rigKu_kwWCXy4dUNbqoA9b-T3U3Va4QX5-4=zn9yO4maA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/16] Page Alloc Hogger
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>, android-mm@google.com, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: etawx8zq54yeqwnbto7zy67wywraecky
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5A23AA000F
X-HE-Tag: 1786472468-405855
X-HE-Meta: U2FsdGVkX19XXQv9mCcTc3cTEN6844xFg/vem+TXj70+BZFoHDUxi6gk2ojN8WhcvscZQ8yGNK+hihKn2F17JaDoTl4ulyGM/iIbPBUvOEnzbF9rCZ2W21DYlrE7VrH0h2t0bIfNkOGW4XkqseGEEziZ7mjL6+JSfWArsPzGu0/8Nl90J89i1YT6ILd5tP0ZE0GnlR1+5IetipqYs75j/w6SM0zjjW98p29zdhcDlS8HGRdcemKu1CzBstpbD63wngYRPx8OGzvNowf/Td+s8YgbN3gX+5fkbamhGLFEJLkCljV6LbYO8cX9SE8JOWuEiYKJLPax/hBTps/y1r4WqMDiPiVYGZUS7E+/B4BWf2lnw8KNwNO2IG5ZgJz8ySgfbfgXwoner8YKFR+7pl/BlHDUlWw0agZ6XcEhgGl1X3ihy0LOVg7MWpC4g1BmTDz4Mvlomkp5sHutmEEzxsseFmfzWGCh0SVdt/t/bqPEzths4oaRSA1pK2aBGKB9hdEQ9FQz8+Zv0lqlnnbRGUSUVvL6zS43qQPQJ8BhXvL+ZYkm4Zybvviz1+KYWENutgMo0asfkaveTp+Y0Pu0FWI2CfDtGALm3NdwH5aY6pgFXKA03l2utcdKp5knRjSseBzBQOi39g/8nQ3auyYUM6+OZ5cBQZLA68G+2GN29YtUuw4S9gDZ0pTCl9bGAh4ZL9/UpcFT+NK7f0KR6Pa06ystytql0KCwLERJlqYLl2RzDH4GSkqNq7MLAsxxEIon0mWKU2d9aeWMR10KQnJZvtCGbpfOMdIUyLLYAV+s3GugbGja0GhUkNJf0QYGn3ei3FRL4HHdZqTp84oXK3pJy89nEpxrYM636pU/JXfJHCumgRGWdCFhRAnb7jDtU+38xZVH9YcYwWUbW6QolbEq0WT/stgWklZ58fOVJyZYncuXltWP70I5ENliGAfAHDyCDn7jqf7iMSslDJPKtiya+Ct
 p45cymYa
 HTiIfiaQrziZHCG1Bg97B/dh7m77b0uhepO/gjZ4DqGlppgVKPpzOez53WOQInb7CBJIuIV0nQ6TeEiWhWDbRfA8rDo3oTPRgHvOhHiMqi0AwUjAJvCuqPQdGM9i21uUutpdMFWRGdHMp6SehE/ABVt3CtE8zZ56aaDBcto5AX3fIsIHyB/azXtMrYWyi8kUwwqkYjgZJLtUYlSVNCOsboflia5BP6wztpgbsnP0syakBeBvbBau+q8KSZVqSHsahMP2/S6zXgvsPonTr2qOh5Jw1T+M2iG5SsxgBI1UkLWAvRjeJXnbPpcFyu5q+ojNeD5It6LqXExR00OIVefojKWcGbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 2:48=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> Hi Juan,
>
> While I think there's possibly value in people not re-implemented their o=
wn
> allocation injector, I don't think there's value in having this be part o=
f
> core-mm.
>

Thanks Lorenzo for your comments. Apologies for the delay.

> I really don't want this to form part of any contract or to be blessed in
> any way by core mm as it exposes internal implementation details and I
> really want to avoid adding extra maintainer workload here.
>

I understand and completely respect your concern regarding maintainer
overhead and internal boundaries.

Do you see a way to provide similar functionality without exposing the
internal implementation?


> I'd suggest keeping it as an out-of-tree module as David proposed
> previously ([0]).
>
> Alternatively, keeping it as part of tooling (e.g. in tools/testing) coul=
d
> also work.

That would also work.

> (This is no comment on how useful it might be for debugging or testing
> scenarios :)
>

Thanks again for your feedback
Juan

> --
> Cheers, Lorenzo
>
> [0]:https://lore.kernel.org/all/97605949-82c5-49e0-84b6-b42e8078b55d@kern=
el.org/

