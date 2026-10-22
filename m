Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD857606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 09:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YqyfSynn
Received: by kanga.kvack.org (Postfix)
	id DEBE26B02BD; Thu, 22 Oct 2026 05:05:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D95DE6B02BF; Thu, 22 Oct 2026 05:05:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAB6A6B02C1; Thu, 22 Oct 2026 05:05:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA7926B02BD
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 05:05:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C9641207C9
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:05:24 +0000 (UTC)
X-FDA: 85349678568.04.854D523
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf12.hostedemail.com (Postfix) with ESMTP id 39CB640009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:05:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YqyfSynn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792659922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iYTz++wjFMvqtqXyscp+99eRXfkEkYxGMNfxByS7fDA=;
	b=SfcaggMhJHxAPaCETnI9eeEVy4oFAms78U7o6qmMYdnf1dtf/XSqCOKnF9Fz0jPCLJtZBq
	EiDrKV6rczXAQuf49OjQXpH2Ay3hZi1U/W1hQP2uV8bRmV7//+XySkFiwoYvhujTFIibnX
	EFz5K5DwmS2n3xlwBcKO3sJXn066/uc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YqyfSynn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792659922;
	b=Wu7FyDalivcO79dTg4wzC4VZD32uezk8gDVXQZpHnuHcHkyzDKAw0UBhn87X6L2IfAhomI
	0oUTI+EgoR3U4H/dtzLYsvZU/NT7k3GAWFdrmC+dIzSiOO0gjYUMr3V/ETpVGqLG5hiFAn
	Egy8hYqL3Rc+XFmLmUKc4p5dmiTiDkk=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49d05d51553so11467375e9.2
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792659921; x=1793264721; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iYTz++wjFMvqtqXyscp+99eRXfkEkYxGMNfxByS7fDA=;
        b=YqyfSynn/KZpKob7xcE5wkR7XvEsnPejN21H3BTQO0CJASe4tq9QY4Mf+hcMFv+A9t
         RewN8r5P5wu430t7T6FrIx1Y9KUy1mTHE7NRXsV6cWG5UXwA+JkbtxzDkf/AkdAIR6Z9
         LMwsKBhjpQDYWm5mcYiYyg290xl4dDH2ESvvaOwNen/NuwL6PDFSbEuVVSQVHeCWB20T
         KS5M40XOIzXsC2oUC0QN9Cu80yXAUhldIejPtVTQyEgvhM3JBKXAOanrLe2qH1Xpx/MM
         VEWLYf1+zmhYbVQZOKc3zOED3T+VMt3TtU2cHwWHlyPQVRFLJt3u89z0BbO9ZWknMUSp
         k5/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792659921; x=1793264721;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iYTz++wjFMvqtqXyscp+99eRXfkEkYxGMNfxByS7fDA=;
        b=0Mp1TvIE3nML8FCnGSP9DxAik1y1zZW2KejZFx8EeqG1xoWziOZ7nBVlPrq+yZxBmi
         wf81+aOVpWacR5nVOmeKsfxL+dLV5dTFlNhkY9gyCJLVmp9IC1dF1yxsAov2ULWy4O3e
         EZb159TSjYJfxw9R6Vo7no13rzexl3qZ/yE4MWRcta3HSptA+CFAx/69bAmHTk7OrmMP
         OJvRqpLzD1AgJQ2n+eBf8D63VhUgRNX7czdkM61ye4cvLCqhMzTysBQ44KRw7Ejd6vAY
         rywK7wO0q/enwzfcfiSjtXib6A+d+EThLQArnba6EQdXShavCY2RzMMGWyAgscpOADd7
         FicQ==
X-Gm-Message-State: AFq9FYIygbVDOdhWYZBD0WElUAXbluuLLKkDLxtfFxEsm0CsWMiTamlZ
	YlBTch4Ylgq3zzvNa7gB9BuDoLxzeLeLEvMEW9H9I0GC6diFoB2it5N2
X-Gm-Gg: AYBFou1awYlfJKm3GH7PYgm+Hmwo+h2S7hG7hiHIpbGV/8B3X9C8i54lNL3OzoYlwKj
	ICx/79stpjFsINwMl1iitY3dMHRKH/WzqfEGzBNz0VnTBa0GvE0OSEhmSotSvdp74FM0+Hlml8t
	lE6BaueyfNlnZxgA5d/Et0viFeBELxgB1iW7jiJfTkOUwKnoC6NdjpBM0q83YgN6xESl3VVTqC1
	5kQGkCftXwG1NwqwnKPJM5kh/RnOMtBBCmXqW6ssL2BzOOZH0Yb9sohEpOy1U242JeDobkPUMXQ
	EOsPwreBfzQvcS3auaM7wv7hzhaKQJBTJtE60ogZmU26UYj+KxlUjZ0EeLlfJW/mRtpjLfZEfaZ
	2WU3Z0+7eT9dnA2k0o6d8vsXjffJ1Def/QjwrLwbrHKAoiQENxpBc18rcJ/Yq8ft/iBJ0v1uyAK
	cypLWvImYM24y/QVWL+paOJLdFaTVUo3J9aH3k2qclbU4xpcPC5laN2Ono85U6TsuMpg3j1rXen
	RjNdsdkbu5PNAZoGBggaeIHFdVzALolVuY7cORP6vWoe0ZyLeM=
X-Received: by 2002:a05:600c:8b0a:b0:4a1:7ed5:99e8 with SMTP id 5b1f17b1804b1-4a1fdd23003mr92757395e9.22.1792659920208;
        Thu, 22 Oct 2026 02:05:20 -0700 (PDT)
