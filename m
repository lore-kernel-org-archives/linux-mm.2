Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F366C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DF5A6B00A0; Thu, 30 Jul 2026 05:41:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 690C46B00A2; Thu, 30 Jul 2026 05:41:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 558946B00A3; Thu, 30 Jul 2026 05:41:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1DE276B00A0
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:41:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 92D0CC08F4
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:41:12 +0000 (UTC)
X-FDA: 85044949584.15.8080A29
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id D49B840004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:41:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=owEBCDFF;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785404470;
	b=5jN8LWO/XDLsAX4caZjT0dYS5N/acHnPgx/Fkx6bqGqYQDDB7OpT85tHMm06tTPUHqW4UQ
	ELnjPkvCuo/a8kmPr09wiJfzoZfh1eUpP3uUJnhjaexYVzSihKZ6as0riXOhsYPWogAouN
	1zznNxTXr/Xdwx3NRrFgI/GaipAYPA4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=owEBCDFF;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785404470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bXRSOEW7KmTLEA5e4w9VE7SIvHIV48lOKraAwCykp7M=;
	b=ZBmVJ/sRR2+Fpq86JAPEMfVFkRRjBKQH53JU/m6STUlsvkwzBw644C+/pZrBefYpJSePsl
	qYx40giPAcBFaDBu9j0qlQYmtSSFba3u+23WXxc+UpbcO7GES7c27lRmveRb03MbBMYma/
	kPpREfXfRIvkHFZpaedeMEnFQesab90=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B762E401F8;
	Thu, 30 Jul 2026 09:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7A81F000E9;
	Thu, 30 Jul 2026 09:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785404469;
	bh=bXRSOEW7KmTLEA5e4w9VE7SIvHIV48lOKraAwCykp7M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=owEBCDFFYm/5ZGKYj3PLpfK+W4y/oqab8Ho92pybkve7clPInVhDZYpnfoTE2ZI9w
	 ZJcdk9WK/XuZ4xo1fAia9i8pCuoK5NIMjj7Vt4X7ThgaEv5SrTuO6SrBPoo/mZO3xw
	 sy9fYDPX7qedxRttlYHJ9q0EDjpfGK0xUZ19gOGeiVIeu2TwwfErbWKZ87/2sU1/lE
	 8RhFDnjjaTmufFd6794B6PbR6kfVxcM09RXHKo/NfZeAM0Ln535IdVwrtGHY9beqLj
	 rPhVwl45M11nidWsdiefFhPWPdjhNcYtx8CQ6IEgv2yzE3EXffemnjENxT1rx2DHHr
	 ebSEugnxHDQuQ==
Date: Thu, 30 Jul 2026 10:40:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pratyush Mallick <pratmal@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, vbabka@kernel.org, sj@kernel.org, corbet@lwn.net, 
	skhan@linuxfoundation.org, anshuman.khandual@arm.com, gthelen@google.com, surenb@google.com, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	liam@infradead.org, rppt@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_reporting: Add page_reporting_delay_ms module
 parameter
Message-ID: <amsYVFfJmOs-Hy90@lucifer>
References: <20260727230545.262579-1-pratmal@google.com>
 <amiN82J8p5z9l_Rm@lucifer>
 <91b61f02-c533-41b9-b680-7de52a5c6918@kernel.org>
 <CALHaPKeOs25YNRg60+NxfS3E5RYLt5hJqFNX02ZCEBrjcDua0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALHaPKeOs25YNRg60+NxfS3E5RYLt5hJqFNX02ZCEBrjcDua0Q@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D49B840004
