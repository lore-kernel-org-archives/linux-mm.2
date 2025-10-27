Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F8BECCF9E9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 02:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 369B580010; Sun, 26 Oct 2025 22:57:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33DDC8000A; Sun, 26 Oct 2025 22:57:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27AD480010; Sun, 26 Oct 2025 22:57:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 11FE48000A
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 22:57:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6FDF187A95
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 02:57:26 +0000 (UTC)
X-FDA: 84042383292.11.C0A6273
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf25.hostedemail.com (Postfix) with ESMTP id 06B15A0008
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 02:57:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="c/3+pTM4";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of libaokun1@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=libaokun1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761533844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bmKr3gs2o9uU3aOUtwCT4DF/FX3VA2tgiedTv3vuvRk=;
	b=1AoQ6jDTkEuORleG+zoI6DXulUwZ1m4l62QsFqQwAORbDuMVsnFzEI3rPQn+wlLmS7pMFi
	64qXZBg4NmrsycmkB+/wi090ifl0ubQ6ogYiiwpNpWpxbPCzaBfLmNKtlcH2R17lWVzndU
	Mojssjgp72UCWTo6ecS7rRf9oz/nwuA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761533844; a=rsa-sha256;
	cv=none;
	b=mTlLhohoo6U+aj78gvn5uQn8ubeIqciLSpAj+OQyw3LliOXjX5vG2LQw2Wojnf3pOsTdqV
	EzJXcRkwoWFKmjwwQzXR7AbX5FSObvhGUMZsSpwPKpnDavWyRYXc5MpnAnrgLB5rWZEc4+
	+mEgM8Jq72Sn7DZIn2vdHwF9eYGBuO4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="c/3+pTM4";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of libaokun1@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=libaokun1@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bmKr3gs2o9uU3aOUtwCT4DF/FX3VA2tgiedTv3vuvRk=;
	b=c/3+pTM4U8FSRw10vA2AeHj0gabjZulb7wdAhA8uw2gblZ2Xp2TjEkoUjwO2h2EJUch1F74Wk
	4c6X7APTEccLl4DMvNL07Efjc/z1nregFeU9v5LLEOPDUERXQTKtIMAtfWklCzxu86uf2xUk+dt
	zN85c0VETcO4PEJuTWDpGSo=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4cvynY2VLYz1T4Fg;
	Mon, 27 Oct 2025 10:56:17 +0800 (CST)
Received: from dggpemf500013.china.huawei.com (unknown [7.185.36.188])
	by mail.maildlp.com (Postfix) with ESMTPS id 15FA21400C8;
	Mon, 27 Oct 2025 10:57:18 +0800 (CST)
Received: from [127.0.0.1] (10.174.178.254) by dggpemf500013.china.huawei.com
 (7.185.36.188) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 27 Oct
 2025 10:57:16 +0800
Message-ID: <2d5ee2b9-e348-4d4e-a514-6c698f19f7e5@huawei.com>
Date: Mon, 27 Oct 2025 10:57:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 22/25] fs/buffer: prevent WARN_ON in
 __alloc_pages_slowpath() when BS > PS
Content-Language: en-GB
To: Matthew Wilcox <willy@infradead.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, <linux-ext4@vger.kernel.org>,
	<tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
	<linux-kernel@vger.kernel.org>, <kernel@pankajraghav.com>,
	<mcgrof@kernel.org>, <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yi.zhang@huawei.com>, <yangerkun@huawei.com>, <chengzhihao1@huawei.com>,
	<catherine.hoang@oracle.com>, Baokun Li <libaokun@huaweicloud.com>, Linus
 Torvalds <torvalds@linux-foundation.org>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-23-libaokun@huaweicloud.com>
 <aPxV6QnXu-OufSDH@casper.infradead.org>
 <adccaa99-ffbc-4fbf-9210-47932724c184@huaweicloud.com>
 <aP0PachXS8Qxjo9Q@casper.infradead.org>
