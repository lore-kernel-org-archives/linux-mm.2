Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38549CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 08:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 717C38E000B; Wed, 17 Sep 2025 04:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EF198E0001; Wed, 17 Sep 2025 04:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 604B48E000B; Wed, 17 Sep 2025 04:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B0138E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 04:47:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B32C785F9A
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:47:44 +0000 (UTC)
X-FDA: 83898114048.18.1BD8869
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id E411240006
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:47:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vgHupC5e;
	spf=pass (imf07.hostedemail.com: domain of glider@google.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758098862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qSQBwTY7x8IQoxtsTDFfPaHwMvtropOKYFv/BGH9LuE=;
	b=HqqW2yQLBGnugapbiCAtF6AqQG/P4Q4CxVsNidK+2IpNgLN8KUGYXMUbHujs3enPxtpppl
	q0CDBTTaiXwTD7q4RXKjOu6+L7UL+Y/q8/gRAlJl0BPBU7/K8RzaLzGpEwdh8f0qRQW7Zk
	AgTha/AdA5uTw+BG9pUeYRATN7kHVNo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vgHupC5e;
	spf=pass (imf07.hostedemail.com: domain of glider@google.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758098862; a=rsa-sha256;
	cv=none;
	b=UYx+KE9SA72rXWzkFQ1wkDmk1sok5SNj6Vh+oCDmg8BWcZjMpSy8zVJQitlenxLELA2FcE
	gbs5gJV6r9VawTsHPl6vTRozTrccoPy6Y9mMKOA8Y+2irtACo/JlXpg4Afmrxz4KoDvo9Z
	+thECGUV+l2tYBZmIugIC3L6Crski9c=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-7814871b581so27014166d6.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 01:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758098862; x=1758703662; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qSQBwTY7x8IQoxtsTDFfPaHwMvtropOKYFv/BGH9LuE=;
        b=vgHupC5elGALILkSolXuPRNurBDnWotG90p/tAbzGzXzXTZi6Ol7bP2f46AaK62Mmd
         5x1GF8KyITHb8tlPYnjgrfeZt5J2E94sPyCgbbQ7HgWFEG8qwoCdOcHsmU1jDoAzhoej
         xgVTbA8petxYPaSiCr9AlS6RV2o7MjJaLwfk1IdR90ys5w/o4zq/eMCxJpAZ2htzCRNV
         0sR/jX7F3N5NKzb176xR9cjjwJWgS6uYG6FeDdLCrCEibnvm4beE/ubEP//mUkMTeuXU
         hLEZ19/DaaMX6UkODh9Wm19lIrVbk5GxM56dKNadLymv1/rcsH6GksQqa20eTKfksXwp
         qBbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758098862; x=1758703662;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qSQBwTY7x8IQoxtsTDFfPaHwMvtropOKYFv/BGH9LuE=;
        b=UGNi+x+GJA8z9iMWMx0/9JbwFpglRQjMH1niAXOvnyOaExXv2LR72ZONpU5JeMSdz7
         3/wZqxWARzQlRzes3qIlb4m7ku4ViU5coZViNVjaE/lJYEoWgDSw6gU87T8Bf4oJiVJE
         Cnu4bsy9/UB3SYXLmcMyOLhs62doWfYxqpBpwGT+9TURHw9nS1O7t1U8+a0SrQNaPasC
         0Vv5iZG3bhnyu6ty5A8PEoWpwIn7utdRY1iWbqkufBrGv8KBleLzUajGiAH/aE7DW5Tt
         jCjQW+CbdulV7PIImQhpk0DKEWiwhoaA+HJ2rLpNq3WkkVpv5tzxnRRJmFGHhgzTjhhW
         Jv6A==
X-Forwarded-Encrypted: i=1; AJvYcCUkB/W4oRphfY5NE5sDnbA7csYMyB0DUS/sgbbfDrK/j5vUxBDHEKQ3XlALuaERqNP1qxJWC8qWZw==@kvack.org
X-Gm-Message-State: AOJu0YzLPLAncLVJRIQhP6Wg3S+KLgp4jAh/RrWjANT4dwBq29ArR3+W
	NMRBHJaJf7uADbi3l7d7pPJ9+9ZdVE92CMf0yHxgoIqKY2/DLjb7RXRgnk3sMq+LwRajuCgyrU2
	hUm7UlakgPXDKglOk4tMOckzX93FuY+fHZzxlxeAk
X-Gm-Gg: ASbGncvEfk6BszwcFRITAn2hCIwvpfsDnEFmwvNvyCvaAq+2NXyXYUT303Haz5la1bd
	2HInWIWUk8OUY0QqjmpNEFlxZUa3/BMYap81lS8Y/L4aSYgkjuwZz3AzXusyOxjf+WNdthi8gXY
	q6YmAPfEuX4QThApghRe4gQj6dNpvf0SSbPrXyAickru6XRasUp5tqNZLeS/3YNhwuP2dc/YAqL
	h3Q5dJLe3SpSNB4vuL+o1fPsYlK+xnvRW/yKBDRMKg=
X-Google-Smtp-Source: AGHT+IHQqM5a49OQaZzq5NlAj4f7mo4PVwkO0Od/qpE6zKcTcL2cYsdQMpOPx7K+APxdGyrFaBcGHMy5truFRbrqA1M=
X-Received: by 2002:ad4:4eab:0:b0:76f:6972:bb91 with SMTP id
 6a1803df08f44-78ecc6316d3mr11179046d6.10.1758098861793; Wed, 17 Sep 2025
 01:47:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250911195858.394235-1-ebiggers@kernel.org>
In-Reply-To: <20250911195858.394235-1-ebiggers@kernel.org>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 17 Sep 2025 10:47:05 +0200
X-Gm-Features: AS18NWCHIE1dESGpN9uvlB5H-Nyc3e2nakhbUlwz_P_LJD2Kd7WI7My-Di8UNK8
Message-ID: <CAG_fn=UY1HxmxpkM_YFGbr8W272F_bZgZHKiuvbsUjgFCs1RcA@mail.gmail.com>
Subject: Re: [PATCH v2] kmsan: Fix out-of-bounds access to shadow memory
To: Eric Biggers <ebiggers@kernel.org>
Cc: Marco Elver <elver@google.com>, kasan-dev@googlegroups.com, 
	Dmitry Vyukov <dvyukov@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E411240006
X-Stat-Signature: e46wjcrt4ejnsgdr5ue46y1krcwk73w9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758098862-283812
X-HE-Meta: U2FsdGVkX18WFkkAFWUJjP1AKaNgKhsoBPcoZJDVssB2Exv/cnBMiwYquTJeWPs1X6ijjCnwyNkMJeHz2nhLqnJqHIcB+DxqxwP7sawFN0jVv/4KTpLMP10clKsvihUXoSfRBYOS2ZPCmqlmJ8UE7AJhaKRZ9Y/K2Gqu57zsr1Wjedkva903wLKUusbN1XfuttLPvN36s67DORlY0ootEPdjTZyr3oKyk6eQVTARhhaKdoqq+PUIOcIPh8pRdm8lFt1N3N2Vsdq9K6wm1xhYyBmxw5eOCyqJjlO4Lv70sYlLAMY+L7Y2cGyvYEZoGvAv0++sYBaBRR4jBpZ8SV2mPqaW+oPVysYH1xA+FFx1NdGEz2yblgHdypugPMgREE04QJjzTYzGTEXNOjhDz1nUsdaurjsxTQBjOEHM5A5q4cjxnm+Ys4VRuQZxoOXAleBSuRZVHFJ1BW4gF0fKWHwkDbkaGvWJoH66oLlzlduQ6UztpzZpp5sWFrGKr46CTi+P4nt4USJvWthGs3WpK9c9wXeZc4M6zd5DVytcTTcgnodpoOg4v7cZs5YcYrNVg7E13ivk0aKuqZYVEXu3FHXYTDwfTt8/OOMLoI+ClWZr95jHDmeRvGr/R1oTXct2mKPzqytAnzEHN46CxRkv2vl+4sAFr1DHtdYynWnuSWOeHxEi996EEebKEJwRzixnmp6com0ijBjpeHQ+7p2oK1FyfCavkhbCZiRiokFxMSCb0ttEaxib+qW0T25M+o4n4Rc9ufOFTjD/g3s3rDaSrZYL5D8ZTn19gEhCGDfe8xP/bCSgH9djVqt9oRa7oM+a5F+V4j9iuJGSBKpOz1p62eCHIfh74GSL1PL/mCUBMM0QvSk8x0ez+lXwalzNFO0okOxzikAWNU3sb+pnGRSqtqF/IYifQwZ8crBerWWLaDLOh3EXo7AdiSTzyIhxjk+WnYsxHLYXslKdQjYuje51eHW
 oa/3LfrI
 esfmMZvFCrK6dP7kChIRzllTijWdLbrhSzVZV+mQcTdAz3R0nhvc+cbHlMAhpDKciDnBvona+K2TL6B7Y4uCNGO9ZTEv75nlCP7xdGFlZOKiv9n4xRS5gmzVp/nIhVmna9PQLRm6LeNERpiKLRXp7MLS8U4+6Mwz4N/LFW7S1UBrM1+WQqVUTuCxFtZMFUxta0u52TzUEzbObhUMd67b58hCr6Qmb5PHFvmZaHBi2j+j7i9SidXNN/NnGsJLMZN+RityqjunPsQ/mi86iQRfEK8G47R1hJSue188foig+BZZj0i4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 10:01=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> Running sha224_kunit on a KMSAN-enabled kernel results in a crash in
> kmsan_internal_set_shadow_origin():
>
>     BUG: unable to handle page fault for address: ffffbc3840291000
>     #PF: supervisor read access in kernel mode
>     #PF: error_code(0x0000) - not-present page
>     PGD 1810067 P4D 1810067 PUD 192d067 PMD 3c17067 PTE 0
>     Oops: 0000 [#1] SMP NOPTI
>     CPU: 0 UID: 0 PID: 81 Comm: kunit_try_catch Tainted: G               =
  N  6.17.0-rc3 #10 PREEMPT(voluntary)
>     Tainted: [N]=3DTEST
>     Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.=
0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
>     RIP: 0010:kmsan_internal_set_shadow_origin+0x91/0x100
>     [...]
>     Call Trace:
>     <TASK>
>     __msan_memset+0xee/0x1a0
>     sha224_final+0x9e/0x350
>     test_hash_buffer_overruns+0x46f/0x5f0
>     ? kmsan_get_shadow_origin_ptr+0x46/0xa0
>     ? __pfx_test_hash_buffer_overruns+0x10/0x10
>     kunit_try_run_case+0x198/0xa00
>
> This occurs when memset() is called on a buffer that is not 4-byte
> aligned and extends to the end of a guard page, i.e. the next page is
> unmapped.
>
> The bug is that the loop at the end of
> kmsan_internal_set_shadow_origin() accesses the wrong shadow memory
> bytes when the address is not 4-byte aligned.  Since each 4 bytes are
> associated with an origin, it rounds the address and size so that it can
> access all the origins that contain the buffer.  However, when it checks
> the corresponding shadow bytes for a particular origin, it incorrectly
> uses the original unrounded shadow address.  This results in reads from
> shadow memory beyond the end of the buffer's shadow memory, which
> crashes when that memory is not mapped.
>
> To fix this, correctly align the shadow address before accessing the 4
> shadow bytes corresponding to each origin.
>
> Fixes: 2ef3cec44c60 ("kmsan: do not wipe out origin when doing partial un=
poisoning")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Tested-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>

Thanks a lot!

