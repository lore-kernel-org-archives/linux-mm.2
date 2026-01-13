Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BC97D29DC9
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 04:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A42B6B0005; Mon, 12 Jan 2026 23:54:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4519A6B0089; Mon, 12 Jan 2026 23:54:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 334206B008A; Mon, 12 Jan 2026 23:54:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 22DA16B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 23:54:13 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 89CA91A011B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:54:12 +0000 (UTC)
X-FDA: 84325723944.22.1E4FF4F
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7DFB71C0008
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:54:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=X2KjV+3M;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768280050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UKtScXEwrHQrA89l3N54sxGcQUtq2SKFpHUrz7nEa60=;
	b=u28p4hLze1tX4ZnY7BWU/djZbtlAfE/ZkEVSqNmR+PFSJRMDZNINGBcRx6nuFuZL82+sWe
	FRE/G/ouogSBgTWY4h5f2yXoApwQeK0tZQh7OIXYpz6iABghOripUhlsBMtgmTDggKBA4u
	9bmb9mTv3hfzlSw8c9KgxG2Q6KfZ4L0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=X2KjV+3M;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768280050; a=rsa-sha256;
	cv=none;
	b=kRaWz7mCAhSAn08wDD0rET+FSk4p+/kgoL6siJgHYzfVm0LpYSDKLCIHMPh4bJH/Va05tW
	LStjEqi8/DGRRFp/CQJPHiakBTAnb7OQassJINqxlB1u84ptnzI752Qqc3UGSiNbIGZxui
	95mHr35oRzax3CEy0m6v4V7JDPnGEow=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-81e8b1bdf0cso1685522b3a.3
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768280049; x=1768884849; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UKtScXEwrHQrA89l3N54sxGcQUtq2SKFpHUrz7nEa60=;
        b=X2KjV+3MFYPbC8mw5DnGcNvtMG0llqFVcVsyI5fQT20AgxquVheYSV2quKWp0nAKzR
         qy9lB3gNUdyjz5BxhnvgZ3S91v7rtVAjtHKeU9BD5gqmus2zngGn+q93X/WnYgTW0mG9
         zR7YvTjLYTepbtbPY1wseYHZkBCf48aoSEcGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768280049; x=1768884849;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UKtScXEwrHQrA89l3N54sxGcQUtq2SKFpHUrz7nEa60=;
        b=m8gubXgnEXMdJhhGXeG0/5xYKTz/61lcQ6Qq1ybN2YNfQPatfpHQtTYpUMZIQBWSBg
         XH6t4q+sjraHgp4H+zg/zJ8P+vffXfjEczypDwghIHWjwGktXp37LhGdatV86afdLfh9
         EwL/2xVF+YCLlMJ8mvnZhU2k7kaevDkirxTQ2IeMQv59Q4cscmTBVxszMCzxo9FJi8pX
         sRy+rDvsUs/Nn7OanGhU3bwdcdO4d7cphd6l/QOZ81Wp3HeoN/hhg0smZ9QNg5SmfUCR
         SWIjQNJizawyFQnsTQ33qqSaS453h1ChSEYu/SmIoONLINTXtMwwCMcmWIWIqeXMNjoi
         Yb0A==
X-Forwarded-Encrypted: i=1; AJvYcCVZ6QCJoJ8VARsojtrlqmR2vZGf2j4hxxtwyQs2pOCGtdjp1qrJ2QHb/SmXgLmU4tytRwNG58XZ4Q==@kvack.org
X-Gm-Message-State: AOJu0YxL9J/GOkVUMgZ/mciCCOhIvcahlaczc3gcs8EGnj6OTbZ+nz4K
	A4dNgbCbV7R/SPohYifI1VrDC79pWNYtFfDLwsvAF0t5OKLuSDtwJFTEIntk9L9TUg==
