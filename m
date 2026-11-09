Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4F1E606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VUWugq1T
Received: by kanga.kvack.org (Postfix)
	id 0B1216B05BB; Mon,  9 Nov 2026 07:18:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 089326B05BD; Mon,  9 Nov 2026 07:18:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F090A6B05BE; Mon,  9 Nov 2026 07:18:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1C866B05BB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:18:50 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5FEEF1204EC
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:18:50 +0000 (UTC)
X-FDA: 85415484420.22.8D54A69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9DE3F140006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:18:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VUWugq1T;
	spf=pass (imf09.hostedemail.com: domain of jszhang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794226728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZMzmCKSIkoQfwrqG+6d9p6F4cnVpKsZmbCb0zDMSihk=;
	b=zWAkSZQN3RqhA04DzY7227iycNGWMyP3ihQoIhGVj5hEpu5c17LTnJpDHsm+Pdo5/XEN72
	UQU7rl0WDq+FX6iBm4l9UVZGdw1GS0fysyZ2SURgFMuIV46F4NlkYTWdHP/E5FqRk9WSc5
	Wsucu1/uPWWsc3mIiycWJ1X5YOCVXyQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794226728;
	b=GVNVjX8U2P0fPEjpIroBbHr3rrIXUMG6NCzqMD3uqgoRnRZnq+t7qizkL7Wc5M2XmPT+4/
	4aomKLCMxxOpwkYXzIhHY7j82GwjPJso8t0tM5BXu1wVjgiDIwTplHn5gklRVY7aAAevKs
	fR9lbsxwsU8X5HSA/OMRYcHQLrA4T6g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VUWugq1T;
	spf=pass (imf09.hostedemail.com: domain of jszhang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E76B6414EA;
	Mon,  9 Nov 2026 12:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033011F0089F;
	Mon,  9 Nov 2026 12:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794226727;
	bh=ZMzmCKSIkoQfwrqG+6d9p6F4cnVpKsZmbCb0zDMSihk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VUWugq1T8LES3WvDoryymkJe/5u+zIris0rGfjfH5o/eCc4OYGe/jqNNYSQBTkB08
	 yuLv0k+CV5aasQM+lmC5Q9cIim0b0K92C2mY25tBKSEpq+Che2kWXSdFTn/dLVOwY6
	 qoDFmAm4Ajg5HsFg8Lt/nfMALrPqyKwelqycnIuEm1E19ecReL+ARFKT71gfwXKctJ
	 gtHYhuzgfnt5Kv/8CHwcVEgLDCTpkEo1veT6Us7YPkhn+0uRh4q2brKBgUxWrDTzso
	 Sa7J4Cj4ddnkWVjvB/Eyhuy2SxOK5g1KKIqnF9o/X67vYD172gNC7JZT8CLTUmZgw6
	 qibxRFwKNjMoA==
Date: Mon, 9 Nov 2026 19:58:35 +0800
From: Jisheng Zhang <jszhang@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/4] arm64: alternatives: Make branch and ADRP offset
 helpers noinst
Message-ID: <avG1a9aVNdkiiGX_@xhacker>
References: <20261107071339.17467-1-jszhang@kernel.org>
 <20261107071339.17467-5-jszhang@kernel.org>
 <sashiko-outbox-203636@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-203636@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9DE3F140006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 5ydqxi9f5hy8pu619ke949o5bg6g6rb1
X-Rspam-User: 
X-HE-Tag: 1794226728-493480
X-HE-Meta: U2FsdGVkX1/h6opomDHNR3FiER1eHT7nd7iZ5t/F8kkRsELIlHCNFoZMOp6i70lUgptreovOvLt2KTPj88fJXavkHmkUy4kDAGgJH/gBAt//PiCyTwul0L8uOJIovee0RoZRJSFSUDFl987BCRZkdLLeARRvg4LBRe3icW1lS6trxyEpDYE2g4HQHXEKsepl2ORclDORvExvh30TLDXUDj+LrKY/R0JTmPreGo+8c2ATpU4QcFVepPYr6obckei4To7ODWY3mj1L+DpYANwpXgqMBJcgskQiU1tm6nsC2T7f4WLECIdlKaIZqbFRxTUr6OKUPS0203oOE74jvDa5pkgxTN2SwrXplJm/SS8P0SnEshYt3LKtpG7RRbLZJyqTCNJcaDZuwlEkr1o/xazEnRB/YGYucWDpigSUevwQwyeEhz8PlL2nyX6j3CDXZQjfQhlplO8DPL40WNJZ0y5ZkgKdCM9nPFccJCca7IKQAGsxvdkcjH8ew/DgWBohPIMKE8AaRurPq5ucpMvJk5jxrq1OhkWcx39k7hs1i1ueyLRDEDWm7cOW1evYObKtlFnnDiZiPCGunoFmD4didudKe83UMPSVzyBNljeKT/KPBgTfxFzY5yLaCKvcN+1fiD6VWHBwD//BtXq846m3AJ4qn+A2x2pVSqesE8W9rZ2XqWLUdfZsiqSoqp0boDBmwF7/U+ZcsU27WbUgKqKzhMN//s0lrOzHldAriZpBgaJs4ZbdgXPKtxtDzVR/SF/IGXVShhRCAszRk5D6v5Ra3sO0Ec+HQoDKHyl8VlIirf6jV4360VybVv9d8kIhYskYahXvZ9yybyGv184WkLRrTPSCKQEhBVVS/3CZ88nTGqvuy1+PZt0+3Vwd+D6JPDpHQpaO+Bbn/fZMvNe88CdH7g70B4/tP2eV+/Bqtm4GZU8nZAY0b1xmmU0tFtPEc3D+ISEpt5kvMz3fxWzG5BBHwKR
 fbAGg49l
 5jpFuyBKCh3yKOItOAGeApFrb3rrPar2Q+xJBkW3zGxqSnFgjUTqhdZjvQeoCSWk34Nn3Qu93n8wK9hig+GGayLrCQjFpcRUeHVbaHOsDF/7ObRpiPjxpbQarDThnfz4nDMBP1Yg5LPrBwwLie0vZdDBlVVv5MGCklPEQqVTBbcU6QqNpWLcQCEvTNKBOcGoa/k8yxW9mPkVOfIMcA4S1WRO/uyaqt6PJ/xYYPYoYeWKC+2ncv1s5z0q+QHvjsHJLCaYQ6y1X2T1EbCgT8dm9Vb0h4EHhyHWwmuskcTmnFOafNoKE4Zb+RbcxqprBEguNPHeC5B1JRS5eA7V+ugSj8LsaEIi3IG8nSJTZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 07:43:58AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] arm64: insn: branch profiling instrumentation in noinstr
