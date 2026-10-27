Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88A25606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fNmhhpR2
Received: by kanga.kvack.org (Postfix)
	id 8223A6B06F6; Tue, 27 Oct 2026 09:30:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FAAD6B06F8; Tue, 27 Oct 2026 09:30:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70F7A6B06F9; Tue, 27 Oct 2026 09:30:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B2256B06F6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:30:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CCBBA809D9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:30:42 +0000 (UTC)
X-FDA: 85368491124.24.4B7EFC5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0846A140002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:30:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fNmhhpR2;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793107841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pqjZ8RLKQmKAOWm9avC1hYXEKlDxEx8VP/meGl2gwmg=;
	b=vQ1fEvyTwK4EgW8vCjiafY4kDBbGgHtFOOrD1Ejwto/qYq30OXSyAcoYCtwsaGhyFz8tWa
	0GgVHvdjKIzdpXzLbXLfSEoRIKi41P3fzK2P3CpZp+u7waM3UEW+w1am+GgxHU+/901IDs
	aJPeaw26bXmGZaONyvQAVFcYEICBmiw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793107841;
	b=GsNH8MAL+WDRbNA8CMjyGIcK+cI6U1oWfCdHBcE9U+5bA/RjaBBU3MlA2JuS1LmRj9+pI4
	4CusSNeizF2+hxTPViowcwBPd9Mg93TqZvkwKERBfMCuy/wtbjnmvyIwi6twJKmMELXG8v
	ZlHD40QNwwi/HJ2AUBguYzevOoeM3rA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fNmhhpR2;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6518F60136;
	Tue, 27 Oct 2026 13:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5B11F01825;
	Tue, 27 Oct 2026 13:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793107840;
	bh=pqjZ8RLKQmKAOWm9avC1hYXEKlDxEx8VP/meGl2gwmg=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=fNmhhpR2uX/tEeM3pZ5Y547zPloMNNJzC4kxlbHDe4s5VwJV8hdhTQyn/UBvJ1GZP
	 t/uoLgzdmXYAokeFyhazPNYFnSeymkcHVlTBJFpL1zm1eNSCkin3DBaJaN77wiuTBG
	 qyv7ik8+JN9M7awERldxCsTjx67Ee9PX0DgQW1GdIHyOxrvrct2MAb9bdz1Dn0MZm+
	 jZQDLx5OwdevBDrqSNZ++OaxHnwL3+B5YzHoxwGNAQk0ixqnboeGKirGxecoplY17t
	 Aj/TbvL+k6aAnjoh5EmFmyWxazVn0t/EbkLc9KIzapg0ahTmcRICHor8Eh5/vRYOH9
	 wMNQ+VvUh0lrA==
Message-ID: <8386b412-c6eb-44fa-95a4-763dd90d2c61@kernel.org>
Date: Tue, 27 Oct 2026 14:30:28 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/14] mm/shmem: various (urgent?) fixes
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Gregory Price
 <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org,
 Pedro Falcato <pfalcato@suse.de>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>,
 Eva Kurchatova <eva.kurchatova@virtuozzo.com>
References: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
 <de90d124-03f6-4657-a467-71ab3d441212@linux.alibaba.com>
 <74d45c5a-1815-44f0-890d-c847f84c0a57@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <74d45c5a-1815-44f0-890d-c847f84c0a57@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0846A140002
