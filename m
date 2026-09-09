Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 019E6C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 18:44:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA0606B0092; Wed,  9 Sep 2026 14:44:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E77666B0093; Wed,  9 Sep 2026 14:44:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8E336B0095; Wed,  9 Sep 2026 14:44:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5AE96B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:44:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4BD42402FA
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:44:23 +0000 (UTC)
X-FDA: 85195099206.20.F08753F
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 611F940010
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:44:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hUxSEqgs;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788979461;
	b=MWTxQidzFCx3xK2urCR9domR/WEkqLtUUuVntEgizYXcEP+oqU6LyWXUwQ5CDVnX3zT7nf
	nAYing2ARSd/mjhIYREXYJPwKMY3vc6dfk91zXIgoNXP8lGysTNrFWO4asrQQ4pSeCYTg7
	9RxzPdylws6dHKIEbYldJJSuH9gdsuU=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hUxSEqgs;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788979461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AtwWC1+qW7EHRBWzjzBbABxb5OjED8iNfu/dXUIcGLg=;
	b=BOGiBKxxmW+39vyKx3rjcO1WdPTmC4hVuqM0BqtV6utZ3TAFnyLs6HqdRHRM7MWeOjLTv8
	OqrpWPxMWEaHKZ17BtOmcuKGG7Ie8aRHrGXWEb8apUK2lpcUk+SV75R/nqzPgMP4zZcYjD
	hHKXaI96A0Z0OitdMkpO5TKjnffpo9A=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-486955ae01eso424198f8f.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 11:44:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788979460; cv=none;
        d=google.com; s=arc-20260327;
        b=btItqAh3+nMg3wimWcPVsTJ2QwuTQmjiIZwwGQpSShCqU54HxyY2JGM2gD+qDZIFfd
         UTxdcAeH5i8WhfIpt6yshcoTQ8PNceEusGSjGWz/vE/W8HQp++yojzq8puJkEG0OYFYb
         o2H6OSVrTJ4mfK1FgOeAYrg766kmziqFv6lsQq/sNx2Cl1hXCscUNEVxn+zhWw8wyReI
         btCKENCWDUmjDvW8Mu9zKyhkgu4MdFWyNoup2wC6h7+Txj5I5TyIxfC9+We7XJVpEuUJ
         DpMd5O4US+IegMZo259D5lUPhCNHFp1vGSXH23a0NRwVJYQKda/FFQWMt9TBDoqiishE
         oWjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AtwWC1+qW7EHRBWzjzBbABxb5OjED8iNfu/dXUIcGLg=;
        fh=iWIH6/CICLNvKrkCJtlc5WmXzWSQx0usE3fn/jqceuw=;
        b=bivLIshg9O1h+4tcRUsQWV4Pa0xWsuMVHc0MuOb0sNyOP3qOtb1+8DhDhAYE62pEwQ
         hJ2jIKqCTvdclkhLQEO/guKu6fml5aEpz80Ekz16xoIi441g33ZlQ+ifnFZwD1ZYQyTB
         mYX2bvvh+5E/g+/OvCYuRHcdAywiL30xrkTmMXCmIOFy9f3uXfsZ3JCu++CQ+cDNevFY
         mRRXBiEJlQdTE7nM/vEpQjS6xA/XiCVD/N153cbjURZ2ZkLZ7r7nxf8l1QlDJ84vI1W4
         jyS/2y+RXmK6DAJckUqrMx9Sr/ABGHw1rv+IH1ljumBLnBv3yWlfyzjP0+5yV1dMs7vS
         NL+w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788979460; x=1789584260; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AtwWC1+qW7EHRBWzjzBbABxb5OjED8iNfu/dXUIcGLg=;
        b=hUxSEqgsXlxN26xXKv27No00OS/TUiERaSJYQAOiMW0EA84JRausafbILRAohC86bK
         +SgzNnLkoEg9bYhBqG5BHNF5GTAA8FaQttxVJGppZelBs5o20foh+wH1BmHSLYi4f1/N
         j6AOfPn6+MHEsfa2ezuF59b265eohJZznGsTs1Gr6xW2oWwPmqVvrQdDQsIJlgE/vUc1
         x0wudZSmRBM/JHMGpMT/6XL3qMJ4HAe39MO/uNs3+dCKaF64qfbGWn+ZqUHB82ilh899
         g818z6mosVdug0gKFuy6W+4r7w62arJZoZGT5rIPh4arv7vciLMvgfcYDXYDBDcDsyln
         plFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788979460; x=1789584260;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AtwWC1+qW7EHRBWzjzBbABxb5OjED8iNfu/dXUIcGLg=;
        b=b8cKL4kIFs7J7L0cB9vADGqy3nvxCq9DC+3KKU/VLvEcZ3aXvGvJRkkjgDx9mGeGcz
         XZ8z/XgrgTvQc9fjc/h9thrz0SFag2RMj+PGYt52g7ZVdhtp8uMm+WTfI6xMy6hFiVM6
         lOrnHWZOdLNuN3zz0iRbBOxco8f44RE5eSln+/5qcMnCSQLrg6l7cX/Wfau+sqR7lMWP
         gqgujfCRO9eOCsViMbc7wQp50EGg326+ZV9189YoDxUvZ51NiUvmLLPOAuVH3ceXbvsH
         molo0MV6AWXGGVQJtiJivwErX2lrdHf4xkWgO+XulZW3OVEeFiuXg9ku39IBx1cLWY7Z
         VFKA==
