Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 540A1CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 21:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A135A8E0009; Wed,  8 Oct 2025 17:03:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C2E08E0002; Wed,  8 Oct 2025 17:03:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1418E0009; Wed,  8 Oct 2025 17:03:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 76C2F8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 17:03:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3BC7588307
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:03:21 +0000 (UTC)
X-FDA: 83976172602.05.1386635
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 570F6A000A
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:03:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=deAB8ii2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759957399; a=rsa-sha256;
	cv=none;
	b=pMiEqJrpFsV6lnijV2UgKlYT/mFyKIzkvfShBXEYranT+XipqKdxVBoEACHRjzc0DcCgY0
	fFcbJSdKlhqqgRyH6DhYe8Kfrqwzq/2XvrJAT1GI3Sfd/khPwUX+dANqqdxE8uMkrhBLxK
	UJj6cyq3fGgmeLagD82ig3nIW3R1sr8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=deAB8ii2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759957399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QKeBJSjAWSqCACSg3rVZkpYp40CuPjls7hZFLIY3sO4=;
	b=v9+mo83wRBkbqr/OFynfiTsyw7yUyIvLA019YfQYyZ6L+vomMWLD1PEspnwkM6x9nBNfef
	e/2HTOvIbyDgTmhslxzPr8DsD7jkhhtZoV/+V0lx2y8oDU3QSrnuoETQ9FoslWBzegdipS
	Y/+UyOQLj1dlEYh5Ae1ltl6ezi1JuPM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B791F6202A
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6919AC4CEFE
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759957398;
	bh=G/ITfw+9WPz98y9dzMSfigjUmz7jNHGjpEelggGzz7Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=deAB8ii2WyATx8rqBfOHToLSdCw0Q/ID7bW40yw6V6AVoUka+AQtzQ1ywzqNYxeTP
	 OZjhZguPrFVj9r5ZpzU1RjBZJ6Jy9HbIKCVWR2dpNX8tCTACBQU2+H+aPdYSNiWeMT
	 1JTTGlHKCuIekhqQo/dO5vR6Q/ssZcOIQ4jYizKMyNKV1oIK42QGthKQrVax2lORbc
	 frmt4ac1Giy9I8YZGXoNuzyfY03PV4Ez1ShgSm7fPvI9za40QCS82b1xh4d9kr/hjK
	 6FEr+B1gOBIXDuGNhTTYnW3jOfT40dNk2VI1uuOomvmdU469rzEEQ9A58Ma0Q2G5EV
	 LZM0+0NetIFng==
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-63470a6f339so367561d50.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 14:03:18 -0700 (PDT)
X-Gm-Message-State: AOJu0YyhoRMELms2dL3oGammpH0iBzCUFSXH7yz6y0zmbZBu7fv+0t5/
	XXn4RqAdGmzrqP0d7ytEEfSNnkSQU6+/C37UBeFvq265522SHVVkMfop64InI1dK7K7S/Zarrl1
	0Dzdb9oLDYFYcUbg1VReEcQHts3Qo9UsIwKKQHXipxg==
X-Google-Smtp-Source: AGHT+IFK1Omp+xmPcKgCpqNFfD5Y+SC+MQkE+F3li4un1zZc175jgUQ1tcQjQ2L4pr2ww0RkuCdLQIaf4qCjRjFoUDo=
X-Received: by 2002:a05:690c:9a0e:b0:724:bb55:27c6 with SMTP id
 00721157ae682-780e170c20dmr95905737b3.53.1759957397779; Wed, 08 Oct 2025
 14:03:17 -0700 (PDT)
