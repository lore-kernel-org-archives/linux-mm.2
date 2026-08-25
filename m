Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF928C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 12:50:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2F586B00CB; Tue, 25 Aug 2026 08:50:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDFC46B00CC; Tue, 25 Aug 2026 08:50:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF5F66B00D2; Tue, 25 Aug 2026 08:50:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B24BA6B00CB
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:50:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40FEBA03C3
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:50:17 +0000 (UTC)
X-FDA: 85139774874.29.57135E8
Received: from mta1.migadu.com (out-133.mta1.migadu.com [95.215.58.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 306DD100004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:50:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=metmLUmX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.133 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787662215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7afrx/UxksLEj5p1pUtRVkjaChuJj6IxaBDuc7wjrfw=;
	b=ZvHpNaguojHZjvG5aFOL29vDyyZ/mAaq5x+GE/ab1X8uzuFA6ybmD6mQ7sIIId3TdUoIvm
	+/Rfxlp6J7JwYSNxcrJ+zzQDeqBqE952oYxO6TsS2jCCIPod7pU/b8K0QGx9fsS8YPd6XV
	5cWsdBZ9ESMubiVE55sqwbWFuix6pPU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=metmLUmX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.133 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787662215;
	b=p8g7UXnc/X6v8nj9mMWm4Lj7XB3OSNEFeeiZr+QniigWULUPNu8+oSn4Ck0fIdIat6HR5g
	IrddSKLok2DBbHxH56BuWy48pS2ofEEgnXYaJqTehSh1QsK2D407Ju44BigrWXcM/Gc1PL
	HzwqqJeF6ztg2sdO12ygZSvdtBrnW94=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/JEQv7N3pOC5lUkF3ZduCEmcdMDk6jtj3oMONbUDQz0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787662213; v=1; x=1788267013;
 b=metmLUmXxsotmmWuB0aukH/5GAGZAqUu/8bVAhA4FEKJnVFcTTChKQ0UASX1IO4+yk5ZQ/4y
 nYZQI1zhZ4+JWk7xzY+ZDHDzZfYhsAXjSXL7Ed90vykIHlWE/oNXDY/tf8gEis9RCkSu92n+717
 HxJSrlzCUBK+CUYhPn/POc60=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.254.116.35] (101.126.56.83)
	by smtp.migadu.com with ESMTPS id 3f54450150a7adc7;
	Tue, 25 Aug 2026 12:50:04 +0000
X-Mizu-Trace-ID: 3f54450150a7adc7
X-Migadu-Flow: FLOW_OUT
Message-ID: <babba0e1-a07e-4e98-a69b-cbba8f201c00@linux.dev>
Date: Tue, 25 Aug 2026 20:49:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/17] mm/sparse: initialize memory sections earlier
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-10-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260825084608.47437-10-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 306DD100004
X-Stat-Signature: jeipo9sk5ozqoh6uzftsycc3ri5oud1o
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787662214-209450
X-HE-Meta: U2FsdGVkX1945WfQ5AUIv+zBRBQQG3hBKXxLWr+3ThCmqoz7tvmg29Ux7xF6rVTqHzefk2XNck6Cfv4ICuu/X9SeUGtMG9FZHaleVdx0en67CyqIU9VsPXW3qKnyXDMessMegzvWLAxVxQbcF57VVkXTjySTCCgYNKD1ib249HWVojgBm6x6YDSx5auQcAwaxxAPOwrgoT9OOBaw8KgK+rnneuQCcMr114VN/UuQMPNBhOv6shNc+VtTBZjrxZ+zxbX88eUshcAcdq0yrY8BeLC4j2nM9c3xszKboJf/MhdZl1erlN9AuifXp6b5AgyqEHDqcUsHuFtoOmhYhq1Tvbw2jlNfiVqW14pHtJX7bBelgygfeQoaVNNxaBMSf3zdEf+ZfZPsac0UBFs2XYIrCHkhsWihMRWpc6KglO+dZ1tO9FqASh7uqRnvlCkfuCs7aBdknbvMRCoUEZMOBT94T6cN5sywcQ9yd+XMqqIQtm9M9p2HcgWXC6K7puvzTuK3HDRjmaqIgDpYJWHpRd2qkEWXdezbI0fCbKFElFeqCbmDtpY5BjTGQVHm1xXPFGYqbhm2Ycy8j0S3E1ahdafCHRwpu574XtkLcxP3T1XNemzYp4k1NwBSnD9RZDoHpSWaxiel2I8kkXtQC5JVr2AuenLTsgNCmjgD0vq33TGvKv3Yrdi6EynA/aD8iyJACEwjpmsd6zU9xyyRPSjB9Ee8C7pXqoPHeq0JpNIN7QZURC7gYkRZv+HK9hN08/DuOG4hlkxS5wa4uSzgeYUYf9m+1Qjyabo+1p3KFHRHndkiSZB0Hdad+bm5ZEXm77ZZnUUo0PQC1oRJgkomumEOYg12eNE+mEGqYQImyeZD3Vcbto8wHUjPSKn2EnPMIhWHtvmZhWD+xOBcO1+NAaOBwZbf48staHamBQklMJrOvs+8FRfyIYqYnCyC3nYbu9VKRxEKYgyppKFVGto6eaJY4BM
 5jF2QvtS
 2HOQoO1fnutbEI3cTrVHY/pFW70UEXwMW3/jD5fV57hOezjyxOCMMMRRklsMrpWllECLP3UQNPPwb/C59pBk3bpHmMCiggzE3LlsU8fQ8Q6E5buGUFXqcduW0D9EwxQ0ilFkqkHXeEkbNIYCaGyyyR5L4jFWeXsmGyuJzdAahMEo5gyyY+FeX/cmacvrSQwAEJ51XQYN6crIElJptecHTXpE6hiF3fIne0XNnzeyCeP9xT0fWbcKY84eU41dBMxrlAiQXOJCyIFWgwVFqfZwU0Z2KsfrF/1FFlMJ2z4aE80xd0UA+uRmVCXj79Q06awR0Qn7kb1poJ60q37MMijYtBVIgDpL2fqv7pAsE0k9ks9vzd/+jCdaJIxKu4eahn9Ql8Jcsp+HJ4tfsn0HEhsfQzwqygw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/25/26 4:46 PM, Muchun Song wrote:
> Upcoming HugeTLB bootmem changes need sparsemem section metadata before
> the HugeTLB bootmem allocation path runs. The memory sections are
> initialized from sparse_init(), which is called too late for that setup.
> 
> Move the code that initializes sparsemem section metadata for memblock
> ranges into mm_core_init_early(), before free_area_init() and the HugeTLB
> bootmem setup. Rename the helper to sparse_sections_init() so the new
> caller describes the sparsemem-specific initialization step.
> 
> This is a preparatory change.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


