Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 381F1C87FDA
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 07:00:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3BE36B0112; Mon, 11 Aug 2025 03:00:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B13616B0113; Mon, 11 Aug 2025 03:00:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A01F16B0114; Mon, 11 Aug 2025 03:00:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8F46C6B0112
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 03:00:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4B83911717B
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:00:58 +0000 (UTC)
X-FDA: 83763579396.13.00AC52D
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6283E40013
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:00:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b="DQ/BexqC";
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf04.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.44 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754895656; a=rsa-sha256;
	cv=none;
	b=Pn3zu8fZ7gMq4B9IR2nUzi19bgf28/BKR9kP4s8TTslHSB/1Mw+9JPTcW34meJX32VGse8
	p/pa0bM5kgNaDuNvzDl2X/MtAt5qzkR0juOiIywGWiePoXaVqiwWNNt7uBZCPEyGBz4+bR
	I7OBL+CDZiebd+3IWuXa4TUyLRSZR3k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b="DQ/BexqC";
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf04.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.44 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754895656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=/hwWzDFSbMSy9EZ6eh9Z+w3E0hJBaTZziN3cHZhQKeU=;
	b=oIVCspj3MTBQSM9/GEQkhmzEeKDxR8hJ7bpoh/QyXGjUES29kW+SUQAltIasv4qeccChKu
	w5PlkDQ7j072HSoNj0sCUNTBDhPxg5enk+5yM3QgM7nOxUL8m8p7L6SvXrav652yvnl6O2
	uSJHE+qJnZeEXrmu1FjNc3vCeTfVKT0=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-459e794b331so23793435e9.3
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 00:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754895655; x=1755500455; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/hwWzDFSbMSy9EZ6eh9Z+w3E0hJBaTZziN3cHZhQKeU=;
        b=DQ/BexqCJfPIrWWkEVUvttVgS+xyYV78gdG+Z/7B0yLIVzD+KT6H+XSYiM3YxcBAsi
         HtBgIcHRjkISRRVOrcfa3sl7laos9BgqfgNV49DLdE3grcxEzKfxVhCXtPiStQVQsoRn
         IFUMUV3nb1bJUPeh5VTIxpbo4mFIiw+4o4C+UY37uH3g3ejTTU8K5HtBODvbfEmmcsSg
         VYaMv2vPCZkdDFcfpriwZmwNDNvhqqTSdoZih/tXROTRc/3rZFVuL1AuKA01anVoeSkb
         7FLbrTALZfO2qEm4Z+C1+8kzCPTLcCCpqjyYoSKxLBc8Y87WHO2XvcxiHfhq45cH5mnM
         /S6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754895655; x=1755500455;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/hwWzDFSbMSy9EZ6eh9Z+w3E0hJBaTZziN3cHZhQKeU=;
        b=GGEKH0vOSR3e7a/g6HqvETjsE9IxNHKjkt5DV3tnQfK16x8uGYyN3mTvfLqvCl+QH5
         Liv0AIYBgxvE/QjTIV3qdS30EX93UW4Px+/MkNjIGmMAjQbGU47O04KssrrZzWozpirM
         ve6esRVzCHJ/tYBF1ocUw8+kSwIPoIhLsOekzIj5S4wnHFZaD9dX68bgwJTo1jECy1Gf
         NmS/t3VJoU9k0W+WQOaR56Q+fuYi9+Phu7xMfskIHcDfnQyDZ80uAhqRUBB5HzIvGHEo
         TQ1qgpgrbHcutkYrYO8j/TNoS4EuLOT9V3F+czJAZwAImC38Q6zNBa83t/H8UIXMm6GL
         998A==
X-Forwarded-Encrypted: i=1; AJvYcCVcRpnVGYUJ8TSnfQr2cA78iMLIS9kXe8AOeDKRqasazRSZ00JNczesShXcJUyZVAVMEs5xgTXTyg==@kvack.org
X-Gm-Message-State: AOJu0YxTZMxciYkUOXTGdW6r4cUQ+E4eZzKpxb8qnLSKe/tNNogowqm2
	F0rV2wHSCj4lbqYkFWvg+LVMan7cWjWa/lDiccQ/PwhYAjRUpsJf0tR67/quB2moBc8=
