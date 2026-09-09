Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59155C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:01:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64BEE6B009F; Wed,  9 Sep 2026 10:01:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 624A46B00A0; Wed,  9 Sep 2026 10:01:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 514036B00A1; Wed,  9 Sep 2026 10:01:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6096B009F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:01:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F2981C1848
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:01:48 +0000 (UTC)
X-FDA: 85194387096.03.31018CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id B8103C0019
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:01:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIDREDi8;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788962506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lgmQbNDE6udjGQNjpfhdi1UAeRbSGHZuGtlT9/GjdAw=;
	b=wkvetUjq7QqD3KET34cYg1Kezyq7SxPb7OJsTE/LqxudX3yETf6wyv7AxGLtceDJFjLUGS
	T5YzqF4qc3ALgUMlRhbIHyUfUB1tOMMPBNv8u/T5zgFcEzfmyf1YFr0+DywcwhgNg9cL0t
	RkClDDdEhHEVuIO8MB1JeVye+iaUrq8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIDREDi8;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788962506;
	b=5+eN6hVsCtzr+xSK24BbXWPB9xkn58rTcobyeB8pzpU5sFhg0JIHfY2WkcEv3QnhW62cUx
	jmlgwJ0hykEnV1y0KP76JKoFvTLfxu4Cv6Z+GBUtVBJ26QXIdkMibX7IP88DZWLo/q1xbl
	hIPkMNzHrEuFxE9JG19gs0v0b1zjr04=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BE73560216;
	Wed,  9 Sep 2026 14:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488661F00AC4;
	Wed,  9 Sep 2026 14:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788962505;
	bh=lgmQbNDE6udjGQNjpfhdi1UAeRbSGHZuGtlT9/GjdAw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aIDREDi8cN3vEkHv81BT15oq78pQGDpQde1+F6DS83L1jfggJF6NRZKNYaJDTtkyZ
	 HinjeHpLMD6d1P4xdz940z0c5BW+NOeYF+POuVsZE2/mnHxcYLZ50oUbv9MXwLG9Z9
	 diG7Z1Uc5e7iQCZaCnXnvPkrjTUb2gw/wS3L6hDn0PRbANgd3/Q4UAXVK2Zba+YAtU
	 0cb+SfgqsM2510uNdaM2qRMHjTPprKueTUahkhdJbf2hUPPv8atx5ybOekAZ1PgmFb
	 lbLnagnLVrSRWnIgeHPUW344Uw0yQZApDB1yGY46Fg2EMHBdEmD6nr6jFEqVGJ2tIn
	 qQfO3lATw2qhg==
Message-ID: <7eae1b63-9989-46a5-9f0d-252d1cb81314@kernel.org>
Date: Wed, 9 Sep 2026 16:01:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/8] arm64: mte: make mte_save_tags() and
 mte_restore_tags() static
To: Tal Zussman <tz2294@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
 <20260908-folio_swap_entry-v2-6-ee6d01dfa5e1@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260908-folio_swap_entry-v2-6-ee6d01dfa5e1@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B8103C0019
X-Stat-Signature: hf7yk3a895787jp7qxy3rggk9ckq5t6a
X-Rspam-User: 
X-HE-Tag: 1788962506-289079
X-HE-Meta: U2FsdGVkX1+7oHBqcCRbdd95h62nkZmKXfx2MeTWpx/fLN/eFiGsf6NenLSJJJlb1Jix45ul5v6wqrQfNr+UxY2RCMxqw5cxbJQA1BFdx6nFmVDKa86CihY6HzPFbggv8SzBkMVO3XOfL9SbzTkc5ANfAXXPjry7LIxHH8wLc+7NS3iQmGwUIe7h7FCWZGzQUokqvSFVLFOpVFSWfLxZhNSk/+hwBB2BsnV6JTZ/VKsDpDzSmzr2wLFuLbjzpQyycS3+0g1hKhfHwFEYrysB2QGmIs9g+FERHGLBGqBqoG/E18b/VLd158IamrHuUT/Dm3wH1z6aPRgvCOp7fi3Fcfyhi/xA4xUYs7UYZ4mryIbSXUfL07G+bb1cr+/YoHWcJYV5/EIhwfKBz7Uz5PCLnXayyenGt2JnMxQcNzU7LFpWA5NQ6jdB/rsw4A/cb6D1AnQnwBmaMonYBy7uQhghQ/OcKrSRiAv+7v2L0HxJtyGZ0E7oF/GE+XSzBA6ocXtKxbKPBd7t+nTMWAdSAApZ0TVWF9SFqUXCDjbtAsH+yqYlBG06mL1utkezQwQ5Q9Z1/gg6F4r0Gr/Wr4Jv6PX1iAMHbTSSi26jNjp2YlhJKZQiozKtrEP4SNpmGAhE66wc95em4WumfXwecJpx+0uvrUPwaBv5R5k3dkQFy+7sRbypIm5fTyXvatfRvCEfh8+G/8aGQdBvfXGPCmzWTYN3gKPUzT+TGUzFZ/nxTIUKSI8NAOWIUVtJm5yYyegMrmcwIO9C05Jb/CDq0cnQ/B+DqOJk2YqRWyDw5zp4WzhdnewYPGMx4claCaW+Fs1ZWJC4qCZRJXARZBCOjLORaBBzL6O7eTk9pKGq9ZIB464S82REt6+zWLamC5N7ljNKmAU93uUwFj+lDJaJRzobiTjE60B2SOBeav0Nmy1/imicoHyCIpRKqs2LBu9wcuY1Bu/NOqaYmP/wd/0E9DgLzzv
 G7xVmnYx
 +0gbgM/tpe3e5qnqGn/Xit0y/OYZRQGVXSi03DJP+hJDiucgtFKzQiobbEHF7QOoHUG7EURjwVVOP3v03i4IvZQBhBt5cPttpGrHl4mIWkUDTGO/WCFxcBncDbutb+njWB7aRSEFM1MxLWqtWriQ9qoeWVg2PjJGxezoHJ3o7z7aZzuw1rhszLZtvOr/YTxbxtP/7GqLJEXPpc6eAO+AEeWkhpVULus85LoInWVA9WeptsugORBTwJQMvGNTEQnDpntLxRs6tIC9q1WZwxkko4rexgbJY3hCo7Xhg8MSFsqL7Xw0GuYC6hqWRiw4nAQAOOCKTQm3p/nx0/MU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 17:16, Tal Zussman wrote:
> mte_save_tags() and mte_restore_tags() are only used by
> arch_prepare_to_swap() and arch_swap_restore() in mteswap.c. Make them
> static and remove their declarations from mte.h.
> 
> No functional change.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

