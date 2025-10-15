Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C832CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 558CF8E0086; Wed, 15 Oct 2025 14:52:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 530CC8E000C; Wed, 15 Oct 2025 14:52:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41F668E0086; Wed, 15 Oct 2025 14:52:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D42B8E000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:52:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B599714028E
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:52:30 +0000 (UTC)
X-FDA: 84001244460.20.A4DA367
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id E266216000F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:52:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=haZ7Sr4R;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760554349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NwQCNOMiVNhviDLYmWNQR++Wsx+PX0Dsjg6jZ0iSZ8c=;
	b=uB9iWqRRHAZXY+DatCzhro7UO5+fSzRp+saiskswbx7PGEkySjktzu3wva3ZL6VWgkaSlE
	PgfZOUc9UHDUncEAkgQUaYPb5DLbESllXJMm3jCXECHEBGSEYxxFOekagU7LOT3uMmGKPW
	IqWhELWgM6wsx+RNTDKFRWmXBxHFJqk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=haZ7Sr4R;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760554349; a=rsa-sha256;
	cv=none;
	b=lM0NuQy2csT1dW3iciQ7QHtLYlkXrNER1Re+9y6UJ+iGDhdILNrMstOxDZH5bH3ADoiivv
	kz0HzEdU558cXot7q4EVro6RxEejWHptdf0IWiUvS3Z4lycPrBrz4l3xx+94qvGJAzY1U/
	TaqOC8+sLpsj0ZV+mElimwgsp2voFII=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-46e6c8bc46eso46740835e9.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760554347; x=1761159147; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NwQCNOMiVNhviDLYmWNQR++Wsx+PX0Dsjg6jZ0iSZ8c=;
        b=haZ7Sr4RPBt7AHOQQKRsH8udKXkqik7dtwMy675TXZnVlexc0zFgkaLhrq+b1Xlqpm
         ZaWp92usnBNSH26ILDT5Hdp9w5YtFNNgsmtwFHHhdPVg1dHNYvW/tkob9/DNxj2nWGfG
         xdtb+zBkGn5LR8gPv6vYL5OxwdyUAxLRoYgnwMZdsf9FHMW/z4HRhzkWYIxVjTBHJ7dv
         OKjndKTHjAJM6kVVauusR5lI8IXkqLnsfEFes5YD7shXdz9SWCeGj5xn9vHUGdYwMBa1
         +yaD/9Z4QBEsuZeU8YpNzZkdB/llTcih0+sSXKDZg0Hp2x/rl0Tk1pf1s1VvnMecGhr3
         GN/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760554347; x=1761159147;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NwQCNOMiVNhviDLYmWNQR++Wsx+PX0Dsjg6jZ0iSZ8c=;
        b=WcpkvYVDgNEPNtzkStkz8sheSppJY7li4GVvwZhWlBbdI7mrHNdhSjoo0WovAdIoQY
         8ZokRsAUlHba8RSlkhMUYPxyCQQrys7OwHy4wGmxEaKTUNaiEOLdLReeqsrYGNoki5/p
         6zOB2aeRQO+tU9vNEUQG1R4LKb5oSc+p28MILG18cEs3izlX9f8hdjNFhZEn4aJQZ4zZ
         kuHZ/jq7su5Z8e+0GgVCH9hmltthUT+fCu21pTpfQZwMBP3iA1u0Ekp9cBrElX8z/I53
         tu4PN9nDtwh96nDXbNuUYSKuGm1yQxmJPfxWfZEWsoYlXoS9auOycQMzvl1A61+92c/l
         OHyg==
X-Forwarded-Encrypted: i=1; AJvYcCWLJazbGql7G8Vk95gJyP7linmKSi/NYAEps1isQkNMt6hcTg/KqvYAJQ1h+E2gJtqke1ICAoED+g==@kvack.org
X-Gm-Message-State: AOJu0YxY1pTzgdguXBKiyRDjyK3XylSP2Ki344q4z+tgTqBopBtQa/Q2
	bRyhhZdpBSZzD70vVrM7MnWSgqHIEy1gyf6UUZdTs/QIqZKeYT1vGQpQ
X-Gm-Gg: ASbGncsGxn9SVREw6+F3LRu9Zrf2FYil2MJIvOxCCKAmQfSwS5kzXLQlz9RL/6XNSwu
	l+deUFxtxPE9of3a0nkc3rLt44du++AxrFFu/uhiCQAiy6PNoxizOOJZgCJ2N+dapflvkADThpV
	4csqCzzyXDU8ChkGLs6i9zju3hs+MOSjlm+1f2EIrBIhbNPP4lPsTMg+trQM7VIoQvHGQ4xBjCO
	EmP1cW4a92ttCZuQLPPVPMc60FMOMr2yt9J7f6SkAyyl+RmhNo/ynbfgXS1rS0638g6H4Wf4P2W
	lBVzSh2uNlKbwQTx5PRDgX4xThSZNiGmT+HoFEh6LzSWrVuilg2ecHx5nDsZcSqF+C1mtIUpKy9
	y7Xn7rAAKrPmJOj8gmMCpK/DPK9E9DS170CssjrG2uPjB6A==
