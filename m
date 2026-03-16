Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06557F53D90
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 19:45:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE5B6B00CD; Mon, 16 Mar 2026 15:45:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 661B96B00CF; Mon, 16 Mar 2026 15:45:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56E506B00D0; Mon, 16 Mar 2026 15:45:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 442656B00CD
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:45:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0AF9EB997F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:45:30 +0000 (UTC)
X-FDA: 84552955620.12.08729A1
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id 286A114000E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:45:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dciv05UM;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773690328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qruEfGCCxBMe/+AzGeTxCnKPyDw9xbJgeNI3pnvogwc=;
	b=d5aXe8LGUpRkMsOSQ5JO/4azk5Y5TMecoHyGS7Qk1DWg4btH7z9KIpv8WAXWClbHorKmxb
	u8vp2or8LmRg0SXXmbeXE2mO+SD+PF9dHSiNLzSC2/AaJ60oWHdIZKyzND13jg3y3NPazB
	KvNdeBfknF14toweQiOjQYDZUBTuHvg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773690328; a=rsa-sha256;
	cv=none;
	b=MSMeCgolTvG24Dwkb2+LpmiNMumx8LnUOC0AhhqXNrVCGltOaATlkA6JliN8nV92u0dgMl
	jiQ3Mq6Run6l4Mww2wqCAQDF17JDHNuJwTQ+QWI7A9eh7WlO+ptL7o2qhnBBNw2ujSb6QY
	TjfMK5JXV6rmvZTp8UjgYS8wip1pawA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dciv05UM;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8cb4136d865so666060885a.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1773690327; x=1774295127; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qruEfGCCxBMe/+AzGeTxCnKPyDw9xbJgeNI3pnvogwc=;
        b=dciv05UMsUUUYO+cUGS2OtTv7o5k8w0Tqx870LsPmNH4vGyg4hFC3NiZbIEcQVM3OH
         1kStckC3fcDDVgTRuZG0SoflBHJKI3vIq0Q/4EiTqYUPvBCksDGl8xfurB+WOR/11ER2
         6cXdbPDpuBDkNfSEw6P3bUMc+oXt/4HNeedrcLy7eKFFPioWQ30L6N9zF00yIvLXWInS
         SXPEFpE/Nz9Z195/ii0doxGQCYMx1urPFPQS84H0Yi7mI76JPDVCGhAcLSECI5nMiIbk
         NcTjekqYV1kFXhZA4emgoM3xEy3p0GF6s4nbduEN27l8roZBWHHyewZAdxNnv6rE23Fi
         ve+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773690327; x=1774295127;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qruEfGCCxBMe/+AzGeTxCnKPyDw9xbJgeNI3pnvogwc=;
        b=odGYxncvGL1DIWZTibILtk1OAyKPJTYgAuMZQAXDyIUgIM2CYrpPCEnQst2pfiGx3a
         tvjrySx9dxcV9PmRgxGgZ4b8GbudAWCZcPUi0WvUqBT4zE7ECymEGE5z+sa/xK5f4mB/
         OjXMdkWvnJbBAxGsDvfKDZoNMblOydr/ZdWFOJd9HgQ3HN9Dc0+z6fW/yaPjE2rSCsy8
         ZlWhOmPfklF0CgFRTX1BpFKs6dAgiBQQ0SjHGjqEJ83b0jcZ2VPx5F5u512QAkrAGe8v
         JQ1jK50MTm1JWSPQE0yvmR5B8Viz3z8P5DuD6+1Fw4xXYmDL9v4mb1+sRPxwho/qxP7o
         f5fg==
X-Forwarded-Encrypted: i=1; AJvYcCUn0Y/fLPyekAQwtfmHr8X3n5YgDpAJC/gqOpZkEhc4v8hEoYJTe3zEQwryBVVnBC0eZxnkKqPrSA==@kvack.org
X-Gm-Message-State: AOJu0YzFkAV8Pr8AoL5iNAT3Jv0auXkw5l1dXR7LBIeUkZWkwM9waRbo
	9Lz30+X3KKzbmzSx09zXM8i3nKM23NLmR99qksa2nIW8Kij/20jWEy8ntqIInRxgz3c=
X-Gm-Gg: ATEYQzzVlPz/R5uAdlNORK0JI9hemiKZj1hfeiQSPMsEZCJK/bm/Nbwyx7OrsYIhGsJ
	BKWUjWNest2oV98LuY+BhynpEssQu6YIbK+NFpB+sx6iHVixJYw0DPLWL3Tryerl6udZEznkPBE
	ziwJ0fcvaOPc1f3yjJgASAZSC2/xkqBg8+xpci2SO8KW25Ny+MfN4T1sIwNzp3imdETNM22g0sU
	LZTZSTIDIFlwFODi35CMrTXosFH7fBaYzToIIB/MIrbDLhRGCtr3ODwAJo9X8e7lQS012MEvxON
	RfhAKy9d4uij/ts+oYLLYnhtlHoYDrq/D/MS1SKfQvFPanGJPo+TPTnvpyMawMPddSts1+H+dKI
	f3MPTIdovF8kQme0zip8T+tpKERdHHGRmGyPXCRmYxKtdUqRkbS8qsHABsRAWu+5ck1qlPDHj0L
	T4EqbNk3WUORM0eQ6dWEPBbxTpA7m4yqE5xAqbu/LAHkw7Pxmd/09qEQMq1q4dfptIW5xLteTFc
	Rn5SIsQWg==
