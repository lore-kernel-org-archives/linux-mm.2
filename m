Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06E3F606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 06:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XY6g0QDN
Received: by kanga.kvack.org (Postfix)
	id 2B97D6B05B9; Sun, 15 Nov 2026 01:39:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 266AA6B05BA; Sun, 15 Nov 2026 01:39:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 155E96B05BB; Sun, 15 Nov 2026 01:39:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E48CA6B05B9
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 01:39:06 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 59516A8188
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:39:06 +0000 (UTC)
X-FDA: 85436401092.22.D9E4C22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7D942140007
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:39:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XY6g0QDN;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794724744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5uzNQjIqKu1Z5H5h4ULFcPsML/9M2qNB6yySUHBpd2Q=;
	b=4WNbqqfSkujzuWfZHT75+/EwpvI/nOhR8+gZJOF9oFKP7Gqy5wKJAIWMsmDsyJQKxrr829
	PogX6M+o7mHwpX70Z4R05JVLphT48EyUSQG/+h+9fhl3k4jsmNhfUog6j0TkBn54u8ZjWW
	hAJwT5skjKUo1nvEWoXFevdAyRiohHU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XY6g0QDN;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794724744;
	b=fFhQeuks8JkgjthdhDRQ+r8xseowrlCCQHxEsrmvkAlBDNAXycsPFFDwXImldH/iYzDos8
	JaQDUxUA2rF2CLYUHyfri5DhkuoAsNZMr/whkysKB1ZzkXqNEhFZ6H8sByU6CVp+oPDDHZ
	8dGibibqmpZz8QNfYoDOPt4O7yxmMMs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B208B43965;
	Sun, 15 Nov 2026 06:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF9C1F000C4;
	Sun, 15 Nov 2026 06:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794724743;
	bh=5uzNQjIqKu1Z5H5h4ULFcPsML/9M2qNB6yySUHBpd2Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XY6g0QDNlp+U9PsTjMW6Z7U+4AKhATHLs5He0CZN49f2Nu0bcao4bAPuuwEsft6FI
	 TWnoj+VGBoUPTmb0EJCJXCsTtwSE0k13bv5Te+OZ5Acn6pVLSE5i/fhLT5QGKgwaOk
	 Ucb2W6afh0Q1yzMIuWl0IoyL1xjTDc8J5WHHCJWlw82oKPLfFptJE13O1Ok9X62IyP
	 xkoneXTm1OtIXF7WSDiXJH8M/fRN/bG7+qbjc7kJUeud8mWA9cz/xm6XTt15y1BZge
	 qGkeMJ/mOBJIxREW4t6uml5kStkcI3+UGIwjK5RYkeEIMSPndyRf3R1y4lpuaoL/kN
	 M2jExDr2sEOLQ==
Date: Sun, 15 Nov 2026 08:38:46 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Donald Dutile <ddutile@redhat.com>,
	Eric Chanudet <echanude@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Liviu Dudau <liviu@dudau.co.uk>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nadav Amit <nadav.amit@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Russell King <linux@armlinux.org.uk>,
	Sam Ravnborg <sam@ravnborg.org>, Song Liu <song@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
	bpf@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
	linux-mm@kvack.org, linux-modules@vger.kernel.org,
	linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
	netdev@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH RESEND v8 11/16] powerpc: extend execmem_params for
 kprobes allocations
Message-ID: <avlTdlK9ErlqVRYl@kernel.org>
References: <20240505160628.2323363-1-rppt@kernel.org>
 <20240505160628.2323363-12-rppt@kernel.org>
 <3f7af771-87a7-4ae7-9919-bc4c23bd31c9@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3f7af771-87a7-4ae7-9919-bc4c23bd31c9@kernel.org>
