Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28112606A332
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 22:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kAxaUji6
Received: by kanga.kvack.org (Postfix)
	id 425CA6B05B0; Mon,  9 Nov 2026 17:00:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D6DA6B05B1; Mon,  9 Nov 2026 17:00:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A2956B05B2; Mon,  9 Nov 2026 17:00:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F37106B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:00:20 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8B1A64080C
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:00:20 +0000 (UTC)
X-FDA: 85416949800.19.C3F2C06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id A584D1C000B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:00:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kAxaUji6;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794261618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+uUNFNsJ/y/TsHe5tSEE2ggVSbT2u5FUwgZN1VUTMzo=;
	b=HHYAhZmyJiBVZ53LTZA03BCF/TEilBB3pf9ZkoZhNy+96ykQqIci8kfZ/MZY7l0/U1rl+V
	2HRk7iNN0dSxJ/PegMs5h70h6jF0rSd3TcLjLrJ2xK8vtymhJmXu8qE0Aogbk5BwEfoFFn
	iQePXzOJDvNAuJt6xerSHaJv511Hc8E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kAxaUji6;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794261618;
	b=VDqB4SgM387h6+BuaPSS1/CCRvG2Hpquk84lhBAU51lZsWvyaPy5muBwleMF8YJkMSYA/L
	VzE62ZbE3rzx0nN+e8XP+YtQPx1dlq679HGY4139x7YZS4eotLaAuNsOtURPpOIwmehlyX
	65fbd+C9f3VYQflo+aLR7ZSxnfHwlUI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A52B43702;
	Mon,  9 Nov 2026 22:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6216E1F0089F;
	Mon,  9 Nov 2026 22:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794261617;
	bh=+uUNFNsJ/y/TsHe5tSEE2ggVSbT2u5FUwgZN1VUTMzo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kAxaUji6k2KW8rfSAvXJhJiuO/EZX60VCydj5QPGZtcNUy06hAoNW9MKWzQpV/4uY
	 142BRjiWbeltdP+9LWvBZfp5X6D9yTvRt07tXHpQJQcdUSLNrdfPrpSOMbUAEzgqTJ
	 HpoHuTXP9QBCPx6WtPB9860DKqnLXKCenm87BaDg/78/XEw1a1CZdxAudNjGgcTC0q
	 a5a+b5trvcOnvtXTOE6cSO7RlzSheWSRnx8xcpPWyP7WaNq+puxs1zaPHfh94lUUPA
	 vzgZD0i0Ir0h7TMIxXspZ4uUgVnKKFn5jCj1KLtemmJsQDjBdqPd4VXe2ZInUO7b9F
	 xPh8W3FLuSQIA==
