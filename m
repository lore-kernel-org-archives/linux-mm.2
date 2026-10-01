Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69B7DCA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 08:35:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BF5C6B0095; Thu,  1 Oct 2026 04:35:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66EF86B0096; Thu,  1 Oct 2026 04:35:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 539A96B0098; Thu,  1 Oct 2026 04:35:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 293686B0095
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:35:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 772C980351
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:35:32 +0000 (UTC)
X-FDA: 85273398504.06.D137A02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id DFB85160006
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:35:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BcEusJM/";
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790843730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=suCKWCuc1bnOWffxzPTwdfuwNnlJqXA+qy0aAkoGCSg=;
	b=bgGHkuAmoAaxxz/mpsEoffMR/c32RpgY8owtzjwhJfsmWg/+AahwtqG8nvn29hJsnmoFe3
	Fc4js1FjKlYrfnozPtnPn6Zk8ghJxoAFZ4KjzeLE7SpDl24yZDd8U66eQRVsdNBiRlAd1Y
	w1CS7sGfF+ieriI3mMHvDKEQNrEd0fU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BcEusJM/";
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790843730;
	b=j2N/6r/NQnxYev5ZnSQlR2n4TA+Zo15r6wgB1eQVsg00Pc4JvrvdKjFPlYRX/RluOxTMFG
	DYNlpHyEWOMB0NwOwHNIOKRH9w1OjU3xK1VxGj78megx4ASBqwEqopPji3iLZ5BjsKP7Jr
	hTCsb7talkanKCwrykbQcO8BPJhR8dU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F113601FE;
	Thu,  1 Oct 2026 08:35:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA601F000FF;
	Thu,  1 Oct 2026 08:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790843730;
	bh=suCKWCuc1bnOWffxzPTwdfuwNnlJqXA+qy0aAkoGCSg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BcEusJM/janBADkvh00+H9aJtMWGPHTnd9wKQ2NmwFAtRA5DZCwhibfkEfdQ0cy2U
	 eWNDs9yOYDdzF8gWtVO8naGpWDV+SeKHnMAcWZ28+A5JQSWAnNua+fZTS4wL5SH/kt
	 0JMsNRvWdfUUQV+TGlMorXeHabbjIvNZiMruYNjbBUkUd4IDa8K+2kIZw5MXy9PuZE
	 zYoaVF2MLGHOjMXsyjq61OmQ+NDvdp45Yu6X7ckZ6vNeDqJV2qtXl5kbdaH5LAiS7/
	 mw+kOSyyNtYJWh7rXmjIdHR7AhuIaFqbTFyH8MzputxAHbYqZWfta0xvo9IAVEDpYn
	 B3WzwGT1PmRIw==
Date: Thu, 1 Oct 2026 09:35:25 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: =?utf-8?B?5aSp54u8?= <rockeet@gmail.com>
Cc: Jan Kara <jack@suse.cz>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC] madvise: best-effort deferred writeback for shared file
 mappings
Message-ID: <ar4WSaLYBs1db1-3@gremlin>
References: <CAAE3jtcRQ407P9LTbg=JOwhABQRViSaq2XBefnDdNWiD7PxvUg@mail.gmail.com>
 <1ce9cf3a-15dc-4815-ba29-2e22b05206fb@kernel.org>
 <art8EKRKMdwSDCkr@gremlin>
 <CAAE3jtftxMkCfWJ77W-xvV2x7jdAN8C8kyofYC3fEivM-Cq6UQ@mail.gmail.com>
 <arz0auULA33fqoWu@gremlin>
 <arz8Plu6J4YOTi0a@gremlin>
 <CAAE3jtcanTUrV3xfofwrvYGCFe5o=Vn7gS66bDzuxzeGg6c5=Q@mail.gmail.com>
 <CAAE3jtdHi7aSsJ62TpEjkxvwA-3TBLvr5i1ohCNg2aupND+_XQ@mail.gmail.com>
 <xhrorb6wn2j2j57ydnt226khnu6gv4ut3crrmjwjr4iwj7d6yo@43lugxdthgyi>
 <CAAE3jtexTRdqzAodzCkAy5NtH_s3VhtutXbxMjangf8BtB+-dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAE3jtexTRdqzAodzCkAy5NtH_s3VhtutXbxMjangf8BtB+-dQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DFB85160006