X-Forwarded-Encrypted: i=1; AKwUvBxRD1LhEKUniAHWlz2zI/VBR7kx3xrB0pN7VksQmivXk46cqclL/xFSXSkg3k4Wa0h8Jet6gcAH9A==@kvack.org
X-Gm-Message-State: AFuF++mSIn0odfmiCl2vVpZt7aI9bnJM41hK99mcm4zuJgmEtvCuB8u5
	9P6t2Xmp17eGEj207UDHNr70h/5xngvMx3fpYBePpGKSdWIDmLTdgk/ZOWWFdSzMzT8rqeSYOwI
	bVQd95Y6rRMlN71oPbppuCDuzl+PtKg8=
X-Gm-Gg: AYBFou2bcDUT0gjqfV+U4IQfURsikxcPugGn1xnPXrzpqwG+Vb8uCAVW1xh3yQPr+rA
	/+K2+4IfJ2L0iQxJl0BMlWJ8GAeYuMuGKp32YaNtGmVW0XNEUH26B2q9TgYVzLvsm0AG55KkDyh
	B6rv7tn08oIqTlD/ibdHyvrycE2HQGING1xGkisF4VVVBDngE+lqhDBbiuJdTPcSbpYp6TipxA5
	Sow6T6UCM+B5lHQORZEP7yVdty7pGuRq/YGwWLlB+nyO3Rnqx1tVYN/lDOPRfsfZy9RT/0vZ+uy
	JHZsE378NuvC+IhFY0W2FR9zmn9YvYB4PTgVxc7vbfTKu6UJUyqb6bLPYns3a5glGUVcnEw9T5u
	PI1K2+rQZbNw=
X-Received: by 2002:a05:600c:3b9e:b0:49c:fc6c:be1a with SMTP id
 5b1f17b1804b1-49cfc6cc121mr333765985e9.32.1788979459824; Wed, 09 Sep 2026
 11:44:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260909161552.2335971-1-youngjun.park@lge.com> <20260909161552.2335971-3-youngjun.park@lge.com>
