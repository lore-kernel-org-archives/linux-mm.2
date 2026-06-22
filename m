Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A36E1CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 23:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858FE6B008C; Mon, 22 Jun 2026 19:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2A36B0092; Mon, 22 Jun 2026 19:45:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AAE16B0093; Mon, 22 Jun 2026 19:45:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41EC26B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:45:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB8D91C12EE
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:45:23 +0000 (UTC)
X-FDA: 84909182526.02.B9AD2DF
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id B40DBC0004
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:45:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EAMfToy1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782171921;
	b=ithAKViWQZ17dsThJ5TU9BK045poaSWOQKLbD+Aa01l9T+1GSLJHubWNojyiAzK4a8tliU
	uNZc+J/CWBQoRWlnEvkzkDEweRd/FtRTY/5yU4vwF9+6OodDOApwI3WpPvJhHa8/ftk/sr
	d1pfgn9YN6upVFBkyFx1CyuSRrkpMws=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782171921;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rqciz2qlJ5KO2k38VZg83p2ecH48DGVORpzo6dgPKlM=;
	b=fziOQTpC/0fRA6ql8ZmAyzHe1YDSoPWGaBRSW1xo0FsTWlfkNAuUvsRG3NP04HQpLV6qD3
	UvpCti9K+Gcu1kCD5qT4amSFnweKoZm6VuxraGufh/1MVkWod1S7/NXTgk0FldDBqD0Cjt
	MrcqgTes077lMMqcAdKvidXIupB483Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EAMfToy1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c0868ca8738so578512666b.0
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 16:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782171920; x=1782776720; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rqciz2qlJ5KO2k38VZg83p2ecH48DGVORpzo6dgPKlM=;
        b=EAMfToy1n5RAna2lMMl+NME6a7XzfGX1I3EPiWupwQKklgE5VIBZ9HQF7f/xjrvL0I
         ISUAYxwJXei72m4GpEIv5ohqArzPnpkWTCPEhh6CdYlu4JgoxfvGpX+W7eF+fKWKx+hd
         8EsWnV+wu8afae/YDdpRo6vd5lF/KSWwEE1ri0MjihBcDp4Gu7BNiYBc0mop8wCX6teJ
         XlF2KU6HSi15XfhIaPRL0e2apkUzC7xF83XE/H0rvO8Q3cxl4C6JZzjRe48Nm0yTu57g
         0tLD+Q59rXVNothKjxE1ZMl5q1eWluHX6n/YS84VHRN65HgRqnPFeb81EmOP6RUlQQsX
         Ilgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782171920; x=1782776720;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rqciz2qlJ5KO2k38VZg83p2ecH48DGVORpzo6dgPKlM=;
        b=qVyt1ib1FkjOTDdxliUWmwmWFxbYEwM+d4ZiDFsdtkYESZsyzcF1XQYj4jooU13yjY
         FEM/koLwOXfKDP1Rxk98Ceic2N5FHw8gyVct2u3jk4JD6uYzpRCh1kKBc98859kLQ6fn
         FjFPkQCb4kovqeZKZo9uvVompUVIO/K3DITngAYtQ2jXZNohD3yGeNgqFapMpFx24FJo
         qSR7pyHVrYCLJRAEyfBjvk9QCOwkFPp2PtbyDMcpy/EavLls9UKNlAnOdI0LiNo9Dg9a
         h/I86P3t7SYy6uX/hGiRg2FaXuVGSwasbkemQg1KrGQ+/vcOYO4un69T/l3NdIE5tmXi
         YmeA==
X-Forwarded-Encrypted: i=1; AFNElJ/2Wh5dF3ee19ihlfgYS5TPyXTl39iS+LvPqnY3nztCSKcEDsLEmpwVVcg2I2tiVbOBgH88cEuotA==@kvack.org
X-Gm-Message-State: AOJu0YxWpXkoSc+rjddmy6MEnrNI4rGcWBjcwBgunBmk27WswExTGWW2
	M+LAq82uRzeLpseootPpt7TO7vWYPoqUM/ep9W8zMspDULwvCdXPwF66
