Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67EC3F54AC4
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 14:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2A7D6B0088; Tue, 24 Mar 2026 10:26:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDAB86B0089; Tue, 24 Mar 2026 10:26:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9D66B008C; Tue, 24 Mar 2026 10:26:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A90F96B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:26:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5559F1A01C9
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:26:41 +0000 (UTC)
X-FDA: 84581182602.13.E57E3D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 58BB018001C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:26:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jHLE0f+j;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774362399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AeIMwnpCpoiD5fGpSnB45qpF4v0gCaiBfK0wYD8z7WQ=;
	b=RmmZuhU7QQnEKWRYxT5QVLqQhLzhFHRnGCL081iXyDZwiGFJTxwYP4Un5njbD7Du7ysgao
	xyF6Jm/pqVIl4mVfQuGhpSPhMpR3WFqL5l5EaGKZlV4YfV24+O4afEJ1pvz7meEvjU1i2g
	mMTgspU37JJvj2vFstmhcg78PLpYHFk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jHLE0f+j;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774362399; a=rsa-sha256;
	cv=none;
	b=pPzh0EUi6tPJ8Vknf9KwNa0HS1rbdHfDGB8MfyKwNOAwI5ShIglI2LAUNu+KNC/CZ6I54u
	7YHMei0tbXRx8uGFyIa2FGWkS6EQkY9h4smVC9tV6HE89JOKbTxIKjbGfpu0sge1blROSb
	0nN5mBP3AEb5melHldZC6PwhMtNy6ew=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1748040207;
	Tue, 24 Mar 2026 14:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF10FC19424;
	Tue, 24 Mar 2026 14:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774362397;
	bh=jbmeTUiHgD1/BUVa6y6/L4uBWdzAaIyEnuCWg6Aqqwk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jHLE0f+jKQrZNp687YBoBRWvKqV1yWHDJoeSVdPwmNvSWECrmPXDTbAi2oKjk+1NJ
	 qnx4cHZLM+LIL/EoJtJgr2egOHXEYl3PmIEgTgWfctCXapgNTUzCU72gmELiYyBz2u
	 Bmagz4Dqlv/xXZnYGIqOcn/VE+9HcIDQca+kSTZwU2EdFdYDcSCQi3OsySsDqMWMEj
	 xJBl1+rl8ONOJYI/rFp2Q6/AgAT6Ooo3EbuSldP/+bCHPCgnXfLdZYk7zRnOoBztke
	 5D4hhUKhkSo5DjVR7YkZzeoY/AhHGi4yeVpH65JJi5N0Pl6nFAlDHXYhnAvm2OMXP/
	 QLKTQd8HLcvhQ==
Message-ID: <d5b66671-697f-4a4d-8039-d9c9ac5ad4d7@kernel.org>
Date: Tue, 24 Mar 2026 15:26:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/21] mm: switch the rmap lock held option off in
 compat layer
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Bodo Stroesser <bostroesser@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
 linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <cover.1774045440.git.ljs@kernel.org>
 <dda74230d26a1fcd79a3efab61fa4101dd1cac64.1774045440.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <dda74230d26a1fcd79a3efab61fa4101dd1cac64.1774045440.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 58BB018001C
