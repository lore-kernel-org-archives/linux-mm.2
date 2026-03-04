Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7FD1EDEC17
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 07:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C70256B008A; Wed,  4 Mar 2026 02:01:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE5EC6B008C; Wed,  4 Mar 2026 02:01:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0A066B0092; Wed,  4 Mar 2026 02:01:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8BB896B008A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 02:01:25 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 41E3458DAA
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 07:01:25 +0000 (UTC)
X-FDA: 84507484530.18.3770D70
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id CD70214000E
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 07:01:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FUB5Fd7h;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772607683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ujAxWBI/9YO9pDfOvAHGUhyTLccrKoAuXmKCcnkProM=;
	b=O7OQSvrCw8oy5Jnj2xy8EqlC3hKoEgzJgsbpW8brpKTOL3GHb7kzLN5w/o2bzJN+ascido
	cCIby8T4OKHFPsgS8/SpUGyLrLsrnonOB4WFODdk+FE9SezATyuvPfl/RHWAl8nEwZ3h4e
	54sXe2FeyYDu8WlqOAw6uVWQakFYksE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FUB5Fd7h;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772607683; a=rsa-sha256;
	cv=none;
	b=A5mAtibvWVQgeNFSS6V0pDGTaZz7gOD/EFMTc6B+TpdC0p8nLuJnC9w+4KZ2fVck64Qlu7
	Y6u5yBpyaKfRY50kT4Wom1Oh6X0U93WleUbGEzzVaePIwkgcHBEaFJmXmHEkQMeiIxr2/K
	h9SFCSj+LY/splqe5APSm1BN6PD6QKk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772607680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ujAxWBI/9YO9pDfOvAHGUhyTLccrKoAuXmKCcnkProM=;
	b=FUB5Fd7hKuAyUZrfs0QRjG5P0AU4qv+Kxtkp07ZzjrDUNabCsOusMyv9i1jU7FhQfTc1XO
	46Y9Xm1PY6bh1j6o29bs6LvKCo8/GPVVSu03z6zJe3Acdu/E4nBacAFwrAubFTkI97GzUx
	Ds8T5fuM5TlvYr0Jx77/juZZEfAluDE=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH mm-unstable 1/2] mm/mmap: fix Use-After-Free of vma_iterator in dup_mmap() error path
Date: Wed,  4 Mar 2026 15:00:56 +0800
Message-ID: <2360c415d4aba233d80666b8820ee31aa77c54d6.1772607155.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1772607155.git.zhuhui@kylinos.cn>
References: <cover.1772607155.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CD70214000E
X-Stat-Signature: cmo4d1taoep8a3iwi73aohq7735bsqme
X-Rspam-User: 
X-HE-Tag: 1772607681-564916
X-HE-Meta: U2FsdGVkX18zYhUn7yw6KvUv2lEwMExO+acSOjfRlpoGUpFa5C5XgbipWu3qus61ZV8h+axdJUe05HY6LhpdbIflNPOWGD91eYyd+7eWdb7QGz0t6FZ88NlrbAPZC4IMQZAtUb8e0oVro/jSVHaGnjpu2cl0YdYv2b5I2gD671qxItAuUDkxiIZb3JRs5+C2WugSMvlMnF4UCtBYGvd6j1zH2DVRRXN27th9tNdifTcSFfoY2FAZcQ0rA5xxofuJqubnUHfU/pHLvhNLp7Wj+DUBbzRnuLj8wLupL3cTs2qKQ1gpDWwWQ8v21A0DxQMm7RJR02tlkBLyx7/5FjYWpnM0wT6XEtJGWSC2MZ51htOMajgWPJXdGQ5PXU208NDrumyK3BKmjAgXL3qP0yRNLEznrP6Fl44yfrLhIs6E+4dEVNEYGRch/8BOB8gqU3dqmLQyP0r/UEs8f9LkqjRycvga+HcsChpSvUMuq1IXMgOLt4IHBSPjPgs7D6xxXvF7LRgBO6jvHLauyUf7eR+jXRw9uVHnwRR7Jdn5O7bLqsS2fEnjWpRkAwVtPTUMgcL8lc+X5hp48Yn2nk7aiTN7mdJziaDskEBlYGmbgeU6Gb6Vq9IhA3v+zxa+gj/0k8tAPF6RpNCqPPj1khfLQlCK1BL9/6C8nhZXcgDaajHAiXjh673kqiGIYr029K2qbAnatmahx5bVj/05O8gUdirNSn3zi2zdsZDsZFLfCNcn2kwROIAPaf0qDH9FNRveVOhl4ZEj34WnBLTLrpYvH9uQM5V01h/bpNlx03qG5lndBGLDsOZzpw+CB4IqQ5qr8BUi9qI0cPG3MU1orIfr4Yff0ayY4Dpl7IC6vta7R2okL9E8t43G8m38qgNQsfY6xdPfe9YRF0xnA1wrsGU3awtAeBTcaHNgk1KzF1aQW6XImlzDQiOMFP+TiyNheUV1JBxKkjsrbLtrU1XnXIzV9hH
 45DeS/oD
 KUDYT7i1wycmqiLynXSRw07VNyjBRD4WEH2MPdtgAmIjFj3xlnoKjVj1KXs/PE9icgaKz0EZrcKS2N5DVwzkQA1M7ELzGl5KFrbB4rZ41UWBdaaL+O/LQXJkFSg/q8SOkE1z5/vRlaN5CLqNRwVLIS6zc2sFkCuhA6tj9CTOGqTh0vEM2Ax/UPCLejer+jkZQF5wxeWo2anHZmHGLq9XgQkTHttpWo8NGfBwFVRYo57rnCsk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

When dup_mmap() fails during the process of duplicating VMAs,
it jumps to the 'loop_out' label to clean up resources.
The current implementation calls vma_iter_free(&vmi) at the
beginning of this cleanup path.

The error handling logic still needs to use the 'vmi' to traverse
and tear down the partially initialized maple tree for the new mm.
Since vma_iter_free() calls mas_destroy(), this results in a
Use-After-Free (UAF).

This patch fixes the UAF by moving the vma_iter_free() call to the
end of the cleanup block, ensuring the iterator remains valid
throughout the entire rollback process.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/mmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 843160946aa5..498c88a54a36 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1848,8 +1848,8 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	/* a new mm has just been created */
 	retval = arch_dup_mmap(oldmm, mm);
 loop_out:
-	vma_iter_free(&vmi);
 	if (!retval) {
+		vma_iter_free(&vmi);
 		mt_set_in_rcu(vmi.mas.tree);
 		ksm_fork(mm, oldmm);
 		khugepaged_fork(mm, oldmm);
@@ -1893,6 +1893,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 			charge = tear_down_vmas(mm, &vmi, tmp, end);
 			vm_unacct_memory(charge);
 		}
+		vma_iter_free(&vmi);
 		__mt_destroy(&mm->mm_mt);
 		/*
 		 * The mm_struct is going to exit, but the locks will be dropped
-- 
2.43.0


