Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98859CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 09:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 760696B0088; Tue, 29 Sep 2026 05:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EACF6B008A; Tue, 29 Sep 2026 05:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58B786B0092; Tue, 29 Sep 2026 05:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3234F6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:27:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9BF20A044B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:27:36 +0000 (UTC)
X-FDA: 85266272112.11.7EF0C98
Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	by imf03.hostedemail.com (Postfix) with ESMTP id B2FC420008
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:27:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=y6U+hzZo;
	spf=pass (imf03.hostedemail.com: domain of leizongkun@qq.com designates 162.62.57.87 as permitted sender) smtp.mailfrom=leizongkun@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790674054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AWUWyJ+l2DRWxplVbMpUfprXcHiO+Hhgpwu0TEAt2Ps=;
	b=Nd4kDjidFb03DW2XZgAKNIZbJJL2ePeGj8YO4LCtLjX3cQYRkqNot3727bzpOf5ucQUJ/p
	bq6vdLigNuElThl8EqtKNB9dfYlQ/yXyqjs4AZQQ9Vqo55MdUXu2HIKfibAVkzXHZ6ewAE
	yns391emLCL5Ris9MWSaHg/bm+/2JcY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=y6U+hzZo;
	spf=pass (imf03.hostedemail.com: domain of leizongkun@qq.com designates 162.62.57.87 as permitted sender) smtp.mailfrom=leizongkun@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790674054;
	b=8GwcAF9n6q/SN5phkkiFR1zGOhdsmBGDrCYEoU7e1YQUNEXmSDrauan8rKbtGDFEk4XJhg
	XTU/GdYH0E1yCfN9d4vQ1UBVFGFSAq2o7fzWPEZkKTcHVN3rQNDcp1N5iVH+ClCHuSJUJ1
	xgwvy5R+o2/wKlN/du9+Ysp0pC5oqYk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1790674049; bh=AWUWyJ+l2DRWxplVbMpUfprXcHiO+Hhgpwu0TEAt2Ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y6U+hzZowv/kQXd8zIXhFmREZFa55LBeSbfxK/Vg04f/Ev012G48P0Ze/zNpg7uKQ
	 QdjFB3fLmQVjG9IdWaKkfK0N6S87t15yL4rpsr34RMei3oR0e3boYb4vpxVhfxDqzT
	 p/NWNhvB5PkXfl2jnSjwUAdtJoRJlZneJnxthsVc=
Received: from lzk-B860M-AORUS-PRO-WIFI7 ([2409:8a28:a83:5ba1:514f:5353:e14b:594e])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 6D804811; Tue, 29 Sep 2026 17:27:24 +0800
X-QQ-mid: xmsmtpt1790674044t61f9qe0i
Message-ID: <tencent_FC17069F1AD34F4E65F6C8DB7AD5ACEA4408@qq.com>
X-QQ-XMAILINFO: NG+oLgkBIWry3Wz4maLN7rRkyN41slc9JvtS1xFpKIhL57k1NV4x7PDHWi8WdX
	 o99f03YS8qokgloaivFfemf3brjidrYniLNj7+KxYFNhw0/N9KVKX8GkuqHRb+re6xXkmIU5x27C
	 X5jkJo5iGDhaezZ0jkbJNVDNXP3oTQD9fmVAd3LqwdV8IBezdHn/pcY/aMY7cFbHd/BvXhXapkPW
	 UCEl/eIN0mAekh9Jfjn6t6x8et5fXKjVQ1TUOvztXip3ThfvBaiHrKKmnf1P09JG+iCxq252eLGM
	 vS3J1QxzZffF1CHsBz5gLpW7mN30Zc1rrCXWf3/kLo1tKZweSS7KsGkJkh/6xoqL8AGjeKZsu7zV
	 HBsOsp1tzyturg0vdJgFV1SZzHbjlsrz3edV6zJkhyCLHihNLSXmdEPMGRx/dtBPRtoAGH5VtHyQ
	 kTLtKoEJoYQoOk337rRVtGGObqJhxKRZw6WaI9xmIy6YZmc+8BFo+h9evPVAjNLVUnRC7n5qqr1h
	 tvzD+yDaETQVdVKaZvIRwrTrt5wnzxPbeWr+X1k2mXNv9VPyKFT4JHIfuZEd/+m5h4MlldUkxIFu
	 SB3izGdEElpPErImYCgB7E6l6G25RIrtipqueulmDzPA6IHriiKKkJBDRnAhVK78rV8VokJ2u/Oz
	 Exv0sGBIFoY0WoiBjU+WV3rgOWAbb1tqv2VhFNmDUQSR2SYz92mLMUP0tciXX758vUZtSesCsxXo
	 ChFFeZ1sFeDKcKKjZsoWFEXlecDNu9KKy5DnvmyMOWxPOAm6xmJjydotxUEihoWKMrkWGiCOJI5Z
	 Bk4hUE+kQ7PfVJYW6mjIqxL0QIRLMJEz7Fg126fbGnxjLXLdzV7ejO0UhmkCXmEXLpZ7mZWZk1LE
	 7T5OM32oytXF69Bu4fMDG2raTMAH8X/jkhxZc5hiItqSCM8bT4Il9qrOXbmWL06Ieufz+3KGzYrI
	 GauRTZL+NZAC24JEPKWGdARnDtHgNr721bzXcb6ZX7D/JAadiueABo1sWIUyRJv+MF6HvTHVDzk+
	 dcUOYyCHvydM3x5qkRxJr+4F3oXORLCpQOU0NvPs8yEhetcP6osu1AXWc8krMaYxWdqez/HaTMgL
	 laPnN9SD7iTiPEADADvS1cEkTWJXJ664WN6fJbJhkP7tMO4Qtoc6oM+/hd1W7mFGGL8NmCudsyFD
	 6HgFlNyPgZkduHYUWYQJYYu6fiULY9iCMKizI=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Zongkun Lei <leizongkun@qq.com>
