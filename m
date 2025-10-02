Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB45CCAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 11:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 104A78E0003; Thu,  2 Oct 2025 07:03:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08E058E0002; Thu,  2 Oct 2025 07:03:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E718D8E0003; Thu,  2 Oct 2025 07:03:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D01948E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:03:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 70BF6119FC3
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:03:30 +0000 (UTC)
X-FDA: 83952888180.27.B4347D3
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf03.hostedemail.com (Postfix) with ESMTP id B539420002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:03:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759403008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=26Fh3hYaPw0UF8Dh+O2fzjCpnAGjVxaVwC1862wzeNk=;
	b=NH5VANy0NqZPtAUQDovCNJS/Y5ruUEza0OMPZ+iw3YUwBtzAl+pM13auIiZrh5rj+ujDjE
	wzHWLJsSNk/u97rWeKMdkXx/Gbs0AdVbt8xj+w8rRZmpgppQcm1gI7cyH5O2EF+wa/5Ir6
	J7j8UZgrk8wM3DkyCSCBA7p5z/fuwto=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759403008; a=rsa-sha256;
	cv=none;
	b=cpPmQOhn/ZkHsgO24fOMBewdyVoKBlTcXRUaff+fk4EPN1ptYlRTPHc2Uk9bNL8K0TXyQ1
	uF2ruQzjSW+OHtwatncj4vQBRrmZx9gX/TsySeb6srR2yaJPV/uPaHzVDQ9prvyTyDkSex
	otZVeeV/VA49PIBn0oB8/sK1MnADiIc=
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ccpkX0rtWz6L4tv;
	Thu,  2 Oct 2025 19:01:08 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id D51CE140278;
	Thu,  2 Oct 2025 19:03:23 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 2 Oct
 2025 12:03:22 +0100
Date: Thu, 2 Oct 2025 12:03:20 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Shivank Garg <shivankg@amd.com>
CC: <akpm@linux-foundation.org>, <david@redhat.com>, <ziy@nvidia.com>,
	<willy@infradead.org>, <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>,
	<rakie.kim@sk.com>, <byungchul@sk.com>, <gourry@gourry.net>,
	<ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<vkoul@kernel.org>, <lucas.demarchi@intel.com>, <rdunlap@infradead.org>,
	<jgg@ziepe.ca>, <kuba@kernel.org>, <justonli@chromium.org>,
	<ivecera@redhat.com>, <dave.jiang@intel.com>, <dan.j.williams@intel.com>,
	<rientjes@google.com>, <Raghavendra.KodsaraThimmappa@amd.com>,
	<bharata@amd.com>, <alirad.malek@zptcorp.com>, <yiannis@zptcorp.com>,
	<weixugc@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [RFC V3 4/9] mm/migrate: add migrate_folios_batch_move to 
 batch the folio move operations
Message-ID: <20251002120320.00003ab7@huawei.com>
In-Reply-To: <20250923174752.35701-5-shivankg@amd.com>
References: <20250923174752.35701-1-shivankg@amd.com>
	<20250923174752.35701-5-shivankg@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B539420002
