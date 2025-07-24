Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA7B2C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 08:19:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79E326B024A; Thu, 24 Jul 2025 04:19:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74EDF6B024B; Thu, 24 Jul 2025 04:19:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664856B024C; Thu, 24 Jul 2025 04:19:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 527B76B024A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 04:19:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E8B0C022C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:19:29 +0000 (UTC)
X-FDA: 83698458858.07.2480ACB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 783D7120007
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:19:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf29.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753345167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IxVyPqY+IZBGIEiIPjcN9KImvgd2N1QLi/uVwsIgNTI=;
	b=WTbekwiOrFFq3zD2VNIzuciGf6ioY9ig9j9WrVie9xtk4Z/JVPEE0gqkUP+vLXsrSbMJw8
	Bo5pVfeePy80Ip9XSyrlJ6freRJ+u5WY3hWuYYaKRwt56hUzv4FKBzHPEWdAjSw4EBeTl4
	INNnKxGrRBXc5OxnoYyL71QKPWmQreA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753345167; a=rsa-sha256;
	cv=none;
	b=H3roXPFkOIRHdwA+ulQPO2MP/xmu7SpP5hwakHRC5gt2V0BqpaHE+PqDyONnSXVCo/rIY/
	Wk9g3i38rmTAGS+OSw2R39XgYzePfe32bIkzkxF6zksHgiN5Z/tZPOq8yJA1iGjONwP3RD
	s2MKoqDkv2s3m5nCu3rMe4Xn2SVCDf0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf29.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CF924601EE;
	Thu, 24 Jul 2025 08:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D28C4CEED;
	Thu, 24 Jul 2025 08:19:23 +0000 (UTC)
Date: Thu, 24 Jul 2025 09:19:20 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, will@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	suzuki.poulose@arm.com, steven.price@arm.com, gshan@redhat.com,
	linux-arm-kernel@lists.infradead.org, yang@os.amperecomputing.com,
	ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH v4] arm64: Enable permission change on arm64 kernel block
 mappings
Message-ID: <aIHsiPtG0Ycm2DTe@arm.com>
References: <20250703151441.60325-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250703151441.60325-1-dev.jain@arm.com>
X-Rspamd-Queue-Id: 783D7120007
X-Stat-Signature: 3uwho19ksheeucuuqjqn15r7zy84hubw
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753345167-74075
X-HE-Meta: U2FsdGVkX1+0drzgNV5wVbU2iEPluxo5k14tE/QNZmtUn3bPPoQ2vIpB0Op/LO0nO3vhuZzJperemF1ADl+hL8/9mhLvvaMRTDUYgtJBrpipygqNhbpBrWVRiOJd4ospECY+1fhJvWK5gcb494lyQSfAxYWfTg+Ln6cgZb5nx7D2P1gqceRAO5KiCXr2hiUVaSOkymaUd4TKafim6g0beZuc+rAKaTnY+g9SJBergGzrjN/VjZ72Xhqv+As7gd+93RMjRbMS4zW9NPvKfwuqKoq9DSDMOMlQe8IQKTUcY+TPqPwPvc/3Lct/D5DMi5IN8ExumEFaBcJgNeJoihbyualOnkonTOBQioJoDTv+EvlZJZx2LF6MO4puh3R36c469Frk+TULzzcyaY0I9x5/519F+gY8sVpS9ALj+F5vsIxJA0DQNehJvFBaCuq8uDExXIU/TAWaVOsOZlCjOwD4FAUwF5NpXs8sBEYbIh1J+9yCqXpqypudJcJHkAr1VZkkke+1kaztcABvxfcydjMy4+5Gm71osEMTUmnmUYMEdl9Zxjr5GQbU+jQLh9RELaqcvZxWpjMtJ5tRvzvYmMfkiYCbPiBEpXfwlygUpMa7W7TUjZaQvv1QqxacmduaXYdOCQFtG82QkV/bOHI4jAvLYO0XqlqyOZMWfCWlnk2387QHgUjVmHxMgA4VkHJgwLFsESzhM5nL+UQeOAITXA3gx8l0Azz/i8m5yC37u5R04eE7YlnO+FzrBC9kP+o1Lu7ij1l4uGl+kRWfIpyI+PiUhWjzbdHtZh7Jph6CyOyh/tmW/znQPOeXm50QrP/q2S+aUwu2w0OlebHx5MbkuCca3oo4MbnkXEgCSu4qZ7awK3x3PE8DU+A/Rlmknd/pPw8KOzPDs7Du9HXbUoo6WLhY8vOuB4M9+g4o89783rUHvvf0c3+LixUdvFkQsP3CECRgAruhgN2JipT5Psw93Ny
 FesTvdQJ
 RDG4OEK2lqEOHR4cwNPqMQEPoR7RLBT3w5rGd3j1yUZKdlLowPxEiVUei1v+MMhBIRGbegetSOBfFoPSTBZ0UrjQCa9nXkHsQRSLQfdIfNor4SD+5ub8LWfyaoEW+GVFgn4640igHS2/eQWhPBUNp8JPp8ywiGsufJThCflvGZcfX4HMmSqc1fC8KEbxRoQ1wIACRW1HZcWe5TAUkgAs2Ekra6jM2JZ/VAzKoyhSXVdnwIKzbyh5bzitJWUdoq8s0vHgd8eoSUJ5D4M4XQvUlJjA/fQi2LDrPl5panbtMj00GXS3GdSeQkLIn+tyhi1MyoobyKL0IHTYfGEineq/Ksq7FJjmCQhc/e9t4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 03, 2025 at 08:44:41PM +0530, Dev Jain wrote:
