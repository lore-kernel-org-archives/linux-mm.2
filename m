Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FC47EE6B4D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 20:11:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 498BC6B0089; Fri,  6 Feb 2026 15:11:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 446DC6B0092; Fri,  6 Feb 2026 15:11:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3455E6B0093; Fri,  6 Feb 2026 15:11:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1EA6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:11:58 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B96AC8B150
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 20:11:57 +0000 (UTC)
X-FDA: 84415127874.30.B725C10
Received: from relay.hostedemail.com (unirelay08 [10.200.18.71])
	by imf23.hostedemail.com (Postfix) with ESMTP id B6C9D140008
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 20:11:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770408715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mom4FxigxUqgxHxI6Kp9ws79L6QLBt12tfLMkhAQPhM=;
	b=2R2SIqNgZYVzltrIrgabEqyENtWZa0G4aZlwM6c3nOvnQR1fkuzzvyrRfoNo3mgdtewdRd
	BZNKjOd+YabSf/qnaj3x2ie9VKMXtpzWiANlaSMn30E497JmQRcCEDXoNZ4wFWG+2KW+WZ
	bgEm0kEKhWKTgHaYQYNz5OSJz/8XsbM=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770408715; a=rsa-sha256;
	cv=pass;
	b=YkfepXbtsLN0IFJFQOKRh1va+yD7l3a5HIXV7rAelboF3eZb4pk1hIhAJPkhbjxZHpzS2Y
	EwAYyqEVyCzRx1wK7XIGwOODP5sM7Y2wZixOgs9gQWF3ufJTFj8BTPtzhl6R6NsIs+EMJ6
	orFIN60jLKL4BVnp1JGIjA6heotycv0=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4561B140321
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 20:11:55 +0000 (UTC)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1588E1A02D7
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 20:11:55 +0000 (UTC)
X-FDA: 84415127790.26.C1BFC2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 55FE4A0008
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 20:11:53 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770408713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mom4FxigxUqgxHxI6Kp9ws79L6QLBt12tfLMkhAQPhM=;
	b=kncY76J/QB4kmkGq3cJHP1J7iH7eiK4mQeHzF9gq6Xo/qexkbsn8T7ApVwoug3kgQ8X1jF
	fYqUQ28XsAzL4OIJHd8yXbkrVxEDQ81f/3H0a3k9jm//hWRRtpUc/OPJQlJw6XlyHUv5z9
	Lv7aLNzUmaJrlJplCKq4Kz8v1/An5T8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=z+sCdjyQ;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770408713; a=rsa-sha256;
	cv=none;
	b=tqM7ZLgO3x/RcYc/AeJCUn6F73u1I0aTQXRYsincm/tLT+RXVO6GeZ1hqd4FfM51ji9OJz
	DqXo9PoLK1I7OyYp7ie4grjkVhRLusbLPVE5lpfz9Qimg27rih9P19bxZVc0CJFBCnDfyw
	p+ySey3e31wEgGA2NSVreFHahUlIUKk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 157FB401F2;
	Fri,  6 Feb 2026 20:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF525C116C6;
	Fri,  6 Feb 2026 20:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770408711;
	bh=8mYM8u1acZ5xGe1Ak0y+3i5xy3haa0EvTTtCBilST0U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=z+sCdjyQIdGmSGapZlqU23+BnFvm+eBV19oig3SG1wvDSaouD5eAGZqVmGAurEB0z
	 kT0664BuT7Vdxd4kEZ1SXzRFtkzLQZurOoFzWGRAyzW5G284lPcuAgEQ535Lv4Wmey
	 Bq/PxNalbxIcQTIC0/7boFsZfpuxvaUZa15Ix8Hc=
Date: Fri, 6 Feb 2026 12:11:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: carstengrohmann@gmx.de
Cc: bugzilla-daemon@kernel.org, Kairui Song <kasong@tencent.com>, Baoquan He
 <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed
 <yosryahmed@google.com>, linux-mm@kvack.org
Subject: Re: [Bug 221055] New: Hibernate image write 10x slower since commit
 0ff67f990bd4 ("mm,  swap: remove swap slot cache")
