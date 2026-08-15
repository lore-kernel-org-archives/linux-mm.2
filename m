Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AA81C5DF67
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 14:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C6026B07CC; Sat, 15 Aug 2026 10:30:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776076B07CD; Sat, 15 Aug 2026 10:30:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68B326B07CE; Sat, 15 Aug 2026 10:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41BE86B07CC
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 10:30:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3F7E803A6
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 14:30:53 +0000 (UTC)
X-FDA: 85103740386.08.8F5796B
Received: from mta0.migadu.com (out-112.mta0.migadu.com [91.218.175.112])
	by imf29.hostedemail.com (Postfix) with ESMTP id C355D120006
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 14:30:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ex1nmzfE;
	spf=pass (imf29.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.112 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786804252;
	b=S2zytFvdoH427mO+ofQ6nTLEYXnrk7OZIFr0YK1G7kFwmmbugnEubVBCmgNJ8kceCEjQm2
	mxusCHhxZfmYuRYGColwfGYwR1fbXH9fI3NDLlU8MYcuV+rZhADy/wR86SLYMaG7VOdDwc
	ZHFzy37XdQ+le8FGVgBDD5gKrVjhJfI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ex1nmzfE;
	spf=pass (imf29.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.112 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786804252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/0Z/2LadPFY3rjFZ+EZ/aup+JHhu6t6XpboK+FK8giU=;
	b=A9VsK2A/MZATJT42/Vx+TTlTA1zFSQzwo5kjw/9VWej6iDIhza+GfYjrTll/Clhzc4Keuk
	9s/UtozecVcUA3Ol6cW01MtxQWc1JZ20OAHPowuc1EoiZ4cCSCZJr2rWiB0PFxwUQxWI9h
	hf4DvVg1dF3frxSZDqy9MvgWeEGI+ro=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=f0l24nJdKCPn3HKZrSe3W0vzuVprJAb/6eQIXz+8b4s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786804250; v=1; x=1787409050;
 b=Ex1nmzfE9iGXU5fCmahNyVytG7kca6ipEWwEzWtf0vrvM/wpyjFCaoBLJqYjYnexwQpYFLNq
 khPZE/FHwgZxmh4xvv/X5IevlsbrGNds5D6v8H/J8w7pFZVbM+UsuUlQa1+oqz22SqeXUikWLto
 RFurkYXa3v8WU8MfeX2grlxo=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (77.97.51.77)
	by smtp.migadu.com with ESMTPS id aa0f9b3bd3bb642c;
	Sat, 15 Aug 2026 14:30:49 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 15 Aug 2026 15:30:44 +0100
Message-Id: <DKPL8Q39R5JD.2OY4LAGZ84XTG@linux.dev>
Cc: "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport"
 <rppt@kernel.org>, "Wei Xu" <weixugc@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Lorenzo Stoakes"
 <ljs@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <x86@kernel.org>, "Sumit Garg" <sumit.garg@oss.qualcomm.com>, "Will Deacon"
 <will@kernel.org>, <rientjes@google.com>, <patrick.roy@linux.dev>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>, "Andy Lutomirski"
 <luto@kernel.org>, "David Kaplan" <david.kaplan@amd.com>, "Thomas Gleixner"
 <tglx@kernel.org>, "Patrick Bellasi" <derkling@google.com>, "Reiji
 Watanabe" <reijiw@google.com>, "Sean Christopherson" <seanjc@google.com>
Subject: Re: [PATCH v3 21/26] mm/page_alloc: implement FREETYPE_UNMAPPED
 allocations
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Yosry Ahmed" <yosry@kernel.org>
X-Mailer: aerc 0.21.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
 <CAO9r8zODy9UCrtJuU5_SuiZDUbg4dUYLhOyOwZtD-U0N0tpCsA@mail.gmail.com>
In-Reply-To: <CAO9r8zODy9UCrtJuU5_SuiZDUbg4dUYLhOyOwZtD-U0N0tpCsA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C355D120006
X-Stat-Signature: y985s31hbdrtrrtd3hygf3jn8f1cugsr
X-HE-Tag: 1786804251-468997
X-HE-Meta: U2FsdGVkX19E9wUVPUscq5ScKBI5qPFZKmx/dT/m2fqJ1IIV1XjxsXHo7fYhSC8L4XfaZqWewfhupUOBujG7EjyOAQD6JB+IelGbsi5xdYLK4d/e/RIGtSd2CokUfyQnSGThCXcqPa/8cgN/64XOyjTBLyPD0CNNvs6VE3hNqiTaiJa+co1lS1mrRsK1FCpwdLf90MztXv8nwbqiHfBTJqeB6q/6+PkCjzm2s622A5sDl0NtHJeoZNklzW3OtP9uVwforWDYvx41jujkdNP6frF+QU/wW9uXsYRNNX/nYJp5l7brBPoqwKJYoDOBGF4g/yFbf7K3VCzyY886ojeHpwz4KGRJgR8NSMrxpJXjYeIGbxC7yXioC6z/dVgnxNFgqq3q/AroH/5EPCezDpDpwK6jkkyo5Uv8kWXbTCmNL5UAZY+eMP4LoTRovnl9H/km9M/VJsaEWr6+ylI3ZvpezkhhZIZqNzrhZ6Ut1YdbMglVSu7CPUVTgyp6daI1SwJoQ99UX27kBXSTaE9dm46WISYDyRafiuE9uliLHVmqxhCXpGQouO+wHfwcI0SqtfzFXNEzDHTeFpyv/LBOEkBrraxNDRVVngO+QvEpnZ7aZc8LI29AbkPdVB2C0r0e2ZQ5IX/RnyTpc00zm+qYxA/XNzq1EJachMQfUVIW8RrOI/TR2Priq2iL3U1WjwuxsX2S2wnJCxSN9o09TPMALOnxIAdf/6Mt60bENGJtFwD66SQilwOBh3MqluRIDrtEi83gV7D6CWDOxtQKDY92UPeK8CdrLFpEp53x3KzEOJs/0NZwLTxq4PClOmAjg0ya7q2QHQ9WdKIt962MNpahZtigrwZ79KyCjCFyF+DXXXPMZY3ozZGLBLxkDh9ttdK8jv/hEcfMObggvGlbaCRNHcRQncw9KrNYIFYizp+6+bk6m4qMjKP5mz1kySj8byXX+6RhQOrLYa0HGKcST7cYFZK
 Gcxwf5br
 iUkoqUBWkKBO3u7nEV7qeHnR+QQE7+K49p2lGPE6C7uidvEuj1Ltfjy9zP4ZhhqZAh3UZjTbYSTeBOSaMq2kQLwiOYKus3veC3hnYkaVA7LfJ2mUme1kNwfkAzga6QLUgTV82jxUG+MSDK5T4ofq82vM5holocfxxjYqw/s/KRgXvdRD/R1b1ZLBmqoZ68Lj0S2rNZDlxZVdXqEZ1IKZxG9L0WyCigV9j/OZ3EXZS7hiM7Bkh4n65cRKA1mnEaY/7mCZAz0o1EmmX1zGrGhFTyVJrziLZDVbFipEqQm2EjQ1ujAvvq3fwVoBQlUuBqHfH8ayPM0DkJ2ftXLSPqy0N8k+QyXtAwVWq61qBLy3N9pCSag0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 7, 2026 at 1:16 AM BST, Yosry Ahmed wrote:
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index 67b01af024e17..c9eb3947ffc79 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -1393,6 +1393,9 @@ static bool suitable_migration_source(struct compa=
ct_control *cc,
>>         block_ft =3D get_pageblock_freetype(page);
>>         block_mt =3D free_to_migratetype(block_ft);
>>
>> +       if (freetype_unmapped(get_pageblock_freetype(page)))
>> +               return false;
>> +
>>         /*
>>          * CMA pages can only be taken by ALLOC_CMA requests. For anybod=
y
>>          * else, vacating a CMA block consumes free pages the caller
>> @@ -1444,6 +1447,9 @@ static bool suitable_migration_target(struct compa=
ct_control *cc,
>>                         return false;
>>         }
>>
>> +       if (freetype_unmapped(get_pageblock_freetype(page)))
>> +               return false;
>> +
>
> Do we also want to add safety checks in the page migration code? IIUC,
> if we miss a check in the compaction code and try to compact an
> unmapped pageblock the kernel will crash with a #PF in supervisor
> mode.

Shrug, yeah I would certainly be happy with sprinkling some more

if (WARN_ON(freetype_unmapped(...)))
  return -1;

here and there. But yeah this feels like a maintainer preference /
philosophy question :D If the machine is gonna crash quite clearly
anyway maybe it's not worth it, I dunno.

>>         if (cc->ignore_block_suitable)
>>                 return true;
>>


