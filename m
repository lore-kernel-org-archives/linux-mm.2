Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91F2910ED674
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:42:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06C756B009D; Fri, 27 Mar 2026 10:42:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 044576B009E; Fri, 27 Mar 2026 10:42:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9C766B009F; Fri, 27 Mar 2026 10:42:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D855B6B009D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:42:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63AD61B8C9E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:42:00 +0000 (UTC)
X-FDA: 84592107600.18.042CB1F
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id 528D412000D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:41:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=DO3QFfLj;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774622518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nugzbSmXYxH79Cp7ObFsyTKICHKOQ5VI8ykZIBcaifc=;
	b=s69uIxjHg9b8U4qsjskxfufoEKa6E435jfkOSnoiBjsyu6LL4j6mWKA1vLBSRsx5WPnIAb
	SYTgOz9O9nkcXw3y6GeNDmGAPaDABuiS/MYblMMGhPsPHp3X79lEJUlQHxpJKxm/m+QarK
	kRjyACkQax5/+VWg0NSY+3YEt06uE0g=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=DO3QFfLj;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774622518; a=rsa-sha256;
	cv=pass;
	b=tZRwL0WCTEyxymQAQcM+ym9PC3xjR7nBEEB0YiVBEi1LC2kuDaA+x895bwqHbCXa6CYK1r
	pPsbAD0xcTee0s8jUIFqFDCD/pUMEx3+fVCNDX4Lc+zePeUm9KV1PXuK/bdyJeByu86B5G
	jy41C5hSuShJQwwxB9B7hpY89y5T6as=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-66b582b72aaso296075a12.1
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:41:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774622512; cv=none;
        d=google.com; s=arc-20240605;
        b=ZkgStoXi0VEt/V/Tmd2Mvd5XL5JJoK5HzPl9cczNJrpWEt5TMitYv1VaZ6qnfUmcKt
         MpneZgsNl3vMfXZd6DCAQRTHLPeWr3jA8QXGlJfe0gdk5CiztPEsPdnaJcM+d/+pl6sS
         gDWRZ2VbG2sx92KmZ5szpbHsbwKBEpybSpTuVNn9R8SFEW6jX49YiLJe22EQ6Rl7raK5
         SQ4IPQAB3Ry80XaLcN8zYQunxq9pd1vPneLbYwobpvKN4xU1RbBp/Dd54BGJKoyCh7mD
         ahzd+A+d5ePvRy1V+zOwD3HPo11K9i2JmUwrOygG0WpeGJYs6IeDbzqrunKuFROtdK7j
         kz9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nugzbSmXYxH79Cp7ObFsyTKICHKOQ5VI8ykZIBcaifc=;
        fh=NpKKDTLU+eoG/VpR6y7s7+eX1dB41jMbE4uCg7LZz8k=;
        b=Q7EaPO00HWX6pduEpKVxt8Cu+Imnigu5iyp0Jm1VhTewsCUmSBlJV3O4RahRqKrHzr
         vWGjoYJpPLhIkf8/zs/04oha7iTc+1I+ySb4746pPHUd8iups9bFtizfbIA5TTafKwEH
         j8NHEa2L1jjneXFLc0orbJwa+QJibQfeQoSvBym8DaITw+T/PpXvhNRC53Vacz6WYgn6
         SIbr+izBr/gDPPvQr919oIJ4PnXcuX0VS2FWko+JRSrRnSTCd0sZhWa9Vujzi3BohpJv
         MIyFoP89MdT+rDV0flfaJHE7fOBdFWre1aIGEGtTfoKaqjr3NUti5yQWIVxhTZp9gGRG
         ynxw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774622512; x=1775227312; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nugzbSmXYxH79Cp7ObFsyTKICHKOQ5VI8ykZIBcaifc=;
        b=DO3QFfLj3Mnk3zPKRduXvCypFKV7v5bSdFrFy+8My+Kyx+eWwGRZceQNc8JBdTiCMr
         hrloCjRWmpyG52Z0wQsedq6Gr4fp0gclsRvA9N9rBX2WP0pOLPQTa/Th/8r9SGFO0GUS
         mwB9ZgAMtAk39ZHYi56tDe0Gws/I2LdJsRNhUxLPZQ0NdPlqxGvIihlASV1SID0NJ9ti
         rLtga7qrAgGpdJUcNg4Y+cpdXbd6UdixiDa8myPvsR9oMNcKptkXztwoUEhptYXdZUjt
         P5JX5OwmLRIMwg4KtAOU4nUo+/N837QJu9kxy/YxLeJeWXnpKaev/x6mVdHjfmh2M+Qx
         dUPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774622512; x=1775227312;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nugzbSmXYxH79Cp7ObFsyTKICHKOQ5VI8ykZIBcaifc=;
        b=fngmel6nYz3R5roRkb5InwYYktHHgatd+AXGw+rApLPtqpRSZfyUHJzxxi5YCruc4G
         yPKuHBMDcfgv84mdpTvNl4JNVSSwKF+xmSN3GzHr+87lehKUTMSdGxpUPYtefeYwxX6v
         7wzaJcwSyk7EL5zXBKf8A0DTRKbzSiy5nb1L6nmqp6AvMpggwQBQcd+xS/TS5HjIB6JS
         WzZ597zHAeH7WV22WcRCc87E8WHl09o2kCFMeMeWvKFjAX3pi4gfYREDQ3Q86kmTvXCl
         AK5CuWGxfGa7ZLt1Qv0wzoYKfj0fP0u25MG5l4RE6aZCBVY0XGM8E4tK2/mSZ9xTKKPd
         Kr1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUtlRl5rTTQ6GwK4QxO5ww3+ShbPyu60o/Kv2SWx7yfJkAl6gcimjxeUPnbUzIJzhgR4C10tFKLUg==@kvack.org
