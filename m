Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B368FD8746
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 11:51:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70D8A6B0088; Tue, 17 Mar 2026 07:51:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BE546B0089; Tue, 17 Mar 2026 07:51:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ACC96B008A; Tue, 17 Mar 2026 07:51:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4AA406B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:51:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E2678C011D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:51:00 +0000 (UTC)
X-FDA: 84555388680.21.0664DA1
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7AAF614000A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:50:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773748259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eJPcRpwIoY8lxu34CSFv8eOn+HCjO8LE3kQkkvlb90o=;
	b=pxYO87/pFrCClXKKSE6/maYFqvgxeUK29DQWMT8zUmpmCRSe5hKPn1jjNv76zIDmjEUmsM
	uHsyhVGzOoc+VAz1QI5myDwkJqLPRg2SZ3MQDIDOZtBW7FSuexpTuW1i7C3iOHIhn6Y7yr
	WiHS/ivJ/p5wD3cBLh1WSypzBoj5Wlc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773748259; a=rsa-sha256;
	cv=none;
	b=y/eJOjZHhCOVFyR1fACgMTs4lclDJHBl1xkpSSPFkxiD22oIdjHx16YxCN1yjzebEFA8xg
	ksjO4OlO8Hu8q8Kh+/p7LXkZLDFeZZgBJgb1xWp+NyqCsOiuHZhdp2us1EX4iKWEM1ye4l
	MeJ7EkTLB6iL6OLfxVjbx3vukH6Spv4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c2dff70000001609-67-69b9401fe92c
From: Rakie Kim <rakie.kim@sk.com>
To: Gregory Price <gourry@gourry.net>
Cc: Rakie Kim <rakie.kim@sk.com>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	harry.yoo@oracle.com,
	lsf-pc@lists.linux-foundation.org,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] [RFC PATCH 0/4] mm/mempolicy: introduce socket-aware weighted interleave
Date: Tue, 17 Mar 2026 20:50:47 +0900
Message-ID: <20260317115052.294-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <abhd1BXSST0BTDaN@gourry-fedora-PF4VCD3F>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsXC9ZZnka68w85MgwuXJC3mrF/DZnH38QU2
	i103QiymT73AaHHiZiObxeqbaxgtnm/9xWjx8+5xdov7y56xWOx/+pzFYtXCa2wWx7fOY7fY
	3vCA3eL8rFMsFpd3zWGzuLfmP6vFyVkrWSz2vd7LbPGtT9rifp+DxZH125ksJl9awGYxu7GP
	0eLWhGNMFqvXZFjMPnqP3UHKY+esu+weCzaVenS3XWb3aDnyltVj8Z6XTB6bVnWyeWz6NInd
	48SM3yweOx9aeky+sZzRo7f5HZvHx6e3WDymzq73WL/lKovHmQVH2D0+b5ILEIjisklJzcks
	Sy3St0vgynj97ShbwSPBinuzj7M2MH7m7WLk5JAQMJHo27OWDcbet3I+SxcjBwebgJLEsb0x
	IKaIgKpE2xV3kApmgQ42iWmnZUBsYYEMiQnL/zOD2CxAJScad7OA2LwCxhJt3Q9ZICZqSqzb
	eAvM5hQwk7j/sxVsk5AAj8SrDfsZIeoFJU7OfMICMV9eonnrbKCZXEC9P9klnl5bDnWapMTB
	FTdYJjDyz0LSMwtJzwJGplWMQpl5ZbmJmTkmehmVeZkVesn5uZsYgZG8rPZP9A7GTxeCDzEK
	cDAq8fDeYN2RKcSaWFZcmXuIUYKDWUmEd9mRbZlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeY2+
	lacICaQnlqRmp6YWpBbBZJk4OKUaGF3CNRVaD1fd0ki4xGIQbGfZ4iJUOMtxNQebnMu7LI7S
	0z1LT3n+mM59LCF31ozejg3Llkz+kqZz/eMHpkXX5lxe/3KCrnuUIPPJWZ7S17UF925uXMKc
	VPPhB9f34/rvbQ5wzl63u9SH90En5wvbmC/vLr9lWm+lf0EhZ4v+ZvXJfNnMk01331FiKc5I
	NNRiLipOBAA/p30y4AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRyHe3fec3YUF8cledJAWFRT8kZlr1Cmn3wJQokgCkmHHtzJK5uK
	E6KJKalommm6WRmSl7m8jLytVPI+u0mmuXnLzDt2MyQvYC4J/Pbwfx5+X/40Ie6CTjQfm8Ap
	YmXREsoW2hYfD3F38W/lveY1NCqt01NoYmaQQsbRy+jdfS2FHhQOAtRvTqVQjVkP0HzjBkDr
	E31CNFUxB9Hq3DKBOmbnIdI9GaFQX+MjIep6aCJRs/qzEL3XDEA0ZCyl0KR+m0QmTTVE7ctt
	BFrLdUZTuf6oc2SeRN11zQJU8KGMQtrUXIAseb0CVKOXo82mqp1Tz6TQ3wW3aiaEuMyQiLMz
	hoT4dvcKictfLgqwQZdJYcOve0LcX7wJceu0Ly4YrQQ4J+0bhX/OWiBeG8O4fOGHABdqb+G6
	58MwWHzN9mwEF80ncQpPvzBb+fJaDxX/xT55UttHqsGqKAvY0Cxzim2vfgyzAE1TjITtbQux
	ogNzlM34GGgtCOYOxRa9PmzlA4yczavcJqwMd5L+1BfQyiLmJJuRPQ13F13Z2gbLP7ZhfNip
	9XTKymLGjl2q7wC7vT1rKvkKd/dd2LRGLZEH7DR7lGaPKgMCHXDgY5NiZHz0aQ9llFwVyyd7
	hMfFGMDOaytubuW3gN9DgZ2AoYHETjRKtvBiUpakVMV0ApYmJA6iiu4mXiyKkKlSOEVcqCIx
	mlN2AmcaShxFF65wYWImUpbARXFcPKf4bwW0jZMalKCtJoHrK/MZ92U+DfrW7p9rTvmUsmBU
	x9O68YPSnEubM25sbtu5jWCfsXFp0TF5VOJbL5Pl+g3VoqOncCNc375dFXC113vhTZDfeZeB
	gtCiYYKoP0SK/yyZT5QG5auznu27KA2UjqVnPo2YarsbKfEyxjV8LzO5rQQFHFG1S6BSLvN2
	IxRK2V8pEuWd1gIAAA==
