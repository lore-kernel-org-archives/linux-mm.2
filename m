Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA57FD5B862
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 18:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 181856B0088; Mon, 15 Dec 2025 13:19:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16DA36B0089; Mon, 15 Dec 2025 13:19:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0850E6B008A; Mon, 15 Dec 2025 13:19:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E39196B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 13:19:15 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD9131601B7
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 18:19:15 +0000 (UTC)
X-FDA: 84222517470.29.A57DB59
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf05.hostedemail.com (Postfix) with ESMTP id B5AD4100014
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 18:19:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J3LqOJpa;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765822754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lM43wrnlnlkMNqFPDW8KYA5Kn3KbKiIXGK01EzxZsuk=;
	b=YVY+AEw3ghFmDDg3KuEgbp7/ZiezAGB1y+vRAmgGUNhmV6xDW9YwgZyGrR73d6a6s/wvth
	51VHf9vVyJT8T+deYamWeWdYwzI9Nghov9wuQQ1V82/Hj5QWFR/1lndMsOnnoQwLyEv1dt
	N+r4EYxprS6d0lsu9AOHfA4VE/qLzag=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J3LqOJpa;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765822754; a=rsa-sha256;
	cv=none;
	b=Lh7gtq7y5WcerQws7pKZyZHHs8ev4698lsrZSEYW6DDLHFBCDMjiFb4n2GDWo6YwUaZBna
	6sP2bwh1719z+WCz6V4iuFlcdws6dEf64qvVL9khIMHGrsWc/6LU1BzsCZrfwKRHtd/A3v
	9OjHXDdXXZ5VNa74y2RZlvLb5KXs6vo=
Date: Mon, 15 Dec 2025 10:18:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765822751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lM43wrnlnlkMNqFPDW8KYA5Kn3KbKiIXGK01EzxZsuk=;
	b=J3LqOJpafBGNgZS/H44p6FPOwYKxXkhb8+O+/PoV1ltWSxYSLr4nIJclgI28YDJeNqU+iv
	wAhQjhvcH+sBjL5dgEMNwyFKkK8p24U1qx6qjni3y49IGWOeKuK0TlRrB5gbFlwFDC52qo
	dN4GL7gHKXPvf23CsBAgk7OicW1+xJM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"Paul E . McKenney" <paulmck@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH v2] cgroup: rstat: use LOCK CMPXCHG in css_rstat_updated
Message-ID: <j4w2nyev23cdn7b4yop77baokq52cd4bkz64phosh2yuynlbfr@4azhrbquiyjw>
References: <20251205200106.3909330-1-shakeel.butt@linux.dev>
 <rrpswcxeciypobup7rdwvjknnsjkcnov2xdabbfng7se5yihk5@4wayqftotykw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <rrpswcxeciypobup7rdwvjknnsjkcnov2xdabbfng7se5yihk5@4wayqftotykw>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: swxfozk1j3i8zgarg8gzpiuabotaq667
