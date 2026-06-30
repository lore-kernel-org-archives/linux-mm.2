Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A751C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:32:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEB6B6B00C0; Tue, 30 Jun 2026 03:32:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E72606B00C3; Tue, 30 Jun 2026 03:32:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C78426B00C4; Tue, 30 Jun 2026 03:32:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97BD56B00C0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:32:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 268861C6A11
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:32:07 +0000 (UTC)
X-FDA: 84935760294.20.ABD6DBF
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf18.hostedemail.com (Postfix) with ESMTP id 529B61C0005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:32:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=Bxl3YyLh;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=NzBLG2Mi;
	spf=pass (imf18.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782804725;
	b=VTcyu08sx/1wEjBkZpOfJaElZfsnRxp+mwAcHb3LIBgYZhVZqXcnfIDWSH4+angB2Yl96f
	BX7rpClrcJfnwjX2146UDkc/W0AXipoy038sdVlfpvX8VbYycyrAZWfldwhHcS4vQJBDlN
	WnME846/7TSLlNa4bBVjeugAXkUy8G4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oE77uZJY0l0QxnYAgs7xNyzj+GJUBJARmqc/YVyQTc0=;
	b=6H7wnV9EYTfKWE4URWgXMK/Q/Y8yEqZfyLI6con9n1MzzJgKhS2ejViyA1jFFWgLnKnS9v
	hVbigWUW0AtkGV8vO/GpBJVNa4GuoC6V0Yj6nnlfTcrqyuYgWacSrH76KNJomfpscSF6Cg
	2HiqTe3EpAt66FSS8GmCflJ88+uz7vQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=Bxl3YyLh;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=NzBLG2Mi;
	spf=pass (imf18.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1782804724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oE77uZJY0l0QxnYAgs7xNyzj+GJUBJARmqc/YVyQTc0=;
	b=Bxl3YyLhg9qt1mZo3c1jyTAFB0F7EpHLblvh+k5TVID31D3j4JwLdoQ02Hb2FzfLWpgEHD
	Dl7Zb4KkA7pTEqatFB42fRsNHxrrLTIFCWQmG2x5ZLs1a4oRfxDYvZ/r+JzKRDj1bNzJIK
	eF/RvAk90m518pLxWMlMpYfAaasM/UauNVZcynB58IcjGJwrVNap298OdzwUAsDkou1XVn
	yjhL5fJEyDjuQ2sEqhn8EDlbjmLpte5w5OgKNUO4+ndg7EkCfraFzOkP9OGdPO0KKphGoR
	RgVuShicbAPkCNjlt4Je9anLhljUsYpmvaAZg0eUyU8UgyETu1qROYGqoQAj/A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1782804724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oE77uZJY0l0QxnYAgs7xNyzj+GJUBJARmqc/YVyQTc0=;
	b=NzBLG2MitHx8d2jKUhpyXO/FV2MDmLIxia+qWIHuEkd1fPfbDa/b9/+ud2jOfk8y94t7no
	4agovJHlab26QRDg==
Date: Tue, 30 Jun 2026 09:31:57 +0200
Subject: [PATCH v4 3/6] vdso/datastore: Map zeroed pages for unavailable
 data
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260630-vdso-mlockall-v4-3-6c93708ce723@linutronix.de>
References: <20260630-vdso-mlockall-v4-0-6c93708ce723@linutronix.de>
In-Reply-To: <20260630-vdso-mlockall-v4-0-6c93708ce723@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Nam Cao <namcao@linutronix.de>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
 "Liam R. Howlett" <liam@infradead.org>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782804721; l=1779;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=yqs0awL8w4LoCZn087DSNqA873VFAAn2J8DEn2oDJxw=;
 b=KJKfshCQsaLaqMWDPp34LqfUqpxqh1XA0nl53TcmkAgeBUqnXrUsvERjMXGyHrW6ADuH4qY66
 gJQxO4JpMcaDp+XALMtIewme8WIRqrXmSa+x7WQlovmHmCeeMScTZeg
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: pnmhidg3t7tfko7xdfptaw7kpnkwccod
X-Rspamd-Queue-Id: 529B61C0005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782804725-695420
X-HE-Meta: U2FsdGVkX1/j3lFT53KALUMKbCv7JaIV0hcI8gRDuFnO6JYFwZNGB+D8ZvyOKmy8YPAqI+y5PCLKrLGv6Ib5IsyddAat7DO/wVhe/zRj99IL7IwKDRzbQ5nti3SZ6kxJ46z3OvRxyEWl6aN8OWiyNmME1NufFvcClbFMI6BFEvK0r6BCZrmEofHf21N+boe7+c7s3XPqrNqGUVGVi55H6SarEdHB/ikUGK3WRo9N6L0bv/DjhlM/6zK67ETdjpHUjVbbk3yQSZT8sdBsA9VxSB0lCr2OzWYXx3sqJMWaVovlI9p6rDUBuK0BVl3gIGvJHIn7Ww2KCA+d38CSg0QuNEpA26r4gYL1FbLdYvFKzKM+ApyPHS7VO38j46m8U6xrWQPPKnjd31hNqw0Iwl2ZwyN4v0hwfo7nI4NbWRmXsPviMfOZoRjutijzh85Q6vKurMN+deIKHxipGmzaEdHhBS3WgKMGR4Mxc2HRapL6M2KxJ3Nbe6yXLPHIAWbU8TWPbdPI7KwXvYD2aFxsZpuZ5aKwlcfZk6h+0fmsUI8pSGc+jvhaRl6dhMgeuUZPgkvEkt6vLRFRvJ0NBRcbtxjVn8RPz0uzXE67ZfeVD4NCDB4hv0sX6mIYIM15cLHXmYXq/WnwW0Iv1HKUHROnz+1zVHaql5r7aPz7FjZYU6RLfHKLCHRzUfBP64bfgdi613H2AHjBO6Zs0TwPjaAVMNDFlYOW+l9Dfg99vq4/WKh7V5ItJ6hHQJjKC26WVFZmvCPn1nO1qgINfOVDQwUEtd8nji7lTqFgaic2bPIIBqnewRI4mzeVI6EjBcGKiMj5JdVhpT6VAyx+nk/w71rn8azdskDU4gGQKdSjfDe10W5KYnuHMh9XqVGOvVUPvVRt8mw00oyIg8PXiXsoJh2+kzXlVW0cNuVTLRuzaC2OPsaIns1hFbvH+JngvP5Pk2Jd0+qu6vQXYKQMTz1XBQlJy9o
 2mbEUZeu
 yfJ23hiVzL0s0BCdow1L2hFYv59LqbLeciG7foEj+iqHsPCSfMjoJSLDusWD5CAf9oefD/3iotEYujAGMrNahjGma83YxEgZeWgaN8Rspgeo3qUgUDYKO0o/GcQuNNSzH+IKcCDl23vKK3i/LDgbnJUBUlF9tJwV71Obu+Xi0x0QoC/I/03GUs+rA+u2mODu6NdvvwT1oFwt63SEythkA8KMtqp2yHP5IuwORriyc68nbtEpopy/I04NvAmYMuBxOqov3NzydYqMVLRPwSR3UtStI/2wF1r4s0ZqEaREx0YdoV+FSRMEv5C7hhyIq+ZLSWVmm8p2kgxzzMgMD6Wv77AeoG/FbIwh+I+Ry4GYjPAc/vdE0P8+DlSzymFEqPfHWAybxny6aTHA5OVC/mOA/Xsu9tMlDadGBeKLz6NOjxqDxEYWHfTWZiB9Mig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mlockall() stops if a page in a VMA is unmappable. As the datastore VMA
can contain holes, mlockall() would not process all data pages.

Replace the mapping error VM_FAULT_SIGBUS by just mapping the underlying
unused and zeroed-out data page. The vDSO will not access these pages in
any case and for other userspace these pages have undefined contents.

This will allow mlockall() to process all pages within the VMA as soon
as VM_IO is removed from the VMA.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Tested-by: Nam Cao <namcao@linutronix.de>
---
 lib/vdso/datastore.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/lib/vdso/datastore.c b/lib/vdso/datastore.c
index e01db9607534..cf7aa80355cf 100644
--- a/lib/vdso/datastore.c
+++ b/lib/vdso/datastore.c
@@ -74,7 +74,7 @@ static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,
 	switch (vmf->pgoff) {
 	case VDSO_TIME_PAGE_OFFSET:
 		if (!IS_ENABLED(CONFIG_GENERIC_GETTIMEOFDAY))
-			return VM_FAULT_SIGBUS;
+			break;
 		if (timens_page) {
 			/*
 			 * Fault in VVAR page too, since it will be accessed
@@ -99,16 +99,11 @@ static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,
 		 * See also the comment near timens_setup_vdso_data().
 		 */
 		if (!IS_ENABLED(CONFIG_TIME_NS) || !timens_page)
-			return VM_FAULT_SIGBUS;
+			break;
 		page = vdso_data_pages + VDSO_TIME_PAGE_OFFSET;
 		break;
 	case VDSO_RNG_PAGE_OFFSET:
-		if (!IS_ENABLED(CONFIG_VDSO_GETRANDOM))
-			return VM_FAULT_SIGBUS;
-		break;
 	case VDSO_ARCH_PAGES_START ... VDSO_ARCH_PAGES_END:
-		if (!IS_ENABLED(CONFIG_ARCH_HAS_VDSO_ARCH_DATA))
-			return VM_FAULT_SIGBUS;
 		break;
 	default:
 		return VM_FAULT_SIGBUS;

-- 
2.55.0


