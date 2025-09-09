Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 066CDCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 11:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 619078E000B; Tue,  9 Sep 2025 07:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F15E8E0001; Tue,  9 Sep 2025 07:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E05C8E000B; Tue,  9 Sep 2025 07:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 39EC28E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:43:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04B4A1604D1
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:43:36 +0000 (UTC)
X-FDA: 83869526874.11.F8BF6FB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 96335180008
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:43:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g63hbSzY;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757418214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZfsNktiY5EeJ33gIhfo8w6nygoXQJt9oz6VGjfkKEBQ=;
	b=rlUKdgqVm1H6ZtCqARRw/KjdoKdq5TlnrhK5dOSwkGhtOo5j6AeGNDho/0KfG8quCtRtet
	T2PgaHqn/tIk+rVsCv/5fYHwsdZvXz8dAFy5wnn90tHaqnP9a96LRTCCXh1ANioiLZ/NnX
	UiSSyQosTMTW1hjzb/VvixpD9KiQxss=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g63hbSzY;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757418214; a=rsa-sha256;
	cv=none;
	b=F+6mMTsQdaFPFMsTYRGGxfPx3CmSLldmMGQRM+ixCg2WLJvxWI3aHWv5GokDeIJDP8CN8Q
	13FReJqs8DJJsM9kZlK22gM5VUpNw3usGWxRyFwfkxB2E9yQLDNiQPZDxaxLE26akA6Bfb
	VJX9AacfIq6PFoDS0YXFAcAKqRPtquk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757418214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZfsNktiY5EeJ33gIhfo8w6nygoXQJt9oz6VGjfkKEBQ=;
	b=g63hbSzYtAOzxqTf/aFkxx1KNSi/NJ2J4789Y77DnBdt0epeTBqEIU+wCR4XWiW5gOgNbf
	yVgeG9vshbaH6cn3mC5xgU21xq3Nlk64VPHb/FI3yJDqRDh3nUoW5qbJ7kUVnF3mDqedFE
	VrZCw6MkKl+aCGrq41SzbYAuTm0Lh6U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-3Hb-ewy5MxOYkjxbIWvdIg-1; Tue, 09 Sep 2025 07:43:32 -0400
X-MC-Unique: 3Hb-ewy5MxOYkjxbIWvdIg-1
X-Mimecast-MFC-AGG-ID: 3Hb-ewy5MxOYkjxbIWvdIg_1757418212
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45df4726726so1310035e9.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 04:43:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757418211; x=1758023011;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZfsNktiY5EeJ33gIhfo8w6nygoXQJt9oz6VGjfkKEBQ=;
        b=k+JQud/Gm0MKbWarROEXcX+znfe3WRiAULBFBUUZsGL1VPODlTHWV/Qc/vmUn/67M9
         DFd/6Ba1TF9ztUxP1kgzcqK7NYrcHJgYFQvBky/jnR33uiizeOoQbr2K3m4xz8n6fViX
         dpPOVp/SL5hElXnOdKrw1p2UG0EP0zJV2v4xvOCKEJ0nqvOBQyMV1geCv5rQ7k4tF11s
         syDm3tbwgsuV0AfUBm1B7zUUA6vuqmASYs3drGFaVq2Th6tcwonAWo/HSt7qIMrKWrqA
         YMpvUZm9GTcl4dmggOJqtlXYKIbxOCHnxNrkbTjKyYjl8JC/vzKhtLRqVo3nbPFbOikp
         vKyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFSs+yVXVfxXZ3ZqlYC5UQ8e+7vqzSpHrz59zYxkdQPimiChqBKr3JzrA4MqeU77xwp0mVRi5KVg==@kvack.org
X-Gm-Message-State: AOJu0Yzyd9AB1hx0wh4HMuqJtPcQt0eTc7Y6ZktoEWdq9VZgG34vm2WN
	cC4GdEV8ZV6mX2mA3cknaw3bW+7ic19ltTTf3nElsPpoC5U8CPqiwXsIZCjhSoXoz3Rdt0gzVs/
	8onTbdqm8HeTkNvBytOn7F1uFG4SHvWPDfcwjvWZ3dAyZtxAABore
