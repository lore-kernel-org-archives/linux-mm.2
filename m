Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D7F9C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A6AB6B0260; Thu, 13 Aug 2026 06:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57E376B026C; Thu, 13 Aug 2026 06:13:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 493DC6B026D; Thu, 13 Aug 2026 06:13:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 167E36B0260
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:13:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93722A0581
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:13:55 +0000 (UTC)
X-FDA: 85095835230.23.CE33766
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B84CA1C000B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:13:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XYoK9Fyf;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786616033;
	b=xccXTOcecRaOpySJak2eDSuYxfCgkEYI4Wb4RzqqLeiYFHjQSCKXtXfPohWJ1JxD5c2EG5
	NaQ6OUZgfxz+wtruz25ORcYyo6hExTKDWdgFX29enxRwk4yLS6mIJEjicfhxnPx+rzGvSl
	lnZcU8YAcAt3jbKnC8e1Ac+iuYRZSiA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XYoK9Fyf;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786616033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ksh9JQogDItTsNV6DrebHCY8apcRoEePwnjhFJwjlWg=;
	b=0YFtiwFIlIWJasWkOfLh8noOsvqzSGRpkw4TEU3g0vMxlj4Xy3FS2aQ6F3Yo2pJacGN5QG
	hrW+qhAm9xebbNA001cuGrQMhHthROJpTIWGt67EL7UQ29V0KiXHKtHefsbLpHbZRbKPSd
	gQH44WW2FzlJZRMGT9WLSaIEwq07kbc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EBCA5400F7;
	Thu, 13 Aug 2026 10:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841F01F000E9;
	Thu, 13 Aug 2026 10:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786616032;
	bh=Ksh9JQogDItTsNV6DrebHCY8apcRoEePwnjhFJwjlWg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XYoK9Fyfvq2ubibGlKhU1B8GnR05AiHDXs32H5zWVbCZrCKYpsgwO99THe6YYLJBF
	 zMIszEijfcu2yvtBR+gPORLO3yU/3fAZPJy2MjqtCr8oinGUksTr5fZndLyTDzmUU4
	 LO9KebeviSyXTG9OSenHm5wo/ZYbkvelo/RNFZekreoLKeeUSfX/hniKUNPbxDa2g2
	 pWzDuNltMcBDqhx5BFs8XGQG6IDmmPz3MJDnzlCwFVXEM1WPAmuUPj14npdWGeii6C
	 ww/RDdH3Z6owFqBt2Kk9s94iZuxOy6SypUVF1I0mNketjzMsi1DQq6K5KYAK39M+3e
	 ePrrx8Kp5V5zA==
Message-ID: <15d1edae-b9b2-45d9-8246-8d07fbf08bd6@kernel.org>
Date: Thu, 13 Aug 2026 12:13:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: andriy.shevchenko@linux.intel.com, usama.arif@linux.dev,
 hughd@google.com, willy@infradead.org, ryan.roberts@arm.com,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260709044334.1741263-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B84CA1C000B
X-Stat-Signature: m71z4foa3hefasgwkw184jonx16kes55
X-HE-Tag: 1786616033-554158
X-HE-Meta: U2FsdGVkX18J9AVBGv0VE/f85uyUqJArhmDw4txjf+VMSeMaX7XwBb1PP6GR2pc/YbnSrxVT2+Aqb6rcAzwasunFw/QVX623zvKYQRkyvYnKJNBaZQsdFhYFEVVqkEULVUeF5K+w2Qfjr4GIzA2ZH3cR8Epz86R3ZNSmQKlrakaCW6ixIq794uIh/TFYkCDi9o7RoIsEhVD6I5X1lLLDPto2MkoqBhq36p5L6qtvKZfZmxXJvYJeOonItq1M8dGC8qjNG8ugus38Xf8nI2J5rTDysTmIUD4jxD2UjptItqa9xu1rfPw/X+Iilp63G5mMo/3Mo80jdP+VZTDM48r78guDfpQskpcQMaLMGxqbsjfaJBf7c/jAIFgDYOA1YKve0cpwY6UjWJNC82spZPd+zFl0Wa1syge4fakv/qp05LSUvlV7M7NWUHSmvBwnhHPsgvUayby8KyI5Yc88Cq/oTmn+QTYgbbnBHjqPsC8RJcqh5vubWLS8Fwb27/s4QFZg3p+7kszNvQklXYwxj34gvZ6t7n3kSoJBBiBNnTtJBTWquY6dt/sjYzjDMs7PsjkPsbx805Q1qL6zgWGrERg779cqPeHwROcYT/baTC0Blvh+D+vzWWW6df+6ZuYAiG+RotyTrxNr/eWSwu1d12d2yJ9Ual8KxQETsiv5fLR/8GOnEbLeXF/BZ0m7UXsQIrKTcP1PUu3Xy4ylBbU0uysNugyCxO5iq/jkclfKCW73IvhN7RsY09okVLKsZNXdBb+ShBBr9Fx8KUSUs7qAQiL8m/cy1xVy5sP7jfrXuvpuj6Bd3BnIBYtjS8+H4cg0HYUREqgW+4YORxeNHD9shvtsoSuzJCNTMF2H0UQ9FWPAfy1WQ0HNeUTrdGEyO0PMK02EuFXdan0qW8uwghOdT5kBmSOiGjohzfif9cO+hNBQWhboFdMhBuEzAhDBnqLKvNiHwDsObE55xOlu6zHM/SZ
 VzGMGHWu
 wflKYSWIeqrO2EKPL2Wk+Z3Kqtj8JrjZknyKkb6HXbl/0X44UA7lTqi8+OG5cd6yshc0pRlrxJMoHDAAO4o+EZAvofZ8CuFTIiug+HukAIf5i2N8p7WXxAEJdbVVcQxTOcG/wnESY+XvzFnsHl3FVgxm0De8kpWfcJkWcNRt+44qwI9Xk+5qKieECickKjAutCrR8awnZmE8dbAM40OeitzOoOnsv79RYEyVjOvuSXp95K0uZCNCXITadgdn/FyRBq717QdPBYnIfLXqUn4HYaOnNK5gc0LKmHv6qngCMj+4+iefE3Y3iMcZEFlLfgCYtFT9i8gvxa4TnQGNM0jVQgIfRpMgcyEapXvB/agUbEjVwEiqZAjGYLClJCcwUpHaXF4YjvZ9QOijVFejExW4C7WOs0v2pOEwNpPa8On9wI4dDdPcAyIJ6c7j6h+C7NTqZzGqRwErIWeE/po4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/9/26 06:43, Anshuman Khandual wrote:
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> 
> Bad page map reporting currently stores page table entry values in an
> unsigned long long and prints them with fixed 64-bit-oriented format
> strings. This is inconsistent across call sites and does not work well for
> architectures where page table entry values are not naturally represented
> as 64-bit values, such as 32-bit or 128-bit entries.
> 
> Introduce a common helper to convert raw page table entry values into a
> fixed-width hexadecimal string based on the actual entry size. Use it for
> bad page map reporting and for dumping the page table walk in
> __print_bad_page_map_pgtable().
> 
> Pass page table entry values to the reporting path as raw bytes together
> with their size, instead of forcing them through an unsigned long long.
> It keeps the printed output consistent and avoids truncation or misleading
> formatting for non-64-bit page table entries.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Co-developed-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---

From the discussion I conclude that this patch is good to go now. I wrote it,
Anshuman cleaned it up.

LGTM

(adding my own ACK/RB is weird ;) )

-- 
Cheers,

David

