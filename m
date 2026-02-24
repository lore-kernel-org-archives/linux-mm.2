Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1898BF3C9A8
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 16:16:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CF676B0089; Tue, 24 Feb 2026 11:16:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 786DB6B008A; Tue, 24 Feb 2026 11:16:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 689336B008C; Tue, 24 Feb 2026 11:16:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 55D756B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:16:14 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0FA2756EDA
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:16:14 +0000 (UTC)
X-FDA: 84479852268.05.94D0D04
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0F8D340002
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:16:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MYW6tFXb;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771949772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nw2ELX+8RjGMTSAnCI7BjUsdA4OU12s3IS0WITZ6+04=;
	b=216oF854IdlTcpHwo0bTX/J2QlTJao8ptpnsVrqlM8w/YqqOExpLyiGzYzDQKZx6zFBrPV
	mBSM/gjfQXZ5ALuhsYxW0fG+FgKiAw5nAfKaOZXWKYU1/aADg9pA2DYLVwnqiq5kO/Txe+
	7HQ7GIV9g2Zxd1qyXlPoichiyeOHA+c=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MYW6tFXb;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771949772; a=rsa-sha256;
	cv=pass;
	b=XmRdm+XcKR9Wm1sSkGdhC9AuYO5holrkglMkwuvv1Je10uIj4Ltxj9WSAwIHqi7C5DdEWn
	vGHah4ZLVNmP+QFKCdjVQ61QVXG4nPpGM9t82SDCjjLm/4aB7In2Ea+ZTlHUCl8CUAmd6O
	1cgnbRpvm6NpM3ylLWCPiyFJhPa+vzE=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-506a355aedfso46491cf.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:16:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771949771; cv=none;
        d=google.com; s=arc-20240605;
        b=cB7hvxtLfLwM1FlZ0EqSgSW3I4SLjy7VI5C1yyIt5pFMRL86pfQaoj3Ppp8vuFob2X
         Wlo1W0w7mM+nV9Bt4zpqUggTxIkZcZtfBC2s6NwLnPuX1VZ5thgT9m78DkMh25zqFPyS
         n1VmoosWWs4p+m2Fb88ngpf4CC8qC9/JOowaPxuvOhjNlvUvejxq8HQItccUeY9MDZO8
         MZswQjrxnuRj3UoCoL/7M4aEpE9SedLZu2WYBvt0kLgh4Cgmok7+rnv5Z17gXH97pUNc
         4mOAmTzAm0X6aP4sGr0t07miC02Mn2TnKBltkyLpcaJuUZuZmbKA6K1uNYFqegS6vksY
         yCDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nw2ELX+8RjGMTSAnCI7BjUsdA4OU12s3IS0WITZ6+04=;
        fh=4uePOqqyvX338jh28lVqFdQx810zGMXmgXok5C7y3F4=;
        b=RRNUP43CNQ2arFwqUn5vjQ2MlV7vqSNl+huBAqgHjcfAbAoifTM1P6UPvEl/aN20In
         xr8gKgx7Ia3xTc+e7/wf0Ax976wR52KC6n5s6QcMJ8HNXRKyFLtlKo+6DE/tDZTVUH7i
         vNNimPycIjn0HFsWKrNlD0UNNkR8vAcgmeg1FAbsxF3uHTU2zHzX9JENQpMcvD/mwqpn
         ScfdLDNOFRpUbYqQ34CF4J1AbODUKxxqQt8kWHY4lZFTkp9WkFxM8P6wddWdMLiYNQcZ
         iucckdmXNHAALT+5BjVr2e8PQFX0bmTccpsZwnj8jsm8hkuHXx1fzpUaGPraO8eINw/p
         EHIw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771949771; x=1772554571; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nw2ELX+8RjGMTSAnCI7BjUsdA4OU12s3IS0WITZ6+04=;
        b=MYW6tFXbaRKAT7vBPI0i5V2h4otEf3Enddp7Aadm/DjnI9RiaFj0usmAPTpA9LU8zw
         wf0bQoPSD6rf1wMCCQuKHw/LPuh3P96YH8CyxKaLyXa9C1JGNxyxuOV+76MhY8E5QZw9
         Ltls2mO46C5TULS/pqJ2xTi8rIL51q1pChG1GBFaf3OV/wtlggBaHAz+yo4ggcvFjkyf
         vqHnDzePLkSGsosVYjGF0zmfxtAKRIBmvDyx9W13qDfeA5MbP/mCTnSrsY0ro7yoZR3I
         EMnpgClm1qNbIYOB4qnPeQMZHeKZnu0qopgaSlL2WofCGrVGK4HdkW226Ai7E1U9nIpk
         SvRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771949771; x=1772554571;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nw2ELX+8RjGMTSAnCI7BjUsdA4OU12s3IS0WITZ6+04=;
        b=uz8g2lt8PkVB2cepu3QyzOJdKhLiGhe2M2OaVUNBPb9d6Xor3f3BaXYTC4mx9v3FPO
         i9owStq7Amg3l43r9o4zUupD7LbQVzM2Kn01AVtkt9Y8Z0+4uCGMFUEgoKgWuk3Nk/b0
         I0flX1TxtgX8sJLhjvh0nl0ay5ig516CEQ2YrNLYFs68ZARYX7/EwxUTo/ATkb6tpUC2
         UEQPK7DL5o3F9r0QxGf9lxZ04R8WgOd7ueOs5b8aiIPjcTEFgz7f8Y5Fd0IHSr9+CYCu
         DWWj8Q3/cjmlTBNP8e5BbsRTa5GaWGAmxn06vH93D1Z8EsaOYINxFFUeTEhMgbYQuHvs
         oOzw==
