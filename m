Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4019CCFC531
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 12:24:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742CB6B0008; Sat, 22 Nov 2025 07:24:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CCD06B000D; Sat, 22 Nov 2025 07:24:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BAB96B0010; Sat, 22 Nov 2025 07:24:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 43ECE6B0008
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 07:24:53 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 723E24F370
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 12:24:50 +0000 (UTC)
X-FDA: 84138161940.18.0CABDCC
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4458BA0010
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 12:24:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mp8hASId;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763814288; a=rsa-sha256;
	cv=none;
	b=TbVVz9l7rjhZHiWhikrHobiRsTRECJS6Srfb8N1OSyEnuP+nkx9mKJcDZo3sp60lm5Aspt
	UxfVMX7pebiMxQLI3syedYY7YrVqWAPxC/J51r0UvKogWCsNy9gyV7/emwbLHnoDXB0e1S
	UiG8i0Shucv9NuEfdS/n/LjBJjpxTTk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mp8hASId;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763814288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QlWKRfdPev+JE8xmARtuY3t4ko4RyH2k7HvUC9+LEHw=;
	b=dwEiaLpPn50KzRvi6u5WB2XBULjRJVg7Pi9h1fa3jzycXIhszlc7VcQQRgN5i9xZny88lS
	/wdlGXp2+IYw0IXLy1uO0YFCvZAznb9Mlw5uVXqBIt3p16LGD9c/hExWu/qv+iZCR3QxxK
	nF9muw+JdDecw8AAOEhAG2xV60uw0zk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763814283; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=QlWKRfdPev+JE8xmARtuY3t4ko4RyH2k7HvUC9+LEHw=;
	b=mp8hASIdqguXYT1ils6R5KQm8zPW4wPZ7bUR4n7BpfC+/D8ytrrs3iLEQxinF0s4hyUw4cv5BscDI2g5c/QQCotPv0IjRusUQqQzRbsxPVbzhPRv81R1kAliSJ1jjiiiyDjKe6p9592jvLWJlqeLEKDGnGn3ODwDZuUD+s904p8=
Received: from 30.170.82.147(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wt4IUZV_1763814281 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 22 Nov 2025 20:24:42 +0800
Message-ID: <853796e3-fd44-4fc2-8fd2-5810342a6ebe@linux.alibaba.com>
Date: Sat, 22 Nov 2025 20:24:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCHv5 0/6] zram: introduce writeback bio batching
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yuwen Chen <ywen.chen@foxmail.com>, akpm@linux-foundation.org,
 bgeffon@google.com, licayy@outlook.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, minchan@kernel.org,
 richardycc@google.com
References: <ts32xzxrpxmwf3okxo4bu2ynbgnfe6mehf5h6eibp7dp3r6jp7@4f7oz6tzqwxn>
 <tencent_865DD78A73BC3C9CAFCBAEBE222B6EA5F107@qq.com>
 <buckmtxvdfnpgo56owip3fjqbzraws2wvtomzfkywhczckoqlt@fifgyl5fjpbt>
 <8c596737-95c1-4274-9834-1fe06558b431@linux.alibaba.com>
 <kvgy5ms2xlkcjuzuq7xx5lmjwx3frguosve7sqbp6wh3gpih5k@kjuwfbdd2cqz>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <kvgy5ms2xlkcjuzuq7xx5lmjwx3frguosve7sqbp6wh3gpih5k@kjuwfbdd2cqz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4458BA0010