X-Stat-Signature: iheizjc6fxe3mhw7fi84w8bdig9zmaup
X-Rspam-User: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793107840-56943
X-HE-Meta: U2FsdGVkX18PdFnRiM9nUmNQ8EIyzYrrZrtwtaPmdYhJcLAqNpm9UceIB6vR7dx9IRd2XmbI/gIqEJiiwaOfxzJqy3fIKJjBY7zsBkhNlSatmHWKO30q8zBtM2x0reuG0ssNBdtJK0mtyvmZ++jRzAtziyHYBE2Cp1By3L66ZwPLKTWL7t9/Nj4Ferz/wZw2ZAp2S939cpJEhIMH0Wj4t1BhJAsI95iZHCpj7qqDgQs9ql0T7ESX4DD93Rfq43Hr1c2nMIF8gLeySQhh4iLC+9sdTuQ/6Pzw2lekVNmb25wHZJM0Lpa2GbKsM+GoYQDAnvo0xrCUcNiFWMDGxKEn1R2R6DDYU1w4JYoMsj7QBq+RMTbzFqHwD3YRF9xmvA2NE06uPV0Lu7ZavfBNzMswPQUi/h2wcI2OBgfnGxA6XU4FJWMqeunWhMxbBEOhzNhIu13eJuOe9uBn6rEeFnnbyhYoVlLVdyLa/2NCvc4jLvQFwmH8LmbpOWYKBOhaf5kfdYcQze4BFYx56EtWq3MURgzmivpAocw8IZI4hOjjXCnlBE0b2oHbrKQE2tPe6U5xe00BUN+rur8pOGwHzGns+VC9JTpGmOYM4zvA85LgNhbfvSJq3eWpPXbvGPwf1heA6sKEve0H9sJywvma9Ennae725iJe1OV1dzWI+O8uZRIazjQLELIycIXWqkfvlhkDrLfTjAFHzpufqzK7VGesgBnYszN//KjeG3E98ss2V/JgDIupQ4Dl9X7fMJmuCR4TbHe/28jvkecNKF8n8jDzuBD128Fs8N/zx6fOWIAfWzyclmFo5oNCSVeSobzlJoq7LZbXNq1wy98NV9nO7eNq9xJbl1i1QgC333vZkieXXyyCurhIyac8Z4yFPqOnytNGB0qhoS5ZZC58XHxDVvGvwuujxV+k0ag5jc7tdJV//ml1A50kDzT3CYLlEHuWz6HdQRTBT7UYkD02I3kZyN5
 JzXLjQgY
 /vp/r1atSt8fwW/WAv46V4RC3XP02lNiPwd+qExQ4XgiT8Ydtq3j/ZwYejSIIa95PzvSIQ1SmWxkOG/fTsRJsfOOxquxvlocXbKxr4D2zQwwj97wJCR407IPkf5aehkqfIVLAXd1qnC2IpEWhuFrWsfEBfCTXbN5eHk9xzUrIw7ooK2t4HPKvLW9xmkDr5N2gQ9MPMsF7GxDn+fbXp7fTVZwjHk2qC0hGn4zcxxjq0sFXKxBGQLWrLU92+Ze0rEFH9bEsJbnzf7NkAl9S4htU26ZexPiRRD9/FX3TZgSCvh1ffxsqlDlPx7aBbMNrzgFPR6tVgGBh5uWXs6OqMNL9S4s7Yx1wvgTNAoPTspMclDP9lIJ+YYDXjBCppwUywWQFK6rHrpvrF9dlkA/5wnaC3oJycATj9Rh6XpZ5D/okEUwQtnAG9HBABLgOQpGmEpoUcUS2PHbiLmbTi713vOae2aWSwecgOpS0KNwNewwyUxhzw+wWlTz7bxgU7+XZcbaRVE5SYEV8vlPtWvZb2XuyVyKmYPNqtx7GNNc8sypBXdk1E/gUosLNYKb13AxMN6jX27B0blEP5/yzp59Gsn7fhq6Hvvqb8PSV3SjbEdPhRdwzLYg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 14:27, David Hildenbrand (Arm) wrote:
> On 10/27/26 14:20, Baolin Wang wrote:
>>
>>
>> On 10/27/26 9:03 PM, David Hildenbrand (Arm) wrote:
>>> Hi,
>>>
>>> see v1 for details. TL;DR various fixes.
>>>
>>> I now rebased on top of mm-stable (thanks Zi!) and retested with
>>> Gregory's tests (thanks!). Thanks everyone for the fast review!
>>>
>>> When sending this upstream there will be one conflict with the following
>>> upstream commit:
>>>
>>>     737362c7012a ("fs: port ->set_acl() to pass const mnt_idmap")
>>>
>>> Which should get resolved through something like
>>>
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@
>>> -static int shmem_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
>>> +static int shmem_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>>>           struct posix_acl *acl, int type)
>>>
>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>> ---
>>> Changes in v2:
>>> - Rebased on mm-stable
>>>   - Fixup shmem_set_acl() compilation issue after rebase
>>>   - Dropped: "mm/shmem: avoid moving the truncation start backwards"
>>>   - Fixed up: "mm/shmem: stop retrying folios that cannot be split"
>>> - In "hugetlbfs: enforce F_SEAL_EXEC in setattr", check for S_ISREG
>>> - Smaller patch description fixups
>>> - Picked up tags
>>> - Link to v1: https://patch.msgid.link/20261026-fixes_shmem-
>>> v1-0-703206d5fa0c@kernel.org
>>
>> why drop this fix "mm/shmem: hold off eviction in shmem_writeout()" from v2?
>>
>> https://lore.kernel.org/all/20261026-fixes_shmem-v1-6-703206d5fa0c@kernel.org/#t
> 
> Because I'm stupid and dropped two commit instead of one :(
> 

I'll wait a bit and then send v3 fairly aggressively, including again:


From d342e8d7d01bb656d7e224e38acd7309d7678e53 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 9 Oct 2026 00:36:37 +0000
Subject: [PATCH] mm/shmem: hold off eviction in shmem_writeout()

