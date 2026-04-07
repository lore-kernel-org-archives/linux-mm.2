Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DE53FF512E
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 16:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A17EB6B0005; Tue,  7 Apr 2026 12:56:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8C36B0088; Tue,  7 Apr 2026 12:56:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B8836B0089; Tue,  7 Apr 2026 12:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7781A6B0005
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:56:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0A1DE1408B2
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 16:56:38 +0000 (UTC)
X-FDA: 84632363676.06.F9E8738
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id 282DFC0009
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 16:56:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Ak9969FD;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775580996; a=rsa-sha256;
	cv=none;
	b=5lkCXw4n8FBWyD/r3M6DoQDsKL4DMO8TUbww3k/Xmy+CGvRXW0xf9Lk34qnvFPvbgIMdh6
	1OjMSFkO1wsnoapwBuIGCa9NhbO3fWbXkTWBnez2qoOiXunHxCGi2j2P/tdIWuYH1j3gxc
	14enwq0cFLBxqUnVr4KsxB5NyXFxnLc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775580996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5H/LTMuHhHjt9i0cJQj2AuHwgZLtfBSzlCy+PjveH1U=;
	b=o4jV5JkQ7f3ge0owt1KF0kqUQcAjQQNP6FoporO+RKS3OO2O8WN51I7T8q/I+eVHVIQaIA
	CS0f5R1/ZMcpZsUUaoWmf8vTjpM+CoxzMWa3ciaIB6wzRVBg2traxDK109VFqUfzhPU6SQ
	NFNNS4l54r347JUbxmjzo+WnMWz5Glo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Ak9969FD;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8a016799d2cso69731116d6.1
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 09:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1775580995; x=1776185795; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5H/LTMuHhHjt9i0cJQj2AuHwgZLtfBSzlCy+PjveH1U=;
        b=Ak9969FDWDw16Rhucsts3llFvnw7YvCP3wR+Q6QOxQ6uYAThz6Vna40Eo43Uhnuiry
         fmQg/UhIQHJU00PxKD8Bd5Jt+m3ERbbMek58MIdD3dikOS9PYWfH8tGt2wqiPhtS1x9s
         W2IOOdQtfkoEYsI5sfF13QWLXGhKJkfssDNvvhnh0Gm/xAqqWuNHKaJXrLo0+GEFlpNv
         IMgtaytvGyLuaCEI5Oqq9p4ZTHA5+Cm9OD/qlLYrA0vbV9piWNGf8ndpVN8DTlcYUBFD
         3jNQ8r18d+mxdt2K1vcvZKb4+JK9XD/UwMuqJVQQ7aorj2sl4S3OA+gJ6QCcVrMGQBAe
         O0hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775580995; x=1776185795;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5H/LTMuHhHjt9i0cJQj2AuHwgZLtfBSzlCy+PjveH1U=;
        b=Glu6aXmrxg+RrTJx+q7h6k9E3L32bIlesF18B80zb6JN2SMeX1avLTpC/omrpsATuw
         RQ+GxbaRHpBKuQLWKvWBG43GBVAKggn8p+Dudbvu9uttUvgMY5QLvqiLklG1Lah+U2Po
         IOZ03XQudGYUFQeY5l0aouWfZch3cy+OkSmbZ9w2qNlCcHohtaubqA/t73EtAkRnh4yr
         prK1n58zQU+Bx4F+7HpXihGVUqckJpAN7x+jNasSaePeQBu0S8S1wOoeiSAhj3r4EYd3
         cIapMaALvxyGL9PGjixmUiRjbC00Y1wmRND77Id3p8OFnaHiuXB3BRrimch7RR4OZfgr
         3ReA==
