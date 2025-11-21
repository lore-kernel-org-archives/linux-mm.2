Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75471CFC29F
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 18:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BED7E6B0029; Fri, 21 Nov 2025 13:55:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B76106B0092; Fri, 21 Nov 2025 13:55:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3F106B009B; Fri, 21 Nov 2025 13:55:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 865146B0029
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:55:46 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B7A513040F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:55:46 +0000 (UTC)
X-FDA: 84135518292.17.A502190
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf07.hostedemail.com (Postfix) with ESMTP id C51CE40015
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:55:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="BMWllm/D";
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763751344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0DsHYhbJzZL1ITPLfZp78ILftz3jrH8Pcn/zoyt1NVE=;
	b=AmSOW40wuDZdu5+BnpMajH9QlbCDsz6LkXH/VJI5tWmsftqCJWDRJX/3hijqyOFY2jh1Ef
	0fK0cDvRbt5PK/O4LQoj/wO0ayf9GcqG3D8Mo6/SBj6nRhBcclskFQaRVbVAATBvovgSDC
	jXYc6bFg1ox7DfHB95OafIkB8G7WDUU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="BMWllm/D";
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763751344; a=rsa-sha256;
	cv=none;
	b=Hp5pmytq26JJNKPlG3xJEyCRMCVtqmY6m3BXeI5J+UMxyTAqRo6EykRm/tHmbCLojsScUL
	Ya7hpsY/SDRPOrH0yAVWTYJ5cZC+B7Gd+JeBTCqY+cv7S3tCCs6SziIA5xzbgkryfHsW50
	CinZhK7wEjCIjDf3P6DJSL+6CDPrBBM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc
	:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0DsHYhbJzZL1ITPLfZp78ILftz3jrH8Pcn/zoyt1NVE=; b=BMWllm/DIAjo3MsYJGc5Or+Y6+
	uYA0qsmTIJ9GUsMWYB4j47UYn5Bgt7Eeyasp0suvcPQ4yobXFKxnt37dyqvnwRXsz/YKIvXx/aPqU
	gkloOMo8mzTzVskBXU3dkkn9DBQGI0rz0gL8SsWyfrx9NafYr3rD7Wl8JbJXpQalNR79jUSvb1tWp
	pZsir0i03XLuykr2RPc4mFzvgstwCXEtpjUEp1e05gQZNhuRKUCc+PIRhWJRyvv+zfZpi4ks50iPE
	3oN3yT71noOnqomQXNnYrknW7saXQSgpBXdBi5OuOKeYGlBzBPZwx0DmpkyqKp0z919QQpzWqhZku
	Kad5LI3A==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vMWI9-000000003i4-18wR;
	Fri, 21 Nov 2025 13:55:34 -0500
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	x86@kernel.org,
	dave.hansen@linux.intel.com,
	peterz@infradead.org,
	kernel-team@meta.com,
	bp@alien8.de
Subject: [RFC v5 0/8] x86/mm: Intel RAR TLB invalidation support
Date: Fri, 21 Nov 2025 13:54:21 -0500
Message-ID: <20251121185530.21876-1-riel@surriel.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C51CE40015
X-Stat-Signature: 575iscs46c94rdbc1coz481wg8tydj5t
X-Rspam-User: 
X-HE-Tag: 1763751344-205381
X-HE-Meta: U2FsdGVkX197FWeUxhioJrqtVde2msNKMUHJ5rGKBzJwjFJI5uo/Z5PjUvsIjvO9fXIOWWQsf565C5aQ+iu3aS48RNhY2VyjGilA8UWoeVhA8VquYmwfskAhfBEMJaDwCCrKNACRbgVh1dmhCM7KvarAJhFyFGc/TC4Wh1ZJEWTbUBpKG93gzCB6xSEQRhuy0cgbT4A2dJp9KoG2sMav/ZwD8GB3cIck6uDkGb3merlTdCCxTh+jyqMO4WMuhze9EgugRn79sANKFw1K1SLUF5oKr02zVzENXFx8elN9pS/5bG6fIFs79R7bscYSBUAjdfSyL+eg+m7LQDVnJ+pFvEKlwvDVE1NBn8drbGKnhqa0wBal6g6OtpyQ4U4jtbLeLZl0RsmhxYmvNU93IcuzZv5tT6oiDp1pzGMYq0Xwk6rG4oV1VCMIva3soekdDo3qeeypKkLMyn5wyzHBl7j9BiOM5R/UglEHP2296i7p71yKlYftzY+6fMR4KON/98zCPoLcd/KOlw7s/ldKN51yCuic691aopFQGziTw2CN0RZEkHYRyG3d1QYEklZp6AS6UTij7+okz7LG0yiHWlDvUn5WwyADrp/2edchupxBb/k/Xtue70iGBVe/tT9BmNLP9AZjr+ZAF6KCREeQ6nJRtTF1PJFwPDZ2LD8l70KH28aUHGswxPmR30coQpaxljxRzZPNSU7SxDfHXdLRUmZGqfr682NPj3ZAua3MrJy0TI9aSL4f9WTGNCMunA4URnBu+4qXda1ZI9d6f3qESNh3yxH1MWXeQaPKndsxys0CAjcxLeNxSmzp+BoUpRO7dzkHOG9HbOo+7hr6lQ4y+1j0Q13AGSkgEyXtKBVj0Hmpe0R2J5ZgAiwcJqlp2kIuRa6iU/tsLJ7UMadmIPOSSArajqgc/tpcpmWmnO4rB3+2GscSseQONJU2ja8SZujqldQ2l/rx13sH6tz7pj8StCX
 m4NfrM57
 /5w1iJlqntNE5VlWbnDT4IJw6WTnUk5lik8izoe7VcF949Z6WiqDU8VgXIhn96yTodduLaEaZTiTELKWElb2SsZgEv/JUOAiP3RDCwb8hIGL/TX1EIpE0VDalZOZoscYLGyOtRNxzYHzfOsTatNVZGyh2Dn2tzUc1UYu0JU87F0Tdu38a7mRGNfV4TpZezOYRZP5oQSJOWtOSfJq7foPzhylPH2fIoQ3O0HUOqiOXMJtKwRU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series adds support for IPI-less TLB invalidation
