Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43D8BCAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 18:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 616CA8E0002; Thu, 11 Sep 2025 14:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EDB68E0001; Thu, 11 Sep 2025 14:50:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B54C8E0002; Thu, 11 Sep 2025 14:50:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 386058E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 14:50:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8AB1C0590
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 18:50:48 +0000 (UTC)
X-FDA: 83877860976.18.21A6879
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5660F40018
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 18:50:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UPCHQTCA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757616646; a=rsa-sha256;
	cv=none;
	b=iH8wTcqQVfeoTscxxz/YbHM0zFkW05TItz4lF1ebFDkyqBzkQ4VRRtDCIbqBmAMVLPh06u
	66qd+BS9xyZcXvBVXiiMfMWskiAgvq1Ob/6mpPgV0Jwk1SMSku4HdmpIpanFqV4TPl2fdx
	x2JZv8P2pT7zMTY8wR3oZnhJEYF3cdY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UPCHQTCA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757616646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=75rXashiaKSypPE7yXVIqcKrMNGsZ586vqRO26aajTA=;
	b=cOuFybrjnJFa9wtvFFgdpuFwJTlJUn/pViFJvjsWcp/CCM5b+bGUBSNrXt4xf2q1+4DvEe
	6X+EexwFR7GBD0AZhp0UWyCipKATHtCSKUaKkmZnKM8pzX1zYBKYN1JSwDJi/tYBJYmRPg
	+63qlvoSqGjlDyPwBRboHYYRpfGXPx0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757616645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=75rXashiaKSypPE7yXVIqcKrMNGsZ586vqRO26aajTA=;
	b=UPCHQTCALxcOwwNGaFS/lpmEOkR2j5Ol745YVNvZMeoUeySzrWD7j6qn31vOlD323OTXUW
	WJd3cgeZ35opT3K8rzNNkspls4O0NwaFStqWlKfygjQgzcCMH6JrD9g2G9c212PnErJ3KM
	yDLHPo8cn7XPaAMDkHqG3VRlEbl/SLE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-49-QmXO_TPvNTyrpl26d2u-1Q-1; Thu, 11 Sep 2025 14:50:44 -0400
X-MC-Unique: QmXO_TPvNTyrpl26d2u-1Q-1
X-Mimecast-MFC-AGG-ID: QmXO_TPvNTyrpl26d2u-1Q_1757616643
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3e68a54dac2so496675f8f.1
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:50:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757616643; x=1758221443;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=75rXashiaKSypPE7yXVIqcKrMNGsZ586vqRO26aajTA=;
        b=hey2Q7nyGqMrqol3gvFIowMN4EKSwmkg7VC42Ne2ALa0IXvoo4xp+j643aCAvQWuBl
         yf3KpWlNWrYYw00/YsTdACsFPu9pp73DkC4UoryMNzG26+KLe6OSsL+PzGeTDXGYWgOT
         kA0Y+oOprbvUqxyN0yUHkiuxuriclCTSVoexZLEiewOK4kPPqkL2Tt71/9JWgXwqUhI0
         Swy7MgESFkH5jYU04oEsRjz8MXQ5zWmhJPMA9THMyG9htYwUI+o0+s25Le+feVx0UgBP
         8JQA/M8QoROHO2vbSYs/3Q878lqApmWLO+SyxEyBIih+zmRAskVh2CoHyAF6/8O1YFAq
         ahnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEE0aeW1uSzBqNJIxIncldh6Yau313o15LtxbMpeSm4ca6lup+yyKyl5Wm3foPLL3Z21bfo0LsPQ==@kvack.org
X-Gm-Message-State: AOJu0Yycd3Nu/f0GYNlMP1DWTS1TUWjdF2mNnT4k5teuTkunEB2sloG/
	xEayYQ8+l5j6EYHlss/3wsAcrx7YGFgBdCQdSl19JXfKJHuXFYm+4tvm/B4lnC5DWAkhBwvQU97
	ggVRR772OlgVa83dhAMLa8Adjlmi2zpquhKF727qWb0LBWZbhHz8Z