X-Received: by 2002:a05:620a:4627:b0:8cd:94f9:1bb1 with SMTP id af79cd13be357-8cdb5a9729emr1904634185a.27.1773690326947;
        Mon, 16 Mar 2026 12:45:26 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cda1fe19d3sm1245799585a.19.2026.03.16.12.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 12:45:26 -0700 (PDT)
Date: Mon, 16 Mar 2026 15:45:24 -0400
From: Gregory Price <gourry@gourry.net>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, ziy@nvidia.com, matthew.brost@intel.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com,
	kernel_team@skhynix.com, honggyu.kim@sk.com, yunjeong.mun@sk.com
Subject: Re: [LSF/MM/BPF TOPIC] [RFC PATCH 0/4] mm/mempolicy: introduce
 socket-aware weighted interleave
Message-ID: <abhd1BXSST0BTDaN@gourry-fedora-PF4VCD3F>
References: <20260316051258.246-1-rakie.kim@sk.com>
 <20260316151933.3093626-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316151933.3093626-1-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 286A114000E
X-Stat-Signature: q3ga6pxghahzdzthtf5z4wzfxnmauq1f
X-Rspam-User: 
X-HE-Tag: 1773690328-899294
X-HE-Meta: U2FsdGVkX18Z9rF6F3BmGDWIOzpKp4IiLicK9w6sNCBUcsF8cMLTlZIA8sjZJnifig/JeS/4LgWgvO9nnEEMeXjMMfk1/08iRCujqTTZBdUeRB8RWu6kqFwEKhHbPZYWKjrz7J5XekRSXXrinzoxa3wJoNVq3Ez4xsb7HgXxb+x8g/PD8lJ5V+uuDqaE8h8aN5kb75xLyyts1dsn6ScV6J28EZkuXdSRNEbyWWBBdwtZBNRTRh6W9dnoIdQ6VH0Gk2Cu7BlN+NpGrmr9qWd/U4Xcee7tkv7MSHKb4X/0Jn3oklvXeocbPmZtacDr7/NiFlkOhOnev8grLvlzf0U7mk4zKZ6eJ8ntyiYmfOor9/+Dt8s6H7MOE5/sQuqNd7kzHPHe1QFTc6TWho11U9jaQqWUNrUKmsg5o3WVxP9MJ0A/R382jYG28xZcTHCzxHAl2S/DMeu4Jm15mR9hfCvXBE/SK7PcpbU3kwsGoCXdoQn2sLHRGtdaIETGADvB1k15+R77/CFVYzo1IU1sPLqePCx6Q6aapKcu75Pk62qBLtyY0lsSY/WDc1oXRbDqb8QA70CuX6mfhisvcvwdwllZ07o52nKfu2NnNDciAd1gTh7K/jdKyPIXMRGSozsBK63+6eqjmxMfRqg7K1NVBgdq/Kost0vzIRtHeEc/XeoAjrnglPC1LjzyfdmSzbTn/jOAaLQ084VxyhMBmUs7ecFGWuEGv1yXpQx9rD0ZConox38opJff1AIinh9LsPKdSpyeaJ0/b5zJCypZ0runYA5co/Yf7n67Oijb6S2HiR8OXKRWnbHwkKXMmht6Hw1yX/J5KODJ0eD9Lsw6t3EPJgRKi3+EFulF+r5UqRSArWLK6iqYcKoO7K/iA8Ft3EA+KhUA60xvfSCaQim/n9T8H0FfeJE9v9qJXb5g3e1+yDccPVnFpAqAMUVOouJ+VVKkT4meG59YBohLfMNJ9cuqGBc
 kILXAyrN
 65dRg84K/h2FlcfMhyVcgZqAT7jkV+LtkdkJYgvcvc9Mzl+PXPAY0XMIAbRf59cEa5wobmJruu+TOh9MTL6qVR3wYfsw6wSrARTQc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 08:19:32AM -0700, Joshua Hahn wrote:
> 
> In that sense I thought the word "prefer" was a bit confusing, since I
> thought it would mean that it would try to fulfill the alloactions
> from within a packet first, then fall back to remote packets if that
> failed. (Or maybe I am just misunderstanding your explanation. Please
> do let me know if that is the case : -) )
> 
> If what I understand is the case , I think this is the same thing as
> just restricting allocations to be socket-local. I also wonder if
> this idea applies to other mempolicies as well (i.e. unweighted interleave)
> 

I was thinking about this as well, and in my head i think you have to
consider a 2x2 situation

cpuset             |   multi-socket-cpu      single-socket-cpu
==================================================================
single-socket-mem  |     mem-package            mem-package
------------------------------------------------------------------
multi-socket-mem   |       global                 global
------------------------------------------------------------------

But I think this reduces to cpuset nodes dictates the weights used -
which should already be the case with the existing code.

I think you are right that we need to be very explicit about the
fallback semantics here - but that may just be a matter of dictating
whether the allocation falls back or prefers direct reclaim to push
pages out of their requested nodes.

~Gregory

