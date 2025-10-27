Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAEB8CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 09:22:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BFF28002C; Mon, 27 Oct 2025 05:22:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16FFC8000A; Mon, 27 Oct 2025 05:22:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 037548002C; Mon, 27 Oct 2025 05:22:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E0B0B8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 05:22:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 970D3160516
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:22:17 +0000 (UTC)
X-FDA: 84043353114.01.6E6BDC7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 22873A000F
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:22:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZeArEhqO;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761556935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A/GXeoHonKMlzjFGTYijF05WfyyHRvFPdjwbyNeXc3Y=;
	b=CaLmBl7zS4iRJGJRqBgM/13Z3GKKaQt7w540JGn2iQcb7nEyYxljnZFDEPPLVPYcNYD6eP
	Gh/miAocQwT3WTvGz5LI4ewqsAoBp2YzC1cBtUVzu7zsKmY0Pev1z1sQcGBkB9JldHb+u0
	H8+uwzt5Ikiy8/dfDvzJsMibnZBqmsg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZeArEhqO;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761556935; a=rsa-sha256;
	cv=none;
	b=U/McXNsey4CXsbetoilgtfGPoGbmEO0bYopSsHdTGg0zs9g6FKmOeC1DdFWB9QiLLrkHqd
	yclVZktYLJR6P62bCyh1PNkI+GXZGbUwNnThXiP7VxX0gT+z/lyNoeFlOkkZp0RB3SeIdl
	8bw52uAtmS1rAZIoeiCtJNUTXVScyB0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761556934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A/GXeoHonKMlzjFGTYijF05WfyyHRvFPdjwbyNeXc3Y=;
	b=ZeArEhqOB2nPgT9UQdOsrhP+1You61yRQzP5NqROTx89v6lck5+75GFDk0LIDtb7amFQs+
	B/bndFWgO5eZ6CkdyOyPB/q9QgegFXScqpIETZYzej3ZQb4g07FK7yGJI/JdWzrx+nvRaD
	q34NxUqAonKLh8PeMRSsmlIuYx54b1k=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-tOP5zRcSMVC7z1u9glDaMw-1; Mon, 27 Oct 2025 05:22:13 -0400
X-MC-Unique: tOP5zRcSMVC7z1u9glDaMw-1
X-Mimecast-MFC-AGG-ID: tOP5zRcSMVC7z1u9glDaMw_1761556932
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-427013eb71dso4359076f8f.2
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 02:22:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761556932; x=1762161732;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A/GXeoHonKMlzjFGTYijF05WfyyHRvFPdjwbyNeXc3Y=;
        b=MZh2PbAaXIhdQCHhDtTCnSokHAC3bNDrAXOLCEF9xzgl26yPv26hBLZRngcfq4qf2t
         JYCEk4D8UPbbygY/Ffttm0NAYgOStf8E660cvTLSjqVjsTq1oqp6AbbYEhwHpIrQ4aTY
         u2NCq89d9Jp3V2+/aMNc4W7P47jgR4vqo17m//95u4W146GFW0aG3SewI2q3cNvOBsPq
         wX52l22eCXt89AreiaFkc+5u0ayBQG3yZx3C6/rSVHjiUQXR/FwxPDZnGKTzsDRXeDMo
         2WMkaXICjegFtbWV19D0NLdOWvg+wZkrzqsNMBuI0O3edNR/qYv+i9YkUEgYdNpztFLx
         WBxA==
X-Forwarded-Encrypted: i=1; AJvYcCU1QJOQkF7GOjq5y0p6p40gC5j4BZSD6GRX7jwMsseIO0hXbtARoKp3KLXPTe8UeLTpQ6fmhH8kKg==@kvack.org
X-Gm-Message-State: AOJu0Yzpran77HjpWr6+2AF90FY5ARmjFnWIdoHkhygGvuBEB5iqYMn7
	gM6KcIrD8x8lfJ75dOn7YGWeuRWRDHqZYKGOndi4Pfqne+XKzj2VjADTFqv1BRKqWPhTmvIl7lm
	8dY5jPKqpFda42YVduUW57R2DFYtf+Jv+0ww3Z2+mYtSbJXWLBSk0
