Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24AE4E7BDA1
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 11:39:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 517C76B0088; Mon, 16 Feb 2026 06:39:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C1816B0089; Mon, 16 Feb 2026 06:39:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4026B008A; Mon, 16 Feb 2026 06:39:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 285AC6B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 06:39:53 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B652C5CDA4
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:39:52 +0000 (UTC)
X-FDA: 84450125424.14.685860B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id E68BC40002
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:39:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771241991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nar597bGzXCnn4gRsFxaCdpoqPt7HhkceVvoLTezTTE=;
	b=IJ1dc1lcKmS16asibnr6k+6Uf/P4mndhOrBtPlFHeL/mFkiLHt7dcpLJ41saW4UfFilxRQ
	yRt87GMCyLeG7G8QExyRVfnF5f779pyI068YhkCcOzxqT8T7gNiaqsdagj69yxtauzMIEI
	RRtmGOm7R+tPhdtDy77fqyILk68Ga+U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771241991; a=rsa-sha256;
	cv=none;
	b=lKIVPaferFBKwm1EE7nhyXACfjX0KNN/GzlDvosUCeig15gN+YqprMDEprYWcTcgWIYFOj
	tOvpdAK7vzajZnbIqonjschgAedpHH78imuLY6o1ViNMxTazsszVDfTLfT3NqbLX+DX7VE
	Fn2USVX5BSrvcPIFTqEo0kvdEcr6ocE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8BB82150C;
	Mon, 16 Feb 2026 03:39:43 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E0DE83F632;
	Mon, 16 Feb 2026 03:39:47 -0800 (PST)
Date: Mon, 16 Feb 2026 11:39:45 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yang Shi <shy828301@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>, lsf-pc@lists.linux-foundation.org,
	Linux MM <linux-mm@kvack.org>,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>, dennis@kernel.org,
	Tejun Heo <tj@kernel.org>, urezki@gmail.com,
	Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
Message-ID: <aZMCAWiA7XHYLIE1@arm.com>
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com>
 <5a648f49-97b1-4195-a825-47f3261225eb@arm.com>
 <CAHbLzkqRjuWg7ybdkuv5xdoPz7z_q2n+0Eh0pRNoVxq-WskRvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHbLzkqRjuWg7ybdkuv5xdoPz7z_q2n+0Eh0pRNoVxq-WskRvA@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E68BC40002
X-Stat-Signature: q7q6rchbgb5te95cq4n3f7k89xzg5x5j
X-Rspam-User: 
X-HE-Tag: 1771241990-265161
X-HE-Meta: U2FsdGVkX1+ga7snQxY75q/hW4PXoiCwgTIXKDoTVjmNbWsZpwvzV78SaqI/lapu8/7NI5lEKeJTmMMOR15C3OABQQw7joz3aAdjlY73lYb1+piBjtiAjY9mQNlYG3Mv59CfUcrYuBT3y98pbeO+SUHxzTSLNwUpgH8cAflOXOxhJSWBQ1GRU6944cp3uw5lF1bfKkAJGEqKaRRh90xQi/5rWacwlUU+5K2l15PTpOvzLQxJRmY5PkgXXoeTqJv6xbf5DffL0cK+tBcwHPftGSY/IFfBtwugl4sxSiuLY9VLCITbNqRwPucsEZkmwf3seRdIAYicKpx/IIH+HVNWIRHXD8hSufmS/FMGUB0Dx1RFuIsu2FBPUiuudCTrkuqLMNurHFIQnmMXawqQXRsC6gP2DodIMioZe3vmOtIZaT+OL5YT53WEpxA6SlOxeP5ZfYOE/PFjFHhrMr+csTEoPOQUJRvCXgEJIS3xw90XW9gSi6bxHC0GTRKLfa7ALt6f9fWWxzxBOFjAePsbhEkKDOipgzhE/zo7ucMkWEq/yHFeEBCL+1AMetAtZVjkwYtopwp+a4zWNlIOZFWQ+v2ZwXgEnI1Rzs8G+ezyCHIcceWMOlMRjMLAg0HWQxz84Ntn3YO9u6YrH+Jax0NXbd8UV1mNlO1CT/XIaJIEVOYsumjHPjgnqBqD24xdaw5C4uytULHmlrzaabB6I6Pu0lJXmJdnjdvE1tQoeQOthTvqY0vNcf6+7BSopjEpBalIrXEFA+j6DXB8q8O71/ocwqkztE/RJeglR21zD485cACV9HneovGpmXjkbTO8AU96Y9sO/59OlqnfuzVUj8NkCbh3H8RxARB/74HGmwlENp7w2shMi/NfZnwYgi8C2Uo2nLxNDR0IB2tLQ4iDiVzhqyAO6lasBHP3uTRUBFMs3+Gkqq9RI8XD0eCtbP+ADD16BGM28QcAbJZcSrMe7uNwPDR
 l/3lVWHH
 3gHnTHVUHYuP/jy2Qpa0cONnYRmB+ObaihYnesdn9rcoDFBhAyGGrhsrr8dA7SIgfE2t5wsRPsGM/rc/suGZvF/GRC5So6iw/q6FiF5jmQ9qqPDTUmfIya+LPtUvFLWGxL7gPhDIXSK1g4kQZvtH5Yk0SFbWKdk3/H0m+PcqFS7A6RUtnmIZdDNZ3FuHNfjB77QCcjFcN90SdLdekIqs/WiYMcJFkbj4DJ3EcmCc51bswHtga0mbAQiJF0SeUGUDsDgYh7MTz5j6VQZY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 10:42:21AM -0800, Yang Shi wrote:
> On Thu, Feb 12, 2026 at 10:42 AM Ryan Roberts <ryan.roberts@arm.com> wrote:
> > On 11/02/2026 23:14, Yang Shi wrote:
> > > So, the code flow should just become:
> > > INC VIRTUAL_BASE + percpu_variable_offset
> > >
> > > In order to do that we need to have the same virtual address mapped
> > > differently for each processor. This means we need different page
> > > tables for each processor. These page tables
> > > can map almost all of the address space in the same way. The only area
> > > that will be special is the area starting at VIRTUAL_BASE.
> >
> > This is an interesting idea. I'm keen to be involved in discussions.
> >
> > My immediate concern is that this would not be compatible with FEAT_TTCNP, which
> > allows multiple PEs (ARM speak for CPU) to share a TLB - e.g. for SMT. I'm not
> > sure if that would be the end of the world; the perf numbers below are
> > compelling. I'll defer to others' opions on that.
> 
> Thank you for involving the discussion. The concern is definitely
> valid. The shared TLB sounds like a microarchitecture feature or
> design choice. AmpereOne supports CNP, but doesn't share TLB. As long
> as it doesn't generate TLB conflict abort, shared TLB should be fine,
> but may suffer from frequent TLB invalidation. Anyway I think it
> should be solvable. We can make percpu page table opt-in if the
> machines can handle TLB conflict, just like what we did for
> bbml2_noabort.

It's not about TLB conflicts but rather using the wrong translation for
a per-CPU variable with CnP.

-- 
Catalin

