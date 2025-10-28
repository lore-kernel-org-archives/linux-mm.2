Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B6D9CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 03:31:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8704E80104; Mon, 27 Oct 2025 23:31:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82034800E4; Mon, 27 Oct 2025 23:31:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70FD880104; Mon, 27 Oct 2025 23:31:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A5F1800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:31:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 13FF6490D5
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:31:24 +0000 (UTC)
X-FDA: 84046097688.07.8D8B298
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2DB8A1C000B
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:31:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Hrs7mGz0;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761622282; a=rsa-sha256;
	cv=none;
	b=O3gO7mevOvAtzRcjUSw7riY/sg9YRXyXXsgt0wkk7FWb7HiycQE2wqRqmjIMG+Y6T+/9TR
	fYRJFVr9++oLEFlG0odnt52Gerjp9SUQzBuDn3+AdqwHAePkmlS9z9gHFQYJ/GNLzlfC0a
	ELs1PvhsabrVRAm/1+BAfnCZ5CcwfbU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Hrs7mGz0;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761622282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/WJvY11yZe5DNuh0SmLl84KhyrfL2n7Y6FVCkvFsiMg=;
	b=7qZeICLC1U5EFAyY0vvNFOY87QwswlWV8U5aa37uB46Fn1g7qEUMGEDVOl9UJKpCaVg0qU
	fw6Xe3OeF9nBI3HdE28bHjTo01HGQmzSQp/kD0tG0GarlmwyDunHSiQNLKan2Z0OROR/Ta
	x0d7RvUGsS2mQRN21YzYJH14Cs1Yw7k=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b6a225b7e9eso3933474a12.0
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1761622281; x=1762227081; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/WJvY11yZe5DNuh0SmLl84KhyrfL2n7Y6FVCkvFsiMg=;
        b=Hrs7mGz0uG+ZAA+u8cE3IInD1selUGuFil9NVfYRXX+QLtt5EsB/szuFnVv4ClIVZj
         CaA3m8UhsUE+l/zsgvUK1qNW3oWvEqrCqOva72k5na8jm+fkVS6VT0byGApwsZzbqEfC
         KxWH+DirrOuCmSePAMV++/d6aAuR++PuTvwyc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761622281; x=1762227081;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/WJvY11yZe5DNuh0SmLl84KhyrfL2n7Y6FVCkvFsiMg=;
        b=JWcnFbdltuyiekJR2H/a+1Wz6DgQFZ7MfPqOZb8m3KLkHH7nTfd6SqwUfcgzZqHxfW
         7803al31k2cvRYmgptYvgGH+UTjuTiEyisJDojYSRi+ZXkCBd+MH4w6Xme56BiQlzQ39
         z5TjiZXhnayK5j6UwIETPW0bKwg1bBlt9FWbKVXF3cH0hOmhmbQwS86aR0RNmT9cjL7A
         Bi9rk3QPk0NKmOvNQl/uTqqo/c8N0ZQEv6qQu/NuL4P+YDVkP8ApyuIEU/sri8sA95lW
         yTCWHyKNHCQactx0SQtwdmCESy9KeKvhDjyWsOfWB0pblWpkbqG1r7MqZn5C5TLvXMON
         64ww==
X-Forwarded-Encrypted: i=1; AJvYcCXsN7DjR89AUHUr8DXYJpfnZJMCJ6xi4NN9pT3dKdr99y8Bx8DaYRz3jz1HnZpBATcObj1hrAKQMA==@kvack.org
X-Gm-Message-State: AOJu0YwbJnvygHFOEs8tr8aflWPFy7p66a7NH9xacMFQ7ycWSCLoyfez
	WtvdvyWN5Xx9nghNQFUwVyJTaaSPYOMNdKnRT2Xwc+oPuq/su+GK7ee6Q6fBD+iRGg==
X-Gm-Gg: ASbGncvvXKNTJl5zfTWFPSwsbGPGcmNJU5iZytNN4HQWL0iSw0M6GfljoIVITiFZari
	y+G0dMapgA2b8xZD71ElHLf3Xa7TVin4VGyz2t5xNT6fkPRMCrEyzzN3lhMN5GOlXiKe4w9g8x6
	YHoDuoc3CATRqlz0QUyEtM543enPXKxBHQR8C1GIXrM72vQqv28I8kfADYr05Bo+39q8pQCfRNb
	pG8uoHzarfShYHSXLEbHGW4XTopmi7RDEQ7Gq5qkrXoQZoZlRj4UGM1m8MeJTiS4aIgzl4FjIxc
	cmqALSVvFgyGZT2ERXwOv02JwV8WFP1Lw/R+LF+DYFwJvPntIAs4kdwQqy+YZk01FVEeRTkxcdD
	jD/VLP9AiaM7FR/cKdKKao5TcDTAfdx107qRtG43AspbY9OoqbqqE675J4h05qFBe1656DJItIE
	rdiI6D
X-Google-Smtp-Source: AGHT+IG4vfR0LE0WG8LCYJmEN31gkl7hCsYmhmgxpsNHn1XBOsYb/cbkA/Iv5cZPqQ3IQLRXV2PyoQ==
X-Received: by 2002:a17:902:dacd:b0:290:af0e:1183 with SMTP id d9443c01a7336-294cb6746c8mr22090685ad.51.1761622280960;
        Mon, 27 Oct 2025 20:31:20 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:2c65:61c5:8aa8:4b47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498cf4a53sm100342125ad.6.2025.10.27.20.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 20:31:20 -0700 (PDT)