>   offset helpers
> --
> 
> commit b08429609214cdffaa257c9ef953b28e179973db
> Author: Jisheng Zhang <jszhang@kernel.org>
> 
> arm64: alternatives: Make branch and ADRP offset helpers noinst
> 
> This commit marks the branch and ADRP offset helpers noinstr and introduces
> __always_inline immediate encoding and decoding helpers so that
> patch_alternative() does not call instrumentable code while modifying
> instructions.
> 
> > diff --git a/arch/arm64/lib/insn.c b/arch/arm64/lib/insn.c
> > index e70ac02385153..b98610fcab32e 100644
> > --- a/arch/arm64/lib/insn.c
> > +++ b/arch/arm64/lib/insn.c
> 
> [ ... ]
> 
> > @@ -1299,23 +1316,23 @@ u32 aarch64_insn_gen_adr(unsigned long pc, unsigned long addr,
> >   * signed value (so it can be used when computing a new branch
> >   * target).
> >   */
> > -s32 aarch64_get_branch_offset(u32 insn)
> > +s32 noinstr aarch64_get_branch_offset(u32 insn)
> >  {
> >  	s32 imm;
> >  
> >  	if (aarch64_insn_is_b(insn) || aarch64_insn_is_bl(insn)) {
> > -		imm = aarch64_insn_decode_immediate(AARCH64_INSN_IMM_26, insn);
> > +		imm = __aarch64_insn_decode_immediate(AARCH64_INSN_IMM_26, insn);
> >  		return (imm << 6) >> 4;
> >  	}
> >  
> >  	if (aarch64_insn_is_cbz(insn) || aarch64_insn_is_cbnz(insn) ||
> >  	    aarch64_insn_is_bcond(insn)) {
> > -		imm = aarch64_insn_decode_immediate(AARCH64_INSN_IMM_19, insn);
> > +		imm = __aarch64_insn_decode_immediate(AARCH64_INSN_IMM_19, insn);
> >  		return (imm << 13) >> 11;
> >  	}
> >  
> >  	if (aarch64_insn_is_tbz(insn) || aarch64_insn_is_tbnz(insn)) {
> > -		imm = aarch64_insn_decode_immediate(AARCH64_INSN_IMM_14, insn);
> > +		imm = __aarch64_insn_decode_immediate(AARCH64_INSN_IMM_14, insn);
> >  		return (imm << 18) >> 16;
> >  	}
> >  
> > @@ -1327,35 +1344,35 @@ s32 aarch64_get_branch_offset(u32 insn)
> >   * Encode the displacement of a branch in the imm field and return the
> >   * updated instruction.
> >   */
> > -u32 aarch64_set_branch_offset(u32 insn, s32 offset)
> > +u32 noinstr aarch64_set_branch_offset(u32 insn, s32 offset)
> >  {
> >  	if (aarch64_insn_is_b(insn) || aarch64_insn_is_bl(insn))
> > -		return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_26, insn,
> > +		return __aarch64_insn_encode_immediate(AARCH64_INSN_IMM_26, insn,
> >  						     offset >> 2);
> >  
> >  	if (aarch64_insn_is_cbz(insn) || aarch64_insn_is_cbnz(insn) ||
> >  	    aarch64_insn_is_bcond(insn))
> > -		return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_19, insn,
> > +		return __aarch64_insn_encode_immediate(AARCH64_INSN_IMM_19, insn,
> >  						     offset >> 2);
> >  
> >  	if (aarch64_insn_is_tbz(insn) || aarch64_insn_is_tbnz(insn))
> > -		return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_14, insn,
> > +		return __aarch64_insn_encode_immediate(AARCH64_INSN_IMM_14, insn,
> >  						     offset >> 2);
> >  
> >  	/* Unhandled instruction */
> >  	BUG();
> >  }
> >  
> > -s32 aarch64_insn_adrp_get_offset(u32 insn)
> > +s32 noinstr aarch64_insn_adrp_get_offset(u32 insn)
> >  {
> >  	BUG_ON(!aarch64_insn_is_adrp(insn));
> > -	return aarch64_insn_decode_immediate(AARCH64_INSN_IMM_ADR, insn) << 12;
> > +	return __aarch64_insn_decode_immediate(AARCH64_INSN_IMM_ADR, insn) << 12;
> >  }
> >  
> > -u32 aarch64_insn_adrp_set_offset(u32 insn, s32 offset)
> > +u32 noinstr aarch64_insn_adrp_set_offset(u32 insn, s32 offset)
> >  {
> >  	BUG_ON(!aarch64_insn_is_adrp(insn));
> > -	return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_ADR, insn,
> > +	return __aarch64_insn_encode_immediate(AARCH64_INSN_IMM_ADR, insn,
> >  						offset >> 12);
> >  }
> 
> [Severity: Medium]
> Can these four noinstr helpers still call into ftrace_likely_update() when
> CONFIG_TRACE_BRANCH_PROFILING is enabled?
> 
> Although f22c81bebf8b ("arm64: Disable branch profiling for all arm64 code")
> added -DDISABLE_BRANCH_PROFILING to arch/arm64/Kbuild, arch/arm64/lib/ is
> built via libs-y in arch/arm64/Makefile rather than arch/arm64/Kbuild, so
> arch/arm64/lib/insn.o is compiled without DISABLE_BRANCH_PROFILING.
> 
> As a result, the generic BUG_ON() in aarch64_insn_adrp_get_offset() and
> aarch64_insn_adrp_set_offset() expands to unlikely(), and the if statements
> in aarch64_get_branch_offset() and aarch64_set_branch_offset() are
> instrumented under CONFIG_PROFILE_ALL_BRANCHES.  When patch_alternative()
> calls these helpers while patching live instructions before cache
> maintenance completes, they call the instrumentable ftrace_likely_update().
> 
> Passing -DDISABLE_BRANCH_PROFILING in arch/arm64/lib/Makefile (or defining
> DISABLE_BRANCH_PROFILING in arch/arm64/lib/insn.c) would prevent branch
> profiling instrumentation here.

All comments should have been addressed in v2. Plz review

Thanks very much for the comments and hints!

