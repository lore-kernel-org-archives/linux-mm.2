Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8858CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 22:17:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 429316B00B1; Wed,  3 Jun 2026 18:17:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DB136B00B7; Wed,  3 Jun 2026 18:17:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F01F6B00B5; Wed,  3 Jun 2026 18:17:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E9576B00B1
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:17:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B4FB04060B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:17:11 +0000 (UTC)
X-FDA: 84840013062.24.727CF98
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id AC22C4000B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:17:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mokyQUzf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780525029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V6pazkEL6DFXw7u78OwlQURha9CAXkBpjIcDT/R6oxE=;
	b=PTPpbkk+WTMTj0iAv1QUF1lqlIQSvX+ZtyRe0BA60i3E9OzgzBIYf2N3gQHQOmnaixbiBl
	5RgxDv3RgAOiAvPXPOZJvTtphNYLH7qntLvm9129wR/HUU3FMIuM5z/oNN7SpuKhORTK1F
	ytKJ09KGiwrmByTGPB7b8ZjQvwEelxU=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mokyQUzf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780525029;
	b=p1lu2IOg93BwZ5n6qxcnZUTacnJ8XYd4ODiuemYnYmz6a0/3ehibEN1AvRJFRjSVdHwp0D
	wA7G5GRAt/b2y7EnQjKMIocmH4v7WSWlNP4e0O4Rl2C1xrEoVbZZohbZy0x8gb3wkSDZes
	3+qOTSijcG0TTMNfc2h8pZgCHGn3+/4=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-13721dfd471so59610c88.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 15:17:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780525028; cv=none;
        d=google.com; s=arc-20240605;
        b=byGtuvC/brQ8uOqKW2/ZJ5Bo4nNxasZQLvcSc18jTNEFPpf1JAkxJaCGSe7niZ7eB4
         Ov896eUeDFFxPdh216zhvoQs/3dUJ//u5N2fJ8lm9x9TUG7E2RUxVWWfC5oUYbX88qv8
         N1EsL6tOeq4ZgelYu9VmDZSgno5vd1I2zH95UrZuapuwCOhBMjrjS24ywzcm9t2fPOow
         E6enBfk4zE3wHhFeNWK2b3KY5Laq+kWwLcP55X0ep/QidCsdIsk5VjneWEpuDKGF5iwW
         k/2ga6XVTans0Pn0zqOXJhTfv/7QngF0o9f9+4TdlMTaxib13GUge/4GolzQnp2QHZFV
         ct+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=V6pazkEL6DFXw7u78OwlQURha9CAXkBpjIcDT/R6oxE=;
        fh=TukmWgoY0n6S2XcoEg+Y6VTemIvGBGnPN9zZEn5pzc0=;
        b=bAil0pm4WyHojm7S/xXzqzeZU3SUxhzel4JDl8+y4BzVOHvYWqYJ5NbIyv3hs2uj6n
         t7dXjCOBu1uj5mndg+ATyxSXs40jxm2aFh/w74D49mp96Y1uAkcTQPlsZ4OwDvhWKqU2
         px8Ca4reU3IoltHwWf588jOZ5qVeWgPnX/rgkqhiTzzQQRWJ0/YCKVRHHcydIas1Sor/
         9Sq10hhCdzd64py5GJw1dmr0ySHXcr67U7gIBOteErloLXH//lVenIWZVtqsbHIca1kg
         32zqvurPh2uCTXUMQ1qJW9rZKIjYExZzMG5ayB00TgVs9C0shTVJAwhDtofQpg/GYihL
         lJHQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780525028; x=1781129828; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=V6pazkEL6DFXw7u78OwlQURha9CAXkBpjIcDT/R6oxE=;
        b=mokyQUzfAoKrKGNDHIxdxPDD6opY8FP5pR8BU2e4ROtXzz1D3OPKn03sxuc2eLulfy
         +fqK0sBvjL5uHqLwij7Gsao4nuJwcvYjIz4FCLr1/cQIBARfoMUESc6YZq+f2ertv4tU
         efG795vndfLxUytI8DkzyjhdQyfJPJnGGXdCh5JV7JMg1XMkW5SaZZBK1+wWv9xupDNJ
         zvLl3Dj68nWKk9/2ft9D0NgmjD9nEI4ahhHLGy8nbv3pUowy0b/ZkpRQBjNbVTIkyDhD
         HbdDcthHb5fA0FeEWLpgNO6pTtr0yMPtm43NFRMGkulOizBh3d5f3ZWGFF3kn5h5mjT9
         Hqlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780525028; x=1781129828;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V6pazkEL6DFXw7u78OwlQURha9CAXkBpjIcDT/R6oxE=;
        b=fgZtmlCO3/6L7zG0HLOe+jzZ4JmzhMz2smqi5tpZuCqvfePwqthbtzkIUAYSQxqHUJ
         3IiBVHr3aSXJpvaZVJvZ092FU2dbw022wUvzS/q7jsHD0tAxIDU3tEDnzMyd5mw2oZpH
         Hvo6ELBZ2fpxUtKeW3+rSBFZOuzVaWKiP/2ROLA7GTWOv086BKCbFe0lEnIxGlOT4nWc
         JxI/zzUmKmBLQnOTAIxsUNSuE3+gtgi6ICi2BcbcHUt8vpAWfNZyZQSJ03FPq9ZIyuZe
         VhaRIeK9S51KDq3SmQwjdtVd3bSfBKX+6mqUFaSUL10cFXTiDaC3m08DCqeeMI7wvGfI
         CKfg==
