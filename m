Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7157606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 19:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=es2eEKk+
Received: by kanga.kvack.org (Postfix)
	id D62A46B05F0; Tue, 27 Oct 2026 15:10:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3A706B08AD; Tue, 27 Oct 2026 15:10:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2A676B08AF; Tue, 27 Oct 2026 15:10:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3A426B05F0
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:10:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3FF3E140AC3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:10:01 +0000 (UTC)
X-FDA: 85369346202.05.27C8DB8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7FE5D180007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:09:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=es2eEKk+;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793128199;
	b=YlIo/4g7Py7rFN1DgtTzuZFaiPtFzGLE2nPUQik1BRPDYo1nHyzzKoXnCm0TIfXKxn6uir
	nPSz4/cF87W3xYHyYDDSYrZa16RRN+G5dkVozk/+SuCG+3u9rZtMzYXc48rgJ3qL0vPwc7
	srZe3fZEVSBgadandh0WEg2QvjnTU6I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=es2eEKk+;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793128199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kkvfEtwgKNH/KsYhrOsWJWMTyAP67vGHRSRe8u51NyU=;
	b=tOcScndTePmYhZrzXK1yeYxXrFfNNXNIITpbyZEr2KXiXlbWD+4nS9BGDj9eB/XjBJg/WK
	y8glAth8MI1UQ7F3UyinCs9Nj3FDySUFuNJn1Hrm63Ro1caFZUUcZUwyzQ8EUr0F7R+NcK
	GYSXXrRW7ApQx+pCoFlLWfq29Ugbf0E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB35A60142;
	Tue, 27 Oct 2026 19:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197B11F01825;
	Tue, 27 Oct 2026 19:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793128198;
	bh=kkvfEtwgKNH/KsYhrOsWJWMTyAP67vGHRSRe8u51NyU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=es2eEKk+bUcpnare1MMH51MzJ56RMYhJHCJ4BbctEiBx+OTKwVt98ZYvFRoK2s802
	 7zEK/2ivxgL2Z2lGDn9QxlCzi4S3oV1kfpOid34xAz5jxDFltH8xfEeJp9M+7/Ptz3
	 ZE8XAUsU66F9fKYfgRjOUGIK8VrdX7t9QDm8O3gjYy/vNY6XRXPLq1oT35R7IfhNm6
	 vfwa47AhjF15KgJ4OPPZLClvSNtHPclXBuu0DOKz/kQ3wVHCLyxglh19i1lO5umlq1
	 7M+LKT4FNl3GB5zrB/ijPxIInk/P+8QS2D4Fk1N0Zv8kpezBwrOu3C7LY5oNXwaWnb
	 JBUMmaM0Rvp7A==
