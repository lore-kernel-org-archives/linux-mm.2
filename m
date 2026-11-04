Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85B156083612
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 15:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NwrHw1Lp
Received: by kanga.kvack.org (Postfix)
	id 907196B05B1; Wed,  4 Nov 2026 10:16:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DEAB6B05B3; Wed,  4 Nov 2026 10:16:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81C406B05B4; Wed,  4 Nov 2026 10:16:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 621936B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:16:12 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E775B120724
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:16:11 +0000 (UTC)
X-FDA: 85397787342.19.EC3BC17
Received: from mta1.migadu.com (out-15.mta1.migadu.com [95.215.58.15])
	by imf31.hostedemail.com (Postfix) with ESMTP id E1D1720008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:16:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NwrHw1Lp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.15 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793805370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2QP5qMLgCjzR3Vq+1R7yHnSJoapXAZoBlu3K14T4Qag=;
	b=CqcmQpK5fM98qtdIMSKBbbDP/qT+4RZQH/7HIjZS6plr+Cu72wuUxl+KWP0n7y+lhdlypr
	KqUvml+ur4qttsbKvzXGEYeis3gYqouvPo6AxzmH4wfYccoIc9MHNDblPLeZKL6YqyfIf5
	wF7U2viLx6mDXhQzGBNdvS1trqsBAJw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NwrHw1Lp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.15 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793805370;
	b=p9nk/5b5zfXrhH2NoMSXvSz+cmgbVOs2CvgOGEE41gn1Gl2BvVnI5eaYHr9UJeNkwrHctd
	JZvOJxn2+XCEpor9D1/iwRBoTJIex57atuAmy8yrB7QtXXgh0l+bjkIEx1cN3QFvlElWOc
	ebBnT3AXzvet8gLCBjKg0YLKVPWy/XU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Y5MODlRDl3QiqtxOx5uVZzRjMa3zrlbQrFa1R/TJtnc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793805368; v=1; x=1794410168;
 b=NwrHw1LpmsBIwswo5wKeYjRD/cJXqjYbwgfklMVriQ9oURLjlDTfl/zLggxdnvTYym/OnKq1
 0ax6B6z/14WfVvEc4TcGopfGKXxJiVbo00QdorFvXj0s8F/6G2IoPSpEn0xuxlFtmrdc2kI90p5
 JXzmGZYYZB9EOGWk8F536pXA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b99bb3eec717c0ce;
	Wed, 04 Nov 2026 15:16:07 +0000
X-Mizu-Trace-ID: b99bb3eec717c0ce
X-Migadu-Flow: FLOW_OUT
Message-ID: <bb136360-bbeb-41e2-9dc3-96d783e6dc81@linux.dev>
Date: Wed, 4 Nov 2026 23:15:36 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 43/47] mm/huge_memory: split huge PUDs when adjusting
 VMA boundaries
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org,
 kasong@tencent.com, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev,
 baolin.wang@linux.alibaba.com, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, kees@kernel.org,
 peterz@infradead.org, jannh@google.com, pfalcato@suse.de, hughd@google.com,
 pasha.tatashin@soleen.com, pratyush@kernel.org, willy@infradead.org,
 jack@suse.cz, ziy@nvidia.com, riel@surriel.com, harry@kernel.org,
 apopple@nvidia.com, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, usama.arif@linux.dev, kas@kernel.org,
 matthew.brost@intel.com, jhubbard@nvidia.com, peterx@redhat.com,
 will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 osalvador@suse.de, minchan@kernel.org, muchun.song@linux.dev,
 xu.xin@linux.dev, chengming.zhou@linux.dev, chrisl@kernel.org,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, youngjun.park@lge.com,
 gourry@gourry.net, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 ying.huang@linux.alibaba.com, jgg@ziepe.ca, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org, stable@vger.kernel.org, usama.anjum@arm.com