X-Stat-Signature: r8kx19p4rgf8exdozo79a5594916qxyo
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7D942140007
X-HE-Tag: 1794724744-418105
X-HE-Meta: U2FsdGVkX18dEM4VA7LNvV7GX8PA+5dnZai0yeE2UbpGHG2ccrFR7ztPN4Ksdz+2mVGC2YUtfnqT9KXDXR+Pe94Gr44ZQFpe7QPuL1JJWeiqUXYqvSsor+gD5I0IhPHdTG0PxaSA8S+1aF+hKpP7YYsmal+KUePUEmXussX2ICuL9iHZpzwbr9P+z0VoF4yXHo4Qad9q1GaPsIyvwvyKHaeBt4qUDLgrhRWwvkE2UvJNz9bBy2ZDA/VLTm0IgMm4FfIAtg3q8qdQbwPgqLSMdVPUTOfwophL2/BGcSkMNkCDjprAKNOQeC/uaXDPJoIXamPubilUsOemIEEsobu+2Mp2Hl4kkTh1ozvZ5blweD+iCbgrP0ZmSgh5GBFKKGGNnjbzPEPoYl7oN1gcEMo/vWxK6B/NA0Kg2J50gqjpKl9kDP6JiYWBsJOVIr27f6iJ2zhLVxJXf/OnN0ailOdQbtrEq8yY5/gV3Jp3slWNezjVuUt/XEXBKICtm1EFg9dYdaOEdOHLaCctbEHM7b5bFgy9sGmJ2pwKn4RPOiXai/JFXL7Y1nF2rOG5vzPyhEnxCwMF5I/pfkLfflOSd1w4zrnq0b9qWejFnVChJArCcXjxMqPtrpV9PK+luY13qdfTeGf2Abxo+rkUZLyAM4SRzXv4n1Yx1YhBXJZRaJ5djBDSh8tOSCgfK9ZX91cBiH7Y5N8Pbtgkc/B5AnZFyf9UBnDlT7O4bRmb8tbWocWVkUmUbpk3OnOUaFyeUR4Ba/gjk1V0D1xQGxu55UiKpBV4p05hwwDanVxq+p8LJxwBr0m4vaJvydIE2l8MYdUd/wCWl5qAufMYNXYXExVqXnjEAa3bI5YAMcSdUxUkDP5j6Ub2ZK21pFzu1Hx+mf3O6nnk2aoWEV8aMdBnmzFzXAOOY6603mHRasG+9dG/kzfZIl2Zlo14tQ1bRhWeSB6f/09pWgRZLUhDBhzNfEygEDK
 UIu2kOu6
 rcQ3rxbN2D5grwbyTBWwM7LehpIKpaOsjrn+dVHk7BCFwnE4W84Nqs5YhYRc/ZgSGYtAmml12X14KBJ9ukzhKYSKEej5EQxiFAEPvXlKXYphAcLYez9nIUZnY1CoP7Ma+1CsgjfCpVk5sx1QHeWsX67hhK3wzIG2Vw48EjihPDMbtG9UauEwAI1KCkKxCd51NOdSBsemvT79VCVZU6AWXmnmzc8UI3B+abyowNIXXfHWDWLyvuCL8Aw5Kq+wur5B3cMe70a5SgS5g8ymtbgbGdlkkG8uF8zB8ot+4/XIwlOo0ElJ0FtgCPE1T8uE1c0qTi1Ywh+0CRTKuZVXZ3avzEpiYIc/T2DtP+Vv4s/ml8dkrp9HVLqFAI9qzsr1bCmNB6e5oVldbDP1HeT6T+IUROSI+P46L0pZXKNLD6P/yGvVCkerGBqnyZ3uAn2vsEhmjDr6LizXy5IkEQQs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Christophe,

On Fri, Nov 13, 2026 at 03:36:01PM +0100, Christophe Leroy (CS GROUP) wrote:
> Hi Mike,
> 
> Looks like I missed this change ...
> 
> Le 05/05/2024 à 18:06, Mike Rapoport a écrit :
> > From: "Mike Rapoport (IBM)" <rppt@kernel.org>
> > 
> > powerpc overrides kprobes::alloc_insn_page() to remove writable
> > permissions when STRICT_MODULE_RWX is on.
> > 
> > Add definition of EXECMEM_KRPOBES to execmem_params to allow using the
> > generic kprobes::alloc_insn_page() with the desired permissions.
> > 
> > As powerpc uses breakpoint instructions to inject kprobes, it does not
> > need to constrain kprobe allocations to the modules area and can use the
> > entire vmalloc address space.
> 
> Using breakpoint means the segment must still be executable.
> On book3s/32 VMALLOC segment is not executable, while module segment is.
> 
> See commit 6ca055322da8 ("powerpc/32s: Use dedicated segment for modules
> with STRICT_KERNEL_RWX")
> 
> See report and fix at https://lore.kernel.org/all/ed03d290d440d579a81ae0b7de5243721291d903.1794543909.git.ritesh.list@gmail.com/

I'll take a look, thanks!
 
> Christophe

-- 
Sincerely yours,
Mike.

