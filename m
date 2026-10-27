Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 142AA606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 20:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ecakqe2i
Received: by kanga.kvack.org (Postfix)
	id E48376B08CD; Tue, 27 Oct 2026 16:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1F2E6B08CF; Tue, 27 Oct 2026 16:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D37E76B08D0; Tue, 27 Oct 2026 16:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA98D6B08CD
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:09:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 265111602A3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:09:27 +0000 (UTC)
X-FDA: 85369495974.16.BF3C465
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C79921C000D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:09:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ecakqe2i;
	spf=pass (imf20.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793131765;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qCB2VNIuJaytvnyi8XURzmlcjZmcQYR874A5wGXc/C0=;
	b=QGq7K7J01YRPPwGZIhBpZkIDkWnZD/UAxa5EtGessPi9rYJGU7SW1YzzqMsvyFQlYC0nkp
	S/EKrIcNmekLLpBEFateNc+3C7Xd9ogC0QhJQo4C5bxVlBNUFnojgvRlHWPmgZ035Wyd+I
	oEUBRXjmR6gF1Xgy45MmsuLMQ2szUiw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793131765;
	b=t2zRpu2VUF0QZjQWbd0Bdkgh2+c56IS4BGpQ0CeNCyXQ0GsH5tvtJZQ8IWdWJB24MdQU73
	TIgOT5+wBtjz9N4kcCuSK2M3QjEer7gzOYzOBc5vHPnSfVe2HggD2PppECMQV4Hzvl90Zs
	00JwbncaXTyREqIctsf7M8JJdKJLPmo=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ecakqe2i;
	spf=pass (imf20.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C2D741FC1;
	Tue, 27 Oct 2026 20:09:24 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793131764;
	b=cXbW7ExwM6MIMWp9yxGA+QUuxdViCRoIl9gUtoPh2fb1GJ6+MRvNMkW7V/NIavoXhQH8
	 HIsuWYpyenz/uxOU1t5jD/0fRpHH8oVYQ1iu7VI5V4DtxP90W0URGSWSbMWdYh+dWhQi4
	 Q35dM3f/bV31qaEOotcWVWQBA9k5SBu92/2cc8bacbroCakqUyhxHzPlS/UjWf8Khs9a0
	 +8qTXtuAh1nallAumYuai37Xp7cQxNplwDLeKE6XJJFyUAIxGrRjkfSPiDB62YH9Ujj89
	 CZgi7pri42ZNP4ldG3OI7YoK/4qH/BqREekGvSSGI4M+AdaBBZDC35M14lxG3N6wI1w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793131764;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=qCB2VNIuJaytvnyi8XURzmlcjZmcQYR874A5wGXc/C0=;
	b=e3CjuIW7lvA0XhbjTpqRRG7eGwGF9uQex4V/Pe75veT5nCKSZ32Lscva1cVwyzNDi0yU
	 F46AkM5muu0i9k2W9FMNZ58k5jAK7q3WbxHt/WlhDC4gU1H1rDGLQwCMTVU0KVTSyMIch
	 YWj+NJJB854uk5S4N+FwPGPJ8dtF8VdtFCb+0nYumlXdF8cmutjUw5EDSp2Ym2TU9eS0/
	 eOR+VwC5r1Rrj27f7G3oFBVTAoFab0/ud4tF24CUS7hACLawRSZYylseXaht5/sRz7on/
	 kcgFaPFq136IgaRmdcYCAuUx7ARYTMkAeZ/Rwiav3Bkf+6izpycpRJvMEmUtPlfvsMg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 89A211F01825;
	Tue, 27 Oct 2026 20:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793131763;
	bh=qCB2VNIuJaytvnyi8XURzmlcjZmcQYR874A5wGXc/C0=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=ecakqe2ijzu+zd4Vn1EhzS4EAsMhu1JCHwRExSlEPvkq2DXhaPoswpJrvqCNLsp6R
	 ZiE5EsVL3fHbQRskZFaWuFSU8odxwX11JMuAN89RbF2oBYEWLDaZg9IuUP4Wzf9DfF
	 8Dqqm7zy39/9VMZNG24iSHu/lx0HqDTSUUc/wYjGDI+nQD24nu0fseHtbOWV6/DVRY
	 cFyNFcApGOsLPZYp6TbwKXiDOrnluMjw7Ylwaa5hb7AMEXCBQavUhHc+zOTZQtWUMn
	 lcefn5MBF/hLJ9PoPdjV5pzzbfT7oadmatZQAokZgxQO3uO9+APLfWja7auPdIT2lU
	 LRV0v5Hn+o9JA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1AE8F451B4;
	Tue, 27 Oct 2026 20:09:23 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Tue, 27 Oct 2026 16:09:23 -0400
Subject: [PATCH] exit: use READ_ONCE() to read mm->owner
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261027-kcsan-exit-v1-1-7c0429a29bc0@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMTQqAIBBA4avErBNU6Pcq0aJ0qimwcCyC6O5ZL
 b/FexcwekKGOrnA40FMq4tQaQJm6tyIgmw0aKlzJXUhFsOdE3hSEEpW1mCuM1sqiMHmcaDzmzX
 tb977GU14D3DfD5lpoW9uAAAA
X-Change-ID: 20261027-kcsan-exit-109dce625d81
To: Oleg Nesterov <oleg@redhat.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christian Brauner <brauner@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, tz2294@columbia.edu, 
 Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793131763; l=1574;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=WXjCMdCN2l86r1jkTnC4XOf4kZ6T9fA2oOWN9xZ8maQ=;
 b=P4fzFN8wMHtZOrSvTz2cGZqT83oLhWqh1Yl+Q6idpSUy4YBkJ/VD293cGAp/MVmQ0NcTSTKL6
 UTAzDy6KdpKAIEtlMq8vulmMt2Se0lha0gFkV8W1YvL068x2hwvXryx
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C79921C000D
X-Stat-Signature: dumdhfrg3espbj5gguefnnxpyrffqdik
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793131764-210901
X-HE-Meta: U2FsdGVkX1+LpTH+tjJAZvlqNSt3hCaR9ZL70GCY4FfJmDWy0LX8Pm2q8c1liyzKXdqQsJLKIKFM29lC2XA0kCHpi8breCR1pJiaRbO86QKLBvuC0o1D52s8oX7oq/ZwT8i0rb9yfrzwbSHXV0OSrwYeJbkIe50Sbu//gkuNyS/l0yxTYGNb9tXmaTbYOVgnBvot9D4m6vy2r/gRrLgQ+VGF0rDc1V77pOlsdi/nke6XFal02GTdwUFHRQ4WRZPt5vQtBznHd7bJBLrDM692tgzqJALWh2++Rce5nWfZccFPcoVZ1erH/a7WIZiEi8BorE9n8xAzOxjsEKbBvmd3xjus6CmlMebEMJOKq5jV1wVFMq+1ECkWcE2b3ZWGuyWnw7ytWCTTosBJzwtQktU98WVJq8WmxtCF7rlh16rEgl6JMPuZQnwNTcodg0xE7gxIOZGOIsUpegTb7hwWhQRLjZO/Hb8AAJI8F2Qw56wINwa50hyzGaD8K2Zt7eMlsvvNBl3lPa+Hc6BJ8kQ99rVVoCm+Y+LODBT2wvo3ZZVgOzS/yagCv1P9/tLaSQeF8T886VSggE51KweCn6a1McPQ1squYYoRR+LSNYDVCIryFvpOCx2np/p7VkV6EBXE/I1V7mDuZZdcTXloEibR/GVkScqcE+1jlIYk3r5zRp4rBTG1U0fE4Udw1W5rgRbIz249XsnOXrKzJuGM7hAxfMv0PKJom+/5t5l5ZHjv+4RIRdRFM411P572DzkzelPSLExjEAt1+nk1THuvqQkU49hUP5pTSrILC4RhfpzScw543k03tugXW5nDdekGR6ScSgD4pPTXuB+3Xdp+9r/xchfQUpCFB2HzhXlM+PI39WZucBLN4pB0YeNoi0Mk562zwrsp5/wfY0mChfaZf/AhEFE0C8y7ZRIJLZ1V5ZZJgouIMp9M3X9LURpIpAKEN92q52XG+uDz5ZhbPsttYEWvz6z
 hf+8s2sU
 BUCotIFdtzJHc+a2Sq1+Mc5hjsRtRA9mbf/o1mufBmiJf0yALayGvuZg0mGDUQlScH2dSo7/OG5Jz4zErZUNEtgeylFFCszf7f/Mbht9UL0VkSQY0RT/747UGYa0ucodLYaCE75LH5P1y3EjrQYB6Gf5oX1OGkwi0CAPXV62XcfOXoinmL5W1mbkQU5SXUCSsI+twFRO+onFg+uw6wTDCaNvI04QaZbxePpuBcQA4d1EDr8aNSMbR011Wbp0fk4SNH1J+5Z0zUPfBQOtGIU0pFR5fEQt2OvNHWr5yCE+VamjD4VegphSiqR60Jk+fIJqR3mwrSGUEngjicZQ4Y+tsiTTZd7kLKMx3tImP0lIJY5mB/SnnuZJ5ZG6xbnBCDUoDzRig9sDfrjFwIOEwZDFVoPQPL8EgPTA6n52nIH9+uirjrODprsGhOgoVNm7nipU3ETp1HKXQpBh++ILCcif3c+l3IGEWgF/e0OA2YaLOTPXlOgWKVjx/olAuNT44wqjOVpUru+8RV9/mz+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mani Tofigh <mt4022@columbia.edu>

mm->owner is written with WRITE_ONCE() when ownership moves to another
task, but mm_update_next_owner() reads it with a plain load.  The race
is expected, so read it with READ_ONCE() to match the writer.

  [   14.915975] BUG: KCSAN: data-race in mm_update_next_owner / try_to_set_owner

  [   14.916154] write (marked) to 0xff11000004471b80 of 8 bytes by task 71 on cpu 0:
  [   14.916204]  try_to_set_owner+0x100/0x140
  [   14.916302]  mm_update_next_owner+0x177/0x300
  ...

  [   14.917246] read to 0xff11000004471b80 of 8 bytes by task 75 on cpu 1:
  [   14.917293]  mm_update_next_owner+0x2a/0x300
  [   14.917396]  do_exit+0x575/0x18b0
  ...

  [   14.923906] value changed: 0xff1100002ec04180 -> 0xff1100002ed3a0c0

Found with KCSAN while fuzzing under a deterministic hypervisor that's
currently under development.

Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
 kernel/exit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index d5e7bc2af804..cc78596db74d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -494,7 +494,7 @@ void mm_update_next_owner(struct mm_struct *mm)
 	 * If the exiting or execing task is not the owner, it's
 	 * someone else's problem.
 	 */
-	if (mm->owner != p)
+	if (READ_ONCE(mm->owner) != p)
 		return;
 	/*
 	 * The current owner is exiting/execing and there are no other

---
base-commit: d135ab453a7400a34930bdda1ef4bdc8acfac80e
change-id: 20261027-kcsan-exit-109dce625d81

Best regards,
--  
Mani Tofigh <mt4022@columbia.edu>



