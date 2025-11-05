Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E699BCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 13:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51C368E000A; Wed,  5 Nov 2025 08:16:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F4638E0003; Wed,  5 Nov 2025 08:16:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40A2C8E000A; Wed,  5 Nov 2025 08:16:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 307608E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:16:41 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CDB88B872B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 13:16:40 +0000 (UTC)
X-FDA: 84076602960.18.C823BBA
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0594E160004
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 13:16:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RZpWGVaF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762348599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5VGZrah33ie0BfSxMEnkVJv7D+VrvHZac8M9hCEtR7k=;
	b=sZVaZ2jYzyOXlb90/Dw6h6KUdhkkyn7Mia1SMY28xK/hQC+R2S1hEz2fvh8Ivkj4EkGmu8
	AHARgibrvgKLnMroOJQJP26lLI0OC3mZVhn0ftuTMuD5Tye8brOcwHFIy2yGZ43p2GxJvY
	6gDZ7mDVnF2r1BZ03pGVNxOx0Yx4K+4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762348599; a=rsa-sha256;
	cv=none;
	b=QTmw2w7u/SXsnrxzvHlKZhJi5YwbFrxBmN9P5NxgIxa121/ME/+q04+z+QGYSjSqI+iLic
	KvjlHESoPYqoAmTVwQ8WQsPATkG73JHcw1QeSwomctfs+pT0dOpUtzPNNDjvsvP06YoNDh
	GSA3H9+XeqFGqnRlmXFqfRaYbKxOXgI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RZpWGVaF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-37a492d3840so13454211fa.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 05:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762348597; x=1762953397; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5VGZrah33ie0BfSxMEnkVJv7D+VrvHZac8M9hCEtR7k=;
        b=RZpWGVaF7LQZxhLawdOrpIOoeMNhw+RwfCI9prrJIOViX54VSTsrY8cw7hylhP3W+0
         3jpPwJ3W29VtTnK6orrsxs4JovrN/NbUCRNm7BqdUh495RQmqs28QnyDejTLU15kd6Pc
         WHn8Cb7K42y4KxRho0QRZMIHIAoIM0nBKmpKfdRuzu1PSRXe9t7j/xm3QOBZWBeV18lV
         1mzQ+DghK65YTyh0xQpNueHBmN1biZeonJbNB8j0s3Er6+45CBfbcHnL55imidEkp+bk
         aOv2Z1Q8A1auUSGWgUPuMQTDsvii1LvaH6bv5B0zRdCiIk3Gx5SZ2OLLO8f/kN7jQsEp
         Kykw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762348597; x=1762953397;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5VGZrah33ie0BfSxMEnkVJv7D+VrvHZac8M9hCEtR7k=;
        b=O8ds84mq5zzi/CmrC5rWoWXb4gg6Yot6M2uvIrNBsaQFza21N6glRYF79gWBilhyqC
         Cueq8NuFlQL8nxmicn88A3VYoyJeHJ5T51pDtQqnBqBWFyjybsJ/QpECrpuPffbkojte
         9fkMZepwJGNgAlrOV4AQJQY16zs4/lp4ppyeHIq/fmIJXCgLzvbhQNkrPC/PdkChmK6J
         6bDn6k1lv/PI7St6W1w6Lqu8EDa1C71INHbfRTnk9HOFfqu4HxfnJNLA95iMfkn3XJQS
         7IvYxUbU7SHFSvkNxChWrCp3CiVmwFMLUiMbn8G1BFXaXSnic+ZpMOpMlq+3yira7EW+
         c2Jg==
X-Forwarded-Encrypted: i=1; AJvYcCVt5iX7RIA/d28rJeEbOPjTiEk62WWl4IxmrqI5jDS/CG8uOeR2hwbO9zWcFNX0l9EdYQyvXcLrFg==@kvack.org
X-Gm-Message-State: AOJu0YxFV1Ka2PW1IokDmKnvixqdXWGd6DV4VmVQKhufC1h6YNoucpB5
	Tnmu/o2IRroW908uzWITRgQ9slRyWBZh2El2JjEmJm7vci8rh3Rl2LBhNOK+siTjTHXabxphRPn
	yHf128EKW4ONgSfdDO1yEvliFezM3k7k=
X-Gm-Gg: ASbGncsndm+VTY5ljMznXU4hrMhOBMi6KSJwZFKNoNUuwgKhGLWFfdhIAiJtQZzG39H
	ggimr9KAdAKDaxkzlvQZXI1Mnm61MPCWFBqek1ujU1YJjsPag1TSwZGz9QjFpAugm/gqP0UwQ7o
	bxcUKqFo4ShQxfLHuTKQsKDLjRubLB2b3cuPGAvvBl/tH54a0pkmSehlGljmWfgrl+GFt0CUmGV
	J2whJvsci4TxqwjW2bYRAs1Jb6VmQ50XUF41iIKoxGKGs4FjEgjDWKhsN7oN/Zl1VXh3730Vdqi
	9hE=
