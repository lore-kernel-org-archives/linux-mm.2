Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C626ECA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:51:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 584778E005A; Mon,  1 Sep 2025 09:51:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50D1B8E0008; Mon,  1 Sep 2025 09:51:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 388A68E005A; Mon,  1 Sep 2025 09:51:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D5B68E0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:51:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BCC1C86043
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:51:01 +0000 (UTC)
X-FDA: 83840817522.14.3080045
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 72DB540004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:50:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YJ2L+rdr;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756734659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hQXxZK+8L2C3hWSBdyN50IL5R99xW41D+fHSrVTbeg0=;
	b=OfPwk5Mu8Ysc3K0PfC5rsG+3/h6Xs2GFgGOgM/faBfq5qZC/HnsRd1xCUbOHVa37LPdYJ0
	Riu1RmtwG7RtYvyRd57VqSyBwFoV6BHk42bNHkbDr9uDg9WnBEavUlP8n0QTgnXsam2iTF
	duMieuFZe/T35Dlz2nxkWuHfjuXo8TA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YJ2L+rdr;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756734659; a=rsa-sha256;
	cv=none;
	b=H4NTQQELXgzfgf+q/Nd6mPWgDpjB+Pw4M9XPaMiGcxDTpZ0RXEKBsAv1xCv4mH3Kw0vzCk
	zVYlpTs1zCTOgfHaKN8OFsdsnhkynzut6MltzD1GcQ9EcAXhfsZlsinD8bj8b0kHWLoxgB
	52LQP9HI8/czxuQ3daR+r69NiYJHpVQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756734658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hQXxZK+8L2C3hWSBdyN50IL5R99xW41D+fHSrVTbeg0=;
	b=YJ2L+rdrgyopCpZEc9ycZ3dEEaheL+lrIWv74GVP6JN4AySRjSu0nUHACIqGHs8+UXhUp5
	NjJYv2qpMsBGbcIaO3LNmkA66OGyAysPtXRAuxz0D8Do92ZHrh/s4BJ6MDUBDnpsp/U7pV
	Ervow8oVFlA5XZVwQO/9QY8vIgBaGog=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-qn1SGG7wPIGOSUToSoJ2Wg-1; Mon, 01 Sep 2025 09:50:57 -0400
X-MC-Unique: qn1SGG7wPIGOSUToSoJ2Wg-1
X-Mimecast-MFC-AGG-ID: qn1SGG7wPIGOSUToSoJ2Wg_1756734657
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ce3e098c48so3030797f8f.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 06:50:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756734656; x=1757339456;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hQXxZK+8L2C3hWSBdyN50IL5R99xW41D+fHSrVTbeg0=;
        b=VWugNbWQcP0ba6fhYElnl8WTGE8RkuXM8cbuy/8ce45g+XlwLM0y0gSUJNGjacpdhY
         VQN6dLSrkbFRvFaUUgXEVdy5yjmWoAov/eu5Wxaiy5YaxJOoTh6lrDuBh19fUgGtmMPa
         LvbMvhWw0yY5Gfff1I9BXvyUmp448oMsz9I5BpsYYnwZGpmICp0L1qy94pmik1uTGzta
         kZaV8sgTcynKkyv0u1JJrNcBQmfLk+RSs9Yt6l3utoyEow2eNuNvTVOW8YmUXurp+87B
         dOc2aMh9+jpjvxXg+9AUkoEoyW2drEHVy1QCslFc6p8hbPjbwlMTgGjnYFmI0Fu3skU3
         esNg==
X-Forwarded-Encrypted: i=1; AJvYcCXyQNALmxrMr4lUV0B7DP+dQMv6lUXcVk4BRgpgLeTVZt1D1FzOS9X00Cl/Rwo8Bz+Zo5oyHYE3mw==@kvack.org
X-Gm-Message-State: AOJu0YxuWGB2YWiGN32zkLhegkB6HcMsHLriT+nKleaQrCgsLoJX2msX
	0DgCppU/Dw2+qDqLHQlotMzAE/cUgggbfaPsv18Ou0oHMS3OCXeU8C+sRqnmAAAUoK7gSl9U+bb
	60Qiw6DlOLKGXOfXXviiytm165R2XXcxYqLF0pPscCBahF8Z3r1EZ