From: Baokun Li <libaokun1@huawei.com>
In-Reply-To: <aP0PachXS8Qxjo9Q@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.254]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf500013.china.huawei.com (7.185.36.188)
X-Rspamd-Server: rspam01
X-Stat-Signature: adhbnei7566ub1ke67i9ukip8kt7huce
X-Rspam-User: 
X-Rspamd-Queue-Id: 06B15A0008
X-HE-Tag: 1761533842-624712
X-HE-Meta: U2FsdGVkX18zHdI4YRDE3DT3yqWJ3WyE3p+Vb/LunK3NKch3k7MZWKldgAdOnvRaBBA10+32dC9kM+8Mxf2/VkwP+nEngQARuCH7wM7fF+Twt6EmD7uILQgpdOeT0ucGJL8u08UFzYGvrulgbZLKhZwL5qAjvpSROF57z57pYibZl2XaRCzPZmxWtcMcRb6dEObGg2TyCmZhRwcqdLjw/TdS7ht78m8nSF3noq9SzKJzohGYWbykzBYmAaxMO2KzFgdE/0J8zcnJW+J1Ha1cAf7/+4upfTjr8IG758+N9S5q4b9DvsQWwZxTcR7VCSBn5dRkVBBjns2ASXRbeFN6CMZAjq3se8OedgGRxwlx0Vlz7bYSleQlHHzhqp+5VCldJAn4gwiaLdcKjUWWlKM6zdDlgAdij9sT7gsRF76Bh7PCQlxz+EGVJLpLUN0HIdBOzegzxyEX452O/AlafKryqlHTPzzavH4O/kiZUmyWUTgSZAwRPNblZYSMNu1MfsJz10lv8wJgTUd1Lm0LKUF143rT9dvJ+Fft6kBxumCzCaLOpo0kb8mHFdkwACbBSTk5Nww/peF2Rs9vgg2Fqi429zkPwmy6sd0VGFU7xcbaeI+nMJyI8Zhb4Od/Q2QiHuOIytoL0YLtSBG7MAmrj1FHkUcfX4CQ9bElKh45LB9UeGjJQAzzXFCKJbDpBWcjmYHZHYxkrtmcU/7MJpm+xKA0tH7VhBgWaVgEBpIl9+xom00ts72OAvEjYx5fZpGFYodAfl7caGQFFAshgEKxEpkRjKI8sCSO8o4330f8dcQwxf397NlcUuFJ5dxX02GALHXASSof3gEP1Y9HvHZJOfNxUG1apWx5xqwzHEqakbZP+UiXK50jbP0X4lH+g4YV6lkkTLCGhqFI+TlK6IlnddVrVt37OzBLonO6fqqh3Z2P8YG8XDR/U3hbXpmSqdwLK6orwEAzNP7UhO+CX9XSEYS
 ghR4TrGZ
 HYUNIztqAaIrJ5bMJSQForHrR5O8riD2tl6bb+HaYmjaWCqn02boNCPiDAgzKcuYuykjr66XhqtL4JMkBG2WjchbPnzmBPQmdMPubGjHHizhrW5/NsJDC4/+yAZQBqntEzE+sPSLCsLHDNr5J9QRfcqmsnOUwH8/8VPym4j0OZzOkXL3jK0c/J8Byy5/U0JAro5AQtYQF4h8q7TxvDODRa6x0QLdc/NJ+f5RQTIM46HpY/lYNjtfKVkp5C7NcpU3IWFuU/Awb3Yv5kwXT71o3VO9jpNnaImCOV00fvKPrQvrpy3gpyu0f4pPw3wKa7B/1hZUVtdc16i/jUCibbkIOGHgwiCIr3naGMCn9H9aY+nSvNGyxJmfKG0pVzipgw3UxMonv8mea2zkiZm03UZUP3eGGlAY7oOiZj4xU8YXhPklnoJy5azwPrYge+iZoqTLw9eYNSUCS1C3uL9x+B1JcvNWtIMTktpXXV+Au6hMdu0mNMNm/1sM3rDoloBrUQMBTzywbluy0Y4MHcAvX8s6w2HRTsJ+DetDOQJ9EH2BYOIFY3S0Haq3/xvU3GHAb+cEyze9L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-10-26 01:56, Matthew Wilcox wrote:
> On Sat, Oct 25, 2025 at 02:32:45PM +0800, Baokun Li wrote:
>> On 2025-10-25 12:45, Matthew Wilcox wrote:
>>> On Sat, Oct 25, 2025 at 11:22:18AM +0800, libaokun@huaweicloud.com wrote:
>>>> +	while (1) {
>>>> +		folio = __filemap_get_folio(mapping, index, fgp_flags,
>>>> +					    gfp & ~__GFP_NOFAIL);
>>>> +		if (!IS_ERR(folio) || !(gfp & __GFP_NOFAIL))
>>>> +			return folio;
>>>> +
>>>> +		if (PTR_ERR(folio) != -ENOMEM && PTR_ERR(folio) != -EAGAIN)
>>>> +			return folio;
>>>> +
>>>> +		memalloc_retry_wait(gfp);
>>>> +	}
>>> No, absolutely not.  We're not having open-coded GFP_NOFAIL semantics.
>>> The right way forward is for ext4 to use iomap, not for buffer heads
>>> to support large block sizes.
>> ext4 only calls getblk_unmovable or __getblk when reading critical
>> metadata. Both of these functions set __GFP_NOFAIL to ensure that
>> metadata reads do not fail due to memory pressure.
> If filesystems actually require __GFP_NOFAIL for high-order allocations,
> then this is a new requirement that needs to be communicated to the MM
> developers, not hacked around in filesystems (or the VFS).  And that
> communication needs to be a separate thread with a clear subject line
> to attract the right attention, not buried in patch 26/28.

EXT4 is not the first filesystem to support LBS. I believe other
filesystems that already support LBS, even if they manage their own
metadata, have similar requirements. A filesystem cannot afford to become
read-only, shut down, or enter an inconsistent state due to memory
allocation failures in critical paths. Large folios have been around for
some time, and the fact that this warning still exists shows that the
problem is not trivial to solve.

Therefore, following the approach of filesystems that already support LBS,
such as XFS and the soon-to-be-removed bcachefs, I avoid adding
__GFP_NOFAIL for large allocations and instead retry internally to prevent
failures.

I do not intend to hide this issue in Patch 22/25. I cc’d linux-mm@kvack.org
precisely to invite memory management experts to share their thoughts on
the current situation.

Here is my limited understanding of the history of __GFP_NOFAIL:

Originally, in commit 4923abf9f1a4 ("Don't warn about order-1 allocations
with __GFP_NOFAIL"), Linus Torvalds raised the warning order from 0 to 1,
and commented,
    "Maybe we should remove this warning entirely."

We had considered removing this warning, but then saw the discussion below.

Previously we used WARN_ON_ONCE_GFP, which meant the warning could be
suppressed with __GFP_NOWARN. But with the introduction of large folios,
memory allocation and reclaim have become much more challenging.
__GFP_NOFAIL can still fail, and many callers do not check the return
value, leading to potential NULL pointer dereferences.

Linus also noted that __GFP_NOFAIL is heavily abused, and even said in [1]:
“Honestly, I'm perfectly fine with just removing that stupid useless flag
 entirely.”
"Because the blame should go *there*, and it should not even remotely look
 like "oh, the MM code failed". No. The caller was garbage."

[1]:
https://lore.kernel.org/linux-mm/CAHk-=wgv2-=Bm16Gtn5XHWj9J6xiqriV56yamU+iG07YrN28SQ@mail.gmail.com/


From this, my understanding is that handling or retrying large allocation
failures in the caller is the direction going forward.

As for why retries are done in the VFS, there are two reasons: first, both
ext4 and jbd2 read metadata through blkdev, so a unified change is simpler.
Second, retrying here allows other buffer-head-based filesystems to support
LBS more easily.

For now, until large memory allocation and reclaim are properly handled,
this approach serves as a practical workaround.

> For what it's worth, I think you have a good case.  This really is
> a new requirement (bs>PS) and in this scenario, we should be able to
> reclaim page cache memory of the appropriate order to satisfy the NOFAIL
> requirement.  There will be concerns that other users will now be able to
> use it without warning, but I think eventually this use case will prevail.
Yeah, it would be best if the memory subsystem could add a flag like
__GFP_LBS to suppress these warnings and guide allocation and reclaim to
perform optimizations suited for this scenario.
>> Both functions eventually call grow_dev_folio(), which is why we
>> handle the __GFP_NOFAIL logic there. xfs_buf_alloc_backing_mem()
>> has similar logic, but XFS manages its own metadata, allowing it
>> to use vmalloc for memory allocation.
> The other possibility is that we switch ext4 away from the buffer cache
> entirely.  This is a big job!  I know Catherine has been working on
> a generic replacement for the buffer cache, but I'm not sure if it's
> ready yet.
>
The key issue is not whether ext4 uses buffer heads; even using vmalloc
with __GFP_NOFAIL for large allocations faces the same problem. 
 
As Linus also mentioned in the link[1] above:  
"It has then expanded and is now a problem. The cases using GFP_NOFAIL
 for things like vmalloc() - which is by definition not a small
 allocation - should be just removed as outright bugs."


Thanks,
Baokun


