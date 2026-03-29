Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 691DFF3D5F4
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 08:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A90C6B008C; Sun, 29 Mar 2026 04:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 859BB6B0095; Sun, 29 Mar 2026 04:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748216B0096; Sun, 29 Mar 2026 04:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D5406B008C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 04:47:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0C6D858C02
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 08:47:24 +0000 (UTC)
X-FDA: 84598471608.30.387D968
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id 19E8B4000E
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 08:47:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gV9xJu5J;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774774042; a=rsa-sha256;
	cv=pass;
	b=rYKQI1euVuDgUpOxJvMvFvne7r2vykbq8+LHYBCdwei6EGuqdKVwjBB9vtSt6af148YvJj
	3m4/qk8m9g3fi8mdKe3JAHqv6aHIqcDJihVdbeQfRsvkdKGcfBmRrDX7eAy2XZ2WoMD7JM
	4HD8eMysw9fLGv9HBjxQFmvhcmoQvCc=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gV9xJu5J;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774774042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1WmU0IxV/gHHKFvaZrHHuKjr1zdE408hQ06NeL2hOQ8=;
	b=PfAltHczaz9sltyrqMWMqwKVrXy+R9rjAdTE0XMoNIwQb/O/GSf2nzCWaUoH/RSfwaZXnY
	+uYY+XGHEE7I81iBjFtv3UHXawNoYbOlp4aC/SQJqQVuDVgwk2sH7YdFCt1tk5jsaTCbIe
	MUnxMNjumzOfpC5u/iuShGe9taM8duc=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-66b66edf6cbso2758356a12.1
        for <linux-mm@kvack.org>; Sun, 29 Mar 2026 01:47:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774774040; cv=none;
        d=google.com; s=arc-20240605;
        b=KfuWBCHTsCBcCslK3gSyPvNvLdzOY5vwlXdyaZAhAGDCeK6FuUl/Rn8WH79obNc6DC
         y2/mZ9nRwW14opyAl4hp2/MX+bJYw7xChEWckidOFWRYEgSF+g5Q9ek6fXQIX7yfLCe0
         MCgTGNDTv2iJTmzHFehJja9yBwyRBby5P5+B/lESOc8EujW0x4cQ/u/WKB5gKnsTSnTW
         G3u8tyVmJksXCYxqWw1i0C1T1nbpgu2LGQhiLYuWcI78Y4AnpSv+cSHzyDIXubfZDpAk
         XId8c6xQptSQQxJSSI90vcSU+4OcFluTkSnKVMY/bRhtnH5+VKik4sxuzR/SIkfpnaZS
         cz0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1WmU0IxV/gHHKFvaZrHHuKjr1zdE408hQ06NeL2hOQ8=;
        fh=TVNLNsVLbhrCWBa/Ie+lFqc0IkeJSoLz7F+ToqBZS6Y=;
        b=DnAdX4WeLrdglAxfE+WLggMYncHTLDD/Y5iv+FNdxAA089V0CNDIksMKaSk/QOKTKP
         fAk08/OPk3NeK+givV9c+qOp1hD5egHJwUFkpV5nIWxZqP1M/0yD/fE7W2rejNG3bHXu
         Hp3pK1kRk9T9vxRqvjHYTNGXrHkBHPU2cIndwSVtLP7IiSPNLq73A9gUkxK7jF8iKg0s
         8OBP0YV9lceCKx1BsB7pnkNKnSksrJR1uLU6vDgG4IrHhwAK/9OntZW0mUThf9NlT1qy
         zu7CdqVISclDfFnJINksEHQ1UBbXoYsNo4xSY/HRb2acz9CNtg8fYHQpGt+kzv+VNNCG
         n4fA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774774040; x=1775378840; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1WmU0IxV/gHHKFvaZrHHuKjr1zdE408hQ06NeL2hOQ8=;
        b=gV9xJu5Ju27wQhrmdUUq9MC3/8yBjlOYojm6+ufrZISiBJdBYdjnt+AiXqljsBX+My
         vqT/JCZkyAQv8UDAvmKLDddqRNk9KrCRyuoxYqRnBFP9/+deec/WMAw33SdYFNBxzCHK
         qrRUf+F7GIILm4RErBUj/u506toxDfPM0ggkaElw1xaWbiampO/N/OGRyTyfYcRLofPZ
         u1TlJM/++bgvw1sfFp+LZMSWDJ7epdYCQ0L8Yc/FUP+ivql7IrkOj9ExLBiE0b2KCHhS
         8J+SOaxOdpTqOBkU5shm0WhlYkZxulXzUJvA1/TqEu/7vM1QLejw+KoOriEQ1xXwHLAo
         WUhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774774040; x=1775378840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1WmU0IxV/gHHKFvaZrHHuKjr1zdE408hQ06NeL2hOQ8=;
        b=aplUZyVVhfVfPu7qGANaSdk6BVRvFnSFCeokhXXepYZhzD9xaoJpomNqk+fUWjgKBd
         lo84QGXMfgLd1hVm+40TryZ/1yIBpEacd/tzcxM1zUMSbiUnEhL25Yn4+iqLp9rtECQO
         Om0YyznmBa+VK/aejb04wTizsPWo/8aCikEbTYxlp1/OmO91XG34XDEbhIYdnB8EZ+V+
         EgbjQsoIzJgRa+X7ViTHATusSCThh5gYTN7A8+ZxT5B/b+v6gjl2Ozl4AjBXRrYwhj0h
         1xfZcWdTdfkQIqAgIMu+XgNIqwWky7iXWkuGaFNretQVXos/k0u/UdliHFQUy9DIDjOs
         L6jQ==
