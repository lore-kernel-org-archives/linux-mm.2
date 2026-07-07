Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 461C2C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 374906B00A4; Tue,  7 Jul 2026 09:20:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 352226B00A5; Tue,  7 Jul 2026 09:20:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 265446B00A6; Tue,  7 Jul 2026 09:20:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 022E46B00A4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:20:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6459912043D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:20:32 +0000 (UTC)
X-FDA: 84962039904.01.75636E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BD2A1180017
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:20:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WcsyS1rN;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783430430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ThonobVbutjdpxgi4zCNaSyVPNB4espWFRa4yco1WyI=;
	b=t7CoX99w3kl14cQCwJsHXQTqVH7lVs4Ei7phiPvJbt2OfqM2a76VEEbLTbYTdL5MngZ65K
	QKAQFEh2oV0ER9slL6dSp5Qhd0nZS59e/pK+xOCtC6bT2XeffLWNmELi8h+39kl9siok/6
	wLqSE4aRGEXTSlETc+5m/dx1+s0y0q0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783430430;
	b=qIUaCiQ3DXMf9i80rhQHIg7XTvTgaOwczCKHaqYDv2A+v8H8rKE0knk/7999P/Rv7WGOSe
	cPRWsXJ66ZWcfRThKsJm+mMQtEhytE+/J4OIXIA2f17efV0awILr8BjLCS7DkXJPr57Kj4
	6uuejOkPlFC/qIwptqSFJTF57YanW8k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WcsyS1rN;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E212D40711;
	Tue,  7 Jul 2026 13:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289511F000E9;
	Tue,  7 Jul 2026 13:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783430429;
	bh=ThonobVbutjdpxgi4zCNaSyVPNB4espWFRa4yco1WyI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WcsyS1rNE6zpcJVBcO6MxkNMQ+nR+95qJS5iXV1kQ5CxwF2mZYtdDYpZTej7gCmS9
	 4qI533fxLYj4yayOmzWhL2+jhmX+KXpWvHuB1qF3Hnd8pM4Kh1/S6+JU/JzEsYq4j2
	 ptzrWG7Mkr9iVH/adrDExEHfHN6+/itICaG2k9BIHYfd/m2/zYEt4H84kX9Jw1tDHc
	 cpYnwRUMn1wFSAlKAefI9Z+htPe5TaMjG763Xuacmc84aH2TwLV5NqC49Nt+Yq+C7B
	 uF2/D3NeP2p4B7kSKotFUyELmyRYpDmb6sba+EYTl2L6jZ/J78cLQYnYcm20RYtxdb
	 UvBxkn0uXde9g==
Date: Tue, 7 Jul 2026 14:20:19 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: linux@armlinux.org.uk, akpm@linux-foundation.org, david@kernel.org, 
	liam@infradead.org, liaohua4@huawei.com, lilinjie8@huawei.com, linusw@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@suse.com, rppt@kernel.org, sunnanyong@huawei.com, surenb@google.com, 
	vbabka@kernel.org, xiqi2@huawei.com
Subject: Re: [PATCH v3 1/2] ARM: mm: fix use-after-free in __do_user_fault()
 under CONFIG_DEBUG_USER
Message-ID: <akz8aZUW23rpyrLO@lucifer>
References: <akzpuerKqOY7qfFi@shell.armlinux.org.uk>
 <20260707131409.79043-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707131409.79043-1-xieyuanbin1@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BD2A1180017
