Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE627CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 12:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F04B56B008C; Fri, 29 May 2026 08:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB5496B0092; Fri, 29 May 2026 08:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCAAB6B0095; Fri, 29 May 2026 08:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D02896B008C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:35:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76260C01BB
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:35:47 +0000 (UTC)
X-FDA: 84820403934.30.4BCBAFB
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3BACF1C000D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:35:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ZiqMSo7T;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780058145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C8tyG14nP5ARAFOFatQyu1rvTUj9VVrrHucz+LTuvp4=;
	b=n7Qly7h6xgjVIT8E6VAPY38J1m+lSU1o2MuFc9RA2y/IqkFfNQ5k5lz+nFqo7Q9k5ALivk
	+PT9pZPgPx+sehZ9cnBFIK+ozOXGUshuy0vz1FRo53D39bXrd6YOQ5nKwttBxuqNcRDmed
	zuCOAI4p/5q+6dUOo8UMlwBviYOv3Qs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780058145; a=rsa-sha256;
	cv=none;
	b=TvpuTGdOJ9uTjIMwyfgjUjkoXnXukI3zZyHej2IPl8OD8fWhDj4p3n76jkN2LZafSGZNqi
	th888zCdcG/iknxIwgL7sBaOI/JqY7hLWCaPqzCsI/g7kj+4H9aN7ilnC0XWHqdrxCvgjg
	XpamYaFPj/rXc1W4BRWAbKVbknPLiIY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ZiqMSo7T;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-914b03e42b2so940937385a.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 05:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1780058144; x=1780662944; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C8tyG14nP5ARAFOFatQyu1rvTUj9VVrrHucz+LTuvp4=;
        b=ZiqMSo7TnlyHhYCVBrzUfKfwdvtQSLqhVAJ4qx6xFIxE8xOQF9ubPw+niEdybxHB+U
         6ITpxhNRUm+4cIUpUW/bZ8KFBfs0h91iGhMeHCBAnuwi7PyqnXmPZcRRreu24xMtx9oY
         xLsQ+ECxAqIqmlab90i5j0LqOk4fPGpNrV8pLJ7mBv0pXyx8+HP3LKrJqF4bcLwKtDu8
         QlX5128Q1lFF7cGZlf+KaXPXyP6q7p9c3y5SpzqffIt7iQmiw2POf7CZ7zFPv3QNsE0B
         nf0iZ7GvxbVT+I/vE+OtVUu6/3MLG7Nmvd8iA1kM+26Q3HxTh4CgVoDViaeppz0GC187
         PNew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780058144; x=1780662944;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C8tyG14nP5ARAFOFatQyu1rvTUj9VVrrHucz+LTuvp4=;
        b=VpSTJa3ga9ws8wRTs9CSlSn1Qz4LmMkwBC8US/9B6GAlZ3tXbSMY6dWpK6h+D51NYw
         4iGxF0dX/T7WgYYX23ldfOpp3ew9kV70Mo0eFo7PbNddwDkaF4WnlHCQIColXlCBrKYS
         VVwNL1ozmbyKx6dr+n3DWgqp91RYK5bAdg12pYDBxw4bCYaJniV7e74IdzShKg+eOjyf
         KfO8vivh2aASMdKAA4/QNB+lpbaLkgUsOqujyDUbdChqzfQOG2rlua7jHCb8Kg66IBDE
         ve2+rVYTRIVAjyckNJnSCZOSG/9w8HEhIEjBEi8nhwqxJRa2V4W1tr71ujPk2WHhKpdA
         2RKQ==
X-Forwarded-Encrypted: i=1; AFNElJ9lfuGS0/fo6ZAvJWI0y5Mhd5NPB2OXGi7I2URHIlbMc2MhTUdcid94SkTdKKptvWVczo2MYcdrDw==@kvack.org
X-Gm-Message-State: AOJu0Ywmrckzx/BJEFfMZWvWfcKOGaX7VFpkVfaLHCqLPvDZpkRXAzdq
	Vof5b/XpYOJynPSliM0LVAv6CKhT+I/EO/R7krwPMilyodOVqn/ejj2A7JVETf5D93s=
