Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2E42CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:41:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3528F8E0016; Mon,  1 Sep 2025 05:41:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329EE8E0013; Mon,  1 Sep 2025 05:41:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 218478E0016; Mon,  1 Sep 2025 05:41:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10A7C8E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:41:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9BFFA1DEAC0
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:41:57 +0000 (UTC)
X-FDA: 83840189874.02.D88EAD1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4D0B31C0004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:41:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cCDc+u3p;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756719715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KOhC6M2vlCj5G3ZVZXROi8iNp3B5G7J3157fBvcjijs=;
	b=eQc+JaLLojSOdQlt0bGS3rI6xG+n5TpnECGHvy4TTyKwinAX3ayMII2WdijRfw0NiJFJUc
	g7v6pCSU0PMr0jv2Eo65je5ss7jeDvmc0EYPyVeqpdmltaGBjRc3qzR/CKvANckpu6Ayi6
	sGBdmYAR3kB3Zts5Txv5MST8riDRK8E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cCDc+u3p;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756719715; a=rsa-sha256;
	cv=none;
	b=W5q1Gvj/LX230V5LG56+93N+6ZfajsmQCIUqJK/c6PGBeNUmhvYgxGYpNUSXwNPXJx6em2
	HTXTZPxHQWuncfi+cxqhjeuQW01Hlkm46xrYAp0OJmaVRS+dXDYD5iIRzotbVCsL09fRu/
	g8B/Ni3yHPwBgLmL18EW5jQ/4dekN2U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756719714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KOhC6M2vlCj5G3ZVZXROi8iNp3B5G7J3157fBvcjijs=;
	b=cCDc+u3pKzhqCTZJkaE1yy7D7mA9t4oGyIFCyZLzjC0zaG+/XowqcmfhhgcuYPrvmgAPJ+
	00iU5ZrzvbOrW0wXs4sZ7O9hyF3p8rQ1jTkxdwtLFnqPCuudjtbvptOC32TObo9PfsNk4l
	IG4OhbIrB/o2LLSETto1lrryOuQwHDc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-hPbcCjmIO5qqV_d_QpIuzw-1; Mon, 01 Sep 2025 05:41:53 -0400
X-MC-Unique: hPbcCjmIO5qqV_d_QpIuzw-1
X-Mimecast-MFC-AGG-ID: hPbcCjmIO5qqV_d_QpIuzw_1756719712
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b8f4c2f7fso3244015e9.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 02:41:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756719712; x=1757324512;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KOhC6M2vlCj5G3ZVZXROi8iNp3B5G7J3157fBvcjijs=;
        b=eilFFomYQlWLpvEWFPsSRAAzdfc1u5eIVwLpIso1kaFNoenmoitUboFVJlMSu+uWzI
         I/0sMWukDGUTM5LecF+H8y7+upUSICobieuRYj4cwFSXa5rJ3cYx0CJFdhTkdj1z2dEj
         Za5koety65te0vJ8OwlSvd/i+TUGxUsH8tgWU9gO13HmrdTD3hNiGN8x8LE8X7JAtWMe
         XsFWRLSnp7UDEfOiFszpK/R+kXdDUjsLMrqHCUR/xAYO91EGdiR4ydltSXu4TMd8Mhlu
         a5J/UAfos7wRKXaw30oOavCbngYFzcAp/pU2gUkyXowjMgqKU3a6vz6voG9ZEJ1LkYsC
         REOw==
X-Forwarded-Encrypted: i=1; AJvYcCW3M3rupd/+3B4utC020qpjAsqtcAwS59oOGcArNR+dC9KdmoNTzEmgJxC4FSBFr8lNNyxitiu6mQ==@kvack.org
X-Gm-Message-State: AOJu0Yxp/zgDpyO6CAgk3/55c1uuFXDIbIC3R8xM1LSlC0rIbiSGnbJt
	xdPNhOsaFMo+KtgXlksx0IFxqpl8x7Ie6majm5dD1fnHwHI4u/ALBXG6VjKTm7V7/iFAL5O6lf1
	hYiQt4V0fqT8Z0Bve5Do2bJ8SdfWWwDUg6gr2EeT+desJ23hcI6SX
