Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07C68CAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 08:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 457498E00CA; Thu, 18 Sep 2025 04:11:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 406CF8E0093; Thu, 18 Sep 2025 04:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F63A8E00CA; Thu, 18 Sep 2025 04:11:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 194988E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:11:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A65AB13BC6B
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:11:18 +0000 (UTC)
X-FDA: 83901651036.29.A3AC775
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9339C40005
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:11:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="E/+787Ig";
	spf=pass (imf04.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758183077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gpdf5zd5/ar6nMWB3h3rjQXpfUfe+I/6t4BRZfYK1Fg=;
	b=qfzrT+oz3gAr2NAsjI58RmxbvFmtFJmF9LIZdWI+WOw/MY6dIuvUJ9D1CuWj7eJz1tJ54y
	hc4edThEq05xB++jXqt3jCaI13sQ9ScqZSGuUis17s2+Aw2rj+6Y/joBJ16FTTp4oquVpv
	xeG00iBfDZCGeGdin9c70CVvZ5q6/xc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="E/+787Ig";
	spf=pass (imf04.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758183077; a=rsa-sha256;
	cv=none;
	b=B5ahjvXuleVelnVOJP2vpZr9rROwEG0P5IFftrWqcL/KlyKEaXgWrMPHSzumuBRjGcb5S7
	HyE2TZuQ86PJU1ekm0/PQM4KRSJoZZhlymzyhAqzwG6qYsyDYMaNgP5LbzR+mp4NNGVyaS
	JWblLV2UVYd5mORqskolx/07eVNv7QQ=
Message-ID: <1a9f44a1-855c-450e-9dc4-415a29b90011@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758183074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gpdf5zd5/ar6nMWB3h3rjQXpfUfe+I/6t4BRZfYK1Fg=;
	b=E/+787Igq6FLtq7IBnUzJz8t8JWQ0z9A36rBHkQT1b8XDJtgz16gaPD2eAvx+KcEItNW1u
	RLTJMqAvXNnHNZv2kMTDYiK+S7IAAbPyrn3iBnCsmmesZCrmLexQKBArkpNMNwaMhU9lFk
	GsK6teS25ZC/b42u8jTb1xN79kGJ+6U=
Date: Thu, 18 Sep 2025 16:11:05 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/vmstat: add header line to /proc/buddyinfo output
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Ye Liu <liuye@kylinos.cn>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250918071741.526280-1-ye.liu@linux.dev>
 <aMu01xIkj-3hgW88@tiehlicka>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <aMu01xIkj-3hgW88@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9339C40005
X-Stat-Signature: 4pt4rxd5kew1m783tbyb3sswwhk5a67c
X-HE-Tag: 1758183076-884013
X-HE-Meta: U2FsdGVkX1/jI1fEGRFVXKmFaYIJ6p58jbrNtNJ3JcJHIoDMg6OSsIzyim6lMmBJDzZsEJlXvsHzWp57NDHxDCInKBfIrcIDpQvzm+beGy5ZfmbgYyoPYXBNXFukqwvpmh0JE3G4Exqa0NsSWzNRuX7efDbJmW9UkIUJt/EPjo6smxT8nZJDT+e7eGiRw0wyQxg+8stxm0ecjaF0CZSY1qeBMr1o8jzmR4ce3DNLNM5ZMdUwJs+bo3Jmrx/LwIgSfC+Rx9z9/6aPkkWvRrvFYFX424DExXafXkddQs3CNXZ8NRxxYLRMgw357UEt3nz2WSppTsFMnpwiuUCZDvd0NyU60n8UAwfHr6VIMlkobXDqNcoOrpicRBfJ9qnBIky3fnG0gXhoaDHQfU/pJW6g3QYUPFqZkKnM6ssu9ew3TPcw3H4i9XmcZwb/udS6Bk0ZuBg3OnjX9vhPI7nOppMM8jkm5q7sZs1RuWqtJWueDlTR7ggiYK3+uZgNG4gRRXjXDR9Vok50LGn72MMBT4MpH+yfV4vi+CUY81/1IAnr+6HpgQdn3FRdOQ+tGcDbqghB6VfrLumsYDEoPR+Zquq89+OwPhbDHZ1/9ztp/8FLgwFoONJ4tMV19tofc93kb9Qlppp8sgV8yuinnwKPPimwCoa5UAs1x0BWTtxLMW0luyEB2lddG/f1LHEVuUcdIU4B9YcnxZJrVtTdzIGxWy9MiXN9iH27Z/BBM2RIkKYZNX9qGi3UffOkk/8gPIAyosvXllaBBMTU/Tqy0P3R1Q78IrNgNwB1Q8wjCMWkOtLyYKv2IpBb8tYctfgUfWVZnHSPaax8jMxZyDTR07S5nB5OsZEneEODo/42h5Ee48bfY+F49epM9MIBzijSxXLZG8e33v1Y48Tr0XOvSJpuHt4hB36vEEPpapwE3WpkDIxBbnjELAByPCDnkIuoAwxUiNRnDLxjRcmGIPTgtvQaAXr
 iMoL2/gR
 0WpNboFiocCPQBbVPO9Fwaa7+RcjFcm9Y1a3zXiOvXIWwqUzCYFbmiO3WKq7CVzFmxS72DaVlnl9u47++/VjaIqbSMdlX0BDd3ePJZIEHIRefy8AgPtGkieZ9CQZSAjTKXmWga5FBxijXKq409XQiR6XSeIPT14VCoiZW5omjBe5NnOesG4rUrAzxNNtGyhx9SKZ4qle45b9dMW+uQfTfoFNoasZQ1lRBE7fVKJARPKJWkNc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/9/18 15:29, Michal Hocko 写道:
> On Thu 18-09-25 15:17:40, Ye Liu wrote:
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> Add a header line to /proc/buddyinfo that shows the order numbers
>> for better readability and clarity.
>>
>> Before:
>> Node 0, zone      DMA      0      0      0      0      0      0      0 ...
>> Node 0, zone    DMA32      5      8      6      6      7      5      8 ...
>> Node 0, zone   Normal   1113    351    138     65     38     31     25 ...
>>
>> After:
>> Free pages per order       0      1      2      3      4      5      6 ...
>> Node 0, zone      DMA      0      0      0      0      0      0      0 ...
>> Node 0, zone    DMA32      5      8      6      6      7      5      8 ...
>> Node 0, zone   Normal   1113    351    138     65     38     31     25 ...
> 
> Why is this needed? And have you considered tha this might break
> existing parsers of the file?
> 

Thanks for the review.

The reason for this change is simply to make /proc/buddyinfo self-describing.
Right now you have to know which column is which order; with a header it’s
obvious. This is similar to what /proc/pagetypeinfo already does, e.g.:

  Page block order: 9
  Pages per block: 512

  Free pages count per migrate type at order   0 1 2 3 ...
  Node 0, zone DMA, type Unmovable             0 0 0 ...

Regarding existing parsers: the patch does not change any of the existing
“Node … zone …” lines, it only adds a single header line before them. Most
parsers match “Node” lines and ignore everything else, so the risk should be
low. If you know of any existing parser that this would break, please let
me know so I can address it.                                                 


>>
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>> ---
>>  mm/vmstat.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/mm/vmstat.c b/mm/vmstat.c
>> index bb09c032eecf..e9606457ab91 100644
>> --- a/mm/vmstat.c
>> +++ b/mm/vmstat.c
>> @@ -1574,7 +1574,14 @@ static void frag_show_print(struct seq_file *m, pg_data_t *pgdat,
>>   */
>>  static int frag_show(struct seq_file *m, void *arg)
>>  {
>> +	int order;
>>  	pg_data_t *pgdat = (pg_data_t *)arg;
>> +	/* Print header */
>> +	seq_printf(m, "%-21s ", "Free pages per order");
>> +	for (order = 0; order < NR_PAGE_ORDERS; ++order)
>> +		seq_printf(m, "%6d ", order);
>> +	seq_putc(m, '\n');
>> +
>>  	walk_zones_in_node(m, pgdat, true, false, frag_show_print);
>>  	return 0;
>>  }
>> -- 
>> 2.43.0
>>
> 

-- 
Thanks,
Ye Liu


