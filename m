Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CFE3C5CFD9
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 09:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A9506B008C; Tue, 11 Aug 2026 05:48:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 259E16B0092; Tue, 11 Aug 2026 05:48:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 149256B0093; Tue, 11 Aug 2026 05:48:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E6D356B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:48:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A75C1603BF
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:48:03 +0000 (UTC)
X-FDA: 85088512446.10.8A87759
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 79BDC40003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:48:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=d6ccwcWa;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786441681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nYxSNafAAtif8nzjOtqbyClvHQayaKNQE+7wW9BA4WQ=;
	b=uY6DbKXBsMla0IWaUcrMrLlrSk4YN0pEmyhMqVV1Ui+UKcPZj/waBvRhYdIb0waTUv9zPJ
	jw0VO82mhGDgJH8F41aTMHWYCxtwDBdcoxi34vqIgTucNVmNl+GjdOpvTPFyxyrkMAr/R9
	5URoaauqYr46sCZ0RhnAdxhuo0IA5zU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=d6ccwcWa;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786441681;
	b=77n5GX9csofSTn90oGVUwORwRvkT99jch/bUDUiNZKxXt+EPVJnsAL1RffJh1Mt8oEiHtS
	+qJgBcMXvr8UqrZQW+X4l+AtHuL5DzQPWAn4at8rd/pTwlGfXcyDI8E8NtWKm6HcaFbpYc
	nVcEoXcMWiaFIrnuH+xPZomk1t3bC6I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 53CA01682;
	Tue, 11 Aug 2026 02:47:56 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8FC363F632;
	Tue, 11 Aug 2026 02:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786441680; bh=9BoMtxA4Y0P7/HlT09wIdHqLAsjiBcPF0bOK0SA6y88=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d6ccwcWanhV2NaMQGyN2LuxorwwpnGJX87UVp3OA/ioC8kalbAN29GEdYDjGMly4L
	 +yi+Q/zEcN/N5K6/AZJJ9VjzIZc7OuAomjl/vPpcEdxNEFoRGn9LR525fZF+bpEreD
	 Ak2C6/i9Np4uONZAT7JjQS//RpxwX0LWi0gAmmt8=
Date: Tue, 11 Aug 2026 15:17:57 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich <dimitri.sivanich@hpe.com>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, ziy@nvidia.com, 
	pfalcato@suse.de, ryan.roberts@arm.com, linux-kernel@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org, 
	xen-devel@lists.xenproject.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH 1/9] mm: introduce hw_pte_t for PTE table storage
Message-ID: <u457qwrnkaquvqfn4op2a4wcdflm6d4gzut5ii4ialbeqjiyfj@qpn5fu5kwn4z>
References: <20260806083926.1807279-1-usama.anjum@arm.com>
 <20260806083926.1807279-2-usama.anjum@arm.com>
 <3db8233c-3785-444e-b2eb-3e5fc5cb2f17-agordeev@linux.ibm.com>
 <eef14e97-20cd-4b08-ae22-7636af049b09@arm.com>
 <4a42c498-58ca-46f4-819f-da14cfba154f-agordeev@linux.ibm.com>
 <52b5066c-64f6-40bb-9bce-365a18f24265@arm.com>
 <b40d4359-3156-4d02-9662-73bfeace607c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b40d4359-3156-4d02-9662-73bfeace607c@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 79BDC40003
