Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BA2DD277D0
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 04:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0C236B00B4; Fri,  9 Jan 2026 23:04:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB94D6B00B5; Fri,  9 Jan 2026 23:04:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9A326B00B6; Fri,  9 Jan 2026 23:04:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A77276B00B4
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:04:00 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60BF7140139
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:04:00 +0000 (UTC)
X-FDA: 84314711040.30.52EA50B
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id 83143A000D
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:03:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iGYWtQJX;
	spf=pass (imf15.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768017838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WZauXH+MPa+G5mIjej9+lL+y3hp8looiMpGaZ3G0SjY=;
	b=NnZhPQgSyUuJpMi+jtR3PPkU1xzI7VHyCRiHdBLjS/AM9WQT/zrNw7wF5oXdN4UQ4fVPIN
	0scEO95zGUgb3H0YbLVfJRzyqKht7PDOhHnRUCPUkcBP+4Va8oW/eW7OZ2WiBmyZMmL2JY
	ZCmDEMwSXC7pZuIeMKXYCySJKCwoum0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iGYWtQJX;
	spf=pass (imf15.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768017838; a=rsa-sha256;
	cv=none;
	b=TpZF0k/n3ooXNyDq/xezJmopYvl7jAkaNFCmZOWJp3m3j2ZDH44WBCHpJRmfDdXrOHM/iK
	qBcE/UeZwwXfD2vp8/hqliZIfiwNzVU/usxa66jjKONofikebrEqeFUkKEa/la6cNerw0t
	MVJbDGCEPbgXzDXBcTbPZDnI1pKR6RE=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8b31a665ba5so584978185a.2
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 20:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768017837; x=1768622637; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WZauXH+MPa+G5mIjej9+lL+y3hp8looiMpGaZ3G0SjY=;
        b=iGYWtQJXxQ9avkmo7OHUUixH57/up611rV/1OMBWGIgCPVihYlGWwUm1XuIvuGwphX
         St+9cuxnkx1FLN8c3cUf6++xAfncbAN9cJhW5c+Y1tfhaUnBNG0Y1SNWlbmOinrTpZU6
         m2ib74iAxYdcVpucGoG9unCjOj3JLnzOlGnT+GIdFHRSFm3+ye/k9c8RPLCeOxvSdf2w
         FgibG2+E53MkpuxuWTU6hV1F6lHIXBEiS4jVwDDhFGpQBN1bN6DML0QgJtbbdPQ4Dp6Q
         XeBJjOHn8qAjNG5lLCiXRZxTKRkDA7Hi/AjFvU9WJAkse5PbLPKc+fl582mRo1GlhVRa
         TR1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768017837; x=1768622637;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WZauXH+MPa+G5mIjej9+lL+y3hp8looiMpGaZ3G0SjY=;
        b=HU8LlFSCDVaPaECoZTUxHHheJiL23E+WFFt80yDKDNEPiRExMiFZHFahSI7nGfahA3
         U06y2r6E+0Y+LBAtyUjWONLOl15J9/YChxasM7y8w06Oe6I+fQSB073Aj1Ek9G+DUhzK
         Xv18McR7c/s9JdVC8QQDFhDOB9Zif6hl4CRm0g8G3ohwH4w4x91fNR4yPnSJwEwial5v
         bA5GwyJzDJr273NjpS8kQvyjNqLPnpCFL8lvyuFwqj5mTOZ1wohq4ySbkehRXc7VpWjE
         rHDs9VCvaCAx/qyYrBr4HjBwD2fn/Cxwy7eST6Hit7U/uBYnDYeZJ8a70vSpJG3HqRCU
         pXjg==
X-Forwarded-Encrypted: i=1; AJvYcCUUc3349JjALW/n7PjGEDLktBzTDp/R4BNkij2vpLNbA7wseA95yBka0cFM60AQne8xVU8RRrlCaw==@kvack.org
X-Gm-Message-State: AOJu0YwGED0RnvjNouKGKpFJxveV77/zsdXKBOJ2NPWIIPxQeUsi0XMN
	ympEpTAt8qHxBnPy9XweJlSJ799KgV2AMxQHhW2um5AUXBN8iYpzi2wpMZl9GRIcXGvPn+CeOt4
	bqbVC6lEV/cI8wB9uuDV7YwXKZkk2fww=
X-Gm-Gg: AY/fxX7F4268DOct1ZCZmUnvzlURq5bqACOcM4u/yF0q0g3aCfn/qeJyVlKhdqh/PTi
	nJONPwcayb3+AyRgzjFK6vX9/PiSfRIxqYo5rOBNykkenTFahJZe0/cC+nfyPDyeURmeBdJjwfH
	vVNE+jqfJ10DF3P2agdI+waIvyxljAb3AxBapeXG2IxSL+zGvBpECIYywRN3yAPTzmCW0PKfLKL
	f3xcfRM5Zrm1TlA9tNZd4/Tvpi1HzVOJV4UDdXW8N67g1IRrsF4LaHaEb5vtVmygG3kW0BnXXg2
	qBD+IQ+z7fqkgLlZR+qcz+8=
X-Google-Smtp-Source: AGHT+IGkoL2AF8SQKFOHJCmnDdpS23VSI9v0VXX4sG8uoPW2wp+fzBtIvWSsAOWNdGOX02I4Xj+89b2hG49Vj20t4K8=
X-Received: by 2002:a05:620a:4444:b0:8b2:e177:fb17 with SMTP id
 af79cd13be357-8c3893dca80mr1563823485a.45.1768017837553; Fri, 09 Jan 2026
 20:03:57 -0800 (PST)
MIME-Version: 1.0
References: <20260108101535.50696-1-akinobu.mita@gmail.com>
 <20260108101535.50696-2-akinobu.mita@gmail.com> <cb77c9eb-6dab-4147-a0bb-ce488524beb2@oss.qualcomm.com>
In-Reply-To: <cb77c9eb-6dab-4147-a0bb-ce488524beb2@oss.qualcomm.com>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Sat, 10 Jan 2026 13:03:46 +0900
X-Gm-Features: AZwV_QhMXanhtxvUY1a9f2Zu9D6Y77eXyKKzmP_0rDRPiP7b2vD0NAhLFhC1j3w
Message-ID: <CAC5umyhC_zN4jFTTfz0DiJuZAd_8eC=E_a+aPiBVXDPhGToa3w@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm: memory-tiers, numa_emu: enable to create
 memory tiers using fake numa nodes
To: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, bingjiao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 83143A000D
X-Stat-Signature: j78niyecq3itpkfk68q71dw3ob1w7nj4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768017838-312364
X-HE-Meta: U2FsdGVkX1/lK+RsY9G+4Tbzic+EqxmVo9bEIOr1l54XJS+CwFv91nUf6aKs9GVf2pINXWG0T/sZK9yne2UUCmInYc/TcxdW9lSVfMz7l9asyyseRLBe51fGYqqSDgMfgYKuyN/rxqP/csKN9TvLp3xUZwy7hYug3kdrPqhcAjLDo1NglUyOSi8D0HvtRuGhWKpBQPpaxOLvs+GQHhAiPDKfNKIZoNcu+Y/OJiwGlaaq3qu9nvZ8mUwvlgITO/E6kAyKGMlH1BG4pRSRcxi6P4k+isRGfnGCBpjc91yxPRoxgHwzOgyojwQWlSpHVCUx7iJe8kJHUHsuxoWIIu1jPQ07TCCIVgiq67JQ8wLD/bEOtrBnQGhPX2Q3XBtxp3PTl94dLE7Tc2+4sqjF9w6zX8nPrMtvfbHvkYx7ueELdpVCa3M0lW4kcpAOLYFT/JNfKxfbd2Sn4f8IgzXcVCtP8QLoYGsO+khmbiRvttH91V8I2n+h9avrbg5gVCCmepmtLwS5CFf7ThTEUHNxynIil8ygfPXyzHZfH8I7HDvICUr+OPIHPiewHMuzqjQYk0kqfus1y4UnQeQW3OkeK5vWSXI1DMEltSy/17sRXoo6SwFgjfKBRY/B/XsZV1GM16cmMrZ4/Av7aKucHs4QrUrd7br2AQhM7KmjRU+b//AVAl5W9R81O+HPJEsigPvCQ2WCleNIHdcoUdYUp/4bmGaEIgwQB93jeld5VbPrg4/EZqkq1TtuZAA+j/47tuYGAkH/ZF1pDldGorMKLYREEiaPxNQ3R8oI3WFFChXb6AHLIgDr8vtS1LQg9lpb7D9zuthNu9kMDPNE392mtwVPPTbjPdS0siMz3lVGuh2IWuy2mCm8h13Eor9wxDIRW4V9NVSHAbH1hWUxqz1JOlY+iqp+guh+vHKD55pgXCqL4chfzNnIJHjh9kB0sBVzYn+ZY/x+51GqPzeIhlTjdr18LZX
 qlZ11ITL
 x2JU5fCv724cc+n/tIReQta9E1BZQhYO3NvBuEQna5rI1Q8yI1EUhde+YihViDRf5pQXXb/TjVE0kKXGfT01aXXCXRzj8Ef17fAznFdX+E7dVo0VN342qgqSgWoPyMAcXtk3ETFDsD4GqU/riZlfU/1aXihfUK2WmNyeqszYq80w0B2xLO4WLYj0J0qR1eGWi/pzg20Mhv6siX5nr9VNAxS9JuR9kncx8cYZtC4zqEJdosjNiaNwdurxWzm9m/fUSGbXN9CQgdH3D5ydQYs7I4qkFR00QSM/v9kJclpwKTQnUZJYGYs89Haq7KqQKXduD4Ep23AE618fGVU5KgjS90Qc/xfyHKydcJILqFqA2rcxAgwJCTT+yjNxu4HnnSBsbHT9PO5N9Olu1aVdZr5q1efxGAs/B/imObvIkAdnzgVLJbOeUPOQU2BXW5JdADBYvEhzPlvEtLqZRhJg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=E5=B9=B41=E6=9C=889=E6=97=A5(=E9=87=91) 13:44 Pratyush Brahma <pratyus=
h.brahma@oss.qualcomm.com>:
>
>
> On 1/8/2026 3:45 PM, Akinobu Mita wrote:
> > This makes it possible to create memory tiers using fake numa nodes
> > generated by numa emulation.
> >
> > The "numa_emulation.adistance=3D" kernel cmdline option allows you to s=
et
> > the abstract distance for each NUMA node.
> >
> > For example, you can create two fake nodes, each in a different memory
> > tier by booting with "numa=3Dfake=3D2 numa_emulation.adistance=3D576,70=
4".
> > Here, the abstract distances of node0 and node1 are set to 576 and 706,
> You mention 704 in the cmdline but then mention 706 in the following text=
.

Thanks for pointing that out. It was an obvious typo.

> Please correct the typo. Btw I am not entirely sure if this example is
> required
> in the commit text here. The Documentation seems to the right place for
> this.

This example is also included in the next 2/3 documentation patch.
The same typo exists there, so I'll fix it.