X-Google-Smtp-Source: AGHT+IG0YzXWMbTbwUU9D71aDeWBzEJ/KQVWDDiUSV4tlhYSsUwlaA485hhq2+u//XYa9y1WeInKFd1d1BUKtTZ3cIs=
X-Received: by 2002:a05:6512:3e22:b0:594:2bc4:8284 with SMTP id
 2adb3069b0e04-5943d80bfa2mr1150417e87.49.1762348596657; Wed, 05 Nov 2025
 05:16:36 -0800 (PST)
MIME-Version: 1.0
References: <20251103190429.104747-1-vishal.moola@gmail.com>
 <20251103190429.104747-2-vishal.moola@gmail.com> <aQopoAj3i2jdIX6V@pc636>
In-Reply-To: <aQopoAj3i2jdIX6V@pc636>
From: Uladzislau Rezki <urezki@gmail.com>
Date: Wed, 5 Nov 2025 14:16:24 +0100
X-Gm-Features: AWmQ_bm5zSslRL7odzax1g1yzWcLuJoFdgi4luT5u2tawHzjpU6ps8je4_UKZKU
Message-ID: <CA+KHdyWxjqAxVEBjOun9VxoeErWEyba3OvcJveLqnRuBLk2RLA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: na7sgtnr7x3eeche6yh4ees1gmmhnjk4
X-Rspam-User: 
X-Rspamd-Queue-Id: 0594E160004
X-Rspamd-Server: rspam10
X-HE-Tag: 1762348598-826391
X-HE-Meta: U2FsdGVkX186Pe0lsCmb8fR8698b3p4sQK4buBJtnP46COgJqY5wPFd3bB/frBZlZYOefpdC7ayjGQroxyab9R2IdpmSwh0NoW/5dvI5XewXGDnK2uoMplhAKChjeBUsWcTRzawNBG0dlHD935IE/zcGAZxqtut+F0v81mOpRrbKzzR9HnuUOlnvwNqLCu7J4LbgX95VdtkE+xK8bQ624XoXGhTM3dFByO9ll7w46t/pA9rSSst2poV5muQdREwJLAi5E8We0NATmJKd6xzkjUxy4yviQt3CnhNsA9j3ToqVk3/pudVWCo85Y13cjg9l7OBLcTEefpzVm4pwNGMwHoHVeODlgKJuB18ZlZIOOHkJLKYP1eHuqCpjZ3AOXOfoMg/xL0OfRLCE1nkuQODzJrgsPJntJ/zCYIjZ61D1+aycpGUC6SWsGlpjROJIbmGMugwEHEgOv2VJ50LFlkDoR6MkjvfneXVVdPUfnlozLfQZPSOX83CYn3xqIs1Ggmmpp7OyKuantyUcXUjp8Xw5/UB4x5cMRWHt1IxNXFn6x3Y6QSrUFaKRuzaG1BNLLDO9ZstVP/Pmob13rmXwCaZ0UIqtcHt7yddbC0vZEWEspxWI++FjKQm37waGWHY1JnD/ZNzZHk8LRltfInsQpHs5/o1GgrN12mFSYeRvSxsVOHmv1M4qGMIePRT+lJenMDuaNI9EEQ0PwaQM/JMsLXK5nArs2dHQeHQF8xgdDMgTXm9+0zI0lYt4LExwhDUSR7W6UDnsMeVkP3J9Kxj/pdQCzk9LxRaKt/yQM0rezH58Q6j/290QCWT/RRB5dNZ+gM1Gq8SJcEdPTPHmLTyryIosyyUCFbCdl6wei65E/SJ/XMNOx6DV/RilKWL4GicSnCg4zWL2+2Rq9iwUAcf/22AE7ScuLEds/eb6Y/R8gxvJS4Qyys66A99WycSeQz6VDP3oxi6gLB1w3yiyOvO9+/V
 oJQfh2/Z
 Ic5dxkXAOICykFXyiF5emTcxt2fTbFgxYsk0MpbJV7Szl+DE4O8f/oC4PLT/MaDyXf7ds3b7Ub+NrIxoB8w7uf0u6w+RyRE6nabFSUGG5Jk2PmiWmefFXPzMQbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Mon, Nov 03, 2025 at 11:04:26AM -0800, Vishal Moola (Oracle) wrote:
> > Vmalloc explicitly supports a list of flags, but we never enforce them.
> > vmalloc has been trying to handle unsupported flags by clearing and
> > setting flags wherever necessary. This is messy and makes the code
> > harder to understand, when we could simply check for a supported input
> > immediately instead.
> >
> > Define a helper mask and function telling callers they have passed in
> > invalid flags, and clear those unsupported vmalloc flags.
> >
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> > ---
> >  mm/vmalloc.c | 24 ++++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 0832f944544c..290016c7fb58 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3911,6 +3911,26 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> >       return NULL;
> >  }
> >
> > +/*
> > + * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
> > + * This gfp lists all flags currently passed through vmalloc. Currently,
> > + * __GFP_ZERO is used by BFP and __GFP_NORETRY is used by percpu.
> > + */
> > +#define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
> > +                             __GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY)
> > +
Also we do support %GFP_NOFS and %GFP_NOIO flags.

-- 
Uladzislau Rezki

