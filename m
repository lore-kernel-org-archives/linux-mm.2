Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52637CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 15:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E88D8E006E; Thu,  9 Oct 2025 11:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BFD58E0008; Thu,  9 Oct 2025 11:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D64C8E006E; Thu,  9 Oct 2025 11:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 771128E0008
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 11:33:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CEC2B46371
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:33:58 +0000 (UTC)
X-FDA: 83978971356.01.2E29DD3
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id ED35C8000B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:33:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="e/FuL2WP";
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760024037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tSXhHm/5nIOgPjlJwTx67zGytbtuMVojQkXq2p4N9O4=;
	b=sU1UK5F98BhskySkz13cNRo3sLgYHIa6+zanJ1/OiSa/WNnHQ7YBqDk9bIJ4hSBwHKRmP5
	Y6jHLEz9+JbNr3ITb1EelAkS1sY9Y4Srn3bDfbf+bEH7oScYGaTDmlnw7NbxMNVT0Uf2K9
	MwGQle0nYgl9WcnHEX63hWFQfdztb+k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="e/FuL2WP";
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760024037; a=rsa-sha256;
	cv=none;
	b=VQF14a+O9MKMWmcOb8UhXWfUW0qRCaIIqHYR/wFRNdMca3sHeFV1lOImIXT6Yun/CnntGw
	ML4lnqhr6YKkQuw5Go0JV/1lKrRzLfSICIiaXhrxOx2TKgxI4C7bwPMH0PZRVinK2Dx2tk
	+VD9/eYVqdVJKGhh/3eLTqb/ox3t3vs=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-afcb7322da8so199299366b.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 08:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760024035; x=1760628835; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tSXhHm/5nIOgPjlJwTx67zGytbtuMVojQkXq2p4N9O4=;
        b=e/FuL2WP3M3mLyC3A92oFTlPWCk7PadYxPj6rAStTxGOosYwUeD2O7u73xyZ0rsP5/
         tok0bg2t1sn8hKuBIHwX1afCAD/2VIJdjNFFsgheFaCeWPBiyUjVpO5gahvOcJw5D7Pv
         dkpee0nYgzvDEonU1rjAuN9wu4h+0Ju7/6bs52tu8bmDzzZ4GPBsr9QXkYUjw79MxRRg
         1iEM5NBI0l1XHq9RSy1sXrZ01rO3YxHCrcRruRXVcuMK7WJBPTEqXm5unLWKrnX3DMtF
         naTJXUSn6ZfCWyNMCZeVrMXab/01fmH1RkpqK6iRF9KKnbig2wD3B7864p5215JuJQxR
         IYCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760024035; x=1760628835;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tSXhHm/5nIOgPjlJwTx67zGytbtuMVojQkXq2p4N9O4=;
        b=eggxj5wcKHu252VFgpQFW/Mf4onWH3ZPugAxRqdEQY+MSy/ITrajYyxZXBrvWw8pTH
         bIYnBWnZHUdGnHDe2KvAR4Y6NNqoYSnvboEq3WQqGJZHu14PsZB2EX4NGtL9hJVo7yEE
         rPTEj1yq3oopc03oIGeJGqfznKhs4+QiuAYui5JQuqZ2vddceIIxalJixiG3zzsEMP8J
         QwlgfKjNfHlKjp1M47oLxZurzhAJcIXwGQ0XSZ86/Q141FO3wenRKexHGAN/FveKfPtQ
         pF9HgewBB14rNteIiAxeRFxRPMPAqh+lXoE4fYPzL79/ogM2H+AswvUnm4C8L6Sb7kOP
         KVQA==
X-Gm-Message-State: AOJu0YxfQrsLArzJc9EFsu8XKl9NBlJBljOwgFq+z53fAgVoAo4uOUzO
	ttPhR3UgU92oQYD/7kTamZ07TGxsm9Z3JkdE1Fc8MZh54AKq3IUZNnN+xngRVPrOS7xZRQXYTAI
	b82txYT8vVcpCxWX9DFQHb3I0nutpAFY=
X-Gm-Gg: ASbGncuSdUBoWuUbwqXA7Q2+3uLO7OmK5JouzLy241sKn/dAseAi6lG15sJynNT7wW3
	lUN017VmshJIj9KbRvGLw9VUk2wr+WjxoT8s2X6QnD1uZNExbcoXppHriXjPWmwXdvsGQ8W02rF
	KYUFa23iTQjWHdlWEpE+hwQ7UbLxCvd/g7cj++5oBvSfMu/78Gz3hDr8+cmj8NXufyeB8nSrqPi
	8KJjLWwRBTAxAexAf95j5EoNLtCu/wulRb50btV+g==
X-Google-Smtp-Source: AGHT+IH6/BnweZ3mNzMlMJsoDTrD5kw2wuxUnnf/fUi4kLw7k5i81wPVfRT8YaOXTjGWMzidnp8/KhRKuG28inavPMc=
X-Received: by 2002:a17:907:9287:b0:b0a:aa7e:a191 with SMTP id
 a640c23a62f3a-b50aca0b70cmr976959166b.57.1760024035254; Thu, 09 Oct 2025
 08:33:55 -0700 (PDT)