X-Forwarded-Encrypted: i=1; AJvYcCWTQ6xG4FwUTX8iSY4WrPV1FYw1Rq5mpXBi4bqJ4EmHjLPg0EuM1QsnNrLGs4CK3DjDYWorEyacPQ==@kvack.org
X-Gm-Message-State: AOJu0YyeB70xh0J+fun3T2Ap7nr4WvFPS2UGAnHCL5UGZ6hk/yjlMAUT
	3OefrpRwHjOv4Es/+1llFufFE1lkkA1bDDdeYqzTs6+62Lo2XwlKbumV2hZ8qzixq+s=
X-Gm-Gg: AeBDievuO5DU9nEvndfbRzPBxbhmtlcY1KSHUMSy4YZPUpMxkt8Ea7474TfEkjAZhxy
	CtTNlhidAXyc2lO0/MVHjwdnpRH3GL+5nE/X7hJ38ApVVUln8mvDMIwyLHZJIgkUGBU7AQHtbYB
	jrqr9aoj8nimQaMYWnD+dTAM7eozDkO4ZasMqKDLL+/PV7VP92/SxuZr414Gn45hTO2vdGsoH5Y
	sAuVmJcZjvVzmi+6DBSVxWmLvhA19BXs5dnO7ML9qy7D1e8nANqu1xtZW7cSEQIRTepLF18xzaF
	D2XJ1tZOzK7h7sS0hBMF4PxRhgkhok4HmSVS7rpZ7zhmAAyiDz2q8QyTQb1GWlwUZ2EaGiFHe0p
	KPGSnD9dW1jyDiCp5WX4bATLWHhru8S2YqcoC6t9rwbFNof9Xu85nAUy+sonjArOuyrE5NNkbvC
	pzwtmAB7FoCRwhKLz70DRmkAxmwyYJfUhGzFK5dOMQnak1uIJCy+qlFmlUNWxXLxMxoRajt0epz
	6KH5saR1JqZskz9SjlL1cg=
