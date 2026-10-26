Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C9B2606A32E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WYvkGUDH
Received: by kanga.kvack.org (Postfix)
	id B33A66B05CF; Mon, 26 Oct 2026 05:42:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0B6C6B05D0; Mon, 26 Oct 2026 05:42:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48206B05D1; Mon, 26 Oct 2026 05:42:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 838CD6B05CF
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:42:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 148E3140670
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:42:25 +0000 (UTC)
X-FDA: 85364287050.15.1AE4E37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5B6FC120009
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:42:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WYvkGUDH;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ljcdxIOHbwoigWNhoclMmblcXW+PBjkhYv0wmQViFuQ=;
	b=jjY9ijXIxwGCBcE5KjyX3WJmF6Q6hY4vdq7RwXBcLvaa8hoSxE4A5MF0ZCoy1IjiFUbV0s
	hNlOnDZOvYq4Gg+Pl4XxOKA/EN4eF/61pWY6KDmsHbL4ZmaYrT3A0rgH0WzBOLZmtCowV8
	zBLmoEwepsqsFT6aS7KNwBE4BxTnxDo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007743;
	b=xY/hP4n/td3MOjP0qNKtEECnzwpGbFDJ8OJgvszB/XzVO5T7CK23p7+voLl5xlKKKWPfmt
	L7JAPamKIsFF1u0dZ6bmrA00ZcwAEP7AV98/itQqu53j0LOTL2C1dl3JTle45zhJLUvaRY
	5fetI5gf2pAD+DIeR/kCjzGNt6YkSUo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WYvkGUDH;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E5DA86022B;
	Mon, 26 Oct 2026 09:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1996F1F01483;
	Mon, 26 Oct 2026 09:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007742;
	bh=ljcdxIOHbwoigWNhoclMmblcXW+PBjkhYv0wmQViFuQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WYvkGUDHITIuwWPwR12HqoyRhUFAy6h7D2GZjbG4VE4gXr7sy72QJNIXs3F5KCaJs
	 q2z+lPQsIi4UaPIagF4/XF0LjXOJDP0WaaxBFC51q9RE7hTdh/VWWb/bCNmf7SNRAr
	 MV+QzMrXcC192m53tetY8803fvgRO4Ms1yEnhvcP+NUfZritkav0ZoUaONMnvpIjD+
	 4cEp+Z+pjH8g/mNzMfpEjr3XUKDDEdFqrPVeFjN8OnxGWN4OJHEiSie5ZGvcsUD7rz
	 gzD+yr8ZRRy5jt3yV8erG5EtN6ZUyNdVCeTtdjFoKPyvPZHcjgQuEsed1G2OaA9wSh
	 elkNNXikanF4A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 26 Oct 2026 10:40:46 +0100
Subject: [PATCH 13/16] mm/shmem: preserve allocation errors when swapping
 in large entries
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261026-fixes_shmem-v1-13-703206d5fa0c@kernel.org>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
In-Reply-To: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1410; i=david@kernel.org;
 h=from:subject:message-id; bh=q20WAtGi9Zz6yJcJWGoO/cw3wVyustG3Ar7+W+cD7Fo=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLuK4hrTFdaV7N3X2KUVn6/wdbgmU99JyyYYxB9rOp9v
 +I6uStSHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExk6xqG/6E77XmfXzb/UGi6
 6Bq/3fJ88yZZsTXb9nJzPU2ZMu9dUBzD/6TXwrvVb0qkeXAn+K0QseUU3r7WN+7zzbL9N1Uf6E4
 zZAcA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5B6FC120009
X-Stat-Signature: 5teqggnsz6dkq4cgaopdu9q9bo8q6dq9
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793007743-544904
X-HE-Meta: U2FsdGVkX18cyvdToMKla1dpWD2Q3hyIEk64W9cyhfEYke1HZPeFB19MByLJguTtTiGt7QyQvyzh6XsK0WJjjQXMvZq2EbR98V15d800Of4pukIGOIIcBQ/CZSX/AGn5G7K0c8SRZTtvYLEjMzVW6aw1FRehAJcYPZucAMhO+BeSYH60nwqMItxJ+06MZ0N97myCNF78PLd3qexrx59UTK6mBIwukCDC48eXyClJrrfEsNBgAD6mPMUKDjLncPPJAmYVD4qvggn3tq+uQ5jLW6AnJFnbwnHKtGd7fcH4wgIlJ40m0GHjauM7ymUGhZ05htm+9HMEZyvwzB4m0JJgIZ080LGXFSLDU9f1ej54NocJcjPSyVgQKEKFIifUijwddaBhpakNWpJ8GvraNpkdUh6XXyDvaOR7PYEl+5NGFDdq4Mbu4Y4+LxIlo2zfye8VMkWAOWajbR04Fn1so4joiApsUkWNwBcW1IE/VPTeTdSzjbdgmVn4bAdFtJtXgdLNuf5EWi43uW5f5vAcaH1Z7l0KhkSAFJhyiUbtwAUKS+gzLXIwOuOSnFlBCsmrI2FPaOrsIp40L3p24GukWBxbqEnZDRq7gzJZXH91psw+gr1q6b+Ru/CKzScZa7v1glQY3KyIp0DXpEcfN6wM+7sYc74lsrHl+lxoqxtt5jv4Nob0ygnhJsu4+X4BxGNxuljamao/6fas7MVrIAX2l4tamQN2a5eNdu5FvmegSIcTuVuOA4KnwnOrPyXGrJT+1zRn7ULizSVr+1X7qG09NgQymkW1MHKuuycDTo0WVEUwvcpXzIUyRe/XF3s6VSSiQfG53QZGpoq/PYV2lfPWghG7iLwEwaxxgdk3c4YShichGW0YW4Of36KJdsTSWhNPIO3d47lD+PbhI/e8Ws78nS9S4JzP/I0Y2W1RTdxg+3ZxhHGTSe66L8SHjJEbQtQNWV1PFBCvv0uo6ZIQ7H/tfzx
 nTMr07VS
 tPlqW1Z6TxEEvgOJ6IGDt+B8Q4iWFRxkjq1CjbsYEr0n1nuBoH9hIx5LW3kdrCHd+WXMmqrjuEFuXvPZ+WogtMmbIqRgXnzxgB39EgLtvgKzcB/7q7i9eFfCz9QLYapICGs1H9YbriAQz5SGozsQFcTBo74WLTNrgq78t7UQZ80GTgJ05d25zjhl8hczY7w0hIRIfs9RxRfH1r51L98cjnW/Ql7mhq4Wn5iq5dSdDInUJrfZD4uRET5eUoH4xhHgw/LgnAYuF+TESRxbVZOmdwRtFMFJURa+lOazFVqi0/9CCOBI3MbtaE/hvhu70fFbfSIvv
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

Original fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 91ab656ece13 ("mm/shmem, swap: tidy up swap entry splitting")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 9e0034a424908..d1716a8da9075 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2563,6 +2563,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
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


