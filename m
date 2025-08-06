Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C39C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 12:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34266B00EA; Wed,  6 Aug 2025 08:03:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0BFA6B00EB; Wed,  6 Aug 2025 08:03:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C21DF6B00EC; Wed,  6 Aug 2025 08:03:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B59976B00EA
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:03:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7A8671A05A0
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:03:06 +0000 (UTC)
X-FDA: 83746196772.08.AD7F85F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id BEC491C0009
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:03:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jjiq6aMR;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754481784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=81JXfzkVsyn+mq9Qc73a6tmqTkZ1oKa6uSM635i0f3M=;
	b=zXMnnsISHJvtUckFt9G/+WlLJkxQ5CjD6ULqSZgIwJbnn3NDXjjUDPw69vNPnsE+UM4sLx
	x6TNSQ/rlOkCuKZ++8/onLyzom8/cNkD/Qu6SFpkl+a+IzrUohY9mZJvqKgopmiYu6Jvs3
	OmmL9Ueh62LOqRyoM4P/xViZUfnI7H0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jjiq6aMR;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754481785; a=rsa-sha256;
	cv=none;
	b=D52xyTsOwujCGwbNSW6G6PTF1fsck/ZyOrFTz9/NX1QTcQ7Ui43hWyLjktY5rcMz+FgkXi
	iOW0b1uVmJAPPtc4j8viRBPxd7UHCLiQ/4xJDp23WeJJcl5gHv8ydWbraf+AjfAqJCXR+N
	EzlAC0Nxjm7oN7YD9V5IFhykyZiitMk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 442134532F;
	Wed,  6 Aug 2025 12:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F95DC4CEEB;
	Wed,  6 Aug 2025 12:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754481783;
	bh=iM3DL6rk0RbOHKY0NOC2WS44N14rliZCsKY1vAOE0s4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Jjiq6aMRhbWCv5v74m8F3r/WETA/ORQJKafiqRDXRe1OAI+ZWJJuCD1Rb6RuQ930+
	 cxGf4XAVSsFnHxzsV5imiaoQi0U6QxnVqa8b8jhLJGQVPqjYAJT4WtOESQLnTEBLcr
	 PdrWB5UTHuhRc/Pnc1xgTVONPRQamGcj5PEpEu4aaFvYE69JKzAXlBMhCIo9lhfz44
	 kEl96fvPjQh4UQOa0ISpr/HxTvDWPp2GXE9WRbQIt7uQJq4/rQk83yihh/4AsBrZd6
	 q/rJ9lbo1yIC2+m/EGCJJXcKVBbUNpsA8xDbuSon0D+0WkBHxTLxmAIQsrl9vAYYOR
	 Pcqs7riARcj7w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Steven Rostedt
 <rostedt@goodmis.org>,  Jason Gunthorpe <jgg@nvidia.com>,  Thomas Gleixner
 <tglx@linutronix.de>,  jasonmiu@google.com,  graf@amazon.com,
  changyuanl@google.com,  rppt@kernel.org,  dmatlack@google.com,
  rientjes@google.com,  corbet@lwn.net,  rdunlap@infradead.org,
  ilpo.jarvinen@linux.intel.com,  kanie@linux.alibaba.com,
  ojeda@kernel.org,  aliceryhl@google.com,  masahiroy@kernel.org,
  akpm@linux-foundation.org,  tj@kernel.org,  yoann.congal@smile.fr,
  mmaurer@google.com,  roman.gushchin@linux.dev,  chenridong@huawei.com,
  axboe@kernel.dk,  mark.rutland@arm.com,  jannh@google.com,
  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  anna.schumaker@oracle.com,  song@kernel.org,  zhangguopeng@kylinos.cn,
  linux@weissschuh.net,  linux-kernel@vger.kernel.org,
  linux-doc@vger.kernel.org,  linux-mm@kvack.org,
  gregkh@linuxfoundation.org,  mingo@redhat.com,  bp@alien8.de,
  dave.hansen@linux.intel.com,  x86@kernel.org,  hpa@zytor.com,
  rafael@kernel.org,  dakr@kernel.org,  bartosz.golaszewski@linaro.org,
  cw00.choi@samsung.com,  myungjoo.ham@samsung.com,
  yesanishhere@gmail.com,  Jonathan.Cameron@huawei.com,
  quic_zijuhu@quicinc.com,  aleksander.lobakin@intel.com,
  ira.weiny@intel.com,  andriy.shevchenko@linux.intel.com,
  leon@kernel.org,  lukas@wunner.de,  bhelgaas@google.com,
  wagi@kernel.org,  djeffery@redhat.com,  stuart.w.hayes@gmail.com,
  lennart@poettering.net,  brauner@kernel.org,  linux-api@vger.kernel.org,
  linux-fsdevel@vger.kernel.org,  saeedm@nvidia.com,
  ajayachandra@nvidia.com,  parav@nvidia.com,  leonro@nvidia.com,
  witu@nvidia.com