X-Gm-Gg: ASbGncsZtmPXW7+CMjhE9t5PLWJVLJvVBAX0OW8XNzVb70sFlxyd9qbeJ0ZVqtTXFlx
	EV/gxQrYAaVXXwHWv33vcoAOm86sFWMhTtS+JhxefrwrUs2tlPupVqctTCzYkx8Ifqw0xZqSdBG
	tGuKiwQjgZYSif2FIOKeJScM4RtwJoN8NJJsQE9Od080XsGmeBPw0K92TKPkNRJpQ9zYZytCvdx
	7NdykS07n6fXV8kihVzFHYELp24VIcqdpXpGLwe4EWcr+T6zri+5YjRxPPVgQnHpKtlLvYvDnNH
	BrIBnYz2XpKtMDWKUFLU+u5E36AmSpYrr02px6+EcMK54Jv/36fmfrdNpoka4+1vQGOz82Imnf0
	yLwat6QiS4LYJX0CHu8t7CPHs3rbQkWFhH/2EhZB2zBKJP27SGeJlxE5BEMhKTf4/Mv8=
X-Received: by 2002:a05:6000:2911:b0:3ce:f0a5:d597 with SMTP id ffacd0b85a97d-3d1e04bd373mr7157134f8f.47.1756734656294;
        Mon, 01 Sep 2025 06:50:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFyqfIPR3UJ0zeZzVPNcpmMbRimqvxcPDkH6oxy2lkVv43ujDLnNBQGZh3mwvE2LqGlafZAdQ==
X-Received: by 2002:a05:6000:2911:b0:3ce:f0a5:d597 with SMTP id ffacd0b85a97d-3d1e04bd373mr7157088f8f.47.1756734655808;
        Mon, 01 Sep 2025 06:50:55 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d26f22f5bdsm10012660f8f.37.2025.09.01.06.50.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 06:50:55 -0700 (PDT)
