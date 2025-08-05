Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BEDBC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 09:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2D496B0096; Tue,  5 Aug 2025 05:52:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E057C6B0099; Tue,  5 Aug 2025 05:52:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1B2C6B009A; Tue,  5 Aug 2025 05:52:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BD9FC6B0096
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 05:52:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 664D81355C2
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 09:52:50 +0000 (UTC)
X-FDA: 83742239700.25.0B105DE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id ECBCA160002
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 09:52:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MbzDK56W;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DhVywzYJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MbzDK56W;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DhVywzYJ;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754387568; a=rsa-sha256;
	cv=none;
	b=1zPpk7TVZNMmPzV7DWM8yUw5Atm8lB4bMWmeQ/mBOL/ZRpid0K2XichC1f9N7E1IJPsULb
	LHn1YT2ES6XRk+PfyfbqDcPKzvsIEeE8d2yW0Sjdwfamxb9PMAeEz1R6CCw7DGJWg12KAI
	8CuxxN7EjDLlV8ljYF8jpEpzftL27bA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MbzDK56W;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DhVywzYJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MbzDK56W;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DhVywzYJ;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754387568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CDpfwfDj8mWUuSG1LdS+ozLLdWjJmIOisHydIRxuvwI=;
	b=Tfqh856M6XayixAxpGKMwJzQ+c1YtPKqQ/FBTMVXStTyE+ApAx/iUMZH5LmIrTLLOL/zgQ
	07+wr8sWJFy9Y/10apyUqv6VkhZ8ZTgszgftX6pdXoBric5jlxkXcC0DVrBS0MvwGKfFYx
	g4xLFuvxt4ZH5mC4WBqlJWgjScJto38=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 00B87211A3;
	Tue,  5 Aug 2025 09:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754387566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CDpfwfDj8mWUuSG1LdS+ozLLdWjJmIOisHydIRxuvwI=;
	b=MbzDK56WATBzpYvm36PNRjnPakyEpA0LxY05vXUpaJh9MMuMEMri4LNxqixWXpZE0ujwi2
	L+GUGKQmmq3DdmYrQpdZknuq0a52XYiGsEWfKKMuTvrp4/SSXHFbSTNHI1MRqoWx7xx6IB
	QSBtK4dDay15AfV7AmP8sn0DPxz98k8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754387566;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CDpfwfDj8mWUuSG1LdS+ozLLdWjJmIOisHydIRxuvwI=;
	b=DhVywzYJxBPrz+KzmpiM4/Q2zxvwVcCLxQF6f+fvfGe2r69RE6DlgZiHiEs1FXmPkvD5tA
	jHuaVAUJKfDbmjCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754387566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CDpfwfDj8mWUuSG1LdS+ozLLdWjJmIOisHydIRxuvwI=;
	b=MbzDK56WATBzpYvm36PNRjnPakyEpA0LxY05vXUpaJh9MMuMEMri4LNxqixWXpZE0ujwi2
	L+GUGKQmmq3DdmYrQpdZknuq0a52XYiGsEWfKKMuTvrp4/SSXHFbSTNHI1MRqoWx7xx6IB
	QSBtK4dDay15AfV7AmP8sn0DPxz98k8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754387566;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CDpfwfDj8mWUuSG1LdS+ozLLdWjJmIOisHydIRxuvwI=;
	b=DhVywzYJxBPrz+KzmpiM4/Q2zxvwVcCLxQF6f+fvfGe2r69RE6DlgZiHiEs1FXmPkvD5tA
	jHuaVAUJKfDbmjCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DEFC013A55;
	Tue,  5 Aug 2025 09:52:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LolANm3UkWi+VAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 05 Aug 2025 09:52:45 +0000
