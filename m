Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81DDF606A880
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 03:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mjy9uP/C
Received: by kanga.kvack.org (Postfix)
	id E56086B00EF; Sun, 15 Nov 2026 22:28:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06CF6B05B0; Sun, 15 Nov 2026 22:28:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCE716B05B1; Sun, 15 Nov 2026 22:28:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C2E96B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:28:46 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA5B8A055F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:28:45 +0000 (UTC)
X-FDA: 85439550210.29.15BEB03
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id BE17D1A0006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:28:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="mjy9uP/C";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794799723;
	b=xg2smHZTB1f+8mBTC9ywStHE1T0/svm4BDTRWer6B+bdUI0NlfmxLPnkavXhlvO7dmZeOt
	7kFoZnCDjxXJyXBIky4JcIl8BrKqQGiEb6eZpx86MRCJuvwhMMqcH+Kg6ClTvVMkC1k3zy
	j8DnmZdVwNmL3UQALnxYf3j+FVU8mq8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794799723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5U00VX/qcVSmjL3I17CsWerlchOit9RVm28tV2i6Zg=;
	b=Xfh8Dc44RfZEG81keneCa937xDy6O4GIUt2tELchp7b2rbQKZVwKk4MhdKAlzmtV56AAVV
	IaJEVAYKFZqptb/ZVXiC2Yqqz9O/on6BtrfL51sFl1oLRKDUNh3cJC54AqIRatU8zsqeCJ
	0iY/FWMYCo9XsPV6klL0sK71MFVpg1o=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="mjy9uP/C";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c40f29667e6so527404066b.0
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 19:28:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794799722; cv=none;
        d=google.com; s=arc-20260327;
        b=G9zZ4rfOGHJNqkt3MIY/qlAy8XFLSeYMC27k+iCBAWAmWUgl3daqYdz9uFSWa2eX6n
         POZW+2zc8NYYIbL9AifOkw0PR26c5hBQycZFn2NYfHvU0PZteZOxtBfDFJwjOkbv4y/y
         ACpDAxbbD93fGc8T8Bm9LIBz3INPC3gcoFHjbXKdunCE8FVKOI2EbnPeqzPnbK5RpfnP
         Fmd33Xj0lupa1FjR0R22ImVdQL5v/br0xBiE1lo8TkhtVcG8YQXbEYQjkCMAM54XqIux
         Bhctmee3MbRp29eypRJ8mD35lfspzag1Sm0N8mFhIxCu20+HoTlteLMhxguKC//DtPJD
         hzcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s5U00VX/qcVSmjL3I17CsWerlchOit9RVm28tV2i6Zg=;
        fh=K8IzwvHccnlfuxUYR3s10EuwPZQn/CC9/VrCpoXAJtE=;
        b=sNriy9EH4f8zKofkul54b+pCkGNQ0Lhwjh2byNOzqLFssi4g8ZYt167KkDkNsItsTL
         dh8MPZTcESlKksuWQ5nB0FnEYQ5N9w5Kbo/zOmxRfIpCRNrlqYYscvxtJtOhfy+IWCX4
         KGBEmX4V86uigwL/l98lxv6nOsZf3ZQabRe1tMMsICA0nur8pxnfhomPAH/YWUpx3LgC
         JRwesbSj3Su7anhgOdENPcXGVcupSyixGXlACHNqhQmv/q0eTVh67qneagdSDk4jpVtC
         bnMkahs6nVYuBKJTnLi+qvRL0U1zgfcAiv6FfApX9qnoQ1yvJ/AUsV4ElsG8binLk6bs
         uG/A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794799722; x=1795404522; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s5U00VX/qcVSmjL3I17CsWerlchOit9RVm28tV2i6Zg=;
        b=mjy9uP/CWHYmiYy3k7dinYMXlk8LUCN9QzU4Kcw72aFlaL72sk8WX3O1ms4LSnuzAn
         ZzwKHJPxM6y60ml/D36RrFIG/OrmKCO13/2KTHHJqwkQAPRdq7QN4ZCCx64e/ElU1JE+
         6Hwvd/qXOHCEg9RGnv/KJpuxGBMGaL57AmkDEge2J1G+0QmuntVRj1RQr9R85OsVyFZq
         t31AvjGdEJiYsIfbZmyzo6IMzZZA7HvxWOQ/e8j2noVWIbH5FTdzds4xO7oUkEz3Jj6y
         5m4RuIOEw5usBaFlfbq7Xvv1sELQ3WG/vqpn0ZieMYtRrZsE9F8Fod1xdBq8l9b6zjmm
         9WzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794799722; x=1795404522;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s5U00VX/qcVSmjL3I17CsWerlchOit9RVm28tV2i6Zg=;
        b=G35TP3qNCFvVF2GViqWRjbTQj4PM/gb/idxiV/RD6wYHEeqkhH0OcBJ4PzIDoN9oSK
         jZXqO269iuuLbCMl/cK9pkfAqG6PoXEAC+X1su/RBDU3kGt5k71SuMK+cFrSVD0Qy60v
         qwCmyP+obBL/PG54ZKQmlS8XM+6pDA1UL/6gt54nIVbcmYRkLxkdSQvuVoQ6LdpsJ6/1
         c/BaxW7HMj5CgeBmtQuHSbHP5w0ZpCp+Xc75HPsMRRrOeod9oIans4xWPxBzP3SMqjbp
         5OcpxvNpezusKsakHtPUE+y76n5oD9yAv+7727/xuzh/GIw2Z7cYsOTW+Z/GKuIEqSg0
         +6Sw==
