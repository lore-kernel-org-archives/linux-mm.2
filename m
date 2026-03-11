Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC56910611F1
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 11:06:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 103426B008A; Wed, 11 Mar 2026 07:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B1EA6B009D; Wed, 11 Mar 2026 07:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED4EF6B009E; Wed, 11 Mar 2026 07:06:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CAEBD6B008A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:06:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6C11F1A077F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:06:10 +0000 (UTC)
X-FDA: 84533502900.21.04D6A04
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id DF4E9C0004
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:06:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=orz5LePz;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773227168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8TahdgEn3gMu5VtPViQvPPRTFhQLJ1Z62fN7PBBs1bk=;
	b=YYesyBR0uVKvlx4I48wqK9SOznPSRa9yuje4OTQxW/Ve8CmSQAd6ss2dvLUDgpDtiZ1nsD
	s9W3hvot9d6GzbFx8hidrO9gqeq0s9aBEpO2OndT4/ghL0k24qOPup4m1Pr3CdVF+exT9u
	MKHSZe1kFBb+IiP3Fj70CvYAkZ+kt9Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773227168; a=rsa-sha256;
	cv=none;
	b=M4EJr1SXQU9p8DSgf8tWRrbRP7EnCcu1p9zNnyDBIBhgzt8+l89EiNULLjPzoGaSuFVBue
	dPJ8QAUI0hddeqldG2R9VF9wGYN5EMURFiXRtlg7uVz4QNgjdnE1WJAyxU1TPaOkSTzx88
	VyXUWRRoA5C7dOq8hh7SL/nB/GF+Lbs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=orz5LePz;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8TahdgEn3gMu5VtPViQvPPRTFhQLJ1Z62fN7PBBs1bk=; b=orz5LePzw3opuW/yz8CcEmozDO
	xiizCf5g/4MxZjstVBcXke9ZnZO0KfEYJyfLt0qfJxIIKWpBbcS25b5NkpFXIyAuerC1Y725y3LI1
	LmM0yprkpnTTnsGvdRnTLlYjnZARPC5drSicT9Fq5KQr8WyNNGJF+1kOGcLp5EIkuE3AL72ee/fUz
	i4g9g/jZnVHSAF6x8tSUjURxXZ2eTOJKvuxIej/M2PFOoechdoDgi51M4IPbIJI7whfeRMrmMMkBm
	FHy5O1AL5RyUC27FW2JJ5juzEuX3Q9MFEWUsLs4jHoo+n6nXEasBBdDdErUBGTx5ebJCzAqOLxnQK
	1CorYs0A==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0HNx-00000009VAZ-34x3;
	Wed, 11 Mar 2026 11:05:53 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 395B8300462; Wed, 11 Mar 2026 12:05:53 +0100 (CET)
Date: Wed, 11 Mar 2026 12:05:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: urezki@gmail.com, ryan.roberts@arm.com, kevin.brodsky@arm.com,
	samuel.holland@sifive.com, dave.hansen@linux.intel.com,
	jeremy.linton@arm.com, weixugc@google.com, ljs@kernel.org,
	ryabinin.a.a@gmail.com, rppt@kernel.org, bp@alien8.de,
	luto@kernel.org, jan.kiszka@siemens.com, mingo@redhat.com,
	david@kernel.org, mhocko@suse.com, akpm@linux-foundation.org,
	andreas@gaisler.com, kas@kernel.org, Liam.Howlett@oracle.com,
	morbo@google.com, thuth@redhat.com, catalin.marinas@arm.com,
	ankur.a.arora@oracle.com, kbingham@kernel.org,
	nick.desaulniers+lkml@gmail.com, andreyknvl@gmail.com,
	dvyukov@google.com, corbet@lwn.net, leitao@debian.org,
	hpa@zytor.com, tglx@kernel.org, yuanchu@google.com, ardb@kernel.org,
	vincenzo.frascino@arm.com, tabba@google.com, joey.gouly@arm.com,
	nsc@kernel.org, will@kernel.org, yeoreum.yun@arm.com,
	nathan@kernel.org, maciej.wieczor-retman@intel.com,
	skhan@linuxfoundation.org, axelrasmussen@google.com, osandov@fb.com,
	surenb@google.com, justinstitt@google.com, kees@kernel.org,
	vbabka@kernel.org, hsj0512@snu.ac.kr, trintaeoitogc@gmail.com,
	jackmanb@google.com, maz@kernel.org, glider@google.com,
	linux-doc@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, llvm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v11 00/15] kasan: x86: arm64: KASAN tag-based mode for x86
