Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB4F7105A594
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:34:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37FBE6B0088; Thu, 12 Mar 2026 08:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32D546B0089; Thu, 12 Mar 2026 08:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22F8C6B008A; Thu, 12 Mar 2026 08:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1098B6B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:34:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 970641A01F6
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:34:40 +0000 (UTC)
X-FDA: 84537354720.07.880A9A4
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id B850D160012
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:34:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=YFuAPmPJ;
	spf=pass (imf08.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.170 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773318878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ULg7grqreMOX2MMOX7z3yI5zs+73GrCTo1UP0N+hYkE=;
	b=EFVcZzVzb47hkQVU9BBslpmP0EekJXfawuon39XAf4jAoHkIPKhE9I/830rUGGliuMVEOY
	DH48M09+9HKm5OFFxbPtFdJdtuplVzcuTuM9sOScYq4ytUcOjH997msEuIqoVWla1pMEeY
	Rx7kBwz4hLjw6B5tzab1WBN9fcHDePE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=YFuAPmPJ;
	spf=pass (imf08.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.170 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773318878; a=rsa-sha256;
	cv=none;
	b=iVyl5yB7bMCGbj6W7sElzghz7aheXP2eIR87cb1tFyUJf6W8x64TT1n3q36LtyvW+m74xW
	6dTGOjhIEMLP8TN1Ie993OU+iv9wVFojxA31qlUrKH2dP6gFMnFuIoKlyRu9V/4mBpC9wj
	XhCqr/ce1siZl4ihUS8yspxAfbpKINE=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8cd858e860aso134835985a.2
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 05:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1773318878; x=1773923678; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ULg7grqreMOX2MMOX7z3yI5zs+73GrCTo1UP0N+hYkE=;
        b=YFuAPmPJWa7wugsZrS9BCl3SM666jAjFNQ873szopB1fz7ZiXDtfJLnnaMlwsUwKQ1
         WRfakG1EKAaNU25IXgiEASlYPIBVDHALKQQkmApOih39jcPkja6PLdOMbGd51W2eq/E6
         I6MhDwofa/9y7RU7jcCzXlykHmGffvg7MOXucqDlWJ7R1E39eifVS3YNk1JzF0WymmEE
         +AieTgFzeEpykEfstOiPjlSQPubzK06vUATZlkRmNfGFO0/L0RacgVkvaHE7MX9pEhqD
         3zAZjzx6mG8VWiYM87fhuv8ykco6N5CSHYou1LuiSVpUrGPKVqH20WxFx2fqjjrIIk8T
         sL0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773318878; x=1773923678;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ULg7grqreMOX2MMOX7z3yI5zs+73GrCTo1UP0N+hYkE=;
        b=A018eOKj4HM2uLSOaaKE7Ke9gY6ByXB9R+IqkjK/3KMxE64Ghz2OTn0fEOLfSSUVeo
         uAGMu7qYmkE2NIysNU95IGB7wpBx1lGFYjpBkT/V8XuqZtGoJ8IckuWjPLsHp2UBAsMh
         ++x2MACFeL3u10er9Af0Jb3ktksoE3yofQjOwC4QARNaKLCNMEQsPS+YI70My+uVZq0q
         gRx/Df5z/qVpvOVWkhYwL27J28cGs9SCawaoTg2OFv7yyukrNEMePlroCzGk+aRsMhIl
         sfGzaehRNzWc/FM3il1T9MNWxdBvGiSUJ/KBG/VK005l7WbaHHCls3Ai0K9eMRWaT//5
         sRTA==
X-Forwarded-Encrypted: i=1; AJvYcCUeBYAYYy9SG9Q7Stl5d5LSjMJgS+EC6CXxyiRXaQ9Gs0ckt0lhsNnp+Q1mI/Y+ObbT4RUF3PVVuA==@kvack.org
X-Gm-Message-State: AOJu0Yy4yT5HNDbzt1quDGrpPAnuAhVuMO8EgCh0G02Kf6NyTLrt4UyZ
	9hKzeY1NeyknmogUKHNu1KSDZ19yY0CR9TCbQ6LQMu0Jw0FerBQKLfBPPwfSPbV7ans=
X-Gm-Gg: ATEYQzzj8oTE1JxieHk+q12psZfsqrUWncgOemztUTlpKHVMhgcR08trfgZLNXTfDVi
	3MW9/zcfmFPlDqlWICSotytrhiLO95NS5FQgJCzGe8qq2ugBX+pMJcoHWKmGYdMcaIT1ktpmJwl
	dI5CEKjiKiDv8kLHXL1CroZNYz51M/1rsmvpXrHjicj/aKOMXTiRGw0qvp+S0PJWrdoiRJb88As
	32kp4HvnkU4xclnQeUWPBQ/QOvB90DRtZIY1LW9p+vkvl6EOLbMctZKes9yd/QadXHxYtnF04Tm
	Ijbmar+Zvt0Mfl0mZktOlnhfzW+yMTrgsed2dekatZG3k52ITb0GfgXgAGngma1EwopL066NLls
	Hc8ilNiaM8kY9Sea947okCL5wEQinYoxrJn3xWFnXR059C3BKOrvrPqyYSc418ArZJKSGDKM6a/
	nKHjEhHK0gVKA7/jG1CBFJbj5gD8eq+3iZ39P2TP8+ybaIBCw4uXJjhZeUI7Pc5Tmv9r9UqWkZG
	0tQPHGr
X-Received: by 2002:a05:620a:46a8:b0:8cd:8938:eff9 with SMTP id af79cd13be357-8cda1936a90mr737651285a.1.1773318877767;
        Thu, 12 Mar 2026 05:34:37 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cda21346a0sm323887785a.34.2026.03.12.05.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 05:34:36 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1w0fFL-00000006ezF-1zix;
	Thu, 12 Mar 2026 09:34:35 -0300
Date: Thu, 12 Mar 2026 09:34:35 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Petr Tesarik <ptesarik@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev, linux-rdma@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 7/8] RDMA/umem: Tell DMA mapping that UMEM requires
 coherency
Message-ID: <20260312123435.GH1469476@ziepe.ca>
References: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
 <20260311-dma-debug-overlap-v2-7-e00bc2ca346d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311-dma-debug-overlap-v2-7-e00bc2ca346d@nvidia.com>
X-Rspamd-Queue-Id: B850D160012
X-Rspamd-Server: rspam07
X-Stat-Signature: f1ynxj9xz83dq8ryw6o9j8nc4nn7agpd
X-Rspam-User: 
X-HE-Tag: 1773318878-911051
X-HE-Meta: U2FsdGVkX19RmNqW84CrQRxjPKLhxRUzi8u4Chm8Z5u6yT/dDxitEbopyOq9wFRHJWQtgkcsFJ37AxcWPSRHXWpwKQpYTx3EMaclOeKaTqyCrvHvQrNi5JM5WALJvF5b3G29Py1l6Ldg7YGUMh2yF6iweM8lDa160HrbZLmXqec7O/TPoIRh5ElShMX9MqzU5+FxgUcZho8snCYZrcGtRxaS8HdAS+uCpUfYu6PjLZH5rtl7AQND91O2kiy1rovtt6y9rGIt9RMXMNu/gsmqTYxEtgz6xcEmYQhu7KGZxbyveHxjVqe2FJgT7lmWS/EBUw0T9y7RGXpYXNx2QFv7+DhjM3mQQxjp1H8VlJH4JlV2zeLgFaksSLUioqL0PDHLJ0Zakg9W79rUjL3L8Ttw77d9oNlSRgiEGRnh1U/5MuO024eIwHL8Bk9qhRtIUarWBmmVLamMiU4RKgRQMHMf0qB+c85lBJlIg6XKbQwu+TccYFYFRQSJfTg6As9ChIqtJkhhnkmyiEhI3Hv7N3odZXJCVet1Duj258rpZrRaSOVW07n3g1RWzybuUISzpj2LLiCDt1yCuPXcQkH3zrQo8biWMqM78fJxVrDduEWzs+8d6svPSP1Frlis3QA+RgUz24WMJRexmePLU3Yd+9uy29m/c9jjlCcQo9hTz1XjvksRXnaZhMlh/Qlik4+GxqDkuHrao8uE6dRufPX3zOWhlIeq6ICMwwRHA4wM7R9QQF7qxmmcsPmxB4WqtHeK90XBpli2r7A8KVBDSpku2tXLEZvHFygmDaalpZZNJrLyDCLuBehwdfYTqLVLCSoPpF3T70QsWEd9L6WxzkD0dTrolT+nUZdccb/nvalMeQpNGg3U/DVU1Y0iibcghD6Kx62+UN+eDrZHr8A+HQapHYu7Ovi7WFwVLs3uig/Sac9T0vS7/T+0vXJZjy5TuFW3WjiS/F8kQkJWKDyVFM3Ma4J
 wRue+0Ya
 eB2MDJ0iSMHu2QTXf5rcj5oDrOPBJQPcWf9kDg5+SiFar0RQe+DxoZprmg1ADyucmsRCN2SimoQnRTBrZxzfBYE6f1pndJew1lGJSv1ghUa0u2sExLkrmQAXzEY4jrE+1Li0zimT9LbFU/FM/w8ylCRRgKqJmiZpsJNqRWjCKsqBWV56QzUfI1uRoghDdHvb2HyyVUdCYzhqeiz9r4x7GSNqHfyC+z8PxuC9d7AFzKIX1BUaM8rVLKlAPF9CCwHSqjbBKQZXRJb784XhtMNRk6uLHjNetbflkzOpuWKEN6bThu7Zc+Y2CdjtD7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 09:08:50PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The RDMA subsystem exposes DMA regions through the verbs interface, which
> assumes a coherent system. Use the DMA_ATTR_REQUIRE_COHERENCE attribute to
> ensure coherency and avoid taking the SWIOTLB path.

Lets elaborate a bit more so people understand why verbs is like
this:

The RDMA verbs programming model is like HMM and assumes concurrent DMA and
CPU access to userspace memory in a process. The HW device and
programming model has so-called "one-sided" operations which are
initiated over the network by a remote CPU without notification or
involvement of the local CPU. These include things like ATOMIC
compare/swap, READ, and WRITE. Using these operations a remote CPU can
traverse data structures, form locks, and so on without awareness of
the host CPU. Having SWIOTLB substitute the memory or the DMA be cache
incoherent completely breaks these use cases.

RDMA in-kernel is OK with incoherence because none of the kernel use
cases make use of one-sided operations that would cause problems.

Jason

