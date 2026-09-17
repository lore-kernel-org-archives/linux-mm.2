Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8267CC982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 554FE6B009B; Thu, 17 Sep 2026 12:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 507306B009D; Thu, 17 Sep 2026 12:22:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445586B009E; Thu, 17 Sep 2026 12:22:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 239586B009B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:22:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8EA4E120404
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:22:40 +0000 (UTC)
X-FDA: 85223772480.24.81A8175
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id B9AA8C000D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:22:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BB24ejYj;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lWKk6VoHrKC3iYLdqNgUoi+2NqdVBf14F04xFZxpklE=;
	b=hBFPL5dyS+eE1fFW8VLK/RTJg+mMxAXeS13LLeUZFhvspWMXkQMd+GLccmst5qq2L3YbFZ
	MfXTOl3javC21yg9rHMPKCc1gUWmrgfBgQ1MSYqzGCpLEska8OjjU0APYFazgMeZplIdG9
	MFwKXRiVCTV1Y8SEvaYtNQkwlUnC/Sk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BB24ejYj;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662158;
	b=E7F891Suv6LP6nkI2x7WuIxG73HEjcYSS5eme0PhUUPhAxyE8OfLauUZGYh4KcLqy5R6rl
	hZA8VPsUksSBIDkKt11rxdCsQSF1V962bAnlNIKD+PNNwiiGr9o46emeo/htHFmh69z+8N
	dQ4S5qfwjDDAXjFPgFuXipZQvAqxKd4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3AF2A601EF;
	Thu, 17 Sep 2026 16:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44031F00898;
	Thu, 17 Sep 2026 16:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789662157;
	bh=lWKk6VoHrKC3iYLdqNgUoi+2NqdVBf14F04xFZxpklE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BB24ejYjYhTa3VGHJVwJS3Zuf8vBxfWXP1gP7QTxzfgU5BVNQNyUfoi8/gXSmeSpg
	 pAFKA0X8j9JJLhVqrBpQ4pVA9xU3C0fQUCx/q85YkYj0q/zuPTyStNLhGVsTQp72Tu
	 wkus1re/GMkTSF52HiCObx/xxTvBajnrCaatMnGM=
Date: Thu, 17 Sep 2026 09:22:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Suren Baghdasaryan
 <surenb@google.com>
Subject: Re: [akpm-mm:mm-new] BUILD REGRESSION
 892f5b3b07e5b07f2f29c87750ff94fa58dcab73
Message-Id: <20260917092237.5ba48bf16e8406e3753eacaf@linux-foundation.org>
In-Reply-To: <202609171758.049ApqPm-lkp@intel.com>
References: <202609171758.049ApqPm-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B9AA8C000D
X-Stat-Signature: wd14ooqhxfmbf35hz3fbyg9wh1o5rruo
X-Rspam-User: 
X-HE-Tag: 1789662158-668628
X-HE-Meta: U2FsdGVkX1/Q2yK7baijoOE0TVrdoFCEoj/HTyBDiLh0IQD5U2yga22XILAhw/YEDI8jf/zohW+WvcQv+9fa3gy37YVys5xHn+xSIpTisWlLwhm+BlimHnKkBPMr7rF4/viXP5bZEyYv3KukKgMYM7QLgrjfTmV1ff6DEdytizMnFpN7Cb1zKw1nTW80FxkXCG2cfz1nIiqz/Rz4lrOHFwh/YZTF/m6wIXvi0Q3bSaS6OFR1Ll6QFWgGLbJ//lSv9QUK3AeM1r2BkPlbr0UZ9yUqr8FQZ02pbmSNhpmAgc9ACp9vUdvbIMpS0Ir8dvkWy0I5AgWnHohwBebZqs5lwn7YSuPhW8hQKIUTtMJQoEk47EgZJgwHvkFdQw3LStxfjeSJcx/RNpWBqLwKIgKPx7GezYH/zHcyqD4SGeEee1k7d2Hwt754YdCXbeS9gNuYabXcPsTsS1CxLmpKyJv2w8O6Gm0eepB8H89VF/DE7VTjK6JrejEBk306uO8gxFOv2UXFIjdurwKL5epLDYqvICUBZhPN8GPh+IIlzDiAwsmbIgpzBdba5PaKleoK6ZKGRGe/9BPQ4WQNjTj6E+e7GrxKA2vxG4h5VBmM24+8FXpVHMEQ4nuAKFaRS2ZRruA9uwjPjTWXPdlvElh4N2XEBKxHkuBNnfLmGwL4GhUyH4V7+QzQyzCwVUX36Ovd/ouvGb6gtpkauRfkz1qBw84Xp2MBJY1iGB1YDLjFdsJNwPt3/t4RZZJ+Vnzyy7eW3ALAhkyopGgMXQ5WlSOCKqHnGRbP0ytJ/vxSzKlCyFvyjdI/ylY/Rowkr68OoBuXcWXYq0zW/95KgoenGQ5DMsMeWpwZVmsYGjsKGZOY8x8+D6eDVbtq4zGj9wTbIKH33jigFPjFYv3zaxQzRg0c6KR0MTXnvAFHn4SS+U2VDu81DtUyg9y3s4I/rr0wZqJGiwJWVNOR87rv2dUgYd8bsV/
 ZCT47OSd
 waItKk2ZmqE2Imikd8U5e9Drk+gv8ThXhsDYF45UfEJzi2+sBu0sHSDymP9/u37yVb5ArcIhkQGUMy2llubkcXPEcp0I5zgrJpyPbadB8w7j3gRrmm3tGzny7IpZ567q6U/GYbhkFxdxJjKmEnRw0eKz7lc0uzO33fljB/46gfOyS5UfEs5hESIbw0AoPJvJJphoFaQ+mCn7jDsBdRSv8Ccq34ykWPU1P0xIoc4vQIBBydDT46wzHtvWMD5Kr7htRFwLuHKKp91ELsyNenruLxWhYllVXmEFh59N9yrdJpDxalkh/1aund9Jau4pStBOUFB1axkTzBu5fO/WAGIvqz1aSMN5hRzh8sw2I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026 18:00:02 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: 892f5b3b07e5b07f2f29c87750ff94fa58dcab73  mm/swap, PM: hibernate: atomically replace hibernation pin
> 
> Error/Warning (recently discovered and may have been fixed):
> 
>     https://lore.kernel.org/oe-kbuild-all/202609171159.oaB1OaSG-lkp@intel.com
> 
>     fs/proc/task_mmu.c:3448:3: error: call to undeclared function 'drop_rcu'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>     fs/proc/task_mmu.c:3450:3: error: call to undeclared function 'reacquire_rcu'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

argh, we already fixed this five times.

Confirmed with x86_64 and
https://download.01.org/0day-ci/archive/20260917/202609171159.oaB1OaSG-lkp@intel.com/config

Suren, I'll drop the series.  Please check this (and the 'lock_ctx_mm'
defined but not used failure) when preparing the planned respin.



