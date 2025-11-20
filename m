Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F4238CF8865
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:24:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A8356B0011; Thu, 20 Nov 2025 10:24:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558486B00BA; Thu, 20 Nov 2025 10:24:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446E76B00BC; Thu, 20 Nov 2025 10:24:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DA906B00BA
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:24:53 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA85C12DDE5
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:24:52 +0000 (UTC)
X-FDA: 84131358024.10.AB6802C
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf23.hostedemail.com (Postfix) with ESMTP id 166D2140018
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:24:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ku36GYJn;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763652291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6y/ne0wZndH5zO3FaM35/ylxSZxnZPTH23+w/6th6WY=;
	b=wgRdwbTlTc07qpFBBfkz1of200EVL+tMI4UhcxfFq8ei8KT9uc4m/wZsp9UN1Cu8Y4BNLC
	Jjlct6uqTb7oRNqAs9CYjVSH1oSAD6KBXUi9PW3N0bq9HpenyCB2BpthxbYLxqKrzJ0eKx
	23Eu2es8AcbvBQ4p+eMuk67g+xbgY+E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763652291; a=rsa-sha256;
	cv=none;
	b=6s4Cf8Fu0Pln5pzR0EoIhdVAQtdwBWBNLbv8FOLpBpbTlQ0JvDeQg0EWy8Y1T3R9Th5nLu
	OuVDSacS1PMK+5/hx2WKyBUgFSFlt4Gt62dW3zFGjASi6B9QbjMRYgndyKcWFKQWCFM4s+
	UC1qyqtYBShjn/KS2adxqv3cwJ4L/Q8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ku36GYJn;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b739ef3f739so201759666b.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763652289; x=1764257089; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6y/ne0wZndH5zO3FaM35/ylxSZxnZPTH23+w/6th6WY=;
        b=ku36GYJnc8t7XT+R8wex1Wc6yhCjeSk42+5O6ZcPkVAkp3IOwNZxFm4Ymm7dKBtDuc
         nmTEP3gzuvMUWDMCL7zwnCHADMWOBBKrkATy5ifTRbTy8nd/Kj3pEXaziGkYZy3pYtze
         exI8s8DymjFBzdeDwM/1s9JrpgULa6iQ52yTv5+fyaNKU9msMYvkk1Z/jUJuuQoy+Tic
         u8FfzRvLNNxeefJ+XfcPD+P/ATl+Q2ZTCHsol1VIrED+tJRVG4lmKcj2EJVyWOeThqvB
         fHRR+EPDXjY9OfGBI4MgK530jG3P5GalsVoMsTNNrBWATQIUuweu47J0AEN1Zwbi8R1K
         kkUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763652289; x=1764257089;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6y/ne0wZndH5zO3FaM35/ylxSZxnZPTH23+w/6th6WY=;
        b=hjN2WkQ6oqg+LJAPkpaBZ2TgtuFJ19Zfa1INB1dMc5t5fUhInPHHyBMmvC13e5FZ7K
         oynn7JSA6VOB0nXvQ/4y5zGw2pUQ0MPbHv78jtmGFza1z7DidszFeI0ILVvALhQJQy/x
         tnbFzzzbwF2MT3zsYogF3EsJXQk+txr2xWzE5djai2iXpO+pJPJiZTWV9R02JBG/XRs8
         UX8C0RJjyGmEO96F/nY4fo1y0vOotYvgBZqCrkBggni9YzPdb+hxb2iiVds27rwMrdEz
         zX1s8PnCpFYDqfjSwHX+cahCp1cKB/sz8Q1W7gWhKaVe3MDyR25Oe0t01jPb0DZ+FPmO
         s3Mw==
X-Gm-Message-State: AOJu0Yw1LxCeANh+o2ebEBhPCDqSJyXySXhsm8GD0F5Nnu0LRq0GfYPr
	lDb8MMVdp+Qmk/wloxEtuM2pCjsK+HnEnhzNJh93FQSxeVCHG+eKniNllWByZZ3ZNqLtTtJmfcy
	qeyyh/N41+KgzK5sn+Cwd1lIMOhtB1Io=
X-Gm-Gg: ASbGncuzYHt++BHPag1KeyGCrbjsBSWOZ7LIrzbt4W2Ym0SHzj6l5UhXBDM4KdBDHXI
	U6B3GBF+5javtbY8NOVvEAd9ORgYe/1oUu3BOzTgttGA/GThjRQvNo9mWoCIRg83VGpvcgXPGZ8
	am+XjVXTpnm/ti3o5jc3kVXu2/2Ju9F7lTnjNzF01TgoVOwdl2lzO6VQ7WlmM5LMXJiSb0ULiuj
	WQiuPCY3SevMt7HAqO6twu9UMyFgTHWk2kdtTMB7+zhkkVZAKSWFOt/XwpAnpZ7lOowoBTBybxV
	Hb1jWOi+XuTBrWipSfO0mVPPiirJL9s=
X-Google-Smtp-Source: AGHT+IHtHKc1nhUG9TCWSjiJGwYThNYvO+rK1/PqWavFfKQZo5ZMDUmFxuyVoXTkX9J5YPtc2jWNqfawLtQhuX8gCPQ=
X-Received: by 2002:a17:906:f59b:b0:b73:6998:7bce with SMTP id
 a640c23a62f3a-b7654f9f5admr401232966b.33.1763652289231; Thu, 20 Nov 2025
 07:24:49 -0800 (PST)
