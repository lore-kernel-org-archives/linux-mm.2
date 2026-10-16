Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 104DFCCA463
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 03:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 082706B00A2; Thu, 15 Oct 2026 23:13:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0339F6B00A3; Thu, 15 Oct 2026 23:13:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8C676B00A4; Thu, 15 Oct 2026 23:13:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C86A16B00A2
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:13:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B056AC0298
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:13:47 +0000 (UTC)
X-FDA: 85327019694.13.AA255B8
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id C2C41180003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:13:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="lvbfJSl/";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792120425;
	b=GpsQ4sBjq46L7qtry8F4ocLZ3Zg9iNoG+Z5xIZiCm4imCxKOtZKbzPkSIhTRHcQ2RHqGV8
	yg49lriBtDGImU+JSojgMM1v0lUaLBE1HTK9kt1c2jufIeVn4RRaW+UphDQDW5uiHav1h/
	OgwX/r2tAghXNV4MSGCzQiORSCWa8b0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="lvbfJSl/";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792120425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kncXSXLqdZsNjreOv88DLkZuZB0aSQpv0A/ER6BF3zo=;
	b=38SoIR15XpxjyDi5RiLHBVgCuSmfD5v59j0+CYGKXiU2TPraxzL0YW9QHKUFzb2gC9BtDj
	AKTcbB9OgRZ95f49pK/SBXpv1e15GPudfap01EpBKkVqmBsv07Sg3wm8UFmO/J/02bbFpo
	xT67zWS3Uj0VRF2P/6kTYP60n/kT3HA=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-881269371acso319456b3a.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792120424; x=1792725224; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kncXSXLqdZsNjreOv88DLkZuZB0aSQpv0A/ER6BF3zo=;
        b=lvbfJSl/TTMKC+a2ySvBsKsGka2DeLtbJUI96owNb0hpQ0pCm8uToeV7WcI6ah76+u
         2WNeT+6kP/RlwEuxKsKqDnuMA5PE9LBTJSnK85SZJSw0vW7JylpPM4/VMYdYoWByxD3E
         dz0khWBGwJhWG/lo9ZeFTqZyu0/7KbCNMJ8Vs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792120424; x=1792725224;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kncXSXLqdZsNjreOv88DLkZuZB0aSQpv0A/ER6BF3zo=;
        b=hF1nMuRmNaXz6jG54tTlCblNFQJ/hKHgcXdIDWc9dKwCAI+mlDwMirsjj+RZ71lXoP
         /Z4m2SdtVF4GA3MP12m6Ibk1sTBltrZdFqxS1PigGYdppLSAcDu/88mxbN0QWZv1oXGr
         PmLi5g8A6YXVsBCxXmJONT4TF3Pa+gnUV3fTdC4WcLANCTlQeXCC8dVKj3oX7i/pGGA/
         sKb5Gw7R/sbKAw6GwO148uAx8Qi28xeECRHH8flrvzoQhq8WbYvDvalVJRZTxFE3HSh9
         98mAKkDsNnDUEBg/bQ3BzIEvs+RVQk2HJ8TsX4d7WPc9wQEdPDUU93HBZRIOcI0ktHGL
         19OQ==
X-Forwarded-Encrypted: i=1; AKwUvBxAgWW+c9FOB7N1MYex5DggjMFdoFAvubbmi6o8+M+0v1yfdKD3Hg3wlYmB49eGJBs8kzZVFQG8wA==@kvack.org
X-Gm-Message-State: AFq9FYID2+x1nHDV9Ewieu8iSmqjS867CI5Ms0w+exHnFIGLagigXqf+
	Rea4x2CwtzRGqKXbYwiLiF8hRg07wDzDyylJpNagolkh1xh/qydh6Ddr5D+Am+5rSg==
X-Gm-Gg: AYBFou37Ukcw+cLAUNZ83jxzs4R0uvnwVw9IIQextBwFyD7W1lYd9lWiM/CLNNEhNIG
	IU21zfP5e4iBSgkWOGrlo0wMSqZFJbYbQ+mcsvXT9eU8Q4U2ItFRb0b/xc4h3PCoIgVVg8FfHVp
	VxmNN9jG73uFctnUhv81XaKBP3z3r7buP2vSC573L0AgULePHXj/a8I7cAK54H47MKDR6e2V3YK
	O1a6yu6vJVmmKqkHmhqoYzjCTCpdbwOkC2RRIUWT4LcbY2+RPQ3rJbJDzvUzRaoAHDBKj85XHhS
	F4/iBX0hnzDIeNlCNJluFhWgDn/s5+X9iyItkRqBVsI8wP4YLjzfuPrPDs0EUN4XhMp0T040LTk
	j08VDu+IJDbz/lUPK0+rxQJ2AT1/pobudcf5TOQ2yCrJhC8dJsoDbegjTtn5rvsV7CBUs6Fm+Kr
	VAwzRz8kq6eyN9Tp++myx4FI50lyVog+Q+a0lXjCIBQWYRHWOKJGyj62HbyjE+cxaCfmaTwaXg/
	1wm60N1eWLJjJ0wPy4LGzpb5Kf0Jjy3IeskajrqoTAzyss4NKKyDZkTcu1D21BaSMxjJk8YGViP
	sBXP1qfwO4LZRAepNWmw
X-Received: by 2002:a05:6a20:3d19:b0:3e0:da23:8743 with SMTP id adf61e73a8af0-3e201efbf5dmr1523172637.23.1792120424479;
        Thu, 15 Oct 2026 20:13:44 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:a579:8b87:8304:7ac2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f54b2eec9sm406056b3a.8.2026.10.15.20.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:13:42 -0700 (PDT)
