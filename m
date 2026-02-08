Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ED0AEF06E1
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 18:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46A666B0089; Sun,  8 Feb 2026 13:07:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4178F6B0092; Sun,  8 Feb 2026 13:07:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3197E6B0093; Sun,  8 Feb 2026 13:07:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E7786B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 13:07:36 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B5DCC597AC
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 18:07:35 +0000 (UTC)
X-FDA: 84422072070.20.2E860D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 27298180004
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 18:07:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="eIjSMF/3";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770574054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yMcDMMO5pUL3iromxDqvHXOfyfcuNP17tBgk7jNq3a8=;
	b=oRCWrYzwd427jaShCoAboerpbhLqL0Ho8ze3ZiMzZOuf9/NX5e+qhNMFoZlSwcK78Gd7rN
	RHF76UYxmdUmRsp0Eu17f7HSfLEgF7f+gEnswkxFFUYwSF3O1w/bWmkQfNTNDzc6vw09Lz
	BaM+Lts/ostfQU4XX6ytMFFj2OQWVsQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770574054; a=rsa-sha256;
	cv=none;
	b=VyZcgDXu1apwe9FcHJQCdFDk+Dc3lhGS1dkcnn/4BMOUx9PLmrbeU0mIcvyO5tVXv5FnXY
	sGN3K4Bn3Z3WwBJipvuYIbClpLiMRQwVjY0PjUHQwIJs0Fqq7bgJHbQLZ5I0KlIJUFcSMw
	uxHBXUK0X+QkhLHA82trJKjMLJcInn0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="eIjSMF/3";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 49CD4600BB;
	Sun,  8 Feb 2026 18:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158FAC4CEF7;
	Sun,  8 Feb 2026 18:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770574053;
	bh=PxcXwLUBRw69pj0y/iw2r5Y8so1kEeFr6i4iz7h+PcY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eIjSMF/3JMss8Yv+gzQCRJWnr30dkiCVPZJUb/Twq/rYj3Ce0b2P3ZsnTT+JbZyka
	 vlOgGbPj+Hs+7evu4WQ5ZZjNMTbLg8eophnbVM8l5Yw9ZGiNNRYPAhr1wZw7Mnbbjp
	 s2KPl5J79HQ1SNpCBVRfzZ5+IMwcNfGdFOgsV3UiLeNGfPu/PNNdp4cUxruGUrFEv4
	 wvtSKOjCooDTcqBbHi/diKNhFZrcnm2EgIxJKYeJivAggYo04X0Rr5a4R6B9kAT3/m
	 7midGG2ywBRApW/wuU82yzTseJINdxFPeWtLzn+sGRIQ3Xm9/dKr0cw8XkzCYvxSLP
	 yE1Cl6ejYcP8g==
Date: Sun, 8 Feb 2026 20:07:25 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Jason Miu <jasonmiu@google.com>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v9 1/2] kho: Adopt radix tree for preserved memory
 tracking
Message-ID: <aYjQ3WlwJkcvJOZz@kernel.org>
References: <20260206021428.3386442-1-jasonmiu@google.com>
 <20260206021428.3386442-2-jasonmiu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206021428.3386442-2-jasonmiu@google.com>
