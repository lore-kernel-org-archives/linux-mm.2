Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F007F433C7
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 04:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E8A16B0005; Thu, 16 Apr 2026 00:50:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9721B6B0089; Thu, 16 Apr 2026 00:50:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 839226B008A; Thu, 16 Apr 2026 00:50:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6F14E6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 00:50:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 283FFBAB50
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:50:02 +0000 (UTC)
X-FDA: 84663191844.09.CBC180B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4AF1B160008
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:50:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AOsPsGfG;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776315000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ivnbKdVLI/vynoab1ZSQFr0Gswa/T+oQnjFjirTcHCA=;
	b=ez7WcvgjUOQRqpVHbgN2wqlU+7osZamya9LQFHAgfvXKhifhdkDeeQXVormcmvPcsknN/0
	Q44VfreTqXZDswAbGulIUAvPVE8icJme2KSc6iurk2tE3p++LtfPtpJE7DWJbngc+QQeHX
	QpKgHefiDzLSytirP4dxBkgZcdV/u78=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AOsPsGfG;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776315000; a=rsa-sha256;
	cv=none;
	b=p17yr4Un5RikVnuhc0ygRnyCRbVmAwGmleuQbp5/I58+GaByNEt7f6fVbyuVtCHlmm4p1U
	ntkgUVVIMDSjMLB3zT7Rvy5SAGWID5JalZyrZ1p1G2wBUs+25XKccNtbeCK2BF0OO18pMz
	AQKCa1A+dx3RXpxKH1IzBGoEGLPPEOE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7295660127
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A281C2BCC6
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776314999;
	bh=ivnbKdVLI/vynoab1ZSQFr0Gswa/T+oQnjFjirTcHCA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=AOsPsGfGw8osjtrrbdhRqrEuXpOgbbztCTz9zNhs2aoPGS6oJyvR8V0Wc5AhYrhT3
	 XthasEws2muOlM2aWausjYI0oeID9TnkaoOWrmx14mKnt+pa1muMpUKtf+KOAIGrxa
	 3UlpZZlLqtglSYDo9zYGB3H0Tg5OtElC1ge3VQ/xPmzFoSi5a1xz0V6QGJub6iaFeC
	 rSdjvSp+YOz9Xl7gfy8fFAbgauw3ouDUqyj1lYl8Ofe2xhHhG64kwov/2H7m5pdpYj
	 TAGyYdZD+9do8PvZ9jQ+zrMlQ4wdYt/k8kiNPSdSSDCgsybeYxl/DT4SXtrC3MFO0M
	 i27m7ZLMTUoSw==
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8aca6bd57cfso51622196d6.0
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 21:49:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+eKKFsJ3r9sPrWO5VCFhtQ0QgLEBK+8/8/EipQy7lf6K7D6NnSXxnsQYgV6eg9A4PlNOsjcC064Q==@kvack.org
X-Gm-Message-State: AOJu0YwpDKHYvU3VT1pRtAXlxBvGeWPROs79Jva83SKiysuaMyT0xr8R
	9ud7aLcIBMJvVhNYQZ1q0dNeA/jDOlu1+mI5F1+YWr27MqRpIxE8I17fR2UwSGWrQjSFCRiPtd7
	DbwcaYiVCNW+XKaIISnwyw+uov9YX780=
X-Received: by 2002:a05:6214:258f:b0:899:fd8c:55c3 with SMTP id
 6a1803df08f44-8ac861b7754mr371308066d6.22.1776314998341; Wed, 15 Apr 2026
 21:49:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260416024248.687943-1-gxxa03070307@gmail.com>
