Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53732606A323
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 17:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a5ntfLO+
Received: by kanga.kvack.org (Postfix)
	id E83E86B05B4; Wed, 28 Oct 2026 13:31:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E34DB6B05B5; Wed, 28 Oct 2026 13:31:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D73296B05B6; Wed, 28 Oct 2026 13:31:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB36B6B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:31:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 418C91401B5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:31:26 +0000 (UTC)
X-FDA: 85372726572.28.5655818
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 91C8B1C0012
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:31:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a5ntfLO+;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793208684;
	b=bBol8Nu7kpp6B8RBt17pkdJ3wyPFd9XeRHrPs4FCL+EfQDRFo0X1l+iCnqYLJVSNlXvmQF
	N2P3tGK0b4GRiAxb3MR6NGut7pEHMvSfQ3JEw4Cv6riGQeUQ784+3njRTzbHzykyXzhlNE
	jpl4jts+9GMXmzPsN3aasqWR7vkk4m8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a5ntfLO+;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793208684;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0bSSM8FhTsNedWNt7lXmwJDLMiA0gbyOLiaRiVri7c=;
	b=HElZGdgXuuxux20dojW2TngO81u4TdTz+emd1QBsCHx663F/sl7ky86JHOrCFIiHRRl073
	IlGjFQFNZc8Eidn1ZYQcqC17ASdC0+hH79J4tCFASJK3Wmor7VfhrzJnx4jEH8xn49xSlY
	8TFYHt2VbyxOdVP0R2axo4i2yXsZch4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 070886021A;
	Wed, 28 Oct 2026 17:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3BC1F01825;
	Wed, 28 Oct 2026 17:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793208683;
	bh=l0bSSM8FhTsNedWNt7lXmwJDLMiA0gbyOLiaRiVri7c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a5ntfLO+h3Xj2oPj7TrcoswjoJMjKmwQR8qmTWwKE/f+5raVyVU5WoPEEi2/PUsV/
	 zCbqYib2iWN632LJp93qP5rFhqH5e8+o1wZtrqCtSf9MJGF1OKcLknwjxI6FLQvaXV
	 mKGQgoRVHmXk62ipiTJM2VT85lolGRQfrpWuQ57VfYQuc0mm2nY8AcU5GtSBrJvHtS
	 UBR0zq9ITIDa25Gs1JFwBQ9a0xLvuW5UmJY/wh5Iee5EZD8Jt09OkFOau03h06+vgH
	 jkyRmBrfcifU6X27nxszoOEIjfbYcAPW107pW+K4cZKlUrgZVAx0lX171l4yw2f1q5
	 Fgp3d0tBjRIZw==
Message-ID: <sashiko-outbox-188237@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] mm: shmem: use mapping_set_frozen() for memfd
 preservation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pratyush Yadav" <pratyush@kernel.org>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian
 Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, =?utf-8?b?TWF0?=
 =?utf-8?b?dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "Hugh
 Dickins" <hughd@google.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Zi
 Yan" <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Mike
 Rapoport" <rppt@kernel.org>, "Matthew Brost" <matthew.brost@intel.com>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Byungchul Park" <byungchul@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Kairui Song" <kasong@tencent.com>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>
Cc: linux-mm@kvack.org, kexec@lists.infradead.org
In-Reply-To: <20261027173031.763213-4-pratyush@kernel.org>
References: <20261027173031.763213-1-pratyush@kernel.org>
 <20261027173031.763213-4-pratyush@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 17:31:21 +0000
