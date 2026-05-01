Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FA75CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 22:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7468A6B00A4; Fri,  1 May 2026 18:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D0A66B00A7; Fri,  1 May 2026 18:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5715A6B00A8; Fri,  1 May 2026 18:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 438D46B00A4
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:21:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2EC3120254
	for <linux-mm@kvack.org>; Fri,  1 May 2026 22:21:56 +0000 (UTC)
X-FDA: 84720274632.15.FDA7AEF
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id C24142000C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 22:21:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Rw3drj9+;
	spf=pass (imf13.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.181 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777674114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dtXXiVGCKhisCk8aLdkBNg++qq/ezEnbK3PGbPzPAeg=;
	b=BIAAZ2fLiLnY4RX5UECqRUWymtt7ArdMLk6PtOfo0YClMIB/M8jMET5Qpyyl1oC5OLWPhU
	LBddXrvpXywTlQtf48rDrR6ftR9nLY1C0hQ3/1SfcZYFzOFCn+pADqziUOaYD6wE3f+CCK
	iq0+HCvWg+DSueCZ6cuATQSQDfz9wEo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777674114; a=rsa-sha256;
	cv=pass;
	b=cwc80gE4li3Tp6QKuWCMaiqsaFdNCrHVyTwm01f8tfUoQhmkUAitfxNGD+28FXhBAqucXS
	SCfz8lQi7ye/ywiL9hTkK55v/olG+VXJ2WRjF1R3d4IUklU8xNOswk91sKfV+hESSphDAl
	5KguS+8ooKoXPZHLK397/bMwG+WPgx0=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Rw3drj9+;
	spf=pass (imf13.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.181 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-56a9c5cb48bso841858e0c.0
        for <linux-mm@kvack.org>; Fri, 01 May 2026 15:21:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777674114; cv=none;
        d=google.com; s=arc-20240605;
        b=HbOacNfiNyeV+PgP9asMMv5HUm++cm2qWZrAjhcfebNlkw4a+fXQqzhsrSgn8LmVK2
         wmcm2c1MUMNzRUYBhziYV7J9Jqt3A+Eknxm1rCl1vk0G294wjExOVgF4U8yGFSJEo4UB
         xG+c12B6IDKR2R8sCFu0yZHHM9LRUhlSJ93c39hn76xhgGvUVq72flVOaSsMmF+hNSxI
         DQV3VXa7qheiC90W6ilH3QrhUDRGXBzashvvEDfbUaw7hNaMNgfkqMJb9luVTwgWn+4b
         1kFX1LpwflW3LPkJjMSFgwx3IjV/7n5+vstMCPXnT8vJy/d8nI19uvFyPp2u2BscU9xv
         h9LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=dtXXiVGCKhisCk8aLdkBNg++qq/ezEnbK3PGbPzPAeg=;
        fh=PJM4uiXfh9MpQHvbm/TS4slU+UlrBd1IjjN1tYM+SfI=;
        b=Qctyrhwu5xrE18t86BXEm0TcLgUnwGo1Ohh7FzlIiLlGYfvGLoA0A0RC+3mPUe9e4i
         z+JOMRKON47kvtant+kFgN2VpK4i1shsjdM6teaymOm35TGnaGgVR4gQlVgKRPd/+/Sj
         YZmKTD65KG2Rq8Ll+/g7ycxYQF1MvawuWSpYesxdTBOhUo3romabmjmnMtrkTOJ1h+EW
         hnZDDzQtRd54ncGvR+Oj6l/MpHygDoIIy3EXceCuIdGD4og5SGeFxHmj9ReLbshvs+G4
         rl4q9QUpigecXpDG8GBLU/PonqHEbVhud3xTboQLWcOmwmNnbOELoD3jTs3Wm3AJ7jNq
         gs6w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777674114; x=1778278914; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=dtXXiVGCKhisCk8aLdkBNg++qq/ezEnbK3PGbPzPAeg=;
        b=Rw3drj9+n6/sGEfoCkMlY5abLcTB7Sydt8yhIdDThhTWzPHtZv7nMZ061BXF43HLiP
         uj3GDIXQXV8T2PZsqSCkJQlRykWx4KZ45k24PTVNBdbP9BoMiEeeh0vs+m72YXOQzGKx
         Myd3XJ9ODk07RnH8DEUDCIvGLLpUTT4dW4uR63kvUNMPa68ueqSCPb7VfMacFjYxepkP
         Xuww/gRQ7xQIRm8nNEf3kqw3Ah0JYrRtsHcY6RwNSe8vIkvgWHeySguDRM8nY66EtVuu
         QZzJY+hbGkNsDozKlHo6G7AzRTMWXkvN0iclyVedxlD2MkiVNCjDI/9G9+9KhJC0ihMX
         trNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777674114; x=1778278914;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dtXXiVGCKhisCk8aLdkBNg++qq/ezEnbK3PGbPzPAeg=;
        b=DVdvBqthE4HLuNT9EohG4MuwMe9uOnlPP3m2i4F5+Um+blcyoYWscaOidxRU1hif8P
         IeyD5z1+lXlUrOe9o2NQM0DRPhFPCm/3hDAoREjVLB3fdA8sIot79Go/PwxYcxiw3Q1B
         bjmoRNSCw0NkM2Oyuz1BmVN1J/zc7UGSRzx0qqyL+mR3jBotvTPpeHjdoX12bOeYu2sD
         D2i++wGYM2ZtKwrMDrHLwCWoy95TyO3x9hOh1mipnyAQCrYntIjgF+W/OTcyaVORJunV
         1pMdpvj2HQ6m9gZVCXijJXo0rwsMRfxzbS/tbv16GX5kt0B38FAhu1nXHTOPnzBPHKl9
         4DNg==
X-Forwarded-Encrypted: i=1; AFNElJ+b9CZma5AS0t2XNUeW3layfxz682yPYgNd4ep/1tbWn12ZILKI/DAvWbjewdRNE+XwStuLTqox4Q==@kvack.org
X-Gm-Message-State: AOJu0Yym3amGHn+IsxmpIWcRXaUNfxhUgOplbAIWTxP7cI/EtFmqFlqb
	SSrWEh2QKtB/yUggZz38r1ik+8XhA+LqG+LyjbCUZAK/IVFXtNsIxnRW1FG74Hk3TDXpHJUTP+h
	mERa4JRo567YI/BNtCN+lXJhW9BtcXHS7El7e6dc2
X-Gm-Gg: AeBDietzLtZhD8AYF8SeXu/m4hLgeQn7sMBcxgSW/dje8R9v9TcufHgcgT+u6cpR8UJ
	t2iZyF/xIfby/jbUZVDQZPXOPqRw2gX8eU2OikB5DRVjbHc+Mqqo+5JjMjALIH/AJfe+mdMF3S7
	0ubDhbXJDLNMBOIV32IoGmBKAEJscFC59rsmGvh6d3n6ZzJ/N1w+j8jcGU75utsOKRZV/Rv0/Gk
	nMqyQWVeqOp2nE0lJwo6uTq6Wtvx7XCnQC2Fo6DV6WvOFACt8oqrGt8ejgZH9N6da1jnZe6phCe
	GdamZ1EbU1GEM4FGI4Pd5HJWvTTumcy7LDWjf++zB4Os+Y9YzwRXnruCGisDiFtr2+nn2bojrRU
	cXFb/pTNgLYHx41Q=
X-Received: by 2002:a05:6122:1789:b0:56f:1c32:bd07 with SMTP id
 71dfb90a1353d-5750c6b46damr742606e0c.2.1777674113098; Fri, 01 May 2026
 15:21:53 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 1 May 2026 15:21:52 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 1 May 2026 15:21:52 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CAEvNRgHRpvsEjtr1A_Qz3d4oMEaffTxESavrZ73Jtt6OobCwhA@mail.gmail.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
 <x7n77snnvvukofo3slopl74c5tmlb2t2un5qy5fq6eb3d2xt7e@6a6tixg5mdfc> <CAEvNRgHRpvsEjtr1A_Qz3d4oMEaffTxESavrZ73Jtt6OobCwhA@mail.gmail.com>
MIME-Version: 1.0
Date: Fri, 1 May 2026 15:21:52 -0700
X-Gm-Features: AVHnY4I-FL7ow2VQuDyStuaACgF9aoh7fvjduqjprjOyhgxszANTKzDwmZOdoKM
Message-ID: <CAEvNRgHZJ3RONKBXqWWLu2f4G7FhAvsYY0iMowmHu7v-O+g=kA@mail.gmail.com>
Subject: Re: [PATCH RFC v5 00/53] guest_memfd: In-place conversion support
To: Michael Roth <michael.roth@amd.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev, 
	Jacob Xu <jacobhxu@google.com>, Darwin Guo <darwinguo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C24142000C
X-Stat-Signature: 7qb6kujttombnzjpyktrhybydwnr19q4
X-Rspam-User: 
X-HE-Tag: 1777674114-997797
X-HE-Meta: U2FsdGVkX1/z27rJFcrntXyp9XgOKMb3I0AbLEUPylY+XGA4JTSAwNuUUT0LeVAPvzUuJHLSP0cQj+ekSq0Imc8on/hn1/N35J8h3hhUOng9gpgBtjQf/dO8lJwxbfStdfYz5nrjdhzek2DqF5fM/DOU551UVT6h+Jf1oTu6+EejUx775pCn0z51s8K6BW4Dq/+90UGvIS7etVCTt9rAM7mrhb9GCKyVw8BOr+2hXXVzCyYkjdV7MP/VvaAli21xKemc1JQWj9AgRC++baWg+hwxfA+1Hc9AJDzApO3C2n9yb/NWMbk/ggiP8pLpL5xbGMN4N79j5kRbAfa0NTJ5EB2nVeEAc41P7PwKqnwHYnQnkVN/DqSt7XcTJdLhbQbNEpxM/lt7a5a4OP7VhPqfxOg56YIvDIiNdi8sdQ8bxqfBnu05DzyqisXLduu8sBzuUgcqLUYI0DeXFn5XKmJEFuEZndVq3U6Zgces7Ok9cbUaGqZZ1PvUhiKFzz+NGmnC0Kt3f/n4a+qdLsI40H1so7sFCntczv7XtpPRqMEkOAG4eFurnKkDksnLbPnmQm8a6IRUIicxhhnDFgdCZ7WyxhcEogSFvkkq4w3O4v2GwwAJJMUXKS6VsbNK1kgcqOxuRwWP+nyCyIaOAhEGmaQ1aQmWcYUXAyAbA4jdHz/QR7jlyeciytcEBIuAm6F4K4caXbHv4B4oa+3pPMOGJ2+loBnbqzuuHvlS161wU+rQGWbrN/LDb+JEvBAeG8K/QIj9uHkZCxJySI4fMbhOtGl2SrDDi/kowmGHw37DsNCYYbs0zb0LeLLEDwJXdpQevdRfp8GCv52dTEKGCv1ENpYFqDLAZBX4NsA5k1GDYOMfzsajuybVQ37QBXOLl31u3vJgu5emwVh9fjJG9aqA88mxcVVJvmh5fePOX16JFGomkY41MJpcbw5i2D3fD59/YHZmHODk1iHiWHbgL9DlEoU
 KmDvu/yx
 MdNl7vmmoOJFGK6gMLzw38U9LIumOGrgcz56Br+yfALZPWEjLybjv/WQo84cl9hrZa/7STQ7QHFkknZNmaSH9vV0x51lgZ5FXFlScBpAfro3HT9Coox6AB4wYys8rli27aTlpRmv2hAbXDycHC2XIxzVwQ8rvWepX00laPlMnS2ASr9MYjtnJm2e+jHLtnc27E9R81Buw+i9VvEIBzQWGJ+J/owQpEyGCwOREbIO/KYw5DVOKw2qtzZnn3iunnRfOa7tntjRn0VGZRhC2+NYQjt0gqLDKHHcwRAQ+Zx2rD8crl1VkO75imWUJdJ1Q7V25nhZh4bBAgRpn5nNNlL+OzHa3r3d5K3dI/ER1y+hH85vGDUcfmruyjE2TSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

>
> [...snip...]
>
>
> TLDR:
>
> + PRESERVE == guarantee that the process of setting memory attributes
>   doesn't change memory contents.
>     + implementation == do nothing in most cases, except -EOPNOTSUPP for
>       to-shared on TDX, since unmapping is a required part of setting
>       memory attributes to private, and a TDX side effect of unmapping
>       is zeroing memory,

-EOPNOTSUPP will only be for TDX, not SNP.

> + ZERO == guarantee that the process of setting memory attributes zeroes
>   memory contents.
>     + implementation == memset(zero) in most cases. For TDX, a future
>       optimization exists, where memset() can be skipped for pages that
>       were mapped in Secure EPTs before conversion
> + UNSPECIFIED == no guarantees
>     + implementation == guest_memfd does nothing explicitly about memory
>       contents. The implementation is pretty much the same as PRESERVE
>       except guest_memfd won't take into account vendor-specific side
>       effects of the process of conversion. Except for the test vehicle
>       KVM_X86_SW_PROTECTED_VMS, where memory is scrambled.
>

Found another use case internally for pre-finalize, SNP, to-shared,
PRESERVE, which works with the above smaller scope.

During SNP_LAUNCH_UPDATE, when inserting a CPUID page, the firmware will
check that the CPUID values would not lead to an insecure guest
state. SNP_LAUNCH_UPDATE will fail with an error and the page remains
shared in the RMP table.

Here's the proposed flow in the userspace VMM:

1. Load CPUID in shared guest_memfd memory
2. SET_MEMORY_ATTRIBUTES(PRIVATE, PRESERVE)
3. SNP_LAUNCH_UPDATE => get error since CPUID was insecure
4. SET_MEMORY_ATTRIBUTES(SHARED, PRESERVE)
5. Read shared guest_memfd memory, error if VMM disagrees
6. SET_MEMORY_ATTRIBUTES(PRIVATE, PRESERVE)
7. SNP_LAUNCH_UPDATE => successful, since CPUID is now corrected

Does that seem ok?

>>>
>>> [...snip...]
>>>