X-Stat-Signature: f3be85879jja6kho4nz5sj586o3eqw9f
X-HE-Tag: 1759403007-74778
X-HE-Meta: U2FsdGVkX19wa4mXh8xYhAcaHcowxIx2KHKMkBhD0+/Gl7ohiWwSvxUizLJ8C+2HGnQV8fEgPeWK3mnyFRSy2vD3+eLD3cUIT2CLXkERGHV/wukWKDmCd4coYuzQQhhrIteGu5p+aJB0ekQIAtNskLPSAyCx/35fApD/eH69lE9b5ESbkIdiKYISqjfl8UZ5JrvAGn0kXkn09uRWa4FdatRSexXG5QDtYyiSAd1nUVhUy8VyssIMAyy4jWcfCLhz4vhLeS6FAo+ubmiY9NHeRN2gfFeFzP4Xw1XTPcJKSlIj/sWkI4biCGeUJYuJQhDeQ7RUapcGofpGVlExiVnGTNC2WVpgLORIbnn7KuIIf26sCSBiPZHBmfJmbkS7paKK0BzUy7si3s9T3uqTHLSqnTzY3Gg0GkkGgHe+eUJB6Odd5SjIBaSMAjf8JxwAVdh1qtwVfDGKGv7rGSd1WCPK5hGuK1KqYgePyTGMcuoa8LlakV/cC7Tvd8KiX/qosZiO6jHL3JybZ5WfS8INhJcvevnASTgBW3fpFDj5Jia6uJN3KhftBI5baUnRIsImMREW0DAIPWHlPxIbzfVYqUxgN4zVc35D9WFX2kboVqMV9C4u+A1n6KKn1G3qMgrO2mdWXJ6Tn+PkGVl9anz7acNoOQx+2eaLWdsqylKk1V7WychQdVC1/wnALf2jE6kdnIHZjuDXp+82/8XapeD3jRZjrHRu3pedR4/CQx8LOymyndC8zs/7HpajcZAfstZV7dcQfFopRiZmZJvmEN2PIpoWLAmQZeTI10G4GC4P0rfFHel4AC2pE6rtRYT6gd9KpveBXvGf17wx+7TSEOld/lc+TCilX8WF2EJoTQ0P1It1w9IZmSYdS0XysnncBXSOoQSq3as83kBC7qmS2/4tRUOq3OU5digjSEa54Mq0nrofH1zSHoWY3IlykT8ChB0iyQTgpuMEKaIZ0UvlMrtcbpt
 szzsydWg
 biTn7cKj1gbz4DUqg5VjTEbFR7oeQT9v5FC4BLrtIOX0GWKasaQJgNMb1R/EkyS0e00jN1G2mYpqZLoVF/5KFix2BOAzmt7VhqFq7OQ84gapUOv55TBL6lPJkRL5MI+5a5gJJslW8hEKm8lEMc2VHwycDjC/FUI/PoWSCpyNXPaZDcB9qlaVbA9lKEblstfnicy6F4EHt54AqbXGbX0uCNnAS7sUC1UUnfLhvnXgYhRpyS+DLtqtsND7nw+dR8/W5MY8Zf7K8EobFeQeYg8lLG/jsI/2UFGQDYdFKWGWeFJrhIdjM8edB1jl6VJUaZpLfOLwI+oE0y9HEF6QBt/YaLRHDUPGegDyyX6DnOCD4a1Z+Yqb0lBUsZ/bCxqhaiSq/mRte
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Sep 2025 17:47:39 +0000
Shivank Garg <shivankg@amd.com> wrote:

