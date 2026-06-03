Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46DC8CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 14:56:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 198AD6B0096; Wed,  3 Jun 2026 10:56:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14A0A6B009B; Wed,  3 Jun 2026 10:56:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0384F6B009D; Wed,  3 Jun 2026 10:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E60146B0096
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:56:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 807FC1C0A0D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:56:00 +0000 (UTC)
X-FDA: 84838901280.08.D8BA65C
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id 512C318000E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:55:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=fazgitG3;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.217.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780498558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tHFJL4Vv9YiBmui2bXAlE3Jf5dI3wvXhQmEI6tHCSqU=;
	b=UnGB5Oa3ieto7xwJ8/I9LvRObYei+nEnlbvzFrFog+6zHmxVHJEGihZgDKCHAibIyFZz0b
	TalDBs0OFx+ZIcL9pY25yYRbuUstrJLGlQ1FTnTCLlFIuxNq3198ja4CxUPHHeyAXf2fiz
	8r/PBDbYrMsJkVqVcSsFRWHjAIc+QNg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780498558;
	b=rAqNo7u5gmLdyJE5qJ71OQvZkf2s+7shHw2W1XzG1giDo66y+C1xcDQsLxJZblpTv4bg4m
	Sbqh/dWgTGfF7xogiqLaKnlsHKMJteWhVkVP60jc4t1zUjdnJWQW5qLdbv0x41kQGMdm0V
	a8xho/V22YSHGNm0+yvYkunNcDiMJSA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=fazgitG3;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.217.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-6c87709aa26so2597414137.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 07:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1780498557; x=1781103357; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tHFJL4Vv9YiBmui2bXAlE3Jf5dI3wvXhQmEI6tHCSqU=;
        b=fazgitG3yCuMo+Rln8ILgFkUEM9Fw+KVVtMNV+z+DUqna4MiWMS0mYPR2Tdt8Lgtz0
         gTWq8ywJIpT4jxvqc97DZBZz97vvVcPp3a9eJ6ZwmO3S5nVGuOKOwuoj4BBRVehTmuXS
         SJ7sVtFva7zzAdZf9NgLZ32PFs80ejxmZ42Th7E2vlft1YxRHt7jx6+LzCTIdHJgRABA
         j5S6I8gJTcaHjXuZhUHsLG1wDV0B1iwXFCGbo1m/lVCKB02dQ5sGa0vW8Lqe98j67tju
         0/IHBeB9D2d2fZJpfhHVMRoQM7PgYydQz/llhZvcnL1ou/tRBjuHoQ2SS/P8kcDyUOr3
         SHuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780498557; x=1781103357;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tHFJL4Vv9YiBmui2bXAlE3Jf5dI3wvXhQmEI6tHCSqU=;
        b=ATZh0+bPAFkbMpBqDv4kQsnorfTyab+qpS3zc0DYbi/zKwhWP8zyNt+sBT5LN+03N+
         UE3t52fyOPb2D/lhX7f+zYSA9fNwVRxke/CvzB+6qR2m7M0YHmwzEkrDP7P+keuIy8KS
         WohysNbtn763+dND8fSqPrOYqH2i6cqNW43gqMGNBIQeszBoEBcEjfOxlJq/mndeTfGS
         KU/1/YtaJ4rreH+fg7Hy/dH2JcSHrJ/EZPWXwGdd2iiWvTMMDay4iUgK6R5m7dvrEFBY
         HQniLYhurHouo0zvtxm4rnoeFltvb1dkhr5uXkxGBu5Rxr+RO7eDPMfSvb/hVVgreZ4h
         Mhig==
X-Forwarded-Encrypted: i=1; AFNElJ9tqe6IeeifZDXYS1pdQ5DLRl0NNHGnigQjacmkWtkMDjCcCOY/Yi+5jtISUHH2qZJQeW7bdgXH0Q==@kvack.org
X-Gm-Message-State: AOJu0Yxhd1zrIXuUL+RKow6gLSPuwzTcITyNtln0wMLl7tkMVV1UDJau
	z3KQInyX20pXrJGR9WmuC2X9DGeJWP/4Uaf40rlWIEUBrKKX536rLVLg/fyyTXxlAYc=
X-Gm-Gg: Acq92OGqlUyMu9bnddLKnLL7f985/zLcbU0N71wsfIHcY0PGOn49TWp5v8ZDXa3stbY
	eBfIGdAuyqDHTXiM8TbFRe1jOHiXxdNGfSOoRlQ2hDXmO2czC2dxHnscvAQSbqXaC+cf3zvZo1V
	kxIJxJNhJnfRsLCyx8slOOEOZRM7Ll8+Zke2ErDbuVoqeJ9eAF03xYsAN/mAaU6IhkXduwg57QP
	6WTm9/CGRoRwC8u50boZVZ3jOeLhL+VaYL5j4vM48C3xw+790jgW7SDZ11Ik5fzoHodkQLe8m5V
	9d9CBo3imZB1QTtdkiq8eSN6LhutwvuiP2hEifQ++uCmhgOTIJ57wsP+mOh40hJ4/K/s5awv9T+
	5stznrEkuhfrjximMm76Gl4/gZ6pKrkRTOwciFMH7r3FwyQ17m/CGngdewAcjqpfNQvFN+yFq5M
	6gJceEGgRUWn0go9ZdtQbNenNFpHjVnKol