To: David Hildenbrand <david@kernel.org>
Cc: Zongkun Lei <leizongkun@qq.com>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Kairui Song <kasong@tencent.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Hugh Dickins <hughd@google.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] mm: swap support for hugetlb folios
Date: Tue, 29 Sep 2026 17:26:30 +0800
X-OQ-MSGID: <20260929092720.544090-1-leizongkun@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <d8646877-4975-4b2d-9255-9285414d65cb@kernel.org>
References: <tencent_501F9D3CED07B66BAA97D5352FB63EE1A709@qq.com> <d8646877-4975-4b2d-9255-9285414d65cb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mote68o7e9iuidgkupxcmf8tbucu1ri7
X-Rspamd-Queue-Id: B2FC420008
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790674053-750379
X-HE-Meta: U2FsdGVkX1/cxo+6Qp8n3ex7Kkj7Th1InpKwzfsve2o7hsomeSXC4q0TeWlrKIJKt35GgOnFHm1qw3xuCCGSVK5JgaJOy1TkqxxPKoumjcPCf9Khq33l29n405bxwzB0XvoYqDpnKAt5MFxmqJk5RFiwjmt/KxWrL/kCt5jymLroHH2aX0Lp4n2/ashDiEKKk505lEFIk0KvlXqqCXdWA9u5CveC9OByaDPJHUbOlKrfm8XdG6ii6U39371yzkYzxK7EyPx3fLX0OkirHvz1WDH0moVVtOcz3XiXnynaqMfm0eznxdm9NyJOVb6XPEk5xgP3TtjUQch3S98xx3A8zlT4bJ7h8wz9GrTBMg56g9jAi6byYTB9WIYRtPOyn4Qft/2nEc5wfEKsJiZjyVzz6H4WntL6KcjHvVrlJhqh7TkJDqy4HivCwdS4HKZCBxk2td9bp5l9LYpV7Gn9BVvdzpfamNz+bUPIFI1h3NiabcDKPBrSep5X4yPQoF3VAbObztrK/7NdVMO6mVLnHAcTQgeLxJGbdQ1UnBR116cXlRLqMoKHrBuDKQsd/5IoJygEQr/YqUPO+jTOiDRgoia3t/BFdJ1C6KeW57acWtP/QcSer3jhkefv0ppsBd32wgGWo8mWlZpN0MiQphVfY7wyYNTlHPackO/XDmhtKQDJk8RZOhJO2FwdcaZY8GcEq74BMYw8cjggSMNR478cJWt8oaSpe/Tq4OJIIFV3/qN7S96wMKHaWaV1IK1aMzyq6X5y64c/qKPgTkYKc8bxNJ5kRRai05EbfsQxxPVOioKr0fKboUbIYlOq1JnwcL8GVqhDWEi0hXpne3J4TljY9nodmAA3/xErZiS9Bs3LcUk+6gM8uretRYj2QUH1w/fKt8mQ2GIQy0Z5OIkdnWdqjHC9HtHOlM/rkaArH24KtvLjK0Os8/bmU4T1M7QtMHFGKVGSEwketZj6a4wAx67i2o9
 Y0g07bCf
 mmhpe4yshWrvEGoYGXLkU2LBb/RWzSpX0+KUKOaNWbLaRcutHxNUaR7L8QHKQOcdDWgXaQ9ijfDBoTz7AdEgTRk9mRKnqfR1plFn5kePRDAw5gm9G61Zlo27Y153z3xhhtg6aZCT+czCplBmBV6mw/t8zuqNStsVGs4w7554slc1AtTT8J4AWyYAQbDuxtnQaTX/Us7P/7CgmGwK/Bt8jCRJgldNG0A7QBFVo9iOd6KAG/CWOUTrYc7YahgYplBeMmvb6mjEOs/uAkjVqLFRhnJA5b6ONcvdSjxXY79WpF0O2wVg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Sep 2026 10:02:11 +0200, David Hildenbrand wrote:
> Hugetlb is effectively in a feature freeze. There is no interest in
> maintaining even more of the special hugetlb sauce, sorry. :/

Understood -- thank you for the direct answer.

My mistake was misreading the subsystem's direction.  I had read the
earlier list discussions and concluded that the red line was touching
hugetlb's reservation semantics, so I designed the whole series to
keep them intact -- user-driven only, no LRU, no reclaim hooks.  I
see now that the actual position is a feature freeze: not "new
features are welcome if reservations stay sacred", but no new
features at all.

Going forward I will stick to work that reduces hugetlb's divergence
from generic code rather than adding to it, and I will float ideas
on the list before putting serious effort into anything big.

Thanks,
Zongkun