X-Gm-Message-State: AOJu0YxWY/zN+7GRdXQWncf8/DxsCp4POg4F4hEo8AY3oh2qAmKMc8Nz
	QyLsLcHNwUfyAdDC2JXWimtbisOy1SBomfi6fyOcGxdysS89m8hrpMw4Awis5XaTJFHxi9gZ9ST
	TAqPrh0ppIZWGeLMO1JL4fMrzRxZ0g6WJ2Fxf43Edyw==
X-Gm-Gg: ATEYQzxqp8ZrSGpeEgDxhybv3zWgyzK1Cdzrwa1TXXLa+o3w7Y0yp4pEsdE76KzKLOf
	TP036quEdleo3K9P3Z9lxqBAP3+H5WmuPK0RTQx0wWsB+VAylPozaTBFGoaz5Q0T4MZ2BPOUDqB
	NRdPjYnKXAzDgpKdmkEJ8l4kmU6r+/qcQ9EE4ytKSmm7c8+wA1I3N8KdU9j9E2kdjEOnuTpBZSr
	JsEyNtcd6o53wjYZDjvdhGLCIqNoMgiD8bVeuMUwg6a85vpQHW0vcwvYSvvVo2sEygncQuyjbeD
	5wkyMWvorxaNX6izRSD4atYAscrd5/54H3jonw==
X-Received: by 2002:a05:6402:354b:b0:66a:50c2:6bd6 with SMTP id
 4fb4d7f45d1cf-66b28e7293cmr1686849a12.23.1774622511672; Fri, 27 Mar 2026
 07:41:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260327033335.696621-1-pasha.tatashin@soleen.com> <20260327033335.696621-10-pasha.tatashin@soleen.com>
In-Reply-To: <20260327033335.696621-10-pasha.tatashin@soleen.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 27 Mar 2026 10:41:15 -0400
X-Gm-Features: AQROBzDQzt0n5uJUWlk0xXXs0sfRPTiMoyJTGbGyDBSSRc0CqylzPeBQcXHKLw0
Message-ID: <CA+CK2bCcrqvMVvqfzh4Mxctwi+Z1qGX52x3mQ0vCSrLvf808-g@mail.gmail.com>
Subject: Re: [PATCH v3 09/10] liveupdate: Make unregister functions return void
To: rppt@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com, dmatlack@google.com, 
	pratyush@kernel.org, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 528D412000D
