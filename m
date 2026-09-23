Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6717C9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 23:04:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0A3C6B008C; Wed, 23 Sep 2026 19:03:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BAA86B0092; Wed, 23 Sep 2026 19:03:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AA4A6B0093; Wed, 23 Sep 2026 19:03:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E4CB6B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 19:03:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D9607140191
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:03:58 +0000 (UTC)
X-FDA: 85246556556.22.A804B3D
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf09.hostedemail.com (Postfix) with ESMTP id F223E140004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:03:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BuH0Onw6;
	spf=pass (imf09.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790204637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IT+kPykiDUVKChmVTT4JFPPqjHccYovstoU8+/L1N6I=;
	b=3DaJ/u2mYr2kQMA+jm3twOfeyXd2Gi6+B6cTW0Vwj+jnR2g9FoJ3E1MKDXMt+9Vbo81qEk
	WwzCZAuTV9tukaoKL1/7/iK4sBfsCxFarUQXQuI3yz50u4ASEUK0kSLXkIH+t4ZDlTH7V3
	TdOvp3GjjtKJvjg/yh1qL7zjKST0ht8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BuH0Onw6;
	spf=pass (imf09.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790204637;
	b=GCbtLlHWPzWVvNl+75c+ZSP5kVfljyVzxpnyPuJJN3zw21sepw6Pbz9jOK4GbIMe1rGJqE
	hmc60lW9AlJ3fswQZjqPIXMn+mw4L1412T2x5cuVTQ5IHuDcJZtywhYiq9ms8u4/szRz3e
	ogv8eMERHxUjb07oIfty7PwcsmGTIMA=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350f89so1045492f8f.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790204635; x=1790809435; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IT+kPykiDUVKChmVTT4JFPPqjHccYovstoU8+/L1N6I=;
        b=BuH0Onw65fpscjjL4T6c4JVg/o9TLcXF98wDWIroUnRIBoKXCWxGsFR8F3p/Ey29qF
         Ms59tL5Uwyvk9Uq5DfTv6exEK22ZK1bfRYUAVLZYtNm+FADtbX5buGnFNTn4izC1wned
         se8Ypdb2SmNAz0NvDabf1ufb6ZQ3WfO5vuYcT5zTI2/gS5agmBYa8ttLydJ0WkNgefHE
         +NEeVjxvTnoMgSBdghv76d/drBu8Ek2T1YK3U+x+4cqySseFLLr9EjtqoEBEkQjR7YdX
         q2yDrysSQqKqNnVL3Kk+64PS+fw3275/+Lkf7GTJwbt+9lDsOVe2gYQxmvPXKk30BcEr
         It4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790204635; x=1790809435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IT+kPykiDUVKChmVTT4JFPPqjHccYovstoU8+/L1N6I=;
        b=HRzjVGjmsehuricZn+H4AigGUsBJ1TgzJjHVXx1rkmhBn67U3MA+wQZUCnMyh9DEsM
         yeOM1upRN4rP3Ovba6BzJWr9Dr31sV6fbJZRMyIJYTFO/HOVi/5zG9AyFhEHWhlJRD7e
         /Mi0Xh91rHEBxdKmDg7Gg5qaO5P2kLCSJZ2qL3Pu/5fcm5SnU8rnOT3k7rrhXHB0x6YN
         kOW5OT0rxLWuqewKUatunMwDg2jRjWQJ2oTGtSVjYvpVtJ6YSSrIKmEDR2pWAJNA4ltN
         zuoNIssaO+TGGhZHyUwSXlGOK3GrLaSMJFtvQBpR1JapC9cmSwZxwgAX+DIhJoK5MlCq
         G4+A==
X-Forwarded-Encrypted: i=1; AKwUvBztkkOteeZe1U4k+xS0IyjIcW3tO4BZIM0HchcSlx0mNON7I6JIXNepyibuLYXC7rTbg0t50Drg5g==@kvack.org
X-Gm-Message-State: AFuF++kKfiFq45hYgJWyNoa418atP3o946CpLAZyCvJ7YRYUg/8ElSW0
	f/S6P0xhD5uz54UFMLb+39R/5uLbtUOWhsdGFdGVmAxic1PLM0strJzU
X-Gm-Gg: AYBFou3Dmne4Ap8QoYHz9DuiCz3zzYIcnTWPqy3v+esWjjOWYCRhrK7gQRQQ3WSgQ0G
	sQPemovPgELMPXmPe6XDcMjpOzSi5NuuqCvd9NBT7pwppsOEpquzHnQhsAZfq+QawUld3svOO41
	GDqI99y6fLvjJfkc4kP6VXzUxqdnn5Ztj9xkoZMDQymgoSQGO8jlqa3/E3t3juLYA1RJ50V93Po
	PdvJTjObjwvE5YJwrbwrKahHtYgmnX4e4l1fQmk1DZpZ9tsg+qX5F2FqP0QTtoJ0hJ+3JMo4V3w
	m2e34R1xwy+cqyrBXcA+MSZkUNSCHjutc/vLd3wG6uyJb9Hu7IE4at1Zd5+k1M3EymrBsVamitn
	uzo+2f1tScDaF3sbNFGZIzoiInWT5Fq5/plzfCDe+WO4koJL0GEiU4FLKBIOS0Y+5ODw5/u9z5F
	8oxYIG6kplir529lyOljRTtfKQ74niJ37a4JaFi68/iAXStlRldCo0bPzfNZVVwNsfjfts1Ups/
	qlnHhaQCDryuQMu7J5fSo7nx3m6cKz3LM2w3S5QuOiZodmS4vFqtYdroRIyeRz7JgCwG5bO
X-Received: by 2002:a05:600c:530e:b0:49f:cc2a:f73a with SMTP id 5b1f17b1804b1-49fe66fbeb9mr10115395e9.25.1790204635318;
        Wed, 23 Sep 2026 16:03:55 -0700 (PDT)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe5dfa6a7sm31259815e9.12.2026.09.23.16.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 16:03:54 -0700 (PDT)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>,
	Pedro Falcato <pfalcato@suse.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Toshi Kani <toshi.kani@hpe.com>,
	linux-mm@kvack.org,
	regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm: avoid a reclaiming allocation in pud_free_pmd_page()
Date: Thu, 24 Sep 2026 04:03:50 +0500
Message-ID: <20260923230350.365304-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <e11449f0-d9ad-4d1b-ab21-2be7d71fe335@intel.com>
References: <e11449f0-d9ad-4d1b-ab21-2be7d71fe335@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F223E140004
X-Stat-Signature: 1t5myb1amu7grcas67dckcu4r8xxarif
X-Rspam-User: 
X-HE-Tag: 1790204636-191636
X-HE-Meta: U2FsdGVkX18Dxi1VXsr/9s7sPS1Qcyji4CIdua8TsJMoeB8p9qOea30qimRFPF7OAAEhaZLTCiic5smDIyAlUwTBBSeM0fNTL+lJJKX0krtW4/ILSctgbJgf0fzMkdhC1fZjYZ7tW8oO6Bg58mfSrUabLYspbBYIiNeYxem1Na+BQAYcRCVXTFGOEYyENInL32LS5PRFKU9AIH33Lfx0Cpv6k/LYkr5ANkNtuBVDL2qYyuiScr1LrpAlNaKJ9LJPWlpTKPKzbr7PgqyxXo7sCAG0FykJxcZ21N2uhcCEBR5BMepr1w4lKhuOIsg5R7OyQn3moxKtfJIlIIia7OiOGNp+wv4wsLRcLsYQR+mVuQqPnVmjT22X3oo/9KmnMpWAgW8OzBBqGh/yV0Why56bB1e8kSHaRgkpZOylCOoA6UVqCuFsSnT8ChmDBCsBvso68L5g4rZ8o5mlie8ex+YmOuIF5r644aMFmSnFI0TyvPeV6ZQzBiXxm1foHlS3WoSOE1uC1A60qmQG29dLnEnhJpUO8edNtYrIAQ45/qr+x7NHwdE2HfmypuNZYrfV2gJIPk6/sq7co1LShNY+HSj+oXFRiPpYQVUafRpEt1I6jRkmuXR0WuGGDk+PZgNVmMtDruWv1aq1Qvcg/wac/mFW8PQXjEa/IVhz2x/nMU3kYX+6ylnsw8CGcaogdwN7d3eCR1UfAS/GP2LInYLQHb49j5c8Qwhrst6QIEkbF6SbDDxLJPdaQXdE4fJ4L2RbAdQemPSQEvk593EOCG0X0b58nvl3NfdEbFH38NNJuka85GuLVGnXwXWobqzKn1DKdmFrGe2K+rKrEsW8obsgAh8kjmtaWCcAHrRGXquqKxL/XeZtVMWrojebvJV0YnYkrSCkodDY7XjK8a6rjh2sav1c9gY3B9uMj48wwrS6KV2i9ZEp7z9szyvwmqNJPAlJouG/lJmnIOsnGRbZacz1qqT
 nN2QFiLJ
 yezv8NVBlsl1HwHYD38R4acUTjIbubocLXErXt73miNwYemMQJyLlGqVpruXYsiWOXL6qJixt9+knn8fOxP5cFRhI9/nELYlUM7WxCdcIl1HVK/N88NgWtyDREN6X8ZYUQzTsRitDVb5BIPWWK8olxoT9D/rILl03Cfeee34ZHeLXCzfXaQNMmYz2KINHr4kFgGyI4iSwRVc41lPwyiakaDN2totVjsvKxPaKhnEoJgM6QmYZ6M+4qGaMsKVT2Am5oVNkndqOnQJs2WFgJbkJw1Cjvmjh9Gk8LeoO0Dd5epM8u2fewQHMznGYJY+mo0gtUCsGSYT6HbGNgs4qaxUfHW37eZQvLR26ejb477iH/Qykh7RLH9rkL7rKCPfl5AAytwh2SXKd5sJVBqQV1DxpmmZI7PIK21iM8CWR4h1t9GgWDnd8gvMIpxQm8nKEBXZRcFwfYFhF1SACwVaitfqpqjLMiSlzudQtbf29kcHa7hF5EKXd6LehWr0hdEZJV2xXgP3JabihU2fXaoXfcMVTszYPCVPlh1eV82EP2dRjafEDB41RJvk0fzTNkVD/NP5oXNgRE9mNAwUinsEE4JRWaH68PC1DZfokQV2wKqmoifHdUdjQ9wuN7NXwgeRk+5OSXDFSZb/VuivrKF/KtuIuLnven49mv8zZXPcE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 15:53, Dave Hansen wrote:
> I think that means we can do something like the completely untested
> attached patch.
>
> Looks like Mikhail came to basically the same conclusion.

Yes - v2 does the same thing, and also drops the now-stale NOTE about
the page allocation.  It went out about 20 minutes before your mail:

  https://lore.kernel.org/all/20260923223116.20090-1-mikhail.v.gavrilov@gmail.com/

It was tested on a box that reaches this path at boot without any
instrumentation (from amdgpu_ttm_init()), plus the TTM shrinker
reproducer; the details are below the scissors there.

Two things in the attached sketch, in case it gets picked up as is:

 - The first hunk prepends the patch name to the SPDX line
   ("pud_free_pmd_page-simplify// SPDX-License-Identifier: ..."),
   which will not build.

 - Making it return void conflicts with the prototype in
   include/linux/pgtable.h, and vmap_try_huge_pud() still does
   "if (!pud_free_pmd_page(pud, addr))".  The arm64, riscv and powerpc
   versions also always return 1, so dropping the return value looks
   like a reasonable follow-up across architectures, but I kept v2
   x86-only and returning int so that it stays small for stable.

Your comment above the flush explains it better than the "INVLPG to
clear all paging-structure caches" one-liner.  If you prefer it, I can
send a v3 with it, or feel free to fold it in when applying.

