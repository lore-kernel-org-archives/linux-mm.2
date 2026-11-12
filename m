Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E35D606A89E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=sP0H+XlC
Received: by kanga.kvack.org (Postfix)
	id 5E5B56B05B0; Thu, 12 Nov 2026 11:26:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56EB96B05C1; Thu, 12 Nov 2026 11:26:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436446B05C2; Thu, 12 Nov 2026 11:26:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1ED156B05B0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:26:53 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 95FC112060D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:26:52 +0000 (UTC)
X-FDA: 85426995864.21.22AE2CC
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id 768331C0004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:26:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=sP0H+XlC;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794500810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zy2nREmykWs6qK0x39KiCj1K4H7Cbhg1tuWFyKfn2Lg=;
	b=Ydz39UG5oy6sHzXB3BjaNTkOVb412qdIhC/L6PRqHnx7ie2P4fhcLyXY1VJtHmnmW1tpcs
	9Wyre8ThAPpbuWRlAPU2CjVmd+VLPA6HA/1HsGxwCcLEM56DAtLebuCFwTzGdVoz/9Yo3W
	+h29uyiUK37Ebn5THeMKGEDNIm7h+K4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=sP0H+XlC;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794500810;
	b=uRyfWeRWqSHSk0FKfu6tXbRIrK2R4ispdY3jSd5dde71Z28oj3RV6t5JIRZMZ0+FlkB7un
	tp89pEV00E0BNxPhZEz8VFFKaBWs1byijn3wWdmBcyFUeO8uvBh2TjAjSimdnzc1xke1ge
	kOO+v689hOTCx86GU2kZZjfo2R/XVY4=
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-67c6a0abc2eso2508461d50.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1794500809; x=1795105609; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zy2nREmykWs6qK0x39KiCj1K4H7Cbhg1tuWFyKfn2Lg=;
        b=sP0H+XlCEu4S/fWI2OwGKjWyUVe/QQQZuDsYYKwpL8nWeS5oefKy44GJKTaAAlDuxR
         nt70F+aMAO9qhjtB02RTvMsphMMhYckIYqRyyJ0dygOUPcMfdXjSf2RGgv8oi+DM/D1b
         SGXcoGH0Ou2bgAEBJ9dfmus2u4XOU/0HcNy+m53A2dUmq/Y+CRbWrnSHrbsxHuxXkZAf
         KjtjK0AN3xGBEYRGfNcRyH2V1lrsQ4+KdNH52RSxnH7gHIIrgJL5gUFq4DYQnCMztS5o
         KSpbznEGYsDrGjtN4sKzMGjGih/y0lsJOgAlzXR9sn3XhFd9eAIIXHGoOgpJeXUObUbe
         DZrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794500809; x=1795105609;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zy2nREmykWs6qK0x39KiCj1K4H7Cbhg1tuWFyKfn2Lg=;
        b=WyehXsP/qh+2FIdDrvjrYntLKxu2r/zfrZ7eg5eZWuLQuwPR2cNVUyk3EwmXyCahsC
         6bRss15UP/stndAzyI1Bt3WtBJk8KTEeqW0pTjNyOG97faxJ48iURFbS3SHmCr1jxVtH
         fFLFovLD22e1CjfZdB8N11UuP7X2qbWyNOYVg9KivxXB3fPWEe77jXCjllAMgvBp2Isj
         6LPkIYbs6gYQGdMgh0MWUhBhVaRQHqqjBmC6Exu0SW+HmHoZG5NN54GFkze3Hj0F+zuR
         rKaBrJEZwumQljCszkZQiFb78S9G9soHypP1wLfH4l/2JlfeEQBs/Rup1WxIrhXRN9sO
         bVzg==
X-Forwarded-Encrypted: i=1; AL+hErE+nSr85qs53vrs8phYGvzel6SO/1QQNYkd0spJvbS3rPEA2lYE6Yy0NABLHd3W083n7JkuUzMwAw==@kvack.org
X-Gm-Message-State: APuU4Z+5KMUZV9UVpaeRuYbMRJuMazA9HiVhlWkhq4K5VQhZK+jl91m5
	1s5Wq58TBbD29xhFrRYrd37L9rjK16E1DpOQyUCj+WUNYCQw9hAOTnS5m5/ij+vhrRk=
X-Gm-Gg: AYBFou311wbOY+Qr2qhFzUN2IFxjTOFJYNtLatAgPCqQZhpR8k60CPsMaYHBmrZcbB0
	sKy2IoD3xUU76te2t8J2KD/gAZtZBRHEpW90pUbY4F+s9Wl4Hqi2dSES9IDMmzXxUAAqzhQz+lB
	rMyMCppJWkrgddh/Ui3Evmd1MR2H+sBs4PrqHmu4O3nJOemoMo1L3T21Bt+om7fZku4801A73DL
	x5r+vlLmjlDsnudAiAacshAkS3GCM1AlywpVYXP+gGq0MPIfIQwlPIF0YzXYzrKsMsmTUgmLzaA
	iZEOBYmRIGs3FJHIgL/cc7K3uJVbMukhxsS7EjeOMdKgdyoP1f9Oe17ozUvojzU6w01IssOpeXC
	EWVNgp7AqiuAvyZ3im1Br7zOvnHsiA8RooPaXHbTdrby+fMIcJGIi+aoJ1Ra562Cv5DB2BNXxpM
	kY09JaXZ56PsywLv03YSAfjixJQF2Qv9Osmsja1iRnWrvZMqfqWTb8c709mEL+y6kCgSN30e96X
	HOTzKtU3oJrXBe/HQPjIoYAHwQnqkk1Li7mRAWxA64L6OA0UkFULO6EC8yDP1KxrfpejNH051G4
	RxqsDyQGTL97HIsz3x99B2/aQj+5
