Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0205CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 08:17:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16587900002; Thu, 11 Sep 2025 04:17:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13CE08E0001; Thu, 11 Sep 2025 04:17:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05486900002; Thu, 11 Sep 2025 04:17:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E528D8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:17:32 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7BA2A160316
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:17:32 +0000 (UTC)
X-FDA: 83876265144.14.2E935E7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2FCDE40003
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:17:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JonPNbwr;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757578650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Ad4RitIlPCzWAHNWtUENRWOS98f9IauUAknhVfFDSI=;
	b=dYdXKLSabvimDmRT7Ow0Gc3/oOKKdpKX28FRRRmLHlUx18CgRfHmGJgACrJVVjXAryOqM1
	JjoeKGUr6JYnBZ4tpdVtTMVHL1oE/UXu/QxGOgAKfvCoo7+v1UZD/0O4X5A0rmvv587SKx
	cdm0Pd2o7mAXHi8ZxYc5H0VRGC/rMi0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757578650; a=rsa-sha256;
	cv=none;
	b=d0MYoHyfNmdX3XgUmaAwyik07sfA8/7tksJGlkj98xdXgYFjzi1/+nFG3jiO2Ai9yPnR/2
	kIrXselhnoqOurnNj4XJNd+bacZT0uY4TBJjDSB7HZCKA1luxUgP2toFN5W87pHZBqAD6a
	X3YzzfAyzoLbi3uOmOpdxI0FmzQuWuQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JonPNbwr;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757578649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/Ad4RitIlPCzWAHNWtUENRWOS98f9IauUAknhVfFDSI=;
	b=JonPNbwrWZehl3ZXd2Fu0hwsdXfXqTyM+QmILqO+6guKbeKbuqKhi9sX3BdVBU7m5sFiUR
	FkQZMjLFt9DBjIvgxM90ymfRYw+B0tI3MU9/0UazrEW+K7aA4wYXBMrEpgXoBy0Vjd4qgA
	eP4z8ZQaoDN/esCKn5NtMfY2s77QfiU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-koXDSCAxMQOa0XxzuqB-hg-1; Thu, 11 Sep 2025 04:17:28 -0400
X-MC-Unique: koXDSCAxMQOa0XxzuqB-hg-1
X-Mimecast-MFC-AGG-ID: koXDSCAxMQOa0XxzuqB-hg_1757578647
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45dd66e1971so3890575e9.2
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 01:17:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757578647; x=1758183447;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Ad4RitIlPCzWAHNWtUENRWOS98f9IauUAknhVfFDSI=;
        b=FQ1XfO7K616Wt3fHsPLlVDEdTsvOfsNEZmErAU2wWAHfIZrNhDG9pkOVCncY9KC6Ey
         cf1VwR4vhIeCUrEh1C3XKNGFheYGDrXNi1CbBchLiwrw7DgNA80X8ZoHiHa3C/ALVXSB
         aYAvNe/JfeYh5OUZ2dfZ+O40o0H09HyGH3cOHjbsBW4fZKnZScoZRbUxcX3tF32+v+Ao
         7BDze7qFfut16MDcAbNbRHmKI+TD4aaVnaBPnYjOjqxVpGCItGwt4czvJD6dN0qwD+PV
         8snJeZtEjuBM60cmLX20Gt4H+HPZ6YnDeS/XSID5Hx3DOLH+XCAVN2lNHKjUw/4Gqvdt
         Wv5A==
X-Forwarded-Encrypted: i=1; AJvYcCX0dVW5sncc5WLMi5qbffIIqums/2HYmOjSdcBI4qqMCYGs9ScvORXXQ44Viex2Rla/1uAod4Cdsg==@kvack.org
X-Gm-Message-State: AOJu0Ywqvcyq+FAh1ZE7zEhlC+UAVDLlgZ91XLgMEuZEnFm40zW0RKRY
	4ifNlumbJYZC7Bg9++neemaXSgYD/zpCQcOf262WV1TBOR2o4ITB87cScFVbLxVLDsCZ4vf7Zt7
	ecxXmBClnAmwzbAmKwKs3NFFR0Ujbv+/10YV5XAnhaqS9BpDJAcxC