X-Stat-Signature: 5z5sbjmu4s73b3hrfoqn7q4ewg9tjt6w
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 91C8B1C0012
X-Rspam-User: 
X-HE-Tag: 1793208684-110515
X-HE-Meta: U2FsdGVkX19DJvBZ+MSibTNS8Wt7jB1j44317Tsjw7g3CFHdiV8CgeiRoqsib7irnW/Cl+uBKv4rX+XCkbmBEIhfWTvBXs6ykPzLjTIVGVp5pCzJKXSetloV47LhdIKMqxtIiLe+LBHwPzWZX+8zUbqXGCUuFtvAPv6Q8Tn8RLTrc/ZkMiD+3NJNFftuhYR6Rp4TbuoFopgdvLAspFxOG9+mD1U5GKbZMm3rzJkVhjxwrgy9yWLlHNXDhWIpQXq/5qGNjk4D8CegjSv0g6Eok9hyTDej1ITrmpba7VseVjTUfA0lMDRGzCX+vmCNVpcdarI3Zc93vgKdZ95WaoQUUbMFjjwrnx51im7N26QmlO7dBaV9HZKdRGqH73eJIfEbiO6ZjoCHoGgJZCbog1NKDfWcSE4ZubsadGWenVG2kXuTFvsPXaF6CvpOxEft1Kk3fEASasZSMCZvmAhzDBQb07ucyj2ESxUoUmCi0Z3TCLekNNVJ5EWdjV8jIk1dLjK7yrt6NyihK2mwpnl5dVnp7lQyVwD9Pr/QNbH7vah78wdOcRixEBo7W4slRb/fFoeinGS7vkbrTsQBsrd+wxVbzb3wwDhsz08Hw9hCFtbLFZrfQEnAtwoBlG9iwUpRIPhfoJkPfhQGPjraVIo/mV92LYIm2t0RjVuPVpNsBGsWcw/OSmPv2d7D0vIsId2SqlKdA+H7AsAa4GYMV5ZUxcWrWWHiD6exS6/iBxOIg1dC70y61gK939zlYdzPvOdPpFlhk7ACIsvfELMQf4pkzjW6QnDq0p8n/FxP9XbjjnMfpAl0chxkUo1ieCmmMg9JA4YO1ZAuO0WK3kTt/TI5RH5/UivLOLQlv9607KRvuGmhP68QjP2k6z4ox0kwveDfKLxBZREcJHBYgX9zjTOSEDRbjDGciv91Ywb5hxdMGqecv70oUMlw/VAUtLMGZRH/uC9ez8SNGlOpVCJazq5dHNv
 fMgdyCPv
 QKd8dmkNj1RdQKV2Sbro10tXXq0YgXpMoOSzHvWb7TNjZ530TVwJc63Gnau1DaRDu3jvEELlAMslmUENyyPqfnkKzgUqUNgruKfXRk68ds/PcFM4bV5U4N+1R//OPlSFaL64a9KcUQwHDRMgBNZWAjUwDCJDL5wvTKsaYkI0XxsPGUxlYdiGsAKPsSE7uvg+EAUqRU2zf4hasrXG+hhDwA6JQ1qbGC+5H07Q9GCfn9gchQZnzqXkpr5gxZ4HK0kS+53SRziA9TECk0CW/+1K2UWBlnGVKEuVsO52PjmzV/kjhVN3K108rGJ3baa5071m5X1cE5w+Ubgp/01noFO4wGqYEi+fd2ohfrN6AruV1+laWzr6Z025hxDzdkvlqiNMRXDLfD93Sf0ffWpT9zozmj8F6AT05f6HtaO7qU20pcHykw2DxxPkSHHbPjMchi34wS73kiSy6iZvh7m34v/z7CoBbjsNLNuhjvGpkN3ReuJZSzPypAqMhZSu7WQr+xcqY9vbvRvRGpwaS6bkF50Q3hLGdAQY52n3Te6+QkWDG2xur2yHELNdDOrueJh5d5kzc9H4zYZ+N/cVkCPBqtl2CHozABur5Zpv6mOuv6b4QBli1k5wZoTfmTsSUR06JVkc1LzwKSAhFn+9XzsMtCUdRk2UybwA0+x7PDTGfCj2nvLveCXVEut/rHtQlMjJdlDn0yVTND4jmNsHzau+Whqp6S2j/9J7ZwMHlI+CsAv5TCXqjWOLhBTTVxXssSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mm: shmem: broken mapping_frozen() check ordering in shmem_setattr=
()
- [High] mm: shmem: shmem_write_begin() allows extending i_size on frozen m=
appings
--

commit f05d5b8fc61839cbb16ea914eab638cf83da5354
Author: Pratyush Yadav (Google) <pratyush@kernel.org>

mm: shmem: use mapping_set_frozen() for memfd preservation

