Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4333EC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:28:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AB2B6B0098; Thu,  6 Aug 2026 04:28:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55A116B009D; Thu,  6 Aug 2026 04:28:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44C536B009E; Thu,  6 Aug 2026 04:28:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1FA3E6B0098
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:28:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A60D312066D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:28:44 +0000 (UTC)
X-FDA: 85070168568.17.74E5A3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D871240014
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:28:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Br4R6Cfs;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786004923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oenkpXQvpspNwRdLBZH2t6JBxgoR2w0itubz7CxvgRU=;
	b=nDaY1HiNTEs+Nf+lB1VA5ZQ17phipZhg4z2Vgra2y9KQ3GNeefB3hvx6GBUuH+olDksYhw
	GJHc1I2M5N7JNLXOF1A7SprzyoFoCNlCJuCvSUrkVhRJVaZ0LfUWhr+hCbt7Czc/y8Am7h
	PBWeCRCxdSKMzimat6kDVeJTDLixDMU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786004923;
	b=ByIFZj/gY367lZg4ADxy4gX3Mn2vzuJ5wwUd+aJ8/v1qKFP9MGsPCYcUFTJFE/5DpCj4Lc
	q24V2soO2K/1cH6es0Enjpe/Pt2Pz22mIDRvu3T27XQhyE6n5u3okNAAe10dX9NfuGsPME
	nNjeSblD1tc8tTH2QFQB24Zn4GceDrc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Br4R6Cfs;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01C39424CC;
	Thu,  6 Aug 2026 08:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6781F00A3A;
	Thu,  6 Aug 2026 08:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786004921;
	bh=oenkpXQvpspNwRdLBZH2t6JBxgoR2w0itubz7CxvgRU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Br4R6CfsRmAAmpjPkxVBS/Bs/HzMSRFF+TgaPoeNBpaIOTc/XF0gZlZIYyhEcxEh3
	 0v6W7YwVX5fvyWtptGSPWU4WbGbbxIfHOPZYBjilMpesToCgHZRPQmkAWtpVGhzbQH
	 gHUue7xWlqcAOMkNxAUIIV8tu4mpoETEi2FhxEgf6KzfIGfENVUUefzc0PQ5K30DQT
	 d8vhktbmC5TU13D/tOi5doPtu98Eid0VOtO5XxHmCzQEbm77igo5mePyglCaPYQz1G
	 P0bBcyTqlmPk4J56yjo0E2ejQO5q4ZwZhe+1dNmS1XOumeFLwLaQsjBmwV7Yk5+rwY
	 Nat0kWBjjr+aw==
Message-ID: <e5f3e45d-7203-48b6-8fac-d3ab12fd1e01@kernel.org>
Date: Thu, 6 Aug 2026 10:28:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/15] riscv: add Svnapot PTE folding support
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Yunhui Cui <cuiyunhui@bytedance.com>
Cc: linux-riscv@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
 linux-perf-users@vger.kernel.org, kasan-dev@googlegroups.com
References: <cover.1784201104.git.cuiyunhui@bytedance.com>
 <anQ-GfzFl-thu3q8@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <anQ-GfzFl-thu3q8@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D871240014
X-Rspam-User: 
X-Stat-Signature: ipbt5y5mm7egpg1i5gybyu4ygam35cw3
X-HE-Tag: 1786004922-977962
X-HE-Meta: U2FsdGVkX1/l1eOcCfp2MWWpAVNamoCZDKw5bsP4n+YKSDKD7eSaZ1x++0uXkzjbD2ydeV3OdHxGoB60C4Ib3RXp2cqnUNsxZk/v0FBGQS6eRRCv4+rxoXxjIiAt6BgSXOJ+6GEewgzKHjtUCs0xEITYr3332pq7gm9ibx9FIZZ9dcc++NKBtXYRkn74IQPwPJDidZXSoMo452UQmYMw2QdhO4e6nuNOWLlpyLhZDxWjzza15U6qCk8Wwmg9DxLzo2Kle8i9RAXtGW3T94BfoewdW8etdBD6eph+/oVa0bnIMvA8N5+ZQCBR+0a39vR8OhXUZM0tP0qRVx0Pl5dYkH7/KaIfvtH2I9izMOwpP1QkQQ6c/I1/576ILO0x8bua05XpsCuQz+XihSG3rF8CIA/BiveeCXtGPlji7CTOu+dkuPZWiy5ZLso6OPZ0/axv3aKhmzhpvpLVHoBndHQ+vG1s9fuKJXWUl3X0JvgGiT7rkY1EVfPL6p8W1JuasXI9yEpoNLqPUwx0F2MIg9RWBCS5IATNF+Ei0Ia19/BrzX8OWZcMg+wMcRgN3Af9FGowZFVbjer3niuvlDT6angpFh/3fGWpkvZHqDolLfaUWJjy1ZUqaB51+RM8Z2NsWwpSW5rbznNzP8coI4lsmJxKnOFi7vyvUBRjlu+NCVSozJ4okcUTiveJ+ROPkeTpgRvMwc9uP9xkjDR8RareejjGNX1EtsBfmnWrPHarQefl7YtiHuQd3KFSXPOkZioX1upmrRI2YsZUfPfF2LW4QpVkjEmYWn4RenKJJd2d6ezHwR3uoqCc3boJgH662hgd01B16ZM1GjABSKMczfND0KvXzbnYTEBqGkfF7IlR2GPlSYOrLPCr+oaHzIeVTKdSINbxg3tHZL5MWo4rWT3OcjSXxU3ifLFgEAu1tEE+g6OoT0oz+g8HzI5c7L9BnKZHtQRuNFpr1qelYUv90oU74Lj
 zjlw88fv
 q2dglEkdoCDcNwuKU9DHznVbKIHPqR5AteIaJLm3RjiBIso+GYTifBSHlBUphSwGpdA7BZow0E4jKStAfwrF7FPuka/HXeLFoMqs/Gf9mjCa4PLi4eC1Rr1MJa7CdiK0ErG4Im76R8FLnj8EnpVYsC4mnkyPlKrNZZNDjDThXTxv9chq+M5CoWWn1Cx/JCqcppZVOmt57tryewVMXbhvBDqgPcsyIB9vYcSAkM0Mwl2A1cfDHJu0I/gEPB7fPHo89x7y/HTZaxGjYW5T3/5EIAhE+ZUw3PGY/0cNG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 09:58, Lorenzo Stoakes (ARM) wrote:
> I already commented on you failing to cc- anybody here (!)
> 
> I am guessing you did the core bits in response to David's request ([0]), but in
> general - if you're changing core mm to suit an arch change, you really need to
> send it as an RFC and then it'd make sense to send the core mm changes
> separately as an RFC with an explanation as to why you need them.
> 
> [0]:https://lore.kernel.org/all/62c418bc-082b-4ae2-a889-f63dd2b7f503@kernel.org/

Not even CCed me, lol

-- 
Cheers,

David

