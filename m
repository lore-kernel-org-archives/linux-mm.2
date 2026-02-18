Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AD05E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 09:29:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9456D6B0088; Wed, 18 Feb 2026 04:29:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F2896B0089; Wed, 18 Feb 2026 04:29:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FEE16B008A; Wed, 18 Feb 2026 04:29:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68F1A6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:29:23 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1591CB9710
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:29:23 +0000 (UTC)
X-FDA: 84457054206.19.1170E03
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6F5CF1A000F
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:29:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771406961; a=rsa-sha256;
	cv=none;
	b=iM5EOQeHzB2YIpmlI+Ni2n0plc8xXVC63ELIsIM2LbWq0Gn0LwZOdcROBnNOgjukthauhu
	O71Msl8wwftIWcGvqgJRidwWIr1reu/YD9h6fb/0V9AM96lVxWuynpCctKeUYjoClwTSdC
	pzR6raIJJn1vKJF3PBUUmPPttSDaMak=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771406961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qn7eNXksb+tXbYJau2jP0gtFK32RD1iKf8zKULsX7mw=;
	b=V34yseUU5UOaqsSICH/1RIGXjDZpo124Y72EPL3eAZDnKh1204AQUYXerVv0SnkoJg3gds
	c9bGLLl6h093BcIjfPKHXlFsClH2HTsIfFLizUu/COoLHCyndfVSZXGyF9pAYzXg8YoWgo
	JFdtHX6VNMZfTvP5XmOyVbJuzo+Dbns=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 102A41477;
	Wed, 18 Feb 2026 01:29:14 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF0D63F7F5;
	Wed, 18 Feb 2026 01:29:18 -0800 (PST)
Date: Wed, 18 Feb 2026 09:29:15 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Jisheng Zhang <jszhang@kernel.org>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, maz@kernel.org
Subject: Re: [PATCH] arm64: remove HAVE_CMPXCHG_LOCAL
Message-ID: <aZWGa149nbQ_Nc_o@arm.com>
References: <20260215033944.16374-1-jszhang@kernel.org>
 <aZL46z1UZkQlF3Dd@willie-the-truck>
 <89606308-3c03-4dcf-a89d-479258b710e4@arm.com>
 <aZRyzy0SJ8uF3K2J@arm.com>
 <aZSChrCVnoWSe7h0@willie-the-truck>
 <aZSb8VbCC471Cw1X@arm.com>
 <a537c546-2fbf-4509-b668-33851e0d44d5@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a537c546-2fbf-4509-b668-33851e0d44d5@amd.com>
X-Stat-Signature: btaexwfzxdw3hfqtj7x8wxzjkejts3ow
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6F5CF1A000F
X-HE-Tag: 1771406961-648024
X-HE-Meta: U2FsdGVkX18FTY705ej1vs8GWLgpJkjNTaFX4efC4kbnUo+HvLevr7TJgfoR8A1uzbJuBwmoKFi3fNbHQM43gclCmTQ6dr1qBdIO+BHNktxcjKhOKY2wiaeTQfbf3hAvwPLGYyRTszhFlHlKyvZRSdYYdnNIOKoaGGkAOo5lrDWk/YSe1eqsxZJzeWSjFbV+chZLWqWU/6UQrSNyrpo5+9MnIEnJ+soQOck4A5xjZjsEBf097s6Wx8wKkX1cT8apkZAL0WW4SMfoCgdnR7X7QhGITbZJbPhx9wPIUH0cUGYIFu+nEVRqLSa+L5PpzroDyTpLVXSYeuGYra4LWgdK4zA5GPuxEBJNin03Gypx+plsOpZvB6mEsO1HQMsoDeVpKtC+NctY7AZwnQqjk6ZEtENBcOfVZccevN45VDvRZXWGbdRwcUbTTJV/GCMdSw1teumY5jVp2wIQiKtxOWQbVlObNFGEuICu8Nyu8qTQ5jNVw18wQqMCz3tKuGZb54Cj/Cee8OzmQicapBSEQjhzEjyVZs9j0Z1XNjLV/7grL3x0CFqh1TJnMPBslfysEZgGn7WcgjLIlgSkDWATxmRlL+4PqgY60nlghyZdvFm+sZRb/NF74YgI8/3n5MKtsXkJHWroD6ty+yehD9/ob93iTpem2iNoxfsxfv2K5ZUiAc9IznLoRWBSFlSO/6uv6WPTcznwEWt8hCKI2HM/Cu4HJjSn4iK8UNITlxwITQ/HJDIirjvrKoJ/AIQLFRNKCcQ0fJTkeou6YIksg0MwvCCbRf2s+Vki7H3AXDPv3+cwDz7ceDYTjHvPtMITpHTRwaP3m3S5ZQ0mlBeYqiUI5l+SBApo9efRq2fkCR/umOc7fRi3h8mXFt+dv8q17qRot6st1iGnloGho1OvR6bRUr2g7tUEyrkCh0njnUnJsmlcg2u++EgWfeOb4EYXvbHUW5oF/AroKGKCDafbkPK9Io0
 rnhzzVqC
 CPu+GwKWhjJgUSgTydXjd6i/RrC07x///F7WZk74K2sSKSeZekidFC6gSqvFf8bO0MQYhk585+AUG6EQk17NbKHswVNsUXHZXN0evBKx0fvM3TzUefSln93IcZGBAar0Cp3w2nVXtlzpTXehBjpU0jNmWlLc7FfIbgc/y560ZTNR+8PooZSjD/aJK9PTiTlR5PPSdLdBBGeR+O6hLVenhi43ZgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Prateek,

On Wed, Feb 18, 2026 at 09:31:19AM +0530, K Prateek Nayak wrote:
> On 2/17/2026 10:18 PM, Catalin Marinas wrote:
> > Yes, that would be good. It's the preempt_enable_notrace() path that
> > ends up calling preempt_schedule_notrace() -> __schedule() pretty much
> > unconditionally.
> 
> What do you mean by unconditionally? We always check
> __preempt_count_dec_and_test() before calling into __schedule().
> 
> On x86, We use MSB of preempt_count to indicate a resched and
> set_preempt_need_resched() would just clear this MSB.
> 
> If the preempt_count() turns 0, we immediately go into schedule
> or  or the next preempt_enable() -> __preempt_count_dec_and_test()
> would see the entire preempt_count being clear and will call into
> schedule.
> 
> The arm64 implementation seems to be doing something similar too
> with a separate "ti->preempt.need_resched" bit which is part of
> the "ti->preempt_count"'s union so it isn't really unconditional.

Ah, yes, you are right. I got the polarity of need_resched in
thread_info wrong (we should have named it no_need_to_resched).

So in the common case, the overhead is caused by the additional
pointer chase and preempt_count update, on top of the cpu offset read.
Not sure we can squeeze any more cycles out of these without some
large overhaul like:

https://git.kernel.org/mark/c/84ee5f23f93d4a650e828f831da9ed29c54623c5

or Yang's per-CPU page tables. Well, there are more ideas like in-kernel
restartable sequences but they move the overhead elsewhere.

Thanks.

-- 
Catalin

