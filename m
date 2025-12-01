Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7644AD111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:10:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39D26B002B; Mon,  1 Dec 2025 04:10:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10736B002C; Mon,  1 Dec 2025 04:10:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B284A6B008A; Mon,  1 Dec 2025 04:10:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9B36B002B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:10:43 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA7B551613
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:10:40 +0000 (UTC)
X-FDA: 84170331840.03.426C9C9
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id DC3C740013
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:10:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=cIk1C9kt;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764580238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/xH/xl4gTjMEdzE/YKcmGTPtK0Ad9BuJAHEgDFNDw3I=;
	b=oUYK+DuUTE+VWBiQogdARguf8mFBBG22p9Ixa1NFYPHSa4QpuhvbPXq5p/zKXFx4Dkx3wt
	TSY8rG59Zxsvu62/iCKTmaEf8IZlPapM1RFppdiDebg+FcnNyKdPwqewRTBxvCyIFjWpfH
	7DV40FWGjYyeylfHNVLdzeRMiCtSalg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=cIk1C9kt;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764580238; a=rsa-sha256;
	cv=none;
	b=s4yvb4pxh6wb2GfhTheICgVYIKG3P8eq57yX3Z7mSbpVz2rp0EffYF0IwzBw84eLKvY3TR
	yGkB22gAKSb94kyNBkXwfs6rcVB1SpfYco9eniTHLDLMyCt6dJlYiyirycW9IixHoMbEho
	MP1xJ/g6w6hn15RHnRwn6grDa69Cd6o=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-298145fe27eso63499335ad.1
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 01:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1764580238; x=1765185038; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/xH/xl4gTjMEdzE/YKcmGTPtK0Ad9BuJAHEgDFNDw3I=;
        b=cIk1C9ktRLD9Q0VUEK3h5hsu7heD7meUs5C5SrQt29dkOE1VEkF/6lbre3Umu7IeU/
         iaxsauSw5XxuW5mT5BgrWe2oTIR7GIHoBlOP356D6xTS4ZzWpnLESreAvcsndsM7FLbu
         /loL9DIyJ5PYQ/SODg5bJ94i0BAPj6cm4lduQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764580238; x=1765185038;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/xH/xl4gTjMEdzE/YKcmGTPtK0Ad9BuJAHEgDFNDw3I=;
        b=Ut8szxqgvejPv0bAaCrWfBDwN92AlLGD608n2j8yDYOe1Q/p78rUC2MvN8Oy3aQspo
         gyFEOJSkhTHPVpu3GcfkRHCDhQ8oXwgUAayhmoyMF8KQMZ7lB4I8ngo9Pt8ZXefAoAph
         sfD4Lz1PqLD39Ckyuos/6RG7GQ7dose1m8kR4D89CYVPjZostLikTsrH9a7dssMbu8p8
         JPwgi9Hdx53jrFdoBY8izAMu37ikv91cj+rLbZiEtccAgehQrwRDN6jQrgTohpSPhJ47
         idMUHK9LBLT3XXFyrVrJAVNbGY+4xa7JtR9Nywix0nBrG9dDCEfS6ZDsfGCCh0IfnhIw
         N4Aw==
X-Forwarded-Encrypted: i=1; AJvYcCU4fFQ9v9oTXr1CpS7opSuHkiOhZUtj6MaMYc/7icjvTZ57FLlfRbbuqMXMBk8wYe29yIQDkWcLkg==@kvack.org
X-Gm-Message-State: AOJu0Yz/Bakuia2+5jqA2FXcFEb4cVkKyaF4gnxX7mWIcrSBnkRu4o7b
	aBY4qC7uu/ZOtMOVd0XeQaKYPaM5vRx5JK2ljgR5+DllL7Rz932MC2XnsS9XBSGH5g==
X-Gm-Gg: ASbGncvjY1H+ZZyBj+CdW6OEymnyRm1Mb+K8GY8vKO7I9XPLXhezR0Jfs2pWPG7JEWc
	2ISO9KKr7f5X88bZXHvlhbLgK/crrGvRv8ehKI9Xmv+ILpDM+tnv4KkfskqaBxTkXjWBLlh3dJH
	En3PVTFmBxR/REX4wj+phJTbz7vO8On19iEIUHqw3En0UgvNbgLHBKYqKw4umUkAmVDALsAT5kk
	5snry8axB14kVMQjsbVnbdowc9gpMEw0xyFJJQnjYsbF+CBhTJ/S7ShJpmkxVQwgY4uldc/wdxl
	bu+8avpJCmD8KDpTM9JOT5cg8ITHeO+M31RSFwdSeiRLuPVQIKbF6UIWCCdh0fRDnc2qc3/JTor
	ZtVf4GFswLldroFDgC9HrJ1CaTnZ+O2ehrh4ilk3XCErV+dmHMetCcb4+JQPxpFIT/y6QJEluqy
	+yAE2J2BFCB0y1Me2dUwpAaIF5HbGPs/SD9BKOK3vTTWCe7yMP448=
X-Google-Smtp-Source: AGHT+IE0IPVwLtIcqmJPMQYCZMufINocvo6ueSZaKn00EQEiT6g2KuSYP5RewdIVgIypUPwe2Riu3w==
X-Received: by 2002:a17:903:1108:b0:295:8da5:c634 with SMTP id d9443c01a7336-29baae422b7mr220139295ad.9.1764580237703;
        Mon, 01 Dec 2025 01:10:37 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:943c:f651:f00f:2459])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bce41afe1sm115517985ad.1.2025.12.01.01.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 01:10:37 -0800 (PST)
