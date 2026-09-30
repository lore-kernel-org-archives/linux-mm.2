Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86E56CA5FA5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 03:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 119C26B0088; Tue, 29 Sep 2026 23:08:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F08E6B008A; Tue, 29 Sep 2026 23:08:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 006876B008C; Tue, 29 Sep 2026 23:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C119A6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 23:08:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 36F5316066C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 03:08:12 +0000 (UTC)
X-FDA: 85268944824.15.92BA3A9
Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6B5D51C0004
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 03:08:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VQoycwsN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790737690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tADa+gUpKB6hXrMlk4JcdjCrfBHR2QIQ4vRaRu8qGQ0=;
	b=aBuQPFLadoYAtYV26tMZkzKh3xAyfrelczm/GxqLWUqNC5S//XMPdpr6Hs+UK8eApnk6ki
	qXUriekYGNRa4A6ng+v7ozHHZe2QukRQ3KgCgqX46BUDm+b2ImgfZp4UXPbx0Ovle9KRJS
	PdOVSJjN+mVJ1u4mCRgMF7YCIIPjAd0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VQoycwsN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790737690;
	b=hMHFXaRiP3Ve6GVITaZpR9a5vvIQApcaE4f136ZfssapX2zw4kX8a5DhAVy8sSA4CwIJoL
	+lpS3TuKQYxxCWLTJU1bBbFqQdaM92Pa5zqubfhP6Urga0v9TbY8J0yp4+FaIVWRnZltKW
	+2uVVChmC5qZPIk1/eNZE5dUkvAZ++0=
Received: by mail-pz2-f42.google.com with SMTP id d2e1a72fcca58-86e6d007703so2278746b3a.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 20:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790737689; x=1791342489; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tADa+gUpKB6hXrMlk4JcdjCrfBHR2QIQ4vRaRu8qGQ0=;
        b=VQoycwsNpXrNz5EgqCufZOb69SH2lgPoVadGNlHkNRKa02gTO6lgbkVEYNhmsYnYJe
         UbRz8lKihP/yNMtRyZbskdJiN5X1kb8Qx3uQU+5sqGhhMfuZyDyMlSpmRvmArevU2ZpT
         UfmcLPi7j2LBbgcW0Rw9gq6BPUiIXbxYEcb6R/5F+ePa2eGvZ7PrFzUxTnjyAe4s/Kll
         oHx41I4mKM67sVs97ierISlvngZ/oUS4anwljtR+QGdlAFLTbLzXZCaN6navIJIABxVJ
         cNlWzELwDmiMCDUUQcyTX1OaJ0Iz3oD72gxznPBlo2xOQ4Lp5rANSiF96hLrnJt+6tDT
         weCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790737689; x=1791342489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tADa+gUpKB6hXrMlk4JcdjCrfBHR2QIQ4vRaRu8qGQ0=;
        b=wogX5Dkxki1/GLqOXw5YPa1DCFPOPGnufhFOxJ2KMvtrwMmC+0vtxW5EOs35n/2sbw
         8WWyQKzR20355F2LT1zG4s1l1sIXeBm69cJ8L3y8rlwqzZftp/VlMQCKxsynIG9NZYZ5
         WZT8Ln2C33yr3tggncC3DEyCmNHXIIjYtJIaIHz4j9iXaaEy2pfy3R0A/01KE0yZLBcs
         gE7ps0waH8cVA3s3X6WmeKzj57g3kFB2mXWvwedPj9XhcJBSw1ErSykyEW0Vh7FCuhQG
         T0hGfDHvsTmEGfBy3zCVz6ftrY5ZP2r65hNlPMFrpmO+8f33YyaHOtW1ksv4f29/cHRA
         bp4g==
X-Forwarded-Encrypted: i=1; AKwUvByfDJTq7wMitdJPNeCFolBlIuSbtosyLQ533yFysQB6ZxsiN+UpnVPfCiYDb+oH/M/ZDLMLEb6Ryg==@kvack.org
X-Gm-Message-State: AFuF++kbXdMd8oLW/jjYdrNeiYC56zaSA0UaPeiO8H7pdyl5zRpdSC47
	gtQ63vzSpafDa+/05W9ebUEbBRNNhtnNDi6VBmzYkvAMOqRzrS3oCyDj