X-CFilter-Loop: Reflected
X-Stat-Signature: 1ieb3ztuxmw9dgd1ismngejrnmiz6uz6
X-Rspam-User: 
X-Rspamd-Queue-Id: 7AAF614000A
X-Rspamd-Server: rspam12
X-HE-Tag: 1773748257-534617
X-HE-Meta: U2FsdGVkX18Y6N03rVmc8LV5StJSzN/sL4+Z3hiSpwgDWHj3h/HPF8IaQ/bCTls1VQ5/+a6rhAFfoESGKLxnpLKBg1GTwJRKvupqO9S1K+lHl19JDUTSnG2DUNWBksGMaAwA+t4CaVXY5WfT6CJhKJU3zXAZ8Ndvy+Kj6Nuhd7krcgmoIGGV7rzftmY9VM9y8gjz7E0hk+uWpSVWQCTB6tJ89JbVqpV49OdDSh7hq8CTMbA1/0Xs8QNtTrJNOAa+qrYeZCYI5CXBOtF8P3zy6+7+YWqkkkBRqVQ9ESybSnODHG55Q2P/gqu3yc/OcFdVN5hPqER4HrRX7syxCUd/V0y1CW3zpQWgtPNjPmWVzLDb8nQvOEcDfysI2ecOStZ2ItXBX3JTKXEpDmLF/21o5RDEOESFyyjBMMq9xM3r8VEIOxlFn6RhrVwPlGo1f2nExZqav3GH+f4Xcvvo87SPMu2JD9S4hYaXTfYsvRh3WI5/Z7YvzQYlTLMxbjh/sH36TDq70WFQGGn8WkbndFHArRA+G4+xFauNLDFN2Xfk0JX/nzND+hLckrg6TgXJMo4hvs9Ef3bvdOdEqS3oK18OcMJ91sMP/jpcLCE0KqSCausk5HQtfW3fhzC/4ib0HPC2QFeX0zzlwwufM8Iq/0XuCUWdeOCZrxtMm+tHs/D11b25QA2p5oi95aFYlrPwEJ8d68jCWQPXdn26vdv0WeGLBT/J3aJ7lehWPAvytXrp3oEBz70WgGRanwcdYz3kjaSlSulCY2aaYhAQCTcmjie6t9cGJHgY2xSClYYS+lnMB1nAG8SJ/CPrAsNl+IbaqP03AUbenjjRNnZGW0m1GEJYk4q3vdosC7FHF7CJn3thTebMEIPi2uCmqMiN+pVLchPMW2EDoM5Ft7QSfpJgJtqCa2gsA9FEB8AWd6tUdKpzXV7RKS8VyGU29Dma+cjvsJBwt6t2FFgrkTD/QteL4Lz
 rWA5E1JL
 o0lsi6XAYYErsA4MIlWP6fP2QVakJVQFpsxPTuUJ09ftpZKKrpcZkstLSLXMroGui33Hu85cXgV+8X54=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Mar 2026 15:45:24 -0400 Gregory Price <gourry@gourry.net> wrote:
> On Mon, Mar 16, 2026 at 08:19:32AM -0700, Joshua Hahn wrote:
> > 
> > In that sense I thought the word "prefer" was a bit confusing, since I
> > thought it would mean that it would try to fulfill the alloactions
> > from within a packet first, then fall back to remote packets if that
> > failed. (Or maybe I am just misunderstanding your explanation. Please
> > do let me know if that is the case : -) )
> > 
> > If what I understand is the case , I think this is the same thing as
> > just restricting allocations to be socket-local. I also wonder if
> > this idea applies to other mempolicies as well (i.e. unweighted interleave)
> > 
> 
> I was thinking about this as well, and in my head i think you have to
> consider a 2x2 situation
> 
> cpuset             |   multi-socket-cpu      single-socket-cpu
> ==================================================================
> single-socket-mem  |     mem-package            mem-package
> ------------------------------------------------------------------
> multi-socket-mem   |       global                 global
> ------------------------------------------------------------------
> 
> But I think this reduces to cpuset nodes dictates the weights used -
> which should already be the case with the existing code.

Hello Gregory,

Thanks for your additional feedback.

I agree with your analysis. The final behavior should follow the nodes
dictated by the cpuset or mempolicy configurations.

> 
> I think you are right that we need to be very explicit about the
> fallback semantics here - but that may just be a matter of dictating
> whether the allocation falls back or prefers direct reclaim to push
> pages out of their requested nodes.
> 
> ~Gregory

As you and Joshua pointed out, making the fallback semantics explicit
is the most critical issue for this patch series. We need a clear policy
to decide whether the allocation should fall back to a remote node or
force direct reclaim to keep the allocation local.

I will explicitly define these fallback semantics and address this
trade-off in the design for the next version.

Thanks again for your time and review.

Rakie Kim


