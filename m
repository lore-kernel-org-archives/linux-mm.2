Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8DA5CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 14:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27B948E000C; Wed,  1 Oct 2025 10:06:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2533A8E0002; Wed,  1 Oct 2025 10:06:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 142378E000C; Wed,  1 Oct 2025 10:06:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 02A778E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 10:06:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A46A4160AC5
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 14:06:17 +0000 (UTC)
X-FDA: 83949719994.09.08F5391
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4C3E310001D
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 14:06:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RUNnrhEx;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759327575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+JjFA8L7VJ9DW4AhzP29s4DyZi7y9MtKLl72xa433K0=;
	b=K7eDr90ulpZ/pDrc5tvhszuJcp5GvHQ4ax5D0UcmSA70YbEEXSEZYrjsgAIe257F7e+gwI
	odSH7bKqa0YaIQUhGyasHCDSid/kFKmt1u0z/6IjftS3UhCmuhor5oGn4uj+xDoAMio9Ue
	ggTah+/eeij5rpMTZ/CtzWN7i695YwU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RUNnrhEx;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759327575; a=rsa-sha256;
	cv=none;
	b=mSgoQpiTl87DQpdCNLWoCtMYru/Kp7i6UoFS4IvW+JPwiwWlQ+FvQzV2Db1AamcWNDjrpr
	c+3LQlzm3Ha68cO7H8MwVeKAKjSbPOwO4/g4E3m6JNRI2yqyK64tM9A890XQdH2IffJKdl
	9DhzyoF9P+ELze73BUYa1Ji1+yw+X/I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759327574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+JjFA8L7VJ9DW4AhzP29s4DyZi7y9MtKLl72xa433K0=;
	b=RUNnrhEx3tQwt14Qs/TrjamWfQKZU9oVfNgH+GO7ABh1DOIrhgvKfN+LZFqHafZqHQs6UX
	HgzPBsFfY78mtWmmfrVvFCEx9NdgAjlrqSzwfP9nQCcbl5N+i3JPa7e1HROXTGRoJlCNh/
	XPRFqCn4qshd9S16mNdayJYxLHSTsKg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-28-6uq1RboQMJq1k6RUA491tA-1; Wed, 01 Oct 2025 10:06:13 -0400
X-MC-Unique: 6uq1RboQMJq1k6RUA491tA-1
X-Mimecast-MFC-AGG-ID: 6uq1RboQMJq1k6RUA491tA_1759327572
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ee1317b132so5687066f8f.0
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 07:06:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759327572; x=1759932372;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+JjFA8L7VJ9DW4AhzP29s4DyZi7y9MtKLl72xa433K0=;
        b=E4CXJct0wG3l/299u0dNgYVfSqxwKg1wbapd8U+a29I0t0HsUlVKbSRbC1ONLIrGxW
         c/xzheV3CdDLGgUwmbxNjSIGmFpH92GZ8mUqF/4AxMVYf5Jt+GgsRm8bCEvPcAfcn9FL
         mNcooxnju2xvRkGWAIjLmPJC3iK/GBM8DjhiSgh/meB28LGxDIBtxj76zyMAdZn2Ol/A
         4ISpp/yGbjimrZzwpmgsA71lz5V5l2mZluiN26/pOiNZOhBT24ehrHuvZOROmD7luBPI
         Vdxh8UfqT//kylQ2w6IAwuokvFyVVRtj5+c0rbnm0obBkGM9hRuLG3f//a+rcctg7sMY
         RIRw==
X-Forwarded-Encrypted: i=1; AJvYcCX0ZcEF/JaXjZdihBWj6jHkIvpSubCsPRQso/TqXsW61uIBKGwfBDmTxQjaL3NwSFuHa96QNiLBiw==@kvack.org
X-Gm-Message-State: AOJu0YwWWC/HykvCApv0IzeNNEwVv5acrczLJI+xR0pdL+KLrMyeiSck
	ren/z9Ue928sjtrmN+YGGwLBSmnBZm7dhXEs1xH0w5Y3dg6n+60zw4v9vLGiog/EyEWw0Bv5had
	o62SGLlaGnuCFyByiVRP0kxg/JSplfX/vPdf3G/5dlldnFzs6N/n2
