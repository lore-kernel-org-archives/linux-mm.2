Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9295DCD4F48
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 12:00:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C0616B0093; Fri, 15 May 2026 08:00:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 272216B0095; Fri, 15 May 2026 08:00:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AE7A6B0096; Fri, 15 May 2026 08:00:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B9B06B0093
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:00:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E86690964
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:00:54 +0000 (UTC)
X-FDA: 84769512828.22.CCFED07
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id D562D100003
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:00:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pB3rLOif;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778846452; a=rsa-sha256;
	cv=none;
	b=MjQNDdxoC1w46PzkbaBFw1SWpFYEL8sgFiMeeCvbVgKrrrXhZ36KJVLyNkg9WdDI6ywB5a
	wosGO5qd8cqUbsWqxEqLNi+QGcNIWuNJjZki6DHcCLwNsCdVrYzRFnvgYQfAmQXniafNpo
	frcTnEuYVcUvauJJw4puhWKnht00j0Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pB3rLOif;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778846452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rqUuSdLw9o8MFVvVMazC+eykVyiUNVFPH8v4FMnL9Ag=;
	b=fqkZVDIBMxAQsEe6lBZyFp/Hws2NvbFZxHxZUWn0gRoT0pSIY+Kf6MOUINlJJ2WG+uSBkL
	foOfrqBVmV0GT/FV+6ijCgMDUX1g+pYzM7bOPsI4fE9vS7Q3/8fcxKq4UHLSynPC6hz3GS
	Q81zEMrTNpovg2TM5fhXbcYX9m8RUug=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 27FB060008;
	Fri, 15 May 2026 12:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE650C2BCB0;
	Fri, 15 May 2026 12:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778846451;
	bh=WZnNIBt2urPbxa47troMlcZGn0NLvkjQIUasM9GRgDo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pB3rLOifn+WsvWCUeIEWFVrzDnBFP4vrbr8hMs4KYBxS2XnLrog6MEqkDcp4FQLIc
	 zm/bM7qiiMq4uXt65cFCJsVRjS9noXKUIiq+/jwYxAA7tFbx7BmKoVtw107p2oGWdt
	 6lWwc7skpeyKCzN7kxK6s0e8YGxgoj9UTw5ltuDMPh0ycOCP+5MC8QQIdReSlLUl8/
	 v2J5GJvth2iHMhrTD/koTwXvdhg4xUMWOWJrhcRPPb01UU2BM+HfTx7jg+gvrWFDCU
	 aDthO+bSzv1GfuhfSUQMLV0C408bAuhwmBsHvpHUFPjDkUeEZTqWb1lZljQfbyqyxH
	 t4NEn0c7otwOA==
Date: Fri, 15 May 2026 13:00:47 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Ahmed Elaidy <elaidya225@gmail.com>
Cc: stable@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, 
	avagin@gmail.com
Subject: Re: [PATCH 6.18.y v1 0/9] mm: backport sticky VMA flags and
 soft-dirty fix
Message-ID: <agcK1mzmGbB5KSpP@lucifer>
References: <20260424211315.1072123-1-elaidya225@gmail.com>
 <agcG2uKHhlt85FaV@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agcG2uKHhlt85FaV@lucifer>
