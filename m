Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AFBBCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 08:12:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 848C28E0011; Mon, 17 Nov 2025 03:12:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F8558E0002; Mon, 17 Nov 2025 03:12:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C0918E0011; Mon, 17 Nov 2025 03:12:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 585468E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 03:12:12 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED993160C84
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 08:12:11 +0000 (UTC)
X-FDA: 84119381262.28.66825F1
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2B44E20005
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 08:12:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U8lok7HA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763367130; a=rsa-sha256;
	cv=none;
	b=m2DhUlDWo18sRMjkXmU6UAGqmiCFv3xAfsRSqA3gDYgptRhv3RWJgCopGwRPWRed8Mm06F
	2NNP7OQD0JvzhRhgNpFDhdxzK6yK6+EHvzoQYS0f4MdVQU+RnYXIuL1HEUGYHxpNLsZhAe
	bXrALJgo/sukE9Ha5mVDLmbe3W6SSi8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U8lok7HA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763367130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XgCAZVnIlC2H6WnCWFpjBgYOcv6yKOPLeCyGA9luXMI=;
	b=A0QP6e3xH6DeaHBSN529cBvVpDspZwbgUI7ATWBl2rXBDkxq7BQAk4mgVmQMCAFjUWEAqc
	cz1NH+bYLbOcglhEyh7gGAnI8A6yb1NyyBLeXPI8JpVRl4TYugQDROejZoBe9g3Zfp03Sp
	uq6gQfdJZPyhIzRgnqKkPqeLYR8Qd7o=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8b2dcdde698so229240785a.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 00:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763367129; x=1763971929; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XgCAZVnIlC2H6WnCWFpjBgYOcv6yKOPLeCyGA9luXMI=;
        b=U8lok7HA1YmDJjIqy83cCDscSnaNgYt5vHJ92GhmRx8/13XLcMuEInMPmxZrNaazMg
         17ELvk/dnmmGPoLVWGmLKn1yVkUu/nvmSnb+YrdHcswXy321AQ3DgwAqjfRv1DKOqbx0
         R8PX4/Pxq7yX/8j5B84laydEUvqwV1mRKyfcaFHg33Rumddeg+LnabmYdUNt8fiWt+tz
         g4ZZ48O4Ctajsp7YUPvmbO1a4rc82jwXv+noXCV6EEzdnfkvZ32GcIgOwA7ll8R6i8ri
         nY24xXqOzfdSDvLEMNE5r2cGt/2XiqaWAdyPgWD3m8SpUac3qavFEgqKyyHquEL7MYSO
         8CkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763367129; x=1763971929;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XgCAZVnIlC2H6WnCWFpjBgYOcv6yKOPLeCyGA9luXMI=;
        b=Zxj787Ihr084O4zTmkAzU/Vv22LtwvxnkP+8+PfDdpfYSoYc51sHbxHGI65QHFnp6N
         mnG7lp5wFr1ogHUxVTMZZrOhrCo6lVP7MqmLuEwPZIsRx85CK6medn6PVfRh9LgWR3S9
         DcQVdNb42cFM3mKWOUdRzCLN/zzord1MiYlWUJSXdeSiCOognKoMw8NTgOT5ouJ6QIZ6
         t2mH6sHKqU8O/8wR2rr8FDdexo6H46dNRygRrWsB+/aPPmj3aNT/x0W94IKxfQwVEDbw
         32uapT6SmdqwNXMisu19N4sofObo7RHbOf2F6LkaXsmtOqnEzvSgh3VDga8gbVXkpPhB
         vvJw==
X-Gm-Message-State: AOJu0YwKwpiyrR+4gsQ5MbeGqbuCLlu38RKbjBe2Kh5tYAZ1SoDR7SUt
	8Z0Pk2v7WAQ6dIHEHMGk7V/ryoYcOxhCtMlVCfm71dgPgJ7lLaPn+jyHGW5vA9yM2zUE4O7kRgm
	dQ/T525bVzTsmsj0iD+CTbVpdRGKWemU=
X-Gm-Gg: ASbGncsJyuXCqWHujlyJt+5GA8EVRD/4x15OHmyE7QBYUK4ykEr8yA/IlBA6uFQgsv7
	fJzvqFyF9AvzOz/mHbRbZh2W2oQGLoXgtHfI9Lh7zZgs/HGJ2CJoa9dof/vUOEqJeezBMgqQcRd
	ehDlKAcVCsxC3Uvn+qFIZhtwAivta/hhRgIVZ2N5GNrH3og8iMhLJXYtTN4KcLOFn7X4eHnj7sD
	JUmqW78Ubd9tuWGv2GRrxVqAQ/a+zPF362L8ao6pbfEhlo5JhL4tZ7ngSM=
X-Google-Smtp-Source: AGHT+IHr8QF0cDxs+vlTdDwahta7o6Orzj28wAbAn1Dzd/AkxYVumEzziVpL1r8+1FfVdkfuu4nPQy7fxGyPKKquEC8=
X-Received: by 2002:a05:620a:468f:b0:8b2:e8b5:1e9d with SMTP id
 af79cd13be357-8b2e8b521b3mr481345585a.75.1763367128969; Mon, 17 Nov 2025
 00:12:08 -0800 (PST)
