Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCEF5FD4F19
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 18:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED6016B0088; Tue, 10 Mar 2026 14:24:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84426B0089; Tue, 10 Mar 2026 14:24:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5BDA6B008A; Tue, 10 Mar 2026 14:24:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B31DB6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:24:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 43F471C126
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:24:27 +0000 (UTC)
X-FDA: 84530978574.24.ADC94B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 80CD0180013
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:24:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pGuw+f+h;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773167065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0R4N9uugtHbqzTL9DCEdPm9+pRC6GWIinV06O9Ir7wI=;
	b=w/TxTfUmqngPsNxt5l8HQM2EW3N5NFUrxn3yEcS3fTvF+7cq8B+eLAJhfJETgo5mDgs9DX
	4ErH9sMY22DJeFwKMZpPZ4rAipPqPkgZ85OOnPG+hU3Br6u2yA/NY3Tp9YCt7roKV1hvL1
	e1ZK1n5bwvYdw0jBMs4e79VsrihHH2s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pGuw+f+h;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773167065; a=rsa-sha256;
	cv=none;
	b=0Ku/OLloAE0ucwdy0E/frSYAi7+hM8yPulkNCBoF6C0iMd/AJyQA2HQbn6o7lsupijlmeA
	FSa94TJJb87NlooFEMr/iGcIKZwCfI+t5/EWL2BbWYqsIRjiYFnKJxhYGuKbdiq5R6Cym0
	843W3MrGS1BZ9Tm7dBq3eRUOPv3vL04=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9277E60130;
	Tue, 10 Mar 2026 18:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22EA0C19423;
	Tue, 10 Mar 2026 18:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773167064;
	bh=CBLgVSzk+uzgEcjVI4lMlH3aOZqVypXHnT8n1Tb7lQo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pGuw+f+hlFO49DBTuISwVhCRRSm3fU7+z8TUiRua0/pRhS9XlHJYtLB++MyKym8Pv
	 lILVY26TmefkmAOwH7jgNgU8V1HrW19mRkYMWkDOO2ubbtcP9EgqQTMVJOSHH66SJi
	 NZIkR0SD5G/HXfc9UTT9oO9P0iMy4Kh8WO0QWBBQ=
Date: Tue, 10 Mar 2026 11:24:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: urezki@gmail.com, ryan.roberts@arm.com, kevin.brodsky@arm.com,
 samuel.holland@sifive.com, dave.hansen@linux.intel.com,
 jeremy.linton@arm.com, peterz@infradead.org, weixugc@google.com,
 ljs@kernel.org, ryabinin.a.a@gmail.com, rppt@kernel.org, bp@alien8.de,
 luto@kernel.org, jan.kiszka@siemens.com, mingo@redhat.com,
 david@kernel.org, mhocko@suse.com, andreas@gaisler.com, kas@kernel.org,
 Liam.Howlett@oracle.com, morbo@google.com, thuth@redhat.com,
 catalin.marinas@arm.com, ankur.a.arora@oracle.com, kbingham@kernel.org,
 nick.desaulniers+lkml@gmail.com, andreyknvl@gmail.com, dvyukov@google.com,
 corbet@lwn.net, leitao@debian.org, hpa@zytor.com, tglx@kernel.org,
 yuanchu@google.com, ardb@kernel.org, vincenzo.frascino@arm.com,
 tabba@google.com, joey.gouly@arm.com, nsc@kernel.org, will@kernel.org,
 yeoreum.yun@arm.com, nathan@kernel.org, maciej.wieczor-retman@intel.com,
 skhan@linuxfoundation.org, axelrasmussen@google.com, osandov@fb.com,
 surenb@google.com, justinstitt@google.com, kees@kernel.org,
 vbabka@kernel.org, hsj0512@snu.ac.kr, trintaeoitogc@gmail.com,
 jackmanb@google.com, maz@kernel.org, glider@google.com,
 linux-doc@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, workflows@vger.kernel.org,
 llvm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-kbuild@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v11 00/15] kasan: x86: arm64: KASAN tag-based mode for
 x86
