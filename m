Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04753606A323
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b1SiGScN
Received: by kanga.kvack.org (Postfix)
	id 0B6446B05CF; Thu, 29 Oct 2026 06:46:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08EAE6B05D0; Thu, 29 Oct 2026 06:46:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBF786B05D1; Thu, 29 Oct 2026 06:46:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C578E6B05CF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:46:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 526C1A0388
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:46:04 +0000 (UTC)
X-FDA: 85375333848.02.03787FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 78F0840009
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:46:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b1SiGScN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793270762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F6aNkGCILQejjmcnm5RGfmCiEMne8lGLDKI8m/EHHN0=;
	b=DhF3UzyDocSdGw4AV/+PfzfZA6yoNTrHT2LYXRn4c68RXBfN2Mhp2Kq6qKLc5N+yMw3Twh
	496rmUVf/HVqKa1cCIjz1hHlBWM9PSsWY3eDkAXu20XASScvaqeG6wYZqw3x/C2tbdAr2W
	VVBZULAP18X3XknUK3Qc3rIbam9WX4E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b1SiGScN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793270762;
	b=yhzb8NsEY4+HkqXk9ijFzF7wZEb1oifhhOVowI5WU0JpeTNxupBW0Bo9qPlUN8qVwud6eb
	6WzynwOk1IDZyuEbo5po62MIrc0MwxaSVHQ8hoVel74dYGaLmvFLRmurdZkm9MW3w9MSnA
	NNU3Etbnkds9sZu8m41K1FpNJEr9K78=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CBD1242DE1;
	Thu, 29 Oct 2026 10:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C281F01825;
	Thu, 29 Oct 2026 10:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270761;
	bh=F6aNkGCILQejjmcnm5RGfmCiEMne8lGLDKI8m/EHHN0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=b1SiGScN5gaMrX3BUT8ZcgSrrzqOsKcKpJtUpEjCDbs07kThIXWnIiQLBOYl23ACS
	 JI562Zwyzpfs14JICCYTVvHrPqNN5A5FpTYtKi+Gm65Kshvq5mXNc02vehV+dblE8i
	 mDrOkRYjdY5hbCijQF+z5j+HmKz3CBMMezGKL3cAJ64RwXX/xQ46wiMnn0YWWqbuJ8
	 dsErVxADrysN/Ju+UVXwAUP/re9tL+sFscNXtSzro38rZO88XVOB3wSxqXnXNZeNE/
	 fdJeK1H6KwU7t7q5GKCB5xTnXc/UUndzY7sCzZLXFd6w45nKctrqtleR8Q8ToDzMI/
	 Zo1+GSjyuZTHw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 11:43:36 +0100
Subject: [PATCH v4 15/15] mm/shmem: fix truncation of files containing only
 swapin-error markers
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_shmem-v4-15-392fc715d8f6@kernel.org>
References: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
In-Reply-To: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Stevens <stevensd@chromium.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1609; i=david@kernel.org;
 h=from:subject:message-id; bh=3cyi7TgGjxMsxAuKMnS5D15fBsBka8mZ87JHY+VoW4U=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeK4ffb/+a184UcHL1M8H4rm3yl8JNVmWtO8myKN51w
 cuvxqnFHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEykzJLhf9hnqZq2Pz3P3c2U
 Ln3s/MQmvGOSd+KVIn7uvdw/v7d132Fk+HZzs9urmLyMzFgmx/37/Fc9jpyaNnUG5w9bVefVEbN
 MWQA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 78F0840009
