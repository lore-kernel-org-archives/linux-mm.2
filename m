Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EB44C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 11:15:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97DB76B008A; Thu,  6 Aug 2026 07:15:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92F216B0092; Thu,  6 Aug 2026 07:15:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F8F26B0096; Thu,  6 Aug 2026 07:15:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 572086B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:15:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E34B216072D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:15:22 +0000 (UTC)
X-FDA: 85070588484.01.634D304
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id C7A2140009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:15:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oMuB03yF;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786014919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qFYMAIkwIN37n8NP5DTPowrbFEO7nfR2o0HVmuYvHAY=;
	b=c/G4Ab7Fyvi7WPzhrBEZoXR4+qvBsLRmDsyDjtY7PLDW7eC2lw97HJWssaGVGXlcoj3z9w
	qjB4iPm1FBNzTkhpVKgC4T9WbLx0ybV+5nR9kpcsOmtu2+d5wz0phhB2sFAB639ULqZFD3
	NGun3JbCjDdDdOaHwKz0X+0fOFM0gtw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786014919;
	b=mUdJhHrtsjuyW9g0fyiX3kt8+27JJJdsUcaVSiKo26R30Kvj7ISMuOm+vWX/rFSaYEdyB7
	X7+ogO0XQ1w+cSbEUnplBLYNO0hm/Csb1+I0/TCREyPryRa7CmVI0ODs3UPqzFVnFpnWyW
	ESdz5d2sIzcCo8ucZTf875914QnINQA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oMuB03yF;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D2B860A7D;
	Thu,  6 Aug 2026 11:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABB71F000E9;
	Thu,  6 Aug 2026 11:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786014919;
	bh=qFYMAIkwIN37n8NP5DTPowrbFEO7nfR2o0HVmuYvHAY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oMuB03yFs+2qPNIDQyZ/3VEwQC+lZL+c/Mqoy/5VoJ9wXh5p36tFcqQcXLkmHCuQp
	 VK10m3QPK0eI2nr44sywbuSI1ITwPN7hwl7g+yd2f14LMqKhAvLXJYgFeK3CZQY1UK
	 fzq4npu7O2Li718SGINgecjtSqDgWvvb75gNwrRCNULYunQ0ar5sIe5Q0SJ6cpedJX
	 Jrodhe6gMyqwhhT4mt+z/PoLE4j0nb3mXs+clAEjI+NfTV7MZq0aQiqyaNAAP4gYc8
	 orughlmZXuP+nvIPu1/yGoDjwYNqb2gTue6Hese5JB57RY4KNWr/5meaYiScMP/J+Y
	 ZOTVvSNd78HMQ==
Message-ID: <d5feed99-8c28-4c96-9993-471a43808519@kernel.org>
Date: Thu, 6 Aug 2026 13:15:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: add VM_WARN_ON_ONCE_FOLIO() in
 min_order_for_split()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, =?UTF-8?B?5p2O5L2R6bi/?=
 <dayou5941@163.com>
Cc: akpm@linux-foundation.org, ziy@nvidia.com, linux-mm@kvack.org,
 Li Youhong <liyouhong@kylinos.cn>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20260806032116.681060-1-dayou5941@163.com>
 <anQqEfCEbWmm5vX8@lucifer>
 <17316ab0.5714.19fd5fef275.Coremail.dayou5941@163.com>
 <anQ5QyzLCdXxlEOE@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <anQ5QyzLCdXxlEOE@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C7A2140009
