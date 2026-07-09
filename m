Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 144C2C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 08:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F16F56B008C; Thu,  9 Jul 2026 04:05:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEEA26B0092; Thu,  9 Jul 2026 04:05:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E051E6B0093; Thu,  9 Jul 2026 04:05:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B74A46B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:05:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 51F4D168EFD
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:05:58 +0000 (UTC)
X-FDA: 84968504796.27.89A443C
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	by imf31.hostedemail.com (Postfix) with ESMTP id 641792000F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:05:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	spf=pass (imf31.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783584356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ygb6NgkOkKFoK+FjOqgp4ZXsd/Yj8LwJxppMpG1O8hM=;
	b=CTgwC1nrmm6K6QMq43L84XypdQKsSDbiia4LAUz7PlHB6pCGbogHxl3JYap/Lm5DVgA6A7
	+TJrhJQ+i7MIcLfurtjxlB3IT4KCaPNaIF/H1/yDZtPjM009lj/t9W6ba6p9X7RGGx7De9
	HbexEKwdzi7NvwKNFc6itLZI/HOkx6c=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783584356;
	b=vvZDuezPwB5dhFmCNpBuvalhQAfavMWW/LoWUJiUTrEMAoaUwc7QcW5SGPU7rPUkmhbOH8
	jBd28iWKmA20F35FZeGC7aygRMPRafWo9gRwDZhC3zAzJB3AQTIqKHSkRAOXENVJrPuluT
	M35/aIHqWwylVkejTwav+lly8LP7wkQ=
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5bddd789ae4so486760e0c.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 01:05:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783584355; x=1784189155;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ygb6NgkOkKFoK+FjOqgp4ZXsd/Yj8LwJxppMpG1O8hM=;
        b=tCXHzUdLzMgYa8yag8UFSp0jpIh1ecPMLCT2hy2NRfSQEtvi2Nu8q86vHYnEbnSCKd
         GbPAf5fp3kNg1GpaC1HCws4sfBLXQa7xd0qOK+xnkTSbf+xzEx/QaNwIkWYOJiS0XVpG
         PScRYk4Ap50Gs0fAvPc+HWUHJi5TB8hY51mU7HMBUWSLKXBc/RxH9ku0c4iLkbhTprUZ
         DRRtEIMgMkS0B5s3CdKdgPnCNKTEXKchvUnZZOUKGCQHQ7oFic8njomKVyG6txbpM+x8
         q/Nq7HhulaAwCIVHkIMYziWN+5wCjtW1ma/iM5eYcwxsNsgO7CIqUQM2tAR7pgv/yeU8
         gsjw==
X-Forwarded-Encrypted: i=1; AHgh+RpxowrzTpFS+splzDsuhIQzuE6ZIic98VAWKDmmXk7POYEjQ7NIXn/lmzTQjF6mDoOeBXva/zDQdw==@kvack.org
X-Gm-Message-State: AOJu0Ywy0ema5zGOe4pejtsBVa3sGQSXsqTWV+FJKZqjAmafgA/xwdrI
	Gr0xBsWo5ZJVA6vHk2z1QXFoyobEUe/7+tEoQd7UHyowbE8KOz8TtYBAZt/c5QWeUHc=
X-Gm-Gg: AfdE7ckcTMqzSdLiio8xx1R0BuLO7tCBpiPF6nq8fE6HCc89vlh/L9NjfUPo94jBOpv
	4PD/XkwknmAxtlJEBPFIxpZI9wzyiz5BAN2Rubc+vZhsM92EiqVQ3cPXv9nujwCBHql3skle/TL
	1l7wnMdwfGm9QfpQ8crUX2bmhYhqyxKNzCsTCEtvlykDpivhYt4pkounc4s8+PuxtyBqAAMwIFl
	wc6iafMKxyZOAn5oaCc1mdpSDCkU9QxNWxfOHASliLmK8j7IuAK1zdWO45eOgMuJRwACeXFUbjw
	IVHAbnyxiyjNHFsBuhQytdrultuo4Ohu3aJneEJISfngYox1ZYVg2Hh+gmHfHAbfeL8H6AHdbv1
	Hv0+AAkmWd8ws3xGOUCuR6wxHJHgDrFrk/BuIg/l9pPDjSFr+HLsRsfHvZOJ5n5KpZgKlszmr32
	vDatrOpEmHZvbjEBizNRUi6Gkv05779jXKK8hd0rsYTiGqtvnYtQ==
X-Received: by 2002:a05:6122:219f:b0:5bf:6b19:2762 with SMTP id 71dfb90a1353d-5bf75d6413bmr3068146e0c.7.1783584355510;
        Thu, 09 Jul 2026 01:05:55 -0700 (PDT)
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com. [209.85.217.46])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5bf6f8ed2adsm3022745e0c.16.2026.07.09.01.05.54
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2026 01:05:55 -0700 (PDT)
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-73a75f251a7so430975137.2
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 01:05:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqiQDyvSODI2rteNHhwfbi7CIJXm66x0l5iAAS0V3bMa6oCMEUJEtrcqzy07i1GL/HQyrRNxAFHWw==@kvack.org
X-Received: by 2002:a05:6102:512c:b0:633:2389:3a82 with SMTP id
 ada2fe7eead31-744e030454cmr3833412137.28.1783584354697; Thu, 09 Jul 2026
 01:05:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260531-b4-tty-v2-0-f7149947d4ef@kernel.org> <20260531-b4-tty-v2-2-f7149947d4ef@kernel.org>
 <CAMuHMdWrLhDOFeeKJ573pvnmf0cNDsPJKEUQ_g+_+sawLEC6AQ@mail.gmail.com>
