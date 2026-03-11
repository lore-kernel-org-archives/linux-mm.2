Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 915D1FD88FF
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 05:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C65A66B0095; Wed, 11 Mar 2026 01:30:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C05936B0096; Wed, 11 Mar 2026 01:30:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B07F86B0098; Wed, 11 Mar 2026 01:30:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 88BE66B0095
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:30:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B9A21B8551
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:30:04 +0000 (UTC)
X-FDA: 84532655928.20.7B1C16A
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3A0BA140009
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:30:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=F5+GiQwM;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773207002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tpIlh++gNSqrjxti8e+fCN/v6IbpRXIC+wi7lGmEm8w=;
	b=bsSQ8IgW31jXR+MBaH+wbGr1X9leuGR5ceJqwO+ZvCOue36mT2x/xD1rg2MWy4w+wIVKRM
	BCobXYW1ruYJJUvBzLufkG9sOjJXEGNMrKVZNr15QMvdmUiMVwpuKM+wSi4J0oaAC9Q1w1
	PLTL39A6yiQVJ46/wZrPOVdyj/a20+s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=F5+GiQwM;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773207002; a=rsa-sha256;
	cv=none;
	b=PbEeXvPuPGwVoiDcnj+OrqfPw+cZsNHPEgKImCGcfltKzTO0RpStp3TsFWheJVNYRRZ3zI
	GnkhLmuWT8tOBuqypuc+D8EqMkR/1XUdUBHYNlZT0nTNUT7dwcllQcEhwohsApkww7cINx
	TANKS7WRpkruXCtw4V2xYWql1r+yk5Y=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a7a9b8ed69so150264705ad.2
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 22:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773207001; x=1773811801; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tpIlh++gNSqrjxti8e+fCN/v6IbpRXIC+wi7lGmEm8w=;
        b=F5+GiQwMn1naYpV1X6baaMPl7X4iIGGWg+ZVQsgJAvM/2n6pQ1l8VsjntVYzXMw/Ie
         FIaKqlw6h/zhktk0IjxSNkvA9/PGe4m/Hi45LkIe8sF+uBearQz57pJjJvM9tagjHr/V
         0FR4M+spe2DdJOwjtpX0Xdyayl5HXO2FJVTWE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773207001; x=1773811801;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tpIlh++gNSqrjxti8e+fCN/v6IbpRXIC+wi7lGmEm8w=;
        b=GbID8i5hr3BG0Z/MODCoFCp0Ld76++yubLmlQaDoc9t5s+cG/CTixyPOvycS2t/Iuw
         xnkDTWk8C66NmZGaK1gl7t6JuLj6jH2a/nAWC+QKONqrAphJwH7S1J9ByIeUK6JiJTTJ
         pkOQ8CWXXoFZnYoD8V9S1scTQNTINsUGu8gdHKK8OSoLmKra3IjXRTYsoeM3g06gwQOc
         3xc9X5Y7hHHsdgAlavNAqd25XahAbL4+GjpHSe306fGyDEfD97xVQTOqj7sp/0AppCb+
         gZfhj5KjLQTwqR+WSno9BVyP7rZsUAVqVGctONWMXesblezvGbnAwz3HJnyLuC1k0Z0N
         LzIQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2J4NlpjfU4UEgYmc/vZUMP6v97DeGjGmnruWVmWVquZXJgu3Kp0bXk8vIhlnpCdbB1k31MATpYg==@kvack.org
X-Gm-Message-State: AOJu0YxnnGofsexMWY7k76u0y/GxcmuQc3thuE4tdwfyw+/xis1H38VD
	z8AjJPz2Nln6Ab/C8miXKulvln3DUAmT279BUwlCp2A8jMs/yuwy6rgtTGOyqnLKCQ==
X-Gm-Gg: ATEYQzztqiuZvLYCI1sYVPx1AapUjZeQnx9KMKXSmjzFx2hh9rgFqeLHpCIGJd9kQDn
	QTRQIb08eJSHOsIswdl/4yv4y3oD9JOZly4XldEqvLJTfAQCl2ATePztiGkFDapGFqYhrQkWfTs
	1UCJ//DX6To8YjsfqXB0zWhhEo55zopXjboIfqHu6ThNEcN1vJxljJjz9FLrIP9AsCjdf5oGiGg
	M8w52AW6/5iAnaPlzREl6bjHk1pQfD5pQLjdV1qmRmBHE68gg1qn0Dg74uMz5YeOfOl+JDjtsII
	BWJ92loWu+oZob6XsIpR+cHp0B6Piv/yaWVMyM/ilA8UP+0HYylcFVzK3BdEBzGZi5PsO6XHumi
	Kg43LK4z2Cv7ogOUDA2mhdQ+fv8B913L+ym+nPYnsyUnjL6bCe89AZJh6+bPxna8lQi4/xJrfGF
	Ck8z1t1RPt9C/W+WrW44AdlnFeR4VsHvIqyImoNerIPLvOgzbENmTFeeqt2IViV/I=
