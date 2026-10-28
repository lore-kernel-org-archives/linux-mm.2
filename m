Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55E15606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 10:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eBRAr6GD
Received: by kanga.kvack.org (Postfix)
	id 7A1156B05B0; Wed, 28 Oct 2026 06:52:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 751D76B05B2; Wed, 28 Oct 2026 06:52:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 640306B05B3; Wed, 28 Oct 2026 06:52:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 410096B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:52:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9081F1A0C07
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:52:01 +0000 (UTC)
X-FDA: 85371720042.25.F441077
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id D52BE1C0005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:51:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eBRAr6GD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793184720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7VuPLf/Bn8Nq23p16kdsfk/y2q2DGA/iZ/5CkjspwaQ=;
	b=26jSIOK6NnCyjcdpaWONmkhPVwwkRJ9z3ZMQoo7F96FjOgpNDQaHQSuz0dbkSagPswO1+v
	KiBi32OZWSckV+Wu93zTLdEXphhc/bqxPmSpHQitCzpzI+K+uvaaw1dV5Gh2w+oGLQ1y7h
	YBfjchPwtfpo/Yr63f+8o5s3SODXS84=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eBRAr6GD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793184720;
	b=vv71kiuWt/OfVUPdvpmNZtpNb8db/jxxEDrxCQziHqRBwYSKrHNnpOasX9BDerNUSN0fSW
	9LkaLWKCzyXtd1qUpQSUe82R4x7b9mGCXYEgd/Yq+0rIRbinDLd4IR5SPPzPAABzdYtLmY
	eIHfuEHdDEOoqIEsVOYUswA87UqMHM4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C95A943E05;
	Wed, 28 Oct 2026 10:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B691F01825;
	Wed, 28 Oct 2026 10:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793184718;
	bh=7VuPLf/Bn8Nq23p16kdsfk/y2q2DGA/iZ/5CkjspwaQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eBRAr6GDX4kET2Ek9hYjPmzPxEQW5sR6uvgI4atic8jFUwlYMWDd8wXV59vQEJmDv
	 AlVsHhjlRbPVmM+JsGl8xrOaYMa/vGAAwVCuT88dBN9QT0ocy0iENimUTCUqFwHUzd
	 ZJ/bOQ9MzSg0GY8P6RrZp/Tk7FT655/GKkGHxWGmC8FVsr3NEkAZxuLIuhYNKXJq7s
	 gtsGCJwJ0TMNg9xCqSlNtCcEP8zMBLGU0NmNcNK5ipdk004Tl8X/UpJrcNXB+ouHLi
	 z6snhbni4tuYid2Q8J+rBnNdQbMoCFWI3RPJyEfBuFFC6QvzlP9EPVA54/9BYhrquW
	 L6exRasHRYQtA==
Date: Wed, 28 Oct 2026 11:51:48 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Vladimir Davydov <vdavydov.dev@gmail.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Stevens <stevensd@chromium.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	William Kucharski <william.kucharski@oracle.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Eva Kurchatova <eva.kurchatova@virtuozzo.com>,
	stable@vger.kernel.org, Pedro Falcato <pfalcato@suse.de>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [PATCH v3 05/15] hugetlbfs: enforce F_SEAL_EXEC in setattr
Message-ID: <auHTxApiSnnlY1xt@localhost.localdomain>
References: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
 <20261028-fixes_shmem-v3-5-4ce3baf2db4b@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028-fixes_shmem-v3-5-4ce3baf2db4b@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D52BE1C0005
