Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA4F1C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 11:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE0B66B04C4; Thu, 13 Aug 2026 07:39:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB9926B04C5; Thu, 13 Aug 2026 07:39:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACF0C6B04C6; Thu, 13 Aug 2026 07:39:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 914506B04C4
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:39:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2EE10A0101
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:39:55 +0000 (UTC)
X-FDA: 85096051950.22.E99BA85
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9B03BA000B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:39:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gp28GzYV;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786621193;
	b=h7LLC62IkCfhLhqXt8t5FLF5ABqRvaHG/yG7vF2BhYfCVbseySAdYw4xmzZ7mdfFmihE2A
	GGefydglw7i1SQBicBPCyVLMqlZuowcdz2ZGxlftuWPoc5iNb7kA78Ije+tPtYy9m68JsO
	Wb/AS72cRxWTPvffgdpUoWVXUZQCF+k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gp28GzYV;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786621193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bzwlkKgAjFA4jPn5mhlQ/drv3ccUTPbHoR0B3kcJtU0=;
	b=G3Uyal0GJsEudilU3bTfhTfG/fWkN2FeDywRjPioa8ieMqytzZCToD4gx0zTwGb19VgbhR
	0qJC7NMbeNuIqOqZJD1mhX91zAg7gnN/fy+QqQOtvq/p/oF10UaHaRZJAo+Ndqo3pBI4Hd
	JU9HP2FnU78zlyYaIQ86sEatM9qZjiw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 32B1D600BB;
	Thu, 13 Aug 2026 11:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8A31F000E9;
	Thu, 13 Aug 2026 11:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786621192;
	bh=bzwlkKgAjFA4jPn5mhlQ/drv3ccUTPbHoR0B3kcJtU0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gp28GzYV34B/sJAzyVyl+eGvrNb5UuB4gSP85z0eoWa3UUx2NSg2JThEbyxeyPix1
	 l5G5xD3OpRrw0O7lS/pUWjvs1GloVvb+G00bRgBxHYeE5cIt9SR++oyp1mUnT6AWcR
	 Ie/K++d2vQYE3sWy/XekaKcV2Z+wSEn1Sn4jcFj1C+ze8lVlZLeOEY6vyhhddIqC/W
	 1V626T0m8H58D9b+4pm10o6UG8i2ojikIvc++n0r656j0p7haiFFlvTgwG4VFroSqZ
	 rR6UbGiTwEwiUX3MQ4aUWaCE2QdmQiOQuiHR96DoHeevN8HP+YeuOdKP+UThYp3KlH
	 PPlJOrwJ4I/ag==
Date: Thu, 13 Aug 2026 14:39:46 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pranjal Shrivastava <praan@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] kho: support preserving high-order non-compound
 pages
Message-ID: <an2tArzOomSNpjV9@kernel.org>
References: <20260803113944.3694290-1-praan@google.com>
 <anr4-F-e5_vHEar8@kernel.org>
 <2vxzv79f39za.fsf@kernel.org>
 <anxrvA3z3NUkWvnE@google.com>
 <2vxzecg33103.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzecg33103.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9B03BA000B
