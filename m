Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0FBE109C05D
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 10:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EACE6B0136; Thu, 26 Mar 2026 06:34:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 074706B0137; Thu, 26 Mar 2026 06:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA57B6B0138; Thu, 26 Mar 2026 06:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D183F6B0136
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:34:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 372EF160CA7
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:34:44 +0000 (UTC)
X-FDA: 84587855688.03.E7D328F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8F1031C000A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:34:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GA/1mgZF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774521282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7KAwczp//Hb8LpHDu6sffDxkw7O7KEHRIJwAKGANCQY=;
	b=wjF7nfk8do4Qm2Xu3HeouZmVqUwkXTqlB2hse+SLmFoG7G5vlHRod9I8CFH6ZRvgLd3y45
	ihtAie/ly9/RjpMffqz43vnEbqF0tRgnYViycmbHZRD+kjk94oHrPgSslQjkvljdNZqJqO
	gR062MN0UEqgn9f/mdCMNkBIofWSrfk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774521282; a=rsa-sha256;
	cv=none;
	b=mECDx/GfFNzSoHwKTYHp4HdjOozZQUYAw8Q8eUOf2q2E612SNUx6TLLblmTVhhZ/a6r7iz
	WgJsCIiOxmlJbS2b6dXxaLY7uh8mjSYr8px8zpxkBF9Glf5IC6cirPxRc/NREw5xDTkSmj
	rrFgWpank0QVZzlIDPAZt0PnDrFaqnM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GA/1mgZF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D203660053;
	Thu, 26 Mar 2026 10:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29433C116C6;
	Thu, 26 Mar 2026 10:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774521281;
	bh=KOQYTe1uJbviUnzDjOWn90b2+nt4xQ4qIkhPKvvmViE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GA/1mgZF+rK0dn4r6X0GwSOY18uvmB8PaDvhdwiSTNozH48e1m1c9MjnZhgVleWm3
	 S15wyNTi5cKiPMQx+HYv9usZPKACYjA1i6G/QPWew8l8mFjZdL5szw9GT7utkQRBxF
	 K1O6ZnSnUxlkKGzttC9XSjbCGoc6WMLU6GfzFkf2Kllaeqq5EegLMlCMfTyde6Msod
	 zW3UVSA6jF0Hoxt5cSnx7k97kk6GzvBZiu77Y0mKlA/GnxSkwkIjuI71U3QLd6ky7c
	 QuShy/gVxGCo9eRJAIs9/sdQTArDSQjODeaijQPZW7iaNMSmULbwg249Y4xo96KPyZ
	 12OIOlmpLShjw==
Date: Thu, 26 Mar 2026 10:34:39 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Josh Law <objecting@objecting.org>, Josh Law <hlcj1234567@gmail.com>
Cc: SeongJae Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, 
	Kees Cook <kees@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH] mm/damon: introduce DAMON-based NUMA memory tiering
 module