X-Gm-Gg: AYBFou2pqYeBwT+hw1f1xwWWN7RXDN/yfXd4BjCS1FZaOT0He+8ZGdfplq1qWySJjl3
	srRCE0vWMJxStroh7w97Rg8g8yCwLPlaz8XLJgdFGA4LnjedDsPY3tr3VVNLiBVRIDx7uYbv/rN
	L877F4TEjU0dZjDO+QvVlwswwScJDDOMGyXziYtAiJEAf3yh5kVNZxQqWw27PUIowzruZtelu2O
	JMS8lt1oO1ankAF+fN8CAqTtos0wMNdZm3AnrEiyVCz8S4aUgeumRN+NZFTEYw+BhNq4jUiDwze
	ctohKQiWrxrHve5TnSx+PSrICN/tezytsG14IESwJJyyvan7i29n+ySjK8WdvxagQriCJxWP/Ba
	TgAGrB7AHjFkkCNeiBpVmCx74VDJN2yHEbvLpiNBjysrjPgnEjRXRq10q1eODnF0jUFHphHMHw8
	jhngoF+WG80SRcen2vn4aMZ8/7bqV0ANVsg8mTh1LCZq7kQs1a7bL/iWPw9H3rQm23tftd8m0jU
	SnUmrxHlWMBmk2be5MZxgXVMfg5Izy+9g0RvQVD
X-Received: by 2002:a05:6a20:a10f:b0:3de:675d:bcec with SMTP id adf61e73a8af0-3de9e844603mr37737637.59.1790737689067;
        Tue, 29 Sep 2026 20:08:09 -0700 (PDT)
Received: from localhost.localdomain (vmi2317699.contaboserver.net. [85.239.239.237])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88722f72dc5sm101341b3a.3.2026.09.29.20.08.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 29 Sep 2026 20:08:08 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>,
	Jialiang Huang <huang-jl@deepseek.com>
Cc: lance.yang@linux.dev,
	KunWu Chan <kunwu.chan@gmail.com>,
	baohua@kernel.org,
	damon@lists.linux.dev,
	david@kernel.org,
	linux-mm@kvack.org,
	mst@redhat.com,
	ryncsn@gmail.com,
	virtualization@lists.linux.dev,
	xueyuan.chen21@gmail.com,
	xiang@kernel.org
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
Date: Wed, 30 Sep 2026 11:07:29 +0800
Message-ID: <20260930030747.47294-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929165603.49436-1-sj@kernel.org>
References: <20260929123241.1408414-1-huang-jl@deepseek.com> <20260929165603.49436-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6B5D51C0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: k8gjjurqccomqdoyzd18z631ob1oc3xb
X-HE-Tag: 1790737690-910414
X-HE-Meta: U2FsdGVkX19BqEt+Jxc26OMfFqqKYhIHx1NDu5JUicivuG7pvPKurqxrfDozYRVKUZTC7a3Mop6IP3KdVShqyg6IlBbBEnIXRrmtZcFPRtX9zD1dSVSYg1/WkfxFwjVHStS/gkzgGQ8aWboV8i0GoBhc5CLsvAsdtJqevp8rlLm5ga9RjBgGTBIOwUMFkb4m+aNYaEN4Yh8i/7XaRtK6qvTIvUeUzEmllRya5b4m+xLuRK7DsJT9/5q1Q1UtzunNTb2/bYSRDmSshWeWtTX9vtlzw/rWMw4laUR+06f1XX+XeQ5998g7SZrE9O8Z8EHWOp/1LGN2hSLBUcYh3uug16ckJYmdSdAwwRCqhW89Gu66EJhtLdpaVWt1UN1zurXH40/0psVkYnY8REEwY+1/s08nBJ7j47xe+zHa/+1pZDxpLgMWHdDs87XYsIIgd1WWyF7gPP+eHU36ocpRns7tRLfKOs2MEf30tEmSECf9ER5gQz5uDpchVoBotNPyeNnUx8m+0suS8Zerw8eZbBtZrjCESiPTumhjtWGzwOD/2RYPgaClaZSDIi762oRuKNDdynjqG1XVBlVengkSZt/rKdaLUc90/Tupp6v3ON6tpxCC09qlX5b34qM1LJXqd6L90BNnbX2Xb3uSvJG6cDU+oC6EEGTqGUzhCJjcwSpuuU+TQRvMDVFV/IWkojOSTK6j7gOaCzwHoocEOGqGczxtBtnnl4P1rEeQX3MaakrItSXqTIhYqzAJL7TWPf7EqkQBGQhnJ9mqS+ENmEPWc2R9rdzfSo5mxEfSuPms0TFYWGS5OuU8LzHSrdDP19cByyVPudFskALSnagigelL2PT5Wym3zKUEDf6KtaZsLR4LL4S8nCpN6MkYHiTHremK0HmR3TX3hZOegbXb4ko47YUqFCai/hCDyVBCxFmvyJEKNB5f9DjdxP40hWSkr4GjMeXCK++LRJbruHqeorFRBK7
 fJCeNrZm
 dx2s+EIoQ6wem0hbcKJegbsxt0YRz4As/pR0Q9PrwwghKYz3Wmkz58HD9iTvkRlnHZFkX56nIGQnA4ud37rE1971aj9H32GacRe2ZGubiPIW91CdD+ufAFDpzvwgNBUCAtCARuuvu6tTsNqXSfsd3s0dcDrN7FE+yEFs+HifEVo69htY8Kz+qKA3kq02IOk7Tm9mI9k2BRSt+CPCCe2ZUzvhNsH0ioa6arpC5bv6ryMEUARNj4MIQoYN04lkAHs5OSmjcPVpFtv0hn3UbIfo5Vlfv5soZgI7gn+yVimVdsqT0vfV79MCqRXLqWTZvNPVWRJOxkjmw/7Uc8WEbc3iZ6ouUjt+JQjIDwaQ24ABbPBuEBSD5AuvbROq8EKQJXyinIn43VYh4dseFIiwSyTSvSxXJGwjKVKX8KNAVsYbSTny15m9Xt7OwMjVpdU6EEuCu8LR/5dlsFFJylfcoLCOuqHhL/lZs8iNF/wBy2hG66berxU0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On Tue, 29 Sep 2026 09:56:03 -0700 SJ Park <sj@kernel.org> wrote:

