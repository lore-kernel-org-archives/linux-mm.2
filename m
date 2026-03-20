Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 072701099B37
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 705176B01A6; Fri, 20 Mar 2026 15:39:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DFCD6B01A8; Fri, 20 Mar 2026 15:39:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57D646B01A9; Fri, 20 Mar 2026 15:39:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3AB726B01A6
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:39:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EABAF585FC
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:37 +0000 (UTC)
X-FDA: 84567455994.08.E8D6538
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5C9D712000D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gBrZd8U9;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YqqB2/wAajBOaHc6RSYsWK/Ls6NxWHrl2noLiJEcZzg=;
	b=TWYfACMwtzP/EoXtvPDBkMZ3MGXLzgu1hoS3OAMeVtA3mL/ej6wAbzvV9BNW8WvdnijHtV
	08cYW4vyyqPT+5/z78V9rhm/Y92Uu8EHk1HjgHV4GsnzqWAH+m+8ihMabw1lyPf6DOtOVh
	MRc5hxt1aICUn75LHcchtILfk6M2cc0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gBrZd8U9;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774035576; a=rsa-sha256;
	cv=none;
	b=0VRP+8aN2UIFjNl0N6BPZJjoI+i2Xg5Zkv4iwjHrrlIImVLEMvh1+innnHcUUJ83v5QDg0
	B3jnQcVDnky6TAmTNbSmG8tSHDj/BKbWiwG/r6MC6rfJCW/t/OQN9ibRQsvwqlrqlgh+eN
	QAloNRB6Sf3c+2w625BGHRgC3oJG1ak=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D551F60141;
	Fri, 20 Mar 2026 19:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEEFC2BC87;
	Fri, 20 Mar 2026 19:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774035575;
	bh=ITKDjpTWVAmcbe65xV3wfn2gYUdwv5ILrW2qUz0eTQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBrZd8U9Ujdbh5fVqt36pJLq2lzg6Tra5eFKl5KawyX/I/tRUy589y2a44OqFpazT
	 fgm/0/mu4evXvlsmTb08B2ZVmDYeAG6IqSi5hhD90wUuCjeeNcOI/3N3BO2sXKBA8m
	 3JHvgBo3YWtjpM6XMx7WU+bZQdxnYDHBNX1zBTCYnPHs2w+F08W6NUxN/ljDBy5ZzX
	 OWHDOPBy2VPGeui5M7+3m6aPndZX2fzT30hRdTESiw+GEZAiRutfLdRy62ha5r+t+K
	 ZTILxjVTTdtZdoiL4OdqELUt8cUiyVgjmhes2YaqV2eePs2xaS/YeLs4GOQBdsQAF6
	 H1EhV9yfi90bg==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vineet Gupta <vgupta@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Brian Cain <bcain@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	selinux@vger.kernel.org
Subject: [PATCH v4 22/25] tools: bitmap: add missing bitmap_copy() implementation
Date: Fri, 20 Mar 2026 19:38:39 +0000
Message-ID: <4dcb2fb959137e9fe58a23e21cebcea97de41a1f.1774034900.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774034900.git.ljs@kernel.org>
References: <cover.1774034900.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C9D712000D
X-Rspamd-Server: rspam08
X-Stat-Signature: epznj8mo9y3apf9f8uzqnwzjtfiow3yx
X-HE-Tag: 1774035576-394761
X-HE-Meta: U2FsdGVkX1/w80BHtTEl55Jdsp3NbWKaCXakspjiCrPsqfT/y4UHxxT1K1ScabEINTaoYJxzlsNl2hjeSDWPK59hljntkjM9yet6vrt3iPkgxzZelrg5cEjZfCGLlAWYvVs2vBGQUcBYxP3foS8WiABCuSLzYdW2ZcnNhZtdS5VOtyd1ntIkSE3nhIGvC17cHbrpdwHFUZzf4PNEEZMV1x78Ed7yDO9SKuHFGuA99GbHBmf9RN/D69e1Qg8jbHTYN3+KOzfpCjOTpMlTuQUAZmEKHE9KFenrnZlTXVtcn7zJ2Ngqw83+CdsGcfoK2wAXNYvtqPWlfsIaDbr+S0RJQFHuZWQT9JDwt51vM7RlMG1aTui0evD/SWlrrwfpt13ZpjFS3UoG6SM3Bi4mrdQf/y3ZvOqP0jossQnL8FADu0U4XaduWdBC0vZrRPDYUS51fDbaqhqJw7B+oyigiBoeFYp6b4cObSrLZfb7w4X8dyztJDr910AbNFqf1OFaAm7LTwLlW3PBI3QJe1i2kv81NYdU6fX8SKxdZmRsIuhUZ+6RVd8wcId05jLb7cmAixl4v/m8GXe6qFPlEkmwVvgDvHy6rrv8c0lZqKVTNCl/Uya21+PhHiu5Jjj4SE3hHUqVtktPWrcXUz80O7QxenTl0A2nV8nF89maqywVBfqIxm/rC28CZXtX7sQPsJuCMQsF7Gkmdu2bcpVU4Ga6hg8ui/WWqAYtYL6KWxbhw6Y9eYKT8LeP7+IYDMOLKjWxuKYNdTUHyX1t3L5wytF529eDZYMv61dkfuohlbL7mN3k9VSGgF5hlQ/RQwTE5cOLucXrREwq1/JBmAgJS2qQqnni+71GGwt8fGjX8HcESvw90hrYJ1Jvy3U1ZPcvEWQUTfybRER6YW1cPL404JGfau+ZdRD/7ykPQ8CDIGVGJ/9BC9fY3omKzMAzr2a03QqVaUA+yise7lRPOHDBL4D9pzM
 nxorI/W2
 AZSEsQLfkbZVS89NSSHQ0xan5AXNC5Evo/Yjti/O7bI01eHgUsU76mdU9dqAuK1ky9Hgp92kehyhr4U1ixcW9m2xMdZRrjSf8cjlB9y5SjP3cTBfID4zhurcZvgVKAIAUbjurqswjnehipQ00k1XFIU2mbGgrx+SZNSksh5UuoRWVzx6dK47M+5K1G1vmP9K4ltT4lpZiXNMhKYSW0pTXkHRQ7FHaPoBuvf+DlZ5W5AEtPFFyONJkL/g/f/noiN3IErBIs8ZroQiUqvux/wmuhS5G+RXIJsMFybBhnZm2hxtVc4Lux9hPwx1Ig1aCSYwy1fQSNnhIe+FWeOPmH+TwtBPzONiNJqqa7wTE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I need this for changes I am making to keep the VMA tests running
correctly.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 tools/include/linux/bitmap.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/include/linux/bitmap.h b/tools/include/linux/bitmap.h
index 845eda759f67..5cb4f3942fd3 100644
--- a/tools/include/linux/bitmap.h
+++ b/tools/include/linux/bitmap.h
@@ -55,6 +55,17 @@ static inline void bitmap_fill(unsigned long *dst, unsigned int nbits)
 	dst[nlongs - 1] = BITMAP_LAST_WORD_MASK(nbits);
 }
 
+static __always_inline
+void bitmap_copy(unsigned long *dst, const unsigned long *src, unsigned int nbits)
+{
+	unsigned int len = bitmap_size(nbits);
+
+	if (small_const_nbits(nbits))
+		*dst = *src;
+	else
+		memcpy(dst, src, len);
+}
+
 static inline bool bitmap_empty(const unsigned long *src, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
-- 
2.53.0