In-Reply-To: <20260416024248.687943-1-gxxa03070307@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 16 Apr 2026 12:49:46 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y+6W3v+9cvNzZT68pCwPdk-4sWQT=XJLXCrvDOSiN6uA@mail.gmail.com>
X-Gm-Features: AQROBzD3V4-ve4yujHHvY8l-6AxMl91V_sgYK1Gc9_6Tc2iM28a3MXZDD9feyf8
Message-ID: <CAGsJ_4y+6W3v+9cvNzZT68pCwPdk-4sWQT=XJLXCrvDOSiN6uA@mail.gmail.com>
Subject: Re: [PATCH] mm/vmscan: fix typos in comments
To: Xiang Gao <gxxa03070307@gmail.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com, 
	hannes@cmpxchg.org, weixugc@google.com, david@kernel.org, mhocko@kernel.org, 
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, ljs@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Xiang Gao <gaoxiang17@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4AF1B160008
X-Stat-Signature: wwiwmk1y18b7aai13aefu8b8wzsfbtd6
X-Rspam-User: 
X-HE-Tag: 1776315000-184099
X-HE-Meta: U2FsdGVkX1/6pJgJunux0NdEpsMxFc78J2tBIT1MWu7m3XTZ6qA2iPKfY8wORA+AysKdiQ/rlzkNFMAXoZAOPymzyLGAXZ+y1KuJKhyljvpu3hI2S7Fq2vse0JXvpJFE6QnSgDZHZl1fsESL/QjqRPkSWk/KokjXtNvj4hIbBYdt2N2fra0ZEjQ4xLJvi+FbsnclNy0CE9yWTYwksbbRKYE47iwgySiW2ouxJTDx3YZYyltEjUTUfTE471xtmGoJ9SHcchmaByzU2QzziJ9Wn60YjCt9mk9Gofo1GoyT1eYbKPQOw8+tEG1KSRZ3AbXewEJLH1rHEWPxhQGQQYhg8GMq98pevnrcaiW+T41nfwHgd79W1E+tNFCsETJ0QNEtfJjs/N4qe/gv/yg595n1qx+R5odG21kst9U9UUOlMdKdHM+57ktAedFRdBEh2CXZL8+2W9LTytTuHgR8slpIi5I/wJ7fKDL0zdpT26tvdvLXQ1mBCPotWIUfktEbXYp8+E/STwtc60BoaIgLeS+ycDzwp58/y2l2F7WuVAtUz4FWbfD94bXZnXRNLeyS1U41hOlmses0wuQHgApKKsJqgT6eRsxTU+ZOiuPYf85p5TMESZRkh1HpdskuxRHD68cr6ATbp/TOlIDdbXtsnTxlDVxoQP2Po+3KGaHOooZVVelhX9ZcI4pBNC8tbKbJMkN6ZOeq6e9ZghtBiIfJ99dlpV6isLPlSbmLqIwC0USsCMhDRTeimQKSM9XJb6tIFFxmToNEq5dAjCLXV9FjlWX/J+q8lV//51kMOKV50UaKANIEIcZE6+uf/zJ7sdRznV77iz33k1K/ntEeCpBI37xNSa1U0jTnZlk6MNYcBrSFAm+mJT5/Wc0kPZ6YAIjszgjxDfxW6M2AyreBRcaHKGOA+WVmCmUBmM/gP3DO87T5vA5TA4BNSLUMP0D+pkIkfb9IipUtI/8xPZIcA50tu+O
 3UBa7X4G
 baSI1krUzBP0t9jx/Qeo82gs2XMLPiMmvveHXf+DabYObMY2FllfX0QlsDXiZO0ANIsYBZMGBsljfsVohl+RNsvZVM2XIkUQ5lsdFwb5eo164t/YgsNrlGKhqb4mhaoNjGCS7zJ2hddV3StY2tS8zdV7fPxP56c5C2brg2BTRHKYb6J8YezRNaAXEhktoV5YEX2Am3RaRWKT9gW3IoxlTpREy88eHkpf7QS014ICBb64AkGR/+n42H3ji8AKz9nX0uv6GlWXzyJ+xc/vUkHVDloHh1i4s4JpQcn4q5x697dCHwi55rwXQKr3HHJ3NB9z4i2HRNPj9P3uoeJBXPdz++gYh5uMxoqBMOxXq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 10:43=E2=80=AFAM Xiang Gao <gxxa03070307@gmail.com>=
 wrote:
>
> From: Xiang Gao <gaoxiang17@xiaomi.com>
>
> Fix three typos in comments:
>
> - Line 112: "zome_reclaim_mode" -> "zone_reclaim_mode"
> - Line 6208: "prioities" -> "priorities"
> - Line 7067: "that that high" -> "that the high" (duplicated word)
>
> Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>

Should be:
Signed-off-by: Xiang Gao <gaoxiang17@xiaomi.com>

Otherwise,

Reviewed-by: Barry Song <baohua@kernel.org>

