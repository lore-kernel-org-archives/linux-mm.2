Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F02D8C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 02:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDFD66B08E0; Sun, 16 Aug 2026 22:42:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D90D66B08E1; Sun, 16 Aug 2026 22:42:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA9656B08E2; Sun, 16 Aug 2026 22:42:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A70DD6B08E0
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:42:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2582F8061B
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:42:18 +0000 (UTC)
X-FDA: 85109212356.05.D5AA39E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5A6AAC0004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:42:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CQShMVjj;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786934536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HZTCYCleUiU3YRCHIU5xkcgU6TcXz2UCAgTFRMqwvL4=;
	b=0sqMyz84DCPeagcWOtlZcbbcha+13rE/WTVfQNh8VJPma5XEoNrV6lLP+leEotcFGvkrtC
	vpSClCZKitj9qRGpQe5kaFBCcdcSMZApXahgrT7MGh8whl6BnjPUbknAbZlWQDRNQhzX+I
	0gmaznWluLHM6g0uH0hNp8+1KRH8B/M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CQShMVjj;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786934536;
	b=giQ5LWb4e7MX1APia8LFWOluHXdSQzBu/2zeA9C6CWMc8Yksn+nf9ZOIxhkAeKxhW0gdV4
	9WBX5ACG1ODjLQSPUHbOCVRnyXtPMlluywD6PpVk+yhMZku9d/1sjwMVAPmPu4ToSj2lZI
	ZDSymTsasHF0uFI6C7kivg4UUwSVGWc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 981EE4099A;
	Mon, 17 Aug 2026 02:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077DF1F000E9;
	Mon, 17 Aug 2026 02:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786934534;
	bh=HZTCYCleUiU3YRCHIU5xkcgU6TcXz2UCAgTFRMqwvL4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=CQShMVjjnI1IlYUmO0zNpP6fs6jQvF4hvVXe70zPGDgsR0gi4FCJ5g92ymEGRk1jU
	 tQ9aG6fAGeNMW7tH6ndqVegbvFRz1q1s3RIBPl/NJ/a3hr5b6Ma83WTqLgkqxodOoa
	 AffLXdw4vbc8OcrDBSACUUNAK7u42AlPD8C8uBPo=
Date: Sun, 16 Aug 2026 19:42:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Zi Yan" <ziy@nvidia.com>
Cc: "Alan Stern" <stern@rowland.harvard.edu>, "syzbot"
 <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
 <apopple@nvidia.com>, <byungchul@sk.com>, <david@kernel.org>,
 <gourry@gourry.net>, <joshua.hahnjy@gmail.com>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <matthew.brost@intel.com>, <rakie.kim@sk.com>,
 <syzkaller-bugs@googlegroups.com>, <ying.huang@linux.alibaba.com>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <linux-usb@vger.kernel.org>
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Message-Id: <20260816194213.0e813ed338144ebc81ed4050@linux-foundation.org>
In-Reply-To: <DKQU9SQUIKDR.2KEZZPONJ1IJ7@nvidia.com>
References: <6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com>
	<20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
	<DKQP5QC9XTDJ.3MI016NP0NPFY@nvidia.com>
	<02c2e5c7-0d78-4763-90ff-75fa87105fcb@rowland.harvard.edu>
	<DKQS9ADYVLN1.246LJPQ9QQYVP@nvidia.com>
	<9787b33b-b30e-4c5e-a0ee-7f14515c7166@rowland.harvard.edu>
	<DKQU9SQUIKDR.2KEZZPONJ1IJ7@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A6AAC0004
