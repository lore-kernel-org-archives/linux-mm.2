Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 649D2606A682
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 16:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Zn7EyLAy
Received: by kanga.kvack.org (Postfix)
	id 7AF8F6B05B1; Sat, 21 Nov 2026 11:38:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7395E6B05B2; Sat, 21 Nov 2026 11:38:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6281F6B05B3; Sat, 21 Nov 2026 11:38:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 42D526B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 11:38:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BD000120567
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:38:47 +0000 (UTC)
X-FDA: 85459685094.02.6B49D5C
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0E11A100006
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:38:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Zn7EyLAy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795279126;
	b=wRMEGDGauljTs77sjeNyE6bFJIf67N3nqH2zZUbS/n/n3hQ+/38ZrWmlPFwFtmLvmd1D0z
	VRLMMTLjXE72ytMWKLbpOvpzRG87K5N5xcCUS6vpUB4XviI1F5TUzd6VfTe1YvEw0sb3nf
	Iq7LHliZI8FZpqhhBeMlp/aDbM5c57s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795279126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dfLpaiZKgialdhZmLohg/bMfGz6NinnnazUQ52qYpko=;
	b=nnIDGLd2m5mH1P7bh3me6GzLvGfdTi3gTr0d+xSQ9hsjvR84AqQNf/o1DvXlIJKwHbWO/v
	LR6QvinxCWVCpMhkqrvhG6Ow5pi6K2ySgUsH/2lztzbark5d+RUAPsq/g09v9I6dj5Rsdf
	cbb9/zzT8nO0wE3G3tir0ljQGW25JDA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Zn7EyLAy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4a357b1c649so1130480f8f.3
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 08:38:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795279124; x=1795883924; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dfLpaiZKgialdhZmLohg/bMfGz6NinnnazUQ52qYpko=;
        b=Zn7EyLAyZejMN+23jW4zsx2KxJNcBtpKNV8Gk09VMQMAjTlBfarQ5MNUoUzXBIFSx9
         1i2p1D7H8ReSfPY/omb8W3/xhCAdPS1EiLnEdlnJhdQVI3QyOHD7UewVzWPddNHHOz9V
         rb1YHlbHQcKzI8ojoNWKTpWOTUCakzS2lcFduNhUl/BqAP2P8oUFiNvDRe1oiWPzucDl
         x6lTS7xhHh76tvCvPu6BJDtRPv42z4VOT0nTLOOLI+vqP1nn3dDhvE0hZr9HswR/GgzB
         MXkn+1tyvcVOA3MmZRAuYE9fuh1KNplVni9mBiOtJxRg6+OeS2PsO9p8vqDuGBEmcKRL
         Gfkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795279124; x=1795883924;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dfLpaiZKgialdhZmLohg/bMfGz6NinnnazUQ52qYpko=;
        b=mXOQSKA7pqjaqmbV9BsrDEu4NHYtR+nzSkjwuZJt8/99uzHAsiEQg6L//kRKKv0rpM
         VWH/VtdQI5MFktDeEwtDrU5sIVlDOuVpuRIYy4NI7XYpgSuYpP3dy4Gt7uyC7S9HQfwM
         JP1T8O5bhfCb74r8yND+d0eqWRAS0SB5p2Pw6BkojEQTTPAJ33USzMG0wN1WJ5eZ+LBh
         MWCzxUKZOhwBSVZYQwKpDCSalOveCo9Vkk95TI+KOs+NdPn0ZXp5n0ZmUdof1UBJPD9F
         QtgGv6pW9nvJSNfElX2smBeLvsCNgpp6QAccWM4XR19FhO7YVFLJ6YOIXovOljkhNj9n
         EZUQ==
X-Forwarded-Encrypted: i=1; AL+hErF2xSBeCwxAof4LKYOK7LFKSncQ9o9HMWEB/vjwlbbJptlkgHEI2OjGKzLuU9pu9NpYS9DclwQM+w==@kvack.org
X-Gm-Message-State: APuU4Z+K51gTSUQWg3ZMuxjtOIYWjiAkY1OFivF+v3dIOLwTyZAQuktX
	gV7BgKk7fRcPGRHPGz7GI7/XtGa9agUtcIrO+PKJ32XhLpOlcG1RO6zA
