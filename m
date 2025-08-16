Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FFE1CA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 07:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA9A58E023E; Sat, 16 Aug 2025 03:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5A568E000B; Sat, 16 Aug 2025 03:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D49138E023E; Sat, 16 Aug 2025 03:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C301D8E000B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 03:50:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 651E358C9E
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:50:00 +0000 (UTC)
X-FDA: 83781846960.11.435014D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id ECC6514000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:49:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="YT5WM/+n";
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755330598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=17PhsuAKsSKCbFAc67SwRG6K2FiDsT7yekkoNHVBnxE=;
	b=OBB77d0GLC/oYR+dYJ9D9JwETDdtOWYH+awoEIy6VYlWjO6pZk1zhhSYcTNmejr0ivxAhV
	UvJqyc6cbNK2E0LmbctSZN9DMf1KmOpAsvTiXIWUqM2Huq3BYTun8iIuRBwXe1Jlm2OryB
	PvB7tjOKUH9IkO+Svxaflhu0ZCViHVk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="YT5WM/+n";
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755330598; a=rsa-sha256;
	cv=none;
	b=bQBMZKROv3+/lcp5zayeyNr0H4Jb+hE8j3IFIDGGaYHGId6DwUa7aK4MosX6Twe0Y/nmt6
	ehLmrn30Xz8c1qOEAIj9CYoXYMKxiWsIlrCqu2wjoL/uC777DMz9RwMyxQrz+7UsBOLiz3
	Nm/KLu2v1AVlCj4QRR0sJS8BaIJpeD0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755330597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=17PhsuAKsSKCbFAc67SwRG6K2FiDsT7yekkoNHVBnxE=;
	b=YT5WM/+nakEIQeBpBCROqr6sWdEOISVSM9SyL9yxfbPyOOgyUXP9/FAs6/8GS3i8gr/lZf
	oze4xNsk/QSm9zY5t/MB/us8MpMcNj6Y4irKA7j+RWx5QWpPZFP+kHhw8nPt7LQf8U8G0M
	z6HNSdliavlPtgvSPQVCvSpg9bsEsp0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-341-Zn-MHR19PE2lZ4WCvgOkVQ-1; Sat, 16 Aug 2025 03:49:55 -0400
X-MC-Unique: Zn-MHR19PE2lZ4WCvgOkVQ-1
X-Mimecast-MFC-AGG-ID: Zn-MHR19PE2lZ4WCvgOkVQ_1755330594
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b9d41b779aso1656608f8f.0
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:49:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755330594; x=1755935394;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=17PhsuAKsSKCbFAc67SwRG6K2FiDsT7yekkoNHVBnxE=;
        b=U0mtsPbbb8xf3Xj2xk6zbeyCMpWsmweEIJQI06QkqPYLv4aw4uWOM+A+WW4S0t7IXk
         iOjpldUqJ4f3TCrUQUSOMUCYr1mURJYklooD9Q2+pm2JMKWy0ImPmsDPnVBEjgdmbDtA
         1893euduHZGCplff1pkrdx2YX8iTd6PtggtKGb/NQnGRVkdz8EC1DAanQU4+R2xgKgPH
         43NI40vgpKxvtYrOWFlNuMoXFlxmVNJdo/PPfEHpyG7PK/m3L6gPv/kpewG4Gcya+Tjy
         MeYiVDjodrXl4mhvDjvU3GseACwV9qSu1ZBDainQ1LHEmEvAnifAIX8K47eVk23ftqvY
         QVrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUnucsR8cFCtZ0G5MWOEzTTPEnWL+uks3EY2CgpAGsEeZSGw7Z1K2K3TbC1F7KdlIGzTKLrCEoJWg==@kvack.org
X-Gm-Message-State: AOJu0Yz2VRBOFxekauySoh3YZihTrVIS/xVTBo+Zykz+/1ffYHIsb/+4
	3FPXCUfq4n1PO8ne2YWrxVjOxKIWz8nO3tcBMTEtxOkUzb2wdtKjRHLUYzDgXH6mimiMc3G1uNN
	3rDZT0mv1b8FE1q2PR12vDa1Gx79nd9wKr7EYIi4TlhF7LeQJz8kp
