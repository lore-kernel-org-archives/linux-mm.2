Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A5AED1CDA0
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 21:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 175BD6B0028; Wed,  3 Dec 2025 16:50:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127D96B0029; Wed,  3 Dec 2025 16:50:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 016806B002A; Wed,  3 Dec 2025 16:50:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E0CA86B0028
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 16:50:58 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7621C13B7B5
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 21:50:58 +0000 (UTC)
X-FDA: 84179505396.15.3EF0825
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9D60718000B
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 21:50:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WGcjvpUh;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764798656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u1L7bCsctlFH/rlCsw/yhcu41+Ux43nXuWYzbJSS1oM=;
	b=TOWQdYbS+MKXPrwrA6ljWQZvZFRYmYxaqCv4FV2gtrCeo+JqV443hg5OxEbIeBD3cc6Cab
	q6hzolRUFljFDbR2PXXJ1PqPgcM+I7ksewwvhZoa51VoG6azeN522UxT6MccR8DuMngUb5
	D1ySCUBp7O2GXF/TAJHG+yfMJnr75m8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WGcjvpUh;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764798656; a=rsa-sha256;
	cv=none;
	b=XFvRMysldh1TJTHafu8f9JbSKBBX3+Do7kNEQV9mV7y1PO1/l9DgFNO8yAAcureQduekuE
	Tv3kbX/Gs+v5So8kpKsDlcu+lYKmiIpBcIsCUL5OkZTX0bmWhBBSwjBGfUafShM9nQhdye
	sr+n/B6Nhh4wjDRtNkE4OMOeH3L6nNw=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-88246676008so1868256d6.3
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 13:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764798656; x=1765403456; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u1L7bCsctlFH/rlCsw/yhcu41+Ux43nXuWYzbJSS1oM=;
        b=WGcjvpUhOjGxQKLy0uHcSR9Un4Ky1t5lJN8+YHzdgOppzVr4Y62Eiq9R20JOYvHgxB
         yrhgLw7BLiiVxxhJebtUgwum+eh085bit2GkQ8dhZy8ooxfDgXRzymk5XJgi0P2i/its
         619FYOgz/OiUZa+sto+lbbRdVLVvpZZKiXDRoJ7R4ljcpm35F76mQOUMs2YX/4cmr7Ns
         EA5a1V189Z3NFbBy+KLzpVIZdTZUm5xPwlrKCnZIG2ry2AknvvWgmSLChp0Ot0Xsy9Ud
         oXUiJKvGc9uYvQGNwUjv4Zb4xVFWwVtTB2yS0SzlEO69zOxnedSuc40Z/oSzR/rANciF
         gfxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764798656; x=1765403456;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u1L7bCsctlFH/rlCsw/yhcu41+Ux43nXuWYzbJSS1oM=;
        b=EkGPyfncfjeCCWdZzaL0SHj7jsF2zsx1WwQ3ID2UXzDCiiyp0nEqNF2TJ5mGqRUotp
         ONKBRCRGUbfoZ//QM+rpzhknRcFqQSriDaQUV9/IUF3vXSAlaGme7Nvni/FWm3MskWSD
         jULCP+kW614Fyi9ixGuqryU79E/iAhxFUq14yc9remOPxFJVWTlzfmhgkqu2NGUXm6Ip
         6hmNIkCKTWwaNnAfhMzmhu52obHgGoyRpFWQK+DfskEC1v2XSdkMdNgPUdbnGBZOXIvp
         sTGRpD7I67WbZwqSZVRKQjX0mYp3cfO4ZfLDf7dIST/KmJiGQxj9SQ0r24fjMm+aCZTb
         jFAA==
X-Forwarded-Encrypted: i=1; AJvYcCWUPw0pXIK52WFyFZyyCBhnA2qSK9MDvOY3tJMig80Xd0XwP6yLdqpVZt+bc4x65cRjfICIrSQ9oQ==@kvack.org
X-Gm-Message-State: AOJu0YyrTjUdvcy7mMsVGicdVT4RDJndKYG+TEBMZl0bRhzIc+aoLOIC
	cvBX5z5L5uqw4edHnEcyBCjmq8ZwtvKS/7n4fG3Eakbwvre8+b8lAPVxB/9XxkcAQO0=
