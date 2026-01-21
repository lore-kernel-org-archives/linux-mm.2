Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D012ED262B0
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 06:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D198F6B0005; Wed, 21 Jan 2026 01:17:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD0736B0088; Wed, 21 Jan 2026 01:17:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C26D56B0089; Wed, 21 Jan 2026 01:17:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4A656B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:17:17 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 41C691607A4
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:17:17 +0000 (UTC)
X-FDA: 84354963714.12.C11459B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id E5C2F100002
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:17:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=wAlL3gZu;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768976235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VcBL8d2Tx+2ZFZ5f3VAnB2vrhIOAq8GII6J/15sAm3w=;
	b=JDEvTT7tJsy/aQ1rhOqsYtUb/HAcvRUF3wSWYRs8Z5XHOs018VvCtA4NUXltS6/JetKRQf
	DeKtoNMrhOOE/bLY3ZLTAI2756x4e7egVGrcRBXHM12ojQlV6JjurSAYNGA4XegFH/uyP7
	mFbrTDGJAKEIcuzk4D5KnuSs995tQps=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768976235; a=rsa-sha256;
	cv=none;
	b=2IZBqgq1ZeJrwwWuHN8U0Ue3hOkL9Fm7+L7PPvIIjwffylfNgmobXcmLJqCsYHrnz2jst1
	3q8y4VYeOnayzE4imNXpf6Rl/vIqKWTk+ERHgisI357u12woVSxfnZaDNuuxynoOv4nsx3
	/7f1wZtej/mC8LWfgdJi4x3JFNoxhzA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=wAlL3gZu;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VcBL8d2Tx+2ZFZ5f3VAnB2vrhIOAq8GII6J/15sAm3w=; b=wAlL3gZuurnhVR3RZjXKIacc6C
	DpiVRxRwhsGlnwZyo4oOr7gwAAOmSM1QpcrMhzvtzC2a5dNlB2zSXmOBq+BJPwMTASNR3KTVLGalm
	QZ6oupbY8Pk6H5cCP8WIL7dB+eq+P09obvWC/g28IRnOa3b3b3yXR0CT4nwf0bymuvFTUFOrBwUk5
	WNcNCtx9VR99V9JVHqE16LQiYcQV6kemYKmE7HHk7jfhdUBOlgHkrmYPdx39KDMcfNcFp1W2q2x18
	8LTk3FPsYCR9Rnip4hR/L+2BiFiza33+vRZHV4ozeQcDGOyNIwvwSffWvwPPh4TvRoN/+z0W1/F8O
	hGV7VqQg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viRWe-0000000FyFn-0Vs4;
	Wed, 21 Jan 2026 06:17:08 +0000
Date: Wed, 21 Jan 2026 06:17:07 +0000
From: Matthew Wilcox <willy@infradead.org>
To: zenghongling <zenghongling@kylinos.cn>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, zhongling0719@126.com
Subject: Re: [PATCH] mm/hugetlb_vmemmap: Use max() macro to simplify the code
Message-ID: <aXBvY_MjV2GZ0WPN@casper.infradead.org>
References: <20260121015114.560424-1-zenghongling@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121015114.560424-1-zenghongling@kylinos.cn>
X-Stat-Signature: xjiojdtje9xecn765jsxtpx67t9ftiun
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E5C2F100002
X-Rspam-User: 
X-HE-Tag: 1768976234-217317
X-HE-Meta: U2FsdGVkX1/37eMVMJ79EiYwJRKIFmp5txi3BPIxmzXH9vut+8mApYq5N3VsO5xxk1/6+8pGUAYD8AOfDhXmJMm9b2yXMVLuBaCPriTx0qBvQemLwwUTKmWelXaWUR8a8etphO7wZ+iria1HplMhaheWG73t0f8ruz0FyUr31AzWtn20XpibwI/XwnfRasJDEykYIv3gYgkhwatu4iOpRPd5f/NQs0Ql0xIr2BPV62cKEVtzZwUp31C2nPUwJMGhpE7of4RSidqOzsp7lflzfsd1sxpTJj6OpVbjRzMYMdvfXu0wQzPjqN4IdebE8a42jY7+DdhnxvAPfX8L9GIOf8j3frkKdnDZCoUwv8frz2qmMMuUlonzqgsFKScFcMtoDpW1Kjh7B0p5XNu8XpFmFtF7DXyPXm+LgIhxlFM6XqCrHNeI0PX8mm5K6wFQFS11xjUthjK+GTgoYSk7umQCgEiAgasX2vG87kBM9lbwIZdYYF7O8/Qs/Yqlgy4LE+fmn4s0nBM+/SNEiQwGxSfQh/C/iJ4swA9rmAFXl/aCsIMFd/5ZowXqWxOrTyNwL7stgXdnLhltinIGa+K9axyXQa11u3bt2mTkwhk6YaskWfqFc4WhvCMLX1M3ZzVldsx2AhF9nBBuSIJZR/LzLPMDMM8SnGo6PHmuwlmCgIwWAohlNy8BerJYeKxz/5O1wF4RQEQI8A96N9uYpcElDzWOCpr9eT2XXekPJbFMDy0dPgn3pTl9x/xPf/BVxZTLg/MjK451kgZ4mEqTFOyn8Hs/zlfvn4ZyvSV7kDxfm/IqcGEcpjT8qZfp5Qkh6ZZrvCQoICxoYACY1qRSNQaSZo5V0U5cn2R+WjnKkXWPVUJ2XYHw1uxRiz1hGuY/rSA00o3P8XL5atFUgDCx/RW4h/uXI/9xxBUAzkiPjtTt7Ux8eLsxIjWkIc6Ev2QNDWL1+OEyEsojV0IkkQGSRFh4G7T
 G2G6gNGX
 savSenaEc9Bz1FkwwZ85Bzny7f5FC6ESMWkWXaBNw9KR2B7VRmu6yb9bkhUskCw6eCpsWVelrpor4NvyppTbeWhpcdBZz2yR1RwgzVvj2v+U9aRyAgbL/Fcf9caRRWXIIhBQZ9pJz3TrgWf1dfa81/3AGEsyU497lolXTLa2eOlmkmlpswNtagkGhdclTan2ExaGVs7Xt1CXdRYc29tsDZmVaiPOSNtHiTdxmsM85l9hoOw0+TqwyTaG20dD+LoKIRl0rpAx1sSu3Ujuk4fhWhh1DuCW5CwtkZ8LShKpqZGykpAI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 09:51:14AM +0800, zenghongling wrote:
> Use the max() macro to simplify the function and improve
> its readability.

How does this improve readability?  I understand what this does in
the ternary form.  I have to think far harder about it in the max()
form.

>  	if (!is_power_of_2(sizeof(struct page)))
>  		return 0;
> -	return size > 0 ? size : 0;
> +	return max(size, 0);
>  }

