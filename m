Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A538CA9EBD
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 04:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF9466B0088; Sun, 11 Oct 2026 00:18:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA9096B008A; Sun, 11 Oct 2026 00:18:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B97B06B008C; Sun, 11 Oct 2026 00:18:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97ABF6B0088
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 00:18:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 42C76A837B
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 04:18:08 +0000 (UTC)
X-FDA: 85309037856.21.9029A1E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 649D6A0002
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 04:18:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mOu+5Xo7;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791692286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DQXe8ZXbnsxg1+ywX8B2BQaYZQsy0RAAEXJi/kKPUSA=;
	b=WNCHIklcseHffoHAlh3tsXjuHyq+MC9xkNmxgygD8NpcPM7yE5wHIEUwO2ZL+yHEUXTjAH
	P8w2iF56jPdgwNb5mMwYiRb+tZG6hoM6wsrjMr3aBEf7q/lE9x6lGGmgqKb3lopGPYfUOC
	Nioi9eV056OCURs1Aa8idR378tW5VQ0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791692286;
	b=zPVJ8iYWpzwPyfOO/67QfC8pxw8z4o14CoQSk9aMrsXuJAqw4pLtW/2ij+ClzUBZ1h2jKc
	zhUPtDqwlllghFsa2nOJN4Ri6t7/wu9lLv+MiXKF4fov/p3gPhYn3/57YcGBbb771jb2ky
	Iw7nqoQPYOie4i6jMFYX1jrYOpta2V4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mOu+5Xo7;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 40ECB40A4A;
	Sun, 11 Oct 2026 04:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D4B1F000FF;
	Sun, 11 Oct 2026 04:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791692285;
	bh=DQXe8ZXbnsxg1+ywX8B2BQaYZQsy0RAAEXJi/kKPUSA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mOu+5Xo7a92z/S/2VGgblZPi8AXguP9JYXkNhHRY8SSbjs2GXb6O2n6o4z54OU7He
	 pWY65IfFS85L+JZpRRHtGWAsiDdg91jaOHoM0RAw4q3AggI5pxqGoxuVYBRzDURHXt
	 uQJeXyjLRxzCGWl3E9+zhqr8BxH1osGXO3YVaxu8=
Date: Sat, 10 Oct 2026 21:18:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Adam Harshbarger <handyhandyman.adam@gmail.com>, I Hsin Cheng
 <richard120310@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] lib/plist: add a plist_test case for plist_requeue() on
 the last priority bucket
Message-Id: <20261010211804.2d8a5f6180c74b08e18ad48a@linux-foundation.org>
In-Reply-To: <20261011012245.765558-1-nickolai@csail.mit.edu>
References: <20261010181016.44f5e2883b6820bb32c04204@linux-foundation.org>
	<20261011012245.765558-1-nickolai@csail.mit.edu>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 649D6A0002
