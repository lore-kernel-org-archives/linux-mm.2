Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71B2ECFD30D
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 23:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88DB26B009D; Sat, 22 Nov 2025 18:49:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83E5E6B00A6; Sat, 22 Nov 2025 18:49:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7066C6B00A7; Sat, 22 Nov 2025 18:49:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F32C6B009D
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 18:49:26 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2356B4F347
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 23:49:26 +0000 (UTC)
X-FDA: 84139887132.12.9A82D82
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3A97210000C
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 23:49:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=f2bIzybh;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763855364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UW+eRDPoYF+KU6Xqx6zCWEO1tEVVIaZy0NmGDfMcUDM=;
	b=HNLT1AI+oFf7PjYuaGmwpLnJbJi43n0/6ci8MGsoT2YNJCpumaLTqS7OEQ9buQrWlKTZvN
	JSblPhRjLIzF7bG5W7OnPBgmlcEuI/TSSvlYlKeTmle6qo04/CTUASxL7OpAIOzwveSltl
	L+uWnCYYmyM9Xsc4EwoIBjO8x7oe7rY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763855364; a=rsa-sha256;
	cv=none;
	b=pePRiu/xQOdDYkiI2Wn7HCw5LAFy6heAhnOGsjj2Ljsf2cBC465k7mY2wtRnOZlzr5Mv4+
	rPPy+8Fri+0nezAG8n9g7MRJsLR9PPC0ZSSvsHa0UNwJjEsHg2/3usWlqkNbOusKxvW8dY
	H8jomjuLB6AGRiVJa0egxOJ4v9CVExk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=f2bIzybh;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2958db8ae4fso31420275ad.2
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 15:49:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763855363; x=1764460163; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UW+eRDPoYF+KU6Xqx6zCWEO1tEVVIaZy0NmGDfMcUDM=;
        b=f2bIzybhA0Fb3Wi1PRZEDbmSRFiGvnJvJ4hz5YLGUtgCuB0UU7+6c9Z1X3yDRVMyyg
         p3rSr3svkAUX7cnKNSjoxqCFyoTBwDrK8a3SAwAp3xdGNSQvY6VZPxqhaamexsUg9Wj8
         kL8EhlIhWISMDDEghrPahUKfdgNu1RpUPpmz0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763855363; x=1764460163;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UW+eRDPoYF+KU6Xqx6zCWEO1tEVVIaZy0NmGDfMcUDM=;
        b=lQ65E3hH25Fipoycl5b0GeFl3CU51Wa7m2aLm7hZvPgkylEfycyRFer0stFoQhUo//
         AYXHhj2c0SJE+QmUdqwFtkTkcuWP+5Xyddirtf7ON9pBL38JBsJbVdrtk5M+Ene09kQo
         JMqqmxP6XHx+WOR1Z/Egib9vsE80G1m2KzuQVfEbS/WhciPgygFo/yxbkr9RGkugx+hi
         LjHElNXs5/zyxizJJIV7X1qqYzYQHXXRalUQCu7yGyg0TXIV84YhpRsp6sX2P8bqfc0O
         iOZu9b/L+golOj1WR7p3PN4mmRWeH1mWXS0rHxR7xCfBrvrW1YZIgFYmAOdmAxmOufsV
         hR3w==
X-Forwarded-Encrypted: i=1; AJvYcCULDGCIHG/OCUJiaWtTT0nx/3GHAH2w3YOLGEH8uw3GlKkgfI0kBZs8m92UNfbwy4bdN13VhgkxBQ==@kvack.org
X-Gm-Message-State: AOJu0YxqFTvbc6u0I1HYGWi8Rs2W9obkv6lgICBn5IEUSfirzLHvSugz
	OpsKhANHovTKaTx0/eLZ9WkenPjy3aU/QuRJTxFx7ZBD15eAVJgGV7TXwNspEKw51A==
X-Gm-Gg: ASbGncsGbQVDCneT/ErdoWMqL/DO5IM/Eg6jsupBk7Iw23RhRCGPS491BO2ScCqNBml
	GfL+g5NBGSiU/yHQrs7y2m6Nb02Z8MFxoBoEIF3tQpsMJk9JmTJlbA0tkeRk2jzp76L9wIXWfG4
	mRTsBWP4JT2OUkaujoQI9l3NyaoZoM9AXhOhp6QMBYghxgTPpmU/QIL2EXFcw+QqWSYJMcN1gLX
	uVlBlBqLtn2ZWHv3fyal5bb4PxzoWOmiAmDz/Hb7oSyUGA//2awuZqrLmjSW9Q80RhopJFRZwRE
	9tZe1zjOuFMZB8OnoHyAebBZdjWxm4l7tnku/Gj7NKHGzWrr1KqCUijkqeAq8hYiUIhhkyg7oq6
	Mpktr1FPQHi4oPqvotF8BKu4/Tch1t9pjnh2/USJherpf8bwQOwHVbGoGL927biCoVP09MIkCXl
	hcebhgsXRAw+wGgOIr8e+bs1ZkLssol1zSfDT6cSoqQg0SVsfqsg==
