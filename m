Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12AA3CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:00:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AA136B0005; Thu, 28 Aug 2025 05:00:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 281A48E0003; Thu, 28 Aug 2025 05:00:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 170A86B000C; Thu, 28 Aug 2025 05:00:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0272B6B0005
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:00:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B097F160903
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:00:08 +0000 (UTC)
X-FDA: 83825569296.30.62C3756
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 63C93C0007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:00:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MjXJQSU1;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756371606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B+eUQDQFyI827IMsBZ4ENEU8Lk0pMUb22YeE9OodMQU=;
	b=3bgVlNW69JrkYe9OFcrAEgatvrdTYsakbokv/ctGAv1Zjx3YtaCTCH549IPVKJ24fwBefx
	daqwgAwD7jILIHLzVxy96gGhdKMH994o7AeIDZ7rahDMUo6ru1sTuKagmcL9VEMxkIxtA+
	M/lOA3BNo7hziTS8cXL53QSr6uNWoq8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MjXJQSU1;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756371606; a=rsa-sha256;
	cv=none;
	b=BhY980NVQwP/+DSkGWZ3SNgjvxICU4a3JaB/nKDJ+Vsepl+18UCa+5sv0phr0UsUEQ68M7
	PPkdn+zRRIOGOgQzcwIpxdm/+d0fRpdxpV3bUK3dDI8EPrBWk7yPi5cgTPu+U+LXVkro5D
	WRuLxGrhbxkl1BxI3udxyezn8psmqNI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756371605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=B+eUQDQFyI827IMsBZ4ENEU8Lk0pMUb22YeE9OodMQU=;
	b=MjXJQSU1pmFAz4qgN5qJaBBs3NMN63AHduZ576AeDiNpzEQ68lIslHQFeoGQuXampi+q2f
	YTEyrlO6VpE28ZlR/s8OPHRTVaRcFzz138CPiEBSM7MLarwgaT995G0LSBUjUhwvtILFlm
	k4uktYR0/lQLR6T/GXDaa1EXPyBMWpM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-bCZBV-KANeSa3PfiQqLaOA-1; Thu, 28 Aug 2025 05:00:02 -0400
X-MC-Unique: bCZBV-KANeSa3PfiQqLaOA-1
X-Mimecast-MFC-AGG-ID: bCZBV-KANeSa3PfiQqLaOA_1756371601
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3c9bf5c8b12so403356f8f.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:00:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756371601; x=1756976401;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B+eUQDQFyI827IMsBZ4ENEU8Lk0pMUb22YeE9OodMQU=;
        b=kfr63VxqZyu9N9ZAtxVCa5uteasLkFGxxSkqCKuZv1NYTxreWLxjIYsYDqbxIQKmwZ
         ljv93KxAtd6Gwd8lEU6Fp3Cf9FytryP2U77q4NTOuc4AMO7LuqplenxobG6WaMxxjteX
         tpFXOzibTMgAddYhwW7/qfcGH0GYRjkIrdotfkYFmAcYhfKEGxm+aQIvJZyuNmSc175s
         E16LG6GlO/dEbJM88vI/b7b0QJIHenj4y+18Pv5gIAvU2v1DV/AytZas/RYOHURxuXUn
         AKoCGm6/u6oDWGRXUx34A5qYbXZmOt03bOPsYloj6ZOQC85R0nVRVx5QPJody/xKxyJO
         EyIA==
X-Forwarded-Encrypted: i=1; AJvYcCUZqfKImcHK+zjH+CBDtrCnXxxqmJZi9lP4gFjdVdBCJBoAMGHdp+jQarZoRFvtMyi8t4yJPEIvBQ==@kvack.org
X-Gm-Message-State: AOJu0YyGOioYufpsGIlNfDVCfIoZXCCkC2tGNxNXcRKXAYNZ0YHs6epM
	iNyYe35YgLnZ7Vb7CpofSpvNQ8GqeU8RFpaVjMqKRiBFBTIdmhPJUdq1iQvFmHZxvrJFm/VmGjI
	Lpgehyr2LawwLiyqR+A7F5yNvzS/8XiV/5UfsV+47sWWimyjbUbRD
X-Gm-Gg: ASbGncuwQ529LqeR7rDvJE2ske6UvTnKRidNUgyblW1C+tLiDDmobxILYaT/oYtFPYK
	TDHDcEeXifiuYkVqTxbaJDHZ4Ic1NAkXKPSfUDs3UMomxr/pNbNha74ja6hAs8aVCpMclDXJQSp
	M3IqeCpfaaC1zBPAxPx8XiXj9UN59nYxb3efskxtLeOv6exEHax1wmT9D4NQrOzBnD2raALJJJ4
	0kBYRqNga7CuuOu1kaKxGJi/CzV+hNpLGxba+caqJoycWmsg6MO1eVIblOKMWQYubx4U14eMlj2
	N+trqTYUSyzkKQkpwGUkgQ5mFynIKlPj2ZpjQuuj28kuMirElQ9UqKf2nIupdOR8h3rZjEVMe8m
	QYBHKyYiH6s/3P1BzZ9v/xWR5tDVGSL4QXHTgf9ysSCH3Q9gGNSDAWaKR15lmrd9I3yo=
