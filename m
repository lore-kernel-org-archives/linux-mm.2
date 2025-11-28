Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92EEBD116EA
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 19:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E7826B009F; Fri, 28 Nov 2025 14:51:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9976A6B00A6; Fri, 28 Nov 2025 14:51:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 886B26B00A7; Fri, 28 Nov 2025 14:51:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7415F6B009F
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 14:51:33 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 26AD750BEC
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 19:51:33 +0000 (UTC)
X-FDA: 84161060466.02.E37D73E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7522114000F
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 19:51:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DDUX0aHo;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764359491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B6YeQYtPOVDtLTK9DFwVSfRPJZ6vWdv85d2IOIz3XnQ=;
	b=l4F8ZiONqwBeN3KWEZcxk6VnKFz85FLtYdOBF3/rMXvLWwqKddGduMVMZNdcuCjy2VnM/8
	YsOiydIRU5rur3YFriqKmIRvqyA6DXbCo5waclvUyI+JbFlf8NOylbSbu4nVNBBqoNtIC5
	7zdkLL6YyyULDV0rLmgCozvKlk+XVE0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DDUX0aHo;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764359491; a=rsa-sha256;
	cv=none;
	b=VBABZDiIaflsHTIKH6wSifwvNB67hLjWjz3lwBCLBSovjFXMfxuhF0hhWceEPyX7Or9wF7
	mj2EZxZy6gEoG38erS8/INyArdxfWs5StX9i2NKkmgx/K2T1SIxqstm4npawDS/0/LawKy
	IJ1o5CIGVzsFLRX02b0LuEe3Pcjt8UM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B4FC160192;
	Fri, 28 Nov 2025 19:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3939AC4CEF1;
	Fri, 28 Nov 2025 19:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764359490;
	bh=NR06UM6epC0ZB0HG7Po42G/+BGWua8g9q5A5Ak9ER9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDUX0aHoVVdYpplIWWEnJQsduHQha8bvV/5+IXyPLpqt2WB7ofVD97rjBLys5COF7
	 2VwhXh1WV0Z+G0oOuZrMkuBciZAjehGBN+WGIsPPG+cLki79FQnmts2W3cPv++N+7+
	 AdgWB5sGerJAqJvkVfwUiONi7iXTeHjC/IQXXQEwn2aa/eyEYZG9NJwRhUf8zEBsXl
	 qiT/ZWdmgCYtBW2xcrCoBMgTxT3xLkuuqoKcxm/61NeVt6lEJNfgoOsUfFbtDFTOKu
	 0qPFbDYZTnKX1zOzCibC4zViHH5LwJskk4xnWKF5ZN/PHkbJgcEGEUFrMhE7fYi4PC
	 M0vGLTLdTrYug==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	Xin Hao <xhao@linux.alibaba.com>,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
	Andrew Paniakin <apanyaki@amazon.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-mm@kvack.org
