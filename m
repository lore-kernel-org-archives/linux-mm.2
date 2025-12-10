Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37B89D2CE17
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 08:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 543B16B0006; Wed, 10 Dec 2025 03:05:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CDA66B0007; Wed, 10 Dec 2025 03:05:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 395376B0008; Wed, 10 Dec 2025 03:05:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 24C246B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 03:05:47 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA940C043F
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 08:05:46 +0000 (UTC)
X-FDA: 84202827492.28.CDE2730
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id D5D6140010
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 08:05:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IYyKLRy6;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765353945; a=rsa-sha256;
	cv=none;
	b=SA0wMJkUQrhn+vyjtDxP0obsx9TGzlRMfZhWPNH6AdlUNU67AcwwiQ6oxbf357NngH5VJr
	fVzXgStTh+CnPvD6Y8iGPcSNwsm/slN7kVhiz5NrIXsvHWJ13aCh5advTIld0E6U5zp+Jh
	VEAH9yKdHcjw0DHJMtgatdm8rrTH4L8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765353944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GQfsJf21ik2w5RavX753kN9D23TLoxAYXM2cGk1af+8=;
	b=MnRN0XHJlaBGcsMqWpgnGblDsW/RjDAbGiDhZbH6ol7HhvPCWGmsQLZicpHM9mgA4rE0NS
	w/yQlcy95I54ULOJMt3WBHPHebhBNF9qlMQPf+Q9sDE/sC39dtRiY4rx1koLy3UQ85MGYF
	mhqsvUlcIfC2KOqhNeJUAEq0EH3HWGU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IYyKLRy6;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-477563e28a3so4707075e9.1
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 00:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765353943; x=1765958743; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GQfsJf21ik2w5RavX753kN9D23TLoxAYXM2cGk1af+8=;
        b=IYyKLRy63YR1z9ZlK+8wgoWmlG+OVe2j6pRDCkDIyZUe95TNWmXjaNm7WAuB1J4MFE
         t6uADjFvCjPD7CuDqIdDtsIipzuFr7g5ksPQvJqamWv4FdyTT/ccgcP8mrZanLsDCOSO
         w7+c61SeKzZncF6bEQkqo6sm8nigM19kMuQfJPihhwwdN4IyY1BkB9EpENtgsCE1gVxu
         zaqp95qsS5zpIVezdrXxSJi3rYBz/3qKoySM9qYd4WK2oCbo2BVMxoB4v1RloM+WTXnf
         u6q78zdP5S0r/NUAHk7RPr8izlMgYjj8K/sDhA1Hpcnz/tm+VZVCR0fww4+nrHjImguQ
         qQ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765353943; x=1765958743;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GQfsJf21ik2w5RavX753kN9D23TLoxAYXM2cGk1af+8=;
        b=o+eunRh2da3UI0UnzYppDHROxYk6bZjkl7l1jegUAx7fLEvP6ZxCA/IiJYG+yipXaS
         X7jpDdJ5/0ZJKqeEQIoQpR2O7+U1rvN9epoJ+eh/ClRjY2tBi9JW+SkJfPYcIHwWgb3I
         PBnlcON04mTWBUpDa9PvL6Yng38zez2BgN3LasiIUApJQomJps5ymZnLvGJXZ/aGWRwl
         DgD1+966WAyldCO6eeygqx40L2n6bwyjskRtGiQw5sSiEWn6RHABJn/xzTvKo0XmJ+qN
         +qoXmJh5oLfpmA4nMPlwSRzqDx1sybLm3ASTRdZtQuiduhUw53Rjs4egdM1UlC3O7Esz
         DJUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWi7Ei0+yL3JnHyWtt32FgUWbTcB4AlMob3XzW2m0ssbmPnOoExCbiGI7Qlu1pvyVTISZcOPmiyxQ==@kvack.org
