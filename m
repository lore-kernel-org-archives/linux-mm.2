Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CF3510F92E0
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 17:01:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 515B66B008C; Tue, 31 Mar 2026 13:01:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5CB6B0095; Tue, 31 Mar 2026 13:01:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B4286B0096; Tue, 31 Mar 2026 13:01:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 28A2C6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:01:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C019D1A030F
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:01:44 +0000 (UTC)
X-FDA: 84606974928.09.3315DA4
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9F24C14000A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:01:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wg0YrStP;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of bgeffon@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774976502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ham5ev+UebYvvEaY28poSjgTGYZxX5cFNpBczGAP7zU=;
	b=yTHPzpN7fGk/aA+r9U4woCSbvfvAPUEA108+h0TEmQ6sfI9EwWHS0EHA2hcK5X0+kKpb51
	EptLp3Oh3eHKzYyEznnyE2tMbqoFhimHz3rdan85GoNK78xvE7mlZsJyx0R8EkKxrw1qsC
	tb1v+sEDph+fk6lhVgwywxKW7RZ233o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774976502; a=rsa-sha256;
	cv=pass;
	b=6J1h0oQysP2z+d60quaVZGzr/uz06NQINsJaKWm5ztq3PLubvNNWbj/P26hKDLU7tC2qGr
	Cs00CtYPSNH59gu7W2PTrljvTyYTXzCJ+NkFJKvku5UYE6LSr/jY9yD+9Gtum4CRyA4rdX
	coyKI0LRyOenxvxLZ2D/fG8tuwtwEJs=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wg0YrStP;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of bgeffon@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-509069a7a7fso714921cf.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:01:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774976502; cv=none;
        d=google.com; s=arc-20240605;
        b=J4srqF/ZtOyX313SOWc/gU2AU4y+avI9vKVchnjy84uT0mTNPsDzR9aL0LgbsQ7DDb
         peNRGwevv5cTyVrzkli+OTTNMK9RvnacsUuojFscQL8NDBVfDkRKbmQcpWtWzGhV7QtW
         HkGbkkS7q+W8UabodWC02hQanyflALoMi0ho3D9OAmokHxSuypc+wvo/sIcXudcltjFt
         OrdrdFF9YoYOy1eDmxqfvCM/3CanZKwezAOmYkTWgrY2aNOD1l5LKVYTUOlniN4Hu3et
         U0SEJ4b3LdvDt9kZOW88FHMgewSS87if/8rD7DZ+hDts+/JxjYDs+s4GBCWhCxX+1Zv2
         HQvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ham5ev+UebYvvEaY28poSjgTGYZxX5cFNpBczGAP7zU=;
        fh=9GmWbGlctrplFDxrewj/eQhvx26N2kBa5mA6Mq2L2/M=;
        b=Suw4yQsi85SZCuFcDyKw12s/0pPez6W4Rfb4bBxx7+PVN5DUPDMk4FN/szGipBAb1T
         MpxUBinorMzKPJp9ga+zODIMECQxPagPpjmYlKOEO64VSwSwO/0o1Pu5sOcD2G3M/+pW
         kaY1T0GHan8GWy7GDU8QDDCOg73xpNL3Q5cMDdNKQBkvEw1JjJZpXCsrRZklK4Oa2/LP
         IjGT5vJLXoIGiqcIUH5dHBmaC8mnsCGENw6sCeepzymV7bYPK3n5JWNAEM6KZsrAwSNe
         35A/R5hAQvsfbpHW24qDjr/Qoy4YKu5APAYO10bkdE+5x7GQJf/7+DhR9K+7sLLv+SSq
         Oibw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774976502; x=1775581302; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ham5ev+UebYvvEaY28poSjgTGYZxX5cFNpBczGAP7zU=;
        b=wg0YrStPJoyteJlMQ4jTyLfpSq0m67k9YU7iwsL5El60x19uX4JPxlQwPRCpZTySy5
         AJGNSs/wETfT39ELwlTb2IpYiDPDM95Y8/ZLIwmi396f1uBflhXvwpfluTYutOGz00BJ
         9SeEKoZvqt1yOTIfoRGETQvAhihx2AyRb6y+X56mF87HE9ZJSc0aeLSUjX3lT5RLQd34
         sp/5mVtcWLMQyUWu3HiqqP9lOgy57SnPucU3sy7yb3xoyJeuRZj9EIJ620rZC8R+tbMV
         1cfzQ2GJSsddSo8pUkO9Wu7x4L8s/ygXsLFxOkjV3erdLPFg1TZtp+Hc4NxSW282gYNO
         aTCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774976502; x=1775581302;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ham5ev+UebYvvEaY28poSjgTGYZxX5cFNpBczGAP7zU=;
        b=oLMDggmHadHK3X+xhyWr0Bgytf/7V5LTb6w+jmm7ZgESKQh5voyAOl4bIi93hVH/1S
         iwjO3RllnV3rFbthzAjSI8889IdqNAt1zBp/Ae3JVhmPQ+JV7PFb1x6/eaYDFiLQ190E
         4UVM3a6iNoEeY/v7n0TUXnmZ3zxpYDyn1fpkJlKOurtQ2T/t5SSTaAVzxT6eV/vqG+82
         ntgCdhJ6XZFwpUrwf+Rbvl1dMLHttK0D4U9xCn3hIeQ0aBK7HdSvGcutwDnUHjfwgb+v
         JQpp+a+Kuretj7RhDMvOLqRaQQmqvdVKD5LRl2vuuH+bgQGoe0ukx3R42GM89T0PXTR/
         3P5A==