X-Gm-Gg: ASbGnctszQDolsgZZFENhoy4iQfsEnGLy72e4lyNIiyeM5fyIqb5E0jyI5fULxICF85
	Z2tSmZSITpOBgYiieV0Bj/0ypf5IF5B0kWffR+bqDepiNw/XxlqMS2zU3kJcUTr0NM2OxFKJ4gg
	dOmMsq5kdalbAz9inG4vsENHhYCKSHdRa2p9ib4dxalaWSoUneYvkK1nWJJ+Oo0hp5wu8TBKZUn
	pe+HS3lNYSLyiswVzL4zFVYn0io0JmtxtdeBmFYIxnDquq3guhavAKxozFh4jg8ZhgeFNQecN1v
	Cdym6Ixitze5MPnUfTk7ZcqaH92iutKo0ZdngQCpkIJeNub4Q9JcB3oOgGfjo3c2YYvxBTgeNy8
	pez+th9+4sCRqndKj3wkX6FEMxbNhTrU4pO2Dgt3OetmU91dIMF61hXOjlqYP7uqCjGA=
X-Received: by 2002:a05:600c:4e14:b0:45b:86ee:415f with SMTP id 5b1f17b1804b1-45ddde8a741mr192478575e9.6.1757578646710;
        Thu, 11 Sep 2025 01:17:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFSRVxSfASwnKAAMpCKLh03FTQFpe6kLNAVJ0k/oKJQ1NfZbCDMlSF+qLrVbq3VUgGgugW5bw==
