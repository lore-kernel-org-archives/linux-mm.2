Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2117CCD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 07:50:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D4B06B008C; Wed, 13 May 2026 03:50:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AC216B0092; Wed, 13 May 2026 03:50:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E91F6B0093; Wed, 13 May 2026 03:50:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6FA826B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:50:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 32B551608E6
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:50:51 +0000 (UTC)
X-FDA: 84761625102.14.ADE2AA6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8CBAB1A0007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:50:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y8tu24O4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778658649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L3vDLT7eL5gRY9mYntqRxATDSmIZOlGhdKqY01mZEms=;
	b=Tmi14evKXU1Ohii/mWZwnaZL0CiB1zTsgomxYa2lTSQ5I3EGD7m2RnaUCT7sAVtlDG0WfH
	zd/qScUl55GLTATPqEDwnmlVyw+xhhn0MBCRQ/dTVN8ssL6v7Q5U4j5fgtqd8sZc6rFvg/
	l2QMpQA4+OZQIQE+lkZUfHQNS5uYnuw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778658649; a=rsa-sha256;
	cv=none;
	b=wIk/mIhtWAPoJaSV4uyicuw9Tt5qQK9QsYss2T0E89/JY1F2duYhCEGdG2sDcYoIUsMX0M
	wEWfKkdx/+d0AfvFCcNkHjg7gAlr/p45qFqFduKcwxFSDZIcKZfIy8yNRGgIKHKQ4J7z36
	tEnpOrCby5EI0xrKGBGI88tGP7sUosY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y8tu24O4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DBD644448;
	Wed, 13 May 2026 07:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A0EC2BCC6;
	Wed, 13 May 2026 07:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778658648;
	bh=MCQeJ5Iv131m6kkGCuiJh8lRJbCMXYg1egO+kK3uzhs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y8tu24O4/8Mdg4dQoG8Q12JtRpcMuK9ZwwlE5pj6eCnqgKc/jmkwugKBpoKzB3hGa
	 o+Rs7Q65GsAMFWDYtrgpUEIBoViTy2abAmFwlbZVlcRVeWDxIMKO6kKVJWy6lBX8gL
	 Ce+v2ddB1S/xm3KKhsCZii6w+nUWH1lQGa4KIZbHleuemxRBt/oNQHjphVdbsBZPuP
	 N6L4K76HmOhHk/uk9nlLwi7FV65i5CRLCs+zcFlMCEwrfoJYm1i7mcjXvqCdzIvEK/
	 5fr6mgjDcLiqLhamJaxAobs7Og6yey+bl7vX5pVJO+aaZIkg83JpIvBwKossxCoLjX
	 O5T//PvVAtihg==
Date: Wed, 13 May 2026 10:50:40 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: George Guo <dongtai.guo@linux.dev>, pasha.tatashin@soleen.com,
	graf@amazon.com, jasonmiu@google.com, ran.xiaokai@zte.com.cn,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	George Guo <guodongtai@kylinos.cn>, Kexin Liu <liukexin@kylinos.cn>
Subject: Re: [PATCH 1/1] kho: fix KHO_TREE_MAX_DEPTH for non-4KB page sizes
Message-ID: <agQtUOImdpoYrfkV@kernel.org>
References: <20260509024415.33190-1-dongtai.guo@linux.dev>
 <2vxzcxz2dybi.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzcxz2dybi.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8CBAB1A0007
X-Rspamd-Server: rspam04
X-Stat-Signature: urpeftg3385pn33f6sz1zknxphzjdqum
X-HE-Tag: 1778658649-57131
X-HE-Meta: U2FsdGVkX1/Nd4Y1K9i/0WBseSYP6N2dClqja7U5bL1kLXgCa7aUhvF1YQpEIsyd2DIS2S+NHWBkIkOwfpO8+Rg52iaaWwQl4uYNQ7K5swpKAMmKHaQ7yndlbLOTExT2mB/rSFLS/dwto+aOq6WC9bA8EV0e5OSfAG29Oj7XOZf0ThakgSKa89CWWNVv/bHT/yAMqeWJ/Bb7hNGrZ0mzLoXknBcGYjgeALNYUkIRZbEjbmXHkg+lKFc/9siz8YDJvYDhZpZRCWzWGq2rzY60r8NEbGXQvKz3fzqWhmIi7A2IC+bhurIixAZHzKdj0MVRxVhCobmoIL3zzqtTiQhmjqmtvN7UpvLIdZs23HYMitg71lW9JGZg+fh5/Vtsr1ryIY7/LmY5IQfsioGeoeXK3UvYCL41e5ltU0UOdLm1wgp5tSL1LKhK4V9jwB4IisuB9M1j5kNO2aCghov2L/T3htrunyBdOxVYurUnNskRhaYH9WKHKgdUrRhNJ0cW7IToRnf6V59P6a8laBHbcHXkqISwxh2m3BbuR+7/jMuGEn+f7FtbMCETOKMHcd+x0GFzHHaRnTzsloRcX83geJIwDMKiP39Mx/OQ5m8ko2/p4m42UQSpDZsWx5SRLK19h+mtcYx7tMy9rUrjkMO+VpW1pMVITK5Li9N8jmRlLiak0tzcrx7X4qd0pRXX2ZTxHgwjgYuHqQ9hjx5n4c2E63V7J1EVOlkYSh3mkjggUFxFKGWNFwQus9QCxetwwan9y1F5UO3Z0lEjrK7iRe6fuiJGKDKZbM/7iZh7nI9I8TxgvGQIFANHxMc9fr8SGjsKUt2mrHy/CqRhGTRPKiobd1THRFFkY7Lt2+jKwX3T5CKm+LUYoy/kXgyiwrFULq8V8EXKTtXAgjzb4nc60IG60Lg3OkK6UQY5+C0csBaZh3iiKLu4Os2eC1LHP7exypSi4ww5sR9jeEFaN3TQkvSBZ6z
 7v02XJLe
 kUyZdFlVMnhyOppgF36x1Pm6zR9t6wXFdrs0XuPsUgJ4NIQG7sdXCgiiHbTB8aSqKLcfAzLA7odu/bgQTL7ghL8Xl5Gv5gAeMZWcR458HB8asSBYlhNKMpP9PXLRok8uJ6oGSSUQUbFiJEz1FG2GaQPf5VC6NzWoRp9Ki0nFzL1AfS5EklIeWc/JvVzs43rnYR8piKbMXeR2ZfZDcbr3U77m/IpnefYDqhDTS+V0eWqVMgR/kyUcYi4P4tocXpdsNLejm7Pb92TpqFw7Toq6pNGiEwa8MJ48usBXKVIVzGkBgLzeH8HU/g3Uf4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 12:40:01PM +0200, Pratyush Yadav wrote:
> On Sat, May 09 2026, George Guo wrote:
> 
> > From: George Guo <guodongtai@kylinos.cn>
> >
> > KHO_TREE_MAX_DEPTH is calculated as:
> >
> >   DIV_ROUND_UP(KHO_ORDER_0_LOG2 - KHO_BITMAP_SIZE_LOG2,
> >                KHO_TABLE_SIZE_LOG2) + 1
> >
> > For systems with 16KB pages (e.g. LoongArch), this gives a depth of 4,
> 
> As of now, we only support KHO on x86 and arm64. Support for other
> architectures is not there. Are you working on supporting it for
> LoongArch? What is your use case?

arm64 can have 16k pages, but ...
 
> So based on this, looks to me that the 5th level table won't ever go
> above index 0 and the 4th level is enough to represent all possible
> keys.
 
... as it looks like your math is correct, I'm going to drop the patch for
now.

> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

