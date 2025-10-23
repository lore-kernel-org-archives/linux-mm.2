Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B888CCD1BF
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 20:10:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 842468E000E; Thu, 23 Oct 2025 16:10:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81A3F8E0002; Thu, 23 Oct 2025 16:10:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708F18E000E; Thu, 23 Oct 2025 16:10:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F79D8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:10:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF7EB5CEC9
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:10:48 +0000 (UTC)
X-FDA: 84030472176.12.AB8B55E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 65CB9140003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:10:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="AGOZKy/r";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761250246; a=rsa-sha256;
	cv=none;
	b=fs4ho8MY+jgeQkYmm4O/eh64s4pfbKbQlmv4hzJJoy/LABs9pKc0Rg4u1xZpZFnWdCAntS
	eCQyTJ/slKKjOEvHJIJwD6rMvvw7n8a9JpwMjh+ms2Onf9KSIq78i9QGoDnwLg/Bxg261O
	ipSIf/y/60Ew1lZQnOFWfLJzi1gz14E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="AGOZKy/r";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761250246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vF8Hb3hnoXfLSdgr9uXEesJUum0OfpN/YlQIs62F7QU=;
	b=OK053ClQgERna7D/K+JVUBshnZFYksvmbgHS6Pqoqd2kn0g/6RlIEsdN3UDfWFBaVlrbZN
	PKWx7ljCB/01BFKKPVMS7HRLFQAe/yEfWVGtGkX1TIvNVi4t3NOMChqi+ywInXr75MlWwU
	VdAXNuuy6duZ8zX35A83o1cZ6Ki72B8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761250245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vF8Hb3hnoXfLSdgr9uXEesJUum0OfpN/YlQIs62F7QU=;
	b=AGOZKy/rvQIFLyM+d2Q/S+16ueuPcuHtUwWMAPkSvIqtncOeU9nFhoLc31MeKwLNrL5n/p
	DWixNe/t6XlrfgkT9OKMsJ7TvLa7IC67d6099uVFm1GRa+Rdpsn7rO21cbrKnuQD2ENXAG
	yEYllIPTUhnBN2AVKcGq3Fh9Y6+UhlI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-ThIY8oYAPMa8yir_VcVFHw-1; Thu, 23 Oct 2025 16:10:44 -0400
X-MC-Unique: ThIY8oYAPMa8yir_VcVFHw-1
X-Mimecast-MFC-AGG-ID: ThIY8oYAPMa8yir_VcVFHw_1761250243
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47114d373d5so10072335e9.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:10:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761250243; x=1761855043;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vF8Hb3hnoXfLSdgr9uXEesJUum0OfpN/YlQIs62F7QU=;
        b=l8wk5z+cNkYBiJNJcZwKYPcLQkw5d9jK9fSZQxbWEq52uhEGberHjVkNN0p8uHed3Y
         +TACPj/Dwt4f3b4auMbFJiWcjopNNcaDMF4NHk2ZE/i3Iok6EZ7iE1trfjXaCnQVhJiB
         He0nfGKc4DNE3nZqvO5R2XZ+aW8UpYCa0B7vCTRVVE4GvqSXbVlkXtqkuv/m5Eh3ISZ3
         090Qq7YM3Izt4VRHB2r02CSqDdhFH4Ayh6TGvGj0bEzWZKTBPxEKrFKUznSvHaKXOwVB
         o/rTOjZGxtT6NKsHWJDSqEkyQ1++ayXmbXWPTi86rVcRstnz8hakl+daBTUXgTb40uvz
         1r/A==
X-Forwarded-Encrypted: i=1; AJvYcCVAYl0yA3XbW3TzoSoiLIWvw/PfYVnZw1kJBwVX4wurM7hHsYyFN9QEaV5gTwyx8TH/6/vkAQSSZw==@kvack.org
X-Gm-Message-State: AOJu0Yw9AbAmjs44WR7NrYuqMMMVvHffx6b9B5aJpieDtwgFJ12iO5C9
	3SjtzDhfZtsa/U/Ps7dVr5JhRO2zA/l/Q6ua95G7/uI+nAs7V8KS7kAaHJkhLyVUWSgvAZyDjNm
	AAa0FXZ4okdK2evTHomG2nGf0LIs7nMbvkM+N7ycAnEtWRqo9/tIo
X-Gm-Gg: ASbGncsUrPl+e7oe42y8BAzUBN2NYvnuxTzp2u1gKabI7JTX7TNLoi9Dpj8pmOlMK+O
	RKmjdmc+pCDQS9UIYVX4sUOazx58FlK1pfjYUpAgy0sTEGBkqjRp3S4b2RqhUp8f79nh97r/a08
	7UExCij1cewxg/3EFKaIbY3GApMayJ3cWAKWrDS+TYbLsJTTNWGpnGc5Fi7Y9KSxaLSO8f2dnuy
	jYrq0YH3IenrEyEqp6WCKKzkTxGwISL5ZRFAtAUWQwZlkcttupIY2LhPsbfpku4kS7rPVv/Z0JD
	aNml0d4hsj6oAFee5V2k4XMo2ZwoNQ3XrA2awIl4FCG+UtPo5O3MPLKmUt7gKIKE9mb9ERiq4Eg
	UF031f/CZxCyINWa56sDMBjsG5CNHFFkQAmRZKuwv5N8Nb4kRYUI5TmH2r2Wp6kGy6sT/9QVe47
	22Odlncbrh083N1rNQG8y47bHbLEQ=
