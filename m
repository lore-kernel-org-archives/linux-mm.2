Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93D0FCCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 20:08:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFD898E000D; Thu, 23 Oct 2025 16:08:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD4D98E0002; Thu, 23 Oct 2025 16:08:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C37C8E000D; Thu, 23 Oct 2025 16:08:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD628E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:08:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 30A2A13BA49
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:08:52 +0000 (UTC)
X-FDA: 84030467304.12.5FF429D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id A954F40018
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:08:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bCF3xmyq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761250129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3/xqA5Sno72zZ6iNEmFJ5mtAMbJynT1rhUprvMytuFY=;
	b=oWgC6ZwgtW5BiGNU1ssLlV4PhRd0vmktbGnTbpdNIHyLPT3EvdOaiPv0kvE3nInhkfhIGg
	eQ8nII7tupNzNxlbFrWQ7qSK04fbO1Bi0F7B6kW5QIy+eP+W5YH5K6sCOpfVDEKyfnu8Yg
	dTfKVifFHgeFopHgJTwwreUdLLfrsAo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761250129; a=rsa-sha256;
	cv=none;
	b=rW+n6FwbF58BeVotckz4ft98uMvT0KecwNDV8hXDN5KwifkSK1S45uDoEvU04d1DoVbnvW
	5sEv76EpkvQ46TglEOlTpzl/Y1TH2gSscwR7nTuOZHuE89joxHCwpHtHm4KePhQ6xxvYAg
	WFa0Vwb0oStvNqC/cU2zZmaUfVuga6Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bCF3xmyq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761250129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3/xqA5Sno72zZ6iNEmFJ5mtAMbJynT1rhUprvMytuFY=;
	b=bCF3xmyqGhAxt2D2zsQiWIznqj3FOVeCl8+sQxO6yKNFtnMpL135Jc/DC0DOkc1XLWUoc2
	pXdCjS8oBzwVVJ+12YJR+8XrsXAnhVOMz+56GtAw8+/GYjuqBssaC6vW/Gpnz3v8BQlVns
	H/8D9KEJKADshfRX0oPJFucs6QKMZ7g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-65-eIVL7vFTO26rQEZ6Dk3k8w-1; Thu, 23 Oct 2025 16:08:47 -0400
X-MC-Unique: eIVL7vFTO26rQEZ6Dk3k8w-1
X-Mimecast-MFC-AGG-ID: eIVL7vFTO26rQEZ6Dk3k8w_1761250127
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-470fd59d325so5354245e9.0
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:08:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761250126; x=1761854926;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3/xqA5Sno72zZ6iNEmFJ5mtAMbJynT1rhUprvMytuFY=;
        b=nJ7l65p950vEXm3PZhPIQhA9xQGwArek+BIYseWKsZIdrpksBtJdUFucXP9cSMuPLm
         sNnVi79Tjyo5jPowtJL09glybr+LjicldMXeSHvRJ+ifVBI9eKaAF/puFfQRnwjRY5gW
         PTRwlMuiTDhrpIKeKkvxcazB3qHPAMv2HEzPmDOPSlzMwkoQ9/5BZeZ0LcX5+YdMakpW
         8d8BlqeWf3CSjh5aW0DzGOaCUFsGElc3sGGUQOtzLTNzkom+5og/OiacMWzNJMZne1ZT
         MqV8tH+EojLc52vgMPYViGpNQ/6s+dzXv+b/QjCno3Pjm8/FE+rxXh+QZ0P7/M4RTqht
         BSwQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1ZVMVMGOoe3GkjtOW6wRLqqyv+vTqiUsmuYlaQuxbFNeFh3XTnvnWkRspGwww3E/LY5NkMkuC7w==@kvack.org
X-Gm-Message-State: AOJu0YzQtOBUhUYHNqo6hFQlbj/BBGOaP69v1onmAGSDcdpUgwsaBw33
	OOfLpeDAv2NthtYfCIr2lghsoA6M+ch/fiTdA+oAgvXjceipeXW3xlOwFftzPiwptmI+7NCLcKw
	qP2PFxJWcBcHAQ/+QRph6M17iBDdbEonu+YcG5rm6OC7n6Nbm3Y9DDNM1p84F
