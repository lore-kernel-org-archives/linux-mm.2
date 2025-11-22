Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B07CCFC536
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 13:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A401B6B0005; Sat, 22 Nov 2025 08:43:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C9A96B0007; Sat, 22 Nov 2025 08:43:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 892286B0008; Sat, 22 Nov 2025 08:43:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7201F6B0005
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 08:43:57 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E99B81307C0
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 13:43:56 +0000 (UTC)
X-FDA: 84138361272.26.F728421
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 111B0C000B
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 13:43:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=eVEjYypz;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763819035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=skEifoSnF8Rut80XhCz/YHjVueIg7ytLGu1hExe5Elw=;
	b=uxX96/hCzLV/SigIagvzOrdJWzDwgjXZ4IkQH+OKU01jW7fIgXZzUNdLppz9pd1FYc5Cuw
	nLWSTE6OuxsKCtTJ4g9ZMPFuOobSF3LqI7bZZnKEDdsokK1zuaXXrjOdTNV2p+V3Jw5bwp
	8901xn34iHzEmK4AIUDMr3UmclMBBH4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763819035; a=rsa-sha256;
	cv=none;
	b=HxoITQXeE0xX2TgUvpqMMdo8c+qDZFKuO0l5zFGPlB8lk77AofskcxGQWC+9te9vDad27z
	4Z2ynzHNyWx2zAQLbSaPwSbCeVMaqkpT/fNTs83n8MHy6EyklhVSLcApkj2k++SFKI4Q0H
	Qou9Y3byK7wGdmAMJN7BoFwWXPsXTKU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=eVEjYypz;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-29555b384acso36291495ad.1
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 05:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763819034; x=1764423834; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=skEifoSnF8Rut80XhCz/YHjVueIg7ytLGu1hExe5Elw=;
        b=eVEjYypz9w02uYAjvVNwh8GZBVvluHtS9PRW/e0cT3I8U+6qzNmBIXgWYXwJTNOd+3
         8Rr/l681RmDLcqBqcP2Ha75KoMwoeg7gvR2LgNWsOuuzIT9YPUGnsz/tAwbuDrFYBjkg
         lUStLfgRQYvHd692sJ3LzVobMrPH90DCInxmc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763819034; x=1764423834;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=skEifoSnF8Rut80XhCz/YHjVueIg7ytLGu1hExe5Elw=;
        b=eoEuZNxxE5fgmYDwajAtsVzDRy9Kqyst2lIrkIAUG+HHHdHYv/0M/ip6WCyhSjhS+o
         PCk1rAkgMCw7yUonuIx2mrRhoF/3L5psOBkURLF76MSMOTQls4lFXz8qEDddgLvhcEY/
         VqPlp+6DPI1bkb6JLCqs1IqMOUvPsP/+l26JI/fROtmeGFEGCzWf7xh3xqDCklO46yw+
         LDxiJCkfNofehOwTDt+OLxIvIsoBWr8Iw9anI4dyJAm7EWuLNrl2IMWcxmo83cOVXqX4
         2LomXjHPawAtKx1ajgmh6nIhENOsXa9M4I2MKOEGuC3rFD8RQIC5+w73r/YpM6V4rLrb
         GcsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWU5pr3TZTjmsETeuvy/5wQmUjIaKH5jwqRagWHwTEOYsFMt5AxB12apQAt0hc6p8tDk/bSfkVjug==@kvack.org
X-Gm-Message-State: AOJu0YzAdesQn+YSmvNMpx3ABlVmqEebtaS3RJ0yVF2UChk9FoGtMtHK
	OM/zOPcshwPg/ajm/SEUVIkMeeiFeJmVZjImgDOFqNvSgzPmQc7tbdBTxKIday0LOg==
X-Gm-Gg: ASbGncuJRjiJgXUBMILQR/zwc/uuYpcIHerG5BgFjKvttlJBgUL1qzzEgTTVVIMQJ1a
	mjSBGR3P9TIqXfoxVkD/Tx6JXomPShaT59lrLkDbZ6n1whexIPbOZan+hMgj+LEqyd+WBmR2z5F
	7mfHog94xfBQBBrANcYBCX0uyPAd9xsmn1DCL4EjS/njXeJKixbxQMRxGrsbFiXaVBp1GGgy5sr
	olwoJQoc/0Atq4txidPAwNfE3OZVl+8ov4LnqDYMQ3X1S/yeI+FQ3+zi6qvdn7TGNjLeFlbNtvi
	Fy2UV+2bURQq+BWji4hj9uoQvDBJxqTXyws4Oug6B02Nm9N9EfJBGRlMkzVSmX47/ebezWYShZV
	4Z4WO/VLEF8jQk4tTZXNO+JMHv4/wYT3UJWvFtYUkfqxM6saG8jVR7P8ZI/8pl1mLL8+Ly5b6FP
	pSUgZv2NFRYQT7PMBwz89MqY6wbK03bNnMUCPVRQqZmDwsnKN/F2c=
