Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3440FCD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 06:59:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51AB56B0088; Mon,  8 Jun 2026 02:59:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CBA46B008A; Mon,  8 Jun 2026 02:59:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BA1E6B008C; Mon,  8 Jun 2026 02:59:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 29AE96B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 02:59:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8ECC7C30AC
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 06:59:45 +0000 (UTC)
X-FDA: 84855845130.14.C21D2D4
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id 47F2B14000F
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 06:59:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EUapOzUX;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780901982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y3/06Trq5FpnxHyx8TwAa3S5P3cfEJjPOzAapv5j8wo=;
	b=5+HuexiLQ4I9ubhAXCSO2IZ0pEqFCZccmz+HUIvBIQKnOHadEhL+GgeCqjjeRIe99vwW31
	q6QaMfjqwkkY0NNZYC/iqjvPv+tU3o8Tbo/A9rL617QdrrigNqybwhG54g3aVUJLZ9oClV
	qahLSBbgvuA7Z54jQd3u+EgZK7tJ7Lo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780901982;
	b=zv16ZuxiZp4HO3cPOA92AYBB5TgUymRXnqUiAgAOKs7zgRMIxL0oGwNpm3LMn745u/BXqB
	GG6bf4OvcReub8MEIzx9OYUx9rfEHRtYOqFMGMIMIrBL2+YMXNvgDn8DTwpkx2C8uezBzg
	7Wl7qAuxO2rFoBuJPMFmdinOMBGn1Go=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EUapOzUX;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780901976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y3/06Trq5FpnxHyx8TwAa3S5P3cfEJjPOzAapv5j8wo=;
	b=EUapOzUXzSldul+SfubS/o+1vi1bdkmgOGo33ORWMjo36vmrsTNcL+aaGW03/YjqAZSW2R
	k6K4Jlx7h9j38VtG8xzTPjXnNZRTsV7JRAyL8HPHWR9Zi+NmmnQyClmfyWfUeVsdt9mjuP
	MnaxxTrabdkE3hKr88UNKrlypvcKGKk=
From: Lance Yang <lance.yang@linux.dev>
To: npache@redhat.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com,
	usama.arif@linux.dev
