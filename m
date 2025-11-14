Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4608ACE8D5F
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:11:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91A7E8E0034; Fri, 14 Nov 2025 12:11:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F1D78E001A; Fri, 14 Nov 2025 12:11:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 808398E0034; Fri, 14 Nov 2025 12:11:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DE068E001A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:11:45 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A5DF88EA0
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:11:45 +0000 (UTC)
X-FDA: 84109854570.17.FBB3343
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 68926C000B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:11:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZnGKWdc4;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763140303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rKcxNQOkeCc2qD0o2ipVqo2oXYeeJXxmlFCanUNhjhs=;
	b=FYEiEQpu0FyDd9qHlm1A9CNkk++g6itvHKvNxCHzNsZWlwNxXvr6CXw/2oIszkMeFl6yUw
	zquViRU0DAyS1uC9k32s3KE5jIv+AepbZKuwQF3OMq+msa5t1j9ZGtW15/+RSXyMWuxeSh
	8V6yIQwJ4RmvL54tTUVg8Lp0MTMEqUo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763140303; a=rsa-sha256;
	cv=none;
	b=dLnkeap1NWJJzlAotkOCvUFzU/+sD90lYHpBJiv3lemYm6sv0QK0KdRqOiAWKiZfUI9BZj
	VwaEuWgjTeA8A9Aa9OTOriW0M0MrqJxsZONuqU0pVI8WBhVMfdAXUAujqaVhx/bmiC/57R
	i+eOlZUCrv0ZQOohhQh4uD/WC3bugzI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZnGKWdc4;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 83C7C43DC1;
	Fri, 14 Nov 2025 17:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799B0C19421;
	Fri, 14 Nov 2025 17:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763140302;
	bh=KdPt1kVDnO95rsL6NNliJLGFmzAdmIAIkvZWlvYKdMg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ZnGKWdc4OQi1TdjZMUR3LD+7juKVZGWAyYe7+QViXFa622INTWRgLE2O2tKFoud9V
	 4/xbf0zjrd94xc1uXIcj2JcfJLYyr510GciQM0aRN2+l62sLj/IoA/ZUmjIz0T5J3B
	 SiZ6ocVCyj6QF0H8wrF/kyCII1RA/CxSw32+JrUEbsbG6154KLapkjVZKkOpeMHI2m
	 hYglF1n7c3oAjwTRpnzhB8cVs00W6orwNGzoaOj3bL272GRmBLVwmtPWC3RCxSdpBk
	 z8yJipGkv0JrgzvsfE5pyda5kuDXq9ic8Jnb9ydHxK5wmMxwpS7cSZcbQNOvFsGGt6
	 4XUgQkdy6dzSQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  bhe@redhat.com,  rppt@kernel.org,
  jasonmiu@google.com,  arnd@arndb.de,  coxu@redhat.com,
  dave@vasilevsky.ca,  ebiggers@google.com,  graf@amazon.com,
  kees@kernel.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH v1 07/13] kho: Remove global preserved_mem_map and store
 state in FDT
In-Reply-To: <20251114155358.2884014-8-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 14 Nov 2025 10:53:52 -0500")
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
	<20251114155358.2884014-8-pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 18:11:39 +0100
Message-ID: <mafs0h5uw7d4k.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 68926C000B
X-Stat-Signature: 9q47fjmj4c5exz7zsbrrmm5wsuw5rhp8
X-HE-Tag: 1763140303-674706
X-HE-Meta: U2FsdGVkX18CTmrI5Lx9YraZQEXMze71T/ArNcP2uikEuX+ZCxdqZcGS0b6YIhwHbMPQ+5+0qnWDTXFrHK6kRe0qNGgbdTF2VLCu7/0qh8s0XobEObes6zzP0uKisCx+pV4pv1S/tM4QnXFhETOxIEnpllZFuFxAtm3o06Jf28HvCs1VXDbt/Utdl763EwYw09isg61OvWcuQYThQVHFwFO7f+961xV0nOVq1jTYnfKY5rCflbksy7XEfYtYBgDg/mnre60QqZpLR8042xMbJCBO80C6aZk5o1UzjQjbN3JjNG8IKbz5jXKRv4eE09tDL1UTW7WylTf2WdA5y96cayg/HEq6GO7WRa7L6ZIZ9LBd8jzLWkmQ8ujY+EhXFkzwIWKpAsz8jclEUb6YzLnWgJsrS4Yweba7usBfy6CG8HUKK7UGoyPIHC5YwSSwCU0vD7exQzYaOiwNnN29ziFfT5iiJBpHOkPNg6sZy8TMwNxysG5M3zlUdf8nJ2lILdaJl+4DVITCB1i6oM1MNO8Hm4zXuXaSy9ZdG1cKyyBI06kIY6aDu0oSi2VcGmvxfseaJzB0wL7enir1FeFI1sIdFBnLsrkAAnm+FP7YCU/kJDBBniHouuh3a0jKLXoO6u4jN9V0hKhUpQd8vrhBQZOZmaSzUxmkNZPNBnJ0T572vShbnsgWlf2pyd9Fj2308QljWHoPMjZhBylvC+V8EcCbHxdlZBTSxMVQUkBO3LGnWYKA07UvfxE8hpN58Khy2Ul9RPUSgVMLOhdoasyXzfouJYWuRa4TjDXyQDXLyh+iAwVmYlb0oUJt+n++SNnr6HrioQKf4X3M+hbz2pY9h8ZKqGPiz/J3dqnMiX5ETJZnUzjDjDNAyKbdLMTcrNooDYVJwIXZLGWCdUDHSvWGSwzMg9HI2/4aPxS+yjmdeMvIin8z0SHouAwJrXjbdzHlrJR12lLrtC6db0E0XOtQYbl
 ZJVDVB9D
 8o8B9efevwY+lewmQ2kFms/Vq1YqUceYTMRi8mx69OEDO67qIdycV3Ast41nf1/ouLYfCz6CsFH5grI8Jt8m6NvB6MgeWo8AELKS4cObFpOfMGdZFUNHpiXqT+f0s+y60+VW0hbBw9QakfpvCuZ5egmfdPMHf9rkDy050zC2lmWg8kUFwsKOFZUTZrmuSXCg/oEKjxmELc1amTxvbgLx2XyUBFvfGmnMf7EueXAVRP8Z3ze38g5GBpwwTC3kfbHqvD986kcMrLnt2gYr+wYeppy5MRIJVBnxqAQ1lm2EdOcQFx9g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14 2025, Pasha Tatashin wrote:

> Currently, the serialized memory map is tracked via
> kho_out.preserved_mem_map and copied to the FDT during finalization.
> This double tracking is redundant.
>
> Remove preserved_mem_map from kho_out. Instead, maintain the physical
> address of the head chunk directly in the preserved-memory-map FDT
> property.
>
> Introduce kho_update_memory_map() to manage this property. This function
> handles:
> 1. Retrieving and freeing any existing serialized map (handling the
>    abort/retry case).
> 2. Updating the FDT property with the new chunk address.
>
> This establishes the FDT as the single source of truth for the handover
> state.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

