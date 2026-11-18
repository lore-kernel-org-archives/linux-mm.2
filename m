Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2554C60A2600
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=vCfGMEls
Received: by kanga.kvack.org (Postfix)
	id 3DF316B05BD; Wed, 18 Nov 2026 10:21:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B6AF6B05BE; Wed, 18 Nov 2026 10:21:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A6816B05BF; Wed, 18 Nov 2026 10:21:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 086C36B05BD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:21:01 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B6F3140222
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:21:01 +0000 (UTC)
X-FDA: 85448602722.05.7AB6BC7
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id A3528C000F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:20:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=vCfGMEls;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795015259;
	b=UHdsNUubJEuWwYCDFQxQ8X+9AL3KvePCRghnI9smeukhZM+IlB12QZR+gzbDVBG/Li8Xle
	abExiR/DP/JkBFdStgS/nA+5U3ESfBcxThvN2csAMgames2d2hDhQsT/lubgyH/EKxWpVB
	Zqo1qsFKkAUiKuEZKkRv6frqNObG1K4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795015259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2f1/3qPELFtVfaXBFluo86ffYBKVD1HppO+tx/i4yJA=;
	b=krTiTHrT+z4wYzXVXvypvnkrN2vOgO6FzjRsPbXgXrIpXLG5fyZoyTTmbR71oGw+uLL4dL
	//1j7h/vt6CigXdnzoeWgN0i+aSiz2fB/XpzNzsKVGDdkkteRC2rP+BEOSI/GZV5EnQyDH
	SZdW/QD5xml1YhtM0joBjgrCn9zMD9s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=vCfGMEls;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-55d30c054dfso11803941cf.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795015259; x=1795620059; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=2f1/3qPELFtVfaXBFluo86ffYBKVD1HppO+tx/i4yJA=;
        b=vCfGMElstmrSV9iaumbmHWicGoJ6QQofGS9Zi/7N4Q7bOkvOESoGKNUXljH4hVhpFw
         q71C6204YQafi2VHcWnpxwvVTZ37KBZNK8VR83QfuNHcnSgM81sEY5mQYlVaTCVpkW0i
         wtVgzxF+Z0oZlsJXyUsjD3Xkk8ygXyMMF1IDW7Q+TnzSddwuaxWK8ZZCKj2ar6j3yUa8
         Rfb3LqsBUx9k2VOLmFEqUH66gOBfxUtg93ifzFkq9KQ8aMOe7ZjXphF7yjVUZEm60zwG
         f7OYBo/vKTl2XBWzAu8LAm8sc0rqOTb3332zcNdxYsVlI4WOWfz4LQSKw65IB3SxoBb3
         4pHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795015259; x=1795620059;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2f1/3qPELFtVfaXBFluo86ffYBKVD1HppO+tx/i4yJA=;
        b=zgzyHJI4RooXu48WYWhF2AE3AK1iSVKj4xcPp6vXAG9o9nZGyRr9F9pMHljMBOmYc3
         SzH3HH8XRkLdvDw0Xm06x7pMmgRKljAeLnFD9ofOjg7BNYPnf03jGWMjiFpDy+NY/I/5
         KbIj4qhp9iJK8OXKncn28RRdl/PeAsnfbF2QsFpi0qsSeOfOhqFS7YB4KiXCpggVX1EE
         YdN/zDMRwnK1pRq5wvc8Cyl6EmXkR/tKtERyTWNrNQkT9WvbXlu50i2eVY89SPBHJXBq
         1ImwG8Ck0i9xofd/5ln4m/AWECWccrElQj5Ut5kTxvEAcfWiog68vzxWFuqIcsYbhcAy
         eQqA==
X-Forwarded-Encrypted: i=1; AL+hErFuDfEQ1ZIkWCTEP21YXa2yEeI2Emcb4PGk3H/5/6a+yKCL0U32vU5gTxYp/Rx9iDYxBtnklchiDQ==@kvack.org
X-Gm-Message-State: APuU4Z+CaHUWnPY/g1WDx1y2EHzv4ESjN/ikVyD7fD8A/OpttQHoC0LG
	36LCaRlNnW0DPo5p8GcYfJUqPWS06BSViGxBB7TN3H6JOumAreN81Xw9VIW3sSjoHOo=
