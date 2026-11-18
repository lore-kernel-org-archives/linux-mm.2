Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64D5C606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 10:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=LjRCyMWy
Received: by kanga.kvack.org (Postfix)
	id 63C3A6B05B3; Wed, 18 Nov 2026 05:22:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ECBF6B05B4; Wed, 18 Nov 2026 05:22:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52ADB6B05B9; Wed, 18 Nov 2026 05:22:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 276936B05B3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:22:22 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B3F6A06D5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:22:21 +0000 (UTC)
X-FDA: 85447850082.21.D00EDA4
Received: from out203-205-221-210.mail.qq.com (out203-205-221-210.mail.qq.com [203.205.221.210])
	by imf13.hostedemail.com (Postfix) with ESMTP id EAA142000D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:22:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=LjRCyMWy;
	spf=pass (imf13.hostedemail.com: domain of 1045704958@qq.com designates 203.205.221.210 as permitted sender) smtp.mailfrom=1045704958@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794997340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=so/CeAH0TndbVbEBeoF4tkF3aB19pcuqXJXgWV3BUF8=;
	b=43RSsNyYcsBiGEeMPoJemqBryo+QOR44xOVRdnHmKCKebPjcRygDW3fq5Jg1Vpe99UDAhz
	muJUZcRvlwYWtoij35ZWJR98Vxa8oaM21RfPRbGf+BzJWL/za8MoXW7MXQAMC1y2uedpB8
	7+XfPOvmUpO3IKXy8HF30Lk6snk/UYs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794997340;
	b=ZOAxaOquOr6J345lFtGTZlHasUQngiGM+E9yj/HszLmXziNNOtw658iDnFM/z7hDPYQ4O3
	hKOK/NCXaHV4EYm289W4NBrRbLJy1XIB82500AMBvIth1/2W3+MEYLa9cM0gd+Mj7FPr8Q
	CLnB865OQULF+xsHQGuTFmrbRIxB/M0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=LjRCyMWy;
	spf=pass (imf13.hostedemail.com: domain of 1045704958@qq.com designates 203.205.221.210 as permitted sender) smtp.mailfrom=1045704958@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794997335; bh=so/CeAH0TndbVbEBeoF4tkF3aB19pcuqXJXgWV3BUF8=;
	h=From:To:Cc:Subject:Date;
	b=LjRCyMWyuk8MxwA/B3/ayfIdZC8zf6ptOd1a0CgD49+DOJ3aTCyFSsvCpETmI/8hg
	 OQzUL8QYArGCM6J5F4LmYnAH50y02A3RnukQdmBIhWw3PJ4BXHl+Qh/anG34ZWFbZs
	 /hBJA/DsSZ8nvQS2hSvpSDPcFXgtMVsGO0wxG1Zc=
