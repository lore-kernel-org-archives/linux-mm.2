Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 874E3CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 01:40:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2233F9001FE; Thu, 14 Aug 2025 21:40:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ADE69001D5; Thu, 14 Aug 2025 21:40:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09BB49001FE; Thu, 14 Aug 2025 21:40:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E83E29001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:40:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 64FFF5B7D8
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:40:08 +0000 (UTC)
X-FDA: 83777286096.20.0A40FA5
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf11.hostedemail.com (Postfix) with ESMTP id DB21640004
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:40:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JyCHEiYG;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755222006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mM6ETlRb4AUaAvsKe6UppqbUP1u8KlXUj2EtKdJpteA=;
	b=7xjQH6W7hwOaT0gjFlMgw9oFmH/lHIGeGmE+PEff+UOrygOZujrgOUfkbRq1y6mZlA6Zim
	PeDNANeC59LLNx63/eI9Th1nzd8YTzra9IoXNG3PDLN8Zdrl5zUxAw3DjelnBKW0++2ex2
	UPRC6uwXVZevro9HJTtN7Bp9T/a9obM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JyCHEiYG;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755222006; a=rsa-sha256;
	cv=none;
	b=OkjHI5lmqwh5Ew46EOs7H58JNas0wMOVapE+pGxsi+RTWSiWiceFlPilNjkR4Zc1cYhPfg
	vxdz4p5ZrqSgts2lawyOC/oICuiDNZEPNnWGgKwE4kWJPjPMOcySBXDFtin5nvGcs6M8U9
	btva6mwh/yX49beIs/CaKo+kXyTBbWk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755222002; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=mM6ETlRb4AUaAvsKe6UppqbUP1u8KlXUj2EtKdJpteA=;
	b=JyCHEiYGxKkS7TCdZ1j/3onv6mb2JBU4J2UUxJsqzM/h7BPIvmtSeD84E4X751/MRjrjk+Z0I9yGWQLU8ovtbNyR+rvWZB0euKifwj+BoZ3s+SMrYo5OirENoZ1TR9YDZ86fqA/7JkB4w5bXxQMItds9Mgyb6rsPDv+PhDyasFY=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WlmgyQm_1755222000 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 15 Aug 2025 09:40:00 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Bharata B Rao <bharata@amd.com>
Cc: <linux-kernel@vger.kernel.org>,  <linux-mm@kvack.org>,
  <Jonathan.Cameron@huawei.com>,  <dave.hansen@intel.com>,
  <gourry@gourry.net>,  <hannes@cmpxchg.org>,
  <mgorman@techsingularity.net>,  <mingo@redhat.com>,
  <peterz@infradead.org>,  <raghavendra.kt@amd.com>,  <riel@surriel.com>,
  <rientjes@google.com>,  <sj@kernel.org>,  <weixugc@google.com>,
  <willy@infradead.org>,  <ziy@nvidia.com>,  <dave@stgolabs.net>,
  <nifan.cxl@gmail.com>,  <xuezhengchu@huawei.com>,  <yiannis@zptcorp.com>,
  <akpm@linux-foundation.org>,  <david@redhat.com>,  <byungchul@sk.com>,
  <kinseyho@google.com>,  <joshua.hahnjy@gmail.com>,  <yuanchu@google.com>,
  <balbirs@nvidia.com>
Subject: Re: [RFC PATCH v1 2/7] migrate: implement
 migrate_misplaced_folios_batch
In-Reply-To: <20250814134826.154003-3-bharata@amd.com> (Bharata B. Rao's
	message of "Thu, 14 Aug 2025 19:18:21 +0530")
References: <20250814134826.154003-1-bharata@amd.com>
	<20250814134826.154003-3-bharata@amd.com>
