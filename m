Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 479F4C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 14:31:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978266B009D; Wed,  6 Aug 2025 10:31:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94FA06B009F; Wed,  6 Aug 2025 10:31:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 865C26B00A1; Wed,  6 Aug 2025 10:31:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 766706B009D
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:31:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E61F781A18
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:31:08 +0000 (UTC)
X-FDA: 83746569816.12.B693C36
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id D0B011A0018
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:31:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="V4E/7+TR";
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754490666;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VrgGiOBYMFYIIMzsimnDnHrC9UaIdenX2JqDgAaCvnc=;
	b=scRrzY+OHmOCr+sgDgB4QsgiZv9MYQYtmxYODrvxgMXXPuJwV6m0Kg8Z0lHMYXWR+e/tq9
	J6sQ/w7UeXiTdkxAfYiACEWLvphgLxCbH79ZDV981AnWHDDY9XbKTZN7kCrRAF3FZ9jJ8h
	U18cxdyi2m/Inbp+U9736400DYxb7tc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754490666; a=rsa-sha256;
	cv=none;
	b=H8JRWa98OMZOtOcXau8+sAtyniHaEroClN7MyS2rBSRHXB5Jus1P4vqGUhVrzMl7hQqsBg
	nry1n2nOiuWxbhAdJlNhJhwREAw3ECpk4YvTy9eCcFq2LXnc50jqPOKwH306DlLlTo3fHI
	nfZtPymryLV7luxP9F+J36rbuMSbJyo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="V4E/7+TR";
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-60bfcada295so9168647a12.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 07:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754490665; x=1755095465; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VrgGiOBYMFYIIMzsimnDnHrC9UaIdenX2JqDgAaCvnc=;
        b=V4E/7+TRE69ZEnGMBnz/7VGlSRQmF5jSe6xTuYeBZXCh5mtvyqVHoiUjGOCQryZxPI
         F8zmU6XLspmDY0jUrsh0dP2o9ryiYol4kenAy/sD8ySVIMRNddOi+RzHgxZX80vFm7mg
         o3QUe6ZlowNCr4xM7dcNUisDzn67JgRFm1+aT4EbsHQPyOzxLqeZ4al/qDtfjT8xBQuN
         G+2gCENC+lE3Ft2psblJwDhiDXt/HMELDmhTeeku8N5cB3wmUOjr6NDRT9Evb8sc7iN6
         tNvBCgmHEgR8AuuZmE4a6V9XbcWpnMzeyUK4LniD/+OWE+FvPJ1mTDFON93XpcV2LGL9
         1yQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754490665; x=1755095465;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VrgGiOBYMFYIIMzsimnDnHrC9UaIdenX2JqDgAaCvnc=;
        b=i2QZ/XTUupPaiy25tNutiWEzl/RRnPR6WtLpyV98gm0R5pH1IwMKVncn3Vb05/u8Vp
         JWxS3AEH5LlCL+fBB6Ontdv5oHX4PsPLaBU8zB3dy77YQ5Er2/G7CxBWfvycJpeYcq6g
         2/toKaue3nUQUbsrnvcstiqY6bBFTlT6K9KE1dUVLO/RWsTEydGj1jZADltX8FF/y9SZ
         GVXG1NPsT64yqdQ9gYDqnU2R2m76r0OxJmCm9o6l9xQQ2Bim7r0Rz9UqAYA3euG6a9kK
         6YUJGHKNr2+yNFVHrelXHtc5pCbWgHpr5eUxK0k/1lCPnD7/uUirpJoCBdgE+gf7zMi1
         xqyA==
X-Forwarded-Encrypted: i=1; AJvYcCVALjkiVfrAsdgSb+o4z1WlNFW1O/j2JBMvRsoz5l6e51OHvip0OkfcQat3k2sQwt375vb8pi8tog==@kvack.org
X-Gm-Message-State: AOJu0YxfOmlquV2CAL8C0d/HB91z+1eioDpRca4WU0/9Vm9+bbGxbxLX
	q4/Nqq11zSxBwkWMJriglSo2vSWx/zTfzJE0+TuTaxyUzyaizTZkrWNO
