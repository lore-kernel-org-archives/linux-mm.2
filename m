Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5870C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 21:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D26186B0095; Mon, 24 Aug 2026 17:58:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFD076B0096; Mon, 24 Aug 2026 17:58:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C13456B0099; Mon, 24 Aug 2026 17:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9FF626B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:58:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 343404026A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:58:57 +0000 (UTC)
X-FDA: 85137528714.16.9E9F617
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id C8F2D100004
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:58:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fzPMhn35;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787608735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KBpVXvNSIu/VB+Hjuc+28Xij0/FItj9lSc9IUEB2grs=;
	b=b0MBviS2tWe50iH5RTOZzrMmGC1rBN8+buJ+/Pg5hEa8T9+UPOQDBV2M7ei3X/SjWevlWY
	c6dRr7HmiXtWviahnle9Mm/VX6DEuwBb79cnzieEQQYvFtlGEMuLEvsU1xnMWOYm0gG6vz
	gYMrhmEJIuGtiHo3XnX+qW/Gh3o92yA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fzPMhn35;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787608735;
	b=MfLqpqbctA00C/GAUJL8S2rrurqAsB5jm/pdWgslw2PTAZ7zyvVz+QGZCd0mDs3HKQ/VNJ
	oJCoXLCdAD9TPU8Tdk7k833fHOp/qkHLq6GiFSy+Eq/qN9Ivy5djFONxdqDT+AIiTIr1yg
	aVzY8MlhntogZdkBK5pNtwW/oM3qkOs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787608734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KBpVXvNSIu/VB+Hjuc+28Xij0/FItj9lSc9IUEB2grs=;
	b=fzPMhn35I2Lpz7VWka8VgkdWcAP0BGFHDdbkZWNmUBZ4LBtsxQrDGaz8a24ZRW+bQnWkkw
	SS7xzPhSrltnGtLL4srexdOcoOuriGbjPEzg1JQlWZDDrVeLCWWXU55x8qwaB6mkwZoc6j
	2Jy8PHq6inPu9R7zpbihw65KEocvXqU=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-GjcVLx-KML29W4ysMiTf1Q-1; Mon, 24 Aug 2026 17:58:53 -0400
X-MC-Unique: GjcVLx-KML29W4ysMiTf1Q-1
X-Mimecast-MFC-AGG-ID: GjcVLx-KML29W4ysMiTf1Q_1787608732
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51bf321d786so33544001cf.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:58:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787608732; x=1788213532;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KBpVXvNSIu/VB+Hjuc+28Xij0/FItj9lSc9IUEB2grs=;
        b=fgLFzMNCzbeX6/umw1bBOaPDzdk0O5dFY1VQE7JZIdP3uRaExkElGAlBCoVkN9rkNg
         TsxYRYXsvVj9MBZTVriwg00ruOAzxKj5Qnzr6DfAgBhJErqA1mwFGAr1niiSmG1WaYkd
         kOfKkAgWIeSH8Wg5N4p0e0Q+SPUj3mCy6rpFpOIvkJDC1q6AijtDM5L/dvqnRdAUAsMy
         URtOk2by1dh+o97qCbE2QkTNE91dblX8u2XMzKB65yegWu1nHeqkf/0OXXoHp9SaMtDf
         IL8ZhfufmjcL81Zx2oh8ucIWxEdxLg0243S9LjD1UKUN5v7bEAcyS+C+k7gv8IxsHYLp
         eWLg==
X-Forwarded-Encrypted: i=1; AHgh+RpFzBv6fe/FgQt+8+1IG6UzMeKem58TB/gGTZUJSs8thnSSS0S6DSRhv9ZED/tmIDTFt0RHTGvfjQ==@kvack.org
X-Gm-Message-State: AFuF++kiAqCn8IXCnD3aVwu/zHKTgI1LEDoZEi8hfY8Dtros21I8Kb8J
	Y5OMHLMil6KF52VVirW0a22aipab0B7MWMlt7m8y9RAHRyRdlRwbVkquuf3KJWJvnlrYelXM7Pm
	fdiB0puHqiQ0KK3/R6goMIZpfIdv/xMzZrrDY7Ha/+r8uvtQFaStY
