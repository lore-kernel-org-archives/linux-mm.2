Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CD09606EE86
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HtVoaHDo
Received: by kanga.kvack.org (Postfix)
	id 9491B6B05B4; Mon,  9 Nov 2026 07:48:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FA826B05B5; Mon,  9 Nov 2026 07:48:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C1A26B05B7; Mon,  9 Nov 2026 07:48:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B3A76B05B4
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:48:16 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D6D881C3FED
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:48:15 +0000 (UTC)
X-FDA: 85415558550.24.E7C7AD9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 077AD40005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:48:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HtVoaHDo;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794228494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tR2fXYvbYzceYpXDplcuWbUFZ68vlDLDkowV6ErqxpA=;
	b=q7IHCvR/90QgMLUxTvgFLrjczCIZCuRtOWDkTRdQVKfEPSNuTYCfuuuJrna5g5V3wuWphK
	zs4tvSCWFUdnVnoI0wBK4R/yDCVdmBXioSNz8Iw3oZxv/rRqHdHSnCx/wZ0iAxYHefZX0V
	XLzy/kp8wHrIxv26obHzisjKaRfqf+4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794228494;
	b=2SPM+d7NZWnAygNGqUb+E2fzZ3E2uuOAxYqK2EvJ2Hlo7FmOXjLiUHlYQoXnIZGAVjJKNH
	q4PrGLrPrghMEweNJAYxNUwDso/TIT5dQfvofD7zkuAy6NJQyElPUS9j9jrOOqqTH7GY97
	ZJT9Mj/rcGs77/pox/sX262RRbLYHQ0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HtVoaHDo;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 476AB437D7;
	Mon,  9 Nov 2026 12:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392511F008A1;
	Mon,  9 Nov 2026 12:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794228493;
	bh=tR2fXYvbYzceYpXDplcuWbUFZ68vlDLDkowV6ErqxpA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HtVoaHDoc1kU+xDJjyUeaPgKzzK84HWxKjWBFjieuSF10g9LLyEHGl9ozCguORLVJ
	 d/Ucx214bDxbbrIK/uR0dBY3S5DNSioDHu+ldgPkQOTfZyMLyO3jsWIh38SfW31/96
	 Qwcf6J8TgeevGbjgPWsbpmOldWrrva7tJqkcTwpvPYSlDuC9jd+YHfTNrgmywKzI9m
	 rlWPOqnZSFdK2pD7Cr57Xgex87oxYNg7YZMPZRRgXHY/UIQhieLLx4h80U5R6pWK6C
	 1OqX6SZuQ22bSvpkrLi23gfRgQScLjZ/QH+B6BSHGByojnfnj4lV686wReK9fmXRK2
	 YvSckuZNyzZ6g==
Message-ID: <e5045cba-d7b7-40f4-b0e3-93f919617a23@kernel.org>
Date: Mon, 9 Nov 2026 13:47:54 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/47] mm/rmap: handle device-exclusive entries in
 folio_referenced_one()
To: "Garg, Shivank" <shivankg@amd.com>,
 "pratyush@kernel.org" <pratyush@kernel.org>,
 "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
 "xu.xin@linux.dev" <xu.xin@linux.dev>,
 "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
 "baoquan.he@linux.dev" <baoquan.he@linux.dev>,
 "riel@surriel.com" <riel@surriel.com>,
 "usama.arif@linux.dev" <usama.arif@linux.dev>,
 "mhocko@suse.com" <mhocko@suse.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
 "pfalcato@suse.de" <pfalcato@suse.de>,
 "kasong@tencent.com" <kasong@tencent.com>, "jack@suse.cz" <jack@suse.cz>,
 "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
 "weixugc@google.com" <weixugc@google.com>, "kees@kernel.org"
 <kees@kernel.org>, "liam@infradead.org" <liam@infradead.org>,
 "gourry@gourry.net" <gourry@gourry.net>,
 "lance.yang@linux.dev" <lance.yang@linux.dev>,
 "jannh@google.com" <jannh@google.com>, "chrisl@kernel.org"
 <chrisl@kernel.org>, "yuanchu@google.com" <yuanchu@google.com>,
 "youngjun.park@lge.com" <youngjun.park@lge.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "rakie.kim@sk.com" <rakie.kim@sk.com>,
 "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>,
 "rppt@kernel.org" <rppt@kernel.org>,
 "axelrasmussen@google.com" <axelrasmussen@google.com>,
 "jgg@ziepe.ca" <jgg@ziepe.ca>, "willy@infradead.org" <willy@infradead.org>,
 "osalvador@suse.de" <osalvador@suse.de>,
 "surenb@google.com" <surenb@google.com>,
 "peterx@redhat.com" <peterx@redhat.com>,
 "matthew.brost@intel.com" <matthew.brost@intel.com>,
 "minchan@kernel.org" <minchan@kernel.org>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
 "will@kernel.org" <will@kernel.org>, "hughd@google.com" <hughd@google.com>,
 "nico.pache@linux.dev" <nico.pache@linux.dev>,
 "qi.zheng@linux.dev" <qi.zheng@linux.dev>,
 "baohua@kernel.org" <baohua@kernel.org>,
 "muchun.song@linux.dev" <muchun.song@linux.dev>,
 "harry@kernel.org" <harry@kernel.org>, "nphamcs@gmail.com"
 <nphamcs@gmail.com>, "dev.jain@arm.com" <dev.jain@arm.com>,
 "apopple@nvidia.com" <apopple@nvidia.com>,
 "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
 "vbabka@kernel.org" <vbabka@kernel.org>, "ziy@nvidia.com" <ziy@nvidia.com>,
 "shikemeng@huaweicloud.com" <shikemeng@huaweicloud.com>,
 "npiggin@gmail.com" <npiggin@gmail.com>, "ljs@kernel.org" <ljs@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>,
 "kas@kernel.org" <kas@kernel.org>, "mhocko@kernel.org" <mhocko@kernel.org>