Message-Id: <20260206121151.dea3633d1f0ded7bbf49c22e@linux-foundation.org>
In-Reply-To: <bug-221055-27@https.bugzilla.kernel.org/>
References: <bug-221055-27@https.bugzilla.kernel.org/>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-HE-Meta: U2FsdGVkX1820Ie0vkXrCLFeeVwS+PuZyJL8sy2OGfFH6Xz7gsskYj2vYztZn++Dd/KFrO373Pv9AKMfJ/0Y5OxUtxc60/hrS0N1odPlw8lpjXA8J3yazlHXOE87dEzN8PDzTn2VpKzhsERpWWFi+ED6e3WDHz7wX0K5iKuQTlNgDGl38V7VVIO5QcFrG2QiDzQPOxptbvCadc3zkfpEhB4xm75P1js++cnyLuYGnJgLmcC7K9aCl7QML80jaqh0VWkSWhmlFP7+2YzDBKlhWs4bc1XSLj5Z+1raEcK9UQoOwGWpzUcmGhGdNireAityRMnjKmQ7LWgG8mX3CB1oUxjeWJJkheyIW+Rs2gX1vRsT4LbdkMhMAPor6CAvEBfJnHRwtaiPcyrwechlQlieUysrwsq1ICPx6O2Eg9IMuK4aFe8MAZwagArbkn9FrE9RDDy7SRSK0STXKE0qB468cfl7XAB8Y2JTnYMMacmzEflQ5nwQNS1cO/HoXjSP/H2ZxsygVpiCtrVSg1mk+8wJgdkdzsWs+Lz1o9FOYT0VkoSYsElytK8k4a2Y+XFzDQtXWzjpL7ZcCxdVub7+HXL5zMaAgJ2QSjVQm904VzTDbM3rsazh6M/dgucyJXi3xDUR/McyxbfKq6sdH/1VhJ9gBN3m6+pfVSZzkZ6+5otLDZwzG0j9Kcx8iCYufcQSPBCh5KG4Qb/KlhJodT8SpmqrOYLdWQ5+FNM6cyTQ8He5HYvaPH24MjpVhxS8K/vXYivFC5ll2s/px2UhTKTYyGFW8tfzMkTex0JN73CE+20U3eqixgLmdMGqxKcmvxQ9oRW/2H9dwjBCZVAzdc+wH6FzkReUexbSUHPqoRXhlfAcEWtS14jowZkArniwvVpTa8Lgnsque1Wtc7TJ9wf85gPZzfc9YTYtr+vnwkEucqyzDpU=
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B6C9D140008
X-Stat-Signature: 5refud5zyfgjec57qa6n83aiws6w3djs
X-Rspam-User: 
X-HE-Tag-Orig: 1770408713-649919
X-HE-Tag: 1770408715-186357
X-HE-Meta: U2FsdGVkX1/L5PZPV+PArYx/+PK0G6RW2p8OA/czuUtmlqbYt+9z8uRKzzpZcuFlMfcxWvBGL5b2QWkckRkJPsh452kDxUoO+K77zdZDbsrXnTSmNCP85mLXeHwCtPDfvVgrWp5/ET/ILz0hutr3tCb4hc780VjG1nPKnyx7yCGCBUbsyj4JUjAq+3rUvAGSAOVKLgHmxBa6fNTPN/v8vYKP0nQG0tdMaPGmO6x5zZQPz/Q7Pa8X+cX934PTf7chKANgOiJIz+txD+X6jp60FqPYuolgiBgEXH/y2HTyNVLFhid1hdffSAvGO+CdWod7+33Or3+PtmoJ121elWLHMm2jEOia1puouml5P/elusMeXLurr/aPs+22JhoBSin/2XTnCQUKduaty9OfXtLQKvF98BC/+sG347TPhI8a2hXtbc4b0zcScDq9svN0O31nVWDll+1Ia69aZi0eM7Bcr+pJnIW9heKna7v3LqSYpCF36hnbVSFUpP9v1t7nCWRzNIOjBzSoIW5lddFttnDwgt3B2LREZC0BuaS2WZL30uGBlIMP4W2s85i0+Gy7hegseRwj1OygC7zFqhOo++P7IhuIJe7jE6l1tdlqRhC9aOiBZcM7TYGgJxjW8AdUtuu7TWkC7MuLTRNjQHU5u0fyf84AiSSr4yIa4HyfmPAv8GPnA2cyVaQQQzHBHXzTbl5Xv+B56LEm8z495zvQwpCdDG5zKHqlTUODADJxi4jfMGZs0LHz1RgANhyGkwXFMSvWEQDc2CdtSgBm1ULERFkF2zt3vqv5SbYNlexWOksWVnmmXhvXXgU+TY5E5TcfRVgBqjv/C6kIat2Y6QRK2sxEjo6BEQ/q1cEzt68P7RQiDUAIOTNPNX0G9OiTzdjPTbKeO2MTjvzjGmhguiSudItjvDIR8plvDcsdhq0mrlh9VRancGLGDWg7wgFZJHVBW8sYFVnujjNSvTLFSb//S6u
 kor2CVHV
 xwFEC3UV3sd712NGtP7P0Z5GW108FqRaEcGEgTEXzeRQRMjJ0yj0hDR7W+XLkIZjlqE2gX4dIMWkgFDZBJeLGfeRUBhmCjILl8kRN2MHp09CUqrbqFYml7yaz7U9OBxZAIWeXM31x9vYoA7WazacGjWUzYsPztBmA1EfucyipCsjptApmCBEQ+KRfk2v143oeusFPEKdKwxoDPeI+FCLytFb1/G7Jb6KX0WrKqecOt2xgzcklSnHVAcCixI0eyq4cweE63Y8rVWsJTik=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 06 Feb 2026 19:51:38 +0000 bugzilla-daemon@kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=221055

