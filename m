Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3B22FEA834
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 08:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 438836B008A; Wed, 25 Mar 2026 04:50:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E9356B008C; Wed, 25 Mar 2026 04:50:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 325EE6B0092; Wed, 25 Mar 2026 04:50:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 24BAB6B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 04:50:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6E31BAF19
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:50:04 +0000 (UTC)
X-FDA: 84583963128.13.D0FC932
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 405A240003
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:50:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qCvygCAF;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774428603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+LyA/etvI6/gdSuycdzwtgJBfhZvqU4U+o7jdqmeRmc=;
	b=V3oeuTVMjfytwQ7hNrG/2+0WT/XWDdRIUIlJZdq5uk9v2DkmDOldMAXyclWcLINq+gasBu
	yjCWbTVpbDzcD3/cL9OTu+2/eoPC3KSH27TYI20I8GJ9tNNpOfLbO1ps4lb6Pm6pJCWtRq
	qQPQKhZUTO6nFxLzGsc/Jl+35guwGHw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qCvygCAF;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774428603; a=rsa-sha256;
	cv=none;
	b=dzSQE65EThLDG0QKJXZYxCKlnJcfd9MSJ4o9WhnrkodTGJXI3yCFf3Bpb8nKRToxhNN0qi
	Fko3D0TdhPi5TMgummSWS0UYj4sGITD0QzAi8mIlu4+Qd90O1iSIJmM65m1rpN5PoxPNyC
	iHUDPBPkQPOjj8S+t1FpKFrHLeQDwNg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 638CB43C60;
	Wed, 25 Mar 2026 08:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC77C4CEF7;
	Wed, 25 Mar 2026 08:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774428602;
	bh=2OtW7QmiVigTTK06LISL3S/tZBy8Ab6IzToCMPrG2QI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qCvygCAFXRT4PUtLUGkctheDZeJvsmkkNlvGwTtOfZTeYh+7PcP5dK2AHTFWlzs1k
	 8u1zaiLL/xbbvX/nUy+xWmExLkC2lY0x+B3xromtO0kZvFcVqc0rpxiWkITihqhkEA
	 GxJb2iydrvQ/4YLqdEYnG1ydabKkugvoOJQR2RKrkmmOQuZ1lM31WOc6LmnwfreCm9
	 uic95so6GLb/ms7TIgVBFMR1cgP8PBS91l9uAwk6aUbZzB0hzEQM7CHWfeUcHJLnJT
	 +bOx7vnx4wlYbzrXN9aYxdX9EHVqTL0VeOg6P5gjRJxgrXnw2KZAPmTSqJpulX5otV
	 FM6y2TC6c2iFg==
Message-ID: <af90838e-bef4-46d6-9bc1-c6185793ea62@kernel.org>
Date: Wed, 25 Mar 2026 09:49:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/userfaultfd: fix hugetlb fault mutex hash
 calculation
To: Jianhui Zhou <jianhuizzzzz@gmail.com>, SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, jane.chu@oracle.com,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Mike Kravetz <mike.kravetz@oracle.com>, Hugh Dickins <hughd@google.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>,
 Jonas Zhou <jonaszhou@zhaoxin.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
References: <20260324170311.dc5b54fe0765f2e680e3cc90@linux-foundation.org>
 <20260325010618.85366-1-sj@kernel.org>
 <CAEgWzV5vp7bfr8=W6aVXNBFqxd9nVc-BGtG1jFUXJ_-+WWmPPg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAEgWzV5vp7bfr8=W6aVXNBFqxd9nVc-BGtG1jFUXJ_-+WWmPPg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: jp4qbyg38bwjqd6amski8cyyow8yxnhd
X-Rspamd-Queue-Id: 405A240003
X-Rspamd-Server: rspam09
X-HE-Tag: 1774428603-590216
X-HE-Meta: U2FsdGVkX18BW7/wZp2jTgNUSbnC3U+PjvnVQnB5R23EVex5W2a95e0lbn+o3syieRE8V/7BSXkWO88NEM5SWmnLOAP+a4u44bv67N9rjyFU95E018Zo4EwViV2PuwbI1kBcVTQvIsrWEbLuuAcUZ1JuelmarxUVMAee4gLhxLL6UiSyyB5SKEN7v883RYbxCDolfxH7OI/AW7l4QlZP/9V+8PZDnmecsxkMqrkjua3Rvn12/0L2bbMIPny340QI86JKE0WxBfYgMHVeskDHJl9Ocipv9eG1QN9ygX/GqGki5RGroC8feMW7lgo17yti8xV6WxBSJPPDbsOYhjpOGrdlMmMpCrUUZoxgcTL8cjHPQa4dUC4tBAJKcd2D7syVCynFhvTy3akMZ+NeKC1hpKCKUSjegdH7ZNfWt1jutxbotOpvjVfDw6cxAtMM9N3f4Bo/Eg9M/3dMmNZdntZofW5FTSfuEZ8PZ0TNXRUWnIesz/prOU/vb06i3ylbrv92Qx8HDFq+8BeZwTarV3jQ0v7gYk0JZmzwUrcKQvIBAVxmXmcgTDEwCR1AMa+j3FnaIjj8IX8Jw3R0WuHmGlFQiXMyhFI8MHq/I8tLVR0weW1rPjtO/MvW2d2JSZnoW+KE+8+tGaEsGYMoVTcV3AlWsde8ApCiPydtS4DTFjZN4maj4zkgoz7fSS/FuUiogddEPZhqyLYdt3PND9S8ZHvfKeRlujr8tP7EUbpCLScNC9bufncOOwB3M8kfG58KcNeapoV3xOooVUTylUwVYErHiLRAz71Taaq5hRgRmqhM53KLoAw14WOgjx8ezaKwgMsomCvtBId7idwemgqmdrYMH+HLXSVHY+kIPUftNI9SCXYHrmRNFiIQlva+bofn85VGDNlNfj2ENDBmEe4U4warUl0aKMlWoCAZMj1mgeYUdd+jSHQtQFpamUR4YNgdB1JgN/jekefjEjwc5+YIMUa
 wU9r6YET
 ZbOn70KsiVokGpK9k3FrybKaPnwxoMlVSNifpC0Il0mKza4QNdMol/Kc3DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/25/26 07:07, Jianhui Zhou wrote:
> On Tue, Mar 25, 2026 at 01:06:00AM +0000, SeongJae Park wrote:
>> Seems userfaulfd.c is the only caller of the new helper function.  Why don't
>> you define the function in userfaultfd.c ?
> I kept hugetlb_linear_page_index() in include/linux/hugetlb.h because
> this is hugetlb-specific logic, not userfaultfd-specific logic.

Yes, and see my comment about either removing it entirely again next, or
actually also using it in hugetlb.c.

-- 
Cheers,

David