X-Forwarded-Encrypted: i=1; AL+hErF44U15s5PUEOZwDRnPxLgxEY6W2PLmuHqU8h+rbPhNDSVfS5w+YF9GQerZ0K+v2P0Gzck+Rhe9og==@kvack.org
X-Gm-Message-State: APuU4Z8XLxdcYOLVU6EugrdLZnTIBly/60HSO5ZXo4cn/zB7c9H2XVBv
	d6OTb8W19VfWQBP2LCjka+Cf/wMKTrSseOlNQhFM01KwT8YhYgkWRnCtZ4luHrStHIpFrUfo6df
	WE3XhIp/tivbKHqQBGonSU5roq1o/enc=
X-Gm-Gg: AYBFou0Ey/Pjpn4e/UYhUWINUtxujaTY2mm6cQiAZPGKTea0r1u55k1T2MyNk8GoUqP
	RIuGHq6HuqvGDDVMS/N4Zj5YN7c2DGOlMTQMlaCxNFdaB/mRL2POYaHTBCgydzb2/5vAqG47+JM
	pDbwhtmCvhM6bYt+Q4Ssxhl9UxKmHIAHbS7FOyrG8t4yXcUSaP1V73qhJPJuCZx+wvh1G5iwsaZ
	LfrxbQDtAycG+KdERqCxkT5IitKQB7kL7pbzgSJ8lrpvqcy4Vnxo51Lo5HGXjNYUEsj4jgAbQpq
	gs7f1waewhwwH3shwFAMkSd+UbjoOe0qsNf+BDI2iOj6qeyQsFOpgZE+jvhY5a8AO+CQiqlR1rx
	SzVoJZq+bCPutK/0xIQuqqbr7jj3wgL9ulkT/NuXpXimn1IzzLoA9i9A6AyjvLtcgfu1A4A==
X-Received: by 2002:a17:907:2d89:b0:c46:8063:220c with SMTP id
 a640c23a62f3a-c5096398047mr695900066b.11.1794799722075; Sun, 15 Nov 2026
 19:28:42 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261113020132.274013-1-hui.zhu@linux.dev> <a72af87a-0f10-4717-9d50-2d3480c32caf@linux.alibaba.com>
 <1c6137c0-297a-4993-b386-6e8a1824d8dc@linux.dev> <920ed3c0-42ee-4268-b8ac-45981645ae4b@linux.alibaba.com>