Message-ID: <c4be5787-c519-4fc5-8e58-743b30bb6692@kernel.org>
Date: Tue, 27 Oct 2026 20:09:36 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/46] mm/memfd: make f_pos accesses atomic
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 stable@vger.kernel.org
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-4-6f74bec9a5bb@kernel.org>
 <179307206859.1171062.6841971971647864368.b4-reply@b4>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <179307206859.1171062.6841971971647864368.b4-reply@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7psuknp7r4h6e1jci3kt43ek5zpbmji6
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7FE5D180007
X-Rspam-User: 
X-HE-Tag: 1793128199-677075
X-HE-Meta: U2FsdGVkX197WYoyS3d+V9GmehAhh2jqjGb03uCvfXpADSJA5OdOMrkUrazs6Nh6QqiYsjzhoquYMsZCn948uVg53FxisHbGY99YkvJmoYLOBrBeosqM73uudaCwARf0J0bsAojeRBfEEfU5zsZg0C7EntLstwHXq9iECWztJHZ96nZwdSQX3gscLUA+6EYjVSAASSAW9fFCGy7V7ighaAhV7ZkVbXMg53ZTSIqLDODX78yIiE4100ol3v4U/9SumTDHZMKt805SG0MVQFbvEXDD2GWDuiQqhRLeUhZ61v5cSGv5izqMnKrs7B088uco4LB4mborkx4njEXmRZrx33tkrU2pD3pjklgtxynRRDZ5BPK9lVNEz+s6oDmsfw+SoxvhrtHTTO8LUac/1mQttDsAgrHur4QUr/a5x/EsAmdr2P8Z3w8xfEIkEzFvAQVesW6G5zAfR+I6NxMOta5TddiYmUJ6Q/rdqhJrUAFMvWHIlb8i8Za9wwBF2cyRJuSZZzizMfdPaAPijNMPCflzpCohWd3RpNDtBGmwfeJMMTE6x/Ij/hTRwc7RwxNcduf6uSrR0e3pUyMit7eUZazg57zXkRT4eZyl4HKrEdcN4X9KopT+pvdmEZh45caKsVfY0XS1uz1e4u3X/gd9udXLdGlTvJYQZWatTRtSaISf2ERmo/b/XYVTMNLHWGGn8nSYvT3o9mR7bUpd9ETswtKeV9Rft9TA+EWWeJ+4zLgnodL6fzlMFyYcK8i+5J3ePE8oG8EngkxEhAZW+VJB8YFKUp9utmktSFW99tPB9lllAKCiaf4wLN2vxhJkMEVmD5XZj8yoLMUAgdqmmPW32B5GPdaynlFxVuuCn4MfZXmXRpWUbksu2eYQWBFm3H010FsIOL1fp9iPEMLBsz//sBcL8rtVW6/3DklpxWFTOe2TtilJsjEYplHZV89mUBmfOyVFnH4X8R1YfFdNtbf0TxP
 hKVcdWcP
 gmDdBq18Xr/udfc/6ISuXoWR49AZKKa20irvBj7FPEe0seHBFN84I3noHANTkLDyP+mfIOOAqHH2y5QnXYF+OZnKzwXSKRec8q4NoCz9cS2hGNUebpWxvgzhcDVHiNJmF3Ehk2f1F1r7qklwGsnP/B/FnqmD8iDXgTcGpwVtmjNLc5AGq3B5xzTtvy7bcvk4NyLoBNegiof0+pG4eftfb42NRzIAq5/VQremoLiwbQPGiGBWHjp/XxxnCVzSgBBfUhQcPHfwamXhnowr5zh1DM0cQ61z/WPTp6T11NeFxSnYpXNkDVSTaY8jKLGkLtm/kfyiA3yBJT/XM8n0xcX+PpsS0rLU+mR7SlmZ9vT9BUQV3fn/dNK5dqJk6u79v5xBsKYAAvEWHOIASmlQTqHwlG7BlBWs66EHr2WPTqK0cbzpwxD2dqyD5QCt4a8/2gP7p2NJys7YfptBuQO2U8Fum1LULvp3PonjAl71XGeete7x1If8UuCz52qf8ik+aQfv7M4cAr30pm3DA9EY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 04:34, Gregory Price wrote:
> On 2026-10-27 00:17 +0100, David Hildenbrand (Arm) wrote:
>> From: Josef Bacik <josef@toxicpanda.com>
>>
>> Commit 9c225f2655e3 ("vfs: atomic f_pos accesses as per POSIX") made
>> read(), write() and lseek() on a shared open file description of a regular
>> file serialize on ->f_pos_lock.  The flag that asks for it,
>> FMODE_ATOMIC_POS, is set in do_dentry_open().  A memfd is a regular file
>> too, but its struct file comes from alloc_file_pseudo() and never passes
>> through do_dentry_open(), so it does not get the flag:
>>
> ... snip ...
>>
>> Fixes: 9183df25fe7b ("shm: add memfd_create() syscall")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>> [ david: minor description tweaks ]
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>

Thanks!

> 
> This one arguably should have at least a trivial selftest.

Yes, best to bundle some of these and send them out after the fixes landed. Thanks!

-- 
Cheers,

David

