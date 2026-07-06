Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FD3DC43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 17:30:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 143B36B00BA; Mon,  6 Jul 2026 13:30:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F5086B00BB; Mon,  6 Jul 2026 13:30:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00AFE6B00BD; Mon,  6 Jul 2026 13:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C66BE6B00BA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:30:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 48E771C141D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:30:16 +0000 (UTC)
X-FDA: 84959040432.06.A79AFDE
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6539214000A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:30:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=exOOQ2Lj;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783359014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T9PWYu0fUk83E8iTN6ucQI9VPyecYn/0QKDiHqXI4d0=;
	b=k5DS+t/pvb5KTa+vPvJS9FU/m7d8/Tp6iIFHGsiov46R2nKPSE1xVAn+50aYmovXd6BIu+
	BiDH4r8s7Ek0kEypPTNi4KAXCF7G49+JP99/W65WfYduBGMzuvSQpas0AMzSdQ2chkN7Io
	R3gfCqhsGdKkikKBBLHlpSYg8xhlBFQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=exOOQ2Lj;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783359014;
	b=g3qltpRqNbjBuxu5bWNyvYerVxTGmJqWHR/iR/hJeqJ8UXOrG7ioG/VoZK+fzSIXBVQ1/o
	rRyh1lfXYCAbj8RqPyIbKSq2z986c7E+57HrhnSW5XXTsB4Uex9FhV7tWc2BVlMc+94owI
	qiNh1ioojXWvPoBqn6RVAz+DbpUexxk=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92e7c6ec9dbso141954085a.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 10:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783359013; x=1783963813; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T9PWYu0fUk83E8iTN6ucQI9VPyecYn/0QKDiHqXI4d0=;
        b=exOOQ2LjvWNQU7dAomaR5E62PtVQbDcacUlFNdtxnzkpCJ2S+8DfKxknYcUFwfJurd
         04YbKxFvJ10n4JqFnCDN3zQJxYMlw1MktPxYaTUZ+H9UF5bxOFGVefcfUhXxmkFN60Eh
         nq+Ky4zydEeChmWpdvMI4lvaWhMSEtkXODAr20WgRqN0xxgDuC99WbEkcHpRrJd/2pGe
         ok9HyFtRd1d6G3U8CQUoSx7m2ZUzeyilqf+zikctjshZL3rvX0F0fcjAIEdxuNRvgi2a
         I9XSRbgf+oq5rUuS8PupPf/Z0h1i/iVuzgt3hZT+AsYN6iTh7oTfGLgg1EWFZe+IDpfO
         Z7Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783359013; x=1783963813;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T9PWYu0fUk83E8iTN6ucQI9VPyecYn/0QKDiHqXI4d0=;
        b=i6oWkbiY8XfRFzengUsgzfoouFyWlmWuotn+R6B8XAh9g0lUEbm+Vub2UXeZEI0zae
         7w1owwrkvcvtxtemAyto1TS1FQic/89CuuX034neqqJ6V+3IOBsP2WsKmY3f1xkOdXMY
         SVU7+JGObgCkphka24LUHpcM0TJDQbB4D2N9oxEmbfTU1QTPFDbdPrQs/nlF13epN07o
         1m6Nn8MMBaUbDEOyibpFE+p1kwJg5fO1XINeskF7ux3B3gTlaKWqjvu9Iu9E1/+SXUGq
         oQ+ddzWLKbN5ZXsOkclpeIBW6u6gdn3qcEKSWl567bQqOz35VpQdo0mdxsp8tMndd13L
         rGBw==
X-Forwarded-Encrypted: i=1; AHgh+Roivc32uIb6EDdaHUEHTITljotl1n8Reyyy5+PamVQk5cyTpEjaXVNW7N4PwDZhqpmp/aw/xVRu4Q==@kvack.org
X-Gm-Message-State: AOJu0YxZUg6pM7As+wMf7e3PYzms0zm1QtvMsPkleGQUYIyv/+RA0xKq
	qL/JMGd4MMLLDjSbdhzK59yF0dqQAt2ua2A2XdKjUkSOVueQvSKiAcXNgDG+4tlKn9I=
