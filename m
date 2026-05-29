Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5FC0CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20FF46B0092; Fri, 29 May 2026 11:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E79E6B0093; Fri, 29 May 2026 11:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D74F6B00AF; Fri, 29 May 2026 11:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F18566B0092
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:07:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8DC58401CF
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:07:34 +0000 (UTC)
X-FDA: 84820786428.18.0989820
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf20.hostedemail.com (Postfix) with ESMTP id DE5071C0013
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:07:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=YHFXwrZp;
	spf=pass (imf20.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780067253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ebIP9u+W/NdprxD2plfJ1x4u07OsUSk6F8cbjhxlAs4=;
	b=Fve8JiBq7EUvcld+0OdxsvjLU1GCnBALu0e2H/OFNl/842JCOVM1yNNslIxdpVtt0L3SIV
	6m1NudZSh4mgvfiC7ut88HH6vHm+K2egVe1TJBSEQXMBFgH5/hHUaYnrdT+mc2eY9beRNL
	bWmM+iBCs8eIG7GtLlbzZH0ll1uycv0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=YHFXwrZp;
	spf=pass (imf20.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780067253; a=rsa-sha256;
	cv=none;
	b=HYT7aCBfO4oxhSPI2ekAuvQavnRB6lxRHjG/BnvKQ9Yvpaalz/rbcPj9skfNBugx6UB/zY
	Mj7TB73jYgOk0rm430A+KF0mqv3jKN4aubfgohJqw/Eeb9rY0Pa/kcEDOULs+zyq8RsDC4
	I0ajCFQLh3WXz07AKzvj+MEVEeSq52k=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 10C8440E37
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1780067251; bh=ebIP9u+W/NdprxD2plfJ1x4u07OsUSk6F8cbjhxlAs4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=YHFXwrZpXpELJCTLz1aonU6ujOlC3U+3KBMyzDRJIeqAQxcKO89EUcmvxyoUQM96G
	 GofDbotXK9F4W+ymH9hdnOnS1IvDgr+Lwj66tJhtDzp5UmEbp+e5byw5Etm+YfUK7D
	 /Ecut4iJxA08ifiuuZA6Vcwyd0e4utrKgns8b6tGmNx2OtCMX5T+skVL1jEXVmAbCL
	 2QNrsrRMp72ArGrSCZhPWChA7mnro+R7Uv2NUXuEvWX6U49hDb9rCBCBah+o8+OAx/
	 +rLwQA0b7r+EZwuhVhdFVhVfiBkLpFeYS21diLH8um6X9eUyPadg/1mjT/mKpeCdmY
	 G6+x3PczFpJBw==
Received: from localhost (mdns.lwn.net [45.79.72.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 10C8440E37;
	Fri, 29 May 2026 15:07:31 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Barry Song <baohua@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: wangtao <tao.wangtao@honor.com>, "catalin.marinas@arm.com"
 <catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
 "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com"
 <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
 "willy@infradead.org" <willy@infradead.org>, "sj@kernel.org"
 <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>, "luizcap@redhat.com"
 <luizcap@redhat.com>, "zhangjiao2@cmss.chinamobile.com"
 <zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>,
 "hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org"
 <liam@infradead.org>, "vbabka@kernel.org" <vbabka@kernel.org>,
 "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
 <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "jack@suse.cz"
 <jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>, "harry@kernel.org"
 <harry@kernel.org>, "jannh@google.com" <jannh@google.com>, "jgg@ziepe.ca"
 <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com"
 <ziy@nvidia.com>, "baolin.wang@linux.alibaba.com"
 <baolin.wang@linux.alibaba.com>, "npache@redhat.com" <npache@redhat.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com"
 <dev.jain@arm.com>, "lance.yang@linux.dev" <lance.yang@linux.dev>,
 "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>, "chengming.zhou@linux.dev"
 <chengming.zhou@linux.dev>, "nao.horiguchi@gmail.com"
 <nao.horiguchi@gmail.com>, "matthew.brost@intel.com"
 <matthew.brost@intel.com>, "joshua.hahnjy@gmail.com"
 <joshua.hahnjy@gmail.com>, "rakie.kim@sk.com" <rakie.kim@sk.com>,
 "byungchul@sk.com" <byungchul@sk.com>, "gourry@gourry.net"
 <gourry@gourry.net>, "ying.huang@linux.alibaba.com"
 <ying.huang@linux.alibaba.com>, "apopple@nvidia.com" <apopple@nvidia.com>,
 "pfalcato@suse.de" <pfalcato@suse.de>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
 <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, "damon@lists.linux.dev" <damon@lists.linux.dev>,
 "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, "ryncsn@gmail.com"
 <ryncsn@gmail.com>, "jparsana@google.com" <jparsana@google.com>,
 "dvander@google.com" <dvander@google.com>, zhangji <zhangji1@honor.com>,
 wangzicheng <wangzicheng@honor.com>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
In-Reply-To: <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <ahcANgFDFwfC0v1q@lucifer> <b24b4a8198ba412f8b8b42c43dccd058@honor.com>
 <ahf2mJg9OOWvu0jA@lucifer>
 <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
Date: Fri, 29 May 2026 09:07:30 -0600
Message-ID: <87qzmu2r0t.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DE5071C0013
X-Stat-Signature: 4rfc1j1pedwhc3k1tz7jbtda9ig3ougg
X-HE-Tag: 1780067252-607456
X-HE-Meta: U2FsdGVkX1+CmJ+EkIxIkOSgEsElvZb+h8xSBJtzjIbpVErMZhoi2l5JrjJLn4/NzeKz5/l8C6fg8eGAaEF9sEyTexYndpgfj4ZFVx4SoMOnzoQsqR12aMxRQaeilXV2imWBv9jJGnOr+J9jUTMxgO0/ceL9o7DsxkQZ/nVqHW5FzWFojic2Iz6emqPHZLcMNY0xkibehbkKbhcUjLwjl//wgX6JcHZIbgY5/JSWK2E4hLAJY686z+Th74w3uWlbXIDyKqik8xEmYL3OD2XhZd9nqGrahPcVUk2Q8xXw9ib1oDd2bBwfgnDPiMeWuKHvy7a2+M/yIH7y8sw6Yuy0t/Zzz6xQyB9bXh7lGd8kMme6MXAiQfdj1bdJfxkbQdT3uzkoSi+joPezVoelvEJHNKqM8rZ8EN4G+Gpw2EFT4CEyAUMux+suxVCCySy1H+BypNGNs0Xw0o7OUsWLPtPxCXP+eJvNxWOt8ThBG13hcAxQTX1JysfkT2h2bfYrQndom4k+EEqcaP/BSM6CR3UV6f3JD3icXjnWtG5vaoqB0gBbIAKHXY4pPFen1u1KENVZ9tC54DjORi/CWPe6H63iyG6LSqrL5qEMzNVFeDk1QbjC+9Hi9qdZ3dlwDBb5G0MzrEmk0g6fuBE9mxQoxSgEH78FJtkLVtHtlT/jDPW+MnxetCtEcPAi3+6H8xcKbSrVkuU+qSYQH218bVtqI8TgKedbzbryH5dmRb0fhyD6WIGBru3tVv14KwoZOsfDLFQOViYpy7BFx++tKMICrEXsPN3glwf2GX+tXYn181aOV/xjPlkPf7aPGdNIWw0Wj8i6e+5Q2pWOwSuJO3VRSgcp0soJbLjc9YCKcM5OPgE4tou5F/QBiEVCxyMs9p+1Ub0unUHx11/6PvRiFJ9gHWOvCMqrAYMyHP/Vwx8eSK6QKKUJCmcAalQG13sruvtTkzqssQRgzkX4lYfK1RIups4
 xrD41cj8
 kdrbUGAw4mg2XhySHLfIySsedCOd1pylwWLTkDfQyL51MKZV1B8V91MnBNHGhqWnhp/O6SNGzRr6uEJgXnLWGSJpi8AqjUJUhw39m1iH3Q0G6lroj61/9rnWJadWqlvCrkCuoCTmvD9wIqbqfg0ao0sBhIz3dcr0y0m9O/foZS9Yk3ic/Gxf9yS2SCakXcdOkipEyASAPWxhknJDOThBjqFaCkKcPrSIyuLAPaOPwhXewPYvUFnCVSr5g6BOI52J8fPhnTIJWQqh0lwa7O0XyfpSIOBCx/Qhf0BbY0GPOZXnFrSUHBc2mLXr5xTwf6+3r2JbIdZv1HGFSFbE9Mxt4F/HNUtGn2Pii3duUD26IkycG5SWZsztkrrFByvv3FraT1oEp9gYbSdxbPVYc6jikfRvJzPfIPYZ9ruLRKBxkdMKPCx0iVJPjWDWmZHJ0L0X60vgncjnTQT61YobTMm00BjdSVK7u/QvM3a80vfwbk8zh9Hjqv0VtHVviBEMRTjCn8wRo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Barry Song <baohua@kernel.org> writes:

> After coming back from Zagreb, I kept trying to find one or
> two full days to read Lorenzo's code and slides carefully and
> write a blog about them. Unfortunately, I have been completely
> busy with other work. Sigh... we always seem to have too many
> non-upstream tasks.
>
> If possible, I'd really appreciate it if you could take a
> deep dive into it and write a detailed blog post. I'd be
> very eager to read it and better understand the overall design.
> Otherwise, I'll try to find some time next week or later to
> go through it myself.

It's still somewhat superficial, but in case it's helpful:

  https://lwn.net/Articles/1072378/

jon

