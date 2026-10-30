Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE45606A335
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 11:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DV7dP3Zs
Received: by kanga.kvack.org (Postfix)
	id E156C6B05B1; Fri, 30 Oct 2026 07:35:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9F7F6B05B2; Fri, 30 Oct 2026 07:35:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C18C46B05B3; Fri, 30 Oct 2026 07:35:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 99C056B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:35:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A65BC0693
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 11:35:41 +0000 (UTC)
X-FDA: 85379087682.19.1D0FE0F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 75F0AA000B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 11:35:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DV7dP3Zs;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793360139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TYrpZVQ/GsvgUGgPVgovKNkkVkoYTgtTPGZXWBcYsUg=;
	b=a73/zzjP3ZHXtDpqXbAllRk24fTncMlhiqd/Mbv51gPAm8sRZCUnoiX0xm7vpc/sijCwwW
	SEYd8iMZtrW1JBX4Ru6xoEmv8iSxCRXeZaiJIKaEX+04ARDDAfWzdfOq11yW/KBYBlh9AH
	QCcSA7fh32zzNa75Qehm+XZf2lW9Y2k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793360139;
	b=1Qq9awDbr/epm3BHQbKAGBubMwClhdOAkOn1QRd46AUGz3T3tKzwRePphfMAUu7pUWSYDM
	k75zLsiVJTXWOdwMuJLU4nFdXr/0KXTQQYpvLUbPGKJeXLvRWYsBoTEPUfE1wlD7sUHLCV
	PKGL166TpRk8AG1df51FHBwKLUw7MvQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DV7dP3Zs;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE129602CC;
	Fri, 30 Oct 2026 11:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A911F00A17;
	Fri, 30 Oct 2026 11:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793360138;
	bh=TYrpZVQ/GsvgUGgPVgovKNkkVkoYTgtTPGZXWBcYsUg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DV7dP3ZsojHaXxJribD0DKo5b4PCOC8FdkRUgYL7R+uUDI7gUjh5A7huogvcG+J6J
	 Nd2e24ltHviS/XzS8gcUIifHgGSepFBRuv4iQmYXeeAYxK+UYFoOtK9BPjb/rX84Qr
	 2m0GTTuKi6u9uhP3b1UQ55GaUl9OONJ2fbAax8hY8CD97plqv+q5+JNPNO220WD6qK
	 dBbODOTfcboqVXbdiS50rxbmXmGd69ll7rciNrgicqN3QR6abLc4MeZjjSAdK5StQW
	 z/9hzzkTYNBG8Q3t11Zmx8tUQAbm1gypQjVg8uptfgJSeyJf1lNVlen0WpnB2ukvv/
	 1WLh2kL5FKdjA==
Message-ID: <baeda061-e0d0-4be1-9aa5-8886182ca83f@kernel.org>
Date: Fri, 30 Oct 2026 12:35:20 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/47] mm: various (urgent?) fixes
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
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
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>,
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 Mani Tofigh <mt4022@columbia.edu>, Samiullah Khawaja <skhawaja@google.com>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
 <2f23dafc-43a5-47c9-a819-e696cda6fd44@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2f23dafc-43a5-47c9-a819-e696cda6fd44@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 75F0AA000B
