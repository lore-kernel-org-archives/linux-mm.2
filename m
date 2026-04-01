Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B89F510F92EC
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 02:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A2916B0092; Tue, 31 Mar 2026 22:33:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 253406B0095; Tue, 31 Mar 2026 22:33:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11B266B0096; Tue, 31 Mar 2026 22:33:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA6D66B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:33:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5772559635
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 02:33:35 +0000 (UTC)
X-FDA: 84608415990.19.51B5440
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9438118000D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 02:33:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=juSjYxBs;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of ethan.yang.kernel@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=ethan.yang.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775010813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3oo7dkEhtHT7VYXAhK0i4yVbZSa70g5LexsTV6nJgOA=;
	b=DD/uzeug2sMem4jC7ojX5hIUpX1ZoeXSXkEHc/DJp1CkMkgZnK3yIHBB45M888cGLdNx4F
	vJLRo950sMEBT9PDkze/8XGlHvajPURz0UyLbR6zT4GAtbv/8bpXpSDmRiwyuxTWsQlnut
	FAYgGlqfVenKVtW6TyxeB891tcDt+y8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775010813; a=rsa-sha256;
	cv=pass;
	b=HNTbssTeObS7iQ391mFx+q6I7NeFTmkZ3k401UPtI0f691tHFHm52lisGO6IQRkZ61dsc/
	389Nfv4xxQjfA+cjMYedBQaJvMuKXlhbBMnBJ5YHzjA85Tfpc8DNPdpPDoACInuAqHwoNp
	P6h3msAM3NUJnRBZNwmL5jX2u+RpG4g=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=juSjYxBs;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of ethan.yang.kernel@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=ethan.yang.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-38c551f2497so58349531fa.2
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:33:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775010812; cv=none;
        d=google.com; s=arc-20240605;
        b=g1gF26QhvvU2Ot03PiPXIlRyGl7a9KbjrERj4/Jlvzy2N79S5A/2+qzJu6iiHBVQMe
         wFB9RjN/4MImSfqv2DqX2jKyIBURz6Tff4bVjY/2cAM1bgOK77dfWFGzsg3kUGJXwtTr
         xMovElYTjiBlWT4eeG9puO+75zscR5sRuOHzzUpVrHp3SNPZilhVdKubF/G9irf1DMCc
         unHqkJ2XSJeqzGH/8rgbfPsFgzGXQXdpEiHaYlO64bKn+LYhlQ4cOJdd4Ucfi+ZiuvZH
         3xCICfbqWa0F34TfgwNy9qOgWqDNIWJI7+fiO3bvzCEIPETZKIm/i0AMcDRDsAudari0
         IVfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=3oo7dkEhtHT7VYXAhK0i4yVbZSa70g5LexsTV6nJgOA=;
        fh=lO9YYszM98OS7q+m/45mevj24CDMRujQ3HSq2rB0Pmw=;
        b=K2cD7F9JwjziCEy9594WI09o/JIvXN0TIcY+AC4RRbjoZmKy34ts7TqBFo0XremvuC
         wWEGFNLqst0uj68yvAqeb5hUQPAwm+N/cGC8jKQ5frfGjyxFSD1lwGcYISUOiH/G7M0/
         cVtuFalrExxML9L6zJH86c2jLJosksPe63Dp8v29PTLNNVcXz5TB0i+DvO17xo38QvJB
         qmWoRe9T0akfxVD79LQk0bYafnHpE8XN35pXWJCcr8rfsT/L0PXTfh+aqc3tHx1OYqg3
         y5UoDQcP9n9jt8Nvvf4QIrqIYMJ+zND4F3+WGJ//H3SEEA/q0CvIQ8dhLIhAeW0/RZCR
         c8JA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775010812; x=1775615612; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3oo7dkEhtHT7VYXAhK0i4yVbZSa70g5LexsTV6nJgOA=;
        b=juSjYxBsTsd6nCMMjtOuuLVkoSBjaa7BlhYud6tw/UhgRTxW3eSBmLdf+nGUJ4T101
         nBmHNMKQzoWH/bQnvc3kaYQc0Y9MCTRE8KQSEhhoQX4T0Dn2TnCkFN+aiiuwpnAYkcts
         /Zx7WAaATNyVf3uuCy1HGRGSVH6pRYN0wDg2eCTIQc4T6+zsrTiP+obYs72pMwe7KGKV
         qS1OXdC97Zu/ZjHx1hXRx4FkUGXUncrsSeFVQsCYPtCiGko6p7pc8QPGkfstxNVOUxPM
         N/XQpHDK91XTer6TxMjiX7BLiRp/i1FxQxOdrFDCbBN9a/ey0soI+OhC+MSg04+xCQTQ
         D2mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775010812; x=1775615612;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3oo7dkEhtHT7VYXAhK0i4yVbZSa70g5LexsTV6nJgOA=;
        b=XpclIyueMwu4tfTKkgpPUF6JkO9Q7x6D6iNYhqKxdxWltyVOFhmk0bch360pQPSMiH
         oNzxlpDvNCoABFCHOSyXq9eqJNenNBWcsDJTWezSK9Typ9YqPsaf/5UFkd9tvP5sdfnU
         jJ31jU03j22ipmNwineVwXmOsjB8QrVDttZPdRJa6cfUOhzpEoHmyNKT9Y4sFp9PxWK7
         XizPijsLVBSh0fbp0O82cXOkcpqOY292nO3E64lp0dSvDY9K+M1A0WbnvjIJ/W5HYzMg
         hqbqqcmKb6CUNrjVrg8ZpoVF9lsuydAUsw2ibNgNumAyNv0Q5oDKyJX33S4uyQn3FK44
         13lg==
