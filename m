Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3831EC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 15:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EC386B0088; Thu, 27 Aug 2026 11:57:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49C536B0092; Thu, 27 Aug 2026 11:57:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38BD16B0095; Thu, 27 Aug 2026 11:57:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 067226B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:57:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8824D140484
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:57:12 +0000 (UTC)
X-FDA: 85147503504.12.B764922
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id A83B4C000C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:57:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E8gjo2Rw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787846230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CJD57KfG/QZ66WPVhOedT8gTIsjcNXLXXwCqIXIG4qc=;
	b=Soew2+4KlQwPswr1EggS2JREzIqWc759JPDpCJPykIHVA+RL3UavDRXJEfiFr9cv31tWlb
	DPyNKMIiNe8aAfxMwBo8ApxMNbQdR3e7vEjY4GTjbXCQqxsrutZfgAxaX3mtsNYKcaBLu9
	Eb61Tq4x+jjeQUw1cjhjZ+xJigMKCO4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E8gjo2Rw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787846230;
	b=tCft2GQ57jnpHzgJz7qimY3xrC2H9z8ayIG7lQxqxodYmdZdzC7E0XOonGRXkEYz8IIWpF
	6bs0Rw4IuA1tsGwEGZ2uGesKipBKFyV/Ijb7x1GKXZ3+I3Mi1LDdtVTn9Ee836n81DEpPc
	nkwa3RhoL4YSmWcAQ1iKkg1i/ExHatc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C287743CE6;
	Thu, 27 Aug 2026 15:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFED1F000E9;
	Thu, 27 Aug 2026 15:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787846229;
	bh=CJD57KfG/QZ66WPVhOedT8gTIsjcNXLXXwCqIXIG4qc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=E8gjo2Rw096gGa06lttjTPVXYA/0357Xt78LUc6eDZqgcAwLSjD+wZOynLB3ozuU8
	 E2kq+RN0t8fsnysnZKtrszpNH2HS8RcuvXvxJB9DzyDLamEgXP3yXSi43Rtrrfci2c
	 xT3/aqIiGNAbd4eQtbTiPkXAGuKaBAQiC5Q/qJOeoPbzM7uKT4n3AQdfrg8LlmfOu8
	 V9GM3Q1uXNOPRmMQ6aCroV5zR/jf331cB9E2ZawOIpMz1WLuRjYkwCu8IBoEE6yNSm
	 r/tZV5Zxk51Aqce3ABeh4pnBXKa4x72EG2/hUECPwL+zIEeeOd0oJHh/fx6+pOSfH3
	 pbM0eR7OCvoJw==
Message-ID: <e6c2ee8a-4047-4e9c-85ea-62bcc04d0be9@kernel.org>
Date: Thu, 27 Aug 2026 17:57:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/18] mm/swap: fix off-by-one in swap cache replace
 sanity check
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-1-9b43f5163238@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260821-swap-thp-cleanup-v3-1-9b43f5163238@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A83B4C000C
X-Stat-Signature: bqfry6jptafzq44d8srb1ztq5rxp5mzs
X-Rspam-User: 
X-HE-Tag: 1787846230-475433
X-HE-Meta: U2FsdGVkX188Nn418MGcuF4mH4a6cvIVNqA4C6I8aBgglHji8+sWChaujGs9n5oNH5nCs1dVfFCWVHl44EMY3x8Ec7JNIJLOkTma8/Gx9XZouuLXgqCcm7rXCNwp0mLDyPM5k4macm37t6gClm0/05OX4e+EFnE7pstqpIC5F9kFYbdR7Lvz/TShlm/IPI/uGChq/IpvXLHvdj0hASDFXiuYDC1eifXgLVEyPPXUaRNB5qLHV7i2w+W8sUV3/entcQ3JOfb70kekP9mVVh+5FkmSz9aIXSQWf5RiE+dsIWpKAFZcRx8VZs2kJFF48HDWuRV8q84nHz0i9YxSlUK1UkCAs6CI6kz4vW8Y+4WkO9ws90KhTKpTJ/s5gpHTOLmHipD85kGnDIdUEgkckUhYDn2areJdu22BjIZUF6j9uqUlugCVHdGosh/Pm586Az6FyOSlS+0gKV+m1JMLMXi0OY6n3fpAn0f+llOW3mFAUOI3NreUV4nk4JwfkGRBv8TLoujLIHWpVJG3y+EXae0uZFQWpwgK7OTeYMgCw2mWe+5WC8S6As8v75bJyZys3z4iHC+pJZFaphzbpq6gyE0k7IYBMcp9MRRs+qFDNfLysycsU61dDD2G4szQ/JtY/i0o/mQVnPRz9zlBDlGdzt+VO38kXOL1Gv+3esqX63a4FlxMG5/V9Bp+J059rvAuWiy8L0WLfFxXGYOaZzf023b6ECxbGNwjmqp2cSjW38RVjOUzKIaSrPflUXCmfyKRt26OpnirAtZxpEIZjhtgeEHhrANdHNiCab4x+baFKHvPjpi7PeW+JvvWilRXV7NTK3CCcTpqXvYxFoOHHuqVUHmBjUO8Jxe+jYKE+jAryJLXQ3crWYROnU/04JFP2M6ICYt6uSZMEFAndVorPdoaJvjbwyO6MdjZo0fLDgcjJlw6WYgy8BiKmOm38zjFqeipxvn3TMTJkNpIS1QyRMLAsTM
 R+h8pS7S
 3obnejCwkzs6bOcTctcX6o3so7C52V8XT5R7yIGu4YpIrUFPCZgHtuAmFdPV3jEM6cz2TZPFq3OrXokzzle0etQZh5+2oBuzNBkmTmxQTBMNZAkiPqR5QLufOf5a8nUAnUg6Odx0HafGpEWCsPfVUCrCAwiBO9kXQXGENQuYwNsaZXbk7/5rmQNBUdhCWJuCXEpb5eW7JmfhpHOqn3fNYzAJ5D0xf5BGmKI2Keqggdl6mbwG3MqjBFYmeDputXCAq2cIIsnmy0WeZNLd3elxiUVVUAJH2Z5lf1JD2XKBQg/SQOsuPy/EN3Mtabl0XW1PE2zG6fQH+GpMvv/0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The DEBUG_VM sanity check in __swap_cache_replace_folio() iterates
> the old folio's range with "while (ci_off++ < ci_end)", so the loop
> body runs on the already-incremented offset: the first entry is
> skipped and one entry past the range is read.  For a folio split
> that entry belongs to the first after-split folio and was just
> repointed by the replacement loop above, so the check would warn
> spuriously whenever sub-folio orders differ from the head folio's,
> as non-uniform swapcache splits now do.
> 
> Use the same do-while pattern as the replacement loop.
> 
> Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache and switch API")
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

