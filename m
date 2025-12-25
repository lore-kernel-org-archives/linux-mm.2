Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EA38E7AD42
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 10:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C7C36B0088; Thu, 25 Dec 2025 05:08:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 475FD6B0089; Thu, 25 Dec 2025 05:08:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378266B008A; Thu, 25 Dec 2025 05:08:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25AAB6B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 05:08:16 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CBA33138BED
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 10:08:15 +0000 (UTC)
X-FDA: 84257568150.17.8956CAA
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0564B1C000A
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 10:08:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="Tu/z/cIv";
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766657294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgFMQJIl6IU/hL8mMn/JPwDrQ4dql3AhRFfIkIc6/O8=;
	b=UM8GdBQpHL88HcVb/PrwSoLYDv4/lx8BXp+M3dF6YAVzGTNViqgjDqj0HX7wS4UCn6gJTz
	fPeRYfX0Ptldphw+hSsB4CNk/sPzJNENzgMndmInr2/orybe0+uP7F/1N7xNaDWfYKCxAN
	FAIVA7MoohPLoyuBEttc8RJXmCBICcA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="Tu/z/cIv";
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766657294; a=rsa-sha256;
	cv=none;
	b=vm5Yw09vYLU4e70qwiWc5XvLCEZe1d7dzI4gJJXYW6tyeVLgsFcnZ43O/AXw3OqLytcVES
	Xmi9nQXlizks+F/Si7TEM6Lyde2QH61ckpaHcH+eQ1nKDGScO2/WSCbT+eeheXfYqNgIWh
	pJ18JOsk8rm5UaIj0QvlAxt4eWC8Up8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766657290; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=bgFMQJIl6IU/hL8mMn/JPwDrQ4dql3AhRFfIkIc6/O8=;
	b=Tu/z/cIvqd6qIe/fvMYIoTbomBHL8lYpR77CTdS6Ny49+5x8wLsC39Hg7FjbZXLmr7vWasGZmam18PmZdov3diiijTSCvhsxyh9N+2VcUaIhTaGc3HYilG/JvnucDIiHmQGTWEXSCxZkyFJpK5LQOO/aiX+RiUN8UdRZqm2k4/s=
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WveUWeH_1766657288 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 25 Dec 2025 18:08:09 +0800
Message-ID: <bdb7f7c6-ecf5-4da1-a11a-cc19c77fe4f2@linux.alibaba.com>
Date: Thu, 25 Dec 2025 18:08:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: fix uninitialized folio in shmem_symlink
To: Barry Song <21cnbao@gmail.com>, Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
 syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com
References: <20251224094027.65842-1-21cnbao@gmail.com>
 <aUwcV2HhtdiXXxfJ@casper.infradead.org>
 <CAGsJ_4whKLWiw6LNexFPHTFWB1QbSrAwrBtspuc=c8fM2=WnvQ@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4whKLWiw6LNexFPHTFWB1QbSrAwrBtspuc=c8fM2=WnvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0564B1C000A
