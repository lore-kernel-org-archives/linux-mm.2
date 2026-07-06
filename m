Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6555C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 18:32:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92C8A6B00C5; Mon,  6 Jul 2026 14:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DC526B00C7; Mon,  6 Jul 2026 14:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CE4B6B00C8; Mon,  6 Jul 2026 14:32:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5577B6B00C5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:32:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D4BFC1A01D8
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:32:34 +0000 (UTC)
X-FDA: 84959197428.18.439A4AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 158BC40007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:32:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ix4bhmJR;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783362753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zGOE+B6wkEpBM2IpcGXFx8QZR17g+FSu0rEA2m1xu9o=;
	b=EP2hF4ssT/zd2TUGmYjyiwpKUOiZjQtBdI7bzt9hpOStTOXqUBvaijVcb5sL+IMCcrRXcr
	QS0QpNqOrZ8YKdo6s7WeJCuj4pzyYrmvGN6j4L7xWFecsr6jqSP2rvEyYuziRpQwLeUIV6
	p5VKYk7wHVp2u/dxWOXPumsA5Mz8r88=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ix4bhmJR;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783362753;
	b=oTOyuD334GCZRyXH2D0Zx+KeVnbHhxrAON5U+BkSUQ01AK8nk5P9g65ebzlxO5XsXdd2kd
	wKJwmlEELOR390mEgCNlzGLTdMCIydS/8XwJ9m4pORxA92OobWZ2XxRdvHYtGsy/23wINh
	b3QOoVNCVzwCOsu3XjhlejXjT6mEoWY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3EFE3405C7;
	Mon,  6 Jul 2026 18:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621181F000E9;
	Mon,  6 Jul 2026 18:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783362752;
	bh=zGOE+B6wkEpBM2IpcGXFx8QZR17g+FSu0rEA2m1xu9o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ix4bhmJR7eKsC24l2YTxxFRBLjhmL4LgBvKmco8VimioUNWoZ6OX53QFUAY3E/fu6
	 bPmipEz8QWmjsWI5jPo3cNditiRywtVRwh3X2Xl+QsGGEwg11HXrnMhlCe/9mG7IjP
	 UQcKUMhhVB3+wcX78k3+DQzhbun6h7M1BZ8HZMBcZCLHxiTjrHno6zFcbd1kI6vC+x
	 OreuqOVbwXg6Spqfzj7FWBHKioeMP2f1s8moXKiDc0v5HFpvMzvXber/vPcFn5DLQa
	 fSXrr8QMf89/Yd3KBS2qny278fI9C8bk0Lld0fN9tr49n4ys/lX34U3AJCkA9tB2kg
	 kmB7e7C+mfIJw==
Message-ID: <72f81925-e845-45fe-bf68-753be5b4d75f@kernel.org>
Date: Mon, 6 Jul 2026 20:32:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/6] mm: rename ARCH_ENABLE_THP_MIGRATION to
 ARCH_HAS_PMD_SOFTLEAVES
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, kernel-team@meta.com
References: <20260706114320.1643046-1-usama.arif@linux.dev>
 <20260706114320.1643046-7-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260706114320.1643046-7-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 158BC40007
X-Stat-Signature: cet3kikpsdhswn9sf8e7c3xts43uzm6o
X-HE-Tag: 1783362752-738179
X-HE-Meta: U2FsdGVkX19Td43ASq4F0MQAeyBwsDdcB2rz0WDy90FYOOmq3HeKUZxQxN+jIjipoNSrq23NxHO/+jpKur3CPW5eVSzH/RF6pVbpJ5dqtvDHymb80ZdGoWPk+7QnQS4W1bcWByFvgXvpVaDfQDat+ydAGJaX6Y1OX0VwF7NtEwjjA2W0xKCJCKnvx2xHN/APGR6iaTc5Byi6jLteI7Igbf2CzG/+Ug2lNuTnNUBrbCDDWapdlhdYAnEpFQVuJKmNr+fXnF9j74s7hukj/Q/jPFl1Tp5MH8WMQkXAgVCF5oXY5rkczwNuKyJZGg1lW3K1Gz/ZukoZzOYXKg6cSkgmcyg4E0Nez7yzC8/K3ipLNou6mebOBSINjZFZLny0yr6ZZaScicPwu3RtcMJLk+aYmsS/wz8PGZ/CfkrTHVhiAQV7fE1f6QOK4hvkKwunabdgDKqalwRIEUTX67P1wkkImiq2wxR7M5g0d9Mw74ZZW/Qlh7uPlghzEgIIrnNx5yTI7UDkNqiEW9qU9oAucVTDi/oCfZY4tThtn6mKu0tKPQF7XffOs9ZVNyNwv4v8Fa9TbdS0mXp35YLX5Fzf3cTzT3rBa0X8Z2PmUf03WxpuiO5nYCf9Vt35PKWU2mj0YwSGNGiePwes9sd+KC8vV64RgHRke8pAzlwWgHqHjpraSEhrgEkuzgP4kxIEbxcc5gs7lh7ZMzsRSvaID5BFSD9d6e52Wa7afX0GXOWtIftWCS0csr7Nb0ooqJZyl4mFK/qOd3/Qp2fQJ4vd27JkWMW/mBY1ZEFMh89Sfss1UiOoRYnql3Iwf9YkczGheCJdllwwbkNrrdUjk2IdZeSu8GE/jzN68NQe/OvWUmoegjE02Fj3IFMOEYt65/CQacytV3HhOvid9n845mVpgsvVu+waY3TNdv458oZkdTSkf/eoGCl913PusK/8eekvXsSwkbEgW8ueBcx9X9DPhZrS03k
 7LUv8A+h
 6MYx79EXM4+tCz6mQheEmP+/axYp0Alvez9qVZ+0Caj4JK03/k35tNFoEcBderdbSY+FhHcR/AWpon9Pj+J/JwNbmsyeTkpXrsGouXh4PF3c4wnQct49H/6IjFueRg3phkUcWCcxE9NeAA09no1fHzUaHiVqkYwM0piNbWEKTpAqbznl8u7qHcPurXquRC24ZxLlfjRFF0YK+LPq4iC6EW541VCrhR6SF5YjPJZq1eO6VCM/L9L3cTVtNHzWRfHgQzKs0cdgRiirZKZd6NXSiAekLV+popdFaUFS/wxPJKwC+CI7+yeDrojO42gK95ugKTlygg/REl8HFTFTKe/tO86g1PP33i/YG5N5U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/6/26 13:42, Usama Arif wrote:
> CONFIG_ARCH_ENABLE_THP_MIGRATION gates PMD-level migration entries.
> PMD-level device-private entries use the same migration mechanism and
> therefore require the same architecture support.
> 
> Upcoming PMD-level swap entries can use the same PMD softleaf helpers
> without depending on page migration, so rename the architecture gate to
> CONFIG_ARCH_HAS_PMD_SOFTLEAVES.  This describes the PMD entry capability
> rather than one current user of it.
> 
> This is a pure rename: the set of selecting architectures (x86, arm64,
> s390, riscv, loongarch, and powerpc on PPC_BOOK3S_64) and the gating
> semantics are unchanged.
> 
> No functional change intended.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---


Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

