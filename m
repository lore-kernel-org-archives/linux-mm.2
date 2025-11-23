Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA7FECFD30D
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 00:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB3C56B00AA; Sat, 22 Nov 2025 19:22:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D64B96B00AC; Sat, 22 Nov 2025 19:22:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C54126B00AE; Sat, 22 Nov 2025 19:22:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B0DE26B00AA
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 19:22:57 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E471140A65
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 00:22:57 +0000 (UTC)
X-FDA: 84139971594.21.970EF45
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5C06680005
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 00:22:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=dgn7YVOE;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.50 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763857375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FHAiZmWkDhnXuoPqEc1Nf7Paa0Td/r7W/5Ao6DSoK3w=;
	b=JUZYGHvzMoKeeVcM85oTC8YnkAmx61ifqt+BOGPStXtHAsSYwjXgrvBImdQUMjgpyd3Sxs
	clGULY2eIEJ+LZxL9S97GIy4c2r9M/uh8yRTOogyhBQ5w5MvrZYPFDy103Lr6pHmYUVJdT
	t9kK7cykCmslSS8Bag6eEw8vljlFFBA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763857375; a=rsa-sha256;
	cv=none;
	b=DsiRxx3mn6kpJ4prG93v99JfZDPmzSgxfJiBYX42hK/qF7WRLobcaqSxLO37K5W1qaKtb/
	3trjRflSlOtrGS5MIyvV2qtZdt68ZlXtdJTaSIZ23E8BNhtWL/XQF5+g+yDI+XhdqfTdzz
	BhZr5n2CbR84WDNWrZa1YX1aZFnKpIU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=dgn7YVOE;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.50 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3436d6bdce8so3869065a91.3
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 16:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763857374; x=1764462174; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FHAiZmWkDhnXuoPqEc1Nf7Paa0Td/r7W/5Ao6DSoK3w=;
        b=dgn7YVOExq6Q1vq23oYVOHpKwSyWUpR918Kfuy+FgJh5d0q7t9jL/Ltkk5hCEdPk67
         vqkUq3NwNmZGN9o0nVHWUd5N5db9MQV7kSb+IWDpRSMNYLAgve3kFr/9TpdYRhrtL6TL
         RUeEKLB7Xu7eiR+gERaaiC8LuPjbRHtVS3KeM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763857374; x=1764462174;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FHAiZmWkDhnXuoPqEc1Nf7Paa0Td/r7W/5Ao6DSoK3w=;
        b=gEldQWrsVsC1ltp1V1iztL5GadYCQlfQZQKcwPhMfulHKtwbhZWf7Sq3OBEgl+3SOa
         fNBPAgWUPRghZGYvgXnz7H1j9R70lou5sGFspuW8l7pOKGh/JgfggDrlLuRvEPSmSOxs
         vkP2OO2vn+0NyuG8/GpNoLEL1x3G+FPviYyTpIBJG+OR1bYgeG5T6Xdjhqt6WLTtKYrO
         UEiZt0e0WDzJ1B9KSrl7fLsTVrs2JKwpZpHCRipL2UfbSfkGHQVeSmogMcAzVWI20tKh
         n4ZKIPqPB2asGOgkryjdJud19rhXoTSSwArHsxKlG1yNaQP2oLsDECbtfzCWD3AeuJVF
         fbjw==
X-Forwarded-Encrypted: i=1; AJvYcCXxfmp5v8CfNGwlP3vNnF4rnb9+mCaorGNY+YbnNvIKZ8PDBVbTslHMiugPg0B/Jp8Cqyy7fCSZGw==@kvack.org
X-Gm-Message-State: AOJu0YwvJDv5CH8DSm+FsnqNar0trAi+NbnVPm3R8D/xjpTi3ywgQkgm
	BF8pjgkWxi0XquaGZVlIdC851Bbi1R8Y9+U3IFPYV5/pyW6ghq3L0/cefEScDlNV1Q==
X-Gm-Gg: ASbGncuzCdRExbA2RGZZQCrCgvfLXt0f5mNSsV0w1ohVG2AzrNgQfcUhSeKPT2qcRkj
	MYbhUX0qdiiQvv8L6dBcxT3hYyr0iGHe31GiU3CPcJ9UIcm5H2yJER9J5tpjKxlM+FoPywNjxYr
	Wgve9AD0+apJFkv9+WJop/CgBBD9dXoy5RDK44XlMGvMEpnS3KTETO3UVwTz/A2AyDra/qJ7pMH
	ThaU+fEoSZFw0qYpu9oDLqeOTCxJv41Iclq4nx9b0+jVssSPUPAXDAfyf+Tm4USZ7hyWA1bDdVM
	IRMxiuPM+j1FF5NI52hRwiyTTq6wt1eSzq0i3MgXjdpc1MkJzxfdELNdwAnMB6Q9HRJovcIlg+h
	zh2ViAXrDQLRsXZCJrLPOx2brrejgkaJyuEZxp2YcY4hKsj7eNjMR40rMgEgZh6aJLoRD2XQYkh
	aQtg4ScL+GyZT4ObHbx/Y73mnJgaHDszkvegj011gygAZMXEX1CAg/qW1S7NvI
X-Google-Smtp-Source: AGHT+IH8FBGlGeoQlTTcY2Ds1x+EIg6ekEamifVS+TUuaNagUXwwLXZoC86g7wj7iuLp7+iUaAexuA==
X-Received: by 2002:a05:6300:8b0f:b0:35f:9743:f4a with SMTP id adf61e73a8af0-36150ea9786mr8054586637.26.1763857374220;
        Sat, 22 Nov 2025 16:22:54 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:296e:57d:751e:5598])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd76129de4dsm9097957a12.36.2025.11.22.16.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 16:22:53 -0800 (PST)