X-Rspamd-Server: rspam07
X-Stat-Signature: qfrk39a7xyxey3zf3dh3n9xifcwpy8in
X-HE-Tag: 1786934536-256534
X-HE-Meta: U2FsdGVkX18GsOZTX22lcOIf+ATydWzy2BaxVSaTYkaW5d2nofqZGjqhb8MZm/qAEBndddKMwRetbHPWY0bMWJrjyKiZLTeYRIUa9UWfs270DkiaBMFHVjt/pdL7+vKH073bo21RZfL7Nq72LHKm6uyO5MU6tRdkalRk1mtBrdexi5qB4MomVjJ9bC4uHuv8pQnapRQi0H/EyXLpJ9+PfBFkNMHrYNJ3atueCMqinHrbzNQH42oUZgF/5w4SgwHoeQ4O3hoV5WjCWvNHqzdS+HQgdTV+LLhg0d8/rpNDVvmulH5k+vSDPbaGgQ4ONPR+b0Qq/se1PJ9vjVfXl5rurPSCH6bylrmMGl26fAtL1kj8SayA0W2lNoMTgzZtujVS66mmOSeytz6G/EOpcLIQvMWRZ7GFtlnWf80N9i1lQb++qnDV6v+iue8NtVwC+wAtEKHhyYFhZc9DscdwXS/WQAe20ESy8k3jlw+yjnCoA2mE1o2UAIW8B3Oqf4vHa/c5uLP9K3nmHLAjEm29b1Dry/aGz1JNoe2tz0YReum8nQtb2fZQ4Lb+w2SL7fhBrl+h6TzTQrKm8npoGn6oXjcDXUSSc5kySy3BcJQFI2v1K7x0g4vpjpye6QOlMm+/bxpL+TYfSTafy0WsvTI/LYg56ctRGt01QVOf4tfN2/CJTGewjKq4QHH2w0toT4KYTPGkJ35FDl5dIaXzgxV7AHAjXI7LpvDnEfB4GytRvoz4ovI4/6QwYMrNt0h2S4MIFRPHA/OeldFw5a51tozoVdKAlfcmqjB+taiAYPrFQpSqsMWwB6ast3KNaDXxDKkunNwyJakMfGvgLn+W5nTe7xkv/AYIIlD8ACfXIA5EaFz6Y6GS0UwPDmnABfkmt47gQQI3JyKlXrwk2WBxb+e6Hi6IJbpJOFuuFMyDSmQkDnWuuHoq7rEpGPlEyvpBYdgKFNxTXlBbW7R01EgwJO+pxMI
 xxPU2f3k
 ANHVoQf7suhI4+lHHJHAkPOpxjhiUzpKSYcEv2StYNYH64DhOlEXZ5yMs8vcsYjyG0tbnExrbxeyyIu9VGj5oH1sszJ3DO5K3jbXimx3C7UnoW5FifZm5yTY6jGjSGS/+L15yqPHfIFsNQ+SDYEvPC5fj8QvHtQdkKOl4/7dxggRxoaoo6VUHatzNGP7IO8iG9Z7HLhVBiwZFYaj95+qK3RuapByWJKb41FLr/J2LoFoj4lIw1WvRc3CYmORcsBr4VHlYeJwKmShWYdFqEKODBN+moOBnBXjqZCuTASKo0/DwMSYmpaVLNPbnSBrHEaRtChmK8NZ2Mk3jnJz9WI221Axycl1ZUxR1GgzXGLyZCmC1vMsAhAlrDB0m73m1tb5JzRnphYjuLWFQ1wA9YV0vYChsX/dlAUeytoZxO0Xga773msAkvLd+71e0U/nBaCTbWe5j1A7DRoBrcW8P/TB5gzzlIVWgG/3awFGq3e+qTwmRV8xBnjPdcmR4cQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 16 Aug 2026 21:47:58 -0400 "Zi Yan" <ziy@nvidia.com> wrote:

> >
> >> > I prefer Andrew's first suggestion.  If the user asks the kernel to copy 
> >> > too much data, just fail -- with no warning.
> >> 
> >> __GFP_WARN gets rid of all other warnings, even if user asks for a
> >> reasonable size. Why use such a big hammer?
> >
> > Because on many systems, WARN causes the kernel to crash.  You don't 
> > want the entire system to crash just because the user asked for more 
> > memory than was available.
> 
> User asking for more memory that what is available is pretty common and
> should not trigger a WARN or crash, unless you have panic_on_oom set.

I assume Alan is referring to panic_on_warn.

Heaven knows how common panic_on_warn usage is.  Gemini tells me "There
is no exact global headcount or precise user metric for how many people
use panic_on_warn.  However, the setting is widely enabled across a few
billion Android devices and many cloud/server provider host kernels
where automated failover makes a full reboot preferable to running with
an unknown warning state".

So I do think that WARNs are more serious than we (mm developers) tend
to assume.

So we just shouldn't permit userspace to trivially trigger a
page-allocation WARN.  Especially if the caller is perfectly capable of
handling an ENOMEM allocation failure, as appears to be the case with
usb-gadget.

(Does usb-gadget actually get used by Android?  Surely not by cloud
providers!)

(Can this WARN be triggered by unprivileged userspace?  I didn't look,
this matters a lot).

> You can mmap a virtual address range bigger than your physical memory
> size plus your swap space and try to fault all pages in. That would
> cause OOM and the system should not crash.

Right.  As long as it doesn't trigger a WARN!




Perhaps we should revisit this.

Why are we emitting a WARN if an allocation fails, given that this will
often panic the kernel?  Should we on the core MM side dial that back
to a pr_warn() and a helpful backtrace?