Date: Tue, 28 Oct 2025 12:31:12 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: jinji zhong <jinji.z.zhong@gmail.com>, minchan@kernel.org, 
	senozhatsky@chromium.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, 
	christoph.boehmwalder@linbit.com, corbet@lwn.net, tj@kernel.org, hannes@cmpxchg.org, 
	mkoutny@suse.com, axboe@kernel.dk, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, akpm@linux-foundation.org, terrelln@fb.com, dsterba@suse.com, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, 
	linux-doc@vger.kernel.org, cgroups@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org, zhongjinji@honor.com, liulu.liu@honor.com, feng.han@honor.com, 
	YoungJun Park <youngjun.park@lge.com>
Subject: Re: [RFC PATCH 0/3] Introduce per-cgroup compression priority
Message-ID: <4tqwviq3dmz2536eahhxxw6nj24tbg5am57yybgmmwcf4vtwdn@s7f4n2yfszbe>
References: <cover.1761439133.git.jinji.z.zhong@gmail.com>
 <CAKEwX=MqsyWki+DfzePb3SwXWTZ_2tcDV-ONBQu62=otnBXCiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKEwX=MqsyWki+DfzePb3SwXWTZ_2tcDV-ONBQu62=otnBXCiQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2DB8A1C000B
X-Stat-Signature: rqan4izecz6oghssmwaww8d3b6hp931d
X-HE-Tag: 1761622281-500524
X-HE-Meta: U2FsdGVkX1+W9IxdCLpowQSxcyTPMceQZSvsENdY6zt98CbdypK1TfOJ0nltMSJEkJeoR1Gy0YYGi4lTZ6b4ccAUN9x3ClOgiMcy25bPGhJz9fEO5gOrgEFxUg+JDi5vRc2dUzeSc2NiUu5tISEM1g1h+b9FJ8HP2+/0ihmFoaQ0hwlMamWiQh6nyRda+SSB7QrR578b1QhFL84r71WuvDCHhhIZWMuP8U03vDVLDsmAqBLLBSALGzPZZRepBWbHsA8RAV5c83D9ZSAGUC0MsqvZa5fb5gmCP6A3uS8ovnAWiRNdSUfT3HdtIekvhQb0h4CFQaOPukwHbNWvWzRXlHjMirh4iTb+ANgTTiPAgYVXRtroq096oNQ21JPKT/eLgcdbo/tGcQfaO8B6f+3Y4HEeBnxX4mbE0JUzi5quQxuBiZBWZUdIbPcrm1CHHHol/wyBhYc2V37S8WDWib6kQJ97K1uXgNkVfOgufXSwtL9mU2qT7NvAXk6dsJxsCqOKGZp5CkRcoaVwncNHx82nN8P2/rakG0sUIx86iwaIRQrgg17ZYWkvCSpDNAnZytA7Lpt/RmR2vtNcch/Y5GJD/crh3QiNDvjTiftMTWR0SNvL3jJTpQjPJ/TOu/QSrq+BrRcgH59fuhCi1Gd7EvAVGNAJEFz3H2khjPOHPCH+iulBp92WyOpCAyGV82/q1dgbD3Y5Mh9Feo5RQjLX9+qRWXFxaRJsIckX73+9065WXikozevLQqJxCdJDvKVDQkPw06uwOBXpHsGCehBGrkQOr8smMaUpIHtKU9EGm/MbwEDnAvMLrjgrZe5wXrssi2Z9+HRpn9Wk9v+eBVtHjbQOCqr8r+nzgWjlc02c5XPPd4dPorNcT+556pbJkTNu2WmCFiUsMOX1sLDD5fyScqd1ns3i2TwVJvfzbyFktm06XFEA9lbCB8kzJcRGVk6wBVtXltJWTQMZVrjOzz8/pus
 BMk93UZU
 mBqiCfo+Aaa1Ba8KgKFRXWTcs2zF00cvSKz5CmrRQxAchGl3BkmJLNkVMwv3y+qecwVcw+0at84lFGaLbEK4nVKAPCUyoVJ6gcWGGR0ILPl0DqKkC/nQ2EXB011/P0K+dVYbQpXX2ZN7chxZrJ920Jw0EaIsNtFFWLvjYqqxDQBTF2vf6j7uRHr7uZdeXvRa2BtXKAhqLrlW77vrQ8K24wxK5cD4IIQkXVhC8/ajZVDwfaNAbHUZR6YfkI/Qty+Y/HHBnDelNyb0gqyXnimS2zOSutVR6ghbGRTBUHuHbwTCNj3xaLZPia8lD10nJTCwJTseH89uh8WWVM6HfqVCIxvJUH4Myfhqgcg3Z60yLAnQG44jaOmwekxpk8jYxoezuKuM4agqwpv+xvj0EBdb0crVr1mI5HP+mKu51gbydSHhygfs/YcrZUgiGvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/10/27 15:46), Nhat Pham wrote:
> Another alternative is to make this zram-internal, i.e add knobs to
> zram sysfs, or extend the recomp parameter. I'll defer to zram
> maintainers and users to comment on this :)

I think this cannot be purely zram-internal, we'd need some "hint"
from upper layers which process/cgroup each particular page belongs
to and what's its priority.

