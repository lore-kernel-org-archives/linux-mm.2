Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C231CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 08:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74DF56B0088; Thu, 14 May 2026 04:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FFCE6B008A; Thu, 14 May 2026 04:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 614E96B008C; Thu, 14 May 2026 04:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 518746B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 04:11:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E65608DA9A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:11:47 +0000 (UTC)
X-FDA: 84765306654.29.64DF3BE
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0DD9240009
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:11:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=go8Hfoqt;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778746306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7d8pBMwlUmT1b6rr3QpvI3IHWFd3qcPl+TOQyqLsnxU=;
	b=KO39IgVBQKMWkXOLZYTspRxmP2BKOrPqREVgBTuHGCu80501r6+TjKf4IYlxax4hk894O8
	pX4jxDtWqFf4jV+3bRDlAorrocjEZnj6kl8QmcKNfv4u5o7egMm1NhXWiGg+9HfZWGwU/p
	QZgtEGyie87zGxEsLUprPpKiFEZOLSo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=go8Hfoqt;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778746306; a=rsa-sha256;
	cv=none;
	b=DCMPubseWYjmEfUSn+NyKm8ho5/f1kWMsPCJ3i6Gul5RER1z3fC1IFfPHdudRoYsUukWwj
	OaMNKWKek0ZHr/xP5XAZdxlkpSGT96xbC4gI8EeTcYofPljpbr038aKTEthJZlqRYZZSCj
	291VVGOb9LFdP1T4WIoBOhf1hWdrWSk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778746303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7d8pBMwlUmT1b6rr3QpvI3IHWFd3qcPl+TOQyqLsnxU=;
	b=go8HfoqtoEReSSq/ieZqqdZdWt7cCKm4uTLqLbOMB91XjqOYGN6K0Z5371rrh+7HwtCqYO
	JSumfynqMoUIzwG2Cqmxbjy/HEMzQQYu/xM2/l+3ktbd2CryZCCa8B/w8HmbsW+RV+dMOt
	TvCjZAcb8r0uH5yqqVnX0n4QFB/WXso=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org,
	npache@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	yuzhao@google.com,
	usamaarif642@gmail.com,
	lance.yang@linux.dev,
	baohua@kernel.org,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	liam@infradead.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	ljs@kernel.org,
	akpm@linux-foundation.org