X-Gm-Gg: ASbGncszfp3tJF8vJDePAj7W6McjqZd/563Xg9XInUr7u5ChLXQxv5/eyUi+dE4HIYQ
	CWAgoNfox3OJFhlMfi82VKIuD7TWHtEw3aJtgPddq4XRadxY0SbOJOnrgUlKPwgFrvoy1LUxjW8
	9zLeXNvMqrwt5QMOYeJz0osNW5nQM6cXE0M485WWtjfN6fXHWKzn9ioHEdVmE43RD9SbD5tOOHE
	IyFvKOnSc98kCgAKfuepihlsBa3cBRb3qwcHBrjUj58FWc84kc7Vdl605eI4ux3/xHBL2hBAJqP
	JmDHi1luvRyuhqtzpMofpOw69B8PURvzb9Kxdp0dqR4c/v05kN/YhhdbTrgZXEWeWawFOKCsY6U
	M5Iu84pgQOOCPcLtAAZroq6mHargtRR2d7kbfAKV5dhfl+KrXm8z+YLqZUgK8c/reqpw=
X-Received: by 2002:a5d:64e9:0:b0:3e2:3717:cce5 with SMTP id ffacd0b85a97d-3e75e16b341mr3701775f8f.30.1757616642963;
        Thu, 11 Sep 2025 11:50:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIa5vhuiI1ykuJSwXQKeFBJi+2181WGO35nRF69Fl/mSTSWBEjbLZZ8kV1vJ8X+ThIJ6dl3Q==
