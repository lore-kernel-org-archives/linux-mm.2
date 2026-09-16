Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29D23C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 02:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42EBC6B009E; Tue, 15 Sep 2026 22:36:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DF396B009F; Tue, 15 Sep 2026 22:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CFC66B00A0; Tue, 15 Sep 2026 22:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0EFD16B009E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:36:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92574160580
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:36:29 +0000 (UTC)
X-FDA: 85218061698.02.567DC83
Received: from mta0.migadu.com (out-227.mta0.migadu.com [91.218.175.227])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9F6B540006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:36:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ttFq3DWY;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.227 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789526187;
	b=LeryVR2I8ScI3WLx+J3VzCI+fn3AKnMHhhQCiZnE4vI28AmELHLTzoCyyU43CDqUMltxPV
	G//irLa8KvbT2jHGQgVT/ThgRuFmLpQSxhmRLzmquYQkA18lVjRFKCmMq50gcgZcCkUNT0
	pLiyJB2xFIGapSksY1kMb3kAenuQwwQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ttFq3DWY;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.227 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789526187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CbEQrIA83IYrhW8D4seHdk5E5umblkqPOzrNx/6qe6g=;
	b=nf0Bb4kzZj7K5fsz6vgn2chkZG29+C4XuA3J6vBLU/kKNsLk0HrkqoQiVChzXicbRL1oZO
	vur2YFNO++n7WHXibD5M5L9lb9bSUsfOgf1crLdsv45xYtiUU2nEcBO3Gw52/xZ2raudn/
	jLNdnjc0DUdeQ+ifeu7JC45b5sd4WFI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7Dz4fms3T/cjCdtsDYuHqhdriRacQBPm6AH3anwvlj4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789526186; v=1; x=1790130986;
 b=ttFq3DWYHJZhgvzRXlNISEXYnO9+a0TLmYENr95Sir8R3XqPdJSJAmgdHapbjlea+8ffH6HQ
 bG8OH1LIvXMk/RLyxUtd7KxUxdHXZUepRxw2IDAJC2LHDSlrO3LFXerkoKiwEpVoOiaddVCJ1u/
 oFz3PkKYN5o0RLu7RsIA41gE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 9d20baf603adb599;
	Wed, 16 Sep 2026 02:36:25 +0000
X-Mizu-Trace-ID: 9d20baf603adb599
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v3 09/11] mm: memcontrol: constify the swap accounting
 helpers
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260915-folio_memcg-const-v3-9-c239a6010b58@columbia.edu>
Date: Wed, 16 Sep 2026 10:36:09 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <B52CEE68-38E0-44BB-A375-E733BC5BD37F@linux.dev>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260915-folio_memcg-const-v3-9-c239a6010b58@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9F6B540006
X-Stat-Signature: c1hbij8no7thcp63nq53nkw9djizkxr1
X-HE-Tag: 1789526187-134193
X-HE-Meta: U2FsdGVkX19Wa75F93WZXm04MYVyaScSNMXKHmem3k0N+P1Bc0atxFmwJYYUKxVrUWNVCMTlXw+1V+1Spc05EEWunpLCgOe+1VjV4R2HOghQN3QmL3v+ivL14Hoq11MulT/NM+cYeZfF7RGjbVgIvBbCZa+UGw6YVoYe3sxrfp24KAmkWFIDjuk4/fKsuUEy+LPHnuGicfolFIkHdOg75VWAY3xgyzFO/uHRfqJkwiTzu88Lb7cKrC0sSgPYfulYNTym/X83TziqyfQJnhcCNHt9i5722uJHYpOF7HVIJwVWupqFggihu8U71sAYeiYv+dvxAtGPGs0KBUvHSAyXbSP3oImKzk7SvBhQfjphW1OdjBkoXamojnuvNzS8d4cb5i8WDlEeJEXOjWHZnPJkqRIJttDrTcHHOV9Sxh1nEbxDmhMS20RQgOk8ESUlJvhHD9Or5BewcaOurIfugDKCWtZXYCssB9SGgcrcBZu8Y0frpa+5UDrvuSLXVtbWSVnUQZ38z+obNUnLDH3GHFmqVwn1jITI8dwUBxNqZTNWMo1PXvYhhaABK44MH8ilt05gVr9Is6OPfmspm2xaRDeiXiMgq3AI7+Qle7/fj8FDJ393pFWNPBq/ZCrxWarpGrqlcayg0FJXdcCK1I5npdrowF0h6qNnjZ/48gpXKrcxaksaMzjSw/NPQ+h6muFwM50LEKT4FC5qi4e6BFHpM1fLGF1TM0IcxlqNl6rRQfeykd0Fa6abSoJ6SIgiWiOciQbNOMpo7xfunIS3PH2f22I7HpyGTgOHTuI7AFq9ePYiO1iNwvjWb3844qGOQK6Rr5hQiub65kECx8xqT1Uep3wa2Gh6tsQEAdwZuASTzRhFFjA9LRK6i9a6ukmTG1Mt+tEhqQe9+84o2rsHPqgbXhqp78XRkvwP7Iq/Ti4pNqcwWxRzoDTD4I4/0a6IYjHKwPwuvQqIdGIkvYsWsZeko5V
 N7qFMfLI
 XYHLUDCBQIZn/GXD75C0XHytUvPc385YlLHFJj3mVkqDhH2xyZQj62N+KyOk+hrE4wlebwJPTrOMc50lSAE4I1Eq8iOSDZMhrsz5yKzt2K6N2jVBxIfxEfEjmYZYC6LRckrj1PYobqsoL3D9vsnS13v/bi4mAiPQqjZy+EVlBv5ER09WPAPNgNTmHhMkFu5+7N9Ywh7t0N9fypyy3kTUNvsqwlhFO/G/eS+7xEI0ofSDidH7a8lq9de/TSCjY5ZiyitnRmH6mdZxUAlU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 16, 2026, at 07:20, Tal Zussman <tz2294@columbia.edu> wrote:
> 
> mem_cgroup_get_nr_swap_pages(), mem_cgroup_get_folio_swap_margin(), and
> mem_cgroup_swap_full() only read swap counters and limits. Constify
> them.
> 
> Remove externs from function declarations while at it.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