X-Stat-Signature: qnf3zd1saespbaxeszqjeg41rsa66e9x
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774622518-905895
X-HE-Meta: U2FsdGVkX19FsNK+7Myu4FI+/FiwKnKvDzKYjV8fTBE0O9KT5dXuC+UkGzgx7M8tA8V0OfVwheuyOxN/UPkNifdlhJWGnhX577+onyfarMP5gWck4O+bwF/8M/0DqGUXaa9axWtSACuRGMEM+inSAqr7+G07BxaEpBtZ8Q1e6TY+rXDZn3Y6Jt5gswBiYyR+z/RfXvfN4nCuHMDI5AMoKZcT+cwTINCEJvjDRfgi1hil3ufvsDgx0ZlFBzGZpjmC6iBc81W9KCXcu3LG/WvTI/V1ZmCvsbPbchVEGqAeHRdCnA5efF0Aw7Pixcv0aUWqq6EYhcbw2p3ptHUxCq1H+L5vuvCiYavrK6Yy28NP3jB+VVHQ0dB/p/UEQ41insfTL1q/KA4myIc8LVP+PXzXcrUQxmWVchF7rmr7OtbqZQ6dOSB4pXPDj2b9XDk6Ne3cp6LXRtjQjwdiqnBYk8zSt0OC/kwVhqJa615CQqr4fLsY2B+zeFUUSjVMXFvRQT6STVgdldZ7rCk8sASnsun21XkVSc2NHbdZrZVijGYDIxwhI4A0LeecmnHuEGY3t5/Iv1Fq2uytV6fDpaD1r/Ie5GWQwndJXEFH9TyZ/qx4od6RCiiITx+pCVU0pwe0mfDKsOFY1+2lWmzFhpjOZHk8bBwW+FtbToUBlnl75YRpE/Gby73oIpt36Sp0nbTu1bcIN63jlnm526jW8qUVIrNM6XXjBQLPYKLPhhVX5uGdHXIxhCkdqNIo40qQAYz4X3rPna+f3rO/I+ZvP/7ojxVkvdQb5V1EnQceBcrC0jtdadhDq+eyuzxDBvpeK6JrA5wculU+PMg1qIjWnjc9giEBOskxG9c3xJzalsuufsdMxGCey52oRdDIhJEVgAiSCDyKNVJ/rEQ38qf1Lt7HxGBK9f2nRnb6WVgPjtjGSUR3IxgE8F6GRFV8Ra5br6YUVGnXFSraeKcrB8NqlavaBmt
 mNMpTgUm
 zCWfCmk6hFkrnCs97y2R4rwrrLdTEMj+pixYavzr8lp8wuEoJVC3Y2ihiXOCxVyvbz/DC29H9uGxseru2GToCTSD9efCmVjyOrPDyKVbmPN5Gg9XkkMtOotvG7dGFhtMpr9jilK5INY9FlAtcOsaWyPb909YtX83c7A1hHJpVvoXD3cGRLHFTumv+MjhF5AZqtnzGi2P5GSMFdMbKJzYoYT2pgN7Q1WxxBa70z3QVLXhglCN4PevnFxhLmsDDp1E06UnIJcrEGo4BSV3QEPVQWNK4clcqPUPBS2lQ4+Ujxy2kyVYHrYcKGP6NxdJ848RyuDlSUBJuwK4VeiqJKtqldMpA+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 11:33=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> Change liveupdate_unregister_file_handler and liveupdate_unregister_flb
