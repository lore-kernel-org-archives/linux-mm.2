Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6438BD116F3
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 16:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53F186B000E; Sun, 30 Nov 2025 11:43:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EFF76B0010; Sun, 30 Nov 2025 11:43:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42D886B0011; Sun, 30 Nov 2025 11:43:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 341716B000E
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 11:43:42 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BBA145D614
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 16:43:41 +0000 (UTC)
X-FDA: 84167844642.29.25E5D8B
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id D859A18000E
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 16:43:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=HpNXuYeZ;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764521020; a=rsa-sha256;
	cv=none;
	b=F0uTSfVF3fdz3iPjpzMgW1e4JaiOduOxYLaIFivONq8nWac4dfzmGrqIvY5gC6gtlIxJm0
	o7cHuypDEKgXUDcmktoKDs6Fj/ZC0kzV4L92Vf84KsluqySGuWAYYAnreKiWXiQcVVjllr
	MTtFSGFYOKBXPgbtK333TUaDohFAxoc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=HpNXuYeZ;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764521020;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6TQMOQpqW8krGAHNp9tR8czsOrAsd6ZBsxnO6QRI/Ns=;
	b=L1dHFR2c+l6hJxH0oQOA63/Mszkz3WIxO7YsLQ2QSFmrNblmeF7cZNpNTxy0aFHhpFT9qk
	DkCAsDsh4qB17xtlU7lYDtWZeq4URRm68I3BNS6WNoHquU3ofzuAIqpKY5yD0jRHRyLEyn
	rSNi8LksAgItdeZtZD0YmxEi5TbWNzc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6TQMOQpqW8krGAHNp9tR8czsOrAsd6ZBsxnO6QRI/Ns=; b=HpNXuYeZo0kYZQOCGgq6FzNrRj
	JAyLOPcOzLE6pPZPH5OwI0lMoZpoNfRElK9IBD0C8ELiKmjaa8VFl6UQHry+OkV1hh9BD25mPrfs6
	Mb9B2Lpfwuty8QhaGjWlzAzHMy5YFP3CmRf6oVaR2+ZOVK+P5ssFA1J1sGrnYd1dh1YBPBuU7mRQf
	AE6ZwC8XWApOmAi+EOWX/jtHT7smdIbxCZYIbJpLji+DD3Ps0p+Us5YAvWQNae1A7w/qO8IJUB5Nd
	2Io+JAc8nsBDbjVHf4CYH8bbtN70dFeumER2EG8zrmAqTTrIYZWmvx2HjPd3kZEPK1rI65jSmsyqd
	LXsZDdYQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPkWa-0000000AnW0-12ga;
	Sun, 30 Nov 2025 16:43:48 +0000
Date: Sun, 30 Nov 2025 16:43:48 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: david laight <david.laight@runbox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-alpha@vger.kernel.org
Subject: Re: [RFC][alpha] saner vmalloc handling (was Re: [Bug report]
 hash_name() may cross page boundary and trigger sleep in RCU context)
Message-ID: <20251130164348.GV3538@ZenIV>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <20251126185545.GC3538@ZenIV>
 <c375dd22-8b46-404b-b0c2-815dbd4c5ec8@huaweicloud.com>
 <20251129033728.GH3538@ZenIV>
 <20251130030146.GN3538@ZenIV>
 <20251130113213.40c8e7a0@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251130113213.40c8e7a0@pumpkin>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D859A18000E