X-Gm-Gg: ASbGncv7e/YLT6DCa6fuWKX+XYJHfAbw8liGmeBBiikURjDshniFXptf4bxHxrHdo6u
	GLzJYC4pKWsfqZaXIc/iV7p46GQ5TyBYwqmrwYxYj2vYUofuCK7BayX8drTjZaaNG1XNWK84Yq7
	Xn5J6huROZUrW691E7l7sVgFRwFO5Wf7QghCQN/tCj6aZZxIB9ILY49joI3L8blFtNVHVQHLaP0
	f2hWLp3WHZu2LuLSJQhoBQ8JgpydeF1pVCbD8Z9zyPoMPLpOhyj1JH7KxdPjzDycA25392DWN9J
	LZru7Su5KT7ZN+JibihzAFrsLsIkzM0gkKKGNCOy15Qx3o9VOJDr9Vw3bBglF1ocXsreapXV56N
	uJyfXlNav
X-Received: by 2002:a05:600c:45d0:b0:45c:b6fa:352e with SMTP id 5b1f17b1804b1-46e612bc7f7mr29175205e9.18.1759327572103;
        Wed, 01 Oct 2025 07:06:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFB6BiumaTojBiz3Df4vGWwSD12NjYRd7DhTnsqEdJQlY3WRU8bYOQe+jJ2eqHmu3GbYlW5bw==
X-Received: by 2002:a05:600c:45d0:b0:45c:b6fa:352e with SMTP id 5b1f17b1804b1-46e612bc7f7mr29174765e9.18.1759327571568;
        Wed, 01 Oct 2025 07:06:11 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e6199f17asm41088775e9.6.2025.10.01.07.06.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 07:06:10 -0700 (PDT)
Message-ID: <02391468-5249-4640-b96e-76eb99b792ae@redhat.com>
Date: Wed, 1 Oct 2025 16:06:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm/ksm: fix flag-dropping behavior in ksm_madvise
To: Jakub Acs <acsjakub@amazon.de>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
 peterx@redhat.com, axelrasmussen@google.com, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20251001090353.57523-1-acsjakub@amazon.de>
 <20251001090353.57523-2-acsjakub@amazon.de>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251001090353.57523-2-acsjakub@amazon.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eYJH1996IJdfg49XbFWtEFS79YY4HJRud0fiSFMz2jY_1759327572
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mgh5wgc3739wr5st3tgy8zeom6urihch
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C3E310001D
X-Rspamd-Server: rspam04
X-HE-Tag: 1759327575-572501
X-HE-Meta: U2FsdGVkX19Wwiuq6EJfMdv+UN+r1elEUVW4titjzrMBQJGkzYfO45GqBNlYKrPe2IXFRqZQh7+O1v/vlSCSyD9GPMA3k0K46iNvSNBti9T327SQdgX9KjHXzMOvC3H+dxsjMVNs/zRkp5PV1wMvo4hBgsVvnBw1KTPOSk2a8M0jmVXM9/daGtUZSSY/ioqnafMkLRTmHd7zbTHXO5ipvtOFuOVIn1QpRxNEPrrYOw25/jg6PH0yiz2oDteDoVLDP09QZiG1CSJKgsWPbdRgBGPjreTNMFg7ZmTdiJP/hX71QNiw8M2RUrhescseug5SMQVF4TsOIJ9mjvDTLxKN6qc9n9GA+bhnVQ6llN6Ao1cGQfXuwcJ3IdTJF3aD/MAQsTc4ytWfOk48leWbo7TSbdBurbOtVX7uj5rLswHJLuA6if2Z8E9+LxAAJbhBaexEWxRRzUHAmAQFrA/wJ0uV2dNGrBpekv1smgD4jSfeNG9/cqWycoscjfO/LDjhWRoywzLGXIgebKV6dFx2LCwy4xw2uhvPjS/Zcmvqj5t26jv9Yf+nPrtd3MAfK32b+p5OtHdENwbghOFGCmwPWvMP1c1OmwD1Dlv7kJZI5uZGBV3KrWPbK3tSIqR94sv2hSY5rnwlRort4wOnVON3rUxsre1RvyM2G7rNc8eFAnCngigGkykpGFba2rLKEyB2gwiuDc2fZj0uLgwK4Gej3mo7KNMvxkejOLP6mBJy4ecCzTrj0VokpGKVp7sbkzibK+7Ug0OcHfbQYc0J1rWZJ42zJy70Dall04o9DJblMCVOhILXHLeDwFzTQg0THbGXDjW25Pn3t2KXqy4ATQjgXYK5dgv4EpqGS+M7gB9eWuaGPa2l1IgvH4LLEpHbtjCd/pMHBrennA16Ejp+nCfSVBqTfIHcZfWRkiRY0zkKAoUmENtvIVu4fbkbXiO1Y/paoPabw7k8XNb4IiZxQhZ34O1
 GtYVjegT
 7a5rlhV8vOrUc7wP1B1eFBPk+RQz3OJXrMLRgnMXnNQhgI9kJqzYT7GUP5Ptx78n7SBELVkFLMOZpSnaxNM6Fxyiz1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.10.25 11:03, Jakub Acs wrote:
> syzkaller discovered the following crash: (kernel BUG)
> 
> [   44.607039] ------------[ cut here ]------------
> [   44.607422] kernel BUG at mm/userfaultfd.c:2067!
> [   44.608148] Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
> [   44.608814] CPU: 1 UID: 0 PID: 2475 Comm: reproducer Not tainted 6.16.0-rc6 #1 PREEMPT(none)
> [   44.609635] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> [   44.610695] RIP: 0010:userfaultfd_release_all+0x3a8/0x460
> 
> <snip other registers, drop unreliable trace>
> 
> [   44.617726] Call Trace:
> [   44.617926]  <TASK>
> [   44.619284]  userfaultfd_release+0xef/0x1b0
> [   44.620976]  __fput+0x3f9/0xb60
> [   44.621240]  fput_close_sync+0x110/0x210
> [   44.622222]  __x64_sys_close+0x8f/0x120
> [   44.622530]  do_syscall_64+0x5b/0x2f0
> [   44.622840]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [   44.623244] RIP: 0033:0x7f365bb3f227
> 
> Kernel panics because it detects UFFD inconsistency during
> userfaultfd_release_all(). Specifically, a VMA which has a valid pointer
> to vma->vm_userfaultfd_ctx, but no UFFD flags in vma->vm_flags.
> 
> The inconsistency is caused in ksm_madvise(): when user calls madvise()
> with MADV_UNMEARGEABLE on a VMA that is registered for UFFD in MINOR
> mode, it accidentally clears all flags stored in the upper 32 bits of
> vma->vm_flags.
> 
> Assuming x86_64 kernel build, unsigned long is 64-bit and unsigned int
> and int are 32-bit wide. This setup causes the following mishap during
> the &= ~VM_MERGEABLE assignment.
> 
> VM_MERGEABLE is a 32-bit constant of type unsigned int, 0x8000'0000.
> After ~ is applied, it becomes 0x7fff'ffff unsigned int, which is then
> promoted to unsigned long before the & operation. This promotion fills
> upper 32 bits with leading 0s, as we're doing unsigned conversion (and
> even for a signed conversion, this wouldn't help as the leading bit is
> 0). & operation thus ends up AND-ing vm_flags with 0x0000'0000'7fff'ffff
> instead of intended 0xffff'ffff'7fff'ffff and hence accidentally clears
> the upper 32-bits of its value.
> 
> Fix it by changing `VM_MERGEABLE` constant to unsigned long, using the
> BIT() macro.
> 
> Note: other VM_* flags are not affected:
> This only happens to the VM_MERGEABLE flag, as the other VM_* flags are
> all constants of type int and after ~ operation, they end up with
> leading 1 and are thus converted to unsigned long with leading 1s.
> 
> Note 2:
> After commit 31defc3b01d9 ("userfaultfd: remove (VM_)BUG_ON()s"), this is
> no longer a kernel BUG, but a WARNING at the same place:
> 
> [   45.595973] WARNING: CPU: 1 PID: 2474 at mm/userfaultfd.c:2067
> 
> but the root-cause (flag-drop) remains the same.
> 
> Fixes: 7677f7fd8be76 ("userfaultfd: add minor fault registration mode")

Very Likely we want to CC stable.

> Signed-off-by: Jakub Acs <acsjakub@amazon.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Xu Xin <xu.xin16@zte.com.cn>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---

IMHO no need to resend this one if Andrew can just pick this one up. 
Then, you can send out patch #2 separately as commented in reply to 
patch #2.

Thanks!

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