X-Google-Smtp-Source: AGHT+IFfn9/XhYNsg9kEBy3HRPWyVtIjr2aUR9s4v6atPJEbesiw2bkGCZdPCRugezv9LVZwavljTA==
X-Received: by 2002:a05:600d:41f3:b0:46e:6603:2a84 with SMTP id 5b1f17b1804b1-46fa9b08bd7mr240557805e9.32.1760554347187;
        Wed, 15 Oct 2025 11:52:27 -0700 (PDT)
Received: from fedora ([31.94.20.38])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce57d3desm30688069f8f.7.2025.10.15.11.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:52:26 -0700 (PDT)
Date: Wed, 15 Oct 2025 11:52:24 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH] mempool: clarify behavior of mempool_alloc_preallocated()
Message-ID: <aO_taH9CKxmJPnhV@fedora>
References: <20251014-mempool-doc-v1-1-bc9ebf169700@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251014-mempool-doc-v1-1-bc9ebf169700@linutronix.de>
X-Rspam-User: 
X-Rspamd-Queue-Id: E266216000F
X-Rspamd-Server: rspam03
X-Stat-Signature: e71aioszpf4ut6rkgycohrhzzsxdhhsa
X-HE-Tag: 1760554348-777059
X-HE-Meta: U2FsdGVkX1/Y0zyevV9p/pHcv+uA5yIy5AcGBVgrbS+9axBH0qYo+m9CkpBkC4ZSttVY0WTm6OEkBNIgzsrak+Y8LhzYd0RxLxZNQDF+P31wr9JMxRtdF/Qge2LVuF0IshlTX4rvd3GJE2ySzXNI2X6TMSW5Zi8+0nEsPjAgM7hvIVTckFsuTA7n5e5u2QZWWY2knFrpFShUSmXlJUpVRyOrVmgUlyeRvP2ud/pPACrZktl38SG0SLW6lvWcXO0ixDWrQC9OU4A7hcYhY553rphSvtxVFaUOyy0szOTHyrS9iIHsUnnwulBOuWRLU9/VGuVnXteqpnTPJtIvg5/Cp/n/D77XjExhBKbJRTtp9Stftl+7WvYSMJlLVwTCqGzurn2hift/h8fodmmQGITitqSg0r92Er4oCD8c3fEh2fI/s790xPuZfCd1UfsJjRGl/23aYta4xaatPr6vwTsrDVTGvKb3c5gZpafkeOsfTF721W+JEDLfse0n9Y5Ic7s5dMA+6BCM4Z7Hf/eKKz2PgYPNvEp5gT32btGPmZ1idvs8VOuuOnTTCOANqxBdso+xN3Ck5l80etKdpWifyMqNm1cilmPhElfXzM8+Ctuslik+pgkij8jMFboCv7OECnIddOy6Tu2qSzA2RImB3eePxWEsYS+RI2qTzLr5/Kn7QPBYNNEMNmGtk73xpnWKWeB9x1qPvuGAPel0Vgr0qflsBhJVR42FJ/Av7RWSLLcfaz4Vf2R4PO4/+V62O6Jws9HGPRR0256E0CzwJPe9/JLhtif3rGXBwUw1rCRSwywz2f9udPFFmRAcXxCrTHi5XjG1l5CwoMyasyeV3tmsUzyXGw7vVBPLEU/0TAxpFVQOeoeLv7sTJUZur9VbkpxlSzOD4A7klEPIw4ve3ZK1oL1MGkqRZ3hVoG/FaTWpBEEyU2YkMidnoRcZsCE9aLJZLaL1vqNaaZ8GHvFuJJiMIfY
 lY73R9k+
 PWGoa+twvvN62bYgPRoU88YjRqWvXArV7CGGetYjIpdjVZEI8kDakUgIi5wrKz7Z7Cw3WinwwR1h9USqRqy3IgpATnQPqiO+/cJN13u33kfKMOqla/tXkG7QR1Re4aKvwjLSf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 02:17:23PM +0200, Thomas Weiﬂschuh wrote:
> The documentation of that function promises to never sleep.
> However on PREEMPT_RT a spinlock_t might in fact sleep.
> 
> Reword the documentation so users can predict its behavior better.
> 
> mempool could also replace spinlock_t with raw_spinlock_t which doesn't
> sleep even on PREEMPT_RT but that would take away the improved
> preemptibility of sleeping locks.
> 
> Signed-off-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> ---
>  mm/mempool.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mempool.c b/mm/mempool.c
> index 1c38e873e546fadcc594f041874eb42774e3df16..cceb09b75ebe35f263a5fb95ff6d400221ecbdd5 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -461,8 +461,8 @@ EXPORT_SYMBOL(mempool_alloc_noprof);
>   *             mempool_create().
>   *
>   * This function is similar to mempool_alloc, but it only attempts allocating
> - * an element from the preallocated elements. It does not sleep and immediately
> - * returns if no preallocated elements are available.
> + * an element from the preallocated elements. It only takes a single spinlock_t

Might it make more sense to say "It may sleep" instead of "takes a
single spinlock_t"?

I feel like the fact that we take a spinlock isn't the important part
here (especially because we always drop it before returning).

> + * and immediately returns if no preallocated elements are available.
>   *
>   * Return: pointer to the allocated element or %NULL if no elements are
>   * available.
> 
> ---
> base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
> change-id: 20251014-mempool-doc-625dd4996110
> 
> Best regards,
> -- 
> Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> 