Date: Fri, 15 Aug 2025 09:39:59 +0800
Message-ID: <87a541e51s.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DB21640004
X-Stat-Signature: 76fyscewi13udcipqa5qh3epds94rg37
X-Rspam-User: 
X-HE-Tag: 1755222005-877583
X-HE-Meta: U2FsdGVkX19bhnbS4/15ZJ6O1DHuP+khLdl7gPnAS2H299jObcGQFRebLoBp3QLVUFvstRrIOxMBjmiXHSz3SWJGKKFwdN7S67WF74gZp7rb9oKALeyv8sTYydq9TuM8VR0+pNefpUlB9MiWzCLqoBhxM6nM/7afIwZ8Buxi5bgQDzzRtPfNPyqDRNBTeyoO2AvKBkcGP+t4pArukseN8Sp0CIehWm35+OBPwAxhv/vV7GaIYiXjAqfLIJuHFwlFGFQRucxfqSaDibKQ7CnluABZb5omagCXJWnJTaN0P7Mr04uhOZfR96ejgboCDQigJAd3WJJM29x5ohDt7WpHRhCCuF27jGscPfNrFzQDDtAN4L44IDDu6lGyDkc4wsnicHpeMr0P2Y/+j+sqOoEnxc15t7MNRe7GHEDsSEkp9DpKsHEPGQ0C5iWsHztMachgRIKo2rCiYPYKYCOnB/5jpHNqu8w4sRhPnRZRg3nCslFEycV75d6Z8yJLsh9fhTmnGyHanz4SIRNCg6phy5M1DYnXrkp/NuguVO2iqheJKMryX06jjROupHlYzJyQ5FN31NhLwtueLMZHS1UMwLvMuN0kz6wIIMFYH5TrWOEWrCIIucaXz/Gpwe4n6o4Gmflz+wD8V6+BXi3dA2uU0sSCkmvQTEZJ/1rFebG00ex3fgnu82egmz3pJz1tDKSn5eA+Iuv6FSHNmK+cTZCXeoeSS8ae0Fcdkj9PDdrx9GdTq3QXRFR+fKYwJkSBpYgIi8Q/1LoosSJAolwFAWjgSXI9beLPkTT25RDPecNRFsERqG+ZXYiO0n6MZgFJZ/c00zpenqxOK4WtNZec1w11oTTfsoy+myAfbK2rWiNdNy00MJPB95HRJJXzcMS2iNMdOdqhHMJDxGYW2sh3T1FGaG/8v20Zd/MptskI0NNWRqpCQrt3OJz4y/bpxPmLIzMPUtuehibfyr+OPAHPXVOUmem
 sVZVfCoC
 xgkcRy6EtN8PoWyoGyPXrKiEEu53sTNdQXh9KMF5uao1DDrD0eZXYrWBwe56qr3aMddQB8YH+VUQEvxcLP75FMpkMX33IVg4S2nYBIPoMesSFxH0D+U9Tv2ilBY7U1Bh57HeNUXxpgeUAjLDve2xX+9nItfFs6Sk2SGH/2UTIWgGwU7m4k8zRHvMTkWeKOg3ILS/+7VGAvsFVaj6vEj8hIxY3gscO6uQt4cIvDweUXKdPAIBQIJinpE8xwaH6j3e8K1u2HTfanwkHdv/dA0uqpYQN369vYRGmAYabqMuZbYGVa7rMlE4aUfFu0weH1EA8OwvdH/RPAa0YDM2So09YuECq56jcWv7q6ddJb6ooQqbM6jGnsA7koY3mXgOKNTmSUlKPpmeFSW+xSIU6wXOfJFLTyZKXR3W8Eeg6kppzIgz4IZa84yKmym6VRINCpfY/QJSFfYWvCE1HnfPN8ZcQm7sBsHuNrcN22Sy33KZSiGsJoiN5BAaceMetHdgDlycN59ob
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bharata B Rao <bharata@amd.com> writes:

> From: Gregory Price <gourry@gourry.net>
>
> A common operation in tiering is to migrate multiple pages at once.

Is it common now?  If so, you can replace some callers of
migrate_misplaced_folio() with migrate_misplaced_folios_batch().

> The migrate_misplaced_folio function requires one call for each

IMHO, migrate_misplaced_folio() is more concise than
migrate_misplaced_folio function.

> individual folio.  Expose a batch-variant of the same call for use
> when doing batch migrations.
>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Bharata B Rao <bharata@amd.com>
> ---
>  include/linux/migrate.h |  6 ++++++
>  mm/migrate.c            | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 37 insertions(+)
>
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index acadd41e0b5c..0593f5869be8 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -107,6 +107,7 @@ static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
>  int migrate_misplaced_folio_prepare(struct folio *folio,
>  		struct vm_area_struct *vma, int node);
>  int migrate_misplaced_folio(struct folio *folio, int node);
> +int migrate_misplaced_folios_batch(struct list_head *foliolist, int node);
>  #else
>  static inline int migrate_misplaced_folio_prepare(struct folio *folio,
>  		struct vm_area_struct *vma, int node)
> @@ -117,6 +118,11 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
>  {
>  	return -EAGAIN; /* can't migrate now */
>  }
> +static inline int migrate_misplaced_folios_batch(struct list_head *foliolist,
> +						 int node)
> +{
> +	return -EAGAIN; /* can't migrate now */
> +}
>  #endif /* CONFIG_NUMA_BALANCING */
>  
>  #ifdef CONFIG_MIGRATION
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 7e356c0b1b5a..1268a95eda0e 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2714,5 +2714,36 @@ int migrate_misplaced_folio(struct folio *folio, int node)
>  	BUG_ON(!list_empty(&migratepages));
>  	return nr_remaining ? -EAGAIN : 0;
>  }
> +
> +/*
> + * Batch variant of migrate_misplaced_folio. Attempts to migrate
> + * a folio list to the specified destination.
> + *
> + * Caller is expected to have isolated the folios by calling
> + * migrate_misplaced_folio_prepare(), which will result in an
> + * elevated reference count on the folio.
> + *
> + * This function will un-isolate the folios, dereference them, and
> + * remove them from the list before returning.
> + */
> +int migrate_misplaced_folios_batch(struct list_head *folio_list, int node)

In addition to working on a list of folios instead of single folio, I
found there are some difference about memcg counting between
migrate_misplaced_folios_batch() and migrate_misplace_folio().  Why?

And, can we merge the implementation of two functions to reduce code
duplication?

> +{
> +	pg_data_t *pgdat = NODE_DATA(node);
> +	unsigned int nr_succeeded;
> +	int nr_remaining;
> +
> +	nr_remaining = migrate_pages(folio_list, alloc_misplaced_dst_folio,
> +				     NULL, node, MIGRATE_ASYNC,
> +				     MR_NUMA_MISPLACED, &nr_succeeded);
> +	if (nr_remaining)
> +		putback_movable_pages(folio_list);
> +
> +	if (nr_succeeded) {
> +		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
> +		mod_node_page_state(pgdat, PGPROMOTE_SUCCESS, nr_succeeded);
> +	}
> +	BUG_ON(!list_empty(folio_list));
> +	return nr_remaining ? -EAGAIN : 0;
> +}
>  #endif /* CONFIG_NUMA_BALANCING */
>  #endif /* CONFIG_NUMA */

---
Best Regards,
Huang, Ying

