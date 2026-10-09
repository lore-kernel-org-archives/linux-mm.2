Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B81B6CA601D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 16:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 546466B008C; Fri,  9 Oct 2026 12:27:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51E206B0092; Fri,  9 Oct 2026 12:27:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45D206B0093; Fri,  9 Oct 2026 12:27:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 257796B008C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 12:27:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BBD6B160468
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:27:10 +0000 (UTC)
X-FDA: 85303617420.02.EE575C2
Received: from mta1.migadu.com (out-202.mta1.migadu.com [95.215.58.202])
	by imf01.hostedemail.com (Postfix) with ESMTP id E369D4000A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:27:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fFJt5But;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.202 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791563228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+XmVIXcevzCKIMw2kPiuGNxesWcbtj3AUfqtfxxDJSw=;
	b=0BtDr4WhhDS2doiJcxZzdd8pSKcyMS3HJFZieK5vB4sfeJqhHi40uyg3sgHRZOP65GiRw0
	Jm7U3nYloDyzuczGpbn5BPi4LUtPYgO+Kemybd1rnloWlu0eaW9sMA7pPenm/4Jo5AYuvo
	HGDbDrLmeR91YxYz/Zcgm7qB3yfdT5I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791563228;
	b=k2N0/OUH5iwPKhi/t6jC+6jb6535lFN02PTFJs76LGkYAzHXMFTn2vKlKmC87sZbdMBbEW
	x/feNBpgrfySUIiKLsrWGzp051bzNHNQ1HkCSRGkVvqI0v6wdIVetnF1aD3QU1CnF7LeqC
	JfEkNmvala/bhDTKgG+Zj+H8TXT7pfY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fFJt5But;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.202 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3+ISbXvxNBs6+/hE67lzmNGr70P9/qRzm+LaAlqac3U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791563223; v=1; x=1792168023;
 b=fFJt5ButOHfCAjmIVQ/GOHQrojiSPTPUfGPnFb84/0o2sEo2GUpzfNexZgS9MQBVaEbXAn4y
 buWa0yo8PtFm3NmLDaxd67Ql3tdFx+FH6r357Ftn/DtF8RiBBv5b7mp6s6SHStgkfGxoSHvstQ6
 WFDj44i07hwAOrGMXJ34oXdI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7b24a70362aefd2a;
	Fri, 09 Oct 2026 16:27:03 +0000
X-Mizu-Trace-ID: 7b24a70362aefd2a
X-Migadu-Flow: FLOW_OUT
Message-ID: <b11ab591-3839-4486-b4fe-77922addbc31@linux.dev>
Date: Fri, 9 Oct 2026 17:26:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: zswap: use separate compression and decompression
 requests
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev,
 dsterba@suse.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, nphamcs@gmail.com, terrelln@fb.com, yosry@kernel.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kernel-team@meta.com
References: <20261006002307.2669023-1-usama.arif@linux.dev>
 <20261006002307.2669023-2-usama.arif@linux.dev> <asiUXpjrE61TLMxQ@google.com>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <asiUXpjrE61TLMxQ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E369D4000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: pwqhq5h3oezxewozy9u4f84iewpgjyw9
X-HE-Tag: 1791563226-196152
X-HE-Meta: U2FsdGVkX1/ufh8PyhQ26mSIhVUptyPNYvEND5lKUzhXa0dEg02mc25gSNtOokEJYL8N/L1pkVkc7nN5V3Dswp6sXhyS4sT92o8wdAsACSXxav84iRHPAtKXp9MD6GV4MGzjDOdL3RUaow9O8s/IsBMa0hL9ANj7gWGkOajgRsGhTcazaARIQYw6hScwiDXCZ3V/fy6H+AHFhxR9zMteE8XyJLtNwF46Swgq0VT29PVeLljp3io8RCgGcKjBfJ3olHN9UJXZc1nOt+w2rrsthgfNyO68+4C4qMJSVxOIY9QUxbpZ2K8j56dhsIBYeTa+woDoRcIvheifwG7+lS4BwR0qRoSDFlf9Ww4XqpSJG4qvfgbzzuAZnwXfAfjvII61lmjN7EdPCOrXa0viM3w42IVfINLWnc3W/yRSlWSsUlW1J/Cc2oAjb8OrddB/vhbMAFIHqxkEWkvD6XrpKuwDMvq9UIOKAaQNMF7bNDbYOcEMX0rBuToi0u/6dVJYD9O3YHwIyH/PEpjP3gj9oOnXm8eyAB1nGhVmF/2tCqZ0/sEKNMMjH5tkgPFhsSAeTOYbfjQxQ68KMVdItlI/TS2CIMx9LSd14mcPCi3NzBJPRVTKVPCtapuLUzvXYfQG4RGX3B9ZwrxUs3Yrmbd1M7Py4p+6fSr7nyiCtT91s3SYNKIsHVJfBrN3nU+El6jTCPtSiWfKqWtvR01JBO8VTXhBeGLhKwJtdtaEcTMBnNW5HiYxBJB8ZcoFoBaiAyL1hCPyuAQSagO3+RuRWEV+MrRqATMJi15TQytxeW7XsjxW0W+BX+VW/rNaD+jUJoNadarUmyRStMYOE7+TjzsbcBBUczqZEo8Y3po86YwgHd1hA4g08OcWVX9q22RRvMX/dBDoHxxXoRpmX0HA9uQFWOhgpoSZt+k7g32RpR6uIGJYRXQyX8aEDSdOGCcGyK5an2pEXRS9mWbO7TAMBLRULxC
 0k4aHuO1
 odQ8iKjL2kRBEJwgsStEQS6XNEkSjrGghPk03ObaFMJyhi4YQMbb9fWff5AtJH6CI5rbljiFBsTcJ8mwWAqhSkp8QCMLnWngqKuJ+1K6FZJtrekNkBDRchg641c9b9nMZWGWNsIVuKwl8EAFnpayyhYJP6hUfcspmVi4RhYs88N76rRUG1OazdzxO98+0nR+0ClV+0fNHp66eW17OE2/vSCFKt1cH5JPCWq3dbnqbNw14v6YlFVGImrg3IKc2qHRD9zHoyU6Qr6cRwl7pVMmt/JGiqQUh/6QLfbpc5tbSsn/75ddaIWm9CikSH4Uan7sZnwO3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/10/2026 09:16, Sergey Senozhatsky wrote:
> On (26/10/05 17:22), Usama Arif wrote:
>> Stores and loads serialize on the same per-CPU acomp request and mutex.
>> A low-priority store can be preempted as soon as the compressor drops
>> its stream lock, while it still holds the mutex. A higher-priority load
>> on that CPU then waits until the store runs again, which can take a
>> long time when other tasks are runnable.
>>
>> Give compression and decompression their own request, completion wait
>> and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
>> decompression APIs from zsmalloc"), the per-CPU buffer is only used for
>> compression. The two requests can share the per-CPU transform: no
>> in-tree implementation modifies transform state while (de)compressing,
>> and shared codec state has its own locking. Loads can still wait for
>> each other on the decompression mutex, and stores still serialize on
>> the compression mutex.
>>
>> This follows the proposal from Sergey Senozhatsky for the same split
>> for zram [1].
> 
> Greetings zswap peeps,

Hello!


> We pushed things a little further for even more gains [1]

:)

Thanks for the inital patches!


> 
> Catch me if you can ;P
> 
> [1] https://lore.kernel.org/all/20261009071157.3730698-12-senozhatsky@chromium.org

I think it wont help zstd, right? It would help stateless decompressors like
lz4 I think.

We could that as a followup to the series for zswap.

