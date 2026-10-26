Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E9E6606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 02:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=an6otOFp
Received: by kanga.kvack.org (Postfix)
	id 15BEE6B05B4; Sun, 25 Oct 2026 22:35:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1345A6B05B5; Sun, 25 Oct 2026 22:35:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 049296B05B6; Sun, 25 Oct 2026 22:35:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D7CB06B05B4
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 22:35:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 588501A0647
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:35:12 +0000 (UTC)
X-FDA: 85363210464.30.46B8518
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id A49D520005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:35:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=an6otOFp;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792982110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mWS6nWjGDo/ShzQtH2Z3nfuPDKs+D8p78VoAXukz7ZE=;
	b=eJF6fnu3NRKls2+jUDUCRo0V6yG+rx9fifgxTUxnKwSuY+YyyBIayNo4FJ72E57kPCvulD
	O6TWWx8wlTkAWd094medm1uT/qdPvcyyLmRnzAkVOxrJBMKh4rb511hGBKUE3QG09VSOUI
	HOyGVXHgW06Xrlbp8O6oqFsyMW47cNE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=an6otOFp;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792982110;
	b=ikb5YF4aP2YuGcM0gpoI78f8YPLdew027raCfIVTGpWHjpnaCUCRdup5X2CprqvqrcktCN
	I9kZI8TkrBJ7JxSi5Ko5RFnesU3iMAFpo4wQhLfbBeNfOjmjc4e5yp5bvrqCEIL9IMeIod
	rZOl1oOclE7lRqw3ZzQSB72HFq19R1E=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792982106; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mWS6nWjGDo/ShzQtH2Z3nfuPDKs+D8p78VoAXukz7ZE=;
	b=an6otOFpm9bkyCRM83PToZx2trfSF+F6lQfrSsV0M41SNZIGpwfhmtbUykmkmmZZ6kpq9BEHASMCRJxqvOADpg/a7kjtVrYny0xjqhltbFKbVngV/zGNNsSCeoAJA1mTHsVLnCjmhDLH2HHtsvzTGuIDL0Z3vQmkjcZPdne/KnE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XDRbIb._1792982104;
Received: from 30.74.144.181(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDRbIb._1792982104 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 10:35:04 +0800
Message-ID: <059bce48-c591-4bc7-9046-de03fb4df748@linux.alibaba.com>
Date: Mon, 26 Oct 2026 10:35:04 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] mm: multi-gen LRU: remove get_lruvec()
To: Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
 akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: david@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, ljs@kernel.org, kasong@tencent.com,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, baoquan.he@linux.dev, yuzhao@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, apais@microsoft.com,
 rlmenge@gmail.com, Hardik Garg <hargar@linux.microsoft.com>
References: <20261021235606.89545-1-sidchintamaneni@gmail.com>
 <20261021235606.89545-2-sidchintamaneni@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261021235606.89545-2-sidchintamaneni@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A49D520005
X-Stat-Signature: nk4bzhwicbmcuwrp4dz7cc5pxsdsimir
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792982109-151090
X-HE-Meta: U2FsdGVkX19A4eAm/i2TMO9Iu6+/asUyfgzmGRYE70098NTsI1M8Vs/+PvHSkMcKQIvdIRLsp+2WQp7UjO1/0uwBIFtem9pI771vevYu7a4yRLOy1qOlqg/0qRftpZzkEASXSfZB/mqovNLhifzFOnxLYH1wQhaIPzWx/p+UXgEaESdig7knYU4FX1qczaWzTeu5M2blNsxop2pag9Bvh9QpcRXudR5XNLptr4rBUUjhHX4wr2oX1Ny4SMnbRnsxrGwgRYlb0UcCTF7Q+C1lNgrmcvXa+ubPsbaRirYA9Os6O3ZEbIkJKCqIkrjHhS+pXbelU53+98zwc6UXIKKiBPuRmabjyp9zEyoeLYUCR4klqsLh+S/M8UybDhoc2/hKk/I6u8Rm6E0obtqEIvafCDn4aRhK8YVFzoCB6qem0ZVjOKHSmYM3hk/nVfQs/uespdl5zeSmrS0kepp/mEjhKqLvEOlKGXC3QYp2xCLTBkikFu/zxxaKmMIkVpxrrJ1pM2+ZT6Ne1aNPdeRVFofIcSvK175GdM1LOZYvquYJFD0zllWhbsI8tUC26qQ7cxFqecZqNDQ0439vRiziQ/bo31wOXcnM4izquS2RUw4blLCf97ZKlouPHSvrL2h1JI1JLP2vRvsc7BjcuiFLsxh4j2tOl7CsYVVGXM5yShQuqFFObbfbhXRXjv5l92RN7+mVWO6jx88+HiTDCAAACh0luWxq8RqPvAor4/0GOv1MywUoDiTl3f+zdaUpv4Bq46ImmGXn2ilbuZzt+i6z65FrVKq1/lE1/jXVCgVNiWolVbFHDVRsxxn4HdwMJEUsGrMNqDVeYd5j/b0QI+Xm6XjP2Ue0CmfwMpaYLFdTbhjRSOPEI81yw00FxXJEUTFzz+9kixBf917UqG4FMDU7aGRdoU8r8Y2A9vMMZImmYIJJeukeV00kL5RDoy/0sDNq0o/QFVeNSAE7gH+YolojPSk
 /fIbk/ez
 u5Il2Aenyr0IDHGKLc5Wwlp40GG7ZvYR+qgNC2cNw2YS5EpEuEnsPw7x1K/v8EBStlQq/fohH2c7j+xi/+FRZQGSrOSpeOK1jo1RfGeFq2uVzCi6NHLj2mH3f/9Sv9+WY0Vy8UlbCjGN6fs3x/WdIy/NTCOgwHTYz08Hj9qV1rKGjW186To269RPdXke0fgHuMr6o4bXsU9/zIb2GeuKScq7HIdal5Mvcwo5IB/yNdoGYlJ/ykmiEhv9FsjbzqKOrK9Q0Vw4N6gcRrS3ePodsS1zHI/CMUMI7FrFDIm1OucMA6rhhOjKa3RiLL8/wOoIsusWzYCAY6p62qwK45QnaAlJVfN+1k5SQs1D4Q5ydFiEiXmWWfEitzsLmAuBsju6nSwgTDxpJipFvFXPpcW3gqsoDgIc6on0yfCOg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/22/26 7:56 AM, Siddharth Chintamaneni wrote:
> get_lruvec() was originally introduced in commit ec1c86b25f4b ("mm:
> multi-gen LRU: groundwork") to guard against NULL NODE_DATA(nid) on
> uninitialized NUMA nodes (`return pgdat ? &pgdat->__lruvec : NULL;`).
> After commit 09f49dca570a ("mm: handle uninitialized numa nodes
> gracefully") and commit 931b6a8b36a2 ("mm: multi-gen LRU: remove NULL
> checks on NODE_DATA()"), that NULL check was removed, leaving
> get_lruvec() as a thin wrapper around mem_cgroup_lruvec().
> 
> Remove get_lruvec() and call mem_cgroup_lruvec() directly at all call
> sites.
> 
> Cc: Barry Song <baohua@kernel.org>
> Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
> Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

