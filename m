Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88A94CA5FC5
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 07:48:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63E986B008A; Thu,  1 Oct 2026 03:48:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F0056B008C; Thu,  1 Oct 2026 03:48:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DDD96B0092; Thu,  1 Oct 2026 03:48:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26DCE6B008A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 03:48:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8522E1A0305
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:48:53 +0000 (UTC)
X-FDA: 85273280946.02.A5055C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id C1A6A40002
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:48:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qygm2R6W;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790840931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mNjIuXpUThvFyotQd9GSbJFtJ0698ZsWlEkeLqDq+J0=;
	b=DWf1Ku2aqS92pM9QziShKSdPKc9udRhBrDth2Ef2kqUMFc5HfPorP8ownjeDKY+4xks7jI
	rHF+S82WMm9INb7rFKii2MwEuqT3j+VXSW+iARJp209tpwyX7Kh+BwLAaWswTh4I5e3YLx
	oDB5FuyfnvstsjwPNr0ODT9+7pzjvgY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qygm2R6W;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790840931;
	b=QxKKhvehZix9/U893M4XnYnUFI+eLpQXSHEvKoeJBQsEwIB2G8eYNZhpD+VwJn6QG3GiDB
	bJyB9PA4M3TtCU1vGLqOobnEJwMJFIgTLEnRRIv9XXyLIRXAk+V54TtZkb6sc3pRmNOX7g
	Q1HjwS0WdvcchvCrUVk9nd7l9iWS6xs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A720601FE;
	Thu,  1 Oct 2026 07:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579AE1F000FF;
	Thu,  1 Oct 2026 07:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790840931;
	bh=mNjIuXpUThvFyotQd9GSbJFtJ0698ZsWlEkeLqDq+J0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Qygm2R6WcC4oKwDn9p3fd5ZxtzzH5bVE56ZCY4ydjNT+BVGfjf1B1VfA/6LcKKxnD
	 fgLc2Ii0Qk1vYBGKiMS96qmJDfepfm6PRk1ZHAR4tc4j3LGDTnbxZaiq+YJwFjnIfr
	 n/a2pBckpty8tFctrBoQ/Wnzfguno5IwnqdBOVPBx3SAgqgtUnlpSpuzYvsB7o6jDn
	 Ntw53BUZ5DWbC9EVG9R+a6qMFrI01y74S36eh+kibIoXFmN+T/24B694H2MQVfF2Z3
	 MOHLkbN/ggiH6IuMJqfIYSI7Q9jpQk5kCHodR/m/MUMeXjbsLR+4k9bgqAu8r5KZ55
	 fxTrgkQDj6igw==
Message-ID: <964df3e4-b9a4-4741-b8dc-cb8ef02adeec@kernel.org>
Date: Thu, 1 Oct 2026 09:48:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] mm: swap support for hugetlb folios
To: Zongkun Lei <leizongkun@qq.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org
References: <tencent_501F9D3CED07B66BAA97D5352FB63EE1A709@qq.com>
 <d8646877-4975-4b2d-9255-9285414d65cb@kernel.org>
 <tencent_FC17069F1AD34F4E65F6C8DB7AD5ACEA4408@qq.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <tencent_FC17069F1AD34F4E65F6C8DB7AD5ACEA4408@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dn148crny5h3af7kdpbxcc5ay9mpbej3
