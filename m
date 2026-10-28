Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82858606A327
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GS3doGme
Received: by kanga.kvack.org (Postfix)
	id 974A36B00EF; Wed, 28 Oct 2026 16:56:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 925EE6B05B1; Wed, 28 Oct 2026 16:56:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EDFC6B05B2; Wed, 28 Oct 2026 16:56:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 508FB6B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:56:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CBBD5801E3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:56:55 +0000 (UTC)
X-FDA: 85373244390.06.6878BA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 00429A0003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:56:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GS3doGme;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793221014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZu1Cfp3L16PzP3G/orLKum8qOHFItvUlrkqAzL+8QE=;
	b=extFmMBWBC9cSq1LqWHF/plbmO6/dqMwJXpcyZG+eg1TzawYx3GSxipfBY76oyk5iW+Tt0
	yVj/MF/w2bvZniV1OErB3IO1JhSpX9uQF22L3OYPWdhPbPbV9KnsHdjSCKtXVgKap2FdPc
	xPXKRbMzaGdDNw5cgPmrf5+/qwkS8cE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GS3doGme;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793221014;
	b=t3RKJglUdesqkmloWS9mdZ3GrcOvAxqDPbePq8BMwVGOVvegfOxSl478+OxX+o+5eMUIVE
	ntT/lLSPapvqDmZarpBnI1JQAT27fXqk/EfJKQSiq+UAiI//CILVtISixxJ0LEs5ffGn6f
	3zUJPuwpsl8nOea9/rj+RztN64dvldc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CDD364121A;
	Wed, 28 Oct 2026 20:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C95E1F01829;
	Wed, 28 Oct 2026 20:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793221012;
	bh=LZu1Cfp3L16PzP3G/orLKum8qOHFItvUlrkqAzL+8QE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GS3doGmePKLTxMBl+unC3ykHsq1mGw7+gmmDZJSzc9q/PgJo+2fP+qmWwk/1x7fMb
	 1qi1BQnKHOgrUjCM85YSdApcrxNttwjdcG4dUCaE8JndWcNZUa+rdc0DAoEtZlSzKA
	 LuTzM4AhAsy4W0hF0A0GYZyfgn+pRadVV+LKaPmfvCMs57lNI9stAAraG1ehlvPU3e
	 8wuYdtq5E2meTCrjtCXLe1awZ5E06zqPQBobBkb0BpqpjBfiNiCA0iSVZRXJLyJwsi
	 hH1pmZ3EI4ox0FfUZ8QyK4VM+BLXMc0G38JpNWqM3Lr5UZ9McDSU0R2sGR5qGWMb1F
	 EIrUurhnkeP0Q==
Message-ID: <bff8fa50-6b73-4bb1-b944-2d90dd4e41d3@kernel.org>
Date: Wed, 28 Oct 2026 21:51:28 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/15] mm/shmem: hold off eviction in shmem_writeout()
To: sashiko-reviews@lists.linux.dev, Andrew Morton
 <akpm@linux-foundation.org>, Gregory Price <gourry@gourry.net>,
 Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>,
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
Cc: linux-mm@kvack.org, Josef Bacik <josef@toxicpanda.com>,
 Pedro Falcato <pfalcato@suse.de>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
 <20261028-fixes_shmem-v3-6-4ce3baf2db4b@kernel.org>
 <sashiko-outbox-188427@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <sashiko-outbox-188427@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 00429A0003
