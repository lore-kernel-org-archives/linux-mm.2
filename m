Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 880A0CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 22:04:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D82EF8E000C; Tue, 16 Sep 2025 18:04:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33218E0001; Tue, 16 Sep 2025 18:04:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C48F48E000C; Tue, 16 Sep 2025 18:04:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B0DA48E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:04:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7575A1DE10C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:04:36 +0000 (UTC)
X-FDA: 83896493352.05.635A1F2
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf19.hostedemail.com (Postfix) with ESMTP id 983211A000C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:04:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zTZZiiPc;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758060274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GO0OExCnC+Sl5h2asp7Gvh1+SINfuTNdIpxLbVzAb3Q=;
	b=GALvy7+VgjsQ5STld8Rah45duWjZ3qCfNYLd+mQt6F25e44eecLPItlyfNoXeHXhkbKRSy
	x4DEBtAzeatu8kRr5oMxqjYB+B2MO68fM0ooQRlpYHJ2FvxS/C5I0aw3Eja/cwCOitxSHh
	XmZE3A0Nw62tzCHotffhFFkqlQ4/weQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758060274; a=rsa-sha256;
	cv=none;
	b=e+C8PcMFFTtvacAzxexL+p8NpazheGemnyoIul1e8kppHV4IuTTfra+cYQT9LwaeFDK1Pj
	HBNMVqnN1LcU0WbEsFD0JhIuYT+492Z0CoyHbXW0pqFSHOKHQiOPR/OV8oDIxg6ffYK4M3
	awUpIoEhjjGPzJT6s9moV7LOqfl4tgc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zTZZiiPc;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4b4bcb9638aso204901cf.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758060274; x=1758665074; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GO0OExCnC+Sl5h2asp7Gvh1+SINfuTNdIpxLbVzAb3Q=;
        b=zTZZiiPcE1DzTybWqIN1+m/5zwqU/rPgM1T+x4pv+ik/J9DuFDdyjyO6jGwxmCcjGK
         8/Aj+nTWNquRt+RHq7fCBGe3A2t9n3DdqO2BdM1ftB7B36N7dL2HEqUVCZGqX0DXYdMx
         znnxVEOMb6W7Hfj4N8JVJao+hWcKJqEVmW3V6e/nsW0VHVNUJGe4xQhRdlNfakXEFpa6
         mRXSCaejwLJc1bLSItgI2Pz4BcS2NtdQZBbRAonUnFKGn9kcOfbbuUDlEA7SseHnvlhP
         S6udPWv0qxWOJySf3rbT5XnNgCAxliiFEOarzWscw8OtiLuC61EWgZWW54XfkxWln2fv
         z5Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758060274; x=1758665074;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GO0OExCnC+Sl5h2asp7Gvh1+SINfuTNdIpxLbVzAb3Q=;
        b=V0YO3ixuRcmbQHB+73QIw2fsaP/sTZ5xbEoa8Dn6YYGie7QG44k+6DLQw4H6Ns9Zh6
         IJcbbcUoEVSIjm25bjO8QA09oOvKjVnTFL7ig8elogN/5ZccCylLqR1IjQ32NtH1XElI
         8f7lz++lr7rcqwnRwDujszCQYfvW2vNKAU25Wtna+oX8xntVxd1vyCYNSg3awpUqr0PK
         4sUpbR9ICou4FLJs4Bu0YWQMpLClUXKnqsGgPaQquqDMSjO+2FR921NaeLg0kLVkUR11
         8WZAmcZnzWpH5Xky7WyMhy3oJE0YhYE8fjk1F6+e0W9ZFhTkVeDIgne7vAPklyjEyQsT
         yqzw==
X-Forwarded-Encrypted: i=1; AJvYcCUOil/kuWPoC5hZpYGDfRLCAz9HQKr0qAPNXV/rE3ryGn2TDUsGHRY3XNGH7JDq/eGcRo4V5D/6aQ==@kvack.org
X-Gm-Message-State: AOJu0YxhD3R2dzENeOUUVMgb6zCbuoVN7zzonWkfhdoKnnXUcUfYWB0u
	MZkA9boynJFwV6o2Z9SPPTRj7+QMdicjeNz0Dsf+q/OiAExsytRLZU1i6UGIoTk8eGXj0+wGtpC
	orslaBa4mK5kYVR6jjmrKaWos3OxCGMCML500gmid
X-Gm-Gg: ASbGncvgQcXXZhcZ2LiK10gbK+e5e25nVcTrsMom43vXYWK+LxelvAGnzDJPiYzKUwB
	iB4yRsWyXgjCRRwBIlxKKMnbWfoj6hl01tfQFxbjEx4GkGPqXkhQofeiPsSZXajTGiocrMgqLqc
	+DHq9Ff7SWq9weSQ3CfRD2J3Uwb1hDbiFVA5KLQNUwEqxl1yL/Bltfuq2Sztpmq9SgzC6UOjIm+
	TPLCpP+KlnwXLZtX4b1IT/hjZfOBECp7TVVbpuDGa4=
X-Google-Smtp-Source: AGHT+IGsKu+cTvUnrE+14NjFE3JwC3AX5wEjcsUr7wNzlgTYrg4z9FFihrHIMkxTd4MhTiMWV/kr4UXdJ0+aCZG77NE=
X-Received: by 2002:a05:622a:512:b0:4b2:febb:fc96 with SMTP id
 d75a77b69052e-4ba2dbd8e7fmr647301cf.9.1758060273178; Tue, 16 Sep 2025
 15:04:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250916-mm-rcuwait-v1-1-39a3beea6ec3@linutronix.de>
