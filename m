Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94E59CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 09:34:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00A678E000B; Wed,  3 Sep 2025 05:34:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23528E0001; Wed,  3 Sep 2025 05:34:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E39278E000B; Wed,  3 Sep 2025 05:34:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D0EEA8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:34:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A167859B50
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:34:31 +0000 (UTC)
X-FDA: 83847428742.13.F7E1D70
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id B2A06180010
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:34:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K0nmlxot;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756892069; a=rsa-sha256;
	cv=none;
	b=kdulnhZ2NhHQCf7IEInjAZZXyDcmdc2R7bmB3RKcQO3NMcDFWLu6zre50lTmPxJyAeawE/
	Yn0otc1sH5AEwuFmGQ8qS0SqDCEjjcZiErljqRWBDOxii0vE081lkxl60KqZoFs9UU533A
	2uUiRpdh8MnLcxH/TU/TgKSxAxglxKs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K0nmlxot;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756892069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mnXxYUmSUAbuziAVQp/tntBVhySw2bhEF1h3PYk8Xjc=;
	b=QUXb+Nhw2rJtFOINC4eBZb0kEyuIvT5IjSIp7TapaYNmVpZuuFl2BoVdRH/rKFIY2v7VCN
	Mm5dR8XcU1H41Ajs4crpOIqyPl1OZTdnpzIxDBi5ImE46Z90FRNI/9wVqbGF2rERH3KI3o
	nWpTqbPiBL3pBZuKh7YCL7ENL38yeWE=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3df2f4aedc7so237625f8f.2
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 02:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756892068; x=1757496868; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mnXxYUmSUAbuziAVQp/tntBVhySw2bhEF1h3PYk8Xjc=;
        b=K0nmlxottqIkS5xxBJFmDkxhGYYxny7ch+IJYaazM8Sk5sD7AABPWbC6ssDeWzGVAA
         hJ4Htm2G1++W+hYQaS3xmNb9HhH2ZGGTAD/PGZHvLNyqqpGfqBaZVLaa+e38f12nuXsC
         +qZABXRCG0GL1v5RRhD/y7ahusNpyyxV4eIXF/P+/2e5KriYE0Gr8ZdcBAUR5b27iLax
         TUecOBf9CuaRcL6/0wf9eV4HTqqdcxCnGH4plortH1tJLQfQD6AHe0y6ZVfmUwghlim9
         RJAQ/NRWrjzEitaK7OM2Tgebj6QyCYtY7oC7v+vPZL58wTEfN4hMo29e/Sf81JjMiqxV
         pD6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756892068; x=1757496868;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mnXxYUmSUAbuziAVQp/tntBVhySw2bhEF1h3PYk8Xjc=;
        b=vEqJ5vB2/9cehicM2o7G0ZY9NKXRC8JdHS8IxzcgOPYY7cgw2MK9JU5hbCNPunrNDC
         FLo3JlwiLzBcSeDSzVDR64l696SZYMVEiQsgU/CQpZL8wv+/mS4mqzLaYyV44GKrQMp0
         tPX5qvDEscm4D+OHNdDvjarHaJyMIZn5t5mQk4lgBJwlzDkKgMH7cVFJeVV+pE4IRt4p
         uCo063/8GkNCk5G4FR5lXf8fJGP5/gkZ7q4+Mq0MMt1tdZTmVBAymo3FMPP/dkCWq0W2
         Pj9tL9EiJLjcDNhwN/3cwyQoM7ryZv00AjUYWTV/ckTf3bylwYq8LDGi/1Q8IW8ftAIt
         j5Ew==
X-Forwarded-Encrypted: i=1; AJvYcCXC5O6qJrQ3kQEBbhhEIB3w6JiYiFj5EnHYaBYTzFoJk+n/7ZxVviNky5ooOPwxhzQLvT7EA7+7Eg==@kvack.org
X-Gm-Message-State: AOJu0YwqwcTzcyLuhBvpLy7ptWWfwYjZvpmXUYtzrsMkO8fAVFNpRC44
	TElNAdCKHufGq0Q0IGGOFIJhEZBVNE5ujKLwyYKC0LdsLPiXouGF1Ccu
