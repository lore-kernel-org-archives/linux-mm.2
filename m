Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB199606A337
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=vYJYhTBL
Received: by kanga.kvack.org (Postfix)
	id 5B2606B00EF; Tue, 17 Nov 2026 07:16:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 562706B05B0; Tue, 17 Nov 2026 07:16:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49FA06B05B1; Tue, 17 Nov 2026 07:16:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A56E6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:16:45 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7160A0403
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:16:44 +0000 (UTC)
X-FDA: 85444509528.22.3F206A3
Received: from out203-205-221-245.mail.qq.com (out203-205-221-245.mail.qq.com [203.205.221.245])
	by imf24.hostedemail.com (Postfix) with ESMTP id E81E718000F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:16:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=vYJYhTBL;
	spf=pass (imf24.hostedemail.com: domain of 1045704958@qq.com designates 203.205.221.245 as permitted sender) smtp.mailfrom=1045704958@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794917802;
	b=IuzU08a6TAKy6TadfuAs1nBebkM89dPutvgz2JNvJLSCam3wo7f3WI7paaSfkNiI4sd33m
	kJn4jaLF43KuCOsJRKAhj1JUtugjGwO5gvgp9YxV6bKaDk4BDKGUIV6rLHn/muTSCvT5ij
	o7A2RnXn0TbzQT0EXDCHyjng1RCrWHo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=vYJYhTBL;
	spf=pass (imf24.hostedemail.com: domain of 1045704958@qq.com designates 203.205.221.245 as permitted sender) smtp.mailfrom=1045704958@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794917802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xHhwduXYjZsTcrueRZeatOj1/QPkxm9HvyXxSX48zKk=;
	b=4yR5HOF2ODhDaRSI63/r5i/2EWUPt2yu+gYs3QPN1knztXWbjPkko3jtIbGcHGWusj3Yxe
	oDxubc1esb5p7yIT5ms5v0A5OiolJwfrlSqH/b6hr2WPVvgp6G1fNXvOx7UsZoB40iMXwg
	L8kmda2GnapTgQsPAeitlY4fpZQfmSI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794917794; bh=xHhwduXYjZsTcrueRZeatOj1/QPkxm9HvyXxSX48zKk=;
	h=From:To:Cc:Subject:Date;
	b=vYJYhTBLfWhmHVROHVOV6S4IpaR1DlHP39ikL7rIeTbcLR6eqatJg6+pMU3MTN3LW
	 0M/92VYt/4YjrABwRe1i+gy03Pi1/WLCV3ldagNjUjuu8EEHejt2lATeXQjx8zJh37
	 fC7F7NQSzE6M2zVM+bvM1CdoMSRqA3h7p76P204Y=