X-Stat-Signature: i5i4rchqdyh7jjw1oyrwn8pzpqeguw36
X-Rspam-User: 
X-Rspamd-Queue-Id: D562D100003
X-Rspamd-Server: rspam07
X-HE-Tag: 1778846452-447744
X-HE-Meta: U2FsdGVkX1+ch6tYeD1Mavq7CmbTGyhE/i7w1B+DQOt6GppD9xoLE/PxQYLMEfD63cxD65KkKyZQO2vJFsT3gUWfcOKEXUgI1Zqn/X3g/CgR/8b+vClWABHBZttm+ekCEsf696If2eD9PkX3qoGYXDTMEO0j50ti6n8Dfy4OhOr7q7pov7cDwEjfEMUfQfkT+VA/CshNxkLvHj/XbeNAryt1SPrG2lbgnWbZUPKnJKbIuCUTnmDJNoIQx2IThd1XnBIKm0k9PZDbMQeoeIVERSEGk1B8bbZLbL3MnommQjoiLoguj3h4HhWcOLx+1AY8OZ7RAHx8dKKL6k1Hvc9wdotNGu7UD86tYzytkNoZNaA/aqTQoI1E6P/Uw58TrnreFs1X7vIIJY7WGR3817CvoTA+e1WbHxEOGAR3RccOrr11fARuKYdi9LFMZeT2WbAl8p9SxbRNqYTKjDKDkdj4hTFXvPQyrPZ53WKdNnk4x6kFBQ1GZjUxVEn9Wwur0ooKSlXdiDkLgZ3EYsbKnl5btohMqnGzfqgZkI2QAq8khJXDw3+uvlppVXw4hGhXlL1yQcI05P+ZYCkIUn22usVWkpS7zxCfNz/xgEsnQnOto8qMN/Ig5Yex4jT6HSYFE6Dq/BYn9fd7Rqy7PcRQde3NGq478bGCLBskJ3SS2Ij0HSlUyEnETu0GBAL67OM3CpahrCZvGsAxXMLcXCuC8Uz7y4sdoHeNGs0/rC0WMte6TiEvFpTOFTz4MHI5syRZiaZfeBA1qazxXVSgkLI19MRyzAqF3eqtLpkSF+DER/5wQxkjkzXjbGM2syqXqrJFP6qE2OQ6aJs72E9Ssw0GzeNE68flkv0w67PbqfKTtG0ai5cbmhesrRaAesk20FyMiym+3kDCi3mChav2wwnhUtSW2mjAfrooteBP4TrfBP8nEzUoW6vsC/0OFv+3bp9w9qSB0Em8daYiZZK/kQW+AVn
 OyjS2CBV
 bzFi4F+AFHJMJoNyHp/AOyL2M8sDFC+VOiXCUuo/GMdpPRXZa8r4DeslwRB1rPFMJIqrLeqeFjk999/227xbM6azqMaW57l5rnep1+90vBIsPzXjH2v1dthuguao1XifIYsFl272ClMbIXRKRrr9LReGhp5046VNwzsrzi8v4ySGH7X+7SEsVfLIR2eDOQe+vjR3Qi5wmm/hV0h3p93GmS7zeuyGqBX+MJxF4RGMnQL/JBnTgTjb9aHs/GOMbjBeraMDjE/ujRWcvUHU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 12:44:55PM +0100, Lorenzo Stoakes wrote:
> Hi,
>
> Just a heads up that I generally don't read kernel mail sent to my work address,
> as I changed my email setup significantly and use ljs@kernel.org for everything
> upstream!
>
> Understandable given the original patches obviously used it but just FYI :)
>
> Cheers, Lorenzo
>
> On Sat, Apr 25, 2026 at 12:12:34AM +0300, Ahmed Elaidy wrote:
> > This series backports the sticky VMA flags infrastructure and the
> > VM_SOFTDIRTY-on-merge fix to linux-6.18.y.
> >
> > Motivation: CRIU incremental dump/restore can hit a missing-parent-pagemap
> > failure when VM_SOFTDIRTY is lost during VMA merge operations.
> >
> > Patch 8 is the target fix:
> >   mm: propagate VM_SOFTDIRTY on merge
> >
> > The preceding patches provide required dependencies on 6.18.y and are included
> > to preserve upstream behavior.
> >
> > Backport notes:
> >   - Non-trivial context conflicts were resolved in:
> >     - mm/mseal.c
> >     - mm/vma.c
> >   - Conflict resolution keeps upstream semantics; no intentional behavior
> >     changes beyond context adaptation for 6.18.y.

Thanks for doing this, had a quick look through the series and all LGTM!

Cheers, Lorenzo

> >
> > Cc: stable@vger.kernel.org
> >
> >
> >
> > Lorenzo Stoakes (9):
> >   mm: introduce VM_MAYBE_GUARD and make visible in /proc/$pid/smaps
> >   mm: add atomic VMA flags and set VM_MAYBE_GUARD as such
> >   mm: update vma_modify_flags() to handle residual flags, document
> >   mm: implement sticky VMA flags
> >   mm: introduce copy-on-fork VMAs and make VM_MAYBE_GUARD one
> >   mm: set the VM_MAYBE_GUARD flag on guard region install
> >   tools/testing/vma: add VMA sticky userland tests
> >   mm: propagate VM_SOFTDIRTY on merge
> >   testing/selftests/mm: add soft-dirty merge self-test
> >
> >  Documentation/filesystems/proc.rst      |   5 +-
> >  fs/proc/task_mmu.c                      |   1 +
> >  include/linux/mm.h                      | 100 +++++++++++++++++
> >  include/trace/events/mmflags.h          |   1 +
> >  mm/khugepaged.c                         |  71 +++++++-----
> >  mm/madvise.c                            |  24 +++--
> >  mm/memory.c                             |  14 +--
> >  mm/mlock.c                              |   2 +-
> >  mm/mprotect.c                           |   2 +-
> >  mm/mseal.c                              |   7 +-
> >  mm/vma.c                                |  81 +++++++-------
> >  mm/vma.h                                | 138 +++++++++++++++++-------
> >  tools/testing/selftests/mm/soft-dirty.c | 127 +++++++++++++++++++++-
> >  tools/testing/vma/vma.c                 |  92 ++++++++++++++--
> >  tools/testing/vma/vma_internal.h        |  49 +++++++++
> >  15 files changed, 579 insertions(+), 135 deletions(-)
> >
> > --
> > 2.53.0