X-Stat-Signature: mztzqhhod7pk735skfdzqhgsafaidoyk
X-Rspam-User: 
X-HE-Tag: 1785404470-187272
X-HE-Meta: U2FsdGVkX19EFcT8hk1OwefNp5tVxCIIPNk/R6IB7I7p3L4pAAaUzybJxMlUUvTocSmp6hCMHbOX9mctkohPPaH2D1JmPzc034dMgr08SyJ+eHX4/dTta94X0mvcnsrOF0ldpGJhrX9rPkwsiDd0YpK2LXuca8xqQl7IGn6yTn3gn1trWPTTn1/83GAc+KMtCp1bxJCbbge0p0WxRSgdvOaYVcBzxyE35y7scgaVun8RC9zx2uPZ1NiSa64W4ehjvxyEy3maXvqgu4Lovgp+t+E/g5sXqqi9p7sr+BPzplp1QAo9msrstUTJuTD6D/45/w5gD6ibmSirPjvpbha817e+szev1O5y3pGlPBiH8rS3gHqOfHKCMxQlS3R+/06tBHMp4JQHxvxkDmErNvEDCiRV0a3ns6nxgfvRA9vA1qLIIrFRSgMtdNS8GYjGZgOLpFmXSAoS9pH6FktkWENm75fQgHkBedVfHajQHMILGYIJCNWeCKm0I1l8ystYEZdHkL3uCPGWwM/Ka+zdgNLRKO3Af3pkX1zaDanqj4aj2CXKlxAFN7RxBFUwXX4aGD/SI7hQ5eW3TmCEospfFenbk93KyTXeOjutT3pyVe5+sFfpiMGZG8ztFY3lyzz4u7J/0z0lgJgVnpyytKOYKWBpZx0fX1PUXYsAZRQUNtDXYuHrH1xkJD7xh1+4fI30dx6p9H9UBiULlfo95cweIFHVY9gE7Si4TSak9GPhbDpMg8dddKv7sTZjHOL/pJdJ8orvWdbaecip52kS0+4kzWj8WPTeLtI/3yXumoAeb2BF71krhigk+nhV6ycz7dW5hvwlU9q231X807lVX96LKixZPosLyqppgTZTjGeD0H3zOgQddJ2JExVa3Iz+m7fyJg6QiW/1+lTnIfgFFymWiFsS/HgnTLik2/rSq70lqBUp/gYkdxM4P/E1IMDPIEsfRp6YFBo56hQ2yDh0fjE4hkP
 mTVWz2gW
 LvTzKwr/oveUdkhe6G1tW5n+HZmxGPkoWLp5pauGZrXTID6NgqliaTN8IG0pKsIspNA4RZYzndImmKMHr/JXeSUbMJSVIinmEhu2qQ1r891jW7h7NOntowFmbBjocZECc66pTLflHK+2TdGGC0JQmki7XghAz/F20LWAxRQhTiH2l9Jyt3IKe/k6HPFE3UtraeGuFpZjM/yKHgVG5chYEphjY5/0Pto9c/aynONs6uHCjFScNOGo+qubvxgKIvAg0dihjiIhQCePHsIOyeBpScwxeeWr6FTnkCk/YzG2K/GVq4sjxQdFlBbjzRVrA3dqJfMUBWuKVuEkbdyprGBniHtu86qoAZoKJwiMG1rVpDFNp0gv2B3A0NxNtSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 01:31:10PM -0700, Pratyush Mallick wrote:
> On Tue, Jul 28, 2026 at 11:55 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 7/28/26 13:13, Lorenzo Stoakes (ARM) wrote:
> > > On Mon, Jul 27, 2026 at 11:05:45PM +0000, pratmal@google.com wrote:
> > >> From: Pratyush Mallick <pratmal@google.com>
> > >>
> > >> Currently, the free page reporting uses a hardcoded delay of
> > >> (2 HZ) between reporting intervals. While this is a reasonable
> > >> default, it lacks the flexibility to adapt to varying guest workloads.
> > >>
> > >> A low delay allows aggressive memory reclamation, returning unused
> > >> pages to the host as quickly as possible. However, during spiky
> > >> allocation/free churn, this immediate reporting can lead to a severe
> > >> performance penalty (nested page faults) as the guest re-allocates memory
> > >> that the host has just unmapped. In these scenarios, there is benefit
> > >> from increasing the delay to batch free pages over a longer window,
> > >> absorbing the churn without hypercall and re-fault overhead.
> > >
> > > Since you're talking about increasing it, maybe set the floor at the current
> > > value of 2s?
>
> We benefit equally by setting the value to zero as well. This would immediately
> report the pages being freed back to the host without any delay. This helps when
> the host is under pressure, as any immediate memory release would help it.

OK page_reporting_order makes this better.

>
> > >>
> > >> This patch exposes the delay as a module parameter:
> > >> /sys/module/page_reporting/parameters/page_reporting_delay_ms, measured
> > >> in milliseconds and defaults to 2000ms.
> > >
> > > I'm not sure this is great as it means we now have a parameter we have to
> > > support forever and autotuning becomes harder to implement, also if later the
> > > implementation is changed, this might prevent a reimplementation.
> >
> > While I'd prefer to keep the implementation as simple as possible unless really
> > required, I guess auto-tune could be enabled by setting the parameter to e.g.,
> > -1 in the future.