Message-Id: <20260310112421.8ceb7415e14b49cbd86db715@linux-foundation.org>
In-Reply-To: <cover.1773164688.git.m.wieczorretman@pm.me>
References: <cover.1773164688.git.m.wieczorretman@pm.me>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 80CD0180013
X-Stat-Signature: ra1iy4b9jj58mmgo344556azimxfjzco
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773167065-881201
X-HE-Meta: U2FsdGVkX1/rEpyigw4R3N7Wz8yTh/QwK6BxcvTjc5nZkPBQ6Ft13bzSvN47ZOhF5a4QiYh6SBmbTyNAXKPsWobu8ZUxweGaPOzLV/m6XnUCDjodPjzMs3vdJz85bEalKZevc70UrT2PJ72AkA66jsc1jJn566MYGQG6YFednww/bZ5/7sCijvh5yx8T/YhnqIobkshQC+Bw2LytTj2NE82uxendbUSbYovwrZWLVgBpYTfUUxRt6AZhALdo49eolVVM5pDo9DRjx2VbcUF66vAYcBHRbUkRBJeFqffdzQDTFCcvHAV8P8tfMhmCA5FEDVL6hsD8UvKzThIMMbB8uKRVlFc9sqBdHBCPS4RqfyPIeU0wUigjcr7jcmv71I7JZCS+3hZmyRw1V/VXI/Hh2yhyNPjZCeY6tuzT4XZuKkRvmpjJ6cZd6Rl0GWv4xXbB/tvOgd6a67rse+/OtBsVV2WHa1GzAmu8gzvyV7pusw0KF97Gpgtmy3OUWRpjcQS+MuxwryJnnwTTmYTVWWXx9/ZeRkRkP3TyWOFGwE044td+XDTU+hQZfRv+XcKRlTo6Rhq3hT7HRVLmYHV3M0j2e+pMGqjzylyehlvLtBCX3Ihtm78OUEP1xhXJHqlUo/Xww9r+ZgxMUMF/hfWnYG9jCC47s0xw8jIqWnQC7+HvDgNzxO3yRIMtWnl29ZKJGTnG/PbB7IRwmjerhjlWnmeHan131qYhpQkKUT/hB6CDNFdG0XXYqPBWmeIyiC4lqaMiIryviPUQ/Vdh6kJmwkL28F8Um1dE7ynKpgpSkfrBCNNHRaEZF8P9eqwzWVpUzpLTGEHfV6v1VhQNN/LIdkg6f5bl3AIAth7WbGyo2i1mEPM3j/eyIa1aBiXn7L9ochBJlJ/MxAqjvt72jaawha4BUXePQ2uMYYdObZa2eeMAkqphaOvpKTNxURWbsMNtiFxC85bnYzRXI8gQo6W+dBl
 bxP96aCT
 P1vQsVjjN8CEgnmZyQs7ANwjkYeapJUZJfAPq1BFGW9B5JNZj1MlnwI2qiudbfXj5qeoVKaDIEr/0D9OpK+AJFRz6nG7QZKSXFuyP5L+k1xAivgUdoYsweGGc8nLM0Tyzu28e2RGT10k7+Pp/QsCy6/Rz34S/i9ZUOwh7xAN1fJJZGiGdlCCDG3YESD8wLu+25xifJREwsGHBCNIvFp+FlDpElFpHb/w+yQLugDyJplKz9RtsVMzFxg1D43scHqievwJLVUCMuvohAFOoUnTN+dR2i0Jn+Gq9KKXFdMFfAqFv3/L7hk567KuYdwjP9CFpg6m9hC8zAlmhjgk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Mar 2026 17:51:19 +0000 Maciej Wieczor-Retman <m.wieczorretman@pm.me> wrote:

> 
> [1] Currently inline mode doesn't work on x86 due to things missing in
> the compiler. I have written a patch for clang that seems to fix the
> inline mode and I was able to boot and check that all patches regarding
> the inline mode work as expected. My hope is to post the patch to LLVM
> once this series is completed, and then make inline mode available in
> the kernel config.
> 
> [2] While I was able to boot the inline tag-based kernel with my
> compiler changes in a simulated environment, due to toolchain
> difficulties I couldn't get it to boot on the machine I had access to.
> Also boot time results from the simulation seem too good to be true, and
> they're much too worse for the generic case to be believable. Therefore
> I'm posting only results from the physical server platform.
> 
> ======= Compilation
> Clang was used to compile the series (make LLVM=1) since gcc doesn't
> seem to have support for KASAN tag-based compiler instrumentation on
> x86. Patchset does seem to compile with gcc without an issue but doesn't
> boot afterwards.

So LLVM works partially and gcc doesn't work at all?

Do we know which compiler people are using?  Google tells me that
Android, ChromeOS, and OpenMandriva use LLVM.  That's pretty thin.

This is all rather problematic and it isn't clear (to me) how to
proceed at this time.  Do we have any projections on when all this will
be fixed up?

> The series is based on mm-new.

I actually carry kexec patches in the mm-nonmm-[un]stable branches. 
But the series applies OK anyway.


