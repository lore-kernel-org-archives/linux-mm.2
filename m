Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E44606A321
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 03:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=BL5h+qaI
Received: by kanga.kvack.org (Postfix)
	id 5D6DD6B05B0; Sun, 25 Oct 2026 23:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 560E56B05B1; Sun, 25 Oct 2026 23:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4284C6B05B2; Sun, 25 Oct 2026 23:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0DB396B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 23:09:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8F6DB1206AD
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 03:09:44 +0000 (UTC)
X-FDA: 85363297488.12.BFF2F97
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id AED8E140006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 03:09:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=BL5h+qaI;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792984182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+4adjsji42YunpnXzr153PsIW3465KG5I6YOnRXsyQ=;
	b=bX7fWUx/QzE9YO+hCQgKGu3bLI0GLUXYOVBVwOWJA3CDR/yOqmOCNjUluJOiKsEnQEvVUM
	uWOfEg//sexT7QuflVazR6fNbdVZejgW9bKBhC+ata66WQuCDz/6DSk5m3Vp4PC5Ht6Fng
	5Frc0iesljPn1HtPGnnow5jhgVpNyA4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=BL5h+qaI;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792984182;
	b=XeY6oX+cL/thx8LQJ0UpQMZC6JOHQnJNuA+wNzxoEyv9/oZ1AslfpMPWuSfe4PnTRpqC6H
	qveKUmpSSkCf2rhLxYxfZQzGA3K4WTgf74zVYPrBsQCcRNtIYQ30xmTFtBRj2/W6nhzbnQ
	VU+BHJA671moHO0XTHOigfjTSHsGFRw=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-3282db206d3so4950443eec.0
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 20:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792984181; x=1793588981; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=z+4adjsji42YunpnXzr153PsIW3465KG5I6YOnRXsyQ=;
        b=BL5h+qaIfffb8YP2qD5s2kTAiW4jzuogJ1W2DEkaOcRd/bKZYQYUmMOShyHnJeXWTM
         F7uE/nm7OJLkDHwldSVty6tEHI5XQfzQsXSQiQTVP/QpMiaEQc8pDQ/RWIwFCo8jJyQy
         Jr+mou23UBDS9sWk3WAxMblrEqsNQkK46MjrM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792984181; x=1793588981;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=z+4adjsji42YunpnXzr153PsIW3465KG5I6YOnRXsyQ=;
        b=2bMohsus+Qhge9E/zYrbQsjysRVP1sIShHeBM/B+xxefw7MVLea2HKl3U9X02VXwNg
         2k39fyZForUJIUEjforNWY/Fc5T+7lAkcCzcQsRsv81F9vzvYnWSDiasIsW83tbsuj/R
         8KZ8RJLXxRlENR5BrbfJjVwGX0J0e9mz4zaV7Gqo+ryaeWDTc9WXWsI7fwYjzQ/1yttY
         GSN83Zn30ct96okCwwld8EwO/1s0VrfpYyyeac3wq/5g1IIhSA2LkTpcxQsiDO5HCLtF
         nH7ldG8H+SbHbKT4XbJKY4bsjhF+jU2y/PwBqUW2XRZcHGeLQjAkT4bs07Mde75TF3Fz
         /7tw==
X-Forwarded-Encrypted: i=1; AKwUvBzh21F4sgbl/SOt1Em9DwOS/hcVvlxt0t/megExP+IKfW4bFRsAGsRFleuyDyfftJzUwDFDkV3dpw==@kvack.org
X-Gm-Message-State: AFq9FYLPejOM+2Kx7zLeSCy6yKq+P0YsED4LkgvD52l9cJ7GMKkQba57
	Jk1CL8TrmUxs/COYbPSd+tFj3qW/0ppcRDcoIJ019kqWhs2JZ1TOSMYZX1qOPHsc/A==
X-Gm-Gg: AYBFou2ElJETMn84vRZQZ1yWPXxwIVs7IrHYOewY7+S8uDDX8BT/ipclmwScEDPNRcv
	ccFrpP+4GJxdBR8zjHgCZQDAwpD/GPMDY69oSYXM+GlBssoVVjwXXw1LfTgKdGslnm9nlF/fTrW
	ahR02zDjpgexDUlJs6CMBaU2T93QYW067IkMO+T2cnbl4ZxeczL6EGva5uV/khD/8FdxVqvS9Ii
	YMT3k1jTx02SWDfq8tUowUxfI98zsaoAdxteBmG95OCg4ue3FiXmD8gNCs4/I9ehnTAqKN7tth8
	FHKU/wJybrn67WBWswWTwE/JffbRC1uCUM0fAUR145ZyKTRQPmrJgf760jbonohtd+gxKuUmyEx
	PcFbOlRXBB+rS2sux+WKMbuQxz13Sb0TAV82/KDYoFxYZvJQsdKOK//tXc0vevHBvQ7g20SjnBF
	vimjbqY5HG7mCOEk1V9l1RH/sjZZ6q+rk44oQpOoGdBsnL1vUqyF5WhTYz+jeUB/h1lua73SAeK
	HvyeesAYq7qvdLCAOnrDjsy1nO/+HmGd5B501eCtRug88JtY84G+0jq/q4EOJR8z3nEZip/GDUw
	MmlUSF/nZM3pfjGMEg==
X-Received: by 2002:a05:7300:3d13:b0:361:39c0:c393 with SMTP id 5a478bee46e88-369e848a6dcmr9746177eec.13.1792984181239;
        Sun, 25 Oct 2026 20:09:41 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:4346:aa6:8d90:326])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369f4164886sm13681062eec.7.2026.10.25.20.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 20:09:40 -0700 (PDT)
