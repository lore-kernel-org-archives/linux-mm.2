Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B35B6F433DE
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 08:19:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F21F96B00AA; Fri, 17 Apr 2026 04:18:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAB3F6B00AB; Fri, 17 Apr 2026 04:18:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D736F6B00AC; Fri, 17 Apr 2026 04:18:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C14396B00AA
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 04:18:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 74BB713C007
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 08:18:59 +0000 (UTC)
X-FDA: 84667347198.30.347C9BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id A65A012000B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 08:18:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NpWidIvo;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776413937; a=rsa-sha256;
	cv=none;
	b=MeokSDGc0QgRIXzlU5nyawdsJpIUY754tdNHzkLQJit4T45VhVAyrSvBNVS9UrbiLepzf1
	mduKUc8vWTsRXIM1BwDUjEI/yPVS3yo4qM1ht+PjkUXIZHOlfE3rPQCbONowffIDUxHcnA
	jqtGuTXyMo14SL+aKlZwJPkq/8Dmhz4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NpWidIvo;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776413937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZtCo2eFhm9edLdC7XQ2jUFe7hZh6kDsOH8WKtYH8/9U=;
	b=IL0Q3EQv+SplTA1YlkejciJuEkBXoTSVd+tiLUFsYD6Pgh8hjEpxPa6Hhb+9YEQGUbovl4
	BQiVG3R72Enepx25ILXbBlA2csu20CfCCfMv5ay3JvlFneJ96Yso47bOwMzHb9gtlSiL0y
	axycC0yu+HtgV671RBGj7W5GuBieG44=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2288944276;
	Fri, 17 Apr 2026 08:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC8CC19425;
	Fri, 17 Apr 2026 08:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776413936;
	bh=fR5nlThMbPXMGExImyEeBY8sFNyMbZ/gR/TEPtcycf8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NpWidIvoscZeAhAF/z3US0cm+LxrJaTu0Ov3dX+5nGOn6CswrorKfY9iHZ7tLvUkl
	 N6q4Mfz9I5lR0dhQH/1plz8c5PU14UspgyZOR5AAw6LWCpYkArFVh+/kOhrf9jSpTx
	 OTRlhAl3PVIM5oD/q+wegRb6PqER5JksJvGladNECIk4dvP1vb3Bz/LN7HpQH3H4Ex
	 x+ax7pDdLz4fpbCk3wgu5UKJQAnNCEkznQfErIxW3CJ+HElELusr1248xY+ACsHDTS
	 HdnxV22HhDJTZULDwuAGed6gO9tAm6R2XLfCDGvbXb4dlDGbPb9Neot+dNyrZDrXep
	 N3qYCacHhwkHA==
Message-ID: <e9baaed8-4934-403d-87b6-ddd46e852769@kernel.org>
Date: Fri, 17 Apr 2026 10:18:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] slub: spill refill leftover objects into percpu
 sheaves
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>, Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: harry@kernel.org, akpm@linux-foundation.org, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.orgg
References: <20260410112202.142597-1-hao.li@linux.dev>
 <87a4v47xk5.fsf@intel.com>
 <wamsxmuhcbr6hj5y53bheub4cmkq7pd3psntl66o74k4bmtygi@qhyse67jvr3f>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <wamsxmuhcbr6hj5y53bheub4cmkq7pd3psntl66o74k4bmtygi@qhyse67jvr3f>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A65A012000B