X-Gm-Gg: AYBFou0XYK9fKc4RFCP4pWBJ/IEa4sUgg5u8ymbkOjGNe5r+uUfCGPSrJ4d+UNWACmH
	ydjTBFJ4l81OlPcFhxd6MZPy7uhLOJ9Qz2yK0WwjaAvVpZ9jaAc2Vod6ldGkPLnsxtopRd1HWq4
	fRc71hgn5uC5GkTd7yp855vLcvRMtkhfNZBUrkU8sEkLnOUP2i2ELxT8r+W6S7GbhApIUb0o2iE
	w1OV6qZChmb1GBnlsjpGdM7El45elaPgGpnl2xoavgxoFm6dUKI3moA09HD9VeGLUPeRdG2LjiE
	2SLeSDBeYstrvMotWdgfP1Q/aisIajeqc+b81Z2578afasw6BJKqyIvPN8s24cXUeLQvQbzSJGL
	ahtaYGmndZFIogq0fthThJWfc6B3ia5lSwvjeIX0q5LfLX/gj8QCXffFN8xOfbRbqOyVrodhODC
	oV8ncKM41FWwBUQ9T3Pibrlcac/oUyLGi54b1D71zAznrC4vRjkiOp4ufoSjjO9lJB7wnRUq2UC
	WI0EnESvkBiqNdu1v8YaflWN+DXGzabaqehMO7nxfKSfMiRS+WaAdbUHRkJbZSF9C5zUQpveav7
	9X0pYZhA/+6wZRTwzSiSbqNe65unRkbZFSOiqeYWlPmDShECKUu0kA+xGSchMouBqwot1PyLqER
	bB5a6ln0=
X-Received: by 2002:a05:622a:a0a:b0:55c:66f0:5bf0 with SMTP id d75a77b69052e-55d5a656766mr42047121cf.39.1795015258621;
        Wed, 18 Nov 2026 07:20:58 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921167f4725sm19632976d6.44.2026.11.18.07.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 07:20:58 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 02/22] mm: publish and clear node memory states via
 helpers
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Richard Cheng <icheng@nvidia.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 linux-doc@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-serial@vger.kernel.org, linux-pm@vger.kernel.org, 
 damon@lists.linux.dev, linux-cxl@vger.kernel.org, akpm@linux-foundation.org, 
 david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
 surenb@google.com, mhocko@suse.com, corbet@lwn.net, 
 skhan@linuxfoundation.org, rdunlap@infradead.org, 
 gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, 
 johan@kernel.org, jirislaby@kernel.org, kasong@tencent.com, 
 qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
 baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, yury.norov@gmail.com, 
 linux@rasmusvillemoes.dk, pavel@kernel.org, lenb@kernel.org, 
 hannes@cmpxchg.org, brendan.jackman@linux.dev, ziy@nvidia.com, 
 sj@kernel.org, muchun.song@linux.dev, osalvador@suse.de, 
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
 lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, 
 xu.xin@linux.dev, chengming.zhou@linux.dev, joshua.hahnjy@gmail.com, 
 rakie.kim@sk.com, ying.huang@linux.alibaba.com, matthew.brost@intel.com, 
 byungchul@sk.com, apopple@nvidia.com, rientjes@google.com
In-Reply-To: <av1ZBTpLpJC6DJqA@MWDK4CY14F>
References: <20261114070959.3490008-1-gourry@gourry.net>
 <20261114070959.3490008-3-gourry@gourry.net> <av1ZBTpLpJC6DJqA@MWDK4CY14F>
