Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C88D3C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 18:08:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39F36B00F5; Wed,  2 Sep 2026 14:08:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEAC36B00F6; Wed,  2 Sep 2026 14:08:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADA836B00F7; Wed,  2 Sep 2026 14:08:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92A636B00F5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:08:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 31B5D140248
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:08:22 +0000 (UTC)
X-FDA: 85169606844.07.B56D0F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 66F1AA000E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:08:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lug92wra;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788372500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nvGaPSWtkLzLgWlLesnGbGngcPbb0sSWCIqegrOKGcc=;
	b=UnKFajHapUK6p44UHccSFw+QvBZgNpV7QeQii9ktQxAaC2hk18qkgq3kkI/cqHIulrnttS
	f9KNKx76GXedoJhdFMAjnXCjVx6z8gidX59FwjcAVhe5WbWa6f4KWU5//l+bGAVCjy9W8C
	MK3NhJQha6VNkdB3mXLW0d5WgBfsrAY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lug92wra;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788372500;
	b=8CgKhdifzwznX+jV+XqtPKrnN8T+zmFu+rzIevhmMnMSZRhiBT9Dp+AGTAvBq4CrXyy3ed
	WB0HNmm4RX8Gh4LPFAo1xkIdWvbgOmGHBsdepKpyYsexh1YkhtRHV+/nQxD5Hf6lmf5q+0
	Ka2iFMCo1PvhPVOOlkcU9GaBLZ6LR0A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7F6B4191A;
	Wed,  2 Sep 2026 18:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEB91F000E9;
	Wed,  2 Sep 2026 18:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788372499;
	bh=nvGaPSWtkLzLgWlLesnGbGngcPbb0sSWCIqegrOKGcc=;
	h=From:Date:Subject:To:Cc;
	b=lug92wrauFUoadUDfedDcu8ti+QVzBhMs1SeM82948yNlzKcVoUOmHlQMhEPKHvEj
	 /W/HD79ZXs/TYe9SBkeJNNIiX+X3Z2+JXyoXC8ospedxxuOlWvflr4xmDWLy5Cs1wf
	 tjL/YC4Ys8t0GVdDqSRUy8YH1+mHNEquEWt18JUl/9JvfggIzcl8VyrB7yUz5Mf5TF
	 msUeWm4fRYV9x57Xy5DV1Goqk5LR8W/wbtxkiEMqcMdtbkGTnjuUcztfegHLQQmqPD
	 hOAztvdjXHeYmNoShziHCruKSzn1/n5yNVsopKaBEsXbku51EPrOI2QNI9mo5VtXPo
	 d0m65nsg/wZpw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 02 Sep 2026 19:08:08 +0100
Subject: [PATCH] mm/vma: correctly unaccount on mmap_prepare() failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-fix-unaccount-mmap_prepare-v1-1-ea070189fdfb@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MQQqEMAwAvyI5G6h1ddGviEhoo5uDtbQqgvh3w
 x5nGOaGzEk4Q1/ckPiULFtQqMoC3I/CwiheGayxremMxVkuPAI5tx1hx3WlOMXEkRKj8URd7Zt
 2/n5AB+q1/s+H8Xles7TijGwAAAA=
X-Change-ID: 20260902-fix-unaccount-mmap_prepare-0daa93d56f74
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1478; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Ugek0cCv5pYCXE3BNFAh4JNoRgqA2ID5EXm/A9YDk/0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJmpAke0GAKFlzns+z+tE1Lp+81e5eTFXVL1Wa91WzFC
 8dOayct6ChlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEQhcz/LNIKn1ZYM4w/XjT
 18nVnZwqEkv5JWWnyN0NnX4l3ed53FaGv7IJ2psOTxdZJS5t1ld8wWZ/36aX8iaiuvZXnj7d6mH
 pxAIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: yrgn4q67acjtrqoddnkq9qadt1ugitk3
