Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5899BCCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:52:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96F5A8E00AD; Fri, 24 Oct 2025 10:51:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F9228E0042; Fri, 24 Oct 2025 10:51:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C0848E00AD; Fri, 24 Oct 2025 10:51:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6719E8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:51:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B2AD160EC4
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:51:59 +0000 (UTC)
X-FDA: 84033297558.18.8567C1C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8FB4514000D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:51:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bZWf2c63;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761317516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sFCSKz+pbfmgnJ7WA2aI9CGgIZh/9VpaZ5Xtmq9YRV8=;
	b=6A5jPZjKr2Jm0YEIasAnBZkZk9DDXyDsIP9pOwm49h/PNpgQyOsNFKhF/0e3dLKzDnDHse
	NwN1sisREM6Cs1vkYMMO5Zf6xuC7XZiRdwO939OBVFfjroqX+Og2Xn+i8aw9JFQbNpiHY/
	vlJkIQig6gemqfTZfcVCkQafK0gybs8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761317516; a=rsa-sha256;
	cv=none;
	b=A9BXNPU+YY6V5zBRM0fAMTjSBahx1hGxUfkOzWbolN+0dAPOKPvoAyMDuSyhbe0oobXMlr
	Nzgr4yKz83dlg4Tiu/OrW6O7c+FXAF5IdDW+aaCNV4KLB4BsoqFSM/IRUzzo26N5mNMJfq
	zODBqhz91m3R6m7F3/1gexS2evR4mOc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bZWf2c63;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761317515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sFCSKz+pbfmgnJ7WA2aI9CGgIZh/9VpaZ5Xtmq9YRV8=;
	b=bZWf2c63vLxA8hdsX/nsYxG1jQuWnfMOnHCto08wS+jWku2t9hr5T+L6ZGkwU0EkLF68Nn
	zs9ClYwKSGi3CBK9xhmGrxoWFyYBj0cPlJQgTCI74ScPXL7FBTcA/F2ckiqVLfvZk/6zGN
	S2oB5l8vfQj+nf2xy+QCT9RI4r2BY+M=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-iyD_tP20M8Wl8BijGIep0Q-1; Fri, 24 Oct 2025 10:51:54 -0400
X-MC-Unique: iyD_tP20M8Wl8BijGIep0Q-1
X-Mimecast-MFC-AGG-ID: iyD_tP20M8Wl8BijGIep0Q_1761317513
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-427027a2095so1245145f8f.2
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:51:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761317513; x=1761922313;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sFCSKz+pbfmgnJ7WA2aI9CGgIZh/9VpaZ5Xtmq9YRV8=;
        b=bO2xqGRUcbgoYuJcVrS10SPMlvUMaFMYcF99NfMIHNABj1VqfH0mvrcHXQBAEBeiRt
         KoyA24j4QcMiCSEF/Km4k+8prqTrULl9b7WWjPmmJyjh2SKypXDVTZa/dgv/q5a00Epv
         D5242KjjrYFuKmlUOpVNqZ4XN1ApGyas9URgxFvuIJqcyepQmMkaWFDOKVJpBP90WtfV
         hJst7XyO5xCXMqHNs1LQrGRGmVXE1Byc4IUSfIttR4NcwRo9NxPRVFHCeJAeaJt81fZk
         vAc451sD7EIYVUleN8Ba8pyp2MqzjZ7kNgVYgIlbqodITCxOQ0ZXvt1uoaEbtHfz1Mch
         ok9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUxjRmEcNNa2vAmJwJsTY8jvcVPVfFkeyrKeIZqCdvZIluRTT5Ka1qZZliLh5ZGBq5Npl8ad80rrg==@kvack.org
X-Gm-Message-State: AOJu0Yw0a7Lov9jziXsf5yGXw2gKdbbzm2AGjPCL0PISDJ33OEhlHtSH
	upuUk4wbzaJzK6GzJqQwVlzMWQOnsSMf6ZzRiRDbc38g2Dx1KkzcA6YOE1+4Q3LEKnoCfZybRF6
	KLapjYeNxkf+MUfp/oCLVln6bFcguslQliT2+aAmyjIhUYTGmrgyj