X-Gm-Gg: Acq92OG0e4S5QayZSQc1Kz8dhNuv/vXzeelrS0W7cMGnQbO9XvMBaoNIphDuUjCGcnV
	anxzHLsB+V3HcGa4iKpqROnWAwHesJQiga8oRVTOclvrg5LEyTB0A3c6gbc6Ky5iVCxnM6C48H8
	3BLTSUrEMVLveE3bHBAq0Y6+pTkv+DZhi4nj3GbTvRIc5iN0dc3lk3TUsHaH5HYBXWDbfTrpHwl
	HDentzc+O08yVbThk59ZAanvGoZhahEdStg0iadJSJCuUl96gkXbdad+bHot0Jsi6tPK9Z2S5SU
	7V+DfoecbT4psplvSN3Wuyum7Bm7kb6MmBQne6WQOALzFAWklUOtLim69Qzup5XArQfzx+Slqqj
	ZYhkAlQi9rOPaXJ0anF4441EY7LlSf1AJ992GbZSyMIrQyyQUPS7aoXrOXMJ1YjtSgDbj2orWaF
	sCwI+m2DRgo1Xe4d3c6PxnWkeKrr2hJoel
X-Received: by 2002:a05:620a:2982:b0:914:bd3f:b6d0 with SMTP id af79cd13be357-9152fdf204fmr323840685a.31.1780058143430;
        Fri, 29 May 2026 05:35:43 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9153262d1b4sm172594285a.39.2026.05.29.05.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 05:35:42 -0700 (PDT)
Date: Fri, 29 May 2026 08:35:41 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: Re: [akpm-mm:mm-new 429/433] mm/swap_state.c:468:19: error: call to
 undeclared function 'folio_memcg_alloc_deferred'; ISO C99 and later do not
 support implicit function declarations
Message-ID: <ahmIHZUg2IRrSgnm@cmpxchg.org>
References: <202605281620.lc3rtkBm-lkp@intel.com>
 <20260528151618.7aa255415825c8d1de6ca437@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528151618.7aa255415825c8d1de6ca437@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3BACF1C000D
