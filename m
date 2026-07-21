Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4757EC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 17:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 390956B008A; Tue, 21 Jul 2026 13:24:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 368686B009E; Tue, 21 Jul 2026 13:24:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 283C86B00A4; Tue, 21 Jul 2026 13:24:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 016C96B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:24:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 869CBA06AF
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:24:15 +0000 (UTC)
X-FDA: 85013457270.21.07CC402
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf18.hostedemail.com (Postfix) with ESMTP id 444C31C000F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:24:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J0h3YynE;
	spf=pass (imf18.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784654653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4F+iZhFV6VPB9ZUQh4/hKSJwpjYLP4RW3rsSYNMA+yo=;
	b=Wrn0D3/Ad6FGZvD0tnYNwpxCYMgcU/Nq/uI5No1ACbmpVfD2xIGn48WwbPVyoWGRMtqoU4
	RLzMYdBqyJimFcQF+KkTZ2B1EJKtwmvVj3umK3nikyLPitDjyndWssIJZ0If/dIw33ahfW
	dlx8tGo+L0np9fDCTb7h7EpyY3ylr7o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J0h3YynE;
	spf=pass (imf18.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784654653;
	b=OZuwi2bA1SHvJW6G/CqARpn7rh1sK8vHtYrl2F25Y7qMhCa/WCuT63/kB8bEhRIHmUkv9Q
	7Lp12X4Ta20w5Ndnq4jTrQBr3bO9c265pJZdaJ2CLQVavE7PsgoY7uJ35crxqIqUPTOwq6
	APcJGT3v7c7cH9Tyjah7o1bstwAlO0I=
Message-ID: <7c79eb26-0986-41c8-a5f9-5911a2e71175@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784654649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4F+iZhFV6VPB9ZUQh4/hKSJwpjYLP4RW3rsSYNMA+yo=;
	b=J0h3YynECLow0Nnsp03fdyDTS34Y59J51xWwDr2kgqKZ+bKjF8x6FCbBrrZ+jMk0bOw0sl
	4Mnp7MxCx4Pw1IVloH58zet5ib5GPDifhdDNflFMbMXGBmu4g9/DbXHuKBXZrjb6eb8HFg
	x10FPUADk/mxFAuq3c77N0sGAoYLr34=
Date: Tue, 21 Jul 2026 10:23:25 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v1 0/5] x86/cpu: Refactor identify_cpu()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ihor Solodrai <ihor.solodrai@linux.dev>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 Thomas Gleixner <tglx@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, "H . Peter Anvin"
 <hpa@zytor.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 bpf@vger.kernel.org, kernel-team@meta.com, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260704002046.3859585-1-ihor.solodrai@linux.dev>
Content-Language: en-US
In-Reply-To: <20260704002046.3859585-1-ihor.solodrai@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 444C31C000F
X-Stat-Signature: tt7rs6qjm4f3o3jkisrd181fp8omj58w
X-HE-Tag: 1784654653-399989
X-HE-Meta: U2FsdGVkX1+PY7+1YzlrFbVE7OWpecuCsvgfXQ9blSqwF6v4mMh+S/T6PHp2X/Bq0r1dim/dSpKjQ4mCy4GDuYSfyJ5/ZiwAQgWrU97+10W1twYUCTqHws4ExW3z8YdkYkr+rgLOkfadGwsA2T/6JYc6i9tM1PvCI4XdWXEOBgkWGNeUBAPWkAdouj5rdP1vfKYpq+3ZnxpivObduysvCh9SjeGjwRPylO4URpvnVreLhC7PjqoJ1lCFv9QL0Y7G+I+4ooAKVjkdcMCj14CqkJsK8TKD2wtch6X+PqRZDkFdpJgLK09nWzzVp+CRenbSuB7Mc/eHYEq5sTlVEaBGA46jREP5juTqBsO+1fHhHKBTHLXZmYmEsT4Kmz9t+CjdjjAGkcOYGRq7XZ4JlRNTaGcQtTH5E9Jztt3TOT0lgpM+bOuXPAXrKs6AuEx6OZAahLr86cfSOj4ytLLkDTMjp+zFV1M8Z4Unz9HZnkljgPEZYWLpEMhIn93bejhzR/EI+CTtXEirXnrr9yMSIO5PWyj+884LwEp/wpgb3VbckMlD3scpbddtfOumPPQzvbtxtKftq7UxGgjIYOs1HHpqJVNXMTkVZAzBUVnNUi+yrvrEvSnfAcbf/WPyky4TWtyc0x5DQgoa9SSAMxKs4B2eIGQCd/FbwIPRqhOba3lGlstTUaTsNF2PTTatbmGjMWadc/EulaB5Awx61shW2QKrvbvks92ZnRtyXFs90gXZYenaXVdGVYUnGy2mc2QptVvfY6wLuHQanhk1IgmYRNYE4Pzhe8U2e/wslOCqOSwBXT2WjWNdwwcFG6+xo9/8lvbifbVOAm4FgEz+JbM7084kiukMzRWmxHzKpN0xRFI4c897k3m7Y/MaMm3dbH7CYUlo58wlyXPzOJsRHSqkEQS+vtmyXsv9x3G2wJsGxsYK4aaU0Gq341AGHPFCRS77kHp76wjQaLCrYa36zLvu5Wa
 ErR4RGH2
 9Y7zAtcih9knkiDfvwKuFB2lbVE86lsinreh6o5lTir2NLTttPPvpPr2Lp4lXB/8ntSG27JK2LiBptp8VE6C6c6hg2LEhX0bO1ixYgWLFuVVK6ouMrpLMeTFom0ewmr6bUYSg+8HJg7RX8ONMvRlaBbyomsfpTerOOuXxHYjispXEMb87Pbi8J5D6O5juebi2hTfzXmgAJCGosFQMwyGtqU6iPIfMqIWT8BnLoSxwzDDlHmIkI0UMCOXsTVY51yrVbr92Fw1OtCxW8m0peL4rv8zBModijPgjeV0KmAndREk+FVEGXMfEyScJdqa7UqB8NTaFXX3SbDwuDduhz7gG0SIn/rbOWT9yt4oNKKdd6MvU6AQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/3/26 5:20 PM, Ihor Solodrai wrote:
> This series refactors identify_cpu() machinery on x86 and then
> implements a fix for a bug when cpu capabilities are temporarily
> cleared within an interruptable window. For more details and
> discussion see the relevant bug report [1].
> 
> Suggested-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
> 
> [1] https://lore.kernel.org/bpf/20260610175651.647515-1-ihor.solodrai@linux.dev/
> 
> Ihor Solodrai (5):
>   x86/cpu: Factor init_cpu_info() out of identify_cpu()
>   x86/cpu: Inline generic_identify() into identify_cpu()
>   x86/cpu: Introduce identify_cpu_32() helper
>   x86/cpu: Set X86_BUG_ESPFIX in identify_cpu_32()
>   x86/cpu: Don't reset boot CPU cpuinfo in identify_cpu()

Hi Boris, everyone.

Bumping the thread as it's been a couple of weeks.

Please take a look when you get a chance. Thanks!

> 
>  arch/x86/kernel/cpu/common.c | 114 +++++++++++++++++++----------------
>  1 file changed, 61 insertions(+), 53 deletions(-)
> 


