Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0168FCA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 17:52:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5532E8E000E; Fri,  5 Sep 2025 13:52:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 502848E0001; Fri,  5 Sep 2025 13:52:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CA698E000E; Fri,  5 Sep 2025 13:52:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2690C8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:52:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 699BC1DB82D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:52:33 +0000 (UTC)
X-FDA: 83855941386.09.E345327
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8466B80008
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:52:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ksxEymcA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.179 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757094751; a=rsa-sha256;
	cv=none;
	b=NxIjbS9Z5B4fZX9XNle5VT6Yo5OEcpEDYZsTakUPaqfLubwP9VkjFIqWhOo1Gly/MjQZ5v
	B70K36XS7TpQA1eIQK+VfkXk0AL4aHwZZ0em9Zg/IpeHaiRyce8a+BYnKTKzmgohTGrMor
	9GbnnXVM59fqT8B063KMZNH8FXfh8Ig=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ksxEymcA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.179 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757094751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rODzLRofJcFgARvay8orMOiUJ1s8/nrDQHaYoswCTWQ=;
	b=HUdjhkQNSMtczrGudtXTv0bQ1ITDGh+4nzMYwdGg3dA1s7YRzzU8NFsd5ilQUuLjUbPljE
	kH8Obt/hxbRVYGwR2ENbeDrlH6cKrqcKRoMfJRccqCazigikIHcZm0KW+9sqDUISlBqXbP
	3fIfMmvaRxBZNp1JohrOeO9pruukr6I=
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3f664c47adaso12844785ab.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 10:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757094750; x=1757699550; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rODzLRofJcFgARvay8orMOiUJ1s8/nrDQHaYoswCTWQ=;
        b=ksxEymcAiuG+2Lp/LnN3C67ZF3xgw/LRbN4TNMw3k7IJNy5FodiVaI7HRqoMf3tvD5
         Sw5C6ovRJ3LwhweT62HMaMz2iSImjf8PNSNmgZA3KQ0fA8Ho5Nu+04mnXRP6j+1IyTE2
         y497/C2eIc6DKVmd2Zcaf8+2AiK1YPqrZo4aWmZZUkn5TNRCGgYTaVbA/09Zsewm6Tfr
         +8SHBZyCv8gKlw97Cod+dWOvt1WKBJmyphrvREoMOLpk0jaHpfhMdiF/GaNFm06275vM
         q9Oq5LecXGEqdjnOUhQ1i4ri3w+jPGoutWzp4jHcmMcwSsfCtIijeQzlSBTgRswwrVeN
         Chrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757094750; x=1757699550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rODzLRofJcFgARvay8orMOiUJ1s8/nrDQHaYoswCTWQ=;
        b=pRHaBPlDl4gKxyMuJSaPPf51idN0ZeEZHsWC7OnVJ6VGulaihaMurBw/k4YDtx3wxB
         GOGirDvw3PmnQRLjOmBCNA6Az0ct6aySZGkZgM2k2GHElaGwBg1VDod7v7WjU6ItbOzq
         OefpUcrtsvQlY/gTnTte1e8GjqEuuKIbiWzJYKjpAPAC/EoMhyTBL+K9VUQp9fjAAoog
         wVoRVBYBMzuQ+r/4IBKfBh+4vaWgDlgtYhk4Q7kicxAubziaRMPFUT5sQlbVmgr4TcYm
         YneGgBYVnYw2+3cYF/bkTG7TK4CeXTTPGOa3u6tef4kSP+s2dwCP8U6Rh/on/ILStBZ+
         rJ4A==
X-Forwarded-Encrypted: i=1; AJvYcCWEmpTOmIhCIHhWGw7CiBiCMsa9E5gWtqBRH/qBuh5jlCcrkjinCygv9aXztXC4GHIuISbqLy35tQ==@kvack.org
X-Gm-Message-State: AOJu0Yx1EJSfqYuhGYF0nHF4qPnRzSymzDWBHkLdH5S7fwJ61dm1lJ1S
	dtrM28QIufCP7nt/J5dpFXHO47XSvzCRjMbqh4MCVIUCKvtjUQGaLRXWMPIe1nD3orrBsLs59Ga
	yrHblunnQb8YYVcgjnPe5NlMGbsHlNcA=
X-Gm-Gg: ASbGncvPZtr0E+UbXddsbF9iw7NZPWc5hI2LVlNlNtecalhO0XgfSjQZRJtMA6PGbjL
	wOv/4iqR/URSB7xmWzgjSuZzBwVgeOxqS9ZR8jsrpddDbJjWs8fYkVQTHDrcgfBQCvE4FdT32PI
	pHxiDEZukABOr0M821giThS9Z2JsWUJYyhNQ0AqmMDaQMLaEjAt5bSGoNdfM1FOlFztCjTRUACb
	nk0eAdtoaBe2+I=