X-Forwarded-Encrypted: i=1; AJvYcCX0I/MPZWP+AreDiuoO6VSeInk6IQ295NF4JIACTbI5dtWMydCXmHhvmCh+O8WtuOFzl5HtxH8IJg==@kvack.org
X-Gm-Message-State: AOJu0Yw14wMaUNEg7j6eV3fp3CGod7VI6+CClagD4v7XoFgeG0t4RZFh
	E1YSHtUFpWW713BRoNv7nYZnk02RtSut3raZIWH7XcqWig0BC9t9a1y5pjkjRYVLSBSAYAkSdiZ
	N/DuHaaXtRxIUK5f5+w8PEoNpWq5ecUw=
X-Gm-Gg: ATEYQzwBWN71t21w/+XeZLHdQVxgGRVKjZOgc14vYJMYJWJst65I6cR/Qv8pXs2sQmI
	oNwepntwEMTLLoLezIgcdmm+M23ZB6Xd7MZq5o6ErdtnwSkUkkJjU4kzTUblbczUBhpiYMf2+m5
	377p7XPOI9RGFWhhQKKybLRS04H/lf7gPxuwzoLrDY2DJxQor4MK3Vijdr2yQgKdoCLgK46Zqp4
	7ihps9U8/5twJR0TGiMjChCcc2xA+up2nrxyPLsyVJBRpKScvWutzHJq6b21cI7F9w=
X-Received: by 2002:a05:6512:2308:b0:5a2:c0cf:451c with SMTP id
 2adb3069b0e04-5a2c1f23dd0mr689913e87.24.1775010811374; Tue, 31 Mar 2026
 19:33:31 -0700 (PDT)
MIME-Version: 1.0
From: Ethan Yang <ethan.yang.kernel@gmail.com>
Date: Wed, 1 Apr 2026 10:33:19 +0800
X-Gm-Features: AQROBzA9KQDCoKz5kKkfvNz3IJ9AlhJH5Qkpot3vhbFR9ZDzxPncYWR5-rTeLmQ
Message-ID: <CAKeWACY11_1JL_OagfxUhQckW4rkAjhwXxUnVHNPdHF60Uc81w@mail.gmail.com>
Subject: [PATCH] LoongArch: mm: fix FLATMEM ARCH_PFN_OFFSET for non-zero DRAM base
To: chenhuacai@kernel.org
Cc: kernel@xen0n.name, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, akpm@linux-foundation.org, 
	Ethan Yang <ethan.yang.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 9438118000D