X-Gm-Gg: ASbGncuDJXVDnlQhOD27aInUZ4uhOWAstJxogsY2XFJz7Ns85BjMUrhntj1lrAF/Wdz
	AQhm3z0hGA8kAZW3qInNL09Oc0wnXhcNWwG3IRuAD7SHVxzygKkGpdxgsdXVPcydWcsbqm/lq8f
	aRkGicwbx7UbDoVoF3rM508CXXl0c5vZ9WGDU3QYLYnukCLlU7olSZDZngMfV36xFfDMzmZzhD4
	iEefSfvg0x+VbJ8MFhwUiyDY3WWh97KJg3sU9ZIb5BNs4WuSBuj5L+FK9qCFMl11WFBAv19goKH
	F2RSQU7dC8ZjhuJICulE+HdUScBUeeigeWMrnSbS0R1TuOldcweljNhzcAVhpyI3TALQYAlMRM+
	W5X+Mr1dj4VRUhN0ywm9EP1KsP133DfGx5gWrgtGItuxUINPkFTNB6msb/LZEMYHCWWk+XXj4IM
	3G6oZ/LioBPIA/LUkAACmhrGOYWDM=
X-Received: by 2002:a05:6000:2486:b0:429:8e79:a181 with SMTP id ffacd0b85a97d-4298e79a45dmr2899214f8f.56.1761317513368;
        Fri, 24 Oct 2025 07:51:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFAsv5JgYFopD0erwd4B2+Ll31lxxEQOMyEBbus09iXdFkBdtTufzvXtldPYP1cAIE4GNfNHQ==
X-Received: by 2002:a05:6000:2486:b0:429:8e79:a181 with SMTP id ffacd0b85a97d-4298e79a45dmr2899181f8f.56.1761317512945;
        Fri, 24 Oct 2025 07:51:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429930e35casm833065f8f.30.2025.10.24.07.51.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 07:51:52 -0700 (PDT)
Message-ID: <70723f4a-f42b-4d94-9344-5824e48bfad1@redhat.com>
Date: Fri, 24 Oct 2025 16:51:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/13] x86/xen: use lazy_mmu_state when
 context-switching
