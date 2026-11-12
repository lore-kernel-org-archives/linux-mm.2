Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63BDC606A886
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 07:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=CA7arcQK
Received: by kanga.kvack.org (Postfix)
	id 5EEEB6B05BC; Thu, 12 Nov 2026 02:26:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C5F16B05BD; Thu, 12 Nov 2026 02:26:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DC736B05BE; Thu, 12 Nov 2026 02:26:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 17B126B05BC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:26:50 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 855CD14038E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:26:49 +0000 (UTC)
X-FDA: 85425634938.01.053C09B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf06.hostedemail.com (Postfix) with ESMTP id E0D2A180007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:26:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CA7arcQK;
	spf=pass (imf06.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794468407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sjp/uaPMoOpiNDWt/TTQ52aexCS+VPJtc21TlQtoMSA=;
	b=uCn3DYj79AAP4vdDpimekZFJ1hbLjSVA+88nAuSYmPr+ETJLLzJ2i7ywFzkv9/EX3D+oh9
	5KJmbRW+gALpZOkUqeAHw2JHQDfcBi33xpzs0a8RqK+ahS1ELkO3e0SqO8/nr5hbpaSeFI
	uRMatbLXMePL7+Qq8NtG614v/pWDyFg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CA7arcQK;
	spf=pass (imf06.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794468407;
	b=FIQj3W+UV6MMIKhSvS9zzwlWV/FJ1iuLJVVmCJ3nUDDiV+M5cuaDSlvP7bVM01v6LHIXqe
	DhZPd79ln8mNAFAumK6yM/00BEXDQElvbysj436zzHbcjp7zcyZJovD8EDl211boOgK2ft
	++MGLrFPx4Yu+nT2zk8kQWa+wBAm+Xk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794468407; x=1826004407;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Gat36huUNsEN06TZlUZ1hiMmeuKxIm4q/qQBfo2zJ8I=;
  b=CA7arcQKyHO1Taq5Y+Xuh6I+xaeyZYCmYkrkB2zy9ia4TTSdMthpvxlX
   A9mpypMIj2czt9HcwNmb40lRwv88oWN4570sqAi7+e4KZmSWsLVEmNROf
   ZVf0U9uQbyM5KJB5QTWnxWVPwpjAAnYKxufvYVtmubekkBQLenRymwB9X
   /kvOOMgAdf8Xru3btWZS46bQmpkfISWqEFnDV2mOUawa9Vckze52bceFn
   KQkZxqNGOCSwLvMrWLvRid6j1VMikbcS8FjUglYnzkWs+A2XgyvsIlay4
   UChQFb07gn9zLOaIJuiQEIeefxiqtgPFudX3aVpE4U2aZUo3J4hNhlrtq
   Q==;
X-CSE-ConnectionGUID: mTdZhB60TBWw1rGbw2fezw==
X-CSE-MsgGUID: wYsfssnxSaSAFGwdWsz8eQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="3271492"
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="3271492"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:26:45 -0800
X-CSE-ConnectionGUID: UMsvMJhrT2+EYePEPqUtsQ==
X-CSE-MsgGUID: hNVyi5YeQcyWIpAckxSPEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="9024485"
Received: from carterle-desk.ger.corp.intel.com (HELO [10.245.244.5]) ([10.245.244.5])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:26:38 -0800
Message-ID: <96d6a6e828310738c0cb4550752a0b5808a81ef9.camel@linux.intel.com>
Subject: Re: [Linaro-mm-sig] [PATCH v4 1/8] memcg: Add MEMCG_DMABUF
 accounting infrastructure
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Albert Esteve <aesteve@redhat.com>, Tejun Heo <tj@kernel.org>, Johannes
 Weiner <hannes@cmpxchg.org>, Michal =?ISO-8859-1?Q?Koutn=FD?=
 <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>, Sumit Semwal	 <sumit.semwal@linaro.org>,
 Christian =?ISO-8859-1?Q?K=F6nig?=	 <christian.koenig@amd.com>, Michal
 Hocko <mhocko@kernel.org>, Roman Gushchin	 <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song	
 <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey
 <Brian.Starkey@arm.com>, John Stultz	 <jstultz@google.com>, "T.J. Mercier"
 <tjmercier@google.com>, Christian Brauner	 <brauner@kernel.org>, Paul Moore
 <paul@paul-moore.com>, James Morris	 <jmorris@namei.org>, "Serge E. Hallyn"
 <serge@hallyn.com>, Stephen Smalley	 <stephen.smalley.work@gmail.com>,
 Shuah Khan <shuah@kernel.org>, Randy Dunlap	 <rdunlap@infradead.org>,
 Ondrej =?UTF-8?Q?Mosn=C3=A1=C4=8Dek?=	 <omosnacek@gmail.com>, Jens
 Wiklander <jenswi@kernel.org>, Sumit Garg	 <sumit.garg@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	op-tee@lists.trustedfirmware.org
Date: Thu, 12 Nov 2026 08:26:35 +0100
In-Reply-To: <20261104-v2_20230123_tjmercier_google_com-v4-1-1819a017000b@redhat.com>
References:
	 	<20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
		 <20261104-v2_20230123_tjmercier_google_com-v4-1-1819a017000b@redhat.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-2.fc43) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: hj997341kywjkxmx6c6f7upa8p43g6fj
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E0D2A180007
X-HE-Tag: 1794468406-410050
X-HE-Meta: U2FsdGVkX18r6Tw3HpyuY29z5zRjK8BIhrjXmZCJYurUsq32b414K2J2ahqv/qexHK5aWgTBMyeUj774GEE83ru9qR0mGUV39+wlgvhmXuzgxA77NMZI4XlMkGFTyExnodVQ1NXc2CRXmbYBnBoEuVBWMN9gzLXTPJuOkWjehHKn4SJfherH/baAFXpQKMXDH3fs/nlLLsiuZDqAogOnKuqTNrZ3Uvg7NpAua8iISuT/bHYjyr0birAMv6lmrTAXwk+KZRfzlzRLy99489qlPp+K6m/my1NDI1AvGtmdsYwXMOP8VVFKu8z72hEN2c9f2cA8Ityzd2hIUrwvDrN7VhFmUtJKLzeUf4eUuHGY6Bw4H2yfVFTOCg2KXTwAjKT2Q6y/a8tnRkTFTxJYfJ0H4Zla00xNhrAqiumq4t4mu7YwM6wfMJT7yUPHl7peTbU99viNhHhVmW/WXooKfrbg3qi27iA22vL7Sg8Xl/bAUR1vSj9LK+wW/GepS9Y9d0sFTA9FVqVKcn7ziU6cpk9bAJHqfAJPqEvaVe7lD4/zZGAcjRHq4Sd8jnnukgWS5Z51jRrULLiMAdLHPUCC660fd2YMuY5RNdJVLwvdFVi3eiptWFQDXHMnVBrBqSs+/F0wbIbeH7cPmc7fJB22DuEQpgBQHLJcT5Vsj5bWt8pF5Y0emkQIE/cjxl5uhTXznXqgTNRXQ0l+i8M876YUSrrtHlIkLo6l/IH8K+67oRVA+UrC1nGI541JAf/xVOgwBDFtjFYjNweoY1nm4xVjxKhKPpXxAjnayG1Cf0SJ/P7uP5VF6w7dZCzZdO7Vj6uaW+erqa/7do/t3B+Fe5h8dgNZ8v2Wr8e4uoyGFs1iNQxoiUGBEq3IJBQTqU6w4n7ltEdsMTsTNMwXfU+tFpo7n+tZ8xbQ+cdGzXlYZ68h3fWZf7YFmytojw4ul8/p/lITkp4Q9x4o2OmYHKdRx6hna/o
 wQ60edUV
 0x/8PIsH4UU3pIjifzQmFnP+W0AIuWR79GFfVyHUMEwDFphm30agygfxnslA88Ec1eOJYkhhYNcK/qNfg5xVYnWC5HcdansO5ksqQCdspZzQiBbuvBgCWPzJte/7+FhQqVkbo0a+HgUsv8c8XEy90bAHmH62cgZpGv8nUKJ8Mdox3npEbrYRRK9ISlIy0/PLdGn2Ak2f6DXA1GqgtLe/nlE6RujF8Xxg0lTFO8SHTrSoEdwnblHX9tCqUvalMG3qD1RxD1iG2ljMwle2fBm8iGEM1zcQ/P0Z2bGdCrko3OJMSsweMAgF4wzOg6JpnL2vbx2XE5e5Y7iVcM99tiwsuLc3lDCGlfnZ1CMihazeOima9/2GSIwXvWelvBARkuiJIYRq3jtfT9J1rjkai6D0BpMGfGBpo4d6bYeTkXAxejZZbS5YlcXiZt1I6dDvgJyTs3Tcozlrpi5ydqErpQ2tntWj6Xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 2026-11-04 at 12:09 +0100, Albert Esteve wrote:
> From: "T.J. Mercier" <tjmercier@google.com>
>=20
> Introduce a MEMCG_DMABUF stat counter and helpers for charging,
> cancelling, and uncharging dma-buf memory against a memory cgroup.
>=20
> The charge is tracked on struct dma_buf via a new memcg pointer.
> The memcg reference is stored into (or cleared from) dmabuf->memcg
> by the helpers, removing the need for callers to manage those
> details. The release path in dma_buf_release() is reduced to a
> single mem_cgroup_uncharge_dmabuf() call.
>=20
> Rather than charging at the page level via __GFP_ACCOUNT, which
> would require exporters to expose their backing pages for
> cross-cgroup transfer via new dma_buf_ops, charges are tracked
> externally on struct dma_buf through a single accounting path.
>=20
> The next patch wires up the charging policy in the dma-heap ioctl.
>=20
> Signed-off-by: T.J. Mercier <tjmercier@google.com>
> Signed-off-by: Albert Esteve <aesteve@redhat.com>
> ---
> =C2=A0Documentation/admin-guide/cgroup-v2.rst |=C2=A0 4 ++
> =C2=A0drivers/dma-buf/dma-buf.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 3 ++
> =C2=A0include/linux/dma-buf.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 ++
> =C2=A0include/linux/memcontrol.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 27 +++++++++++++
> =C2=A0mm/memcontrol.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 | 70
> +++++++++++++++++++++++++++++++++
> =C2=A05 files changed, 108 insertions(+)
>=20
> diff --git a/Documentation/admin-guide/cgroup-v2.rst
> b/Documentation/admin-guide/cgroup-v2.rst
> index 86a2a0099178..a3265a4a953e 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1662,6 +1662,10 @@ The following nested keys are defined.
> =C2=A0		Amount of memory used for storing in-kernel data
> =C2=A0		structures.
> =C2=A0
> +	=C2=A0 dmabuf (npn)
> +		Amount of memory used for exported DMA buffers
> allocated by the cgroup.
> +		Stays with the allocating cgroup regardless of how
> the buffer is shared.
> +
> =C2=A0	=C2=A0 workingset_refault_anon
> =C2=A0		Number of refaults of previously evicted anonymous
> pages.
> =C2=A0
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 4c9add51f9ef..1c6b9cee7ac2 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -14,6 +14,7 @@
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/slab.h>
> =C2=A0#include <linux/dma-buf.h>
> +#include <linux/memcontrol.h>
> =C2=A0#include <linux/dma-fence.h>
> =C2=A0#include <linux/dma-fence-unwrap.h>
> =C2=A0#include <linux/anon_inodes.h>
> @@ -182,6 +183,8 @@ static void dma_buf_release(struct dentry
> *dentry)
> =C2=A0
> =C2=A0	dmabuf->ops->release(dmabuf);
> =C2=A0
> +	mem_cgroup_uncharge_dmabuf(dmabuf);
> +
> =C2=A0	if (dmabuf->resv =3D=3D (struct dma_resv *)&dmabuf[1])
> =C2=A0		dma_resv_fini(dmabuf->resv);
> =C2=A0
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index d15b2b31d3c9..23ec0ff23fba 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -27,6 +27,7 @@
> =C2=A0struct device;
> =C2=A0struct dma_buf;
> =C2=A0struct dma_buf_attachment;
> +struct mem_cgroup;
> =C2=A0
> =C2=A0/**
> =C2=A0 * struct dma_buf_ops - operations possible on struct dma_buf
> @@ -429,6 +430,9 @@ struct dma_buf {
> =C2=A0
> =C2=A0		__poll_t active;
> =C2=A0	} cb_in, cb_out;
> +
> +	/** @memcg: the cgroup to which this buffer is currently
> attributed */
> +	struct mem_cgroup *memcg;
> =C2=A0};
> =C2=A0
> =C2=A0/**
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 7d1c0ce189a8..4d1e82cf0833 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -10,6 +10,9 @@
> =C2=A0
> =C2=A0#ifndef _LINUX_MEMCONTROL_H
> =C2=A0#define _LINUX_MEMCONTROL_H
> +
> +struct dma_buf;
> +
> =C2=A0#include <linux/cgroup.h>
> =C2=A0#include <linux/vm_event_item.h>
> =C2=A0#include <linux/hardirq.h>
> @@ -40,6 +43,7 @@ enum memcg_stat_item {
> =C2=A0	MEMCG_ZSWAP_B,
> =C2=A0	MEMCG_ZSWAPPED,
> =C2=A0	MEMCG_ZSWAP_INCOMP,
> +	MEMCG_DMABUF,
> =C2=A0	MEMCG_NR_STAT,
> =C2=A0};
> =C2=A0
> @@ -667,6 +671,9 @@ int mem_cgroup_charge_hugetlb(struct folio*
> folio, gfp_t gfp);
> =C2=A0int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned
> short id,
> =C2=A0				=C2=A0=C2=A0 struct mm_struct *mm, gfp_t gfp);
> =C2=A0
> +bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int nr_pages);
> +
> =C2=A0void __mem_cgroup_uncharge(struct folio *folio);
> =C2=A0
> =C2=A0/**
> @@ -682,6 +689,10 @@ static inline void mem_cgroup_uncharge(struct
> folio *folio)
> =C2=A0	__mem_cgroup_uncharge(folio);
> =C2=A0}
> =C2=A0
> +void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg, unsigned int
> nr_pages);
> +
> +void mem_cgroup_uncharge_dmabuf(struct dma_buf *dmabuf);
> +
> =C2=A0void __mem_cgroup_uncharge_folios(struct folio_batch *folios);
> =C2=A0static inline void mem_cgroup_uncharge_folios(struct folio_batch
> *folios)
> =C2=A0{
> @@ -1167,10 +1178,26 @@ static inline int
> mem_cgroup_swapin_charge_folio(struct folio *folio,
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
> +static inline bool mem_cgroup_reserve_dmabuf(struct mem_cgroup
> *memcg,
> +					=C2=A0=C2=A0=C2=A0=C2=A0 gfp_t gfp,
> +					=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int nr_pages)
> +{
> +	return true;
> +}
> +
> +static inline void mem_cgroup_cancel_dmabuf(struct mem_cgroup
> *memcg,
> +					=C2=A0=C2=A0=C2=A0 unsigned int nr_pages)
> +{
> +}
> +
> =C2=A0static inline void mem_cgroup_uncharge(struct folio *folio)
> =C2=A0{
> =C2=A0}
> =C2=A0
> +static inline void mem_cgroup_uncharge_dmabuf(struct dma_buf
> *dmabuf)
> +{
> +}
> +
> =C2=A0static inline void mem_cgroup_uncharge_folios(struct folio_batch
> *folios)
> =C2=A0{
> =C2=A0}
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 856a7d07586c..e53dd7eebc3b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -69,6 +69,7 @@
> =C2=A0#include <net/ip.h>
> =C2=A0#include "slab.h"
> =C2=A0#include "memcontrol-v1.h"
> +#include <linux/dma-buf.h>
> =C2=A0
> =C2=A0#include <linux/uaccess.h>
> =C2=A0
> @@ -442,6 +443,7 @@ static const unsigned int memcg_stat_items[] =3D {
> =C2=A0	MEMCG_ZSWAP_B,
> =C2=A0	MEMCG_ZSWAPPED,
> =C2=A0	MEMCG_ZSWAP_INCOMP,
> +	MEMCG_DMABUF,
> =C2=A0};
> =C2=A0
> =C2=A0#define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
> @@ -1625,6 +1627,7 @@ static const struct memory_stat memory_stats[]
> =3D {
> =C2=A0#ifdef CONFIG_HUGETLB_PAGE
> =C2=A0	{
> "hugetlb",			NR_HUGETLB			},
> =C2=A0#endif
> +	{
> "dmabuf",			MEMCG_DMABUF			},
> =C2=A0
> =C2=A0	/* The memory events */
> =C2=A0	{
> "workingset_refault_anon",	WORKINGSET_REFAULT_ANON		},
> @@ -5658,6 +5661,73 @@ void mem_cgroup_flush_workqueue(void)
> =C2=A0	flush_workqueue(memcg_wq);
> =C2=A0}
> =C2=A0
> +/**
> + * mem_cgroup_reserve_dmabuf - charge a memcg for a dma-buf
> allocation
> + * @memcg: memcg to charge (may be %NULL)
> + * @gfp_mask: reclaim mode
> + * @nr_pages: number of pages to charge
> + *
> + * Charges @nr_pages against @memcg. Call this before allocating
> pages so
> + * the cgroup limit is enforced up front. On success the caller must
> + * finalize the charge with the MEMCG_DMABUF stat update, or call
> + * mem_cgroup_cancel_dmabuf() to undo it.
> + *
> + * Returns %true on success, %false if the charge would exceed the
> limit.
> + */
> +bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t
> gfp_mask,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int nr_pages)
> +{
> +	if (!memcg || mem_cgroup_disabled())
> +		return true;
> +
> +	if (try_charge(memcg, gfp_mask, nr_pages))
> +		return false;
> +
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(mem_cgroup_reserve_dmabuf);
> +
> +/**
> + * mem_cgroup_cancel_dmabuf - undo a dma-buf charge
> + * @memcg: memcg to uncharge (may be %NULL)
> + * @nr_pages: same value passed to mem_cgroup_reserve_dmabuf()
> + *
> + * Returns @nr_pages of charge to @memcg. Use when the allocation
> fails
> + * after mem_cgroup_reserve_dmabuf().
> + */
> +void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg, unsigned int
> nr_pages)
> +{
> +	if (!memcg)
> +		return;
> +
> +	if (!mem_cgroup_is_root(memcg))
> +		refill_stock(memcg, nr_pages);
> +}
> +EXPORT_SYMBOL_GPL(mem_cgroup_cancel_dmabuf);
> +
> +/**
> + * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its memcg
> + * @dmabuf: buffer to uncharge
> + *
> + * Reverses a finalized dma-buf charge. Drops the memcg
> + * reference stored in @dmabuf->memcg and clears the pointer.
> + * Safe to call when @dmabuf->memcg is %NULL.
> + */
> +void mem_cgroup_uncharge_dmabuf(struct dma_buf *dmabuf)
> +{
> +	unsigned int nr_pages;
> +	struct mem_cgroup *memcg =3D dmabuf->memcg;
> +
> +	if (!memcg)
> +		return;
> +
> +	nr_pages =3D PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
> +	mod_memcg_state(memcg, MEMCG_DMABUF, -nr_pages);
> +	mem_cgroup_cancel_dmabuf(memcg, nr_pages);
> +	mem_cgroup_put(memcg);
> +	dmabuf->memcg =3D NULL;
> +}

Instead of keeping a reference on the memcg for the buffer's whole
lifetime, shouldn't an obj_cgroup be used, which is reparented when the
memcg goes offline? Like in Dave's series here:

https://lore.kernel.org/all/20260706052330.1110909-1-airlied@gmail.com/

Thanks,
Thomas




> +
> =C2=A0static int __init cgroup_memory(char *s)
> =C2=A0{
> =C2=A0	char *token;

