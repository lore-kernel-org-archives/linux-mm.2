Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24F7F1061B04
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:33:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E3526B009D; Mon, 30 Mar 2026 10:33:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893576B009E; Mon, 30 Mar 2026 10:33:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A9B26B009F; Mon, 30 Mar 2026 10:33:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 686946B009D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:33:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E034C2162
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:33:54 +0000 (UTC)
X-FDA: 84602973588.28.C61525D
Received: from mail-106120.protonmail.ch (mail-106120.protonmail.ch [79.135.106.120])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3EADE40006
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:33:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=YCCLybHY;
	spf=pass (imf17.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.120 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774881232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qKJp2zmpSOHrWvXWXvVfm1wRsYfpExx2ugXRE4WLUFU=;
	b=p/QJ7Q5jO8sUkTMPBlQfX09zGx2bNdM9ZrKprXtokxyV7EwG8LEI2bqwIMpQ8akfvGSlVd
	e4PTq3dv9soopQUJv9GYAw2db5sPNqCD4I4VbwIYSgawxs9w7dEo/GUZMBFysoxbHcBqsb
	XeLgoomk8U/CunUJwfLg9Q5MWgNWAXw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=YCCLybHY;
	spf=pass (imf17.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.120 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774881232; a=rsa-sha256;
	cv=none;
	b=xTeV3ucIkpUOZlpErtTCSloG+3RaWta/P0vO3TV+IicD6jci1mE7zwpfAbv5wG5yXmmpbd
	CcfMm0lbPG0YdeKIXtS6TKx4IL9FeUrr25Kh3A7nZ++YBbusxs38pVqW0pdBsaS5mBsXjc
	MU84HliixaWWITkuLrn/7udBUKlP8FE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1774881229; x=1775140429;
	bh=qKJp2zmpSOHrWvXWXvVfm1wRsYfpExx2ugXRE4WLUFU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=YCCLybHYi2wR2wkPVJqxMiQnlVDCKaRSAc2GM2k4yVvHs2+q/xLGEQmy1ci96SVPe
	 ksL1M18aqk3T+U81SeRfTAWcLdzwSjTjKzqLtI5QiW11A2y/FbKAgTDTFezGKbYoAs
	 lAy3jSe2vY/cAgrClSZfcuKZoRSF7SKoG67G4XwdHpD0urxhJXKPrz3bPaiOnXM/Ui
	 px6s72vg+QThjq6CrchL4qKa25I74kOJnsRR3TnWFM0ryokXew0zZb8q7bsoodgWSt
	 di67Knp/aRc8Pf3yWTXpGD6Nd1f62Xm3hy/yNYNx8I4T65ECLLumqOMlhrURNFi03W
	 R0Nvo9JsEbLdA==
Date: Mon, 30 Mar 2026 14:33:43 +0000
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
Subject: [PATCH v12 06/15] kasan: arm64: x86: Make page_to_virt() KASAN aware
Message-ID: <b9f7bd991dd2ba0b4c187f5c63962626f00c6a62.1774872838.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1774872838.git.m.wieczorretman@pm.me>
References: <cover.1774872838.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: b6d1646a2fe7b6e96ef4cb8b05ca936c4900195d
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 3EADE40006
X-Stat-Signature: cuqyt1jztqzog357oww17m3whismx5hg
X-Rspamd-Server: rspam06
X-HE-Tag: 1774881231-937499
X-HE-Meta: U2FsdGVkX19IjzNgQB4cOaG1VQY8UREi2Uf8ydAj8WOsLxZZpOGF9LuEJCAutGxAgR00qg0ZYb7yUyCtGCaw+lc2cu1u3p6JE35r/CfLCNzSO3Kpp1sp1+q8KRfGYSHmScSSLbrdM5Hltvedxv+24ZOnzdvSACUedwH0qeHKLy0DLrwMubcd8LUuC+ukt3IR0PEwmcNFBzW7zPOr+8AjFjRyx1972qOMXqg5mIybWrHTuS2u77kjRbWk0SyXh3py3Tk55EiUxGu+LrqD5PX4V9bS/URD2ttFYeCzYD3aR4WgKyOorLyVQbRS6wOiHzlBXjdk9gjKXAUyCi2ZogwisavHWSeo47cDzb3dcDXaxH/VA31mo6G4CWy+3vlDADtXpJQih05cl+bghKHJqhumAf7I/1PlzbPzXp/xg6BuB8WuVNOBNqqZUYDrYW2uLFrZlj4zVwy/4EcAEpjPVxfDtJdIxAbBbpX+9FFmlyaKtB4awmSkKw8yBFKZSMt/PS9w+n607Wbnp0WiTEaMd8D8gAHOyxpuUt0W7ek7h118zzv142Sc1SlYKZEsd+ko7yggfp/OdoEYvYcuSRpRF95say3OLUdeivTVQ/vfm+oMETG9nf4UUMrSn5zeVxY2NrERt/moQ7crd22mKCWEYzkT9rUEAyjhfu9LgLjO+oYqp3eptCquItKV22FN3PRixFztbqZP334t5WXrYSiido1QhLHq/gEwNSfU0p68erOqIUqycUqz4k+bzLfU2P3hpBFIYA64u4HPu2XADXRDLM4Ydpc2+s6B7DHe+bEnYOcVmdJZ0MRGwmBYw6hrBbGk42uikyqAOX+xlj44fzOBoA1GvYUAlOpohfwUQbVD3a/vT91EAWwMx7V3Qf2S9n2sstkJM5w+nTnGJZb/Q8Vlc/wpwFEc6jWdzZLhfDAyMTnj9wKny1+HeLRBKRJLpw3V4ieLntPkZlN8fWMkNntt5xM
 rIUo7Au0
 Y34js/LwUwJOIiEKwLpHQshzXDKvDZXlO3TDIYs9PlTFCEukp7JZQTdy2vAsGb5MWjWSkw8re3N1CZmDICui6mGRH3Fp0iS1G4TH+6dvbGmdGa3ueyQHXQ47Q4Rzp4xjdrYsMGu3yoMQ0eyF9nVCMyPItzSiD2FUQuS+ao+F9bjs43HFT9N7yzb0ioU28piHFc7+Zt+D5fEGsUI5OFx+gqNBkWjpwYFDo63m9K9tNkXrsKQYbcCO2hoYsHQ2UeuKc3zx0vokGYI5wzcQ0D08E0ny99jWA3N+18fcAIpThdGzZyXvPz+YNk476ALebLQXH6Etqd3+4Uu7Cyi1MKXiW+5CjtQHfjsAqzOBqMKWAB87wQcZ5rhaCVURRf0RVF5N4uoHZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

Special page_to_virt() implementation is needed if an architecture wants
to enable KASAN software tag-based mode.

Make page_to_virt() KASAN aware in arch-independent code so
architectures implementing the software tag-based mode don't have to
define their own implementations anymore. When KASAN is disabled or for
architectures that don't implement the software tag-based mode
page_to_virt() will be optimized to it's previous form.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v11:
- Redo the patch to work on the page_to_virt macro. Split off changes
  about virt to phys conversion to an earlier patch.
- Remove Alexander's acked-by due to bigger changes.

Changelog v7:
- Add Alexander's Acked-by tag.

Changelog v5:
- Move __tag_reset() calls into __phys_addr_nodebug() and
  __virt_addr_valid() instead of calling it on the arguments of higher
  level functions.

Changelog v4:
- Simplify page_to_virt() by removing pointless casts.
- Remove change in __is_canonical_address() because it's taken care of
  in a later patch due to a LAM compatible definition of canonical.

 arch/arm64/include/asm/memory.h |  5 -----
 include/linux/kasan.h           | 10 ++++++++++
 include/linux/mm.h              |  5 ++++-
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memor=
y.h
index 875c0bd0d85a..39dd0071d3ec 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -411,11 +411,6 @@ static inline unsigned long virt_to_pfn(const void *ka=
ddr)
  */
=20
 #if defined(CONFIG_DEBUG_VIRTUAL)
-#define page_to_virt(x)=09({=09=09=09=09=09=09\
-=09__typeof__(x) __page =3D x;=09=09=09=09=09\
-=09void *__addr =3D __va(page_to_phys(__page));=09=09=09\
-=09(void *)__tag_set((const void *)__addr, page_kasan_tag(__page));\
-})
 #define virt_to_page(x)=09=09pfn_to_page(virt_to_pfn(x))
 #else
 #define page_to_virt(x)=09({=09=09=09=09=09=09\
diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index e18908f3ad6e..271c59e9f422 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -527,6 +527,11 @@ static inline void *kasan_reset_tag(const void *addr)
 =09return (void *)arch_kasan_reset_tag(addr);
 }
=20
+static inline void *kasan_set_tag(const void *addr, u8 tag)
+{
+=09return (void *)arch_kasan_set_tag(addr, tag);
+}
+
 /**
  * kasan_report - print a report about a bad memory access detected by KAS=
AN
  * @addr: address of the bad access
@@ -544,6 +549,11 @@ static inline void *kasan_reset_tag(const void *addr)
 =09return (void *)addr;
 }
=20
+static inline void *kasan_set_tag(const void *addr, u8 tag)
+{
+=09return (void *)addr;
+}
+
 #endif /* CONFIG_KASAN_SW_TAGS || CONFIG_KASAN_HW_TAGS*/
=20
 #ifdef CONFIG_KASAN_HW_TAGS
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 09044934dda8..f234650a4edf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -117,7 +117,10 @@ extern int mmap_rnd_compat_bits __read_mostly;
 #endif
=20
 #ifndef page_to_virt
-#define page_to_virt(x)=09__va(PFN_PHYS(page_to_pfn(x)))
+#define page_to_virt(x) ({=09=09=09=09=09=09=09\
+=09void *__addr =3D __va(PFN_PHYS(page_to_pfn((struct page *)x)));=09=09\
+=09kasan_set_tag(__addr, page_kasan_tag(x));=09=09=09=09\
+})
 #endif
=20
 #ifndef lm_alias
--=20
2.53.0



