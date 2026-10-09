Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFC8BCA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 06:34:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABBAE6B008A; Fri,  9 Oct 2026 02:34:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6C946B0093; Fri,  9 Oct 2026 02:34:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9834D6B0098; Fri,  9 Oct 2026 02:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 609E06B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:34:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D17FE80286
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:34:55 +0000 (UTC)
X-FDA: 85302124950.04.24A7E79
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id 003081A0004
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:34:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a7pgdIw6;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791527694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/FPgtZeMX9AGe2HbHCGRW/KD//MP8quxuz9bO2dJ3o=;
	b=zGN/5jCtBvnAPEn7fXpUhMWuH5/iqpLSUHL5BPcaTZDnDEXJYzCUU32ks5Wn27BlYyJp7l
	+CzVvHw5Int5CGJhRl5OBi0bDrFhTLAsSqQA8FY1kmtg5tuPc/Y+ZQr4hN8QW4HmcKofyL
	dOIwvtA5CJUTKrYx0ZVtIzd+kQ4XjJI=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a7pgdIw6;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791527694;
	b=QnT7WHGmezAwBjabPMcV3C3JaP6/jZitTQfXf5pWms0hscu7fSV91P6epncK/8tbQGWmJJ
	SYekDVrSINf7574N17YuOorampV6DyR4keKSDEtirmkxN+HaTCDnmPhhE3WoB6c6MvI45a
	cuccm3+NllC/+nk5SyANC829YDGCpGQ=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a0213948d3so23289935e9.2
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 23:34:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791527692; cv=none;
        d=google.com; s=arc-20260327;
        b=AXlq6q2JNp9A9w8SOygcLv1W2wmVMbCZ1PbZGRrvUdKDojc+k4hcy2JQtsALUs+Qae
         cMMReqYdFG7XvCJl8sNGCUL4FzvIlPhjlgf5vBtncHDlGGCgbDgjEAZMLYSrkM+JT3tI
         xh1k2pKjEkjNoL34W0GhVNAntXluiiXf6e0ChplV1ZDtIdJrKVBCsEYbct2LD9+BQMG5
         ZVViQzl2cUMOK+HO8lkUVZd2b12CYp/QrnMcjYe2r084wMWyvWu2MY/AC+i8YDTi10hg
         qE5boJKKm+eoLKkWujdUxOx1fpESkaVbqC/pMRU8SSp2W5NwhYyYOrCHy8sO217RMOLL
         A3lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g/FPgtZeMX9AGe2HbHCGRW/KD//MP8quxuz9bO2dJ3o=;
        fh=bcEPE3CR+OddF51KqqJLDSZk7qQvv/ijtX/Tm5dhCBg=;
        b=fYdZka0LGs6dcdoVFD/RkkII5/VjKEkY6MnPTtX4lqbFwnHaliJivSY4ehxd/eLGZq
         gmPNzIec5R/4DChDqPT/D0WeqInXnjCiWmQn+WPjOOJL71+tZzwgjW9oRxZ0xESKITQS
         vrxghv8v/BDgzr2qXrtSkTZZsjXjwrlD50cVq6iUEjN10otre3oDNfV/AZa1igZbUbKd
         cQRTSO3YCyyqC5zBQgrMQqs8oAzvxwjYNeojmO438jdL8YlfqUbXxoSXk/YC4GrfZPc4
         3eXIb+tFOIKb7iF46WlyBmmxaaECzo9sV21e/r9O7SlPzREYcPQlBCL6/ppkN/z4roMY
         4o8Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791527692; x=1792132492; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g/FPgtZeMX9AGe2HbHCGRW/KD//MP8quxuz9bO2dJ3o=;
        b=a7pgdIw6zWXiSo3jjilm4mGh/ifApXTMJLyXLFxY74UrgUa4RfRbG0uxCYosmTvK3I
         UIh2d5LmpKap2Kxzz4sp7ptXezSZxb0Ojghz9fhpYcTu3KOFKPIbmfmBwaaKmKmMKrGe
         Xmb15IEv0YkXFXm4BsdSYNJyT1goms0GDWLYY7DbyE74Mdh5K6O5bYd46+Na6ojF/dL1
         DhVjy/GBgdWR4NKGzMTlxstnrom4x9tNtrPjbtFtB2BJo0EFbcwSbrhc4NE+H9q+tvB8
         MTDEmP2E6ZnipCQx50tV6JjyywtFZvfkaAhc8c71Ea9TIFGafCBsLatnMEsPN1yOaS07
         vJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791527692; x=1792132492;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g/FPgtZeMX9AGe2HbHCGRW/KD//MP8quxuz9bO2dJ3o=;
        b=Hbzlcdz6rmkOI3p+sUCT9ytB6rNZY9oyJxzAUrREVBKNUl7tVsYvUmqN5rIwn4uVcM
         3Gu1lZDpHH+MfPOxake7aB6ikocuVRDqg9OEribZrnIWG+L3UNBvg7urMwfmF2cMqsu4
         QPqJoYq/omdKqfZ6eqNJ3RkbpWnpzj3f8GGbAcVZ3r8aFoIwGBWggkQdijF3AfYjFx9P
         m1sjjW29jVFW6vy8uYdTPnfI1V7uZNIMSDvTNR9TunCuhAvbXsBi6esBY5zhJB1J5Y2h
         Vg+megdXDCzcU7irh8jg7jAj8ZOB3cJYfG88IoTVJ94tArP+wZR0Hhdi7nhLyOsQTeZQ
         4PsA==