X-Gm-Gg: ASbGncuKn1LiNvA2eBabXJLWirrqhC4Kh7z2YLvWAhHuylIxPUuel864oVjGTiWdkL2
	7hE1ElaTJloALZuRa2PM+4gEZ/r6TdPgI4cHdnM+HQ/bW7zTVbmk5DRL/LN9gHKoq9PoVavMuP1
	zpMea4DzX9D4tJ7En9/K8DTevZQP5ZbWNmZHLFgIkAsKcNAVQFoOo+4SU3m2RGHk+XhlgYoBFbT
	D9EB6hdebgU0y7AABHoc/P2vsEaozQvfX0MdsrpQchuma+Ca3rlKYy6jEbFmNQhVRT5DYilh9dc
	CvRisIqcEKSfVYg8eUgmQHJqqz5QA9Yk262SKn8vTQ1GZNx1vyGAaMCskCL9TACig4yYn8/EKLe
	5bifWpofcyWgQdkcFFkDLpNuidZGsz2Gv4XkCIrq8xNYXqOHaF57R0NOjv66ZC6MT3Bk=
X-Received: by 2002:a05:600c:1c9e:b0:45b:8f5e:529a with SMTP id 5b1f17b1804b1-45b8f5e554emr9278055e9.14.1756719712293;
        Mon, 01 Sep 2025 02:41:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH21mM9qsZdllKa5sainOeX2I0Ok+9eY89z/vExhO2b6YLIH4K4CgEd3n946nyWOQulz6xJKw==
X-Received: by 2002:a05:600c:1c9e:b0:45b:8f5e:529a with SMTP id 5b1f17b1804b1-45b8f5e554emr9277855e9.14.1756719711889;
        Mon, 01 Sep 2025 02:41:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b838ddbe5sm123272345e9.16.2025.09.01.02.41.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 02:41:51 -0700 (PDT)
