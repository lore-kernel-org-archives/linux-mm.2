Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53E94606A320
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 03:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=cbLZoEP1
Received: by kanga.kvack.org (Postfix)
	id 357706B05B1; Mon, 26 Oct 2026 23:40:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32EDC6B05B2; Mon, 26 Oct 2026 23:40:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21E096B05B3; Mon, 26 Oct 2026 23:40:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE8AC6B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:40:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7DACC1208FA
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:40:35 +0000 (UTC)
X-FDA: 85367004030.20.96DBB97
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id 66C80A0005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:40:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cbLZoEP1;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.218.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793072433;
	b=8oiyKydlV+6lIGunBUelGfbc29gA/HnPWbNWfiwNmUCLEWuKgig9rEpokuCY9M4mPWmk13
	bzSYdSFO1B9eYIPGUopbRh7jT+ADzQADRrG3nO892HFXSt5YbYlwVEgtyyAcxZOXS41kXh
	lreC432v0Wl8QlFRvLz46as8SgBNtbU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cbLZoEP1;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.218.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793072433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cRzqF3pZC9T9+mgqazzI3wB0gyIKv4okDYmmTH+ci9I=;
	b=1n/fQO5H5Ub2yp5GpXYq3d3wJgEOLOYg/f25FyhOEhvq4elHAU9R8Roc0dMLNCJBFzp++l
	c4XvImqTVZnqKxueVzIKw9Xt1Sk81+S6ViFkAL9jEm4YoHvUJPfn1+w787EynxvrjBuQJZ
	4oj/gfg8/my+2jloxjktYx3klgB4qTE=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c46822eefb6so480736566b.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793072432; x=1793677232; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cRzqF3pZC9T9+mgqazzI3wB0gyIKv4okDYmmTH+ci9I=;
        b=cbLZoEP1xBdNXG/ZrrT6aVUwwARKMvqp0zbFQ1Ov2kVNPEaYkgfKY5tFUP3efraQsj
         HSf6NFzHOkyrB0YayfUe34u3NcW6fAaMhhNjl/JGHyXewK/h4wYKprsBRpZO4b2o5Q9K
         W5zHUieKo9A9CRahY53P/nWT2tA10HOsXj10O6FemQiBeJ4hGQS0t80uvCI5BPCvdOtn
         MZOsujU9908OTp6sT0mega5VqlHUaijv3mqvd7M59VT47sz47QP7Phx5XdyMg3JgB2Yu
         O5IFRoK5XsYz3kqUwAq7oDNUCYpKyl2VknN2xmoMtocr6XSK8Q/hTr20NcAB3YoDR+N/
         SO3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793072432; x=1793677232;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cRzqF3pZC9T9+mgqazzI3wB0gyIKv4okDYmmTH+ci9I=;
        b=A3BR///kigUkH4w7FyoLSP6I5ewK/wxRAK/wNMkRF7kESnZTjgVjkF5zUCgwOYLznJ
         19qSP9r+Fp+rGz4g707RsMfw9ENrPMlUwroXz773x6cVBs7M+M+3M7Ib7iMHe93bwFhF
         Pr7/xCE8GJqTKxk94u7kdMFtvxL5y6AOP6VdLQEbecFs83TatXRsDJ5VUNc5UC8rpceR
         SlciWFAZXjcAuiZvNu75CfsW8Y79FWmKB6C8ZC+8fOo/WM+wHZ0XNZk+Misi7IdsnBhp
         JyHXMT2Q3s+7OGGU21bWhTFiydfDArvuQf5SQZmGMFYpSVd62vcfJBfjIypMtGvePBHh
         N6LQ==
X-Forwarded-Encrypted: i=1; AKwUvBzbtDq3GOX2v597n37SRlio416RJVxcaOV7Qmj3P7U/4pMtaqfljCEgwD1HYj7TuEvJjqa5Wl9Z5g==@kvack.org
X-Gm-Message-State: AFq9FYLbIvUPYYnkHJWn3OUmyoGlvjRy6ydLkILFGKzqp8I/4bvuLYZx
	+4NPl9VBoIQ91ISLC229cyOugjQuTiaeYAjG6ljIe+anudP7CsCs0lDYs7o/VKHusHE=
X-Gm-Gg: AYBFou3guRv+ZPJweqHhGyP9zszjEu8EJArKFOEfvL0JzQGMXwxUYtR7yTOBnEpUN2G
	ifTu5+EVVkuwG0wtGv+RswtFMEdWIdidR7SQTh2qdAfGoA4DTo33Ve5DzpKD+lfS35J4RMUOo8L
	HQT9MWLY1aYhMxxTqNmAOU17+UTVzdX/2S29LHCelvmAJhJ0R7xZIHMuizKwyzYdu1/8TdE288V
	Fstrl9EHVnyduM3sWfRC5Fu0AG4r80Bus6uZaP2Gk8lA71UUFskw6QbmnVaQiLj589AF9YEeyrn
	UJNHVYYL/oOFbyjW4vkHLpFjtgnM2uZitFEoVOkHet1MHJyZUuPFG/pCfblq0zieWVXnTVU82H2
	89fpAsRI5p5dnzD0gwAQDEwIQUHKmNFMQzGle8GoT3GxfcKOCZdJLd2J3zlGY16+rEOP8Dq885c
	ixmNnFHAYJ2rcMnCq3WvsJCUpxkQzCLI/dLEzz8whEdg4vo4WXDDUyRchWfH/kzXN4qhThHtISY
	ITutTKm30zLm1xUsOAtPt+9A2xwgRWFP/ozjkuJaCVTDg==
