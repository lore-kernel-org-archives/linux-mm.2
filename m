Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9274BEC0460
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 09:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E846D6B009D; Tue,  3 Mar 2026 04:05:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0DCB6B009E; Tue,  3 Mar 2026 04:05:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D836B00A0; Tue,  3 Mar 2026 04:05:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BC9ED6B009D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:05:52 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 95B511401E6
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:05:52 +0000 (UTC)
X-FDA: 84504169344.16.4F96BC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A8838140004
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:05:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=er7ANTkY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772528750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rHE4zb1y6wYeLuDDGLEwsCN6nqvV3H49AeS+XuBQsHo=;
	b=N/qVc68q8utRv+Hfldos1Vi/ImAeVXVofhAbrnUT/wNCMKoO7Ip8DReFWdwugT0xuAxFt3
	/NjqKUBKTPr3oSwHx90kwSbI+v/hnRH4gBtabYalaIwi1wTEK788J8F08BKt2voWSVD7p2
	GBMEUEVUpYBd2V3/6G03w2hpG3twCZE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=er7ANTkY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772528750; a=rsa-sha256;
	cv=none;
	b=XVyMbvGxLIyH8QHXs/EJ65qfiAdnuNLCFTIL3XiMypGCRhwcRxu0sZGGIKDe7jD7nbD86o
	YHj/PuhIz6hgDGvaTYzj2E84vgDkE/bWBV9o/XHTuAnZ1x9p4DhTpyPPuPE3WxQGhPX2iy
	nGoKv4SzL5TRyFMs7xgSrFK2Pw5ocoA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BF0743351;
	Tue,  3 Mar 2026 09:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E17C116C6;
	Tue,  3 Mar 2026 09:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772528749;
	bh=nvRNMslbIsCzNW54O4+B9qj5CQx5O58p7vfrrnpDLcM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=er7ANTkYJBqwL1g+vXUe7IQfDHLUZ8ZzIlwYrjYgAJzWmuewZOuzijTOr1G9TmMhz
	 6dRajFMtFCt3t4zfjwNJCLxT5yKzQAQduTUO6SuW+Kw+PSS+aFdCZqhfu+EeBWkv79
	 uZ4PIlGzNug0PSAlDF/5q9oumhdg0L7oA9q8ExOWeKfJGKk21JNqa/Bkqa3y+tUVFS
	 5CAbiJigJlbQMNxVqG/oKIx/6eKxED+6neoM8nrk13nDe6+PU+bxxf1C1VdGhtNcp4
	 xgLiaom9MjCNLh4YKPQC+MiySDfugxh8l/B6gVQGetlHb2xJiMbzy3rS+GCTQBtwi4
	 0GKDYT3CzR4YA==
Message-ID: <dfd73ec7-21b5-464c-9a43-fe942b03dfc9@kernel.org>
Date: Tue, 3 Mar 2026 10:05:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] smaps: Report correct page sizes with THP
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20260225232708.87833-1-ak@linux.intel.com>
 <d2c37aa0-ec0a-457a-bbf8-4624cdb8074f@kernel.org> <aaR4y-lCl7YPEcnX@tassilo>
 <af715d91-6d49-462f-9e9f-3a513ff2ef77@kernel.org> <aaX2B9Efh0dBed6c@tassilo>
 <4a08a249-211b-40b9-b6bd-7c54af2b9d15@kernel.org> <aaYFpEmiH99dryA4@tassilo>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aaYFpEmiH99dryA4@tassilo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A8838140004
X-Stat-Signature: m31pw78kbbjqooamcfwpyrxyk9ukiek9
X-Rspam-User: 
X-HE-Tag: 1772528750-227877
X-HE-Meta: U2FsdGVkX1+ycQe+ZY7oURwjP4kFBMG7o9kQJy/6XDrLltiX8MgVfP0GRepkrRcEOQCBWqGiLHxWNr1n0eQDst6yyGCQPdCjVxQzqJC0MAieWP0bFykk+bnbbmDrAAh019fJ5nIz1dvIX19AkvQHsTPmfWlC8OudI0tRzk6Ad3AFYCAzCFVxAZCWP58kxOPeB8yINVPq5EgjyKc3yp4IS2Wt0Kt6L3/7bgm+25SwM9xUqNx9auOfZw8YwVIxig3nVJQEq8ztlOwxEwsPk1DXrTrpPcnCWJ4Z33ybIC0Wq1S2Bu47rZ01SiCjHN6rJbxW3dEQbPf/fclAAhkB3QZ2loDD5kbVqFgWr59lJl+r2JTrhcrld3KAxQ8yerru3YU50thSeU7ZS7QQOr8GEx6hJfHCkYqnE+uCn/n/Rk2+S60fS7wLIotos4XtDGEZGAC4eIsUWkXw8RUA/Br8y8008yS2d3MOrVyt8JVjGgv5Csn6YueTmbx+7/fDqwgc2m4VahGI244Tp5fzAypR6a0vxt6oA1QIeqkb1o+6L8k2hN/xaTik7oSZd2vwTJ7RmVQfuhr96V+tOCEflORltgGkr/NmFnHlcKjKDQOV6r2fpA3rUWSPEZLSP9hQCz4deFQvvOYXvFq9PS29LtR7Y+iPtSGbMBn0T5P9lDH+d5Mq1+dFsv+W0iY+VqLgZNLMOVR5OM97SkF4xqrd3HiONSRlvZ6wV6IRD+EK7/5q2AjKbi5vV5I5MbiDhhC7bHDUYjYqKrE6hIMX2VVPyB6LdsSQozl8uRRjyGX6A7QgsbaNYbjB0ReEckJvhWY0SgHmXm5DsKoyTzqldP6DPzTp6tsQj/3fIbu40RCExpD8Lop3n8F671iNSGUptBlq9ZXANyvrZLu598zh6e0cKiHk9cTbJ2Zs+kyj7LQ8y86gAdkno/0ypQ/7Vzts4pGB6Bd7A8h0473iF5vzBghw+71grxH
 Tu46Sb4T
 eAFjlzxp7Jux1yBFws1BxOJA/IgN86QK3y78SVoffOgzx2CYnbJSmiatblt2r8n5iiqM2P9EUHXKHb7mw41cVfY5hByFDynYzufi4cM7jpRsmy5KWhfzKnVqHaIWB2ClLpSGzpaTFpAtWgQACZ3UrNgJx0WfLVWkLNXieehz4W4fZwc/9Fi8pqy67wJV4ubGnCWE2ADhPoLY5dh+pLYYu+ewr9/9YdrJyFGeBsysSpHGdwxXai03zN2i/7pKj+PCVA4bE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> Ideally, that will tell you "how much" of a certain contiguous size is
>> mapped, if that contiguous size benefits somehow from TLB optimizations,
>> etc.
> 
> The key word is "somehow". It's better to work with real use cases
> instead of such hypothetics.

I don't have time to discuss this further, unfortunately, so NAK from my
side.

-- 
Cheers,

David

