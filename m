Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00B2FC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 15:15:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA59A6B00B8; Wed, 29 Jul 2026 11:15:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6C3F6B00B9; Wed, 29 Jul 2026 11:15:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D43A56B00C5; Wed, 29 Jul 2026 11:15:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B19156B00B8
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:15:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49247140634
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:15:00 +0000 (UTC)
X-FDA: 85042161960.15.7E6350B
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9F0931A0002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:14:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=skm0ONFV;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785338096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2v6EYAF/prndNnQMY9/VeGyA6EcrPV2/qkncXAHToaM=;
	b=D+82C673AAkdAk/8Lux1X4hzN0EWo64rFHUnLHy5EMvSBnjULgq7XYQqBKU833p3cvthu0
	AbffVyicvbHLcks3r4jZ0faZnU6WUtXdIDglP4QYd/Jik6JVKJ5u5gasufd7AONQy4x2q6
	gHbso1fdQEhfm0q5of+Wo9rm6luyBOU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=skm0ONFV;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785338096;
	b=wew9laIfyGw4ad/4LdmREqqTa8kfdTw5ixWdGXRFyZgKA3CjBbT8y84NHPjwd7zY04/bZ+
	+ZZPlGwcsqoZO2ppSLDr1WJeKPtnXQ42zGqUSeCY8EBjlG4jUk0U0bOjGP0hA2hjHIBrTW
	HKTUAiRJpdlXdJ6EglUYchgE+ezNowc=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92e55b62640so63676985a.0
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785338096; x=1785942896; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2v6EYAF/prndNnQMY9/VeGyA6EcrPV2/qkncXAHToaM=;
        b=skm0ONFVOQ3E614Gn0Ra0eg9k1dEAzAEeAL1IdTyKUpiIu6RgPRl3hkb0czysG02bC
         cmEK+pP1/sRh1RhVz1Bkwl5P+rJ4VwipF6DYFpk5B055VXoabmau+6+CeSX3wydboJrT
         jVpKQZKEjIIuIMnpDaba6x3vhEkWkmR7Dtaa+Bm/Ts9v4wQxlufMfq+OY8mfpVGbSsKP
         WwbFnYt3VhwSMZOYzo2Pkfx/vHODlVK+migzz5SYoKi3wkCFPtjnR8vQAiQoh3P+B5W5
         +qo6xf3qehd3/mPmJbcplK1fmjQe0snm/kzyLuOJ3aCi8v/fhTMsa5s++4q+GrTtBIIA
         t46g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785338096; x=1785942896;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2v6EYAF/prndNnQMY9/VeGyA6EcrPV2/qkncXAHToaM=;
        b=N8Dj0BvRL+cK0ek2pogT6DW2JN4T/cqN0fdxj/BLcBFQZyg516o0vqS06xG9bNfUPD
         +IUDVWpFQPa2eBGoS1OcP0FHxoBSi3+hzRTtDET2vOUr2S7T7DDemN+tcxYVd7r+yB8b
         xstfGpl4X0GQrK4qHcyYpYsz8NawCjBt9yQmCEvhEuIJ/uyNFhqIJWjTpANBn9iS+BVQ
         28MYslF1Q7/qZCfUSZiu9UZhgAAJ0xAWQH+qY6RyP7bVhXb4hqnV2PqubyXClf6hd931
         LKZxeohwE4IdRUnn0Uh5HGjW6JUAbN4eX9EESopOQ58/7xqUjlAyikGRAAJ7OtgCiY3x
         o6dg==
X-Gm-Message-State: AOJu0YxvgU0d/afcPUz230mY9zA2zjTmf9hC89a0tUJx3WOySsV8NJVA
	9z8yI7qMx9GtOJXaEgnifsa/x4qjY9dvxvY/WeTj/8sAxcm1XOlR1u+319tVy9M9+f0=
X-Gm-Gg: AR+sD13xMt4MFKwcJb83JSwulbTLr0FDBWnJB5kAbrv/Wj8Y4Eszkv4M0sX/aDsk7BL
	mw5zMMJKjJXrh2+qXYf8pJJtDS6Rqm+n6LspQPEeIvYpHjn+xOQ/bgpbDXL2NlQWPNGtWoIHO+r
	XRtA160CdGZ3PCksEPr1jfdacCGh62WgirHSedkXgx4tckSs8qhj3rm5eYCqQBoLUZiypj0+eVP
	2dfvqBFlFIXCThPfFPTyThdpd/cwYTq/Wzcy98dB21celSGaah7Zkm1spu9Q52t2O/w78AblDk0
	IuQHBs1YrKJi4YMgCa5dHlmS/COFrDpgwyius0SNk03HSVJB+Y4DcrwiIO+btFBCoh8WQh91AhE
	qDmG9DMyzYyr88QWfkurqbYnBxRGho4/wZS1s55BoAOfDk9kE0WFZEjfhEbalEpRLyZIr4cenDP
	8gjk7ZjcwspQGGWLRRiTIHt2szQ2tsLnEzCCyccLlTbrwuJExRD+1I+9e6xEkv4u/xiCN1+XT9/
	4d2k2gOsEd2vGP6TcfZSfAZy+/bt0sdjiOQeYoPWTo5
