Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16A40CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 19:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440AE80088; Mon, 27 Oct 2025 15:16:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F0928000A; Mon, 27 Oct 2025 15:16:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B86180088; Mon, 27 Oct 2025 15:16:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 173988000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:16:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 911D11A0257
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:16:31 +0000 (UTC)
X-FDA: 84044850582.24.3FC8B3B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id BD4DC100016
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:16:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E23WllTF;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761592589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=biEqkPiWZ7skPB3ZUYN7GM347nSsM+EvIC+QGhJXhFc=;
	b=2U185pgstLJ75rAwU8C8QE1JscqZPPAlqnnAaxaU/Dlmm301M3UlWpyjJjKRNPkS4xXh7m
	csb5oJiGuIxbXBDgzsqfZy5zyzL8n+62YbKCLFVFSyi1kPcghD3pupCF5nOnFIDr4S9njq
	iNZehzj+ipTngilJVfKC1i9TbkQEqZ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761592589; a=rsa-sha256;
	cv=none;
	b=Xz2UDCM6I3F1+dA0ptOwqwHX1uTTGbU+G9SdLvZ9sRIrIQWZ9VuHgnBoRRJjCv1qyt6TTK
	41xR5jGxdI4aQIGir9hZ1NVqdJ1eKGoCGz7njDTci8p6Hqus98RNPLwpzLEr1i5pFCh3zh
	9gUo33ERNQmYAAWFSG797cicA9WfkQU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E23WllTF;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761592588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=biEqkPiWZ7skPB3ZUYN7GM347nSsM+EvIC+QGhJXhFc=;
	b=E23WllTFh4ZS0xHEMCPWRR4DK9/MfCX9UM+qQNxAN/TsBQCx9ZzzaUrfhA/573fk/ZjnGB
	trl3fgoo0lj+GXFp9WJv1RAM12c046w+ZOtyscudSujmcGqYLWejaTD1gGH7S/r/9IO7Ek
	u3zji3ccHhG6+TUKRqtaLHEuyQnD94Y=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-wDCu1bXTNx-EQbjB5F_C5A-1; Mon, 27 Oct 2025 15:16:26 -0400
X-MC-Unique: wDCu1bXTNx-EQbjB5F_C5A-1
X-Mimecast-MFC-AGG-ID: wDCu1bXTNx-EQbjB5F_C5A_1761592585
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4298b58bd3bso2534479f8f.2
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:16:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761592585; x=1762197385;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=biEqkPiWZ7skPB3ZUYN7GM347nSsM+EvIC+QGhJXhFc=;
        b=TGHB0k4qUQ5NL/cfKpA2a/P2sSc/yuCJzeeScHyCq6y/zqqdg9HjlD01ydmf8zwTdU
         9ZoRMFaVQkxxs2RvdrqXPo7wSCb4ZlB3lwt9tLdhP0EvBkSCelHS29OYMsYUhmBuOccb
         Kc/WGRz1s284YAaDgHxAw4KPRLNM662Xz6mBNtNQGKjIoEOhA5/Y4kM7dP/gp3AT1VMh
         sXFrfThr0NyrnX7xF7H5WLjOIjgw2aHi5BtuotnVSKHN76UGR39Ctnu9u1X5AvyR7rLx
         Kc+SECtELPLR1M/X0HxAMLl6fYl+1HN/AytJPQxhSqbdj/dH2pVlu82yRthpoMcJRn9O
         U6OQ==
X-Forwarded-Encrypted: i=1; AJvYcCULqNnjbzzJpJ6wRMUe/rqbXxdaC+3qfSHIX4LuEqOZBCIKekTjOxnTKomxykC5PW8G0jRK89WbeQ==@kvack.org
X-Gm-Message-State: AOJu0YwXCJD+qDhMppH+tQzGVNdekJ28e2IPlDcb0CGHCZhU67RGyqVI
	Ch8aHW/lUWtFBWzfFK5nSDZm79e01MQlD8salcNzxv+OUG0h/WlLRiSI0PUfXJHBlV4oOaRmBW7
	+lS320XlfIaKTa5MObCBmHfRNRBKN48qwn26x+vYJ7YvPGt1nNXGr
X-Gm-Gg: ASbGncupr1jZmZ8MudmYvXeI/1L5VwnCt62w8ctz5CrOGnaUXoNkm0aTAwNkhbNg5sS
	piiOT4sZUGcy3PH4x1B87BPBiS3mWerF9D+VaR2HmQ/UN7bn8LfkCRj/OsYa7mRjs5TQgq1slWZ
	BIKtF4qGPcHolXh2c/0WAR869GN3EX5GvrIIL98sH7T6jEJsr7NeZAa8P85xtfrSMYugCzUNG2s
	oKMNFxZ3AN1L3Jd0GkgVdRSZ5YwMkrh66yVS8blCVEcDt7KttxX/5AbvqRbAaRmw6ERPTHuXGMv
	jqRnLZ6W2KcIA2I2mte2PLyfU25t+SxN/vgGJcOnOhVL/nFZGfo3sJkC958mc7E0kEMoDMz8kt7
	SN3Qt6sWN2deSg/CoY3dcBxnrFiMsiGOKBz/S5oM5Cgkc4V16nv1xVLXz2l3SspO2gLyMhLInc8
	0x3bBIbfFCUOoNW++CGKnIHL37zFQ=