Date: Fri, 16 Oct 2026 12:13:39 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Barry Song <baohua@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Bo Zhang <zhangbo0325@gmail.com>, akpm@linux-foundation.org, bgeffon@google.com, 
	minchan@kernel.org, richardycc@google.com, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 10/11] zram: use rw_semaphore for decompression streams
Message-ID: <atGWIBSUdnwJ4sTX@google.com>
References: <atBh9xfpOji_A7A_@google.com>
 <20261015112440.1491168-1-zhangbo56@xiaomi.com>
 <atGPwJL6XzlRaMva@google.com>
 <CAGsJ_4weqqSGH2JCh5EThtU8N3e96kRnhLtd9Fotia1t+7YqxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4weqqSGH2JCh5EThtU8N3e96kRnhLtd9Fotia1t+7YqxQ@mail.gmail.com>
X-Stat-Signature: 8ieoffcfngqdeyftbb4199eddmb56zps
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C2C41180003
X-HE-Tag: 1792120425-413994
X-HE-Meta: U2FsdGVkX18vw7jSWHsdULZATPxunzqi9sphy3h3a1UTYLKa3EozffVqBcyJW7VrSUmBIgaouP6wsV/BaBHwu8wKiqDLKLdoc/g5HnV2bsRoQcns+OQrX9zM1QzvvCv65O89xyJ8ECoV7cq932ic4tllKr16h5WhVtaYpcYerRuGrmYdcpnsrh4bKBylYQe8lEowMyCxKMn2ttkg72gEkmIEnomAUawbQkF8CRGUYP27Y4aIFOCgV+JFQXSGcEifZwEZhzys9Uj5VuhxUhdZx56RJm7z20ZSGKH50/ThKldpbJR2oJOIcGSCjAnEtNfJ9QLnNDNIHvACzwoKS1Bbsf4pOYjWz9tdY0ObJs4C6EaTJ3WD9fGT4Xo70NbpVsBkx4gS0M76/n3m6UU+z4LBBFOmqDeKwlyzzmyQzhk64/uCbKroq6mNrUeUeVRVvrloyj8Bf3VCyYBiNYeNw3zNk5N+U4+lp+Vf7a9osUwz4ic0SZI6jI9c3b/2SkqH4rj80vWA0uUN8kNwuCdRv3hDTNcN+LLPGWS85Q7v+31Ia6CHaqVPyzuH5Yu7WsE98dDnDJHq36BSQ2bileDqFEQABFRa7+DWJ8SW3mMZgG6kGS5lDDfu5koQfXKjr6cDSwJBrbATgr5s5txI7uJ2IYBBrIdNUePtliGrLiUjBQlbM3UGp+z9M0CjFpwSY02fCoy+6C6O4BZ+ntcZ+gY9igzLe/P0LzJkyXciaqIr8YLMPhQG+3evmM3QS1QTuiDGZ29R9uWj9VPYSjCZeC7aS9fHDsTw1OdqdLXavb6s9zczU69GfUieR5uFrY8MoWjD9ZipiMmEs+RkPiYueMWjEWH/TVQtQGgD61geOXow35PgU/+KfLAdXoFiqRTEfM7IjA/iyZpsQ3bJiTFD/DqVxDnYvUX/UYtKRoUcBB964+9hdR9SD9lu0bVyLnPYZ3Jnkxzfm7GMY5cCWWxwNIFP8em
 QueVHDGK
 1FAtmtMycEUuRHz2jdgSqwNA+ls3SJhgLrSUmZY8UhRSOaWfYgmPlL5Q+pyf2v6ggKN1zkKMyTSNDZRPmbwTiAcxY1LHffZtLZqAwE9O5TGGeJwZQn/pfuzMffnu8Ly7JI1RefBuktFvvDOBMso/FTnvM8S3AlNSw3703j3GLtr7k07rd4081928pyJXAEHjecXwarPpQ0RchSnT06REC6Y0V36FwyGFZMpJCwdEif9OOi6TyivMX1lpBoa3hy8FxkKnag4bxyODjU8Q9EiP+iPvfhSGjFalkLj0wmCmiKSpnqxHhcFQGqTYP5KdWP+fzDXeIV1FtAPXEb/ajPL6eDgINaz4zzQfMnK/NNEarRCNmPhyiytDCs5X2AjtJyLnh2c/MczDTf1eA+GxiklFtv5wavTDYae3ntoQGudsJbmoH/tQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On (26/10/16 11:10), Barry Song wrote:
> > > I applied the kmalloc+memcpy variant on-device and re-ran the same
> > > Android A/B. It removes the exclusive path entirely in our workload.
> > >
> > >                       9+10       9+10 + kmalloc fastpath
> > >   read contended      ~1,959     0
> > >   read wait_ns total  ~12 s      0
> > >   read wait_ns max    72-96 ms   0
> > >   shared              76.7%      100%
> > >   exclusive           23.3%      0%
> > >   dpin_contended      0          0
> > >
> > > Every decompression now takes the shared (down_read) path, including the
> > > cross-page objects that previously had to go exclusive. The ~1,959
> > > residual contentions on the exclusive path are gone, and pin contention
> > > stays at zero, so the full read side runs concurrently with no stream
> > > contention.
> > >
> > > Read-side contention end to end:
> > >
> > >                  baseline   9+10      9+10 + kmalloc
> > >   read contended 24,749     ~1,959    0
> > >   shared         0%         76.7%     100%
> >
> > Thank you.  I'll include kmalloc patch to v4 of the series.
> 
> Hi Sergey, Bo,
> 
> I assume when Sergey sent v4, could tag for the patchset with
> 
> Tested-by: Bo Zhang <zhangbo56@xiaomi.com>

That would be great.

> also, Bo's data can be put in cover-letter?

Sure, I can include it, along with my numbers.

