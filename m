Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ABFACAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 16:35:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D670D8E000E; Mon, 15 Sep 2025 12:35:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3EE98E000B; Mon, 15 Sep 2025 12:35:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C55058E000E; Mon, 15 Sep 2025 12:35:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0DA68E000B
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:35:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 61E9B1606B3
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:35:35 +0000 (UTC)
X-FDA: 83892035430.21.BF412A9
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf20.hostedemail.com (Postfix) with ESMTP id 814C01C000B
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:35:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m4NGgNHB;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757954133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kaS+4e9CD9qq/qcfYA/NkZS+Q4I1Jtxyn3M0VBK+Z8M=;
	b=aKNO5SrD1adb2rvFtW3vOJTaFbWUJZn4DIjFJ3HD1ecn/OmTqKxnK8YAaF0+eE4BqggtDY
	YVnOsCve/a1TKAZxFPlyL4Gz6yp+pjKvxAc29izNjmqQVzm4VCFO2gf68zf8CaQMsbJlSD
	hSKaSDcWXJ5pD4Z7JoTLftd3AwxvbNU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m4NGgNHB;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757954133; a=rsa-sha256;
	cv=none;
	b=HPdBmjZBNOJo6yaa2flyLMXdSUShx8dwXgqXEy1rrZCBttx0d6rkQWkFLWuHwMlpL5hLgp
	zjr08NVTbHL/zGt/EKZjfiE6XsZHoUKGrxI15A8Vmcik8+MiEdMH5EVAyd4T1M3IBEiISg
	ET8vvQZA3JOJ2kOzqPhpeccGeJUBk3E=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-62f330eeb86so2332611a12.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757954132; x=1758558932; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kaS+4e9CD9qq/qcfYA/NkZS+Q4I1Jtxyn3M0VBK+Z8M=;
        b=m4NGgNHBqUcIcJHgWdJlOnuJYDNdNyIEH1i8fVUw0spm2+klcNKhAfV2+ZMahfvw2J
         Yq8W2MA4XAJS6LTb/IyNegnU55ihY0Xs9X4uwRZEpP4CN8q66aQoCdX8KR/16no+qfmW
         kNYU4CppypvD489QGV7oEcRqyVtcMcXjBidL0OTHHNF/jlTHcbT5tVYfq1ROwV7JBhEO
         2I27woB2sel/254nB/9QsaC5HjG9iYAcK1KFr8w2Um+Tum8UJURCW1G38BzDqPWyRzQY
         mpvLL35YcPe8nUkYoEG0GpguvBeFgKwAVv1ZR/m34OwuyXQFmMyH0gjmnZsdYIkh5cXi
         8nqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757954132; x=1758558932;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kaS+4e9CD9qq/qcfYA/NkZS+Q4I1Jtxyn3M0VBK+Z8M=;
        b=IawOpCheobs4Eu/CfPONMnaJwmvN0rEIccTiNMEHbwXFb7Hxn8HV/f3k36y8aZRsQL
         XRx9jJ/x6REdZRUT4cHPErN/KHgIrx4QYSS6eBj10BTgeszSsTMuJSZnbVbJzpvprnk/
         hjjqndCJO0Sjy5otWn+B7wG1QH1YRuYiYvYQSnZxsiykLd/KR9XC0Lg0c9Doo8vkguXn
         cqPhWBaY84l1ZAZADPVAUuDUkuM14wVyXwZ6BkBKUNkOUp1svE+Fo48Yk8edMd86ClfT
         1HlnsL2f6QRRNrplgAg6BXbgdqn6yPyA3fgPYBzkGtd6yLk1yNSnBWk3eBwtw3hSm2AG
         Mxdw==
X-Gm-Message-State: AOJu0YzhA4ZasFbi21jTfx/Urg+RM08qO4zQX3mz8CseA6dYCvteyXzk
	ZsQ73AYXvXWY42jhlDMZWcUQeoE+SjnV+mQkzvcaQr9IHEUl+t3vqDYnEmLBoeRDwq9uV6TYUwm
	+faSW6pk+0Sh1E3DRJZlO6Ao+luDjNig=
