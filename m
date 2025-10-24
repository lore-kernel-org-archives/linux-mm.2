Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC189CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 19:00:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEEBC8E00EF; Fri, 24 Oct 2025 15:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA0038E00C9; Fri, 24 Oct 2025 15:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB5338E00EF; Fri, 24 Oct 2025 15:00:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 99E1E8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:00:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3715313C565
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:00:31 +0000 (UTC)
X-FDA: 84033923862.20.85783EB
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf09.hostedemail.com (Postfix) with ESMTP id 69D15140012
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:00:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761332429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rnAdtCsyakXzJyyEXalNqpXAn/lYC1E4yZtetoUry2I=;
	b=KjOItqn1fTRtjqgLKfjzjuMHD0/i4/zZvIiShyS41l14mGqDLm4qDU0QSwskKseGi7UoFx
	pT0T/lu1P8RHfx9bgOiIeGB3NTjiy1v1bgQJKYBVIk5VLUPUZz56xGkXUx5oRJe4O+RFIv
	OPpInZ6Dph5jwzmOPNlS2WZXpQPZklI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761332429; a=rsa-sha256;
	cv=none;
	b=NH1+7FJSchh4q3uyrfLiG3y8mLqKDUlmPHh0M8yGCecKA6TaP39nCS05P0VFiNYLZK9+7F
	lQUe2LnD10VWqbfQN13JepsS2XStpwm9UuMy3UAGobtSPXmMFtZd8BNiVEoK9ZpfEShbdU
	FB2VEU7j1YCor23MWpjSzjj9bGSqz7w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	none
Received: from omf08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5BCBBE7B8;
	Fri, 24 Oct 2025 19:00:25 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf08.hostedemail.com (Postfix) with ESMTPA id B3CC720027;
	Fri, 24 Oct 2025 19:00:16 +0000 (UTC)
Date: Fri, 24 Oct 2025 15:00:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jens Remus <jremus@linux.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Steven Rostedt
 <rostedt@kernel.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, x86@kernel.org,
 linux-mm@kvack.org, Josh Poimboeuf <jpoimboe@kernel.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>, Arnaldo
 Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Andrii Nakryiko <andrii@kernel.org>,
 Indu Bhagat <indu.bhagat@oracle.com>, "Jose E. Marchesi" <jemarch@gnu.org>,
 Beau Belgrave <beaub@linux.microsoft.com>, Linus Torvalds
 <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>,
 Florian Weimer <fweimer@redhat.com>, Kees Cook <kees@kernel.org>, "Carlos
 O'Donell" <codonell@redhat.com>, Sam James <sam@gentoo.org>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, David
 Hildenbrand <david@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka
 <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>
Subject: Re: [PATCH v11 08/15] unwind_user/sframe: Wire up unwind_user to
 sframe
Message-ID: <20251024150045.5fdbfb6a@gandalf.local.home>
In-Reply-To: <6b5c0c64-c4da-416d-a103-8d6ec2f06a9b@linux.ibm.com>
References: <20251022144326.4082059-1-jremus@linux.ibm.com>
	<20251022144326.4082059-9-jremus@linux.ibm.com>
	<20251024134415.GD3245006@noisy.programming.kicks-ass.net>
	<6b5c0c64-c4da-416d-a103-8d6ec2f06a9b@linux.ibm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19iy0relq0hsycahgoTlXBcrmF8ZC/GxZs=
