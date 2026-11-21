Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0FC0606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 16:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AM5vyY5c
Received: by kanga.kvack.org (Postfix)
	id BB4296B05B8; Sat, 21 Nov 2026 11:03:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8B2C6B05B9; Sat, 21 Nov 2026 11:03:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7A146B05BA; Sat, 21 Nov 2026 11:03:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A0FB6B05B8
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 11:03:38 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DAA41A0550
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:03:37 +0000 (UTC)
X-FDA: 85459596474.04.5199E06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 138E340008
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:03:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AM5vyY5c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795277016;
	b=mTS/dzLLKDHgnrOut/JRSEg0FJCKBI2ZvIJcmWi+IxzLEUOQIdCvJCJInWjo2zv3oIpyld
	eXABoeTPutnPDPAX+U88hO73RKJ9l7Ou2iGtYezbL42DRQNwjWhNLWOCl56SM/SI8bC7Jo
	F8Qi16NDBNrpX1wGaUAjJQvvBjvz4Pk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795277016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fjtW3tWTyT2H196OmI5oHGMlahZwHiXtTvIY2ftsbT4=;
	b=Y+JtVcoOokV49u5SEo16jta+c888nEtMCXKgw6slFqobz15NZCcNYovJU4m9CvsDgu2HCD
	wLPHWUr8inF7p/B6NFNaq0tbAlWSAPxOqZ2Pb48BVGC/ZnI09jZzIi4HZd9tEfF6a4M/rU
	6J5jFVTZ3EeVPu0AvtgnMaVQnxppnks=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AM5vyY5c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E12B45A68;
	Sat, 21 Nov 2026 16:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7DE1F000C4;
	Sat, 21 Nov 2026 16:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795277015;
	bh=fjtW3tWTyT2H196OmI5oHGMlahZwHiXtTvIY2ftsbT4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AM5vyY5cH1h8CNycg8kMNZ88A5BtN4ZaCO+c8FK8uYi89pGcHUiG+1K6TVsaUJ/r4
	 5vNhLxRNRqRcMLAyfSLSpHCbR48SqHTMOSwkUzk/UvMcRgpEVXNHqu0Y4L8C+VxUiQ
	 cUKYsBeiVKPtKMzCurl5U/+sY2ho0AKvFLn2lHK5as4BKL8m/OxsroGYnqZr20v/EP
	 UnOGMwsamBqTugTZChTFjwKxQ8o/K9mxnfTjLD/uneDFB16IUKeUzpOS2fVWD/lR9D
	 QO0W4+lGI20OOQDSjkp1Q9tBMeYFMvO71mcYD1C7Y5CpMMRhvw0PgbjWMYHYTZMRPk
	 EnPBajbz/NLiQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 21 Nov 2026 16:02:30 +0000
Subject: [PATCH 4/7] mm/vma: fix uncharge after failed stack relocation
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261121-some-more-ai-fixes-v1-4-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
In-Reply-To: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, 
 Ollie Wild <aaw@google.com>, Adrian Bunk <bunk@stusta.de>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2955; i=ljs@kernel.org;
 h=from:subject:message-id; bh=jvGf/uqdCmatWvRece4f6kn/YJqJuQMD/ohnWFCk+Y4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIZD2zn3pJ7OiDo14erch31uQuPv7HSSc7u3nX56s3o6
 J3betzlO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRaSYMv5ieN35gtAu9cL/U
 8rPWvRuXAuqNnsxS3sJw8Z5N4vczB18zMhzW3qbz97v6SmUds4OzpL2eH5Dtqk3yXzwj4d6vmNu
 P1rMCAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 138E340008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: zjtcmueed8o648y4ayz1ymq6t4w7o7z9
