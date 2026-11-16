Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37495606A334
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 22:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DED06B05B2; Mon, 16 Nov 2026 17:46:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169646B05B3; Mon, 16 Nov 2026 17:46:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0317E6B05B4; Mon, 16 Nov 2026 17:46:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE3876B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:46:38 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 36AB8A75F3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:46:38 +0000 (UTC)
X-FDA: 85442468076.11.40F8299
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	by imf20.hostedemail.com (Postfix) with ESMTP id 54E161C000D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:46:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of fw@strlen.de designates 91.216.245.30 as permitted sender) smtp.mailfrom=fw@strlen.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794869196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jqSwoAjsDQRdlLqv7HFSYNZ2dAycXMwZNoLGHbmfdsw=;
	b=EvIcoJXrKmfzb53d1K5y481UQKrkonPu4fcWutpq1Y3AwCADr8oPI+CjKh07BOSy2GEw80
	6wKELUe7feALbqoW5E/gEu/bqQaB6ZLA5yGMszgYVjRfr5/BTtDkOAl6BXUcApfVvUnl2b
	6N4oyf2GrDCQI4oSdMK3g/QfQILOLFM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794869196;
	b=GX4dU5SRDCFu93x2+shA66Zv3oIyeyuPg+BK3F6syCmosTVdPZhVyJ0maXLf1jx0hufoJU
	a9oVPs3XPwCFEsc3WVUAszO6w3xmYp1inuYwEIurxsKtpFktGldn+i9v3Feb3Gd5Hq6Lbv
	C7HnlNL7JUNUpeRM72Jdw/4z36yrph4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of fw@strlen.de designates 91.216.245.30 as permitted sender) smtp.mailfrom=fw@strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6663260D56; Mon, 16 Nov 2026 23:46:32 +0100 (CET)
Date: Mon, 16 Nov 2026 23:46:29 +0100
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
Subject: Re: [PATCH RFC nf-next 6/9] netfilter: nfqueue: account saved skb
 bytes per queue
Message-ID: <avuHxb9In-dIYj_G@strlen.de>
References: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
 <20261115-b4-nfqueue-memory-accounting-v1-6-b9cc30819997@asgari.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115-b4-nfqueue-memory-accounting-v1-6-b9cc30819997@asgari.net>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 54E161C000D
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: sirgydb7bnzp9pafb3oc9gfuwoqybuat
X-Rspam-User: 
X-HE-Tag: 1794869196-75065
X-HE-Meta: U2FsdGVkX18lqsPkagdo+lU24BOwCQvFTuYHASEPud2Mltg8VJqAJK/UohKXsY/dRzyP4EiUt2CalKey/7QkhvTVYyDIoi5mLSPUGIhYO57OYnW85Z7Dz2Y+GxWlcyOkQh8FGwB+IL5+Nh3bqjAhL8aFEif2vMxAsaYPm0kbkCirB+Yk9EhH4oWQuFE9GI6BZl7ZbWE59u+Ak76YGILD9mfwImijzxEYnqRYKTjs7JIwT6wUjG950Dmr+XgMAd6CKN7C2O+5I7sqCgF8MKwVJ6IJYHzyIkNQdTUh73WVCMpSSBEpsfGnt47giWjvZ6a3q1g6+q93VCpSXIwjgppjIms+XLSjkB0alJk+ZIvu2Vur+IQnhcY364yGndGciJ8SMtjIapsZfY6rHRpjNnPT9XbUTl10PKr3ElHf5tyNbMncWGkXNbuxP463kxM/YLI/hDh9SvD888JZdvAIu7FmY/cDINc0BO8XLOhpaF1BohoRFFZpDl5W6pcroaiK1u0ZTxA0/hON1MOTo8rbPLnTZ5uh9ZBRHN8Za19eeb33bZg9Fnoo3FlzKky8cm3cQpNK2IXeHhuwdg5Ar+AE3NDy1eE1UKMG7KDdSd9HyCy9uHrYpv/xm1z6bAr/+cHLMD53JsNwLIBMnSkHGQZelDDDUipVbzy1w+F/kxfx5E6WVUF/EBscwCWmJaPB0hrExvtQdm/SXQrmCd3sFdmp7i8slRtSmnCzbTpvlxufvQRpz7EBp27HAVcizF6pWhpu/XxyRAfdw7qDiI6hU4IZVkjsf36XaE/EV7t7LgIkHQDY3WdRSObzPgeHwULZQXNDnFK1zxt/HCxMEtIgTCMct2jFaphv/pqlKdbVs92Vvc70z64hgQ4Jt7LKo+tz+z2TVDb54flHV27pQJq+tjKr6E8eQv5vxMwocV9mYziknVihOjg0pGSoGAUJskyn/wV+e6hGGTNwRO+xwtVHX8AnVhw
 cEjPaOlX
 QjQXD+/nQsDf+aAIq+PY1LIY/cPCn7JoB0Mv0lnIX8h4jDASbEQtxPLhtpLIUaXp/+iXHDyiNaQcn5XeealJ48RcUN9crPQPUjduA29jJmyZAINp7SGHGw5WwvRH0/CT1YZTroRFvFNmP612gbo68yl9JyH8AnYH80Sx4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Alireza Asgari via B4 Relay <devnull+alireza.asgari.net@kernel.org> wrote:
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -92,6 +92,8 @@ struct nfqnl_instance {
>  	unsigned int	queue_total;
>  	unsigned int	id_sequence;		/* 'sequence' of pkt ids */
>  	struct list_head queue_list;		/* packets in queue */
> +	u64 mem_limit;
> +	u64 mem_used;

I think u32 is fine for those.  Or do you see a use case for 2**32 mbyte
worth of queued packets?

> +/* All release paths use the saved admission cost, including notification undo. */
> +static void nfqnl_mem_uncharge(struct nfqnl_instance *queue,
> +			       struct nf_queue_entry *entry)
> +{
> +	lockdep_assert_held(&queue->lock);
> +	queue->mem_used -= entry->truesize;
> +	entry->truesize = 0;
> +}
> +
>  static struct nfqnl_instance *
>  instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
>  {
> @@ -152,6 +176,7 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
>  	inst->queue_num = queue_num;
>  	inst->peer_portid = portid;
>  	inst->queue_maxlen = NFQNL_QMAX_DEFAULT;
> +	inst->mem_limit = nfqnl_mem_limit(NFQNL_QMAX_DEFAULT);
>  	inst->copy_range = NFQNL_MAX_COPY_RANGE;
>  	inst->copy_mode = NFQNL_COPY_NONE;
>  	spin_lock_init(&inst->lock);
> @@ -199,6 +224,7 @@ static void instance_destroy_work(struct work_struct *work)
>  	rcu_read_lock();
>  	nfqnl_flush(inst, NULL, 0);
>  	rcu_read_unlock();
> +	WARN_ON_ONCE(inst->mem_used);

I'd suggest DEBUG_NET_WARN_ONCE() here, unless you have a strong
preference/reason for a full splat here.