X-Google-Smtp-Source: AGHT+IEDol+/lohZYi9Y/NFSKM0lfOTzS3L6PZJihsXBE1JGsvkJpojYVq9ljMlryr8XwDq86UdBhoVCt6bas5s2oqY=
X-Received: by 2002:a05:6e02:3a06:b0:3f0:b1ba:f72e with SMTP id
 e9e14a558f8ab-3f4021c42d0mr408790765ab.25.1757094750404; Fri, 05 Sep 2025
 10:52:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250829162212.208258-1-hannes@cmpxchg.org>
In-Reply-To: <20250829162212.208258-1-hannes@cmpxchg.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 5 Sep 2025 10:52:18 -0700
X-Gm-Features: Ac12FXyArcg8HLTO3HVVGOFdyzJb6hPsDWKqbopHOKNws0wa2b1mtcYW9LCU0KM
Message-ID: <CAKEwX=M8ccnsOUc4_ZcFrg-8MSwDDF250=LCFKctvTrL5vJZ6g@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm: remove zpool
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosryahmed@google.com>, 
	Chengming Zhou <zhouchengming@bytedance.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8466B80008
X-Stat-Signature: fkofg55tgcpgeggh9p6ktiamomyn78p8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757094751-764562
X-HE-Meta: U2FsdGVkX1+LwNfqTAFcgBFWH5CRDLTf2mRzRUIIpIxaaUJTlxOKz4uYcW9nhbwsNu+0mYalDUIaEuiCHj/IAcBsHefeLgEyWzmWl3YSgxUZwVP9I5TMOODH3wyvmE158uEMO6BdcKHGUY3MYCTQ5K67sx1mF6PnWpKU5VZlbQd6yhAFqMHXO5QxM4pPENcEKlID0UI40Q13cN64yhhc1r5qi0U1wMqIj0iqqsuv1ipXt6f8h9MA3zXaDkFE0yohOQ5VqFDbhIOxb8Po0NdIHBLGMVMCuI/Jp9FtAgwhJ91TPI9+X/xNNwIXvnkZp1q3mEyoeWzX5Ps9VoAA+VBSYrCAooXURf/VLhq69GvDyUxmOSn5wOXnOPWvBD5SB/iTFlOHnn4OULPcJSsEYj+okaJfNnQlC8IhW78hyfg8QTShIriVaI19KUZg0j1zWgHtSqspKqSqYfMW/gUPc9n58fDXY73HqA5CQB/iSEon0+9WNG/iNeQum5OJyUgv5i2OSpyzJvqw6eug1ayfkAlVJv/uozJaegMiP7uTOrfgunsep8qr7YUm01+Ud4FeBOk/uUS1qPc9M9GH8j3JDqOhfhGhVVAgpB1fweGF0koDIvXOIeGNlQDc/EYsq0D5axYq4j1+W9XmZ/2sydY2rE5+cFQ5KGqYUur02m1omUIbtWgFxdbJBvZTkHOaaKEtDmhr+2C/tX1rd9L3YRrm2cCqYoHI837oIcs0MHTriAy9W8CebdloecaNkTFSZxox0iRX3gk54R64FMkKXd+dXgpXM16hNfw/q2zMJ6eBoqpIlxyFhjUazM69eGpPpK+mmLJN0xMaGwiqH6/ulN92VChGylxzUIs3k2Sr264mKCe+YsxiglhCfmGUnGoHrbfDPL16xVZZS3kT9wx0GdLKIFRlZ2clqie9GF8/Wb7Fp1WkfHyo3wnLFgoQOTpGDPay6GmoHbeIO6oQyGPJQdrBQng
 3w94Wh3F
 miHim7QYueRaWxbQjV/r1z9kT0qjoVTpL502Xplm9l9jvNJzVW8jp/lEPIgCw1nkDcmrVNyYnvGCI9lINbIRE2/7+FNC8fBBcxJlJX+rX1OayyKV7bgAtceTanstndRjjYo7FEwM/3iIns9Kn2Nq5D98Rfi3z8I3161SuPgK6TNJfrQlLFBVLDA0qZrG9ZCl5+BfBu6YRTyxKwy9q8yjSud/58l/Eh50Q4t9lMAM4EZJLvHnQMQQvlHVN86mfU4pbAR7Z/iwAHnwgx9iKjWcDfMeo3QxPEwN3tY7UGR+H2d4w+i2w/SmIHybfVe0s7XTJLtm/BJ7RNQL9thJRk3cNmBl8awJvaMQL+6CxQD5GJ+ZWwo68GDbp+zoJiOTmKcrYW7X5CWHO4KbIYav9YmyEJkIvNP5TEZ6YLBjPR4nuBP1trwnXCyelssYSCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 9:22=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> zpool is an indirection layer for zswap to switch between multiple
> allocator backends at runtime. Since 6.15, zsmalloc is the only
> allocator left in-tree, so there is no point in keeping zpool around.
>

Taking a step back, even if we do have needs for multiple allocators
for different setups, having it runtime-selectable makes no sense.

If you just need one particular allocator per-set up, then it's better
select it at build/boot time. And we have ways to do it, without
adding 700+ LoCs boilerplate.

So:

Acked-by: Nhat Pham <nphamcs@gmail.com>