Message-ID: <cbd0aafa-bd45-4f4d-a2dd-440473657dba@lucifer.local>
References: <20260326072737.341964-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260326072737.341964-1-objecting@objecting.org>
X-Rspamd-Queue-Id: 8F1031C000A
X-Stat-Signature: fq4a1bajpiocdybxai5dx4g665o9ahx4
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774521282-584168
X-HE-Meta: U2FsdGVkX1/EIedE31wkGgyyxrGDsv4KbQdLBlN6D+v0fbfrqxbVj6OgR5Q47nk/5c1Fbp5BpOzlMSZaWnyifqjn7J3yfElV17VKjC85cL4rZqP5erBh0ciy9325VtOEzMD4S0B1vXYzHSFaI6L8rnmQ+PdtuNceyVUII9ykfSjPq/1Wbyg7OkpOPVu8v9f0WRWKoupnusEqnegUjqvEapcFEKfJioANARM756Emti4hdoFvnseA0s1pk1Yy1yo4kNIRMfhoVe0v22UHXJqQq42vBBcvrjqFkbetj5JuOUOn1Q2E+uD4IxdU/pV5Rwg/S3lvsLeUeFWdeRkoEJ2qmtwZ1rR7+jCm/7qVG87VFiQYEQjksmk4Pa7bSNHATzLe00XVPkGXkmyJl20nkmTTGCnFasH97AJ7f5NfXw9uBxBSDtFuIoDAIsqZR8t5hajdbyjIkGWc84R/Zw6Rpv2mdwggRacPDXqITGYzvsRry63LuaSBPI0E5Go9uev4nWeujQvYY3rLh5lqvc1VOgNjMd5PiGVK8kCXI+ll5DI1akQPv4/D/Xftn5JiQx3EUPvYawB4rnOy0YMMsUKBPtLVz6oC/L0LdeiyAJXrJhBf54NWVgbZadeAVOrRYHQZVULcLKrwB495oWmiZ/PH5w/Fr/ABb4gtR9xvL7q1QmuVP/t3/bxirfhUm9C0+BdkKYlLs3vIjF4Sey8ggvYZYswaT8xxHqtuz/A/EjJbLn+9k2u5CnbGmfFl0W55H8bhhEELPePhXmWQdoLrN3/KEYKkwVuVSR8tjOWC3NS59bxbVpIFsNAu1xrfAFfZByXhd3cjHpg3yEg/7rCZRZKsNxc/FVNAkS/ve0Fzpx8VUyt7y4Akwj+UzJAqjyT84dK5ScqkHREKzErgkFppbnyh1LvfOxoROXcu3kpY0kYDIbh4mC06eEI6Cb7ChrNwBpQvcLTdIYQAgI128OHkGJvvcTj
 zd6+lT72
 LDo/64tWH9Dn7K2z8T8ILEd3qN2bOUP3ZgVqWgecZNMcwuncOKDyQSIDLTq6AffUBZ5q/LEcalf8VUrJEBVPLNQ9gfXhCGlmW5U44XrXpQKpQUrDnAiaxuKW57nhDv6ZfW9qp1fcD357SB6EbJU+Wt4zpMnBGd1ckW/f1eRLHI4fgSiQRszVGSFpb+StSTFM8hdvP5RdKVLC3J7KD9XlwLpujihZfjJm127iJjyWwX6FHxUXhWwbUifaVmTYZD9SwqhgBIZNF3WBlZka+GX3OHXAr/aNafOm15X3cZ/wHQB+CmvJGWa/EQIEoeN4Sq8imwTTlxdMJlSp8xEwz7Swax04Amin3NC03+82pXH6D5VCBdFeQlIlNAP8ulgrcodZQ2B/1SitnqpzriDmRaqp6NfyXa1gkljmH3PwKPNoEcEXeZXo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+to the other email you've randomly sometimes used
+cc various possibly relevant people.

On Thu, Mar 26, 2026 at 07:27:37AM +0000, Josh Law wrote:
> Add a new DAMON special-purpose module for NUMA memory tiering.
> DAMON_TIER monitors physical memory access patterns and migrates hot
> pages from slow NUMA nodes to fast NUMA nodes (promotion), and cold
> pages in the opposite direction (demotion).
>
> The module uses two DAMOS schemes, one for each migration direction,
> with DAMOS_QUOTA_NODE_MEM_USED_BP and DAMOS_QUOTA_NODE_MEM_FREE_BP
> quota goals to automatically adjust aggressiveness based on the fast
> node's utilization.  It also applies YOUNG page filters to avoid
> migrating pages that have been recently accessed in the wrong direction.
>
> This is a production-quality version of the samples/damon/mtier.c proof
> of concept, following the same module_param-based interface pattern
> as DAMON_RECLAIM and DAMON_LRU_SORT.  It reuses the modules-common.h
> infrastructure for monitoring attributes, quotas, watermarks, and
> statistics.
>
> Module parameters allow configuring:
> - promote_target_nid / demote_target_nid: the NUMA node pair
> - promote_target_mem_used_bp / demote_target_mem_free_bp: utilization
>   goals driving quota auto-tuning
> - Standard DAMON module knobs: monitoring intervals, quotas, watermarks,
>   region bounds, stats, and runtime reconfiguration via commit_inputs
>
> Signed-off-by: Josh Law <objecting@objecting.org>

NAK.

And NAK to all future 'contributions' in anything I maintain or have a say
in.

Your engagement with the community is deeply suspect, you've come out of
nowhere and are sending dozens and dozens of patches that look very
strongly like they were LLM-generated.

You've - very early - tried to get a MAINTAINERS entry, you were given
advice on how to contribute, which you have clearly ignored.

We DO NOT want AI slop.

You very much seem to be either:

- Somebody playing with a bot.

- Somebody trying to farm for kernel stats.

