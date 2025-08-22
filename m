Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C334CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 18:00:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88D6E6B8003; Fri, 22 Aug 2025 14:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 864ED8E009D; Fri, 22 Aug 2025 14:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2366B8003; Fri, 22 Aug 2025 14:00:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 669528E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:00:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 255C01A02CF
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:00:31 +0000 (UTC)
X-FDA: 83805158262.18.B20F442
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6F68980016
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:00:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DM39cQLp;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755885629; a=rsa-sha256;
	cv=none;
	b=Ao09kMfBoRAh3beHtMHq/bmkQ1whjYnBkMuc+25ZDWx1zOY+tSsFL9VTmT9j6pe+hRDTfb
	AiWVIwLgxe7DoMiIgpyHNrc8/BROIDTnwjenW5PRr7ZQyE/uhtdS2sv/kW5AZI7DPzE+3H
	xfZcIEwtuLU3Cp3w2UhBf3HqmYHpknI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DM39cQLp;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755885629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KkEnuQKGJXZ1yxPD98pZwWtLLDRGdSZY3/lbdHtR8gA=;
	b=juf1vLaMw5BxtZs+rMGaiwxYnaWj5LgtB65W49gcpwzQf6twjGKBKrGaJOUaVk2M4ZeFS8
	jL+thr7vYZ68QyYgtmxPj/CkU9ian6LeLV+FSXhPqcsWmlLJny5+oKHV1CWgtTraFhHVrg
	lPmNlZCXggSVFuQ6Vuu89HlDB0sbwBA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 5B3065C4B8C;
	Fri, 22 Aug 2025 18:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31DCC4CEED;
	Fri, 22 Aug 2025 18:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755885628;
	bh=+5NIoRI3gqVex+BUi5UZsNV1yheEo0BfWMcN1z3yUSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DM39cQLpXocbfHciUQyB13E5+LoZ9yMqZwjosYd3WryN1bSmWKHUovDu9cWyHfmrZ
	 F1Vnabz9BnTGW1hhUyaEdKJGAEH/JHNDFVO/2xJ6bHe7k7JNMGtQU/HdqC/8tc2NIh
	 TfjsQPWZoKxnfk3PMB8skY6hApMiAut6WFn6x4ijyIv+GdwSLCGW1bS/Nwa2Yb5XI/
	 1f4F/uZyMLRpLbNT5QiYN14yRp5AaDFyRUGLJKozPOR6lgZ/KcRNK17zDkdZm5gqp/
	 WnRIpZnwGgmhKL0yXwRIV5dfJtRp/ScJ9ukg84R5/kWwSWhZfE3EMmlgOby7Cm9W94
	 kU8J+J+BAxlGA==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v4] mm/damon/core: set quota->charged_from to jiffies at first charge window
