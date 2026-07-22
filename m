Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89600C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 13:43:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BA106B0088; Wed, 22 Jul 2026 09:43:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770EE6B008A; Wed, 22 Jul 2026 09:43:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65AC56B008C; Wed, 22 Jul 2026 09:43:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 32A156B0088
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:43:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B86A0A01A8
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:43:29 +0000 (UTC)
X-FDA: 85016529738.07.7751339
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id DE1D5100006
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:43:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pCwtW69g;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784727807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wqGzltcyJPxwfdEhPSjMSETzXly+gOy2t1lReGVE8tY=;
	b=dNdLQXjDN3vN00+KSygJchhXRuCDB6Vf0xRllnbhDPsxG2C16iNpihDG3wSaOWIT87qMh2
	ANmcXqClegkvC7GgDC+YqmwtkN6LdTALvz9DuRb8kYPjSfKGyAWGLWWPZiklL5E7MtV5HQ
	M7GWkulcjIN7PVrUOFbFTQ0CX57r96I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784727807;
	b=wCf9Hcl2XN97CrB/CPo+PMUI829AozF3EWbEH6MfhelBs7nrgk/bZu6cc3L3OQewFWDGjH
	3vccrQR2110YtUZY0kN0lECxPcp25aJF+i1GmKtBM1jokLES4RTlvBQkybw3i5M3IsCDBm
	MN17Wlm+oMvuDLoAzYcj+EmZdJYDc5E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pCwtW69g;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c0c45c580so108276281cf.0
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784727807; x=1785332607; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wqGzltcyJPxwfdEhPSjMSETzXly+gOy2t1lReGVE8tY=;
        b=pCwtW69gTeADyU4hllEPBf/S6vArQpKreYPOba8LcqMkpSC2EFIC7aNLC6PrRF9hqj
         5aIB6ZmNMvv8V6roWDerWSbT+psVo4D+fCKiSGPDDnsej4ZAEE7X3dPkFfPmRvjTBXEB
         ySLDSLu/cDrxCAb7tNvxit4r3E8+Sj/X1uW5rhc9/AEwgAPEMroxIICoNSTDyVoVF9v6
         jgDu9AulUcrR9pMkNR/f7G0nvk/FtZc55Ggs4ErF9OXr8M+2KtnEHZp6vIm2Cbzraraj
         iKX1ls34WpGtAve4LYtx92qlB6PSlzavmQVHqcM4C71drReggj7pPPkrhxcVxsA4qQq/
         B0WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784727807; x=1785332607;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wqGzltcyJPxwfdEhPSjMSETzXly+gOy2t1lReGVE8tY=;
        b=NiGYK39tGMSpR/xAQVHrVESiHlcs5RiK1jWYflbTqg5Wm6lA/vazJixJL0T58ua1E6
         dFx3tZ8uWfZsz5og291gwKBJaSOM17lIZsdmdgoP/REx6vhHuldm5k6HvYkd2p6obIMV
         tVBJYkYoWHf8++9scGqVCsRXoGdIoRHYKv/VWsM2u1J2RmQq9aKh4JkwBt+cCxurTQxp
         b4C562/p9HsezZwLq9JK2j8Ftlfe35BbB4+q38M6lG1JnQ3lsSthsTO1/DYaRp+6g7Xa
         MvHOjht53c48QiqOmEvQMwDfIIRzO/DYZqY/b1AKm4HS/2i4yU0EoVwlCI2f1HnTWVrm
         bUEw==
X-Gm-Message-State: AOJu0YwR89wT/VdQdrpWLgckDC4FLc7pefYKHy3z7h39eVKC2HzCmnKW
	X0MLKFiTnO1s6vO4EZSRGf7gpOWN8G4XpgqcRDNStkDG6vHSsvsOso7Tv2j2bFbL/pM=
X-Gm-Gg: AR+sD11mjSAUaVX/D5y+Sk633cuzvLWQOiQ8knh7gN+lFSNb0yCISgeMb1wbfcN+Z7n
	iajydbou7qCTv+3Ia1C3JoXE2iSvYW7s7I91UZulEixIDWXG+7N9xOLI0dGtoZ+2GGP6fB5TDsz
	RiztU8flOf6Kh3UBQdeeFJyCai3s68YFKT5ZXULnfOgZL8J8idSGnYlb8PzfJTkisMgTmWw1wal
	1CJL2UgVA7scO633i+Wavf3qpSZ0w2aH/oXET/5LvtiSB5YjsjENsghfd8Bt/RshSUOWf0vQ0NK
	dTle0z1r1S1n0HqHyhbhaJ2AD1rqs/dbqsRE9CgQQeGLMlNP2l3mq7juIy4cv675Ur0q2foTtnq
	MMzCMljMgJ7AJMhIRjx7jZ1gvnu4sgqoZr5+KIEesq7UFySm3sJsXE09q5rvLFUBQiVVJIFX2+j
	Emh4vOBXKaSkH3fkmKxGK5d73AoZHqjLFpCVHU6crc1cRXXT990E45vXXUUxbMdp3QMHhI
X-Received: by 2002:a05:622a:1f91:b0:516:e152:7a59 with SMTP id d75a77b69052e-5213e08256bmr218014961cf.42.1784727806950;
        Wed, 22 Jul 2026 06:43:26 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-527d3b3f66dsm15332181cf.27.2026.07.22.06.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 06:43:26 -0700 (PDT)