In-Reply-To: <20250916-mm-rcuwait-v1-1-39a3beea6ec3@linutronix.de>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 16 Sep 2025 15:04:21 -0700
X-Gm-Features: AS18NWAo0S1mrj9xxOmoISz9k1x-YAMjgdLRC_PrTLqqMXhYSeUwuLtYX6ohgmk
Message-ID: <CAJuCfpE-DPBp-0b0908FHvguSo_PqxE2LdUXvBiMLu1UCd5icQ@mail.gmail.com>
Subject: Re: [PATCH] mm: forward declare struct rcuwait together with rcuwait_wake_up()
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 983211A000C
X-Stat-Signature: 6afg7meq13nfh1i93qhbsqjf4wy9dyof
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758060274-701524
X-HE-Meta: U2FsdGVkX1+OjON7wRMU1BaEl7YdeVqCeeat0jWW3A2bnv0GMTMEjftCDOZhIf642oYgLbxZbOeABkAOdRMA0Xtm/U5KtrCN6k/CC6sUcMQyjkUajZzwle1I9/nzwL/w8u16JsI2rMuVCj0AoD3rlZkMYhB0e85wFSL4RCLyb0m38wNclO+8cuvy9fHWd5CbF6E0kPAcREwGlSKaFRYUu5d1rgSv2RgksHpj7uhUi/fk/uYZkcMx7gf3fEP+amzJEgc0HcON5vyPxUQaRowVBHkun7mvSqE6LRnsceqwYlo7cj64Ai8wY3NO7g0BMtwjo8Cc0dfj/GQwYar27pfWlw1+67qRMuBZRD08upYXfTCP+mi3n0j09hqB6pMgDHGYskrJPK4iIckpjVxYQ/Ri8BhDZQd+1fqyOx3FIci1NK0ybgAvpUv3D+KOGk801PjPEFmo3TIVdWPsVJcIT65KBNnOWBoXqwbWHtP5f4hMQGhiJZkWwczzTARRPiovOWL0A2ydi4OV0jdcOqTTL8vtoSS/Qlx/4ET+CiAYCbPXZlNiNJPq3XG+nSP0TGm6qLxjJAdsoJHx0/97vxkU/lhogworOpuCoOh5nyqEyF+MdmqZSAc7ODGYoJm0wvIzOCvFMk3vXq54dYmCNxm9euiJtHmdI/rHyzKOM4KYPaekGfEMcgjjvCV2PdOCcu3m61paYRyjHT9UWyoU5F27QAd7WhjISWADf/EQCheYNXr/NcF2mMDyQQ+W4Z5MuLXFnSM39tN2yN6dco64080+VIzZhnh38MJ7cq9URT4hVOn88/QuVhBN0I+mQ6atQ7UPXBrWsUuIVGq0+pTZQHwOEc6+PWpQREiaMiT0tQ5NZyRRWJab1tJ+S5vFMmI3h1WjDK1zShhJ/ojl+2TkbdtjlcjYwlnYEKPDYvK9dx9FPtrmHg1JH2bx7LlREGHBQ3teribjFYQ35r+VTkulgBiCZBa
 n/LFqz3p
 2BGgJuU+w163yg4rKCmrWgegfomH0sAZC2KxBwN30JD4px9/Wn3bXhd76LyStoFo9BjhANXxCKDGOXFZUptaIPhGLeN6YhqCo8wcxx5f4IUo3Bbzrly951sjLRXF9e3QQkIJxllHq5R2YuSEGBeHYqKf7ZCikKpDBTv53bLeIHA6CN+8dgthUie9zhHIlGr4ibRx/D5leBetNoF1KHqfAkUaNyVi8HIStMU5nKPXP/D4dPENy/gRb99OHqvcg5vI9jIfICmYpQLD6KzA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 6:59=E2=80=AFAM Thomas Wei=C3=9Fschuh
<thomas.weissschuh@linutronix.de> wrote:
>
> At the point of the forward declaration of rcuwait_wake_up()
> in mmap_lock.h 'struct rcuwait' may have not yet been declared,
> leading to compiler errors.
>
> Add an explicit forward declaration for the struct.
>
> Fixes: 75404e07663b ("mm: move mmap/vma locking logic into specific files=
")
> Signed-off-by: Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>
> ---
> This doesn't seem to break any in-tree code right now.
> I stumbled upon it while building a series for the next cycle.
> Instead of putting this fix into my series and spamming all the mm
> maintainers with it, maybe this could be part of the last mm bugfix pull
> for this cycle.

`struct rcuwait` is defined inside include/linux/types.h and
mmap_lock.h includes that file. Could you please explain in more
detail what exactly failed when you were building it?

> ---
>  include/linux/mmap_lock.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 11a078de9150df1beff4f0bfb16e199333767614..9792dd4fff0ff73829833aae8=
ea3229a31757d61 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -3,6 +3,7 @@
>  #define _LINUX_MMAP_LOCK_H
>
>  /* Avoid a dependency loop by declaring here. */
> +struct rcuwait;
>  extern int rcuwait_wake_up(struct rcuwait *w);
>
>  #include <linux/lockdep.h>
>
> ---
> base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
> change-id: 20250916-mm-rcuwait-03c5fe95f36d
>
> Best regards,
> --
> Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>
>