X-Forwarded-Encrypted: i=1; AJvYcCUDDpXh79AUJLKi6GHByTdvUy6N/E+PEuU3qWWmuPyp60Jk3GwNEolxo6Z6Q4tNEEvLVMZycR7wFA==@kvack.org
X-Gm-Message-State: AOJu0YwNJ8ogqNYV2MtRbCqLHzJjbmSc7mw36TmfKLITsY3jpNYOAUct
	ymjJ8ybaEEQPBD4UQYSfITKz2dz8xQrhtRNHz99FGV+W17QaEtJFls4PI0k1StQBzNzxX/Wq9Rj
	lNtX6MBAxHcesMcjQkz0MzxhAHzwnMv7zkz05knd5
X-Gm-Gg: AZuq6aL17zaScCMh/FuYRnDfJACsum6s37HQjv+HUwiQiGNHnljJJ/TPAi8FRkaCYKs
	3GIxHbpETgQmZCDAYoMRxldOLQXwMvipB+DXsfiqhab2qLxc1CKXnQ9TJsVL9xC1EzzupIv9ydq
	Q/1xm/eXdjKLY3p94kRoEszuUERuVOj3xBZixrYb4jQ4BSeZvknpmI3CxTBkxtc01TIPhs0y0hj
	aUjWg1ndeAxnEhygftzx0rND4my75r2bEAchnpdcQgzlOMfjBYRgDFDZom46DHZw/Dx6XrycW7+
	gisvYpbXgWIm/x23kdmNnF9bCf/anDD02uIK9A==
X-Received: by 2002:ac8:5d10:0:b0:501:3b94:bcae with SMTP id
 d75a77b69052e-5072c9f2b6cmr14002501cf.8.1771949769912; Tue, 24 Feb 2026
 08:16:09 -0800 (PST)
MIME-Version: 1.0
References: <20260223155128.3849-1-00107082@163.com> <6ca5f70c-43c5-4ba3-bdc4-8c48607dbe7c@suse.com>
 <37bbaa9.1831.19c8d7a2cac.Coremail.00107082@163.com> <CAJuCfpEsykCarj6_k5T9EeLDfsA0fFL182g1hQ+tb-7EM=izsw@mail.gmail.com>
 <aZ2yrEz2ZVggT7UL@hyeyoo> <aZ21CP0d-RRAjUCX@hyeyoo>
