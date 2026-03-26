Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B3A610AB82A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 21:49:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 811ED6B0005; Thu, 26 Mar 2026 17:49:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2396B0089; Thu, 26 Mar 2026 17:49:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D82A6B008A; Thu, 26 Mar 2026 17:49:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8886B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:49:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C974713C31B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:49:18 +0000 (UTC)
X-FDA: 84589555596.24.E3BF1AD
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf26.hostedemail.com (Postfix) with ESMTP id D85E8140002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:49:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=SpnWd3th;
	spf=pass (imf26.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.45 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774561756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qX1NpSiXWyZWkTM0SqqSAJKsUKjmEEHU7OKtCuDkLTQ=;
	b=GHMqSyivQQvlKyjG9VcXtJMhwMRy3dy0Sa8jO+rjP9u/MXZcx323tntGbhzxNknuNF5zSd
	GW9+sl+43yMa+oFJt2I/0r1CR2/+SsJyT7TcCYz6075a5UwVy3R+iQyPl8OIWnvCt//6A/
	iSTQssnGh5B77EKif/vMdQ14Fye42Yg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=SpnWd3th;
	spf=pass (imf26.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.45 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774561756; a=rsa-sha256;
	cv=none;
	b=P/MqP7RXuJLk51IhgG25drG+qEDZ2ldNF1MzIUoX/HhN8Zx6lkH/AIlRU1OW/0hcaDLQaT
	Tbyl87Ny9+EJY/sQ4e2dyH16jxOAR9/4pQT1HJ9MYypH8K02HwUdPcgky9URNcgO8uByxU
	2Vb2GqoZBNy0EBWZcfR5xbbqyf+dxY4=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-89a07f66f4eso16305526d6.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1774561756; x=1775166556; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qX1NpSiXWyZWkTM0SqqSAJKsUKjmEEHU7OKtCuDkLTQ=;
        b=SpnWd3thZtp1IAFNhRF872qpiFhS0VWNFqjHamLqTH8G+caCTjCz36Nkf24wIh3Gmv
         t6+ontjH8j23UySHSW5eeIIR7fKNqvgHFHz6ZqwT70EA176mAeP784DXnw0TM4C7Unv+
         KBEB6ZepZh3I3EmAA73ue+WIfM/BgOvbkVY12KUi+ZheYNSGAWOGFJm8anMgUJ8KXPHb
         L8PpcmBMjgitZ0+866Cuu9+UwsSqcTfrmtkGQ9S108EVXUshXVnFixNNtZJn6Pk2uu5c
         3KQgSiJ8zbQc5Bg2im/smm/roSD0utPeSdU+LaWl/H0GI9M8rf1vM/XlgKE+j9TABg6F
         IBKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774561756; x=1775166556;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qX1NpSiXWyZWkTM0SqqSAJKsUKjmEEHU7OKtCuDkLTQ=;
        b=MEEMQPMN1OU5NfAtnPbYKi7kRH9Vtbj+jhBHniDTjW86HQ07Iw7qyJHInHo7omGhLs
         PJLJkPzOcCV3zASAoDH682j9vffif0t8DHeWnxwXIGpqQv1/PCHubq6AB5ND+Fcte62w
         3ACnJEYN+zdw9b3yM8//EwR5b8UUpT6DucLd8EXN90WuS081SKre4X8PFEvxMtLYOO52
         FHpkv6d6UqW4DEpCVrotutFUljdlBSx8XSTp9FIkO6AE5QF+xMCAW9Gy5RNDW2PSvXi3
         DanI5zo1y3RpgZg3GEeLeA6sL36LdOORPhe6pio53garv5FzEFkgYLCaGptCcu6EalhV
         sfHg==
X-Forwarded-Encrypted: i=1; AJvYcCXaHv+fIJ3PxlJIlK6mDLyEmGpJjS1jkbcDFVk2YBUnTnXmjBuDvi7JG/ypPWSQbyEXivi996eX2w==@kvack.org
X-Gm-Message-State: AOJu0YyHIUgf19l0VVOgQ4xwmyLeY0+wW8I4WIFSnQGvAb23jsLugzas
	6lr8IHZJESlb51+CcUQZehhpqx2JTXb0NaG4X+4SGDt5JlxWWuyypjn4HhFn0owIY3tEPSJE8o8
	u2XN3
X-Gm-Gg: ATEYQzwID2YxZkXigi+v7GKhyMCjsLDFVbi0g7XsrmDQm8vykgSJD6ozl719+KAJNRA
	5cz9Km0dXQmEUtMO+aDVrwC0xWnqlcwEJYhXkaHuEPQj4zj7w4Q3QK6oW1wB7b3tuUO4rLl5DZB
	fwwDDZCzEz79uIKNk5pSqow4MywM0Nxa2XaqMr9axv6XW2DB3ciJm3nHJk1vaPCiYAyP0Hzh5DN
	69vVSIh15fADPsa7zfsCzjmfuPBgXROqb8Xedon2CIO/WoJccDny86TiBNesIu6Dt4AEjjchT2S
	tqz0QMq9VG3UmpFxcpBL16VW3mXHYoXPnPCiaG84CMH5by0+yCDITaIihTmVX4mktWO734RfFFy
	UEOWPUkji5aOOYC2DdpgmeWJwr4vQKcKJXKyZ0/si9ofa90tc6GhcmdbduGZ7QfPloDrnJjHudB
	l0/k4SuM5VvzstJa7ViaIvIHWpMoisI/rs7RKw/uAP+SymuoxD3oOM8tKTS3eYQamPoZnJYA==
X-Received: by 2002:a05:6214:3d02:b0:89a:125f:37db with SMTP id 6a1803df08f44-89cc4a9f41fmr132847846d6.51.1774561755760;
        Thu, 26 Mar 2026 14:49:15 -0700 (PDT)
Received: from ziepe.ca (mctnnbsa70w-159-2-73-22.dhcp-dynamic.fibreop.nb.bellaliant.net. [159.2.73.22])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89cd58ad990sm32934696d6.18.2026.03.26.14.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 14:49:15 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1w5sZm-000000011r9-29KT;
	Thu, 26 Mar 2026 18:49:14 -0300
Date: Thu, 26 Mar 2026 18:49:14 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Brendan Jackman <jackmanb@google.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, rppt@kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] A pagetable library for the kernel?
Message-ID: <20260326214914.GJ8437@ziepe.ca>
References: <20260219175113.618562-1-jackmanb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219175113.618562-1-jackmanb@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: D85E8140002
X-Stat-Signature: paiw4c5dee97enmis6nf1xjxb365pob9
X-Rspamd-Server: rspam06
X-HE-Tag: 1774561756-173175
X-HE-Meta: U2FsdGVkX19+UsRtbLKr0LIME8w1TI3d+YLMbOvvKyp4gEwCOsrlOZRkEDbKRknLC6ULo+7daCxkYFNGDc7yi6ebZpSMzYhv6xJD1Siv79WJnxHS8A6M+aA2z0qwg29Kd1YRw3qEmbF+t5cwKDBZMPqlJIvfgapBG76Uz8sknf5RNu4JpRIDaKoR70ke0fn71KvqTYTjZ162KeevR7cRilQST40dlK/mIB8Fa1Yx6QxLaEGeRxmwHFLasyx3CcgZdYy0n1S34S0ra4sVtFMm076y2sYJYpIuRzzQysE+ULrlqy4o3ETNiZWaQzwVc7KYO5HZxbfPxJfZGNETaQLCJZBIqqdVNrjQ/vHgfFTO9rFBUc2RlDaRseZ8k3UyG6bGbgL1Lfa0DkVAK72g80+/ImKIEsbbnXEJKlQp1dbsvVFBtXhlILmJiilGDYFXM3Xhs1FRxqqSCKxauLF3AQmGgPVVqacbSFj52fmLDYs75cbPzGPcPapYfU8WA71YosehvDJGxfKmUwAgK8QcLPqt70S2o4xE0aOn2Vf0Y4CnVUUPzYr8LnWNe9FVtkcXHLqBbtp+iYwh0n008c9F7BBmtLszqHgsxtBce+HwLPC9ASHW2YrUtcfXax75SCBKgw4DzPDW1csTKoRzs7K8mEn9vupj19Aq7yAPW6oVnxg5G/5BuoUy2ZMWibDT55pYdW/rR628JsIQFnBT70/8piSM2cJd82tmoBf6vVZEzK5v1OfuYDSpcA6h/4LZn/pHCC0PUDim4Y3ekfOP5I0CL6VubDXsqyMt4QCdbxixE8u8htVETdi+08LlNkpwr2+Q1m3eDRkBSUVhofRc74e5LQRkt8FCd8jbtFbZlRPHbjBA2pVsZYlxfyNDOTpGL+C8CWsU+EhGqQFyq2mdH1iFr2SOT1Z4eBqFWNi7p+MZijH2wzMKx3i1Z8COpBpLf6zNLqqnszXsvTpCsJmMlZ/Etyi
 qsKholvg
 pWYqggUW5/2YMK/HxZkGtOsyg/+0QvUuD/u14qfKKdwuGtt53BPI3WVuKb5cA6m4JW2x4oJNygeOzA0u5DOr7yl6Rc30HgHSYdG7KDNTWZweMVnlfg1FgqeduCtPRTfDS6+1RtIALfIsWnub9MOlqOaA25LNBAdzyxkP7T3m9Rn/M/ysuN9xDdnXD9scWgz6DQ8TAv+OvSyaabX/Cqqi71H3siDUWjSgiAZmbts1IwyD2qZdBuUDR3APJwVJ9ZnrhkUDptPtHa5nov8uGNRHZueHpdyn9ugpQEQXU7xy5b8hoJcinZdDtRwcWm69aIjNxt7thy3O3WLKn7LVkJfZCfM4UB2AOv+9T2o56o87qfwFNn6KSmH6MFO8bWIJ8wox/i4GdWZIcL6nzFxIGtoS4+qT4EZynQeAchvmuYEQ0dhGUqjRO8FVmCpfdgmXKwNiGMNfkRiPFaxf1tVPEh9x3pcB8G4EtpN4h+3HXYKW+HI+fR3AX1GNQSMh9D7LNVoju+PUp3emnkd0dh+U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 05:51:09PM +0000, Brendan Jackman wrote:

> 1. The collection of APIs that are specific to userspace pagetables: mmu_gather,
>    mm/pagewalk.c, some vm_fault logic, all that good stuff.

I have done something for iommu that has a very general part that may
very well be a useful component of this:

https://docs.kernel.org/driver-api/generic_pt.html
https://github.com/torvalds/linux/tree/master/drivers/iommu/generic_pt

There are lots of things that need various page table algorithms..

Jason

