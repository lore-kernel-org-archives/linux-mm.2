Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63311CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 17:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85A2A6B0088; Thu, 21 May 2026 13:39:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80B036B008A; Thu, 21 May 2026 13:39:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 721346B008C; Thu, 21 May 2026 13:39:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60DDC6B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:39:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1916040458
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:39:55 +0000 (UTC)
X-FDA: 84792139950.04.CE6BF49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 784BF10000D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:39:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Un7uQ1tr;
	spf=pass (imf05.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779385193; a=rsa-sha256;
	cv=none;
	b=sypyCQ5Lu+q/DokvwVXrRVurDeI8Ka9E3aeep+mzUhaBYa5LTBp8epZF3C4otuhwlYT+Fs
	VhgOxVP+YjxbKnBTL3wyq0n0Eq8XogLs7rpWMlUl7Dy/PGt6EVpj9/4Ozwe8/J7QwWNllJ
	Kc8coHH7fhgonjY4Y/kOY9MCFQbpZSg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Un7uQ1tr;
	spf=pass (imf05.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779385193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oJO1RcjiVrxikN4S2wMkT12NDdZvJEOL3uH9OszuZ6c=;
	b=fFovADpXvGWTGxcHkUH/OTc4EJ3k0fG/e/u7RVeR/mYd7eKDa9o4OQPjvIo2Xs/EpSerK5
	JR9M15aA2KDXvoXXR47NS1dfH1Ilyek9T4yCT8+VFB1iA1X9KeWO5n8ZazcKSrNfpeRi9r
	215nuWlmPef5MjImJnjZfQnamIeQqV0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C92F260098;
	Thu, 21 May 2026 17:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522EE1F000E9;
	Thu, 21 May 2026 17:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779385192;
	bh=oJO1RcjiVrxikN4S2wMkT12NDdZvJEOL3uH9OszuZ6c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Un7uQ1trx83eYUwW4uPp58qqvs/tOPLwPdqNWzVDB8TdjlrZg3PYemqiyguS3thAl
	 r5RMzSbCtDUCq1L5OYI8C19bFj43M0ei0laqWrel3mO9LzNY0PA/u8Ptgb2zjXkot2
	 eoZz4Kddz0tCIF+7fHSC4xxd2IiIXm2k+VY+P+lIsIDTjHT2/7ZXPguRju+yNr0L+f
	 pFtwpqfwkaItBOWCFBjHxFXJTPs51yxkfBgXyyyf7J3iVxNSXdfyacp6+G8MEDGXxr
	 FX3BkCtVScCsW3lP3RgenIgDaBUVQx1qv4re9v+xWcd0RfpNKUveGA3TM05F1+LFKb
	 tJVgWkvmEwd9Q==
Date: Thu, 21 May 2026 07:39:51 -1000
From: Tejun Heo <tj@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev,
	bpf@vger.kernel.org, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] bpf: Recover arena kernel faults with scratch page
Message-ID: <ag9DZ84OyofILjHM@slm.duckdns.org>
References: <20260520235052.4180316-1-tj@kernel.org>
 <20260520235052.4180316-3-tj@kernel.org>
 <DIO99FYEHNC1.23KFEHRPTRB5N@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DIO99FYEHNC1.23KFEHRPTRB5N@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 784BF10000D
X-Rspamd-Server: rspam03
X-Stat-Signature: o3cgp97qztx9ktz98c5jh4uyu56i51an
X-HE-Tag: 1779385193-9854
X-HE-Meta: U2FsdGVkX19pO/Pj0JrUBEAgtGRvxhpl2hAdJDe4keeD2LGvsZfOVLaPEiK2e3N8i7Npn7mAf06Fk4QdNeZudWiU57cakl3GZWFMNMf3NxUZ5kw3DpOVRBW7AZkr53DWhuIwirWcnYc/dTi3O8Xz/fogwHjgPiB+AENU6Ln8m3zt/QcfL17zFm7HahIOsriw4q+mBtumGTOy9uXZXeP+wSnyNkUMI8QYG1hg13gHjUvmY1XpngzmL3mKN8/3DTBw4MCJjh7Y8ZqOfgo2p2fdgxXpmodgb1m+msjxeaJxggwmgk6jD9SHQq5Xf12qLEnkspOFJbd5Qi1Sg58qXwglWjJDW1muo5SMtsDZCxrumnWmTTfNZVU1jlfsVYHx17f1Il6wGvPMJ5p/vTRuA90YXZurU7h+VpMVCbGyMiRZTrrw70fQfMr/kzNwT/m4ihyuBW5UAvmY1RGzEYZnwio954JQXxsz3u4kmtEYEr3HBd83x39Tk4oj+tFDazQyZqigcU6MPS9MwzZjjFb0oNuMWPsPZ0vpv7wAheDRv1NOZhy7M7RcvulCBenaa5icmRcxzSRG4fc21FVqqIS2B4ed1odB4MQiWtGqjAyQ7aXZVgh/fXFyy+egEIm6ylnCyfftQkh0QjWpEZDhmjob+cWrNyoG/kMCaYknP1ZDhEDEGZP+LYiZ8sorY8Ev805NjiI+kvjOpR5feDV4AAChJl9aKcZpZ9H9cGFMxO68NpEhf3TAPUjmd19L+voQnKowJPnCzkxQzGNXzSepnjW2eWYoDFtwaOtO7lVN7q/lIA+Hzi2EsuFXhuBdAPJ/KYgFxbIIetunr6VGAQlgikffAVCJDRZ2XjXqXE4x2U0rVPspgv1d3UcOe1dcrFmfQ7mq8SM37OzaD6Yo/FhFiWBoteU1TfBjE4moq7QEWuubrhPK6Bg+6sUwObvIbbJRbCBr53MMOT6MU26r3qicMlYl0hc
 w5TzqoN+
 LP485c2uFF2bb4mbYM6P3oCWkFkWC8pxqlRd1UYaYqaWX51tC6yUwbIsH41B/zzyZT24p69ihAHue5kUaTYkD/WLu+G8KI8vAC9+GdZOyYLj6Iyqm5roq3eH5t52y0q1OxNWPoTOxc56mChQAU67CFw/9idsWhTD80N+0f6vEIBvngk6fgnLVfK2KDJP5RqLZESAGo3Ft2rip5ou5v7Rhi3kiKJzPsl2BTP1WyEQAtZswgpfqI5sjliWdw5CRCorv5yKL2eUvQYb4Yb/Mfp4vkrCRiRqEgjTcmHRM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 02:42:50AM -0700, Alexei Starovoitov wrote:
> On Wed May 20, 2026 at 4:50 PM PDT, Tejun Heo wrote:
> First 5 patches lgtm. Should we create a stable branch out of them
> and pull into bpf-next and sched-ext trees?
> I'm preparing a followup for slab-over-arena on top of these changes.

I just posted a new version of the first patch w/ comment update. It'd be
great if we can make forward progress.

Thanks.

-- 
tejun