X-Gm-Gg: AY/fxX44O7Q42gui9hqaGDtLx484jgPBi3g7NQJCimFBaH9EWzOSVdgX5MCg+bK/P7I
	F4E/4wXWIF3lm25jdExyXCOBHWezjNgP5cKu/0nJ59byEdHao4Hc0DTPYDILGcXm9kyHH0ayj26
	VaEQ77b8BbYTHePf7TVxH8RXyzkUzqt6TNwpedZS9HDeWNLv5IlvMGiYrrHDA893Jq0ppW2wDcU
	hTPzmZokjeRQVPeVWu+mB8vlDdEB3JVPFIu/a/AwWZEs5RYs2A5KEZSVSYsJdHiYN5dfoZuL9rZ
	BGrw2ZWkWEIpeXJIWdhgEwvgQ4pcFXn4qzAb4yYtD3Q9OWHFyTVlVy0Zlx1TDjJvfUXVEzwqldB
	QH5xJXLMHhWp3KmjyMrdbkUrECbsdp4mcG9KwglWQLczBDno6a0i6g/+xT7sO+wDE033Nm8uyFj
	3IQzKCER5oq6b2axmzwWgxcjhLeXWEbmWerSU1Ih2sTHEVFgd5uH55urO/R8oZQA==
X-Google-Smtp-Source: AGHT+IF8giJZ1cwqEfJp/6iUzbp0/TRCRwNaNcmX9U5Tj5XcALJKWgAQYkT9Emt45eu48BVTknyMpA==
X-Received: by 2002:a05:6a20:728a:b0:366:14b2:30a with SMTP id adf61e73a8af0-3898f9cd5d0mr19601101637.61.1768280049256;
        Mon, 12 Jan 2026 20:54:09 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:3c61:f146:e418:e233])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c59b0bf72afsm6489637a12.28.2026.01.12.20.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 20:54:08 -0800 (PST)
Date: Tue, 13 Jan 2026 13:54:02 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: zhangdongdong <zhangdongdong925@sina.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, 
	Richard Chang <richardycc@google.com>, Minchan Kim <minchan@kernel.org>, 
	Brian Geffon <bgeffon@google.com>, David Stevens <stevensd@google.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, 
	Minchan Kim <minchan@google.com>, xiongping1@xiaomi.com, huangjianan@xiaomi.com, 
	wanghui33@xiaomi.com
Subject: Re: [PATCHv2 1/7] zram: introduce compressed data writeback
Message-ID: <aswaagdlczqq3sh2okdew2o5jtzmev5ghdz4ksvzmqkfsshbfw@aoxdptshkqvu>
References: <20251201094754.4149975-1-senozhatsky@chromium.org>
 <20251201094754.4149975-2-senozhatsky@chromium.org>
 <40e38fa7-725b-407a-917a-59c5a76dedcb@sina.com>
 <7bnmkuodymm33yclp6e5oir2sqnqmpwlsb5qlxqyawszb5bvlu@l63wu3ckqihc>
 <2663a3d3-2d52-4269-970a-892d71c966bb@sina.com>
 <z22c2qgw2al73yij2ml2hlle2p24twgpmz4jemfqhjoiekc65f@pvap7olsolfp>
 <a527b179-263f-40ad-9d7c-bfa86731bfde@sina.com>
 <luzn25fgin43cnbmvmxwps7isqeq2pt5kfn26jqzly6hbnedlp@ojpw52ldzmuw>
 <731f6e5b-f678-49ef-ad8e-fe6ff85d5422@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <731f6e5b-f678-49ef-ad8e-fe6ff85d5422@sina.com>
