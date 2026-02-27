Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E18FFEFB6C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 16:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D1346B009B; Fri, 27 Feb 2026 11:05:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BC8D6B009D; Fri, 27 Feb 2026 11:05:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 591566B009E; Fri, 27 Feb 2026 11:05:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 40B9D6B009B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:05:01 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 048211607C1
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:05:00 +0000 (UTC)
X-FDA: 84490710402.29.1DBF5F9
Received: from flow-b1-smtp.messagingengine.com (flow-b1-smtp.messagingengine.com [202.12.124.136])
	by imf20.hostedemail.com (Postfix) with ESMTP id BA2371C0011
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:04:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=jr3vgegU;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="t vscZop";
	spf=pass (imf20.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.136 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772208298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9iPiw6U5zQK+rw2Kav/sKN2Hf6ijXsHI7/gXVV2UUoE=;
	b=Y6XWLUNOuPwHhPgxTuEmTxm+EQ+gxgdTc92yXPKD1pM/xZebdqJTGPzF8UOwGr8aRpmHiX
	iRXaW6RJys/Em0nVxIyQLlObmWcb4l6PD1MDWqjpUy/TjauLXeogW4QEMqL5jYuafZNBR6
	TU3+8j6WQwvmdpoikTGB0EjnmnK9/eM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772208298; a=rsa-sha256;
	cv=none;
	b=M02O+7id5YQrwx3h6jrF+D87K8YE9YhiHjFR4aJeJm+yAxuhhAcDNTzXPQ8eiAVt9gkOsR
	XXeQCb/NwXhwhfFkvaa6JsIHJwxsGrTPuK4+FgyABdoHVIQFk/qZt0DuabUlwxl2wo4/k9
	JRsei9JERGgdQaltq6iQ25hi6nCjszs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=jr3vgegU;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="t vscZop";
	spf=pass (imf20.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.136 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id 43E3B1301495;
	Fri, 27 Feb 2026 11:04:56 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 27 Feb 2026 11:04:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772208296;
	 x=1772215496; bh=9iPiw6U5zQK+rw2Kav/sKN2Hf6ijXsHI7/gXVV2UUoE=; b=
	jr3vgegUcdiHcY8N3v9Ti9WcEJ5nINZ1LAG8Tq0MP7dsOTevP5c791I1/P/v4BsQ
	7iHi6zv1sNVSXsUMC/t5FLaK2xSmrbpAOfmmZb18i1xzVnDp580eWMO6P/vu8J3V
	vwZdKbbp158lxye+S/hdnWtDfgurN6NArNK1wHg5kvh2T7k9D3Dl5AgSBo/Oh063
	rgZYEdUC4Z0rqwhPIHKhe/hnwRs9kCtNTpjS0BXScOr88+CNoLHwIpSo9mo5OTMx
	Ry2YwDsNycGr97KOYjlMny2hy9bIhPG3Yt5lw1qqv/D2fwpmZLUn6Ho2FM7GyIHc
	aGqnwznkm0tYuPiEISOBZg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772208296; x=
	1772215496; bh=9iPiw6U5zQK+rw2Kav/sKN2Hf6ijXsHI7/gXVV2UUoE=; b=t
	vscZopf+ZIEohHyAEDRhsH6FvskiqkAmDpcbJ929YOc16kdoaID3AUqA/A2BuUaN
	T3NQnehlYy2NHaHOZTy905uPUXQvza+V1dfuXki/6uhpvSoc2L0RtungWGT1jrO7
	ZwCT4v71GqF8Lb2j9Wa5pO6iFsAT82AWVVzzfP6i5qBkN/NLD16OpXnsU9Um2Yit
	tqax0ePNsklBpO7D28r+WHWyEsyEB3dBdPzILFtuFeTep/W/txwnLoEbTm6byCiM
	ZyFo3GtCDe1fofD17VNEpSy38yMrZStnH4Y7exMTr87u2ozA0C9IAtaYmIuUOHGo
	++gnE/qKKaOXz+R9EfRlQ==
X-ME-Sender: <xms:psChaT2sM4Kvl-4-ynL2eVnQMEX39TidibWISnlH_elJUGQErX3wTA>
    <xme:psChae4zqe00s2rW3dmgGMuGnyWrupYFD0bGCo76dIRjuimHTSYe2q3WCJjvWTKjx
    4PzQz43jg2I0fHfbjnTERQhWe1Q9ptrfVZgA1EPP6ANrtJPb8-JHw>
X-ME-Received: <xmr:psChaYF1xEFxlqB1AHJOkAbJUOmtbZjtLf3IJgp5hsYNQFhKllAj9SiL1qw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelgeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeefjeekvdduhfduhfetkedugfduieettedvueekvdehtedvkefgudeg
    veeuueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepgeehpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopehjghhgsehnvhhiughirgdrtghomhdprhgtphhtth
    hopegumhgrthhlrggtkhesghhoohhglhgvrdgtohhmpdhrtghpthhtohephhgvlhhgrggr
    sheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghjrgihrggthhgrnhgurhgrsehnvh
    hiughirgdrtghomhdprhgtphhtthhopehgrhgrfhesrghmrgiiohhnrdgtohhmpdhrtghp
    thhtoheprghmrghsthhrohesfhgsrdgtohhmpdhrtghpthhtoheprghpohhpphhlvgesnh
    hvihguihgrrdgtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurght
    ihhonhdrohhrghdprhgtphhtthhopegrnhhkihhtrgesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:psChaW9Xw982ojlJdwBELBg5nUtIzvooVbtsR4EkEMCm_xurJFXzrg>
    <xmx:psChaaOp5diDrMTGhRQmY7BQEtexZqnvTbnjvKx4-4ezrSFwxx9F2Q>
    <xmx:psChaSyHxbqDw7kNVUBcF1TzS8IrpR_G2LRBbhhRg_GGFr9lHV0HNg>
    <xmx:psChacsS35VypjDMtowdC17AE2t6OJySB2L9fCOTFIyvV5HWrXnqKQ>
    <xmx:qMChac02xKCLa1txMJHJVVZiONFn_n7mbt_yHes_8ALNfR1pvZwQrzfN>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 11:04:50 -0500 (EST)
Date: Fri, 27 Feb 2026 09:04:49 -0700
From: Alex Williamson <alex@shazbot.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Matlack <dmatlack@google.com>, Bjorn Helgaas <helgaas@kernel.org>,
 Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
 Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>,
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
 Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
 kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
 Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org,
 Lukas Wunner <lukas@wunner.de>,
 =?UTF-8?B?TWlj?= =?UTF-8?B?aGHFgg==?= Winiarski
 <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>,
 Parav Pandit <parav@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pranjal Shrivastava <praan@google.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 Raghavendra Rao Ananta <rananta@google.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Saeed Mahameed <saeedm@nvidia.com>,
 Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Thomas =?UTF-8?B?SGVsbHN0csO2bQ==?= <thomas.hellstrom@linux.intel.com>,
 Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 Zhu Yanjun <yanjun.zhu@linux.dev>, alex@shazbot.org
Subject: Re: [PATCH v2 03/22] PCI: Inherit bus numbers from previous kernel
 during Live Update
Message-ID: <20260227090449.2a23d06d@shazbot.org>
In-Reply-To: <20260226144057.GA5933@nvidia.com>
References: <20260129212510.967611-4-dmatlack@google.com>
	<20260225224746.GA3714478@bhelgaas>
	<aZ-Dqi782aafiE_-@google.com>
	<20260226144057.GA5933@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BA2371C0011
X-Stat-Signature: ke9jwz53k4a5mwhst8k4k49465eu666h
X-Rspam-User: 
X-HE-Tag: 1772208298-791354
X-HE-Meta: U2FsdGVkX1/cjg8lzHsKnapJBxFHjvSh+vYZn8BrQ4tPJ4fdYMJY5g+oUA+UgBzvX0GTuxwOJR/h0BjQV1UhrvWkf3iAuEeujv3RdFyh0IU2DvDcF7qpAnY5IItZ65NUpm9ZYpdk8hcoAustPiK61O1zY7YI/wSewYSDDZMaom998EJGAEqtOK+21JzvLVwO1rougYgVCyD6zDePQ1zpkLunpYRxEbuBaql4PARbUYxIEGxOyYLfwsTTQBp3lEmZVDvfcpFmz9E1qXpiOwLfO9xMDDAZJwjFF/9yfmDZbRGSf40CgFzznzJb94soXOx+KLx3Qz1Uxs4vZz+tYhSsrUNBNo8xnTMX6S/m1ekcKIAQXSLB3xug8/eFBpdcBrAQbqpIVHZ7wlhFHyPXgxg1R6LDAhWb2ha8jseekOr6ZGeUArASStiP5PD+clCdv2lZZ8jmj06K1tgWzX7lhUauxmB/2GC7tuzZICGZJ2vGAsQrQ7KnuV4WXfRfLzV+5pVewd5As6bjEuEfmg7CQRWThxTi0BJRycxGrS99UAQRAtcU7nBGFtaN3qXg6g15pZg6ZZm3V1fBczdp18xW/JQdKfNVjUWE6qAZ4Mi8yg0qu/+Phy2RxCDKTjsre4Fc8bqT3f1UJ5ZWQGgLpA5r22jiL0cUyYnfXxUXKaqkgurzzjQo7Djlb9DpAFPhQYX0gCBil8UZuz8v1bhHHw+jlA4wP0yxD3YxoUEQiQzQtdX//6PvnvgbGHzGeqC4dh7Oj0a77VlkR96LKKSEMx90hVY1l6/k6+WYRNENsi6fNPWwxPLe6vBv/Jur1WY7vKylz++fySOe2m9mqdB9R40ZmZD7ph7f/5Zx24BkUD6IHSNALyw6pUVmXg2F+/OnHMu8AXUwOEyL8CiUo9ZgdL5zVcA/s7h/F0b0a+IYQpXLM01lCNNujojILXCflIiguezdOVMOVRVF/Z/bXoi+MrFf4Br
 LYa/Ui5j
 2shvYJbWXNdug7JAxz1PdCKfgFhONMVIO5Nrq0PKAUoSDaiQURoEghFEBQbIAv5R+nqjKsA8xrvBaygnA1NFwNuhm6sIoqr/Csi3LkOK5ODbqHNXWKuq0/C/PTHJT9G+BO+0WruOciicl+Dz7mywgUdepBfxZtCYiU5BGUZALc0yiS9EAcJvKMNVIax+4GKhBiPQ6NKBE4hyj+JBQTzd6rx3skHJ6o1LonEFeCW+SAJ4N0y89pUZuixqcuOaV1fphrl8PepUeeP0hF8g1UmGaUDkTl6xX3hZ9F6sTqztysw5yTfxuASirI60ID3gGmbaFni4uA8mz52VkFAhn4r2OpuOl+e/9L7WuQ8rj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Feb 2026 10:40:57 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Feb 25, 2026 at 11:20:10PM +0000, David Matlack wrote:
> > On 2026-02-25 04:47 PM, Bjorn Helgaas wrote:  
> > > On Thu, Jan 29, 2026 at 09:24:50PM +0000, David Matlack wrote:  
> > > > Inherit bus numbers from the previous kernel during a Live Update when
> > > > one or more PCI devices are being preserved. This is necessary so that
> > > > preserved devices can DMA through the IOMMU during a Live Update
> > > > (changing bus numbers would break IOMMU translation).  
> > > 
> > > I think changing bus numbers would break DMA regardless of whether an
> > > IOMMU is involved.  Completions carrying the data for DMA reads are
> > > routed back to the Requester ID of the read.  
> > 
> > Ahh, makes sense. I'll clarify the commit message in the next
> > version.  
> 
> More broadly you can't shouldn't the fabric topology while Memory
> Enable is active.
> 
> Renumbering or readdressing the fabric requires disabling and flushing
> any memory transactions.
> 
> From that reasoning it is clearer that you can't do that if the device
> is expected to hitlesslly continue performing memory operations.
> 
> That may be a clearer long term basis for describing the requirements
> here.

Not only fabric topology, but also routing.  ACS overrides on the
command line would need to be enforced between the original and kexec
kernel such that IOMMU groups are deterministic.  Thanks,

Alex

