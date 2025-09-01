Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DF76CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 14:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33F798E006D; Mon,  1 Sep 2025 10:43:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C8588E001A; Mon,  1 Sep 2025 10:43:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16A2D8E006D; Mon,  1 Sep 2025 10:43:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F36458E001A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:43:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF3F51408C9
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:43:30 +0000 (UTC)
X-FDA: 83840949780.27.7F1F20B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 55DFA100015
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:43:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=he83A8Hr;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756737808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQf4Reiy5apT64tfdgfETW33d38jjuSty8SoNlXS3hY=;
	b=yk5GctUpMzD5iD5jhVBKwBrx+EBUdrmsvN6FuZz8Q2KddzNuyfvu2f2vY7yPfJ3Se+axfP
	jX6UHci3dDeusZ7W4sVa/43mWURP0/TN/6biXWhwzhgrFUs9ErFbVZt9he6KTox+sDMkWP
	4pv2gkhh5Qr0kk+VhIl7mHoXhceR65A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756737808; a=rsa-sha256;
	cv=none;
	b=cWVj8ZQbierTu8cKU4nmNme3ilF22pP1WhcRn2xg3xjuKt5+XKSsCBauY5ygMXRjusu13C
	lWGLptTGaj2JpCT4i7CfgZDpKXdrZnCat0TBFCcPaxHh+r6kgRAG+bDCLYvxdvN8BWTeoH
	0dnwPprUbbchuUvaS3KeupsgBD9v0fA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=he83A8Hr;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756737807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZQf4Reiy5apT64tfdgfETW33d38jjuSty8SoNlXS3hY=;
	b=he83A8Hr4oZxw6L7xZYUs5O56bNktzRy1zVWXInnzvHq6lU9BSaZhxS71R1yPfCC7poltk
	ul6uyxGnyjxq32PJhu5YntHb/ow7v59L9W+f9sCh3+ZnLuZG3Xws98WHMAAlh5yYtopkff
	zsQh8SlOPC6LGLSZi1jId1Np6uy00LA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-3msYcyDTN46-soXNdnYZAw-1; Mon, 01 Sep 2025 10:43:26 -0400
X-MC-Unique: 3msYcyDTN46-soXNdnYZAw-1
X-Mimecast-MFC-AGG-ID: 3msYcyDTN46-soXNdnYZAw_1756737805
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b72ef3455so16833345e9.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 07:43:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756737805; x=1757342605;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZQf4Reiy5apT64tfdgfETW33d38jjuSty8SoNlXS3hY=;
        b=fvcqOvySymUy9SGfo/IopVdnm83J5N2EujmuKGAIP/dSphYgBtBNXrgqeI1PeSGmAy
         zFVDLjfUnT2pmoY07DxjQ87jzKZK/BFlT8UEB884gcXVt4aUKOh0hUSAxmtwZSxobyYG
         Qw2coxokUavg/0Y8ebVg6QLbaiPgJJ0aYZKBn7WfOIL8kfDy3Xa/k4z/FSwp4VgCb/8d
         sfEhwWGhePE0vo9vFvRYGqYX4kORCfcqSLBHitkEurFZIJmaelzrWXJ9DxDtwJXghUBd
         NgA4iwpeEiYypiF92L5/QJyWtX2T7AE7pGzUuycM4qjLjB7z6rPzem4YB/RLZsVBdcNA
         606Q==
X-Forwarded-Encrypted: i=1; AJvYcCXf5frssBZX6NNgLcIe+Y0hVI+W+0Kihsq0u87mIqMIRZOB8j7jZE83/VU+gqJ60n6W5QOLZOztnA==@kvack.org
X-Gm-Message-State: AOJu0Yyk6mY907V7LXqbvOyE2KW6cFaMWPCP0yMukUtTIZSzAgZe/Gok
	+gCGVmeHfJ8LerXPAohaWp1c4Fh/x5klfMRIxTi91Co+UBC72qSsCXNIEsQWHFyYZEQq0fyyKiL
	OSsJ9j6CzLWttNOhSkRzy7BENZ8cX+2eJlAvIciefLfrqsmI6C4YB
X-Gm-Gg: ASbGncstS6kMVFdpOM3yPcXamOG9Uxv5IvjHLfviMmNJmSid7kJbflCCqJ5z+TkhsxF
	7fIr5mI+ZGoF+GX0VjXfGActwiedhPUvSAuNNeQWBvaYBhz2fr8Juscw1wL8rm3k/u/+0GFYlZM
	SGRZHVLOlB2dvQXYO4Vme062P2a9YIa6tQtz3jipUBs6S7fE+MkHN2pMfZ81Bf0Jb/QW3/9Xe7S
	MTd+j7+nJnbE9MTG7O7ZhofhkuHskZ/I4aXXVxYRQDWTkd+cXgOHdpZmiP2B+pkSnUxFp+rU5em
	J60/gJ3pwUlOwHZi3WnrILWK9N6P3p7QmUYMV1GQxd6/NniM75CWOAUkfTtWthPb6XJFgWLcFnb
	+R5qr4qAW99qDTcc025HxqDlrLrWhqHxONitDrnPt8HRVpb8I4T62dwd28bEAQ/bv+fU=
