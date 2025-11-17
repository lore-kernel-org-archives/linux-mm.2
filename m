Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93FABCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 04:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D66C68E0043; Sun, 16 Nov 2025 23:36:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1CFD8E0002; Sun, 16 Nov 2025 23:36:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2D708E0043; Sun, 16 Nov 2025 23:36:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA94A8E0002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 23:36:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3D6B913C1A3
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 04:36:50 +0000 (UTC)
X-FDA: 84118838580.20.4204462
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf09.hostedemail.com (Postfix) with ESMTP id 54877140005
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 04:36:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O86h6axC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763354208; a=rsa-sha256;
	cv=none;
	b=ihiehG4oFk2DCswG7m8C3g+sRecfhJe4MycxLRkxoRaIDVizaV7N+3u81d3TTHA0ssA5Y1
	BvjPvgo6FZE6fhifSWRBizOGbj9hwB0TFU/3XRfntdA8ErP2svnXxTdFEhT+/e6leII27N
	2UFHr29JGsZumi8DsjV7jr/Ux2uaRvA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O86h6axC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763354208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Fc3Zu8BNXpaHICfIJf5oLYKBbFHa0OxTAlRc1QvXAw=;
	b=C1bsUiLxvGGEfmeE9VLXS3CrCPz9AYFBnVpddwsUudDYM3PvvLuXEQ6bH+uTrqUeVrU9bW
	RBL2tOY4hVyaMplOPNDW6ny+TLsViE08zuwkt0q59ZX6HqrrpyZm+dXHXGg7/LFMOE9WSQ
	50uVGT1O1s8tUMtAJv6W3bCHjeUPJig=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42b47f662a0so2273841f8f.0
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 20:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763354207; x=1763959007; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Fc3Zu8BNXpaHICfIJf5oLYKBbFHa0OxTAlRc1QvXAw=;
        b=O86h6axC57mzJc6dd7zfWOCaPItC/cKDUw0KWf3UZTF8Wt+ZrZLolN16d2vlQUMKNp
         Wd2WYlWteOEsHQlBTu/utPCcbnBZIPx4S808vQP1adymoAoxgMj2VrOMIBEz4umskk8P
         yhgR6gEhfndM+/a242K2cFpRZWBxml6wrR2lbH+OS46hRTuheG4wHFMScMxPbyNFphRa
         WOuPpjKWZ/oTRh7jrdIzM5TYyXN0pBX4AbS8EQdjcwpWJ/yc+BhNahle68Mc5pZnmOA3
         SGgLRusb3iU84tEnC6E9nC8wk11ulLvlunG4zy+b00OsncJ8KGkfDYtxYSnTq+A83aqZ
         ZbyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763354207; x=1763959007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6Fc3Zu8BNXpaHICfIJf5oLYKBbFHa0OxTAlRc1QvXAw=;
        b=Tiu73UCmnuyipRc/Gb2YPLcgwpBP9nVLc5ShVKriEiO74FMd8KD8aqRlhHhO31fAFF
         57PjoUia1MTI++Gvp213rnkRUKHC1FzH45VmCv2gNWWiEi/w+7y62Ubmu0I8zxf8ANCu
         yD163Mxi8+1BQDcl8jAXOnqAfzjHKxw+uDOo2bLdMjcCYbbrIiUkIineGPfKP6s1Mjl5
         K16aG3Gu1OmGPo+LiBqUFMzhLOzrgLaiGW39FIHYEjZYSrZ+6PKJ2zmkRbGTqW/oGyq3
         5sxEbLyqKsr2dCln12XHE8FUU2DE3LuNDPX2ZEAa7MR2PpPI30Zsv5Mk4599UalGGthj
         sYZg==
X-Gm-Message-State: AOJu0YxFL/82N88eBPXuxvwncabNU4jgxNo5W/AvdL3ZnRFLE3/YfaiQ
	EnWKGbCw5k3XFvANjiIW2uke/2qoj/ZuBFa5vwUKE4hjfofIVX1teVqAE/DhlaKJgkjrXUmSEH0
	PP+QBEBrkCLEyiAwy6OJXw3s617tBsgA=
X-Gm-Gg: ASbGncvBzHbBx127rcuHH1dae+n3oN99LbycvEUis+4yaVu1qeQLZQzf2zKib7gIQ1F
	fZ2NxPFjlny/DruaNlj4iQiFTj8kH4KKJvHj0OspROMbfbmroa7sojnZ0ummLU/0o6jPL2oceAN
	HFtVigl7QC1f7rfA7KuRTKCFKmKfIpmbNyvmGHYg0F5D8xZ7JtF2Fkg1RQBO565UI1E9KxTwULz
	naW4NzpEKtOeof+ZeLJ7aXTWo30jD6R+mnLyHpjLbv7FDrY2yJMYL7L2qw=
X-Google-Smtp-Source: AGHT+IEYkJGTV546sNbvGJ6zr5CbyG79IyzbFyOU3MHUh5V4d0FsACHPhrb/AGiY7YNHmuBQleizjBNvEGdPQixkago=
X-Received: by 2002:a05:6000:615:b0:425:7e33:b4a9 with SMTP id
 ffacd0b85a97d-42b58cde7camr11933030f8f.0.1763354206483; Sun, 16 Nov 2025
 20:36:46 -0800 (PST)