X-Rspamd-Server: rspam07
X-Stat-Signature: y4gkpaijznfcwk1diran3t7netgadofg
X-Rspam-User: 
X-HE-Tag: 1763814286-936661
X-HE-Meta: U2FsdGVkX19N+k+EShI1eFrkmHZes1PP2cyr6iHFtaCKPSKT+X3Fjq2pk4Fg27PCk4MOOODxPU3II42GRt+tPYmQjXzKtr8ZkpxFfllUKYncHoMb/TdKCabyewaFet21SIxvMq2Hu/84KgFqF2K71TrwpIFFkGaDcDvpkuXBP/Xlb0B7g5da2imdaeUu61V+s+9DePxmNBuXYti1bqtgNFBz1cwTcb2pYAkVQQRuprA4hN8MqRyGq3aUlrPLBQpm1LqdUEOPiSORCFnm84zRMQYnV7F7atUpOBWjxnErhtrA0Oc7rSogB54XoWuvoClGjE0h7QB29HBa1Ota1ad1APDpd8EFroK6osS0mcpB87RYHAe1YWOBhs+C78zrCHaxpMCYUTYJh8pjKjzqPWO/4fK5EkHZ2O9GNg7nvGvlb8PlljyF1y5+757VpLZbThPRBh1B8972KSHThcBxwDjrYUtLtPa/2Do8ylaGpl76O18nTvcMtLhRQZb6OPxUAph8df1vYgYEMalApdzbF81Q35lxVWU9gcMHWqm+e7Ry29gU6ACQ5vHN7DCaHv3l2WtpNBXfzBIH9G6AuCAJBweSjyObiUw+b47qdhHdt4uB6RAndGk79bznbuuNoP8xYe56XGEt9XawlbOrc6Nv6oE6OFBea5BBrGS5FGMLqlp2TZZfVlGMMSTdaRqUlouDrj7eV0iZO/tEcbgsD3R2GJeJ1y1EozB6OL1NfA7vAFVQfE+GCY8vic8+YBMFVUPzk5sOp23R3bRaq0tVquug79XM0vb7UbHv2fAGsjQiqy2riyHvHx8kWksC9hrDR4j7KLy5isRdBpM1m9nL+tPK5M6cTg8QNpOeYviq2mCOb+gBJ8VrYzDJGW3tjGKea69iXn9TGe268AYAmhIVHhI4ZaHre9UXGqOAv+xcKaU+E40IZ3uRrzUzwYf9gxPLVdg+erEO5heVgsYTGsBK0P5QCrm
 BZvymC61
 w9egAZ5tbIb/P4W8VcCaq7sUoPxJOTJeiS0un9z5HGkGzkIf1IYhZcY6zuSYrUkRFGdPukwi/XhW+lsMlYhsxwB/Lmo2Y3vZq300P0UzjbS64OrG0+5GpZS+JHchoOWifg9LySs1Tf7yukoa0UiGR6Jgi9QTTs6WBae8ckd/fQ4l9C8j8spcCpTLyGkUcYY9rPovJLdu1i+S/RicwbgHt8BOnK9uzv80NLAdSVoly8MUDao8MwnC78R+4mzCq0ep3mwYyDMRRncK6V9xj/PwWn8FOS4tPfKOBEN0WpsQ2XFYisRH4T0FtMzE5ObXFzRxZNwwX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/22 18:07, Sergey Senozhatsky wrote:
> On (25/11/21 20:21), Gao Xiang wrote:
>>>>> I think page-fault latency of a written-back page is expected to be
>>>>> higher, that's a trade-off that we agree on.  Off the top of my head,
>>>>> I don't think we can do anything about it.
>>>>>
>>>>> Is loop device always used as for writeback targets?
>>>>
>>>> On the Android platform, currently only the loop device is supported as
>>>> the backend for writeback, possibly for security reasons. I noticed that
>>>> EROFS has implemented a CONFIG_EROFS_FS_BACKED_BY_FILE to reduce this
>>>> latency. I think ZRAM might also be able to do this.
>>>
>>> I see.  Do you use S/W or H/W compression?
>>
>> No, I'm pretty sure it's impossible for zram to access
>> file I/Os without another thread context (e.g. workqueue),
>> especially for write I/Os, which is unlike erofs:
>>
>> EROFS can do because EROFS is a specific filesystem, you
>> could see it's a seperate fs, and it can only read (no
>> write context) backing files in erofs and/or other fses,
>> which is much like vfs/overlayfs read_iter() directly
>> going into the backing fses without nested contexts.
>> (Even if loop is used, it will create its own thread
>> contexts with workqueues, which is safe.)
>>
>>   In the other hand, zram/loop can act as a virtual block
>> device which is rather different, which means you could
>> format an ext4 filesystem and backing another ext4/btrfs,
>> like this:
>>
>>    zram(ext4) -> backing ext4/btrfs
>>
>> It's unsafe (in addition to GFP_NOIO allocation
>> restriction) since zram cannot manage those ext4/btrfs
>> existing contexts:
>>
>>   - Take one detailed example, if the upper zram ext4
>> assigns current->journal_info = xxx, and submit_bio() to
>> zram, which will confuse the backing ext4 since it should
>> assume current->journal_info == NULL, so the virtual block
>> devices need another thread context to isolate those two
>> different uncontrolled contexts.
>>
>> So I don't think it's feasible for block drivers to act
>> like this, especially mixing with writing to backing fses
>> operations.
> 
> Sorry, I don't completely understand your point, but backing
> device is never expected to have any fs on it.  So from your
> email:

zram(ext4) means zram device itself is formated as ext4.

> 
>> zram(ext4) -> backing ext4/btrfs
> 
> This is not a valid configuration, as far as I'm concerned.
> Unless I'm missing your point.

Why it's not valid? zram can be used as a regular virtual
block device, and format with any fs, and mount the zram
then.

Thanks,
Gao Xiang


