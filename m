Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0718CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 18:55:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39A078E0036; Mon, 13 Oct 2025 14:55:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3716F8E0009; Mon, 13 Oct 2025 14:55:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25FD88E0036; Mon, 13 Oct 2025 14:55:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 153718E0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:55:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB3FB4707D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 18:55:43 +0000 (UTC)
X-FDA: 83993994966.15.40D8AE4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 296B240004
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 18:55:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SAXS73r4;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760381741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c2l1X4zxpuuQEOMhoTZtWvPktW5G66gnU+2hRZgipMs=;
	b=Y1fdIHma5hWIhPle5RY2QVX/TMS4zYpVh/m1F/4pQC9+smqwQCcTTmRKAnhEeOIoIXBgz8
	kgNQCsvxSRzkHY98mxwn2jUjs951AFD7ZeUCE5KV9R66LVcr/B0GCPcD0NgrXazq2tSz1L
	4AHB8lEUQWy8vuo0Q5wC0fdT/thxxPU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SAXS73r4;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760381741; a=rsa-sha256;
	cv=none;
	b=GDyP3iPUnL0ipY8KdGNBzYZKPsxEVftMKiGsvDtth5D/t2ASbMBV2ePnJEYehwCSGKejLL
	0Ko7/1VamvPLC0KZ3ojL7v9bluRnECB8TMULDHTk3dGbfXCctCunw7XTMjLCwqBf9qjaaw
	60F4Nebbyf4z75KW3b4o4sOxIQiFrc4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760381740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=c2l1X4zxpuuQEOMhoTZtWvPktW5G66gnU+2hRZgipMs=;
	b=SAXS73r4YwxIQdpEjp+YOLUQJtNsmjVApZA0eOF6UqMx6RxQpSIsvAlMIF+GHCpPMfDd0P
	d0CmZmK+TU1dZpqCguRfD9+ZdO9awDnm7S8tNVGVV29NgmhfPf6NUQMsLbtfoEz39jNjFz
	+3ztT5487WMwqAQVXSQ/cJfz3OC4VE0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-aK6J77b1Nni8T7uJd8JY2g-1; Mon, 13 Oct 2025 14:55:39 -0400
X-MC-Unique: aK6J77b1Nni8T7uJd8JY2g-1
X-Mimecast-MFC-AGG-ID: aK6J77b1Nni8T7uJd8JY2g_1760381738
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3f924ae2a89so5490177f8f.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:55:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760381738; x=1760986538;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c2l1X4zxpuuQEOMhoTZtWvPktW5G66gnU+2hRZgipMs=;
        b=DFTw6T4q81S+v9xTUy0mvPgsvoTtmhsNvldm5uWQkguSkgnDrq02mMBTgjZEZI/W+8
         Z2fBdd2e4jLfylmMF0k07nKpLKAz8lGL0tSss+SSkz+ZEy53sqk3sxHG3rTdgKXrM4uF
         t8hSydUsM2kYpjGdeyD8lTHzP+/RTWwMAyWPuIfJwzbWHQLqw5kx5uq1rsbwnbSw6hlk
         9JqdGubZuwywWqOVs0aM8MVFA38LMw7FbESP7rOtWLUABjufmFLVS5/bOSiutRn9sQ1j
         KEaLV1nxwlj1hEJqShuRHenIThngGX2nJzOf9b6s02pkAW7RR4Ty36/mlU1w0NK9unRi
         3d3A==
X-Forwarded-Encrypted: i=1; AJvYcCXeB1nCkstNh5iwutLgz57kMQPAx+Xl/eY21lFDADn7rAYWofsymKaOqMikst0gOItHA7+7dCwitw==@kvack.org
X-Gm-Message-State: AOJu0YxYjiBDt5tB+2IK7NQp8i+h9/Bywoz6A7wdrWB22ixl0NURGSxj
	0pIeYQDJik/q/A6HmeDbiqpOMJURysu3gxKKX0ESD2koYKiw0HX14sARIjxtDh91gefwzRaHnDo
	j1XDljKTCZvLb8B8sPq2aNeCls+x7As8KVaIWMBjcTXAQGB3Lv1q5
X-Gm-Gg: ASbGncvb7f+UC+DcwyTHO8OelrxuB2Hahnxqc0/b6rCvYNzyyKk/YxuC2VmDEfYzOqW
	Sg+FiNqS1Ie0Rw86TxZ55dGhh3ZKfCOXZ4rPD5NK4+w36oBSlpRG8tK27dn9VwiLM33zViDgv4i
	EA2ItaJBCYO40bfeUN2/GJoyIFMDQkqtOkc9A7ADbw8HYzU+8LqazZ3fb5JqgeNwGkJ3nLjTTYS
	0C1frMcE7n4jUrRJPB2sbPJCIHOkdZYSf75W4/C1DaFL5Tk8mqBKX0YJjey4x1eenVYYgdyv4q2
	mwnXW0sb+fXXA60lcEdgpxn03eu4I4FgJ0w2yAgZZvD9qukEUuAza5Vthy2zflKamKMX3zLmm55
	fctg=