X-Stat-Signature: ibxanoch5byimskd5t55tmbeco6z7yhw
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793360139-66834
X-HE-Meta: U2FsdGVkX19ZsKR81taSeNLQdcTAzrtaGL0P6J8USrM9PY06jxOG3VWdt7psF0leQI7kFc+S5B7Ct+Vm62lO8Grab3Y/zgSEqy9hA4v4DU4KWWqq3nTIbsVs/u8zfRXf9sLO2juNpkTOMTew6QS/WRFbidLorWp5fiDKjuszlXldw1iBCkfO/eWd6+xKqDPGYcJYU19VDYIxTKJhwrojfwLn1ivs4RkC8oCQAu9eCwdbTkcEb2nR4KHrEtVSGkXh16SrC9mWTaz4eXd/m1bD6zGUhj5ulxSMk5jrKYzjIy3IVJn+7YumDAO61RL3Vb85sDJkm6BZkwCcqcT4RbEB08qRyevefFFcvlbULd23zUvs7cLDMyPSonwjiRhQ/9g/9cGXx3ozCcYrW8+sB0ZrqXVwfqkgOqq8sC9txnSoDym2f/UGa2S3cZWSoEE1YnohOKUxptrvielsSZcWnAzHnN3fFugRZCbSJNMvuT9KymAsJOAOLnVyxfkw4HdpbaYysmfIdY/s6FdkazEKDtm+LMQ+XSZxL38br1uw6MArzpovxi8wuAbX+JhvJWNPvRy0uU+JsyyhVx+TVVZvs4TdMyvtO78Tgf3rmLHpPdih86ytBvjWAW9EnO8E12Qz1kaJpPAjbOcEaeiartm5WkCDxADCD5Qq/C2bNS7Wjn0F+6I+cld+W3WLZFOfPaGqqsJTFa7tGEa+0fh2iq7C/LveL6hQBZPReEesqrhKoRr0BF1TYj4eHNne7DzyD+POviVaGr1/1OTRqA2kfMNTuFesmRJaMATTF+8ZpGBsNxXRfuzSwheJuLMSWBGbhaIMGUCZwLm11g9UWMIx/3iSfM5Llv2Fa5lBh85MXxDo+e48ni80ykfarn+yIjGy0AyLhCv4ie1kMq03rgBEcEMc6U2FlRcBxeGzWG3HNFk+wHBQclJxW6+5I/E6upciUWScT0zRz9Xku9xi16/UkhgbZ8l
 EAy6oqH/
 /hGdNvAy5si5CfLm/9zcxk/ubLrcm5wNY+59dJ70axmgqz1yDRJZGjZPe/gaYmjeMeXdHWK90Ja+BSjcsQcF0jg74ecAdfa7oxcqu0nLWT9/z7Xw+b4ZmKc+oAw4VBXqgqZQ44JP2pTrF1kW9lqdklxpcrC3Oz2RrgsnhcreuFvCWRjRYCDBaWKi7jEkqIM4zw3l+v4jx1UaIVKLUxkT48HeNLo0MhcO8RmxKMH95nbWmahO0pszMtaCQZnwcptr+8xSNgpWvy7XHyO8+Zx1FDvq8JZkDYF+6Kd9mn2CAzF5mHs+/KIas0QaRO49mye4cOT7BFfhr1utjxt5IXh3VbP1WWL90L2hfrY1UW0D1LFmawobFuWEapv6FU/828OYNUEhd3xAP20iQGrFXaKvZBZponMuzi8ERz0SaQLvQyxfnk4dI4afOwmnOiPeHaPqYoHY3kqBQNkGU/kXlD86up7z4ZYfZMGi6fk6vrBiNJ4daOQg5COK9ERqWnmGD83JpijDMDe/lGYNTJ2h6pbrmR1s45Dol/utwQxew
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/30/26 12:19, Muhammad Usama Anjum wrote:
> On 29/10/2026 8:32 pm, David Hildenbrand (Arm) wrote:
>> See v1 on details. TL;DR various fixes :)
>>
>> Thanks to everyone for the review! Hoping I can get some more? :)
>>
>> I am planning on picking these myself, moving them to linux-next fairly
>> soon through mm/core.git.
>>
>> ---
>> Changes in v2:
>> - "mm/memfd: check for real shmem inodes before accessing shmem state"
>>  - Call it inode_is_shmem
>> - "mm/truncate: look again if a folio left the mapping"
>>  - Different fix for truncate_inode_pages_range
>>  - Adjust description
>> - "mm/huge_memory: fix zapping migration entries for device-private THPs"
>>  - Move handling in zap_deposited_table
>> - "mm/mmu_gather: fix flushing ranges with 4 GiB or larger"
>>  - Adjust description"
>> - "mm/huge_memory: split huge PUDs when adjusting VMA boundaries"
>>  - Drop split_pud check
>> - Link to v1: https://patch.msgid.link/20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org
> I ran Fastpath, a Linux kernel performance benchmarking framework, on
> this series against mm-stable on aws-m7g.metal. (I) and (R) indicate
> statistically significant improvements and regressions, respectively.
> The results show 10 improvements and 1 regression. Other, unmarked
> percentage changes can be ignored as statistically insignificant. Hence:
> 
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>


Thanks for the results. IIUC it's schbench that shows a possible regression.

I would expect that no changes here really affect performance at all (neither
positively nor negatively).

"mm/huge_memory: fix list corruption when deferred_split_scan() races with
deferred_split_folio()" fixes locking, but I wouldn't assume that this matters
at all for this benchmark.

"fork: take mmap_lock before copying mm_struct" changes locking, but I also fail
to see how that would affect the benchmark.

Maybe some code layout changes just affect some benchmark on some machines?
Because already seeing 10 improvements makes me wonder how that could possibly be.

So I'll move forward with these fixes for now and see if we get more reports and
could identify actual problematic commits.

-- 
Cheers,

David