References: <20261031-fixes_core-v3-43-d6437171ecc3@kernel.org>
 <20261104031245.9524-1-lance.yang@linux.dev>
 <45508a75-7549-40e2-a71a-807a824ea026@kernel.org>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <45508a75-7549-40e2-a71a-807a824ea026@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E1D1720008
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: xeuqhfgx134whz6d4ctme7pffjjrjm87
X-HE-Tag: 1793805370-707039
X-HE-Meta: U2FsdGVkX19Jgb4twfaeGO8q8xRySCgpqyQ+2IXZJp9PVT1WDyLAJr6kahhBRhoenWFahIkZpsPJOZJNgSP/GZnKLyaMkc5duWTo0uAzQVnVGP8X7KerHnVbJxe27/6K/XQQDIMXbcvEK76eZ7lbjseejF2BxiTxo+izd1cI9memVkQqHqyVHgL9G7i5Rc/jCkNploaxKrsaJ6XoYMkCqv3dEIUBFOKOn75v7IPQAaRhYoxfdJfKH7FIDrn3XKFcWXL407imgPhT4TyS/8+nZlMqftzgPuAJRrVcueupRJDcnUC7VLeikViSe773lqp0ZZwKG/C+r+FpRN2zLmLiKlf6yhKUyTTh9eURDj7OnMPIgppM4fShHJQkJ+fquI2KLHdbY9JxnW+VN8PrjQ3WCaQGnVfS1oE7lUKGV5NLXqwY+SfgJQz+6+xH2QESm10x/2Yd/1An/MXeYcXh2cK/rfFtAUNyqlZDLwILC2UneGPFh8nm7eY3XaPniHgPH2z7mfCh+qVMw0KIrOUrW6sx1QA378XwU68V994BlzvfAPttgjExqZK/kDeQ0q341S6R4IU+1bzKRfMpXXnP4liuBo3y4rH7py7+WmEjZ5oc+p2334D1X6gRNFUV+t7PtayD7HeipO1volp3ynGtT9r1NFJ1Wma/wM1K0mTcaAxewUdteoY88v7dGL35W6qzZo2xh4vlF3CePxLPbwZuk4YHUSBl6LhlTfs6U8gCoeYf2386yyU862t2KrksejkYW/7J2zsio0dchDld9C3kGWgiCGeIdyZWkFCyxpl/XB6x3TbL+858pisr1RSwdRE5KC7OioyhzOC036jHnq5Tcx+7+a7oONSrAy6ObMHpkwJteOUZ6rlvdnZYmlip+ASgs5pLP+QvwxDDl5KO0We5u6p4M815LwTu0Ogn7svR81YQQ3XR/HPvcNs3WUvZprtm8ES+tPp9vbHNmI/HBSG+jyG
 aTh+tgeO
 /sRqwDx1pdI9B3w26zvKz482hk4jN8t+zEdIniVZrIFLdivxPxb/EktKIEGqKBP1ELY1qle3yiY5AXfDL+vH5ScF9w6yVIsqX6so+6MiVPKZFIUeDfYT+6KbdGopKfnsa+/Fq1Xw0UJyGtKXAblhMPjFZ8T7F9LnTKtwvlCkYeMz9z0/65fkla8UwVAMxeXaPXZ8F+GConkzieeEazsZJiQamLHvkwYsyI/JcHw6FQWLob1NqeX0ZJkfXTkS77MgYRID22T9r4kNa+o78EelAqdLL3+vWWHpWpAhZO2jw38a+OuSJX8PqlCnw8puCBNX5sbZmzl1LA2xLbHyF3Vz0IHTPzwaGX1GK+SDms536yHWoFVooH4caxDjGmLi3zFymi7W2CRH8Ysj9a6g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/4 17:11, David Hildenbrand (Arm) wrote:
> 
> Thanks for the review! Please do keep reviewing, but note that more trailers
> (including this one) will likely not make it upstream as I am about to prepare
> the PR to get most of these things here upstream.

All good, no big deal :D

Cheers, Lance

