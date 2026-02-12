Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD259EEA845
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 19:52:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EA6C6B0089; Thu, 12 Feb 2026 14:52:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06B466B008A; Thu, 12 Feb 2026 14:52:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E85646B008C; Thu, 12 Feb 2026 14:52:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD1046B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:52:20 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 904C057C61
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 19:52:20 +0000 (UTC)
X-FDA: 84436851240.02.CB048B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id AB91340004
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 19:52:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dYk/yZZD";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770925938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tz3scwEwVvm5ZB4c7qt82ffX4arNi8YEwnqePUTGnYI=;
	b=TMydk7RsztZToNTDl8znoGBfF0aGutMNxKmRJVoiVaMbH9Tz0n2tOLweThYzPhrJwcq+Qu
	2hsrc3U0C8GmBT07FilUuEC7pAhzY+JHwZx+VlmNCntbp3bwlWTc/DkQDRx39EVRXLRO4s
	BXHahM3mHSyXTNc1//kbzgFXQMDX/4Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770925938; a=rsa-sha256;
	cv=none;
	b=VlhdFs80W1maOcd0mhp1XmltKeDsTPOVrK00GTkdSlaEhYWroTExzZruWx3rrPegmF0FaE
	mCDHMYBowb1iIIXVVtcC4PSJ48+FRDkCkj86HojpXQP5G60XEAHf2PCtbj6WQlQC26kbDY
	F8UpBJx1xTgWtqAPZriZmiT5a3xV6pY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dYk/yZZD";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8621F43DE1;
	Thu, 12 Feb 2026 19:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C93C4CEF7;
	Thu, 12 Feb 2026 19:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770925937;
	bh=bNrUVodcnDOc6or+W7LBICiQVZVIESPwVSVAWb84RLw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dYk/yZZDHjYU4fQmSbkUmJukd6yIBwnXf2HGvazkW1tlY9AK55hrmuDm8zjLO8ub5
	 ZO/v9bp2K2Y7D00B2zUCPeraHOoMfrQ5P1HGOXJqJnl/7DICWUMDYBYGUS4lXJiJYV
	 1pdLJDBuqpeKva//WaH+p/eUAmjDT0HBro/CmSNfLapHX3B3PDv1P3l8Zp6Tpv+Mwa
	 lWXG0lgf9NP6z6xc8FZ7wg5+D28/Nh6CN7SAPQQ0niASchqYUI2oGQySkR9lFYzimY
	 4pCe3AReGXbZjJZXqzmEUINqU2dC0fSloizGDoSd2wxZHbnyBnaiW749LmRysHOOgx
	 26S93OpiOM6LQ==
Message-ID: <c3cccefc-8f73-4e97-83dd-1a7e4b07412d@kernel.org>
Date: Thu, 12 Feb 2026 20:52:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v1 4/5] mm/khugepaged: rename hpage_collapse_*
 to collapse_*
To: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212022329.18892-1-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260212022329.18892-1-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AB91340004
X-Stat-Signature: pd5xrp8oeii7a9onuod6ukyumy8c78i9
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770925938-543012
X-HE-Meta: U2FsdGVkX1/c2Y7vfL8SLnkQAsII1xaXoB5J2bbR6eE0/qFWhZhXapt2CYGDaSibNcCh/CJO8MJ4djn/Qa7rk0upifKHYq/smXQy+PKDTf1tgJm46H3JzfMipR3HPcoaOwINUOZrF0RT+0Chlr7ZN7AlOe7S+8D7ADOHy+j6caS3mKtG8D19bdrwEE5vuGfvi9O+pMVz0Lz4Q5hEbIiVNktuiyAETqP9THls38Xp9cUzUKENTeWKjK3fqJAHc506seWwUxU/nlVuLnj5CFRnKlWTmANYvHnWD+MbID+DmNd93mTq2Htau/pF9kZoQRWIPlBROu9GAnWLOjWGjXhwf7UkTei2kTKVaI0AKnKyTHnjXak55P8Yer+I5jl+6XXhg1xMmWzinYlIMKHhGGG1+E2v1qI0Dg6ek53+6eYThPblWahozmzcYBOHqpv+qVlDJOD1NcYssOmYNRTVtc2KbbA7veomIXSX/tJZlQ+9J922Gm04b6k0RODd5keMg3mP0QY3cxTYF9E6N2gXCqTF/jlamDrl0xAc9/yUMrpWGCvJBjAae4kmdzUnEVG99LlxGfbGTcjSW/fvaJ1ZE5S4ypWL9+fochTLasBk2RWmCx7dPx2U/4m6QziFVp3gjDU2ZZ1rN35IQJEklebEjRbizwwsaWyPiz/ptDm2llDGq0ehsoGCxqJyQ8yBHE3H/BLY+AjYYIsSwG9DE+jBuQBuWj2loitYWrbF1z1jbS+g0GkkvcUQE9K42XhgzKhpyWh6r1sGYJGn3ShSaDvBC6f1GsplA6uyzd0+cMbIV56H403NBzHVfTwvCc0cXWwfQqn1MhGMV0DcOyyeg3FSobMtZjBvUh6QhTQpK+xrZgli7eAaHxWWs5DHPuvTO6hSG6NhFC2SzRnJNI1Vg6iR0NvxcMAX0lEzadWJshq8cn8RcIYQZCFjGxoqB4U8Kb2YmERzCs1uvXGtieTEsqea37t
 nYeDu4py
 tl7pjYlqgEWgEDyBooAvsecZ9Zd4qh3wa/g47goOAwcSFHS9kRyvPzgmweu0Vq0OzY4IJ8mFgFWntbx6Q7jjmbh1eDqmace4E/cgnym7pTr8yf8foB8h88n83o147LSF2tfmZh4prkUHGgSsaYeAAYqw5HHoWGMdgX2FeAVoCAOZBBbhkui23ENhe7a6EY3nXSdsnb+QsT7rDUraPrMW6NPHKaiji7PLl6h70Ea6Ygh9sRbusalBh/NtAPuVDAk3tdw0mZeMQi/TOyoBIKA8ugtejIFLlJ92UnokgRIVewSLsEjTz/q2mGqhK5AwV1UINcoFbzaF2GD9wU151jtI5KOxvHWtWuaMmgnRoFQs5HcCT+jTdxj+FM1mKIwXcVyvG2W3tKZQRAXSIzzoD/DzWdEEzY4+1kdZ153iyKikbmXv/3VSU3Ag9LUz8B27/I3PK7VFWUe6QU//sSB3Qdc9G7RcviRXsjJ4BSaGirppVVST0smfINfJpliZf0U1rbvO1FLaBrVoi5s6atdg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 03:23, Nico Pache wrote:
> The hpage_collapse functions describe functions used by madvise_collapse
> and khugepaged. remove the unnecessary hpage prefix to shorten the
> function name.
> 
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

