Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74377C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 16:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 634B86B0088; Mon,  3 Aug 2026 12:44:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60BAC6B008A; Mon,  3 Aug 2026 12:44:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 549716B0092; Mon,  3 Aug 2026 12:44:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 260BA6B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:44:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B3E01407A0
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:44:17 +0000 (UTC)
X-FDA: 85060530954.21.CDC9179
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 868FA100002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:44:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785775455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VF9+9aXKTFOiyKVpG0eaSz51PqWtaVxgoEgQhQrqJwc=;
	b=sEXj9UPs/cIkCXv8BShmha4fW32xCQ+sHdhtQZeoZJOnn+aJRzklBRrjo7uPu4QeU1AVYt
	Sd8sVjwrE3NE0y+fOAolVBvWrAGWUv5gQO5WdmpVCCGUs+e/H0WDlA+kqKziRX4jR4D9hR
	PoTkxvuxpOj/jCy+tQXTmTnWXpmBhgI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785775455;
	b=ShKG6EJDfglup5Wx7KHYK3BwwVtZLDKbetrQnX4f4tpgRoQ/0UjOPs2j/yFzb7IJbw4krC
	wTtMGqtlEyF3e33EXqM8DqvkbHGXgCZKT8+W9EhLKTWAA3vW2Pl8AZalWGupYY81I5bR/f
	aJdtQotzPCOnlvbdxBn+muD+d71y9Yk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 050FC3FB3;
	Mon,  3 Aug 2026 16:44:14 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 154A3779E7;
	Mon,  3 Aug 2026 16:44:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CB3oAVzFcGp/SQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 03 Aug 2026 16:44:12 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 3/6] mm/powerpc/8xx: constify ptep_get() argument
Date: Mon,  3 Aug 2026 17:43:57 +0100
Message-ID: <20260803164400.531199-4-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803164400.531199-1-pfalcato@suse.de>
References: <20260803164400.531199-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 868FA100002
X-Stat-Signature: yky6dcijwa1ybqp8a9f7ea9zxjey9yqr
X-Rspam-User: 
X-HE-Tag: 1785775455-447011
X-HE-Meta: U2FsdGVkX19n244aMPhD2Do2/mZZoA1i5hfUV9FM06GNGVJNqDBO2gyGZsNZnkJAOXNEQejhcVTm3+V7ZclXqaT57Kc6/V0mJFCT5Qhd1EME26Scz5xPbwTeNV7vzO3bwHU8UW24hy+IE+2g+BvFnhF7quCZrxCFEQ5tgEyzEDf1xyt8F5m7INTCVkGYmLaocgZJLDHtLwFFupk3QkgOq+ys6cqB6E2J2IC56s0heNRemVtMJv0VHIma5Op03fXnuOoFtdFR3K8bIw75c1MJrSb4MWtpvkR2aWJ6DZwkJTjFGY4othaSoFH8jp526YRy7VJnfOfdfCUpLIqT9j8jV+CT6bmW5LsHeCqc92oZinv4I4gnE4HKzio/Vk6n9FRZrBdHbc8m2mYe5UhBrUCov4C0YyqZDExnr4AgZEcfjxxst0Kp/6osVQUMkFdStPkdstuLOuEzEsCyPe4NGPZgD/VYEMM7Oxdt2m694BLPektd3xRPOWCMJRCbw1HZ0fF6RHCckZ58LcJ6EuqL/IgLQU+dqxa0NPTqBu3DhgxaTNsX2tC8UGjTrptVmokVZXQ9MPpTVuHpYA2u4NzyE2wTlkHq26LW7tms/xbVMIcKGf5OsLmjAN5GByksfQOWiJ0260sAXVNKFPf7jqZREm8PJ0newnYL6u8i5kT+tNmhXt6fZYL8tHwMva9RUcudcj36QVBUZ/wVytxKmNRzk2g+My7cL77FA0CBcAxh4jMPe7piglkZDEi0cNUDBRWFTcPAqP4VVKUnO+IgFMadM/76v4UX5ryWhXyHdxxs3MOG69hlF0KGlFfHABxWh0c+uBz+o/voWmFloI7/biGS2tG4sxTJVsJxdpQM19dLpqFitWFkjSm3gqNPT4NJ4gGH98YdAxmMOB5Ylk8HEas3x+DQnN9c9v0U2JwaUpJZT5oo1ypyDw1F4u3/2ExCfbvvAGVrP3GtBgLmAi0qwNKDt+y
 CV6B6n1e
 j6nvxt52fK9Ti1eaESlF6FTDzXS7qu2TAlUFW+wRg1YQY9KFj7cMbijIbNxCh5Kl6OTsPT/mvC++PQfoMz61cap0QYSM1I/OkZf2ec62jVncfPoB7/QRtCHOpGslI35fyHw6iuBla35KDGSwGiXTdUTuWTaeyp64kRkeand9ta/CV0z1osxpUfOKQtseEkwtsRxq29xnaYDgEP/sz1ldyiQorupfKsYqTHf1oQxW0lMxo3hOioB4CePjWaGNrU9YaUVbLIUysFjlbWvhH5lvAP7cBQtisSnJybykmrCG9s8uXBuOstEUO2k8b9a8HkT10sV4u19Lz4fzUFSeeG2H+PUALZMh37MT5KlH+vUYN9RSnNsvH0NaBj0YMVh4CJh3jC6kQAYX9mjvv00XOF6glUOdu079AAdS/CIav
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no need for write access to the PTE.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 arch/powerpc/include/asm/nohash/32/pte-8xx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/nohash/32/pte-8xx.h b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
index e2ea8ba9f8ca..f2bab31040c7 100644
--- a/arch/powerpc/include/asm/nohash/32/pte-8xx.h
+++ b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
@@ -226,7 +226,7 @@ static inline pte_basic_t pte_update(struct mm_struct *mm, unsigned long addr, p
 
 #ifdef CONFIG_PPC_16K_PAGES
 #define ptep_get ptep_get
-static inline pte_t ptep_get(pte_t *ptep)
+static inline pte_t ptep_get(const pte_t *ptep)
 {
 	pte_basic_t val = READ_ONCE(ptep->pte);
 	pte_t pte = {val, val, val, val};
-- 
2.55.0


