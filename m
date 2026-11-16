Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A853606A339
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 071156B05B0; Mon, 16 Nov 2026 18:17:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01ED96B05B1; Mon, 16 Nov 2026 18:17:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77506B05B2; Mon, 16 Nov 2026 18:17:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B21AA6B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:17:18 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F14D6C0298
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:17:17 +0000 (UTC)
X-FDA: 85442545314.12.6665197
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	by imf25.hostedemail.com (Postfix) with ESMTP id 78C37A0007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:17:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of fw@strlen.de designates 91.216.245.30 as permitted sender) smtp.mailfrom=fw@strlen.de;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794871035;
	b=wqMYJD3Qn9+t12toP9AwL9B5QlABQySbPP0XhpnT8gYJ2bjGuahMGETiU4m6zagafHssgD
	0SnVxoHs6E/CGxWNgZVihyxeEJ7Ki3IolEGKaqTr1PeQFYt3JlEQ3XZEpT9HBKbkMJSmKj
	h6J6hJGC5z29RX6macrT3b9EG67YS7I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794871035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lBMZHfw7i4eJx0zD4VQ6/+RNNcDSsfzhNT1NDQ8/k0U=;
	b=mVCTSjUgSlyG9K//R400UXcyHdgXmIsyKg95Ox3KtunpIT3vyELVTpKRtbD7LOMNJwxayk
	jrmhxXyZ5hmVv89NhflcSVcduJ4BzYPgKaL51Uj+y7Ix6tQUPdjVumaam3DT68AVXFARw/
	PPwEucEP4Ad4+uJAS7OSBHtKUFJbnTU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of fw@strlen.de designates 91.216.245.30 as permitted sender) smtp.mailfrom=fw@strlen.de;
	dmarc=none
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1421760342; Tue, 17 Nov 2026 00:17:13 +0100 (CET)
Date: Tue, 17 Nov 2026 00:17:09 +0100
From: Florian Westphal <fw@strlen.de>
To: alireza@asgari.net
Cc: netfilter-devel@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>,
	Vladimir Davydov <vdavydov.dev@gmail.com>,
	Chris Down <chris@chrisdown.name>,
	Zhang Jiao <zhangjiao2@cmss.chinamobile.com>,
	Song Hu <husong@kylinos.cn>, cgroups@vger.kernel.org,
	netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC nf-next 7/9] netfilter: nfqueue: reserve capacity
 against the bound owner
Message-ID: <avuO9UUriolRoRg8@strlen.de>
References: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
 <20261115-b4-nfqueue-memory-accounting-v1-7-b9cc30819997@asgari.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115-b4-nfqueue-memory-accounting-v1-7-b9cc30819997@asgari.net>
