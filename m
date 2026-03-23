Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11806EC01A9
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CF3E6B0089; Mon, 23 Mar 2026 05:17:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5F96B008A; Mon, 23 Mar 2026 05:17:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BC946B0092; Mon, 23 Mar 2026 05:17:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B8476B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:17:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05748C31FD
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:17:32 +0000 (UTC)
X-FDA: 84576774786.08.332ABF9
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id E13308000F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:17:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kTatZW1J;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774257451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ATgLsjCSGnGevYK8QWN2NsmPqAQpgw61X7qv/GD2mcI=;
	b=hHsooXm3mn1tAIJxNd719zorweNUIUtN92pbk8J3NkNpUPsHnreyuZVNBNtue/H6aVqq/P
	JYqTyZwZdDFPKIA7QbL87c1QRDbAxV5TpYX2cuWAgC6PqN9TOmpymh1r4ll93U+qD1YA5M
	AZFLLyKdoQ0RHRHZ1jtPMte37O7JLOE=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kTatZW1J;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774257451; a=rsa-sha256;
	cv=pass;
	b=lyLBAXxtgETF0CEyOEdCRksuTXQueQMwQrBc3ZGAZ3nqRQS6f7TWU4FJIRVbszKCEW6OoY
	JOpnO8wekCi0l1VLzdjM1fFlkhvj7vn414WS5n7dCUboWjhHJooy3twxuwFzVyREBzwpYz
	pjdFJoatG3DEDp4JlkSQKiGTmO8AbqY=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5a277f77876so196834e87.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 02:17:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774257449; cv=none;
        d=google.com; s=arc-20240605;
        b=j7wFABeTrSB43hbQeberB5CkjcTSil/MSkBVpwJdf+ePZ8P4miMvnZFewB79tAqHFa
         i478k6yYa5Ms0HHQrijCiwZZMHTx8lKOS+hLohqUXjYJqcyd3R9fj3eChLU60t6voF0r
         tBHoXmiq1FbTa2FwjyBJqFFsskST9xeNbnPK+otn/+RxZEUGbSTZdYLLYk6vLjJRoRDf
         JYDzAQtjZaAF6Kva5wczeyEJTqYuuFx4vF8/+k/89ybALfu2Jw605P9vl3NfW6qEB6MC
         wrfOt4TmwtViGTNLmycf+lblaWrHKuiTUUzMDcXNhg0g4tawCQ/TAmbKNoCbrq4roYkM
         x5TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ATgLsjCSGnGevYK8QWN2NsmPqAQpgw61X7qv/GD2mcI=;
        fh=5QF95t8qGvsuBU0a8UxnojzFI/u8AdjTblpTaJhHMhY=;
        b=PB0Ucha/Ri8eNUn29mocmITeV9wKObV3cGM1sWziBo31Smhvmn+AJ4H4MSWH/uYZLP
         I2vDrrMC5H2EAPeBQkyAVhhlyFBcneGm/EGxLnIWubU5ly5SL/NlEX/YNbFhpkxP9BoJ
         3hQTccAAKnpGY6DmGczysXxrQBvBm1iEZtolo/lLjz1Kxp1Dp/b5G9uMkewo9xsKonTa
         tk4C5ZJz4hbRFLwyHHxVpnmslcvAcfOIL3BHYLqoKl3QUz/9UszSCRafj0d5+Tg62N1/
         18wVxxmAn8ymUOjc5f90s2PSqn7KU7s6zl7dpQovLp8N3CqdIFZ7grARMAPnD0aCd6Tx
         ARMQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774257449; x=1774862249; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ATgLsjCSGnGevYK8QWN2NsmPqAQpgw61X7qv/GD2mcI=;
        b=kTatZW1Ju4T2XYyNXqsCS07obuVcVlKjHuMdVZNwh41STS9DES+b1x1cbOBqY4r558
         8o4lGBZevHx8Hd6KkmlCrFs1PLnpqDEoQl7EQAEyGFZmxLvwLo7MjwczPJMtXh97r2va
         xUtN85Zmvm8cqqwBk2wQxj2xmz31caz7XXeY+ekot0y0CkMiVKc6rNF1laGlYy0mwAjL
         QPs2sof3y1qDNWMQ0056JJOqv1u5tSaj/3lTXhJJGJ2DcV6oSAVLQWkKG6NivJYlxgMB
         osYMJeE7ZV5CUb2b6U38uZIMCzxSdZHkccoFQTaFmRut6f4bnvV8fwBmrb88zZHNCH6u
         8iZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774257449; x=1774862249;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ATgLsjCSGnGevYK8QWN2NsmPqAQpgw61X7qv/GD2mcI=;
        b=iBF8rF8E0WNdyBPFgqjSU2lct5GSTD35JwASgX9xTtSFZVQQvI7AuVtGnQ9fxDpKhr
         hYdeXPa9EZDgfx5H6Vi1V9WEE8ICvZoYJt9eMTVc9i9iaYpTRv6qFH9asy781pd+llHp
         BVYFiyi5om06mFtp6UsXZjtcswdAwTKf1fU1eVxe4Z8sLQKbmN7oFRh2nMbM8naEWCyP
         kyPvhpVlxU1FcKSKUuSz27kM8fMZ5qiSOoJc78I5xEzhLH/L6flYxWgzwI2ctTTeuYFI
         J+GqQr0CSjdDGdTfJXsqZRGh42LmfIh9StKxkov2hK16wfz6B6LCFcESY2UPquhci47s
         LlzA==