X-Gm-Gg: ASbGncsr1Udcwbqo9+A7lRxlRui1CGBsvnmKkvY4mRlrS0vyfk7vfQiiu7KuCX43DSY
	GUTxDvFytzNiqXs06Q5xYQSpv4oFn2sfcOLJdpoREIx+YWsK9v0AWUz62ua0IXcmt5rT93utTZn
	g3KbmoYCUl0Gst1bIvhhRrtR4GXvtZVHNHIGOf8XcPCYhyEqa+j8Cc0Q7bTiO8E8j6/55D31IK9
	Q1dztm0AwgQ9QovpfsTynyn6Zd4JL6fCFbrzMGT+vzUgJxqSXFOur2FMbDbFML7l6CPGbA7x4nm
	n3v9CyJVCdUiLX/9BYYjyQv9AtrtJLNWUzIud1DNtqEUV74H6Zb1v4pldTwqsREZ+n9Fe6X0Ssp
	km6nQXEnCSdiruTxJnRO8m0NHWkbQ6Owz
X-Google-Smtp-Source: AGHT+IHgT5O0Iq3yZz68l1DnW8bbga5gPsAheej3jhuIVZ6EgFLEZ3o2jOGtaQ0DYWIboOiRFGYRmQ==
X-Received: by 2002:a05:6402:4304:b0:608:f493:871c with SMTP id 4fb4d7f45d1cf-61797d6ad0amr2329670a12.14.1754490664668;
        Wed, 06 Aug 2025 07:31:04 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6175ee53a1esm4730587a12.10.2025.08.06.07.31.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 06 Aug 2025 07:31:04 -0700 (PDT)