X-Gm-Gg: ASbGncvT6NTtKtGCEfPXIoaA/0of3UsfYVttPAuCGMT0yPKK68rIYOSs75iKp4Uf6zA
	I1rQmmEbUBTinP+D677Ou6frVTqhGGex3tbLBOKoosdTHLxJR1YAx3upDs/Zk4596yirVx0rHRU
	DUH30lthxUKQ4TRQdJ7aGRHJ1vx5DV1P+y+3pGQPzio1JD87fTUaula+25bR+aHeL7GRFGhb7F0
	1wB0hXzzsbVdelnuQHuwYdYZEaLMQfopj1wYyN7pIF3Rugru7tF5+aJlyjYM/r2aSWzBu8lWK94
	e0loh3Oykp55TrlKmWYjlJZvJ4D5Fsi2MR2KFs2qSpoPcJWpToHSv7gwgWGr3oBpulDtJWwVMja
	PEaFlVd+tCSSJTQBzDaHR1I1+UL/4EZIjPehMBmVkKaubUTnScg==
X-Google-Smtp-Source: AGHT+IH0igkYbyCZ0CHxVl196rXHiK6GWYO92Ep1yKJ+DiFqBD6jyauf5QFuTCkfYbls91RIKaQpxQ==
X-Received: by 2002:a05:6000:250f:b0:3b7:9c79:32bb with SMTP id ffacd0b85a97d-3d1e01d54b6mr13455125f8f.44.1756892068052;
        Wed, 03 Sep 2025 02:34:28 -0700 (PDT)
