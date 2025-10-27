Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CE8BCCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 19:17:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6DE180089; Mon, 27 Oct 2025 15:17:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1ED08000A; Mon, 27 Oct 2025 15:17:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0E0280089; Mon, 27 Oct 2025 15:17:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8FDFA8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:17:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B70116025B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:17:11 +0000 (UTC)
X-FDA: 84044852262.02.4401EC7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id D01D4A000C
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:17:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L06HH0sP;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761592628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k68tctDaos2r7S2/tugCy531UZpNh5YbiETzZ7k4MIg=;
	b=OKE2qNlGQxr/JGHyROeshFx9esor3ostSI+YGTFO0jGMT7IwgSJLRVbwvrGUgvLaAZFUaO
	y+DkbcEkIhQofSizMYQriKwQrNVGGn/v2rlI5XqygpIKBivFoP3RZG3ExyBHWOLNy5hd5D
	OdXW7/QEKa/7wXH101xaukQBFz+llkY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761592628; a=rsa-sha256;
	cv=none;
	b=EUKRsFqNi3X46sccOo2vLBZ8i3sk524tMQuQCm0afyp5FwF6CC30/9O48y0mXbZ8mHL78u
	AOKdeTtqSrcnkJzFrOuAUDkBsxilUDiG4hO8zqFE83zc2pCW2VRC2iYIllAE0hXEXTxH80
	Pq5z4vYk5ziq8WUC7KBafWT2frOSWOs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L06HH0sP;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761592628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=k68tctDaos2r7S2/tugCy531UZpNh5YbiETzZ7k4MIg=;
	b=L06HH0sPFF6XFmKkFAPmCZl0LXh6NxJOwo43e+0RBKHPDl+PpiC+6XYx8RLIP+pRrGR+zn
	pg74Rj7xaRSjjLHaulLtq+q6J1CB23gLXupgGA6uB3QnIuxvYOX0UXryIsgHEIVgaRxz1O
	wkSPWGnVUyaOD5zOss8QPLlGPKef34k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-EimZ_bR7NzCQGY-DCwZRpg-1; Mon, 27 Oct 2025 15:17:06 -0400
X-MC-Unique: EimZ_bR7NzCQGY-DCwZRpg-1
X-Mimecast-MFC-AGG-ID: EimZ_bR7NzCQGY-DCwZRpg_1761592626
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-471001b980eso31913195e9.1
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:17:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761592625; x=1762197425;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k68tctDaos2r7S2/tugCy531UZpNh5YbiETzZ7k4MIg=;
        b=m1W2k0zAuJcaLWjAU5CP9Tg+rR1E4W1umqw9XoeYH+25/XbN9gPBbeHfu5KEQt1SuZ
         06UQZ05N112BYD3eyy2Q5YNL+NKDmYFhymf8LL3CAfhCFWKirGkiDjYlZngpuzF6Dw54
         /yY/7VKgJMKRpZ1N9JIh6swciyBHEdYcbissJlHsnXxvMZ7Rir7MLX+/hG3TM5X77klc
         z3NtHrvtih1IKltDTB9DRdju4MNXdynujgmUGh7oeQj/mOwumU9tdKdE+Z6D9VRPM3tf
         +M4DHVB/3ddrZtpnvAJknCFZaaqJW5pnfcOh+RunaDO5+J8qaY9EiSowXdgTggIyHtTC
         fVsw==
X-Forwarded-Encrypted: i=1; AJvYcCWTxGtUfKdO4tQmwaPDtflj+WdYMZMoM4/5D6bR/rCX1cVKRa5N5jD5/OM9dF9AaBCy+wC5JjFE4A==@kvack.org
X-Gm-Message-State: AOJu0Yz8ysTWfvVXNJyr7AaPr1d+sWYCuRPldJkGUxRD33hNCt83Ogyh
	Cgxpu/iWuhJEQ6UsJfUid5UQqm3m/SnGFRrSls/N8REXsXaCXCTyyghS4+30rAJg+L5ac237zfP
	Zydozl8+CWqdDw2HeJqTwcgL17b1CAzOcaAx44rZJy0VWTWPnEuBH