X-Gm-Message-State: AFuF++kWj+RIQPJBHUMh9xg/CplWtQwNlbP7GMnYRGvjukqMYlEn/jFD
	2uC16ei9rPYS/Zt+UjNBuYyw90bi1d5/ikhCvBXi4jzEP2h+aaKdCSpa9/rgZdgkPPzeOccW5bb
	7Fn/Xs4uNkj7fU2ZbdXJKluLBs3L8TkY=
X-Gm-Gg: AYBFou3su1+tl1NIk9uc9lNxwkFm2+06199RToZ2xxE7wcIjlO6l7Ub/FRpKNC/qXyV
	yONFTOYvl8vc1mDX0OWjnzg4CJeFTfIgTZruasRZazq+zAvnnKw6FUbxEEwNIIi922uiuJYbHon
	jgTIhBfC5yXI1pO690OmxrcjHIwRRdJ9cny5dG/WnPuIyfsS9ekIt/VWftTERuCA3ughTGYOKPv
	+mETzs4rzxh7WsoWp/Gn/u5hS98fY2Z/P+Cz9RSzVrdfNNXYUO8AyoZjbDbe8cYBJokUzQiKsQg
	87m1c7rtXipS8ZJ1iKoGm353mFukO8W/XBQ7StjWDuzjIyXd9cTUFWZTYV31OTx6ri0rS1yz4fy
	SLbPFuUSEiLx6
X-Received: by 2002:a05:600c:3ba5:b0:4a1:70d4:c69 with SMTP id
 5b1f17b1804b1-4a18e4c03bbmr15672005e9.28.1791527692297; Thu, 08 Oct 2026
 23:34:52 -0700 (PDT)
