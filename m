Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 180ACCD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:45:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 187326B0005; Thu, 11 Jun 2026 09:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1385C6B0092; Thu, 11 Jun 2026 09:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04CEA6B0093; Thu, 11 Jun 2026 09:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE3A46B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:44:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 45A26120689
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:44:59 +0000 (UTC)
X-FDA: 84867752718.24.581AC71
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7CC48140013
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:44:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="ibs/lTWy";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781185497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m0fD9KCk/6I6qo6Wg6wfui77ADSGp/LJkYfEAup3lwY=;
	b=zkvFQafVptMNWNu+0+lpaGkr9XVdhjXNUAiRNmDmUBDCeozArUwqqI5yoPQE3ve6YBr15X
	+U9jcObXkLoCQ4I2TwgLr+isQ/kswSA34QVaKCqodw0spiwKomHOtOp56+uBbbtzeS3VbL
	dMpu6rvhNaezKZyATQfh6MFwWm0rc2k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="ibs/lTWy";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781185497;
	b=IkJeZqXBAwrtZEjMdHnCvqHhXyGp+dxkBMwTUm0cXvtKOrXdZM4lWuHtN+X6i60N7jxynb
	5X7tI1SjmYWsq43NcBDYhd50uL5HJpompseEDYrrkGORdRsZPLVbXQzZJwoXd87a7Fzfiz
	mJ4Fum9ljMtG+EsHgdVt6ZjtBG3tKOc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=m0fD9KCk/6I6qo6Wg6wfui77ADSGp/LJkYfEAup3lwY=; b=ibs/lTWyAjLVWXS3n4wPjA79OS
	ITb//Iv1CxtQUrx/67IL+hYSamUfqJOQPft+Dglj3UFpe6AehWYKHnyrdmyQlnLCCHnR37eSF04YY
	BV8xlmAh95887QUefrFHmh4w0rqaGST435zBbQpMYZ8US3gRQg+HjRI0XuAaxBi7gclydQf69ZDM5
	k61d3A3iRRXuQJHaZacf+KNxVaTzU7pWHtqGjdFKnziZBtLLfi6vKmz1i2qN9G7/mZEKcluKIADZP
	arbxTyUtAa9KswEQnkGYCnK7u+EJaXbbI3n2nupMq3G+mbNR2VmbwbcZlBXNHkE7grhJz1GNpvuDh
	FnJVAQdw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXfi7-00000001ydR-0GUg;
	Thu, 11 Jun 2026 13:44:43 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0B6CD3002F0; Thu, 11 Jun 2026 15:44:42 +0200 (CEST)
Date: Thu, 11 Jun 2026 15:44:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com, "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v6 5/7] locking: Add contended_release tracepoint to
 qspinlock
Message-ID: <20260611134442.GJ48970@noisy.programming.kicks-ass.net>
References: <cover.1777999826.git.d@ilvokhin.com>
 <5d7ea75ffe74a785e6b234ada9f23c6373d4b4c1.1777999826.git.d@ilvokhin.com>
 <20260513193342.GB2545104@noisy.programming.kicks-ass.net>
 <agXBb0ga_6HJrrnm@shell.ilvokhin.com>
 <20260603120811.GW3493090@noisy.programming.kicks-ass.net>
 <aiphFXe_TPNPxZ_n@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiphFXe_TPNPxZ_n@shell.ilvokhin.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7CC48140013
X-Stat-Signature: cka3y49n1xniniqafiqw4f9kyduu5bi5
X-Rspam-User: 
X-HE-Tag: 1781185496-134698
X-HE-Meta: U2FsdGVkX19K0rK1AmhHWRXUxEPQ7Tlz29+x4rhBniOxLxYs5KZFbUizglzPIVm6WL653cmM0NuVZ+SzgbhguZYDmHtKkuGeG7HU6z1dpLon3eUwW/v11xxpFIkgtB7Euyvwr5MnSG1kkrM7rg5sVYOo2k88llRf9PB3mBsMQ02Y9QBryojcjia7JSl0dk0YR61daV+1gM4IPUdy0rjbTXxpOCbhaflJDjCmlXsbqwuR7C2g6hdha6K956k8b1tCuMq5WPEw1pXgyd1OlJTI+suAcS895P+ayrLceGmf/ybCKvBiylVYiOtq903Kppgrea5uCsuB+kjzmmjRHzxGaosvKZvF6KABkNXdzfwYlhkkcj7QIOoclAd4Gut14AYHwnvSj3ZqNdzvil6YunoGB4S2aO2BsKA8eUiMiq3hxcpBnyOwK16XDyQExotIa2fUOnlWNJHuV4biWY6UVZM+Yu7+DxY53ftsebN2bm3X/PIS+gHedtWAj6JKIDsTEhx5tEWNr+TwpMMC+5Rb2QbE0eoyyIAFWJPZZ6Fy9zzsTb/LfpF1tRwzwgRpkSMRWxwGzhv+QPnsrM+HRXDzkckPUKVCwhgeKn1ZWw0z8BguFrh83d/i38SRlAZb0efV1TLCNbYi1aJYp8UYu8HGP0O3I1/qv5uAPbyfkdT2Hf6KGu3+aEtQDY820LXO9akKIiqasTsf+DBpcur+XB80lJDvg0ag4ehPGkzeR/rB7r/Fwskrkz1VzcAw3mEZMcHVid4ZUdv7evrsnIM/Z2+nnEQwLhS43mQ0giQtSmIIye9XkT/det9Gf+OEqBhYSIH8HpqSx+xElIm2pFyBu31emjAk1A3hJ0LfzoclRS7MkiHKl2qz8MHYw6MK2XiRvOcDg8nVUfe3HmMd1hz6ARKm3N89v4UzjwBpKXj5coYN6qr6FWoO+KILlXfEUK0OeIYHgRjZ3ghX5QTzUUE9hGuTRI1
 Ou1DRxb5
 wCalGkPS+2B+1wMYjJ6/YtTdZKoKJwmMB1VrDpWOZENn3gxu4SSlB3xZh1CmDGjg9KSdT4Nv8spjhZY/B2J+oX2IsQY6vknuZAyt9t23SAZq69MhmS05L3Dy+CKjIeYHke7TsPaxqZzhtPpVav4h0MLqQJ6TJfM/VUiCZNZDAGMS0enIGcbFRGm2poG0cT61K3Cke8PH3f2oqYSXT2bMhITnHsaBGL6Etncl5JBLowSlT3MndT5LvaaDXYyJXkN43jivPnie3LQXH29pHBrx74PxrJECaZ1LNT2Q3WXYb/3tew0k2krc6DcoQzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 07:17:41AM +0000, Dmitry Ilvokhin wrote:
> On Wed, Jun 03, 2026 at 02:08:11PM +0200, Peter Zijlstra wrote:
> > Also, I think someone should go do some performance runs with
> > ARCH_INLINE_SPIN_* set for x86 just like for s390.
> 
> As promised, I set ARCH_INLINE_SPIN_UNLOCK{,_BH,_IRQ,_IRQRESTORE} for
> x86 and measured the effect on a few real workloads.
> 
> Short version: inlining of _raw_spin_unlock() adds measurable kernel
> i-cache pressure on every workload I tried, and on a
> kernel-i-cache-bound one (nginx connection churn) it costs ~1.27%
> throughput. I did not find a workload where it helps.

Thanks for checking!

