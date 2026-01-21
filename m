Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F11BEC44506
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 20:39:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 350AF6B0005; Wed, 21 Jan 2026 15:39:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DE9C6B0089; Wed, 21 Jan 2026 15:39:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20B366B008A; Wed, 21 Jan 2026 15:39:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 10E736B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 15:39:27 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9783F13C3A8
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 20:39:26 +0000 (UTC)
X-FDA: 84357136332.22.B99AFB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D006D1A000D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 20:39:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1+fDaFjV;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769027965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e/B6QJI/nvZSgehlUwoRng4xy4SyPfvFUKU5kDYJ2PU=;
	b=8EcQY5YGEmYTiFtLoUQwtJ26338W3j1dJY8cT71MCXry4R3z8AhHU7wiDHtUMbhWx9eC00
	hp8Qh/b2NRkkfiqSk8irmJmImexFfOwpLNWJ0xRK3FxEeqYRlTetS9OZbgqhFWI5GwQv2P
	Jc0OiGZPWNP8b8v/4X7zDykSfEfy5zQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1+fDaFjV;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769027965; a=rsa-sha256;
	cv=none;
	b=hE9uZpUrCuvFPH0rZJSV0/hQkw6IZMhYLHl9lgs5oIAGyB27TwYcSz/j+paAJjsVa0apLB
	iOb2KPQlwMcIMJIG8HIQ7gyzzjw6fyBA0Z2/TrDIhe7FhvwS0+92cEt0PZHIfBeg54X/8L
	JBZJM4zOjT/y8CA1btaE4P3jNgpcqcg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A1772433BF;
	Wed, 21 Jan 2026 20:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C86DC16AAE;
	Wed, 21 Jan 2026 20:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769027963;
	bh=xOpMNsFQylVOsBcRH+cu2isRcoydT0zQtcqEonA+bic=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=1+fDaFjVmCDf8Us6F7ZtT9ywVlq3AXV0+LbTQeRi1xe8kg0UeUHPjCFJuYtEOVSQe
	 HZqjoQ+1tfkNQwheSesWJs99D4SGDDkJX+hI27trVBTT31w8FQEzYEkhmx4LyWguZB
	 KnCoOgxZFHLRXhe+FezYcfI3a9HBm29nZR8KHX7s=
Date: Wed, 21 Jan 2026 12:39:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: oe-kbuild@lists.linux.dev, Pasha Tatashin <pasha.tatashin@soleen.com>,
 lkp@intel.com, oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Linux Memory Management List <linux-mm@kvack.org>, Jason Gunthorpe
 <jgg@nvidia.com>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: Re: kernel/liveupdate/kexec_handover.c:994 kho_preserve_vmalloc()
 warn: missing error code 'err'
