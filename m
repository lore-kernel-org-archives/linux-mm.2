Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 370051099B30
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 20:24:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60ED66B00F2; Fri, 20 Mar 2026 16:24:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E6746B00F3; Fri, 20 Mar 2026 16:24:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FC176B00F4; Fri, 20 Mar 2026 16:24:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3F0B56B00F2
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:24:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C5821140367
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:24:34 +0000 (UTC)
X-FDA: 84567569268.05.F558EE8
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9CAAA40006
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:24:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ey5KmEcN;
	spf=pass (imf12.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774038273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yaacsJbs7+53UVhkwxDkhvqyBamYYq/AMuyWT9p6SAY=;
	b=ZRNvylnZn8KLIBLvF14Vrjf6AEMLJ982NLxIow0yIUEgdGnzyB4ynKJCO3kGIO4Hy6H4Nu
	s6+onnOJjM0c1LeSuHDF9SEVJiAWWU4ppjxSDQgtKHRymx80dVn8YBmMdMhb9yCc67yrE/
	eRRCp45882mqLT22U86pm02SPPmR4hc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ey5KmEcN;
	spf=pass (imf12.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774038273; a=rsa-sha256;
	cv=none;
	b=W+lcAPJG8GPKKGrLUFd94If9jnhv2UMVNbgRjguOylNFgisoWnSfYQlqMtcbfmuCNL5tg0
	hUYH6lkNtEFBW8BVMl3hzKpNBN1OhkuKwl3ns3zsmSR/04aw/qeRpzNcGzEyghBWWrPikV
	8PpjkM5Orfsy6bXYwYEgfLL3K6BxFWg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774038270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yaacsJbs7+53UVhkwxDkhvqyBamYYq/AMuyWT9p6SAY=;
	b=Ey5KmEcNYzzSZnBR7ihUZ7Qew7rU8Hhsw+kZb57/JgQynxuwEPyFVO/nhKZrO9E+59eKih
	CPle0NDgKJvpOkAC2tksb8xAiA3Rh4k/cIt1ltJTDcg0XiTkphJ6cHGM0NZPcroaMsDXL4
	YzdVb1wgWPq5VjBgoM+XAL6AFPmXVDE=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: John Hubbard <jhubbard@nvidia.com>
Cc: Miguel Ojeda <ojeda@kernel.org>,  "rust-for-linux@vger.kernel.org"
 <rust-for-linux@vger.kernel.org>,  Alexandre Courbot
 <acourbot@nvidia.com>,  Zi Yan <ziy@nvidia.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Gunthorpe <jgg@nvidia.com>,  Leon
 Romanovsky <leonro@nvidia.com>,  "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Sashiko.dev for Rust for Linux
In-Reply-To: <1f94cf47-9898-405d-bdf2-29e21cd87528@nvidia.com> (John Hubbard's
	message of "Fri, 20 Mar 2026 12:40:51 -0700")
References: <1f94cf47-9898-405d-bdf2-29e21cd87528@nvidia.com>
Date: Fri, 20 Mar 2026 13:24:24 -0700
Message-ID: <87ldfmtfk7.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9CAAA40006
X-Stat-Signature: mxgciexo9hqhripyiqi8194cnrtzza48
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774038272-583471
X-HE-Meta: U2FsdGVkX1+KukPKhB7U0CLFeEB0pF/Rb/0e3C7/t38/QOPBvPcUk/01CgBo7f/b3+gVgws6lZIc+cbBfo4u+s0i6StHB+n0EX0aQnBPl/lIIV9ZU6Vc+Q5sTpUTaa+6oMkPQzlTjcf8smgBknTvzyYO19pJM6a49Mw+GQ6zFPXeQW6GR/9TM1AeBUslmIbQNR3EwVzmII94h5fWaUeibsX6TotUVibzEd8kAGFHeAv1Dhx6XAvLjOpWwuRlY64Hn0T903Pw8b4tvZnZXhAdB8cpAXj4XdOnSiMuL+rwkUhZQhgdGPms2D8iNnKczQ7yFlIJXe2Ag/sr5cqoUhoZxZOv2WKWx6I5b6pXiy3V/0uOB1C3sBGhdOZnH7kPMGH/dyekGMRRWkL22g00sBE3K3lBKfRXIRfEcT6NBUKij/LVXCscQvxPMc+nDntmp+Zc8M6+BH2bGwaRPFG2jxX5qK4wbm9Vnp3ed0m0gVEhzj6pfV3qjYHylOtcS4thhMFZDq5i5bCXBpSV9COjPGMDrQmRZSiAsJLzSqtCLKZ7Y4Q24aJzupR1f24kM64Kr2DqO1tazl+qR3B2PtVVAhVUlm3nz1YIVf8uIi9nHDghN7jaeENY854s/uMqPOUsxSjH+6sKY++YcqcRHVjH7kXzW5flndrpPxQuz1qTq0z/S7Z6vUpfCpPtcHVJOaG7bovar/x/Ql1AEKXZBhw/Ldv5RLDMCyl+78/M1YkjwXeGrQBaS57gNBWvLgc3yyZb945QFO6MwpXK6IFrMuo0FKIhvV9fXpusZXmTXzawBhygs8L1LFMoM6z2GLpagdaX8n3xYvROxHGT9VEcHCtv33UgVdQGFkG4H2KEAxkfqGiys0O5gtHrhQXByWEt8gBf8N90VtUIEn01NO9gUny7yGAM16wQijBeTOyYjiMNQ2bkDXyFPIzydIDWUWMXt+Qmm6pvbnE+Fr73OoyzpzTHkUf
 s5Jzy2O/
 uaheL9uu4TO6mpKduADx+sCXSF0pRAmj/4kRZOYSeIqe7rzE/0y7BtQ98Ar7FewRpPTedU0u9stnOuxiSgvDqDwWBRUI7IBfr6s5/SG42FyCYAtiW6n3ZHkYkYlIH/Mc136BD9LqRZ5fbyp9OVFP9cKSN+RP1bsijjebOFugm5us1NqVwHn60IUkCHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

John Hubbard <jhubbard@nvidia.com> writes:

> Hi Roman, Miguel,

Hi John!

> I was delighted with sashiko.dev after just a very quick peek at a
> few of its linux-mm reviews. Up until now, the AI code reviewers
> have often fixated on trivia, but this one goes right to real
> issues that actually matter. Sweeeet!

Thank you!

> So what would it take to get similar results for Rust for Linux?
> (A bunch of us are working on drivers/gpu/nova-core and 
> drivers/gpu/drm/nova, which are written in Rust.)
>
> I'm guessing a combination of "add rust-for-linux to the list
> of mailing lists", and a whole bunch of new Rules/Skills?

Yes, I'm going to add rust-for-linux (will appear ~tomorrow), but a
bunch of patchsets which cc'ed lkml have already been reviewed, please,
take a look.

We don't need any rules/skills to get *some* reviews, but we certainly
might need some prompts to get *better* reviews, both in terms of bug
discovery and false positives. If you'll master something, I'm more than
happy to give it a try.

Thanks,
Roman