X-Gm-Message-State: AOJu0Yzf3JyArkYhWvMuF6tJYpTFOlwAYSTiHsWypwqDleogQ6GkY6+5
	UPxOg/f0rnm54WOc4zD3iGjrenxdcj0Jf95YAoNJFWjmPHIVh5K/BLD/6aw8t314l4muLU75pDD
	q5S4QbieWVpkUlzFJyOxbH4WRAdikEY25LWGIyRfFSEGM
X-Gm-Gg: ATEYQzxJy/h54YKRniAMdXzxqWAHp2g4nc+9g58HYwnL84QPDs6RBLpxgWG+sBpVVTU
	fVIz/IOt5AhxEM+O3HzzTaSuEq+FVb7FVy7NYgj8yaeP7wtEjkScwGhrSb3fIB6ljUFBxzfRNoz
	i5cbccGN84Mam5grTdyMD4Pm9giSD+xg0qa+tic2bRJJyjpqE30VJUrKlsH362ogeU0ldoGSbom
	KGiv7mMt1XfODZxTppMwmpE0ZgVDXN/Ssmy0ioHOphcRin0zyGy5HUPXGvBNqGeFDe8DDYuZ1gU
	1Zk2PDoo5Z+cYTQU0moN1YfVd2lvMwDejC2FsUrAUKEfuQ1PVdc=
X-Received: by 2002:a05:6402:4494:b0:663:6d0a:6f97 with SMTP id
 4fb4d7f45d1cf-66b28f72394mr4946249a12.27.1774774039993; Sun, 29 Mar 2026
 01:47:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-8-b53a3678513c@tencent.com> <acjLfIeCFcX7ZEQb@KASONG-MC4>
In-Reply-To: <acjLfIeCFcX7ZEQb@KASONG-MC4>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 29 Mar 2026 16:46:43 +0800
X-Gm-Features: AQROBzC_yztj7ssxTKHR-zQVltSyfpUE4k2XyCqnZysrAp8FTuc9XOwQ0ip2_A8
Message-ID: <CAMgjq7C8TCsK99p85i3QzGCwgkXscTfFB6XCUTWQOcuqwHQa2Q@mail.gmail.com>
Subject: Re: [PATCH v2 08/12] mm/mglru: simplify and improve dirty writeback handling
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 19E8B4000E
X-Stat-Signature: xtwm37urrbkgtt67z75jm4mm37p6facs
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774774041-869064
X-HE-Meta: U2FsdGVkX18FOjEei4tSyPWZUks5c3lQgllRnj/ag6ok7P3Dp+KgSn5pB75qGdhBLsFbIEZMPPlqu4oxHMXbT4cOiduGsc1Te+fP+SXd1H/L/Y+iYrtJ7fs+8EkuE9f+DGT5wg/9/8a7EmZCEC+Vji+7ApCEvvJK8Rv3OqQQMDwvHvsRNd9lH4P+gLCN8jWvFKkwuvTNkmhOuRcccshoKhaLeusFLheW76B9CYAtlsEN749PXVNdSKrTgFs69FcoF1MNE9LXpmx9eLoQR20aU0LoXwNfNxNoUYpybTcNMTzquPoWufYeOMLIciMFlfHERVEvof3kx1PQHt1LaJXIf86DYQ5B67DkTHiDSq5+LCwNl2vV+r/PprdYx6S1ya1TDImgBty6v+rKee3VPnYK/JHxRYpbxn3GvNHiYNzCwetNvJ3YZb8hQhk18N5+I/FVOJd7qV7qEBmc6gvaCSVlgOHsje+VUIZqH7f8ReFnl8LvFr7nDM67Rti4fmSq/dgKy56p6R0LGI/Sv+FcGaNJxi5TzM860hvYyjwvXBAAhXWV/17uU4jpsW2H/so3PEV16kRvUczbsHiVJwtRzGBhCD36eXGxvPno8cWdriTerqsB1ilCHuD6mnKPwWpinSQx/DGj+Ygkjr8lCQ4x/aOg/o44RfqsYszpsM2eEQAX5qnerGShyHZl+se342O7ByzAV61AQHuTpBqsmxtaHBKTcP5YsXkgeKIBANvgc36lV+9C5wNrRDNVi+Zo/E6m6O/wtYWXtaBDQ4/ODkP/RbyN3cyQ/dBV+4pemUoZFU7W8zxtmVHz85Pi03EjyTkC5EW/A200Fp7mAW4OM3ziSblfuBXHiwZNJuuoLW1e59ubFRQ49Hw0r1oMkCraS5dess0R5sD7lENgnWAX7vRqDLOgCbYlSR+P/jOM1+Ld6lbXj/Hf15VJF2+aadU2NQy7cmIiOGxoCs+NLVOoW+lFayE
 dP8IAMhN
 n99lzjTngF6jdhqGn8/2bAiNXyrnMUQFJQ9T+MBDLo9VIsh1aziPh2pqH/tH8ice4inen7IM+6gKPsEQhUr7PRuOb6yLSpfDrVZNIAORtneRh7gJaiNY4n+B7CqlakmT/zGrOfFLCIN0WrqrOdj3ELD9FjKn71IrLAuN7QoGMCOluL6FhTlhFREiUpEj4286Jp42U79r60qEdLOB2L4O7/RgvmM1L5ziDaENPgiZXjAgw9ZsBxpXXMui23/KbO01J3TOR/4KHCr5qvjgEi3vlpYzCFPiIzwKRZ/SbWIz3BLe9vtaN0HaupR/rlXZHTZU/zNBhA80PJNnjdWMdjMiIgLMNj0iSSd5V9IKsCRdu1xtP3M9leY5qTnlMgSRX6BkUT2jr4haMup6PTWUS7rTcofdv4OYfYgtalG6hY6CZD3lHJec8rCaJArJ09FbHgsgrmDbTzaOy48g4XQMVSQbRPk317a8JTPhCzRwb/P/juYsU+b6QsAW2ngdNeDOgwm8ODVwRRTNOvmE5TYSaIDDWkCiOhfV07s+i/BLStG+Qjxo2HjBxCPakmhA+gkNeDWtiHUqabYddb8nk7L0MHVtajOq3OSwkm4scpcyyhur+X6SI5ik++dqzAa3E2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 29, 2026 at 4:21=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> Forwarding sashiko review:
>
> https://sashiko.dev/#/message/20260329-mglru-reclaim-v2-8-b53a3678513c%40=
tencent.com
>
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 8de5c8d5849e..17b5318fad39 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > [ ... ]
> > > @@ -4633,21 +4632,6 @@ static bool sort_folio(struct lruvec *lruvec, =
struct folio *folio, struct scan_c
> > >             return true;
> > >     }
> > >
> > > -   dirty =3D folio_test_dirty(folio);
> > > -   writeback =3D folio_test_writeback(folio);
> > > -   if (type =3D=3D LRU_GEN_FILE && dirty) {
> > > -           sc->nr.file_taken +=3D delta;
> > > -           if (!writeback)
> > > -                   sc->nr.unqueued_dirty +=3D delta;
> > > -   }
> > > -
> > > -   /* waiting for writeback */
> > > -   if (writeback || (type =3D=3D LRU_GEN_FILE && dirty)) {
> > > -           gen =3D folio_inc_gen(lruvec, folio, true);
> > > -           list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
> > > -           return true;
> > > -   }
> > > -
> > >     return false;
> > >  }
> >
> > Could removing this proactive promotion cause a livelock and premature =
OOM
> > during GFP_NOIO or GFP_NOFS direct reclaim?
> > Without this check, dirty file folios fall through to isolate_folio(). =
If
> > the reclaim does not have __GFP_IO, isolate_folio() will skip them.
> > These skipped folios are spliced back to the front of the oldest genera=
tion
> > list in scan_folios(). Because isolate_folio() isolates 0 folios,
> > evict_folios() returns early.
> > This completely bypasses the new wakeup_flusher_threads() call, leaving=
 the
> > dirty folios unqueued for writeback, and the oldest generation can neve=
r
> > advance.
>
> This is a nice found. For GFP_NOIO (or actually !__GFP_IO), we also need
> to active and set reclaim for the dirty folios. It's a narrow case though=
.
>
> Following update should work:
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 8170aee096e9..342ba3afe77c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4641,8 +4641,7 @@ static bool isolate_folio(struct lruvec *lruvec, st=
ruct folio *folio, struct sca
>
>         /* swap constrained */
>         if (!(sc->gfp_mask & __GFP_IO) &&
> -           (folio_test_dirty(folio) ||
> -            (folio_test_anon(folio) && !folio_test_swapcache(folio))))
> +            (folio_test_anon(folio) && !folio_test_swapcache(folio)))

Or this check should just be removed. shrink_folio_list already has a
check for swap and a more accurate may_enter_fs check.