Received: from [192.168.1.18] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a203a4fec8sm57925135e9.13.2026.10.22.02.05.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 02:05:19 -0700 (PDT)
Message-ID: <f5db959b-3744-4f7d-9837-e8a4aed70ab9@gmail.com>
Date: Thu, 22 Oct 2026 11:05:18 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: Re: [PATCH v2 5/5] mm: hugetlb: enable CMA allocation for PMD-sized
 pages
To: Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev, david@kernel.org,
 osalvador@suse.de, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, lance.yang@linux.dev
References: <cover.1792651104.git.zhengqi.arch@bytedance.com>
 <5edd1dc82bd3b0b09005c0b36cafa2f7baea6d3d.1792651104.git.zhengqi.arch@bytedance.com>
Content-Language: en-US
In-Reply-To: <5edd1dc82bd3b0b09005c0b36cafa2f7baea6d3d.1792651104.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 39CB640009
X-Rspam-User: 
X-Stat-Signature: ytxsqq7uroh8zsyo95qjm3notdou4fcj
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792659922-881727
X-HE-Meta: U2FsdGVkX19Qy0iAZnbF0iqgnsbYlyeruVJGIRaVJm7u2KuLdnLue5HGNLkZLZ+doZ/0wBv7hR5kqMj7R2G+Fdr+1VG80wwr3IIc8/jJ1izFjjKGq+bbFhCCl9olkLY2nVkqzLBsG2o5RdX3N7ZAQSKEaVvct8SMS9X/UgHEckSYnReBGrVnvEKsBC70KPfStO7MjNb/QZ1iHMmErQlz9RqGT0OqKdgYPwJp7/h2YYHj+0+uoY3buz2fkSPbHfvFNew7mxj/d6XNxdrWK2Wga2Xkxc7UvjAz2fVEwXzJDbqaur0jXm8RH1UV3mbM7+G6GpA1J7VBoym4URL82n+orGdCnIGm0aUGrrNGEz6ovt1wq6BIqRxg1kQlF/JRy6JwWpDvhYBBMdLO+zBkZUms+hLXQibjfL592ITFYVQKIZE76dz+e6rrRgLJk3ZPVCY5m+xGbHFxfgIEpNAWZbw3jh6HYKfBoAUk3xnFlMffKCVmPjFnZzHsILkRfnTNHz3/FQlJeO5tCGeCLmUxmC5lc7cFyMwKAnMUSM3jo12IuYwnS1h+aYiPXLObsfW68r/2bkO0gRoE33rg5veT4bNijwssOFFL6TjIcVUvJPwP15T4s3ULuogMrL6Ob33ivNLq/efcSQaa0Cx+/weaeLiTa2nfmQo71k8/iy9SPQN+1U7TDLD204l65D4qqfkg/wPg+nSv+j/vrdw0PwqQqFI4qLsYmYMorumRg3slhJkOTKVzz5r+q23aoowrAiHpD0/e1AobF5RMd+wFO41TQEK/Hmodo4sBLHAS9Zmp7RWQE7jRpmThRb6B0Rsv//HB6tjxdqhyDlFAjpVQ3KppzryiaEor0jtuPpfEZZ7GpNyXjEDEbJH3SeScB22OFBWoYLahRm6Xw4aYu6PJLqcxrGF0Wo72qjZ+fOqx3u4WOn3XXGA1m4UdVE7QtTs67ZUtRsOn8NBbyfQLvfxk99fVIhL
 j/NcGJ7n
 HpK7jshBk4i6CJZQooASX3T4KjoF8O6SZxHOagWDQHO0VD6ewyCg0nHWA0DCDyaXTduONg2X3uryU98GGYV6ffrNRCYhHoX6vX97SAgo3SiQTiDySDOleDUg7NcXLfsme7r/u7NbVtKhIEUAtl0ZINrtSz4YZ53xphEAqgiRoHMn7zIL43jupMlCH92EX3G+m2fHXKqsk5KzenMJmgqq4K5fVEvX0nAKwBsIcKJcTXcRkJR2FH3T0/yFveC2qGs89M9ZlHDR3GBucdFv63QAeanpdYL6Fs0w7QMTn9vLka8ERMfLD/xZpmTQo1ULZmMxrZhnz3rn0K8i9+SGIM/fpONALEFMWpnaAORodmgsmSSQ8QTK6fBrscwuWuvbBBLxYvBpBqNhRlqgbvckPRK+4KM3+Sy03OD/yRZyMn2+achKwjtn0aZ9zqcvyIRV362+hPA9lI5/WPQmrxNCzX8mFZvL1H6hmtBX+YpzwFxQM+cqZpaY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/22/26 9:31 AM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Allow hugetlb_cma=<capacity>@<page-size> to select the architecture's PMD
> size in addition to its existing CMA size. PMD pages are 2M on x86-64 and
> 2M, 32M or 512M on arm64 with 4K, 16K or 64K base pages.
> 
> Give PMD pages their own pool while preserving the existing sharing among
> gigantic sizes. Unsuffixed arguments and an explicit default size continue
> to configure the default pool. Gigantic PMD sizes retain access to that
> pool when no PMD pool is reserved. Apply this mapping consistently to
> allocation, CMA-only policy and boot-time accounting.
> 
> Try buddy allocation first for non-gigantic PMD pages, with CMA as a
> fallback, to reduce CMA migration and leave CMA capacity for later
> allocations. Preserve CMA-only policy and CMA-first allocation for
> gigantic pages.

on v1 you told Lance [1]:

> The same missing PF_MEMALLOC_PIN check also affects 1 GiB CMA
> allocations, so I had planned to fix it separately.

why did v2 go out before the fix then? 1G CMA pins fail with -ENOMEM
today, so it's this patch that makes it hang.

[1]
https://lore.kernel.org/all/04c89538-28c8-4d03-92c1-08d854a46ac4@linux.dev/

-- 
cheers,
jose a. p-a

