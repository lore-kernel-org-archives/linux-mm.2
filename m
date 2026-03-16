Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57AA1F506D7
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF98E6B02A8; Mon, 16 Mar 2026 10:07:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BADAA6B02AA; Mon, 16 Mar 2026 10:07:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADA016B02AB; Mon, 16 Mar 2026 10:07:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9EBA66B02A8
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:07:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 43261B7310
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:07:30 +0000 (UTC)
X-FDA: 84552103860.16.23BDBB5
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id 84EDD40016
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:07:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fUJrUeun;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773670048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NVfS4F3yzp6RxSjfPUPmy97+3JM2QBYP3BC0jY0rHlc=;
	b=P6tKrljICRf8UOYewQV9MsckpICf/NlD/QRdt2bIyyC+cR2QGZQEIRbEKmRRYYQf+5tEMX
	GCpScOPFzj6LH5u2uzXv5EMaekLlE3CcUw3pM+2ZsPFtlgww/Z8vYFSQf1kdpv5HqvkVLG
	TMnJo4FTwCsL7nFexq/Esd1TNnUzYUU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fUJrUeun;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773670048; a=rsa-sha256;
	cv=none;
	b=D7ueBqKh6YGq9lHoFPsF1mI9l+/xppX2ViBKIWQSyD/Q0KEzQmEeip9pZaCX7aaRqchZQv
	oysZqCZaXm/CDWudHWYT8A9wUsiDk3SiKbV2xeflvqhRmE+JTjmhiQ2SU8hDjkLsDmwA+6
	mU8m4FVwpm65ux8etIrxOhKVqExmdVU=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50902b1006cso41374551cf.3
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1773670047; x=1774274847; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NVfS4F3yzp6RxSjfPUPmy97+3JM2QBYP3BC0jY0rHlc=;
        b=fUJrUeun2yo+IY18wIPo7AwjvRvKCIhUqMfUp9TqzFZYw0bNZORJIn0ar1bw0pnZBU
         sgdf/zLtl+gP9eeplaTjUAT2K+3ye7Y0b+CAJJUPFM6GjSgNZ/U5dTgPvTixF7Of3FTz
         mRknhJQTYZdtvQP8kj5rU+JjryctZgTd89MtQrQcEWshryfri3riaTT1FV4SEa3f/Rtt
         IQJcthmqHtts4MJGena3uVGGYEvGP2g3sAOdZQCk9j4RcpDYEilNfRk99j4HHXwtAA+G
         bT1JCF6Y02R8GUaVmvfLTYHyuL1oI5q2ugBnoW40Usba+xGnM8TBq3a0TPVGqSizBnkL
         ikPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773670047; x=1774274847;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NVfS4F3yzp6RxSjfPUPmy97+3JM2QBYP3BC0jY0rHlc=;
        b=O3JnUv8wO7kaDBscx9O7oZAEZIOQYrW6uYMNvC8Y3QXwLxyvNkteOdsI9FrRAn0T17
         GxjZsUKzNnxoeYJZhiLOlz6cjDuU0kXXR/5HcbDXFT3ChhjeOA6gCFV3pH9+DGqnknTZ
         Sp2Np0LpP5M8L8anTy1im0eZV3WxGw0cMzs8tEh1/i5WI6C1AmYHKwIMGt8b+yaPhDhc
         0uZVVlZdAqkGBTm5e9nZn0eBL1YRSipAFaKXbI2vMrFEnY/xgO+YI3pVeyZlmLeMhgqG
         3DJaEfoBTXNEyUfT5M6Lo+lSu2mwAqnUDOM+VD5o0JobFNqyXvPdKUSA3MHZfwx324YP
         8AFg==
X-Forwarded-Encrypted: i=1; AJvYcCX1DZ/WSbnxhgFWmFSmB6wB90RrDQgF4JJuXCEcImo/2vWyyHVEXDUKqo0eMbgucWxuvxgQyvvjvQ==@kvack.org
X-Gm-Message-State: AOJu0YxxooCRDUL4LAimw04ewppl4yW4xQsSE2QSfIEzXUwUaUPm1Puf
	Pjq1DKZ4V4I7QN4LhKtsWGe7rOtlNPf36aAqQNOLvp4bZqJzlEOP3YjgfeMFLUfxhDs=
X-Gm-Gg: ATEYQzx1Zk5/HcjfMUWWiy+ep1mHx+x+ATgq4qBhYYth0/s/d1ElUwc3+7rtC1mlDrr
	yV+BVV0BvEuF9AAV9PlaQbzxiRr83HqdzZvGMQvJKUeo8TVr7YhUsGAIIoEPgHDlJbxtOk8126A
	wiePvKmlHPW9eyL58NkGKB3/+oEqCgLc+vlXsUgWn92fCdXmnYuXkCvZq9is/RlPyyjQTDho+e1
	eiiJXzRLpssA77dwwtW0/4vVf940nKLaobsn6Z279UXLeguQQN0JYA9JJ1LcaVqsA5bxKocB8OW
	P/bULdy+T13IOWgZQUg7O8rcDtevEqCKNvkeSQNaY7s+OeDneHsRapFk2c0/jqGFO7ykt+P7dtd
	w9Lj7BnghufW/Q9PAE/Rjjed1EolzZW+IMVY8O6MmIgUii3hITRduTf15kTBQqK+DXYjVl/O/hF
	fw4Zu/Bfkt7q8Uor71HpnIIFa6jdWAM6BoqBUQa7Q70ZAhPT55ksJ6naaxJUWcQh2X2ADY8v1Pq
	T/Jwq+5Ig==
