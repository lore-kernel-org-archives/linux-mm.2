Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98FE9CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 17:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDFD38E0002; Fri, 12 Sep 2025 13:18:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB6B86B0011; Fri, 12 Sep 2025 13:18:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF3788E0002; Fri, 12 Sep 2025 13:18:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD5B16B000D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:18:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9C25E13BEC9
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:18:03 +0000 (UTC)
X-FDA: 83881256046.12.A8B7EAA
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id C1699100002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:18:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gQZeA0J9;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757697481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IxoycGrKzRGs9/QL6SDPzKjKtaL7MvzqWWqVeetLLl4=;
	b=gYnM6eou4yRR2oBKm+n8nKXbtVfwF131ZOn/nsOcxA9S9U1g0cRvCH3Q2ZwYKlrc6Nb3Cj
	GnAH/ji5zTHH/rFC2Z7mQzn8aPxAwfmT9403cU80Y8dChv3ghHIK6YxMRkiPGZX9tN1J1D
	ieAB6g/Jo1U69f15HNbmYAv5LedYfEk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757697481; a=rsa-sha256;
	cv=none;
	b=LPxDumrEH1WUplfU+uoWzRoDP0cQBhdIZ+BrW0npVT9D+Y1zjSpdsjFMQzkX01ThzEylCU
	XDvNB7nWj7Q0BczZAT3tgfIQbvDoAkID/msLLz3l3kKFtsV0le6Q8RgUOVwY+yYM34kUhL
	/uS5sjjklGToguNckNAcxWqfY5Nakhc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gQZeA0J9;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-890e5bb3100so16424339f.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757697481; x=1758302281; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IxoycGrKzRGs9/QL6SDPzKjKtaL7MvzqWWqVeetLLl4=;
        b=gQZeA0J94dhqRLU05QIkMItdAkUCeg//WziRtz2pg+T7Ub1F9Rwi6SQmYADxArQYK3
         s6Xdjids8T3rslHvkfemRWqxQclOoA+Z9SyG87Cs2TQUGxBHddXyEpODHkUyMGCFYO93
         YrzDWzX8jNJRoGAWm6ecNhtVU+67kgVK1/4wk6SJ1FpL1DJ1my4SPGsfOS+TAo/vFpMv
         aVKhHXEhuXiRgiV/gcLBiVDJ906xIXhCaz2ynOKa+T8nIlmc6BfXaLzKdfyK/C/YAm/A
         2bHFHtngtIl+qb3u7iXFmKgPg/70L2Gbc9bWi1s/AAOJ84WWMTgZPUX4htxWctEgeWdN
         C3sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757697481; x=1758302281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IxoycGrKzRGs9/QL6SDPzKjKtaL7MvzqWWqVeetLLl4=;
        b=SynRPtRRP08IiHjC4S680kEKjjtws3jWMwBGI9TIYvefPZXWMCnrZxMstDDJVKdAk7
         1nzSzbOE4tPpAypOkAngvgHrPnbyMh1u43qvj5KIPPYMJ0RmmntxPvZmcTJ9MXFosBJ8
         p4Ac3c7PWHY8TMz7VB/9cAU8PKvUlp59sGihkVgBMz7juuGbZNdHnMcrt5DB/QeAwkeO
         7zmQKEyQK5C+iOdzO0/MemIjxOoB413872spdMiJ6o3hGGGHpyA+ri+Pu/tCZG40Ec9N
         BwYh8xmwRTH5zk/QRSrdDiLN7XKZVetfoE0fzioAQFgeHjniNRMujHvmMEphQ5cTZjsD
         Is5A==
X-Gm-Message-State: AOJu0YwEepddBbF6bdjiqjptFtd0O2FFibjH35ZULKOGRJQhjfokDY7q
	XbMjWT96c9S6u5jvZsbKoN+eciDuei9kuNoSvS+zdPJrZHsHrWrISt1OiXh7aDjpz/ZF4u6DLik
	I7JObtRaDPLNNEjK1fvLvnUKECVTFjZ0=
X-Gm-Gg: ASbGncubYdzsBrpJj0e3RazNgSa1Yl12tL6PAQerLDVCpjejZzLkSGMF4whI2agTwUy
	GGlqhbzcYuTqnzmvJG6ontKYkH2hJylPAjGA/N8MmZqbr3BXTEEBgTvQIGBT8w1KMNOKVg/voHD
	DmOY1Tlbw1/f/irzGj/ahnJI8J+MXaWr57qOZMRDxjO2tLJiiXiy3ch7EmsQ8uS0WK7ME0d85VW
	ihZ
X-Google-Smtp-Source: AGHT+IFK4H9XVovn1wGPxMxrsCcscg/iGtnWP/hW3g0mJvdEjcm1UPwPXUqTSTnpIYzkUqSiE2LIg5N65OMJpLS41cg=
X-Received: by 2002:a05:6e02:188d:b0:3eb:5862:7cef with SMTP id
 e9e14a558f8ab-420a4173bb3mr46512855ab.22.1757697480494; Fri, 12 Sep 2025
 10:18:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250910160833.3464-1-ryncsn@gmail.com> <20250910160833.3464-5-ryncsn@gmail.com>
