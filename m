Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DC2C606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 09:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RQYGohhW
Received: by kanga.kvack.org (Postfix)
	id 3AD176B05B0; Wed, 18 Nov 2026 04:46:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385516B05B2; Wed, 18 Nov 2026 04:46:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29BB66B05B8; Wed, 18 Nov 2026 04:46:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0E356B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:46:46 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D659A826B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:46:46 +0000 (UTC)
X-FDA: 85447760412.13.5DAD380
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A990740003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:46:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RQYGohhW;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794995204;
	b=gmdK9IaSQpMpo3lyxPj6yvvhOEFRfTEHpdLks14EUoXYTEKpcPe6+9RmXh8w2vDnb1doOT
	X+QpBC/6r/dQ5qG4G6zsmEo/hs4zbJLvvQpVjwToVXFDR7iTOWovZ1hT9CHseu5BL/rEEg
	M8HgyB3Ba7z/+S259AisAobnl+Ml9TE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RQYGohhW;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794995204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CtaieybfS6BQtpEqYoffKr95cQJaQPqI7rmHn30lmpg=;
	b=PGlaokksGEhhu7pDMYdHwSaYCD0OJQUtl7X9pZ2cFmon2Bcu4C+TkxKql8ODTRVA6B62/Z
	t8RT2at2o63ruiO50AIeZ0bukuLnSFN/9dSg982BSN/3BdC10OIRVFxBoB1MeyGW/csAT9
	xtjwaQ7eSYAlOKldwtp22x2TZSQJxTg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D34C94568E;
	Wed, 18 Nov 2026 09:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1101F000C4;
	Wed, 18 Nov 2026 09:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794995203;
	bh=CtaieybfS6BQtpEqYoffKr95cQJaQPqI7rmHn30lmpg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RQYGohhWWhAMmEGxIAzOYr6Fx+D3c8etuGKHMFcbyKBYk19gb0PmTU3vg4xr2/6an
	 SJ/qop6o7easXoypEONyiMJCk8cgR+yJjAnGlWhqyYJ/ziD1aNlj2ESpXtYiDNRwlj
	 e5B2ZdNugULbszT5sBs7bvHePzJ8bmuqz1BjALmVdtQaVhFWk40mYXG3RtN1ZfLaG8
	 CO7RPHtrPQW3mS0ouvPJuJjTBrscheUKbE+yzjJIA5+EdbTjFPpS41EOhTYuSfpYXk
	 m2o215lUT4PGALLB0rFVQlxsiCFea6eOd2CBZHCy/6uKXDd0NHCR7gWa9XW+UGFy9f
	 mZGW3Ic1lhhTw==
Message-ID: <332f315d-ea27-488a-9a3c-28cdfdcd5f27@kernel.org>
Date: Wed, 18 Nov 2026 10:46:24 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/7] mm: kasan: skip KASAN for GFP_HIGHUSER
To: Jeff Xu <jeffxu@chromium.org>, Tomasz Figa <tfiga@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Marco Elver
 <elver@google.com>, Boris Brezillon <boris.brezillon@collabora.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Chia-I Wu <olvaffe@gmail.com>,
 Dev Jain <dev.jain@arm.com>, Evgenii Stepanov <eugenis@google.com>,
 Ian Rickards <ian.rickards@arm.com>, Jann Horn <jannh@google.com>,
 Jeff Vander Stoep <jeffv@google.com>, Jeff Xu <jeffxu@google.com>,
 Kees Cook <kees@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Peter Collingbourne <peter@pcc.me.uk>, =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?=
 <ptosi@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Will Deacon <will@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Miklos Szeredi <miklos@szeredi.hu>, Baoquan He <baoquan.he@linux.dev>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Allison Henderson
 <achender@kernel.org>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-mm@kvack.org, kasan-dev@googlegroups.com,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 fuse-devel@lists.linux.dev, kexec@lists.infradead.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <20261116230627.3537051-1-jeffxu@chromium.org>
 <2066d131-f999-4747-beb8-520d5e0ce1db@kernel.org>
 <CAAFQd5DzTmyeVQxNdhdy8pPi+ts1cCgbztVJiMoNBeJWBzjdQQ@mail.gmail.com>
 <20261118012858.289236-1-jeffxu@chromium.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261118012858.289236-1-jeffxu@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hr6nmmf88ax53wh3wnhqdaemqkok3651
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A990740003
X-HE-Tag: 1794995204-782089
X-HE-Meta: U2FsdGVkX1/JArboax11LwXx9h+5vLwtDVjtd4K75sv9QEX7ZQak6dV8gM9cbzSlD1SmJvGgRpI+KxK22MD9DjV7TE1vBh96v5BW9025goTTLd8zN/LbjZSa3etRkIL1V2IXlHPwjVbPOX1wgtuZaTcmZGeN4NUvgkf+VAGG6XSkppqBc9rSUn+4FodgETfp953isTINMryzfMQ1VROJbn4OshJjSdrhdavKRIw3dpdnbFuKa83M7MNP6cdqvIp+04ycDi59oWLM7z61ctp7EmVjUHJ3xyxnh34Xmb89WPsMiYM9iNNCZ6/dY3yAN+xJQ8Do8k/DPz6YiCi1yrYv6KbvYjlB00AwlHFSwRs/Sq2voXi2GssDvzIVBxO5cbncmvxX27htpePQHq6VBmMrsoHFg3QUkJZnH3u11jKCuXLCPNaGjOrv2sT8l0XLB0PmHDBISNF151aQfuuzRFMDpD9ANerX12yw1SWdjnl0gQxGlXZhpQ6Nn5baNW3DsZi6NmIR57V2j7AsX1URX/BXjP0MViNaRl3bjDZoC6PPduJVJwLZMiQwXzB8cnWHnVF/2XRvz+ULW7BuOu2BzMywTpATdT/lY8DSWiTiPZ7DNMlt/ysTBiRYB3FnSPzPYK/ITswACDrSCiIJZBNlboV1t8ZBqbfNdnf2VsNDj47u7kGUyB+7fnPj9h2T7f0JLsxUK9JrISCwjuY2cQxRoHGFjWJ+VKT+pU4y/OoSgPENDe7qFCy7UwRCTRwxtIDZFH6GFMp7hRciFmdF/26MygVg8Tg5y1NXqUNWwtdiv4Kq0lj31+c2T6zrEcO8EWsmmzfw03eUrmKgUugB+58H5pd8Np9/wgu2tQdOoU67lmubGqlCHxi13SDBCuI3poeyICll4cZPeKZ46wnnnQbcg8BaCCctWOvhctMSpFR+Xx0Letx0y/g2RIK/fYytdanNcVDqD+oMgAxsN1/v+e0s+Xd
 3mSbr0tW
 7XHdav8/OauihuXAfi7uWFS526A72Tp8it7nTNF2oPKdd6w4FMlTRwk5iYxvK8/VL06uBhx024dhViN9QSypcjdGMsQvSyxxgoK6rf32FDES1wBRSHqruErhyGzGGrNLJZp4E/O1JMs6S5TAoDHEGvBHI2aJF48L46gKldd8t4PwBPQJjn/Hx+R5wuhy4C4h8QEyq1oAObCoV2LbfmwkQ1zoYlv2TS9ejvvVY2ymXaHRmNey9/7VWGyFanm3dbFufX0mM3/qgY3LkdVcaycUkpXTONXrUAf1Mn8VsNnvWiFerHA6Jh5HkI+HI4IETJiY+iwUpOsxyw/R9nV+zTtwBpCSQsBX3jbZVmVOPgetyGaShLiGuE0L98rp8oBCJSRT3QbCl55jLbLFm/rdtV07cLptbzLN7IBiBrflL3mlZY4NCHLU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 02:28, Jeff Xu wrote:
> On Tue, Nov 17, 2026 at 11:11 PM Tomasz Figa <tfiga@chromium.org> wrote:
>>
>> On Tue, Nov 17, 2026 at 7:10 PM David Hildenbrand (Arm)
>> <david@kernel.org> wrote:
>>>
>>> I really don't want us to spread KASAN-related GFP flags in the kernel.
>>>
>>> There must be a proper way to abstract this.
>>>
>>> Why is GFP_HIGHUSER not sufficient? We were already told that this is memory to
>>> be mapped into user space. Placing data structure on it and handing out pointers
>>> to that would already be a bit questionable.
>>>
>>> So what are the ways to avoid GFP_HIGHUSER_KASAN?
>>
>> I think the idea behind GFP_HIGHUSER_KASAN is to make it possible to
>> skip KASAN for GFP_HIGHUSER by default (for most of its users), but
>> keep it for some of the users which today use GFP_HIGHUSER for their
>> memory allocations, but could benefit from the added security. As per
>> the other patches in the series:
>>
>>   pipe, fuse: use GFP_HIGHUSER_KASAN for pipe buffer pages
>>   kexec: use GFP_HIGHUSER_KASAN for segment pages
>>   net/rds: use GFP_HIGHUSER_KASAN for message pages
>>
>> That said, I'm not familiar with any of the code mentioned by those
>> patches, so I can't really tell how much they would benefit from KASAN
>> or if their choice of GFP_HIGHUSER to begin with is correct.
> 
> Thanks David and Tomasz for the feedback.
> 
> Tomasz is right about why I added GFP_HIGHUSER_KASAN in v1: out of
> caution, I audited existing GFP_HIGHUSER callers to find any that never
> map the pages to userspace and instead fill/drain them in the kernel via
> kmap_local_page() (pipe, FUSE, kexec, rds). Since this series intends to
> improve KASAN performance while preserving its security aspects, and the
> performance impact on pipe/FUSE/kexec/rds was negligible in my testing,
> v1 was optimized for minimum behavioral change.
> 
> Looking closer at both of your questions, I agree that the security
> benefit of keeping those 4 under KASAN is minimal -- e.g., only linear
> overflows out of the pipe/FUSE/kexec/rds page, since none of them store
> kernel structures or pointers. That is the exact same trade-off we
> already make for GFP_HIGHUSER_MOVABLE.

Yes, that's my understanding as well.

> 
> To avoid introducing GFP_HIGHUSER_KASAN, I see two options:
> 
> 1) Simply keep those 4 cases under GFP_HIGHUSER (drop patches 1-4 and
>    7), reducing the series to just the GFP_HIGHUSER change and its KUnit
>    test.

That's what I would look into first.

> 
> 2) Switch those 4 callers to GFP_USER. Since CONFIG_KASAN_HW_TAGS is
>    64-bit arm64 only (!CONFIG_HIGHMEM), GFP_USER is identical to today's
>    GFP_HIGHUSER on arm64 and all other 64-bit builds (and if 32-bit
>    CONFIG_HIGHMEM=y builds still need ZONE_HIGHMEM, that could be gated
>    on CONFIG_HIGHMEM, though that feels ugly at call sites).
> 
> (1) seems much cleaner to me. David, would (1) work for you?

Agreed, (2) looks more hacky and I don't see the value of doing it like that
just yet.


-- 
Cheers,

David

