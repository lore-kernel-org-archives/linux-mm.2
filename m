Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19D14D3CC84
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 22:33:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F0C16B0005; Wed, 14 Jan 2026 17:33:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69E976B0089; Wed, 14 Jan 2026 17:33:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AA096B008A; Wed, 14 Jan 2026 17:33:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 46D376B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:33:23 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E117CB58F5
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:33:22 +0000 (UTC)
X-FDA: 84332021844.16.94AE45B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9B4CD40004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:33:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="IZV7F+9/";
	spf=pass (imf17.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768430000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bw+UUbbgHuxkE1SVwjm6zfIO4qzzzhxSHIjHJSRD/NE=;
	b=j6kFQJXOAQspqi1idT/asO1KGQ9dMVl2DwLjhS+F+GViuV07vUPqNyUOFbmbrIP9qeVCSF
	sfG8J7EorJjzMPcwwt9qL7aed5QzSidMo9WPs+BnLam71H2tnt87kfan2EpULIOeLh3jRa
	h6pQYhrxDKO12zMQydktfhvbr1vg/SQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="IZV7F+9/";
	spf=pass (imf17.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768430000; a=rsa-sha256;
	cv=none;
	b=YwczhOqHFGJS/7bUt2MuRDr8afDMlztWqALG90rIrixjPEG3eHg4gZ2DIG8ZRMsPjfk2gr
	TBoBKy1x7nnUc2AJuXPy5dL04Eud4y7pnWN+LJqluG3NTrqnga6AMMjciul/tsWiPG5KnN
	jdSeoF4qTBz+CbWTF2s/wOC6QomXNzc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768430000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bw+UUbbgHuxkE1SVwjm6zfIO4qzzzhxSHIjHJSRD/NE=;
	b=IZV7F+9/6H0UgDa4BdnVaC+7HuBp573RtJH8EFgAkGBZJDC9Hie7nyVqCoyeY2Ev1TiLWE
	byw+Am415CMeonrawYQlEbp5bLRxgZ3pnl5BTvW5iW4F6AroUxmPE2yoJBvCwWnP6tnK/b
	iO2CRBlVj0uVaJREMXTswRVNbGQxW4E=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-09Um1NR0MRagVPm6dBrXoQ-1; Wed, 14 Jan 2026 17:33:18 -0500
X-MC-Unique: 09Um1NR0MRagVPm6dBrXoQ-1
X-Mimecast-MFC-AGG-ID: 09Um1NR0MRagVPm6dBrXoQ_1768429998
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-94120e0acbdso397273241.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:33:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768429998; x=1769034798;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bw+UUbbgHuxkE1SVwjm6zfIO4qzzzhxSHIjHJSRD/NE=;
        b=OmSMqrLTBsLi+H7ULfg9hlhTqUF/SQ7fHbzJU2XOkDIAdDldlcpjAE4sTDxNyLXb7i
         B5BMC5omCzhoAqFIyBZazbxXMj8R+kSKdP09+afUoOVlLMYxf6lw/hpJ4Mm+weso0mKe
         VJnZnTl/jAxlo6x4SziwiYBFCzJVmSjPBVZtCu+U2zAPgZ9NBMaZLpX/yFS2vSPpFPGe
         jh0OznOcf8RFMrmqFiw362pUOAxOgbAV1EMGhGqbmU517YjlMydU7Z0y/P9cmwlvGcWu
         3dCm66VzsL/gJU1/jxj6GNj8D/gDxDxSlRqLyWzN+ZASZz4Vali4i94PEF8RLIBdPnHb
         Tbhg==
X-Forwarded-Encrypted: i=1; AJvYcCXRrcrY+OF3qy8RrbMBGV4ATW8glMAbxxIOczM/0u/Ewy/KcqVVcqFear7PkRN1SjmCcCdmMwO3VA==@kvack.org
X-Gm-Message-State: AOJu0Yxf2bchqG8onGcEtUG5l7CRGD+Y5xV+e+rDJWqoP9pxeQKVjvsU
	JInvUgnGvX8fBdKW7LC2/kF2RyO4xWjBS/DAcBQYB9QsNSiFYPHDZpWOfgSGPRSf5aA5uxQPB+z
	uc8PybK8PkpEvRC9zfFailHfcHWiyg+d1BSgRIyFCEEgx10z1qi0P
X-Gm-Gg: AY/fxX44uaf/PmsXQOsERWII3VsNRuv5+qDQjZjKT7lNagQ3YHcyDljjGcLyTPGT8/8
	/Wv75vK9fNYRtI1F0upMNS185j4ePKuQUKYmqrsnFBbFbPyLy/tUpndS7U3QNazS0OD+EExKUMt
	cbicLWLY5yMGv1MOQu3UyiM3P8Hl64qf+5Snqq6Ict3l41mOf44/UGaDTnD3A4nKW5y+pmYh9Qx
	Tlf+AudYPkxkCWRgvNZLLRJlZ23s9PPSzh8iz4WiNSS0HvSHBmJiBcmf8A+lPhw3T5zpd8khUxb
	yVsPB3Q1r5RCuqDxiu8TMXpSsXgYLMJBdYlnkM2eOci9QaSvymBvHj8SmMnquDCYlu4GNWcx+Y7
	5qyuzm7wjO91KTDNLOR0Zw1BVjNNVKE0Sw/pXcIjAluKIl/v71wiVAqy8
X-Received: by 2002:a05:6102:5801:b0:5ee:a184:35c8 with SMTP id ada2fe7eead31-5f17f638b15mr2072336137.30.1768429998155;
        Wed, 14 Jan 2026 14:33:18 -0800 (PST)
X-Received: by 2002:a05:6102:5801:b0:5ee:a184:35c8 with SMTP id ada2fe7eead31-5f17f638b15mr2072327137.30.1768429997810;
        Wed, 14 Jan 2026 14:33:17 -0800 (PST)
Received: from ?IPV6:2601:188:c102:b180:1f8b:71d0:77b1:1f6e? ([2601:188:c102:b180:1f8b:71d0:77b1:1f6e])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-944122ae554sm23610471241.2.2026.01.14.14.33.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jan 2026 14:33:17 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <51675d7c-5c9d-4596-8e5c-692c90b79e06@redhat.com>
Date: Wed, 14 Jan 2026 17:33:06 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] cgroup: use nodes_and() output where appropriate
To: Yury Norov <ynorov@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, Alistair Popple <apopple@nvidia.com>,
 Byungchul Park <byungchul@sk.com>, David Hildenbrand <david@kernel.org>,
 Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Brost <matthew.brost@intel.com>, Michal Hocko <mhocko@suse.com>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Rakie Kim <rakie.kim@sk.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, Ying Huang <ying.huang@linux.alibaba.com>,
 Zi Yan <ziy@nvidia.com>, cgroups@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260114172217.861204-1-ynorov@nvidia.com>
 <20260114172217.861204-4-ynorov@nvidia.com>
In-Reply-To: <20260114172217.861204-4-ynorov@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Bdi7BH3M8KFk4lrOc91wAiQMHGjGDrAlmWTqxwGkqWc_1768429998
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9B4CD40004
X-Stat-Signature: uzxegmuhfjtdbud5t7y8oatr8sw3b4ie
X-HE-Tag: 1768430000-808659
X-HE-Meta: U2FsdGVkX1/bwEt9m8bONWCX78nsbm+hH0wuGjCVNHCME3b/XJvfn3LCZEVe/i7JGZugevqKowVAd8f4pJ2IIt+MVmA6e35Ww39z2IBlAYHth6cD6YUERkktfBJCvkaZWX0j4pvnvKa8lGluyprr8BWBfDSRukLWhSbZPNnWS+i1A7g9jtMcZPymhuhyUuYZS4h3PoCV6BA7b4rty9533lI8O5vGWXE2BXMUzUqL5vbp4DIbDelWRqkmSyPwypO2vkZrGK5JLw/93OeQgAgh81Jh/T7VXs/ScB14DSUBG2IBZH7ZR9B2RfBIMY8t8VLboeUvrfU4AMAHQ1Yd4H12UgMrWrzJm46t8c3Qu4+/yCvI6qkUu2ba7tcZkyQB3j7rSkfguISPED29/4/E6dWvDPe26D2tpVG5sQT/t7I8xBT48rvwPNFI9bZOuBZK4DOPRiqxxSOtwbLtTwg4+Sz/LqDSWIEl2QJzXfd6Vyiib59PFuBjdkSUp6XgHkZkWjuL8V35CeHnfOYgeUVLiQ8/OjMHGCqFWq9nONd+K+LPC3pc1iuxVwuh1LHeFrx255708GkazYh0HlTpT7+7pJZOVF5YMP+6tHlzZPjiyKqapkDEcq4MXBH7z45h9fT0aosJ/3trZRCde6q5u3c321GvjCiLTR/Nkbf7Pf/+6cwRTare/pE72Lv1WsemBbtPTIlHZxJTnkDTsJ28LwxqWXLAuMFkNKKtEY0h9aIwrhgHkXTPifqzfFMW94peHTSkwvqMdMTCjQxalmjqgN8mofUKnp1Qm93w3smB5VO2MhmlhtSEHvNEPbG7k4fHFtP+ilIQ7/nJmZOgGyLRA+QfkYbcUY7Gontuiq6G3UeIIulC8AK5VFNQBW6MJEA6hD88OxQSTi8xtWF7vdM2CH9eVT9DbVu4+DG4TanV22gfXRUtMOlEzkrQ55cFMidtfX/tEV5vBeedZ3x6Y2ghKJ/CRRh
 RxdZwXSB
 0IMvtANY7EkpzQh9qgjZMXT2CKoBxszpNU93vLoBNeozVl3VMcSI84ZhC5lgddI51w1IFzzf7EtvFwLTdU31rOOesHaCncwjif1yKzzEbC014aqUrthAsDWO8Fh9/w0KDr/iqpjklUYGZxsKHf7WpKqGREZ4K9QnvOnVyuaLB3hnxascr7ymMenjiZ9XC07f1oLU/EqBVnVv2uA5QQb1Ir5PyLklFU5/sogKPOU73DF2fR0NPD9Xrb6AFfezbwlZoJtbZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 12:22 PM, Yury Norov wrote:
> Now that nodes_and() returns true if the result nodemask is not empty,
> drop useless nodes_intersects() in guarantee_online_mems() and
> nodes_empty() in update_nodemasks_hier(), which both are O(N).
>
> Signed-off-by: Yury Norov <ynorov@nvidia.com>
> ---
>   kernel/cgroup/cpuset.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 3e8cc34d8d50..e962efbb300d 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -456,9 +456,8 @@ static void guarantee_active_cpus(struct task_struct *tsk,
>    */
>   static void guarantee_online_mems(struct cpuset *cs, nodemask_t *pmask)
>   {
> -	while (!nodes_intersects(cs->effective_mems, node_states[N_MEMORY]))
> +	while (!nodes_and(*pmask, cs->effective_mems, node_states[N_MEMORY]))
>   		cs = parent_cs(cs);
> -	nodes_and(*pmask, cs->effective_mems, node_states[N_MEMORY]);
>   }
>   
>   /**
> @@ -2862,13 +2861,13 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
>   	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
>   		struct cpuset *parent = parent_cs(cp);
>   
> -		nodes_and(*new_mems, cp->mems_allowed, parent->effective_mems);
> +		bool has_mems = nodes_and(*new_mems, cp->mems_allowed, parent->effective_mems);
>   
>   		/*
>   		 * If it becomes empty, inherit the effective mask of the
>   		 * parent, which is guaranteed to have some MEMs.
>   		 */
> -		if (is_in_v2_mode() && nodes_empty(*new_mems))
> +		if (is_in_v2_mode() && !has_mems)
>   			*new_mems = parent->effective_mems;
>   
>   		/* Skip the whole subtree if the nodemask remains the same. */
Reviewed-by: Waiman Long <longman@redhat.com>