In-Reply-To: <920ed3c0-42ee-4268-b8ac-45981645ae4b@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 16 Nov 2026 11:28:05 +0800
X-Gm-Features: AclHuK9VrfjiTVFQsnwuS3MN9c8lYgnoiUB65bCJr7GRkF4PaqhwmwlukZVpQrk
Message-ID: <CAMgjq7BYb9XmQWrZn2+omY3B47-OckL4XvO_rCyf6D+qzCdzqw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/mglru: yield the lru_lock earlier in fill/drain_evictable()
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BE17D1A0006
X-Rspamd-Server: rspam12
X-Stat-Signature: 7uuntp6x7gdqiemkh8hckeq88z5eq9e8
X-Rspam-User:
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794799723-391081
X-HE-Meta: U2FsdGVkX18Bi/ClxaKZS9TWcWSDD84GTHP8BAHM4DXJArp6p7gV9M+g5h3ekL6WRaBnpSDDLfp+h8ok1a5tJh9gYjTqSTbJ6TmES96mbdAN570+SEdVuc7tg19FJWV08hWYvjVfTqRDbI00x9e5WTHeUOzn3h2Hqwxo5MPbZ+2QDUFubOTCCVQaXN5j/8ZLtxFj/FL4wsJZHxcbRG0ijidGOSGDiMYvSXhj7vWn5ArBX98tSVBAHoL5BOfmyo5EGcaVHhF/TzZ1tUesjCixvf5wOg3w8tf3rEiuxCZAgHgdhpXKLIIiCcGFlsy0q0NVDkbqMOSsiCGnpYLDhYWxXfWMdV6ysN1Wq8PkY9ftcVuwTyxIyuf3jx8Bv3TVV3enbwKZ1/qC3LjEnupGYjd3uXsam2ch1EWWweGpUESEAmhDnsDLu6fWlFCYUIxpVsAo8cuPjPUO+X8rrzEFCsgjnQnnoiJz7Nm+HukpcZT7+OBk/VFoGNo/zDuGGIrfD4HijDrSgZ/8e6JFy9nC6cImrT/0+juLry+cBUAuiaxtyS5TP+4qQgGji4CPw/YEbxZmGd3puPztjGaa6SNwrPCU6S5Dl4ekL0H+NRbIjZREujiMQzLa+XPaUGx+HDnImRAqKYae4N4xJcCDhsXz/61DdZEGFevm5eQPy2JAiJcYKNLBg5Dl3mTU1219PrjOfmSWXP6NWa6kKqHxTCsrJGIEQh9csGWyz8RUZBO9PPU816irjupWDb7fL5DznuGjgWkrEKLyM7fGSBh02Di/fr/6y4qYWf6B+jcrZR1T7Sg53UfgsfBNpG4z8hRYr4f/vD4mtfHQ1cC8l9p2LZ2tjZ4KwV2ySomOIhFHzpgpMz2PEc4DlniFCzaSgzHQwjb042z1CnqpsGI2enAvXKd5XO7dDs3Yuo4xV704m9bZo2PcYCmH5HIySq3O53IxyktSh+Wq2LD8AbH/mwomQzADEB3
 x9u5Mn92
 902QnQL3wg218MJxsggyxu4uCN+TAJdnc+IvdkIBqwgMq1QxWjoViutwSpNtli2GgRgqwtG2UQDDKQivG+KaFV3joNOQ+E7HaSDv5XxkU6XkHtrng6Mh0TFaKhOmHfQJpckegcwrVEOGSJ50u8Tac1Tt2Tktrl9KbiL8ORTnC5fIgUXkcyyt6sigXNxWtZIMy6EQXV3akD+Asgt3GZtSlskRsNvzMmJ8jOu66yJYx4ezhp+Hwjkv5jr2aMkDaNsN6CeVF0n5r0T9OMp2gKkf9QUSxcNtXfYHF8W4lt3rE1VnqbyrgA/LZdQIGvtW6DHK2K6BY1gMI8oxeXDGHvze/8f54IXQ3cscilT5Ze8nmsrD4X4rnEziurUsMPy1P6EBlj3fdwvrK5w031BCysb+wMRP4EKC7c3mncz7jC9nWnE7Dcb7y1ed6onp8L/oTf41+1YUru+PVH6sq9RNUeuhiPDMqrosgICiOUdRyBgwtnjl4HbI6vaPp2bI+LmbSqqqkMZzLxRpNl/bNYj8PaZpwaJrc/nBYC6MGPJKPT6Lkz0XiN9QOLd6t/CIDdBvF1OpN64tK+ZqAcsD22EhsIPoPOhS0Mx0OiV2SP5K0T6dElh3IWj7bhM7oxanXPh2bKJtvcoXDJebgSQPRQfC0QTFNIpH01nHf//xvDvsVBANRjACytFQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 1:19=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
