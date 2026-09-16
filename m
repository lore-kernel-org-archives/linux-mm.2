Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E67BC982C3
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 15:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79E626B009B; Wed, 16 Sep 2026 11:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74E7E6B009D; Wed, 16 Sep 2026 11:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6653E6B009E; Wed, 16 Sep 2026 11:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44A626B009B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:26:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA3D2120790
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:26:27 +0000 (UTC)
X-FDA: 85220002014.06.350E77B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 015BA40008
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:26:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YWZEbHAh;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789572386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QEb5Qb19FcDbTyVRiixInWMHYbzxTpZ71E1UuOSUWXA=;
	b=MRx7PRe1Wp/IJ3yfMZAFp/8dP7aC0qxUkFU4f7eau/de5/A3bVVrb42EianK1O942juFhX
	LlLbJ/Q6U4+iFgBOs5qLtEhIv5KSiNm/cWvcn2RRkfFCItbd5H3Z+XZ9vqTMqemzUMVAN1
	HkG2QgKyC7SKJ9wLPnuV51Ybf/KWcrk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YWZEbHAh;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789572386;
	b=st6qil5g9GFEGuAybw1RiOguwNx+vdk5+UG1jMf+ByXhMU9Bj5m73IXLYRgTfeTL9ydPLX
	4lkicqaZiVWOX6KWdejU+H+10GwMGt/YrEIenzzVYm7WeZhjE8utWifj7BsK9icZx/ZPby
	zk3FOjE6/Rz5kU0mtmIh7tZSh4NzThU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 148FB43A99;
	Wed, 16 Sep 2026 15:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729C01F00893;
	Wed, 16 Sep 2026 15:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789572384;
	bh=QEb5Qb19FcDbTyVRiixInWMHYbzxTpZ71E1UuOSUWXA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YWZEbHAhFP0bHivxSTeQa8jR/rVVQOGd3LcrNX5A9uMW2DcBaYw3fXpCHdJsTu9gU
	 TYgAWl9hi2rdHAv1SfgsV8/ZELPY6oJnCuT6E70cEUh5UzBgI2qZrG1Abl/PB5U4NR
	 w7gTwp2pIqXV+SUz1zVJws6jUEzFjUSpeCJCdQLIwepYYL2kHvj5oV6tuVlnB5z9p6
	 CLh2ZKWW5zu11TzghgNKaENcetvQNAH2KnLpo7CpZhsUt65VEAmVuQygMZgWDPCTU2
	 zyb2AYQbr+TqczE7YdgfKan+ykk4v2Hw9AQYtNtZNCUagSifr34t6ZBH9eaJCdKRPX
	 xd5FeYKQ2Iq1Q==
Message-ID: <8f3d1fa0-aebb-4e2c-9e7a-63934ffb3de5@kernel.org>
Date: Wed, 16 Sep 2026 17:26:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] selftests/mm: fix size truncation in pagemap_ioctl
 test
To: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, gourry@gourry.net
References: <20260908134117.84405-1-zenghui.yu@linux.dev>
 <20260908134117.84405-2-zenghui.yu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260908134117.84405-2-zenghui.yu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: z4oqqcir4f195b99qu9wt81pb7aybz1o
X-Rspamd-Queue-Id: 015BA40008
X-Rspamd-Server: rspam07
X-HE-Tag: 1789572385-562977
X-HE-Meta: U2FsdGVkX1+zXBy8qV/E2cNVB88xVX4XvABWQ15FO4abjzQMbCXFHh129DEmnm7gjiTz3YA47J3fOWw8xOqQA452kn6cRAQvMnmVtedjeQ3c74wNAb79rg6FlcBrKv9fFathSM6VrJ+NWP0CPHoIfw8XBUFEwk8LmMphMjyj4xEOzJ3IOMumdcG1HV7NcyL3neL5d7kqkFuT/ggPeRX/Lb0c3mhWre+SoprBYgxwFIg+Cebx44BJIsCUfsD6Q+D2iKFtM0tha/scQ5vgnEo3rh9RGEeiSqXF1GXfr85D5PdIwvwN9F+ncMa7QQj5Qt8pHFNdfQe+DBX3slQeIn/5mPQazhYVxZ9VY2GHjAqD0Ev6YT+HrS/zh36l0iLg7H8p42lbGgmWYwtP6wDYIiPB0ffo6o7uuT6NwBkW4SLyHCH0EDYW/dj0z4w+Nt9+MMbxYFq04Vn63Pr36Z/nTVyfI3JAD1gpogkpwwkAHH+LbM+Hv2SKVDHDSRBHc54LIaPxnipbvUPQAj9X5zRhx+85Vr/jx/aQYRSblUr2ojVCj6qjhk6yauY8LQwr+eHQ7WWdQ271eZsh+zwMS+sXhDLj3G/qikLDBJ/O+K7jyOGCPEXhkNqREkCOYd0B7TVLkwZ+rYaAm444b36apUtAFXMdovEAlJXErzbcCimZJRbIwCaAMUo4M1GQ6ogMJsAxHzp2/+QUF9Ptjgc20iwrGejE47v6SvLDF8MkWsnj37eiSvVyAx6J32f+d7g5G174LfrVr8G52PoDy3QiMWXwNu1bJINQAlXC9wbJ1fm1lvqWxSdmzo8rtEXTNrXJadRRmZbm+RuBUdvP7RYf40soEq70KT9ZwbpgQt4ppnRQiy+f7Kw1V9NM6Is95EmhzQtSBfZ9ncCtfDOITRNW7q1whKisa8pVm71cURPmQqDrw09nhe/bcmAXPPOdR74hki3MYuoE7hJDrTAplBg+4qCQ4h/
 2EjeIwTX
 6tP1ewj6DGnWYeDJe0csGjqWxGycCU6NfITjNVDm3zlR8HlZ1sKEP/8BmlAmkc/GsjiKIiCqOJ62RKqPqcCT2wc+BORRkhvJ1zLqnm4PoUEOovtn9nmTeuQs8nRoLnBtXnW0TGHYUBQaJ9u8MLSWrTgKaZTT5llGyjqnVBPmgOimursjL+yC6q7YFn/x/xMnUhBxuxsg5V/h0ij5GIYR823sB/O1myC/AwBF4aJWyCtHNcXKCZimphszG2Gh0W8e1M9N/GMwD4ACb5OrsXyaUnxuSYQ7Z+5olIq7PrZVeIhs01cOnDsNeuf7+g4ZZisJOxtIOtK3Mm28JudYCMoc1/PTsR+LPI72F/EEqlyRyYp5O03Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 15:41, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> On arm64 with 64K base pages, the huge page size is 512 MiB, and
> hpage_unit_tests() builds a 5 GiB range (10 * 512 MiB) for its tests.  This
> exceeds the range of the int size parameters of gethugepage(),
> wp_addr_range() and pagemap_ioctl().  The implicit truncation to 1 GiB
> makes gethugepage() allocate a too small buffer, while the callers keep
> operating on the original 5 GiB range, resulting in spurious failures or
> SIGSEGV.
> 
> Fix the truncation by changing those size parameters to size_t, and for
> consistency, also convert the remaining size-related parameters and
> variables that use int, long or unsigned long long to size_t.
> 
> Fixes: 46fd75d4a3c9 ("selftests: mm: add pagemap ioctl tests")
> Assisted-by: GLM-5.3 OpenCode
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

