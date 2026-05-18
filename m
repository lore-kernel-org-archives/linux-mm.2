Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 749EECD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48CD96B0095; Mon, 18 May 2026 05:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 435B26B0098; Mon, 18 May 2026 05:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305266B009B; Mon, 18 May 2026 05:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9096B0095
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:50:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1EF5920BE
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:50:52 +0000 (UTC)
X-FDA: 84780071544.13.AA7B6C0
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf13.hostedemail.com (Postfix) with ESMTP id C30FD20016
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:50:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=T1DwD4Y+;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=+Rn9z5wq;
	spf=pass (imf13.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779097851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eKBBbMFW0zeLfKhafDGwFXWyVXzSARM45rAP15Pw1ts=;
	b=pokxHEJYe7JcsLguOd9m+zTLpfItSsrnW8grlYOjYNaRa/UDDW/tlavJ8lZzzVO5SdFHYK
	ypAJcSoJ3CT5BgKyYSI0mmp47EryXZnhPytv95EnKOx0T9MCKA5/Y03xjB3IA8ZZ1TjEa8
	KIz78Kqidhf9PyKvY7M50idGJfGwbVE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=T1DwD4Y+;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=+Rn9z5wq;
	spf=pass (imf13.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779097851; a=rsa-sha256;
	cv=none;
	b=tLt33VZkZxUphM//Y3PKz7IVNo8AXZfANnqLGF7BQl/II6AX0S3RfAE+Rq20rKUYdEF0As
	wr6UEgkdpcggYSJdPcDPYRbIq73iJB1Cdy/PyeKPlhcCizWLpzHFCIvoieeKWD5otoyhww
	vQHZWmtNeGAS7JybNsMzjVeVQt6Aazc=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1779097849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eKBBbMFW0zeLfKhafDGwFXWyVXzSARM45rAP15Pw1ts=;
	b=T1DwD4Y+9qZNYRn3+BCh7jG7baC/rIqSmxElD+uZdR93PpXrWGiLFjHH76dC0VacODtp08
	ASKH8emTUOmy2RHIS9mgsCRYAfo35Rhyq/6lTk0XHB35XyZSY8gSz1s8dGrFXafP4b+zq2
	S2VKInq5BVDeXkAmtokPSCiQTekOQAbzcFPcK/OS+6D6N3maS3FpL8PhEKzywrJ2eHYjSA
	EB2KuSwmxDe6JuE6b7Vl7nDv9MLrwDmSSeGagK6nmTiFUzazG2zkOhvA0rLEyPaJfypusJ
	m+aBRgNpuFF2blLVQ3cg0Hzv7LNrnvsyHU0ruoW/rGKgZvPdSbawp+PuLf3Fqg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1779097849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eKBBbMFW0zeLfKhafDGwFXWyVXzSARM45rAP15Pw1ts=;
	b=+Rn9z5wqnKOCTl7+4iQLXvarvwFfJubpHkP7LnPRFyja5mtmlQ1KSUgtnkCLO1SbYLzti2
	g20HAQx++B+I2eBg==
Date: Mon, 18 May 2026 11:49:40 +0200
Subject: [PATCH v3 2/6] vdso/datastore: Map pages in terms of the faults
 pgoff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260518-vdso-mlockall-v3-2-bf4f2af2b41f@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779097846; l=2385;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=nzT+jyn6qlGajUV43mviB6CNboF/KXDQKyet06Cekss=;
 b=w37Z9N6Y8tgiF2a6w/a1sqtak00ri+ZGpAQvQQrdBSqIinWikPGz0HG5xyz9cU3DoIXg4X2RQ
 ZX6YbcNVILkDaLnJ4mJPx9qMc7jiOVkyxjGx666XKZo24JnHKfryvXQ
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Rspamd-Queue-Id: C30FD20016
X-Rspamd-Server: rspam06
X-Stat-Signature: x4pixizg95p99dz5h6jecqdrea6z51c4
X-HE-Tag: 1779097850-570634
X-HE-Meta: U2FsdGVkX193WdVSwzG+Y+sKXeW8OXkUj0fMqk9tkVQkeWSk2Y63DcgmJqTxYqKjh0X6qA68B868XGkyHEzKoQ5uI+oiY+AUsLIistYZuyCxrqO5Cuvdp7t5l6Vf3VY+fkz/r5E0JB0+28NYGJ4+bqF5diQHxyTrv/0q3uaGegTHdRt0i6qytpa5Pobi5vA5d+tr8hKjAjXnSdsdxHKnxnp962gPdDxw+BCnqq/ToSTJABSy+H4qWVMFhAObFf/rxmpBStQ1UUjaTVxoEFfVLn75Xk431VOAOTDhtwmvEBXr90vL81iRV2KgAbuKRico/sX8oI9QsVEkyLvrlmuIY5umClF/AcqTDAy0H1ck5fvrNYOj9ibVcyz7j11OaL25/H7FAX7wtjH+CzqJDAgHpIFJe3iYOwRr+m+kY0G/bJ8wgiPKArmDKX/HgAvUzeY2gO3Zqtf2RLr7eh1pcjzKPYxnNVVD2Vp1kmmiEnpvZdG+bAmbXHDoO/hw1GtW3bZ6CAdpocOveCLmDjhsjLmgqzuo2WvEKi1L65LzBh7oH5ptZiaNLvY094H+XaYHQNvevMJw8RQxZFa6bfyuQKe0vLD9YGY5ElrlNRjwAa7ClRUBVuloG10vzvwullUOiPECGDNCcKDGcnUPfeyWN2A3CvR3Ez6Cwcu0yzXCHWrTwIQFKYe2P7tTydjdYFz4YwyWxCK0DIkKy1Qp58gjcPwNVSb7WfaCEp1AvEL8arnNp4X9V/N4B8II0bNs+i/prQ2lnIYkkaDMpMsIb3NT2ljTx4S0sQDooHY979/RpJxOV42H9fgILfK0J9A3XvsUpxGk7QPcw4o1avkD76ggDDat5zK7y2F7UWvYBqJ3fsHrkhbVZO2v3cXHWXOtxFn3PAL0leTR0OTKZ/7zz4yADKhHBa+RnUTMgzWh7G0kSOR4VRFYeS+Fdue1XHh3viB64w/COULmPTUS/9bWdV78C5W
 by0gdpVa
 8x+WKSdENVRKHfASfgeccslxeX0dcAMs9zvGdbS3pZfRB8PAXamrVvZcrAXnfoJcvHKpv9Odj9WaojCS2d4pFwhF1tBuNq8SS8Pqq20++z18skD+c3tgFo208p1uV/9JVyorTbzkQk/0m2MhMb30glLr/vzw7utZKA+FbQxepYtMOoTff/qwKoh00A3wNq9zW7nSBnda9SH6SlNoDaUHZWzOcHVsx1ifcXrMe1irtmjMoPdeffLM9gP9jDKDGCgGoPkZJq9h4tculbAscBZKdAtJtgeIDHmAjB+a2VmPDwwWRMTpaho+lFUtXfzDSMRSjr3aui0wxhpGO8qNsfYHSV/P+rHfub7y7vrdVx8VxLDDGSjKpQ7w6wkzPTs+1FQsLL8kHp4LSCB2+YDl9A9XcCvrC1rS0gQQCXbK5OnqbWzHBEV0QQ3Wb4hd5kQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To support mlockall() on the datapages the VMA can have no holes where
inner pages return VM_FAULT_SIGBUS. An upcoming change will avoid these
holes by mapping a zeroed pages into these holes. That logic will be
simpler when the mapping logic is based on vmf->pgoff instead of the
vdso_k_ symbols.

Switch to the equivalent vmf->pgoff logic.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Tested-by: Nam Cao <namcao@linutronix.de>
---
 lib/vdso/datastore.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/lib/vdso/datastore.c b/lib/vdso/datastore.c
index 9d66ac2fdb8d..8aabb289a7b5 100644
--- a/lib/vdso/datastore.c
+++ b/lib/vdso/datastore.c
@@ -29,10 +29,11 @@ struct vdso_arch_data *vdso_k_arch_data __refdata =
 	(void *)&vdso_initdata[VDSO_ARCH_PAGES_START * PAGE_SIZE];
 #endif /* CONFIG_ARCH_HAS_VDSO_ARCH_DATA */
 
+static struct page *vdso_data_pages __ro_after_init;
+
 void __init vdso_setup_data_pages(void)
 {
 	unsigned int order = get_order(VDSO_NR_PAGES * PAGE_SIZE);
-	struct page *vdso_data_pages;
 
 	/*
 	 * Allocate the data pages dynamically. SPARC does not support mapping
@@ -67,13 +68,13 @@ static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,
 {
 	struct page *page, *timens_page;
 
+	page = vdso_data_pages + vmf->pgoff;
 	timens_page = find_timens_vvar_page(vma);
 
 	switch (vmf->pgoff) {
 	case VDSO_TIME_PAGE_OFFSET:
 		if (!IS_ENABLED(CONFIG_GENERIC_GETTIMEOFDAY))
 			return VM_FAULT_SIGBUS;
-		page = virt_to_page(vdso_k_time_data);
 		if (timens_page) {
 			/*
 			 * Fault in VVAR page too, since it will be accessed
@@ -99,17 +100,15 @@ static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,
 		 */
 		if (!IS_ENABLED(CONFIG_TIME_NS) || !timens_page)
 			return VM_FAULT_SIGBUS;
-		page = virt_to_page(vdso_k_time_data);
+		page = vdso_data_pages + VDSO_TIME_PAGE_OFFSET;
 		break;
 	case VDSO_RNG_PAGE_OFFSET:
 		if (!IS_ENABLED(CONFIG_VDSO_GETRANDOM))
 			return VM_FAULT_SIGBUS;
-		page = virt_to_page(vdso_k_rng_data);
 		break;
 	case VDSO_ARCH_PAGES_START ... VDSO_ARCH_PAGES_END:
 		if (!IS_ENABLED(CONFIG_ARCH_HAS_VDSO_ARCH_DATA))
 			return VM_FAULT_SIGBUS;
-		page = virt_to_page(vdso_k_arch_data) + vmf->pgoff - VDSO_ARCH_PAGES_START;
 		break;
 	default:
 		return VM_FAULT_SIGBUS;

-- 
2.53.0


