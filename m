Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2FB6C982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 04:44:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE45C6B00A2; Tue, 22 Sep 2026 00:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B94C96B00A4; Tue, 22 Sep 2026 00:44:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAAD36B00A6; Tue, 22 Sep 2026 00:44:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 90B036B00A2
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:44:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17AB1C03B0
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:44:35 +0000 (UTC)
X-FDA: 85240157310.11.E835750
Received: from mta1.migadu.com (out-192.mta1.migadu.com [95.215.58.192])
	by imf09.hostedemail.com (Postfix) with ESMTP id F1FA4140003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:44:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PSPTnB4z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.192 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PSPTnB4z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.192 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790052273;
	b=vLXDClnESh2K5D4wll/zmSZGLJJe9Z0jskwIazJPCaaD3SWmBp9EXL7PpbQyrzGG3dqU7U
	RuFnlbrd81uNPfH4CLU2aFoNW4JW3dHc5PLD2o7nc0OlNZHXgiGg1B+cUilFYySYNXoVRU
	dqumwJUilY7Kl4/92paZ7a7B1Hbddzs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790052273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5jAczTY2srZnyFZCJQBTQCuPl4VyofX+/wzwWQlpVY=;
	b=r3WycHOCW08YMpeNBAZAa7zqs284mFm7QdGQmX3sKtWMpxPn/Krb7IRkY95vwU8amRGA6h
	GOadM3pKp0K8MirR2E52XaoPiT7DbOcLvrI74bEleB2KWkfLK0deJzDere59XgOk675+Qk
	zhGDSKvzdl+ATJ5Rs7j1p+xokk2k9ZI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=O9TtdOhD8pGjJ5szyUuOrZgrl+8A101U3MBnFYDvhY8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790052271; v=1; x=1790657071;
 b=PSPTnB4zSxw4Mu49Z0TQhV1FNPlOwzFXABfcbLftXqQKLWeNRNr6oL60cCkVQlc0FULpn0Yb
 +gYjqTpa1UfXszW/jk0eE40uHRK2besbBxrZ0EpN9YBsDdDiS7APJNSdXyp2cZlNpyokx+Do3Dr
 xWmwF19PBWWFEU81MNODolls=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 1c91c1c822023d95;
	Tue, 22 Sep 2026 04:44:31 +0000
X-Mizu-Trace-ID: 1c91c1c822023d95
X-Migadu-Flow: FLOW_OUT
Message-ID: <10159c57-091e-474a-a154-4f675a39dcc2@linux.dev>
Date: Tue, 22 Sep 2026 12:44:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] nvdimm/pmem: Remove test_and_clear_pmem_poison()
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>,
 David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny
 <iweiny@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260903053535.17611-1-kaitao.cheng@linux.dev>
 <20260903053535.17611-3-kaitao.cheng@linux.dev>
 <arIBvO3cFQ53ivG3@localhost.localdomain>
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <arIBvO3cFQ53ivG3@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F1FA4140003
X-Stat-Signature: gqruk8xfnrgstpox8m6gnkrzpn4cem4n
X-Rspamd-Server: rspam01
X-HE-Tag: 1790052272-824545
X-HE-Meta: U2FsdGVkX19AOvVP9A5Pf4fnJA4tUEcGxAn7x4Kyj7jm9rrBBxdgs1fv4kZyz15nBOLzS3KhEQTKCXaWO69pfwt/sLBzFbIq1FCsvISIn2/LAvRtqCUJOTZxFaibz40p5VnVcukKIHQ5oWdEabOrBJe2epi2zGSChne87tKi/neYrPbAaxUkjLrUxKmAjvFJlyjBWUTvvdaLpvkbniU+z31VXr0uPnec9VaJT/H6zbdPZHxqEQPuJGqlSoFxJzsZc5eWj18P8ldCXisw7BQlufdQ0v+kQWiS7ehCAmhAhJvzL59pcn5hKLKGIEyc3OOwqHSC8yDHCp7Ez/Ri5SEdtwoCuEyyKcAkk22tkcaKqqEu+e/F0MB8IvlTWMLl/Rc04FMrkt65JJzKXxuHKziVYNXBLv7XwGXaNvRQZSGj80a14a+nu96lWZaOhpIQuE3S3CPyY8sf9UrzT0duYQxtJ6vWcNpXc9g4rfmnJJez9rgxaSDBvOnMV+NOs49eVmsyku3SAjqv9giRU0eYVGsFknaGYK2bVSy6WYMgtVyZ9aWph3k/Vh9Ro85KOTayBE1Ibw0HnFKLZ8XzE3XV/uytOFLxgRmnhSIxaFgHgrjklm1QU/gcL42cqqouCO+La6haVtP4D4mg6xzmlPTBBp0jIFPQfmtSu7fHnkR19sc6LzN1RbN669KDyQiCq9X+U/nn1XEm7UaDiadNh48Mb3x8+Dd3WQz8D39tuI5YzPjA3sMDyPtizvm8YNwPZLU79A+7Azukn1dPcc/hioNk6Cd0XsI3+6Ye+QSOpZyUxvFSncoxv4hDPfn0IJCj0XVNCbaS0KK++9cv6OCwJJCoSYLgYPcjpVoPKSepnp5eiiNebVwLNkmkMJtUaUV7RjnhXNWyC0jw7Cg4UXOEv5NMiEsXiQXvHmEt1r8mlEM8lKe+uZG1OIW8g7lKNPP7na4io9yV+44PB/iidA3ajIrCY86
 bt7TCwtD
 b7TX2tk21pO9PWpYQoqghNrBZbDllkWEMdSuy1b/w3etp/DiSibru6ia1bG9WZjox9S1P3JM6giMsDLpy4W+7XJNzu+C4JNmxGW3E3ptdKeakxk6R+gTOAQWdiJbiDlOwgFkQVcElpVNRpOJuENy66GWIOp7bEJtp4riTNWFj85Pq6XvFrisS3ELs80aH1sQSxG6zUuqLd056x0J5Ic3H75hF9haPBZZfSJNxfd4l+8QVosCI+Sxo2mCK2UHE05wo9Gb0kX4uOHKfknPekGFgIrbZ1MYWPKPp13DFRdiC+0XstzvnQQxs1TCcML2sbHu+yKKYk37Pq+aXoYQZ82t7cbfOprbf98/+9f9m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/9/22 12:19, Oscar Salvador (SUSE) 写道:
> On Thu, Sep 03, 2026 at 01:35:35PM +0800, Kaitao Cheng wrote:
>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>
>> TestClearPageHWPoison() is now defined regardless of whether
>> CONFIG_MEMORY_FAILURE is enabled, returning false when memory failure
>> handling is unavailable.
>>
>> The test_and_clear_pmem_poison() wrapper duplicates this configuration
>> handling and has no other pmem-specific behavior.
>>
>> Call TestClearPageHWPoison() directly and remove the redundant wrapper.
>> This also removes the need to include page-flags.h from pmem.h.
>>
>> No functional change is intended.
>>
>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> Nice cleanup, but as David noted, please squash patch#1 into this one.

Although NVDIMM is currently the only external user of TestClearPageHWPoison,
I still consider it a generic declaration. Combining the two patches might
give the impression that TestClearPageHWPoison exists solely to serve a
specific driver.

That said, I’m not opposed to merging the two patches, as doing so would
make the submission more concise.

I think both approaches have their own advantages and disadvantages,
which is why I haven’t sent a v2 yet.

> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> 
>  


-- 
Thanks
Kaitao Cheng


