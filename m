Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4618606A330
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 17:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KTwUKq6I
Received: by kanga.kvack.org (Postfix)
	id D324E6B05B2; Tue, 17 Nov 2026 12:16:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE26D6B05B4; Tue, 17 Nov 2026 12:16:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD1086B05B5; Tue, 17 Nov 2026 12:16:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 942906B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:16:41 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E8D41404DB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:16:41 +0000 (UTC)
X-FDA: 85445265402.07.CD5D73E
Received: from mail-pi2-f9.google.com (mail-pi2-f9.google.com [74.125.227.201])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3ACDDC0004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:16:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KTwUKq6I;
	spf=pass (imf10.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.201 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794935799;
	b=c0WHjaFhjg9dNpBHhf94HNCXSvUvGvnz9o4HnVKbYoZOLkJxQPT4v3sNJR2jtfG3Ql5FgM
	NJ53rREh0ezuULaYfkXriz8+bFLnoiULNWHX1K7i/V1j8rzwz/46UF3kcofC1VAtpwxA7c
	mTC7lnE+ACCNs7e1V41INXhvXhEZIEk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KTwUKq6I;
	spf=pass (imf10.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.201 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794935799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ROucTsPnyYTVcMujmRdSC63nWVbZidpBxQo25fxVF2Q=;
	b=jjxffLQohdgvPl0soK5RLNkuOIZBRhWJTuXV8bWwQtUqmglicq14wxVG8DPdKEjYzrAKRy
	DU1Lk+oD9PiyevvPLmpr2/Kqw1mBqCr8GNMD70gp8PMnqBecV5G+3DNt+I0IR3YHZ8rPfS
	MNeoc1V7a/gZ1c0nR86OZxCuISOmnNo=
Received: by mail-pi2-f9.google.com with SMTP id 41be03b00d2f7-cdd8f943737so21513a12.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794935798; x=1795540598; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ROucTsPnyYTVcMujmRdSC63nWVbZidpBxQo25fxVF2Q=;
        b=KTwUKq6IT7mEZZCWQPXdDpsjcyMSvV4eQ6sQY8oqu5QO+2HfwBhhag6tJHH8HWZqic
         Ecr89ryYPpDJoz3g9I97vHTrZXykFx+7ZqYOG/RYLvXEJtpccImwkrUNgIwokaTMrNr8
         yf7mpyqi8IpemEjeTTSLxmIW3lbYIsZtxbOFQ9KfpaUy8zbLVAlnsATseJWGcx3xMbS4
         SqsrfOyEPsRUo928xETyzJlEXRTxe8/y+8XeVon+HYLNmO+tIjF4UavfK7YdSgvIy7nj
         VMwLSfhE2J+WjqbPSQ/79lkXV1/nTTrOl7FfHdYiEwXPWvFme/C4nQXeVE8qOYgnMgFb
         J0Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794935798; x=1795540598;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ROucTsPnyYTVcMujmRdSC63nWVbZidpBxQo25fxVF2Q=;
        b=MJUsn1JwKI9hrkcZPB7iYPlCj377DV20zpWgXJyvjcakaCqvyhOMxs21u03bdU4YAx
         NHUo1Nm72Ubv5fskZgaP1qBfevSjf5SH+QES4xVMigwBZ4of05DK6ua2l2Zuxf0wgpHG
         3Ybwo0uChwLpMX5XVKOzAM9fT0Jvgcw8llSXSPttsMZ9Wnh4dKHjMjeV8+d+vFQFrvdj
         dw/IZv64H/0WYfax0Ww0phkiqv0AnwTo1ieIhcujBmykNj3ZS3/QwFwppQus5q/N71BT
         B9CBsjF8P6jHqcktFOaR8AF7Ckpgkjx6E8azULrbhBmPdBso2CbrTIH+Q1ILjEP8c6TN
         xufA==
X-Forwarded-Encrypted: i=1; AL+hErFThYH4EPy7GOZT7XnOXuRWKDtx/khvs4kxqiSMR8uS9EMSyRVTYWWVpIjyCRlKS/gIyb8PL3J9Hw==@kvack.org
X-Gm-Message-State: APuU4Z8ex0POZIy4E+5hgu5drd9RGkAc8Qz9F86C5bnhzj1ClUajv/8q
	8cczq9Or2vMesN00LiRpFhIqk7UQIlCXFW8qXen0HcI74Dzut75leq55
X-Gm-Gg: AYBFou1TYLvy+ilj/uorShBVDvAh0twgJ+zVwsG+9kG1on2Nvc1SvML2v/W85B0RK+5
	sr0MHdmxyaJpy5S9ZWyjn5DCQEUf3XfuBcDobnK5xRuk2rjpSFviLhcSstIahpU9hczyL6PXKww
	9+uG8YLPO2D/HH88TfiadJryNjxpn3LJhDOc49UQy1BhqRVXvHEwLCycnL4P+rSXSfYi7aGt6Qt
	Zl+YauX7U76gobK1EBVp9hAXZrjdYqUNUSujBuJRIDez1uIxbEU9EjMtlgn1/JB/2p5TnuhlmiN
	dnO/vkz0q8eMIcJOgAK+GrQ+dexkLkBbTUQXuzyBnqoG1xKjNIG3Pas4hS3AhcZgJYPRmMSzAAK
	k4ZBGtKWDTAychySJg+32bHfZA2qR4ofzqrpESm2pHFhG4sLwHPgxMm+BU6y4Ab8LnTTUnLBDyW
	2JqJNeb03J1mVUunkxvCjky4lM8Gtz+kf3LxvHLRk+6ekfw1eMDwoHSVDG3822pvYUAB3g1mRW9
	co3iaItu3aaXhbxSaCHNYQOBUpI1VQSoUvurCJAlu2AiwYwveNxyoVpBRC0FthPmpdD3ACzQhSS
	TLK6khsRsJU9tnsXzpv6DTshQQSoLBRdmb6BzimF9puEeXND9T64mgt4IKitbNALvkBdhwiO08H
	XBIsXKIqyHcDReUnfaLj/Sx8exJxfNjLRdMHse1gvj53JYuk73esSuTJng9hppd00ZyRBBvYy2b
	0fxOzVk4I=
X-Received: by 2002:a05:6a00:3008:b0:855:eb7b:5804 with SMTP id d2e1a72fcca58-8beb374dd2cmr12162924b3a.4.1794935797654;
        Tue, 17 Nov 2026 09:16:37 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c5b38f2c39sm99770b3a.34.2026.11.17.09.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 09:16:36 -0800 (PST)
From: Aveline Noir <jm5905938@gmail.com>
Date: Wed, 18 Nov 2026 04:04:33 +1100
Subject: [PATCH] mm/damon/paddr: avoid truncation warning in high-address
 KUnit test
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-fix-damon-paddr-sparse-20261118-v1-1-3a0e943406d5@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/32NOw7CMAyGr1J5xiLJ0AaughicxNAgkVZ2QUhV7
 04CAxvj9z9XUJbMCsduBeFn1jyVCnbXQRypXBlzqgzOuN5a6/GSX5joPhWcKSVBnUmU8ecH4w/
 GDb1PA9SVWbhWPg+n85f1EW4clzbbEoFqPwiVODap4f7PA2zbG7eW2xe2AAAA
X-Change-ID: 20261118-fix-damon-paddr-sparse-20261118-fb08902768d7
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, David Hildenbrand <david@kernel.org>, 
 Justin Stitt <justinstitt@google.com>, lienze@kylinos.cn, 
 linux-kernel@vger.kernel.org, 
 Linux Memory Management List <linux-mm@kvack.org>, 
 kernel test robot <lkp@intel.com>, llvm@lists.linux.dev, 
 mm-commits@vger.kernel.org, Bill Wendling <morbo@google.com>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, oe-kbuild-all@lists.linux.dev, 
 rdunlap@infradead.org, sashiko-bot@kernel.org, 
 sashiko-reviews@lists.linux.dev
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3ACDDC0004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 71tk6nfkrqq5p9totdhdkkhmsfnfzc4p
X-Rspam-User: 
X-HE-Tag: 1794935799-256463
X-HE-Meta: U2FsdGVkX19YHeag5ggBHoTQQuAHtcOfD5/4stXUS7karv2EbWf+EM+U+8+BLwzcMz6VzmTWVXtGmeUxGdWG8NvLnyc6R03jV+g1K8io349qATNLbsyHdcpiUDnT/Y5OkUUWi8mJU5fbvhrjwgD71QGohJmfPA0mbrFar/B3TQYQZbjEwpoUuUBzzLAkHnC0Yv0EGnMPLN15qr2yn4T878tpUFyTIQ2sPfWkQByyYNHI8WfdjkKYvAIV412F5dkimPTeTdjbKG0afLvnTguBkH8D78s+gNp/UgzJIpCe5KM9Nq41CnaF1GDMhZtvQmJnK1nms82dcOkboqWnw9ek9MY+YtbH1gmzjRMHJF9pIzFd8+q5tlRqVt4L3qGFwjA/+WI4fyx7n8p3YJJGNH7mEeOsvZBzeFI/zLN6e+YasdRkK/5qWBZxGl2sC8GNmkRFzt5NW2RM8GbPq6pZqVYayA6j7h9mq0fC/N/+EmWi2F9BDzdnkpUAJgZgxQG5cH4RRbShCUqY4oWx0+ec6BBTaM3IinzJKZGmPWlTZUSfWYcGk2jmEggMC5vQrKff4KyRnfn3IzBVmyTxLN6nCx0A+r1kdCewGVjtrwasvn0005h2N/5D7BTaJ33HHjdkOrw9H3M4kKOduAyIDOsu6B8xng6oAlSOIRE+W5oAmSE3AAOxutDyTWZdh/41yZyDGQE+QMcFyGHfLHmn5NuflCrTVUAEFyMhY93ohzzuyaN3lF36SYmmb6QlzYOT+qbFdOu0SoBWE67++ssTHqw1hWSLB78NGkxcIshxx928/aoGWxaH6o9GGieQM9D0k4O/v66cZT5L7YHUAq3Ec1tIvt+/QwonyryXLVuOXJTPWfAIh/CKxV9SLhQYxM8gbpcJMRBw7byadQqzd57SvVKPpSaoFYXLf2IBHhCHlpNSAZYipixdTOptOV9+Ly1JAD9xZrqo0dega4ZCwJUrceVdB8W
 UZREHEY8
 F3Cgbc5cNrpgbtFmc/9P8X7crzX8X5YjZ9QxDKUiPbC6DJNoNhowjF42ta+xeGZEqimQHC0R4U8ftJ42yG/M4XDpTJ/A89BkRAqW1A6YCj0Td/82LIi6WS0irJuSj0+A2Bv9K3pcZWb7Pm/kfMVCAVsxgLTz/Yr0Ey0pNFpVsZH7TWOeHm68v3K5QR3kUpORuCJplu9Gp6mgrlryxm3Yo81b2k5j5Lr//NWYPvbFdoUP74GW3mEFEnr4NamT5tv26+DMHD3sxzUeihCjJLT4yFV5wXObKiHXaAeLDZDya2z+PYDlS3kY0UMhhSzc/4Bwj59qiVRo8b/6KtVs0keFKUmtM89fSIMfNS6l23jwsN9VNuzYL+srsVfpfRGMQiJmXolrmvus4tEZkJXSP3tank9pVtJ0XYB98ebuCcU2Tt6pjRM0b8+CfS/SAMy8YFUquG+D8FtB7ZPF6wBpH0GkoVsCHSlQdudXFdzapqXfpyP5orLXbPLJqOoj5kIP6reZh4MVcSDXtWW97qzQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ, Andrew,

The kernel test robot caught this issue in my earlier addr_unit KUnit
patch. Feel free to fold this fix into that patch.

Thanks,
Aveline Noir

-- >8 --
When phys_addr_t is 32-bit, Sparse warns about truncating the u64 address
passed to damon_pa_core_addr() in damon_test_pa_addr_over_4g().  The
runtime kunit_skip() does not prevent Sparse from checking that
conversion.

Compile the high-address assertions only with CONFIG_PHYS_ADDR_T_64BIT,
and keep the test skipped otherwise.

Fixes: 7a983cc1b573 ("mm/damon/paddr: add KUnit tests for addr_unit conversion")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/20261117170155.fEdeuuhm-lkp@intel.com/
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
The reported warning is gone with the original i386 config, Clang 22.1.8
and Sparse v0.6.5-rc1-21-g84ec0658. All executed DAMON KUnit tests passed
on x86_64 and i386 with and without PAE; the high-address case skips
without PAE.
---
 mm/damon/tests/paddr-kunit.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/damon/tests/paddr-kunit.h b/mm/damon/tests/paddr-kunit.h
index 9839cc233071..2b11f0e67a12 100644
--- a/mm/damon/tests/paddr-kunit.h
+++ b/mm/damon/tests/paddr-kunit.h
@@ -26,15 +26,16 @@ static void damon_test_pa_core_addr(struct kunit *test)
 
 static void damon_test_pa_addr_over_4g(struct kunit *test)
 {
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
 	unsigned long addr = 0xffffffffUL;
 	unsigned long addr_unit = 0x1000;
 	u64 pa = 0xffffffff000ULL;
 
-	if (!IS_ENABLED(CONFIG_PHYS_ADDR_T_64BIT))
-		kunit_skip(test, "phys_addr_t is 32-bit");
-
 	KUNIT_EXPECT_EQ(test, damon_pa_phys_addr(addr, addr_unit), pa);
 	KUNIT_EXPECT_EQ(test, damon_pa_core_addr(pa, addr_unit), addr);
+#else
+	kunit_skip(test, "phys_addr_t is 32-bit");
+#endif
 }
 
 static struct kunit_case damon_paddr_test_cases[] = {

---
base-commit: 7a983cc1b57309a875a9e07a934c9944bf3d088d
change-id: 20261118-fix-damon-paddr-sparse-20261118-fb08902768d7


