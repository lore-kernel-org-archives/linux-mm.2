Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 505BBC44503
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 08:04:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 464856B008C; Thu,  9 Jul 2026 04:04:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43C6E6B0092; Thu,  9 Jul 2026 04:04:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378D06B0093; Thu,  9 Jul 2026 04:04:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 14B696B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:04:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A13CC8DE60
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:04:08 +0000 (UTC)
X-FDA: 84968500176.12.8B25722
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	by imf02.hostedemail.com (Postfix) with ESMTP id A595980002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:04:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783584246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yNJ0CPi6whzhd05Ug8Zp7I8ZdqXAVuZLf2mnR6sqHTI=;
	b=Rt8ZTDROg9zna8fR6DpmZb6+a1BpM3YFJawTtAuWDehw6M4llD+CR5lquFLH7n+6NAfJoA
	unEE5WtTdS04U6vL9Js3ILQlCQmB69AtuGUU+ukna6VDbGt6kMY2gHrzQqPXiZKEYCmXt1
	vT/dv4gznXdM4YTU2tqWg6JUjusoVMI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783584246;
	b=m2t2ELdD3X2LIsNEMrJEyjn8173Q7jZTZNSCDlE6EyBoICzUqsP7Uk4qs9UD4uJtVVrEQj
	9OVILtYGalDte/eVAJFbwFo86zbYlofWB9Sc5KqWuhORS04elKQf0w9GJkCZCImiCI0gUw
	aFqKVhG8yc9td/up/DoG9ZRSx+FZIiM=
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-5bdcbb1f3f2so835334e0c.3
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 01:04:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783584246; x=1784189046;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yNJ0CPi6whzhd05Ug8Zp7I8ZdqXAVuZLf2mnR6sqHTI=;
        b=qYj65HLFHrhQqsf8zjlc5F0a1t5qrmFGpBuWISZXN5S+NjKG3UjwIP2YXIsVoX5jeR
         LDTIwkfRIfM23UrIANKgB5hsM0EHqQzWetuZE/8+hHaCUK9szIFQIvqCNy8LEgWBWzHD
         8bguLx+fjIADXpLiJML2+8sUpIOWQtiQOKnS41tZmoERdQrk1eoHDJIpa9jNvKlEHLpl
         zJDj2NS80PISSrvn2OVHhAVHHfxI5eiBdFvXSJKD2pxvxffr2t4dI7aYvVGDARv9/y7D
         LJwNq5r6Kmlujk6CnDR5LDunZy8SL0K2ZWIgPof1dAozj6iogGIDlBqsKqiKtD7KtVqe
         jD+Q==
X-Forwarded-Encrypted: i=1; AHgh+RrRU0p5vwse+j7CTIPj026GjoZb6oNhydIGlIbNVXwnrFve3oUVJZZ8CA8K6i2niS5qJpmXBs7V+A==@kvack.org
X-Gm-Message-State: AOJu0YyOPkwFKeHS5/0JsZhFxs32yUzTA4NO495djfG13RtBsIjxZfMR
	vLqntFJ1Zz9tRIO/LLmfCXJ8ALkDJhUUH84bO2D0SpkxqZRsVIYeYA0dqeJ7byN/aSc=
X-Gm-Gg: AfdE7cm9uL0bdoZLvm2fzbKZWSh/8CPS9/pM7iRpVIunw6944RcPGzu+xlT3PIrC8w8
	RZ7Q78JqdX1mgjjFHoF9h7Fzaz3DK1qCMwcwzQ64Uk+oGGY6kquTabUbtjCShq6rfJI+Iimk2at
	G8I7MnYOmVXO+rqMxERuT9XjKx2q7BdJjxaf5Z2ZOeUBOW31vkRYKJ22RRFzqiyZ5yOR1o59bTK
	VXg5G3dVpLRvjrItSUWbetbt9NKchrex5sS+pExZhtb4LMLJrS/naM3v8e0+qoSzb+YfQXjOq7R
	AcWISNhUNHIbebGUjziKTtbu7TqRlpjYc25zfNzg7Uwf+mSuzCsn5e1Ncdl0lqwqPFm2iN5HG1B
	o443hp7p6cQRXag9WN0PoKCJHpTIhwOOVhCRjC86vdKXRAdTPeB1QomsU2uXpLku55ZVBXRyljw
	BFOKVosIK4kk489H9ruRN5pEvU0xtESOSnPBx6z9xd/br7oiS19A==
X-Received: by 2002:a05:6122:e22e:b0:5bd:c32e:b6de with SMTP id 71dfb90a1353d-5bf75f42538mr3369912e0c.14.1783584245735;
        Thu, 09 Jul 2026 01:04:05 -0700 (PDT)
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com. [209.85.222.49])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5bf6f849a44sm3138681e0c.9.2026.07.09.01.04.04
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2026 01:04:04 -0700 (PDT)
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-966d7738c3bso827831241.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 01:04:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpfvJg0dZjlepHcA0GAZw18N61aFtSZaoDmk1tryhG8I2fAokVmtdS41QT0UaRHm2uHsBDc5f/r4Q==@kvack.org
X-Received: by 2002:a05:6102:c47:b0:737:bfe6:3b02 with SMTP id
 ada2fe7eead31-744e0369abemr3827978137.18.1783584244666; Thu, 09 Jul 2026
 01:04:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260531-b4-tty-v2-0-f7149947d4ef@kernel.org> <20260531-b4-tty-v2-2-f7149947d4ef@kernel.org>
