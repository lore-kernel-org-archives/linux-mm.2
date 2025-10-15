Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA68ECCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 07:05:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F29DB8E0003; Wed, 15 Oct 2025 03:05:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F00A68E0002; Wed, 15 Oct 2025 03:05:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E16638E0003; Wed, 15 Oct 2025 03:05:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF86C8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:05:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 542B75CA26
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:05:44 +0000 (UTC)
X-FDA: 83999463408.16.44FA9AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 81F2220010
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:05:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=foHpd7vV;
	spf=pass (imf03.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760511942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cH0NJo+/fDG8pEEJ/srku2xIGB27bmqZXJ1aeuMexUo=;
	b=iaN37S9SQWeY0JcJeSD49Ea78XlmWbGU0Ql5vcTQRxFKxIAriea3hRFIaKdem/pt1Uv2mq
	JrrhYVbAM2ahcINtU/78ZOsrgVjyRJvAvfvVfkWS4HIdpDhY7oB9BF/OLLDBUs/BS7WxAZ
	fLPyESIC+QaGm02+Fzit3HwQ/9D006s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=foHpd7vV;
	spf=pass (imf03.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760511942; a=rsa-sha256;
	cv=none;
	b=sD8tKXbtwUBFvSt/ctMqYOeTKaXqZSgijPxWnSedmcDp2fIyowXuoXm9fDlcywOQKATSik
	TVqLvchrlnkyQUOBPQuGUBGJ56TCi4wUNg3QBQjExjz1f5Cj+h4QWrJD7jC9v0guQgBZ9i
	62qlW/jtxicr4fgvdUfY06j27vaLia0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4719340BEF;
	Wed, 15 Oct 2025 07:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0574C4CEF8;
	Wed, 15 Oct 2025 07:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760511941;
	bh=S4ISIxsDbh66QNuheYs7XjdrsB7o2PxzZSVLohh+obw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=foHpd7vVDBJjU1ci9E7s8nn/l9bqYBG5rN0PjgBzLkdDeogU0pbmzwSWGHVfOcZTy
	 Cs3XSrRV1zyY6J60ADwW0j9Q9hucBNQwkSzNCm5pRNCqSBCuGKv9Ny+YbA7NulI/8T
	 G91f1ES7kt+9UxIukV2IEt4yOo85i+EqwJEiIrYsl4r11bc0JSFSFpk/ZgKVPzYJHJ
	 RK8SrVjVV1OfeN5rN1gAULbWWoT9QVE65X4edo6Aifh1zQcH1RPwarp80yqw2d5HGT
	 ope0GyXxl0LZ3LBjWCzXn7pFvtRjB5xIYoAZhU7T6V6Af5AvZInNE6gPgtG2Fgjtuo
	 vO8QjedNG93xA==
Message-ID: <c0274733-bb5d-4692-8288-fbdc7c35800b@kernel.org>
Date: Wed, 15 Oct 2025 16:05:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] writeback: cleanup writeback_chunk_size
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Carlos Maiolino <cem@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
 hans.holmberg@wdc.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org
References: <20251015062728.60104-1-hch@lst.de>
 <20251015062728.60104-2-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251015062728.60104-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 81F2220010
X-Stat-Signature: 46ob1q1dhf58834eu1ni7u99t81k5cr1
X-Rspam-User: 
X-HE-Tag: 1760511942-956701
X-HE-Meta: U2FsdGVkX18yoqBXFJOGeBPKcUi6wPIOZdWieckG5jZ1IlwglL6jy14ZsdLhp7qe/mMWKeHYZOcfxRgYTUZyj5O8tfK6ouuwTReftL0SAtsb4uY7CyL3D+VzzByrvF64ouwoQOOlkITQdWQLWmM0R+MGn4ACHpZuVDiHdshMRdlPthvqKbOmZva5IHZHtvKaYrq8z3A13U44HbE18rLu9Kx3PbkHlDiITfkL3Yr1JWL1BIVKks9ey2tAo34EmDsEyDrH1isr9FJmpH4uyl/4fGro4gkN6aDkEqUCF0ag2dFZLFz22cf7EmZHzCSg7EKIsYqBsVgRLBmKZYJXUIOQCJ6UEaDDptihOfisXm60+j90uU0cxuYloLzT/umJOTIvgxKKw0fi950ukOPy6Xx4VpRM0noZM7VwR5AbL6Xo7ViYvvt9bfnlH481Fp8ZewVmSOLRQui7T8NDRmeKHXFXQKWpJNvN9LdixeqyjlsnnMo/mcvb07H5b4e0lj/cwdEHjO0/t1D7ytf3qwfCO1j/s3U2DGNgpvMsjKFrBSezT4lWRr0ImGMd1YMvj7H1tAhd0ikLYYkGVt0zXvC6pwQQZVvfK2sIC8Vd3EaTgQZKltGsXmOuZbzeCk3/zSk1wP3OylHS0u5R8TGDXu36MbYyi3pF83GL5Cz/bUdm0n/cjXe4wMMaadnRNmL7kM+fc6Y2NRQPlaQKeQ5pU9hXvrTh+IYZjwDwlQZQ0dXO9fpwHQnI0psinGCNlUxk88PB7z/nX2ggJp5BF2fLRYi4QKt1/V5U4B/8Q/WagJ7fI/BdbsNORwY/6JqSdxxeCXFPKd2CmXAeTblU7krop6w9Y3KFVNsupa8/DchbS+00zF4bJjS/Jr4AGkh/TEzkW4Y2wbGJAS5tJ1TqhJw7shXyLUkRTr1NJjsu3c0fxGzLxH/Ou6147xbMAo9AzEtY+SgimEOGLl91DMqX5xShlbqTatX
 6jTP/IHT
 XVf0bZ1/0GIwkXRyuOTUa+QN4ZIBka12y9bq9zyjCn5qF2Okf3OpEJ7FZgH+bxJybRfurgryMvZPm1TjVVZDc/foCaTDY3Vj5UQtra3F6LqxUbg7k0hdypNEICX7rzfMap8uT4TtZPZiOZSiWyvFWjukeKA9kXJbtXcLxg5K+ZAkXpKYHLWShwd/hjoYgEp7tP7jX0UbSsO1UhdnTQxwyYB5mu3whUGvWxhJqRaDAfaiOXUh+UskKXi+dzTUG/MQfmcen0t9JX3wJYwZeA5deYVH5XAHUo8D4MDVIDEO+qkFnDNGvQB/3JNg5/CnNSpq/FpJkkWhlaltKu/8xin3fjni5nwW4tdorBRfteMk04N1Sf30=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/15 15:27, Christoph Hellwig wrote:
> Return the pages directly when calculated instead of first assigning
> them back to a variable, and directly return for the data integrity /
> tagged case instead of going through an else clause.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