X-Stat-Signature: yyd76c3omaknxrhunkmbrxz4sghioz4q
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774362399-657643
X-HE-Meta: U2FsdGVkX19MJb+JoqrNcFOJyfTou+vMl+YCKGGCbF4cLt3i5HqiJOU0l/6Og3QMMXuODBp2TCwJfSInZTr715fAG/SYwYvlbxtFeMd6d17W/ExJGwRIPD2Ei8DAbxvxBTe4So9SVgNLKXuXh4LFbynRfQJDjqXxGfUO5pkV0T0laRRU7U461PFb8KtH1iUNZ1SrrdlwK2yTkEigmn+xQyy3ctlMgfdKP8k+zEbEe7MPqZhFz411kgpzo8OXoZ/VPwPVdpAnYT2elpmJWk0U90ORoZ1IAKqSyiWB4lkKR15OxbKOCUqsQAQMc5VJWL/a41QVwTNaQt8iKfPeGANdPnkn/SOd3x8DmEJAF4EuQN7mSJbsz1iVGxBLzCuaDEvovpGEzNbZriTKdhLHgb/QgGVy64kLI9/Rayj4c2XQkh1kz3F5ejUWcewN2wsPID5E1ZbRlfgyLQVUbwduOwQ7XDaQazPAfyyyZ7qJbgM4E+LfM5J2UfrU6kGJnFUDMn3WnUPTJI7Il+oNY5/b3RM0q0IXTZuuGT9Phh/KuP/y5LpGCva9hT8PP9YkQ78cruvwtezaFKznZ6mKF8EFr9XZYIlKmJTz2YrzKSTgPjNkyJhkS/B6m2aqwtoUanEkK0395063CPuEA381tIa85Z2BjaKgrMLMZq79a9SJpN2BqdT6uK0zj0w//hn6/SMMjMrekNiZuNeZ5iPnMO/7FsdBfDr9MVRx7SNEtN6G7oWBVNf3iVMFEIDU0/PL8yvffWA30QARXSbRB7Z42Q2g9644olgAX6RosnevdhWjX3VcEt4agk6+R8EFZ/87pgqVi7QMN5PKZlNza4u5fQ+pdF85D7w+QG8dCIGAp6P7rXaQ2U7/ejiMs+9g5iqHSyUWkfnCj1DcAS/YlOWH+18hAyYoJ9WE3L8pligA9ecDUrvJJ5Oj3DaCvCcV+RbP+hgTkqYCCjC+/VJOgEG9jPCB5iV
 RZIqMh46
 YEZFDIQ0MGrTJTvTsAN8wPyxlCi+kJtGrKu6tyE4iV7TnABGF5bblLH0/vNFtGMYndiHoZGmbW1A5Fakd5UVHbKVN309VBAT8z5QEgjmm242lctpIs2K1ccfiUkEWfnfvgMMNm6Lr9V9+AFghuMderGoQKoArI5LQ2aHo0NG4ELfptfcc26Bza8O+LciFYXcuig1bTcnjLMYLrfA1EavryCgNoEFsJSrXEBWqoqtH3j6b3yYnq9/A+5s1HZJ8wDwIOHDZuU5rhXvSws/c5eqVacPuO8qX5lYcdnv9mJaSlZSSPLw/w1LsTDI8uiUKpQr7QgjJoXNX6Zlw5v0DGSgcbtfkbUNC3r1LDhsN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 23:39, Lorenzo Stoakes (Oracle) wrote:
> In the mmap_prepare compatibility layer, we don't need to hold the rmap
> lock, as we are being called from an .mmap handler.
> 
> The .mmap_prepare hook, when invoked in the VMA logic, is called prior to
> the VMA being instantiated, but the completion hook is called after the VMA
> is linked into the maple tree, meaning rmap walkers can reach it.
> 
> The mmap hook does not link the VMA into the tree, so this cannot happen.
> 
> Therefore it's safe to simply disable this in the mmap_prepare
> compatibility layer.
> 
> Also update VMA tests code to reflect current compatibility layer state.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

a typo fix below, Andrew can fix locally?

> ---
>  mm/util.c                       |  6 ++++-
>  tools/testing/vma/include/dup.h | 42 +++++++++++++++++----------------
>  2 files changed, 27 insertions(+), 21 deletions(-)
> 
> diff --git a/mm/util.c b/mm/util.c
> index a2cfa0d77c35..182f0f5cc400 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1204,6 +1204,7 @@ int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
> 
>  		.action.type = MMAP_NOTHING, /* Default */
>  	};
> +	struct mmap_action *action = &desc.action;
>  	int err;
> 
>  	err = vfs_mmap_prepare(file, &desc);
> @@ -1214,8 +1215,11 @@ int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
>  	if (err)
>  		return err;
> 
> +	/* being invoked from .mmmap means we don't have to enforce this. */

				.mmap

> +	action->hide_from_rmap_until_complete = false;
> +
>  	set_vma_from_desc(vma, &desc);
> -	err = mmap_action_complete(vma, &desc.action);
> +	err = mmap_action_complete(vma, action);
>  	if (err) {
>  		const size_t len = vma_pages(vma) << PAGE_SHIFT;
> 

