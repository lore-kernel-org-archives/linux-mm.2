Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4B96E7315D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 12:52:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 018A26B00AF; Mon,  2 Feb 2026 07:52:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEE016B00B2; Mon,  2 Feb 2026 07:52:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFE556B00B3; Mon,  2 Feb 2026 07:52:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CE4C96B00AF
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 07:52:00 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C39FB1FCD
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:52:00 +0000 (UTC)
X-FDA: 84399504000.27.0295132
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf05.hostedemail.com (Postfix) with ESMTP id B5BF4100003
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:51:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=fByy43pZ;
	spf=none (imf05.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770036719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yY07cg0hwKCQwR25CLGXxidJIQ1squuIk4ZcGlGC93E=;
	b=Uf8zMQXr+epwXmlkX9ftCY9GaIT92JAuBdGmMrIFJeeUiquvIgYvfwH1jgtSY7Txhm23zW
	Gk86OBdIlEwxDPoRdqthe2Rt+aHmEhvk2P/GzuH9N9tHizSfK48NmGc5sd5A1v7MG4z2KV
	UEhhHgXi/3EIzOwSFb3WQV/THB/lIaM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=fByy43pZ;
	spf=none (imf05.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770036719; a=rsa-sha256;
	cv=none;
	b=fFmh4dVC1WwFxJi3kSr9lxh0VznakqyqGmx5TuANnh28c8Z9a2M7vDajpaFg6aUxyx54ex
	lpxAC86bcrjgQ/UNLgDOlx8MaB6MdgPPcoKDasdyeZKsZNA2lbWIPUXdR0TZ5sHBMHTWjP
	kmwy22C43UM43aCsFlVWaC78t3Izpjc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yY07cg0hwKCQwR25CLGXxidJIQ1squuIk4ZcGlGC93E=; b=fByy43pZRv6IaSc7ayvOokHhhm
	5nHBXvsWjBjdd/xvRrfB8JohvFI92kqsc+T8fxnQS8DspTZJBokZ+++dD2QJ673IPcJR7hMFjZagM
	5kEV22tYADCLkQLgG8je7md7HqxtQGwQC3REA1XhKC0+SbEKiFX7am6PwbUYOt7kZh5H/x57al9U0
	SvCvl0kh8/DdAI2aqGOlxbk6ddSWY79OoHHR7Vx6h4gkngqasafqwe28K7Mef5K6oZp8j+OxWfo8W
	hH4pWxQqtb/6uPMkNeFaRG4IkkrYkI9OytHqnVhhXbns4/mDpnHL/1qVI6GopYwxVNLXMp3h/E3ny
	uvrKmnWA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmtPA-0000000ETbd-13uw;
	Mon, 02 Feb 2026 12:51:48 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E0777300208; Mon, 02 Feb 2026 13:51:46 +0100 (CET)
Date: Mon, 2 Feb 2026 13:51:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com,
	dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, arnd@arndb.de, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, shy828301@gmail.com,
	riel@surriel.com, jannh@google.com, jgross@suse.com,
	seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ioworker0@gmail.com
Subject: Re: [PATCH v4 1/3] mm: use targeted IPIs for TLB sync with lockless
 page table walkers
Message-ID: <20260202125146.GC1395266@noisy.programming.kicks-ass.net>
References: <20260202074557.16544-1-lance.yang@linux.dev>
 <20260202074557.16544-2-lance.yang@linux.dev>
 <20260202094245.GD2995752@noisy.programming.kicks-ass.net>
 <0f44dfb7-fce3-44c1-ab25-b013ba18a59b@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f44dfb7-fce3-44c1-ab25-b013ba18a59b@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: B5BF4100003
X-Rspamd-Server: rspam07
X-Stat-Signature: be7uyrz6ef5i5i1ui8fi3tk7x4z458h8
X-HE-Tag: 1770036718-555057
X-HE-Meta: U2FsdGVkX19Yy7EqpXGLIP5/RUxVQBx8n96HpChCBeGxvDfALs6A8kRDVTzvZEV/vbAJb0QTlJT/4O60gpOg7i/YF3Rv1bc+XP141dKCJtfKlMfBvDji0NEOjiYp3+nd28NWVSRY8p57Y4VLHdG1Wlneo+FUpsH6dLlMDp9Vom+58nasx71WNnuh3rFtkCMFi/KgboPhNaBF9K6HlUw1PmTBPueg8xDMN9m+mHB9ecIddUUBcWHwMEDNPavQvH8qmV5lFb7Q5S96AW8kA8IxJzZErKnm0oIbfnQ+/01fKdMSwAv5PzIXDoZXJNB0ZBqmGvU/gz6JZftVSOkvtF/BaYyHtToKm2zPY5IXbl26aGTZTdIj7BPuaid5DS/h+I0OlYiLoKVdJLLrGLMRW0DBTn83tED/WYTrq1dIp59wA2YcOtVEao/whBvsNXCmslJRxyrkBFPh+LiEkx8TN1Vw2ByE9MO8qrQVJOq2KEEkqg/xV2/Aueh0tiAlUHiNMFtqwQsR2Rooit4ell12gunIRS/NRn7zehAvs4sX1TZTKP5IgSQBRqz6H5forUJdP8N0+oiLZPT6ixEC/XMGLzHJlcRGhHMSokyDVmJd6YtX+cfGDtX3w8+UyFSbf4O+am5Ln1bSaGdHWX4TSZjgEYLlpCZ2MjC0B+D1Ri7zPkGSRSYJSO8U1DHfcSG/fFLzSH1CShs4JrSdL2wMKNZfLtnOpdjKQQ9w24H1MK3bmet1iIS270li6x/KXbbKqU2/cAYeD1mARI+NBLP3lkrtZbcPjvTEk6E2gWLFLaDzRihEFifM7w3af+eyWQEw8dPTe/IDGecO/+qpLWEIOxxPmhdztGMScuWxValELXaA1Z4jtSgP1dLlsB8VWDdTjAt1rQYIY42eHCkmi/9OkkDHSkvjxMzsbDMlFG/YQvNqLnWMWikYYpVnclf5+tfc26NATreQ1hdFMITwJWU1wf0zMp4
 ewy53H8B
 Jprb2xhrHEfGXcj9PT+67LMvQB2kjc+b3eNcjOOK0r7Wb3MfAGyjLFlgsryFMpTvkU8hA1CDImtBCq5UiNku9dGP96qtt9jVY8vr8ojKBbSOIDoHIWojjj0gp4Vc9/MQoRUdJyPRWZidYmTCOHYWE2/l07t40tneC72EMdPCZfVAksPtqg2QDGxw9go80H9sa8iGy4dJqGLB2TSH3MkXxD7ZNTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 08:14:32PM +0800, Lance Yang wrote:

> > > +	/* Pairs with smp_mb() in pt_walk_lockless_start(). */
> > 
> > Pairs how? The start thing does something like:
> > 
> > 	[W] active_lockless_pt_walk_mm = mm
> > 	MB
> > 	[L] page-tables
> > 
> > So this is:
> > 
> > 	[L] page-tables
> > 	RMB
> > 	[L] active_lockless_pt_walk_mm
> > 
> > ?
> 
> On the walker side (pt_walk_lockless_start):
> 
>  [W]  active_lockless_pt_walk_mm = mm
>  MB
>  [L] page-tables (walker reads page tables)
> 
> So the walker publishes "I'm walking this mm" before reading page tables.
> 
> On the sync side we don't read page-tables. We do:
> 
>  RMB
>  [L] active_lockless_pt_walk_mm (we read the per-CPU pointer below)
> 
> We need to observe the walker's store of active_lockless_pt_walk_mm before
> we decide which CPUs to IPI.
> 
> So on the sync side we do smp_rmb(), then read active_lockless_pt_walk_mm.
> 
> That pairs with the full barrier in pt_walk_lockless_start().

No it doesn't; this is not how memory barriers work.

