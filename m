Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FA04C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 12:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0406D6B0093; Wed,  9 Sep 2026 08:27:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 016BD6B0095; Wed,  9 Sep 2026 08:27:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23646B0096; Wed,  9 Sep 2026 08:27:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C10346B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:27:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0F9CB401A1
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:27:41 +0000 (UTC)
X-FDA: 85194149922.21.1DACE19
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3BEA4180002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:27:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VrFzRZe6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788956859;
	b=dz1V2EZHt3js59EmCDBVIivSUdVvhcQA1NHukDw+RFfitbW4bcRp+E8tcweb8WjaiMVsob
	DjQ2+pmcM6t/5t4YbMwTncckTSyFfct2NXgM/mbBLJl3qhtPZy5nJeI0gNDKU6WKBFCHaf
	QpdKmS3j42dS3aLsE2RaqHlY/1Is8Dc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VrFzRZe6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788956859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fNb37xWCW/T188cHOe2lrBK44SN8Frxj8JBix8SU6qI=;
	b=J8/lc2pOSBDimxU0wDV8BxX55X+QOduNxiRIZpFqnnKy65QnqdxBaCL9muy6IxpXBNxhCu
	xVHA5Ra+mR9vp7K9osvYL2bcLvsbAFvnx8fawfCTvfe5bYL1vyW576vrtQkvZOlgnM9xnE
	vrVTk2MJFlaYhWk/fVvFk7lVrUL6lVo=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4858303de5dso7004049f8f.2
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 05:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788956858; x=1789561658; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fNb37xWCW/T188cHOe2lrBK44SN8Frxj8JBix8SU6qI=;
        b=VrFzRZe6aRQdEeuh/HD/PZGmf2bbHfc+t7oihBGZOkgcS99FxgLee+cfDJvwDVKsG2
         RbMQiftBxuyBWi7sQua2Keu6unOHv3XaNji7y0yStOiE0R1BRCkHGhoEJy2lnwwukCd7
         s9WeEOYwwWOIFkTTm2qOyIY6BRbWiESEU6mNtMTPj/7A1q2MCEOecA7jo1OSrsA+kCBV
         698XSDiM/fBSnFLRymWDSfhtHyWHJrJLYYyG3TWf1NafOt7KKmEaWph3esYIpyPJyD7L
         0lmAti6HdHEYhAXnVJRpA+cug4/MRZeChpf5+3ksGXmp0+71ziPLunML5XJc93+4l0nl
         Wv7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788956858; x=1789561658;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fNb37xWCW/T188cHOe2lrBK44SN8Frxj8JBix8SU6qI=;
        b=tBClh4inWIC7hgeZEXGWFxGifal+VmQLgwoSqrnDxhaT52ZOx4H4cb6d+DoGCAlzQC
         jopWu1rG7QWDZ5Hc57aAC7ewe70vLNt5RT0pgnTGLYt6dyxEzijGyUehwT4mus8pptcM
         jX1UnQ6x8EWr+2DYbBumNsEsm9fzoHu0eXoNpFCTD7YNFieecjyFdrQf9k4Ue09zqnpr
         B5E6BuwZU2k+O68k0qRu6qviHTJvTDqOjT4bUVhiXbEJQ0XoOlAYYStYJFnBXUHCbOye
         JNC4ys+fHZY5c3qvV1fcUKJLyOtXoB3Ck4uHzIxBtr6lX9VwW53jb69KiaRITl+ckcpD
         iuLQ==
X-Forwarded-Encrypted: i=1; AKwUvBya8pSMCgayTsAwZfmIbRMRO+Twr3WJTnmPJ2EQbOeU8iiYE2weknJI5754cklWkCn6ObVAAldvMg==@kvack.org
X-Gm-Message-State: AFuF++nGd6FTWoxUKw4E0fsUeLH7GRboKDbIB9Kt25a3+wKBtPqI3ZIF
	VE6t3y9YPyUK8GCsgrn0z9QCyBOAeSjfXAbfdBcUREk9ugcESKAyYwc9
