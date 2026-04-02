Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F733111224A
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 00:22:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82BEF6B008A; Wed,  1 Apr 2026 20:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DCF46B008C; Wed,  1 Apr 2026 20:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71A0A6B0092; Wed,  1 Apr 2026 20:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 604EB6B008A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:22:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA4B1E04D7
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:22:49 +0000 (UTC)
X-FDA: 84611715258.22.9638D9F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id C5AFE20003
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:22:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Z38T/0Jh";
	spf=pass (imf03.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Z38T/0Jh";
	spf=pass (imf03.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775089368; a=rsa-sha256;
	cv=none;
	b=ak6Ec7i9iLTg8GUIUXFiOw3YNYem+jv4CphzyVW9PwqLJsuHuhpJtHnlioNV1kU7hGOrKG
	zQlFnTeU8UD4BpuSPvgFrXR5wgdaQ85RjXsQxEGjjpGos4StFiu7pScF5cR1lYkDV4qF5x
	yBZjh53VZB4jcJ2khUiBscl27T57eEo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775089368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NlkIZN1Pdr6pNDUfmFvV3yq+JtJ/V9pLJnouaitb3YA=;
	b=BMvwb7g7QNO9XXyKwr+6TcjoS8WfVxWHUkIUi4WWgpmvA2D4/DdQ5RfvKvdOPU4brieSd3
	O5X3lq+MkFBn9bp5vPuYJ6+voJXNfOEZyKCP4Io+AXA6xByburNJnxDhCaxzuZL/WXIgbS
	Uwn/8yMr6wMcxmwSjj7ZCz3JzETqG+o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775089367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NlkIZN1Pdr6pNDUfmFvV3yq+JtJ/V9pLJnouaitb3YA=;
	b=Z38T/0JhYoTwDlz1NvGEC3G7YwTtVjgANevGf82lzgTMtimy9IAfn8WuMN5dPneu/Ix/91
	5s8aItaTCXsUg0IpyK78tcoPLlabyPHXYY/tSOk3wMzIdpAWXzkLZePNV9/4NbXTqNV/Kp
	nO53Hb3IfOSF3JBSnx/THOK9WGKZvX4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-670-Rcc8fe1WNMCasc1wit2v8Q-1; Wed,
 01 Apr 2026 20:22:43 -0400
X-MC-Unique: Rcc8fe1WNMCasc1wit2v8Q-1
X-Mimecast-MFC-AGG-ID: Rcc8fe1WNMCasc1wit2v8Q_1775089362
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 20E7018005B0;
	Thu,  2 Apr 2026 00:22:42 +0000 (UTC)
Received: from localhost (unknown [10.72.112.46])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EF2F01800767;
	Thu,  2 Apr 2026 00:22:40 +0000 (UTC)
Date: Thu, 2 Apr 2026 08:22:36 +0800
From: Baoquan He <bhe@redhat.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
	lirongqing <lirongqing@baidu.com>
Subject: Re: [PATCH v3] mm/vmalloc: Use dedicated unbound workqueues for vmap
 drain
Message-ID: <ac22zMBjWgQnLfpI@fedora>
References: <20260331202352.879718-1-urezki@gmail.com>
 <aczpyc7sxzBL4MQn@fedora>
MIME-Version: 1.0
In-Reply-To: <aczpyc7sxzBL4MQn@fedora>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: uvpUX_GGKjm3H9L3Kh9AHGZzCzhsrKYLD8KfAvsdLT8_1775089362
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C5AFE20003
X-Stat-Signature: k3sw6axhidoi6csmc3qpgd3xig4dtxtf
X-Rspam-User: 
X-HE-Tag: 1775089367-214288
X-HE-Meta: U2FsdGVkX19EpkN+tNJh0w2Wb/255s1Al1ta0j/LtGTPTyyscl3nzc4u1HjGXt+DUfFQn/v5mbP38uJrav7bL8j1VGD8078exbnRMbvW7xT2yikRa05JfvbUNCzbBtRhNhj59xsxeDAxvGVjNOJ31tDUSs52L66cByJBoxlQbUDYYopyZTZiceTidwXaW+EH1MWB2O6lgDXa44ZbdnG0e56Wg3zNp0l1Et3y5KNrkzVWL7jQOl2lFhHmfRJ3O3ztaNEjBSZqzWCKlelp/sVEE65vBQ+hs3PL9xVlm4+gSZEeWd7uWWuwjdeK2aoSMrV3X1ealF750c7pYHUH0IvH1LvSdvMr/3nKgt2PD8bMUVp1PGYjdkjDYwkYF4CQHSLKRf4pNVzhpVl81ZUT72sToQ/2VSItc4DM8HHcey0CxUV0vzq1Cex8/35BK10NY2WzIMDNu7K8+8EiYxJQM3SMAUMsSvI0aJfVgKEOBjYqWkXrkk9vfdnziBnX5o/EiEsEEophKTyqABTMKGw6K4ImToGGQbDcDRC+jJBjE9co/7MejZVX8v3Uc7/tSKgUI0/UYmF8S4CZS3woAs5rWHoxQ3tVDTXR3l5ItyOhQ2DFSoRHxWkG03fg7IqBkCWrccJte0BoF4+frgHK/rDMKQuhagsqodAR3VyL3Lyt/upE0YB8aIDHPF68007HIcr3aLf4aws4FpaT+KWlQ3UUx2q6JUE7RoMHEC7Z5DmgOeErtE4SlQZUmp+N6SnJp7Qk9rqriFENbuY5zUAQzcD1ESaTIHz4qY1v08fPXK5r4BlAkhJZDGmwcHXi6hjYBWGnr2LV0bfJgPTPmfOdI9vU8M/os+tDUtrZOIFtDfBADkrLqk1kfblNYwLNeMnnjCYwSm4ckvhkZEwKagkuwSnTdO708p6birmYVPuh/zG3WPwHiSu9pUWkgavVHhOzmYmXzbjwaRDLhwRj62w+/1xm8fb
 JELHwr2v
 XX/GRbC51v56r42Z6K8HrURzWfbA6AuNQjEQcoXrq2N/9guvuCHX3tSFVhV+TQ9mH6gLka4OyuqVVraSwM/1hfJ8P+yhgehywsoUHUUSh5l9Po2OYJ5+ks/zOuPmDhkPRO5RxBY+Q8HEvaquLrFjDjvjAD9ntSWntqNq1QB7QrK6DY28E6/IWtxfWsZUJz9QwUqnJbphduB+UQw4OC6hzvyfewlR9ktftfpGN0/5IWSp46Kx06jKXe5XWRtNEex9pNbvEKJVIyMBJQl7iFedPUjlDq4V3cOJodWjqNR1yuEz2c6KTjxvHPM4CBXIVCWeLGBfKQlxSjrWCoPVRRQPIOTNNpwATx4pwAwy6+/KcO6nrTxU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/01/26 at 05:47pm, Baoquan He wrote:
> On 03/31/26 at 10:23pm, Uladzislau Rezki (Sony) wrote:
> > drain_vmap_area_work() function can take >10ms to complete
> > when there are many accumulated vmap areas in a system with
> > high CPU count, causing workqueue watchdog warnings when run
> > via schedule_work():
> > 
> >   workqueue: drain_vmap_area_work hogged CPU for >10000us
> > 
> > Move the top-level drain work to a dedicated WQ_UNBOUND
> > workqueue so the scheduler can run this background work
> > on any available CPU, improving responsiveness. Use the
> > WQ_MEM_RECLAIM to ensure forward progress under memory
> > pressure.
> > 
> > Move purge helpers to separate WQ_UNBOUND | WQ_MEM_RECLAIM
> > workqueue. This allows drain_vmap_work to wait for helpers
> > completion without creating dependency on the same rescuer
> > thread and avoid a potential parent/child deadlock.
> ...snip...  
> > @@ -2385,29 +2390,31 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
> >  		nr_purge_helpers = atomic_long_read(&vmap_lazy_nr) / lazy_max_pages();
> >  		nr_purge_helpers = clamp(nr_purge_helpers, 1U, nr_purge_nodes) - 1;
> >  
> > -		for_each_cpu(i, &purge_nodes) {
> > -			vn = &vmap_nodes[i];
> > +		for_each_vmap_node(vn) {
> > +			vn->work_queued = false;
> > +
> > +			if (list_empty(&vn->purge_list))
> > +				continue;
> >  
> >  			if (nr_purge_helpers > 0) {
> >  				INIT_WORK(&vn->purge_work, purge_vmap_node);
> > +				vn->work_queued = schedule_drain_vmap_work(
> > +					READ_ONCE(drain_vmap_helpers_wq), &vn->purge_work);
> 
> The new schedule_drain_vmap_work() could submit all purge_work on one
> CPU, do we need use queue_work_on(cpu, wq, work) instead?

Forgot the specified WQ_UNBOUND on alloc_workqueue(), sorry for the
noise. Then this patch looks great to me.

> 
> >  
> > -				if (cpumask_test_cpu(i, cpu_online_mask))
> > -					schedule_work_on(i, &vn->purge_work);
> > -				else
> > -					schedule_work(&vn->purge_work);
> > -
> > -				nr_purge_helpers--;
> > -			} else {
> > -				vn->purge_work.func = NULL;
> > -				purge_vmap_node(&vn->purge_work);
> > -				nr_purged_areas += vn->nr_purged;
> > +				if (vn->work_queued) {
> > +					nr_purge_helpers--;
> > +					continue;
> > +				}
> >  			}
> > -		}
> >  
> > -		for_each_cpu(i, &purge_nodes) {
> > -			vn = &vmap_nodes[i];
> > +			/* Sync path. Process locally. */
> > +			purge_vmap_node(&vn->purge_work);
> > +			nr_purged_areas += vn->nr_purged;
> > +		}
> >  
> > -			if (vn->purge_work.func) {
> > +		/* Wait for completion if queued any. */
> > +		for_each_vmap_node(vn) {
> > +			if (vn->work_queued) {
> >  				flush_work(&vn->purge_work);
> >  				nr_purged_areas += vn->nr_purged;
> >  			}
> ...snip...
> > +
> > +static int __init vmalloc_init_workqueue(void)
> > +{
> > +	struct workqueue_struct *drain_wq, *helpers_wq;
> 
> Maybe there's one local variable is enough like below:
> 
> 	struct workqueue_struct *wq;
> 	unsigned int flags = WQ_UNBOUND | WQ_MEM_RECLAIM;
> 
> 	wq = alloc_workqueue("vmap_drain", flags, 0);
> 	WARN_ON_ONCE(wq == NULL);
> 	WRITE_ONCE(drain_vmap_wq, wq);
> 
> 	wq = alloc_workqueue("vmap_drain_helpers", flags, 0);
> 	WARN_ON_ONCE(wq == NULL);
> 	WRITE_ONCE(drain_vmap_helpers_wq, wq);
> 
> 	return 0;
> }
> 
> Just personal preference on nitpick, not strong opionion.
> 


