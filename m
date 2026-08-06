Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AE1DC5AC6F
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:40:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B5866B00B2; Thu,  6 Aug 2026 04:40:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28D266B00B3; Thu,  6 Aug 2026 04:40:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17BF86B00B4; Thu,  6 Aug 2026 04:40:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFB346B00B2
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:40:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 95DCA1C1334
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:40:36 +0000 (UTC)
X-FDA: 85070198472.18.A131C21
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id E8E1D40004
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:40:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tagQFezC;
	spf=pass (imf04.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786005635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AKWOh552WC04jaSGlTcexoVTNL/zDMo2t6Xnq8Dndf0=;
	b=t0Mkvwo1cfhHj1g11Jk0knUenuJrLJyMep1GKvNyMW3Br2zbxinN2SFhMnqzNWCIfYWfBu
	UgqK4rVj2kHBFzZwvl8L1ZKuGqHfPv7TyiViei1xJ77deLxWvCz32CqWdkClDlHnyztGwF
	cyOR9nJf/d7ltnXXIuy1ZLO15Kwqj9I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786005635;
	b=tQGpDNMaw39nmaQnZkQj/QcV2HozCYHbJkNtUJC1BA6IGF6UusSWJnhrljTBjC6SLxtbqr
	A7JCXK0u1iOGH8X0WasQoMT09cBANo2jWw6I6AVB4H8OCMrzILWiy4RN0zgkdAXm5g9U8U
	A9FNeTvyOsbnhB1ThcDeCruVreDBPMA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tagQFezC;
	spf=pass (imf04.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09CBB176C;
	Thu,  6 Aug 2026 01:40:30 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4AF5F3F9A2;
	Thu,  6 Aug 2026 01:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786005634; bh=N7Kx8cypRY/4tgLqgkZyPCXbOC37nDVo81ML0oOq7lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tagQFezCw9aBUWT7bOfI3ipYrSvBgGoc0nvAu5XpEVT8jAWZTUXoDkAzn54+nSZu/
	 C0359lFjQAXDgtRxm2t3RSVQ591J+t3FxW0ZNLk6ZGX5bMdhv/n3Wr7ekNo3EB6nJi
	 fG5//UTE+Z1Arn0RcPLdaPIBOCt1BQtKZG1psE+U=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Dimitri Sivanich <dimitri.sivanich@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	SJ Park <sj@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	ziy@nvidia.com,
	pfalcato@suse.de,
	agordeev@linux.ibm.com,
	ryan.roberts@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-kernel@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-parisc@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH 5/9] mm: convert PTE table entries in ptep_get()
Date: Thu,  6 Aug 2026 09:38:43 +0100
Message-ID: <20260806083926.1807279-6-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260806083926.1807279-1-usama.anjum@arm.com>
References: <20260806083926.1807279-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E8E1D40004
X-Stat-Signature: mpifjfh6o1rtjfdoac5gqt9je9zmwcjo
X-Rspam-User: 
X-HE-Tag: 1786005634-756915
X-HE-Meta: U2FsdGVkX18zKIXkN2v9ZdjGeakMSjBZNOti0Y7h25Q+W+8tB78SIgFyVRXv2hKarZlHl6Bs7FeD2wQ9IOWPch9g8p5KdlSSfST3ft7d7499U5oX1HAMPVggKIpW1hwiBsgs7kyJKi7hluqYXE8p/uaWWwfA13ME7vIyI/SJjjT7bXXZCSBOLHYW6jgi1E0fO9Ap9mMIVco2yiyLPYU3AD9V05UZo4eG3mYPe7MIBy0ggTMV5cf9hOF7CkqgcM/rTL2/LEgYHdfQiAcf7+brqWNFZ2M0pZ/rAUNWP++eaXLiz/etBkdNkXKIU7TETB36FvXswn5uHC7X0XCodeUQ/i2LM2bT5lsfdw+Avr+O2V2trpuXaBjaMfbp+rGmXOqFVL8VgVGaFopbS80nrQkh/9ePmgoZIUHV9bF6QAKGP1t3POodf73tDBP0MaoipZHeX2Yw0zkTZS5tryBIUwwsaIQ7Qo1c90wmYoyb4tiz+S7htKN6AiFup3RZd0uh/TmdL4K/TO5XSQGgZoo5o2Dyv66Zss16HDMPy1luH/V5AOJ6D0DoZNoJiuGXAqEeHENM77ZUOuB3/5j+qlrBkNgv2NK+e1K8sF0imYQ5w6k0cAN2DBqv0poYD0kXxpKxF8UYUZ1BJlnQVpXwi38o+KnL5aGoT9Ui+VwOUvzWAZ60IKZaumbJhUYYQrxttSRoClZf05BNofBl4XLTFC36k/5ZcnH3MsUFqmVNLXItCOQf+zdAz9rciLqujwZrhU7x9qnw9rnfetdYh79GWlyGS2dh9gl0pysQ9szUnRHahUh9CsYZcL3TitsgBTxPIx9bl5pEnLYi021IAIcGPumBNeLhCf1L5A3qdJm+Nl9uZGth5HxFBGIUoR8Q5pPpZHGL3viw+CgdQd7m4A5KaV+q9+Ic+B93eO6Nt/S975Got5JSFoukxdmQwoXj2LzUwNEHw36M4IcJtNgHwakiQhWMuxV
 ebeIgJj2
 MEeYLIZ99ii5ZCKSx/JKW/uizfP4zzFG7J5OMVmDbh3sFkLr0IgGRugu6vRVxXzcrcFl7n7OHydR4VB1wjhXA+6C3QaWix9lQToKAA3Z400asHbt154f3qN5WkO0QIV5mRCtoeP/SYoAWI99dOCbzRvddLhcc2xhz9wCtuDxUtmnNfxz2UOVDozTfj7xVpuQrjL0YK0nla70x2bJlHn6d5OyEI2nfacB+pkivobbuVvxbVqEzjSwUY32nH3ZrUlpb2wPlmUSD4c9F/JSaolKfiU9DtmcK0vsnNPVgwxbQGjnQ4JOvEwPoCSCP7vAcryai+oj6gWBKNrBgKW7Pv62cyXUxAbKtjA5Vu5KxDAlZ01/szVM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ptep_get() now accepts a pointer to hw_pte_t storage but must continue to
return a logical pte_t value. Add __pte_from_hw for both generic hw_pte_t
definitions. Read the hw_pte_t table element atomically before converting
it to pte_t.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since RFC v1:
- Define __pte_from_hw for the opted-in generic wrapper.
- Apply READ_ONCE() to hw_pte_t before converting it to pte_t.
---
 include/linux/pgtable.h       | 2 +-
 include/linux/pgtable_types.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index dad80d264aac2..1768421755a9c 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -493,7 +493,7 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
 #ifndef ptep_get
 static inline pte_t ptep_get(hw_pte_t *ptep)
 {
-	return READ_ONCE(*ptep);
+	return __pte_from_hw(READ_ONCE(*ptep));
 }
 #endif
 
diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
index 70c3edd00a01b..a625516fd67b1 100644
--- a/include/linux/pgtable_types.h
+++ b/include/linux/pgtable_types.h
@@ -8,8 +8,10 @@
 
 #ifdef CONFIG_ARCH_HAS_HW_PTE_T
 typedef struct { pte_t __pte; } hw_pte_t;
+#define __pte_from_hw(pte)	((pte).__pte)
 #else
 #define hw_pte_t pte_t
+#define __pte_from_hw(pte)	(pte)
 #endif
 
 #endif /* !__ASSEMBLY__ */
-- 
2.47.3


