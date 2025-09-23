Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E544FCAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 18:31:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 181D28E000A; Tue, 23 Sep 2025 14:31:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131DA8E0001; Tue, 23 Sep 2025 14:31:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3C868E000A; Tue, 23 Sep 2025 14:31:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D93518E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 14:31:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 82EFD1405BF
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 18:31:02 +0000 (UTC)
X-FDA: 83921356764.09.75DD045
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id CBFEA1C0018
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 18:31:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S4ZXIaWM;
	spf=pass (imf21.hostedemail.com: domain of kbusch@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758652261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f74v45qTfX4rd0AIVdvbIhhb3jagTfRC+ZZltoOMjTc=;
	b=BjNNlrmzpro+mgVihELSYWr89Y6qEGY2RIP+vCD9I2Yvg1KRdUSn0jVSxv33qTpBA+YIwh
	J35jes0r03K2XLPseXaWDM0n09ZhYdiCDoQlY7otV9+9cxtIS3UewM9sYnK/h4oc9KJpsp
	OY/JKN1RWcIZHR8YsDpXyQB7PIe4ssg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S4ZXIaWM;
	spf=pass (imf21.hostedemail.com: domain of kbusch@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758652261; a=rsa-sha256;
	cv=none;
	b=jL/NGfBjTUPc5pvLG7HRHq4KammT/7UMsyxX9LkXR9UOqmjDg7OeEeB14XxyUUpbCdvRO7
	RYIkM+3qKXj7R3/3m2tzNzEcSIdOiTXc6yestSs5Ck8JNIxXzIsDNWGwUt5MX2bIhAyHmy
	D846Pdq4+mnMGc9rYrqNF8wFHFUhVbI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BC3A4393E;
	Tue, 23 Sep 2025 18:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB030C4CEF5;
	Tue, 23 Sep 2025 18:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758652259;
	bh=gxKH7wZVbZJUgsdcRmV6yXRnCWQ9TqZ9bpedLe1yt7s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S4ZXIaWM41Ablw/mVVeAaJkiSYgUA1XjiTWt5LSH4qwLIacOxMZE3jScnz0xix1Wv
	 SAp5BLuT2R2dCAYXxRdOCtJez17N/cBe9kv8+xOmcpzYoZ/UpcFkDX5GmNuOLJGCFV
	 Bcs4RLVyhjVQyFhRGAbe1bDHxUFJbKgGu/3vW1Mt1BkujhZ/XZn25PIvUn5jT3S9nw
	 YVX4n2lhWFpC/hhBuXD/s3h9/tXRxQArUIgc5V0sUKhDNiOC8ABgtjM7Q3+LQGe+ys
	 cSfhtq2Jd52bcQy4LLrP2uqO++/e9zs0F7UgxrbinfFgheCfADXwZVzyKQ2yU+i53A
	 XGP2nnt2Bp5Ig==
Date: Tue, 23 Sep 2025 12:30:55 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	David Hildenbrand <david@redhat.com>, iommu@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>,
	Juergen Gross <jgross@suse.com>, kasan-dev@googlegroups.com,
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v6 00/16] dma-mapping: migrate to physical address-based
 API
Message-ID: <aNLnXwAJveHIqfz0@kbusch-mbp>
References: <CGME20250909132821eucas1p1051ce9e0270ddbf520e105c913fa8db6@eucas1p1.samsung.com>
 <cover.1757423202.git.leonro@nvidia.com>
 <0db9bce5-40df-4cf5-85ab-f032c67d5c71@samsung.com>
 <20250912090327.GU341237@unreal>
 <aM1_9cS_LGl4GFC5@kbusch-mbp>
 <20250920155352.GH10800@unreal>
 <aM9LH6WSeOPGeleY@kbusch-mbp>
 <20250923170936.GA2614310@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923170936.GA2614310@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CBFEA1C0018
X-Stat-Signature: hyam6qtn77t7mcbt3uezsc8ue8symdm9
X-HE-Tag: 1758652260-428370
X-HE-Meta: U2FsdGVkX19zCnds/Hh7XsHD4G8fIlAzNIQ4SDrTXvuwI4FHceziRS1HTOuFCb4QqEU684m1019CqNULlN7tuU+7kCJSMavaJVyunOIJ6yi8cBv2OczCQNTFCRnKZcsCjaaYPXAELlOka+UrSOU0o9lLOn+Ci7JkzUMA8HCJ3LpFPyB4jAXUp5aFvB0dXpLSizbuy8pxntf2iRtlsTzhojgCLKRa4QiC89gi2Yzcf9vEt+7Z0PxK9hyGLZ3g6nqnqay1oK8bm0UAWe2VwXruJH/0In0r0iyJaSpxfKN8HkE1t7ehxfE8C2V4zsinoOcrie/5LQKuyt9XbAxuCIBvJDGqO2VlR6Ih47TNt1YVF72Nea0PSxsZTnbwSdz7uEVpzXybaVSnHLs1Gk84qEaeAvRfqwb1rppk/4YqzyeACcFsTcgtOTHQmVJIIN7Wt5QMvkzpNTeWBm8tSJM7JzV2MXngG5MxGJetGcvf4PsNZ4PoMM272y3cubjRi17B4jDCY3upPVOUclDxkqwNrmwEomFhjvnoty64IL0ohv8k9+v15rKUpaLRYycXmPDEQIKRvXqHqJwDUykM7pahQwSkinuNm5jIJbGEoQVyvxu2+sdc/0XwOrytL4czDn6VCKhZK7aVstCc+NonIIRPPjsarIUGPuebmMffIEfYmX0th1IZmfqo1fk/o//0VAiUP76JJAN7xwkeI2fSqmCtN7zlqShmiNCjXOT4P2aG+Cjb1sGnNKUK/ZG7AF4V2tgD/OWcOJ9Dd4GAOwSTvDewuvHpL7cIU7ycCBxMi0zbTKGf0CSzwNmGH7IPgq8BEM1IF7Gp4bAHp+CzKsv9mgX8GoGMYQtb0a1ncKttVk8efO2VLimLJ+/+2qdz9C1n1mHzTBAbmoJfj7JjE6gqrv03oX57vEkBpOG1fjH6WrRgkqhqfZAROqurt9XVuxqewEBogdhtESnjsshD6OT7Ioqg6VR
 6jpqyEHh
 W7uIcsY9GpW6cmsd1IxBRtqkyc2McuiVyERdh5qfCmLhV5UZrSafijhdms7j7nnljXJTJt6gBFZ12sfhugZDcTFs/fejw5vLNik8i/u/+Ztc4SFmtoIp2cD7UuZG22JVndDsTLvJU69Up+hKDcW3rNV/qsSzWv8lfc0zMk9+D/mi7cPAbCt/IzizDJ8wWiemjfkmJpib+bNZiOfL9wj3eCcKu1bVb/aogaTIEp9lZnRQ7JHicclTMjDO/xByBWAc6T9m5XP54rx3YTfVFkemia8fWKhsHWR+Vydl14vamI9ALdI+yJVeOsXp6K8b1G/g+fboC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 02:09:36PM -0300, Jason Gunthorpe wrote:
> On Sat, Sep 20, 2025 at 06:47:27PM -0600, Keith Busch wrote:
> > 
> > One other thing to note, this was runing on arm64 platform using smmu
> > configured with 64k pages. If your iommu granule is 4k instead, we
> > wouldn't use the blk_dma_map_direct path.
> 
> I spent some time looking to see if I could guess what this is and
> came up empty. It seems most likely we are leaking a dma mapping
> tracking somehow? The DMA API side is pretty simple here though..

Yeah, nothing stood out to me here either.
 
> Not sure the 64k/4k itself is a cause, but triggering the non-iova
> flow is probably the issue.
> 
> Can you check the output of this debugfs:

I don't have a system in this state at the moment, so we checked
previous logs on machines running older kernels. It's extermely
uncommon, but this error was happening prior to this series, so I don't
think this introduced any new problem here. I'll keeping looking, but I
don't think we'll make much progress if I can't find a more reliable
reproducer.

Thanks!

