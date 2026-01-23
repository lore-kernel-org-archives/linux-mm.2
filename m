Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E59AD72348
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 07:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 766F06B0426; Fri, 23 Jan 2026 02:46:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 732DA6B0427; Fri, 23 Jan 2026 02:46:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6077A6B0429; Fri, 23 Jan 2026 02:46:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FC866B0425
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 02:46:57 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB4A01A038F
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:46:56 +0000 (UTC)
X-FDA: 84362447232.25.7BFB8A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id BC470180002;
	Fri, 23 Jan 2026 07:46:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gKjzE7cq;
	spf=pass (imf16.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769154415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dn3robGukUhTOXOalWLulDq01xpYbk4pZ/CZENXym0o=;
	b=zc3yjgt149fdfwrGJ44N1sb5f0HVyHOEsUTxM3pGR71PcAHXLvbhNShhrC8FyVuG6UnWEa
	V6F+BoMHh+svI4cH28YwxUKmbfwBhFP9rIu96FqBdMjVz/IJElh691CFTRKvz1Qjlam7+R
	NBWJMhHeV60cw5T8L6v56AzgU5bt8yE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gKjzE7cq;
	spf=pass (imf16.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769154415; a=rsa-sha256;
	cv=none;
	b=xMdfuifdhTmYkA+jTvn0kUBANMNbnp+QB5DJWAlkBSNl8rWJaoBPPliWIME59FgxerR4XS
	hd6PfpjLd7R1IqiNbZ6AeUVMO38pwfDuFw2ZiL2KS0AlaLCKyYWzIXKaVEslna5STIkBAm
	pC5nxjcovRoPl4wRJY+He2lzK4evw5Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5847842B6E;
	Fri, 23 Jan 2026 07:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD45C4CEF1;
	Fri, 23 Jan 2026 07:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769154413;
	bh=OAD/ygUEOD88K+ggqyDG4ngV41XfzkifYu+rUan4UmY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gKjzE7cqDXZweQuGHrMLnfOMSZf3lh7HGxajgtU/lt8kCe+JBtiVTH7cLgHlNYZDq
	 /xkI+t4I2UXrUC62zmbj0vZUsBgJVNWHf2u/IB5rVWQ0M92qWVFNAn+aHpwjmatIJJ
	 42HGEvas39c7oPcKIUvmKiwxdWG6F7op09dvqSnaEPXJxDYV8uNaZg5zuYpCGbPOV2
	 uECZnk5jJ2EcGxljpENkS6fEZ1z6XTrmkHHGu/DMNaJHL0zQj3FpdgRCKBYhPwGr8Q
	 PcpeqEt3bPSuwM7nEePid0sJHAvbYps2rpINdGvyHw/B3l0OhLkXuPNse9MoBWxRVu
	 vChCTt8SYWz8g==
Date: Thu, 22 Jan 2026 23:46:52 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Benjamin LaHaise <bcrl@kvack.org>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dave Martin <Dave.Martin@arm.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	David Howells <dhowells@redhat.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
	linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
	linux-mm@kvack.org, ntfs3@lists.linux.dev, devel@lists.orangefs.org,
	linux-xfs@vger.kernel.org, keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v2 08/13] mm: update shmem_[kernel]_file_*() functions to
 use vma_flags_t
Message-ID: <20260123074652.GW5945@frogsfrogsfrogs>
References: <cover.1769097829.git.lorenzo.stoakes@oracle.com>
 <736febd280eb484d79cef5cf55b8a6f79ad832d2.1769097829.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <736febd280eb484d79cef5cf55b8a6f79ad832d2.1769097829.git.lorenzo.stoakes@oracle.com>
X-Stat-Signature: e3tga4ps1nhz6eepf5m7k9rzo6inweo8
X-Rspamd-Queue-Id: BC470180002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769154414-382117
X-HE-Meta: U2FsdGVkX18PDx9wl99EmJQxYBzE3qPDUd4v29eYglEgItN+FET7f0irwB45WroCvoClRvO4+PeoZlfhQinWca2LNArbxOyNRJWYTLEkoLLJeueymRq8x09bIV4sKF1yqBd6OktkRTFIX8B/750J9DjQW5UZXLSgzGmphI0wGyBPLNQFLRQjFR0E927Bkvxv7bOd/1OJYxL78+ZGDwr2FLLVAhw2wmP9RYPJMS/BOHtyMqb39VeRWzrq5c2XK9FF4e0NrNsEVLrqLSyoy50D1K+gOVkGx25/Dgl0juWMqidOuIr4OwTlxGyF3mC/RTUwS/UyDs1+PT+MvB6RoRC1Wp3gmMIiCV9OL1rEiFOcnCnewu1rK0qwy+4/fnuJe0/7yZDHhbTC2TMkTgRNr6jJwTemYWaBtoS2qsNAhvdY1QGlAMeDTg2uoQCLzisIeys8DU6j/zZ3t6n8tDvTMWHuZSGRI2Aiam02If9b3pRe5hNYhH8xM5517S3b7snrEx5cJP8JF0WXwan1e1DCyYG4DTRpJK+p62+h5ZrnZRHBAb4yKb/J+hcFsK21px2Dr0RlJWsPXPco/UHtFNPXUP2Af2mHeO7cR56GTQ+gNK8gQmSAor695Dv+emPfWiSXUF6fmw5GPTUjSKSWatGyQe84Kf2XUnIer8R4LAF5PS/VLgMyWtPDpr3+wlh6RckR4RbWD8QhZ+DnX/jSuH6pMxP0QrscRL4iQSDzd2WNW2V+ECVrZON5iN+X6fgfvT/7rjsqqkrhF1AqljpX2C0iZgdnrLvUmluhBrjabX/wgVXrnGxwgcQSp7uU0lKFisMaGcHAoXRZkOclSIPnEZRjJAVyC3y0Yy3SIdnM7nHSPekVfI+Cg7pNQJPpRySgu15Cko9+uQhsmbOQNb8/h+ImW0iDODAid19T8bU488Zxbjy3QNlgP2oPWqygPPhfv1t4iKr9fsCXYzM1afXq9SRse4W
 1YsLS6v5
 hAjIA761M7Bn918pqL5JYyHOjL9obde0WKG+z5OhROhF54kV9NOx/rTuqkuYAeCQJIniyLgF++AXDvTg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 04:06:17PM +0000, Lorenzo Stoakes wrote:
> In order to be able to use only vma_flags_t in vm_area_desc we must adjust
> shmem file setup functions to operate in terms of vma_flags_t rather than
> vm_flags_t.
> 
> This patch makes this change and updates all callers to use the new
> functions.
> 
> No functional changes intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  arch/x86/kernel/cpu/sgx/ioctl.c           |  2 +-
>  drivers/gpu/drm/drm_gem.c                 |  5 +-
>  drivers/gpu/drm/i915/gem/i915_gem_shmem.c |  2 +-
>  drivers/gpu/drm/i915/gem/i915_gem_ttm.c   |  3 +-
>  drivers/gpu/drm/i915/gt/shmem_utils.c     |  3 +-
>  drivers/gpu/drm/ttm/tests/ttm_tt_test.c   |  2 +-
>  drivers/gpu/drm/ttm/ttm_backup.c          |  3 +-
>  drivers/gpu/drm/ttm/ttm_tt.c              |  2 +-
>  fs/xfs/scrub/xfile.c                      |  3 +-
>  fs/xfs/xfs_buf_mem.c                      |  2 +-
>  include/linux/shmem_fs.h                  |  8 ++-
>  ipc/shm.c                                 |  6 +--
>  mm/memfd.c                                |  2 +-
>  mm/memfd_luo.c                            |  2 +-
>  mm/shmem.c                                | 59 +++++++++++++----------
>  security/keys/big_key.c                   |  2 +-
>  16 files changed, 57 insertions(+), 49 deletions(-)
> 

<snip to xfs>

> diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> index c753c79df203..fe0584a39f16 100644
> --- a/fs/xfs/scrub/xfile.c
> +++ b/fs/xfs/scrub/xfile.c
> @@ -61,7 +61,8 @@ xfile_create(
>  	if (!xf)
>  		return -ENOMEM;
>  
> -	xf->file = shmem_kernel_file_setup(description, isize, VM_NORESERVE);
> +	xf->file = shmem_kernel_file_setup(description, isize,
> +					   mk_vma_flags(VMA_NORESERVE_BIT));

Seems fine, macro sorcery aside...

>  	if (IS_ERR(xf->file)) {
>  		error = PTR_ERR(xf->file);
>  		goto out_xfile;
> diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
> index dcbfa274e06d..fd6f0a5bc0ea 100644
> --- a/fs/xfs/xfs_buf_mem.c
> +++ b/fs/xfs/xfs_buf_mem.c
> @@ -62,7 +62,7 @@ xmbuf_alloc(
>  	if (!btp)
>  		return -ENOMEM;
>  
> -	file = shmem_kernel_file_setup(descr, 0, 0);
> +	file = shmem_kernel_file_setup(descr, 0, EMPTY_VMA_FLAGS);

...but does mk_vma_flags() produce the same result?

--D

>  	if (IS_ERR(file)) {
>  		error = PTR_ERR(file);
>  		goto out_free_btp;