MIME-Version: 1.0
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com> <20251117-swap-table-p2-v2-1-37730e6ea6d5@tencent.com>
In-Reply-To: <20251117-swap-table-p2-v2-1-37730e6ea6d5@tencent.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 17 Nov 2025 04:36:35 +0000
X-Gm-Features: AWmQ_bnFLsC97Xw4io2kXWjMaJxDsyoKzPofYIy-vZ1fg6yv_dxUwFEJ5hkO0xk
Message-ID: <CAKEwX=N2hAOywYhYGXYg7FiDdXT2t3s1tyb8wPE8goYiT=vR3w@mail.gmail.com>
Subject: Re: [PATCH v2 01/19] mm, swap: rename __read_swap_cache_async to swap_cache_alloc_folio
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 54877140005
X-Stat-Signature: 3qubjw6yc49ibqy1t7sco6njoxeusgid
X-HE-Tag: 1763354208-790840
X-HE-Meta: U2FsdGVkX19LSMy/Lat6JsRtQc4EnXI7xsKMgyBQLuQdHlBiWdyl3Zhx0/UGwFk0vtK+i9Bxf0797wzTYd0iS65N6KzBlkdvzfoObiwazN7HwEGqlnWAcCAVfMZconyC4jE+KLnWZZpdYSrThMocNzoX9Dq0U6PE1UHbCu3RDkQ20aoa+BBJhba8kCUeyXeVxGmIsCInaVozyo0JMtv4rre1l1cDYMNaEPQO3iQxwyesS7jH6ehn+IJ90si5Jy2esiHgYLp0iBfJFSTi+QaKQ40Y8JYoNXDQSNuIORqbZECMHBizP/MuAjJXa0im2wlHdrjEIithJJvgIgO+9varJNx2vJNyVfUj6Qe2yT2klNzyFfMvrzGDG851cl43US5AxUhs/J4ONa3QOXh2RNzb8Ao1WBKtXSlyGXeBfaO/TKfi+JvjEhYrDqC1kXa9NoiOEuBHKmgSc0LAP0cQa9jRImXN0uDQpvqHV3S9M3nv14SRd/QLoFPL+m0r5aq994Y3IZ7m6uI4AeaSojlORFRObr6NCXD76DWKxA/E99DxIWgOvAeDhM6Z4WnwFCSeSTkpFVZF57y8hDbXO5Qg+1kdLI33yeJqBZpjJ8FKw3WkoSjxGj2avDqewiWCQkfjvr22jgaBABWXHm9y8+kFQd/OxmsZSXI5qtg01hOVmDnFS77oVHlYyKHMn46/6HNG8DjYZWRqy2vHMg7XXdXPHhv8Joifq5duhfznSVeoV/etYMgT6M/Z1hDT438YR5F4FzLAvCEiSl+3BiV3zFhjy98z+Xhkj45gm86Vkpy+/WmWKhVXgOzTWzCoUZWs7zTqmI43/FsPJfNzwm2XiKZ/8mAZsaa/MSoqDHM6+SGkcNlqe2B/OGa7EtMzEZWQbkd+/BH4Hctr4QvpducZUiyGkIb0Ew4aeWP+x7mRrwHnvjcEac9mfybiIZRbRgQH7Uzqujj7/0cmT4AEAwT6yJJX9bJ
 3mF6A44k
 YzB2ZY2d8DBZm23XHdcY7rzPN/8ByoRDX3LbClE+U9sy8GJYscskP/+rq1nPXqtcEBmazPTnyeYAvZXlxwp0tcQ0sFWWsjCPIaMutsjOCXzSxTtNokWb9nR2I5F57lVi3LSBfp7wdi3sLYmQeBYmANj3tARcOC/rQG3qRbbRCShwoDZkUvd5z06q1Ns80EAm5eZ3ymwAlsbgR1Q2o/l3/xeQUln+xCZ3mMHFZdDM36VuzDWqaoRNiyw9Qx7R34cYgIzXJBPuEo/Wsd7pMAgKshU07YDkHUsJAbytPJvQTdM7TB1PLzXv8NwC592RBEicGa3xqV8pn9USseBiOzSRBkU5UxbxTE+Mx4Kn/Aaz0H4oQHvv+mvHvBReOe0vf8N4WKcNGvE5dNgdsxvhPyFs1HHlpdHGL4AAturH9PaUDTKZStxoDUvabxo+LU+a+rlKjvwNP3Jd8OuG/b7c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 16, 2025 at 6:12=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> __read_swap_cache_async is widely used to allocate and ensure a folio is
> in swapcache, or get the folio if a folio is already there.
>
> It's not async, and it's not doing any read. Rename it to better present
> its usage, and prepare to be reworked as part of new swap cache APIs.
>
> Also, add some comments for the function. Worth noting that the
> skip_if_exists argument is an long existing workaround that will be
> dropped soon.

Yeah I completely forgot about it. It should (hopefully) be dropped soon.

>
> Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

