Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A993AC98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87ABD6B0098; Thu, 24 Sep 2026 03:38:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 852826B0099; Thu, 24 Sep 2026 03:38:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7681D6B00A0; Thu, 24 Sep 2026 03:38:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 522976B0098
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:38:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D211B40249
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:38:27 +0000 (UTC)
X-FDA: 85247853054.30.CA3DCC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 399AE1C0004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:38:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qrg79Odc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790235506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=syHUjeiyU6PAQHnSegmJU/Xn5fIogA7Zi7eAXuaZd0w=;
	b=L5nrDJR/7MDhp0QyVfqmOzxfyjr2NHdCiQpXhrKK5gsF8uD3d0T20+42E1bQr9rlfQY+Mu
	vUgqvvuxJnQ3Fcu/Z7y5h1SzGCfMavEj5XEE+ChTMOH4bFu85D7KYNMtpcMhP0x1EHl4Y1
	temLVaPt9wPU3stvEAnbhqm/HU6PYro=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qrg79Odc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790235506;
	b=IukrygMJRrfbIECLLQ6BlyKmrJNYd5JyiEZ3aMtz9MP62wT/0llw9KJCnPYoVkO2TiU3KM
	N0P4lhCs2XTCqBgcoOuO3iNStEFURYmim3U4GcwvKaFpgMGzoknArYhTzvx42otjiFTcoB
	lQZet+wTRZe8Hu7dOdKmIaUysA+vMCU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5830941A1D;
	Thu, 24 Sep 2026 07:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F4F1F000FF;
	Thu, 24 Sep 2026 07:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790235505;
	bh=syHUjeiyU6PAQHnSegmJU/Xn5fIogA7Zi7eAXuaZd0w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qrg79OdcGPfgl7yoXl3ptDh3IKF+UVtWixl4nCRdJqTGzJZ+s1Q/oDpS1tvP5TbmU
	 NC/P3mvbNVR2+m1S835Pu6Brj4w2XDBtdsxcTRzLAGRNZ0ek1YUfRQay4KrGBYVwSP
	 c/1mkMp1GSHwPMMZCV7oAdOOPyVA9oyXrssm/mTg12mdArxvR3+Vl5KYhLriakA9mb
	 l/cnPm91MdLqYgXSXXTT03lz59Mp7424d4AfeLbVjh9oqanpGJ4zauMw5X2uFjzT2W
	 TR2o7CkHFMIgi7kDWyK7afhFP1BP82PNGmcb4v/0pzFiydme+Isv5TB4vSibkKCO01
	 1I4uk/WoQjk6w==
Date: Thu, 24 Sep 2026 08:38:18 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Vishal Moola <vishal.moola@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Steven Rostedt <rostedt@goodmis.org>, x86@kernel.org, 
	linux-mm@kvack.org, regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: don't defer freeing kernel page tables while booting
Message-ID: <arTTVY4bwYKzeWgb@gremlin>
References: <41a59ba9-039e-454f-8d31-f647db802ada@kernel.org>
 <20260924072819.33277-1-mikhail.v.gavrilov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924072819.33277-1-mikhail.v.gavrilov@gmail.com>
X-Stat-Signature: p4nh1a8g1ac7u3ybeqr7bun4ercotx3u
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 399AE1C0004
X-HE-Tag: 1790235506-962789
X-HE-Meta: U2FsdGVkX18U1M+cuvXYNeABXx7zY4PfRrgJ2Zvilvg7Vh+b3iPTphiXtTtQyMDTpg3y1XpYqMrOHQjk2m72KCBXlEcgQSYajvLT/qgqnc27Fd63Rlscoazl8j27SsorXFbb5sJN0rXuC1my0owzj309bZkZ6LfpEdCQEz7xc45vt55jSlRaJGiP+BuxCLBQOtuua78/C+dQ/1V700AmPD6Rn6jJXwbSFqW/qiUfDRymKZ3V+F8X+f2l+LAQrNZAY/hgt4dItgNmWh7VJ8fa7zuMHK728geCDNs3bjHEVkNrlr7jf6VH9gMJG+S2XBS/yPTZgXivoG6IZanfD7+ggKuj3WO0UxLyDlNmAqLqm+cnkQ/IacSSBEwg58SYHpwEBJH5GUGdW2Qijn6dlCTMR/dKIvNveR73MTYETr7F+DGX/RgZTF5NDdJHxTZ6mW0XAx3t7/aCYKLsYxtzGveqO37ouCRMuAFJGRgUbiinEa4tL1kezPw0fkGftCTccSxf68ViR8orBiK0D8Yq3iECFzG83OisSxGajdE/0wyjnKCt565VNxgMxmDY8VZarx5l/J7u9zCxbgsShlO2bh7HQFAeqW+NuPE6x00NL5GgnxL9skNfSg4i7eJ8kAG9iDj393NoxeaEEN+YjxmlCoWZ3v+997ZLFFAw9I2oEb4cp50BA9936f84Y/u3Q5zKc8GcOqjDlbxajCmjqv5VIhtGRm9hOO+a04wxS8nl44pDp9LDnwE1lz0xSYXRTA2aJKQxqZSluiWZfXUJkrcvQt69Xw/H4bNK6zjXXtbkA+MKu19Nd1Ma7T+l5oT29HdOjA18cvLs5Uft2waqKdxklwu/2ft5AWGn6KQzMSSfWl3HBvaCNV6KdH3lDPZB6yuOLT5GuyzJTTRi589X1fQGUQ3ghnGIyiZ6XiAza0uFzYv175PKBwoXTdqurTyzUY70MLKwKMRXHZjWWC3RlrI1uvX
 ATNb/t74
 virHcrFhxFxBz07Dgrs4sDB8xBrCW/MRZgCjbPGzT8RAx1C9hAsYyCMX3IfTBjx+aE+kZZxWHt9mTs5mrzav4QOLWV0q/H4UEVtT1LVYCCuASGP8SbC824Ahwbh2eArBkj5fKZXRE7NbHT4QcMxJaDwupTphQiJwJtJ6db4GJgT36dAq7KnIYOBHhFQqPxbKtmZ4ljwtt3BMvi5IFCcX2+FsnOW9YfDslAWLGJHcBOOZk4+pWV74JnQeh2rgxUsRC809fjvQv7nCO8k6Bof3Gl6n0of72uXileZnQF46qkdSRACCe4mA6u/zeJYq8GwWc/muVxar5L5Y2bcU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 12:28:19PM +0500, Mikhail Gavrilov wrote:
> On 9/24/26 09:07, David Hildenbrand (Arm) wrote:
> > Should we instead simply skip the
> >
> > 	schedule_work(&kernel_pgtable_work.work);
> >
> > and rely on anybody freeing stuff later to just free that one alongside?
> >
> > That avoids throwing in more freeing handling.
>
> Yes, that is simpler, and the early table then goes through the same
> IOMMU flush as every other one, so there is no need to reason about
> what an IOMMU can see during boot.  The only cost is that it waits on
> the list until the next kernel page table is freed after boot.
>
> I'll send a v2 that way once I have booted it here.

Please wait for me to have a look through this issue before respinning,
please.

--
Cheers, Lorenzo