X-Gm-Gg: ASbGncu9TNkJHfvos+09J5fxZTpYBBPaFPnjMs+l6u2OD4hNjpLYRPhPZTio7mw80bU
	UxT6wP0rpk3yhMfMueOFGahsVNFLld7FMh8MVc+Xk6liqkUkU5d2oxRFbj8RuEWSWUV2lYGf27H
	yzZLT4jlxtzFtKMVq65/uFXvtrR9SauquopvsCkMJi72RvA1shdYGQU034PKZIOmBZlvq3Be93a
	RBPV3iHusxkRWqQANFGAjpc0eglIJllY/9j/iQ1+rHurl581to+rkV+L8XSaj1wH967aGgGLzzm
	XYLjlqd4gir63aoycTh423huWEWap08ghzDwZZULQbUgdzL/aWU9qXd4fXBXRLZ9czp6AMGo4Hn
	xqsVweH2cXAz9jXeI7FoS1UDqwulIFFY0P8NTCoLlyKsB1VlmRntf06MHT2FKpe2+Ci6tYkQNM+
	AdzuT5vLs+WkdDggPaAav4Vn6tNAg=
X-Google-Smtp-Source: AGHT+IEwceVsLeU5TI95jujZXB37aK5lP0n1gzmGLbDcAQSJh4iH2YFhpUVYfybMssUZm1JTFXzafQ==
X-Received: by 2002:a05:6214:500d:b0:880:5389:a77a with SMTP id 6a1803df08f44-888195726c6mr64755976d6.63.1764798655692;
        Wed, 03 Dec 2025 13:50:55 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-886524fd33fsm134692766d6.24.2025.12.03.13.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 13:50:53 -0800 (PST)
Date: Wed, 3 Dec 2025 16:50:52 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
	kernel-team@meta.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	kas@kernel.org, dave.hansen@linux.intel.com,
	rick.p.edgecombe@intel.com, muchun.song@linux.dev,
	osalvador@suse.de, x86@kernel.org, linux-coco@lists.linux.dev,
	kvm@vger.kernel.org, Wei Yang <richard.weiyang@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH v4] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <aTCwvKRoVGs89BVX@gourry-fedora-PF4VCD3F>
References: <20251203063004.185182-1-gourry@gourry.net>
 <20251203173209.GA478168@cmpxchg.org>
 <aTB5CJ0oFfPjavGx@gourry-fedora-PF4VCD3F>
 <CAPTztWar1KqLyUOknkf0XVnO9JOBbMxov6pHZjEm4Ou0wtSJTA@mail.gmail.com>
 <b5a925c5-523e-41e1-a3ce-0bb51ce0e995@kernel.org>
 <aTCZEcJqcgGv8Zir@gourry-fedora-PF4VCD3F>
 <f6b159c1-e07c-489e-ab9b-4d77551877f0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6b159c1-e07c-489e-ab9b-4d77551877f0@kernel.org>