Cc: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "josef@toxicpanda.com" <josef@toxicpanda.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 "usama.anjum@arm.com" <usama.anjum@arm.com>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
 <20261031-fixes_core-v3-9-d6437171ecc3@kernel.org>
 <50c50262c50da19f6a2b27f848324772b0e3c707.camel@amd.com>
 <db93735f-2452-453f-bfe2-f1cef00f143a@kernel.org>
 <7194ff7d170f8b47eec8361fa9e195ff2d1581c9.camel@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7194ff7d170f8b47eec8361fa9e195ff2d1581c9.camel@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: f76tkyb9j7sheb574wra1tq9qgdt9q1c
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 077AD40005
X-Rspam-User: 
X-HE-Tag: 1794228493-277495
X-HE-Meta: U2FsdGVkX19UMyrgfq9gz9aw20ze+394W0OUEgC4JIfeFAmGTlbly7M5KwznE0ICFA8Eriwm/87MvyaBjNTaPGJA1P3qK27HiSM4T4PXuEU8WHjNvaGWlmUlnN9ryEoNYObhqs9vXqDEnCzVoyVtzMubePieCJzUOa4Uix8D0+0T/+Ln3Y1Jjf/ccMG/oR1sR5e3x6JDy+cZTrsUs/gHnDOrCbsYKGzX2OasW8Mfy4mDZP60e5p8v/iOcEa8jD+Wx5ysZwuT5SArE1Q3uq+tAtGNOpa7hR8p0LoGif19dey/iOREsopoUHjhbeNDd3lGZ2cj/aPlpxasNwf6Po5zu1T2HEO6jJ7CwB4QX7hI0545xaNYcWmXA3ptC4a1C4gGvW6G/OTZtUl0q2jDdE/kGzMYJkhhhcu01KYpliCOFmNmTjTVMZ7Qu5Lq5vosx71TiKuxE4Bl3Zb9a/zyLn6dZiT2o2HMWZ6di+VFop9pCH+7GFwA8cL7YocUwv+HaF0DgDEekvsB75bzQm42XZgUE6ZNs7swC2WDXYR28uVVFIHiv3X/vbB9Arue7oQzoTsqERDhMKqF1G/68BA2gzwUwIN2LmZ278WcXmtte/3DxzC2oVWAOVrjSF8fZJrcw7caCgSmXXc5rpOLO186MUjvROKkCyVRPVQb33MG5bYhH76osZZyseVEC0Om7yY8dh+IQP58B7JMnZQ8jfYrqLZzpS/YEB1M5QZ5WfaizZlmO5oVsEeBl5HwkN8YMAwpLrAbzq0ju+iQZ6LpVF/th2dLeRVDgMtYqpl6wB3tjWupGyTokdzfSAc9pPd1Nv/AfacWyeb/CQVsjJAQeonu+xvxH2xV9NS8QUT54+mTBFbirw9VTv0/46TjRasK1BqdN+19l8AJglafdZ9jZJniTZBy5WtuBVjNMxn3B+lEjtlc5YyN2SJ+B8ihJ3VTL2Ipa0lcKVg+37+lrJINTdEN/if
 Cv/gKZp9
 LcJ+YOSZRMEcJho0aoownUVmae8tMMgUhYFS1pEjRepPdGubMnA71luBi1z0a0jLwPV06CA4dCaL8qqlyMr/fuAplDDJfsYSpUarzfQtn9B1hFVI2+xInMwsvLl37noK/tyqyz65s3GRgQYD8lJzM0yNwZL345HFZz9nsr2DOrM+7zBVVieOuLOJG0Jw7KxF+x7LD5Fnzd1c6qMCbcO9oOGHi1Cqv823aXV/nQSwrh5CR1pP3oL6x5Ga/m10SfShmigwlzrzINjOHhzG3j058sXDLOAMSRitpT7YJKeAmo8Ez8oyGE60LRriQ35UKoizio+zyt7qdSq3KpcZL/tvCii755lgRCobtQ7OqNE4xkoWI92WJX/R+CPa3X60HzXzdqHfH34mNsF8oKZRpP+ClNJsm9E9S+UKcmb9VpdPFK0RGJQY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 11:30, Garg, Shivank wrote:
> On Mon, 2026-11-09 at 10:51 +0100, David Hildenbrand (Arm) wrote:
>> On 11/9/26 06:22, Garg, Shivank wrote:
>>>
>>> This was the only caller of clear_flush_young_ptes_notify(), so this
>>> leaves both definitions in mm/internal.h unused.
>>>
>>> Would you prefer to remove them, or keep them for company with their
>>> still used test_and_clear_young_ptes_notify friend?
>>
>> Can you send a cleanup? Thanks!
> 
> Sure, thanks. Will do.
> 
> I'll include it in V2 of my previous series [1].

Please send this one separately against the core.git/for-next branch. Likely,
the other series would best be split up for MM components to pick them (some
stuff can go through the page_alloc tree, for example).

-- 
Cheers,

David

