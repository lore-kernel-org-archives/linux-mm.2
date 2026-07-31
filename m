Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C46AC54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 06:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EA626B00A7; Fri, 31 Jul 2026 02:59:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19A496B00A9; Fri, 31 Jul 2026 02:59:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08E266B00AA; Fri, 31 Jul 2026 02:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D622E6B00A7
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 02:59:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5DBFE120348
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 06:59:47 +0000 (UTC)
X-FDA: 85048171614.29.04DDF32
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5A31D180005
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 06:59:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QC02GEhf;
	spf=pass (imf06.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785481185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xI0H9wa1goDx2gBWNIZQxhHDiQfCZkKSOga6sXZ8pBM=;
	b=r/XGz3IrXb27ZsFfKyXIYLQabKLJdWTSWd0lHgQjlVM4kNXyLJMlozV4Y6ux3dVBeyv9Ks
	ZqQTYCpH/8E/MsWzeCV87LqWcEAqkuMjz0+/OtLttbMU4EpL6L4IfZdWkaxmOIvdxjyDwV
	Sj/nqvqIfdvWE2ZcpuXfCsP3wCw38F8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785481185;
	b=P7C3vpzSyk/RRu5xPkDTcTJ9/JWghxPnO9SYnYAllxeZXElpDNsFad/4bzdnlI1qQAkubp
	6x7OjGkp3krIVqn55EziQfPM4Ceuz4P5R5xvYGfHfNcwNVDSn02y4LPVvgVDGMeJ6jlusm
	GDc5QzYsg/Vj7++ehLIDdQzw11kXhMs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QC02GEhf;
	spf=pass (imf06.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1361D204C;
	Thu, 30 Jul 2026 23:59:40 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F1523F86F;
	Thu, 30 Jul 2026 23:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785481184; bh=OAzUPG308bSFiJus+9fUvVqFx60KXPL0dOljxnhzkyQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QC02GEhfCiI0em67YgTLHRPfaCb/dfs+G3WtGfvhepMbRXWH055GKUXJXt6pMlijz
	 hT9rJRKzYW9aKfsLaUp7wjeWgB7ykVkZ7QlwPmt8SYdkcC4HSzMtMhiD9uqxfhjbvP
	 vXMSQz6l2emXPCT4oaiM9BcgLtdshUgS/uOEQARE=
Date: Fri, 31 Jul 2026 12:29:40 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: =?utf-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>, 
	Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Dimitri Sivanich <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Stefano Stabellini <sstabellini@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
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
	pfalcato@suse.de, agordeev@linux.ibm.com, ryan.roberts@arm.com, 
	linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-parisc@vger.kernel.org, xen-devel@lists.xenproject.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	damon@lists.linux.dev
Subject: Re: [PATCH RFC 01/11] mm: introduce hw_pte_t for PTE table storage
Message-ID: <dzpt4ays25vvoyt56oy4iatfbqwp7z4gdsxumirv3v2nbvhoy4@73upph7f2hbk>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
 <20260727164715.2866609-2-usama.anjum@arm.com>
 <6xah74eadjmo2bozyr62wcxo4hhpsiufx2mshh7tztyy2dzzps@63m327m7pl5u>
 <41414c5b-e98a-4a55-ac87-ca982b248ca3@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <41414c5b-e98a-4a55-ac87-ca982b248ca3@suse.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5A31D180005
X-Stat-Signature: kj68nn3ini7txbsi7zspzc41sc8zubgu
X-Rspam-User: 
X-HE-Tag: 1785481185-156336
X-HE-Meta: U2FsdGVkX18mnxQqPL8aZj8zOPKBx9uGKefzIhJin60BH/SD5MFXWMl+DbsI6K5aX1SOC9GO2c4D4BoPaZ4OhM5tiBhLRdWDJtCuk8laGVJjxVqlmQL6b8iMZHgfSpVS7CxqNOIDi94nPnQqyc1P4A1UOzd6BER+rFS+vBI2X/VNCJ0BSgpoFN2uZKZfvSxcAycXsOTLVvNJYZgLyc00MSkLur4nsqBa1bBVBhKyNuOUlSuXPXecCk6DzqnnlGGtiMEje5a2dNl4RAQnTtF+7ndb2kEt7FklsolapqL7CKsCr6io/YjZeo+kU64qg3oYTec5Hqx8wDxyLFuGp6lI7sFKMtcJpODc1d+SWKZ5ZbQ3NmIwvd15a+YUfM7zpqHenV3vXj5WdaP3dNlKAcRncfjb9b3YJ6vqv24uvsCIYXV9FV12oAvT02vhI1FES8Hj93FK+Uk6GyEYNxXNcxKGpz1hwbSabiPDT8ztQ/j4aDKhb3j94XcLztqiZw59ZcZIm54GDtT8oKysEEFR5aq+Qy66rMziZmrwm+4KKQmaWUwd6l/lmXQQFgmQUQIj7c4pjOY26BcyEJMq9mCmT0PtsrxbQqBECrpFETvHiA2i5OFle7WXxXj6tTmGHSUY5vbYkMedv5YG/IGJ5Jhb3pGWNGEQkXYHM8JnuB+jN6DSHGeDeGnI7Zo3uckBcTc2elMVv9XUM2Mm0kh1p2xx/1EBvUIQZfsnUSuXooV3u9vrDjkvQqTHa20XkVPDq9jUKa9SAVEfaAd+LU5xkr9A7bwUpqe41Mv7SjKJUuyKi8HNZE39eRu+a2C8oyOvJJYWBGYwaBtppGg2vvMwIypPYzw/OpQ9eIngutvnVF+oTTApwQCiQbrssNbU5lOp3FFqELWPi0m8Zsh+urKAK0lFvn1via7dd+vE+dC0Y7ofnXAj0BjK2YxmyTPFLgEw3WUUk06VRZKObFIUK2Tv/zcV98h
 8ZZ3hxrZ
 ZhvL9sTu5/tsKgm4cbZpcgQOVjtztehunNos+EuaR7F2B/ETqejt5NB6nzJLusa/FyGvmoZsKgvR3W9xYE+AKb0etkHH7MbnWIuyZHW62mdYxRba0dUdrE9TVI3BNhwKn3DrPm7hwvEfd4kCH/ayTPuMulB/5k0KRL+O1IDx8Cw4ATjV5PGDaXDSrJ4leG8KjK4JkepGgh0a3Pa9acktcNOgcQrM2/UMM75f+8QlScvvTyahX42rC9PP+cv/Oa2GCzEhiywXwcF+/knz3jxUumm8EhQLKYXOb33/ryZXWUdVVr+VlFpAs+8LrII4vm54dadqepu02ar1Bl+h8E+TaJ/4NYv1upBopymg4WbYiv1jR6FH9QnDcC+/jsXcdLff9n37+991WwZ8MXQi8E7bhy9pz/PEyqsJ1ZzcAxtEI09SuiHo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 08:53:46AM +0200, Jürgen Groß wrote:
> On 31.07.26 07:49, Anshuman Khandual wrote:
> > On Mon, Jul 27, 2026 at 05:46:52PM +0100, Muhammad Usama Anjum wrote:
> > > pte_t is used both for logical PTE values and for entries stored in a PTE
> > > table, so pte_t * does not distinguish a pointer to a copied value from a
> > > pointer to table storage.
> > 
> > Should we rather call them as "Linux PTE" and "HW PTE" instead ?
> 
> What about "SW PTE"?

Both Linux PTE or SW PTE would be better than current Logical PTE description.



