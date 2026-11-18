Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87E47606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=z0VBrlBM
Received: by kanga.kvack.org (Postfix)
	id A03F36B05B2; Tue, 17 Nov 2026 21:45:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B56D6B05B3; Tue, 17 Nov 2026 21:45:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CA846B05B4; Tue, 17 Nov 2026 21:45:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67D336B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:45:42 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A2A9D1A063E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:45:41 +0000 (UTC)
X-FDA: 85446699282.26.76CEDD6
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	by imf21.hostedemail.com (Postfix) with ESMTP id A80331C0002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:45:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=z0VBrlBM;
	spf=pass (imf21.hostedemail.com: domain of 1045704958@qq.com designates 162.62.57.137 as permitted sender) smtp.mailfrom=1045704958@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794969939;
	b=Edu2BWzic7ruKX5ibvCAUeJq1qI1ZBYVmxbCOqywshFg2j7X0R+G92KfgHKNx4NvJ9HP0o
	0Z2fJEx8VQovQ+hrdrK/87nvgOt4zZxZaLTTKW2cPdF+1vx7oC3EY3EHvRLU00gb+74WwH
	4J+bAnVnOwnD3COg5zwDeoRIScU0MPg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=z0VBrlBM;
	spf=pass (imf21.hostedemail.com: domain of 1045704958@qq.com designates 162.62.57.137 as permitted sender) smtp.mailfrom=1045704958@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794969939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aWUwZ4yOXRgwWXdv9mQMt4h2IPiJ7i2CqyiC71rxZrQ=;
	b=4g2yz3P5L2KcxDeZbweXak5go+qsus7tPhGENUYc8jI4W+kq+4kyLf9Ujn5A99GuZrJbsN
	hxpUX3JOLBRgezi9lS2u/yTltrZbtAaFlOGN8HNpRxbGk7GC7EBRwUKY1mqr/SugbVJIl+
	qvayM9sBHh/wqmWn4fnHTWkkcc/cXpA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794969932; bh=aWUwZ4yOXRgwWXdv9mQMt4h2IPiJ7i2CqyiC71rxZrQ=;
	h=From:To:Cc:Subject:Date;
	b=z0VBrlBMafE7ALto0Ev5yQCq+FJXCnvTMM68deyryMtglChsnmIgVz1QsNL0a5Hcc
	 mer4VE0JIrRtCVBFXXZG4PCs0z74fz+iiUOv5TmCOzHxL2xKPQIUr0H3UaOn9ImGlb
	 U4EcKEvo+U1P5ZE+yZChcs02A30/C/T9W4hYI+as=
Received: from DESKTOP-6LNKCJL.localdomain ([111.199.66.152])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id B5183EE3; Wed, 18 Nov 2026 10:45:17 +0800
X-QQ-mid: xmsmtpt1794969917thdjdrz3a
Message-ID: <tencent_FCBAE9157D42FFF00E681A2D5EA72CEEDF08@qq.com>
X-QQ-XMAILINFO: OKkKo7I1HxIeqyjo+PW2szCQuXozTViUajm53Bq7Ru891VqoHDVA9qJCiyO/sF
	 O1+YZvw4FBJoeqGKqN0aKu9q39w/5FCaZ3zHdzLEH5hqXN9H2scLaF+k0XmF2Ix+jBqLbfj37XpN
	 O799si6nUvJjcZElalzNg2mAmHZczvqgtQVLR4NVheTEzXn9DHgtZFC322qBHfSyJlDuK4H7XRtD
	 xVXHeMxsKq6Z9Gdml7a/RBeC/eJTqog0LCFIg/dnJeddeduoNbpRxQWvKlo6eJu0cN9IfUMo76cW
	 uwMHqUs3Aki2JW94EQLQC93EpZJYwdGJCeWFOdU+vdj6GhTasgvAha8NJR68gGxnV8PqPeFkVGl6
	 vaBOa20bNfRSDnTSa2xSskuI28Rpwcm/0bC8sxOqUQPXzgVBBkOExxeq/IvvY6IABupXayWA2Lq6
	 Gi4IQSx7FLzbeh/ZMEj1408IixWDOvvrDiNtU8YGAyzRjjIWsq+denB6wjCgdRns2imSp7VACXri
	 ffAhyb7VipEqrYieYfNeB56tfXkil2lmIDF2+zYxQF8sNtbLXrGo4WWQwxjImKpLep32iHU//e2f
	 62HSxrE01/EnRwCqHIERzjoNnJpdmjU33grJJvwyJ6aJGMS0491pwJbIbxsp8Ocd+tijUZWQ3vBR
	 25hOfiByEU0CHPaAscN6MA3TlB9Mo0yH6hFyxLt8INiMIDojsDlIGNXJF8LXfwMrTlsZJvK/jRJk
	 C8ZcNcY8OFkqACpa/kAtVkCa7fysvNJyOgmUnWxxF+S0XhFVUeHMidb/sRHhLQpXgy+XrMa7iLsP
	 ig6a+6ZZBnTa9BHkLhPt5Jh3PZUSuFG1njp+kuwaO8J7LXJ21BSodIVZqJWT6XJAgFaS3WUwf5Y2
	 YJCXbh1g6a3yG+Uf9qc9R5h/wIs9lj1Ui2Z3ZyKGbScI8CYdf9G2ftbJfgZuYcbNyqTeRDeDkqeh
	 Xd/1sz0JSjYn5PJV8VyUQu8HCcj3+Jk4/naDHHnjP9OO0Ru4ryjNPFhJewnTwHANtexRlTXkAFbo
	 Yq2Q8gOG21Mn/ddleyWcavb4WjDBsuYYjWy/rosLpqEn4TijLgWjbrJlACpRk+gTGHCckdZraRp4
	 JVVJp6uK518SIfsobLW5QrIkHbGA==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: Jingyi Sun <1045704958@qq.com>
