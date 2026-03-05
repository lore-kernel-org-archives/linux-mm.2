Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D043F30922
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 10:06:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 650EF6B008C; Thu,  5 Mar 2026 05:06:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FB016B0092; Thu,  5 Mar 2026 05:06:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EAA96B0095; Thu,  5 Mar 2026 05:06:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3FCE66B008C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:06:01 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D2AF68C701
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:06:00 +0000 (UTC)
X-FDA: 84511578480.23.239DBB0
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf04.hostedemail.com (Postfix) with ESMTP id E3EA940003
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:05:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SBbQtZoZ;
	spf=pass (imf04.hostedemail.com: domain of bgeffon@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772705158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H+g41L0ssohQDj8n8fJ6tCf5S39BQY8N7v69ggSq4hs=;
	b=8AdiTHrdhSC8NaZwN4DNOryo7+VK3u9dg0eCTJvIlstHxY5Hc7qzx+nRnV7uxdoQJJUi0z
	C5wWWb1o09BoF7h0oGE6PCVm7rin6zvYk8qbkjycI86NDywTAU6Qo99Sd4/ocBQdWckUXQ
	71K5BWvQFxwkdXPWVqV5itnwgDTLwkQ=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SBbQtZoZ;
	spf=pass (imf04.hostedemail.com: domain of bgeffon@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772705158; a=rsa-sha256;
	cv=pass;
	b=jkSLnkqLC7buwjqyqcGZ1e9ntQAqWE/AYnba91vKdh7qzBRE4FahYaN+zwNxavExJvLpoZ
	7Rrjbqijw8nAfVxv4FaphhyFRYbF2SO8zquUbeTQv91qp7QoRsJ+1TlUR9PyuDTXDlZdA3
	Dzbi7nuvDAwqWeiKfsk87sYML3D4EsY=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5033b64256dso443461cf.0
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 02:05:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772705158; cv=none;
        d=google.com; s=arc-20240605;
        b=K5v95zvNrq8O5pjLC537nRiepIM4icQHiGccd6U7QJGB8S8+D2mrDzLhqDc4B7p0Rs
         EuMciXMBbNE818kB2htrLCwmTwMqrnz8a5/sSWhYmDeaIloTEamD3JYrYej9qUx2MciH
         f/sm0/3jw3YlhNsXvwGth1oDAZVnKaJuBZy/9zmhSxQ2YEYykApkeOXgca7q/YLen8Of
         8yMSjzuKu1+0pOEIdPQGGs2MUanID2jcByuDcZ+2YIPQzZEB5GkNgdx9taAWj9SkeN/s
         2bhuCVDmJfqAato/yESchw6BTCFfo8BWjgkm6A+MdrM0EB/ud4j6Bg3EJFXzhRDK+MHb
         lbUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H+g41L0ssohQDj8n8fJ6tCf5S39BQY8N7v69ggSq4hs=;
        fh=Z2wvOux2vtGZLrqkGVzcZN3ctO8TOjEBEAGBE5QMyqU=;
        b=Ela2H1mu7G46RGpk5T/QWhK9k2M2faspX6IMJHavtyIP33yHYYvi9KckMmpbwLmZKM
         gbSDDsgZkZICBUjdPCJVuivnE01c45pR4MrCVqFl35NQV8eTboYxKE1479YfdOEvsj+u
         qsHhwKUN+lgNu4sYSPYycLZBYw6vZo8Z0ldhN9ZNqnaCUBvXWAYN59abwKcRJPdTyQzL
         GevlHnfNCXbxdkHlByZRZXIfQ35Pjv0VdPRUJoxQtCf3foMu3OB0H4w4zd/r5hfholsc
         111zBL29aSFONcFIyize4yE323Aggm05zTrKvVI500DGvgqWJEXf6+9WUzPOfqkTQh9D
         xaoQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772705158; x=1773309958; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H+g41L0ssohQDj8n8fJ6tCf5S39BQY8N7v69ggSq4hs=;
        b=SBbQtZoZUbtdFpthUQvIQ8imk2EMMzbN7VeJaV9JU39b8BI0Nvr++OD6Da9GTt6wIz
         4SufhaD0GuYL5GxVsZHNW1a8za2pHF/Yrk6PqRhHAJTZsD0JkoJhIc0rqV1pxrrAVAy2
         pp+XJmw8rtpMQKcILLeZANxWtG36fRKSJpCNJ1VN5TBqo99vL3mdqkCANJUS0UuJze2t
         YlVcuqTJXbBUv57zkUPeGpKLNE10Qmqg2Q5712Nqt7wIvXx2hgdG6qH1UUnVm4Ft7BNW
         18ANQpIWd9FB5KbilXOmiIrlRyYLUw1BGE0Ti4888+bEr+WGmq1kNQBjvMl/jmzKnomP
         RvPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772705158; x=1773309958;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H+g41L0ssohQDj8n8fJ6tCf5S39BQY8N7v69ggSq4hs=;
        b=VtSBmOwFjDoUj+S47xPD46H4gWaVZ/HNcA1eKXBRSwreGqbvopaHpUGdKe/GzH42+6
         k8/QW9SbwvMcZphzSDVPi4xe4XOdy90JJeSThqu/m2beoGhOYRyUTWBKEZAOjKvzB+cU
         72/ow9pp/6eFHHFqqJu6zoHKtfAGDfhyJXEmtgelOSHsrSLduWY86veGrelYYPlpct8C
         eoBggUAJiZTQhv/lvT5mktvlm3N2/6naeogFxQsytwNzZriMf8rDcxYUa9k/ELs11RuR
         PIC+XqUbgTCU9z8ZChkkLG4Xtd4iXBPWjQq8UvKgtRRNfOSU4k6UR5gCmNPQECo3WZOF
         XGbg==
X-Forwarded-Encrypted: i=1; AJvYcCVp0glsL7+LpYoO3SNkG9oXZnoWr+sbsbMcCuDUe33P7oJgvOSH2xYK/T8cMSfTTkof+xFDayrGgg==@kvack.org
X-Gm-Message-State: AOJu0YwMWyRPD4K/WhjkbFDubgU4H4GEWtmcwqLoJiMh9oDio0wcf9ut
	vFtG1T/k6DwttHGoZKR9rPo+nIYyHLDi0ZAPxipE+Z7XGWoPVn9lmuKDEN9iVVOQ+teDTG9De2n
	exrP5T8kp0ZM2l+Wc64c02kztIVJJqIxNqsuUG15xKLAYond4eTeYbLOrfQM=
X-Gm-Gg: ATEYQzw/uIkmcWTsGss2JfOqZTbjk5JiQ07JgFd/51QbB/NOBN8AypxPkgkpKsgQokq
	Qu8igXDAnBE04gall/CHpOLm5cHzRiGr4gU7zgE6Iq5L89fWNwTgkp4vLw44MThB5CivF4kQs/J
	1VX2hJPS/jpjyzy8olyUyXw6O8LKsdEXdvAfkNkczqPcv7UG2pNO/aJTeMWUbxnfT8ucd6M869z
	MW3j5DF/DX5+MYpYyswlN8F0rFYRlNHSFJHNHJP4la5yWsB4PZhmAndJyauMs2yM82fHqZuSVBa
	G12vTg3XCGwTPmY6ehPbuEzT+2X76xgSBOd1JVxkWoz+aGMNlqPFir9ZaqjqpM2PFtTtl17p0RZ
	i9ffJ4IG48Si3J/WP5bDs8Zwk3JeuqFf+QMRxhQpl0uNUrhXJ7Q6t76WZ9g==
X-Received: by 2002:a05:622a:1991:b0:507:35b2:6b9 with SMTP id
 d75a77b69052e-508e789aec2mr6977561cf.7.1772705157664; Thu, 05 Mar 2026
 02:05:57 -0800 (PST)
MIME-Version: 1.0
References: <20260305021619.617481-1-senozhatsky@chromium.org>
In-Reply-To: <20260305021619.617481-1-senozhatsky@chromium.org>
From: Brian Geffon <bgeffon@google.com>
Date: Thu, 5 Mar 2026 02:05:19 -0800
X-Gm-Features: AaiRm51mCLv4tspe-LWl4ePlymzT_ZYJEBCBG4LmtBoD7ujo4U4hnyv72lvhXA0
Message-ID: <CADyq12y1r9G9WZd0ODY1OhhHMzjELQeqp5nORc2rVMsbKXfMBQ@mail.gmail.com>
Subject: Re: [PATCH] zram: use GFP_KERNEL for post-processing slot allocation
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kxebww9gjg3awy1rqudfrgunzt4chfax
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: E3EA940003
X-HE-Tag: 1772705158-627321
X-HE-Meta: U2FsdGVkX1+NeX7mzVZ2lDzTRfRAPvswAYe5WFx/yOpSwGmKU5VvZdZaj+w8Uue1SeH1lu95FDPWl1K/yYFYoLwfUr2c62CviQktUjPz8osmX8pI0Z3HwTMpmEj66lz0wGVPGI2+fH5kwBAu8KmpS6wjm+XXL9zZJ+T1hWv+WlhrEZ8LMF1eTmxjE9qw/M9JMp4JsrTQtdZekzf9+vr94T73f9r8njaJiKj0cb5C2jUmsmgz3IwJdrKK3waE6+0YnqCg+qcVvtDtpiQIu2FjDyiCpCAhmj/cxiFxUL7XqBe5m2rTdPoX0LPoGwv267UWJy8VdQeEDukBCQaAxdDSZvQ3qtk6R6GNvB83nBbI/B4cnUqFn1HM5ozMmAzd5d2HvqEcfnUBDGb6GeMCIb7UxnInB6wam2wYcDhJhZgLDLoxKEF1HgRRAj1qMKzw0dCP1AnWSz8mIi+9SxQqNzAgd6L0aSfE2VFBhhR5iTR8h8dy72SFaUOnJ6tkxMrqWMXduyXzkTNfU/TnqssC+Tcb6YwPlzwUJl0Ug8fleza83UIYLgsVeHEIQFxLu2yh9NQS/JNcby6UOwHNve+USQfQxE8obQ62xkur8YUYgP1maHukTDFcnCoP7eTAiSlPNA7FEtZu/H+JqwfRges/LaxbqwMtcm9hezfXHtvdIjKTMAdrVAe5wPH8hojiW4YkMxts6mLmixF9ebfQnIs0THzthn9nqJVgp4Bq7jDwEpQa3SLOmQDIlSvMRxoro6kXydaN2LWMwXhdW4i16q8Wq1E7XVbFx6P94BGxHdaxGMFXlRt0oAwf3f2WIVOYaML87qbGlqkjkkEMeX3PV+lt99T8BCptwc66DmE4puQOkO7xcfsRQIq89nbDn6Ndtet9qUCxYdKQOJZvH60cBSHsMuUIeEBiKdUb0ovTVFTzyvIqN5VuUALJguhxO4UaboqoAChAxDRPgxw4CEpIrZBG9Db
 2lAazs1W
 uIfmdIsBZRRV6+1/K3X1LWd7KulA1OTQAWQfSZSBIqMAsZvVCyLDQm9Uyq+j3Kl+EQ5b3otQxGHjG/EUKg9dsbFozYJKsJgkEi0P8Xk8o/Mx8C1pgLviJPNz1jKh6+lwcU964GbV0wx9z4EHfWp7vAySABn19vouR+ukwY9lETnnPlM6F8aaIU2ubzeXjeQ0IXaL3ZuQqrSbHgDGzRML2t0s4LVENXeiZcZwJUjnzhTDsldB9j8EC3t2bA1GjvTmBPWQcfzFq6qBwfCD6twFk/RMHcgUw6Zdbafyb2GZZPiS61D1XbFvsef5KOa8Swt+SlPPuWGiDzVOYB/U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 4, 2026 at 6:16=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> Post-processing slot allocation used to be performed under
> slot bit-lock, so gfp was restricted, then we switched to
> a sleepable slot lock but gpf still remained restricted.
> Drop that restriction and use GFP_KERNEL instead.
>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Brian Geffon <bgeffon@google.com>
> ---
>  drivers/block/zram/zram_drv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.=
c
> index fa38d26119ec..6a6fd08a5a15 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -297,7 +297,7 @@ static bool place_pp_slot(struct zram *zram, struct z=
ram_pp_ctl *ctl,
>         struct zram_pp_slot *pps;
>         u32 bid;
>
> -       pps =3D kmalloc_obj(*pps, GFP_NOIO | __GFP_NOWARN);
> +       pps =3D kmalloc_obj(*pps, GFP_KERNEL | __GFP_NOWARN);
>         if (!pps)
>                 return false;
>
> --
> 2.53.0.473.g4a7958ca14-goog
>