X-Stat-Signature: u1cmpjhtjidttkut8w74wkto5ipgt66x
X-HE-Tag: 1766657292-232141
X-HE-Meta: U2FsdGVkX18RqtNLFfQBxE+U2TOsFf5TxLKglunhAifssY9XdTFJwM85DgoQpWx4zk+IR2voKi4ulPJZUl3adhGgeQllrnRgoiPe4BMyOVGUa0CDO5b4BPg88sX1vgU0/8iYjtlJI0vw0FACeuaWtFDLZouiH0MVcb2g0dFoTT07sfN+C6+ItmPVHvI8Zpom5lsKZPSIi1u6lr93MJ2wrxogwxOLUzlZWUO8MMNsnsFG85ZWAMRy2EsBxmGsYeCdmu0r5GHBxnTZhbyneEcGiBIk1XBnkt1n1MGkHV644XlUGdB8FDvzlUwM1MgUNz094XeRbxXw/8IltrpKUQ7GF4nkBrY5dmGyL0vISIZkBhoy5HDrGRGQH3pP6M6YeJ3v/e90g7z0e2zkvo9MJtdh81tl0SkTSJENlpfZWdWxF0ZekpOxgFqZ6vs33Skoat7+s7joZ6uXjimUfeUGadIbGmt1WMvT/JjdkwkLgRvzs+26/HpPfnwZWRg0dyfBsbRj2I6tNL0k7xq2LU6G6fGqmWZFCL2HeJftFKoqxrC2hw05P4xbCb1s+NqMxcZ+89644mR6Q46uf+lHUg5M1SSmVCyY3z5rEhzj/RmDNoMXi89KSqRugP9IIzUi5YAmwf6j3w4vMBWxibnFwjxSxVfoJIJ6U1EF+BMRJY75MijYtiuI/Vhq3Q0P2Vcj5D+ao4DOWmwJl27MlT4xSLltU7MJfor9QQc4wtE2wFFJWv6leWgIwEoO+bdSd3AY3YoHpRbPENoaycHJhx3KQu0FBN2VFDCIKbKr6AqqRYi30n3kNdD98yg7ETqkWIDimsd+9Gk/zrwQ81HvnAd6CNKdwFfeQfZMVJF/xrLukNjLJA7Bf7gn/NFbEifzt2M/yPz3Sa5FdFyolQ6iS0Phh4e+lT19hivtciBmd+WmQ7sI4QROOZwGvEjEaFkyYlItmzcpfoZ9uqRn2HZ3V9CexMSocDu
 SKpB7CzW
 y3Zo3lC6ENGwNAc9rQcQQ8rjrBuHhIcPJbg2GhkUE/cqbzQhiUgZWSIvyLTwsldXBpvsDI4FY74Q4vK4ncPHdFbN3PrLsS/bq9xQ7Wv0sqrpeV7ZLqBitrbUgLYuDpeCR/SrW6SfjR0sEfmCR7HSXaDjczAKMp35lG755MSkoIy6K6ojwa3iLbRFW507dprTJ682oFgBapded8nAKHlTXMtAjN+L4Yg1UFoH6gFW+1FSLmRFQb6NB1EY2jYkemI+bXiC1TjCSRBm6WoDOEcwmiIgP3NKKzJW25ZS3xgiJNZG3oakEiPL22xWlRHAe+plrZBNHhsQFMyQp2RfnQBpen0szsxveBQr81QMHlSQnrPg6jqbWIKtL2SfFh37Io8ZeGsHiqRQZhAmr8Dw5EW/hffKVA1YkUWdsNOtC9LoS5ML5QHKuaCAacgW2CbppEYlk1Xvmqf76R34+JjIDIDCcrT+u4IJwh0Y8bhRofxyCHPrlSXHdHCNEhUGAigbvrmcrZrg6ezk5iE379Pab1QrXC6NK1Obd8HAod8Ah6rodYZO5u5yCM51bFJUXIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/25 12:04, Barry Song wrote:
> On Thu, Dec 25, 2025 at 6:01 AM Matthew Wilcox <willy@infradead.org> wrote:
>>
>> On Wed, Dec 24, 2025 at 10:40:27PM +1300, Barry Song wrote:
>>> From: Barry Song <baohua@kernel.org>
>>>
>>> Uninitialized folio allocated in shmem_symlink() may be accessed
>>> during swap-out, causing KMSAN BUG:
>>
>> This would be an unfortunate way to fix it.  The vast majority of
>> symlinks are short, and we'll never access past the \0 in normal
>> operation, so we'll be dirtying a lot of cachelines essentially to (1)
>> shut up an automated tool and (2) optimise a corner case.
>>
>> How about this instead which delays zeroing to swapout?
> 
> Matthew, thank you very much for your review, even during Christmas.
> I would like to wish you a happy holiday!
> 
> I am not quite sure, as shm symlinks do not seem very common. Since
> allocating a folio requires a symname longer than 128 bytes (where
> 128 == SHORT_SYMLINK_LEN), such cases appear even rarer.
> 
> BTW, do we need to migrate the owner_2 flag in folio_migrate_flags()?
> If so, I am not quite sure it is worth changing the hotpath to
> accommodate this.

+1. At least for me, using the 'PG_owner_2' flag alone to mark this 
uncommon case doesn't seem quite worthwhile.

>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index ec6c01378e9d..f3b3be1b50fe 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1636,6 +1636,13 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>>                  folio_mark_uptodate(folio);
>>          }
>>
>> +       /* Zero out symlink tails to help with compression */
>> +       if (folio_test_owner_2(folio)) {
>> +               struct inode *inode = folio->mapping->host;
>> +               folio_zero_segment(folio, inode->i_size, folio_size(folio));
>> +               folio_clear_owner_2(folio);
>> +       }
>> +
>>          if (!folio_alloc_swap(folio)) {
>>                  bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
>>                  int error;
>> @@ -4133,6 +4140,7 @@ static int shmem_symlink(struct mnt_idmap *idmap, struct inode *dir,
>>                  memcpy(folio_address(folio), symname, len);
>>                  folio_mark_uptodate(folio);
>>                  folio_mark_dirty(folio);
>> +               folio_set_owner_2(folio);
>>                  folio_unlock(folio);
>>                  folio_put(folio);
>>          }
> 
> Thanks
> Barry


