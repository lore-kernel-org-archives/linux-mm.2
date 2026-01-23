Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15899D72347
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 07:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D71F6B042C; Fri, 23 Jan 2026 02:47:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55DAA6B042B; Fri, 23 Jan 2026 02:47:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E0176B042B; Fri, 23 Jan 2026 02:47:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 27BD86B0428
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 02:47:53 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD90B8B859
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:47:52 +0000 (UTC)
X-FDA: 84362449584.02.505413F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id A1BB8A000A;
	Fri, 23 Jan 2026 07:47:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dhz6ArAn;
	spf=pass (imf15.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769154471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d7Cved2U0cx1Ah0GRYbOwiLnpALcJilpWIO4L1x9IxU=;
	b=vsoHRBkrRnlDtug9+2awLL03Ce5qP52w19mFiMWpBR0Oxh1IulaHuvloIH+8rs182i4Htd
	05H2iNDLud3UYdn3+1fkSzXcU+F/aXetR1inIOM+HGa1+rr3cDZKothHyebwX9/IYpHq21
	hvS/RUluIOBsfT8RJS/KUcvAR5+H4aY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dhz6ArAn;
	spf=pass (imf15.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769154471; a=rsa-sha256;
	cv=none;
	b=BBYkvDvJs7hAj+aFcaNAuO43pDa8etaGdDd7Rq2wIxEJRSQlGMkKy4i8ACCnHa+sCZLhoR
	98JQEZP/OK1mHVLXL3ASSrlOZYrz90v7tU6LcIS+GiNwiR8aEBYri4iPKpqj1K7ofkrZis
	h+JlcgNFGU8h63FiIFpQDBZIPapjJI4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F53D443C6;
	Fri, 23 Jan 2026 07:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6FAC2BC86;
	Fri, 23 Jan 2026 07:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769154469;
	bh=qZcCh8YaN75BaHxJI3n8DUClBttDVVefL2TarE8x2cs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dhz6ArAnF4mrMgD2V9gaW0IOdAyt0UWHdcwmUQgrPBIWvnoaDzJtzmzMJxVck5gv+
	 zEZgJOeFD/IJQzx2Up99SCKmemnDSbXrWZlm1SAK7ny61M8KuplDc84jbfdlgQwQR6
	 +8Rb9fJ2j1Dh4UnsHETHjtBawHKcytU2E3ai7JjVMGK0KGDMhhcMz8n/3MAGSNlsTJ
	 lel+3wVzQK3+jEYSZdvY/T5wo14jtYZ5i4jErLaZOvUngMzlLTTOeS1t4am1xi1tfP
	 GskVtQYN+cTM93xV5bjb1azN9mPAsYErt+ynoEzLMYagl5talCo4C2ogUWa2ojcK07
	 lGuDTmdB4UMCw==
Date: Thu, 22 Jan 2026 23:47:48 -0800
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
Subject: Re: [PATCH v2 09/13] mm: update all remaining mmap_prepare users to
 use vma_flags_t
Message-ID: <20260123074748.GX5945@frogsfrogsfrogs>
References: <cover.1769097829.git.lorenzo.stoakes@oracle.com>
 <fb1f55323799f09fe6a36865b31550c9ec67c225.1769097829.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb1f55323799f09fe6a36865b31550c9ec67c225.1769097829.git.lorenzo.stoakes@oracle.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: A1BB8A000A
X-Rspamd-Server: rspam07
X-Stat-Signature: nug9w7sjfcozc375iueu3bc9ng9pdja6
X-HE-Tag: 1769154470-664993
X-HE-Meta: U2FsdGVkX1+iB9e+Vb4dD4QnDBCpGDN/2fGmw3l4yJj/wPzpJi5DInhGYyyiYJuNvpfM3E09MIqaVfNEPBFf+u4LuOP6Ku1FX2GfnkaaXbRrt8u7LE0vTCVTuMkxkQLC168gS0KoCg74mzFGskrL39VvI4qlcsX+qJ9ArT+6vHnUetttWcus1zNlLm/L8e1H9pOyTeV061QANXeFk61PzdpeHbWGaWZlxIU/DSYgTJZmp4UZOMZwUxBfixFbzoEAO+icFCSUHTQ687KvZRurlAqQ4n2PpNSIAmatvlsrnyxDwHEA9FnJCNxcmgb6OqCbV25y+o31JwyNTnWSBxw608nEe2Jh7mqBwAUdTK58AFrz5cQIq6bdM2NgSF2lS7O0cDCkpUTjwmr5DwwWdWgj8GBFVIDx7N/Uhsdbu1M8TQIfp8pBC4l2eCfrwurr3I1KksH0jyA61MnEVss90Ks1SLSvt0k4rIgr+agqWbVkHER60Mlmi9u+Q3FuZ0hPL4+xORNKL+y8C7DTRqsGqkqUYFHQDLkTrqlXbRxvYvl/pcKNlw4M+qPHbuMxStIObKoTVg6x+13yXKoLEGQlYsT9oXCIf7lPTx1hHS5QsFF8hntHArBhgrmh59tBKfrgR6V41WvKKY3lbweSo5xQS1Ub3fADdy+Q4v8Cxe6edCXqbSr/EcKFTgepN/msg8VBjTu+cBLU5eMgJntem4JDvvqQjrJjUTdIg2gyfobP2dyuo4ufS9Y68o/ObuNHtrOs10jlgll/yiuzVGpG97RjtchfGSnw9hd4pNuzESRQJ93NulUaC/dGO298ZAb3e1IOPSMSfLT77mLCvYOpRuulbekDJ5KcwZ/n0AMJUbSM8u0qOXHszEZTVbog1KpEWZ5DvszZ41BU19x/5J6GtJLeUXiBfvDSv7glJCef9/kL1gOOp1+SO8A5I/a1hwzhLYCVdP7gh5Sds8MBSBBhGis5tNt
 98jjY2Rt
 84oZl7W/eMgA1mPx1otVJeMc6wx7N0haC1tticDI01updmoVSINFs/PByOqAtswWz1bjarhBk/I2kftD4ixF8//XtEVbJUb3j8zAXY+vkFH5gWJmgNbvfrQXIv7uDYOpoWpO/NpUe6pmxBTSFUxtYfIiDvh2r4l01cemcUt1S/JRQRFW0lY/YXGgMX+jIqr3OFjXf6/LqBTWfbiby/gHuJCV6JbiF8px79yjAhLeJ9ZcW7TADJBGK2qs8+7de9G76rmMmBVU6YezhXMhcyWKRgSAKHqo6HVr97L/3fz8JeYKHeer1C0rgV5t4GuoO3o7Ir4MMdvDjNhecnNEUsecMWbPiweV17PojScf/gDL8f+SI+BkFGSJNe6BHAOG1a0ccochoG9z1MvPR8tKGnT7ucV8lJ/Wbci/eKaMpN0iZ9AJxBLuqI4+Mz+kJ32r6LSLutEvg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 04:06:18PM +0000, Lorenzo Stoakes wrote:
> We will be shortly removing the vm_flags_t field from vm_area_desc so we
> need to update all mmap_prepare users to only use the dessc->vma_flags
> field.
> 
> This patch achieves that and makes all ancillary changes required to make
> this possible.
> 
> This lays the groundwork for future work to eliminate the use of vm_flags_t
> in vm_area_desc altogether and more broadly throughout the kernel.
> 
> While we're here, we take the opportunity to replace VM_REMAP_FLAGS with
> VMA_REMAP_FLAGS, the vma_flags_t equivalent.
> 
> No functional changes intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  drivers/char/mem.c       |  6 +++---
>  drivers/dax/device.c     | 10 +++++-----
>  fs/aio.c                 |  2 +-
>  fs/erofs/data.c          |  5 +++--
>  fs/ext4/file.c           |  4 ++--
>  fs/ntfs3/file.c          |  2 +-
>  fs/orangefs/file.c       |  4 ++--
>  fs/ramfs/file-nommu.c    |  2 +-
>  fs/resctrl/pseudo_lock.c |  2 +-
>  fs/romfs/mmap-nommu.c    |  2 +-
>  fs/xfs/xfs_file.c        |  4 ++--
>  fs/zonefs/file.c         |  3 ++-
>  include/linux/dax.h      |  8 ++++----
>  include/linux/mm.h       | 24 +++++++++++++++++++-----
>  kernel/relay.c           |  2 +-
>  mm/memory.c              | 17 ++++++++---------
>  16 files changed, 56 insertions(+), 41 deletions(-)
> 

<snip to xfs>

> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 7874cf745af3..1238ec018bc7 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1974,14 +1974,14 @@ xfs_file_mmap_prepare(
>  	 * We don't support synchronous mappings for non-DAX files and
>  	 * for DAX files if underneath dax_device is not synchronous.
>  	 */
> -	if (!daxdev_mapping_supported(desc->vm_flags, file_inode(file),
> +	if (!daxdev_mapping_supported(desc, file_inode(file),
>  				      target->bt_daxdev))
>  		return -EOPNOTSUPP;
>  
>  	file_accessed(file);
>  	desc->vm_ops = &xfs_file_vm_ops;
>  	if (IS_DAX(inode))
> -		desc->vm_flags |= VM_HUGEPAGE;
> +		vma_desc_set_flags(desc, VMA_HUGEPAGE_BIT);

Looks good to me,
Acked-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  	return 0;
>  }
>  

