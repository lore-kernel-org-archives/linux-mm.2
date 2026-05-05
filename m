Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBEB4CD13DA
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 03:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB83E6B0088; Mon,  4 May 2026 23:25:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E891D6B008A; Mon,  4 May 2026 23:25:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9E4D6B008C; Mon,  4 May 2026 23:25:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C9D9A6B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 23:25:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58F5D1603C4
	for <linux-mm@kvack.org>; Tue,  5 May 2026 03:25:16 +0000 (UTC)
X-FDA: 84731925432.18.E218807
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id 694B240005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 03:25:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hyiUpCo+;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777951514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IOgn1ypZ4nduY+SbHUWa7G7iPPnNvuWv4v36Xev0RXs=;
	b=zlbbIBWoFIyX9qect8JSsdnwQXQc3be2vj8V+x6eiNDmiQ2UaNweEGvVcD5i35Ch6t25yu
	lTZyeQygx1+jQA4t1jc/PLBgQZ1M1PTlcLSpIg8hsAaTqfnKHy/L7eey7Nq8vN68StygTJ
	/gkF2pUYpw7r1wu2jif9msEjtewWd7k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hyiUpCo+;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777951514; a=rsa-sha256;
	cv=none;
	b=RMB7E+akM40aPv/j9R6Yt9ArdDTgnwaCy52JNrLcC+lNeJCHbgY/zUmUghpP3NUaHN8Pbf
	rlihyGfCIjH+sUiyxUSDMKREsPkF/jkkWkpGnALG68727Gz/Vy6GO5F5RZi1a0I5gvGsRC
	pw0adPxnuaoZ3dzZ27iYkh7yXVXwCUk=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2b24fede2acso26830325ad.3
        for <linux-mm@kvack.org>; Mon, 04 May 2026 20:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1777951513; x=1778556313; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IOgn1ypZ4nduY+SbHUWa7G7iPPnNvuWv4v36Xev0RXs=;
        b=hyiUpCo+FgQQ2G8Uu0fjMd1aQ8eE3ZHzNjDQaVEMSxYRCTxnq1+Iz41G4Z4up6VNiC
         kdlhqRMks92BH08Zn2T55xIqQc4ZRjYTBqS+hHBf4Gz/Hk5220ukkGpfAKI2OUPGf8Av
         l5JGsD75vpnIXrcUb1fwza56iUBb5Z7gdX4KY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777951513; x=1778556313;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IOgn1ypZ4nduY+SbHUWa7G7iPPnNvuWv4v36Xev0RXs=;
        b=AKkAFvGEUbtyV6w8j7etaLo7Z5MeU+B2/7Q52BrUdkXXUW8+X9PwZj5BLlDxo7lIap
         v4r0Xh/0yXSL47Az21TiyXEwqYi1MfmBHjOke3yyQZjqcFm2IfS+IA/X22CIhtXclPD7
         YiEOpehvEzzyhcfdbd52xn77k5PQGnK/dnYiCVwu1PG+Nj1BWVxYZCNzzljwBN7Fji08
         JZKgWPNKOOTgmwD2teISOm2IK3m9j83dhOFYCxTOnItAady94iH+W+ZFQpGNJ3DSAd7L
         hByFNuYG/ItF2QtFYdaOZbXBThbvVkT/AO2yr33XR3Ef7SO9Kl1s/+Qr2KFGAG0WZHNX
         5K8w==
X-Forwarded-Encrypted: i=1; AFNElJ+3xAzErSGvRWo7xfzTtTFqEv1Ldw8pD31Hdj0TaIXDT4O9cjr5+TEMWxDoBaLSmgROXO2qgrZIWA==@kvack.org
X-Gm-Message-State: AOJu0YynHHG7bN4EDBB+2KKOahC4bcLquP8jUdYG500RFNwiWM9K+cfW
	uC13EI09d2YeC9DbWSNZ3r7z3ZxDI7yBGjKK+TF6UIkUZgwVX2mgPZ1OiZBXA71iyw==
X-Gm-Gg: AeBDiev8L0NjMQIhsb3CIVKARyCqC19WUXnfn3xe0Bt8mxlePKO1QGELIXM25oX13aH
	/BUstMHKkXRLTijtAmXjuceAg0MYovocarJMUZ1G+uSAygFr/S0bme24Diu5YrsJQadprfREoGv
	w/IKLZYCn7LGz50qmnrVIgPjmWhz7K1CVeXrIZ469eo8xQjXKff2IXRlL4dQs+0TE+lP9GRAbuP
	n2wAi4hXIvPEKD7ejHQ/xIQIhiMjEWoIivs3J9J5GCLXQtPqPibemsri+e4fXWr8Rz/FmSrPCM7
	uu/e+ejZ65fH9u3zktskNX0y6str25lT+TP3W6f9tY55h688d1XWXxJt8/b+rAukiSIMy6LJs4L
	uo1pqIryU5U8vPN6MqNGqg1d30ChbEp7kw6fmuSiylv0gVlNuVeXNQFJkeRJXvz9eEJyd9CcavF
	895g65K1RPd8UJG9+p77n+1OW1umrun6m+YY247zWZnYp/i14SHNimz/X+Lz7DHxNvABAIWvWI1
	Nk8jPVX7PsV
X-Received: by 2002:a17:903:3c66:b0:2b2:4cd2:e16c with SMTP id d9443c01a7336-2b9f260d87bmr118255855ad.20.1777951513193;
        Mon, 04 May 2026 20:25:13 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:1159:b1b3:930d:d5eb])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9cae0e605sm119301085ad.41.2026.05.04.20.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 20:25:12 -0700 (PDT)