X-Gm-Gg: ASbGnct6nbjbozVcNEZPpyVZH0Kr+z7+59LwDzD1pe555FSfbzEfp8RoTsr2xGWkTuU
	ZAb/+PqImrRJqqYD+ssd38nuLjB5cT+xpPgtB562fqAuAsPov541k6FxQbvkRRuGtRG32yXgPGq
	oGg3w0SOVuiw0ytrxuuRPU0ep9QaF02qoAmJgY8BdTHqYMUk4HaRz0c2ySpVprg9n/umbqC0115
	GJ0iMjhMEMArmd9ueX3xIWslN8e97jlfFbw09FlaRIQCbWZDs/1wn8H9cyoSFjboluzhJjfkuMM
	roWgg2i+nDr1lNXMS1CELF85eBgFffAD65V2bKCSqlEnBTEd1pYOLF4XbGM2x5DGcPbg/qwXKJn
	oZmQEzuGD2tVlwHmh91Kon8Qt+LmOg3Ay49eejnO5zWS1FV4qrJ/M8cPXo1RoLBT6WrAxIf3fbz
	cAWLzI4jjqTGUGt8qn/Ui8gP78lGM=
X-Received: by 2002:a05:600c:4fd4:b0:471:13dd:bae7 with SMTP id 5b1f17b1804b1-4711791c5dfmr213019235e9.30.1761250126426;
        Thu, 23 Oct 2025 13:08:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFhLOfkc2goKkbSV/WelWxssM1PnfK27SOZ93tRWz4irrY4Van7GhpXF/QUV/ppkvRzGCYJqQ==
X-Received: by 2002:a05:600c:4fd4:b0:471:13dd:bae7 with SMTP id 5b1f17b1804b1-4711791c5dfmr213018935e9.30.1761250125948;
        Thu, 23 Oct 2025 13:08:45 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c4342373sm135497185e9.12.2025.10.23.13.08.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 13:08:45 -0700 (PDT)