MIME-Version: 1.0
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
 <20251117-swap-table-p2-v2-10-37730e6ea6d5@tencent.com> <aR6/Kc0kag8Z9y6y@yjaykim-PowerEdge-T330>
 <aR6/lN6fWi9qQD8J@yjaykim-PowerEdge-T330>
In-Reply-To: <aR6/lN6fWi9qQD8J@yjaykim-PowerEdge-T330>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 20 Nov 2025 23:24:12 +0800
X-Gm-Features: AWmQ_blv2fvoPXXGWCZbSjvj9YB-kiH67x2lHuHoWc1Kr_X9mNdVkoEhvXWH2Dk
Message-ID: <CAMgjq7Bm4ZD3nHLT0pvA7T2pMr+pP7ZAd0Ho_8YKpj8gskQ_TA@mail.gmail.com>
Subject: Re: [PATCH v2 10/19] mm, swap: consolidate cluster reclaim and check logic
To: YoungJun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 166D2140018
X-Stat-Signature: yko77qfs67uikemgduxqgyb4qihak9t6
X-Rspam-User: 
X-HE-Tag: 1763652290-490960
X-HE-Meta: U2FsdGVkX1+BFvlNSvnOkDAeSFntanTgNIdEzCUz5b6d7BiAkFs0OWQBMsfwp93G53Qchy5dLdr/+7KinlDirL9Wg7QqwzeySjOR/YLtxDm1A8nly70CAL0XmmaCTcseIkonzJM5XyIEZqG3JbuQ0iRR3wps8LUxegaJd+vkdHGBkwGqIli04C3kW3KJ9e0Ii2+Wk1XxG0TRebpymqZdWa1PaMqcXBFyiUMUkegz1Cu+gh0+wOfti87U868GVodrzUc1E0QKads1bIpLEEApk3Qq4M13CDIRTPZviHMDmrQdIuSjz2QIk2tyvBIzF5N4pS8TlAXaZTRnNF5wX1sRu/rM2cLr9yqjPuOaIzga4TXJk57E0Bb5f5Q+LzbukenstcnKJdfUfpYiPy1f1EP7YWrm1K3qAEDpL/hunPJ1FUn81HLZk/KjfEDY3ZqcjOKzgcv3U3IrhrqqtmRNuULSLyCE7BdKKfVKSN2ZXcWlf4BQlXV6J23YswWP1I8LXCGxmvHma1e+T1cov6bxYHw4RTuFLaZFDNtrSJbZ4k4dMrHdH8pJuUt4o9dbU9+buxwVMy0UYUmC41IzOjuiN89F/ZzXr0TaXWZ3yHwrD1t6wIAKGiwC/257c0zfp4+3ds2mkwwNVGSqYKL9wTsJPwb2VroBJXzOIuNOaMkti8oBNXQwHlS+zfndicbBqBvoSWDtlOHKBA1l6u3gFa/Wn+TEYmnw6KSXSp4DCaWG2am7AfV5ZpLlAFyuDf+evCEtBJ4E0hb/nBja1sOk4k6ouFtGlRaXFer7qXavYACrebJiZLfWDqDqAdTPO5GLoOUw0VXlvwYVXDa6m8KXdhj/2jwMs2uwKEwiOe6mPu9Af6fJoExsZRdZLp6hvVNTX0dKm+rqkthuIWj4cdLPLpmwkB47VJ7BstSL5SalxZFrlRSbJRMKEjk/1rUGxorX81kmI86UhyF85Tv2lhE14HU7hDl
 3gIoAg1e
 k7vdlKF2L534JkdKd39dIuU0sGXLp5TGiJMexprDMXFHqk4YxQYVdmtT5SxvYsQzJzFCCcXHz1jDVXDzx1SAR64EbbHzOhRib12hQ+yq8cXI5ifiUcP2yYjpZp8p0Pz8ine81YVvJEjnPDFduD6Y1rnrb4YR5+y/v5Jfst0voNqpUJtb0KeqNzcAVoqCn4r/g2ZWc9IISEwwD5sRSrNcuyDNIO+Mr+8BzxZBhRMgjr5hm8bLYskBHo3rZ3++sYVy9HwAHAE4KCryBKpuGUuubNEqheVIn2g7v6oVeJvXo3rVEOX4dSaWRyxu3OX9QCrDPcErInVPHGUPzr6v2CGiRFmpXU03UVgQNwxi+HqjOHaQJhMDBuMWJOytCY/dAcqAdU5pJ5YJQ2YrK7HdVJFQb0C8tTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 3:13=E2=80=AFPM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> On Thu, Nov 20, 2025 at 04:11:37PM +0900, YoungJun Park wrote:
> > I found the just very Nit comment cleanup.
> >
> > In swap_cache_add_folio() comment, it mentions "SWAP_HAS_CACHE bit
> > to avoid race or conflict." Also shouldn't the comments that reference
> > HAS_CACHE(the word, swapfile.c) be updated accordingly?
> >
> > Youngjun Park
>
> I added reply on wrong patchset, Sorry.
>
> The comment is for
> [PATCH v2 18/19] mm, swap: drop the SWAP_HAS_CACHE flag

No problem, I got what you mean. Yeah, that one more comment to clean
up. Thanks!

