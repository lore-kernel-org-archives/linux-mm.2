Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37653C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 15:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5769E6B02AE; Mon, 17 Aug 2026 11:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 527616B0661; Mon, 17 Aug 2026 11:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EE906B0826; Mon, 17 Aug 2026 11:06:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0BE926B02AE
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:06:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8A1A7160784
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:06:32 +0000 (UTC)
X-FDA: 85111087824.18.0C9800E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id ACAF118000F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:06:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=isZd5Nbo;
	spf=pass (imf24.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786979190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=htBZK+/e+FmhBk0msQ5WNa9+9hWof0l6pn5iLqOk5Ik=;
	b=kKNCmp6Rh5i/l+1yyMOd362nLpc1vEbwpn4aL/GoYd/MSrzH0ZjgY8FL5KX34ceGy6FbDa
	155xjHvcnM4YidsDgpw8qFUTH6RoSX3ft70pEKG/Rw3E5Ycy9SVO9kxDPs9rcrpZVJNEd7
	1jbB37GgdGHS0QpFLyOJylPw03mCNtw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=isZd5Nbo;
	spf=pass (imf24.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786979190;
	b=f1UkpHvp+tW0KEiVIncz3vnJMLzs5dyLCsDKhhXA05QRi388ThQlKRWJ2EDAW6AlTO+SNp
	BzwMZnkfq4MrGJgNZKp6OrzgtZImn7zVbDYp08BwwbEysU/msf0wl+DPm6i8TaAhRpNV3d
	OGnhpfWMlq0jyEfdTVo8ZurAvjLDQBA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1AE6140130;
	Mon, 17 Aug 2026 15:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9CC1F000E9;
	Mon, 17 Aug 2026 15:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979189;
	bh=htBZK+/e+FmhBk0msQ5WNa9+9hWof0l6pn5iLqOk5Ik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=isZd5NboYbWJoU3x/9sedVKgBjPitdEST8EQDu3relYKPFz72YZ23AAREzTURngEU
	 2yUEefMYB99kQD2X9oNzrUxkmYoP9ffzYLGnGms/VE3OtHJHyp8bR6Bfv6jtzyVdd6
	 FL3NDlxl2Sc+ti1WdM4iWxfWleAvFFjcpH9U+jYo=
Date: Mon, 17 Aug 2026 17:06:25 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
	apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
	gourry@gourry.net, joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	matthew.brost@intel.com, rakie.kim@sk.com,
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
	linux-usb@vger.kernel.org
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Message-ID: <2026081745-unshaken-retread-d744@gregkh>
References: <6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com>
 <20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
 <DKQP5QC9XTDJ.3MI016NP0NPFY@nvidia.com>
 <02c2e5c7-0d78-4763-90ff-75fa87105fcb@rowland.harvard.edu>
 <DKQS9ADYVLN1.246LJPQ9QQYVP@nvidia.com>
 <9787b33b-b30e-4c5e-a0ee-7f14515c7166@rowland.harvard.edu>
 <DKQU9SQUIKDR.2KEZZPONJ1IJ7@nvidia.com>
 <20260816194213.0e813ed338144ebc81ed4050@linux-foundation.org>
 <472add4b-f16a-4b87-bbc3-98c8aa385cf5@rowland.harvard.edu>
 <EDCC14FA-F7D8-4F72-B780-37D09E26D16C@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <EDCC14FA-F7D8-4F72-B780-37D09E26D16C@nvidia.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ACAF118000F
X-Stat-Signature: s6sk861ro78wmrythrftnhoi4uhykc8w
X-Rspam-User: 
X-HE-Tag: 1786979190-839214
X-HE-Meta: U2FsdGVkX1+FQSs/R+KtXCci/dYzPrX86egCHrjim65xw9DHDh3YiHSDpy/NqbO206T0EU/4RlSSE9TyIFKNmDANhDDnZlUDh80u0O66TOTGhESAUeuqXxMqjJPerRjfsne9zxhAiTeTrtLmVqYXOXSn4WM2pGgKi//EKZkmJJCxd3vH5ur5VmC+eyKwoo5peRBuZhBprMoQOY2ooiL0n3ma/AOzgDw1LS5d8679SFl7D1bWmYeOTHkEU/nveSLgsjiWq4Okk6NlElQXr/iOh/uvkB6ECS3wcX+b58B1AO3QkyflhD8kGeM8sOmwsbBImWWmGBeEsl9CPxbYBGWt+UQo/STMahAF97R2yG4rXw47/LB4bDQVEO8Etw79pvlS+Ppu06GW9IVJjViONdob9J/KJRf13XJQi+eMdIlFekyjNilloczZNcR0pMl/gijGqt5XJmk8Su4j73LJ5tYufsSRooczH7mRGTqgIEsrqdmgfDpUG2yWc56k5wzhP9qAX2KD0HfEYcRh3baDb/uXW3/ph/HGFeju8EdJW64nNQvkMNKRFM8xdWikUAAps/slmtoxUVR38W8ZBtyJiO7KnIAXBQXPolCsm9z7sR7JXYTm38ASVrRbDHm6vvWeeUmfsGbiaTJC4GiQyvqS4nRWB+LIJ7MGFz30ZLmVY/bfA9jErQJIlCxrBqqtMqn+TivpjkhWevoExS7OjfA2s/pV0tq0/C5A6Khe5x7vfmKDXb1zDCLe7xCYQDAE1vsobuiNkQKaVs5W7Fi5ohwmGvO/vKp1QGCK7vMDnMCLnZnPbkwlP4U3ruKFgwuzEpy+ZGZfN57tYq6FCSf6NALbFqzbnJ7930/7vUb1vVec1qcofl9OIIETTZMUQz3zUS4XeQCkT//3ADENWzDHcyO3nsB2tqT2nZcjOOs3axuWURHZZXilWsVbPyN9VI1HgqyQcaojdJNtsFGgDmCEh7w9AaB
 LIeB8CPq
 McaemxImEYJSvmJLtSLN3h8+qzZ+YZLBMSnZRF2IfosfXzeDzP53pVopyhltVxJA3huRy11A4Q47EhXMUq/B5sv45yUC3e29F72Sqd1lAglCv1Lrc7BYhmFf6XBemya4q4NZ3to9nn2Rez6fLV4W0rVlSQlEdATApCWQV5HGLC5Q5rL9PdX2rB0rHHIOxM9wk2Y7AEvtvmAEHj44BJwlIn151Bj0O6GO2RScO+2uREzZqY/L9s6A6xw1xDz4/QFXyAYqYTX9xd6eq9k+obR8Lo0inRySOvJxY54As4s0LxvDbOUECzUISUffd7QSAuzCQlYJKB0UBcOY0fbTQoMlRb4g8GLF54KsfOYYQWi7AcgCk6lhvayi/BnqvpJotw4qoc8YLVVNm3u60/DxVjxgcfJW5N3G5sX8FeB5OIeYwJdEVgYB6EglI64sDGp5BPUTOR1eyVQCAVoypHSWw1OErEaEVcHimQgSKBpmB2c7hLWqUXcc4+vYOp3PhclAomb4byYNmxTD4VMjaovqpQezjPqY9Xzgtb1oLcXsp92o7JukgOy2kNCWPNgocYw2eEiblv+osPtb5h2+CTP5GUsjjoyaPyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 10:34:26AM -0400, Zi Yan wrote:
> On 17 Aug 2026, at 9:55, Alan Stern wrote:
> 
> > On Sun, Aug 16, 2026 at 07:42:13PM -0700, Andrew Morton wrote:
> >> On Sun, 16 Aug 2026 21:47:58 -0400 "Zi Yan" <ziy@nvidia.com> wrote:
> >>
> >>>>
> >>>>>> I prefer Andrew's first suggestion.  If the user asks the kernel to copy
> >>>>>> too much data, just fail -- with no warning.
> >>>>>
> >>>>> __GFP_WARN gets rid of all other warnings, even if user asks for a
> >>>>> reasonable size. Why use such a big hammer?
> >>>>
> >>>> Because on many systems, WARN causes the kernel to crash.  You don't
> >>>> want the entire system to crash just because the user asked for more
> >>>> memory than was available.
> >>>
> >>> User asking for more memory that what is available is pretty common and
> >>> should not trigger a WARN or crash, unless you have panic_on_oom set.
> >>
> >> I assume Alan is referring to panic_on_warn.
> >
> > Yes.
> 
> Right. That is why I said “unless you have panic_on_oom set”. So panic_on_warn
> will not crash the kernel if user asks for more memory than what is available.

Are you sure?  It kicks off syzbot, what prevents the oops from
happening if panic_on_warn is enabled and a warning like this happens?
Am I missing some code somewhere?

> >> Heaven knows how common panic_on_warn usage is.  Gemini tells me "There
> >> is no exact global headcount or precise user metric for how many people
> >> use panic_on_warn.  However, the setting is widely enabled across a few
> >> billion Android devices and many cloud/server provider host kernels
> >> where automated failover makes a full reboot preferable to running with
> >> an unknown warning state".
> >>
> >> So I do think that WARNs are more serious than we (mm developers) tend
> >> to assume.
> >
> > I do know that Greg KH has pretty strong feelings about this issue.
> 
> But the warning here is when kernel user wants buddy allocator to give
> what it cannot allocate, a page order > MAX_PAGE_ORDER. The warning
> tells that kernel user please ask for a reasonably sized memory.

And if panic_on_warn is enabled, like it is in billions of Linux
systems, and a user can trigger it, then you just rebooted the box,
causing a DoS and a simple way to get a CVE assigned for the problem.

> >> So we just shouldn't permit userspace to trivially trigger a
> >> page-allocation WARN.  Especially if the caller is perfectly capable of
> >> handling an ENOMEM allocation failure, as appears to be the case with
> >> usb-gadget.
> >>
> >> (Does usb-gadget actually get used by Android?  Surely not by cloud
> >> providers!)
> >>
> >> (Can this WARN be triggered by unprivileged userspace?  I didn't look,
> >> this matters a lot).
> >
> > I don't think it can.  Regardless, even privileged userspace shouldn't
> > be able to crash the whole system by doing something that ought to
> > return a harmless error.
> 
> The issue here is that the inode.c code passes the user input len without
> checking to page allocator code. Capping that is a minimal requirement
> to prevent untrusted userspace input getting into trusted kernel space code
> easily.

But why would inode.c know what the page allocation max is?  We have put
arbitrary bounds in other places where you can cause large allocations
from userspace (like in usbfs), and if that's needed here, great, we can
do that too.  But don't tie that to the mm core values as those can
change over time.


thanks,

greg k-h