This commit replaces the shmem-specific SHMEM_F_MAPPING_FROZEN flag with
generic page cache mapping_set_frozen() and mapping_frozen() helpers for
memfd live update preservation. It also updates shmem_setattr(),
shmem_write_begin(), and shmem_fallocate() to rely on the frozen mapping
state.

> diff --git a/mm/shmem.c b/mm/shmem.c
> index 6507b4246c8af..1c70fd306bec2 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1570,8 +1570,6 @@ static int shmem_setattr(struct mnt_idmap *idmap,
>  			return -EPERM;
> =20
>  		if (newsize !=3D oldsize) {
> -			if (info->flags & SHMEM_F_MAPPING_FROZEN)
> -				return -EPERM;
>  			error =3D shmem_reacct_size(SHMEM_I(inode)->flags,
>  					oldsize, newsize);
>  			if (error)
> @@ -1583,6 +1581,11 @@ static int shmem_setattr(struct mnt_idmap *idmap,
>  		}
>  		if (newsize <=3D oldsize) {
>  			loff_t holebegin =3D round_up(newsize, PAGE_SIZE);
> +
> +			/* No truncation allowed on a frozen mapping. */
> +			if (mapping_frozen(inode->i_mapping))
> +				return -EBUSY;

[Severity: High]
Does moving the frozen check after the newsize !=3D oldsize block corrupt
inode->i_size and VM memory accounting on shrink, while allowing a frozen
memfd to grow via truncate()?

In mm/shmem.c:shmem_setattr(), when attr->ia_valid & ATTR_SIZE is set:

	if (newsize !=3D oldsize) {
		error =3D shmem_reacct_size(SHMEM_I(inode)->flags,
				oldsize, newsize);
		if (error)
			return error;
		i_size_write(inode, newsize);
		update_mtime =3D true;
	}

When shrinking a frozen file (newsize < oldsize), shmem_reacct_size()
unaccounts VM_ACCT(oldsize) - VM_ACCT(newsize) via vm_unacct_memory() and
i_size_write() updates inode->i_size before the newsize <=3D oldsize block
checks mapping_frozen(inode->i_mapping) and returns -EBUSY without rolling
back either change or truncating the pages past the new EOF.

When growing a frozen file (newsize > oldsize), the newsize <=3D oldsize
branch is not taken at all, so mapping_frozen() is never checked and
inode->i_size increases even though memfd_luo_preserve() already recorded
ser->size and memfd_luo_freeze() only updates ser->pos.

Should mapping_frozen(inode->i_mapping) be checked before the
newsize !=3D oldsize block so all ATTR_SIZE changes on frozen mappings are
rejected before modifying state?

> @@ -3482,10 +3485,6 @@ shmem_write_begin(const struct kiocb *iocb, struct=
 address_space *mapping,
>  			return -EPERM;
>  	}
> =20
> -	if (unlikely((info->flags & SHMEM_F_MAPPING_FROZEN) &&
> -		     pos + len > inode->i_size))
> -		return -EPERM;
> -
>  	ret =3D shmem_get_folio(inode, index, pos + len, &folio, SGP_WRITE);
>  	if (ret)
>  		return ret;

[Severity: High]
Can removing this check allow buffered writes to extend inode->i_size on a
frozen mapping when a folio is already resident at index?

If a preserved memfd has an unaligned i_size, a large folio spanning past
i_size, or folios preallocated beyond i_size with FALLOC_FL_KEEP_SIZE,
shmem_get_folio() finds the existing folio in i_pages without allocating and
inserting a new folio, so the frozen mapping check in page cache insertion
is not triggered.

Then mm/shmem.c:shmem_write_end() extends inode->i_size:

	if (pos + copied > inode->i_size)
		i_size_write(inode, pos + copied);

Because mm/memfd_luo.c:memfd_luo_preserve() captures ser->size during
preservation and memfd_luo_freeze() only updates ser->pos, any size extensi=
on
and data written past the preserved size will be lost across kexec.

Should shmem_write_begin() still reject writes with pos + len > inode->i_si=
ze
when mapping_frozen(mapping) is true?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027173031.7632=
13-1-pratyush@kernel.org?part=3D3