To: David Woodhouse <dwmw2@infradead.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
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
 <20251015082727.2395128-12-kevin.brodsky@arm.com>
 <f0067f35-1048-4788-8401-f71d297f56f3@redhat.com>
 <348e5f1c5a90e4ab0f14b4d997baf7169745bf04.camel@infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <348e5f1c5a90e4ab0f14b4d997baf7169745bf04.camel@infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nqm7K1l6Bk_-5NAh4McJ6bwxGsklSLoEM1VYgBzLKq8_1761317513
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 4ozb1sco16ch37b1jy76nswhje17wdjd
X-Rspam-User: 
X-Rspamd-Queue-Id: 8FB4514000D
X-HE-Tag: 1761317516-961074
X-HE-Meta: U2FsdGVkX19HnwGp3Y8z8aQZpSeMZfwK5EFuaG5lye3eXM27AOE2XZUCMaZeRDtNyqQSEl7tq/MiPYippgTWLbhjXxSIYZeRk8oncTRnTcXQCRUZfwRToETAVi6mdYq4Y8cujnxGXZNMDW+uvn0SP6suG44lUkban2ZNajvMUEwxTQwUOTTJP7AhFa244GihyF6LMfsZgw1LMwX+aiREUf+3uUDJc0zTPOG1PK8rDrUzy7sJqNEIPxPbVXamFHr0aYlIYVnSR/6myEaxZ3XMdycxURzgr+4qWuQXpQNnFFoXZjrQ7cmNzCwTUZi+X0Aoez1j7Xi8R3mX2rcqZQW/wN4EL2zvl6Z1iLA+9R5Y2Lnpk4nTTMv7+qNOIRYQEBraw+oLDV+z/rG0giSyGuZX87DAsya1u5B49uk/vgi6LUM9rk/MxwNBKlpW5W4Fmll0uxi2MwqmYb8m6lrsrpSKCfH5iCv51UYnoksLgRU2TXcfdr5RbjqFChmkWm613sLF6Rmb8pcgJRXtXxzHTSkFaPuASIgoT8rAY+JKZpj1viGGb+e78IBP5uBhnhhYldAVxnAppJFLa2zt0dQ1hOSWkJKLLMH2sCzpXi1pjZhY3TChPWRILD8NciRfZEQx9FuHcYZgaHCv9/u1jIg4Y3sUuRJCOUwcGmVWuiQQQoil9I3d3pr0ba+b13UH723M8IV/p7PcNGLybCwdnnozt6Jj6e0fsX08l7+YBk7OAS7CyNmqVn9sGcVHSMX6u92sm6nqeKwyxbpOOYEf8HfxORe/NnqLgC5inebPsvTwdT52JEHucDyrgeYEBdqhsgn8TNlYEKyMzM2zP7z/SypJ2jXIdchucqCvhuRrjW4c746G+BS3cMEKvRXHkGQ0ByhPWzkUniW5yQKHzcEE16lJN2o9TvqHXnNKPUj6l4aWDgVjiv69kJT8ZwnShB8FLOxSEmKE9wQnNCR7Dhy6SgBH5TJ
 KsoLsA4f
 NCEO82PRthrtije1xWAPlt5pCcyi/J9m5nx4QbqQ8jSZV+a4i+XQ2nvhFejpjeM+lrLb6JUYp+gm0BoriG57ToYjH4kPZ+3uh5Z91ZCPzBGfu5k1hkFCj2VmvTdvcqZp58kaO0tU4jPOI4SizPYB73HucYIMnMBpbEAv2NA1Hfs4YLHYFfGuAByAs7q2bVe3qPRaEGdtS9sHlzXdzAGPQ1LdMe9mhH+wCbH7o91eLq2fF62/aw3ghpRoDIsYcTElp0mosZxbblFz5c7mG2pQ66eyP672YU6DKbvBAE+/x9YSlehZkyP4A2epaHP3ybyomp4TK1XLNMdcjVYV548TSufgp8SfgtwmAqQP8xFBmskxsqRN0ML76XCNxMLM3UcwTubq1l158PU+vX5ni51/sfOF190pqvqmtA7N/N4o44maQVGk32WDzDnn/9JqBViUlXtlBPLm1sMMOOwU32wTzYXTnY8hySlqemyTF+MVVw+fCKPPrPKO5OObRNIFGdP7jAZ/bpcJymM3M07wUFp3tIOhfPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.10.25 16:47, David Woodhouse wrote:
> On Thu, 2025-10-23 at 22:06 +0200, David Hildenbrand wrote:
>> On 15.10.25 10:27, Kevin Brodsky wrote:
>>> We currently set a TIF flag when scheduling out a task that is in
>>> lazy MMU mode, in order to restore it when the task is scheduled
>>> again.
>>>
>>> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
>>> mode in task_struct::lazy_mmu_state. We can therefore check that
>>> state when switching to the new task, instead of using a separate
>>> TIF flag.
>>>
>>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>>> ---
>>
>>
>> Looks ok to me, but I hope we get some confirmation from x86 / xen
>> folks.
> 
> 
> I know tglx has shouted at me in the past for precisely this reminder,
> but you know you can test Xen guests under QEMU/KVM now and don't need
> to actually run Xen? Has this been boot tested?

And after that, boot-testing sparc as well? :D

If it's easy, why not. But other people should not suffer for all the 
XEN hacks we keep dragging along.

-- 
Cheers

David / dhildenb


