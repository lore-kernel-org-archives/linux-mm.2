Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8FF1CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 19:19:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D95168E0002; Fri, 19 Sep 2025 15:19:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6C338E0001; Fri, 19 Sep 2025 15:19:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5B0F8E0002; Fri, 19 Sep 2025 15:19:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B0D748E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:19:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 45972870B4
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 19:19:46 +0000 (UTC)
X-FDA: 83906964372.25.9F1C1CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7E651100008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 19:19:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i2GtAhd8;
	spf=pass (imf14.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758309584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8yV55nY0fvSS+z77AKpGU5Td15J+ZOm7wtKdU5Fyu44=;
	b=eZWJg87N6jbpqKzEDKC+L6LUJTUHaeOaAT7vqBWk6OoqngnfBMK0pLw1lxU3myXCMp7PSz
	6gC+JHWEB8uPfQkGj8tfA8VOTyP1+GOGtgPeSobgU1TsUHZxKgXx5NZX5Eb3Lk51FkXo95
	qrwmLiRYWkYPN8ENi68g+KKuqscrPBI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i2GtAhd8;
	spf=pass (imf14.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758309584; a=rsa-sha256;
	cv=none;
	b=MqDqjvA5Aedjs8akcWCsoDV5KtmOfnT1qqJkPbDt7YzGKw0fCPs4yO+9VgF5F56muDw6H6
	mgSXA9xIlqDRC6ZadpGhaM3p8GADQFhEMhSIJUbI3MH4DlPsW324vA3m+UHfISn3VK1Gy1
	eaJYx9Axk9/Dw28Fa8vQF2uHktvUExI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3288743CED;
	Fri, 19 Sep 2025 19:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083E6C4CEF0;
	Fri, 19 Sep 2025 19:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758309583;
	bh=RIu4F7qAgYmGH6tNvm+4CzefUV0zH2vjCBJ8h0ToUAo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i2GtAhd8bUf2jG0nPz6QS+Fnc1JDbjL0PYpNDaajz77TqZvhRvhLX375Esu4LPoIX
	 Zic8Xef1180RGF6uIFCGGIBllcoVDHNazkwmTXJj4H+EJY6pce8JBGtyF16UFy4p1p
	 dLJVg5VGwtDQyOaMXxRLBLjj4cPHxQfG6v42OKABqtovOAYnhm1nSGR2G6YmQm/w60
	 on+yLOj2bqnr/s4CLiAKCfaPDP9nLLXlJfhAD51wCvIGpC8GhNNQlYm4uT7Q0F/7An
	 VT+NF2S7AL9sj63auOqbZ1DET9Bq3OB+Hf2NyaclfqbTydCsXoTef/O7uHV5+bwSRO
	 F6oKvMERskMBw==
Date: Fri, 19 Sep 2025 12:19:42 -0700
From: Kees Cook <kees@kernel.org>
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, glider@google.com, andreyknvl@gmail.com,
	andy@kernel.org, brauner@kernel.org, brendan.higgins@linux.dev,
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com,
	dvyukov@google.com, elver@google.com, herbert@gondor.apana.org.au,
	ignat@cloudflare.com, jack@suse.cz, jannh@google.com,
	johannes@sipsolutions.net, kasan-dev@googlegroups.com,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de,
	rmoar@google.com, shuah@kernel.org, sj@kernel.org,
	tarasmadan@google.com
Subject: Re: [PATCH v2 09/10] fs/binfmt_script: add KFuzzTest target for
 load_script
Message-ID: <202509191208.D2BCFD366F@keescook>
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
 <20250919145750.3448393-10-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919145750.3448393-10-ethan.w.s.graham@gmail.com>
X-Stat-Signature: 4xhjt5dw99jtrx1gcy4jjtwyehxp57eo
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E651100008
X-Rspamd-Server: rspam04
X-HE-Tag: 1758309584-996361
X-HE-Meta: U2FsdGVkX18uQ6exZSc7wLrwuL0duHnZbjV5tsIe+y6ApnMrkFAgCTSOQHNOFgZLg7s/xDYAEMn72E33bLMM9Pz6wYsO5oqqdf1skMBeiPAF0a65Zy/F9y7M2cFRw5s2/bhAaPo/siyRnVeK/TeUC11meBx0Ljcer2pFYajZVPlCdOPcHrIAUx+kUGEdtTkXxBah7QgNvkuof1vhQmX0j3AbTHbUdKZ3sCOqUUiF9vofoSURZn5JeNED5JfzZesvZZbAO54LtxZ6Sw8FEgSphsR6v5Wi/QTZwU5G4uRlmnUvAGKZzAnQvQQhFJmIin7p4e4O+tkQ5D6MlI2lSZjxhRvf7EES2dY04Z7/mkrsMtCpGj9C5F4k7p7x1rToLrxkaYk8AnzZnkJwmd2xC8nWSHXkcC0DmgKqQ//AyUgOOkt33xP+UhQf02XHd4UxTXuf64X+x43qHShOBKCHPpJT/318K1ezKqczoYv+w3oL8+zdZ3et+p16SNqoA7t+YE8/frI3KMaqXFv8cfFXjpDH12mmOLfxWRygkoNCasO1+zfXZg2WisMelJC3TPCAqx3cHwb1pKduZXxrF0/9Ibmp8ioWxdOFpwRiez4KWLUr6qwNgN8uTZTjAj+bQKMWDQGUd2EkBriSLGuRYv9a2UNBMmn/FeoOWA6a4Yw6j0inF9huDjd1UriqQp2+riTinntICWkyNSNV7EC72fZDNZey4eKpNs1RtLSvi7kN4WORHC8q0ZfRxI6/0n4o67yv7l3fT3Mn605E3XpsCoDD6LeR9TqocnoYctLvumWx2iJ40NEG2UDSAaklRXLeC45jpwWCq73UJ/SiMI11U/ZzI/5KqBNplXogZe0HKVp9o4p12vYVX8H0wXNwdc6GpbsKkkfUvCLVEn8UYiOE+rxMnxDGg/DQX0Xbak8h75Tw/jutAuQrAADp3U453N7YX5qCf2qQwGN9RXcAFA4Bpj7JFC9
 cWquabxT
 97KKtmsBDt8/GAOp5rJCbSqsIUgIoo4m7PHH1082FBgn23NWK46mbTtY0r4BrpW6N7wkh+XtFifKCTCk3GedcmZ12OHEqXReg1ahzIk7gBYwOwxKex42MY8UQZlnPhKMuEwON0Ce4bXHCnyqILIBE1q4yEP+nH8w2AFnlq0gCfCj3uzhPiq7u31Pds/RYapJJRaApGUx+wbLAvmw10e9gU9Cbe1PPjmiGdWZ8DP83Hyt8+w1lElyVr5z+TEMmGQd24T6khB8EvR8SEzjT5kj4zHdmQ54pNDPLyaDgv4krEBv56dW8WDp/JACGl7Gzc/5+FXn15SsyGzZYq0mVfesE0R5at0wvkeG9u7Cv0nyMoYQZOt75kT/PBOR44dAPOKly7dRVaxi+KWZCgna6je5BgzBlvRhxDP0m7Nuw6uyiXULfxvAIOKVUwEVmLnzQs22R7SAm1UUJOR0rh1xDYtOvRuNgbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 02:57:49PM +0000, Ethan Graham wrote:
> From: Ethan Graham <ethangraham@google.com>
> 
> Add a KFuzzTest target for the load_script function to serve as a
> real-world example of the framework's usage.
> 
> The load_script function is responsible for parsing the shebang line
> (`#!`) of script files. This makes it an excellent candidate for
> KFuzzTest, as it involves parsing user-controlled data within the
> binary loading path, which is not directly exposed as a system call.
> 
> The provided fuzz target in fs/tests/binfmt_script_kfuzz.c illustrates
> how to fuzz a function that requires more involved setup - here, we only
> let the fuzzer generate input for the `buf` field of struct linux_bprm,
> and manually set the other fields with sensible values inside of the
> FUZZ_TEST body.
> 
> To demonstrate the effectiveness of the fuzz target, a buffer overflow
> bug was injected in the load_script function like so:
> 
> - buf_end = bprm->buf + sizeof(bprm->buf) - 1;
> + buf_end = bprm->buf + sizeof(bprm->buf) + 1;
> 
> Which was caught in around 40 seconds by syzkaller simultaneously
> fuzzing four other targets, a realistic use case where targets are
> continuously fuzzed. It also requires that the fuzzer be smart enough to
> generate an input starting with `#!`.
> 
> While this bug is shallow, the fact that the bug is caught quickly and
> with minimal additional code can potentially be a source of confidence
> when modifying existing implementations or writing new functions.
> 
> Signed-off-by: Ethan Graham <ethangraham@google.com>
> 
> ---
> PR v2:
> - Introduce cleanup logic in the load_script fuzz target.
> ---
> ---
>  fs/binfmt_script.c             |  8 +++++
>  fs/tests/binfmt_script_kfuzz.c | 58 ++++++++++++++++++++++++++++++++++
>  2 files changed, 66 insertions(+)
>  create mode 100644 fs/tests/binfmt_script_kfuzz.c
> 
> diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
> index 637daf6e4d45..c09f224d6d7e 100644
> --- a/fs/binfmt_script.c
> +++ b/fs/binfmt_script.c
> @@ -157,3 +157,11 @@ core_initcall(init_script_binfmt);
>  module_exit(exit_script_binfmt);
>  MODULE_DESCRIPTION("Kernel support for scripts starting with #!");
>  MODULE_LICENSE("GPL");
> +
> +/*
> + * When CONFIG_KFUZZTEST is enabled, we include this _kfuzz.c file to ensure
> + * that KFuzzTest targets are built.
> + */
> +#ifdef CONFIG_KFUZZTEST
> +#include "tests/binfmt_script_kfuzz.c"
> +#endif /* CONFIG_KFUZZTEST */
> diff --git a/fs/tests/binfmt_script_kfuzz.c b/fs/tests/binfmt_script_kfuzz.c
> new file mode 100644
> index 000000000000..26397a465270
> --- /dev/null
> +++ b/fs/tests/binfmt_script_kfuzz.c
> @@ -0,0 +1,58 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * binfmt_script loader KFuzzTest target
> + *
> + * Copyright 2025 Google LLC
> + */
> +#include <linux/binfmts.h>
> +#include <linux/kfuzztest.h>
> +#include <linux/slab.h>
> +#include <linux/sched/mm.h>
> +
> +struct load_script_arg {
> +	char buf[BINPRM_BUF_SIZE];
> +};
> +
> +FUZZ_TEST(test_load_script, struct load_script_arg)
> +{
> +	struct linux_binprm bprm = {};
> +	char *arg_page;
> +
> +	arg_page = (char *)get_zeroed_page(GFP_KERNEL);
> +	if (!arg_page)
> +		return;
> +
> +	memcpy(bprm.buf, arg->buf, sizeof(bprm.buf));
> +	/*
> +	 * `load_script` calls remove_arg_zero, which expects argc != 0. A
> +	 * static value of 1 is sufficient for fuzzing.
> +	 */
> +	bprm.argc = 1;
> +	bprm.p = (unsigned long)arg_page + PAGE_SIZE;
> +	bprm.filename = kstrdup("fuzz_script", GFP_KERNEL);
> +	if (!bprm.filename)
> +		goto cleanup;
> +	bprm.interp = kstrdup(bprm.filename, GFP_KERNEL);
> +	if (!bprm.interp)
> +		goto cleanup;
> +
> +	bprm.mm = mm_alloc();
> +	if (!bprm.mm)
> +		goto cleanup;
> +
> +	/*
> +	 * Call the target function. We expect it to fail and return an error
> +	 * (e.g., at open_exec), which is fine. The goal is to survive the
> +	 * initial parsing logic without crashing.
> +	 */
> +	load_script(&bprm);
> +
> +cleanup:
> +	if (bprm.mm)
> +		mmput(bprm.mm);
> +	if (bprm.interp)
> +		kfree(bprm.interp);
> +	if (bprm.filename)
> +		kfree(bprm.filename);
> +	free_page((unsigned long)arg_page);
> +}

Yay fuzzing hooks! I'm excited about this series overall, but I'm not
a fan of this "manual" init/clean up of bprm.

If you're going to set up a bprm that passes through load_script(), it
needs to be both prepared correctly (alloc_bprm) and cleaned up correctly
(free_bprm). Otherwise, you may be fuzzing impossible states created by
the fuzztest setup. And having a second init/cleanup path in here makes
future refactoring work more of a burden/fragile.

But this is also kind of not a great example of fuzztest utility because
load_script _is_ actually directly accessible from syscalls: it is trivial
to externally fuzz load_script by just writing the buffer to a file and
execve'ing it. :)

-Kees

-- 
Kees Cook