Subject: Re: [RFC] mm: restrict zero-page remapping to underused THP splits
Date: Thu, 14 May 2026 16:11:30 +0800
Message-Id: <20260514081130.7199-1-lance.yang@linux.dev>
In-Reply-To: <f2f218fe-a14b-4714-9893-465a4edb4570@kernel.org>
References: <f2f218fe-a14b-4714-9893-465a4edb4570@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: jrstxsh7kt33qs1jm5ksz6wmic4nzb13
X-Rspamd-Queue-Id: 0DD9240009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778746305-672538
X-HE-Meta: U2FsdGVkX1/coR6++n0CKNL+lPVl1eDP8XLDLTLvlIZIZ5QSAZItw1B8P83GDCV0XQxqlrPk0BpEkTNwW82a/cgqVtg49vy8FwW1zkk43mtrfDIboksQWoK+nTnuml18c6cDYYFahPKItDfFM4JnQvTBDcI6TjqgV6noSj8j5T87ZRBDHJ0h7JDfbvAbQt/nPj8jXf5/MrMXtZoHVVkXxBYi9W0QrXlntUPbNIVNvQMPTgC5gCboqwCfdXzIJHIywx7rh9MNPBitvjK7Xx/bIuKiqZdUeBf+j6BzKOYp0yzy+Z5OF2bdnRZFQbmi8z3xWnqfg4CsWlarRW/Wy9a4CxXKen+Z+PqXnFB7Zmb4+rubbeXiHVV+BmUTluquKhonZ5gG1N84P37S2zGyqYttRtBcvd/kUObaYDHCwmo4DbvtcHuY90a0rSAeu72J12ayYdiPaj2gCBSBITFuvSY1TxAN5twAkfseHtl9HKiJ1FrIc8Dmou6ZJk6M3mDsC96Xkz7c9rFNEW3wchD3zGJh08FIXtl4hbCVDo8FMue55yd+Axw+JSY74c4li+ShnNQ23WyYQBrRlplwn/RmAgjkGE1HgKqW116NxWeAdl+q1zoD6msKue1+eDOJ3xzP/ty7ShSf/BmQeIOrCOpFzVOUcItNtULgnPrzlCYfA4CrcN4/98ijkcyoodWAwAmO7m4a00fmSapNXeWZWc+K3cZXSwfVTTOsCKz/qZmjDP79gcZQUFT05mKPa0Rvrm3NX+fLwNZOTuwoPjb5ST0g9VBWxluaPwAAjZkZB8G/BR9WSReoeoJzJ9Ib4HXR2pAsZJBRypsFH0CHRBkGkjfjsrXdGa/t4ijX6UbcYaPGjyoAxww42hJgzKSpiV7lwnx32wCdmQksaKOIWS9vfHBdQNW0MisFRCWSU3DGTNnLoICJJ/ckVoe68KQNsyGLn4QhEwXgHvoY/Oo5iwr2OWKDdHu
 QVVMVUx0
 HNVp65NsMZyzP9ngC12fpYXC1NT4faTKQhjskCbxo1Aah7cMd+BE/qDS+EUnlyA8xsOKOWaas4OkXtY0w06QBFRz6MzzMSbIJXx9urr4quqe2CNYfZnzEl3nApS2Z/oRoS3ev7DU75JHExQdbPgKWMVcYo89bqwTCZ2JBznQeDPOL2hRwTJYxMV/p5Qoy+OVsLqfPTrzihxiGjBiwqb+xl0WUWXmkCfF8AEY2DELUZ4M1/bOM2v7dMjZ8hd49iwg7iM9m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, May 12, 2026 at 09:02:38PM +0200, David Hildenbrand (Arm) wrote:
>On 5/12/26 20:36, Nico Pache wrote:
>> On Tue, May 12, 2026 at 1:05 AM David Hildenbrand (Arm)
>> <david@kernel.org> wrote:
>>>
>>> On 5/11/26 20:40, Nico Pache wrote:
>>>>
>>>> And what was the expected behavior before this commit? Did we just
>>>> deal with the wasted memory?
>>>
>>> Before your change, splitting will always free memory, no matter who triggers
>>> splitting. So there is no wasted memory (regarding underused THPs).
>>>
>>> With your change, if we happen to split before the deferred shrinker runs, we
>>> end up with zero-filled pages that waste memory. And reclaiming them (through
>>> the deferred shrinker) first requires another re-collapse to a THP.
>>>
>>> Or am I misunderstanding your question?
>> 
>> I meant before b1f202060afe ("mm: remap unused subpages to shared
>> zeropage when splitting isolated thp"). Sorry, I should have been more
>> specific.
>> 
>> As in before the underutilized shrinker (and commit b1f202060afe), we
>> had the exact problem you describe above and no way to handle it.
>> Correct?
>
>Right. That's why the underused shrinker was added, to directly free pages that
>have been over-allocated with a THP, but are actually never "used" (remain zero).
>
>> 
>> I guess at reclaim THPs would be split and we would swap out a zero filled page?
>We don't necessarily split during swapout, we try to swap out the THP if
>supported. But yes, that can happen.
>
>I'm more thinking about other reasons to split a THP (e.g., migration, partial
>MADV_PAGEOUT/MADV_COLD/MADV_FREE), where the behavior would be changed.

Yeah. Today any successful anon split gets TTU_USE_SHARED_ZEROPAGE. Would
it be better to make KSM opt out, so other split paths keep the behavior
they have today?

That way we do not have to worry about changing anything else at the
same time :D

Cheers, Lance