X-Received: by 2002:a05:6000:2282:b0:428:3be9:b465 with SMTP id ffacd0b85a97d-429a7e82d65mr735444f8f.51.1761592585239;
        Mon, 27 Oct 2025 12:16:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEAbcxPet5KDK4EyDqX4B1ENPi0b55gto2Df397tHLhHRC58HpBYcH56FL5Wv4AO4I76PFYEw==
X-Received: by 2002:a05:6000:2282:b0:428:3be9:b465 with SMTP id ffacd0b85a97d-429a7e82d65mr735425f8f.51.1761592584792;
        Mon, 27 Oct 2025 12:16:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952df62dsm17170002f8f.45.2025.10.27.12.16.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 12:16:24 -0700 (PDT)
Message-ID: <99e795fa-ba7e-4334-98e1-c17ba8ce5e3e@redhat.com>
Date: Mon, 27 Oct 2025 20:16:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Convert memory block states (MEM_*) macros to enum
To: Omar Sandoval <osandov@osandov.com>
Cc: Israel Batista <linux@israelbatista.dev.br>, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-debuggers@vger.kernel.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20251026162156.12141-1-linux@israelbatista.dev.br>
 <811fd675-b231-45e4-b9d5-636fe63bde6b@redhat.com>
 <aP-2x314BKks2_N9@telecaster>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aP-2x314BKks2_N9@telecaster>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yk8NZNag92z6OP5zAww52kQAcDr_GUrpzsc4ksb16Yc_1761592585
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: qinpxmt5co7izuefczo7qn367ef6wtsb
X-Rspam-User: 
X-Rspamd-Queue-Id: BD4DC100016
X-HE-Tag: 1761592588-639157
X-HE-Meta: U2FsdGVkX19QjCowqVm6hx/txEIYDdxpSXOXzkpG4GflmYUvM2yjueZfKE0GqYXZEg9RIxL1T4iYlWmZUz0lf6D8HJmr1weWjeCPZb2V0EuOwZsrVWEcJgaZ6qIThgcOn1a5R3ERTuKhNUgaG03Rnvkne27J2o3LPhM1gkWGZfOAn06DxgsjUlc27QaJm2jKfMR8WPpbQKgmKBcH8ZoHdhMnyjTb27pGpUQqfdnMwaMNz1CSJ9OFAcxedsklvs/GS+4DF79vzrHobO/6QhGTxdJj7XxrraXDPnAkXwfWKuJl8s92uke49Fo1AcTrUm/q+EmU4u/t3Bspdw8cuZCFpZCdaqcE+F894BA4lhADbCmeKfmY2A94x+Xd/uMZW3pSMjHg4m+bHZSCkDrnqGSGBJ4ozCHHziZgU+OKmUaDh/dEXbgWBZs4wfHuZSRf0LsEJwrWRM7+rOPKCJIFR/LTyQAL0+m+z2PUKYcQMTi8g1kramaZ5EyVt+v1rs8iW6Gi/RWcNq/lC8Qb5K5Zde8QSww3FrZ1Azi3+P03HZoAsrJXQEx1oh919qZ7+LQzmBJ7YqTYYGTLZcclbjMJRvr7/+GP3TbJJacZJL57DVipskFo3i7XZ2rRCEoF+MzdGwcgCq+X6JASN4iGLiERRFKLKh74BbcOyhYNZlkaPatwDPRG8Q6iGtperNfsaXd5/jyh4/evsmqJwS0cEO25UrvUClDmXR0hgi269W9Czjjzw2bs24uOs4CGHxQ73GKTa5rw0rukN8ee0sSABaA6zlt957xADk4PaOuZSA/fOLKEw0+bRaoqqh1/K5QOXQxqlJzCYx1QDCf63OFXefd5FvF+VM++ebr0/foLNmiq47ID+V5CdZSFVBA24/k7qKhz5HJ4U/nh2dRWcSODAXQrd3VeG52xeyGV3FNnLTuEFvKbBrnk9N69V/l4m7caeAElmF5wzDZuU6XdNPeU7bQaobl
 0zpjOlUx
 EfIb8oIgVJFxSulQaceDM4CwMQriK3Ugb0qS7VV3u2anGgiNCvA4BjjZ2Z+qDcS1bmPVGxoTvHXtv/WTclZS7522XkVofRtAx+foc7ug7XVXMJfTdy5/aXAcfag/Qx9RHvL39A0IzvKLJU9rJNcAwzv1Hs4qEUGC2fTfzOkJaj3nXqpZC+8d3a12LZqB9Bcijsy2roMoV+jNejGuWbtCmVuZe+78SoyoUtH+YYCSqLdDuiuCXvN/z9NpmY9K2HtX20UWZASddlBTn1bU84tUcSsdcOjfERI0TPB7OI2PlwmAU97ai1GC/ZZ/VT4qEQZVhXiq7dmpPvdArD6drmyuKgl3pjg2K5rRxy8jd/thGn4IMkdeYwvnp5DdaKYzWOATJGb7gvN+2TIc4k4GMAffqQtcv1LVx+a5i0cuDTfbu5S/eljElLj/WuwW+CnPSTHuSLlGQVHdzq/8BdhPqC+bN5/nbvGeikCe+lh8y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.10.25 19:15, Omar Sandoval wrote:
