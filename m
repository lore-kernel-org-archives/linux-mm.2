Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7343C10AB82C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 23:01:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6818C6B00C3; Thu, 26 Mar 2026 19:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6324A6B00C4; Thu, 26 Mar 2026 19:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 548076B00C5; Thu, 26 Mar 2026 19:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 44E146B00C3
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:01:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CBA74BE088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:01:35 +0000 (UTC)
X-FDA: 84589737750.12.6A17816
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id C93BD40014
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:01:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UYb54Kxx;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774566094; a=rsa-sha256;
	cv=none;
	b=d1we6cmIG9KVOfW+NrfGCQj1R90A9QbHhsIzRgIWTh6cQBheBQrkhDjF75q7rmMhXe3upC
	/+ZIF2vlYvcZ7p+zkVqeW5Zac60v2MFqDjLg2/8r14seS09jju64rjdK+t8hc6zy6gd7TA
	tbh2o1tC2XIZ7TDKx5V3dWxfTn/Bsvc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UYb54Kxx;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774566094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MlHbqRzl6gzEcKOWNCAF3Qv86V1iVYs9W9/fFCdzjhc=;
	b=1F4U+zOOb/O2+Xd/UfVH/EK54gP7Wo7rE/TdOQVqVmgFo0/qIvOrxTnikKQ5Bo1l7+ylak
	9Yrmshd8wn43+p74ceuACZaRgg1OBuaL66Sn4uoYnOXLty6WF/q2bRbwymkbIkXt+imxJ+
	aR7603dV50TN7tV3qd90jFdRUdzp/qE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 20839600AC;
	Thu, 26 Mar 2026 23:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38630C19424;
	Thu, 26 Mar 2026 23:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774566092;
	bh=cDTsrbhXw5vlpWEEc4LUAv5/LmEmN3f96wzlQ2E2W8I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UYb54Kxx65LLq0qlCcbXJfPX2Ur0P4LcbnlozgE0qzkgcE1vgcXIHYzjmSdiFd72C
	 b537IQfQ/372i9zPL2tZI3RdE05VqCLNNhSFjzK1VEUE9GnVk9PabkvstDOyRee/8R
	 Tj1gSL8mE+nLLcG3D0whAWOsGKQxGSlBJWP9AU/0=
Date: Thu, 26 Mar 2026 16:01:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Wang <liwang@redhat.com>
Cc: yosry@kernel.org, nphamcs@gmail.com, hannes@cmpxchg.org,
 mhocko@kernel.org, mkoutny@suse.com, muchun.song@linux.dev, tj@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, longman@redhat.com,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v5 0/8] selftests/cgroup: improve zswap tests robustness
 and support large page sizes