X-Gm-Gg: AfdE7clnrI2KXkNfqCnEy/JNDRHFnRREhCnXu98gSLrml9QmYMX6konv3eAqPevi1Yw
	DpjLqZ6yHrY6k7pwPHptYW6Hp9Bti2yaBwFgELTjFN+CMMq9FN+df8vliHGKNNjmviEiAC4hoAG
	mpyzI0NyrtVRVFf89pIJbfdrWBYx6+CouZuPCA6aCWTuGy6cCUqJpMCeuYI4EnvuNpikupfCd+0
	QElqzys4BPmPzOlG8PybiYw+wQkDT23bA9UH+SlnzlAgYBNqcWHEwigLO+tdLTzr+dm1GG73G/y
	vb0VxNfuKnk+p90zPZrXhS0k6uKb3Y5pYHdBPoXbnNP7FC6KOOVnRtkqDJ7YVZei+qOxtgefrES
	jl3W2el+VDuuXsnXaJTx4YBeDyb8oKW/m402pCSPBTeokXkxo5AT11w3i9k6FRdLiRTsvy4ZVZv
	PFzDIkBxGa51ir6jjwKujaYagbcKC/vQdfM/EoaAVwZ4PDijO7fWUPocqpQqWyBDy+YTb9
X-Received: by 2002:a05:620a:4552:b0:916:467:558f with SMTP id af79cd13be357-92ebb4e3ad8mr220189485a.16.1783359013000;
        Mon, 06 Jul 2026 10:30:13 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e90b800ccsm987969085a.8.2026.07.06.10.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 10:30:12 -0700 (PDT)
Date: Mon, 6 Jul 2026 13:30:08 -0400
From: Gregory Price <gourry@gourry.net>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Neha Gholkar <nehagholkar@gmail.com>
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
Message-ID: <akvmIILwRsU9mUfk@gourry-fedora-PF4VCD3F>
References: <20260629163337.1264881-1-hannes@cmpxchg.org>
 <akKyjUbFg6ETqUao@gourry-fedora-PF4VCD3F>
 <87h5mkz33h.fsf@DESKTOP-5N7EMDA>
 <akPg4ANRetbjSP_b@gourry-fedora-PF4VCD3F>
 <877bnfynsr.fsf@DESKTOP-5N7EMDA>
 <akUzUqQG185XHqgL@gourry-fedora-PF4VCD3F>
 <87y0fonyrm.fsf@DESKTOP-5N7EMDA>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y0fonyrm.fsf@DESKTOP-5N7EMDA>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6539214000A