X-Forwarded-Encrypted: i=1; AJvYcCWddCm/77RBb1TlHU7CiDVUTwVDjdhdWMzqjNYbloafdgrUxhmOuQpNUgdX8mCeETUB7KYxxcVHbQ==@kvack.org
X-Gm-Message-State: AOJu0YwcdCkg0SH2KmcG8XaAwxGk3V4Sq2r93iSmVO+93fNWjlC11/jV
	/FkMLPSxiqXOzqwHmWpta9xOiS0GbNL7u/pfuXfxC4p0AK5i20odw37x+dNRz4AqTD01+3iKaYs
	BNYK+ttzYBZrrmCpMn0yFdyzM9Vy1vhIHbWVuIhV4
X-Gm-Gg: ATEYQzxS0/720G3Jd8E8V2PJ5PR1XbOQknUoNK1/B6yxyKj7Shdy3pFxegz14vkWvUu
	7WXBD9HMZQ1Ua39CMfOeau4ypWhw7hDDKHFf2N4pZEq17zgqVjrtDjWX7SsRepyIdkeQYTdhrft
	vkQJfgXbJWO1zeYANBajvDCzgKpzO07GmHRdmGG3p8aoJ0F+J67Ls0s0KONm8FhVb2+7H12yMKr
	H3qNKmQWTBnL6f6kvrwgM+j09isb3I+nrGxylJW8Dc2plB7hxVEXfZz+54dGkIPYTlsgvYNVH4d
	Gpij5kqypXn7UlumHUkpI/Q8ejDx8vRPdqpOpBjjHjd085UQS3zxvhsfRfpsccfqJG3j2KXUJhY
	a6fSPw1dY0VbMBajTwYylgT2u
X-Received: by 2002:a05:622a:aa05:20b0:4fb:e3b0:aae6 with SMTP id
 d75a77b69052e-50d3b7238eemr1956911cf.1.1774976501176; Tue, 31 Mar 2026
 10:01:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260331062648.596077-1-senozhatsky@chromium.org>
