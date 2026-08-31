Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F27C7C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 11:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAEB06B0088; Mon, 31 Aug 2026 07:35:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E607D6B008C; Mon, 31 Aug 2026 07:35:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D762D6B0092; Mon, 31 Aug 2026 07:35:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9A696B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:35:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 40E6DA3D35
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:35:24 +0000 (UTC)
X-FDA: 85161358968.10.12542C0
Received: from mta0.migadu.com (out-146.mta0.migadu.com [91.218.175.146])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0C904100005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:35:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="qRi3j/es";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.146 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788176122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=68H+HpKcWkAQkG6DbjX9Tl9r0t3HlqtXvWJgJNkumQA=;
	b=erKTCO+dQoLVzcXsFHjjxSFksIcrte0f8I8UNs2n9KIi0axQVa5ggDSBZ4OqN3iqWNfUQH
	/ZRGGR9Fx5W9MmrpkTjcH9lDIL6NUGt17IvVVZeajam+g/T4t0jf+9ySQ5D7Lzh8mDEKBM
	yX+LLQtmTt9PbkG0zJjl/H9eMGfa904=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="qRi3j/es";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.146 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788176122;
	b=DwXwjocdasX95YS4wAaqUFmPMNmdfW1UvPvNu1jqXDLtH3A8VnQoQebFpL6O8ymOKP3A7z
	RjjdqqOvUT84+Pt+OA6U/bD/FTferRZWNtALVZReksL63fun9pxPG+Ar8cFw43+9fdrhg9
	08Iqzwtp3AILv4DWBsZPeYnbKMU5l+A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=56rYwQ/uWVOFc1jV7PXjpV104Tx5PFp2vWMCIo2fAEM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788176120; v=1; x=1788780920;
 b=qRi3j/es83qMgildeEwRs5GDNuhTPCrnfdaO6QsgbSGKarv29W/QsFZx3fChKBTz4QELsm4o
 3JKjGPGWWdKrq+bBEpfT7vtBfxKiyWQJCULjyqo3wBeillRJmtQ5m4gwZSznn63f1yhk7EJFIMT
 N3ySl/i3hU5fW4X1t0DNtlLc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a1ea18d71c6ae9c5;
	Mon, 31 Aug 2026 11:35:11 +0000
X-Mizu-Trace-ID: a1ea18d71c6ae9c5
X-Migadu-Flow: FLOW_OUT
Message-ID: <75ac2253-5d64-49e0-b090-b385e864c925@linux.dev>
Date: Mon, 31 Aug 2026 19:34:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/huge_memory: dequeue the deferred split after
 the split freeze
Content-Language: en-US
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: ziy@nvidia.com, kasong@tencent.com, usama.arif@linux.dev,
 hannes@cmpxchg.org, ljs@kernel.org, hughd@google.com,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, liam@infradead.org,
 nico.pache@linux.dev, dev.jain@arm.com, david@kernel.org,
 akpm@linux-foundation.org, ryan.roberts@arm.com, balbirs@nvidia.com,
 kas@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260831091514.1879786-1-kirill@shutemov.name>
 <20260831091514.1879786-3-kirill@shutemov.name>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260831091514.1879786-3-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0C904100005
X-Stat-Signature: a5hwbhgx5h9pfyqfknem19b359xgst3w
X-Rspam-User: 
X-HE-Tag: 1788176121-226275
X-HE-Meta: U2FsdGVkX1/yTzuLHB7B6i+SycFVdfhG5dsDjRjiay5iS2JIicn+K1ekYCMebPBfdYJMVasG654SlXK6g+r1p9qWwdiwa4Bvp4KXTcN13wmIQmsVfBK6oJ5jBXSEIbhkYzV5XoI5wLQs98V+4BqWe582PC5YKQ2cb7lsJvY/nwbAnSJcG55ZrJbqgp76++9esem+cpoq6CFnZksOvjnvIUvu5CTIoRwbZn+l2ggsNSOY6fLszwWWxhYxVJRaQ7jj3O0cnyHO7V8zAjMReNwtkR+olJ1MSMw/6ZdAlRHhllWASrjWczQCr7ImCu7WJ+GrzjZQKUlN/D2FlYKpb1kyQXwZl2eW11OCbukifIIqhCuhampyImLqyFGKvoke2g39Ho/xzz534A4P+hROvlAGVwz1RCyiBMYERCnzaJJhpbH1zPPYQtdCOJDlUJOAEU0WLFg2K8w6MziGB+x2twN2pk+iybrJBMR1+rVX2YvDHLWSgUE7N00qOjiDB6Xvlyc2q3gMR3ZlPF0E6KIar0NQJ6mrAXxWnay2RjqpvL8cS5R1nXDMbvSZepivPOQf+60v7JQ4FfZXTQJZr5XNOe9a47/Uza60E/TgraxG+LSSU2QTjXa2rLftqDHaPYMUZEyWpFlqSCnqUsyT/4ReB35P59PoeLB1A7CE8s8v87lJpckadYzFIUA+nblrHH/OO3zmgQoSIsXoWyWQI2HBCdegTskWpQYwdjjPM5TGPz5bbovC4UhYRdkGNyb/URQU6pNl/PJ6LEx3uzVy5HveU5yxxnIteJzcV8GfPMOLggRZ0P4kAxtnPiuPeTnXlINXlsUAUHDRlAt23Q72cZ4f5rl0ddGZbR7V5GuBhUTpiePfQhtroyv1YQ1oMZ2bb7dx2LI0T6kA7pwEZkp72EzpRDp3uTbmOTNfvLs2en3qm7Dp/E87LrkINkhhCkx9qoQy6dM2gZBT4E0todAJ/abQPoP
 1xov1i69
 u0edUZz5T4WmDRAyVAfMzNl84GCjnXoetT4VFeFPeNzPQc4g4o7esaXFd1l8Fhqz0o/POXweDPGq+DeEwCX2mWdakQ6zdcgSf1V2sCwsa+sUfcbaG1IqoFlBNBju/aFz4U/n5OaztV9rHOl/eiCzn+/mYSpUjfZJTbPB2ycnPEWd2VZbVMCwGGJr/gAd26kSrP5KDXBE4dyC4Zsp2T7v1KdyN5A3Nzqiz76ApBgAyeLvbwJ3T/y7McOENYpkC5JwYNsPvU+CFT/F5okfPuUsmYzLoUocVsuHclfmxpgPHiVz6rjL9xYQ3gkEtMoP9jpy6COdbp8r7J4aP4Itj8Y4XQ8ftS1qHK9I1gYp0AIXTR825LIM5Z6B46HtfxasKN3j/klD85Z7AMv4JMwnz8BWUzbrmMOC2s+1cG9IMO4LKgDV45Kw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/8/31 17:15, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> __folio_freeze_and_split_unmapped() takes the deferred split list_lru lock
> across the freeze. It is only there to stop deferred_split_scan() from
> touching the folio under split.
> 
> With deferred_split_isolate() fixed, the workaround can be dropped.
> 
> Unqueue the folio after folio_ref_freeze(), the way
> __folio_migrate_mapping() does: folio_unqueue_deferred_split() needs a
> zero refcount and a memcg still set, and both hold there.
> 
> If the split is called from deferred_split_scan(), the unqueue is a
> no-op -- the folio is already removed from the list. But
> PG_partially_mapped is still set, so it has to be cleared here or
> MTHP_STAT_NR_ANON_PARTIALLY_MAPPED never comes back down.
> 
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Nothing jumped out at me :)

Reviewed-by: Lance Yang <lance.yang@linux.dev>