Date: Sun, 23 Nov 2025 09:22:48 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Yuwen Chen <ywen.chen@foxmail.com>, akpm@linux-foundation.org, bgeffon@google.com, 
	licayy@outlook.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, minchan@kernel.org, richardycc@google.com
Subject: Re: [RFC PATCHv5 0/6] zram: introduce writeback bio batching
Message-ID: <d652n6zrqbkt4oltusd5egbnrvd5xz3k4kbmqnfuwuatdyuekn@22jscte4mx7m>
References: <ts32xzxrpxmwf3okxo4bu2ynbgnfe6mehf5h6eibp7dp3r6jp7@4f7oz6tzqwxn>
 <tencent_865DD78A73BC3C9CAFCBAEBE222B6EA5F107@qq.com>
 <buckmtxvdfnpgo56owip3fjqbzraws2wvtomzfkywhczckoqlt@fifgyl5fjpbt>
 <8c596737-95c1-4274-9834-1fe06558b431@linux.alibaba.com>
 <kvgy5ms2xlkcjuzuq7xx5lmjwx3frguosve7sqbp6wh3gpih5k@kjuwfbdd2cqz>
 <853796e3-fd44-4fc2-8fd2-5810342a6ebe@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <853796e3-fd44-4fc2-8fd2-5810342a6ebe@linux.alibaba.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5C06680005
X-Stat-Signature: crzjkp1xei4it7u3y3t93hdhwjqrw6xu
X-Rspam-User: 
X-HE-Tag: 1763857375-12439
X-HE-Meta: U2FsdGVkX1/qrQwRNdPipkpzgwxYdSR+uRnciOHlIG31EuDNYe/30pTucKThCeA5SksaLVoblO7TnIJ/brSw7ims8ns1frghfkyW3+lZHunMs0mqlUf5O9odxCz8t4tRfRnleJOACdgJXf86RObkiZR3RY2GgYVsUdxxDumfchY3dgVNV2LkQNipmZXe5Xdkwsz8T8X7bTv8A5d6TDFUqNHB2arv8yN3HSQUUWh9r9y/WswjxaR0VqmXfjFApztieKjUUWAhP9ugCmMDLL5iHDx75BN7nYwutha23LbsDwqUlywolIl1IbntxFK5fY2LXmceDC2v9/DKEVT9BDQVynL5rXJnGvRfYrg2LT6Zd++fZ1stfCrTBLz64BNNFvyTxJk6hWLT2R/8BNku7HFpaWCuoIga8349V9f4alKWYJvuc8YniiRqMXKn+b6L7FtymrTr/92C4Qq11DoJUgvlYbTmZv8+jd/vh+zs94I9E6IQLEsFHl8LUuo+YLkWmh9LuLxuQ0dVlgZ4ERsuw3XDeAB6SqqLhaTdzZkIKzB0rZ/PGZovvnbgvUjD8qpZsqLODZ/mtFFKRK4G8WPfXgay58VXfIE/NKABBC/WnTRLAJ/7W/xV08YFW8cCqNm4h1uP3b8y2mY0wALmN6y1kLn6iFulwIkkVVKR5b7NZhiK7HpPVi4+0V5Qs8YDYW4KFFn+G2ES/aXF45ukrTGCZ2x3v/JczD7KDLozyagNKYJmOqNnwN9ut+Ofj6fQ2xeggrC7r093aUigf0RsF2m12hufCQ+8y7rgqVIZNhcb8XVSBtQTc6x80gC7SdqbQGXwnBfJJD/Hyg0i/IeSCAuyhAQfWy0BifnIRzQHPjW20QSy4fi4ll5SdXRsx7/4teFTazDlXkPhi6pTeo6gFSQB/uFHvMPEvYoSPP8wr+QkbAzn5p9V0TGObAbozWJyl/4kZCUeYUn3vb/zeeKWzuOmwUU
 q6cPri+Y
 V0Wcp6Px++UsawPjVM6DOEsYNdIQmgPNzGYU0JW2sfF2zJndHXF6V+nj0cohgax8GTBqIQUcJXksmt0R/t98RsG6+QTACaW2JRryiErMdy4R7uP4kyZixaGdKyzUqxpVxeZ9XKbc72XpcW85/SeAKx3k8v1gg77vB8xpvVldV9W9Q1yV8FBznXzO7BDJbyxHB92m010HcpZHjWFzSRCURfjeuaOlAhRLMrKh31GN1Sopq3i5z6n4DliIgiiRnELiPErGE6qrYurEyW4koD/+dRjsfBTrL6HxFJp2p/tH//7AzYKZU0byCgeEZcQyfepVr92nHWcV1Txv76Ygi/Ys1dQOkqUXpYUNYdm1oWqi3tKXxx4k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/22 20:24), Gao Xiang wrote:
> > 
> > > zram(ext4) -> backing ext4/btrfs
> > 
> > This is not a valid configuration, as far as I'm concerned.
> > Unless I'm missing your point.
> 
> Why it's not valid? zram can be used as a regular virtual
> block device, and format with any fs, and mount the zram
> then.

If you want to move data between two filesystems, then just
mount both devices and cp/mv data between them.  zram is not
going to do that for you, zram writeback is for different
purpose.

