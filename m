Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0B3FD46BE0
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 18:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 971F36B0005; Wed, 28 Jan 2026 13:06:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91ED96B0089; Wed, 28 Jan 2026 13:06:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 800E16B008A; Wed, 28 Jan 2026 13:06:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 702516B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:06:34 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 089EA160799
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 18:06:34 +0000 (UTC)
X-FDA: 84382152708.16.422EF4F
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id 14794140007
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 18:06:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=FEUEfUdO;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.175 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769623592; a=rsa-sha256;
	cv=none;
	b=Omvnr8MSK+KBIgjIzqmP9t0wRUUi0bSxoW2rL+vduEDz/C2oboH7sfXvI/vkJeaiYpIYRx
	CdMx18uqIOtxHtr5o10Lijj4uY4XREGUjYpygrTJ1l/Kf9Cgyi+zbnPMqt82sBEWsU9LSE
	je69fMwB7PTLsmyMmPP121EFpmh41Zc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=FEUEfUdO;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.175 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769623592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YaIZPczUt0JTVA89TpBrq/++CRfdlHNIhDlOkzrTVzQ=;
	b=xBCq2v4/2qt1rB+EaaS5ZrlJsd/sHgmewBoCI/CBKPEn7b8vwJj4WKPxG0MX1lMJcMJlg+
	5Plvdg3nbxA9r6GeBz5ckwjzIj9MvrBrihAHVIin9rsPLOIyX0wgf8F4wRt/3pwkMJ45TA
	yFpAo49rRZA9tXdLvGa+/Rb9rMvZhwM=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8c70daf9c94so19540585a.0
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 10:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1769623591; x=1770228391; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YaIZPczUt0JTVA89TpBrq/++CRfdlHNIhDlOkzrTVzQ=;
        b=FEUEfUdOCunXqYaFEyiCcPwXop5mXIKIAXO+Egdd25LmZuNuehXpKZMb/XxnD3eL8V
         biuFRJvEek6hJXJROkO75u7r2F5Jq1O1/Bm6wQh4Ptljft/Y5+ufriUiOeJ6hieMDZK7
         m7aFRYA/+GgabBai/8e2e+iEU2x3oNT/UABkYDFOBwj0Ov1F9oCTdSvRHw1W/pgBG4vv
         SvCYcepYWZso4ykVqYGskccFEjlmDKd8kc1Sxjto125FFKBrx8ZZCaBZCMpTo2UmbRPI
         GNK1YRMiX36N9+Rllbp400YwJn5H9/1hnJLTU4DsRP4lZT75j1ezLEAktg5yZeTCfCr3
         V2sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769623591; x=1770228391;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YaIZPczUt0JTVA89TpBrq/++CRfdlHNIhDlOkzrTVzQ=;
        b=Qq8t3D6PcN9IWlmbKzFhO+4DwuVDiJZhaTiMUOFrINf3AuzzEQ5rii1lS/T0NpDwu+
         rZlBy5pxsglB7ksdUfCevi/Kbk0zBLhmSsTuRrB7fxaFNZrsaj5yCxGsg1fOU7ya5UHM
         G54UnOmVWQfOkYDyxIRyDBwY7jEqrH4jyDVYdC+uQ2BxYwQIDBkJ76B3u00TksAvdZ4z
         HUpCWaf6LQABwiyKLjqZLdq46CLokf1BPCHqY20vCDyu6FnA6sSqEGbCJcwTEYgxzLhB
         HHlAdpzYZz4kwGCcJPYgSDPfDzR+KB8Xg7Ts9sUXx1eYnwmzl/O4S9aCpA2L+k2x7wcJ
         Y7ww==
X-Forwarded-Encrypted: i=1; AJvYcCU8P2dJAwb9d8el2F4F8xj4zQQWftZOxP0+FBqtxCmDcn6cxkK8+XRbcfctc/n2Cs9vgx5sT9DCEw==@kvack.org
X-Gm-Message-State: AOJu0YzDR1jvTBAuZ69YjS7Wwp+OlvFVnQZbgRBRrGNsrh0u1QMuhjLT
	DntGgUmUse8ufAYZE0TLD3AoSXsf90qvbxhty5GphYiywosw1HQhUW2SGycWFaV+fGs=
X-Gm-Gg: AZuq6aLazEykYOtZ6/fz8xhjtpX9T4aBWNkeSBOrtbUaDOJWGPqu43UrOtzzvdMGYPZ
	IhjImhhokWIloZhaRXllSsuryPy1VVnEdmQBN21e7j1gutGAPAna4GAr/rji4HIO6g8/QL0Ot6c
	46Uqjq6j9qxl6wDk6aWXMIh3MHhE3Phb10ZMdb4YIVC18hi614tNCPiWxcCOdk53tljBdjvm7XL
	4FBtYOH2wwxNuD5M9VQC2zw3Q6CDHw+CyHyXV3sDqvoGqi7KMwlkTA+iNSji8eWuhgyXIFTNxZm
	IBjrMFUgx9vq/6URx3mcl4P1CvRSEPTYEIqZW5fd2Q59pfBwxpMD36VloFo8EAlAUv2kDJ7tYoe
	isK9NVW420pSN67LL9Moa6II1UFvEnt8OSo4Bc2xc8Vr861XSqkBweJ+AxJ7DIoYa2PYv9lvsur
	XDPxR5EN652ypTgL0pDiNlSH1HpU2UclZScyj1pKTjfGir3ZKCEnp/w0ziopDoudaP4Wk=