X-Received: by 2002:a5d:588a:0:b0:3ec:4e41:fd86 with SMTP id ffacd0b85a97d-4267260e213mr13243096f8f.50.1760381738072;
        Mon, 13 Oct 2025 11:55:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEPPqcNOmGlljHBCVN9bgaBU+6o1qzRmLmYYfIm1ap1ibvD+SWGiqQat1UD7EflXC06Qt9AEg==
X-Received: by 2002:a5d:588a:0:b0:3ec:4e41:fd86 with SMTP id ffacd0b85a97d-4267260e213mr13243074f8f.50.1760381737607;
        Mon, 13 Oct 2025 11:55:37 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb497af18sm198743305e9.3.2025.10.13.11.55.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 11:55:37 -0700 (PDT)
Message-ID: <80b153cd-8bba-4bcd-9b56-3b2ad3f295e1@redhat.com>
Date: Mon, 13 Oct 2025 20:55:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Regerssion] [KSM] KSM CPU overhead in 6.16+ kernel compared to
 <=6.15 versions ("folio_walk_start" kernel object overhead)
To: 423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev,
 craftfever@murena.io, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 regressions@lists.linux.dev, xu.xin16@zte.com.cn,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com>
 <34d27471-80a4-49f8-b6cb-f2e51518d9ea@airmail.cc>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <34d27471-80a4-49f8-b6cb-f2e51518d9ea@airmail.cc>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4gmo-nFEcWbxqg7H_VTg4eMB5zwxnLdYL6KB5MZd1TM_1760381738
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 296B240004
X-Stat-Signature: mpnm8bkr65mtpgodhu7xodhcqukkmcx3
X-Rspam-User: 
X-HE-Tag: 1760381740-874625
X-HE-Meta: U2FsdGVkX19MyU4G2aijQm6MvCkCZ6GRYqPTUS6GhikpgfJuen/9J7CLx82UHuDgqTEQupJU2wATpyYHX57HRz7NNXIcU6Bh/jdkFcEuMy4gHy2qxOA/rtLPQEYoC7pTVp2ef4aB9/TLPAwZmNHy5w3pg4IW5tWQw6YEtg0DHqosjAbHF1IRBh6r2n0WEm1G5xzsPU0h/ObZNFlNh/BZV2/p7dVHmILWD8gJ7G68BNQxlCXT2IThLIJ22jokFQoN4GpPmaiDm0beC2KH42n396lUh1ls8P4GoYId8OySRQBNYo6iMj1cs5FsElaou34nTGapaNtC2y4yapykoDjlE/9aSBLBJT5LFNeOhrgCQjn7v/ImKbmOkKGO99/+vrYy3M0dyr2azb/pxz6A0w0XS+CEpxjZlhlrmvVeYOdEESebvtLbxkDbHEC8HlB3GzgOVWNsnGYF7wydcsUOqIyg0Nk9sn7lQECba5gHekbNL8MpthtIvnH6bF24lZX4KIINK4R9WEZsJr1R1wnaQ5gVlhL2TWi23Iuw/IgEZTGr47cXtjkwSaKlxeFMDk9skaVRiWKYSMMk36/ZEK2PJl3e+nGJJYQsCqVt0im1wc4NSZbeMFoQUddIw9P/TEkW/Zmb5kKTCpsYiVvbLIiRdKfj7sP2MTjAjctffi7+9fadS6xRAokC6UfHa93Ibt67R46a3/4PZuNIZSmw/IwglqMi9uKdHGSkQmhugzlyH6iQ31xT+dSsKxmJG+ijyb9cnuumRAlgn7PvcykrUjZ/sFEgPyk66OHA55ufP23lL0NYI3RXmGsCIcKwNgigehtH6JuHnpJll2EQCKwXy7dSjGnbB3eRN6ca3NHJGBE9sCBGuCp+ewekHJW1XpIK9OTnZGmGqyhVh/3yBmRfrBH2IXuFOVWh2aeVa157ijnCU8QHyvgvse1ID30ZzmnaV33Od/WvdHCtke0xmnj/Lau4hbf
 6gyMLqTo
 EzaCBZ0dfrHHR7YMIeSfOROJKt0okrApMr9pM3KTdj2HVvlJ3ABtKDmKHxBzlh3JCIBgfxmT3gp+nEgZ4jmpEj/yZDqwbHC7ZPAW48qSGsbzA1O7r0JcH5YA9Cez2eC1k23faL3UyByoa3gNQwnfJ+Rc3vFVariuHcmgsq76SVORdzJGh+kZ4Q/ai5047PhmPeflBqlMGb6mOjZ9YlL5X0/e8Fx+wX+Bk2L+3gyDwr7TLkK07oH3O2vYuif/6APa6QOEpJIQlL08qfQPNZlTuteF8SFKarc8WxNN1UIbxCuMi8llbAizitLEiCOt2m9O0tXJDk8V14qeP3Dovfpfnm2sWeGyrOZIDO/yYkfAfHxmrnTVCHhQFKisMoBCpD0osF94nZ7TxpcUCKYLQUSIEU4EmySoXpV/VQxTxiFEenRAT7UdnF/5LIlXdiQpbRVxHUqQAQHRKMsZys00c7FtxLNx9Y6BwC5KotIRx99ghqKsjvuL5rIlfoKdAJ3OStwLEFmdWTZ5agGxxENqtvK3xygFSIarj37z+4AFb6v03X4+EKDyv5eQrzwpuqniuOeoBr+2/Wu3MqOB9CIs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 19:09, craftfever wrote:
