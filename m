Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0AA0CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 15:10:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 033578E013F; Tue, 14 Oct 2025 11:10:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00AA88E010A; Tue, 14 Oct 2025 11:10:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62428E013F; Tue, 14 Oct 2025 11:10:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D28B78E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:10:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89E66160999
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:10:13 +0000 (UTC)
X-FDA: 83997055506.17.405EE67
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6CA981C0016
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:10:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Yaeuoalv;
	spf=pass (imf20.hostedemail.com: domain of ptesarik@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760454611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+9sQqZFGj6pjO2HmOLKtnRlFSVSp+ASbakb0jxv6v+E=;
	b=mNgk7N5zUvO/FY8NAi7T1gR6mgpquI4UUtYLd40Tmp1x2uVYvE+ZpUQ3vc0HSo6Jn1nj+N
	utxq871VYAjUpAHn/71W+wL2Zf35tIEwdqOf3eDyn538YutEef/1erf60QEFc7PD4+bd1x
	F7fKH/vEpvMhIickywrIA3blslFju+4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Yaeuoalv;
	spf=pass (imf20.hostedemail.com: domain of ptesarik@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760454611; a=rsa-sha256;
	cv=none;
	b=0BzpHlwCQ5s0ElheT5iYT3GmPiQAnLoJ22jEoJsaskEOPqO3tF6j5uIDR8bm1TaQReK3wh
	wnYtjsi0XYrOrdA2JhIzaNTG3MZjo9Dtr1L6AI1cnIN94ylNaJFmC2XOJqc+cSHcCa1DmP
	yK/m47A1qTrtCKQUIl21cGoq9BCNGH4=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-46e33cec8edso3843465e9.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760454610; x=1761059410; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+9sQqZFGj6pjO2HmOLKtnRlFSVSp+ASbakb0jxv6v+E=;
        b=Yaeuoalvhk3Oc6YNo+8tSyArece4pI4P873DX54TrKQ/r1frW1sKme2WN2YlZWlOKS
         w8jLKsNEU1vTd9yi+m9VW6GGU/fkMkZ+ejUdaFciwhXFYAX7Auav/7QLMpUAZWWkkh+d
         RQsG/TGmvgSe64vQnsFuPngBU65inlr/FTDmXdvTAgr0nb83KKkrcMTiNUvgvuFi+eRf
         F74OZ8OdPYR6Fqwatcs1aIuIYUcg2jkoLIx8H5mx7iqt8Ku9LTSsOG/uV17Sj42sFv0j
         FeJZL9bhcZoT4WCsVdOMBONjv53LCIRnex04sqRy+X1pvs4OBvdXVBwbZEH4h0FANa8M
         1ruQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760454610; x=1761059410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+9sQqZFGj6pjO2HmOLKtnRlFSVSp+ASbakb0jxv6v+E=;
        b=ezcKKOR+nHYRYVQh3khPw743z/XCip4vpQQnqBnEeYlyfINVf3aE+WzLI7QB7YYsK1
         fATFD5Phf2BhR8HDfHBhF2tgPfJj3Qe8a/CifPaY8wOfWJxwJTWh0HW6UTklvQ7Q0Ip2
         hc3q1ZzMV9wG+PRhLpvYSlEOn1fi3CLcWax9mJeqbU/4/e3hKDdeEH3p68wtVmFShumc
         /h9uLlkRvnOBKGHmCuyuAuedYcKM7R1k927eSEP5wYrurzgKqEWMnjjZuojxgKb8pG+3
         AH1h7M7zgxLL07LtAZyv0JpxQheTFO9We3gSw/EIPdasQ1MZnYEeghLuwkk3CFzQmqU6
         ZrbA==
X-Forwarded-Encrypted: i=1; AJvYcCVXZHQjDwPvekWJSz03CFhElFY19Z5B9PWnoMBfwPmAS4/1RG7/KbO7wrS7Co+dj9V8ezDsgbQ55g==@kvack.org
X-Gm-Message-State: AOJu0Yysv98bPLVCYwfod6HRao296pu7S6SAfBs1b84Lbzqj3PUaR3B5
	3ehR7Ruf2KuOY1BM/wB/k5TzeLGMAgsu0V8LsuoisRv6Ovuwt3zz+CNTcxy3XC6w4oM=
X-Gm-Gg: ASbGncsptLCn+/Yd3gYYL5t0k7HlZMzDnB3D5gS6dGpKBpcysZM7fDyXN4KMpzKhxN0
	8jpo/tjKwSd63kYYwpE0VqFHfBCtNqK0okRLvszE/4hOFzAGpyCK30hqYwLfDlo06fUZXC0VnBo
	nTh+1l3bv4vjV+Yz8j2UXzY7C6atKayljApQmBWViyHvcUV2eCZ/mP7iwyDgxza8kn88RanKnJi
	GJy5h1dOzWMws+d5NTyxVCMBYHrhaGrx6Ny79lp9p2pTFkbZG3EUht1iQjCx2d4KWmNc4i8GvFC
	FLtB70Q96bZ+cF/KGpWYfyjqk4P6U1dGn7MRwHouH9IlWuSzl+su2gTMV5Cj5RcO7noj8nOUByt
	JgbhJ1xET7ZZdwMGGm6OsMMg=
X-Google-Smtp-Source: AGHT+IGAXLObLFqWvdrlT8jNvhDt4TeOuL5i0Y/T3RwGkmTWxiheZJLoRR4en+J0WUHha4o/PPCBLQ==
X-Received: by 2002:a05:600c:4e93:b0:45f:2919:5e9c with SMTP id 5b1f17b1804b1-46fa9a8ae60mr100424145e9.2.1760454609668;
        Tue, 14 Oct 2025 08:10:09 -0700 (PDT)
Received: from mordecai.tesarici.cz ([213.235.133.42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb489194dsm244369755e9.12.2025.10.14.08.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 08:10:09 -0700 (PDT)
Date: Tue, 14 Oct 2025 17:10:03 +0200
From: Petr Tesarik <ptesarik@suse.com>
To: Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>, "zhaoyang.huang"
 <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Mel Gorman <mgorman@techsingularity.net>, Vlastimil Babka <vbabka@suse.cz>,
 Sumit Semwal <sumit.semwal@linaro.org>, Benjamin Gaignard
 <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>,
 John Stultz <jstultz@google.com>, "T . J . Mercier" <tjmercier@google.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Subject: Re: [PATCH 2/2] driver: dma-buf: use alloc_pages_bulk_list for
 order-0 allocation
Message-ID: <20251014171003.57bbfd63@mordecai.tesarici.cz>
In-Reply-To: <ecba7133-699c-4f3e-927c-bad5bd4c36a3@amd.com>
References: <20251014083230.1181072-1-zhaoyang.huang@unisoc.com>
	<20251014083230.1181072-3-zhaoyang.huang@unisoc.com>
	<87953097-a105-4775-88a5-9b3a676ff139@amd.com>
	<CAGWkznGN7W-txq_G+xpZ6DtH_1DNorYc=CxqUjebo7qfB4Sxsw@mail.gmail.com>
	<ecba7133-699c-4f3e-927c-bad5bd4c36a3@amd.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.50; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: u4yhjxbhcdhhkefecehna1i4h47phtny
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6CA981C0016
X-HE-Tag: 1760454611-540769
X-HE-Meta: U2FsdGVkX19XN7yc4GIeJftOAX45tbYz9nzXjCyAHHgU6N+x6GD/rW1jnFQ/rHmTL+4+GL3sA/623JnV8JSeb04FOULWCPQ6361/aZTSKNwDnY4VovJb67LjIWLRltvrFSU5u1xcIuhd8kLST8br+arxsMN5jKJBdXg2Ig5ns7wG61/aGzhG63Vxaqbr3nUbQzGc+2xWgfcYRaX874xmLpP/UOO3PqW42GoBUXyMp2aWR+h4m3N4JAU2LY4kFrqDFA4jzj5PcnXjCm3EnLh3G/gUsT4ZLWNbyCnqEy3PMqsyxNTF0RQuhB8JdEtF9bhjyCMkqIb2egWMMX88H5zYshlIT4WUS50oZqM4iEy9i/XD0aV7O4OEMeQCBIXnw/EdfU+myzOeGOvBkvgoJC1MdqBpDkufIpDRDwKayIVjfbjxKKW88PLSi+pbuFDiNPZ4p7W82SCPjzB0b+012dRSzV7YWShMDRFS6QBisjuN2QibUbjCJk738Qo/F+0aRVC5kTVrM45dOPrdoKgYN06ff/En884k42nkvYUOy/0doP99c1eWwzLu9MztSAQOsccfgw9Tdj3CAKoM/tyqItjJ+205EZVfSEGuRHdMX8PSXi0cF7CwSNZ/63eeYjWMgOEsHDOE5F7ZVzQ4qiZBv3H2fdDVJLpQFCeJtv0d5cJ8VLWqERPtS9uzyMZeVne+oa9B4bGH4IZ/jIa6PQry7+hDMGOru70gkIb3GTj3A56sPEBkRUhMNrVJ64zefaEVaJ4sAL3nTBXEHb4a723UX0Tn97jMP+P1PtJbqyPAyzaa1V7c+BHsSsQEeXTNkANZEzgJ64DJx0sctf7aZGjjo1CErikcqhg+fPIJdbcBU1KtqlhtHW5yeHmk8dkYtF2Uix3sP5TTJwLcfkXq2EWrHruq7VBPklZMdt27/CUJnm9vBkzRJGnPv6lLzwsXEeUri3qyt/JyQfzb9GNySfCJuo6
 37h52LkK
 QylnJ1rPmflWOGrkJjRAVpUygwJY3HnqrH2sEW3Xtl012pkUF8cOxXduknL2ULWAKbhz9i1OE60nYoUsh/JyQFD8oH18PtmK8A1R3dxg28T8Mw7Xe8Nh6TF0AW+robzpw1RsmaYUXN+MRkgwklMMoL64UKh+ch1vrD8RGdhLHlXYxlgrSi+lvfF8kPtEzMS0O+Js88q+Yjhd12cLkFYlyzruHZzRF7uND8//x3Oq9zAZZQ7C8npJpPLv8MwFoQ00mhhoQb5bzeF4BedTlSXQt9Y/BhY1C4yoAHdg7ByVyrCPT9FFlSudgRQJw8EC3T83jwUEB9ISj+diwUL/3xnAvrtPOS6h70Olj9/AiGcBFtbUDbmXpleKjXWbRQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Oct 2025 15:04:14 +0200
Christian K=C3=B6nig <christian.koenig@amd.com> wrote:

> On 14.10.25 14:44, Zhaoyang Huang wrote:
> > On Tue, Oct 14, 2025 at 7:59=E2=80=AFPM Christian K=C3=B6nig
> > <christian.koenig@amd.com> wrote: =20
> >>
> >> On 14.10.25 10:32, zhaoyang.huang wrote: =20
> >>> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >>>
> >>> The size of once dma-buf allocation could be dozens MB or much more
> >>> which introduce a loop of allocating several thousands of order-0 pag=
es.
> >>> Furthermore, the concurrent allocation could have dma-buf allocation =
enter
> >>> direct-reclaim during the loop. This commit would like to eliminate t=
he
> >>> above two affections by introducing alloc_pages_bulk_list in dma-buf's
> >>> order-0 allocation. This patch is proved to be conditionally helpful
> >>> in 18MB allocation as decreasing the time from 24604us to 6555us and =
no
> >>> harm when bulk allocation can't be done(fallback to single page
> >>> allocation) =20
> >>
> >> Well that sounds like an absolutely horrible idea.
> >>
> >> See the handling of allocating only from specific order is *exactly* t=
here to avoid the behavior of bulk allocation.
> >>
> >> What you seem to do with this patch here is to add on top of the behav=
ior to avoid allocating large chunks from the buddy the behavior to allocat=
e large chunks from the buddy because that is faster. =20
> > emm, this patch doesn't change order-8 and order-4's allocation
> > behaviour but just to replace the loop of order-0 allocations into
> > once bulk allocation in the fallback way. What is your concern about
> > this? =20
>=20
> As far as I know the bulk allocation favors splitting large pages into sm=
aller ones instead of allocating smaller pages first. That's where the perf=
ormance benefit comes from.
>=20
> But that is exactly what we try to avoid here by allocating only certain =
order of pages.

This is a good question, actually. Yes, bulk alloc will split large
pages if there are insufficient pages on the pcp free list. But is
dma-buf indeed trying to avoid it, or is it merely using an inefficient
API? And does it need the extra speed? Even if it leads to increased
fragmentation?

Petr T

