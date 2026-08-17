Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94EE4C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:19:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95BAA6B0841; Mon, 17 Aug 2026 12:19:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9322A6B0845; Mon, 17 Aug 2026 12:19:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 847BF6B0846; Mon, 17 Aug 2026 12:19:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A5016B0841
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:19:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 866AC807DF
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:19:56 +0000 (UTC)
X-FDA: 85111272792.15.39D3132
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 83D09100009
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:19:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="AKLNfn/A";
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786983594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g79rp1EAN8LS02s21Qd/CfSeDeEXT49xOteHy0W5fBY=;
	b=h8N+csVSn3m92JeZp8rxfob8kQM/E0DqEBRQHPerPEoMs1qhsZkAKKBqo5ar70a5f4ZW0E
	K9mh6+BzyVkF5ZMC9MfUe5VwWxUGH8jOjRDn1gEJQb1Ee/it5OfpY7KC54Lnl6qnyA95Nd
	j504mLyNauE729NTCsigpehsjN12Ah0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="AKLNfn/A";
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786983594;
	b=ZpmSQOzlvHo6QMMC6vHyZph/W67LOzsagkg6rBjKaeslbY2QgKifenq6JeCw9Kki6DmiEB
	22JQMfEqq2ECnTjFbOAd3HJeigdoErHUSvUeP/2VC1Rsof+8wzxzTsyg5ABIL4i2l/UA1O
	zURh1REU6smzjLNoqzTyAbA9iT2PgmM=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92e6a434cabso168947485a.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786983593; x=1787588393; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g79rp1EAN8LS02s21Qd/CfSeDeEXT49xOteHy0W5fBY=;
        b=AKLNfn/AFxI5ShunItUL/ElBqxHySrGT7ARNxkyfNVQKNhw8Y78EKNOCuVKCgU3FIU
         /1JiUAqogw+M+E8bsQ2lQuC3ZxQFLg3BoVfjgN9ZtN/QmDWVW6NhRD+ErgbRvYJDpc5o
         8/rh/8EyME8q7mTv6aMCbcscoUN4PBbnx/NvhkOe/wWY6q7QEhjPxG8RypN0VNrieYkV
         Jd6xnpIriaAoOefMVowNvSJr/I5Np1/F79UBEq3Jhw8MFeBRuJexJem5WOBIPeTHgmfQ
         JYNFIER0EawPdquJchIFPhlt/5MUk0A267wvPkSvdpOjpPIOFzODMTp1/rA6GnS4qM+1
         VXSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786983593; x=1787588393;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g79rp1EAN8LS02s21Qd/CfSeDeEXT49xOteHy0W5fBY=;
        b=HSIsfdxErGzjeG9CWgVCVWWSD5qSenbFicQGTVvxrpyUZQLJaSPHe4Gi1j9gDC/9PE
         QgspZW2Zpi9xitYwgM9cQ8kFcYHmS4oRWUFT1EfNfRKZFrhw0+tDMUo2qndYU9Zn6Ms7
         LwImsYuNTAzznxMmpJiW9rbecx1kM/Wa3Z/gsA/q/EyrqwYVomiZ7Hfd+CnPgB6/C5zK
         I2+jcU+pgTMivhf5NmWVq8UTohkLDMubR2YTnt1sh2BV63IDsZEizVWD/aXVsRiKdR3R
         9iVBaGXG/wGiXmjhjUVOKb9pDkkvdq5kZOC8yHFCN1ulu/f3v8tpUrLiwLFHXQcJng+E
         RCBg==
X-Forwarded-Encrypted: i=1; AHgh+Rqy9HzffBsqSzcKd7Sx4qVfBfgKIPTIDqNMRM3gQpDg4Lc1n69whboajQIZAHhUldrBPJxV4ulNtw==@kvack.org
X-Gm-Message-State: AOJu0Ywp5wdcSuk2OL35GtzmXMnf6G3tvgZoq9yr1vLxK01xH+KyjMRy
	FZGMgaPx8Xo0MJH9uiuPfEukmT4+torp0+kvqwR7TrhtdF7EXyo2SUSjSlTCWDkFg78=