In-Reply-To: <20260331062648.596077-1-senozhatsky@chromium.org>
From: Brian Geffon <bgeffon@google.com>
Date: Tue, 31 Mar 2026 13:01:02 -0400
X-Gm-Features: AQROBzD0u_5CmV7Kfe03IQ8eGCjuAdzCH9_TPr0t8uU79dqySJTdhvGybaYcyPg
Message-ID: <CADyq12yGuOg-Q9MbakWtsevLTDxvk-bSbVyCm9igAmVBA-Po5A@mail.gmail.com>
Subject: Re: [RFC PATCH] zram: update ac_time of written back slots
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-block@vger.kernel.org, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: 8up8pbb57mzdanxgx171oyoj3a4mxwk7
X-Rspamd-Queue-Id: 9F24C14000A
X-Rspam-User: 
X-HE-Tag: 1774976502-594927
X-HE-Meta: U2FsdGVkX18hDylxFRfp8R0HY9WK9eklFx+gvDMuWiuZHBf5KB2E1ygCEDhq15AADM72vyHHW3EsyP/t+9x2n2RlepbpXbgK15CZlucWenrF4ZnsT9owNVkF8zl8qQB4RCd2ZHd6frj/uX7mr5ib0ZP/JREZ1DcUEWsrTWgsGTXDZMjqbH5YCTzdNPpZyaOkaVbURbjex1S9zCc10+m1Q5h3g5RtwTjDqhWtp56Q4lelmqWLiAAe9zNbWgvOAuQlQs3YRAI2n51PpmYICvzv0t9BGgTGr9PCR7ueFA63Au0FtKoZS0+jUSsqNKdvld+VLaj6e8AqnHFYWryKOajvbEjisNv1inONNkjI2wQo92djY/SGVUt0GW5FZqgLiTlV6038nlaD58TGLwtw9BcVdfx3h3X/GfUg2LE9q7LCDTGyQjTT6q234ehEtMh+U7G56tBmN1nNis5eNo8jzYjP4OAElJAMTcuGOflXg1NSiG/NsQ6HavlWa2h/mWbMjydguDXMe/9ac35XDpK+Jqa4d6RxGeICceoiPy1TTO6kFY/LPArOxWghkwM07Kmn4Uab+AbFpSrz7NS4jZZTtlfDU19w3cx12joaDEYx6fnKjSBCXjGw60ETsrPz/h7JR5nhHMnox0a5er3ljuM/UX3Q4iqTy6J4ro5T/cYA9T00iQYG5uxTGKKa2I43TwJGEvyGeTFADhAx+Lum5lARPOWUZvkEHxebFTvdMshkDRTudDM081cR/ek1EEn3/31ZvSab/NX83HmlRrEIzYoDktwml5xHRpz7aroMnenkvmCtHmhqMmSXB/bsy9mhFxiTzxqQaRv51L4H5kaA9Raw08VO5gH4C1iMaoLjPiFhSW2S+78Z2iykbBsOmqATc/bGjEeyfL+3vKgZqdtK5MQOa2CjhVlrFKMsuq+slq/SFrYXYgvGCFsyIBWajOMou1yNCifrVdqMoeinsEmkPLgXKWV
 C5NkFIOZ
 kUAdCKb0gaVwuZ6c5aUwpi9vl0zhO01hwDCrqrYKY/8XjSTa4b2mo9VvhHoGNXOZ+8TyjJGwdzPAPcLc7Kq08BcH7TdBcMSiZX89d67C+SKs0Ik3MS+h7kbffMoweCasIU04IrGfb594+42uB2wpeZP6dMiYdC3NUDOps0VxZdsH0PPoN/0yE2cybDJ3zdw542JMw7syWSbsSQGIyLe/w1YTnjIHVoCuPG4Kcr7flDELpe/Ar4sPJ7+2nLBfUXaYuBRCNNL8P32NBhpeiIWIaXOIlnYqPBVNRn7/NI0wl88kB6XxYya5qzV9tnumJETBcY5D68Bnco719Ti0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 2:27=E2=80=AFAM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> This makes it possible to tell how long each particular
> ZRAM_WB slot stays on the disk and, basically, to monitor
> writeback efficiency.
>
> Note that the patch factors out a small update_slot_ac_time()
> helper, which we call on writeback completion, instead of
> calling mark_slot_accessed().  The reasons being is that
> mark_slot_accessed() clears ZRAM_PP_SLOT flag ahead of time,
> while we want to keep that flag set as long as the slot is on
> the post-processing list (unless the slot is freed concurrently).
>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> Suggested-by: Brian Geffon <bgeffon@google.com>

Acked-by: Brian Geffon <bgeffon@google.com>

>
> ---
>  drivers/block/zram/zram_drv.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.=
c
> index 5ecc4ba40e9d..dcea703a6766 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -185,15 +185,20 @@ static inline u32 get_slot_comp_priority(struct zra=
m *zram, u32 index)
>         return prio & ZRAM_COMP_PRIORITY_MASK;
>  }
>
> -static void mark_slot_accessed(struct zram *zram, u32 index)
> +static void update_slot_ac_time(struct zram *zram, u32 index)
>  {
> -       clear_slot_flag(zram, index, ZRAM_IDLE);
> -       clear_slot_flag(zram, index, ZRAM_PP_SLOT);
>  #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
>         zram->table[index].attr.ac_time =3D (u32)ktime_get_boottime_secon=
ds();
>  #endif
>  }
>
> +static void mark_slot_accessed(struct zram *zram, u32 index)
> +{
> +       clear_slot_flag(zram, index, ZRAM_IDLE);
> +       clear_slot_flag(zram, index, ZRAM_PP_SLOT);
> +       update_slot_ac_time(zram, index);
> +}
> +
>  static inline void update_used_max(struct zram *zram, const unsigned lon=
g pages)
>  {
>         unsigned long cur_max =3D atomic_long_read(&zram->stats.max_used_=
pages);
> @@ -952,6 +957,7 @@ static int zram_writeback_complete(struct zram *zram,=
 struct zram_wb_req *req)
>         zs_free(zram->mem_pool, get_slot_handle(zram, index));
>         set_slot_handle(zram, index, req->blk_idx);
>         set_slot_flag(zram, index, ZRAM_WB);
> +       update_slot_ac_time(zram, index);
>
>  out:
>         slot_unlock(zram, index);
> --
> 2.53.0.1018.g2bb0e51243-goog
>