X-Gm-Gg: AZFdTZerucWu5QiNHyetEVi2ahG0gabCsAgfWmOyMSGFeRP5synub/jQWEXf5lL8F4B
	iLPEsT3mudRzZ+VSDJ/5VPEvTzttnlMjjw4EhuIq3tPsgwjdMCHywvf6oSA/4RrNa00wkyNq8ks
	+sKcOjH1Diqi7Ao9b5Zb5hJUEfWwPCS9L7iMm3qK7hb1Q73ibTpgFfsWrL6vuDGR9XxlGUDz9Rv
	y4yubfpYl5w1kD0y1ch4HryodiMsrjbdVfFxoYBcUByXXHRTbkEeVa9b9ZGrSkbr5T2uyxIZsyt
	vwOfgbqG/g68Q5iqqKKIN0TvUmxcU4Ru5UoBKtbSQRsgPrWRTwqYwMrc7FsFcxRr8U5N9nGxuS1
	jQA3gTvIBsM2O3taPI6YYYzAh3KITptoR6bdc/NpT6pJ77hkn/jf+vtISZKSx+R+ty/ov+9Rec8
	fJhzJ3ojGRQrJrDeOhYDltCkWlrhxS9Ukadg+o8aVbu3WxWrLePlEWhqb58yUgAJ2Gv16ediEwm
	/LjaAdX+eni9xxy/0pzL44oPq0E8xmTXlBz9xu1s5htTMGapNh1ADijEf2LyYmFNTj1iELczQBH
	GshdHaHTSf31uppqa2N3uXr+Q7gq6YUvmjhpex4c9pkR/ajjFgeHfeJOaEhKJBbVgIsJfGMWQBQ
	k+bgUUbtYIi9D+GsXV/fo7MFYkJqd51cirKIXDAT++KLCoXTzf8Bqd7+z2skqbF2+rpXjhCJtjp
	Aqjxkequ3Lz/mhGSQtfQZaTIMblbCV7AuA
X-Received: by 2002:a05:6000:2c13:b0:491:fd47:5df3 with SMTP id ffacd0b85a97d-4abab02d216mr13249942f8f.7.1795279124204;
        Sat, 21 Nov 2026 08:38:44 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a02-3100-aeb0-6801-ad74-bca0-dc5f-7242.310.pool.telefonica.de. [2a02:3100:aeb0:6801:ad74:bca0:dc5f:7242])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab658e2e6dsm12468455f8f.6.2026.11.21.08.38.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 21 Nov 2026 08:38:43 -0800 (PST)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Russell King <linux@armlinux.org.uk>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: mm: Ignore PTE_AP2 in pte_same() for LPAE
Date: Sat, 21 Nov 2026 17:38:34 +0100
Message-Id: <20261121163834.15441-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0E11A100006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 1cpijmo3cugqcbbkrn4y9tg5tukh9xx8
X-Rspam-User:
X-HE-Tag: 1795279125-888893
X-HE-Meta: U2FsdGVkX1+6s/AwB6axjI9WHHPIpcj5o91bTaI2QLmylLH1MP/zdxUHB4wXu6ftFhd5CRPgCtaReASdEf/TRU9VHq+t4T4cUlzn7lAWqRboynAfRXaXrXxQmh/SxNn0+LkE9pbwVIGeW0t39YcF6dWYo2pqrR4poHXr6iLKr+LSUXXKISS+On6/nj8MO5p421FhD56mnPNnjn7tV2hz2Fa4oYgEizASPeFCYgJbeU5WjlxxpVlfTioS5gV+bGBSnmDtzOXmofDmUxPCSrzoIs3Q9idgRdd8tTHuuayZkIROWpqi+DF9Qx4wPZF9rvCTTPH/k4/lcrKXIRHZ2z9Wu5soZ0mQhm/khcMf4UBpyyAa5iVr8ZC7rrhKXrkcnUqCuRK3xvlGxaSWK0r7S49LiLLeQcZpvyEqVFi/waSu6V/tB/RLXij3avt0yKEBJzS+2rICXP1KkcNQvf1UM7iSTNzzIaqsCNcVAG1KTCykWWx7pImaBrfYNHT8Xfxass2rOl0JsgrHVO6uCbpOmWVpOC68A09BwzFZ3g0KOwZxD8Ne8taBHX4VmTOYqwzg1JfQpMbiu1eGKxbl/4Y02dmXYdjDW25xrXFS0RoGpMA7ePHXwpRsN2WT0SkGM4Erzox4MZmrByGswgmYIOor3942tHF2u4aoHjzzJPP79ZBIBuCpCzGr8uhhjOTB5/1aSQlTjBBrBD/ej/OfNCQbw6wm9yB584zpLeHFIHd07ZzPgu8r7gHJGSrvTCUPJvMLAWh5KHfMMf4jf944EBxBOe+331lDDnOTNYWN/gLSs2Zz5evKbhwqnxNblePrWH3WpdmteoopgdurHD3ls5Qm4ij5Shqr0fPD6OYvc0Uk5WhWZ5s2xh8EIK3/Rb24AvooZ8XBUr3Tyjzga8DbMNRE1Hg5hS0YQ56oiixPnijHpXR2bEHf7a1RGZCep4lXVt1NSweRxd/aX1XDhCTp5108gE2
 yhado3d+
 E7IzIfcr3aIKBICVKiIJ87euuHM4e8LyGtT6hruPKzWumO0TeCRlvY2pcyODBgE9bNdjMG4FKHNpldidh4z30z16pHkC2Slhccuz7tGODCRCKUavaTh0ZDJWvyptFEzIXiNE59sUqGEBRjw++m0dIhtuFjFEfHXcb99KHewJ+ch1mO6fIQJBcUi3ai+BFGWk0OmN+d3Y2ZIbe9ZeAP22/+P/5NiT5kv84s2zNlXkBcsaM5LNgD2tFMF2Vg6WG8iCtr8oqKEcUembOKMaruT0iyIBzIIFRQN6aIkTHjBccnBRbcvkCnE5GdEO19nGd/HRsS/K+qlyDp5q27lFEPJezg2rMSzAXSD9b2lrnFDqj7Q+jzQgZgzp3GeoU8nudMSt9n6Gd82JndJzDdfknPoIaFxPms3fGpRAollwYLQBn/lukPx8eEk7BODN0RndJiM/iXXSDoLiGIRJ+KME2JS+n2knDTAr7YtBl9qX155uMLqWzYoUyY77si8z8r4KqkKBGHQt2HjURbCY6qEk3Z2tQoKQQ5++PN0HsUAbj0FQjo3bSDnHSHO+VcfM61FzfoErU9CZ+N8q7Nh7tQSleC1rO5yFVAHbJUeHkX4Y4bolewK4g7hFlFNXHNQs2TCDMSX64fNVkdvZAnLhClPg1POFPf3jh0U0uPvUG0m7MvAWOqOi0C/dQdZocnS9VUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

