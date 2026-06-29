Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84BF9C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 17:24:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F3256B011D; Mon, 29 Jun 2026 13:24:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A3216B011F; Mon, 29 Jun 2026 13:24:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0C06B0121; Mon, 29 Jun 2026 13:24:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 022596B011D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:24:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 78CA91C6030
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:24:16 +0000 (UTC)
X-FDA: 84933623712.11.5D37812
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf11.hostedemail.com (Postfix) with ESMTP id 810914000E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:24:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gFeb3XnT;
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782753854;
	b=oCJgral38jnsM89ynpScvGs+5aMpHsVKlr79iSOQ2rNDCUUo4Q01r1quDrB7Zpcc1I5Mxd
	/ZItXWdpT2pEB/CYUXsCNimMl0lBCOeMcgzWqz3P3EXF/j7IC4jAMHgYyMiXeBEcIrpd4t
	e9gM1MswoFSizL6+2bfkA5rLq+tEdco=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782753854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZNbbav3TlayBnL24voJZl6NnED9LU5K9rl2Lg6cBNo=;
	b=qFqtBzKrBUSn9//ehbWObYGiAgFWHKpxYpDBFDwjmqqBzuKPpmR9caVzUi6d5vBVYPEEby
	UXIHyDYpeqXUJ6fsGQDDYy10BD4N5u9HATTSl8CUPyHqVswx7bvw/ZMlUCngOPGXK4TrZv
	Z5ZWbg1jjIzwklMfOP9pf5gCbYUNU5U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gFeb3XnT;
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <b84a497d-9159-4967-b355-44913a3865cf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782753852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IZNbbav3TlayBnL24voJZl6NnED9LU5K9rl2Lg6cBNo=;
	b=gFeb3XnTM6SMtm27Y9liMgdbo8RGjXGKPEII6Ieiw6WvJavwMB++05Dylmkt5UtsT6UsRT
	0h1qePfTwxkE4guHUbDxrFEWSlFTOQWk40xF46QauPYEgjSeDAoRQj+F1Km9RY8hJ77LQe
	O6GAeunG+xJo1ElZsdmCg6mSDK+fVh4=
Date: Mon, 29 Jun 2026 18:23:58 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] mm/vmpressure: split v1 userspace eventfd code
 into vmpressure-v1.c
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 linux-mm@kvack.org, tj@kernel.org, mkoutny@suse.com, shakeel.butt@linux.dev,
 roman.gushchin@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org,
 ljs@kernel.org, mhocko@suse.com, rppt@kernel.org, surenb@google.com,
 vbabka@kernel.org, kernel-team@meta.com
References: <20260629130042.2649505-1-usama.arif@linux.dev>
 <20260629130042.2649505-3-usama.arif@linux.dev>
 <akKhzR8uHh-wzrx2@cmpxchg.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <akKhzR8uHh-wzrx2@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 810914000E
X-Stat-Signature: w7edw4r3kxuzqfxzacxb513yshqoo3p5
X-HE-Tag: 1782753854-125735
X-HE-Meta: U2FsdGVkX18Xhb6BctBtJm1uVEZ5zL0jYu4lllrCQoeIuo4RJFx3ovQMXtgzIp8gv9kvR/jKpoxvHaJwtUYCXoMme4EBgcTmbFtV+5D2GNULh223VVjjn9fbZXVCapKNgaOae2qC2+pQgXk6a6zXYftiuEHqi+S/GXnmWS3d4Qjmr7h7QpuZdAzkIlabgDRE08zU7yrXs++qDuqlNJUOfxOCCD2sBnJdqQB+Zeenqu2OWGx7TECL+YtEEZSzHCRiYn953qwqV0QkW2jFWhMjnLlcYaMHxTcqfi8mn7fnDWHhF6E4wFoAhcmyA8bSKsogmsJPyW5gfrbbD3I7QpTfdD28r7GU3j17yLgA4VaeZK9ILPR2g5PklRqHRJm+7AFVYaoorAHheTn60ns93yJA1ja4LBcLIqJqE0DQdQ5QFAdzlFAhKDD2FBpge8K59PB0WlRlzvm9q4olLJP6bwkkcv54eTg+G42Fn8Ykg647fstMBkQhHnchpo5m3b3MmvB0SyUsccYBETLIG6jXWNd370SqDj5TLWJ+ztJHggNUG/vPW6n1K4DzwxpGJETLLio/o/DRKL1eSpYgegNLmwSvuWuSHaKbclqStiteKQknv7J3JyfE83kRdy4TliHo05VUyf7kB3EXQhB7goSybDzawUUHkY/uumS5hUJ9BSM8+l7B1NZe85bVOswCZ3PRMW2PepD3L2m8S31EG7MpZ41Jq/lI2zObjGUgcpbyvsUOLyyBoqjSSiAn1vSDvOCAaqIIhxaarrQtnMJX/GzMhMZT77z8nqf4/I3dmJ5MIpSxM6Bf0MuzlAp+lYtKPFNCLd88saqGKeNyNS3VRAPMxc3XQy9UTqyDZn90azsF0bB2Fks7l9JhMQKdavfLPaCr7iAG9RTnHbCxI+82VmaLG5ggaL/hMDioHw2fVBja1ibfH/M+bq3IdWu1vPq2AojnS/uwPc5GJh3k3pz3/lrrE4Q
 n6TNS99w
 WoEipGnFN0L1PV8hhYNlr5fcygs4LIM0TRqrtd2aVMz6wontFkh4qoASQUDaaMA4t4XuWvlguTObQdymgj6GGsO20mqz6LAmq7PIzr0qyCVSBiB1SD7Bv8qoWqytweCzQtUb5kuF88+SUYVwGTx+SUh3/OcFQinM9cgJA6MoEqdBWmQKjL227VkWWfs6Pol3PmDfzn1LkfIG2K76D53px1A5mFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 29/06/2026 17:48, Johannes Weiner wrote:
> On Mon, Jun 29, 2026 at 05:59:37AM -0700, Usama Arif wrote:
>> @@ -101,7 +101,7 @@ obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
>>  obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
>>  obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
>>  obj-$(CONFIG_LIVEUPDATE_MEMFD) += memfd_luo.o
>> -obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
>> +obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o vmpressure-v1.o
> 
> Might as well move the interface part to memcontrol-v1.c instead of
> creating a new file.
> 

I think it would make it easier once we move cgroup v2 off of
vmpressure. Then we can rename vmpressure-v1.c to just vmpressure.c
and gate it to CONFIG_MEMCG_V1. The other option would be everything
living in memcontrol-v1.c? I think its nice to keep it separate as
memcontrol-v1.c is already 2K+ lines and this is standalone feature
that can sit in a separate file.

> Otherwise looks good to me.


