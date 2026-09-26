Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BF36C98332
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 12:41:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE3C76B008A; Sat, 26 Sep 2026 08:41:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C943C6B008C; Sat, 26 Sep 2026 08:41:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B84F86B0092; Sat, 26 Sep 2026 08:41:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DCF76B008A
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 08:41:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0AE971C33E6
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 12:41:55 +0000 (UTC)
X-FDA: 85255875390.12.E1FAB5D
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5832F40005
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 12:41:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JCleUSOB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790426513;
	b=nyg8CmS+vEjwKb7TPo/w1nH0irqPHT8S4xKcVh5I59er50TY2Igt2l5M8ZNTsF/kRamVfQ
	HDE7pi5fkCJOCxLu0eMJRvXG/mAdoD9jwMlfgPStVeUwshKgiNzFGXgjNqIfGRXag0gxjn
	jklkFzf6Gt0dvegcetcrHcgXuthyj40=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JCleUSOB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790426513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=W2zTAQUGUmuhZJVF/v4ua+yizjtFuipihK2DMp9YoGo=;
	b=ObgFoh2wi6Mg1sP72QMTY4Ss0m98d0gZzIzl0XuELOaX+g+5oxj7pMs2dIF22AxHbLNcqE
	YzTjLR3d4OvWuBNLifqje7pCcC4FXA4FdWocQdldfm+NAUSXhySmFMXA/jgH70ZppzwAQ8
	eW5eamMXE2NE6SAotQwwrFa3w6cnLHw=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccb1a98dso1051143a91.0
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790426512; x=1791031312; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=W2zTAQUGUmuhZJVF/v4ua+yizjtFuipihK2DMp9YoGo=;
        b=JCleUSOBoHDnKmm5zEY1HVdepIL1EpXgHmfArZO9BvhNV5eloNyhAfkF7WLy0g1mj5
         sQ0QdIzDXItPfwU2htvmT9siWjqBuxco6T0Y/fR21Hh0bE2/WMCgvKzzLbX8ahfSq0kh
         UB9QJnVJ/69Lf6zADPw3Y0jQH4ae5qawT8dUBMJE7FdyorZhhXodnFjKNXMpLZvHewlB
         MP+NrykbuNhPHV8RhusWoP9VTOra+XdwbLC61cK7hxS8sHPAhHXBKvriRP+9PUuE5w3y
         4HCoWcXrK96B9aC6c76gbGkcawK/qwF7vKoS9kmCXq1RYVW3ml8cpbxVAY5PmdSDvh+F
         m/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790426512; x=1791031312;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W2zTAQUGUmuhZJVF/v4ua+yizjtFuipihK2DMp9YoGo=;
        b=LdTmEEQixAhVA74eEEdGV58oPdJclJTyLYO8wgHLmH6tchwkf9dZ92shWrMPhQ21uz
         U0F5KVJzAPyioL5BBZN07jL8OfrKGzQunUMBHzzBrJA/P/B3gpR/WgO/Tj/DqxcSWhFv
         HZeyPka2IhAShdRJTHUEcCj4IHtCuiFj9/z12qD7/eI/HxxeFfSFuS1RGLDevqfU/K5r
         NsG+hxwHF/Tp8QyYnT4QQj/ctE8kRszNqc05mStxC8nafk6Ir/cxvaPBfh+zLZ6zvvrl
         GSYnWe9hzGcJ2iFvnBG3BI3Q9SIh7dKnzyRwelCHIysoUkF7brO3jKzKFwW5OJjE1NtA
         AACg==
X-Forwarded-Encrypted: i=1; AKwUvBzc2BjT/3eqh4UJzo6vCawP7vKaTxXRXEER08hwm5136XhuQ9eIwZ2mvUoNfsP8s0jbvNLKwoHvyg==@kvack.org
X-Gm-Message-State: AFq9FYJVp98dLq4ysxhgrPVBVDc00tkdxD++v4ONaurqEA9rDD6Ssv2k
	VTCDCdRmMatCA6Wwkrbp4pgi4VVYmTzTprDh5sTF3wNu/1UAm7ODsMI=
