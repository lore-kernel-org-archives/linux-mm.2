Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50D87C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 16:49:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63A606B0092; Wed,  5 Aug 2026 12:49:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EB856B0093; Wed,  5 Aug 2026 12:49:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 500B76B0095; Wed,  5 Aug 2026 12:49:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B7B56B0092
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:49:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4011416052D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:49:12 +0000 (UTC)
X-FDA: 85067800944.21.86CA564
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9755320003
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:49:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ttigpe1E;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785948550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0fwsujxxGIrrG1oVqUplWmjYHY8EgpYFJELsOGJkr30=;
	b=pi9XKL8H2sxxlSCYWRZJRpmn2qFNkaA/u4kWZOy4IPeCxCsRO4pNrqHEjZm+IUFskA/O/3
	kRkCF4hIK25ZZiEA2jtkGQgGrPEt/Whz6Netu706I5M2z5QnZueggLdOz0b+YTndAl0r4v
	T0n/q59y1wCjEmPYfxZyE2ou8PfiqCw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785948550;
	b=A7SzoVCuN09mKyHlrIX86AA2PO7awnI66vlL25g/Q4SAvDPovx0BeTjkFvP0mTSiSeth17
	RA+v4b/VhyDvJDouLnQi3Tt4rkDcj3TXkCDEYrnu6kQ38EHp54UQmJTGwJxMtlIEKmG5CJ
	tB/rc0hOC+y+MVvcJlV7tjghXa1zgW4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ttigpe1E;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 25CC660A82;
	Wed,  5 Aug 2026 16:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6FF1F000E9;
	Wed,  5 Aug 2026 16:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785948549;
	bh=0fwsujxxGIrrG1oVqUplWmjYHY8EgpYFJELsOGJkr30=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ttigpe1E06HXLXOcMmPHIQUOl9Udzg0P2jmrNL0mvS3w2z2HZxchbtA7cPnUhl5QR
	 MAyZG3eMk4LbMzlZ1xzAkl/mlOn0Dy2UfMat0UpHmtzA6P5tDCrUzKfPOSzGC8OCOC
	 G0efsTXLOxd3c5k8dUrhscr9IZ+NE95E4moYCMAA=
Date: Wed, 5 Aug 2026 09:49:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>, Ye Liu <liuye@kylinos.cn>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan
 Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: debug_page_alloc: fix type mismatch for
 debug_guardpage_minorder
Message-Id: <20260805094909.9e84940cc1f83502a41e2d96@linux-foundation.org>
In-Reply-To: <20260805093108.2352900-1-ye.liu@linux.dev>
References: <20260805093108.2352900-1-ye.liu@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9755320003
X-Rspam-User: 
X-Stat-Signature: gotspmn8reoj4bnmwkocynbmdd3oqqq4
X-HE-Tag: 1785948550-877692
X-HE-Meta: U2FsdGVkX1+wZ1uBflp4/O48xf65Z5MGrUpChsQWV7f27kl5SbsGa23cP1VrjUgo87WC4ln/R4FFdhMqFi7qc0kuvkS6M1552b5bws9DYF9qa+ktK2qfwKUxjoW82oWsQ4SGvUDySl96wN1+7NRTTD8nyoimPIxAgDEmuJbNnmRslR+TpuKUJ0G/rQD/FKi1PUMhunnV9g21UDFCdTY162h3MpcUtVb+sxgY65iW/DMMkappA2LZ9Ia+T1C7WXZft9HoGwA1WyFPSYMjBxeTEnzKLARhlT6e39VzvNfoGnqBYd66DCZRg1+OVMyAQhKXlfvgrDmqLy4xhkUliWdYUoEdCPh4crG+6ANBum+MWbPxU9QXi301ObJRXvCz3Wk/DJGMo04VhPFm3kr6QvKZ8U7bdvrNQdVcJlZvi4RGRwvK4HMHCYGWlWzYIVG750jQEjFvpvKBobo8WJZkOWAncikYjRwk+TUMA1aor6W/dnYZqjdUnstRFl4FjOblyISJf826txP5C00112qUEAEjzDM7IrvrUHiW9pJQPmd+hl6gpmndBY7dBth9NxS00c51hMxmLuOo8t9T/nBpU5xBloCdFlyIRbkPLrw5sfu/U/evIFn3xhgr7zIv9gjbvtyvbUJef7waRusoYwPewMhKycz71QrHkCzd1T9a8pjlMEmuCQK0Cxy3oV1Z+4sKmt3+220Bd/HdPcN3wHjtd7BHit3CKfS1iGfTzrwKsJ6soZLfGQpupu59Yi13/3CIRkTBPEvdAxalFSACed7yv5/RkM7Z9w4YecG53uewCypq8UpdDxEzcLqIzYrcHkk3ZCFPl+MmtWSzU7hbRBqE9MWnZGsJ8x2FFVcFkkmqw+LfhGBS3/EaoVmwXmOverfY5+HbFqcxoNyjVVNunGIWYTAzyquGdEjxT4Gm/sZ3PhiHtr9PJuKJ7DtXZqtzPXz49OvBIlSTzj3jogUZmVtIQXr
 De7bJRA3
 J+CtFd0w28YGocpVP8lVwVZIJbOy3i6tNJ6AYE5wb91VhGvnRX9Df0fz90SqfmmLYiU/3CIz1vH6JgggkEUjx7g5YDau2403G8JT4IxmODF2ZHLexnrDzrQ6Bw7Q+Tbn0U5qGaoXA7dTLsocz1tZjHSwa1jlZlz7g8xBLCv4B4ern7seE3DzTdNpfRW7l2SND2RyVOOFcIl3xJLRa/IrpaWeRJ9S3jddK5B8FGo/G2nt9vvh4+6IsqYSm4i+u52Op7DUxDitrigiNt1Xt321CMUo95hZrl82B1/Rz93rdYoPFGXjhpuMPc0ceyfF0k0AuCUDdLNOeluJnF/x+1zohCJayfKwm2CvjBcYq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  5 Aug 2026 17:31:07 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> 
> The _debug_guardpage_minorder variable is declared as unsigned int,
> but the debug_guardpage_minorder_setup() function uses unsigned long
> and kstrtoul() to parse the value.
> 
> Use kstrtouint() with unsigned int local variable to match the actual
> type of _debug_guardpage_minorder.  Also fix the format specifier
> from %lu to %u accordingly.

Fair enough, thanks.

AI review seems to have found a little pre-existing bug in there, 
	https://sashiko.dev/#/patchset/20260805093108.2352900-1-ye.liu@linux.dev

