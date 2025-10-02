Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12D5FCAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 11:39:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BD208E0008; Thu,  2 Oct 2025 07:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56D068E0002; Thu,  2 Oct 2025 07:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 434EC8E0008; Thu,  2 Oct 2025 07:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2CB838E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:39:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CD50311A0DB
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:39:08 +0000 (UTC)
X-FDA: 83952977976.15.AB08E4F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 70381C0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:39:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HyOBtIWb;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759405146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qa8gIa0V21yaVB+/eCXge80xz63JZQgqa74/kUyfFBg=;
	b=Zip/Hjg8b8OregSnmae+rr8Rfw4ztH4fBTQrN78/mUqJtEsf5fCL8aJoOR0JQHfi3xyqxT
	NSFWU2Sk8kvE7pqtAl2geEGZy2SSCYsGRj8kFo2/aR25KsWkGjkcJFvnqSHduHt8E/0J2p
	eTG2iaPFH5mhE50yKBfU6OpqfxPQoCw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HyOBtIWb;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759405146; a=rsa-sha256;
	cv=none;
	b=IePODxJcsSDu+DXD/onkp09wzQUrPRp5SY3JM6v+s2iAQLr61+lxbsdOvbPmRSzD7sGEha
	P5wdLvzGDbTMnBrNiWvGHmeiPgZ5PMTpC7kkGtVylinkS0/4vW0t8A0M+svauc96YqwW4K
	QHDT/hTuiKsxf6W+n4mnHltO61bwqkM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759405145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Qa8gIa0V21yaVB+/eCXge80xz63JZQgqa74/kUyfFBg=;
	b=HyOBtIWblvEJEBXvN6GOv0umpXcHxwQEIoGzcslRPqiw46gCXoLZZjyvoBYMbJY8FwFPCs
	mDh511PF+GsG6ezaRTztqcNEttZwNfn1TVSDz1n61i1oDH2zeI0RGTu3LaYGmuCsVUIMIS
	/MnMz7kSRIzYfXjgWMFRfEkLsmPezbo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-393-DhO7xu8fO2aj-rE8lLn2Cw-1; Thu, 02 Oct 2025 07:39:04 -0400
X-MC-Unique: DhO7xu8fO2aj-rE8lLn2Cw-1
X-Mimecast-MFC-AGG-ID: DhO7xu8fO2aj-rE8lLn2Cw_1759405143
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e377d8c80so3030885e9.3
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 04:39:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759405143; x=1760009943;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qa8gIa0V21yaVB+/eCXge80xz63JZQgqa74/kUyfFBg=;
        b=eW0WaUZyhEUAt3fK9PtNqngejM/CaneytO2a2AU/6IPznGsDnyct5lDIqz87LNxCuA
         5Q0JuzyPO599qLrQUe9WURQlfRGIcIJicpcewDfi1uQWZupNLo/Znuvjw/gKrFz5ZMV2
         f5jP68ipfoVMfgGujnEV/8Zdj3rjloZmhe4Cue8JcA8nelv68gTKAVE5rulX4cBYpNut
         G5EcJH+HoEijPPYy7+DkUC89aAnjpEcw6SddG96jqAurvizMFoRo8fqWAps2OoWiCpEw
         rFN7W1uxJkt2ywlTC72riYmDDa+CufpPul/UasVq8oXRIPxZtMV4K4+UWDJ88f6N2nng
         j7pQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsfDtPH8+lEGnNYC7fua52NQ58BjGlwC2lgkOAJ2jlVgdm+KZpxOzyy1NGCJhhH8enMRKw1n3OFw==@kvack.org
X-Gm-Message-State: AOJu0YwMNAh3ePMCKAH59tC6A+L4Bg/uVkOtk0DonZGKZztSHPz7PgEL
	yp62fZAY61BYoerEBQzg/WLd3lL8I22zDa0eEp3hypYxUOSHa1ixdOtVyZXh6xOUcSGggtU8pLm
	bGyj7F4UHbUorKRnoq725hUx1a5Y0uYWaN+2JfLdhNf/R9Eu1AEmW
