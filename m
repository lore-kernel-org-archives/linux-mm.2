Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0302CCCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 22:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A4188E0027; Wed, 15 Oct 2025 18:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2552F8E000C; Wed, 15 Oct 2025 18:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1440F8E0027; Wed, 15 Oct 2025 18:46:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 006F68E000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:46:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8663AB890E
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 22:46:20 +0000 (UTC)
X-FDA: 84001833720.04.68A8E73
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id A360E180003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 22:46:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Td+kgMqB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760568378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LFKGoddm59QoTZnWfmZZLtnAiNTcYZnAo8RKS4lX25U=;
	b=sY2UzPAg2nHEOddEbgg8ZYNmwDoc8MnHc+HCOWUAtjlpwF+SK+BiTmloecJoKrnI5DqktV
	HkYa17bpgdk5w+Et62HBzvi/htITcQKY5bQKmRW+OHsWobqXvUGW6P+dlgKsOYkiCIadkQ
	FJ7kEC+Kzzy6G2hOnayk0E0Ew/9I7N8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760568378; a=rsa-sha256;
	cv=none;
	b=R6i5cedWGExqiV1zsLXSl7dEZ9oEnzVTCbcb53bFd9LFIo235omGw4xc61CimnD5PleL+G
	jHr1lts25xvGA1QPmTr9DLsowSG0QlPLaEGZC5MWMQil5SPp29dimGUaFbY+Rkh1RxTIH0
	Fgqk5ZNWa1fpTEk5vIGGqdVv/skm4WQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Td+kgMqB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-426f1574a14so43732f8f.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760568377; x=1761173177; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LFKGoddm59QoTZnWfmZZLtnAiNTcYZnAo8RKS4lX25U=;
        b=Td+kgMqB3xkwi/8ATXXx7hjKuw1aG6i+2YZA6onbDEZc52Yi56/J2C6r6wejZZefFg
         hWsgwSC3qTShP7DcTBZWdyMEXvrdNRCdlmB993ELowOImEfMGKSKO3+y0AizvKxWWM5y
         7AL2AEWT8AnBYd6LUB5fffsnFlmriXwHCyA6psLIaEsPNOGU0QF/7ZpMk9WDUTCsLkil
         OItr+IXRgUFTmLgal0Pq1wiChT0II6oUh3OxAoMV7F3M4cIK1b3QXLLoLryjUX5LaflQ
         /8aQ0XJx21X2nMky1i2ie+l4pCuustQayPp6gthMrZohZnbKE9Ag+3EbmuvuRRoYFVfQ
         SSyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760568377; x=1761173177;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LFKGoddm59QoTZnWfmZZLtnAiNTcYZnAo8RKS4lX25U=;
        b=RyiAuABQqHNWZQK59kjrijGPyaEeEMfg0q6h7aYaQKBCxtZgXlocb1VE4dl7MWEn04
         OsrsG8SSszTu5y3Eg4AEktBDq6snt1zO1NgRXaABPZtbuvEayjC/kfYHf9ySstgpQJ+n
         1i2UGI9XVgm8He+WuULQkJ98C8t+pbbElAM3FSsYqHMd4FXiSvfGhiIMr6CIaCDuBVv2
         kZT8Kf/czEfTYIE/7u6x6y+3DmdB4yYOBML+4q/DT/Px9IFucZtajBDy1akouHlvlkRJ
         bDehVEaZe8f1ZMej9GBGEiE8Qntz4uslCxm0kXHA9clifLyhLPcxrFz4c8UNNGbDKVaw
         t3jQ==
X-Forwarded-Encrypted: i=1; AJvYcCXp/9qWFc9KO0SpaObOiSbWIVnmM1n/MKdK2sLDZ0N4Sc6hWSz34VDJaYTB8bnG7G1qn7aInRmTwg==@kvack.org
X-Gm-Message-State: AOJu0YzkNzZiv6mNEiaeNBVmCOX/T6Cs3Wf59sbXHX6KomnYSZ6Mvlet
	S1tVF9nDrG/L0wLioHSdG37qml5d/qWeUa29dOsAtvjkWwlsqS9dOkhc0X9i3x1elKw=
X-Gm-Gg: ASbGncu2tdmrfX3Kf80dw+NIkWwWijdpT9HVqFLDq26fvV5Kd/OD9vyKk6bIlbQJTR9
	CYChBq09l/Ie9aIJ1zYl0Xny/pTmwfIEEMMYEWdIQwPj4P7lPE3eVeLo77YomTCymjo0PYnw05V
	bF6nUAmVo+1V7eMZ/aoPDlBOpBpHX4AyeT7uqSDMxTeO3w0aSLsDXASOknmv93xGCCUcVtOX/rq
	sFbBBC1VL4beMcscAherHzE/fk2UwKtpTrp5KV+5CPyv4FVXDd0y/Vtt/FEOsntg+Kd8v453UmP
	GhLwc+vNUXG2HKaqzIkNI3O+lug34UfNovyx5qqFvnL6ROYskccz+ItXmou0BK1D0vQtLsW1BPD
	lrlk/uSB6YIFENyqsNQq2HZ8HnXfIphbiv693bDN1Es5/+bSa2W7aY5C53RnpqFp+Ob8otg==
X-Google-Smtp-Source: AGHT+IGDAo0cT2+uD/d095c1GDJkVJ/8fi2Txwb/AFql1WXRzzbLwuRU1peuUU2qA3ABNJ3YnTjhYQ==
X-Received: by 2002:a05:6000:310a:b0:414:a552:86b1 with SMTP id ffacd0b85a97d-4266e8e48ccmr20078648f8f.63.1760568376783;
        Wed, 15 Oct 2025 15:46:16 -0700 (PDT)
