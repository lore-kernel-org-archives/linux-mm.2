Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54B45C4451B
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 15:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB55B6B0088; Sun, 19 Jul 2026 11:21:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E660B6B008A; Sun, 19 Jul 2026 11:21:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54B26B008C; Sun, 19 Jul 2026 11:21:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC9A56B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 11:21:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F4BF1A05F3
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 15:21:00 +0000 (UTC)
X-FDA: 85005889080.27.107E53E
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5BB3FC0007
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 15:20:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XGwh7JxV;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784474458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JhZZLYUy5JN9m5m76MdXV4K8Y/qprA9fzvyMV8e4T6k=;
	b=QNGCMhDdh4LMDNuYREoj4WdttbQ9flGz9QuFHOahuZ3bklowC4kqgKUaRw5a+XcLUc99AS
	CId1Xu7VrwmbrGYyMweilhnH6Ez/9ZOUz+frjCDGiS7x90wEpS6PAvQfWzjpXPoiBzLwQN
	8pj2UYBp2GIa1+oeYUW2YHb6M3dZqFs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XGwh7JxV;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784474458;
	b=RfxLCaZ1++mVlVCUb7k43166Kshn7/MW2Z8DbMYRcNqILgTj0brF+KQATWMOdUSdQsXFoq
	0wNL8G0lN7ApCoKyqekKwpjd2mQXJxLK9jTMq+v79HiwDIobg9BmIz1nnyQuZICOmC+ZnM
	d3KtW+PXCyGuBUzcxWUjYM30swtc5Nc=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92e7632b193so644635985a.2
        for <linux-mm@kvack.org>; Sun, 19 Jul 2026 08:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784474457; x=1785079257; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JhZZLYUy5JN9m5m76MdXV4K8Y/qprA9fzvyMV8e4T6k=;
        b=XGwh7JxVKULP0PhH+srAQ8sTG/P6m6SDRml2vCrjm3vl1qP629UEufBXmJqvZkHYEW
         tS/ErtfJqsH8NAT2AnNEalhgYTRJPxs5S3kJcUC4w6b39MSzb7xOQgunme0Omq8LecJK
         dPok5s/izsWWKPaIVrOiJNkKEEszaAs8WiGsXNeVylhsaPZ6ZsxExWXZUmdxx6HqqcPl
         yq0uWq3ss73Xcn0axEhyh+C9G8wwcHRgxwqOXwoDIn5jNs9iWYZIDG6EvUKczciwV00q
         QeZ/tb690Gyf7imn9Taoy5s/N21GQM/L24zveRlsCRgx6YNwVh1bhnwd+fFhqBcpNrGV
         6wwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784474457; x=1785079257;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JhZZLYUy5JN9m5m76MdXV4K8Y/qprA9fzvyMV8e4T6k=;
        b=hCn/NAXZVJ5wj1XEXStNH33FANohtGHy5FSgFp0FOVmrZQYF2yu7D7l3Ga//ChsIOn
         6HY2bPt7nw/wuOMe16VtHBG5xyMPm3uIOWEdl1ptozCmAJCzwU9b/l/UTNyp59frbmvE
         dgFZsFTbXugIx6uaQ+7iwPjYMyzDkeM79xwNcIN+oEbtnrbey24C0QRyso5CRiolQMYj
         eQx+J4GdnYW4zOIaV8OCXVoFIeVBT6u5cuEbMbELB8mKo2W/0bMNr+yPyrKZVKmlNB9w
         /J2zD+wuwH40h/yP6JWNjzbYbCMCkVRxvxGOPsM9uF92vByA4kyMrc4ClW//LYT4BM7w
         YrBg==
X-Forwarded-Encrypted: i=1; AHgh+RpKm6gV9ZwbxLuSxNk3k65iD5mITXGDwcGGYOpotuXV1Qno9P8If9J7CvBn1w9UzYnQyzNh0+H77Q==@kvack.org
X-Gm-Message-State: AOJu0YwcvK8j6HFU/UG3MWEzv0Bmna0DAnlBJwKQ5qUaEXTS64zkStDd
	OXU6W9TP5Mxyu52Za/NwldYtzgVp5QuYbgz2VA70LMnHPsMgNqaRjFNyKisiOo05UQg=
X-Gm-Gg: AfdE7cnt2OEvrvRud6KQ8BFVc0WOOugP+qLYU2YMC+/Bm70fHjWnUrhaRV0NQq5YhGK
	H+XaWvXscfnZYFZT6oLKyitXrpPGUiKXsLSdozT7fBP6YulLninrUDmjpdM2ljeJxSLZ/9CQHde
	32vOmKPs2Du0OZesZoxc4Q2PTNyfWRqMCQtnRvcnNTo7tKMxXPxXet19p6j7cveJDgOWK3ITyK9
	eh5piy9SDOy0phC65aDiAoYq6nwgJ1j/RIh0Imd2J0U3qFdnyA8iVigFV0afNdXHmgrHwBjBLS3
	K9qnED/bZAzNVZywa5wEnfiOhYaPXmRsk0gk0uCL9/M9lz5RPckDsjBE3cbcemNRHBtObNttG+s
	Twut116VldJWPmi6LOZRvSK41b0oTL47h/CgLfkzSTYccQGSMOaL0rQ4VlhhtjRn28NXS0YETY1
	aLaodtn3gexw3lz0I3uWK48yfRneL4uQ==
X-Received: by 2002:a05:620a:4081:b0:92e:94a7:16e8 with SMTP id af79cd13be357-930b3eda1a7mr1060127585a.15.1784474457417;
        Sun, 19 Jul 2026 08:20:57 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b52e02desm673998585a.10.2026.07.19.08.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 08:20:56 -0700 (PDT)