X-Forwarded-Encrypted: i=1; AJvYcCUmolRtKFi9SZ8NzgFoyYhtG/f0jOh+rXFlw93FqKKavNr39bRkhm3BjvvjI1EtGsFbyLEKkM3Sdg==@kvack.org
X-Gm-Message-State: AOJu0YyUj/qmtD2WdqwfoQX/vSRfqVjs0WZe30AhrQNkNa1+Qkclnl9p
	mT9jCfYElL7c4E6LFqqaV0Zzcj+/xHxQHOG05x+hQ4c8+tHd0WgbPMprsOhX986uhdlyBVFRnfq
	yYDkAWS13Iy7PrZ+dEXKQ8lik5m2LbmE=
X-Gm-Gg: ATEYQzzbe0UafFi5g1N1YM/+yJlAHwFu0ARBizC/iD9jn2Bx/gDoAgJt/I6cKAcRxzk
	XseO8LL3iPbupKbN26Jl0UPhUHy/beTb69Ejsa5N5d/d/4Ognbksniz5ddo8i8d2cJtBPMcnPgM
	Ef4AZJOiuUtFjFL0o9uFaSY09O2Y56bwAsV6Hvd5BDyBmbCDMUo4iou7XRciyMkSetJ0okikTuJ
	mO5HoPerAzR3iP/UnyVXmeJHXyOMcP8feObxSZYjZjwBbXmJV+CnlsZLQQqTTtci13rtO6/+IpQ
	Z0CrGEOuUEO0lIelw74=
X-Received: by 2002:a05:6512:31d2:b0:5a2:7c8e:14b with SMTP id
 2adb3069b0e04-5a285b50113mr1789174e87.3.1774257448620; Mon, 23 Mar 2026
 02:17:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260320083339.1813195-1-zhaoyang.huang@unisoc.com> <CAMgjq7Bhi_2cgWUWpW+nh4dK2B9N_AbtUf+EJCwBF-d5rvFySw@mail.gmail.com>
In-Reply-To: <CAMgjq7Bhi_2cgWUWpW+nh4dK2B9N_AbtUf+EJCwBF-d5rvFySw@mail.gmail.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Mon, 23 Mar 2026 17:17:16 +0800
X-Gm-Features: AQROBzBsX00N4KIpYY4Nnge6iyH3EdbETLuMYXwhdSS-_GxDwLUMUs7Yp4j9-L8
Message-ID: <CAGWkznEoX2c79E7HiWMSv5Vk+Afg0P4rUgEO=gs1p65kBY-BfQ@mail.gmail.com>
Subject: Re: [PATCH] mm: skip dirty file folios during isolation of legacy LRU
To: Kairui Song <ryncsn@gmail.com>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Matthew Wilcox <willy@infradead.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E13308000F
X-Stat-Signature: fqkjro1r7ckft4cbfe7t4ttibz7gsahs
X-Rspam-User: 
X-HE-Tag: 1774257450-478377
X-HE-Meta: U2FsdGVkX1/rPa3WBPhPLsvfvXNHNpTWomgD3Yi2yoIANd6/LRBY9rfdPEsWFZzAdUFjiiFYlfu85llQPWD4qzj9OkXhhcm9BJ2tPNRJYr8QmPqQFDGRZ9DlQo8wHFiCaS03YYcAoAdiLTgX9FqYOFKgs9L26lAFrKEW3bw5v2+1XtJhjLOyzYt9JzNtrBQizIMBaAXh7/1Rs1hg5h+BbcmnzocxepBtzqK8bkWNtPVqRU+tdfcQf4CHrRQhSfk9ThOK3/4V3e6QYfK4VLE5W2MAxaTWY0cYusybyBFujMBOdtzlMduzDTjwOxMSozdZuMVZt6UEeXH5XhNwRPSALXbizxmZ4yidgoy8B4V4BnALHq6RXkWqHWNRurdSJyCo0yJVWoLFEDQnF04QjwSuxmpq+4Ip019NLth3I9FjEuN0jfviEKUTPjO9rY90kPuWppmen8AfKz34jy+5XzpeV6BdQUBGvSnUdFCaUrQnVpgsR7lubcS0Pu6ZJQa2PspDFeUi+vUepqt+putwbsLf4vq44y3BkT44V+BOx8jQvCyHSLGj8fCgZ8W3p///PpbtByhNGONwxCCmGN8JM5ktTNqW/HbV3O4NdqiWkrgOETrbkNXNYYo2NgxFXhof/l2knA/NFxw7C2UZXJ7UriCFTZyQm03a6o4TN77e2q43b6mVVlPoU9tdKgIgdf94I54Akeuuz90m7ly3jLBDIZxf/AcFuiWxyUQb7Pk9bj5yu5iAu7MYJB1uy8rBXI1IYJ71DVkdYh51mPtKK6Vl3eRzeefzyCazMlo2mYr3QB1UcWjdlzJad0eiBcjhspOtRE3E6gPgi95ga+NccTC2g+UYXAcaNU/GZ9Iz+ZLWe8Vsm3iF/GgT245gq9TPjU4K8nceVuLYdJUqoLBJTFlTIMtine8PRDzfcTmp+9ML17J4YrCfu+6Hh8xdAai9U4n0fRek+5S5MggtKmMmNEy3YMN
 5ioVQMnV
 zBLeP0P/zGQbusx2hztKov3OGa5Fq7E4i7dpOouYnVtG53lOU4TVMuUd9A6HRzwofDXiN6vliCJ/kOdxxqLtT0yVX331CihMHrFhFFNELDo8JPszszbsMDuEWoNTURylPA2o+qB7Sz9B3DIO+LPm7h2EzYBE4aslY/+27EkPQgP3p2+bFf2mniNvqTF7BhZRAFFcke6rIZQxyAArC3Y7anrB0SkLJyqHmtIeshbU5NZxcp3sujfOmkYIJE0R2O32nopr3IERQawFbIbocnCF1oNRBWxbiiSafCrpW6Q+iVPI3hYcjkpBMZ6n0NHal+3UQEZH0ByTHzLdacZN5t+uAc5ixmJlkI51KQ80kEtoecwvA4dyhQbhDTecKHk1SKixnKPyh9Gw1IDF0ocVWKNj5vvKAdCRrv0NqtIakwxqF2DKv+RhdMwBTb9bCOhxqPh3zS2YrQyac+DWJ4tEXlJNjcYxK/nu0uIihTvR69CiLCDF2C/E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 5:20=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Fri, Mar 20, 2026 at 4:34=E2=80=AFPM zhaoyang.huang
