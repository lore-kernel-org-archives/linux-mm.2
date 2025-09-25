Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8456BCAC5B1
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 15:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFD5E8E000D; Thu, 25 Sep 2025 11:57:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAE398E0003; Thu, 25 Sep 2025 11:57:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9C168E000D; Thu, 25 Sep 2025 11:57:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6E0A8E0003
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:57:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5500B1401AA
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:57:26 +0000 (UTC)
X-FDA: 83928227292.19.D535785
Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7B229C0004
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:57:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=3lNIDf7v;
	spf=pass (imf28.hostedemail.com: domain of bvanassche@acm.org designates 199.89.3.7 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758815844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oMhd05x9x0tqhBXT4WmE2ln8stlPQG2l6//8/VqTYig=;
	b=OafBpQQ/uilULZrQFic6F5MDQSn9/sFZV0dgDILO8CsaxS4JitYowvpNd1jqgxCiTO6Trb
	BVyOSUo6rQ1fB4v98hKq7eeWUR2GyCitF9kIXOuxCbx0NhmNynkYW31uzrtwzr2d/pPitg
	O8dqoMS1iRZFO3Ng1Eu/sQvgofubenM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758815844; a=rsa-sha256;
	cv=none;
	b=OEE8guxa4ssD4qwVSvvNfMGoGexhEN/vXhvw68ouBHGXALcPu+gYuRQSYlGdLS9RasenQS
	0YoD+tYwLJl+1ejtbFP5JRfSYQum7/UJ3AphfzCvN3onacH4jglWPYv8HXgAd4Ovr9eCa5
	Pn183A4ParhHlWhLlKbzJdylHa/jVks=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=3lNIDf7v;
	spf=pass (imf28.hostedemail.com: domain of bvanassche@acm.org designates 199.89.3.7 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cXddb4QcFzm10fx;
	Thu, 25 Sep 2025 15:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758815840; x=1761407841; bh=oMhd05x9x0tqhBXT4WmE2ln8
	stlPQG2l6//8/VqTYig=; b=3lNIDf7vxDukhEwY745QPQncxYUtWSWnx+YuCZJ2
	ioFsjKFelGmM3GkA6ZhXCsAJcUUU5DQKDFk5xOWhn5D2InHRKynPstX/OYS1ZHub
	AEQNc62ighYT5fmrDOArIiH6OMyISaXCcTSkazZW45+9C/cVPGE3fVJwUJ+uAaxE
	8cyWBxCCOFI3l8AbiQ8tNuxNESIrOF5/pcmyL/26HPJvM9CXP4hsxeNr9E7KGbVs
	JdVTtuyQCALcAevFo/LDtbpVcHlzvJseGr67fUOCDRchDmwiknYCuTvcjN1/0rKj
	+c7UfBHWk9N+9dJEIIc2PmitHNFqQ4uYLHZDuwgFPnz/8A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XGOV8JsgHmdF; Thu, 25 Sep 2025 15:57:20 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cXddF1vjbzm0pKm;
	Thu, 25 Sep 2025 15:57:04 +0000 (UTC)
Message-ID: <bc6fe04d-3245-40dd-aa30-c3a3acb670c2@acm.org>
Date: Thu, 25 Sep 2025 08:57:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] blk-cgroup: use cgroup lock and rcu to protect
 iterating blkcg blkgs
To: Yu Kuai <yukuai1@huaweicloud.com>, tj@kernel.org, ming.lei@redhat.com,
 nilay@linux.ibm.com, hch@lst.de, josef@toxicpanda.com, axboe@kernel.dk,
 akpm@linux-foundation.org, vgoyal@redhat.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, yukuai3@huawei.com,
 yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
References: <20250925081525.700639-1-yukuai1@huaweicloud.com>
 <20250925081525.700639-2-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250925081525.700639-2-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: f6maw5nfyxr7ke58ucwzuya8ikpxn8t6
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B229C0004
X-Rspamd-Server: rspam10
X-HE-Tag: 1758815844-770373
X-HE-Meta: U2FsdGVkX1+b7A3baVrJAMX/coRpc6frSmC+JR9BlZPSf6d7X9Y1XMnjqWwL5WWqrC7p55Yz3lcZBujeF1ppxTcoxXYeVnsoOK7L0JBW3r2uUHAvFdPEMtKIvei2ev7XuexnIyLKILfxMatsgDA1hYpyp8vnEHrGSyGD7X0EOFawW4LXDPYrqpk6BYrOENHNk0xo+7WkB9OcIF5nsZEsCVpcgDvhXx4VFbSz8ZNZsPUvUqao9xGuOEprb60M+3UcUZBZa0ouuHL9LKyXxcM0PTYgKmwz85Y7Wk17ii9h4R50IvAz2ToG1riyeRRV1VCSU1QHU92Bk/T6axLZpB315NEhTc1u/fZDt3QV6Z7TzO4XCCwZxpiUoxpvXeb4XVEKy47VnV/BjYjGH42oEZzhVA19PEzoo4pYm3U2IS+zgW1YHpqvySBJqNBci/GvCD3ZHf1HpTk+yn0j0/gc/vVNDLe04Lz7PBd3U8eCWyzLaGDOCLJM1D2MmsZ99XywHUOoQ4+mD79xR5awapJHYYrZsnZGC5HipWdV50RaWWBqrSv5QqxSrMp/lDlNU8RwoDebXqGMzYZFyzraUrTf41myGflyBChRMXgsBc620OQyxB5WwxhfANjVXa2pZ8IJqtXYzWY9OvIwKhQu6bwm5UYVSIvOqvFnl9LobKcxQeV2oPepb7YZ4DbrBXXyzbxURcFpvhG2ssEp4hLAiPUZdUv3wEO4jfZQHGHT42klsDCG5aZoejK3hfFfJ42dcNwSBJiMYAy10a5A1nB9vvbQFaeLzY+mgQQeIw067BjupFA/YAzm5I68QVPQjaO7wOMj7Rompk8h4ClZQSo9nCgp5rsi4r48j/W+FDsphOSZ7WBMPg2QTZz0durSzuN4lozEVGIQ0yrdG2fPBuLJju4xsHgIbX5LXGzhN3PRLwQwucUewGUbcjS2WMlClSKFl3Eg/EmyZYleJzogTASkTVa4Jni
 ad1qvZ7B
 aVZfwRrAC6z4iVpuUGCdxZ0RqSl0vAxrCxpOrnbwI8x7gvzCIDBtiWB9LO77xsCoLE5hHLDxlfgN8Xf3gtpb11xINsmDVWqazcTSjWn0GZ1dY/WUs7gLzp4dnZfuO0WIDsXeOP8dADbZDq+ZX23jc74TaqTjdm+lDBfFDflqk+rg6J+zTtXql4sCUAUER4uR1wx5I5CZ2b8DeFWJ/wjAw4eZwoXgDCKaJH4SckwdIffXFv2kfA3vz5wcfWGrq5SHHUMzihlxM1x7Py3hcU20nv74H/p+OtSOJIIPY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/25 1:15 AM, Yu Kuai wrote:
> It's safe to iterate blkgs with cgroup lock or rcu lock held, prevent
> nested queue_lock under rcu lock, and prepare to convert protecting
> blkcg with blkcg_mutex instead of queuelock.

Iterating blkgs without holding q->queue_lock is safe but accessing the
blkg members without holding that lock is not safe since q->queue_lock
is acquired by all code that modifies blkg members. Should perhaps a new
spinlock be introduced to serialize blkg modifications?

Thanks,

Bart.

