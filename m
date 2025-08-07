Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41609C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 21:14:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8648E0002; Thu,  7 Aug 2025 17:14:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B996A8E0001; Thu,  7 Aug 2025 17:14:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A791A8E0002; Thu,  7 Aug 2025 17:14:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 929C98E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:14:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1731A1A0F6B
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 21:14:50 +0000 (UTC)
X-FDA: 83751215940.14.F1253D4
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf18.hostedemail.com (Postfix) with ESMTP id 97EA61C000D
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 21:14:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z0Uza2f2;
	spf=pass (imf18.hostedemail.com: domain of kees@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754601287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vvt7a/mrUGwAoiJcIhMBOB3WenYophyan++uFXO9peg=;
	b=4pvUjc07A+hBWwLJy9AwI7ByhNars5YvUaFfm5QiDbR5W2jESs9FW5r1W7RB7qvYd2qkAC
	zgh5icFCfhd/FJBl/h2xX4GVzRthc55l1z7BBVAgFHWG2MxpLOQtSg9tw3+7TOzn2zRlVw
	YwsbOkOjp17tBjmRQdnTsSA2+B1Ht0M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z0Uza2f2;
	spf=pass (imf18.hostedemail.com: domain of kees@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754601287; a=rsa-sha256;
	cv=none;
	b=659yRhe1IncbnbhKdLpyFHVTHaFeZs/ZHDyk+24gxl9NfrYh3jbWtOapwUiUCHhwYAfXch
	xQag375uuWdKgmBUCMWdAZT7J2mK6J5ju6lIJnmnhj5jdZksSxoTKYqf4Q81f5wV1drKNP
	EPMGUcRL6a7ElEqgRvfEs2EHXzvb5xk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id DAF00A567AA;
	Thu,  7 Aug 2025 21:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B433C4CEEB;
	Thu,  7 Aug 2025 21:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754601286;
	bh=HAI5f935R1NcGS6jxC+XUnRQCfI1j4+QgnE9A5gcjvg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z0Uza2f2Y0cfOBQOIDPShmRuzwE+/VCihcPmxgI16bYQV+j7022KPaAolF0po2PlE
	 aCVlZYMD8Qq8UGF23DTxD6WhoR+OY4Isq9kXEnA/WDtxvT8x3+HXseLFArZvBjsdM7
	 jBUSUZfzSCNRR5aXCp/p50t1Duc9sfemsH5kzpx3PtLzisuUAme+MaY9vwO5TE4G9r
	 gK4xsHtrlx5vRqCG74r5f+P6jjyQPj/UYmS3Wxy1p/O3ZgLKBteG7OuPay67wMtEB/
	 AonJJIFXC8Eb0/QPKiZhBcwVK+wJzkJ5n1jzqRJlNz0ugcvQH1cO2uVuZvoOHZat6J
	 G//Tq55dlXzlg==
Date: Thu, 7 Aug 2025 14:14:46 -0700
From: Kees Cook <kees@kernel.org>
To: Svetlana Parfenova <svetlana.parfenova@syntacore.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com
Subject: Re: [RFC RESEND] binfmt_elf: preserve original ELF e_flags in core
 dumps
Message-ID: <202508071414.5A5AB6B2@keescook>
References: <20250806161814.607668-1-svetlana.parfenova@syntacore.com>
 <202508061152.6B26BDC6FB@keescook>
 <e9990237-bc83-4cbb-bab8-013b939a61fb@syntacore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9990237-bc83-4cbb-bab8-013b939a61fb@syntacore.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 97EA61C000D
X-Rspamd-Server: rspam06
X-Stat-Signature: k3ugpc5gxg3koue9dss1xrmqtkdaj6sf
X-HE-Tag: 1754601287-736332
X-HE-Meta: U2FsdGVkX19730J1HJUsHEwisau91GPwL7eXBMygUJtSirUcyvOTnjlDr6lW32zJAiQYO7AIPq1BYYo9MbH9mYFEW2rwBLIKJLFG8kA4EKTwFrBoI9EyVyhWdMU+4yx0lwaoRN5kCqwJCZQcKJNZWYJ9zLqLZpsAx+NwcV08GbW/hSLt3KSTGS6iVgrq5WfyvDOsqV4UARxTwt76iQFFa10/XTWxIaKC2DBWpNW6wkGa7lnFuH9RL659RYDmLaJ3pN7pESR4ox6SNH7oePA0zvPTeQeQaKGZsZ3Ihba1Ky9OQ3J3QuCLW6LAqTrOv+xZ53Vx3xYG+lSJ8u1je9Uo47SWLVxJmsRRf6kjNhE9UR7q96DMKs9f7yRVm9PT3Xnlp63mZeO3DTQ/KnWLHTn2OMRXYWTtSCQFKFuJC+++CpTsnhXbDjE1fg4Oj/XkRYKY8F5B4hHaSb4JVFuo7uoKaea/jxaa18oLbJhiTaLHJFqeexXB+B9s8ME0emI9mO4fcYM6sS3M1LfHbD0B2q7Eti7yO5kWHoLlrxgsn4O77yvjqIWPcsa8vIIHLjCxXhco7cLM7wQf7aUoIEFNgQhgkbKky0aHcdmeb4ERZlFh9v4qQMaQHxnRp8Lh5iEcU2gcH8fDraKtJtbXJ0Q12Hzy3OuSqLQcGjkDK5p1as/PJfFR2geFNNuEGhhOFqr+lX+7jiiSw03g/yxMferD4MNFIP01QTHDYlb5y38cbOkrXPle5W+F1tyajWREWR0a6TSHdHIhHGif2wCo6ikA/VSCePDV78yGBfaNE+EEtFQ4iLLiDe1sCMKSJIew5VFp+DfIDVWxTjooFEVRpfr3Qri6oPU4+S4hbmFFyMscV7g+MQbgZFF+9DFzfbiB1Ubk/6HwaYmyqa+uOI3hxykQMWZn+O9p5O0ZVUVtcKRvOM+gtqsZ1U3jXmpg5n5+rUqDPEuVOTJLQSmYLngP/9G7E3C
 JpuoKqFB
 U64+shWWtdLUS4ZzLJykCrIYeCB7InFExxDcN1NnNrLsCOHqPuzssIdpusK75nIFT/H19OiegR8ixMgo6W0ujUtpc6IWuyUfXRPNGL5A0KQyl7sX9MZlGXg3oJvt0Aif3NluXsXlTSLh85el6CT8WdlcSaY91urd+Fex++AUzWljkNakmH8Jyf4spFFXdYjwgkQJ0CZuY6jY6PEb1cWzxXt8jN7bauJA+Tky9MRlMurPeYMjMm9vCrVtwzlzQHnTKiLeG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 07:13:50PM +0600, Svetlana Parfenova wrote:
> On 07/08/2025 00.57, Kees Cook wrote:
> > On Wed, Aug 06, 2025 at 10:18:14PM +0600, Svetlana Parfenova wrote:
> > > Preserve the original ELF e_flags from the executable in the core dump
> > > header instead of relying on compile-time defaults (ELF_CORE_EFLAGS or
> > > value from the regset view). This ensures that ABI-specific flags in
> > > the dump file match the actual binary being executed.
> > > 
> > > Save the e_flags field during ELF binary loading (in load_elf_binary())
> > > into the mm_struct, and later retrieve it during core dump generation
> > > (in fill_note_info()). Use this saved value to populate the e_flags in
> > > the core dump ELF header.
> > > 
> > > Add a new Kconfig option, CONFIG_CORE_DUMP_USE_PROCESS_EFLAGS, to guard
> > > this behavior. Although motivated by a RISC-V use case, the mechanism is
> > > generic and can be applied to all architectures.
> > 
> > In the general case, is e_flags mismatched? i.e. why hide this behind a
> > Kconfig? Put another way, if I enabled this Kconfig and dumped core from
> > some regular x86_64 process, will e_flags be different?
> > 
> 
> The Kconfig option is currently restricted to the RISC-V architecture
> because it's not clear to me whether other architectures need actual e_flags
> value from ELF header. If this option is disabled, the core dump will always
> use a compile time value for e_flags, regardless of which method is
> selected: ELF_CORE_EFLAGS or CORE_DUMP_USE_REGSET. And this constant does
> not necessarily reflect the actual e_flags of the running process (at least
> on RISC-V), which can vary depending on how the binary was compiled. Thus, I
> made a third method to obtain e_flags that reflects the real value. And it
> is gated behind a Kconfig option, as not all users may need it.

Can you check if the ELF e_flags and the hard-coded e_flags actually
differ on other architectures? I'd rather avoid using the Kconfig so we
can have a common execution path for all architectures.

-- 
Kees Cook

