Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 728BEC6369E
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 23:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CE6F6B0088; Sun, 22 Feb 2026 18:36:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 251916B0089; Sun, 22 Feb 2026 18:36:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15ED16B008A; Sun, 22 Feb 2026 18:36:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 000646B0088
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 18:36:58 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B49AC27D4
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:36:58 +0000 (UTC)
X-FDA: 84473705316.23.9D79BA9
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0D08D1A0006
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:36:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jmzNs2So;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771803416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ybdV4563dtS4ZOEJOasBlah8k8g9tI2C0k/Ph+ecmnQ=;
	b=ZG0hEz13iWSMQrfq4aN6SQ/pEk0gji5NU3tQ83XLfhlN2jp9HyyiKvLldWw9UHhYgrQJ9J
	YOhT/Z++WSFWADntjPe7ioUa+NOgxxJ/koHKUmhdsu+AnoqWrQTA5lkdN5ypoxbbKWp2zy
	0lDR8h47r/VSg33dGWAiBvbl9vsb/BE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jmzNs2So;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771803416; a=rsa-sha256;
	cv=none;
	b=adOoV6v+elKQ+wWtKHr8r2oFAFVjJ3x9XI0qmRpqlUirnYIKLvyo/JoK+i5omwE1MZnEGQ
	DmBKo9ARqKVBOl0gpNTF6QANJLifG04uCHYKBOuvbMA3/l/GmcGYtAiHoWEGb150d6xmnA
	9xcMSVZNA7P/QbK0p5MIymxjQxYmXb4=
Date: Sun, 22 Feb 2026 15:36:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771803412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ybdV4563dtS4ZOEJOasBlah8k8g9tI2C0k/Ph+ecmnQ=;
	b=jmzNs2SoD9+RFFddxf4oFJZOTAgJDRPiWKMADSlzPRz1xaIQL6NpjmJr516CT11xADF0Lk
	8AEwwQXmBGTiFzH4ztm4iliD7eR1HfJc1g2gRrN+/cHmTeEDQp28M0hMQcCtLw2vrNgx+D
	PwW6nbXK22WWy2SyFObMjPIkJAF6vIA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Carlos Maiolino <cem@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Ritesh Harjani <riteshh@linux.ibm.com>, ojaswin@linux.ibm.com, Muchun Song <muchun.song@linux.dev>, 
	Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	Hao Li <hao.li@linux.dev>
Subject: Re: [next-20260216]NULL pointer dereference in drain_obj_stock()
 (RCU free path)
Message-ID: <aZuR6_Mm9uqt_6Fp@linux.dev>
References: <ca241daa-e7e7-4604-a48d-de91ec9184a5@linux.ibm.com>
 <aZReMzl-S9KM_snh@nidhogg.toxiclabs.cc>
 <b4288fae-f805-42ff-a823-f6b66748ecfe@suse.cz>
 <ccdcd672-b5e1-45bc-86f3-791af553f0d8@linux.ibm.com>
 <aZrstwhqX6bSpjtz@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZrstwhqX6bSpjtz@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0D08D1A0006
X-Stat-Signature: mwgdtmecoj1pk4upfang66ua8dq9pwgd
X-HE-Tag: 1771803414-981646
X-HE-Meta: U2FsdGVkX1+I/KMDwQ6HXkWdbz42LO+XIATGVgkKE1i2M0J/Jh8XjCM/JS3Osmp4gOmrOM03VreKdb0xQnWmaDp7XZ2gOsV1Eex1ubGpt5+yRyXTVwLexNrvlgIIwZiFNw48diU8t0ugxYqt5VecyhFBgIrI2AD9Q3OSajoXqQ7yVIS0JwKZqkgTEurQCYI3oeOS/8QaAtRoV5Z4tJt7SJblgEOFEVV+I9ZRI62YhTFQQGmHOJ1w3NFTZVa1q/3W3jFQWOMgUJ5BXVcoJv42uqrCK+ZGwpi1c9OmfX7wG4UoBjSKCz+vm9khzmNn5hBPOOsTdaoc1GKU862nR/rT5a/C0BZf+7recVHfCMJSeK62HUzGJ5DxFpRSqHhG8W/sNCZz66WYjM4AO+MZeMwJU9yrD/bhjI+VA38LrXzMq6ydGKNKPo+Bi3lI1HJR/BeVVP2mYpdZzgSImddB8U4ESMpKhdGG9eJx2hsxlGVzA6+qfEq4PnEo8YHJLYXX8JnXoblwLRnZV3eNDIj0nMXviWYUbmPjRkXq/TuAxkPcY9jkebzThoxdPwSGAFZMOTd3YZJMJBo70hcJiIhbAeIW64/1Yp7csNyG4Hfqf07dG5YIN7TANBtxCAHK6LeuU96rmYKDZcTNvAoXTZSvvu63ZgThdx2699l12Wi1GAW/JTyKSuH6rlxu1SBILyxvDAap666KVDoaamS+VqgKfmMnGMI4IWe/c/+9n3vDUphjmig5J5MLqDklica4Wd+SuTmcmFS5np19Yc3xre+WaoGAbjcBMGpzN3jQ3wVVTLiqG2LBXCdpz2ZDacwNSGIcGSy/rPlXJtHRNcLIqZP3U/I7dO2ceybf9juGWbt+v0h4X8V38GKo7Ix9+rXz7njoexKmlH0B8mzM4t6eTaDmFHgPTYs7tW7h5+UNytFLr7GVPCYsAowacoYcCwV8fqHqaWiHTp5Wl1oAE0hJXx8P9BK
 MB6JBeIX
 voxES5Xo7XLGa6zrNU8CnT0aoXpBtlv5H61qUXK7iMvozpHoVJhm7g+OnkHOw5BtUBR0g2FeeE15Y/BPrED0Rf4xqZkhl0rdu/XhbXTe3Phqnweathhel5A3TItfYVBNv5KgxGgOnVDsrUI06HeGPEDLH90Vi6Jmwq5YAdCf1eE7dfdSl0EEhSgpLzl44jPYIypJlt7zceRSztyJJ46TJvHwfrWJWuKnus9sFjqTWS2let7WtZd0XYPDBP6m2TNjgfHXK6Ig+GEmbkdaYzIanRbgFnTSl79Qek45g5PrmK6im/Wk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 22, 2026 at 08:47:03PM +0900, Harry Yoo wrote:
[...]
> 
> It seems it crashed while dereferencing objcg->ref->data->count.
> I think that implies that obj_cgroup_release()->percpu_ref_exit()
> is already called due to the refcount reaching zero and set
> ref->data = NULL.
> 
> Wait, was the stock->objcg ever a valid objcg?
> I think it should be valid when refilling the obj stock, otherwise
> it should have crashed in refill_obj_stock() -> obj_cgroup_get() path
> in the first place, rather than crashing when draining.
> 
> And that sounds like we're somehow calling obj_cgroup_put() more times
> than obj_cgroup_get().
> 
> Anyway, this is my theory that it may be due to mis-refcounting of objcgs.
> 

I have not looked deeper into recent slub changes (sheafs or obj_exts savings)
but one thing looks weird to me:

allocate_slab() // for cache with SLAB_OBJ_EXT_IN_OBJ
	-> alloc_slab_obj_exts_early()
		-> slab_set_stride(slab, s->size)
	-> account_slab()
		-> alloc_slab_obj_exts()
			-> slab_set_stride(slab, sizeof(struct slabobj_ext));

Unconditional overwrite of stride. Not sure if it is issue or even related to
this crash but looks odd.