Message-Id: <20260326160131.9f3df79db328ba2095511161@linux-foundation.org>
In-Reply-To: <20260326032658.96819-1-liwang@redhat.com>
References: <20260326032658.96819-1-liwang@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yx687jd8hwkas14boc3rkfhrq7kxwqs6
X-Rspamd-Queue-Id: C93BD40014
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774566093-207670
X-HE-Meta: U2FsdGVkX1/gcv2ITFPcj4p4SIjenDNMyUhQ1cmjaJWt0zApNEQ4VvKczpX7ZLqZ8BRg01ydJHUzPlh288axNFQjtt9uChWuT/H068axPI8A4EHAzErSyS8JNVdCI1JcITFoJ1DSS9WJeG59JP2im9hNUazAvz5d9Cv8YSwhmjIXEwBwDvbRmRMJc9NyGsmtgDRipyQK2zdAn5T4OarXoygFOY7rILs1XopfNOZeacypmt84mNr3LR5XN0Q73YoAtu+xug4KfEr165DPUGnCg0ZzRnymdk29xWeuVn/GGrVpra6W6ayUCVkxxMukdohLKJzSi1iuBF/f95ugP/8805iH1iOS5UO7G4ZhywWFLyjJvi2epJjr6Hhf0hDRJRzk2Luf8kvDL/JkgulLXvxaofkFCdNkn24XzC/qF/3f5qvaAwvibPBUOCVlx6b1lQ61CRs8C9Boyy4TwKEzu/STPA0tJDD0nE4XONpI5QWlho84Q0XC+RGeLurwl8OlByazo3X597rsMhku4lvSbeoQdSySSFzEu3mgXxU4g0rU/t/ysfdgMBSxvn/t9bN/6jGtxkOui5TzwAb3MU4Fx+STRMhasQCGpZXmjDMfsSrbN7/V6KQThCdt0mPexisXH/xi/GiejcdFeDrpR0odltfOGaSQjtaeIN6KCIDLOqLbXniPLfVg2o+w/0vqIOAi2B6OF24eaYyXdxQp0fm/ExAlS7qeRBnsy/4jeGYRjFe81LCU2mhsYncZEQUQ9nhdVrEsGWE5ljrZaeWMXzHWmFJ4cKHt6QHVY2s+g/09D37u/mxcCq079klDVGshG0tRPAKOicA42Kjxy2/x/I4Gtnl18/+9vIxQleJi0XkhY0ZTYXQpVZVgn45AjybJGUARSGG5/b5QVij+yqUTrDWsQcmraMXUG+yjXvpgCfz5JFSJZ86Bjp5Hit4ovJlvP97Gr5VJZFy6T8vArjittuDbsRy
 H3xj5OVN
 x/DO6VdqgJHk0yOGSEa+JsTTQ6i96BkoD3RqdWTXEOZ4Nj3YfQktZb/TGbKpo1A/+jtCTqnTA62UEul6ngQjUfTsjAvS3Q9CgKDDrwZZryxkwjQDPigjKkvk3I02h+hgnneCtObN0zIKklvjZGCfcSyK0mjWbAUxaZsHY+7vZt9nXWA+nyuiqUqaRaVppfP8k0IeV29iTPOPIaYWuQncINmbyLpD+/awIJryFlPSZrm/J4weFFU0PFCKEPopq+bhffMeyECIm89mtJUzFy6ZiareTtYV8UEF4gb1Cm5JglMsGC+Py/biT5QGzFj1XF/r41uuxr9exvhMTyNzGmtZWxtdoTVvA6uZNLmOEpe7uo3+GGxqEFkxmjl80olCAZKSR3psrmjjAtXkslgfiNUDvY1jnbAEXYofQXjci
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 11:26:50 +0800 Li Wang <liwang@redhat.com> wrote:

> This patchset aims to fix various spurious failures and improve the overall
> robustness of the cgroup zswap selftests.
> 
> The primary motivation is to make the tests compatible with architectures
> that use non-4K page sizes (such as 64K on ppc64le and arm64). Currently,
> the tests rely heavily on hardcoded 4K page sizes and fixed memory limits.
> On 64K page size systems, these hardcoded values lead to sub-page granularity
> accesses, incorrect page count calculations, and insufficient memory pressure
> to trigger zswap writeback, ultimately causing the tests to fail.
> 
> Additionally, this series addresses OOM kills occurring in test_swapin_nozswap
> by dynamically scaling memory limits, and prevents spurious test failures
> when zswap is built into the kernel but globally disabled.

Thanks.  AI review flagged a few potential issues.

	https://sashiko.dev/#/patchset/20260326032658.96819-1-liwang%40redhat.com

Please take a look - I'm interested in learning how may of these you
feel are worth addressing.  

The sysconf retval one is real, pretty minor.

I'd be inclined to ignore the unchecked-malloc-return one.  It's
userspace, it's selftests.  If a malloc() fails then gee, fix your
machine and run it again.


Plese understand that I'm serious trying to slow things down now
(https://lkml.kernel.org/r/20260323202941.08ddf2b0411501cae801ab4c@linux-foundation.org).
Maybe we can weasel out of that for selftests but I'd rather not. 
That means post-7.1-r1 for this patchset, so please plan to resend at
that time.

If memcg maintainers decide that this material should target the
upcoming merge window then OK, 