X-Gm-Gg: AYBFou2ngDd7Ys8MxyU4++F/TiEI/ajySP4UsgSZx8vxWmU/9mTz3AqoO6tHLN0h2bF
	FhpkEeXKkBz6J3yjLfAkvB6uzAv5buW7FFN9a2LzQSKoRb/naCeTw8Y5+qI3606D/nYt5fjmtHt
	kMLlElFtKu9cp+lGIEJil/N9xwXgeNcZcfnXs2Bq3pRx600sQTvAKkwagrwcRzU+em9jZpIF2wR
	ndzM8dIyPdIJdc5Z4rxS5+dTEWs24ebxGW+aZnEgO6wnFggFvDR64Nt8dVNQmOVahsXI5IOdW9U
	uGggnPsw5kC5cVRgoT1EN31togXDfI7pyo5wCbug24/XYNS7MpJ+yAd/Y0NaNOWldf1jg5Kjds7
	JzDw6l1AxyI98glEyWv6+0DL7BfVuiJsg+aru6zTvBVcqfUwiQxGkCjne1Z9e0viwu4Voq25pFA
	MveW0OSS1TwLpmSc9QFsYWw61wN9ZWnxgsP/TnZSxSYndaEsn9mD0Llma8ixjkfa39prKhF4hES
	yjT62D6HUEaRHMpRfaTcyYbZg==
X-Received: by 2002:a17:90b:4a87:b0:3a0:a18e:bca0 with SMTP id 98e67ed59e1d1-3a0bb60e052mr3893421a91.31.1790426512107;
        Sat, 26 Sep 2026 05:41:52 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([211.230.25.193])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0cd1c4ec9sm5965212a91.16.2026.09.26.05.41.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 05:41:51 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org
Cc: peterx@redhat.com,
	surenb@google.com,
	aarcange@redhat.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	mhocko@suse.com,
	shuah@kernel.org,
	kirill@shutemov.name,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: [PATCH v3 0/2] userfaultfd: clear the inherited uffd bit in move_swap_pte()
Date: Sat, 26 Sep 2026 21:41:43 +0900
Message-ID: <20260926124145.2878520-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: k3a19scncsf517ewf1yzt1yepyyiwezh
X-Rspam-User: 
X-Rspamd-Queue-Id: 5832F40005
X-HE-Tag: 1790426513-890591
X-HE-Meta: U2FsdGVkX1/UnDe7C0d7ZvHkBdJkcIk47GX/giAoTID1AFpVi4WyhGk3pkJWBdlqhWXQZ07Wv3ZAAhdC+EUfNcaAVewA+COeQKzEpciVEXOIuYdR6TcMiEKvEcp83rOQu01grLXQcQcC6JqEA7anXNXGx5SW3ElGKqzhlJglPCg/6+PSqKp+AcW0xDTkFaQ5NmVVzWUQWKGS5XcHi8R57NR9UQYZoTteFKAcWCbixULFgUxSqrnvfqOoWFrVIv0D7g5SBq8DSLadzg1c08a6TtsDo6VWsuQn82IxpQs6Zp9UIH8gew8YXM8X499VqahKJIEg4I2pIs+4k0KctU+A2VbkJpFm/8pjyuZeXW3bAL7uz5asOZ4yyTpGaghIR7gM8JgnR9glvyXZz+VwbS1OnJMpCxtEzEm0jjldlJtVV6Ave52mncgPkPzbZM/9hbMTTQKVVSFAiQg06OztjdgkNO7QLT45mg9xpLdv+O1FHqPFRIsSaRt7U9CaaDdWmqbMcQZIjQ0OpZU0qAq6hBbWkoszqQmxQFWByPurt3GO8RKPAQnsdpA9ryNZFaNoUNsR5ylU4voPCoUdpwBArvJkEz6uk9o1e9QDNlPKycA4NveKCSrJQ/OKH97SPVYVCQhn9IGU4bq7V+XtAicdLwIXf3oBM2Nswp6RCs2uj29CLtk9NSMmVGPvG2OcC+Mqyi5r1XHIhzf3UqGSfxY/qsavXY0/rddJp57bZ07ZyhBaI2r4vrHi5jYnQA5GL2F4Or3ruWcihd4rRiC27fgWWPy70dtxgkOXgNxJHJnVaTl8CdzO+nh9DD5XPXSXQBZ19XejacYXQsrcUfdbLKc8gyNJXt08x3R5dVAkkq3hVRoIuyxYq7MWFhlDnhL4mFBlLGeYSVm8DpDWt10OWUUJNZ3nAsR5Y0e3mNFypogCAL9UfmlDeSyaVUpRwaLZexD5TeRHGUv2Dj/FXdISoiqz44o
 MCTyBkw9
 pJr0u0aQBjAxpGtKmVrpCe++yrfdq1APN25Kii6iPCJd9CxprAxooXm74pMwEtQSk/4mwxkIQxqjexViiuT5F2yU9A7xHSa+eZ4wsWnFzS+JPR0SfhSrW+dVaRECJgyz9fZqdpZ+t2DXKuH8n4+J3ci+0u5Zgh1PKdcYc9iLAKWVFnRy+VMrFtDi+zc/ynRzgkaSm0EsJH+j4Z4xn1b1qRSrilZUyu8jdEBWNE8hHWrdL04Q1Yj8TLyKT84S2wJhdngSsfNkW6+xUSx8D65rMQNgnEt6Sc40sNPbgRfYbDs52OrA8JHcYvzrfl7bQzxAMp10i6rHzalrnUdfLE3keIDoZFuP0Bkm4HYQPiF9BZCv3YwZ07FS6mc5I2tDE2FQmb0nXnWmsGz2dTAm9CNqYakYmNZgLUF00agMzz40tI8+WyAH3sbuxsVfFwgNLiyeF0VFyX7LgVsyWJHBXakyoOXFrbfSBbCLXJ5xBIkVtU7OvKaJG3hKAmf23NPc9Nd2ow0Nt+2Ux5kkd6PI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

