Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A60CEEA84E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 21:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5C086B0089; Thu, 12 Feb 2026 16:23:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A26426B008A; Thu, 12 Feb 2026 16:23:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91BE06B008C; Thu, 12 Feb 2026 16:23:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 830946B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:23:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D4FE13A76B
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:23:02 +0000 (UTC)
X-FDA: 84437079804.06.080A80B
Received: from mail-dy1-f195.google.com (mail-dy1-f195.google.com [74.125.82.195])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3214C14000B
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:22:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SsX3l2mM;
	spf=pass (imf26.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.195 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770931380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5jt/ta2e9LCcgP20HRiThdqdZNOrA6s81xaFb0uWeWU=;
	b=ApTZgXARaOceCt054rnTWwqtwMeWkiMY7gQkbjUP3v6gLaxNR2xs4KSc6yxGhc/KVziNCk
	N6AOXcXyD5MsLXB1R/qbp55YUa0N+BECoztGBEqJHyFSjr4okV4szWUs5y4qsUdJ5T6CZI
	v+FvJZNRQ2eAE68948Aw0YM0M8iwRjc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SsX3l2mM;
	spf=pass (imf26.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.195 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770931380; a=rsa-sha256;
	cv=none;
	b=7Is4fCUHMd1rdzwYxxjqz1uEbZEfq0bl99RgRVm1ou4fR9726gI+/hBq7+CGeXBXRclpPC
	NPWoSsyNgxm+FI1bSBOoFnUfScHq6MOm0ZUfwNwbxgNGMWlnY0ExUmPtIc0gdB+x615++J
	EWLGx0cBC+9N0y4BUPrNefZZ/q3HYnA=
Received: by mail-dy1-f195.google.com with SMTP id 5a478bee46e88-2b86671f87eso530415eec.0
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770931379; x=1771536179; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5jt/ta2e9LCcgP20HRiThdqdZNOrA6s81xaFb0uWeWU=;
        b=SsX3l2mMJm9j9k5EVuK6b/IWF0ixS+36boLtHIOG+sA3DIYXzm7FJZBrZDNqwtjFRm
         FrDFCg//M4PB5q9UIzu5L+gOhQ3iqljeGhJxSCCL/auGqdaXsTi5tEFIBMR1Nm3rKihy
         IXGdYe1GN50nlprrMKPp4Q1k5d+M90pw6U8z8x3k67y76fbOuUlkmKrlV2BAAwFPAgNt
         y3lPH8MejhRwI2a0hdEn2IJsRJ/6mYoVguTxQCagxDCo5j3cIsoo3YjaQWvJzwecd93J
         Z1BF/zVUf/HSK08HFnSgYdoVxtMdLTubVOuVsG+IQPm0D1Axsphy2WGlV1ng0qM+K/He
         Iakw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770931379; x=1771536179;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5jt/ta2e9LCcgP20HRiThdqdZNOrA6s81xaFb0uWeWU=;
        b=Wz5NptdYJk7hloosMa6YD6CdbxDAhaYNr05GjXYj5llGGM7dmjxjD5OACFpuDUzEz1
         Uw54BFpAEwb6Td4IO+rrclMQrfeTs7CQHYathplz9WbHJBZDjWdXOgtiilTuI/jGJ42Y
         Ul+5HSmX6CgQ/oa+EDS+139jr0jl5RmZd9qRHaA7Je4g4HIjX3KFLjmau3wTSqdIxiUz
         VyD6CYUFc9sCFPhG07zRanbyrp3O+IR7S88t5uybNyXTHdG+PoknO7UFS5bBkwPBtGIW
         JiMwW8QkYDXxhN9UJXxfSLgeRtpxScTWo7Pr735smjxlgyqZZv9vyhwsEIA2dXjGX0PQ
         azzA==
X-Gm-Message-State: AOJu0YwExObKU+QqVXSKpHVEZJF7swerX0pGnF78oPtPF22AELa272H+
	/iDcYC4Q+zrcw+UBKxiTrO6R082hoK8iF2KQOIPY4k6Cz+mZc10/LcB1
X-Gm-Gg: AZuq6aJ6JQ6BDuO4IDjy8b6Xz+FIX5HaSYHYB1oGHqf/vxjU1CsWnkz9Nd3cULfTCxx
	Oihw8i1bS9FpuDpWxD9SBrsYRyikWU1EFnwIwLMiDuzLbW0UmPoDA6F3jfxwsbT1mO78XE0CWo0
	Vohz+CP4aNIE86+WqqsYjmaZi+/KltOIjMLQW9/8gLnJxVL2E//jtr+jW6bWty+JLG8T688hi31
	UKCYPr6AQbFSPJaHZFsDY3lMaVxhFUB1kieJ9L9jwAXrF/3jrHrbb/GqVH5iGTvVwbKQjhWKziH
	p4NCIo6mbmobUgrDyzWF/KEkNBdIaE5an7j7fJ+fESzDE5qRKiVg/qAA/LL/rH1aGAQyXHN48hF
	Lk+NZ/te1yVQEkLboX2Wumif59YHdtyb/pe54lRbE/k3HRe0eO0okVUioPQVeAGC6GwjiDd0urU
	skrhJphndyZP/x52oGGSlEfNVmdR5dT4PBCHHhtRE/OMQ=
X-Received: by 2002:a05:7301:2f99:b0:2b7:2f29:648c with SMTP id 5a478bee46e88-2baba00663fmr143646eec.8.1770931378888;
        Thu, 12 Feb 2026 13:22:58 -0800 (PST)
Received: from [192.168.4.196] ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ba9dba2d44sm4184966eec.6.2026.02.12.13.22.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Feb 2026 13:22:58 -0800 (PST)
Message-ID: <eca7a8f9-173d-4cb0-93b3-df082b8d0c08@gmail.com>
Date: Thu, 12 Feb 2026 13:22:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/mempolicy: track page allocations per mempolicy
To: Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, apopple@nvidia.com, akpm@linux-foundation.org,
 axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
 david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
 jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
 Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
 rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
 rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 surenb@google.com, virtualization@lists.linux.dev, vbabka@suse.cz,
 weixugc@google.com, xuanzhuo@linux.alibaba.com,
 ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <20260212045109.255391-2-inwardvessel@gmail.com> <aY2BcIHIARSwwQpo@tiehlicka>
Content-Language: en-US
From: JP Kobryn <inwardvessel@gmail.com>
In-Reply-To: <aY2BcIHIARSwwQpo@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: q7wywggecf6ag9irwcosixu6tfeyms14
X-Rspam-User: 
X-Rspamd-Queue-Id: 3214C14000B
X-HE-Tag: 1770931379-209559
X-HE-Meta: U2FsdGVkX1822lDXmy/vrwvadN50bejbpdofkFcQZnLiJO3+DtwKXx5TxMQskYfCPwgFFn7+6DedRU7fhRoiavzjK0n5944pyHuZaxZb8y8LtuQSYbeU4+aCA2s88TDmoNcQD4bPVU44n2ICcrwzFqs3kH3fFm/QYACrVYWHf4O5RScnaCr0OcxEvKozvvj9D307ucTUTYLmWwAeUMakPAsSp9lb6lTfwFlEw6S1J+X5UB/FwKj108KXsHenAHTiJi0jusHddk3YxyLZZHtgzOvk3utskX5GRg/pKHI42h+VWemcil0qFDbU2LwCK2yfKSsCuuiRbyiNpkaGR8WLC8/cgp+0XSfEVGAaJBGoT6JFn/r2HzhTZTJ7W9kTU5kfOob111MG3PNa+vKLZLsLBjNANdPxIk2ZByfCQtEbcSksk6+yNiIbietlVKpEDAV7MTnXvStMRx2VsRwYXD3Au/Q/UV5UvKLhd/YO2xgswlksmAL4/SzGCN89ffxtWCDJrdO8zvL/uvzvG/pyB3aisTvWCH9z3NNlvcoLgfo/FwKmvBq2161DjrBsruFP4V6dI8ksSBRielpEZ2RlPqnSiiZ97s/JoHmLCc/ErhxkoVeE1YSD7swzMcKWmHvRBkwCRrwp9cf+8yyZSGBE704ivbHKHZNSyxSk6IchM359p57oy/mp356/yv201WkV7yV01xEGJAkoZyVFdon8UYjNEKxUNF+wDE4S36dl9w3oVu2LDWx7GwADfecaZC+etGreNYs6FwrVQAR0Ew6hnYbln51aP8JVwhZvuSjOiO1qTy0KRwqo28vgXpskaObzASB2ubjeHw7/1kx/Ir3lLM0HJIaU9Xu6gkS5Fj8p9zDnxWj/b8MJ6Jhc5GHr50ZeFzah8Cjh9zUqA1FmWYyfMmvkuFVcg0jBaMhKCEAUuPNlfbsVU13uoCAPIPC0f/XXhFzgx1vozAweQ1QD9U/9b6X
 cwCoJuof
 bzQ6WzXtafSHp7jDPrC0PWzC/nFz/eNAvQaEuOcxShKdqNs7uCM82bpz21eS9sqCIaRUEoKHutJFKN0zeuLxdb5PwAg8oT1D/KFlV1YKsrenY+wdVDipgXwyUh2JINKMQyG8uhiLMbDVfv1iqJyUvSeF+KGv2hVozRWExg9Daj/LJyHom1lcEbQx9EnyJAee/ASKJx97BsMYBJkl2yk20y6jNscFr0K9dy0mqX49ntPAFMq/dj7VNTwoTfaWR+5x3z1a63D99j7MfeL1ZnmE2yn5S2pTbeBz+hntCokscO4DHhKF+DdfImxZf1wJ46pFsmi1jRpDS2bqAlhgf0db1zKI+kznhOH1KcZe1xX/9ofvlcEb91o8r7dmVisziEBdt+EdemeWoDxIDvJ2v3tfof49RjsuyzH2gPX+l2tQ9SGx3dJeZztMz4XOcKeFIXF2fi47jorGvwwo0pLkcXTwEQGQXvHXKWgeY1+q2VxWIciHH4FnYCvqUb42VFch2bGvBQYuMcELtJ9reVOqp4frWhGqobvwivfCtJSXFhOhTDvgonTp9rmRHNZmQgzWFpeCeMCu7D7O1NwelnSngIifelgRlgQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 11:29 PM, Michal Hocko wrote:
> On Wed 11-02-26 20:51:08, JP Kobryn wrote:
>> It would be useful to see a breakdown of allocations to understand which
>> NUMA policies are driving them. For example, when investigating memory
>> pressure, having policy-specific counts could show that allocations were
>> bound to the affected node (via MPOL_BIND).
>>
>> Add per-policy page allocation counters as new node stat items. These
>> counters can provide correlation between a mempolicy and pressure on a
>> given node.
> 
> Could you be more specific how exactly do you plan to use those
> counters?

Yes. Patch 2 allows us to find which nodes are undergoing reclaim. Once
we identify the affected node(s), the new mpol counters (this patch)
allow us correlate the pressure to the mempolicy driving it.