X-Received: by 2002:ac8:7c4e:0:b0:4ee:280:2e49 with SMTP id d75a77b69052e-50957e9bb88mr168323681cf.66.1773670047327;
        Mon, 16 Mar 2026 07:07:27 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50939ec6331sm117733111cf.10.2026.03.16.07.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 07:07:26 -0700 (PDT)
Date: Mon, 16 Mar 2026 10:07:23 -0400
From: Gregory Price <gourry@gourry.net>
To: Lin Ruifeng <linruifeng4@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/mempolicy: NUMA mempolicy mismatch during remote
 access
Message-ID: <abgOmx0kwvOnN_R_@gourry-fedora-PF4VCD3F>
References: <20260316120424.1535575-1-linruifeng4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316120424.1535575-1-linruifeng4@huawei.com>
X-Rspamd-Queue-Id: 84EDD40016
X-Stat-Signature: 3znqfzgo3m6ac1jg8fw1npxecpg15p1f
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773670048-630928
X-HE-Meta: U2FsdGVkX18yE42bCBFfeWBCmXRGqXbTlO8p+r5A4k2g1pA22k0IaLLIvHcBOL2QcLjB4rHga9on0rsYoDJG4UcAIVR2zpTelCCpTHBCV77zw/AbnjDzXnCqf2mIYFmxIG5K5618qvS2uVDh7jnxwDGmTxnHIPYmpn8a8xtPYU44lYQA9Gtq8E3eogUSGRmG3swW0nqWHKpxzWwl8LfVL0AQBLS2jNrT1eBeC+e3TXOdbytEQuwwCqT4HWevRVl3M0XRJZMa6boMdSk7JW832vvblfz59nmrsTios8Ci4oFu10Nf47UoqwlOMez8sNyc1C5DT6bXrZ8BkiZpJSCXE2bDzvJK/vp4ADMIFmUnMdrtjRh4G0Qmg6Hsf+7P4Tx6ds5Zk9yIidvjWNpkWYg76lsY/xOKZVUwGUtKOT74+lHwfeOSacY23NmKuCfVdiiBZqtfBbtut3VYgKrdYOQoyLFGvk4kf1+iRgUSK8eiNbem7OcX6zxwjenv9xqP86mbp0I5mVvOc72IflYqFi3ki9wlsiFwDw6h3MnfswhbqFjz7Qox9gcb9kt21rXRWtlETRzt78laL8r0FpsZIrVMuC4VRmjnguRakJ73u3XKg72mLZizWS8ejGeCQ7CHWblN8Jw5jFzFTqbM1yu3X2VUMe4wDd3sNKkL3UNt+nwcwRo/S8ogKIkc1owuGmg6TKWUui+kfBglwZKP2xX1nic68JPGxg6jAaqMF09yzhNZppb/nHMuTiV2L2NM/1VvniDGJFOERAnhnQBLXFBKyG/FnkDhngJmS0V+mOyDaYSM7lZJ+SIobSht0ZoAr5zoGMqwdKW0ESDjdZUxjRTld71G3kpU6GzLxsl00J+QX5jG8D+TS28sgb4yocEXV6kpNkFclEwFc+ubzA5vMCm1WUkexTTkDb06tTNz7Mb5hw+SVVtGwLLQ3nNBauAb7s4GDV9YNTWed1HZUGanPe6ESmq
 72abQfzr
 aIb6wUVrSbamxZxzgV2XouGKZa6N2DkDpAM0abDBmtuDboUihGUqMIGK5rz323aPiD4FjpABVL8vbswXScoaL8DNS6iy+T1ggaosl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 08:04:24PM +0800, Lin Ruifeng wrote:
> I'd like to report an issue in the SVA I/O Page Fault (IOPF) handling path:
> a NUMA memory policy mismatch caused by deferred workqueue processing.
> 
> When hardware triggers a page fault via the IOMMU SVA mechanism, it's handled
> asynchronously by a kworker thread. Although the fault handler correctly uses
> the original process's mm_struct for address space mapping, the physical page
> allocation (e.g., in do_anonymous_page()) still depends on current->mempolicy.
> 
> Since current here is the kworker, not the original user process, any
> task-level NUMA policy (e.g., set_mempolicy() or numactl --membind) is
> completely ignored. Instead, allocation follows the kworker's default policy,
> which may run on a different NUMA node.
> 
> A similar issue was also discussed in [1]. I was wondering if you might have
> any suggestions on how to address this issue.
> 
> Link: https://lore.kernel.org/linux-mm/e2d5f3a5-f6f1-4567-a162-a0e814292738@asahilina.net/
> Signed-off-by: Lin Ruifeng <linruifeng4@huawei.com>
> 2.43.0
>

I think the best we could do in this scenario is acquire the mm_struct
process's mempolicy and plumb it through - but this is not exactly
correct either as multiple threads within a process may have different
mempolicies.

I imagine this also applies to vma policies as well - so you'd need to
check both the vma and the task.  Not eactly great since we're talking
multiple locks where there were none before.

~Gregory