Date: Wed, 6 Aug 2025 14:31:03 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v2] mm: fix accounting of memmap pages for early sections
Message-ID: <20250806143103.xkdz4sinbhcq4vyd@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250804151328.2326642-1-sumanthk@linux.ibm.com>
 <20250806090320.wdt4zsfiambtgkvy@master>
 <aJNOs0IB1d33GSSW@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJNOs0IB1d33GSSW@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: D0B011A0018
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: e1rumg68119x8upu1jgtfhi3cjknhtaw
X-HE-Tag: 1754490666-691739
X-HE-Meta: U2FsdGVkX1+gZr2WFTFx6H0yES0xAaUPG5xfdXz4+ax8vAQgnuF/smg1rl1BQHxLtVewXYS42tb5Ew4ToKGIMb1ucwpsRrdLZ0ystV0nIatIHk5+htu6zbvi+FlME2Tmc0xHgJgvwfnJf3vl013/UslJoAzXE44NXvYiqA9G7r8hocgeA+KQ/qmnXXCP78gatHNz8GVTrlrwmyxF7IKfvN8OdetJMSvPIw+s0ZMHJIaC2hLnYkqvHCBZCWtojtoMLCqp/SyyH3+TDSnTmU0wFJwwrlzikgTmMmKOW7cVmO9UGK+DcrnpmOFdrBjx4Ai1ExtenvUbDmqprIwZgYVUAw3EMaU8/AG+F49njLQaBTAjGS3HcuPKMd4m38WI2xJpEKqptxMxXro4kSQVazXLIEbJ6eN9xY8t0rV/A6iaRPDvqwufv09N7ImzMymm1ZNUNm93mpV3gsqSXGcf367757qCbohWXznm4Qgc4LdmWgUV9xTe39h076i33C+UOf9XyoElK/ynmyhXTbGTt9e/22DftjmXws94vK9/sazJc4NVbyR1sCMbSUINn3KLdGzgdP1fVruKgPeR5gh7NBXamfxclgTm4QY/qWZC/NaLcfy3tWp4caq8BXFiMzHydzk/CEiHTD/Sr7cYGmuBOQSGzOl+eNA+EVVia7SgTXZ5e7t/6hRqVmibVwyMaQ/aI1s4Q1HK/QAqoPDGe8TG0L8NR78fTy5khfEE2NNn1tq9jT2EQepZGlCvEWLtDqUoKoKyVAtd6sqigs+Wrt1Obrs0PJ8QhXnCl1prCWnxPXhvTuIPcHOSKSl43GciR67pPwb7/Io0/mxiLmwTwEasf0V+BZXh16T7FSWHwlAeNGIllPuZ9rvZWDUf/HAp9lYgc9fK6ha6+sVSZuY7lTL2gPUoRy22skoawD03kLmJzyo2USLdRH7/Weg8CeDSNh2aCLVqEtVug36BdgDaZbMXD1r
 EZYHUvjk
 4El3pg7vtF8+L7RdjCvucJKrf5tAqnZqGpzjLXdkcNifWHkbUAQsuRC4YhjuVeyTIaTIw3ehg75or5i4FgznDF1vzeq1eO+B2kxpVHHGp70cubzwMNUaKV8S1OecchuRrCZa8ZFptV/7ryv7aG3zEiIM4yU5T0XCqKgiFZ37TZwFJvaIdwUWz9uChcTeGWQrPBnAXtlo891FuyWuJs0QaEVKP3h6H4MqHn4LEXzRiZi5JKBqbnUP98wXFDsA2OZ9gaDg3Y2DVhwgfhxZ8V1wWvxiNq7F1Uj3S5EA/kJa8kEot9whG0iswe5lF9cGehiw1kdFSEuaEah66K/0YwTxqY2IiFjFHgKOxvRPdGPaqLJRaB2tiD3uB6zdPKqiQegxhaom7TLVLgMwprWb6jrkkiIm0qAa5+CieA9hQGbOZtFkK7qLWS1NG7XyMhfop87EONK/ylpCJQOcbQtr2lR3yypmenlWREg7Wl3pwggXk68oP+aZV1JWuonzsBSCE6q6mKNaXSTqfQSF0qk5pLcj55mKb4Vm+F3+cIc8ZMVZol4CF5r+c3Hb7NU7ZGNEDtmoD+KwDP45hSlxU79X8vKcGDEN8/7LI4iL6aS2DgkR/GyaqH1TEC/2hRP4NugNsYKK+NgMuU2KG/xid9N89ecDozX0YjGIv/dBk1YdwCoEVhGF+nOtRLDlXoxeYtYUudEg6LfxKQdmLea/lE/Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06, 2025 at 02:46:43PM +0200, Sumanth Korikkar wrote:
>> The change here is reasonable. While maybe we still miss the counting at some
>> other points.
>> 
>> For example:
>> 
>> a. 
>> 
>>   sparse_init_nid()
>>     __populate_section_memmap()
>> 
>> If !CONFIG_SPARSEMEM_VMEMMAP, and sparse_buffer_alloc() return NULL, it
>> allocate extra memory from bootmem, which looks not counted.
>
>Currently, the accounting is done upfront in sparse_buffer_init(), where
>memmap_boot_pages_add() is called for !CONFIG_SPARSEMEM_VMEMMAP.
>
>The function sparse_buffer_alloc() can return NULL in two scenarios:
>
>* During sparse_buffer_init(), if memmap_alloc() fails, sparsemap_buf will be NULL.
>* Inside sparse_buffer_alloc(), if ptr + size exceeds sparsemap_buf_end,
>  then ptr is set to NULL.
>
>Considering this, perhaps memmap_boot_pages_add() could be moved into
>__populate_section_memmap(), with the accounting done only if the
>operation is successful. What do you think?
>

Looks reasonable to me.

>>   section_activate()
>>     populate_section_memmap()
>> 
>> If !CONFIG_SPARSEMEM_VMEMMAP, it just call kvmalloc_node(), which looks not
>> counted.
>
>Sounds right. This means nr_memmap_pages adjustment is needed for
>!CONFIG_SPARSEMEM_VMEMMAP here. I will recheck this.
>
>Thank you

-- 
Wei Yang
Help you, Help me