X-Received: by 2002:a05:600c:3b9d:b0:45b:8a84:503b with SMTP id 5b1f17b1804b1-45b8a845256mr54590835e9.31.1756737805316;
        Mon, 01 Sep 2025 07:43:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQRfn5sR/77vqQEmdzkbnhL4QNlRAOrqr4TrvFYBM6bDd/eneSMeY2Ldu8ZaHvy16wvsmCiw==
X-Received: by 2002:a05:600c:3b9d:b0:45b:8a84:503b with SMTP id 5b1f17b1804b1-45b8a845256mr54590595e9.31.1756737804892;
        Mon, 01 Sep 2025 07:43:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b87b38fcfsm53262385e9.0.2025.09.01.07.43.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 07:43:24 -0700 (PDT)
Message-ID: <e2620083-656b-4af1-91d5-6452eda2e4a7@redhat.com>
Date: Mon, 1 Sep 2025 16:43:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/12] KVM: Documentation: describe
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "ackerleytng@google.com" <ackerleytng@google.com>,
 "Manwaring, Derek" <derekmn@amazon.com>, "Thomson, Jack"
 <jackabt@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "rppt@kernel.org" <rppt@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "tabba@google.com" <tabba@google.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "will@kernel.org" <will@kernel.org>,
 "Cali, Marco" <xmarcalx@amazon.co.uk>
References: <786503d6-e58d-412a-a17b-f5e4e481c3fe@redhat.com>
 <20250901143000.5017-1-roypat@amazon.co.uk>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901143000.5017-1-roypat@amazon.co.uk>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JWZpZclfRz89xotNZT1xKNnlstIZRBS6od0mn9fV0Bc_1756737805
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 55DFA100015
X-Stat-Signature: 8msy3qqjnb7r5xe1cccwy1ybniy6o4ss
X-Rspam-User: 
X-HE-Tag: 1756737808-351719
X-HE-Meta: U2FsdGVkX18GRkWvo9Z+9ItOsoXE6EaBfQwAycTriX2qjz0S2HZsEVdIytezkOCoNFJ20/X1KbgEKbEJ5M7kw0VF+8Y1cyvb3lx615Sg+3DaVYhtXo63nfuDRdnMV6IS3ocOpbCz1ZLbYxtHvCD27anyW7fU4WHhf3KvgokzyQO5ylYP1PoLHqQZvoD+eZq2rJuP6IReRwzrbGrbNFqtb/xCC/xdKtx39OHOfdM6OCUBHlMmbT3SSJAMCPbURUgblqBbHcim8zjy7ulfwrxMAhLp0jp7g9lBFmwe1I2V2xNqJycyHT2nR/wuV4S47gbsJQEoP3nSH5C8JnraKP2ofBFy9sOkP4oTL46EjtVNkH/C2bD/dO4T9kFRsEtw0BStVUA7bO+9dLxNXPpT7ukNARPe3/VilDopglHK31Dqp+KI3CDPhNQHzGrGVKDvqtVXetctzpwFLdZQrfylRMonQ1R94N3YPZapaa9GCdE/vjyrKsTEsQR/PEPTx6YrfPiC+iRlS4THJcAeaLsH9KJGpTbQB9qgSN9+mffkyaNOe4RieHYkIZP7ySwHv5Xhm+t8qGJ9QRCC//5BuqPTRr50anxj7nUOnWYJlmhF1AWFlHy6axDIs7bOIlPoLWHPPjjWCzy5ETAEAA2qyRmcIdBTWa06ktsREZdnzdguIWmWU1oCIsg8JNRkWwHqtalONT2+vZxou/aq0uUtEs/aqUfjAH0HC5rUwrXe+4//fDWmwlQ7CVuoMLiAG2VGLIEGD9DLwylEvVkacbng/OKGtTVzkfM3A1HmUjpEEnvQmbS+BzSZFL+0jubjMYrnOfi/Yo73WaqllMGWY0QqiIW+eWeWAtVFlB0TlVgRAwoXBSbT3KD+W0IUIVwI9CkChvZ4VISFgpuHzhsl0U0qrjEY1K1Inb4hYXnbR5RiaTARVCFl8ofPJ4HUbn8d0AkVuxXcTJxTpJabhjc4OLFbMJWGVsM
 rdX6H4Er
 /3qYqJJkw+ZgST+44bhVVdl5vrzb+0a5rlSij10P2J51xYhYj3TGFhXdK3mHUncQMR9VMw9RhhhPfR8C+aXZ8kRkhzGjnTfRLZSeckPmvmidYTmLJ+rn4Wqs0N1WO6RHR+jAzcKGWb4MFfQMOIe+WCkK8gf9x2/xuBN269wQBmXkKI5Qma0Sg6PZvWSwK75/zU9iKb5X2Ijm3ql4MXEfsjuWgYrky9aze3YX3eVFzVof8HV1JfCfxHrk0FQ5uSIdAESlwlcx2K5RdYqo+LoHDq0MuDzjd0dzRbY8zd7yOF/M5JbZLN6V2vAOe+8FAbxiVBqJIpDtAmMtB1jLDOkq3159ipUmCf/RxkNwkfDxaZPdRcjlrfKesm106ItMvSTEWd9FpJ+N5yqZAT2PoivelKnQFiIbvct66AU+JfXOY2+hi4+5vgoCNaXCvvFuIZnYYQm+dkia41lkpyDgoczjeqo9GZji/J/NMpw/NwjWLxIwhDD5ACBSzx1jcdwEq2JBfp9OlyOUxdgAzv94h7lJYCfbY7R0nuGSMr7pkKSJ0DuZEa6EF4xbMSEzOKyigawJEoJe3d+7h+XwkbBjHLunho5wMOBZCk/u+IW2HePS/uBAVWm6S96OGgqhFO5WvW+6504uJno0/mldvQ5XKunq1pGWgVsmrGLCd5g9pJmEkmZUM3ozQYX7+EbD2WS2lj/wySFVkKI4LxijTssw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 16:30, Roy, Patrick wrote:
> On Thu, 2025-08-28 at 11:27 +0100, David Hildenbrand wrote:
>> On 28.08.25 11:39, Roy, Patrick wrote:
>>> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
>>> ---
>>>    Documentation/virt/kvm/api.rst | 5 +++++
>>>    1 file changed, 5 insertions(+)
>>>
>>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>>> index c17a87a0a5ac..b52c14d58798 100644
>>> --- a/Documentation/virt/kvm/api.rst
>>> +++ b/Documentation/virt/kvm/api.rst
>>> @@ -6418,6 +6418,11 @@ When the capability KVM_CAP_GUEST_MEMFD_MMAP is supported, the 'flags' field
>>>    supports GUEST_MEMFD_FLAG_MMAP.  Setting this flag on guest_memfd creation
>>>    enables mmap() and faulting of guest_memfd memory to host userspace.
>>>
>>> +When the capability KVM_CAP_GMEM_NO_DIRECT_MAP is supported, the 'flags' field
>>> +supports GUEST_MEMFG_FLAG_NO_DIRECT_MAP. Setting this flag makes the guest_memfd
>>> +instance behave similarly to memfd_secret, and unmaps the memory backing it from
>>> +the kernel's address space after allocation.
>>> +
>>>    When the KVM MMU performs a PFN lookup to service a guest fault and the backing
>>>    guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
>>>    consumed from guest_memfd, regardless of whether it is a shared or a private
>>
>> WARNING: Missing commit description - Add an appropriate one
> 
> Admittedly wasn't sure what to say that wouldn't just repeat the commit title
> or the contents. Maybe that just means this shouldn't be its own patch. Will
> squash in the previous one (same for PATCH 11/12).

Very right :)

If there is nothing to say then probably everything was already said 
(other patch), lol

> 
>> WARNING: From:/Signed-off-by: email name mismatch: 'From: "Roy, Patrick"
>> <roypat@amazon.co.uk>' != 'Signed-off-by: Patrick Roy <roypat@amazon.co.uk>'
> 
> Heh, my git config only ever uses "Patrick Roy <roypat@amazon.co.uk>". Not sure
> where "Roy, Patrick" comes from, could it be the mail server mangling things?

Good question. Does it only happen through git?

When Nikita sends through amazon.com[1] it seems to be fine.

But when he also sent through amazon.co.uk [2], it's also messed up.

I suggest contacting the amazon.co.uk admin or ... sending through 
amazon.com :)


[1] 
https://lore.kernel.org/all/cda7c46b-c474-48f4-b703-e2f988470f3b@amazon.com/T/#u
[1] 
https://lore.kernel.org/all/20250828153049.3922-1-kalyazin@amazon.com/T/#u

-- 
Cheers

David / dhildenb


