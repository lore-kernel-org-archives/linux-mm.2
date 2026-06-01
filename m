Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB75ECD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:17:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D7086B0418; Mon,  1 Jun 2026 11:17:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AF456B0419; Mon,  1 Jun 2026 11:17:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EBF26B041A; Mon,  1 Jun 2026 11:17:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E18B6B0418
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:17:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B9F44140758
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:17:57 +0000 (UTC)
X-FDA: 84831698994.16.7F12A1D
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf01.hostedemail.com (Postfix) with ESMTP id 720EB40012
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:17:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qXQP2NCq;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780327076;
	b=Sa1j5WahoSA6o3H5Vvwvu2n1RgIwJZElV8465s4zzf5/D9Xuu/mB7/T91wP7EsNB929xaf
	ekhpEDtqNerb+VVxD/g9Cf+6bKfniyXyCu8aFhBRtSqqwHsCPvf0upbIUUrDx8pFN+LKWd
	yc5uUEN16N2mXZxPPxbnocuSBrnCRbQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qXQP2NCq;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780327076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rg8W/hYbHAM0ri3fHmP8kcrGaridwiZvmSeuHaJAFAQ=;
	b=cnjKc05euVl1u/vxgdr6LwDhnBI38w19tug1Ka/J1303H7kwWL45sQBN3X2I06LKZd8UiW
	VBqv1r+wJPWqTtnzLp+m4ugdf+Bv0y3O0wd/zNI0+T6mk+hfsRYfd1hE5+RZfsik+1QFkR
	fsR/cnEB4tyjds/thv+5DvQUkyPUjkk=
Date: Mon, 1 Jun 2026 23:17:28 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780327071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rg8W/hYbHAM0ri3fHmP8kcrGaridwiZvmSeuHaJAFAQ=;
	b=qXQP2NCqrCi/beAD/X/kA5YVxzqKAKGVPCXDe8V3yvjNpsrsCnawqV+r/2N0c+KHA3fpEn
	YD60vd/74ryuvgbDxfL6m9trsOJJS+WmMHjZJk4GmaLvHZzx/Ba+ypXUKmv+vyVv+YEZj1
	lIJWOrwHrhVOX+iwLDnSdH5AuzbU39s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, usama.arif@linux.dev,
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com,
	youngjun.park@lge.com, linux-mm@kvack.org
Subject: Re: better block swap batching and a different take on swap_ops v2
Message-ID: <ah2iiPueZzAxnk5y@MiWiFi-R3L-srv>
References: <20260601113449.3464734-1-hch@lst.de>
 <ah2JOjCiDqXvPci_@MiWiFi-R3L-srv>
 <20260601145053.GA5268@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601145053.GA5268@lst.de>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 720EB40012
X-Rspam-User: 
X-Stat-Signature: fcbqcw1bgrbkhd1rx76ze6zgjg3spcea
X-HE-Tag: 1780327073-742296
X-HE-Meta: U2FsdGVkX1+ad3lVRlVz043AcWHZhKo0tujdLvoaW9U0APsf5IF76ISIXPsVyk2Q/CwuACyal4nVY1KXNSN/NI3vlofl5YsLb+xBPCZ9huFEjNmLeSK1zA9bpQzeX4xySZTJYV6t70csqQE9lFSF4RDEHnbffFuzMslUG2ukPglQgGIiZgHpvAGfTIk0Iudhr2ABYmcI9E1k+R3ONIzccPs/QFAqobt/TqUnLu3zuo4cUyWAk0eADCQLm6HLEwjJFUwzxx9aZnDsBLBGOyl1VTKPECF8PSfRfm6GHcV1qpy/Qp7sdLlMHw9kYN43Hcy43PgAQBghmbnXVHvL7vhK6Ld6g5PQUEj0AAqNrSDq4sc07XhQmrEBecmnoqd9QZ3uJn4tY+/7TjjmBOptyEQ/ojTT41Uvn1cvB+nc4G/tftLYkg9Hm+cRiLXYkYHInP4ma1u+VzayfDZrTU7U4BZclbWTQgHNC6mMqgsf9zxouKXI7qlKUEunKrSUCHdB5iHx/pwNV2hcjddWsOGud0cZVN1nu2TgmdpMkqhFLjm8gKgmr7j0i+SFpXfxpX02ZE7pULYZyCmRaQx+RGP1ZHCHVo/6kJH0hXBgEo8Yq9Nq+0T3S1D2L7HfNUZMGw56de0FT1RDvoDnuLL8o7/MhWn4AmnQmHlPTWH6F/JVL0SZWe7btLpOYg78VhPAQ0cSpqf0mACBoH/oQluz10RB0RfW9Nk4Kkc99zZ1D45MiRflbOiSMytzgBAKSEsSz75sOawm2ClPQ1aVVccdxjHv6zGo8bWFebMPVYRuwXb2N9/GoOZCD95WB49Ay+LdTsoew3OqCFsQLF8+b3TQGJtvXPLYYabaOz5bj9I2Zbo+TyZ6bzKIAQxa8kgKa4OqgPq82tBQ08satFKZnCY540gy/Tms9xc/6Vt7crkYO381YNSU4FhqNDscjjFyHWNOmC9HfHcrGJAwJ9kTwedWckgQgI6
 63mh4ajF
 frjEs69HDCIK2/4k3MPwwUk5Sucdfb8hF+nW2eD9ZV4ds48ROFLWCrmU92us0WhYdnKpUnz8gxjGtb9NOIdRD4REhTEe2uGyBIyNYBVXaEugE5Y0MCBphRQQbP/OAo/YeRdYiW29ovaTAHvI3f+U+/1hwbfBlGnQDK1oe/CsJOFxj+4QklAYFXJoVfz1Yu6Uq3HgHr0N//sFP7+4md4c82ZQMplJd8yt80VLwBuILLdgXhcN6Neko0DE3KV1LIqcgx2A+dbjjGz7zh9cJnC8TZIDdaA++mq8FPYUl1Kr7plHaljIDB6JCBc1GX+OAInx5srr603BdZBzOuBJc1zqH7AZZ3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/01/26 at 04:50pm, Christoph Hellwig wrote:
> On Mon, Jun 01, 2026 at 09:29:30PM +0800, Baoquan He wrote:
> > > this series makes use of the swap_iocb for block as well so that it
> > > doesn't do inefficient single-bio I/O, and then rebases the swap_ops
> > > from Baoquan on top of the now very different method structure.
> > 
> > What tree is this series based on? I tried the latest mainline,
> > linux-next main branch and Andrew's mm-unstable, all failed. 
> 
> The base is:
> 
> commit e1af79f3291a268adf4e149e1faba3052743e898 (akpm/mm-unstable)
> Author: Joshua Hahn <joshua.hahnjy@gmail.com>
> Date:   Fri May 29 13:27:54 2026 -0700
> 
>     mm/nodemask: correctly describe nodemask operation return types

Thanks. And seems the patchset pulled back via b4 only contains the
patch 1~5/8 and patch 8/8, it misses 6~7/8. Just in case if someone else
also use b4 and meets the similar issue when applying patches. This
could be related to the email sending tool or its settings.

> 
> 
> > And by the way, usually we add version number in each patch's subject as
> > "[PATCH v2] xxx ".
> 
> That does sometimes happen but is rather unusual if you take a quick
> look over lkml.  It also isn't the default for any normal patch
> sending tool.

Really, what I have seen are all this kind of format, but surely I could
see too few. Anyway, it doesn't matter much. Thanks.


