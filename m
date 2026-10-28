Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F22C606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a/rb5U1K
Received: by kanga.kvack.org (Postfix)
	id 83AFB6B05B5; Wed, 28 Oct 2026 05:49:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812586B05B6; Wed, 28 Oct 2026 05:49:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74EC56B05B7; Wed, 28 Oct 2026 05:49:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 576F46B05B5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:49:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59FC3160C14
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:49:21 +0000 (UTC)
X-FDA: 85371562122.26.ADDB9B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id B482C40004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:49:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="a/rb5U1K";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793180959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j99P5QWiCp9mK5Hf0fpTUVyqcAtcoB4QyeGqeo1OT2s=;
	b=SSFQdUnnIrVWQJtCLJKY/UdRwhjqvu/ftv6d2dzm+RAXfO95sJZlDIGmpeAJoA/DuiZTZr
	rHv3bUF78lZSec+/wheXORDRyad7O0R2ReA8Qjs9+mhjGJaw9fwAHhB1sa96ORVF8g4AUc
	zyMWuf8ears4Uvke4vVB5EsrANo4A8E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="a/rb5U1K";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793180959;
	b=ofIyg9e8W1p0Ddpq+PQ8Eix4Uwds3A4nJSkPsPLGhm2yMoxdcm3hJ0YNiV8/I50IlGGyoe
	cLKyUZViczTpAQBP4ui+ZKLNGPWJiXX//soHb3kiJ5pSrGCcT6QMkk1qHner65mDQ/tSy9
	uBvxjuOgALG5bZgwoRTTmddJ0OnIxw4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4ADB94196B;
	Wed, 28 Oct 2026 09:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18371F01825;
	Wed, 28 Oct 2026 09:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793180958;
	bh=j99P5QWiCp9mK5Hf0fpTUVyqcAtcoB4QyeGqeo1OT2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a/rb5U1K0Gj9rgjjeNICrvcAIx0kQwZx3+rm6ZZYnaEKZaXecdZyKs1e4wZMaPTu8
	 kOyQlOjw53t+7mEwMLLtfU1AlSR6yN0WdsKoO9r0X5U3l8Ol6z/Gl8gJE6rHxaSGc4
	 IPU0auxW+r8/9eUEM6X0OeMwkvjfzdoPhcezmbEfKT56H43y/MLYJBq2lhDAcQ3ilA
	 uhC6NbxVzMhVPsFoY2a92GIuPsayNwHxTd9YAqhxVL6ZEd0tyciCqjEvenCRFpdUqI
	 HUwCq7TjVx920vPdi7+q1VvFF+pV3u57U/9WO5STKbe+D/NfQHN2FAJZ9F2UB3aP4R
	 +vL89dEkpf+ag==
Date: Wed, 28 Oct 2026 09:49:10 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Jeff Xu <jeffxu@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>, Jeff Xu <jeffxu@chromium.org>, 
	Andrey Vagin <avagin@gmail.com>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/3] mseal sysmap: Add mseal_system_mappings= boot
 parameter
Message-ID: <auG8bgpy-m5JUYWp@gremlin>
References: <cover.1793094611.git.chris@chrisdown.name>
 <5bd3c89d733ad22224f296dfa8900769de937de0.1793094611.git.chris@chrisdown.name>
 <auCxjbvY3qPv1sV6@gremlin>
 <auDTMb6WMFUpxeZy@chrisdown.name>
 <auDTptDQsB4xBcz7@gremlin>
 <18e2972cb8520c2e.3137322e32382e342e3434.279dd1.0000sendgmr@google.com>
 <auGNkhSHpBRd2U_5@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auGNkhSHpBRd2U_5@chrisdown.name>