X-Stat-Signature: stay8em3dawc7e75afkhib65fgtxxjk6
X-HE-Tag: 1786014919-540508
X-HE-Meta: U2FsdGVkX198P75ViMd9Wyk+vA9/jWafBhleZbwcLq+uZFalDG4pqiooIqAtb7DoDxvd57uK12gvYsuAAXz5k5qXkxfu7slwDTQ6OgXGXonH22EY3fNTddQvrrEXx9a3U+fIWsSzTLcWmRPS9LIa8Z6EIaRVq5NinLokRW/Q55XtHfunerBpYot0cZifNaIrZOSQws6zYsBJnd/CGKoU7Yi3KmobdGek0bipX53NL4mOOLV3Fg5TdK5yHi8XXhZefCHG9tACH3chAtX9iGyyBZw0qKk5TiWGRgQXVvB3ILj8M9eTLR2kiYd2zvR4dGC7c/uv1I/y91LvYmX4q1tllKNHqxZCEayK7rSoYpJRuAq52NmeozrEIbxzfAglgooqLb4gCzqyHSeecrst9bxe2t+Kddw1LEwAzVdUdPhXEphxz+/0yzUdYW15hJ0Hub05tk9gY4R7UgETLH9mrK2/m86j7Wub0Gp4BLOB59oaxshA5hNUL4tKsXpxXypD21cgEGJwifGvounU1DLF235vGgrpy7pH+c6r95+dJ2B8qJCC2rl+h5mN+O/2aKYfd//Fv1XbN2Ln6xnKktwFVX6ZgEN/Fw6ZtGccX3qRqhW2C+47Mohw8JjXkZiby+dBo5vKCV/eXbu+vD+Z7tdk1g40XG2bSQ9Xj0Blr2UkNbdwpnNwJWJxLXofh0WQ1WhuDfJD5cuTZexLUQQ5TYU05+8Wrj0nFxPezw3PJkVZerzPvjNbU1oPgDF0QpPpazyjoPwMsDM94uSwc1ffDykiil0oDD5ftrTn86KsXHCyCtaGHfi4PspWXjcufOA3nPdzozNh3o5OsFfXEZP6z2oeizgDu8/mly+EXnUVT2zHd1EU8tqVTITl/xPfANVdg1RVt+kS8h2Koz6AJ9YmXXPSU9Ri0hfFLbMSKVZ8hiZ2/brJ88+ecoPSaMZDwHZ3WjoTFxtvwSTJNhieqKUoQf2ATgv
 U9/TsG1i
 nwUJL7VCR5opsEISR9g0G/7pVqjDwuH6gVehyoKv1IsUWi84jTTDcDENVYyLh3hJZSK+Hn6gesGJ/JopsH8L+LVT8oHjG4aiXiIbr30ro2CZ8JvlF38Lrf0kXD3acu46fgIGcyovr7igzTLtXOs/8NXKtLXLBS8BAZFcDxvPCimfi4N47ohr1dUlBiPUFBZcR8+ytEP7ZlZ4aeMLURuTOikdxHpPQMByhJly/xdYZgAV2qtpbFC4Olrfu6KpvZaQyoAlHD/gL+nCkDaT1381ESE5L+iur/5uXFg3Zp+aoraPxQPFPsKSVx6FVabingkte/yAqzbtDKQzn8uzg4A6FH3aPxZQuCwt1aGcA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 09:36, Lorenzo Stoakes (ARM) wrote:
> On Thu, Aug 06, 2026 at 03:34:43PM +0800, 李佑鸿  wrote:
>> Hi Lorenzo,
>> Thank you for your feedback, and I apologize for that.
>> You are right — I may have misunderstood what you meant by "separate patch." I thought you wanted it sent as an independent patch, but you clearly meant as part of the same series, placed after the fix patch that makes the warning meaningful.
>> I'll resend the full series as a single patchset (v5 1/2 + 2/2):
>>
>> Patch 1: mm/memory-failure: fix folio refcount leak and locking in
>> soft/hard offline
>> Patch 2: mm/huge_memory: add VM_WARN_ON_ONCE_FOLIO() in
>> min_order_for_split()
>>
>> The second patch depends on the first, so they must go together as
>> you originally requested.
>> I'll send this out by tomorrow as you asked. My apologies for the
>> noise and the wasted review time.
> 
> No I think it's better that we handle this patch, please don't send any more
> revisions.

https://lore.kernel.org/r/20260806-try_to_split_thp_page-v1-1-a259e3387e38@kernel.org


-- 
Cheers,

David

