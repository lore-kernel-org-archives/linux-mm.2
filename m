Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A78AC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 12:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92E836B0005; Mon, 13 Jul 2026 08:52:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DF326B0088; Mon, 13 Jul 2026 08:52:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F8766B008A; Mon, 13 Jul 2026 08:52:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C97D6B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:52:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA2E78AFF8
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:52:45 +0000 (UTC)
X-FDA: 84983742690.14.27068B0
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id 55DAC1C0003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:52:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Qk7WOcen;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783947164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KrzBFQL/kup5HSstLlQrUOdaDnkU3DG0GMPE0mQF9Ek=;
	b=uBsI3zx1wS2IYVuzPcYPTq8AxCyea/hzQ0sA/nSyzaVObZKJhPrCajW2LP+VGIbG3ugCjF
	uICSt20M773JDSjO5JfoHCoj/4c18yNV/eKvg7R5CNJSlgsekYYOQsc2e5ZXgueDCKgjBC
	BTNVQ/qPlyqGB4tMH947vIunu8Qo9X4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783947164;
	b=JIAMr4daiQdBBdN5xEseHIi60Ym+uTE3yTJDgdy0atRCA66a8+EUkple58oHyj+3V8PAgZ
	dobsNvVb63q9sHyLYY5Z19ZLdVUW8lHIDOEgKiMzu/EwlQzEjnoNTH1M8xaU61E5su0py/
	hCjkk/u8tVlgovepCoubU1ywEUi3Po4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Qk7WOcen;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KrzBFQL/kup5HSstLlQrUOdaDnkU3DG0GMPE0mQF9Ek=; b=Qk7WOcenP8TnPsWFDAQmOgcZLQ
	20+qqf/63rlyGlpxez39tkeLyKC8Z+wQFtQiXEQZPjL1rEXLLanNK9TMtv7ZiUK46cLKfaWa7NoUm
	SxITnK2q6daJpcsN2uzpU8OxbcXz+Y8Csn+011MGei1PKdpc9it+eUuDpGvR3sN7M7CtejltAvEPs
	DyF+KzSI2FzcXaqc+rwqn0gOeabrl2YDKSjru0ZK6lbxbb5TN1DWqZf+o0fheBDTzlGCeNb5MI+sC
	CiNtpB1cCDH4UAmBtiUTtMEzCwNdsamqcdY1C/Qj3r409qPnFITZujeIMHbQVLmivixjNdtiKK8ye
	X5RPWREQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wjG99-001VpD-2l;
	Mon, 13 Jul 2026 12:52:32 +0000
Date: Mon, 13 Jul 2026 05:52:26 -0700
From: Breno Leitao <leitao@debian.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, workflows@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/4] mm: kmemleak: confirm suspected leaks with a second
 scan
Message-ID: <alTeK7ffI8_Yy_Dp@gmail.com>
References: <20260713-catalin_pto-v1-0-5b93b1131089@debian.org>
 <20260713-catalin_pto-v1-1-5b93b1131089@debian.org>
 <CAMuHMdWBQ-Vn4XzbrfV31adY7cEjLvmGuwu5_x7rn1NBkEC5mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWBQ-Vn4XzbrfV31adY7cEjLvmGuwu5_x7rn1NBkEC5mA@mail.gmail.com>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 55DAC1C0003