> This is a preparatory patch that enables batch copying for folios
> undergoing migration. By enabling batch copying the folio content, we can
> efficiently utilize the capabilities of DMA hardware or multi-threaded
> folio copy. It uses MIGRATE_NO_COPY to skip folio copy during metadata
> copy process and performed the copies in a batch later.
> 
> Currently, the folio move operation is performed individually for each
> folio in sequential manner:
> for_each_folio() {
>         Copy folio metadata like flags and mappings
>         Copy the folio content from src to dst
>         Update page tables with dst folio
> }
> 
> With this patch, we transition to a batch processing approach as shown
> below:
> for_each_folio() {
>         Copy folio metadata like flags and mappings
> }
> Batch copy all src folios to dst
> for_each_folio() {
>         Update page tables with dst folios
> }
> 
> dst->private is used to store page states and possible anon_vma value,
> thus needs to be cleared during metadata copy process. To avoid additional
> memory allocation to store the data during batch copy process, src->private
> is used to store the data after metadata copy process, since src is no
> longer used.
> 
> Co-developed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  mm/migrate.c | 197 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 193 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 3fe78ecb146a..ce94e73a930d 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -843,12 +843,15 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
>  			   enum migrate_mode mode)
>  {
>  	int rc, expected_count = folio_expected_ref_count(src) + 1;
> +	unsigned long dst_private = (unsigned long)dst->private;
Why not just stash it in a void * and void the casts?

>  
>  	/* Check whether src does not have extra refs before we do more work */
>  	if (folio_ref_count(src) != expected_count)
>  		return -EAGAIN;
>  
> -	if (mode != MIGRATE_NO_COPY) {
> +	if (mode == MIGRATE_NO_COPY) {
> +		dst->private = NULL;
> +	} else {
>  		rc = folio_mc_copy(dst, src);
>  		if (unlikely(rc))
>  			return rc;
> @@ -862,6 +865,10 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
>  		folio_attach_private(dst, folio_detach_private(src));
>  
>  	folio_migrate_flags(dst, src);
> +
> +	if (mode == MIGRATE_NO_COPY)

I'd add a comment on what you mention in the commit message about this being a safe place
to stash this.

> +		src->private = (void *)dst_private;
> +
>  	return MIGRATEPAGE_SUCCESS;
>  }
>  
> @@ -1149,7 +1156,7 @@ static void __migrate_folio_record(struct folio *dst,
>  	dst->private = (void *)anon_vma + old_page_state;
>  }
>  
> -static void __migrate_folio_extract(struct folio *dst,
> +static void __migrate_folio_read(struct folio *dst,
>  				   int *old_page_state,
>  				   struct anon_vma **anon_vmap)
>  {
> @@ -1157,6 +1164,12 @@ static void __migrate_folio_extract(struct folio *dst,
>  
>  	*anon_vmap = (struct anon_vma *)(private & ~PAGE_OLD_STATES);
>  	*old_page_state = private & PAGE_OLD_STATES;
> +}

Probably a blank line here.

> +static void __migrate_folio_extract(struct folio *dst,
> +				   int *old_page_state,
> +				   struct anon_vma **anon_vmap)
> +{
> +	__migrate_folio_read(dst, old_page_state, anon_vmap);
>  	dst->private = NULL;
>  }
>  
> @@ -1776,6 +1789,176 @@ static void migrate_folios_move(struct list_head *src_folios,
>  	}
>  }
>  
> +static void migrate_folios_batch_move(struct list_head *src_folios,
> +		struct list_head *dst_folios,
> +		free_folio_t put_new_folio, unsigned long private,
> +		enum migrate_mode mode, int reason,
> +		struct list_head *ret_folios,
> +		struct migrate_pages_stats *stats,
> +		int *retry, int *thp_retry, int *nr_failed,
> +		int *nr_retry_pages)
> +{
> +	struct folio *folio, *folio2, *dst, *dst2;
> +	int rc, nr_pages = 0, nr_batched_folios = 0;
> +	int old_page_state = 0;
> +	struct anon_vma *anon_vma = NULL;
> +	int is_thp = 0;

Always set in each loop before use. So no need to init here that I can see.

> +	LIST_HEAD(err_src);
> +	LIST_HEAD(err_dst);

> +	/* Batch copy the folios */
> +	rc = folios_mc_copy(dst_folios, src_folios, nr_batched_folios);
> +
> +	/* TODO:  Is there a better way of handling the poison
> +	 * recover for batch copy, instead of falling back to serial copy?

Is there a reason we might expect this to be common enough to care about
not using the serial path?

> +	 */
> +	/* fallback to serial page copy if needed */
> +	if (rc) {
> +		dst = list_first_entry(dst_folios, struct folio, lru);
> +		dst2 = list_next_entry(dst, lru);
> +		list_for_each_entry_safe(folio, folio2, src_folios, lru) {
> +			is_thp = folio_test_large(folio) &&
> +				 folio_test_pmd_mappable(folio);
> +			nr_pages = folio_nr_pages(folio);
> +			rc = folio_mc_copy(dst, folio);
> +


