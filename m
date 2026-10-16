Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B24DCCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 00:38:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 642726B0095; Thu, 15 Oct 2026 20:38:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F2EA6B0096; Thu, 15 Oct 2026 20:38:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 530E96B0098; Thu, 15 Oct 2026 20:38:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5546B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:38:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B83BC1601F3
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:38:30 +0000 (UTC)
X-FDA: 85326628380.16.6A2478D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id EA3F820005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:38:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZurLXw1a;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792111109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5TB8q3jOLCWfi6nq3LQFTYj1ETHvnif/9oaoAQuSXpY=;
	b=DNeTJRygVTodpYf44EkGEJmhNdeWtsQZMxmwEY0VRGcIy55qE2Xwlo3Um1xrazEhxN2lrp
	DNt6PhSY9uKYieO20o76bxtVY8NS4bS4/9L7Vn7Z7VR2VdRK+g6BQynT+jXzSKyfK5aP4X
	tcxMSZDJ8kct09NX4j5gLAWxZjI09v0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792111109;
	b=ZBDV4BMRWLckYJlQnU3StVdqEGX03WBe918e4vE8Z4pFODcA9TjQ1xSlVNah/buHmUcAOZ
	X7aGhTt7c2CSx0Cy5qMhrtDdEtXqvu2KTLThWe61DvXWJXRMUvZNr8ITnqflp04fzHsWal
	06k3UVfkytjJDLDBg1Pi4+jcw0Ise50=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZurLXw1a;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B8F6F43A24;
	Fri, 16 Oct 2026 00:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58E81F000C4;
	Fri, 16 Oct 2026 00:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792111107;
	bh=5TB8q3jOLCWfi6nq3LQFTYj1ETHvnif/9oaoAQuSXpY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZurLXw1a+hxon7EKEidO2yueKgWEk5blqWjqaamtLSRCsBIzY8FHyhEzvzkEUTA7B
	 tBlA3od06X0fsQSI0Wcp2Y+7VfqBs2+xpZQVUi0mJyBXIfLW2sIC8wENlGkLLwMQPL
	 agL+iUAd4qWd+NsX+vwGLfXAVs7Rr+vSDGtOq+zw=
Date: Thu, 15 Oct 2026 17:38:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nimrod Oren <noren@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Brendan Jackman
 <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, David
 Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: stop recalculating min_free_kbytes once set by
 userspace
Message-Id: <20261015173826.e7ffb7333fb84f5be927ae88@linux-foundation.org>
In-Reply-To: <26103c38-7b22-4176-8bc3-63e4b8fc6bbb@nvidia.com>
References: <20261014140859.1006967-1-noren@nvidia.com>
	<20261014144823.8c89da26c547fa95936a2fe5@linux-foundation.org>
	<26103c38-7b22-4176-8bc3-63e4b8fc6bbb@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EA3F820005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: oprcug86rggcfffg58bwh4egqgtkbf6a
