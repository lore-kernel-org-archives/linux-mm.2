Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BD67C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:13:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 484AB6B008A; Thu, 10 Sep 2026 05:13:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 436806B008C; Thu, 10 Sep 2026 05:13:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 328C16B0092; Thu, 10 Sep 2026 05:13:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 093D56B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:13:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8C7391C215D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:13:30 +0000 (UTC)
X-FDA: 85197289380.23.5C0A155
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id D17AE14000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:13:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XyPvGHc4;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789031608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zEeFtMUHn3s+PI/cg5N17MVY4nHEBTOfJ4ioYjja5j0=;
	b=E7//M8m4f9JMKGU8C/rhGo25WQg76UzCr+4Xbp/WtrlkGtuh5Z/5z/lSgeBYA7J+1zNrGc
	/F9ihFm7a3YfIcPm2iXY1zAOx2vjpWmgy1hANlvEqPChI7zJ+XhKqzFA1STwR/qcRdLLHH
	pRTseVHJm+aQVjUx+EoHisyroZfP71k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XyPvGHc4;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789031608;
	b=DHJRDJ9zAdt13WNc4CMbCw2juWvDFTDZqxi8H1lg/hP46Ryh5kfpf63RTVAg6KenFyIBWm
	/+CijWGfw27Ym6Md7ojfFk4AcbgDxwPbiONS75xlzFZIlnxM0MaNBrZZR34iOPPAebyNb/
	ceSCgWsu4qbBfIiEDm7YCWF80hcAbt4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4FD1E600C8;
	Thu, 10 Sep 2026 09:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2331F000FF;
	Thu, 10 Sep 2026 09:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789031608;
	bh=zEeFtMUHn3s+PI/cg5N17MVY4nHEBTOfJ4ioYjja5j0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XyPvGHc4wMCN7XnUzQUlQv10dHqh7HO9TkjaWiDpqVTCqUZ4CKmIoiz+rzPcl393j
	 rIr/J7DuGFP9ozSMcRGKBgArgVJ+vGtlpUubDEgaYE5Vzdq6UW9s1oKqS6erMBJjYF
	 SPn4FVdbHQyZXkXx/ixOwaCHQW3+hbhiDYYkbisYcgnWLijvhtX8jhLnBH+PL4XmMl
	 0X8GngpShNpiBLxjcnPi2mLIa/G/Kv5WyR4GlLBYjl4gpWQl0s7YVeY5awvfbIrCTf
	 WbID137Cnw9Gz6smokOCSQR3sQF+L/7Wc84ygpecTcamLUtAKNJQ9w39t3KgLMKJle
	 sFyI2xY8WPRwg==
Message-ID: <c2239ef2-10f4-4c87-a23a-2753f1e18d27@kernel.org>
Date: Thu, 10 Sep 2026 11:13:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/12] mm/sparse: move __highest_used_section_nr handling
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-8-008fc8d579fe@kernel.org>
 <aqJrblWch-lajp3k@localhost.localdomain>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqJrblWch-lajp3k@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: kid8groie6s3dhdk3jurxrpxne53k635
X-Rspamd-Queue-Id: D17AE14000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1789031608-544904
X-HE-Meta: U2FsdGVkX1/F2X5c29htxIZLpyGb3GpKHYe9LCj4IKnOJs/OE7RYwIT3CygOdH4iCnfIimPKfRscNUh9qPevkY9HgkrTCBLCmDav5mW1+lAV/RW5uWjfbFM2z9UtCLRKd82FxMmVfrgPCJnRaiyb7018d5Y63IQNsdnvp/vOP/3veX4QnpytuYG00bX9bcUHjKNHUviEUZj7XQdllqmdqvkhtKUpH3hKkKjrQ1S8T6itGs3mgIZTK/GWrBDb/8AIuzHoBS9KHKnnvwGKQLGdkHF3AMxoJjatqYEf4i5KaGkgrfJn0pwbE2XAz0PhATkMp4CkpKYvmyTH+p71c7+iKmS8A72eGIMXL11gdNAgo2YKvDuQL78r8Z1HSfuKUzLMfR01TBExBQcC0CzS4hTu6toJMWve2kDJ0XEslrAlcFf+/rJkMeJ1NcFbIeTVBRLgOdwWI11lUFKv+U69ovm0whOUDDGyd7dqTAA1KjqS5ZwpEZp/MdjY3SRydrnicLQ9l6NHALHJHXp8mj/ENaFFMU9d2n6CDcJz4amKSkkoui0nYg2Qy2+DAFYR+FNBldlghSZMqOcYoBSWClVX45aSW7Akdsss58hfAKgnFH2ggjVSo3QNZ7N7FKmLzVfh4RVxMpCqbdWE3QF8b7vV1ACdp4FjHoFlYyAJfdBIOnnOyrxAR6935IlxSl+T/EX2OEiS5vu+zF6caM9V/eX6C0kaps4zs/hUl/GZuUozt/w0aSEZFKUFmJo5guAb3r4ULY4P2EBc4TokZeFN7whmpZLANf8Mad+vntT2ImqWq0QvInp8Qiif55Pe0SeMf8V+LsiBchOM7ff8t6ena3HTiCiTJRlI1FIdwuQUgRfHuflcSv7Q3tpaz2QnyUvkTH0ivPlNzjUcB4Xi4zH78AtL1Ycjo3IWx0GBef1AcEAX625qyynL6G2XaTZUaIxi4hnJoTs8VhklrEpqm8FU8Qt2ZhL
 tcMNZAll
 lzPo3jx2Bv+esex6XA6HCTvPIlB6ScjzKkdDUg5I21W++o5EE41rYBYmgcnJFBRkPtiCHxYk9ZMOpGqciIkzN9pEfAsYCVCY9do3YOC1/V9aX0k4SgGDXYmqEaE4xN6hvTj/qLOw/O9FXTBVBB5AOo4ALSaGwi57vRR58XLKux/579f1CwZWIbDkRIbhNq4+QZkufskq9KP9nsQO/E/d5aOyJSZuYxJDdorziDIKpYzCAeUrMTsQk1yGEPuMReV3N3b7MySNKyMIEkHIzxDPi6PZ63ysH160Wp7kd1397+k5/OQB5edOIiMxLgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 10:33, Oscar Salvador (SUSE) wrote:
> On Wed, Sep 09, 2026 at 03:33:01PM +0200, David Hildenbrand (Arm) wrote:
>> Let's move it to sparse_init_one_section(). However, to keep early
>> boot processing working, we also have to initialize it in
>> sparse_sections_init().
>>
>> Should we use READ_ONCE/WRITE_ONCE with __highest_used_section_nr?
>> Probably, something for another day.
> 
> What is the worry there?
> 
> sparse_init_one_section() calls should run sequentally due to the memhotplug
> lock, so there should not be parallel updates there?

If you have something consuming __highest_used_section_nr while concurrently
updating it, you might get torn reads/writes that mess up the value on the
reader side.

For example, mm/compaction.c consuming __highest_used_section_nr.

I don't think this is critical, so I decided to spell it out instead of fixing
it right away.

-- 
Cheers,

David