X-Stat-Signature: 6cthrx7jthcx83mrrs9mbe5393ofy7pw
X-HE-Tag: 1790843730-207472
X-HE-Meta: U2FsdGVkX19iW+4fkhpFizYIH+1Yrfv9pPdjWbMHCWlHJjZFw7WDA30wYN4c8XxGf6rgQdLJ0AmcnXDg+AGlaBxJgM/k3MRDOiYs/BpYnCy0zXRNd30IiPgccem8AzRtXhRhmw/7x3JRY5kEfG2m3eySsabnx863SIGVbo72jU9fhPDvnqbTLicXb9rmNNyuvxjvzcqOFSL6Ilixb/JIFu/1OIOCvPqpsxNX1ZfFwncXx5ypzkCpc0kCUCrC17nPoVaNbkWFSQ6aNlXZ8dfvi1RiUPNZ5RnMYICLW84qP5cCxorJesHqcUpxdWoZopuV8o6rKDaiM+lrxdx5Gp2GndUNRJ6vL22esEKBiNQ8kBJfZqGyxjsTCdnRVWqLUI0QQ4M1qID3RryU/oXPIGOHv2jK399PokC1smH+5dlKGi1IThipLmSw9MxRxEan1OXo4bcqTeSNI+ZIkl4jCECYN0CdsHhvXHNXQrT8Fk3JL1QdYVqXw+6NUqlSuR8KsaTBsfiwPLv3VOLbX0qNs+jM2R9fbgj0MFX2bHaAdrRoenTvS2zGhQ7aB7ys+XumzI+hNmoENjPfBZCFDREaBzJTOXkMVNs02OD97DWR1y2Wo2f8eoTRjyYRiJJP/FqnoOfP9ig7I1YddQ1Z4Bp69dLSVsE5rjujQ+Kf3FuCE9O0Y1kEs2+5uVoPAJM7CKyKYqON/7BdeMeVcFSWQfBn2mfqFubUowL12Ro6YbVEHE8zfXBqDXCj2swoTcNvFQkLZpjtxj83/J2O4jd17bi3Yc3KFP1po02OXiJFHBrT/t3lLi4nyIsPm4mK+/mgbVm9UqGDRzt0pynZB6Laz8Ni27Mji+2iY4XTgDaP/9oviJWP5b8Q1WfIeoirpUGfXX1oOaqpEdA6KkJW5n9U8vlRti7f+UgEXcoAjBwtHdHlL7TZKKckQ/7okCpNyay+2ZnFpQrr6fHqoZuJyKNlIgZodR/
 I+oKBSBu
 0Otl7Tg9XCoKnKQDDVAanOgvbWyFEYbCGU+65+ynu5a0niv9o6ODr9foE+xbCO12z3yxITCxNjvsUaiyd9JgDjgUGgq15xIrsMKZ7s3GYrd6aoYj2qp2v7H+c/KZtPHjrBZGzqdhHP8HU8S9XaCs4ufXkAqVc/DP8nAM85Y9Df3o1Mr3sOZ42YJyuOzpQ3+d9Fvd1fLq/TxgOK4Y9C2/Gb5TPp7Ied4kFkj4cOFEoLMASojblVjgjMFO8J2NS+W4OLd3q/Ch8ELec1wZYCsynsN5bCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peng,

(Point of etiquette - and you are perhaps not aware - in general in the
 kernel we reply inline to people rather than sending big lists in
 reply.)

>1. With buffered I/O, the data already resides in shmem, and writing
>it to the regular file allocates another set of page-cache pages. When
>both copies are resident, this roughly doubles the memory occupied by
>the data. Traditional LSM MemTables are usually small, so duplicating
>one is relatively inexpensive (they waste so much elsewhere that they
>never even reach the scale where this becomes a concern). Our
>MemTables can be very large, making duplication a substantial waste of
>memory that significantly undermines the advantages of our design.

Then use O_DIRECT :)

>
>2. During the MemTable-to-SST transition, existing readers still
>access the data through the MemTable, while new readers access it
>through the SST. We therefore cannot immediately release the shmem
>copy. Our current ConvertToSST instead renames the existing file and
>appends metadata. The inode remains the same, so the existing MemTable
>mapping and the new SST mapping share the same page-cache pages
>throughout this overlap period.

That's your choice, not a requirement. The SST is the MemTable plus
metadata, so append the metadata in shmem and serve new readers from there
too.

>
>3. AIO or io_uring with direct I/O avoids allocating the destination
>page cache during the write, but it does not turn the source shmem
>pages into page-cache pages of the SST file. Subsequent SST mmap reads
>populate a separate page cache, while existing MemTable readers still
>need the shmem pages. The duplicate memory therefore remains a problem
>during the overlap period.

It doesn't need to. Serve everyone from shmem until existing readers drain,
then drop it and switch to the SST. Only one copy is ever resident.

>
>4. Temporary files are a much broader use case. Periodic automatic
>writeback is unnecessary for temporary data; writeback for memory
>reclaim is what serves a practical purpose. A per-file exemption from
>age-based periodic writeback would benefit these workloads as well.

Temporary data that doesn't need to reach disk belongs in shmem :)

Overall - each objection so far has been to the cost of changing your
design rather than to the userspace approaches not working.

I agree with Jan that the inode hint is viable in shape, but we'd need a
good reason to add it, and avoiding a design change isn't one :)

David, Jan and I have all suggested a shmem-based userspace
approach. Please explore that properly first.

I took the time to write up the approach, in detail, at
https://lore.kernel.org/linux-mm/ar0mdJKLC0cHBoKM@gremlin/ hopefully that's
helpful.

--
Cheers, Lorenzo

