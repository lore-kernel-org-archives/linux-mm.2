Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DD38C55167
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 20:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2989E6B0092; Thu, 30 Jul 2026 16:49:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273156B0093; Thu, 30 Jul 2026 16:49:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 187406B0095; Thu, 30 Jul 2026 16:49:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D5FE66B0092
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:49:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43B1DC02A1
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:49:31 +0000 (UTC)
X-FDA: 85046633742.08.08ECD25
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5A3D3120004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:49:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OUEH47b9;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785444568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=azR+hkvo8cQmu5EseR5wH9M0hM5NW4S4o7e4N9bgAu0=;
	b=l9w26P/RDrVxTK+g4LmzvWZTnHb6lslb3C0Cq3RR9j+EnFjZiqgxKNIqcy1pMHY8ZLpSpO
	wEoX9aWBazAtdyj0LQcpRXRWp/Czbzgfe8gWT2b/BTgHkCK5DZGb9GoN9t+AHWOGH7gvft
	3E6eGrHueOBHDj9P7P7a7OEdAc0JXmg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785444568;
	b=aP8FovAmsrrUmqbuUd+r4+Z6ZrgpV8JjpAKfQpBTo7euK6+ShXFmJUGA9KZhXOd57PNDLh
	KgMwZKqy2GL+dsYqH5fn3erd2KcbiRql7rHEoixin9ynDrTRlhCkyaQDpXHUdSlPRcBVyI
	2MPvzWrZg5YgzQuDmbs+F+Y5Pn/lXgs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OUEH47b9;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-930f72317a6so15743385a.3
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785444567; x=1786049367; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=azR+hkvo8cQmu5EseR5wH9M0hM5NW4S4o7e4N9bgAu0=;
        b=OUEH47b9cEE4KM3SnXUgPQJXTcmvquatXzyU2fyOTyAe+AZjCw3bQpAtzK2EbFGHBZ
         eAfvStQ1BssW4reRZ9hLwKiPeWqz8gP1jOhR59qFsdfRQkEW04Q4rRAIUz5UWOod0CgV
         o/SwmNDxzGcp/atY3S54HMh2GBcEr/NKfyhDATP07k3gglygl7lKHt9xsWnoCczb7epH
         Yd9WHF3LUBjEM2284UtyTTg70iz6jD59zoENpwpDnppsRkWCr4pTtddpr3BGIQYDbbtk
         SoDG6KPyue2FDeF971LYXaJPOzglj+YVht5tGzBD4DC5welECnniU1DlS1vaP1pkBHV0
         +hCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785444567; x=1786049367;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=azR+hkvo8cQmu5EseR5wH9M0hM5NW4S4o7e4N9bgAu0=;
        b=o5U24+9ZMIQl7vsfSsttm/cSv4NvzGf6OlcyI+23d3lwVNW41CZyQg5t/bgSBkmXZq
         BW1q9hFudz1m3/IJjEDOVKdO1Zz6T885yxUZWQrjwzsLQr0yMMzIlUP5gdMW6dFhJD1W
         jwAOWYamZcNFpcznTm9YStKbuRczUEwXhZzpJX8GsgAeI2zZ9n1yhMy1/DT82WRw2thF
         KDcp/GZ9Mb19WEnohM5JFHh64Ea1PTk575RAXAPfXscilRxrctv2qmJvYSIvja0eZkJj
         iE7T47wGpEtJmutWGNQUeI7hLfOO1sRExY2CDtbR4FLxuBT+7fmoT4Yc2F3+L+yMCTAm
         em3w==
X-Forwarded-Encrypted: i=1; AHgh+RoK3vAvTsSzDc+na07RU/JXlvvJ12fraC13ISWTv+4DafIHTaGSO6G44PrDySXmcdvWipaedKnAeA==@kvack.org
X-Gm-Message-State: AOJu0Yy3maj3wpRBitGcTaGxrz7rSUqe1FQ6greNBPGzYZkVoB5q414g
	rnjtCT24B21rBytcVS6qYKnVbQw9YVvSshGjHipW9PiICWlabDWbeYHengfjlPJ5yKk=
