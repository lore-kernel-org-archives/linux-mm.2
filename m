Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E032109C024
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A87EC6B0089; Wed, 25 Mar 2026 10:37:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5F5A6B0095; Wed, 25 Mar 2026 10:37:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99C906B0096; Wed, 25 Mar 2026 10:37:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8D23B6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:37:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 424C5C2AF1
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:37:50 +0000 (UTC)
X-FDA: 84584839500.21.360571E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 861654000F
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:37:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lJ2RtyiZ;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774449468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/XKQ+ZWJtBFcwnn9FqABw0r8omGwjDNMF+BmDsMLONQ=;
	b=V7n7qyvZkIJj/qoIDKGexwxB6t6LHg8+UTzxluyZR5icCP06TL0n8D1NCl2RN8v1CdLTUA
	JkBStcbfDI4JUFfnnwPnL87MvrzOfDkAmBcmaE+Z0ZXv2XTBQFhzY9WqkUofnbK9CjCKaA
	fl5Lpgydjn3LFcCT21n3x4G07DLHcSQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lJ2RtyiZ;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774449468; a=rsa-sha256;
	cv=none;
	b=j2R0PCEWqvLk0xj9WCOX0MOy7tYB3/Zh4fCG0W+ooxm+y/L+DXl/+RuUjxU+OoMA69TR+B
	T9PyH+kCbTTjLaD42Jjy1qLUJFkR76L562IjXc7xw20yS06xUPmGbbUHU6HGsA7W/D60y+
	n8QJZuq0cQuGgTDBm+dAuv4BNefqe64=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 97EB141AA1;
	Wed, 25 Mar 2026 14:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D5AC4CEF7;
	Wed, 25 Mar 2026 14:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774449467;
	bh=k/MsHHjnglulTtuQp2KFJd4JaMLVffpszcrg/qv0xsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJ2RtyiZOlkU54ojrOOo0w8LrVCduRJ3hDJbsWLSoxu/Fufog6AgrA37CkZa9KLxL
	 vG3hmLIkaT+2QJZGtKVrUi6Vo+/suROFGdl1D5JppxFxCRGf8wn8ACa/dSorvp70eI
	 nFB53f9h6gjT9HqjB4O0z4XrJE+toYcVB7LaWL48ZUuf9bQAUglX9EzJM7z20Vnihb
	 tAeutkdoeXsgRM0IZXjilgrGz3WsrZ0uzB6gRzvffCgD50hiw3J6GHmMPver56JePH
	 pSGrtrgopsuI3v7Yesw78Oot57pRb0Xnt+UPORYjErqsCimfBUvnKCiYy+4AVChGCV
	 BvItSvGr35fWQ==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: (sashiko review) [PATCH] mm/damon/core: validate goal nid before accessing node data
