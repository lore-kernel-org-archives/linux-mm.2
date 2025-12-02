Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B6E0CFD2F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 07:05:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E8546B000C; Tue,  2 Dec 2025 02:05:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BFA26B000E; Tue,  2 Dec 2025 02:05:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FCFC6B0010; Tue,  2 Dec 2025 02:05:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BC326B000C
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 02:05:10 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6982C1A052D
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 07:05:06 +0000 (UTC)
X-FDA: 84173644212.23.611863A
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id CB9E22000A
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 07:05:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YOLAWdt3;
	spf=pass (imf03.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764659104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VvDgagAu6wE9yEAqSHaqkrBQJzEb+xI9kOIEYjd5Lf8=;
	b=eu3oXuFvYaqV5ADgsUW662ZSceFAP2BGw0dpPFm6jUwHqPsp8yT67Kem7Zf+EP1esOrH60
	qT8r8mQIJET1YRwTtke2oTTD+E+dJOCEsV/OL1XWC23mvUhyZj+X4sAungcAyZiF7QKSg3
	JsqZmoZPBqSDN0BEhyGfJyYM+DkFbTE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YOLAWdt3;
	spf=pass (imf03.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764659104; a=rsa-sha256;
	cv=none;
	b=Coguvp3/47Oh8ElBJXr1zH78oeAKnX+E8df9rBrbts5NPYPyYvO9JmiQvKCvfrXcpCIAuB
	3cY9rFoYGfot+fOz7cnf2xnMlD/5JW3+xvQ87L5F8Wkf+nnqktpbQl97orA4bmuuqGBAMo
	iQuY4KCagnfTMCGWYMGyscRzlIE51a4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764659100; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=VvDgagAu6wE9yEAqSHaqkrBQJzEb+xI9kOIEYjd5Lf8=;
	b=YOLAWdt3jd6b0EKCU6Z7aT152EeGDs9OnEls4z3HnT0Gh+ND1wGEjixoRO5OBgBpgDLVZzIbojpyo70QCjGlb/11ebeiZUFTqyZB5tQbm9KdNPn43Nz+hRQSzwI1dlG3rp6zKllbdUIRGn4ryH8NCl0bsBQF9YczpA4+R9ymwTc=
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WtvRP2I_1764659098 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 02 Dec 2025 15:04:59 +0800
Message-ID: <1937798a-1f63-44ea-8c30-1040174eb1c9@linux.alibaba.com>
Date: Tue, 2 Dec 2025 15:04:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/19] mm/shmem, swap: remove SWAP_MAP_SHMEM
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
References: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
 <20251125-swap-table-p2-v3-8-33f54f707a5c@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251125-swap-table-p2-v3-8-33f54f707a5c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6f5h7wu6b3cqfbhg5st6fa5ko1jefmm6
X-Rspam-User: 
X-Rspamd-Queue-Id: CB9E22000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1764659103-888194
X-HE-Meta: U2FsdGVkX1/bBfiaYommb4gbphDzCmg6TOMMhMYtzxl/EsmvlcePwdiwVCHDBvoX5Z3s7teTLEhmeV2/xOVzsJG59bz8xdV1HicrqNv8/IkQFUpcSpXTZ05siP5vzrTYVzeWgWLg4BsUE9iJjgYqx7tMkx222P1dt4iHeKdDeFhBZFZnFWxM6pofj4VWn6Qx1fRKHjTwAUqwBAMgtUYAM0uvX3zfnPU33i97qJVCfkVRZdAF6nhEq4tTGD+8vOwFevU7mZ/1bRuJ3vaUAOwi1m6qmUZmwpW4eYeNo3ZGN5uFmxJm/sAzyumHpNoxFjFwDN1wh5EH7DJJEl+6QTarr1Xlwmvu02+cPM2vlm5WdoulPPQSmO4yKcExNr+P9+Yxbd7WIeIFzTjOgUeb+o92aEOdusXxM/krV46QN36f5JqlBbVoC0wK0sA/KUaojHwXTv4nVQX7by0ksdRwrPo1Mv+9JYG7p2BoYlcCL78UxmFvWhtT7HMeZ8P1BvDoF7Gju068aDejE6tc835UIkfIhSOA1xCL4d8UFidVzzM217nEvNzEoI8i6ABa2zDlN/yLCEZcS5heRBAeEmtYZ3VGU2OizaTKdSaY5sgETS1VvepubplmWWehIhXRDH0eECX1BI2w59KcfQm02fyxn5cXBjjfBVAOBLulyxjnjWVGPzqvPOlfgrDI3vqRZXDZ1HB6zpGEHJQfnipl03B7BDTY2tJsdiREFbSNbC72HiyFKvjpJzSp9ccQZEKZJPiTNQRnYg27FqPvv3sfs9vVWrUWGzqrFbY3rq1Pxugs9MxLO8t4OXXsZAbIvwr1YUWgDJgk7Tf+nQAmSHs8eiJQw0JTMjtx8fcDDGY2cdbGMHsi4hsxV0j5MWFTs0JBUfFsqESdzZEDZIGWG/NWuOj38KQhVn6P8DfibEUA/FFZvjy2PxLxLBV5ah65R66pL/56vg/bf16AEGUWYjCGByDiaSq
 tgSRueWq
 lBxIfAtr+8Qr5vjX/dVqLZCl3jp8M2DOuvI61Q8tqM3M3axYVs3D4JrwZ1zd+rggwf6u0G2rcdiApeprGdhPqHOn1CukO/wdb4rlocixws95ciLIyJcu7ezUGOHRkR0XMVweF5vCSDInlCP8Q/AnN0CeLocSQSqGUGruxSlQj0HI/RGozRuoDRVOvaT40vULN15R3mZZiwSBqe1HNw7sz8/H2wEzlvGvqV0UHD9SmKsa1VaVQ8CA0aP/NzRH7b+esP1f+6pdf1p1lIR9M7n4seTILPOGfZGJTaUeA+wKzEZuVqHlGKVJdn9csSivJ0pOrqKxjf8cDH6k5isYYNnPtTVpc234SqbTeZyWlpi2qMzCBV6MU/6RTs9V1axQOod79awXS31U1dtMt5vE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/25 03:13, Kairui Song wrote:
> From: Nhat Pham <nphamcs@gmail.com>
> 
> The SWAP_MAP_SHMEM state was introduced in the commit aaa468653b4a
> ("swap_info: note SWAP_MAP_SHMEM"), to quickly determine if a swap entry
> belongs to shmem during swapoff.
> 
> However, swapoff has since been rewritten in the commit b56a2d8af914
> ("mm: rid swapoff of quadratic complexity"). Now having swap count ==
> SWAP_MAP_SHMEM value is basically the same as having swap count == 1,
> and swap_shmem_alloc() behaves analogously to swap_duplicate(). The only
> difference of note is that swap_shmem_alloc() does not check for
> -ENOMEM returned from __swap_duplicate(), but it is OK because shmem
> never re-duplicates any swap entry it owns. This will stil be safe if we
> use (batched) swap_duplicate() instead.
> 
> This commit adds swap_duplicate_nr(), the batched variant of
> swap_duplicate(), and removes the SWAP_MAP_SHMEM state and the
> associated swap_shmem_alloc() helper to simplify the state machine (both
> mentally and in terms of actual code). We will also have an extra
> state/special value that can be repurposed (for swap entries that never
> gets re-duplicated).
> 
> Signed-off-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

LGTM. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