> I agree the reclaim-reporting granularity mismatch could be a room to improve.

Thanks for pointing us back to the Access/Contiguity-aware Memory
Autoscaling proposal. Jialiang's description gives us a useful deployment
context and a concrete problem to investigate.

The guest reclaim/reporting case and our host-side THP/tiering case are
different, but both raise questions about how workload behaviour and
monitoring granularity should guide kernel actions.

KunWu and I would like to help move this work forward together, alongside
the existing DAMON roadmap. For now, I would like to share a few possible
areas for discussion:

1. Workloads, DAMON policies, and tiering. My current work includes
   improving masim-based experiments and studying TPP-inspired memory
   tiering. We would like to make the workloads more representative and
   better understand how DAMON's observations and policy settings affect
   placement decisions. The aim is to understand where configuration
   changes are sufficient and where code changes, if any, would help.

2. Testing and contributing to the existing PMU work. Our initial focus
   would be on helping with the Arm SPE integration and testing the IBS
   and PEBS work on x86, in coordination with the people already working
   on these. The experiments could evaluate whether finer-grained
   sampling provides useful additional information, and at what CPU
   cost. We could leave huge-page-specific mechanisms for a later
   discussion, guided by the results.

3. Following up on the DeepSeek workload. If the team is interested, we
   could learn more about the workloads and tuning questions they can
   share, and study the path from workload behaviour and monitoring
   parameters through reclaim and free-page reporting. Pratyush's
   reporting-delay suggestion adds another useful dimension. This may
   provide a practical starting point for revisiting parts of the
   access/contiguity-aware autoscaling work and evaluating their
   relevance to the reported workload.

Could we discuss whether some of these could become follow-up milestones
in the DAMON discussions at LPC, or here on the mailing list? We would be
happy to help organise the discussion and take on agreed pieces of
testing or development. We would also welcome closer collaboration with
DeepSeek and other interested MM developers, including Muchun, where our
work overlaps.

This is only a brief outline for now. I plan to bring the experimental
results and remaining questions to LPC. After discussing and aligning on
the details there, we plan to share a more detailed proposal with the
community and write up the planned work and experimental findings in
blog posts.

I appreciate how much is already on your schedule. We hope to support
the existing plans and help with agreed tasks as the scope becomes
clearer. There is no urgency to reply; we can discuss these ideas
whenever it fits your schedule.

Thanks,
Lian