X-Gm-Gg: ASbGncv37x8fCed/vee1jD/ybNJ2KhvqBR2XCgPcV9ReBZqA55KBJDpyDtOSsSE6Ai/
	uyAcaOP0B/YpUfYmsvG04Vo5V8RKm6s3sjY0UEnXHPnQi3S18bf3jv9pG5w75qT/UqVXbuHJfge
	7yGXOeSu2ATkFMElGlA1ZPTYbwF5DI/kNdrl4H5jhcf+zY9x8Bx/XhRMM72Ts4nEO4OlsznQgZ0
	v8XJSnhr2UycPUZ2AJsQNfXXlQI6w95NCQY/THLL78fmrhJurPH98hr8r5TpxQovLzK9Es7wgj2
	/p/hYzfWmkuMl3bxm4LBwHdxaUsmF62GWQ1ZiU/QnEzy5ogOXwx1zjVw7/luoYUtRVzfnvCs/BH
	aGSO3JAhmP99GPNqyzm2zwxenhPciV0xKSbP0vw==
X-Google-Smtp-Source: AGHT+IHRURi+b8G7dagGCHr+89qFgRkhvYaQGSCmp70FV+PfG/xE/6yTSPpoTAWNO1orRt9InmbSaA==
X-Received: by 2002:a05:6000:40ce:b0:3b7:c703:ce4 with SMTP id ffacd0b85a97d-3b900b6aad8mr8041910f8f.59.1754895654564;
        Mon, 11 Aug 2025 00:00:54 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-459dc900606sm305322985e9.15.2025.08.11.00.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 00:00:53 -0700 (PDT)
Date: Mon, 11 Aug 2025 10:00:50 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Bijan Tabatabai <bijan311@gmail.com>,
	damon@lists.linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev, sj@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>, corbet@lwn.net,
	Bijan Tabatabai <bijantabatab@micron.com>
Subject: Re: [PATCH 2/5] mm/damon/sysfs: Implement a command to only commit
 scheme dests
Message-ID: <202508101330.XRQqvfiN-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250805162022.4920-3-bijan311@gmail.com>
X-Stat-Signature: zzwukukzmyxnhoci9kxafg1deyb86inr
X-Rspam-User: 
X-Rspamd-Queue-Id: 6283E40013
X-Rspamd-Server: rspam02
X-HE-Tag: 1754895656-29598
X-HE-Meta: U2FsdGVkX1/HSYNaSahZ5W6Xl4dTWJjSZAh8LxMrvRJfaj0brztA37aLIPiAvL/f8X4v++fF6ifYw3Vs5fDTdy2nQX8UJTQWfkw1qnEi5CG1aarUSwouGzRCKXK8ICK1mLfcCh8wD00jZz1Qq/60xIrggRpE8czwQuhB5oVsptimDuK62J2pu+sxUvWAxToZK+6WJIztUftecaXZ7QZP+OYsJsZEQkFxVhN4zHXuNp64xkESz0ZL7kPKUq7uz1YRoVANyTPUtFtjgRvcA9gaDUidjWG36GZfLS5JSSZcbSBudCD8eI7TOB4/BIh9UI3tKojpRATeyThUPCnpOP1DApBYgZkLasTTBNkTtuplPHw9aKZCfxySC32BwFN45FngP9YmnEWDf8NNpCHSN8EXnxMu+k6NxaAqQU9nhsmpP+ppXO5rJe/Gt3g33+4OuEnkyRFnF8oFls6q5rSyzgItH2RWLlVH9qx23i9bVaTIbU130vXPcpMrGXnHkwYC/J1BTaXslzPXVCjpD2xrMGGAVKxGyKzgCnLABQOy4Ew/+uemxLmy4jnRDxz+cWuVQmvb+xRNcmVQrX9v9hMuxkQF1pgvpZ4yXXm67KWjiw+tQ10DaRWPPFw5Z1F/EelAFDoGoACx/yxrlg1qCBb1qa/IpqPtjJjMcn7FINMbt1H6KrWRIaaObDT3jrZ5ioHRL+qG56su0NANRonGYDF8Jg+SL0CHSCkdVEVVKmbSR1k5HJirfsb54fK/l3d8wQOgQqeGMb82nWd/8Zt9bEAulwe1xyA3R485Kr8Ho7ef8rlepc0pxZiLuVHIhYKaAFkdYUxk69LdpvOloeOuFgFgWzfMxtOQBQyTnNNYt2WKh+9JOqBVr3vVnJpWAXoiuDzFDWNFwZ7h7pE+0mA05foKwPbwj8MIZs9mkKmmX09EwtwpeDYSR0HLaiuazX+PDHFPockzXB0Vu12xHBlWa9Drfy8
 Evn+sDF3
 q5axxijm4vEovzjO4kGDcWz+Y12DWRNaxjUWvWSfmje3ScLL5jUkidAtQLSS7tIrGluEsjwbOfZgx7ejkNdbVf2co6xaKLhE+9e5pcyF5Pc8+VXkNxiMb5iQ5QBPa9Sv7OVgOqcoKSuDbdKhB1e6E12L6789OvQlBpGXsY5wzsMdDGSStgQEgQimpA46k2SC+6m/THLgWFYOx8wPFsM/VTKe53QJ1VU+B3OLka64oyirF6PsMxplBUNhL5Ri5q6BBSe0akwq61LbkBO6VKYnHM1soStcH20qiU7g8GnbzVt1+EHr8mot7j3F8H/TcsSg5/tK7Wi2t/2gIg7Xc5cfhyME1kiLEW3Flxm17E7YCVC6XsD8U4u48rCCkNXTvLExiy6W9Vg5zvwewADvZl7D1fEtb9lUXZiNccoVSCNkGpvrDzY5bZB9xN4Nq7FKentRtqlAC+gr6mXwfieysbXNV1LzZpiFm9VxLIdMsTzZfPwqAGuM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Bijan,

