Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C831FC5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:12:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F02236B07E1; Tue, 18 Aug 2026 10:12:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED6296B07E3; Tue, 18 Aug 2026 10:12:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E130D6B07E4; Tue, 18 Aug 2026 10:12:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C214C6B07E1
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:12:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 59AF2402A2
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:12:49 +0000 (UTC)
X-FDA: 85114581258.16.5449CDB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7C2881A0007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:12:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=P2m3rdwp;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xbplVkHgGYVeclYwcMZL8ms81hMZjXWcaep67+GqB4M=;
	b=cxb56np8eMyHdbwZF8Xq+yaDvXFo1yUmHMXDbQ0N6uGkistV0V+OrdVWVCFgTdm1eL5/9Q
	Ie7baZ83v2YZhAsnu0T81pw+Bt40FoWYiUB9XqqQlw3miJ6LHVqle7lZQlPhqJ1VJVf8KB
	BdX97inRZWgXJRFnVI3PT5S2zcP59pQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=P2m3rdwp;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062367;
	b=l26NaYzDfnQyaAc+am5QLSu+4eNNr/+17p6TrJcMCcvMibTxBbTSC6ymO8OcButxeiy086
	GSlCizQ0vPivgsl1RYNrQWK4dY5MTcfCjo7r5pQ3FpsBzG+2pzA7+Cjjq2QwGtQegnGZqm
	ipszW+I22PsfClzJPJcPlEmqyu9ObRs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D16B019F6;
	Tue, 18 Aug 2026 07:12:42 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18F7D3F85F;
	Tue, 18 Aug 2026 07:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062366; bh=iuHkFnsaX/6Wt0s3WtH1IONd8/3ory872W49q7NS7GI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=P2m3rdwpn8gldKYtBm8KL2r4oRsqWcL6F4o9V4G1tHbB9srkk9vFA0BAp6B/ip/Bf
	 DhMaQ6Xxpn03eOKwneq4rpz1kt+g3ozd9u+VJVAa0N1WDaGpub4I3T6nYdFSt9Gy87
	 3AS/bnhvOioX+O6k5Rh1LreS5iCGqFFulLtL87RQ=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:08:59 +0100
Subject: [PATCH RFC v9 17/25] arm64: kpkeys: Support KPKEYS_CTX_PGTABLES
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-17-743ad31b2c8f@arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
In-Reply-To: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062276; l=1174;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=iuHkFnsaX/6Wt0s3WtH1IONd8/3ory872W49q7NS7GI=;
 b=gQpjqvXD2ZEiIo5C/DaU185kZh9RB40StHJQpTmYLw+oVULaoiCKxWBhlNqsVRUbfAHBBpWZ5
 ky64mKf7BofAZgocHn4n2s+Xwk7Tk0745d4hmHnkcMMlGVjYgkG/UC+
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Queue-Id: 7C2881A0007
X-Stat-Signature: ijdfrst6ju3okcky7kadxr3xz7gsb9jb
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787062367-20762
X-HE-Meta: U2FsdGVkX19SgfB/J3rT0vSy8ByDA1iW7ZO3WMyIqdmQ1ls3dj6zonpWZnSWiw0es5ICWUpgAdfmk5TzHlr0sgf7cMfTQwhlSdxJlURRhGbsYT3vwfVpjSbPFe9FiOwLk6qMKFUn8A9MjQHa0nHRWlX5d/RoDAwdm86UYYon7F+r+KnrN/pK3ZMZ6bHtY5xf2zRTp3myHDyBpm8Q7Cfc0g1vQIJuRFGyd0OLo5gBm6PnTehokbY3mybMObu6gtGkXOpDqrXT+BcW8MPzUqtHRZaNLcYueNTel+zmkyfqA9VN98c4b3k0oaOIkK6/o6q6kyOFMf5Aswu4F1xiNwDS6sfoJ29Rm7/w1WE5km9NUAzEsrPOd523gqynJefaUWAsJV3wz3AVAkODQdA7HZnoJnRJFwI5/F0spY0peA2eq7dfVRQ0TLDSlesWqijt8+wVSqyJXtNDK0H6YaB9rEIwT4uES3/CXTyHErN+V6iWgyFUc1WfmS9Ba0zlRCvbGH4r/aBvqJQGGgvnBi8KLSxllqTWDbkonSNOfZJDj+lSw+S4Ndslo0iQda2oy00exdcqrNToy6T9gXPh3J0htm1gaL29jc5uad8W2CAaDLLYgzOQx++3FN7JYYd+6eFwWZmC3QwV/RNwWg2qV8gagaos1VvJBJcTKKJjHhdjGWoojsVfgdDxcJUNE8P0iCr8Q1yJioRbpG9gjlaYv+SHa/Hp8y/TUsyAwJXJrmIXiS5MMWIypJfIu6nSjADdUL9mTcgEfRVjtI7VdAFwr52S8v7ZfvHBek3AB1eLN4IOOkpqi/cCD1ZlrmtBbcRz4BghrHVaX86H3y9NWUOehEgcuj8RetswIrfZ768M7ddfShUnrRJ/nzkZQkNAEuFp/AdyKxpnnjUe5wvyMVFkkXWlRe8ip3CdUzdxM2tNNIu1Z58v4OVA1bXMLwnDgP9cQEjWmfyvBOIS2R1gqdg1Ysba6Sc
 ox2Fy0up
 W85qdrj+1hoHbTdAWXJdIsr6fy2rZHE4b1ZRrSZjbKNspjdanwrn3H6UwNTUURvrdwA1N2iNZqQY8gMir2YlSPVxDZxFds5gLRrOm8pc8zayWZKmlwP+64kLtnYCMnPZU8wXzKyzVwcizFEL3AvVR9tnE5QO4poRThDa22tWWYTTEE6HxxdXqU6zIC0xXdttaMwlNnghJq6WELhVe9UFg8lq85MFRhpxWL1giu3HQhYrQuU0rFa3hkV+NqGoRQ1p0XfOm6C/gCuawNmtn2mIaeL/XANLhmlhzSSlgn8j3A66ULzw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable RW access to KPKEYS_PKEY_PGTABLES (used to map page table
pages) if switching to KPKEYS_CTX_PGTABLES, otherwise only grant RO
access.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/kpkeys.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
index 284039e9a244..00e7e5956794 100644
--- a/arch/arm64/include/asm/kpkeys.h
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -12,7 +12,8 @@
  * Equivalent to por_set_kpkeys_context(0, KPKEYS_CTX_DEFAULT), but can also be
  * used in assembly.
  */
-#define POR_EL1_INIT	POR_ELx_PERM_PREP(0, POE_RWX)
+#define POR_EL1_INIT	(POR_ELx_PERM_PREP(0, POE_RWX) | \
+			 POR_ELx_PERM_PREP(KPKEYS_PKEY_PGTABLES, POE_R))
 
 #ifndef __ASSEMBLY__
 
@@ -33,6 +34,8 @@ static inline bool arch_supports_kpkeys_early(void)
 static inline u64 por_set_kpkeys_context(u64 por, enum kpkeys_ctx ctx)
 {
 	por = por_elx_set_pkey_perms(por, 0, POE_RWX);
+	por = por_elx_set_pkey_perms(por, KPKEYS_PKEY_PGTABLES,
+				     ctx == KPKEYS_CTX_PGTABLES ? POE_RW : POE_R);
 
 	return por;
 }

-- 
2.51.2