X-Google-Smtp-Source: AGHT+IFEAzXxpBMN4+Cvpnq9Wz3bF/ejan4xQv2Z6/vy+0j3hfTRsuEa6ttfw6fKfrdggqzCKIk7CQ==
X-Received: by 2002:a17:90b:4ec7:b0:341:88d5:a74e with SMTP id 98e67ed59e1d1-34733f4ac35mr5395298a91.29.1763819033721;
        Sat, 22 Nov 2025 05:43:53 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:948e:149d:963b:f660])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-345b047616bsm5856992a91.9.2025.11.22.05.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 05:43:53 -0800 (PST)
Date: Sat, 22 Nov 2025 22:43:48 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Yuwen Chen <ywen.chen@foxmail.com>, akpm@linux-foundation.org, bgeffon@google.com, 
	licayy@outlook.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, minchan@kernel.org, richardycc@google.com
Subject: Re: [RFC PATCHv5 0/6] zram: introduce writeback bio batching
Message-ID: <ztqfbzq7fwa5znw5ur45qlbnupgepaptzjaw2izsftbtth6zca@db4ruyaulqab>
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
X-Stat-Signature: jkqgtmpjre41omyfstirupu5ktxymuj5
X-Rspam-User: 
X-Rspamd-Queue-Id: 111B0C000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1763819034-935048
X-HE-Meta: U2FsdGVkX1+R6eoA8w+tnFBCVKkcvEuuIZEIE/+Hv80fXp8bQQZ85Y4FQTf124ptV9+lnj6MAfBCP+mwMTF3b9mQ1yExSGPEiTL6ySTjKBKHjcZgKfxEeMZb4Gty1Sb/4/uhc2VtS4fjwEx4xAEkgZIW5xjhrL4B8Ixvf2zVGe5HBnuYFTtFVaNWDUVb41fKG/f0mAMbRrFw41H0KesMcrAIUP8NCBKPzuDQJ6tiSQt3/BhwlwL9ng3kVHforDi0PlIFf180/DKlGtVv/k8EnVbemU3La7CUI8817/1+l+WlDr9YwvZrcZxvRGD8hUG/86Aiz9iqIVtAcQ5dMAKqT4BfYR5Uf98TybkTXLx70HLot6Utxjt2MMH7awOcZfFSRTeTkYpYyfj/sqHn2Q3hDirf9r0GA0cFOtYWmKTOSwTJNyAUHBGzBSg+FM2WGXE+mS3V98Q1PVRIVc7ya0sz6Ks74KDt0UsBr6bkNV+wZothMDaXisFLrK+VQMAWhqNmdlZEJPfvSLaktMcZz7H/LLimUeEUsCNFp+ERyzNvd0wCWHoAqMeiJdEpX2DZDSSycCnOupen4IQSjrX446m1FhZPisTxscWqLOZ4oWhEylPTvewyA/FzVw2bhVJxUOyptuJ3PAjMOKYUlhQY/Kx1+oJ5l9OB3jj+0lCgdCPmdk0Woz8l4AdYAPYSfZ8baCFmqhyv5G+D/8gFSi+qZTMCQktoEvGPlxOsu1RcW77lTPWwQL1XS47sxKlah6qWy0EJ3xrd8rg7/U8gFN8Ts0XYQhqGY6sKnfkn7W8872Dp8Kevg1IkiatX9Iu0W7IcicD0JnsB0sWxP6U34Qsjzh9533AaG2P70WNhQ6BUP6oAzxNVwixiT/h0/Nrh9ygJLG4jn8iU6bZCL2oW//ScEMcSGDOaFBAmoo02dt6eyLmiQ+RjfrtP99Yr0Rd4rIxwSX1giUXpRMoUi9TJHWzR3ag
 JYSj+MMo
 FHFjKmPXUudd9m45qMndZ4wNmscebe8Yfyq2RnH5PWpvFx42zYqKefO/RYeiAODZCMDutThAMQRIsLyxaO2hL1E4w4ynT+spHD6sciq9Xvou1OU21Yd8ZPTgfQ8VWlx4/4lBGj6wFyZ5WNJQyoig7wVgIjlsiTousBie/r8FwFlwOZRFvilFjtSWTcOSu6wJit5KfyVICsHPiInJCquMYlHOsrvE9VqG3FxvH3ASSNx505drrGNBT9sz9DHAB1QrQhuRUC5v50d1JobH3TbPDZL1yMZgTOmLBW0rFBtuAsELD6UtuLJO7PN5nk7FbszaVLminMCT0/jxiQOYGMiMpS8j/s9M1MrTZrFlFZChg1OHSIXU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/22 20:24), Gao Xiang wrote:
> zram(ext4) means zram device itself is formated as ext4.
> 
> > 
> > > zram(ext4) -> backing ext4/btrfs
> > 
> > This is not a valid configuration, as far as I'm concerned.
> > Unless I'm missing your point.
> 
> Why it's not valid? zram can be used as a regular virtual
> block device, and format with any fs, and mount the zram
> then.

I thought you were talking about the backing device being
ext4/btrfs.  Sorry, I don't have enough context/knowledge
to understand what you're getting at.  zram has been doing
writeback for ages, I really don't know what you mean by
"to act like this".

