Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BBD3D74EDE
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 15:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B57E96B04EC; Fri, 23 Jan 2026 10:06:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B185D6B04EE; Fri, 23 Jan 2026 10:06:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1A9B6B04EF; Fri, 23 Jan 2026 10:06:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90FE66B04EC
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:06:24 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3507614037D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:06:24 +0000 (UTC)
X-FDA: 84363554688.28.9412A7B
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0651F4000F
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:06:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fKlC9OB5;
	spf=pass (imf01.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769180782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bp32oonDOnHjCeFAW0yoNz/PodFJngfVEV3gIrxsHTI=;
	b=KRIbZA4VP67p7kQBneuRqBGbELkE49cF/W0REOHTJFKkh5DHJ9OnuX6/QNBzA4L2RulmgH
	60X/xNffxQEpLlF/4H3KJW/amgusEgB/IQfVHl6RGWkk1cO2wb/igj6zkq7JfCLK/oDvsb
	0G3HciHYyp6RjH0ybmyNwrk7DlFFjp8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fKlC9OB5;
	spf=pass (imf01.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769180782; a=rsa-sha256;
	cv=pass;
	b=Nk/4Kw94vq0HgFFVLtA8p7r5wY7WSr+DuYccbrPGpQ7nxKSpCApa1UbqJUUVNMFw1EBy7r
	5PRUGhfY2cskGKrqxqmrmoSjSNgqXSIm5DXxwo7a/TxAov5BCskEg7xJ6HF2wfGupe7Vil
	WQ+f+w8r3kk4fUs4MuKM7WwuaFafjGw=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-59de38466c2so1782123e87.0
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:06:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769180780; cv=none;
        d=google.com; s=arc-20240605;
        b=d2rf2O8OQc0/mmNtL+AvBgvwXhGYq+G6IklMmz8/MfpqdOnWRys4jN/G26R7tiPJbs
         d/uTyUBn+7t+bwgwEe9uFYYq1sm6hd8KkYI+gY1IdPohy51znna848AX6J45E/4NKFCX
         w1g3FtUSiVLLHn5AQgPwkv4aC8FkozY/RNCD7HmvBUOeINOWLq1BbXVw0Qu99XoYXbEC
         xiF16vtckSev9LwdioImmY5R/4rCxN06TKtFIS0V4wpimzVVYhagDNwHik1MatL/BXZb
         jV30Wl3Yp1E8cWwXS5CVZcoWLzRYOvrYtLTouJb9W10DyrdNwyXXRkp0MevM2MDbSJ8c
         IMng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bp32oonDOnHjCeFAW0yoNz/PodFJngfVEV3gIrxsHTI=;
        fh=7LwNO/RkD+DpUsz3LbYXLn+OdO6oOObOKnI5Hbe4Z04=;
        b=Y9/DwjbwlM7BZunI7UAzc9h02p5Ih1SqLWrb/n7AxDQMUO6JFCioP/E2XYgkRkYfpc
         HDFq9FsDrF+k5d9FcTA1ND5fMuniXfzL4tytUdm5xVfduVzvrrV4LjNaMhdYfbK81Oub
         F79N33cPhNUTV84o9hjc+NY+v4ZlX6HRi1O89CojQMflBae9aXmGpCr0dznuq2N42Ik3
         WrowBNokQp55KDbjq9NQyyTmlg78eb5two7ckM/1PmwBR0GlvJUQcssHu9mAvCK4CgDx
         k+tBaqTKTmtNkGWqbsOheJnC1mSDK1foQx3C1aZeOAs2C2c4YL4d7rliwrCeJ785Sm+C
         yorw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769180780; x=1769785580; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bp32oonDOnHjCeFAW0yoNz/PodFJngfVEV3gIrxsHTI=;
        b=fKlC9OB5PYMu/+8+OG8/xIG3BXs6/FEq76ljfJnRxuwUh8aA5WWy0zSfEohoK7OWzg
         k9/QcMBz52/ZqOQgq9DmyFrf/p6n/3+qwwZ1DNUAtVRak7jYfSnDp6FYkSnJ5qIq6qeC
         RPD8rHkbmCNWu0un/OHLhTZyA+VR1lWPinTovZhWCyc5G7Wt9qZkbJkvgLnaUFLHPQRM
         y1vlJShcZlQkC+x9sRs/4VKoww0e9f392M7PjbX8uvIf1WjutGw/lUygBzrxJjprhtOS
         Ymtjpz3uMaz7fgB0nL/jx94FyzYUBoVf/UZoRsXFlhy/eS4dtxVuYvC3UqXyt5hUAFIA
         w/GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769180780; x=1769785580;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bp32oonDOnHjCeFAW0yoNz/PodFJngfVEV3gIrxsHTI=;
        b=awREEKjOWQAF+60vjeihhfaFv4orf6FRKnrjjN16R67RSbGzl4eFio912n+qnH0Vua
         qGy1zzhhTgecZpJJmbKj+nBg7aWUUll46HSOmcPA1Kx6r+kb6Mg7OtWeeUnVE3xOpSfC
         0HxGCtK7JJUoos2ZmFnS7D36rtTLWvwjKKZI3g0ByDlOsB+E9wkRjmBAmCS0s8Gc9fJZ
         3GtpQRAaWe7C3us8v9sOjZK/IhfWxpgj6/xXO7PstkfghmW8KckBfAQz/xiE5IqSHBXL
         0QRpC3/rcNdAnhzGatHAwQV3H1WTt2Ns+f5ZisAZnBqCvBVkgJzOSmMXLXom49GZkYzs
         D3wQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLuoIZi9aB/92zB2edRkR+o+AGIZ8L9uT5zb1OPbw2NzRoo3e66oBpVXZC6iDR/5KgMKh9NCaXcQ==@kvack.org
X-Gm-Message-State: AOJu0YxVRaWmcnGjVPjLkM8XXw8Al07xyUc3hwdr0XiSilPr9G2NRVGL
	qWL0nV56xamICdMWo6H1Il748qEQEcqW0o6FtPrQRfdumFKmk5ERVFyHTMAnPpIvN6etQGrYQw6
	xG9EQQBp6vghxqAA2v6nHgFt0b84uYPM=
X-Gm-Gg: AZuq6aIYQUaH8ati4/YtLOWDpASAhewRLBcvosJpImS7ZyV983NWffjIRYxhcGx5POn
	/02VbhhNwS0FRD+szjeUXHN4s0aVYQXknxHH71fEz1mlUnfiPfzYsdxO3P/tYFHWxf+4KhHF1Zr
	09mLVi9HHPEZbUZvIL6nwpGJflqmgKLL0ia7WSsHk1dIp129G6xSYuqSlNmHr2aYDAgR2aWQt+4
	txkdx3vEqQv0n37iUISeM3RGQBIpZpG2njC1tqUDNGu74XqlnlS7zLltMfwdn5N5Qszkw==
X-Received: by 2002:a05:6512:39c4:b0:59d:de87:dda6 with SMTP id
 2adb3069b0e04-59de48fe58fmr1261220e87.11.1769180779674; Fri, 23 Jan 2026
 07:06:19 -0800 (PST)
MIME-Version: 1.0
References: <20260122114242.72139-1-wujianyue000@gmail.com>
 <20260123150108.43443-1-wujianyue000@gmail.com> <20260123150108.43443-2-wujianyue000@gmail.com>
In-Reply-To: <20260123150108.43443-2-wujianyue000@gmail.com>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Fri, 23 Jan 2026 23:06:07 +0800
X-Gm-Features: AZwV_Qim9akAoBLCRpH-EQVL5a8WyN8bKa0p8a8c1vBamrGpm1kjsQOy5v7Q3zc
Message-ID: <CAJxJ_jjn0i9pEOTXJUS=WTLAde-6-YwdQyijHvZ16nXpmQ2JNw@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] mm: optimize stat output for 11% sys time reduce
To: akpm@linux-foundation.org
Cc: shakeel.butt@linux.dev, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, inwardvessel@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0651F4000F
X-Stat-Signature: 8h13kz5xwecy7x6tu4togci4hu5tcmay
X-Rspam-User: 
X-HE-Tag: 1769180781-28897
X-HE-Meta: U2FsdGVkX18tDWR+K66w6XA+LWOX+OObRd4sKFu89j8Ef9FrxKn+EyVCjGLC6YUCR3oqRFt2ilFUQ/Z1dkVVvgYQ7P4rqlT9vH//ByPRdM4IWuu4OafRVhLc2uXd68MxoNoCbaGgLkDz/izvkroWfU/JqgsXLiJnvn8sNOt6yMK/5khzSZWlQs1aVL660ryI6alCLosGoqpCzD7XweDz0t8HueJ0rSH6wy40yGjX9WRIa90CwZwZKIzEiD3mN47KeFkumNQFToy5Zd8g2PBUWaeFMPHwbPlrKheaehKieUxI+2x9B3JiFF9J7EEqnj6JIaKOY9oLgkAzZ7ju8rL6Txm811NIrdg6SpwgujMvvzaeCt+AWpujaz7xCRDTKktkg/GDeHy0QCGsII57SX+yTvN4zS/GZmJeTIgh3GWU2+CxAK/sn9MOzGBZsSidawTS606XZBsJcM7NmTxuqkTgz32UdeJYswVFfU++Z0Aj8AtLj1G7GmzCwxrCN9SsjqrlzPG9wbKfoOLLtqlu6w9Vonwx+UeV6gDpYOJ4RmiITAZxHCgxIXUB19snJrUsDhPf468fgScFjIH3aebwYqVQ6YX/VgasdUpWuSSiVCfH0IN1/1CXwvK2fg7bSUVC/rNORSiH7BbXJ8YtYfpMW9M9RMB0Y9iYc39TypzMODGhMctnMS53ayneztPllYrYuWpXQXxdmTTEY100YfJ6vVZdHQgmEU6EsYk74nMsErAG16Y+/xnEDZkZbqJBl2ZBTU4HFIfqhiXe3RuEBalFc0lOJUBQ9c0VXkLAZye20vEM4sgV3eqLyMoflXt90is555lGJHtDXPwCWRytZ7GhcNPxA1Ti29v+3nlAYg51az/fUs8eA1pa/wZCL7PhJt0dFlCB5cFyF8ZgvrBUQ84jOj9E7JLxai6VfdvsH1GjyjTwNhW9c9aOT5sQunlOWcF8TAD4Y9NGVoUiShHz7G+DPgW
 ZtogyE1y
 k0wDlYJUfUGaAY7lCvmdILEv0nsq8gqw6Xo6KFAN9htDwtj+XLe08c0tEk45Nw1XxbkJsC8WMpO0VfgoFkY+Lz2zqJ8DGkhRFKzYwTeg3fkivDaM2jyjA38U3sA+kIviMPmJtRXcuyfcLUk78Ut8kTSoLWbHL3UhEvVM0LmLU8HykzgYTJD0u3xJbPGpN4bBNZDKLwzxPIFcxGzZUAjAv+7UJEOl9wtitfAqtAsSF2Y6B9lAWChC6o0ISdf9HbsurUV80Ww+xJtsgqf8yfj3qIOEtWjt5cOJN58U3RkQKNraFkjclL9A3i4DylSkA01nJB0hr8uiOJF/bX58FPJHZMxZqvNLv+NKzZJOTgNu1F6fSUkHH3BwYQmOYDxiODCQEx65dgPh13pukr2FOVBdnF2Bo9rDuryVTKMrxsppywObyDmuBsS+xfrAwb5FA2ZY5Wu+k9JLwEcaFomFaDIMhBl2dlQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 11:01=E2=80=AFPM Jianyue Wu <wujianyue000@gmail.com=
> wrote:
>
> Replace seq_buf_printf() calls in memcg stat formatting with a
> lightweight helper function and replace seq_printf() in numa stat
> output with direct seq operations to avoid printf format parsing
> overhead.
Seems I still need to add optimization for memcg_numa_stat_show(), though
the change there looks a bit complex, otherwise it didn't get enough perf g=
ain..