X-Gm-Gg: AfdE7clk//2Vkz798UmmLPVjYv+8rN9Un6drRTihB4BogDe3+aiLd9TSAEHrQeQAQyb
	P1qtoWxFVo3loTRBZXqyNiWfreT7JzkOb8e5sI3HHFOI9KsvA3Wf7mQofQODlPBHqxj+550iSXe
	ei/Zi1gK8E01sOXzz2+5S4gesnL1HmDg91t8PjNqxjX9afs/+sqFBvo3IyktbMxXIeoDLrFTmsA
	W9Nupg2LefIthhqN6jp2FUUi2ssj2GJU3v4zXcW/0+WrHKxtqTdm3RnGsJrESO5eXfot+UoyQGp
	ixNplBb0uuODzxw109GIhWI11FtA5gFlnTK/Fx57KiOQfE2pPD/1ucVJ1XI4GkcWzktxTByZS81
	LDia+6tCBmhGbYDtU00EXcmMR5nfIZdpB3geB3YUea1yz48lDoAyDvx438QFGE6GvPhPGUnsUss
	DypVuUreaDOlk=
X-Received: by 2002:a17:906:eec1:b0:bfe:ed06:5a16 with SMTP id a640c23a62f3a-c108f60a8f7mr5710866b.52.1782171919729;
        Mon, 22 Jun 2026 16:45:19 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0c5e998decsm422908266b.22.2026.06.22.16.45.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Jun 2026 16:45:19 -0700 (PDT)
Date: Mon, 22 Jun 2026 23:45:18 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, riel@surriel.com, liam@infradead.org,
	vbabka@kernel.org, harry@kernel.org, jannh@google.com,
	sj@kernel.org, ziy@nvidia.com, balbirs@nvidia.com,
	linux-mm@kvack.org, stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
Message-ID: <20260622234518.nnx3r7ckphlxn5vm@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260622130651.23359-1-richard.weiyang@gmail.com>
 <ajk0N3Aekapljaoh@lucifer>
 <20260622142102.pcmr5pftshj5lvju@master>
 <ajld6RKK02Vi-LxM@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajld6RKK02Vi-LxM@lucifer>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B40DBC0004