X-Gm-Gg: AR+sD13pnG2qXt4GDdXUhyuo2jYtiCrKyigAnteNwv5kIRUSAC7Wa+6gIvShjht4VSz
	1dOOmggnuoM0k5RjojpcLiij74eQRzEVh0xfTxJsYoKcWCkoEoEzv2sNmljM+gpv97jAC84ENBi
	kYqn25XOaoSFjgdJOffEVKYRWbtsX16QrIhdvLq8Xb9x6z9O8QvwOnfhHHTVWbXFOvr9sbly8qj
	ObfIeP3vtjhdAILktMTNQAbAOV7tmJvFkKByWVl540SzVHkQEbwepeQ+kWNd8/Y//7Up79GMcjO
	Dw3VHIJMPLNoI3YNlcA4W6c+DX2GaMw0m80Zp5u5PUWifwDPDd/3Q8Otag3x2fVUnecR8AZwgf+
	rcVUgNvCZHTDg/3D8ifTnfVDwx1tqBxq5HualDTNIvLjJR4A0AmvOW7PY4cZKibMqAFrQYAzcM6
	WtT6sSMQ7YeHCt8I0HiuOdQ1h6TA4gRm7SxNAhFyl8U+/BFMc5Z2p4RerQI66sCwiK+RGLS32Kr
	utA/jIZ1nWhx8m1YqjyzjgHSjv1LFQkPzS/FNELypHK
X-Received: by 2002:a05:620a:6088:b0:92e:c118:18e2 with SMTP id af79cd13be357-9348dc4ea66mr225698085a.89.1785444567383;
        Thu, 30 Jul 2026 13:49:27 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d325ade8sm489716185a.12.2026.07.30.13.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 13:49:26 -0700 (PDT)
Date: Thu, 30 Jul 2026 16:49:24 -0400
From: Gregory Price <gourry@gourry.net>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Frank van der Linden <fvdl@google.com>, 
	Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Brendan Jackman <jackmanb@google.com>, 
	David Rientjes <rientjes@google.com>, Davidlohr Bueso <dave@stgolabs.net>, 
	Fan Ni <nifan.cxl@gmail.com>, Jonathan Cameron <jic23@kernel.org>, 
	Raghavendra K T <rkodsara@amd.com>, "Rao, Bharata Bhasker" <bharata@amd.com>, 
	SeongJae Park <sj@kernel.org>, Wei Xu <weixugc@google.com>, 
	Xuezheng Chu <xuezhengchu@huawei.com>, Yiannis Nikolakopoulos <yiannis@zptcorp.com>, 
	dimitrios@palyvos.net, Ryan Roberts <ryan.roberts@arm.com>, 
	Huan Nguyen <nhuhuan@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-nfs@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	Alirad Malek <alirad.malek@zptcorp.com>
Subject: Re: [PATCH RFC v2 0/3] Demote to lower tier using non-temporal stores
Message-ID: <amu4cfko8YY9awfF@gourry-fedora-PF4VCD3F>
References: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com>
 <amuJbBrTW9W6_sx8@gourry-fedora-PF4VCD3F>
 <CAPTztWatWbsF4KQwD-_nib-vrZ6uvrhMYcOc1mkWu-7DzN95AQ@mail.gmail.com>
 <amuTOC7qxWHVyZcO@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <amuTOC7qxWHVyZcO@cmpxchg.org>