MIME-Version: 1.0
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-4-74860ef8ba74@tencent.com> <CAKEwX=OfcTDH08VrTMFL-uQyBay11H=NccYWVo73XNHVVf7bEw@mail.gmail.com>
In-Reply-To: <CAKEwX=OfcTDH08VrTMFL-uQyBay11H=NccYWVo73XNHVVf7bEw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 9 Oct 2025 23:33:18 +0800
X-Gm-Features: AS18NWA71dHoM0Fug4D0KAccZRzH9_6Mg6UINYPbSGRBRYQlJKeWYjPjVsp-Kn4
Message-ID: <CAMgjq7DTLxr4t0wvCDDzeY8wwjk_-1zS2yqVbNYvrc=6DAnXbg@mail.gmail.com>
Subject: Re: [PATCH 4/4] mm/migrate, swap: drop usage of folio_index
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Ying Huang <ying.huang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wxnespn4gcfcrmagp6bshsta3wtgahg5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: ED35C8000B
X-HE-Tag: 1760024036-827487
X-HE-Meta: U2FsdGVkX187jdMM4FrN+2r7E0ErY60W967nxhkdRoP87Y14BXgd1JHmDFuwB0Aj+NL19oEMZvp999S2Q9k/hDh/WN5nR5jUWzY5AIF/CJVlDpcGoj5+F+4I6/fJZNgjNiTxXz0qIyARxqLHWA87sUJJdhFU+0S/0EEGoZD1ZpE0Fqp34OT30TY8s/wASbh2aBP79h80pGnS5MFh2nnDM2SexWlNUX3mQU24jUTyNM5AtRp8IDbGYIBNhAn1mpJi2Mkyv9BhSS3yuClYia1qC5pWmaBuvC2jcAiJG9GBgSqhiiMqnHVMhD4vf1G939tH2mWjb1LQlbpc36LeY+Wjn05h6uV54WcLshT2RM5fS7aNSOh3tKSb/3FP/Czrw8gshSww407/waLfS8V4KJcjoGKVstNRLpBOZrP5/E7vzLeNBz52eenis5lIO3gDr1VVIrfIsR0e6ETYv/Uk0b9rMDhg1NxdKc7r5lGs4qOBzvCSk7kyGPudclTDZfjlI0/AQjRRzzCfxFZaOFGXbxTG+o1AyRzaONiXLDYmeQ/WlKtcx+2uBuDZRwCh77nnePCATfJGnCHMg4tjgz+xsBsJYdjrcg4VkDE4ydOVreRJwCL2XrVeE3rxSpI+x81YkhyP2Um5Co+p3K7khp9XUM8MLdzqX0zGudSxU+yKKOEAxjI9eWVhR8z5yyudOan/Gtqp0vpwSh59Uflx3C0kRwoOmdknxvkBX+6wKeB+knDG2knNVRNCINFf6psHhnxJffG3sUbLqdxpUp63cZdVTRHR66+dl/c6i4ysrw0HNZUgcbQhTIWwsFPA4g12gcVI95BLjcHew1/3Iwdb60ArxHEkly/7qVdmVBFX81v1ETUUAqehmBkIXF3HszQV0kXrHV5xu+2fj1RzjAGgU2LqDMYR/LUcXO00W8O0ixC35WQvQz1lhqhAr0F6atUt57V0DPr0yyFQ4bhYNITbFA4B5uJ
 bxYobta1
 TqfPLwNxqya2nauLwmZe22EwFwOmRufdxdutyR/WeFbpCztUlaH7uB6CCrpDjA1ln9VGpmH4g+MaYd6MQ6GJZ5kaIqprg20x8DrrUhLxzc32Vx4etvY1EoJtJ/E7PlB/mc7VmWiptCC8Z2RqKvAI9rkiTg2L3EY9407GXFOxXYGeaogI8FJYIc973R5RfGod6GyvAqRTy98ywUM8eBMxSdJPD5oT9mnYpjTXdl/8mDH1ykwKzCFKt+6bwnvb9ReaTiPjZmnUR083azEcj51tJABCdwjWIBauCaNigjG1TucK8cu0unilTe1pzaZ2lyenMkfpvwUxbi3qgva0NTBc4Dmuy9U84dBEX2RoFhMdLdhig/MlIw+wo/GjJP685aroexhh7C3IhzpAZLbnayXgN4svKwVFB4+kzPqOdA2OTmXuye5vzvx6w+nMn7blqLU4FX5YA9/c1kevzNIA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 8, 2025 at 7:48=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Mon, Oct 6, 2025 at 1:03=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > This helper was used when swap cache was mixed with swap cache. Now the=
y
>
> mixed with page cache? ;)

Yes you're right :), thanks!
>
> With that nit fixed:
>
> Acked-by: Nhat Pham <nphamcs@gmail.com>

