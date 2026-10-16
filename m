Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA8E3CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 02:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A80386B008C; Thu, 15 Oct 2026 22:20:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A09D66B0092; Thu, 15 Oct 2026 22:20:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 921746B0095; Thu, 15 Oct 2026 22:20:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A5426B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:20:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6CD23C026F
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:20:23 +0000 (UTC)
X-FDA: 85326885126.01.F90A32F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id B044EC0009
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:20:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="hf/APCPv";
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792117221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lmL800MhDzqLz11aGRmfqIVYdCooWhPvfrmpDQYpZBo=;
	b=gfjZzdWnudymJd8ji8UxIRN6qiTu+IwqCNoSgxFvjuvik51GNtxF7xcmsyrZsNs0usNXPt
	3lVJr4TfAIJJF9dvCyuuLsgpjii+bEZEfIS/GNcuGMTjv39QN143K/0Y/naEUeZIiXVgK0
	t2+UdX+JvhQRTr7c5bVpYG7QAuiKyAg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792117221;
	b=ShZxAQ5yCG1WHOTm+QmBXHJ56T8QSH6kQOSwaXGDR9t3D6vABb5sKXcm+G8CbWliBpkGvb
	gKOMa93G34jaJ/ba8/fmtJip0MJqMh5m/GeBvVga2SKCM+9twqtAG9VpgExFlLNjqnJiSe
	Miwe2G+UB+9+VT9ROc6guDQWEAirKlo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="hf/APCPv";
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A27E60A82;
	Fri, 16 Oct 2026 02:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA431F000C4;
	Fri, 16 Oct 2026 02:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792117220;
	bh=lmL800MhDzqLz11aGRmfqIVYdCooWhPvfrmpDQYpZBo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hf/APCPvm4wO/kVP8/Srv8sXIFsas6E4gZK6pVCUvfbV5Y54ulJdT94YVhW90h8n+
	 5ZkvXCiNDfMlGLRjyYGJsOkQz6sX3kKaSWEVFdw4tguDytc1qG7n48LiDQZOtrGvrI
	 PbeVzE0va94hMd5hKv51ZgPiQbvr7cBuaGyEiFxk=
Date: Thu, 15 Oct 2026 19:20:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kyle Zeng <kylebot@openai.com>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Jann Horn
 <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_vma_mapped: continue past nonmatching huge PMDs
Message-Id: <20261015192020.5336a49bc516219e8254dfdf@linux-foundation.org>
In-Reply-To: <20261016011549.61146-1-kylebot@openai.com>
References: <20261016011549.61146-1-kylebot@openai.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B044EC0009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: oehm9591bod19er6uop8d84rrza8sagw
X-HE-Tag: 1792117221-487284
X-HE-Meta: U2FsdGVkX186PxMZZSeJ3u8m/VoiKb5Lhx5FUjJ4w3pLJYb0cnq2xfTZ3WwRTnSOfSDhFXSyQHcI8efCIZ/H8TDclCg3sEama+druMdIVZMKn+alMkEWc3UxQXAdzvCXxOnrOLsHCu0BlkkFUWvL6vJkt/tozqMZEMPa2t0na2ydfNY8d28DW3VvnqfRFXZAs9XqT5362IM+GGmtXqyLEfLq4ne7HwmNrbFtUgTeuMwqWp87cIXsriDWYac4TwuVN6LIT9S7s8pax1aMOBEMDbIHaa0nfmrjKGzJ9ztwLvvFT5vn3Z5lyoSuXld6AgvAqhD9wXNdIZvsftQI7Mp/96yx1SnLbX6Vf2Jpx1RXqQTIVd8cw+kFqLZM+OPd9Wx5YrThR4ds/Jk8+mPk7EiUTxWMOtlagzhGlMczapFKxrsW8nPWPMk/Q7BJ0clmfzsTK7t0Lpr4cIzsEZJxv21WDPcyMc5/M2D20fsg67JepYEzxc0xG/59XLrdk0t+pKwqAItxGzZQHnqLBUCkqCaB98wSRY5hZ7+20FaIXHhmEXiDElIeH+ir7spD3v4DiZYWXomBmLC1EkBwUz8JGyaQemIRhmcdxQOiXFNlmXX7hZcRU+Rqo+wBdlX8q8hiD6Jrpt21f/HHHIOe3Hmq/I/RpAGBY8HIb74GdpGaCe2nfoc4ZqeAMjSMR9YtbZuBufo4Cd1rXra42QVcWOrg9k+VsauRFO6eRys/I5X7OygskmtvU1RND29IEqnZ0APqUx00MFOcwt+JEl7h4qyMpFhZ2XhJqueMtmpADOdcWEqEpk01XuaBRI1ixND8LA7U7nSrrz2A3QtnP2ak8MefelaHrR3SnJZsx4iPby2UZgEBkUIGph/Ijx6oM0SWJPP0IxTxJ1yhyM36eA3doE283EUm3qJg1ZU2lNbD6HHM27GDYZQmTTEVrv0mvjacR6FbV5MLqHVxxK9idNk2F+dqARM
 cKNnBUFv
 Y17l7CzScUNCV/X3LkSka0Xf+WJdSc3sCL7t8vA0nTOZs1xDdww/3+nPVgdiSVVb823P4IhJN6MlBDftGmVmt9qooIX/HkKRyN1NT5CkwH5nB9okg5lDj5tqtzEZiI+S3S7Kqcs7YYX4pYBdRzbwIWjAoA2rJzPLgwSDeaWeW4vrWrG4rHI8uPTn3Q0zHdWi564xaDdrzWVfZYPzMsmwJ+XX98pZscLjJ8REdolAK0T/0msDoPuXmh8PViUXtaRHoCVkPSGcL24+JtorN5/Ch16JDSAnDWDNWFPAEacGJPhSfMnZ1nBbHBvjvRU5agOeoEoUk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Oct 2026 18:15:49 -0700 Kyle Zeng <kylebot@openai.com> wrote:

> A PTE-mapped large folio can straddle PMD boundaries after an unaligned
> mremap().  If the first part is discarded and replaced with an unrelated
> huge PMD, page_vma_mapped_walk() stops instead of looking for the rest
> of the folio in subsequent PMDs.
> 
> This also affects migration entries.  A walk that stops at an unrelated
> huge PMD can leave migration PTEs behind when migration or an anonymous
> folio split restores the mappings.  Those entries do not hold mapping
> references and can outlive the source folio.
> 
> Skip the current PMD rather than ending the walk on a flag or PFN
> mismatch.  Do the same if the PMD became nonpresent before the locked
> recheck.  Release the PMD lock, clear the per-PMD state and advance with
> step_forward(), so the existing range limit controls termination.
> This covers present, migration and device-private huge PMDs while
> preserving the matching-PMD and split-to-PTE paths.

As always, when fixing a bug please describe the worst-case
userspace-visible effects of the bug.

I asked $LLM and was told

: The worst credible effects are permanent application hangs, kernel
: crashes, and potentially system-wide denial of service.  Stale
: migration entries can refer to freed and reused physical pages, causing
: page faults to access unrelated folio metadata.  Memory corruption is
: possible but unproven; cross-process information disclosure has not
: been established.

But you have an LLM too!  So please never again send a bugfix without
this info.

Also please explain whether there's a reproducer and if so, at least
describe it and confirm the before-and-after results.

Thanks.


