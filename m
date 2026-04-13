Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B0A6F531CA
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:59:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A423D6B0099; Mon, 13 Apr 2026 15:59:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3106B009B; Mon, 13 Apr 2026 15:59:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90A786B009E; Mon, 13 Apr 2026 15:59:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8076B6B0099
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:59:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2CAA316031A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:59:20 +0000 (UTC)
X-FDA: 84654596880.12.589D894
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id 445901C000C
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:59:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NUxwjSVC;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776110358; a=rsa-sha256;
	cv=none;
	b=ggYLBogRRKoTqxK0PTv1qxPu8YKU5V+oJiNmUnbOAZ9J6k9E9LSk94gP8zVC9VTe0EiPd6
	KKBX7IIp9SWE+zlDgPcjzaddpuDbwnLaHqyh8VS6J8nipBgBD9lvEPod/LsQexM3anBIuT
	zlfUntZt9S9xn0/6yLmgLB1JakRcFrY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NUxwjSVC;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776110358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1azq21Esoe1p/aY/WIwRSLCrXwL5NJKdtQZKDmxglNA=;
	b=SaaPm0wsqirssq5wHnlm/7rs+DjsNBVKKBJy8K8Ls8f/FWxih4lM6oeSEayyk8aCmIad7Q
	1LSbxiTL+pKjgvg1M+rwxeGG1nEpwty7mPm8Rad+kjJwjH5aWRBlY4PT5fc8eYviar22Sf
	GR84K1hmK4eFM9QaqQoGC2mACyoF2oI=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8dbbc6c16b2so616709785a.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776110357; x=1776715157; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1azq21Esoe1p/aY/WIwRSLCrXwL5NJKdtQZKDmxglNA=;
        b=NUxwjSVCqQLqZZEArkvO2DMWCtr7nfs4iVdQ1Z/IkppwZN/MHk3f/AmE9Progscm7k
         lrU+mey+lhvK69gUWUPorFmpBoUMXgyu634HQ2sLCK9kfxFSaop9cREurgQuRSjp1Liz
         yjyYUfyesRZFDuMzfOA2wEzGAUXO12wniB6GDVeOd7J6XLQFybC6LVepZsMTa/y0t1AL
         lT+k+uwo29pijr387TfxTAiovyk4BO2aUAAnsD6DPfQUiyztyqQ+KAgAeUEmA9IlvlLd
         q2SNXW0TKZg9Td08yAh9sL5elCAyM0+Q+e+uHNg+DiwSbT6vLvdY772P9BM5p0/1Kmy/
         jURQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776110357; x=1776715157;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1azq21Esoe1p/aY/WIwRSLCrXwL5NJKdtQZKDmxglNA=;
        b=fhi10PCELmh8KYhjZo74tdgli4cXJT7QU8hEIhJT40/uQkJ9v8LSG1Qd5sYdS7GYBy
         K4ias+z57zwCLvsPPADS9QBi2yX1xDyU3PoOfc+ZFIJPfmOsWEcNMS0Vt83gJIgKOIkW
         YVtUtPtYCfi53/VSWcjsL88KL1HMIJaiKKXvdZ5YkGIuySccipEUlJAVE4fKyvNMXXHh
         BU3PBmP9r9G03nJUnUV5KiVuA25LmpxCmGpXuT7DpPIXGMPa1AnXLmpTzg7fwfi46Thr
         rtkPPkvWgb+xNwjaOWa0X96P57szsoJO9DBxEE6IH1t+PvTHt/itfrymGSTa2t/bVSmI
         Fg4Q==
X-Forwarded-Encrypted: i=1; AFNElJ8uAvxPOlfNhmvEH3QA5WArPGhzTFTYq7cBlr1GV0MkL19UsIc/OdltRHxb773LBsvKn1IyUAvKOg==@kvack.org
X-Gm-Message-State: AOJu0YwLapLaCoZnwJR6RQZjfuZ66LWrPqFyiO5vKF23N3sntqSud6bN
	jbQYt0Ha1ZIy1K1G8tzCzpHoTSiE/sO6Ty8acwCxjX31KkJRL6IyRRlQ4gJIVrBTfds=
X-Gm-Gg: AeBDies+PeDgPad8OCHCCa+39jjNaO3GVKQS3RWt0+cVHjhXM6bIwE6nPa0Hu2OUosi
	L8QBb/ZQccO0y8ePfADKXIN4b22Y+fPRPW6lfp11NltHqHecpb2E/4M+DWCR+wBo4qZLWI87hhA
	0AhEMChEcejkoteEXlehcO6KYxhxi+UV7QV+RxLcbpBE+/TNnLBclJ4Yk8Tf59iNy5nBeuRrJQM
	5EXDDDtW5aqRnKBNhV0QfSmBHPsxHTJPIg8kmuJhetA6pd5jgCY7S0Djdh7X38eVnOCNnWVz8O6
	jJxQQXDzDnENGsJ2tnObdsx9h9ltukeSGfY5wzs1ytnnoFZxqko+1ghHNc4GCQZ7skiQTZFbtEC
	X2eyC1es9DppHUBacPbsb/4hX/DpuZiBS3iX+pQ8pfTVoqGiW7abYI/H2MSbSBKNTMrXKrotpqM
	7TtRsKkskr2qTtrYDHtNmThFV+I2UVjrR69e6RjIDGB3P/zrsG3QLueXSlcPPsZjLF8qwoRypZE
	SH0xJ5fv6pPj0PUG+NE03Vzn015SwQvMw==