X-Received: by 2002:a5d:64e9:0:b0:3e2:3717:cce5 with SMTP id ffacd0b85a97d-3e75e16b341mr3701754f8f.30.1757616642485;
        Thu, 11 Sep 2025 11:50:42 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f42:b000:db8b:7655:f60f:812b? (p200300d82f42b000db8b7655f60f812b.dip0.t-ipconnect.de. [2003:d8:2f42:b000:db8b:7655:f60f:812b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607ccf93sm3506371f8f.38.2025.09.11.11.50.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 11:50:41 -0700 (PDT)
Message-ID: <0ab2cb14-ba8e-4436-b03d-9457137f492a@redhat.com>
Date: Thu, 11 Sep 2025 20:50:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] resource: Improve child resource handling in
 release_mem_region_adjustable()
To: Sumanth Korikkar <sumanthk@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>
Cc: linux-s390@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
References: <20250911140004.2241566-1-sumanthk@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250911140004.2241566-1-sumanthk@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: G9W9-R3LzAoicEq7DZEgzsi4w06v0SUmUguWVmucp2U_1757616643
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5660F40018
X-Stat-Signature: zd76dsum3ew8p4rcj7c5oumiizxs68sz
X-Rspam-User: 
X-HE-Tag: 1757616646-368111
X-HE-Meta: U2FsdGVkX19vHWBwW8hUhtCHLi4DeRHfa2S7eua7tdzfSSQhRJtEnaNVpFdV0JeqvHhCzpzXF+Rzguh3pDuLI8D/GMDTzx28rtvmgPkyGy93H7rSHGwxpqtDLf32N+ddtcE4PQiQu20MGvcLaE0VBG0KqL+6dAAUChDxRzx68aYAgzxBrSUvPqTNJYFy5f2RfklmeLAb/8wimIWMGbeLpXUfWQO9aPiq4efxgtphmarb6EpFH+Ok6DJlPuBmONCsgbIP3XhfjWSUm//bmu+4rSIiN7PDIbctn9BQIyldGojo82tCsOAEliQ1XoLcnoSqhSN6PvEhmmatG70itigTNB7drjF4i3i+azOzGuEWQtMzGXg85vLbuJXumdHWhiWgjTSBlpR3J4EaivPTzytTDry5ov6ti0P21+WeGpgezDXbOfbhRz2jVMjOt3+7+cAqqPZKMuDuEsClrm/FWusvXaS6cjVNsw778QlthYdxdqFzNxBsnLqH86VxnFKaKZP1fnqO1RDvWtlcCjaBHHOHYBE4rVO5HzTVqSIojkwfOvR2ZHLFdqHD+VHlcGx/1PdKEh4d80XNL/+emhMBT2GNroC3qUui+hzDVNezkM/0MQPGBzPOpNtNf0ml1h3ZIl3XigX6/3vrwoxRLlFBUyQuXdyXo+oa1fpSdO1OV58wZQturv5DEcE64P6RRDTEiDv1IwnaSL9hQp91NvyQ9seIEy0n7mw/tSquWe/uT9fJvTgTTQkgAMYPlqSeWcI3YkVEAuTg/o1v18Yz8SUsLpMtLc9mdJtAbfFmEOXMYzgfQySYe+PsWetoOX3sw2taCB2abEC1Au02i07lfGsMqH3fOZzk9l8u0Xti+TStvcHjIhegW9Z6WaagHRk07MfGXMyigq3w4ScK3WpYnd5IapNFL3+nbePZnIprfsGC6z8tNQYnHPGowoD4Ww0YstKhgWBZWTWThJHMXIe7tsN2rm+
 J7t4VSMO
 a1guFHkWba4dZRFZ/LAJBHws1CMLyopDReo48OLXYoW8dLZhrtf3l+lgeIPqMScKmOUFNbP4libnH5igLc1J/UbC5mNn+a92N4TpbP3vj8yoqasrV6Bk6wgtj4kHVAT1BKCNls1XsXf4ykBQjxpV4uRZef+kZtSVb7wGALgGBlg+mxB8OwNmHZQaRakbJx9nU/lnuNHlNnQaWzYZfDS4+n56D6UvwAee9KMw0gHC2D49J5LjfpRGMv/z3rnOLm659BsSg6Qx4Q+bMCU5Uj+5H/k8LKvFGXYOhIaMTPjvI2922IwErDZqgRTjaJdQ0cJlO5e9W6s1dkWfvJj0qSu9Bd6Kn3OoTAtIkA8e/vShrkCD4lYz58fJXoOHwLQPHtlvRYVMinxBq+tIK5tPf3zfP9twcaZ7lf9TVO3dc9fXfXooCngeUgNboLAuSKxdV4SLYDDqCtxzR1a9DEj3I4Zz6tR0XRU3RDpHL8X2z4llR7LwJzrczkc9KJJFGUi/HvZCxiWPa8woEqHowho9AkLu6EXObQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.09.25 16:00, Sumanth Korikkar wrote:

Hi,

> When memory block is removed via try_remove_memory(), it eventually
> reaches release_mem_region_adjustable(). The current implementation
> assumes that when a busy memory resource is split into two, all child
> resources remain in the lower address range.
> 
> This simplification causes problems when child resources actually belong
> to the upper split. For example:
> 
> * Initial memory layout:
> lsmem
> RANGE                                 SIZE   STATE REMOVABLE  BLOCK
> 0x0000000000000000-0x00000002ffffffff  12G  online       yes   0-95
> 
> * /proc/iomem
> 00000000-2dfefffff : System RAM
>    158834000-1597b3fff : Kernel code
>    1597b4000-159f50fff : Kernel data
>    15a13c000-15a218fff : Kernel bss
> 2dff00000-2ffefffff : Crash kernel
> 2fff00000-2ffffffff : System RAM
> 
> * After offlining and removing range
>    0x150000000-0x157ffffff
> lsmem
> RANGE                                  SIZE   STATE REMOVABLE  BLOCK
> 0x0000000000000000-0x000000014fffffff  5.3G  online       yes   0-41
> 0x0000000150000000-0x0000000157ffffff  128M offline               42
> 0x0000000158000000-0x00000002ffffffff  6.6G  online       yes  43-95
> 

First of all

1) How are you triggering this :)