X-Stat-Signature: gsc4iqcyy54863qdmmr4cmip5xnzor7f
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793221013-412994
X-HE-Meta: U2FsdGVkX1/bspHvAnGEM4qWLSq+zJFBunIthg1D5VtxHqGyGerFyXKeTnboj9o4CIOyNwQTAHzorfZtZTfVMqh0+zw9ghTrN9EKyzDcCNBmPLSbkpdcePzMGQ7buIIUoG5hIJVg/HGUdspkW3PtRRuL7uefPQ2gZEsCXHEn1AEdTWFDEL+btzZ+mieWnoRUN4OlSwUCpLSSrsI5OIHHPlfq8EycNo7AziDbVLRK9LclUriSJDhicMY5AZmnGUUYtmjQIF4BR1nJ3VqhsOuvnMwQOJM0upxmr6dp5iintsdwoJ2lnvHAk7MFTrwm+w9u1p2OeJL9DwfK4dwehd2+3gxF5xo80zJSoD1ijHrczE7ElK862W1EOS1Yn/BQYf9M0Fpsu30dq7H//VnBaqEm3au91ZCoLcyWXclZKx2K4AU7embc6DQ3Oyawpy7RqD3jhQZhF0TZv3V13mP0GVDtYjU9XlTa904exypX1Nxja4ft93bEAnKZXQLSlOhIVolm73ltrVlBjCOoarbtHCk29DVShsX3dLuEzibyzjKFJZpGQVO+LLmQ8iVoD4OY96WfEjJr22mlmgV8gs7Q5qTPq+vtC7SjJgfHdRS0jN+H523uR1RdqOzvVGX2iG2Qpb/dYJ70LYglHbp50AJxF+yq4M/NPCc0fXIn1DB+j02VGnjeUGFm98EY8pyiM8aSV3MvUYmvn8ArW7WtJRvplf55DwJKGVqbu1o/QoB9waCuoWT5cWNNGkoHMIIHxILDwCCh7kvML5DTfF3gWTnj8ROcnYlqpFwPnI/sXLRtUYgnWb3AtkZXqaAwC+O9KHo+IcJ1jfiB61z7J3JJ7ee12DmcskT3ofgAMr2I7FSGs/RuKGOC3xikWdMKpw7xKYJIm72iZly6fgwb8s89qW40n9MZUF46LofWZF7CuLiHLCLQzLbiTkXjXSodwCnlBhJIwOMUhGaORPLcWr4NnZG4Z7B
 YkHPJCaM
 A2Vv0rtZLQp22gznTnBGkJsvpQkKL+2K3ZRP8me5bTRCf3SU2UwkcLJbxvLpH0z5uwewgfsIV8TVJ5CfblgOw5AEh6zR64FhtgI3WuaIzrHuI4JHWfgq5bTHmUrjfc5jMaV4slPa/QIJtbfDT30CG6O/Bwfa0t7J8H1CqpnUZXOlJgczkVzvD+JU9Jkkpp5JnSPptsEM9JJzY65UcjnMzQIT/ShuZosrZCTQdezUbR+VUCIGQ6KizeV2qzKmuLvqe5uDRTha3LP8/3RRKFAUWS61HN/4ueZJ+WZFEdqtmLYI3Kl5q6OCu1MJ99R+D3nKVTy0oNvMPcfH0K4oQHzGIBqj5V9K7HvEiXxhYHWoVoktRYBbzbiay8q12oD91EHULMCfCGRCUifBvXuFVJ3qoPvTqm5cNHZ1vNJkxNmXPWP+PpMzVWH8XJSslil39fcJEu2pXoG4twbqOhKgXlN6iEX/ecA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/28/26 21:35, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] mm/shmem: use-after-free in shmem_evict_inode() on concurrent swapoff
