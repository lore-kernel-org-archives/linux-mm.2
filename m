Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4062DC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2A636B00C7; Tue, 30 Jun 2026 03:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8B2C6B00C8; Tue, 30 Jun 2026 03:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C52F46B00CA; Tue, 30 Jun 2026 03:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 957506B00C7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:32:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A5321203D7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:32:09 +0000 (UTC)
X-FDA: 84935760378.14.3C96AD7
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7877B4000D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:32:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=pkiZd5RE;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=BuXKYez3;
	spf=pass (imf27.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782804727;
	b=dtDPttm5lfr2Aee95BmfBvBt8Roh7Ec2Kboo/5mlUA4hUpzmcV/HzBFDCInzy6YcN7pJjd
	Wfd3EKwdRUXl4/KaM7x8okmYEmXOx4sZLudA4+CQkTDhAtbiceCIGSVCm6kZYWyIHXBQhU
	0LZoi3C7UwP7gB8OmtEY+BN9TE5ImB0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b9woAwxTCd5iqMf0h6O2yZttpHnUjaQxSjRP4D9f09Y=;
	b=OnpZTpJ/K3pInaYUNFpjIB4ZPAbTKsgzBSMrUGt1M3YQTViSNyu2bzGgw6b2JXplMwVIii
	J10MbbG6uYh1zWf9eUlE37bMr9wD3OVVHEvOZjvv1gEsRtXicpG0skXqNURJyOraWBBV16
	hry5F4nZ1b/2k5QbY7eSqDMp1MD38ts=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=pkiZd5RE;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=BuXKYez3;
	spf=pass (imf27.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1782804725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b9woAwxTCd5iqMf0h6O2yZttpHnUjaQxSjRP4D9f09Y=;
	b=pkiZd5RE3R16RLIHgJSrNZojyXivPIjLOENwgHZEw//KpsY5f7MZn/JtKFuYl+KH/Avdo2
	J6ccKqWWMpZgQfHjORmegmRaHO+LPzlem3xQCauGpIGmdUXijcxggHgooQ5WaoDRQKOieG
	MSobUx+QDUPlw6Z8bDVGF5uw29vkQhXqUuT+mWvLUIf+eN0L+Z0yydsroCArBKkFckHIhO
	rX05qYl0VCmVLihAeqq1sklGDCPLMtrTWJ3PNtog2x2/PbD7erUgTwh6OWn3nWupPEGQVT
	SXMieBMYMoM1hpugyJ0jgIzK7C1k+Ae/YvHKMOkzsyirVtmJOBHFxY7OFb+i3Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1782804725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b9woAwxTCd5iqMf0h6O2yZttpHnUjaQxSjRP4D9f09Y=;
	b=BuXKYez3e12iaVkuRRIoAUGjK94QgjbpbzL8Ej6/bbYPj4+Syb6h9CC/F/7bMWhHyT0BOZ
	pTGQSC994lU4C0AA==
Date: Tue, 30 Jun 2026 09:32:00 +0200
Subject: [PATCH v4 6/6] vdso/datastore: Simplify the mapping logic for
 VDSO_TIME_PAGE_OFFSET
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260630-vdso-mlockall-v4-6-6c93708ce723@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782804721; l=1523;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=tMYyr+0MUZgqXxRCaSudj+eF7RhqsNYP604whSkkFls=;
 b=aO9l5/rIajahyFgMu+6t9DtyWFk+0YDSWX/pe0+uidn7k1GXsGHpy5RYFEUzu8nic9h5gnb55
 SPE2zsS3mD3AN85vpJUkQJS6yG0pCKySQ1YDi6WfsCFLCmSHIupjvp9
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Stat-Signature: hij9akhobz8sw9wnoakmhaymecye9n41
X-Rspamd-Queue-Id: 7877B4000D
X-Rspamd-Server: rspam06
X-HE-Tag: 1782804727-911332
X-HE-Meta: U2FsdGVkX1/onfEAhVzvr2JXgS+L/ovnJh5d/oJhuakQqsTOLuOcfVvuLfC9BGlF50KI7kT4OVe/uoF4MDNRa/In9eIUkaXZjeRpQhwzpGPZV6aND5FxpCiLM6SDXSbW/IrcrDZwYIG2NcAZYrFqZ9x4ORjbUV728ETan1o0RYq9yktWKvk7L9fnd2y0jmvJBUcGx0oFdz8wkI4jZqOqMwWPTPvmmmHzfc1pTiYC1QRUPCd4qgbk7jdrJujpbGcgwDEcp7NtId/MTvAIIMhWnvaVSqLF5VthE/5JJ6TqC/l0DWcmEJ+A7Q1+dRRqJUgQH5LbOk3DywU5cMtTLmvQXRQ0yI979XSEAAgWnh9Ro3QN+3/gMWawIJY95zNOKnxKxNttnYEpeXmtabho+yi/EFG1W1OguekRh3faUX7A0vFz0pXvjnI4wBz5bmWVWgU8NcjXg7OOl9Y/VKR8HSHy5JsiYKl59RowZ+qna8UpdVp+ZBA2QTMYElirTTXM6ozq7Sjs8uKw838bcg3Om1YLPk3kMhtNBkn1N5cjugS/VvGZBCTfVq4gdjYkWAcZxUw8b1Y8J+CansHxx4K0X16+JtMYk2CBK+gqFIOxUGfIwtoLoMI226xnMVQxSclmbyFINrGBKaCwYpEgDVBwSPgevN7KsWKjYNWCRnA0klo0Mu+G/2VFcjSyYGTGqQ7Mj8870f/PDKsOADi1x7aM2ATOV80BWQA6xPYnuOr932EdhAM7Gl0hnljblF+QmeCKVoMiB6ngEcAexWbV/QOpP3dxxj8kSWHC3yQaKo+8WKHvvpDxRsJ2i8gemEFb5CddGbP/KpeIseF9YKgG/0nCLMtNS4cJsiPP7DRQ3WaKvB2zzq8h5aoQHgEW1ImmV+O53fSwJrpOI9BVvnexUItVGXPpNseo5TdXxxQ05e+QnkFRovznf/xk7V0Y4L/UbY/LFyp5kQK1+hiHAeiu+Mb0vs4
 qyEFqhAt
 4Fehr5wAYMSEBcA2+TjGDvEpMkT2jgosT+sTL1lcBm9T5BGBEi+aIgJqWP7WZ89PEVO7AP8SyAulmLntTq1dW/g5FFtjsGrK5RVGxHksnggzs/R3N3ToKa0+JC0lTPAJX1waoWnwaSwuvEOQ5QTdStpWe7T6LkpRhfwNQYBWr/O6njps84wmaw5rJhUkMCVy+HE2r4ls3f8ttWveBWlBPGJ1ldBq6q6fTdejEgAjUtkn+gCXpuaVa0QnRJH2yPJ2LBcCfUFIj/aTSeSCkaiPGtCteC3CTq/AhvMwDzPwhKKlaEXrRKOkqGIdsWfO2sY4mUeHQ5gxYyC3Y1hTDTsxBoooYIigKIBX6AVR8EZ20JHsndhTVjNqCOp0UOZtTVGnPH71LymAiVxD+KItmZm8JuwazpDvQQCrjjv4UMhUg8ERy4T7wNmBidrFvtnZAXxsvZl3A2+hrqX6UNKTKflYsrUGm9RM/pffaLsqw0Mw/fJtgLUg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The logic for CONFIG_GENERIC_GETTIMEOFDAY=n and !timens_page is
identical now.

Use this to simplify the logic a bit.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 lib/vdso/datastore.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/lib/vdso/datastore.c b/lib/vdso/datastore.c
index d7ab077cd604..1426bf4e0c12 100644
--- a/lib/vdso/datastore.c
+++ b/lib/vdso/datastore.c
@@ -76,22 +76,20 @@ static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,
 
 	switch (vmf->pgoff) {
 	case VDSO_TIME_PAGE_OFFSET:
-		if (!IS_ENABLED(CONFIG_GENERIC_GETTIMEOFDAY))
+		if (!IS_ENABLED(CONFIG_GENERIC_GETTIMEOFDAY) || !timens_page)
 			break;
-		if (timens_page) {
-			/*
-			 * Fault in VVAR page too, since it will be accessed
-			 * to get clock data anyway.
-			 */
-			unsigned long addr;
-			vm_fault_t err;
-
-			addr = vmf->address + VDSO_TIMENS_PAGE_OFFSET * PAGE_SIZE;
-			err = vmf_insert_page(vma, addr, page);
-			if (unlikely(err & VM_FAULT_ERROR))
-				return err;
-			page = timens_page;
-		}
+		/*
+		 * Fault in VVAR page too, since it will be accessed
+		 * to get clock data anyway.
+		 */
+		unsigned long addr;
+		vm_fault_t err;
+
+		addr = vmf->address + VDSO_TIMENS_PAGE_OFFSET * PAGE_SIZE;
+		err = vmf_insert_page(vma, addr, page);
+		if (unlikely(err & VM_FAULT_ERROR))
+			return err;
+		page = timens_page;
 		break;
 	case VDSO_TIMENS_PAGE_OFFSET:
 		/*

-- 
2.55.0


