Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D668EFF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 08:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7DEA6B0088; Wed, 29 Apr 2026 04:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2F676B008A; Wed, 29 Apr 2026 04:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D186B008C; Wed, 29 Apr 2026 04:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF4586B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:25:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E935A03FF
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:25:53 +0000 (UTC)
X-FDA: 84710910186.02.AA223F2
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7305540002
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:25:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=gOJmuOEQ;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777451151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xevsexu3UbZ8Pxbz/hjTHebmPREf3aJf4+wnjlsTUo8=;
	b=hqXX+VqHQ9QIomDHcoFSABRAWY6m/qDAf5bqZ+u91zGQabd71Z1umFxQHGdlH7WreLlzPR
	Yl6TIf0kLSXIX15CNX7vMMtb7BjI0u9YO8j4uxGFHlR9xCfXJCx1PPZy6OY0zIsUzos2Ku
	7j7Y7yUCsZHBTwR02YV5Z6oEcv1j2A0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777451151; a=rsa-sha256;
	cv=none;
	b=1P9lTX9wvs5AlA+cD5RMEjwibhzqmIbc711eG3zxRvHaxatKnRF7aoh7xR/rc511m+3Vr4
	bH+HCOk6Xx2vYbnwvGiyEiIG/oodaP5jJNPnHTSDFIfEsD0HmcJPKI0EVBkUU06Na7znY5
	xtP59/yoluK1iJc51eXXaCGAEhIdcQo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=gOJmuOEQ;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-43d0deb7ad5so9992472f8f.2
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 01:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777451150; x=1778055950; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xevsexu3UbZ8Pxbz/hjTHebmPREf3aJf4+wnjlsTUo8=;
        b=gOJmuOEQtV3RTxW7YuNdqzGeqU+3JFPYONerZhifoIPFYOeppb3GiUNiw9MJ2XEa43
         iTg9NZw/zbzGRTzzsfA34fZMswzsjI1gaNlgRSHzcBSp0iYTAvvZHHOlIGhSRkZy84t0
         dY0Q9RpSNeZq/g1Uli2nX8eavIm0JPDW0LKZbon/mR8Gmqi5dH2TH5Mnhfrxh1pEDbCN
         LFdt6v2FJ/REm9QOVRQWHrkImhVIriHt6KNIvFFVUs8nGZgXlUdGpob//8Tsb4RFVGS+
         6HPkpoOUH2Sm+mpcED8G+4rb+lg9O2ZpHQRdAqWS6TwYuBeVkSsyPNTJ97x3HHp6mlLZ
         e3Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777451150; x=1778055950;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xevsexu3UbZ8Pxbz/hjTHebmPREf3aJf4+wnjlsTUo8=;
        b=RV38qDu1LboObFyk+9XgnUrMMtQmjav5jvSayIcrUtW2BmZxXg2TN2fR8HftLlYnR1
         hAV3PZJPglU4tueefQYQmoWqxjEGU+/P8j0ZFN/h3lFJ9LTtjIxVpibBHCPCw6pGF9Bo
         moOtdn+fkKdLwzV4EPvHU23LpN2QiXWI6Fajd0HNx2lX3RhwCbpgWfonEgEsOp4tuAik
         NzWnJaQyz4tJp2fjkVWfr+NY6I09j3TQuJZqct5GIp15RAaj77GJcucQwriHfLZQvx6X
         0cN/U28InoZMsPFXYlxKaJS0QbThHUNVC0kmpwYqclJMDvQTE7iSBgVk4A2DBcFjdI6c
         ePXg==
X-Forwarded-Encrypted: i=1; AFNElJ+/FQPbD147PBDM7PhkXTdyFA6Ja8WRYtK3r0fWfI6peLxnHbFNdyhL5rD/e70xF4SmbRX4NyvmfA==@kvack.org
X-Gm-Message-State: AOJu0Yz7rVRz/7lGnasmRlJbZ2u8UGPZAI3jDm8F+EPtDiPWnE6F4JYI
	tsyIpGIqVqfWd2a0SITIediHE2msn214kzgY6KvV4SevMLuND3hl5tZvBJRpGieIGCE=