2) Why do you say "and removing the range" when it's still listed in 
lsmem output.

lsmem will only list present memory block devices. So if it's still 
listed there, nothing was removed. Or is that prior to actually removing it.


Is this some powerpc dlpar use case?

> The iomem resource gets split into two entries, but kernel code, kernel
> data, and kernel bss remain attached to the lower resource [0–5376M]
> instead of the correct upper resource [5504M–12288M].

Yes.

> 
> As a result, WARN_ON() triggers in release_mem_region_adjustable()
> ("Usecase: split into two entries - we need a new resource")
> ------------[ cut here ]------------
> WARNING: CPU: 5 PID: 858 at kernel/resource.c:1486
> release_mem_region_adjustable+0x210/0x280
> Modules linked in:
> CPU: 5 UID: 0 PID: 858 Comm: chmem Not tainted 6.17.0-rc2-11707-g2c36aaf3ba4e
> Hardware name: IBM 3906 M04 704 (z/VM 7.3.0)
> Krnl PSW : 0704d00180000000 0000024ec0dae0e4
>             (release_mem_region_adjustable+0x214/0x280)
>             R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0 RI:0 EA:3
> Krnl GPRS: 0000000000000000 00000002ffffafc0 fffffffffffffff0 0000000000000000
>             000000014fffffff 0000024ec2257608 0000000000000000 0000024ec2301758
>             0000024ec22680d0 00000000902c9140 0000000150000000 00000002ffffafc0
>             000003ffa61d8d18 0000024ec21fb478 0000024ec0dae014 000001cec194fbb0
> Krnl Code: 0000024ec0dae0d8: af000000            mc      0,0
>             0000024ec0dae0dc: a7f4ffc1            brc     15,0000024ec0dae05e
>            #0000024ec0dae0e0: af000000            mc      0,0
>            >0000024ec0dae0e4: a5defffd            llilh   %r13,65533
>             0000024ec0dae0e8: c04000c6064c        larl    %r4,0000024ec266ed80
>             0000024ec0dae0ee: eb1d400000f8        laa     %r1,%r13,0(%r4)
>             0000024ec0dae0f4: 07e0                bcr     14,%r0
>             0000024ec0dae0f6: a7f4ffc0            brc     15,0000024ec0dae076
> Call Trace:
>   [<0000024ec0dae0e4>] release_mem_region_adjustable+0x214/0x280
> ([<0000024ec0dadf3c>] release_mem_region_adjustable+0x6c/0x280)
>   [<0000024ec10a2130>] try_remove_memory+0x100/0x140
>   [<0000024ec10a4052>] __remove_memory+0x22/0x40
>   [<0000024ec18890f6>] config_mblock_store+0x326/0x3e0
>   [<0000024ec11f7056>] kernfs_fop_write_iter+0x136/0x210
>   [<0000024ec1121e86>] vfs_write+0x236/0x3c0
>   [<0000024ec11221b8>] ksys_write+0x78/0x110
>   [<0000024ec1b6bfbe>] __do_syscall+0x12e/0x350
>   [<0000024ec1b782ce>] system_call+0x6e/0x90
> Last Breaking-Event-Address:
>   [<0000024ec0dae014>] release_mem_region_adjustable+0x144/0x280
> ---[ end trace 0000000000000000 ]---
> 
> Also, resource adjustment doesn't happen and stale resources still cover
> [0-12288M].  Later, memory re-add fails in register_memory_resource()
> with -EBUSY.
> 
> i.e: /proc/iomem is still:
> 00000000-2dfefffff : System RAM
>    158834000-1597b3fff : Kernel code
>    1597b4000-159f50fff : Kernel data
>    15a13c000-15a218fff : Kernel bss
> 2dff00000-2ffefffff : Crash kernel
> 2fff00000-2ffffffff : System RAM
> 
> Enhance release_mem_region_adjustable() to reassign child resources
> to the correct parent after a split. Children are now assigned based on
> their actual range: If they fall within the lower split, keep them in
> the lower parent. If they fall within the upper split, move them to the
> upper parent.
> 
> Kernel code/data/bss regions are not offlined, so they will always
> reside entirely within one parent and never span across both.

