Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51C7DCFD315
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 01:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69C9A6B00AE; Sat, 22 Nov 2025 20:39:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64D986B00AF; Sat, 22 Nov 2025 20:39:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5636E6B00B0; Sat, 22 Nov 2025 20:39:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 409D66B00AE
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 20:39:31 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD26D5BF4D
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 01:39:30 +0000 (UTC)
X-FDA: 84140164500.11.6C23828
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf21.hostedemail.com (Postfix) with ESMTP id F27A51C0007
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 01:39:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EyykmT1g;
	spf=pass (imf21.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763861969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R0FaNTVmYaM0SpQ82sulzhFW6ARj1Mibc6jdHQb9PbE=;
	b=LKjE5bOKWeCM425Bgpjh8YxmWALSZ8Gwhw+PMPxCTqUUkEcLWA+3qU2m8EOLcwk0n7qJ7T
	f0VsGFiPS3Nk8UvNtgbbVMfoOiaRRfs/1bQGlVMxyoswV3lO8OAlTBvnrFb0HJiKJBtIpx
	cX59Li0Zs9rslQlwI2cZt9MVnboka6g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EyykmT1g;
	spf=pass (imf21.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763861969; a=rsa-sha256;
	cv=none;
	b=WHv2k9Wu5iLsOqqq0HxXR5GvyiUdo5ljy5gXac2IrnquHhoaa9e1xxnrS4WXwPlUU59ccf
	c8uwdLqZEm8Tnnce+miXbEBsTAeXXoiaO5xfW7FAt8FGbkAjATvPlhAPiclaAGmC8VO0jQ
	qzOV6HaiUYji+vPIY7q0TT32gzli7ZQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763861964; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=R0FaNTVmYaM0SpQ82sulzhFW6ARj1Mibc6jdHQb9PbE=;
	b=EyykmT1g9pR1NDRr+Co5D2ubkwkkNNFLEAJceQE3N9YCG2rR4D2Fw0zwhmTb/v437jCWP0CK7nKye1hDSeKedxZTwdU/DYw32QN+EOEqySK4XrztLjpOK6ZvOoNdtH5t/w87/k/R6cW2r72K/+UhOQ2LWOEYy2P+Iu90Kljujis=
Received: from 30.170.82.147(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wt66ic3_1763861962 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 23 Nov 2025 09:39:23 +0800
Message-ID: <45155eea-2fde-4a72-8ea1-353bc4e14a7e@linux.alibaba.com>
Date: Sun, 23 Nov 2025 09:39:21 +0800
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
 <d652n6zrqbkt4oltusd5egbnrvd5xz3k4kbmqnfuwuatdyuekn@22jscte4mx7m>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <d652n6zrqbkt4oltusd5egbnrvd5xz3k4kbmqnfuwuatdyuekn@22jscte4mx7m>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F27A51C0007
X-Stat-Signature: 3scum68mikr33xysjb931neaoyxswoms
X-Rspam-User: 
X-HE-Tag: 1763861967-431509
X-HE-Meta: U2FsdGVkX1+ssC8d/M0Wo0b14w9zikWpESIqqPfAzfK2NkgE+vs7JFVIyZeYmBsIsHUSmauC6H3o7NVf7s6rgijFR6G3n9bU4Dy4ACC7H0imAWNDP8xl18n/mqQsYa1ZjwzJ11sfK1W4oUt/Hz2IrCa9+hHkjlFsYFVwu6whI/E9LAc0HFTi7xy5sND7ZdocnPysAl0591dq5bwKOD6XCGH61zfTTPUGOeP6h2yiFDJdAFXrO//OU2fYZXj6H2t+p224O78Rjmi4gklrnFlTDnH5asXW6ijx8JU8kwrRm9MhpizKeo70Qd5GbLFhfI+FkmcnULEFNAnMTxvnN5o6j5DRoSSM138s03hbFUJbwzcKxJVqlffW27v20tZPgNx8g4e9gd5fPQlobPSTRcQ3eNuegMamD3GW2xyh0MTiFpPA+hMBsRHme1La4AMcq8CvPluoCQIQZ25ZYOyWgB3qPK1YXTGJx5geJH0DuOjWfjDsxqE2b3XFJ/dWpDYb4ckvndFHqYZS0qphmw2G6MTFXVWulzqKeV182dKuyDlj2ZS94shF/6ajuOrh2K4uSgiivo0pYagwaMBmo6agQUMUCGvmZ2y3X1kKrAX/5I4ALIh2I9iKEfaX6kuLNJdHrhE0MvC0nU28VpFwmrrBQ7r9HdtcxYAKRwrEyPrplAhFkx/W2156XPToSGbwwXcadz3SfFSIuSMBT4W1sorr92n9tEPNN4bcMjmKcYAipQwwCyaR4xJ39PnZeUz6FXPUKA9aPJpq2uc3xi4YBLW8VaDeHn1wTOa6qWJgsDmMm5xSGGrmS+x7n8KyVN/wIVfdc1nJ9WoU4OZlIT2fdiUgltmbMB2hRbz8ZCtrFzamr8nBsK81IcRhA/JxnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/23 08:22, Sergey Senozhatsky wrote:
> On (25/11/22 20:24), Gao Xiang wrote:
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
> If you want to move data between two filesystems, then just
> mount both devices and cp/mv data between them.  zram is not
> going to do that for you, zram writeback is for different
> purpose.

No, I know what zram writeback is and I was definitely not
saying using zram writeback device to mount something (if
you have interest, just check out my first reply, it's
already clear.  Also you can know why loop devices need a
workqueue or a kthread since pre-v2.6 in the first place
just because of the same reason).  I want to stop here
because it's none of my business.

Thanks,
Gao Xiang


