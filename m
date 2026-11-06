Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C5F1606A339
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 13:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cloudflare.com header.i=@cloudflare.com header.a=rsa-sha256 header.s=google09082023 header.b=XzbR/3ZV
Received: by kanga.kvack.org (Postfix)
	id 9540A6B05B1; Fri,  6 Nov 2026 08:18:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92B376B05B3; Fri,  6 Nov 2026 08:18:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 841086B05B4; Fri,  6 Nov 2026 08:18:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5774E6B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:18:14 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E9A60A8D29
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:18:13 +0000 (UTC)
X-FDA: 85404747666.07.57F957C
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf27.hostedemail.com (Postfix) with ESMTP id 09CEE40009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:18:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b="XzbR/3ZV";
	dmarc=pass (policy=reject) header.from=cloudflare.com;
	spf=pass (imf27.hostedemail.com: domain of mfleming@cloudflare.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=mfleming@cloudflare.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793971092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/oCBIQX9QmZ+F4LHbpq5rJKGHjQ9IObJZdmhy+V9C+k=;
	b=SYYHWAzbcGsm6d5CUyJLPn7akUcM1sCR8w6KFWAGgNa8osekckZIWNbIEasXV7+bD7keUX
	Hf9PZhYEqfu1h+2g37s2eZSiyTeYbUJCsgYokKp+p2ygES0h8Bd6IiIVwR8zYoD6leaWAX
	kBFyMVSxnR6B5BMzyypmxBJ0aYOj49E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b="XzbR/3ZV";
	dmarc=pass (policy=reject) header.from=cloudflare.com;
	spf=pass (imf27.hostedemail.com: domain of mfleming@cloudflare.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=mfleming@cloudflare.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793971092;
	b=JLGefThtC5lwOMt2pYnczKAxic+NuBiVWJd6pqigooLa43JyaoeK7vd04W3sbVbVfijS2+
	ziz9gZSJSxvM9rjC2WJjq2yc3jgZpA64e/oWlCDf0HPUVusxwqRxoPKWqSBdJOCb2lCnOw
	v3J3YIQb+ueKWMRGxqLhdDVEeAlMJzo=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4922523d1afso392353f8f.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 05:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1793971090; x=1794575890; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/oCBIQX9QmZ+F4LHbpq5rJKGHjQ9IObJZdmhy+V9C+k=;
        b=XzbR/3ZVr9qwThzI8BG2NfjM5zZXcH3gbulWfyH8HMjMwG5yG9UuAegLrGYGr9DzQC
         1gdfqixuFADslfL1DbBHc3hMOChSRfXGuINyDM9+DVUcola39Jo1cwkQSkEQ8dswal1n
         gB3qnlq51GDDxGfV17ClF2/6gFqbqLDBK5X+jFSJMEVnDRvqLVMY2WN4/+Yai/+8jlcB
         Hllc6sDPYlHm6g6ELLkVauXcE5xos0HKfQwE33wN6inSfwCpa7fhNacREP9Dt828s0If
         V1VyYq+4DpuI8bx6Iju9FkA2zfwWW6YkuiztWqRY5RK0irH5cBb/Y87i+xCjTgc+QQtf
         WF5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793971090; x=1794575890;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/oCBIQX9QmZ+F4LHbpq5rJKGHjQ9IObJZdmhy+V9C+k=;
        b=fl9aLL0kaYxHSqFSasawXljuX3AcTdb/SchvCnb1YGnAOLcRVU7Q4pShB4stwEV62s
         dQfX1CdsgUphowNm5YNOklh+57gMHHCRptB8FvYYO2FgqQeE2gngwGPiZoR8HxLDcXYA
         YHGwdl9idZ1FMh3zaRxD3DR7g2ArrU42ZvD5acLqeetYWl/DT8dOk58Ex9QbK10OtWtx
         N1r4O5TjdjoSXZNCRPYBwzDcWe/v4FafbfLaL8dkpyy2r0fPVOMLZPsaorsHqR0V1DED
         dzd8BqGfbyl/60mYA7eKXSVCyS7jHIJs2Z5efE6QqvjUhgUPqA4VGDC9u3DNYwPQa0pO
         v9aA==
X-Forwarded-Encrypted: i=1; AL+hErE0o+TPaY/gI7AY9T3uooNWh6SiCb6hVhWgljVTjnRG54ezowkzBnmBIoZVSsZ1xyrJV2kZGyNRcw==@kvack.org
X-Gm-Message-State: APuU4Z/LfkDpfPV1hDkK0kjCuz4LDH6rQ61ID2MmxeFboqEa1VKa/sLi
	ojwx8fvY7qUKD5Y/jkjStmJZ8COgaZ/vxnGAGxHP9WDbIMY/2SIVJvFXk2YcNEdXlD0=
X-Gm-Gg: AYBFou0x9bpoivn+cSZpO6OKkP44zoP2kLbVa2i/ra2OtKW/BhvoHQ1P7OI8ntDQJHl
	MEAOatzvcbNbQuhKYGF8YZ8wZaw58+clQJllMP8pGkvDJgia9lTbRhHzVkBbpZUw7VgS3kq0J+1
	KLajIxXkS3xtGDZI9bZT6+c0E98dZl0Nzt6+qw9cdPOFMILtKBcgdPG8RO9olhKTRKzh6kAQovf
	IS1fuugq7/sv7dKXTPqKagoxaWccYbHl72dazbS0a3U8vdnFu14zoyQD909HAAlPhDy+xzDw+UO
	6WUmdnQ1v+RYMjKn66nxLUttrg/3Rv7W1+vq9tAlk5zkpjoISX1TvqqnYNsRlTJ0bLeO3b++lB8
	ROdM6As+BLQo3LMTcT3BLRKLXHCoxRTmyjxIIOxyoRMFjpCMiEDIcweh/Lr7l92q9ioq8cCBM2i
	kFiuqYJ3M/iwRqaFQPB4N7C2X0frQCKjfVwGlnQpHusEJ4fMPmLJyVQRBEh+U2lwUtGPWdyO/Vk
	p2aRRmvtL6g/av3ZPsPYsG4dHAYzUlsQ6X9L6dZH4wrzl2UAl/eJ28OQ5iocCG72iBx6zov5ggC
	1sCjcXup53mpQiOb
X-Received: by 2002:a05:6000:455c:b0:48d:ffa3:714 with SMTP id ffacd0b85a97d-49276b63816mr2962779f8f.19.1793971090427;
        Fri, 06 Nov 2026 05:18:10 -0800 (PST)
Received: from localhost ([2a09:bac6:37a8:26d2::3de:5b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-492d809ddbbsm3781141f8f.53.2026.11.06.05.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 05:18:10 -0800 (PST)
Date: Fri, 6 Nov 2026 13:18:09 +0000
From: Matt Fleming <mfleming@cloudflare.com>
To: Marco Elver <elver@google.com>
Cc: Caleb Kan <calebkan1106@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Caleb Kan <ckan@cloudflare.com>, kernel-team@cloudflare.com
Subject: Re: [PATCH RFC v2 00/11] stackdepot: reduce memory use for
 persistent stack records with a trie
Message-ID: <au24u-HWyVtBZME3@matt-Precision-5490>
References: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
 <ateDvB145CN_R7CA@elver.google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ateDvB145CN_R7CA@elver.google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 09CEE40009
X-Stat-Signature: 6czct3s38a7uajmrsmbbnh6zpia9w19o
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793971091-830905
X-HE-Meta: U2FsdGVkX1//uICbYGz7ZZOhe9eQoJdQKgj/FpyI+OWb8FheuHr5PaSFbJnsrwXwZnq2FBp7FtV5D86s8Epw+SYp51jX/Kw54QdoIZYWsy/STYEoHvwP3ileDGIkiT3ZvZ0VS2lvMtgrVRBRurFF4XagjbG1HZNqMaWC/x8HU9bFYQw89XjTgloCDXIWGuqTp7n70kJv+r0e01/YYgbDXvJViOnzthldtecPuBM3hmNh6PuE5TfTs0iun+GMXj5pmpa3oDKYor2kVffiJcjUKIEHnTgXSw8Mx1BVSwj8yWFosWbBxZ8c97XOFShytuWo48KTunCppPPvgZnYVK+sqjyjBVZyXWqRCZCUcvmpBfcslbM0jw49pn1fhc9KrL1UYanMeFYUcDpxmK2QY21FJcCkeXrtTy/ZE/l/WXrVhSkE2mia+01eWzut0FH8S73bXtbyYgXSM2mnIYzWCmSARz5Haf+PfA5swTN0XqrMe8c+9m2gXwPBjiafM6iEJhLWd4sBRat9VJi9UmQbdOK9Zs6MLxLPylvVAWqPGMSmy0AMPPWSojV0fT41fVmCHdXYcWTzQf4PD2HMWYX1Z+h//nezh4RhczD3PNrOXi1Fe4FyyThuhFTW7lZiAfRgGHPutROC23DLH23qAHZUczVe9TYIIVCsNne5WFigB8hPC0aq2Q0AyVdMHW+rzc9Q9yRH8W2wGeiQu9MVYcTIqm0HY+8/uuPl4HWBZ3hDy/0jIfuLuKw4/e/OH3gzS0Ea6TJh+70dN08ghh66e+zMayc98hao8RWPcSXzSPHXbpNxRgP5gDTDtJZubI8hJucRA7Yf6cRp4EbaDoiciO4vjK2uH3DeIhF0210/LoIouWx0+YHqAjdang9yYfqb5qs0vY64LB+PDWzQSS2OqjJ6IiMbTX6PqEVnIAzRNdfnhv8KkvKccklLRZyASOGw6RjJNiG01+pcvfgnXJf1gatm1kj
 l+9hSOEN
 1xthbQIN1h/lyhRe1Msc+K3GAB70kACEn8eRNH4FqdY5Anb6miXrl6moy874jNZ1jV6m9KPmxXDHAQwrTXPAlvn+ghmjcbWVj4fmF8pFzBw1pbw9m/Wzfq9NrmZtli2eyYceVOu3i5vm6mYOLgF0N5QPtL6S6U3yYVA3zGnXDQcc3RqAD3rOQIZWa+/2GcfiwHrxZL4PIaLPEZ1pnHSHjG1trCLqfynip/kVDUFfxdAnvNFt4gBz1FT33l/clvOyX+h1RKbBL7odtgXcpeIHRYvCsIXK1UpWOg9EFIqUkkvXknrmbycW9AaAk3dRo6C7dI3DuktPkJ1L6gki2yUB/OVSPNaqRjqLX5NvIyjCeL6VkcJVJy7mXeyFubGjcm1cpGfIhwrvC8DrpsegU34t2oHM4l5Q/RrVtytUWLdIeXO8bevcm4si4jfilCcuNZPDxwQ7snK+lx5f+YyOANgV7mh7lHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

(Sorry for the delay)

On Tue, Oct 20, 2026 at 03:07:40PM +0000, 'Marco Elver' via kernel-team wrote:
> On Tue, Sep 08, 2026 at 02:13PM +0100, Caleb Kan wrote:
> > Hi,
> > 
> > This series reduces the memory used by persistent stack depot records by
> > sharing common frame prefixes in a path-compressed trie.
> > 
> > Cloudflare runs KASAN on pre-production servers so allocation and free
> > stack traces are available when diagnosing memory-safety bugs. On some of
> > these servers, stack depot exhausted its pool budget even after we raised
> > stack_depot_max_pools from 8,192 to 32,768. Once the depot is full, a new
> > persistent trace returns no handle and a later KASAN report can lose the
> > history needed to explain the bug.
> > 
> > With 4 KiB pages, 32,768 order-2 pools allow 512 MiB of stack storage.
> > Doubling the limit again would allow 1 GiB, but it would not change the
> > linear growth: the hash backend shares identical complete traces, while
> > two traces that differ by one frame are still stored independently.
> > 
> > The trie is opt-in and disabled by default.
> 
> Have you measured how much of the memory reduction comes simply from
> storing 32-bit compressed frames (patch 9) directly inside the existing
> hash-backed struct stack_record? That alone cuts frame storage by
> ~40-45% across *all* callers (including page_owner and KASAN aux stacks)
> with O(1) lookups and none of the trie/bitmap/RCU complexity.

Yeah 40-45% is the right ballpark. In our measurements, using 32-bit
frames gets us around 41.8% reduction in stack depot pool usage.

> If prefix sharing is still needed on top of that, deduplicating
> fixed-size (e.g. 4- or 8-frame) immutable segments from caller to
> callee in the existing hash table (chained via parent_handle) would
> avoid mutable child arrays, RCU retirement, and the bitmap allocator
> entirely.

That's an interesting idea. I'll take a look at that so we can compare
numbers.

In the meantime, should I send a series that just does the 32-bit
compressed frames?

Thanks,
Matt