Message-ID: <b47cc8f4-3f8a-4893-8a2a-f88dd5ab762d@kernel.org>
Date: Mon, 9 Nov 2026 23:00:06 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory: drop PROCESS_PAGES_NON_PREEMPT_BATCH
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Ankur Arora <ankur.a.arora@oracle.com>,
 Pedro Falcato <pfalcato@suse.de>, Peter Zijlstra <peterz@infradead.org>,
 Borislav Petkov <bp@alien8.de>, Bharata B Rao <bharata@amd.com>,
 Hrushikesh Salunke <hsalunke@amd.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261109-clear-pages-batch-v3-1-6693efe18dff@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261109-clear-pages-batch-v3-1-6693efe18dff@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: q9g4xbg9mrsaykcgzs55adqhicbtpinb
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A584D1C000B
X-HE-Tag: 1794261618-843939
X-HE-Meta: U2FsdGVkX1+mwxpCcV56yCXID4hBTUSE5jkQ9kNtb+fbRItQS8gJDpJB1Ijv9I8m3N+GuMr6Uq7tT0er8Y0ED4qKaDaHDJgwmYBKzjlrmwCSSgfzlYwZ2gGBykKoa5KDrVFbwdPHMBQ2VAHe8w/QRTPXK8WqD5HeOjSnLDNE/0xjJ5ox0+qiw95jXbgoIOUwxP7vgMSXhVIb/qsQzRiH+VmO+95f8vDc9U+iAOITNwED0XhxqyGcuWGAo+SnaggY2YKorjqlUj14wuR1Nb3A0RfxvlLylguB+7D09XB6F5qXCeoabZ2NcdlzJHcpayHTGmWhEuzNUsTo2O4aL94DN3NYNbsz4lYDK7grtJLQLMNJPlD3aemCtLiCzduCqQtBOSLVvMF0cIx+DEuXOX/KZ/XYZXnI9K9j9lWNnmoICFM4GAaItbZHWT33hZ13/TQsw4vN5scuoSoJVslTwDYRBmmPTj8R2U19VH2u6scFfvHfxDYp4zBfApFgAtmG+rpJ5wAyN4muDwyTPdZXHhzxIAiM+YhLF0AvNvux351OCznCZHby7bTdwIZ+9kJ7K/MfykRqbt/6k+Jan2sGQfbg/5UFy9A8KNV0oU6w535L54uL/mzH0GRaD+ZGEBdI84eF8CDyychlQ+EGqiSNXOdBK14+0Glia5QdxiYycvDVM+rTD1J1XEe3l5NMHsJNRlXRszfYmvfkHgC39FxrGlfkCbFUbb6I9NKO3FTOTw3FjfVOycLe2rmlbfRtK9nuIRiO/NPPETDF+GykUCP7S55qeQqNaImpf8v1/SXHlpaKCUexL/UQedyQvjJVQoOvYvpKXUG1yBpId1HTMIkojQSwmLl+dFPtyB/MSk/CuEMwJTiIpfJOG1SYcfKRhWxqBSXlcB1vt9ZAEKLMjj+cLTlZy9lGcbRFanXq0yY5VXJALcbmTwNQ1JovSosJ+5VXkIMwW3VoQlCdAsfFIwiRqxC
 OrpnoO0J
 LAnQhqgxsztC4mx6BOrsSGvWqXvVGLT5e7L2lj2AJg2JIIlTgYinY46Sevt5St5bbUN1SDeBzQqpP3N10HqaWNdP+ugS6guwe7HojRbv9s2wFM3okfgBVhH0PG8G9/BfTgzYu9U5YAfmMqcAJy13oWOuLMRxDB3As0AUvvFzjxQwCcFKhv3KZhbxceV1shmuHfS4knyz/oL9QJBeSHR4+GRYWE0zlE6+vaY4Trs8OD045m3CEkktBPByBwATwy0PhbC3CtlASYfMF6ivNwKSSmok2DX7YsLeHY0EKmLAGLJT0vFEbtPoD7s8c6SBl3SRfzJzUg1JUrbKsrgq04GnL8qcsrBBAJ6yxhjB+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 20:15, Shivank Garg wrote:
> clear_contig_highpages() clears the whole range at once under
> preemptible models. Otherwise it clears PROCESS_PAGES_NON_PREEMPT_BATCH
> pages at a time, with a cond_resched() in between. The batch is 32MB if
> the architecture defines clear_pages(), and one page otherwise.
> 
> Since commit 7dadeaa6e851 ("sched: Further restrict the preemption
> modes"), architectures that support lazy preemption only offer the
> full, lazy and RT preemption models, also with PREEMPT_DYNAMIC. x86 is
> one of them, and it is the only architecture that defines
> clear_pages(). So the 32MB batch is never used: whenever
> clear_contig_highpages() runs under a cooperative model, the batch is
> one page.
> 
> Make that explicit. Clear the whole range when CONFIG_PREEMPTION is
> set, and one page at a time with cond_resched() in between otherwise.
> Drop PROCESS_PAGES_NON_PREEMPT_BATCH, which has no other users.
> 
> PREEMPT_DYNAMIC kernels also have CONFIG_PREEMPTION set, and
> cond_resched() does nothing on any of these kernels. So a build-time
> CONFIG_PREEMPTION check is enough, and preempt_model_preemptible() is
> not needed.
> 
> No functional change intended.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>

Thanks, I'll wait a bit for more review before applying.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