X-Gm-Gg: AYBFou3L5RboiipivgHGnaqOgjBXfRt0szyPOL/SAjze7qln2IcEyBRTgm/6ib6Fe6i
	yRfnswGrtf6eSMWbUJ94V4FmVGykwDh7DhCSAbXISEA8byZv08PTUbF0ssTAVXs8khAo/DpRAvZ
	jqbAolQ9Z20n/v7pv9eLaxV1vZYXJLHdeIzdN+dw9MB+6h/YWzkaFPyeBIIE8SvuEZbxUpUUnP3
	bR18nVBI9x18JfKcLEz9D3po48bgRNn+zkhk2NySlrt7c1vz3iHpG52AoA8XDCm69WT9sDXTPyp
	SGLq6ZoaZ6z52zqQDF4AtznslTqUwxliBUSc4bP8R312CMOJ84QTCv8D0D/jmSCMpRS84gJ8YkT
	1FSHB4Z+pzRg3mLoUG/lxRItaSCZEVYMEHmIPbApsGNVwMQ0c/nycanNVivbq5+/bP/D9Z4Scnd
	gJ9W8jsNtvjzOV3VTA/diJzsQkLqwAQ4u1QmzuJCf+iHNPrF7+HKO+/eo3G/F9Dy8WGtMy9UDOt
	8dj2pxm4eepAebZAOd7XxJ4juXLLVUCJybE
X-Received: by 2002:a05:6000:715:b0:485:8c16:a343 with SMTP id ffacd0b85a97d-4858c16a5e3mr30064053f8f.56.1788956857427;
        Wed, 09 Sep 2026 05:27:37 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858bc74298sm39687472f8f.6.2026.09.09.05.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 05:27:36 -0700 (PDT)
Date: Wed, 9 Sep 2026 13:27:35 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Nimrod Oren
 <noren@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev
 Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau
 <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <brendan.jackman@linux.dev>, Hugh Dickins <hughd@google.com>, Nirmoy Das
 <nirmoyd@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Message-ID: <20260909132735.1fc1a309@pumpkin>
In-Reply-To: <aqFAOLrybtyo6dd1@gremlin>
References: <20260901190123.3511535-1-noren@nvidia.com>
	<d202dcc3-d7d7-4e98-a9a5-3137cfbfd041@kernel.org>
	<DL9XL8T6UG93.1T1NSJMI8PISK@nvidia.com>
	<aqBiVp405v2srvSa@cmpxchg.org>
	<aqEUdmYnnQQRC8yl@gremlin>
	<20260909113836.6cbe8d17@pumpkin>
	<aqFAOLrybtyo6dd1@gremlin>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3BEA4180002