In-Reply-To: <20260909161552.2335971-3-youngjun.park@lge.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 9 Sep 2026 11:44:07 -0700
X-Gm-Features: AcwNN1U3zCOUDirZGczH6cumAYxCXyzTPc9AmDFeHgypiiCXyiICy9Nt6_R0FYk
Message-ID: <CAKEwX=NHbAvgmyCnV6mkBycDnozJ_Fse=OYXVdFbRC4piN9j1w@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] mm/swap: scan by cluster in find_next_to_unuse()
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, her0gyugyu@gmail.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 611F940010
X-Stat-Signature: 7y6hnzebdtjwbmhutjgfc5eex98gouzr
X-HE-Tag: 1788979461-70870
X-HE-Meta: U2FsdGVkX18ZB7O8mOMmiFxjnhNMfAjhruHT7CjLNIW9h3J/Gg473TNZs0YM836e4CkIATBOywCBbpR3ie5wFQOZPpJG/koNVdf3Hgr94KPtKWJake1QCYbtDHXnXiJU3l6HCmHCSqsbJtft+drezLm0lfxJKgLbDF87ZHeBSExFrMFi+PUxF64nB70+YEKzz0RKNfA20SE9veWhqrfV1kmy1YSbrYyOJy8HIBCDYfR4n3N750B+ZNTayGjaqXVwKvJrQFaeDnzbVo9tAox8PEfE/TYVJwV95V9Yw/Z8BKTRE4Kq5wu051fMOmSdoXp6s8VIilw7HQiKrFWtmkbiFe8vZ+a95nSmxy9PA55BJgYO4lzHBj+l6NAVGZkMUNf1++HuG7ggLG3lafL4N6Bz7JU8SO/+wPEBvqTmaJ9FFtg2+Ytp0a7ppHQyyVj+VLOnvTSntFg2LAjcf1X1M9BThf796BcZJgMmkeldxbbrxNTfMwC15EPV2z1RUNOd1F7EP0MzgDc7eMlkoDcJH9+TbcA4fbkB3JGL23CF7rZqtVmzvoPuag8cCofi2Kjewc3eKI7Zudd0xm0OIjF6RcUN4h8IuyfXeZWTL53rgIwWrewYpia3Qr4vXQK+Mvw4zULD7SeYOU7TQqL/9i94pr3Ho/fdqQXhKvfz5EBUfrli9cMQP7SgkDqLzNUBGQWKcPpJ34hNfOl7KwNCZiVsT0cx1RGmgT2eNoNjetZ5qWvWfxXqcuZ75A4d/G3SQtUmCY7cr/Pf0wK5WVaJZHwETIbEJdVlIVezsVAeJ9mtBdN1dppz2CyVkUUmkRszdbMW2w6JQpWKlVqLySqJ0myR7pqqu/cDh42AxBw4oQpQ4/2HmJh+HMDWEwkiShvsoFr7mlzDWHKMsult893C0oZSsbxb0lJeUkRg2GpHs2tfJ/tdfSk1vn1GnojaFs8BlTTlq05Kyr5yqqPxaDQPtOuNLQ4
 63KGnvsx
 bKpHvh+0AkN6/t56iQRxqvwko3HIXfuVWf/9kadQLFOXdwZEY5ZC06houVuwcd1zVL0J/AHJyvLtjjzEaKJSTvN0+rFqvqgh+9VP5yZiH97tQvXFxY7IGjGVBusnYlDvoE4ePNIzV4OqKEAGRM9NdLwDhLUhDdxhT2dAv9frgkIGi81zP1RqIjmN/4BM1pqzFIscfopYxWPKg1hZ3QVXuE4fUfusUsGk77P2oAoa5KiecsVmQ6PJE7Kvw0r5pchIiR3JB3/BRpZ0tuG2sCUn0qvn41vaNwKKeCrf15jwTISysy5FxKTJe8OsS82XUKSXxuy4tAvSzsYkE3QWmuj3CZ/mogEGeALy+5WTRyhnUFpRdJivPZ2cmprI6EBiT1dp69FYcuoN87nq8q6q5Ubkj6hHreVKb/zwzWD7BR6OZn26xWoFQeM7GLrJ+UltKAsxQMZw4tXwykzVupraO3QRZagR1O3jhoTJ+uHpu0an2QJUcB/PyW1IzUX7kwkekb/W0tJ4WM/pwjuI1+AU2zSK5dUWyRrPFPaT+AWoS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 9, 2026 at 9:16=E2=80=AFAM Youngjun Park <youngjun.park@lge.com=
> wrote:
>
> find_next_to_unuse() walks every offset from 0 to si->max, and swapoff
> restarts that walk on each retry, so the cost scales with the size of
> the device rather than with the few slots the shmem and mmlist passes
> could not free.  It has caused stalls before.
>
> The flat walk predates the swap table.  Slot state now lives in a per
> cluster table, and wait_for_allocation() stops all allocation before
> try_to_unuse() runs, so a cluster that holds no slot in use stays that
> way.  Skip such a cluster instead of reading all of its entries.
>
> Fill a 1 TiB swap up to some amount, then swapoff.
> What is left sits at the top of what was filled, so every slot below it
> is free.  Medians over 11 pairs at 32 and 128 GiB, 3 pairs at 256 and
> 512.
>
>         filled          swapoff
>                         old     new
>          32 GiB          92.4ms  66.3ms
>         128 GiB         157.6ms  94.4ms
>         256 GiB         209.7ms  63.8ms
>         512 GiB         391.8ms  73.4ms
>
> old grows with how much was filled, new does not.
>
> In the ordinary case swap still holds real data and swapoff spends its
> time reading it back. it is tested 4 GiB on an 8 GiB device, where the sc=
an
> is 1.4% of try_to_unuse(), and there is no difference either way.
>
> Commit dc644a073769 ("mm: add three more cond_resched() in swapoff")
> answered those stalls with a cond_resched() every 256 offsets.  A walk
> bounded by one cluster no longer needs that counter.  The loop now runs
> at most SWAPFILE_CLUSTER times before it returns or reschedules, the
> same bound swap_reclaim_full_clusters() already scans between
> cond_resched() calls.
>
> The scan end is clamped to si->max, so the walk stops there rather than
> running into the masked tail of the last cluster.
>
> ci->count is read without ci->lock, so READ_ONCE() marks the read for
> KCSAN.  Allocation is already stopped, so the count can only drop, and a
> slot stops being counted only after its folio has left the swap cache.
> An empty cluster therefore holds nothing for try_to_unuse() to act on.
>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Acked-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

