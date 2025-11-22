Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E80CCFC516
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 01:52:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97E606B002D; Fri, 21 Nov 2025 20:52:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9077A6B002E; Fri, 21 Nov 2025 20:52:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F68C6B0030; Fri, 21 Nov 2025 20:52:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6A51E6B002D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:52:25 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3AA4B8A124
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:52:25 +0000 (UTC)
X-FDA: 84136568250.21.39536B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 264B218000F
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:52:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OlxWRJLc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763776343; a=rsa-sha256;
	cv=none;
	b=B4/bFF+GMgAGmI5KMKDc5ApuRfJIipny9warFcheuVXshU7bIfV9rnqV2KkOSsJL0fNe7V
	wKFNJRzAZ6V5KyBA5i4eTpB0ItL6qrEpw8hngkwpjb2+WFmMGuchp+PmxMso39LxxW8BjY
	x90N/VIiLxjOb4pfjkHLpJ6e5qq5ZQE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OlxWRJLc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763776343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ehUBolgNcR1kUkJ4Lw5mX9aGTTiD8+arUjt3qospZsE=;
	b=oL3Fg/FWIrSIPRN2dpyh38/ZLjkjEnilGhzmEPC7KxA6KCDvU8gcWF26BdkmYYM1K+y2pv
	ExAyO1pqjn2zIE3YRMW5UOAkk4PQFOHJi0PMZk8meDP8rCSPJPUbYlpmViEB6Lql+vQBN6
	XQUy//LDRzhFkrxBgUIvVp/nYabqYhs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5678444220
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D269C19423
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763776342;
	bh=P5NxdT/SIe6KmcQLmrsgsa4TxybfCRF36ok9vGqcTew=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=OlxWRJLc7tT9axKRU7LUcTyG80ardWnMU4r4vPmSUs5IbK0FoFwR9jSFGqJXbovfQ
	 y/u32Fka+yQw+AQBSsL/zAhSjQLMswgGj3rCqpO7Yi0kjLO7cZD0Gd0K6AgvWSTma6
	 sMSz3hyxGyRO2mLdSIwl09uQSaeYGp/c48g0R4nOCPrEVLOOqvMOS3Cucrz4Xs9O+5
	 qB24J3UZZ0MkgpL5JZxKuNtl32kMtXb/F3BYP40IqC1gkZbQD4QuFs9WQS/8l50Wpy
	 DJ05KpZJhW6w1v7Syg0Z5rz5o6MJ5ZjndAT7SDJQHc8U/1XrLCPj1FNwmiA0b1z0vv
	 77PVBqIubrCqg==
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-640d0895d7cso3505757d50.1
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:52:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVjHfD8s6A0LjCZfr8DIjdRrv9yZgPXblaklDevocgKG+usAaA2XTaKxFGoZNSXN1Mev8740GMXAg==@kvack.org
X-Gm-Message-State: AOJu0Yz8Q44G+7/zcgP9hoJUcH7oKiI1KMBsW6D+DLMgy0HHd6cvuR6H
	RoAiETe761LAiYQfELmfBjlSC/cn9Ndavnr0ZVGcwQDI7c5nSzcO4JZn0+k1wpDXZJ3dsSZOWYR
	piXrQYrXgkiv1C1vO3Vw1LofsFfxVcUoW58cRf6FNSQ==
X-Google-Smtp-Source: AGHT+IHiVzh5ogpYbhovraPKV53UHGMvLA84xEXeg3w/dBTQjKEVSD2WkOgdOQRihbIzCh02a4a332/gs3AD5psIiNc=
X-Received: by 2002:a05:690e:d44:b0:63f:ae5f:d7cb with SMTP id
 956f58d0204a3-642f8d41f50mr5864159d50.0.1763776341506; Fri, 21 Nov 2025
 17:52:21 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <20251121114011.GA71307@cmpxchg.org>
