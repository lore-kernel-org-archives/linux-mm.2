Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EFAFCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 23:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CAFE9001F2; Thu, 14 Aug 2025 19:28:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255309001D5; Thu, 14 Aug 2025 19:28:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16AE29001F2; Thu, 14 Aug 2025 19:28:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0108E9001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 19:28:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 87940117FAE
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 23:28:04 +0000 (UTC)
X-FDA: 83776953288.01.540A83F
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf29.hostedemail.com (Postfix) with ESMTP id DAF58120018
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 23:28:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2nc3wY6H;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755214082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MEAN8shHJQNqQSxh89+okz6oC53z2wcJeKfPPXsVYNA=;
	b=Y0OBwhF83vJjBm0zuGToLXy8isAt5aUNF0iMK5SD8b6sQcSWTUpdfIIoa1wfMajNXnFm2Q
	akftItPpJfdYPK+lrHyMxnUJWbURI47vSCR9gIM0B4CGQN4AH9ZeJV0dpdOnwTAV6QwfIG
	7U7FCt1QF2QY6CcDT/ca+NQh7nuEIZc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2nc3wY6H;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755214082; a=rsa-sha256;
	cv=none;
	b=bK87C8Cg4Uu97iOB+sS1Jy0P/f+836bLvN3R+VlbLquClxKerjl3DngXNIS+sEgB3746Vb
	2s2tb7u5YeGOY0sK/xxXZRQtv+GVuCErkSjBcMflM5gqkM+OLJufQwQqtkwkxoVlzRdhev
	Efqkkb4yrEYfapXuFnaLYLGY968RO1o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 25088A570D7;
	Thu, 14 Aug 2025 23:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6933C4CEED;
	Thu, 14 Aug 2025 23:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755214081;
	bh=RKMPJD91oygjixSsHWj5e0vCdzOp27ndBzqTMRaZ2B4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=2nc3wY6HZVO3TgsWr3n8qKoRazbe/rFSYW3Vu93F4/XRHsdO3EVO88kWu5LBU/OvL
	 A86xKo2De+y2rzau5wNNTNkps2GmviyfmIGMDqH+wkOPjtgagU6NOLcp3/dL2HwaRA
	 Swry8zQyOTYUXdG5XbXofKKu+LctVQ/C9k25bh/4=
Date: Thu, 14 Aug 2025 16:28:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "Herton R. Krzesinski" <herton@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/debug_vm_pgtable: clear page table entries at
 destroy_args()
Message-Id: <20250814162801.08ece6844de66ac43af5224f@linux-foundation.org>
In-Reply-To: <5e5f45c1-e813-4900-8fad-2ed0dc067468@arm.com>
References: <20250731214051.4115182-1-herton@redhat.com>
	<5e5f45c1-e813-4900-8fad-2ed0dc067468@arm.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mq7r4eqawzo5kjkdn8twdwakedf7onum
X-Rspam-User: 
X-Rspamd-Queue-Id: DAF58120018
X-Rspamd-Server: rspam01
X-HE-Tag: 1755214082-764886
X-HE-Meta: U2FsdGVkX1+aYGU65V/Ixwm+UyC1k0ekG3g9efTpy2tCuK+U1yUbEl3jOd8KvKo1yXgdlSNXaxEtucO+kc/s2+huukTt978A1iWtOwvVhLLoxWjxb6CPITICD9z0muKnW9qYMjEW+VCumUh4ovGxjyXzKK9+DOV38g6nRk5c7RK+NZdiOGX77Ta81UiZVXa+LXJgth0b5W3UynM/TR+a9df4i65mg/1zlr+fQK96ZRXog0/kj9eVelxTk3DmO7ONPoqQBh6Fj9a5Xld2/oyGdwCxSZfxC0U/4FqMFHGTHAo+N5mgFwTVSrVadp6WSP+e4v5yE3NHxNFhPZDRnUnHXSZic3iAS8Iw+td5/oRxCMPW2MLQb3gCDlMomPuPT0xT6+e5kmx8+LwaJFJwL2K4HuXC44lICeFTZd3uso3SLiFUZtFyMX4xS3sagCcWBhj0rxOEJzt36yEJvkajmYZDOqy0ZF1RuZzFwJVI9gbCNt3RHgP84AlnbcOnGeXyzW0me+hW7YldiecboWx62fALt8q/9MoVNXWJl8KAc+M37Me9ws0HYmE7wV1zmAcAc293xHm9vAWa6HNFLoIPy+tB2D2JUxd24ETYDRjR06XIXEGSHDgur2YcgMvGTs33TBr5JFkrWSA81xDONdQUax8falFez5RefICnyYve6TvCAvP5tqAVFqFBbBsZ8a/IiilEpJy5F3rAbLzGrWsKIQx6RxQ+njgcOrTHDueneyhasvMVGhT1V6mkEA9ZJGbBI3rQ96bhIjVFf0M7svKugJ7ODF7OqhDGT+cIqCXI5qr0mymhIwb8S+KP8kSM59VV/22XbOuf8nETOLlqpdf7a3MyEgBciaoGQgM3OYqatgC1/Z7ig9rGuXFRirDxMTtYGufpUmeaDObFUqTMZ6fOt37rqD3V0aArh6U5CxCe73+jQpbMChzjqEM+xMmjQPtzSTubyho2/0JbXsy1BvT+8aF
 Ad4ER/mI
 nDF8rLZnSkZaDJz2bQ3o0FEmPa4Eld+dNPexTwFONy4MK+jzcWMh5gIYXOM6dqkfbFEw7yseAt2f2fdHw8IgiOkhU5FpKCQC1td7q1+ZR9TlBUbBCg+g7qcFHs1G1qRKFS05XwMBmuO8y/mlVY50MaPUyMgmJXAUWILBUfnTrBknSaC72ipYBm6Lluw2IX3HH2sJGmzcsOauEu1cQp8sY6pmhJmTKQRb0z4NA3ut6wYe4QwuVdAZogW9x/QPl3b9bIDsNEudA4mYx/pHzDMnDWJm6u3F/pF5oiRK7kGN97/NxnVt8Z8aQm8O/IyEXcaH7745tFOe34D0AN2/F7LSZLYbwLf0bpz++jZvz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 16:16:03 +0530 Anshuman Khandual <anshuman.khandual@arm.com> wrote:

> On 01/08/25 3:10 AM, Herton R. Krzesinski wrote:
> > The mm/debug_vm_pagetable test allocates manually page table entries for the
> > tests it runs, using also its manually allocated mm_struct. That in itself is
> > ok, but when it exits, at destroy_args() it fails to clear those entries with
> > the *_clear functions.
> > 
> > The problem is that leaves stale entries. If another process allocates
> > an mm_struct with a pgd at the same address, it may end up running into
> > the stale entry. This is happening in practice on a debug kernel with
> > CONFIG_DEBUG_VM_PGTABLE=y, for example this is the output with some
> > extra debugging I added (it prints a warning trace if pgtables_bytes goes
> > negative, in addition to the warning at check_mm() function):
>
> This has been on linux-next for almost last two weeks now and
> no problem has been reported. So I guess it's all good.
> 

[top-posting repaired]

Thanks, I'll move this into the next batch for sending into mainline.