Once shmem_writeout() has moved the folio from the page cache to the
swap cache, the folio lock no longer keeps the inode alive: truncation
and eviction find a swap entry, free it and do not wait for anybody.
That did not matter as long as swap_writeout() was the last thing the
function did.  But since it puts the folio back when swap_writeout()
returns AOP_WRITEPAGE_ACTIVATE, it uses the mapping and the inode
afterwards:

  reclaim                               last close of an unlinked file
  shmem_writeout()
    shmem_delete_from_page_cache()
    swap_writeout()
      zswap_store() fails               shmem_evict_inode()
      writeback is disabled               shmem_truncate_range()
      return AOP_WRITEPAGE_ACTIVATE         shmem_free_swap()
                                        destroy_inode()
                                        ... RCU grace period, freed
    shmem_add_to_page_cache(mapping)
      xas_lock_irq()            <- use after free

swap_writeout() behaves that way if zswap is enabled, cannot take the
folio and the memcg or one of its ancestors has memory.zswap.writeback
set to 0.

shmem_unuse() already added infrastructure to deal with that.
Reuse info->stop_eviction to protect the inode during writeout. Increment
it before removing the folio from the page cache, and decrement it after
swap_writeout() and any attempted reinsertion and inode accounting.
In shmem_evict_inode(), wait for the counter to reach zero even if
swapoff has already removed the inode from the swap list. Add some helpers
to make the code easier to digest.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 6344a6d9ce13 ("mm/shmem: writeout free swap if swap_writeout() reactivates")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
[ david: code cleanups; improve description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index ad644a268c0d2..9db820f04d378 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1616,6 +1616,17 @@ static int shmem_setattr(struct mnt_idmap *idmap,
 	return error;
 }
 
+static void shmem_disallow_eviction(struct shmem_inode_info *info)
+{
+	atomic_inc(&info->stop_eviction);
+}
+
+static void shmem_allow_eviction(struct shmem_inode_info *info)
+{
+	if (atomic_dec_and_test(&info->stop_eviction))
+		wake_up_var(&info->stop_eviction);
+}
+
 static void shmem_evict_inode(struct inode *inode)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
@@ -1628,16 +1639,21 @@ static void shmem_evict_inode(struct inode *inode)
 		mapping_set_exiting(inode->i_mapping);
 		shmem_truncate_range(inode, 0, (loff_t)-1);
 		shmem_unused_huge_del(inode);
-		while (!list_empty(&info->swaplist)) {
-			/* Wait while shmem_unuse() is scanning this inode... */
+		/*
+		 * Writeout may still use the inode after swapoff has removed it
+		 * from the swaplist, so always wait at least once.
+		 */
+		do {
 			wait_var_event(&info->stop_eviction,
 				       !atomic_read(&info->stop_eviction));
+			if (list_empty(&info->swaplist))
+				break;
 			spin_lock(&shmem_swaplist_lock);
 			/* ...but beware of the race if we peeked too early */
 			if (!atomic_read(&info->stop_eviction))
 				list_del_init(&info->swaplist);
 			spin_unlock(&shmem_swaplist_lock);
-		}
+		} while (!list_empty(&info->swaplist));
 	}
 
 	simple_xattrs_free(&sbinfo->xa_cache, &info->xattrs, sbinfo->max_inodes ? &freed : NULL);
@@ -1776,15 +1792,14 @@ int shmem_unuse(unsigned int type)
 		 * remove placeholder inode from swaplist, nor let it be freed
 		 * (igrab() would protect from unlink, but not from unmount).
 		 */
-		atomic_inc(&info->stop_eviction);
+		shmem_disallow_eviction(info);
 		spin_unlock(&shmem_swaplist_lock);
 
 		error = shmem_unuse_inode(&info->vfs_inode, type);
 		cond_resched();
 
 		spin_lock(&shmem_swaplist_lock);
-		if (atomic_dec_and_test(&info->stop_eviction))
-			wake_up_var(&info->stop_eviction);
+		shmem_allow_eviction(info);
 		if (error)
 			break;
 		if (list_empty(&info->swaplist))
@@ -1915,6 +1930,13 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 			spin_unlock(&shmem_swaplist_lock);
 		}
 
+		/*
+		 * Once the folio has left the page cache, its lock no longer
+		 * keeps the inode from being evicted and freed: hold eviction
+		 * off, in case the folio has to be put back below.
+		 */
+		shmem_disallow_eviction(info);
+
 		folio_dup_swap(folio, NULL);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
@@ -1922,6 +1944,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		error = swap_writeout(ctx, folio);
 		if (error != AOP_WRITEPAGE_ACTIVATE) {
 			/* folio has been unlocked */
+			shmem_allow_eviction(info);
 			return error;
 		}
 
@@ -1938,6 +1961,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 			shmem_recalc_inode(inode, 0, -nr_pages);
 			folio_put_swap(folio, NULL);
 		}
+		shmem_allow_eviction(info);
 
 		/*
 		 * The swap_cache_del_folio() below could be left for
-- 
2.43.0


-- 
Cheers,

David