Message-ID: <20260311110553.GM606826@noisy.programming.kicks-ass.net>
References: <cover.1773164688.git.m.wieczorretman@pm.me>
 <20260310190022.GI606826@noisy.programming.kicks-ass.net>
 <abBu-M5esEYWScDf@wieczorr-mobl1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abBu-M5esEYWScDf@wieczorr-mobl1.localdomain>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DF4E9C0004
X-Stat-Signature: fa9p8edbcnceq1qcbtud8gcfdhkodxfk
X-Rspam-User: 
X-HE-Tag: 1773227167-899526
X-HE-Meta: U2FsdGVkX1/3b8aQXQSPyYpWE08xs39UE5h51wBNGp0eW4X+JwdYWLtUp9t5ikvsOxZqJrEI6/XqdpuAIS/3kX7SqnBXt3mG73g0mua8MNI8BZ9OoXB9+2FNfNtAmvZ/S84EpQh7repRpKTZ484Z5m6CRdRDF20R1QAaQifrYR6ua8H/TlRdy30TnkvCKLhK03RV1Y3mvQCH9qQDnjeu/FRypbEn30k20eEqu5WO3307ul13KxteqqEoAdD3AS9CYLrZ2rIbIjomk0Y+DoeZkfUh8KzKgDtl02vvRFRbaFKSnNSqMSkWb4ZxzgE9YkwqIPxLOBtQd6yKNL7zKTcg21PbESnFx/0eFWG4r/AKwYqr4kXZy+Nr4T20N4G4vmKSPY1I1GO6DjRbltPkwGRPwYDLasY/cX8MkdZzyYFnmibxaKdUBEWXqBpjzniG5flNDYoKq3FQlo18FP3aDyDKRYHPpP/Z7oslDwcadMyeIr2X8Iht/LIVHDH/u1MBcHtHUjYO8pRuyLrDss6IxR7a6nR60G3QWUDV+NcBilLsHt9178NhtwZfKt49Te/Ty8+EGQY0veB7jnFDcKX+AqttNrLDHKc3Cc09HkgYkdzCVB9gjVJc4WnsDE7q5u6bV1fSQo6K1SkhQlmeuYSr95r5Sdk/62A05shKWi8H+EXse91uJQu7wEhOoNGyIB6FhNul37AZQLnDuyuDc0E6UZSuBdP99w98zz2EIssROCr/5JITJ9tGqPDJvsVKmKiFUcDUMAdcv1VV6Qof3Ojfo0Bep8P4Yro27sUBLH5MKkc0PyHE7axsU+OIJr0uJiVq53EH9VULAfuh1jkwC+jETTC10ouzvsW8oXPQk5i8lt0ROh7FLdKagOFjaWLWZyLgF8imrq7Dop00UrfyRtfduaDzF/5XmFT2Q7nHbkDu+OMFg0T8vPwT3/oglQxiFJqbbB1XhOuaxWxEiF3YpYEJhah
 Bg8sOOQ1
 byyiH7QXPn9yRIYX+vJ/XNfi8QDBqqUWTy7UZWagEhRyCTw8GKFRhKu1kOFz/fCMTTRqtyNre+m0WoEBdWt6NAd4O9FBcfb4lV9kt+1Ey0WWk92Igxg7I0ALvofk9VmxG9fIz/6HzldhqLtQMWblOX1I+l5+9/qAeKFjfe34b1F7GumzPEow9yLMOjjN3AgCdEaiJ1iLlHyyrXogVud8f9OINdXfPkMFjD//6hQsI0GC4E23VSQEMjaAg5/jm/qOJ0euX0OUgXJYQwu2omIA5nGsQ8GicMiHuIpoj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 07:30:36PM +0000, Maciej Wieczor-Retman wrote:
> On 2026-03-10 at 20:00:22 +0100, Peter Zijlstra wrote:
> >On Tue, Mar 10, 2026 at 05:51:19PM +0000, Maciej Wieczor-Retman wrote:
> >
> >> ======= Compilation
> >> Clang was used to compile the series (make LLVM=1) since gcc doesn't
> >> seem to have support for KASAN tag-based compiler instrumentation on
> >> x86. Patchset does seem to compile with gcc without an issue but doesn't
> >> boot afterwards.
> >
> >Can you put all that under a specific CONFIG and make that depend on
> >CC_IS_CLANG?
> 
> I made HAVE_ARCH_KASAN_SW_TAGS depend on CC_IS_CLANG, and that controls all the
> software tags stuff, like ARCH_DISABLE_KASAN_INLINE through KASAN_SW_TAGS.
> And ARCH_NEEDS_DEFER_KASAN is for if KASAN is compiled but LAM is not available,
> so that it gets disabled in runtime.
> 
> But sure, I suppose I can add a separate CONFIG with CC_IS_CLANG to these three
> so the clang connection is more transparent.

Right, because building but not booting is BAD :-) While compiler
specific features are a dime a dozen.

