Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37E43CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 12:45:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 802E98E000B; Wed, 10 Sep 2025 08:45:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D8A28E0002; Wed, 10 Sep 2025 08:45:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 715A98E000B; Wed, 10 Sep 2025 08:45:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5FB198E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:45:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 07DE05B9B0
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:45:11 +0000 (UTC)
X-FDA: 83873310822.17.88657FA
Received: from smtp153-170.sina.com.cn (smtp153-170.sina.com.cn [61.135.153.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id 64E67C000D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:45:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=NcWVxE0H;
	spf=pass (imf10.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.170 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757508308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wrI27L50Krmhj1fPADGXvtbzVUmtq03K20RQqcV8sng=;
	b=SR75XVi6tBEBHLWD97j5K1MUdf/QLjMRD2J7O4GueUFtd6oZDW2iObmlCoTBDbwD3JzErz
	ADkH7UYa8jYRKLeECKX7GXGOxLdRxSQ+5AkrqRkXfpyOV5ocnua9S4ygs+aI1dpt/A94J6
	IMFYNs2Xrx6LGeFePvMQ227S1H0J5W4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757508308; a=rsa-sha256;
	cv=none;
	b=ARozwmJxPaAIUqShYZ0vFrX93zOKmkUV+Z7YynIRTwgpgRob3icQn+FASv8dq6Sakkklaf
	uiB7v3T9VcX1ZJVd7tYu/wLd5+6WmFXsEHbzlNS5rYATmoDx6Wd4uRn/zddF4hytgM3P4o
	AK62Ky8WjdPZVMSbPLFzwpEw7DPRSoU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=NcWVxE0H;
	spf=pass (imf10.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.170 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1757508306;
	bh=wrI27L50Krmhj1fPADGXvtbzVUmtq03K20RQqcV8sng=;
	h=From:Subject:Date:Message-ID;
	b=NcWVxE0H6KMVQXXNfOsaZA3Ra6YyOM5y6LITw3sp1BkAHTLN8jdVQPPb3ShBQ670T
	 PKvGWyw9m8a5B6StteXoFqLbKljAQWVccAB+/n7PphB0Gth8eFD909efvMzTy/2JxY
	 jHMNINst0oszr9y10uA0Kt64RUV+lyCTKunhDfGA=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.34) with ESMTP
	id 68C172CB00004803; Wed, 10 Sep 2025 20:45:01 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 8252306291757
X-SMAIL-UIID: 7D4C23C301F749E79BF9F5BE7AA477E1-20250910-204501-1
From: Hillf Danton <hdanton@sina.com>
To: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Robin Murphy <robin.murphy@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: Excessive page cache occupies DMA32 memory
Date: Wed, 10 Sep 2025 20:44:49 +0800
Message-ID: <20250910124452.6747-1-hdanton@sina.com>
In-Reply-To: <9dc9e324-4a39-43d0-8716-be325fae2247@collabora.com>
References: <766ef20e-7569-46f3-aa3c-b576e4bab4c6@collabora.com> <aH51JnZ8ZAqZ6N5w@casper.infradead.org> <2025072238-unplanted-movable-7dfb@gregkh> <91fc0c41-6d25-4f60-9de3-23d440fc8e00@collabora.com> <2025072234-cork-unadvised-24d3@gregkh> <c93b34ca-1abf-4db0-90f9-3802ac02c25a@arm.com> <bdd1efa8-691c-4e84-8977-cdfd48e7363a@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 16icemmftyu38hggqgjy4mhgy3fm9msu
X-Rspam-User: 
X-Rspamd-Queue-Id: 64E67C000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1757508306-736041
X-HE-Meta: U2FsdGVkX19JuwrvYb0ab5hnTog/BvSewbabRQM352qD2b0EmrHar1/Pi5AMPY6BK6r56YAS9cbLffKCBKLXKyUpBW3iG2iG51uGXUvo/qhjdYvRz27bwq+PQfcV80h0HYP1mXbJd4r3CKH4RUrWmoExgy995UGUPKLU0kbz442pv5oEcbGF8HagHGos5s5Q0TYkwK5ac6UDHybPDO8AaZIDp4mrLvQoEFHQP93e4zJY0Oz5pMLIR6y58gipaRyoboar4CfcLkCSB28FHYRHBzTgQ5oF1MF+zs7/Dd4u2M9t7AlTaE4t+it4gzhXk/3xMnAW4HEGYmd+2h/zmAGOGAaYSuXDBQ0vnmWshckj24V8DCSU3rHSVnwKGIj5EleRoZsnw0yYxAb8+3IqsMmam559VHYe9y2AosWQ3vvaf+kEEkGrhx1YYcM2fdcJS8onoqF4q0h2VtsEaKP8F+ynLvDLRZ9tcc+WhSl7OhccJ4Aara3+ShKmyTVm529/hWFcMdS085aIr5E2btrcNwWQeUiy1xgI4dkUungmnc2zMp2JmBFL3nUIpfkOuDWQ4jOAw8tLulHunwGPLbd5kyIlwHeO5XItnQu/i/IoJBXmwRScNDdPRmFKKEEz9bxzTQ5vWqsEp0ur6V8yq8Zy5wgJAI2yC6aKYpenK3mqRxPhI7v77DAhNWRkAgetAtxUSgI1zX+34G+HhWo5k8zslPzCMXxcJbrVtxjdWm6w6C8AUtp1SnVmSr8olPqYGG1hDzVnTHtAet7z2M/asd+4UoYyZUcrwNwg9QrTpLC7jMTamI3vk6Tv8iBjsKgZQqLMppNzs6/XbSb2CFwOnnm02vYxwpp/UM3Nrrk9rwr/c33ELcaFXenomVVpdRLHgHDj0vKB1RyMpkB6B7W+rMxLvTazJIul0kRk+VipFXEOH/E8PjEt7l2jokYwefFi7RwiQ00kbKNt+CEwLYOU7lgMPCt
 laSptIYv
 M8GNmzaiLeaM7K/uahsjMjahRepuawYcEUNOmpBFwsc9CmM5mc8AGQQnyHevh08727Jvn7vyw2EvZ0YbdI5VgvNOGwAX+YdMxdOEATVW3gb0B6+qqzB2aCXBYAkVRmtLUD0n3p6z7xiKBZv61mYzvE197YBAeWsP5B+AM2z7upzbq2KGdLtIepLK2Ma8fefJMvJoR3tJ5U0MlDp3Inbr5v1yrCUSDWhmLRp4x2wqmZcni6hhWM5mPRUA1/gEYhVKuTpGj8k6w6hg+cj2gFHYM+quDpW8pNX39WJyvMtp8Jc0Hqvx9n+Zrze0QWcmTdJGURAodxudaZL6UTjzzkFKVct3m22OTerPXmKs+P+K/F5+Sv0m0VWpIRDvoYqSfCa6p8k2yLJmStxW3zi1SgPgUKXhBFyX5jbJKDUr+CfgWSpJ2+6kcSphSr9qEQ5Utjzt6FxspyiNbdg+Vza8E6QVeEDTRhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025 16:23:37 +0500 Muhammad Usama Anjum wrote:
> >>>> For example, in the mhi driver, the failure is triggered when the
> >>>> MHI's st_worker gets scheduled-in at resume.
> >>>>
> >>>> mhi_pm_st_worker()
> >>>> -> mhi_fw_load_handler()
> >>>>     -> mhi_load_image_bhi()
> >>>>        -> mhi_alloc_bhi_buffer()
> >>>>           -> dma_alloc_coherent(GFP_KERNEL) returns -ENOMEM
> >>>
> >>> And what is the exact size you are asking for here?
> > 
> > 512 KB
> > 
Any order above PAGE_ALLOC_COSTLY_ORDER is not guaranteed in 90+% cases.
Nor is it DMA32 specific.

> Another update:
> This issue reproduces on v6.11.11. To summarize, we're unable to reproduce
> this bug in the v6.15.9. We wanted to do bisection and find out which kernel
> change has caused/fixed it, but it's too difficult considering the complex
> reproducer setup (Tekken 8 Demo game + page cache stress). We don't want to
> spend more time on something that is very hard to reproduce and is already
> fixed in later versions.
> 
> My debugging has shown in v6.15.9 that the allocation succeeds under the same
> constraints of power management. My hunch is that somehow the dma memory

Can you try again without the JW work [1] applied?

> doesn't get occupied to the extent that dma allocations start to fail at
> resume in v6.15.9.
> 
> ---
> Thanks,
> Usama
>
[1] Subject: [PATCH 0/5] mm: reliable huge page allocator
https://lore.kernel.org/all/20250313210647.1314586-1-hannes@cmpxchg.org/

