Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04F42D13C2D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 15:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 351866B0005; Mon, 26 Jan 2026 10:09:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FFA16B0089; Mon, 26 Jan 2026 10:09:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E18E6B008A; Mon, 26 Jan 2026 10:09:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0CEB96B0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 10:09:24 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB74A13BAD3
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 15:09:23 +0000 (UTC)
X-FDA: 84374448606.22.C774F48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0AA481C0007
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 15:09:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xixd4krr;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769440162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MHb25h2A4wA8S4XlUyI40EvqM5S7kO13pLW61dQ3DS0=;
	b=M7yxyYsxWR2b2MYV/96a3MTbJuO7qG0ThgcWN4OSRxet/Rf2a8CI+cM5icbCGDceTPbA3T
	Sm36EYHjlfJHm4hI2sAyrW/hVwMea3UV8EpsJo2aHzs+m05hawrC3mRXEofxH/+OobKcTB
	cb1+LPwrWDwiMV4HoUCr/wPrjr4R5SI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xixd4krr;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769440162; a=rsa-sha256;
	cv=none;
	b=agLr8WXgjUd24Kchu0ysaPOpo9YBlQVmyWvxwhIfdEv9RL30IkZeyyZNYGrnPrqFEZnLaA
	Qfa+8r0ubKP5tLORHk0O7JmgOXTL50sK90MzoiVeqHfan5yaPA6uYTDhtxU9rRAkbnI1jH
	n3zzFe5WGD7n0n/iFInj85PDq0pkAng=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BCBB8432F1;
	Mon, 26 Jan 2026 15:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F229BC116C6;
	Mon, 26 Jan 2026 15:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769440160;
	bh=O7b+ioRsB97Y32ljXm5Io/Gt3sgHeua5ZHEKIXJqKsU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=xixd4krrAPZouZ0meDgc+WkiIS97gm5oqypKP5H+EOjYNxN051VuPeWvpH/140pYk
	 T5d4RZEcxum1+pwa1SMhoya2y2u7TEAegzYymzqZCfTBGR4ibL0aN8cnbPWczQXG3w
	 qeoSEliBViEK/73FvGyRlRB5jt+d4yaUqbCMZoYI=
Date: Mon, 26 Jan 2026 07:09:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>, Nico Pache <npache@redhat.com>,
 david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-kernel@vger.kernel.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 jannh@google.com, pfalcato@suse.de, jackmanb@google.com,
 hannes@cmpxchg.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kas@kernel.org, aarcange@redhat.com,
 raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
 tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
 cl@gentwo.org, jglisse@google.com, zokeefe@google.com, rientjes@google.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com, David
 Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Subject: Re: [PATCH mm-unstable v14 03/16] introduce collapse_single_pmd to
 unify khugepaged and madvise_collapse
Message-Id: <20260126070918.cbbd532f4a8813e8a188108a@linux-foundation.org>
In-Reply-To: <0e79a766-811d-477c-83ee-389db29d41bb@lucifer.local>
References: <20260122192841.128719-1-npache@redhat.com>
	<20260122192841.128719-4-npache@redhat.com>
	<65dcf7ab-1299-411f-9cbc-438ae72ff757@linux.dev>
	<0e79a766-811d-477c-83ee-389db29d41bb@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0AA481C0007
X-Stat-Signature: sh7oo4epof4xknqt3umt6zgna5bmdeza
X-Rspam-User: 
X-HE-Tag: 1769440161-640657
X-HE-Meta: U2FsdGVkX1+p3swu29VusqRYKC2grcnJnLL76n+O13+uM7FEXa5IGNx98+uDkwQXD8spcwOsUx43nXdM6Kz6UotxkCQ56mLELSr87GydEKr/ZgomKIPCvTFiQdSbOkpJ0v86fbHFkm7LV/jQlh1+8LjMTEx37h00vOmJ2a+TFR8MIzVXcm/zd56pT2iM/7ZG+b0uAGCDa8ma2W9WN6R8aF98qZ6ERJGT8OVW2wirMPcgH5QDIJmo4W8yh1BNcAYqUzMywdBLnKj1OiBgyHaRcfTF0SGycffxNbmlrFUM5Vvh6raB7WWAazqyjM5Qlg705eF0qyZZZ2cbi3HtnAjqScS95+KG9KQrMncO/wYN/dKxPliywtxIjZw8IQT0/ZOHgWeB1PakeLY8uykF+C/vXSk+1A628E5ej0vOn2qVDk47lPAjKn+RnQU6N9xoT+U1stIS6OaUsmDMRm7kRWQ9PbLLH6alAFpSPI38rPyFKCJJ27/Vjti1W8HBOKFm427rnp+h5xt2Oo45bpSKHjZQ19v4+ptUbUf4GO330mP6q2uED33SH9CLf21Glf/6xK7UsQPNxoSdd2SNQ+mytoFHlrDlnaBl9o+b+QPjowUY5uFHaog6WVnlHQxmdG17yAwklQ/6LHLkpn/yx1TmstDrBxTD8ATltTDmVlX8qnnJQ0iLUhMYNVFZfdGaV8SWXsaTA6OZjSgQNO6FEDfy66+oDK3DWBcM1OX2odL2kNYdt1Q3eny9Rlnp5akJhxkHqzZf+bG+Dj4MIKD2wbfIWG5tW3dUtTDxmUJrwDsjLKgQewV7MkfSpx9SaUzMoQpPIceKZAzGJkmuHOvqOv1hGTNLpUC9XmFm+ce0EjKKNPD1i+v8aGFz+n38ZQUeXBOx+wLqeNGx0Y9McoMp+BP0z6UDf5aQ5T5Fs6ikw+lGH9VxSKU1i5PIZCl2SPZlEksWVK1lOtyJhsRs7pQNsD4llQB
 5XemUUHG
 IiF/rAyeKn/e5dHvUhqWgtkxzmQrIdXIoKRAiuLN6KBnOCIAxK7mHUrS/g/u9e6K4l2xj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 26 Jan 2026 11:40:21 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> Andrew - when this goes into mm-new if there isn't a respin between, please
> drop all tags except any obviously sent re: the fix-patch.
> 

I've been believing this is next -rc1 material.  Was that mistaken?

