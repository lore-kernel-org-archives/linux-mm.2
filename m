Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189B2C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 18:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 620586B016D; Thu, 24 Jul 2025 14:32:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D1B66B016E; Thu, 24 Jul 2025 14:32:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4998E6B016F; Thu, 24 Jul 2025 14:32:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 35ABE6B016D
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:32:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC6DDB9E60
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:32:41 +0000 (UTC)
X-FDA: 83700004122.12.71D6525
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id ECB281C0006
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:32:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gPVwhn0z;
	spf=pass (imf20.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.160.43 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753381960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=30rlnSB27npgJWbqBMQFO+7pkMsstYfilIqdkjSj02k=;
	b=w/cABuSnDvuxB/E8uEHu4F9QQdRbRCWhz8xIhIywVmCkBWHa0P97anQWuQuimGSWuAdO/D
	1Z1B562b8I2pm7hD+0f/ooencK+eTnbouF4mf6wdzShXkWbD7u8NRMMbVl0R44Msy4jBTb
	Rb2UWAADh7eCp8WcPGhz2txPrImn7s4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753381960; a=rsa-sha256;
	cv=none;
	b=jXnpQIS1JvT7QMOOOUM8byr7lBSCBQ/G1rvDBbMV1xo0w3j07V691f74jj+Qg4Em/Xq/DS
	ukN3iMRsU+phJsjz0aXLV8EckGpfYsxDGwHoq+I/zjg4yAGK0lO5hbIE7e6LPVpN4RcGcy
	fvS21tJPkWHlkOKWiRV+0ujsXXrS+F0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gPVwhn0z;
	spf=pass (imf20.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.160.43 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-2ffc7c708a2so39376fac.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753381959; x=1753986759; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=30rlnSB27npgJWbqBMQFO+7pkMsstYfilIqdkjSj02k=;
        b=gPVwhn0zCvZhhShybqfCQ7UL2ilYvyehSQH8fY1abR9S4deaIxAHzhHFaGJZUScvgZ
         4PorR9SyFJ5bhqAVNnaxWBWPPKvCt2CXwc4Mg52lH47ZqFQtEtl6kWklMCY1euz2IAbt
         qaqPxRvUo5dKszYk8mGkKy2EPBj/fvpn+mtZE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753381959; x=1753986759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=30rlnSB27npgJWbqBMQFO+7pkMsstYfilIqdkjSj02k=;
        b=RSa1/Z8KESNdUUZeqfb8Yfx8qoqaRn6TBETqe/vjP1Y22x9DvampkDSjI+3D0b+x+1
         ubL+to3RW9Pzf+tkqZwFf+oLJfxxCi+Sg4ym75F7rcfU3WGhTeWlao/XajxKwd95oEtM
         PbGT48wB1UgmLnDmKJFIPN5ui6I2zK8UEOsQeNkBGK36+wxhg3eGN4D8/p7cOQ6jZnCg
         xr1YFoEwrnc/nTGDgtpkGOJ7X8zQUEghojzl3/HujiwvC/xjkTpgS5Req3haJR33/gxn
         WXTu4JPvcOuXlqjOpvzKHqal8fO23H678SlK3kBHY8RbP5kKC96hDwGa9aavqU+JwpOI
         es3w==
X-Forwarded-Encrypted: i=1; AJvYcCVOkTz7/A2K/KduZoVRkpGSMruzs5SY7DVKryHoaFwFGBJRhhRoiN6vEI6ddeYCP25VofTath5W8Q==@kvack.org
X-Gm-Message-State: AOJu0YwMK3a8v1u/BQZLAshqldMcPo8x281B4MfWoAmPU5ksY/Vpt41H
	GD4Dt8bFfsxzFD/zPUNpsiM4pS5RXC5bbQMEbqkmLq4qAkwPgbaun2Dd0WiB5JjTrPwSjdyKnz6
	2ekGF7KfqcwdQIssmBrTR2oALODg8wBEC6XpQR9EC
X-Gm-Gg: ASbGncuMHku1IpngXpVY0Kf0zf1nF1SSGAFEBilZAaDaxcIG8O0oh/KsQ5mIX43hpou
	X8azSC9m86B0SOeMynCh0BuNIcdkeNjao1XkhFn+3wq+NTuQd4gaZliyVrTuskMfLj+anrBceV0
	GAWsW3nuETQA0Ak2gZsmwjN+NBcrv4fCJ71t9srKz5/XH6WkrNy5CH/jXmz9zua1Yve++wwsJHI
	/2JvH8pJD86sMWLIv4cSvKlmfwkTBlvYMb9
X-Google-Smtp-Source: AGHT+IE/v8/QcDYMq5rcXlGAzua42CVQDWzWzn2XXU5Eo9ZmM+YPZpj2WCQ58zMFcZj9ilRciyOvuOU/eAmRuaHjmtQ=
X-Received: by 2002:a05:6870:bb17:b0:2d6:1e7:f583 with SMTP id
 586e51a60fabf-306c6f2f38fmr2016132fac.3.1753381958752; Thu, 24 Jul 2025
 11:32:38 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
From: Jeff Xu <jeffxu@chromium.org>
Date: Thu, 24 Jul 2025 11:32:26 -0700
X-Gm-Features: Ac12FXzJWfvxsyQk1Xr5HsYL_xRb49zP3u1pqHeWkzOCB4ps3luILJW3LOiNn98
Message-ID: <CABi2SkVVswRr+H5OWRcbFQSLq_457a0eXwn0OrtkcMEbGphz6w@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] mseal cleanups, fixup MAP_PRIVATE file-backed case
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kees Cook <kees@kernel.org>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: ECB281C0006
X-Stat-Signature: x6drp4yrcszmbjk7xr7tx3fhgppxxc98
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753381959-951503
X-HE-Meta: U2FsdGVkX19Fxisxmek0K/3KXY8h/GmxqOAZj1uC+LGYeeLsAFbUAgvs8Mk/BkftIpdDsNaO6enhsvRN2JDciuEaUYDT7v/ShdlV9HyH/p2bBYYcGlm9S+eXPEzgRMKwn1CAtsSZWTH/vmz6zKu9FIuebrBduz54cYB2TH4jziM3NvXVwIX/sRtaicO4Cf3W0ni44IypD4fiAZqdIRbBnF7Ram/+jOoTqs8nMpsACsHRU0ZJH/rx2M+OvU5DmNysIy7znS4MESXkz6ayIWAjzKPRAOhw6bADehu09vAWn3ocDrZjsfffDuz8Rm4/y+sIn069Z+rIA0qCkNH/BgEkLdthC39wB4RNX4e3wCMnlEDOsCkfZuAZ6q9zVvAQckBzLS4MhtwZruw3LVq3CUmkwKqBznqznFtufMorUhFDSk4IwG3qXRm+lTLjtDfOW+U9i3JFu0dQjFixZ1sNisOdSbULC/QMjEDxakFH9xzI3BGZcltlxv6olVkzm0C1K3I/Fj0Vkwa4mjVXGk62A9i718/OYsSXvpfZP+EM91B6ZmF+F9tqVq7q6dpI5OSwJA1MZkCuai7Kv28UNZfOtPEafW+z3VpzWFfqj11CY+ITVbdCwVCHkI52yhUVAyD6yG5pvB9+uIYRiFKMd/k1lC3qHhLervUJ8tMDj9t/xbV9vWcUYOAU9kMygwL4hvbjTJAD9W9bYm4yyxU2IIHJuBu4h6nOw017bZGWk7ul80zOrJjoXhwuW6jPAGnftefMq1rhWgvor9P5hIkdJCTtPkvS+FbKsmWJqdyDr6nls/TQmll/VEbiTboI7DcPkBGp1OnqT1Lvuua1WqErVi97UKeBuuCc+IHkfaGxd6lyVqcOAMgSDhTwl0/N/FbdxcASovezIjU5SwB+OAf093xCQAL97n9VwtZylz5MH3Z9pZmh6gXEaEtJTX28TrNxqBIwfNxkW4ZERLtLM4A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

Thanks for including me in this thread. I've just returned from
vacation and am catching up on my emails. I'll respond to each patch
separately in the following emails.

Could you consider adding mm/mseal.c to the HARDENING section of
MAINTAINERS? Please include Kees and linux-hardening in future emails
about mseal - Kees has been helping me with mseal since the beginning.

Thanks and regards,
-Jeff

On Wed, Jul 16, 2025 at 10:38=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> Perform a number of cleanups to the mseal logic. Firstly, VM_SEALED is
> treated differently from every other VMA flag, it really doesn't make sen=
se
> to do this, so we start by making this consistent with everything else.
>
> Next we place the madvise logic where it belongs - in mm/madvise.c. It
> really makes no sense to abstract this elsewhere. In doing so, we go to
> great lengths to explain very clearly the previously very confusing logic
> as to what sealed mappings are impacted here.
>
> In doing so, we fix an existing logical oversight - previously we permitt=
ed
> an madvise() discard operation for a sealed, read-only MAP_PRIVATE
> file-backed mapping.
>
> However this is incorrect. To see why consider:
>
> 1. A MAP_PRIVATE R/W file-backed mapping is established.
> 2. The mapping is written to, which backs it with anonymous memory.
> 3. The mapping is mprotect()'d read-only.
> 4. The mapping is mseal()'d.
>
> At this point you have data that, once sealed, a user cannot alter, but a
> discard operation can unrecoverably remove. This contradicts the semantic=
s
> of mseal(), so should not be permitted.
>
> We then abstract out and explain the 'are there are any gaps in this rang=
e
> in the mm?' check being performed as a prerequisite to mseal being
> performed.
>
> Finally, we simplify the actual mseal logic which is really quite
> straightforward.
>
>
> v3:
> * Propagated more tags, thanks everyone!
> * Updated 5/5 to assign curr_start in a smarter way as per Liam. Adjust
>   code to more sensibly handle already-sealed case at the same time.
> * Updated 4/5 to not move range_contains_unmapped() for better diff.
> * Renamed can_modify_vma() to vma_is_sealed() and inverted the logic - th=
is
>   is far clearer than the nebulous 'can modify VMA'.
>
> v2:
> * Propagated tags, thanks everyone!
> * Updated can_madvise_modify() to a more logical order re: the checks
>   performed, as per David.
> * Replaced vma_is_anonymous() check (which was, in the original code, a
>   vma->vm_file or vma->vm_ops check) with a vma->vm_flags & VM_SHARED
>   check - to explicitly check for shared mappings vs private to preclude
>   MAP_PRIVATE-mapping file-baked mappings, as per David.
> * Made range_contains_unmapped() static and placed in mm/mseal.c to avoid
>   encouraging any other internal users towards this rather silly pattern,
>   as per Pedro and Liam.
> https://lore.kernel.org/all/cover.1752586090.git.lorenzo.stoakes@oracle.c=
om/
>
> v1:
> https://lore.kernel.org/all/cover.1752497324.git.lorenzo.stoakes@oracle.c=
om/
>
> Lorenzo Stoakes (5):
>   mm/mseal: always define VM_SEALED
>   mm/mseal: update madvise() logic
>   mm/mseal: small cleanups
>   mm/mseal: Simplify and rename VMA gap check
>   mm/mseal: rework mseal apply logic
>
>  include/linux/mm.h                      |   6 +-
>  mm/madvise.c                            |  63 +++++++++-
>  mm/mprotect.c                           |   2 +-
>  mm/mremap.c                             |   2 +-
>  mm/mseal.c                              | 157 +++++-------------------
>  mm/vma.c                                |   4 +-
>  mm/vma.h                                |  27 +---
>  tools/testing/selftests/mm/mseal_test.c |   3 +-
>  tools/testing/vma/vma_internal.h        |   6 +-
>  9 files changed, 107 insertions(+), 163 deletions(-)
>
> --
> 2.50.1