kernel test robot noticed the following build warnings:

url:    https://github.com/intel-lab-lkp/linux/commits/Bijan-Tabatabai/mm-damon-core-Add-damos_destroy_dests/20250806-120845
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250805162022.4920-3-bijan311%40gmail.com
patch subject: [PATCH 2/5] mm/damon/sysfs: Implement a command to only commit scheme dests
config: microblaze-randconfig-r072-20250810 (https://download.01.org/0day-ci/archive/20250810/202508101330.XRQqvfiN-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 8.5.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202508101330.XRQqvfiN-lkp@intel.com/

smatch warnings:
mm/damon/sysfs-schemes.c:2605 damos_sysfs_set_schemes_dests() warn: iterator 'i' not incremented

vim +/i +2605 mm/damon/sysfs-schemes.c

8014d822c9939b Bijan Tabatabai 2025-08-05  2601  int damos_sysfs_set_schemes_dests(struct damon_sysfs_schemes *sysfs_schemes,
8014d822c9939b Bijan Tabatabai 2025-08-05  2602  		struct damon_ctx *ctx)
8014d822c9939b Bijan Tabatabai 2025-08-05  2603  {
8014d822c9939b Bijan Tabatabai 2025-08-05  2604  	struct damos *scheme;
8014d822c9939b Bijan Tabatabai 2025-08-05 @2605  	int i = 0;
8014d822c9939b Bijan Tabatabai 2025-08-05  2606  
8014d822c9939b Bijan Tabatabai 2025-08-05  2607  	damon_for_each_scheme(scheme, ctx) {
8014d822c9939b Bijan Tabatabai 2025-08-05  2608  		struct damos_sysfs_dests *sysfs_dests;
8014d822c9939b Bijan Tabatabai 2025-08-05  2609  		struct damos_migrate_dests dests = {};
8014d822c9939b Bijan Tabatabai 2025-08-05  2610  		int err;
8014d822c9939b Bijan Tabatabai 2025-08-05  2611  
8014d822c9939b Bijan Tabatabai 2025-08-05  2612  		/* user could have removed the scheme sysfs dir */
8014d822c9939b Bijan Tabatabai 2025-08-05  2613  		if (i >= sysfs_schemes->nr)

i is always zero.

8014d822c9939b Bijan Tabatabai 2025-08-05  2614  			break;
8014d822c9939b Bijan Tabatabai 2025-08-05  2615  
8014d822c9939b Bijan Tabatabai 2025-08-05  2616  		sysfs_dests = sysfs_schemes->schemes_arr[i]->dests;
8014d822c9939b Bijan Tabatabai 2025-08-05  2617  		err = damos_sysfs_add_migrate_dest(&dests, sysfs_dests);
8014d822c9939b Bijan Tabatabai 2025-08-05  2618  		if (err) {
8014d822c9939b Bijan Tabatabai 2025-08-05  2619  			damos_destroy_dests(&dests);
8014d822c9939b Bijan Tabatabai 2025-08-05  2620  			return err;
8014d822c9939b Bijan Tabatabai 2025-08-05  2621  		}
8014d822c9939b Bijan Tabatabai 2025-08-05  2622  
8014d822c9939b Bijan Tabatabai 2025-08-05  2623  		damos_destroy_dests(&scheme->migrate_dests);
8014d822c9939b Bijan Tabatabai 2025-08-05  2624  		scheme->migrate_dests = dests;
8014d822c9939b Bijan Tabatabai 2025-08-05  2625  	}
8014d822c9939b Bijan Tabatabai 2025-08-05  2626  
8014d822c9939b Bijan Tabatabai 2025-08-05  2627  	return 0;
8014d822c9939b Bijan Tabatabai 2025-08-05  2628  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


