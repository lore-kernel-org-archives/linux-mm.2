Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D3DCCA5FC1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 18:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 050016B0088; Wed, 30 Sep 2026 14:24:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 001606B008A; Wed, 30 Sep 2026 14:24:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E597E6B008C; Wed, 30 Sep 2026 14:24:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C82476B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:24:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 64AFB1C0FA7
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 18:24:11 +0000 (UTC)
X-FDA: 85271253102.12.ADD279F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id CA4B8C0008
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 18:24:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q3nm1bqH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790792649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FunQvZwAH5B4DZ2KKVAQe9PaR1db9gvR3K0YtXguIiE=;
	b=gT3L6TxRrqNNEc9XTt95fixBw3p6lzjDES7SQJxIy8N4ue9DukqNndKI2OvrEE6y2Em+5F
	bGtCpq8tkRDkg9/elUh1EgHKO+baJxlRxbs2zGyF/tvehevVpmDkDy25ucdnJnaLUoUHKu
	TUgi8RqJLHVpqMej5bIOfM5QsduqX5k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q3nm1bqH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790792649;
	b=urZKTX3LPF1IjbTgmitqHCVHHB0U/DGjwPvXCUgAlGAtf6GXUWWCGBxdLhBmOu9SmeBoxK
	Nw/4v+qA46HSv1zsIegiNAEN1v8RwVta7ns8eVguKWM5jyKS9EXyUE+8jNhx0YfY3nSjQ0
	gKikOoPJowOVu3WIBHydePsP6n6QS1w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D3F09410C0;
	Wed, 30 Sep 2026 18:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D042B1F000FF;
	Wed, 30 Sep 2026 18:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790792648;
	bh=FunQvZwAH5B4DZ2KKVAQe9PaR1db9gvR3K0YtXguIiE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q3nm1bqH7nevKq8YHNKNgJQTY046xcAqz7j8pKgxJCIcdNu5xd2F2b5ykJmycc5O/
	 S4E0uPuPPAktCNmGa5JSzh2CgENEA10vJxxPdkXHO2CYbn8/N8bGwsFzxWiXeHhvsN
	 Nk4iNlqQdWQtwRXAwHnbnm7ybo1RpyY4Pim9O/yYQAAjBsQ5+kH6ROevSTYcr7r5Hw
	 7X3P+jQQrVPzgEvaGf3rk7cLgOH+uFawmA399Q24yZjAJsx5dKQVqJ7YjW5nDh5ZFs
	 t3NPtngodXZtww1yXE/ZRMF3BH0FQcRZcFTYgs1OodcerpISIAb7nSMESXm2sJ/DcC
	 sSQhCu0TlrhbA==
Date: Wed, 30 Sep 2026 19:24:03 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/mremap: fix two issues with MREMAP_DONTUNMAP
Message-ID: <ar1TdGugvi9_RwG9@gremlin>
References: <20260920-fix-dontunmap-partial-self-merge-v1-0-6ffb556f8f8b@kernel.org>
 <ux7od2uydetgsu3dpy6mmilhqm5phhnk2ioxn54w3nb3feohxf@2jqovoqzfs4n>
 <ar0y2odPFkCLMKk6@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ar0y2odPFkCLMKk6@gremlin>
