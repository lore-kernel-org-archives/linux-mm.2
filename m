Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3222FC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 20:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A890F8E0006; Wed,  6 Aug 2025 16:21:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60968E0002; Wed,  6 Aug 2025 16:21:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94EF48E0006; Wed,  6 Aug 2025 16:21:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8587C8E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:21:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12C971366D8
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:21:37 +0000 (UTC)
X-FDA: 83747453034.25.569529A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id AFC458000B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:21:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Afd9eIxc;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754511694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lq3p/AP2ehM2TE8laSRpSoByadMgmXpnPOPj4urYp8A=;
	b=j2CUZdIXcIV6pxGPbh/X9AsvXqeT0nHjP3LAtJBlpmSkPa4ousCBXvJHAlLL4j4ij2I9tS
	a9Z723BgIGiunQy7L/jUj3e+ig8Fu8SMgaITUdb5eF2KxhCGxrv8jRZgk4fhEbnEhhIt1G
	00JalxYDmKfMxxyXG8W/kPvF60aqaj8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Afd9eIxc;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754511694; a=rsa-sha256;
	cv=none;
	b=utfzJIOIRFST3I/ze+oTlTIIR5fd4bnVxegvE7HJ3e04J53kO7tuAnA1hv1sQJIKTbdpnV
	s5CdA1SzxjI00DsXYEs3huGGwn+8HO/pMGL+Dr3lg2PsdJPj/RxLtVONKYnrel6UcXZrJo
	keQu4fFwzR1N1HLs3iIWGNJZoHqt89s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754511694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lq3p/AP2ehM2TE8laSRpSoByadMgmXpnPOPj4urYp8A=;
	b=Afd9eIxcvlYSCoYiNGR5rEuFmGRcYrb6QHFu410jtDbrFAoGGQ4gLpOuqj4ZVX94+Mp4An
	USUilEKScsWhDTxO53EPAAyiK1R2P3hZA9f1MzyD+SIeBWr72UK5T0DNPs2MaySKqG+dUt
	tYuiZ7Z8AvJSdNNjLecgccd389cCpBI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-Eu0Q_UlMPOCxeJ9hzWuRPQ-1; Wed, 06 Aug 2025 16:21:32 -0400
X-MC-Unique: Eu0Q_UlMPOCxeJ9hzWuRPQ-1
X-Mimecast-MFC-AGG-ID: Eu0Q_UlMPOCxeJ9hzWuRPQ_1754511691
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-459e30eeea3so1611665e9.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 13:21:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754511691; x=1755116491;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lq3p/AP2ehM2TE8laSRpSoByadMgmXpnPOPj4urYp8A=;
        b=KGiTL75CWYApzz5NUL3a7UMHNB+FwcEhzyKeI94cbCBtBpdyuxAzH8cAfDgiPa2sHw
         GVntv/DiWTvMI86MNs0Vf2Gcjhut0XJYbUGUZOiNoIcm60EIK2W/nKeYY5IUFIFJsTWg
         bgiTthgskjzaRmJysirQyAEPqLBpsSllsDU5fjZ8qc8xSTx8X3Ca3J5royeowUboMYXm
         KcTs4Q1A+QMxEYA9TMX2QvPumXTKiTH3avp735/Oqbyh9JMvYXSTrUCFvdCx3BDimpLc
         V2Mc8U3cS52dMgg0lvbpPGx7cZIHtqSB0rNR4LFRtR6ByY0WHFUzXabm4h6sS14KneKD
         cYxw==
X-Forwarded-Encrypted: i=1; AJvYcCX175IgfjqmB0Fpy66kcMn6+ZWTkgYWNyq11ewlqDawsAyj4IXXiRbAiJlaZpIWSXhyQGRy16YjLg==@kvack.org
X-Gm-Message-State: AOJu0Yy/YwHhlUuYlQzRlbyKBVECNBNNN7bS7aPDhMYcaXC6M6nejCfE
	0hDZuKWmhL1BrVVVGRIXwYMPXmWdVML//G6krynZqer7nS6FdTrB4hRdaKKftKEM48NnAlZD9/i
	oQZCbNeDM6fFIqJijBYEVPjbg4hjmUVagzcodaieqXmodQc5b5i0h