Message-ID: <28f2ebe9-cfed-41c3-803f-8756dca0e300@redhat.com>
Date: Thu, 23 Oct 2025 22:08:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/13] mm: bail out of lazy_mmu_mode_* in interrupt
 context
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-13-kevin.brodsky@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251015082727.2395128-13-kevin.brodsky@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: U9z_Eo0M-OnIOU6QOxEFnF1eHHqRFZS0PqUdPCE6Tas_1761250127
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: hf19m6g7qy4fuy3qrmkyf9ztuibq1xw9
X-Rspam-User: 
X-Rspamd-Queue-Id: A954F40018
X-HE-Tag: 1761250129-161692
X-HE-Meta: U2FsdGVkX19+5Ak18+ZSS/xIxgMp0ZHMjtYQUi06Lfla02dX84VOzE7ShK874bDHMyXl7pVQ2agRKXEQtzALA5gPtfdxgJNmJEVWyY4p78M2QW2Uu4tDbsUVRHIxCgrjKZ+0PerTJp7bFxGY0oyyE+aeJmmubi47aK/ibKH5InIRxHUbxOoWM7qf2HmUJiqWE8ox8Uo6F6gB6ptxC91nlT/ezPLvmaF5eGs/3mrdTCh9u0ZWLbHOqtYCs07RDFyRleHbl5vEsaspYTXnHZsCm0SutcuWo/aWqchpuY3MBhyKn6m3Wu6VEEUSPBXCT5kaEDxMjJCjl6mrrJ+J1KUbEnA6CpHBupUdK80tXGK9NmKEfGK4FXSLUED+KU24iwC2w+lhUV9GxV0b/4C6EC1fu4opCdf9TTBAuUKgj7XY0PMO7DospxxmhfzGbgkglPyW9vbjTWZNfBL44JQX83B4lYLWugNxA76BSUaD3BnqgiZ64DOyaQMT1dM/LiIr/drwe9PONJom7OThXDNeF9sTzMTq+dVLvCfzVQukFm7SgYDHRowspuSPdIhAbTK0pXJScBAjq/+BrBOEzIQn+h4UtfSLovtZwPrrKKO+KJxHibezC79dVlWXlVZ+BufQwRhN2c/pjRgVKHvay96iuQqOJyZSsLHO39n3WaT+W7b4SW7aJXOOuFfkY2WkoBzSIFpjzofmbvTi++NRXdanyklx44Lc1UCrXjY4tjh8EjHWXVPhncEjsj/bHVvO2i9fSyyi0gRjthOD7I+E/CR66QlXcbmpENh4fPKe3WCwLCF/RsVud2obEz39neYSVHmBYoWAGElY05Zji+Cu5k0Se9v8gwFFN6KXdLPsHFpQU+s9yajG/PwGwFNtzFtr/zKnZ9O9lDCFkol8JryidK0+LZBt9QomEpzP2qQ5fYx+obyS8QcpPPgtE6isMkepfyoMte3I0JzwWiH9MdBvBC0BwD8
 CdLwBr4r
 GZq0thQmaLB0H6nVN3mQFrysOubzxGXXctfWMohTlRWWIxDSAAwYV3Sa9jMgQhhWw9XJDY4qV3ot+6iFpUaWKQfiaLjonZVlbfvyhOrEKZ4ul1QsJTn19m5vb70Nm+R/1st7/AslTPd4cbt9imB169ct367PnilSbADpnS+7F5vdc7J+r4KDVEH+WmFfOtB5NU8c4NSOkVVh9VWACEQrzu9vFy68OkkU15On0XhtqhFAb7RxgcYsT/WzKjbSd0HKDfEsZuZEBYh1E0hpVwFEM9JgZnIHcAi567c79bdG45YaW+OBJ7CDlvOO12ClrS+7Yw/672z+c8CmMXcZGyfXDfP7+5t8J9woYOrHxn28QPRNKDFbO/UuQyPnwmPFDmRS1RHd4mg2TWrFG723QLZxBVJgIvHIvYsMJnUyRLKTGD/ml3p9bqbvhURLdAkQoEXkPrQv2MWld/Z7V7dC/bH91HOpWDP8Lq/O6ucsfxoyXTsLPWwbaepTKHfWK6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.10.25 10:27, Kevin Brodsky wrote:
> The lazy MMU mode cannot be used in interrupt context. This is
> documented in <linux/pgtable.h>, but isn't consistently handled
> across architectures.
> 
> arm64 ensures that calls to lazy_mmu_mode_* have no effect in
> interrupt context, because such calls do occur in certain
> configurations - see commit b81c688426a9 ("arm64/mm: Disable barrier
> batching in interrupt contexts"). Other architectures do not check
> this situation, most likely because it hasn't occurred so far.
> 
> Both arm64 and x86/Xen also ensure that any lazy MMU optimisation is
> disabled while in interrupt mode (see queue_pte_barriers() and
> xen_get_lazy_mode() respectively).
> 
> Let's handle this in the new generic lazy_mmu layer, in the same
> fashion as arm64: bail out of lazy_mmu_mode_* if in_interrupt(), and
> have in_lazy_mmu_mode() return false to disable any optimisation.
> Also remove the arm64 handling that is now redundant; x86/Xen has
> its own internal tracking so it is left unchanged.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>   arch/arm64/include/asm/pgtable.h | 17 +----------------
>   include/linux/pgtable.h          | 16 ++++++++++++++--
>   include/linux/sched.h            |  3 +++
>   3 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 944e512767db..a37f417c30be 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -62,37 +62,22 @@ static inline void emit_pte_barriers(void)
>   
>   static inline void queue_pte_barriers(void)
>   {
> -	if (in_interrupt()) {
> -		emit_pte_barriers();
> -		return;
> -	}
> -

That took me a while. I guess this works because in_lazy_mmu_mode() == 0 
in interrupt context, so we keep calling emit_pte_barriers?


-- 
Cheers

David / dhildenb


