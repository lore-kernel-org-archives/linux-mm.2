Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD322ED7B96
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 10:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E98E6B0088; Tue, 14 Apr 2026 06:19:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09AE96B008A; Tue, 14 Apr 2026 06:19:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECB236B0092; Tue, 14 Apr 2026 06:19:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DB13E6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:19:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1297EB9933
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:19:15 +0000 (UTC)
X-FDA: 84656763870.30.CA1502A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5571712000D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:19:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tLRQLee1;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776161953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zipAUA5Yaf56ZLEAskxAMpT+1BclO1sPsMVbAnC/eLI=;
	b=IeYKGjLjrd+aiC1jmpprPD4wyQU+9qECYQbkyo4InRUDxjwbOIzJLkihMAVtyOowNBP7J5
	CnzT2eaJdsaB5gIVZ39NDDFXReTI7A6ZC5G0kP0cazaIvbMjv5y67DPGy0p061CtchzKKa
	W/ueLH2u6lez0gJxSQjUaN8Owp/hG1Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776161953; a=rsa-sha256;
	cv=none;
	b=Nql7ov7HIQRjXrSjADwrLqRV1CkZuUUoPg2BvL+H93gNkyOn4ZSJbd7fiX6/kUK9uaCq3n
	VQbm1Da5Vnmoxsq2EMGQsV3eGv5OzFMJEENatGA/lQ62q+93NB6jI3elpO0diPX3qDDs+r
	ynAe9kd0//Y2tugvX/CwpXkXtRbq7h0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tLRQLee1;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7AA5260131;
	Tue, 14 Apr 2026 10:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A33C19425;
	Tue, 14 Apr 2026 10:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776161952;
	bh=MDxYDpGQmy5Oxh+Of/cJzn+fi3bCoNS15eBhroroskc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tLRQLee1YgXHJrcPplFsAm3WeFn4fNmAKXn3Y0ZZK/SsNsEVHxwzCghZjXlMEgv8f
	 +DJOuFeqgWrsZPRaEGTNra1MaJQ6+2eobv045cs5M/9tARoAebOa6WG1cxYcYeawOB
	 SYrA4gak03seD0kMfx8kowEkI+xf2nreknYrJv6rAwubb4Fa0bF4sKhmQiGdDYP3bG
	 HifW8OodnnvoALRlYyAgQDRcyJ097cJvSvrsTZDwnrxFGPNb7m7bvFY1lMJ1sDJ0ZQ
	 rEnLYH7nJmpCl6bfi+BtsewOAGiE151lEakpDBZU1bcb3K1XIMkHaO7M6DcuH2ceyu
	 QfUzWIi7Gvvfg==
Message-ID: <d20a526f-49fa-4037-87a8-7ffec1391beb@kernel.org>
Date: Tue, 14 Apr 2026 12:19:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check
To: Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-2-ziy@nvidia.com>
 <ad1P-bfr_Vp6VdKf@casper.infradead.org>
 <CD565023-4FA6-44C4-8E40-8B06CB09B59F@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CD565023-4FA6-44C4-8E40-8B06CB09B59F@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5571712000D
X-Stat-Signature: ki43k79pxutcf3j1a9em45dc56eauh5a
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776161953-918571
X-HE-Meta: U2FsdGVkX19eqyDf+jovxscLqUznwV4EIbNw9d/KnJvCCJLNiO0cKGiK+rtLfpKtmwgDmlNmOwIqR0cHPifzIwuxogUbTrFN7IRD5No0JnqaUKNX6ClWqM+fZH0ZQ80BJq9QmataZxSFSONSXVtb7xnvFCYhdMYHDeEdPmbVg76VD2erBLHDw6Ivz84iLLmIj8JWCjAJeQuLAMxppBI6AEbQ9NXl+Wq/4qoyMJmUMJKANC/xs9p0zy7jQjpKmImmeVenG5CeX7YFSQi78NgUKJ4tCRc8mLNrW6XP7nh3tjhM3Qsu2lMpbVXU7X6lc8y+E/GDkizbsEOBAO7lp/blpl2XCQkZpxwiCllw8m2cXJWGt2iiQBPzDl77oCYBeozx1vV4UqLAu/LRlVlMnhAf+9O2R87+SO0Cm+aJ6PrB7h5FwE5y5/0qy6N/jC5UOJMkXOi8j+Yb5QM66N9y8o/Nn/HOWsRopbCZ6aXjSLQbLVkp+6UJ8xqYaA5Y8Rk/Vjpks/4qbqFVCebqW2iA24nS/WNKrrefDfwnDynopqdqW95ZoKN7vdaVo0t11d+VQbLHwAL83xti6I2F9YQmzRzWEquKogRrJGf2tUapWbZurrUI+41FyV0zq9Cw4FXakxcm33Dotl7qTjkbSsBxi7+SwwHl5zgQ/5fD/f07fTYImB+PGZWmEsSME71RfSv0UZ1KOZ2MUwBiKb8YOAyW5w4HF+H1R8uVkAqL/OCX3Y5AKuWT73UnWfqPkIyOQO09/9mq9wwUw2CKLvjP3mRQblVSJ1VazQ1yFdWD/7wwF5lkzPJlg1up8mxLxZfqjipBf97MdkuXH5w9+kS5kIzVn/XMNob6BIp1q5w81RpiyP2P0cHGIHbG1bFjeQYfI8PzHgowJVOsndgUEYfJmLc8YCQ7e81kyWne3sey7/sB8lfyCcvlrBSURB8HiakDTuA1AG57SlHsMOk9tGA1Hnm9VmS
 2db7Dbs2
 aeLW3BRum3Y72ngr57E30PXXYBbuzp2FFFp6kEN3qE8euSmKucWv79cZm9C7bq7Ac9Jo6ddG5NoXL9I1XPrM0ZzazHJl8KwLbjn4rcFeF2zeYiwIBtd/wteZ6lqKycwPuZdgM+Cye81uDsJM/fo7vQeHoMJxsi5oLxQWqEL7A1U7FUgCHr4zizRDJBq4IJ8VIqynSP+RbAekR2O/BPgkZLYWtxHQ6hNgcKkbDl9Hvvrr9NJnLHNfDPp6TSoQbrVCMS77f9lKkbT4EHnEXvnERvovuEyLmf0UEQvG72Ju52UepqALMh+y0wTFSYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 22:34, Zi Yan wrote:
> On 13 Apr 2026, at 16:20, Matthew Wilcox wrote:
> 
>> On Mon, Apr 13, 2026 at 03:20:19PM -0400, Zi Yan wrote:
>>> collapse_file() requires FSes supporting large folio with at least
>>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
>>> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
>>>
>>> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
>>
>> Why?  These are bugs.  I don't think we gain anything from continuing.
> 
> The goal is to catch these issues during development. VM_BUG_ON crashes
> the system and that is too much for such issues in collapse_file().

VM_BUG_ON should have never been added to the kernel.

-- 
Cheers,

David