Date: Sun, 19 Jul 2026 15:20:55 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: tt roxy <roxy520tt@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Ren Wei <enjou1224z@gmail.com>, linux-mm@kvack.org, pasha.tatashin@soleen.com, vega@nebusec.ai, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/1] mm/page_table_check: widen map counters
Message-ID: <alzrI44_Wg_aTx_1@plex>
References: <cover.1784337674.git.roxy520tt@gmail.com>
 <b4414b588418c52a99d959d35a40e064ae8b6e72.1784337674.git.roxy520tt@gmail.com>
 <20260717221108.c6caf7dd11a47bd7c32aa6ff@linux-foundation.org>
 <20260717223112.ba8646377b103cae717580c8@linux-foundation.org>
 <CALMqdkTUm=MBStkk85y=YAnQfHB_Jxis-BMZhcxfz=-YJfQDcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMqdkTUm=MBStkk85y=YAnQfHB_Jxis-BMZhcxfz=-YJfQDcg@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5BB3FC0007
X-Stat-Signature: hrsb8k8yjadf8txtkcfyg78hobb1wm6j
X-Rspam-User: 
X-HE-Tag: 1784474458-413406
X-HE-Meta: U2FsdGVkX1/RSHOHaTMocQChQaRn7UsIyflyzJyoz6upO675GAW9PRRJQsMWr8FIGBIWnKjJj8KZcaBr2jakuXD4itlgx+hVQK92z+a0gHkcVxBIzpXLNZCpQ2rZ9jtjnwwsekRzGvoW/Fdki3VHbvCNUFtMnnNltxXZRcciEx0f3urQu9yyb5p5Fve6tPn5kghnl+41zwRH827KPrnJ/IxMEil5MljDR71kkoWT//a7yLzFZN/DQJuvfVzd94Lf9QeHNaIqngmsPPgcBqeowfgM7txRvu541Hrb13FfAx07zP7JrXjT7DQjVEHzRyQQI2qjbYegeNJ2NdIEOW6Lzi9HVjtY4GVMg7o2H+r3FQMYUa2ieTicz+Cclf8v+gq4cQn/kxmq+2X1V9rvDjQG+FeRih0TrnVo9QXzpcGgbijvW48YXc90r7QlnJ8qLY5ZXH3zBvsnsFJQstI/8XH/JqlIi12Ca8PxEtuPl27uzOAkLw21ftBrz4QFnBRKmO0eo1xTOgq7Ga11DduaS6Jhv/uvCYFf8cFVqfiaFxmL/XVD15m82jrOS8sbJ6gkW9vonWp8Bi4k0A9m9oVl/ZB4tJ6LG+qVGNNAAIMAzUfwJyWBRSZSJ2uB7fRX4QchPE2VJ6c7901rFY6HTyQ5BjOnw5mgOxFnVxhAp+lrMARxrkr0+PetNsHj2MiIqwp9gv/wdWmw3lQLi6ObOF6KqmV81k5uMiBo1Nte8L2B5z/5E/RY61Db9isR4u78GU2IwmnFHzV9z3RZvUjfrAtWlmfjOmRFFo+5e3mISmMOSou8wZiGDq6lKepyyQKtSGF43J2FFvOFRt6Zn3+fTaZW+1acY6YX+b3KZIfAoWEmYm8zfgKvcE0N+neIbUUqSj4iAKyl3JvsHtENfDwxO4JToVsO05Dui8ApA0InLCWgOd8ewK26dkMpK+RgZyTc7M3PSzJXt+Ohgs+zCojE9b09wLl
 ubA2t4Ld
 JHDbFUJ4mkg0WeC7c/Q0G55SBB22yAb+HKVTU9tOY7sWRVfxNTVFWwdP53Y/QcEKRH3O1FvWFE1RkBbz1Js5Pg+i8pY15SEwBAICSecHIPoj35eqlNU5XfmoBc8L/p+x0b10yZClz/DINdmPM+P3iUk69Ae+mOXxmkA+aM8HJyCiru6b7hxmKetfGcu9xrUh+VcxJH6lH3W6M+FeSTHJmBYNkGa7lgEsZgKkFASTToYq2BsE4kWJgTothzhofuzjFIK6qRYuxJhcjjPdmW7hXxRNZ/tSq74poULV+UlHncePvjAPbfD9tDXSIeLj/Vv1dnyqlYGd2N03uQHGWe0SgWXiDPLin23LPMP3I6+IjbS1AJ9mz8A/yhr6QnKS3HUihoBEgj0ksTLL7hB3XLcDnN7eUAPjhKbfO1QILFCfpMu4SCOYwOqqWHcApJanl0lvMdaJKCOi/oLIkigLzmx96JfTeRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07-18 18:21, tt roxy wrote:
> On Sat, Jul 18, 2026 at 1:31 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Fri, 17 Jul 2026 22:11:08 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > > Probably adding __aligned(sizeof(atomic64_t)) will address?
> >
> > err, no.  I think page_ext code will need alteration for this.
> 
> Thanks Andrew and Matthew.
> 
> Agreed. Widening the counters is not the right direction: it changes the
> page_ext storage/alignment requirements, and normal page mapcount is still
> 32-bit as Matthew pointed out.

Also, double page table check overhead. So, I agree let's address the 
special case instead of widening page_ext.

Thanks,
Pasha

> 
> I'll rework this around a zero-page-specific fix and send v2 after checking
> the exact page_table_check paths.
> 
> Thanks for the review.

