Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C90B606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jVgJN/Pj
Received: by kanga.kvack.org (Postfix)
	id 66A0C6B05BD; Mon, 26 Oct 2026 22:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61A936B05BE; Mon, 26 Oct 2026 22:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 509AC6B05BF; Mon, 26 Oct 2026 22:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 20E836B05BD
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:22:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 92A4FC08DB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:22:28 +0000 (UTC)
X-FDA: 85366807176.01.DED7C02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0505EA0008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:22:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jVgJN/Pj";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793067747;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pcuuQctJg5l1Z0RFAX46rdLGTwh9BUfJhRcLZEucPZA=;
	b=WoBkN8+bWiB7RTBmnwfLDsF7FJm9PCTMsiz5IVzG/ISd5i4e45ZB5Ei5YoBAKA20ELvAp1
	MFiPHMoVwD0Gw3plofVOnL0iIHoAxo51L/X/B+MLVKRMaFA6XKP8ofIq5GiQIPWYFIEADc
	paCeKinwL/Ucm1jTNcLvozSzq+5Y67o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jVgJN/Pj";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793067747;
	b=wdBVTEN2zygXAx+V52ld/3TRVUjGT9VxUtR3pAoS4f8xPJGLDWF1Sm1Zq7EN06PplCWxBe
	tZj3gwP8XqLoSu1zVJTITkBW0tC6z6Qfv6b+m8TV+RkkivUEai/NaKaUw/ozIYSHTEAISQ
	Q7tAonAo6fZPWc83hmrZJ93JY/PqQDw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 70064601F0;
	Tue, 27 Oct 2026 02:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AF31F01825;
	Tue, 27 Oct 2026 02:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793067746;
	bh=pcuuQctJg5l1Z0RFAX46rdLGTwh9BUfJhRcLZEucPZA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jVgJN/PjXR8S5XKYnRvNbMJX26p+89xuc4g04Ir0Ev0m4Ia8KYIRtvHB2rCYFYCVI
	 194uMGk4YQK/nvVvcZBfo88ScTXPbiziOSh7h3ux3lHDOQe/MBQumZlbZV5LQ93adP
	 cnF2f2eeWmGW+NNIrDvKXeBxfZqsti+FI4aDRh1hYjdgpw9/9+xwHoH83VmvouGBAo
	 KugtGbt+lASMcqBSHJ6Y/tT7JMecJeJ+I/yqh3TFB4CzhR7BwFDgMNchc0kvnl5YkH
	 aM+z6v1oiNlUh03pMo44L8DyoIBUBM1Z3pj3/wHJYoJWg/PL0ri8zEnKA9KGkafTtE
	 cUAoDDVmMwQGQ==
Message-ID: <sashiko-outbox-186003@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 05/16] hugetlbfs: enforce F_SEAL_EXEC in setattr
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
Cc: linux-mm@kvack.org, "Eva Kurchatova" <eva.kurchatova@virtuozzo.com>
In-Reply-To: <20261026-fixes_shmem-v1-5-703206d5fa0c@kernel.org>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-5-703206d5fa0c@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 02:22:24 +0000
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0505EA0008
X-Stat-Signature: ox7o8bm7eitdk9oe78w8siukbcyae449
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793067746-547556
X-HE-Meta: U2FsdGVkX1/TnhxtKkJJShRGQ4JAlKobRMV0G1tV8PYuAUogfiqyxiaToJRkNzVd916KIEXLkpkWu/p590WwfTEfmu+U6GznOsOk7WD8CxgpAO7JaWfkhHIRVvSVXH/VujawmCMEXipJ08xeUEZmbrwZKnL8yaI+kAyKZKox2dmZWiHXvOeSi/M9fvrnsA/xSil5dxEbHmAQ2sqUkE8LN/8GQAe8ACvJP3KsHW5YYdqoxN/KsSyKoqXnzIvU2yscS7btVkpCoYkISBqsfNilm9KEvq9IggZNo6WfXnuPss7lUb5FjgtQQjgGfQjeW0CFyTePanQoW5Uyb4Yms3912puR0uFalxV0sNG3SQJSeCs+UjoX+YgLEAkdZhX7FwXLha8DuMwWHVhtsSbQ72iZpSrScTS02qCIhPb22DPgnjoqxeDxRCVIHVY1JUJ7K3oAn63EVlOfDeSWpv0gS+KDLIGR+UiAnJq0RrWRlI3CMArhQ4yd77pbfLg/9yMyrytjndP1s3PxRr+cy0xJB7DSJ/if87UGF/DP06M+xcHHPYC5upY76yZzd2Kvq3Dg+fbhJKxEj1e4+P1T9LurHsITW/v24rzAa1n6R9FphF07piVPTuCuDe/eLtFrtJ10z1PCfVbzl50zVImo1C7Ju48i/sdAM8LOKmeobiqJg1dh7DQaHSQnpXEZpkw/Fp/8DFL3DThIHmWTU3zEakzPMb9/PAawHc0TWjMLZxbOIUCYaE5a984vpRpUsxUoU2H3L3NmP52dwmkIRg6bw+7Y7UiVp5gOwlpcTrZ8nndf8SwfnvE1uDc5kqjk41JGSPlTnUd/u+FY1FIKvTQVGHb+x+4rq0BjzOXKUNWDIpZEhiyhpVJXDQiEL4GYDqX9ilceIqi9iQ9qAjo+KwjHkUhPEO+F0k3VlY0T09R0W1qmTet/Dg7V42AvRrXwnsqBbNKYqK7ZOutXwc4ToOa5vxZjjoo
 /rnGeWMB
 g3u4pou82/JhV2IhArKCXttFQYpb5lztDh0PXhjvehaE/GcX2agyBdIHQ5PhXo/JhRlEFuoqMvysRW2VlcuYoZJqAc6E7aRMWap6pUUk6AoxxEZBduMEAFTcA6q1kUsL9uxQ6dtknOVPLv2vARUsNuh5h2C5WnwybKIGHhgzjclWNDivKphGCIDgyGwqXDa1IsGKJ2PCZwyyYq99Iyd6nG6fLcau4q67FD24o5o60oEL4PewKVwOLVe8djpG185XykIlpaFqWfJX9BXMuMswV0bI0m4CwPp2lncg6PwYast2bPNZUpqrZ/rPfDpPFBEH3v2n2nLmiWP1g1tbozLrBerjXyq1mz157/LBSAGOz79a/GEemJNkM6TJvsDG7KXZ3+Uuxuvpp6qk3/SS9vQiLNPVkWsh8Bbq99yPIVJaV2XqVuIKPKw8/NwjDQeZrUjWIDaCY6MVrV4fQHoNuR7sXKL+MAwRBFYo1pgIPnhyGYAssASJvh9kEeXRWaRcIWc4M9Z0qvcY68xSH4Fyyv5xJ2Gb2H6kKPHr/lYTB8EJyuGFqfA6xy4EOVH2Clxjx8NVH+UDRZBthrlyJBViG82dLSXf8oETGfGjlJwkJeVAZsXpGGQFur0ruEJnuQKApAjTvw42CjwkyUKzs1JgrnuIJAlq6Wj5vlaZ6dlQZ/rdGLqpNQ0tRHmf04INdyU4jp4bBa6kfQOVa7H+yppJaOQjoxGnfIpT2JK7qDO1lIID982Uw3tkUi9A9ZzolCNJguQE77T7xmbiBecOyRNEp8OHCVXn73v2xaR33K0c7DX6CDoHBmCS/J9hPYpxbPKz9WSgaGhKI8Gnpn2tIMVo3SWoTKOMSljYqRGEf7L05/QH5QqqgAIWUsNPL8ZI1jD5pGEUK8rTQ
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
- [Medium] hugetlbfs: uninitialized info->seals read in hugetlbfs_setattr()=
 on root dir
