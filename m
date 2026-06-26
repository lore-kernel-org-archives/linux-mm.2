Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92F2DC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 22:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C0636B0088; Fri, 26 Jun 2026 18:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 071606B008A; Fri, 26 Jun 2026 18:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC93A6B0092; Fri, 26 Jun 2026 18:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAFD66B0088
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:39:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 308141C65E6
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 22:39:58 +0000 (UTC)
X-FDA: 84923532876.10.7D88A44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 75327A0007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 22:39:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TjCvamyW;
	spf=pass (imf25.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782513596;
	b=M5o1SoyokMCCg3Ifilla7QZjqshwzLiztEU8Qu0btPKj2fiQFQr8DW4Btg8J9KOu1G6qje
	S5gBuZGoCUgcEhI8uZ/SmUnaQgUcWS1P82cO339GailVjoJ0HQz12SC+uEO+i/rCYOyXA6
	RtGvgZ19C10F/nyULors5xfCxW1H2DQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782513596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JgUOiZxZzW9VeKLG8hV+EIovmMVBIXkOvz/W5iFc/gs=;
	b=7cPPWj2kc5WomMmpU6Q1Fq0y9ePNRiTgGFY7gnjhFcUv8OGrOzyzazaeUFtg0HEX391UZH
	ttkoMwhxn52ykxRVlGOePYRD15BUb+TQ9jjiFPpkXgJ9UsgOph0OgBi5P9eSAOCeu4WBOg
	uUhWmnRUdeT498+2ZvOvqUcQTJTfl2I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TjCvamyW;
	spf=pass (imf25.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3679042B9F;
	Fri, 26 Jun 2026 22:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAE31F000E9;
	Fri, 26 Jun 2026 22:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782513595;
	bh=JgUOiZxZzW9VeKLG8hV+EIovmMVBIXkOvz/W5iFc/gs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=TjCvamyWEfXozmOQ3ilBoq0H9DMOWf+7DEZzmVzOrpPWBFsfTQsTgvBEQ/p83dr12
	 D53bxJkcJO7L/rET/Frg7CPmJt0Binn+CtSl3YP+eIsPtFPb874HYENAYWbOMmZVA2
	 IT/hKBe9EF3WzMKocNoZfHDK56s2TuvTxxjltIe8lF96Vzqd6LbU4/NhKXCogjzpX5
	 G8wrWOztF9zbuHdszefwnIT0kARR0MmXyIB0W1SjAPrJaT92++naCNBmwfpkv51OvY
	 sC3IpbtZixAzfj8F9Zfpqhyy7Cv+w0T/G6kutxwygeugY3mbmcrwDKjvet4jn16LNE
	 3UiYj9ABhz51g==
From: Thomas Gleixner <tglx@kernel.org>
To: David Stevens <stevensd@google.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>,
 Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave
 Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Xin Li
 <xin@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>
Cc: David Stevens <stevensd@google.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v2 12/13] x86: Add support for dynamic kernel stacks via
 FRED
In-Reply-To: <20260424191456.2679717-13-stevensd@google.com>
References: <20260424191456.2679717-1-stevensd@google.com>
 <20260424191456.2679717-13-stevensd@google.com>
Date: Sat, 27 Jun 2026 00:39:52 +0200
Message-ID: <87zf0hgc3r.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: sjwmyigphj76cjz9r6nnenx3r1k947ex
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 75327A0007
X-HE-Tag: 1782513596-814558
X-HE-Meta: U2FsdGVkX19IMvErS7rbdopjNYvqDXzB1wsFzfhZwH1D3b6T+VCnSlU1kztK2jd5tYgv17TTIzYBmJQTh0sA+uXk2/L44/DXfIeQdlhj6pFvPNoGF2T/XyA9Q6mOyr47LL4RNw0nIjr8ybGngglwbiBx7Q9sqCDgGJpBxwmjJaZkHw5uYVZqdIuOwfE3ztjO6B18t9VkrVBvANQnwiHHdfGZuoFcBj3qCXZeJcBOXfb4M9lYLZfALRW9ytof4LLL0dohjgIjOsEsWn5ryevVwy+nIOKCQfH9CD2K1RP3WQeVatoSwmxyiPtCrCkYzj9iXrdeyoANViD6fwmr/1CrtlQEGOWLDfxezeYlWBRicuD2QrTV2kCrfyHR7NC4d+bPERYfhfMq/d+l/w9B97x0CTBLiXM/c/M/rLH+qOAvVp/4bnwxF5yzlzFzSiwayi3NVP84wCOvupS7yuLZ4yCi2oNENAw39S9yoyBSCQT7a52LrZ7fr8OUY1M/fhyDcAMEHBW7uXjCVq6yJYmaVrTbYVYAeyZDJiooGdrLROLTRiGdSKTKSE1vKwcx9Xy4c+HnOOLlrJ8eKptYwDjkUz+tcP2E31IGVnrcYh4sA6InY1m0g3gsLQGTo1rflKab00KJPv/Xju67Pc1KZXch1wjGMlXEw/DM7k/8e0enGVxbsiLaYV0imbSz5zzHOgaxANXiIZPf7K48zDJrIDLDdcPt9mCipa+3StTIPWh+RJWLksct/t4oE91iRnmt//ECA6U2GwbsBBOi+1v3rD9Gilq03+GaoviSR8QnUG0uN/l6bj5KQ6aGIbEH45J8MzZMDRSoZDFenPRcS16TKu+DbvVXtgff+GrA7mFLu71z0UCN1BdJB5WeL54GtfVHdKEVHgtVUd9ne2LkSsr30jXVGzAM9i8nm+BYPE+lnl4MFO8vWivxRMtELfAr94JB9IVP+kiiSW82U1dL9pj2RX7+wAA
 pgG4xVpW
 88OhvONmGQoFHLzA/yM0UMuNIZ0boZFVIKmJTW+AeVtQ5DK1Bq6CgARavQ3juxGPu+Bl7hSJz0yqK+3Z2F9u92UkaEhf+btxUUe38JKGdcuSxHThWJVCak9Z/NPMgGOwMonWwhIjVUJz74t47yecrfa0LHwb9jI5JkgbLQXbjAEbq2rEBYGJckA6BR4JcDLpY1GlA0oORDGfk3wnT3xoj3QiLNPR2J0BpQS6BnTsnHPpRFpYgV40OsMKDr9AtzPfVzyQk1sPXGxGopQ5J+EueeYoJsJSk/wKxsPsocpWH6Cb9YXg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24 2026 at 12:14, David Stevens wrote:

As promised, I've came around to look at this part too.

> +#ifdef CONFIG_DYNAMIC_STACK
> +
> +static noinstr unsigned long copy_stack_data(struct pt_regs *regs)
> +{
> +	unsigned long new_sp;
> +	unsigned long data_len;

Just a minor issue. Please read and comply with the coding standards
documented in https://docs.kernel.org/process/maintainer-tip.html

> +
> +	new_sp = regs->sp - (FRED_CONFIG_REDZONE_AMOUNT << 6);
> +	new_sp &= FRED_STACK_FRAME_RSP_MASK;
> +	data_len = sizeof(struct fred_frame);
> +	new_sp -= data_len;
> +
> +	memcpy((void *)new_sp, regs, data_len);
> +
> +	return new_sp;
> +}
> +
> +__visible noinstr unsigned long switch_to_kstack(struct pt_regs *regs)
> +{
> +	return copy_stack_data(regs);
> +}
> +
> +#define ALIGN_TO_STACK(addr) ((addr) & ~(THREAD_ALIGN - 1))
> +
> +__visible noinstr unsigned long handle_dynamic_stack_kernel_faults(struct pt_regs *regs)
> +{
> +	unsigned long address;
> +	struct task_struct *tsk;
> +	bool on_stack;
> +
> +	address = fred_event_data(regs);
> +	if (fault_in_kernel_space(address) && !in_nmi()) {

Assume the following scenario:

     CPU runs in user space
     NMI is raised
     NMI runs on SL0
     NMI execution triggers the stack guard page
     
Don't tell me that's unlikely. As discussed before unlikely does not
exist. You just have to enable enough debug muck, build with a compiler
which aggressively out of lines code (hint CLANG) and then end up in a
deep perf/trace/bpf callchain.

> +		tsk = task_from_stack_address(address);
> +
> +		if (tsk && dynamic_stack_fault(tsk, address, &on_stack)) {
> +			WARN_ON_ONCE(tsk != current &&
> +				     ALIGN_TO_STACK(regs->sp) != ALIGN_TO_STACK(address));
> +			return 0;
> +		}
> +	}
> +
> +	/*
> +	 * The regular fault handler won't sleep when executing in an
> +	 * atomic context, so we can complete the #PF directly on the
> +	 * #PF stack.

Q: What guarantees you that in_atomic() is giving you always the right answer?
A: Nothing

Why?

If there is a #PF (not caused by the thread stack guard) on a SL>0
stack _before_ the kernel reached the point where it increments
preempt_count, then in_atomic() returns false.

As a consequence you copy stack data around to the same place, which
should be benign, but it is well understood that memcpy() source and
destination areas _must_ not overlap. That's UB, no?

I know that should not happen, but that doesn't make it less UB :)

> +	 */
> +	if (in_atomic())
> +		return (unsigned long)regs;
> +	else
> +		return copy_stack_data(regs);

Thanks,

        tglx


