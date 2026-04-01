Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C3B610F930B
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 00:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFB6D6B0092; Tue, 31 Mar 2026 20:33:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD2E16B0095; Tue, 31 Mar 2026 20:33:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D10226B0096; Tue, 31 Mar 2026 20:33:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BCD5F6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:33:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6D598C4771
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:33:17 +0000 (UTC)
X-FDA: 84608112834.25.DF4ABBE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id C05A180004
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:33:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jt10dAED;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775003595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vmkN/FV2GymdCNncH+1/1GVQDceineeQA9+Fh0RF4HY=;
	b=DrJ8B/bt0UPZXthiwcCC6gKEjnYzqB4ytV6IzQeXfmQFUcpYmAoLkGwuS1xecZL+8WjM6r
	3+hQaEUI3H6dzkQjU8Xbp9MLucTzfX2ryoL5WQWdbV6IQaUe96sBMxdI2w1XD7owGEXjBt
	iXA2AEITTvJFWivGg2TnYdRaE/YZYrU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775003595; a=rsa-sha256;
	cv=none;
	b=DQIvPQ5vsBNLbPb9w61H48v5Phs3kPLNjLn4prmbJBPcCvIpPIR+CRfyujijuU1t3SgZpX
	HVL1SbqYhSPYuO4PMN2tKxlwGMA4FDmtHBFiBbbqT4Ihv+GGu8OOmwZ3sedS0eMo/RVi0y
	cu1FlAG5SkkUYHZazG/FcMz/Eb4Qijk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jt10dAED;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 28D89600C4;
	Wed,  1 Apr 2026 00:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4404DC2BCB0;
	Wed,  1 Apr 2026 00:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775003594;
	bh=AMNHzr+Jyby6lTUGZfzcMMmbkmLsEe2WHEinPPa1UKc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jt10dAED0bQQ5EIamY+UEw6FzXCGWjvBO9umoXF9o2B+7CWycKJMuxpXug83U91od
	 cGyNZsirNhCQs0zDqIoVxR+hxvlxykmKQ8BpN5oL2iRXYHzpH4GpVqmT57nCP50519
	 t0TErZ4h9KlJfy4AQNtaeGYMTmbON46735xI6UdE=
Date: Tue, 31 Mar 2026 17:33:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, zenghui.yu@linux.dev, Liam.Howlett@oracle.com,
 david@kernel.org, jgg@ziepe.ca, leon@kernel.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
 rppt@kernel.org, surenb@google.com, vbabka@kernel.org,
 dri-devel@lists.freedesktop.org, balbirs@nvidia.com
Subject: Re: [PATCH 0/3] Minor hmm_test fixes and cleanups
Message-Id: <20260331173313.a471934b6d6b76e64ab9fa2f@linux-foundation.org>
In-Reply-To: <20260331063445.3551404-1-apopple@nvidia.com>
References: <20260331063445.3551404-1-apopple@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C05A180004
X-Stat-Signature: bcsxhxr183ey3e4wnwmd3gwpnsfx8fyy
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775003595-78534
X-HE-Meta: U2FsdGVkX18cY2SNwk4wKDRThJa930QJHOr+mrfpX/xYRwDIXDClJIo47Gavv7XdLufO3Q/AfNRRr9Sc8sPAq06wHJVkQ6j5QMBKSGwZDqLwltJDziOYsvDkKh3qjH1hEuGIkUyBAeRvmRzkziOjxzol6oICQxvGAZ7FVFjXeXGokGFSToVqWTDik0vxU+1qnMtjU2lzUfPfGpUEdQ5H2wT60I6al5mt/3HawTpVySbd0EoYA3/+6hjt01wI2NgDL/0fcjzZduKlLLj2GMQO49VGebSK0xVRsGourLPR3ofKuFxsOpwuMY5sgeFwa3P9wIRkcdG0XJbMwbix4Qzm47WNe6xvU4U/jF4ZbGxGFpqHwZ6NmxiceAh/l4NLTbXNrLHwRAt5Tn6+oh1khWJwU64iou4kxPyGSwpdw1LMG+zhmCcFg6LqQoN3lPZxhb+1IX79ltcBd8Rz+F997WCS7zYGw6KerSXySmkeT0iRvuXYPwcVcN9CyoyrXUbA8imXEkC0tsCN4m9aERmIpuA4DlilUh3JhFe9y41EUg5QsRpRFtSXTp3G80iUuCCwVJScSVgkyzMZWTfCz1hL362aalYqQVqjiYhTwUvoA9dmgj88kbMknmE9YVVSehC40la59ayez+RNbBdkgZ2h99J6lGqbBSt8cuSHT32wfEApJir4r9syqACVx4Q7kXveUYYdZqvtY7t24uL5VC2zeZ9l8IcgUCulSmzipoXb/I9mqVSqnNBpVXLtM4SW3Gz3y8EsWnrJwCnXVKPARwZVC75FOEdepGisuPyUEsPcLGtfrtedVyM0lsx8OoaaE+21eWBfA85sFZOO547/V1PlchiAuK4/yvXnbvNT0eLjxKtE1Lu8K5hJqRMQjr3MgyR+N6gVr1RW5tfYn23V/N2Lmx0SJhtMqhPVGd7Q3opKs5mXaHBrkp9FcgdsI5K8vqLiu9ZKKoSfKhOlPpr0quZWXCW
 Bg2+dR2W
 Q5ANeywNMQpRyuFJH9wAQyk1E1qJp5wzw+9CcCWfKuhojKMa7Pxh5h9BAEC1N75lziLB+i/LYA+1j+5PHl9z1PSKhUUUpOvBBcwzHNZr4xpJ/sxoGZBl1UFstNmsszrAUfgfBTa1anwAno53BU+x5LQGzWwAlYl0IPIxQ2nwPU9U4pbAioqj0VshKKJwLsyJWiK5qq952oxx7S9UukSvyKYkVLXmTOcks5BxSJyzT5jY7lnr5ZQzsA8scQbqkGst+X35H4wszVuFEz6fyjtlnNDYUlbWbcRST21zF+QadMP6nob008Yd45YfV+bYZ4DKdmc7v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 17:34:42 +1100 Alistair Popple <apopple@nvidia.com> wrote:

> Just a couple of minor fixups and cleanups for the HMM kernel selftests. These
> were mostly reported by Zenghui Yu with special thanks to Lorenzo for analysing
> and pointing out the problems.

Geeze, if a kernel oops and a ugly WARN are "minor" then I'd hate to
see your "major".

I strengthened the [0/N] cover to read "Two bugfixes a cleanup for the
HMM kernel selftests....".

I also slapped cc:stable on [1/3] and [3/3] and queued everything for
the upcoming merge window, OK?

Here I assume that some users of earlier kernels will use that kernel's
in-kernel selftests.  I don't know how accurate that is, but if they are not
using them, they don't care!

[3/3] lacks a Fixes:, but I'm sure the -stable team will figure it out.

Thanks ;)