--

commit dfab7a0d71278312f805e82ce52518a8ea2f538d
Author: Eva Kurchatova <eva.kurchatova@virtuozzo.com>

hugetlbfs: enforce F_SEAL_EXEC in setattr

This patch updates hugetlbfs_setattr() to call memfd_check_seals_mode() when
ATTR_MODE is set so that fchmod() cannot modify execute bits on a hugetlbfs
memfd sealed with F_SEAL_EXEC.

Link: https://patch.msgid.link/20260629180247.2343229-1-eva.kurchatova@virt=
uozzo.com

> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 6656807ce4377..7f5c3962b5d56 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c

[ ... ]

> @@ -841,6 +842,13 @@ static int hugetlbfs_setattr(const struct mnt_idmap =
*idmap,
>  	if (error)
>  		return error;
> =20
> +	if (ia_valid & ATTR_MODE) {
> +		error =3D memfd_check_seals_mode(info->seals, inode->i_mode,
> +					       attr->ia_mode);
> +		if (error)
> +			return error;
> +	}

[Severity: Medium]
Can this read uninitialized or stale slab memory from info->seals when
chmod() is called on a hugetlbfs root directory?

hugetlbfs_dir_inode_operations wires .setattr to hugetlbfs_setattr(). Unlike
hugetlbfs_get_inode(), which sets info->seals =3D F_SEAL_SEAL,
hugetlbfs_get_root() allocates the root directory inode via new_inode() ->
hugetlbfs_alloc_inode() without initializing HUGETLBFS_I(inode)->seals:

fs/hugetlbfs/inode.c:hugetlbfs_get_root() {
	inode =3D new_inode(sb);
	if (inode) {
		...
		inode->i_op =3D &hugetlbfs_dir_inode_operations;
		inode->i_fop =3D &simple_dir_operations;
		HUGETLBFS_I(inode)->resv_map =3D NULL;
		/* directory inodes start off with i_nlink =3D=3D 2 (for "." entry) */
		inc_nlink(inode);
		lockdep_annotate_inode_mutex_key(inode);
	}
	return inode;
}

Because hugetlbfs_inode_cachep uses the init_once() slab constructor, which
only calls inode_init_once(&ei->vfs_inode), newly allocated or recycled
hugetlbfs_inode_info objects are not zeroed on allocation.

Previously, hugetlbfs_setattr() only checked info->seals under ATTR_SIZE,
which is not reachable on directories. With the new ATTR_MODE check, changi=
ng
any execute/search bit on the mountpoint root directory reads info->seals
and can fail with -EPERM if the F_SEAL_EXEC bit is set in uninitialized
memory or left over from a previously freed sealed hugetlb memfd.

Should hugetlbfs_get_root() also initialize HUGETLBFS_I(inode)->seals =3D
F_SEAL_SEAL?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026-fixes_shme=
m-v1-0-703206d5fa0c@kernel.org?part=3D5

