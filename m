Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78FC310A88EC
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 17:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3E836B0005; Thu, 26 Mar 2026 13:35:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EE446B0088; Thu, 26 Mar 2026 13:35:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DD456B008A; Thu, 26 Mar 2026 13:35:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 796D56B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:35:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 201DA1A0EDD
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:35:40 +0000 (UTC)
X-FDA: 84588916440.17.FA835BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 868CD80010
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:35:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qUachqP8;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qUachqP8;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774546538; a=rsa-sha256;
	cv=none;
	b=tN2T+QrwyPo7OMJB7/9uyQSKsX79qbpUimQuvUo3O6/xKxWOO5sIb2N+/PhDwm8oa4RA26
	gVPBAf9J/YJnWVxKfoY/tqhR8j3/VwS+Cw1bGDGsNS427Sa1vR5ddAQ2i5tmJrfI+SDhNX
	IQBLRCHPuXXt/MgJ12Fk9UWmCZJ2tXc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774546538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fJ3JXuw5z5kNe+Cp1nJve+mSJc/gwq6EnmfA35jmCeA=;
	b=KVXkBpEK77bilPswNK9hVKoNGhoWZ5uAazE3HT9WMGilxuGcisnTaP3POpNiQtDOwahm3A
	AlCyV+Du4ufteAKBIIQVnz8cOraz0zS6/RSxey3nJjXRlMxjE4t6WNuTBQIc1//Qbh7AGv
	FyD8RBZxzPEOmkXdbXOEWaKbawiisiA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D9587600C4;
	Thu, 26 Mar 2026 17:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB193C116C6;
	Thu, 26 Mar 2026 17:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774546537;
	bh=TyHE5OHGZzs2RnxkcfysEFZpFxuV6TaJanuz3FP869s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qUachqP8BOzbrgG4HSlaAq5z/goqf36IFKMEuWcVmA/ezszARsNmy+/kABUgsNV3T
	 UYvZwIu1SYn/sbvhKglmJ7PTNodBNVf7gbosR4DzSdtShwsx2qsOd/zoaWbXr96hvs
	 zhjgv0MVqSyjDriEvfH6HaAwBk/PeMlOr5UhfzeY=
Date: Thu, 26 Mar 2026 10:35:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, aarcange@redhat.com, anshuman.khandual@arm.com,
 apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v4 0/5] mm: khugepaged cleanups and mTHP
 prerequisites
Message-Id: <20260326103535.e8f9092bc92a084f0e78ce07@linux-foundation.org>
In-Reply-To: <CAA1CXcBqOVkUZa_UQh_niRp_GGUMZUSS-6CSwOWZkrpMT_MadA@mail.gmail.com>
References: <20260325114022.444081-1-npache@redhat.com>
	<20260325172500.990e240d813a4b2db300e0e9@linux-foundation.org>
	<87tsu38aig.fsf@linux.dev>
	<CAA1CXcBqOVkUZa_UQh_niRp_GGUMZUSS-6CSwOWZkrpMT_MadA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 868CD80010
X-Stat-Signature: ac1qzh37tpjjetbyuxccdyoj4udd54b5
X-Rspam-User: 
X-HE-Tag: 1774546538-324203
X-HE-Meta: U2FsdGVkX1/19J/W47k/M0F9iEzyw+tDzAuhQHjLKmyKmurMZ1oyK3QgqYqzfkjS6wmBO0bcJTSOH3ihZ6ESdtfRHRvG2mL8ir40RrJByy+f5VuSoVHwB2vnFxpj6+WfdSP5e/AKv1JYdyjndj0nEf1oJyl0AqDmgnHx17Rj52+sB3KItxt+6s4pUT6BcbiRpGtRwWDzy7rX/mbtOIBScHIEpfDl5NiFr7d8b5IhEDDFweqwj4WKKKtApU5DTpzl+M8igMlb34pe4nAFI00K1RC//EoO35P0V+OtEhhgKCDDJDS1tYFKEAT0V0TVyH4g81kulKdngF33Wx6iDsHL6HiLkV0tsm9eamGA/VBysXzkVSITjnz0V1Lm8THgH6flSP7O8ahkk1NaF2SN/M9nn+jSDs9ghQRAXvKmzOYebChM4XS9qhepp0OMxD6NpGPunN2ipiRz3hPr30jloyc0B8wSe1SDQGlsM4UTlBcCh1KAy6YsfXaNsRhdKyZV0W3DahDw89Jm77tt+CWtFYWsXxBSazsW1mSbDyY7q7vqnLFz/FWTo8kzMzr96yMNxdxVg75cgdnTHOjIKyextgwGpuEVRg4z/grJWNJMjqiI39qnocbjkji0o/o1llhXQ8FXrRHXIljWDPqBc+F5rQQnAdLvWGf9sOcmGWdVVp8a+eiJPSOq11xdOVVqKZyGC5HEYw/e+ju/mf5Zk0bs7VzazQnDzQ+MGWNep5dExFXlHMmRKs+ONanI2xSfyNRML3ryCPQoGOGwE63eDPRo17rpjlvPBYvQInqgOemOI470FnWrnfypFVKGi8xaDKgwWrSnsYvdDzoM9HlTs0iR2BsxY2Qfh/Yif8X0EUiJmdhmvjaQfayhryKGxM462sXzsEOozdJPBfuejHnfdSmERvShw/1in1ovmZtZ2HwTQ4vsl8154+U4rMQO/vTwgzBQ0Ll1mP1IWM2T2bBZq/MkaeI
 /2jNjO/M
 snmtJs8mORUP+ElJivdQ6HLj0gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 10:48:13 -0600 Nico Pache <npache@redhat.com> wrote:

> > It did, but for some reason it failed.
> > You can actually see which trees/branches it tried under the Baseline
> > section for each patchset. And yes, I need to improve it to log specific
> > sha's, not only something like mm/mm-new. Now it's kinda hard to say why
> > it failed.
> 
> I dont think this was Sashkio's fault; this doesn't apply cleanly to
> anything other than mm-unstable with my patches first reverted. I
> first tried an mm-stable base but my code is now dependent on some
> code in mm-unstable. As Andrew noted, I should have requested that he
> pull the patches from mm-unstable before resending them.

Well, you'd be the first person to do this.  We're still figuring out
how to use this tool, taking it day-by-day.

It would be nice for you to have the opportunity - most authors are
appreciating the AI checking.  It just caused Brendan to describe his
own patch as "complete rubbish" ;)

But don't bust a gut over this - let's ease into it rather than aiming
for some possibly premature step transition.


