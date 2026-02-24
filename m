Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BFEDE9B258
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 12:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C127C6B0088; Tue, 24 Feb 2026 07:35:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEA496B0089; Tue, 24 Feb 2026 07:35:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF6196B008A; Tue, 24 Feb 2026 07:35:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9E45B6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:35:48 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 53DB81C549
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:35:48 +0000 (UTC)
X-FDA: 84479296776.17.0B1CE49
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf02.hostedemail.com (Postfix) with ESMTP id 86F2E80011
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:35:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="Mb1Y/bzC";
	spf=none (imf02.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771936546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NmoZ7yGJ/UNmDeoZv4NVg492ij4hS7di67j0tIjaI44=;
	b=Et2Wzn1/DUM9R900zyKWdhPKZMJvLTWHZ0tdBciQC7mSSjuciC5zNsGwhkLvyIRjbp0VlJ
	LSt9tpSNTf+52N//BCQLkUhlEEBkPSGWrOW+RNl/RjlZCDh3//d4sMgj61nQxCsZt+hVIo
	vyQbRozfAFR+Fg31Kf1073Vs0XKjPKI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771936546; a=rsa-sha256;
	cv=none;
	b=1oFQiHrjtIjMrpZzsye2Q7X+MwaDm0Q5Kk527yIqFDaa5tcl0+h7OIPINKBbS/kydbTsu+
	uGm+ssGoxG9m7+smeExQ+TN3QruPrSrHQf+HX/b9hZ+aRrEajleNpSCXFfURLFkDjE4HrD
	ucYJB3JiFLTCvzxrggrAqcrTvOio1cw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="Mb1Y/bzC";
	spf=none (imf02.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NmoZ7yGJ/UNmDeoZv4NVg492ij4hS7di67j0tIjaI44=; b=Mb1Y/bzCW8J3tp0nmMGZqbjymr
	5EX5/+a+CBFyQdjkfeY0I9l1y7F/QqiAxPTkIcX0JRls+skfPSD3p05DpDataRXPFzz1ayrY3Q0vl
	TDNDXUHKzKSIA5m/fAfzZTSyIi6zA1cLvKC7OkL4alEbpG2bBz6QgAdhusVTxHL25/fCmoclIduXk
	zTIlExN02ALquUMvlrmTX7zdOszPzuie/d413jqURBzfo2JC37LPixPwAo3Zqh+I9bZ0EknT4HevW
	Ncy5VAeL7zTMmC95PJNeT0ONdIO8tbbj/Fl/lEwp+gYgTsdNssWNZoklmqPJHKJJlUQFmQUXNQY4g
	zlLOVZoA==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vurdg-0000000761b-0wfK;
	Tue, 24 Feb 2026 12:35:44 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 8E54830095A; Tue, 24 Feb 2026 13:35:38 +0100 (CET)
Date: Tue, 24 Feb 2026 13:35:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com,
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm/mmu_gather: replace IPI with synchronize_rcu()
 when batch allocation fails
Message-ID: <20260224123538.GW1282955@noisy.programming.kicks-ass.net>
References: <20260224030700.35857-1-lance.yang@linux.dev>
 <20260224114152.GX1395266@noisy.programming.kicks-ass.net>
 <5cc90e7a-ae32-4352-8e0b-2eee5a5ee122@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cc90e7a-ae32-4352-8e0b-2eee5a5ee122@linux.dev>
X-Rspamd-Server: rspam09
X-Stat-Signature: kg8z4nzt38fbo9bzcenfnbqh6xd7s1jh
X-Rspamd-Queue-Id: 86F2E80011
X-Rspam-User: 
X-HE-Tag: 1771936546-881473
X-HE-Meta: U2FsdGVkX1/hUzDL4/Hno5w0VcVh38PqSArwe7DAB2SxSFP2vkY7FOAZGgB7mwTZLGm2naXQ9HfljrqrhoG8paQXAiuyLyC+OOQ9gfSnD7ryoZufrw0xc0Dj879Dnpm9Qx8XczX/swDub862hOrsxMyX96Xbx8LPdx6PMixJX8EbyoDzmJ278B1JpDY3WAU6+F+4OlxshzlEPQSPgP7Kc1cDG1kl4Udgnw+C1DtjJVdjF7HfkoTEnc/UdsXUp6mWmLG6vu1sdhBfmmpYNTzZTUVY38PbGY9i5hymqTt3pLJO5BYI/mTJpeBHIZN7xzlkrZS4s7OSQkbGwJNL1y9qTnPJSaAOEwKqVJpSbazmG1bIuE0Tfk9mq6hAqGsncPoBYFizKU3MXTJDCv6J8R1jJ+nYbYkDMGfcTHJ1yFqjXqm3jKYb30NLnmbyZBhrZe7EL8ybCzzidmwut88dGhAfQT4OJwlBqHi8IQBsNVFjGW6kk0uzyc9nIXcs2HCpIqr9twc/SyEQS934LAu65PlLP83ncKdLdV58Sun5cb/oe9bNa/QsABaxfMqfgfgBa+iCVufcCjmrFE4Zr+jMYIFAvZlQMoPo793FZngH+lKlrUPKdHoXMdPtuLe60T5TbbgCHa5Rdr7s4ERVE6u3JJuR5hSe7AA4rEAM9rkOWc05H89CAACwHkPgjZ2Y/8ukY9JMldgaBvA+05Qd9luuOfZWb+gDPojNSZgMN5gtHP1WxxyEOTq8TcW13g8BzGEMROUjbAADEsPvYC8A4MxgzRD9ROLYFrlW7/RpMjphm2X1a1il4z7FhjBt4wZhRcVJQAR6VwUodgzqsA7LD0vwntEdtWJ0zdhepDfS8IrT11e6sZzLTLGwzFA481Z2hGTvnEXA10a2LTwL5Qf3pdgGg9V3KyxkDrM20KzBShSVBkDNhwkVcHQ3Gl31Aw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 08:18:46PM +0800, Lance Yang wrote:
> 
> 
> On 2026/2/24 19:41, Peter Zijlstra wrote:
> > On Tue, Feb 24, 2026 at 11:07:00AM +0800, Lance Yang wrote:
> > > From: Lance Yang <lance.yang@linux.dev>
> > > 
> > > When freeing page tables, we try to batch them. If batch allocation fails
> > > (GFP_NOWAIT), __tlb_remove_table_one() immediately frees the one without
> > > batching.
> > > 
> > > On !CONFIG_PT_RECLAIM, the fallback sends an IPI to all CPUs via
> > > tlb_remove_table_sync_one(). It disrupts all CPUs even when only a single
> > > process is unmapping memory. IPI broadcast was reported to hurt RT
> > > workloads[1].
> > > 
> > > tlb_remove_table_sync_one() synchronizes with lockless page-table walkers
> > > (e.g. GUP-fast) that rely on IRQ disabling. These walkers use
> > > local_irq_disable(), which is also an RCU read-side critical section.
> > > 
> > > This patch introduces tlb_remove_table_sync_rcu() which uses RCU grace
> > > period (synchronize_rcu()) instead of IPI broadcast. This provides the
> > > same guarantee as IPI but without disrupting all CPUs. Since batch
> > > allocation already failed, we are in a way slow path where sleeping is
> > > acceptable - we are in process context (unmap_region, exit_mmap) with only
> > > mmap_lock held. might_sleep() will catch any invalid context.
> > 
> > So sending the IPIs also requires non-atomic context, so change there.
> 
> Yeah, you're right!
> 
> > What isn't explained, and very much not clear to me, is why
> > tlb_remove_table_sync_one() is retained?
> 
> Good point. tlb_remove_table_sync_one() is still needed in:
> 
> 1) khugepaged (mm/khugepaged.c) - after pmdp_collapse_flush()
> 2) tlb_finish_mmu() (tlb.h) - when tlb->fully_unshared_tables
> 3) ...
> 
> These are not slow paths like batch allocation failure. This patch only
> converts this obvious slow path first.
> 
> I'm working on converting the remaining callers as well, but not with
> RCU, looking at other options (e.g. targeted IPI).

OK, so with that addition to the Changelog,

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