Date: Mon, 26 Oct 2026 12:09:32 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Brian Geffon <bgeffon@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, Bo Zhang <zhangbo0325@gmail.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 09/13] zram: split zcomp into separate R/W streams
Message-ID: <at7ECnijIur1XOAG@google.com>
References: <20261021024236.1787884-1-senozhatsky@chromium.org>
 <20261021024236.1787884-10-senozhatsky@chromium.org>
 <CADyq12xeONu-+YRP79KaH4XCsSrNK5DdoKw6T5YSEyW7Acxh7w@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADyq12xeONu-+YRP79KaH4XCsSrNK5DdoKw6T5YSEyW7Acxh7w@mail.gmail.com>
X-Rspamd-Queue-Id: AED8E140006
X-Rspam-User: 
X-Stat-Signature: njjrxf157rkh991nuz5rxxymq7bn67do
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792984182-565488
X-HE-Meta: U2FsdGVkX19icbAG/u3ri7uZW3A/N3HGKUDaR85QZBGsrYSdqqMRTZI5/2Zz29255DafMnXE7bw5+wSlGOwXO8O7RTfY6Vo9F9UklAjjijegLEKSCbja6CxmKbwkLKJgnWrs1gQwrKj2LksB/rbqcPLCum9pPU3JyA6S23d8bInaLqDozUGU7JaJXKGLJBTE0DCEL9xhbEMd/dEEnHMF5ObmMXaJ/1tQFh3PvFyA+UBCV3cpRRxOX2+Aw0NuhpNg4pY67jdJugiF1q0aqdtQWx2qis7SSQWDx7zr8tjPtTUffLhl14Cs2Q+Woks1sMEz6cUo5Dh6NxAGlNlHbFXcOSUie/Gmc82BCsRHapNXMESBAJ5dsDFm8htXfx4HZpg7L3l4zsbzRHVFEZU82xOSESwoqK8LJv6dWKtfBBqxY46mN5UOYRG0IIU2ZANVqJJYP8063lxhlDrHuRbHJDfALoH/Lipqv8fg0UAzL0O7HrKsV6O98BiAnnHjF0+NTo0chsfOwoPURS9aiDZHdISCgqIaQc3W2fpZ1wsTNw/L1W3WtdgB/ePacxSP1aQ+fwJ4W7Ism6Xb8Po2DiFnY+GooER9SmbDVekLvEdVP+OJlW2DUjf4x3zh9Tw25iAaTC4cYHhFAKD5XpF48xzgQb7tmBJu6ziCFP/X1xWHGSe8VwBV02g2GYBgJfmpOg/OmwrWCljYV473MEPIUWTI0Q6Jg0i46c14MCH9hGf06YtD20/aPdV7bINE/LOCUNRD0jqNqkpP+rbXt2paUgg9EFmkaXgBd2ggRf1J8OinH35YWBOYE66rw4zyBd83GXfHD5eBdobjJOTRfzw7+LUif9UCnBvsvCqHVTrJnh82QNWS5DE/Dudgf5lPvo/THpbgdn2fA2I/ABxBCmVTB01389MOiM6UOCshjt+77Q6/7C2bKFVR5n3kIJcamE9opbxSi8K4dgyxshbX+/qXEWQcFS/
 Z+BpBr+h
 zIsvSBAWjXicebnAGCSHPuv9fuyt/GKfsdEJLB26oXtqKbPLTmSgvKvBXETNm1BnkhgQH9EbVKXEElfImsHvA/IJq5ocaEDy267xrJn3A5PXMBlrE1WrfHCirFNAq6xN4pFFpM4ui2Ajn0rmxgfhFbu3G5NIicmDxSceoXG2tMEQt7mtHTT0XdACgpD5o8k3u23FauXKENthE1GhnZhBo6vRfaEailTMsVk7SZX7XHdITMCikDdP6bJLm7FO4G8lgrbHiWuydL7BuDZtrYaJfUcWpXRdd/+SryG9WeoTo/rHeo+pURKDrvVdNAM1rK8SvXPs7y2Tu5lkWGAhyU6ZdFbJ5D46oT5hvUfWCwQq1DNijl7Jr1hcTFn49o3DdyCjPLzERLoq3BPGBoCAeg3Yejg1UJ8RFKpvUhS6Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/10/23 13:05), Brian Geffon wrote:
> On Tue, Oct 20, 2026 at 10:43 PM Sergey Senozhatsky
> <senozhatsky@chromium.org> wrote:
> >
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
> > are other runnable tasks on that CPU.  The good news is that Read and
> > Write contexts are completely independent - compression uses its own
> > scratch buffer that decompression never touches, and decompression
> > uses its own local buffer (for spanning zsmalloc objects) that
> > compression never touches, so the Read/Write context split doesn't
> > noticeably increase memory usage.  In addition many S/W backends have
> > stateless decompression contexts.
> >
> > A quick synthetic fio test for Writer vs Reader inversion on 24 CPUs
> > (preempt=full, zstd, 48 low priority (nice 19) writers, 24 normal
> > priority (nice 0) CPU hogs and 24 high priority (nice -19) readers):
> >
> >   Metric           Base               Patched
> >   ----------------------------------------------------------
> >   Read IOPS        207k               1,150k        (+5.6x)
> >   Read clat avg    101.50 us          7.76 us       (-13.1x)
> >   Read clat stdev  5,615.90 us        30.78 us      (-182x)
> >   Read clat p99.99 258,998 us         111.10 us     (-2331x)
> >   Read clat max    1,342,600 us       11,217 us     (-120x)
> 
> These results are awesome and thanks for exploring other options. I
> agree this sounds like a great path forward.
> 
> >
> > Suggested-by: Barry Song <baohua@kernel.org>
> > Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> 
> Acked-by: Brian Geffon <bgeffon@google.com>

Thank you, sir!