X-Stat-Signature: ejy4aajuy57pnf5j6h898ajjfq6yc3wt
X-Rspamd-Server: rspam06
X-HE-Tag: 1780058145-929447
X-HE-Meta: U2FsdGVkX18ZnUORYntcR1iU2ilmM5jDllZY9MPqLqDB5Zh6l2/LaTCUZKU/RibzcMc9mObRrJJrznN/1cX8EyDXfUIRNKRUTXggoYcPe9ybVofncE65o8Bcdecxj4dmSHqub3KYcY0Kg5w7Zmqr3lvRfESAmdUUJOLW/nj3Z4ZCxYli3EVcxHTnDJEvQIBKxWcVFSNW7ZkCe0lPVFN1C2etqnnuhK3oib3EsdnmrcAbi3duGNVzxBtdt6vNuzoYSQlRSsPAtPEvlNCkJQzQsRW5XH0zk6QyZ8rqwcDLCcXVlqrMxxF1wtBX8petES3vYFVa5a2ejhueTQ9rnCX8+rcg9ts7V5mBwdKiAV+dpjEPm6pvY24iPN9waae1vixOSY+z8pcEnxGLgH4G1d4NMI/Ga55TGo92IZBgKC8K0fU/A4odXJlHj+ANsBneChKc9RjFRNg+HVWYahr4ahOkvrLdkJEJhwHPjShD0n/iWNJ/Xk/wz5cP+hKZRc8xoPwQeaFWBtt74+oSLDw3pSVbJ/Yz0zrQpT53cwEu0p0rBeuL0/Q1jGGMmbyVmNjA5LkhRuowUH4cYDqwtC1DwKWCM4x+X9bJXQjz0oF0A9IJ1wagyITG88RtkXYIBpB/y7s/HFsfcNSAUPGghNn4aBrJ2EVJW1TYynBKrVGZuZ8fmKLu84v8LCqpIxzqKI/6sTC/4mlhE2ZjzUExTBle40bYkTBemiYIKVpllJ2Vl/GC6q71z47t6dHaXH90tZK6/xUGmb6jvAq44wfb4tRHLEPtED1j/2K2NYNvvHLCFtkVOmGqcjDUm/ghCLpYphEFoNmRngOGhiDDnFCZ99EG70sId+0zxoX7i47lYEzVWSsQpRSTmu+CNG5Tdi3OqZYcbMjkV237vlFOkkDyzTxYst67E7PBeCGutb+lDmLlgJsJvaWO8rx/19OtfZ/JYcoyfQrTcWdk7TwxMJ/5pMWIYJC
 Zqr5IKL/
 wF2Pe41eaucvLSvBEih9ToEpn5jWf6vhXU0g2/aRC84fkv6gIRQA0I1Dskc4UKxvA3tcpWNbwBFIDbgcD2zjCdCLnnuEzpd8AJp6LYnweiZ4c+UvQFmyvWylH5jXqh2Ku522tEXP1DPn0VVrIPeamxUwFnOCiPVVTOqKtqT+nrFsdZ3Hzq59gvTxAAlhPQVVQd4vE8FQuGBs1LCQfoEka1BX6e2j6BjkCYYFdwwxT3EJUDHTHGakvuDGpnOS5Ko7UTdgisnHZRZFtILWn/bXtZu3+ZyH8thSWA2c9x6jNMNs8DXuDJ7kK7YtBxJ1svIzaSBOgAAOR7NOfcAuTD7QDUq7Gh7HExDJ2Id4LROYWfPKbo5NoKOJU9n7MZXPZviZml9uYk0bN95ex+5DjDUihdeT6AMAEdnHcCleVuZnDXd7MbX5pjUAwWV+248ojiO3nI4RgKTgjvrq0DqH4pnW1sGKfQOdyDXOOf1UMRNxZj2dgTk5lKjuXbscC5EZvHc32/Iq4ci5Pv1WG1bi8C2u/ZA4ZufWX0iktQqMlVYdYe57wM+g8n+XTuhPlHpGRcVhL38X8lYWn+h7TtFIqSKk8XndLnk+JUVl9f+hCw/iWF0Uc9WXT1nnnn0xptpDM4EuHu5yBTV55dVXFgrqigZq/ktCTgjPOD5pbp4GkavJC6hnkmQ+bxOJ/SzjXe6ZNY4kg35J2hEoc3I9PpR6Egq1DMIJzeaKEeOch2mKWaR3v/sOftd+xhNlElKiKN9+Ai4S8JnK4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 03:16:18PM -0700, Andrew Morton wrote:
> On Thu, 28 May 2026 16:15:31 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > head:   d7d405cc33d6e3eeba2d6ec8f0b595da2a5c600a
> > commit: a5e62d9e00dac6f96174c397a82da30e7ae53064 [429/433] mm: switch deferred split shrinker to list_lru
> > config: hexagon-defconfig (https://download.01.org/0day-ci/archive/20260528/202605281620.lc3rtkBm-lkp@intel.com/config)
> > compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260528/202605281620.lc3rtkBm-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202605281620.lc3rtkBm-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> > >> mm/swap_state.c:468:19: error: call to undeclared function 'folio_memcg_alloc_deferred'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
> >      468 |         if (order > 1 && folio_memcg_alloc_deferred(folio)) {
> >          |                          ^
> >    1 error generated.
> 
> Thanks.  How does this look?
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-switch-deferred-split-shrinker-to-list_lru-fix
> Date: Thu May 28 03:12:45 PM PDT 2026
> 
> fix build with CONFIG_TRANSPARENT_HUGEPAGE=n

Thanks! SJ also sent a fix to this end. Either of them will work :)