X-Gm-Gg: ASbGncuI19bBVKvP4dU/Tr7Bd4ZBul2e5+/u/bRjKjU9ypYE3LQqfebdNlz2Eb7bidk
	ZJcpLJ48AjnlE7ig2wjszRS4ZK2TqZJEk/pA/gGJpAfZTXFkipbqY7fBNea+I9xVE5v5WqYdonl
	ewf5W7CMFQ1S781NtK9LLLWQLdgr1q1y4sRERDx7yFZRzhKsWNfcy1Qn5Mo8ZKPpfa/goEa3P2x
	g/MiicIrcZHmthrGulQx73WiAS76rJWLafeu2QRaI3hNatRIjMreRkNmPw4FoMyiyPmPzKwdlqo
	hA2EBj7TT9y3rZRrWkKjNpZAs16hCykZqDbI4veb0KXW/0OFy7iEe8c3/9/R8Sdu2ye9BIXJzeE
	eZOPmXAomr7PPMNqeJlbxnOfJw6ZVdBAPh3PpHbPPMhOlDK2jgvh+cJwd76zLvlqlH3M=
X-Received: by 2002:a05:600c:46c8:b0:456:3b21:ad1e with SMTP id 5b1f17b1804b1-459e748fbafmr42832615e9.17.1754511690826;
        Wed, 06 Aug 2025 13:21:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFz9L54Y8dv3ZQQQ5zpImfkqY1bGBCy7DJowT7QpPPwDnagA1P2KPKg47yvDFrtnPzdqTms+A==
X-Received: by 2002:a05:600c:46c8:b0:456:3b21:ad1e with SMTP id 5b1f17b1804b1-459e748fbafmr42832425e9.17.1754511690266;
        Wed, 06 Aug 2025 13:21:30 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f42:da00:badf:cc55:23d5:1679? (p200300d82f42da00badfcc5523d51679.dip0.t-ipconnect.de. [2003:d8:2f42:da00:badf:cc55:23d5:1679])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458bbf91b69sm106335825e9.3.2025.08.06.13.21.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 13:21:29 -0700 (PDT)
Message-ID: <0de8d37e-5977-43f4-8e21-0ad47130d62f@redhat.com>
Date: Wed, 6 Aug 2025 22:21:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes-unstable] mm: Pass page directly instead of
 using folio_page
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org
Cc: ryan.roberts@arm.com, willy@infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, vbabka@suse.cz,
 jannh@google.com, anshuman.khandual@arm.com, peterx@redhat.com,
 joey.gouly@arm.com, ioworker0@gmail.com, baohua@kernel.org,
 kevin.brodsky@arm.com, quic_zhenhuah@quicinc.com,
 christophe.leroy@csgroup.eu, yangyicong@hisilicon.com,
 linux-arm-kernel@lists.infradead.org, hughd@google.com,
 yang@os.amperecomputing.com, ziy@nvidia.com,
 syzbot+57bcc752f0df8bb1365c@syzkaller.appspotmail.com
