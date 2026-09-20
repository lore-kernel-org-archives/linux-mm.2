Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56BA3C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 12:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE8A6B00A2; Sun, 20 Sep 2026 08:26:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68ED36B00A4; Sun, 20 Sep 2026 08:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A58A6B00A5; Sun, 20 Sep 2026 08:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F87E6B00A2
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 08:26:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 715A380426
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:26:56 +0000 (UTC)
X-FDA: 85234064832.20.6E3CAC2
Received: from mta0.migadu.com (out-253.mta0.migadu.com [91.218.175.253])
	by imf17.hostedemail.com (Postfix) with ESMTP id 63B4840008
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:26:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JOOvlXwC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.253 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789907214;
	b=LmXw9H9elxQmKXZhgDslLgqesaEK02m4j+yG+BOxfS/ec9tPr9OboI/Wd2UXPRaUeBbXHR
	F6SslXWSrqblwdKhUm7UN7fF1vUDMOHqYZhmHyTCJ6ucCkOrwGXaBWtdyI2s9t1mpZ1k3L
	qnXt9wQYrPRH9/lv6CNt/h6wh6hpUKM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JOOvlXwC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.253 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789907214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3SHrYiXrqoDN9FrxmtWulJL32fKDNnhM5OnISyolSxE=;
	b=xdRZKgVM9g2VsGY1jnws2ltM8tvlNY/cLpQEvddoI0hoGuMP5kfSNVrdY7oMpKCEyJYy+1
	hkD5PcXRoaybWm7+tZuFrWm4bAwM1JA+7A2U8YCCA+obBE1hAlee3th5oKoAZS41LGOogl
	rlHQ0j2+hVFgmi54r5Y5ucF99i05x7M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3SHrYiXrqoDN9FrxmtWulJL32fKDNnhM5OnISyolSxE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789907213; v=1; x=1790512013;
 b=JOOvlXwCgXh/KNhdk0mhTJMTNMnQGsjkZyQNKdllcagszAknoOc+vSttQTsDIApCJ1plq0CV
 hBiRAseTFGoPylyPk0qnJBelUWq19A33wh3U8UJvBAqau17FikuKepNI/3CyIpOD8toVnWj4giD
 kcPkHUuexPOEw4o1XePlyGFQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 31352f99dc44c0b4;
	Sun, 20 Sep 2026 12:26:52 +0000
X-Mizu-Trace-ID: 31352f99dc44c0b4
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	surenb@google.com,
	liam@infradead.org,
	vbabka@kernel.org,
	shakeel.butt@linux.dev,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	rppt@kernel.org,
	mhocko@suse.com,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	jannh@google.com,
	pfalcato@suse.de,
	riel@surriel.com,
	harry@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	peterx@redhat.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mm: update comments to refer to anon rmap rather than anon_vma
Date: Sun, 20 Sep 2026 20:26:42 +0800
Message-ID: <20260920122642.8387-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260917-vma-is-faulted-v3-3-5c22314a72e7@kernel.org>
References: <20260917-vma-is-faulted-v3-3-5c22314a72e7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 63B4840008
X-Stat-Signature: 4s3hpfooshi777n985ku89nyen9hpe1h
X-HE-Tag: 1789907214-247501
X-HE-Meta: U2FsdGVkX1+p1o5mDogu9I6a0MG+ajFFKIuxkiDmaKsYd2Wzh6A//xd4VALqjzQaKrEjxMvNMx5BJTvXfSwbJRIt9i8lkH2toXcPwiWiSXJWxxvotYrKWPvqZKZnwSIGr7JMq81WBU2rQn8pVztEuDZ6KwJ92WCVjoC45dnmoUsz+eWyjjqnatkuf5E6aF4s1fnRy4ojCt823jEl4Y1IhKgq72dHftI9jj6ARaq4cTEWl83perpXdHgkfpZWMtd2Z1pYyUwzGNOwjc6USMpkpoAB5YAgqL6RhyWzFhHFaFjkSZm1+JeiQrM2yhFT0xSQWJoF8GZF3Q5qnHyf0WSZ3vbe9uRP6EcZQE3rB9kDF+GzVtgG154yV18+UGnEjYcD/4M5Zxcz8xmjRF8hd1GfOMH5f3/a0a4sUOG3OE9AHV112Q0hanpO0McDpebdKyHAeP0liDE2RdKgFkz7qEGmQJlzQG8/CURQsltIg/CzP/USvwADOVlYQNjh0H+D+Bmy0rxrvLmgc6f3q1d4R/59badv80DMtSROu+CeJXGyRfm2DYtWeK7sH9aYIiTdnu1PCiPufu27Yg/+6ZcsRdmvxGP1PtnOyCLWz7ugxioGrRkAltERY4wgrVxLuyKCDytz6krFV7ekYzR0dxBMJfMTFqJeSdI83yMgBK9cxOIQDXm+EmZbVXmauDXPHhTayfOh40fdS0ZKYnshm+08mR438ejH4kElr11iarVRkTtp9brOjnLmpjSmbx5oy6OCHLdIdV4dpDKmrs1uFsB7AO6bi3lXAtNQgpEokZYw0f4VcZAZQXmxSPoORWIRwsa4tFFXmQckdzoYMv2qOyafXD5JW/mwS9XExmycALjoihFedzs4qbyUIJ19Aa8AFceosydMdwqyrwXUYEMNUi71L//VkPuS3eVpPm/Otd3PzyabKgtzHe+vRK3P9Mwrhg4tJ5Udrnv4s5ldgCc8xv9afCq
 FTA20nEg
 rx64yxwNxb88s7pzPKkCd7QHnhyhy2lAjNA1uPKReWVk/eObsoWmx2/TF1vPnPl/vkifttbAUR5NanviypasA+Gz3dhYtsViJfkioHFNZ+oTX8E2XvNmV7POfXG6nOa2ciLXKW/UqS4tlnfevBLJkfzAY1sc9kimWwkTmW6yhi6/Mp+t4Kb9H5IKkb3XZzxAY3uTq7jJIAAReUFnInIv6dqHCLIcIe+fXP/BCUDIDxxjDa3pKcrG0yGBaUWr/VUDZh7FEKsIjao2+lfzV6N0B2taeIASJPQ2KZJna229WTo5QZKcbWdczjhM6AP2nVFF5dmAK7uSbOvCoBB2fxEB0mRVHmmq8tHWQVau23tC8cs8UbpHPKbjOXdTe6zOgRHdVxEOf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Sep 17, 2026 at 08:47:43PM +0100, Lorenzo Stoakes (ARM) wrote:
>Now that vma_has_anon_rmap() abstracts whether a VMA has an anonymous
>reverse mapping, remove references to anon_vma and instead reference the
>anon rmap.
>
>The anon_vma is an implementation detail and should be treated as such.
>
>Do not update mm/rmap.c which implements the anon_vma mechanism as it is
>reasonable to directly reference it there.
>
>No functional change intended.
>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Nice work!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