> to return void instead of an error code. This follows the design
> principle that unregistration during module unload should not fail,
> as the unload cannot be stopped at that point.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/linux/liveupdate.h   | 14 ++++++--------
>  kernel/liveupdate/luo_file.c | 14 ++------------
>  kernel/liveupdate/luo_flb.c  | 11 +++--------
>  3 files changed, 11 insertions(+), 28 deletions(-)
>
> diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
> index 73ca84de3eae..2ae27711ac41 100644
> --- a/include/linux/liveupdate.h
> +++ b/include/linux/liveupdate.h
> @@ -229,12 +229,12 @@ bool liveupdate_enabled(void);
>  int liveupdate_reboot(void);
>
>  int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)=
;
> -int liveupdate_unregister_file_handler(struct liveupdate_file_handler *f=
h);
> +void liveupdate_unregister_file_handler(struct liveupdate_file_handler *=
fh);
>
>  int liveupdate_register_flb(struct liveupdate_file_handler *fh,
>                             struct liveupdate_flb *flb);
> -int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
> -                             struct liveupdate_flb *flb);
> +void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
> +                              struct liveupdate_flb *flb);
>
>  int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp)=
;
>  int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb, void **objp)=
;
> @@ -256,9 +256,8 @@ static inline int liveupdate_register_file_handler(st=
ruct liveupdate_file_handle
>         return -EOPNOTSUPP;
>  }
>
> -static inline int liveupdate_unregister_file_handler(struct liveupdate_f=
ile_handler *fh)
> +static inline void liveupdate_unregister_file_handler(struct liveupdate_=
file_handler *fh)
>  {
> -       return -EOPNOTSUPP;
>  }
>
>  static inline int liveupdate_register_flb(struct liveupdate_file_handler=
 *fh,
> @@ -267,10 +266,9 @@ static inline int liveupdate_register_flb(struct liv=
eupdate_file_handler *fh,
>         return -EOPNOTSUPP;
>  }
>
> -static inline int liveupdate_unregister_flb(struct liveupdate_file_handl=
er *fh,
> -                                           struct liveupdate_flb *flb)
> +static inline void liveupdate_unregister_flb(struct liveupdate_file_hand=
ler *fh,
> +                                            struct liveupdate_flb *flb)
>  {
> -       return -EOPNOTSUPP;
>  }
>
>  static inline int liveupdate_flb_get_incoming(struct liveupdate_flb *flb=
,
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index dd55e5e74d69..761e8f7cfc82 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -884,25 +884,15 @@ int liveupdate_register_file_handler(struct liveupd=
ate_file_handler *fh)
>   *
>   * Unregisters the file handler from the liveupdate core. This function
>   * reverses the operations of liveupdate_register_file_handler().
> - *
> - * It ensures safe removal by checking that:
> - * No FLB registered with this file handler.
> - *
> - * If the unregistration fails, the internal test state is reverted.
> - *
> - * Return: 0 Success. -EOPNOTSUPP when live update is not enabled. -EBUS=
Y A live
> - * update is in progress, FLB is registred with this file handler.
>   */
> -int liveupdate_unregister_file_handler(struct liveupdate_file_handler *f=
h)
> +void liveupdate_unregister_file_handler(struct liveupdate_file_handler *=
fh)
>  {
>         if (!liveupdate_enabled())
> -               return -EOPNOTSUPP;
> +               return;
>
>         guard(rwsem_write)(&luo_register_rwlock);
>         luo_flb_unregister_all(fh);
>         list_del(&ACCESS_PRIVATE(fh, list));
>
>         module_put(fh->ops->owner);
> -
> -       return 0;
>  }
> diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
> index f8348138de70..8f3c9c63e320 100644
> --- a/kernel/liveupdate/luo_flb.c
> +++ b/kernel/liveupdate/luo_flb.c
> @@ -492,21 +492,16 @@ int liveupdate_register_flb(struct liveupdate_file_=
handler *fh,
>   * owner module (acquired during registration) is released.
>   *
>   * Context: It is typically called from a subsystem's module exit functi=
on.
> - * Return: 0 on success.
> - *         -EOPNOTSUPP if live update is disabled.
> - *         -ENOENT if the FLB was not found in the file handler's list.
>   */
> -int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
> -                             struct liveupdate_flb *flb)
> +void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
> +                              struct liveupdate_flb *flb)
>  {
>         if (!liveupdate_enabled())
> -               return -EOPNOTSUPP;
> +               return;
>
>         guard(rwsem_write)(&luo_register_rwlock);
>
>         luo_flb_unregister_one(fh, flb);
> -
> -       return 0;
>  }

A question from Sashiko:
If the file handler is unregistered and freed by its owner, its dependent
FLBs might still retain a stale pointer to it. When an FLB is later
unregistered and calls liveupdate_unregister_flb() with this stale fh
pointer, could luo_flb_unregister_one() dereference the freed memory and
cause a use-after-free?

No, there is no UAF possability here.

1. FLBs do not keep pointers to file handlers.
The relationship between file handlers and FLBs is asymmetric. A
struct liveupdate_file_handler maintains a list of its dependent FLBs
in its flb_list. And, the struct liveupdate_flb only tracks the number
of handlers using it and its position in a global list. It does not
store pointers back to the file handlers.

2. Manual FLB unregistration: When a subsystem calls
liveupdate_unregister_flb, it is responsible for providing a valid fh
pointer. Since the subsystem typically owns the lifetime of the fh (a
static structure in the module), it is the caller's responsibility not
to pass a stale pointer.

3. Atomatic FLB unregistration during
liveupdate_unregister_file_handler function, explicitly calls
luo_flb_unregister_all(fh): luo_flb_unregister_all(fh) iterates
through the handler's flb_list, calls luo_flb_unregister_one for each,
which removes the luo_flb_link from the handler and frees it. This
ensures that when the handler is gone, all its associations with FLBs
are already destroyed.

Pasha

