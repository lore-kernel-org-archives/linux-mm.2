Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07909FF4923
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 00:54:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290606B008C; Sun, 29 Mar 2026 20:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2689E6B0095; Sun, 29 Mar 2026 20:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A5416B0096; Sun, 29 Mar 2026 20:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 093716B008C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 20:54:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 940091B86D5
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 00:54:50 +0000 (UTC)
X-FDA: 84600909540.03.7A6FD43
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8759A1C0003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 00:54:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iJR71e4G;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774832088; a=rsa-sha256;
	cv=none;
	b=MmDLrIX+c/4UjQ8TOag3EcG76TtXZArZyS57oLMwH3O+YtBox/nvJJAd8RUwaarH7DHSn9
	ecmKXwEmAIRjrV3Im9inqS7pyy74eS+mLZNO8/hbtGG9SNUQlen2w0f2j1KfSIIMp0L54W
	SyHtorp39uu1qUeubOygrpcwHictbe0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iJR71e4G;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774832088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VeBsHEzxlnMsna5xu42WJbgoECnsygSdobxRGWZZQRA=;
	b=jHySGdTK04XmADdREmeiRWEf+gcQTJy2WVthOe6xbph/junZe/4HfA0ZFeGsmQbbsNwTaX
	bBmWr72kq+ijKBLmMY39h8JkopWEEn2xV/yXRPONARZFam8evqoF4XN1JbYNutIxsDNjSo
	wY+dkdE2peDEZQpzHxKlls+Zdqdmsic=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774832087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VeBsHEzxlnMsna5xu42WJbgoECnsygSdobxRGWZZQRA=;
	b=iJR71e4GObChwPyPFlU3k/TkZbpllL5uYBvO0MPBue4ywA0EoNDY7/u6plk5JuwIGmwG+R
	QrhxgV+jnBSskl9rEkWJHzXEVHoJGWGf8NCOM0iilaQS2eTktNkTEp2BklJI3ThAxDeB3H
	9OQjvaD91vvAajI1yatY4YiknPtWYRU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-230-vBzK6CYLOJ2Dn-0RyBXYow-1; Sun,
 29 Mar 2026 20:54:42 -0400
X-MC-Unique: vBzK6CYLOJ2Dn-0RyBXYow-1
X-Mimecast-MFC-AGG-ID: vBzK6CYLOJ2Dn-0RyBXYow_1774832081
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 38731195608E;
	Mon, 30 Mar 2026 00:54:39 +0000 (UTC)
Received: from localhost (unknown [10.72.112.11])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A3B641800361;
	Mon, 30 Mar 2026 00:54:37 +0000 (UTC)
Date: Mon, 30 Mar 2026 08:54:33 +0800
From: Baoquan He <bhe@redhat.com>
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, baohua@kernel.org,
	chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <acnJyXpI0e9oBRBf@fedora>
