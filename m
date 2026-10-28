Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93EC6606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MeWQu/E9
Received: by kanga.kvack.org (Postfix)
	id 30A9A6B05B2; Wed, 28 Oct 2026 16:35:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BB156B05B3; Wed, 28 Oct 2026 16:35:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AA416B05B4; Wed, 28 Oct 2026 16:35:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E002D6B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:35:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 736881201D0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:35:34 +0000 (UTC)
X-FDA: 85373190588.25.2E00AAB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id D4122180007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:35:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MeWQu/E9";
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793219732;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4gS9H3VclwQz1/TXNAuN1y8+nTCQEFaOC0oKafoGRDc=;
	b=HuXt1nMzjFxbUj1UGDcWls9FMpkaQQd98u6NN7Odk0g2TrOFUBBkZws6GDJl2jOBY+q0UI
	qEUSPI3u+t0r9m9zfNkVtiJOy5lfWUTyW695trbIDXiUvfbcRd57G87QHUlkclG199hll0
	cHtZcjqXdXZb+x/gJPNqHekedIND79A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793219732;
	b=Oy98ld0NOi2iUcqtS0DS3dmkraXzM7SRm3Lk+O2qDM6WGK9Pf65rYkJznKqVDDjfr6l1Qr
	/GkCJzZUuYGJ991Xhil5+RPrsw+KU/dbNWLU4gtuHIpKQHztrkDzYdwulSVAS7S5HxxbC8
	MIUEF0iWx4L/9pIMnJPdD+YpfkXPbZk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MeWQu/E9";
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 53168601FE;
	Wed, 28 Oct 2026 20:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9638F1F01825;
	Wed, 28 Oct 2026 20:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793219732;
	bh=4gS9H3VclwQz1/TXNAuN1y8+nTCQEFaOC0oKafoGRDc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MeWQu/E9+sKr4BgLXe3Dzj9btMMgahf0+QQZTGcIZcvTUKToLih3VDIvUl28SrNMs
	 onWJBdIkScTX0T3jRfus3q7ofzmzU4vx51ShSBoNtTmFx6ZWuyJi0G8e+XgiqfLw5X
	 SAtuomAf/ZtKJTeT/eP/EyQdwIIY61RJ1nQk39MR+AQqC042cIdYT8HFzrv6D3hNk9
	 L/n4KUtMzfQozKymftIsYEjI9n52lEZmbQa2Iv8xHkXyRa4PtnZIhSqcOYHL1Brh9f
	 EqnUWrgDS9SyF9Baw/vG7NIT5ZheKOho2P4WWJrjEdeposkMsy2MRTBDjY68p8wYzk
	 C519XProNeIlw==
Message-ID: <sashiko-outbox-188427@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/15] mm/shmem: hold off eviction in
 shmem_writeout()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?RGF2aWQgSGlsZGVuYnJhbmQgKEFybSk=?= <david@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Gregory Price" <gourry@gourry.net>, "Zi
 Yan" <ziy@nvidia.com>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Vladimir
 Davydov" <vdavydov.dev@gmail.com>, "Michal Hocko" <mhocko@suse.com>, "Hugh
 Dickins" <hughd@google.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Lukas
 Czerner" <lczerner@redhat.com>, "Carlos Maiolino" <cmaiolino@redhat.com>, "Christian
 Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, "Daniel Verkamp" <dverkamp@chromium.org>, "Jeff
 Xu" <jeffxu@google.com>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, "David Stevens" <stevensd@chromium.org>,
 =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "William
 Kucharski" <william.kucharski@oracle.com>, "Chris Li" <chrisl@kernel.org>, "Kairui
 Song" <kasong@tencent.com>, "Nhat Pham" <nphamcs@gmail.com>, "Miaohe Lin" <linmiaohe@huawei.com>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, "Josef Bacik" <josef@toxicpanda.com>, "Pedro Falcato" <pfalcato@suse.de>,
 =?utf-8?b?S2lyeWwgU2h1dHNlbWF1IChNZXRhKQ==?= <kas@kernel.org>
In-Reply-To: <20261028-fixes_shmem-v3-6-4ce3baf2db4b@kernel.org>
References: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
 <20261028-fixes_shmem-v3-6-4ce3baf2db4b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 20:35:30 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D4122180007