Date: Wed, 25 Mar 2026 07:37:39 -0700
Message-ID: <20260325143740.87690-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260325073034.140353-1-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 861654000F
X-Stat-Signature: bbsgf556zhrjddc44hw1kg51pbqcpng9
X-Rspam-User: 
X-HE-Tag: 1774449468-878322
X-HE-Meta: U2FsdGVkX191LPOR33yX+O4tb0PlYVokZ65CKNOHgS/IDkPVjuzCYpNFdgMg1fwD92GVdU+Xd1N9pb/FV0el3kPJn2YYw7yhRuj6UO47+6BpeFkOy0Z9HxJIDXk3giPll5h4pZlR4zYcN+mENSfnEXjJwri6pgwoDSWOZm+T0qrNp45d11DWA34+fuo+7HF1tGkFB7NoqFJr9RbrTTeL3mhVbD2LM8fq2OJDpcAVXvpdXzMlGVlU7srd5Q7d3Vhhd1MRWoyL9EAVcpn5UXIp3ZEqNo6ErCG/ZK01Cf6Pe8I/oMHlmPt0BWnhX9L/H96FmgEdnRnSUZfpb8GasRgQhnQR7eM+oBvEKyiwUhdC2GztAMFeEu3T93MvVnKiKReDz7e3w2qUfWCqhi5ySvQhNAWB0lnNZHtnUo/yoZbGu61w7j7O52Dy3oGgTOkkL1taE/qbIvnYl5tAIUFjJHW3IijxUwqI16MRSeEBZiT4GYVRAEoi6kbrl3v/A1wZPfyOH+BZHl/ZjWYKv1Giez84+A3mqzmIer5PMDLx6CBbxCRgwpyVGYTzRbHK/+EvVkm2hZ1YNwMW0xbQVfr9C1+uZiM3jB0GxRgT6cNPc9/UNO0slji+cqR4xysOo/+DkBxiY5iow3havxQwVGM6AA2jNwPROvL+jGctJpf8Cz4haVesKbOSXmF89UoKYukybHPwywMNsLOIKRDh06l10F042Sei66Op0UMSmSni70lwoOwOz5tfw9D5wC6808q6Gob3TPQPoKJ1WE0Mw1m1vSw5wPFEOaKmg/rDJZRGHd2sHtXBS1QB/IAYVu/r0anvuZcgs5kFKmvGLro6YjfW/l3OjXrR2rPI7tcb/UM0/fUUqQe+n/GlIAlUYIiCk9SVsA5L3us/W69kOycp9DkGz4tvWB/g++l+qbYCKFWyrVq8E/EcawDXKp4shHp7X+miZ7uJS/lwNB1zTZjBpQGCoMw
 mZHrjOr2
 CIb5QvrFArVt3RbkJJhbzqgcFbqIxX4lkB4D/0hja62hR3qP/s3fAtqdKE4zCVeCrtCR9v6owp8Q2Ta7ePUfKofd6RAanMxQRo/kmWhNS0IH43529eTPobDKqir8T+uGqeeaZAB1Oajh8Oq1RneUJbNA9FHuQZYBpgHF8KH8rsvMqhqOutfsXbyM4qQUfmqMoSxfZdaYRk5TfpOchtnOSgdk6u+tRkeMP84CLrqq+6w2lKRPIkAGl68/jhLwLR6W21XKLlUiphCuylqPuESdHbgljZj1moaNaaPgzPmb18sLAIsm85+wlw/Eigli1sGzBaTYNvW67OnuAvI5ZqSGM4V1aRJuqRqDTlmxX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260325073034.140353-1-objecting@objecting.org
# start of sashiko.dev inline review
commit 7e17cbe1dc95a0cd1a1410be38ab6964f78fb15c
Author: Josh Law <objecting@objecting.org>

mm/damon/core: validate goal nid before accessing node data

This commit adds bounds checking and node_online() validation for the
goal->nid in the DAMON quota metrics. It prevents out-of-bounds accesses
to NODE_DATA() when an invalid or offline NUMA node is provided by userspace.

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index db6c67e52d2b..81ce27baa1a1 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2245,6 +2245,10 @@ static __kernel_ulong_t damos_get_node_mem_bp(
>  	struct sysinfo i;
>  	__kernel_ulong_t numerator;
>  
> +	if (goal->nid < 0 || goal->nid >= MAX_NUMNODES ||
> +	    !node_online(goal->nid))
> +		return 0;
> +
>  	si_meminfo_node(&i, goal->nid);
>  	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
>  		numerator = i.totalram - i.freeram;
>  	else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
>  		numerator = i.freeram;
>  	return mult_frac(numerator, 10000, i.totalram);

Could this cause a division by zero if the node is online but memoryless?

For CPU-only compute nodes or nodes where all memory has been hot-removed,
node_online(goal->nid) will evaluate to true. When si_meminfo_node() is
called for these memoryless nodes, it populates the sysinfo struct with
i.totalram = 0.

The mult_frac() macro unconditionally performs integer division and modulo
by the third argument, which could trigger a kernel panic when dividing by
zero.

Would it be safer to check if i.totalram is zero before returning, or use
node_state(goal->nid, N_MEMORY) instead of node_online()?

[ ... ]

> @@ -2261,6 +2265,10 @@ static unsigned long damos_get_node_memcg_used_bp(
>  	unsigned long used_pages, numerator;
>  	struct sysinfo i;
>  
> +	if (goal->nid < 0 || goal->nid >= MAX_NUMNODES ||
> +	    !node_online(goal->nid))
> +		return 0;
> +
>  	memcg = mem_cgroup_get_from_id(goal->memcg_id);

The same division by zero risk exists here when mult_frac() is called at the
end of this function.


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260325073034.140353-1-objecting@objecting.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260325073034.140353-1-objecting@objecting.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