In-Reply-To: <20251121114011.GA71307@cmpxchg.org>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 21 Nov 2025 17:52:09 -0800
X-Gmail-Original-Message-ID: <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
X-Gm-Features: AWmQ_bm8GJcZGoiIFmkTSi7I-cijMVbj23wqlJLkpPIDhj_fS4E5zCem48bP-wo
Message-ID: <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 264B218000F
X-Stat-Signature: yhntc5she6jwj8u3soskpb5g9nkzgjbt
X-HE-Tag: 1763776342-784657
X-HE-Meta: U2FsdGVkX1/Ju+g+9+gJp1ooQwSwGp8G7wguA9JMkAWNqeph2ilgZmKFEL/rjcm87YVq3EYK11qbhboVhNmozmNGsfNA1863eRj77zyk6wXlicekplCg/ukTMwb+DZ4BtPY/UfCsvvjlhkFCK2er+cbS7rqPAyLEvnMJPRdLOIzyYqY8/fQE0qETe2DeqsVGUMpMV0ntrT0iOO2OwWLL45sRd0f6HxpEVqXEK5vNy9kqOqBNCNe02ZWjeREoHKvLNjMx6lQJqz4IkZZiWmbE2otMx/gHsEDF9CxoEfCJ+jzTJGg/VF9PpbPWzmGnehmPqh6ZsLE1ge1nxV2DXXXC3B5J08otdvTidMEVPa87OCa0ixOx2lrx+KQ4RQh23PKvu8GRqhZi5XfhNof/5ul7DpSTqWejZpZ3VoMvnqxO/kVv/PvHsxN8LZqv59GCaBtejyt/uDf+CCZllWSK/S80HI83e+kOettXPYoxJtDmze2iHhlJlW7M8pq2VHWs8OjJHiMAS8EOZOTOvxhSGKf/Y1jzfxckdXW9otW2HIgXbYRXCB1THBuRhFyxbD0BfCNbJa3Js2Rjl/IM7A3cfBPefuhXywKW9iZl0/Oru+d9EkVDdi3Sm9WtUfyIz8AAbrM8pnve/33zOQy4gkA2PtaqK/fsHXdf8RwO1SILiShVqUmupFp5grdq50kso6TmVCEik6pUp4hAbN+gpo8whSW0t8edCEFhMRT5zlOJjPDjDCt+bUGCWlnbJMFWhZYy1L+Vh9YnAx2+t74FtHC4M3w57f8/UrfIufoO9RpdE5j28i2tw0d/cOoFN0F9qXtDuR8DNxQFaar5Cd3ZLIfO7fMSAiywKeSuqVpZdh51gcWENyDH/eozg+HjY9k3OtnBneldT9VZwj13+pp7CPH6OpTnUtMo7pZ9Ka7/f4ZWGbuoHwyDi1EL25BmeM+bp7HjNRgFaXeNIcR1ApggvjVMQmf
 UguDRKKs
 iRMm4FV7qF03DZlDZD5xN8cc6K8vVS5iBKN5i2AnMjlVVEp0112JvwFl+XReAVlatSUmXeXh6FvElpkH/ZmjPQ1aQD2yhOIpvgd8GqXibBpY4PP2lD77y5uGEI7gxyBHMNNsvqczg0WIbG/NbtZDpkjekDuLTK5/9EwdtQngel6FdwloWTH9WHMUCbw7gm71MuTHQlS7x1NuR5hzVM5ngCspSyagS8cceEaCaQQ2dA5N8CoJTwc9PGoWGvF6ewD5cFzVOa/fqYNCCdrq6mQtpNVqKrcUJWHNGTVUgoG572Uxk96Uvt++55yOOzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 3:40=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Fri, Nov 21, 2025 at 01:31:43AM -0800, Chris Li wrote:
> > The current zswap requires a backing swapfile. The swap slot used
> > by zswap is not able to be used by the swapfile. That waste swapfile
> > space.
> >
> > The ghost swapfile is a swapfile that only contains the swapfile header
> > for zswap. The swapfile header indicate the size of the swapfile. There
> > is no swap data section in the ghost swapfile, therefore, no waste of
> > swapfile space.  As such, any write to a ghost swapfile will fail. To
> > prevents accidental read or write of ghost swapfile, bdev of
> > swap_info_struct is set to NULL. Ghost swapfile will also set the SSD
> > flag because there is no rotation disk access when using zswap.
>
> Zswap is primarily a compressed cache for real swap on secondary
> storage. It's indeed quite important that entries currently in zswap
> don't occupy disk slots; but for a solution to this to be acceptable,
> it has to work with the primary usecase and support disk writeback.

Well, my plan is to support the writeback via swap.tiers.

> This direction is a dead-end. Please take a look at Nhat's swap
> virtualization patches. They decouple zswap from disk geometry, while
> still supporting writeback to an actual backend file.

Yes, there are many ways to decouple zswap from disk geometry, my swap
table + swap.tiers design can do that as well. I have concerns about
swap virtualization in the aspect of adding another layer of memory
overhead addition per swap entry and CPU overhead of extra xarray
lookup. I believe my approach is technically superior and cleaner.
Both faster and cleaner. Basically swap.tiers + VFS like swap read
write page ops. I will let Nhat clarify the performance and memory
overhead side of the swap virtualization.

I am not against swap entry redirection. Just the swap virtualization
series needs to compare against the alternatives in terms of memory
overhead and throughput.
Solving it from the swap.tiers angle is cleaner.

> Nacked-by: Johannes Weiner <hannes@cmpxchg.org>

I take that the only relevant part is you are zswap maintainer and I
am the swap maintainer. Fine. I got the message. I will leave the
zswap alone. I will find other ways to address the memory base swap
tiers in swap.tiers.

Chris

