Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADFBB60A263F
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ooj2ovVT
Received: by kanga.kvack.org (Postfix)
	id A50286B07DD; Tue, 24 Nov 2026 12:10:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A27806B07DF; Tue, 24 Nov 2026 12:10:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93D2D6B07E0; Tue, 24 Nov 2026 12:10:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 69FF76B07DD
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:10:09 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E010E1608A6
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:10:08 +0000 (UTC)
X-FDA: 85470650496.15.4B688C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 12A944000D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:10:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ooj2ovVT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795540207;
	b=0TIrey+0LNIaQ01dWDF0Hvy1pA0BgGJK5DXVOpqWUiN54IIfDoKpp0ofIcqEfVaoJb0rbN
	aSfCx9g0YeJfAFuk2eQKGXWow6FetU8yEZQ4r9uXRRtgl1BH5ne4n80W/vEx4qlxW5mvRh
	IHwzd3cD+GoymolvShq9yzr70/imXMA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795540207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7BfAuLs5fYXyjLRJaP4J35OcPZOVShOsa819UoKcWjs=;
	b=WeskXpdEp0b9Vzaehs6/TVc/MBkixQgCszGvNQGUKqv5tJURlHx1JaGfZdBLt1XhJ9g26v
	hP7h81PQYE4ecRHY1CJ3z8Zn8NglaGSgcOS11NfUM1ubm/6QPbI5heE1d+NIGf211/3bdN
	tVFx5zajsIODn+2DWyDvMbCv0eO7io4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ooj2ovVT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3659940BE3;
	Tue, 24 Nov 2026 17:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E901F000C4;
	Tue, 24 Nov 2026 17:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795540205;
	bh=7BfAuLs5fYXyjLRJaP4J35OcPZOVShOsa819UoKcWjs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ooj2ovVTmndPb21WMMkefT7zJJ296GKzaQQwA7OSz+P9P5NsjXGtMoQOp6MXLWAw2
	 iSb9ECRw4cHiATf6umuVL/Qlk1Fg1BU8cHDGtgeiSU2ji2uJHeazMZ7GWcoScx2fdu
	 +saz+nxNuR/KSeEnIPWzDGn5NqbIhdjC+EOPF3itD/iSVWi29ZU9UBxX9DWODDiZ+I
	 FT1GLy8eStMdGwjkTTzc/sidjfzdReEJy+l+Xrcb5MSbygV41OLtcDwBOUKlnosu69
	 wcHKUxMVAKjIiaWQ9415xaWrs3p2jdFR52jweWGzWRSvFhU/GIeUdGj6PLKkbIoK3o
	 42SeSi0fVH/ww==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 17:07:57 +0000
Subject: [PATCH v2 05/11] fs/coredump: convert vma_dump_size() to use
 vma_flags_t
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-vma-flags-v2-5-bf3fade93064@kernel.org>
References: <20261124-late-2026-vma-flags-v2-0-bf3fade93064@kernel.org>
In-Reply-To: <20261124-late-2026-vma-flags-v2-0-bf3fade93064@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, 
 SJ Park <sj@kernel.org>, Rakie Kim <rakie.kim@sk.com>, 
 David Rientjes <rientjes@google.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
 Roberto Sassu <roberto.sassu@huawei.com>, 
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 kvm@vger.kernel.org, damon@lists.linux.dev, 
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
 linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2643; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Dq3Cj8/uILUj0bBwtTXEJX6gkCMVPmmLF1KGw4GhyTc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZj+SdndrQfqTp0l/v6eJV21q33dr8+NoDw5jpkpMdt
 081mSfN0VHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJiNczMny+kui0+8w2/VXh
 HQfEqxqrpmrM5pnFJ1i3975yg9ALlsuMDA1TH65earIpKXnRVu+ycOVGTgejhWt5vd/ffBT+KWx
 uKBsA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 12A944000D