Date: Wed, 18 Nov 2026 10:20:56 -0500
Message-Id: <179501525661.1206716.17622543796948053737.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: A3528C000F
X-Rspam-User:
X-Stat-Signature: sdfzm8d6onc4feyiobkmoi7ai8tsdu4o
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1795015259-816992
X-HE-Meta: U2FsdGVkX19+nIoNMFDxjFq3TZ/OQf+yRDof2dJtngcW4kDIb91ob9NMETd/DZQXPufsEiq0jPfOWDl71S/C/WcU6NQWv5PqyGzOHJX2Vaw6nOWNxl3Essqqd1xzSv6roepiz6z3WbW0QAqD8RQ+uMkh3jGf7tiMroXoSYYdZb2Bhb7qx7psRf88AU4g4a9Y4SemunMgvcSIwjJ1Mz01szdgvc7xajov4HWfO+fz8htUemTbXb+PrrVJ7SSnwpd8z+bvn/C9D8g6RSzvyvufwRTRyEJRKqBdg8GFUvy52RJMQg0s5tYWfaTChJ4zfQfDVSG37Rat1wohURLL8UqTuo2CJ9fh4plYFFfYwTTmNDlpIKJ2IHZq++O2pG9pS85clR6BtOWL2XjgagIIMjY3tB5871MqWEPVoHZlzBVKKxV2DLWF/B5SrE8NioXrc0ByfW/+ahcJf7rRXuAT6WqWXnyzfj/EijQlRNOxeXQDZOyai2KDzCsrkkHhS6cmT/coTUsXI9X6pJTXhgJ2E/jZyHmLU6LJPmaiC/1fnc0G/LfeRHaaV6p7itQD03DhBra/mZPm5owvRrii+Gl5aNVSRqR3JkqQsAb9WQwl7M8d+B4/SjHpS+h1wsw2Fe1x+eLc7sKWnnOdSMIwjcrOaRPxeETsLEkJOX3SILvrBohsU89ouR9oZk1o8mjzE7bTUw02WvixT74MEfLNVV0f+lz0WCU/SkYNymDBA+FDYxDWpDrCCwBfvH3Ah+R/8M6Ot2g/+27PQLqcuXTDKnoQzCjZ7heRjRz9oxytsbJGlpNplzAeQa4cuXhTPuhowFWUVFRZUOco6ZgBraINR55/Iyhgzv1T8/DAjiYlJsTeIuCc+H2cWAUyyE3PNUJQv0sK/hvwhg/MjI1KvbweTeZVqMGHBaRaDdUf4TxwTT46XFIJIkEEaxzVBKdAnV6gdbIg97SYFMX5WfdXWx5ugvHY3Og
 YJyfhLDM
 eRKf7yfN/prsxdQzvZDbH3tV9bE5dy4/WqKJkykA5RMCXMritdiWU7i0XfECGjBYO4hoX/s3sMA++/OeWbvQgrYygEHDOBuxj/A1xq+csn4OA9QtYKv3RtBnJ5dLBvQ3xaR5QbWCOr2TNC3emN0Xc4WW+r+p2HOG+bBfdVTVREa2uqOlpbfGG4Sh162Z4sMOchw0x2bFPUQv8Ui3a0D7/X4qkWes4coZ5Bl0PrWlJxdT89veKg6agwi8KXtbsQBJ+vxCKhnHsmrnLxKbQmDvlBba2w7xGyPaF3ln4ZOiMtNE/WVHnb4lq3oW5zPCQE+lqECAnYRVgs+iqMaeDtuO8GOEGZ4CreIMZR80enN4kfvZeNFwFJsNyh24aemyug2vdifZn2KwSzTK7Sbyua45UkxApmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-18 15:53 +0800, Richard Cheng wrote:
> >  	/*
> > -	 * Check whether we are adding normal memory to the node for the first
> > -	 * time.
> > +	 * Publish this node's memory states, including any newly-normal zone.
> > +	 * Hotplug never adds highmem.
> >  	 */
> > -	if (!node_state(nid, N_NORMAL_MEMORY) && zone_idx(zone) <= ZONE_NORMAL)
> > -		node_set_state(nid, N_NORMAL_MEMORY);
> > +	node_set_memory_state(nid, false, zone_idx(zone) <= ZONE_NORMAL);
> > 
> 
> Um, so I am not sure how much cache pressure this will add, I assume it's small ?
> 
> Just want to point out that the old code only wrote these bits for a node's first
> memory. THis now does up to 3 set_bit() calls on node_states[] for every onlined block.
> The result is the same, but node_states[] is __read_mostly. A test-before-set in the helper
> would keep the old behavior, or if you would like to keep it, please address in commit message.
>

Hotplug isn't on a particular hot path, but I can test N_MEMORY before
setting any new state and just early-out.  That would keep the behavior.

-- 
~Gregory


