Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9868CA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 14:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F413A8E0003; Thu,  4 Sep 2025 10:25:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F18E08E0001; Thu,  4 Sep 2025 10:25:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2EA18E0003; Thu,  4 Sep 2025 10:25:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D25738E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:25:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5AA15160243
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:25:56 +0000 (UTC)
X-FDA: 83851791912.13.D72B0A0
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5E5CE40005
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:25:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KoYKVkq5;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756995954; a=rsa-sha256;
	cv=none;
	b=gUgTpWkROqU347HKlBmlYJrmHfuS05WJMkEAxSJODS+SxBAXKFyGnA3k3B5/RU6xFLTrpq
	1Ds5meP0qh5lgFTfOtUqkzbGRnj9YxQ6aUtNUWGQ7WTQdOW2nEZQ9eCQKVbNJfGww327WZ
	51m+foyS+T80AHKGOu+HifxCmMyGpWk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KoYKVkq5;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756995954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXJTPFJKvzfDx5OZSoiIrukQRae9EDXqZs5oGvFGUnQ=;
	b=Mq0AJb5wv62Bzu0VBZRXhCVBHEG6tWek3TLzWyKAtGK3F+yc+/YxiFEf6rJoL6DID7Xpi4
	/jqRAnix0/KNC297XEnI8d/DCcqmqkvzBp0m8nCluyQI6v3ppPR/usFB5CXGQyb7g8T3lQ
	QBhw5KqOdhHi3uFovAzvNaE40Yrl+ik=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45b7d87b90fso9441365e9.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 07:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756995953; x=1757600753; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TXJTPFJKvzfDx5OZSoiIrukQRae9EDXqZs5oGvFGUnQ=;
        b=KoYKVkq5lgMpw98kH4IVTng5aXyKVWQaMlCThHrVugzVyVAuwlCF69rRdmZY4LuIUm
         4mEeo2cR0hosSSccemvsHr/E3t2ESLqI10BQtBLnb1h5Nv1PyUz6FwuflAWYipmt0Q9z
         qKC3Q2PpvA3xCjKkwSGq37VAVNurPb9q2uIiE90sqi3DBrJOR5ZtWJukg1aQB0ujYdJn
         gT0NbjK94SpMdSgj1/8AoWzJfi8uzvTcW6nt1438o/DQkDDzSwLPlHTU1nReZ84P4pgQ
         us0GZZ0TfcHIAXGcw8ocM6Pb9OmTX85WgWfD5gCMQY3HoNAkQgsj/t85TvhL/DPjXzBQ
         0Suw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756995953; x=1757600753;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TXJTPFJKvzfDx5OZSoiIrukQRae9EDXqZs5oGvFGUnQ=;
        b=Ol2bfTFEazMgdeZB7jnfJFPj3fwQt0pNeMlRj5x7sdvz5tM+6Yr7Z5//i7vUtvI4vq
         TMFstZlQGrOiQBkhBSCyFF2oYBHstVo6LDfKfK+ALmwQO0vlaVEeQD2jTuBv3C9z7EUW
         ZJbakn8RnmgdOHBcZnXrNqqCWz+hvlUzYe0K/IsIgqSvcUb8qjJTbNSbs1EK5NPW9eEG
         9I5FXhchGH6LOT6nBxxDWbA+2X3GNeOqJkwjda3hWODtQWX+JHDNVI6PQBfmM4NeYSRu
         YFw2IF98+Kr+a5P5/22DHIeg/zQIc1oAMGy2g6m9mFyuDsNDPyvBrGSp5aQTgtbSqiCc
         1C2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXwpQiNy+1ZbWNdNk0XzRrNE4wQfVYkAMC/Cl3d4hMy+zylScDLHWZvhUKrKp35bOkM6KuTS4j1rg==@kvack.org
X-Gm-Message-State: AOJu0Yy1iiw3g/KXWajxOYOz28NGnGgv7y401iTTmyeDtbDTIBZQ3dBq
	NC/auK7PZuudh9A7w5aI2qe0+iNewPg0VBiirWkYl95VieU23NX8A1Sj5ERNo7HexyY=