X-Received: by 2002:a05:690e:d01:b0:679:a2c3:b294 with SMTP id 956f58d0204a3-67c67ff20aemr3211748d50.83.1794500809370;
        Thu, 12 Nov 2026 08:26:49 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67c589cf1fcsm7627342d50.13.2026.11.12.08.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 08:26:47 -0800 (PST)
Date: Thu, 12 Nov 2026 11:26:46 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
	terrelln@fb.com, dsterba@suse.com, yosry@kernel.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, riel@surriel.com,
	shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH 2/2] crypto: deflate - use vmalloc() for stream workspaces
Message-ID: <avXoxnMq6ns8AK0z@cmpxchg.org>
References: <20261111153532.1036709-1-usama.arif@linux.dev>
 <20261111153532.1036709-3-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111153532.1036709-3-usama.arif@linux.dev>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 768331C0004
X-Stat-Signature: n17s88ndhks3mycscyfmuskbm7k5wqko
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794500810-43676
X-HE-Meta: U2FsdGVkX198r2M5I+QYvAzUBzeF3WZWDttuz07QYd4cnsgPFy8VGp07WP80yc4tseItIAwIutEh01uk/OYhv8l+lEn3iM2KYdNYAo1/tH/qEY/EroClmk9lQjzhqfUnmF6fCdLmYAZ1srZhKZ1eaCtufk2Js60nUSR76EMJhGqJS74ac82KbBxeULEduvxAGxRl2JiW+pzpMYGSsM3d8yhFyH8Kd95lKcZqx85IE0/qsfdW5COXsMHRdCAoyX6+SD8ZE8SoSDqL0qlk0rdMtHxaakH8rHBF/wjhqipzhJ6NQeu66xaw8AQzqwnpS3TUJ48aW3G6jL1VE4iaWqUTDPFCtPo4zFuocogf7XDiPbNL8ma+YTaMMVqiRjgmkXKf4ujWZJmo5zfTuh23HJiQmIqwi4eCPtivf/gMpoyfsXC+OzAoYsWYIcbCk9Ky213jQX43Gl0+dzlgod72eQ7LmyFFGmDomfgiq//mRjIQuduuDlqWaNyHSKyspg5Y2V4x7jJ8Ejns7bpPZTEbZ9Qr+VkcJWR4fTRWzekIgtVxlMT4CId2Xl/MbgVAeaWBxnx5BU8IyVEYl34f6Sb0/ezFN9qJ/FEbS9xeWZLWZvgPuZOe7lsfbOHl8xTc+5M8jq5Mthlq6LZUVe024EYPoOgqa42ha1RMPovXZqmcQfaUsfFci/ZJfLcH4Qpb7kov48EhEY2D/K6BYt80bDEbtculZ/2P3hJY0QMC7nv4GmtqARPytK2Cswc3/8pxNqUeScSAIMNPYCuF73jbwgHpItojo8SabDHTXBWARAOOAtMRP+Rjv/jRZt5HduZp84Mk4UPaEn3Q1O8PuLfXX26rdMr+WS4AgKK58hri1JCE25dTWINXxAA0dkEnmaqnUgi4+1V6/8p3W9LeWvDO95pIb8+OcoD5/9IWim3Du9lRQ2LbvZTqEOFdScCXUNSILv3uZiAxNHDUiCBLr7FqsVookM/
 l8W16Bvi
 i6Ev9X4TIXExlFnhdbZ+4+huLwmm/bJDyTSqza3wwvwSQRYmVaHXMtUE/jMJTqkyXBZMxYdlACn6PYwXAY335TtPwIMjkTs8h6yLThxGMkkfUtw/x0+1fpSfZWx8vGfMiwWYE32aK6zvQbSt4KtV03mDZm5UcfLrp7FxzSZ+quSsZkBwaLoXh+gVtV9NoZXg1qJo7VZEP+dOX7abNNEP9Ky03QfpmwRoSJlts5K7T8ySrwz7V6TEJljI7WCA9FbSNrz4KGKvEIkxK2OG3WAStKd/EnSsdg2A1ndySx3XwlshaPZOSTxysu9o3roRHG7ZTTqoXE+ZacdbLjIX4f7iiV1cAknLbyObqq9jOYgqQj+K1XWJQxmLRjP5UmWTBKP1KdPVQtqQIMxqAX9lXGNHzOjbSTL8VQ/eOxKeJZqdONQxCmp0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 07:07:40AM -0800, Usama Arif wrote:
> The deflate acomp streams outlive the transforms that use them. One
> stream is allocated during transform initialization; additional
> per-CPU streams are allocated on demand. They are freed only when
> the algorithm is unregistered.
> 
> In a 4 KiB-page x86-64 build, each stream requests 145,320 bytes.
> If kvmalloc() succeeds via kmalloc(), it occupies an order-6 block
> (256 KiB). vmalloc() needs 36 backing pages (144 KiB), 112 KiB fewer
> per stream. Across 384 populated streams, that is 42 MiB less
> workspace backing if all would have used kmalloc(). There is no such
> gain when kvmalloc() already falls back to vmalloc().
> 
> Use vmalloc() and vfree() directly, as the crypto lz4 implementations
> already do. This uses vmalloc address space, page tables and
> bookkeeping; the figures above compare workspace backing only.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