X-Gm-Gg: AR+sD11lVOGxttPhtIiOcu7Z0yFYkkJTfyyASap7jiuluo8MCZFwlFEJeNur6VzZYN2
	5PgxlcI8IyvJmc3HxKAaNCsDRh4EbotQSGkTkj+KSimslYyRgzb5Xgqr4OVCgozCKCK70sZf1vY
	p9mGGrRjYRzNGZUyQ1P8OyHHjR+ti6Yus2/fSuCzh0GX2WJBZqE+z/cpQXx/2Rqit1D7F+PC5fd
	NwVGJoXrtbhBw+xQlC1+4zB56GczvFllrrBEVcYKlHKYmY+Qe2jQyC+u2BIsHK+Xdv3tOlrN/D8
	oIs30/eIlfx5IoB2aP7pQg7rLjywXAifPhXZ9svcDZQMgEABwvU3ryHBkQWSJcGgM1yDfwewxLn
	6YDVGJsoeiQ17WRMs+1JPkCaypIj/GfinzE+Yjn0EV21blCIkJlhWu+ARxFtpxyajcILp1wOm4c
	FFqIB/wBhKqP/Eexk/UvjjS/RNaK8O6ljpsp07A3DYc4+Lt8PLfl2lWSc3uSF+EdkQwCSY4O1gw
	RoNHD+tX7T9NLqzgPCQrM6sTC46ISbFaL5ARsGodwtn
X-Received: by 2002:a05:620a:5302:b0:936:ce17:dac3 with SMTP id af79cd13be357-936d238d066mr2289883285a.40.1786983593483;
        Mon, 17 Aug 2026 09:19:53 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-937033ce78csm80835485a.31.2026.08.17.09.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 09:19:53 -0700 (PDT)
Date: Mon, 17 Aug 2026 12:19:51 -0400
From: Gregory Price <gourry@gourry.net>
To: Rakie Kim <rakie.kim@sk.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, dave@stgolabs.net, 
	jic23@kernel.org, dave.jiang@intel.com, alison.schofield@intel.com, 
	vishal.l.verma@intel.com, ira.weiny@intel.com, harry@kernel.org, kernel_team@skhynix.com, 
	honggyu.kim@sk.com, yunjeong.mun@sk.com
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted
 interleave
