Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51033CD4F5E
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:18:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D6C46B0099; Tue, 19 May 2026 11:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AE8E6B009B; Tue, 19 May 2026 11:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39E366B009D; Tue, 19 May 2026 11:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 24D516B0099
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:18:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9FAA1C1F6C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:22 +0000 (UTC)
X-FDA: 84784525644.18.A65F23D
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf27.hostedemail.com (Postfix) with ESMTP id B8DAD4000A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vKnKyx6S;
	spf=pass (imf27.hostedemail.com: domain of 3On8MaggKCMEhyki+np0nvvnsl.jvtspu14-ttr2hjr.vyn@flex--ardb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3On8MaggKCMEhyki+np0nvvnsl.jvtspu14-ttr2hjr.vyn@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779203900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yp6Vbx6VcvTlYXuJmWR3cijY2UdMz6wPDbvvga5K5vY=;
	b=zjN/D2kBHc92a4y+9G3Z6NfOKBJoLBsKFDBUHp5DluzBPejFa5TqH4gXB+YjKsiebxfsTv
	7gHkTd/T9T+nGz3lH/s++RCVizRCLbLIZxdhA6beXbFxRou71h5G7ELYKrpDn3yAWojJwS
	7GYTLXOc/VwbQTnasw1/dIGkzHGp3go=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vKnKyx6S;
	spf=pass (imf27.hostedemail.com: domain of 3On8MaggKCMEhyki+np0nvvnsl.jvtspu14-ttr2hjr.vyn@flex--ardb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3On8MaggKCMEhyki+np0nvvnsl.jvtspu14-ttr2hjr.vyn@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779203900; a=rsa-sha256;
	cv=none;
	b=1nB69sHWn+1E/kC4JFRJ7c5AhE4Kn+U16o0dlZmmho9JH+H7TZtQ8QIVylZ8WtwEkWl6kA
	wu+LXa66UixGpy2Z1koaqs0LcsCGruelFQ7NSccwxkiXsQ93790i8r1rK2y/8X7xkt3crH
	o0K7wOQKiCZcuxJeBVEM4RKuYim3rVs=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-680f7441bf9so3165793a12.2
        for <linux-mm@kvack.org>; Tue, 19 May 2026 08:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779203899; x=1779808699; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yp6Vbx6VcvTlYXuJmWR3cijY2UdMz6wPDbvvga5K5vY=;
        b=vKnKyx6SnOPL/0CGFfZrWWBlFTHqMzuFULMntjJ7AizO1Q3EiADGAje/aEkX7Mc7i2
         0MHb7wcW3EpWCDHcRc7bBcSjdmTRl/o6dz7jQ3xbMdAqfF29F+vv0gBJGhwTp8j5vE+u
         LQRdaeuNCB6cP9EMhnDzx5+MryWQTin9LlwXegy87tVasQNHx+C5GrCM/547OY4las+T
         yaK63N7ji40pkAMR26WsKx3pYNtpE8+UkSTxZph/OrPo/+V8JQkcrAxtqq8DopBMODKO
         srPcUnVRq7h4YhCjyTnODTCQbruGOGqS2bF/Gm078DejKzPOIK5WdZxA15rc6K1lklPy
         QsSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779203899; x=1779808699;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yp6Vbx6VcvTlYXuJmWR3cijY2UdMz6wPDbvvga5K5vY=;
        b=DRfPVp/6TzpnHjOHuqIiUYnHb2DNbUssPSVpCxoOg8llF0ad4YGofYx5P1URDdlTOL
         ssO3BTOB/FsYJ4eT7LGCN7JtIOuokfE/sO8Wk3xzpYVFafI93Njd/rTcT4Gln09H0QBd
         1spQlwRNpKFOHTUUMPYpa/tpHLjCRg0ALYginWiTPUXrlGhOOhO3ETUQ74DJ3poGE2Bf
         c68wlfwqzz5k1B0MKdnrlGHZOeQ3b9ArQrJEersICCUWMufm/fpXsBt5OZNxtAYcv3qZ
         g9syZMieTD0OZ0zEu9UDcw/aybDeHm6KEc2wj8wAGwtc/3Agmz4qDbuD6e/8Nh3z2FsX
         wQbQ==
X-Forwarded-Encrypted: i=1; AFNElJ9n/OQ2u7zsIH6RiQz4d+xK6go+zeXJksKmrWcVBsInkyN93gWjJxX1yDD7QQBHOVM5bczKKdVqLg==@kvack.org
X-Gm-Message-State: AOJu0YxHFWpBecN69IwOW5TH1NdH+FV1x1RP0UqEvHT06AqQaSRbXsfd
	KHBLsQI/w6W3UIJPnwhovfAe0e/jcpvb7greLxKxIIAQAYDhEIs0i+uEOzcJbhrf2bhl/LYsyw=
	=
X-Received: from edsf17.prod.google.com ([2002:aa7:d851:0:b0:671:9d2f:2d21])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:5bcd:b0:676:e2c2:9034
 with SMTP id 4fb4d7f45d1cf-683bd28c712mr5773883a12.13.1779203898712; Tue, 19
 May 2026 08:18:18 -0700 (PDT)
Date: Tue, 19 May 2026 17:16:20 +0200
In-Reply-To: <20260519151616.2557018-15-ardb+git@google.com>
Mime-Version: 1.0
References: <20260519151616.2557018-15-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1340; i=ardb@kernel.org;
 h=from:subject; bh=HzOxyKiU5x0X81nyNN6N0/Tb7jNyzDNJ+OLc9lYWfgE=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIYun7pi9g01ZksV39oqUid92yXdN31TMeWavqc7HepeVn
 ou6vJ93lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgInsXsTIMCthp3fF8SvKomoF
 iluWR+6SSIx6NPH2/8ubVl9Q2u1f78zwh7+qQj0w+5yX82v9mfsl5YIO6kjNEn/++tknw1+qm6J 6eQA=
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519151616.2557018-18-ardb+git@google.com>
Subject: [PATCH v5 03/13] arm64: mm: Preserve existing table mappings when
 mapping DRAM
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B8DAD4000A
X-Stat-Signature: tc9k94ts8351131bsw77mbzwh8qg6a15
X-HE-Tag: 1779203900-88062
X-HE-Meta: U2FsdGVkX19xhV6OwNsT6q4X357/0eqSg0/XVcC5pouhcv4wvb1SnLf3gKtRiElJZxHqPesJKszSjy9GqF4lkuOIxGmstUA+y8QH8Ba6QGNnjIZheR0HbtTF8sx9mmn0abVRf7knLqaTd1Z5pnlbSbOG5GkuF13Fab0yk7Hy7zo7QBykyb1BWiS/f74TBlEkzgWmLJUprzBSE8ZtnvNFdmVGQ5PpnUuWToPtwAB2MISATCd/ujjTRFEtNrYbotHtXwpX+g5e0Fl0hoQ7bE3cR12yplxXHZh0w0a+w75ZQOImHy8rRO2ZzwrFdlb5yvq1VO0wu8DrXGzcn53BHbjX++TFXdhT5yTRKS1QHvFE2oqENA9WolbFuYoIclhuvD2xGAXciG0APpYdKaHLNYJ3VEam6yf14ap1xRoUms4DRCLWwEWjkfj/o+j1eE3CVqkE+8jzLiJXitA+/LXVTgdKL8+Fdtiji26iso/8lCvXMShh5/aEYpgd/f2vskwRo1kiIV/DiLKJHdzEfPwmu2sJWrNbmKwdh2E6RLBh8a1xX8muDnkkbZ//m1SHFoEL9R62B/y2B0xr2ptK2yqHLzWqM7P8ebE0XTW+GQT2gj2XdzuxbA3lzDwKP8E0HF9qViebXyhrOJBkzrfGvePiw8x75AEkaIe6lxSgamxHue5tMaCjRe4HGIq1JnQnmuOCDg+uhXyMJI3+yBx3kywyYnQFPZB0RZB5YWh8gsRUT+fs/LSkgyD3p4Sy/O1E8vCDu+F1//oFYY3tNnTnpug/Sfi3wh+Tu83B7n2wcG+akOVXnNR6eL02PZU3A3AlC9dYsR3UGeoo8NyaLAbmkpmNvSlSXButAUh1kd54sLgb3iAYiHZL4eVLT21DYNgo3BM9MNN/BL4NXQKwqOMQ1gu5JkoREMGL4kOVElmF7jwApNVx1hh7BqBsDPYE6qCLzeGR3qZC1tDuvdJXjgXJ67KR+QP
 GtGd2cJn
 V3rrbb/M8f+A8TJwVoQKfFbNQKcLg2NoC7bv+drCPd5RoXF8mHmCcXsQ2OqtXp0TCqY1Ez+e9nBtH7Q5FnCO92PQxK9J0hl3XEDR6PrIuNibWURNpDR2vLJeWynTkh3RT1aRGY/94P07dICrBEqT9mVIlre9nw4VdmacENjt7GhvVgb4OfIxdzrQ5s4PaYty2DqdC4G5Ga9LpjFja0Eqb4F0Z62dSgnvwLvCygqLZzF1iohhGUbgF+i6PChLFBb+tJNPrAv1tl5j2LM7ufsknV47/+jefNCUWNehMeIe9XHm2gfnLkSwr/10SCeoBcOBKtTHailS1raBvqZD1dzEHEU66QE5zU7DP7Swcb073HorQqOps68eL1MlVo2MWWozR7tY/t1Cm+34SeRLcIVco+0h/6ojboS3KwwpceZmkF2KcqTelqlzeIJzs0JoEd92w4kXII4WiI7MpUSvWgQvIMrGJJCxYbVnAdNtaoLuF2zlvdpcEfkdtIZwtdB05NeJM8tZeJg7eZju5vSB5P5ljY/CECEFIHEz2buMTl/TALZMT8fUHLKmL4KTbyyznnT1i2CRgf9/xjRuBf7esCD6gmDsiplz6HBFUrMI/IMvMKI8vlfUFt/HwciwOIvYB/OU3GJrd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Instead of blindly overwriting an existing table entry when mapping DRAM
regions, take care not to replace a pre-existing table entry with a
block entry. This permits the logic of mapping the kernel's linear alias
to be simplified in a subsequent patch.

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 0c3d97f120e1..bd2764f02a7d 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -256,7 +256,8 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 
 		/* try section mapping first */
 		if (((addr | next | phys) & ~PMD_MASK) == 0 &&
-		    (flags & NO_BLOCK_MAPPINGS) == 0) {
+		    (flags & NO_BLOCK_MAPPINGS) == 0 &&
+		    !pmd_table(old_pmd)) {
 			pmd_set_huge(pmdp, phys, prot);
 
 			/*
@@ -379,7 +380,8 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 		 */
 		if (pud_sect_supported() &&
 		   ((addr | next | phys) & ~PUD_MASK) == 0 &&
-		    (flags & NO_BLOCK_MAPPINGS) == 0) {
+		    (flags & NO_BLOCK_MAPPINGS) == 0 &&
+		    !pud_table(old_pud)) {
 			pud_set_huge(pudp, phys, prot);
 
 			/*
-- 
2.54.0.563.g4f69b47b94-goog