In-Reply-To: <aZ21CP0d-RRAjUCX@hyeyoo>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 24 Feb 2026 08:15:57 -0800
X-Gm-Features: AaiRm50l9R2NMJCBk7iCgcVpIQFwIIIUvEe2OHj1vGndHLX6iigDlGh6hAEQvac
Message-ID: <CAJuCfpHjeFW3xJii3ZcHD_CH8iagHaGGG35wv=ErU7Z8j1vbtw@mail.gmail.com>
Subject: Re: [7.0-rc1] codetag: kernel warning "alloc_tag was not set" during boot
To: Harry Yoo <harry.yoo@oracle.com>
Cc: David Wang <00107082@163.com>, Vlastimil Babka <vbabka@suse.com>, vbabka@suse.cz, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0F8D340002
X-Stat-Signature: kgox5a6odpqdckc4wnyyp4a6zuz5dcsx
X-HE-Tag: 1771949771-78733
X-HE-Meta: U2FsdGVkX1/BTaosKxR1/Jrdq+LPvhgYObjmoK8tRz61/a1/Shrknl1i4DdCOCyyQv/1AhXcsC2wlXDFq+qadjpKY9LbES2u9ZaEsVnS7mZhYhhzkTsMvMpTq/KanS7i6+PdYk+AWmC3A/haC1lm+Q1j06/jCBTX2qc/x67EtBL/BUQe5ZctupCuu6to4+wr6LUJMkQmSNKgLShW00TBnZrwtj6j/z2Gw+P4HBuWfCR2UXe97rWs0us6cihA/NBCi0pyAn74C52bwOT9YdYHnwxtRKyFQRdg2glp1D46+XhjF6ne8EhH1zKviuQTH0HR1pkze2YaL3VXJTwYj0BJXsr5fUrTzNuxH2YCLYocmMQGw4T9T78o1ZsQ26LCJwovvT7yWk3U4N022Cw8AjYKNODoybzW/MCeJPP6OswtOImw5ImdPoL7SjRmekKziEU6nGR9T179lbduKufdZbvP93apKQdvXe8vdnqTB/ArEAZ/VCYeVNYYs0JRIFeK5LSTKqdg2/9BAYIGxQ0R8CON4u2JG+mMzy8ovrqOhClAiM/QRogFmQASi10aWzVwMoo/Aylx+pCaNb5Bl9ZlB19M2VTj7YOYgol8O9Qiku9rk8Gmmrknh9RP3XUNts0ONtFQ5HU6YC5jxcXTdT8ns2LlfV8oSAOcECFBMpN6XoA297+/CTpgLOkSwb9tpHKa2v7DPD+h5ZhPePQHOLemulPmkG9QPBI79XgWf/i2ARU8ZlxltBrKr63PS3BIwbtq3E9k4Ga/SYVkbh59DzLFFvphqsr6NIjRW/FW0ii2tpL1h+0t3NsMYXG4xeiD3nSRyhrKufSHXY0pDdtfhASWgZ5qCUZkOrLthqx0CZY22Js2LbJoIvb7o+W7dkx42pd705L46jm1/imfJqhUcNekZqz+gTh7/joZEro+0ZBMxd86P1rAo0VgpdjrzkUApiyrtNO+t0RjP/QFGb2wOSaS5Sw
 GB5oK4o0
 nyPGJ7hbSPhfH1TaakKTEpyPexByhTd2ttbkw5mIcIhdTcOSDkliHlT5+MYpB1i7VUof4HVx1cTj0oJlQnLnwIGod7BHM83ePmssbdPAqBGkIQSwlpnh4EF4ZscONc8mDSPSRZeUzPnBPtB7srgs/+za4q8W4L0XkqgB8WgNKpn2GpeUjOFUSTmoOr/ugCnFL5U2A3GWOJoKEhdbHazT4MtYe292X7Ih+ItMYKpRpRS6rbwtrdn+40ysMIWvc8kI9rfJnvUGxYpc8Yx6GIftyB+QvqTJmQxm2/4kRWBHjMApSM/dPgDMSNz+3kQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 6:26=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Tue, Feb 24, 2026 at 11:16:12PM +0900, Harry Yoo wrote:
> > Just sharing updates on this before going to bed...
> >
> > I was able to reproduce it on my machine I have a working fix
> > (nowhere close to upstream quality, though)
> >
> > The reason why we're seeing "alloc_tag not was set" is
> > because SLUB allocates empty sheaves for kmalloc
> > with __GFP_NO_OBJ_EXT and it doesn't teach memory profiling
> > how to handle this when such sheaves are freed.
> >
> > When __GFP_NO_OBJ_EXT is used in alloc_slab_obj_exts(), it later
> > avoids this "alloc_tag was not set" warning by marking alloc_tags
> > empty in free_slab_obj_exts(), just before freeing obj_exts.
> >
> > And we don't handle this when allocating freeing sheaves
> > that were allocated with __GFP_NO_OBJ_EXT.

Ah, thanks for the analyses! So, the fact that __alloc_empty_sheaf()
sets __GFP_NO_OBJ_EXT when allocating the sheaf leads to this issue
later on. Makes sense. I only wonder why I could not reproduce this...
Will try to find out later.

> >
> > Passing __GFP_NO_OBJ_EXT skips 1) allocation of obj_exts,
> > and 2) alloc_tag_add() even when obj_exts is already allocated,
> > and this confuses memory profiling later.
> >
> > I'm adding the fix I have now. (I guess Suren might have some preferenc=
e
> > on how to solve it though)
> >
> >   1. mark obj_exts allocation failure when slab has no obj_exts and
> >      gfp flag has __GFP_NO_OBJ_EXT, so that a later obj_exts allocation
> >      will mark alloc_tags empty.
> >
> >   2. Set alloc_tag when obj_exts is allocated available,
> >      even when __GFP_NO_OBJ_EXT is set.
> >
> >      Because it's already allocated, we don't have to worry about
> >      recursive allocation.
>
> Wait, isn't it much simpler to just do mark_objexts_empty(sheaf);
> just before freeing sheaves, if s->flags has SLAB_KMALLOC?

I think that's the best fix and it makes logical sense.
alloc_slab_obj_exts() allocates obj_exts with __GFP_NO_OBJ_EXT and
then free_slab_obj_exts() does mark_objexts_empty() before freeing
them. Similarly,  __alloc_empty_sheaf() allocates sheaves with
__GFP_NO_OBJ_EXT (for SLAB_KMALLOC objects), therefore
free_empty_sheaf() should also call mark_objexts_empty(sheaf) before
freeing them. mark_objexts_empty() currently accepts only slabobj_ext
but I think we can change that. I'll take a stab at it.

>
> /me goes to bed anyway
>
> --
> Cheers,
> Harry / Hyeonggon