X-Gm-Gg: ASbGncuqRPZWcvnKNbnwoJoifVqH5TAuLU+X1yoRSSXmOHcQaBDYZpFuHLzi/3Rufjj
	FrDZolYKaWtrWjVlOwRYY0B+zxWMeiEu1N0nppYxH9i+00BV6M42B3TA33+NWp75RXGXuivORAY
	Fe2naZxtRTxtaLdiNJyJ4Y8hGX7E0cI6mXEPLJb7e1Od9d5nT+0s+cZ87v0rL0x6t4wJIr+ylL4
	dth0NRNm/FzbPLxC/W9juSepCBIzq3wyeUXDWWSFiqqZdCZloXjoYXUHFT/ciQGjzvn/kjkHeSJ
	d0B26Edhi1TaiklJm3j18C+q8C0tKYskxYMq0/cMAOYT+qBy+D9THhLrh/8f6r9/EBWK6bwtgMO
	b9/r8/4/r2MlsPUsm5AUJ9oANcjilhaphiF1ervoeqnMD8EHEjbCSPAnY02W8lW/g8A8=
X-Received: by 2002:a05:600c:3b09:b0:459:dbb5:399d with SMTP id 5b1f17b1804b1-45a2183d324mr35149095e9.19.1755330594441;
        Sat, 16 Aug 2025 00:49:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFBpn3b3LLsYpviEIlgcbkyUmsfqPLLDuIIrOYOdct8HP+3se8zsc6xjWIyVRDTQ5Qc6vOrKw==
