Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF08EC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A57746B00E8; Mon,  6 Jul 2026 02:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2E706B00F0; Mon,  6 Jul 2026 02:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91D786B00F4; Mon,  6 Jul 2026 02:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 64F996B00E8
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:55:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E4A5216844B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:55:29 +0000 (UTC)
X-FDA: 84957440778.01.6D4B49F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 39CCB1A0002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:55:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OH21rkP7;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783320928;
	b=Orv7fPWZKup5fzYHAhOHRRcXTc0fGbchQa6O0zLIiQlmJ4a5luvyXRXYFx7B8AjFkUXpgS
	DOUwrZx1lpsMiMp7ONqItrAvgq4BZlN8Ng5PUaYuXbFuRKRrvXxyO+1jg6bACD43YYPbSZ
	efT/QfFsvZuauuLxp9ajkKPrO8YzCVw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OH21rkP7;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783320928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zMtLSNfy7XDiRALlmO3rgrfVc43zWl2hltbEKjLLbGE=;
	b=8SPRl1cau8MJcacwY0T2TXsDFg3m2GzZV0nesS7Tz9tk7R9B1zuYATi3LNMDbbGcpHx6Mo
	SIjEMK5BRAWNAHXxYtrox9grh32blUSVdVLEfD7ptJbVPRnj3pP47mbd2Vx1dHMvIJj5JM
	CcVvitDTiGzzAECjcwA527w7iOxxo5g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B95A761832;
	Mon,  6 Jul 2026 06:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D721F000E9;
	Mon,  6 Jul 2026 06:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783320927;
	bh=zMtLSNfy7XDiRALlmO3rgrfVc43zWl2hltbEKjLLbGE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OH21rkP7GIl56sZQ9WPfrU//nny8/5DsiJ1PFp07qAsF+nlE3V6lubtYUY/4BQTO3
	 G23eAuBA6pgVtDKeFXSvKmY8m7tSnDItnhZSbUsRNwlzx+Ql1I5PrmM9pNzhXyEFg8
	 p1ELHg7Y78AxZtWLZ4Cew1OdUd3U2HlFCXOTF8j/2lUejKHY3PGqgsHFw/1wMxD9cz
	 qZL9rrwzowQvMzqG8+phXkYTXvaftoqNjgC67+3NnTYhKMVWIZGOxUYoM9U6OUOJv6
	 Ryh18ZvCD9O3TxE1ZUqfNJakt3cfOt/fQG/amw9ansHOskm6OmeM6GSGirhiNHnuS3
	 umrIJIL5PUnIw==
Message-ID: <fdb8fd51-d351-48b8-b2e5-5a480a068e11@kernel.org>
Date: Mon, 6 Jul 2026 08:55:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 3/3] ksm: add mremap selftests for ksm_rmap_walk
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: chengming.zhou@linux.dev, hughd@google.com, wang.yaxin@zte.com.cn,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ljs@kernel.org
References: <20260703162637070FU4ekl58Hw_Z7OSuJryZB@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260703162637070FU4ekl58Hw_Z7OSuJryZB@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 39CCB1A0002
X-Stat-Signature: yjpf8a8emofhb3wbsdfhkyo9c5c4t1py
X-HE-Tag: 1783320928-873777
X-HE-Meta: U2FsdGVkX1+g2zr4/H6ww0NWi+6D1IKDlXC/F8iLDBjRJOBdQlKyd/nPf4M88NRG+/WTbboqigSOQ7pJ8uTLZepaDcvJCD3uByo0oAPIyXjws6JHNp1B4vurZRYyEWW5l696frkI2uOoKBMhoGF0eoBXipPS3NVhKWSWkW/dg7pWm7/rccZ6jL7xSAVSxwhbpIsqNldWyZTzl9u6VoioldxBeOy4QwNTx4e0hlMI9HC4zDRv0mNDuOUpPu9BGpSCGCbwvGFnB3kUZFQFT/gPXuIpnjsQ+15BVuLJRvyPN44KilfJxl0HLKoByFt76GYTMTAzX0p7oQFvof/NAcXI/wer76LTBL7XfMeJn3sybAK60rpuVJjdbmbfT5UPqAGnvbGc4HxPozkp4p3jACEfWJE17zKbQQa3rVcfJSrKUU1Ou+mG2r7tdcPiSR2IMcQ780V6FIPFlNKVQXLtPFEzyd9Ln9UQYt6VVfx70SOo9FHRXS7tn9aGS6Y5FRFfmSakGzBB9LkqE9Qoe53jOfviZcPie+k8k1gHpViRDj4YpL+NL2K8sMMNd+Ak2sfP4vj/yrJNF3oooHq8f4RoNqKqFPPFFR1VWmEJTpHuHa7V6ykSEfxAog3/x/BO8NGONSbeDTRVG4TkS4JlwQVTKrYI2mg5D9hrhUWVP1j8SrbrxIrN/1C6sqW9ipcZF4amQ/UCuCp+rS8eLR2jhtcUpm5Ucd0L4l3LXCTSnp2u8xJQ0RzqbMRfurNY8WOclBQqH6mG2JAbJQfzId4Dt3wD4D2ihLV1ZyJk1hOGX/4G+Ex6MVn8BdqPq3nkVyuwoDeVTmFMqF2/yIuzGBWv+YnNDyu7ZvsBEKsN7kd3q7Dilk2qLXlnxuT0GhE5LR79NCZWQLfiLCME78/iWqdb+1mLV0iESl3LqY9wOxYy+iBXP8X2p/On+l0EiEp7Ml/e35URfhaLvlw115MlWLVSBFd6IzE
 gh2HFMam
 CCgy+vVhlXgwkqdNuBmNsi9YwWvK1TsGUsjXJQBebQ3FyZKRzh4l8BjeOLNR+p6TIfl78tMKY3YFjfWQnOpqapYPhwdJ+5pn+TNfBd08B/FGqiOnnztlrIuFMLzSSUCpC5AemFslfzhuRKidrZ+pN6jCMi4PkEQ2HM0KSX6LyBlHZKW9d+4hFJfq+p7CDHedc9lcckszNOkEx1G++DAsnBKLauZhtu73exn/6fcdpmTGLNopeexRpC0n3cn12N61MBiJw3VcAsk/b++/+kucPnRr1rPqusCXT7/qDQfPETXKTS/YkSsij8ExLxnrIRMQZmfOTWmQffMquFsbAYGdQgG6JHNGdWmy23QgXh1mRvflna6mko0TQfDe5hB17EvaG5+I8WK+2EcM9syWgZg1fi0PVnh8CKU7/ERW3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/3/26 10:26, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> The existing tools/testing/selftests/mm/rmap.c has already one testcase
> for ksm_rmap_walk in TEST_F(migrate, ksm), which takes use of migration
> of page from one NUMA node to another NUMA node. However, it just lacks
> the scenario of mremapped VMAs.
> 
> We add the calling of mremap() and then trigger KSM to merge pages before
> migrating, which is specifically to test an optimization which is
> introduced by this patch ("ksm: Optimize rmap_walk_ksm by passing a
> suitable address pgoff").
> 
> This test can reproduce the issue that Hugh points out at
> https://lore.kernel.org/all/02e1b8df-d568-8cbb-b8f6-46d5476d9d75@google.com/
> 
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