Message-ID: <661e6140-572b-4480-9ca2-6a127730f32b@redhat.com>
Date: Mon, 1 Sep 2025 11:41:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/12] mm/shmem: add `const` to lots of pointer
 parameters
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
 <20250831093918.2815332-2-max.kellermann@ionos.com>
 <day257vhz3o7hepucfz5itjvdtp2k36hkqdg7hckqleb4jxyku@rs4rs3zhl4hn>
 <CAKPOu+-ZjNr9hEir8H=C5C9ZwbS7ynY4PrJuvnxa-V425A+U3Q@mail.gmail.com>
 <e3ec5583-adf0-44c3-99c9-5a388c43fb7d@redhat.com>
 <CAKPOu+9CiT-5P--6TZcyq=jHLDhCa8LDh1AYjKr69+0shO8UrQ@mail.gmail.com>
 <244b73d5-39dc-4bcc-a69c-8ae3010b40d9@redhat.com>
 <CAKPOu+_wQ9DDHOQDtFeXU7ZqwvwxYqXNqWeSP3zJpfC0Cm2YAA@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAKPOu+_wQ9DDHOQDtFeXU7ZqwvwxYqXNqWeSP3zJpfC0Cm2YAA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: i4KegTEG-esOeXeJywjyo_ACd_GcSfTIhImBC6gBDfY_1756719712
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4D0B31C0004
X-Rspam-User: 
X-Stat-Signature: cf5udsyrw1k4xeejrn95mz31n3k6rw17
X-Rspamd-Server: rspam09
X-HE-Tag: 1756719715-873513
X-HE-Meta: U2FsdGVkX18zMZo2VckwVUv+ml5D1e5+NhQxK899T99lDqKf/18itxX488Nc8NI8laqjwZrQm3D8E6HzdCpZ4j68RD0gx5QPnSgOG7O49LH3WkYW5+ZR2V7P+rs4bj6UVCWwEmnYskZtkJFv7f3GW/m0G5AY8ysJ7R9guFJkJHk92+PKu7MlLaCYyJ8oJh/CXdMCV+C79aXIwg+fMHLFrHNaD9Fmz/wxhE17RQCGfk4jJYPd3Rz1+hOZrsI4685CS42uFsh+WbXPnGzSJicoQZlB2X4VtDdBpTrYtTD3d2wPakpDhFUVDISgp7ZA+hUAykL+Ssn1sJ5WCRPclDrVSYAJQogJ6kbQt3/sMCNmKb/HNcaPgt5QmE6GV+qVDE4AeEMVBeEzfs8HJj81c3F0NPj0aXHsRF3qUpPF9w8ZLN38kYhxLTZx3RdArW+qRjjikZnnZGRRy9vg8eKSOUCfEpc9vvzoNAhGn/XssAAq7gOWKxX3bJNytj4l4ddJEioPY5v/bAmEkEY+QtHFJuVgfaZqxWMFHtn8J0yZLhs2LB1PBSfAlHXeUVIb7M77gyWA1OcsDa3kMt4ygF27y0J/8C2P3pnKSlmE+R+j21q16KsBiyK44ul06PUtwU+gYBDOo6Ezrh9RsjXn1c/8nSYlRtdmv9PfQQUx6tIhJirPLJUIo0+6X9TVPiDytdSnjH8nJiqRQHOzmt2jr6ZruB659XZ3csCvwY5Zj5QI8ih6+M+hJf+WdcvGLF9cQLRVfZaCxlHi5nve34C0TeixjvqCFoKZHYkxTGCDrRw8Uuq6kvTJGa7nqKmCloOyQK+5lMptebarXIMQtxm66qTX/pPDunirjiPBbGQiu+jlDqOMWHkudxtcB/F7aY7zGd89OTqVNCUtjFPjExmsOVksdNOmk2nPc13LYvv6PVfD4L2V7de5l/Bisdu6GtZcmUdKcieDlyhqo2LmGWN/VvMVP6P
 LY7pmwwg
 emWlqtV11mlrqtcViEs5QDdxKQA4oEJNE8yiYwaGSj4A8qZGt81jg+pZ9H1vHkC2C45E9hzutkR4bxBqKeTORRw++DX0k0Gz2pIVIZZESMK3dpJ9vQE5TpiGqMcsbS0Ji3b4uD3Z/mjQr8mpvvBZ+JDIzBtNfysEWdoejVMNaI9uX2XAQuSSITSTFJxKah0X5E7/2V9Dn7iaKMQlLiCS4VoDMbY1pbc7rKn8JeV58DyZ8S/WGGjlSq/qa3ja6Ke60gnGn7/ai8lFqfB7qoIoCjcf3sQLSwx8qosKQWAmvpeVS+f5jHfUWa1HFaxVdhwuvuZGYSt1n5zXzScHZ8oZrwC9RseVMbTLpbDrCwyPP/TZu891uBHVJSAx3VBkeMA1vBhXCFg32BCFAm03Y4h+wGL91eYocKOaNsjcpJo61csDrmNq25hfccGZqk87KjTd8gjtwmGcBBzws3k5vz6WA/PYz1yQjWAwcCVPEIJAZ3+aGLQqNpuaIbNqubHnVbEBdkaN4WE8Br9zYrNHbwvIMXVLcwK5XPH0/2WYzf1IrHeanUFIy9SVwl9tFBaGbWNjanXjT8jRxt/NwM5yccHIUiQDWME8O8NQbyNpN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 11:26, Max Kellermann wrote:
> On Mon, Sep 1, 2025 at 10:35 AM David Hildenbrand <david@redhat.com> wrote:
>> We usually write complete sentences, and there is nothing wrong with
>> repeating what the subject says.
>>
>> All the time it takes you to argue here would be better used improving
>> your patch descriptions.
> 
> Sure, but first I need to know what is really needed. Reviews on LKML
> are often contradictory, and it's easy to get pushed around from one
> corner to the next.

Yeah, and that sucks and I'm sorry if that happened to you in the past.

If you ever get pushback on (a) splitting patches into reasonable 
logical chunks or (b) writing a short yet concise patch description that 
explains what the patch does and why, feel free to CC me.

> 
> I just posted v4 with longer commit messages. I think that's a lot of
> unnecessary noise that takes a lot of time to read, but oh well, if
> that's what you guys really want...
> 
> (In the days of LLMs, writing is almost free, but reading all that
> redundant or generated garbage text becomes impossible. I think it is
> harmful to have so much redundant text because time spent reading it
> is time wasted. But that's just my opinion.)

There is an important distinction between garbage and a reasonable patch 
description.

-- 
Cheers

David / dhildenb