For valid ptes, cpu_v7_set_pte_ext() derives the hardware read-only bit
PTE_AP2 from L_PTE_DIRTY and L_PTE_RDONLY. pte_wrprotect() and
pte_mkclean() only change those software bits and leave PTE_AP2 as it
is. Starting from a dirty, writable pte, the software value therefore
has PTE_AP2 clear while the installed entry has it set.

KSM hits this since commit c33c794828f2 ("mm: ptep_get() conversion"),
which made write_protect_page() return the software value instead of
reading the installed entry back. replace_page() then finds the stored
entry different and gives up. After a failed zero-page merge, KSM can
fall back to a regular merge in the same pass, so zero-filled pages
end up as ordinary KSM pages instead of mapping the zero page.

Mask PTE_AP2 like PTE_EXT_NG for present ptes. L_PTE_DIRTY and
L_PTE_RDONLY are still compared, so changes to the dirty and
write-permission state remain visible.

Fixes: ded947798469 ("ARM: 8109/1: mm: Modify pte_write and pmd_write logic for LPAE")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Assisted by an LLM.

Tested on v7.4-rc3, multi_v7_defconfig with ARM_LPAE and KSM, as a
32-bit guest in QEMU (TCG, cortex-a15) and under KVM on a Raspberry Pi
400 (Cortex-A72). 1024 zero-filled pages merged with use_zero_pages=1,
and test_unmerge_zero_pages from
tools/testing/selftests/mm/ksm_functional_tests:

                     ksm_zero_pages   test_unmerge_zero_pages
  v7.4-rc3                        0   fails
  with this patch              1024   passes

Unpatched v6.12 shows the same failure. If this is better handled in
KSM, reading the entry back after set_pte_at() in write_protect_page(),
as before c33c794828f2, also fixes it.

 arch/arm/include/asm/pgtable-3level.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include/asm/pgtable-3level.h
index 7b71a3d414b..4a187d7be1d 100644
--- a/arch/arm/include/asm/pgtable-3level.h
+++ b/arch/arm/include/asm/pgtable-3level.h
@@ -161,11 +161,15 @@ static inline pmd_t *pud_pgtable(pud_t pud)
  *
  * To correct this behaviour, we mask off PTE_EXT_NG for any pte that is
  * present before running the comparison.
+ *
+ * Likewise, cpu_v7_set_pte_ext() sets PTE_AP2 in a valid stored entry when
+ * the pte is clean or read-only. PTE_AP2 is derived from L_PTE_DIRTY and
+ * L_PTE_RDONLY, which are still compared, so mask it off as well.
  */
 #define __HAVE_ARCH_PTE_SAME
-#define pte_same(pte_a,pte_b)	((pte_present(pte_a) ? pte_val(pte_a) & ~PTE_EXT_NG	\
+#define pte_same(pte_a, pte_b)	((pte_present(pte_a) ? pte_val(pte_a) & ~(PTE_EXT_NG | PTE_AP2) \
 					: pte_val(pte_a))				\
-				== (pte_present(pte_b) ? pte_val(pte_b) & ~PTE_EXT_NG	\
+				== (pte_present(pte_b) ? pte_val(pte_b) & ~(PTE_EXT_NG | PTE_AP2) \
 					: pte_val(pte_b)))
 
 #define set_pte_ext(ptep,pte,ext) cpu_set_pte_ext(ptep,__pte(pte_val(pte)|(ext)))

base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
-- 
2.39.5 (Apple Git-154)