> This patch paves the path to enable huge mappings in vmalloc space and
> linear map space by default on arm64. For this we must ensure that we can
> handle any permission games on the kernel (init_mm) pagetable. Currently,
> __change_memory_common() uses apply_to_page_range() which does not support
> changing permissions for block mappings. We attempt to move away from this
> by using the pagewalk API, similar to what riscv does right now;

RISC-V seems to do the splitting as well and then use
walk_page_range_novma().

> however,
> it is the responsibility of the caller to ensure that we do not pass a
> range overlapping a partial block mapping or cont mapping; in such a case,
> the system must be able to support range splitting.

How does the caller know what the underlying mapping is? It can't really
be its responsibility, so we must support splitting at least at the
range boundaries. If you meant the caller of the internal/static
update_range_prot(), that's an implementation detail where a code
comment would suffice. But you can't require such awareness from the
callers of the public set_memory_*() API.

> This patch is tied with Yang Shi's attempt [1] at using huge mappings
> in the linear mapping in case the system supports BBML2, in which case
> we will be able to split the linear mapping if needed without
> break-before-make. Thus, Yang's series, IIUC, will be one such user of my
> patch; suppose we are changing permissions on a range of the linear map
> backed by PMD-hugepages, then the sequence of operations should look
> like the following:
> 
> split_range(start)
> split_range(end);
> __change_memory_common(start, end);

This makes sense if that's the end goal but it's not part of this patch.

> However, this patch can be used independently of Yang's; since currently
> permission games are being played only on pte mappings (due to
> apply_to_page_range not supporting otherwise), this patch provides the
> mechanism for enabling huge mappings for various kernel mappings
> like linear map and vmalloc.

Does this patch actually have any user without Yang's series?
can_set_direct_map() returns true only if the linear map uses page
granularity, so I doubt it can even be tested on its own. I'd rather see
this patch included with the actual user or maybe add it later as an
optimisation to avoid splitting the full range.

> ---------------------
> Implementation
> ---------------------
> 
> arm64 currently changes permissions on vmalloc objects locklessly, via
> apply_to_page_range, whose limitation is to deny changing permissions for
> block mappings. Therefore, we move away to use the generic pagewalk API,
> thus paving the path for enabling huge mappings by default on kernel space
> mappings, thus leading to more efficient TLB usage. However, the API
> currently enforces the init_mm.mmap_lock to be held. To avoid the
> unnecessary bottleneck of the mmap_lock for our usecase, this patch
> extends this generic API to be used locklessly, so as to retain the
> existing behaviour for changing permissions.

Is it really a significant bottleneck if we take the lock? I suspect if
we want to make this generic and allow splitting, we'll need a lock
anyway (though maybe for shorter intervals if we only split the edges).

-- 
Catalin