X-Stat-Signature: szmgbfog8a51ykqi79afw6jh5ohx3ktr
X-Rspam-User: 
X-HE-Tag: 1764521019-273082
X-HE-Meta: U2FsdGVkX18hEDKmvkrj/X60mX21jD81xDj1F4tl7OQEOq83bqwD0q8WW0iWdI0T9yXU/8B7Oo6PDpP07Lfe/e1g2lTJ9vjueWXg061srRhNSrWzvGxzFxVup8pziwnpfQDTuFhQxgbEdLBfynFSqYQWxoXO/gRoOTVge0hr/r/7yNV5GP5pprztOf7iltCV0bTRF2y8/hFyOEQP3zJv6w7YmJeMDEwkHgPdmCmnKZMRd3vAjHKMOqP0F63be3j1n7tuUJEjyYgzcTKjVEQIjADIjkTVtQO1F3137R7tR0OfZZSDuDIM7OzYlhZP0JQ5QXmegNG5G575IFhSJzMm7hcn3d475dEzX9xLdK2WGelJO++3QHo6QVgdoqhCOJ7b3SgLYfSSfTNIer68z5v2ZLGTe0sfmfIcJ3UAcAREbJySOxzq5oYvxppt4Mj2rMnyMKswMN687+oz3KWhnsg8Tu6xSi04fPVdz2LZYL+NXTOn3PX0OCe9ZK06FGMzKTZzaesUGbxsdGm8uJ0bgDNrVxO06Hx0DpsQzGND7JGWboyHpK4giRYHFLmadL2U9CnWrAV3yVg+gaFl9TzfB+G4aQSsAWd4Fm/GrCCTmLBFKWbmf2kS6+oSVvUw7hrH9+OfL5M82vrYc3JrKOR97HITqCJnLVpl7dnmYKM+a92tPFPpO/rfsRDnGcIy5idW/oqJvCF05te7nF0U0++LWmJ9MyqWCgcVakFv8q7F3HytWiEN5yvq5lnQ48IbkxIbRf3/m+8UYZov6CyogUgmKzB+ujj/PaFe6atIcpnkd5grw8G4cDAXyD3TlrD3cYviuKfg5fYNjpQZvckEuP6Ts5xebnxUb3Q2NMUvjUtez8/JjAQDn8WQPNp/9M3T+z3GzHpduz/5XgSvysZ3j5voqohAOA+ELjUDgwOmrR3/GReemenVFDqzMqprQy1/ugZgJZwZ2HMEjeMBYbNGo2CNh9y
 dDRhEtFQ
 S1cRVDzWHKV3zFTn+n5gQKRlIIx2Vy5fT8VsQax0+QcyxOLk6pQlanh8u1YQNGYtxnn70n3JE0SFXnj3IO76sv903iLLK9nie5MN4+/Kkymi3YP0QR9lRad/VBmF8OQIv9wd+Wg93HOKmnlAR4lLmTY1UgIdgs9r7D/HS0HB+xjVlA+UbH3tufI1BtMFQFScxe9bQ4B9ANaTOVL/QSjIjiGGFDgQEhHnPUtdPnu7806XvgR5+AVB50gwOwCouvCRJL1ootPBIIYNP0cUyUj4M9SpPbosNWrXDrenzZ1URI2UI7vnm4k1Pmu3t/zHZuWNUUJLZsFi/yDgFzNgGdilqm69TJbvMvinXMNVj9cIL36zMkOJWiju5oynaifd0H9OfIdYKkxL0jRKYjgMfZ/PkfxAJQ5y/44aoZ2VJcnTCfqI1kG75WMhgAak+AKNPR8pKL4fiIDpV0AxmHWpcDEaCHYwB+FHWH6x+bnuR+xg31BOTbBw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 30, 2025 at 11:32:13AM +0000, david laight wrote:

> How difficult would it be to allocate the pte for the next 8GB on demand
> inside vmalloc(), and then propagate it to the per-task page tables.
> That is a path than can sleep, so being slow if it needs to synchronise
> with other cpu shouldn't matter - especially since it won't happen often.
> 
> That should be moderately generic code and would let the vmalloc limit
> be 'soft'; perhaps based on physical memory size, and even be raisable
> from a sysctl.

Considerable headache and pretty pointless, at that.  Note that >8G vmalloc
space on alpha had been racy all along (and known to be that); it was
basically "could we squeeze more out of khttpd" kind of fun.

Do we have realistic vmalloc-crazy loads with high fragmentation of vmalloc
space and total footprint worth bothering with that?

