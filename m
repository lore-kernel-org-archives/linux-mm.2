Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60952606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 00:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b7oworxH
Received: by kanga.kvack.org (Postfix)
	id 7B8956B05BB; Wed, 11 Nov 2026 19:31:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 790526B05BC; Wed, 11 Nov 2026 19:31:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67F196B05BD; Wed, 11 Nov 2026 19:31:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40BC86B05BB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:31:24 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BB2F4803F6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:31:23 +0000 (UTC)
X-FDA: 85424588046.12.2AFB578
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 27A2340003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:31:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b7oworxH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794443482;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sM9FfP0zyszmMrgXJ0phgeLchPzm+/kuKHgm7FbXyLo=;
	b=dE+/a0TV8KNW2Ur9XcsbsFN/QYFCQhWrsZ1FHdND327I5Pk0fArPUp7TFFiozxgKSgVTGB
	1FexE9om1GI0ejOrkU+niO9WOR/dHo7vJ8ZVtkuuXpTDFPI2/qaHeGnPPmyM30dRcKxjhs
	Y4YYZzifvAnj6WKpcEvo+GpsY4/Tu0c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794443482;
	b=ku4RkWqORKNrMD0ElleRjnJd7EX5Q8PsVsN5PrAPbX6dAESI4lYdfClmFcBudnC18YxWKg
	0dEfs0qwK+FYfCGbCKwOWI7c75dqxkIUBXSDYKMaQV55Yuw4kBMVcXLByF31rUoQqR/w4S
	vxoZ0TWlNe0x2bTodkuDZjlP6ZE4XWc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b7oworxH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C05FA633BF;
	Thu, 12 Nov 2026 00:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869381F00A05;
	Thu, 12 Nov 2026 00:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794443481;
	bh=sM9FfP0zyszmMrgXJ0phgeLchPzm+/kuKHgm7FbXyLo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b7oworxHXPHYvhLTDqK5HshSAhlCDtckAZGdB75jVM/OF9eGX9G6zrrrYyUf6Oy+t
	 3XKp3COx88PfmVzzWKWPD+gfhSf6jxV5k4FvvbEqMhZzwK0g2VSSwg5UDxKqCaoNGM
	 83OXjt6jRpTVyaulUa3gd8+hSwmK6MXtGqarQBsLuaJmdggNAftWy49Y/Pl8dNpO8b
	 nP63N2JgqckUyHCBcYF6jLTiNkp3KEjdB+gu6zM/RPWwnDkZ3ztZG7Kvey3/QmlTUE
	 fvfQosLMUti2eINt52oxI0yi804ppbl6IMCM+F25mSiS3OXcG2Zx8EO+GXdlT80G61
	 Gsi4SjdY7+dIg==
Message-ID: <sashiko-outbox-209944@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 12/19] mm/shmem_luo: Retrieve tmpfs files into a file
 created by userspace
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Matlack" <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Cc: "Alexander Graf" <graf@amazon.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Hugh Dickins" <hughd@google.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Samiullah Khawaja" <skhawaja@google.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Suren Baghdasaryan" <surenb@google.com>, "Vlastimil
 Babka" <vbabka@kernel.org>
In-Reply-To: <20261111002358.1842967-13-dmatlack@google.com>
References: <20261111002358.1842967-1-dmatlack@google.com>
 <20261111002358.1842967-13-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:31:20 +0000