X-Rspamd-Queue-Id: 9D60718000B
X-Rspamd-Server: rspam02
X-Stat-Signature: xaocf46whti3npoogwshzix54brop5p7
X-Rspam-User: 
X-HE-Tag: 1764798656-197508
X-HE-Meta: U2FsdGVkX19w/ttYCOhT6SsRvwi5w8voTJaxQ3tE0GlAyS2bsSctO0QNl9VHvN+03kWQq+q6I2iKVTllS/+NpUt7fEF/t7JJkkaybP4EbiShsvhEYszoS6bFeJiSfEzLU7a9knJMvQLqvmrCUPfT4+6s593wUJdUXhoZTySUJSxJOwhzC7D54+LHcmc/KQ1GgzAB3tFwFB4jATu2OoHFveYaDKMO16ett4rHVWLYZ9qXDkcemgLq56WUgmyZzXbR2N6ssLvfva2CWkPaKIG4qEGe/B3Q+UadGCTcMNCgYOJlgo2iUrlU3TzvlyJjfK3BIp/iqqhE44g1ORZ3NdGJS7cq2A+Mz2CTojb49iEHCUwE/DEc3PURmIpHg7XQhKo7YX5x9GRP5n9gGR7ewMpoDnmPyz1gHjodss/xQ2Qh18ER4DZwzKUhJeBOAdfj/oIPDR7VHbtGONRW/DlNEsd0sCer82WxMeKuwzuo0y68znwhc3X5sRB2DmJujQPcZ/oBXAEsjALhBza0fQXzg1zqY/hV+/oGKvKejJj5yU2z065yzvThzy5kuVYz+dB7tuIL+lLA9eDeZdam5gjiptGavuhmKS1i3M15QTG9/x8yD4Lq8jOlNbWw8SUgSw6LD0g2nRvpuBD6JOJ9Mdu2e6BPJpFuFa0xeirF7/CXS3ZIssAqcd8khNvi48ii2P7l81JzRoz7zNhp9JO2E+xy2lEzJF0PJPchxvRYfzWQ4FHXgyjP1HM013CmD67FBYkfHNpuZXqpn/BSTFQhoQdfLQrVzdFhX0gkQU1PDf1cs8GZWaJNe6C3EhRMaZGbhA5htj8XdGZCN66EBgpKK7jyiNjJfcF6Sl788Ep+smCHJWR3DsuiG95ZKtEr+5SyqDuzUOSIPOuVh6wAWMGIYpfJBKeUxnMZ2Hv0wq4I+uiVtcoxMhCmVEdRHQjl7oquSyB+dVrAJJ7+0B0y29C1Y/vjob8
 QEfjr6x6
 bckRp2aFHMF45qxn3DLK/Kzjv1FK/xBcmhTXIdW5esCS2rXL+JAtMFNiYPggkiI2N0mI/xqwWiNdgB7dGD0t+dZa2q1s/rXI/lXhapF2DGY2OUQx74Ks4jcaBS3enqAxOsgf9SPINc02q0gXiiJC+MuSUcDxWy52DQngDt/JysbyG1hsZYVfuuL/jrWWMgqiDgsv/+egV2LfZTmV5YCq5fl3Oq93PN5OCGWMfWdJHQeyaU+YHaOOx3cZAbHZQtHUmt60s9O2tNfzStb73k+kKED2gVd4OK+WGBbWWgK7xPqOnkjo/+o5HXQQ7Pribqcn4vlQIh8KxFoEm2SmYDe1V8zUn9Pd67rxgq8fA9w+vp7pK4+jtpjPoGMqbttEgLtRfbvXcyVidD/tT0edIC4rfgIEgNYVPcKXHfInDUJMVGg1AL7GII/1/mXHMd07oVQBR77nV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 09:14:44PM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/3/25 21:09, Gregory Price wrote:
> > On Wed, Dec 03, 2025 at 08:43:29PM +0100, David Hildenbrand (Red Hat) wrote:
> > > On 12/3/25 19:01, Frank van der Linden wrote:
> > 
> > Worth noting that because this check really only applies to gigantic
> > page *reservation* (not faulting), this isn't necessarily incurred in a
> > time critical path.  So, maybe i'm biased here, the reliability increase
> > feels like a win even if the operation can take a very long time under
> > memory pressure scenarios (which seems like an outliar anyway).
> 
> Not sure I understand correctly. I think the fix from Mel was the right
> thing to do.
> 
> It does not make sense to try migrating a 1GB page when allocating a 1GB
> page. Ever.
> 

Oh yeah I agree, this patch doesn't allow that either.

I was just saying his patch's restriction of omitting all HugeTLB
(including 2MB) was more aggressive than needed.

I.e. allowing movement of 2MB pages to increase reliability is (arguably)
worth the potential long-runtime that doing so may produce (because we no
longer filter out regions with 2MB pages).

tl;dr: just re-iterating the theory of this patch.

~Gregory