X-Stat-Signature: 3mqrky4r3b5c3x6maetj954yodwhcn8e
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793270762-705718
X-HE-Meta: U2FsdGVkX1+QqbhDxs2wEEZGdMd3WVNTEpoYj8px8Qrdcen/wRNL2K9e5JvP/eygozgBXkdHUt9pxBfT+2OjgMOiHPq1Yks/n3Q9fuXONkk1l6teRdQZzTajXSBCa6AmuE2wElUGZwmIgvtHnulXZnO+wvVNJznWJ5GQOiKLc6VK3okPR94/X8/mVQgIcNRJnDyHQdDXWVh7/dFdR/2wJBVDBSSqlY7RUk+Naj43RzmoD880UZ75D4s+0m+jN2yIiqyabzOeStQKue0uWTRxNZUoCpXOHtX8n3Ibj3FYNCZGz1ZfmMQBz48/LbyfTzXE8FzXYiNhyqRnumdvo0AZg3fgITtGPpToOzRBv9cTALXgMQ43SM8c6JtYPcZIoX4/DbThDrQdmCm6cj1dWBr+Old/+A8ZnPFEimRwXTEICOHsRHSACyZ1NNVnCVi1i2qgEfsQZazH+OYkDXxjz1bmdVxxXSA6TFLlX0VD/pFg8ewHHm8XUbtZfKcztQ8vnsbQ63pv5Z7WkW0Vr0/hBMaiy4h0gbJBgoNuqgWiLWUA48kNSOLakC2+f08uJgkinjMqEWGAbrNUqkPBEHdp5Sjayd2/Oo3ffVDX+Cc2wcsGS1XWbMirqYCtgMKZom6gruzzEWhw12JVseDIzlyLwQLqNlCiTGihfW/lR71xMfKS2czbBF66ai4sQ/aPtcgTJAKUD3jwDKAQ6RaCMYxtkMJpjgf/KOaWNCyDe00gXtgKQt/dPOfczAZW9/QOPUYOCfUsULIgHd17bEqtCU+1gH/L5/2XC2X2dPfUvESCIdebThEH16PLmlgxWxhoICEMecQp9WwIYjKvW7UoS57QYJvRJDqPzHVZECpeHls9jydxD0yDDlGoQOlPFnDlC9QW3/jX345j5Nnhp4k0l3I/HrEJv2i5QtHIeDbqR9D5C/jyYZmhdlOuf32ycDEl9LHstYfj4m1N7bDWraHN+JSgX9i
 Yojgku77
 uXHgLtMbX5IdvMUL9aaU7xwbSRtBSqEewAiIpeui+LioDmiYJ+WnXNlmyF4CanxDOcyC4Qkz1nook9U/UWL4/LM8BAWnYq/drQ5vGOsZxD33VIgxtK+uErS0YSyNFc9AryEinKP2T30DiSBElt4q02qR4bsTya2N3nANk6KoGsRX8YVNPAW5lqluHdSBaUZLj0yTrP1aIbA6mlP89kIrqums3YmmqGvSmjREiLuJmzDGWBzLoY/xyv+IK2WXQmnyqWfVSvnPMGG8h8SaOKNDgmF3hef6Hmwcw9mBk8jd73UJA4igqDIZk1TdpAevUsbv07SIHZOnEhHXzQNoeviTjRlAaOf2yRxcxbnvR3DXmye6mycedFQlvkg6eGpsGDBCbi6m+Pm0Uzzq80iNpK8X2dl7Osg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

It might not be very common, but we can end up with shmem files that are
composed only of swapin-error/poison markers.

Such markers are not counted in info->alloced. Consequently,
shmem_setattr() can skip shmem_truncate_range(), leaving the markers
behind.

Truncating the file to zero and growing it again will result in reads
failing with -EIO instead of returning zeroes.

Check whether the mapping contains entries, in addition to
info->alloced, before skipping the truncation. Keep the info->alloced
check so that shmem_recalc_inode(), called at the end of
shmem_undo_range(), can fix up accounting after reclaim has emptied the
mapping.

Fixes: 6cec2b95dadf ("mm/shmem: fix infinite loop when swap in shmem error at swapoff time")
Cc: stable@vger.kernel.org
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 897f19ed0fe3..923957e5e6a2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1591,7 +1591,8 @@ static int shmem_setattr(const struct mnt_idmap *idmap,
 			if (oldsize > holebegin)
 				unmap_mapping_range(inode->i_mapping,
 							holebegin, 0, 1);
-			if (info->alloced)
+			/* Swapin-error markers are not counted in alloced. */
+			if (info->alloced || !mapping_empty(inode->i_mapping))
 				shmem_truncate_range(inode,
 							newsize, (loff_t)-1);
 			/* unmap again to remove racily COWed private pages */

-- 
2.43.0


