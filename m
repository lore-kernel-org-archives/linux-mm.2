Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9C5EC982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 00:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B31B96B0092; Wed, 16 Sep 2026 20:59:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE3786B0093; Wed, 16 Sep 2026 20:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F8656B0095; Wed, 16 Sep 2026 20:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 811F16B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 20:59:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 347541601D0
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:59:42 +0000 (UTC)
X-FDA: 85221446604.23.5687109
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 763FD40007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:59:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Jr0ZAE3l;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789606780;
	b=Hb4MT/aq+bh5hv64hAhzcUPXUXGwNSlToRxI+YKkWeutXjPuaGjW7wso98UZEQ/qM5QW8l
	WuOf3R779E3gSri5ReZCjDIFttd2VuA0ESrAwV7H5zvmKw+d0kikWhIbwqNF8bcowR/vnu
	WVW827rBBTU5tICew+0/dCgns41riVE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Jr0ZAE3l;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789606780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m18M9q0iDPw/ZXWMaKyREc8QRrR725skItcYr3dWbPE=;
	b=f0vQN35lmbgMKZAJ+Uw9i9SrEy/TB0120woTn0OhMOrttEwm++yJGlzrYVF2UynL0dSK0V
	ugfFRDVIKSxJ2LgW5hxRR9m+/Gw7XpwmMAC0m9+mXqQGzl18njYLCbT1UrvlqX365KqUGw
	N4kJvfcwIBEr0UkunzuqKzhMRq24KQw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E388E601EF;
	Thu, 17 Sep 2026 00:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777D81F000FF;
	Thu, 17 Sep 2026 00:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789606779;
	bh=m18M9q0iDPw/ZXWMaKyREc8QRrR725skItcYr3dWbPE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Jr0ZAE3le5lu5f6Eg2cxs2J4xWqUi10TE7oiSypYZJImDK1S/fsERFeuHgEdRPvj3
	 FJRAxip/J7XyO9Ff20cjHRz7xtg01De/TKLQSJVfLf+csWT/S58O0kc/C7D0mmC0E2
	 4bKYS73q3Dqb3tvewS4b0WO5GA9cyGFPFFGnm+JI=
Date: Wed, 16 Sep 2026 17:59:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ye Liu <liuye@kylinos.cn>
Subject: Re: [PATCH 0/3] mm/vmalloc: fix vmalloc_dump_obj VA lookup
Message-Id: <20260916175939.01ecf1e866621427b7f09f21@linux-foundation.org>
In-Reply-To: <20260916-vmalloc_dump_obj-v1-0-7aa402d224df@linux.dev>
References: <20260916-vmalloc_dump_obj-v1-0-7aa402d224df@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 763FD40007
X-Stat-Signature: b4zo9zjrk8sx3sexzno7crgauwy4idm6
X-HE-Tag: 1789606780-84596
X-HE-Meta: U2FsdGVkX196ncr0wPRXVAq9rBDXE50p+GVbNfP3rbzx15eCHztqw4I3bMwdPoPdJ9CxBrVPAqDANr08dwhJ5NvoKD8x8h5l6QLmBXjKrunUsu2dfwTGsM6LduXyj4+5nSf9ibtWHI7TRu+IiPyH1rGqqw3gpvz92ioh3Wf2jMZIvQpHdCMzEFZdiP7Ybe0lqOnRFvfbZ96kRP1R1AXGmTBls3qCcAIb0tGYJ4GJs53Hpab63jDL+k6qMYrTx1ujw+s4zUOcBJ97WQweTHyLcFGZr/Ok4g4jDEL0hmzkiGsNHowSkmNvNqOdmQJ2N0eSrIv3b/92unI7tlyEtebhaBpeb3uDKYC6cp7lWwANpOAaWqJTRj9wDTQJtnmvG8E/wTKiOjq/cN8vCDUFSJryWRsJxkxi3alHXkTMQxBaNX/TeSFgp7rgc1tX8wAoihM0XapdY1I81TnDUBE4LnO+f1I4VEftfICtOUnAH6Cffmyhc6SBHtlmpGm1bO44yowcQ47tRgIvwCJKKEDYFw+Y/thOECfdcQikazWydnvnZym7vaswdEi4eBwzw6GkHnZPXaBfAh/gfq95+9tM4PdewXmW6YWJ33rYBO5NY8clfbdh5BPrjeGW27hs8kpOCaspK9HoK91+DOJgxX7dL9Ohj9pJa7c4XlDqHBSX4j/gQwiLs8ECb2VcoxbtO4c4RM1uoWgzLPPWQ1iubu9mmWQuvrP3V1/rYtgxSyjj+zBVMa/3bFrFhdq5neM67OegzRjqhI2Z0fvPANKybtf2AVO6MlmgEJ1s1Jykt9paToUcB/sDAjd5N+EihVDKffp+ocW2KCVaDdHxjbIgNmEE2aYHhZKmeTFooY6529CxpvljodtxKBglSUSnY+ThbrCa+Axhxa5vcGcyeg4K+npwwvUbaGM08fiQ199sAtQDwKmYPCH8Uznv5t9HB/BK5FUFaZO5tHBmtAjudAVGSCO3ILL
 Uh0OTPy7
 8UBnqQwL5GwUBOQ4+jO/3tLetYGd/ZgJu6k5m29MnlnJGNJUtWgdCSLCFUHzX2Ap3PDtVp/vdtykAhlp2l4howNvYB/YVwQC5ZWzCCznxz5tUjJY9luqfmU0mmudgthZ/gTh3mvALWZXr+jhv1ubY87mdEE3J52wabKoYXgXOcE2alPiROsK9JBWIrTRQG2nyymuDOjfhZRAEurdgvdNb6Pjcg/DNV2dcbWrwFcdYVZa0utZvf02brtXwe5Z8WGE8jVdddByZOkMqfQA7Uxe+hywRjLpgytY1CoyXvSej7oecQ7+PER02CIaDZQ2aORETE5uO8rAsFo+AiQUkTzfgIWfR6G6s0PvI6djd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026 16:25:27 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> vmalloc_dump_obj() has two bugs that cause it to miss vmalloc
> allocations, plus a minor optimization opportunity:
> 
>   1. PAGE_ALIGN() rounds up, pushing last-page addresses to va_end
>      and outside the VA lookup range.
> 
>   2. The function searches only one vmap node, but allocations
>      larger than 64 KiB may span multiple vmap zones whose VA
>      is stored in a different node's rb-tree.
> 
> Patch 1 fixes the alignment, patch 2 fixes the cross-zone search,
> patch 3 adds an early is_vmalloc_addr() check to skip non-vmalloc
> addresses without traversing all nodes.
> 

Thanks.  Sashiko asked a thing:
	https://sashiko.dev/#/patchset/20260916-vmalloc_dump_obj-v1-0-7aa402d224df@linux.dev