X-Received: by 2002:a5d:5f45:0:b0:3ca:239:a035 with SMTP id ffacd0b85a97d-3cbb15ca238mr6207346f8f.19.1756371600737;
        Thu, 28 Aug 2025 02:00:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEvwQCgZ8qwfbAqaBgA/aLm0dXyJcnKm4aS+HC66ZpgjjAawtJHBXG0suiuLiXZ7k/g7a1tkQ==
X-Received: by 2002:a5d:5f45:0:b0:3ca:239:a035 with SMTP id ffacd0b85a97d-3cbb15ca238mr6207326f8f.19.1756371600241;
        Thu, 28 Aug 2025 02:00:00 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cc50050c4esm7308849f8f.25.2025.08.28.01.59.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 01:59:59 -0700 (PDT)
Message-ID: <8a0e1bb1-ab6f-4ba0-952f-e540ac5bd55d@redhat.com>
Date: Thu, 28 Aug 2025 10:59:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/memory-failure: fix
 VM_BUG_ON_PAGE(PagePoisoned(page)) when unpoison memory
To: Miaohe Lin <linmiaohe@huawei.com>, akpm@linux-foundation.org
Cc: nao.horiguchi@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250828024618.1744895-1-linmiaohe@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250828024618.1744895-1-linmiaohe@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: k76WbwSALnTlrbR0YCFRriyQkFaieEgv3W6IXpQIoug_1756371601
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 63C93C0007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: t5xje5rshfqzztze5gpmam8r7k4pcisu
X-HE-Tag: 1756371606-698981
X-HE-Meta: U2FsdGVkX18coQ4lOgslKf9O6C4RXHeewiQEjBEx12ZtSDju4N7Yx/hyQxnkpyC7vbE2bFeARURIP7u/w/fjbhuZcJMu6QQkx9JkdKGRJu6CCQMZCq43O4QiTWn2PZjXWRLXZMINjY2K7bLofXCmPb2+iHLDSDXsrWwodUQr2NyqDxorSB2U/k659/FyriBCeJdXdeLWpbkZNU8+UzBgODaqxVUkbxkDfJzTp31rz7mCTmXy59gIH+Myz+TZsAJQ0y/BikhNn3mowe99KZHX/MyoOG6Pfqj7+lu0lS7yrn1F5OtX2Fq7w8pWyVZW2mYN/R8S5FauOqtcN+62hajTnNIWfbZEhQoFoIY/Fp+OC28AOe10lPKIwr4UjYAFEhEQCweB93/EFIA1Yi4E5LIXmPHP15oARgrYnvPoxAKTBwueeOH+TTH9MSa1Qi3ky/5nviJFt9jOHWf5UIZyKSW0b7rQl/NCKpDY0HHPYDDW/36aecv1iYF5OFvmHm8xXZRkdifzngxMcfpwJhU+xnqhulJLKevnKHOaWDVTcBmd1RUg7Wf3CC6b1MD/00eoNEGtXiI9NGXt5FDBfOfcDMdLpJcfyXeCfUVQOwteN55Z8Ee+js3rR7eh/6PVguLU1AuiccwlMtLkmBKHr+hPPzOMlsrUwcawAvDtn7drd0tSajS8a8P/zrvQy7Ro1idHFMm8ksD+riwGS/34Xt2lC7X8PbU64PjKM+qbF6vZK7Q8ikVumvo+vzFmCrpESjsWPYQSgFL5kI1K3ywHwOMqezqG/xX3MaOFmd6aRUU5gv695reYRs+ZW3vMYnYhn5elVTTXoMtWwfI7HS2NWkX0DjLWIBTktHl5kGNsRTNbfyNx9n/ZhwY7UDSpZiPLZLLv4V8h78ZInh2XkoQ4HsUYszlVY2/XaVvEQ2AzqG4YtzfsG59nJC+0+p9Eyb2MIoX2/HBI5ltISEBm38htuswzJOp
 VVmoOqPy
 uSa2S2Vn+r42o1wxHFN5BnCg2JcQz+/3vePHKYyjzO6GWzqz3cFJeGf1P7ChGUCfM+L6GmDwdQSkfXEoy4rbX7D/i0Pajg6/pf2huVDxJgi8Bsz9EP7qgB2OrBfUxW0u7KF/Y9LgVtAB/jzO1zuH3gzU8y3j1lPJniJ2bauCObMSE6dvkPb5bT359Zc3UzpDQgGzQTJt3jdMA43ekxFiJZPl/o/o+izykI7ot1F2iam8Voy7tn5xGCMt+7NhvzBDLO56DxQOSpbjPSb3vUdcwQX/CE/be8XtMqnhych6B9u2q7rKy4iz43Gkd53vdKQ8j+ZE5K0PCUPKmS3o157qKt3/7BK97r7BuX71AONR790RzKSy/McJHhJVbhbacZg8irxL3Ln91N1waTrctKEBeNUMH3o4nhjfEzVQxobBrRUbfX+mc2sPTqDK97ydU8kvvw53RZc2kITKVIpVHA29AZbZbmqovulDHf6fiyJ0P86EGG8S0KgENwHDDBOVBkDswpJgjx+97uJKY2OHO9XbaSQVrJq5KGr9cVH5juFOT6XGb1453tJSlst3IXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 04:46, Miaohe Lin wrote:
> When I did memory failure tests, below panic occurs:
> 
> page dumped because: VM_BUG_ON_PAGE(PagePoisoned(page))
> kernel BUG at include/linux/page-flags.h:616!
> Oops: invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 3 PID: 720 Comm: bash Not tainted 6.10.0-rc1-00195-g148743902568 #40
> RIP: 0010:unpoison_memory+0x2f3/0x590
> RSP: 0018:ffffa57fc8787d60 EFLAGS: 00000246
> RAX: 0000000000000037 RBX: 0000000000000009 RCX: ffff9be25fcdc9c8
> RDX: 0000000000000000 RSI: 0000000000000027 RDI: ffff9be25fcdc9c0
> RBP: 0000000000300000 R08: ffffffffb4956f88 R09: 0000000000009ffb
> R10: 0000000000000284 R11: ffffffffb4926fa0 R12: ffffe6b00c000000
> R13: ffff9bdb453dfd00 R14: 0000000000000000 R15: fffffffffffffffe
> FS:  00007f08f04e4740(0000) GS:ffff9be25fcc0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000564787a30410 CR3: 000000010d4e2000 CR4: 00000000000006f0
> Call Trace:
>   <TASK>
>   unpoison_memory+0x2f3/0x590
>   simple_attr_write_xsigned.constprop.0.isra.0+0xb3/0x110
>   debugfs_attr_write+0x42/0x60
>   full_proxy_write+0x5b/0x80
>   vfs_write+0xd5/0x540
>   ksys_write+0x64/0xe0
>   do_syscall_64+0xb9/0x1d0
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f08f0314887
> RSP: 002b:00007ffece710078 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 00007f08f0314887
> RDX: 0000000000000009 RSI: 0000564787a30410 RDI: 0000000000000001
> RBP: 0000564787a30410 R08: 000000000000fefe R09: 000000007fffffff
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000009
> R13: 00007f08f041b780 R14: 00007f08f0417600 R15: 00007f08f0416a00
>   </TASK>
> Modules linked in: hwpoison_inject
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:unpoison_memory+0x2f3/0x590
> RSP: 0018:ffffa57fc8787d60 EFLAGS: 00000246
> RAX: 0000000000000037 RBX: 0000000000000009 RCX: ffff9be25fcdc9c8
> RDX: 0000000000000000 RSI: 0000000000000027 RDI: ffff9be25fcdc9c0
> RBP: 0000000000300000 R08: ffffffffb4956f88 R09: 0000000000009ffb
> R10: 0000000000000284 R11: ffffffffb4926fa0 R12: ffffe6b00c000000
> R13: ffff9bdb453dfd00 R14: 0000000000000000 R15: fffffffffffffffe
> FS:  00007f08f04e4740(0000) GS:ffff9be25fcc0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000564787a30410 CR3: 000000010d4e2000 CR4: 00000000000006f0
> Kernel panic - not syncing: Fatal exception
> Kernel Offset: 0x31c00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> ---[ end Kernel panic - not syncing: Fatal exception ]---
> 
> The root cause is that unpoison_memory() tries to check the PG_HWPoison
> flags of an uninitialized page. So VM_BUG_ON_PAGE(PagePoisoned(page)) is
> triggered. This can be reproduced by below steps:
> 1.Offline memory block:
>   echo offline > /sys/devices/system/memory/memory12/state
> 2.Get offlined memory pfn:
>   page-types -b n -rlN
> 3.Write pfn to unpoison-pfn
>   echo <pfn> > /sys/kernel/debug/hwpoison/unpoison-pfn
> 
> This scene can be identified by pfn_to_online_page() returning NULL.
> And ZONE_DEVICE pages are never expected, so we can simply fail if
> pfn_to_online_page() == NULL to fix the bug.
> 
> Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


