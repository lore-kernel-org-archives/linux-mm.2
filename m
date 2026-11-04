Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF663606D81D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bKWIpJro
Received: by kanga.kvack.org (Postfix)
	id DFC4B6B05CE; Wed,  4 Nov 2026 11:50:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DABB76B05CF; Wed,  4 Nov 2026 11:50:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE9AC6B05D0; Wed,  4 Nov 2026 11:50:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A8E816B05CE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:50:13 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19F8FA07DB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:50:13 +0000 (UTC)
X-FDA: 85398024306.17.E1E4922
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 718BFC0006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:50:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bKWIpJro;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793811011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h9wu6kihgi9yB1xWkuSesGFotgBTDc+RlqCdPr5bB/c=;
	b=Wu/VPU6rss+wbNFUs1YWu6q6Nqiqy67WAbofIg7rAgEnK2AMzvA873daBIdul37VnC+FI6
	QmkOsWI6M4by/NYg8CBFAUQai+L+MFeMpulo4BExS6t6/7RTDNshM0MX2Gr6gxjEwvU7vi
	X/WSlkIm1l3919XOyc5SVc1Wr2aOvOs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793811011;
	b=zashu1y+mAd0qlXJrob2F86+IQ8IhhKJU9naThngUwWZtIc6yVAq/rnE9hmgdEVuI3JfUM
	zoZB+m7xi7Xyp3wUmtONJzFPc6T3inR29W59dL8mudZtYRvHv2LlrUjc9msVKEXxDpqaEg
	MFGGLYH+ozV8bz1cE+8HT8ZL0mZuUtc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bKWIpJro;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C135343D01;
	Wed,  4 Nov 2026 16:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCD41F00A1F;
	Wed,  4 Nov 2026 16:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793811010;
	bh=h9wu6kihgi9yB1xWkuSesGFotgBTDc+RlqCdPr5bB/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bKWIpJroWZmQuSMKmkcHkS+KBMrgb1w1jTz5HKzXIOr50CEf78uf0IDuq69Df3xiG
	 McCrtoOIvk0xb6p6wbnwjGvzKd6b6pyVQf4nKgBFJap0yATUxKBBuOYv3hAxPCo9+z
	 5piNj6JnHodsMU9py/wzB+LPq7CLnzXj5WQz0Bj42hex+bec+bW9zqWjC7hrHRS2IJ
	 tlvXHJC7RxLi3+LmQyX6yRcwvcx28ds5CuCBBa4/hScO7VelF15BopQikaxNJn608s
	 0vUMHKv70OmXy28yj7eKHQK9jOI7XNRssHsj8OdrzqaI+XX28zWZTY9aH9cN7yI7GJ
	 05o1Esz3NWV3w==
Date: Wed, 4 Nov 2026 18:50:04 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chen Pei <cp0613@linux.alibaba.com>,
	George Guo <guodongtai@kylinos.cn>, Kexin Liu <liukexin@kylinos.cn>,
	Sourabh Jain <sourabhjain@linux.ibm.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] kho: skip zero-sized lowmem and global bootmem areas
Message-ID: <autiPITgQl7nhFER@kernel.org>
References: <20261103-kho-bootmem-sizing-v1-0-45aa74098f34@kernel.org>
 <20261103-kho-bootmem-sizing-v1-1-45aa74098f34@kernel.org>
 <auo3PzmisfK3br1l@google.com>
 <ausVbqZd9qgZf4zc@kernel.org>
 <autM3_pSLuOGZQCh@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <autM3_pSLuOGZQCh@google.com>
