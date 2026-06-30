Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13052C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 08:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1A306B00B4; Tue, 30 Jun 2026 04:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF2096B00B5; Tue, 30 Jun 2026 04:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D317D6B00B6; Tue, 30 Jun 2026 04:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B01D76B00B4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:43:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38D7F1C6DD7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:43:36 +0000 (UTC)
X-FDA: 84935940432.12.6BF6F6D
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf08.hostedemail.com (Postfix) with ESMTP id 96610160003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:43:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="GveY/WIM";
	spf=pass (imf08.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782809014;
	b=v9+JNaHBFjhEAveWLZTOZ3JLNy1IZS0gDiNbel6qOUDOXjJylO9ImB1KHtq/jD/GLefQfb
	7kunRpN1TtKZsuXhYMslnwf+koaeXQO7YtV7Xm4LqbclYDSFAvD57mYnXnro2LWY56EMtZ
	29jVwJKJ+OkrYPad8q7G2JOuQH4LndI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782809014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/gW6w8U/WCaarQjB+76b8mzfBR2xiHvXJCYHZYl81Qo=;
	b=AI7DH3dkqn59v7peGi8QTtGkt4WvnWN4JmY74UXxHBZcxiZEJI7pcN9E/RlWB1S598rVhT
	GAmoNUgblNdc5WoiHP7JOyOKyYGgOIuK58V1GUcCIRIN62vO14FmfS+vtYPo2lM0PJg+wH
	RKS4yVeCT71d7v4IlziFDJgY1ZykdMY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="GveY/WIM";
	spf=pass (imf08.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/gW6w8U/WCaarQjB+76b8mzfBR2xiHvXJCYHZYl81Qo=; b=GveY/WIMBM8ZWTvFxQvsy/zTA0
	lcj9zY+LDuBKIgTx+xf1B+fKVQVueeKtm94MicTrcwxB0HQxqdn1hUlQBm6Sj4zqDfOsDFByPzmGb
	ypZI2zV7mvNZHVs40RrGlJHkV2BUABJmL5vgYuxShmZlmJnyMZVxJW5fRbYAjOlQ868D6n5iWi24D
	Tn0fdQMaMq1t0ueVkIfpMRCZh1ivTEpY8yc4VoYLsr1uB0B9wCfICVWCHVwWMPpZ01ulJVEADgEBt
	bjqLFfDzbPS+bwdpZbSlYO3HbpAn1TEaoazTfKJ6RSW9iNhCXhXUeQ75wSDFY3rPWzER/0gfKI5SU
	6Da3o0cg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1weU3u-006wWk-0w;
	Tue, 30 Jun 2026 08:43:22 +0000
Date: Tue, 30 Jun 2026 01:43:16 -0700
From: Breno Leitao <leitao@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, "Liam R. Howlett" <liam@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 1/2] mm/kmemleak: dedupe verbose scan output by
 allocation backtrace
Message-ID: <akOAzZkWRzQtIeyI@gmail.com>
References: <20260506-kmemleak_dedup-v3-0-2d36aafc34da@debian.org>
 <20260506-kmemleak_dedup-v3-1-2d36aafc34da@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506-kmemleak_dedup-v3-1-2d36aafc34da@debian.org>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 96610160003
X-Stat-Signature: wd1sa9us4zoy4axebsibd3gmb9d4n1d9
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782809014-810027
X-HE-Meta: U2FsdGVkX19LdJiXqeAsgj7VvMT8l+uk2eHT/+1XsMKoWSjwmDYqt7l8Y+hYjQ6R77pNCz5LLyMFCWOvSCJZqJglkzInFmeAUfYw+8X2ZLJ/mznVT97verIuNDLk5E1xpBiAc30HAki3JJ2Xj1ahZmZP0w8k+KiLi1zvzbny3lakk0PECuYtX5vQjRg0fgWeyYZFuiN0nMTgpE+IRPVEM2qI+h/w3snefdugYNjo8bqh9ZIo/tS7torWDNeUH/CSK+dHdP5N7idE2OqCYoU2gy42+ZI4EjU3kksbuIVqiAT9wWafPXxvEvyqiqbzi4gU9dcUFezCetx8C983tWNQVjcmQOuBaA/oKJXQ9zegOCxX8iL52djRYUfdLT85hZnr+ODhfGghN0rGHS9GP7mBMonGE/9GtXPh8wf6SR8aidvvt8yMyfvkusXCC/HT/oBEJwe2g7Kkdl9MrBr1MCFLL5lP7ugfnChz4t4AkmnNeMK5WFfsxH9oOXEMOGIAkd4qFbVtwuynIsLaZpbfxbyHcGyz6aVd7swW1fx5yl17D5C7BSHHMnv4TLCaL4m/YwXFjgJQJuioqB8CeFQosRQ1eVB//5XmLKF4aKyTwIhL7w8elecv1U3yyYStYhVcNCm5UqzwAFKC0RpPeOX1zWMgaCoaHZpGbsXyTtS5m6+BHJEThs9Yfcp9ltsiyVYRxUtXSKLhXNXTwP+uBP3euLYSXNRWkfE8OOWH6xnoRhJe5NSglChUYXBgDBKlZWdTjvOudcu1Wbyvo1Fv6cWN9Sptzb42GNo/CIu7kfSrIOgAB1P+9BtCIfK9n+AzGS2PuchmPs9k4GkHFrNXFwd3tFKjnvBwuI7hHqSzbUQuc6QJoCFLL0nmCDrueAoVi5baJ8rHSV2Bt5swi3o8Ucv9zxjY1VapX7Ie60m9EKPNAKm81iOzlYQRk9wqAUEdhYALCDEoE2kXVFVyk87d4DHBEKh
 Rb30dqpp
 +ynLesQcI/PyTdNlcxa0gN1DU+ldrqTwUNowAh9ZMGwlKOXMasPnHYQbw0vl0pC8Pi+/EL4tn1xaT4/0QoniQCisy7wPvsnS8byRsbeLu8dklw47/q1uIPSFcPFj2mPe+2EiGUd4VnBaM6Asp7Y5HpWx3Rqq/TOjPPqYBCSgAN3u8Vq/OD7zoKMm7Xrzn2vjxikQQIw/1FAgMk/rYhhztGFY9ZVherDShMqk3Rd3HBfkIM3KL+o4CglH3KPMtVDB1qORO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 06, 2026 at 05:58:24AM -0700, Breno Leitao wrote:
> Dedupe within each scan using stackdepot's trace_handle as the key: for
> every leaked object with a recorded stack trace, look up the
> representative kmemleak_object in a per-scan xarray keyed by
> trace_handle.

Just to circle back to this patch that now it is upstream and deployed to
production.

I've got this feature enabled in Meta's kernel "debug" tier (which runs with
kmemleak enabled), and this is being very helpful. For instance, this is the
kmemleak reports (instead of 330 similar reports).

         kmemleak: unreferenced object 0xffff0000c3b5ca00 (size 96):
           kmemleak:   comm "swapper/0", pid 1, jiffies 4294748185
           kmemleak:   backtrace (crc 22d8f576):
           kmemleak:     kmemleak_alloc+0x3c/0xc8
           kmemleak:     __kmalloc_node_noprof+0x42c/0x7c0
           kmemleak:     __alloc+0x160/0x3a8
           kmemleak:     alloc_bulk+0x3d8/0x7b0
           kmemleak:     bpf_mem_alloc_init+0x3f8/0xd48
           kmemleak:     cpumask_kfunc_init+0x88/0x158
           kmemleak:     __initstub__kmod_cpumask__654_534_cpumask_kfunc_init7+0x14/0x28
           kmemleak:     do_one_initcall+0xe0/0x9f8
           kmemleak:     do_initcall_level+0x12c/0x1d0
           kmemleak:     do_initcalls+0x60/0x108
           kmemleak:     do_basic_setup+0x80/0x98
           kmemleak:     kernel_init_freeable+0x280/0x400
           kmemleak:     kernel_init+0x24/0x170
           kmemleak:     ret_from_fork+0x10/0x20
           kmemleak:   ... and 1 more object(s) with the same backtrace
           kmemleak: unreferenced object 0xffff0000c3b57080 (size 96):
           kmemleak:   comm "hardirq", pid 0, jiffies 4298468258
           kmemleak:   backtrace (crc 85619951):
           kmemleak:     kmemleak_alloc+0x3c/0xc8
           kmemleak:     __kmalloc_node_noprof+0x42c/0x7c0
           kmemleak:     __alloc+0x160/0x3a8
           kmemleak:     alloc_bulk+0x3d8/0x7b0
           kmemleak:     bpf_mem_refill+0xb4/0x8a0
           kmemleak:     irq_work_single+0x9c/0x178
           kmemleak:     irq_work_run+0x12c/0x208
           kmemleak:     ipi_handler+0x1cc/0x900
           kmemleak:     handle_percpu_devid_irq+0x3bc/0x4f8
           kmemleak:     generic_handle_domain_irq+0xa0/0x100
           kmemleak:     gic_handle_irq+0x364/0x688
           kmemleak:   ... and 331 more object(s) with the same backtrace

I've haven't investigate the leak itself, and that is not the reason of this
email, it is just to share that this is being quite useful at real production
environments.

