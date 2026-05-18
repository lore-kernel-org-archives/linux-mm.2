Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C5E6CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B91E36B009D; Mon, 18 May 2026 05:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6A666B00A0; Mon, 18 May 2026 05:50:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D3D6B009E; Mon, 18 May 2026 05:50:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7B23C6B009E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:50:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47CD3C2B43
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:50:55 +0000 (UTC)
X-FDA: 84780071670.22.A74FCF5
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5DB4A4000C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:50:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=SaHFP7is;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Nb4Xn1wp;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf27.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779097853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=56ec2S6UfJI5KAZ991lLf5dp68E9Sf1TsK9ZbOo3bbI=;
	b=pF1gg7LmlxrCUCTOsCQr7f+ryMC/lEEGZtWLdkBS8SOnQ8suO/OvV5xHTXyJK2gJsASg+y
	hKY1ScgTxSf+Y417sRmy8xUVgVKWzQryVDY12jun2soAnYRCpqXZSQdbAcPSVxy92DAmB/
	SeLudN0Rpg462665a1JWYB6AoUiA0Tk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779097853; a=rsa-sha256;
	cv=none;
	b=qGiFSOMZvgn6KGgYKkFyUmU/40Kka+1FbpDeyVfscoGsi5FXd5bRw/YifiVlM0JvxiOD6U
	MoAocVzOCjGU7JUrYRBLzVXfFYEeg173Qmul0RNTc8qkd6N8vI3jiiW/Pu/mjsOI1VHD9b
	wupLL3ew7/8EiGQ0DQH5XEae1Bn0AxU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=SaHFP7is;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Nb4Xn1wp;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf27.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1779097851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=56ec2S6UfJI5KAZ991lLf5dp68E9Sf1TsK9ZbOo3bbI=;
	b=SaHFP7isUdwhSVQ5l1Y9zvTejemEyd8BX0KqDvdTc5prGnufRKTB1aIcN00WjgftkGW1yK
	nmSHedDzBT+mU0qhyLb/5ygQCaRbzS8xE0u2EFdaAk1zHnBQ/Ee/GrOWM5XBN7jBDJ67c3
	K5v92MujBuor3AeeTN6Kc79M2AugcInDpx4t2TjsuWni0pcrAlaKP0SZQvsZz2kuUNg7Zk
	ZWVh3pee2rReuHkUddlTsM3fewe6Lg8IpWIbzAKzdyO8eDWBYJMFuq/l5UvzQF14dIHbOY
	upyt45fZRcauj9XVyt9EK4Olboe126wSovoY7jqaTWiI38/snMKeXoo3M2O0EA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1779097851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=56ec2S6UfJI5KAZ991lLf5dp68E9Sf1TsK9ZbOo3bbI=;
	b=Nb4Xn1wpCA14AqC+1VqPEBORrcVz1VaIPEZ0emAqRIwhoiLrqtfJnQ6kVPM6ni+QXK/tCb
	IHwcDv8NpGLLCfDw==