X-Stat-Signature: 54hhxqba8cst7ith3q7z1t1uodnmtubm
X-Rspamd-Queue-Id: 718BFC0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793811011-259647
X-HE-Meta: U2FsdGVkX1+o6S3jZQ1Ln2ovXTdleKMpKr/9t9hnceG/fOhc4bxZxnDTEKH978JrWSAjX++8OluIiTqZaDa/K7VR7NKXI45YzcD09wL9W1oPUtJkMXB3/f/paWe9zjnxQdbqS4WS9Caw3e2nHG6kHp/z/N0SeF4zOn1V3eOiennYWlwWgzviQzEn7uAfBigCakP6z/xIk11Ml/KKYom0Ns+39C47tffSj6h3OVwsw5PuFpbd+YQZSNIrienZ8tenTcD+BFc/o8JFhLRdKLD4nSRsrqlv0oofLBbYaIooM+q+qQU3LsH9SF4RtLo+FVJo0Hg4lbYqEdWc/OQvBxaakyTRDscBO55Yx4mnMHeEZFwtrxx3pHVJRZ2ZAXTYsGcBRTclWfSs9UCOMNU7g0y50bGwMfiE279zMgsamLGVEyD0sqdCv+LVimTGTQWQ45ieti7Ez3zMraw0PBwNjpN23PT2TgbcIqbB7Q8gLIHqS/VAmrboXITSUjYsGuAYBlEugZdI1S+ywtBUXECexHXN0K/Dm2XgodsNYHgAovmk5ymU6lXO/j8NUAALGhT/OQO86uK0BFyi5RotwJfQC52jWu4UuTx7uB+scHyj6GaaRWkawS4KT/mATFFCGs7/+PiOIdFNzFZfI77kDEjLhGflVW6qpLFhRoninj64ofV9R6LNRyTiiNpL+62gVkhbbepDH9Aoh3+XeQZ7E12J+ndWwuxxeoHAjoBtkYibEsajMJ/VgrYTHxyc+Sh4xMXweoGqflhK4F0uguY1+NEGKv4u8bUTJeEo5ioLdHGLIeswS0naY26ZK1HJRWkSANVLgifum2YlZl1bDP0jTMbtm/vx48oELEfhP64fyKoFPX0xFNspW1UnO2PYVPi6TlcbEONjJDd9C+7K9riW8ozhX76ifA8cfFzCr90uP2la8GdKfonkVOCWAB+XDPQ6gPCvn8gXd2dQ2izq6f01vBvtJfz
 X5YWVUEt
 ZutTgxUk9/T8wRNCOTJ9kJ4Hm8ayAfyzKC5DnAuYlXC9HMFUdVFx8PmCkWaLRpb92DI/o4sdk4fRupZOAmtkChMuq614bC+UaPOoZriBf5PWWpUcEtKPkVTVyU2B8rJ4GB6GiJuGjMk9s4FK6ex1R1LQecn1298R+ImFbYRbd3Daj8WFddjosR7uRl+ddimTBkXCJkuvV6hFMIe/QNvALGDVtipZzS2u4YgBnzir902WTXCFkZv1Ei5aHvNZ/2BBhsQfa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 10:32:14AM -0500, Pasha Tatashin wrote:
> On 11-04 13:22, Mike Rapoport wrote:
> > On Tue, Nov 03, 2026 at 02:48:36PM -0500, Pasha Tatashin wrote:
> > > > @@ -852,56 +873,32 @@ static void __init kho_reserve_bootmem(void)
> > > >  	 * reserve bootmem area in low memory for lowmem allocations in the
> > > >  	 * next kernel
> > > >  	 */
> > > > -	size = bootmem_size_lowmem;
> > > > -	addr = memblock_phys_alloc_range(size, BOOTMEM_ALIGNMENT_BYTES, 0,
> > > > -					 ARCH_LOW_ADDRESS_LIMIT);
> > > > -	if (!addr) {
> > > > +	if (kho_reserve_bootmem_area(&i, bootmem_size_lowmem,
> > > > +				     ARCH_LOW_ADDRESS_LIMIT, NUMA_NO_NODE)) {
> > > >  		pr_err("Failed to reserve lowmem bootmem\n");
> > > 
> > > You are adding a helper that returns an error code and then ignoring it 
> > > at all call sites. Even though it can only return -ENOMEM right now, 
> > > dropping the return value is not good practice.
> > 
> > I don't think error code is important here.
> 
> Perhaps, but it is just not elegant to add a function that returns an 
> error, call that function from three places, and ignore that error every 
> time.

Because it's not important what the error was. 
 
> What is wrong with:
> 
> err = kho_reserve_bootmem_area(...);
> if (err) {
>         pr_err("Failed to reserve lowmem bootmem: %pe\n", ERR_PTR(err));
>         ...
> }

More churn for no value?

> -- 
> Pasha

-- 
Sincerely yours,
Mike.