X-Google-Smtp-Source: AGHT+IH4jcS+xtBExdkrUh/PqxDOHrrG0hrcKbrp/NkX8lIW/tOBtidSFRn6HKRqk6RmeBK/ozSTYg==
X-Received: by 2002:a17:903:40ca:b0:299:dd98:fac2 with SMTP id d9443c01a7336-29b6c6b2646mr95443735ad.54.1763855362961;
        Sat, 22 Nov 2025 15:49:22 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:296e:57d:751e:5598])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b25c20dsm94265595ad.59.2025.11.22.15.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 15:49:22 -0800 (PST)
Date: Sun, 23 Nov 2025 08:49:17 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Minchan Kim <minchan@kernel.org>, Yuwen Chen <ywen.chen@foxmail.com>, 
	Richard Chang <richardycc@google.com>, Brian Geffon <bgeffon@google.com>, 
	Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org
Subject: Re: [PATCHv6 0/6] zram: introduce writeback bio batching
Message-ID: <wdju2lsmlwvz7oqaku5xe6gl22t3pdbgcpgkdcxxeqavwxgc7o@4bmil6a3zsgp>
References: <20251122074029.3948921-1-senozhatsky@chromium.org>
 <20251122135406.dd38efa8bad778bce0daa046@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122135406.dd38efa8bad778bce0daa046@linux-foundation.org>
X-Stat-Signature: a3wxoj3pq33giy4hp4cq8gu7qhcuqdnd
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A97210000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1763855364-225833
X-HE-Meta: U2FsdGVkX18UAOV/Je5e+gLfiN1rs6vJ/NXyDgKYB+5uUeme55zLdzze7aTnq3m6FtLAOdjclQRjyeF9ATTV+0HosQOliFvMmpfN1sk9HD1LF0JJTDofaAAdiQOgpZRb0D6PQ7dzj63NetLVwO20fFKl8S27F83XBjezKLgnALCuRSqA2nkUkMSwzwFsnqNNl6NduwhcB/5xNlHgG26s69kbSyvb8KTLaohKaQ8fB3ddV/aRjJB5kh35VdvEtd+C1SzjyKlJuy6LoYMTk64U1ZG/wxMPDE+P1vZDDaSwtsItr7RaojsR3rdnC7HijVI4q+CqY3dE3X+XpXU/6JLROMRXiW6824JDFrqFxH3tpiENqxD8KzD99G8BoOf8wnLT/sSW2NMe3JmWCkWPK9qwOafIWysDtVrDCuWBg+Sx2fsF1hcIyckzt35JwCb37u4rNamomwWJGEqFx6bj0aAohAd9iXdG66uNYlgdy3qo/mQB05LMHc/uVWEB/O/4GP7zXqnugFbpJp/PAitgQQ1W4ixzmZF4XmiISIEk3kkJtwfjiEzprDhQNMMGHIhW3zuodJE1uljuk717qmIzoN1wh6+LsbzN6ufmAzksg6jWjT8XD38wlbknTUXd2LrRUamC39WUqZ6qsyjfPRr/5g++FKmf1eMXXo10UE3ss5eewAEJ+D0EyaByDDHaPOE3X2HIkLwAkBTm30mto8Bc55FNJzKAyHgbS6OOURbFGPNxDvBcbKdDqoCepPuTH1/NKBWxtZysDc20An4QGkZPsCDjP5UARhDVO7ThKd+weB2sdo6p8ZRC0ROASgjl/KiPKX/kSIvvPHsFZNpQpKqtV4e4qctOpDmDMabA4cDJWQj0ARrcK4sMmXa/zKAzu/eAk+ifoFrpi/+aPSYe2mV5dk6I3ZZRNpBVSDMFmamSRMqfmREJ3yE9DiFAYyrtdcOukFhL/TXi2hygcsBP6ny8QKl
 wzix4REI
 de6zq5sGUV9fZFlqxh4twPzkKbOhIEBQAIu+7J8XirKPfpk933+SbOXcdfO4VUSdPyZzDkfyHTODqyNUQrMLTYWirLwqXvurgKHz3RrsCmuSL1FcMLGB1Cn2rtl1vBhKNb9TN5Y/+8WfxWmqLKQcgZ0K830ENxuu3gxrIZzMPMIdGN5DuOk6Q7f91alENoTOdkUbUbtEm/oVGM0znQu36sufUw6XkdcEGRp5rz4YYx39ivyE6ZL9uWLVRNPECuEuoWz5rxEF533diFeqWPnYa4KoUHuvh4GGTFkeSblvS/yeYXTkteeih5N//qZqfD6+uUZsnESnxFKy7WO99DE5FQElebTr0umrM2EUo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/22 13:54), Andrew Morton wrote:
> On Sat, 22 Nov 2025 16:40:23 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
> 
> > As writeback is becoming more and more common the longstanding
> > limitations of zram writeback throughput are becoming more
> > visible.  Introduce writeback bio batching so that multiple
> > writeback bio-s can be processed simultaneously.
> 
> Thanks, I updated mm.git's mm-unstable branch to this version.
> 
> > v5 -> v6:
> > - added some comments to make code clearer
> > - use write lock for batch size limit store (Andrew)
> > - err on 0 batch size (Brian)
> > - pickup reviewed-by tags (Brian)
> 
> Here's how this v6 series altered mm-unstable:

Looks right.  Thanks!

