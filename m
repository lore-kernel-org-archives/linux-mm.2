Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F5F3CCD1A5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 19:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E2E78E000A; Mon, 20 Oct 2025 15:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BA298E0002; Mon, 20 Oct 2025 15:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CFC78E000A; Mon, 20 Oct 2025 15:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D0548E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:26:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 02F161A028A
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 19:26:53 +0000 (UTC)
X-FDA: 84019475148.23.7724C5E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 655F040004
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 19:26:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=P0g8omOg;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760988411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UTXB7/q8p4TNL9vNa5DPOotMkbp1a/zM+v7YOiHTFsA=;
	b=PSqux0H+GH0RAkQs1Rug3dmeMmCk+o+SyZcc5HK1BjN+PofQJ7HvltBu6nDEBZrb6riSiv
	JrszRpu0ODWEvXuMzU0SbBNjJhVPdpp3yMMyW+VfoPdI1VeEcrCy3ZTS9cqOQ8dSvwIi8m
	fTMj2zjBe9tDNgIaMTHTATcBJZVmVQU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=P0g8omOg;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760988411; a=rsa-sha256;
	cv=none;
	b=Baq9ahyh73pvmMYhk2IK5D6HY6sa/D8gggm1l5WEwJjTylKiiWveLlUWPAYtqX1O2SXJRQ
	9r15mzhxyAR2HDx8sHWtCQiava79Ou6Ig5K0X+VlOYDxHs5W5X5s43x+2JivUqjXTp3a0l
	PHjPS0sDUcflEBMBqKM74u6+xeW2q/A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760988410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UTXB7/q8p4TNL9vNa5DPOotMkbp1a/zM+v7YOiHTFsA=;
	b=P0g8omOgQja6Suv2QxeyXylfDsiN4bQik9YH5+QAdsuLu7lie/hFwrth0GKoTM27+7oKF/
	8AkSlRkcZsIpsbdVslCzhZ+8uAelvNOU7AbORBNxrDxeHB4qS2QdATGQCmc/XQI7GhRd9M
	QNLgj+Q8726f1s7PM+zA3O2y8/fQWek=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-4al7WX-XNgWfgaYzM9Bn9g-1; Mon, 20 Oct 2025 15:26:46 -0400
X-MC-Unique: 4al7WX-XNgWfgaYzM9Bn9g-1
X-Mimecast-MFC-AGG-ID: 4al7WX-XNgWfgaYzM9Bn9g_1760988405
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4710c04a403so52146845e9.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:26:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760988405; x=1761593205;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UTXB7/q8p4TNL9vNa5DPOotMkbp1a/zM+v7YOiHTFsA=;
        b=IcI4aG6bKR1SP+2sRRHjSp4XA0DAM5obPGnuoW9grh15ftx3wxK7mLmV+uRioKJc6/
         IZr+XXfsvk5LtpNXCHanznpU7BbthVCXib1kCySAOz9XI0C7ndgXC8X4AfwN1nRKZrl8
         5pMk5UrlxOL8na/mGhk0Op6fMcOcQfWQcKXwlL/7VAJg4mK5hhwA/yPrOON8j528FkQY
         o2XYzZJaQyIG6NpXWYhxqfsSet7ujO1mYI9fWLjH/bEuYPLHyKANvZvQqRNjk8PggC05
         fkXUEOC4j2/Ty8Wukmto+b5sKfjHh2J6LP8lrLtbGmKUjXb1Lh0qXPnuV9dAH1MHx2If
         iE6A==
X-Forwarded-Encrypted: i=1; AJvYcCUyuXdtMcBLHgjmLbrkeuPZdBUYUWXpA9GwuMz8g+es8NAnit+sjYM6I3lF7EOoHWFCt/uVXPlpeA==@kvack.org
X-Gm-Message-State: AOJu0YwexBnVDCyTfWMTLCcZ1XyUdECCf5VIBCTKvMg2zA5JVbB28fQt
	BSVyNrY/EUMcdGg3ditBCWHXsLxriE9xpQp1hAGlYHPpeugEwu/Rftq+9pcVH9BNdEr8nprlKFg
	qcWMjoyt7hkABdRXw2PZAz/3N2s7+Z6b8QQAvjkiR55NiRVzKIpf8