MIME-Version: 1.0
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com> <20251117-swap-table-p2-v2-1-37730e6ea6d5@tencent.com>
In-Reply-To: <20251117-swap-table-p2-v2-1-37730e6ea6d5@tencent.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 17 Nov 2025 16:11:57 +0800
X-Gm-Features: AWmQ_bkPaqE4eHE0E_7vSkfuNxWarbNXk27NMet-YcDRcMNo3o_J6cYztQJj6o8
Message-ID: <CAGsJ_4yQ+_hDhF-eVoBKVxWmVa-hghfeOf1BHTbZvZ4Woht18w@mail.gmail.com>
Subject: Re: [PATCH v2 01/19] mm, swap: rename __read_swap_cache_async to swap_cache_alloc_folio
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2B44E20005
X-Rspamd-Server: rspam07
X-Stat-Signature: 3opxjkxhhbxs9achm4hyp7bkfn7pyzcd
X-Rspam-User: 
X-HE-Tag: 1763367129-114391
X-HE-Meta: U2FsdGVkX1/PQ7vhd0ZM50NhEnjoFMHHQvdgGptlssJXUl2kDULJ2R2Lif/DrNzcH8QixTL8OsnQjqIPSVnIIutLRWb5G8WnM5FPc3/H/GPIjx5CT0A+BVBG8kzB9pkD1H5TuQB7URQZrE+1GWzbNGzRw6Y7+pnjiXD3VgZas3FAfmRXbrO3hXC+AL3IAmSDA9U8Pqrtq3fviMUL6R7gzk0VTfApnT/Kze6nE1V8PbHABC/yIv4uijY41rfx27A2mkQw+SXSde1pd+fPQOx/fMbVMfkg9B7HlQtK+JyCommI05qtvh4rjq5s5wz6p8laFAOu+lq74d/7Am4ym7NYL2f7pz0iV7VzL6TrAK3IOInD/BmyJOW2bDqOhwBMy1o7LwgQjOnkCMdfOHk4/LbAZ5FZZoFlpJGxKD4bIx6isFnaSWysUGCdz+oYfmyXBtkilFkvAnbfP/8PGu3byOhZl4gBceBQwIB8unUQktdx7zOEE3cuLpkmP3Ccj+j3jkuxXoItRHRU9x3kbYX6LAytaq6q3/Kiu/+gs6itdU0esnJ2LLyVZxuj2KfLGdb8seADxfqNBorxUokOq6zUHY3a6RHxDv13ZyAKHBdXPgO4VbTJd1GTljpnO+X/INf0S1t+EBS0+AXb+qQ1M65GunnB8lw8kEf0Dqqr5T+/4BXgIOiD1x2/nS4Vd8ECAorHi4KLFxNSoA8e7ERwNEUjgh4s1Xom84N70UN7oopWIEDs1vhgK33lOJhqyaKdxw7SF68ph0UZKIf0XCblWQuGEEMlwQAQFMT/Dp43INXRnZRsiHnvPPMZPyTYslJpzv8vWBAaQfAxxhQUn4f30NHOaJBPhCBmNZtEXG/QItWLEDtUfovzTXmTmwK6nJBZ10Wq+gcnnY1LKhQImMHDD+qPY1myrkoPLL0amCkrIy0re83TamIywjDSNh/9113Jnw1+pf3G6U2+saGhhRnF560M/Jm
 LZtXPPWL
 IttxlOu4H+MWi5MmwhaSpeMPrself5+ju637OHdwlyr8gMBgTkAshTzI0FDOdBTLTMPXttbNcEYJCY/ddl7UkM2LdrU2heY+6q60MhkDlrloMflIDHus5yDYFcpo6T4BGdTdpQsTNzygJS2HAnfP8gkwVh50xAMf40gZNUJwGFdlSQB/Fl8u5Y8Vzr9AMHFACvsiRU5lXqJKB6Oh2/oE2ydCQsNu6OhzUAMnOT/bm75sEhHjEbxcpNfynMKfSryeqFOK94T3lZIRg/Ram99yq747hqyf+D0CYbvgYzKFiLKyIQUoifRXy+EuR0OO29AcNeteBhptBpHMbFw2EUCy6nEPZ9ux2TFfh/OlnJiyEt2AYsCphOpZmZ4LTjdEDesHgpeYiSUdP8p65BenjnBZP3c/hIrwxxlkWLcmSQKq88rSJJnGFjsr9IXuhi36tfYO8Tv/6H8r7Y+NQbGKP+/+KuCobmTFg5JDZa16K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 2:12=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> __read_swap_cache_async is widely used to allocate and ensure a folio is
> in swapcache, or get the folio if a folio is already there.
>
> It's not async, and it's not doing any read. Rename it to better present
> its usage, and prepare to be reworked as part of new swap cache APIs.
>
> Also, add some comments for the function. Worth noting that the
> skip_if_exists argument is an long existing workaround that will be
> dropped soon.
>
> Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