Message-Id: <20260121123922.c0bb0ef8505c70b99998c324@linux-foundation.org>
In-Reply-To: <202601211636.IRaejjdw-lkp@intel.com>
References: <202601211636.IRaejjdw-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 67cjatxgwa3pwuwpp7k9efam8qi9rqin
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D006D1A000D
X-HE-Tag: 1769027964-91085
X-HE-Meta: U2FsdGVkX1/W+LGIiBAkYooGrb94Aw8sd6h6WYVBAzM6SPTZVU0jz3drEI9n4qfF1bT5DGvfsQNk+Z9P3PpsKhynPEsDWmWtF0cqaTrXC0OA3TBs6Ir9xoKs0/Ld8rSfbdtqfUWGRW9HkuWm5dHMLiI9RrBwOvIgQgtOxYznBXnyrHu1CqSwrBaaJ04HY0p9sdeErh7eGjMxKv7ozLhc9CHXCLm9mJwALDaLI4keD0aDd19NE31/mHMQC8lpOtv6sJsdC1DUrTJfzQOF+mBksQ6FwsOX4C0ICCii84dsbqKWuJMoKZPQdEvpUfx2sS8fGV0ytVKJy3DuPBUCA+CKPRKsLzZaDNRn8+ZiUq9bZW7vxH1sS61aJ43fxQ3qNP4iVNxAEVsy0T+tRqL8BM3IRTvFldTSpdSIK+JIlH436P7qxbBu5B5JU6lQ2cjcqiksKZCZQ4G9AMfh7kycRPAjpMwvvAUIB5xClO8pcF+GrWvlxVPw0F0ERTdq0UeGkdIDDtl9E6nLK8HJREA5a1Fa4u2a79v6sYbCGJcUdEHZ2BYrF9fVNr8IRX03JdQyrnPcN9DvHyNvIPpXpMQsqzhQq2S9z//bEZ5okyHnTEH790TZ8nI0EWglw8E/f90TDD2ofJZXF23iLkH0jrqD72YYCUOWMCCJV9AKLb17FgE+BvIW81m6cmnDIuz/F5IPFAFAOuKxm2iBUHYTym2uMELJHNDHQ43z5rT1+hstQGgw8QtzlSktJmIOVVjeOY02Ox6GuYTbcBEHOVJsleomiD6Q81yMkDM7w9OnUaOF9G3exp8ndzrVEg0hyhmYfkM6Bljp6VlGqT/Vnw1gi96mDjDliud5OwMeNuiK7E76A1Z8gM8jgPcZpQuPz89LsQNJ2wRcr/A2tsQmyHN5x0YlArrIS5e8lfXgbXE9gMydKh7VasL1FbZe5ofjtvET3R3kNoY5Y3NZzgk4Jqt1UkXl4MA
 7YiatFr3
 Smku9R7eEgxxVEAI/T0NQuzF+Oy3Ggfac9JU1Uwg1uQxbsNFZGr/XtW/DuFp2+uxiyZ7Xee+612Jdj82TjZFeZ99RwoirpWfeq4IDdDpGD8jxjA07zltuOO8iqrtPP/Q2/atsJuZzQ3Yjvq16TYbzXdHbkLjRkKLmkZQG40kka2zEcBA6q/iOvwFQgg9ZlXBbazQMgUrS47U4oOKRi5qPICpYmmPTlWgisJb9orlCQ6IoF3eZjE9KNBkWYzWDHjX7j2/yhtm92cbO80A2kT95rbMyhOSoJdZVnC7fb6PjJJmx/RJJcunm8tGVAWHux4rWMP/UymF02nrJYMEiogA5eB8jTRFwAdeXcTPWo2C3DXPP/CvIV8hXZ076uRQBd7Iid3zTHl0U6SKJ93IBYdjWqpwHKIqC3GXlGSDnS5yFiRIBd4PVkNehNv2m3rqWf8pVM5gmfnsERU0p/c4qLwU1lhuCuTnJuVi4I+YRxR+uhF9MW/3Dr1NmXG4KQRFLyJZx+xqxGeTHWeL7rzU5zYtO1+WhIYxXRfitN1LBZrOwE9Th6n0VQO6lSh5v4/hBIg6sbIWhv12Jhk7JDJKCk4z4cGRrOXK7EQ7wWaRFcCpnLrZyGYsAndKEnEGKYayrS1dzHFKSj3XqrlfAff0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 21 Jan 2026 11:58:20 +0300 Dan Carpenter <dan.carpenter@linaro.org> wrote:

> Hi Pasha,
> 
> First bad commit (maybe != root cause):
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   6c790212c588fddeb0d852f2790840753bb604b1
> commit: 48a1b2321d763b5edeaf20bd4576d8c4b5df772b liveupdate: kho: move to kernel/liveupdate
> config: x86_64-randconfig-r071-20260121 (https://download.01.org/0day-ci/archive/20260121/202601211636.IRaejjdw-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
> smatch version: v0.5.0-8985-g2614ff1a
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: https://lore.kernel.org/r/202601211636.IRaejjdw-lkp@intel.com/
> 
> smatch warnings:
> kernel/liveupdate/kexec_handover.c:994 kho_preserve_vmalloc() warn: missing error code 'err'

Indeed, thanks.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: kho: kho_preserve_vmalloc(): don't return 0 when ENOMEM
Date: Wed Jan 21 12:36:17 PM PST 2026

kho_preserve_vmalloc() should return -ENOMEM when new_vmalloc_chunk()
fails.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202601211636.IRaejjdw-lkp@intel.com/
Cc: Alexander Graf <graf@amazon.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover.c~a
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1011,8 +1011,10 @@ int kho_preserve_vmalloc(void *ptr, stru
 		chunk->phys[idx++] = phys;
 		if (idx == ARRAY_SIZE(chunk->phys)) {
 			chunk = new_vmalloc_chunk(chunk);
-			if (!chunk)
+			if (!chunk) {
+				err = -ENOMEM;
 				goto err_free;
+			}
 			idx = 0;
 		}
 	}
_


