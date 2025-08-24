Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F9E7CA0EFA
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 03:08:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF91F6B00A2; Sat, 23 Aug 2025 23:08:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA8CD6B00A3; Sat, 23 Aug 2025 23:08:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBE6F6B00A4; Sat, 23 Aug 2025 23:08:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B613C6B00A2
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 23:08:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8226A5A72B
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 03:07:51 +0000 (UTC)
X-FDA: 83810166342.05.32E769E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7BDB740003
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 03:07:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KGCxe9w1;
	spf=pass (imf07.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756004869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=miYmcZ7PQT39UWbb5PapaKAE5Ak3MX6JFaE0vARmqPw=;
	b=8pfZBodwun8oA8gW11qOvI8lNxTUJZFEk03qDth1G9fzrvucEfP9lG5J2QmwpilCmb6/Cm
	z5I318YGVaoyTiGKrt+pgiQRbhILVuPatRTcTfguwIZ0r74wGVDLjjob7cv95Lu2dAXrBv
	MsWQvcj/X/sX+IVJWgO2rNVHlBSb/YU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KGCxe9w1;
	spf=pass (imf07.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756004869; a=rsa-sha256;
	cv=none;
	b=U693/ruSAlq1eHZxno5riOB4j2nnNZ3l8pOwQ+S6AjYY1VBOU5e86O03nSBrnAuK10cqhg
	GIVgcKrGo0AZcqAPDPC/Qnycdcllke/tllNBlWqtyvIh23+fhW+F44FYa+t5JQmOAC7f9m
	JyPwD8yPpptI7FuAnsuPP0Qf8R/kSKE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756004867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=miYmcZ7PQT39UWbb5PapaKAE5Ak3MX6JFaE0vARmqPw=;
	b=KGCxe9w19OEOv9IL6HgjxCbQTYadVUsP+Jg8Dt71M094r5MLbFCmvvRpCvPuJh5KVnlmaZ
	1sREJPXl0yx6sDAhX//19LWR8lsulpOwtXXxBg7GXH1SnFD+SaXhl+xxX3vIy6XrJEBfRB
	1wCGwr27KcFBmWglxdU78TC01GbuVAQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-211-tR_AURjPN1Wuh7rvfLaEWA-1; Sat,
 23 Aug 2025 23:07:42 -0400
X-MC-Unique: tR_AURjPN1Wuh7rvfLaEWA-1
X-Mimecast-MFC-AGG-ID: tR_AURjPN1Wuh7rvfLaEWA_1756004861
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 74DD4180045C;
	Sun, 24 Aug 2025 03:07:40 +0000 (UTC)
Received: from localhost (unknown [10.72.112.99])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CAFBE180047F;
	Sun, 24 Aug 2025 03:07:38 +0000 (UTC)
Date: Sun, 24 Aug 2025 11:07:34 +0800
From: Baoquan He <bhe@redhat.com>
To: Vlad Dumitrescu <vdumitrescu@nvidia.com>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: fix race on alloc failed warning limit
Message-ID: <aKqB9sGmgJwsTXGg@MiWiFi-R3L-srv>
References: <ab22061a-a62f-4429-945b-744e5cc4ba35@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab22061a-a62f-4429-945b-744e5cc4ba35@nvidia.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: 7BDB740003
X-Rspam-User: 
X-Stat-Signature: jbmrz1451hbp5sdgjac8m39rph87bec5
X-Rspamd-Server: rspam09
X-HE-Tag: 1756004869-131321
X-HE-Meta: U2FsdGVkX1++b4UYEyJmW+hrt7Mrp4p6ZzkR+oj9MPRfHZecagSGeGh3CEumrJSitpV3feKie3C+PbG5NIhJH60TRQ6zO36QXQ/m1jswwo5FclAV/9Mj0A8I5foVLz3cCHGX96/A9MbQbHNB7awuP2GcCAaQZNuPAdDaaiqNl991n4edS0a3oenKPiKAAcLeBchjpxuUw49a/85/u+zHFdnDKmIfhXv+mR64U+LpFeHfzZqYgLjZtxmi9ylCwo11zxBPhuQE/iJHH1/+ZScrAnvReR/OBJo0RhqGi9eQfq4Aql+wcjSkVcSBjNVFJKEDkth5UtQo14cEtWojFKsoa5E1Sn7ZW5gR0tcgSOFA4Wl73mwZjKwswai4LKOYdJLOl2KLwxMpQRq94v2vZvL5MQq5jhWO4Pf0uMCbXHxWmidXVKDGQQg8eTYsNXdKAw0TxuNTNs8Cfe0pfE1s6/rKXQqZ1GooA7UL9dEq08vvcaQ3P30dkRwaqIHLIP8voLGun+NJ71dFgLmcZf6afUQQncnGP49uDKakS4t9iRef52BQlsFcLELIpSVaGXDpu+qeKbAuczkGKhvzzdkwb6Y9EsyM6PZR2kSRyNC/amOrHRmOqjIf62atM5Ly335ef2hpRRDT/UQglUoyqzWB6vFYMlT/GfVbEzAu9zSf3XkXpqtT75bH/uNz54euGJxVLBynES9VX6JzImq9IMxgmmVjyjWXoVr/r6cLe4pDhle+oh+quervjXj79MmSPx3h20NRf9A92ISJaBnJd/PqhcT4OCbl0Ew/T/8U8SXKfS2XiWv9JPp8BqoWrUzu05USML1+StOThQm8yf9MMde0YxJidDqEyCylYruXn00hUqnOh2nF7bkaYfOwVsiYjchA3zsZKHGgfvWywczecU+25DpKrGsMVnOXuO6dv4wyxgpX89dDALAgtZn175B+jxYRZIGrBelZ+IJNfuMAyr4LNuP
 cCwR2X32
 Hl5coLnWnMS6B7pr4p5wk56rHb7Ov9pP1MWPssTToOewGePpw+tlCFZApUfApg101v1cosN/q+PGA4QaE07kkYov+ZE6tqag8AVWrRNvZdslI0YcxPO+aP+dJrN5RmgT0kdCXZTmfOXrDOSQOhkQ9v1AFxwhevM9Gp3ZM4Y2JSuv5e2MYqUovq0TRD1noPcVuV0/iIqTU724IpSBCFweGtszSCWTRtw0hY5CT9Ft3OoB3cwjdjKGIkab1LxMlsYwIyjaEzb/kXyktCAAbcU7fwvCfhEjluui72fHIabF6DghgTpyZR3nghw5EIAfVIY0yV47GVOPqceyWRbnebbaucDpQdntAd2ncLlzTJwx3BEbSj/dEBRCnfvwahAQV1CT4yI6dx8FEUR2VxFC+nPnjI16hQcBET6E8vm+iJWoMM+Qzwz+CW2KsXrc12qZcN1Jh3aYi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/22/25 at 03:55pm, Vlad Dumitrescu wrote:
> The 'allocation failed, ...' warning messages can cause unlimited log
> spam, contrary to the implementation's intent.
> 
> The warn_limit variable is accessed without synchronization. If more
> than <warn_limit> threads enter the warning path at the same time, the
> variable will get decremented past 0. Once it becomes negative, the
> non-zero check will always return true leading to unlimited log spam.
> 
> Use atomic operations to access warn_limit and change the check to test
> for positive (> 0) as it can still become negative.
> 
> While the change cited in Fixes is only adjacent, the warning limit
> implementation was correct before it. Only non-atomic allocations were
> considered for warnings, and those happened to hold pcpu_alloc_mutex
> while accessing warn_limit.
> 
> Fixes: f7d77dfc91f7 ("mm/percpu.c: print error message too if atomic alloc failed")
> Signed-off-by: Vlad Dumitrescu <vdumitrescu@nvidia.com>
> ---
>  mm/percpu.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index a56f35dcc417..c1a4089eb4c3 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -1734,7 +1734,7 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
>  	bool is_atomic;
>  	bool do_warn;
>  	struct obj_cgroup *objcg = NULL;
> -	static int warn_limit = 10;
> +	static atomic_t warn_limit = ATOMIC_INIT(10);
>  	struct pcpu_chunk *chunk, *next;
>  	const char *err;
>  	int slot, off, cpu, ret;
> @@ -1904,13 +1904,17 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
>  fail:
>  	trace_percpu_alloc_percpu_fail(reserved, is_atomic, size, align);
>  
> -	if (do_warn && warn_limit) {
> -		pr_warn("allocation failed, size=%zu align=%zu atomic=%d, %s\n",
> -			size, align, is_atomic, err);
> -		if (!is_atomic)
> -			dump_stack();
> -		if (!--warn_limit)
> -			pr_info("limit reached, disable warning\n");
> +	if (do_warn && atomic_read(&warn_limit) > 0) {
> +		int remaining = atomic_dec_return(&warn_limit);
> +
> +		if (remaining >= 0) {
> +			pr_warn("allocation failed, size=%zu align=%zu atomic=%d, %s\n",
> +				size, align, is_atomic, err);
> +			if (!is_atomic)
> +				dump_stack();
> +			if (remaining == 0)
> +				pr_info("limit reached, disable warning\n");
> +		}

A good catch, and the new code logic makes code more robust, thanks for
the fix.

Reviewed-by: Baoquan He <bhe@redhat.com>

>  	}
>  
>  	if (is_atomic) {
> -- 
> 2.49.0
> 


