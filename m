Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FE15CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 06:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9C66B008A; Tue, 29 Sep 2026 02:45:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C1AE6B008C; Tue, 29 Sep 2026 02:45:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FEFF6B0092; Tue, 29 Sep 2026 02:45:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C8266B008A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:45:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9BA474028C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:45:36 +0000 (UTC)
X-FDA: 85265863872.01.2E40331
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id C77E940005
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:45:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LlyhGwgu;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790664334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2hovsts/EP2rMWjzeBEfd5QEScwbOvRyI+VdMh5XzkE=;
	b=sqSwglxiDBhMBOcJ/dx5qLJvuvvIvVcUZ8zm7GaDTFCeNKD6Rlt9LbV/DbYguX70oL+767
	vhmQbSsP7ZaIqprqJfjaxNaSZVNW1ebO3lEVU4F6bSSdgR0+KBz8swo6o4GneafYy8p+cy
	f1CdzhPRPuuXvlSFeaKqr6glEBm5FIo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LlyhGwgu;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790664334;
	b=7yXR4aEtXjVSghNTLKdEBDRhb9sw6g6cbx4gnchVTI7MnDTQopX1FZvAUYK8HBluKVRU8H
	A3Htj2JMccHl7X7oV2Ocl7u2A/HW8TVqY+Emw0OJKDvVeS1VGnUuFOa/m5oudbYXX4B88Y
	7vRksd8a6cBxPARMHvjK4BC1iyUQG94=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790664331; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=2hovsts/EP2rMWjzeBEfd5QEScwbOvRyI+VdMh5XzkE=;
	b=LlyhGwguM3CMKRPgnocv1HdOkuELkVewa+gf6m7XHO++nC6d9utTU4CUg9NR8JP44azh7+wxtf7iprxrkWnLpxhHSzqAYgndrL7Fa6LVm9VEc5RPSFrlHot0e4TzRgJr2DqTK6Ns4hr+GrqQQCXEXT3LROHoaOrX1X699zQ755g=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XBsIIbV_1790664329;
Received: from 30.74.144.142(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XBsIIbV_1790664329 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 29 Sep 2026 14:45:30 +0800
Message-ID: <3c14bfb1-1c0c-42c7-b202-7647e71252f5@linux.alibaba.com>
Date: Tue, 29 Sep 2026 14:45:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/4] kselftest: mm: integrate huge page checks
To: Yeoreum Yun <yeoreum.yun@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260924-fix_split-v8-0-cba7359d882a@arm.com>
 <20260924-fix_split-v8-3-cba7359d882a@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260924-fix_split-v8-3-cba7359d882a@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C77E940005
X-Stat-Signature: xkgwgyg33ykc1c3e76duwk3u1ge3zzdt
X-Rspam-User: 
X-HE-Tag: 1790664333-246043
X-HE-Meta: U2FsdGVkX1/mqgodKGcnPNqxEbb/Wngq6sMQ4hQ3q1WlA7wUeFU3YSK5mOCLLY56ZpAiC+Sv3douQh6+BjE0Es5pWAXw9oZlDTPrAEz5HFvwvDvesJKK6AaX4voLg7kaCFjDe01x6CAcQFlncfhJhZ2qii5CUhN7FHhJsyC8d7xdcBNOdfNvr93Icg1520lS6rnWPWVp148BWl3fhbDPc7OH0WaveufCdPZxzv4ufNKurhy1TbpaC019UT8bznnGY9mMvalruAm3rXj9BMhOMBXBoErCgI//Gch0+aWMg0eaLkcl1LsHu1bqzA/XQfZpmf3KumOftSi7SSLQnuvniNCiHKhmC5iTCL8jV8bm3TfHY88vWfz5bcipLaywz9GzXRUNIdskr8ULhd9X8Tr7Upr0m5YhYyKdKHtCy72Rabr1hf17pshFxs73w2MCVe/IYxIZv41UkjIEwcgN9bKtAoVWdoIjIxW70c4Cl5InHmeOTtUTqSuyAznA55GPrNIFqRhjExqiza2fSRuWbWCMV8WD+6xfprhrGSCrv2S2DLXCquJjlBMhtTO4ecVz9c8L2N4MpevjewFRHTv51jSNbqY8Yyqvt3avmrFQx81C/HtEpnQgcQnrW2J2fcFheO55opu9fCO5QWy+1a32sINqS/0qPCvFpIxnoWDfvOaIFttoPOskIfDxqxeFVjwLG8f6AhT6MriV68CpD6dHVQpLZJGwG3Ux4OnXioRa8QtqtYUafSj7/AqVOIlsvofqFFdxackOMCSJum69UNVZNdT3DhYEN/OURxYgx+mpgTXk0tpkIFGn2p4jDaBz+zMh5Bppwq6JnGxJucgAcVCttA0ppU+CdFxOyCyf0KdEiJeA4Ddm72zeF6Wa9nCuPdH+RX9ilf7UXMNfoPPB6NaM3zlRng6wiIQbNvIrqMEglKoyr5hTVu5ve8+IamxzQkiBGKB6RfkV7WoYAobkiXPvhQ7
 mwpEJwZy
 QUs7XDBTcCHWG56vyckMZSeDH3n1O6Ktm9Y/S7N8GeLxMvVyDf5YyhkeD5w+d9eE8fG6HpPE59ciGf58PURRkDMV9o8/3QUi8RTgQiTyqhEKloBt9Z994BKgXs6E6k69srnYpgGt6acvBc/aUPHtYpH8fNBiP2rdGgk3WW24Hb1pEhAN0VxPQKzEKaL50fdqn0gRpC5p5NhKL5wuMcvAzdG/hnyfD3aMn5P6E/yDj5wwXXJzRHjPg3Fagmfto/E+NJ0GRaZC8pcJdTj/tR3U9Gry4lrsdgwyzt+5Wn4Slba23iaGzxyIVsCflswG09AK7KtF/khIOy3idHJxIB3aJXuDiPFn1Im+MVZvAlr7L2pTwpYCEi128lQk/B25eIWarVOEKgeHeRMm2hftD8AVWi5YctFFyhzxV0wSjHllgsVzTYJa4LxuuNJDwaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/25/26 3:11 AM, Yeoreum Yun wrote:
> check_large_folios() only checks for large folios without distinguishing
> between anonymous and file-backed huge pages.
> 
> To add huge page type checking, integrate the huge page checks into
> __check_huge():
> 
>    1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of using
>       check_large_folios(), since only the mapping type matters. This
>       identifies PMD-mapped huge pages.
> 
>    2. Otherwise, use check_large_folios() to detect large folios. This
>       covers mTHP cases.
> 
>    3. Check the folio flags according to the huge page type.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---

LGTM, with nits from Sarthak addressed,
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