X-Received: by 2002:a17:902:c951:b0:2ae:46df:5643 with SMTP id d9443c01a7336-2aeae763812mr14917185ad.11.1773207000953;
        Tue, 10 Mar 2026 22:30:00 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:93a4:8281:fe98:426a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae222a2dsm9964165ad.17.2026.03.10.22.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 22:30:00 -0700 (PDT)
Date: Wed, 11 Mar 2026 14:29:57 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org, Brian Geffon <bgeffon@google.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH 3/5] zram: recompression priority param should override
 algo
Message-ID: <abD9faU5BcoCNcfY@google.com>
References: <8a5d53d19a8dbd51d7d81d153676895163e0735e.1772180459.git.senozhatsky@chromium.org>
 <831636c74ca6d72317de02d96585cc6833d082e6.1772180459.git.senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <831636c74ca6d72317de02d96585cc6833d082e6.1772180459.git.senozhatsky@chromium.org>
X-Stat-Signature: fe96tsr33k1d7dmpopne5wtfdidhbsrr
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A0BA140009
X-HE-Tag: 1773207002-467055
X-HE-Meta: U2FsdGVkX1+DboU5h2h3MnEkCUvxFjAapjnYzK8J+qk5WryoxbbkMPMt8tZjebvWL5ozgqm6BQSs+VPPUa+3OQiJGynnUY24/PVCFEPI4/ZpTqn6nzJuXoxI333pmibSZnF76Az0lgDgKy3U/Wt/LmpDDRPaim1gzNas2SmdcD4SQkRwMqXw33NtgW5Uqnd2olTm5/+4/s63R5SqDu46P/OYvMEX3kwMqRySnHJMR8Wvh1X3mkYkAsChjY5cTLkxWQtogZ+wn/Clc8x+Ea61bfq/RiwBnIZxWXzO5oF6LQT4X84AxDg8UNaBHyKDnaOk6tKmoOI2R+E2sNaRjBJDDXR4musdvaokq8jgR7Qar+BFQnoOi7gpd8EG3O1kwtdJQYD3P6MR0eKzkkjjjypKzdnwtcDigJi/zhITtdpYfQgsWQbljkULFerHuXNK/OksGMls7JMzhjiud2PGBOmC8IGBXu1bXO6SvgJxs+fUrRUor/rQnVFYVk7umZ8ivg0wioEbsSAH/iI4Kr53QCcuihURyx6wAoVQQK4jTxxfFgcDD1ax99SooVA6e+3Lw1VxZrdM45GNw68L45yilFpI48yfFPr3RuNZrfCou+/wVNNL5WiKFbIWT6mnZGOMks5RerYKvQyIWNC8Xn8u8b6Fgj0YhQQqp9HUxDFLEhFyx1VirjxBZ1K5IEL4RAhb61gzDzjOqP/wqWFNnxJ/v9D7rZAcYudcpr57PSZwL4W+1RHpiFzTFusIDA3zZoEx8QWeW737fp/gAi6RKxSRN0f4Sr8Ki/PUcEcXKJ4WLgl4PPC2U7W78aAAKBu5RL4whYN0lOHKd/bx67OZZXyvSBpFEjoXJ/du/sxyDoT5DUP1b+i/ncZdJaWtCUXumuuuQA45Id+6T1u95HYOf424HRtRG4sjUGIcJ/i+ylKIuEimaofrjfoj+zCaDvSJePT874LcwMFyRcMIi66VRkVGk5q
 NHJ0WmxR
 +idcs5c0VA/fg1LQUeNwsfpPgOdOPFbrGFbXhc/BiqPrPPcUGzTytCX6BF12jOSsPPCHsgxcTy8IuxuzxV8uthRqeBSPiqB3wud246FJ7z5h+xzG1LqAR2X6/PXpj5QVC23Xpt/R5Gz33b5aPrDQUj4r11AwnKMGRLuw27x/lmMSdRq9OdbpwDuEum/AHcoyCjV/hvL70YcjQFDVfU5TvhJfEu+oXz10FZUySE3GWUQudHpnDOIXL8AUTkzJjYbvDdpVkXqel1DFB7n0wgUg9LMSMJF7tDz5VhT4c9+2G6/2nEHX444KkwuGYHwrlA7CUu+OLfuLF/B2BjccItOKBKnmsujpMFrUJfJLsc7xyUyhzQcI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/02/27 17:21), Sergey Senozhatsky wrote:
> Recompression algorithm lookup by name is ambiguous and
> can lead to unexpected results.  The problem is that
> the system can configure the same algorithm but with
> different parameters (compression level, C/D-dicts, etc.)
> multiple times:
> 
>     [zstd clevel=3] [zstd clevel=8 dict=/etc/dict]
> 
> making it impossible to distinguish compressors by name.
> It is advised to always use "priority".  Additionally,
> override "algo" with "priority", when both params are
> provided.

I don't like this patch.  Andrew, can you drop that whole
series?  I'll send a v2.

