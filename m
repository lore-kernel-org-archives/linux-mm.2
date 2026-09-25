Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCEFAC9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 13:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C166C6B0093; Fri, 25 Sep 2026 09:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9E086B0095; Fri, 25 Sep 2026 09:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A67D66B0096; Fri, 25 Sep 2026 09:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A2186B0093
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:00:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F3B83140666
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:00:45 +0000 (UTC)
X-FDA: 85252294050.21.48C7B5D
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf02.hostedemail.com (Postfix) with ESMTP id 258E880007
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:00:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Tv9kOHeK;
	spf=pass (imf02.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790341244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OrcFZRDnFkiDn+MYWmxCF8cD4rC4Rzquwa4PDTiGChk=;
	b=TSQwdLaPGmYhhMcq9W8TeT8MNiwsGQ5K10EqSs4DEJ5scXxkmkAKlcbUdPeNuuVKYep41K
	URFofFINXL7jMOf4ntejJ1g8Bk1jSu6/m7F8JuoBtrD0e7cXJeqorBQiBaz0hw1FJOzcHc
	V31mr1Cv9MrIWUW+DGPG0amdpExjKPU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790341244;
	b=G9Mnrsai+pCwwWEJbYM53i4dl19jker5zi4njCzQkMQXXNyu7BcRsc14sIDhmC+IBh5xVJ
	rWlcyUlfJiCV+njWSfqa9KeXlW7g4HbgGsmztvV7BHK1aWPlxUdQYdfc4FRjGtWUUQ8ldt
	ZbHndM5vP+ScSwl1Ly8cH+jWlwMy5iQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Tv9kOHeK;
	spf=pass (imf02.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2db22383fe8so2977475ad.2
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790341242; x=1790946042; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OrcFZRDnFkiDn+MYWmxCF8cD4rC4Rzquwa4PDTiGChk=;
        b=Tv9kOHeKIJSeLS9PgU2OI1p3J17A0ta2uK6Yd5j7UUgaObLCgqBIgBtewpi7Eeycrt
         AWltVWMVwzoYCVNvAVRQEIaqPbxp3F/H+/fFT4TUmYSUlc1Ww9LSp81bzrmKkSXGCLwY
         xLmnq9mFY7CmnP02B/2K5e7F3o08td10yWX82YMVF8bvQnssdQujsF0PgpdUdlfDeqjI
         0JqJkSwqunxdaAOjtjQYR0gQOC1b9NQkqt7lt5/0PojcOrqXaCL0wYx7RDT1y8W8vs3y
         oeze5pulHbKkQu8Nttq07/xgU814bi1JJOC2YFh8Fjk0rqpsieqJXsjtn1djldVXo/FV
         +c4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790341242; x=1790946042;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OrcFZRDnFkiDn+MYWmxCF8cD4rC4Rzquwa4PDTiGChk=;
        b=P29+50zyyskXTu3E4tC+gRdL6B2byR5LCLzGWmA4duWp1Fsf8Jdm0bYDSJAC6hU32W
         fp8hTotftiiKEKqG9f3J9wdv3ow2mker3b6c4ztqAsyEbZ0ZS/CYnCk9h4l4Eff0XbMc
         Pmr/Efh5O+DSK74Y3MJlMe9xy6x0wHnozfFP962cOCMuGpOVUuV+iuBo28Hwj5l7u1mW
         McZXH+wWZQjQb4lS7V7HW6pcus/dpVGUUX86G3D6CKRYXwi8cZYDrr3FnZYYvCGPGIId
         Ur/4i064JCQvKeqIE/tb+I2B1K921hn9t8Gt+2fu3uJPNPsoJA3PXXw3VKRbJ1jtbNZg
         M+Vg==
X-Forwarded-Encrypted: i=1; AKwUvByA1Kwy+qN+NJQuwX0tsGwH80XsyT6Qctg6YBngC3mMPnvMvC8NOYyfZj5eSaErNY3RNInVgRafcg==@kvack.org
X-Gm-Message-State: AFuF++k8E2Ox/T8FdeSl7ibse3xe5qg2FiZjBg5MQZV3/++Zs48vS4Z/
	LMR6Yf0qu7B6lXYkeSQvBlb5fy5NjAqE+z2WGrU/4HHwxAEk72Ih1Kb2Be+sCHUioGo=
X-Gm-Gg: AYBFou0YSP0kO9eWrgn6ZDuIyooGwwIjPkrZXcUBet2jO2noe6IOVxrbAC8y3chSSl9
	1TDfGLmYSUYzgxHJF1Ao23GtwDn2dy6FyLP3X/s4mB8uUu8q5eaehnxkVPDNWN4CrAlAO7c/N3f
	Sr5AKowXFPL0+KJKIMCko4wDgZhojvt626nGo8JlZ3GuXN/NgxOOwncpr6ofniNVEb4Kj3K3ID5
	NSxiHx1zakmmDsZWn4FmNxwbCHrWyMw+7+Cmkxm09qINOCh4DemXwxxRLbfvfqVpNormY/W74JJ
	O5nakazvN7+Q8wXvfheUKJonrKF/jzVCRzSnH0nRlVnDruSxZVe1rI5oOecLbyA5mL/5nP/ZSxS
	QZLk6b8ifuK3ZszPa0ArXUCZkioA3E7XRxtMDf7WYTsKXR2vkxKSaH/F89MbUpjVVusN6dFCcp0
	erVtV0YgxBJT8xqFbvDialH91vg0wn1gc4x8jT9I6aThDxzmy/M00G/BOyWi08iUCDaaf1Ywlnr
	APT90NWN5Qn8ROVexWVuJkBXBwFbQs=
X-Received: by 2002:a17:902:ec8b:b0:2dd:c053:82f6 with SMTP id d9443c01a7336-2df7deb7a71mr48844055ad.45.1790341241383;
        Fri, 25 Sep 2026 06:00:41 -0700 (PDT)
Received: from [10.254.237.61] ([139.177.225.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df913de18asm9819175ad.26.2026.09.25.06.00.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2026 06:00:40 -0700 (PDT)
Message-ID: <87e10baa-13a8-4766-8d6d-9173a4b0c5c5@bytedance.com>
Date: Fri, 25 Sep 2026 21:00:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/3] memcg,writeback: flush foreign bdev mappings
 separately from owner wbs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, willy@infradead.org, jack@suse.cz, tj@kernel.org,
 akpm@linux-foundation.org
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-3-sunjunchao@bytedance.com>
 <arYa1DbKNeAN-PLl@infradead.org>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <arYa1DbKNeAN-PLl@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: z1zhjgmje8miaq9dk6oq4bj3rthk5ax8
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 258E880007
X-HE-Tag: 1790341242-343106
X-HE-Meta: U2FsdGVkX19J3MraEa8ZPi9bfBz+ZVC1X4xXfj4L9a5l+qlWEW0vmW+WQw3coMUiRqf+VqCCXFBmSTDzB34xIaPvKiXZGMQEskHnJhE26O//TidoXt2F6GgYvn8XAmlb+h3BxkOprmifXBBuDVCKWhePQ9yEWSYeOEjgIYql7+WkDL02JsulgVta1UwODOfEk4vYiEom59OUK8W5XK0wU/gEyr5AM61a+klVYGmXs/WwsLI4IxaDphVYvbI9JGVa2fA0IVwU5sk24qE87SDL4S/K8D8M8EUQSFxLu83Cq+HvWiHrWSMIM7/d+fhr6lxltogW0TSFYJNdq6tC1ewnLpeW+djau6MezriSUuOobokmNE93XWQRMHlncAxzMQ68eXmyy+Qol09s6s93ZfpGkIftOPrZojKlA6V9sL9JxFFuwG23y3WzayNA0f88D3KSy1Qqo5uj7ZdD8C4d12VA0Ynqii+a3Q9GHa199OiklotP8CG0nt7HvWRIEFlheCR8vYQthL/g8PPDBA8bdqChKlJSRxBRX3A4xVRED8nIh15cF58xwl+s7yM/Ls017cA+j8Sv+Bp7OR1DtsLgpKjD2Sjf9jTJ3tRJ15zjOFH192SZ9guVrDC6xEt4EQvWVG2+ZgF+lNmzMmc80BSx4YkdgmxJLUjft4iLKubLB7lG43rmkiegnU1hWS7oovcQgBv51jM7Ii17IgZDyK3sQKzGQ1OhO+iSdWUtptkcIvzuLC0XnFS7P6QMqpQ+E02/JkeP+HwXemXa0An+l8SKF7c7/puo4OVtnN8Hp7Wj12q5zeQP3oc8YUf2yI5Hu0Yh+P9+oBoyiJax5vqZc4tZfoLjktVljb34VLm5OGRhgo6gajrXdxS2lZ4zYLIfvn5Tol45r6N74sgrFVZSUhEVkYJqBd3mlXdYlok3S1Z/ODxQD6magU8pMiUEb6BzaV0Sq3GOPR0Rx4uu4RhUpF41rsT
 I3IFEB3k
 ujZwZrQEKcw9tOHfmYIAQTeT+8wUCOF0rclHBhWsVlp5gT982tOXkLNPSmqBlRsmtDnXSY966Z87/TyVtnf63qRwAvyhr6HYnK9XjRZRv8KScXZSyO4O1GTL1/qdD4BNl21C1zCjh1CnAjjRqNbhh6hauDpzMpjFidEJ8ZNyhFd28tvtsEgbllSRkrntSL86nOYF+5+Jd28ASe9VcEZuY1duUc9mSrulUJN9nr5V3B6SV378UwQX6w1zSJ0iyon71saG4Ey7uTNSg87POjM/MmvKN5XoO5yStmGWVMqo073MiMP4UO81f9jIgKjLNgg6o5v0VAh3vfAGxJx8vQsp5HoKiTmJdMDBdlwwQ/m31qlqpXtYXPSzZ3z4Cx1ON1h2p4l4c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/26 2:55 PM, Christoph Hellwig wrote:
>> +/*
>> + * No extra memcg reference is taken: this work is embedded in the memcg,
>> + * and mem_cgroup_css_free() waits for it to finish before freeing the memcg.
>> + */
>> +struct memcg_bdev_frn {
> 
> No reason not to spell out foreign here..

Yeah..Andrew and I discussed the naming in another thread. The idea was to stay 
consistent with the existing naming and keep this patchset focused on the functional
changes, leaving a broader naming cleanup to a separate patch.

https://lore.kernel.org/linux-fsdevel/20260917065759.2643940-1-sunjunchao@bytedance.com/T/#m0d196c3b8376c9b51276f6c5d26ab9f29e170169

> 
>> +		/* Reserve the slot: it may have become busy after the inflight check. */
> 
> Overly long line.
> 
>> +	struct address_space *mapping = folio_mapping(folio);
>> +	struct inode *inode = mapping->host;
>> +
>> +	if (memcg_bdev_frn_wq && sb_is_blkdev_sb(inode->i_sb)) {
> 
> Why do we need a NULL check for the workqueue here?
> 
>>  	memcg_wq = alloc_workqueue("memcg", WQ_PERCPU, 0);
>>  	WARN_ON(!memcg_wq);
>>  
>> +#ifdef CONFIG_CGROUP_WRITEBACK
>> +	memcg_bdev_frn_wq = alloc_workqueue("memcg_bdev_frn_flusher",
>> +					    WQ_UNBOUND, 0);
>> +	WARN_ON(!memcg_bdev_frn_wq);
>> +#endif
> 
> Instead please fail the boot.  If we can't alloc a workqueue at
> boot time, we're toast anyway.
I followed the existing memcg_wq allocation handling here, which also 
warns and continues. Would it make sense to change both allocations to
fail the boot in a separate patch, so the policy is consistent? 
If you prefer to address both in this series, I'll make that change
in the next revision.

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>

