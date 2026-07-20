Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D90B5C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 02:19:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97A106B0088; Sun, 19 Jul 2026 22:19:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9530E6B008A; Sun, 19 Jul 2026 22:19:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840586B008C; Sun, 19 Jul 2026 22:19:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AAA96B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 22:19:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8959160730
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:19:52 +0000 (UTC)
X-FDA: 85007549424.08.068991F
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 49EB840004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:19:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=ToxhVma+;
	spf=pass (imf17.hostedemail.com: domain of chenyichong@uniontech.com designates 54.204.34.130 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784513990;
	b=x/tsdV7mNng5eKAp5SYEjlNwkeJgbY1GGx+r3bJ59LwJvhkoWkUt8RX6LKqiBPMedxeASK
	1cowxq+KPk9aduWefdcZ9w7fgX/NnCMFyQjZKbW6tquyk2IbrGSNprkNbFXj8ssdP/oZNb
	oBNlN5+mwC7Gh8RMpk0s46+kwx/cW+c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=ToxhVma+;
	spf=pass (imf17.hostedemail.com: domain of chenyichong@uniontech.com designates 54.204.34.130 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784513990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FzSyefZBdWz21D7smw2UotnDXfr792MR7jwj4+8Nwfc=;
	b=6Zhs0SURTOVzGqdDrGYmFzq2avffGlrhE2Zx2sH+qoZ6xIHEHHZVNyIzb9tuxiRhcp1wvZ
	vkpAV3Qz1yKByLjF1R5cQJQHEs786FVafPnlD10uBlrWTCRPFpAYAHKKxcsfuW18z8PaLS
	j3lm7TUe8da1I0B+mNqH38lKCPCjKQk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784513968;
	bh=FzSyefZBdWz21D7smw2UotnDXfr792MR7jwj4+8Nwfc=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=ToxhVma+QcOrKhIlgVCHFw/guEXd+fgI1a5X0bsPH4A9hl0h43dVzWwjlGwQfG6XH
	 fvwwm9d/D1qCkA3ZqJwgPl7LXlXlt4dCy2GrwZXINTt6vhNHvsc12X1/510xEM86rg
	 OpJcSS3o3eRsx7Lwrja7ruD2AaEg7E4SjevN/hd4=
X-QQ-mid: esmtpgz10t1784513944t75e62dba
X-QQ-Originating-IP: GN7JFQV9yrGdoYbSaIEJwawim7Nb4sbCkMWJto4qlcU=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 20 Jul 2026 10:19:02 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4858750843730928359
EX-QQ-RecipientCnt: 8
From: Yichong Chen <chenyichong@uniontech.com>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH] hugetlbfs: release subpool on fill_super failure
Date: Mon, 20 Jul 2026 10:18:59 +0800
Message-Id: <20260720021900.1376309-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: OHgofOj2wgpBvrznB2Au4n3j0A5xBRbOuyomQ5dQsrslY1rUO/aSs4Mx
	5BTi0elUyr2OE7NOJfd5z9KUpQwT+3dnvNMi2Lp/TUqViyUO7aHiDp/ZmIjeyC67/3jXmeT
	R28lKQfMQ3mviZow+1uC2ja60sc0+bDHhl/lm0zPGqV0K0P9inSTKtnFmNqbziyAdAhtdK3
	h++tBmJ+HaXVQehvoFef52vVaHdc0sVrgZemCEm3SSbIpsEOeXX+jpruYY9POBookcirpUz
	KsmQmLQinkgOIhukCyEetYhoEDVIu2MD4+3yRIvK3+7thvx5dkVxXLinPAjwtLXXqJe2fUq
	QUE64ckbwqkHUN/TQ0r9YHgCcJYtDM9FDyPfK+sLAliFZoJn4vmnTZ+IToUxaHaWeTYSBc6
	7Vy/KugaFzKyDanAh4dsj2DkaFNR6g1+duC3CSVQffCscwXNWkrWV8jM66yaxdjROsSWvBG
	Y9c42paQObQ0ZL4W9Z7ThWveEsvAJa6eBbUJa1h/pMopKjIUAroqNRW8g1oIyqCtIofDzLo
	NWkYErCcPvgt+EEAs5KzWENSEZMD1oihbMPlCQDhrcBxxFbnUEBe/r6eYUMAspQfj4ORa6u
	HYcIidDqVIx5+Yv2BTLX4yZ4PlzQ5amRtXBXis9NVJ/shXyiLe8Jl5vDnql9TTekGZQV7yu
	bhJnDjBhmOGESfSUNanI2+Z4m3gleg0VJrX0EMq0+zL0M9pCprv0OyEfT5FqGSBb5v8gddj
	EZSQHl+VH50i+vRMZrEnZLGskgQajaP3yOIDBIV0iW+gMDrOW3rDLfUYFHiM5yRcTsEYPnt
	M8Hi7W1H/IvaKdbjQNWyqCDF0/AASZr2hrfQXg0qFvvrsxOuu8eYXdyAAthprmWLkwi5XeY
	nuavEZIzuCM6kmViw/6bcO2AVuIQZp0LFH11vRT755Xpt2E2qktpjen2E9afRRztTuD5gOc
	SqygGX3r6WfEmpEFNXX2xKRMrBQTtZ8UfVnOeTnexGrXI401kqp4KYgOb9q4M2davCKZID4
	T9FX+akf8/ciD3sE2pNfDOdVtEGKG9a/Yn6Y4lUYZHH5iSZtmk
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 49EB840004
X-Stat-Signature: jnhywsusuo55itqon1rqqakimz4nweiq
X-HE-Tag: 1784513988-853571
X-HE-Meta: U2FsdGVkX1+Z+eDT+5W86FDjLM5u2ME/KYP9tEz+lccDesrIhfhl5Cy570d5tN3WRRtLwFBYZSm+fF/fpArxqjorDM3TMXsk7rcWCLzm5HevvJuyZgBBn//SZ1qq8/Vnkt5Gib/k2OutpUMYwNFS0DSApl8RdP6aeekCzS5DjyLw3ILtYqNYapkMNWDqfpdYBpZSDjhmBVJq/o1YwiDxXuh9c79zzsvaj8l3riDNg9wDIGaox/zlKs/xI1FnqKoVfpCl0CtVwvUJRoisCDz+DzW4kd32kcKXkAyQcp0lEsPCxt04EdhFhFeqMEF2wbZeYmXvB4UtT2FqnYKnpgCnVUtSHn9U1/8Imgn1XnLKRnkyvKr5LOhhb5qpq19gnXk/M2P0Uo42Pjm9LBIuqR2JptHx02JmnGaD7l57xRMTcM2346FUUuSsFnxvHswR3nGohP5gPA7602W7wncMohEy95D3Rt3DPjMOM9xjTcA7B7nuCwKjAQMGrWpUkhsVwr6mPkMumc6ElKm1QGYl5eGlWl+F8SArl/2fszCIDDKT/zDf6KMHZOGiR56r9bQKwIuXzhmmo1ZjRCO14vQXWgwUEVJ8KGlX6Phml00Ph/x++SITdbLyMPUbeDW5R7qobxLgdG84cKi6e5vB3s4nwla6u6/CV1qKcPeIM3gMrf8qBg35JxhACxX+ZVXNhWjWdsTDZ44v4H7NapcmHcX/Q3m9xmYnob7pLRrLL+TqKlGGvCA/18GekaXRFxFvrrNcIOdPWVS47JqaJ/93dj+9/PX19v3RJD1wVk1UcX1y7m9jVpV6r7RGP38pKgvowWZ9ZXShAGK2Z0Vz+NDsNvOCr/EVia0FgBEHhmJlmry5GCOuz/oPJOut3fLlQkNjFXdxtnAVb8oxsoMSp+z2Nl68rvli7z0hZ78dmSp4Lqpv4WlM8tbB+t+95ZePn4YToZi4S+u7dMT/s8CCkwhC+j7uNc4
 CLNraAu+
 Oazm6wg85GBln2SbDrIrbMccssgJHeUDhe11WCYED5ydtBSWdcSvl/jbqN1fVcA1MK54S+pTuG4mVT0JEfuPrWqHV7jTzKoqatVoFV2v0xivkHFCG89lSrNCStU69Bs/qH7mBuJcU68J184USG4R4C2Hpu+MAFz7I8tIcTk/5SHti1uOw6y9mr5zBWWUosUOU/Lh3jg07vNuR1yoxd5FGOzl7+fJEf/8jCRj6TTCfmCo+0t+LuL9A1BPvlnPK319pKo458gpGWMxAYBKpPeQOY9hcFsxCDqdvr08yedWrpHKU6xpUjvpvqQ9zeFb6MLBh/N1LGUqi4rRJV8iS5FqDuS5dFoh9JOiXAcI/2tGey8LnyHlItz2gPiaFb/ZvEsqZXNehIkMxJFCBoV4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlbfs_fill_super() allocates a hugepage subpool when size or
min_size mount options are specified.  hugepage_new_subpool() may also
reserve huge pages for min_size.

If root dentry creation fails after the subpool is created, the failure
path frees the subpool with kfree().  This bypasses
hugepage_put_subpool() and can leave min_size reservations charged.

Use hugepage_put_subpool() on the failure path, matching the normal
put_super path.

Fixes: 7ca02d0ae586 ("hugetlbfs: accept subpool min_size mount option and setup accordingly")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
 fs/hugetlbfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 216e1a0dd0b2..6a1d7e778cb0 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1419,7 +1419,8 @@ hugetlbfs_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto out_free;
 	return 0;
 out_free:
-	kfree(sbinfo->spool);
+	if (sbinfo->spool)
+		hugepage_put_subpool(sbinfo->spool);
 	kfree(sbinfo);
 	return -ENOMEM;
 }
-- 
2.51.0