Subject: Re: A rough plan for CPUs/write-only monitoring RFC v3 and future
Date: Fri, 28 Nov 2025 11:51:20 -0800
Message-ID: <20251128195121.81042-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128193947.80866-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7522114000F
X-Stat-Signature: 6qdktrerbbd3oazucsis7dw57m9wzz64
X-Rspam-User: 
X-HE-Tag: 1764359491-608207
X-HE-Meta: U2FsdGVkX1+VZJmCdGDPxcYcfKTgWyKTjuFncjuSGXmqNv6oDpSQ31GktdVTkoukuU+vE7Wn4nAOfOlPKplskOTf40EHxdTnS18ZYQlmw4w2ka1iZTFeZwSCaDkROYPwSMFe9+wkuYFgZUqYQ7OSqRKhkvVyo7uuNiTeUfHj8C9UPeIXdscmKq1MtiNmXYYkFawptpxcZqduCdGdBNWx2b99FZzGYqG3ppOud8gjECys0WvEbNeMcWEPhCelbhbWm9qEiSDh4gqtTL1CMlCat1oQx9onPl4L4lydu/zW/qXcOtzn3MAPEE2M/ZA0hnlRTM6A07oFtz7IQC5tcYy6aYrRHNuUss0b15wpoLsmri3Q1FqqgBZjvqSYvhDIEN9xAJq4nk8tSjPxH8LVbbyLdFryJN5ZwqVVHikybC/Y66rL5hwL2Ggs+UbrA8TwtIFLBNyOnb3rG5SJY4EwjDXnfRWzbQlVmhnTWlS1u3U1wLS3VTSu0fhcFZoMIryE8d8/gWFNgJyG6+Ud29Eq0PKM/ygf7deMMCtOS+Lfv8RlYGmib4MORLHFcEwQfjznDkiru9SfXQ9CSdnGNzXEIlcbKuUO1B6eqwxEzqGN+QC+BTTAQgsgXP4+pYciw9Im7PKyFdYfgaJN//SF/MNT0aITyj71w5uFKUm+fPShVPCw/DZZ3OmzmhjQEo9HGs+LsX9OgPPVon7KfhDUt/d+v1U0841F7q+rePrseo++aLrE2GBjzuCo+Q85MqdUunECZPz9tvmOipUFXzLxeSvWiXztVtaSdOU7BJXqQ/PH969gBiaz6tNXndAmnlnQb8yEqq+NzyKSPDPXK3NeyvbW5wfYIazYWGED4atkL+lht9rHjiCLJy0gzsl8WDKYLTU3GkNnJrbMdm0KwkkB0Rf4jlljXeO7pkuosv035g+X22WDrtD7rUE7V5C9sfRprnSiBHgE4iXtGIZwvAqnlj0NoJ8
 Xx7An5e2
 tiyqMCvfeLEHJF57qcbVSq865W8zgxLZARFB2wbnuot5NeLoX6sVSfCLq/WkPdBTA1Gmse3cMkIqWMSkupkX26GyDGzx3fH+dAEWV7vVa93LF4YM7AJLToW2UEGjVCzG8otEleolWgfXU+ZZf/IU+SRRfDCPvETGiczLpVsYeUF5v9Z66rA4lKH0OhmNUnUXuGISYmkjIAo5LRI2aJ1MRO0i4A29FJGtXDxdqnIpuZRVuKXFRROL0th7rS9XfXnO55cU47zOTYTmha5HIoAQch6brn0s54LcB7kaifhQy0mxmfb65tXHu+rlwHl4L11SZwVovehnafpGmbpxlTvUWznatLbnzMf29kWG6J8gQEA+wIuzlnw4QOt/Jqikqm8c5dFxvi4QjBXBxmOwWPG7XpoC1hqoRDAvq1o6DaoHrjwX76Sd4TEMqyj5WtLUmCcpL9c3KmUBDJTrMP5L97HbKq5xQSYRxxNTmEPaUtpA26xEj9PsK0ELAwysMu4637d3ZrEX6weNEZhabP0PFOdlxUF+gkVgcKFT/94KI7aZh1UtTxhTQFn9jJAv8icI7S2e8yyxY3zrbNZZ6BUJjjXJWcRO1aw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ linux-mm@

On Fri, 28 Nov 2025 11:39:46 -0800 SeongJae Park <sj@kernel.org> wrote:

> Hello DAMON community,
> 
> 
> I'm working [1] on extending DAMON to monitor accesses that are made by
> specific CPUs, and/or for writes.  The aimed usages include NUMA hit/miss
> monitoring [2], Kernel Same page Merging scan target selection [3,4], cache
> aware CPU scheduling, live migration target VM selection [5], and general
> NUMA-aware pages migration [6].
> 
> I posted its first working version as RFC v2 [7] about four months ago.  After
> the posting, it got interests and tests publicly [5] and privately.  RFC v2
> was, however, a never upstreamable hack that was made for only showing if it
> can be implemented.  For making it upstreamed, a significant amount of efforts
> are expected [8].  And after the posting, I was unfortunately unable to spend
> meaningful time on it due to other events and work.  I received more continued
> interests in the work recently, and hence I'm trying to spend more time on it.
> 
> The Rough Plan
> --------------
> 
> The rough plan of it that I shared on DAMON blog [8] was just saying "it needs
> to be upstreamed and it will require a significant amount of effort".  So I'm
> sharing yet another rough plan here.
> 
> This work require multiple changes including
> 1. extending DAMON for receiving access report from other subsystems
>    (damon_report_access() [9]),
> 2. making other subsystem who can capture origin CPU/writeness of accesses
>    (e.g., page fault handler [10]) report the information to DAMON,
> 3. extending DAMON for filtering the reports for origin CPU/writeness of
>    accesses.
> 
> The first part in the current implementation has many rooms to improve in terms
> of performance.  I don't think that's upstreaming blocker though, unless some
> early testers find a problem of it.  So I think this is not a blocker for this
> project, at least at the moment.
> 
> For the second part, I'm trying to modify the page fault handler, to use
> information like NUMA balancing hint faults.  As Lorenzo pointed out on RFC v2,
> it needs to have clean and non disruptive design.  Also this requires alignment
> of multiple stakeholders, including MM core and NUMA balancing maintainers.  I
> think this is the biggest challenge of this project.  Using other subsystems or
> features such as instruction sampling can be another way to go.  But for
> general availability of it on any architecture and virtual machine internal
> cases, people I privately discussed preferred this fault based approach.  I
> will try to make the alignment with the stakeholders, after the upcoming LPC [11].
> Unless I make good progress on this part very quickly, I will propose an
> LSFMMBPF'26 [12] session for this.  So hopefully we will make some alignment
> among the stakeholders by LSFMM.  Hopefully we will get a more concrete
> upstreaming plan and timeline, at least after the LSFMM'26.
> 
> The third part in current implementation is very ugly.  Especially its kernel
> API and user ABI need to be redesigned from the beginning.  The interface is
> better to be stabilized sooner, as changes of the interface will make the early
> users/testers be confused and frustrated.  I started working on this, and
> hopefully I will share RFC v3 of this project with the stabilized interface, by
> upcoming LPC'25.
> 
> Summary and Message for User/Tester
> -----------------------------------
> 
> To summarize the major expected timeline here,
> 
> 1. By LPC'25 (2025-12-13), another version having stabilized DAMON interface
>    will be shared.
> 2. By LSFMMBPF'26 (2026-05-06), an alignment on part 2 stakeholders will be
>    made.
> 3. After the alignment, a more clear plan will be made.
> 
> If you are already using or testing RFC v2 of this project, please be aware the
> kernel API and user ABI will significantly be changed on the version that I am willing to
> share by LPC'25.  It means if you are directly using or testing the features
> via the kernel API and/or user ABI, your usages or tests might need to be
> updated.
> 
> The support of the features on DAMON user-sapce tool (damo) is also
> experimental at the moment, and that will also be changed in more stable form
> in future.  But, the experimental interface will support both before-LPC and
> after-LPC DAMON for the short term.  Hence, if you are using or testing the
> features via DAMON user-space tool's experimental interface, you will not need
> to make any change in the short term.
> 
> Please feel free to raise any questions or comments on the plan and the
> project.
> 
> References
> ----------
> 
> [1] https://damonitor.github.io/posts/write_only_cpus_only_monitoring/
> [2] https://lore.kernel.org/linux-mm/cover.1645024354.git.xhao@linux.alibaba.com/
> [3] https://lore.kernel.org/lkml/20220203131237.298090-1-pedrodemargomes@gmail.com/
> [4] https://lore.kernel.org/damon/20250129044041.25884-1-pedrodemargomes@gmail.com/
> [5] https://lore.kernel.org/all/aJAfTUh-49pYuhbg@3c06303d853a/
> [6] https://lpc.events/event/19/contributions/2066/
> [7] https://lore.kernel.org/all/20250727201813.53858-1-sj@kernel.org/
> [8] https://damonitor.github.io/posts/write_only_cpus_only_monitoring/#cautions-and-plan-to-drop-experimental-tag
> [9] https://lwn.net/Articles/1016525/
> [10] https://lore.kernel.org/all/20250727201813.53858-6-sj@kernel.org/
> [11] https://lpc.events/event/19/
> [12] https://events.linuxfoundation.org/lsfmmbpf/
> 
> 
> Thanks,
> SJ

Sent using hkml (https://github.com/sjp38/hackermail)