Date: Wed, 22 Jul 2026 09:43:21 -0400
From: Gregory Price <gourry@gourry.net>
To: Richard Cheng <icheng@nvidia.com>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com, 
	balbirs@nvidia.com, brendan.jackman@linux.dev, yuzenghui@huawei.com, 
	apopple@nvidia.com, alucerop@amd.com, matthew.brost@intel.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	corbet@lwn.net, skhan@linuxfoundation.org, gregkh@linuxfoundation.org, 
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com, 
	dave.jiang@intel.com, alison.schofield@intel.com, osandov@osandov.com, 
	jannh@google.com, pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, 
	peterx@redhat.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 32/36] mm/khugepaged: base private node collapse
 eligiblity on actor/cap bits
Message-ID: <amDIuZSsOPjRkywY@gourry-fedora-PF4VCD3F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-33-gourry@gourry.net>
 <amDEEnTv0QumcDJn@MWDK4CY14F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amDEEnTv0QumcDJn@MWDK4CY14F>
X-Rspamd-Queue-Id: DE1D5100006
X-Stat-Signature: dhzfy6o9tfnafq7jkpktj3zrjdbn4bz6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784727807-732048
X-HE-Meta: U2FsdGVkX18of0EJGwupTDUo9/JQ9oueXqBNWLtcdD8xw2l6sXc1oBBHoeND3uxRjC7JKHDq39l3DVJhyzgut1Bl3xc38CDaw+kSMbn5QcZz/6OBOPDBP3IxwGnKukYXpVFO0kxCbXkbFzxrsgAjK3Q+fsYe50QZ+Z4eULxaoxwUgpKKFalIkOjK+TtFMOBewIcFQaMKVdiZq37si9Iali2dU6exI8pVGRqjp1wA5DpFz2vl3IffM3+a54zwnv9G8PmO4ZFbPGBMHjTS4Pe/3k5Lru8pz4CpIStQ6g+rgyQPKy+tHDjRgSzEY6nvZIn+po4u4mWGyTXUjgS7s3ASCT4EdIizyY8CDNEm4JIP8l85Cms6a2vQVEg7B//b1IKDu5tJ68sAo1W6GS8y3SPhaP1sg12ZUSyumdXnbGaPqAWIa9YVDpQ46eWi6QxBDXvEmkb+QgSyPrJMLJ2K+u6rDAtI3ZXDOWgC55F3n7gMbCELu5R6S075BU9mOP4escMwZrPTTuLlmQJgEzqRb2bt3W2IY6OeE/P4tQIhYX59clR0PjX35ecETHwOtdQ+1GBry3+cceF3IVm5Qa2JdLK9oLR7XGP3zV7VB+NPQ90cp/xz6yKHvkOU1qPYltcH0BFle7054UaZ7WCGUdBSYoNvZTgStnH9eKRCbdoZ4mAduuE/rME8k4nVXW3Z776RW6XsnkfHUS5ieXG5LdhHYKOuAEnARec9jZtZ+s/iIHm+P8iuXQbMQb1vliht7rPF1emjdaaXbtRMtK1gYnwb4TUuS/ZW2aNvn4ufZjYbqfPTlxDu6YB8tGe/gIIGePAq0gyVkVQU6OLPZc9hvKDe0VMyqyqmB0gnd/zTAL41zl7SGj6fUmK43/kg6Aab25tOslnovuKCKPYvkQaFrxn3HnGnClBVr4ileemUasYOIUL+IQ52wkbAd6H/EqYwWi/DQyXuOml80JFc6yY1/yrEUtX
 tE2bh3KI
 cVLjsre1mYxGa8JAF6rdx07rlgs/Nl672ddV1jQgaCQzSiVwHIJ7sWcYs5gGRPDOjnY7/+e4VvhqocAPSe9k8yGNKQLrgeAzeE55yostmvlhbo92sXEqFjaESAoAiK2E70PzHeFYI2E2yqgRruKq1qnHXcAKIKw43UgJqXtkHJdeJOhrOx3yJbdjxHP0uZsXjMu+XTFKGO0LJLPGetbbOiYKAW/UZUezeEnYiwUS8t03CrFq8WL7APPsRkCvlsC6eqEp4NRnHdRDBZ5LrK6MYQJ0GKLPTGFx0FVV23385ABRqJEM0je/zeX+SAWNg92WVPTh5XSijpa/LPZQAVP6rxmV2OdVajGo4Dyq/dl+eULtGdu26TvS+PseSwmAoh3uAEhtZuQ0cXs4o9Zmh6kTY/F5GBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 09:24:37PM +0800, Richard Cheng wrote:
> On Mon, Jul 20, 2026 at 03:34:26PM +0800, Gregory Price wrote:
> >  
> >  		page = vm_normal_page(vma, addr, pteval);
> > -		if (unlikely(!page) || unlikely(page_is_private_managed(page))) {
> > +		if (unlikely(!page) ||
> > +		    unlikely(!page_allows_collapse(page, cc->is_khugepaged))) {
> 
> I think collapse_scan_file() need something like folio_allows_collapse() check as well.
> 

I believe you are correct, sashiko up some stuff here too.

Thanks!
~Gregory