X-Received: by 2002:a05:620a:44ce:b0:8d8:9434:9379 with SMTP id af79cd13be357-8dc444ad8d1mr2489658185a.18.1776110357176;
        Mon, 13 Apr 2026 12:59:17 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-243-150.washdc.fios.verizon.net. [71.191.243.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8aca259724csm53270746d6.12.2026.04.13.12.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 12:59:16 -0700 (PDT)
Date: Mon, 13 Apr 2026 15:59:14 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com, osalvador@suse.de,
	dan.j.williams@intel.com, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 0/8] dax/kmem: atomic whole-device hotplug via sysfs
Message-ID: <ad1LEgvfwzgvvWPO@gourry-fedora-PF4VCD3F>
References: <20260321150404.3288786-1-gourry@gourry.net>
 <20260321104021.4a6074330131a2058e8706bd@linux-foundation.org>
 <ab7_AVLgzLaDRcv5@gourry-fedora-PF4VCD3F>
 <a4be48f2-ab0a-4808-a7db-2532ec65ad0b@kernel.org>
 <ad1GJRyAfIAhj1iz@gourry-fedora-PF4VCD3F>
 <478c5700-8bf5-42b9-ad71-bbc618b36c9c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <478c5700-8bf5-42b9-ad71-bbc618b36c9c@kernel.org>
X-Rspamd-Queue-Id: 445901C000C
X-Stat-Signature: kgfcr3duarszqujcmqxip6y4zjbeb6e1
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776110358-326301
X-HE-Meta: U2FsdGVkX1+YHuuqZemWhDHeQQG3c+EEFTjpyWxEiI80+6X8pUowEb4oSS/NOP/6H8hHaPQsQEy48L9rGt5klYIkyzTuRWxm/xdNENnmySUUG3riXAIHcA8o800Uu+vZAb1OX4KGZnda2Il83tldUswUanyDzt0Wb/X7aANHzj6eYbaLRKyaTRvpSD+GqyvVbm9+cjndgP2rdZJQHlbumRlQUUyruaefCEB61duek4fh8MxR1u5CxVMKDG02Uqq06jPDrSRQJ3TVCx5TXK+G7YBEVH4dMXGV6N/U943WL5zRFTMdjZNvMA72nEmy+EBDEpLi5adG44cQxyUnCYo9U54V8DIPQ16VOx/ZIoFLl/QRCk3yP7/YeDWlZ+TW7HH9CgjR8Pv6AXEHdHDZGRcRsatjwozk1LH5A5UDiuB18xgM0oYExI/NdsekhPQCtHZBJtZ3rx2kNhd/IppVL0F+xfEGRcc6YkoFJ7s15Dus+JNE+IH8jWdbzoTpPbbHayvpcAc7DrycYAqqwgws3KuPNiLWPYLb8x9yo3oH2U70nqefq0wYPYEh0VQd/VbhNfVxSGRFqVd2aD8nyqK97ZPvtsbmrkM8dP0X0XKcypTOOh8fI1ZnaamaybGCJoKelH/uQi2yyTUDd3glld4naXeLfdbjfms8wTkXAgTXmNDkK01n44DI9lE1z+aYxZEp5kvtqavp0jFV9TueoNEUMAwzKgSHAyVTPftD+OKVTNKmAFxZL0w7l5BjDuXREsxXfMGBkIiM2/SKMgngzrqyoEhVBa+6JsLjNczAlbBO2a61+uK7HfaXjPIdQg2qtECPlCgWKAHz5ss+KbYOWa879w5qS38dz9mpx2SJT9UWIA7MQi2BX3GzLLNpIa6iVcVeWFEiNR3A1Ocs15GUcNON3XfCDjQIupZpaNwE4OTu1OTMlRxNf/3xvYFOiHeO2BgyNLZHNsJswEl0YboFkcYiH2E
 6S1krXGl
 h+j1YnzaFBm0BGB9hhSeX9YQ5dSK0XeaOh0n/Dr2qpzwsovEnknvoR+ciEnE9K9cBFs4KxRuN35prn9SBfwAHwqaqfuJV9qio9OF9ZMSYkRy6FWj1kUAp3mqiepY4h6fHnzzflif3gNQVEacJlN44kzRfxSs757q1fFWxX4A0B8YYFxQ/I7FN3qSOq437/MNfcyh0dJwhoGecGtbGv81a+NqzQPGNjXUjIcIXswhPFhzY3pT+NzqqUXCRIsmI0z5i5LOcNlzBEdkfDTfnFn1i2xmf4M7NRfu01h3QiRNV1kKjm1We7gVR9zTYUoKUM7lWueiyfPR1fTD63bKtsNEO3N2LoOE+MeiwBShO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 09:40:49PM +0200, David Hildenbrand (Arm) wrote:
> > 
> > I don't think this is a very large lift, just a slightly larger hotplug
> > locking scope.  But then - the per-range thing in this set should just
> > work, so let me know if it's worth the extra churn.
> 
> Well, you can rather cleanly undo the operation if any offlining fails.
> If that's not a requirement, then no need to change it!
> 

It's not a requirement for me, but maybe it makes sense that

   echo unplug > dax0.0/hotplug

Either fully succeeds or fully rolls back.  Otherwise `cat hotplug`
would have to report "¯\_(ツ)_/¯".

So makes sense, i'll come back around on this.

~Gregory

