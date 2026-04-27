Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3AA0FF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 10:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B7656B0093; Mon, 27 Apr 2026 06:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18F0B6B0095; Mon, 27 Apr 2026 06:58:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A5156B0096; Mon, 27 Apr 2026 06:58:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2D586B0093
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:58:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 91290120158
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:58:51 +0000 (UTC)
X-FDA: 84704038062.29.43A0F2A
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id B4D4BC000D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:58:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sj91+h2F;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777287529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mC/SUXF6qmjl4I2YmUCpIFnBd715RpusDKL8gxRM2m8=;
	b=oQY2JB7phPM5Z1AKSsh+JTIR9X8YtQ/N44rJiqPwwPLZKJsDmibaU6dEeHFx+1UsfmBBh4
	lCzeGAPyybOjTl1BYU6irNd8fzc9w4c1XBi8VCXCw9Bqa4aUAmL+ha0KktejK7TbT/x7BX
	gE4T6/OmZ3KxDBtdlUIhSm0zivcpJlQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777287529; a=rsa-sha256;
	cv=none;
	b=PEoFpN8rCsqb3ZO8UQuzApTN4W93jb/sozRlYi9uFRwGcT5yZ60l2SiKW1uNJLOGjSnXU3
	03GvIdv8VLr4eC8LshmdC1FHWjaRVrnzT3YmLI/ysisbXOm3mEVvyoUrmuJRCpVLwWNwtJ
	VUJKoFXvtZrJM9lNFw8Y71uhKsRskWo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sj91+h2F;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <93cab3a3-1a67-4ac0-a818-f333d8017bc7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777287526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mC/SUXF6qmjl4I2YmUCpIFnBd715RpusDKL8gxRM2m8=;
	b=sj91+h2FCn6FNfkkxcVlMhdGDID905wb6k5PpVtes3BGCdCrQDPp/vXU+amHHWxaeF/Nak
	u8EDm/WFOVn3PvlJF6yeIYWeu8YT+q4Tm+g6N0lnrAc1xqRxnXkhl9hkMOhfvHF+qQGx/j
	syfIfRAlYok9/6+Cc8WoRf+2Iy+48Q4=
Date: Mon, 27 Apr 2026 18:57:52 +0800
MIME-Version: 1.0
Subject: Re: [syzbot] [mm?] WARNING: bad unlock balance in do_wp_page
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shakeel.butt@linux.dev,
 syzbot <syzbot+7d60b33a8a546263da7c@syzkaller.appspotmail.com>,
 Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, surenb@google.com, syzkaller-bugs@googlegroups.com,
 vbabka@kernel.org, Muchun Song <songmuchun@bytedance.com>
References: <69edca15.170a0220.38e3f1.0000.GAE@google.com>
 <20260426034938.db29d74982a8eb8463f8cf3a@linux-foundation.org>
 <e7187a21-7114-4f42-bf8b-90d6e6b54fa2@linux.dev>
 <20260426105532.43768b24a42744f1b52fdff2@linux-foundation.org>
 <3591c663-a4a9-4c22-97cf-b58b2e7d8a41@linux.dev>
 <f0ab0c7a-c597-41a8-92b3-4424b12b1b1e@linux.dev>
 <20260427034402.096cb95de92bec15becc78bb@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260427034402.096cb95de92bec15becc78bb@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B4D4BC000D