X-Stat-Signature: 7844ursp7zgw4pyz1feyg1nxkz7saswk
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793219732-566689
X-HE-Meta: U2FsdGVkX1+jDqFaQoQJ1UyqDqtG6lM0iz0HzslDnwyeVw/Y84KmK65N/bXo1OKijnqdxqbYt3oENlI+ot5A3QIEpKhCSINblW3y1bdd4GLukxb6X0TY0gnRngqewSG2FAa3+l3/dvwnV3udN3k90BBa2fLRBCu+BpF/AXfkqrTgJJbP45NTt1BNcQip3eqNhAMhnR6qTT+ytse4wRW/15a6N09hQ3LdwREB/3UHkGKRWPkRNZ6xo9gOEkzgZx5oHjqMSaODYgMQDyfKRmuLRh3X9Y1ZRaXbpcfhJoenazsP+8XQAH7uzOUmnjiFBqoSWWN+QUouBDeAgrfaKJBPSZbN3nabt5l0uyXinvomOwIdd838QFWf7emGPNwR4GKYa9+HMLpCFpAWnrK4MIgSJQvFiKuUMdulTAphUFWNh4TEx4UUbsQAMY8nezGeliJ7Wf/8FdJONCmiYTNcehCmYubOvLu6q7/5MdldBSuEjTrRjgy2XrM8b3E3HCeu8+9eP/fD68tTLq100u0v4UWtxcjvGyOaHF3EZqpB5wIi/ebsqTDM+t96NP9xHdIkWdfxkFbK11yDTqkz9Yz90B2qT0b3eLt+s2xQG+c+Au80MzvEq/uM35jVFhm7l3czf930vnAlAy9Ur7sEfwSUrUrbK2LxcKGjDXYZcprfYARRS7aboM/hLwlWpRIkwCkXdWfroOS+huCGtHP+6st1T9Cg8Uhs7hrk5hED5edLjOlmvIWDulTGwp6f3F7h1eRbyclgyo+BoLghUEhBK+q+NsUsFvWbdI1kY9JW2dZmAqrirhRrJW3jjJFc5V93cTbTIPiUSRpJQVZpgiIpKTdchcNlnGxae6S2DqSdLBBQ312mutMzKh3eO8FGgtjbHwbwRbNQcVp4fwLpFACA0GAwBPvwOY4Su3HFb42Gl0saH+l7cyq1YKdKGeMtVuxVABe48VkouvOdX8AbELJcjJMAK3f
 iKCm9e2z
 M/tMb50c/Fhkhkusp+cT1XJFcmsAeU/zU0GhzUH7yNP2XHnli7jO8E3j70jL92sAhew8kbasF5GGkbEp+xTH2t4q8AKgT8RYE0lGVts7i5XLD3vzexSQzm1PeozQjOhGd1vp5pVrI0HxOWYI9EPJ4KRh8/hOFNYOgD35ny9+COxayTlGNhcGaa6JfU4R79cGnQEqdIEgt1arh5dhXhWA1HHbjPndO+roOuOD7nQd3/+9eYT7DDLuJfqXH1Rs1KwPabfmIcFA/2yYKu38GttkUD6oRSRTJzOi9iJvnPzbpFVcWW1JYYt4DWrnpfPhZEgWH/bnyB3qHuZt8PSxEurJFTCzskb+vftKFyWJrF6Fc9jG9cseWXSi4tL86InFul8FIIc0fs6c/Yr2Vv/j1BdOXbrZ1Yqx/5HB2aWiaj8nTDzVMsFStUrotqL9j2MZoyzhpr2JbDOqM1SxhHWKPjcNDJ7R0xJF3Bqnoa3/MpQ+eL0yitJqsVl8DOVVEtZpdqBmj7V+OwGLuRRU5mftRqMJRiItSBPbnHe/rpFGboAZAo/sSzXfYw6lfffROZJ2ezQaWWNHgiFSSMvLRINGlElcxao6AiDETskk5aR2Qxrbkun3U6oP/P+vQyubLkY+6cQ+RZHTQ3VgXj3tqL0b2S29Hgh9ZawzdEosSQE3zNWZBORq0LwhC2oq634xjHHBni+ttKFQIGDa7vTEmtxYb7PJ7TnHHoiAMUHTjq+xgRiJ2JfYBM0jhqj2vPHHOpybFXPHUkICCWFyR0i9kIES97PIuSeewD8tNKiMBn5cQOcdKz801QHTo69NnIqYaqQGaoignNWiGE9Ya42dZcEwcfETct7pMdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm/shmem: use-after-free in shmem_evict_inode() on concurrent swap=
off
--

commit bfe337ff80d886d314a9991abae8133932277cd0
Author: Josef Bacik <josef@toxicpanda.com>

mm/shmem: hold off eviction in shmem_writeout()

This commit prevents inode eviction during shmem_writeout() by incrementing
info->stop_eviction before removing the folio from the page cache and
decrementing it after swap_writeout() and any potential page cache
reinsertion complete. It also updates shmem_evict_inode() to always wait at
least once for info->stop_eviction to reach zero even if the inode was
already removed from the swaplist.

