Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B36BCFA747
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 08:13:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A89696B0062; Fri, 21 Nov 2025 03:13:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3B096B0096; Fri, 21 Nov 2025 03:13:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 977336B0099; Fri, 21 Nov 2025 03:13:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 83CBC6B0062
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 03:13:26 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AAAFD4ECF9
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 08:13:23 +0000 (UTC)
X-FDA: 84133899486.12.BE6732C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 15BC620007
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 08:13:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uuy6ZZsm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763712802; a=rsa-sha256;
	cv=none;
	b=g+4eUCpKj2cANiAIZZc6LL/ImDx3Webq6mRRi5Ff24mAfUQ2azYNc1UVXh9kE7FNIfRhWf
	TQtQKQrU8XQns3SYJ7hzNq52sq6J9VzOurjFU5naHOGJiQekmptWCNYa5MxcBmnp0W0Y9w
	9yPFFCjOVI41SEjH/VhidFUz8t+xXQ8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uuy6ZZsm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763712802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wHkBL3sxG1p8CtoCQHRZbNA0MrGszKgzlq2ISKJ9yP0=;
	b=U0AktbdNXVDOJt++lI/aoTkloDUUEPdVflcVF8hZ5ckNKO13FnHu6ImuCtXYyvssKvYgIk
	EFlITaRNJQtfc7oDNVrGQiBzyEmOTwO9UC3o7Xh5J/rFqa1XDclqTCoaG9scghjnBpGjnt
	9/E4WwLaSbb5pHJTm7xLmoLrwmeB5Jo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C319D40B1C;
	Fri, 21 Nov 2025 08:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDBDC4CEF1;
	Fri, 21 Nov 2025 08:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763712800;
	bh=r0SQs2L4kV96eXA5ek224oIHHwc4SCwPNdL4FqIG5OY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uuy6ZZsm3vRhy+kugYgjzAQlddWYfxNhX4+quSyuFFSXDIE35/y8Xfa7pkuAm3W3P
	 Hs+rhGykqMEBVZrYIQeM8/kAy7vJ9DAxCeADQx8twhMd4RiIm+4Tf95tMCKMd/NFk8
	 kxmakSAkknQHLWWvdpLlLh/EwLqYNg9H8OrACYUtQKCwxP4HpiJNSHAQt+uWLica13
	 bNlQmTvj9X589zKfVFdbMAbAHtxE+N+rdJLJRZ5Qo0Lc8lXFCmy3CeheVUnqO+o55w
	 KgpjgUZjdUUDklxi8nNEZETSBc5ycZn5OGFJfeDyAM8nse4v4jFhX74KqH7OpNV08E
	 Lkfiii9DKQ+EA==
Message-ID: <fc85d934-bd1b-4fbf-b4ab-37ba061e72b0@kernel.org>
Date: Fri, 21 Nov 2025 09:13:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mremap: allow VMAs with VM_DONTEXPAND|VM_PFNMAP when
 creating new mapping
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Kasireddy, Vivek" <vivek.kasireddy@intel.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
References: <20251120053546.2885836-1-vivek.kasireddy@intel.com>
 <976e9916-c949-4fa0-b92e-87f6841b5cbe@lucifer.local>
 <IA0PR11MB71851184AA5977BBAFBD55C7F8D5A@IA0PR11MB7185.namprd11.prod.outlook.com>
 <070dcd0f-ef77-4924-baf1-6c380bca192d@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <070dcd0f-ef77-4924-baf1-6c380bca192d@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 15BC620007
X-Stat-Signature: pz459wr5zcnoetprckafy31he6k7jewx
X-HE-Tag: 1763712801-753842
X-HE-Meta: U2FsdGVkX1/DDvgObVhlOxcNDzf1GGySXdMEpE8jx2DuHFtNRUIR2j2EszIBpjj+5JZBUSQyOQqWtpRbyO8Az6eg2XtrtToU5oXwrLqiMZH7ZYHujeWM1thOaem5LHVkXNbvfjoypSDGv/s0Ypzm4HlVAWyZsJuAIpy4gPrpttFeL1f/y1tlPH9Iiouefil0nQLQPU9wUCChhT5V3b4kludZhEWTJfiIy01AKTtG5Ldew/ISPNvFvI+LtsLtC3MZBRRYLBqcK86Dq1P9e6R2ymDc7Z61jysyZSVClGILKb4CKcZ9lLqwXyWRSbVnEgdwEaZNz89248lGq2fgBonqCA3u3UxpPwz/S8vt3aWDD21EEwhPF1ZkVxCp8jap8P1Ij4VKrYlGsBF6ww5ikAUj4a0BdYbX7G9ShcBWU+JhsZ/qiWnBxP1cI6RuC8IiavJ+lRfR6yrqatpeTktlmR3+EdyQWiBhOVuH3Jyou6y7r+YS+ezIK30+5tOLChZbsPLcUX6NZSks1usF+u+9+erAN5RzAy7O+jizHoPR/dlaW0WcJO3uvv5SKcZAQRYoOwhIhUHnwG+XvqOAbIkDzLLLw90xpHofmwG0uo7wAe3dHJKbmt40HmLlZTFg8msoHMFfrgzGLpjNwz9rHumaVM9PVnYbAYqy/AltjU4irPdc26DA+4wtQfqboxXsPoLq209G5FRA0OQ+HNYh0ZFTpVpIglCDyJ3Qlc5X3x0SLNlpNAtYXqre2hy9mvj7ZWdlBGnUKCZ1bi0BNABAEFK8dVS+BxQsMDFnaFiVKB6l4LCjzdrBoZ0htYCjwrNXzEYbcXXG8dvYnonI5rq9Z6WN522gEHimvMvDtmem1rSQ1eKrp9mxY8BE97WDNUxidSYbKOSBiTeSIfWD33vOXqCrb9FWZvfLQe7sCchWwlSNGbLcE/AHK/8fXbRifCuEBbajtEPDvFpZFqe6MACLB5u7G87
 6flRjudA
 9bjuXLRwkuGS11G+kAfDx6GwJkE7/xpniroBg1dgRon2HHRY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> Another way round here might be to try to use userland to figure out the file
> that a mapping belongs to via e.g. /proc/$pid/map_files, determine the
> attributes from /proc/$pid/maps and then generate a new mmap() call with the
> same properties.

Right, if we could find some way to just obtain the file/fd we could 
just avoid mremap altogether.

I recall that CRIU used something similar to obtain the fd of a 
MAP_SHARED|MAP_ANON mapping (anon shmem) VMA, but my memory is a bit 
vague on that one.

-- 
Cheers

David