X-Rspamd-Queue-Id: CA4B8C0008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: yxmhfuuqikjysct6pzri95hsmi6nu4cc
X-HE-Tag: 1790792649-767359
X-HE-Meta: U2FsdGVkX19ui1a9bmeWGQl0dIB/fKIGG2k/03kQ44UKRP8vC73SZB3D3SDLA9iHBXXTj9cVBwG3TkiciQ9OtWD5Z9EcsOfkK9WqCus0ZRActjoioeSAdf8vVN/Bwe4eYw0l4LohzcVSIzYaxFv93ckJoTAWEvZLzxbIGYCWZdH/2F0g0/CVZ1jGcgQtQ4YeLIr3AjrN1Ann2ntQ/26a3GrfmrZJ9ZVp700BOxbPMSFmhu1tnlOtuDQKNl5SVo4dg3/zeg47Qfr13Cx2X6zPHhy8SZAi5W51hnv3JzBWN9z7/HLyrsnl7ajFVvSADGsmuiGFXXpZQhlAWJLDzLwqv7SX0wzmHJ/kGOCx7PrP8ykf+iERCPbuEtHzMgdn7AgacsK8NvujyeISUOSFn3vWMFaCY6V+7NuPPdABUg+oXSjL2lkSlHJhoXx9I8XzM83Qv2lorqS4rp8TGGO7NZ3X3X/7J4N4cJsoVXLV9BlQzLiNPPXg5HcOqeTZ+lBsiQrLXBLvY4hCfgrR7xaho1RvdAeUnQXPuEP4EHUoyeSYVkK5fN9U3ux8TkB6rWxFTqcrotwzHRj5FPnxJYEYeRLJja65toXoCPEHhVUyT0s3WiJ+J1IKPmHC7Eo2o8R/9XeUSP6KEKAzz6+8cVdwdjIDtSbAqb2twFO5tv0ioE4W9l9+R4v7VibgJs/xBn99ytW4/SqR97KWe470fsxgo2st807Xqhkr4FOOfR7TCCPFHhgy1Xi+GPkCEDukAAQbDVWS/6+Jni9o4WFixPtA9mtlF8/8so5VGiHWA1A5GqJo0tao6EykjBe3B/6BDztjOuN4VJOAqTrNnRHqyGUgxLKVfxXzKDYWYRannFoUfn7un5sYDOTkYiQbMunKA7X/jIbSR7cP1YrNGfJVs7HE6fAmBsjp1iDOGcg8k1F6J1uHm+q6SknKFTl9+/N1urYqnRY2KCyhn5V4soVQMgSkdIJ
 +s6UnAS3
 eSFD8X1Ic/j1Oqe58REaEF2jh/Y7V4rsFWzQBnb7K+fV5P5X4Qy2sq1txqUZJH9ZKxS+vxh/8jdF1IbV1nelVDYRiG6Qb8I3MakDLVfMGja1cUrfIIqgzj5aOooD373eJtvfD0qvKqV94obM9uV7EKvRCDfOGp2rFWTwIUq8Lx7kOHWjG8BWOY8vzgnIsscRsBmph5ZyHsT3DxBvAbcyADfGpS5XNOtY+4MdN7RG7D0qBFvUnO9uIiFEHdT0Y9OwIwRpau1P6fo31UFGZd6sImB3KHMNeKn9EIlKtSa8mHBmDj/iGZHCLJ6WDp1xitek4Hu6Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 05:04:38PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Wed, Sep 30, 2026 at 10:59:50AM -0500, Anirudh Srinivasan wrote:
> > On Sun, Sep 20, 2026 at 03:13:09PM +0100, Lorenzo Stoakes (ARM) wrote:
>
> > > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > > ---
> > > Lorenzo Stoakes (ARM) (2):
> > >       mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP self-merge
> > >       mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP
> >
> > Hello,
> >
> > Apologies for the double mail. I did not hit reply all first time.
> >
> > I am seeing some failures in the proc_maps_race kselftests after
> > this patch was added to linux-next. The failures are in
> > test_maps_tearing_from_remap and test_maps_tearing_from_resize. I have
> > attached some logs below
>
> Ack thanks for the report. I'll dig into this and get back to you!
>
> Instinctively I suspect the tests are making assumptions they shouldn't be,
> given this series has the MREMAP_DONTUNMAP case split in advance.

OK, the tests seem fairly sensitive to change, but the correct solution here
overall I think is to only split if the VMA is mlock()'d, so I'll do that and
send a respin + cc you on that which you can check!

That should fix the tests and avoids unnecessary splits also.

Thanks again for the report! :)

>
> --
> Cheers, Lorenzo

--
Cheers, Lorenzo

