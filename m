Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58129C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 09:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2701F6B0802; Sun, 16 Aug 2026 05:59:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 220C96B0803; Sun, 16 Aug 2026 05:59:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 136456B0804; Sun, 16 Aug 2026 05:59:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF8D96B0802
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 05:59:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 73C871404EA
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 09:59:10 +0000 (UTC)
X-FDA: 85106684460.06.347FE97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id DF60420004
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 09:59:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y8Kj/UNg";
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786874347;
	b=eR0tDXBKfi6Sa48Is/j8659F+2GBh98Y6cZueZrD754O0cZNg8Bs7XarMPNfkzVvX62iNe
	75qjPCfsicBDxLmQmRECh93AoPhIfpLBjzojAysCtwm9TRuMEUYwT6GRorGMZtG1LclA9D
	gP8b7n1nGDiQYRD8izPERfF7UhHrY+w=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y8Kj/UNg";
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786874347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NTYJAsVDkO7YIxBVl0sfyICvDw21eBl55uq6tMu+icE=;
	b=Q7Fg/cXSf5lhyBVCjn+tNzOr4MxBrlWxi3V6axx7FE1l9yKp0KHH7sDutzssu/T6g2j+Jr
	m/ZFqgYoX330g1wQW+0xiSktiRJELIXuaRiZInF3vCLhRoVm9IxDXQOLcNZUTE4fIzUOve
	LcgQlBnD6OXbBeNYNecD1nuw0h+PaD0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 20ED140557;
	Sun, 16 Aug 2026 09:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6D31F000E9;
	Sun, 16 Aug 2026 09:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786874347;
	bh=NTYJAsVDkO7YIxBVl0sfyICvDw21eBl55uq6tMu+icE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y8Kj/UNgRL/skfMARhgY4keWAMhwtZeZa9GTiEpwT7TsDVKb52rE3IlBql5jX7br+
	 crgRNKTt/d/EEr6h+SMDtPodg09wi6BcmELkdZ8pF0AVnc5JDXHqIdk2PTBPt1nGfH
	 PID7IZlTaKnSQkSuz4Anro+841WvPyI7+Kd5T/+NLUQgQwG9tpVhgbgfyZatvtJhw8
	 qitPPHYaSRfs2arUlT3nj1wFT3uH0+n9pERnI8GGdpfCsFuwKFezDJxBUIRU8I7M+B
	 /tLBDWhjnUjZ11fe6oZ9gHXuRFWY5ABu1b2kq+T6MangVqAIMg/qw4Rz7845h+RKvU
	 QwxpsqNjYyKgg==
Date: Sun, 16 Aug 2026 12:59:00 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] arch_numa: Avoid false positive fortify warning in
 setup_node_to_cpumask_map()
Message-ID: <aoGJ5KL9cMl1E7iV@kernel.org>
References: <20260813-arch_numa-avoid-fortify-warning-v2-1-093ad97a78df@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813-arch_numa-avoid-fortify-warning-v2-1-093ad97a78df@kernel.org>
X-Rspamd-Queue-Id: DF60420004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: qengpnfqpx1dforeezfep6k7ph99crrq
X-HE-Tag: 1786874347-376010
X-HE-Meta: U2FsdGVkX18JagzmL/146Y+b5HbNR4x9w9iy1sUHb76TjqgBcdy4NHNYqjfYSfYWxCr8NW/6MbSiUYHd22G9ReLKuYphwA4LJcOm7XLAwHkd1aXHmVvZHd3n4URdytXCFTbrPMgLn6AKmF/eusqUPzb5AM2pkNANinxqHNw2l89ZRY6mmJb7kUmnlzplCZ2QvqUKKDgPWm1sIcJeCk7QHPuxGZbybQo7WpRSUHNILsK46PSNvBM3J7Twh4wY947bLRIrr0YIOiy7peonpXsKJRNH+r+mfhyZ/Xa0p592aawk5tHxguPVfh970mk5pitcZyHeB598Z+guWDYP/xRgqIUiASS5ePX3OmYuaDzNyeGZAcwHWDd5odbrTAJzZD4fVkSDnxsmTd//pdMvBIFkbh6gTc6KFSiyFvSjGvJLENt5DNT5xHvLY7IRsBOS1LUC4bxKZyvX3fy7nsFHJfcT5dvA3n5zGa/Yf/8Hzoc8kNfc4SR7XrqChZ8tVp4DhfLF2kE9sLy8nMe7PGQBR5WGXGqAo9mAZjQTSHDYP2mkTvTT6ccaxXraBugDVw0Ujei6iacau9aybIiLOCt1aomGQGoI/eqpNur7/eyJOcXd1A6/y6J+cAtRtwxwBSn1i8YpoVf6F7ovyh148fLng4KO/zvKe+zgd1YcjUwslP2Xdnsq9mTAX/taN6m6eWFj8q8ui5BDp2YnbATnFNzA+Oko0WULwBYhsF+EbfzLTR6aNHEvae6A/mg2v21OO5Cfb2wpKRBIj4+xdmvRIyuv3znqIYYg6Mbtw2JX2u8haLj/iFvitX3YNtJBbuvaLwXRcLjilFHjz7HH7sJ2jTUS6koDzb/8U7zKYDpY1uv/gd/P4P1Ba87C8LaIgKS6efG+0eAYfTiivelzhn7AUrYlGE573LttlshaO5gUuLwYbRzsRsVFMONzuaKNouR4C+vGQANVgZv9UkVCxpUyICU/SfV
 kADLG5vu
 GMnxRYKjEJ1Ha5E84z+SWBhobLAc53J5ub12onju3u/OBlVhEOVRAE7MOG9CPXlBLwb64DQrLV1HSZN9Ya+4rE4DbaMKT+rH2dvt1s7IO6Kt/zAYMFRSXZcfahV+BLrCfflG2JAYm229FlcCgpSFGwMkFrBaOnaJvuCzFZstXrLCErI4SN9MM6VPa6cVUluLjtsXWs/5nZ0b3RhW1h1B7wTBKSYyK5X1yqJKbuFcyNsXiXcQMtUtM0uifJvBp4wfbe1T/RoBfyqElQvEI+6OIGhD8wQDK+acHNkqH54yFQ9O5u5Gwc/BDhlOHcy5Hrf2cWyuqTPhVecD87pRW2pAHtdweSmpee72pdl7r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 08:12:55PM -0700, Nathan Chancellor wrote:
> When building ARCH=riscv using clang with CONFIG_FORTIFY_SOURCE and
> CONFIG_UBSAN_BOUNDS enabled, CONFIG_NR_CPUS > 64, and the default value
> of 2 for CONFIG_NODES_SHIFT, there is a compiletime warning from the
> fortify routines.
> 
> In this configuration, MAX_NUMNODES is 4. clang unrolls the for loop in
> setup_node_to_cpumask_map() past this, which triggers the fortify check
> when accessing node_to_cpumask_map on the theoretical fifth loop
> iteration because it would be an out of bounds write.
> 
> Make it clear to clang that nr_node_ids is bounded by MAX_NUMNODES due
> to the logic in setup_nr_node_ids() by early returning in
> setup_node_to_cpumask_map() should that condition be violated.
> 
> Cc: stable@vger.kernel.org # all applicable
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2174
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/arch_numa.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

-- 
Sincerely yours,
Mike.

