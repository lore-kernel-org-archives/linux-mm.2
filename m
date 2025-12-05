Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 533F8D374B7
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 23:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B610E6B00B2; Fri,  5 Dec 2025 18:17:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE7F86B00B3; Fri,  5 Dec 2025 18:17:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C7676B00B5; Fri,  5 Dec 2025 18:17:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71EF46B00B2
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:17:48 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 31B4B13AA05
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:17:48 +0000 (UTC)
X-FDA: 84186981816.23.1C99F9B
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8E33614000D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:17:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=MFRhopnH;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf23.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764976666; a=rsa-sha256;
	cv=none;
	b=8k6c7Bc0fkXwO64Alse3GEV2SeMBOB406s7OmYS/4EmBT6vSEfIpbJfFeh929Un7vrQ89Q
	5ivsvpDT65EXzZNjAYRzz/fo1wK1NVi+K8CbpY/HXYHatFookh/c7kIA7pFWiiLDsQketL
	tnopuWCsb8DD9r7m7Re7KyF3e2NP4o4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=MFRhopnH;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf23.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764976666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6hgIhBjkcBdOpG4pdp5wLt2KON9r3FFTvP5A6zlmIso=;
	b=sRzOLcO1g0lICZ/5V+ChgsG/ecY+k841MTfiiti9qIj+UTV/o77Yo2XwnNOFGgLZAKsIYw
	Jr3Oaemps0KekwYnFcibj5EuQtWOE17q9z9XfMCCmhVYKz99p08jKO1F8UZGaYPNvSumqE
	0GrbFxaZrmVLXWPCznyvL4zM1r8Qy3E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6hgIhBjkcBdOpG4pdp5wLt2KON9r3FFTvP5A6zlmIso=; b=MFRhopnH0jY1D0S/Z7/HGXAz9z
	AFJgXWhDxsUzmz92x1f4LKTC2qYf2lf1Z07OBMpR0twyEDFI5y+OwCwfzkogf2q/aJsxxxC8A0wjR
	9CpvorI1iExQ4K0v65ktrD1/4JEh1uR/sJVA8CF5Xt9G16IudoEKzoz6EOSGO0q4lo86oePKMjPMx
	G21vcrDKoOUITCUgrt9LmHA0tv8a3crh6EOzTYB4EIRhLW6xzJzZrWKqk5sVGnsV8/LcnARmtJP7e
	Uz4epEM62N1glMmnmGvxMwATI25W1dP2NTKjBfzjY65GOjDNZ5naiCBzDynRM2xVQvU58GxsbPomF
	2Bj5sBdQ==;
