Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 586BFCA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 16:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 784FE8E0007; Fri, 29 Aug 2025 12:46:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75CD68E0001; Fri, 29 Aug 2025 12:46:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69A038E0007; Fri, 29 Aug 2025 12:46:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53BCA8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:46:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0AF79140832
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:46:31 +0000 (UTC)
X-FDA: 83830373382.07.8F0C579
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 88BD240014
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:46:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D7s7Vq4s;
	spf=pass (imf11.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756485989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZncrKmkfYm0ifrU3KUl6vWqS0G4T0Q5iBTPG1MeBPms=;
	b=1IsCgTpJ9qnlWGRtm6n7Kw6sR88mZrx+e3F0bN6el5l26+f+WCvhW3YxQqdpUveDb6O5tZ
	LxlJGnTDayKyy2xSejpDDFk1a0SYXdZX2jNEpk05QHXrujTliMzHkL/Q6yQJwdQppARRdC
	ezWhZlnISR7DaFfsFYdk8A7y3fdYhe8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756485989; a=rsa-sha256;
	cv=none;
	b=NWbZCIFjJRzt1yUMQFFlQJ60/hN7q6bdSg6ski+6AxZUw4uD0i4Bm2I+FIe5WFakeZxbOl
	7eUuTEHysN7WG6jwCgEaOOJ6DCHMV00DSPAs0wizwmHDvQ4v2Y26e5NHO583YoLDpwRDXu
	XcZ18kORntOq05igSBXydq059anFNUw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D7s7Vq4s;
	spf=pass (imf11.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E2921601BC;
	Fri, 29 Aug 2025 16:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4098AC4CEF0;
	Fri, 29 Aug 2025 16:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756485988;
	bh=PVpX8+3IqfXg1/WqFGH/rwOO8yjTxELXA5EvlRBBMZc=;
	h=From:To:Cc:Subject:Date:From;
	b=D7s7Vq4sTLna4JGv7jkxQ+Glrr41wNqIFZ69f2jS4N2FgRPGmazU+mT1ZYZzT5MVh
	 LwQyyPST7pEiUz3aHpak0Lljjs3HeIDhDI8/GT4d0rdFISmukYSF4Di7IQj7wg9ZnC
	 qGkcxoyXLAwblIEMk/jdBFjlf2lGxe6iU1r69UfzpAXg+noHlUGrshDhdcAoIIz8OZ
	 5YYNaFWce9bM32WI5JN4tExtDaxX8Qwvgmh4VHwZclzus2lxqjkwvOFZwM1tgG9+0j
	 u9koKe3Ideu6bNCDCTWB2yqDzvJEpyHbQ7ebrvFOvN2iIq/kJsNNTVoB9fE/PHICzK
	 gnTUnH8Qg2m+w==
From: Eric Biggers <ebiggers@kernel.org>
To: Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	kasan-dev@googlegroups.com
Cc: Dmitry Vyukov <dvyukov@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] kmsan: Fix out-of-bounds access to shadow memory
Date: Fri, 29 Aug 2025 09:45:00 -0700
Message-ID: <20250829164500.324329-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 88BD240014
X-Stat-Signature: 7xdhiyeojrj5dwhkiifbkpbht4i8936o
X-HE-Tag: 1756485989-930636
X-HE-Meta: U2FsdGVkX18mtxivZEKhVbQAtzae/WQY04bGFkj4oe6Ny8v/JHu/WYIDYCrbFK3D6HU2MevLt+Hx1Yp1Gpw28NL/9wI3lggHXvUDWLHIh85adn3gxQwhlsbEqiXXZiQ0UEUmOj90x5lMXO2lPH/m9QYLkxAr0fMeM1lBMP9wyDzagBaPlzX81HkFX/dRosZ0AyNqZZWNQB9KikjVQGYzoJdwgm/yv2/qAS8nRLWrK+cMYmADCYkqaBzAihz49t7JAnMPMH/91XjaTpomMO+4xACXzdqyLX+UE/5YXIqS7yTVza1z91aIyW8O5zcuO8EiYWZvmlPPo3bsp+vh2ZndYgaagmC7FvgC8Q/ddjNwAb8WD1F/LTrbRi953nQc5Eim2kVl/5GkHtcPSvorY2iXTwJtmA69siwIrrY8R7K+WFq/5fpkvf9u7L2FCDG0+4GGGtOUeuD5+ILLnkyF2erxOFipSwntdVfQeyUkMwaPPjvfZJRCeRWYapKNh0YbEK9WCYE4ek9eEZc7Zo512024eOLG/nGbB4O8W+yYtDvyH1EiiYIUk+uHxYWWKYQ9QaPMe3nNRSZkJcalp5RNwN6RMPNDVlPxQ6MP7eGUAzAbRVxogC/xH+Yn6x17Q0QoJjpfSrcZDCqzjNCGdRMGej2WepKCayV/rfsU8i3FfYdHl2OD5LAJux+6htISI/lUVe3BLh9JwIUxZ52iuPJKABfZ7j8LYDqJb7TdJsnW8l0+VNh5wqFVWXQBCdjREziXm0O1HbR/NPRVbrM9QoV99iAqQ4R60XeII5cVPIvv4k5bb+MPh/MuRoX27+DQmA0cK4D/jOO/NKIE9vfI8hRnrv0rDc5YbUsteVAh2k5LDuc/OQrlZOziE6FPqtTOtNCRWV4f+X43cntXMsR52eJzOELAhmcUYT6EVtuaxsh0MOxAILm6YeiHw1JM5GbE0t0N/6h1hQEFR3Qt66wGUlxXfPK
 EN4G9jTg
 TkypmbtB2Sktkb7vXKLuofL1ofe+4fWoTE/rVPhSuRy9Vin+VJNl5QiKbSrmGwGGyGJ4f6wELfYDyzFsIeT42uagJdtTOHVHrMCLvkdFp1qwpyvXmgJ8KRh2iO5QJtGkE6Zcpmn9Sl642jmyvkRmZxy+eGV630gs1quwVSg198vxWQl2C5MfWv0lgC75cyDgwt0pZGOp4Gm5EZTifqAt+FNOBh3+LvCWJo3tbrXwv1S2z9TxuE9QRVqlsgjMlIl1WxiyPCWc10j4WbRLBchKtn1qP6+fFTjjkTACI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Running sha224_kunit on a KMSAN-enabled kernel results in a crash in
kmsan_internal_set_shadow_origin():

    BUG: unable to handle page fault for address: ffffbc3840291000
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    PGD 1810067 P4D 1810067 PUD 192d067 PMD 3c17067 PTE 0
    Oops: 0000 [#1] SMP NOPTI
    CPU: 0 UID: 0 PID: 81 Comm: kunit_try_catch Tainted: G                 N  6.17.0-rc3 #10 PREEMPT(voluntary)
    Tainted: [N]=TEST
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
    RIP: 0010:kmsan_internal_set_shadow_origin+0x91/0x100
    [...]
    Call Trace:
    <TASK>
    __msan_memset+0xee/0x1a0
    sha224_final+0x9e/0x350
    test_hash_buffer_overruns+0x46f/0x5f0
    ? kmsan_get_shadow_origin_ptr+0x46/0xa0
    ? __pfx_test_hash_buffer_overruns+0x10/0x10
    kunit_try_run_case+0x198/0xa00

This occurs when memset() is called on a buffer that is not 4-byte
aligned and extends to the end of a guard page, i.e. the next page is
unmapped.

The bug is that the loop at the end of
kmsan_internal_set_shadow_origin() accesses the wrong shadow memory
bytes when the address is not 4-byte aligned.  Since each 4 bytes are
associated with an origin, it rounds the address and size so that it can
access all the origins that contain the buffer.  However, when it checks
the corresponding shadow bytes for a particular origin, it incorrectly
uses the original unrounded shadow address.  This results in reads from
shadow memory beyond the end of the buffer's shadow memory, which
crashes when that memory is not mapped.

To fix this, correctly align the shadow address before accessing the 4
shadow bytes corresponding to each origin.

Fixes: 2ef3cec44c60 ("kmsan: do not wipe out origin when doing partial unpoisoning")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 mm/kmsan/core.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/kmsan/core.c b/mm/kmsan/core.c
index 1ea711786c522..8bca7fece47f0 100644
--- a/mm/kmsan/core.c
+++ b/mm/kmsan/core.c
@@ -193,11 +193,12 @@ depot_stack_handle_t kmsan_internal_chain_origin(depot_stack_handle_t id)
 
 void kmsan_internal_set_shadow_origin(void *addr, size_t size, int b,
 				      u32 origin, bool checked)
 {
 	u64 address = (u64)addr;
-	u32 *shadow_start, *origin_start;
+	void *shadow_start;
+	u32 *aligned_shadow, *origin_start;
 	size_t pad = 0;
 
 	KMSAN_WARN_ON(!kmsan_metadata_is_contiguous(addr, size));
 	shadow_start = kmsan_get_metadata(addr, KMSAN_META_SHADOW);
 	if (!shadow_start) {
@@ -212,13 +213,16 @@ void kmsan_internal_set_shadow_origin(void *addr, size_t size, int b,
 		}
 		return;
 	}
 	__memset(shadow_start, b, size);
 
-	if (!IS_ALIGNED(address, KMSAN_ORIGIN_SIZE)) {
+	if (IS_ALIGNED(address, KMSAN_ORIGIN_SIZE)) {
+		aligned_shadow = shadow_start;
+	} else {
 		pad = address % KMSAN_ORIGIN_SIZE;
 		address -= pad;
+		aligned_shadow = shadow_start - pad;
 		size += pad;
 	}
 	size = ALIGN(size, KMSAN_ORIGIN_SIZE);
 	origin_start =
 		(u32 *)kmsan_get_metadata((void *)address, KMSAN_META_ORIGIN);
@@ -228,11 +232,11 @@ void kmsan_internal_set_shadow_origin(void *addr, size_t size, int b,
 	 * and unconditionally overwrite the old origin slot.
 	 * If the new origin is zero, overwrite the old origin slot iff the
 	 * corresponding shadow slot is zero.
 	 */
 	for (int i = 0; i < size / KMSAN_ORIGIN_SIZE; i++) {
-		if (origin || !shadow_start[i])
+		if (origin || !aligned_shadow[i])
 			origin_start[i] = origin;
 	}
 }
 
 struct page *kmsan_vmalloc_to_page_or_null(void *vaddr)

base-commit: 1b237f190eb3d36f52dffe07a40b5eb210280e00
-- 
2.50.1