References: <20260328075812.11060-1-21cnbao@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20260328075812.11060-1-21cnbao@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: kMLnVoHTQGN-5cu7VbSpnifJpSTOk9Ytz58ikBjVzCA_1774832081
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: eh9q9mw3a66oy7fdhczpfrqmh4jxokw8
X-Rspamd-Queue-Id: 8759A1C0003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774832088-92975
X-HE-Meta: U2FsdGVkX182wvaO0+tr00ztg7MadD3AgP9kQJJww0XeW1FUeWorxS82Kg/Gwh9Us0voxq35ds6bK2ksZNaXab5X7hVrfsqx6LuZH46kxdgn1FIMZFTYyr8sPqFeObQQ3QPVN1tZKKDUKbEb+vRDNgEYvsd9F86kQrmcrJixqI8DTNpzjJTwt7saypnEd0SbahH5CFBkQAvN84XCkEuo+AI5jAQ/jatGXZf1nfCXeSQKFqpROc70r4So0O8KNTZN8UlJqqjwHcBAfOBC1xz1SRwarUDDkYztZ3yvJI34yRk0axepaBXSL+YSiDVuOJiF4NkNl/WduBmZ0c7VI71R68aK208fhG49R9I8iMDmiK/9v+FPdBf6ktcBVP74aleku6+UdcJH2V0r5JOtAnFC0ECztR5pTuTIDuFgulLVOobkQVms+irU/GBWan+9JgimH/UO1jGjYEyPysEB8+45g52g7TV4hOjDsdjEbFmybpM87KDJQ8wAoqFXFrQsimca964tIlpm9NhGhgnkH0qBY1W42FzoeduObQAjNyeiT3k0T6jXYxR+VEFZbOwd+CLKA/uc1LOOsLI3HJnTXmoNqNtObwq2AkLRGk5WDBFNzyYXhG1FniMFdxnyrW3Te9zr/jo22dUk1iYG+Medhpc1CerguNCODuIB0OfDG9hzb+qFjMT1cmN9+IJZI+r6t7+JqE66RD886lL3W4Xq0+AU9MZxOwrchGXxzhP9ne3KHLj86Shy1ukbK2txFHtFXRsS+cvqe7VfoAqL7wehEHmzZQQ+GgBnlkCnGr0kTkUuEGdAdjp1OTg7u7vvJoCZsV/W3dQr9AY7V+stqZbzaEnDXYhYxWr3kmu3EvTxXJ/eB/X8n2DmH9+jeYd8pqGjfpNYkVIeJ52oebA7LzN6OIiSsnrJnFM8BJC4hvuZS1tKeJTMxifjhW7eOkdHdMT/5iKj4jFdENfFzq7hjehyMq2
 kS/ztzAk
 i7nQV+D2tBG3XVpAa7AsaYOXluJ/553/evVjpYCTcyzmMl7sC0iz8/XCmrD6DLTAjRY2xAHc6GC2EV9QTeC80i0e4+fRtzkHJs2QwGOedm9ws+rhW9bXksgbsYZftSfTlmPz0OjdTfZhoAHnd8g91Y0XB8eqd0CnusdlMtypykUdR5k7r0UkAMfUGquLd0R6f3GBiTT8nE4RMBo+Ty2mT1X1ZzPIelZUw4YnnH2yA8sWiAFAjV/s74q/9fLiUONfjjfR6WNnfZZ9s7XYkCOI+21sm7w//yB0s9fcV1N+UuaOHQUK8N1j2OUsm7caO97XN1qon4nxVgxY9ghY015AbK/94jWJqI04BVn9xZkksMVW7rQxW0cHmNvyP66GHSytnf4V/gOnUaxH3y8/0Rh1RT83DHqfjecyrDZMh8rrVXWQAgc7mNpF/bM+J0sr5SyWhzhndZCG+d5yqr0Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/28/26 at 03:58pm, Barry Song wrote:
> From: Barry Song <baohua@kernel.org>
> 
> -v2:
>  * lots of cleanup for patch 2/3: renaming, moving data
>    structures, and using const properly
>  * collected tags from Kairui, Nhat and Barry

Thanks a lot for taking care of this, Barry. I took several days off for
family reason. Sorry for the inconvenience caused by my leave.

> 
> -v1:
>  https://lore.kernel.org/linux-mm/20260302104016.163542-1-bhe@redhat.com/
> 
> This can simplify the code logic and benefit any new type of swap device
> added later.
> 
> And also do renaming in this patchset:
> -------
>    file renaming:
>    ---
>    mm/page_io.c to mm/swap_io.c
> 
>    function renaming:
>    ---
>    swap_writepage_* to swap_write_folio_* in file mm/swap_io.c
> 
> Baoquan He (3):
>   mm/swap: rename mm/page_io.c to mm/swap_io.c
>   mm/swap: use swap_ops to register swap device's methods
>   mm/swap_io.c: rename swap_writepage_* to swap_write_folio_*
> 
>  MAINTAINERS                 |   2 +-
>  include/linux/swap.h        |   2 +
>  mm/Makefile                 |   2 +-
>  mm/swap.h                   |  12 ++++-
>  mm/{page_io.c => swap_io.c} | 101 ++++++++++++++++++++----------------
>  mm/swapfile.c               |   1 +
>  mm/zswap.c                  |   3 +-
>  7 files changed, 73 insertions(+), 50 deletions(-)
>  rename mm/{page_io.c => swap_io.c} (89%)
> 
> -- 
> 2.39.3 (Apple Git-146)
> 