- Or (far more concerning) engaging in an attack on the kernel for
  nefarious purposes, perhaps a (semi-)automated supply-chain attack?

Your email is highly suspect, you seem to be using an email relay via
gmail, and I'm pretty convinced you're in violation of our requirements
about identity:

"It is imperative that all code contributed to the kernel be legitimately
free software. For that reason, code from contributors without a known
identity or anonymous contributors will not be accepted"

https://docs.kernel.org/process/1.Intro.html

Also see https://kernel.org/doc/html/latest/process/generated-content.html :

"
...when making a contribution, be transparent about the origin of content
in cover letters and changelogs. You can be more transparent by adding
information like this:

What tools were used?

The input to the tools you used, like the Coccinelle source script.

If code was largely generated from a single or short set of prompts,
include those prompts. For longer sessions, include a summary of the
prompts and the nature of resulting assistance.

Which portions of the content were affected by that tool?

How is the submission tested and what tools were used to test the fix?

...

If tools permit you to generate a contribution automatically, expect
additional scrutiny in proportion to how much of it was generated.

As with the output of any tooling, the result may be incorrect or
inappropriate. You are expected to understand and to be able to defend
everything you submit. If you are unable to do so, then do not submit the
resulting changes.

If you do so anyway, maintainers are entitled to reject your series without
detailed review.
"

You are clearly not following _any_ of these guidelines.

To evidence that this is not some wild accusation, I ran this through an
LLM asking for indicators as to AI:

~~~

● Several signals point to high likelihood of AI generation:

  Strong AI indicators:

  1. "production-quality version" in the commit message — kernel developers
  don't self-describe patches this way. This is a classic LLM "selling"
  framing.

  2. Comment uniformity — every module parameter has an
  identically-structured block comment with the same explanatory depth and
  cadence. Real developers vary their comment style and skip obvious ones.

  3. Commit message structure — exhaustively lists every feature with
  perfect bullet formatting. Human kernel commit messages are more
  conversational and focused on "why", not a feature catalog.

  4. Too clean for a first submission — 409 lines of new module code with
   zero rough edges, no personal style, no unusual design choices. It reads
   like a templated synthesis of DAMON_RECLAIM and DAMON_LRU_SORT.

  5. Grammar tell — "aiming a target utilization" in the Kconfig help text
  (missing "for"). This is characteristic of LLM output that's fluent but
  occasionally drops prepositions.

  6. Over-commenting — comments explain things that are self-evident from
  the code (e.g., the promote_target_nid and demote_target_nid comments
  just restate what the variable name already says, in long form).

  Weaker signals:

  - Unknown author, no prior contribution history I can see

  - The code perfectly follows existing DAMON module patterns without any
    deviation — exactly what an LLM with context would produce

  - The objecting.org domain is unusual

  Overall: I'd put this at high likelihood (70-80%) of being primarily
  AI-generated or heavily AI-assisted. The code does use current DAMON APIs
  correctly, but the writing style throughout is the giveaway — it's
  uniformly polished in the way LLM output is, without the unevenness that
  comes from a human writing 400+ lines.

~~~

That's just for this series. I asked it about your contributions overall:

● This is extremely revealing. ~328 emails in 11 days (March 15–26),
spanning an extraordinary number of unrelated subsystems:

  Patches submitted across:

  - mm/damon — NUMA tiering module, core optimizations, sysfs fixes,
    reclaim fixes, kdamond scheme filtering
  - lib/bootconfig — v1 through v8 of a 13–17 patch series
  - lib/glob — v1 through v4 of an 8-patch series (new features + bug
    fixes)
  - lib/vsprintf — 4 bug fixes
  - lib/base64 — decode fixes
  - lib/assoc_array — gc fix
  - lib/bch — signed shift UB fixes
  - lib/bug — concurrency fix + debugfs interface
  - lib/string — strlcat rewrite
  - lib/maple_tree — dead range comparison fix
  - lib/parser — match_wildcard fix
  - io_uring — flush deferred completions
  - block/partitions — seq_buf replacement
  - ACPI processor idle
  - signal handling
  - kunit, iov_iter/kvec, percpu_counter

  Assessment: ~95% probability all contributions are AI-generated. The
  evidence is overwhelming:

  1. Volume is humanly implausible — ~30 emails/day, 5–10 new patch
     submissions per day across unrelated subsystems, from a contributor
     with zero prior history.

  2. Breadth is the strongest signal — no human newcomer simultaneously
     finds subtle bugs in bootconfig, vsprintf, base64, bch, maple_tree,
     assoc_array, io_uring, AND writes a new DAMON NUMA tiering
     module. Each of these requires deep domain-specific knowledge. The
     pattern is consistent with an LLM being pointed at different source
     files to systematically find issues.

  3. Bug-finding pattern — the patches cluster around unchecked return
     values, type mismatches, resource leaks, off-by-ones, signed/unsigned
     issues. This is exactly what an LLM produces when scanning code for
     potential problems.

  4. Rapid revision cycling — bootconfig went from v1 to v8 in ~1 day. This
     matches AI regeneration, not human revision.

  5. Feature additions from a newcomer — glob_match_nocase(),
     glob_validate(), debugfs BUG/WARN interface, and the DAMON NUMA
     tiering module are all non-trivial features. A first-time contributor
     proposing features (not just fixes) across this many subsystems
     simultaneously is essentially unheard of.

  6. Zero ramp-up — the contribution stream started at full throughput with
     no learning curve visible.