Received: from DESKTOP-6LNKCJL.localdomain ([111.199.66.152])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 588170B0; Wed, 18 Nov 2026 18:22:08 +0800
X-QQ-mid: xmsmtpt1794997328tz8vz7byo
Message-ID: <tencent_69A761EE2ABA6F15B942EBF0EE686B2DE608@qq.com>
X-QQ-XMAILINFO: NDD+ZwUaH+mrqhv6ZaLC/66xueoPLPA/oVmOv751sEPd2/kh/9Xt/3/ISsXNxf
	 KzHY9jjguRCdyQtuTSP7Y9GXvlO9waSUth8Gqe2r/r9y+3BB0itmtirWhupkQweIWtSRDfMauXf+
	 gT3WpoDT62+58tcsjC1OQDeMdnBICWqG16xASD1okoWkBn1JYpO1wbTpoMPz06abKPY19JVzo71a
	 AXW6i8dkw5S2nwho28OY/gKasuRY8d1syX9T7/m9JF3sV9+r94xjqV9l1knyFuQocDPVOVa4h4iM
	 Oj+G43pd80CBK9x09bqO/zI6iFtAL5OovnqihwujezbuJsnEBeIUPfP4uVaRwxOt1Ezq4BWLjFP0
	 m8SHnAKazSDg2LcNaPjanEfKQMZr4fWo8SNxWQ3W04WBvf9f3MVhBPZY9rFZHClu1+gfPt8oTsg3
	 MhR+HiDux+UH+bnZyVHlghIYPolSBgT+n0DBNGFUzM8GrZ6NIWSxJ5rglOqrGizgFOtKp6IQKaVB
	 RcnrXgSMGloT8lesM6x7b9MB67IIToVZG64zXnjb/FX1/EDPV6bh7FLEXEeuU5sb4kQCmqnB4cNG
	 JxuTeDA42YOoCOMBwdUdwQ7XOMJq5hAM1F2zQube/0bUX7h8iqUPaKktBIT8kvHvsVvwW9WmmRVR
	 R2iRTjJW6dkke5IXN34iIshc4uJ12ayua8+YMjrRUbRA4ti3J/6Svsrc+ZMv5PqRiGQFtkxFhmio
	 aSJ6LEsRhyVI4FJEPXFvjwzZzvLfDe+xK2Dnxq30/YM+4b0j2fe/dnwGghlY5QBactIxyy4RX0ow
	 H8Z0yUFc/c7cD8ODUGmqf2Tijp69CTpXIxh3NunfuVrhIRoYPb4jEIeLWCfqS0bry+UOP3hPxuyk
	 /NGmswsrQwHotY3JvrvKAEd7/1LV+94UniSv9DRlQtvE3MsY0obzkauMiafDvW98YQOK1kN6bi5Q
	 SRs6i4vnA4gEtDeyPrMKKI1NVL0yjlrGPzCWE7a+kHocSnpbmD+2GkBOd6CJu/81RXHW86HlOWqc
	 m/0vcIkq0ceGyT39C0oI60MYBuBm6SNIiOhlW/W/KmXK63nLg5A0S3I614SYs0Zkks0vPo7EN/5Y
	 v/ZJ8LYDmS8uRQWFb/pRVwU23nNza10YHSvFmZ
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
Subject: [PATCH v3] mm: shmem: limit forced anonymous shmem huge orders to MAX_PAGECACHE_ORDER
Date: Wed, 18 Nov 2026 18:22:07 +0800
X-OQ-MSGID: <20261118102208.751-1-1045704958@qq.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fe48bgesq9tgtycxqkb744nw8sjjs4w8
X-Rspam-User: 
X-Rspamd-Queue-Id: EAA142000D
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794997338-197321
X-HE-Meta: U2FsdGVkX19GheCnyvNhtpsC+0J3hWIVepxcmK2aadjsCXd21/uEVqjd7wvHuiF4T4Otmk2r1GVBBsYC26vGmTQkJegGSIihCfKXizR9eeN6BtJA0oICFUYVe3iJTThQR7b2OKrgPm4olm/rfA/NIzslZSQk5xXZxOO7/Z2Mbo999IwwiP89FzruyGrWniz/xDe3MlvV3On5IqDSrF3VOpqWbQ9095lw0mSxGp6O6P4BWTWlcVPTBpDLdT3LJRDJcqySLicJae29JiWi1FXcDbHZf4Ee9tUBGbxkVZqImImvu/3izaphjIFzxPjaei1Hx3uU/NEuSyQQZsFN4AVH0NjVKrUwLjNlPkA6L5X0gAvEu+oB6O1I5EjDye2p9B+QAGo6gs9GlMIyV5v+nmE1qOykJ8PuaJZbwWhIpDz+teBExQyIeZ3WZgPh9FD6pdRdD37Zl3jmDKfU7UteF0cU2+e54e6aVvLXOCvAtqxjWIXKUtUYhWNoFEtuBqDBaVZHMzvc/ngOONuhhrpIiWRjpvI5uLS8np0c8eexKvJ0U7/eq3OWsiMd2126YSfhE5AIt42gS+NGZsFTfUVnWciCAFTuH9+i5c6ep2MPp2FUD2GxI9AQMeuqb9C/y3xeuPtvRHySQEAaB6jrkUmFksOv+Zxbf4nHr2QUwejDsv/7uZxtT4i5tzSmi9cvOo+nSqwXSI68nsh/OLxkt49RsFIY3qCptmg0py3wGUZnEuNp8fFfsU7MoVV8NNlQhnm9/hZQyOEuzsd0JIKPRKouv+uIp5K/ak2pRzH7FZbZf6WqzdIxZr04BteSdu5fBq/niq31nxrB3mG8/slDZmhirT2ngUg1TWYRn7AbLJCdArey/25HIRbNRTyExcwZTibH3gO99l6UIO8E9ghab9gFi7qSeM3hX56ShW4CzuSqAPNEQtPKj5YPmg1yASOaBkKeEq9OwG9yKmn9YGgqudHlcmK
 515boekA
 /1JPAPrDkedEKwMsFgj6hS3p+tKSMSly1uIm5kUfgMgbL+lgSs3arUXlYZd3efzIl3EN9O97T2KLSlvkPSrbZDiXFKhMNY705Iq+xiiNjfr6BhlanOgkc8TQxVLJrxxrmE0UP3eziszMCDulUt7oTVJnWb9TM0ODsilWpp6c5emVnLpTnlAjL9otpb2fNkS/k9sNZSVrvauAFE2PRpBCvVjxhpZ0ZQBxKUiYlofHJgq3m6r07ySIoGDJvCiPOv7CFLIl9HIbiSd9Gml87RkTP/otxqlDqdVEaeBcI1JkbZvJQAnvE+JHdD7wLOj5KCqQnjiaDwsnj9xJdcjm6Tw5iRF9D9x3Qi4CVXcwnHDJL+bm5zRIeah2ulxu59ylLr6/xUAr4
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
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Jingyi Sun <1045704958@qq.com>
---
Changes in v3:
- In the force branch, set mask and jump to the common return at the
  end of the function instead of masking in place (David). No
  functional change from v2; kept Baolin's Reviewed-by.