X-Received: by 2002:a05:600c:4e14:b0:45b:86ee:415f with SMTP id 5b1f17b1804b1-45ddde8a741mr192478245e9.6.1757578646277;
        Thu, 11 Sep 2025 01:17:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f42:b000:db8b:7655:f60f:812b? (p200300d82f42b000db8b7655f60f812b.dip0.t-ipconnect.de. [2003:d8:2f42:b000:db8b:7655:f60f:812b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607870cfsm1513658f8f.19.2025.09.11.01.17.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 01:17:25 -0700 (PDT)
Message-ID: <bfeb8af7-62d3-4dc6-903c-b6697c5ef795@redhat.com>
Date: Thu, 11 Sep 2025 10:17:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/hugetlb: fix copy_hugetlb_page_range() to use
 ->pt_share_count
To: Jane Chu <jane.chu@oracle.com>, harry.yoo@oracle.com, osalvador@suse.de,
 liushixin2@huawei.com, muchun.song@linux.dev, akpm@linux-foundation.org,
 jannh@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250910192730.635688-1-jane.chu@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250910192730.635688-1-jane.chu@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _LY_fJIu8Xudb7OShn_rf46airS6fLd6kvnxOL0v5gI_1757578647
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2FCDE40003
X-Stat-Signature: 4pqtb9dk1qe9karm51a4697if19bzf45
X-Rspam-User: 
X-HE-Tag: 1757578650-792001
X-HE-Meta: U2FsdGVkX18JubRWuQeuEuIjhq7N1bDx9zqfdXs/5NxPSinfPd92lta1+SJdY7TKPEYTtDnBbb7khiEAGUnoarDSdXdM9wtkuxRIyOTnz83sCP00kruQXA2ygjknpaqTA0yuAjL8quoqqgqm6MVVYd4vhMD9oIxK2PJoFWGRYcNfZ1MQThofU/jhlCTPRDm1QgvVxIVgM4i4fxrqpZGylZh+qS6Ti/bHUZcWh6ffWUOqdzaUs7mUmLsUhRQ/FxQ6vybC4FvUMcumiIyxmLKTldhv4lGumDo/AyA9U4o0ddqSZ8v3l99EpdLor36aZoTPjZCwJLqmW5xEXDYLt0tIhpfMElHAUflZX7TB6rK4ddP7WLsVBqN/vL593WaQKEk70gxXMc0kWj9bzt6gP3lyjX63nSUjjof4TueaNQcfqdw6hxlb9LRfzwqD7H2Kzrz1QtfBfvwqDrVluAuhBikbu2dBjNfNCRRoRzB+QN7xwsgRsJKxXhE+vf2uZ8FjhbISrG9QersfF3so6AlG+nsh0NQK6oytwQRHdj4ZG9j/1hEnLW2CLLwWG/F21dDMkLuDnhMYyvBDnLhlnh+Q/Fv0AO37dGexovjq9rXM1T5JGogbyqVuIrACJPASAcQuOgbi2Layqum/77x+RL+UREtc8OsjO0G71s/6h2/PrBg4rO33L/wzFLK3r1str4ZToxyVU5B+BGEgd3dQBlyQPLL5iqjfaRBRD7LD0Vu9qeRHEnlHrX7N9hxudYbkGciEnXr8bZJWO6NLwC5kZzBTfh2wvuQgeecnmCW9JDXDUL8tBST9k0n5DCCQTUaxPW06M/nmtYnKeE3DnsM9AeoOmZj9lbbzhOWUrZcaW9rizBp8SBFuJ1YHAJmF6g4SCKYBXdClX55RQMz2ASjAd7DO49A0IXPzjQbzIrZWTNU3o1Nk7AyDqMDv8GEtpTCVGHCnM2/M58ZWvGLrVmbPEiU8Q1e
 DObRra+5
 3O2d8/8EuIc4dpAMWRXEQT9ON+zM2xmCbKhqWK4J+EZY2LS3+gLd9JugzNWpXuqxRs4dE7oIJNrzACoKznIgUPeEGt/SB3HSqhaXA+Wz4cjgPMc8wDHJ2EcKwsbQPldktTAKDSLS4kHupbA1yoYirq+HFHszfKoAqgez438BKS0v0Il0LwmdQQ+UY2YQc37rfpcakJxnjafstY8o/baT6QvflTxaf1/FE/b++wdP0sD5lwxWiFG1yMrADvtJ1XiAurQhVWwolBA9LeW0W1U89a0FpkRqyFXyQygGfMdwWUK0HDMlBvEljoBDP1+HaP2+Rai4d2NdHDgkvOypMC9m7kJTK2kcVSyBNZ0MIO1JFgD3NyCfRos7lXaYL9qb9IEzRme4ezdNeF1eaVL3XGGYEwu7iiFSfAyqejhvtNQUbEqxLyAtn7n8JUBUzd+FVwveyTD/ZmNsuxzFCaUNpeAEMvcJ+Hrn2ddsypPjwbNp8tiStQoQ0Uac+D8jMRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.09.25 21:27, Jane Chu wrote:
> commit 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared count")
> introduced ->pt_share_count dedicated to hugetlb PMD share count tracking,
> but omitted fixing copy_hugetlb_page_range(), leaving the function relying on
> page_count() for tracking that no longer works.
> 
> When lazy page table copy for hugetlb is disabled, that is, revert
> commit bcd51a3c679d ("hugetlb: lazy page table copies in fork()")
> fork()'ing with hugetlb PMD sharing quickly lockup -
> 
> [  239.446559] watchdog: BUG: soft lockup - CPU#75 stuck for 27s!
> [  239.446611] RIP: 0010:native_queued_spin_lock_slowpath+0x7e/0x2e0
> [  239.446631] Call Trace:
> [  239.446633]  <TASK>
> [  239.446636]  _raw_spin_lock+0x3f/0x60
> [  239.446639]  copy_hugetlb_page_range+0x258/0xb50
> [  239.446645]  copy_page_range+0x22b/0x2c0
> [  239.446651]  dup_mmap+0x3e2/0x770
> [  239.446654]  dup_mm.constprop.0+0x5e/0x230
> [  239.446657]  copy_process+0xd17/0x1760
> [  239.446660]  kernel_clone+0xc0/0x3e0
> [  239.446661]  __do_sys_clone+0x65/0xa0
> [  239.446664]  do_syscall_64+0x82/0x930
> [  239.446668]  ? count_memcg_events+0xd2/0x190
> [  239.446671]  ? syscall_trace_enter+0x14e/0x1f0
> [  239.446676]  ? syscall_exit_work+0x118/0x150
> [  239.446677]  ? arch_exit_to_user_mode_prepare.constprop.0+0x9/0xb0
> [  239.446681]  ? clear_bhb_loop+0x30/0x80
> [  239.446684]  ? clear_bhb_loop+0x30/0x80
> [  239.446686]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> There are two options to resolve the potential latent issue:
>    1. warn against PMD sharing in copy_hugetlb_page_range(),
>    2. fix it.
> This patch opts for the second option.
> 
> Fixes: 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared count")
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>   mm/hugetlb.c | 13 ++++---------
>   1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 753f99b4c718..8ca5b4f7805f 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5594,18 +5594,13 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
>   			break;
>   		}
>   
> -		/*
> -		 * If the pagetables are shared don't copy or take references.
> -		 *
> -		 * dst_pte == src_pte is the common case of src/dest sharing.
> -		 * However, src could have 'unshared' and dst shares with
> -		 * another vma. So page_count of ptep page is checked instead
> -		 * to reliably determine whether pte is shared.
> -		 */

I think you ignored my question to v1 regarding the change of comment.

-- 
Cheers

David / dhildenb