X-Stat-Signature: yeqhkk5zftjm4bmuuyk7hiceehjukgf9
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 27A2340003
X-HE-Tag: 1794443482-735332
X-HE-Meta: U2FsdGVkX1873U+WRuGM7kR20VFUHcvX+0nfk8rkdYeShuYxAjms19MQMRi4VOn93TXnaOY8wcaovbVqaS5iDuWNtXKsn3aUAkCxzhBAZV3wfys8twA5yGJz5Rhc01+xI+tlRazOt5rwU4locftwWHT6K2hXm7x21Gyg7Tc/8OXBK2pOWgUyOyBBK2KEC613WPt8jdcmSIDNl1LawpV8t+alvey1z9LAg1jP7CwY2QNqsmJrtttbgaBYiXkPzD6Qh0DsuIKXSTuiGchRBWKWG/fmbQii4bF0q6yGAkAsizj++3lpScPGa35WHvUaEghBlSpH1cztvPaiU6k/YvfU9WYGvNCnY3yu1DUCbIEE7EbMi4i+9qgNW0/cnZChPkgDiZPd2TuOpSWA4Rb6Dr1bJ5FThgo2H4gdaHjmDE0Fg0gq9FQACw64xSmouR71/WaFzeArWqprq2HHQ3xCC+IKUZup1WCG8Jg9gmHtBKv4EpgPOB07UybbBgeI29g89PbuYTE5GDjROrH/jYXo4VZoG32fFrwD4PtbH30jogPTCPVHhfPW1Vg3P2ZgW14UtlaI0k06GBGjVMdjAMjz8GvttPcVrlKJVckh9NmIDpPOt0SKRWlSPH8Tf8coI0i6KijmJpcs3+f5VeowCCNqmNmsCXF9Tukox9txwwLiVyQf1uGKdZKg1lybd+WmzZ6sUw6XDadmhs5s4esMTmc8Hio5kDCJQ4sPFNCbCMN0iHdhj+bLXVOBl1H1Vg3Pmw7HtfxJvYHgz6xOQuBirAbaBmnCW2+IiY8ZRAorPrGwMGSiK31mDJVxTpwYB2IEifUfGmK0ca4QwK113q7gxGkuJ8lBTLWDfqUQtYPYuwEZCFIqMDTWdY9XUgAiWp4X5oOHxXM/CE0Cx+Eq9RKxs4YYEaq/dE5wgaFqb0RYplbUveDh2XBSQvWEjSyYG8idTrY2tvvfFghYQXaLtZDJXod/FsL
 J3alZk0h
 5WaBcrnFpy3kzClDfUcPrX98BZanKtVsig+Phg3EsicS9PnjWI9WsnBdVSSmu9+Kr7L2OjyUcsOPqPAjREUXBaGpc4b9OyLchQGYtzl0PSm+D44MwVpqn0gt0d/SG0zAnG9Drh+xzyhqY0uKSEvj3cWLbM3ICl5Wqfnoq8mZHXOROvF9ZpqYSfImkWp6Bz7sgZSfy4VfB3oA4cwzhpFwidz41AIIV2Cr7i+KhpHPxyl+n6rilV6DZ2HzdfKXwShkxol9ozaGmhrRQL/slLalEhvYXuJOG5QAJy8nt1SfZeN8ODLAEw3wNjIR3sNn3BLkdB03/B5zx26RwY2iefPj5cUWPHW+cX4rmOjb5AzhKXNlCFlqSiylxl9XrtRb+IgIlAeP65Ip1GHviyThjorYONdV/UmNB9pQGLCFMo3Q8PZNy7kRovN2UAMyKbnjGAxXfJMUtKYmBavUt6WvEzOsGSDZdgHFCjYd9uqw0KNj84b1a3qN+oZWiPaiO2PxOHDRB8q/Yr06q1lZTYUC2UFX/anRs9pM7yoDX8jF1TjXxMK6wLXW89S9Z2oXecxBHr2nN8l1fbMkUdPKkcElsv0FYjxPKd7EjPFUA5EFo9ZJdtD5nlKK+i8uSf6Vfej6FfMGJPERmIRFnmsmaSjc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] mm/shmem_luo: tail pages dropped on folio split in
  shmem_luo_retrieve_into()
- [Medium] mm/shmem_luo: race with khugepaged/MADV_COLLAPSE in
  shmem_luo_retrieve_into()
--

commit 780f293994f8e014ce055385564e7193d31d8556
Author: David Matlack <dmatlack@google.com>

mm/shmem_luo: Retrieve tmpfs files into a file created by userspace

This commit adds support for retrieving preserved tmpfs files into a
userspace-created file on a tmpfs mount via LIVEUPDATE_SESSION_RETRIEVE_FD,
and adds SHMEM_LUO_FLAG_TMPFS to distinguish tmpfs files from memfds.

> diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
> index bdf90aac5820f..7242664ee4aee 100644
> --- a/mm/shmem_luo.c
> +++ b/mm/shmem_luo.c
[ ... ]
> @@ -577,6 +603,86 @@ static int shmem_luo_restore_folios(struct file *fil=
e,
>  	return err;
>  }
> =20
> +/*
> + * Restore a preserved tmpfs file into the file that userspace passed in=
 the
> + * retrieve argument.
> + */
> +static int shmem_luo_retrieve_into(struct liveupdate_file_op_args *args,
> +				   struct shmem_luo_ser *ser)
> +{
> +	const struct liveupdate_shmem_retrieve_arg *arg =3D args->arg;
> +	struct inode *inode;
> +	struct file *file;
> +	int err;
> +
> +	if (!arg)
> +		return -EINVAL;
> +
> +	CLASS(fd, target)(arg->fd);
> +	if (fd_empty(target))
> +		return -EBADF;
> +
> +	file =3D fd_file(target);
> +	inode =3D file_inode(file);
> +
> +	/* Like the preserved file, the file must be on a tmpfs mount. */
> +	if (!shmem_file(file) || shmem_inode_on_internal_mount(inode))
> +		return -EINVAL;
> +
> +	if (!(file->f_mode & FMODE_WRITE))
> +		return -EBADF;
> +
> +	/* Fill the file like a write, which also takes these locks. */
> +	file_start_write(file);
> +	inode_lock(inode);
> +
> +	err =3D -EPERM;
> +	if (IS_IMMUTABLE(inode))
> +		goto unlock;
> +
> +	err =3D -EINVAL;
> +	if (i_size_read(inode) || !mapping_empty(inode->i_mapping))
> +		goto unlock;
> +
> +	err =3D liveupdate_claim_file(args, file);
> +	if (err)
> +		goto unlock;
> +
> +	err =3D file_modified(file);
> +	if (err)
> +		goto unclaim;
> +
> +	/* The preserved state is consumed from here on. */
> +	args->retryable =3D false;
> +
> +	/*
> +	 * The folios are past the end of the file until i_size is set below,
> +	 * so reads, page faults and memfd_pin_folios() don't see them, and
> +	 * they can be removed again if adding one fails.
> +	 */
> +	err =3D shmem_luo_restore_folios(file, ser);

[Severity: Medium]
Can khugepaged or MADV_COLLAPSE race with shmem_luo_restore_folios() if the
target tmpfs file is mmap()ed?

shmem_mmap_prepare() does not take inode_lock(inode), and
shmem_luo_retrieve_into() checks mapping_empty() but not mapping_mapped().
Unlike shmem_fallocate(), which leaves newly allocated folios beyond i_size=
 as
!uptodate, shmem_luo_retrieve_folios() marks each restored folio uptodate
before unlocking it on the LRU:

CPU0                                  CPU1
shmem_luo_retrieve_into()
  inode_lock(inode)
  args->retryable =3D false
  shmem_luo_restore_folios()
    shmem_luo_retrieve_folios()
      /* restores folio at index 0 */
      shmem_add_to_page_cache()
      folio_mark_uptodate(folio)
      folio_unlock(folio)
                                      madvise(..., MADV_COLLAPSE)
                                        ...
                                          collapse_file()
                                            /* sees uptodate folio at 0,
                                             * treats indices 1..511 as
                                             * holes without checking
                                             * i_size, installs 2M folio */
      /* restores folio at index 1 */
      shmem_add_to_page_cache()
        --> returns -EEXIST           <-- permanent retrieve failure

Neither collapse_file() nor try_collapse_pte_mapped_thp() acquires
inode_lock(inode) or checks i_size_read(inode) when a shmem folio is already
uptodate:

mm/khugepaged.c:collapse_file() {
    ...
			if (xa_is_value(folio) || !folio_test_uptodate(folio)) {
				xas_unlock_irq(&xas);
				/* swap in or instantiate fallocated page */
				if (shmem_get_folio(mapping->host, index, 0,
						&folio, SGP_NOALLOC)) {
					result =3D SCAN_FAIL;
					goto xa_unlocked;
				}
				/* drain lru cache to help folio_isolate_lru() */
				lru_add_drain();
			} else if (folio_trylock(folio)) {
    ...
}

In addition to causing shmem_add_to_page_cache() to fail with -EEXIST after
args->retryable is set to false, try_collapse_pte_mapped_thp() can install a
huge PMD into userspace page tables while i_size is still 0, exposing folios
before the retrieve finishes.

> +	if (err) {
> +		shmem_truncate_range(inode, 0, (uoff_t)-1);
> +		goto unclaim;
> +	}
> +
> +	i_size_write(inode, ser->size);

[Severity: Medium]
Can a folio split during shmem_luo_restore_folios() drop the tail pages of a
restored large folio because both i_size and SHMEM_I(inode)->fallocend are =
0?

shmem_luo_retrieve_folios() unlocks each restored folio and places it on the
LRU while subsequent iterations allocate XArray nodes and charge memcg and
quotas with GFP_HIGHUSER_MOVABLE and GFP_KERNEL. If page reclaim or migrati=
on
splits an already-inserted large folio before i_size_write() runs,
__folio_freeze_split_file() computes the EOF index from i_size and
shmem_fallocend():

mm/huge_memory.c:__folio_freeze_split_file() {
    ...
	end =3D DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
	if (shmem_mapping(mapping))
		end =3D shmem_fallocend(mapping->host, end);
    ...
}

Because both i_size and info->fallocend are 0, end is 0, so every split
sub-folio with new_folio->index >=3D 1 is treated as beyond EOF, removed fr=
om
mapping->i_pages, and freed, silently corrupting the retrieved file. Setting
SHMEM_I(inode)->fallocend before shmem_luo_restore_folios() (as
shmem_fallocate() does) would prevent splits from discarding pages past
i_size.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111002358.1842=
967-1-dmatlack@google.com?part=3D12

