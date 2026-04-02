Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B1941112249
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 00:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60A136B008C; Wed,  1 Apr 2026 20:23:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BB236B0092; Wed,  1 Apr 2026 20:23:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F8E96B0093; Wed,  1 Apr 2026 20:23:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 40A366B008C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:23:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A841256B8A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:23:26 +0000 (UTC)
X-FDA: 84611716812.08.D90FEC4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0384F40007
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:23:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="iEZ7Hc1/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775089403; a=rsa-sha256;
	cv=none;
	b=s0w+qGV+zO9YN5D84HE1Alx8OU1UzBhPepiz8quzkiMTgk1Wg5s03u4SFK3R2cmQCLYqtg
	bqWiO51nwHHD/sqqdEBTPvO8NdVmtYHdKuwDjQ87s8GXn9Fupl3dzZHZFm1c7iIrarRNhl
	6zsVpFcitm2C7fKj4uX8n/eEa4g2G64=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="iEZ7Hc1/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775089403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PzNZ1nRlwt+/i/wv4JFJx6Vf7hfHjWTodzEqkmNDe40=;
	b=3atKKPbDRnNma40q9NyoPWwgfCXr02QUrzqTDH42qtBad0G7/V+wanDz+2POWzymgSrD4Y
	T3tWVRUArcD2ZqXdwZnwip/IKb5QXbfDGU+dgjAoHQ95tVwxI3os1QSbV+DMPq7XAEvgZa
	jg1ijsFVpKQy9KkKsijh+VAt6AQo1T4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775089402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PzNZ1nRlwt+/i/wv4JFJx6Vf7hfHjWTodzEqkmNDe40=;
	b=iEZ7Hc1/e0iIYdIU+5xt4Yszds7yYoh5cyIxyoUDJSMNRw2JF/VlFp73u393zMjDRBCrvx
	p4bLZu+sE94G+O7ou/y7W5Ipfu2SynKOkDYALZ0RoHdZsh5cUXa7f8JPD4F5iceLXaYt01
	L/luXab94cEWuDXou/VJoQ8NR/TF9uU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-685-BfNY1WboPXSfQepN6-Eqwg-1; Wed,
 01 Apr 2026 20:23:18 -0400
X-MC-Unique: BfNY1WboPXSfQepN6-Eqwg-1
X-Mimecast-MFC-AGG-ID: BfNY1WboPXSfQepN6-Eqwg_1775089397
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4EFA1180035C;
	Thu,  2 Apr 2026 00:23:17 +0000 (UTC)
Received: from localhost (unknown [10.72.112.46])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C46431800361;
	Thu,  2 Apr 2026 00:23:15 +0000 (UTC)
Date: Thu, 2 Apr 2026 08:23:10 +0800
From: Baoquan He <bhe@redhat.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
	lirongqing <lirongqing@baidu.com>
Subject: Re: [PATCH v3] mm/vmalloc: Use dedicated unbound workqueues for vmap
 drain