X-Gm-Gg: ASbGncvYevzGaMj7tu1OVRWwdrYO7awyfFNJH2hq5X3Yaz0P4VCVshVl0NgtAfVlWxL
	UrwoXpIIpJiV+sdCcFKndr881AVvooPsSb1Sncv24EhFv+h9nBQXRH98qfTGQZBoByFssDAiC82
	AilVZLHWmkjmynWkS6GQ3LWdFr7QRa1aIo3/VZdSFmpae2dG0glDTj/1kR7d7dL8a+X+61Mnz5q
	mDZA7g7Hsb+5/xxLk9FtbDXY8LvUyCIpfZQiPVXsg1+vRdDcVZ9mbecESPBV8Vu98Sn+c2C25wi
	2Vhtej6copNzzcKMr3EqI2Ikz7nGUZ5z7U4P1SmNsKqs0gd6bQtnXk/qfAxtmur22lF885vLtrY
	KdwgVGikvD6L/ylTA1cn50aqB69zS+P44ViWFZlYkyJ/EZr+yT9+BMQxFfM8UcRt90KT+2dIOKH
	1degaksKeP9L0F4pDkKXuijBxdNM0=
X-Received: by 2002:a05:600c:8185:b0:471:14e7:e988 with SMTP id 5b1f17b1804b1-47117925d0emr107430275e9.35.1760988404966;
        Mon, 20 Oct 2025 12:26:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfhRTNhNg7YWVfxTym0dxgSdzchCcacq4Q770pmVWsBNDJLEfc+4CUgQteSBDZjY1EjbrX9Q==
X-Received: by 2002:a05:600c:8185:b0:471:14e7:e988 with SMTP id 5b1f17b1804b1-47117925d0emr107430195e9.35.1760988404582;
        Mon, 20 Oct 2025 12:26:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47494ab11bbsm2352275e9.1.2025.10.20.12.26.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 12:26:44 -0700 (PDT)
Message-ID: <7e43294a-03d5-42e5-bec2-5fbcfab97b69@redhat.com>
Date: Mon, 20 Oct 2025 21:26:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_isolation: clarify FIXME around shrink_slab() in
 memory hotplug
