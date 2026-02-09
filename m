Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E89B5E7E0CD
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 18:22:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FB5B6B0088; Mon,  9 Feb 2026 13:22:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8DF6B0089; Mon,  9 Feb 2026 13:22:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08AD26B008A; Mon,  9 Feb 2026 13:22:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB2666B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:22:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8BEB71B2819
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 18:22:11 +0000 (UTC)
X-FDA: 84425737662.14.D940696
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7DC264000C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 18:22:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dX2FS4ui;
	spf=pass (imf01.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770661329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tbNzYBZo9BUScy0n0qSEEP/X+PFYqoABoCMZm/T5fRY=;
	b=tWewX4RsQyAyHjgKDTjGN1d4e3nwlBgFsB0C+RfNZscbTwAyI2Ol1XtyrmyHu9/BECB5FA
	nH6PBM4SD4T6QAeRlIvVfsH+LSkPFUeLzgSGA5wNv0j2vIwcMhH2SmzDf33OQUPxVoIpZ4
	Bj7pJN5WqT7rX+Zk9pqkqCGHArZHWP8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dX2FS4ui;
	spf=pass (imf01.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770661329; a=rsa-sha256;
	cv=pass;
	b=09fsFS/25l7xpKEXewSDmN4pr2yTWXBe+MhlFrjVfMVmQIcPkyMzACqcPDf2iMd5Vm43Uj
	EcKIuQXrxI2bkRWZQTa4JkE9/hiZALDihAx/1YG2sKI1rScjK0D2qYv3a6V4nYoCR9Uwxh
	VGDJ5CYZCkAVsLlYBe8jm+0xoJxhlMo=
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-5f5418c40daso5089826137.0
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 10:22:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770661328; cv=none;
        d=google.com; s=arc-20240605;
        b=LYwAT40xNyCvZt/q9YMrAUU+xi6kXqeqWdW2cq5kIT2G8T6RP8mNjCPUdYMaXakmk+
         eHmDUla7eMmkGA2LziE3rL9Lo5HORq5krjm905UF7kNTLO1IGVsPLlyaTK/tzEXSCCzH
         R1YYLW5rAfQkN6FSJQEIadJRrUE+5b8vUbf0flOw+EZAP/9mYIOZGbAB+ltokJ1O4RrB
         OrXJGEwe+a1Ci18g1OcaZLMIzQFTen4gDw1ChZlDOzfJrNg5wWAXSAtcvJkCLHkdyAQW
         xlAcKXGzyAIrsksQjHrZMYR430f8hlakT/GI+4wsrGED4zjtSL2u0M5QNef7M42IeiRr
         8rjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=tbNzYBZo9BUScy0n0qSEEP/X+PFYqoABoCMZm/T5fRY=;
        fh=sg7aNDDctrWSA/pdNs0Kixk9g4qYgNBHphPSC88hUpo=;
        b=RpgQWSVVvE1tDdgb9vn3v3VwlTObFCRTVk4Xm1B6R2HkKswaLbrq0z4IzTF9ATnGRS
         7R9T/X+NocOlUZrJ2JQ79hSm4QLR6JempH/cVkrUNz9srkjfwn6aLa5lJVYSs4JF85cM
         Tc9b+Od4JyOw4f4DrJWbUvYH06VYscT6BU5N3/BSkFcN/OTeHL6bK8PbqLuyDa5Gt95e
         F3ax2G3SOxgMduu2TApQJPxYMjYOPUWuNx1Jje0J6fJWUW5h29ax+5Wnh8LDSfxMDA9u
         QNIFAyuWt4zIhg5+UeztfopVEm0rFG8S9teh2NgMQFG7d0Q2u3AnIQ3HGNuVFC2sv8mh
         os3w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770661328; x=1771266128; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tbNzYBZo9BUScy0n0qSEEP/X+PFYqoABoCMZm/T5fRY=;
        b=dX2FS4uig1Uvx28Xpxly2TAvloIRPJnKOw6MR+98sME9VZ4iJx2PbuxLVBC/D906qA
         9x7hlQW+tzg6JVfZKsNZGqMr6r8XWKkffxpRrsEkUUSzpZhf1WhsGRrwK40g1lT1bAr4
         4DSyfC0FEtNF/0s6TTMht0J7giaxZdNCjdChelRPJMeEEmac3b7C2fGUHWDLI5ZpIEa9
         qlwuY43eE7HWC0acSbERjxhRb31VcJByZfpzaP+bm7OV08isVlDl9+vl0Li8Fi4CSmbz
         uLQAxipCyRtYI0QHLZ+UL2+zLdONxlkkVd7ONrJA35dBtxSL4bMJgbIzmaas77hyMTXC
         MY6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770661328; x=1771266128;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tbNzYBZo9BUScy0n0qSEEP/X+PFYqoABoCMZm/T5fRY=;
        b=jAZeoY6OkF8fovVFu12fwbSbFSTK/6kgPmXuGaOqaP4aW+AFH3UTFMqMsI8nyKko/p
         wd7OP7F8hL5F7cs8R6MtpMRnwjyJwBKXL+WyZfjpN3Vjl8JU+D9sAqRkKtqHMKAoUJGD
         45s82LVxd2fdlrc9UXrBX8ffCM3uOv94J+qKKWRqath/SEmwLFpQYQjTjz3GKqKsvIIf
         2Vbt+AE5BO+Qvwhj2lY5Htqrulrqm3c6qfc3z13X32dX1QOVix/d8ZLFGE7KsQMI2BOZ
         WP49c36JT7XkNDqjbmVZtSwe1iwzESYha7KoOKxhyYKOPXgx0wX6SwNtCbX4uBJbVr6j
         sLdw==
X-Forwarded-Encrypted: i=1; AJvYcCWKz/GfmshPYywoI9CUDLEGbWWsZfAZ+9jrSph4nsIFATiMs2zct4JiGRndbtMiVa5FGEuK6HOfJw==@kvack.org
X-Gm-Message-State: AOJu0Yyler7vUOAoVuCDYM6R2VEnRg2moUxg9INO37CbOh+V1ISruyFW
	QWVU67RS3le0McolxWAKCTSH0Y7Hm/xUMn/LBQgD11g+zQ8eYrfqiMmcIjZOg1bEokMNllrpWEl
	ChegS4VlF+D9wly6u127m8a2EVu+P9YmKny1u3dgS
X-Gm-Gg: AZuq6aIO6mhgsDmB/ZGZ2BCUaow93wr++TSjDxvzTApOaEXB10Q9t9kzwFaC0Um7292
	D2jSmzJlKckaVIssYoNtq7D9dpMOJ7JNieBRB4gYjjv3JKabqtMKrYwiLGFu+0n/1Irh/BOOvqH
	PIDjTxWTMHRBCXk+obyYArhBMIgk0xPoqkcgtc0CIZbXRDmVDBPcgBXCWVwnTRCfxOnJzsrQWah
	ENUke6p5AoyrFgTbg6LkE2+2zzuXeFUjj70puYmlfJkDe1nHcJ2ch6reZTAiaksJEWhMNj+Vc2D
	XVbK2A13NuiU2oJhZFyg86B6zg==
X-Received: by 2002:a05:6102:26d4:b0:5f5:3739:100d with SMTP id
 ada2fe7eead31-5fc42e49737mr167568137.0.1770661328010; Mon, 09 Feb 2026
 10:22:08 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Feb 2026 10:22:07 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Feb 2026 10:22:06 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
References: <20260209033558.22943-1-kartikey406@gmail.com> <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org> <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
MIME-Version: 1.0
Date: Mon, 9 Feb 2026 10:22:06 -0800
X-Gm-Features: AZwV_QipdZ3jDVMHY-_ogWYPGgEyKyqzEeMCGF8rB9UqPWu_-IPvMP9sZmCT0BI
Message-ID: <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in file_thp_enabled()
To: Deepanshu Kartikey <kartikey406@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, seanjc@google.com, 
	pbonzini@redhat.com, michael.roth@amd.com, vannapurve@google.com, 
	ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7DC264000C
X-Stat-Signature: z6wrpm5n13t9k8rapfw5ufxei1ujd9ws
X-Rspam-User: 
X-HE-Tag: 1770661329-916593
X-HE-Meta: U2FsdGVkX187B2JSCfVaIWvI9C2BnV+7Ax2p4SKW1gZ5emTxZJcPiH0qFr3/EJvIbKw9T6l1ONDv9T/hW5TRXuSKuNjsu29F1XAz1CoFCOxwL0P5yxW+tny3KeaqrLilqxXkszCLtP3Kf7B9aL8LEs+cAbkp8kzvkSzdnomSv1uSBcnR5QhyMuFpphmSv2zcohmHsKNN2kSPfnEceTXZgVWQaASUmq2V1LvUXLh/RcqhRYSDlTKgNCnPFPjcnM0P5hHiYBxwLNDsB71s0C9CGfUMXk17V0GyKkft2crfO6KFB+EjX+Lu9FQSswlDVM0YOSUA+tS3JSXvzLn5MY3Id1gzBGPcWWcg0/k8KlZZFfXmtkfn/+d5bvNxgbdRomMAyyJbYJHb1Nl435cAZn8DuQXdLl8FdWxQBfdkHgVvso6m7Mbbb6mneN49OrGnOeuQOjL2KZYeawUKCuSPovUgxPH6tJNsG1eo2Ysj1HhPn+yfO0Uh/EAm2LH+Dn+7pQcE5twrzsaRcDrvhW5tRVAh6Tqsj+Qj1KXJHpgpH9yKWqlz+HV6Sn8PxRF2lJSQc/rivP705F2bNB/MPPvEWCe24rLQ37fqcqkp4L5EubXqnN0OkpjNG58pFLKcxq+fpL73psx8j+nKJlPO2hSW8HF7DMwJoZXK6pEHUZ+AhYpMpQO6a5GLEQvRIYCsvLuiOEojuXnZHvx2RfJHj9mAwkMAQgCny85aHhCed+ovGW7zztJKIUOGtlGo7WAVy4ltmH4ZZbvvDvcPcoWJt1eDkJZITz4FLSRkHvD5NO13wZPqGsyH/cizX1YyHZLru5dsBjoy2b0o4LRsqZr8ctGAjhX3MkDcIUAAeN7h/7cvCBEyzc5eCJk2fJMD+ypBwuHAjqmDQZ/UX+K+1oTJ6TXNHnrWqi5gQhEmkCiNS7FBP6hKeUIPbBpoRiLfGvvgyTW1iqGPJPeOh8OLRO1m8K4SRRx
 NJUb460G
 JaMZg9xye/XirFD1v4yi11IYlXgMNexo6TJpSBd/0jegF92/akX8pqIp6KuibNtL4L0TnZw6+nw5FpQ+zkwOc2fewG2F91gkT4qrCtUmM2UpKgASKCKRtyKloToc6VqXm/IqnocovGL1MbD8CYennL9VMUMxMez96pOt1oWh/XnaGY7HBCorq6S+as2X1qoU+xT5ZHFGIz64GV3Ce4Nv7sUzWFM5pkM4c4TnjotP/w1OudaevCIPAnHBsvNF1dOGlkFkpkh/pjA8hXLiLO/wSQqx5A9K2Umz2zuTu9AvVBiU2z06313zOTlIOVYkXQm0m+ulr9Mwc7W4tS24HfiCmSK2xCo2+QUaucLnpQnEaiavBp7VpLdv27Tjk9UiRkwK4wWgQ+pxyw9a/fKbkghN7ivC6v9e2QVagLH466AkQGLdm+WuswCYhqTIEtnbPrI6BYRToSBnIG3wdakAxhCPzfWwWvrwjc6++nrLl0iZ1/xtrjaL0OfyQnUhH8RxzUHCRJkq712h6VjFDa0VljxOiCSsf2k8nSkFM1GjJwq7vmcK9IEAREjwfOcwZ18hIJHMtET/l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Deepanshu Kartikey <kartikey406@gmail.com> writes:

> On Mon, Feb 9, 2026 at 4:12=E2=80=AFPM David Hildenbrand (Arm) <david@ker=
nel.org> wrote:
>>
>> > Maybe introduce a AS_NO_READ_ONLY_THP_FOR_FS, which we can just easily
>> > rip out along with CONFIG_READ_ONLY_THP_FOR_FS later?
>>
>> On second thought, why do we pass the
>>
>>         !inode_is_open_for_write(inode)
>>
>> in file_thp_enabled()?
>>
>> Isn't that the main problem for these memfd things?
>>
>> Maybe a get_write_access() is missing somewhere?
>>
>
> Hi David,
>
> Thanks for the suggestion. I looked into the get_write_access() path.
>
> Both guest_memfd and secretmem use alloc_file_pseudo() which skips
> calling get_write_access(), so i_writecount stays 0. That's why
> file_thp_enabled() sees them as read-only files.
>
> We could add get_write_access() after alloc_file_pseudo() in both, but
> I think that would be a hack rather than a proper fix:
>
> - i_writecount has a specific semantic: tracking how many fds have the
> file open for writing. We'd be bumping it just to influence
> file_thp_enabled() behavior.
>

I agree re-using i_writecount feels odd since it is abusing the idea of
being written to. I might have misunderstood the full context of
i_writecount though.

> - It doesn't express the actual intent. The real issue is that
> CONFIG_READ_ONLY_THP_FOR_FS was never meant for pseudo-filesystem
> backed files.
>
> I think the AS_NO_READ_ONLY_THP_FOR_FS flag you suggested earlier is
> the cleaner approach. It is explicit, has no side effects, and is easy
> to rip out when CONFIG_READ_ONLY_THP_FOR_FS goes away.
>

I was considering other address space flags and I think the best might
be to make khugepaged respect AS_FOLIO_ORDER_MAX and have somewhere in
__vma_thp_allowable_orders() check the maximum allowed order for the
address space.

khugepaged is about consolidating memory to huge pages, so if the
address space doesn't allow a larger folio order, then khugepaged should
not operate on that memory.

The other options are

+ AS_UNEVICTABLE: Sounds like khugepaged should respect AS_UNEVICTABLE,
  but IIUC evictability is more closely related to swapping and
  khugepaged might operate on swappable memory? Both guest_memfd and
  secretmem set AS_UNEVICTABLE.
+ AS_INACCESSIBLE: This is only used by guest_memfd, and is mostly used
  to block migration. khugepaged kind of migrates the memory contents
  too, but someday we want guest_memfd to support migration, and at that
  time we would still want to block khugepaged, so I don't think we want
  to reuse a flag that couples khugepaged to migration.

>
> [...snip...]
>

