Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05EB5CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:37:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AF956B0005; Wed, 20 May 2026 02:37:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 360726B00B2; Wed, 20 May 2026 02:37:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2769D6B00B3; Wed, 20 May 2026 02:37:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 186C26B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:37:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B23DC160145
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:37:22 +0000 (UTC)
X-FDA: 84786841524.16.347197E
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf10.hostedemail.com (Postfix) with ESMTP id 537E6C0002
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:37:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf10.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779259040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2sGVb7k+av8wUSIY2afSPpJ2X09MYxxhiKZZuNRNz1E=;
	b=8aIdvk6Nq4bBTpsy4IemnUGNAh7geyauHLYV35kDDNMI9T5YdZIXBQC4OxJo9zJzr5mVl6
	xZJxOZM0LB9hbry2GV4XN8IrCr387rvSVfoV44uR8KdAdDywrXWASJNb2DE79LNO3rcjQs
	2aMOQUAs18W9gttSS4YDrcU7g3GA3hY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779259040; a=rsa-sha256;
	cv=none;
	b=BmC3noljyopVU2tWjGOcLdMVNxwMGSVyXVgtGrpgUrJ5zMJWf3D6Fq28mfkZXveFOmk/4E
	tvCTLfNuf6wVfqm+ym54xkLj9gFXcnLZIvQfIaspHYL9ZybSgiWU3vThwQ7JuxAeXJXYUr
	7xaoxulvZm406EPbVQwpQa5djZdn2C4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf10.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gL1zx5JVYz8XrrZ;
	Wed, 20 May 2026 14:37:17 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 64K6bDnD022319;
	Wed, 20 May 2026 14:37:13 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 20 May 2026 14:37:15 +0800 (CST)
X-Zmail-TransId: 2afa6a0d569b806-2195c
X-Mailer: Zmail v1.0
Message-ID: <202605201437150043iL_Mqfp22erG52LJkA9y@zte.com.cn>
In-Reply-To: <20260519100156.05043f9d043889a5f60e22d3@linux-foundation.org>
References: 20260519220536792dMIKRMurt3vZ5lXC5pwh8@zte.com.cn,20260519100156.05043f9d043889a5f60e22d3@linux-foundation.org
Date: Wed, 20 May 2026 14:37:15 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>
Cc: <david@kernel.org>, <ljs@kernel.org>, <hughd@google.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <michel@lespinasse.org>, <corbet@lwn.net>, <wang.yaxin@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2NSAwLzVdIEtTTTogcGVyZm9ybWFuY2Ugb3B0aW1pemF0aW9ucyBmb3Igcm1hcF93YWxrX2tzbQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 64K6bDnD022319
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Wed, 20 May 2026 14:37:17 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A0D569D.001/4gL1zx5JVYz8XrrZ
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 537E6C0002
X-Stat-Signature: xpto95i8dmaun4emn1ntzaa8fq65rpex
X-Rspam-User: 
X-HE-Tag: 1779259040-494041
X-HE-Meta: U2FsdGVkX1/sQ0yIB7Zya+Hm+WlnXk5Ndme+euy5g0ZK5uKQjU+ru8vp8yvE5AbtpN6/Fuy17jUdwvHJzfxQoVkbChsKSIK4TPMD4nXxtL4ySuqlqsxRbqhiYIkVNfCFeQWcPGbqave/8TScMu0g3ipCWpJvK+Ihjdjwnr2bswBISSa/sgRzXan83TpEg9jjusRnvGBj9B7rmM4g51NQEtrKBayHP6rwOrPdw5CA7nPhYNGwrC9hus5nO+SzljySLrpBHsdyRGyFj4KAA6By5499q4nKP9FMuqqLh3eNX2yEh+4OkoNGkU2nQiXepB5wgT1KAobyQk/EWBWDNEKKhwdWMgb2Iqml1HDyCDBLWRkb7Glqd4/ySFxTO8dzRVzgUGa3CZFBE/VI5JsQ1cUZkpZ3yUIhTxeam9fuWV6IoC/0CmKb9nAudYVKnfVxNDPV5Vn9fV8dz+ZmlLzB58hwEFKD5g1UhL50ZjQ3kdfS4apMkCCSRlNnCFV2hHySAXm5xIWBRu4H9SvJRgqllJDvpGc7bZbUvM6Mrbrc+rLYcnwf4DR5BOZ9foi3597kvN5MtxA7fmy620LbdDkP0QOBvynBIaLS6iczBrY83TRnpMOYzf+FQ2fot8+nlsstYhDBSzZRIQGhU5g3Vhgli9+wlYIImnLlQBogZH/h+DVAQzkHWge7INtIcx/m4VUiTDbxDDNL4JgTuXU307RpSRi5kF6kMIRDqsveNwcZWOKusGiG6KxMaGe1+D1sJpYEJySWhPzU2Z+3rdfh1JXyqCKKkjfiAsqdDbKUKrcBuca7mR0ATd+CkdI5WYz5Lz5J4jwlEcDmCX9v15wOqN3ZrSkwGILCZoxGOoM4TBd/1EtXptHvhCgDXF8CV1zODMF7/2k0xz40vj7rqQpEdvBrdHGKdCEUYSldjaii87saFkGgnilYh5aB0Bde7qi++TBFFRM0Z+sLqx24RqU2Tka5e21
 +5suHlqz
 +nPK0RORyAx1kMnXMglCtwr+0K0Br75YeseZFLA5CUIpuuY2GnoOEo7w1Iq/yA8ajXhSim7EV3YiBI5e0Qm79bRtFRNvvl4bd/uDgnBf9pmPRjYC+cHlZLAGUlW28iKB6KEsyTTI2EbbQ1PbtrVzTT9neUeDPZbMDYSceTNuHBXNlZXNczC5NSgJw0Q16fnFDwz2W6Qdv5Gde2XVRfq31uCjbSwLh01y7xy8K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Changes in v5:
> > - Patch 1: replaced local_clock() with tracepoints – no overhead
> >            when tracepoints are disabled.
> 
> Thanks for that change.
> 
> > - Patch 3: switched from vm_pgoff (unstable after VMA split) to a
> >            linear page offset.
> > - Patch 4: adapted to the linear page offset; added user-impact
> >            description (real workloads, lock contention examples,
> >            VMA splitting scenario).
> > - Patch 5: simplified to a single process with 32 pages (instead
> >            of multi-process), as suggested by David.
> > 
> >  MAINTAINERS                          |   3 +
> 
> I don't recall seeing any discussion about you becoming an rmap
> M:aintainer, perhaps I missed it.  Thanks for the interest, but it
> probably would be better to propose this as a standalone patch,
> separated from this series.
>

You are absolutely right – I did not discuss this change on the mailing
list beforehand and I agree that a MAINTAINERS update should be a
separate, standalone patch.

My intention was to help review future changes to the
rmap benchmark and tracepoints, but you are right that it needs its
own discussion. Thanks for the reminder.

My hope was that for future changes
touching these specific rmap test files or the rmap tracepoints,
maintainers or other developers could cc me so that I can help review
or test them. By the way , I was Adding myself as an R: (reviewer) rather
than M:

