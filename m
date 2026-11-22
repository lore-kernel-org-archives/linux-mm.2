Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05F6B606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qr1B7euW
Received: by kanga.kvack.org (Postfix)
	id 301416B05B3; Sun, 22 Nov 2026 10:58:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D9416B05B4; Sun, 22 Nov 2026 10:58:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EE9E6B05B7; Sun, 22 Nov 2026 10:58:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E93CE6B05B3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:58:16 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 86BF3406FF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:58:16 +0000 (UTC)
X-FDA: 85463211792.27.B935739
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id AD82214000B
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:58:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qr1B7euW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795363094;
	b=Dk44qe7ODulHPdZphEv8NwZOo443faLuxNYWNbvhF7h44v6dVPsrYrdUdpgFLb05pekaHW
	3giOZ0b5eZFhzPKZRU/P42G/axCkYUikrfBtB8kjk/QiPWIx3q1I2k4tCcJqjR9p6Rb2pm
	Fl7o8Ar94+515HYu8HBKD1EFx7DTmlE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795363094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sm03WQikhvK+Zqgly8SDqrTCCiqA0P1yxoVTgDGTg7M=;
	b=BksqDwR79YpF/qCMc2IP5oZlsMPdTeC9TEo0NLyZhM0ns9JTm06toOzpCUCoeJGaLrTv/8
	sbdIbbVYFh+/8vfzIReQnEf6mbv3Vs+uVqV53ftLw/3E+PFHRpl+876h9U4foRAkkdOroD
	JbQsXzU4o35t9GbOphfkavp4vB1p6JQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qr1B7euW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2596260F73;
	Sun, 22 Nov 2026 15:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5174A1F000CA;
	Sun, 22 Nov 2026 15:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795363093;
	bh=sm03WQikhvK+Zqgly8SDqrTCCiqA0P1yxoVTgDGTg7M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Qr1B7euWqPUFHMbNA2RGINnDHZZs9atNDV/hwqTAqCRzIxZhrZAVcvoyfq0+WYRto
	 u7ShkdF93gyBHEz/fhmLDPqpH+qnygEAkCyMlwph/q7uokg2BRlQM8vdKQWbbk6iuh
	 cYO+V8Eb4GdBfigef3AfKhlB41gR+PupLZsBC/dZkWAE7ZSwixTb3RpsmaRW/hhniB
	 P/9Zsyb4bgMhp9jbfKAT8r68zNBSG0uJCiNdcs7A/16K09hksVNCRh8xTBQ+/YebBI
	 Q5S4uejNa7nVIAxRoq0RngeS88z6/mJTcT1xfzj68oA/M80zK5prdB4iNyMUnquP40
	 z0RriQ60M+5qg==
Message-ID: <687b4ef4-651d-4c13-8fb7-e2c600941e91@kernel.org>
Date: Sun, 22 Nov 2026 16:58:09 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm/hugetlb: a min_size-only hugetlbfs subpool is kfree()d before
 its last pinned page is released, so free_huge_folio() takes a spinlock on
 freed memory (UAF)
To: =?UTF-8?B?5b6Q5pmX57+U?= <xuhx@hust.edu.cn>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <4c7f9772.192e1.1a17d5c2ed5.Coremail.xuhx@hust.edu.cn>
 <2026102727-data-sequel-ce41@gregkh>
 <566ddeb4.2ad04.1a202302fe1.Coremail.xuhx@hust.edu.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <566ddeb4.2ad04.1a202302fe1.Coremail.xuhx@hust.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AD82214000B