X-Gm-Message-State: AOJu0Yzy9TDprV9wV57BQ5embWxXsYNqxBtzitHw7KcB0fZRF6LWOTLD
	tlAxMJKHRTxn5+nQHDbwWa6cdY9LGnpAI3UMGuhP7+QubhPPiQ5G2+usQEusgExWg0U=
X-Gm-Gg: ASbGncvFI4WkSyS/EtcSXCfAzVb3YfaFw3BPd2cadDoHqWHMVBLB/gihaifsBOGfYpT
	YzAaW8xDE4ZaGDuRamIdDctdqwXC6+v39snf75jXk44eTUfxUxbJrBpBeml8M+3YsdS9R1ZYj9M
	dWOMSxhH6RM0MahjPoVUaCZgc92Y1VDLnoe5vLAiU/PVP6JUIHsetimIsdjEpcx1MQIiCP7EM1e
	scA9fvMMIdW8nAd47guY7VLRiiVdkq8yOf4/sEq3v+yCehmizCTGZkkkpgAneN3wEVUt/5egaTj
	h0rJLwvZ9Y92bxMEZ1qXEAeLFNlXROzCQFQ914bR28t4zJmdaM9pyjYAepnw+b0MhGZY5WKBbhl
	mHjMw7thfBzlB2Z+wpTBAmVXZTSdsAYLLUNDk2Jx3FKAHOx9V/Q+GlK6AXyuiT89BPtguMPS7HS
	uvQnosQn6IkRxwu6PmYxJUfXxH
X-Google-Smtp-Source: AGHT+IGvXzDH3zfRh7Jnwp4XKq7wlBGzq/g6vrlmPFCQLIHg1YyyhLYmcswXxMwGpDgJf701MMd8gQ==
X-Received: by 2002:a05:600c:3b16:b0:479:13e9:3d64 with SMTP id 5b1f17b1804b1-47a83934bf8mr12958385e9.15.1765353943426;
        Wed, 10 Dec 2025 00:05:43 -0800 (PST)
