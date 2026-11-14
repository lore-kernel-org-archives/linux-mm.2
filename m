Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91C90606A32E
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 06:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=lO44GlAL
Received: by kanga.kvack.org (Postfix)
	id B03256B05B1; Sat, 14 Nov 2026 01:02:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8D696B05B2; Sat, 14 Nov 2026 01:02:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9542A6B05B3; Sat, 14 Nov 2026 01:02:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6CD2A6B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 01:02:20 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5FECC036F
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:02:19 +0000 (UTC)
X-FDA: 85432679598.09.A8F95A9
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7BB37C0005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:02:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=lO44GlAL;
	spf=pass (imf22.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794636138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cSnX/lDPO84uhZYL3He4tA7vIj3wFfw46jJJRk/azek=;
	b=wZ/cS0TjOfYynwN0wvE+aeZuze7UylvR/KprNNUMCQw/AAy4WtB7A2mEBL9IZA215pGf2F
	MRwGhodxQsH3h6Ya0+S6sn+iYfi/QM4/tUMjAsUHjzrbRJ/qR2HO3sTmCHvk69sp9/Q4DD
	8N8NCvbQQEZRHdPTgtOAeiowDQM0vP4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794636138;
	b=Sto/IGu1FhQg0dkYwgXBp2r/TJZyEn1zUKuQk/WoUDHp5DQos8/acNzpy9/9ehxxPVca2z
	iQ1tsunpMC9C2tFzIb93f9Lgbj8qyXYhIwuidNUYd3KM2QpzhCzWScgbR19jrMfjn/69bj
	8W4vO6zkB+HjQojXhwQKTKyp0pQ9Tcs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=lO44GlAL;
	spf=pass (imf22.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=cSnX/lDPO84uhZYL3He4tA7vIj3wFfw46jJJRk/azek=; b=lO44GlAL8BpSDnM8BNoovadxIu
	kAYTKzZ2GcRv8ke2DTiZBmoU8qAc9Gmf/kd3E55EyYB2xCW6TtsbGISk42BrLz331ClG0UoQfZvn+
	4auvUXT6EE2wAtpNt8mx6uL+OVlAFX+fTawjVAJZxyHVjUn9BzTjiIs1hm21tGhKnZj73IbrCX0G4
	D28d6zQjJvDtpRQ0PjQfLELliQgEE2D7uVpZT/YOVjexkLTIa9KFmRP6K4sTw0f/E/CigGQbzAYxi
	GlMfGlYzO1qGiM2mYHWhI/bySErpwvOu1vASJlj0GqJoA3qcaymyhMisJYSOPowGF5FVFyo9drTOM
	43TEQRbg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xS6q7-0000000FWJ8-3fe1;
	Sat, 14 Nov 2026 06:02:15 +0000
Message-ID: <aabdb561-881a-4824-9d85-860528a99099@infradead.org>
Date: Fri, 13 Nov 2026 22:02:15 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Docs/mm/damon/design: replace "same to" with "same as"
To: Enze Li <lienze@kylinos.cn>, sj@kernel.org, corbet@lwn.net,
 skhan@linuxfoundation.org
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org
References: <20261114055436.5546-1-lienze@kylinos.cn>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20261114055436.5546-1-lienze@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ig77grjbq9rfcxassedenxm66q7ozbtt
X-Rspamd-Queue-Id: 7BB37C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794636137-448021
X-HE-Meta: U2FsdGVkX1+/Pm5JhWG3HhzbzN54AZKU4Hdqx21AqluhpjhABo/svhW7eFf0zOyScdNTsOkmtjiyhON9C1FAPrAnknxo5KMELBMW/XwFNYDYqLoGUW3XUb4NA00eQFuVfvR3XNz66OCUQWpyqQbs4tXO+koINtRmD2w3BLQCvv097MusQgGTdn23GaaUJAdiMnM1mOZD4fIQcYm/CN0AOXQAZOtIp+WzV8j0Wsv7VT80ohX1jdkLf9UPDCyAe9XP5RHkSL0MqNjeFEmi6yOWxGoKA27m39vPWv2x0YXCtdgQx0UKUBzWH1UeMBPZIpyRQpqtJL9bOeHhe/Nqsfhu6EmkchW31wp4+e0x6g3lllFFzk1g5bvh6XxE6b3NotW5i1zPNRUhxAEq3bj0GapM6dbY31G0QyarE0Vwfkdc+li31/32BG2KP0LXI35XoSCwnVd86Vmxi9PyXiUL9d0DHsSwrZFiNuemNMKIN3a6HUL1ZKEoZlLjVURljuuTisvY1oyebyiK49IiA9jXlrgDEHdrMs6fzXE/PEBMIwqfDzsNyAyhl5ow0Yzi96OjcKIg3R01H3KDWC3u1GXzY+JoDH9MjVCn0QuGbhVI07P3ZgprjLSf6qfbYB9EWXrY08Lbd7RcdJJjaxJ7hkd8AqkyRBRP/T0HTgA0hqCtqp6RSj+S8fyvNILemsJ8qjZCG+UdKLpTuXF4PNxSMjc2a8KiWFFjtyoDkQ5NwPuVRacGeDjQhjoZ+zAlDpq86sM1BBDBJp5p4cSOXGBBBbtrz/Tpf1D774vZZ3RWtxCpE5BaBeC7zRFMzwMWK1b6d9vZ1UBtviF2GF3kFf9sPUMFwwPBxf85b9v7BmSfa5TfRwg/YttIIjeWjIJGnrMC7V8qp3mZhk6MGyDWS922ZBp3F87SIYMLk7w+QIhc8SushRBKtJvGRB3P17e0cqX0x768Xtt70M96T4ZtFJHR7V5JNj7
 zDbjnlD6
 tobPvlqgZmwHCJ+cVSU/QdGwY++5h3yg+82rCHFZHDhoVfiBUi47WCc/2bN6BNS/wxng3oF/iC2KPM66gKxo1b4EEPw77+4pR9yiFF0F/pwQUqjncjk9yNCcIDNafcoxGyeh2IMbqyjG31X4/ezr17SwY2XZwNHAn8WU23AHduc3PQEGbjvyqYVfPqMdIayYwDqRkotW7dQzDBcd0kmBJGDhz2YqLBaIFJZ6oc36AG2IRZqCjPaqpuQDK50SBIkpCjdT1+d4p1QPathpHLxaPx35auEgDNAXNm6FcW9ZgwgKlRLS6CZKceCUgpDYQKqcc2s90GcNVKkIDLLVPOapQ1of4/wuKvaGlIiRRxHP+pAcRlWQHK3DjWTciAQbslUtBp5r5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/13/26 9:54 PM, Enze Li wrote:
> "same to" is not idiomatic; it should be "the same as" or "same as".
> This doc has six such usages.  Fix all of them at once for consistency.
> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

> ---
>  Documentation/mm/damon/design.rst | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> index b676be697158..6284b9005443 100644
> --- a/Documentation/mm/damon/design.rst
> +++ b/Documentation/mm/damon/design.rst
> @@ -292,17 +292,17 @@ DAMON :ref:`context <damon_design_execution_model_and_data_structures>`.  The
>  registration is made by specifying a probe per attribute.  Each of the probes
>  specifies a rule to determine if a given memory region has the related
>  attribute.  The rule is constructed with multiple filters.  The filters work
> -same to :ref:`DAMOS filters <damon_design_damos_filters>` except the supported
> -filter types.  Currently below filter types are supported.
> +the same as :ref:`DAMOS filters <damon_design_damos_filters>` except the
> +supported filter types.  Currently below filter types are supported.
>  
> -- ``anon``: Same to that for DAMOS filters.
> -- ``memcg``: Same to that for DAMOS filters.
> +- ``anon``: Same as that for DAMOS filters.
> +- ``memcg``: Same as that for DAMOS filters.
>  - ``pgidle_unset``: Matches if the page for the memory is marked as not
>    access-idle.
>  - ``pgidle_set``: Matches if the page for the memory is marked as access-idle.
>  - ``hugepage_size``: Matches if the page for the memory is a part of a hugepage
>    of a given size range.
> -- ``active``: Same to that for DAMOS filters.
> +- ``active``: Same as that for DAMOS filters.
>  
>  If such probes are registered, DAMON executes the probes for each region's
>  sampling memory when it does the access :ref:`sampling
> @@ -706,7 +706,7 @@ There are two such tuning algorithms that users can select as they need.
>  The goal can be specified with six parameters, namely ``target_metric``,
>  ``complement``, ``target_value``, ``current_value``, ``nid`` and ``path``.  The
>  auto-tuning mechanism tries to make ``current_value`` of ``complement``-ed
> -``target_metric`` be same to ``target_value``.
> +``target_metric`` be the same as ``target_value``.
>  
>  - ``user_input``: User-provided value.  Users could use any metric that they
>    have interest in for the value.  User space main workload's latency or
> @@ -736,7 +736,7 @@ auto-tuning mechanism tries to make ``current_value`` of ``complement``-ed
>  
>  ``complement`` is a boolean parameter that determines whether to use
>  complemented value of the target metric.  For example, if ``complement`` is set
> -and target metric is ``active_mem_bp``, it is effectively same to
> +and target metric is ``active_mem_bp``, it is effectively the same as
>  ``inactive_mem_bp``.  ``complement`` is no-op when the target metric type is
>  ``user_input``.  For the metric type, the user should be able to emit
>  complemented metric values on their own.

-- 
~Randy