X-Gm-Gg: ASbGncupUiVYK/UWqwteIYKCAJbLfkMXZN6ESwKvqXh3B3C/X1uzSwkCgVR1DN8A6QJ
	jMkN3WaHEKnF4DHeb9ZGuMYGa3YraOdljKrPWxO7/IXGTy28qxZIjvwwVUO+Pg5yMoKxaGMuR6L
	9APupzB9IUBO89fkTB3PL+qi0BVnya9oN/+HcoWhb4AWOxE2mvmjg5J2KWFJMrL0uruSnwS89cZ
	fun3m2wmTBN/DcT0pMruw==
X-Google-Smtp-Source: AGHT+IHVXEBwPC51SnFdwQUYw9y7HhXwNvoyENyaB1Bz3o6IJeGXsQsiMQQNhelK9xiWwWQe8BzplsMVrUd6qgL2l6M=
X-Received: by 2002:a05:6402:1e93:b0:62e:dd2b:b700 with SMTP id
 4fb4d7f45d1cf-62edd2bb931mr11812400a12.2.1757954131625; Mon, 15 Sep 2025
 09:35:31 -0700 (PDT)
MIME-Version: 1.0
References: <20250910160833.3464-1-ryncsn@gmail.com> <20250910160833.3464-6-ryncsn@gmail.com>
 <CACePvbX4juhR5jry0Bi202qo=nfFVZkztHzo8KxKMW_yKBseyA@mail.gmail.com>
In-Reply-To: <CACePvbX4juhR5jry0Bi202qo=nfFVZkztHzo8KxKMW_yKBseyA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 16 Sep 2025 00:34:55 +0800
X-Gm-Features: AS18NWDf-XutQXVyGUmemggoHy9lplrAX8RvyMvG0-69Mvw2smNEDJTjC4BRwgY
Message-ID: <CAMgjq7Cddet5BQorsc5gaLbNKJrZhCwi5qifpHz=sd6gb9dQ8g@mail.gmail.com>
Subject: Re: [PATCH v3 05/15] mm, swap: always lock and check the swap cache
 folio before use
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 814C01C000B
X-Stat-Signature: jdpgzfs6fzd5jbiuy5dcnngiwh899ra1
X-HE-Tag: 1757954133-370201
X-HE-Meta: U2FsdGVkX188QbZDVU4b7nIUGoH6/kr64/LLT1VEtdg68zaKyxrK1FNllSo+IavQjHUfOn99lnkwo3IYfgZQaMttSq67v3gCLnuDGYTvRMrX2rpl9jiZnRgW2IXcude2VauhMenZQYdHkE6k0xgw87fXOKerAeDOyHg0m4zjRmnailUTlaRlaMtGQ+GPlSNi6782y1e/1YpKZGdS7iGSEoyJkqQyjhV3TrlKL88YyR8ZhuewJcbKfSTdfX6hJqOYlRJRaX6+ucNqUFG0/D8QA3CBuayvdcL5mO6zaV7T9FToh1iO6+URcbLHOIel9twPrYpS0lkzDFhlaf0Jj2fztA29fAiOn51VnPiOditLMdrH0AmzGiR4bbLF0ExNBqSAHuvd2LZn7OVQHu1b6ZQPlxZ8EIhLa7zmLxydzYykDCDIvBDmyTrFukJZYetqwFb9BAP8T+O1lJTtgbnU1BG6tgR8pkeIgipMVBt4ws8TiplFmzMAmLtkx7Yuf0jv4tmoR/OK655jJ4GZpOlI/mbT/w/OHwlFLQboHCDQI4S7bhZtKwv4NWsDlGTpabX08qhvkaO4HsioS5r4OI8Afiv9WNoySoTX0Hm1P5+We9JArHiucbvPjL/G+g0HNkl28TYI4afflTjOQ5jF8GNwn413Z9ZDpFU27N+Lo5R5GJKTbTxhwQQ2aZcIgwhZ5Mnxy61G3uz3Tg/CTr8XWVME1uu6OKlm7EBI1gnztY7ZZNZTjScgD6pMVIXhQ0OWI0R/FP693UgwS+en0QHdOT3SWCZFMLIQk9H0gFwritjHvIGrXEbU+a4TbRYP3W8kSHdcE/4Ir+jeyhjoFOPB/d4DotFAYcsLA7pvhFOUiieTDbNJZgwqXn2go5z87354oOll5MI4U2wsJo0T6DsjRcWvx5HQQbEdCxBxZdNP7QiIA6BsH7I7LIAUwefrLZ/HIobEnibtDqc8WnLlcWrKiqheHFj
 +KCvfE8m
 2LF6vK5+rAAWs9jV/Y87BvObjRoMlxYL+5xEp08AqsZtyJ3fFwhXmaNaMcYw2x/E9DTT9yYmAu9Ejgs2nTSUDy089riJdZZM3AHgqQ3a2XItzSAeGTm/H3iJU5h0g2cBmkYHbYkskjKXaKK53Ua3UtXpTrQ2akKiPzI5KNtn1QRo205dMkA1zFx64m/vYPy8yKb/LDCc4kfsi735wlj1rHdbOaSZ+8K7+C3N/T7+IsJd/b2uos1JLUCDcNRQqZ5icWIu3r6njnNVxhgbK6qzRt+9INU47qaqix9zA3yot7WPFtreE7y8hrnQbB4yuTJsNIFkImm6Ci44X2OrODqAc5oswD+4gn3ENu0Dj6Feb+epn7f5ii0e0flVx1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 11:07=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote=