X-Rspamd-Queue-Id: 78C37A0007
X-Rspam-User:
X-Stat-Signature: a36tt51c5ktei1ifamod9746u7gxi5qg
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794871035-413739
X-HE-Meta: U2FsdGVkX19CckXdmBnwvxUFn8Qr+uUV7C0DS1JUKQs0UWdOGkIAET/o/zc5m6PO1uVd76NaAeqBWYFYPTm5gmrlvxetpXR/q8HmuCjyZKjRjYY9TOUky0MtDnsDYcB0btmYwvTr6n/YYwWZ5WzrvzkA0PZakgofjmgFAGcDtHljH8QG8ZM6Xy/aVls98uv7cDO2HtVltgKSFo6t15tPRtlFzD5Ya8Dw+4aDsEU6zOxCcH8ngk4mW/Ol4cYm8y2YQ9/FIIfQN6sj+SdGlbUIVlPUE+G8DG4DHirXnJE83GV+8ahX4G3exBgLhN8EBQapk3zZJ2Tt1GWYpHhf4ekeDA6f157VRD3A4TWZT9iHSbdGzFmrJem0VpNou6IlHF8bYePudf52tSLIiQI/bN9wnGu/dOUAziPG80smaVVhHPhun1X9d/aclkBZg6XcuGaF3I9McMM/x9HITz8rw+7dJkXfPhZaTop/YMS8yLYyMJX7GCJw2fvErVE5cAEZyLlV0WWxnOedMbUjuCwdpumbQjXsY4EvRACz0TzGyDSTyrliQvSpOavX2xySPcmrp1dTwB/QurtIeoHYFPZOiD/kimSEXkLLfUl40IZmDgPyIsCoN/817XnZz805Jgt1AZCqSkQ76HlLoo2vNXiBsjx3TP0Pti00WfHUnQlQyJio6OAx8a/0URY5E+0BRJ8SWBGf/+vjLetIyk/ECUWJE+71u2K+/Pqm4vHCynFX4C2jdcIwyQBupDP+z9TIJ2AWDNuvGM8Ba9lroHyNtutJDvvRTzyxIW1RF3iJnpcTTeT1tbZp3tYCsxBrqnDcyYEdYu5K0fo3O/OCwTTrQhR312yQsD4cMb9eBq6e0hbFZBCnQdcZXf3uijiMqwBD//6l50fTpRUrxNYqE2uaygWCpkDpASCs7Tx1fd/pMJSLxMYm0YP590jgXE5tNd+GYZaycPvonJEh1QtgNWHo/FYrVmZ
 Zrq+gSJH
 +b6N/qcI9QJrkrm44etRLw4MosDeIa7UdzkBTqvFaaL18ENvm478pl5R7rHSplynpXGw1MEaani5pZG7fm+WcBSGbyQESMCrNL2keSSEI7QgXlf4fN3OI4COgVrILnDTJLMXzTodrI0UrSTovCzrt7OA/8JseS76ifYVEXRF4MBfxLg1bWE8JjmMHiBPxDHwi4TTeK9DfL2lOZj4OrZyvV9xIo+/dpoovcoxu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Alireza Asgari via B4 Relay <devnull+alireza.asgari.net@kernel.org> wrote:
> +static void nfqnl_mem_refund(struct nfqnl_instance *queue)
> +{
> +	u64 pages;
> +
> +	lockdep_assert_held(&queue->mem_mutex);
> +	spin_lock_bh(&queue->lock);
> +	pages = nfqnl_mem_pages(max(queue->mem_limit, queue->mem_used));
> +	spin_unlock_bh(&queue->lock);
> +
> +	if (pages >= queue->memcg.pages)
> +		return;
> +
> +	/* Shrinking cannot fail. Keep the packet-path copy conservative meanwhile. */
> +	mem_cgroup_reservation_resize(&queue->memcg, pages);
> +	spin_lock_bh(&queue->lock);
> +	queue->mem_reserved = pages;
> +	/* A final drain may have happened while the refund was in progress. */
> +	if (!queue->mem_stopping &&
> +	    pages > nfqnl_mem_pages(max(queue->mem_limit, queue->mem_used)))
> +		queue_work(nfq_cleanup_wq, &queue->mem_work);
> +	spin_unlock_bh(&queue->lock);
> +}
> +
> +static void nfqnl_mem_work(struct work_struct *work)
> +{
> +	struct nfqnl_instance *queue =
> +		container_of(work, struct nfqnl_instance, mem_work);
> +
> +	mutex_lock(&queue->mem_mutex);
> +	nfqnl_mem_refund(queue);
> +	mutex_unlock(&queue->mem_mutex);
> +}

This is rather complex, do we really need all of this extra machinery?

I had hoped we could do the memcg equivalent of

vmalloc(4 * 1024 * 1024, GFP_KERNEL_ACCOUNT);
on queue creation / instantiation, and vfree() on instance destruction.

The only minor inconvenience is queue limit reconfiguration.  But that
also happens from process context, so it should be enough to just
do the equivalent of vrealloc; or, if memcg precharge cannot easily
support that, just vmalloc, then vfree(old).