X-Stat-Signature: 8q8qffy513bb5u7ra8m33mrs8d1ruk4q
X-HE-Tag: 1791692286-395509
X-HE-Meta: U2FsdGVkX18QLHcHXvg2dDFYqddUxvazf2o4TbVu7+aVart7phWWcGFJQv7JOvvagRXOoG7LryNcMLg+TI1GSSlYOuRV2dH8GB6+dzbInirkFa25FceuWG/oBywNmRA1B7diFezwRHCgA2oF4sr5z6sbcWJkBla9pf4eGG3APZrn2V9eW2OXBH2QJWNEtP5hxQHyl5ihr/00uhoSFAg5EfmSO7SKnSRNybvF9964LWsUT3Lf2ppzYJRqFJqczvOsrhnP3sStJRgI+LMMdeAX5QFUInHLRxzk+Ssw27Caf4R/d7m/O0nOQ/eub8Jf7YyBXcUZPsnBXeI3uK3k+wtChApM74vGZc/+mIQqqiCnn4Q756uB8pmK3pyrzspOB+6fTI4WsDrYQ9NSXHXRIm4wtTehOhwTa+e62nrqOMbrW57R4y+2nJmM6O4OuviDfMdPhzxTLEZZTTM9aHYTYHrgCtit67sKI4MSV7oiZdW99xSvvHom3wXZaX/LWgg+ZLUpGFfUExN0+Swbo7wWQyHIftDtmYOlGBJdeg6yH5gSWlz3mHyW105UDoAVCcc21yQDtihfmxKYD4eqToiV+ocSnBGvS7cjQxByDut5/9TcrjVvyU+PXvHejcGWSgAmZ3mv9t/oIIab6Zk+NaC4xYKZ/v98zdC8VRIqU/4RkMs1iAeO+ydn7fvP0JyyR3NdcyyyEkzQtA/qGEFWGpCmraPB4oekhV/z54kdtejQv1o90POgHfSYo1T6pFvwy0ZQ3F1945fETqPCPjOBeqzkFDuCBBCAZ1KDmkTapajfMWBTgKCvdjFQtCdjxVdR1lzq+yTxrrizBiQDZWvML7DZjPzW7ZVIhFIx257It2aV0FWQ2MmvlwaHQS4OI4zmjvUr8bSFHq32EL1vMLy8G74U9nb1tEyFc06ZuD7zU9AN6KGEnKBsX3uAIRBA4eChcNseSwxRPmEuscgFiCYnhZXT2St
 UM529FKL
 A+J9sFdXDMYq8nyevqXZM8Q9uP0Up1ZDQAEmCHYHl0UUjPr84JeQxsCQigPjuqeQCGPy4uczXNOyOWhgq3amJeEQFS99CV8ZU+6fs1zN2aUYHMLsmzyzDs9QZAO+Prvzg4joLA6KquCnThlVYVR5Cx7NU4lYT+8juJmBzr0RY+lmLyTr7V8zbg6//c6CWYq+kSyYv8nugc1DbXY8w+QQq6BmE9AQej7QlEHF8UwctAOnxiJjN1aNqJMJo/do9psQMkxMCr6HdhsU+r3f6nee1rQgRZC9zF1fXP18LunKsVgZ20BTsDdK/fBqv1TBYTrBGUorWgY/jaRoIQCUIhs3uHgp+NrzEZHKfkiP8TuMFfveoNyDQ/cKYCeg44+yPj0Ruiz9zhM3W1XruBumptA16yWChRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 10 Oct 2026 21:22:33 -0400 Nickolai Zeldovich <nickolai@csail.mit.edu> wrote:

> The plist_requeue() shortcut inserted the node at the head of the list
> when the node was the first of the last priority bucket and had a
> successor of the same priority, with an earlier bucket present (fixed
> by "lib/plist: fix plist_requeue() corrupting order in the last
> bucket").  The CONFIG_DEBUG_PLIST self-test did not catch it: it only
> requeues nodes it has just added, which are always the last of their
> bucket, so plist_requeue() returned early every time, and
> plist_test_check() only verifies the links, not that the shortcut's
> insertion point is correct.
> 
> Add a deterministic case for the failing shape: A(1) B(2) C(2), requeue
> B.  plist_test_check() verifies the node_list and prio_list links and
> the ordering, and the new BUG_ON() checks that B ended up at the end of
> the list rather than in front of A.
> 
> Before the fix the case produces B(2) A(1) C(2) and the BUG_ON() fires;
> with the fix it produces A(1) C(2) B(2).  Verified with the three
> functions transcribed to a userspace harness driving this exact case
> against mainline (fails), the queued fix (passes) and the alternative
> fix I had posted (passes); lib/plist.o builds with CONFIG_DEBUG_PLIST=y
> (LLVM=1 ARCH=riscv).

Thanks.

>  Not booted.

err, it should be,  If this is wrong, we crash every kernel at boot.

> --- a/lib/plist.c
> +++ b/lib/plist.c
> @@ -283,6 +283,25 @@ static int  __init plist_test(void)
>  		plist_test_check(nr_expect);
>  	}
>  
> +	/*
> +	 * Requeue a node which is the first of the last priority run and has
> +	 * a successor of the same priority, with an earlier run present: the
> +	 * shortcut in plist_requeue() must append it at the end of the list,
> +	 * not in front of the first run.  The random test above never
> +	 * exercises this, since it only requeues nodes it has just added,
> +	 * which are always the last of their run.
> +	 */
> +	plist_head_init(&test_head);
> +	for (i = 0; i < 3; i++) {
> +		plist_node_init(test_node + i, i ? 2 : 1);
> +		plist_add(test_node + i, &test_head);
> +	}
> +	plist_test_requeue(test_node + 1);
> +	plist_test_check(3);
> +	BUG_ON(plist_last(&test_head) != test_node + 1);

No, let's not add a BUG_ON for some selftest.  Emit a loud warning and
proceed.  If it triggers, someone will report it.

> +	for (i = 0; i < 3; i++)
> +		plist_del(test_node + i, &test_head);
> +
>  	printk(KERN_DEBUG "end plist test\n");
>  
>  	/* Worst case test for plist_add() */

This goes in my for-7.4-rcX pile, so no hurry at all.




