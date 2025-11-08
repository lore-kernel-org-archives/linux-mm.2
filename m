Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2770CCF9E3
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 02:33:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07F7B8E0009; Fri,  7 Nov 2025 21:33:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02F6F8E0006; Fri,  7 Nov 2025 21:33:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E39C38E0009; Fri,  7 Nov 2025 21:33:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C8A1F8E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:33:41 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6BFC314068D
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 02:33:41 +0000 (UTC)
X-FDA: 84085869042.04.90D7723
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id 974571A0007
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 02:33:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YYqKK71R;
	spf=pass (imf19.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762569219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8bKq5Kbap+TGIzkU08hwTVasn8Atv2TAiFfbpOuCLu4=;
	b=EVokZq8Lo8tkJkN1yafCsPufwxo1J8k5Em1JutlUWVPLsVuwGNKNcDYgDuD9ZQ3GL1zvz1
	0PYN4JtrAGmzFQK4jEWJb4wZoFr34WSuQaLTbipycBWltoTUwaLJOLNBwGvXMqFc53VgIO
	2FMQ+vo/mslcB5hrvQHMy4rlifjrsiQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YYqKK71R;
	spf=pass (imf19.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762569219; a=rsa-sha256;
	cv=none;
	b=f8F0HU0wgxwovmQA90nvb9E0G0nVYzu3gstW/np1ZzAhlNd7nmrt4gt+i3zB/Rdl2yxLx9
	std09Mk2u4BWh8DNh9sg9r10lbV4O0MKlJ0ABdajnAAhsMIRzLEWHghpqzKcloZB23Elhc
	OwQ2P6tqyV6ZScO4jintSotssHKTNNA=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7ae4656d6e4so1648550b3a.1
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 18:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762569218; x=1763174018; darn=kvack.org;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=8bKq5Kbap+TGIzkU08hwTVasn8Atv2TAiFfbpOuCLu4=;
        b=YYqKK71RgoV1zgXuNwacIRh42PAp5gmIcCYiWWDfeDfqL6SiQukmDeY5ey8QukIDM7
         xwf81LFhh8Jc8FZSky7k0t8eLBreGDMmgWWNWO9hP1QMMxJjUF/uGrnd/balgxcVYSxh
         cTiDERlDEAicB1KyuCiIbpnlxbjKgNJtG36Ah/1M0vhp9JCx1DnzYEq2cr1J2Lj4ujhv
         la8i1/JVN1XXwblYYxntd6oAjR3+YmSKvGJT/HqX+gnH+1l4BJO20P2LZG7GkYNJ3TpX
         U3/t7MKEaej1vmK3y9SDo/YAWOhJ6RXo4E1RfKstHPrkn4IWWg0XyesQVPZhvjLIiQdr
         r1AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762569218; x=1763174018;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8bKq5Kbap+TGIzkU08hwTVasn8Atv2TAiFfbpOuCLu4=;
        b=hRheldJzd6X48DlyryvdRgrwbcpYKDE+lVferoOqfJhslK+eHtzxqlpdkKETXuvN6W
         NpjXlGoifJvCuDMewe5fo1gvPBaGn0Ui0h2fQJefg4HeJ6WNdJ06oFSml+BdXMTtWUQa
         QriXzdhXicCO47S0OhaFyKxF9EwcZXJiNvNq+PInS4Y/Ypjhj4VrlemJ6e31wgDj2g71
         VTNtvkIgFI+6rKJyAqscAO79rQdMdW4CJy6pLkUWVpuJiwhSd0FenvVX0FdEWPL0Ys2r
         uypCd0phG+Gzv/W9GIhu2N+I5gCEuYdhesDFBfds5Q6AK+E5WWXQ+/C+W3wTyAxyDNrZ
         xKWw==
X-Forwarded-Encrypted: i=1; AJvYcCW+4lKGF/b60bcKlIsXGJDbi5qF4sXHG5ua88XZBo+znRbgvuhaJeIGV4YfgItBJs6De+eMKX1UDQ==@kvack.org
X-Gm-Message-State: AOJu0Ywt3jqhx2Vz/L7mli1HpIgyKUfLXj3RyZx2TEtt993fy1pXzO6+
	aSLN+Isdn5cWe4IyLSQAWJp46szL5hAA3TEcSgoEa19EdFFdH0GXg9Xz
X-Gm-Gg: ASbGncvovxgbrxhPCuFZfvmRz0CWkOyLHULOREqUVjO5O1MWi3O1ycgnSFh/hv32+Gj
	4asZplr0yPcNse1TxauCpvpJdN2KIMvMavMl2yOhMu/k/BUuCRGvr/0dSnpX4pn/WNBeDn5gaas
	OoF6lXd+nRx5Oj5/VIy6EGSgxEzlu/Gbpma2UZzxiAYXdYcuxKEO86Tf81wvf2uXAF75nvsNXx3
	XbD/bX08Lqby0DLCPcvT2DF6DoQnoTd9eMpOhmqRmmPBZ4Q5fjNCNIFi6bwz/uJX5w8Xu7YKGJo
	mJQqC5IyESrcPoe9kF7sNJZxCJPJZWd8X5N3hwVbd9ND5B4LZtn3wLUW/8S7pMWt2QdiWRZ9dSR
	4RkxgEDMuWMV2DNchPs+Xd6B1jUXp/J+C6nXm0KQ/4/ui0A8FosnaYqfrm/f5qD8I6fwL9PAml+
	SZSzxB
X-Google-Smtp-Source: AGHT+IH/Pe7wf3Ci181tpT0LHXQVq+Kf1iV5vunI2sKT5fx4KiiLBfIeJu3hgL/jAYkDOG6ZWRYxGw==
X-Received: by 2002:a05:6a20:12c5:b0:33f:9581:5d2f with SMTP id adf61e73a8af0-3539f99e63emr1740681637.3.1762569218334;
        Fri, 07 Nov 2025 18:33:38 -0800 (PST)
Received: from dw-tp ([171.76.85.117])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ba8f8d7eedcsm6587378a12.2.2025.11.07.18.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 18:33:37 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Andreas Larsson <andreas@gaisler.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov <bp@alien8.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Dave Hansen <dave.hansen@linux.intel.com>, David Hildenbrand <david@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, 
	Juergen Gross <jgross@suse.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Nicholas Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>, 
	Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, 
	xen-devel@lists.xenproject.org, x86@kernel.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: Re: [PATCH v4 01/12] powerpc/64s: Do not re-activate batched TLB flush
In-Reply-To: <b3e4a92f-5b51-4eee-bfb8-c454add0f0d2@arm.com>
Date: Sat, 08 Nov 2025 06:05:17 +0530
Message-ID: <87cy5t4b0a.ritesh.list@gmail.com>
References: <20251029100909.3381140-1-kevin.brodsky@arm.com> <20251029100909.3381140-2-kevin.brodsky@arm.com> <87qzud42n1.ritesh.list@gmail.com> <b3e4a92f-5b51-4eee-bfb8-c454add0f0d2@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 974571A0007
X-Stat-Signature: 3qr8646u3mwyx58k4s597nihym418u3t
X-Rspam-User: 
X-HE-Tag: 1762569219-840995
X-HE-Meta: U2FsdGVkX1/fOBVNIj1+zd4HBOpXtJaYubZKQRMaZKjjxt9ZqfYk2F22g+3XHGItTRaJKH+qBMuHScmnZaDViDotz+xJumttXPIXBwmXBiCB/mDTChWoIus8sUhduD6RCj4bAIGHBzI0sXQgKMxVuQj4RmMCn1+/r6GFEDzamoq4eiF4CcpTkuhDLD7fserDvEkTcJxfqD23G4niL4UJxCzn5Hz+V9QOjTfZq3Mx+afCURO/nCUBbosFKT9KLlyalqJ8dideb8FUMpj5hi9PZxq7aAuNDMDBIo6B3n04QKrKZP9Zzeb9DCHI7AhIXyGbaAtO9J9XgaSioBV5cOglSrVPeZtG4YQtx2KPKnm3bth3IUyqvK90BFQ18tgqZ/22DcWLBt6tmN1L97j4StqqpyYkhX3VscA3xOgD24Eqp2oQfFwpREF/4H9y3T/yCysjpSFIpZh0HVHKScqW7VJg2XHtxklxaQkBZKEuwNGHjoiOzCaAD3yDH8xBemrr/zzMFnzP1RZM9ic3lIsm/R2/dsmT0WOf2567Fi7zLkc0BGjG4bOS0LN7zMihvcJD5MYIVEGd1/Xo/DUb6YkjFcdDlksrLaMMwCkM6g+lOUnG3eVNyYagaH/LFgN0p9uG3Q5tqTJiLR6Jz7nOlP3pud92EZivdPeQI41ERPpVKAwrMF2g+CTWWLJU7/iLlHagAbuy/yGEpVSXwO+yCbHc3je5CkeBsrwYIIu3+YyxZfIpq7UVuoj3H0a4ZD1/zGhpMREINn+PxhClSnmNV7PgUcgaK5KklD7V9Fyv9DRAP0x+9WUJwwizw3jnMLy83d3EyuDwfgaoV5amb0NnwYaEA4TezeMUOohZHRaVTgJF2dzrD/nzw0Ry2uTxS19xD+Uwb9g1OZqjj6IwQAIfsH3cJ27jzFgAZq/ayUWwZbzYFcU/YImaSTsRlDifSgWeFCNKsODrrzKPoLHl7+X1vSSxHan
 aGAZlimM
 ZKJw7lCXV80m5lIjc3F3sIMFg1yYliXGWIkJ7K6bxDXF0OLo5uuKC87Rk06KtsCP3IIF4RRqxXpQtPoZgrohAm+qTLSEhX0i4UkUjMDKfQwj4Bn++HA2UahDVN6BVnFwkff5dcbXRksy0OBxRl/FPGr6q5GG6QaQqjLj+aph6DxQUrOk+tHPmB5W2RvNDglsMGX+5PudS+SP99qn6ERC8gQOzQT0lfS/cM8phPOjdsUVqeKrurwmTOyfJzVpjsJIHT5UE+fwti7uo+BSRmCHEjj/FpzD5cujRADVtL8cVOOwJlnEYuNNPFDT610U/sbvRupk5Jog2nxewYt1OaY4nVuEjndIXqAQrv7V1wCKuYL1Mprua9CDsJvdPXwLj/1X69M/cdE4bs0T8eNG45mCwBgB6RPHL6XqVDl3zuBCqwPc0EHdOKx9ZNQYaX9dulmWuh6Ce7QmxZF2ItNQM0Z+awuRqamG/0PKvEL+j167iF5aVJuY01Sj52fGmAxztXQ4ekpXeSpffZy/Q4EM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kevin Brodsky <kevin.brodsky@arm.com> writes:

> On 05/11/2025 02:46, Ritesh Harjani (IBM) wrote:
>> Kevin Brodsky <kevin.brodsky@arm.com> writes:
>>
>>> From: Alexander Gordeev <agordeev@linux.ibm.com>
>>>
>>> Since commit b9ef323ea168 ("powerpc/64s: Disable preemption in hash
>>> lazy mmu mode") a task can not be preempted while in lazy MMU mode.
>>> Therefore, the batch re-activation code is never called, so remove it.
>>>
>>> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
>>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>>> ---
>>>  arch/powerpc/include/asm/thread_info.h |  2 --
>>>  arch/powerpc/kernel/process.c          | 25 -------------------------
>>>  2 files changed, 27 deletions(-)
>>>
>> Since the commit referenced in above disables the preemption in
>> arch_enter_lazy_mmu(), so the expectation is that we will never be
>> context switched while in lazy_mmu, hence the code changes in
>> switch_to() around __flush_tlb_pending() should ideally never be called.
>
> Correct, that's the idea.
>
>> With this analysis - the patch looks good to me. I will give this entire
>> patch series a try on Power HW with Hash mmu too (which uses lazy mmu and
>> let you know the results of that)!
>
> That'd be very appreciated, thanks a lot!
>

I did give this patch series a run on Power10 with Hash MMU. I ran the
following stress-ng tests and didn't observe any issues (kernel warnings) so far.

stress-ng --all 0 -t 60s --perf -v --verify \
--tlb-shootdown 0 \
--fault 0 \
--userfaultfd 0 \
--fork 0 \
--exec 0 \
--memfd 0 \
--numa 0 \
--pkey 0 \
--remap 0 \
--vm 0 \
--rmap 0 \
-x swap,pagemove
(Note not all options shown here will work with --verify)

Let me know what else I can run for validation?
Do you know of any specific tests for validation of lazy mmu feature?

>> For this patch please feel free to add:
>> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>>
>>
>> CC: Venkat who also runs CI on linux Power HW for upstream testing :)
>
> Ack, will Cc you both in the next version.

Sure. Thanks!

-ritesh