X-Gm-Gg: ASbGncsNuWQJtdjcr1znXJ4guzrQ8RXngIhe25viY7vluYh02v/1BTUyQ4tctM4Apw0
	zRdMhwAxqXuQu1j6eJGpXMwM7sxfkr04/B8AVdOLavjATEwuK5IQ9fNLdTrDtxt4ncqYn5OZOfh
	yGl0knE4GLnXj+psJHL7rWh+LVPGXBq9Fic4J8VDeHMM0d9h0WBb/0GkIYfg4VFgnBjOiCcYX0Y
	ECysgUskk/VqEwt8ftyJTOBx71vzF77fYypek2QpZNduHG6d0Chq6cF4DcfX4FLzz5gIBk08nnq
	Nu/TIWTBCN2XR9txRPGNnmoX8JWu/yIlAC57T5gIDUCOS//kf4tuG5nNPFVM0yIPtgHtD8AhR1t
	BgRQrj9qwIMfXKYxGGi6hSO35Jzo1Nd4gBl3M2nVR1yJiymIr2rweE4IjpXxWbG54w1hPD9XXKi
	X9aSGJwB8Il5cGCcdAvy69b0tzOJw=
X-Received: by 2002:a05:600c:530e:b0:475:dd9a:f791 with SMTP id 5b1f17b1804b1-47717e41487mr7111795e9.28.1761592625634;
        Mon, 27 Oct 2025 12:17:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF6A2ms8gZTaN5GeqRUQRthpN1XLh7Sry8dQ+oUPP7Dy1GpsfL+yHR8GnCvPgFOi8kufaaMnw==
X-Received: by 2002:a05:600c:530e:b0:475:dd9a:f791 with SMTP id 5b1f17b1804b1-47717e41487mr7111525e9.28.1761592625179;
        Mon, 27 Oct 2025 12:17:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475dd4cc596sm155530485e9.15.2025.10.27.12.17.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 12:17:04 -0700 (PDT)
Message-ID: <e899be34-ba23-4769-b159-2fa85e1c1876@redhat.com>
Date: Mon, 27 Oct 2025 20:17:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Convert memory block states (MEM_*) macros to enum
To: Omar Sandoval <osandov@osandov.com>,
 Israel Batista <linux@israelbatista.dev.br>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-debuggers@vger.kernel.org