> On 11/13/26 11:08 AM, Hui Zhu wrote:
> >
> > 2026/11/13 10:50, Baolin Wang :
> >>
> >>
> >> On 11/13/26 10:01 AM, Hui Zhu wrote:
> >>> From: Hui Zhu <zhuhui@kylinos.cn>
> >>>
> >>> lru_gen_change_state() migrates folios in batches of up to
> >>> MAX_LRU_BATCH (4096) folios under lruvec_lock_irq().  A full batch
> >>> keeps local interrupts off for up to about a millisecond, and CPUs
> >>> contending for the same lru_lock spin with interrupts disabled for
> >>> that long.
> >>>
> >>> The caller already reschedules between batches, but a batch itself
> >>> only ends after 4096 folios.  Stop it early when a resched is
> >>> pending, or when the lock has waiters and the current hold has moved
> >>> at least MIN_LRU_BATCH folios; the caller restarts where it left off.
> >>> TIF_NEED_RESCHED can still be set with interrupts off: a remote
> >>> resched_curr() sets it directly in the target's thread_info. The
> >>> minimum batch avoids lock bouncing under sustained contention, while
> >>> a waiter now waits ~15us instead of ~1ms.
> >>>
> >>> This follows lru_gen_look_around() in this file, security/keys/gc.c
> >>> and jbd2_log_do_checkpoint(), and commit 6e9be217a3ce ("mm/mglru:
> >>> use a smaller batch for reclaim").
> >>>
> >>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> >>> ---
> >>> Changlog:
> >>> v2:
> >>> Also yield on lock contention after a minimum batch (Kairui Song).
> >>>
> >>>   mm/vmscan.c | 10 ++++++++--
> >>>   1 file changed, 8 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >>> index 6a1af9b92349..c1231925159f 100644
> >>> --- a/mm/vmscan.c
> >>> +++ b/mm/vmscan.c
> >>> @@ -5533,7 +5533,10 @@ static bool fill_evictable(struct lruvec *lruv=
ec)
> >>>               success =3D lru_gen_add_folio(lruvec, folio, !active);
> >>>               VM_WARN_ON_ONCE(!success);
> >>>   -            if (!--remaining)
> >>> +            /* stop early to shorten the irq-off section */
> >>> +            if (!--remaining || need_resched() ||
> >>> +                (MAX_LRU_BATCH - remaining >=3D MIN_LRU_BATCH &&
> >>> +                 spin_is_contended(&lruvec->lru_lock)))
> >>>                   return false;
> >>
> >> IIUC, Kairui's point[1] is to just drop the 'MAX_LRU_BATCH - remaining
> >> >=3D MIN_LRU_BATCH' condition, no?
> >>
> >> if (!--remaining || need_resched() || spin_is_contended(&lruvec-
> >> >lru_lock))

Right that's my point, we can keep the checking simpler.

> >>
> >> [1] https://lore.kernel.org/all/
> >> CAMgjq7CUMuNSdCXZ7_kDdo9+0BFvPNHuO=3Dmq=3Dct_Q5YUyyckvQ@mail.gmail.com=
/
> >
> > Not quite.  [1] was about the extra `moved` counter in the version
> > discussed on the v1 thread; Kairui was fine with the rest.  Since
> > `remaining` counts down from MAX_LRU_BATCH and one call is exactly one
> > lock hold, `MAX_LRU_BATCH - remaining` is the number of folios moved
> > in the current hold, so the condition is just `moved >=3D MIN_LRU_BATCH=
`
> > without the extra variable.
>
> If so, why not just set:
>
> int remaining =3D MIN_LRU_BATCH;

...

> fill_evictable()/drain_evictable() are really cold paths, I really don't
> see any practical impact from this. At least we (Alibaba) won't be
> dynamically switching MGLRU state in practice.

I'm not sure about this either, but if we want to reduce the lock
holding time for the cold patch, setting the batch directly to
MIN_LRU_BATCH seems cleaner. However, combining this with the newly
added checks, I'm unsure if we've become too aggressive, potentially
causing the switching process to take too long.