X-Received: by 2002:a05:6214:4883:b0:89c:518b:9dbd with SMTP id 6a1803df08f44-8a704da7fe5mr324190956d6.46.1775580995082;
        Tue, 07 Apr 2026 09:56:35 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-243-150.washdc.fios.verizon.net. [71.191.243.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8a593bf4b0fsm154393106d6.15.2026.04.07.09.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 09:56:34 -0700 (PDT)
Date: Tue, 7 Apr 2026 12:56:31 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	lsf-pc@lists.linux-foundation.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kairui Song <ryncsn@gmail.com>,
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>,
	Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	wangzicheng <wangzicheng@honor.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <adU3P9fk8h-AmEp4@gourry-fedora-PF4VCD3F>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <42e26dbb-0180-4408-b8a8-be0cafb75ad9@lucifer.local>
 <acVPrEyfcE4Naz5b@gourry-fedora-PF4VCD3F>
 <248a126c-43e7-4320-b4bb-282e0b6da9c4@lucifer.local>
 <acbgIKuwDsPvPjdF@cmpxchg.org>
 <adTonuzmUc2AzUhp@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adTonuzmUc2AzUhp@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 282DFC0009
X-Stat-Signature: b4xyhcsekjbse9gg94iqqknughg7in8i
X-HE-Tag: 1775580995-818600
X-HE-Meta: U2FsdGVkX1987toqX2dBZ9Zp2gHiLmjUusMuKVTK7ANaM59hxo5S3r/RbxeD8uCblDJfS/x8a3jNc0bfH5fNcdFPBSIqhk45/j+b1o0xW6d2BtVYBv2JHyZjg+SL35VTRnnegnDQd+53c64oE6K/DqVrAgLFvzZz3PMv9J31qhU2DZEqYsBNMT/279OehZqA+6HstXZkGfX4IhjPoGsx77IJzITIBygwbaC1OH7aMB7Hou+l+f2mQaIw85vVnKuleeQ10+8xlmj8IeRQmW7LIIxw4ykfo9skOcJKu1Dl84ifMQaip6DB0n8ACztMJ0hY8CQ0dirtXhAQFDsN3Xwwq0SV0qufLbl946vnHdI48bo3c+aqKrpI5kt4a1ipFera3v+HzmN28yRW24VtT0KugGfCLa0M91J/BZxY4hYmFDNS456YtH6nhpihX8UJ4iTRXFxi+eP/x6B12hiU1qN8vG90wzqo8lo4aPWFnToSQb/ZxK1VdY4R/JL2cXthkrsDHIcGaWe3dMiuqep7bmMg6twflZ5/zfgfU7LUmvYTFzF2deuyTNsSvxXRJc6nm2oHClxBpciqg/FzDNHz3p4D65JkAiyPQveP/YWVyfCzdn1N/JquL4EsY4aBZnF2rg1CFIftF/Lx0yu8xU4W874reK9kWowG77QwJOYZkfnjogCBBGMYhrUXLjo9/Ldx4qc/lnGYnXoglsGn9kPsh4HoPD2QDEgLuKCFyvmKZib5Fx9X4k4pTM+mBaorSnrXtUVf8N9HGHAHp4KTybW0Iy57rHwb0dzO/nlAQJdhKiySb8unyGoDx3Bmr7sFSicWtYbA6wvKiTESFnzBi9nLUJ9maFSVu9CKmViF+HZ2u+9yhsxkp/msn85azZBmR0OzIaOxs6fz3hcH/Wa0qRfLDnQgqV8ge7beXH1S9CMFp4a2KfE4ng4XBQtlYQd7iF22+Xfe1rKokWMh4gfZvATHrm3
 YHjuz+fK
 Zzv+dDoF16NOeXDGT5x/pv+ZRgMgSbfo9aOTGd36fQVUuNaq5XG3wxnECwOv/AWL2YuovXB58+oECI1JDH5l1YFoMRtanzlwzYrxgDnaUwaNWtNozDE8Z56oc5ayG3U2HaLVeFXkxr0qLIkMuC5JHIkY2NlUVSarBJSgQozP8JZT8bs+2LCsYQBugVXa8rgJwuY1Fls8J4GumkOuAnmYZviB9zWCfXCbxwWVoxYGPtqRF0PQzakPoYF7ID3Mj6iRetbEgUOhe3Ul9cROAhJW/xCMJXdBdD6ykjmnCFk7TBM4MuGLtn1fCqGf8YezSHpVxtosdDbxfSUtq+iDxy6yHM1dHboir34/A3pWX9DCY6AwVw3REYRmw7HAIWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 12:36:36PM +0100, Lorenzo Stoakes wrote:
> >
> > And the current code structure makes it difficult to whittle down the
> > differences methodically.
> >
> > IMO modularization is the best path forward. Giving people the ability
> > to experiment with a la carte combinations of features would make it
> > much easier to actually production test and prove individual ideas.
> 

...

> 
> In a possibly, fantasy ideal world scenario *puffs on dream pipe*, it'd be
> amazing to somehow isolate the reclaim code in such a way that we could
> instrument it for testing purposes.
> 
> E.g. if it could be invoked from userland, or UML, or _something_ and then
> faked out to have a certain configuration of X NUMA nodes and Y GB of RAM
> with Z processes competing with total observability of what's happening in
> the algorithm that could allow for really robust controllable testing and
> regression tests, as well as possibly some form of fuzzing for broken
> reclaim scenarios.
> 
> *Puts dream pipe down*

*picks up the pipe*

At risk of being shot - this kind of stubbing / functional testing is
somewhat trivial work these days via <pick your favorite LLM> with
reasonably well designed interfaces.

   ( read: probably not with the current api n_n;; ).

So to get there, we'd need to agree on the refactor work and interfaces
that make it possible to model the scenarios outside a running kernel.

If we do actually want to move the core to look like:
  - vmscan.c  : core library
  - lru.c     : standard lru
  - mglru.c   : mglru

Might as well consider the functional testing question as well as we
decide what those interfaces look like anyway.

*throws the pipe into the bikeshed*

~Gregory

