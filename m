Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7285C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 07:11:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0EDB8E0002; Wed,  6 Aug 2025 03:11:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBFF68E0001; Wed,  6 Aug 2025 03:11:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAE868E0002; Wed,  6 Aug 2025 03:11:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C91778E0001
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 03:11:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D8FE1160406
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 07:11:44 +0000 (UTC)
X-FDA: 83745462528.30.64BBDD8
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1A987100006
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 07:11:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ua6PiKeZ;
	spf=pass (imf05.hostedemail.com: domain of elver@google.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754464303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CIQROcvGNDvP322fenFV06FYLfCBAUlOFBfGGGTH+sk=;
	b=FRFO+GPS7ZqZYPJ3dGoR502D9Cmv/mzmYLSGZfK6JujfRoGf66OknHWFrf2PgJxSWXSS3H
	yVPg15BEyA6RYJSq/UJlOLSlhdzkcfUWXDSOPu8G878roFVYxfmaaD8FUvM9u8eGUSyUeC
	rkwOQlEm3Q2wXTJbrJuDG4v4AQg4iQ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754464303; a=rsa-sha256;
	cv=none;
	b=YvaMulVqhzU57tsBgTheZf54IJmgohVvavyE0GmFUyJpM/kZP4jJXPbgivqJlKFJSrt5V2
	ELBsCb4RaQld3c1lP61TY61IY8wzFerQZVrnKDZTMCOyEUaoHI+ieWalmy/PC3TKv2QgKT
	kiV5n9t+8Ln/8ZXUlVTN8aBNhm8iCo4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ua6PiKeZ;
	spf=pass (imf05.hostedemail.com: domain of elver@google.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b423b13e2c3so3878755a12.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 00:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754464302; x=1755069102; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CIQROcvGNDvP322fenFV06FYLfCBAUlOFBfGGGTH+sk=;
        b=Ua6PiKeZYyIdiYhIILDmIAK/fPHkhiAO6rtDe0SzROWC9Z3+ghZREVqUDLgOIdGcxu
         UVT+s5bciqhOtTgNFLZ6/aJlWy6qru6xrZB2GrPCvSpQAsBnEC9zZXwC1MiTxtIzEn1b
         fjeWhM5oCRFPPDXQeAP3qvZ6IJehw92i1tSSvYhugA1sYyltyiEfRggiKUPU5kLJJosu
         xjzLGd5/2S7NwGx9xydf4cxttzkloPJAjNdhUQnnBT8+I+TEPNQT12QPmTvPnczsdsTe
         PSu6UeGNJ9xsPDqUmyMSImxjdVhGzD5IAjGxLfiXZNw8eeNKNQ7PfvHTlxDrbkZJoOAF
         CnGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754464302; x=1755069102;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CIQROcvGNDvP322fenFV06FYLfCBAUlOFBfGGGTH+sk=;
        b=CbfGbkiwQIiAUpiLPgAgFPvdOunvv7gfg4aLBc0ql+R7yxJdf+RmS75bau3GwXhEhG
         Zk+ZBCPJurYHYdx+dpkhRMgupcRxmYVt3Ttn6qCsetc6HWtQIs5cn2zJ4OeERusSFLzt
         eMBLr0BxPeOGT8PzTxziRfgzNzvwoz1dDG82NCMV44aAT4ZYTl7d4bHFK6un11BXZyPh
         0vfICvkzTC1Ue4yg+odqGtVj6E0W9ncfmn+HPM39feBSry/3HVHMj1/SAsd0POj01ojW
         FdgyJhEjmrdGfD7K623zSukAmiqZ6LFSqjqu1c+ox6svoKnIOIWpN+GqFZe6KaxIgmTm
         qbLQ==
X-Gm-Message-State: AOJu0YwmgS+gsDYrDStFo+Q7nfsUl1/nGETy5cC/HMKFFZb6gp1yFQhE
	KCThAaLzn3VJcaiBBJEG9uWdY+jn0+y3cUaNGhW61MzXetnI3fBiQMoaI4oFRZCTngAbJA5ki6c
	vOsbagEEhBT1H9+fw8nxGf6evVLqvUjwd9tqhsuuY
X-Gm-Gg: ASbGnctBMTROuYRHt6meAvpBn7ChfYO2RHm7Q6vIYnqVKBNK1ZpRqQmFf/RPSvBrrFp
	nDNLy2rt9Ge+BZg3EirfJdD8fefaJmLjmdkFtqnstyuEjnBRt2vcLKQ6dmQOjhgoo5UlxDNtqyE
	tRosaqMgWsOawwvurCyk/40JDTJtFGVw/1QLoIHjN6yJP7vuy4v8uU/ZY9Fnrhn23sV8kbAx6k0
	L6FgriF5u3LSMHDpbbVJJ3KF23HXD0oFBpevJw=
X-Google-Smtp-Source: AGHT+IH4eNRLMKya/4o32tlSQWOb3//29rbV7XojFN8jVRMxJhB+5q+ILE/Mwm5nN4R+52ElrJ7C6Z2zf+YQwxTewsE=
X-Received: by 2002:a17:903:3c6b:b0:240:3bb7:fdc3 with SMTP id
 d9443c01a7336-242a0b6eac4mr17702345ad.28.1754464301762; Wed, 06 Aug 2025
 00:11:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250805062333.121553-1-bhe@redhat.com> <20250805062333.121553-3-bhe@redhat.com>
In-Reply-To: <20250805062333.121553-3-bhe@redhat.com>
From: Marco Elver <elver@google.com>
Date: Wed, 6 Aug 2025 09:11:05 +0200
X-Gm-Features: Ac12FXwvxDclvgbX00BaC4VbF0Z298SA2kuazPxeIBtYynYYBydJBukUdCOs9jk
Message-ID: <CANpmjNNr7e6DXQrZva8k46jELr1JSkjExWvQOyrkY5VD8mOadw@mail.gmail.com>
Subject: Re: [PATCH 2/4] mm/kasan: move kasan= code to common place
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com, 
	andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com, 
	akpm@linux-foundation.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 1A987100006
X-Stat-Signature: scryt8n4wkg7cj9qxhubahjnj394b7rs
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754464302-89594
X-HE-Meta: U2FsdGVkX1/k+JYsGC8KQrnmxpNytRW9ca+y8XokSJszcfXWfMmn5WbkY6dr/6p7hVFOOEdDqnqvBLHFrjGY6pYP1TT4rmud0+7aTS+DES2B3V+X49zOwEgJ0kGKDoNhegWJQ8T1FKqwFkYCQsCnn4ZOCYBBplxoL2RzMZ8Z7KSE00f1XnQ3d4OOBV/hACAIkdnWOPw8ujgadwn+OlhWaZ9/zZ0pwdSpIR3+AD6VSPiqvJvVALWm6ujBM6D1iCWW5YgZUX1HnjT6RlnMSonWKmDWbwiFKNU9r5bBPK5jvJN62sviih7UX2H6TeAKD8ZHI0+765i8bDTSAJ6ny5xTdJRIamEjT9J7nVyEBbxFyloZheYIk1cw7rQlebqKzU3KU2bXMVF56gpY5tF0cyRpyx7EYKF8RSZ/t9Hvmd40HZDf9bjR4eybb9qPZv1EIYUbC7rJYBKOMiyexrPSInzCFREnpik9pWC5r7kZ0RURXEDUO2R7JFAc8cIWHlZacmwTWNVESx/2oZwpy7goDT/r8vWDmCTyKx57FOrUOALwF+gktv9jZ1KyQd64AVgMzgw4KTKIgohq/bAF7sWXtwfB4QiTwBZgRE+aDpep5HkP8gs3mclXH777iliN1kH2dafDcyJU0/pTfkw/QonBTLY3gaUGgWKDV1zXodnSF2Px5oPhvTQnppQf9iCyRt/vX3j0s1tGx1KZqFpQ0TgyI1lRZkXsqzg2g2FCiFQuKzjuvJBg/EUqonsmwTDnkm6C6QYTbO39oOgFTL76WOeEJNZ08777QV3BtCObBkVgjhQwCX6QzaFvZBjJ1vpG3RZxEjTeOvI99CNWUTy+BQ7uYHe/361rYc9YHSSUghTsdCKdGuGYijKY8eIOSRZMkK+MRGfmJY32iRVapaLt38LFz0WJ9NR2ngrMMAwxt3J0cGPcT0MTuyod8z6qEUHaqaHPC2oILKVQLHqKxCvhE/irU8Y
 ofSkztPV
 uus61PMpzDwBAsu9+I3zI46H3XJSdqU+OanPoN447Is9HFXN2sOSAClIW6EMoEqWar31Nxe1bY15G9i8pvDW2G5Ht4xV0CnxAgpTonWi6Qhk3Kkk64/JVikwXjW9YpzR+NsHfW63fJp/Q88p1YnaJQk1B6dTnM4rrgiCQ+y/T2GOWCS1HF+OujE4TB1s/F8A66Iboz0u6e8dax5PhRTDl2T2/DB8/C8LeF8KXoOEE3C0R9HXtpYAZ7y8MzwSJKJ7t8DUmtgOSs/n0FylUTmwl5pJzmZmOaDRtZdRV/SLgoycF5VSgTs+oYKYqsqje8oO7Ie/43yozfsJd7lKCiJNqDUjJopxw4Ufy8342oM5q9dACJHYOb8WVtinCVedigmnP5G2G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 5 Aug 2025 at 08:24, 'Baoquan He' via kasan-dev
<kasan-dev@googlegroups.com> wrote:
>
> This allows generic and sw_tags to be set in kernel cmdline too.
>
> When at it, rename 'kasan_arg' to 'kasan_arg_disabled' as a bool
> variable. And expose 'kasan_flag_enabled' to kasan common place
> too.
>
> This is prepared for later adding kernel parameter kasan=on|off for
> all kasan modes.
>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  include/linux/kasan-enabled.h |  4 +++-
>  mm/kasan/common.c             | 27 +++++++++++++++++++++++++++
>  mm/kasan/hw_tags.c            | 35 ++---------------------------------
>  3 files changed, 32 insertions(+), 34 deletions(-)
>
> diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
> index 6f612d69ea0c..32f2d19f599f 100644
> --- a/include/linux/kasan-enabled.h
> +++ b/include/linux/kasan-enabled.h
> @@ -4,10 +4,12 @@
>
>  #include <linux/static_key.h>
>
> -#ifdef CONFIG_KASAN_HW_TAGS
> +extern bool kasan_arg_disabled;
>
>  DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
>
> +#ifdef CONFIG_KASAN_HW_TAGS
> +
>  static __always_inline bool kasan_enabled(void)
>  {
>         return static_branch_likely(&kasan_flag_enabled);
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index ed4873e18c75..fe6937654203 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -32,6 +32,33 @@
>  #include "kasan.h"
>  #include "../slab.h"
>
> +/*
> + * Whether KASAN is enabled at all.
> + * The value remains false until KASAN is initialized.
> + */
> +DEFINE_STATIC_KEY_FALSE(kasan_flag_enabled);
> +EXPORT_SYMBOL(kasan_flag_enabled);
> +
> +bool kasan_arg_disabled;

You lost __ro_after_init

> +/* kasan=off/on */
> +static int __init early_kasan_flag(char *arg)
> +{
> +       if (!arg)
> +               return -EINVAL;
> +
> +       if (!strcmp(arg, "off"))
> +               kasan_arg_disabled = true;
> +       else if (!strcmp(arg, "on"))
> +               kasan_arg_disabled = false;
> +       else
> +               return -EINVAL;
> +
> +       return 0;
> +}
> +early_param("kasan", early_kasan_flag);
> +
> +
> +

Why extra blank lines?

