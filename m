Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E53A9606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 10:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IjkX6dWg
Received: by kanga.kvack.org (Postfix)
	id 09CB56B05EB; Fri, 27 Nov 2026 05:04:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 025FA6B05EC; Fri, 27 Nov 2026 05:04:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E575F6B05ED; Fri, 27 Nov 2026 05:04:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7802A6B05EB
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 05:04:40 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D091140291
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 10:04:40 +0000 (UTC)
X-FDA: 85480464720.30.957C051
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2509D4000F
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 10:04:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IjkX6dWg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795773878;
	b=VOi79iwGbzjCDoao09bUFeKvViwX4DbQKI+3nYPZeUiFHY50UTcF6+tbaUQUqx9vH5M6b9
	+c6flmpu8KrxqZgMV3EXB1whu3bqvaEiMtv/LWnWxa7e2nnk+hYvagX6gprTlZMS2X6e56
	bd3pVoCnhDhWDxi8Twt7On5Ha/Iz1BA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795773878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=k4XoDR1GKascgjeA34cEeTWWMXYxiv8rCHJZtJu+drM=;
	b=YamHFcTgAdMqeQakNVPYRZ9lgY2L2UDTw2dsUxcYIX47jajJ9DJ8B8T1VAd2T0HB3cCpV/
	Wtfb51SIEKAIGXDFU8qwKsur8NaskYIe2mjozwnnA7VwrJ+Y3iUBLpgjPWIOF1kOMa/dqq
	jw9nRThTbAjqKpHi/qPIogzQDE3JfUk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IjkX6dWg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 916D26124C;
	Fri, 27 Nov 2026 10:04:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2A01F00926;
	Fri, 27 Nov 2026 10:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795773877;
	bh=k4XoDR1GKascgjeA34cEeTWWMXYxiv8rCHJZtJu+drM=;
	h=From:Date:Subject:To:Cc;
	b=IjkX6dWgjGwegOmdnF0EAWCS19T0N7IxLN/TQJtMnmCDP/eP4ZY8xLydQzT19L/s5
	 PaN27FNtwgK0maoJqNNiuOh7wpOQqaHugibzz7rQ3YHelTIi7P2i2ZY3gcXGnm905l
	 Hytgb+FdNlBBB2FVwNzm2KikCosGjYGtfXn2pyMFCgQYxoxDmVMUWRdFYk6MpKvSIz
	 FjNXEBTNAblR9UzXANEay8xmD7xXIQI5DyCIu2fI6qmR1Q5u/x6/5nTvJ9aMjVp2P6
	 L6T1lbN52q4QaBxtqbY0RDN+xrkEEAwNyL8xYwb65VBgL8tKTomezptTK7nKWDTEhA
	 QQEhIFsov63/Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 27 Nov 2026 11:04:22 +0100
Subject: [PATCH] kfence: use a nofault store to zero the guard page
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-kfence_guard_zero-v1-1-cb33d3ee653b@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/yXMQQrCMBAF0KsMf92AiVI1V5FS0mRSRyGViRVp6
 d1FXb7NW1FZhSs8rVB+SZWpwJNtCPEayshGEjzB7VxrrTuae+YSuR/noKlfWCeTU2iTs+f9KRz
 QEB7KWd6/89L9XefhxvH5jbBtHyjoI9d1AAAA
X-Change-ID: 20261127-kfence_guard_zero-fda6d21938a4
To: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Chris Mason <mason@kernel.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3475; i=david@kernel.org;
 h=from:subject:message-id; bh=FA1KnORt5pghKYxVih2NaXekTNZEkyBRBzqY7zjO5C0=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI5Q5dv+Lz3CyOnjytf2kcdx3NLr3+1YfOY5OK+M5Wh8
 ZPgRFaljlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACbyVJKR4W+Y7p3vL4Sz3/93
 +5+9WfT7++SOo/cl3R5o/eh1+lwaysjI0MeQN+noqZVp5yRkF00/LjRr0W3zpU87HDx/xlxOzi3
 qZgQA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2509D4000F