Message-ID: <25a174fd-9513-45c4-996d-6427860c2059@redhat.com>
Date: Mon, 1 Sep 2025 15:50:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/12] fs: constify mapping related test functions for
 improved const-correctness
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
 linux@armlinux.org.uk, James.Bottomley@HansenPartnership.com, deller@gmx.de,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, weixugc@google.com, baolin.wang@linux.alibaba.com,
 rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com,
 broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com,
 mpe@ellerman.id.au, nysal@linux.ibm.com,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-5-max.kellermann@ionos.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZoEEwEIAEQCGwMCF4ACGQEFCwkIBwICIgIG
 FQoJCAsCBBYCAwECHgcWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaJzangUJJlgIpAAKCRBN
 3hD3AP+DWhAxD/9wcL0A+2rtaAmutaKTfxhTP0b4AAp1r/eLxjrbfbCCmh4pqzBhmSX/4z11
 opn2KqcOsueRF1t2ENLOWzQu3Roiny2HOU7DajqB4dm1BVMaXQya5ae2ghzlJN9SIoopTWlR
 0Af3hPj5E2PYvQhlcqeoehKlBo9rROJv/rjmr2x0yOM8qeTroH/ZzNlCtJ56AsE6Tvl+r7cW
 3x7/Jq5WvWeudKrhFh7/yQ7eRvHCjd9bBrZTlgAfiHmX9AnCCPRPpNGNedV9Yty2Jnxhfmbv
 Pw37LA/jef8zlCDyUh2KCU1xVEOWqg15o1RtTyGV1nXV2O/mfuQJud5vIgzBvHhypc3p6VZJ
 lEf8YmT+Ol5P7SfCs5/uGdWUYQEMqOlg6w9R4Pe8d+mk8KGvfE9/zTwGg0nRgKqlQXrWRERv
 cuEwQbridlPAoQHrFWtwpgYMXx2TaZ3sihcIPo9uU5eBs0rf4mOERY75SK+Ekayv2ucTfjxr
 Kf014py2aoRJHuvy85ee/zIyLmve5hngZTTe3Wg3TInT9UTFzTPhItam6dZ1xqdTGHZYGU0O
 otRHcwLGt470grdiob6PfVTXoHlBvkWRadMhSuG4RORCDpq89vu5QralFNIf3EysNohoFy2A
 LYg2/D53xbU/aa4DDzBb5b1Rkg/udO1gZocVQWrDh6I2K3+cCs7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20250901123028.3383461-5-max.kellermann@ionos.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3SompFfdp94fwpenY4EPV9MCLnsXDlASUhShS3tEY6Q_1756734657
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: das8a5pnyymuu5krdseuf31xtc9tuos7
X-Rspam-User: 
X-Rspamd-Queue-Id: 72DB540004
X-Rspamd-Server: rspam01
X-HE-Tag: 1756734659-996130
X-HE-Meta: U2FsdGVkX19HNoaYCXcZc29wjs9Vr+HP1zkgZYiiix6o1SSZex93yvU+vlb27K8XP81DvVQ5MHftVX4D80NRhgPphOIPa2QAEgE+exvVRNOdZWMjfGjHiJyt8eI1qXqrpSTxYkm9AHRNj8raQxWhtsjSWEfGKs6Em7u/BzmA9fB/m9mFUUWei2ZgM9UCD8f+OWFWvphO35gUbd+6W/CROqmx4aXWod1+6DPhHG6gC0rBm0ZlXar2Q7VL0YeL2fH73+lDDI3LEkLU1WgVW41ey5fvNFTpfKu+Xx0ij2WsWPlI8qOFmPjA+8HSR08/usZZlfsCDdtlh2FRm3e5ZnLkGR4WbX0JpcMtoJ+pfcq/n7585wViR+fEKgCgokjN8CPhcNZC2zEvRZd5JGbKsIXXp7zlaVAjbUKr+BgvXd3kPnuZUmGgqkNZhHIRD/hPuHIpjSeb8zwWH/3oR7iDufTe0aw5N5WA11EHtC0AZ/Bw96vMR/u1sdO3kjlIF1qjzJXDHnBBaliwVYUzj+bXvqkoZUCOWnIj5FkqAgtYqY9nF74qu9m+eN5OURa8b4W/bXSrF1c1fwplGWywPeaorFgRY2pZFug+NZzv8uxQKVxvvM+mdo4zHSZMQGJSMnpNY28m6RzFF83Aq+oVlKbS/XTm0RlzfIdml9wJVqQCaXO/PvxTpQFNLTAM5Sxgw3eTkYd8YdftVFdHJnybQ4uKdTwiR/zXfKg7IoK7vSpBO5vHAE0EfEdWAJsuD3A4jIsHf+bbYQ3vw5AkXw7+wlVQmsEI2KTdrhPX9qWYQPmFE8D1eBqiXXxZgPs264req2KiSyW0dMrnHxtsX7i3vhD4bqQIauB6X6uRxtjPZojOXF/ghUZgttc/JGsij10ihiAUbTJaU7U16RL6nqBJhE5c/UlPSC14TrGYJ0tScYHxXE8UQP/99KLs4ggAaQBvwYgK2/gTVV8jWGZ4/u1K6E+fHIE
 t/h+o0mR
 92aQT41IIjRTn2zBLbGBggMA2SLdtxsA1MyB7nR1WnreN/e+0s2oC4FeZDUsWH53dNVFhynvoRa8O/AA0WQZE3LCbMQORZKYPAcuTSHi3Z8ZuIZwGOaE9mT32IUv0XpVp+QCObPnaGL/DoPEJ8g1m9mqHzYac7Xr1vHT8YKwPozohuL2Y0ocghpUk6c9Tf49wiP14Vp+cv8tWxAYZDRXnJ8qLLb6YI8dM6MO46rW1pmCBQ3xYVLz1Dnwlc1tOAKyj7gVnS0wsNZZudDBp8UzWtjFLbYJrXQMnCNCkTH9EFeVK9gxkWROaqP5lyw27E4YC5iDaW75s5vujyDfITFXZ38gnZVgWP29EMMKReNJUeL5gmURww/v+dnvwbhPpa5XaY4fZwXGXM9u6BC61i8NulhZIAIUFNRsgimOESN9gGv588mUV6ajeWBS2Bnvhmqsv3VhM7MaRKH9/OphwdigSyd0LtQU+0ELFHGa60ASg8cLKg/ro6ZoRoOApgCIKnobfWWhGNxyoJT3Vnx5OCu9bFafCSCoVOweC/49bDE7cLB1rfABQ1yny1NztDRGPGLAUS2f3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 14:30, Max Kellermann wrote:
> We select certain test functions which either invoke each other,
> functions that are already const-ified, or no further functions.
> 
> It is therefore relatively trivial to const-ify them, which
> provides a basis for further const-ification further up the call
> stack.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


