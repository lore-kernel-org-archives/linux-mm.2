Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73C39D5B872
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 22:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 511286B0088; Mon, 15 Dec 2025 17:31:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 494B56B0089; Mon, 15 Dec 2025 17:31:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 368A86B008A; Mon, 15 Dec 2025 17:31:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 19CB56B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 17:31:52 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BC7625893D
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 22:31:51 +0000 (UTC)
X-FDA: 84223154022.06.7AC3B43
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id AE226180014
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 22:31:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=epveuxWJ;
	spf=pass (imf16.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765837909; a=rsa-sha256;
	cv=pass;
	b=ZfdHcn9mXrJjI4sw2D9tIuKb5BCrpijZrenJfiwtWsvCH0u5pYJO4TnfJNwamoRA3IkGvg
	Y+/M6WoqMCgRabavJTt0WGABs4x3NvXL6O+xLoVsMhvKSZb9gqRCftyYgYtQ9tB/FSdDFb
	Lzkw4Io28+FgoJmtAs1AA0tPLVsK7yQ=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=epveuxWJ;
	spf=pass (imf16.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765837909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MDoS1wcUn46c1o+kUt4Dase0a7E8ksrz1tIiI0QmEA0=;
	b=eOB7gVNaFr/tO6RGciW9LUEP9nOd/6PkDfZT93lOa21zNJqLvti6yiBkgEcziaAVuYcyz8
	Azvg01qfVDHoKTkhSpsewXcRpcX6sAM3imFpJbfr9R/T1vEf5KZtZCRcqorLlAHcTXs1/C
	AEk55OMxbVq2lumbOYnjJ3QMRXmxS1M=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a0d06cfa93so29395ad.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:31:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765837908; cv=none;
        d=google.com; s=arc-20240605;
        b=D42ty/+S+s7nY7NWxZYQNiqyKJc1aIrkbsWNvlAbIdsoS6sMkzI+z1wvWnbfmA75il
         AVyldpco/vC0HGIWmatzSBdDqt9Kwwm+3KrGXolntJhOaG92UwGezjHKO1S/71GH6KyW
         BPxACfBZakzvA33/H7Rmc2vCKGFJzROHJvUs+AIXQqeyx81k0Nrn7Tgt09vP/MJbCcju
         oVKu5P5gHHDyaWsimbEhgdloQWbJmiLVxHlBLOkitrqfaCnYwrkxDj8Zx7Yu9KG24O1X
         QyaUootm82jnT3B9fmjWPs/oEbWJNRDjuzCJWu2vlsK9ErxETH8kwb8c21IqCISm3/tf
         uzbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MDoS1wcUn46c1o+kUt4Dase0a7E8ksrz1tIiI0QmEA0=;
        fh=4/W5RV6sYrwodtBAb241EiK/gwCuCXxAH+aWm0prttU=;
        b=QK+3UObDj4+WcX15Kh9cdam+SHyFudHlApasXWjvlBIrlk+J/wp0jjCJrxQzXteqMn
         maLykswxpg14ZoNVHaz67S3OUXUW0rvY3s4xVqT3wYQZK6soPcGQuoaCvR3If/XT/bK5
         BsD6BaIO1d+iw+7FWXESYSLoeFj9LbvvUsC7a98sn0km3cgSD0ktOF8DWp5ylFc9xMmq
         6tw5xthiMzyS2dKOCyZOs3lncR9yNejf3nqwfizf5Cyai1204UrCP2wgiyRDq5DnuF1o
         TKX2MwhmUGZGgboSptN5lbgxOZzgHsCqOIR27y/egyxHMSx/frwc02/nInTeSmvP7Ht2
         S80g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765837908; x=1766442708; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MDoS1wcUn46c1o+kUt4Dase0a7E8ksrz1tIiI0QmEA0=;
        b=epveuxWJ0rwZ70XKq15NEX0VNjNtx/NtOQc9FYIytctTqBtDKUDa6nxL49FIsaUS6Y
         mDZXApH4+ZUn0/mO4Xq4VNrBvTE8uReHPHcHxTsEoUrYgy3GrbMfIgrGRPr6D29YKTkK
         1JweJIJnNT34XuyufGpW1v6SiT76G/cvdmpfWleGEHNffeK0lN1+MKzC/F6MU5nB0Uag
         v81Epkxf22IUEaGDR/wu/WF/dRtv0ol8MKAq8sKhWudeWTiUrxLqd23yUYVRQlG+gjeJ
         SGruMq8OFBOkqS70VJMVs1QvXDU2wCLGyTU791QDFzbD0X1/RJMyi9xw2TQbY7o898VI
         zunA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765837908; x=1766442708;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MDoS1wcUn46c1o+kUt4Dase0a7E8ksrz1tIiI0QmEA0=;
        b=aPLVhOB/Qjm8SwQcFcqwTw5+fBhJjxRqobm7YMpdsUptVume+5lR+HOl69kLw2plHp
         ZtGq3divMdw9RD249SJLQty2CYLlnlB5YNZAAuBUiCJk1aABfFqRxLHkkSwT3JeuveUm
         Y9jov+ybDt/Qbj1uD1T/KEp9sL1mabon5HMeDBPuurHGo9IBF2+u+b/xzaUJIcmwph4+
         4/qkxjauMocN1k7npby2+qQ9H8t86J72u2zLYgFb2eHHAkW13GF/aYbSxofReZASmb25
         R/fStXU5sp0wEYXtaWVEHooAZtG103h4eU/MszZL9xJ0zqbFU2VymYX2L2j5ZImvo6TC
         zC1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWr7LrZbBKv7nDfnotiuqGPeZdnGcjVNRmd7XYPenHZOW5B0hLrKlsrjiV4Wx+HaTeDAfxkbrBPzQ==@kvack.org
X-Gm-Message-State: AOJu0YwLaBQ8CBM/6H6Syx/Q6edEU1ymDUz2WFgZUVr4YRaNLFowJxao
	SnegvxofYBcJ2qpE+Fyl85QXjsyLmYuGcuaUSeSwCSF3h8hkttFPxVfsq7HQlONHwjXiJrm3ZLb
	kyXvT5m8UvXeFmyN1oe2PwbMAx3HAotr1wiKltQtO
X-Gm-Gg: AY/fxX5kLMbrDhRKMSkDZ27GkO8HOXqdO7sGpZYVpnxrWcId0BchT5yPnP0uYuunGBQ
	TsTFA+soVlLSUf45xx5O7cfBryOXzdqT1/uo/khK/K+buuqk4QIL01QHuO6HZaFMiMh57jARsl2
	PVh83ta1F0CB/Sa7ujN7pfNzYz1EXFQRvg9+9KU7zZtYV4X5DrkZKngPfvidkzp3EIgmR7M+S2Z
	Y/XRjlXIOw3j8KEc5bfiHRV8n1ot8nlZsKLWbLPcSUREIcFVx57x2vaQdgiBRX126DPT6JWbVA4
	7+izkJA+9bFaPWBDE2PdH+yA2DxvbjYHgqZqBut2ZKku5zwJ6gPqW/c=
X-Google-Smtp-Source: AGHT+IGRIaboGVckS9g/qPRFtli3PshYjyLF2BM1BK7omXduoKeTI2/kIP9p0srIwsjovp30ojTHhjVXymdM79d4KN8=
X-Received: by 2002:a17:903:15ce:b0:29f:181c:1f0 with SMTP id
 d9443c01a7336-2a0906f3886mr5554235ad.11.1765837908008; Mon, 15 Dec 2025
 14:31:48 -0800 (PST)
MIME-Version: 1.0
References: <d7c0b48450c70eeb5fd8acd6ecd23593f30dbf1f.1765775954.git.senozhatsky@chromium.org>
In-Reply-To: <d7c0b48450c70eeb5fd8acd6ecd23593f30dbf1f.1765775954.git.senozhatsky@chromium.org>
From: Brian Geffon <bgeffon@google.com>
Date: Mon, 15 Dec 2025 17:31:12 -0500
X-Gm-Features: AQt7F2r0EuuPIfhwSJRS6i_Tjcekk7gDmjBvcasparsnwyKoYpM333lodRLuq38
Message-ID: <CADyq12zu_o1fEz2B0nrZUFhbnEgiLPVkJv4ku5mrXYNBBNQ-Dg@mail.gmail.com>
Subject: Re: [PATCH 1/3] zram: use u32 for entry ac_time tracking
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	David Stevens <stevensd@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: AE226180014
X-Rspamd-Server: rspam04
X-Stat-Signature: wq7yttu7x1kewzcj1xainnn3ayt4fd7x
X-HE-Tag: 1765837909-747605
X-HE-Meta: U2FsdGVkX18Kztnfhxe99qOekgao+2WR+ctqgjzzM04TFPfm5M0K7pye3F3rPO8SgZUaJUcSWIg0iIMgn2NaGGbmKoTbYVGUMfBvnc78lgP6eDeFRGtonmsUzjJVPivjZrlXlx1N6mzTTF19es0AMZDuUZwavcn+mG2yCNZtmQicF7SvLYaJ8xOm/yHEGThcx1Ds0LJe48Vd667RRgfA2vNuNiXiPnU8eeKZC1oUE8D+m4t7AKpPmRIqYXypx6iols3w/30V3OYm14+lZcxgvT5qV+3RGeECA9kRUxzRE0dvfta0JHC3Er14lyLHBTBzYd2VAB4M4J9ex+SI/x1W7jkSnuDjRhN8+qqEzOzoHGnziIcRlXewsiFMUf/+8K8B8BZZcGN4EdOdqwBWKKP3zXwo2TfX5oaL4dOJqSmhkihtBycxz74n/HEtFV1R4VdinyiHgGFJjVkcMMwT6lhHtBjUmSGn0757E2gEt3z5Feh2mblfDW1fjJQmkonFGu1PFsFQNczrWDKf4G85YcJeLb0MyGoF5gBlpaNLbpnHRo+rHN0IjQTu0a5xrrpDm6qjdv25n85mbOAWv9NyBoYIeLhs1iQpCrm593JfAGeq1a3HRUy1K4eMsBLubDR3qsB60xQGt2yBTqiEmWUHy3ggXKMnMpBRfE81k9wy2QDW1Wj5oeDXfgbop1wMAERCfxzDnE/GF3PXi+KOKF6TUTGyDFXPvcwB08YrWuKRrqYJ7ZFaFoUQuxa835CbGV8vBoyOo+QxR7Dmkwc15iq0anh0XyS3fU9lJZ805KKMeE2JCXSCpdFJHTL96jNSAszKXer2ZHnwUIXe+ixGDP/BMOr4rDWjZpFJYBU4mr/M0vtRjeCUol0CqmsBO49eJH0joWjeYBKI8UcgK2BcoPtxPgwW8b9xQ/s2bo9m70wDcmtN+HaPfBW5a456m675JS6uvYsSqWvah+tOKQ3TmuEXmO8
 6GnINf1L
 jM2Y9p0IQIvs+fQYj8BeSH9rkCFCGCu4VWgiIjIPdDckosNg/DFpMlBB9LN0c26N9zPq7xYa9fyxm0KOivM+9VqCi7bXPXgup8xxhmPSO9TFLrDy75JZeX3pKKL6nHQFEuIMyEBqdYt7Y+S/VP8TUF5hu8XSss6A8DfnjONdVZv+ziBSNAT9458kqOFLgRmdBpHmXtjhLq/CgVXAs8+P1WjZ0JUOCxXMD/7LH7VbBa38HFOMkYHnTR3LzcwwmcAdyVHXAO84fOsbSiQ67S3thZ77hpGM9lTp0HMdHZcu5i1+gSWh198uxry2PhPEDwlwq+e7IdH9QnevbGEQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 12:47=E2=80=AFAM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> We can reduce sizeof(zram_table_entry) on 64-bit systems
> by converting flags and ac_time to u32.  Entry flags fit
> into u32, and for ac_time u32 gives us over a century of
> entry lifespan (approx 136 years) which is plenty (zram
> uses system boot time (seconds)).

Makes sense.

>
> In struct zram_table_entry we use bytes aliasing, because
> bit-wait API (for slot lock) requires a whole unsigned
> long word.
>
> Suggested-by: David Stevens <stevensd@google.com>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Reviewed-by: Brian Geffon <bgeffon@google.com>

> ---
>  drivers/block/zram/zram_drv.c | 60 +++++++++++++++++------------------
>  drivers/block/zram/zram_drv.h |  9 ++++--
>  2 files changed, 37 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.=
c
> index 67a9e7c005c3..65f99ff3e2e5 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -81,7 +81,7 @@ static void zram_slot_lock_init(struct zram *zram, u32 =
index)
>   */
>  static __must_check bool zram_slot_trylock(struct zram *zram, u32 index)
>  {
> -       unsigned long *lock =3D &zram->table[index].flags;
> +       unsigned long *lock =3D &zram->table[index].__lock;
>
>         if (!test_and_set_bit_lock(ZRAM_ENTRY_LOCK, lock)) {
>                 mutex_acquire(slot_dep_map(zram, index), 0, 1, _RET_IP_);
> @@ -94,7 +94,7 @@ static __must_check bool zram_slot_trylock(struct zram =
*zram, u32 index)
>
>  static void zram_slot_lock(struct zram *zram, u32 index)
>  {
> -       unsigned long *lock =3D &zram->table[index].flags;
> +       unsigned long *lock =3D &zram->table[index].__lock;
>
>         mutex_acquire(slot_dep_map(zram, index), 0, 0, _RET_IP_);
>         wait_on_bit_lock(lock, ZRAM_ENTRY_LOCK, TASK_UNINTERRUPTIBLE);
> @@ -103,7 +103,7 @@ static void zram_slot_lock(struct zram *zram, u32 ind=
ex)
>
>  static void zram_slot_unlock(struct zram *zram, u32 index)
>  {
> -       unsigned long *lock =3D &zram->table[index].flags;
> +       unsigned long *lock =3D &zram->table[index].__lock;
>
>         mutex_release(slot_dep_map(zram, index), _RET_IP_);
>         clear_and_wake_up_bit(ZRAM_ENTRY_LOCK, lock);
> @@ -130,34 +130,33 @@ static void zram_set_handle(struct zram *zram, u32 =
index, unsigned long handle)
>  }
>
>  static bool zram_test_flag(struct zram *zram, u32 index,
> -                       enum zram_pageflags flag)
> +                          enum zram_pageflags flag)
>  {
> -       return zram->table[index].flags & BIT(flag);
> +       return zram->table[index].attr.flags & BIT(flag);
>  }
>
>  static void zram_set_flag(struct zram *zram, u32 index,
> -                       enum zram_pageflags flag)
> +                         enum zram_pageflags flag)
>  {
> -       zram->table[index].flags |=3D BIT(flag);
> +       zram->table[index].attr.flags |=3D BIT(flag);
>  }
>
>  static void zram_clear_flag(struct zram *zram, u32 index,
> -                       enum zram_pageflags flag)
> +                           enum zram_pageflags flag)
>  {
> -       zram->table[index].flags &=3D ~BIT(flag);
> +       zram->table[index].attr.flags &=3D ~BIT(flag);
>  }
>
>  static size_t zram_get_obj_size(struct zram *zram, u32 index)
>  {
> -       return zram->table[index].flags & (BIT(ZRAM_FLAG_SHIFT) - 1);
> +       return zram->table[index].attr.flags & (BIT(ZRAM_FLAG_SHIFT) - 1)=
;
>  }
>
> -static void zram_set_obj_size(struct zram *zram,
> -                                       u32 index, size_t size)
> +static void zram_set_obj_size(struct zram *zram, u32 index, size_t size)
>  {
> -       unsigned long flags =3D zram->table[index].flags >> ZRAM_FLAG_SHI=
FT;
> +       unsigned long flags =3D zram->table[index].attr.flags >> ZRAM_FLA=
G_SHIFT;
>
> -       zram->table[index].flags =3D (flags << ZRAM_FLAG_SHIFT) | size;
> +       zram->table[index].attr.flags =3D (flags << ZRAM_FLAG_SHIFT) | si=
ze;
>  }
>
>  static inline bool zram_allocated(struct zram *zram, u32 index)
> @@ -208,14 +207,14 @@ static inline void zram_set_priority(struct zram *z=
ram, u32 index, u32 prio)
>          * Clear previous priority value first, in case if we recompress
>          * further an already recompressed page
>          */
> -       zram->table[index].flags &=3D ~(ZRAM_COMP_PRIORITY_MASK <<
> -                                     ZRAM_COMP_PRIORITY_BIT1);
> -       zram->table[index].flags |=3D (prio << ZRAM_COMP_PRIORITY_BIT1);
> +       zram->table[index].attr.flags &=3D ~(ZRAM_COMP_PRIORITY_MASK <<
> +                                          ZRAM_COMP_PRIORITY_BIT1);
> +       zram->table[index].attr.flags |=3D (prio << ZRAM_COMP_PRIORITY_BI=
T1);
>  }
>
>  static inline u32 zram_get_priority(struct zram *zram, u32 index)
>  {
> -       u32 prio =3D zram->table[index].flags >> ZRAM_COMP_PRIORITY_BIT1;
> +       u32 prio =3D zram->table[index].attr.flags >> ZRAM_COMP_PRIORITY_=
BIT1;
>
>         return prio & ZRAM_COMP_PRIORITY_MASK;
>  }
> @@ -225,7 +224,7 @@ static void zram_accessed(struct zram *zram, u32 inde=
x)
>         zram_clear_flag(zram, index, ZRAM_IDLE);
>         zram_clear_flag(zram, index, ZRAM_PP_SLOT);
>  #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
> -       zram->table[index].ac_time =3D ktime_get_boottime();
> +       zram->table[index].attr.ac_time =3D (u32)ktime_get_boottime_secon=
ds();
>  #endif
>  }
>
> @@ -447,7 +446,7 @@ static void mark_idle(struct zram *zram, ktime_t cuto=
ff)
>
>  #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
>                 is_idle =3D !cutoff ||
> -                       ktime_after(cutoff, zram->table[index].ac_time);
> +                       ktime_after(cutoff, zram->table[index].attr.ac_ti=
me);
>  #endif
>                 if (is_idle)
>                         zram_set_flag(zram, index, ZRAM_IDLE);
> @@ -461,18 +460,19 @@ static ssize_t idle_store(struct device *dev, struc=
t device_attribute *attr,
>                           const char *buf, size_t len)
>  {
>         struct zram *zram =3D dev_to_zram(dev);
> -       ktime_t cutoff_time =3D 0;
> +       ktime_t cutoff =3D 0;
>
>         if (!sysfs_streq(buf, "all")) {
>                 /*
>                  * If it did not parse as 'all' try to treat it as an int=
eger
>                  * when we have memory tracking enabled.
>                  */
> -               u64 age_sec;
> +               u32 age_sec;
>
> -               if (IS_ENABLED(CONFIG_ZRAM_TRACK_ENTRY_ACTIME) && !kstrto=
ull(buf, 0, &age_sec))
> -                       cutoff_time =3D ktime_sub(ktime_get_boottime(),
> -                                       ns_to_ktime(age_sec * NSEC_PER_SE=
C));
> +               if (IS_ENABLED(CONFIG_ZRAM_TRACK_ENTRY_ACTIME) &&
> +                   !kstrtouint(buf, 0, &age_sec))
> +                       cutoff =3D ktime_sub((u32)ktime_get_boottime_seco=
nds(),
> +                                          age_sec);
>                 else
>                         return -EINVAL;
>         }
> @@ -482,10 +482,10 @@ static ssize_t idle_store(struct device *dev, struc=
t device_attribute *attr,
>                 return -EINVAL;
>
>         /*
> -        * A cutoff_time of 0 marks everything as idle, this is the
> +        * A cutoff of 0 marks everything as idle, this is the
>          * "all" behavior.
>          */
> -       mark_idle(zram, cutoff_time);
> +       mark_idle(zram, cutoff);
>         return len;
>  }
>
> @@ -1588,7 +1588,7 @@ static ssize_t read_block_state(struct file *file, =
char __user *buf,
>                 if (!zram_allocated(zram, index))
>                         goto next;
>
> -               ts =3D ktime_to_timespec64(zram->table[index].ac_time);
> +               ts =3D ktime_to_timespec64(zram->table[index].attr.ac_tim=
e);
>                 copied =3D snprintf(kbuf + written, count,
>                         "%12zd %12lld.%06lu %c%c%c%c%c%c\n",
>                         index, (s64)ts.tv_sec,
> @@ -2013,7 +2013,7 @@ static void zram_slot_free(struct zram *zram, u32 i=
ndex)
>         unsigned long handle;
>
>  #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
> -       zram->table[index].ac_time =3D 0;
> +       zram->table[index].attr.ac_time =3D 0;
>  #endif
>
>         zram_clear_flag(zram, index, ZRAM_IDLE);
> @@ -3286,7 +3286,7 @@ static int __init zram_init(void)
>         struct zram_table_entry zram_te;
>         int ret;
>
> -       BUILD_BUG_ON(__NR_ZRAM_PAGEFLAGS > sizeof(zram_te.flags) * 8);
> +       BUILD_BUG_ON(__NR_ZRAM_PAGEFLAGS > sizeof(zram_te.attr.flags) * 8=
);
>
>         ret =3D cpuhp_setup_state_multi(CPUHP_ZCOMP_PREPARE, "block/zram:=
prepare",
>                                       zcomp_cpu_up_prepare, zcomp_cpu_dea=
d);
> diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.=
h
> index 72fdf66c78ab..48d6861c6647 100644
> --- a/drivers/block/zram/zram_drv.h
> +++ b/drivers/block/zram/zram_drv.h
> @@ -65,10 +65,15 @@ enum zram_pageflags {
>   */
>  struct zram_table_entry {
>         unsigned long handle;
> -       unsigned long flags;
> +       union {
> +               unsigned long __lock;
> +               struct attr {
> +                       u32 flags;
>  #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
> -       ktime_t ac_time;
> +                       u32 ac_time;
>  #endif

Why not just always enable CONFIG_ZRAM_TRACK_ENTRY_ACTIME now that it
doesn't consume any additional space? Also, why can't we do this with
a single unsigned long flags as before and have a simple method that
isolates and casts the lower 32bits as a u32?

static u32 *zram_get_actime_for_slot(struct zram *zram, u32 index) {
  return ((u32*)&zram->table[index].flags) + 1;
}

>
> --
> 2.52.0.239.gd5f0c6e74e-goog
>