In-Reply-To: <20250910160833.3464-5-ryncsn@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 12 Sep 2025 10:17:48 -0700
X-Gm-Features: Ac12FXxE3rEVvClbzQKrM7cmqGE6Iqd2PgJQy7xb8lu-dQtSlZcYF-4hgXQEdFk
Message-ID: <CAKEwX=ONB=z3h5VdgoyXj=2PZ1Qpzi9zVzGioGstepHie7i+_A@mail.gmail.com>
Subject: Re: [PATCH v3 04/15] mm, swap: check page poison flag after locking it
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C1699100002
X-Stat-Signature: d8q6h6xqxokbkywcaa1yqcbhcqu97d6j
X-Rspam-User: 
X-HE-Tag: 1757697481-397308
X-HE-Meta: U2FsdGVkX1+zRSOvPePMDZUxptnbEmyVf85FdWaUtxTYRHUjrmMe7Kfw6a3yYvscVL26xotvc/kTR61VXHb3E7neg4J2ujmtR6Yb2WALKYhL3bug+vKlnJlbkeQyQS/HKybqfTRTwwduTnSQe6ZPN7P3357dWvINbz1LJBhY3ag6IEcf4Hkqijj1a2HtwSjHivpYpmaTGrYconnhp1J0ZHf0Zlee+FcdDXkSgj1vBJ9FJSYzZnsTJvxx6rKpNko8C03+cGXT4Q1kdbmkf3FqVJPHKWAz79umBF9N3Kycd5OKGCpxsyWiqnVdt/KtPq6CDCLRWJkTQAJMHhpWrCcsTLjQVT6wAZRjIA6LkGhUQaSyzIUu9mSsWjuPY0mUNIJRB3uUABiN0AI/RCvQNJFJPNyNjsVFVjIXaLjttY4m4FEMk/hRc9JNKg6UKwd4/OlZ+wpWsCkZrtUrjGGsqixhj4IQxlg50uMxABIOslGT0WeCB76TXt8Pdc068VUoArxZWTOapgPYmi34aAF1SLhXM0Ne5g5dcOdbcxpxHYjz2Z2IbhNc2N83cg8T+n7DLIPe87SyeOVRV5380xYbInmWd/IuXwCKO17DD/rMFMFRZRnjcYg0z16Ld0jIRqRMAOJ9qgB7DYIi0P9VuSAzz2oPO4fNgZTvgV5T3JDMMNc2dU7lPr5Xu2ICHxB9chJwwlCazGhnexeQ/xN82CgIQqAqoy3EWm+MN4L+uTbr3ZlbCCikRBWKypfPaHDTI0x8BpSVZF3KHyE3TCYzWc6vZpc4YBFFtZ8FzdwmLesPxg3IBk0N4wdkW6aTPmba4JOxVfkcjWmyDbG7RPnKEbimLRcY7wLDAX5rpDJHn0+I87oAMbXcGb0M/CnTnvK+8Qv7uIVH4YeiHQdJrSgsL924W2XGketUGWA5ietyQpePv4qzKA8cRFbPSo4zz/p9Su045x1XQt5hpGewt2ZaLdJZ8wU
 Gq5LqTbf
 VvjxXdRq5mtC8/byyDGxZSn1HLuuhFrdXzQu0/BrdSvz+ki4IWumY8PB3OGI1pq7eEnsTBkFOk0gmOuwcZ/c28G2CNrFT2YSjDiv8oGgP5rtxYxasMaKHZ8XtFYnkov+bGB0P896S4ICf1egQYRlvcJskOp0HbPrpdiQyZOrsQmTy9g/mtLnEoIdTcj2DIo/FiktZgULqUP+huDtOowxVYIHalucRltm2hFUpiFs/JAw9jDt35CC2WwcVwDscZibtqcpNOzAgMEsyJRfRtil8dwaOrOw3fvpjs2h0Zspk3J4Cbo9R0ndR6QjtA+MhnTOhUpDaxsj9gxeQeVgbmAjhPm0n75R/lJRBZmfyu3yBEDh2jZlIo/nTDkte7lAbuYyRespQ3SQuHM6P02Fu6R8J3gH4TNKIvKtCVJ9bVDXQUFAhOkk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 9:09=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> Instead of checking the poison flag only in the fast swap cache lookup
> path, always check the poison flags after locking a swap cache folio.
>
> There are two reasons to do so.
>
> The folio is unstable and could be removed from the swap cache anytime,
> so it's totally possible that the folio is no longer the backing folio
> of a swap entry, and could be an irrelevant poisoned folio. We might
> mistakenly kill a faulting process.
>
> And it's totally possible or even common for the slow swap in path
> (swapin_readahead) to bring in a cached folio. The cache folio could be
> poisoned, too. Only checking the poison flag in the fast path will miss
> such folios.
>
> The race window is tiny, so it's very unlikely to happen, though.
> While at it, also add a unlikely prefix.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Acked-by: Chris Li <chrisl@kernel.org>

Acked-by: Nhat Pham <nphamcs@gmail.com>