Message-ID: <4566222d-6b91-4789-bdd6-61e3769f5dbf@suse.cz>
Date: Tue, 5 Aug 2025 11:54:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/page_alloc: Add PCP list for THP CMA
To: Juan Yescas <jyescas@google.com>, David Hildenbrand <david@redhat.com>
Cc: akash.tyagi@mediatek.com, Andrew Morton <akpm@linux-foundation.org>,
 angelogioacchino.delregno@collabora.com, hannes@cmpxchg.org,
 Brendan Jackman <jackmanb@google.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
 Linux Memory Management List <linux-mm@kvack.org>, matthias.bgg@gmail.com,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 wsd_upstream@mediatek.com, Zi Yan <ziy@nvidia.com>,
 Kalesh Singh <kaleshsingh@google.com>, "T.J. Mercier"
 <tjmercier@google.com>, Isaac Manjarres <isaacmanjarres@google.com>
References: <CAJDx_rgzkZognxWzOXJ-ZxdTtUaM3FT6bmpkwxMz03XiX3fKAQ@mail.gmail.com>
 <d395b14a-9a84-4f25-b4f0-45e8500fc5fe@redhat.com>
 <CAJDx_rgrp1TpOt-iDcsSGRTL=qZZsK_dpKL1bSkyunPGcGXt5g@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
In-Reply-To: <CAJDx_rgrp1TpOt-iDcsSGRTL=qZZsK_dpKL1bSkyunPGcGXt5g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ECBCA160002
X-Stat-Signature: 9a8ikp7kpmz8eqei3nbnwsmctbpga1oo
X-HE-Tag: 1754387567-58221
X-HE-Meta: U2FsdGVkX1/ZWURR3lKWPheFKuWQWU+xBfjRt1hFkaUSM2eLbuUQraEOKZ68VkXnC4u5jywIvLUauO3q/jdHO7IicMbxYdazS36+ADCbJnpWnz9IqMO+Lmew3X+IsG2xL4teErEW7iisAisdAWGDAVLySAG63fdXFGNLWMIIYHg0BHfPH+OYTbAeZtU4Dial41Zcj0woQanfAfRttF4B6uef76jmikysQt6hodM4O5Qn9V2aewReM1Vo7ys6n81lgN9QlCl7H5KjCBcOCr2jO5b9HppHTGBl30MP8rHGYe5nsYZoag1a8tZNfdmZa0bZsGi4a9G77lFFSdUvC0O5Wl+H2nq52vtsdNPTvOQLM3VcpDoP4uvlOijgiHOHVgAubOnQYY5+r/DVAAHL017UCv5fnCxQS32xkc7333KLrrXqRMhApH8yFghSTKXBMJsRpwxcAhvyt+qY5+GU+jeLVk4oAxfket64vFwoCsa9AQme3OzC7BhM6psbHpRRnUotc+1xshmicNIZbWibeMt8D8MIMU/YTEHCV305QWJTZvepZGfwHjGV0hoyP7yJLuI+6Ig3xJ0LNrdKruP+Lr/2GI27kzBNJaLoPQhUfUH6YWmd+kEIX/3Yx9iYDwUxukqKydi+NlUMRdyJF0cqA0eI04mQmlMk2rlBwkp2LBH9z6koYDXiXQ9l+Gi+DsE2JNte+5BRVMofYSPoRsBLdywg8+BTMgrTssma26h4yYPE2A+7GE9STJw961iQf0LhwsbH/upw/ijC3t/qq+1Dl25GELNf3oAhFBo1nREsff97bHGSxCphl//RuKSVuAeQL8kflFvxfXSrWqgP+AXNrxiMZcTP8s2mltcWTOAvrDfVwK3kYLb9QgpygtwIfEpiPrjuC/vm396A8S5/qGwC9dSqZP5v+bpRoIvc1ycCPGH5RChH+UPcuQgPxQx/rQ7XyeNuv8qGxdcfqiy4zmr42mY
 qdecRT7+
 jRXRgTSuLGeDhQiy9sUJ6JDc6kPjv+VOAe73jddRNAFJLWXpveWn6smoMCdtMBfTcKPTJqBV5ibES5bnTmxKuYoVrKyQqHOi2S9K8sPak0nj/w2yI2s6XYvk2cyrHhL2TA5f1Qe3POOktG8X3PK91RrssioAmAu2VfVS1oauT1CQPAk4iqUnO6HXxi3e3mEvWpao+2bVj+1hODKuBqoQsh8Ag+MZlAJZbz2dfKZ43If3KFqnw0uazRVy0ToYSkVfWBodU8mzTIr4G4Qy1OuejqgMBnk91AZq0gp7cBJ78hYOID0kkq9qvEiugANldeWj1pLQrIS+OYoznigKX2HWvUcLlspXYM9K3tbidj5/jClRYfPNafletWXNi6W+DIwFokYsCLKbRj2t924645jyhR+optHEAB/cdc3o9zVJ5Vqa2bK7Uq4Aqfig2OwlH5RcOn8CJ7dL2Q4HOKhQuxwLhA+E1futhUirchzgaOPAeiDR/nkiAn3PecGxUO8a5uZsgRWAsm1xy9sLnMXPEeGxHIxNIjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/25 3:22 AM, Juan Yescas wrote:
> On Mon, Aug 4, 2025 at 11:50 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 04.08.25 20:20, Juan Yescas wrote:
>>> Hi David/Zi,
>>>
>>> Is there any reason why the MIGRATE_CMA pages are not in the PCP lists?
>>>
>>> There are many devices that need fast allocation of MIGRATE_CMA pages,
>>> and they have to get them from the buddy allocator, which is a bit
>>> slower in comparison to the PCP lists.
>>>
>>> We also have cases where the MIGRATE_CMA memory requirements are big.
>>> For example, GPUs need MIGRATE_CMA memory in the ranges of 30MiB to 500MiBs.
>>> These cases would benefit if we have THPs for CMAs.
>>>
>>> Could we add the support for MIGRATE_CMA pages on the PCP and THP lists?
>>
>> Remember how CMA memory is used:
>>
>> The owner allocates it through cma_alloc() and friends, where the CMA
>> allocator will try allocating *specific physical memory regions* using
>> alloc_contig_range(). It doesn't just go ahead and pick a random CMA
>> page from the buddy (or PCP) lists. Doesn't work (just imagine having
>> different CMA areas etc).
>>
>> Anybody else is free to use CMA pages for MOVABLE allocations. So we
>> treat them as being MOVABLE on the PCP.
>>
>> Having a separate CMA PCP list doesn't solve or speedup anything, really.
>>
> 
> Thanks David for the quick overview.
> 
>> I still have no clue what this patch here tried to solve: it doesn't
>> make any sense.
>>
> 
> The story started with this out of tree patch that is part of Android.
> 
> https://lore.kernel.org/lkml/cover.1604282969.git.cgoldswo@codeaurora.org/T/#u
> 
> This patch introduced the __GFP_CMA flag that allocates pages from
> MIGRATE_MOVABLE
> or MIGRATE_CMA.

What kinds of allocations would then use __GFP_CMA? (let me try guess
one - zswap backend?)

> What it happens then, it is that the MIGRATE_MOVABLE
> pages in the
> PCP lists were consumed pretty fast. To solve this issue, the PCP
> MIGRATE_CMA list was added.
> This list is initialized by rmqueue_bulk() when it is empty. That's
> how we end up with the PCP MIGRATE_CMA list
> in Android. In addition to this, the THP list for MIGRATE_MOVABLE was
> allowed to contain
> MIGRATE_CMA pages. This is causing THP MIGRATE_CMA pages to be used
> for THP MIGRATE_MOVABLE
> making later allocations from THP MIGRATE_CMA to fail.

If you don't want THP's to use the large (THP-sized) MIGRATE_CMA pages,
what kind of such large allocations would be ok to use MIGRATE_CMA then?
> These workarounds are mainly because we need to solve this issue upstream:
> 
> - When devices reserve big blocks of MIGRATE_CMA pages, the
> underutilized MIGRATE_CMA
> can fall back to MIGRATE_MOVABLE and these pages can be pinned, so if
> we require MIGRATE_CMA
> pages, the allocations might fail.
> 
> I remember that you presented the problem in LPC. Were you able to
> make some progress on that?
> 
> Thanks
> Juan
> 
> 
> 
> 
> 
>> --
>> Cheers,
>>
>> David / dhildenb
>>