X-Received: by 2002:ae9:f404:0:b0:8c7:136e:bad7 with SMTP id af79cd13be357-8c7136ebb3cmr341643785a.85.1769623591045;
        Wed, 28 Jan 2026 10:06:31 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-894d375ce71sm21598586d6.45.2026.01.28.10.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 10:06:30 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vl9vx-00000009aHB-3e3a;
	Wed, 28 Jan 2026 14:06:29 -0400
Date: Wed, 28 Jan 2026 14:06:29 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: Leon Romanovsky <leon@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dust Li <dust.li@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org,
	oliver.yang@linux.alibaba.com
Subject: Re: [PATCH net-next 2/3] mm: vmalloc: export find_vm_area()
Message-ID: <20260128180629.GT1641016@ziepe.ca>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-3-alibuda@linux.alibaba.com>
 <aXPEFdEdtSmd6AzF@milan>
 <20260124093505.GA98529@j66a10360.sqa.eu95>
 <aXSjm1DXm6yP62tD@pc636>
 <20260124145754.GA57116@j66a10360.sqa.eu95>
 <20260127133417.GU13967@unreal>
 <20260128034558.GA126415@j66a10360.sqa.eu95>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128034558.GA126415@j66a10360.sqa.eu95>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 14794140007
X-Stat-Signature: bb6dcakdamrypmzofqn3iqsqgnnckj38
X-HE-Tag: 1769623591-5708
X-HE-Meta: U2FsdGVkX19umIB2yh7usPgmzyhYv1KNCrkkHK5eH2vWQi9oQsmTHuWOhH3aCQE6FJBNErIet1L2aCdD7924UW4xZVC7lZK2xdLauH9X9JZDOOLZ2x+Dpv6KNsx7C5h6NYa3/ktuPhCyXl1A4Csj1Rj90okTqRLJHUt5hgWhwhQXWBfRgvJOKJnq9qaN/mbLfYFGIGPtLY1iS8pzmPAJR2LcAJDc1MQZsPcUepWdB+qQIJCUQN7tfxH2q3+2RScHZ4QvTun4PgU3q2JoCtUS6jnEw7nn+2NQYsCsq1d1jztk67YNkzlFJ3KOm1qzNrK2OuViaSwG6t+rdchQkhg4lTtTs09dxxyzn+0aLvhuzHYeOTYHQIsUw+g6iD+Yi2sE6AHgRHQeH03UEf66Xje+yzycm6Es9rrAyPV3jW9f33Gu2snsyMhXpGNoIp9ZKPR+Y9MRR4NsdbjzEX64UaByzA3znGGeRTMhs/e8TSdVSmgQdB6Q+nWCQShn98MJaE0eT66Ar49QnE4Gk/Y/IsEk9cORmSvsHu3c8jBeSWcypErb3u2TfXWK+9z+dRA96MXTmIL0yZDn6iXs9HElujbPqZdvhT2ibWYFPHfwDlp6Z0QsXmY78IJ8i4rijTanZsbAoaA8TDplFjTIRia6ygKQsMjNZMVWKeLFIFsGMDF2liG61jO7mICHARpQjFxYKVuSxSKSl4sHhXg2rVT4UH3wAi7vWNkERr9jc4M7Of9wpTIRz6eoedu7JEBbOIlQNK4xsQ+EHtr2c4XV2CDsQoYjv4QFmoqm8wuKmOAd6LCzDB6UIF2qaqtFoPLvpVSPuX2gmn9xzgqpI11PvUSDXte5uPgf6kFR63odAVLhQ0e3HYHvwQx3mXYGzTNB9ZYSS7cC9q75WWheFrldeHtmNmLG7l4RA+Cz7Y71R3Fshh1ELpxiaSxtEEatKj/s2GMWbKfCPQsKOqrzOOPz/mjbZGi
 nYrJUOlD
 fiBk3xikwIcChROJPWU/CPKoOQi6MNAU075ZgjqMXuwkwEGTrYXvVKxbuekz2mHZSc/RVvsifdfuMJKvg+ztsVxmZ6Sch4E2MyrmueiWTA0OYNEyIli6RbbwQBnv3Usfpb7fb3WNhFJ5sP497cT8OiKSDV8Gkshi5UxzY6mQZcLagCi7EkcId8G2paff1orZ0ZVQAcacoHSRCnC7HFLYxnkAKdm2pAUbGFyGqpRhheUv0L3bhRfHj2VEgdPEJsly9gMpr1ZoZ2OgapDSjE5AHs97K1H6VbGcqU7r7zm1dU3mpLwiP1XAT7dXyGw5Czn4ehfoVIcz6pZ57vqY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 11:45:58AM +0800, D. Wythe wrote:

> By leveraging vmalloc_huge() and the proposed helper to increase the
> page_size in ib_map_mr_sg(), each MTTE covers a much larger contiguous
> physical block.

This doesn't seem right, if your goal is to take a vmalloc() pointer
and convert it to a MR via a scatterlist and ib_map_mr_sg() then you
should be asking for a helper to convert a kernel pointer into a
scatterlist.

Even if you do this in a naive way and call the
sg_alloc_append_table_from_pages() function it will automatically join
physically contiguous ranges together for you.

From there you can check the resulting scatterlist and compute the
page_size to pass to ib_map_mr_sg().

No need to ask the MM for anything other than the list of physicals to
build the scatterlist with.

Still, I wouldn't mind seeing a helper to convert a kernel pointer
into a scatterlist because I have see that opencoded in a few places,
and maybe there are ways to optimize that using more information from
the MM - but it should be APIs used only by this helper not exposed to
drivers.

Jason