> diff --git a/mm/shmem.c b/mm/shmem.c
> index e3e4bbbe1d802..eddd5870be072 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1616,6 +1616,17 @@ static int shmem_setattr(const struct mnt_idmap *i=
dmap,
>  	return error;
>  }
> =20
> +static void shmem_disallow_eviction(struct shmem_inode_info *info)
> +{
> +	atomic_inc(&info->stop_eviction);
> +}
> +
> +static void shmem_allow_eviction(struct shmem_inode_info *info)
> +{
> +	if (atomic_dec_and_test(&info->stop_eviction))
> +		wake_up_var(&info->stop_eviction);
> +}
> +
>  static void shmem_evict_inode(struct inode *inode)
>  {
>  	struct shmem_inode_info *info =3D SHMEM_I(inode);
> @@ -1628,16 +1639,21 @@ static void shmem_evict_inode(struct inode *inode)
>  		mapping_set_exiting(inode->i_mapping);
>  		shmem_truncate_range(inode, 0, (loff_t)-1);
>  		shmem_unused_huge_del(inode);
> -		while (!list_empty(&info->swaplist)) {
> -			/* Wait while shmem_unuse() is scanning this inode... */
> +		/*
> +		 * Writeout may still use the inode after swapoff has removed it
> +		 * from the swaplist, so always wait at least once.
> +		 */
> +		do {
>  			wait_var_event(&info->stop_eviction,
>  				       !atomic_read(&info->stop_eviction));
> +			if (list_empty(&info->swaplist))
> +				break;
>  			spin_lock(&shmem_swaplist_lock);
>  			/* ...but beware of the race if we peeked too early */
>  			if (!atomic_read(&info->stop_eviction))
>  				list_del_init(&info->swaplist);
>  			spin_unlock(&shmem_swaplist_lock);
> -		}
> +		} while (!list_empty(&info->swaplist));

[Severity: High]
Can this loop exit in shmem_evict_inode() while a concurrent shmem_unuse()
still holds info->stop_eviction > 0, leading to a use-after-free of info and
its embedded vfs_inode?

Specifically, two swapoff() syscalls on different swap types (typeA and
typeB) can run try_to_unuse() -> shmem_unuse() concurrently while
shmem_evict_inode() is evicting an inode:

1. In shmem_evict_inode(), shmem_truncate_range() -> shmem_undo_range() ->
   shmem_recalc_inode() frees the swap entries and sets info->swapped =3D 0
   under info->lock (without shmem_swaplist_lock).

2. Just before info->swapped becomes 0, shmem_unuse(typeA) on another CPU
   holds shmem_swaplist_lock, sees info->swapped !=3D 0, and is about to ca=
ll
   shmem_disallow_eviction(info):

   mm/shmem.c:shmem_unuse() {
       ...
       list_for_each_entry_safe(info, next, &shmem_swaplist, swaplist) {
           if (!info->swapped) {
               list_del_init(&info->swaplist);
               continue;
           }
           shmem_disallow_eviction(info);
           spin_unlock(&shmem_swaplist_lock);

           error =3D shmem_unuse_inode(&info->vfs_inode, type);
       ...
   }

3. Before shmem_unuse(typeA) increments info->stop_eviction,
   shmem_evict_inode() enters the do-while loop and evaluates
   wait_var_event(&info->stop_eviction, !atomic_read(&info->stop_eviction)),
   which returns immediately because info->stop_eviction is still 0 (the
   "peeked too early" race noted in the comment).

4. shmem_unuse(typeA) then calls shmem_disallow_eviction(info) (setting
   info->stop_eviction to 1), drops shmem_swaplist_lock, and begins scanning
   &info->vfs_inode in shmem_unuse_inode().

5. A second concurrent swapoff running shmem_unuse(typeB) acquires
   shmem_swaplist_lock, sees !info->swapped is now true, and removes the
   inode from the list via list_del_init(&info->swaplist) without checking
   info->stop_eviction.

6. Back in shmem_evict_inode(), list_empty(&info->swaplist) is now true whi=
le
   info->stop_eviction is 1. Either the new unlocked
   if (list_empty(&info->swaplist)) break; exits the loop immediately, or
   shmem_evict_inode() takes shmem_swaplist_lock, skips list_del_init()
   because atomic_read(&info->stop_eviction) is non-zero, and then exits the
   loop because the while (!list_empty(&info->swaplist)) condition is false.

Could shmem_evict_inode() then return and allow the inode to be freed while
shmem_unuse(typeA) is still accessing &info->vfs_inode in shmem_unuse_inode=
()
and later calling shmem_allow_eviction(info)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028-fixes_shme=
m-v3-0-4ce3baf2db4b@kernel.org?part=3D6