X-Stat-Signature: one9ejega475kypxct6wsr81r69jrjuk
X-HE-Tag: 1786441681-142724
X-HE-Meta: U2FsdGVkX1+TqkkCLjT705o8Z1SddE949+0HR6mKrl449eHUISNRlwTt54niwt1TMA4WcvXzreMUUm8HRnTeLYP49LUrWPCc3YrgqHE3bhRM38bJ+qXaw2FNW3n5nu3nl5n+xR7rKjKMXnslmrUX5cqn4z/pSlgG6Nrv04f7/HHcwhYrUsNcJG+w0+yrZytO3WlSNMF+XVUzPVKThzZMjJsFdeLerFKRSIPrKl5azrz+jSw7NJZT3pgudoSSn1/N/zg3ziSZccedEDBZDw8J9zNMWD25PtiDrd+GwTFUK+WDr5qZY2z2FzT5ADYtEcjCEaBOEhan2xgx1n4Br7UEX/+P/eb36HyBah4I3bAUzS3dw3QxebXG7ZAk6dxzIbu+HZAYf5Qo8YY47I+iqAG/ksHid/6i3oQGSVsJ0DQo5aexitioylC4qMcMWsdej80SlhnzISeabaDruuUxoPiAOSmaxlEcXnYtwvp6MubDe3qLl6DYUiHfr+OYnQGveQs34bDSlv1Rrnx/HyhHEKGYyHEG+e3AkfAfYttjTiuwhV00gXUGTXwU8uuNCziSv99I15wUvcQoS5KwyQK2frXwGC7lc5zAWaOllVcszVnp+HyqbOsvl37lMMxEPEdJcrUKxwyDsHLebaZSJIZr0K/jk2mZMBZUjvEE1UczdtJb2l0W7vH+LvhHMvUMPXRAtLJ3BfKDsQ/kmIMdb7mL2Y/dawQvMKg4IbZylzTi32/6LGxlsvp/CGuzxbu4IULKJtahYcHCcVRPvoKp8SxuU7xnT1TNEQnG2Nr42XdAQUSR62sgyO3MA7pMrbbjXy1bHPDZ/T8dw/yhQl90u54EkHJsmqCzwCneXqL5uX3pWDKX5zJ3hyfED8kGPeXjlOdTFnwlH32FTu7o5GO3xLiFuiMxFmS8XzbgJEfnEd0u2yVoNhslCMcuTdJvR81XVPmcHS0XvqVHhttXhSaEY7LYXli
 fVg7SZfu
 VfgvSFIr6rC0ABfbvecVtZLEfgPwuzTdyo2llrm0dOyveR3TDhPlYpVTY9aKv1Ou44yvgKB7L8OLtPNfD5/vERkiEeit5hj5InZFgacdJ+PB68jaB/6Q1vobMLYNEQGhwSFl6t0TjVWdTWfK0aokGOrSs8YbghBRViarp+3iNizwsNRbpEbI7wP5t5MhltRMJoG6DcN1V7koJ5+s6OkY6TzLRqCju+KDpOYBH9TkElUIkxN6Kc/p+HmpCrjGhZ/Z4nSKye/o2hZseYFfSOs0+gdSZxhKGgP6DzoykYUpIhmdFu2oK3vDa2dLl4SixIvCBp2OvnKxxrnRaKme3E/mWmbrYEFKR2jXe6TbTWkTLFPafzwqdp+KzjQG3GL49PM42k53xTHnDDwnU9Eo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 01:20:00PM +0200, David Hildenbrand (Arm) wrote:
> On 8/10/26 12:09, Muhammad Usama Anjum wrote:
> > On 09/08/2026 6:45 pm, Alexander Gordeev wrote:
> >> On Fri, Aug 07, 2026 at 04:24:00PM +0100, Muhammad Usama Anjum wrote:
> >>> Thank you for testing it out on s390.
> >>>
> >>> As __hw_pte_t isn't being used yet in this series, would s390 enablement
> >>> patches add __hw_pte_t to this definition?
> >>
> >> I hope there is a better solution. As I noted m68k, powerpc and sparc
> >> may also be affected, so I would suggest to look into those as well.
> >> I would prefer s390 to use the generic one rather than circumvent a
> >> compile error in a custom way.
> > I've just checked all of these architectures by doing dirty conversion and
> > reached to same conclusion that __hw_pte_t must be defined like:
> >  
> > typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
> > 
> > I'lll add __hw_pte_t to this series. (Initially on last email I'd thought
> > that the first user would add __hw_pte_t. But it seems sensible to add it
> > now)
> 
> Yes, do it as part of the introduction. Also a good idea to mention in the patch
> description *why* that is required.

Agreed.

> 
> -- 
> Cheers,
> 
> David