X-Rspam-User: 
X-Rspamd-Queue-Id: B5AD4100014
X-HE-Tag: 1765822753-111494
X-HE-Meta: U2FsdGVkX19SuEf0qsnXXnlBdZq3Pc/pmFOKQ4Hvn3VgB4roBlRzGCnsh2ljDCrGLfVaoDZ9FDgNrBxjW8KU55WwEArq6IMGmiyPDLRtgy7NS/UqJSXl0UTQbDFHl0X7Lu3m41X2xIvR1VMTsJMHRVfe8QAeYqjwEaRHFGDWnBnVji1CkhVSChA6WEfJZaBmEWxhARte0kuUREkRKkA+cDfOoK1mFuUOnpLNHg2j3kG0VCSpBsZv11V+u0avKUtenNYHkwg27qCm0vo7LxNMZNPdzf9uC4P7ENVHZgBALkVazGCpb3y+FbbJKW8G4piai3UaSQ3XIZwe6UvrcE/FoMZMgOxbUKtz578TqtbXTUxCAdHV1Ess3awJhYPGxojnaaZJf7fNuLE9UxknwXY5xJDbdWdWMwHInGJreCgYkPL6C893Zh/4rmdan/mrj2C2zwiBN5pb5UC7Aove1TEUyqY3X6ubJD1AA1XsnBnX0J5Fd+8kf/4wgYYb2TaXoofVWEA4HU3zzzJIuWKffmXRt1iYQQFdqpB7aLghAO4wWKpLlNqgTmn8KSba1mIquuYglEfCdDa6iNXfyDuv+xqg7bIH3hgksVgN4K9FcQKn4y55nG+ODouS78EKx5TRt33XcPgi0G+jVy3AJubQ0dQOXoa4Vtnb1+40dlceR9yfrJZIWIU8M2TJO/MZ11IllJyfHSI5QC66zXvlxZGEynSZO3M9q+BtUVHnf2fJrqJevzFILufZ2qC8FJ57CPCN6mdIlwKHXATQnMUE1N+acDMriJC9COJy1NWa0dnZbgOaBZmJMw1LIy31+EWT/KB2MKOpF21nLAsJPsMZpGID5DYfnoBiL6wOWspwkNBX/YD9kIAW8U87M2YMMM4V0yFbUI/8UZQUA/yzpd9o/HccnwBPz1i0cPQI1Sp62tkx9blQnL1ZTNoBPhjsId/zii/NyET3ZF6sfdxc+I5uQJ+ZTLL
 e78dxspE
 nURiPdORtlaz0sjf5afKZoyesPU2CJf+4cUGQl1nBGPCNre1zGRVk2jIBL3pSEHxrAWl62w64YwR4uvsaf2kUxUnsPtV5iEgTSuZHpIxIfv2XenTxQ1MQ3lvv9IQh80xkyazfFwiQ5Cu2xWCLvQdjd1a/NERXuQQn1dsjG4D04Hv8sZENUBxa0sTb67FZG1A1Zc0W8R5uX0UiZC/FNCfIq8gl9ngh1rul0fGkpMdP35TclIO6zv1Xlr4B+xS4xdLC8uJtEQyvVCGv5aTOzjnH3TOEtA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Michal,

Sorry for the late response as I was travelling.

On Mon, Dec 08, 2025 at 07:11:31PM +0100, Michal Koutný wrote:
> On Fri, Dec 05, 2025 at 12:01:06PM -0800, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > On x86-64, this_cpu_cmpxchg() uses CMPXCHG without LOCK prefix which
> > means it is only safe for the local CPU and not for multiple CPUs.
> ...
> > The CMPXCNG without LOCK on CPU A is not safe and thus we need LOCK
> > prefix.
> 
> Does it mean that this_cpu_cmpxchg() is generally useless? (It appears
> so from your analysis.)

No it is still useful for single CPU atomicity i.e. process context vs
irq and NMIs.

> 
> > Now concurrently CPU B is running the flusher and it calls
> > llist_del_first_init() for CPU A and got rstatc_pcpu->lnode of cgroup C
> > which was added by the IRQ/NMI updater.
> 
> Or it's rather the case where rstat code combines both this_cpu_* and
> remote access from the flusher.

Yes.

> 
> Documentation/core-api/this_cpu_ops.rst washes its hands with:
> | Please note that accesses by remote processors to a per cpu area are
> | exceptional situations and may impact performance and/or correctness
> | (remote write operations) of local RMW operations via this_cpu_*.
> 
> I see there's currently only one other user of that in kernel/scs.c
> (__scs_alloc() vs scs_cleanup() without even WRITE_ONCE, but the race
> would involve CPU hotplug, so its impact may be limited(?)).

No, I don't think there is a race as hotplug callback happens in the
PREPARE state where the target CPU is already off and thus nothing is
running on it. BTW cached_stacks for VMAP kernel stack is similar.

> 
> I think your learnt-the-hard-way discovery should not only be in
> cgroup.c but also in this this_cpu_ops.rst document to be wary
> especially with this_cpu_cmpxchg (when dealing with pointers and not
> more tolerable counters).

Yes, this makes sense. I will followup on that.
> 
> 
> > Consider this scenario: Updater for cgroup stat C on CPU A in process
> > context is after llist_on_list() check and before this_cpu_cmpxchg() in
> > css_rstat_updated() where it get interrupted by IRQ/NMI. In the IRQ/NMI
> > context, a new updater calls css_rstat_updated() for same cgroup C and
> > successfully inserts rstatc_pcpu->lnode.
> > 
> > Now imagine CPU B calling init_llist_node() on cgroup C's
> > rstatc_pcpu->lnode of CPU A and on CPU A, the process context updater
> > calling this_cpu_cmpxchg(rstatc_pcpu->lnode) concurrently.
> 
> Sounds feasible to me.

Thanks for taking a look.