X-Received: by 2002:a05:600c:6291:b0:471:a43:123f with SMTP id 5b1f17b1804b1-471178a6882mr200628565e9.9.1761250243302;
        Thu, 23 Oct 2025 13:10:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEznsO/mZG7bXXGeVpf9lUsRK7DtoSEnI7rqyr8WVIAgGuBjLQ7Sb3p9c9Pj2m7/SEml5RHBQ==
X-Received: by 2002:a05:600c:6291:b0:471:a43:123f with SMTP id 5b1f17b1804b1-471178a6882mr200628295e9.9.1761250242917;
        Thu, 23 Oct 2025 13:10:42 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429898cceebsm5532934f8f.37.2025.10.23.13.10.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 13:10:42 -0700 (PDT)
Message-ID: <3d6bba2d-9739-41d0-8f3a-f8b11620c33f@redhat.com>
Date: Thu, 23 Oct 2025 22:10:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/13] mm: introduce arch_wants_lazy_mmu_mode()
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
 <20251015082727.2395128-14-kevin.brodsky@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251015082727.2395128-14-kevin.brodsky@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Y0kTcX8flFDolsx82Aw8P0AL7o4Wecx7fB0C-1Y4VKA_1761250243
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ipniorr6khkf1q9eky544pur3pow6cxo
X-Rspamd-Queue-Id: 65CB9140003
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761250246-495535
X-HE-Meta: U2FsdGVkX19KXAKPCyN/YIBDNFjbE92bPkWeYBB/r9dNNMf2zxat3O0D/oC2yQLBfEXQUCSSxLkZm/Uev2k8zObQu4maqewYRUqWevGcSA02jqe/Ejmr+5IIbAiLpB/v7w1ZoLgoet0DozQb7Kbmo8h38z82g96omdy52Z1o5Zo6dSva4F12LY6dLmjdAz/UZTRXMhIF8q+9ItvJav8wOS+/UBYSr7LYbwFfRV12yLAYrykmaOBDr6E4D0S7hHPd3j5GTMYvYKr4BlfSVXB6t80Jvedfl1MFE4ftJJMmgdpPrR2XL3Fxpj7NFGXvF9f18E6qJ/IzBYCvtQSo826tlhTIy3E7cj1A7qNFUbSLTeArOduBjQ1KCbVG9LeSs1QL6fQFPFBBFQT0pRW67aBN7V4Af+wD39uqrEbAKuPd/p9YRXhxCen4IOG70wC15JBqwS6y+FUTgRqJQZAaUeH9340a/MTkqwsGu4BRd7TkGUPJWD/50gjptrsqXSWHW9p++XOmbhztq7EEp0us4dRxKGN9Rle09VV6es31s/M8qmpdGTwbEEZuTW1XcUll6PzhoC8JAtFLAVYp+FbrBoGu9ehYADy3hGGazNyw/SGMGBreKCBc71MzbtJ5VvPcsrTZFzdZfvpM5BlaolMuoBtzJaguA/Io6NsQBZ92K43m+fI2fQdjDyRDQGp5PVcsx4byJdP2uub6PGHudcKbWHQ7Ln+BErV8Ario/G6Aj5CA+bBJoUbFpN7x/xNwwGWBY5A7ibQbPGIPWRQSbfVHa9CMrh0YnEvIxZLjLGba9SgvMxKdww0TWhcyLInm/nKyhZu66bdlRvv583hbRhY3p4ROkg3+7gZh1f1zfUio0+wmewdHndXhVOqUFkQTTl1k42C2XuFyA87KarhTNfkNq8SrxzGb9FJwTsKXcJr6MGt8oPxkWAXPoqTRYFtmyYjXCrd5W5b0upiEwAjmG0hZZA2
 MO+ymsnA
 CrDPxpVpOwswBhn7yGT+gbcclftbZiJYDQq2cqFv6Hvtwvg3L/w5k8ZmXOuuKr4pnAX3+432pqtH1xStRn7SqWrOBUZ2rIOS5wp7f7s3m6IOXNFruS1OEZAiFc+y24DqwvfkEdsPOMlR2J+GFi2lHEiuZIyjZ3MXEssEDcSakti7WX2AbkkHvWyiP41n1SO4SoFm0SVX7m1dlr0CH5g+bN0it6Duze2pa1MXclvW1kKNBR1S717XrFJVxxqDBB+aSrktzqoMKiTGRWXWy2/W1C1DCCcKbstqbhgu9UV+ktfZxMI+nlGOoVXrBuav1tBXgj4NOee+JAf87zYHitUT8imLZe15hGiWAAbjwzMokpgcJYn5ZiPgDsl7QL+mHcVZ3xRf49c3hwGLOO6bIGsCDqP59BLW6theqMGdix8X5GTcrqIkAiY8BNLKO6qMGebLrLRk1M6X5y9KFXU1hAGa2IiemoskMEQpIq6xqCfiOrN4MAcI4+ZDJ95VBt+DjtyIbOmuQ0kMkAJT03Yr0RetILz13HL7bn1eb+51l2x+5DZPVY8P5BrnGnckALQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.10.25 10:27, Kevin Brodsky wrote:
> powerpc decides at runtime whether the lazy MMU mode should be used.
> 
> To avoid the overhead associated with managing
> task_struct::lazy_mmu_state if the mode isn't used, introduce
> arch_wants_lazy_mmu_mode() and bail out of lazy_mmu_mode_* if it
> returns false. Add a default definition returning true, and an
> appropriate implementation for powerpc.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
> This patch seemed like a good idea to start with, but now I'm not so
> sure that the churn added to the generic layer is worth it.

Exactly my thoughts :)

I think we need evidence that this is really worth it for optimizing out 
basically a counter update on powerpc.

-- 
Cheers

David / dhildenb