X-Stat-Signature: e8mwwe1uxhm7jp5wazy3bg6e5qnrmqm8
X-Rspam-User: 
X-HE-Tag: 1777287529-317594
X-HE-Meta: U2FsdGVkX1/6rRl6A3Z11NfweGVmF+uxhEm1LbfFhAqVsK8pSP83x/hXb190aDjb7sQKM8nWJJXVIL3CLMOTiezks7xN+d36dWIw6UsPXWGeFvZ4Ph9RW8k2PEcg5GmOwHTtjjZM6hHQ3NIvOztDaOrfPvPrj1UexZTe2DTr/2xqvETv+iyRiZ+7l8Gg1DThMIGNZXkB5Af/v2LBWgDyaZFPbmbdQwAXQGP3jjmjrvRHbvSd+xseigjqFa1FkBfNEmtXtiMwQuLYfDoSTZqMPNizUaJ26wqvMTl1YKO4X3VTB0Sbg8T0SD9wyhDjserRvPtiA/tfneAFSTe6BnYoYUXPVbv0Ak6ApwzkPBezaKebhmbbBA9SHYUIMnWovX8U2LL1siRdepHjs6RzGVfFNzcDm2rribhgk/eM+jL3USwEqU7TgxoFaHdQCHwvO1d86eFtnx+vNkLfHVHYxH6e/2p9AAf9Wz0H8D/MB+RKr+/k/y/MhEfiBtqbU8q/b75kGEHpitINb5FuQfqX2CmeJNkPBIbafCuBnR7ZiMV/4Mu9nfkir2PXW7FZaedkvIPKPmXqF7m6D7UWfocLEWHnFPNb9QkhfNClfT4M01jXGZZAeDLyXeSEmzjNLre8J3T5FQQ4Tn/I83MGPirNLaXwi+syzrTOKmMymfoQChzoVcB1Su9M+JD1GAKIH5F55gEzG4JcSKZeb6DSpiWpJH+32Nk1QJRSwdskKiuTrCnkg3iVY9N1pKx5jBnQYi5M1l8TfveX6K2FkS3e1jw0pIm9kmt5hPnb+RP5gVZSwsklFmBrgFtlBGzU9lZXTDqluy/0xSLsQpEUhQVU+oCM9nP0K+DdXk8Zt/i8G6Odxtm7q/3mTkaidBgcis4ZaphDtTyDPVvB8E968HXAwUJ/aHZwlteKOZcn16VslraRXKxTdQPE63PayhiAwx3G1fpkai7HIkYYndDjHhMkDlmpDEG
 RkHci45M
 E1+hnOJ+EFILsFlTlGxvgo74tzimNU0JX6YH3vvXtzrI/SKI5XqfPNooyfyUw65adhk44Okry2vLtuEwgY2Nee8dCgbZihMbK2uJlbCXS1t4zUajrbtUZ533B29eDvNuEnzrYCO2IcrwrGRRLBiYuXcwscEEUHjdfVwdbvwZTUZtaJdKSCCeR9RELjVNzWAUv6ku5qcG4jfLgbNb5lmLXjanC4k3Hm5U3xg9D7AFco/I4bCgyVyYw4u8necwZMQzunPKJqXj9HgbEUxvSSs0MDTFDHLaYbQWiHE0Hco3nkJcjer3Ga4FIO1ZMndfx5IMiHVHRTfUUTaOmZq5ec/H7y/GJGgYH6p7TTkz2sju954NSu82btptPJNJp8i4DVtFmPfBw+BDlEJjt0AMTZaLpNckr9/Xm8RWq4f4Ao1LyxcfoFP3YI8fYcxKo9o5ml00Zhxm942KeFy+uBo9EaJBHJFkFuWnBG7XCKWSP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/27/26 6:44 PM, Andrew Morton wrote:
> On Mon, 27 Apr 2026 17:43:38 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
>>
>> Alright, it seems I have successfully reproduced it:
>> (The reproducer is attached at the bottom of this email.)
> 
> That's a lot of code.  Thanks for doing that.  Maybe there's something
> here we can put into selftests/

If we are inclined to drop rebinding, then perhaps it's unnecessary to
add selftest for it. ;)

> 
>>>>
>>>>> However, in a production environment, this is practically impossible.
>>>>
>>>> Can you expand on this?
>>>>
>>>> sysbot isn't a production environment ;)
>>>
>>> Rebinding only works when the hierarchy is completely empty. This is
>>> generally not the case in a production environment (e.g. when systemd
>>> is used).
>>>
>>> BTW, it seems rebinding is about to be deprecated:
>>>
>>> cgroup1_reconfigure
>>> --> pr_warn("option changes via remount are deprecated (pid=%d comm=%s)\n",
>>>               task_tgid_nr(current), current->comm);
>>>
>>> Also, it appears the current memcg subsystem assumes that
>>> cgroup_subsys_on_dfl(memory_cgrp_subsys) cannot be changed at runtime.
>>> (Please correct me if I missed anything.)
>>>
>>> If we can get a reproducer, we can try the following fix, or simply drop
>>> rebinding altogether?
> 
> We'll want something which is applicable to 7.1-rcX please.  Removal of
> rebinding sounds like something we'd address in 7.2 or later.

Got it.

> 
>>>   From 6ae41b91339625dd7bf0f819f775f26e78171a73 Mon Sep 17 00:00:00 2001
>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>> Date: Mon, 27 Apr 2026 11:20:21 +0800
>>> Subject: [PATCH] mm: memcontrol: fix rcu unbalance in
>>>    get_non_dying_memcg_end()
>>>
>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>> ---
>>>    mm/memcontrol.c | 30 ++++++++++++++++++++----------
>>>    1 file changed, 20 insertions(+), 10 deletions(-)
>>
>> With the above patch applied, the warnings are gone.
>>
>> If no one objects, I'll submit the formal fix. Or should we actually
>> just remove rebinding instead?
> 
> I suggest we just fix up current -rc please.

OK, will do.

Thanks,
Qi

> 