>   > Looking again, no, that's not the case. We do a cond_resched() after
> every page we looked up.
>   >
>   > Also, b1d3e9bbccb4 was introduced in v6.12 already. Regarding
> folio_walk_start(), also nothing major changed ever since v6.12.
>   >
>   > Looking at scan_get_next_rmap_item(). I guess we might hold the mmap
> lock for quite a long time (if we're iterating large areas where there
> are no suitable pages mapped -- very large sparse areas).
>   >
>   > That would explain why we end up calling folio_walk_start() that
> frequently.
>   >
>   > But nothing really changed in that regard lately in KSM code.
>   >
>   > What we probably should be doing, is give up the mmap lock after
> scanning a certain size. Or better, switch to per-VMA locks if possible.
>   >
>   > Also, looking up each address is highly inefficient if we end up having
>   > large empty areas. A range-walk function would be much better suited
> for that, so we can just jump over holes completely.
>   >
>   > But anyhow, nothing seems to have changed ever since 6.15 AFAIKT, so
> I'm not really sure what's going on here. Likely it's unrelated to KSM
> changes.
>   >
>   > -- Cheers
>   >
>   > David / dhildenb
>   >
> 
> I have to make a correction, folio_start_walk is present in "perf top"
> statistics on 6.12-6.15, it just consumes 0.5-1% of kernel time compared
> to 11-14% on 6.16+, where it causes ksmd 100% cpu usage compared <=6.15
> kernels.

I'm currently looking at the diff from 6.15 -> 6.16.

In KSM code nothing changed, really.

In folio_walk_start() itself nothing changed.

In the functions it calls also nothing relevant should have changed.


So the only explanation would be that it is simply called much more frequently.

And that might be the case if we are now scanning much, much larger VMAs that
are mostly empty, that would otherwise not be scanned.

I now recall that we had a fix from Lorenzo:

commit cf7e7a3503df0b71afd68ee84e9a09d4514cc2dd
Author: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date:   Thu May 29 18:15:47 2025 +0100

     mm: prevent KSM from breaking VMA merging for new VMAs
     
     If a user wishes to enable KSM mergeability for an entire process and all
     fork/exec'd processes that come after it, they use the prctl()
     PR_SET_MEMORY_MERGE operation.

That went into 6.17.

Assuming we merge more carefully now, we might no longer run into the

	if (!vma->anon_vma)
		ksm_scan.address = vma->vm_end;

For the gigantic VMAs and possibly end up scanning these gigantic empty VMAs.

Just a thought:

A) Can you reproduce on 6.17?

B) Does the 6.16 you are testing with contain a backport of that commit?

Definitely, scan_get_next_rmap_item() must be optimized to walk a sparse page table
more efficiently.


> I understand, that something changed in linked function, that
> affecting KSM behavior. Maybe, you can reproduce it with same settings,
> especially it happens with Chromium apps, there is V8 sandbox with huge
> VM size. Maybe, you could reproduce the problem with the same
> MemoryKSM=yes in user@.service, that sets KSM processing for all user
> processes, especially, when Chromium is running. KSM CPU usage really
> differs between 6.12-6.15 and 6.16+. Maybe, it's related to your
> explanation.

I'm afraid I don't currently have time to reproduce.

-- 
Cheers

David / dhildenb