X-Stat-Signature: 9os6xnmy9yycgxmi8rcecs3ocpoy5jjc
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795363094-677536
X-HE-Meta: U2FsdGVkX1/2Si205sGNGnQEU//n/MlwJ1k5O0lQ3trmUeo9lUF7OSaRg1FKXDKldpLHivY++E09Sve+nWU4xgN97ZJxVlxM/NjClrKEkDfTPMW+5ZZvF7/MtjF5O5tGoQIwQ5l8+t6plg4op5422w5bxQtcYZELfGSvHgH3vlPqLclfm83SCPrxiSUIb+4i1UXrbAmg3GW6n/hmP3XwZnCxO6PH3RTbAJ38lk9pIfX2PcAtrRGZ59DJEq5PH+5Nmr3zIALMe1P7Svmro+jo9jwVWPbBZbyYbF8rVHQFxk5qwjBD3ygmR4AEhUfnfLZYDu5UQWF9y6j3mLdSCh1I4l/5Vc4mm6+VFArr5s8pSBBEeFeyqtb/1sr06+jzmPqNoTxufJmGzfKkt+Aa8Oi4nHDYZt8LCvIGzLH7CHFzvBgH/Iok1mCmAHUgGl5xHpscxVSxQvBpfuLLXq6nUHBopJXSXNBnIO1UbRWMJoaGiMF5fabfQAX5YW8fGjxFLg0Ys3gtwzY/AEW3H4vlZRs3Fri7+SswN39aH8pi6wvjWlukEe3LTy2RGm6aBcsMApa22LbpXqXq7EoyNMy1WNSDEsSGlR4jwxjMRSWvuw99juA3c3mQSzb/diKvqjhBFxoli/H0XAsHoo/K3Z0bFY9i/Scj4tyxHqi6FS/Ggc+sSn+2+jgfW0DRhNrSct/VXS008MKZmWB7r+6q1HdueGYktaVy+rbcklZdZPSF1/n6lKPMgB6Run2jyq62WoRbSh7NshHpgn1iUL++rou06y7uBo5lrLvFMdwcubqeZkooAuRnMYEN0YBJibiXED0xSsvmopNu5GA67o1QGbCizacuahGe2uFLITnGV6IbO9h7Ic6v00Hom3g4nR42dYuN60zjbbSmv/9c0F+NM/jof9CNrVbteSZG335LuKtwNtMp2q6Z1eUC915qwF1dhiPC/7kMWucMpcDSHvSQjqbb0kY
 909aJrrM
 +RtAkRW7uOwA6rBrr61JDZivnriBlubBksY9CCp+uWcLi1njLdPoBjiXuxv17qekCHburVRKrPQkYeOyBXtQQg4+C5I7kRzNURs/FpAGwJvkociEc6Mi1AK5utDxqavaT9ESL5qoSP43GyiRWiDM2JOxvQZVp9OPqsJhyf9O4BdmXmW6g6jExdopF+bnuCSx64cmgL0ZXL351XJcUuq9nr51l/H2RBDZsev/aanBqQl5uyAolxbc1SM7zqhzsxs0QQ+PsMKGuiv5+Bx5kpZT6Sc+8K2M3NEYKTZI823/VQhGVihZ+F+r5/jYihW/pMC4cxf/w4rCom+k+jZg1eiMZNmTYzxmg463H8oWFmYuXLF/sN06o8JY7cjIiWxzgMbirJuZaANlPLUtUEf0zEAlSN529bWvPqHwf2cUuw8lyeCynGI9UuvFpjY31AJh3aaS8xETi6rf/vCas6QJSKGcVry47vssThZcQyHDkux7jXvkxOiIvVzGR4rGO98d1CvtKmknFjULTRxBVSXZ6qS4re5Ckx/TtnDPIlH8MK92bIXKQUD349ReYrMRP9nuVIGhnA68HhFwa1pXPxMY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/22/26 08:37, 徐晗翔 wrote:
> A hugetlbfs mount that sets only min_size= (no size=) leaves
> hugepage_subpool::used_hpages unmaintained and clamps ::rsv_hpages to
> min_hpages, so subpool_is_free() can report "free" while folios that
> still carry the subpool pointer are in flight.  The destroy decision is
> taken under spool->lock but the field reads, hugetlb_acct_memory() and
> kfree() happen after the unlock, and only superblock handles are counted
> (spool->count), not folios.  A page that a user pinned with vmsplice()
> outlives evict_inodes() and put_super(); when the pin is finally released,
> free_huge_folio() calls hugepage_subpool_put_pages() on the freed object:
> it spin_lock_irqsave()s the freed slab and dereferences spool->hstate /
> spool->min_hpages.  KASAN reports slab-use-after-free at the lock
> acquisition; on a kernel without KASAN/quarantine the same path reaches a
> second kfree(spool) and hugetlb_acct_memory(h, -min_hpages), i.e. a
> double free plus an unsigned underflow of hstate.resv_huge_pages.  The
> whole PoC-A sequence is single-threaded and deterministic - no race
> window needs to be widened - and three variants reproduce on 7.3.
> 
> The detailed description:

Thanks for the report!

I have an AI generated report+fix for this problem pending for rework already.
... but I'm focusing on non-hugetlb first, I will get back to hugetlb soon (or
delegate :) ).

-- 
Cheers,

David