Date: Fri, 22 Aug 2025 11:00:12 -0700
Message-Id: <20250822180012.47379-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250822025057.1740854-1-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6F68980016
X-Stat-Signature: d6nghiyqm94upq1si71p9r58nhytej4m
X-Rspam-User: 
X-HE-Tag: 1755885629-131609
X-HE-Meta: U2FsdGVkX19zStWJ5TTXRZzqju2mv6cf7mMkuv/k85eONNkUccD+Nk8kYA1AXzQTNeGOB1vEca8LtOTQRMO2q0E7MuSQcfA1Rs2S3NysD6MJ6aoUmJ4mmOharDa2zd9QVqO4DZzdHvPZKpzbk6az0yNAFHcXLMPf6bDyS2K2jQ5ON9jw29nZmjvKacBaqGRkauCGf6X/L4iacn5XTT++0UOIMleh7sY9KtSggV/uwm7VQ8MovBJNAF04xiRAwgc491dJDElm3nDdNSaea44Uq44wp37H/6fewMoXzOSLLpVSUcrHngNoXP2AWslB+LcPIIuzX/t0IljsPDtv+6W/DYlZp7+66IDqv88yNRuNDAbUvyp7rpfyT0NjZpMk1LhKCoPGumX98xAe6Tb4EP/BSCA70JfhaMbOcVozqDxesSYoXoez8xgdACao9CNl9oYZzOGjDc9sLx6gHIfx6QcP2HjBIMn6P2Xug9bI9heaqqU4W+LfJ17N5Gt88w53g+j8SVHZrx9VjP06VL2DYghQ0qFluJVr2oEJy5VqCJgzVCNMYCi1tulSGn7bJS/vEzE+zP0rgN6/3anZSsp7CZcNF7s/KxjvfVmPf6jtzuqmKzs7ihqpYHpE6hO43i/6Vz8Pm0WCHvll2FQpjlCMbYwFvZcToQEgxPp9/D0/PDK0F/F/XoP6IOs/zji/ciVY23jyCSFUX3Ap0XdHQPrnXG60vdkc3E8dEOW2Bw0l3UL4IUlzL50tKKcYRSvmbmpgEfkl50OJM+6tCpRC122Dfg0Uxrrf5XeH3QNWRJVGNtWfw2P8pmxyifAvjIm7FrVE5MgxbUwKTfsPvnnYyToAx9GGAMO/o2DoW4ZK6F9d2gTVdq7VXzRr4og8J4nqmP33xV27IaWJbMSqN/Kp2k7cUVW4doX0mh6Uo58HnQrg4koh8QNnE5OUORu1kpuh+xLeT8wZVfYlBUsgalPNggYB1ib
 hHuvLVsU
 CTRJrGH82cacXFIxo6wCMsFBi6E8DgIqHX8181KdRgsryX/JeIyqyX0q/kWGCn/kfSVKTXmbDXC/mZ+i8didIKH6B66XrFIwU87eMqK7vJtzAwITLrSppiftmjcnMB41RTRfQMgnErTJENqyTtZmvsVXzaEp+4GLanyNRg+McZN0e9DfJ8an6SlUkMIQ+nTNcyD/Q24LsOKWQQBoVLYHXWH/gGaVLSkaKsQ94J1VVB3MljKi1u5n02HLWef3DFPYR/O2gWm7QXHtyIbf2ogvP74t+or2OpikwafHi95oHxOdyAls=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 Aug 2025 11:50:57 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Kernel initialize "jiffies" timer as 5 minutes below zero, as shown in
> include/linux/jiffies.h
> 
>  /*
>  * Have the 32 bit jiffies value wrap 5 minutes after boot
>  * so jiffies wrap bugs show up earlier.
>  */
>  #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
> 
> And jiffies comparison help functions cast unsigned value to signed to
> cover wraparound
> 
>  #define time_after_eq(a,b) \
>   (typecheck(unsigned long, a) && \
>   typecheck(unsigned long, b) && \
>   ((long)((a) - (b)) >= 0))
> 
> When quota->charged_from is initialized to 0, time_after_eq() can 
> incorrectly return FALSE even after reset_interval has elapsed.
> This occurs when (jiffies - reset_interval) produces a value with MSB=1, 
> which is interpreted as negative in signed arithmetic.
> 
> This issue primarily affects 32-bit systems because:
> On 64-bit systems: MSB=1 values occur after ~292 million years from boot
> (assuming HZ=1000), almost impossible.
> 
> On 32-bit systems: MSB=1 values occur during the first 5 minutes after 
> boot, and the second half of every jiffies wraparound cycle, starting
> from day 25 (assuming HZ=1000)
> 
> When above unexpected FALSE return from time_after_eq() occurs, the
> charging window will not reset. The user impact depends on esz value
> at that time.
> 
> If esz is 0, scheme ignores configured quotas and runs without any
> limits.
> 
> If esz is not 0, scheme stops working once the quota is exhausted. It
> remains until the charging window finally resets.
> 
> So, change quota->charged_from to jiffies at damos_adjust_quota() when
> it is considered as the first charge window. By this change, we can avoid
> unexpected FALSE return from time_after_eq()
> 
> Fixes: 2b8a248d5873 ("mm/damon/schemes: implement size quota for schemes application speed control") # 5.16
> Cc: stable@vger.kernel.org
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
> Changes from v3 [3]
> - fix checkpatch script errors

Thank you for doing this, Sang-Heon!


Thanks,
SJ

[...]