Received: from DESKTOP-6LNKCJL.localdomain ([114.245.39.251])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 41B01800; Tue, 17 Nov 2026 20:16:27 +0800
X-QQ-mid: xmsmtpt1794917787ts32msj22
Message-ID: <tencent_1B8BBAF215484255F04168752D9BA778EE08@qq.com>
X-QQ-XMAILINFO: Nx5J06Esz7r7tOdMo4oLhcU1HEvq6piSmNZYgze6EELdW4f4Dk9mRfb2x4T8Xl
	 9ctfO5b2/AZffMmxAo7EgJG1/lOiz1h3R46i2psvEfjh0ssoBPYjaSBptlp3JCaEJ1aeAEOQizG/
	 n56t8jOOcvqNK0+DjPsAqIuo7lxd5bA6S/U93XSK3EYLQF0Ttkarh0UTfsIWk6v4LmZ49FaBjcNJ
	 xkAE4423kkrzGty/5lEn44ODq0YpwM4NpfJmoC4781cv7OEJ9+Qly0GFlfXZJGH4EdHI0T25wCyW
	 ts0enf5OsxAk0lUrWToNja8MOzIe0xInipZCvnmU35FZQJ5bzxut1PnmhCFt0RqpFd/yn9tjeImG
	 LC2VaNq3gPTBpBYFElsYvLH8l3zDfisQvS3fSR8J6BEgUMDG0SpS+mjlq7Cp+riYGGco+diVZS8p
	 aiPJhxOpOjAqlX1omY0XGt94k8oAr8UfdMoUFseLx+Q7LOc9kwN5Rb7BZt8atI93XBrXi0TgvI3E
	 cxRl3aF4COHXMeTVK6nP6LXY0uPvECxANe1DxUC7QpzuNJVPy3H0/jrXGn9NvfrzoNLjkiebE4HK
	 75oMrkvlUFg0FOeppkESVTmsRDIleD7AHKcURwfzB7MYdo/Xurme5okgtxV3fzfYM98hHiutVtGw
	 6PLg588TkomDuLLweuEL06EzjfEhXJaW9AzsE4de6qVoeb1WGPxcY2SfX8Nt2Km2gfiwEiqqTbma
	 krH2mfPRFT0X3zNqMndSJS1/tkv8p570KYsbZ0cwH8ayEEs6AvtU9IyIdWZXaMLllAjr1rurNRQb
	 99xvatiOArzF4KbSzFH+IQnyqrfJPRuRqMFLNOmOwMh8amv9WL441u9k3zjuj+xcG8kK2lf/PhRg
	 hDH5RlMgVy/TDhUdFr4b94GkqGF+UUr1azMBYBEb6YMnCspQE1eT+fRZb3mJEp92tn3Lhf1agGXa
	 su7xHHr6OawkJm1oZjlSikQmUKKagBzKqFZwC9uue+dv/XaayOWviyC0rUtY6yAA0MtHVejgATAK
	 OWlqvNTBBLICkuwVBBnGi1Ra1C/DEz3o6/tGhGfYIYjPL7vGLMEE03GUFITK5nVNQ8alXccm0mdw
	 81iKfTyVE6rUFFwZIAHRpayDk2dBv+kVb5Xowu
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: Jingyi Sun <1045704958@qq.com>
To: Hugh Dickins <hughd@google.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Luiz Capitulino <luizcap@redhat.com>
Subject: [PATCH] mm: shmem: limit forced anonymous shmem huge orders to MAX_PAGECACHE_ORDER
Date: Tue, 17 Nov 2026 20:16:26 +0800
X-OQ-MSGID: <20261117121626.1058-1-1045704958@qq.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E81E718000F
X-Stat-Signature: kn7mfenu93p5gbeprn61dxdbzdwqxahw
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794917801-248047
X-HE-Meta: U2FsdGVkX1+b/SaNvnJ9JnIufG8R1bFWk26g+NOtu6phhBdOp0it44jYT75k0OojiIYT94qZrzQ12qZMFF+TJylMI2xeIEJPI4iA+JWy1w94szHJVnQeYs7moIgnPJBJmpOQG4wYWOVRAettobHqTQecjhFYRkybn8rungNdQSalWAHjR/5kiCWdv3Go5eEJZgx+2VFXyCzQ2/nulLcS++UMgpUo0A03PCCH81LPZPM9bNrwcHd92ckDFRrY2vTn64BRolOK3aXiaCQv6d5w3fxSsOPehZ1loF9+rIa24GtZcHH3qD+zxf/FAu2IIapZvFL3ViEQV6nq7jaofSk+Fa78A0W5BGzJadaf92i+U/+n3irg9VHrckuiUfZlXFUfNFW6buH+FmU8QRZV1db9nSx19m4PsxZTt5EDVtNqQuI+JmRA1tn8wkKgMVVufTDwzSY2S3FX2vrSTFYtSAQ7MsFWPH4l5iG+3pNflC8Qsu4ItSAOFWabINpxBolsLH9y6JIQisSLVYymJqax++7WVupa7ft5Enxv5KTW0PaYWvu37fgoArSpWimXyvBKPzqYWWOOWpBdWcW+5l5Um+X0n3FXfoPBYKoiHUZRzNExJzSt92XMp0UC7fO5BcvtlHiPU05DcpwmhnNtfodRAEMbcZSIBY+lVEN3c665K43JUglj3iead2+SXrTHV+h103Au2DDMK3X9jFeiafmoLTX/BBU9dA+3uBU8j+cehPiPAAxhs8ixH1NzUb0afGsJdWnZ8qq0yxjexKHPOVSoCU+C+/Jp/WKudD5qttDxmkSJeR6XAJ5qwjyCCdfyX4rPlINpjjXkXpM+jbG59RyKbAhM+Lr283OyzXT1Jk/ZDqw9d+7irMtH+3YukwNOGNEi2GhWsp+o7DY1C6GP0KBWXaokyMVw+mqLfj+4QWOlqhRhUPREG3MTwFpJ/4MEfy/iWjM6wqIPU6BlB2Ml8KJacHz
 n2kZpRuw
 whvFcIjLvHW3FQVMWzI2hy8myL6kgCh+e3SIr8bRyuQLvwj+U+J5/N75ZEnmkcaD+DwezyWnuNqhKGPhcGAmF3JePWMT1NjFjBPH7EC8/RS/8exhIfXBsHKwvdUCWTTMeveRIXjYf8bJT6BFRkipPATTt3hr1jqSL4M2qH6jdsKxvyaZdoDUC8sOM5ZAS6lEQIzA3tD5JrwK62wzk57197T+il4gGSLKaw491X1/6DyoyCu3bqb7AMwlsMqu7hd2n4rEDvNTuOze1KRFl3pjvMcJx5ra12lAOWj18Cg9az5CErDxXxZ58pSiG8Lgy7w2VSK7I/gt6/LmHByF+20nNBomoCmAcGwHhgcegq59BWiXDygM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When the top-level shmem_enabled knob is set to "force",