X-Gm-Gg: ASbGncshC9Y9ak8AlTWjWxh5LTXcPC53twoOuLT+AYi2SARRBnk+SG7JA7Pa1fZRQzo
	RRMSSZrG1+5BVrosjw8qhhd71MNQVdZwzhT8eXrNGPmT1RKeNDD1JNvJJCnL4bH+duTY2YkUEEG
	CPVH12uezq1xH60PQabi4hkG+GKEBYjBiNbOWCZk1QxjqJqyrgngv1I5AQilsuPwDSRGA+Yi70G
	TLjR8rCwQg4oMtB5fFTBqOHWOjHHp2P/aP4Q8VfnjWjg3LNdkaaSG2ISXMaFyqGzlS/X5iCvI5K
	EXYWj/p+kh0krb4KnWrjAEx8TOoleiBgmfqUXVX3QDd0bErwJk/Q7DB6zsE5riq//QmDWEiYxNS
	uRjGBpbea
X-Received: by 2002:a05:600c:3e10:b0:46e:5aca:3d26 with SMTP id 5b1f17b1804b1-46e653f84camr38704705e9.22.1759405143345;
        Thu, 02 Oct 2025 04:39:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyThTO2nCYVKvGrKXsprfkdDNwOhJqAGfAyefFwycoBiTM+WyfaA8y0YZWBdbXDJvOp6TQbQ==
X-Received: by 2002:a05:600c:3e10:b0:46e:5aca:3d26 with SMTP id 5b1f17b1804b1-46e653f84camr38704395e9.22.1759405142936;
        Thu, 02 Oct 2025 04:39:02 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e5b69bc0bsm54311425e9.3.2025.10.02.04.39.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Oct 2025 04:39:02 -0700 (PDT)
Message-ID: <9a586b5b-c47f-45eb-83c8-1e86431fc83d@redhat.com>
Date: Thu, 2 Oct 2025 13:38:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm/migrate: make sure folio_unlock() before
 folio_wait_writeback()
To: Byungchul Park <byungchul@sk.com>, akpm@linux-foundation.org
Cc: ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, clameter@sgi.com, kravetz@us.ibm.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 max.byungchul.park@gmail.com, kernel_team@skhynix.com, harry.yoo@oracle.com,
 gwan-gyeong.mun@intel.com, yeoreum.yun@arm.com, syzkaller@googlegroups.com,
 ysk@kzalloc.com, Matthew Wilcox <willy@infradead.org>