X-Stat-Signature: ds8mpbhw4to9u9gx61gyw761me5pkkdx
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795540206-272799
X-HE-Meta: U2FsdGVkX19TB+RPyIl9zZ9zm4rv2Tmxq94ZAw4s5KaVZ78qu8tXzMSpK/xjuN85e6jSjly0IflvytnOT7vIJ/pL8JYRqVZjWPXZHrCAu3L4ZO8XGP7MNI8zHjkLt6Y2IEc+3aZ4t2rwWIUylOs6EZWoc9E41NuMSjp+86syMYbfNPQ9OKq/3ZADru4Y2RstaICPPDDim2dthQ+CfD08lm4yFTqDqx7xavePDknIyfh3L8bR9DXy2LTKYsjdpmBn7FNHlvhMZEcYAbaiZ7MQjPGM1XQfHZ5qjunzEDlElrHmiWTpwAfBQZtk4ZvvVzZiyy606BOZd5YGD1/DdYLwOkTzIIAWxH6BxP+TU53m/dKka09ZJQ+IskdyN6ZTcMsxVDzHNM+peltG8iuflxM/wZ5c6h2XFOJ37AsckGvYA8OaFCRpkKYW2gDHQ7C6mWMt4+55WmeVw03DDIs2GG4U/wIleQSrStgzoj93h2qVhzzJiAlBLn4eWh2exAPhZJxlrSKgdY/rTNOLbBFupUxgYk5cc4+pcqX/Vnp1V285y7xyW+eHbkYpdLnc1rLvTLgOsKSiac35ToIf1RO4h/peWs82FMDAKX0xbsbCmDXxCqucohLow+W6AAZ8/QBk6Waghk6lhHdhPQqS7QsUsVSOiQtcPT9Eg02JRlU77wfloEg/U5WkbR1YeCZGrIlBbW3hXFmp6Kxb2Tpidul4n5v6t2GY3pILyUMulfrCZYoqKApkqkLUBeex9A4F8Y/M4/OEbNZEGdDBdCPVV7Tn7rMQqvbLlOW2LfjyeL+3GGI8vunhFnli5QutW4ZHORGJU6h+ChDfOKZRNlGrGeqeaCpis/ErwZV2bdOmz81h35RKpzsSuC2EJJFFEcwjRleFUsUAUc9x2Nut+c006TSKuHevyF65OmFtkXO7UlLcvt3BN6nBnigtjFL6+zqguJLut007E/zXivJCyEWkrFW+QyL
 HaHf2Umu
 7xJfA3iUVbb95FBsTxkuR2wm9z4OESC2keZ3PtTysLI0cs6ibtblFNNbi6NPjEXg3KooOHWedCK/BG+wApiCJUUsWWBIEXuBuF508s9b9OhqPmYAnOEubB30W9LX2KSd4U5hWELBuHhgQB95jBkRjz1+E46TQTIufgAL+KajoSiCwbN+ikRmMlcHdZSN8GnVCD93nuiH3fKm/C9U1CuM0hnajKWfgIOh8H4Gz9td6GUCvR+BSXkN5PhvRW1HHeFAXpjYEqc1ryzKfHHVb1AzErV5kwY8gPf9GrPjEfuShWZELuf37vlLfayx9N7BZrVK9j0803M5ztnLxGMa8UknEL/vi4gCxZVAU39nFN79OR70tUM6GuH+/KemIz2xH4XdUKdDeCYVB0U7UWZKjWotqy7YIezI76ETrUMMNsyRrp8w2YqF/TC63wu5qdhvsO+O/ro8Uqcd/Tgg4VCmvf9CfZgp0EZXpRHyWePzraqhp1xWQhKsxMBMKdZBZrh9Ewmsugcaof0J24G1H9UZhBVkK17CVCKX/5eARp7iPxxY01Q96n4dtXSQIdRvy0GE3ND634Cu/av24NHNZx4J6kNIgcnmdIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace use of the legacy vm_flags_t flags with vma_flags_t values when
determining how much of a VMA to dump.

The flags copied into struct core_vma_metadata remain legacy flags as they
are consumed by the binfmt handlers.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
---
 fs/coredump.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 82ef9d115999..d842cf6a30df 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1837,15 +1837,15 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
 	if (always_dump_vma(vma))
 		goto whole;
 
-	if (vma->vm_flags & VM_DONTDUMP)
+	if (vma_test(vma, VMA_DONTDUMP_BIT))
 		return 0;
 
 	/* support for DAX */
 	if (vma_is_dax(vma)) {
-		if ((vma->vm_flags & VM_SHARED) &&
+		if (vma_test(vma, VMA_SHARED_BIT) &&
 		    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, DAX_SHARED))
 			goto whole;
-		if (!(vma->vm_flags & VM_SHARED) &&
+		if (!vma_test(vma, VMA_SHARED_BIT) &&
 		    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, DAX_PRIVATE))
 			goto whole;
 		return 0;
@@ -1853,21 +1853,21 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
 
 	/* Hugetlb memory check */
 	if (vma_is_hugetlb(vma)) {
-		if ((vma->vm_flags & VM_SHARED) &&
+		if (vma_test(vma, VMA_SHARED_BIT) &&
 		    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, HUGETLB_SHARED))
 			goto whole;
-		if (!(vma->vm_flags & VM_SHARED) &&
+		if (!vma_test(vma, VMA_SHARED_BIT) &&
 		    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, HUGETLB_PRIVATE))
 			goto whole;
 		return 0;
 	}
 
 	/* Do not dump I/O mapped devices or special mappings */
-	if (vma->vm_flags & VM_IO)
+	if (vma_test(vma, VMA_IO_BIT))
 		return 0;
 
 	/* By default, dump shared memory if mapped from an anonymous file. */
-	if (vma->vm_flags & VM_SHARED) {
+	if (vma_test(vma, VMA_SHARED_BIT)) {
 		if (file_inode(vma->vm_file)->i_nlink == 0 ?
 			    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, ANON_SHARED) :
 			    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, FILE_SHARED))
@@ -1890,7 +1890,7 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
 	 * dump the first page to aid in determining what was mapped here.
 	 */
 	if (COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, ELF_HEADERS) &&
-	    vma->vm_pgoff == 0 && (vma->vm_flags & VM_READ)) {
+	    vma->vm_pgoff == 0 && vma_test(vma, VMA_READ_BIT)) {
 		if ((READ_ONCE(file_inode(vma->vm_file)->i_mode) & 0111) != 0)
 			return PAGE_SIZE;
 

-- 
2.56.1