X-Stat-Signature: 3kdg8mp85swyo3adtiesehjxxutuaayj
X-HE-Tag: 1783359014-212117
X-HE-Meta: U2FsdGVkX1+oNhxDeapFsVpt2CXyGDXpS3SeRVNzQEk3XchDOpTkQ/bZZiCz7vvznqSzfgxvpR33cBYMUuHP+to6jCMmnABFftsz7Rs0NMFYYmA/EvLT8sOzxhl3Jd/H8vsHhDtgo9UUnxtyooJS146qmD36Nr4Ap9WRqf0SeSoYhHpeaULw4jqnFS65qhvX+eCkTod+mVlLRqk7WaGWNaF0UVfjPxMAgZt6rbGqjAN1iZfrxVYYQBu+n6UAVGjlK8aUTAer3QkToIH8LOOs7RCTYChFbPjT7KINQYkVJ2xPPSc1Ypg/u2xIol4ay5eE1TyhwlcUbYBA+Xi1AWo2Dn7I0ypOBUpZZ+I8RIM5e5Ejfaqu5wcTJq1YRmrXvIlZMbDzYyHAL5/3/P/MXP0KmGEKA4YTGEQ7weE5IFrlV/lFvpiZLLHIdvVsIwI7F06WDH6ENLkifSICozHTVdlc9ttfc3mwSiiPAJGIv8vERInN0FuxE2rCXDICd+CulQrLgfECdS8UsKU44urE1QNrXemRpKrHAnWEO1KhspyFAzpvuf/+QVom3o6pR/x82aLRqNaByXDAu+gyxZMRgLW4qUEkj1Oqd4J/FNFt+kKwQf0wlcPStT3e1gRQY1fXoNeTUSKDJlGo2UcmfC7h2CFmXcpIJciTc/BB+i/oUGeaQR4kf3l8gH2szpIqLhEevCtT759mlxMAZqcwJZoIeMmjNN3T5ek2gVYb41YRMxZiKrnDfOW1lKFHDnAr54As4YbpIupcAQY4OmwDRwQ4niviLtIkMaL2bMGqOM9MnpzZdB6cHzsUb+61ulXiEsFgGQJGu88VFt5L6CvRuhupWpyIWvmVmIzK2zZZBffufqhqNB1eyzEWlQdqIMkbbPAEG68nJhLdYny3Lw6qdenx6KMQtTH1ZF4Udlr26rCE//2oGXQGakAm41znDchqvZ8GXQ+GhCDyP7XaaMmKiZ2xZA/
 bApD5TX/
 NQW6OSzbHi9SEr3kM9uVChSyH3Z3giyjg0A6rflUzMrBl/da6OHlGgFj6VfZV4+5f6t0NX45W+Pfw+jxRfzUJfcmARh1+WHLxYSOA1pAGo970IoKloLeK1RPvbCe3uneBJ5pVZ2iuRLf+CsBpYo5FYqFzFUGb0HpyoMb3P1wv4q1mafg/cgOkdzl33L4L/DJPgtHqCHb70/Nmg8WUjf/H0Cq/L8WUR7LxC1DcFS9deYgm8fKOAfS+F8E18qnuDKSY4gYpLhm3D05Yrb+lqo3xBfCTKXQlFvw9xLa4cU9gplwDvMt5gNVSKmbDt9Dy+WBK2oPP2iiQUmmOHDbk/yy074nJxjvIxx8KFgfbtJvTob09BfcbSNEYujdNnyZpQ80SyWp7EGyeXuCQYPCFV/WoG67C4EXeskEFakcMTSO8tZtk+ZuO4tMoFqnsNPuNRHH/DsCG1HcpgQKKqolIrDRgm99pQENjlmrTgWVK0SfTP44mKEU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 07:27:57PM +0800, Huang, Ying wrote:
> >
> > I considered proposing MPOL_F_MOVABLE_ONLY to mean (roughly) "userland
> > memory only" - and then slowly trying to migrate numactl to make this
> > the default.
> 
> What is the right mempolicy for these random kernel allocations?  If the
> pages are used privately by the task (not the case in your example, but
> is it possible?), is it OK to use the mempolicy of the task?  If the
> pages are shared, what is the correct mempolicy?  Will it be fixed?  Or
> can we find a way to change the policy?
> 

I submitted a recommendation[1], but I think it got swalled by the kvack
outage, i'll probably need to re-send.

At the very least, these allocations should just use the system default
(local node) instead of the task.

I left the page-cache affected by this (so inode data DOES follow this)
but after some testing I found this amounts to around ~0.4% of total
memory usage when you have many small files (~64kb files, 512GB cached).

I think we can probably drop the first commit and just ship the second.

The fun result - when you combine this fix + private nodes [2] you can
reliably hotplug a private node in ZONE_NORMAL so long as all tasks that
were using the private node were reaped prior to hotplug.

This is a legitimately useful improvement in my opinion.

~Gregory

[1] https://lore.kernel.org/all/20260701222112.2820098-1-gourry@gourry.net/
[2] https://lore.kernel.org/all/20260222084842.1824063-1-gourry@gourry.net/