> <zhaoyang.huang@unisoc.com> wrote:
> >
> > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>
> Hi Zhaoyang,
>
> > Since dirty file folios are no longer writeout in reclaiming after
> > 'commit 84798514db50 ("mm: Remove swap_writepage() and
> > shmem_writepage()")', there is no need to isolate them which could help
> > to improve the scan efficiency and decrease the unnecessary TLB flush.
>
> But you are still isolating them with this patch, you just adjusted
> where the statistical update happens.
sorry, I missed the above information in previous feedback. No. The
dirty file folios are moved back to lruvec instead of being isolated
under this patch. How about apply this only when isolate_lru_folios is
called from shrink_active_list which has no worries about stuck the
inactive list.
>
> And this is kind of opposite thing to what I'm trying to do here:
> https://lore.kernel.org/linux-mm/20260318-mglru-reclaim-v1-0-2c46f9eb0508=
@tencent.com/
>
> > This commit would like to bring the dirty file folios detection forward
> > to isolation phase as well as the statistics which could affect wakeup
> > the flusher thread under legacy LRU. In terms of MGLRU, the dirty file
> > folios have been brought to younger gen when sort_folios.
>
> If you really just skip isolating them, it could cause a regression:
> skipping the isolate and put it back will cause some ping pong effect
> on writeback / dirty folios as they will be stuck at inactive list. It
> will instead decrease scan efficiency.

>
> Currently shrink_folio_list will reactivate them and set the
> PG_reclaim flag. They will be deactivated by writeback callback.
> Simply changing that and the flusher wakeup logic could be a bad idea.
> You can check the link above and see the benchmark result.
>
> And for under writeback folios, there is no IPI flush or unmap as it
> was returned early. For dirty file folios they are unmapped indeed,
> but following flush should reclaim them anyway.
>
> It might be a good idea to skip the unmmap part for dirty file folio?
> Maybe, some benchmark is needed.
>
> >         while (scan < nr_to_scan && !list_empty(src)) {
> >                 struct list_head *move_to =3D src;
> > +               bool dirty, writeback;
> >                 struct folio *folio;
> >
> >                 folio =3D lru_to_folio(src);
> > @@ -1749,6 +1731,30 @@ static unsigned long isolate_lru_folios(unsigned=
 long nr_to_scan,
> >                  */
> >                 scan +=3D nr_pages;
> >
> > +               if (!folio_trylock(folio))
> > +                       goto move;
> > +               /*
> > +                * The number of dirty pages determines if a node is ma=
rked
> > +                * reclaim_congested. kswapd will stall and start writi=
ng
> > +                * folios if the tail of the LRU is all dirty unqueued =
folios.
> > +                */
> > +               folio_check_dirty_writeback(folio, &dirty, &writeback);
> > +               folio_unlock(folio);
>
> For LRU contention, to force active you always have to take it off the
> LRU first, folio_activate will take them off and touch LRU lock
> anyway. And now here, there is more work under lruvec lock and it is
> also trying to lock the folio under the lruvec lock. The LRU
> contention might get worse.
>
> And the wakeup below seems very wrong, you just can't throttle or wait
> or sleep under LRU lock.