Message-ID: <ac227uLhjH8pETb5@fedora>
References: <20260331202352.879718-1-urezki@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20260331202352.879718-1-urezki@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 4p6jLF6-V015hC7ZRxqtI-Nj7mtd9B-m8cZ1YeRdLP8_1775089397
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: d49idcmf1h9qihncj3na147xr5skxn3e
X-Rspamd-Queue-Id: 0384F40007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775089402-90962
X-HE-Meta: U2FsdGVkX1+vsV4/kciqhJfhz2qAEOSV2FuvMCrF28ttdkOB7E6pTh+Zq3aXgpbk4qb8zHhieRPfe0dJZxnEOTqxu8b2g/FiYCLicNn6Gp6e8FEa1zgVxmxnshMgnkYrYD/t4yZ/0Fpkcm5sXNOSnI+4jLbyAt60FZ0Yd0hK3oblnUqzx5eBnnMmXru40JQRE5uEtosTLftOcXm5EUu6c+n3dVDHzfta2H/2D0ynVSuo/axO5MCLIOOcRsR1EHi0ghGEY31PZ3xeBNEhJ2rhyud/DWdMq09XhhRNB44PIqwSOsZ89J5kcCXm811NIc7kWiN4oZ404wYkR66WeUAHp95hYSiPSiHWX4Hl9WfEvrM0jU1W25cxqulhpt05f5oQu1K4IlbCO6prLTt2HI0klTEXYZ/xrE6w9B3qWTdC9zOjUYu9/7DtiB1gtlwKNyx7YrTdpSxWIh2Bxj6BrHvhJBVaL+6h05jcilImS4Xm9Gbflq+ycvQac1kuzCVbdJsPgse6BvycYaOqKFWi+RMEKnddvwvZFIf4wICFI5Mh8XlwuxMeuj10IQ3VLcVz2HACfMG14RdROh+CTiz0mf6IVTxTjhLmIraIoNh40mfDM8g3wiQihNSVcAtpKJVQS0YGNRsjPkzTUEkhQ7CPlD6BUxjViFyssK5siwqTlEHkFT+m89oapkYaUbWBwt9Hzry7N9auSra5u/VTzgML7yTEEi/FOtoOMO6AFF+xaif2pP4O4+5gepap2BUrYFMxnXbDaxSU/Qn0uoaTDWbZtF+CBxWzRNGqIFvNfTRSdlgPKTUG/L1szG0brsE+xzIHX90ijnleEh9XwM/fJyqU+FTyaVErUbg92Pz71dVEtfuRITFRwOaOtwrCWm8SdHdENgVu0e1B/WvxAH/sSeJ78v3vPFElWbBiNW+tOJlCBNQIDhsxp10EeTKbhsOrrbp9eLAYPU8hWPff6KwbdKUojwe
 N9oJy8e7
 9eIMN59RRMO+zpDVexH9sYdj31YF9bvqeIjjHwegEKn5uEqV3xhzWNwd1m1XxUsNevuAqGNGVuz5k75i2VPvIBOD1RE1VxiZ9adrLaGWsVW3hhVDcBm2bDa34YJsvKyyAm19KnUz6zuYtFfDgJzxX74jYDuawCkdyhQ3K7C53sn9Ll4tCodiDj6ohmiS26TdxWDSRIJlnhiEKivFjDUsTwSt4lyHP/QZKWPzQt/TgVtCDEjIBFPOBDtyFMefDKYYHo47yrPOCz4xPotxzpOFB44E8FH8C+wUXNaRHqZbljkIRh+bdiiQvWrYfYCY1Dr0hGxdhW/zmrfUBWyLPbwJuTfop/2YEiXk5PTl3XnU3H0rfPImus9LLl2IF1TvfN+TRc6vUXd5Xwfy4PZHNBPMUwD49cyfwIR+t1u/JOH/fqLaaAUxbACn9EMIgwsXFNtI9nE28DV7nVCCSP00=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/31/26 at 10:23pm, Uladzislau Rezki (Sony) wrote:
> drain_vmap_area_work() function can take >10ms to complete
> when there are many accumulated vmap areas in a system with
> high CPU count, causing workqueue watchdog warnings when run
> via schedule_work():
> 
>   workqueue: drain_vmap_area_work hogged CPU for >10000us
> 
> Move the top-level drain work to a dedicated WQ_UNBOUND
> workqueue so the scheduler can run this background work
> on any available CPU, improving responsiveness. Use the
> WQ_MEM_RECLAIM to ensure forward progress under memory
> pressure.
> 
> Move purge helpers to separate WQ_UNBOUND | WQ_MEM_RECLAIM
> workqueue. This allows drain_vmap_work to wait for helpers
> completion without creating dependency on the same rescuer
> thread and avoid a potential parent/child deadlock.
> 
> Simplify purge helper scheduling by removing cpumask-based
> iteration to iterating directly over vmap nodes checking
> work_queued state.
> 
> Cc: stable@vger.kernel.org
> Cc: lirongqing <lirongqing@baidu.com>
> Fixes: 72210662c5a2 ("mm: vmalloc: offload free_vmap_area_lock lock")
> Link: https://lore.kernel.org/all/20260319074307.2325-1-lirongqing@baidu.com/
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  mm/vmalloc.c | 79 ++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 52 insertions(+), 27 deletions(-)

LGTM,

Reviewed-by: Baoquan He <bhe@redhat.com>

> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 61caa55a4402..0fa1208a910b 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -949,6 +949,7 @@ static struct vmap_node {
>  	struct list_head purge_list;
>  	struct work_struct purge_work;
>  	unsigned long nr_purged;
> +	bool work_queued;
>  } single;
>  
>  /*
> @@ -1067,6 +1068,8 @@ static void reclaim_and_purge_vmap_areas(void);
>  static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
>  static void drain_vmap_area_work(struct work_struct *work);
>  static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
> +static struct workqueue_struct *drain_vmap_helpers_wq;
> +static struct workqueue_struct *drain_vmap_wq;
>  
>  static __cacheline_aligned_in_smp atomic_long_t nr_vmalloc_pages;
>  static __cacheline_aligned_in_smp atomic_long_t vmap_lazy_nr;
> @@ -2335,6 +2338,16 @@ static void purge_vmap_node(struct work_struct *work)
>  	reclaim_list_global(&local_list);
>  }
>  
> +static bool
> +schedule_drain_vmap_work(struct workqueue_struct *wq,
> +		struct work_struct *work)
> +{
> +	if (wq)
> +		return queue_work(wq, work);
> +
> +	return false;
> +}
> +
>  /*
>   * Purges all lazily-freed vmap areas.
>   */
> @@ -2342,19 +2355,12 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
>  		bool full_pool_decay)
>  {
>  	unsigned long nr_purged_areas = 0;
> +	unsigned int nr_purge_nodes = 0;
>  	unsigned int nr_purge_helpers;
> -	static cpumask_t purge_nodes;
> -	unsigned int nr_purge_nodes;
>  	struct vmap_node *vn;
> -	int i;
>  
>  	lockdep_assert_held(&vmap_purge_lock);
>  
> -	/*
> -	 * Use cpumask to mark which node has to be processed.
> -	 */
> -	purge_nodes = CPU_MASK_NONE;
> -
>  	for_each_vmap_node(vn) {
>  		INIT_LIST_HEAD(&vn->purge_list);
>  		vn->skip_populate = full_pool_decay;
> @@ -2374,10 +2380,9 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
>  		end = max(end, list_last_entry(&vn->purge_list,
>  			struct vmap_area, list)->va_end);
>  
> -		cpumask_set_cpu(node_to_id(vn), &purge_nodes);
> +		nr_purge_nodes++;
>  	}
>  
> -	nr_purge_nodes = cpumask_weight(&purge_nodes);
>  	if (nr_purge_nodes > 0) {
>  		flush_tlb_kernel_range(start, end);
>  
> @@ -2385,29 +2390,31 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
>  		nr_purge_helpers = atomic_long_read(&vmap_lazy_nr) / lazy_max_pages();
>  		nr_purge_helpers = clamp(nr_purge_helpers, 1U, nr_purge_nodes) - 1;
>  
> -		for_each_cpu(i, &purge_nodes) {
> -			vn = &vmap_nodes[i];
> +		for_each_vmap_node(vn) {
> +			vn->work_queued = false;
> +
> +			if (list_empty(&vn->purge_list))
> +				continue;
>  
>  			if (nr_purge_helpers > 0) {
>  				INIT_WORK(&vn->purge_work, purge_vmap_node);
> +				vn->work_queued = schedule_drain_vmap_work(
> +					READ_ONCE(drain_vmap_helpers_wq), &vn->purge_work);
>  
> -				if (cpumask_test_cpu(i, cpu_online_mask))
> -					schedule_work_on(i, &vn->purge_work);
> -				else
> -					schedule_work(&vn->purge_work);
> -
> -				nr_purge_helpers--;
> -			} else {
> -				vn->purge_work.func = NULL;
> -				purge_vmap_node(&vn->purge_work);
> -				nr_purged_areas += vn->nr_purged;
> +				if (vn->work_queued) {
> +					nr_purge_helpers--;
> +					continue;
> +				}
>  			}
> -		}
>  
> -		for_each_cpu(i, &purge_nodes) {
> -			vn = &vmap_nodes[i];
> +			/* Sync path. Process locally. */
> +			purge_vmap_node(&vn->purge_work);
> +			nr_purged_areas += vn->nr_purged;
> +		}
>  
> -			if (vn->purge_work.func) {
> +		/* Wait for completion if queued any. */
> +		for_each_vmap_node(vn) {
> +			if (vn->work_queued) {
>  				flush_work(&vn->purge_work);
>  				nr_purged_areas += vn->nr_purged;
>  			}
> @@ -2471,7 +2478,8 @@ static void free_vmap_area_noflush(struct vmap_area *va)
>  
>  	/* After this point, we may free va at any time */
>  	if (unlikely(nr_lazy > nr_lazy_max))
> -		schedule_work(&drain_vmap_work);
> +		schedule_drain_vmap_work(READ_ONCE(drain_vmap_wq),
> +			&drain_vmap_work);
>  }
>  
>  /*
> @@ -5483,3 +5491,20 @@ void __init vmalloc_init(void)
>  	vmap_node_shrinker->scan_objects = vmap_node_shrink_scan;
>  	shrinker_register(vmap_node_shrinker);
>  }
> +
> +static int __init vmalloc_init_workqueue(void)
> +{
> +	struct workqueue_struct *drain_wq, *helpers_wq;
> +	unsigned int flags = WQ_UNBOUND | WQ_MEM_RECLAIM;
> +
> +	drain_wq = alloc_workqueue("vmap_drain", flags, 0);
> +	WARN_ON_ONCE(drain_wq == NULL);
> +	WRITE_ONCE(drain_vmap_wq, drain_wq);
> +
> +	helpers_wq = alloc_workqueue("vmap_drain_helpers", flags, 0);
> +	WARN_ON_ONCE(helpers_wq == NULL);
> +	WRITE_ONCE(drain_vmap_helpers_wq, helpers_wq);
> +
> +	return 0;
> +}
> +early_initcall(vmalloc_init_workqueue);
> -- 
> 2.47.3
> 