To: Manish Kumar <manish1588@gmail.com>, akpm@linux-foundation.org
Cc: vbabka@suse.cz, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251015175041.40408-1-manish1588@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251015175041.40408-1-manish1588@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uYvsRQKX8UNDhzC8cmHxXwyVDoQs8MdY-VaF6zbe8ho_1760988405
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 655F040004
X-Stat-Signature: zjsu1n7ad147ra6gnhyara39jczxbun4
X-Rspam-User: 
X-HE-Tag: 1760988411-21857
X-HE-Meta: U2FsdGVkX184ouVFTjegv8tUJoPy0UKAAfyVOJBryq2JX+jvYMWrv4hmoOA8jXrBjCw8K03RwjYewVLYetu7reaO6cKIeZUD2c1gGsejN8e5sdJ4Eh7jsX0QOEB/14P2t2mL87zAbMJYISoHbRWmjFq9s9ca2oJkBP51TeOcq8zBOZzC/6VyOXy13Vrnt+y41Nbx+YL9lFjov2LSgrliSnUkWAL9P8R849facY5CGHM9inHhCPcCrHYdID9L+3JrdNKUAjdcoWEkMhF7U9FZcpwUY7LY9kvXxWw478GI0m1J5cJcQMeZejDDNg9TautouxUcwQugYdqRujruPjwWpCzEy/xhmcnAStp2Yj9IIaLWK078XFAqU1PzV+WQiFCwF2IyPTu9X4sLZ2yZ91l2IQXWnWy2XBG+PqncjjvW69pjh7/iupY27OateSE3EimeQ7Ns64nCQEKIrY51alwhLFLP9oki20cnEpeHgkxkAUSyUsOTpWnhwC3nnW8jcCrKmo0ftIwRWWQ1MtcfaRkNd4jFjgTNc430DisV9KkbQ4SybO7KWpQdt2h+law0qSCLjN+ohdA/9pWN48STswv6zemfbkmnAUF/bXBYq5XUAkuxjgdrh5wRCfLAGzNeIFOuzcLntBJrUyMvVGflNArGa1XOSnBym18/4l9GjUafy+RlPMhH3v8QD0XUcloP+eKHGMoKwpO18nT/XY+nGaYzB2kV6swBE90/V+37nXIoqQvUic9FJDbvdJaEHWUjVm1clRnghYtkFsXD6d+bSAjxtZrEr/wPUx3R8RzPs8eM+rgmzu7TBSwAuMb4IdMzjH1Sq/qqb++aRmVoiQIuZXunB6cP8Fg+5TA++G1v/V5FzU5HSNc2/u2dGdfp13YzNwota+GnA7NJ0yz2mwxKUcs+5ZtWwmgKPvageVH35Pm4aXxDkaar6yeWxjXKzlftNULyU97MH9Bbd1OvQPPnQej
 ewNN1+5o
 p+W2jwFTrWVfDh6o/IvnEE8DhZu3WVDuZh6IdEvCiCKtdocu+fXLDsj2HN07w/A0Fa5Q5JBgddU4da7L2u3bzf9ygc92wNOtGaYqE9lEfngtiGSlBRSJ8MNq9x6p1zgmx3VGG+5UG+0Kq2HREAfNrPiujS/pgDqsSSTZcQWGmnf5a/rM/Mtcn1wpnmQfKA8fYeZ+Cnd6hkXBR/vueIZsOA2QtwD4bAVbivsI0C18ig/d/JjVa8YMf55kooXTHEmX84De0nH7dms4R8vzqCiSrzmYcDKAApINqCbg0bI5+nVclwsrruCOb0eccLR20em9EA86y2+uudzIBwX+GeDobD/3EyKsjaSDXsyKvW77Z99GwydQ2xpJhI6S8D8RdT6F1PPNql4Tf4CWpEMEowqeqt+fJHhIUPZXJ5YeUkpI43fsRX/cYg81mfQ2lHjLFrP8rE7SkF5/FjciZs1Q7GkH2Hao/UUrSQ/Vmeard5+6Ssu58reKbFjNNjCgovg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.10.25 19:50, Manish Kumar wrote:
> The existing FIXME comment notes that memory hotplug doesn't invoke
> shrink_slab() directly. This patch adds context explaining that this is
> an intentional design choice to avoid recursion or deadlocks in the
> memory reclaim path, as slab shrinking is handled by vmscan.
> 
> Signed-off-by: Manish Kumar <manish1588@gmail.com>
> ---
>   mm/page_isolation.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> index b2fc5266e3d2..2ca20c3f0a97 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -176,10 +176,16 @@ static int set_migratetype_isolate(struct page *page, int migratetype, int isol_
>   
>   	/*
>   	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
> -	 * We just check MOVABLE pages.
> +	 *
> +	 * This is an intentional limitation: invoking shrink_slab() from a
> +	 * hotplug path can cause reclaim recursion or deadlock if the normal
> +	 * memory reclaim (vmscan) path is already active. Slab shrinking is
> +	 * handled by the vmscan reclaim code under normal operation, so hotplug
> +	 * avoids direct calls into shrink_slab() to prevent reentrancy issues.

This is the first time I hear about this reentrance issue.

How did you come up with this explanation?

-- 
Cheers

David / dhildenb