X-Gm-Gg: AeBDieu8nUb9xUsfWVcB2+qsXaV5m6oQPpkFvavtrxQON3PLW5f9S4tsbDt3TFF3IZo
	2dCMvDrp2O36Bm474Nv1aKiMhttBArfOsmSl+xjvyLcoPK3iY0CUAa9TaV5f1fMW/OB9h09iH1u
	t1xcsCqG+yuzVWV4dLFbjKw7oJoOgmoAJTXWSA45CAB6o6SevlxefPlKj3XhPgL1aD9CARFMd4C
	Hugy6UvikELWqSsxRb0d50Shsfci/woT0NkmswfZtV0rroGBGEcfALFjXD6O0ZH/tbO2n4WuAHB
	kZ1i50bvcB3WqiGJJmZ68a/DLAPoFhiyjTg0C++UDT4n2y17TXRxQtGVaei9LYP367rvbf+4kEA
	R0+0FG+hqut/cKQ8J75QE98pwvu89g82oFjkIRWpNdV3yQmQW2hg8Wa4Xq8s4XO4uCJARMz3yI5
	auPZctmc7FZGqGcB3vcMnqb3q7vVQVbyC2yBuVlpp8/th9k1qZ6gzj4xV40g==
X-Received: by 2002:a5d:5d0f:0:b0:43c:fc5c:aa0b with SMTP id ffacd0b85a97d-44790d12a8fmr4412927f8f.42.1777451149563;
        Wed, 29 Apr 2026 01:25:49 -0700 (PDT)
