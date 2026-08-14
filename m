Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5A9BC5DF66
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 00:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1686B02D6; Thu, 13 Aug 2026 20:07:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95A2F6B02D7; Thu, 13 Aug 2026 20:07:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8688F6B02D8; Thu, 13 Aug 2026 20:07:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 634C96B02D6
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 20:07:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D7B9B1C10DD
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 00:07:20 +0000 (UTC)
X-FDA: 85097935440.04.5D76803
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id F0A3040002
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 00:07:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Afh983QF;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786666039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ymNd05TMLbBF073X1Jaf1Su92HzJ9CKX70prNcfpBTY=;
	b=zsOnKN0sCfyXUIOzAAv+mCV3TdVG/IMqDKcqltJi61vgUhGTEJSR6EQb8QfSekbzLuXd+x
	EY7X1GR4eZLozT08cGXijTGQoRxcm0YztnNEJjM9CLKmflF5trZYjEoU7/wDGTQE5S8KfL
	5v+Pjk4huBaUsEj22UhwRoObQNba/Io=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786666039;
	b=4OoUnlhGbKYU/1YFYT1fkr2AI9MvyjtJFPNksbndt0nSBAzhGu44EdqIBgUKkyAP5aNjFv
	zaL+ccut3XnoeKJK2DWco4JJ9H8Tff7i/QXaMLfEa7D21rJlmaWgDjL9opha1vGaXu6/Nz
	Jbd97I/E+sVsVTvUQdfGfDd49MweURA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Afh983QF;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C7A843E68
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 00:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51DC01F00A3D
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 00:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786666037;
	bh=ymNd05TMLbBF073X1Jaf1Su92HzJ9CKX70prNcfpBTY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Afh983QF1LkBVJ2nuQwMXW6+LWgGr2qKRj9sV7JR5T5hT7oEkD8Wy/BinAfbcBtz4
	 wHik6feoLeAysK6oKeDHD1r1SdNJW2VvZdJquCiA1CMVZDIOhMIoMf63VGI+9NxrDn
	 L0mO+V+553JARauFoif3mrl1O+twYxt1riW4nn8ZgsE8vRh//M45IhGTg7p0NSphHV
	 mJKUVF7aqcipe8w12R7kQd1P9ARgKvpNU/X+zyIUPvgXjJR8a9IyO62XGYc1qG4OUW
	 fF2U7sJnFlPYypigr6lO+eF3oOKI9Cna8A99VCYoIGPx6aQwmMq6dAB0Qv1QanKUV1
	 OLapkzYJrPelg==
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8f1a8e914a9so2498226d6.1
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:07:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrjfYVvbZQ5XHY7zznW8G2b7kgl2UvIxsMzqUpmLDzzXwp0/ozqGNI3wMD+qiH4FuoIwGIi2uzwOQ==@kvack.org
X-Gm-Message-State: AOJu0YxLcPj3rVTsbsfVgCzfdN966+U/z0ZuSOMJUWRiueQM3M/i9U63
	FoiXYE2PagLxIgEcprgvLWdgj0DdiWlwOBamzp8FiljPCXfPuAVW98VZDWJ3JOOnnkrpJAG+9lM
	dD10Djxw/xUZdlUrFQVuuYSMW52ywGJQ=
X-Received: by 2002:a05:6214:5985:b0:8de:ca40:c3b5 with SMTP id
 6a1803df08f44-90a91ddbcfbmr20707036d6.31.1786666036693; Thu, 13 Aug 2026
 17:07:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260805005545.66112-1-baohua@kernel.org> <anLmcHXqEX3HvSpZ@google.com>
