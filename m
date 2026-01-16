Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4498CD4899A
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 12:19:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72FA16B0088; Fri, 16 Jan 2026 07:19:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DDEA6B0089; Fri, 16 Jan 2026 07:19:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B5706B008A; Fri, 16 Jan 2026 07:19:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 484D56B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:19:56 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E5E601AE8D2
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 12:19:55 +0000 (UTC)
X-FDA: 84337733550.10.5E30893
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 481CD180009
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 12:19:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NLDqW3um;
	spf=pass (imf16.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768565994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N27lR6LD8aLrpqUY3jTvrBfxTbUYZ+iLvKoUwVGh4p8=;
	b=hjnlGVio4DcMKLS3skmC9vjYJ2jSzJgr8b0OE0IT9oVW/qxDoFCcnAgnep6WLVHghWXViq
	CTbf6f1Tq4026vL92c6DcS60lFzA6C0PF3JDhxDqi5+6sPQPbd+o1mBGVj7akRXDw3diE2
	hW7fgzKdLlf0LKDQvu2zQLQgur8YBCA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NLDqW3um;
	spf=pass (imf16.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768565994; a=rsa-sha256;
	cv=none;
	b=kHxEqyiWF731bvJQ+RyWAa946ZQdwGKL1qZ+bAN0Cbrj0tEobNrwt564PrHB7bXX7x9KVa
	4wwY9QOPMGyKJ4PeI23gcOBy3YAIBp4i3wR/8KldN8CU4eGW9fTGeDw4vuUAvkPWvPZCbt
	7UlAVO6Ok/Qw0aouKcuvnHZDSi0MCYE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DECB4032C;
	Fri, 16 Jan 2026 12:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA661C116C6;
	Fri, 16 Jan 2026 12:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768565993;
	bh=N27lR6LD8aLrpqUY3jTvrBfxTbUYZ+iLvKoUwVGh4p8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NLDqW3umKUH+oTSWeFot7VEADoh18cZVilBpn//cNgFD3fP0Bxh+2ORvBW1B98Yst
	 GB/QiuV75BD/IAJzSl0SjZ5nI8Nf35O63pUOq3j8tLKWi//TNDE6XNb/iuAbpIaiTV
	 L3Ky+yG5G96EPeyo3Rmhmi8oDXcvMZVsjShSrYq8+B3dvzeIzrFnhM2B6oc4bFmMBT
	 MH1ib2aX1LQSJO5pvg7w3fWjAATy4D2EyqR6051befqLmQKGiZWfPME/S1vX82U7+w
	 yX20DDUn4pt6fugT9hFrKeMcdmd84MPGKKZZ9MLThalk0lScIBzxAQP4uWB9JxNNHl
	 put1nqc2PqCnA==
Date: Fri, 16 Jan 2026 12:19:45 +0000
From: Will Deacon <will@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, linux-mm@kvack.org,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, xiaqinxin@huawei.com, rdunlap@infradead.org
Subject: Re: [PATCH v7 0/5] iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
Message-ID: <aWos4aIxKpqWuHoK@willie-the-truck>
References: <20260114164322.787125-1-smostafa@google.com>
 <f3ab0156-3d7c-470d-9c1e-922195ea27af@linux.intel.com>
 <CAFgf54rVPaUgbouXWQkczCyFQvXkrei_x6FYY6n1X5NkSSwYfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFgf54rVPaUgbouXWQkczCyFQvXkrei_x6FYY6n1X5NkSSwYfA@mail.gmail.com>
X-Rspamd-Queue-Id: 481CD180009
X-Stat-Signature: zndyqd67opzbpryb77re11bzracteo8s
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768565994-660447
X-HE-Meta: U2FsdGVkX1/5T3rUiyQzW7+VqlaELFoeFAKRSd1wFmH4yXxoA2SfRWS/eheVDq3F0av/COcdGGqWQ01aQoBYI0dUulTKZpXn9ZSRejWc03l+ueCfhNhHiBfCR9Eo0pPBKLsja2IOnQs3Oz8jIWFJdGzbZVHwiRGLviOsaASTZIYglQIOc7xHBGYMtZqYWpVs7TiX54ssmnTJABV8mkgeHRsGPdVserW2Z7c8Tx99gqsU+4PZvwF9vQIwBEjn8VvgsLpiHaY084/B4QwDXZhaIun+WXTXwS43pGxBembxuRFtqchr9Ptv0luMYt46TVzHsk62CVOtgKKnWD5+zW/Btl4c+NDp1lyayTEoGE0OC+sHlnyg3tSs2JKr4I24lEDPf+se2WPUPyKCxoq2EwJDRN0inJveGFOqogflumlWPpFpfn84HkpUaShY9ICzpa0i39fbU9Hz9Ec1vaevePS9+qSGbqZPvdIAaO09Oy4WlwepbS8I+/K+Eh+k0VZpElX3rPuZB/HFMO9wDTHW6omjmEB2diB4o/BJ3xICcCnftca3sLXTfXG6UbAqNPyzmrWmeUdE7JHuHZsDWoKM9o+8WcTDJ/b4fz26QJ4JOSWqzm10w+LK0qakxxIKBGoYV1vaL7dpkj28biq+FOE6OeJFlXlNjMbZfwoiB45wm7EMVUleDR0UaGKRtAvxisjDAAKiKQjZny9ymILNjSbDC5tNFnmAcMAtQgDE43dLDWZkUzDZesgFAi/siSDX6pGHDPdASs891ziaNMh98/scaJkkXKxeAftWNUxiaGd93D84wvvzY7jHVGYVBi0SjXroTT30OGj7Ubt/YOZp8g1D9QvpBlNYF+OHZuQa3z45tzsIJgeKix+h0uuwG9rzQExH7lN/Shy/bGxdknfk5yXtyjpTJ99n9IXkmPEKyVT/n+7OTzFXIyop98Wx72pwYrmvyUATVejbJBwiVC3b/jkNLa5
 bkoCAP9k
 u6RwaWsn3KFk1/ddLmSZEKwijfnbHa/yy6pGmQ2JGC0vxHqBc9r6z8zzsSQ3tZvmSQkO/cgybh8HoW8aOW9t3j4IElDjjbcueslwL76eOyq+UJvKDW3YMMDfuEXGWEhsWlPqsqcj6SnJIKNQuPSI4FRrT/AwdFIwNCCxrbB49bN4N5Tvf5Fjtt1WyeZS3A7XiP+e7gK/wxi0JyZfqTQqhBo9wAZHKaecGw1G/vpDYRRwJ2V4xqO175ZZu3ezVud0J/HnpmHGB4qc/cclxVxKEFJG3dbwmiUOmprVItu+LzNX89p2EcAi2DIVFaaNoXiyCOX0A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 09:08:42AM +0000, Mostafa Saleh wrote:
> Sorry I was travelling all day yesterday. I see Jorg hasn't done the
> pull request yet, so I was hoping we can still change it.
> But I can send the fix separately also.

iommu/core is a stable (non-rebasing) branch, so patches on top, please.

Will