X-Received: by 2002:a05:6102:c06:b0:650:967f:fb32 with SMTP id ada2fe7eead31-6ec2978d496mr2278212137.3.1780498557198;
        Wed, 03 Jun 2026 07:55:57 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd06b231sm22007136d6.33.2026.06.03.07.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 07:55:56 -0700 (PDT)
Date: Wed, 3 Jun 2026 10:55:55 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 1/3] mm/swap: colocate page-cluster sysctl with swap
 readahead
Message-ID: <aiBAe1WQWnuGzniz@cmpxchg.org>
References: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-0-ce0219e100d9@gmail.com>
 <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-1-ce0219e100d9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-1-ce0219e100d9@gmail.com>
X-Rspamd-Queue-Id: 512C318000E
X-Rspam-User: 
X-Stat-Signature: bwfpdiiwcm189eeeoehwjpipp67xe4ga
X-Rspamd-Server: rspam08
X-HE-Tag: 1780498558-293760
X-HE-Meta: U2FsdGVkX19DhWixHdB9U1WjNlPY8qr8DZ0vr1jHBtc2Nk7tML437nwHt7SgDsJcKs2VowPhsUQq8PKuT1KmFUEPPRECcz3yIbPI2VsiTifotTzLDAhem4FMSOmFu0rFeToZ3znv9L+PXseYtRAuHc1ieEQlK9k1An4/0JKdWPJxORc3ZmmMYNN5eFs3EXVvaatbSH0KIRjCSw9bUY9DhA2SPtGM+5ejP8QCxIxuWElJg/a9LnaAZjo2rx7s9LC5ohkEFQB3a0bhiQEB4Fqde2YxVjmyqQ9vARBBuGKlnAdTgyQgy77HGUP1g+Jdvxa905Enqy5cApeew0Knm8r3gk59bQF5ZyOfc6zMuYNbI/OglVuuvKEbqs5l+zWKfhofJL54F3gMH9hWmD7e/cgvVDW0kqzsRzSTBPqvDn5IBrAk9kdEZisCTpfPO2LRjB1MZsUfgvE24vjup5ZlvL3uYXHhkwwxHmqrGp66TeCvK4D2PpQIotEyURFsMFXu/nG1xa4+Wy7BzMtMF26n094lmQO16Uec2dbxJkud7GE1suDg/5i/bI0F516hmqkIzIkJU505jt7X7n1oBFUmth1BrfI64ZUOPBiimpvFYcecPLrovugTHNPcbddgg4yJnJ1luVMyxJSiNNHFf/w2jlElbiRkBTk8Asoc7ecvePWMxGfz/PMOKmoDxQOT/vVAZuIiwj6Nrj0fCrukPtkd+63PFZ61t1DmOkd8PlWlO1G4EgL3qndeotAEQot2UoOeMXIYqNL4s9l401RfdVSrEmKojBm+8hrPhd8Qbc+lVxxIvNo/BtcamxIDd5TYLq6iiQ4HrrwN0/jR0wFpN0IjTO01gq4tIVRrhGBdWnYQNBWg4HqrOkcoU7l/z+Bc99oPTD7qKoCJnJOZJdiW1px+5qjS3nVa8W7+52WzJfOxkxywWTuHkI140unrzP7siEP9hvQJF2Onwl1W71SyoYyY1/s
 e8PwlhFy
 eQc11THBWNrvNEaURybDdK9EPBNd12Uzmyp1Ds9V7vZ18MoYRYRm722CPEuj9CN2z9zil46aana0yMUGdBIF5I0pdCHnM79rxTyzzWOpaXbQLRmyF6iP3ZcSGEIp+8QZ9pJeXrkqLqSQqrjnKFf/YneL+hL+xnZfgRBc8Xw8VmdkMO0iC+m15uezIp9qjKVFIjOarDtMalWN/5qTP1jOIv4zfV9P0xN05yrreyR+W6HHAyeITX8tVE3j4qph8yDiLWcpcjAfucLYEHlJnS6I68VnQm7RNGY/y5t/hKa1JZIRYoK8P/bZbjyRBmcvzbs1dclnL3cfPXSSD8yXU3yYJcR+z+I2HRndcON7FmPy68fd/2zkXEsqgiphUsqPTlIA2zFM2M9bMRe9o6eRMtu3GSvx03PCWbDCYf4Rt3ieiSYkHSBCc1RUQgM7P5RIHQWVu/8WThgRbEhytS9Sml4XP13iZZqYVvEVNg6yM3ntn+XedntAOP12XKsTkyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 09:05:32PM +0800, Jianyue Wu wrote:
> page_cluster and the vm.page-cluster sysctl are only used by swap-in
> readahead in swap_state.c. Move them out of swap.c together with
> swap_readahead_setup(), and make page_cluster static to that file.
> 
> Rename swap_setup() while moving it as well. The helper is internal to
> MM and now only sets up swap readahead defaults and its sysctl hook, so
> the more specific name matches its reduced scope.
> 
> swap_setup() previously lived in mm/swap.c, which is built
> unconditionally, so the vm.page-cluster sysctl was registered also on
> CONFIG_SWAP=n kernels. swap_readahead_setup() is now a no-op stub when
> CONFIG_SWAP is disabled, so vm.page-cluster is no longer registered
> there. The knob only tunes swap-in readahead and had no effect without
> swap.
> 
> Suggested-by: Baoquan He <bhe@redhat.com>
> Suggested-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>