X-Stat-Signature: 9y1g41req1nik9o1hje7ajhuwmf9aacd
X-HE-Tag: 1788956859-603461
X-HE-Meta: U2FsdGVkX18YQaZyvWY0tKd6MnOwAnT2syvE/zTYIjscx5j4k+KR/LxEL3G/zeDmhxaz6QjWcaqewba/yoKv3R5+jGjJgnVYrpjYN4+ykvRRFGqiHprl3j3XkXSMJ4PrMlxpIpmQg/ZTVzFN+SHwwt+m7bd2NLnf6qlaszkNimuOzQO6Js3SkCGukh3o7OIT64PIjkqdWFSIKSPre0s86Viu7PazjeYSkGk9uDNAXSaomWIMfHo21VzFKTv7VBLsH5FwSYM3ctHusldS3wvFcDkEG11+k8FBI20hfYHN5g1MeaA5cckclDFDfelOHyezGY/yL8Kz416YfASA373CVjK0G02xib90d/FNsrrgroGOd730QN2+6v/Dmcn0ESxTHkvB2SZYzdDEo9L1R0NhtnordzXDuWjlQB2HZx3uc41rCfMjsPq/n/D3Od9Q4pA3Jqn/a+44cSjTJy54zX2wimoGNTP218y7iUu5Pg+3z0m3acHLN9U1QvrZQMtofZ6AqG7NbHI0YvAHJsxRMfMd/luuaS/VtBzzF/xQLJLL7cdoi0lsjP68v37tq8ReiWfAy+l1UZnTqmDQQ6ObwvXmnYY4tRH5JVCYvxHJURegZ4mSnrckfWubiRSnGvR7ZV2+aYOpv920WbnPXIohe5vW7DrD0/gZJRYsRQXwCFBf6mJ811eBknYHY3Oka8mDoz7t99juYYyaC12FI7NrV0PzgnndSMbP/6mP3gepNo43k0PMNCF3JxlelO0jfW9hSPLnxLVRhWLXt1qjMPbe2d9smrQcc11pz61qIpFDd1VDD2HWZYxiJfZi+f5nUd6julm5D/3lyDl68V0siJp8niGwftcyFnLR4/MOoGjAZGo3/T+3QKoftC1ogwqK3zkQ5e/O0BazgeIyTxJ9opZSu8V/aDi4qGNPdTJy/Zjj7fAYp79PPc/4jxJYc2mdZLgpAq258qKDqE8fpxKydAhAdoL
 sMebmPcU
 uuL1FFV2IM1+xCxSlej+7SdwAoeCbcl1WTvT2WLhSV24SfGQo2X6UqpjiiPFd9aNOelRPNxtCW38VX76AEfZu8CEP8/C78MDUZ5EQQmSz8V/+VFHGZpl0I/SRgDVmwRDP5dkO/X1dRoNLtKhgkekSxrhcV6qTeIfu5ZDuTe6uutizgGbHsnqd90KmzPLLwkjcjk7usszTDpCgdQ9TMiKe5plY24yAySEE8kxjX9fqwjMZkxZpjzF74HBZ562AFkEEfW0VsOvf4lbr/zmRYE8yoyXFXBsharlxaJWJhqOtGm8GAUosIAUxLhX64MC2d+t1TB1L7WiAPboKHsXSVG2NeGXeGyfmclFWD2BEbSo3+yFyZ1tH/w45Qn/5T7LEBpdi/YbwYXkdGyPTcCegFtJTEAQOy68cfiSOtc+6CbEPEzE+lL148JYjdCHRLfTz7qp/o1O2h1w9fCWG/ujaqTXcstorclmWnchTgLupFpdEal0Fbj06Ae3LIDTbw/fkgKxLM3pg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 9 Sep 2026 12:18:03 +0100
"Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> On Wed, Sep 09, 2026 at 11:38:36AM +0100, David Laight wrote:
> > On Wed, 9 Sep 2026 09:11:04 +0100
> > "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> >  
> > > On Tue, Sep 08, 2026 at 03:30:30PM -0400, Johannes Weiner wrote:  
> > > > On Tue, Sep 08, 2026 at 08:24:38AM -0400, Zi Yan wrote:  
> > > > > On Tue Sep 8, 2026 at 7:54 AM EDT, Vlastimil Babka (SUSE) wrote:  
> > > > > > Given neither of the patchset versions achieved universal acceptance, could
> > > > > > we try just disabling all the automatic (re)calculations of min_free_kbytes
> > > > > > the first moment the sysctl gets adjusted from userspace?  
> > > > >
> > > > > Sounds good to me. Johannes, WDYT?  
> > > >
> > > > +1 That sounds good to me as well.  
> > >
> > > Me also! :>)  
> >
> > You might want some method of restoring the default behaviour.
> > Maybe setting to 0 can be used (if that is just silly).  
> 
> I suppose the concern would be an embedded user for some reason enabling
> CONFIG_TRANSPARENT_HUGEPAGE and then defaulting to THP ->madvise and getting the
> bigger reserves before somehow disabling it after boot.

Or just testing whether it makes any difference to a workload.

David

> 
> But I'm not sure if this is something we really need to worry about?
> 
> >
> > David
> >  
> > >
> > > --
> > > Cheers, Lorenzo
> > >  
> >  
> 
> --
> Cheers, Lorenzo


