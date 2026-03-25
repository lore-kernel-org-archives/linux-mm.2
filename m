Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52475109C02F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:30:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7E06B0095; Wed, 25 Mar 2026 11:30:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBE646B0098; Wed, 25 Mar 2026 11:30:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFC1F6B0099; Wed, 25 Mar 2026 11:30:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2BAF6B0095
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:30:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5D6315BB2D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:30:20 +0000 (UTC)
X-FDA: 84584971800.17.3000BE7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id D082A100015
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:30:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="hg/tY5nc";
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774452618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oZIRaXPgrY9XO92K3r1yFSjUBUwQqvuFyOUdxlhkPAQ=;
	b=XUehvSoKK5OT3UEYX7mxCUHr6pHqud/TclIsAfUoc/eZTwLXFAWRMyZLJd1tBRgySfb7iP
	5B+g271mJRVGU1TxUzMQ+tF+pY6FGBqgUgzPeMPosp72Sh/IViVI+ozIR8fG6y1naF4h64
	kbfH0i/PRPsExkziVXTja2OmczXvk9g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774452618; a=rsa-sha256;
	cv=none;
	b=RxxfU+aIQN7ZUm8uBW/IhB8gy4lRHCEmfLg/sQWz3dILFnKS2s7z5qTun565uz427h4/Lz
	G8lN26UDOfOLF92J0uIR3oAFjU+xnE8jtZ7DxKvRnfsmYw3NtRiuNdInwyFgxHhZN0JXH4
	1uitvLCOksLfs6UcFId79RXS8XuY3WY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="hg/tY5nc";
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D375600C4;
	Wed, 25 Mar 2026 15:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47386C4CEF7;
	Wed, 25 Mar 2026 15:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774452617;
	bh=ipt0qF+CvItlsG5F2muWd9cfvoSnSIi7qZEIATPqnBk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hg/tY5ncFUVkWwXBifZuAFbHCNb2uSb6fLwBzSq9v4Vq/c6E3Z4Y6MVkEn5ck4V1G
	 04hrNT6rzTHoPYKeRMOitF7vr5q3+6df2rnrVAzuH3rQM3W0mY/i8LLuqtWbxWF7f5
	 x+ZWu10/YhLx82NmzA2rS4bnS6g66aT0uS1R67R8=
Date: Wed, 25 Mar 2026 08:30:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Barry Song <21cnbao@gmail.com>,
 catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 dev.jain@arm.com, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the
 references for large folios
Message-Id: <20260325083016.a32095bea3f04488a7c9005a@linux-foundation.org>
In-Reply-To: <e227a7f7-0186-4d10-b7b4-c84ca8424bdd@lucifer.local>
References: <12132694536834262062d1fb304f8f8a064b6750.1770645603.git.baolin.wang@linux.alibaba.com>
	<CAGsJ_4yEWn3kVZPQZatOJX7NLLv-OK9pAqUDuWz25XxG5hpV=w@mail.gmail.com>
	<a4d7cf56-eab4-431d-886b-a32456e44736@linux.alibaba.com>
	<CAGsJ_4woBVQdYcCbN1Btr2vxOL8OAujaHkNZZ41=S-TdNh-wbw@mail.gmail.com>
	<d6820b1e-52ae-4ef2-8342-11818fdd0cb1@linux.alibaba.com>
	<43831628-a00f-4292-9797-cb96a029bb00@kernel.org>
	<e54e0ec1-b968-4e12-84a3-4e3d331b1c36@linux.alibaba.com>
	<86f611cb-1292-44e4-b629-6503135d33ca@kernel.org>
	<e5cb474a-a84d-4edc-8289-d68378feee7d@lucifer.local>
	<e3e374cc-ddf2-4112-b063-6cb1839ea566@kernel.org>
	<e227a7f7-0186-4d10-b7b4-c84ca8424bdd@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D082A100015
X-Stat-Signature: gjixjj5sztgch1h1ddrzenoxze597w9t
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774452618-336744
X-HE-Meta: U2FsdGVkX1/HK0IrijIqfWquWMTAPvJsZz2P3Bo/cm+2IP1PvoCGgsbKlCMjZZk1A1JK5i9TYDaycZ0lglR+nG0dKVLbszcDd3vMvGKh/fmxiQNiIj+G6Zp08c/CFCeI/uAev9/eU1r20XmRaNq0Z9SZi/Q7m0ZdtQaaptrMZCJJgXXCmiSn/6rQ8dlAsoRn29oHzcUw1taIRqSg5vJepxN7wzP2hbAboMNnuV2b8vhwrM4FEcgIiAX3AvDMifrPIeI7Mx8jK66wMbHFOIXZf+MpYYyw1g9jhvcJTde8qaHhlvPsHqccUcyujyNsnjVHXZUtPpl7QtnJk/OXy9AEhTHjwI0SmAiDoJc5p18ymsEQEMsVRTEU6jJUDuCdXCI2L7A1B5jeX8FcDEjBw8RtRDN9ejm+/Kkv1sDWPvt2bDIE3Y0oVMPMkmDsDYLk9vIQxHNYWhyD1zvcmBOEohrPvTnou+8pAoFGjzPWBE3dmNIjMi5J/l20PxmaJQxfWrooZQ0Dy3tyU9jvHkr0TUUhE0qWH7EMCf4nBGM+96yxgc6jVg+25mXutqdkYxrqET+MxRPraeUg5rKONra6d2s0L+J124+V6IsR9vXCB1sfG17asjoUX/rqd+RPFyRG7wkHZcvjBwxfPZk4uWaUYh3ngit6AeQb30uTGiBp0+l1GxDP7td17eNOsVGsF3L16kgcgW76B5Yo8pzvUFblk4ULsYTD3IXtwjBspwP4lTAUT2QaLo5H2qJ8i+C805pgFZ5lz49wQBr2GXeXX5g7v3czVh172OWQl3pbr6ZEIobFdKzr/rq1gMwmOeU7bbSTXXx307iaFslZbaRGslo45XSDPEHq4LkjVoaD/P8RjLwHMiEXNqcf96NZZbF/x0DOTIVz4hwEBgjv36GMYcBmnvlM6eJgsjUNSOp1PfWgOvIlqXM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 15:06:26 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> > > Sorry unclear here - does the series need more work or does a follow up patch
> > > need more work?
> >
> > Follow up!
> 
> Ok good as in mm-stable now. Sadly means I don't get to review it but there we
> go.

Well, this was sent 6 weeks ago, at v6!

But please go ahead.  If review is very bad, there's git-rebase
(happens sometimes) or some followup fix and a minor bisection hole
(happens a bit more often).

And those followup fixes will trickle in all the way out to 7.1-rc7,
via the hotfixes path.  This happens a great deal - about half(?) of
hotfixes pertain to material we added in the current -rc cycle.


