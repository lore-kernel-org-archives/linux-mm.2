Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E0ABC9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 18:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2865A6B0095; Sat, 26 Sep 2026 14:39:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 237296B0096; Sat, 26 Sep 2026 14:39:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 126676B0098; Sat, 26 Sep 2026 14:39:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D691A6B0095
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 14:39:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B6D2408D1
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 18:39:38 +0000 (UTC)
X-FDA: 85256776836.29.CF8766B
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf24.hostedemail.com (Postfix) with ESMTP id A6E6D180002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 18:39:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Prl7x92i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790447976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h0enCh2MRlgPpYIWKl5Sr13FnH5bGjxfJsgRmd5nwro=;
	b=BSJtUKrbfBNEeBRKcAmpo3RjseOa6BmgnWA7BwXpxAkWEZOEHnRn2fZkQwNHFlRt/ai+mV
	+LNYq4iWN2I5FrvxvOePEtxdjt2te7XkZSqiEWtv0k3RBEN9VJ9+7aNo4lK3t0GfTxKjYt
	hdd4Qx0zboOEuxOxES0AE08+0sGKStQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Prl7x92i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790447976;
	b=jQezin+aYfLNvmjLuz+sSms2VfP5att/RbC43Gdv1irj18ROLIJWfw0OSNeq+Co/Qt7vTA
	2Ge2egppFjGiHVcT3TDRF39vgwg++jfrXJzzA3CSeGnvAW0rSYbgiQ7VErHBGhZXQT1UBq
	kbwiwCeDXHLQ43Bd+rMpldyFxSa00So=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49ffbd83a92so4153485e9.0
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 11:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790447975; x=1791052775; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h0enCh2MRlgPpYIWKl5Sr13FnH5bGjxfJsgRmd5nwro=;
        b=Prl7x92iaCiW3wQ5VHQhTE9rkmfwKnMoIPqgFrC3kMAdYymP5fNGVkliPImjoNx9Pr
         fu2d/nzImbLa+KkSXLrPhq7xCNC43MF3PHtikN2CvyS05TwX1pO91Lq9319RCXH1eqk8
         +ZuCMV9JnUcURcSu+Ld43e5y5G843IGH8/8Jlb2OPKjjVyjmd93nfKq6UIe2sr+YGVs1
         6qEV4Wh7ShQUuUf5Xqf+zWTjxWOjfsUbJAchtFu4iG7J9lfFp3h1rY0edIhVmwrPMyZd
         7JRWB/u1JwCtdGDKDScggF/bZyDB2i9ICsqcY+Wiv/NHlNUqZgOF4tj4H+Kzxywcd9hH
         f1Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790447975; x=1791052775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=h0enCh2MRlgPpYIWKl5Sr13FnH5bGjxfJsgRmd5nwro=;
        b=h2nG+BKnx341crG03veJ37yAfUvSPyfh5rfeTwug6GsUu8BpjAc3Iwv+eDS1u4eOWC
         6yb63Buv2jgcu0TenRCnz0Jj4v3LgMISanDcDDdOlHp7fPgOos7GyGl0DOhteLZhNQLY
         Och7M1mHENjGfL10J4M7YEWyPUX88jkE3erJuOWiAyy47ypptEqOJ6IQspbg084wGE7L
         tiF3TulkOrowlkC7hWDzrqX0TsyvvSBxDyply/x1b88TTIqQq4PABNig+zpzx53nrQkN
         RDvn+komp/G0nYxVDGy8mb67WxgEZaHk9plJ2ZMAA+sJ/P8beNrGuVHLYlE6dqKRn9qB
         H/sQ==
X-Forwarded-Encrypted: i=1; AKwUvBzcVauK6fQ1TjTtuG2hBHCGbRmNlb04yJ2eUhhOE3SOxJpXw3WiZId9OnlhYsJj7aKA2fdgomrD+w==@kvack.org
X-Gm-Message-State: AFuF++m43lZmNjvQCmB+qhqHb+VfDnEa0As2ySa6mL19XpLQURgLo1rt
	PsQYDOTPlgF+9X5EsTCWvtDdbPckkK5pBGX+fd8D40lAdCWCBQymE7jA
X-Gm-Gg: AYBFou1jtqxRFPsMOuJDvU9jhh/OXc+hHfAL9yenB3KJFIFt522pyvQjty39uHOcSCg
	za/KemfeTsbVl2ngr5prfAzppzjzxwSo6VJmu4texy9dPBKYqUlmrMkgMdY86Uw0af5o4J1fp1w
	Y0g/svat1NVA/S+lEsTYJnuyizevQ0k6ODDSTJXI65haoX/ZAjUQzx4+OJKVIOUenbQmkUKQz5n
	M0OJTW9SrPGLC7l/KEhGyyWcEN3p4jF4ReUEu0SPLYxnJmy7iydH/OiWaHIaU2O01gwgjw3nvDe
	MH/MxCYkn2JDke9rIr5uwKwSsBClkxhFtzeTTCI58D88Ick88kLzMavZMzw6lzSOtcZ9OYqSM/8
	bMfT2P4ODtzyFb1sDyyT6Sl7AkjVfRoYDjQADExZXzQgvzkixKGmFDNSsGSOZYtmTEKXkfdy/N0
	Cz3SqHxKXT1VLww2nkiLG+bLM9Z9QP6A3w1tRcMvIGQfHKtoWSHHCiyFwkSP5gtd/j2/g3PFIdV
	2JDTlMSNJDGzDcG4NHZTLt1eoZODauhkI2M/g+a+88k6hBOUgaDqiMO12JOr/AqH1f9nebjRznl
	+g8EG8r99FQyKZRSkc9XA1KBU9KCwMdyORPus+SGqMnjXpZMP4Tq1IkEXuk5G83NHYYYzcgg84Z
	5hHd7JIc9d+op
