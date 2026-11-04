Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 509AC606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bPUGyJe8
Received: by kanga.kvack.org (Postfix)
	id 6B4A46B05B4; Wed,  4 Nov 2026 04:11:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640636B05B5; Wed,  4 Nov 2026 04:11:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536586B05B6; Wed,  4 Nov 2026 04:11:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D5666B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:11:35 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C10331A0595
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:11:34 +0000 (UTC)
X-FDA: 85396868508.12.D74DCC3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id EE64A140005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:11:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bPUGyJe8;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793783493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+BWGMpp+CGdBx3er7fkKiPSgFKGZi9UN3j89ZX4ZK/I=;
	b=q3aGlrvGLDT4gOT7yaK3FTB2dmGFIngVnlqiU6kMZ0WF6eB150fd4+w96x3hZxbdtzz5tW
	743sp+DhFKJs9W7uksqlqFJMuYit7rcPYW8DxyiKp8k3+Z4X7OSo7BH0JUIGZjKckKYsoV
	7GrNg4tWTth9kNAYKSsB6r1ACe1QJyo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793783493;
	b=13dDsYRXkdv6DuyIqacGhJfYaYxZCL/tbPwBSKAKDnW5DcaJLgkjSARekYiLlD8HlkwJ6i
	sbR/FOcPf66Qe8mrFBU0Bqbgal7Y/B3/zUyiddNA7C76bZraltVsgwa2iOTG4rWulA/43o
	QTquJzrWEBzt14Qtx9lLCAqvYEl0f1E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bPUGyJe8;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1794D431CE;
	Wed,  4 Nov 2026 09:11:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4141F00A16;
	Wed,  4 Nov 2026 09:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793783492;
	bh=+BWGMpp+CGdBx3er7fkKiPSgFKGZi9UN3j89ZX4ZK/I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bPUGyJe8jTsIlbF1xVTN5nX4l/yeQqqr6KUSLqOk5CwA8zaane6up/uXHy/A6ETFN
	 8GMdYQkC/9pvmhBP2zcSqtRvRTHOksDMwvx7gtNR3V/dSa5XbcrFjusMb5bbHlPAqY
	 FtbHm8MMjkmKP//Sey/LKddohMLPyRf4C7s+5IntPmGQ+G5m0rp18ZxLjCBmoTbsqX
	 6+sBf9cofe3crMJ9E65oq/xyI3vlQ9WK8JdqiYXb7nE+wHWgrx4QfKgjh+C53e4xEw
	 hQtZGro3VXx5kNioH4KUnh6d9IwsWjAmh0kD1m7YN8VI3LyBQcu4wnCHz5d6QOS+Jm
	 8qsGDtkKaCKQw==
Message-ID: <45508a75-7549-40e2-a71a-807a824ea026@kernel.org>
Date: Wed, 4 Nov 2026 10:11:14 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 43/47] mm/huge_memory: split huge PUDs when adjusting
 VMA boundaries
