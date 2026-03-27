Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCCF910BA431
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 590BB6B009E; Fri, 27 Mar 2026 02:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F2D26B00A9; Fri, 27 Mar 2026 02:45:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7906B00AB; Fri, 27 Mar 2026 02:45:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1D1DB6B009E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:45:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DBE448D79C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:45:23 +0000 (UTC)
X-FDA: 84590906526.20.ACD4373
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf02.hostedemail.com (Postfix) with ESMTP id 90B1F80004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:45:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SgpKrIcu;
	spf=pass (imf02.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774593921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O0bPPvK7Mw1LToaM78FrGCA/5WXVTaQ0nyJTHS3nh8U=;
	b=QWgIVwEFbY8+yQWG+AZ/+RiDL9PjSeg6J4/diRSkfhBgADFmVZH6n6uw51/VmJoGPbzF93
	lPL8oew/g7W5Jw8ovJodXT3WI+YHZnW5BD3SXGwrRgk1AD+r/LSevDQBzV0JIt7JzJVh/a
	P+ayM64x4FYAKzmYTXUdZdO5v/mKH1o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SgpKrIcu;
	spf=pass (imf02.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774593921; a=rsa-sha256;
	cv=none;
	b=YyGE911K/+6kHmfm6zp39cUDaFefRhgxQwt2CgZcyNNJY5s5LiFnkA7NJWho6XViModqIT
	j8q5wO9r2be+22NplXv+o3X4yfetYh2WYMoDaT0P4ByoQvlx2y9ubQOOHPdHtUcd+dLfPH
	HArxoQQK2ij4OEW32p3tDvxrrZ065nU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774593915; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=O0bPPvK7Mw1LToaM78FrGCA/5WXVTaQ0nyJTHS3nh8U=;
	b=SgpKrIcu8Jv5Rsw5BCm59eScdbUy4KxSSEIR10GfOoi4i7XZeEWkB/ZhF5z5SVYsSh36yJhpcRiVNrAEIVPsymsAumZRJK2WhvJDqx+IALTTSSaan8OLZ6SmCNceAEah735tIFPGCgPbbxXHfopCKA3CGSbA7UQF2pdMfKF+sZk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X.nKRnf_1774593912;
Received: from 30.221.131.128(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.nKRnf_1774593912 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Mar 2026 14:45:13 +0800
Message-ID: <9e83a4b5-ac4f-46d1-9510-a24e7ef54b87@linux.alibaba.com>
Date: Fri, 27 Mar 2026 14:45:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 2/3] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dgc@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
 Jens Axboe <axboe@kernel.dk>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
 <acRG5f9QjdEKg2JB@dread> <acYe1oCInkDLWGGu@infradead.org>
 <9e8061a5-980e-4e6a-a349-8a89f9eb1ba6@linux.alibaba.com>
 <acYjSMkz9MdWQKoJ@infradead.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <acYjSMkz9MdWQKoJ@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 90B1F80004
X-Stat-Signature: t8dkaxrzdsepgb6rcrf77ihcyktxgoou
X-Rspam-User: 
X-HE-Tag: 1774593919-28254
X-HE-Meta: U2FsdGVkX1/gw1QwjDSKVSugcu8166bAm7s01pBfNmXyfxhLHayv4befUdK9BF+nl6QfRmxKnzUZcA+iUb7/PwX9HGqRGPU4BClTYu+5NLH8dgv6SpxctlIEgBC1bCPaYu9c45lDSFX3GBxZHwBtLeSoERdfuVAdLIDdHXrhR9XuIF/yxoru5CR4RIfCSmaqEJAdImAVeiRDogLyMlY67GvA/0XtUotCORxim2dyroesrHA5gRDGWeqYFnSmSBZ/xtt5J4fTPlZCwrbGxGMiew6p8n4qErxF5fI4uKZVZIE0poVKzcaZZeXO5m7XNnM8TTGaMgXNb67itEwgHdpyuzHkS6g7Fuwzje1cgErdZwRrdrtQJKLw3TX5abUCnqG4skzXuaH2Y21qUauEWnk2eNkqk+/cw432l5C8QBNiVUA7Qr7RqjRL1d6XMna5RypzRcI4KT8bn8istx76T0y1426KWfDbA2QUgI4qFKBz/dBRy92PP+inNlvix9JpcEfAIEceLBQWYtHO6IUE5pQnCRRXyFfQkFvMslYjhk+DLaScTR2L0SGHaP324AjYINR8gYZCnG7TjZGJmIY2fmX7nsJ3BhgcJIb1pITOE7Bltup531OJr9kp2L13SZ0P6NtIK9MHSqUkPeDOSxr2J34cCssmtFYUVh6Vkp7K7ijvxx5nechx/d/n8uMEe9DmxGzVlYwa9kVCClimLg/BUZip1kG7UaWS8JGSZgpFBx7krgw5fqBlmNYa5CXiqFK5F3/GBNai4oz1AWzroeoiaQIoAsYUHpwxX3qdiGfvUIbWmgzSgM9JdUqfT61M5ghZQ2xAsFZN85P/XSgUunQ52MsWcoa40Jl4yyEGVreqfRqoRdusHVWsh77jW50GfmhiblxhPeO6vUH9AskTHg05xY6+ZEGvxCYAunUSfQ8dXL1csFSdUiRqBpJ+mCTWkJAobtB527hROvojPxaNcmqYwmr
 2RCz/Lix
 Z1ig2EP6aP3Genikkbrg+nQctIHBDxwsXiHTr82LT0dI9F6wkiubtLzaEz1C+qwVMsG9Ffu27d465SjEfDdwzdl4hESqbJl37UhBpl4T/Az1/aYbaEDeeKKFVTeG26eooOe6guSdIn0H2ZkoaEONJ7FBB00qIsn5MMxOMzJe3osBtLnr+vFmngAzZEFAM4Pi+Yh9C5e9wfKhDrNknDS4JOgbzzIxoCTgcu25CQHYpY1Ab8mH/oC7npbA5crcmVTUVMdPt4EKgMQ4BPWMcB0erXY52xNwW03h5p2T0YEwly9noTK5UHCCFUw+e2XBGfqib4NP2Fe5BVOIP/AipA5Lo8qG5KY58gneI/tOLoZTr62kLMpY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/27 14:27, Christoph Hellwig wrote:
> On Fri, Mar 27, 2026 at 02:24:02PM +0800, Gao Xiang wrote:
>>   - use EROFS directly, in that case, we still need process
>>     contexts to decompress, but due to Android latency
>>     requirements, they really need per-cpu RT threads instead,
>>     otherwise it will cause serious regression too; but I'm not
>>     sure that case can be replaced by this work since workqueues
>>     don't support RT threads and I guess generic block layer
>>     won't be bothered with that too.
> 
> All of the I/O completions should be latency sensitive.  So I think it
> would be great if you could help out here with the requirements and
> implementation.

Yes, especially for sync read completion. Our requirement can
be outlined as:

   - a mark to make the whole bio completion in task, so that
     we ensure that the bio completion is in the task context
     so that we don't need to worry about that;

   - another per-CPU RT thread flag (or similiar) relates to
     a bio or some other things, so that bio completion can be
     handled by per-cpu RT threads instead of workqueues
     instead.

If they meet, I think that would be very helpful to clean
up our internal codebase at least.

Thanks,
Gao Xiang