In-Reply-To: <CAMuHMdWrLhDOFeeKJ573pvnmf0cNDsPJKEUQ_g+_+sawLEC6AQ@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 9 Jul 2026 10:05:43 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXbT_hPnf1msm4exUoEMxRPvU5gmQbzi74b9rk0EopRqg@mail.gmail.com>
X-Gm-Features: AUfX_myA12YrlCT3ttWesIwGD_4s0xHALOjnC8y6S8V61ejNj9VFzSCSvQ5Ey08
Message-ID: <CAMuHMdXbT_hPnf1msm4exUoEMxRPvU5gmQbzi74b9rk0EopRqg@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] tty: amiserial: replace get_zeroed_page() with kzalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jirislaby@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-serial@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 641792000F
X-Stat-Signature: sb3fp3fqwmqub6sbd3btk4qg3rm9p56w
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783584356-105187
X-HE-Meta: U2FsdGVkX1+64AxVm4o8C0d/WxNK3wCH/GJS4wi2JjvCpUYzR4i85c6sLMrDiLqLACO8g3PCVZoRqgTEF6gXdqCcNh1HZ1XyzS8Mf4bU9nLixcuxCErnAW/Sy8hPOtcIqdkcoD7v4V3/YmwkvaBpi4wp+yvXSgndVBWoJZrErb5uC7X+fdVrLN40hCqyLr1Zs6qsguwC2uVm2EbzDC6k5NHLafT8YPwW/pE894shrHcLlbTzsXoPVQGS7otuVnYapXlKRmoTOUM4sPnKfx2hyMnOf7BvTxY7Sq6qoFeUwbf7ji088najSj45ZEEnVb64GjNpMp166W2/y0AyPxS+55nOwITwWR/Cxl0RToNE+iio4tTl0Kr6xNfH0MQd20WijgopMFc7DVbICSXdc1il9CyerSMfSmdLZ2YSN6Cf3xcD3cXQrgjjmjXpcfmM/nz7x2mDDQ7Psrvhqdl7P46wgb5CAIb5QmiVtlbYFBLqZRACLqTah21k/NQQqRe10fd0x14C+U8n5zuWwC0eio+lkGoQ1dFXp0Qio1itX9L7tieUAkoJGF8CK7U9MhKYdCzsLG137HyniJ5sH8rmgi8E/EHxNddZCxcn34A9yIDBahMD3SxHHM2mex8bx1cnnteAyz5zF4VEVgc7EtkU4byFM7fN89nTTChNQsySKlsMgcr3NX/VMPqokD+2gloJsGVpDRqMUIGfQ95XwfxFusfROgJ+UVsj/ExDym6Gl19R8jXzZd8fZBbkuXQjSE4fXd7pxTZBT+5IAOpLHywx0RodeDgfQYOCsPWj+n2c5U9ATRp00TkeYAZYm91NVjuHoeSJcKYosdILf+sqpR5VcEXdsZjTuCQC72p/zEl3xu9akc+/EcLQeuStjUC8oZ0pmOUHlA68A+ZFDTWqiGGUwlUWT5WMZwHXllR8QBA41WTem8g/vCb2/iivOoDHzyEnkIfyFeRnvLIcXE/Q5HySZku
 ZVc62lhX
 GIHllJ8tcTXzJ/kopWdwNOPCiKZENM5zpBq+Fko1pu88vyPoa4IRSxiMyskMYEPxX43S1v1cCY7zjim4fde1OVJYeriCxyRzeUEulOmlMIM6GM26hb1s53eAl1qveWUWK/Bs73DbHbDN3F3DGTUSa7HT+n7N7aYcgDBA+PotabCnjIHPD6UqOh7yj5O9tL5IEKW0R05uk3JpGgtFFXLb6MOOEPbYbMv1l1qzbFXG3lZgrgv70D3ySBL462K7VkfNl0oOdW+LhCHYixVDAp6cbsUoLNSwLUgkfKPDlcqW7+rsgrDQ4uCNkQT8N/diXkAhBO4RsMhVI/CqURQODOAsjU/LcksTX7e86KpBSVhU8dVQTl5nTpmngb62PMXuD5HhmCZyRI738dSqqL/H8INjMT95p3T6YXWJkKMiPvErpjveg7AOyGOwaglTnX0NtpUoz+6Gx7yfkHKCC3urxfozEno38Df2MiFdlHEMevkmJNUZGgoLJrE1FFB+LsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 9 Jul 2026 at 10:03, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Sun, 31 May 2026 at 09:04, Mike Rapoport (Microsoft) <rppt@kernel.org> wrote:
> > rs_startup() allocates a transmit ring buffer that is used to buffer reads
> > and writes from/to serial data register.
> >
> > This buffer can be allocated with kmalloc() as there's nothing special
> > about it to go directly to the page allocator.
> >
> > kmalloc() provides a better API that does not require ugly casts and
> > kfree() does not need to know the size of the freed object.
> >
> > Replace use of get_zeroed_page() with kzalloc() and free_page() with
> > kfree().
> >
> > Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>
> Thanks for your patch, which is now commit d26ed502d0c7c05c ("tty:
> amiserial: replace get_zeroed_page() with kzalloc()") in tty/tty-next

Sorry, I replied to the work version: the applied patch is not this
v2, or the even newer v3, but v1?

> > --- a/drivers/tty/amiserial.c
> > +++ b/drivers/tty/amiserial.c
> > @@ -443,23 +443,23 @@ static int rs_startup(struct tty_struct *tty, struct serial_state *info)
> >         struct tty_port *port = &info->tport;
> >         unsigned long flags;
> >         int     retval=0;
> > -       unsigned long page;
> > +       void *buffer;
>
> "char *", to match the type of info->xmit.buf?
>
> >
> > -       page = get_zeroed_page(GFP_KERNEL);
> > -       if (!page)
> > +       buffer = kzalloc(PAGE_SIZE, GFP_KERNEL);
> > +       if (!buffer)
> >                 return -ENOMEM;
> >
> >         local_irq_save(flags);
> >
> >         if (tty_port_initialized(port)) {
> > -               free_page(page);
> > +               kfree(buffer);
> >                 goto errout;
> >         }
> >
> >         if (info->xmit.buf)
> > -               free_page(page);
> > +               kfree(buffer);
> >         else
> > -               info->xmit.buf = (unsigned char *) page;
> > +               info->xmit.buf = buffer;
> >
> >  #ifdef SERIAL_DEBUG_OPEN
> >         printk("starting up ttys%d ...", info->line);

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