To: Lance Yang <lance.yang@linux.dev>
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261104031245.9524-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: tfdjnt6a1g97ze56f71mu6o5bh3f3u76
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: EE64A140005
X-Rspam-User: 
X-HE-Tag: 1793783492-137734
X-HE-Meta: U2FsdGVkX18L79L6qSnw17etn5mGk4QDhLvurqOCED219PGV2+zcI3NqNp2jb+msnP7lVoq1YTTEakXSPk0VX1xNeclwVzo5C3Xs8y02Z0SwybmFZGZwZNmZpFj+Mfpmxz+HOUEefs7jkg7s+ILQryrN+u/v23C8uaT3RsTh7xgO894FgdPOTH2SNxL6+HsiwgWO14ivUZX9Rwbgj/cUnPBhkxEo10LCONeB/T75pemrEg8hwQj0hT/a7gxmtSufLRoNBpnjzGXWnZbRxUUNRMH0PBrOCZ4+6RLZb3Ntwren9Mbf+9ktZaDzeCsQ86tQNh6cH400gFk1rMnD5ZtuYy2i9Ij31dxJqLBP7Vgizn66q8xLE29jSi6YtlrHZOvvoX4nX/G541zT4dlkS5Fw0CQjOarre9CkkM4M9kCNN6J/T+F1VvQpKuaEF9nawhlq0t/PNdMh8YeeZAAONNqGdBYK/H/IArtOXJRnGrczi7m5lDpF312uEW4AGUVdZjTij7Duh3zbbH3EN1+ssdTxX5vIhFJMvhWXzbq6O+0JkZogTjTvY+V9345VJoWITE30coA7axjD8d0s8N/ITmaLWOVnw9674is2BYD/7Xp/KCoG5jPmbXPgIjY/Cfv9F1C3rQeNSk8E/TqYWSYR4t+IYo69udohB88XtY0gIN+lxT6fWYWarfIkLU5AOffcY+moXhpm+k2xiqt7I4g5IXDaZ7uwc2N+2ZlUP4nVIFJ47C8m+yBZixtoV34Ah97KZ9Bxte+Qhtzuxk+PGh00wwGJtbeaby70ni33wANgAJR8MeXfR6MxmPX2nJONlYs0gBgp72S0M8bKKIw57HoioRFyMIsrafgdtJ1PkM/iKIW1d+gj+NrHYETHKvz+U+l53S81BFZoj2SyhYUPSaivC+dGggFqj48fynD50BMRZGEIlmK3lR9nk/zcoYyV3z8NfKN0wY3Kb0i+Sc1Qdu4DCJE
 ltd5J8Ml
 IpcPgklm4co7zpkw/jAHEJpE2eWYheWFwqvjBEN7d8BDCruEusCQg5zW6ql7DgUu73bryt0mVCEPvaeY5W6Cyf4F16DNPodYyqfROXj/Vuvi8ePHRo8Yj0v9qtdlnWNDJPrVMM8ULSurJuHRN/7+7psU8TXjrGZlLFZKpFDZdR98ZVjG2TGKM9d/ps4vunlYH0/tk4vU2VhzsOLRkcEqnT0+r/lKhTLTgLRClFV/HFQEgYzomEluLGds9IgVOsK1gT1dSSx0QKyxhFMNMl18DlJRNpsyz3z7VoR2MbMdaip8xc1gZ81waCJbpbkCQ7BNL8Cs5ev3vXHEawfDokohGOKmadQG8SUM2M9R6vCZI4LwsWg7HiuWalls3+C2vRO4lF2nUhZeSVzdi8ROSDKW5NIdoX1r15hR3lM02LcweWAoDWB7zjc7F6DjEnBMY3n2dXlVKCci12W/13nu2PYjeabnfBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 04:12, Lance Yang wrote:
> 
> On Sat, Oct 31, 2026 at 10:40:12AM +0100, David Hildenbrand (Arm) wrote:
>> PFN mappings such as VFIO PCI BAR mappings can use PUD leaves while
>> allowing VMA splits at page granularity. However, vma_adjust_trans_huge()
>> only handles PMDs.
>>
>> After faulting a writable PUD-sized VFIO BAR mapping, changing its first
>> page to read-only with mprotect() makes the PMD walk treat the PUD leaf
>> as a PMD table. Applying MADV_DONTFORK to the first PMD-sized chunk leaves
>> the PUD spanning two VMAs: the PMD-aligned boundary skips splitting.
>>
>> Walk the page tables once at each adjusted boundary and split a huge
>> PUD or PMD leaf as needed. Handle PUD leaves even when the boundary is
>> PMD-aligned.
>>
>> Fixes: f9e54c3a2f5b7 ("vfio/pci: implement huge_fault support")
>> Cc: stable@vger.kernel.org
>> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
> 
> Nice work!
> 
> Reviewed-by: Lance Yang <lance.yang@linux.dev>

Thanks for the review! Please do keep reviewing, but note that more trailers
(including this one) will likely not make it upstream as I am about to prepare
the PR to get most of these things here upstream.

-- 
Cheers,

David