X-Forwarded-Encrypted: i=1; AFNElJ8+sCYUWsu66qksT7hVWC7YFN1aI4TafTUZlfZmIYqh1c3x3YQWMbQkjQAktNkjjuZBTw4+RNd4yA==@kvack.org
X-Gm-Message-State: AOJu0YziB8DYYCCWHC/H+4Z5VKMDBlrKEjADgqeniDsbztAuR6vx4kwX
	uVle5vSC/6dhkifoqc81HChiUC0jbbivzjF+Rw1HGHsuRRF7F1/vOCP0VeGoqo1bzc+Lj/v4n5I
	CV9496xQca/NbJLctWnexvx/yfGgFWX0eAoQs1ZTt
X-Gm-Gg: Acq92OHSgmVD6MA/l11RtGzh+f23tLVYWzKWgQVHvPqX0eI/gBtcox/uMH37dmnIU8f
	MeizHs8JpDEttN/lM2uZsjl8JWlu/+U/REmxJ0S3xktPYfh/VuM3zQFIWEUYsZPzOrIfpkuFpEh
	Ze/9b8VIGs5G6p03fIVg741wQtMBN0vq2UEzUJ6+XlMijmj4Ib3CcBESto1ERNloxcnElcyjU0H
	M3O20Efjw4ovesu5IwxYQf5J3FoOBMP0iBtJMf9+KfOZXbufUayx3qR797JINeIdF4y3IDrGOBU
	tPzgI0fUvBKTD02y/6IJX/sMHdRKOVQtzJGn36hub1EAg/Bs9g41VLpBEvvOQJiEfHvBPyYFlt6
	/SmFL
X-Received: by 2002:a05:7022:7f19:b0:137:ef27:e29d with SMTP id
 a92af1059eb24-137f6c126b1mr1478374c88.31.1780525027812; Wed, 03 Jun 2026
 15:17:07 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 3 Jun 2026 15:17:06 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 3 Jun 2026 15:17:06 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ahmbVaCUcBrYK8qO@google.com>
References: <cover.1779080766.git.tarunsahu@google.com> <9huzwlwnbgdd.fsf@tarunix.c.googlers.com>
 <ahmbVaCUcBrYK8qO@google.com>
MIME-Version: 1.0
Date: Wed, 3 Jun 2026 15:17:06 -0700
X-Gm-Features: AVHnY4KwIBznOQxPeeZp-k-7DNYvQD8SHlCWDjhKoWsxt_QvgGRs8hmrB0P3Bno
Message-ID: <CAEvNRgHsJbGz8k8vgCn_HSxeeQ8agEm4oBYQQ0+b3gFb-aVokg@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/8] liveupdate: kvm: Guest_memfd preservation
To: Sean Christopherson <seanjc@google.com>, tarunsahu@google.com
Cc: axelrasmussen@google.com, mark.rutland@arm.com, skhawaja@google.com, 
	Mike Rapoport <rppt@kernel.org>, sagis@google.com, Jason Gunthorpe <jgg@ziepe.ca>, 
	Shuah Khan <shuah@kernel.org>, corbet@lwn.net, dmatlack@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, vannapurve@google.com, 
	Pratyush Yadav <pratyush@kernel.org>, david@redhat.com, aneesh.kumar@kernel.org, 
	vipinsh@google.com, Alexander Graf <graf@amazon.com>, David Hildenbrand <david@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AC22C4000B
