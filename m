Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE307CD8CA8
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 01:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62B716B00BF; Tue,  9 Jun 2026 21:30:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 602886B00C1; Tue,  9 Jun 2026 21:30:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53ECD6B00C2; Tue,  9 Jun 2026 21:30:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46A216B00BF
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:30:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0BFA9165191
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:30:04 +0000 (UTC)
X-FDA: 84862271928.26.4EF8744
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 28D4AC0003
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:30:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MVvxqZno;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781055002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vCu1T632UHHSmMD6YMm6b95GrTeLcRhEQPBtBgubed4=;
	b=LP0B27ZVYoX18f5cLKFrabvCwwVrNTWKAz0GQvvYPG3Irm6GDX767Av28OuYNIgVNnuNCU
	FGvxsvobKt8qTSYBRO75X/l+xCim9Oq4GHaBfeNhXQ4zCOrylJO/nHlv38qio7vewzo6lL
	p1y/09egTm4yQX0C9F5nJ/+ZGA2p8sg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MVvxqZno;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781055002;
	b=6/pBp6K/2rcops02XI3rBgEod66pjV2JHZ/afV9T3rJpIT6u/vU/23RjCp3Yobib5wVd/S
	GCCDPW1oYEVKxLIGdeSakITZ7sMYy1c0E/xGSPsJfSkEPQU1hxWYNgLQGgzTiz+fk86QZ8
	QZHh1q348hFefFG+2VZoHQnkavI1gCs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A54A46024D;
	Wed, 10 Jun 2026 01:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196531F00893;
	Wed, 10 Jun 2026 01:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781055001;
	bh=vCu1T632UHHSmMD6YMm6b95GrTeLcRhEQPBtBgubed4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MVvxqZnoKUjEUjzEL4TCTecwj5jDqNyDY0+GscoaF5wWNyAK71Qwrc34YHlnptrRq
	 nsCmYcJ+Eu1ChHvsa+GonSavxipEUjy74I8tCPdVCbjFfbFTgrTtgzYm4TH7BIi4uZ
	 SqDcuVpaTogPoAcI6Zhrv5rHbhoL64q2dNsunzsE=
Date: Tue, 9 Jun 2026 18:30:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ruoyu Wang <ruoyuw560@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol-v1: use nofail allocations for soft
 limit trees
Message-Id: <20260609183000.296ae8ab0f0e90341de43198@linux-foundation.org>
In-Reply-To: <CAK_7xqyyDqNW1+puMSp2LzxmOKxFUx-UO9uGiDKoL7ZTJ8+3ZQ@mail.gmail.com>
References: <20260608063644.39-1-ruoyuw560@gmail.com>
	<aiZ3EZZV6LqsTxQM@tiehlicka>
	<CAK_7xqyyDqNW1+puMSp2LzxmOKxFUx-UO9uGiDKoL7ZTJ8+3ZQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 28D4AC0003
X-Stat-Signature: wggc97ru1atbbiwnx71gygnhj73j7bkb
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781055002-834305
X-HE-Meta: U2FsdGVkX1+5qRB4BTBBDEGUUPZqnP3IDLIsAwiSRbXx/1BqfWbZ0PeQsXLv77MgzAdn8Q2pHrXYdg1uD03bhNBpeiC7sz4eL13ln3pTl99Lz5Ta2bdlsK3g1ZYTaAXg42rBXLdyYtTyXrIhBm7+tVhaNTjq5kV0XI/BccE1oBQIX0q/NvGYbo+k8cVvgvcdWxKDUW/iwXqUH5XybcJBJsfKfaWcbrojOXxUf8rQfxOLYkk7UTkszK+P8J32aXWU8dyhL5UfEQAFJO0KRMHq/GDvWdaPKWrJw/w6NDTVoLckQ3c9GlX6AbY72nscpn1ecmnW6/s43D+YI88b5D2Uss8IYuyrzZTu1XGLa/NncgOcpNdzX3syGlTwU/DzHX9gak5jmYN5wKUpAL+o8sDwYXcJhWC2QJSAJ46wtVPpuiARmNYOmwqg6Khxz5lCdHWIGmaoBlValIfn1w36eALAiyhmtS7wJGoFY9+KIsLLgX391DMhUBmXKEufRtbEUg1ULwi47iJmBIlpTbI8K6pa4FTUGMpur+OGGJ40zZvZ1ZbNRks4HfosOAyL3gXMWT+SV+V9wKOd1HyYkD8cchcG6gq8YUz08I6Vl/Wftd79yz74sfOroPt6a/VyaTWA0I1Z5iMhf71qouR2M1F1XZgWOVPBEmaU0oJlEOsY4eyAQXJvKiBL5roi/PC8JIGJ1sQu6xYQ+DF08Lw55n+q4zaBHP/qb+oLChz6Jedq0+vruOywxtp/TMh6Gf+ezOh+kkNWgVrUS8FbJk7DpSGGY9E39bitZI/tsVg/cOJhBLRsPbtx4dojTSwKYzax7Rc04UHlKNWtDyy+EkHcTXAFAglRRDyj5kSBVqZXgOs4Z6smNv3EODELZdt9mgUko6jVNs69vDbg9Nr1tUHzTjppV0ioKplrdgWA//kkDChXdsMDIXNSfOr/7dbEhUvhay2Ve/wV5AVqz+qjXf3hxxczvtL
 0Fh8ik81
 tqYS4a15op/6CXDKZR0/uAcMZ4k4dFLHrvEm9yTXCp0s/0IpW4gYhQEUbejMz3BuReQVegzIO2ZaKBR4JoxI66aFuOkUXnsCpmd/wLfCVEOkYdDGARJgbdP77jQGY9eh2JcEodElkdVjpHHGLQdAQA7h78W72F3hq0wQVCsae9siscLu4I7qX0HSEFxPFAwpe+PLx/4Vgfz2hJyM1dzeWhu6FfujKrvjJOEBhft825TyrIL4P7yjB1qCaClJ89AguRucJCixs52rqFbQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Jun 2026 16:34:48 +0800 Ruoyu Wang <ruoyuw560@gmail.com> wrote:

> This was found by static analysis and then checked by reading the code:
> memcg1_init() dereferences rtpn unconditionally after kzalloc_node(). I
> treated the soft-limit tree as mandatory memcg v1 init state and used
> __GFP_NOFAIL because continuing without it would not be useful.
> 
> I agree this is early boot init code, and I do not have a
> runtime failure report or fault-injection reproduction for it.

Thanks.

Please teach the static analyzer that kernel practice is to ignore
allocation failures in __init code.