shmem_allowable_huge_orders() returns huge_shmem_orders_inherit for
anonymous shmem without masking it with THP_ORDERS_ALL_FILE_DEFAULT,
unlike the other return path at the end of the same function.

huge_shmem_orders_inherit defaults to BIT(HPAGE_PMD_ORDER). On arm64
with 64K base pages HPAGE_PMD_ORDER is 13, while MAX_PAGECACHE_ORDER
is 11 because of the xarray split limit. With shmem_enabled=force, an
anonymous MAP_SHARED mapping can therefore get a 512M (order-13) folio
in the page cache. Splitting it later, e.g. on swap-out from
shmem_writeout(), triggers

  WARNING: lib/xarray.c:1051 at xas_split_alloc

and the split fails, so the folio can never be swapped out.

This is the same problem that commit 9fd154ba926b ("mm/shmem: disable
PMD-sized page cache if needed") and commit b66b1b71d7ff ("mm: shmem:
avoid allocating huge pages larger than MAX_PAGECACHE_ORDER for shmem")
fixed for the other paths; the force branch was left out. Mask it with
THP_ORDERS_ALL_FILE_DEFAULT as well.

Reproduced on v7.3-rc2 in QEMU (arm64, 64K pages, -cpu cortex-a72,
4G RAM, zram swap): with shmem_enabled=force, a PMD-aligned
MAP_SHARED|MAP_ANONYMOUS mapping of one PMD size got a single
PMD-mapped folio (ShmemPmdMapped: 524288 kB) and MADV_PAGEOUT
triggered the warning above in 3/3 runs. With this change: 0/3.
shmem_enabled=always and 4K pages did not show the warning. The code is
unchanged in v7.4-rc3 and in mm-unstable, but the test has not been
re-run on those trees.

The issue was found with a research static analyzer for
cross-architecture dependency bugs and confirmed with the QEMU
reproducer described above.

Fixes: e7a2ab7b3bb5 ("mm: shmem: add mTHP support for anonymous shmem")
Cc: stable@vger.kernel.org
Cc: Luiz Capitulino <luizcap@redhat.com>
Assisted-by: LLM
Signed-off-by: Jingyi Sun <1045704958@qq.com>
---
Note: this touches the same line as "mm: thp: always enable mTHP
support" (Luiz Capitulino, v8 14/14), which is still under review. That
change masks the force branch with ~disabled_orders but does not add
THP_ORDERS_ALL_FILE_DEFAULT either, so it does not address this issue.
Happy to rebase on top of that series if it lands first.

Link: https://lore.kernel.org/all/752f528f0fed5cdc9de12b54260b0495d4e5a6cb.1789695931.git.luizcap@redhat.com/

 mm/shmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 10cef89b00b0..41bb3f2c6b63 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2114,7 +2114,8 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	 * means non-PMD sized THP can not override 'huge' mount option now.
 	 */
 	if (shmem_huge == SHMEM_HUGE_FORCE)
-		return READ_ONCE(huge_shmem_orders_inherit);
+		return THP_ORDERS_ALL_FILE_DEFAULT &
+		       READ_ONCE(huge_shmem_orders_inherit);
 
 	/* Allow mTHP that will be fully within i_size. */
 	mask |= shmem_get_orders_within_size(inode, within_size_orders, index, 0);

base-commit: 666539eecdf4db623f5e3c3e55cf9f2dfad24aa4
-- 
2.43.0