X-Rspamd-Queue-Id: 66F1AA000E
X-HE-Tag: 1788372500-771646
X-HE-Meta: U2FsdGVkX1/Naix63JIBbwtrjY9WxtQ5YAlyJsKbUei2U3KYN18Vf2vN/m7cbBAuWQrF/lLxw2jdIao7SEOV2UO+pFA+sifJht8NCeEyzysl+Sgoadhg79naKVWS45mgorI2iuPA6q3WjpZN/b0rKNZU+zdmz7sh051G2SP5pc2zTirFIMT1h6ApGl6aMKC67/V8sty0Xw+quy/UbonK5COoXrcQBFHaHnQxq5XKzimdH2pnI4Jx6GoUlNpD2XUEKROXmxmrfuapE3S6HSHYF2TQtKdqct8VOcsIjNa/H8C7XHmnTcXCV9yVSVt4YrBUjI5apJJNM4aK905LTgGSXE0fNGlRRW4nHTQDF02ILZ6rZHC04OYPHdP34ATTcuwYTUb8dJ/DJO4IQrgrf6dh4H8Mo+ZgTs9jFDFOgtapE1Y8ByQo7UXM4Beqv3Rtge1Q0kLar2cN8M0i2LtNBRJN3QCXEDlvN4zysvATKcO0vqTbq/VPH0YnpLn6hgxqbey43qYm9w15N2tL//JiVbzHZOUZMfRwzzmExdVY224SRtRY0j4C3jx/2Jm8+JfChQN5pXDjaDeUoxdhzR0sj1iDKYBDxFdToFRNXcR8iDMULQKYim5qHlxtZcYxADA3Qguoo2ns8u1hHZYDLdMGnrTXJFS4gb0idjV+dIKUF3DLalf1bsfbo1jBcKYWKxoFmMfp9ICtmAvTi1sZ98awSVm5TfnRi+PqWQk+1ZVnPrOLQePCjmZiJgvTa96yg55K9cH0IIn74svz8tMY1up5nfkJVdIOKF7qlrClTvTMX10N8OOLgeJwaIGxkH4xDGIC4GCveYRR1BU1spYM9NP6SXtSRNEIndb2FRinBZARuGGDrkB060Q/4KSqafa4lUvrlgPj//ZzHEOhoNXvfn7icNBXdi+1ZrIRV4xqPFzIuu6P88eerjqCAAHBVYKKKCoALFWIYb2bMqbEjxLim486ion
 h9VMmDTk
 yUJh00vWnljISvryVVgX/D+H3Ni78h7TCZwqehnyW8JzpTQL+uM9q1q1P4frJjElcZ1vItjh5m50s7rRZD9PyJTPKm2DyQl8xiKGD+avtkTWV8W7E2YbGQZgdMJojaZ8WvYsIKYnf4PK1g2eIFcz5XiLugIgmfG4TIeaObpgegRuHiNtTtWu/NCtghXapCg7sfqosMvX0kMrPUBVCUZ8SKH9NOKpbfZ8cPdIjD4HVq4aIfwi6MnDOJvlr8F/WT+QJMlDNMgYYUex+M+yHoiu+/op1/MjlSIzZN/92
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__mmap_setup() accounts memory for relevant mappings via:

security_vm_enough_memory_mm()
  -> __vm_enough_memory()
    -> vm_acct_memory()

If __mmap_setup() fails, this indicates that this accounting did not take
place, and thus it's appropriate for __mmap_region() to jump to
abort_munmap.

However if call_mmap_prepare() fails, it also jumps there and any accounted
memory is not correctly unaccounted.

Fix this by handling each error separately.

Fixes: c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file callback")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 35e7a64855fa..f29abb30956b 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2859,10 +2859,12 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 	map.check_ksm_early = can_set_ksm_flags_early(&map);
 
 	error = __mmap_setup(&map, &desc, uf);
-	if (!error && have_mmap_prepare)
-		error = call_mmap_prepare(&map, &desc);
 	if (error)
 		goto abort_munmap;
+	if (have_mmap_prepare)
+		error = call_mmap_prepare(&map, &desc);
+	if (error)
+		goto unacct_error;
 
 	if (map.check_ksm_early)
 		update_ksm_flags(&map);

---
base-commit: e3b5239afe1b8f0194db7436b17c33e94c1988c4
change-id: 20260902-fix-unaccount-mmap_prepare-0daa93d56f74

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