X-Gm-Gg: ASbGncsL9p5HJmCh1LFoIQFRF6EFuq/T0xdJviabF7DXksehD11fls31lSLjzUZI7NT
	gBEkRx4tsyctFL5UkeSp/ZfMCPncKG+NACIm0XhKHHHXQMDnw+hAC/OE0IAtiufomFAwEglphiv
	0kR2qhraShOT0RTDrCFYCGHxhFmKOnm1y95cUfBqeMf4o8l6/frA+tiRaoS5kjLcy29t2rOoSkZ
	+9AZmW6InMdQteKPHOfH5HJtZXcFVJvkkql0mgMm8iSgAfClezm9ydO8YgM5goKd6H5xjLCfLJS
	zXk2VrkmaSbjOgQUNxLjWxD7wq2GFYculudGPL+Sw21ebDReXyGqMooYahFh0Tz8wp9i5g==
X-Received: by 2002:a05:600c:45c9:b0:45b:97d9:4127 with SMTP id 5b1f17b1804b1-45ddde88188mr92336135e9.1.1757418211520;
        Tue, 09 Sep 2025 04:43:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJoKdOB5PemUWBhPxYUhvzLBwqsvjrZuiiRzLKO/WI4N7BBAhfeDUq9Rg/ZPYt77RdwSoTMQ==
X-Received: by 2002:a05:600c:45c9:b0:45b:97d9:4127 with SMTP id 5b1f17b1804b1-45ddde88188mr92335895e9.1.1757418211082;
        Tue, 09 Sep 2025 04:43:31 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a41f.dip0.t-ipconnect.de. [87.161.164.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e75223f607sm2331885f8f.51.2025.09.09.04.43.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 04:43:30 -0700 (PDT)
Message-ID: <0847f0b4-a02e-42d7-9bf3-797a753d3304@redhat.com>
Date: Tue, 9 Sep 2025 13:43:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V10 2/5] mm: uffd_wp: Add pte_uffd_wp_available()
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
 linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Deepak Gupta <debug@rivosinc.com>,
 Ved Shanbhogue <ved@rivosinc.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Chunyan Zhang <zhang.lyra@gmail.com>
