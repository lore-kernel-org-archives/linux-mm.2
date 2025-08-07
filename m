Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52561C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 22:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ECF68E0002; Thu,  7 Aug 2025 18:54:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C3208E0001; Thu,  7 Aug 2025 18:54:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 500468E0002; Thu,  7 Aug 2025 18:54:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 40CBF8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:54:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 97BF982254
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 22:54:04 +0000 (UTC)
X-FDA: 83751466008.02.0F5F9A8
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0CB63180002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 22:54:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LJ5ETs+A;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754607243; a=rsa-sha256;
	cv=none;
	b=3DYmAhtTh/PYdf/n3kuD5U3lLT6/wUEL6pFnzRyMBxLvdjtDweVMgaDn16Wg2KlTRQ+xZ1
	nHGD9RYYyeFYVFXDLWU+MRlgbVK3bs9f+vx7a7rT1Qf3BzzcO1xIc1hqVzZPEc0DOvb3sO
	XzaNJUaRIKKNGGunh+qPpDHNuPdUhZI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LJ5ETs+A;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754607243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4DJvY1xHMS++s+SKxLLsoEYWqytLc7PXvw6Yyc9gJtY=;
	b=V8IbumGIP9uCK9lFXgLqet8vac80T3X0Ve5mPNdl0TqfAiAsnyMtsJFnRcarQY1/ByF59F
	QL9ew+Ww6FQ4uWroPxdfnBlabWFuH4iL296huGwtxniQBK+hL3g1rTCXRjaf61wKP5y3Zc
	+eEZ9XPKWRGXR65UFv+g8NR5/HrOE/E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 50D35A567E1;
	Thu,  7 Aug 2025 22:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F9DC4CEEB;
	Thu,  7 Aug 2025 22:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754607242;
	bh=yTxomUojmR5ID0F+z/FwDbe6uM8bu+LgQm9RYqbWYzs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LJ5ETs+AxmbXea/uHsVXOIXY4Zhn0UQoSkETvcS25bbsuKqckwwZ9aCS3KIyPkD0v
	 elTmXugxMwPUplL1yuCSzk0AT5mqDpEcJG6X4i61ND5CnLAPC0eqK8j/SIi4OFltwV
	 lzVG5JbZw0WItpPuOP8tj+KtUyyR4JiKmthmGDt8=
Date: Thu, 7 Aug 2025 15:54:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Xu <peterx@redhat.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>, aarcange@redhat.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 21cnbao@gmail.com,
 ngeoffray@google.com, Suren Baghdasaryan <surenb@google.com>, Kalesh Singh
 <kaleshsingh@google.com>, Barry Song <v-songbaohua@oppo.com>, David
 Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v3] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
Message-Id: <20250807155401.683c77b0d0cb5c9ec88089e6@linux-foundation.org>
In-Reply-To: <aJT7qQzEs_p36yfI@x1.local>
References: <20250807103902.2242717-1-lokeshgidra@google.com>
	<aJT7qQzEs_p36yfI@x1.local>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0CB63180002
X-Stat-Signature: rdi5wrku9idqsfsqs8jk4u69n9tqajur
X-HE-Tag: 1754607242-687607
X-HE-Meta: U2FsdGVkX18QsURPLDVwC0RBxPhkDZVwFeanUEg/oSfmSfKUFPyYaH7Nq0CQp+egXUCoq3EIUwYTflr0vWHFLupJ2Z2U3UfgcuswZpYroXMlOC87WaGT35llM9+7hdO9AB31v/2+NRKYEuQyWEG3ZAC7Cm/6Ky6SSA8lxE1TYPVEZKGrO/ajRkl8t39CBO/1bWABp5W8PqgWXW7exe7VfqJ55d/pnviQqUpKoyX2zb8rG5ADkSrCU1rH2zVzc3yvuyJTnST0CjuNWCOXWAeG8C/t/34PB4aTQMG73XsEsr9FrFIZLkUgJjjG05K85tLjTsQWi8rhpp0sybF8VDlB4Ets1Ds3aP9iOTWyFjBp6ZzWxI9Mbdy5HJvsFZk5w5LzhrZjLROFlowhP2utSiylyIJMaCHggCcs14bZzTGXpTPOH5n8W3MRKQJTYwNS81DXVeq+dKiNPX1zKXEYB11Ahg35pjkLlWYtc8tSJYvjc/DbZAV7sd89gAGxAsF2tSfWKGlJuwNwdPx5CGhf3RxfKNi9RV0UI7dEuYmmNO4cNYVHM0ww94cht5Mie4+4A3my0OXRle4rJlxTcBsLpfbOUdVg0J0oDLyrQ12icPg6orM/s6Fi9ahOM/mTl65cOigqFyX+GKAZf9etNYqEEiNR+Lc9JPTF3Ceoq0Nos1SkkezRoK62U/l2YT4D0hYyFjhRmXhjarPZnazmxepUnTB8qQzu2nsGQKvtx+HZoYDa83EJ2Db6DZ6ZvGQaXqthuxTuXcjgmqMPrMkuJlSADmahEVF+mHilccBT2jUVCCHULJHAg9EjwrjqClwgfXVeRiHABAt7OzVHjE2Sa20SveOLC0xpy15K3NGGYpebjT4wIPDLI69neNnSDN140glfiABokD+NiuiSnEF4wCaSDtnN41q6owaPWAKwbKmqU6BOz50=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 7 Aug 2025 15:16:57 -0400 Peter Xu <peterx@redhat.com> wrote:

> Hi, Lokesh,
> 
> On Thu, Aug 07, 2025 at 03:39:02AM -0700, Lokesh Gidra wrote:
> > MOVE ioctl's runtime is dominated by TLB-flush cost, which is required
> > for moving present pages. Mitigate this cost by opportunistically
> > batching present contiguous pages for TLB flushing.
> > 
> > Without batching, in our testing on an arm64 Android device with UFFD GC,
> > which uses MOVE ioctl for compaction, we observed that out of the total
> > time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), and
> > ~20% in vm_normal_folio().
> > 
> > With batching, the proportion of vm_normal_folio() increases to over
> > 70% of move_pages_pte() without any changes to vm_normal_folio().
> 
> Do you know why vm_normal_folio() could be expensive? I still see quite
> some other things this path needs to do.

Maybe as explained here?
https://lkml.kernel.org/r/20250807185819.199865-1-lorenzo.stoakes@oracle.com



