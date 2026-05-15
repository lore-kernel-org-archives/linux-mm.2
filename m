Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDB71CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 11:45:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A9156B0005; Fri, 15 May 2026 07:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25A176B0088; Fri, 15 May 2026 07:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F8E6B008A; Fri, 15 May 2026 07:45:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 06F626B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 07:45:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A98F440624
	for <linux-mm@kvack.org>; Fri, 15 May 2026 11:44:59 +0000 (UTC)
X-FDA: 84769472718.27.CBAFBAF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1FF7940009
	for <linux-mm@kvack.org>; Fri, 15 May 2026 11:44:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y2zYqn3w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778845498; a=rsa-sha256;
	cv=none;
	b=HaCnaLkVLT7YxSQ7WUB3fU3YB1aFIH0svhKjTvK3uY8XZ4/8nXJlHxjbFaceKWDvm5bohy
	SBrBWHTlym8ChAhigFYMz3lZlrVx2dpfaFV1ZYH1YTFyLXty4+8dkZUVjSVGvNf3CZ0cbh
	osQQluxDSEO3RuY6TZlYmAZjKVQY/ms=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y2zYqn3w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778845498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KEsi4rXjLXcqTQLU8173/KLnswspO/pjafZCPcWeGCM=;
	b=cVPdidfD0YoFf4IXfnG0rpZzOGAuvNkqoRQq1QhfTBHeWR0Wdj38GiHSBS8IDG4S8z6Jlw
	aXLsBVIl+3aGCrpwQexSGDi+vwwCUYm2bJclNQb8A6JOXfN6lIaoZ1C5MavAmMzFNpfURp
	QeT6D3l5OmB6j02sTAn8WhSZpAcsIn4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D5A660018;
	Fri, 15 May 2026 11:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FDDC2BCB0;
	Fri, 15 May 2026 11:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778845497;
	bh=PE9zQaAn7lWPjucVTgHtv7aA9fxAoNNXlV5pSrMocrg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y2zYqn3wTDDVUCJZ2Sai/O/wF6mekPeiFMT93wDS/0apVZM2TppMjBg/DCJy+QboD
	 P3xxqEtoB9AqKCKcVTp2gJvnFKTeMl8r1t1xPecjZPRktoMiRnc8A/XF6JsI/Wb+Cb
	 m/FuuTvWMMkDqREi57ZvsGMUSfNu0fZ5BMTKtrq3jg6grdIgZX38TAUuMnxLwRsy9+
	 O1I01R0/hCzNzFD8lt+0NVnf/z5WQUqrhPbjOsn9iSpktZv8MKEJq3ebT9bZvlJWq2
	 ZpqW+6hXf0KQ21x7xBRx+lxeGQTCqvcHg5rtlyIvdbMBVh35JAE4Uo50nkcfXFp+Tp
	 iAJdzLt4JZHKQ==
Date: Fri, 15 May 2026 12:44:55 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Ahmed Elaidy <elaidya225@gmail.com>
Cc: stable@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, 
	avagin@gmail.com
Subject: Re: [PATCH 6.18.y v1 0/9] mm: backport sticky VMA flags and
 soft-dirty fix
