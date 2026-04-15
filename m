Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAE8EF428F5
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 20:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BEE46B0089; Wed, 15 Apr 2026 16:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 570306B008A; Wed, 15 Apr 2026 16:56:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 437DD6B008C; Wed, 15 Apr 2026 16:56:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3089A6B0089
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:56:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D33C8160612
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 20:56:50 +0000 (UTC)
X-FDA: 84661999380.13.E32C44E
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf16.hostedemail.com (Postfix) with ESMTP id C0D4A180016
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 20:56:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h9FnKW8i;
	spf=pass (imf16.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776286608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JqmrcX9qSaqHr61SrWlzMf7ZmFlrG/fsUaqnrdHct58=;
	b=Us+6XNIpsuMHHW3HS50wDeu8gMsE8zmubAjkcSy2PuqJFb89+Ntk5+eA0xWxMXSojNLbXp
	seH2km0lnBI6SzHV1fqOY4XXebPz9J23O432uJ7D8Ghqqk+YNXzAkKy/cbMnL12SKdgvnt
	yXOOg+LR67o1PHLESz6Sp7AB0KLH11k=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h9FnKW8i;
	spf=pass (imf16.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776286608; a=rsa-sha256;
	cv=pass;
	b=y1eE9tOaDcHg8mnBXGviBOCeyFstJVTgFM5JIvmMaxy8zEt5fwXT3nZm4N3a0f2df1zsUL
	lm0RgH6nft7f04n95pvtQYWTRF1a++0De9gy2y1rfCOUsd09klfq3qc3GAIguTgqF3Idl4
	lVSLxGw3Vyyunx189u9mKxHRUYMOQQI=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488879dcbc3so3885e9.0
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 13:56:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776286607; cv=none;
        d=google.com; s=arc-20240605;
        b=ds86J3anpmJ4nVzvHopTdq/7ksqHfvtEegJ95pO5IRjEDk4l4CrTL1PtOX0zMsNNvB
         tQ9dL8g0VnN7XZie0V23IcUiqqPPQDQEBjkiB8vjGYjiqCOVAqacncNjrVHeqcF9C+hf
         fWEeGM327IncnFX4VVCGIy6Q733nbPrxEHdluJqWRjO44zUSol0IElom/+zmFXEcpFG1
         y+EDJMwpCqpYGxp34UTO/E+DrPeGa+8EzwWCKc9vC+SJ5nBIHHhZs6FFVq+tpbPZUrAV
         fVyouD/snnTUYorc0vhhYLQo8Q6ItFwXFB0fkEVvOuyyB93rVIHjhQxbdwCBCpJyoPKx
         3/Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JqmrcX9qSaqHr61SrWlzMf7ZmFlrG/fsUaqnrdHct58=;
        fh=dxQwZ/IK11WsmPFCvx+GTTSHwJv3tKnB2EZTyl3KfMA=;
        b=lNIikKe6fuG6PjwChQYEZ+yqBoixC+b5YvHB7MqIXiQ/fBIhOUDjhEkuVnkSaKeIHK
         lsVNjSnNW9WrXv/DBwrtAcUFCa1YcNrmVHn7PrLVeqPe9pdog7GpH/dnhbWGG4P+Dbon
         jreTuR7LbkvBZ8z0svC4mvDnKh4rqrQrF5A6GiSUIRYlUjl/atEhevkRKlZqU1MnHsgI
         tBECIuN4mppwqw3lxXL5fR6F3gWxwqOYPpH5fVPDe9O4MhyHa4+yXEiFu8D9eLqa2tBX
         SUadlZxJIBuy/MS00+nfODtb+LYvAO8ksV8QMg5R+VZPy6Cn4okX9GRVB1pKoBBpLo5P
         r/Sg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776286607; x=1776891407; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JqmrcX9qSaqHr61SrWlzMf7ZmFlrG/fsUaqnrdHct58=;
        b=h9FnKW8iUZy8/Pjbdv8vJY8ClgyXSS+zPcIGhikwoaZ39T3ZELMFzoJncDfGCLFGvd
         ehVupe/oaniTlQ51cBq5F5U+ZveuQXzfoAp9sEjs7syO5z3sgc6RnJ/qX0VYnI4SW4m+
         RBF3PZ+gG/dQJE4lF1PldVbZalgqpQqhnoDsUi8AC0QFcLXslbCwsYN8doikamtpokaj
         VgS2pL6+f25/hk+1aR23NS/hgBQLjGXysheLG4F0qM5XObBgm6/eFO1tParfR57q6Ehe
         MHkcGkroJEZ0ZOqabQNdY7iLaPGETbghyD3Vy8nu6b+0Pdaiy/x+geGJxMXPegF72qMN
         5jlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776286607; x=1776891407;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JqmrcX9qSaqHr61SrWlzMf7ZmFlrG/fsUaqnrdHct58=;
        b=C8Wa+1T8veXSaGUTvZjgFvFamVrLex2IqxIqcrqjWcCkVRRU4Y2RBSG5YJaBF4wklL
         UEpljGncXvxS2aLCJ07uq+NcB4DgS5iZNVsCs2XhJBRIZ0GrlswFq3ztvpMVo6oU5XFY
         qEHTwXYTa2HFzc2BvMH5Egg9fNfWsmeboYGCHEbK6URBYP5x1h7/U/WH1vkD6xK96lI2
         FpCk9tBX3gfGVGpM8g19WE1tvBjKURdnJmLOhSFwEsBJ9PyGIsdMF8Ec8fTxFO7mi/7s
         C9JytfXb/x2Kp1okp4xbVfyJU7LEjSkURjNhXLY9M510GmP9m/NI5ct7RH1X0FxhIY6a
         SYfg==
X-Forwarded-Encrypted: i=1; AFNElJ+yJvRk38FRpPHNX1ffL+nZD8ysqMnAxBvyzyRqo5AsN97dnesQCEnDJmEjDj9Izn+OJq7yB6IMkg==@kvack.org
X-Gm-Message-State: AOJu0YxsB7z6tk/suzFuwtg1TisjiA6TqCg/CR6g5h4J+p0cp7bJr/nU
	Fs2oSME0UlkkHoRveGdYXUnh8OC0f4Qlm6whDx0lOdY0NntXM1wtwJjdKD41Ijh+A2KSXj/2zyB
	qKerAH2sLPlCYzBMiofwKyPIw8MONYfMNNhvVMszV
X-Gm-Gg: AeBDievpUmmPXoip7sS2oxY5aoGP5OhoumLi4VhRl+waCWASCcYSbt2J7f1dMcvcNKy
	Yxm4R9BR9fP/7UgvAk6HfZ4YFRyfAUwhxp7q8Janxzd25/Kk9lYx//gWo6b+nbuv7GUJVOef4x/
	hmJSvf/AeH9I7P6Y4DQ8O681CWnSOGxZH09HKY+XR1sz52xNTlE5UF6Dq3Td8hT77qcEJi2ZWsX
	VvBXhVAejbpW2lQuhf7elzCbmDKVdA+Z3MV3aWLlWc4XA2Tonvfb04yolEMi1KYjEBTS3wMacXJ
	QBgP6PYJi/YpZ2o2sE1eroDhsq4wOhiCdqgckYwEmcrOelKYkf3yZESfAg==
X-Received: by 2002:a05:600c:32af:b0:477:86fd:fb47 with SMTP id
 5b1f17b1804b1-488f4a9d81emr153385e9.8.1776286606809; Wed, 15 Apr 2026
 13:56:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260415-ecc_panic-v4-0-2d0277f8f601@debian.org>
In-Reply-To: <20260415-ecc_panic-v4-0-2d0277f8f601@debian.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Wed, 15 Apr 2026 13:56:35 -0700
X-Gm-Features: AQROBzC_-yVQi7CjcD3DiHe7zBgEWti0V3awpLyPpMnYVTnD0d4omoeELg1sqHw
Message-ID: <CACw3F51PC0iB6mfbiceQ_Kh242FN8zdXOfTyE5Pa_5+gjTPPGg@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] mm/memory-failure: add panic option for
 unrecoverable pages
To: Breno Leitao <leitao@debian.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xmimhp4u75nz189wf67gu4kw11qe3izr
X-Rspamd-Queue-Id: C0D4A180016
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776286608-799169
X-HE-Meta: U2FsdGVkX18iLltkeuPfXLoAkC3mzpFZDYZmsXlM3B0J5Wz+V7PwQurAKz+onT8uLgqF6ij6AB5FlqjRkkEvwnawlaNiusK8Z2Md8NEyJDT5aZEBEBdQFTn5AS1XUcSrVUiCzS5zqkXSBv42ERIiG7XGx6zvIzIBxz71ad0/eVbx/PfHBhV5m6Wajice8S46IrDAfq4vGMfEAOLblNmp3X5+L1MCVX0qOTL4GjTwIVsuG0m58Vav2B/6uY+SAIdTiQpedKDnI3riK+NEa+ZrRY/83zRX0xgDvOkBZVQnWNigM+/aeNPM+ydm8fb43Juo2XOf5/QhxJBmNGJRHu5fT4Fj2kwgzvJbZ+G0VmlHvS+tL2HHx7etRCo+nJ9a2D1T2J5y8Kkb1y8ZNjX7QuDjofs/wEbnU+6C2K40tFBtc/DHm5cu47es9A4J0zWYf1L7hWRPiVN2ua+862GZ84gUvGTYoMrdzLbETxNund8C34p0nJfS1RkZ/w8ZyORwluFvNfgsSjjtgilrbMot5PVK/rrBYe8l1w95ZJcgWVa8FAbNXZV9mYIiH2tRGky9NcNemF2TRuHmU1LV4E9peOoGXOYjs/93fhgzw3z4lS7eUOozAKzMI1gsvdhgxxNeudSvn7Alct9IujiMIi2MOxG+bbusdJFeBt2a+ItiS3VMvhBcekY2D7xFPxBbMwZhMooyZhXKRSqbVQxbQ4bcMsSWCivu1PnB2Sb3nrjcTTIXF38OrnzQQkbBYn2dDSgFK36hYxJwqjWUtd3ZeBF/fYEFYbduW3eBJJ0u1XOOWMt5p7q6LEae2YCwpvIE26QbuAeP+MBfjtwT+07gHtiuuJN0L0jOcJ4KpSMphadJPHgy/ya7vkJDtkzEl+C53JRBiJ1Dwitdjjl9neVFElWdU154CM0p7H9ycCvUzmZ/3bw4eeU+1tyuXr+YxNCjdVqhTC9/lHRYzQk7pYVsR5ruuFJ
 qRNsjKUT
 Awv9urrhorTWf8fLZbvJtx5nI4VU08XpbBpquVI9l6TByYk2RnwWpD0kCU+rpiMKUiJrZ4eyr0TIWLdakSInGxH16BHU7+XSTU5Tv0/HIKDj/IWyRuRoNh0HNyvFVH6h1arT2cRlubcE5sm82Xh1cC7O3zuyOD5OGz12VkvakmMiOFVJjiSTOAESgSXA8sQkEviHZSBYfGobJVpgEl1Tt3LTcDoSosBEmfD4KDRTCGFlIXD9r9Iwf8ayHG5OtIuDx5eH2tePPzd89+GwTmPVN43lzzjpSUhpXykw7d8vPnmwTPCIFbteYPgV8GxSkwrtmX3G9RdLTVGSCiS7f5IksqVJBE4fxyZduTWjtt9jDkZYt23yPMc5yq4aziJDwj8xGwcQjdlQNP0GNlYxP3d1G9tiPETnDz84ipAKloP5daLjV0GRVYJ0ArQE6ISlvy4cb3nV2aNHj+0uza/FSzIyhwXGu0QCCiCaF395SiynnCJQeTNxKHjsRKnpTlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Breno,

On Wed, Apr 15, 2026 at 5:55=E2=80=AFAM Breno Leitao <leitao@debian.org> wr=
ote:
>
> When the memory failure handler encounters an in-use kernel page that it
> cannot recover (slab, page tables, kernel stacks, vmalloc, etc.), it
> currently logs the error as "Ignored" and continues operation.
>
> This leaves corrupted data accessible to the kernel, which will inevitabl=
y
> cause either silent data corruption or a delayed crash when the poisoned =
memory
> is next accessed.
>
> This is a common problem on large fleets. We frequently observe multi-bit=
 ECC
> errors hitting kernel slab pages, where memory_failure() fails to recover=
 them
> and the system crashes later at an unrelated code path, making root cause
> analysis unnecessarily difficult.
>
> Here is one specific example from production on an arm64 server: a multi-=
bit
> ECC error hit a dentry cache slab page, memory_failure() failed to recove=
r it
> (slab pages are not supported by the hwpoison recovery mechanism), and 67
> seconds later d_lookup() accessed the poisoned cache line causing
> a synchronous external abort:
>
>     [88690.479680] [Hardware Error]: error_type: 3, multi-bit ECC
>     [88690.498473] Memory failure: 0x40272d: unhandlable page.
>     [88690.498619] Memory failure: 0x40272d: recovery action for
>                    get hwpoison page: Ignored
>     ...
>     [88757.847126] Internal error: synchronous external abort:
>                    0000000096000410 [#1] SMP
>     [88758.061075] pc : d_lookup+0x5c/0x220
>
> This series adds a new sysctl vm.panic_on_unrecoverable_memory_failure
> (default 0) that, when enabled, panics immediately on unrecoverable
> memory failures. This provides a clean crash dump at the time of the

I get the fail-fast part, but wonder will kernel really be able to
provide clean crash dump useful for diagnosis?

In your example at 88757.847126, kernel was handling SEA and because
we are under kernel context, eventually has to die(). Apparently not
only your patch, but also memory-failure has no role to play there.
But at least SEA handling tried its best to show the kernel code that
consumed the memory error.

So your code should apply to the memory failure handling at
88690.498473, which is likely triggered from APEI GHES for poison
detection (I guess the example is from ARM64). Anything except SEA is
considered not synchronous (by APEI is_hest_sync_notify()). If kernel
panics there, I guess it will be in a random process context or a
kworker thread? How useful is it for diagnosis? Just the exact time an
error detected (which is already logged by kernel)?

On X86, for UCNA or SRAO type machine check exceptions, I think with
your patch the panic would also happen in random process context or
kworker thread,

Can you share some clean crash dumps from your testing that show they
are more useful than the crash at SEA? Thanks!

> error, which is far more useful for diagnosis than a random crash later
> at an unrelated code path.
>
> This also categorizes reserved pages as MF_MSG_KERNEL, and panics on
> unknown page types (MF_MSG_UNKNOWN).
>
> Note that dynamically allocated kernel memory (SLAB/SLUB, vmalloc,
> kernel stacks, page tables) shares the MF_MSG_GET_HWPOISON return path
> with transient refcount races, so it is intentionally excluded from the
> panic conditions to avoid false positives.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
> Changes in v4:
> - Drop CONFIG_BOOTPARAM_MEMORY_FAILURE_PANIC kernel configuration option.
> - Split the reserved page classification (MF_MSG_KERNEL) into its own
>   patch, separate from the panic mechanism.
> - Document why the buddy allocator TOCTOU race (between
>   get_hwpoison_page() and is_free_buddy_page()) cannot cause false
>   positives: PG_hwpoison is set beforehand and check_new_page() in the
>   page allocator rejects hwpoisoned pages.
> - Document the narrow LRU isolation race window for MF_MSG_UNKNOWN and
>   its mitigation via identify_page_state()'s two-pass design.
> - Explicitly document why MF_MSG_GET_HWPOISON is excluded from the
>   panic conditions (shared path with transient races and non-reserved
>   kernel memory).
> - Link to v3: https://patch.msgid.link/20260413-ecc_panic-v3-0-1dcbb2f12b=
c4@debian.org
>
> Changes in v3:
> - Rename is_unrecoverable_memory_failure() to panic_on_unrecoverable_mf()
>   as suggested by maintainer.
> - Add CONFIG_BOOTPARAM_MEMORY_FAILURE_PANIC kernel configuration option,
>   similar to CONFIG_BOOTPARAM_HARDLOCKUP_PANIC.
> - Add documentation for the sysctl and CONFIG option.
> - Add code comments documenting the panic condition design rationale and
>   how the retry mechanism mitigates false positives from buddy allocator
>   races.
> - Link to v2: https://patch.msgid.link/20260331-ecc_panic-v2-0-9e40d0f64f=
7a@debian.org
>
> Changes in v2:
> - Panic on MF_MSG_KERNEL, MF_MSG_KERNEL_HIGH_ORDER and MF_MSG_UNKNOWN
>   instead of MF_MSG_GET_HWPOISON.
> - Report MF_MSG_KERNEL for reserved pages when get_hwpoison_page() fails
>   instead of MF_MSG_GET_HWPOISON.
> - Link to v1: https://patch.msgid.link/20260323-ecc_panic-v1-0-72a1921726=
c5@debian.org
>
> ---
> Breno Leitao (3):
>       mm/memory-failure: report MF_MSG_KERNEL for reserved pages
>       mm/memory-failure: add panic option for unrecoverable pages
>       Documentation: document panic_on_unrecoverable_memory_failure sysct=
l
>
>  Documentation/admin-guide/sysctl/vm.rst | 37 +++++++++++++
>  mm/memory-failure.c                     | 92 +++++++++++++++++++++++++++=
+++++-
>  2 files changed, 128 insertions(+), 1 deletion(-)
> ---
> base-commit: e6efabc0afca02efa263aba533f35d90117ab283
> change-id: 20260323-ecc_panic-4e473b83087c
>
> Best regards,
> --
> Breno Leitao <leitao@debian.org>
>
>