X-Gm-Gg: ASbGncs+Ia35ysS+1gScuxsjQlneO7ShQHZJziSNKNd7/W3Z4c1Je25d2Q2zLdJt+np
	Dha8A8h+oQ4rCeC6kYCmPj49PQeTq1XvWafHQlpi/aNarjoSre8YBOev8fSwpS1rs/CPBnQ0d0N
	c0G/29JvxYCQ7bMG82v9n0SVGLbieqMU1XzqFBZMX0tepc/DLOI4vUqtu/a3G1NTfKDcd0m8jt9
	cUTxad6dJlugj57CfyTPeapxztXkVnEAOJtSxh8xtUt+vWTMtz2pmL77TXLxtwTfFmA+SRvjMEY
	QTbBGI+h0fu9di+X5Ui4JdK9LFsELdWcZEEMctqmFfRMMfBtx349AONpTgQvuC/png6+/zkTmf+
	zPgUZOoouK8Aj8cJjFkkMxPjW+AF8FYPWW3z3VUEVyac=
X-Google-Smtp-Source: AGHT+IGEO+0DMHgMdm6ZrKhXV6osEE1ZqnkT+7HfsartMPcj/1fM+gmIyotmbXQVSvGO+oewXkAYhA==
X-Received: by 2002:a05:600c:4817:b0:459:d577:bd24 with SMTP id 5b1f17b1804b1-45b84c3afa3mr112855515e9.7.1756995952630;
        Thu, 04 Sep 2025 07:25:52 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45c447244c4sm91020175e9.6.2025.09.04.07.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 07:25:52 -0700 (PDT)
Date: Thu, 4 Sep 2025 16:25:50 +0200
From: Michal Hocko <mhocko@suse.com>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: rientjes@google.com, shakeel.butt@linux.dev, akpm@linux-foundation.org,
	david@redhat.com, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	linux-mm@kvack.org, wangkefeng.wang@huawei.com
Subject: Re: [PATCH] mm/oom_kill: kill current in OOM when binding to
 cpu-less nodes
