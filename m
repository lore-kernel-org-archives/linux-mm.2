Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D95FCA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 13:46:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E9F96B0088; Tue,  6 Oct 2026 09:46:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 372A66B008C; Tue,  6 Oct 2026 09:46:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 262216B0092; Tue,  6 Oct 2026 09:46:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1AFB6B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:46:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 61CECA658F
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 13:46:36 +0000 (UTC)
X-FDA: 85292326392.24.EDF2918
Received: from mta0.migadu.com (out-145.mta0.migadu.com [91.218.175.145])
	by imf29.hostedemail.com (Postfix) with ESMTP id 25D7E120003
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 13:46:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Um6iDmuT;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.145 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791294394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1UA5ViZwh+AMiYx1WODFX8ijwQvDqiVrksKT8vqWtlY=;
	b=Y9qtf582N3UoF5z97LQbu4zj3mzo1oYmFQ5luO/BaCvpzXf3oRMzdcTbrdO26xVu1DHF+n
	eSiLzOijX58lmt3X0T6M8DTfcUtFBu/Bx6+1GwRtLotTknRVQicXR+QlQ41+j8KuzSa4Ax
	ghKVGY2KEDDddHsN/NTQCUcjnFTLvuI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791294394;
	b=Pdo7SFqHithBOlBkGE8YB8Jj3kKfhKMswpETB0UdGdt3ygIr5yEqq/wb1Lyh6/IvzZ2zuT
	9ntQn+UVyeynGJUXw/Q0rYfplYem0K52a4mxn+wDt44bXMBKj6K1wwDsQMDuHfwlfZVdok
	T3Y2cqMvhMqvchVSMtSkffzNSFp3JbM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Um6iDmuT;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.145 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=elGqjdWdC+eBF71MIvDlDCg/ZVnJPkrJ/dgpbbfueek=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791294392; v=1; x=1791899192;
 b=Um6iDmuTqgLjiyNgPNFb1tUrVCbWzkiRsbKDeHYXEsbGlEv4/2e9R5O+PRqTlXLsS/wsuGH6
 FMg7G/DcnRBqfeFd7d8+Aq7zvNU1YkmEQ6bxLeIwh5K6LvuIC8oxnxlUZ7m6LPhQvzYEiRIopZR
 BICpRM+i9Pa2O1M0Nh/0gK9Y=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a96366a333f7c277;
	Tue, 06 Oct 2026 13:46:32 +0000
X-Mizu-Trace-ID: a96366a333f7c277
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] mm/hugetlb_cma: remove two unused include files
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261005142040.675204-1-lienze@kylinos.cn>
Date: Tue, 6 Oct 2026 15:46:21 +0200
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 enze.li@gmx.com
Content-Transfer-Encoding: 7bit
Message-Id: <BD7EEACA-71CE-4919-B60B-5767EDFE035C@linux.dev>
References: <20261005142040.675204-1-lienze@kylinos.cn>
To: Enze Li <lienze@kylinos.cn>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 25D7E120003
X-Stat-Signature: 7i74ryq7ej45d94swag1cxkrdfg8wpxj
X-HE-Tag: 1791294393-741977
X-HE-Meta: U2FsdGVkX19w3yaY1dS9oBCzbzRz28jWx91TzFdXO1QNYyvVYjrJ15C0nZoeLRpsxbrpjEsifXcyJ4HoBnoY/TdZtYEieT5VfwxYMX6Q3DYu/SG0Vbh/6iHgqgMUJwHlmsljNA1azrfSJDvzRKiU185nLTReUZQz+lN4H2i9QmPptOutP0oF6lFr8wH8DyMuxazX+QcKnhqBsMXRrpFw0SNGmFp38TYyDneYTg9aBp9b5U/GYAKwkVec6MLWu4oPFX6bLYObXpCN9deWClNbeyU2yLepc5Ahpj7V29sWoX+WNIUDBoq+efL6vKwAsRzaC8zm//s33Ie5pwSFHd+NAqvk+LHjx4dcJvRx4BdYgCOxzVnhiiIuAFzCR3wES8kfEiejbdVI8aH8cSbxgST/okr/aHwzTm2RZ1TfuT1hT+rrcniv/hSo1Wlk0M8FFq9vLuUP1q+OLw+K/PeZU3J6oFFieZxXqblRMEUJScVOHseucl+Ug3VmMddyE4f4RVLUJDoUL4MFi+JjwoiEZU4YhRh4JBPhVD3CRfk0LBn+CRwbb2If6hlGBTZ6pppdIyNjQzMk8/ZjDJRTOa9yM/dfHkM6DCRGHxQL5K+oAF9yXVKxflRVXw+S5kUhrE5/LX7txRX50pz2SZj/+2XGBthLbPri9NfikJBO3tqj/12ozQnwcbEjqu3mgiVERoWZJ4FQZFviKEb6wLMwD2EfkcWRCAHFp8eOMOXf+CIyzNPcsc/yEOTPl4KPyko83H3SpxWofnr4Ed1EdACIdz/qSMnCGSui3yv5jW41GltJGfB1GOaF6aqrVo2e2USt8GTr4JgP3GnQLTFhkhJZ0TQrCw1sWYdkQ2jreTc71EX8VgqzGIDPjN9Ozsr6CrCYSEY5asMpKh36gIK2KL7eQpFz3XK80sf4DWDLV8sbDtUrXuWx/jj6XU4FcLNQzPFSi6eVmfqrtnCGHX9aXEfYEDRC8Hs
 7FcP4k/O
 lQxQX/htCDlxejYgjzAY1qgs76QjFwBD+ypDNr2i4IJezfnrKu6rEr2Ulug1OvWbr04oWR9yeiGzdw2v3O92IT/v5Vu86QsGFvuAr406l1uwd/Tc4DKdYsxgGVlya71CE0/rKucLzgxpkbmUfjV6e5z4MHXnfpzrJ0CnHuCt07iX7NhlooTDx+SxpbPNU26TMJk+oA2BGyyblbZkylcn8cUkM1+EyZB5ZD9EI4BWYvngj/fFbei91zaGzFpMH9hK5XdrfduYxo4+yd5+HbwVFwZbV0FGlxdgLRCdnxLCUP/kdrNA1/CUvWAfdhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 5, 2026, at 16:20, Enze Li <lienze@kylinos.cn> wrote:
> 
> hugetlb_cma.c includes <linux/mm_inline.h> and <asm/setup.h> but never
> uses anything from them, so they can be dropped.
> 
> Found with clang-tidy (misc-include-cleaner).  This holds regardless of
> config: the file's only #ifdef is CONFIG_NUMA, and it only touches memblock
> helpers, so removing these is safe on all arches.
> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>

I'm inclined to believe clang-tidy tool.

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