X-Stat-Signature: acrk1qbwc4foq5cdaw5ho1si6gdih798
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793184719-552051
X-HE-Meta: U2FsdGVkX1+A2/FOVUxy1Bg7cIe7PZfiWL8hZJPJq14K09xXgETFUxOm3/llvTlrJ5W7PaU/1lMwKWbt2qHt65UleGlJWiAbH/ynh5r+gN9J/DTDDKlNmTpn7AzVEHyfGCCx7V3xf0EWuu7MIxCGSfP5FXCR+fmayPZ1tDHQ25PxxmZTJJW+VMdoOUb9hp19ToQ3g5zEtnZHaLUd5EBGWfnQZBQXSOFnrgIm404Gndg74naFVY6lMMt9ZeTatoLAJd0rq3aVTbyiReMoeFDqfd4zvN1C6WiDixIoaVaJCI+m3D7BtIEIWy0qvztSNSAOoXf0cKgVuPbNTfJ2KnQKpj+LStg4obKqIw+zBRu+7EfopQ2yNE4oUt9tF5EBL7GeQK+ofBdYW1TqFVf9qjSQYTh5d+lQiwUNPehq9KXl7HNRkN4n39EsymX+fifpMvkkDk3Hyi5hx0LVEBqzn19eEloIE+uSl8A64jAJ7i9DgYT6I8qrFVcYKu3mUcL1Rq/uvAaHiLNCLUhv/NnOoo7IbUWDQbFvNV354GPVe8TLqPAW3Sz2lN52o8OXl5Z1aakVaV5XE+AJ/7HD5KS1NR8f1wVT2nEmt71p5+1bHD3uB/HpvTthjCSYNMYemOj6tK1o89B1hnxrjG4yaAOObD/Wbzaz0Ja6iTq7cazbfnlIOEm3S+tGDVE/a4J0EbP72xVqwfKhLh6zNlTtzeSOPqcJFOW4v+2XRETCmB7WZFw4iLUxVUj3naEkF/8V2qIeFrL1eUf8u70I1s/RbRjAoMQCB4sNUr3xaBhenWn03e42MnnGevYybVv78hNQK0Mr7Xfd3so0bUiDNaAM8LgilucENNoD7aJT7jyWw5wj9pvxwBdwLTnFcM8unDpiuZx8XHPJ4nSKzpNI7woOvTdR491NG2XyoZ8VEByZM+5L54Chi4/6BqhzAPoDkhb7a9aBtIzHAyq0MI75Ww1vlnVbcyI
 etRocyk5
 bfxLJyu7TL/d67Lzeb3G0p5HkyuqAmaNbVvxCAKcjNVlpa9TQpBUzshiVWyG5G3uEQlXMpMt5D8kmk9Oq43Wjrv+AXZh5OHFIpR4QvP12BO2OAqlnMRTZiCgimVN404rwHLc9PijKadCIIN+FD+oyy2UFgDuo8PH6qgB2LwEPOZzlkP1IFdeXlrEZKZ1C2gDEmmgRzpIxC4zgOod5N1gVNJn1p1Q77PQM/fxgj3/0H7tfg3ZalynrRnHX4AiFMaqY2X4hagN5CxtJ/zn4nqRmEj3fHgF8KMBHJScTzXXFR4x99bSs/rpdrBKyNJy0HBUmWHft8Fl8TOJxdeQKsBFZyWqZwdLkWnZIbKxzM/1gKVAF4TSVScIsJSPje+0JjC5jreCSAhG7Kl35dh6eLt0Zn2hddv/OUGLzjDGRK5cqWpviZ5KnxwOeigf2vNfelCWc001hd3FAam9Xo+fzqzet0CDIcAVxKPnyAIsW562KcPWcpTbFxojn1bgrCSo12O84+CfY0t+c/BrKWt/zzDMzTteDPmP2+rBAvaiArI+NS+TOwMe3Jw64f+WIpwsmnOmg727DDA90TUpXCPITiY9flCgRcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 10:55:03AM +0100, David Hildenbrand (Arm) wrote:
> From: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
> 
> F_SEAL_EXEC is enforced by shmem_setattr(), but hugetlbfs_setattr() does
> not check it. As a result, fchmod() can change the execute bits of a
> sealed hugetlbfs memfd.
> 
> Use memfd_check_seals_mode() in hugetlbfs_setattr() to reject changes
> to execute bits when F_SEAL_EXEC is set.
> 
> This also fixes the memfd_test hugetlbfs SEAL-EXEC subtest, where
> fchmod() incorrectly succeeded after applying F_SEAL_EXEC.
> 
> Fixes: 6fd7353829ca ("mm/memfd: add F_SEAL_EXEC")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
> Link: https://patch.msgid.link/20260629180247.2343229-1-eva.kurchatova@virtuozzo.com
> Acked-by: Pedro Falcato <pfalcato@suse.de>
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> [ david: use common helper; fixup Fixes:; check only regular files ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>

> ---
>  fs/hugetlbfs/inode.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 01c4d6f44ebe..02e0a65d596d 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -28,6 +28,7 @@
>  #include <linux/folio_batch.h>
>  #include <linux/fs_parser.h>
>  #include <linux/mman.h>
> +#include <linux/memfd.h>
>  #include <linux/slab.h>
>  #include <linux/dnotify.h>
>  #include <linux/statfs.h>
> @@ -840,6 +841,13 @@ static int hugetlbfs_setattr(const struct mnt_idmap *idmap,
>  	if (error)
>  		return error;
>  
> +	if (S_ISREG(inode->i_mode) && (ia_valid & ATTR_MODE)) {
> +		error = memfd_check_seals_mode(info->seals, inode->i_mode,
> +					       attr->ia_mode);
> +		if (error)
> +			return error;
> +	}
> +
>  	trace_hugetlbfs_setattr(inode, dentry, attr);
>  
>  	if (ia_valid & ATTR_SIZE) {
> 
> -- 
> 2.43.0
> 

-- 
Oscar Salvador
SUSE Labs