:
>
> On Wed, Sep 10, 2025 at 9:09=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> > @@ -2004,6 +2002,13 @@ static int unuse_pte(struct vm_area_struct *vma,=
 pmd_t *pmd,
> >         bool hwpoisoned =3D false;
> >         int ret =3D 1;
> >
> > +       /*
> > +        * If the folio is removed from swap cache by others, continue =
to
> > +        * unuse other PTEs. try_to_unuse may try again if we missed th=
is one.
> > +        */
>
> It took me a while to figure out why we add a
> folio_matches_swap_entry() check here but we don't have an existing
> check for folio swap entry matching in this function. Can you confirm
> that if a race has happened causing the folio swap entry mismatch,
> then try_to_usue() MUST try again rather than "may" try again. It
> seems to me that it is a MUST rather than "may". I am curious in what
> condition the mismatch happens and the try_to_unuse() does not need to
> try again.

It depends, I think it may, because: for example here we are unusing
folio A with entry S1, and a raced process just swapin folio A then
remove it from swap cache. If the raced process didn't swapout the PTE
again, then there is no need to retry as we are dong with this PTE.

There are many races, someone else swapped out folio A again using S2.
Then here we will see a !folio_matches_swap_entry. And that's OK.

But there have been many other subtle race conditions in other places,
e.g. another folio occupied the same PTE and got swapped out using S1,
causing PTE =3D=3D S1 and here got a wrong folio A installed. This isn't
happening here, because we have removed the !SWP_WRITEOK flag from the
si during swapoff...

It's really complex and fragile, so just make it easier, check
folio_matches_swap_entry and abort early, is safer and follows the
convention.

> BTW, this function has three types of return value, 1, 0, and negative
> for error. The 0 and 1 are ignored by the caller, the caller only
> cares about the negative value. Overall this unuse_pte() and
> try_to_unuse() walk feels complicated and maybe a candidate for later
> clean up. That is not your patch's fault. I am not requesting a
> cleanup in this series.

Right, totally agree, we can cleanup the swapoff part later.

> With that Nitpick,
>
> Acked-by: Chris Li <chrisl@kernel.org>

Thanks!

