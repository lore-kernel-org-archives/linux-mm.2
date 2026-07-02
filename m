Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBCF7C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:32:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D02606B00D2; Thu,  2 Jul 2026 20:32:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDA196B00D4; Thu,  2 Jul 2026 20:32:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEFC56B00D6; Thu,  2 Jul 2026 20:32:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9296C6B00D2
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:32:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7EE6F168016
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 19:46:39 +0000 (UTC)
X-FDA: 84944868918.08.6FF37AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 00EAA40011
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 19:46:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fvZmcYdh;
	spf=pass (imf07.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783021598;
	b=rIGt2dSfPjVD6FoBPoeG6PtpW6W1Dl3OePDry7kw8wgFvCtgJnf54RqGcvShbco30k6qZp
	lARB7zROFjL/IwE4YgNA4m8/t15/2EBCszKHCdubqhnqpuB0R9DJ+8eyGK10GUfznwU+Js
	V7352UA2mzxRJRvLYt2o+Qtgm9outXA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783021598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eyHDCPYYCnCqlMDzLTfPdm2rWb8d16r0Pbrr92/ckAM=;
	b=FJw3RgunhH2XOzYYqa9NgNEzGJyRuwrM2+78k+yMrcGgoLJgBt57PFwZNcBHWcnlmll97h
	59bb4qwshAR4IZhU8uXkWT9D562acVcCXSLs+6m61zMzVxerrktHYscqMPU4iDTDNlJmqk
	ZUhgW3Cnsc3Ge+sbmBgJEoc4Igf6R2c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fvZmcYdh;
	spf=pass (imf07.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 85ABB601CC;
	Thu,  2 Jul 2026 19:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A391F00A3A;
	Thu,  2 Jul 2026 19:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783021597;
	bh=eyHDCPYYCnCqlMDzLTfPdm2rWb8d16r0Pbrr92/ckAM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=fvZmcYdhCSUgxGkmW212EmxrZkq8oiLsj08VEMml8LnUCeVmay3/VcXrLihutPk27
	 v5fcM+pm9FFE6PI7i6YNPUu7yvwylH1P1PCBykFqQwX2Wr27XknhLV5s+ojEkqHeDi
	 ybpgMTv7D3GiZgJ8aliQVd8yh0h2EIsoiJWzYqIBVGCH9QGxMDXT3LLwWRJHUHsEPE
	 lJ5yUDrsuyxK+t3S+6a36XFBKDDSJPOo+69ULqmDBge83Uzk2DLYSur7EVuvXiRQiS
	 7FNBmzOIXBi+EHRJU+QYGo4HULKM/uQI/xDmetMBKrzzdZlHvR9QCdVvj0k+n8CES7
	 LMgDNjtPzxinA==
From: Thomas Gleixner <tglx@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>, Dmitry Voytik <voytikd@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-toolchains@vger.kernel.org,
 Alexander Potapenko <glider@google.com>, Ingo Molnar <mingo@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Josh Poimboeuf
 <jpoimboe@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Ankur Arora <ankur.a.arora@oracle.com>, "H .
 Peter Anvin" <hpa@zytor.com>, Nathan Chancellor <nathan@kernel.org>, Nick
 Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling
 <morbo@google.com>, Justin Stitt <justinstitt@google.com>, Marco Elver
 <elver@google.com>, x86@kernel.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org, llvm@lists.linux.dev
Subject: Re: [PATCH] x86/mm: fix objtool failure with KMSAN enabled
In-Reply-To: <20260702111550.GH751831@noisy.programming.kicks-ass.net>
References: <20260701125151.352632-1-voytikd@gmail.com>
 <20260702025342.GJakXStrsCmIRnEwFD@fat_crate.local>
 <CAAX90H0V-=Gy1FyBT9qop2=RvhBxbOPLu6+DYpPH2pTehT=nRw@mail.gmail.com>
 <20260702111550.GH751831@noisy.programming.kicks-ass.net>
Date: Thu, 02 Jul 2026 21:46:33 +0200
Message-ID: <87se61npie.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 00EAA40011
X-Stat-Signature: 7m46hhq1tye1hhetn3qx6sab3tubtwtq
X-Rspam-User: 
X-HE-Tag: 1783021597-558452
X-HE-Meta: U2FsdGVkX1+rBpWBEpG/+Wtw0vELp4HLQ6d92Oc7FMxSA/Zarzy2ZmyMtQr2gVD9BMJNWvuFT3REwc4E/b2YGVdjIPz7zJ4fxz3twTEED0K2AE/ec+1GZ1PTeCiJi2PoDQFd1rQrcNYRVkYE2Lihdsh500XFWBqJmYgaYBLCcaV+f41cMk5ibFNH1LwE33OvIAUL5Udx0zZo3PyKWzekgcbg1gvsMusAmiK9awuLNgY0P+nVCbF7afuMbGzlAgWl0rIqGLkA2fvFIk3pwJ4DajsK4W2YwS9lQO8hlpsxXjTiSFhIfJF5MdpmMCsccuneOnuREUFysZqiySFNT3ulI+OdMGKKWBrBjfOmwLhbZF9eHfRvyPbha0vP/m18cvT9c2ntSINmG8FbJC5lGl7zHft4E/fIPVbUSrCSGYSV8qsSpTSiToLmlHfMAU55mz7Sh/6ynXmsoWldFj1kscK0xFXAm03AMmKtyIFCxsUjkXwHBTs0wGzKwuo1iuOmt/ca3rodzu9fQI4r4VsOhhdd3AJFxgPZFdYnxsqher1TpxmgNuRFbhryPg1nB9ulemD9/kRB/nlcwwXDBSJseRFds9iqwqYVL8s9IsNeK4wWAa5hg0OtCg9nJ6eNRzxj7Weh6AzOEuCKDQrGW/7V+j3faJXjz/rZ6VIloue+Z7K9fCrnxIJ6EOJKmjFEIelWhYAmiHOWZ7WvPxQ1a4fHjhH7+eH/qKZVE7Vo23F6lMQyG3nkWT/eunYz7pt8YRkxv+H6OVNh0cVO3/Jtkl5TvH6wCuEhblAxGoLXhUPoWCdnA6pBmyS68wvRKroeq7UB5YFN7mwc4JbHjWbCX/Oo2dmwTrkatna0BToF0sksu7ZxQ5XA3T+tGIr0sAPlrVtIlFrgJCRuZvjmg3Fk5hUBNYQs6d0QnJZzDsTLjFi7RWHl724+RW8MF49VNa19Ob+pls15eEAnlh57hd3peNT7Ecu
 IS+F+DHU
 iHVifS99dhJhs2HGDwaCH2QdmMmXgULRIWdgm4Fk1Nk7YItXwVOlg2tiGPan9ZzBqLGQSUNyLm+11D8ktmFzxnpNECuYW3f/gYv5BPk1xSjBFQdHfomMvqqaIm604yxI83U+/hsLtxuJ7KEr9F95YPT+ZNvfGH/FFxImu2Z5vRiIkCFql3XVWh9tNA5K3n/PT8sjxDlodvDOifg+A02T+1/7NgVr5gy3nEz2v2m7OeANClP+zWAmU6Ez4GlSTj7eKzAFgAEo1/lGhd02tn8HqthXPsL4pERidIFp35yBcJ+XkW245D6sV48+WojNRhb/8hYoM7kVKHwryIU0ToahnQafoYZhcoq7rxMcl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02 2026 at 13:15, Peter Zijlstra wrote:
> A quick test with folio_zero_user() seems to suggest the
> ASM_CALL_CONSTRAINT movement (your patch) generates the same code for
> defconfg as does the unmodified code. The change from the thread linked
> above (input constraint on __builtin_frame_address(0)) generates
> different code.
>
> A third option is to force FRAME_POINTER=y for KMSAN builds -- for now,
> until clang is taught to be less insane.

With FRAME_POINTER=y I get now with clang-22

vmlinux.o: warning: objtool: folio_zero_user+0xa7b: stack state mismatch: reg1[4]=-1+0 reg2[4]=-2-336
vmlinux.o: warning: objtool: set_ftrace_ops_ro+0x64: relocation to !ENDBR: machine_kexec_prepare+0x8f0

That's with your objtool patch applied. When I remove that then the
folio_zero_user one goes away. The relocation to !ENDBR stays.

Oh well...