We'd have to retain the customisable delay forever either way.

But I guess maybe in this case it's not such a big deal.

>
> The case we're trying to solve involves tuning free page reporting based on host
> memory pressure. I think the host is the primary beneficiary of free page
> reporting, so if we wanted to dynamically autotune this delay, we would need
> some mechanism from the host to enlighten the guest about its current memory
> pressure and the autotuner would build its heuristics around it.
> As far as I understand, no such mechanism currently exists. While
> we do have ballooning, it requires the guest to actively allocate memory under
> pressure, which makes it a comparatively slower mechanism and wouldn't help
> much for simply adjusting the reporting rate of already free pages.

You're explicitly needing to do this under certain circumstances.

>
> > >>      /*
> > >> -     * Delay the start of work to allow a sizable queue to build. For
> > >> -     * now we are limiting this to running no more than once every
> > >> -     * couple of seconds.
> > >> +     * Delay the start of work to allow a sizable queue to build.
> > >> +     * We limit this based on page_reporting_delay_ms.
> > >>       */
> > >> -    schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
> > >> +    schedule_delayed_work(&prdev->work,
> > >> +                          msecs_to_jiffies(page_reporting_delay_ms));
> > >
> > > Err, do we not want to limit this to something sensible? What if the user
> > > specifies 0 does it just hammer the system at that stage?
> >
> > IIUC, 0 just means "as soon there is a suitable free page block to report, start
> > reporting immediately".

There's comments like "We will defer by page_reporting_delay_ms to allow more
pages to accumulate." etc.

Maybe worth tweaking that?

But with page_reporting_order == 9 (or 5 see below) then fine I guess.

If somebody asks for something stupid by setting it higher they'd already
accumulate latencies, just now with a 0 timer it could be really crazy :) but I
suppose they are asking for it.

> >
> > With 2s, we wait 2s before we start reporting immediately by kicking the
> > workqueue immediately.
> >
> > So "0" does not mean "report all the time", rather "start reporting immediately
> > as we are notified about a pageblock to report".

No, it's whenever pageblock_order is specified, defaulting to a pageblock.

But I guess in practice fine.

There's fun like this in virtio_balloon.c btw:

		/*
		 * The default page reporting order is @pageblock_order, which
		 * corresponds to 512MB in size on ARM64 when 64KB base page
		 * size is used. The page reporting won't be triggered if the
		 * freeing page can't come up with a free area like that huge.
		 * So we specify the page reporting order to 5, corresponding
		 * to 2MB. It helps to avoid THP splitting if 4KB base page
		 * size is used by host.
		 *
		 * Ideally, the page reporting order is selected based on the
		 * host's base page size. However, it needs more work to report
		 * that value. The hard-coded order would be fine currently.
		 */
#if defined(CONFIG_ARM64) && defined(CONFIG_ARM64_64K_PAGES)
		vb->pr_dev_info.order = 5;
#endif

>
> Right. Setting the delay to 0 does not hammer the system. The execution
> is constrained by two checks:
> 1. The worker is only scheduled when high-order pages (default is >= 2MB) are
> freed. This makes scheduling relatively infrequent compared to normal 4K
> page allocations.

It's that only by default and could be overridden (and is for arm64 64 KiB page
tables but probably also fine there)

But probably fine.

> 2. Even when the worker wakes up, the actual expensive operations, such
> as page isolation, acquiring locks, and hypercalls to report pages, are
> guarded by the watermark check in page_reporting_process_zone(). We only
> proceed with reporting if the zone has enough free pages to fill the
> capacity batches (32 slots by default). If the watermark is not met,
> the worker simply
> exits and returns to the IDLE state without issuing any hypercalls.

OK that makes it better.

Can you make these points in the commit msg on respin then?

>
> > >>       state = atomic_cmpxchg(&prdev->state, state, PAGE_REPORTING_IDLE);
> > >>       if (state == PAGE_REPORTING_REQUESTED)
> > >> -             schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
> > >> +             schedule_delayed_work(&prdev->work,
> > >> +                                   msecs_to_jiffies(page_reporting_delay_ms));
> > >
> > > This code is duplicated, while you've making this change maybe pull this into
> > > its own function?
> > >
>
> Thanks. I can create a new function for this and send a V4.

Thanks

>
> Regards,
> Pratyush

Cheers, Lorenzo