X-Stat-Signature: mito1s8dis8kuenkdf4my9zcxucnwwpx
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5A3D3120004
X-HE-Tag: 1785444568-756466
X-HE-Meta: U2FsdGVkX191saDtvbL8v6j92v+JWDurPUPC2lGpriuMtFzJ92L5V9LhGc3cQM+nFMhGTRzyptFnfEdATPtC0UiyKlZ5lITq5ut/tL5hgNF6SSYdhng4/HIiPTU9cL14O2D1nCsEr6WTrqAOFQkYeKSG7noF5v3snm50caSqo6U3rOgDnH4cnpx6Vac0IFjFjwR5YZR0MQ7SKYid0/jCLzsA8hQ4JkT7vnhaiFKO+RSfw1NxDkpVSqh9Uz9AXAABqp+g1DVELtqtfemwODL/5GMr99OCfl/yftboCfw7dse61PQQ9ve1vtZx/wSY1rXa5R8DLz27r2Y6BavE7sH1MrprnbE2blL2WApCm0MCDpxsiGwokFu8ckkXzh+sTUtG1ohy7Q7ZTjrfoO9XMu+4yzZg2Yc79QZgHyI15+MGcMUE/OCOMbbIOIwea9yzHqbRcbzNnvaMkYmViB18EyabyqUbhyDnPYPeF0X3AEXY2vYyGOyrSVCdJJKGFdM0o50L3lzhF6vcMKvRGlDVD4ch1kQx35xSz8jXsDTw+mJym4IfiHXjtV56NQBjTgKQp9nxMV8NtPk4uApr6bVHhmzBYAi+QwsIm12/+RQa1S/G9mMVvLrRhZKN0YTX+Fiu+JkLdZW6EnQnltAqHh8s3PDSg1KntTU/0+jgvvJC30HFNrn9Z5wZsHaPuWaNC9WOjRqDtzl9QffmRptV02XIXSyxNIkBb9GI3biYnVbIsS8hT4barZUoKNRwyBYsGspFyMbgn8EROyBvckYGkSHBEF0IkZ5FjzGg83GK5YoBAR/le3fzdE7wujYxh7aIMBLovF2IGMrcrvuLf/6F+EtSKzpCJOAMDKuvecM+QVIVbo+cI9fh8HPSFIkOnxCcDMWjUmeAnEJPM6uKPmfdIqUaCuLSU3J7ENwzpt716Ml+6BIXihN63M/uCiIqeMrvlSQNJa6qcgOFjCQpAo5HjoffYaX
 zhfxB4al
 YmE72dCGdoCUA3J2MTW7jc5zaCkdIKI3YrcfgwpbY7jP4aMAvVcffRfvtgtfM/Er9froaI3v9HaOSeb5Ir55MuB4gIGHPJKpEQCvWXAXD0m3v65DQW6nVgGa9IvF7YVt/9dPv/E3TCpSSEnHUpW/e5GIDOSEBCVyzSZaeFI98bHKkDKHp9PB+lJkSEvpA9dY/wvdDGS3XkSmv+khci+1ha+qVtZwgJTgTeAtHXAHd/ukWR2XVcgeaVGZRm8cNiaWtbz1GSZpeH98Y4vzo7NwsIF/0kpQzsQeEqIpg1MAOxcuDojGbnRlZg4HKuqF/p7eO6a28dC6ztxLnGlXfzEtt0tDgTSuD8mUdx6fIkNIpGjHmvuaukF+Ez9s83NlMhFRTVFFun+HPzxiDa64vtT5usaJoLklSWFGXkzJFcmjvIUOjNr0vyrONac8MslCCF9LVLILpzz8sWFIyaKAWThnvN3xqeCZTtlG0IxlySR3I498EB4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 02:08:56PM -0400, Johannes Weiner wrote:
> On Thu, Jul 30, 2026 at 10:40:32AM -0700, Frank van der Linden wrote:
> > On Thu, Jul 30, 2026 at 10:30 AM Gregory Price <gourry@gourry.net> wrote:
> 
> > arm64 already seems to use stores with NT hints by default.
> > 
> > In general, though, I agree that for ASYNC requests, just always using
> > NT seems fine.
> > 
> > Maybe the mode and reason should be folded in to one variable, so
> > that, further down the stack, a decision can be made as to what type
> > of copy to use? E.g. if the mode is !MIGRATE_ASYNC and the reason is
> > MR_DEMOTION, then non-temporal is still a good choice. If the mode is
> > MIGRATE_ASYNC, NT is still a good idea. If you wanted to get fancy,
> > any mode with folio_test_waiters(folio) == true should not use NT,
> > since a task is waiting to use the data, so caching it is better.
> > Maybe that's overthinking it.
> 
> Agree. `reason' seems like a much stronger signal.

I think this ends up cleaner as well, it would be a nice improvement.

~Gregory

