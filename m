Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14051C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 081FC6B00CE; Tue,  7 Jul 2026 23:11:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 059786B00D1; Tue,  7 Jul 2026 23:11:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E81326B00CE; Tue,  7 Jul 2026 23:11:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7D886B00CE
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:11:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 17C3240613
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:52 +0000 (UTC)
X-FDA: 84964134864.17.77524BC
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6CBD3100003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PMyiN1qa;
	spf=pass (imf14.hostedemail.com: domain of 39b9NagoKCAYpznu0mnzutmuumrk.iusrot03-ssq1giq.uxm@flex--jthoughton.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=39b9NagoKCAYpznu0mnzutmuumrk.iusrot03-ssq1giq.uxm@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783480310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4NDGpn45MhaTYlhQFUuH7sBQd7vZ4HzbwwdEmS2fdAw=;
	b=kVk5bRCwxiic07tK6oE6N8Uwo/XxHuy+aQWWvfka/a2c3J6F891g+09j2le8hRkjp+bF8d
	MBj01HS/BQw3lUIglCtm5n1DGzzi4DKqq8bj101/UILKVpAFtDgSSf6ozGVuB0wS5qAi1F
	M3ACi9MvzEYZ3iH5uWgxkaqhvzHruIY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783480310;
	b=bdmGUAd7A58djGhp+ITQ/s7t2GyCoKVhndLl7Ym+bWIpT4uTiJ5QmElYpjQH3ZKt/6CwCl
	8hNzTdoqjdSO9xszLkiNt9w1mGUb1diPv6fBy6+KBc6cho4WZFcV4dhWywWUllqF5zkpUu
	IV/c4/3QiFDQjYAvMUc6d9OrlYlNfpQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PMyiN1qa;
	spf=pass (imf14.hostedemail.com: domain of 39b9NagoKCAYpznu0mnzutmuumrk.iusrot03-ssq1giq.uxm@flex--jthoughton.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=39b9NagoKCAYpznu0mnzutmuumrk.iusrot03-ssq1giq.uxm@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2cceabd70f5so4350245ad.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 20:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783480309; x=1784085109; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4NDGpn45MhaTYlhQFUuH7sBQd7vZ4HzbwwdEmS2fdAw=;
        b=PMyiN1qaf8PjL4BFine/KcBfCE/lqVfBf3TOu0wXc04E82g0itP5+R5Z9bvRpnxgE5
         FGKMbRP+dkz5dDPukBbjMsbjaU1vlBDiidqYaC55w5H8yq74RcnmQpuDGvgep6QXovC4
         1FGxXdXneFyBIqbKR/oQ8vaMacS5ggyDZvMHJElcTpihsGNOafbkQ1zhimgIA/ASEIip
         76MAzKGLgNWZ5Xmb+d3aqAfRdOMkKJ1iooOHeV3UZjNH03YWnVr1n2LhBKewNgq5mymC
         el8KOWEkYaOLtAf3N/axQdU6vr6aGEjfBXF+Xb89A4jUXgxbfhk48Veo+xwAVyQ4y8bg
         /Rjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783480309; x=1784085109;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4NDGpn45MhaTYlhQFUuH7sBQd7vZ4HzbwwdEmS2fdAw=;
        b=dNnNqCo33o0eoobZvW47O164I/mp92bMaz5lZpFyS7TJ9+eCdf+sxRgcFso72+ib2R
         hc5sENUgCfd3u7FqyZm1H+6r83bSipGw0TYM2eKvRG3RxiTcyynUFlxBV3o7DKhdykB9
         8q5kW/Qr5X5k25Dr1MJRqeqj1yfULPI2ZeIyYC6/SgOAUloThbBxxbD/wCcdVrSxS+3s
         BuChHgnGG03LsFOH59+ZPMc3YV+prGonPXcYR8Onu5qqcoGJSvbu0szu4WZvfiMRM2Iz
         19oTUCGIY66aNOYXP7KURx8c8umc2FNKrsR5h2KfUoBhQyDAViCP8LThipg/kSmo+uEX
         hwiQ==
X-Forwarded-Encrypted: i=1; AHgh+RoBsByyiU4p4n1jOx0VYphmVEZP2XU+i62/WDY/GQl0EvZOLDAEtUSvHBx5PRgFI7w1HZOAluvS/g==@kvack.org
X-Gm-Message-State: AOJu0YzyeU5ODtqY293SzGVqYQ5KP5Anei/KwRfbrMbbunRAY4YxNq2v
	XRa/0tEj2roScXt2h493VNtDcTggEX36bA/00XuwgOa7mUwDw7M8mRMiaS8BJBznICfAUgXMgWu
	7gbaf5q8eqf43FPn4gqCyig==
X-Received: from plwh17.prod.google.com ([2002:a17:902:f7d1:b0:2cc:ed0e:f302])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:4b48:b0:2c0:b6c7:2271 with SMTP id d9443c01a7336-2ccea2a5ecamr7510755ad.4.1783480309200;
 Tue, 07 Jul 2026 20:11:49 -0700 (PDT)
Date: Wed,  8 Jul 2026 03:11:28 +0000
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708031129.3503195-19-jthoughton@google.com>
Subject: [PATCH 18/18] arm64: Remove user-selectable HVO Kconfig
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6CBD3100003
X-Stat-Signature: 8knskgbekmduijz3ra6uedb5ziud9gf9
X-HE-Tag: 1783480310-868474
X-HE-Meta: U2FsdGVkX1++wjkfNUrb35IQZO/bekepVAvFJzWx2ylGaJ8zK+4kGSfVopboe77k8euUy8cJbJwmXkXf/SCCwK/0Hjd5CQsoeBzFs0FU67hvoAukJDeOAkeIXcB99uJBOyylugLUTSYN35+Fd9Y2aV12cU+Q6ZDjhFt+tLxJp0cXtqPPNWILabxLZDQU71Tx5zJIhwe/uiX8UO5Wm1tiwo39V/dq58X7VX/QtHuOQw52TsoHQjF+ChIpQvb0s0oF3QdczExu3qC8tNK2Xz2MG1O+2T1suLZayB89PIi+3WDmXnCq4E/huUTKVLjvZ3Xsrci0OqGiGxlU3vQjOfcfw3pZEQWuPy9NKwaGfpze/dmsBRwsEgBOACRrhWwUmUytNcRo1CzDF588/BoE5U20Da9HEahZHQ2V2NJ3tsoc4pCU9LflAg7WaOLnhJD32ItUOWAdsh7/DkteHeFOvOzRkPZJn7p0TrSJoQU6b0JKiHCZy60/Ik5uVaaYCMiJ322CrnRUpuAgVJwgrgAXeMJ9TEu/SezYBxCiB+IQqwGAW0PBhnPXjWbtcqeDg/jvvAxFKIuoQjY4Fdw+66m88qAKMCBDxwbSQnsClWS+fJ4e6QX76VU6UP0YJ9LaD8Be7UcgfQ6UxCMGrXiOU3XC4PTdXmQER6ORrO8C1XVltv/5DEMStlUw/OV+YzMvr3M1ggb7l6TTN6q6VR1qkoDhu82BHOnEt60y7v4rceiTWG6ON4OuALzsJpvTGDZjvs37tlSdZ76hznD4wC2JHYBZA4OAflFJLOnCEKQUdsjQY40J5YzHcTsj5DBVe7QDRImjZXHQgt46u89P7yvpKTPjSLGkS5XIYqczwC45tTEFsoUzMfzwvlIBQJx22LGw/RoZ+IfQK/NNz/0KaFhjSjF8kWV8bj6NnOSItCz8LVGANwFKGg0ZNfeb+40bey0UEURlV5tR6pRQ2U0Z9ryfTEOITgA
 WQ/b6Vqg
 BBXQ6UpXod4dFQhRr9BhabmKRHlj2KN3mVjBDQHihLEZ0vPNVE6Al3koHfVEWy8wkkAVetVv2Ircg0ZPLjtcFUtMZPzWbidVIeaK+Y4ABVJxBq9B8w/HRzAMRwXWN9VR3TM+7cS6Em/VFDT1tYRtcmeKKFW9JWi1pNoRdvg+a8HP/nEUoY2JX2AbbDRz1NeYH4DOvKFDi3RNb6NKmy8Tehlc8s2knNdj0owweB+xKpL0tL6o9tWQHXeli6sVG08d/RhAyzqVlUpsgwSiwXAG+UaHozlj6RY9TbAnKPllYC1NhYwAPG3zNz5R0dDX5F+lpd+mQBTadvrsvQZ6Sk0tebFum7IFN6XxPIpveZtRERmBYSdD5aTpy7b7da0sdropAeJY59zwT7Va81yFgXfrsc3+hfSORx3h3ITmFceTBnFJJRQYL6e840xgHUSn7ATU8ibqil8Ck0bV3nfxwW86QDwzuyN8q/BjwxOEAFzPXeQcATTJnHUL3QznWeYgX99Iu1R6DrvDa+aIoPH+rlyXJZzMtwwsbsXsV6Do6481rXwo6i0cFfTGwJWZxeMO1IBGLYnwI7U4WwrkvyqpO3mm87RufqM9v9j+j2VFfVpab0ft2xiw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The Kconfig is not ideal; it is niche and difficult to understand for
users. The Kconfig was added to avoid the following regression: if HVO
is compiled in and all boot CPUs support it, any late CPUs that do not
will not be onlined.

The implementation now avoids this regression as long as HVO is not
actively in use. Therefore, drop the Kconfig.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/Kconfig | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index cf4bd6bd7f11..2a59155f68dc 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -259,7 +259,7 @@ config ARM64
 	select USER_STACKTRACE_SUPPORT
 	select VDSO_GETRANDOM
 	select VMAP_STACK
-	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP if ARM64_WANT_OPTIMIZE_HUGETLB_VMEMMAP
+	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP if ARM64_HW_AFDBM
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
@@ -1608,17 +1608,6 @@ config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	select SPARSEMEM_VMEMMAP_ENABLE
 
-config ARM64_WANT_OPTIMIZE_HUGETLB_VMEMMAP
-	bool "Enable support for HugeTLB Vmemmap Optimization (HVO)"
-	default n
-	depends on HUGETLB_PAGE && SPARSEMEM_VMEMMAP && ARM64_HW_AFDBM
-	help
-	  Enable support for HVO. When enabled, late-onlining of CPUs that do
-	  not support features required by HVO will not be onlined if all boot
-	  CPUs do have such support.
-
-	  If unsure, say N
-
 config HW_PERF_EVENTS
 	def_bool y
 	depends on ARM_PMU
-- 
2.55.0.795.g602f6c329a-goog