Message-ID: <aLmhbjtF0Sp75XXE@tiehlicka>
References: <20250904134431.1637701-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904134431.1637701-1-tujinjiang@huawei.com>
X-Rspamd-Queue-Id: 5E5CE40005
X-Stat-Signature: gtq4kc1o4ko7nw1z7pfb5gbanb81q6sr
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756995954-20831
X-HE-Meta: U2FsdGVkX19Y0NkKZRuErBTTU9fo6Tk9+AQ6koCKQ9REI0oytYxn3sM/GTQpbiz5if4Zwt63Edp47yDR5o0qBqpS3Me/+xggsReemVbqcuPEol5u429QTw9aJ0Uj5ozBobCSz4JnJ8uKHCMp1lcwbSY90Q7b9mTc0kmOPK45g5CR5JQlaOoHVP03kTCOamBddac3o4GJdAfz8RwyxfrYTdQZf3EtS1Yu6NHfv5nU9lOUlYLnjJHLcOLNDNF5jmS8lGobeP9j40T7GC8WE9k8oQjmb8EGccLLMrtLz/3Yx76+L3/RYgeq6vbxrlDmLibP7O9NQfiJVnduBZuRTAKewF18OpzPa3i1svyTkfg/q+GbZmndsGFT0iFNvUqSwmltttuQD03+hfVLn7Y9awFA3z0KJ7EK5Gncr7BAoSEWswHMCS4U/dchFiSjdu2QVOOlaix7HrLi/tizesm/NjANZXLkBBPoc1tuHak4bevxDAQRb7+Qn7rexfmiSC6b3CWA0oBb7D5OprDqX8WISOVzf3ov+BW0jPfiedIFq+qIKeygU/9YwfE/+r+Y2tmmBt9PIpLLqrEeF1UwV0dXD6dEsSXpA9VX0zFnBUUQdjkmslC7r65hmFhA85k176FpMWT7T1mpyLWUqxFZkse7YS+83twWE13nV5qdHidZq8DaT8jPhztOG53Mb7wmv4MZI1zo9t2cq8ntLAs+b5wcsaVvHUHcvN6fVb4yNGoCmTCH3F4d/gulmHetB7gjxBXcU2ylgawJ+QIGqSiY9nvZq+oEJVnBNBSAPzlm08DwY1zJR7c/gvKlbnsLdt6SCZ8TyXbpROnxuGcRXe5np6v11v35NQ35mC/OK9pYZ4sgZbGSf+QwvotZ8SZzHJ59RsHUEI0Dc2H9otRn2YsaN9yM4OwRYiTYOphyWfgEQ6P2QMzOCccGYFgQ79QKi7dxy/pKsTVihzWUOHg41bLggxkvK2r
 vEgnksrg
 7mRq5Usek+IUr4UYs533tIn0czRyQTSNW7jLzzNKaEqWEPsgkS1gM5tyx83+kgl89aRmFJLJ8Z1tKnrMJ3nJvy7ZbBPxaJjWdwguXKgEV/EGAu/dYCFgdrWcTU57eaxgCUSG2M3gKB/LkXdkM1+SE2uWmXSZ66EXeaZS6Q1yihanBef7lriraXlZu1iWeU1CO+42vK7YoKNnPY/+w28Xls7zV6U5oFRC0O2haEjz6ihotl/9pDOX7etr83Z3AbxA1mXhqJw3DcaXtwlSs7ft7E0WxnhGWk6Thi7EzIn4pC69iHMrjhDkrrn77xtBxhUvhNMmvAlslHZ7ghs4xlE3Z7F0UoEN59mv56K2hyMeQIgk90AUwMsHLmMT+U7XCtIe8TntQWeseWdtu0NVQcYMwpS+s1SU1T9lhPDPVCMn6nCctn10NpOcmdokf/YgOnLVuzlxB6qLA/+VnAG8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 04-09-25 21:44:31, Jinjiang Tu wrote:
> out_of_memory() selects tasks without considering mempolicy. Assuming a
> cpu-less NUMA Node, ordinary process that don't set mempolicy don't
> allocate memory from this cpu-less Node, unless other NUMA Nodes are below
> low watermark. If a task binds to this cpu-less Node and triggers OOM, many
> tasks may be killed wrongly that don't occupy memory from this Node.

I can see how a miconfigured task that binds _only_ to memoryless nodes
should be killed but this is not what the patch does, right?  Could you
tell us more about the specific situation? 

> To fix it, only kill current if oc->nodemask are all nodes without any cpu.
> 
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---
>  mm/oom_kill.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 25923cfec9c6..8ae4b2ecfe12 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -1100,6 +1100,20 @@ int unregister_oom_notifier(struct notifier_block *nb)
>  }
>  EXPORT_SYMBOL_GPL(unregister_oom_notifier);
>  
> +static bool should_oom_kill_allocating_task(struct oom_control *oc)
> +{
> +	if (sysctl_oom_kill_allocating_task)
> +		return true;
> +
> +	if (!oc->nodemask)
> +		return false;
> +
> +	if (nodes_intersects(*oc->nodemask, node_states[N_CPU]))
> +		return false;
> +
> +	return true;
> +}
> +
>  /**
>   * out_of_memory - kill the "best" process when we run out of memory
>   * @oc: pointer to struct oom_control
> @@ -1151,7 +1165,7 @@ bool out_of_memory(struct oom_control *oc)
>  		oc->nodemask = NULL;
>  	check_panic_on_oom(oc);
>  
> -	if (!is_memcg_oom(oc) && sysctl_oom_kill_allocating_task &&
> +	if (!is_memcg_oom(oc) && should_oom_kill_allocating_task(oc) &&
>  	    current->mm && !oom_unkillable_task(current) &&
>  	    oom_cpuset_eligible(current, oc) &&
>  	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
> -- 
> 2.43.0

-- 
Michal Hocko
SUSE Labs