Message-ID: <agcG2uKHhlt85FaV@lucifer>
References: <20260424211315.1072123-1-elaidya225@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424211315.1072123-1-elaidya225@gmail.com>
X-Stat-Signature: e1wo11oix3azudf83uqneef1ufi6nm33
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FF7940009
X-Rspamd-Server: rspam07
X-HE-Tag: 1778845498-632986
X-HE-Meta: U2FsdGVkX1+H7fuV81D4LCAUMzvUlWhZmC+JQIPYsOk2GFhA1G0YySqxX5fmPqJWUtu6qiDngWT7nueWzWhiHJ9PhuJEpoQ8ZfwwphqhBKcPVtnncqtzwkDPHWbtCOuFjezomHEiRXgo4acx8R6uW9M282ngcNmWeDdA+YisnAJoMP5h68u/pv9ZppyPU/93mn5PA7ahysh2Zb9Tfth8xmZtXxiaiYqnvvXNfsj9PxzyFrQNpu4ercQBkaRFEePsi4W3As2pSXsLZg1g2wQwaJs9nZxkkrJY9WG4ymbHMLRz7Gmy9Cxp3oeoMHEQLIDd0bgTgN3gCh97HihTgxJ0ptMD1KkcnaZNyWNQ3RNmU4rluC+RP2fMSjYjgptkZZRgFC/59lYCgD0F43zp27jIOCOg+uiwv9dP+2qmLOLpHrOKNIHvAAqUmYclz1I0KeDe4v3lfiGlUf5+QfKTaZkp2WF0F6LySkfIWr9+tXQOYEuEmVFNrwZt9AHq2+YKORNGYoT6vxop8T4IJaaiVQBF17lRTRatfiW9SWAsph/wH166AEm+1ksbR+z5YrOsu3nZfjjZOEVomA3fHsEperQ27CpiE0oSzwoUKfcV65Xiclb+CO1rPOKef6EKMfM5cL4d4b7JtMFfLFnCsM/3erE6K7fooExku7priqs9B6MvLiVslUFDQ1GGuC0aRQJdM04HhGh9Ks8Js3rUAEh1JZ2ncYZGjKSK3Huyygx4slMPN24QuYRuDxM5SanJhxkmAry9my9lqnMzf+SoqbgNqNqUzQsIXE0RWFEd4I+WNN//Nsz+rdoz0KaAvhFCLI0dWQx77hAPUfyik9hvDuNa1aeo7aSyIB3x9PZrfkC8hNaTS+Fy1Yw/DVDJ6zxyNMX2rvrnS8NpSysMIx75FQ1UuOYO4GZfFv27uSYT1/A6GaTigPxAk90c2d2Lu5Q9a6Icj0hKzZAdZ1tkykaZT969HSB
 QyJsvoAw
 enmuHYQomm2jhqHkSSc+XACzdGE+lS3DM+ymRrHzBk+xuK1SYhXzDQkD4Arjoa+lcuSqt14qEU1NTiK90iCGe7Pajo6Nv1TsSEV5xFhfdsF2pErf2qpM9a+65vvIX2moE0DB94EMJSHtO/qpBtDYk/RSqT6aOclE8MM/2pXYK8kbqrIwCGpYy3gntXAAhe/7Emor/SkQ2i4yHX1Vin02ss7b2qB71fZ44UHZey45ZHa9UHNTiXzUZmxkdy3/YQaMp5YRIMwaDBpwJeHc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Just a heads up that I generally don't read kernel mail sent to my work address,
as I changed my email setup significantly and use ljs@kernel.org for everything
upstream!

Understandable given the original patches obviously used it but just FYI :)

Cheers, Lorenzo

On Sat, Apr 25, 2026 at 12:12:34AM +0300, Ahmed Elaidy wrote:
> This series backports the sticky VMA flags infrastructure and the
> VM_SOFTDIRTY-on-merge fix to linux-6.18.y.
>
> Motivation: CRIU incremental dump/restore can hit a missing-parent-pagemap
> failure when VM_SOFTDIRTY is lost during VMA merge operations.
>
> Patch 8 is the target fix:
>   mm: propagate VM_SOFTDIRTY on merge
>
> The preceding patches provide required dependencies on 6.18.y and are included
> to preserve upstream behavior.
>
> Backport notes:
>   - Non-trivial context conflicts were resolved in:
>     - mm/mseal.c
>     - mm/vma.c
>   - Conflict resolution keeps upstream semantics; no intentional behavior
>     changes beyond context adaptation for 6.18.y.
>
> Cc: stable@vger.kernel.org
>
>
>
> Lorenzo Stoakes (9):
>   mm: introduce VM_MAYBE_GUARD and make visible in /proc/$pid/smaps
>   mm: add atomic VMA flags and set VM_MAYBE_GUARD as such
>   mm: update vma_modify_flags() to handle residual flags, document
>   mm: implement sticky VMA flags
>   mm: introduce copy-on-fork VMAs and make VM_MAYBE_GUARD one
>   mm: set the VM_MAYBE_GUARD flag on guard region install
>   tools/testing/vma: add VMA sticky userland tests
>   mm: propagate VM_SOFTDIRTY on merge
>   testing/selftests/mm: add soft-dirty merge self-test
>
>  Documentation/filesystems/proc.rst      |   5 +-
>  fs/proc/task_mmu.c                      |   1 +
>  include/linux/mm.h                      | 100 +++++++++++++++++
>  include/trace/events/mmflags.h          |   1 +
>  mm/khugepaged.c                         |  71 +++++++-----
>  mm/madvise.c                            |  24 +++--
>  mm/memory.c                             |  14 +--
>  mm/mlock.c                              |   2 +-
>  mm/mprotect.c                           |   2 +-
>  mm/mseal.c                              |   7 +-
>  mm/vma.c                                |  81 +++++++-------
>  mm/vma.h                                | 138 +++++++++++++++++-------
>  tools/testing/selftests/mm/soft-dirty.c | 127 +++++++++++++++++++++-
>  tools/testing/vma/vma.c                 |  92 ++++++++++++++--
>  tools/testing/vma/vma_internal.h        |  49 +++++++++
>  15 files changed, 579 insertions(+), 135 deletions(-)
>
> --
> 2.53.0