X-Rspamd-Queue-Id: 27298180004
X-Stat-Signature: 3tdkzkeg9h6aa1yy39fazsj9jdt83jkm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770574053-182991
X-HE-Meta: U2FsdGVkX18mJbuAGhCvdgyxA0rqtMHuQzBI/+Rb6A+ozXuPPMtkRBlhtn21Laa3LERZv2tp2kn9cbDCjYbJMNkdFxbqWp2/Wl/qyjNlYW03Bll0Ho2nVV3mB67K+iaVIbW+ldPBtwmJOn/cpPv7UGs+5Bmqm/jUR30DVe426gI6MzWGHhiX33LGW5tiH79SD0FVatQ4v1bm69Qrj5hi7wFAhQ8ls9sIVyjhxARCIpsyqR7hgWvqHmkh1C7fXJk155EqOKJyen64Dju/oJH81gliXrfbuxeLgjJm+KWHu8lO+ZbDOD4ogzx/rFFXeGPWJFRLVKRGS8N8ebzNOg8j5D5sOxXBTJM3vLoloSfpadX3nJ9gJvSDmHW+XZXq3gmi82xjjN1Rxb20DT3RjPpWtTWt6kNl4gwIWqOyQFnkg4g3nxrEemkrQjxLxFvdRN0Scl7diaDkKUuccQ0hfCMLV56O+sFS6EU2gWahjVZ8UCE7NoGCsY/SfoGVlpZBWVdKO9o50S+FY/tDMd8ihcPIKQc23inIbOfHZY4dn6HlIt9VUlkWbjLOQM2w+4i4TixVxmQYD2INndUDO3WyeWLp3dNJIXQblftbn1wCCdSBxHZBvdwXwd43vU7y4JxDmS4F0PyefN9XDDiBO9wNAXNH8bvomfsFJXOUoFNNeWFUUVvZS6DSRNsvxDstG+Hogn0yOTw9vpjI7rcyplhY1VD3gD6jD8EC+NKwnarZphiR67EguILxqjM/5CYPa/xqJNcWIp3cDsabyk9tf/CmtYNNIRrt0Di+NeIT7Oiyk1oMCQHh/jsA36ZXKWwCXsb3ZqCMdVk4uACBpKP73/7v5DR1JvhTxQn98i4w7o7qfYeel8M5/kJexpRBvIP7wiTx9AKB+/lA4uG/F7RcVsUZFMJHoDJUC2f6qwJYsY3uE+2srCCzi0h7LV2yfQ7iPBd/KqGCoE64Sb6svjuqr0UDvQ/
 mMwdN8R+
 Z34Qg1CwFQ6Eo9i12ea7OAO7HPrHoz+kEaPHXECU+ZEiMVt7qQ20zoqbQWVqgMxgy8BVG43IzQuc6AXhLoqX53VIqDKIeFRn9QtaUmixvfMl6v37dZ9W/6NCvaxTTpsYnsFWy/9kgJawAdNHpoW6KssHvXniNBzsPqpfdJhDBfYHO6GGot5FdTkpyRwSQNfGlmM052gbjJiSlhlFDseVqoMQQAFsgMmr+tcMl7XIy1D0TPgxefIep8rPdwgftM5q4CxMOVhHeBqX3XipUGOlTQvf8+jGQeJqlNNNTB+J9U73Ys1g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 06:14:27PM -0800, Jason Miu wrote:
> Introduce a radix tree implementation for tracking preserved memory
> pages and switch the KHO memory tracking mechanism to use it. This
> lays the groundwork for a stateless KHO implementation that eliminates
> the need for serialization and the associated "finalize" state.
> 
> This patch introduces the core radix tree data structures and
> constants to the KHO ABI. It adds the radix tree node and leaf
> structures, along with documentation for the radix tree key encoding
> scheme that combines a page's physical address and order.
> 
> To support broader use by other kernel subsystems, such as hugetlb
> preservation, the core radix tree manipulation functions are exported
> as a public API.
> 
> The xarray-based memory tracking is replaced with this new radix tree
> implementation. The core KHO preservation and unpreservation functions
> are wired up to use the radix tree helpers. On boot, the second kernel
> restores the preserved memory map by walking the radix tree whose root
> physical address is passed via the FDT.
> 
> The ABI `compatible` version is bumped to "kho-v2" to reflect the
> structural changes in the preserved memory map and sub-FDT property
> names. This includes renaming "fdt" to "preserved-data" to better
> reflect that preserved state may use formats other than FDT.
> 
> Signed-off-by: Jason Miu <jasonmiu@google.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

