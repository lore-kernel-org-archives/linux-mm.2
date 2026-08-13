Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 756F7C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:21:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 650306B0275; Thu, 13 Aug 2026 06:21:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 628496B0277; Thu, 13 Aug 2026 06:21:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51BF16B0275; Thu, 13 Aug 2026 06:21:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F0A76B0275
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:21:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8BFE1C05DB
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:21:12 +0000 (UTC)
X-FDA: 85095853584.22.CBB17D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B7AD8C0003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:21:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MAS9ggXE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786616470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SbuxHmqDbr/TDoLiKVstYcqIhkRii7nKMWvnVw3gtYk=;
	b=WsE4zY33zmnY9hu2Syp8tlO5QRhf+mVkP6ePmDQa3ldGf56tp1KMpd2E7HlcWklp0+3tFd
	hd9UWqyIoIjiRxYmfgEFQZVIKD56xyK6htj09OzatrTVnn653gneAyuM+hwypcnllKeo/I
	Ley7C4m5J6PPeTSuv3p8PxPm6p3TwhE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MAS9ggXE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786616470;
	b=zHI5rBMHwGyzTjulXS5l7nJTBZHWHzwbKI3BTLvWmef8mcobmfQNWfDMsJbS/RbB1eLAnM
	YNUE2QH9Q1by0c0eAAN/NKeLYk/lw8d/2tvZ2BlwXgtxZIEa9OfK2wQVvnVF22s8hyq95D
	CDgv/ggvp9QoAWtXZuHDamffTohrfm0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 030B7404A6;
	Thu, 13 Aug 2026 10:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669481F000E9;
	Thu, 13 Aug 2026 10:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786616469;
	bh=SbuxHmqDbr/TDoLiKVstYcqIhkRii7nKMWvnVw3gtYk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MAS9ggXEUpw/Dqk1MOhvGtPckZ0uZJR5ZZ78AaYcCnRZuxCBshpraw9TKluwbOkhz
	 FsX5ZSPNzGP9TK9jC5R78hb8VhPfK9+16hVNKHV0AJfLjdve1teJvZNi4pgRWl+rHd
	 CzDREZT6t7dEMDDj/945tHNmQetmIBFRsJaH+5TAf1PlOw4wqia4ci2fU0LtvEHB8j
	 Mq/dxut0XI36GEVu3ZQMKCshK3k105UF73M1Il1DzHbVLedPsdhhD4t3AERFjxajNy
	 C+B7634Zmvcok95MdsJF6rANEdD94ykeb4RFG4JU/kiOHrVJFAGI6A5WRcEQ2ub7hK
	 TfeAyJ+BKT+WQ==
Message-ID: <6b7ccd6d-c332-40fe-a1c1-65ca11a4faf3@kernel.org>
Date: Thu, 13 Aug 2026 12:21:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] selftests/mm: skip guard hole-punch test if
 MADV_REMOVE is unsupported
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sarthak Sharma <sarthak.sharma@arm.com>
References: <20260727095225.372655-1-usama.anjum@arm.com>
 <20260727095225.372655-3-usama.anjum@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260727095225.372655-3-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B7AD8C0003
X-Stat-Signature: zqitpe7kssj3jokjst7bsywtkycdy6mr
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786616470-801228
X-HE-Meta: U2FsdGVkX1+bqWzdf/Su86GIh4Eh3ya5Y0gVr3JAACf6oNuceJouE358UoOs2tbaR/zHjHPWQr9N2IClufIeE+QmHDepOu+52JSxq6zqOEVP8UAO988ThvtBmp81TgZSg7BWsRRiV0yYGvJffMRBHbt7g35JmetqJQclNT8q4TEApSUV5mqOh97kwQzPf0sOyvMeRpw16AAvDdiBTtHMN1NnljLl7au+2bp8BH29GE+XeEKhm4KpIc89bG+tXoKh11WJZZ0vLfqHcm2kfd6Rz2OA19F/Btrh26Yi4//rsWnjLR1kLACunyAtotVB3r6aQi6knVZHmDxnWNjHVbAq7A1jMjiidfLkJQO514u/f/1r6mOUJ0xFpSKU7fPSxMsBTO2wT/Xa6s9EFiiuxyxVo87nkY6HdEoXb+KlNjTAIjp5JJMuvp616RAUIw1RhwHiF3sNkOKMB97Sn/SUQjILCPgjMfgnqcA25EfRziIdS+qqpWCRCXcJGYRkV8SIJhjRYiNrSDB1QDynUYUTYcrdvTqXVBnDyxAtJDqWQPq8QrsJG3YWbzJLHTa8++80bwRmvJ7F5hCYnvp3KgSlSFSv4ajOJq7rj1taRr0/7ApeokQs42rZsrGJvOg0efFRMpMkrAwHi/Ve3B6bjuYGrWEJmYWLs53HKayss+BjPZnHCtJLiPL+Ou0y3HBzxgHcxuNGnntziqqWIwszbrB6N1c+G4hTfT7oQtjvu69Sb2b10k7PPH0xIxSihZ4D9MQar0RnflDudPyuTkwObVRtoqm8N9TwpKjiVjts7sfyxN5OeUP/Lcpr3kpYQqAof1oXLooq9i12X/flKqt98makkPJPh1eRz1kvSqak89GhTLDLdO1SY00PKaDtJSkCLo0R8XQZAtMBHA3KVYBkoDU3FWqbDAy6vFNc6PaQ0TH82e9KmrbqWkjb0tkyEW21phYqTHZiH0PzNYGEebpTP/L7Mza
 fr64gh7N
 ZyADRKJIdOvt/c6ygbQa6tDdom5o9wfSbNI0O1wiOQ3urVNm62miQMcrrMaIOtLJLAIBkvzHq13eIjL8zL9fARi5alDkHhbGYj5/VhNV+7KgLVMSZzhnZjzP8c5l3O2xrIENZFy/+RhRKM7ftYCwl8Sg0U0d21QxTYzEzQHY0g3UII8/hjRxJ0EkWK2+2u5QcG4nYmNkzHDbevXmnieQYrO11oxKmnE4hE/KFtyum8Npz7ZifAARd2+aN/Xh6uMAWro6v09Fqy7HTMcwTjF5I7rLyPo4vz92givdRm1RVVuWIWjXK2x4EgRG7SwOMqndYFn0kc0rY7dbx5Jv+tJZmU/ZbV0hPM/Q996oxKVwLUfXVoWNmlK/zB896o0NDcrerOM0Jc4g2DahlCxcAD1hmKLnhPltfEzyYpbe+5nitZbNerkajh/hBykv0sRitZ9wXWTcM05J2VMtZC9++GWRQW2hgwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 11:52, Muhammad Usama Anjum wrote:
> The hole_punch case verifies that guard regions survive MADV_REMOVE and
> that the backing range is punched out.  MADV_REMOVE delegates the hole
> punch to the backing filesystem, which may reject the operation with
> EOPNOTSUPP.
> 
> That result means the test cannot establish the state whose guard
> semantics it intends to validate.  Treating the missing filesystem
> capability as a guard-region failure creates a false regression.
> 
> Unmap the range and skip only when MADV_REMOVE fails with EOPNOTSUPP.
> Preserve the assertion for all other errors so failures on supported
> configurations remain visible.
> 
> Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