Date: Tue, 5 May 2026 12:25:07 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	Richard Chang <richardycc@google.com>
Cc: Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, bgeffon@google.com, 
	liumartin@google.com, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] zram: fix use-after-free in zram_writeback_endio
Message-ID: <afli4ssQC9pFArSq@google.com>
References: <20260504123230.3833765-1-richardycc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504123230.3833765-1-richardycc@google.com>
X-Stat-Signature: sde6q4z7ngyrcjf6ogm1h6d9yikk36wy
X-Rspamd-Queue-Id: 694B240005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777951514-631683
X-HE-Meta: U2FsdGVkX183PPSc5yY1//e4LEQnJykhQ1ouFcx09+KVHEwazfgdhq8z8Kq0o7QNkw2lHofFW86jjgb9nVJ/ATl2QD5EOFB4JFoBIVmjyO5UYYSVQIOGsE8t8wg/TAZqM74p/6ikPkbquP5oy/uUEFXKbY7vmQwVWjZyi9YzN2xJ50bVqSKQzKbnXchdmkf0AHK0ZwfULo7M6g7nTcfXg0nwESnm8QIB71/l1pHaKefxr7mhdCT+dBeAhELf7vrQr0Y/tbABKHx2XqV9FzfjtuchfPo8VeabEQr3jhdbG9NPiMnWg5CxxBiINKri1NBzybUb4rLS0aS6yxb1zJeNVb1HphPQEPwLf23odJEP4bYd91sGSZ5inVrh5Y9eDV8w/Xk/0EhnkVmymjmGqTYGj2vH26ZCJz4kdxotQxcpszW4rK8gnpO6O82QAVxdIn48s1NPTBt3kz2CLFf6f07OEB2kqSS/qaR3ikPyp3AOLo9BY9hJ9fXovtD8QFvXz8+YLCQS2+LaKnAbj1IcBWBAx3MZkgxv3gbX0y9dz4DnErlcdXfTjV5ooZswSChyMlH8ieHcHYu4PS+KzBI4lYHSl+pbOOPJsGIYf78bBLRrjFiEu+BUp76Jk+z1ecH0exV22vfBBMYrNOJvll7eIxJ/JtXxIJ8PulMLsuA3y0+otcTWsyMP3Be7J7rq3OC/Oca5Dip1Ol7LZSNzRKycYY3/+TT1etbPJbas72HPDu2fWMuwXJgq+ShluDUMVypSmqYJeiW9ERJ/Ymr7ej58cDZEfEGCrzxUq5F+jS6D83QnsEzPShjYNZefTYOBO1dFK99TrB72D1lDmHuA3PuvlWUGB+en7+Aj/IPOwqw8+aAdgQM5vK87DwxsgRHyQBlXwrZ2xUSQr5BkCLZQY4RD06EGfofaVH7kx6FjdzmftwxIAROkpopi9uOb4TDERlad1sszEmnYuFbdEmh+tY3QiJO
 Gi/UimjQ
 r8KLoUYwesLKdc2epNKPsh67b674IOkWFLK2//PuVWBnVEXPvmPxCB1sEmCQcfzYwVwGk0JSb7xThgN4rTIzEXAKDilucM4twt2DrueNCOdBRono3nwgcNkzl62ZKywoYEMCLra8bjuO9FLH4KQu/vgnbYI0TtBzWVhkAUuj5F2MU79BJBGtvGGLGrC6sN0d80f09IAEfMphS2CuBPGHQJ5PUGkQ2+qs8nGAIuXODbHYV/kxr3vwKQ4xK0gcCUld2lAET/koEAOO3LiPrBb48pkGonwDp0NVJabLfDIsFAwBHTy2MLgxSlEEWSDtsWDM0bOgPQIRWu8e48kNWjeXPaC/PCOFSSGfqgJxxGKwc6J5fpHHbIcX7Z1Oo3lR1qAhtxf0V9ArZdkik430YApjQSdykVoRRnZIqA6ornKbK5FGMCJwga8YJATmKbcCbUy7IDICXJXLho2BGwilyVimyrLSi6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/05/04 12:32), Richard Chang wrote:
> A crash was observed in zram_writeback_endio due to a NULL pointer
> dereference in wake_up. The root cause is a race condition between the
> bio completion handler (zram_writeback_endio) and the writeback task.
> 
> In zram_writeback_endio, wake_up() is called on &wb_ctl->done_wait after
> releasing wb_ctl->done_lock. This creates a race window where the
> writeback task can see num_inflight become 0, return, and free wb_ctl
> before zram_writeback_endio calls wake_up().
> 
> CPU 0 (zram_writeback_endio)       CPU 1 (zram_complete_done_reqs)
> ============================       ============================
> spin_lock(&wb_ctl->done_lock);
> list_add(&req->entry, &wb_ctl->done_reqs);
> spin_unlock(&wb_ctl->done_lock);
>                                    while (&wb_ctl->num_inflight) > 0)
>                                    spin_lock(&wb_ctl->done_lock);
>                                    list_del(&req->entry);
>                                    spin_unlock(&wb_ctl->done_lock);
> 				   // num_inflight becomes 0
>                                    atomic_dec(&wb_ctl->num_inflight);
>                                    returns to writeback_store();
> 				   // frees wb_ctl
>                                    release_wb_ctl(wb_ctl);
> 
> // UAF crash!
> wake_up(&wb_ctl->done_wait);
> 
> Fix this by moving wake_up() inside the done_lock critical section.
> This ensures that zram_complete_done_reqs cannot consume the request
> and decrement num_inflight until zram_writeback_endio has finished
> calling wake_up() and released the lock.
> 
> Fixes: f405066a1f0d ("zram: introduce writeback bio batching")
> Signed-off-by: Richard Chang <richardycc@google.com>

Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>

