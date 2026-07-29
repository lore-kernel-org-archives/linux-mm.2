Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D30E4C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D35216B0095; Wed, 29 Jul 2026 10:22:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0B196B0098; Wed, 29 Jul 2026 10:22:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C20966B00A7; Wed, 29 Jul 2026 10:22:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 945616B0095
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:22:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 18C2EA0687
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:52:55 +0000 (UTC)
X-FDA: 85041652710.25.E3C04A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 612F010000C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:52:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RAKfZ2hl;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785325973;
	b=lIJ58RlTzOPax4RvM6PZninGocFBVIYobqBvRP54SR8/2LPiaba/QJGKjw5DXOwQ5cm4Mz
	KuCekcPmMU0ZEnZ6e/Kd/VOLTrztgL1mzoPf/PuiXmHTQJ0PhQODPkDVkyWo4ply6Ib8wh
	IUcwAaR3JgZZp4Or8KcyBo0RZ28ETOw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RAKfZ2hl;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785325973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8F6WAbJF8b0+/lVo//yrlr1XJ8a9Kbyft0CZ3XPUVYk=;
	b=Wm0mzf9fS0/YAPZyeADGgxRyp4Ue21nIWUSuks87MnHeXDMzxnbx8Gw2OTW4nYRR0EEVBy
	HLXNukVQfxSloEppVFN++138rUeWSmPEDKlCWaAJeUtZbx0CYRugbfM8PI8dzk4ZrrLnfv
	/NXtSYZYo3AYuVnPLcffDdmmWHMfFys=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 95C6C60A5E;
	Wed, 29 Jul 2026 11:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8671F000E9;
	Wed, 29 Jul 2026 11:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785325972;
	bh=8F6WAbJF8b0+/lVo//yrlr1XJ8a9Kbyft0CZ3XPUVYk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RAKfZ2hlnqur+lPLRDZhd6ll5wLFkTHMz4LI8eJaulXjieYAenmJmk4PMTQBKFZ/U
	 pyK0RNiqn70Ad+1GSsmrI6B8F0wYm30sXDWHDNst0Az9PbGi+TL/KORuZnT9sqQo9u
	 Rzh1V/+oM6ZDs940TjFOqs5yohNNslJjyJ8iJeoA7WeF7cquNvL+t9q9S4Ic9dWWSq
	 4Iq5kwkGBW1Jk7vbZTiYIDehoEYYdr2IUaB8x6zsF7dvrh9VnNBcSXaGSuIBDNZs7f
	 4jIUxCejHJULeLyIkGbqfPXxbWzy7/VjVvik+QZrAxtb829aluzCnGwByuZkktgqQX
	 wmpaiiZ29+lbg==
Message-ID: <78a0402d-5436-4aab-a704-90fab56eec50@kernel.org>
Date: Wed, 29 Jul 2026 13:52:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/11] mm: distinguish PTE table storage from PTE
 values
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 ziy@nvidia.com, pfalcato@suse.de, ryan.roberts@arm.com,
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, damon@lists.linux.dev
References: <20260727164715.2866609-1-usama.anjum@arm.com>
 <2c19247e-bee6-45f4-a353-2fcc60db26e6@kernel.org>
 <7813b5fe-e767-442c-a356-afc1a5c567ad-agordeev@linux.ibm.com>
 <6db0a8c0-b500-4364-be3d-d3a537c61258@kernel.org>
 <46319967-0338-4532-b953-dbea77084fe3@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <46319967-0338-4532-b953-dbea77084fe3@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 612F010000C
X-Stat-Signature: emqqhonzt1h1557pwcdu6h49ic4xzgna
X-Rspam-User: 
X-HE-Tag: 1785325973-765773
X-HE-Meta: U2FsdGVkX18TXUaGi8Hbnwi1QrdYudmkpMoK2fz2TsyNlOZqm83BZbOL7+T9GEzTW+PIGNFm2gCNdIB5uBWS6pJR40zroQXzin8I6RmY3j66uh5W+VOyFgobZeM6/kmrRC33N983ccdehc2J88qgURr07WQcbiUanuNX0ToPTMGzK+KbtJ2Pb0xEFixAYjFaovIlbclVLRT7V+LsT4b9wmS6NH1oFLB73s+3899V5vfayki2xJgCVzlw/u3kkLvF7EX0uUSzQj5ovXhsyRaW3w+JgQD2C7bxhXGn8f1jV0Z2L0Bg00Sx5344K+1+k0ls1yVfAYqtSvv1HOUnR5Nwppz5dW3ZPl5ULq4I1tZs6EnqKIOgXVHgjvrBcq901khtqVFptACM9YXT7DQWhAcZ6vT8OMw6aIKwLpoDS1GKSHxLiTUvnrLpH8ZPJNnT1ipqmtDVSD7/he5cH8wubx7yfixpplYUfNfU3XeEY8BG3Y0Vs1QMQ32DOza+OOzXD2NcCAMC6tSPrs8RocW3jEhCM4CnRJzh0WaqJyxl3CdKjsjpSRsrniw7Aca63nHHiLwyfD+bXLu5UIaY4VKdejCKr1jGWvpDeN7ckLYUhnoEVA2NZAoSfvyd3ZpMterJem7AAS1Jmxtf1tVEgPxdTN7pulLRgqBOgcHq6+/3mzXd2v784J3nYktwIcTqXA7504fG+aNHoQDzi8jasp+WuyvYlgywYoxmWt/htNMqLPwgr/vsKCv8cI9s58JYX1MEjqbTu65vhwgtAaxK9VqXW3h7KNaspu1APEvjKwXu8OA7MEumzcCbbdWvysI8bOmCZFRTHoDGAzwhGcqdsWgDRijx5q8Si6BMggfrd8plh01viadf7fhvIseGqXEzi72TO0eIx0sZTCc7Gw3J1vJH5R/rZUU4kH2R42quvjx2J2lrGPbyU+3v6Yy6GPn/O9Ub1+MdzkmM7VRcmI7c+g+YykG
 /38/Qly/
 6Cp7jUJXtv1caCkoO7nOc0LkSvYxg9W9qJSPDgnn6c/cIOTz/RbnXWzYWair1ZiFESb2Ll8zl8MnX3lpbUi6oXh24N7AV1KfBQCpEQ26AeOUtqGZcD/z28Vkc088fG/CDPguKFsPAmVbx4GOh9EQCBL//AHNFvZJxWPCJH4lYJ76NyQT9mYmcPIQJqSOWyPtfXic9BUBOtymyT1AuOjHjQWPtGLSgUq81nrIk+GOVVa42BJyw1uv3a3WRZjpsvz9O6xNvU8eBiwuusW1BVvHCl+wouTAhmbqCp5zIRKpX31aD7pyBZv9xYclkQ+V1XHrP4LXVfumeULLE3NU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 13:33, Muhammad Usama Anjum wrote:
> On 29/07/2026 12:05 pm, David Hildenbrand (Arm) wrote:
>> On 7/29/26 12:13, Alexander Gordeev wrote:
>>> ...
>>>
>>> May be we need the generic hw_pte_t implementation as { pte_t pte; }
>>> right away?
>>
>> Indeed, that makes sense. We just need a way for the architecture to opt-in that
>> it did the conversion.
> Yeah and architecture cannot opt-in until its converted. So we should leave
> it to architecture to define hw_pte_t.

In the context of this series, we should have something like an
CONFIG_ARCH_HAS_XXX and select the definition based on that.

So we'd have a generic variant.

-- 
Cheers,

David

