Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BB23FB3CE7
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 09:15:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B75C96B0092; Mon, 30 Mar 2026 05:15:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D386B0095; Mon, 30 Mar 2026 05:15:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A89D76B0096; Mon, 30 Mar 2026 05:15:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 999CB6B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:15:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 294308C430
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:15:58 +0000 (UTC)
X-FDA: 84602172396.06.7411A85
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id 05D2D40005
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:15:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JlEVi6V9;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774862156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LSCJ0gl8vSa6PI9GtiEGiz02O1vonLLeMqbuDT2/pT0=;
	b=77WBL4IFbdjcgxZ1tb51KqrixOIdfghomjrYyZEM5V4dtj9OKWxyQjfnyte0AuOQtsOSWQ
	SBwkmMjp8iarijv+84ymkRFHoaUFLzvuIj+icTlSRfmvfPg1XJx1riAWCisQBL94A0leyo
	XcGAvvJjoUkrShJUwaWxH8l/FGFbFrU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JlEVi6V9;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774862156; a=rsa-sha256;
	cv=none;
	b=edC8MOSk91j8sRHRC8GTv/iDMcDCl/yM0yUspWH5K4u6rW0gIukC9V1BupEl/sb2ZiGUr1
	/yeg4tegGJjlpatN6QGRchcvF53DXaMqaMXUkXMVv5KlrVMi1O0yVf78JDqwvmjHut31t0
	IrnKzRDOQa4R6Zibwnei9xzQAJ/lbj0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774862153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LSCJ0gl8vSa6PI9GtiEGiz02O1vonLLeMqbuDT2/pT0=;
	b=JlEVi6V9Dvb4mKdK823yLSF2UnR/iHJ0WcmyNTy0zY2Vi0Iw/QhfgPYo49r/guOUtqs07o
	2wEfzceNfeC0ZghYSXatqvUiQtxgYTkFjR+fQdkCMeaKASv6tP9fKcmehrrBDbe60u65DD
	rd2PAY99ZUhzsT3Xo99AG1Jk0KJicfE=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com
Cc: willy@infradead.org,
	songliubraving@fb.com,
	clm@fb.com,
	dsterba@suse.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 06/10] mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
Date: Mon, 30 Mar 2026 17:15:36 +0800
Message-Id: <20260330091536.20015-1-lance.yang@linux.dev>
In-Reply-To: <20260327014255.2058916-7-ziy@nvidia.com>
References: <20260327014255.2058916-7-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 05D2D40005
X-Stat-Signature: 8jbiyyci37ph85q5s58xtk6d6b9z85oz
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774862155-456862
X-HE-Meta: U2FsdGVkX1+C2V1c/medtM4hwP2TXA1NpK295ER41ROSf1f/7rW4j6RRvlJW/t8ugzuuHAr0BmW30CW94YA4p+lKXoeoyhoPlUgGWQMYxD0A2h5xbFxDkWUvogGi5URoU6BbcNWw6CwClR2rwTV/naiA0tiowtGQhO4cAgDr84sT8pp3Ek0DHASbVC4JaKak9IIrKtt6C82U7iJJeROtoxHbT11kwzsr5k2ZTgcRUD6fo0X3OTaGm27NGgoN+bCgvmnbQTy/Mrm/RTuJnnZZsC7Q05dMXIqbb1f5kIvD/ndsYYIxHEpXQu1hO++FhGWoCWyYOVOjj9HNUv94+tL4DrR4GSoOLbZEEh3OV2sjcLsdgdzAL+ZlvpSDdzqwiKEgJtMWBJS13FLwnyETEIiwKj4jdDnzWeGcALbkjlZd5fx5JU5GbA1jPc/qc3J/kBqp3tnO3okcoSXiHDq23bzDu8QGCnjR6W2S2DB7vpHsRdhuxEnYsaHaYpudpKsWG1Zpju3kvxEVmHSwD2jjj6XU7ERBFJro+30/OtP/Xbcvzf75wjs8MyefyNL1kpEo0e0XLLsGqmdCEfdY04hGs+FHY+4kLFRLh7i9tiwjyTo9pH5ncpOO5GsiHzOmQzdCSiKcZeOpUquLiHxlNvMbLw5VE/++JUqOW3LNkyVXdxNFHF7Z/h7ijSd3ixaYrzO2QTpKtgheQrlSIMQoG4EscXnNu+Z6qQsEc7yL8iCPqqQDBu2tcZ3c8n5W0nmDpgkZO5QlP1Ip4DN2CcpMDDgwSVZWfVLnnjEyup7cbhYL3eDAWV7+Cv2tLomUgiZQBxQAZ++lGdGmOB1tn4gZAcR77V5iF7hep7HXzDfo5WYyKGbsYNS8eEogrGMqBDmpzXjn2oE5NzwrX9OrsskrpMbZvBGJiW82U6S5b3vvqDI/ewKcESTTUTSYA3k5YUJBZU9cf8v/PJjyGolp9/WRNsguh4u
 Kg5vBWNZ
 BkpGaBmico2Po2+5+9skvz/dfrMWztJYXdSNFulWvQ+Rdct3ZLha9nViF91/COz9jonYTXzN1x+00HfcMGq2s1ysbrdPHEt8kVpACPGkY8yhLzw+1096T6eQ2cmbFr1UIYWZzkoPL3wQKe0J25e9odMWFJJlochSTyugTkBEArq2EQJgzq1LEWk6wpEFXi85QCMRivHqPUd2Dkd+cVzmyXqi9vV3vEmfxiC+uIEysQvdqEBWuacHkmWTVQfTFo20a7sMQZaWtq/QjilBc5o5q8ZR1+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Mar 26, 2026 at 09:42:51PM -0400, Zi Yan wrote:
>Without READ_ONLY_THP_FOR_FS, large file-backed folios cannot be created by
>a FS without large folio support. The check is no longer needed.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---
> mm/huge_memory.c | 22 ----------------------
> 1 file changed, 22 deletions(-)
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 1da1467328a3..30eddcbf86f1 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -3732,28 +3732,6 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
> 		/* order-1 is not supported for anonymous THP. */
> 		if (new_order == 1)
> 			return -EINVAL;

While you're at it, could we also collapse this block above into a
single condition:

	/* order-1 is not supported for anonymous THP. */
	if (folio_test_anon(folio) && new_order == 1)
		return -EINVAL;

Just saying. LGTM.

Reviewed-by: Lance Yang <lance.yang@linux.dev>


>-	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>-		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>-		    !mapping_large_folio_support(folio->mapping)) {
>-			/*
>-			 * We can always split a folio down to a single page
>-			 * (new_order == 0) uniformly.
>-			 *
>-			 * For any other scenario
>-			 *   a) uniform split targeting a large folio
>-			 *      (new_order > 0)
>-			 *   b) any non-uniform split
>-			 * we must confirm that the file system supports large
>-			 * folios.
>-			 *
>-			 * Note that we might still have THPs in such
>-			 * mappings, which is created from khugepaged when
>-			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
>-			 * case, the mapping does not actually support large
>-			 * folios properly.
>-			 */
>-			return -EINVAL;
>-		}
> 	}
> 
> 	/*