Subject: Re: [PATCH mm-unstable v19 07/14] mm/khugepaged: skip collapsing mTHP to smaller orders
Date: Mon,  8 Jun 2026 14:59:06 +0800
Message-Id: <20260608065906.66125-1-lance.yang@linux.dev>
In-Reply-To: <20260605161422.213817-8-npache@redhat.com>
References: <20260605161422.213817-8-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 47F2B14000F
X-Stat-Signature: k68ut5thzzrb5ftzbxtbqq4jwgjnw1f1
X-HE-Tag: 1780901982-667139
X-HE-Meta: U2FsdGVkX18NwVZalr8OHqS+QQF7wIZCJ/WnDcpHDJOsPNyP5HlSNdjIB4xZq1Z8L1Y8iNflgxQ2fKwWoaWuD+GHkDGQ+VYtUkBDGs2mnlk+keBvV+JophYap3xhH4TFdLQi8jSWJJqfIChOdGoAHbBhhZIkQvLkLSIAXrem0zAS+I2oGQuh52vqZQ3VTarfZ++leRK2311sYz5g0Ivo4+hFTwWmWQvjGrnJ33/xvBLEFaJjLwU2sp5/3WiGUpyYd+RnpBt6CLf5CdmZvmQxf02cZFxkfrWvRIS11Akexh0ri6RzzegWC7untQfrrPU3R6iBjopAWgsFMWOMbWRO5v4eiZt98UrP/znhZd29Mxy0ZUooBbN4EfZAA8Bc6lDLiowCuSovTCdq2NMTkrpHcKgBB2qqGUhmv/Y/5MN8vuynZOayRQIzerSArwUS6qd3HZjNtXV6D7GW86Yh40O/uFFFNG9i9x27lx0y/t1sGSzUotJdo9ZPfzzleA8BojjR+BDDnawz3VAJZj+TxDGI3usMFXww5g7hqJlK9873XtakQ57ZviXs06PtORVlLDMjmu6sGeqTa5xQylAO8Bl+yjVhUGmcwUDwaz/ql5Aoe4HhFa8ijDEDuzbVW0uIXu25HuVqUUa2SXqUwniIYQJVY/cRF/leXHSKQuZRcO1S6P5HTFGYoF1Av9fgAEMROnaPs3Y7K/66CKGBDBMEwuQHJ5QZbzowBBCpiS4BoA4y1T9nDCdNHIz8FCh1CSuqA98vTnkzuTKIYYzFAhMdYEEUrU736FsScxoaC3SpDJ89xm7TO5xzcAWBd7J2WzWS15QfXNQRvKkX0qQI/PmVb3e0i2YduBNFvF6MREGxGNRznxXvmhouGCj/6i5IvGbAGqRZdj1F69bIcXNJLgIH1/jQgYQODf2Qbl1WGjmSkWQK/jHQqYmWOsPY5/YmXn5rUOZr8T1UOKvyniHyO7GuLoh
 C6vOSioo
 55BJdOUD2iM6EqV6x65F0wsdybjuArlN/Mr2Lj1wSw09cQjdXTx+iV5jN9u72pjErbDZzI4SHTE5xWH81yiHuDuWbTCs7aBnhjLqvQq+vhIbSS43FqLzCn8xTKNUKIMDLizq0IlJ4h0hOcJXK3Y1t4IGx7OhpkCjGM1OBX4Dh3mzQF3rmduIUmw/nBqhEA5EviBBsbyXJ9/hmfKhhm18qjHp8+PBCVOy0PBbJxiyqiljO0pRL4ptREExPcsDPGjKJI5SmwbI8vYYGhfGopTva3Rwb3fvxi2+OKEnbUHYKDeOOmT52EHclkjSJ8HRxMT7/N+OTIbAv6kpjMqtobDm3r3RMLL5EVG1xOM9HIv6VerNctARxgbKILFdf5LuppfHgylpjUYJ14LO8f64pLGYHN6LTQyr2IJuOLMNK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Jun 05, 2026 at 10:14:14AM -0600, Nico Pache wrote:
>khugepaged may try to collapse a mTHP to a folio of equal or smaller size,
>possibly resulting in a partially mapped source folio, which is undesired.
>Skip these cases until we have a way to check if its ok to collapse to a
>smaller mTHP size (like in the case of a partially mapped folio). This
>check is not done during the scan phase as the current collapse order is
>unknown at that time.
>
>This patch is inspired by Dev Jain's work on khugepaged mTHP support [1].
>
>[1] https://lore.kernel.org/lkml/20241216165105.56185-11-dev.jain@arm.com/
>
>Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Acked-by: David Hildenbrand (arm) <david@kernel.org>
>Acked-by: Usama Arif <usama.arif@linux.dev>
>Co-developed-by: Dev Jain <dev.jain@arm.com>
>Signed-off-by: Dev Jain <dev.jain@arm.com>
>Signed-off-by: Nico Pache <npache@redhat.com>
>---
> mm/khugepaged.c | 8 ++++++++
> 1 file changed, 8 insertions(+)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index c2769d82a719..191e529c185c 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -697,6 +697,14 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
> 				goto out;
> 			}
> 		}
>+		/*
>+		 * TODO: In some cases of partially-mapped folios, we'd actually
>+		 * want to collapse.
>+		 */

Partially mapped folios can be handled later :)

Reviewed-by: Lance Yang <lance.yang@linux.dev>

>+		if (!is_pmd_order(order) && folio_order(folio) >= order) {
>+			result = SCAN_PTE_MAPPED_HUGEPAGE;
>+			goto out;
>+		}
> 
> 		if (folio_test_large(folio)) {
> 			struct folio *f;
>-- 
>2.54.0
>
>