~~~

So I really feel that you need to account for this - please explain why it
appears you are spamming the mailing list with entirely LLM-generated crap?

Furthermore, you appear to be using sophisticated privacy-orientated
tooling, which makes me quite concerned that this _is_ a concerted attack
on the kernel.

Again, to back this up, here's an LLM's assessment of the headers in your
email:

~~~
● Looking at the headers specifically:

  Infrastructure:

  - Mail provider: Zoho EU (zohomail.eu) — a privacy-oriented
    EU-jurisdiction mail provider. Easy to set up anonymously.

  - Domain: objecting.org — custom domain, no organizational affiliation,
    no accountability chain. Anyone can register this and point MX to Zoho.

  - Authentication: DKIM, SPF, DMARC all pass — but this only proves the
    email came from objecting.org's Zoho setup, not who's behind it.

  - X-Mailer: git-send-email 2.34.1 — Ubuntu 22.04 LTS default. One reply
    had @ubuntu in the Message-ID, confirming the platform.

  What the headers DON'T provide:
  - No corporate or institutional email that ties to a verifiable identity
  - No PGP/GPG signature
  - No Signed-off-by chain from a known developer vouching for this person

  Supply chain attack assessment:

  This matches the threat model of automated supply chain compromise:

  1. Patches already landed in stable — the bootconfig fixes made it into
  6.19.10. The pipeline is working. Whatever is in those patches is now in
  production kernels.

  2. Trust-building pattern — the mix of real bug fixes (fd leaks,
  unchecked returns, type issues) alongside feature additions (DAMON
  tiering module, glob features, debugfs interface) is textbook. The small
  fixes build reviewer trust and merge history; the features add attack
  surface.

  3. Volume as a weapon — 328 emails in 11 days overwhelms maintainer
  review capacity. Maintainers like SeongJae Park (DAMON) and Masami
  Hiramatsu (bootconfig) are now spending review cycles on AI-generated
  submissions. Even if every patch is rejected, the reviewer's attention is
  being consumed.

  4. The DAMON NUMA tiering module is the most concerning submission — 409
  lines of new kernel code that runs with kernel privileges, monitors
  physical memory access patterns, and migrates pages between NUMA
  nodes. If accepted, it's a significant new attack surface delivered as a
  single commit from an unverifiable identity.

  5. The feature additions are the real risk — bug fixes are relatively
  easy to review (small, focused, verifiable). But glob_validate(),
  glob_match_nocase(), the debugfs

  BUG/WARN site lister, and the DAMON tiering module all add new code paths
  that are much harder to exhaustively verify.

  Bottom line: Whether the intent is malicious or not, the pattern —
  anonymous identity, AI-generated code, industrial volume, patches already
  in stable, mixing trust-building fixes with attack-surface-expanding
  features — is exactly what an automated supply chain attack on the kernel
  looks like. The 2021 University of Minnesota "Hypocrite Commits" incident
  was a manual version of this; this appears to be the automated version at
  scale.

~~~

I'm hoping this is some naive attempt to try to 'contribute' to the kernel
rather than something more nefarious, but the seemingly sophisticated
tooling used makes me wonder otherwise.

In any case I'm deeply concerned by this.

Thanks, Lorenzo

