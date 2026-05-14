Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F9B8CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 06:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBA6B6B008C; Thu, 14 May 2026 02:42:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6AB76B0092; Thu, 14 May 2026 02:42:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA6CD6B0093; Thu, 14 May 2026 02:42:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A91A96B008C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:42:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5091C120513
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:42:22 +0000 (UTC)
X-FDA: 84765081324.09.66385A2
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7BA58100004
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:42:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="qdjT4/8j";
	spf=pass (imf05.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778740939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g7EGq3xnGENgZKkxTM3hsLHRd8K6TtCjtcofuKXJ5tQ=;
	b=eGOS5n7CaTvfb9ZG3NRg8K7e4Atwe71z58XV2Pb0k4HkORSphlQWui2weuDJiyBafr5JWi
	qtVMx7wfS2NsSitTj87MFLenq1E3l9mf6rLA+0amR/Wb1sl72+cjbz0BIwHfQy307JWwlf
	ck6gjBzizaEt6Q0rj77O2pETmsbbr/Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="qdjT4/8j";
	spf=pass (imf05.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778740939; a=rsa-sha256;
	cv=none;
	b=u8beAqA11SDBSwKmf+Jtejr06gwYIe3cpL5fbEirjZmobUeJvPgUcpWh2wJ47WfKYttkDS
	M6RYdYU/GQOa1giy/fuAtOu5UwO5e0ugtkMVni+VnOYtGGoy2vMTqQQ5BWa4OVwFpx/s6+
	pr6779GlyxC4600Fx+rA3wxvWjlhbHk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778740934; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=g7EGq3xnGENgZKkxTM3hsLHRd8K6TtCjtcofuKXJ5tQ=;
	b=qdjT4/8jHVKNIu0+Xqg4fgORidRIVRbCdWHelt4XRmnjaRS+JTl2l361jX9c0V1Fcn9CE5R46Ve8F6jJjUASjBRvXL3wZU6EW/BeD8SuLqcfAtFM+O1vXdt+iF0l2xjpH+td4y5N9v3p0xohMvvttdk8+fjiKH/OjMxhBp2CAzY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=44;SR=0;TI=SMTPD_---0X2w.M.t_1778740922;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X2w.M.t_1778740922 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 14 May 2026 14:42:12 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Shivank Garg <shivankg@amd.com>,  akpm@linux-foundation.org,
  kinseyho@google.com,  weixugc@google.com,  ljs@kernel.org,
  Liam.Howlett@oracle.com,  vbabka@kernel.org,  willy@infradead.org,
  rppt@kernel.org,  surenb@google.com,  mhocko@suse.com,  ziy@nvidia.com,
  matthew.brost@intel.com,  joshua.hahnjy@gmail.com,  rakie.kim@sk.com,
  byungchul@sk.com,  gourry@gourry.net,  apopple@nvidia.com,
  dave@stgolabs.net,  Jonathan.Cameron@huawei.com,  rkodsara@amd.com,
  vkoul@kernel.org,  bharata@amd.com,  sj@kernel.org,  rientjes@google.com,
  xuezhengchu@huawei.com,  yiannis@zptcorp.com,  dave.hansen@intel.com,
  hannes@cmpxchg.org,  jhubbard@nvidia.com,  peterx@redhat.com,
  riel@surriel.com,  shakeel.butt@linux.dev,  stalexan@redhat.com,
  tj@kernel.org,  nifan.cxl@gmail.com,  jic23@kernel.org,
  aneesh.kumar@kernel.org,  nathan.lynch@amd.com,  Frank.li@nxp.com,
  djbw@kernel.org,  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH 0/7] Accelerate page migration with batch copying and
 hardware offload
In-Reply-To: <f13f56aa-fce5-4382-8998-668f2c13b84c@kernel.org> (David
	Hildenbrand's message of "Tue, 12 May 2026 08:34:17 +0200")
References: <20260428155043.39251-2-shivankg@amd.com>
	<98a16642-35b7-4cf9-9ee2-8de15e877920@kernel.org>
	<874ikdwe21.fsf@DESKTOP-5N7EMDA>
	<f13f56aa-fce5-4382-8998-668f2c13b84c@kernel.org>
Date: Thu, 14 May 2026 14:42:00 +0800
Message-ID: <87ecjeqypz.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7BA58100004
X-Stat-Signature: fcozqjy3crthnzijtg61n548k591ju1i
X-HE-Tag: 1778740937-471997
X-HE-Meta: U2FsdGVkX18/hPS0pK0Auj3sMl5Fv25l5gfJoeqW43mFFXLRcoh7xcDKlFlbSr7g3Q0p+UpkBy7LxYztSF+XO1KQrPTR1reX7madLh7daFIpvDklMvo1bhqGUHs1LBqeUuJw5FKvEzByuO/fFvYWjtOOuaj5tAvRgvKgj3pKEKY49yV1ESvN1/flk4Q2j8zZ3M3DrCoU52G3CaKFWZgdPoSXEnv+YJO4D3Fi2A9hl/OQpLisGpuzmLyIbzeQ7nz5wQjo8di3cbJg4YlA2KPn6C/qgwpTaT2lwL4+vnvV2EGL43P8yCUwn4I/YG8AUoipfmc+3ZXTV5KB1mIFar3ZUxtvtfqRniT3oCy1TpCry+ISRh8CBciLeXnH7A3ubSD6KlV193FJv3BuRIYbq+bcjl0+6S9ciujD1VxrwBeZqeW5DAuRDKyIhV7pm26ncC4rBaRgZkr7MKcFXEHOq2IxpY0CBXNjooNpH9GA6dGKyLpqEqugG53IlTXLqYGDqkjOfH+2G9NMiX8p2PkO0jnQXbSoWI53fcJ4eRJ5d2G1kMP2itxT9vq25p9cwwrABn435TM4546CBgXlmZgyft4eiOutkK5Rr1rsSEmlaXL48CZMeKsndn8IroQLs6KzslFjdmARv9X9o38llp/SPmM/cMg9fKxfVxHCs1uD/dDBBD5D7UbZeiXarcZJb1ojTvAp8tTEsn4wRlO5ttKlq2PGDeqhvm8n1QMsCOklS4r3ut94Wss0W0wH/ik5JAn+ssJG/0+yXz6JXOosy1qT/8YD7n+qe7CK+dVtbo+9kP6uDPQr2YJN3otF2S7H0ZiborCBoPEMkjFeOiqZ/PCOfvRiLHp+M6uMLioLPvqelNvr65K3p1okiFic5J6hdq93833QegqpsU2a3Sod1RZj6vSATHrG34e1YVsFdBIqKzAihZEZsTyh2xJkmVW2cJl5k+QXnZhq8A6vPYKsPgHspwx
 0a4ceaft
 HO4PZH1iyBirG0lo/XlqRBSWo+mJm8QPQogIJABKh9NpDtdeY/gNru8+MiMKiL1kRsY/IeSAM2cu1RQEpAhjwkvs+wJ7PXDAX0dlgflPDj2U63niuS6alDw07bdkQNj7Fyyw36zsZGZrKzGT1mwmoOfVdyoDq2/LpdRbMNxi5+mC8rmPFdjBOQweLFpJy5G5a1RkXmKqeUKg3fwAZ93Zzo+t7RYcwhkEm5bVOnajZbl8XIN8lJ6i3O48sUNhtF3OWZMe3XW1DGFDIAIvPbym9XZJ3u+4mwKGdhFgL9imMKsrrRnwb7hMbKLB23euPcfkZVScVYNwIyRi2BkZJpcIbjawdYxblht2YrSlpZrVbrSt+ZaVFnTaoPlt1Pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 5/12/26 04:35, Huang, Ying wrote:
>> "David Hildenbrand (Arm)" <david@kernel.org> writes:
>> 
>>> On 4/28/26 17:50, Shivank Garg wrote:
>>>> This is the fifth RFC of the patchset to enhance page migration by
>> 
>> [snip]
>>>
>>>>
>>>> 3. Per-caller offload selection: Today eligibility is by migrate_reason
>>>>    only. Some are latency-tolerant, others may be not. Is reason the
>>>>    right granularity, or do we want a per-caller hint?
>>>
>>> Isn't it sufficient to just do it based on the #folios or sth like that?
>>>
>>> If someone migrates a handful of folios, latency is likely more important (and
>>> batching less beneficial).
>>>
>>> I'd assume when migrating many folios, batching could just always be done. Or
>>> what's the concern?
>> 
>> IIUC, for callers like migrate_pages syscall, it's possible that almost all
>> folios of a process are passed to migrate_pages().  However, I think that
>> we still need to keep the folio inaccessible time reasonable.
>
> Wouldn't we still want to process them in batches, only affecting folios in a
> batch at one point in time, not the whole address space?

Sorry, my previous reply was confusing.  Let me try to be clearer.

I think we need to distinguish between two kinds of latency.  One is the
latency to migrate folios; the other is the latency during which a core
cannot access memory (while unmapped during migration).

IIUC, most users want the second one to be as short as possible.  One
possible user that does not care as much is the folio demoter, which
migrates cold higher-tier folios to lower tier after they have not been
accessed for some time.

---
Best Regards,
Huang, Ying

