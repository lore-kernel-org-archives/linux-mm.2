Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59885D1CDC6
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 17:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A38FF6B0005; Sun,  7 Dec 2025 12:11:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9E26B0007; Sun,  7 Dec 2025 12:11:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B2056B0008; Sun,  7 Dec 2025 12:11:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7654C6B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 12:11:23 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 11A11C08E0
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 17:11:23 +0000 (UTC)
X-FDA: 84193316046.24.E6F5F05
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id A54C3180012
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 17:11:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="itx/0zaY";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7HZyHac5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E0pJCmHA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=slgdNDHD;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765127481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RfRP9iNwSvZyohF288xP34cGD5la9DC4IMTY9uuQMkc=;
	b=fTHam5eZ4n1t7aK0MZR1HTejATrEObEy8xi3esZixMn1u/C0XFdslUlXe11vxbfi5MK33u
	OVjYJfajh/ggKk77kg4Uua9E6vya1irdnnFTQfzLDtrR2gUJuMtyL08g+aBwi7+c2+DPN9
	kPBdmsjwp/KQfQ+fdn+Wvu9iNftraLk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765127481; a=rsa-sha256;
	cv=none;
	b=hmSs+/26c5GbPZ8KM/4wgmmrPelRdO+FmrTtedAOq7B5/iZQAllUI4w96rAyUkORusAyKy
	n9QN9SrjIP5U75T7ivATUPXbm76toHRzReME78QmRxJqCgFcDOWB1kOqyap0Xru5yVXBad
	vlzFfZxRommKBNGqOb9ISvEFTr7lhDU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="itx/0zaY";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7HZyHac5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E0pJCmHA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=slgdNDHD;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B4CFE336D4;
	Sun,  7 Dec 2025 17:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765127478; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RfRP9iNwSvZyohF288xP34cGD5la9DC4IMTY9uuQMkc=;
	b=itx/0zaYztzrxEWPT1ddl8Dg1IulLDxkb6sG8la5hm4B/r8oO7oMweYh7E8zeHq2Wg05Nd
	1+Y46x/5/Y0BAew8gyNtK6UTUQzNnZzHQ6P9gQXlsLmn958ulYxf+84KstO58wcqYdXsFz
	ExnlaUmn+MH5p0LgUIBOs6RANEaDYoU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765127478;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RfRP9iNwSvZyohF288xP34cGD5la9DC4IMTY9uuQMkc=;
	b=7HZyHac5XkPiGJjDM3yiFqQTQZaqh98cuq0nIi2dAX8jkLam6QtxdjrRQo+7B4kjhAyWmW
	Y0pyMxqmlH8ZH5Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765127477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RfRP9iNwSvZyohF288xP34cGD5la9DC4IMTY9uuQMkc=;
	b=E0pJCmHAdo7CnPqqFghswWpEw1Mocl4vVGtSHYJ4o+YYPqe+IfK8uW231iN7UfaceRgSnh
	4HCDphkwuaD57wMDols1zzJWkkUmVTSx7K8KSZTsh+JL+hWqtxrQM9F60TAQHT9I2dg8Gb
	D8hhnZqAjg973HRAsW9niboaCR/6Czk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765127477;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RfRP9iNwSvZyohF288xP34cGD5la9DC4IMTY9uuQMkc=;
	b=slgdNDHDvQITr8FMzB3JUyy8Alf27C80plWcQBNDL63BtODzPjMdDlgY4iPGNL+1k1MOPB
	cyr3VqIeC65tdIDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8ADAC3EA63;
	Sun,  7 Dec 2025 17:11:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jnbjIDW1NWlSLAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Sun, 07 Dec 2025 17:11:17 +0000
Message-ID: <7ff8a5b4-1422-49fc-b35e-958f1ea561c5@suse.cz>
Date: Sun, 7 Dec 2025 18:11:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] mm/slab: introduce kvfree_rcu_barrier_on_cache() for
 cache destruction
To: Harry Yoo <harry.yoo@oracle.com>
Cc: surenb@google.com, Liam.Howlett@oracle.com, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, urezki@gmail.com,
 sidhartha.kumar@oracle.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org, linux-modules@vger.kernel.org,
 mcgrof@kernel.org, petr.pavlu@suse.com, samitolvanen@google.com,
 atomlin@atomlin.com, lucas.demarchi@intel.com, akpm@linux-foundation.org,
 jonathanh@nvidia.com, stable@vger.kernel.org,
 Daniel Gomez <da.gomez@samsung.com>