Received: from devbig569.cln6.facebook.com ([2a03:2880:31ff:4d::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3dcc19a386dsm2501197f8f.4.2025.09.03.02.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 02:34:27 -0700 (PDT)
Date: Wed, 3 Sep 2025 02:34:25 -0700
From: Yueyang Pan <pyyjason@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org,
	kernel-team@meta.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/show_mem: Dump the status of the mem alloc
 profiling before printing
Message-ID: <aLgLoal9q7Zx7Yto@devbig569.cln6.facebook.com>
References: <cover.1756827906.git.pyyjason@gmail.com>
 <8dc71d31de53afa4c0bb25234807b1e6ead5ba55.1756827906.git.pyyjason@gmail.com>
 <ef1b79ab-15cb-4720-ab05-d77617143a26@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef1b79ab-15cb-4720-ab05-d77617143a26@suse.cz>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B2A06180010
X-Stat-Signature: 7z6ztwhn6351dzqwaosziinpwhsidxun
X-HE-Tag: 1756892069-564577
X-HE-Meta: U2FsdGVkX18E+51BBMbBVIbECoee/wy+7iKiuYUTD18Sv3zQct/tdoZp8AihZ4YIH9JiUqj4trdZiHPsTNQkMCD57TMlNa3v98mIxTYY5k7Kn9/CR5W9nK0lkvj+GBwCYQZfF+imt0gXlcvFSZ6CY8PL8KAcZF8W3zfzZM9+4NBvFBZpCa3pIsvlhfvMQU51v0up1ZbMpQSp2N5yueM5AVoA22qOWj2jZIt1cbvn/cj1ceteZcm48MKpIsJmPhRkxr6rMKuN9vQc7bryt7ySxpHhlrmX/HZqIEWkd/5XW4ya0YCV+5r6JZHD1Zf8Jsr1ocmnNJ58U5QGHJT7pq8mkuzfAHCksZAwa7dxc7/llabmcdmXQAVfnqnCakfwTzofUnAZg+p7RZrPWn598rGzB9V3Q58kMoCaGWUFp6gNYgIrInU/3kzONCJ8Y/cxz8BaR3L5A2SMdrMMQD8e/eJzMltm7bPm9+i6J2wWlFrhUIk7nByIJZx8mMpFgj6PKJpG+yPXILu4Pk13yfajBL5n/pY5eRZpZcOCDPuE7KFJXS1ChAutshtnULwHNA1FngzceuJzdeMBMXByx4XvvBDURIE10I1DJLj+5YpUjbJiAr+We7f22Y+F7rc7UoO0VipNTAKlL0yqtix2Lu5GCR9b89mTdMyocq3wrsvNvG/2l272d6ft6kvAbFgIblLeSgMnmq5RIMjvpWyFMIjX44TLs4ahbGM4qrB7X7qMKghgpUzrveyIeSAgljrCCmbsvbiCNVbJCmPcVsH1N5+vvCvEYQvzojP+LQU2Qcofg8CAjQ1o7AbBZ3auqRUYMeCCkRjWhvLKCfF45fUrE3M+mRbnftKYSrH85VS51AXPq0sXio3GagtMXPlIJxrDJz9ENOMEwvw2Z8VchQ36U0dw4TiChahZgO9aNhhl9jArZ2Grn0bbXQvAAHEVBLs0P6rZqTYfBXkjw68s3rdBt83gMkl
 AsNbSG6w
 yH7rgJambV1clHQDxnxLlyqq/fYfheQFpBsOAA/HpKaRVDe6bczUysyNMtFwww5tc1i5Ib0JvjpgAxx7WT11Ldv9eAn4tj1WrpJQMcKMb8fMwEgp+r5O1mICmz0d/LWWgBBp4GPEzwtrCwWvZlWylnoEbu1n9HZILPsS9AqteTzmePIC6Ghjl4f8EiIe4VPbe+NSK+hjnVq6a9fI6usg14rjZmy/ais4JbdUnqDJ7ox9Uw1XpTLdbgnyxcInHTee4Gdw56DXcWcHJpwAD74+R/g1Yl1Ax02W9SsduOVm+a3+oacZPIRIhfkVJQ/WjtvPk/eVy1rMfytYoSw6EUpFRzWZLRLFtKetggkP8JChcojZIi4nE7FdFu2VsHoSw4YApFSBo1z1L3HYhdx6cVSMjO17B2HkRT+tnoL+u/vWl7tRzN6/MoOwAeybJVBN7DzaUwR+csQmDVNx6S3bnpJGiu8z0OByBH+9mX3OOXuAS0HHqV+wEmeDFRoCw+Qq5YWVes7yVojelFlwJhlGSYQO6syss9bTpPPtq5C/xPP9HQw2gQ7rRytV9oHkfbgepshq2+KWDz2ao+2Omeb4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 11:26:01AM +0200, Vlastimil Babka wrote:
> On 9/2/25 17:57, Yueyang Pan wrote:
> > This patch prints the status of the memory allocation profiling
> > before __show_mem actually prints the detailed allocation info.
> > This way will let us know the `0B` we saw in allocation info is
> > because the profiling is disabled or the allocation is actually
> > 0B.
> > 
> > Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
> > ---
> >  mm/show_mem.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/mm/show_mem.c b/mm/show_mem.c
> > index ecf20a93ea54..51892ce2efc4 100644
> > --- a/mm/show_mem.c
> > +++ b/mm/show_mem.c
> > @@ -427,6 +427,8 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
> >  
> >  		nr = alloc_tag_top_users(tags, ARRAY_SIZE(tags), false);
> >  		if (nr) {
> > +			pr_notice("Memory alloction profiling is turned %s\n",
> 
> There's a typo "alloction".

Nice catch. Thanks!

> 
> > +				mem_alloc_profiling_enabled() ? "on" : "off");
> >  			pr_notice("Memory allocations:\n");
> 
> But I think the message would be more obvious if it said e.g.:
> 
> "Memory allocations (profiling is currently [on/off]):"

I can change it in the next version. I saw Andrew gave approval. In this case, shall 
I send v3 or create a new patch?

> 
> >  			for (i = 0; i < nr; i++) {
> >  				struct codetag *ct = tags[i].ct;
> 

Thanks
Pan