References: <20250909095611.803898-1-zhangchunyan@iscas.ac.cn>
 <20250909095611.803898-3-zhangchunyan@iscas.ac.cn>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250909095611.803898-3-zhangchunyan@iscas.ac.cn>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5BAl8xGlOS6Y8r3xYTwG3aA8nUKFQlQ76zBp3TQ7FU8_1757418212
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 96335180008
X-Stat-Signature: 69qpahmakejr4wa5c63ay54k41owrfar
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757418214-462587
X-HE-Meta: U2FsdGVkX18G4akkhujs1+oL415jsZOptMBcNYO+uh9nxsoslOl0VvJWjG58nmottz4qZuACtX4EjRHuo/ZUih4AAqbL3bX7iqDS2384doS6bn0Q5FFb6n2XyUDkMK/bHcewIf+ObUsARGso6aMmOrMpyeWgq1jYN7XRSQ1uAW7SR+kcwtP04lNxeGYikPnOSlWNyaN6H86bVQHg3Dwwaql9ivSzHYDto3Ehd0JCcYh5+MWrMiDmosg0DoC/ZnXt4GRbjOg5KYjoAQCC0qwbYLo7V9d1l+U4j4bMWwtyM0pQOfXgPQQyiL47F1OdLWzutic5kVlsIHGYuIkcCDPNcfE8yBphC/foeYAStez0hTLn4bOjOybznqdgcXd1NOg3cUTxbg0M988C/R3GU7sFWv5bBk5GkiDj91RAQV69Ii3GvD62XQTbUvyC2umfijNPAtt/HBdwAwkw+NTZlSHh0Zo3dDbCLgcP3QSd78hcCWv3GGQ0XQhd+Put99yAK+n5C5W8D/DA/RzTg2K8n7peekFxHbMGItaoskpux+NwUst19ucbI+9GO9/wXrWVZwBAC5b/M2nEjL6yMrnEDEPG89uyCuUP6+D2E92nGDyGIKCBY1Olf/w0GLvj/urCmqhUUdSCfJPs1u5B/bg4gDZ6syPtBi38nzYATJHe6St50sgfuk6P4x3Uvvk7E4XZoY86cgI4O8y0x/ZpK7P+VLBlf7iFIkdqMUM4K2fevjolTGaMASMpXPJKlpgIMBW+fbLS48jop7es3OFjPXpjkJZnaJqj9xNCYGoKJ8Sq3A2/VHjt6BgncT78A9hjUcs2IVnd/zVm1ku4m0vqjgDwhw/23XaZH/fC8Zvgz51rlAsk48AK+aRc8Rg+3x8H+Kf8QP5OOKysIkbi0Z+CAKhVk9ket2RBa7vDuXYGE/u86Moep8RXn/+qwlfXL/7Qv6aGkJPIihdL08c9kOxPTRIQA/M
 oJLSFMw0
 MqDJ1uMoFd3MF37FRxydie5rBKoNK5KPkCGW+p5YKZEF1AqKOyUqUGpL3OyIEo1yO4ZBkK3zGz7P1ykcIDzKYxyppHD2ct5p7Jv+JxHufHK1UOr/7ult4bbPpDR2C8Pi5hqHVHdg0ajMTcCBV6i1/ORqATFERZ/PcCP4lCADEUa1ADa3kfiZm5u5hwgTpBqmc2+gXyNeCfCVmcFBE3ZiCkKZIBaThu97GotdSLTX6zsmmMgkgv89n+WsKqCRKbuzyOfc4Dx0hqcalRSCC7pFlvBpqLiHy7HkUHTQlfMAt6HT0OnDCXzxxDo79ceG8lBEomgn5cLNQMJHRLiXVYDw4RwlGKE9A02aaG683d+3fb+nQXgXKajetPXxd3expmto32is5ARdEaFqoz32n+F4GVXdQV9UPxJIWI3LmI1BDUhNKvLApOYCfCuIswIXaK8decHM/eSNpoXEU13B5od47TTOwP/38Npxao2kE/3bDVP62o12Hh3WyrroScsWsMIEi6P2RoqWfGHrdHPuNjHs+o3XuDdJ1kQD0Wq476k4Fe46/TkaF/D9QM1C92v3kccsL8uQmiCXWXwauALlMMaCwZVHmAJny4rx+qBDTpkdq7/D2ydbekJuGJcSL7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.09.25 11:56, Chunyan Zhang wrote:
> Some platforms can customize the PTE uffd_wp bit and make it unavailable
> even if the architecture allows providing the PTE resource.
> This patch adds a macro API which allows architectures to define
> their specific ones for checking if the PTE uffd_wp bit is available.
> 
> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> ---
>   fs/userfaultfd.c                   | 25 +++++++++--------
>   include/asm-generic/pgtable_uffd.h | 12 ++++++++
>   include/linux/mm_inline.h          |  7 +++++
>   include/linux/userfaultfd_k.h      | 44 +++++++++++++++++++-----------
>   mm/memory.c                        |  6 ++--
>   5 files changed, 65 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index 54c6cc7fe9c6..68e5006e5158 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -1270,9 +1270,10 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
>   	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_MISSING)
>   		vm_flags |= VM_UFFD_MISSING;
>   	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_WP) {
> -#ifndef CONFIG_HAVE_ARCH_USERFAULTFD_WP
> -		goto out;
> -#endif
> +		if (!IS_ENABLED(CONFIG_HAVE_ARCH_USERFAULTFD_WP) ||
> +		    !pte_uffd_wp_available())
> +			goto out;
> +

Same comment as for the other patch: make the 
CONFIG_HAVE_ARCH_USERFAULTFD_WP part of the pte_uffd_wp_available() 
check and better call it "pgtable_uffd_wp_" ... available/supported.

-- 
Cheers

David / dhildenb