X-Rspam-User: 
X-Stat-Signature: hmoe6gi43s5habckoye4crkf9xj5hf48
X-Rspamd-Queue-Id: 7DFB71C0008
X-Rspamd-Server: rspam04
X-HE-Tag: 1768280050-346935
X-HE-Meta: U2FsdGVkX18TfRXcwsvhnsnnnqlAQfWIhw1+SnniEzcicMoluZBd3wvs4lJnHpQwr3NGfA9kxs/zCbpl14D+9KGhmhJxXYOXTXJONgifxM4aXBaPU35QH2gW8BTSSxnc/ue+PZ0V/HDnmvXWjGU8r3CmslBCW5GmYsGgaetdPMdfl9iLck2fhHaVtLcjM4vat/KOSBprFdOCfQiJdgb5GBE1669dBoLrdo7s1Tymt6KvEVnAWUEZM6wT+hkgmEwg8DhQFZvkJxjDCaOVMB/DVVxF0gU9zC6QzOiumVRO0rpDcf6/hN2J/blifZagfIG1EbxBl8Bi6GyGRwVYqO17A9KORFnJsklUgl20a5T5oJjBrvd/sXPoZmh+mRfmS8RhLgYsZGb4SuwNpxYW52E7wPaeaR4L24sjRDJcZh94EJUwK6Xq1xt/RHViMJIBTMdzz52QEW6qwA5RZtBZQNDuHWIruGEp2f3MDVO7iCTSFSzkxKvtojz9YHOMScPUnTcZDNx/w99QjvBKP82qA87h7qggjjnRK8TdXH8xrcTqLP5XD1M4RhEjMTi6iCekDF/t2djlriBnNZxa+wwYK8QkGN3r1Aln/FTOi90t6kLbwlr0O6nAKeY3B7zfKlHgE3j5VKy/sqhwWpK7ThEl+u/uaH3C3LFf6sE4gDZ93Zsid04HbTfYci40WxLMghOEyPYYvNCLNyYv0BlDsLSmASl3EutdLU4DPDx9+Lm6oR4FWhwDQNicousewt2XtbvWlPkhGUJzCdYstviEaVorPV2+jzMwcUVrrD107mV4Bl2aPV1AFoNlvRRHakUpdccbP1Cxd3udWEWtTDlr7VjPUgO2yDa78NKFxTRujjj3+sdCzzTtxLtoXHZ1viN5XFvyrfm8sRuQ9CcnuJpk4Tee3XzH3EaZ0dqEjPzCBVrxswagnEt36ptS2M05ir0BfllnnU1muqL7t7GfZLHbLnOLwlo
 Ze1Quc5p
 ZyOUxN7YVenZEcdWzjXYp+v74Ulpjdt/vlc+ltT5/1yhzodBiBQ3/+M/ekT42UmLklkARXh1M6709dwZonRfP6vH9svJ276y054mzVR2waC7OjZOoizyNPAaK6MjY/u8jSiVFlR5GmCds+5oz69ydmV+ajyZKOXDHyc9hecyswWgxm4HqgtVMuymNNujuP8ben/Fr2om6/IpjT8dhGDznUP1PBQ3O7j0K3qoyLZjMCqCKwJnwxlV/glCyZVMc7lZcwdn93sLEqfxJZQGJeffc7vKVoOPlhnPZfOrnAG45LyOYnpBKLaQyM+/F1kf+35VrzVLMyU95drvFTtRstONJ6ZznsVHO6s0WETyvqtOD7vuP0RM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On (26/01/08 18:36), zhangdongdong wrote:
[..]
> > I don't know if solving it on zram side alone is possible.  Maybe we
> > can get some help from the block layer: some sort of two-stage bio
> > submission.  First stage: submit chained bio-s, second stage: iterate
> > over all submitted and completed bio-s and decompress the data.  Again,
> > just thinking out loud.
> > 
> 
> Hi Sergey,
> 
> My thinking is largely aligned with yours. I agree that relying on zram
> alone is unlikely to fully solve this problem, especially without going
> back to atomic read/write.
> 
> Our current mitigation approach is to introduce a hook at the swap layer
> and move decompression there. By doing so, decompression happens in a
> fully sleepable context, which avoids the atomic-context constraints
> you outlined. This helps us sidestep the core issue rather than trying
> to force decompression back into zram completion paths.

This approach is limited to swap use-cases only, while zram
is a generic block device: one can mkfs on it and use it as
a normal block device.  So, this is not a complete solution.

[..]

> If I recall correctly, this issue first became noticeable after a block
> layer change was merged; I can try to dig that up and share more details
> later.

Interesting.

