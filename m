Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70EF4606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lg7AV3Jy
Received: by kanga.kvack.org (Postfix)
	id 5801A6B072B; Tue, 27 Oct 2026 09:04:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 557636B072D; Tue, 27 Oct 2026 09:04:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46D686B072E; Tue, 27 Oct 2026 09:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A6BE6B072B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:04:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB77CA0A45
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:04:53 +0000 (UTC)
X-FDA: 85368426066.22.B187540
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id EF6E7180003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:04:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lg7AV3Jy;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793106291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C9CW95GOpUZS+JdbNzdoy8x8Ek3CYVhYSlyIeljBRJw=;
	b=oJnT26KrK+lOaBBCyLbD4W6mvieR1BJFG+RX9037iSoW5gRIBZBBiPdx3U/CSky/AE9sy7
	9U4G9f+OYjNLah/vlWoxgMeVQghg7qb6ESeEVE2bwI0O8RzPpjMreb0AYlgx/dVIPQ2MuE
	O53j7Yst0N7FTg66zQxzw0+yfeVII+0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793106291;
	b=i1V0DN5dgNYhraqYm8RQ07th2fflYSPO1Q/cIGzrnDBrDeKMkfDQOqKRba6Q1FYAa4r67g
	sKzlu3++O/vjl1yxT93wQq69JQvdIi33WaoiBg7zgjyn1Pi9vLyjVxGYA8b0ZUQ3A74Y0q
	MIVw4gJpN1rfze3euIaRjN/e+bgixEY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lg7AV3Jy;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B15A6022B;
	Tue, 27 Oct 2026 13:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446AA1F01829;
	Tue, 27 Oct 2026 13:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793106291;
	bh=C9CW95GOpUZS+JdbNzdoy8x8Ek3CYVhYSlyIeljBRJw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Lg7AV3JyrpqCFTdtN8/Irbsn7pw4xNIm8fnXR3opnpD7q8JY2TuW2TwvubuRQce28
	 NCYj2M1SN5DdsCXQy1aSscJ9FgDFhTpDT3Gi29M3VRD5uPNxumZCcd9T3sRCDGE4Xi
	 30TVlxdQjL/cnGRjNPLdzXB4yY7lPCuRkXmrHNzB5nTLcI1OWS4cfCqfB/DsVhJGoS
	 9lJSxiFMmVCkVZFi22QfjZZFOyVHMjQmob0uy3IrkN41vMx9gNUAeZCXRVIafu+gXX
	 bRnp1ebGBgEYaRN1Dz+r/BtbOFf85lTXepz+jkS4EPHLzBK7i2t7eOh8LhUMTMdInY
	 kkuD0yPuzSuAw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 14:03:16 +0100
Subject: [PATCH v2 11/14] mm/shmem: preserve allocation errors when
 swapping in large entries
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_shmem-v2-11-86a00952acb9@kernel.org>
References: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
In-Reply-To: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1549; i=david@kernel.org;
 h=from:subject:message-id; bh=VFsqS5vseIV2DxJFz3mK6fhGor3WImrNW4kFky6FZTk=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeLBScy2N1p9Nrfctd3iZLSV9jz3efdHc6/7l4KftAS
 tdbDob7HaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEykS4/hf96XOGkGlqBl4T9s
 VjXd8cn1O8xx3uSEmMhNlqOnWtXa6xgZVh+bMJtlzoKNv9Y9EmX4H35Kc7ag3QL7zUXLDtlKP+y
 I4gEA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EF6E7180003
