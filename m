Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69E85FD4F16
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 19:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 796786B0088; Tue, 10 Mar 2026 15:00:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77E2B6B0089; Tue, 10 Mar 2026 15:00:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A4226B008A; Tue, 10 Mar 2026 15:00:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 459E06B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:00:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB837C17B8
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:00:40 +0000 (UTC)
X-FDA: 84531069840.02.FDA6EF3
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf20.hostedemail.com (Postfix) with ESMTP id 35CC01C0024
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:00:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=CDyDNCj+;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773169239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h1kVvZyG+gLLU/7Q842ol8WN1mRiir9mvGE/U/D8Pdk=;
	b=vLWo+CWS92/X6xM+CvCU3+42GHIuYcGoawEm3TnoMGelww7BjZkpNyulk09ivj3UJYoBF7
	StLF4WntJ2EZqLc4g4kyc3ch/Bzd3oNkixrWC/AfnnyJ5mae79Yz0fcQVI2tQzhqS/tTmo
	BFTctm2OGMKs5FhDt0PBiGuWwe1yzfg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=CDyDNCj+;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773169239; a=rsa-sha256;
	cv=none;
	b=QVPsNKRjTRAw5cHlscf6lClSnn7CCiSI1ab7Z3n0VqL8rOsynY82lS6ynVPC6I/vzJeefP
	ekv6K61XTfxmN+PnOwaMeQKYQLTf7alB/HgU5kbOmIEhp5YuIzM8QabVBHOD/ABzE/c6TR
	/ExRL6apykFSPCnLdcV5OLiz/ujPUk8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=h1kVvZyG+gLLU/7Q842ol8WN1mRiir9mvGE/U/D8Pdk=; b=CDyDNCj+O0QrZNh2HsGSooKDzU
	Zgr08Ge7ZSguwe01MELBY8GENSRbhpH8Jx/Mg1b+3ZH8LmG1TYUh48eMmatnCYziumKlM63gdU+X7
	h7MfecIy8n6GEDApWwnRndFNQo90uUNlg8wePybfIWgwhofgoSbogQgSZwuFDTAYdv+4LxO/L1GIL
	abKqUCUpyqhAgkZF0OHEpKFzChJjtf5b6d4Zqe84lCE92WCqV1dDVLXEO7eC6oCv+EGvZToC6FdoT
	gT60zdaDdmqQ1YveXbkCjxEnNnelPNkDs51/jBGz2qSWSUKN+Aex6mvQtKfB+cuIwHMaDVm+DUK+U
	OK+N4Jmg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w02Ja-0000000FNZC-2rfJ;
	Tue, 10 Mar 2026 19:00:22 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2857B300462; Tue, 10 Mar 2026 20:00:22 +0100 (CET)
Date: Tue, 10 Mar 2026 20:00:22 +0100
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
Message-ID: <20260310190022.GI606826@noisy.programming.kicks-ass.net>
References: <cover.1773164688.git.m.wieczorretman@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1773164688.git.m.wieczorretman@pm.me>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 35CC01C0024
X-Stat-Signature: 6p5i5jsygwyeia9ebpbmykk4usbogmo7
X-Rspam-User: 
X-HE-Tag: 1773169237-983806
X-HE-Meta: U2FsdGVkX1+OtEWLts6E5LbBkBIIRNobXMtX+qO9mdnQFNT0olhkTXoBAjbrxqa/249IDr6fKA4mMHPI4kpqHYp3rPrrrk5RYamaIaOErS+vyeix2y8YddHRZ3RkH6Xw+loLwfY0aR7ZveFhp7RptnZrf3fWV/jPGW7TxBYxqj5uFpqgDMZvrrmemJeOELoWy4rag9Uyq4OAvrTuBScggbiroZjKEfaGO5n87SOIOi4jduvSq4YlPnrFk7tDMrZ7ZbnNuat+buP83qblF5aG4VQk+/CCQ+ONCUWSYZ4hZNWKg/Pj1npKo0lA1pEJH7wRthzkvO9LwXRHTHjt9tyq0zl3zTTHXXrzfAZwUlwRMWczpDHWEl+6qJXd7CoQDhywyjylMT/DYo2fRerLsZ00pXo73rW/RqT2IkFOVPAGKTUHESumHrYd8YGEmnOXzvjRDn4Ch1SAgA3vji7V5KzroTZe+n86Fsxcc7/pBYPJdzb7clEnC/1GqDA1lpFhb2wryV7m7bKeaK2VKzvoQb1THNsxfiWhdff6feTo8i9SaQtntNRM6XBPbSgxl+Ly8IKJ94A1s5aFkNgob+Yk2j9yn1cr5nT65nZB3ucR0+xyOCOzino/KSK2x1ga91kKpW7ILKhP9bFHRu1t3sY1QWkbze0mKklK4d65BGFjU0R5mkCllVmJXL2+SXJCEINrQj1tIYeWWsOljFom//eRIZmRfnDbBJUM1PIrDHy46awSZyZr9bq58ErVDjo/3ZSEFvMZJSsKNc9swWekar4FsncoQkERh8uGDI05LyiDiryvaCrZILH+DsIBVo6AYdOd2/vKg/aFcDfUTd13upg+/IbLD1roxcsZxifbjpnwOkjF/Glq3dHOemnp+PkJ63RCVa3u81pTOBipM3AsUBY9YApzQvDF39jgWG3+e0m0JdEWVfwqq8Z2UZnNcusunAG/DReN5wB8XtMTTk4jv0cvobo
 aSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 05:51:19PM +0000, Maciej Wieczor-Retman wrote:

> ======= Compilation
> Clang was used to compile the series (make LLVM=1) since gcc doesn't
> seem to have support for KASAN tag-based compiler instrumentation on
> x86. Patchset does seem to compile with gcc without an issue but doesn't
> boot afterwards.

Can you put all that under a specific CONFIG and make that depend on
CC_IS_CLANG?

