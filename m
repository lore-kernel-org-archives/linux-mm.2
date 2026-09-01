Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 877C8C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 10:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798F16B0119; Tue,  1 Sep 2026 06:18:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770206B011A; Tue,  1 Sep 2026 06:18:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65FC46B011B; Tue,  1 Sep 2026 06:18:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41A886B0119
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:18:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8109160363
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:18:30 +0000 (UTC)
X-FDA: 85164793980.28.1F70F26
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 05E8616000F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:18:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IJCZACXJ;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788257909;
	b=6k3MrEvIu/vuqzC3KIzuT1XVtsxVnCLbrqWofwa/5PEMqrC3znLxV6ROJyzEhboUP5gqhq
	kBohroqG6peyXzXE+W7m50lLa6t9n5MleE+2mkru5y2ndeuxLgpectcMMhQn2Wr5GmyLXL
	dK9fHcSj7xHpRBAZouVhMpUd0MhMnww=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IJCZACXJ;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788257909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ka+EzEk2oJ6Jd08jco3fylL/LVEMBlnehzUs03r5tcI=;
	b=vr4JcwOMgx2QnIv8kLTEfqHH9TYSvNEMuUTf/nreLc8rAUApPA4O/eWklsVttMt9Bp1ysh
	9JZeSmhN4fqY6b4qVbutTZnJo9Ta4x4PYIxEJPdltor6tjzqy2HJnGnwdp6V+ajB1U21rw
	h8KG99qzJQWSkgf4Rq7ndNu/MLmM3Sc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 765F5601DB;
	Tue,  1 Sep 2026 10:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A2C1F000E9;
	Tue,  1 Sep 2026 10:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788257908;
	bh=ka+EzEk2oJ6Jd08jco3fylL/LVEMBlnehzUs03r5tcI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IJCZACXJ67zF1pP8dvGxQNa4GwnXJMvRkCQF5/Aaz1+/jO7mEeYhBBMpr262Vx3R7
	 hvUxMxn7xPTn7h08Ivw4uDAQ2Oiwu8nv4h+C7KgBDBqpNv6SSLgK7TxT4KhSEL/QPR
	 KuFGzNITSjD6ET1I9BS58d9FKuzXm9ESg6QHbypR2RcEO5PzGan9VBw/zwl1r/5X0F
	 dmFRXM76SeeEC3Lh75SkTywsYKUFQIXPhFKkTcSMPhRuFVR4pVbql34roRGvkVpDkC
	 rM+fhberaKHhVuqr7mTsXdfFFDpumMNSYBwj8AhdsZwtR8JUBLCm3WeeUQPD+A7tbp
	 Q8JAeDwfbmrpA==
Message-ID: <75d51a99-b9b7-4e0a-adb1-c8a002fb0b05@kernel.org>
Date: Tue, 1 Sep 2026 12:18:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] MAINTAINERS: add memory related docs in core-mm/ to
 MM - MISC section
Content-Language: en-US
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Randy Dunlap <rdunlap@infradead.org>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260831-docs-memalloc-guide-v1-0-547718c274c1@kernel.org>
 <20260831-docs-memalloc-guide-v1-2-547718c274c1@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260831-docs-memalloc-guide-v1-2-547718c274c1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: t6griskrwfpopsocjaoerihz954oosgr
X-Rspamd-Queue-Id: 05E8616000F
X-Rspamd-Server: rspam06
X-HE-Tag: 1788257908-494575
X-HE-Meta: U2FsdGVkX1/NkRx5rg08yWa3ac4ItFDb0I7koCj9jhVqZJvTrlyp8yathJIycMoE/KgnlitZfhHn80q6X+NNvPjDefDEFq9sDxHDWJos+3AFI7/mNH+Q1oyWUhuYDoH79ii3DLAQ2Wn8M63sOujOWIGQfsv1VXNJuF92HzEDgTmdtvTFIk+5dCajGMjJMRF1zdrZJmhgVPelRGoyIv14qk6Iqdd2ezWQtkMaWwYpnVxK2Ika3GtjbBQW5SL+j4w4PkJz0GXntHOOMQSY5e4qF9ve23EZWc4O6rn3KqFKd7/pQL8zsbN5ypRqSUr7IGVvUuh9pxH31ct2s8WO+vitpB0y2FTkSnN02uDh9ynum1SZT7EIuWe4hAtNdxQ0qgZxNBkPyrgO87D7EYKmEK0UgYv3QoQqmTuLx2GB8mMwqu6Y/MkKz5q0f3jSI1jq246wxDOWPp5ulVKc0XyWFyYryRKYtjJywG5iCtyA31rG3C9h3v9v/VmPbdrSqPDSRMLSq+LAP8ALgxoVq/SxJMFQT247iDypOaJR+ZWT91DmErXoweMvcWINUk2XLDpAZq2zSAtWK4xq4IVGGwGeiVnMaUz+tcgxfEnSZ+Pk2t36w4RyW+LkKUwniWF6iaUUGPgrcDB5a6uGSpqq9SR9Uh7mKk6mrzFVSUvcP4gDYWwgl0cQ16Cm5915BmhOwUWfauQzVPwybWg0qM6MdfkA4Ip08ar8BBbQqTULFrhY3WO23vLNfonDL2P59rrHolTkIvP8JsuD9ttch/modzBXMaMCAZNCwn1chTX2MIaiQwZsG1TLKEfU9akmUGFaGjFRBCYpaXGJtJBs7a/gzkb/OKBiMeGCu++0s93bLmOCZYWtWXKFxLwtpaeEPbYN+1XjEZoqMzi8fpU9iBe9dadDGQLh1DKihG2kLK+l8fcKlndZjD8dpAl3kAK69C0w4zPokpqa+1HPpycs8izOVyrT4IZ
 VC3B1Td0
 mczaxycabz5i9REQcqA51F0XqYbPr6/vkEltY//xgSyQW454+pkP/kLbW4vGgp7VHD2D6hWc7hzV0LmBfMkBahG3POsJ4YzvMrN54SaC80pVC/P9WENASRTEHWgt92tT5gtWmDgihSyfwRl5Wi0cL3B8c5s4afl6o12LpkZtVJyZt/hdiMW2ohrYvRsqnLdqT5StM6L4B7cdfwIu5YL5gkRK3uSM9a13nyccVD4k2TkmTBvn+s+hngRHFwvrsuldMKycYunGIwE9av4ILCB92W2oE9YnMhupg65Dx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/26 17:13, Mike Rapoport (Microsoft) wrote:
> Previous efforts to make sure that mm files are properly listed in
> MAINTAINERS missed
> 
> Documentation/admin-guide/mm/
> Documentation/core-api/memory-allocation.rst

These partially don't match the actually added lines :)

> 
> Add them to "MEMORY MANAGEMENT - MISC"
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3a19da74d00c9..707f93320ad72 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17275,6 +17275,8 @@ F:	Documentation/ABI/testing/sysfs-kernel-mm-cma
>  F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
>  F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
>  F:	Documentation/admin-guide/mm/
> +F:	Documentation/core-api/memory-allocation.rst
> +F:	Documentation/core-api/mm-api.rst
>  F:	Documentation/mm/
>  F:	drivers/char/mem.c
>  F:	include/linux/cma.h
> 


