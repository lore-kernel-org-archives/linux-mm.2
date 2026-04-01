Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78797D3516C
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 10:15:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAB416B0005; Wed,  1 Apr 2026 06:15:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5C016B0088; Wed,  1 Apr 2026 06:15:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4A0C6B0089; Wed,  1 Apr 2026 06:15:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A3FE76B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 06:15:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4392513B1A3
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:15:42 +0000 (UTC)
X-FDA: 84609580524.18.7E8D0DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8297F2000A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:15:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C87ht2XU;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775038540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bLa3ebsfLxEdbY4TGYxv+TNWkhy6Tc7youISpmiJTgg=;
	b=QgRyxSbpMFbwjOSFUcOpV87Xvx6RTHy5gHiP9GKBHDSYgOJUlL1RwsOktpG1jvms29eDy9
	0Qz6e+A4EjWNkDOap7rUqVU3O7dVy3OXWwoixFnastwI7f3MRuf1ofS4pRqV/fnFMfhLko
	YAkAMOUq9ZqA5+FcsOxchxTeGZ9HaG4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775038540; a=rsa-sha256;
	cv=none;
	b=6qv0HbiDFTs1XXBiZdJVxqdeCT4BUe+6pNK16fvdaE3MFi+6nLxL0usI43EvZKl36OSxzs
	m8p5t/VpOQjxbwbSofF8tyIbPap0pUUNWhTcSZKgS+TPd2T4zOekAFUQVhmAkzI9hh18Di
	uL7yjz2AjxpELoqn8NLDrUHWmkauqhk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C87ht2XU;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DC36D6012A;
	Wed,  1 Apr 2026 10:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CACC4CEF7;
	Wed,  1 Apr 2026 10:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775038539;
	bh=gPfGpsPWtFNdEOnKKfHw5AfsvOOAcxMLCXyvPk3Q6Cc=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=C87ht2XU1p1ey1swk04IfzogavurvJ5V8TQ8YgI1FffaGA64aro2WYLEj5yHRd36V
	 h2CDWj3+M/DEChZcelqV6WMOYHlDDYvUx+BWgdMywl46ggRJSipBnCpybJVrELs2ZU
	 7Gz80GC/Q+PXSpWWRz7Gcz2HXbDMAzYMP7xVwaFFaV//fp2CFdOrl23NnKB2T4MUPG
	 w0+CtylbAGSFGpiYQzmD739xdKyVIJrH7rMwCpzwBO7teXqRDdQ4gt7Sb7dobh7RP3
	 CYucX69y+K7/j64jx8hRw9l4SLKZnr6Av+XAqi4ZoulG4M7TAPqA+pBGbNDw/ex6XW
	 ++rjEazkEKfdQ==
Message-ID: <f1fd3148-3303-44dd-8ad3-c031251abd51@kernel.org>
Date: Wed, 1 Apr 2026 12:15:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: fix stale partially_mapped arg to
 deferred_split_folio()
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Deepanshu Kartikey <kartikey406@gmail.com>, akpm@linux-foundation.org,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com
Cc: usama.arif@linux.dev, richard.weiyang@gmail.com, sj@kernel.org,
 hannes@cmpxchg.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com,
 Lance Yang <lance.yang@linux.dev>
References: <20260401084116.22219-1-kartikey406@gmail.com>
 <f0599d26-eebb-4bb3-812f-beee0bce5f5a@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f0599d26-eebb-4bb3-812f-beee0bce5f5a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8297F2000A
