Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71110CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63C5C6B0096; Mon, 18 May 2026 05:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EA846B009D; Mon, 18 May 2026 05:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37B9C6B0096; Mon, 18 May 2026 05:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 22E536B0098
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:50:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D3FDD1C0716
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:50:52 +0000 (UTC)
X-FDA: 84780071544.19.CCB0C09
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf26.hostedemail.com (Postfix) with ESMTP id F3706140003
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:50:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=GUX7YQkV;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=4j1ux4y0;
	spf=pass (imf26.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779097851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xDACfn5mnkk4BzBZ8LQOYFhz188HcBcZRBoZRe6gBL4=;
	b=Nguh24bwBx5RkX6HcqZrx3ARLZdNDVzVNiSfECXtzoiMvaaPCsqqp4oX25OkvCeDz793xz
	mqMNKxQ8H/7HbF21UjO5Ey4kUj91A27Ezyx+bVM9SsAGdXb3Ge4H44ZpXowhmf1GphjU4K
	Zg65gSrJ6lrhARHnOMrmO65RCD2h8pU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779097851; a=rsa-sha256;
	cv=none;
	b=BJa7gCxjE01F9mi5eHbNfo/xvmTv9lBftyMI+ORSSrCc3JTwPRbAm26URwvYLHnAEpVYqC
	Sr8AERPJTXcbuKXEdOKp4CKbq//nnqR4YlL7VRuHemBscFwMeqwmAU0Qbsl7vi5rn4khOg
	/M5gj9f4mNgDytQy3yc7QljD8KyCJoc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=GUX7YQkV;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=4j1ux4y0;
	spf=pass (imf26.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1779097849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xDACfn5mnkk4BzBZ8LQOYFhz188HcBcZRBoZRe6gBL4=;
	b=GUX7YQkV9tH8B+pbuxQlopuV/TuHc+IBlvcg1io/zbgozZbno/dhr0oPqgRIxvMqZdCca/
	6PRMWJxqC6wOe4JIez2PeXjxCHpH97RutmTF0siTM33lCXU6Q/busByu94iwSU0HgBLILQ
	zw11c1qXNaCmLJxTdpDLQyB0IVjzzzQexSJqskY4wTDz1Nbmz2dB00+dU0jwau1eGOTGUO
	lS20j9to7ftr0bCFPgk2uSUGewxJFn6j2TZpvGmqpnnu80yTdh79nWmBzlSuYFOCyxpUQA
	7/+8GjlhWGaeszU+MAO0kF/pdWYZKeMbgsq2HV6naQpDcbnurxMkiEXHQk8oIw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1779097849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xDACfn5mnkk4BzBZ8LQOYFhz188HcBcZRBoZRe6gBL4=;
	b=4j1ux4y0bHtY1BECe8ojDJ+mMSEqAh6xfrUs5WIVGZlz8w5//pwGo19JMLRHUggLVwbDuI
	1oMgsPX9kFXIzKBg==
Date: Mon, 18 May 2026 11:49:41 +0200
Subject: [PATCH v3 3/6] vdso/datastore: Map zeroed pages for unavailable
 data
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260518-vdso-mlockall-v3-3-bf4f2af2b41f@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779097846; l=1779;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=dPJZ4cyiY7usvh3Dj3xb9H24EuXZmchSS2shKwLhI4s=;
 b=Ng+knDPvybZE2AWH1rVLYkUjoc6qSujYwPAPvd2pWS+dgpTx5w5LSoOpY0egzbrYBeGzFOmNs
 4JljMACKH3fBuU6RnvMEExmOPnHDDlpVN1oJX2dkwe0I13GGMfTKmKB
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F3706140003
X-Rspam-User: 
X-Stat-Signature: 9ozdtmmx4q1chmi8qs8tx4qxwto8wk1a
X-HE-Tag: 1779097850-853833
X-HE-Meta: U2FsdGVkX18FjxPq940Uo/4O/7xAR1ku30qwWq9KRgmsPsUHKB0maniupBm3vWAJ54hZCJtPTHbKpctquur+oc5qNMUry6YMpvmspmhp/ecXZlzUeLjSvuGP7WxaSMl7fKFBVC5LUl0a/rqy8+MR1HXkzE9XsgbTQkU5F67C1JI0aPzdBtxfvAj6vDHBt1Lozev/oqrHs5U25XEEjALctvW64DM1SUfZBaqjD9u1WcLvuTDgsBnY5iqZVd7bXSnEDA0ljNSWlOzsvlp9zXoXIWHTxwJKJoaUSD9jnLwc40rc6R7zcOJ2n5RxYv2+M4kzt51p/3hFQhYrwpujpzTBS6BKIcNNRgQyTqB5YBHeomNe1qBIOhPbKdVk2yKAhliSQQnB/6GWyT276KR6/Udxtd50svs8tP0V6/dwNjbHljdZH1f682z1znnrJABgAXs5WT7mC8OFxC3np1y01ZaeId4tQtsGYOD9DyhKcskU8fRBC2e56IjQJVjtJ78zgEWhqvZjpl8U41wSFiV5HMkpfkTxeWFbeBDrqb0n1fPbIOks/WttlGA8DH20AdZG0FQTJaN0MQjFoKAoCcDUPTuVwE/TCIeaViHnJN6NAdWtpGCM/cFKcFmftbZd7KFA63tYmcjx8Uq2LH6MxL1pOYe2c+9v5dRmO08W3qDLMbQI3+P2A9mb2yV4mN2/iHkFqr/9Eri53cdb9XvdRyXU0pnDPWhNodO2rBRdUBhycgwcY03/WVT62HJWoMaBn0yPIn5gHSnW5sftVeHmzq+K5YXAvo4OTkTmtATZe5h0d2sRlCVbNkPZPPFTd5Cv3b6PxPn382SquSZxwCzyQpvDrkkmkntgDeFVJEBzK0dRMkLRMpCgBA1ZZltLUv6jf9KYZAMWMASjI0QMQ5iaBrLHq9NKlN/xnlFOxavJyStGCfeDvSkPo2jnaDGM2LJbB48VEGpaT34VnYCso66Tmy4GZSh
 u6Lc/3DT
 GLIvBwHuG5KAnV37e/sECzy3RuC5QAP5vpewdBz7YDEjjuVQQHUg9cHKxq5khKZYYHLoBrbTMfMVLtMjyt8oJ61+NAQSLG3ovkjAdCGWEwLk7ZfUFoFhBueQBqsauEim/oyMw292REpkdR0LCbtfGDSIEmulAnd4NEkD+jnmI1TijHq0v5060bDxx2ohm1R3mgrWKQDjsKSeF6l18q+uf7vRPytOEQVatzwBUSdzzilxJ/RQglTUXDwBXGLjF6578nIKmb4/pVpey0/aRjECnkwbMTtlDr+iSVWSc1E/kl3IjJj8wcc61xW1WmjUwbARCQYksfLUThhOUJddVb/IjbAClPG/HsQv7ggqImFF44i0X6UiQg0SAjf2q/AtVZ3G0kDpMrC9fEIag1tYWnPXfYL0fjn2dQMSpgMr3xdcDUltV2shnpEy5+tYjyw==
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
index 8aabb289a7b5..f9a1f0fb7ccd 100644
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
2.53.0


