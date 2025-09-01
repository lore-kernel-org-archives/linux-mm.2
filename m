Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C32D0CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:38:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E9D88E001E; Mon,  1 Sep 2025 04:38:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C1868E0018; Mon,  1 Sep 2025 04:38:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 189AC8E001E; Mon,  1 Sep 2025 04:38:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F2F7B8E0018
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:38:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B531EC0724
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:38:06 +0000 (UTC)
X-FDA: 83840028972.30.73FBC5D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7C5001C000D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:38:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aN4aTH24;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756715884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jrgwOs+scouNVZvyi3e77NdTzgLAbayEdAxxiP49p7Q=;
	b=VhKMwLKCgEchP6jhhqPM8w0aMeSSUnW6gKsmq671QJTESeRLR6wq0w4lbRzak5IGvkVFOq
	illb7ZTfHBi7lxyco1GhogCmLlL+XK6Mvked+PuKG8ocE6KITT6Nfj4xI8W+YsS4if8/Oz
	/93cTax8++6z0ngFxi7ooYMU3OnS3rQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aN4aTH24;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756715884; a=rsa-sha256;
	cv=none;
	b=H7fOqeHoqa/u9rh/CmkKhHxonF6uZJ1RjJXNSAvj8sAt+X3GH+qtU/rvYdP7eeMDneKXkc
	eSe81q/cC0P2q0CZIXFjgTv4E4mqSk3UCDnpVh+/Bt1dkDa1R5hTBaEd6EBDgix+AhlV/x
	usaJo+OmCZ/SCd5ktw5VzyWvgTRYxOs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756715883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jrgwOs+scouNVZvyi3e77NdTzgLAbayEdAxxiP49p7Q=;
	b=aN4aTH24thb1eskhztBYTsPIa17N30aQ+XpoLHlyNrv8WIVamdHzCqzrbUchFuQtlc/Cld
	aw7X6H8bY8aXwrLKFqmQYyBVbuj9v1mhQYrCrlJVY7EzdtZpCKEx55pBFDn9UDv6zs/DF1
	EujUK/JUsIzhY9Qtnto9OzKasbmLNYg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-GV6CSCwzN3CyU6iXgQUrnA-1; Mon, 01 Sep 2025 04:38:00 -0400
X-MC-Unique: GV6CSCwzN3CyU6iXgQUrnA-1
X-Mimecast-MFC-AGG-ID: GV6CSCwzN3CyU6iXgQUrnA_1756715879
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3d160b611fdso1202215f8f.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 01:38:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756715879; x=1757320679;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jrgwOs+scouNVZvyi3e77NdTzgLAbayEdAxxiP49p7Q=;
        b=Ig77V7KXW3Ird20ccbOLQy5UkT/RAYiZCTxza/Djok699spfGC5baEHM9LVpcCDQRE
         H7OCgVwzPjtZt9izi88z/qAMc01kWnzp0D3PkOKnLilAq3qky8LqvGgZnKfXVU54Us/9
         MDZr6slT65nxlKkGoHwRKbFDxI1YdgxuQHehAwNk1EcKEKE9E/AKImymu5C8H6jFmtOl
         lGtc7lscs0SaGQ+qAttKB7MJWuOVvFr/KcB76swdSLTP6aZlESWk/d7LTb3uT6SgjhnH
         xeShhIoSwnVl4ptrnZlff6YBQGCRYB/iZdRsjaJp36xpwlWnUDdzVEM/uCXmWL5lCwLN
         qFKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUA87NYCIufdz/3YKVVOFdIbHn1ZiwyAfWegAIXYutT9WAEBm2yTmt7KTaNv3c6xxXQe7oPKNPeTg==@kvack.org
X-Gm-Message-State: AOJu0YxcYVWEz93llM5Q/u6NzKcin9MQ8a2GUPiz5U5kNhRBZmmyGZRz
	Q0Fw/QB9xb/TBkIJJaoazK2zeTTQtKkj9YMtqX40B/5ApMHzgVBXIKHgijnojNTAuvLqkYHYsfb
	uiq7Z+YouGY11VhVupON8kJuSRgGphEh6tLxuui+kDqqr/2OWDwe8
X-Gm-Gg: ASbGnctkoYvj9wNg6ME/VuxiwBOTmHiEbUFgrnq1Nd4HKIhw6G0T/xvhKs0BQrIFxYz
	qPSf40NC1+BvsqgxvfDBBY/6y/bNqS2kPDJIVAmWSnvywKyAYZstX+5d+ZzqaxtVj7708+ociOR
	tjaa+8GIN5+OFR0ou9S3wsPJ4e7AkiqrMHcKsOIQ5pBR/yfAHVIkB16T+8GK2jY4spyqTBpWDfc
	k82TabEPJhlR/53X/Ccav55tvuG3MemrphsxTxe6iAHdoG76aVUZ8QNl4moyWxmfOVa+uyFPLc8
	/54I1BD/fenqqH5PQBHZsAyoUqfV636n8+LBBaBuapeMLpUtGNo/5t3HTVQfVEbZ9kAnG5b0yLb
	3J2C8mdY/OwIf7/SXyaxyw1Hu1dsaEikakf3pl+X+RFe30O9KOe58bO0CHzMq8LyBwxs=