UFFDIO_MOVE on a swapped-out page installs the source PTE at the
destination unchanged, so a uffd bit set on a write-protected or
RWP-protected source lands in a destination VMA that was never
registered for either, and nothing clears it afterwards.  Patch 1 clears the bit, then re-arms it if
the destination is RWP-registered, which is what the present-page and
zeropage move paths already do.  Patch 2 adds the tests that catch it.

v1: https://lore.kernel.org/all/20260919004630.1159895-1-donggeunyoo.kernel@gmail.com/
v2: https://lore.kernel.org/all/20260925042907.2330519-1-donggeunyoo.kernel@gmail.com/

Changes in v3:
 - patch 1: describe the userspace-visible effects and the backport
   (Andrew Morton, David Hildenbrand)
 - patch 2: drop the MADV_PAGEOUT retry loop (David Hildenbrand)
 - patch 2: add an RWP case (David Hildenbrand)

Changes in v2:
 - patch 1: clear the bit unconditionally (Kiryl Shutsemau)
 - patch 1: rewrite the changelog for readability (Mike Rapoport)
 - add Assisted-by: LLM (Mike Rapoport)

x86_64 defconfig plus USERFAULTFD, TRANSPARENT_HUGEPAGE,
PAGE_TABLE_CHECK_ENFORCED and a swap device, under QEMU, on
6812ce4e4379:

  uffd-unit-tests                    before   after
  move-swap-wp on anon               not ok   ok
  move-swap-rwp on anon              not ok   ok
  the other 103 unit tests           ok       ok
  uffd-wp-mremap, 38 tests           ok       ok

  11 unit tests skip on both, as CONFIG_GUP_TEST is not set.

  pagemap bit 57 at the destination  before   after
  swapped page, dst not armed        set      clear
  swapped page, dst WP-armed         set      clear
  swapped page, dst RWP-armed        set      set
  resident page, dst WP-armed        clear    clear

  MADV_COLLAPSE over 2 MB at dst     EINVAL   0
  fault on the moved page at dst     WARNING  none

Donggeun Yoo (2):
  userfaultfd: clear the inherited uffd bit in move_swap_pte()
  selftests/mm: add tests for UFFDIO_MOVE of a uffd-protected swap entry

 mm/userfaultfd.c                             |  1 +
 tools/testing/selftests/mm/uffd-unit-tests.c | 84 ++++++++++++++++++++
 2 files changed, 85 insertions(+)

-- 
2.53.0