> On Mon, Oct 27, 2025 at 10:29:15AM +0100, David Hildenbrand wrote:
>> On 26.10.25 17:22, Israel Batista wrote:
>>> The MEM_* constants indicating the state of the memory block are
>>> currently defined as macros, meaning their definitions will be omitted
>>> from the debuginfo on most kernel builds. This makes it harder for
>>> debuggers to correctly map the block state at runtime, which can be
>>> quite useful when analysing errors related to memory hot plugging and
>>> unplugging with tools such as drgn and eBPF.
>>>
>>> Converting the constants to an enum will ensure the correct information
>>> is emitted by the compiler and available for the debugger, without needing
>>> to hard-code them into the debugger and track their changes.
>>>
>>> Signed-off-by: Israel Batista <linux@israelbatista.dev.br>
>>> ---
>>>    include/linux/memory.h | 16 +++++++++-------
>>>    1 file changed, 9 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/include/linux/memory.h b/include/linux/memory.h
>>> index ba1515160894..8feba3bfcd18 100644
>>> --- a/include/linux/memory.h
>>> +++ b/include/linux/memory.h
>>> @@ -89,13 +89,15 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
>>>    unsigned long memory_block_size_bytes(void);
>>>    int set_memory_block_size_order(unsigned int order);
>>> -/* These states are exposed to userspace as text strings in sysfs */
>>> -#define	MEM_ONLINE		(1<<0) /* exposed to userspace */
>>> -#define	MEM_GOING_OFFLINE	(1<<1) /* exposed to userspace */
>>> -#define	MEM_OFFLINE		(1<<2) /* exposed to userspace */
>>> -#define	MEM_GOING_ONLINE	(1<<3)
>>> -#define	MEM_CANCEL_ONLINE	(1<<4)
>>> -#define	MEM_CANCEL_OFFLINE	(1<<5)
>>> +enum mem_states {
>>> +	/* These states are exposed to userspace as text strings in sysfs */
>>> +	MEM_ONLINE		 = (1<<0), /* exposed to userspace */
>>> +	MEM_GOING_OFFLINE	 = (1<<1), /* exposed to userspace */
>>> +	MEM_OFFLINE		 = (1<<2), /* exposed to userspace */
>>> +	MEM_GOING_ONLINE	 = (1<<3),
>>> +	MEM_CANCEL_ONLINE	 = (1<<4),
>>> +	MEM_CANCEL_OFFLINE	 = (1<<5),
>>> +};
>>>    struct memory_notify {
>>>    	unsigned long start_pfn;
>>
>> CCing Lorenzo, we recently had a discussion about such conversions.
> 
> Yeah, I've been asking people to send out these conversions as we
> encounter them in drgn, but ONLY when the absence of a value in the
> kernel debugging symbols causes actual problems for drgn. I want it to
> be clear that we're not spamming these just to cause churn. This is an
> unfortunate corner case of debug info that leaves us with no other
> option.

Well, I think we use the opportunity to clean all this further up, so 
all good :)

> 
>> The states are mutually exclusive (so no flags), so I wonder if we can just
>> drop the (1<< X) setting completely.
> 
> FWIW, putting my C standard committee hat on, there is nothing wrong
> with combining flags in an enum. 

Right.

> C11 is silent on the matter, but C23
> made this explicit. Quoting 6.7.3.3, paragraph 16: "After possible
> lvalue conversion a value of the enumerated type behaves the same as the
> value with the underlying type, in particular with all aspects of
> promotion, conversion, and arithmetic." Lorenzo may have been thinking
> of the stricter rules in C++.

Right, it was around semantics.

For example, instead of defining the flags as an enum, define the actual 
bits in an enum.

> 
> Of course, semantically, it makes more sense to use distinct values in
> cases like this where the values are not actually flags.

Right. And that's the case here, we just made it look like flags for no 
apparent reason.

So I hope we can clean this up in the same go (same patch or addon patch).

> 
>> IIRC, these values are not exposed to
>> user space, only the corresponding names are, see state_show().
>>
>>
>> Won't the compiler now complain that e.g., kcore_callback() does snot handle
>> all cases? (no default statement)
> 
> Only if the controlling expression of the switch statement actually has
> the enum type. All existing code uses unsigned long, so the compiler
> doesn't care.

Ah, indeed, inherited from the notifier_call implementation. Which 
brings us to another topic: likely we should see where we can then 
actually used this named enum.

struct memory_block -> state looks like *the* candidate ;)

-- 
Cheers

David / dhildenb