X-Stat-Signature: j4j6eq9pnzh76moi83me3r9d1cpihjqq
X-HE-Tag: 1783430430-641101
X-HE-Meta: U2FsdGVkX194P22mhcGnupBXM34xKE0W93Ut8BhBSDTKpZmiUyTAtIGVWX2FMToACx/UtTWx8ohn+KMZ1Pdt4HwRc/PYUYnPx3oV9XFlzd2K9Q2RN+fya1QYI+VCNGJMYNKse6BpYXKjtV5kLBK9EKHQw8O6vtUJzKpG5BPTtPp5Va2hTj9AcseTLG1lFJ2kj8h2b7KTO9RId3fU/WktQz3DaW3NDgwJ2CSoOKrHZg5UZUbXrO9bwtcVqntFqZazHXD3677y1smc8yd4tSu6uyv6D6hXJvYfj4QmuYEjIukblrmB0OrcFH4Gxdn1dbgYfk1EHZWp7sVDPbiDbqoF1WVp4VOByGxIu68V4FvlwCQqkA96KemeT5wqWpVT0sT12NdjgQ2fMQjWUgj65pxGcN+cJbfkT9C4bA/wNSLKJgPtiplooGd03cOEbTDrrFIiBGC3U58HP0ah8zf3vCMOik/OS1+6iipXgY5SrUDfWkauKhemUXtmG81YJxbmebhLXDkhPgI5WJwLtJab4SvqdOBlw1umuBQsZh8UCYAQo0zsCtXNuRsr7hG8Sd5sMz5bDksfz1PPs8hCZnqiM+3wCg8AGIZyfDa7aMSel63tiWqXSxUmZ6YLOcJS/xmUnqXpF4/XqfN2/vwjoGb+FnyVDudZ7BjVWaMv7eX9eXsmbIZlqmMc5cc6CTksGR0PAHySmQdjAaJRh2XMyR8t4KGIROoNFUB5FWc/+s3aRFCSV5HFK4q/1uM7JClu5jlIeL3JlQ6npbJfZ4XHniCfSx4N9WYIY+g0xUOXbrLqu0qtNFH4teOf7GweLJyV7X6ummc12Hbvf16zoKYRCiP/jytT7SygLrGvBTOa/Qu1nM98ONSloBVvzX8zZxKWvPmzPKEW1BriUii1snktXH4BwiiRMwIqxAMJ8SYq9F9nRr+K8pSCOuR/i0/yh7NEn0/juuXYsmlzt/S12d2EBNu+FLD
 zDEe3uDf
 hb7fOWm8dOhpVq7mJZ/4a5vFInTKLsU1140g+lVSIO3CRvjS1NXwCgutqcCf3ZRabuV9cW8ue2C9Uvn6Sipa7SvY/5mt3YJh3cGhOgtFy4B29r1u2qlDwEl/fb4YejkvF0UKzQE2laY/vS5REOcKyRlzKI0X1emKOQGk5rVObmnx2DV/sHDzIf9DrhaBLNnjhOs0mNMdbxOukSiZb/G8Wi9GSyKjvEJwrcG0vo40excIcyEj2Lb4TQtm9jDJP6c0oh1ywSaJwxNcAKXqOgt18rByq1fLAJfKuvzoOfojFAJOBjgo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 09:14:09PM +0800, Xie Yuanbin wrote:
> On Tue, 7 Jul 2026 12:57:45 +0100, Russell King wrote:
> > No. This information is useful debug for kernel oops.
>
> For kernel oops, I think it should be `!user_mode(regs)`, Qi Xi's reply:
>
> On Tue, 7 Jul 2026 19:48:12 +0800, Qi Xi wrote:
> > For do_DataAbort() fallback:
> >
> >	if (user_mode(regs)) {
> >		if (addr < TASK_SIZE) {
> >			mmap_read_lock(current->mm);
> >			show_pte(KERN_ALERT, current->mm, addr);
> >			mmap_read_unlock(current->mm);
> >		}
> >	} else {
> >		show_pte(KERN_ALERT, current->mm, addr);
> >	}
>
> changes nothing to kernel oops. It only skip show_pte() for user-mode
> faults, and the fault addr is a kernel address, which means a user
> program is trying to access a kernel address.
> I think it is reasonable to skip show_pte() in this case?

Well the whole reason you're faulting here might be because a userland process
did that right? The page tables should tell you (presumably on ARM32 :)

And I hate to repeat myself, maybe you didn't read the whole thread but... just
use mmap_write_lock(), this isn't necessary?

What is this trying to achieve?

You're not in a hotpath, why are you bothering to conditionally take/not take
the lock?

Thanks, Lorenzo