X-Received: by 2002:a5d:5f53:0:b0:3d7:618b:293c with SMTP id ffacd0b85a97d-3d7618b324fmr1132382f8f.16.1756715879513;
        Mon, 01 Sep 2025 01:37:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9nWwOBCAvDBQoLLOnu8h3E49+M0YCTE2ZQwP6KwAdpKdeubmEVeAJTUT/HJf/S1n5/RmPbA==
X-Received: by 2002:a5d:5f53:0:b0:3d7:618b:293c with SMTP id ffacd0b85a97d-3d7618b324fmr1132361f8f.16.1756715879028;
        Mon, 01 Sep 2025 01:37:59 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf34494776sm14122840f8f.61.2025.09.01.01.37.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 01:37:58 -0700 (PDT)
Message-ID: <38aff9eb-9d7f-4dd7-8ed8-fe29e469d068@redhat.com>
Date: Mon, 1 Sep 2025 10:37:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] memblock: drop
 for_each_free_mem_pfn_range_in_zone_from()
To: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Bill Wendling <morbo@google.com>, Daniel Jordan
 <daniel.m.jordan@oracle.com>, Justin Stitt <justinstitt@google.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Miguel Ojeda <ojeda@kernel.org>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Wei Yang <richard.weiyang@gmail.com>, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev
References: <20250901083423.3061349-1-rppt@kernel.org>
 <20250901083423.3061349-5-rppt@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901083423.3061349-5-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Z-YNrBpqzesf6Gq5cm9PzrPaTaoGw2_aJ5rWccUQE9g_1756715879
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7C5001C000D
X-Stat-Signature: g7o1cr6dxemiumonmmyhuuw8dzfurfua
X-Rspam-User: 
X-HE-Tag: 1756715884-198032
X-HE-Meta: U2FsdGVkX1846wrBgmsobQbWHN9QsLFonsE9McULRTHxHe6bl2qiw5Hw8RunC2mnpIr4n46QXrYCDfzSXhTfbqVE6JVyAVtNF+naWYvcH7ymt8HtPwGJ24comB3JgRBEWdDESI6dpOf8g5T1bv07PXHUb20KCjHUXXkfcB2IY84KJasJ9NQuTw7xjs7DXz4Xd+Fn/3/7alARyth7hcdmNwaJdsD/CWk5Dvjh53d06GOMZUJFBYFwYdVOs7/TPZqWefNlPfgoU87RFTr8DKKT/aBEIqDpLX1YLJJI59m7wDRjAYOkd6Gcyy1sutwcxJinkSUYAW5FiCZ7Ft8kX9A7fRhT/6OWTzXOyh7uyGpnne44h9RhMSmuCSbZjThm/Xws5qLc8WdqFOmHkrHManDvJOI2SwzyQrrnkt5BI0xNtAaAnQVOhoWwU9CoVadSu/okjwP5MJQieQSepeHnxttwJuC6aCZVBBxodnyfALg0Bf4mYp6pVoUBkfwiB9IObyB3Wwwz+c0JiwtmzC1eGMu8FhsijMVU0eCtcIy8ycNtfJapN3+t1gzS6uWJXEOVudpYHBl682Ib8esOYJjDcGVW3nhvMvD5EvfAU6VI5KXhYGSOnqKXCrfVBtyrZR5A+Xq7RY5N6NosVckVC6CgzTWnLfRWiVMrgQ2E+WVUQPQOOufbgrmOzbYCFZdZHNttLDXOCLFkFn8M1BXKsArW1ANlydZSLcCLTbzxkiAqiB/IaZqogEzLjTWtjL0PJA+uxirxFd3kq+IvP064syq+QTT2hJFGCmiUgfvcvMWbiGdHMxeNPW4Vve8A/+Ve7vxpKViQIxTX4NuSCh54nmpJlhfkv1pl9okED2LF9cNDnF4Dz19z9gAnqnmBwI/3EJiwK6kicT4cRTqSjetIX1kOF7l1HGOhoO2Q8vQArDx0tvCQwXE/p9LBqnJGCNRJNeP13mCM+QLgL2P29GoMcpLmvue
 of1GOOUG
 lVx9+AJnUQf9QGjxu4cTs+0FS8o4fOsAirYRJGUW7Irt9HyX6f/BSbV7K/VsJGF4brjVgXHUkCgmuw2A1ufRKm5GFRRt2Z/5IiAsT9bTmlqJP+Vb1N0KF+r/QPTzIlynsybBwXDFKY9w67teZMNrtyk1KjvOdbzhIwriK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 10:34, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> for_each_free_mem_pfn_range_in_zone_from() and its "backend" implementation
> __next_mem_pfn_range_in_zone() were only used by deferred initialization of
> the memory map.
> 
> Remove them as they are not used anymore.
> 
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Link: https://lore.kernel.org/r/20250818064615.505641-5-rppt@kernel.org
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


