Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C35F210ED669
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 12:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 105EF6B0092; Fri, 27 Mar 2026 08:29:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DDB26B0095; Fri, 27 Mar 2026 08:29:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01A4B6B0098; Fri, 27 Mar 2026 08:29:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DF1266B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:29:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82024E0836
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:29:15 +0000 (UTC)
X-FDA: 84591773070.04.C44ACE9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C79111C000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:29:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P8nvaAV2;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774614553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rLkzVIkip+1ZqEMckC8IpnK6lmfr5/498CmBrDAsrwY=;
	b=bGb6t1pj8Mpcnq85f1y9abqKO7XfAnhZ7XC8JJScowlVB+jT5ELJxacNUlRz1Cs65ggOoA
	uolaCFP86DERjks+l0dXAm8P4QfQlOAFRkaya/7XNYSIl+t37ir3seoQuahJIWYBLHA9MU
	m6rc2i0RPSR2hcehyEpb8TG1UL7t70E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P8nvaAV2;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774614553; a=rsa-sha256;
	cv=none;
	b=gKqueyjnDhRAp3XF9OG5bTZtRKjfSuR/kw97spEH82Q5WQ4Z0KjXcgzmCVbcLtqLnVc573
	wcSFeJFG9xMLQOw3OG+bDbs6fgfYEu+A77CKAz5iQpBkEwO+4zH+hGJwpoOuuxeYH+qBCm
	8gXWLOLlXVGTKA88qsC7QyqXRbH42Zw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BBBE140D95;
	Fri, 27 Mar 2026 12:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12598C19423;
	Fri, 27 Mar 2026 12:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774614552;
	bh=YgZDlPiJvemYo/gf8s9JAb+1AiSwXPvayCb368ynG4I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P8nvaAV26WoxCEiijKXxPz27X5f5WPVVmW50/Em6IcSbxbtwykC7Fq6FoJfjrvGnI
	 mdZ/cUzccp77GfiTBOa3d3PVBkLRkZg5AKjVFZqeDnL/O8QAen1YstfoUyKmYl7J7Q
	 KY82Qxxyf4i6TaQfHjikvgEUodvnNiCpAKHmWq5VjRJhchC5tLHP6gBukW6PTzKS8E
	 y5e6gNLo8ZoGnjGJjOEa12iHG9PVrzf84AKevXj5aoTqRMFRriJGQKol8WvKP4HXT6
	 7U2dnzTkl9gSGl59FU2c/W3e1eAbLDQAhnmfbFgYZFG1xAZuRR2z9ssCbwwbYQ9r0v
	 Yg9yUPFoVsrqw==