To: Hugh Dickins <hughd@google.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Luiz Capitulino <luizcap@redhat.com>
Subject: [PATCH v2] mm: shmem: limit forced anonymous shmem huge orders to MAX_PAGECACHE_ORDER
Date: Wed, 18 Nov 2026 10:45:17 +0800
X-OQ-MSGID: <20261118024517.21812-1-1045704958@qq.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A80331C0002
X-Stat-Signature: idsyrn54fgtear47jh31sw1ae8a45sqy
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794969938-953267
X-HE-Meta: U2FsdGVkX1+lyXwa2R+ST6/XQGemEB2G4TRC4mqmDj3V8tGp04yVxfCqI280vNyo6vaBKNd8AWbt1lIhI9qraiCuQXwDV7A/dK8ftNKmNXnMpb3SHFKJJNPWhxQKEkFqxzp7H29er5Mm4DpwT/XK94uWdWnMF+94kajdY/GwWWsROwBZnV/r+9RyiJxOLdUk0ikBRGLurqjohBcqsMLjqbpdMal456xJ9eED7Azi+B6veZtFcU9ktMf7vuBkhyUoxkNEOEbJJ8ceb4UCScM80bxYinYRtvxrZd4THwUSuPcNGhTxGe0s7oOG6S4THFZH3bRwTBDFbtidQtFGGM8mtKyw3Kcby7UQpbaJNoffcQeVWY92T/p2edjezBCGeRkHuEHYB4z1pQdkFzyQCkUSpCOZfNg2RZ+/mfzW5jlc0sVZNCW8kqOTVpRITZffqO/Hv9J4F+bQ8p3ub4afzyeVXvUinzTgUO8QIknnY7CRyNvKszxY87hgL5siZeTYtpxiu4ddJPfnXF+OgQDVuo3lNz5RWjbyVJUjyh0xW9tTtD+QVNKzIbrGCREV2NS0XlyMiCmp0vTsMc/CuAJm6UYq/bKljFF4pgE+snbBAhDJHAaraIOQmuFRIUl4d9dnNN7ZGfx0x2BScnwS6FUh4/071gAnkyDLyIRfYzNA91dnGzG3fn+9v6FbxddkvMJb/Nqdf3ckONQEt5jnrupfNPLvg4qIJHTNf3Gc6IQGK1qgVIERjJ7IStm5glfLuqFBa+0zkuArd1jqxemJM3CiiwLbLYnQZ975EPbVvk1ruqdapJM305b0CsUDV1nWXXdoAUl8DNOZUv47o7JaFZppU+hugwlLA6VA7vRUo9lRjWHyF77OdnD2wahnRt42A05LCLwaxKnxH2oarI/5oszH0060ecWxOh0bHu/MWCTr9za/sVmRPLXfjkTfKrSdN/jeG+BgKznnW0QBBu0S7rVL6uB
 1BvRpUuV
 zsSaU7SKDNdrYd1/2qS72DuP1elaM6ov5q43bw/Z/Sllz+IKwIrYahGAV97F4Pvm4fNTguFk2K40kdpgxh+bP1yx0CEHrSXNWeGtrrn+x6SqRe+KQ32NH8P2f4s3C2+3Rp9oUg5ZVrXtA71SMAwPgknUud9H6O+ysIvgUR2rvJtX5lPyZsvhOVcV80YxXavvVp/ArfU5XwnLhgSWgBjk6RJnH8981DDKRMSjXq9tn0It+s5NeCtuzfpw3FLAtznJ6cepMqdh0ickG5/LGkWp6zQ18cOkeWOvFzrCfxVTiIRsaxpHmHbFe1YuJgoCW8oqGTFd1s849BR4tTTVp4nk5oK3bAtolWM/H3vUtKnr6nGpexJMBQa4kFOsnMc1KfO4Ryr6j
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
Changes in v2:
- Dropped the Assisted-by tag (Baolin).
- Collected Reviewed-by from Baolin.
- Dropped the note about the overlap with Luiz's mTHP series; Luiz
  confirmed his series will land after this patch.

v1: https://lore.kernel.org/all/20261117121626.1058-1-1045704958@qq.com/

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


