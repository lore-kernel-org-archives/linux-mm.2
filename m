Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1B06CD4846
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 02:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F8B86B0088; Mon, 11 May 2026 22:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D0676B008A; Mon, 11 May 2026 22:35:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E5526B008C; Mon, 11 May 2026 22:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B35F6B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:35:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 878DA14032A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:35:17 +0000 (UTC)
X-FDA: 84757201074.06.C522308
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7E7F940009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:35:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VCCGZVMA;
	spf=pass (imf07.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778553314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZryK6TtFL9lwH8VtNqHCwypE9vBCEHYayhdvZkF1tGM=;
	b=5MzWZcEGpBExkFnbIXpuULktqlH2tpg1GUQ4Q/fm121qT702uMFp49eDjMdTIMrL1CjsJ8
	rsEuIP42zeT9icuWX7Z0fzom0Kd1o9CVm+tpPTDH9a8ojbrINYGTC/GeqJUVS3qZho2eha
	rAYOaY2Bd5Q+hho9nU5DkZ1inKxUmoY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VCCGZVMA;
	spf=pass (imf07.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778553314; a=rsa-sha256;
	cv=none;
	b=yOYU6QfiniMYVlWSDjtBQCk1JbYu8KlG5qZ37GMUKg7GbY9bjSrdISOOEH55DP9H2eB0yP
	Cm1ogfLcwdJm6MZ1nRzN526ub1K12IM/U8Iu1664KnpKlIxIltcccRDohLRWSIktH3yWhE
	LMZnfQ1aDtB9IlqN83GS+/dyBUAvPaA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778553308; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=ZryK6TtFL9lwH8VtNqHCwypE9vBCEHYayhdvZkF1tGM=;
	b=VCCGZVMALrmIvv02ly62CYcxOxgHOd4PuVJ8/3PmCrIoIctOPJjFcpH4CorDBNjIsQIkCk22Jm+tdeMqwTwqua035JN9WiMRFQ/d2wLLGiwsHc1cX1yLpMmavV0TkHEMl6z1hP/IZjJaXa142FSyg3wVPoUGlIYqEOJgjJslwhM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=44;SR=0;TI=SMTPD_---0X2op7A9_1778553302;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X2op7A9_1778553302 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 12 May 2026 10:35:03 +0800
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
In-Reply-To: <98a16642-35b7-4cf9-9ee2-8de15e877920@kernel.org> (David
	Hildenbrand's message of "Mon, 11 May 2026 17:53:24 +0200")
References: <20260428155043.39251-2-shivankg@amd.com>
	<98a16642-35b7-4cf9-9ee2-8de15e877920@kernel.org>
Date: Tue, 12 May 2026 10:35:02 +0800
Message-ID: <874ikdwe21.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7E7F940009
X-Stat-Signature: ykatxtzrui3qr9w56gpfbtctn1r43tfq
X-HE-Tag: 1778553312-905693
X-HE-Meta: U2FsdGVkX1+TuJ5Sj8q2d8nNZXaKsGRZ+kn1g2blAvWO9s93aOm5pu1vr9sLzqGLafQS8eYQ7/bqlxLGB7W/1Rs0J14Bn9DMRe8enEMVtp9/TVHVDJC+83GjSPunpdt1ePRnV1aOA98tDyitE6cjyKl8WrLUQNCOPmrXQHnrNhfAMPq9hKbZM0oBARy3nFndVQKQP0NFzukzYsnTtZdm+Bv37xW4hho3CJb+81M9kibtLIdgED82ZkreGt+j3/MKWBnOixKRHpLZde0bKpgkiVYmt7dKIZHuuinkndnPIoWIFjJuS/GOWMxkwI08Ygxnf6LBZ9fD7HH9aQU1rPJ2aGwdJmyrFIQ85sSmnORUlSGuEcGilILmqrCItgoeO/JOkL6RLBFBfNXoNk/d7lb86GCe3458qP9nUmJA49z8L17iuXHa23HQYZp5SliAVXa/lVqTuQ/kn2TLBIeed3NSOCXOTu/PK6QiqueYdmOL9YEczGMpVg5EUUaP9F5zPT/Z3v9E4ESX2jgE73ENjh54CZKNnJZNPMGFatA0XwrTZuj7pz+r+0DmNbg5cxLNBheET88IVWcBVgeIKq3JT2REOhTMR4GSclI8DS6WK+88zJcLzP8C7oQZa1TYOOxnv6fSZrKIS+dq8Eg6l3uF9bb7/5WhlnNKV++nAfvWoqW2SEIf0JARstPWH5VmtVvnqmKwaEdUa11nXdG6hakAmvPq399yAbjb48WU/JF2I9MXpSFMuOC+Zj7h3n9geA56U5ewexhly25++wZOvCrXdy1HUMwZTm20VtbCRpPJ1Mf+HCT5CJkSTC9kUX1mQRV1Mb5XqxbPlj2UoL87mbQLn0PYZqMfCY81shWVvRv3S95v/x4WKMl9DNV13Ys4QUl7yru30EfjdbPjqd2ukK/OYSUhhJh3vootChNJuFLxK7naYVasjNLPdh6Zd1oBAPNpon6KqggFzuW9EpmNV1+PA4p
 NxWF6JDn
 YtV+wPPYj0cWwqDlzQ8ou8efYooyPxzht15JcleuA2smBbQ1PpGL03Dnc5dI1MxISILM/SCrH1c2d9swm2ewPGHWf26r7Mb2r2PQja/xV0cpeq2w+OELEmj7+5I+H7M8A75jipD7ZqLI+O5rLYTJdlOyW4l5nm1E3u+mezKt3Tm01thM0aFDYZX49iqUX2fFFq+Bbub5WLKBJgzACiQ3WvcQ+p3uoh1Et8Qmcq0YkPRH7si2rYi7SYxcoM1OCvkbjt6+T5Fr3plAogWFog10ztFBmy52iKXANkBgjFh63pUnZ2WrJspnXvrOVKvHJ0uw8GuUgiPwxiF4c9l4qGPDkSoXZoHX3gI9yBhASsopVAdDyrUkGJXJ8ZxOdZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 4/28/26 17:50, Shivank Garg wrote:
>> This is the fifth RFC of the patchset to enhance page migration by

[snip]
>
>> 
>> 3. Per-caller offload selection: Today eligibility is by migrate_reason
>>    only. Some are latency-tolerant, others may be not. Is reason the
>>    right granularity, or do we want a per-caller hint?
>
> Isn't it sufficient to just do it based on the #folios or sth like that?
>
> If someone migrates a handful of folios, latency is likely more important (and
> batching less beneficial).
>
> I'd assume when migrating many folios, batching could just always be done. Or
> what's the concern?

IIUC, for callers like migrate_pages syscall, it's possible that almost all
folios of a process are passed to migrate_pages().  However, I think that
we still need to keep the folio inaccessible time reasonable.

[snip]

---
Best Regards,
Huang, Ying