- Re-ran the reproducer with this version on v7.3-rc2: 0/3 with the
  change, 3/3 without.

Changes in v2:
- Dropped the Assisted-by tag (Baolin).
- Collected Reviewed-by from Baolin.
- Dropped the note about the overlap with Luiz's mTHP series; Luiz
  confirmed his series will land after this patch.

v2: https://lore.kernel.org/all/20261118024517.21812-1-1045704958@qq.com/
v1: https://lore.kernel.org/all/20261117121626.1058-1-1045704958@qq.com/

 mm/shmem.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 10cef89b00b0..6d6b4a7e024a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2113,8 +2113,10 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	 * Only allow inherit orders if the top-level value is 'force', which
 	 * means non-PMD sized THP can not override 'huge' mount option now.
 	 */
-	if (shmem_huge == SHMEM_HUGE_FORCE)
-		return READ_ONCE(huge_shmem_orders_inherit);
+	if (shmem_huge == SHMEM_HUGE_FORCE) {
+		mask = READ_ONCE(huge_shmem_orders_inherit);
+		goto out;
+	}
 
 	/* Allow mTHP that will be fully within i_size. */
 	mask |= shmem_get_orders_within_size(inode, within_size_orders, index, 0);
@@ -2125,6 +2127,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	if (global_orders > 0)
 		mask |= READ_ONCE(huge_shmem_orders_inherit);
 
+out:
 	return THP_ORDERS_ALL_FILE_DEFAULT & mask;
 }
 

base-commit: 666539eecdf4db623f5e3c3e55cf9f2dfad24aa4
-- 
2.43.0


