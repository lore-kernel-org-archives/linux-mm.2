Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D570C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 781A96B00A0; Thu, 27 Aug 2026 12:37:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70B8F6B00A3; Thu, 27 Aug 2026 12:37:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AE686B00A4; Thu, 27 Aug 2026 12:37:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2608D6B00A0
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:37:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF3731A0116
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:37:39 +0000 (UTC)
X-FDA: 85147605438.21.9BBD0B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E0EA440007
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:37:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UO1ouNA1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787848658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=htyGdVLdNs+c5tlJ1wIfTZ79+eETdg1STIt5vDLfjO8=;
	b=8pLRW4jRxa5v5cZ05Ue69NqP+jqH7+OJ77vFg5WTvoT7NqinVfwmZ5BhEr8NzgihYpS4YC
	fIdkZt6GxeFnIhVIYAva9Wp+W329LOxAWm6WtmWuRmwi6ab0B5twJdiurW3OeQV4V15UlP
	9SiwTylkl+cxCWqCMB9SF4/+Ur7ilxM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UO1ouNA1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787848658;
	b=N1uP+XUJUr7yg1HWdlsvTm2WqnaSDzbMBrr0xleJvNrmEhMLVY/oGWd6eWZ/dTiS8nNqJf
	NPH7CRnIbmRrbN0JFtKGJy61Kfx0BtQI/M0IgFLcPpKJr8PpftoXATvY7J4UupXjv9dMIq
	plvEe3yAEk2tV6Ea+MXPSBoDYN47VaE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F422640A32;
	Thu, 27 Aug 2026 16:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C4A1F000E9;
	Thu, 27 Aug 2026 16:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787848656;
	bh=htyGdVLdNs+c5tlJ1wIfTZ79+eETdg1STIt5vDLfjO8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UO1ouNA1LQx9iuf7nR0+Q6yPndQnzXNrSi6RznHcD8DvKCc6aFZ6HbwgiXWyLcAzZ
	 54f64inT4LGwh6XKz0p4hej/egkNlxflwUGg87mzrGpx5opzP+CbuJVncV3Yu4M+Ng
	 kS46HzEWvQeuEV3V+rPh8ug+Eb9eMLL+Qp5dDqjxrWCNZi9+bQJnVg7mCMblI4rM0n
	 L0VGblRoLv8+YW7L3nBsysnlLPdL2kAKuWrG8aM4HzN9gmWbUomQHJsK0CqRKdL4cc
	 ONHSzNB6j6Cb6n/W3xa01KrmMoOhTWoPmOR/aa+W4uo8dLrc9XecBXKA1DrJUmOev/
	 i9kXCftwJS8tA==
Message-ID: <05b360ed-b22f-456d-9077-998566ea8579@kernel.org>
Date: Thu, 27 Aug 2026 18:37:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/18] mm/huge_memory: move memcg switch into the file
 split helper
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
 <20260821-swap-thp-cleanup-v3-10-9b43f5163238@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260821-swap-thp-cleanup-v3-10-9b43f5163238@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gby57hrcd7mb5krshqijx8dgnyponef4
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E0EA440007
X-Rspam-User: 
X-HE-Tag: 1787848657-89115
X-HE-Meta: U2FsdGVkX19doMUlaKZFN+o9pGIWtNlPE0sR7jdczKJJhh7hmZlTLvoTHs84pw00bTiuxfteo0gAosX2HvWHtIf6ClFSp/ZGETZS7cdGiDcAeCDnqqUQY1O0XEXv7eHaofHMI9hqcRR7JZkY+NafHbLNKVNzfG9gyu1dlP/G9neONhChSGL5UcqSRPPaShgjsY7V9egTq3nFcZ16ZLz5vlBVOtc+3abZR0ASMQyxOWiD0eXNmbQ/iXpzIybmBRlRxunGpLUhuSyDYFfihwJcJV+l9fbkGTqop93LzTugLuqiF6CmCNH1so1jSdULKjWUe5i5E4F+M4yzxh1IWWtXYVY3H3HqrEGSqR6CceT33qjMhPRG2TK7whGGq19C9AoSgOSrRolyQIqwRGEYcbnfHDVqf0Tj1gR9XL8rlG8Av4vbQc2Qq4J3dKfXcdoU28aM1F4rNz+EwXG4tj6afeQvwQSzoQuUKuCuf+cIM02AGpATgfbo0mGTgPPpcuCOwcfkz44O07aSJtWpS8XPou5S83ChuNjwR3dE5ryYV7slbik5gGohgA0ZnGwkupeCxc+Qwowho1ryVHF3LGrzg6OqMVH7uZF8D/cEru1A9BWp4YUs54AtXDRnar4UlurbebwJQS4WuV0w/rSDWQnW0mMFCAK70nLvD2XXp2B1ashoNkYCAHgXDcWkrVDZg5/xGGu/L1QNoXTZLWjwCM/IJ/DNa7nH/gUWxUlN7KlNCB6OHb00zDLqB0uFiDm8xJK9Jz839/5PRUHi+5WcyY1docIAYKh8AF5SoRD56bzrAIqy10n97/x1mie8OT+RHdee5XVr8pYjELvO25voMDravHRYd4wSNS1C31YuYamw2XDPs0SdzzdfczXug73UdnbVcsKKeHeLH+6RqucLktgMA9gInC8h8b3KzByPZx/azLX9Jh4y1PiVUpR8tydBxPPRLg8xRqrmOpBE/26dXZrl8kc
 mLOxF3Bb
 Bs86twP27B8PcuPL7Um+4lTuXoIO+yzI+eFBQH/95U1jIYjvhTsEK90WdbWnlu2ASHKrYPaXQ8+0c6OiSVTBo6H+wGvLI9GetBrmbXNw1mXeAs6r4LdPLiw0Yu4zG9Z7Vw9o1+jDS+Kk+5znUg9qaXnTyC9d1rIXbB8nOEgMOAX6yQhhbrR3Jg5WOJaNPXU1wgk7h7VpDOloXIEGkE0VX/x18nkF+1pSGPgeVVPUJ1W9kObNJh6GlskPUdTEuCshcP4yRUlETGyi3x8BKeTcLnjq8yj+CDNh80pfvUsguYrolQwVIym9LYD41V+14PT5vu6USUpwwL2Qpc9QAuYEkioqIqDtzX5lasSzZhJD7QF8loc+YWZYAQYMzSjvEQkgDT+ro
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The xarray node allocations in __folio_freeze_split_unmap_file() need
> to be charged to the folio's memcg, so move the memcg switch from
> __folio_split() into the helper.
> 
> The anon split helper and the after-split folio freeing perform no
> chargeable allocations, so no memcg handling is left in __folio_split().
> Rename its out_no_memcg label to out.
> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

