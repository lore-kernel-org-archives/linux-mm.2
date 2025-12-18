Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A65AD68BD4
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 03:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EA356B0089; Wed, 17 Dec 2025 22:32:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C1C66B008C; Wed, 17 Dec 2025 22:32:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F83E6B0092; Wed, 17 Dec 2025 22:32:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5889D6B0089
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:32:06 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC88F1A0CAB
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:32:05 +0000 (UTC)
X-FDA: 84231168210.24.B396246
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id B5EE2C0010
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:32:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ow4iXfp3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766028724; a=rsa-sha256;
	cv=none;
	b=xhzFcGA14BKf5APp7doi43Y2RtK2q86CETQJ0QN926wYqRcxNKcwwnOArlqNA3PQ232Ojp
	5gWRVKcJ8AU26ZvpGTLw1/RwREqCBpKX/WF4bZXoVesmFJ2CXlrSHsu9XJtpVYFsk6c7w8
	369GxhxCFKMOLGZESu1/0D5CtPKtCLs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ow4iXfp3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766028724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UsdkpPRWds07wTB0hbxgdZlH+FRjloYj0TiP13tyXec=;
	b=DUl/cLLGWVkdsFu9AlvNCKEDmng3iF3Gifq8G0Zx1kl8pA+iyTtb/4FV7tdmtueedY+ns4
	VnxS3O+fZy2Bzna1Zg16OSM0DTdj4gLdu2bb+HMmdoTXASLgOjcPDhVvOqESSzyLATyOWz
	Q2r0r9dNb6A2QoTrSxTyV0PmZ8RqvHs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766028722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UsdkpPRWds07wTB0hbxgdZlH+FRjloYj0TiP13tyXec=;
	b=Ow4iXfp3M+2G9bxsqXIc283C6nLOCUIUb3dR0a0qZ9KSWLqmxuODvCIcYzFCQHnq661wvc
	9b/e6QtBw8n8zffgpecPJ6ojhQymWvabjE4E8iWjyc+qFKZfSgLWcUSqFTL5LNRgxJVVf0
	VsevDtaSNlEK8b3qVH6WPwfXsbEhnFg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-r7BxuS-nM3CihuZPqJZm1g-1; Wed,
 17 Dec 2025 22:31:58 -0500
X-MC-Unique: r7BxuS-nM3CihuZPqJZm1g-1
X-Mimecast-MFC-AGG-ID: r7BxuS-nM3CihuZPqJZm1g_1766028716
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A36C1956063;
	Thu, 18 Dec 2025 03:31:54 +0000 (UTC)
Received: from localhost (unknown [10.72.112.95])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 35F2A180045B;
	Thu, 18 Dec 2025 03:31:50 +0000 (UTC)
Date: Thu, 18 Dec 2025 11:31:46 +0800
From: Baoquan He <bhe@redhat.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v4 12/19] mm, swap: use swap cache as the swap in
 synchronize layer
Message-ID: <aUN1ou9otdqjSRls@MiWiFi-R3L-srv>
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
 <20251205-swap-table-p2-v4-12-cb7e28a26a40@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205-swap-table-p2-v4-12-cb7e28a26a40@tencent.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B5EE2C0010
X-Stat-Signature: mmh98kxqz1h3wch4nru86dsc8q9rjrzp
X-HE-Tag: 1766028722-878921
X-HE-Meta: U2FsdGVkX1+0Vzky5xeYpu8gzhYASRJUU3OsOiLUtgwOtVMMkC7RtByRQS1+q4vxZmRJCiprXN2joxF1E3aNyhyOkb3ZzkLHMU/mPJ+Ez2YEREjwm9diHishcc6cTfSCqxqHZleDkPnhckeOfpElAMPyNqtdg5yx6C9PQAaIMxdN+fTXbIc6RLQglboXsvD8uR0eyypZrCDRogbQ5DsZjAxxMOjf3vPKEYBAGZ69dIzIQF+utC6DV1ca9pVtk62ZbupemxcMTTPsRQBSOKAIBLIOMtwBVoxo69c+DAbkighoREfcBstfxuMSZeCabrVkskA8YasQh0lAKOHBC9cFg/Ut9S/O6WIFTnvuEfC0RzJ6zm6hd0HtzDLuDVBdsYdpG90LmT/pAN7RUBCUGGkEOqM4rtn3HQkeISIDCVf4NZn+idQ5lSV6Scj11mKVeRFEwkjwm/BvN549uyOe4/yGHiTqdS5nIQ/P/5pCsCYj59EwsxroGLWXyxu6pDwgm6Cv1hlldtSaSccSDX0S5K0D1kw52xW2hTRF4AR6ZxaQMn5s84ps4uLmrUSs+ZAPJJPxia6xUOeO3RLsKvDdm1hrrcocmw1HRiwCnxEbhzLslv8rqX7XACEgv3afbj1PJ0VcYOiH7Nw/1IwA77HXirlTYtnNKOXzytf0GZl9eKrp/+hWC7IYp7/Z2bWxw2tlciTpOtrgHIuKn02Mhn0iJ2fJRwsvUSSR9Gqkdv7G2WfLzrppQenLL4k4jttO5HsdTmK33Pj5QHiAKE3t9JuuXggorZpju/lkfgOTdpE1rMtYgEgpj+I7IVVLQX7bNaoX8DDQIn7LuY25jjqa5n04pfQY/9WwH4AGODI/0hnwA3Pyuozc2PZmOUbk60SXaKc3QEYU5Y4ndh3N34oB1pu6PbO/rnQ4yJJkpONXhcKWPXXRKRb5bjwDIZSer75eLCSfP2cJ5kzH4j7ENK/i1F4uG4y
 ize9Ectv
 Bdl5JLBiZgXkzGXa0qZB3adYRuvYCOsZ+qbcjy2q51ndCCCvnIMp7iF7Vsei1upg6Q5b6eSCpzqAT0kM2Joh2Rovdz18CWppY5bZnqY43GvXVYQA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/05/25 at 03:29am, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Current swap in synchronization mostly uses the swap_map's
> SWAP_HAS_CACHE bit. Whoever sets the bit first does the actual
> work to swap in a folio.
> 
> This has been causing many issues as it's just a poor implementation
> of a bit lock. Raced users have no idea what is pinning a slot, so
> it has to loop with a schedule_timeout_uninterruptible(1), which is
> ugly and causes long-tailing or other performance issues. Besides,
> the abuse of SWAP_HAS_CACHE has been causing many other troubles for
> synchronization or maintenance.
> 
> This is the first step to remove this bit completely.
> 
> We have just removed all swap in paths that bypass the swap cache, and

I think we didn't remove swap in paths that bypss the swap cache, we
just add folio to swap cache in those swap in paths where swap cache is
bypassed.