X-Received: by 2002:a05:600c:3b09:b0:459:dbb5:399d with SMTP id 5b1f17b1804b1-45a2183d324mr35148875e9.19.1755330593820;
        Sat, 16 Aug 2025 00:49:53 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:c700:d8ae:41bf:492a:9e4c? (p200300d82f23c700d8ae41bf492a9e4c.dip0.t-ipconnect.de. [2003:d8:2f23:c700:d8ae:41bf:492a:9e4c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1fe2c019sm66592525e9.17.2025.08.16.00.49.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Aug 2025 00:49:53 -0700 (PDT)
Message-ID: <167acb82-1368-4c8e-89bd-8dbe4877d5bb@redhat.com>
Date: Sat, 16 Aug 2025 09:49:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/cma: print total and used pages in cma_alloc()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Xiang Gao <gxxa03070307@gmail.com>, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 gaoxiang17 <gaoxiang17@xiaomi.com>
References: <20250816042842.3959315-1-gxxa03070307@gmail.com>
 <ee29262a-911b-4a97-b619-0dea3b657252@redhat.com>
 <20250815234528.882ab58247cefc96e4137811@linux-foundation.org>
 <701bfbb4-6c12-4614-a322-def3ca923c78@redhat.com>
 <20250816003418.b2a62f6ddbcf9468fde87a18@linux-foundation.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250816003418.b2a62f6ddbcf9468fde87a18@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XW2kyg5lDMUdzEV3K88-LrmvOrv-LqFNnuAFWdYkigU_1755330594
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z5fc4wy1q44u8388i79uyiowj3nuu8wf
X-Rspam-User: 
X-Rspamd-Queue-Id: ECC6514000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1755330597-396355
X-HE-Meta: U2FsdGVkX1/hEzkr/owAq35CNO3peZ55Z6Wpz0JxkJ/7W1uD2OT7ZTLFliSL+KrPoMz2gUa81El112w1na0j4qrDBzkWmpOfbs9x8b+ig/ThjwyEK0C7fcvWjfGZzBxbDSKL8FEQ7/lvNvQWNTiYQTkvzkLwlHIJqdwAgeSz6N2mAjfyhrwHGEUpxmWDOJnviYiXu9RP+7ZXhP0cj9sv5eaFY2wb3U4BYf+sQORujOmJtEZyL0XR5kCVpGInheid9sls7w0SciRidQw5qg06fnvRp/bMGIgG9FDxouHbSiV9NfPTWFl25zhtishwGXocS8Hf3tm8EHF1Ld6gFL9Ka9yPTSebb7WuBq6kQZUK1j+IjDW2lNu2QfdlN4bIRtvtpHVETyVKZeI13tEN6gcUgrcSmYTQ7Zbzw0k3KW6ytl4WkbvWZKs/LSkH/aODGRcstFzHf6JA7C+9/xajE2TYAuGYSWjrskFq8lzEz25BUz4oMjX+Pldsy1XXeE42rtWYJkPgy/7dxkf7RofZhkVNSrFh2pxQdZ9qQ6Yn5Lk/63ut/5rQn+qBSrz2h86x2Zq6/CiBV4PbW6XIZgCO+f7lL0Mlq8V8mM1Qn+v9zMe6H9XBS22QdqTHjnOwvL7TTTHBOBfUGN1rr2a+1BvcIHoxKaPa9rDB75jG0nbHzlQfRqwwI5cS//fuKvpjs2FpXiMgqZFx0Iksvm5XfMi8bhN02siJWX2AnsdRk86KIsN7we+/MkATCm0B0Mt81ZQU/kREbZI/i+ssiBzyQBCQWH2X2Ih+GlevQF6hDeNIjymRNITSuKQt16KNoMSQYshikwu4SuB7sKaVtDv9foxAAcMJSU06695w92fgPQEndZO3Rua+Bu2W95vHjQrdi2fCKocTqo8+Ik/gtkAouIwl4yfdsU8Re8WCmKvfE0wz0tgx36c0phr9QWaoqZr/HXhnu5DTZ4UX5RVS2BifamKEYbu
 4Acg6b94
 o/lklZMNxnkG1LhZ/hNb8ZZ4AJYQavgmbD0Rwp6keAyVa6taeTEMjS+zztrlmZSzNjrAhnVARxfFmarBAIZYVqSxSE5PwkSWZPS7bxlwVRwKwJCT4tMi1x8SM3b2BPquXO2oGOOIKIJFYeFlTOem0OqfEbrtfrhIHj60mWjMETv6+B6tYpu4R3ybNRcXp1S+0eIuLcktKRnETfTsUO0BXruql02qnxKIGEEuHEXn04Ik1oFo/m5dQ+Y9P5JyFv3uNe+FtROj7qPE53rsnrDKgoIcOH1qQaLiwLYMOP6U29qJIGffHPrk0hca73qwEfFQZOTHbnX7WXAmG10xQKA4A5SEZnUN5gI/bbqPmqCVWhKPCXK8e5v1ViPas7B1qOMjf1gTjbjYF7avwdhBSdtU2/CpvQKs++EL2CWxOL1RpeiuR8kVD3gRVVQ0pKj13sj4VX43rVtEFBhWCZLni87ltykQPeQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.08.25 09:34, Andrew Morton wrote:
> On Sat, 16 Aug 2025 08:56:47 +0200 David Hildenbrand <david@redhat.com> wrote:
> 
>> On 16.08.25 08:45, Andrew Morton wrote:
>>> On Sat, 16 Aug 2025 08:27:39 +0200 David Hildenbrand <david@redhat.com> wrote:
>>>
>>>>> @@ -858,8 +869,8 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
>>>>>     	if (!cma || !cma->count)
>>>>>     		return page;
>>>>>     
>>>>> -	pr_debug("%s(cma %p, name: %s, count %lu, align %d)\n", __func__,
>>>>> -		(void *)cma, cma->name, count, align);
>>>>> +	pr_debug("%s(cma %p, name: %s, total pages: %lu, used pages: %lu, request pages: %lu, align %d)\n",
>>>>> +		__func__, (void *)cma, cma->name, cma->count, cma_get_used_pages(cma), count, align);
>>>>
>>>> 		^ one space missing for proper indentation.
>>>>
>>>> But doing another spinlock cycle just for debugging purposes? That does
>>>> not feel right, sorry.
>>>
>>> If we're calling pr_debug() frequently enough for this to matter, we
>>> have other problems!
>>
>> We call it for each and every actual CMA allocation? I really don't see
>> why we want to just randomly make CMA allocation latency worse.
> 
> pr_debug() is 12 million times more expensive than a spin_lock()!
> 
>> Is the existing pr_debug() a problem? Maybe. But who actually has debug
>> messages enabled in any sane setup?
> 
> Nobody, clearly.  If anyone enabled pr_debug() in here, they'd
> immediately have to remove those statements to get any work done.  Kill
> it.

I just learned that pr_debug() on a !CONFIG_DEBUG kernel translates to 
no_printk(), which is just a mostly-empty macro that doesn't really use 
any of the parameters.

I would assume the cma_get_used_pages() would get completely optimized 
out in that case.

So, I don't care, but ... moving to tracing seems much more reasonable.

-- 
Cheers

David / dhildenb


