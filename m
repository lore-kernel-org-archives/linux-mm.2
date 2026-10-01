Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C14E8CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 12:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7FAC6B0095; Thu,  1 Oct 2026 08:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C30C96B0096; Thu,  1 Oct 2026 08:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF86B6B0098; Thu,  1 Oct 2026 08:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88CF16B0095
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:00:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10C70403CD
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:00:33 +0000 (UTC)
X-FDA: 85273915146.07.46AE816
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4027B140010
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:00:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dEq1H6O6;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790856031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QlLXNEoEhaxlpUOmNEGk0GST558WV4z35ATUA2llJZg=;
	b=yIe/iVtcPgtwEbczbLZHDQupv5AqTUMoAFcX5eWxp5ltz7kp0RufIMr+VsMQ+u/Lu7dl7t
	j9xTRB2LuAKOrTtsYQ3A71RpuPq+qRWUFrF7EtqcMI1Kg/dLkcdlM090K8OvLOad97USSM
	aX9z2V/P0WX1jjsHsclmG53COk+sRiY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790856031;
	b=1OG09Wd/1VX9L32XnHIX/LJgPPqYU8oX71FJMk4oOavsXCqq/bsYnemkPa633/AwmkYBR+
	/g4jMKlKtbGmv58T7pAYmTB0yWc8vbXHwAAjX8UWi1+d3qqesT9grObDVi3pmQJJThmuee
	EHaBR073I7XSAACgoteRZJdzLB/nl0I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dEq1H6O6;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 27D3942B23;
	Thu,  1 Oct 2026 12:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC171F000FF;
	Thu,  1 Oct 2026 12:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790856030;
	bh=QlLXNEoEhaxlpUOmNEGk0GST558WV4z35ATUA2llJZg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dEq1H6O6x3KoA9AnzZqRIvzijzq08b3P6Io3AIK1goEzHYRIc0N6U91nJl/pQZihv
	 HZ6h51UkqSm1/09N3J8KJSVRfK4ajDFr7KzFjbAB71sqnmSuo5WI0tjBjg5Rm7Mgl1
	 Ba8aSeVPI1xFIimIPu/bRyHt4jv6OCI8zKvXbrDLZ/nr+Tkqklp3NZGp6c8K1/ZigB
	 v+deWysGRSfyy5iWRA18rxKu++H6yZTacu+w9w8ra7LAvi9SioyT3nh/9UcLnvxx0+
	 Kt+vEfg42NFy0I7XZwC6/lo6gnzD3rw8Pmi51L7QWPVmmoIsjy9vDez8SSnkzrf44Y
	 19/gVHtZZVDsQ==
Message-ID: <b45813af-df08-4270-93ac-d99ee42830ec@kernel.org>
Date: Thu, 1 Oct 2026 14:00:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 6/9] selftests/mm: mremap_test: replace random data
 with deterministic pattern
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 John Hubbard <jhubbard@nvidia.com>, Kalesh Singh <kaleshsingh@google.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Park Tae-sun
 <ts930@dgu.ac.kr>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260924050009.19974-1-sarthak.sharma@arm.com>
 <20260924050009.19974-7-sarthak.sharma@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260924050009.19974-7-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4027B140010
X-Stat-Signature: 9whwxay9pnw6t6zxuhdtdqaigr9p56jc
X-HE-Tag: 1790856031-757275
X-HE-Meta: U2FsdGVkX19/nDEs1C5OPuEgGKGIWkdxvwZDgiyC4c6+I66TU05Cy71ihgK9RtP+35ak946ijdWdz1M+0VlwSHRUiZSFKIy1YvdaFCbT9C4vOjaRhoL/WYbu9zavEhPVXP+U+RR1vgIZNzYXxOs+z5KQ72eyc0aHwK+DvTrbPfTGeUSDZFRncupLurkDPmV/rc20cGI/TvDnsvW8gFuJCXKj3Hb/ypA2CckAb9NvnZfVp6J9hWzfYBcK///TR2rBWM22J8hY2hqJGft2H1Km3K3lnYxM9M3EZs70UqVKZ/Z5wKj8jw2mMlqk3ucsaTm7X1P4D6v8B64kgc2jn0vVdSWZa6WtFq5l1eAkDFCMuZECnJ4DZz4G3AsojU6LNLxnmQ4WcENkupOXC3sx9SH9vnJZlc4WXqrHBQF9gH7PymSicv2TGyCLAMTDEDgCswfR6iZ8fEpVjZpP0e0m518+XFoHdpOg0Kx4AQd9LqzUxUr1q8+P71XyRUsGqq+5k3tbktHKhCcUY9D8YSmhGhDIYtzN2E7CpsUGF3Zwa9t96ZX1NOE58klgZ+L8+l48viUwgZTR/yNwCWbVySEXiLY9M/OgaUX4PMqkQk/jP4Wzk4cTFA2CxSxoQ2lKjHf2ZUBmw9xNBj7tWBGxTvUTiDpFHUZywoGLlS0FhiP5DLJ7BMQaAgqTOsa/LUBhbapL5TPl47lPGene4B8aFb4y/H8bQlel4a/70p0dbbjweQ6xEzeWBMIC7U2XqUBA1RFz6y4qxU/GkbPZpTtEMxwQ6BxsgdP+CvXfuhAJ/EBoNX7qTZlZ36S7Kw4x3+/c9DC3T+YwMDO5+1ig5Z117N0BeNMT8bQOh3b9q6wsSat/BI3go99gx8HRpNGpuSxcC8H+w5ebwE0cNA8u6sM0Ci5Fizm2ajvCxSNppH1OQeqzwH8IhiDYDrIc61HrAhr5mae0Kt96IooF2myi/Fe3CKbLLt8
 xixoVidS
 neMt2/tbLgWskQarYCgMOsujvhN0JygNwkq4j58i5Jb3oe5yn3X+QTyUL9iXOGGCvwQKl7/H0ELGhlnKqOp3R3Wd4rSSuoww7iGs7O2Z0Gt6Fw6tpz+fgQ9+TfYyVg10c+b0Fw0vYUVPojpgR65FX/cv6FJwvKtB8Ca4OvJO7HVWtq7iDj6tpth8E/x47+Rx2jbjv1Uwhdnz/mBW4JgeaO6XsTmb7tEcihWMDCtvHhzPpAZjeEEpxroHqDLtqLJsj3svXrH9YBq5Ib9LR1+HX7NWWfXCK3jXfj+YJTrdOrW9/KK2edA9JYCGIz/+jAfW1ejSnAw9NT8SNLELSwJL7ciHxgv39jbUqw0bKrcY+P0JTG3Gs++luRPXTmS+CmZ9kFN2gwmrtkUT/4yA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 07:00, Sarthak Sharma wrote:
> mremap_test uses a random data stream to detect corruption after remap
> operations. This requires seed handling and byte by byte validation,
> which is inefficient.
> 
> Replace it with a deterministic pattern where every word in a page
> contains its one-based page index. Use memcpy() and memcmp() to
> initialize and validate the mappings. Remove the pattern seed and
> its command line option. Also update the comment diagrams to
> reflect the new deterministic pattern.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---

How will this patch change with the change in threshold handling? Does it make
sense to reshuffle the patches?

-- 
Cheers,

David

