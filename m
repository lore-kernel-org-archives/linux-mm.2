Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1940C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 05:16:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E6D68E01BA; Wed, 13 Aug 2025 01:16:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BEC88E01B6; Wed, 13 Aug 2025 01:16:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FBAD8E01BA; Wed, 13 Aug 2025 01:16:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1C5278E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:16:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C981F1A0266
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 05:16:42 +0000 (UTC)
X-FDA: 83770574244.19.E2ACF40
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2452D1C000C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 05:16:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NJ8kdtSm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755062201; a=rsa-sha256;
	cv=none;
	b=f5hvN3ClJfSZ/qWM72mqlcHX/RUW1JBZoTa2hHonxPKQXzTr6iNxy3m7rxEe52uGckkk67
	jNlgaq2BqciSkE/rHHdHdSNU4EdokwUgbZA/AMUeugYZaxYr8kv6F5eyBKdrmQMOdK4kM/
	4zR8mLQQBsMQIXkcgj0YWMg2F26Kfag=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NJ8kdtSm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755062201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qliO/ao3WFlCOOgotU45EFsgsw1nG4vz09qlzIJSLSI=;
	b=TU4oFN29xSUbJSsGJkIjdAa8KvtJc9Vl7JPO342G6o2AdurQpwRL6VzkS53Q40uj3iphyb
	hP/M+CnTq56dY2lflP5hidher1UcFPXuwNXKBspgYPBTqWkP0dnfSnn1edfzcTVeEyT9ud
	BHzBgQQhYAPCpXlkPrYomKZ+66bc4U4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 30E48601CE;
	Wed, 13 Aug 2025 05:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6485C4CEEB;
	Wed, 13 Aug 2025 05:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755062199;
	bh=QHGINcBtgZyN5lwSuC4ihOdgAfkWxrXCvNILJWMOBVA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NJ8kdtSmVYuDmZ9UTC9uyVZDWkHKpE44JmKlAUuCa7NZxop2ZK8q7CC++ZZVKGYqf
	 2FtFO5vBHtDjYhIFJTJjQSsJRbxUaf0a5k9GCO/vI0kEc2Amu0RlAFK5LI+90qUwE8
	 Wt/HmHsp350LKxT3V5edx5EIk5k5/dHroc1gWPsZBPQTy3e4Ep/IgKDgKWQmnFs0sw
	 6cqFtidy2jtFeD3RQfgLFaCCGVcqzgmOXefeTkU64Ioo3+VbGhOKm4ArnHUoBv87xd
	 3Pvm2U1X+nJMrmwtp/okmHBkuSQR3Yb1oCRfS+C3ip0SypefYd4i8fT0xp5j3V9lPt
	 9tySUkpa34FBg==
Date: Tue, 12 Aug 2025 22:16:33 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: Dominique Martinet via B4 Relay <devnull+asmadeus.codewreck.org@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Maximilian Bosch <maximilian@mbosch.me>,
	Ryan Lahfa <ryan@lahfa.xyz>, Christian Theune <ct@flyingcircus.io>,
	Arnout Engelen <arnout@bzzt.net>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Dominique Martinet <asmadeus@codewreck.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] iov_iter: iterate_folioq: fix handling of offset >=
 folio size
Message-ID: <20250813051633.GA3895812@ax162>
References: <20250811-iot_iter_folio-v1-1-d9c223adf93c@codewreck.org>
 <202508120250.Eooq2ydr-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202508120250.Eooq2ydr-lkp@intel.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 2452D1C000C
X-Stat-Signature: 6i9o5ki51bhzq8c9duqq9n3oh84xxfnh
X-HE-Tag: 1755062201-716088
X-HE-Meta: U2FsdGVkX18omypekfPY+eCrSHyZKK2/05sAyWmcfUE445O7ry0OCeFZcCt4W7EKPzCqeDVUG4OXKlY9caPf2Ez8cpJOUshsL1FOMlgGcT5Si0F53YKcGBAhPOGa8pnNUr5cQ0DP+am/Z59HF49RPXjzxV20lXzL/wn/k1J45wihsA9QkZGheIutkn+VYhGJG0+chxvs9kwG0Y7MC7s/9byf05WYZ+Iyknt7obGdaMTu74EPZEAlXnJFdDUD0e6crILPFfXb7zunswHajW0kM51v564y+tSMcxgiOskyIpQf6o/iqogH73cCd9uk0xc7drhwX6IS/sStWvyH+rUqDQ55Q9/8Gu+VC0b/Qo6S8s3rtOHx1FTrKTn1E2Izlk1ZOzJfSCyedX1YHADKxBb0q4zev/XGzzm7zC1Wa47PNEluDTPm82UoL7b7VgKzzMrfT8QCv2jr9qTMF/xRtafbVb8rbr0aqDP8ooOHoK7R+kDzlV6bLMPaDWUW/qRjV8A5eoU/9v3m4fmSNPRMsLLbtiaYCKucechr/jVZ0tC10kd/kz0KKUIjnlsJHp6Fhk0RVl1PAgJFX2/bInu0zPFM56VPUeu6iqGGXogmOgaqCsMmf88E8FqZ0GfP7LRpu264Ce9J2o1d+5trOoF+vtKmWco9ZcroAcD+XjhmEwli65fJkHwZdKKSWhrkKfCAGV4SJ4hZ5B3C/cVKSzxJmAlGP+uUtKB7XMhW+nWH5C1wz9PmclikndoVJhkNnh4nD6SSZ2YnXOceklq0Whb25ZATQiUGicaNyZEdAa7uoZItLLdrh47A0BM3dXZ+UFKY77RnSLR2DrmVAI/z33e8zFqEv0oz1cUBxMkpq56iTg6YccNodb2thekp/9X31yXxRzkzJ6nC7rNEVZHsQv2u3lNI431M5OXlwzroofmDAmiRrAmm4DaocZb6TiIb8IeVFMg75cpH7jcB+IoY/IwK7Mv
 SA3haRjn
 kRi3XMolFd4cC8hR6UrPh3E5ZVFyXS+h+Vi71x8BbfZRXv8jHiwv5NvuK3+VcEjlg4PTAI6SW54FmP5LvbDWcV8qV1QHiRxhO4rZHrvUcV6nLJJ0w9mo4CLUOniSrdPll8eORkwX5VeSOTCkostTW3cMRWn8Vug3WacCDRwNIUxmojB4hykjgHyVvbP764bTkKAqaIIhTUa578553wR1+yLaGmoRT2h3RxbUZzcjGj9ypFZk4yl6FIOa/5ywl4q4G+u4NidQlwUtaR1LWspEdDdl9lJdKFRBBIVW8iIoo9aMDjD7261ydqgB1UtTom4frOgOVHY+B1KirJKFW6XGaPJei9qS0XAVHSn4BbnH1vyv1VjA/DLK8KRpf/wdbpA7J0XgNYh9fPqWJaLDLvX+6IDEXkKbAOhYZTJhN4MbNiV8Lpof/WZxKZjSfCKbiTW7Hfj6DUYGqqp3S9v1DOkZDMEWr4GgemzylxT3IgNAbqhKoj6lXgJBbt4U5LGwq46W2vNVwhS1DHScPp8aiupvSs5koFWVAmg/aJl2ANN8wpnx+khR9Jbsv0AzUUNsV0r7WpR1XK29NRG0fdbH+bYofBtAvpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 02:55:55AM +0800, kernel test robot wrote:
> Hi Dominique,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on 8f5ae30d69d7543eee0d70083daf4de8fe15d585]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Dominique-Martinet-via-B4-Relay/iov_iter-iterate_folioq-fix-handling-of-offset-folio-size/20250811-154319
> base:   8f5ae30d69d7543eee0d70083daf4de8fe15d585
> patch link:    https://lore.kernel.org/r/20250811-iot_iter_folio-v1-1-d9c223adf93c%40codewreck.org
> patch subject: [PATCH 1/2] iov_iter: iterate_folioq: fix handling of offset >= folio size
> config: i386-buildonly-randconfig-002-20250811 (https://download.01.org/0day-ci/archive/20250812/202508120250.Eooq2ydr-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250812/202508120250.Eooq2ydr-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202508120250.Eooq2ydr-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from lib/iov_iter.c:14:
> >> include/linux/iov_iter.h:171:7: warning: variable 'remain' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
>      171 |                 if (skip >= fsize)
>          |                     ^~~~~~~~~~~~~
>    include/linux/iov_iter.h:190:7: note: uninitialized use occurs here
>      190 |                 if (remain)
>          |                     ^~~~~~
>    include/linux/iov_iter.h:171:3: note: remove the 'if' if its condition is always false
>      171 |                 if (skip >= fsize)
>          |                 ^~~~~~~~~~~~~~~~~~
>      172 |                         goto next;
>          |                         ~~~~~~~~~
>    include/linux/iov_iter.h:163:22: note: initialize the variable 'remain' to silence this warning
>      163 |                 size_t part, remain, consumed;
>          |                                    ^
>          |                                     = 0
>    1 warning generated.

I see this in -next now, should remain be zero initialized or is there
some other fix that is needed?

> vim +171 include/linux/iov_iter.h
> 
>    143	
>    144	/*
>    145	 * Handle ITER_FOLIOQ.
>    146	 */
>    147	static __always_inline
>    148	size_t iterate_folioq(struct iov_iter *iter, size_t len, void *priv, void *priv2,
>    149			      iov_step_f step)
>    150	{
>    151		const struct folio_queue *folioq = iter->folioq;
>    152		unsigned int slot = iter->folioq_slot;
>    153		size_t progress = 0, skip = iter->iov_offset;
>    154	
>    155		if (slot == folioq_nr_slots(folioq)) {
>    156			/* The iterator may have been extended. */
>    157			folioq = folioq->next;
>    158			slot = 0;
>    159		}
>    160	
>    161		do {
>    162			struct folio *folio = folioq_folio(folioq, slot);
>    163			size_t part, remain, consumed;
>    164			size_t fsize;
>    165			void *base;
>    166	
>    167			if (!folio)
>    168				break;
>    169	
>    170			fsize = folioq_folio_size(folioq, slot);
>  > 171			if (skip >= fsize)
>    172				goto next;
>    173			base = kmap_local_folio(folio, skip);
>    174			part = umin(len, PAGE_SIZE - skip % PAGE_SIZE);
>    175			remain = step(base, progress, part, priv, priv2);
>    176			kunmap_local(base);
>    177			consumed = part - remain;
>    178			len -= consumed;
>    179			progress += consumed;
>    180			skip += consumed;
>    181			if (skip >= fsize) {
>    182	next:
>    183				skip = 0;
>    184				slot++;
>    185				if (slot == folioq_nr_slots(folioq) && folioq->next) {
>    186					folioq = folioq->next;
>    187					slot = 0;
>    188				}
>    189			}
>    190			if (remain)
>    191				break;
>    192		} while (len);
>    193	
>    194		iter->folioq_slot = slot;
>    195		iter->folioq = folioq;
>    196		iter->iov_offset = skip;
>    197		iter->count -= progress;
>    198		return progress;
>    199	}
>    200	
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