X-Rspam-User:
X-Stat-Signature: rgzsy6n1if1q1qaftzd6uzarkc6z1miu
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795773877-473202
X-HE-Meta: U2FsdGVkX1+o1Y5u3s8gMuyqehCjZsLRo8ETNPD4szeNMCd2XhZwrCuk1DwcO29SL4vvJm3FJr9tVQJnIn0NFgcNCHiIMR6dwO6xWgAg46HytCzwEhLYrvH61JAO8f4/2UYtXNpa28hJ2FfUSIe+2ANq3N6MAWg+GKDIiHz9d/Qy1a8WtODvKvTaK18LaIGDxAmVlR8wfAV7nuA8fAbaurMa9qbpV6VTJu2oVoU6Nf6PIuY/2JgLTZjLI5PgR3edVQuxW5D9OW+KhSzGXj9v/NqHWKSzUoE733OPoFLNUcgyzgthEztjnOxsHHEpk5Mi+7Bpb6MnjT/oUj2+WpxcwQDsU2+1ciSbfBKXfZ+Sk/ePRDr7MesDNp+8Qvj4HEvf4rR9Qz2HRmr0o6THuG7QQMxio4kX6f5vUGSpnkTDpxbV1Uao9iom8O0/YzZM8GdYlAmDrTtaXL2fxhMvnfWxWv6+QRVQXvb2wQdcv6YRvBxyyz0CnLsRUPrn4CgPGiXOXEBDIW274e3+tK88U7hmx2nhEOJoiGv4gymIrGpqVtXT7GUCFosY6F8NkXtjDI3g94yfP78u+GiO/6OGt3qVkTCv9FKfTy+92u6WP5urE+Bw0ROZZ5kC9y21RvrBqDNHNUa0Gk3ZrkVFUxxTpxsiTq1VWJCFmIiP1B4+JdYxfu/Yoiam6AXmpaPmIwvHv7j4H0jkJdpmRatCRKTlse0+rXL9I/90tmosNm7BYblS3yaFr+3NXE7ABrZH65Vf8plnZV0FSUiUQrTund0oAG/XaOvJOjlKa3mib4lIDlsOYBVjZYtPDuqeSuxEkIHpS7Jj3PaC1TE9ZhWcyf3shDROWZK8d33MymZE1wnbPYfBJ0FSb4Im1FbV/PErEPeXUejaHUJ9tynICBTswI2FF8fhYrdSufJ6qrb1ZnAw+PX9CUge8gpmLYLj80wMGcYumDhZRUyCWSYwQh6Kxx+v6JS
 5BoTmJrr
 jQLukWo3rO3LFum2C8+deLq7Z6JqtFYgAZfTXMmlHvoeKZORAjsuM4QExQYcYp+Yb4Hv0uBvwmMfiISZRf4+ZpCqzQbiCaFWhPMQfS0RUGoq5B5i+o24QASDRxz7+4iEStHru+p82FkBsMHTExH3sPDL0zH+68/i0nY2HPvSFYmajhvOYjYIjBKtuhXd+CDPdYRsr1gL/5SDZDJqpLmgkLjTxVNXhwmDKk6BVcNcwbr0qEgK2qWNGhFtJupkDQfuhrmbgXSd+3Qey6EIBJIkDahl8r9wvBpeEg5ASiMj4VP1FohTRHIw0ap0GI6rp0Ek4SdFZ+bnpe8UbV4IIBZH1ZkRRbGnEG0C2V2NkZ1uE2ExLJoyEZTcMaj2kQ0R4dSrl4HWx+JAiUwusbfWEeUV7/+fffFlvzTd48xUSvdZ0sp2Z8YHek+cVLwGwzSA8XNxW6HQsEGlsFeV9+XFAEXle+g0jr/dAbyfF981CKUS7Q1KW6HS6p6PetKXYcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

After an out-of-bounds report, freeing the reported object can deadlock
on its own meta->lock with interrupts disabled, or trigger a false
out-of-bounds report on a neighbouring object.

With kfence.fault=oops, this can happen more reliably, without races.

kfence_guarded_free() zeroes the guard page that meta->unprotected_page
points at while holding meta->lock, assuming that the page is
unprotected. However, the page might still be protected:

 - kfence_handle_page_fault() calls kfence_unprotect() only after
   dropping the lock, so a concurrent free is possible.

 - With kfence.fault=oops, kfence_handle_fault() calls BUG(), so we
   never get to kfence_unprotect().

 - If both neighbours of a guard page recorded it, freeing the first one
   protects it again.

The store then faults, and kfence_handle_page_fault() either tries to
take the meta->lock we are holding, or reports a bogus out-of-bounds
access on the other neighbour.

Let's fix it by zeroing the page with copy_to_kernel_nofault(), so that
a store to a protected page simply fails. All architectures that
support KFENCE try exception fixups before they call
kfence_handle_page_fault().

Skipping the zeroing is fine: either the other neighbour zeroed the page
before protecting it, or it was never unprotected.

This is a quick fix: nothing serializes the protection of a guard page
against the fault handler, so after a racing free the page can stay
unprotected and we will not report later out-of-bounds accesses to it.
Add a TODO as a reminder to sort that out properly.

Fixes: 94868a1e127b ("kfence: zero guard page after out-of-bounds access")
Fixes: da735962d05c ("kfence: add kfence.fault parameter")
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: adjust comment and description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
I think the underlying problem should be fixed at some point. If this
quick fix here is not acceptable, kfence people please take over and
fix it properly right away :)
---
 mm/kfence/core.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index bae787fd9baf7..02a07676ac7aa 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -33,6 +33,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
+#include <linux/uaccess.h>
 
 #include <asm/kfence.h>
 
@@ -553,7 +554,16 @@ static void kfence_guarded_free(void *addr, struct kfence_metadata *meta, bool z
 
 	/* Restore page protection if there was an OOB access. */
 	if (meta->unprotected_page) {
-		memzero_explicit((void *)ALIGN_DOWN(meta->unprotected_page, PAGE_SIZE), PAGE_SIZE);
+		/*
+		 * The fault handler may not have unprotected the page, or
+		 * freeing a neighbouring object may have re-protected it. Don't
+		 * fault, otherwise we can deadlock on meta->lock.
+		 *
+		 * TODO: Serialize the protection of guard pages against the
+		 * fault handler, so that we always find the page unprotected.
+		 */
+		copy_to_kernel_nofault((void *)ALIGN_DOWN(meta->unprotected_page, PAGE_SIZE),
+				       page_address(ZERO_PAGE(0)), PAGE_SIZE);
 		kfence_protect(meta->unprotected_page);
 		meta->unprotected_page = 0;
 	}

---
base-commit: 739e2d979b66be560b608a38c4ff86150ec090be
change-id: 20261127-kfence_guard_zero-fda6d21938a4

Best regards,
--  
David Hildenbrand (Arm) <david@kernel.org>


