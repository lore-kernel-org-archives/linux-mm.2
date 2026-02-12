Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EFE6EEA86D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 22:57:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BD0F6B0005; Thu, 12 Feb 2026 17:57:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26A9B6B0089; Thu, 12 Feb 2026 17:57:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14C2A6B008A; Thu, 12 Feb 2026 17:57:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 056866B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:57:36 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E02DB7C09
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 22:57:35 +0000 (UTC)
X-FDA: 84437318070.12.A0E877A
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id C8A971C0008
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 22:57:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0rlIDT6c;
	spf=pass (imf20.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770937053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IsL3Tv0VQD7alfW+TNnGdHtI6v7KRjX4CYS+WhxYbDs=;
	b=AZdztnLF2z9yI8+mGl4Cwspd+kE4x21mvJ/pBzsYqqa5+QwsTFKshcBNuEb5NWG/aTokyo
	Xx4qQqP5R7h1hSx0H/dGPppUTtmtxXXZ40OpXic4yAkEyQo3hLQAKXJOiJyfsed6Bz3YIb
	QH27DOr8/Sa0jqezYW/tiwtoe9LbJOM=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0rlIDT6c;
	spf=pass (imf20.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770937053; a=rsa-sha256;
	cv=pass;
	b=c90li8Kbkdv7RTEdFBNV7kj/FW0vqIw9jvesijrSiVkukGKWbapJQdquPSegJV5yGbIDht
	Q7X4Tnw+buIrW2bfn6NbeT/Mjlhy3vsMEAyEyqn4gvgu1UY7goyulR1gIsEO7EsukYl11a
	oN14VhiAuKwRXg2htwzoCafN/GyjZYs=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4806b0963a9so13375e9.0
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:57:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770937052; cv=none;
        d=google.com; s=arc-20240605;
        b=av5ml2eVtKTL77w1hyaTHn8Yld+eLSxp8P+ukqGoU7HU/jAV9wrxAoVEz2xGVEPFDk
         DfFp4vBmwiULvQPgRsLs1LSO4fCAtzMKprbeIrjnDdOcEsxJp0KM3ZXAXTuvchfYSoh1
         whIHzxyWWwzkml+a26c+CApl6xBlgsFAAB+whm66z651W1452iD0tUNssz59w3XAfsqr
         JHIBuw11X06xfj4ZmTtHapA/YkPuo6aQi5q3liLnokYg1BotyzOFUmIBMO5xttLd2W2Y
         wsc2oPlbhbF3OmbkRKJFTixCp4cdgkqwy7RZj8ZqW03FFYzL4t2KnsxqqN2n28ZhFZ5D
         2ErQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IsL3Tv0VQD7alfW+TNnGdHtI6v7KRjX4CYS+WhxYbDs=;
        fh=ssgqLsUBvpHx17vs8XdohFjDi/TROVVkmzDa0pGsvtw=;
        b=giVoWOJdK9Yw6F5M781NcKuPpZGDv72ifDe9I3aJmwM3N/9V0nfeyvqmf9U1QD5kTe
         R5CAy8D6CMFNnBWakQfIzMx3d+j4K7fBIKfHeCf5CD+vIGoo2sonKCQ6EEBZXfe7KvP0
         QNwM2V7IIZ89//7vBQce49pflZaTpzlrh1sqKjr/Tmjf6O1V/8PsYlcXgDLE2rGo/4so
         CgEFPLbVmu9Djbii2Iy4Z6cWpO+pHw2L2Pbw33Ys0L9c0tQvcoeV4yskQYncJxZ8BXfn
         L5MsqnYskD/KdZquDwwc9l1n8PrlJijRF2T0gy42syNunO8WQ1mqRPSF3RoA1bPgRJiq
         RlwQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770937052; x=1771541852; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IsL3Tv0VQD7alfW+TNnGdHtI6v7KRjX4CYS+WhxYbDs=;
        b=0rlIDT6c/sDaCkuB4Y3+zPo2OOvTmMQUozWXNjNAjZs4LBbVSriUYQhYCDxXlNZpbW
         syFcknaJRLLFEkZhdn61pXxfXQvd63kUgsxjpkFf1cs8BXn7Qb+y/mN9jDCs/hJRxGpa
         M8U93eJVMOVoNvParNkgPSHvoMST/yrR16cyfwckkLbYrBiZMfJHRL0qZCUg4I5KFPTl
         dtOGomkyu0PE4o8lGOju0G37u3CEDftGe3IbaDWS8tCClo51FfmMO9mhzKTlRrXBHzfy
         Tol4WPRsVgwt2lMVGFq9d+LEoiOgzMMC2UXcCgw8dkXZGe5iZxx+mKiBfPpetTZCoZnz
         Q7Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770937052; x=1771541852;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IsL3Tv0VQD7alfW+TNnGdHtI6v7KRjX4CYS+WhxYbDs=;
        b=YNXug0qJMDJipkBEcGY+SGYQvLXoNPqkBPEBjyOBCOAu1YwoCWdKfDBO5h9eoAiZ6f
         FI2MetxRQPl8YG+Y3f7tO6zG416XqZ7ppooXNXSTOftFycbsXqBSjih584oalcAAmggT
         SPfbi8HSH9o7FiLciKl/w0O1c+LW610aC1ETuFUury8+zcGHTiNnaMjTNiJYCcCT1sqj
         qsPv+TjNQVqWaV7FVCyZZhonGZNtTYEAuOZthJ96yAPOhtIOZMOvJVuUZjU6PYdCAO1T
         8jrJx6zkeh/UZqOB9hne1olup2/U/w6Bxrc/euhBn8hdZHs8vTJbPq/k61HHHKTKmDDY
         8D2A==
X-Forwarded-Encrypted: i=1; AJvYcCVOJQrMviMZkG7XJD+UNbm9f3VI0o/WB6P/VxW85ncG1lvCw/hYNyM3AVS7msE2HJxfqS3zoxmc2Q==@kvack.org
X-Gm-Message-State: AOJu0YzpFpGGNTqoNVt5xbjF/GijUWLOqFGG/uMskm6gaHj2x0DOZdev
	U2Tdj9wqu2mgEB+NPjBeZZRJXUTLoyX9o+VGzhuCXo73aydOcwJbUfHxY+/+wLNO6J51UfXH/bx
	uH+5VWUOgCTDXYkDCvNoJr6fPQIisf8O8E3Aj/DAy
X-Gm-Gg: AZuq6aLl8Ct/ke7u/PBXS8WYpIeUDr7JuqTjULImsmU7RQUsmfhQ7tQq5QiFhInjQD1
	gShXawxSAxtzE9Q9TDZ/fAo8BP3isQuxUvqf5AlcUq8dCqM5k5nffLbnbtRH/ywA1qJfiD0QV2J
	B3mrVFAPhy94nA+7Gced6Lekx+jUUtJxUI9aVsyt3H4yyaGFqVGzz4WPefsmE92+cHfiCVN96Qt
	7EkCWmvU464ckKwMa7ecGsrZOA/UhkfFK9B58FP79Y1GfjTcus3RwYv89fRVYIkXL37JDBCJNv0
	AnWmiawsEA4KNhCui8f0P7fch0E7PMmJIgMBCUjHFZIL5L+TUqQqtXRYn3UZfiEGZjLt
X-Received: by 2002:a05:600c:a144:b0:477:86fd:fb1b with SMTP id
 5b1f17b1804b1-48371cd32a3mr72565e9.11.1770937051849; Thu, 12 Feb 2026
 14:57:31 -0800 (PST)
MIME-Version: 1.0
References: <20260212032111.408865-1-zhaoyang.huang@unisoc.com>
In-Reply-To: <20260212032111.408865-1-zhaoyang.huang@unisoc.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Thu, 12 Feb 2026 14:57:19 -0800
X-Gm-Features: AZwV_Qj8ggz-blw4kj9aYSc9jaLwCHp32lTIaKxhWsQm0RofiyRFAm36Bqjgw5Q
Message-ID: <CABdmKX2iqxfJCLO6=TGkN2rZpJd1yJiDx8e05HHGnRbf6W6W_A@mail.gmail.com>
Subject: Re: [PATCH] mm: remove '!root_reclaim' checking in should_abort_scan()
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yu Zhao <yuzhao@google.com>, 
	Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C8A971C0008
X-Stat-Signature: sd9j6sin4ig1oi9in73m1yhiqurge4s6
X-Rspam-User: 
X-HE-Tag: 1770937053-776736
X-HE-Meta: U2FsdGVkX18LKufjVhi8BQBaSEsOyns2d2Au4G7uigt3D2QifJKULOKrPG7seJlOyHTinO/u0vPS2ZkBQGp/7b3gH5AszvhyyVgiZfB3rrjYD21QQi8luq8EIeAW+IuN3g1zB/qHJLKjlAhEFq1eT4zPztGJhsVRdWhzTNNGeLEaE/G1Y/iTX/swDdAg0C+3r+tvJpqWh4M3UA8ioU3gzjWTaE8/5CO4T1VPSSMVS2Q7SezbB/i+wvouEHAkgfmSZzg8cBTL3PooBKr/eUHZbHZKqEDNsVOUFJ+j1k4+GwTOYA7gU9jhn9W5+gvQ07sSMQB4nZn4wyi4Fu8vffVXcNLtfEQY8CsoYVrMAW1m4BIy2j4bR94gAR6kD3XrGfwkIDCrTrdGwEw+otwImgv29+0n/RQ/OmPQvxbE3GDwGtV2/83M0H91ZATR9RaxDKdnV1c9kbf8Oota5B+/rUPI92Yic9ilYVfs3LqMkoShqeirtxtAoUOzmnDpHD4fducw05y5USj/3U64AEkGKDTmzz+QE88ZCRHw6CeZq6v0QDuYo7n8Cvo3811qlt08wCF/zQbPtMKMm07ywDJXhTHdBXkH7LPxmR7jsww3dMssJ+Weaja6+4pxboeX0CMiS1W7j8SXimZkl3Jq3VSKNqqV/e5vPQxmx7QU6CxvXc3atEOlAVWYmwXyyKVegzAasaD1XrIBFfc3R8CvSz7mf7Upj+AV9YBubTrCM1iuwFliuNfNQOdkZieR3eQe+cd1RvN7+rV8OU3RNWAmUrhiL1KlT6PopPJZE7SXWFdnJJcpGsvJFHljmypWIaZji2VB1HSkaUYv7684bVQ/LgPa81XlTNFxzCvXLvbV0jtkI0AoxxTrDF47wmrVn+WpYd1u81LDPeKhEHylbNp039WpkRZc3pR2iway2vt6HGane9V7TFAwcAZWroDeC+nj4uB+Y4DqzSE25kbXIQVVGwFoDiM
 EWyoP4TD
 YN8EIvpmIdPK0mGK89n77njPhTZzZKBEc8z8evmtV13C2uCcZ8EAIGMIPtXjc3NG0ltnG3QbEdQ8x7TE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 7:22=E2=80=AFPM zhaoyang.huang
<zhaoyang.huang@unisoc.com> wrote:
>
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>
> Nowadays, ANDROID system replaces madivse with memory.reclaim to implemen=
t
> user space memory management which desires to reclaim a certain amount of
> memcg's memory. However, oversized reclaiming and high latency are observ=
ed
> as there is no limitation over nr_reclaimed inside try_to_shrink_lruvec
> when MGLRU enabled. Besides, this could also affect all none root_reclaim
> such as reclaim_high etc.
> Since the commit 'b82b530740b9' ("mm: vmscan: restore incremental cgroup
> iteration") introduces sc->memcg_full_walk to limit the walk range of
> mem_cgroup_iter and keep the fairness among the descendants of one memcg.
> This commit would like to make single memcg's scanning more precised by
> removing the criteria of 'if (!root_reclaim)' inside
> should_abort_scan().
>
> Suggested-by: T.J.Mercier <tjmercier@google.com>
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

Reviewed-by: T.J. Mercier <tjmercier@google.com>

Thanks!