References: <20251002081612.53281-1-byungchul@sk.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251002081612.53281-1-byungchul@sk.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aIN9dC05J8TMW1heWUuxVzxtSWWbc6f9kpMF1ssyWj4_1759405143
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 70381C0002
X-Stat-Signature: qnoxiobbc554htrkzrbrj7h43tzmhzn8
X-HE-Tag: 1759405146-4281
X-HE-Meta: U2FsdGVkX18vbsdc9KSVx6CpeOT6aisHYpvvLxaUOI1lqpx2ox8vAgGrKqPszoeeauTpk10EcZRogqKz0DTdCZakLpdqVu1at/6BqcKQ4ovf84t27qWCZ7u5wN9hg18ZVeZpsXKvOZ0+fl3WgOE5fUkzZPwRcAJAw6IQk7SEXA7EV2rFwvtsJAYaq4o1RB0t7ER2Vu3F93/b+exo3PbJtLvkz3xvkamljhtoz6crzIPpByJKpZC0vMAyWt9ggyvfnHlez23izidXhe3RNCGf+jqYFl5Y0Ge3DE3ZsmIr8pCdmaoRONGXNNPUnIidVXJMzcxrtU3dAVjBZuglnnDQahtWJcWBFeawi5XDVmdEErq088jyxTEZuzQSm8p5quKWGMJQpbA4zfVL9tezpSK3yCd0/QGv8pwiJE73o33womdtfNr3C+g8VwPOrkJcv6UeZDRNmdIv5xiojQY1l2YZvZU2IJsNW9W7oCRBeVv7Iym+Lu2rIf0hqrmqk7SU+FwX2GSZ9h4gps2VwN/q4wsQBMBFIwcnqgDcvNYhGHatLOh60jKDLUFjssUZs63EoJZsvkAf266xN49Cj1M3UYdNDKNVejAEkavdXJbr8mO9/qdzqP5o72c3THOhbBkvqgyKNd33ivmYrLVw65oYLdllILFXok+94kE8b/uCHDfvcx5qHjmYjrUcnhnrTrez+jswukQHB4ApzdQyZGGWfVgvMoHtS8HEPcHl2u9c8xMtNtv30WISKN3HiK7VfXfC3ViJJePqIGnXBnPdyowoso63hnBFviMzHD8nRm+O3S36x7yWkd3aYS8LhojJs/LJeVOPgLjfbAPIX9wmOsAoM7RU4+nMqY8m288YjvVm59OpRuUBbGuaxsDlDNP1JnELeKSjxDOSGYgu2cdWyUW0ZHnn4AzxDYrJI5b4PDfdscmYevsVpWqipwuXEBn6CQWPTy3w1dDTJZCWEO2pMPuK4mN
 0ZMjtL69
 XX0obrd3m8asrs0vN7BM7cDwNLkZtudNE4MA+LojRwk5rPl28gem0ymr79S91/s9SIMhsLyPN1CnIAWVyYEqpIznCIX/vPVzvFSOimxP8ZpYCzehOvg3TduG+hYlPLd0yLsK371AxypY4No5yI+FqbBfMRn88pzEcVX+Q9wpsiB+03Gs7sCjvp3AGlpFkfTxZWj06UnBXjSAcWwBRjoFyu3RY3KpEhROozuYAty2lonAHDwO5QdZGY+NnOpyPIaEup01f/PUfYxwogPEanAr5aNgZco+CouMwkCTxw3YIZ8ioVILoM4RD8d6sk273scANJhpDySUr5E47gYQJ+vmPYEoP4VD096VvV78Qna27rOQby+sYrRzBbwjgg1n4SmjQPtoTWb9MDbGl+J1f5xMZOAoXxtfRIaiP0c77ZUu1rDV/hSQu7QHYyUSV4nGEYnm3vB1Hjw3LDYCwMhD6e06I+95ENIHRYvCZB9zLVFy493vO05F0bc+DAfJWX4a1+opuokRHx/7qX5k7Wht7+sYqNQLvuVyoqKJZ6AdB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> To simplify the scenario:
> 

Just curious, where is the __folio_start_writeback() to complete the 
picture?

>     context X (wq worker)	context Y (process context)
> 
> 				migrate_pages_batch()
>     ext4_end_io_end()		  ...
>       ...			  migrate_folio_unmap()
>       ext4_get_inode_loc()	    ...
>         ...			    folio_lock() // hold the folio lock
>         bdev_getblk()		    ...
>           ...			    folio_wait_writeback() // wait forever
>           __find_get_block_slow()
>             ...			    ...
>             folio_lock() // wait forever
>             folio_unlock()	  migrate_folio_undo_src()
> 				    ...
>       ...			    folio_unlock() // never reachable
>       ext4_finish_bio()
> 	...
> 	folio_end_writeback() // never reachable
> 

But aren't you implying that it should from this point on be disallowed 
to call folio_wait_writeback() with the folio lock held? That sounds ... 
a bit wrong.

Note that it is currently explicitly allowed: folio_wait_writeback() 
documents "If the folio is not locked, writeback may start again after 
writeback has finished.". So there is no way to prevent writeback from 
immediately starting again.

In particular, wouldn't we have to fixup other callsites to make this 
consistent and then VM_WARN_ON_ONCE() assert that in folio_wait_writeback()?

Of course, as we've never seen this deadlock before in practice, I do 
wonder if something else prevents it?

If it's a real issue, I wonder if a trylock on the writeback path could 
be an option.

-- 
Cheers

David / dhildenb