Received: from fedora ([31.94.20.38])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426f3fa3bdasm9095798f8f.46.2025.10.15.15.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 15:46:16 -0700 (PDT)
Date: Wed, 15 Oct 2025 15:46:13 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH] mempool: clarify behavior of mempool_alloc_preallocated()
Message-ID: <aPAkNZDr_HAA_d75@fedora>
References: <20251014-mempool-doc-v1-1-bc9ebf169700@linutronix.de>
 <aO_taH9CKxmJPnhV@fedora>
 <20251015192717.HvwzCChE@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015192717.HvwzCChE@linutronix.de>
X-Rspamd-Server: rspam01
X-Stat-Signature: c67neq1imu8b3g7zhkjdchu3m1eaf7sy
X-Rspam-User: 
X-Rspamd-Queue-Id: A360E180003
X-HE-Tag: 1760568378-880758
X-HE-Meta: U2FsdGVkX193DX3qnFXovDPmiUzIo1CFVlCnxmLk0Cs2FwlXY4UT0ZYZBa0zzbP4G7otxO0LILuk7sT7VWIQZaA+72HB6vP9GtPNT9xjQUegbKjLEv1nQwJWPA9sRjyEGzxuBASOjSvGKN9iPZanswA7ReS4MlCWz1elHx8WQr9/BKoCiCp97/ghn01tU9M05sIG8Fe7V32Nmw619uw4+uP9mnc51ucEvxWIqp0v+Uf8zlfz/Otdt7a9SBatZQ/bbu4ZD2QBKQf5xhxB6ydPHVdNl/UblVjvwGQ+dEZJxSzpH0czksh+dGOY+d1r4/o3ArwHxkUt7dmyJzR4Neik+/bqIfefrXboy6EMIaqm+jBvMpcYi1oV0i0QoBBh6EYR4/WGuM1+wQWbjYzjzOuNsFuy7P5Pg8i3K+tp98D46WtaDebiAuMWHBSTrKkZcCvxDDwZTJyZPPTdRRasrANe6vcluZ55SG5uCrEJFHvOkhXMpaVSKVAc9+SPzOzuA/c6J+jzuZK1CJDM3gNleoH4TDVKyCgY/YHoMN8W8UpNXJMhSp3dRYAkyEMgDFYQzNb2iG5jA163lFFF+Cd6exZmm8Rx912sGHq/Ab1OX9vjV6kRGjmwrHMfCzzu20oqYpqDWy3dGauN0/0IeTgZPiQErlYR8tAtAww1YBv8mkyFELfIPbGpzOmSVt/c9+2L6LViMTwSnju/siRpu2ivuO00p8Qh8dsCWRO27t4LHC7aPOaOPcb9ljSSsNWXZVCfXjMGhQCqFAzKFtYPS6KiPM9+xKhE15KO6dp/o2zOl4H9EIuL2g9otQVPyRFVnVzgaYHNrI/NDewFTM4Lx649JK3uDhDXLM2QeZjOfu4L9sLqEn9wl2COJzmtE5MN5pVWuNqx45ZtBaXOQeWK6oxamIr9SPPVHOlk2YUix5IXzYDmzOqbk75/y904DB0sS2nczYSTN0N39fziaA8byb+QIHU
 6o2VUs/u
 nGUAMHCR7rTnL2YnLGoUZGplfkpGZm4ehX5PZBHwp51gsB70W7e9wNceFvI129L3tISjAjg2CU7JtIXEuSNWh0h+s7NFgngJDTl7iB8z1TjacvlIhsTbDrLxuIiv4LqxzV9euNmHhX2xMerzxxDDnVw4/CDcjp/HSrLkADjnfigJBdlTeKhjSGfbhMmQTBHvm+tpYCLVWQP5zPztcABPSx8IcM0xno2/e+dhUrHteNfc4Q7Jpze0eBLIpn2yid9hgT2sGCwdC94qRneFUNbX5y1my6ESTXfeb2f6rfbpKEt2FEnLHxOpb0cX9RMkadSmP3AqESzXjcv6xpl1JrGbCBISHEqdr8Glf4ZVwMpyiQ3nedzmk9PBsnkV+ewg2uI+YZ6J8a+nseQ/TcAn6WIryjXFXkBbDxOSZ6ZkHPyTYdnRnWAakywXOh9wYwIyIJLXksSIK2Kg5JVsud00YSL3T5T3KIUKi1CDbRcl54Un9yXOg26W4203416tWHTSzxT8ZhaBB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 09:27:17PM +0200, Sebastian Andrzej Siewior wrote:
> On 2025-10-15 11:52:24 [-0700], Vishal Moola (Oracle) wrote:
> > > --- a/mm/mempool.c
> > > +++ b/mm/mempool.c
> > > @@ -461,8 +461,8 @@ EXPORT_SYMBOL(mempool_alloc_noprof);
> > >   *             mempool_create().
> > >   *
> > >   * This function is similar to mempool_alloc, but it only attempts allocating
> > > - * an element from the preallocated elements. It does not sleep and immediately
> > > - * returns if no preallocated elements are available.
> > > + * an element from the preallocated elements. It only takes a single spinlock_t
> > 
> > Might it make more sense to say "It may sleep" instead of "takes a
> > single spinlock_t"?
> 
> May sleep usually refers to something that can not be used in an
> interrupt handler.

Gotcha. 

> > I feel like the fact that we take a spinlock isn't the important part
> > here (especially because we always drop it before returning).
> It actually is. A spinlock_t can not be acquired in hardirq context or
> when interrupts are explicitly disabled via local_irq_disable().
> Therefore you should use the function in a local_irq_disable() section.

As someone not too familiar with how the locking intertwines with the
scheduler contexts, seeing something like that makes much more sense
to me than seeing "it only takes a single spinlock_t."

