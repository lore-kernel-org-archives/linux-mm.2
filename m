Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1DA9606A337
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 09:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=TEhxIWGw
Received: by kanga.kvack.org (Postfix)
	id C4EEB6B05B1; Fri,  6 Nov 2026 04:41:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C265A6B05B3; Fri,  6 Nov 2026 04:41:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3FFA6B05B6; Fri,  6 Nov 2026 04:41:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 974E56B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:41:11 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2FB61160CD5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:41:11 +0000 (UTC)
X-FDA: 85404200742.15.0A5BAC7
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8AF8B40003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:41:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TEhxIWGw;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793958069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u++veeV2UEGzavVifT+Wy9EXLAeW8NwCQG/jN4kumaY=;
	b=YA220C2wrPWXUfxj8A+sGZWJ88ousY+s2WwLyepds+SwaopNQkC7i3Km2ZFIx66dd1vZLw
	gpBz4y5qe/L0IFcR3IW5YFZjGgpsqz+NpJ18QH37+qrrdoPgtUSCop1NTPtYaI01nZAL0v
	O86PoZjHnyCff6zAI24E1d2FIboobg0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TEhxIWGw;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793958069;
	b=5+bYqMkW8qLhDv8J4csw97eGvzuVDX+/9ooGZQSZkl7fOQv6o4ZeED4yil85h1zl7XNHtn
	9LOACMNlsPtkc4gb+3fX7o1LfLcc8Il72hXzRQjPILudHr74wfG5IcLQqBvgPWP0hqNtfN
	3vmxaNgM33tf6MjIJI490zJvQSxlhNo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793958065; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=u++veeV2UEGzavVifT+Wy9EXLAeW8NwCQG/jN4kumaY=;
	b=TEhxIWGw8N9et0jVajuM97Za9nuv8Gc8To6Pbgh4AzCf2NhFrpxH3x/2kCNMXwXYxzD4DkFDl4XjU6IARWWcSOrnjoqmTecex0H3ZjUz0a4byb45Vj8lxcxUmaR57unDf3L1gOC8pau2toSexFOo7CPFNoTvCww36l8W3P6r+gw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XEBIttq_1793958062;
Received: from 30.74.144.130(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEBIttq_1793958062 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 17:41:03 +0800
Message-ID: <76e89362-6c79-4231-9d0c-0688c026b9b0@linux.alibaba.com>
Date: Fri, 6 Nov 2026 17:41:01 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] Revert "mm/khugepaged: remove definition of struct
 khugepaged_mm_slot"
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-1-4384bbfe4606@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261105-khugepaged-latency-fix-v2-1-4384bbfe4606@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8AF8B40003
X-Stat-Signature: rk4sh199zuhcnsr66razdh9qktwkqxis
X-Rspam-User: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793958068-646044
X-HE-Meta: U2FsdGVkX18yYHyXfZDRIkTd82N0ikUGRJuavVy6gYn9aXHhdc9kJb+vOUPiXz2C52wz6WygSH9JxNn+i6AvQlvuYpUqtaHvAcoXbmmZHms5UcDhM+ApMtejgqbBBILGSki7s4/dZwtHmdeZI2SA9WtRUEKlJb6tfqmNRhVRjf/LrBPgWd6o/pF5WedM9uEJVZfciLRWuIeI3wD/2hGhU8ZghUdJoMnMl/kKKWeiUOBfiGj/NHODdWWarTNoDXfwjDjKh2uWr6U4B07T95jdrFNGlWKLC4GraFzIJlJnzErAqGYtO8ZFNrAE2MFUeGEpWzHxy4FsMvSPDcbvw2BO859x0jSHtKSTtY5uGtojyFWgyPNXqoOQqRJ4jegumq3C386utlyZpsVpLwlSLRXSiH9sqt4cD9232HmwN/HV+Slm94T3JW1UmcWruQUA2jWz29LXgrrN0CUvAVedvzjPyuVbi2Zk68nqtmSqnbX2YWcjPJ6HRgOjhdsi1m7+sCCZiaAzvpE/oBgrG8g75t+tYAI5zIL3lzxoxND08CwjCfzzewM0PTdH+6S96eUlEnesRSSlugsuJarDHmYeG5yvQaumWwmOdUMVe68ce4iBtFBYXtUBJjT/xoP5jc+i5ZChVujj/2ZL4C6N0JVcKrlZ4EYWOkaguIdji+7TZH/JSi6y0MUURWlXgtP77sSsx+T+20qdPK8apDdGsjARcJijBn4uBiFiwZ/tnhByshBXZs5ba+yk/v9BcgvoCZthdmOUzLWEjD0IEH1ZAvOFpMffNijEH8/cCNQEz+p4ho9L/FtrMUWpHuUpoqwMVvjeUJwBvIzOUCPwZOELpsR3xZbR5jGnKoWBE6QFQGr0V4OvrN6E60ljK0Q3OBhaF2rND2i+mPo1W1HmHvT/Kw4H+REIqXVMWr30+AzMSl+U51avFr8w/BpYdJIIj/QmWhN0ZX5tgrb963SXc3Zxx4xcGxp
 /6fUMc+6
 y/r2DaEtQIeQ9tLAGnlfNXh/d2pUL+n3za3fQGhg6YmZphCgHpLUZGNQVZang/mYuu263LnhYJLtLm684nthYe5JCH8f5crqgdaVwCAjeqbnTlrKIh+n9J9021FBOTy70fcwzMAdZtRe5aoU7RGR67cJSIwrpKD64gcq11OzWgu1vsqm5/JKvgNBLtE9XOxQtY/aqwMXx/+Yyi/HV7ojQwhLfZlke8sQ+zNWeFAHsnBCadIOavWLH0532rCIJJFw2AYUYmMKHvY9gYerGXD0Lrl1EfqO6mDAP8RMwEGhWN4JiDQpX8v+Ar621SSYziSbPtjjEblLHrQ9cW0Savv7x0qZxcfjEqinWinj9a2OuB4inWeFMlUFYydH1xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/6/26 4:57 AM, Lorenzo Stoakes (ARM) wrote:
> This partially reverts commit b4c9ffb54b32 ("mm/khugepaged: remove
> definition of struct khugepaged_mm_slot"), as a subsequent commit needs to
> resurrect this type to store additional data alongside the mm_slot.
> 
> The stated intent of the commit was to address a NULL check in
> __khugepaged_exit():
> 
> 	mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
> 
> slot can be NULL and mm_slot_entry() is an alias for container_of(), so
> this is container_of() a NULL value.
> 
> This was benign as there was only 1 field in khugepaged_mm_slot (offsetting
> NULL at 0 results in NULL), however it was right to fix this, so retain the
> fix.
> 
> It also unwrapped KMEM_CACHE() in khugepaged_init(). This was a mistake,
> and was itself reverted in commit c14bdcc9f274 ("mm/khugepaged: use
> KMEM_CACHE()"). Therefore, retain the KMEM_CACHE() form in this revert.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