Subject: Re: [PATCH v2 31/32] libluo: introduce luoctl
In-Reply-To: <CA+CK2bA=pmEtNWc5nN2hWcepq_+8HtbH2mTP2UUgabZ8ERaROw@mail.gmail.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
	<20250723144649.1696299-32-pasha.tatashin@soleen.com>
	<20250729161450.GM36037@nvidia.com> <877bzqkc38.ffs@tglx>
	<20250729222157.GT36037@nvidia.com>
	<20250729183548.49d6c2dc@gandalf.local.home>
	<mafs07bzqeg3x.fsf@kernel.org>
	<CA+CK2bA=pmEtNWc5nN2hWcepq_+8HtbH2mTP2UUgabZ8ERaROw@mail.gmail.com>
Date: Wed, 06 Aug 2025 14:02:52 +0200
Message-ID: <mafs0ectod5eb.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: BEC491C0009
X-Rspamd-Server: rspam06
X-Stat-Signature: sun5y3pj7ezygusfiowpqc76hyf5rmoq
X-HE-Tag: 1754481784-165855
X-HE-Meta: U2FsdGVkX19mrNsFHcJ8/xfkSPEswiYwcsU7y1lyY/MR1pk9h9535AOnF5466GSdo1HIFMowKnIWGCcn+P0+QtYAbG/jcgZ/Z+wObNU1FZitE0RDqPKhBF4VqhVWIBbmrvkh8UhnLqZiWhNNgCcSd7AXs87k/tEbJ1WGcCk/GouK2nrZ6I4LxIHxRGQ+L6EyCjwNSnE5v1BPJ+NKGkkuRcxihxRzL0ywz4O8qPUr6Rd17X4utx99Wp3YSTtAkVNG1RieRwdS/jbfSx1Jgmoy/lOdu+3dy2nopIWX3kgvBIxmY2K9cZvxBhXvEymAL0EFPxsQUFOguIrXJf6ZFVhedjS/He6UuW7ObF38jYBSM6B7ai4bP1SJDBDwTqwf33u0CCVbB1ZfNSm8GTI/ZpiWAY1sKEAnpht5BNiIuJFGwVaJaJa4RCvUviuUJBAhN4HYtP9E3mQ9JszfQfildcA8AEroHTzlv1REi6HG5bm1yREHbjjO7XOM7CrofAUGfK1x1A2XgxRmr7jwhLJa2Bh5PMpWHijFueTPv8+YamERIebiDUnHMRsi06eyfjZMk8AUXP0DMiHSBA0KDNEo53EakCoSm5f1Ped7BB8ssAzZsa+ySYksXmChY62+UwVtSESdvLV/dzbNk+GqCm+wV1qbbPRwZJSL4+8RP6KZ5PNABPyiIejsLAJde0L7GWHFy+4WPHNlDHN8p4AblNUthbUs2RvzNVAVXdtcBka9Oii3yohABiP31N8+VI8MaYXDbF7BvtnYmKI9busPdS4zdUaSYDBYvUYJM8Ki14BmmhZVu4OB0qfHsCEF4o66qUaiAA9Dt7XYihJMgRUAN3dKlwgtNOH3w2SBGezjMbyj9kJD/sbj4PxPs2SIMM8EJVaTpH6oAE9TEit9R0+Sf6GTUnItVWi4WbglZxPUjWgGAe6ZelqKDsgyNT8wkEfbaSVGznyoY9fWsY8Ym+vaiicAflb
 zO5Y8Uib
 yp+Wwnp3cXSsHgxW7M50YKLIh0MRNcH3bMzLRd7OjMKpo60O8TmwK2zGbnn4agGwCr4B5qMnyaKMMQMaLQmyht+Txzy8IXaPcFPZLXhV5E2xCkGSsFIDZ6xPIdpliXkOivqjhIZa89SFB9r0WpuQLx/ybcmt1AmsFkFlHdnN3cFTziQowP1Cpsr+VDAEyLytNCNRlNWCXm3/QwOGOy6wVOs9QTY0QNIgNulrCsMX+sdGhDRw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

On Tue, Aug 05 2025, Pasha Tatashin wrote:

>> To add some context: one of the reasons to include it in the series as
>> an RFC at the end was to showcase the userspace side of the API and have
>> a way for people to see how it can be used. Seeing an API in action
>> provides useful context for reviewing patches.
>>
>> I think Pasha forgot to add the RFC tags when he created v2, since it is
>> only meant to be RFC right now and not proper patches.
>
> Correct, I accidently removed RFC from memfd patches in the version. I
> will include memfd preservation as RFCv1 in v3 submission.

I didn't mean this for the memfd patches, only for libluo.

I think the memfd patches are in decent shape. They aren't pristine, but
I do think they are good enough to land and be improved iteratively.

If you think otherwise, then what do you reckon needs to be done to make
them _not_ RFC?

-- 
Regards,
Pratyush Yadav

