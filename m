Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA1FCCD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:07:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47EBA6B00AC; Tue,  5 May 2026 12:07:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42F676B00AD; Tue,  5 May 2026 12:07:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7776B00AE; Tue,  5 May 2026 12:07:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A73C6B00AC
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:07:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BDA8F8C195
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:16 +0000 (UTC)
X-FDA: 84733845672.11.B2DBC8C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 030F940006
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Eo9DDHmg;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O+b83bGMCzyEzByJ+5LU82nBa96lT9m0LV7qEzNfGOc=;
	b=j1MtPZ6AIhOYy9mWzi47dHtmdvX8UDPLfN/6BZ17szrvTkm1xZ/e5HgvAEFe8SMW/5tfxT
	MrhbzTki8UU2qdQq3gwKp60GuH3R+otmnjB7h/n3c4EdKzZowegYAAgu4q0iL2tIpUPUYV
	w46XsMecW3S5Ma+E/7nGR/cQH/flbHA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997235; a=rsa-sha256;
	cv=none;
	b=lv91sBIPA2sFL7ZT8bCQiRKCaQBKQgIH5o2lkTXqeTvw7KZ7E9ynS9i9hZDunfslRwh1e5
	3T560JcvpJmJ2KlyprJybDE1+84A6itJ9P4wFGqiOfMGVGkk2n7VBJNTrmO2YVwL28WdBC
	L6AcGpAjJmulQ7T6rUSF42t09jyjz8k=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Eo9DDHmg;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8764A14BF;
	Tue,  5 May 2026 09:07:08 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C0D1D3F763;
	Tue,  5 May 2026 09:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997233; bh=+OGpwgzVEkFFPsMOgL6J2ZFY9bOrw4hijWLmgpJn7uk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Eo9DDHmg2QBzvLuzevofzQsstenbooOdc4Gqg47lWWeDfoebr41BuG04YHG89O/io
	 NaJ2FYF40DTRNat24YBclNyTeQWc6si99SI9TS3W5M0ijJ8UOdg7W+fxprrdZUTjFy
	 fo6B/KZ5vD2hAp2k1FAlzS8ZKdW67Z0a1fxCNUes=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:05:51 +0100
Subject: [PATCH RFC v7 02/24] set_memory: Introduce set_memory_pkey() stub
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-2-20c0bdd97197@arm.com>
References: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
In-Reply-To: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=917;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=+OGpwgzVEkFFPsMOgL6J2ZFY9bOrw4hijWLmgpJn7uk=;
 b=RlPHbUkc3oheG0ykOqKEOO0iIZrzIk4Arn9cjSnWXUBSSdJ8m6tPQJFPGDMPFbGVuo8Rinbti
 dTlSp8DlZ+lCl1fLdMdgguzhz9WrDCYuKFAxaqScfhVPCEzDVnEUOK8
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 030F940006
X-Rspam-User: 
X-Stat-Signature: r9784763oc8gmonhom6nuhnyckrq9osa
X-HE-Tag: 1777997234-402250
X-HE-Meta: U2FsdGVkX18cZ7eUmgNF2CT8uIRO4IOXHUxcfUX83SwW7YTr8/dmJBxmSzVqSi4l+EJNF6Ihm1ltuAmw6+a1h5VJUSmCcQDaR7iwrSE2B6Dv8xMhCVGcFSAj5XPSa7PfV9IfWzZebVsG3zF1cN3Y+oxpkP9J79PKiXN4ZLYBSTn9PVbqVIT7XPC7QHiT1biI5e/bod+0merm7mkY+C/v3bL4UFPHPW8E44DcYoLdQFcnVb/QQIHn4xXzlPFSoEzHh2WOZ9tULYUrxQV6SIDWPcjuIeGpZADXWgtEyvb8Nc5wx2S8T5a3n48x180oOALqHIYyO5wTV1oA8KP/feBWPS/0nl+Bbc8yHgi3Vvu4nVDW+p8wfdLIDOd5oF41RUZyr/kHVVf6K8Xh7OXNBDof0rD6CnwBif7Q62AcXlsSJeH2eU0iB60wa8LB8y9CdO3SaMQJsEde53U7F8AGdkb9lcCHMPXjwpoYcYC0s0iy8AyHc+2tXlAGUmjjXJecg9PBTTKg4JLI6tQJ6DScqD9SRVDZ1IvB+JDyYL0/TvMnrx840sQhSl/XClHxEzAdulh5vj6lvKrEk7IwKtT+t4MCXvjU+1OJMIxW0JPW7V3wj0JOwASa24QbrPGmi0FeYaP/0nfgtyFbtSPzGOkScFlsk4DO1+kEQz+Q7iPSM9PMPgwjG8JdQLGMC9CEHR4I/NSfOo2za64IlfIPj88Wo6JUpPaOpOyXTF0fn7oY0UgjBjZOI435voqpCZ8n8a2CS+QpF0rjJkSu8VVEjpF6GfLJTKQW0coc9M97j559ilOwhEFdqlXCV8PJQ9MSVE4hzcTjntr8by2RORypAipWfsfJOq7d0WTn7Yr/uK+aWjqIVYaPlZtsdwUTlxlqfMTijxaMErpqlbOwUwOpHGZw27V6G54ufB1LLzgoCu4KCCSVObB2HYiNQrt4T7smcSSTBcPZtt1/ln9K7TtDF1BB0mX
 HY+J7PqQ
 iNc61lytGY7dDUikLdj6sZnC51FiH8ab88DQAyJZ1PcMaGOPosXK5Ui7W825jfSlLypsTIudPCu3MYdk15ao5hQQf9cwnDDtUAUfziUvzcRsg4BpCEjVnFnDt7NZHrdpO5nK0ww6PhIlQylE9p0FGmQvQ2nk2AbMiMtStlk7JtcySnpFHPzt952T0a2HV3Lih0JEnpV/t0oK67IPsUvvw8tOyCNfStuEqWeefHf9KsV9OpDYgz7y9abNGxy1cvLB5ie4VunIGRUXwo5jHRnSsB1/P76VDdr+7L6eSkW10fq6gbTKnYpr+wslguiEvKCt9tmSv2hQ3Y17WTmw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new function, set_memory_pkey(), which sets the
protection key (pkey) of pages in the specified linear mapping
range. Architectures implementing kernel pkeys (kpkeys) must
provide a suitable implementation; an empty stub is added as
fallback.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/set_memory.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 3030d9245f5a..7b3a8bfde3c6 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -84,4 +84,11 @@ static inline int set_memory_decrypted(unsigned long addr, int numpages)
 }
 #endif /* CONFIG_ARCH_HAS_MEM_ENCRYPT */
 
+#ifndef CONFIG_ARCH_HAS_KPKEYS
+static inline int set_memory_pkey(unsigned long addr, int numpages, int pkey)
+{
+	return 0;
+}
+#endif
+
 #endif /* _LINUX_SET_MEMORY_H_ */

-- 
2.51.2


