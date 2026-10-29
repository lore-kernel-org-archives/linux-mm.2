Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD6F5606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KY2WSYrS
Received: by kanga.kvack.org (Postfix)
	id E71386B05CB; Thu, 29 Oct 2026 06:45:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E48B16B05CD; Thu, 29 Oct 2026 06:45:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3E446B05CB; Thu, 29 Oct 2026 06:45:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B49BE6B05CB
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:45:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60F79A0308
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:45:38 +0000 (UTC)
X-FDA: 85375332756.02.69E86D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9668A100008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:45:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KY2WSYrS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793270736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0fxJ1yIZnUumW1Gvcfcp9HFQq0zCF7wYA9AuvuvXBWc=;
	b=H8c49EdnZl64Cl2ftca9sSBLZ97o56Z4DT7jnJyUZZU/SnccF3ZcyIAxLS3iB3F49N9aru
	ItDPE/S22Ul1jFBb5tKOTVr/gw7jaCoDa/PH8k/24ABH/dqR0Kk458nMOihFPMq2YDf8GI
	3PZM8baZImXkdcqSABQfj5snyP/Jx3M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KY2WSYrS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793270736;
	b=1PnWijO6+eicef/zlLCX+C/7S6XTt25IOvmwnJtb6TK8GLbSMfM/BTkmn/k4wo5jhw28tM
	pEFkJFhKMwaQIq0GNPyx90u/wiHWQZoKdvNrNT5HBofn2TgXRyYaYEdHjVP1AbAD0kkX8m
	GZVr0WuD4tufzq5oBMbEXYACePj8zeg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E65C743B17;
	Thu, 29 Oct 2026 10:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AA81F01825;
	Thu, 29 Oct 2026 10:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270735;
	bh=0fxJ1yIZnUumW1Gvcfcp9HFQq0zCF7wYA9AuvuvXBWc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KY2WSYrSAZkUAfPZMrMsx5s36BqbaDUK+7BvSQwkci2fEIxnAa3xelYkAzkMmSG7L
	 IgEqM119VkmsnG8dfE12u+oOdMyG7g8SIu8HsM6Hxo9bv5mrTJLIWMq/Zx9CueNUKf
	 II7OgBOUS6/L04rBwXsRrj8+LCurvC+JTW+liZhssZgviwuN0wJ6eirbWolHEj1kar
	 Mtj6uehUVnoaOWjn1JMt9QaFn3HZ8PTZSwNtnDAp3kvhL1PWr3dhYoVW+eGYzObhCl
	 BzxPgb+IFzmlMOlKAqNg8aSHH4Gybk4cLRBC3BJKA2svjqIWREfWK+xjrtklMx3Pi8
	 HBIVilPTrkFJA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 11:43:33 +0100
Subject: [PATCH v4 12/15] mm/shmem: preserve allocation errors when
 swapping in large entries
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_shmem-v4-12-392fc715d8f6@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1547; i=david@kernel.org;
 h=from:subject:message-id; bh=/qXGMJ2+Vc8UHm0Vypsyjzej9eUaZtHiT5EAktCFeu4=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeK4db7fTebfvxomo7W7/gYnm9LZLnmNs3Ntz5bHJXY
 m3MpM3aHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEykcjcjw9KU61svWB5VWCvo
 Y5IXNleV9fGtJw1xVX1q+tf3xygeCGP4X7f6NK/LVyWjV8uLGBa9bOFwbrrTk3yP8+Pms4KyokK
 8rAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9668A100008
X-Stat-Signature: t8fppwn9csrtmuhutb9xgd8trtxjnj8t
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793270736-456907
X-HE-Meta: U2FsdGVkX18jsb8GcQn5GNcdoLdji94FnxGHtV9fbUMr83OERR/UjLPvaskP+cHST5/7vIDRoHcQwEAfWiik1zuVNUWe/4D19Z2Gz31FN+uB2RKwGQKm+G18NrdVBWqKGW7WDfWOivvTpyVFamTew624NqbyJ5Zadtq6G5B/XS42UpDVA4pNkjAMsCAV4jDnc2NggI8BSUzYnXbA/4qZXGBJZV6+HI2beZ4p8Ayv4szDEa+HSM+KVzuXEsMuspwXYrfZ+nWB4wG07XpKO1/XfQKkJ1+2XzYDHPEy/eKvsmyyaupeJ+x42xNEV4SZxzgphZgLz+DTesNfHy+PkH9ctfhAwgNbH7GM3WDsw4enjZUzWOwukwVggF+Wc6P8Hulrq5mWGdg8dVMFqfggav4RzYLjODOMOrjqFQcqevx1q6kMrI8wzgDps6JN5etTAsgCxXp/y23rw8m+FudJSn/bfvnvp77Yra2UrzEqdajhQWREWMihmf0Ip4N86OYB1UOJJf7WxGL9L21g9fvblQ2jDzcnSrutkCtZVBLU3QWqjrWJ3aPy7PLSr7Q1GytXjK/OZLjD/XKvIrT20svnoUgNZhOoNA9UfdUeqxfpJfBFsuOOmvxNpZV/ot5lSjhrGWbjyVbuqgRwh3OP907ugT8rmSCDcCJw/WwiTTwecxps8CjM+yrdRFqBWwlYMGFSTzG0Q/wIzegzEIVhbW2ypxBiGgvT24adblTXnK7/qdLxCFjXcP5CmYas6dDoUeZyC1BmyShL1+MdSQLihh5lXsJDvZTn1GzpAYBuDh1qaUyGZDHP4CqYhHg35dzC5bio829iCzhj+/e92xQUFIP+DRrK9obbSgG+W9PC28gRabgFxVxLrEARONOe0OFin0KtAJjTOO7maVyJ2XirHBynpn2sbu9DWROGJ3kZK5w5eebCkpaKU7VTM2adYXV324wdyEybCNCnGO6FcaI5jeCvHCP
 c0Lff/z9
 g3keWFxoT9cVIwhzujVMT0DLTS6RHSHBF8XqUaIZrG7omaD+A59ATk3wN0dBx0fImGzbw1H+nCbCH4CFgCGiahd7SQueUQye9bG8qdUHQZwwVibnUQSYSV+AxAPvhS96mY3mQZjwB0Smnc6QwuXzKh9C4yxH4mwdY2YRxkI5F2S0/LDs+0j0UoG9WBiNLXJ7lUCIh0t+yv6M0OpC2eMns7kqCfp8l4HxCt14zGpk7yHghvKLxLR+4N/Dvp3kKkQp9iCYCX6xDAQGWlY4jw8k9pnCo1LlS9gVOE4hJjz1qUV2zn/Box39t6FTTW1cVcELTdWHn20Bob5YVy7wxNC+qR6OUPGvSjx2cbNGguEMM4xS0wjT4X0ZjmSNy+j2WNqqmClPSAJxJZqesugDG6Dyp//f9xRyLehU4ytO2rnnw6Pz7lsLUxn5EmBNUQDtCRrLi9p9n4LPSDz7X/Ho=
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
index e1b7cf4b5280..02de6326ef3b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2552,6 +2552,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
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


