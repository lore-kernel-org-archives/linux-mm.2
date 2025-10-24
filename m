Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95066CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 08:31:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFC4F8E0059; Fri, 24 Oct 2025 04:31:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD3CE8E0042; Fri, 24 Oct 2025 04:31:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D10EC8E0059; Fri, 24 Oct 2025 04:31:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BEAC88E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:31:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 594A412A16E
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:31:53 +0000 (UTC)
X-FDA: 84032339706.17.16493A2
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 566D0140008
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:31:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VZQ8BcqV;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761294711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=que4oKIU2Y9paKeWcPbyLqkBz0QggtLbLzwslhxaSPI=;
	b=iM7BMnukEcOCNrCTQIHooGVTgHTPetlYft9/ZGnxj2uCDsnQ+Zn/LtvLQW3k/Td7EIk0z7
	p2MpfU9mZ2sEl6Cp+RCezLBvw0egA/ql33V+p2w3NSvNtRIpPCZgI15nZwP05jR52+mN7Y
	05fKbUjNhQ+yJRLvFjyyQ70+0WhE/rY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VZQ8BcqV;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761294711; a=rsa-sha256;
	cv=none;
	b=FC+dl9BIXEHwk3J8QXkedscbEunhwvNdUH178TGhovPMHnO3EY3Xy1qcjc5JyNoffCQfIJ
	XD74ea/TxeWTYVSHpRG/CMidYGci4H2Fz69I+FNngVTAK2j3/BA2cW8Lwv0LtJhdb+//Rq
	Dkxruo7WHeyvzZLjyGXy45FRH918D/4=
Message-ID: <44310717-347c-4ede-ad31-c6d375a449b9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761294708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=que4oKIU2Y9paKeWcPbyLqkBz0QggtLbLzwslhxaSPI=;
	b=VZQ8BcqVSWjZY2iooCLrZafVjkiidx7JhlHaZvyQe4SfVPp2KDJ6V6C0JsD/uvctrakrus
	xbl8zcgGoAGL9fGd/v8Ihz5Cq3/ZzncmdV7575MlndUnq6/G6FESI40c7xsoFbUyVa/MAo
	bnJ5ksjpU60HpmsyvkIVn1tOhj6UF+k=
Date: Fri, 24 Oct 2025 16:31:30 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4] mm/huge_memory: preserve PG_has_hwpoisoned if a folio
 is split to >0 order
To: Zi Yan <ziy@nvidia.com>
Cc: kernel@pankajraghav.com, akpm@linux-foundation.org, mcgrof@kernel.org,
 nao.horiguchi@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Wei Yang <richard.weiyang@gmail.com>,
 Yang Shi <shy828301@gmail.com>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org,
 linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com
References: <20251023030521.473097-1-ziy@nvidia.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251023030521.473097-1-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 566D0140008
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: sseom3sbpsd5bs1cg8dgr6s1swpjmhcg
X-HE-Tag: 1761294711-810458
X-HE-Meta: U2FsdGVkX19NMdncbjdpHocp1+JakeAhNR9D2klSWRPA49hvaa8VyaGfTNMIOpnGW7LbUS1hfcQQKMUElb2lH4vo7o8D89eRW3ykNgiiGxCNX2Yxix55XWmj+N5eqrveI9e9LbL4By4rLPjWPdwFmGMv6JxY7BxdBtvzddo36wpMtCqevdXyPz7mIhutfBtTKEJKBREsanBxMRuLgoi5SDiuNMrYyd1yp1sQ2bonbOPKaR/86ESq7/mii+IK5sYDVEOBykkiYB2gmXrShkExoCnvxmxKy46jCFDV0gGzlok1a8n8rxQiVD+Oq6mJoZOWFXtuJhV6+XvkwGWhcMKBVLaolnKog1Sp4MlAQMor+dwqvhtYyatgSUG/ZdYG1FVEw04/vy713yXn6Syoor/ezrO6InZRXCYwlqkrtggFDGCw68t7OqrzKdarG75ghH81yzFLl5IQ3FwDLyaUYytj/yIFF/QvCLTqJ/cprLYJWBkbcP4JzIrmbJZZvUycubmIW59n7E7XxbtZBjoVKeZcT5xrutRadgSKpkbLo/7+mWfARcz23tJ5aUsR6Av8hRzjqU9hAOEy/bsbVcPp3iUzeTV6/ScxTNR9eDK/meikht5MiO39MoHAyylpqcEpNQHKk8wCBENcKXI9X7M0PBpDP8a9drXZpa42R3v7XWll5zG9yS4VycJKb+190IbOiQJEUNoTr+f8eFKYQ475nLgdQ/+mM0Y9kTm6bPFp2iQTP9WGyNdCNHMSrxPFvkZVaw2AqyjimjFLsfzfxzVfY4Xy3GE4H40kPh/AjTYpXw7AQj9wYiQ1rWRs0jNG8VrYIFW2Jh6zV2lF2NYI63Iddvi+ebXMU7d73bFie1kRMi3bf31z3EWlQkLZpgrTmu4rKvdUgafh/C4kE2zyTiiMlNFOsBsf8/r5QFiYUzZEZXDTPbWxx1R/QjZvOq2SorIGIYjn/BchzAGjh/ll1/GIc3o
 0WgFHoJG
 WLNn5dLTov4LYrnSIzji+uZ70C6jhuATYuKHiVorta2wzwtxBPw+XoSTzDITkLQwMLKoUowyg6T6lZ98sqgkh3cHCeBgH+wpCuaBVNAAlnkoKfHW+1VA449z8xhnQN7RFM4FTZzlvvCDaIeU5uZ5f5/MiTKQewnRB5X01DQ9mqKJnuwU03Vlf2qRuc6w13GA/Mfat4tdch3je5osB/FN3ZdOtzps2pD4Hj0z4wrrBGY24YXtEPer6EHbdPR+s/CRw9wjFaIRRNdT2v2gkHw+hTrabzeEt5KbFU3qmjqfi+u49Hx9lONr5aTQcCX69RqpuOFdGeJPuq3CGPCbyEp68bOu1HZyJYDRFSEpcCtJkrRvj/7o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/23 11:05, Zi Yan wrote:
> folio split clears PG_has_hwpoisoned, but the flag should be preserved in
> after-split folios containing pages with PG_hwpoisoned flag if the folio is
> split to >0 order folios. Scan all pages in a to-be-split folio to
> determine which after-split folios need the flag.
> 
> An alternatives is to change PG_has_hwpoisoned to PG_maybe_hwpoisoned to
> avoid the scan and set it on all after-split folios, but resulting false
> positive has undesirable negative impact. To remove false positive, caller
> of folio_test_has_hwpoisoned() and folio_contain_hwpoisoned_page() needs to
> do the scan. That might be causing a hassle for current and future callers
> and more costly than doing the scan in the split code. More details are
> discussed in [1].
> 
> This issue can be exposed via:
> 1. splitting a has_hwpoisoned folio to >0 order from debugfs interface;
> 2. truncating part of a has_hwpoisoned folio in
>     truncate_inode_partial_folio().
> 
> And later accesses to a hwpoisoned page could be possible due to the
> missing has_hwpoisoned folio flag. This will lead to MCE errors.
> 
> Link: https://lore.kernel.org/all/CAHbLzkoOZm0PXxE9qwtF4gKR=cpRXrSrJ9V9Pm2DJexs985q4g@mail.gmail.com/ [1]
> Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Good spot! LGTM, feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

