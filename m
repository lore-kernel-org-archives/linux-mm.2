Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 272DBCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 17:08:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 753DA6B047C; Mon,  1 Jun 2026 13:08:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704AD6B047D; Mon,  1 Jun 2026 13:08:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F3976B047E; Mon,  1 Jun 2026 13:08:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DCBF6B047C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:08:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DCA1B406FF
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:08:35 +0000 (UTC)
X-FDA: 84831977790.08.8F58BA9
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id CCAC620002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:08:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gfJJyfUb;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780333713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fwo9lRnl+caU8n+bkKsCokOR7tEa4er/MbruZS778hU=;
	b=TaxrAYk5cMAUkuCu35vussyw55H8FcJQ4xF0Br1J8oKDqaicojxFYzYrs31moCBhnbZN8m
	HVb5fdXLRKdcVGHv0HRixU8QS/nE8h5L10iMGzFx3eykdl1+rU94SzMgj35yVqQQLoGSxw
	bqfoV7TDV64Ht9rpcn4h4FEGFhsk54E=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gfJJyfUb;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780333713;
	b=V492kvjv3Fei8ur1Q0BAB4WFOV1Zca9m3ALDc7HXkUE9GzCjnljE0jMTL/ZMdJoAmoNia/
	/2fe+3IoF7EaBxQZ4Ms4tkqapoINUVYZbLJn/eX4AeJVjHP66t3r6A+8eOdurGCO1bwuXS
	6e3PJs3zrnxIb7tB717G/rtoXKDT/9o=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-45eeea039ebso1891234f8f.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 10:08:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780333712; cv=none;
        d=google.com; s=arc-20240605;
        b=NZHGtAaJX+EJ6Vzt12i/y+e2wt5SKWPIAu7tvyiomOGHk5ni5yiqyYgoGSpPxugoMU
         bT8FCE4lEcEtCkdioYrDjGInN+eqCKsvTYSpMnYhzmBGbcDxd8qvP/KQr/rP4MUJSdZg
         cyhSOvJZiw6IRNFjxWhMSOtNKgyUmnlZhUDx4wRjOtPkPNogqgYYYxbwhxxcq5FcYgJd
         EnvUM7htJBSS5GrMwf7M9Zhff6wU/3ttDs4wx65yccEvFusM4kmFWwvaZA+fGg8JEffM
         LsD/vag4iHF4evEJA+Nrg2ISO9HoDtnLMqYFQPvIQOsf1MAKndo2Kq3vWcaFA/McGsES
         2IHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Fwo9lRnl+caU8n+bkKsCokOR7tEa4er/MbruZS778hU=;
        fh=ihORIHPYRdlijs4CPUWkGjJidGg4NVQYZ7RiF83b0A8=;
        b=cc1jcMtWLzK5cYmQvCr6BqMZQ2T0KqDPu+IE1soiSmOXIR3h9M7iMDcEi3GcN5VIaX
         xRW8IFuxlcUYiQTFsZE7qnb4HVPoH0J4rwafsnsEQWOaLFZSL1Uu6xowJ1OZ8vk+TQCC
         GpeQR1Kz5rWA7za6lRWkAe5vKIUm1scWBm+2JVTxirIZmwTMVcXwVB/CIViNURy1nv8e
         BOUTQtkN2D0Lq9LvU1xP93Bcj5uO8BdgYLbfWe0zl0F2BKftUvK0nJMa2ml2bNIEwhPv
         FOU2UI3H40iEyNIgszhTXij9fT9STNkQrUWVFUNN1KrFudLDbbrBRDNWDYOqTuqhL3up
         mxgA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780333712; x=1780938512; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fwo9lRnl+caU8n+bkKsCokOR7tEa4er/MbruZS778hU=;
        b=gfJJyfUbkiCgu9xIWAbytv0VMRCvH834lnWgJwGdp1lLUYEIooBjO4SABUcV16iD33
         JXd3fxMuA/EXMzbFCh0jYI7huIamTf/0DSed3+QQTWnyCvQxp0cwGf0KrjC3tckxKDEl
         9SYmJzn6vZeJ2ZcJCsVifOBLxuVok6NGH6QUY1vWIr99Yvmv/t/tvyT2STmWoic2z7gA
         bTJMNhD3Q9s5A0rpADRIbC6tQNBc6pKrrc878x544GJIfag8aMT0NeCF7SO+zJp1kopv
         TiUFUFaw30cFNGC3yIhvzWsIsNcNYG3iezKhhOhIuJznmMSgOcmG39VDa/SaR3HIm4gd
         pF4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780333712; x=1780938512;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Fwo9lRnl+caU8n+bkKsCokOR7tEa4er/MbruZS778hU=;
        b=iCm0PjmpV4IPG5IOhtFor7wU5p4jzTPbt/dNL0mdQ3ZD4skZ7i7kzvl3lFk7NLWbYG
         pC9TNvaaXOUIiwYsnASWiraNiHQfxRPlAhH0/9pGgBHh3hlzRi9gML3kUY+HpI7898dg
         V+y+OBW94CzH9tPcfEHPFyR8Dl5TUj2GzGUk4aNaXgmaOEVpDThHC3pNT6ykEkNX3Uxs
         SJkIBkSS/R33PXeP/AkAzrsaLWjDYL2prHixZbZ3Hfnk1yYXLAINjwKXY2n1xr/b5BCG
         Ya6AARXtx8bXxV7sRWVfATO8dMe1aZaPUq5zrMskCsHBurI03bFAN4hhcmQZy4OGdHGG
         Xg9g==