X-HE-Tag: 1795277015-114125
X-HE-Meta: U2FsdGVkX1/QlBFvuyTsnS7wkayEGgzEvsG7ARfdQ+lyiAISA+AovGEAk7G4D74YdCRZO/v3CKDQ2OAQIitNfdaEcqJFCWzMuXSN7lx69IvB5HutQwSj5e0uU56ATnOPPZoGR//viPg4lw3I5ifZ3mCPhaC8CEJtDNvytL1ylduVh7LoQAV8S9tSHuJitkkAFHF2R1kGj+2nIdfayy+V7RpoR6VwOVEe/U3hYpwU/bkiZsN3hQrFDdktAo9hE+L9RCWsZrLjM9X0nRtO5UPg4d7zP3wDn3DH40I9XU7ITZ4qa/WCdcpXUaAjQhPc297NSc2AxmiJLpr6WrqXn/AbVlpMLfbiu8jQz8BFdkwBR7SZAYfuWkPK0YIQCH5HgtW+uyswdAjFpLDzUzJY7OuqN5O/ssuWKtKhn2UBSwShx3o/1QCkhmFmhE8LwKIbQNrnWxZEXsOe9aUjjiZLFrLmPKU9xhJTaEhNv6rYjYP0gMJIR9cP7jtpfFC2HlXtk1e4hVnq5jqeJcC62cu5wCy5Q9B7QZP5RCgiRcpzZcnghGE5c+X+FYz4agaO7G/5ozUG8T87yt1QUZaCnG7gOPJsVbgaj71Widw+3eyDMIkGZvHydN67NOYK0t3HsKUFtzvvBR8CCa78McY226ROeSl8PtzkTdNMmWFklDZNEUHUfPEEdgpd4uF9O9pD9T6nOVOvJDLuxf97RDk0mLJIR/USpmxfs7E/L1kk+sm8HEfnn4n54S7xbQkdobZl17WLxVz934OK2/RGLp+zyD7RfuOKdESWtg2pjgbBvsYl+57ZbGXsb7Y4Nh93VfvTWuQscw7oDNLAHzKDKiElsbnCutmhWRNLcEoEZnDiq7hBg3aGwI58biT+4fZgag0+2fqOkvLhSrOHGquwwXLspKqiUkddmUPkhhBbWQx0xwX+c4+ctX57SxjTjwBv8Ylk1lY2ZcqfbyYAiHoVX6UkUSPTuqa
 Xb235EX4
 vi0slHnayPuUug2YbWNnIn3d/lAW+asUaWDe+jHlgzBnIyCTCsTGvT410SgqlXMprhvPRrgfdUqxw/qbreZdtQ1iGmKM/gc26He62JMSc3GaJ2MScWoXMtrNlXKSH/tbQx0Qd7q6ca1yU8j3S/KgKpNQ5N7fltBt5UKOTO+7oyINh/gd2SRg62DQvshgyJ7yOqLnYeEIvyOA9EjKcvPEo4XFedOuvaOwU2n++lNyViyqqKx0CVA5TmPPn7dFFJsoxLDEl9EtDw6Zcpwq1mI+jJ1S6LdZFqGAJxYN4zAHTMeXLo87PYP/uCdJS9UPhoZMFuZpfKXTShUazP7PTX3LeTVJki9yB2k44yVOpc4vd+ZNjyJdLH3wViESIFdveQH+s8ogLkhyzBC08hsqki27wbOyPLf5ELqrq3fiBxEcOsD13LtmaA0iXTRy6o2x4/7Kn45hJ3lljlXrjD1x2yKeZZ80/RDJiH5/JUwRNXgFI3ToAepsppJdocM0pGyexcfFnEE2V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

An execve() that fails to relocate its stack can underflow
vm_committed_as, and the commit limit of vm.overcommit_memory=2 then no
longer holds.

exit_mmap() uncharges vma_pages() of each VMA with VMA_ACCOUNT_BIT, so
the charge has to match the size of the VMA. relocate_vma_down() expands
the stack VMA by the relocation distance without a charge, and relies on
its vma_shrink() to make the two match again. But it returns with the
VMA still expanded if move_page_tables() can't allocate a page table,
for example at the memory cgroup limit, or if vma_shrink() fails:

    relocate_vma_down()             charged    vma_pages()
    ===================             =======    ===========
                                    L          L
    vma_expand()                    L          L + shift
    move_page_tables() fails
      return -ENOMEM

    exit_mmap()
      tear_down_vmas()
      vm_unacct_memory(L + shift)   -shift

On x86-64 with 4-level page tables, the distance is up to 16 GiB for a
64-bit program, and about 128 TiB for a 32-bit one.

Fix the issue by giving back the charge of the stack VMA where its
relocation fails, and excluding the VMA from what exit_mmap() uncharges.
The argument pages of the dying task are then outside the commit charge
until exit_mmap() frees them.

Fixes: b6a2fea39318 ("mm: variable length argument support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma_exec.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/mm/vma_exec.c b/mm/vma_exec.c
index 586c52155942..84b98f1a201d 100644
--- a/mm/vma_exec.c
+++ b/mm/vma_exec.c
@@ -45,6 +45,7 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
 	struct vm_area_struct *next;
 	struct mmu_gather tlb;
 	PAGETABLE_MOVE(pmc, vma, vma, old_start, new_start, length);
+	int err;
 
 	BUG_ON(new_start > new_end);
 
@@ -68,8 +69,10 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
 	 * process cleanup to remove whatever mess we made.
 	 */
 	pmc.for_stack = true;
-	if (length != move_page_tables(&pmc))
-		return -ENOMEM;
+	if (length != move_page_tables(&pmc)) {
+		err = -ENOMEM;
+		goto err_unacct;
+	}
 
 	tlb_gather_mmu(&tlb, mm);
 	next = vma_next(&vmi);
@@ -93,7 +96,20 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
 
 	vma_prev(&vmi);
 	/* Shrink the vma to just the new range */
-	return vma_shrink(&vmi, vma, new_end);
+	err = vma_shrink(&vmi, vma, new_end);
+	if (err)
+		goto err_unacct;
+
+	return 0;
+
+err_unacct:
+	/*
+	 * The vma now spans more than was charged, so exit_mmap() must not
+	 * derive the uncharge from its size.
+	 */
+	vm_unacct_memory(length >> PAGE_SHIFT);
+	vma_clear_flags(vma, VMA_ACCOUNT_BIT);
+	return err;
 }
 
 /*

-- 
2.56.0