Dear Deity, I do wish kernel MM bugzilla would just go away.  Sigh.

Canned response follows:

(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).


>             Bug ID: 221055
>            Summary: Hibernate image write 10x slower since commit
>                     0ff67f990bd4 ("mm,  swap: remove swap slot cache")
>            Product: Memory Management
>            Version: 2.5
>           Hardware: All
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: Other
>           Assignee: akpm@linux-foundation.org
>           Reporter: carstengrohmann@gmx.de
>         Regression: No
> 
> === Summary ===
> 
> Hibernate image write 10x slower since commit 0ff67f990bd4 ("mm, 
> swap: remove swap slot cache")

Thanks for all the work you put into this.

> === Description ===
> 
> Since kernel 6.15, writing the hibernate image to swap has become
> approximately 10x slower. The regression was introduced by commit
> 0ff67f990bd45726e0d9e91111d998e7a3595b32 ("mm, swap: remove swap slot
> cache") authored by Kairui Song and merged by Andrew Morton.
> 
> === Performance Data ===
> 
>                  Before (6.14)   After (6.15+)
> Hibernate        28-32 seconds   290-342 seconds
> Effective rate   ~60 MB/s        ~4.5 MB/s
> 
> The swap partition's raw sequential write speed (measured with dd)
> is 255-450 MB/s, confirming the hardware is not the bottleneck.
> 
> === Bisect Result ===
> 
> A full git bisect on the vanilla kernel repository
> (git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git)
> between v6.14 (good) and v6.15 (bad) with 14 iterations
> consistently identified this commit:
> 
>   # first bad commit: [0ff67f990bd45726e0d9e91111d998e7a3595b32]
>   #   mm, swap: remove swap slot cache
> 
> The parent commit 1b7e90020eb7 ("mm, swap: use percpu cluster as
> allocation fast path") is fast (28s), while 0ff67f990bd4 itself
> is slow (307s).
> 
> === Kernel Version Tests ===
> 
>   Kernel              Duration   Result
>   6.12.1-arch1-1      32 sec     OK
>   6.13.1-arch1-1      42 sec     OK
>   6.14.1-arch1-1      32 sec     OK
>   6.15.1-arch1-1     302 sec     SLOW
>   6.18.1-arch1-1     290 sec     SLOW
> 
> === Reproduction ===
> 
> 1. System with swap partition (not swap file)
> 2. Boot kernel >= 6.15
> 3. Run: echo reboot > /sys/power/disk
> 4. Run: echo 1 > /sys/power/pm_print_times
> 5. Run: date; echo disk > /sys/power/state; date
> 6. Compare hibernate duration with kernel <= 6.14
> 
> For best visibility of the issue, use hibernate=nocompress as
> kernel parameter to disable image compression.
> 
> === Hardware ===
> 
> - CPU: Intel Core (Ivy Bridge)
> - RAM: 16 GB
> - SSD: Samsung SSD 830 Series (SATA II, 3.0 Gbps)
> - Swap: 20 GB partition (/dev/sda2)
> - Arch Linux x86_64
> 
> === Kernel Log (6.18, with hibernate=nocompress) ===
> 
>   PM: hibernation: hibernation entry
>   PM: hibernation: Preallocating image memory
>   PM: hibernation: Allocated 2217260 kbytes in 0.39 seconds (5685.28 MB/s)
>   PM: hibernation: Creating image:
>   PM: hibernation: Need to copy 506945 pages
>   PM: hibernation: Wrote 1794356 kbytes in 397.97 seconds (4.51 MB/s)
> 
> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are the assignee for the bug.