Message-ID: <aoMv3OhqkBTzSfek@gourry-fedora-PF4VCD3F>
References: <20260806080936.421-1-rakie.kim@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806080936.421-1-rakie.kim@sk.com>
X-Rspamd-Queue-Id: 83D09100009
X-Stat-Signature: j1kqmjqtunr5tdnh3zjsopbfo77icxjz
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786983594-252510
X-HE-Meta: U2FsdGVkX1+GgFSE/0la0Y/f0C3wTfbAfHVLBXkasyn2ymEaV/P4BHiJ7sg/T23y+rnTo8CLXAHZ3UnwYmPS9xMFcPEIctweULpBe/zfie20yrLtWRxjqq0jOC6PlqQaN5S3nvyX2ZO3sjV1lnlqfBbK5vmNe1DP1lkKkWH7DVKQvc//TPL3qmn/dwT4UwYfApGgfoynRH1FiGWPjKjLjxML2tTjvdvM9937adg0PAIgMuvW0YjtmENFitwu1JWS10xjf6A3zZXCNckZc8Y+LxKGgLJBlkmtb8tBIaSK0vbvKxlhJzAH4IduKXT/hIN+kxmVtNv3ZraiU4aE8BQARKKOGu89RmdKB0KOrQufViVciF/pcEtUhEsTMioD5ZSI4xeCU8CLE1It68ssK1QvGzGReAu98O2MhTZi2sAmzWD5D7tO1SfkMZqIuAZOBbQZnc1gbdHj8NCp7sL1ePWTIH1QU1TGvWHwoLYewqi8i0N2rcKRu96nwB78h5DBW05IOWEQg38Ber/kvPvi/L6aIzpMqic2qGxoGNXtoMBCDO9LGpA6JLSfIbeRmp//LamJK3xkuOnOwkwoOG0k+gk1rFDvwIqfuVtgZ5s+gWx6sU0SsFtihhNoin4J/oBDxqaEJWaRNqm4wG0nIQWF9MTsB3+ADkHTF/UgBsPJepKvQh1wat0wDqKssyK0KW9vzrdvIQiHJD+HacS4ku7WG80ZnefH64BE/+0y3+zQcYDpc9TzkcECPW9bOZ9ai1I9+SsbXQuhbuAagrRRRvUj//DxLMUEpsa1luEAGeMRUftCygtFHe4YdAti3yCTViPQhYw0f5d2rqLqL3lKhLuadJ4dQF0GCaZuwDNLNv8GHSapwY0qyVr+v8kzQWTXQuK3jFrqom6ql9jIw3ZAfVVb9c6ThDR6084EBRV2ZfjFqyf4MccCRFTZOnPwpovETE1IwLoFuCnb7bqTpRhqmw4cxbD
 pCjNpRRn
 ZNZsnH2vLkTIHQ8pc6b6gyb1I4viDEpeWf7lnkemGUp/ndUGHVMflOh/nzW+0XndM/YYDYn7YNL9KUqE8C5B2baSLXFVVXNphliXVyrPVLrA93LlgtSR9PIQzDncF6FAVFEk0OD2rN3561Tb3uceSNe5zFwq4Y294pOJJlFiwliwxt1rrD+yDT59YhAn5fTZultqXTdk+Nwh0JXQD2QiZjp3nKfT3ifer3UpQa9W/Ip394BlTEZeTNpVO3gNpA/ZSwkat0Kb76Dy3QOgsyUHsNFVo9+vS2U3BJYXkWwv5NH6+k10wAMljW5nvfkVdK6vsTOOlWwVIAOw8iKi/PU4GMQgtGCBgc2IayuJ0IXelimA9z/kiiAk/X5bXtUwGFl5nuwsAqKCHomg13kUH/kmyOoI8RA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 05:09:31PM +0900, Rakie Kim wrote:
> 
> To make this possible the kernel needs a notion of which nodes share a
> package. The NUMA distance model offers only relative latencies and no
> structural grouping, which is especially limiting for CXL memory nodes
> that come online without an explicit package association.
> 

The original attempt to handle cross-socket interleave tried to deal
with this with a matrix for weights, but this was deemed too invasive.

This brings back that matrix, but not for per-node weights - we're
basically just adding an addition weighting to filter on.

I have some concerns with the now additional filtering mechanism
introdced into the allocation stack, but fundamentally I think this is 
a *better* solution than a straight weight-matrix.

I will need to chew on this for a bit.  It seems there's non-trivial
sashiko bug reports here to address anyway.

> The series adds a package-aware topology layer that groups CPU and
> memory-only nodes into a "memory package", built from the physical
> package ids firmware reports and, for a memory-only node, an initiator
> CPU node or SLIT distances. A package can contain more than one CPU node
> or more than one memory-only node, so the layer maps a package to a set
> of nodes rather than to a single node or a single CXL device.
> 

When worded this way, "Package" sounds completely arbitrary and not a
useful distinction.  This really just sounds like an extention for the
existing fallback lists to take interconnects into account.

I wonder if abstract distance either:
  1) already gives you what you want (the secondary weight)
  2) can be twiddled in BIOS to give you what you want.

> The feature is off by default and opt-in through a sysfs toggle. The
> package topology itself is exposed read-only under
> /sys/devices/system/package/; there is deliberately no writable
> override, since a machine whose firmware describes its topology
> incorrectly should be fixed in firmware. On a topology that does not
> have the symmetric shape the placement relies on, enabling is refused
> and any active mode degrades cleanly to the original flat behavior.

The way this is written it sounds to me like this should just be the
default weighted interleave behavior.  We already know weighted
interleave does not jive well with multi-socket systems - this just
fixes that (in a more general sense, Socket => Package).

~Gregory