Received: from localhost (109-81-30-110.rct.o2.cz. [109.81.30.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a82d26f5asm29905245e9.5.2025.12.10.00.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 00:05:43 -0800 (PST)
Date: Wed, 10 Dec 2025 09:05:42 +0100
From: Michal Hocko <mhocko@suse.com>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	lujialin4@huawei.com
Subject: Re: [PATCH -next v2 2/2] memcg: remove mem_cgroup_size()
Message-ID: <aTkp1tIIiw8Nti10@tiehlicka>
References: <20251210071142.2043478-1-chenridong@huaweicloud.com>
 <20251210071142.2043478-3-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210071142.2043478-3-chenridong@huaweicloud.com>
X-Rspamd-Queue-Id: D5D6140010
X-Stat-Signature: wftu9ohkb31kz6fiadwr4iyrxm1ghbrj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765353944-504407
X-HE-Meta: U2FsdGVkX1/QNknZdUHwt2jjsX54KvHyY3C1wjJRvmk3gyNu5o3/3tuIsNjLV3GCP4ZU5AkVTvqr1vlul1AIBd2aK1dporzIoRe3BrmuLrfPhj+SvBY4OUEKiyq+FW05q7vNW9dp9V+AufZGuS2WnLoBw0TeufON17/RSgqEnrRWoOoT1BbmfztadoTALX3Zmedp3hvPMC8YcJg/kQC1bPvO2HDZCOKKdUVjtBs/jR672oYxLSb7HUda4UPc9lmf+cxSbGmLYhCDnnJ8WNNPIU0cBH0LuP4qCbj5b7JaWv7miEhCtEH68gWroVXxcMf9bJRu6l8mcgPpg0bcmmhdvob4NXPZhYHPQqr4UD6+KIIT/oL0Gk9zfRPzOV0H9Vedl5T4HxWQVj1SYyOwVpoqAgO8gjgzfGSYu+E/sac6ZgwPwUbhPnu/w0TNX3aiwNFz23jVm64Iop7ixBFpPjGsZevkH3P68uiwUHXAkoJBKMp+vTfBXrPyboWbE+ymS1ww68+SDIv9VpHO1UbNPK14BGCsCI6Pn2W0O/IK3RnkXrVHVKHIHeCThH6e1spHGIDEwKHlkrRQjE9UryZPVCCoUAbzBu4b5ObwAQSQ4RcrsUsgsBIAgu63bzB6SPoEzx89u4NpLg1/SXbzKJAaMbnLSk1zmtQmJld+W+72dQOrIsqB7vzsEZbnhkN+r6d5oxuSA+mZR/kusylppgKK/zeUyBjoXNqlZLdBQg9TGoYo5+7IdE9JC1J+Gm0kmhDTKWO55IqOp3SaDbxnd2eUBIbqCyjzgEfJIV5/7e8neKIB92Rxxdi0WkvKFmmqzyoE3mM/xw7sO8kzCB8m1j13NaGjTpFKXb6G2k0b3SmGwTmFwfOMOvS7zMhaGG4rsoUsHydyApSZgxyYp/tnIoJaDAo8VmOg7dS4lPU10HhVyzCtGI3Pm9uqICODfFEe83UUe2K7Tq+xeKyXO/rvoGchnWR
 yam6rL0i
 I24FaCcyz3aesfDBUWEPtC4ZAka4/IKGuj9i5VXGdz2MJAo6f8G4vqQh+8vVOgSGKp8LzMvnOIwAq6RLco8dr2Y4vWJdcybm7iK3otHDxnPjLHLQ9qi3zIaaerxmdmW3Uzs6MZbClnzwYYDxj9a8YOImMtMGLhd6XdfsXHNLtfy5zWVZsVzt12wT6CfVScfwU2/tF+5J5J2bjPyZKfSmjiWb+KAQ8uoi8ozBqNKjyAQkw66nARSYDRFv8cwS/XOKf0s1Ozsu07up99Po6hcGK+l6+2FoSVi57nC3CwNLD60+b7TuCy5Nt7uWpXyEhsfMpfYW2EzaCTpaHoMjfTFjWAYCXKzhRFq+rFAXulk19vMRWF8zhjZ6nTuRa1PwS372LE2GUlQdCSgMAzZ0DJAaHMeEP2cMsefd0iTl6jQjE8MnZS5dpPSKErNk/IfhBGfi9djluK1X1ga4QuWhDjNnohQrCVUoyzc0Pw+XxkBijIdRaYkSVwYEvl8XOABpG2fIGkKcE37IblkEqaMHPV8UqFl2yvV3j8oL9IaWL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 10-12-25 07:11:42, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> The mem_cgroup_size helper is used only in apply_proportional_protection
> to read the current memory usage. Its semantics are unclear and
> inconsistent with other sites, which directly call page_counter_read for
> the same purpose.
> 
> Remove this helper and replace its usage with page_counter_read for
> clarity. Additionally, rename the local variable 'cgroup_size' to 'usage'
> to better reflect its meaning.
> 
> This change is safe because page_counter_read() is only called when memcg
> is enabled in the apply_proportional_protection.
> 
> No functional changes intended.

I would prefer to keep the code as is. 

Btw.
[...]
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 670fe9fae5ba..fe48d0376e7c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2451,6 +2451,7 @@ static inline void calculate_pressure_balance(struct scan_control *sc,
>  static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
>  		struct scan_control *sc, unsigned long scan)
>  {
> +#ifdef CONFIG_MEMCG
>  	unsigned long min, low;
>  
>  	mem_cgroup_protection(sc->target_mem_cgroup, memcg, &min, &low);
[...]
> @@ -2508,6 +2509,7 @@ static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
>  		 */
>  		scan = max(scan, SWAP_CLUSTER_MAX);
>  	}
> +#endif
>  	return scan;
>  }

This returns a random garbage for !CONFIG_MEMCG, doesn't it?

-- 
Michal Hocko
SUSE Labs