In-Reply-To: <anLmcHXqEX3HvSpZ@google.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 14 Aug 2026 08:07:03 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wS1vhhrvk+BqLK++65ebENQE7yBPrM19q4HoRNEq2ckw@mail.gmail.com>
X-Gm-Features: AUfX_mwrRTRqLKQzDB-CDSDzAVKFlXV8qPon_DtZLlYle51QFid9QtlvHACjCd8
Message-ID: <CAGsJ_4wS1vhhrvk+BqLK++65ebENQE7yBPrM19q4HoRNEq2ckw@mail.gmail.com>
Subject: Re: [RFC PATCH] zram: avoid preemption with CPU-based compression backends
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: akpm@linux-foundation.org, bigeasy@linutronix.de, hdanton@sina.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, minchan@kernel.org, 
	ryncsn@gmail.com, yosry.ahmed@linux.dev, surenb@google.com, 
	Dongdong Zhang <zhangdongdong5@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: srbmdueqwoshx7t4rchiq3acie9pocg1
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F0A3040002
X-HE-Tag: 1786666038-121023
X-HE-Meta: U2FsdGVkX1/JPfKNAJDOdDky0tlv4MiG0ncAeMXML3/30Tn8twVQ6hIxq8D8hs+gqb4QlPVwmScyi+C0pEpBkIbqRAWsYCSt+k/jndR0+J6O3gy8yi9OrxlNE6lT5fodPo5qLPeIUtkDdGudnUzjVdiK9V3uPPnNQmePSn7Gi5SUHh1uGYLZ2oCdt8UGu3/uVmO+FDMj1P7H65IHqjngvsa37nwLsdy6zdJJjzj+BQN04aUTxT7WhBVg6dqQ37W3netSSwy11yJwpMKeLzUyu3wZfXb5vUEyBJf28AyUcL+/LSRThP2WJKtj8eHouCm2J9K/WZU9nKJjYzAUF2Gy86fqQEWuxA8CEfjy5sRm0CIgqhGpPaPOu11lrTqImKrovLmRF8Ch3EOb7DFCcob6jGIj5GTmN0xGtLddHEQ1/goMEVPILIqoSDfSCWEXcihSPSrNVa8syD1h/77owbLkuMFBwB1L/E1kwXAQ/2h0I8xWlS9+tcX5bv3sDSd/LwTJxuRmWl9v/TCUKXvIBsZYqumNRfRdxmNxxNJJ+1cRIzEZPkQIbOe6MhcuLu0clQ+zxv2iHgLV5nHSwtTR9vMaipJH5DX+/EPlsf3vpsuDAnpHaR07OlKAkoflpTjkWkDK2VTvT7JdTfAYNgxflTO348c80ONMnoWafqsSftKtVaH/nrCzkiL+E0YrtGcZUkzoKw6QXApsZoSDxhW/uQ8seOxv5MWZynOugD0Do7jj1m19nZHjx/07JJuKzBamFv3a3IJfC3IaClvVWPPWLwnM0Fjtd1ns8KCxhHgKRGyCQ43cbQaCiN7aGy9EplQhSunOetbPqZ846VLmvTad1Phb/CLOJ57XlgAXtHZyAjkFkwdHhfGUso5Et7O5zjXS6PMebw43cl31EnEvbITjnrN8XH+CQnoJYQJ0cAG4HTqr2fFFQRZLhB1Pm1ENSTfkH8cMB+O8xAzW0EAmcB7GMD8
 gogCuUai
 9y1hAhPiROLUZox/ZNngHV1Spk+fNbCQo87iCICzo9f915m0tdh0+Kad0kAyOqAxWiI9xK3zlIOubNaE5daKO8B8bMum1QQBtAddGTbJZ542rFPvhWA8jhA+d4bMi3/pO/d7Prmp36/UVfmJIH2KthBFosyASqYCMbZN+PcXmicMc8wazocaZGcJnLdY0K9uSJ1t5jQG7dIwPBashPeSEgSqkAp5/xkZUqloaAfvVix/q/Gu0zJuEfDDiYcxqZ3RhkiPCK0vzoNnEGQltO7KD4RWR6Z1cvxa98JUphfB/z8cjAMLX4ex+AYMEtD4giSnllGnhU3PtkZmS8G+40EmlaF+6aj6Rwze4CmmQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 5, 2026 at 3:31=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> On (26/08/05 08:55), Barry Song (Xiaomi) wrote:
> > @@ -128,14 +128,20 @@ struct zcomp_strm *zcomp_stream_get(struct zcomp =
*comp)
> >                * so then unlock and re-try on the current CPU.
> >                */
> >               mutex_lock(&zstrm->lock);
> > +             if (!comp->ops->async && !IS_ENABLED(CONFIG_PREEMPT_RT))
> > +                     preempt_disable();
>
> We take slot_lock(), which is preemptible, under stream lock on
> some paths.

Hi Sergey,

As promised in [1], those patches are still under testing on real
Android phones. However, I'm quite curious which path takes
slot_lock while holding the zstream lock. My initial testing shows
that this path doesn't seem to be exercised at all. Also, after
inspecting the code, I couldn't find any path that does this.

[1] https://lore.kernel.org/all/CAGsJ_4wd60ok7BF9XGRiO6dvddkaYTziPV-Bxq+3mA=
+-c7MvQA@mail.gmail.com/

Best Regards
Barry

