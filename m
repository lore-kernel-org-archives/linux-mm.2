Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A237606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 04:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=WpfSZngU
Received: by kanga.kvack.org (Postfix)
	id CF6D56B05ED; Wed, 21 Oct 2026 00:56:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA7F66B05EE; Wed, 21 Oct 2026 00:56:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBE3A6B05EF; Wed, 21 Oct 2026 00:56:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98F476B05ED
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 00:56:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7560A8043D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 04:56:24 +0000 (UTC)
X-FDA: 85345422288.15.F90C495
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9E08D40002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 04:56:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=WpfSZngU;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792558582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xiB7CdYcz2CO10I+090KxlJTct06C9BMHn0Ug9FfOXA=;
	b=wh0gpwXOBdSflZ+ncKsR9uO15uvjzdNUsz7dpTlXFYqMzz1pLAil8Q1Rl9pdsSPdLw0cB1
	QSRD4RlfkKXImyi7oI5kmBCdRlu3sjdG/uCfsox3CxYs8mG50GLTcmg5f3gRyV0nEkAdpZ
	ORqzr5NBtfXKoswBz9/AlWucRbOIWdM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=WpfSZngU;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792558582;
	b=fZ5v+3rJFTKBYbAEdRGGPJ7cEuOIpk37ccxLY9d4ie7eYVjVQBa2DQBW99lyYB8O/+ovcI
	A0Amg/ynYvULM2GwiMsTkjkbS6IvV05ndXHATdfoshLSqOp65WMJNii41MxHJ1kUzyPZN1
	obHimx81MJfxQ0Rwa6dopGe+r9Fn05g=
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-36661f953e4so633086eec.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 21:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792558581; x=1793163381; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xiB7CdYcz2CO10I+090KxlJTct06C9BMHn0Ug9FfOXA=;
        b=WpfSZngUiy51tD9GanTO3kib0pJjMjurQiIIorBLLE+atsIWFuF5A4zh5hZYmsGnyc
         cgyjl+uhuY7pEKa/c9ggiIUXUSxwhc3nQj1YbxUU40+Af2isOlWvnWXJExny6p8jaTEP
         aeFGh9/waZdz3kpHdPARZgDNpqtd5TwJXQx8I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792558581; x=1793163381;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xiB7CdYcz2CO10I+090KxlJTct06C9BMHn0Ug9FfOXA=;
        b=LJefFg6AzVeqwbG/jZaIFQVFCFzC0mPKp3cNrmu9J1Ut9IhgxeQ+h3xbYrYgIo5pi0
         KJdum/PFokC1uMF9dtQoa3tdQgCaAryxlcho/tvpuFd1jUtRX4snXUDSDubarYCVc+/H
         9QkMkH4yLfXofHeDRlllmktUlnZ76wb6ejBNCd7TpkMomUaT143/h0nOZVEVq0oBtWg/
         d9yXKGInE2vNYA8T8ZvgsSacLypT24ycks6O3iNIvCVeLOzIIHao0LLCLvSSwbxhWDcM
         cQxifP6FbZIHSkLL3njEHgKJpZfnJwfF8aY3tlMGIOvb2kwCA/p2mKf6m+jebFyDDuqg
         tVZA==
X-Forwarded-Encrypted: i=1; AKwUvByos9EtCky3+WXrCfb8gp+VpX7PWANB/osCc7SDSk3hmNY++ydQCjIzynueKPqYmLrN6HuZCBMQWw==@kvack.org
X-Gm-Message-State: AFq9FYIO40EhYeDzeaMwKlf/ixKcqhLMfRKwlGWXeT4HLducXt9ER4R9
	lQAddEhdoC2kSCEnVblnMNHEvV31A/bsRN3pFr9kojh5gJa7QCwkMfeXYYfWsqGUEw==
X-Gm-Gg: AYBFou3KVveHd1mBbX0o6UgqUww95yfSy1HgUepC9Q01OB7jpWviJxOxYKSfAhLl+bv
	eL1fRW5Xgvq+9CxNQqSGydYlEOjwBzsvwsCTMB5DezNpxs01G+Fp7jNDhcm8zPH6GlRY0yn0zMZ
	6nMokcsSa2Wmre/FG4CB7qIMk7pMTbNF5PK7Gi8x+bFP+zgKxpljvjXsTN6msBd5JE8O1q7YZ08
	SDQ/xXAbaJeE0ShTJkBVTlPpZBoWn/4eRwDwBfqGAwAhejlFoYO2PFVNRZGoADiZWwjvOZdCZhw
	pIm7g+PW6ioG1gmqbuwVJJlMY+C96WWSTgXsEIFZ/fhfevFoTr60EWHiWyRgddwf2a8rmstpzuC
	plTIEEWKnAgVuQsGkabTnF+nu3dCaoYFx7jnz8gOIjhK75XGQ3toh0k5nc7P9s0LFXog/uMXXjO
	WbqbsTGCiHHEutFh4eIfMXfpF1OxOYs7CW1PMyGKvz/uPB328V/L1oLp8H+nPw9iOABMrCohf0/
	ja34m1vLmODY2gA3LdaG2/tWlJV2rHie3gi/Dj1huGKLP3iueR6ifqNX/kSnHhKuTbNZIh8K53D
	MFU4PbFAjMBtM6kjoiaP
