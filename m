Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68BF0E8FDB1
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 12:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6D686B0089; Mon, 29 Dec 2025 07:29:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3E716B008A; Mon, 29 Dec 2025 07:29:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4FD06B008C; Mon, 29 Dec 2025 07:29:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A0A866B0089
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 07:29:29 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 516058E712
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 12:29:29 +0000 (UTC)
X-FDA: 84272439258.16.FD5A465
Received: from sg-1-101.ptr.blmpb.com (sg-1-101.ptr.blmpb.com [118.26.132.101])
	by imf16.hostedemail.com (Postfix) with ESMTP id BA875180004
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 12:29:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=M01uOyU4;
	spf=pass (imf16.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.101 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767011367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DyL/G9kKBvpgLEzvxHMBFeQFxclVz+zkzEXVUpDOVas=;
	b=PPFmGF8mjvizCJBqLjZ9IQHRpM099VLRNocvLfhrCzoSJOrZiGGo7W2FGiPSmtK8ACn86B
	XktH747XnFxh96fbA8w2brPX36feNfjanasafc6n+yVsnjxFOYWCu5ilbhDix0Y8sHzOT5
	P8JONuYeiOx4H7A155FriJcomx2VNeU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=M01uOyU4;
	spf=pass (imf16.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.101 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767011367; a=rsa-sha256;
	cv=none;
	b=s+TyrgHW0HPORdyoGi467THY1GkQL+XJdSwkq+/vYjMLt36084Pm125IfrfxQRTXL61qi3
	/pkQtYip/qbMsRhghGFnOhXvH5pL/S9OL+Uhk00PV5sDB056jK6UaQ2AdFYz6ZErXGbatm
	xDKrTdxntj8vRc5ic4n/EN95YnWCwfA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1767011359; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=DyL/G9kKBvpgLEzvxHMBFeQFxclVz+zkzEXVUpDOVas=;
 b=M01uOyU4rGX+GDBWGhU/OG2fBHwrGLqzzCXgUIgaKcQz7eqQhGZF3WUXVTCVG5kAaoBo5i
 qck0IkBFwmpOuKjHl58HrUw59sZ7YbbwgmPbudrgX1RB8Aea+AOGuakaTtt4yqbpeSvnK6
 SlBXftn0EXLRGOAOUTN0itvIpHlxoyqriohmC0UjsZJo/qi9N904PMPLbb4PA4SrQcnHrN
 ohb5rHtgQC8Kt7K2gxMO8e+ly6WF3/zScEXszrbPZehXhMNMhr6UGc3AqbNYOeG0FyMmzP
 33iXBwNEStIWbJioDfb0mGKWLLjNna5AhH03xLyFwprAgNxqdE7I9UeAvZphmA==
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <muchun.song@linux.dev>, <osalvador@suse.de>
Message-Id: <20251229122856.7397-1-lizhe.67@bytedance.com>
References: <CAPTztWZroGx5AqB-2+EmSnqsCRtRjw5uvrNi_h7=JefZURB6Lw@mail.gmail.com>
In-Reply-To: <CAPTztWZroGx5AqB-2+EmSnqsCRtRjw5uvrNi_h7=JefZURB6Lw@mail.gmail.com>
Content-Transfer-Encoding: 7bit
Date: Mon, 29 Dec 2025 20:28:56 +0800
Content-Type: text/plain; charset=UTF-8
To: <fvdl@google.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH 0/8] Introduce a huge-page pre-zeroing mechanism
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26952741d+266501+kvack.org+lizhe.67@bytedance.com>
X-Stat-Signature: cqkkinbuc8o4gtb5bfjfjmp3fswdptej
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BA875180004
X-HE-Tag: 1767011366-963696
X-HE-Meta: U2FsdGVkX18wf+Dbg922Xw2AszfTDnxjnUZgQ6PMbXnsiytLrCa2drKIziOP7xr/bu557YZ+GHlREFtl/3fWt3lgwvPxOKTlOw1yhZYiL6QuSjysGWCMSDImJWAmTS3V9bR6ILkOA2wu4y8s41Y/Uq4/1wMkQDVWl9UNz9QX3LzZhdDhfooROZNA9Fc0x8DY1yS5uXA8YEk/fOWG9ht18Cjsa4czjgJxjAFqWG9R354ANqbrNwN5pr/mS2Z8561kl8ICy9PHK2Ns3sYW2y4hQaO74aHsnEf7EvmPSt6S6rbeoWNS1dAzm7LDDyjOvRofIisU7fEHv1lSMi3athDaPhQ8jSR9ZPyZYoECuI9H853/nx+qaHi+1pEhUqafidHpUnTp/pBLzB1GffROMHj/Jmf/xp5gPILfyFD8/tnUtQ1x+obYtM1Vmm58YlCKMqeSsIeLs3GrHlzntihPNpAnKwRg9mCZWDdRqvffAgahF7ZFHTpNgD4vpctCeNS9m9qX/PY0Oy9jpC0st8hXNESPl8VNL48tTqjFkhoOjD/tsmmmtanqgEIZ0rm2pwBtufrO/NUQ37Np7YYTdJZbS1da9n/AXbq+NCQiNLT6bFk5VPfdBwmPOgp4f8PFYxdNPbfXfZ+IdzX6/3rx14VhAM0qia9LWBeS4Cbdg2uSqRM4pzblH4LRa7wV48/0fvaR4XKbdiIS82ZApmYp92q++eDTJCeo1hBv5NmQssbvFyPpBe1p1NXo7JYuUQTDyXUSbHNUuTqW5ISLj/kYboqKcSsZFmb1ovKWLFMQ0kHIMQJAy607yYW+jEcd/wowRqDQARpESCIJrdCrG2TUYt85cXBt0jXp6CQETyN2gY5gUsPTAekqhq1FLn3UHukYLGFDCAxQCOal5Dybu65BaoeAPzzrjx1R4Bky0PDe2y15KcmyTRrTSc3igQeTrzYCHvVGvMwTNBZeXc67cWUHPi9Qg3X
 H0z8OERf
 kDSeNjCVG/rl98eWVApDil5imrYrrhj5QGsHuegOEc0V8xQfNSHyXPbBcyyt6DoeneISX5NOxZd8k3OieEbpWj+SBo9UWhMsqxaYtq5Bflf7xwXgryoh3MZC4wLWLKa7Wm9aeIdIvTgT5kD8p1cyE5pTkNj32wT/ZGx6o/4KUOoium1TOCWilpfXv2fFgvV9dyYYxME+5vQhjsFwYn3FEdA65gfV6OgHFJVp0gvQlQogPMaGZQtrFOWb+6BpvmtOqpA/l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Dec 2025 13:42:13 -0800, fvdl@google.com wrote:

> Is there any situation where you would write anything else than 'max'
> to the new sysfs file? E.g. in which scenarios does it make sense to
> *not* pre-zero all freed hugetlb folios? There doesn't seem to be a
> point to just doing a certain number. You can't know for sure if the
> number you read will remain correct, as it's just a snapshot. So how
> would you determine a correct number other than 'max'?

My view is that each application knows its own huge-page requirement
and should therefore write the corresponding number into the
"zeroable_hugepages" interface. Since the zeroing work is accounted
to the application process, the CPU time it consumes can be
constrained through that process's cgroup.

Thanks,
Zhe