X-Rspamd-Queue-Id: B482C40004
X-Stat-Signature: wr6f1zzy5a78zz1tsjdg3m1zn9caeo3r
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793180959-425779
X-HE-Meta: U2FsdGVkX1/NQCOnj2uFoZ0Oj0n2g2/2SIhp6msR9cvPSUhe31Ty/EaKjELrNe7IOjhx+fLbmbdhzUvaurjquXa5jTkw6y60DVmofhr2mMTU2dsjgkzWcubE/AiPIey5L/nq172jWbcypJJ2w2+iYWmK8glXtHIQsgFWAYN5Z9vBAQSgVQf3Ffy19AhBM5rL0rAhMvPnKURtkQzfQoAxxKCBjYb7ZoatQkWrRfQRKPYxwgOJAzw21zeKZKelii9msoEGftouFkm+Sou60cPSCPbYAhAvcT/KFi7+NU/8jW/8e1+l5bETWy4KaHKrAyjuGPTMRmaCcgcBvpcxnLLdf94EOlCOLK5NYa17FXB1Qv8JAnY5WDnp7OHVgJvJe9FX6ERn1rcFIuGnLeC3BywtvSG7z+zMmRhlNA+Zau313zDtk1Bzfiss06De81IvIdjqitK4g1R1gx6A6hwJa9T/RF5eVKWkN8TdueKNiln64JZuqju/M11eblvKmOtIC/UToqAkJOnrFOQ6Uh1ZcmYAj4JE6Zigkqv8ALjWha0sqAwPN0Qfxb/rxsJqemJgCzSJwuR1ZDZ8LgOQQAMel2fMDhWwoPiszfXbryCApSvAWKXm7ztirTTBmUn8hBGW8FeJw9WzHY8CsCofLboCGM3Rhd2Gtu3ouywXPSJQ0pmDdylXacTWJfe/wB6wvWv0DTlz0/FSYbmT9SyCaF8wdYskwtI8tCNOsYUyjQr9bKz6SXh8IS1PxoHr1QX1iWwcEv5bbf00b+q9q+0b4qA2NxM7Qe0GumrE4V9DdDnvUYgynZxEXsMwxucjFodvMQBsnVbIm4Q33k6Fdz6fcB1Z9bGAy5qwUsyA0HG0/vWPWies7skk5OZ+ZB8c1orNJswa5SmtuU0/cllksNM2MwT1uVZc5ocHs9vKtLTqtQN59PUMyqpDXl939JBPIQiOY1KBZYzk7pqNsWYBxkOea2vyC6H
 5CNNAtQO
 tsAdbPeJ/fdq3/Lw77AEVdVQ+ZE4Pdm0nkpU6zlx2mmxx0b5NVXbHHRT9WVlKyu3/Tox7bwduFImaVK1AElppabDGSZ7/Gb1Pwqg6QVV+JGO0HRM4rYM7FWQsFCbZnsHcsfZTHh7aeOyHY30zuZFzZLHhhBiO7Ei7EnO8/dyDSCN5W4zddvBHgFhHJ4ozgw+oLFT3yry0DefgoA5nSKHdCOrwQd6fvak3sFohfPIwOrDeSskvbE2vbwgzpwCyY6MDC1jG1SVndwt3x3kjBxtQoUEw2cWahTz37BLAjLV1ywM78wE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 01:52:18PM +0800, Chris Down wrote:
> Hi Jeff,
>
> Thanks for the review!
>
> Jeff Xu writes:
> > Could we please keep the test coverage for the unsealed [vdso] case and
> > avoid unconditionally skipping whenever [vdso] is unsealed?
> >
> > There are two regressions I'd love for us to still be able to catch:
> >
> > 1. Kernel or config regressions when sealing is expected to be on:
>
> Yeah agreed. With the cleanup it matters even more I think because when
> sealing is set in one place the most likely regression is probably one that
> unseals everything at once.
>
> > 2. Regressions in the new `no_mseal_sys_mappings` boot parameter itself:
>
> In v2 I can check /proc/cmdline for no_mseal_sys_mappings to do that.
>
> Lorenzo, I think that also may inform your question about whether checking
> for the disabled case is redundant, right?
>
> >   When booted with `no_mseal_sys_mappings` (or when unsealed), running
> >   the assertions in Patch 3 (verifying system mappings have no `sl` flag
> >   and that `munmap()` / `mremap()` -- and ideally `mprotect(PROT_READ |
> >   PROT_WRITE)` -- on [vdso] succeed) directly verifies that the boot
> >   parameter works and doesn't regress.
>
> Sounds good.
>
> >  or keep strict failure as an option (e.g. `./sysmap_is_sealed` fails if
> >  unsealed without the boot param, while `run_vmtests.sh` passes a flag
> >  like `--allow-disabled` when `CONFIG_MSEAL_SYSTEM_MAPPINGS` may not be
> >  enabled), so CI environments that expect sealing still catch a broken
> >  seal.
>
> I like this and I think we can do it without adding some of the complexity
> that Lorenzo was not so happy about:
>
> - Have check_sealed skip as usual when [vdso] isn't sealed and param is not set
> - A new test, say expect_sealed, fails in the same case

I'm confused about this one - we want to skip altogether if the feature isn't
enabled, right?

> - run_vmtests runs with -T expect_sealed when CONFIG_MSEAL_SYSTEM_MAPPINGS=y

run_vmtests I will have to best-guess it, e.g. if /proc/config.gz is present
check it, I suppose?

>
> That should be pretty minimal. Lorenzo, Jeff, how does that sound?

Sounds reasonable!

I am a bit leery though of requiring a CI to enable the option when it is known
to break things, however, as CI's might rely on some of the software this
impacts.

--
Cheers, Lorenzo

