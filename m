Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 498D6CC6B2D
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 08:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 443316B0088; Thu,  2 Apr 2026 04:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F4176B0089; Thu,  2 Apr 2026 04:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E2AD6B008A; Thu,  2 Apr 2026 04:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1C7E56B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:21:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B3ECC160570
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 08:21:40 +0000 (UTC)
X-FDA: 84612921960.22.A6E3B65
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id C7362140006
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 08:21:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W5NFSiQw;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775118099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sy6KQ39cXvvF6ykGKyoMiwcBMu6dDObHqrllqYv1iTU=;
	b=e0DPgDLfzuh++xKu6Vj+rGTjkBgeftK98vxegJntDBh/GXY5CIKhjlguHjhyzgGglDggt5
	yjI+GCtft3IxBErCnfzG3rlDBv/ui0wa3+E3++aGTg5tUb6y5NrwpMeRtSWxbbxwe0/fd6
	7OdCGYu56HKn76WFFqD2m5ssN1cWxMY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W5NFSiQw;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775118099; a=rsa-sha256;
	cv=none;
	b=qh/0goDiBeWX9HYJh9tbaXP2nsN9MDWEyITPAJcKNP1Czrgz0/MdyDMCCMyDa8JdK/jJP4
	EDDHrG2fyKq12EV4ram7CqJ0kNSP4DXfpFMfEOOy5M+mf5L2u6FCaoT6qToW9PpTMkIDxB
	gLMWcyvTMvWUuJZa4+IJrlgszag6LFE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A305743540;
	Thu,  2 Apr 2026 08:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AADEC116C6;
	Thu,  2 Apr 2026 08:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775118097;
	bh=VrXCmY6IVndo65GtVNw4wMeXzy1whTfC5ptBNMljuJ4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=W5NFSiQw0jW17XBbC7g4coFafl6SATWYsNJ6Ui0hS9uvk/OU3uqgLEBRvuw+OOMHZ
	 k9y9uEQzGehRPEs/+7x2xpY6Skyi4nT9y8UxLmuuntlvgNEukLkmAG7CJv8zB9vaJu
	 wQrWCuxNBo0WXxFTtYVbyojhWMnhXFhQqrWTj0QpYSP2AqAGoJhg8qng7dE6WtyJNb
	 kXucPQRtPKBMrRylSOvXLtyAfWC/1MgdRRz1vcTB7c9iojXjFs76fTx22hrYig7G4b
	 1Qs4ewzUhRDVdJX7h6OO8FMUmiM7LOWuVnOKrhQir+UQwJrVUi2zO2G/8oSjjYpns0
	 P186mCbj5c5hQ==
Message-ID: <3c2f0e52-0271-4bd7-b3d7-84249c40e2fc@kernel.org>
Date: Thu, 2 Apr 2026 10:21:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: huge_memory: use sysfs_match_string() in
 defrag_store()
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260320-thp_defrag-v1-0-6ab15d0d26eb@debian.org>
 <20260320-thp_defrag-v1-1-6ab15d0d26eb@debian.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260320-thp_defrag-v1-1-6ab15d0d26eb@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C7362140006