X-Forwarded-Encrypted: i=1; AFNElJ8g3pl6Q4xfezKpwLRiwIMNvwXxex3OeoaxEGFYcyrczsXxaJW4HYB7r0T8ImI4qQD6KCdWaIBeBA==@kvack.org
X-Gm-Message-State: AOJu0YwzrFiU/Tbp7vmTPt7oShwDMGnj/ZToFQee5ZJLqrVYM9XOYsKO
	wDGxxz9w05JiVUOzcu2YUGpe3kZ9K00LJtj+zuKcEXalyhUvR5oUGWc05CGxI/2Pmj2KnQDHXrN
	GBgomASCWbjRrt63d9rByW0m3kX3Nvmc=
X-Gm-Gg: Acq92OFSF8emwEYoQBbTDp9TNLja8vkxqiFlCEvA2IewOY5OjWs4r7A7cCWSUd7pdoN
	MDhthCUWTAoSZXhzYjYthcTCj+I61kLWuax3n4nnes99KohjxCgVJhQqawsk9768QT9Pu37UrMY
	7Q1Nqf/dObMR05NMFSJV55NMElkOlnjL4wk2xgnzr4pXJOVLqytGq23gpaIw4brJn2ltSPtRCw2
	V68JZN4O2Db1/6oc8mVF/Jq1wBL6Ibg8yrC2iZGm4CGPmPyTi7FpTxn1HDtdqPy8CFAdfKtFikC
	XEhQaQCOgt2Gs7hPf2Kh787WQDRUe87A5CLyIvxf0dwxbpJ0SQ==
X-Received: by 2002:a05:6000:18c6:b0:460:1301:ded1 with SMTP id
 ffacd0b85a97d-460131122d6mr4841379f8f.6.1780333712087; Mon, 01 Jun 2026
 10:08:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com> <aho7nepN5jZtKmef@google.com>
 <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com>
