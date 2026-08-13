Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EFA8C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 19:11:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E10A66B05A4; Thu, 13 Aug 2026 15:11:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC89D6B05A5; Thu, 13 Aug 2026 15:11:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D05D96B05A6; Thu, 13 Aug 2026 15:11:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7ABC6B05A4
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:11:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3526C1A0279
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:11:16 +0000 (UTC)
X-FDA: 85097189352.06.73A7F13
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 64C1B16000D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:11:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y7jhHci1;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786648274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=naXnhfAO9RnGx6HRIhVoxKI96h1ZYxiBUY7LdCve+tQ=;
	b=NMngS23qnp6n6OhQl781kYcgLN+/lBTBImShzRWjn2HZSQJHnOWjiMUl5JO7qyS/bTLBQe
	SEEGQS74ZlrX8QIN/XaarSR9VcLHMAz4dbtDQSn/tI854iztMsPTBdMdjbGnhfAKcDgU7R
	wT0M6qQQ4OZFbzLs+1pLLRqrB1Sg5RI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786648274;
	b=Ck8kuOIfzeaMfNsCCoGMtxzXAtlkeuqI0WMmCok8ocyNVimL7KQEOfqeCNnARCV5QJw9ey
	4pwWDDeULc/ClAkGPjhSMjtaNr2NuwH2Ja93kR8jpXVorPQkZ4YTqzzP0YvgLht9UdwIzS
	Gy933N/HwfSZgifCw4GfODQ7nD+xIQw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y7jhHci1;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C6BBC408B6;
	Thu, 13 Aug 2026 19:11:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFE01F00A3D;
	Thu, 13 Aug 2026 19:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786648272;
	bh=naXnhfAO9RnGx6HRIhVoxKI96h1ZYxiBUY7LdCve+tQ=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Y7jhHci1lOlOP51GmyKNT0U/WypCIHwtBuFgWfktPDSLLYXysVYJDFmGCnnsOMR9v
	 7UlcQjNZFcbiBjD74IKLd5kgMY8QoImdTS+TdL50xpZEoqpyNvDFDdJFXo+J4fT9EZ
	 fL9izDOVl69Ng0q3QS3Jp8M7DpgvuUCcH9UK+UbPqaDV8y9/PU8/J/uWCQt5+2KJrQ
	 teT4glwDNj+UNehOwSZv20Da5WBrO0S7Mm9wfV+nhXhJ5WlLobIJxMXraCyUhx5YVW
	 c+jNodQI0cwZUPJyIQk4gwl0VvTFUmFdUBJXTnqKLo+WB4KsR+AWR+Zd9USJyv23Hk
	 mrTmaXLmKGKOg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 0/5] mm/mm_init: simplify
 zone_spanned_pages_in_node()
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
In-Reply-To: <20260806162100.313965-1-ekffu200098@gmail.com>
References: <20260806162100.313965-1-ekffu200098@gmail.com>
Date: Thu, 13 Aug 2026 22:11:07 +0300
Message-Id: <178664826734.2487459.5355911171968933423.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Stat-Signature: pmyyb4xy9c57p6aw9exbtefpedj6u3ay
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 64C1B16000D
X-HE-Tag: 1786648274-356784
X-HE-Meta: U2FsdGVkX1/IFy2SBHkD7EPNxj8MhSd+Rm10qWxv8W9PpkMuH5PTlUPpVA+Vpe30smKXE612g803DFallQGCxQy6kABkf8CvsHOt9b5D8+fwdx9TjkCoLqmndfE5xRS82Sl9oRvhtdCTVzeWx7oRS7AVxCUjbSbr/JwWdTvhqTjFPbJqERl45NG5k9VTF64nGYXDm5PEuVGj4KYLYmYcq8+KMbBmRyEv76OvhRq5yhDUB560xmKEeH+uGLeu3siLHwH7lEgMk8++p+hN8Ixfbl7BHJVunAkZZ52H/6c2KofOVvqDhCEq/w3P4CIkbJzwJEeHJxtYDbXJB5gIgYgnrWvj9buWcicY3+GY4M9cqfo0uk4z2OrP9w6wAW0fzqGfLsmL91IZDs4zfEzEyTgLMer2Zx548K28s5g9hlptVFeg/fpxFrmTcq+UD3RQQBNYsvcQvF++cmGo/yg9BqMGki6nEJWh0cSwU4TX+spAxZTCq4QQ4RNhhqt+ynDpy0XZQA6398AWko8yozpsf65pUgxBxi1VDvkhRTChauMvEp44RMnRaCmSj5YNQ5Qi+CXfRJ1iLQHzrtOFBqgloF4hnUR5K8bJ6isUYkoeDhYPFid9TzjY1inIW23ZWh4nxFmZemg5Hm6AISdCM9KM+Dkl3WvbbUE1WM+Rpp8dFnu5P6Wf5N77xjbZsdM7A4/ETT8YiUmr2aIe1r1e3o544nQQZ1l6O3ne81Swp+HmzLMS0CriSrmgAkC2C9SwNcOXJ5VglRjGxmCSXi+RoHRU3DfrIGsTRcTPiMKL7MrkGBLQLnvXjouZyVFMdoig8w9EENqdp6JtFHgNgGMOr05/otpudBtZ6SF4XrDQ1T9Rzs5P3v5KM6snotYzPJDCOJujPhDf3YIZFNFResE69CQN8eU0TvWeKf+0t4eFtGMFLl7SGg0CvURYkiwmRdKbKMpObKdYwT0i7L5Lat/4Zcz+BWz
 dOuAT7jB
 DZGMR2xXHqCJErWGPw2dR+4sGUxr7159vpZ/lnEs48ZJQZ9CQF3q9f5ATWYKlTV1uB2bi/dyxJcIMUbqtu+hAyJgDiuoblEEj+keaL9eeUX9FcNh4doxa1sAJkr8zcC5JDhVS/r+RLBdiYZ+BtN/yTmhybY+mqdhncAw+gD4UG5035OFWCltHpjDFiRzYE1Op+dLDCdsgjF772yI8NrSy5WjGFYbRje+bY6n5bBCtQ/0UB3s9f6g5J82yXYVp2iVd7fjhsoHM+4vOxiE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hello,
> 
> This series simplifies zone_spanned_pages_in_node(), which adjusts
> *zone_start_pfn and *zone_end_pfn before and after calling
> adjust_zone_range_for_zone_movable(). The helper adjusts the same two
> values, which makes the code harder to follow.
> 
> Split into five patches for easier review. Squashing them into one
> patch when applying is also fine.
> 
> Patch 1 folds adjust_zone_range_for_zone_movable() into the caller.
> 
> Patch 2 removes the clamping to node_end_pfn, which has no effect.
> 
> Patch 3 moves the check and the clamping to node_start_pfn into the
> ZONE_MOVABLE branch, which is the only place they have an effect.
> 
> Patch 4 merges the two branches that adjust for zone_movable_pfn[nid].

It would be easier to review if patches 2-4 would be squashed.

> Patch 5 extracts a local variable and reduces the indentation level.

This change can be folded into the first patch.

-- 
Sincerely yours,
Mike.