Received: from localhost (109-81-86-177.rct.o2.cz. [109.81.86.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-447b7217a57sm3805010f8f.24.2026.04.29.01.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 01:25:49 -0700 (PDT)
Date: Wed, 29 Apr 2026 10:25:47 +0200
From: Michal Hocko <mhocko@suse.com>
To: Minchan Kim <minchan@kernel.org>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v1 3/3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <afHAi0E11D5sg_9y@tiehlicka>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-4-minchan@kernel.org>
 <aesiYAumkLCyedf0@tiehlicka>
 <aevzbx_Pk5Cu5exa@google.com>
 <ae8KD_Tq0t7RvUy1@tiehlicka>
 <ae_dRZ95dCDTTxaQ@google.com>
 <afBbRUaGnE8WZIkY@tiehlicka>
 <afE2xchFRh2xARBn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afE2xchFRh2xARBn@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7305540002
X-Rspamd-Server: rspam04
X-Stat-Signature: kmz334js4uw9q8x1kitgrqfjtwdnsdgs
X-HE-Tag: 1777451151-507822
X-HE-Meta: U2FsdGVkX1+V8pgEw+d4Pynb9poirpBa24A80S5mKzXet7AIrX1YrqI4O/q50jVeuWwaTiPYaJ2uekhWtM04yYlA1mwptbJZ77yJnM8hhnB7I4EhT+qsqAaWQpJexFrNUrSL6RkRIUBqgmA2G/ygh1l/TnWwGWwTds9rNtt4BLvhURqlM4v2aeJVatU2OrvAPlhB0m+/tayESXB8A1kgB2PIzS+FY5mU63AZS9+2VJBnYx3/W2EW6C48mwX7jeCDm01b9sVHo3jcubYe1xG8+v1J1OlADQeDD7qbMVU8EFHEX3N4hC0rDr8UDCk23E1WkBzTClwq/a4w/+8D9atHrCGU/kmcWtIUSCZkjaSwoHEErbR8nFZYmN5NeYdECg14bWsFgu9kEjw27uvv+h180uzwaSDLeSoZYRBPf2H3BK3WOYKNmAsNvshlBo3zoW1tSYZuncrNgUngqsRe9cJQCW4jJJLHbS0Y1q2JJxPDD5MweGsF/Qcnd3Y5PEEFEq4/IlORD5ZxwjK4lGIBTxXPejiXUnL5D4z38oJ/t1JkyKblzgCGY2Mwggkd6wyzaUf7aaEvE/GeWffLnC8i0+MgzauMFuCsiDxVpUsoehX/dtSJj8Hdo9ocIF/TAEbhvOC0IXa9nDBmL8y+uR0wK6c+ggshaewAtBwlhVzwQ2/lzb7ZZkV+GYALTcizy7Md7oethp0e4mQTwmSla1bjq3jR/FT+zB3426a+Wp3pU37umsgN3gzuHIUd6ZYdnSkdffxnP0V1anmTHAtkf88N74JwkVAgwH8poqqz0xvHJ6AIkCYMUF+OmMe/8tv1+HZvn+otSBjO5QUsXuOKLIWxO5vVxNHeaxNsNYnHO/0PohLcQYRECZT2ToEEEaXad1OVTXcG0UWeOMRMz5SLK6Nv61cfi5EPb4J8oPG41Lf4ipD+GLfo1ShFYj0g0tfVCJM2NwF35+ouDPGNuRhIcmXTd5j
 DpQ7rgPX
 5kb/ktDtAEyfTju3T4VNGmntEvyXnuD8RaSJngsozHI34FKhj/gkXtR8tzNpngXpOFM8YcRT9L26IxFavB8DoAXYoEraFK8O/j1/fKhw70IcQ4hKeh4CoIaOhiVQjckhwzYoX44ht/gMX58j8NhRugMFIxH7whTX2oI02ouUwYg/+nPrMj+Pv7+muSiHWCRzqaL/PBF1Tz7LGma3a3QYrA78+nTlLQiTgEDq4YGjd86/7cDvaZDTta9P5RZsA8PgbwbGEidA7f3GLbV3CX6EtQ1Ed9MVi279FRRfE1dNGe5nIVLZ3YTZT7I5czYmMjjrIxosaV1Lyk1PhC/lggwdPmjDHP9TUlqxVf4kj+MZBU6CQheozf5t4AG/r7amv5Kaq9ERnzBAtetULpnb+8WVmtGPsUVaqw3Jx7b2XOHqINiCB5jW05wr3zfG4mURR1IztJFxyFq9FETjfINw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 28-04-26 15:37:57, Minchan Kim wrote:
[...]
> >From be4bd22a100ed6be2d1d2599ddb9da04043143eb Mon Sep 17 00:00:00 2001
> From: Minchan Kim <minchan@kernel.org>
> Date: Fri, 24 Apr 2026 14:27:08 -0700
> Subject: [PATCH] mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL
>  flag
> 
> Currently, process_mrelease() requires userspace to send a SIGKILL signal
> prior to invocation. This separation introduces a scheduling race window
> where the victim task may receive the signal and enter the exit path
> before the reaper can invoke process_mrelease().
> 
> When the victim enters the exit path (do_exit -> exit_mm), it clears its
> task->mm immediately. This causes process_mrelease() to fail with -ESRCH,
> leaving the actual address space teardown (exit_mmap) to be deferred until
> the mm's reference count drops to zero. In the field (e.g., Android),
> arbitrary reference counts (reading /proc/<pid>/cmdline, or various other
> remote VM accesses) frequently delay this teardown indefinitely,
> defeating the purpose of expedited reclamation.
> 
> In Android's LMKD scenarios, this delay keeps memory pressure high, forcing
> the system to unnecessarily kill additional innocent background apps before
> the memory from the first victim is recovered.
> 
> This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to support
> an integrated auto-kill mode. When specified, process_mrelease() directly
> injects a SIGKILL into the target task after finding its mm.
> 
> To solve the race condition, we grab the mm reference via mmgrab() before
> sending the SIGKILL. If the user passed PROCESS_MRELEASE_REAP_KILL, we assume
> it will free its memory and proceed with reaping, making the logic as simple
> as reap = reap_kill || task_will_free_mem(p).
> 
> To handle shared address spaces safely in the auto-kill mode, we bail out
> immediately if the mm is marked with MMF_MULTIPROCESS when
> PROCESS_MRELEASE_REAP_KILL is specified. This protects existing users of
> process_mrelease() from behavior changes while preventing unsafe reaping of
> shared memory.

Please explain why this is a different behavior from the global oom
killer and how do you intend to deal with those mm shared process
groups. I am not saying this is a wrong behavior but it will be hard to
change once in place.

> Fundamentally, this allows process_mrelease() to trigger targeted memory
> reclaim (via oom_reaper infrastructure) quickly, even if the victim is
> not yet in the exit path, while reusing existing race handling between
> reaper and exit_mmap.
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Other than the above looks ok to me.

-- 
Michal Hocko
SUSE Labs

