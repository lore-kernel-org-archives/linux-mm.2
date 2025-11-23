Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09C10CFD315
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 01:23:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0186B0092; Sat, 22 Nov 2025 20:23:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C700E6B0093; Sat, 22 Nov 2025 20:23:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B85A36B00A4; Sat, 22 Nov 2025 20:23:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A7AC16B0092
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 20:23:41 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3B0CC1A09EE
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 01:23:41 +0000 (UTC)
X-FDA: 84140124642.28.52E6A11
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf27.hostedemail.com (Postfix) with ESMTP id 035334000A
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 01:23:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gyHzibOu;
	spf=pass (imf27.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763861019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VCIF5DLiQMx6oN9DUx9P7XFgjwtiupQtB75jei15lO8=;
	b=RLGul/ScqnpF2Ap5mzsVDYJnIp0PRSfYw4njDhitZ/wUdFrGfycuZ66tL3r+VdCMt8JqoQ
	sJnJSVRkXt5OlaJU9UdC9pTvsIpNNUsmxoL3Zae0zeaILPOSuAC7NIDzZIW9e+UimzEwK8
	w3XyDGtr1UIAcEX2k7QPkAlR1xamLy8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763861019; a=rsa-sha256;
	cv=none;
	b=uxVL0F4pS14Z2MJJ/eRjwWeNeHJHSlcE8ZIla2AJA86hipJvrTwvAKmPhEJLpreKR6uUpw
	gjFm7KLmbjKD8zVuWf7vxKGhyRpEm2JHETWxSVuwLJcDaptl1BjyDeszp5RvnYMSIgr4UZ
	Sg2fQj7UfH3b0Hi+QTgMkEtMlF1/Vzw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gyHzibOu;
	spf=pass (imf27.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763861014; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=VCIF5DLiQMx6oN9DUx9P7XFgjwtiupQtB75jei15lO8=;
	b=gyHzibOug5awWD6Ncq7JwAeH0/B/x+lGycfM+pF64R5vBKQ29kMQS2U1ghvp4hI87KJArtyfGONo9SAK35QVl0YRF14zsFWrSZ35m5zxkZkgHraJNYlQnz/xpltnqMNutlRla0dz2iKBH9iY2Z4kddrANT2mXK6RJKa7MwnWrzE=
Received: from 30.170.82.147(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wt66DMu_1763861012 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 23 Nov 2025 09:23:33 +0800
Message-ID: <d3c01e18-c556-4892-8283-08765c5e6cb9@linux.alibaba.com>
Date: Sun, 23 Nov 2025 09:23:31 +0800
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
 <2c6906d1-132e-401f-830f-ae771fe836c5@linux.alibaba.com>
 <nx6o4gwpetxjeyfbu4xyibulvldr3xz6lyfjrar62cidy5gxum@xmx4ojyq3mbf>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <nx6o4gwpetxjeyfbu4xyibulvldr3xz6lyfjrar62cidy5gxum@xmx4ojyq3mbf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 035334000A
X-Stat-Signature: jtcw4darma3p1gyju6njym8c1otmu9oq
X-HE-Tag: 1763861017-273602
X-HE-Meta: U2FsdGVkX18MGDAtySuFUdzYy0Z3djEzNEeJUbUXFd+JrS18W1E2s9a0+4m9UOuSjAEeJ0etIdtg9mqyRQD6q+M5Idgz0C9QRtLaWvwFUoDY7kZ17UxmJEFO1TaqwnhFatvKWRGsJ+1jmz2aNtR39HLFgku+fLMnXl/tDnDhqfhMWNbCzXqsA27OeIANd5G23ftLxs+iXaVNDhAlwNjnHtexMTkcjFlmeP56rHLqShyARdO6oUhy8bDufdFVzaRXzPThdngr5e1mwmUmGsLCnaYQJI+CB91DfeJDIDGOzNE/sN1Tx5dGxOVEOWoP6301uqJefy1DsQevJjoAd8YgGJwMJvCsRplUs5ZLrtHo0CphcGpwnt9xabpjO9XDh7z64sn+Vt/ZHaAKsfczBcLDsXpU6lXPALseeczV5hlznuiiovg/YkWu4yz8keBeKzM0otuOS5lgmxwZPAQYCiMM/faiEBPxE1m2U6uXPGCAPilBvIa6vyIOwH89sNxL9cM3Q3jD9Xfb3sn2FJd5KpmP8SzO1+9XhvGOrc+I2OEhUwsBz5DKAb9OvKLsg2edrdBbO0ShcqRMBKELb0wthS41NFW+q+cxzMQOda8hc/2B1MQTFFRSrpGENEhgb7nqORiZbzB4Mb0uHnDRe0c9uOOMAG9PwZRe+VwQAXvFH29RieDg0ESURsPSdhE35nnko4ykoqEG4rJR1qO9UPRA3qpmc69IzKC7vZ0w24AZWto1CIef6U4v0PI2r9Up1S8Hf/MMdSoXHwFVWlVFUYF1gubee9gS5jdz33wF418HQJLqfRidEqWRSqBQmHpXnm1ZyHf5Zv/ohHlvAi2BaPy9vmdve/n0V8NokPeyQbrK5IEKwgUOjZL1wtchT/z6kFdaaBU2JyXxhNu9YXEKQLB52Besy8xpDeUMai68Vn05JQzGHHYjSMeJJzrbSMQiuxV4W+rLg7J7zVPSi1vOO+u0Cim
 v3sJ3zke
 0GpMwfjOtnRmCKxpxUHHzldr/HuK16QW0ZNMDfOpxuC1SDNgrYHGGubpXluVgT5VCglr4rJCEuONIPVYMenbU6W2hwWWW6QSmbTXBq200U7xhucoH91MkuyhXuoMVgwk9n1p9e1ZR/I5K4snnSVMuNBzNSt4gx6AedruCQoXLT9wWQTKHnO6mcXebkKd1vHZzdkUYcWBH0PKpPIE9o9jY8hd0JR3oQuv1U/JA25kpen1TdwHiRBXzZO5+eNGfzwhiHdC4NNInN4yrw/iEe76b/qJSmi9XCBXbcq2FdRkEr72rqTQrGcgDjxSVw2NsuHcfA1cArZJAlEEmNKkVe00HgbjgWKROndAy/GAM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/23 08:08, Sergey Senozhatsky wrote:
> On (25/11/22 22:09), Gao Xiang wrote:
>>> I thought you were talking about the backing device being
>>> ext4/btrfs.  Sorry, I don't have enough context/knowledge
>>> to understand what you're getting at.  zram has been doing
>>> writeback for ages, I really don't know what you mean by
>>> "to act like this".
>>
>> I mean, if zram is formatted as ext4, and then mount it;
>> and then there is a backing file which is also in another
>> ext4, you'd need a workqueue to do writeback I/Os (or needs
>> a loop device to transit), was that the original question
>> raised by Yuwen?
> 
> We take pages of data from zram0 and write them straight to
> the backing device.  Those writes don't go through vfs/fs so
> fs on the backing device will simply be corrupted, as far as
> I can tell.  This is not intendant use case for zram writeback.

I'm pretty sure you don't understand what I meant.

I won't reply this anymore, good luck.

Thanks,
Gao Xiang