Yes.

> 
> Output after the enhancement:
> * Initial state /proc/iomem (before removal of memory block):
> 00000000-2dfefffff : System RAM
>    1f94f8000-1fa477fff : Kernel code
>    1fa478000-1fac14fff : Kernel data
>    1fae00000-1faedcfff : Kernel bss
> 2dff00000-2ffefffff : Crash kernel
> 2fff00000-2ffffffff : System RAM
> 
> * Offline and remove 0x1e8000000-0x1efffffff memory range
> * /proc/iomem
> 00000000-1e7ffffff : System RAM
> 1f0000000-2dfefffff : System RAM
>    1f94f8000-1fa477fff : Kernel code
>    1fa478000-1fac14fff : Kernel data
>    1fae00000-1faedcfff : Kernel bss
> 2dff00000-2ffefffff : Crash kernel
> 2fff00000-2ffffffff : System RAM
> 

Do we need a Fixes: and CC stable?

> Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
> ---
>   kernel/resource.c | 44 +++++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 39 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/resource.c b/kernel/resource.c
> index f9bb5481501a..c329b8a4aa2f 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -1388,6 +1388,41 @@ void __release_region(struct resource *parent, resource_size_t start,
>   EXPORT_SYMBOL(__release_region);
>   
>   #ifdef CONFIG_MEMORY_HOTREMOVE
> +static void append_child_to_parent(struct resource *new_parent, struct resource *new_child)
> +{
> +	struct resource *child;
> +
> +	child = new_parent->child;
> +	if (child) {
> +		while (child->sibling)
> +			child = child->sibling;
> +		child->sibling = new_child;

Shouldn't we take care of the address ordering here? I guess this works 
because we process them in left-to-right (lowest-to-highest) address.

> +	} else {
> +		new_parent->child = new_child;
> +	}
> +	new_child->parent = new_parent;
> +	new_child->sibling = NULL;
> +}
> +
> +static void move_children_to_parent(struct resource *old_parent,
> +				    struct resource *new_parent,
> +				    resource_size_t split_addr)

I'd call this "reparent_child_resources". But actually the function is 
weird. Because you only reparents some resources from old to now.

Two questions:

a) Is split_addr really required. Couldn't we derive that from "old_parent"

b) Could we somehow make it clearer (variable names etc) that we are 
only reparenting from "left" to "right" (maybe we can find better names).

Something like

/*
  * Reparent all child resources that no longer belong to "low" after
  * a split to "high". Note that "high" does not have any children,
  * because "low" is the adjusted original resource and "high" is a new
  * resource.
  */
static void reparent_children_after_split(struct resource *low,
		struct resource *high)

Again, maybe we can find better names for left/right low/high.

[...]

>    *
>    * Note:
>    * - Additional release conditions, such as overlapping region, can be
>    *   supported after they are confirmed as valid cases.
> - * - When a busy memory resource gets split into two entries, the code
> - *   assumes that all children remain in the lower address entry for
> - *   simplicity.  Enhance this logic when necessary.
> + * - When a busy memory resource gets split into two entries, its children is

s/is/are/

> + *   reassigned to the correct parent based on their range. If a child memory
> + *   resource overlaps with more than one parent, enhance the logic as needed.
>    */
>   void release_mem_region_adjustable(resource_size_t start, resource_size_t size)
>   {
> @@ -1482,6 +1515,7 @@ void release_mem_region_adjustable(resource_size_t start, resource_size_t size)
>   			new_res->parent = res->parent;
>   			new_res->sibling = res->sibling;
>   			new_res->child = NULL;
> +			move_children_to_parent(res, new_res, end);
>   
>   			if (WARN_ON_ONCE(__adjust_resource(res, res->start,
>   							   start - res->start)))


-- 
Cheers

David / dhildenb


