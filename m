Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6E27606A330
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 22:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dRWUklhy
Received: by kanga.kvack.org (Postfix)
	id B662B6B0604; Wed, 18 Nov 2026 17:35:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEA686B0605; Wed, 18 Nov 2026 17:35:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98A286B0606; Wed, 18 Nov 2026 17:35:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58FFB6B0604
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:35:14 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7BB1C08C3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:35:13 +0000 (UTC)
X-FDA: 85449696906.02.98CE747
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id 00A7420002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:35:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dRWUklhy;
	spf=pass (imf13.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795041312;
	b=M2UoJnnkKCPJPrMrDcQgefwCG9Xhqk/6Y4MPWPX9zdkVeMGftBcbHZ8AABT6ea770JasUK
	MYq9qtB3T7Cj9ZiriIU0T5ak4cHtkT4nUzjQVJ4o0fAgvOJyAbUp3LPI1Fbsh2BYEXV9iF
	82kSNZlS/vN1miifPVf7vLkHLHkmReM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795041312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+wEj8CWquloqUtruK2jACBvwnRpGsJYik9FeeinA1ng=;
	b=XMFAni3itkHuZQyXHkr/OufutEw7mtmRTO9cDzF+NoogtVjp1Xu7tM0atz00AjHCsY60Ni
	0nsfxhXnV/Ccc5GPm1jaOGJVOt02iErPjuqikr3i1jBWv6j3c99tUR7unAZyXYC5vHoEKg
	dhZuSPnsypPsiKo0TWXi3YrvUARlk0g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dRWUklhy;
	spf=pass (imf13.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so16587255e9.3
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795041310; x=1795646110; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+wEj8CWquloqUtruK2jACBvwnRpGsJYik9FeeinA1ng=;
        b=dRWUklhyXJ6QMWwLx51d3qwAKJgKphdKgx8bSURG+PPr0/ueZlwas+G5UJFjs68MK8
         N+KGxfCWlkbtcPLQOGOkKvqKIoqO9bYVGjvmgdjT5Q+nD1jcHOkHirS6e3L7mftSQeoX
         SqcTsdfYRBcAk2BifIkhx1qdLGAHD/ngP3Q7fhu0WdGNaq1YZb36yyHu92Ggaab2Hoow
         gi+bJUSUVTmJ9t4z/uyj+iNwsR/SorNWcsv3bOxvrqNwDjH+ru7uiqdMYMlt+rxW1ykQ
         36ORodOxbxI0xcP9okZEp9V4W8OhWTzTj3NbxVGpedMtu1NeFJOV2e2nvTPYJqGXFVQT
         KCRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795041311; x=1795646111;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+wEj8CWquloqUtruK2jACBvwnRpGsJYik9FeeinA1ng=;
        b=xTSnht3M1CwhQjPpjGSNnhPqBKWG4+avMmOZn/s0gmZEPDazR0s8gVU/Om3AHaES8s
         TjVNwm+9idbRAklCQ4BmOq9SLgo/tXro567pAFKT9aQIBGGSMecl8w8KFq+C0Vxjpj6m
         zOV7dn+xKPaUsk2ZslXaCQb6epHioynSSN8onAodFPp056My++2dd9S8kmGY1vxpBqrA
         ciS74o8Cuju8DyHGNlX5p950PrhwjwbpbwYWxM5GkBL7TzjTwDlLd6RhyVEeHbP6+EjA
         uEZR45aOuZVApI/qQClVkNn0rv9jGVwD0jIJXFw0Q7b3cMVv5BfF79dUydesaGdxRzct
         /YxQ==
X-Gm-Message-State: APuU4Z9LD9Q8CvLdIJHDMQcRzykG1F6uqo62sLNWQbRkG1g2o1DvU5qb
	pChp7KEXk96yathilbEEx5BBlPtiIn3CAbjzzA8VLBZrVx3NmlPCnKoX
X-Gm-Gg: AYBFou3QPpECbY+a+XYgkXfdbJ0vGje2lE5gLvTtCcmAP5dl2aoqdzh1Dx3zJwDefsX
	PZGv1lOwnnwWY3v6Aup9Pz+dAD9+/c+CCqIU64d21rU2nIMct71MRzRAHZhvZ5CIZnv6B3WYBfz
	5VpObkZiXKYNHyDBQNcwiWkpwwSMrmbYyGTAZneZa34rc9VXqaa1W3Z8yuCx8nb3QhH8uAi4C+1
	/WMrCaeJ0BeeTAjbs8b+tdoLbWvb/nVPjm9N+/17owi0eX/h6M/2wTb0lYZ7U+rzhrorrvLw4/M
	+xJ1AyFM1ODyI2p8GLJR+2C2hnoMeIi7IDMMm8jL3A6lXZEBy5GSPMAqhHMLKfIZ4aoC6s4E1Qf
	LjLov4ojWfkxec+xw1Dzc7EJGpplbY3KaMncul/9JPgFjNOrzV1zvCdmiMUUW2aUXdS3kSXS5V8
	HTvn4+uOs5CGX6a9IKoqScxpJRWruiCo1yXiXv10TpMNEQqElgSDCLTZFmaZiDMz4wsx6S+O8Zp
	IebvUVvi3ky9tP1WVKlvaCPglomjwO0OOoYet0O4H7e5/slK0PaUcB/FLavMQHY5Wf41w5f2Ecl
	z2b0b9MqoBi5NHDCkWIjnftCA0PxTJSRti618BBdJ7t+FA==
X-Received: by 2002:a05:600c:4e92:b0:4bb:6a2d:b440 with SMTP id 5b1f17b1804b1-4bb7d6d1df0mr87283275e9.2.1795041310455;
        Wed, 18 Nov 2026 14:35:10 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb845223b8sm2954135e9.12.2026.11.18.14.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 14:35:10 -0800 (PST)
Message-ID: <e0a946fa-19bb-41fe-adbf-8ead08009ab9@gmail.com>
Date: Wed, 18 Nov 2026 23:35:07 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm: flush stale TLB entries before installing a
 CoW'ed folio
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, "Borislav Petkov (AMD)" <bp@alien8.de>,
 =?UTF-8?Q?Cenk_Y=C4=B1lmaz?= <cenk@deepfinresearch.com>,
 Zhang Peng <zippermonkey@icloud.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Mel Gorman <mgorman@suse.de>,
 Sasha Levin <sasha.levin@oracle.com>, Rik van Riel <riel@redhat.com>,
 Ingo Molnar <mingo@kernel.org>, Peter Xu <peterx@redhat.com>,
 Hugh Dickins <hughd@google.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261118-file_folio_flush-v1-0-e9e739ed14e0@kernel.org>
 <20261118-file_folio_flush-v1-1-e9e739ed14e0@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261118-file_folio_flush-v1-1-e9e739ed14e0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 00A7420002
X-Rspam-User:
X-Stat-Signature: zrq7s53ie8mkfs4arh11cr7kd9iosmiq
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795041311-414545
X-HE-Meta: U2FsdGVkX1+HS6huwScA6QXobEOXfrzGYGePBbzq1qx5LkwwOjgmX//k3g/iyMICjZ6nr5SRuT61oJkOxewP+cTwYewxcWTZyL/kbmxkHELoejOsWzSCGPdkPIuMR+75nqmUPd1McOvuZ8+1W9/zDtjQtUVO2mukzoSVg5890hBO5SWD7AbwAIw2vPH0bUjdtBOTTyKEo70HCIhx9WUYAW6iEUsl94ZNH6t/tcDi3dzsxoaFN8ImJNdkRpZOOQBukjb/baUEBp0I1KbuXdrNY8buK5VB2uMoWuddJohsqauQJUaSCpEk3x5ZY2rLBP5+/PqEkxUqRrp+7EqVl1KndXKwzoQCw0tLFmHkJDx70lcYTTjC4CFICX4NxvGV+WZD59BwX2fgtq5xBTEKs8lVeuItpIs2sUPGRvcX3XUpzS//XqdFC4Y0TO/FJOwmpGwaAAo6CNOvjACGBiRcyGbOlYb5tpTxxpl4lmyfmbCBickVxcbXdbcsYcKAupT3MkCZHTAbAlcG7AnV8on3LBeM7ynxNhnU6lfuodsmOZD4Y0YkMM9wvncngPNKTIqFTZDtA4oMUSRlPrlP1gqNi4yRuYiIlaGThJEHCbp/zSVsArk+yEzEG0SHrpeyMyei4mHYwWC6/jIl/NsI+4vYf7eGtqHiBenSdifQfTjTotcMc5IhYzpXd3PQOwcUMJT76n9xazf7EH72i6pmB7iSPIe9xsjeCkgmNHH5UMdIw2pcDPjVNalpArEWY9eMUT88gPD55mTqz6z5kzjptKUTp9kGcKx5OwkNlvjC580qadL4j9GVfv/0zkI6TzVpZtyWhsZ1lYccev604MGhyQZ31g3JFRbUSOxWwhHjDlpr2RRo9vOQa6rqF7E1YiWNAkjueV1iQUWOGcHzWO9vVz7CNw5AHBs7J/r/OTVbp4Jh+5kmbJyx+1Oql5ceG+9dz0ee8Yd2dwZmhfJsyGP946bUfFu
 kFdJ4XoV
 0XL0++dpnzed7Mc0VKNxj+51Y0JRMRHCmmc45BM3sXYY7eqeS9uNUq5lQe+Y1a0F8qNDblHx1XLI/vu1lOnG0RlIBCtRrOiPNFXIv+UDmQ330lVFgKzvRpyF9Zpq6cPs1/LhRIuBW8CV2OVokY3KrfUjIMkVx/RU/5N5TJfzskB/9Z5mcL0HS1D5r/5vaE4DqDA28OKTqm8tiuczi7wY8E5eXXnbV3fLwVXDrFnrU97F56i/FhdnBZCDTno7cvzoczJobLho7gXVVqPtPphPGDQQhOPjXgjZmHfLKN5I92CoC3J09I/VFa29feSVA/0hKtdeO0g/YDqbPVcbdeLd1PhfVyuCUqz2qVa+I0/mDKQGQBgnYxSojo1tolSRcIWT11DQidRPwOxlH9GdvjaYPqJBwBDfupUoJsdXeaRDIFxMm1lc9tFrSkjLYkFSNz1Wv/5RvPnzLC8mEcka0WV1GEVt8r1eMXm7KVZhH6NJSBhcHOyevZZZeZNIp9D0zU7GDuAgDXdn32PsEy9gvzgcwqrway3YpcMER/4yvNyGFLnNx2gFB6UOLtJBpwr5NdNRpxcotppmmwnwV8NYzwl0QtKtcXx5BnxJUjUdsRLHoWc51GV8e6s7hXS62tBozU0VMIEzEbwXGV6o+47YKS1eMIw04MN7BrBQhskXM6azErWk1b96Suah5jhZWjGanncvd253CsuNXo4VBWnbhukX6i84UeZESt1SxAMaGZZ68zYgsjQhpnEv2PC7OfTY6hEb4DYKaixd22upcFcb1To6k7Nkflug5ra9wgEsg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 10:20 AM, David Hildenbrand (Arm) wrote:
> Zapping PTEs in zap_pte_range() defers the TLB flush until after dropping
> the PTL for clean page-cache folios.
> 
> A concurrent write fault in a MAP_PRIVATE mapping can then CoW the
> page-cache folio and install a new anon folio without a prior TLB
> flush:
> 
> 	CPU0				CPU1
> 	LOAD(ADDR)
> 	 -> #PF
> 	    installs R/O PTE -> A
> 					fuse_open()
> 					 -> invalidate_inode_pages2()
> 					    -> zap_pte_range()
> 					       clears R/O PTE
> 					       // delayed flush
> 	// Other CPUs (incl CPU0) still cache ADDR -> A
> 	STORE(ADDR)
> 	 -> #PF
> 	    do_cow_fault()
> 	    copies A to B, installs R/W PTE -> B
> 	    // no TLB flush: PTE was none
> 
> CPUs with stale TLB entries will still read from the old folio while writes
> go to the new folio, until the TLB is flushed.
> 
> We really must process pending TLB flushes if we are not faulting the
> same folio back in.
> 
> Fix it by flushing the TLB before installing an anon (CoW'ed) folio in
> set_pte_range() if a TLB flush is pending. Zapping itself stays as fast
> as before.
> 
> Other faults are not affected: unmap_mapping_*() users only remove
> folios from the page-cache after their own TLB flush, so until then, a
> refault maps the same folio again. The exception is a concurrent
> invalidation that removes the already-unmapped folio from the
> page-cache before the zapper flushed the TLB; that is an unlikely corner
> case that we'll not handle for now.
> 
> Note that we don't care about MADV_DONTNEED followed by a new read
> fault, as MADV_DONTNEED only guarantees its semantics once the operation
> completed. CoW faults will flush the TLB either way.
> 
> For example, imagine that MADV_DONTNEED zaps a page-cache folio and
> doesn't flush the TLB (but still holds a reference). If the page-cache
> replaces the folio, a new read fault might map the new folio without
> flushing the TLB. That's okay, as MADV_DONTNEED did not complete yet.
> Same applies to MADV_DONTNEED of CoW'ed folios when re-faulting the
> page-cache folio.
> 
> Memory reclaim, which removes folios from the page-cache before performing
> its own batched TLB flush, will be handled separately.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Cenk Yılmaz <cenk@deepfinresearch.com>
> Debugged-by: Cenk Yılmaz <cenk@deepfinresearch.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

