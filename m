Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E1EDC982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72C816B00AD; Fri, 18 Sep 2026 20:46:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 703476B00AF; Fri, 18 Sep 2026 20:46:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 640446B00B3; Fri, 18 Sep 2026 20:46:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C0E76B00AD
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:46:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BBAE8140153
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:46:38 +0000 (UTC)
X-FDA: 85228671276.09.5B5DBD5
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0D3C740005
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:46:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iUcFadnx;
	spf=pass (imf27.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789778797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QfM6UCZtzoFFrTjdj14/vVJVL8UR3GPz2RxKfZlHRaI=;
	b=lNjWgHWvMg0RlDW0jROcFKbsGnMPVIUoJCg2LInVNcLoHT/s9jqT5WBKR9zdHu3PE2YsIk
	QeEIBpqxy7G6gt1mqYSH9SZ+NCsf8SWLPPyD9SIJUzOlfg4h/foPYg1nQH/g7XQ7WIINrQ
	lNeGddDfeA9sUoV4xaQzofKBJm3C5ks=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789778797;
	b=CVcki1UuUG2o3l7boDbVkJPAOl5xbkjXKB+c/HL2CMFNSe1wCmLvA0PAXxraJXsweMdNC2
	//qVeckUew8tGxAIfWiSQAOaX5KOrqEkFCe5Wmnzj0q1XRrdPY8t39UucL+Xa3gzcyd9i0
	Rk3m8TesUilNgWZveKqzFpuUUtUPEx4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iUcFadnx;
	spf=pass (imf27.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-39dbdfaef3cso1247944a91.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789778796; x=1790383596; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QfM6UCZtzoFFrTjdj14/vVJVL8UR3GPz2RxKfZlHRaI=;
        b=iUcFadnxRaCnGUeMJp8TkRZgZYjC+BFdlHOhUUygZ9ofhOPT9hBrWgsYdkUF2xBJ6K
         Jzc/VdO4JPGIUwCT15spaqZyKk3VIs5gdJSXjVXvEhJrKcpoVKFNavlEqFkf7DUrau2m
         EgMokq2U0xsaghudFra2X9FZS0Nk3Nkm1T4pBhRu7rX04i3dj/FzvgcS6W1GKFY9cYeY
         hYgiLhCyegsSCm6xQCOk4MhCpznWWm0NJL9heQ1P0WoVJiTtkKBWf9JNbA21SSkZpb4o
         Mc5pJo0VdBgwtln6Rz2WAJBF3GZqPuR5c5oYYxBPOtqFi4qhW52csj2b6yhHwGwdWeyX
         GSMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789778796; x=1790383596;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QfM6UCZtzoFFrTjdj14/vVJVL8UR3GPz2RxKfZlHRaI=;
        b=TAIKORA8pnGIQ1hu/Xy5E968wuhJWAcBKiA1WBZ/39XSOVGPuc2vkaR/SPuNi7nedq
         XPshq/LhtXtMUbJ4sZGnT+qy7P52OVZKw+uycjHzwcsV8WNnrwJM0CasRG5dSk5Ow+Mn
         op5gQCR/0DEWeqi0i4VntBTq7gUrY7XW/7AiX2YPEbAR3+UmUpJXqgggwZETZWaOHnSE
         RnXSKwr5uIyD13MCrSJZH1541EEDHcQhAzpv36tKsIxXyXsFsTH/dD3On9Ki28CpiVtb
         j//aJkuGygz5Mf9+NaovRCV2ZWUPHe5ItflfTnnMaaDame8zsUARvlmCrxCTjUm8KOwx
         aGJQ==
X-Forwarded-Encrypted: i=1; AKwUvBxIbLA9bfvvwIh9WrcMqEvSirmBBDMBYKywpjzEuC3wt0OIfaf7kMLL+RzyY8QL3PTdqTj/YWsYUQ==@kvack.org
X-Gm-Message-State: AFuF++lzBZhF3BLha42GjvtQRL1VMg3h7Ko9kXViBZ8v8y7Uu/znozE+
	Bh2I/pc5A6MshZZgNMippwAOCd8gDS310q3IeerX/hpUjmc2Q6SLgjU=
X-Gm-Gg: AYBFou1P1mcpcldZoOT8c8pcxg2xgaRHHXbEKBAIUh6HTSd4vlxjkeB4qU7WUUMA+rz
	+KLHh0kOe4DNBW+c3xfIgl3NkErGuMaU1r6IAwQH+llVGpj2j0EXtpFyRiEey/tEtk56UmchFXv
	8ZaisoBn+1N0h/G2m00ddYjDwgeoGqEH2ZZtI7CsPwQU1R9g0YToIfmQ12ti2p49CNFwwj794Vk
	W8Dd7CAbYH1NvIvMgLcJyutJQ2CaeyGGFlhKC1jKOUo4IC9lIlAbNdMnBcf6Z0s0Jvzpb12dWTK
	hFM93ddVC+S1Ap2dSPEWZjRKA/39wvE4F1ECUk7s171/4EfiBGUw3bphXoGti0uShodd00lib94
	iU+EpSgb+7MVeCLsOuoGX5/DRipkb8iMILa0TYApixpjJZ3x/XvzoeWN55CnX3TzYS4dAv6D1ct
	fWYWoaNxrU8wKuE+Vv06HdlJI1l/Mz9GBplg7P6zPglNBeqEWsFsgVSpLrtM3h0UwMf6HzynlWM
	APWy/BrfmMSDw0Di6E6PG874xFnyn/W8h/l2V0=
X-Received: by 2002:a17:90b:380b:b0:39e:4fec:d6e5 with SMTP id 98e67ed59e1d1-39e550707e6mr10838895a91.16.1789778795844;
        Fri, 18 Sep 2026 17:46:35 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:45e5:9e39:6356:6164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c169dcdsm1927166a91.2.2026.09.18.17.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 17:46:35 -0700 (PDT)
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
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: [PATCH v1 0/2] userfaultfd: clear the inherited uffd bit in move_swap_pte()
Date: Sat, 19 Sep 2026 09:46:28 +0900
Message-ID: <20260919004630.1159895-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: budg3x5pfbdeietonpwjxgj1u5xem3sm
X-Rspamd-Queue-Id: 0D3C740005
X-HE-Tag: 1789778796-51768
X-HE-Meta: U2FsdGVkX1/Um9z5C3/0o3nca/NNBeVgbiXPeDyGiOy/C3xvfgmH3juIFmiyStpQ9W+jdsMMIl8jk5hRm8SOb0kyZFFer8LHutYMN7b3Pv9xlzETPdulRRJte0sFLBGWTMtRHypCq3ko359/Qo5Tf9ap7sq97DGZm+wzhWGu/EVpEoOCbHirEpuctO66Ftm7auqV2hV34tTCpHUCgfbalOqDSngMDQtX18l2oez2Hts9IbQT/I7R5gOk8ba7bp43KVt5i7vZxMDBgtxUWAc8xY0SuBAmXlexa98ht/hTpUuIP3osH/xFXJTsfVo+FSp1paAtD2TYxyEFRCeD8qD+QdGc2DPkM57AJqDyiaNF+IIStjSjd8qXdHeeWBdT3eDQRB7DQ+1QW91ryt/nFpgZ/uyhe7ffX3x2JxEenyEN6DmYW6Kf8TT7PGM5OEB0Xs0Xt/kRvGVComj0HrxuKy6xLV+h6NjizSiXRj/ExxHBepxs2UHAmxzKjw5wGwwl4n00J1TK43tH+WDdCCPDRjkCDypLaRwv/x8sqQktmDFQZ0i6xr+t865wW2oZujMnx76ujN4owYkVgXKYqzHTBOq+Cm3SNg76kSD79kuVG25usT0TpEnFroDh+qH1sOu9lliVzIJ2funBq37UtC7T/wNXxk+kIrZBGsN0qvaBlKH4fl+CWu0texWe/JX8DlH5fGODShJQ2hvP9tFIPSRWa6eBfafaOGWDv9jXkP3TGEdmCx7GZKmO2Hf34QEreUV0PrnUd8ZRA8sd+GBL0ke0ozX1vrqPxHWkphDVfYAMfAlLadYzAYuRkrLvzzoi0n+Gfrw5ZTdnHueYYv6sQdBLlS7Snl6ylAEd9RMMIAwgqg17YPMEHJy0fvSrILm+vZ8mnjx7xsN5ENooRNyV5nl4nNkcqQMqD0EjnAsWy0JCbq2VLEDuX/56D5GKEQhU4+ALvFyrCjSP/zsh5aGNV1x3PIc
 84HXHGKR
 bYCK7AwNG2izU5rHTHp5NnXQvJZdMcikry++oxMScjcfJ1SwV8omZn2XRzQJaQdNEGEOUdCBMCdJdkRHdmi8z2QDONMFoaAOrkuTyhnhnZyWWHmHdvIHrI5c5rY6KL7aP7YzDMvRhVYVlAXlhqTpi+xiKhjEgp7mz2WMkYD3bh5rzEeTq/AbWZ8TIY8GmWUm8+uJmybbwq8rDAnr0XRfQzjkjxyiXz/LQFlq63zBckRkTSyeBGqJYUxkyMTHWKRQe50a8xk8ah9f6CtYQiTVz7Tziymg6OOcH5wr91B+8J75o8GR2mX5+ssl3xgNLsJERxa1Lu+XtlXSMUXr+idmVcSYU4C21xIpw9/0L/tjD4XNRT7BLIrRRcbOLhKIFzb5vdOBAHZxbchMM3QaMhHHPFJa6xTPs8jZS1EwiAT9KR5TVm9zdUNCOG0tskzHh86PUU3BDOicXs5zjx/UjPhhNZcoxxaZ0hxgSdaflzLh2U2nq+lQ3ifupGzITnb4rWN882DExveqd5Q2i+Y3wUdsoXgzqBK6jaBssq1Iq54vnY5SgYltyz5Wr/UTbqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

UFFDIO_MOVE on a swapped-out page installs the source PTE at the
destination unchanged, so a uffd bit set on the source lands in a
destination VMA that was never registered for write protection, and
nothing clears it afterwards.  Patch 1 clears the bit unless the
destination is RWP-registered, which is what the present-page and
zeropage move paths already do.  Patch 2 adds the test that catches it.

x86_64 defconfig plus USERFAULTFD, TRANSPARENT_HUGEPAGE, GUP_TEST and a
swap device, under QEMU, base 17e7b8eacf4c:

  uffd-unit-tests                    before   after
  move-swap-wp on anon               not ok   ok
  the other 114 unit tests           ok       ok
  uffd-wp-mremap, 38 tests           ok       ok

  pagemap bit 57 at the destination  before   after
  swapped page, dst not armed        set      clear
  swapped page, dst WP-armed         set      clear
  swapped page, dst RWP-armed        set      set
  resident page, dst WP-armed        clear    clear

  MADV_COLLAPSE over 2 MB at dst     EINVAL   0

Donggeun Yoo (2):
  userfaultfd: clear the inherited uffd bit in move_swap_pte()
  selftests/mm: add a test for UFFDIO_MOVE of a write-protected swap
    entry

 mm/userfaultfd.c                             |  2 +
 tools/testing/selftests/mm/uffd-unit-tests.c | 61 ++++++++++++++++++++
 2 files changed, 63 insertions(+)


base-commit: 17e7b8eacf4cac800a4fc89a28729df72a2dabda
-- 
2.53.0