Date: Mon, 1 Dec 2025 18:10:32 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: kernel test robot <lkp@intel.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Richard Chang <richardycc@google.com>, 
	oe-kbuild-all@lists.linux.dev, Linux Memory Management List <linux-mm@kvack.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org
Subject: Re: [PATCH 1/2] zram: introduce compressed data writeback
Message-ID: <tykowgjsd2gogsufmlz5vrh4eov4gnwsawrqx65ckf2s24cqwm@utqeq2m3cgw3>
References: <20251128170442.2988502-2-senozhatsky@chromium.org>
 <202511291628.NZif1jdx-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202511291628.NZif1jdx-lkp@intel.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: DC3C740013
X-Rspamd-Server: rspam11
X-Stat-Signature: hor53wcery4m8qprcszyh5ax7heczfiw
X-HE-Tag: 1764580238-14096
X-HE-Meta: U2FsdGVkX1+kzENrfFnLOpMz5EYxaf5+TNk60GOMMqwnR85tuPm5UGZs/h6mz33e18OrVWYfphoSsA5Zr23gokGL50sLN8Ed7S3O2vAthsk1hoMGGOVUWljDxPAYilcAhMOrqf3FQUdmcb/4VPwhoDUMwAoIXqGe8E2+afmjbsEYW2URB5DMofCAeJbN4IP/8Lysg8HIZnMAsCKVJBBRyOkHVMU7sAEFD1nuEt2SGILAdzuUM2z6W/ac7RFHvP0e/9eKvVbEOq8Lw9v7zJX0DPmgxQGMjMV7utAxFmTK/n8CWY9bSi/h5evmSWDH1HGnqb76W3AWPqhm7x92mX6XzX1O0hzvM/bFIcweYdlYilkOCR5JkkM8oLAYunx8wKaOHcEXAIjIfhO+F59dkBwET/ZZSWwUFIutmJOfDVjAD4bTFlHb+WHH6WXwSWYHCXK1bxRLvX+C0Z2RUNG7StY0lEuu+PsMATdfnouAtqIdZv4DbGGK0Op1UIsgoNpcU4bK2UaUfdJwNIjDcLvlNe3VKEbCDTtB9mh7Tcp9l6G8+mIWTIBDAjf033UH3Y1iqN21qhrjvL1DsJe2S1CSZTHNPV4XUclsdDCadxSENba8z/vywV69KJ+Vu4oLqsohg0rdJJ7QcBOQtpi7EXBUPHNU60Ta6NxpAZGdouK2eRuabxT0fm63M+zmQ0JYID4+10ceoqPwCHiPQy6zUm7+mqtnuVmYksjgVRY9Ek9FvjDXMbA6RF/Xiue/CfchwvKxsC+o/FqnrS7xA3u78vGyZ5zjpLo1VEYQ+X9jXuB0A8QhWnKbw+XHVimaboKxJhYHyzjJDRLU56S+87S0dGuq6WenOqdoJ8D5j9ELI4uYPdxyUjhp/KjMwJsEaX3MpIwN4XEcx36cx+VriJDkdh8NZF4C7UBtvnaL15gOfZbbv3PO+OpmdImUXuue7BcVKKZp6fpS69WCVt3eOtnNbM62tmc
 siiJ85WC
 1LABuiVeb2SYBq4NRaWFlwXOrifp12a1vNhtJwbk5Z0jEHChy34fv3aLarR8oCtuCo2y+mEWrw+qrkPgSQbd5767mOaXW9w+yP7rBjN52qLmzxNDEe5Bqcb7GO3kvJ+ehAimvP/xeEDNjfM+RfIFFH/d1PUW1esFepCbfo5awfvcMJu3aF4rBL06hNTRv5p3Z9GEpWjwzOah1lghsbjlxH7PsHGnhfwgkZJ5z6LlmcMoRbCMi8mzFCXGSFTbdB9IQQTCxOEDmRSlQa6kxtxj+qy96RYyGQBHKdtOTzPRZjY87+/DaL9ha9jkR3rASasf8k1ZWlUPB2TXZ1fH4ItuApUIM8oFyfLh2L465EbmkCZcgcwj7JeQ4TbA+X1SDzhm0f/0PwH4XCEb/EWINe8zEfhcIRZKONFvxTyVT9B9pz0uaeojxwsobzXSG5yp3VGrdbSx7Vj90rIgSTw1UVm63Bgi3kWaSoOp49W44dZTeBG3WQyKtv0h8DmppCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/29 17:07), kernel test robot wrote:
> Hi Sergey,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on akpm-mm/mm-everything]
> [also build test WARNING on next-20251128]
> [cannot apply to axboe/for-next linus/master v6.18-rc7]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Sergey-Senozhatsky/zram-introduce-compressed-data-writeback/20251129-010716
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20251128170442.2988502-2-senozhatsky%40chromium.org
> patch subject: [PATCH 1/2] zram: introduce compressed data writeback
> config: x86_64-randconfig-011-20251129 (https://download.01.org/0day-ci/archive/20251129/202511291628.NZif1jdx-lkp@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251129/202511291628.NZif1jdx-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511291628.NZif1jdx-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> drivers/block/zram/zram_drv.c:2099:12: warning: 'zram_read_from_zspool_raw' defined but not used [-Wunused-function]
>     2099 | static int zram_read_from_zspool_raw(struct zram *zram, struct page *page,
>          |            ^~~~~~~~~~~~~~~~~~~~~~~~~

Fixed in v2.  Thanks.

