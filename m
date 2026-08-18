Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 083FDC5DF80
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 08:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA1386B03D8; Tue, 18 Aug 2026 04:50:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E78F06B0410; Tue, 18 Aug 2026 04:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB5606B0412; Tue, 18 Aug 2026 04:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B866E6B03D8
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:50:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 50BC4A0A84
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:50:54 +0000 (UTC)
X-FDA: 85113770028.22.7471006
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf27.hostedemail.com (Postfix) with ESMTP id B0D8040005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:50:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=fXfjY2Mv;
	spf=pass (imf27.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787043052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XwuCqX9TnQYK22XQuTy0J5Z4XyKTmxsVQS4S9N8AH40=;
	b=p9cYLmgc6BGyY8oCcxE8dkyW9iJp9a92GO9CuItXN1ZuBRGVDnXR7HrThjhOwBVHtIAnzq
	JeW280X9AxsWtI43YEobhZFzmzadu6ynTzq3XjF4pDW8OSS7KAhYQlj1NoJntIZvvskEce
	T9JZDGyiDu9lY4RDLtJbUf7/PvRlhC0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787043052;
	b=gVTQUXJnQsaPk5UvTMfz3K0GbeYzgRCgVOzvOx7Y2ApiKPc1G87TLFELRdkDnmL0N43DdY
	XTF+UVA0+SsbcJszGjX2VrbUsMOibbDx1atc8L2Q/fP6RmaiX2kJAYCXUDEU0QBGF0YEf1
	aTzYmCVwN242+0ndoUjqFlZXqyRV9QQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=fXfjY2Mv;
	spf=pass (imf27.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XwuCqX9TnQYK22XQuTy0J5Z4XyKTmxsVQS4S9N8AH40=; b=fXfjY2Mv0jNfdBNs4jH8af4ETR
	3DMxHjxBfw67nU3IlLXw3KaAjLK5HBr3Kh2KFFwJz3xcFpLebIbQEnx6AX0+vqs9J25Pv98lRob+C
	6c1bSrlOPt2oR4XONbyZ9VMvv/mJCWm9+ouQO1WXOIOMSunJmwTJOQbIimIsFMChCBqEsieliDz+c
	X2asfTecb4aJJPY+A7zB7Fkl5I0N1gcJwVEpKqiOfQ5nxHrfDV/IxwAJGe711ZurRx8lnE2735Hg4
	0KvvaZHn+BVTB62j9AFKvGC/pQPWPF0KUcVafMTCNotnKgCBYKjIdD/+i3c8M9rVZpAos7lxu7aw8
	Ci7+LmrA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wwFWK-008tFv-0S;
	Tue, 18 Aug 2026 08:50:08 +0000
Date: Tue, 18 Aug 2026 01:50:00 -0700
From: Breno Leitao <leitao@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 0/3] mm, swap: don't spin or flood the console on a
 bad swap entry
Message-ID: <aoQcZgOO1R26z9Oq@gmail.com>
References: <20260813-swap-v2-0-4a625ccabdae@debian.org>
 <20260813133455.3fe770eadcbe640e6f6c46cb@linux-foundation.org>
 <aoL2hgmgQYk8vU8i@gmail.com>
 <20260817145337.85c945fbfc7e8165ea016710@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817145337.85c945fbfc7e8165ea016710@linux-foundation.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: px595386gwi4utqzfuxq73h6ceodqk8r
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B0D8040005
X-HE-Tag: 1787043052-223947
X-HE-Meta: U2FsdGVkX19mVgvevVOBgtoQ1Kz0aQGhqF5yksPCp/CJiW6YeMmZJokARwPHvvpsit27O/1PSNmLTiUSMEQpl8He1Su65iIUWFQnGqpuff39SkBjsXoUX2XQySbrbqL8sPPFCNlpBw1MiYd4d/0lkUi+Fd0z7NRWG4BNggyVk/RhJVFEN8RztNLFz0jsF8J270zsGJDQ931Lcvzu1X1xMgQy4NnZ8t56q6yFfrugfN+qA3XwuOON331V11romlqMjdVWaxRKwTkeqfcl4Q3osXZw6AK6h+0vfaJy2opKQ+XLu61BGpACKZzqLG6R1TmULPcDl59+9u9AoWqUN831qpHNp2sGcD3weQFeRz5VilAafVoJoiTfS/GSu4D00ro7Clegyn8LL/wXd1m7tc3SAqmVoqcE6OvFjX6ofJ6l2Tg1Ttsz6X1mfpJ64Sl6V9eaEZnccgUo43a2cAg1d+WilTT6KNXalC8alExKi1lM8loi3Se8jpcicQ5uzkJcmCs4GSuzLFOSvOMYMegTVKZ/jLiJcK51j5kh8xlsw48+1O3AWhqZYaoP7YcaY2+5Zdlwp21YYJgY+q0/thIRJjg8tgSnv0p1i+D/S2poA3UGiX/Iz77n4YWhZTQyjNzIQg1sbZub8QnXdUpgFO0u64JCbXOYU82/B8LCOpTz0ozjp7VNkN932B3Nc1kQVe0TGJD79TMCteC2pkpJpe/3HUObwyzvXrgb1g+0/7WL3qLg6q3hKHexSz9/8VV+dwckkVkjCjGTORu3/eTIcs6K/aovaweQD/W07EiU8xeE6Gkn2nz3mmBvpgW+kwyI8zQzEU8VX3MRXboiBqk6L04R1Gs5tWzVQy1vCSVX5s2I9CenNJQd76U3hZU+GPk0bnB3Xz/pmNPKIlNZyEZsmqBKz73WySsMB0kvg+uh+WbJmDrX4EwVoEo8r2e8RKNzez4e19VmIf8J5cLui0ok/KVOViz
 Im9Fhnet
 nol2IDONiSRJHI4pk3EJUz+pK/WHOApqesqdFCaA1zaenqGE/jIu7XIHchl0S5C58EzUgPyUdsEWWngowUK0p+R8jciUDp/IORxpy4LDMOPGTLlMp8J7Uquj+5NFhz9SwjoDaq+s7mugJkvaD83WoV8gyhDfjpLtJdPju9MQHnFG+RkXBUoZMjRego1oTVN7eb+qQHLcmwVg28ADd0Ad6oS+wlbuMCj29BOTiBJsnpiZAMNlSlNCAXCus0Ajoibk2zCFxHGyA2ORsDBHGG1+5R+DXXBvBLK61cCUfjXz2BgMfxs0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 02:53:37PM -0700, Andrew Morton wrote:
> On Mon, 17 Aug 2026 05:21:32 -0700 Breno Leitao <leitao@debian.org> wrote:
> 
> > I think only 1/3 should be getting a Fixes: in v3. The message I am
> > drowning in is the Bad_offset one:
> > 
> >   get_swap_device: Bad swap offset entry 3ffffffc043c5
> > 
> > 63d8620ecf93b5 ("mm/swapfile: use percpu_ref to serialize against
> > concurrent swapoff") added the put_out: label with just the
> > percpu_ref_put(), so that arm was silent. The pr_err() landed in v5.19:
> > 
> > So, if I need to update it, I will include:
> > 
> > Fixes: 23b230ba8ac3 ("mm/swap: print bad swap offset entry in get_swap_device")
> > Cc: <stable@vger.kernel.org>
> 
> OK, so you think that only [1/3] should have cc:stable?

Correct, that is my suggestion. The other patches are more improvements
than a proper fix, I would say.

> > > [2/3] is "no functional change" so ideally it simply wouldn't be
> > > present in the series - we should aim for minimal changes when fixing
> > > bugs, then leave the cleanups for later.
> > 
> > I need 2/3 to expose the difference in the first place.
> > get_swap_device() returns NULL both for a malformed entry and for
> > a device swapoff is taking away, so no caller can tell whether the
> > failure is worth retrying. 
> > 
> > 2/3 adds that distinction and converts the callers, but none of them act
> > on it yet, so it is no functional change on its own. 
> > 
> > Then 3/3 is the actual fix, now that do_swap_page() can differentiate
> > a retry from give up.
> > 
> > Do you want me to squash them?
> 
> If I'm correct above then please send along [1/3] as a separate thing
> and I can queue it as a backportable hotfix.  Then [2/3] and [3/3] as a
> separate two-patch series for 7.3-rcX.

ack, I will send [1/3] with the Fixes: tag, and then [2/3] and [3/3] as
a new version of this series.

Thanks,
--breno

