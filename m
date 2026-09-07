Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0B3BC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 11:30:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C08436B009B; Mon,  7 Sep 2026 07:30:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB9586B009E; Mon,  7 Sep 2026 07:30:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAE696B009B; Mon,  7 Sep 2026 07:30:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9E96B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:30:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 181E91C00F8
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:30:22 +0000 (UTC)
X-FDA: 85186747884.13.68CB30D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5B6491A0007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:30:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D0be+PQn;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788780620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Df9Vs2CsLw1K3pBOS28/RnLUuS1VBAgN7vqlEKdpBU=;
	b=zomMPl85xL6O9wJcyZ5NRz70A51U8/6/JSGI3dJCiSj6MtPdwOAe6CMB0DYhB9zF4TUYz2
	6FNFHHAUlUDPExwORzP5fEnV/lpcbdjdi6FnK7YG42i3yRAvMEj/NjYwhPW/F9dg8xXf3M
	ghGsFthXsHIhnvxfwveU4jykhy02bFQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788780620;
	b=tVMu8+5gHxf6mrfBdWLJmPzNiLyMaMw3wq56tnToelcP2zgWk0UasyuunKyRrom8LXs7hL
	1MtO+mrWxGDMxuUwqXW9Fas48SrkOT7bDBYNa6owtaixblhKqJC7169fDKX+8dhsXDdxPp
	YKwXBAZyd+fRsseZ5HzUkObsAbSfh+U=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D0be+PQn;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E167960D89;
	Mon,  7 Sep 2026 11:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E5F1F00A3A;
	Mon,  7 Sep 2026 11:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788780619;
	bh=1Df9Vs2CsLw1K3pBOS28/RnLUuS1VBAgN7vqlEKdpBU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=D0be+PQnzcjaosyF+C2OgofVECAhlkIznofOYF2lXaw7UWLmROnusM8RC/F15P8YI
	 /XcfgqV8RqudIXVBRYFXDzM5BGBuPMZZeT2tzlmZP840yDtx4VKqKAxvWo1ieldneE
	 2K90uN/I0meOvnPlvsq3qAuYV9DJS2Yxfnqjw+Rn/1Hz5dxvSFGbf2aMVzU4pKuzV3
	 vg7Pefe7ZBLfub/+b/BHOg2CGrk4CIEAL9NbKjA0Io4zzDsrQePpkLJYwR1+5elO87
	 QDruieoxO/+Qvr7hYjvIVwDRS3wTwDccVbD7prhdJwsO7Bv51WKBfn6pp7IGC84ojh
	 gE5Xn5zC8uqXg==
Message-ID: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
Date: Mon, 7 Sep 2026 13:30:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>
Cc: Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 YoungJun Park <youngjun.park@lge.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, =?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?=
 <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>,
 Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>,
 Meta kernel team <kernel-team@meta.com>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 linux-doc@vger.kernel.org,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fiyn65wobm7iipcoqqhhr3bjo1php4x9
X-Rspamd-Queue-Id: 5B6491A0007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788780620-246246
X-HE-Meta: U2FsdGVkX1+SGJCiulP4P4YJWWhvEew7GeZ5UPvGI6n5eooCGY7qemsnj7h4MgvSgwUTrkZ+PYS4iUeDqxmlaoh+XtFeh/6SBdyTjmgbo+S7rkXPndeR+6MIJ01SFIDEa4ZRrefL9G6BS7W6gsbAIZhhdIqvZcY/LnKoB5cmaTbLr4tKtUdCkkGojhztjrD1WbLBFWgnr0GZhUhdRgNynnW8kCDg08YmEhpnnylxGAehmgn0muwwRLXf2j4iKPlB+X8lYrYjvjegPe0KkKiZB6cXZfHOj/q0/yOGCMsvsgt8Ebq1tJbMfdfP8VXU6eq0WEKkF44BOi2eIYgwMyvcDfHR17Pq9vBj1vpJiaCdPtd9FcM/VUSZhOGwWdbx77d6Lme9e2Ua1CJkxFcY7XEll9+HRlRdf0rC/6i1LpJBMyd2/jhk46TFgV146IVM4EcmQxHu4aRsI64JoIZI8h5yPB7s1LrHfuztkLAOVGOFNBiP2HzFtTgq81Q9b6aYZQpIsISXJdA6oY3viGYUeY2lqxpKwl9D8ZK0HJQVaLWgpuRhX28ZBcqwkYrV+azrSiHXUoF1F1gem/7L6NSMWq4RG8GpuSR3D7Lip17+lV+6C/35IXGCPljuIMwcgfOQyker1RhRWtErkpDFnZ4svtZ9ZbeNDWK4VIbA6PqRlM7+Ypole45nmm6CWJFCZIfdIArsVxDmAAZUdMAUybZqSebNuLCUclBzrtj+vWmYX13O3sWAmSLtxKJBMW0gwwSVovD7PkMbrzO57akavEUMJITcqGs3oKEC98aq1TVtbGLMsWgDPY4Nk8jDODUNp2YLnJoYbe06UmK8VAiNPOw7xq3Vp466VgFef3ajDIjlmGSirYjx0uGXUxfY7JGuzXowIDuzwkAHpKSurEPunsMGRE4YOFrmDH/RUNHMAD5dyc6lJfhX0HQwB37Nx87I+gMT579UYifiNXAy1h6QZPPMi3E
 SUUHj80n
 olrQzfDyBVmek0XZ0HO28dlcoxI8fdvcr41lXnVA/hlhUgcIMJpvWv+izbGr9CnyAbAF6CAWWPz/j0eNoqNBChGu/fK2d21A+QO3SWU3bXyvaTasgKDiOu6kJn8wB26vOYCMqzS6LL/8HAOe6KnwgqiDZklIRhgEdCIdISrWM3maPjyYV/1TFY6w+zLMHDwY7CKjI4KTi/TUfA3778tWlOwW8oZ0B8GrCVllCKYWEZTjnqdEqEEFvxZQpl4QgKpcdn6KYhIHsRI4mJNrN2sbvFpxAZx4jeLZumX7cfxRBfiOHYB+zai/0Tw99EVvPmvguxev6wztfQ/LM+CX1EN2GVFtfOB23Q7Yfj3xa7hE+roLT+XD8agXeohe6qQV1yZ4SjVf0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/4/26 23:14, Nhat Pham wrote:

Hi,

> To Kairui, Johannes, Yosry, Chris, David, Andrew, and other (z)swap folks -
> I need some help here.

I'll mostly ignore swap-related stuff because (a) -EBUSY and (b) we have quite
some swap experts around :)

Reading below, I do wonder if the swap subsystem needs some more coordination
and collaboration?

For example, maybe having bi-weekly/monthly meetings to get everybody aligned
and uptodate could be something reasonable?

This approach has proven fairly helpful in areas where (1) multiple companies
are involved (2) many concurrent development is happening, and (3) people have
different priorities and requirements.

Is there already something like that to organize development? Should we get
started with that?

-- 
Cheers,

David

