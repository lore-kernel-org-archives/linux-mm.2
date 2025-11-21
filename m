Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44826CFC269
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 12:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 936D56B000C; Fri, 21 Nov 2025 07:21:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90DCB6B002C; Fri, 21 Nov 2025 07:21:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84A5F6B0092; Fri, 21 Nov 2025 07:21:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 715506B000C
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:21:56 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C58C3C0575
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 12:21:53 +0000 (UTC)
X-FDA: 84134525706.09.883BDDB
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 47B97100011
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 12:21:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=X2s0q0Bo;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763727712; a=rsa-sha256;
	cv=none;
	b=jVgNU2jIYb5LFigYPd5y3hnrO5djGdE1QFMj5bTgHTTlK4NN+iUApqAZiDhpBYWf42vYLJ
	F9fG9lTLgw63B4vTlguZKN1BtPu+ZaxZDQHwkmQTdPue2rmZ6m5wT6o53bVWtDMjXq7OC6
	l4oT8dkFAAjANMXQjdiic0Favxftwtc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=X2s0q0Bo;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763727712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4VddRBqQQlyL+Xj+/XmM94zKGHnKwIKpRSELjbmbuWM=;
	b=turXLI/zlMwtSK7n9rPELgIYICc+vtUkCLnLBGR7yG2tjOJbR1tzn6pZfFYgiAGQV6ubS1
	6yqxSlC80htX+FvtRgAF9DNeakpErfW/2NxCWH7QVa+23BPFwJqXR7FI6QLbWD6jFB0l9t
	pwQ+LhQZTNAt2Z1DNT26/1x0zeq0BN8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763727705; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=4VddRBqQQlyL+Xj+/XmM94zKGHnKwIKpRSELjbmbuWM=;
	b=X2s0q0BoUx/F+s53tUkr08sBs+phG7EyyovIKQNyYQpZAJPGWv+t8116ZvV+EcrAlfgW889X6M+rDvbsKaDLC7KofF2s/0Krg8UDNEcLJX35PrBMztxGK/RFDfi7b3DwBIR2rRfHqXPa0W9LCcG0b4UjQkloB777/YKBFJB8uws=
Received: from 30.170.82.147(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wt059Jp_1763727702 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 21 Nov 2025 20:21:44 +0800
Message-ID: <8c596737-95c1-4274-9834-1fe06558b431@linux.alibaba.com>
Date: Fri, 21 Nov 2025 20:21:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCHv5 0/6] zram: introduce writeback bio batching
To: Sergey Senozhatsky <senozhatsky@chromium.org>,
 Yuwen Chen <ywen.chen@foxmail.com>
Cc: akpm@linux-foundation.org, bgeffon@google.com, licayy@outlook.com,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, minchan@kernel.org, richardycc@google.com
References: <ts32xzxrpxmwf3okxo4bu2ynbgnfe6mehf5h6eibp7dp3r6jp7@4f7oz6tzqwxn>
 <tencent_865DD78A73BC3C9CAFCBAEBE222B6EA5F107@qq.com>
 <buckmtxvdfnpgo56owip3fjqbzraws2wvtomzfkywhczckoqlt@fifgyl5fjpbt>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <buckmtxvdfnpgo56owip3fjqbzraws2wvtomzfkywhczckoqlt@fifgyl5fjpbt>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 47B97100011