X-Stat-Signature: kq4mfnszwmdo1id5axhrktqtm5866cz6
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793106291-880578
X-HE-Meta: U2FsdGVkX1+me3xL3txiQcsXd0omAXTVjnow/8sC0JrHApOayua7y7oKRaBH8wS/DJp/iFX/8OxNDf2sUCn5ac9OvDvHd6re/T8E3gntBEraWSlTlTmknVhFdzP+H9ol2T8ZtkvBxK+o1ngzYIRQAoezW3gWw0Y3y2qPBZF8DWdftRcJrMLgY7t/bpdWK2B15/WK35NuVNL9L9vUryBiTOc5C3mAbVr+3gx5eeOA26SG/pP/35Eq8vgZsebxvIudW4DEaZegF8nZfPM2q31A0P+sDct5KnUaFyifrX/Y05p+J1scnocJV3sOyQWzU0vLoSnzPRZD8l6YJK97LvczDbdyOSEGvTgD6ClglGj7jTWH9XluvKlckbfiA6nfZ/OcW/jp265vhSxewsuqlIoa9Gvmlp8bdTrAQnXojnboDxYZBwmJNd9STM8FGW2CFFjCG9CO9B2qJ22x3t3iW/1ox4MUwpNKdYt6vtOH6Xv4Yld2XKtVlaWqNDy+e4QSLbDFLxzHmFpA61Lx7TYSZva640Hv0jugZw1mdEOH3zkWKMYxGih33+bUszmSwH3odeshh8Mj8q/zyvQHP9AtHTZYbubCkKupABSj4j5mGR4y5Q87T1zKxaFmCjz/ZRO8PHdOZrVESIb6cHdOK/oiGgOKkIK3Mi0JcroMbvi/+FwG8eje9TAIiTVF5+ln3SByTA9kY54zrbcOHEZ1R5qDeE5bC5IMvZHQ1hSJsEPQT3G6IlTtKmok2EmzR8hbkvRW27ZOlLlpwFNaxeqKg47mW2fHqxyOoNurUonJnFrVli2TyIYpmijHcUHWit+cXrntG0ql5apGKw26OOmPOHRasQsS6C2Tj0i2DiEgQKA9LJ8pzms5AgG0t13f5SWBd8Hq419D4IYQP51BeT4c9xF+F96r9J5edbZee8dR4PUDbuh2qvekM90EJUh766qoglu13GJRnod63GKJJefGidMOTXE
 WjJ9/NTs
 9xoW+NLKjjInBasR3Mp54RdNN0YYnZP4Cby0DzJJ1o/xegGpjSiG2Wexz828UTa7DpMxAtNRUt6FnvA62m9v9TnuvX414KxZqguuRgXSgMiA3v8FxDaJZVH3LybvZFCC5uTHudciAcUQo3xz5+5j7O3lvTjlWCjLoX+oLt3+e0Mi0D36g/KRYBCeCc1vCOKJRBnjN7dWvD7WYymlwm7OEkKBa2iTXK3CxRUKcc9xWR1ij3CKcB86nDA3NkxH8k408uUbM6WmW0lWgyKkHJKYRGCCKsog80OyqSOJS2l8JOTky0mlKlriVRvmeeZgd3803PcwzDrjrAI6MgdMY/q+LCZkpLihfQGIs5UjW2Ze3ACDpqpZxdZF2dV53Wv6QBee8IOBsOvL1Xfx4WHHT+lwdWxOKJRhOwCQ2nLknI114UtrMnntpOJW5ZqOMJUxWBAb84HPIZUIj4amZiFY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

shmem_swapin_folio() adjusts swap to the requested slot within a large
swap entry before allocating a folio. If allocation or charging fails,
the error path compares this adjusted value with the original entry
still stored in the XArray in shmem_confirm_swap().

Unless the index is at the start of the entry, this turns -ENOMEM into
-EEXIST even though nothing changed.

The caller retries -EEXIST, so persistent allocation failures can leave
the task spinning instead of returning the error.

Restore swap to index_entry on allocation failure so the existing error
path checks the original entry. This preserves the allocation error if
the entry is unchanged and still retries if it changed concurrently.

Fixes: 91ab656ece13 ("mm/shmem, swap: tidy up swap entry splitting")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index a538b37fe739b..9a11de010ed7b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2528,6 +2528,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			else
 				error = -ENOMEM;
 			folio = NULL;
+			/* Make sure to validate the original value. */
+			swap = index_entry;
 			goto failed;
 		}
 		if (fault_type) {

-- 
2.43.0