X-Rspamd-Queue-Id: C1A6A40002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790840931-521820
X-HE-Meta: U2FsdGVkX18FxkAqDOoBTkg9nLD0WLBA72AOUr8Cce98fOq46D0SAJatYUl0sPWgJuyyaX6tmPGBtqTsZ7A10SGLJ716yM51TXlXh5Wrian1axYcAzuSWrWEiClolCwysnQWS8C4XwYGL485o3xQ+7EwhQmjKTb13Fu4H7/XzFPnV941nOObp06iI5SYh3ZXVzWjhZdMR0UrMrGkZNBqxa5d0stDAOA6x+6BzimKSR4cqP0xKyUS4lbtQRN/4jfpQJv3TMold1LhyZZL7H2uKsWRZG6QDoD63Tj/jZDWwPgKXSb8Ss29j3x9nUwuxBlL81mb101emKnQ7fiGQaFK5yHlR9jVWIxa1BqgMGoR7oIv3dqt7bZgty+itctVnM+fKHojCX8fduGwq2540V4uREIPgzOaRhwFB0Ivye/guhDHpeFht/EqZVgsaBlXW+KHG0ZZF/N6gHX1XnoOBukjV1fao7B9gnskcAIiHe+L/qRoABs5pXVw+yBxjPMmu8NUdMlp1lCZ70Mx50FU+F0afImwdr4oStLyza79m/Nv6QQZvZDBxR1mXxF4e2706ZQT9vg/DR4c1Ip79354Fi75G9YHusCECuwVm8TF48XSxgfhwqTUD9TN1GZjYfmV6B7zUL5uxywlg5npa4Y3sjxa6v8J3i3lI+ptmmR/QhKWK25ZDN63YQzg3Esa4yl9qOUOmDA9LAMOB0QH5m7LNB3Z6WQxkSxNZ45e7qtVXP6LGVLV+w2rRkWe8xB7am2ZrXzB5sjBJXryMq54OWS9XAmjVSJNLWS+UgatOP2xkP9ezXgtOZcQLMpm+TlA70K4rykZOA3nG4TCpV+KxhKokpQupgX7E5Bh4enmBQ+yGdunvINUQ53eYOSYQA0Ml077O7aF0yJ9wRpIo+nOyvPsTvjFfU2gwa6kSX4ddYRmJVLJ7o2c/vVPR1+ATncUNj+BZjRhJnSr4GYajscJa0ZAl3w
 BJSNODlM
 X4JeH5r3zdANq1dPHWdw5PaAIrbts57chSRv3O6rfok9Ip81bjScYdBdOqdZSwOjd4UFsMDZPRlkP/YancVSZkdKPrlNsiJWaw5aSZDMGXDNYxyPnWWaOKLq1xBuo2BSgNQuq2N8f/HziAZtOdawpTTnI6LWqKlWFRaz1LZ59q2pOkSyb3y6jT5k2LD+idqTK+1Pe7Zy/SUxEFDnVh6psJynUEhZQw6KAIb/lvIntcP9TctivFlHlvCBZSEwQW5nj+sbtTEjFa4R36qFTMTeajY1smGsrKaMgySbYQxJsYg6oWIgO1Rl/jIedYITCPfb/3YsBffd4MyWQgV8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/29/26 11:26, Zongkun Lei wrote:
> On Tue, 29 Sep 2026 10:02:11 +0200, David Hildenbrand wrote:
>> Hugetlb is effectively in a feature freeze. There is no interest in
>> maintaining even more of the special hugetlb sauce, sorry. :/
> 
> Understood -- thank you for the direct answer.
> 
> My mistake was misreading the subsystem's direction.  I had read the
> earlier list discussions and concluded that the red line was touching
> hugetlb's reservation semantics, so I designed the whole series to
> keep them intact -- user-driven only, no LRU, no reclaim hooks.  I
> see now that the actual position is a feature freeze: not "new
> features are welcome if reservations stay sacred", but no new
> features at all.
> 
> Going forward I will stick to work that reduces hugetlb's divergence
> from generic code rather than adding to it, and I will float ideas
> on the list before putting serious effort into anything big.

Yes, that's usually the best approach: if you intend to do a rather invasive
and/or likely controversial work, better reach out to the community+maintainers
early.

Most of us prefer a well written problem statement + high-level design idea, as
it rather focuses on requirements + exploring solution space vs. a concrete
solution.

-- 
Cheers,

David

