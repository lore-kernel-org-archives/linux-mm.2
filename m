Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C289C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D2176B00CA; Tue,  1 Sep 2026 04:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0827C6B00CB; Tue,  1 Sep 2026 04:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB4D96B00CC; Tue,  1 Sep 2026 04:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF4906B00CA
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:44:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 320F540343
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:44:26 +0000 (UTC)
X-FDA: 85164556932.30.4AE49C0
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id 50C1A20006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:44:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BENiIb2g;
	spf=pass (imf13.hostedemail.com: domain of eli.billauer@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=eli.billauer@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788252264;
	b=TzVPw8d7+g81RHsdy4GWNgZmz1XA6fNqDbMDOy4N/8acTzrl5S4z9oacikaRO0UPzEdnlj
	87VkLhlD1fv/zxws9o3UMSu5xs4oGdmh2mkQ/+iXVnl67ZcXXIe1QI2LJcaICzoIcZtslL
	+dJDqP7lnsmrru7m3k+3hG6VBTVhOZY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BENiIb2g;
	spf=pass (imf13.hostedemail.com: domain of eli.billauer@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=eli.billauer@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788252264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kfkumJrDF1tZTAVRjvzgDO3hMk1gGG9KZ2g7tgv7l7Y=;
	b=G7k3Ef12Up7/0X1LSxjo14cv4TPCSFvoDiyJDxG8ZZRm20WWElWPuQuUH73LT0TMSZwq9u
	JJUzk57/P35dQmUmqTj7halmjM/iRQlu4MqF64EKFzbrgx/xaLHLj39v3UeHi1hKx6Q0WT
	+7tuw/wcp4wD7Co+Vd6FpCuqGUdV2/M=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c207cb16cf5so738728366b.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 01:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788252263; x=1788857063; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kfkumJrDF1tZTAVRjvzgDO3hMk1gGG9KZ2g7tgv7l7Y=;
        b=BENiIb2gF9kB7w4r6xSDc6HShegX30rXcpZ4ExYzV+fToLScI6YWNd05AnbdEelqC0
         lhQy0cqEyXRb4uzPw52wLxbcJWqY/paHhk0MqvkqQs5Uf8lEPV1cMIwUFHr0ttV8l8Vz
         2OUR1qy2X9C/QfD5oc6fdDxJccZmycTRqPr9gCqozhdmWmHknN5fKWgBCUA0xa/7vJy3
         5al9/i1Xa3KESbMYtrM1ogaAbKOmxbhl7POGy87CRDB3Ia/P5wMqyaG0BGEvt1FKfGY+
         VQS4OJBG0QL1FiiQbjEshJ59pPc3GgmAugLlqTKsdezVwGR5D3Ud9Fx6R16TBQwp+lEV
         yqhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788252263; x=1788857063;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kfkumJrDF1tZTAVRjvzgDO3hMk1gGG9KZ2g7tgv7l7Y=;
        b=al99+/fNmT5MUE6Gu3kcfpm/VZCArYf/UuUXvzq7J0ZJUvL0a5VixHfD9g6U/i2Ypv
         +G/9KgEhsOlU+05F7fZVO4xDLKOaoxl8h6HKFXBFvPWX8f13R9WFV665nsISVwkr2GoC
         ib6q098ZwJW5RuA4k9Pv1zTCl0sk98BmYMC9oGPQPU9bRh4xf7zF0lCbRyShwWeoXgF5
         AboKDD+FoW2P4dVHXMtHvtJcPx8vPcGtUVHShDJKoQCacOTKo5WBaFQqx1QFJL7t2hLa
         fqEtvkTFw8HzGBARLNejxoyo/bwSwOJU8IKtwlBjWTFZ6RHI70ituAinZLfUtozjVlxM
         6ZbQ==
X-Forwarded-Encrypted: i=1; AHgh+Rog0an0lx9i5+jEp0tSD2hBT8japbE9M6w2tpjcUfGdQBw6szTpcdfCSl0CKI+6K3zTnrXztUpVwg==@kvack.org
X-Gm-Message-State: AFuF++ky9PHjBQxURSIBSBB/7F36mGfDbPNXFQJKrFQm0oMWKfogGAJE
	ZDGGry4F8GxfC4zmZA/5PbbJIIlDi9kWoY9fC/wYc/edyv665PVIeT88
X-Gm-Gg: AR+sD13bMieTaXc3FTuIUN4s4OPr/8IcOV/dubBllZEan51q1uK39nvZfiRARqecm3i
	aTL7Yq34WpL88GLOTVHsiQ4qnXaLfEEmxZ7Xywo68m2F9Q6E6Llb9LJFnoiNFxS62kicC23fRpc
	YZC9aSioAvB0238zdHUaJyykC3AWVvN/upVBhD9xLhY4+XV1cQpAq6mM0avsBAKqT7VgiQ2wahu
	JED7eKhTByzTxcSCvJvl7iD8C8r9of+vqKQPAbxEIKznAekic0RHPw9kyjq/b6lHfztBKFSnt3m
	u/QFQ1PrbjwKW/dCOMPVrzyXGmCNH9C8CjHKl0qE9+P/Ee52YpkYdJ4ywVbBRJKC33vY5u6WP2I
	Qo++NJ8Akg+DGi4nJBQHG4NghsjnrEGgxqGTXjFLEc7ieDf1PYwgVUmjveelm08Fv+FlrxgsC8Q
	rL1Ph70Vbcf8KRKUrcVz/kEI765mv0P0ToR2fH1636FhEmARg9a8uhz9ZJZ6Fl4xbHmhxpwVNZF
	i7F5TCeWO+zOgNQIeTVgtU=
X-Received: by 2002:a17:906:f582:b0:c24:c22c:6372 with SMTP id a640c23a62f3a-c25b3affecdmr382949666b.5.1788252262902;
        Tue, 01 Sep 2026 01:44:22 -0700 (PDT)
Received: from [192.168.1.89] (c-85-228-45-68.bbcust.telenor.se. [85.228.45.68])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c255eacf6bbsm527267366b.0.2026.09.01.01.44.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 01:44:22 -0700 (PDT)
Message-ID: <1729fb06-6beb-f8ef-3e71-47fc3f00345d@outbound.gmail.com>
Date: Tue, 1 Sep 2026 10:44:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 2/4] char: xillybus: replace __get_free_pages() with
 kmalloc()
Content-Language: en-US
To: Mike Rapoport <rppt@kernel.org>,
 David Laight <david.laight.linux@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Brad Warrum <bwarrum@linux.ibm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Michal Simek <michal.simek@amd.com>, Ritu Agarwal <rituagar@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org
References: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
 <20260830-char-misc-v1-2-05e2ce44f291@kernel.org>
 <f6001085-9234-4025-ff34-6cc4a66c293a@outbound.gmail.com>
 <20260831123937.32255a49@pumpkin> <apaF1HUtJnstuUN4@kernel.org>
From: Eli Billauer <eli.billauer@gmail.com>
In-Reply-To: <apaF1HUtJnstuUN4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 1y1z37sa7f89mswazt5okrpro85re78k
X-Rspamd-Queue-Id: 50C1A20006
X-Rspamd-Server: rspam06
X-HE-Tag: 1788252264-438822
X-HE-Meta: U2FsdGVkX19wBxpJ8Dv1PYSr7UbNvfq/kscK/cKyY8mo+PxWr3UWfEc6DEBRuiXI2025pMvc5tfN1OzQ3kSJ7NlaWiZ3hL6GN3V0T+1Yo10v4UdjSN+zTWI3lNwNAv9HQtBOT9Wq7Mgs5+nGbI8m1km5fz8zpHgvzFixUDGpxOssg+JuL3hbAFB/u3GEoxqV4O8NgyqoMTyvSARXt1QM95pDF4ttRv24Gpy/lojtlUXWeYcZk/s4yJ0CEHDhIcaiDzXkksqyHti7i2O+yPqOmjj0Qa/L7Ql4yZ6HHc1N+8CA8Bou0n6bU16aXNCYLCtC/t076g2IgOFA3pKSA1DS783v1CtLlPsxj2NT2PeaRhOw+1MX0wTOe1EO1B/IG6z6Vp0sL7VpK2tqZYpkIlgp9TRk1ArnhVVLWyDWRiK/UrvRhV12A9auvGrlzaPR3fwnNgkyIM/ukF6HuxN67iQRkWm+wh7Td3FrdBfW5doa+LRebz6uSm9RdUTSNV3SaduPBXnSfNpXOMWmaW6S0Tas8Uqio4iE2yKsoIOkGUptVGRRnbwkBsrh8/rSiEbT/sc50nr6m3G15B73fJ8VEVRYxUanRnNK7EmlGjzUnbAGuNOH7bgiy4cMcni87wwN/098Ezc2jQZbPDSZ2MJavOFCczBtXWdzJdw23/XG9LHwvYNGy3VbWDQAEFgr5OrmoEckGo5I42SIhCs0bU5eL+2hFWhFYUJEIh6CY8wy4Rz80VbDyT/+mJzKZLWB99jn24921hleE7SfLWbm/MlOCSHd+IvWflqvosxSMNbaxDknEGRac6xLzUfCS5ixQ6ljTK6I7IGUZvqnA9wFKMcJDm7ohGnG9cm+8DuZjxDixRiJ1qj406NGv/PMJegHviPFz8uOkIZrzS7ilvF2De5xrVvOa9Mj+7ARKEaSUmfUcd5uyEI3JwysNVivJuM4VyD9lt8XN9osgKExUDCTvw2CJVU
 TMz07/8P
 +phRtUFKC/Bk5taIYGaNJKBpDihM9FiLR00F778+4c6xDf3H0l3WmZd8OgxJTmK42Yx1lI6vj2oT07DCBY8eZfwpECENzeF+hTCNyYQm2roMrt8DDBWa0qq457J1OyAc4HhxWNxS6I5P+Rcb0qPwanARENK7O54U/oIwZs8NTu3sQzVcSVVgMQLXpdDWJ/OcnhWe9O6EsevtdBnHM2XV00h4kyUVy0O2eNjb9JTMtDTwLzt41ZnM8aG+ITAc0vNSubU8wVao1s6uMI2jfhBGizhZJV6eHGgsG5Nkdkz5E8jWLzIb2gQ5oZrZ1yOA0URaqmhSJt13AR2IACq32UByE2szkh2BSK6HIPM900DZY0zsy3mApPDC3/wlg9RU/3XTWqSEXcxMa1L8vSPKCdHBvX8Lryuh8zcUqbzUEEDf7jkilnY0Y+oFJqtCMV6MyHZS3PLTXD6DJDACJGj9kfoRJhcWFNULqaXCurR3W93GWJSOJ6yi5HJwt7NYFxx8A2vdgESbdLhluyOP3xmy5ufLsbCeVCpdlEtjs5k1pcdrPVeDmUDe07Nv7UnjltMLq5zimmTxDRSkXKvRJ8b4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/09/2026 9:59, Mike Rapoport wrote:
>> Would it really make sense to allocate the four buffers separately?
>> And/or use vmalloc().
> My understanding is that the buffers don't need to be physically
> contiguous and vmalloc()ing the entire fifo->mem in one go should work.

vmalloc() is an interesting point.

fifo_init(), fifo_write(), fifo_read() and fifo_mem_release() implement 
a FIFO in software that the XillyUSB driver uses internally.

The memory for this FIFO is allocated in fifo_init() by calling 
__get_free_pages() with requests for up to 64 kiB. With the maximal 
total buffer size of 256 MiB, we have a possibility of 4096 allocations 
into an array of buffers. And if __get_free_pages() fails, the size of 
each buffer is halved in the following attempt, which tries to allocate 
8192 buffers, each 32 kiB, in this example. And so on.

This mechanism with an array of buffers complicates the implementation 
of the other functions as well.

So why not replace this with a single call to vmalloc(), possibly asking 
for 256 MiB in one call? That would mean simplifying all four functions.

When I wrote this driver back in 2020, I avoided vmalloc() because Linus 
wrote "vmalloc() is NOT SOMETHING YOU SHOULD EVER USE!". (See [1]). He 
also noted that vmalloc() is a restricted resource. But that's from 
2003, so maybe things have changed since?

Questions that arise in this context:

* Does vmalloc() guarantee that non-pageable physical RAM is allocated 
when it returns?
* Can copy_to/from_user() be used with memory allocated with vmalloc().
* Is vmalloc() guaranteed to successfully allocate memory in the same 
situation that __get_free_pages() could have been used to obtain the 
same amount of memory (in smaller chunks, as with fifo_init() )? Maybe 
they allocate memory from separate memory pools?

And most important: In what way, if at all, is memory obtained with 
vmalloc() practically different from memory allocated by 
__get_free_pages(), if it's never used for DMA?

Does the API offer clear answers to these questions?

Thanks in advance,
    Eli

[1] https://lwn.net/Articles/57804/

