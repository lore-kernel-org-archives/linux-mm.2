Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9069CFC538
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 14:09:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DCBF6B000E; Sat, 22 Nov 2025 09:09:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28D166B0010; Sat, 22 Nov 2025 09:09:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17CB66B0011; Sat, 22 Nov 2025 09:09:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 016506B000E
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 09:09:26 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A0269140916
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:09:26 +0000 (UTC)
X-FDA: 84138425532.04.6379C4F
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf26.hostedemail.com (Postfix) with ESMTP id A35B614000A
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:09:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="e4eJ2S/a";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763820562; a=rsa-sha256;
	cv=none;
	b=X3c1Ae8DzJX6VbiVNIAtX5PSIehH+w4ON8ARCOgYSuWSl2fjbAUQjwfU71jbPQw4Yb/fVr
	VZko2kUnIfCdjkZJjp/RNFN9ePqDOoc5HtjnJtR9u217KxmwUOND2o5Y6iATZn2hn5kya1
	3by95nWetPJ64TSOUgqcOU0YFHKLlp4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="e4eJ2S/a";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763820562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ZDjsY2sg6rvsyUvNLcAYz1go/aL8BSTJ+KSEmWdUmM=;
	b=4jM7azvYT1egKFm5O38nesm7gz8DmdyO7jxtR5QOp5M60pqwDyvU32+zNUwaVQ4KKoVclM
	Znp5gp82wpkqjiLZuopd9dHuNgFk66h0zQIurCcn3rfiK8f8QNqhlUQ1aVdM6urC4Y0lce
	KgCZkJ0pcjh3aZQZrjthUMVrG6+/VE4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763820557; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=3ZDjsY2sg6rvsyUvNLcAYz1go/aL8BSTJ+KSEmWdUmM=;
	b=e4eJ2S/aNNfPW+aDnhFZIZY/nsFKTgLYpbsQqeTQThk+plL2pqPqTNDZMKL66KXgIikZfJD6N+ejHEObQy5IihJoPqBUAFKAevOy5ibaQRIkPs44wudonee0VorqrOSShVZogC4Qa09hlo6Cr4F21yjAiKXC1JkmUfOgdz0uGF4=
Received: from 30.170.82.147(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wt4WfL4_1763820555 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 22 Nov 2025 22:09:16 +0800
Message-ID: <2c6906d1-132e-401f-830f-ae771fe836c5@linux.alibaba.com>
Date: Sat, 22 Nov 2025 22:09:15 +0800
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
 <853796e3-fd44-4fc2-8fd2-5810342a6ebe@linux.alibaba.com>
 <ztqfbzq7fwa5znw5ur45qlbnupgepaptzjaw2izsftbtth6zca@db4ruyaulqab>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <ztqfbzq7fwa5znw5ur45qlbnupgepaptzjaw2izsftbtth6zca@db4ruyaulqab>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A35B614000A
X-Stat-Signature: aqzyh1mdea9daw8uo8t66usncu9e1jr9
X-HE-Tag: 1763820561-728813
X-HE-Meta: U2FsdGVkX1/COltJvXiG2AacyINYx8Z4MD0DdgVsdmCJgwUZxq8Tcwh7nARNZ3YD2Qk3RD0KjSm1NwEO8wsOe/qKcGsugBGyQA3dI7i7JXoQoFVfARS1T6oJit5fOFBG2qplFzNYWerKu+f27MYEQmazVPyHYfDbz+pUDO5E87oxF05rVuMrd6aFUHDWpG01tbl/1r0zpd2+ICXPApJ0jFLdkdZOcoBmo3haEPTdLwzpUa0DIk20t157F9isbV/uoqOZZ6XRGl4Jr5tqFyOZRQGpv6UookrE5QdMWOq8sggtNS4SfQwdnjxEF5Z7g/qsgbchO7/Xk0c00phzE2ZSm8jMRsNVf07CVIiwV3VhJ1L173TbZjF61qcGJeDnxP8yWxZvV6ZSXWE5ipI1EvHaJwEz1Y+GkQCPZFs+p7duBwVUXAItehLhrY/xuxrVgLID9aY5W2bktai6jOoJHSfHY7AVZMYSkHG0RPVVYl9LXZJA2QbFZRJTtOo0QxG0WKqHxKChhVnLJ0cq70pZAvZdLO0Sis+alnANIx7dvNxGttJDZbfRF4vBykcp4KVHwnQ27IbeEl2uDK0C8S4O8Zux2NZbQCbk7zZ0sVrYtXILfCcX6DpYOdNhrGhpfxJ4tH6QOgJUWIKNqrGgBtlawZ4N9cWxpiKBgNu0gGEnRgzUprZJ9yuZYVCkwy6A6fwahdrBFwb25i/3HRMYAFQaJb1nGQm/9NvCMB/wfSQHS9VabFltIm95VaZbRlGEImEssNq3SMQ+159lMcvTMiJvd/9f2BHCOKG4iYikJE/Andvf1PoLjSFnM+g65IQodrof29TiBKJEfbaesuuHyABr1bMOj6NkNClH63VjtVcCFSWt/kGgfsaXTDAZyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/22 21:43, Sergey Senozhatsky wrote:
> On (25/11/22 20:24), Gao Xiang wrote:
>> zram(ext4) means zram device itself is formated as ext4.
>>
>>>
>>>> zram(ext4) -> backing ext4/btrfs
>>>
>>> This is not a valid configuration, as far as I'm concerned.
>>> Unless I'm missing your point.
>>
>> Why it's not valid? zram can be used as a regular virtual
>> block device, and format with any fs, and mount the zram
>> then.
> 
> I thought you were talking about the backing device being
> ext4/btrfs.  Sorry, I don't have enough context/knowledge
> to understand what you're getting at.  zram has been doing
> writeback for ages, I really don't know what you mean by
> "to act like this".

I mean, if zram is formatted as ext4, and then mount it;
and then there is a backing file which is also in another
ext4, you'd need a workqueue to do writeback I/Os (or needs
a loop device to transit), was that the original question
raised by Yuwen?

If it's backed by a physical device rather than a file in
a filesystem, such potential problem doesn't exist.

Thanks,
Gao Xiang