X-Received: by 2002:a05:7300:8246:b0:366:913f:4d18 with SMTP id 5a478bee46e88-3674db4d094mr1602303eec.14.1792558581213;
        Tue, 20 Oct 2026 21:56:21 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:97d1:a8be:236d:bf79])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3673e153519sm3617931eec.3.2026.10.20.21.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 21:56:20 -0700 (PDT)
Date: Wed, 21 Oct 2026 13:56:17 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Hillf Danton <hdanton@sina.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 09/13] zram: split zcomp into separate R/W streams
Message-ID: <athFf0kXopUKh2-V@google.com>
References: <20261021024236.1787884-10-senozhatsky@chromium.org>
 <20261021042350.907-1-hdanton@sina.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021042350.907-1-hdanton@sina.com>
X-Rspamd-Queue-Id: 9E08D40002
X-Stat-Signature: kz75sx9q5kiycgb8sc8ut5sg9spgorff
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792558582-738203
X-HE-Meta: U2FsdGVkX18Mgxc7J1Bvs/mweAcgTVmCb5jMphisJUjuL05GzfsIImGZnVthJKXNaySOLlbdi7pW15r3lS4W5xEjp2C+nQdUOLVQbL45KEYRqiEhxsWbXFhvXO7kjI9v1pw2IcdjOKpB+5+55MVgjLr3z6wpBLvmjGutW81e+vLqeXWbkbGzfTVX3ajBP3zLa0WmYCMKoqFf3KyGfW2L5rcfpJywIyM3LHqFB4D5ToS9xZRHS1PgAdtzcC4Bmts5N/JO4WsLlKvxTmVDV2YdA11Ye51jj3MV0876vRnBFa15CRVp6u5b8pXk18+NRqdwF4SN6WaLJ1AY/MaaKUFZbW6BX4eDsQyAKzmZE+x0LzbKnml+Em3fX2yePFbFDgSWS4O+0h7Mjh24WotUt7BM9xls0nUrR2gW6y1yx1QnD7JoFQ1BqPT3LKJEi9RTOIsXDdkdGRtpR4U8wENb+mFLLMvv8KrXCunIfrYGK1Vm9EVLRfqfupvyIGtJY57sqMxht/80CwIKNDxlFgTqU+s/I1BLozVmmb2YIjHd0jiOvDaf89HI4VG/CAvKu9c1GULarfKgvLqalnQh9npC82b8cb/7Ofgya40nMQNjTz2kiZD9JbmZ3YV6sAFloUqvDDnwo3EAOBRHRkhHKXCtFbLw8+yHeXpfvKSBGYHI02gSEXT4brFUnEPpWk/fr0URwgMEfXMWhK9sE0b2d2T4DmvQyNCjPXTAx3tFImVbr0XA5pqT5WL20HMfCSD9/j8EBrVwe9F8Dx1PCVT9/EpdU1H30e7/8RKl2XoSHqOqbPhLPQ2mHLqLTKjH+UcR6JdXw2qlu194tGBiTwdtPoGJBUneUSw4nrCZUEJueuALaUuhJ9o33ujhlfH8PySFRmjGXgd2uX5nHNNp/ZQb3uZQohSTLoLdEshVAuo3eNL72sgMJeXoyPDHmfwz9O1KEKHQjAwB4OlQKnj8n5KupEjBxkk
 pUDn6EGf
 PcOtAy+bzbDQMc/6EwsCeMf66S7zO0HKpIN4PeWrZKnuI2vNwUbHqY8rm+U0M/mfDI/hryL7Wuk6N1rcdf5oSCSd/ETZHIBcEKC7AJ0FpNGyXNvI7P0DIgpm6pw0vSPYP9eF0Ir/Gf8ZvFiKVUkCTwUcVbwihP+/IenplVTkbUkrCXvbTpWNWB6jWS/wXxepmzZbPBBVOfSXkRnPDIGKkjvbqLWRIn+qABa1QIaz/QR2jyqmjI3B1a4I9NObHDtfTdMZKhJdxMKfrA17/oZBFBNu439jruLm9x2HPWo7WCZM0C6pZDYJSmqnB6dswgfch7inrsMiryG1lqN20mMmnkNLnrW3Lu16kfng6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/10/21 12:23), Hillf Danton wrote:
> On Wed, 21 Oct 2026 11:42:19 +0900 Sergey Senozhatsky wrote:
> > Split struct zcomp_strm into separate compression (Write zcomp_cstrm)
> > and decompression (Read zcomp_dstrm) streams, and split zcomp_ops
> > context creation/destruction into create_cctx/destroy_cctx and
> > optional create_dctx/destroy_dctx callbacks.
> > 
> > This decouples Read (decompression) and Write (compression) paths so
> > they no longer contend on the same per-CPU stream mutex (Writer vs
> > Reader priority inversion).  Currently, a (low priority) Writer that
> > holds the stream mutex can be preempted by a (higher priority) Reader
> > on the same CPU, which then blocks on that mutex until the Writer gets
> > to run again and releases it, which can take a long time when there
> > are other runnable tasks on that CPU.
> >
> Given lock like mutex, priority inversion happens from Monday to Friday,
> but I wonder if you are inventing some wheels in 2026 if proxy excution
> works for you.

Reader-Writer split is a foundation for further improvements (like
singleton recompression stream and so on).

