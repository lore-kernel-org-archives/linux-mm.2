Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52B9E606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Z5cypXbt
Received: by kanga.kvack.org (Postfix)
	id DF6CA6B05B1; Wed, 11 Nov 2026 12:47:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA83A6B05B2; Wed, 11 Nov 2026 12:47:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9A646B05B3; Wed, 11 Nov 2026 12:47:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4E366B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:47:17 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A540DA7EA8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:47:15 +0000 (UTC)
X-FDA: 85423569630.01.EB58484
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf31.hostedemail.com (Postfix) with ESMTP id AD17220005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:47:13 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Z5cypXbt;
	spf=pass (imf31.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0MglZ2+4MgA6qoVKrAGxsEiMN/rG/VnPk4yp/O82FwA=;
	b=qkCyzpdukzgqxX7YE+x6wLWZTgOcaOC0BeJsfC+yqkX9g9ctS63TDMJSZkv3ZFsMW1M5MF
	cYatHeB+SpyNdRvNnxZO2T93a6/+8OeSMNa9DHGNW4uE6x3H56FA2M2ly6rKYT5deYtyrX
	Vy8prqzipZfbeuq6s/HzWoIXwekI8n4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794419233;
	b=22o3cEQk6BTHGIa84azUjhOBLXRWdxypin3DDL2zHyoq1uXuAV4qzNoBPrvhBk859acx6w
	hCMifMc7abyEYxFIW61Pk/iLLtANLlYB9tmS71fziKfLMJAr8EqAvHtL1FH97kG8ka1RkH
	w7ctyxmBe2BWFromWGiJGwcFLwllZbU=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Z5cypXbt;
	spf=pass (imf31.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a018493d57so46435e9.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:47:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794419232; cv=none;
        d=google.com; s=arc-20260327;
        b=ndJZSLpFOiVsENVrgMcv50KsffbNAdcuYfv3CRJM/vrQb7Uzp2Sh/JTbiYoT6nXd0Y
         ZGLCb+XFy/qxrJNQSvB3wySchu/5sslniXu94QIZI9NabUxQaIiWsGQ3MlKnjEILtp3x
         HfkGyC7TqaRz9YvPwOj/Vo/wqx5bdA7QUWoUnYDZmMLv8Chz+P1+XmkeN5rdceC/HIz6
         YW1fVIneHueJ9BZxT7skZu3uAHDYVYzQbclAaQg/f3u6swODkjoaD7HIx2m0XZikQT/T
         TF/PfdgfzSI7Iw5xjHUQfduTIP4jn2pHJpazW7w6MeGqA5IbLNGZXU1GoUnhPjZ7p2K0
         9N+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0MglZ2+4MgA6qoVKrAGxsEiMN/rG/VnPk4yp/O82FwA=;
        fh=GSutFly5XsALygaKkZjFbwdZLuR+fooc/qh5DKp4Q0A=;
        b=Jk64/5XgmGv2EpxgJnl64QvU1s/BL/OIXb4XOeBer6xo3dPNpaA8PrDebYmmeN1x6u
         XNoSKm2O2L5/iZpFISeU1vR0YweUwDe9I2jNr6D1HeQrBRBhQMO8xDCloGmlfzww+Sag
         8nSc7c8NyLrXMDq/8HMAgXJeAUi51wGFLymdJ4NE8qgQ0pmSo0Zn7RLKE/mpZXGA8O5b
         1kC406BsTYSG8nmQ0EyXgLiQ9CrUvmA2uOxw5y8sBQd+fmQ0ent5ZEapUTGm4Ih3kpb2
         kni88YVgdyYn3Ew34s5CsCLB1y6TAMgLGsLxppUyXRiSCus9KtbjCQL3/CetZAxccqxd
         mUkQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794419232; x=1795024032; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0MglZ2+4MgA6qoVKrAGxsEiMN/rG/VnPk4yp/O82FwA=;
        b=Z5cypXbtE9VMpRmWHhJhMFOcYdpacOWf75xBjpkChvIhLXEKwtx5NrJw9wmYVnjxKC
         XVF1qIpXEWHMKArdQv3n8tYrldqF9H+Zdyxd/VxUyV4lPd7GR+YXbLBCGBIKM+NmFYUs
         IZJJ34xHIQnC/oOsNZkH7bdvNsw2gwgD1BDBFk1mxzfgJKHuBa1C11/7PI12bP/Pdw/E
         V+oqsLAY2t1u2bsj6p91M4OYWPhXCmIpqRXEd/zpKWVpCbQKVZJv8Zctb5Oxl2TqDmI/
         PRSxj080qz0FX2t/r5mS2WgwGjkhXlSQAqb6JkKAss0kO4bIhC+powbaW+rMI2LuZxQx
         gRGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794419232; x=1795024032;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0MglZ2+4MgA6qoVKrAGxsEiMN/rG/VnPk4yp/O82FwA=;
        b=v8V/bZOfNmZrrH6EnqKX7I8yW0XZzNBRZ6l5sOm1b0Aid9v1+RAiTy2xW+kjFP+KOs
         zR2BfnUO32+aWth2b9DZiXaiKGSvdAzijRRO2BWTyMaiv5FSCtiBOpJEWGKyz1Rzpomw
         nCCxhb2RQi3wy5LhO6igK/oA+mo87MscYfQAddGgEZMhcYz8Mne1yrh58WpkqmIPFsly
         7rICM/H83CYaZv41WtV6WaAzmOHFdVv5R2Jn0KE4oCc100GG70Ux9Z9O1Dn/o5BDG4zv
         TVxJ+/Dw43r/jbW4R1ZfIZJbgMUELSoceimBsmujY05KYpPxJbw790beOqyWGNtfDPrS
         2TWw==
X-Forwarded-Encrypted: i=1; AL+hErH1PG0mMetITtNrDi1rsVM4PE3EnPcynFbhWcildamHKOlBxYrtcBjgx6y3CVn9aG5WZvebDRwkBA==@kvack.org
X-Gm-Message-State: APuU4Z/adkSeUP/g2y1Tovt3RpdvIJtXvyKaSBQeoCfpQAXHZPnEoZYj
	NIJVc6FfVMd9YlHNgIZ0aDe9+iriwKY4Dty8lKJodrpbrxyqDcgDFwnilTWzH18UxoUdkl6u3v7
	XICnV10ag+Es/4tFCmJqLfuF0xIqUMi7ic/RRtCuC
X-Gm-Gg: AYBFou1JughoQ0ltZlDXPWngtyeR73CMvTyZSSxaqZlZI3uyBdLp63vUYpXvvJ1Uklj
	SzWZiv/IIQqSDbK6whcbNfJwXM/xVMF1RoMcTeSjIXCJB6zSJaQ9F5SRb0ZTQfmYqsmpwq2qfdR
	twqoI0R6jgxfYDl+L15Yiw35cx/XYtRX3rmaKI+jofPqvV2NCNErCvWP2ELL6POAsYq3BLjZZ34
	+2vnLcwOGHZYTdz3aPZ2G4YHDcVTrFdGPzn2BgZ2u/mD5CC4NHH0iYPfMHarWR1R45kgQ6KRdVa
	IR6SJVDItZo3O+TmBl7DTIrJX/nItalwe8WGvCmV42eBolfmeWj9JN5F9D8TA7K3d0Nan0WF7O2
	vknC8fhqQ7Oi4mVNvNp6k0JVr3pqOIHAkCR9/NvGx4kE+kg5x526yE71E6TSxAaS6jbE=
X-Received: by 2002:a05:600c:c086:b0:4a2:1912:6687 with SMTP id
 5b1f17b1804b1-4ba09170ee3mr852245e9.2.1794419231803; Wed, 11 Nov 2026
 09:47:11 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261111093747.50048-1-songmuchun@bytedance.com> <20261111093747.50048-2-songmuchun@bytedance.com>
In-Reply-To: <20261111093747.50048-2-songmuchun@bytedance.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Wed, 11 Nov 2026 09:46:59 -0800
X-Gm-Features: AclHuK8z5FnzGqe8u0PQ4Ulh8pu20DR0dU1bs3qSGpuaTxaD_TsAlYrPl_76rQ8
Message-ID: <CACw3F50296rRFQaxopftKTLUr7N2X+v+zN8wX9=su36wQj185Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] mm/hugetlb_vmemmap: fix lost HWPoison state during optimization
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Sashiko <sashiko-bot@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ojicr98hpz5bx4dxc7dtg5grzbur6iwe
X-Rspamd-Queue-Id: AD17220005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794419233-866154
X-HE-Meta: U2FsdGVkX1+QezSFmxkq76JjJu0tB7IZGPatnzQZi3OBfDiDbXirfahRffoPDSn9lBNfl4UrMNBT1WXrTWGErDAN1EUG0O8oQxgnGNTUMbH4X265w0c6GGSsupmHGHDaf5TtzLqbA+hgMffQg8axZ6YUpiBvznc8aZl5dRscbc+YwfhJpQoNDpX2ucVs2ULYGV/RgWBH9JOsUstoXSqjoMzY+ncuXY9t3RCcuXD9xS/E27n3RHtWS4FDDiz0S5jfq5MBa6pLGgy+hUeFF9lYPXVgINV4EGLnFoRZ5a2rN8s6cndqbf6lTfq23l2gRSHiFD3F/uhIk39DZd5Vc8V3rlL+iOMqaFV/eE0Edteff4iowtcbyTkjmqQw4xHsONwd+P1RIepmwIXe1zHwOLNVDz9uh5kO6J4lhhRD9xWQzR2Wf5zNZW36YdZeeX0rqaxGQxyhXstQxyE/0WkbR3ZGTJAAA7qtPNFS44V0wFLQWJoeSrOBsu7ZbHi7J8oyyugG+hqmqyepbv7m/ozNNUzUvEDrrlqCI+M93jtbWJsvHDwMZJ6iMUtockQhEMoTKCOjYWSR0LUOP5Ggya+YjwkzZsJVuWYy04Aho8C3P6FCak8rYVvRE0jDPlTa1vEvmvWurP3gn2iAZeTOR6pYVKJLvUHrLoxqG9NeXZR4+8dpcJEBk93UyT9zTObH6SJ6rxRqssklBtgTNqgut+yNt0YPa6rVZec+HsPYS2eZcU0fYfEJqBp3QF84Pgh9IYMi2CZAj+8k3DUWeesRS38HAfxNVDvbdlI7egMpSiSGg1FjPqFBzGKhsaW79MdCaexsMk8XfCbLNmq6vcEzl1ReC9UQ3hYK9f61yfVHIu5XoiasHzvJcphAX/lrWwfPdOhvb1NwizVyPRCRfo1wvBEoVYFUN9aE/LFjzQ/5eu8jc74fKz2QXdSJD3uiLwkNgn2RVOUmbnehBIluhzr22XIk29l
 El2BQce0
 RL10bGjh0JAHvjlXcul9tPygYzy6DMPRktoHqWz5sn39aHEb5yofxFeB+dauJDArs1woUtw84yGfCV9zw5vXiYOkGBIrezo+zHgBjUl9wTjYbGK7VfCcCS+bq95lp5k9aFd7be1Uh4Iq41AV6eCwYXlaIbd4ByHAk+ougNaqikRzhllYzyuQjWsEFu2sm+cfimsAEDL9WxoZUcpEe5VQjmTJBQpeNMo46awNcLSNS3JvAe3jyYMuZLCEsUW5nUu98FasVg/jQSi18BtrxDV1iPrkCz9pzKZlo2sgovowWHHYxq2V6fkNvw3o/AoZ0PZ0NuDsIkOBr9K4ZU3CTcwvuduoXNDYi13hIZk7WUuHI2vf7/No/GjQaWQGwH7Wp4U+QVYp3npZjIugTxBDAyt9Mgkf1FDnPxO/UvwYtb2uh+FqB2kX3I9nYfKBPhcINp97VdID1kjGi5GxekfvuM1J4bamTD7TvQnemqjpV84mWzF6Zd0I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 1:38=E2=80=AFAM Muchun Song <songmuchun@bytedance.c=
om> wrote:
>
> HVO copies the vmemmap head page before remapping it to a newly allocated
> backing page. Memory failure can update the old head page after the copy
> but before the remap's TLB invalidation completes:
>
> CPU 0                            CPU 1
> init_new_hugetlb_folio()
> __hugetlb_vmemmap_optimize_folio()
>   vmemmap_optimize_pte()
>     copy_page(old_head, new_head)
>                                  try_memory_failure_hugetlb()
>                                    get_huge_page_for_hwpoison()
>                                      hugetlb_update_hwpoison(old_head)
>   set_pte_at(..., new_head)
>   flush_tlb_all()
> free_vmemmap_page_list(old_head)
>
> The raw_hwp_page linked to the old head is then leaked and the folio's
> HWPoison state is lost when the obsolete backing page is freed, allowing
> the poisoned huge page to be allocated later.
>
> Serialize HVO remapping against HWPoison updates. This ensures that an
> update is either copied to the new vmemmap head page or applied after HVO
> installs the new mapping and completes the TLB flush.
>
> Fixes: 11aad2631bf7 ("mm/hugetlb_vmemmap: remap head page to newly alloca=
ted page")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/bug/linux-18e93f17-529b-4d84-ba44-a41829f4b=
e64
> ---
>  mm/hugetlb_vmemmap.c | 10 ++++++++++
>  mm/hugetlb_vmemmap.h | 24 ++++++++++++++++++++++++
>  mm/memory-failure.c  |  2 ++
>  3 files changed, 36 insertions(+)
>
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index ba8e11e399b2..79ca68dff635 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -15,6 +15,7 @@
>  #include <linux/mmdebug.h>
>  #include <linux/pagewalk.h>
>  #include <linux/pgalloc.h>
> +#include <linux/rwsem.h>
>  #include <linux/vmemmap-optimization.h>
>
>  #include <asm/tlbflush.h>
> @@ -41,6 +42,8 @@ struct vmemmap_remap_walk {
>         unsigned long           flags;
>  };
>
> +DECLARE_RWSEM(vmemmap_remap_rwsem);
> +
>  static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned lon=
g start,
>                              struct vmemmap_remap_walk *walk)
>  {
> @@ -333,6 +336,9 @@ static int vmemmap_pteify_folio(const struct folio *f=
olio, unsigned long flags)
>   * responsible for freeing the pages left on the @vmemmap_pages list, ev=
en on
>   * failure.
>   *
> + * Note: The caller must hold vmemmap_remap_rwsem. If TLB flushing is de=
ferred,
> + * the lock must remain held until the final TLB flush.
> + *
>   * Return: %0 on success, negative error code otherwise.
>   */
>  static int vmemmap_optimize_folio(const struct folio *folio,
> @@ -348,6 +354,8 @@ static int vmemmap_optimize_folio(const struct folio =
*folio,
>                 .flags          =3D flags,
>         };
>
> +       rwsem_assert_held(&vmemmap_remap_rwsem);
> +
>         VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
>
>         if (!vmemmap_optimizable_order(folio_order(folio)))
> @@ -536,6 +544,7 @@ void hugetlb_vmemmap_optimize_folio(const struct hsta=
te *h, struct folio *folio)
>  {
>         LIST_HEAD(vmemmap_pages);
>
> +       guard(rwsem_read)(&vmemmap_remap_rwsem);
>         __hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, 0);
>         free_vmemmap_page_list(&vmemmap_pages);
>  }
> @@ -588,6 +597,7 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h=
, struct list_head *folio_l
>
>         flush_tlb_all();
>
> +       guard(rwsem_read)(&vmemmap_remap_rwsem);
>         list_for_each_entry(folio, folio_list, lru) {
>                 int ret;
>
> diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
> index d057e8b12bf1..8b28063d78cc 100644
> --- a/mm/hugetlb_vmemmap.h
> +++ b/mm/hugetlb_vmemmap.h
> @@ -9,9 +9,12 @@
>  #ifndef _LINUX_HUGETLB_VMEMMAP_H
>  #define _LINUX_HUGETLB_VMEMMAP_H
>  #include <linux/hugetlb.h>
> +#include <linux/rwsem.h>
>  #include <linux/vmemmap-optimization.h>
>
>  #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> +extern struct rw_semaphore vmemmap_remap_rwsem;
> +
>  int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *=
folio);
>  long hugetlb_vmemmap_restore_folios(const struct hstate *h,
>                                         struct list_head *folio_list,
> @@ -20,6 +23,16 @@ void hugetlb_vmemmap_optimize_folio(const struct hstat=
e *h, struct folio *folio)
>  void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head =
*folio_list);
>  void hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned i=
nt order);
>
> +static inline void hugetlb_vmemmap_write_lock(void)
> +{
> +       down_write(&vmemmap_remap_rwsem);
> +}
> +
> +static inline void hugetlb_vmemmap_write_unlock(void)
> +{
> +       up_write(&vmemmap_remap_rwsem);
> +}
> +
>  static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
>  {
>         return pages_per_huge_page(h) * sizeof(struct page);
> @@ -59,6 +72,14 @@ static inline void hugetlb_vmemmap_optimize_folios(str=
uct hstate *h, struct list
>  {
>  }
>
> +static inline void hugetlb_vmemmap_write_lock(void)
> +{
> +}
> +
> +static inline void hugetlb_vmemmap_write_unlock(void)
> +{
> +}
> +
>  static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct=
 hstate *h)
>  {
>         return 0;
> @@ -69,6 +90,9 @@ static inline void hugetlb_vmemmap_optimize_bootmem_pag=
e(unsigned long pfn, unsi
>  }
>  #endif /* CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP */
>
> +DEFINE_LOCK_GUARD_0(vmemmap_remap,
> +                   hugetlb_vmemmap_write_lock(), hugetlb_vmemmap_write_u=
nlock())
> +
>  static inline bool hugetlb_vmemmap_optimizable(const struct hstate *h)
>  {
>         return hugetlb_vmemmap_optimizable_size(h) !=3D 0;
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 78f0a13349cb..164a02866fd5 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -69,6 +69,7 @@
>  #include "page_alloc.h"
>  #include "internal.h"
>  #include "memory-failure.h"
> +#include "hugetlb_vmemmap.h"
>
>  static int sysctl_memory_failure_early_kill __read_mostly;
>
> @@ -2038,6 +2039,7 @@ static int get_huge_page_for_hwpoison(unsigned long=
 pfn, int flags,
>         bool count_increased =3D false;
>         int ret, rc;
>
> +       guard(vmemmap_remap)();
>         spin_lock_irq(&hugetlb_lock);
>         folio =3D page_folio(page);
>         if (!folio_test_hugetlb(folio)) {
> --
> 2.54.0
>
>

LGTM :)

Reviewed-by: Jiaqi Yan <jiaqiyan@google.com>