using Intel RAR technology.

Intel RAR differs from AMD INVLPGB in a few ways:
- RAR goes through (emulated?) APIC writes, not instructions
- RAR flushes go through a memory table with 64 entries
- RAR flushes can be targeted to a cpumask
- The RAR functionality must be set up at boot time before it can be used

The cpumask targeting has resulted in Intel RAR and AMD INVLPGB having
slightly different rules:
- Processes with dynamic ASIDs use IPI based shootdowns
- INVLPGB: processes with a global ASID 
   - always have the TLB up to date, on every CPU
   - never need to flush the TLB at context switch time
- RAR: processes with global ASIDs
   - have the TLB up to date on CPUs in the mm_cpumask
   - can skip a TLB flush at context switch time if the CPU is in the mm_cpumask
   - need to flush the TLB when scheduled on a cpu not in the mm_cpumask,
     in case it used to run there before and the TLB has stale entries

RAR functionality is present on Sapphire Rapids and newer CPUs.

Information about Intel RAR can be found in this whitepaper.

https://www.intel.com/content/dam/develop/external/us/en/documents/341431-remote-action-request-white-paper.pdf

This patch series is based off a 2019 patch series created by
Intel, with patches later in the series modified to fit into
the TLB flush code structure we have after AMD INVLPGB functionality
was integrated.

The stock hardware needed some tweaks from Intel before this series
will work. Contact Dave Hansen ofr details if you want to run this
on real hardware.

TODO:
- some sort of optimization to avoid sending RARs to CPUs in deeper
  idle states when they have init_mm loaded (flush when switching to init_mm?)
- figure out if there is a way to make RAR actually go faster than
  IPI-based TLB invalidation (getting closer?)

v5:
- Add optimization to avoid heavy contention in apic_mem_wait_irc_idle()
v4:
- remove chicken/egg problem that made it impossible to use RAR early
  in bootup, now RAR can be used to flush the local TLB (but it's broken?)
- always flush other CPUs with RAR, no more periodic flush_tlb_func
- separate, simplified cpumask trimming code
- attempt to use RAR to flush the local TLB, which should work
  according to the documentation
- add a DEBUG patch to flush the local TLB with RAR and again locally,
  may need some help from Intel to figure out why this makes a difference
- memory dumps of rar_payload[] suggest we are sending valid RARs
- receiving CPUs set the status from RAR_PENDING to RAR_SUCCESS
- unclear whether the TLB is actually flushed correctly :(
v3:
- move cpa_flush() change out of this patch series
- use MSR_IA32_CORE_CAPS definition, merge first two patches together
- move RAR initialization to early_init_intel()
- remove single-CPU "fast path" from smp_call_rar_many
- remove smp call table RAR entries, just do a direct call
- cleanups suggested (Ingo, Nadav, Dave, Thomas, Borislav, Sean)
- fix !CONFIG_SMP compile in Kconfig
- match RAR definitions to the names & numbers in the documentation
- the code seems to work now
v2:
- Cleanups suggested by Ingo and Nadav (thank you)
- Basic RAR code seems to actually work now.
- Kernel TLB flushes with RAR seem to work correctly.
- User TLB flushes with RAR are still broken, with two symptoms:
  - The !is_lazy WARN_ON in leave_mm() is tripped
  - Random segfaults.