X-Gm-Gg: AR+sD12dIxMNEz2IS4eCXnCOBkfjyFPGS906QM/twg1VRGyc1SlZlULulgcf2MAFwN6
	TnsMFoiZE9zNn5RZChxaLvETbD5MJAsE5EWDTs/SPDo4BEtjNX313mGP8xM3lAUehzC0y6KNWWS
	k6+ztR/BvgJ3myubwKbLuCYF6axESxKsG4oO4Z8QIWln/7vvs9AX/dwHRG0yv87BW9CVpXH99US
	PEZOoLhAmNB5mPQtu5HORRLw/wfVcw0u3qLQmS5I74mu91u6XA/kZ2RXkV51sYiESe2d9XiM/iw
	07jAtykXHuwGTWZBA3YMTlvocULlTELtjwEvlU5BMv4ghoOScidYS1zb2iSHRmSbNxqlubvmcdY
	QO+8Ky39hpOl0Alsn3uU0pnKpSYC143mqhyfiOuLt9GwP
X-Received: by 2002:ac8:7f4e:0:b0:521:934c:bcf with SMTP id d75a77b69052e-52e2f17d066mr22919031cf.41.1787608732353;
        Mon, 24 Aug 2026 14:58:52 -0700 (PDT)
X-Received: by 2002:ac8:7f4e:0:b0:521:934c:bcf with SMTP id d75a77b69052e-52e2f17d066mr22918481cf.41.1787608731836;
        Mon, 24 Aug 2026 14:58:51 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52e099baf17sm55607001cf.12.2026.08.24.14.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 14:58:50 -0700 (PDT)
Date: Mon, 24 Aug 2026 17:58:49 -0400
From: Eric Chanudet <echanude@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <aoy88hVQcA6Gkfuk@echanude-thinkpadx1carbongen13.rmtusma.csb>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aoqbCyX-32doBJwd@kernel.org>
MIME-Version: 1.0
In-Reply-To: <aoqbCyX-32doBJwd@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZiefOQvo86oQMDu6i_Zef4tPdsgUed3RTIpUlH1YzMA_1787608732
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: gbucj9ygjkraztjzd4cjkj4kxfiscafp
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C8F2D100004
X-HE-Tag: 1787608734-628527
X-HE-Meta: U2FsdGVkX1/lJRfxs+UPy8FnlG1LfZ6DPK2GBPRq07hgE/+UMKb1iudzfJphVAuFv/+DjWRrzV3Wvqtr4cMcSznFDYs/HJU7BjJduz5aWrZ/ikNUy1afkD6N7mM7pXNj5rucTdihXQDH5B6CBK+IQH606o/HSDtU3yu6qFNpwO2vVASumC8P7r/wo35gUDYCdrEN9zKVEpWYDoytLWMlwQ+ohLw7rMsd49hunHRMx+s/5olFegp+dlVG+Uj0bTPXKDbhEfPswUftGmWS/zsOAWgxQZURZsCgxGoaNfxTGej0QTK/YjpIVeyE5LWFlrlWKpW23NybnRvBEYm/1r+ZpGsCtzg/T24pDX9Ca9y9wDZdDgCLI9IWTom6mBFUj3aRuZh7Bq0krSXmhdVdi9NDL1FvWgL17rflWaARJsM0uE8aQ3P8+IMM6y2lyk3h0aEWf0aw7dRubMFXSt7yPfLliU4ldIfGMb1hwwcrwj+LmlVWmsAkQiUW3HPZdqspy2yFHkAi0ierrycKRn/OcDq1yUKxAIhXWVak0EdWM0ugymjUsa1Q0US4mjXXJ0OV3NZ5YlaFSf1lUA7O8gQsaA50eCgrvByU5yWWXLsqsRMNbzdt9qIityNw1cmRztPRiNgDZlvW0D0rpJqH3ov7sDsuMcLWW+9nhg7pzOT+Uy3fNLVUPAw7JO+7/cTgRrzx69Gx7al9w/AvYyZ084nCTD327iWfPtgOnYqiVlRD2cJE62LjMPFrm51ko55Ut1UI6iEDmZsYdPLnzZWqSJPs0pssO8eBR0/u/rS3JvqxT3Ea+3ZKFNEX9L4DV7vQ5lPKNvm4kEIGd3DJbdzH28bOw1zgj2OBnyCKyt3utEJ7JNRIXh8vQzdEvIv3CnntlpaVJoCLxAsqPwBb9mzjOEAe7UC1bp//5aRa/yoRkym/l2RsC3xCF84vjF27zKhv9HjKpLoE98Z66RRnZtfBS9MGi2b
 zK55VNG5
 BT60xvjLXBMWFcKHknHa2iM4zQEckXGaiPmnbBmsDwvK6npBxzaiXAtNw/UZtTnZuHKQnPgSCcVo5WAF3s44sO8naRGTDDHNKFqBhATbigXedcoZsr9Yk0e56PFdaxVOyPGEIsXTQe/aWE1JiCEbOkZBtnX5+w3tlDCFJDZ8hHKa1Eb1+JAsV4XQpHaTxIApG6HQjFtcyp4SxKAEmBP/I0/F48M3u+h3FfuI6BuaW+BE/wv7HCE7m3XUNGlSwxSeEbpOejXg1PdQv0tWQKVkTuk99xtQXYA6+QzMSq1cc+pptgCDm6XwxqCthgb9CkXUjVloKyvwFj12CbRsjsVzGnxNXXfNNKreHb89+qacv4N7qA6n4BamTF6+KeP740VjZnwXkKI+SsM8ff28=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 23, 2026 at 10:02:35AM +0300, Mike Rapoport wrote:
> Hi Eric,
> 
> On Fri, Aug 21, 2026 at 02:56:52PM -0400, Eric Chanudet wrote:
> > CMA allocations are currently unaccounted for by cgroup memory
> > controllers. As system resources, they should fall under memcg, but CMA
> > areas partition the available space for different purposes and memcg
> > doesn't have a good representation for that.
> > 
> > Add a memory_cma_accounting cgroupfs option in preparation for the
> > following new behavior. Make it disabled by default since it will
> > account for CMA allocations in memcg which may affect existing systems.
> > 
> > Provide CMA charge/uncharge functions to memcg that introduce a CMA area
> > specific counter per CMA area. Charges are issued to memcg and to a page
> > counter for the CMA area used. The allocation's folios are marked with
> > the cgroup via commit_charge() (once for large folios, per-page for
> > 0-order ones) so they can be later uncharged correctly.
> > 
> > Add the new memcg calls into the cma allocator under __cma_alloc_frozen,
> > for both cma and hugetlb_cma allocations accounting.
> > 
> > Finally register the per-area usage counters in the cgroupfs. Each CMA
> > area creates a memory.cma.<area>.{current,max} pair for reporting and
> > limitation for each area.
> > 
> > Selftests and a vmtest script are added to this series for convenience.
> > The tests are simple accounting and limit enforcement verification using
> > the default reserved CMA area (cma=) and hugetlb_cma.
> > 
> > Signed-off-by: Eric Chanudet <echanude@redhat.com>
> > ---
> > Eric Chanudet (11):
> >       mm/cma: drop const for struct page on release API
> >       mm/cma: include linux/cma.h in cma.h
> >       cgroup: add memory_cma_accounting mount option
> >       memcg: add cma charge/uncharge functions for area counters
> >       mm/cma: charge cma allocation to memcg per area counters
> >       memcg: register per-area usage counters in cgroupfs
> >       selftests: cgroup: add cma configs for cgroup selftest suite
> >       selftests: cgroup: add memcg cma tests
> >       selftests: cgroup: add a vmtest script for memcg
> >       selftests: cgroup: add memcg hugetlb_cma tests
> >       selftests: cgroup: amend vmtest-memcg to run the hugetlb cma tests
> 
> CI found issues:
>  
> https://github.com/linux-mm/linux-mm/actions/runs/32519133924

Indeed my apologies, I messed up CMA=n it needed a forward declaration
and gating for mm/cma.h content included in mm/memcontrol.c.

I queued this up for a v2, with the other issues reported by Sashiko.

> 
> >  Documentation/admin-guide/cgroup-v2.rst         |  35 +++
> >  include/linux/cgroup-defs.h                     |   5 +
> >  include/linux/cma.h                             |   4 +-
> >  include/linux/memcontrol.h                      |  19 ++
> >  kernel/cgroup/cgroup.c                          |  15 +-
> >  mm/cma.c                                        |  14 +-
> >  mm/cma.h                                        |   6 +
> >  mm/cma_debug.c                                  |   1 -
> >  mm/cma_sysfs.c                                  |   1 -
> >  mm/memcontrol.c                                 | 205 ++++++++++++
> >  tools/testing/selftests/cgroup/.gitignore       |   1 +
> >  tools/testing/selftests/cgroup/Makefile         |   2 +
> >  tools/testing/selftests/cgroup/config           |   5 +
> >  tools/testing/selftests/cgroup/test_cma_memcg.c | 402 ++++++++++++++++++++++++
> >  tools/testing/selftests/cgroup/vmtest-memcg.sh  | 197 ++++++++++++
> >  15 files changed, 903 insertions(+), 9 deletions(-)
> > ---
> > base-commit: 98f21c54f99519329c18e2625b0ea6db14524d09
> > change-id: 20260706-cma-memcg-regions-696cb5ef7998
> > 
> > Best regards,
> > -- 
> > Eric Chanudet <echanude@redhat.com>
> > 
> 
> -- 
> Sincerely yours,
> Mike.
> 

-- 
Eric Chanudet


