Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DBD0C5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:06:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27F1B6B009B; Mon, 24 Aug 2026 12:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BA7B6B009D; Mon, 24 Aug 2026 12:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F7956B009F; Mon, 24 Aug 2026 12:06:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9A826B009B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:06:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 55D9A801B4
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:06:00 +0000 (UTC)
X-FDA: 85136639280.11.4D0941B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 89F08100005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:05:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IJ4nzVeh;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787587558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3lhzQ8Ef5dV1+hHioph425Pq7Ajue7QfcmG8Lv/yNuk=;
	b=seDnUlpBxMWuS92BLchKZfo41W/b8Rspmbe71RcVR0fTdHle6MJR+Qhgj2b7gG2pfuRUZ0
	kylADZ0rwIILnxAtx2pfA+anrDsA1hTL3YZRs+K5UOPNqQGdoEND1bYc0/+YS9T+9dWXKI
	0LHfhNYa5hoeGBFRM+tpA+dbcujKVJY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IJ4nzVeh;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787587558;
	b=gAag54eUQY+tGVna3Rn4t6xuBbYC115YCOi+5Q7y+ip/k+UDNypESORpSQG2XLVG/6VpC5
	yPn+TICyoOqo5kg7ttmG+tJvpu241q1QWLf1x0g2gFhRLj9lzU9FjKMJydn2/ULxBIrxNM
	/q/iRcgws+qwtWheqkCvqX+pm7xpR2g=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DC93A1AC1;
	Mon, 24 Aug 2026 09:05:53 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 769D03F85F;
	Mon, 24 Aug 2026 09:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787587557; bh=m2SBTQpkWSQqtHWMxAh9TvwsKocaEw70262S7IijE4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJ4nzVehS8Hj4+HT2oldjrWLZfDgo41bmtZTUlst4kclYjz6JGUKaYe6MBCCvzi8t
	 7KG05+LCjlzm0mxwo5U1+zEPCt1LJnfci69d5G/n9XN09VbrmnvKqGB7eAhMcCqd+S
	 ZBYO+C1F8Knznuik3pACO1Cht3v7ezOhwpBKTvfg=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-arm-kernel@lists.infradead.org (moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)),
	linux-kernel@vger.kernel.org (open list),
	bpf@vger.kernel.org (open list:BPF [GENERAL] (Safe Dynamic Programs and Tools)),
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - CORE)
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH 3/7] maccess: Skip setup for zero-sized kernel nofault copies
Date: Mon, 24 Aug 2026 17:04:48 +0100
Message-ID: <20260824160523.3907021-4-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260824160523.3907021-1-usama.anjum@arm.com>
References: <20260824160523.3907021-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: myb9wshq6rez44q6wzjh9cb3wzbhno8z
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 89F08100005
X-HE-Tag: 1787587558-503354
X-HE-Meta: U2FsdGVkX19hgn4Y7waPtflKBi7ezY4DjT95KvzPXpc3Y/DV9NrsaldqIMush79C40UloWD2pz7xJVW2GsNYzeQbL3IvIsnvsCkvg5nfYL94/cHwluLT8psnniQS/oZ31saRDsf7yD4CuFemKSCiWy8OnGQDyNrnf8iGlZN2rtZg51fo00P+TYoYD7Iuv3Q+WTcWimHczPYy1pk9VepM9xGeBT0yZi5XK5sdzCy6AzwsnI0aJ6NbloZSu8PYaGMDFuba5jD5a0w4de4jWeLrf0p9Loxg+AQx61XUqz7qMLfwcwVK3SBfOT46LenVPUd8mAJf/R4XUxT69L6O4Y4dgeOeN7tDy+pBcSjnD0QdLWxdEfNBP1mmgd8u6VJUppBTmsJh7rpUYMlbFjHuXA97hIHnp46ZeMqWau2KiD0xZySqZmd0wd2iLwiKNbsQNcpHGm54D39Y6zx/OaJlPLE7Rcu9DvoYNCE+Jhdutz3iH80odYEPAYGgYWrUWEnf38oRPXqhs5W3/r6p1JcTR+XLnCRbkAyCPrg3gbYFUNcMurd4kUXzdvM+d/1mkceMnj5iqwekhqU1EOj3t3/msUZC0IHjGhX2SdNqntfsSJe31qWZohYnstBWwwKmoWSuejViVSHyNf+atvMCO+vPMJzYpuDS51dlVspZ0v54ZJ4Q554QD1Fx13q60ti/J2TYdGf1DBKNnppijImqeyL9aOf2tyMaUtlGnjL147RYXPBz2sGJS54OH4wvjQZHbvfRjTlMRe2zhwVxVgSk0BpFyz5zNpUl9x8qlBsxYLaqwZ/BRYluSYCTgcHAuQWxMgdzAjFYArQGm4Pt1QDE1OwUjz2D31NysDxA68t4/bsV0cbPsG6e0fS/wpyH5NsBku+Z8lyKEx76pvCTl0OP0QmQIb39qYFamqnYzmoGKWTPgTTEZTB34D4aDB2vTjCDvwT4EbRWW3vd+kB3WpMYM10lcO4
 tbjpecgu
 617mwr9m+azEsC3L4UjqTVKt7dlKOk3Q0Eb4T0mYuwO/UMBg8SlDukNiC23Df+FYMWs5mtZyllLuxYivU7HNt3CB/XPj5fT0CktIIaI2T0+p+irnW04VkTvxuwao/W1hvTD/dtSXoKTVB4HLm6TPQc0mSP2VpqhzmaaVBqo4o8by6Olcr3ls6LVQd+EO7pq+jJkL0uYi5E/Hrd/zJtWQgStGG4/QbsGHJU95uHHGW/RM1EJL6a+oBIImC4knwj619MR2/WKQtxaZfuv7ZJUWhU6yagDp7/mrkXzLU3BYqL4M8YPvOpiIQw/oo4NjG2aIlK7ZKVNKq445/lq/YKkeQCPIxUwhSkh4/3RZ8i9d2HbtPFokYM3mG04KKR05sPuidfWn/jrhWSd6V27M1eZWoRR5usYZ8hJrfSh7E+jig6KQgf3ouyu1wsfr6A+Nh8epauX3WtliRAyPhuC8PZXKYUjM5hqCgE5sJOXaS7OTDFR+cWc7AserRBXuzCOzwMpdEr9ZkfLOPYU1WUvGodK6npvhn2595zCcu46HQIh7IMdO8p4IfIVLsb2XGUV+ZE8TH+k1hGAfJLxvtmGsfawLaH4xDM0RVi68ALmcYJdTyYZbRd/rdbFQwpTXDgiqwfEqtIpKVG4B44ETvmf1OEfSCoPM6TKF4ek0TawbGiLeI+JWxjVKeOI8RBtr3t9TlAmImhD+J+A1zK6L6kbD9QLAlzlmch/aPPAWcBf8p7KcMOl9DRBJvsiFUF3OwB+qJYVLNbUa21xdr+HAx90Pqx4gs5B3jT1KBaMLpXX98j9ThhQ3FmS7wp4r0L6nR/2lUiFjEafEELKkBw9tVfqmujpan0bvMdRsTJ7GNZ7BSgo5NwrLtbhcmt+S+6AUM7dV1zzqY8lvrBUKY37X16MHadW+TWUVABMWxSQSRPquM7ZfbDrGnfs+h1yiLzSnsPTTFF3liHRW+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A zero-sized kernel nofault copy does not enter an access loop, but it
still disables and re-enables page faults.

Zero sizes are valid. BPF probe-read helpers accept them, and KGDB memory
packets may carry a zero length.

Return before changing page-fault state when there is nothing to copy.
For reads, keep architecture-specific address validation before the fast
path so its behavior is unchanged.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 mm/maccess.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/maccess.c b/mm/maccess.c
index 486559d688583..c59a0e092d24a 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -35,6 +35,8 @@ long copy_from_kernel_nofault(void *dst, const void *src, size_t size)
 
 	if (!copy_from_kernel_nofault_allowed(src, size))
 		return -ERANGE;
+	if (!size)
+		return 0;
 
 	pagefault_disable();
 	if (!(align & 7))
@@ -65,6 +67,9 @@ long copy_to_kernel_nofault(void *dst, const void *src, size_t size)
 {
 	unsigned long align = 0;
 
+	if (!size)
+		return 0;
+
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))
 		align = (unsigned long)dst | (unsigned long)src;
 
-- 
2.47.3


