Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19170CC6B24
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 07:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B391F6B0088; Wed, 14 Oct 2026 03:26:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2DE6B008A; Wed, 14 Oct 2026 03:26:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98B016B008C; Wed, 14 Oct 2026 03:26:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BDD96B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:26:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7868A047E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:26:12 +0000 (UTC)
X-FDA: 85320398184.16.F519419
Received: from mta1.migadu.com (out-48.mta1.migadu.com [95.215.58.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id BF3AD100004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:26:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D1QEeRz0;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.48 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791962771;
	b=rEiiaGRbtVjjmQkX5R2VpAGP5HlV/bBHymfdB8d2LWebKM3tp9LhT/mDOzdaDNxZcYT7eX
	JFzpB4h5youv6CLgN3u3oTb60Ek2YvOO2YGwI2r/M7A/6Ayd4RFhgeLDS+2eceWv3znxnk
	O2nftI5+BfZgAahz+idmwqrPrs5ElZE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D1QEeRz0;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.48 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791962771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+RBVSp3rJz9n0AZl54Q7QDTDYZaqjYt8GYBhm2QspE=;
	b=3dscp/OpZV8MvqrvFgoeY9MjeBftRMotWTvKgwy8KCjSU0sqyRF43Lk7M7Yn7u67k0vQRo
	32iJ8Mw4qx4xiMY6znFrWiQ7pfS9ID7NadydQKwuIdW5RKs7t8zNVk6sxqDtJ6uuSxSpzO
	7k76AVZeLYa/+xiyl36BzadTAPEWLis=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=hHZJT6a9AHSI0FRADan7O9ikGQ54SPVMGHXSCUhyLoM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791962768; v=1; x=1792567568;
 b=D1QEeRz07pyQk2O3GiZVOT9dvoQwUDEyqePUb2wnY/+hVCDcveUWV0utkMw1YZVznUBRR33R
 P0FTpxlMwEJK/k7wD9U8CqNte8OYkSoLyPaO1bZ9GDzZoBub/fAdNzfWJ5IzVHp0xQtvMWwQ99B
 K7qpf2B1It3iMwX3SRcbRFRQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5a2aabe76301d61e;
	Wed, 14 Oct 2026 07:26:07 +0000
X-Mizu-Trace-ID: 5a2aabe76301d61e
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] ipc/shm: fix RSS accounting for hugetlb shared memory
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261014062705.1997201-1-tongweilin@linux.alibaba.com>
Date: Wed, 14 Oct 2026 15:25:49 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Dan Carpenter <error27@gmail.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0B5B2CA9-8FA9-4DEE-BF78-8E280F337362@linux.dev>
References: <20261014062705.1997201-1-tongweilin@linux.alibaba.com>
To: Weilin Tong <tongweilin@linux.alibaba.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BF3AD100004
X-Rspam-User: 
X-Stat-Signature: urerz3sjd63h48fax7iys6um1hrbnuf8
X-HE-Tag: 1791962770-626710
X-HE-Meta: U2FsdGVkX1+O5Lb7T4OUvCo2FAWTfTQFYlvye/UKqdMxFOPlDoXfQttgGaY+EQnx3Wpp1sostPh57TELoAHTssFMnnz6kas6gBejaD6QMEJoI009l86pOgitJlRLjN2R11NP0eb4qloeHBaN23PwAACNI5oGI+QSy8Q7wKjF0RLan2/X1joULY3l6xUqrdYdjOLiEyqMqvDxcRS6P42OoIKBKCH8VI8nVJd4pUfoo3qb4+88LrlwvgEyXAxUezoNHfOrfFj8BD4kWOXfXr2ANgKp4SA5gVnwxADz+xa8i4kfBxccQjGZjzKBytBNJ56Ndtffvk/KcSjquFPR+R992himQ7cbjksPU2/zVHSKXQa3Vum0IGkd7CEb+fcQANYVJ01FYVxx+FRAeMJT/gslwaty9ctSIKRwwwpgnUCkCBr61407dp7x0ZdB7rKCgLSDvUjFHKmMdhbPGcGo35GUNIkEQbLN75zuLgtHVw26WzdKUrrGaxlM7bYm/x5c+Otd3xm5InRB5ITMzxlWnX6qQ8wzMu3RCNArFV65tnp2TgYy5gsaRo49cI4jkwa5gRagCgtUhZwjvrIiplPXgugD53wxvk5buKrBe/DN8Q7qiqXdPQ1tfxszjO6AHDI9/nyG0r4ervdHDZZU2+HBCd2rLTLSzgXfzPXejzfROmN+UoGXFkEkYtWbU70Sc/0rZ1y0+Z1AUQuI4BfaybCqhiDmIJPTRC9sxvQnEBu+dsmaJMPXzeYw1NNEeqBrZbJF8iHh0PX6B8NCfWbPiizrVOBn3nqNJvkg1d33zh6ls5u6NsdQYi1PS4AAbEBfgG7maQU0ZBfYpC/Xjg3fEogCMTSzXsFJJd8mjOoY+YYb7YnqR2Ip4ke1Q1CxHRYvDRN/3OtRCWpgR2wljeeC+1fS3YuefyKBf+oL9VGzyfP/6hjaOBdWREbaa5PX4t0BnUkoIBsAi3nU+gfLO1nVytFbkXM
 tQF6EKfE
 KbRdB6M/Nx0tjjspnMmMbfLvIfBwyoef7LIju7WN23tQJ6/wAHG7S9qOaLSI36kSPwOjBODW5DmrQLOPLZwxfYU07I9FfBunW5J3FcqLZLlr+8UtfH6pW8mLGjGTh3iC+sgBavxD1ouMShTDIK+KY0tWa4XlNV5+lym7UoyLhu1HNAyka3p12+H1Vc1rqEFWAdAB9kKfJoFfxeTV5tlu4Md17IBulIw09y4zvuYSxHEOlXDwPrCWcHkbGCaAwpoW7cZnG16SpZJCWG0sMID0eZTGL3XiUID8O+lpt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 14, 2026, at 14:27, Weilin Tong <tongweilin@linux.alibaba.com> =
wrote:
>=20
> Commit a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in
> filemap.c") changed mapping->nrpages to count base pages for hugetlb
> folios. However, shm_add_rss_swap() still multiplies it by
> pages_per_huge_page(), overcounting RSS in both SHM_INFO and
> /proc/sysvipc/shm.
>=20
> Use mapping->nrpages directly and remove the unused hstate variable.
>=20
> Fixes: a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in =
filemap.c")
> Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
>=20
> ---
> ipc/shm.c | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 25190965c9a50..5ed2beef0f1d2 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -943,8 +943,7 @@ static void shm_add_rss_swap(struct shmid_kernel =
*shp,
>=20
> 	if (is_file_hugepages(shp->shm_file)) {
> 		struct address_space *mapping =3D inode->i_mapping;
> - 		struct hstate *h =3D hstate_file(shp->shm_file);
> - 		*rss_add +=3D pages_per_huge_page(h) * mapping->nrpages;
> + 		*rss_add +=3D mapping->nrpages;

Hi Weilin,

Thanks for fixing this. Using mapping->nrpages directly for hugetlb
folios is correct.

Could you please simplify shm_add_rss_swap() further as shown below?

The info->lock taken here only serializes the read of info->swapped. It
does not protect mapping->nrpages, which is updated under the page-cache
XArray lock. Therefore, taking info->lock cannot provide a consistent
snapshot of nrpages and swapped.

These statistics are inherently best-effort, so READ_ONCE() should be
sufficient for both fields. This is also consistent with
shmem_swap_usage(), which reads info->swapped using READ_ONCE() without
taking info->lock.

With that, the nrpages accounting can be shared by all backing types,
and only the swapped accounting needs to remain conditional on
CONFIG_SHMEM and non-hugetlb files.

Please also mention the lockless snapshot change in the commit message.

Thanks,
Muchun

diff --git a/ipc/shm.c b/ipc/shm.c
index bb1a721a3e74..6862f681373f 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -936,26 +936,11 @@ static inline unsigned long =
copy_shminfo_to_user(void __user
*buf, struct shminf
static void shm_add_rss_swap(struct shmid_kernel *shp,
     unsigned long *rss_add, unsigned long *swp_add)
{
-     struct inode *inode;
+     struct inode *inode =3D file_inode(shp->shm_file);

-     inode =3D file_inode(shp->shm_file);
-
-     if (is_file_hugepages(shp->shm_file)) {
-             struct address_space *mapping =3D inode->i_mapping;
-             struct hstate *h =3D hstate_file(shp->shm_file);
-             *rss_add +=3D pages_per_huge_page(h) * mapping->nrpages;
-     } else {
-#ifdef CONFIG_SHMEM
-             struct shmem_inode_info *info =3D SHMEM_I(inode);
-
-             spin_lock_irq(&info->lock);
-             *rss_add +=3D inode->i_mapping->nrpages;
-             *swp_add +=3D info->swapped;
-             spin_unlock_irq(&info->lock);
-#else
-             *rss_add +=3D inode->i_mapping->nrpages;
-#endif
-     }
+     *rss_add +=3D READ_ONCE(inode->i_mapping->nrpages);
+     if (IS_ENABLED(CONFIG_SHMEM) && !is_file_hugepages(shp->shm_file))
+             *swp_add +=3D READ_ONCE(SHMEM_I(inode)->swapped);
}

> 	} else {
> #ifdef CONFIG_SHMEM
> 		struct shmem_inode_info *info =3D SHMEM_I(inode);
> --=20
> 2.43.5
>=20