Received: from 186-249-144-101.shared.desktop.com.br ([186.249.144.101] helo=t470)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1vRf3T-009H1j-6j; Sat, 06 Dec 2025 00:17:39 +0100
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Oscar Salvador <osalvador@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: [PATCH RFC 3/9] mm/page_owner: add 'struct swap_page_owner' and helpers
Date: Fri,  5 Dec 2025 20:17:15 -0300
Message-ID: <20251205231721.104505-4-mfo@igalia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251205231721.104505-1-mfo@igalia.com>
References: <20251205231721.104505-1-mfo@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8E33614000D
X-Stat-Signature: bbgzmkubik6rc4wdkpyudcezuy1yfs6z
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1764976666-344856
X-HE-Meta: U2FsdGVkX19IVyMaakTwRSwMfdEFGelIHo0aYPF9tC9ndRqPYc2Wo3LtKjsbw7/bdbK5mAo4PYMaI+LXddzNL04IjxO1cZDOKaQ9bS9fbi/BHWgflPLDDG2uGGYWIn4Do4pqeeDwS4fu6I0IaxVmJwbjxlOINibrtA/I9IVaPe2Z331JsItJQ0TxxANLEuFhW/MI5hfrq2jvK/CXuKE9Blxge5ZpT7XXzH7cvi3URM+LNGgxKEZ4GB75XwpIBiZ6Dl/Dt9XSN2BIxOO6/u3XBIFtJ86b3+FnXeWfrC24SMu/G1jua6ixAkhSNgITQZ1HyRgAPY0WP88YRdzgCkznuiCLGuW402KNn18U0mhA1siebUTpWGBL53PxoTI6geB/Kk8qci32P+rxOGEUYW4kVUNFIfkmtZ2/uQbdYoAQTEDtpbwT7dgavdiSvXyfTjZNYEYExERD6WeXXPRbV6WuV5tQQPQm44qoWAxJmKlOon3uZZbCb9qiRE0F7mxQEJvsoUEdBdxwBSHjsg69+woRQanJiuLbHfAmE42COIlxlpZDtvzTq58weQMEcTEcxpV4mvSBi4swJWFXwFvkQrYX9sOKO+u5Nf03kfrOetjKL+CcUTj5vWikbqTm0XFjd2/ydeUYHaMRjfnb+c/2g3QBi6K1mepobvZMah/jwWOKl9AfnccIn7SDR4goulvvIvtj9zOtpS8PuieUwZFwxAzoTXp4iqxJTebopR9le9Tj5pIsRou90YdqxrTjjHlqjh6oWEfR2eE54cEhpueRNiHnoCuwi/ijV0q1lxtDbiD3X2DeXVVMbOdbEcrNMRBjE9noWp0IC9Uxd+DX97Og1QsSRdHeJ2S8eewuCAzIKGsSibwbK+YaJ+25x0MrFcNOqtgjkTO8G+L+Y8depIeRUcq+bjsRqB7QDrEiiIMLqRkWjTIrEORoyPwCai2YByiT4f3BYo0TPDAkL6GF88QZXsh
 QNpiZ/ZQ
 bN74cEhABcEU3mrgdF1/B5EyJA3JjpoAvQHz+Z7/zDmrRDzYFyE+ji/u9naOMjD3oWpUEVDrMzZRGyN+IpfvQLhiwMHU19M/IKng1q1UODYx839M+4ad2nd2BxM1GEldKQd1PFaf79aaDHLEkPP6vbjtjV+NcQfhUyrnCQGWu3QFfCxBS3UqblBpg2yLuU2xuTqKfC/zMaqyawj1JJZbssXSJcAUW66zakIDAD51G+h0NENoR6abxiOtMH0GhgswmwIcLjqV8lcw5n1TOLfomy/YzDkbvHDyLSrLF/0E0yUXWOL+8m6psSOWULwBcr8fH/6Ls
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add 'struct swap_page_owner' to store the (initial) allocation stack trace
and some attributes, plus helpers to allocate, free, and copy it to/from
'struct page_owner'.

Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
---
 mm/page_owner.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index a27958872b07..19ccbda1c2a4 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -60,6 +60,14 @@ DEFINE_STATIC_KEY_FALSE(page_owner_inited);
 #ifdef CONFIG_SWAP_PAGE_OWNER
 static bool swap_page_owner_enabled __initdata;
 DEFINE_STATIC_KEY_FALSE(swap_page_owner_inited);
+
+struct swap_page_owner {
+	depot_stack_handle_t handle;
+	u64 ts_nsec;
+	char comm[TASK_COMM_LEN];
+	pid_t pid;
+	pid_t tgid;
+};
 #endif
 
 static depot_stack_handle_t dummy_handle;
@@ -442,6 +450,38 @@ void __folio_copy_owner(struct folio *newfolio, struct folio *old)
 	rcu_read_unlock();
 }
 
+#ifdef CONFIG_SWAP_PAGE_OWNER
+static void *alloc_swap_page_owner(void)
+{
+	return kmalloc(sizeof(struct swap_page_owner), GFP_KERNEL);
+}
+
+static void free_swap_page_owner(void *spo)
+{
+	kfree(spo);
+}
+
+static void copy_to_swap_page_owner(struct swap_page_owner *spo,
+				    struct page_owner *page_owner)
+{
+	spo->handle = page_owner->handle;
+	spo->ts_nsec = page_owner->ts_nsec;
+	spo->pid = page_owner->pid;
+	spo->tgid = page_owner->tgid;
+	strscpy(spo->comm, page_owner->comm, sizeof(page_owner->comm));
+}
+
+static void copy_from_swap_page_owner(struct page_owner *page_owner,
+				      struct swap_page_owner *spo)
+{
+	page_owner->handle = spo->handle;
+	page_owner->ts_nsec = spo->ts_nsec;
+	page_owner->pid = spo->pid;
+	page_owner->tgid = spo->tgid;
+	strscpy(page_owner->comm, spo->comm, sizeof(page_owner->comm));
+}
+#endif
+
 void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 				       pg_data_t *pgdat, struct zone *zone)
 {
-- 
2.51.0