X-Stat-Signature: 73jej34pan83pxxc567mwznrnyg4ww61
X-HE-Tag: 1763727709-785067
X-HE-Meta: U2FsdGVkX19WZKkoGsPWurzrCVED16kYVBFVQIgsUmyOjfBh5R4yHjfZ+ef4Xmp08KaEh6CMr4dOus3ON2TYrP9Vn63yJFEEX2gXmZ7j4wOAKXjp2HD5riCj52woTbynvoUW4uDUTa8TUKXlSrbS00SNKn88GGC03pRHa7f6AUz+JoNZXgzF2KfvaZPYzvDG3Y/IHgnLvCwxVfdxcmbDGk0M2OfGTZXGShcfDBUid1BOv0VM4tlMYK707pNxI4S+dXhJ1CoaiMN8umUoslSCT44hJuw9eefN657fT8R5pCZkK/d5KuLksJi+yTnD4JoPZfPrOa+TzZN/osORxfiAGjSif3MAYMpJCBJAuTSIyt/wjy71hhbYkn+smQ3eHalK1pp6wCCGBrKmUQfnheLte8JvirgJoIFivxWrHvtrA8M+2qYRT0/q9dvGyH9q+bwYAA1YEc0KZpdgfAl3GsyHJO5NCqP1bP3tdvyQKN7QS32ZLnqpT3uBATCetnQ8QSA9NPETI9kxeF52rGfCUV2LY4NYRnOp/7hKU3RZ5sl5WzzHEvp56mv4+8kS6h6LWIzbC//bHNO5xXJ0JtvjP3Nf0/q8U/heZ4JZKv1oCf3GCgGsFfAHsJmDWvNz91P+vjvrl6UHbWS9E2a5wx4BUbQwjqYwEqNIh09pVtNdrBnvNxOMeLmFaiM7jQc2BDFyvfZvxdAvz4HPF0CQJCqSJa0L3A/ds84NJOjuiea4nell2G6PmgBBxgOlWq0TxhTlRoD8ptfjUeOtBea4aieQChB35tD6SmgBavi3socVUD8+u9xnSs14hMOWEW4GVcUVPnO/RlI8Vgw2ZAM7ljYVyIop8a+sZG0K90SO7CAMpME4ZlcfKQVqGlaRB82r+ZONLiDVJ53JCK3AN20yor2YEoTHP6U9pZXjCJn2BoNHMBJ7SFqhRSw2x25Zzm2I/38HJZyX7k7xyfei7a7vE2D7gCJ
 DIo+a9vv
 Y8nshZy1eOqq9dMkNOnk3n1bCtYZbcR5fW46g0dF5IOhsZLgkTocVcIowwSJsMWl1Qu9XY73ETUAbhSocKDafC1r8uICzt8o/EyRJ2GANFDar1v/THXCPHha8wAnMn52nsJ+urAy7+R4/qp7L8To6orfLBkxKd5wLOqI0sxghv0kW7+fxo8Ecw3f7Utsu+ruMvRywqu+QRpfn6o5nTDOzfp7hPFYgA+yE7WNj9P/bez+Q8ONHtpBgkq1rHLW5qMyDVWHW4eCaxiYT3PEtI/qXWZvO/Z5b4oXBhJl9D/zmT+uEKWuvFQWY2irXP9zvJ1W5963v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/21 17:12, Sergey Senozhatsky wrote:
> On (25/11/21 16:23), Yuwen Chen wrote:

..


>>> I think page-fault latency of a written-back page is expected to be
>>> higher, that's a trade-off that we agree on.  Off the top of my head,
>>> I don't think we can do anything about it.
>>>
>>> Is loop device always used as for writeback targets?
>>
>> On the Android platform, currently only the loop device is supported as
>> the backend for writeback, possibly for security reasons. I noticed that
>> EROFS has implemented a CONFIG_EROFS_FS_BACKED_BY_FILE to reduce this
>> latency. I think ZRAM might also be able to do this.
> 
> I see.  Do you use S/W or H/W compression?

No, I'm pretty sure it's impossible for zram to access
file I/Os without another thread context (e.g. workqueue),
especially for write I/Os, which is unlike erofs:

EROFS can do because EROFS is a specific filesystem, you
could see it's a seperate fs, and it can only read (no
write context) backing files in erofs and/or other fses,
which is much like vfs/overlayfs read_iter() directly
going into the backing fses without nested contexts.
(Even if loop is used, it will create its own thread
contexts with workqueues, which is safe.)

  In the other hand, zram/loop can act as a virtual block
device which is rather different, which means you could
format an ext4 filesystem and backing another ext4/btrfs,
like this:

   zram(ext4) -> backing ext4/btrfs

It's unsafe (in addition to GFP_NOIO allocation
restriction) since zram cannot manage those ext4/btrfs
existing contexts:

  - Take one detailed example, if the upper zram ext4
assigns current->journal_info = xxx, and submit_bio() to
zram, which will confuse the backing ext4 since it should
assume current->journal_info == NULL, so the virtual block
devices need another thread context to isolate those two
different uncontrolled contexts.

So I don't think it's feasible for block drivers to act
like this, especially mixing with writing to backing fses
operations.

Thanks,
Gao Xiang