X-Stat-Signature: b1t6fij8dgjobuttrhhy4xrzd6i3qydi
X-HE-Tag: 1786621193-971143
X-HE-Meta: U2FsdGVkX1/qAps60yBzB2ZGpxpgtFSLVmfQB7qVQEieU6rRyUxl/LngRF63AcdpwEtHf/WEicQnnrLWvPurEq1qokcQRqLmrm8wepJWrshvNCiUlC6htpFeNzhOwZmQUlGdPqz+SxOWGPAUQ6oBpAHHtlKr7mylyGxw3oVmjneY4KlvqiNLj022nKrH0zEaD+jb0SgJoJvqkw072HhOj7a1qSV4wKzjRCK0jziADTO0WlbACEInot+RUKkB1n5gonsX97orbF6PNcv/iNp/QHz8xx47QkHxM8+E2HylQU54bBdE9D1iPBoQpWPtS5MuJw2cZiOELMhmlvBJ3CR0Bl0hbqsSEDloR1EvFItE9Sl1Vqpj4TXiArzdjWTmdsNc4XL3AInTpd+s40RNLi9AfDEUj99lth0Us0Qi2DQ2SddP89t2Osi0eFXDs5255RnsSbJ1UKA2rjKBR2XtqiVl9ZpzmorzdYBfunlYMg0ajdCfW6gOCVwbBsnALsZG+lgD0BJoRTWifjIbpcy0egDBlw6qEudf8b2iOpitU3LyWtZa4FL7/myGXbnclHw5ScQw3L2C1+QcuLxknDY5QhuCKfAjSo7khSia+F7lek4rzXpPb4gwmQ3W6uwTCmuMbnL+PElH5fYpeWzE8VWafxui6+Xf3/cHvclta80YmeA4HpU/v+AwmyfgJ+M2a/c9HJcWzoeQWo51eJtzMFOfJAwsiZ81go7Pvak+cMAxtcrSgVc1Z2QMQgwMC2xxmvKOYo8Xi4QVBZ7Qcarq/ufWTB+yMNz0G0MTCsOmaZr002ZGIoPCosgMvVQ1Bhi1KlsB2poH+VnEQvT7HoQGv5AMz/Vr8Q5tqMZ9iS09eieSKJ6gTa9n09+hDAX1/E4v7pXs09+VuXDXZRoINxwaNPVdeGS1pKsjQX6INmy61uG7rfx/eZdjjiT1ixdYxOvbm+8gbygCIupxWDp3gPPpkbQqpU3
 ZrrYYkiz
 /sW/+DC1M1nNtHZYbbmTGmpQpIezwae8Mk7CCjL2Xl0AZ2F0azpLalfxtcfIr7TtXQSPFUWa2xdVYo+hPdbRfhpfJSeCj0QvCSPS+f6r3X+C3yoq4TjdpIdaH0Y7yBtkVF8gacsIEcnWvU2WYl8J1Zc0YZJbTkeEyBcZ1W5Mwf9g64tj6NLo2yjj7yzjqwqfE0ETq+8XqIPcFFf3YVblL1+wVDkl7DnGXeI5YdkAp6tG9DmmAWn+xE/eso5yR5RrUVA7R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 03:46:20PM +0200, Pratyush Yadav wrote:
> On Wed, Aug 12 2026, Pranjal Shrivastava wrote:
> 
> > On Wed, Aug 12, 2026 at 12:32:25PM +0200, Pratyush Yadav wrote:
> >> On Tue, Aug 11 2026, Mike Rapoport wrote:
> >> 
> >> > Hi Pranjal,
> >> >
> >> > On Mon, Aug 03, 2026 at 11:39:41AM +0000, Pranjal Shrivastava wrote:
> >> >> Introduction
> >> >> ============
> >> >> This series is required for the ongoing effort to preserve DMA allocations
> >> >> across KHO [1]. It addresses a fundamental mismatch between the current KHO
> >> >> restoration logic and the physical reality of high-order buddy allocations.
> >> >
> >> > I skimmed through the patches, they look fine to me before the in-depth
> >> > review :)
> >> >
> >> > But we are really close to the merge window, so we'll anyway need to
> >> > reiterate after v7.3-rc1.
> >> >  
> >> >> The Problem
> >> >> ===========
> >> >> The current KHO restore implementation treats all multi-page blocks as
> >> >> split pages during restoration. Specifically, kho_restore_pages()
> >> >> initializes every 4KB sub-page with a refcount of 1.
> >> >> 
> >> >> However, many kernel subsystems, most notably the DMA allocator (via
> >> >> dma_alloc_coherent), frequently return high-order non-compound pages.
> >> >> In this state, only the head page carries a refcount of 1, while
> >> >> all tail pages have a refcount of 0.
> >> >
> >> > This hints that these patches could be a part of the DMA preservation
> >> > series, unless you expect other users of the new API.
> >> >
> >> > Generally, we don't merge new APIs without the users and if DMA
> >> > preservation is the only user, it's better to fold these two patches there.
> >> 
> >> Makes sense I think. We can review the patches here, but then they can
> >> go in with the DMA series.
> >> 
> >
> > So.. IIUC, I'll post a v5 here as a standalone series till we get
> > consensus, and finally the reviewed patches can be folded with the DMA
> > series?
> 
> That sounds good to me at least.

Yes, although when the patches will be a part of the DMA series we might
notices something else :)
 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