X-Received: by 2002:a05:600c:4754:b0:49d:1e09:694a with SMTP id 5b1f17b1804b1-49fe66d2ce2mr162026765e9.11.1790447974930;
        Sat, 26 Sep 2026 11:39:34 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b162-c701-4960-a998-3de8-2fce.310.pool.telefonica.de. [2a02:3100:b162:c701:4960:a998:3de8:2fce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a648895sm15430376f8f.28.2026.09.26.11.39.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 26 Sep 2026 11:39:33 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: linux-sh@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: [PATCH 1/2] sh: mm: replace the page size bits in pte_mkhuge()
Date: Sat, 26 Sep 2026 20:39:03 +0200
Message-Id: <20260926183904.76186-2-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260926183904.76186-1-kmehltretter@gmail.com>
References: <20260926183904.76186-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 6uwbmpibsg5q6imzdd8m8und6pb4sn9c
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A6E6D180002
X-HE-Tag: 1790447976-714526
X-HE-Meta: U2FsdGVkX1/Y4+oZP+GgRMCx36YQIHTbKbTYvJtJsNYMycpmOnbrbPfeYAHucoDyUdPXS/oU6RYR0Pt6FEECMjecjjGyREwEWU2eixZ2esztjwgR2tz/N6k+WihW+tly8TJ7cRQS+AUsxoetqG9mh00yjprIMa2v7nBJKRnBOhuN+1Pm75JRGcX1ISj980+eVFv/WJNtzRp/GJ+XLbxklYIWTe5QY49fgldT52C3KX8kH1PFBjvzt/osQ5X8RashkHcwXIoRVva3WvDxYVklbINt2gpW7cqUwxrLAT6jyob7RJKlilSBT6tRUrXERI5TPJv6OuJWlZSlyXt/WHN3TtEceoAceJC7hQlNM4IRHj0bBZ6zb+fWKhIrAuKdluITXrsuN/MIwvyWheqZbMn0RxDMZdpubvzHNjY7kHF3tuvvD0atiCIT+f/3Ifl11tistGkCI6KZ6RCNGUjvihpz5woVEILN3B2H6JnHtuGx+2Mc0Wz/BPVpsiUeyoupcvHZItmO+C6XJwzZUC8T9zAcAqaZwn0VCMpcdwOjJNxKGXK8Z312AFRUZlKOljAnvp4ygHkreG/eOrbrfwws9sHtyHs4has8A11S231i06+UEg4vGT7P82172n8PRds/P4VLQlFhxMqZzHcTYH9bkBXDm4KrNNlgb3rCzF1oq2j9rEZCCEsk0gUoWZXnD6TzoyOcTeFkq/L/z7aaB4CVd5CMLLKbCxpXpa/QNOF0CZeApvIRBzepzBJS3JsCMQLi9QSULw/sJZ1abTGNClDRzQhcRXh1ocNilNIWD7irHRJwaxACTISVxzITuitIxTBeuP5TYEfji2tH0IZs6C8fBpVgRquiz+hp25C0YfSRt/rxYZtlHIBoPiA0c8kYZ4HRpY+QKOtfxsWefXuLXk73R5vTb5qWMSBMIEbBNoQ0V7ONJ7U7svoqWiiYX1qgtCu223iRnlYRfAVU3IfxUB9FZgx
 geRtOMUI
 BDAMtJ0L93cob0P/jIV8Mid9e4yzUyuD1czRJzfnjHIgviqIyw5klH1qv1X1yUBgG1Yq9el47kIvfhdPizsexoaWdqL1aMWRK6X6uqAUeSE59ZeOaqFUEgD6WI2oOnuxpRYpoesKtCzBkUW0w7vGHKy8btgBNP8SZkZWA/DxYojg9trL7fHr1mwLFb2voyUqs5wpFzmxhA1tpkNnCkcJoNzKhVBqo3xGxRnwTDIqhcnmfSJ+bJXoPwARXcxDcy1ifmE/dkiN4fiHHZdXkN1VuD/cfV1gY3PPFo3s67Vz17KHXT96UNZoR5+i5zOk4ICBLa9ZlO3xJ1cNFBLwJr8rkzT/L5CrRrps2PlFWbtxApzRrNyBd0v462jaWfAKxRDts4+e0ihiFTQ+WSO5fr2JM8X0T4bksHi/WQW5LnBCljzyP9k4LQiYNCy7+1MrYfYmrdZMM2d/kDpHRLhCDGN0cZ5iWWNkE/Xv1d1AMeCO46punEgs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pte_mkhuge() ORs _PAGE_SZHUGE into a PTE that already carries the base
page size from _PAGE_FLAGS_HARD, which every PAGE_* protection
includes. The PTEL size field is an encoding, not a set of flags: on
SH-4 with 4 KiB pages and 64 KiB huge pages, _PAGE_SZ0 | _PAGE_SZ1
selects a 1 MiB page. Every hugetlb mapping is therefore loaded into
the UTLB as a 1 MiB page whose physical base is the huge page's address
rounded down to 1 MiB, so user accesses land in unrelated kernel
memory.

In a QEMU r2d guest, after touching a MAP_HUGETLB mapping at
0x30000000, QEMU's "info tlb" shows

  vpn=c0000 ppn=32e00 sz=3 size=1048576

and writing the two huge pages overwrites kernel data, for example
page tables ("bad pgd 5a5a5a5a" on munmap) or a struct file:

  Fault in unaligned fixup: 0000 [#1]
  PC is at file_tty_write.isra.0+0x24/0x220
  R1  : 5a5a5a5a

The SH-X2 extended size field has the same problem: a 4 KiB base page
(ESZ0) combined with 64 KiB huge pages (ESZ2) encodes 256 KiB. Only the
configurations whose huge size encoding happens to contain the base
encoding, such as 1 MiB over 4 KiB on SH-4, have worked.

Clear the size field before setting the huge page size. All hugetlb
PTE constructors, including huge_pte_modify() on mprotect() and the
fork/COW paths, go through arch_make_huge_pte() and so pte_mkhuge().
With this change the same entry is loaded as

  vpn=c0000 ppn=32e00 sz=2 size=65536

and the mappings read back correctly after mprotect() and fork()/COW.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 arch/sh/include/asm/pgtable_32.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/sh/include/asm/pgtable_32.h b/arch/sh/include/asm/pgtable_32.h
index 5f51af18997b..1e6821a23eac 100644
--- a/arch/sh/include/asm/pgtable_32.h
+++ b/arch/sh/include/asm/pgtable_32.h
@@ -145,6 +145,8 @@ static inline unsigned long copy_ptea_attributes(unsigned long x)
 # elif defined(CONFIG_HUGETLB_PAGE_SIZE_64MB)
 #  define _PAGE_SZHUGE	(_PAGE_EXT_ESZ2 | _PAGE_EXT_ESZ3)
 # endif
+# define _PAGE_SZHUGE_MASK	(_PAGE_EXT_ESZ0 | _PAGE_EXT_ESZ1 | \
+				 _PAGE_EXT_ESZ2 | _PAGE_EXT_ESZ3)
 # define _PAGE_WIRED	(_PAGE_EXT(_PAGE_EXT_WIRED))
 #else
 # if defined(CONFIG_HUGETLB_PAGE_SIZE_64K)
@@ -152,6 +154,7 @@ static inline unsigned long copy_ptea_attributes(unsigned long x)
 # elif defined(CONFIG_HUGETLB_PAGE_SIZE_1MB)
 #  define _PAGE_SZHUGE	(_PAGE_SZ0 | _PAGE_SZ1)
 # endif
+# define _PAGE_SZHUGE_MASK	(_PAGE_SZ_MASK)
 # define _PAGE_WIRED	(0)
 #endif
 
@@ -359,11 +362,11 @@ static inline pte_t pte_##fn(pte_t pte) { pte.pte_##h op; return pte; }
  */
 PTE_BIT_FUNC(high, wrprotect, &= ~(_PAGE_EXT_USER_WRITE | _PAGE_EXT_KERN_WRITE));
 PTE_BIT_FUNC(high, mkwrite_novma, |= _PAGE_EXT_USER_WRITE | _PAGE_EXT_KERN_WRITE);
-PTE_BIT_FUNC(high, mkhuge, |= _PAGE_SZHUGE);
+PTE_BIT_FUNC(high, mkhuge, = (pte.pte_high & ~_PAGE_SZHUGE_MASK) | _PAGE_SZHUGE);
 #else
 PTE_BIT_FUNC(low, wrprotect, &= ~_PAGE_RW);
 PTE_BIT_FUNC(low, mkwrite_novma, |= _PAGE_RW);
-PTE_BIT_FUNC(low, mkhuge, |= _PAGE_SZHUGE);
+PTE_BIT_FUNC(low, mkhuge, = (pte.pte_low & ~_PAGE_SZHUGE_MASK) | _PAGE_SZHUGE);
 #endif
 
 PTE_BIT_FUNC(low, mkclean, &= ~_PAGE_DIRTY);

base-commit: fddfc3ec31799a932bb92f1b8a84cb3d1f963be9
-- 
2.39.5 (Apple Git-154)