MIME-Version: 1.0
References: <20261007153507.50715-1-alex@ghiti.fr> <20261007153507.50715-2-alex@ghiti.fr>
In-Reply-To: <20261007153507.50715-2-alex@ghiti.fr>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 9 Oct 2026 08:34:39 +0200
X-Gm-Features: AclHuK99dJ221d2Hn3wf-Vc20XRBPV9xr32gHo7d1FVChelU5vepJjOhair59mU
Message-ID: <CAKEwX=Mr=9hbGo+L+2418auHhA8EUAQAKYxNhXOXP0UZ_vHAtw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/zswap: batch the writeback IO of consecutive entries
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Christoph Hellwig <hch@lst.de>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 003081A0004
X-Rspam-User: 
X-Stat-Signature: 9iykxzyugkeiqmc6yq1p8818j7d49xdy
X-HE-Tag: 1791527693-231701
X-HE-Meta: U2FsdGVkX1/1sXqXI0wK1YYPwEzE4tAk+ieBybzUgyNRdg828PKlwgFNQlLK57pXrJQQXvGbUUqtQrdCCo6LAle07vzR3+Lh7Gui69ZiFxY/RcCDQs4KcRX19J46C0UxaO1cdCXP1/ocW1x6iZ+Gh51nvEl+PxfvWrLyWh1GuQOlQYaG8qRKHdw6QIo5TKZgXFjaXQpMfB/esofQyIHcw9l1ZBlmCgPagR1Si3o1xQJ9vp0W3zLBICui2HPhwEY6xSnupYjADHfwt6Y+tasNqX7Asa4g+EXMN/0wLXn9jRkdgJP3l8TpUUzRM4mPzIjziEdAPVcrljJNC3wvKnekPUs3wcVpUL/q+VqA4xSWPtdte5gKG7rpBEpw7q1+32vH1lTVi8V782I2XhylDWlJk5xd9KLuPsPZc+INf49C9rz2yNR6WRpojqEk2w6ciu4CV3Rv7xseQ1YUW/Ar5BDX7JYsgQup7Yby3irwfxfzN/rjB+9bUQmKXiAJQa727DC/P6tCfXmFVtBjWPAaAwzLhAn9VCuuxQR7WCkn1wttCP4xb8tegu7sC2Sc+Sx3O/+cdRRlViA/mfRnw9NlGSfAJw5iZHrzb1klgDhaOz9BG5PCKdIdO01Kea7bjynokeAdijdlndFi7DDye3yp75kPENE4voCgWY2HuQ/O1skYvHTYyE5Cips47FwbUaCQBMlYWI128fbdDEB/wUiymfL74jqn0yf6Iv+NDNq6lVBGfUxLlc2bs4VLW7vTvWegtMlYDoW67HAWh2Y4nDgcmQiNpv5/4UuKXy1M8WIdnTaLAVaWeETCPCIq2r8h6jVxlYhchBEU/ic8cEW3c7lliVJbrMcaVasHz0Vk7IMZfsvpiK7aYi7sPqRRvVvf4HbS+9g+pYGSccXtTrXVSNvsmqsy8TRM31c7N4wqhIDDxSrNiV/223yPaD/w5cvpOlnSfZ2ches1f7i1TyrL+CVer6C
 PKO5UDh5
 dtn179LyMnzFfsc5FEc1auL9cjee77QicNF2tkZgMuaq72DszV7sNgpwcm10Wgry3kS8WEgZI2SKUuYu4Vi5gtfAfhS9ar6YqsZvIlzjG9TIMhS/Pz355re+4Xr+Lz6iarGtzuUcNbOyhAwASOcZDbBz5AiqtxBCDrzJ/WEgedh5gcdtm4fj1ss0IkUknzz4od6bbkBfEU52UA1oFRw24uicc3jdt10vMKW4MkPcd4Rbkip0+E5pBsAhD/mUXZHdOwu8vumq1jhO1/OEOzmtary+FODD4kjTSCSIfrzzoHbGVozMZYJNr4DpnGI5RyjrVBYHjGoJkXURbMisPAOuY2pvJLQGei2jCrUjFZhtWzSmyse4fxft1kojOo8IznQ23F2pzI+MnyFpUGyZvvrNzqaWpmVFA/dPGlVr4d8rUckR2Y1M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 7, 2026 at 5:36=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> wrot=
e:
>
> Commit 8f29aa226f82 ("mm/swap: introduce struct swap_io_ctx") introduced =
a
> simple way to batch the swap writes of folios with consecutive slots into=
 a
> single bio. zswap writeback does not use it: zswap_writeback_entry()
> submits a context of its own for every entry, so every entry written back
> becomes its own IO.
>
> So let the two functions that walk the zswap LRU, zswap_shrinker_scan()
> and shrink_memcg(), own the context and submit it once the walk is done.
>
> Kernel build (defconfig, -j4) in a 600M memory.max cgroup with the zswap
> shrinker enabled, swapping to an NVMe partition with iocost enabled. It
> runs alone, and next to a sibling fio random writer with 10 times its
> io.weight so that iocost throttles it. Mean +- stddev, counters from the
> build's cgroup:

Number looks good to me!

>
> Alone:
>
>                                 unbatched       batched
>   build time (s)                1066 +- 9     1061 +- 2   -0.5%
>   write requests (k)            748 +- 47     596 +- 26   -20.4%
>   pages per write request    1.07 +- 0.01  1.30 +- 0.01   +21.2%
>   iocost debt (s)             15.0 +- 2.7   12.1 +- 1.2   -19.5%
>   iocost wait (s)              7.5 +- 1.2    7.2 +- 1.1   -3.6%
>   IO full pressure (s)        19.0 +- 1.8   18.2 +- 0.9   -4.2%
>
> Next to the writer:
>
>                                 unbatched       batched
>   build time (s)               2269 +- 50    2203 +- 62   -2.9%
>   write requests (k)            714 +- 31     605 +- 24   -15.2%
>   pages per write request    1.08 +- 0.00  1.30 +- 0.02   +20.3%

The improvement is pretty big, but still only 1.3 :(

Is this because writeback entries are not contiguous in physical swap
space? Physical swap allocation algorithm has a bias for allocating
contiguous slots, but by writeback time we might have already punched
a bunch of holes (refaults etc.).

Ironically, vswap might help a bit here, because we defer physical
swap space allocation to right before writeback time... But who knows
:/

Anyway, I'll take the 20% :)

>   iocost debt (s)               685 +- 25     646 +- 26   -5.7%
>   iocost wait (s)               655 +- 26     632 +- 23   -3.6%
>   IO full pressure (s)          655 +- 31     624 +- 30   -4.7%
>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>

Looks good to me FWIW:

Acked-by: Nhat Pham <nphamcs@gmail.com>