X-Gm-Gg: ASbGnctWmBlo8cameBGUlOHfLyhm+bC7aRUIFal9wlKYie66XRw3N2Lj8AuqCdqprMW
	61qCAhPHzYHw7U7NCKs7rF7AiuocNZ2cxoK0erTQqasPEGRVsdnp1iCGuiA3tgWrA5y7KK1jIb7
	7zh9mk/PwlWfJEkGGsivBy7gbJJH9y04JUq96dFq1LqH0u4895O06vmUh+TN5phZ/LarhrRoXKg
	hGJ1sPDUJNErzuvypf6vZJjqS7z12wUSlQhxIK4aVKjZ3BElJyfUzJ+D6bmrvS4EGRoZnygrJe7
	DTPOiT4etqnlkNdyTUGDGpDI1haOANdAvArHDEs3PbqNkAOGUIMNl+5lfk3F6U/EqbmVeVTsTly
	rbl4jRD3ANomkBSDJ6aiUUDtjQjfyX7r/TR1l5vhlEiObxzEKKeAH9eBiroFqrfrv9H4aRspdVX
	MfWu3zf69C+xhnhFv8CFixKyI4Ya0=
X-Received: by 2002:a05:6000:4024:b0:3e9:a1cb:ea8f with SMTP id ffacd0b85a97d-42704da3924mr26721883f8f.52.1761556931764;
        Mon, 27 Oct 2025 02:22:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHDRyzbYNgapAsDQVUP/dfMOneGlFTnaQdS54xLTyrz5QcB73wRWvx5krJws1/xS1I2xHKHjw==
X-Received: by 2002:a05:6000:4024:b0:3e9:a1cb:ea8f with SMTP id ffacd0b85a97d-42704da3924mr26721844f8f.52.1761556931254;
        Mon, 27 Oct 2025 02:22:11 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952cb7dcsm13518433f8f.11.2025.10.27.02.22.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 02:22:10 -0700 (PDT)
Message-ID: <8fc01e1d-11b4-4f92-be43-ea21a06fcef1@redhat.com>
Date: Mon, 27 Oct 2025 10:22:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 1/2] mm/memory: Do not populate page table entries
 beyond i_size
To: Hugh Dickins <hughd@google.com>, Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
References: <20251023093251.54146-1-kirill@shutemov.name>
 <20251023093251.54146-2-kirill@shutemov.name>
 <96102837-402d-c671-1b29-527f2b5361bf@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <96102837-402d-c671-1b29-527f2b5361bf@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OWcP1HcdjpfQnf1trFRGembDLAoN_THFke97rvqFF5Q_1761556932
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 22873A000F
X-Stat-Signature: nhzsd33mzoeqpbb84u6k8d88k84riprm
X-Rspam-User: 
X-HE-Tag: 1761556934-901364
X-HE-Meta: U2FsdGVkX198mcDqwxeEfgTubMBIsZWY2TOAOYpSFNQNs3riku9s42mjqn4awvO2biYO9z98oyJJRFVU+ey35ma5LRO/8kVGccPXUurBfIkG5i65e1yxlYA93I3qUr8eyUEQuLDBizBgslOYLoZZ3iCZL5EjD+Kxt/Gf4xIBObXgmF0/Pv5/qZxb5VkBx6+LL/+5OF7DLGAuYs2Ztcm+sLiJBHy2H6bUC/PKYzHwP+P8M6Ja8YTCmBgHke7LuN2iGGBeoxd1tdjQXH/Mner6aLSKAN5wsCVlj1qQr9U76CwgJzh+JAkZjJV722nu+4Nrnd4SzgDUbgB+z36k5PSp/F2iej+Gk1f/mY5VHu3IWMFeQsa2cCsjP6r/ZctNRKysNO4VmNaqJXPCKnwdrnRit3mLeIPjuJb9sqZQpgpAQp9FWiBuD/AyhO4ULwgn7scaNGzpku4xBQQN4G8l0Krn6Glvzn1XJlfQ2Qtrcoxk50o6/EG5mVoAg//eE9PgHMfTqDGXf+vxXhurP6t/7Jti4CyjbFptrRt6FHD96j1nNI5Tcig+1w9qIfCa48Zb8gVYAVNqDYhF7gLjKf+LWPsdJftdQ7giuGY/HOX76OBX3WsLAvjHh20jlpvQWTI+0Zp3a/bUVrjmVkTo0v8wHY9S1jAIkbnLvTBiDhhCWJE/Bb27jao/Fx80KpNXZ6OOkKGSLm9VU+ecatIW1LnXoDPDRbsVoP+FuNXoO44TXw0+iaaOaM9CMkMyrDnVrUI+nC1a/wwSWDBYnX9I9IGO4Zm5vltGIsOGNy4jUg1gev1tUCwsvH8BLWuuy50ZEYB/6qlFa7ajr8+QyXoPZTz/KC1uU34IGw/DUF6QqCMx0WiHuKkE3cCEY77BjZ1SxpymegwFoo2f4m1mng6ZSES9PtMyyetRV/cOSvTp8fP8GJVHgOXq2JGpsFMH809NcTqEZD/bbufsjBe5b32aBqJ0t6l
 Y6252imk
 L15yAireZgBmZ3eKqN53rFfPSxuMaj8njQ1VHbev5+mKtwIejw9EQx4ry92XDL3x8i0ba8UFw7KLG8yEgs/esZqJqnRXTygQ5rx1/+InktLTKoJDywHAg2tY0c0opN8/0uWaUAyZfOldEFe0jOda8/FIMvjNzhmI1VWa39+6eLUbpD1uk81JQathhNAFLlbwaBophGWITdvKF9zqpyI5w+z2xiuB4Ul1ITFM8RaeZ4kHLrjC5JO2LEJicwRmaw6T/wvNqpKLuVaKeoHSxkna8ypBjlDnK7tzj4JQ2CyI8z4QF2RcIZGkSe/UZfg5h5vp60EfX1sZlKxpkvZGnCeHrS+Rs/5iNurWEJf1ySiq+jPF+N04+g/oUMHd6y2c8G6hAT5OF8B6YrqxFu1jhuWaxFZc50lGz5vOOT4/oOKqGWJmSJYwW/C4uViGDV+hudC0HkPMJxmCeKPYpUZiDR/D8gJrJRHAm8KYwOO9/MUGOsZOvHv55cFwoMu9PjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.10.25 09:20, Hugh Dickins wrote:
> On Thu, 23 Oct 2025, Kiryl Shutsemau wrote:
> 
>> From: Kiryl Shutsemau <kas@kernel.org>
>>
>> Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
>> supposed to generate SIGBUS.
>>
>> Recent changes attempted to fault in full folio where possible. They did
>> not respect i_size, which led to populating PTEs beyond i_size and
>> breaking SIGBUS semantics.
>>
>> Darrick reported generic/749 breakage because of this.
>>
>> However, the problem existed before the recent changes. With huge=always
>> tmpfs, any write to a file leads to PMD-size allocation. Following the
>> fault-in of the folio will install PMD mapping regardless of i_size.
>>
>> Fix filemap_map_pages() and finish_fault() to not install:
>>    - PTEs beyond i_size;
>>    - PMD mappings across i_size;
> 
> Sorry for coming in late as usual, and complicating matters.
> 

No problem, we CCed you on earlier versions to get your input, and we 
were speculating that shmem behavior might be intended (one way or the 
other).

>>
>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>> Fixes: 19773df031bc ("mm/fault: try to map the entire file folio in finish_fault()")
>> Fixes: 357b92761d94 ("mm/filemap: map entire large folio faultaround")
> 
> ACK to restoring the correct POSIX behaviour to those filesystems
> which are being given large folios beyond EOF transparently,
> without any huge= mount option to permit it.
> 
>> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> 
> But NAK to regressing the intentional behaviour of huge=always
> on shmem/tmpfs: the page size, whenever possible, is PMD-sized.  In
> 6.18-rc huge=always is currently (thanks to Baolin) behaving correctly
> again, as it had done for nine years: I insist we do not re-break it.

Just so we are on the same page: this is not about which folio sizes we 
allocate (like what Baolin fixed) but what/how much to map.

I guess this patch here would imply the following changes

1) A file with a size that is not PMD aligned will have the last 
(unaligned part) not mapped by PMDs.

2) Once growing a file, the previously-last-part would not be mapped by 
PMDs.


Of course, we would have only mapped the last part of the file by PMDs 
if the VMA would have been large enough in the first place. I'm curious, 
is that something that is commonly done by applications with shmem files 
(map beyond eof)?

-- 
Cheers

David / dhildenb