X-Stat-Signature: 4xwtt9osk3e84q39b4ypmbfuzyj1uhsa
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776413937-960454
X-HE-Meta: U2FsdGVkX1+OLLSqi4ArkuP8JlY2ENSJhpaDCglJ6Wvc42M4vvosiW3tVJycl9CXK73mN5v2wxW44U0UqQu5eTkqqBwLxLKiZ+ojQsZv6ZABYSwt62YWAqZ9eTF5kXaBLqJLO20+2S84Dc4eI/i5R3R+1/mfJ++5RkgbapWmOl47EfX/0l2ld3zlo6zdl4wCTK4FO61wWoiiS4O3CwPo6TkapmaW6PulJ7vdWxKzesNXSAJRYK41GcsGgxholiB8d6ksp+S4E2iMzPbt7bXbUf3tWZmCL6VTn9exXHrqdB33L3GYhtQazEPEYeTjScfr4K0z9fWcBz8tlIlnX4848fmu8pJAYaoltulzdUZIRVULrtqVIeLg35NXlw73yu57Ee4WY5iEoL/uNhYcqnEKrtivtoYHuBF+wReoSxhsxVSPgiAfjfz/RjfqXFUpSniujM7NqccydzEP+x2Kj7p+1PKUOIezy2h9EicU9idGJjLAPStLfwg9bJ+u/EPu4Jx6Qk8TrczvgfbhcmO+fruvtUUEZXXUof0jN0nGygoe8d3+XvQJ4KAHFOHh0O4Y6fsouGDmoR8aFY5nGHtSEaYc1bS+AOOnN+kPpLFwyiCBhXtNFq2GLNqk2aftklZcJmX6UBsbH0pX7EkFwXEoIN/dFCrMLVGqm4Y43sfZ+hUGie8BVlwYO3vWOag+RDYHdXN5mlKX6H86dWCk++x51C85JCN0NS2/h2xJI51WjLiEVh4douBeDJuQMvDqUn2ju+V48uLPPaukb04Z8NIWElcxM7955aoY81JppNnv3FOZyNJ6k5YigixWjMjbCfb7t4Tt5d7eixbvoiETEx+p5YvJDzuxh8dqymi8PcX5eXbFjgDTGm2b1A7g52I7xQ8k2S2ldzL/0elLoa9YSY7SltEz0RsPV8URCWhWdUMBCrHYWbXyqcNEcB2oKw1wmLOs9YvVPksP/VQ8RAKHIYE5Ms7
 eIYojEr+
 f80jtmPkF9HQ9KLsDlM7SwRf9G5DUz8i2ep+CK7y4oXBPemnpH7EuO2jOIFjsROkcqiVKkKhMCqMPqj0GCGYLuHXZ9guQZeqRNhpW96KcaFXJJMaMSpnCbYGT8DsOPOAGXyZOSxP94PSxb3Gxsviqc16tazyedacydAOQB6kyI7Tr7OT3fSE2ceTYLcL74ZxRnk3fhqNrRkd/ro0cQQ/i3D6hLoy6FKsRPYE5D9nmqHwbuY7Lm+QOH+w/iPVN1KoiGmDXgbF8y/D4GJf9qJABZaEhDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/16/26 07:49, Hao Li wrote:
> On Wed, Apr 15, 2026 at 01:55:54PM -0700, Vinicius Costa Gomes wrote:
> 
> Great!
> Thanks for sharing those infos!
> 
>> The numbers are here (the commentary from the bot are very hit or miss,
>> so don't pay too much attention to them):
>> 
>> https://github.com/vcgomes/linux/commit/c898c39ee8def5252942281353eda6acdd83d4ea
>> 
>> I am re-running the tests against a more recent tree, but if you
>> want to take a look:
>> 
>> https://github.com/vcgomes/linux/tree/mm-sheaves-regression-timerfd
>> 
>> Also, if you feel it's useful, I can send a RFC.
> 
> 
> I also tried stashing leftover objects into the PCS before, but at the time I
> observed that this could quickly drain the node partial list, which then led to
> slab alloc/free churn, and the end result was a performance regression. So I
> gave up this direction :/
> 
> I took a quick look at the code and performance report in your GitHub repo, and
> the performance gains you showed there are really interesting to me!
> I'm going to try testing it on my own machine as well.
> 
> Also, the idea of a warm_slab looks very interesting. I had previously thought
> about something along similar lines, except that I was considering stashing
> leftover untouched slabs at the per-CPU level. But that would effectively bring
> back the old stale CPU partial list in another form, so I ended up dropping
> that direction. But you direction is really interesting!

I wonder about the conditions when the warm_slab freelist is actually warm.
If we have leftover objects on the slab's freelist after a refill, we didn't
walk that part of the freelist to make it cache-hot. So why is draining that
stashed slab beneficial? Is the benefit rather because of caching more
objects percpu again, and avoiding the partial list and list_lock?

The freelist could be warm in the case the slab was just allocated, but that
should be a minority cases compared to taken from partial list?

> I'd be very happy to see a new approach come out of this. If it's convenient
> for you, I'd love to see an RFC. Thanks!
> 


