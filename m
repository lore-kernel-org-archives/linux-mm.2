Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 519A3C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:07:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D8556B009E; Thu, 30 Jul 2026 05:07:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B14D6B009F; Thu, 30 Jul 2026 05:07:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F08976B00A0; Thu, 30 Jul 2026 05:07:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BCA916B009E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:07:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 262804095A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:07:01 +0000 (UTC)
X-FDA: 85044863442.17.0F11777
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5FC0E20008
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:06:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LF3o8w+K;
	spf=pass (imf03.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785402419;
	b=ZDz+SV0nZAVRH0hd3RVLlHcEEZ3lmat3XSe3qvtm1GetyxnJlOnpxeMwdkiFE2RejZ8X1Y
	h8QW8V9Wo6hmaA72UY6ayL2e9sAMjzuedoTTJ1fCApOXjolAiqQv+nP9lg8inwUuc2dbbF
	vHOZDDoPdgowkod5kIItecGQnvpPu18=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LF3o8w+K;
	spf=pass (imf03.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785402419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JyUPYL2OrXSKt8rHjiCQrmfpBKq5z8MLwljG9M1Hes8=;
	b=Io3usm0eSq23gxuuf1WRJi4oPu2uDCTua/NXhxxgJOGRB8arltO9fvwBsndkk70Oobjf9o
	mIgAFGVWcI81CwQKNBvQgMEeHdeUac4nFDIvCTFItnQJ0zVU4Zg6O7kHtMX+5NXP0V64ya
	Sm8UHEAGHr5LxjUwEtpJKDZ4NFMJkHE=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-84e252fbb7bso158453b3a.2
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785402418; x=1786007218; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JyUPYL2OrXSKt8rHjiCQrmfpBKq5z8MLwljG9M1Hes8=;
        b=LF3o8w+KxHIvHy11iCRb3p6F0KkJO1F/e6B9/Oi2UVBiACf1Tm6XH2/epOCGRTvIgr
         iHo9ALMJ15TyJPg9y0ciGgCn2e6YIaaCWqKb6Aj8S+eqrjBW7dTxUAvJTkOYOTLFmhQC
         mWk9XgUjinn2lAZ6+dd21qXccWqkZjFZabAfcPiugFXkiPea1uXBLZw8VNp3fmWg0ir/
         RnRgoFIT1GDRiSzbLJNcTPXeS+0eSongURZHFxn8x/fcK0GJql5ddXxo4gvF2i4gPpeb
         ozjkIkp7+mRpS9sd2/irB98b6VsVBFT1pAeIxtixZY/vdxqFtVwiHjPkfKhdRppqhEDg
         xGpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785402418; x=1786007218;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JyUPYL2OrXSKt8rHjiCQrmfpBKq5z8MLwljG9M1Hes8=;
        b=hgAWO7IMivZ8jzi7rpG0c/Qjl3ACUHvl/OTNwfh+WIGLlFHXYOYhT1/dET7355NrbS
         VoNzKMsohHXDjAmX6Alls6I/DBvV5BHSezS+8LqjUEHfWgbR81bFTuAkqbMyL/nUqtn5
         zf+4sFW2aJ+naVjT6yklZTcuFMzyyAPI6Aw3QM92wu5SD+1bGNmBgJ4L5GATIfq9fXkr
         OTfy3dERNVWWVcABA23MYBen5TuD4hMWRKjsD6NjWMzjynJJ7nwAgThfR7LlSfM2/bCx
         /EkVQ1yWx0s1NRI7L7+nXEBY6XaKKchmENcO6ZgbVjSasYeI/KFwtfkQnbqUH+gJREz7
         yq6g==
X-Forwarded-Encrypted: i=1; AHgh+Rr88rxW0/zAfQ7FH0vHPz4sjb9XEF8HnTMiJ+88kWyMVj+j2ZAfO/Ye18LXsMHxp8DI2sj32KJ9TA==@kvack.org
X-Gm-Message-State: AOJu0YxsOlqIafTnOhN0UnnFYGSU0a6CoobaJqqZ0VPMdn4n3JgtI+Fn
	X3Lu0kXLgEbdq04ABWKVmn2xkPu8lKG24Xqg66r2kMBc4/1VzNksRuMA
X-Gm-Gg: AR+sD12cEDBqqqVT2mZirus59PyYW6H6hJ5kPNClgQufoaB6hwmqPi7RHOrcVonOndS
	YZYR2S7leOQ6cEe694kul/U82r9kZ/lVWtNoRaG8K3c0bapn/LAAYoC2XtJAv1fCUDgIxx1wgjg
	vS54qChS8O6oGuRAuNqPQ2QwSwb7bVGsUFcxWqCNYJY+I+4T6jdVsZDv5Hk1PVsIEgulcik94Bk
	O3ldXl6BXIh6QYu+vojUum08p91uFUzyQhDHb9av5K5iazsXYpF8eZgrNqwV/7G79rs+KihnXOY
	rr+u6WtxPEN41lRCMpBDzQIkHYVczH6UEwK56Px+1/L15ix5oVihFDqo7lBj77IWG8RF7aV5W56
	aMU2lXChZeR9H+d2rtXEwyUfwLApBcWa1d9La2z5Kf4shdHpYwBkuQFVPyuZqOo9CRvd2a6kOkz
	JzucgTobbhnFK/4daNUonrghW5OK7UbpWH/z2PJ10wZNA9oKSId+J0MDGeoaKvZlTIcagycC4X/
	uxVD57wSz7RFIfMeGF7tjDY8aCbKCpjTnhOHHZZ9V6kM0nK8hY1
X-Received: by 2002:a05:6a21:3997:b0:3c6:7648:5ab0 with SMTP id adf61e73a8af0-3c9003cc78cmr2258784637.0.1785402417981;
        Thu, 30 Jul 2026 02:06:57 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbdba447107sm1902510a12.21.2026.07.30.02.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 02:06:57 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	usama.arif@linux.dev,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	ziy@nvidia.com,
	baohua@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v6 0/3] mm: make persistent huge zero folio read-only
Date: Thu, 30 Jul 2026 17:06:44 +0800
Message-ID: <20260730090647.2401252-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a15um9gc53y7ane5grxx9bk7zhmckzhr
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5FC0E20008
X-Rspam-User: 
X-HE-Tag: 1785402419-746286
X-HE-Meta: U2FsdGVkX19cXK/5RnD0rGEg6E5RmNLqgCOBlX3J4SxGhthtp1wM6RlF1+Dqf2xSxA/uaYddoOyRxR6lkLRjuuIiNe2Ov5z2lRjxSJw7Ep8Wk5mkFrPbVMWYLPUYFK2tj/YAiECk/IQD48gleRmrZ2DH7fwzc21F8WrOoz5Wm3IYpOOC4A57evl8PTHIldB4sOk8Gk271HS5VByEW//7eN5lj2niNP2rlGYbYDr+zFAlRTIUF4/EC1h8hVcA3tfRho+0fuFFlWXunAhcYblkktaYwAzbUmwumdna4ZklPiScBZ7o2l5XxmikYvCc3xJLIRFvlTMdwlCbAZhMb1PyikodHKbVg9k99nlWWST8Qy13jceKHdayH0ACTg++QBx3VOje048qO+JYAJ/tbHGTkCHUfQV/6m9hdqwQZC0o2wwO2BEFYMowYjB1HQUTfIg9jNyHoXPyigHLrVp3+0Bvgj9oDZmvOPs2vk86uDbVpLf24+j2iR00MJ583zfbaJQjNZmrAuSCtteDLCos/kkgFOu88ygRm7Yoy14RnVsXII723ZCxGnFyT/V5i+MtwsHjHh8+8O4p0hRrH9880Drt7Mu3Pu3CqHDSf6/SXNB371dKAYeUjGzEG0lHGrOW09n4KTrPwQ9eyHJPybnvsiQZkdm+0FF6DCF2veHmo/iL9bp30PkyWMV/0TlGv/RahkTjbKOYfSxejXmjWmocngnon8c14ohmjdcpLmFdw6xVT22QTc+tUoE+xF4Gd36Gu2QSdz4+AQCJtoZ7GvMwNH1SOG9jsVaJni+p7Z6TtuC+c6RQp2/xjGzIR0QmpJQVAdthSxlt9j6xMAU0ny00MSsJo6qtuljdsWquGnE8OeGnzaMTIev6CquJDjAS8sskC9KKp9VUNE/yY+udq/O39WPxomfV8WErknp7uN3pEEDkRz/ZmCz/7WtojNJKrauZWReTMgkkeeFoJBQlitGS34Y
 ZENdMOUd
 Tblc1bN8Tsfoimw6c5sW0wtHeBiHstC0EyE6UHEiwZoXdiK7u95lKqTn2cMMr9G/suU5hNLH5Y8CdriqM/n0CvRe22+pxa6FZKvohS0wQ/zi8CWpTmPw5RZkmth2tW4Uu0PEEHDuRSlcfNNgLZ6Rw9nHVKgZ/WQsc9FgswL5P+0Bd+thgtnbXhPkZMWlV8VhhucCkouNX5Nk5JB3rAHTAiOxhV+/dbvTI7dnMmG9kvkZ6dD1dRBICX6Zk1dIMgwBwYsZjA+WXzgv4Gv5rqAfKc1y9jOOWsXqNeEy9EkLoKCpSYv5HFMGtss4Zr9lGZr4ZGXXtsddwUwiONbdLlGG1PSd7ZWcjnRSOjyJ3hCcraywZYijP4WaAMgfxEx3yf7F34Jvw1gI8p5ptJ8HUQFJuD/IrkNTdyp2IS8cZF90QW2UCuE1TqTGPbRedsEilYbm99lbqvQG71Vco9o75QNQlWrzCpk9kKKBS0D6EW9+WoJGJ7mOQI0210BKD6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The persistent huge zero folio is shared globally and should stay zero
after initialization. As Jann Horn pointed out[1], kernel bugs have ended
up writing to pages that were meant to be read-only, including in
security-sensitive cases. Making the folio read-only in the direct map
turns such writes into faults instead of silent zero-page corruption.

This series adds set_direct_map_ro_noflush() so mm code can make a
direct-map range read-only, then uses it for the persistent huge zero
folio. The helper is direct-map specific, takes an address-based range as
discussed for set_direct_map* helpers[2], and leaves TLB invalidation to
the caller.

The folio is allocated and zeroed through the writable direct map before
thp_shrinker_init() changes its permissions. thp_shrinker_init() is called
from hugepage_init(), which is registered as a subsys_initcall and runs
after SMP initialization. Writable TLB entries may therefore already be
cached when the page-table permissions change. Patch 1 flushes the exact
direct-map range immediately after the noflush page-table update. Keeping
the flush at the call site preserves the helper's explicit noflush contract
and follows existing direct-map helper users such as secretmem and
hibernation.

GFP_TRANSHUGE can allocate from high memory on 32-bit systems. Since a
highmem folio has no permanent direct-map mapping, patch 1 skips both the
permission change and TLB flush in that case.

Patches 2 and 3 add arm64 and x86 implementations.

Link: https://lore.kernel.org/linux-mm/20260508-ro-zeropage-v1-1-9808abc20b49@google.com/ [1]
Link: https://lore.kernel.org/linux-mm/0e5b23a6-4895-454a-9dfa-6dc21adc2991@kernel.org/ [2]
Link: https://lore.kernel.org/linux-mm/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com/ [3]

v5 -> v6:
- Patch #01: Skip the direct-map permission change and TLB flush for
  highmem folios, which have no permanent direct-map mapping.
Link: https://lore.kernel.org/all/20260727143426.1077133-1-xueyuan.chen21@gmail.com/

RFC v4 -> v5:
- Drop the RFC tag.
- No code changes.
Link: https://lore.kernel.org/all/20260718095647.182592-1-xueyuan.chen21@gmail.com/

RFC v3 -> RFC v4:
- Patch #01: Flush the direct-map range after changing it read-only, since
  the folio was cleared through writable mappings after SMP initialization
  (per Usama, thanks!).
- Patch #01: Keep the flush in the caller to preserve the
  set_direct_map_ro_noflush() contract and make the flushed range explicit.
- Patch #01: Clarify the noflush API contract and the reason stale writable
  translations must be invalidated.
Link: https://lore.kernel.org/linux-mm/20260706130440.9295-1-xueyuan.chen21@gmail.com/

RFC v2 -> RFC v3:
- Patch #01: Replace arch_make_pages_readonly() with
  set_direct_map_ro_noflush() in the existing set_direct_map* family
  (per Mike and David, thanks!).
- Patch #01: Use a direct-map address and number of pages, and document the
  direct-map-only and no-TLB-flush semantics (per David, thanks!).
- Patch #02 and #03: Update the arm64 and x86 implementations for
  set_direct_map_ro_noflush().
Link: https://lore.kernel.org/linux-mm/20260609143801.7917-1-xueyuan.chen21@gmail.com/

RFC v1 -> RFC v2:
- Patch #01: Drop the READONLY_HUGE_ZERO_FOLIO Kconfig option
  (per Dave, thanks!).
- Patch #01: Replace the huge-zero-folio-specific hook with a generic
  page-range hook (per David, thanks!).
- Patch #02 and #03: Update the arm64 and x86 implementations for the new
  hook.
Link: https://lore.kernel.org/linux-mm/20260527035607.14919-1-xueyuan.chen21@gmail.com/

Xueyuan Chen (3):
  mm: make persistent huge zero folio read-only
  arm64/mm: add set_direct_map_ro_noflush()
  x86/mm: add set_direct_map_ro_noflush()

 arch/arm64/include/asm/set_memory.h |  2 ++
 arch/arm64/mm/pageattr.c            | 10 ++++++++++
 arch/x86/include/asm/set_memory.h   |  2 ++
 arch/x86/mm/pat/set_memory.c        | 15 +++++++++++++++
 include/linux/set_memory.h          | 29 +++++++++++++++++++++++++++++
 mm/huge_memory.c                    | 20 +++++++++++++++++++-
 6 files changed, 77 insertions(+), 1 deletion(-)

-- 
2.47.3