X-Received: by 2002:a05:620a:6885:b0:92e:612d:87cc with SMTP id af79cd13be357-933027745b6mr659175085a.46.1785338095672;
        Wed, 29 Jul 2026 08:14:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d3263c35sm187961685a.16.2026.07.29.08.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 08:14:55 -0700 (PDT)
Date: Wed, 29 Jul 2026 11:14:53 -0400
From: Gregory Price <gourry@gourry.net>
To: SJ Park <sj@kernel.org>
Cc: linux-mm@kvack.org, damon@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, vbabka@kernel.org, 
	jannh@google.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com
Subject: Re: [PATCH 1/4] mm/damon: defensively skip zone device folios in
 damon_get_folio()
Message-ID: <amoXZr2vB_q5q5Wu@gourry-fedora-PF4VCD3F>
References: <amlZ_6pnt2AC-Ppl@gourry-fedora-PF4VCD3F>
 <20260729142228.88390-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729142228.88390-1-sj@kernel.org>
X-Rspamd-Queue-Id: 9F0931A0002
X-Rspam-User: 
X-Stat-Signature: cd19wexwfigrneb6zfqm7asnq4eu7k6w
X-Rspamd-Server: rspam04
X-HE-Tag: 1785338096-210310
X-HE-Meta: U2FsdGVkX1/QIIJ52Kbeed3hywyaVkU7HVGlwG0/lF5e9PjDVmzXCZfMauObJjA2OzTijdi6JaWVXRVooCoKpsXgJzMEtfeye0t0TSStaicxu1UBXGJGn13JshvQMJBqu3X93v8YzM7tpMwKMNJocvMZRVGAaEGR0SIKHsjK+ublUsFgVKtmIrdJe7SpYYV3kTO+i4KbTxEayZQUu+ofB7OBYcNPQFnizIR2YrDqWKLriYHJ2mRcOZFP1my8NkiBuug4/IgZn/1FVdoc8LlxBcdl879928o5aBWmlfjF4o/7YKxji0H6jOGF6I3fhX546MCyTLy0u9dy2Ab33vIN5EFmz7pjrp4VfugQs8GW1R3n8bI5/FbPyNwzR3Qu8olIniaC/luLgs8rrYydcYH0CvhzecRPFZW7CbNij36B4GMQWXmUHy+Az8/sDA7/ys2tNwAXQB+WM8OOgTeGeSrDy3N0/K5h5L/KIWlOopHQo5JbwYo4BARQ+eAQD8zdMYb4yjTJh3//8FmnildbNy9ANKY+3ciYh7XZHLsKCjWbX2uFZqqJTA3mcsI7MKi2Vqb7LfSTXmqStTWP1ug0OYZ0EzEi9Y49xxF9FeqIMXO3K8z2KoKo3qQ0NTR5MgrkKk8tWKO2fs1/qjmxfAQCVRoQe25wKw+VBeJv1FzXFXkhgmGDRizU2GeWqT9Vyctj12s/VruZ1Ozuqe9KNysM6jy+w+OcwrbsyeGyp66U1//6+lO43CsDwDl9en1epqnSgG/Rl6uAUVca3m+XuscjrhwB/k6D92jSs2J7QuCubfKP6Iv/hEC/9hHXs5RO3SEhyILykv4UNFcFqfdl63OZVuq+ronT2ip3RGwC41SDTsD3AKT+4ZK6MRAfH4dU+aRLFvsiZj32XA1XxDDfK/wpJqlw61AS5hw4dsIt+hPspcMeAZM2dVlPWOg2gGjFnflHXx7FZ3+glxggNwr1c2ckO8E
 Squ0n7T/
 dhBbYF57iVtVuHRAkrDkpJQBt8E1tsIuRfaRRYRGi70h4GMPugGyUgrFiKYfj86kUWfy/8BOSmNGq3HBr0dWHNYRGxdwoOOLdSTEcAYxjEysTQVgGRbJwLMqNr6AupGZh6NV+IGRnYq3SQDmhEIPmwL3X4Egs9bXe/PSiuujnhXgWaTQuDwfGuYEVXg8ZOW2wiB/DkePkiD+bTdtWLqnelB5xfw09285axOiaOvsLh4DQkN9Iu4RynDQ1fRwTJCW6hoMlIqG/0K4hygLE2eVmJMU7zYEUw1WRumqh/2OGRPfTM/DJPfq2ffKILbuAosMSXHjGjMDaTi9QNRQRdsjZwof6/82I4K/hgUHNFAPdywqWHz+P4bfAvLjlVTiGeiVpt5zN/cnU/I8xIAgjnlOPYeVW8AzE6RYOQ7LXq66kNniqbs+hOeJb2sijkBPRoElUcDromdEWeHUzUIKYtgHzKKmipoFAPxDrVpCgqALOqsSnCg1219OHMLuhe2CUnXECskjS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 07:22:28AM -0700, SJ Park wrote:
> On Tue, 28 Jul 2026 22:01:01 -0400 Gregory Price <gourry@gourry.net> wrote:
> 
> So, what do you think about adding the check under CONFIG_DAMON_DEBUG_SANITY
> with good comments at the moment, and later converting to folio_allows_mm_ops()
> together?
> 

I think probably we can drop the commit since it'll be a little odd to
add ifdef's and then take them out later (the latter check will be
functional, not just a sanity check).

~Gregory