Date: Mon, 18 May 2026 11:49:44 +0200
Subject: [PATCH v3 6/6] vdso/datastore: Simplify the mapping logic for
 VDSO_TIME_PAGE_OFFSET
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260518-vdso-mlockall-v3-6-bf4f2af2b41f@linutronix.de>
References: <20260518-vdso-mlockall-v3-0-bf4f2af2b41f@linutronix.de>
In-Reply-To: <20260518-vdso-mlockall-v3-0-bf4f2af2b41f@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Thomas Gleixner <tglx@kernel.org>
Cc: Nam Cao <namcao@linutronix.de>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779097846; l=1523;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=Hr9CQZ909W4yD70dLkMZGJHZWtArn65CtWZlQke5Hvg=;
 b=zmr3hyUYEww/Dm4yHLpAjozy/bJb3KTvigINE+q1hmoIY0Q3TUITjIbdYECHG700bRT3IWYFC
 fZB0m9GO4leC5up/AVIKU92rYA3kM2ipz2BcwUGZ+zSVkYM71Wm8ZAH
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5DB4A4000C
X-Stat-Signature: 9c979n4epdyi4u7njbedtjr5h8uzoxrr
X-Rspam-User: 
X-HE-Tag: 1779097853-863884
X-HE-Meta: U2FsdGVkX19gJfJkBW/H2jjnUZUscJl+imUt5bLgF4Tx3cjMh2XD1Es32XSEyGjTchTp8aFnvTiBvnJ7lVfaT6csqfRi7+F3dzD7V5cbEdggj/V7cQc5njQknXwgUHQwJ8uTOsPXoK4kALDfCOhWmIvpFy57a3ZObrDMJXmBznlm4G/EO+mI36Ta6kaiGsdArJxU/aMSYQoIdWWJO2rMhESvO4Fzw3CTeAsLt7DTx38WDDwYsNSiRIC/9Fr9dRSlu0uj9+quDxLJ/h7/31VbAcZixwinzqPHqjHLJYjFfxpEW6vDxGyQLUq0PqI7RK5NSDbkh8UjlGcV/bAjv8SWKtbZjVRv3Mm/Pvr1DdZ8ddHBEBEEBUHyo19UVdLAd9koHMMPfSYhDaB0Xfn2lsYMZBNCBT8A+UYHcLS20nO6M15/TvRwDX5hOIVazltPdWI545AmNL+3dLVYzqymrT+waAdhe4yQjLdlWPYEFyl0YRns/OzkO9yO0V7zgnbqbPHy1/7X2ig+zmLMjq+PDBBZxtNfUdrhqWsxi31CmXBUu7u/+TEx6pAczEOmrZYwG1Bn016kXPBn34w4dplU7DV1Qyw6H4HcIkQPR86MVQbpy7/zhzaOhpFE+vkjQhezWECpSXE0iKU3h0LgHTXdLf1x5cJzXGUdNrh3KBFDQuWCFX1k23/tREGZvxM/joFsJQoSOrkzBGlYQTLHhUBb+GYRCOL++QSrpaeXy9OHcfeYMCXlLKWAtA80nppVSJWnz+5G21P/iYu7RRZAGqb7Vb+qmLfcphcP6McU5W7QrdyrviiKS+z8MOE8QuRU/GvYfcfFLQyA5AThaDt1jdqIm0K+Evoq1G17hRx2GJYcQYzTX5tDdj2Eaj0Al5JJ//o612zKmd9AW7rirTlgnxRaWasQocJl8HbtLw92D5rG+difjq0MI8aJjORFZXIS25ldYWiFu/nDS1VZi4MnFmtN3gI
 zHVc6qzM
 S+Rwe/nCN/HqTUOk0/CRikq8A/alBdm6Kn1QMQgaQSxU6DhUCh3Yh578dkC6Xr0z6i4M9JkmrPJuu16qa0B0DidtkpaYdXF9KH//VUUN90Vwxc+6gNyZkYht3x9HZDrQiPFU9ZXnyMIFnTn5E+sxltiHsGfAj4b87c7LS5AMw8BV/Q9jpgAjMFsyS9AWo0qmZl7VLqnK3+Q3PgDZ0ChMvXoQrWAqZS4xanzAVGB2ZvWD7SagclCQOHJ3QwkK8uQnK+DuiInaxvtZqXe09bQdI702Cdh2JSnHLnedhPA/s+cygEf1wqhod3Tc/j8oIpYd3ksyUVNtp/fJyO/UndutMfpXvY+u0qo/tkDC69ePsP7dirujSaJNTxxXJrxnnbnWMjVQ18EOXDKWHqGqvEKj4f6g4owJv1tBoqUUAtUdcJems9prN1tBfV9wYQxFOZnhulPfohc/YXdCI/vLvELvFleO1uTkt8GmASwP3
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
index 3f837cb6a886..21f09fa5e254 100644
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
2.53.0