X-Stat-Signature: wcpdgtx1bzzc4yc6gqyasepc3yt91rjm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775010813-253391
X-HE-Meta: U2FsdGVkX1/dqzT+LmZVvRnuN2eIT5cPwpMCHLeJEvgQKi8H8wQmg1OEbiSXPBsMQTYc8orPUcVtM5Yy7mB2QTN+4+xYfVYgOHfEbi42F1loA3cDNoPonLcbBp+ZHDoyoOkwap6oqBj9YfHd2ODwd+A6CuBN8jnv+gmAHRqeJodbzPgqunK6RikE+dN/ls++8Ryk9Hoq5AtKOCxdoLH44lRGXc3hmxsevzs3yiji50n4NdYnecZTv3r4itKi8RzoZgC94A3FYWpR80hBRV657rJZjrJUt4T2eQAXgF1gemotwnAdw1nysCSAuTJO8nrprW4n2WeIR67DoyD6bIVS0O73BAAvMFrG9t0QH6hNxsBVvI4R5e6i6OxzMdP/WtdW+1rOgnMWWZ+q6pbptCJ0D2bMkjzU3IGBmdfBItiVQNbkVcQsUhnyOwxXVmt5SWlemDUZvRCHVuBQ1sc4CQVSnP7dSTuT9R6smhmKAPESB6EtmSJct0VUc3QnOZTlQQYu3sB05UYE6E0NRA3YxPl+ORAr1RbsLiUyQ4yfM/uwawy5MV55bbbw7dT30AXI0ePZXUqUy1WAALONHDI/h0fZzxbaaZ6Z/iUqYzYZFADLq8te0eZi6tnytM98LBMROu/0qFHp0uKuh6ZiFhqgm9CxEcMpr8uo5M4FgNkKnn/VkYJXdajZsfOjVcbhHmXYWjXsLKAcszbFLBACeWb6vhFPt6bW16su/UAEF22VOAcNdbtxp+ECdD6MhDqq+tW3QM/awoGYzigZWTNU0+lNJ8Tur9mpl6c8cikLxqoo3hVuDPhaaN0kGWAF9v9LXmww+N9lAvvnllRaJjcgBFs/vEMzEsw0mBOYfsxO+nQjXtBZ24MJ6nHrjNc64O5VNu7vFxQJR3dyTXMzU1lVbY8BGU7uN3yco0Mqt6ydwIkl4WLtWnfT9vp4OJesS4xr5BF4WKlWirCWFs+b1ViUy+LAx/X
 x1I4v7xN
 dggikmvTitKYCizG6ucZCdPFODhBcAK6IOFqN75SuoTX5MRyM+STsR5Wag8RmxTw9kxmv4GvaQ9MB2IBZi5Tk8RLjkHLzJMLEGQqT4YBAX9vykOeWmHhue2kGhoHagyeAxxc/bKD/e1YJ90WegoPyzrzr3tTRVnt0plLRmpiSP1/ndGxy5jJUFxfW9sqChrQ1lDS9IKSRk6fO4TGo4rm4Cs95cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ethan Yang <ethan.yang.kernel@gmail.com>
Date: Tue, 31 Mar 2026 21:02:26 +0800
Subject: [PATCH] LoongArch: mm: fix FLATMEM ARCH_PFN_OFFSET for
non-zero DRAM base

With CONFIG_FLATMEM, pfn_to_page() is computed as:

  mem_map + (pfn - ARCH_PFN_OFFSET)

LoongArch currently derives ARCH_PFN_OFFSET from PFN_UP(PHYS_OFFSET),
while PHYS_OFFSET defaults to 0. On systems whose first DRAM range does
not start at physical address 0, ARCH_PFN_OFFSET becomes smaller than
the real RAM base PFN.

As a result, pfn_to_page() points past the intended mem_map base during
early memmap initialization. This causes struct page initialization to
touch wrong entries and can lead to early boot failures in the
memmap_init_range() path.

Fix this by deriving ARCH_PFN_OFFSET from min_low_pfn, and initialize/
recalculate min_low_pfn from memblock_start_of_DRAM() in LoongArch
memory init so PFN-to-page translation matches the actual DRAM base.

This change only fixes the FLATMEM PFN base and does not alter the
existing VA/PA linear mapping scheme.

Signed-off-by: Ethan Yang <ethan.yang.kernel@gmail.com>
---
 arch/loongarch/include/asm/page.h | 3 ++-
 arch/loongarch/kernel/mem.c       | 1 +
 arch/loongarch/kernel/setup.c     | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/page.h
b/arch/loongarch/include/asm/page.h
index 327bf0bc9..80aea8b51 100644
--- a/arch/loongarch/include/asm/page.h
+++ b/arch/loongarch/include/asm/page.h
@@ -25,7 +25,8 @@
  * used in our early mem init code for all memory models.
  * So always define it.
  */
-#define ARCH_PFN_OFFSET PFN_UP(PHYS_OFFSET)
+extern unsigned long min_low_pfn;
+#define ARCH_PFN_OFFSET min_low_pfn

 extern void clear_page(void *page);
 extern void copy_page(void *to, void *from);
diff --git a/arch/loongarch/kernel/mem.c b/arch/loongarch/kernel/mem.c
index 8ab1ffedc..03835f8cb 100644
--- a/arch/loongarch/kernel/mem.c
+++ b/arch/loongarch/kernel/mem.c
@@ -46,6 +46,7 @@ void __init memblock_init(void)
  }
  }

+ min_low_pfn = PFN_UP(memblock_start_of_DRAM());
  max_pfn = PFN_DOWN(memblock_end_of_DRAM());
  max_low_pfn = min(PFN_DOWN(HIGHMEM_START), max_pfn);
  memblock_set_current_limit(PFN_PHYS(max_low_pfn));
diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index 839b23ede..625be2494 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -394,6 +394,7 @@ static void __init check_kernel_sections_mem(void)
 static void __init arch_mem_init(char **cmdline_p)
 {
  /* Recalculate max_low_pfn for "mem=xxx" */
+ min_low_pfn = PFN_UP(memblock_start_of_DRAM());
  max_pfn = PFN_DOWN(memblock_end_of_DRAM());
  max_low_pfn = min(PFN_DOWN(HIGHMEM_START), max_pfn);

-- 
2.47.3