Date: Fri, 27 Mar 2026 12:29:10 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 04/10] fs: remove nr_thps from struct address_space
Message-ID: <f98087e1-311b-4b8c-bfff-230cfbdbace5@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-5-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-5-ziy@nvidia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C79111C000A
X-Stat-Signature: nqgw6by4entq5i7xx41caxieow9rr7g7
X-Rspamd-Server: rspam06
X-HE-Tag: 1774614553-434441
X-HE-Meta: U2FsdGVkX19TRUMGVH4yoOipxQdFwKLrQrthRG/Rv2JHq8m568de6yhwEQiNf4FuoaV9hrm6cwe/PcqI5gpaduZ1CeKgpcWZD2HGqiOwBUat2jFNPZnNLInJgkQp1Q1mRHsFD9SWnmzMQR+T0oNTsAv+2itU2wdtec8UaASeOw6o3KtCwHSs6+HC2YI7cNNNIGsXOlbw9lxh5Rhy9/nG7v11GymexaTmmKBxP2EC3l5fNLWCkWSWkA6hHRWbkc6Hq7bYNmZvu72CidxASFYUIuxPw7H27BOEB3O1KKgCTiefx8cWfp05FE8OytYJxReqCINQYCF8vqLYsGnc5xctNzfyoyzKxaCRVJOCiDgvaXUCEiRYnlMB01hZ2xjh3xz1NuvKcaCza9WpcPQTzrP4vGi6nSYFol7Nxghi7eSRSowGqUA42uwSg+7W4a4q5gAd37Tx8/OT/wOuoETvq5sMWPdYb7F3OoroL34iHDt6358gxdMCjmfxUe9Zx6qMCvd3GCYZ3ocRM5b2nf901C2IsjCwL7omXACp2nUnoeJmXd5IaUWs95y5niNRXgIpA160U54/uOW/K/tzJgmDDpU5hFh8AbgJvDkPQhGcOugAinTh/HHSKRZIDz1s9tbzehhhh0lZ1abcOBtHs/zIxrZucuXHzT56bKUo6y3OA4iTliMmH/T38Z2vVNPmNiGIhKoMr3VNLFCVzDItgz/WQgLUW542TBBsCU27ckT5pJi4jFOFfVz/Uaeq/9z1M52AZ9dkxYKTAtwiJM6gSO6gg9wJLycjoSuVcOMNeKdnUKXvhy0lAAbcddQTiyIK6JZDSWsSYn/FHXHCfVXEJrU+2A+Zh0GJY83E7JK4f0w6zgnBdTNejwUJIgS+j62ETcYcpqXZj7EEeleoLFxdMKWIRww99itGHbqWCgvi41oFuOkoqDAHshtbRc35DlQEGXkrte6tXzBOi3Eltf8JE27J45I
 XnxqGm06
 SmixNbat/jMrGJE/8IlbgvgE09PaqMVcV6y2Y1hyav8dnAfzqbor3i4GeXT4GMp0Bhh9W6/AotgB8PQRG+YtuCRuP2xp9pBKdStzLmxL5rj5CUslHShAL+SuVCdx9ZB8rvKPc/qETJ6DqfJVd4NIozOidj29tVTrw4OpW0HKnqm3Piy6qQgfqZM+qT1lxZ2tW9Ij7bq9lM7MHCw+UimZ+/L9SsHy9ESeHlzBfNIoQnRXzmF0+LMSh1AaA+jA8QAFngmK0uhtfUv+66QQ34yPDNDJuLfkT3WC2pWzFZz2d58eNM2r00Me1FX9wQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 09:42:49PM -0400, Zi Yan wrote:
> filemap_nr_thps*() are removed, the related field, address_space->nr_thps,
> is no longer needed. Remove it.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

I wonder if we shouldn't squash this into previous actually, but it's fine
either way, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  fs/inode.c         | 3 ---
>  include/linux/fs.h | 5 -----
>  2 files changed, 8 deletions(-)
>
> diff --git a/fs/inode.c b/fs/inode.c
> index cc12b68e021b..16ab0a345419 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -280,9 +280,6 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
>  	mapping->flags = 0;
>  	mapping->wb_err = 0;
>  	atomic_set(&mapping->i_mmap_writable, 0);
> -#ifdef CONFIG_READ_ONLY_THP_FOR_FS
> -	atomic_set(&mapping->nr_thps, 0);
> -#endif
>  	mapping_set_gfp_mask(mapping, GFP_HIGHUSER_MOVABLE);
>  	mapping->i_private_data = NULL;
>  	mapping->writeback_index = 0;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 0bdccfa70b44..35875696fb4c 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -455,7 +455,6 @@ extern const struct address_space_operations empty_aops;
>   *   memory mappings.
>   * @gfp_mask: Memory allocation flags to use for allocating pages.
>   * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
> - * @nr_thps: Number of THPs in the pagecache (non-shmem only).
>   * @i_mmap: Tree of private and shared mappings.
>   * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
>   * @nrpages: Number of page entries, protected by the i_pages lock.
> @@ -473,10 +472,6 @@ struct address_space {
>  	struct rw_semaphore	invalidate_lock;
>  	gfp_t			gfp_mask;
>  	atomic_t		i_mmap_writable;
> -#ifdef CONFIG_READ_ONLY_THP_FOR_FS
> -	/* number of thp, only for non-shmem files */
> -	atomic_t		nr_thps;
> -#endif
>  	struct rb_root_cached	i_mmap;
>  	unsigned long		nrpages;
>  	pgoff_t			writeback_index;
> --
> 2.43.0
>