X-HE-Tag: 1792111108-626473
X-HE-Meta: U2FsdGVkX1/UMaeh0EnRgfqLgvIdgYP7TczDIvRzscazGylQJdnnf5hPfWX625UMguxwF/LWHmP1kUSIY78sztRvuJrsEWCv8Q7fse45CJ9H6+4/h0lM9c3tWQZtFnTCzfhttANYcKteED4lqAa1S4Ue1ZAuy19Zf92AxuTEb0j/ltLKnVvvg9Ic8zEGpgNhdDWxu1a3TQ0kE2odBJTDUaxm/k2s27zIXYYnvkN4h+WALceVPav2fpcJF+dbXbH8Fd4SRTsnCqNeYC4M73DSPNzmGKUZ1UQJbfZmdZ93enNMr13MuYkX/qM0eNMz2JuuJJ78uBBjTyQ0uFBfJslwSPLuc8JMRnC3bMZURSfGtIUYwOKC5yHxKgC0Jo7StJVrVjnGp1Jek80mQel+vT/1B4An7OY+fGEcVlaXnHtTyQ6goZ19k8BApDKCDrSCBmtgSXiVPX5HGOTUPRVOtyj5pOSsCWPoBmtcQMz8fQmTK73gJKNTocCv4+sV2QllYveH8GCGx0uPbX6MrnngUwqYCF/hIowen+sBD8XZRdYS+CmfYAODg3NhETvTncJ1MV8vJDIGQZ8RZhLzqfORUsRMXCRbrOMjpdkYus1KxqwFB4PkfzrhaCu6b1FA+jV8rmKHwfExbUF84M4B3kbjxdWr2St70kgS9gRx6/xiY2SUTtj8+ppxQF/ujBV/3br9SIbFnsY4MI91iRjj/NsSpZgWH7TrsXYwjgoxAxaVQODDZ2/cvhsz1nkuAMvMwDgjM7xC/s3FwnitLJLDiWqK3GsboGOb9o9lBbZbKWsUAe+UTK4xqXfvUnR0TQLjcINSIH9gusyOKQ50qBFyJtsavI4dRLlEgkLTUaidPdapo7NjgjofGLwi3PE4IcZMsmkHchrcsPuYnAnROLEVX+Qn9UcXCjqaXVQ7u+0qV+pKa9R0NCOIdQMfIxnn8kz5NBV50e+oc0e+vtUzBBErhk563sH
 +VdU8Llb
 8UN4L/rVF/NfAlA7Ccvs9+GiBJkO6OxjhAwJ8YDyScOkSHdWVCU2ebSH6CUoizf2/u1fKOl812rrvmNmXgsbnDrTwBdlnR+Ms5a4qL99OOm/RQV+fPDq0c/ysF294E5w5lD23fyN54OE2FM7dgs7soVedwUg2gQR9OdMeY6DkSzhEpBUw8kO4mlyuXEBi8MNVN2Gt0ktT/gnNzi31+eHonvGbUZS2ho+5bn/dXZJuDheNu6430Mh2/4FKT2gTkE8QD3cOgYvYY4UcCX4hvJQ63qv4/ha4PTp/BbsEktY5Vx60JUarAL9Yts2TairbmBPh22zrOPAubH0i8qi8O9zRURrE1zgq6bnwfevqyAVILRQD6AWnKeVuoRYhPNGvdqywVnSvTxhzuzj0uZ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Oct 2026 19:16:40 +0300 Nimrod Oren <noren@nvidia.com> wrote:

> On 15/10/2026 0:48, Andrew Morton wrote:
> > On Wed, 14 Oct 2026 17:08:59 +0300 Nimrod Oren <noren@nvidia.com> wrote:
> > 
> >> min_free_kbytes is recalculated on memory hotplug and on THP sysfs
> >> writes. The new value comes from calculate_min_free_kbytes() or, while
> >> THP is enabled, from set_recommended_min_free_kbytes(). A value written
> >> to the vm.min_free_kbytes sysctl is replaced whenever the new value is
> >> higher, so a lower value does not stick. This matters most when THP is
> >> enabled on configurations with large pageblocks, where the new value
> >> can be excessive [1].
> >>
> >> Stop recalculating min_free_kbytes once a value has been written to the
> >> sysctl. Systems where the sysctl is never written keep the current
> >> behavior.
> > 
> > This problem lies somewhere in the range of "minor annoyance" to
> > "catastrophically horrible", but it isn't clear where in that range it
> > falls.
> > 
> > So can we please can we have a paragraph which explains the real-world
> > userspace-visible runtime effects of this problem?
> 
> Sure. Can we add the following after the first paragraph?
> 
>   For example, with default arm64 pageblock sizes, the THP
>   recommendation can reach 5.5 GiB per eligible zone with 64 KiB
>   pages vs 22 MiB with 4 KiB pages. This keeps a significant amount
>   of memory free, reducing what applications can use and triggering
>   reclaim much earlier. Users can lower vm.min_free_kbytes to avoid
>   this, but the lower value only sticks until the next recalculation.
> 

Thanks.

Do you (and others) feel that we should backport this?  Or is it just
not applicable to real-world users of older kernels?

If we expect there to be non-zero users of 64k-page kernels on older
versions then I think "yes, our users will benefit from this".


