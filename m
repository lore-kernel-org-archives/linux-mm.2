Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C76FFC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 16:15:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 960386B0092; Fri, 24 Jul 2026 12:15:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 937AE6B0095; Fri, 24 Jul 2026 12:15:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8293B6B0096; Fri, 24 Jul 2026 12:15:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5313E6B0092
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:15:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA2B11203F9
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:15:08 +0000 (UTC)
X-FDA: 85024169496.01.8F9B57D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id DC3DA180016
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:15:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kI0Hv0Lu;
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784909707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=51KJHbIf7JheF/TQON1Nt2IkrAoXsCVlhhd1llA6W+k=;
	b=KAhYIZJhVTRNUKnaqkbuVciRtcHRBduVeb1kCYF5dPdAGImx8Nx8+dcoQxvMdx4894VgmX
	5SxLScLfEeO6A6Mxk/klZ3PicU3D6AwYZrhG9LP7YJ4sB6ZXI6ZNPxyzyt/d1j2TtPcm8u
	o05a+IVXIzSGwjVF4f5yrvpWVxYa+aE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784909707;
	b=tH/bcPdXt5vOAus0XEKUVIbeTrCl2yrdNxkgQd3TfXEccgwpLOXtiRwZFW40DrnvYbvurA
	p2z+j8hmdBAIIyrgex4/t3ITAZINiPnXT6/jcl91xYh6E0lf+siZaMbSn2X/IPS9EMIEml
	ZCfsMwm8z9MZ4R4nTnd9JPYRqb46+3c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kI0Hv0Lu;
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=51KJHbIf7JheF/TQON1Nt2IkrAoXsCVlhhd1llA6W+k=; b=kI0Hv0LuOACoyAzgS8CUk/Ex2m
	Den0ilnMsK3bgo1B8LYf2YhaE65vJVCWWaRmslS74gU2uW5ZOL1yL9GCHIjdYwUHek/LbxCwaQThC
	qt87qrTL3t3VgaRuL6CGTaVx34VoOZDhy96seeAzYe3lEAAfIgTRgzzRp4DkG20nrh4LF7IArlcat
	GvyU0WSpIT39snbPOdflEKRog2eWGCfcsuyIZeuFH24yIY7/NoRbHSS5ePEo3AmqIyPRjkvx4Z3HQ
	gr/Yzz7uo+PLFCR1LbIPMbC8u9nuUtDgkZFG49uPtfRaj8XdTSMmoazX4N1qTP12GeZ97gck1wZpM
	8a2T655w==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnIYB-00000003tNF-2Shw;
	Fri, 24 Jul 2026 16:15:03 +0000
Date: Fri, 24 Jul 2026 17:15:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v4 13/14] filemap: Add support for authoritative mappings
Message-ID: <amOPh_oXhrIE44nE@casper.infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
 <20260723143034.175661-14-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723143034.175661-14-willy@infradead.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DC3DA180016
X-Stat-Signature: pie9bmz7qizjockwofg1ptcz46wqteaw
X-Rspam-User: 
X-HE-Tag: 1784909706-610644
X-HE-Meta: U2FsdGVkX19Ixb+uIvGIAbzSK2SNe+TReM5Oh52hnFbYUQ/wkMxVhNvgsp0QRa4S9OcpTjXzHSNaYZIpzX5SV0HveoNaSLVXyt1STcIFhYH7SEV1D7QapyQ5Dpq99WkNpZ5Wuv/fY3BZf3Ol8J1f84tdSJX8fxNC0Pi2Ypf0HOAWgyBLw8DGbGOxp/uQuYnxaqYJ7B5za8wQbtbWkE1JZgDVuoBd/lwpuUrTmLVwZqwnAk8O3tN5seAU7cz++NjbWmQQC5/DGyl6C9yy8/GXYOITw/hJKZzn+6/AnhHnd025gaDLaLYNsl56lFDVa9dVureXjBKo0NtrfNBpq9T5Z8tjYz+2DsOkDrGCDMnEDEvS2a0Fqa8b6H9mGjUEh+rrk0jqjYNwlRP2SjqmnQIhEMO5cF3Th2FH4RkY9t3L3jVdJr4il4WE0OmxIG/2DnrxbfZd/XzI1/GfpDRCJc74pNzsHj6Kl9nqVZCTDZrYhRw2ozEIhPE6QxtWPH4lztH2bInadXyg2xPjEyEtCF0nn+Tv1q5KWTQzWin2AxwlqVUBr6xltHPgbLz4THkcoBJ7vuPf9F1DWL6oXVOsQLnrEpX9PINrg7r5jDSGiHeuL2cvagi7MnvR1TWO+auYEA22lqPxKAgNWV5r89797rjhh2dehyd9RGnc3P4hacxrSlCKMuEqDYmJHOed4EmV5TiLLyHuBwe0oZICNLI+lzuPKDB5ki9loAy3ZAkSqEv99G2q+MVsDz+JKl+BADdzF7507UoXXNZd2lCe3i5Z/vHDS0ZcVhzx/7INasDsl0a+F9VO+jhE9swsm1kSCaCGc1TOwmpABtxdLx3zVWtBEEZQVOJ6NVMNPrP2OyKxkcg8PZ6Ls9o4zAEn90KDU/5KIZFd31QvEK/aRpenxVMT3Srj7tQkAEJBNfalPAwT2cqC9A/lnOCwvzAtEKHHDrKkMKw4DHUMJvTr2MK52sm/CW2
 Z8HalhTn
 +9/BUcruBHgwKGq6DmN+WWN+mxNEhch2zOr+CLzIsRkl781ohq1bLSgCZw2iLdnJp9S+NUM/gzE0L+dGUjJUS4COz/HkQ/kj7kwZLqd19lW8EGs0cwtBLH+GpfO17DKfXltTrMcAYDUX4yOJGeZCIQXsL3cln5X2kzHMKR81gh9m0L5ZtPVUR//9UQdCnxxBamDFBVP/ILTTmJd4aTTbXi6n5ZBIipxMLwdt/cuavQrnCefG4jScTY1JQB1HIEKvg377PBobIr8T4l/YTwPtbEd/wA0PKucXAVxOgCccNNSgV24WhWZPwjo3SNaA9C6JLbze1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko review identifies only a problem identified in the previous patch.