X-Stat-Signature: 7jdeu8wtmc7ndxq79d7yx5eqf8xj9rst
X-Rspam-User: 
X-HE-Tag: 1780525029-585866
X-HE-Meta: U2FsdGVkX1/XbbqfTdBGxw6mg9/WsRfbOfB54gKROBLebFbPXkTOIgtYTn6yipgIq5gmPTpDsQ7HS/2Xx3QHhC1wM8XT5zXmLSoTAb6yMLGamtl+cyqHS7P2IY5Kvtwml11g2EXG+ziP2cypPAJbaKfw1O2+9ZM0YDASGL5J0b+koQomSyi5NOmS7TFLF0hmE1gJ9Nhqfza6ZzClgsYSJx+LkrT5puNY5PpAjnRhQDmYNqGBnMPoucS2t2+h3kmOwSARCTTQwiPqghywFnZrqwscogNIlRaEL6gNOwMF0rnJ6rj3JoP4WNRT2Px20hXFYsmjERnaUoec5LDKD9nOjBDQaeAxLZ0zSLz4mq72P03vaJhALvP1sIy+T4/pQ/E47gQE9ejlp35LTfooOODw/0Ba1BBMI/aY88xXD099N8fY/+QjT6uMKbjph7JcYEpplVlNJopWkHF99hzGS8NVMxFhJ/rQV9L6hDVl192Fm7grBx7GoiTa6qbw4npOPbw4CtBPMUwfFk6kzy5JEWr6Tjesu+SKBoee8CZHNAdzmhheIPScv6/WlwVT2qac7E0Pq2Fngg3n+D/bjkgMC9zS5uzrN9p/VZwy9eEGrvCeisuyxV9lufduwPPitxGY40pt0wWcCXw14FrkycM62c9TxmtCTKcmi0JI5y6OvJY2MMN4KbO4j1OtHhxUBnV7HA5JYBLiFJqShHe3WoCEeKkTAkZ+eSP4seS3oqvLD4OhkXX3ScgdZs/0qV4UqhG/yoeYgPCvC9cX9eOtgLMZZI5DAPt5kMSw+X2m4DDLbZc6I08QUb05FyG5WfI8B+DA+mO71kdVnS9JnGEIknsHmElm3TwIn0VCOLmU8gCMAnSs2YVkDCu+y383/IiGyDFK8SXOCdy2GsxZ0xKMdchsp2D88YzozOeE0yvqiSdE/gHUzZQE+9GidS6Z9/zYjV7Lnguim8RpzvaURG3tFC3elmK
 p+vaGLDG
 wWV0eFvJdKaNW5feCwtaNJ7EgXux1bYuR2mYai3tjuJHgTR0Be1H7vYAks7G6WNTejWVPW2ti5iSEr6Wj4PXKkboj4ZW7qQco4wj2RXGOTYcE66h4IFXGgfDFBNKLknO7sxrpqxaKHci2oQWdGvQgmlOYiP479jNaWuZmHDNTRBRFkYJtkDyZV1f97mK9bJCYIUN4sPk/AmwJSCd+6oYIZGRkDbruw1U5lio/mhlJGjBXEpbhQDqcT5L2iK/0tzdi+c9R3YiGNiACwAGxGFJvBzxb7TDsR+gMEu0jZRH9D4cW/zcN8xo7IKECtdhHY1HLhl1f5VKPQ70b6D5TPdV3WryAFk73gkEvAQ5fMlkw4V2qKf9Uy72fMWZfF+BY1KG4/u0JM9aWXsDIJch80mjlx9bQW8xvSc5jdl6ikxAjD7Kllb77ywkCECuF3tmCKr16zBYJ2gwTpax6wTQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

>>
>> [...snip...]
>>
>> we have one open Question left:
>> 1. How to check guest_memfd is fully shared.
>>
>> [...snip...]
>>
>
> Given that lack of support isn't going to be limited to _just_ guest_memfd,
> simply disallow preservation if the VM supports private memory:
>
> 	if (kvm_arch_has_private_mem(kvm))
> 		return -EOPNOTSUPP;

Makes sense. Tarun this was the other option that I was suggesting when
we discussed offline.

I think (?) it is possible to create a fully-private guest_memfd for a
non-Confidential VM, and even after conversion lands, for both
vm_memory_attributes=true and vm_memory_attributes=false.

In that case, your preservation series can still preserve memory tracked
as private by guest_memfd but not used as private, right?

I don't think anyone will use this combination before guest_memfd
write() support lands, we just need to make sure there's no kernel crash
or corruption in this case.