In-Reply-To: <20260531-b4-tty-v2-2-f7149947d4ef@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 9 Jul 2026 10:03:53 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWrLhDOFeeKJ573pvnmf0cNDsPJKEUQ_g+_+sawLEC6AQ@mail.gmail.com>
X-Gm-Features: AUfX_mz0QeF12JvS07xaiPbV1Hu_Z54v9ARU9pRFij_0pmo3eygFx3vrDpgxzV8
Message-ID: <CAMuHMdWrLhDOFeeKJ573pvnmf0cNDsPJKEUQ_g+_+sawLEC6AQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] tty: amiserial: replace get_zeroed_page() with kzalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jirislaby@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-serial@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: azgzi6d57yjjef8itmbzmbo93ucmwyea
X-Rspamd-Queue-Id: A595980002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783584246-836858
X-HE-Meta: U2FsdGVkX1/Yn3fH9uXbDVQpplI7wGL9cH+BVHwPa5jVTOtMhLl4GuL9fYV2leXYJEatpLwy5pq4YnkTka+qaspql7xeV/MeJHOxpAp9rkUSamdUFHR4Y1fMhkKsK30pda8ZP/K6P2r9dmMtfpHDzE38kVAth7RdwGfmwC3jG0XTmCbLJQ/O9CYjaiuEB9TQ83dD0Gaj0WubmdX1v1qz/OZYT401Io6/dGc22G+PJTJOFhWFuGNLWgSEWfC4Z90OVfM82Czig/IR5WKoXAKVCDbmD0+iNshfcgPbdCU1tVcVACWD9pzHumzP1Ov0gcrAwPbBBR3yrSYz/HDHnRaERW2ihaIdzY//LYslOd+c5o6HQSq3cnLap4q+kRJ5ptFiPGEaXcS7wEu65VGbwq1QvOg6wu2CfqKio5g5t7aWzZgdnwC4u49ow5iplDuijj/NL14qjmxxecPet6sI1DlOw5PUrM0w+9PB3jUJssvON5WxQcbsg52ytRcyVPe3JmhktofqIp+1ygZq8rmdVkhXrbL/oCAj1pPFx8nC+xLvkmD7KrzRktlaHI2RKu6acIjdpirh0TUY8bULDhfEtjEtwvl9eXz5+TtsXYo+aKgyilo5femqWC4q55GtlEbuTPeqlvixcsEyjQmmgAbkA1Br7yqsytrp5sLyzBkBlK3AwPDiHh+TFahCvQD+bu4cPMoVme+l/EJMn8eaAi7noPEuQfMzet3nt6YakJht9CTPmSTSnYa5ARhu+nNs/jZ0kzmYYryEqAbTrjxe4MLcS5vI9hIUsHNLFjWczE+4OsEQxY8/TV4aU5cmCEOaprusGQMnUti6dtbcKENA60gSihy/GfM1GNPryM5eg+BNQsF0NLhYiMDbLjwda7iwCFm5Oe/rv2yNLnnEgaXzwEiGoJhgAbbrC6ivxeELCZJxQV/4+ClcBa1afnl7uhj0xrOAPd7WY7mHtTqpS8z8I/Gsg0M
 icK05HsN
 R+cRuwQFK8Q/6FR8XLWAV8HYmUZqrFFFdSpKSg9K8yyZMJ2tno2rzCoTTm40Fz8EsJTq4HGs3WPAIfeYFPbmHGQ4SY6k3YzE+QC3sTpGEM1nDLK96M0km3Ur9gZkHNzdSpISCSj4YDGcyw44r+rS+TEiYrSIiSAFZ5R14EdoaALwLsnNgi5O/tYHFeQHeyXB05eUYwjmWOQXDbjGyXJkKtOfyxPLt6RgL8tiURGDP5GHltNF3nT3fq63oxljkYWurEH3IJJOLbT++iNxirTZWd2mUY7/b89IGHgfuvWYy686lT5NFFLmGjywkvGFsejkEsCw3yo2oXp6r4+iOfYvjJkVL+PBb5uz5OF/0UlSHmqUzY6hY80+gsuEtOvP8G/FzozKjMZf2VIzZYNfW9/REWvoqxXN3fajl0+mSqjVpoolWe+DP64YNr1r5X3FwjzC1Y4jUVMJOrz7i+gIP+9zlA6l3I9Zqgh3DgzEk+D/lI+bWyvomGwSsxslG2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On Sun, 31 May 2026 at 09:04, Mike Rapoport (Microsoft) <rppt@kernel.org> wrote:
> rs_startup() allocates a transmit ring buffer that is used to buffer reads
> and writes from/to serial data register.
>
> This buffer can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
>
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
>
> Replace use of get_zeroed_page() with kzalloc() and free_page() with
> kfree().
>
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks for your patch, which is now commit d26ed502d0c7c05c ("tty:
amiserial: replace get_zeroed_page() with kzalloc()") in tty/tty-next

> --- a/drivers/tty/amiserial.c
> +++ b/drivers/tty/amiserial.c
> @@ -443,23 +443,23 @@ static int rs_startup(struct tty_struct *tty, struct serial_state *info)
>         struct tty_port *port = &info->tport;
>         unsigned long flags;
>         int     retval=0;
> -       unsigned long page;
> +       void *buffer;

"char *", to match the type of info->xmit.buf?

>
> -       page = get_zeroed_page(GFP_KERNEL);
> -       if (!page)
> +       buffer = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +       if (!buffer)
>                 return -ENOMEM;
>
>         local_irq_save(flags);
>
>         if (tty_port_initialized(port)) {
> -               free_page(page);
> +               kfree(buffer);
>                 goto errout;
>         }
>
>         if (info->xmit.buf)
> -               free_page(page);
> +               kfree(buffer);
>         else
> -               info->xmit.buf = (unsigned char *) page;
> +               info->xmit.buf = buffer;
>
>  #ifdef SERIAL_DEBUG_OPEN
>         printk("starting up ttys%d ...", info->line);

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

