Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3D56C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E6F16B00A4; Tue, 22 Sep 2026 04:03:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BEC46B00A6; Tue, 22 Sep 2026 04:03:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FC146B00A7; Tue, 22 Sep 2026 04:03:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45B446B00A4
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:03:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C5AFB8040C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:03:52 +0000 (UTC)
X-FDA: 85240659504.22.9F254E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3621B40004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:03:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pkk8hJkz;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790064231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iz5ZvXuN69BjPyv2G6HIms6qrpA+v8co7aU/JAxPMNE=;
	b=6FmxISjHdhra6IzNTGsYBZRYxCEsG/Lj5wtnjxtua+idlMrVnL4ZjoxXEDxFaoulpPSG1K
	xkP+PdE6k0bLuTrbdtQwj8g91DbOqFLKhtnbBfEyRH4VkBJynbpYBKPTQQt50oAYtY1mMi
	HonLjDSIXPXc/t9pFX4z5ets8CfELUU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pkk8hJkz;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790064231;
	b=TuhwRzTj8AZ4HhwHaUEBPriTjc5x5D5lQij8MeojQ6yHkYZChgJHL6e2DTW33v9+ODKgSf
	ml3e7JIAOZmrmRJUaHbKk3sL1BHylU+s4EIY0wrTBH+jd6+w7SBMf4djTfH6w8YiKuSVTB
	xPpTms64pQYNGa2qGRWIAmrBQohIP9I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 627286053E;
	Tue, 22 Sep 2026 08:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1991F000FF;
	Tue, 22 Sep 2026 08:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790064230;
	bh=iz5ZvXuN69BjPyv2G6HIms6qrpA+v8co7aU/JAxPMNE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Pkk8hJkz+KwRWDTWURSLDurufWOnqDbYDUTIZvYXp9jfWOkdjCM/lvETnNtDoI+LS
	 weuk7KILNbiDpsCFZUmltc1Xv7VITIdVF1H2oDuxtlrKssjRaAsgmNRV2hAr5C4SeQ
	 bZ/80zCO8tXpnUnlLHyelefCFy8yEvMbmP9VMlwSO1DLccj29DgxZ7QexRl8x2wU7k
	 fTdqHnUv9AVXxk5dnorcXIFA8Peq7IgJWCVjlGznMMm05cuXM6uyfS9EWxIwApJwpK
	 DXsQ17/1MOkMBuP4zJ74q36cN6eF1s7VZkd7lMrYU+rofAevR3gfQLNsSR3/mGgEhl
	 sgglkuVP99KSA==
Date: Tue, 22 Sep 2026 09:03:40 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: linuszeng@tencent.com
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Maarten Lankhorst <dev@lankhorst.se>, 
	Maxime Ripard <mripard@kernel.org>, Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Oscar Salvador <osalvador@suse.de>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jingxiang Zeng <jingxiangzeng.cas@gmail.com>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/6] mm: memcontrol: implement the memsw limit on cgroup
 v2
Message-ID: <arI2So8-IHlUjuv0@gremlin>
References: <20260918-descriptive-name-v1-0-dfcfdd91b456@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918-descriptive-name-v1-0-dfcfdd91b456@tencent.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3621B40004
X-Stat-Signature: opwe9hexrbiag9kjwhpcqm1u5ik9b1se
X-Rspam-User: 
X-HE-Tag: 1790064231-56491
X-HE-Meta: U2FsdGVkX1+YXvauyJYF73FFKZap9mPWe5YAJf0k5CKf6i0Zo2aoV19KX5qMOJ8h0i0oKNuo2tWGjiDMVG1TTvlEb/gQZZh+u1pNJCG1q7zcm9ouxWmOV4WJojuT9UUZbM8TMKniXhBpw5FfvBeRVv/Dv2emkSTOFjeUOnmHGjVJdMIxcVjGBNvowNH/RQnexHeKXp8tzpXVnqaV52uezIjw1UyXydBBUrgU/exKiK9lauJqMESkk7wjNjJWwVsuVr64dE6ZdGIeaj4tMfRqumMiA2sTSnA8jC6mNqczA9Dj85sSLzpApKfzrZFLdiIyGgast63qM82lISErX6YTWzzt4cFQ3HP6MPkdjjpr+VQbfDGbu8q8bKzTYQ407HUgSLXLnfY/inak8Kt4kqyNW3R9C0IgtwxCQTQweMFN4aCbbulUbQ+QolMttIlnpFXSJWUfzrWJlVU0HRNfgPcLSBLpLJC3V3dnxPDFQJjTuPxqlsyQJjpuHqwkqjbZZlVlCy5pHGQto2egdCrM48ofi1XPGR3yk9fJgPKNHYygwQTDMhdIqogReJva/I4E/EmXBY5ro65Za0amj5VSWgv6+fgJdJysH6aSUyGrVj0vdEvzYtUN6tW7ffrz4SXFcXGG4wzkFeeI1ZTBIzZLUtPtgGkBYxu07ZUBuJxZly/ji2pRquXs/zx/eEUA5kjiAcJi17X5UN/+0wB1KFcpuq4aKlNjEAl+OlTVGqfKehMMPgPT6C8NJKaVEqnR06Pm2pbKvxIss8Ck1MZDCISryxzuAjRVwIDqlJonlG2xmXn9hCHXIKuSfvgQNGTu5KyXFTcNE4fWf6xfEoCMMlxgsq+Cd7Dv3sBbXnJvSchF8dVM1fDHUomfC1u1LKXvUAXaEGZLpvHS3NgqnH1/aM5Wjauj05EfiLpEhcoIPrVBD0t75HjozlQ6RuiNS12O2wvqI6vE5CUOF1jR98H3U8+JGXP
 RwwpgvrD
 wp2jR/k589eBcmKN7MuSCl4claX/cLoQguan/Bd8/kouNrebCu+fwBZPWpyYGaiaqiR/2jhAT6i4m7bBkHA3imGy9xr5hBqWMMwD1wZKyZuGIaEsR8JnVe9GLokWoobZBJM3bxjHlnFBpIG6rR5kKAHz2A2r/Fs3jnXAhuw0wLzMlCUEgVPiAcnNFfbiJHLFMzaa9eh+OwX4eRVNoOnED7zqRKYtmm8Nh03UvL4oHV+37/VvXuICg2RUadrIXljSw+fQblYH22z7iVlafX+g4Cn0qsF/l6BwW4fNQbN0Z7hXjxzUup7edKzk8OjnLu0KuLvUQdJuqezK9J7S5mnikFbc+/bG0hx3UjGItBqRccxGhXXRjgrABuBlHUOhHQZ9ch3pnyw8wm6g/2+2tMHkQ5hbabw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

For one of several possible reasons this mail has triggered an AI
detector script.

Note that, while we are fine with AI assistance, it is kernel
policy that you must disclose this with an Assisted-by tag like:

Assisted-by: LLM

See https://docs.kernel.org/process/coding-assistants.html

It is also kernel policy that you must fully understand and take
responsibility for every patch that you send.

See https://docs.kernel.org/process/generated-content.html most
notably:

        If tools permit you to generate a contribution automatically, expect
        additional scrutiny in proportion to how much of it was generated.

        As with the output of any tooling, the result may be incorrect or
        inappropriate. You are expected to understand and to be able to
        defend everything you submit. If you are unable to do so, then do
        not submit the resulting changes.

        If you do so anyway, maintainers are entitled to reject your series
        without detailed review.

In general, if you are a newcomer to mm, we expect you to do smaller work
before moving on to larger changes, so you build understanding of both the
technical aspects of mm and how we do things.

--
Cheers, Lorenzo