X-HE-Meta: U2FsdGVkX18ubh822JQukhagA4rmyZ/kfFZ5e9GBo5bHGmEcFo3R5wrw+1cNrkalDAZsGy1EymjeMHOvmc+qfcEJjivdvmslflP/cCPZQm6vsoqHmDNgexfeEZWDP3fXLN/3PWR7NOuwSKK9Dgp69k8l/ZOb651Lci4jwPdj/HqW0nSyCxXm45JJSvokANbRiozVvP6p37v+DWjDJYxDZh9Vsk2YPQV1DGwEadcGYfQqRu7D+3A+8InWOYOqM3h+/JyWlkB4A4hRNJfCKGE4D6FHEGWpSqrdzugRjEFxubyS8zE0ycnMrulBlS+Z11oaDq2dZpehUVm8XCFSDafwZRLq3La1yEcZ4SWdRJvmXpCTybXp00PcB8acZ6q4VqPJcltalzuk0eKEIgDzyXQ9b77CWyR88irNcuRIF7Ky2OQ=
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 69D15140012
X-Stat-Signature: meot9n4skde9zpjhbqgjtfhxopiebfpq
X-HE-Tag-Orig: 1761332416-792391
X-HE-Tag: 1761332429-17114
X-HE-Meta: U2FsdGVkX181BfnSKOLqDUp5eVhgPz+1IDtZH/rWCZszHicJb4AHFIc25bIAKJqwHL3lCoBdv2v8fESchmOdpAwbEDB5vSJVT9jrA/W/2IPT27+tCX5Ei+D4Dx79f5k/HHIK9U6emxv2Ulv1uvzxMzl4hqoQuUA1JxldJVOnQSxuvcTbIjVZ4cFlgxHVBcgdeC4uG7jP0ed3udk3UGYI/OFk8pyV/Wh/o+uzsc8KRyinc5PFaf2QASZZPwMoVmrgZnhhj2NC/W4d7JW+i7TKMFMaOUjaEvrXgdTOD/dYYjfafu3OpJ2idvuWUImyNzZGDCwphBjDaC+hEvhSak0ZWyZ3HjYvfKqjBxffzAzV3+Qb+2XATg/vI7CU9bj7LaEur0MfMTxWWAMlYFZ6Wt2GUPEpjs5yjdvKMY2Hg5Vsug6dNoj4x4g431bvViirHKBrQ3hC2d5omIh/mrR4dcEN+TwekaZuimARNgDc1DtQWS/ovSMn28Z6asIiMjgfnx6NoBP6GBglqVtNjIW7ckf/t3M3vFgkpGkR6WKjfgA/3uzQ9/DOCVRtbdOawAvfCdazFJn2+NRS5l2eql5PnMG3CwIUpKxPGnYLHzchUSOqtq7z/be0h0DQzh1d6rbs+kCzuwGErkHRtfLWC2BAulEBfcf15hbaX3dw86XmH6Ny6G3Xz8uOr5tKcqNEX3nmfsBPUcl6sQB/ijNAniCipSwS/v8TBq0c9jcMJlCYSxqR3BT3+d84sBhRkUn8jrIUz0OEBgtiJwQrjwhGO6oUu1BirGUtWjhy3E3pske6pyJf8NZ2LRON2A0qo0PJxr+F/BcuhekCwrR4s5unUEUWqwgUuZofe9xOAr7pKYGjrkqZDujrpmeZacTgoCroUSXiLV3iKZWyJGf/ts1D2afM8drtMHwLKHdgxwWFzC7QZomz4MvTfkHfH8Z6cMdxT0M5ypsB2qXCJXcD2bWe4JnHze5
 f2CsrkiQ
 50Y+5nQzRRbpUUuwIoJnVAnGMeRsE7MGTNWaWYYjpOJ8ogxQzFTjykzw6G3qYqO52ZZ6Qfp3hXHXTpUSxahsajIsUgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Oct 2025 16:29:07 +0200
Jens Remus <jremus@linux.ibm.com> wrote:

> @Steven: Any idea why you added pt_regs?  Your v9 even had this other
> instance of unused pt_regs:
> 
> +static struct unwind_user_frame *get_fp_frame(struct pt_regs *regs)
> +{
> +	return &fp_frame;
> +}

According to the history:

  https://lore.kernel.org/linux-trace-kernel/20250717012848.927473176@kernel.org/

Which has:

  Changes since v8: https://lore.kernel.org/linux-trace-kernel/20250708021115.894007410@kernel.org/

  - Rebased on the changes by Mathieu in the kernel/unwind/user.c file
    https://lore.kernel.org/all/20250710164301.3094-2-mathieu.desnoyers@efficios.com/

It looks like it came in from Mathieu's updates, which was trying to deal
with compat. But then after noticing that compat wasn't working on my tests
boxes, I removed it. The removal failed to notice that regs is now unused.

-- Steve