MIME-Version: 1.0
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-4-74860ef8ba74@tencent.com>
In-Reply-To: <20251007-swap-clean-after-swap-table-p1-v1-4-74860ef8ba74@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 8 Oct 2025 14:03:07 -0700
X-Gmail-Original-Message-ID: <CACePvbXTG3qN64D-zu4-N6126ZNFCKqvMuUhrxW=aXnCkrOb_A@mail.gmail.com>
X-Gm-Features: AS18NWA4mAHlhE6n5l04RrJTU4ZEExbIpnlqnzbJgZU42WD6IdARt2KezhZIUco
Message-ID: <CACePvbXTG3qN64D-zu4-N6126ZNFCKqvMuUhrxW=aXnCkrOb_A@mail.gmail.com>
Subject: Re: [PATCH 4/4] mm/migrate, swap: drop usage of folio_index
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Ying Huang <ying.huang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 570F6A000A
X-Stat-Signature: ocf3rjjdfhd1cdq31so8cehozfqucocd
X-HE-Tag: 1759957399-32528
X-HE-Meta: U2FsdGVkX1/loFIkV9q8hwkcH2iQwQUq3I64QSB634QduXJ/Xm01AzSgd6BWuaS1ESBP++lGePkM7ottWUvawfYRNUiDfkiM0wQp2BvOxxDqH2fyXVbjrChL4oW7l/4Nqhn+gH+AopgwWwKms9g5wy+gSiQW2yDMR0xv9xhiiH55O5ol0DFn7mIgL5zd261TEQk7k1V2kyTHhk/AKaxDwQzjp53T3qFFcyZJldXJDiDTZeoj6dauRCriCoIoy8XWS6rbdB0WN3/T2rN64N1h+B05AZvUOYscIMgtxaiODdeqSgtGnZLtrgptLBZim1Hx3lSmgx4rikcDzvGOP35t5ZHY8ExVv6Rht81kopSlDX2/NiXp6itAeYvMIG9L7d0eaXt9nnKELdfx0KmdPErU/SrNfwFZHybWI9dlefV65/ASCNHesGSPUM3ARvcaBn40H635Kz5yX48BByOyj9u/qEiJiilGHtMJcxAnIT1Ji48tr8qtWrQtMpEobbxcQU5bCm+h3gjjdGQpwZh3O+EtTy+jq8K2MgBefvI5DGXSWa4XCygpvNkxUjyXTHzOYHfTcUPIpWRfrlxL35qJkMby8prky3tsKAopUyc9AUT9K6Fvlg4AXa1mbiyMBQRqL7/W/HOTyexRyAilO/RdRmJchKfGV8t1kXtOWe1lorKHl462kvXFSBuI5iMFrPevN6wTUrERa0GEBtWJvMmiy2QIwvBefFJHz3gNKMaK6DLbngVbqksIk0t42T0ZfqTvFUydqU1VYHu2IZ6rZfsizX6R5xnP6cXhVs8VlnGuQ0R7aywi+sa3Q1CZByiMtiG5DyDLWE5pu2S3PZhbE5wtAU1KaF5R+0lCQuPPI+jLM5T1qE96G4mksC9+7y5SGYQFP6YJ7BIiVufn1AB7q5khjF/bZjaQQ5IyCurieQs4VG9HLqBJu1Id5l4wnapnb8CDnNbBEuAhEKS33heNGaDHmXv
 /hNhmhA4
 eRrmxlZoN+SEKpuJWYo2KYqmNeEb3RmTUU9QBJFML92h9CzvERLfmeDM2rA7xpVJWx/WtO2T1ScACvSnmHed5meGKDPMaET8SscPt5QkrxF/Icki2vHUKy0yMO17DM9ZhKwsQxLRRVsW3wPtL9MWMtjXQH/XV0zU2L4Nt8w3DPBggByKZo6HT6RfL5rpEF1eitsWnszWbj5fLAHV8JuObp5d4X1TNTYIvymj3P0QXvJbEuzPI9EMY2aYXpfgQVN3OQRT4Kj1oZ9m0hjvs8Pa+ZTxgI6sGHguNJjfp9NsyZPWQf6y/KbO9s9E7el0ON2SW7+vSneSoRhLyM9wPHSMws20QQYG3zGVwyeHMXuxRwB+vFWpmOJAKG/tL+8bSIc46O8KF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the cleanup.

Agree with the other fix suggested by Nhat regarding swap cache vs page cac=
he.

On Mon, Oct 6, 2025 at 1:03=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> From: Kairui Song <kasong@tencent.com>
>
> This helper was used when swap cache was mixed with swap cache. Now they
> are completely separate from each other, access to the swap cache is all
> wrapped by the swap_cache_* helpers, which expect the folio's swap entry
> as a parameter.
>
> This helper is no longer used, remove the last redundant user and drop it=
.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/migrate.c |  4 ++--
>  mm/swap.h    | 21 ---------------------

Nice.

Acked-by: Chris Li <chrisl@kernel.org>

Chris