In-Reply-To: <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 1 Jun 2026 10:08:20 -0700
X-Gm-Features: AVHnY4IPBYIavrsVjRZcklh2r0yiWvzcpUqLWkliFzeatE9D_yJwDY6lgq1MVZs
Message-ID: <CAKEwX=NoQNXOMDD0uTSOPWHQX-CMNU1dw=zEuFj=eLcS3fB-ow@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor per-memcg
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CCAC620002
X-Stat-Signature: gagxshhayrkfcds6hyiryrtpk14kcnsw
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780333713-946277
X-HE-Meta: U2FsdGVkX1/6SQe6YSo8qhXSxGYnbfUV+iIeqvYRFmX9wjNVDRZstcCYIjFEIS16XpRI+DtTguJXhWtXnGo+yqnTTciasR7m78mBxbKz+pRVrRpLnKjg0NjFN+7t+mR7xccnSbeSH6RMMz/1G4Xukq3pP21CwVjm8Ntf8ZLjjVfzVFRxD+A5hP41VgeP4BbCTDNw+vae4JUYY84rxduIOMPoAsYWcuunlZpJ3r+E4e5YiikcNCAfg0omxvZWsscIkANKwasVR5eDyCoys2xSJ8UBhzwWsiy/JQcQ//T10alF8XhYZWtHQhK+zKhl7IzQfbSs72A7DZfxhvQbFqtYcxIrwIp3q2MRfVu8nUngQzu5l2n0uncFu7DZRxN64spvaJMKTL5wCL+oacmMXgyOyMWmPTask/b+gwWiUcl/enHmllKFp11E0zUHEVZJe6fExKysl6vNqcLRd+x5cYTG9ujSQ7z/Sm2Rp9w2bEkeUWSxZYq2whyGH1H1rIxkINLSwqpXZfud95RLhqgwx2ZM55NiahflDwVmnKRyFjBcw0oCXRbHpy3Yak1OeQw083YnC1H3hPstCQ03TqHkiBjogzmHuuezswafPn6e0GQ+D+8mbetdA/axqnaq7Zi0ZYhIdClqUjihzk26z9o10DrwqW5tSOh0+yUqzwa5zGDhMPTLIGX74eI5thmi6Gcdwczw+OoBEHxDqrDF8/xImtO+YC5ybSyFJw4z2U0HTiQBzQs4GETTc4JwkyKqe3wnU/ZUiGrCQ1grpXvjSnKhijD+58LO2CmU6X6BarfdsACjoOoHNdbEHmbp00ue4mLrpgxsaX9wulTIdyfkFd4d9x3OSaXjyKPGXkKsvcp6Er2o52fJWvx1eCFWgh/UKeDt7u3lDW3i68wxuk8rHAJPsYgf55ROjoRByrjaVqpDAKSWe3oaqRdqqCjl0+m5gIMKiYnM3XqUayxNOw5vxoDW0y2
 ZPCAjL5B
 r0NLk0eV9tHyG6xvyDxv9ay3Rfnm/L0lhrUzpJzdHY9OZplLA1jCPHfOcSsjQ6o5hjQZcSIUB18LYyNBIyZwM2X6v4qP+/xrKZjHckcvpp7FE73TUXpo/Cz4xGDccLM2TQQsBlvbmSdpsdl8PNC8tVCmlxyryxTYgGFg4kWYkcpxFWRawkw60T2GSGVnLx7qQRXvMfQVPyiccoS/lbPaTRW3R2fqnnEE3Juv6gjeRTmh8Mwn5U6gwTq+ZGlmiaiLVeNXcEEdN7+iZNg5cssDL1UMgPAPhePD9eWcEYZ3zBpRJWMKOL62Z1igJnaKTAIeAQYLW6COK4xCFtE5Z4YoGEaQHveT76gFX2XYqoIJ221bNfgMt4MR4OkGavYGDlIZh2cDY+bgVti57DPHnH/GMSr2pK0skrNc3d5mcromRUC453A5b8eos9fVn5YoFCwgaHH1jXqTZUicLB2BVPio62qOon2L0Wlua4KSYXCS3RfY4UrkZekQbkww5Lo2qMdo8GjMAeSRxnC0bKUHuceWmDDd48XB3CcRpBMX9KMqT9XKYgGr4oZhLCUmJg0FIqv8vyqS7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 4:07=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> wr=
ote:
>
>
>
> On 2026/5/30 09:24, Yosry Ahmed wrote:
> > On Tue, May 26, 2026 at 07:45:58PM +0800, Hao Jia wrote:
> >> From: Hao Jia <jiahao1@lixiang.com>
> >>
> >> The zswap background writeback worker shrink_worker() uses a global
> >> cursor zswap_next_shrink, protected by zswap_shrink_lock, to round-rob=
in
> >> across the online memcgs under root_mem_cgroup.
> >>
> >> Proactive writeback also wants a similar per-memcg cursor that is
> >> scoped to the specified memcg, so that repeated invocations against
> >> the same memcg make forward progress across its descendant memcgs
> >> instead of restarting from the first child memcg each time.
> >
> > Is this a problem in practice?
> >
> > Is the concern the overhead of scanning memcgs repeatedly, or lack of
> > fairness? I wonder if we should just do writeback in batches from all
> > memcgs, similar to how reclaim does it, then evaluate at the end if we
> > need to start over?
> >
>
> Not using a per-cgroup cursor will cause issues for "repeated
> small-budget calls" cases. For example, repeatedly triggering a 2MB
> writeback might result in only writing back pages from the first few
> child memcgs every time. In the worst-case scenario (where the writeback
> amount is less than WB_BATCH), it might only ever write back from the
> first child memcg.
>
> Similar to how memory reclaim uses mem_cgroup_iter() (via struct
> mem_cgroup_reclaim_iter) and the old shrink_worker() used
> zswap_next_shrink, we need a shared cursor here.

I think each proactive reclaim invocation just walk the entire subtree
for page reclaim right (see shrink_node_memcgs())? Would that be
acceptable for you?

I also wonder if we can at least make this structure dynamically
allocated... In a system, you only really invoke proactive reclaim
against a few target cgroups, no?