X-Received: by 2002:a17:907:971e:b0:c46:723d:600 with SMTP id a640c23a62f3a-c46bde9f783mr916491966b.41.1793072431944;
        Mon, 26 Oct 2026 20:40:31 -0700 (PDT)
Received: from localhost ([2a03:2880:32ff:3::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd4e784esm379153566b.19.2026.10.26.20.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 20:40:29 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 26/46] mm/mmu_gather: fix flushing ranges with 4 GiB or
 larger
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
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
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 stable@vger.kernel.org
In-Reply-To: <20261027-fixes_core-v1-26-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-26-6f74bec9a5bb@kernel.org>
Date: Mon, 26 Oct 2026 20:40:28 -0700
Message-Id: <179307242835.1171062.11616590599815003560.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: gorqmokmcto1yzz5tzu3tqq7x7i9ds5f
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 66C80A0005
X-Rspam-User: 
X-HE-Tag: 1793072433-367145
X-HE-Meta: U2FsdGVkX19QHhQ2MXJ/kGx6jIftUC9vL0DwhKXqlnMUhBKjkOyzXIYPYOTATCQiuScMtDeoOuSvh/6yva3hVGttNvhFPOwPt+EUQCZS/E3dXtcZD4A/w6LlJHtNZNZdXOxcjPIDWZmbDbfZnZdfPXeqZCLpGulJJMQ0c5A4rSSfTMoZo7fhxo6wGvq9oktVuM2Rm5TjbNRhK2M+pG42xcRlUNpoaIIFoNZ8T5Y0XmPktHsP58Ownpuo7LEuD1WeYSK/4gu60Xb0tuA06vBDDitGP20IjEwVPBU/+GFu/1mlo2e6denM4VFJny4tYZEm6oNSYoaBqBOb3dJRQtw67amVwlnrv/r6g6QhCmr1MTgZ5NLHWwHPCQwpSlGldpzHRGX8VDsr0dJm3jo2zkeuUlbh1PuDsdg8U1lR5y3O9A5Snkbc9ZoL6wOCEAJAVNuNLwYEe42zYeK5xIbHXId/wMiNc9PM2V2S2iCi0Zw5nhQYOivSagUzPYuGEVKGsbjJmhhStXqm5zQbdZml/Tm5wQRDGTMlNH9PLxWhGrNNIw2oNlxqy96wJTCzE8lp6dVBmqT33y5pIWSGDqur6gbNQXoZ3nUFF6EfA/+YMatOz+IlzFxOKEYRSSZFWJwNtnsIn0n8tE6f470YSsJiLJkGk54rIZ33IBFtjV3SCv9Q58uSk2Fd0Lj1VbQ3pvJ1DSYXykobk+pis0Y+rsVE4lNj6MoK0pUBWTc2D8keUaLmlE8qx+NqoPHZwi8VR8lc25nw5O+srw500F0ssevQUeOm0mstg7aeFgS/TdNhiefubu1nsO1cWkhy4FWch4MpCw01V6BstA7hZpGe3LtV1ClQAxS6fZAvT+v1LYd86du17NNg2bZZcxImJtbtTYld4jIoPmkd3sWcqUqsX8OmejhVwIsEeflsNTC06uefx9qUpckifOoXTrgRRmCcc6GgvjrmlzsWN7K2MX8zfgBi5tm
 wbnIvfXR
 H4A477oNP8DK5y9LqkJ7AjBILKnTjhmL+8qFfSpnxrwOFYsimSf7gglUcNr/1RdZOTbmLWAkSrwR3Njqzv1e4kRwo9zfjWAJ24UeALpAuwKUditNvVMBUfokaWyb7Mou6V/M5gVeoOTr3VYH2B/xTGgvE2e3p5uA6fZ8ZOB0m9jTl81x/Irs3eg6S1P2fPqEHmlOpIy+ddKxwhD8jM6hMFaEQbom8GSaHX1abAs9O+fk7AQSuqYMyaTU1aNU8Y3t1jspRA3XsHS2ug4rBSVJQSuEG/2ERR2xTVx3Bpbe5GEPQEV4nTU0qcBbEV+SGcQqiOc5a4OAC8BjLQfi6iLo8UNkKLgERS699Hkt3XwpZDr9+Ob+BwaYmWMoHQYUq1bS/Gbs9V28d3n0VLyjckEXmSNmp466/6CVKIjnxZw7CjkzJvbwh5+hgFhpYKHZj3q6ypjUaiDZALLQp4/EFcdBP34fjYvq/rd5nICjl4nwzzVPJqQJY6TzVtaMSmUY41CJhOoncVY56KbqLotmgqMHrek5Y3Wyi2kNHQ+bP8xDQl6890k7CVvjzAWPOn86J3S/VI/YY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 00:17 +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> __tlb_adjust_range() takes the size of the range which has to be flushed
> as an unsigned int. Its callers, tlb_flush_{pte,pmd,pud,p4d}_range(), get
> and pass an unsigned long. Consequently, a range that is 4 GiB or larger
> gets truncated, possibly to 0.
> 
> On arm64 with hugetlb, a 64k kernel can flush 16 GiB hugetlb PMDs, and a
> 16k kernel can flush 64 GiB PUDs through tlb_unshare_pmd_ptdesc(). So
> at least these two scenarios are affected.
> 
> Fix it by flushing the proper range instead of the truncated one.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: b528e4b6405b ("mm/hugetlb: add tlb_remove_hugetlb_entry for handling hugetlb pages")
> Fixes: 8ce720d5bd91 ("mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> [ david: use two-tab indent, simplify description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
Gregory Price <gourry@gourry.net>