> --
> 
> commit bfe337ff80d886d314a9991abae8133932277cd0
> Author: Josef Bacik <josef@toxicpanda.com>
> 
> mm/shmem: hold off eviction in shmem_writeout()
> 
> This commit prevents inode eviction during shmem_writeout() by incrementing
> info->stop_eviction before removing the folio from the page cache and
> decrementing it after swap_writeout() and any potential page cache
> reinsertion complete. It also updates shmem_evict_inode() to always wait at
> least once for info->stop_eviction to reach zero even if the inode was
> already removed from the swaplist.
> 
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index e3e4bbbe1d802..eddd5870be072 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1616,6 +1616,17 @@ static int shmem_setattr(const struct mnt_idmap *idmap,
>>  	return error;
>>  }
>>  
>> +static void shmem_disallow_eviction(struct shmem_inode_info *info)
>> +{
>> +	atomic_inc(&info->stop_eviction);
>> +}
>> +
>> +static void shmem_allow_eviction(struct shmem_inode_info *info)
>> +{
>> +	if (atomic_dec_and_test(&info->stop_eviction))
>> +		wake_up_var(&info->stop_eviction);
>> +}
>> +
>>  static void shmem_evict_inode(struct inode *inode)
>>  {
>>  	struct shmem_inode_info *info = SHMEM_I(inode);
>> @@ -1628,16 +1639,21 @@ static void shmem_evict_inode(struct inode *inode)
>>  		mapping_set_exiting(inode->i_mapping);
>>  		shmem_truncate_range(inode, 0, (loff_t)-1);
>>  		shmem_unused_huge_del(inode);
>> -		while (!list_empty(&info->swaplist)) {
>> -			/* Wait while shmem_unuse() is scanning this inode... */
>> +		/*
>> +		 * Writeout may still use the inode after swapoff has removed it
>> +		 * from the swaplist, so always wait at least once.
>> +		 */
>> +		do {
>>  			wait_var_event(&info->stop_eviction,
>>  				       !atomic_read(&info->stop_eviction));
>> +			if (list_empty(&info->swaplist))
>> +				break;
>>  			spin_lock(&shmem_swaplist_lock);
>>  			/* ...but beware of the race if we peeked too early */
>>  			if (!atomic_read(&info->stop_eviction))
>>  				list_del_init(&info->swaplist);
>>  			spin_unlock(&shmem_swaplist_lock);
>> -		}
>> +		} while (!list_empty(&info->swaplist));
> 
> [Severity: High]
> Can this loop exit in shmem_evict_inode() while a concurrent shmem_unuse()
> still holds info->stop_eviction > 0, leading to a use-after-free of info and
> its embedded vfs_inode?
> 
> Specifically, two swapoff() syscalls on different swap types (typeA and
> typeB) can run try_to_unuse() -> shmem_unuse() concurrently while
> shmem_evict_inode() is evicting an inode:
> 
> 1. In shmem_evict_inode(), shmem_truncate_range() -> shmem_undo_range() ->
>    shmem_recalc_inode() frees the swap entries and sets info->swapped = 0
>    under info->lock (without shmem_swaplist_lock).
> 
> 2. Just before info->swapped becomes 0, shmem_unuse(typeA) on another CPU
>    holds shmem_swaplist_lock, sees info->swapped != 0, and is about to call
>    shmem_disallow_eviction(info):
> 
>    mm/shmem.c:shmem_unuse() {
>        ...
>        list_for_each_entry_safe(info, next, &shmem_swaplist, swaplist) {
>            if (!info->swapped) {
>                list_del_init(&info->swaplist);
>                continue;
>            }
>            shmem_disallow_eviction(info);
>            spin_unlock(&shmem_swaplist_lock);
> 
>            error = shmem_unuse_inode(&info->vfs_inode, type);
>        ...
>    }
> 
> 3. Before shmem_unuse(typeA) increments info->stop_eviction,
>    shmem_evict_inode() enters the do-while loop and evaluates
>    wait_var_event(&info->stop_eviction, !atomic_read(&info->stop_eviction)),
>    which returns immediately because info->stop_eviction is still 0 (the
>    "peeked too early" race noted in the comment).
> 
> 4. shmem_unuse(typeA) then calls shmem_disallow_eviction(info) (setting
>    info->stop_eviction to 1), drops shmem_swaplist_lock, and begins scanning
>    &info->vfs_inode in shmem_unuse_inode().
> 
> 5. A second concurrent swapoff running shmem_unuse(typeB) acquires
>    shmem_swaplist_lock, sees !info->swapped is now true, and removes the
>    inode from the list via list_del_init(&info->swaplist) without checking
>    info->stop_eviction.
> 
> 6. Back in shmem_evict_inode(), list_empty(&info->swaplist) is now true while
>    info->stop_eviction is 1. Either the new unlocked
>    if (list_empty(&info->swaplist)) break; exits the loop immediately, or
>    shmem_evict_inode() takes shmem_swaplist_lock, skips list_del_init()
>    because atomic_read(&info->stop_eviction) is non-zero, and then exits the
>    loop because the while (!list_empty(&info->swaplist)) condition is false.
> 
> Could shmem_evict_inode() then return and allow the inode to be freed while
> shmem_unuse(typeA) is still accessing &info->vfs_inode in shmem_unuse_inode()
> and later calling shmem_allow_eviction(info)?
> 

Two concurrent swapoffs, what at time to be alive.

IIUC, the problem is the check for list_empty(), and that can race.

So we must rely entirely on stop_eviction under lock.

diff --git a/mm/shmem.c b/mm/shmem.c
index c44d2dd71c89..e518fb8e3350 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1643,17 +1643,18 @@ static void shmem_evict_inode(struct inode *inode)
                 * Writeout may still use the inode after swapoff has removed it
                 * from the swaplist, so always wait at least once.
                 */
-               do {
+               while (true) {
                        wait_var_event(&info->stop_eviction,
                                       !atomic_read(&info->stop_eviction));
-                       if (list_empty(&info->swaplist))
-                               break;
+                       /* Verify under lock to sync with concurrent swapoff. */
                        spin_lock(&shmem_swaplist_lock);
-                       /* ...but beware of the race if we peeked too early */
-                       if (!atomic_read(&info->stop_eviction))
+                       if (!atomic_read(&info->stop_eviction)) {
                                list_del_init(&info->swaplist);
+                               spin_unlock(&shmem_swaplist_lock);
+                               break;
+                       }
                        spin_unlock(&shmem_swaplist_lock);
-               } while (!list_empty(&info->swaplist));
+               }
        }

        simple_xattrs_free(&sbinfo->xa_cache, &info->xattrs, sbinfo->max_inodes ? &freed : NULL);


But now we always have to grab the lock at least once.

Do we care? My intuition says "no". Thoughts? Alternatives?

-- 
Cheers,

David