References: <20251026162156.12141-1-linux@israelbatista.dev.br>
 <aP-3dauwpc-Kq5Kh@telecaster>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aP-3dauwpc-Kq5Kh@telecaster>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ezq-dUYD3-rx_dI5_24neLywSQSU-hsTckNx4MRd2cg_1761592626
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: sio7difzy16t9oecuhfeerea9m941hhi
X-Rspam-User: 
X-Rspamd-Queue-Id: D01D4A000C
X-HE-Tag: 1761592628-288398
X-HE-Meta: U2FsdGVkX1/agC+EMLHpvunvoAi84SFZO2LPrpKGqlWIxYZIsd8xoWKSIcFzafGtcJ5cQ8PNozXj/lIj0V072mV3BWANKpu0jvq5DD+OKeHiDeMBFLoEw6BradrwSsvD5EDjG5KKooJ5U+iW/Vzo7k2BmX4jDh2UmFcVuFKDKHAnGx/h/pXWSWl95oDJ0zMvrsVZw6GHrv4xRryGl/eyWRmp+64vR9uMbtpBTsYpNVtRt3v2kykofB+vYtTWTovxviY/XW8RlQpJIH3y3KCGG2Ff/A6+VMPW1miQbkaumUUbU6shyU5FpM7bW2wmknAeZUGPZB5TDw9fy4Fd79ClcegjRTI4tboummWJybWxSM/axs2QVKbSVTtPKFPW9bowqdOt1b3eUGN+9qLQn5l1GXsajSIsvtnMol5FsUx103OG6EuepuBxTG/80I9vV1sD1mGI3on/qb0zWk2SMgnIQElBxoE7kJZBG5WmaMO9NtVaIzQ6CeIprkEaGFfiprqFuxDXAHdU4o6ECYTpTc1prhO1ojPUvVVIpNXNBlcjbZA4ypRaJkbmNy3WiA6S74WqSlpCl7wNBsUt5miZoFlwhE04zYQShVYwFhEXpOeuiPChWAzcpiVFFUqZSptB811GE8Ql76AepBTFQUX9KoxVm8bAF8XAjWIPPg6dtwILqSCeLYay4vu/Kh4OAhQQvLwDrtwU/BZqVmm34yRG++keAzaQ5tcnL2qGRZYmz41zG7HI9zhb2XMdXhBtxkXdC/otRQhW4G+GbC6/Me+RwnFOYez4uunlcayToisBRgKrZvHBzKHbFwxb2rlV3elX65D7nvK31TQbZRgrUaDAAVnBHseKD5n/oPWoOsnp5p9Dy61UJ+jXV8UIPoIOIRYpcK21K53MOUzsz7jw9f/SqNOF7fxhC21rN3Itw9NKygaWjMRfvCGh4NyE5BxUfWm4hidFOsOxbNXuYSzE2gIXuzQ
 MTAzgrkv
 0nclt/2N3jNrAbMI93RxDYt75NflAHkB0U5Upw/AB9rT1J3ZEvFrmgl3o8htOgggDQ3S9CouUrMjHOdRDMrp+oNcZBFF0Y1sMCkgYSbcY7ELpDjy3aEuAyMrmJoeAqk73+wr63LpoD1Khi0a+AX8NSqiILgIybwbGQ5ljuphPoBH8xXbd2NfYF0ASfeEN2GRY7lNO2SzhC2Sa5Tua1NnqbXWM+GRFl3ApbBp5qBvnegDiQR5t/wKce67rhWZXqm4xtpbnU9VPCfsA8mGHLQ+wmoeKRqMKgD0Qpw0BSMHd3njDF/LrRb2pCDJt/ghwkJavLayW8Q1rHvZ0l1PR0EQi7kGv9slrat9a1ZZQcOLFunvqx607AcJ8qeJ0RoQYvNcYYDzCSoyTj+Jt+ZR/yLFvGrTu+pPbadx2MC5U+uyPza9GZMh7OvArCltaPDDZMde1mLxt8BFOtDcvDfFn8P0FtmpX1NT3JAdPm3i9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.10.25 19:18, Omar Sandoval wrote:
> On Sun, Oct 26, 2025 at 04:22:05PM +0000, Israel Batista wrote:
>> The MEM_* constants indicating the state of the memory block are
>> currently defined as macros, meaning their definitions will be omitted
>> from the debuginfo on most kernel builds. This makes it harder for
>> debuggers to correctly map the block state at runtime, which can be
>> quite useful when analysing errors related to memory hot plugging and
>> unplugging with tools such as drgn and eBPF.
>>
>> Converting the constants to an enum will ensure the correct information
>> is emitted by the compiler and available for the debugger, without needing
>> to hard-code them into the debugger and track their changes.
>>
>> Signed-off-by: Israel Batista <linux@israelbatista.dev.br>
>> ---
>>   include/linux/memory.h | 16 +++++++++-------
>>   1 file changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/linux/memory.h b/include/linux/memory.h
>> index ba1515160894..8feba3bfcd18 100644
>> --- a/include/linux/memory.h
>> +++ b/include/linux/memory.h
>> @@ -89,13 +89,15 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
>>   unsigned long memory_block_size_bytes(void);
>>   int set_memory_block_size_order(unsigned int order);
>>   
>> -/* These states are exposed to userspace as text strings in sysfs */
>> -#define	MEM_ONLINE		(1<<0) /* exposed to userspace */
>> -#define	MEM_GOING_OFFLINE	(1<<1) /* exposed to userspace */
>> -#define	MEM_OFFLINE		(1<<2) /* exposed to userspace */
>> -#define	MEM_GOING_ONLINE	(1<<3)
>> -#define	MEM_CANCEL_ONLINE	(1<<4)
>> -#define	MEM_CANCEL_OFFLINE	(1<<5)
> 
> What kernel version is this patch based on? It doesn't apply on mainline
> because it is missing a couple of definitions added in 6.9 by commit
> c5f1e2d18909 ("mm/memory_hotplug: introduce
> MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers").
> 
>> +enum mem_states {
> 
> mem_state is very vague. enum memory_block_state might be a more
> appropriate name.

Agreed. That then nicely fits "struct memory_block".

-- 
Cheers

David / dhildenb