X-Stat-Signature: ruuyrtmp69i6zq7rrjrjm1jki9rosafo
X-HE-Tag: 1783947164-831754
X-HE-Meta: U2FsdGVkX19q5KyDBGngtNmwUbRsLxUVZ0TRIzVnqkxOcWWN5tGHSbt9VWEohmE+pnVK+VIT9g02CG4uJ7cC6GgvIHnctmYKW4kSo8QLrI5NL60Hz5tv/YMfcrs1qNwaet+7ZsTgo3zmwbAYgJGUgv8OOqoAdF4YVA8IM1ZyU1HtDYNvo2cHyq7HJH8pENBok9MEQB1MOJt0b5xxkEXG1BZAIhg2JxkgBzp6nJGl40w/Dgo9hwgUHupO/0MCK1sqm76XXob9rEI0d/mAMxm5C7YMVOT3yxM9l8Oe2eoShrfBxkVb/Qzh0zL64zD3kwwPs+rR4kQlZc5Oopi5dFMQcxHky1l4S+DE1fq/evt5PLMS4e8hBUWU47oboxuwQcu4Lnyly1xNWBWIRZLfVGgH3Hzb5DsLxI3xO8TVAvwMdF9+c/4mKB1Dv9hWFVCazkOX/XSsm0ux0ngSMFHKqzhVbKA9tkLI5Iql3+Nf1QkbcBt+sZUzsmC+e42RSWNNgVHpUHI06FSL9nphNuHDIio0NSW5QR7rmJmkzzDJ3OXgnyp0h8+0QFyUDt3A9HrfMNEFK+PRJfCpeswXMCya3AsJYz8WASALN6txb+jZkT9SeDs3dmmkSz8tFDQvOidhuTm71tEDz9vJBNpHMqazkfN8BdWDaQHAvU/LOjG34OrDR09SGGt8nKPdEn7y/VUldy1XNn9zDjkqCk4gAq4plAmlitRA9tMZKS3C3XDGP8H/FGQkEydWfEgURicl6FIrNUotT43LYmwm3kGS0k/T0BlHscCoFT6gabDx1Zy0AS65mhSaatuErGbLnVu7EXuiubaNpbsl5VI2QIMBHM2Qjb2a5EV7CKnBRbZqD++EMdNjRWbgaqpwBR0I5E2QcC9mfT5J08EEcf3V/o8wGWtST1rXzujPK6G7eBEnS/mPiK2azLlTwBAe+fcvFRWSWK83bYR/Cf8gqiepzlwyYWkdShg
 E4Qx2YQO
 5PF9adfbV8bHxzFzwvVmGh0VhOBext2Smz/78jmMtzfGsziR3BxFVfES/GTH7VLJpJ0iStGPH1KCGLjMLn7tFpKcHy+cqkchwX53goLzFBBEubjSUOBF3iCZblwGmC8MgDeNfqamNlJrQVg4zLZj9pnAHrwgBk9hW+ITbsWmuCtWQ0tBVmCXVGymA6500v/AulODXhkUfP0kBceMWItotujpbX7B/A0gLBOoRz6O+azZxFoFJutHfqXCbRk10P/aw/SHiZ3aIBNutcSDU2GZ5gCmULr0/hpJPSI0C+lhhxGwrzDO1J0Xo8fjXPkHnWD7Gath1EomTkUXnhh4O/TMJrb18JnBw89fjlqbJiwYsvWNjv5tHZAJF8w1ShlkwF7mTnW41w5f3+8MXaXU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hello Geert,

On Mon, Jul 13, 2026 at 02:36:30PM +0200, Geert Uytterhoeven wrote:
> On Mon, 13 Jul 2026 at 13:48, Breno Leitao <leitao@debian.org> wrote:
> > From: Catalin Marinas <catalin.marinas@arm.com>
> >
> > The kmemleak marking phase is not atomic. While the object graph is
> > traversed, the kernel can modify pointers, free objects or allocate new
> > ones. If a reference to an object is moved from one location to another,
> > kmemleak scanning may miss it. We have explicit annotations like
> > kmemleak_transient_leak() but identifying and maintaining them is not
> > trivial.
> >
> > Given that such transient leaks are short-lived, rather than just
> > reporting such objects as leaks, do another scan to confirm the
> > suspected objects. If no new leaks are found during the first scan, skip
> > the confirmation one.
> >
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Assisted-by: Claude:claude-opus-4-8
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> 
> Thanks for your patch!
> 
> For how long does this postpone the reporting of a real leak?

No, it doesn't postpone leak reporting by default. The default behavior
remains unchanged.

This patchset introduces two features. The first (patch 1) performs an
immediate rescan within each scan cycle when potential leaks are
detected, filtering out transient leaks.

Each scan takes slightly longer, but a single scan cycle now detects and
reports leaks with fewer false positives.

The second feature adds 'min_unref_scans' (defaulting to 1), which only
reports a leak after it appears unreferenced across min_unref_scans
consecutive scans.

With the default configuration (min_unref_scans=1), a single scan will
still report your leak.

if you change it to 2, then, the leak will only be reported if the
leak is detected by two scans

--breno

