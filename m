Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62E41F8FA79
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 13:31:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5A3F6B0089; Tue, 21 Apr 2026 09:31:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0A8B6B008A; Tue, 21 Apr 2026 09:31:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D24F6B008C; Tue, 21 Apr 2026 09:31:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8C6A96B0089
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:31:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 429F48D414
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:31:05 +0000 (UTC)
X-FDA: 84682648890.13.1CA4D72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 508A01C001A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:31:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NEsAvZlc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776778263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EiQ721oSxJL+49kCE3KBrAGEyXh+20S6aF8xBPikaGw=;
	b=MI4KCFdatY9SRbLiYAx7TFrlwvTb8m5+0BonzPDDJJCQrikpFEpV2dR6CPWNajT3qnlFPj
	/IEx2plCddmRnUz+CAshgBff6YPxdSQreHVqGY54lM2S6BPCZyI9XBq8j9ytmNppxsO9P+
	GKojZBD18IaXN8vcvjB8Oyz2OF0ok6E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NEsAvZlc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776778263; a=rsa-sha256;
	cv=none;
	b=fABFtF0Xubk9lAaJ4kqPOsSpQStwEW73B0eX1gcQSq7rie5ufXZiZ1yRW901voh5YkdWhv
	3ouNSfgCeUIa4EZcDiQ7lfj4KCgqVAksoYUsAbkADrbmJnEVnVoHxRx31Cn/P6qOLEQkXp
	H9QZkNhTRkJl8sLvb7nNvmehaLwkLn4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 48F2643BD4;
	Tue, 21 Apr 2026 13:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AADC2BCB0;
	Tue, 21 Apr 2026 13:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776778262;
	bh=RAnacQScZk2HHf5w6dSElvYRXNo/zrEXc78IP1F8X0Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NEsAvZlcX5SJrk4ZR0PAjMGRcCWJ8os1LWUsvz29bylZrF8QKFGl7xapm9gK4L+fC
	 xEctGyT4KI+2ilnvqq7+6Ym5FLQv4awJ8NqeA0fcCZYK2QTGr+eP9loiXW3fxlFZUm
	 BUrR0oaAopEywO4Pd63SLRFcJT+QKK2C8D/kccePJWwNrVVduP25y4+EkgZ1pABrW1
	 i3prujydQyAbHLpiT5d4Hy+zpLbtx+lIHzfODQc41nLlhtxIc4ti1TsNEAdKOwqeKx
	 51aZZtdWKJNY9AISWjV3C26bT2UTlukbzYoACMQ8RMZZrV51uI7eAt/+hbMD4zQ3+g
	 74WXBMT3hHM0g==
Message-ID: <2a41dd0c-7ad8-4d34-8bab-a713e16c3b29@kernel.org>
Date: Tue, 21 Apr 2026 15:30:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 17/18] mm: add free_frozen_pages_hint and
 put_page_hint APIs
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>
References: <cover.1776689093.git.mst@redhat.com>
 <c7094de807c0e963526686e1d245bc76193b1a92.1776689093.git.mst@redhat.com>
 <5f76af6e-9818-42ea-a305-c0fc1d920dca@kernel.org>
 <20260421091546-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260421091546-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 508A01C001A
X-Stat-Signature: 8cfqrx4qgmp9fje59gxysnbc9zdz4bw7
X-HE-Tag: 1776778263-16042
X-HE-Meta: U2FsdGVkX19r74DXcRw2cKs1cyc2yakuO0X8YwKuIhD9yDNchezNxhU4SresqHSl/cffN1JcxKnSFmtNADpx6X4dgJVFmx7OPcYXSV0845PniptlqX/V1EFetj8nvk8JFNrKXgdfqC5dN3yi4xL2HInVZ09boOMAoKN2W5A42FBRvUsNB1UDGe5D+1Y6AqfgvRP30k0bHT/KYlcLGz4NKXHSudRi0wd/ms4DKTMR334+IVicp88ZJnYcu8IADYHwjtlxKSazQMDxn7D3FwWRkHvA4PTPhZ0ixRBbGg5FVtl8Hv34y/Duwh0Qnyaofv9lS/qh9IAuj1ixVRO/uSnFigvPHMcJCg9Ihy7SLuD8Un4HBX+e7n8Mo1KYiUurE7p0CJKVLnhtDMTQWI5QBtuY+SavJofO47pbPziI3lQ2pmRmilYKIkijtUn32h42LCPeu9fdcyYEsjdnxoo4KgdX6fXqXJpSikSb7fEq7/nxvMH09NGiZEzPymaswkKWrVLVWmep209Oy0t5AlHYDfvN861SPdMw78MA9xeXaryIf5VWPyI6qLeAvrsdWJUw/aSyrFE6ICSml3WyXpCvDmBFMIPi7jQC+isY1rVnUv35xwFRUIMrU5cR2vNMsfSglrw5Lb0bJWB52XUK4u2i70eswxBkLSxji9DnBJ8SHVfof+G8LZku3j/E2ovD4X90xxXREm1jmT+m1qc5O/wRxZj9zjiK06aTcUprT119dBlaV9B8IOjxjb9iadPsvgx9NLTXqRVMzuul++MH/EONTd+yRsn4m++N4M0TI1/EoIjvPfWg2ihBZp2WvSZAb0rYBTtEz27xZ8jqfFXNInarY+MuKUehnUe99omk8wyEGVzapKbz9KZJQMFIEhQEQQcQcFEJ170vZUZtHqMBfAvYdlwFdh5WAvTzisZrzSFa0zfGL1C0AoTiec4Bk+dCGaJOJZ7oagi+VM4zVZufQs9HdyS
 8VtD3zzE
 lwLMq1t+9sw5nd555n+jL/0Rm8ZZjBG66N7HyoF4WxqiRStY+W+qTMAS6sD6KskeZk5BWgg5aaw/scbu3SHqRYKM2kEpNdtFx0Y0MX9vjDK+6E0rqwRVfC6dzNH0IOHWsKmC71+tBUXfAc87qd/rx9GKP6squFxUz7BX9nd16KD7ezG726enmlE8bCL2EdOZ15LU7+GB7y7XT/K9OcNYtPomBLlqTssZjlyF1rb1HASaek1AuzgfuBZ8sH3HSay/K4b+nbhMbOcugjCjh56dA7ylMyz28WQ+x/phxWd2PXdlgge1Z/UxlW1drYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/21/26 15:16, Michael S. Tsirkin wrote:
> On Tue, Apr 21, 2026 at 12:56:00PM +0200, David Hildenbrand (Arm) wrote:
>> On 4/20/26 14:51, Michael S. Tsirkin wrote:
>>> Add free_frozen_pages_hint(page, order, hints) to free a page
>>> while marking it as pre-zeroed when PGHINT_ZEROED is set.
>>> The PG_zeroed flag is set after __free_pages_prepare so it
>>> survives on the free list.
>>>
>>> Add __folio_put_hint(), folio_put_hint(), and put_page_hint()
>>> wrappers for the put_page path.
>>
>> Can we defer that change?
> 
> We can - it's a dependency of the balloon deflate, which you asked
> me to implement. I'm more interested in reporting, myself.

Just to be clear, I said:

"I'd assume ordinary inflating+deflating of the balloon would also end
up with pre-zeroed pages. We'd just need a (mm/balloon.c -specific)
interface to tell the buddy that the pages are zeroed."

So while I think there will be value in that in the futur once we
figure out a clean interface, I don't recall asking you to implement that?

-- 
Cheers,

David

