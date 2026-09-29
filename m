Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 706E8CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 22:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C0A86B008C; Tue, 29 Sep 2026 18:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54AEB6B0093; Tue, 29 Sep 2026 18:08:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413036B0095; Tue, 29 Sep 2026 18:08:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1335C6B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 18:08:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 854BAA6FDC
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 22:08:15 +0000 (UTC)
X-FDA: 85268188950.17.C46999A
Received: from fuchsia.ash.relay.mailchannels.net (fuchsia.ash.relay.mailchannels.net [23.83.222.64])
	by imf11.hostedemail.com (Postfix) with ESMTP id 05AB64000C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 22:08:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=HWOBl2RC;
	dmarc=none;
	spf=softfail (imf11.hostedemail.com: 23.83.222.64 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790719693;
	b=kSsZsJOrapLqmu7ZyeEpeudzEDYHeVfbjL5sXfOf/QXhTFXQqyNFaertq0niuaPQ5fRoH1
	kXTQY5OABeglu/ObjI9CTG+H9+vjeDM/xPB4OD4a7mt4pBQrDuDEznBNpIIA/R2hvy6N4H
	57FegoGOetmpeA/IEYDobasTNe7zWno=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=HWOBl2RC;
	dmarc=none;
	spf=softfail (imf11.hostedemail.com: 23.83.222.64 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790719693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/MjidhiyZvlwnI8HPoAfUzgBLm2B3srI3Zh+AVUip4=;
	b=rw4UkXl+9KaniL37PAeovbvyhw9XQs7Gr8gFNtbDGuGPQ6SmFDItQIo8Oc7DYrXrXzffRB
	gaFpMLLkFj823fLHSGPTcx7DDwpYBju7wfSIhqdHTZS/8cR9KJmG+SSlKwBSX0KHo+OJ4H
	9au3WNAHg+HSe5HMnI52d+jrX1wi0Oo=
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 84D40801705;
	Tue, 29 Sep 2026 22:08:11 +0000 (UTC)
Received: from pdx1-sub0-mail-a214.dreamhost.com (trex-green-6.trex.outbound.svc.cluster.local [100.96.21.128])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 037848009DE;
	Tue, 29 Sep 2026 22:08:07 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Broad-Company: 37df9ba5613faa8a_1790719691378_1081366681
X-MC-Loop-Signature: 1790719691378:1820811857
X-MC-Ingress-Time: 1790719691378
Received: from pdx1-sub0-mail-a214.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.96.21.128 (trex/8.0.2);
	Tue, 29 Sep 2026 22:08:11 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a214.dreamhost.com (Postfix) with ESMTPSA id 4hvXP11m3gz4D;
	Tue, 29 Sep 2026 15:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1790719686;
	bh=i/MjidhiyZvlwnI8HPoAfUzgBLm2B3srI3Zh+AVUip4=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=HWOBl2RC1sncyg+qW4OI0NL5BUYwZNX3YyPzt86HpjNrbY3ab4XpchI2ADRBJK2he
	 3TC8Hqtei1jo31E3ZN3/gjb3OWLGb7tHSIBPvmVTjiqLZddMLPZlHuMxq8IVHzlREY
	 1vRrE5/YQUQlJq3ICRXCoCPBsj85VN/Q2neTO28aotqD7HS68jTarfdfIbxB0+Q3Se
	 +figL3yCghu0/dt++5c41MkAYj/ZCXquKMcUwhreo+Ll3Z1UWEXzR31bYRi77Ko6Js
	 KI5+Js380yfPKq8rQCbzLR+KoYoLLgwqrAOgvia94gfDbRS6PG9eHjPPLsh9phFHQ4
	 tH/BM38SZuGNw==
Date: Tue, 29 Sep 2026 15:08:00 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
	gourry@gourry.net, mgorman@techsingularity.net, mingo@redhat.com,
	peterz@infradead.org, raghavendra.kt@amd.com, riel@surriel.com,
	rientjes@google.com, sj@kernel.org, weixugc@google.com,
	willy@infradead.org, ying.huang@linux.alibaba.com, ziy@nvidia.com,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@kernel.org, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com,
	donettom@linux.ibm.com
Subject: Re: [PATCH v8 2/8] mm: migrate: Add promote_misplaced_memcg_folios()
Message-ID: <20260929220800.ekoqcpxkyfgbe3s4@offworld>
References: <20260728054356.291998-1-bharata@amd.com>
 <20260728054356.291998-3-bharata@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260728054356.291998-3-bharata@amd.com>
User-Agent: NeoMutt/20220429
X-Rspamd-Server: rspam06
X-Stat-Signature: 4h91m18iuon5n7e7xsi7i5d4okxi8fdj
X-Rspam-User: 
X-Rspamd-Queue-Id: 05AB64000C
X-HE-Tag: 1790719692-377908
X-HE-Meta: U2FsdGVkX1/gLd0ggODDIHVVG9czhFSG7OASFbX/pK2oJ0X5DdI7GUD350s8D9q/OVTIEYSPT92wI/tnHSYKKzxx8msPkF2Tfsfu3CC22Q30slRTuVemaAYW/XhSRwJzWSlkoPcd4Yjlkj4zqwU3ksubiNn0/0weJ7JsFx2Nl3Xab6k5CcqgUVhYPn/zXg3o7294LQBf4ZluOJP6Ll9tuzhrNUwiQY+mG6B+SLAYg16ev3TiejDLxRvCcn4Sjxm3b+GjTo5Psn3i7S56C8TtgPePJezPochzBnPaSMqFZ1A3WVCAgVBpvgwyC27phuL2yGjFp13SJ/KF2D9KZ5ndT0jPkk7qnvfpAm2khNa1FMPsVmCIKNx6ACos9G8lqpYAUE5PJ7PCZA/D49GANUfyvKfWke9uCfPUJ3X+k5ICvAiTxwQ7+4kUwqq3JvL9xulGPi8yc9zL6sujZBf9L0Qm3A/OFc2wGtO7F5WRyQyd5jg8hQEJAKCLNtJU0TntZhqxnVC6c8GHEdd9HoimeVZeJjUcGlENu3MgyvgDXyGiPDw4WsPWn4XKLs8nwCWAQLIfNwlAA5PDwQgUUdWaf2l9ky+PrPMUJffOTqY9DrDuP90VG54sPVOhy2z56ohOhT7sUTtkUkDpdKKJaCv477eFHDp8RUlESsq3nPoHr7wxcDaP00+DnpvOg+yauwgOsum4n/2w6I8e5QytuvULGxV89r/p3LqN25eJzNWojZvbPNPT9yJDwBv1BgsPqp658ePHWTQU/VJAfGqTV4fupz56QUr0YUwiFWe0DEi6lPFLgMB099TMK3vg7ymFz+XM+dm2auyJrfixPhw77sor+ZNTeuOtM/hQ2r/3BrcbM6aFTA8OBTqqfshgaZ765VzAwoFXpOv4ZbbnpyebXdbZJlSCIDmiQMIY8Ra9OCiZFTqCfzJha8iuy5snxRgd4yUK8NiHIUPxxY5mbbY+VnZQqF8
 LWPIxQtu
 N9Xj1i4NbPFgZxbDNu7KZNr6tD5FYCB4mGX8t4D1DbPauQeay6UghCv/HLDtZyYsTGRwYJoaB2/o8obbd7083k9iJSAzJU2zRKDGxIhHFPbd4JpZ8eG0mz6YDDQWYBNK6+TgsXGQ+LIYeTOOO9FLDOj6ly4IPe6bzWTFoKGh+E8KBd0Lf/GAzc2OLM5yQ6aUs4qYFZrkarWjRw9F9TLax17YEEWxqZeXXdBt7O6oykHCPnfFkmviww9+rIEBmAaAmEVcQQt3DcliVSGqO8GTEarQUtRtdkqYvxX9qoY150i6peVyP/PtE1nKzWD2yrbWWUIYjiUCP0ETHygYHZslfNV962e5lCbiYN0M1UthgpOcukWS7WtnkmQWXSn2dvfXo8X4xvSR6OjcTGgjzrM+4dNE/Ncv5w5LKOrU4fCArBOiI8LXvnXXNmlYZGwLHE0gJ5EryhjRpuYElPEVpEOU4a1x4MsecJzJtwSamcwYpqYYgviWYKsNi4Sqf6orn+Q464zDsrGvLYJYqXWNzl49YbTzGxDE9JZCL+9NE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Jul 2026, Bharata B Rao wrote:

>From: Gregory Price <gourry@gourry.net>
>
>Tiered memory systems often require migrating multiple folios at once.
>Currently, migrate_misplaced_folio() handles only one folio per call,
>which is inefficient for batch operations. This patch introduces
>promote_misplaced_memcg_folios(), a batch variant that leverages
>migrate_pages() internally for improved performance.
>
>The caller must isolate folios beforehand using
>migrate_misplaced_folio_prepare(). Additionally all the folios in the
>isolated list must belong to the same memcg. On return, the folio list
>will be empty regardless of success or failure.
>
>This function will be used by pghot kmigrated thread.
>
>Signed-off-by: Gregory Price <gourry@gourry.net>
>[Rewrote commit description, memcg awareness]
>Signed-off-by: Bharata B Rao <bharata@amd.com>

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>

