Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6FB7CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 05:02:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAA136B00E9; Fri,  8 May 2026 01:02:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A81F76B00EB; Fri,  8 May 2026 01:02:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BF136B00ED; Fri,  8 May 2026 01:02:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 890206B00E9
	for <linux-mm@kvack.org>; Fri,  8 May 2026 01:02:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1BAC61C05FB
	for <linux-mm@kvack.org>; Fri,  8 May 2026 05:02:15 +0000 (UTC)
X-FDA: 84743056230.26.AE3BC38
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2A4314000E
	for <linux-mm@kvack.org>; Fri,  8 May 2026 05:02:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ZiEjJs9/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778216533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NGn8E3OW/YKp8cv83Ty48wZxRZDisKcg1p7i+wUnfbg=;
	b=qvEj6a70o3Y7XJyewXi5omYR/Pgk55KR8jcgQZ+P557dzV5vd+H3TVNZ5nbr+q267sb0Oy
	l93gSl0gDf0FVyiBHZFLzljzjOZOSaWR2eOb+kHCoPBmDDGDx3YSJJTu1cocUbrA8thi8v
	97TyMruv0aRQ0PRepLA1QKCTAQPo/d8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778216533; a=rsa-sha256;
	cv=none;
	b=wxw/yV8hhL7swUAcdF51BGjQM0uJeE3owpx5MXtHTcn6daQHgFbN/4szEwHYDATbNzipoi
	kceo2P5uEHPIpfAYoMig27/Faw5TYZ2EkniJQZjhpp8eS+3rrdXm1gROuUNNYRjXfBSxxn
	byiAaPnmHrWQn7IgduyhSIrcFfFaKlk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ZiEjJs9/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778216530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NGn8E3OW/YKp8cv83Ty48wZxRZDisKcg1p7i+wUnfbg=;
	b=ZiEjJs9/2qI7w8l9R5Ttl04n92mAjOpUJv/WlQwgCidzGGC4Os/xomPAQcSSmONDnPkGeL
	JfbTEOORYT2mTncUoDbxWmfPgvDcacr9ErwMkkiiYpQTgitqw91qBpYtWCf+QGuaUrWlDr
	PzNCmI8MSj/9MtNV5dLA8o5l6/1jhIU=
From: Lance Yang <lance.yang@linux.dev>
To: dev.jain@arm.com,
	mst@redhat.com
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v5 09/28] mm: vma_alloc_anon_folio_pmd: pass raw fault address to vma_alloc_folio
Date: Fri,  8 May 2026 13:01:40 +0800
Message-Id: <20260508050140.49010-1-lance.yang@linux.dev>
In-Reply-To: <db7cc3a4-0070-47b3-bcf3-540d0e9d3baa@arm.com>
References: <db7cc3a4-0070-47b3-bcf3-540d0e9d3baa@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A4314000E
X-Rspamd-Server: rspam04
X-Stat-Signature: p3eb81xp63huhe3ir7nkfwarzcb3yoem
X-HE-Tag: 1778216532-870665
X-HE-Meta: U2FsdGVkX18DRwIF2o3+H9/BVUhZikec88O/SdaVGIT97kvnzvd7fl4hPSMq9Wb4xAg29+/DcVHKuUlY4WF7cCsGx0EiS5oka2A5jpKDpGkBPSGhmFUTuR1hym8ipRzShooku0y7veoHKM4Skt/3wCAzduMA3odt6BgXKFpGDA3q/NhRiRlwNvhpVRcCQV0LIVGWugALfNakRfeSw+GgC8Eyh2GZkaOHu4OWnXlhm8D5ukOT6BcQknwWaiH9rodgmkbo9YCvfAeSovEcGFEsmRMJVxk7EKOmsbrJW/EQ0753i+Vij7YSkhP6NWKYDLpkQ/AHjsZ4l4iMR1ETEjVy/7KY7ZVaiOP0CVV5NSFaVVv1pJa3SfS+yiDnIFSC9wgNNon9CZpWtedrVEEhInlrC7z/oCJpCMPZ1dxGAhCdFTr5P8kRczgKWhC9QHqtxawEuewbwVE5kxiOt+1sUwDERXulWIZHyXUm7QQvFetX77FoUNm6gJYY4iqLUHuda5HedgaBhJTvb+pzfFDqzvM30WCV3SekbM9YsA3tIaaZju61FmPplaPV7ccBDCPyCi3VrEcSVFuamMnzJJSKuMrbruEK9ceIObFiXYeLNX1itzzTh/+eSSxz96og7hLcBVZVzogxf00AERBPjEYgS4L1dvtHvF3alrNCjnj9AclVgOGmt0uDlirsMbX4rDK6QxgPOUUXzgj4MC4ou6zKYTQeFsnzTbBXgQ8wubDEVlvYrOYzUPpZEVit4SGRu3caTcMvvYWS5hrEGA2nZOybcyIYWeCbDE3HdE4kybqB2Z1tn9AuvHYos8vZR7KSlF/y8lNWtMoSb1UFEMWUXUtdqzJ5ZC5GtXq0qANe2SHjaloYSEAPAHCESaGFlNapz0kdek8iNwn00EoCQqbfapllmrg8wM5tAwA/O+JE7UNUec83xpObhG+eSBaW6hzf+4qJZGFFo9TwANV3jpDO4G2hp+v
 jC6kIyWQ
 SFXaTLx9WBvOkgc7+SgjfAOXQSnL4RllCHuRq4SlGNi67BIZCv9EhqX5p0g2cb89Ys16x9fOK1dk0+1tmraDNzmmctrsmSio0FtqSkBW5MPG84EuliQFmt4CXPJW5tNCWPNOXIdExHAJrcjwRzWs9aOEl82cQX/okzgzkJPwWAH4EV6zocLFu392rmqi07QrKGICEaIYzqUnDYbvpPywVfeU3TB9TsJgp4anBZ5q+RjBxu7I+WOHVkgj+Z20QUml3r3Y2Ue/z2VqLqJRRIPpvS4jM7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, May 08, 2026 at 09:06:22AM +0530, Dev Jain wrote:
>
>
>On 08/05/26 3:52 am, Michael S. Tsirkin wrote:
>> Now that vma_alloc_folio aligns the address internally, drop the
>> redundant HPAGE_PMD_MASK alignment at the callsite.
>> 
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> ---
>
>Hello Michael,
>
>Could you please send the whole patchset or at least the cover letter
>too, to everyone CCed on at least one patch? I only got two patches
>from the patchset in my inbox so I have no context :)

Agreed.

The missing context makes it a bit hard to review the individual patches.
Having at least the cover letter CCed would help :D

Cheers, Lance