References: <20250806145611.3962-1-dev.jain@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250806145611.3962-1-dev.jain@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ti6CDEgCLxU9bVeAw53SHl7QFt-0FaLuRhUh8Ng6eoc_1754511691
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AFC458000B
X-Rspamd-Server: rspam06
X-Stat-Signature: 7yn8h9ef488pa76bnmzrr8bkh5su8d61
X-HE-Tag: 1754511694-36146
X-HE-Meta: U2FsdGVkX19n+TJeFiDP2EVtCzdOKjCqBvxrj0rTw8xhuBMIXgsem5hqjkCBcwylR5rlYFHWYVtZ+7t/gFbQPD0g/qUmKElgjaBvHmhEDQCa+eBzk40xQj3HiC9EF3T2yWuLdaX34V6KvoYJ02qTXr09mxRBFXX3qE4JoCvy3TJVmWB0K0RdB2t0iOU/rR64Fe7EOcb+s3FqzWO+7deKu3WSsjlCjwrRrj6nTXob/WmGgKVW/1U58PRIolj6dQw7f61nI0HBXMNs29iOnY4NuXy6TCkMB7DSRIOYDxWKEVXGWBytC3OmiyiIrIxCFyQuQEZawrFaPWQjv4t9i3ePK8cCC64PwxFpPzwZ/wUH8+cSVi8mcJKKd2/w+P6aqqKAztBRL3Jim6rjMhP57RUDdegtbld1WhzpQ+AksNn4jggvikgt1XjIU8VpNVho8px27kBLocTKvJNl65rrQm5EFkw9V/McxtwHvMjosoRfxKAS0QI1PezklSFm2DRR52B9VRpKIBEdkoXQsy6gnqNkn5JkfX6OvEdzkVrfFOuN01sUyFFpJ1m8pOMLRHiMROADsqX2xyE+UD3YnIfoyl/CebEUQgOX443yGGCLk79YaK9jtohM4yrGRPoVR+Qfr2SzCTJS88Me8jG8Ir7hCZy8BI+4E/r/p9nCMUf18l62rQC0ReMt6fp+Di0YezWzm1LLlQFcOr9zJuiYpOAgGeijwbqQiwIahbJ36aZ0BeoLNNY+X1gKsq4vgwiXP4zslv8mh1tgN4eYDnhLDOJwij8Ld4B9cuxEVlJ61efXE5O+q68BDW2/+tPSyjUhFmblPWcIWOAybYadGttiUheKc4ecpV77zYwZ9m4vq6DTCCRfCdcgtcvdlbdW9ZgCftbrh51RcGTY4GeEyMakQ3cKQX7rf7D4e4Fg/rSPteX/ZZ6v6Fftmn2sDPgstjmKqiUQ4fB5112Wso67MqTxqdx/nSh
 MmxP5iTH
 ZDyh6W88EtsDdf76UfM3r6sUv4Whk8pdgiBa3LvL0HDjJjEugCyqQGXNn4q8v2WtrHFkOhaUahwylUyu9cRiPjY7mf3fZ/1lHK08j+Ma7e3J89aHkTFp0xDgu7gm+b37Zi3dtLtc7CiIUwJxnfW96pWOA/v4iUABlZJeUA4ZJwY4aO3Q4MYhuABo/z5GlfHJKFsaiqlJvaPqqYH/a5J+PNNznxPVSkMk2hFL3TJaTr5uTUC0KKtH7u6MWfU9glYiXjYLPIGavKfSTxVF8NfCWe2Nqras+1Bha18KfUy57bNnYvIUMUC+OJHgMPasJcOHZ/YwkriI5lN4FO4b5NoBaYfc3TNLJqXqocmWKALBUMm8BR5BNweKKmuvalq8NF70r/xhBWzSqBGIs7ZQl5FAcPE5esqLxfhxNwbwoiG2zylkBB+88vb7vphRyHKKP//zXn7blwRpKFPO54xd0Km3P7e/p/JLAGj1T3+rm9pCxL4jH+29iYISOJKkUDxJHLxrM3Q/pSydz8cj7AUv+yImaTK1MSEVfoSx/3u9j0m6OzbGOL8Yi1rAi/6iOZOM4yRoXZToo6nAeHgxsnMtnyktay9TSAkcjMO1Vs/0WHg/JClcjCw38mFeGEauiSVe8PAB45KKpOZMR4PAZYnOHzwMlF3B3cJ/ZZ9UTk1BAvU/k9+M7/jk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.08.25 16:56, Dev Jain wrote:
> In commit_anon_folio_batch(), we iterate over all pages pointed to by the
> PTE batch. Therefore we need to know the first page of the batch;
> currently we derive that via folio_page(folio, 0), but, that takes us
> to the first (head) page of the folio instead - our PTE batch may lie
> in the middle of the folio, leading to incorrectness.
> 
> Bite the bullet and throw away the micro-optimization of reusing the
> folio in favour of code simplicity.

Huh? We are still reusing the folio. There is a single 
vm_normal_page()+page_folio() lookup in that code.

Maybe what you meant is "Simplify the code by moving the folio lookup 
out of prot_numa_skip() such that we only have a single page+folio lookup."

> Derive the page and the folio in
> change_pte_range, and pass the page too to commit_anon_folio_batch to
> fix the aforementioned issue.
> 
> Reported-by: syzbot+57bcc752f0df8bb1365c@syzkaller.appspotmail.com
> Fixes: cac1db8c3aad ("mm: optimize mprotect() by PTE batching")

Fell free to add a

Debugged-by: David Hildenbrand <david@redhat.com>

> Signed-off-by: Dev Jain <dev.jain@arm.com>

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