X-Stat-Signature: 6cf86f6zdq3umwztjzjhhxikqx7oa77f
X-HE-Tag: 1782171921-342439
X-HE-Meta: U2FsdGVkX1/A6ISH9Hpy6+tdof/j7dGIwYV/ZMegmpawafTpD0ECRhlvk30BmF3joKLNO0I/COF1ZtxGQP3IOq4zlfzHijga1ETVz7BfeAX+QvAuofs+w4YHxlwbmHAgOQL2XTvZK8tJGousgQLjd5oxgo8FN1SLTPcYe+ZClU6a3oI0DmAUawdJEGdzN2YHSmnSa0V3EiZjhAbJ7sI5FJB4fY33KO+clJUl3E1qKsGg81j7ZzQPodr3z3szqzcB0Em9JM+pxlEZI7tl1PZut/FCxjFiMwd3v4qiQk07wkVLo0MsisI3wNqAvzSw/D50nJHKqXGKJe1tp+qUFCEw84ioGFeI2/xL3j9pddkFyUlzK2xIBPuyy71DC3Tv+5izgLyGKIEguN/bUQmn9N9ONZuQjdPC32QVn1KvDHenouOF4kL6z9P51XMxdwfvfU0L5Plp8t/rhQfaoMDoBUNJ7u66ipDacQ9ON0g9wykCkx78hjmgQt1/+aiLvcRNopI2Rgm0ZpYW6Ib5tIZ2ZThDHez0KFXDSOby8wJzaNsw63EDUsugjB78hQ/MD7gAJjUszRwwjKEJ9SM/ayFN7Rday52M73pMwjWwh9aQMkE8iPVZe6JfS822dCkqj+nBh5Xkb7hXBr9iqo4GgY8CfSd6z1r4S3e5EvT59xU2NjC8Y4pTsBUZTfM5ZKeslxFTTUA2JxrLEXNg14SnTH3LCZjS4bN5rG3yIetyX9DSnmJfXFIPLVWWxBRZICWDYF72qGItu7H8IC6gisPF6bFzi+y0b5Ock/gAwTgh/N6ZvSPU4FSnoO8aflMkCSm2xDeev6x5kSEI2FgkExjXqUN2UJoCuJaDlU4hMunC7PfQBn8DzSAmH8mkRbccTM7E+5+1PWpwuhqPOkeqxas9CAiL1EXRUWtf4vF+qyKnV0cCnKH1WZ6H5IjGYo5aG/JPKQqPuzCXJ8sMYvZm+DLs9FyOPLC
 /mOaJvJd
 2vvlCZ/Bkb8q1Ogz6iSPN0pNBjf743/i4DBMuqttXO9NemtTIPconHJOsNnBGLlxGwzpcy7pEZSHt4nRXFd28K48grK56Q4WIosYlUnbXGD3wMO+1nrVyE9U7kiMAIqOewGbX1gU+IKrLtBjI5Mi8beWmABEpNNGVMZCJf7QEMB4PLFdCUHLtkUSB6O4GvlOg9CUZixJVG/GtcSYrntJNz+AON26QkDTT7/jwMgVTuXlLi3+csrDWjpsgrB9i8+PtOCzo0lPahkiSu7N/VDbtd2nOEgDIq3GaeoXTvT3fcgGbnJ496diQRMdqXQULNG+lpW0aJUTvjJuYLmRZDoenW4GnL1y35mDVaOvVuKDTlG18NBtI+DFUrjmG7X+R03ry4RdFVaWRXESXilD2r3wW08PkU9PkN1iM/Hx0lgB89BpEZ40pctuESuQEh7UJZDPc2g5O9emFFbAhdpPdxpuVXzo5U/eX7na615js+4HSOHhq3i0W/35+4iqfrtn5MJSeRxy6HeLKR8e4VfUrAuLg9CJvL8w7uETFdGeXuJ0t3jaAwulQ2aRsfgZhAz+ZgyJtT8lCfG3UI6QgNyfE3eajsNQ4TYmxrfyKX6XD1QpVtKBaxNaHqafHCKeOvznlHGm8r0ivLU0dvxNjDrSuV9/9Yxk9j8brOLhXrP3GaH3v4u4eBqTrCgbrb1QZBJqGMyrEyKwAW+es6O71rTWbDwtV95Xa3qqsSqihRQB70038N3oS21XU71gi0G/iBXc5jCi5KTar
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 05:11:02PM +0100, Lorenzo Stoakes wrote:
>On Mon, Jun 22, 2026 at 02:21:02PM +0000, Wei Yang wrote:
>> On Mon, Jun 22, 2026 at 02:46:40PM +0100, Lorenzo Stoakes wrote:
>> >+cc Lance, linux-kernel
>> >
>> >Your subject line is 83 characters long and is way too detailed how about 'fix
>> >device-private PMD handling'?
>> >
>>
>> Got it.
>>
>> >You forgot to include linux-kernel@vger.kernel.org on the mail, lore seems to be
>> >a bit broken atm but in general it's helpful to include that.
>>
>> Got it.
>>
>> So usually we send a patch to both linux-mm and linux-kernel? If so, I
>> remember is later actions.
>
>Yeah it's better for dealing with kvack going wrong etc. :)
>
>>
>> >
>> >Also is useful to make this [PATCH mm-hotfixes] to make it really clear it's
>> >intended as a hotfix.
>> >
>>
>> Got it.
>>
>> >Some commit msg language nits:
>> >
>> >On Mon, Jun 22, 2026 at 01:06:51PM +0000, Wei Yang wrote:
>> >> For pmd_trans_huge() and pmd_is_migration_entry(), we does following
>> >> before return the pmd entry:
>> >
>> >Sounds better as:
>> >
>> >	For PMD entries that satisfy pmd_trans_huge() or pmd_is_migration_entry(), we
>> >	perform the following actions:
>> >
>>
>> Sure.
>>
>> >>
>> >>   * re-validate pmd entry after PTL
>> >>   * check PVMW_MIGRATION
>> >>   * check_pmd()
>> >>   * handle on pte level if split under us
>> >>
>> >> But for device-private pmd, we just return after pmd_lock().
>> >
>> >->
>> >
>> >	However, for device-private PMD entries, we simply acquire the PMD lock
>> >	and return.
>> >
>>
>> Sure.
>>
>> >Also can you please give some justification here as to why all this also applies
>> >to device-private PMD? Right now it sounds hand wavey.
>> >
>>
>> I thought below paragraph explain it. Not sure what justification is preferred.
>
>Something about device private PMDs splitting the same way THP ones do, in the
>pmd_is_device_private_entry() branch of __split_huge_pmd_locked().
>

Hi, Lorenzo

Thanks for your detailed suggestions.

I tried to add the justification here, and the following is the commit log
after consolidate your suggestions.

    For PMD entries that satisfy pmd_trans_huge() or
    pmd_is_migration_entry(), we perform the following actions:
    
      * re-validate pmd entry after PTL
      * check PVMW_MIGRATION
      * check_pmd()
      * handle on pte level if split under us
    
    However, for device-private PMD entries, we simply acquire the PMD lock
    and return. This is not enough, as __split_huge_pmd_locked() would split
    a pmd device-private PMD under us just as it does for THP PMD.
    
    This is particularly problematic when PVMW_MIGRATION is set (meaning a
    migration entry is sought), as it causes a device-private PMD entry to
    be returned with a different data layout, causing memory corruption.

Just feel this is not that smooth. Would you mind taking another look to see
if I get your point correctly?

-- 
Wei Yang
Help you, Help me