X-Stat-Signature: y39jjpky6ayaohki8rjc1rcaes3o7uen
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775118098-951819
X-HE-Meta: U2FsdGVkX1803TWkzZYZhOg/21x+9GBU2P9rOfqhzLZXEZaJG5pCE5c7L/97gSEbB79hLLE24mQ4/EG1Xcdhn6flf+NgTJxSKOtmWrAZCnIGlXXhW2W6ya5fmFKJGXubYUlinQj5N3HqXo9uEm56TakRYtFIX3z9dI5qvhco0dT3cRXLb0RbNkpoHQEP7RiTzZYVHb23gjENNbz1dqy4y0E/x7UAY34lMY2IuWZaA9HNG3jwcpfYvghHdSaNIfjcy8+WnQd21z/rw8hi/sSQE+x0/p1TX1GJZWJkKB+oxLqoC5hi+mUXu2jxj+4WT7X3fBRhe5C9HxxipVEv1isLGvm39SfHpEI3SqDgAQzN3eA0ifAyptFYVPmzW9PK4x4imRUKlYamWtRPxquNvsU5AXSlcviAZTbwmvOCcDg2dQ+Hlz/bpScCICvWSM23HePbc08idBzEeoSRhyBTCmA5cY5sWZAVvtpx8loQjA1kK5nUxEGimxbF+QQgyMfBBOE6s1geYOXi9XvqsjdmA+UwFu9i9CXKOd/nYkxfiSNB9csBGtu1wrkhSvzzy/HSrwwCoQQyRSbu7PUZDiINA+HPiU5ikXUEfc9vXLfdvI5aRCX+FpYoj3p8cwo3Hr8yvrgyizBXYpbghxWAb7gToQJGB35bsoMrvmBlNOzGN/A/vHkCUcyMGK2fPg0PtC8nP+m9CwrYx0zJnvb/uwCLKtut23c8W5qDk+5X/TCY8ihETEYenZI82ckkVQZNR1mKAo4Btu/RaA9cm81n8SWLV1YJeSFowYuBfYAM6GdMTuouDwCHwT0N4fj4rxZbwxoYIRohz4euXN1nUFaR5wc0HjiIrc9Afm0VrNXKB3y520Mv64j/NyuztAlqYxzpxmiMhLFPXPP0mgQl1EKmEo1F9P1dxN4peDt5mxQWr9g+UeDF5BS1UgjLSA/xtsP8ZqVCQbjGfgAB9u6DYo55ZRIY7us
 Sgrr6xlL
 8/J90hfB+aRQNgGrG6M+LjknR1VpcSThoeOrppnshpPw+qjY1OMbpMTdublxLEWnZf/RwAIi5qc8VRvMChlcAfS3nrWSnuQe2lfREawJQUOXoviMbKdS/3/2xdJYT+qTthI2EUK2QRJ0LFIOZzadyX3N0bXd1lhpVvw9qYXhLMEhM0jMikxtma+2elbFRD/7Dg6tBUQ5+6M8TOiqqzPmhX/N2VRIHZXPXfxBg7ElpDUDLiw0TDDITsRdhK9csjRCedOi+bJfgZX6M8PD44AXvj9kT/XPgdcQ7GtAEN+9wL4B9PgRN7gfdMRuQG6EOXJH/kSC6Ffuym2xw19pw3GfBA56Dh/MAGqv34cDg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 17:05, Breno Leitao wrote:
> Replace the if/else chain of sysfs_streq() calls in defrag_store()
> with sysfs_match_string() and a defrag_mode_strings[] table.
> 
> Introduce enum defrag_mode and defrag_flags[] array mapping each mode
> to its corresponding transparent_hugepage_flag. The store function now
> loops over defrag_flags[], setting the bit for the selected mode and
> clearing the others. When mode is DEFRAG_NEVER (index 4), no index
> in the 4-element defrag_flags[] matches, so all flags are cleared.
> 
> Note that the enum ordering (always, defer, defer+madvise, madvise,
> never) differs from the original if/else chain order in defrag_store()
> (always, defer+madvise, defer, madvise, never). This is intentional to
> match the display order used by defrag_show().
> 
> This is a follow-up cleanup to commit 522dfb4ba71f ("mm: huge_memory:
> refactor anon_enabled_store() with change_anon_orders()") which applied
> the same sysfs_match_string() pattern to anon_enabled_store().
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/huge_memory.c | 60 ++++++++++++++++++++++++++++++++------------------------
>  1 file changed, 34 insertions(+), 26 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 3fc02913b63e3..4843e2154038f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -421,6 +421,29 @@ ssize_t single_hugepage_flag_store(struct kobject *kobj,
>  	return count;
>  }
>  
> +enum defrag_mode {
> +	DEFRAG_ALWAYS		= 0,
> +	DEFRAG_DEFER		= 1,
> +	DEFRAG_DEFER_MADVISE	= 2,
> +	DEFRAG_MADVISE		= 3,
> +	DEFRAG_NEVER		= 4,
> +};

These numbers should get assigned as default (C standard) I think, and
can be dropped.



Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