X-Stat-Signature: 464u4xxzwroiir7z3pjgu6s74kx4ggdn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775038540-63393
X-HE-Meta: U2FsdGVkX18HnIE9sljz80iHSZYChZUSdsv42qq/DCAPJbBkILmgzVB40cV3eJ0ay+uJoLJCp0JDVCDCrqTNAPNTON3pLs/rhl2Bwgjri4bfTg1wncbxx4bIH5nSKECbve6UtDzxetweb/te5WEtpRRlqq6v6G9InOWWxdU4oJ3LfI3elJhpnih4tvoJAJbgSRGru9QrlkVusSgSq39zOkzZThCooqW8v/0CGdG0nzK3xNg6lz+afQadAziEY2JiBlDUyUX02RG6NASkAo+vcL8FiT+HftlRzrVHlEB6hg08TT7FtgJGdcr2PuuXddY1Xfq9FyImn/V0WmlqaZMSZcFPnerollT7c/ShM3+kXBhYvazERRuzb2KgIUGT49L8I8TVQ3HiUE+0aJJQtsEPPn+0I2y6RUbqSm2IVt84Dr1EM3eeo0WUoUq7DyUCHrCO5sSI2pqxVIOa4r4h523GM/f+W/bR7COD1O2pyn5HWLTaEV1lK0eXFIFT04cC8PBWbd5BlvYuKEzoERD/sgWg8+5LrUKHfvpD8qsf7fKlbdrE/kXCkAKjwFGwYyR0JNA9WIe21dnvn/8yKvLKFqlf2d6pIvh5EIVYjcdQT4GEHkl2wtAYuJzNyGMuu6kXKeL66qTa+u1F5PdWGYK7GRXTiz4dEtX8j4GhQtpgtYgQjTd5o8h4XQ0lYYtgh1yTmdr5uWxFfOt6/1W9C5yPVIQXsdBIy8ZsZgxzSbI0uKNbx8pdagIV300Pp3nTTqfWnVBXJfbu/TKmsqnIUAgxNdXJjlY5ketU8piRHsQaKADbfcsF/qRYX6sTAL1JZDpG5Sbs6/qjNLm/CDvWKmnD38ypCQrGYTj1OWbsbfA4nWNYRZlLPoRlUhqQgeDzLdKi2MuFaA4kH/oU/H6Xgc0zQ+XMCc72zpri89jkKljUNiw6RGIbHPqWsUgoR8c0Ss5J//uR3jEIv4rdRuIPdCxqplU
 Var6gFaq
 jb+gI69BhH8+kAhaadgWqHzanS+es1i7oLsNF8m/9hGNgh7VOi2LJg4viu6ULyyA/EgofUXQ88Pfcu8dS3otiJ93ko2At7jrM1TJrqyTL+ap+opuefgghBIEmNRp35atDhXPCXUP6VNE1kJtzcQpY3+FG1ldC8hQ44hZ6fAp/nW3jtTEWa5YVUIWxqKGtvOabUtzeYJhlq3p3+1GtP1lhYdgIYJX1xcNDrc0KMu3HqhaG4uEVC8rhofC0oIp8Zed9AaokgikvD9pMxeZwv9lXg5N5QrYRDFyQaSqBImTHGkjphKZ2lpncTCniLqm8zj+Mj/W04HkpXMwMghUL0osqbBh1jEVLuoZ3cbKqPvEk2BExIoXptIzhvOV9z1gmZxgvE3pJhm906pwPJ8l7cT4X2S8TavpreExXd+v7IUCdx32J88s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 12:10, David Hildenbrand (Arm) wrote:
> On 4/1/26 10:41, Deepanshu Kartikey wrote:
>> In migrate_folio_move(), src_partially_mapped is sampled from the source
>> folio before move_to_new_folio() is called:
>>
>>   if (folio_order(src) > 1 &&
>>       !data_race(list_empty(&src->_deferred_list))) {
>>           src_deferred_split = true;
>>           src_partially_mapped = folio_test_partially_mapped(src);
>>   }
>>
>> A concurrent thread can unmap pages from the source folio between this
>> read and the actual migration, making the sampled value stale.
> 
> Trying to make sense of this.
> 
> In migrate_folio_move() don't we have the folio completely unmapped
> because there are only migration entries referencing the folio?
> 
> See migrate_folio_unmap(), where we check !folio_mapped().
> 
> Why should we suddenly have mapped folio here? Something is off.
> 
> Unmapping a migration entry will not involve rmap code and not mess with
> the partially-mapped flag.
> 

Okay, concluding that the above reasoning is all wrong.

Let's discuss it with Lance's proposal, which makes more sense.

https://lore.kernel.org/r/20260401085932.20945-1-lance.yang@linux.dev

-- 
Cheers,

David