References: <20251207154148.117723-1-harry.yoo@oracle.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251207154148.117723-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A54C3180012
X-Stat-Signature: tkxxwh3ya1cx3hdzo8wfehenp1f554ik
X-Rspam-User: 
X-HE-Tag: 1765127480-732968
X-HE-Meta: U2FsdGVkX18RmKOHhx6McmmQVNcgiqOme5nL/d27a+m3JQ9NBo++GIHxcvK5x8encSVK9EifGZ83yKLlk1Jx7lx/wR4kZ5Zx8SzeRmLlD9px1DI+in5NgMZmlX0A3RJxuH9ZFG8WHtu4H3g93H6fWO+Y8tfHNlnYTqeU3O9Hd+n3pplHK0KVQUnT0yzWKiV+piuY4UFrMfLQgbP2npmZyi3FMgrI3weykNMjaVI5PllhLS1xucLzte1pFF+zVulwmvhxMyLpkVVj9/7zs5h/QCC6iyFaohRoDxuJqKL76jzsTtifaKA0jOhfK0UHstfOEV5eBA8r8zERsCNlQtHlqqs+NdtIqkRjOGAQaRLAbcWIMMgSs6TgwuqnV7ZzTW46IE/SG0n7ETmgfryANhSE/PhSSjvyaleZAQK9NdAynSylxXWHouOAKFCydfXky3r0QeWEhqAvrlVM/Fm2TQxx3cW6EUFE0anqR0Oi6j4jW+x5wLIc0kCm9jLO8PAb4SrNmJJHUwf+dIWyGdrrOD27s1nKk2Xkpyd6SiL2DsgCu3lT0XTIR4d6bBho9pUj1L/jik9Q6eruBJoXavMye81HL2d5Zk/mSvWFOJauO0SQvmxBGSqhmdhljBdpxtXsJeh2w5CQVunr53mPlq6KXDR2cltNKF/s9uDtSy3fSiN6Y89Jtf3PnNVgPdDMCicG3gK/dJbUiSrfXRV2IoaxAzy5Tuz3sByHAOjbPxo2ZXuhMaphzrXUGtkMGFEjJgGjOMVE4lGL5dxtHyks2qbuBec4tktzvz2J5pmoEtChWjKII4RCl6jS0YEG+pGYc6nSK5oJp8d/hVOdA0+lbQhso+kCQfcq/z2MRsOwX3p+6WN4mYFKSY5d3ZnzBkLOHjMtiUzJNlDP5wh+dUPsksYJ08UnIFSvXyWoGuhggtglo2FWxT173BwqiY0nq3rlpZx8ua2S+RtCCzgNI6FAYa6rMgN
 ePuSL7o/
 oKRmeee8P476XrTr4OBG9wr5Cww/Do/W3H9uJMT4s64cjbgNKdRI5nS3l2g7DDM491GC6p6zVP1VMlW0O2vUZKTFQL2tl3Z+WoUypJLbJxvQC9YB3Ag2hssxl5KTlTudM6B02rRTppwzidNh7D9NH51ZShv9YlyASJktHPvxHvuT1CEpmqp1OXeK2MLIAlYBudCb3VEA5ETiKlM6ShFvKrjj4ZCWp2LHq4KjEoPivRafqyVym1ynNykwB9B179DgMPrZoRFKApviWM0bFfpzNGOllHW2NGgkTiN7yeACEpXSjdwfFZuuqy1qmfUbnRfhbp31GlLnAYwi3tKAHicXpdHcaVuUd1NGJJieig66BEsc9yep8fyUQiB8nkiQZmrDMUnOL07TsyuS/UM4JNzTvdA7z59E8mA8EkVLs0n7JN3kHQ5c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/7/25 16:41, Harry Yoo wrote:
> Currently, kvfree_rcu_barrier() flushes RCU sheaves across all slab
> caches when a cache is destroyed. This is unnecessary; only the RCU
> sheaves belonging to the cache being destroyed need to be flushed.
> 
> As suggested by Vlastimil Babka, introduce a weaker form of
> kvfree_rcu_barrier() that operates on a specific slab cache.
> 
> Factor out flush_rcu_sheaves_on_cache() from flush_all_rcu_sheaves() and
> call it from flush_all_rcu_sheaves() and kvfree_rcu_barrier_on_cache().
> 
> Call kvfree_rcu_barrier_on_cache() instead of kvfree_rcu_barrier() on
> cache destruction.
> 
> The performance benefit is evaluated on a 12 core 24 threads AMD Ryzen
> 5900X machine (1 socket), by loading slub_kunit module.
> 
> Before:
>   Total calls: 19
>   Average latency (us): 18127
>   Total time (us): 344414
> 
> After:
>   Total calls: 19
>   Average latency (us): 10066
>   Total time (us): 191264
> 
> Two performance regression have been reported:
>   - stress module loader test's runtime increases by 50-60% (Daniel)
>   - internal graphics test's runtime on Tegra23 increases by 35% (Jon)
> 
> They are fixed by this change.
> 
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Fixes: ec66e0d59952 ("slab: add sheaf support for batching kfree_rcu() operations")
> Cc: <stable@vger.kernel.org>
> Link: https://lore.kernel.org/linux-mm/1bda09da-93be-4737-aef0-d47f8c5c9301@suse.cz
> Reported-and-tested-by: Daniel Gomez <da.gomez@samsung.com>
> Closes: https://lore.kernel.org/linux-mm/0406562e-2066-4cf8-9902-b2b0616dd742@kernel.org
> Reported-and-tested-by: Jon Hunter <jonathanh@nvidia.com>
> Closes: https://lore.kernel.org/linux-mm/e988eff6-1287-425e-a06c-805af5bbf262@nvidia.com
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
> 
> v2 -> v3:
> - Addressed Suren's comment [1], thanks!

Thanks, replaced.


