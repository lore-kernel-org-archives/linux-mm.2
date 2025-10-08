Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D30D1CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 08:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2499D8E000D; Wed,  8 Oct 2025 04:02:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 220798E0002; Wed,  8 Oct 2025 04:02:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EAC08E000D; Wed,  8 Oct 2025 04:02:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDD298E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:02:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9F59C160455
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:02:35 +0000 (UTC)
X-FDA: 83974205070.25.3F1EECD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3DC3E120004
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:02:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aVQSMVrl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759910553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pddHH/uKIG+2OdAE3dfwxjSpPlFOQuBykDEPMc5UKGA=;
	b=gFFA3YosjlpWb4svemEgqzMd9es4bHVuTn2Zb1BCwsRTmaXyGnUxzvdr4sWIinqqnqfNbD
	HPWs2q4X0+NCc34PWs4idDg7Vnl92UJkUCLE9J+q2zzujIz+lNFqGRpMyn5MG0leaadKKz
	2Lky8q2JRwjKlE2JfwI2LlFgMPvb7aY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759910553; a=rsa-sha256;
	cv=none;
	b=WqgZdEePfg3m/Gsy1Zg963rE6FK3OMePxe4vQQK/ZDP6SyYwO5PBsa579CeSEHXz192iWt
	a+qWkdan2NAYcnyPYX7faOy5TOl/0+aLj8GfocLYYKzu2nfgQtp+MvxisUhi7J7PJCIQ7A
	knakot+fWfSehEmtOqHHuo3dEB/SMPA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aVQSMVrl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759910552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pddHH/uKIG+2OdAE3dfwxjSpPlFOQuBykDEPMc5UKGA=;
	b=aVQSMVrliEYvrPpdMO+VoIgDrNP8XV5XWd0ujqs0TJCak8xaF0l2B6LePTZpjK3DZR/WQE
	jECg/Clk05Dr9kPOGrugJnht7GJX2wZP62PTYTtdF43zawcXT3u4SRE0xQPPezm1T5K4gE
	H8dePjuwFY7+NN4x3RomFSU7tz6E4NA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-RVNS6eWTOWOk7UoP95vDbA-1; Wed, 08 Oct 2025 04:02:31 -0400
X-MC-Unique: RVNS6eWTOWOk7UoP95vDbA-1
X-Mimecast-MFC-AGG-ID: RVNS6eWTOWOk7UoP95vDbA_1759910550
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ee12ab7f33so3877192f8f.2
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 01:02:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759910550; x=1760515350;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pddHH/uKIG+2OdAE3dfwxjSpPlFOQuBykDEPMc5UKGA=;
        b=TrCy/r9wenRS1XG3PjHcQt3FqUGsdsHBQbjB2T8hcmctLTdB/l19VCrrSVn7QUsUxD
         B7omSgCWP6HBWqhvi18U68qlisAfXoGnV0pxrlArOak9Bx0R3qrGjAFoNuB53Gz39OSK
         7duXgbvJuM2A3YfI0exzLlrOGCu/GKZ6OaKmClmFTImxdWa09722t9bmXJ8FALR6y9NT
         evTytgYyMkSGSfDJrJuS/cXPCahlO8374GsaJmuAC9YYkv3mcvnD84zTPUspOFdYFZ41
         KdFHp0OlFQ5yhJ9qAy10A4/uCZUEUV29yUBIlyOJp2Osj2DkHcK8ClmSSAGvtnGiZDG5
         NuDg==
X-Forwarded-Encrypted: i=1; AJvYcCUXGxjv2WwBLtXKs/UxPxh2vm8lV1tGtCfHwH9Lvnq4lMEtcl6HzDMlqaKVQ+v/Lkt1IWBBmYa+zQ==@kvack.org
X-Gm-Message-State: AOJu0YxsHuokSJJElidRUUKYCjICsi31Vg51BrJy3tFU4IzcznewQzSz
	7OfERoXLWDRgMov+imkD4uCGmdoPrPZ4u0Wbi1tr68SxVpv9aimR54RrnsrK5nPgllsgoQqjV7s
	Y3gdxLMUCBbMLXANbuwktCCZCICfGWahr2ZoejMgURGlqGRNW2uR3
X-Gm-Gg: ASbGnct7dLCNirhldWHoviCp65F/JZ5yBDqJoeVclP+VOjujFVlCa+kg16ZShMAQJyu
	GiLWwPEksuumI14NNUaRHiFCW3HMDoBCToaVHfXyhJ36TMCdrWsdnsS9E6uQTr3HBuSfV6d/ihN
	KPbZ4qQlMSofW3qIEI1fYZ1ANogHSy8vQabK/VO5R/pe/DH7JmFlJW41uQaXTHkG9DsnO1LuLhs
	icFfTPnLX+uYfMbGjj9rmR3x6nSHpjK/LPEJ+25GhG7yYI1qcPz/y8NiX0YCiXKalZdHrG3Bt9t
	HL2h18pGcL+7yYqCLjgp0sVGmvHGAQpCvnKt0wx0RTpZzZ90zfCUKO9uHi02flMkZqXEuUDr4Ut
	W+WqPNbSN
X-Received: by 2002:a05:600c:34c2:b0:46e:21c8:ad37 with SMTP id 5b1f17b1804b1-46fa9b06d3dmr14877385e9.25.1759910550018;
        Wed, 08 Oct 2025 01:02:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEbw0aJZMLEsvRDrluvzxmPzzAjNZ2fUN5jdXsXVmOstYYrD7freeeFECzzcJlyO/7OK6m0A==
X-Received: by 2002:a05:600c:34c2:b0:46e:21c8:ad37 with SMTP id 5b1f17b1804b1-46fa9b06d3dmr14877115e9.25.1759910549578;
        Wed, 08 Oct 2025 01:02:29 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f083asm28904014f8f.43.2025.10.08.01.02.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 01:02:28 -0700 (PDT)
Message-ID: <1efcb368-fcdf-4bdd-8b94-a705b7806bc2@redhat.com>
Date: Wed, 8 Oct 2025 10:02:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] Support dynamic (de)configuration of memory
To: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-s390
 <linux-s390@vger.kernel.org>, Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>
References: <20250926131527.3260733-1-sumanthk@linux.ibm.com>
 <ab366c03-8c78-449d-bfc4-2d155212d9d7@redhat.com>
 <aOVUNmDiWgrDJ1dJ@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
 <5e3b16ec-9ef9-483e-b97e-bff0c1915b19@redhat.com>
 <aOX_L1_2S30XhLRA@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aOX_L1_2S30XhLRA@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NXBxX2ybfImijm3kF3PYfqrz6LJClJvrjKy04GPP_zw_1759910550
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DC3E120004
X-Rspamd-Server: rspam02
X-Stat-Signature: zhpbmhyu464rze37r3gsdta6smekzaup
X-HE-Tag: 1759910553-652182
X-HE-Meta: U2FsdGVkX1/EB7ZWDXL/KKIMJqg0narf8n98Hj1T3zNVO3Huea4uNgKgGLShBlZp3Ca0A8BRv660uUkQqXuK8HLNzhKv+OPfmYo6CEgCwz9DkE3zig9fCh6ZYjiNYulXP2Ss++KVX6Zc3cetYByE5ojAJITjvyZnMhK/Uy0wNPI1ztblXW1fNfpLm/olWk5Z9Dvn22N7MN2qAhBscSEydE8MYwRNXKpMk1g2pm+tDC7MJYe5O8C8W0G6IyjVc6MKS1WXn1DbgePL4QiW7bFlazKYoAw3/QUgfq706YoAPVoVKe4Zow47IO5v8oHGTUBzV/1tKU/rZWgman6rCDAtVfd/iLxjVJCO8OnAGTBLTIWlQqz1ius6s5kLiJOpMubidWhstSLiitQPy7fj+nPw9amiN+mMpx/1qGH0XIP2Kh9QsVnU/TPNhVq7VN3ZDE63aMecgGYXnLvGszF+3CJwqE1JvO0OJby0PKpcXuVx0uoSWBGlbQbl4IUuwCJELGSPcENkP9iXB7g69vChrCrdkFbqyBFdWNBHF0oMDQ8zvIG/532rFIuPqCW9rrt9z2UNomEZy4D8ojLoOO+ZRQpXEdHW6OSQm7ElPo1JvDfNr+Vu3H2JhQQBcbFF0DDku0uEI4sSwMDKnts8cDZUwUa8J6yzmxWg7YiMaaJ3I69AGHGM+QjgB+GmO6FYFGpjL9R8JVsarTpGNLyYOZ6iqMTA7DC0wOD/5yghm91qjjrcMb//JHUgoRLFiqqgEpGw2Fx8nhvW/bPHvImFohNIwSXXttwqWroJXX/2JhUbB6I+HCIjAlRRJZRiz7l7Jz7udtDS72ZM+U19AybACCutCZ3BEdkzZVE4io8oFDAoFTSffdq+0kJy+NOld1HNVMukYDBssPDKXS82/LaL1IqvCKdElZp7YomuXFM8CVPJZ2ht4C7X1VvIxX2xeJoVBk34KsyoQ1kWatYmNX5oWUFQnPC
 UGDtz61E
 /Ia+F/f7aAG1vSZ/NaLv9UsN0i8nLa0zDa6biKcH++Yx1TpXLptIUYOzxnq3oz+RvH19+Tu6jOpasBu+cUBKLX69VwZKWFqqVRDLb7Lqeu/vrE0sKOKbCz2ggsk4SB5Rp8Ts6Dcs4rgK6oF8eMCo30FFWpCrFStgYP3cIMXOMfA9HoHZ1k5CHrAvA8CRVJiQEPsM6e3uRdwPDpLCrsc6xOY7Xp5qnkXSKJg+34nthaojJmKyG14EfrfZjznpdEnqy51ULbUStu8XLCfsMs7vmMMqkzY8n4BPwZ0cPAi4Hz8h+9CfhCcqS6mOAZxJTRUpYLlRNQDgjMx0Hvzp61vIDhQ4hKTkCsm0y+5jaF3P+4B3FpsZtilUUP03SNvmW89mlcepgWGy0LxZGohF+tAmLjKuppsch4WI9pb6A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.10.25 08:05, Sumanth Korikkar wrote:
>> Care to share an example output? I only have a s390x VM with 2 CPUs and no
>> way to configure/deconfigure.
> 
> lscpu -e
> CPU NODE DRAWER BOOK SOCKET CORE L1d:L1i:L2 ONLINE CONFIGURED POLARIZATION ADDRESS
>    0    0      0    0      0    0 0:0:0         yes yes        vert-medium  0
>    1    0      0    0      0    0 1:1:1         yes yes        vert-medium  1
>    2    0      0    0      0    1 2:2:2         yes yes        vert-low     2
>    3    0      0    0      0    1 3:3:3         yes yes        vert-low     3
>    
> # chcpu -d 2-3
> CPU 2 disabled
> CPU 3 disabled
> # chcpu -g 2
> CPU 2 deconfigured
> # chcpu -c 2
> CPU 2 configured
> # chcpu -e 2-3
> CPU 2 enabled
> CPU 3 enabled

Makes sense, thanks!

> 
>>> chmem changes would look like:
>>> chmem -c 128M -m 1 : configure memory with memmap-on-memory enabled
>>> chmem -g 128M : deconfigure memory
>>
>> I wonder if the above two are really required. I would expect most/all users
>> to simply keep using -e / -d.
>>
>> Sure, there might be some corner cases, but I would assume most people to
>> not want to care about memmap-on-memory with the new model.
> 
> I believe this remains very beneficial for customers in the following
> scenario:
> 
> 1) Initial memory layout:
> 4 GB configured online
> 512 GB standby
> 
> If memory_hotplug.memmap_on_memory=Y is set in the kernel command line:
> Suppose user requires more memory and onlines 256 GB. With memmap-on-memory
> enabled, this likely succeeds by default.
> 
> Later, the user needs 256 GB of contiguous physical memory across memory
> blocks. Then, the user can still configure those memory blocks with
> memmap-on-memory disabled and online it.
> 
> 2) If the administrator forgets to configure
> memory_hotplug.memmap_on_memory=Y, the following steps can be taken:
> Rescue from OOM situations: configure with memmap-on-memory enabled, online it.

That's my point: I don't consider either very likely to be used by 
actual admins.

I guess in (1) it really only is a problem with very big memory blocks. 
Assuming a memory block is just 128 MiB (or even 1 GiB), you can 
add+online them individually. Once you succeeded with the first one 
(very likely), the other ones will follow.

Sure, if you are so low on memory that you cannot even a single memory 
block, then memmap-on-memory makes sense.

But note that memmap-on-memory was added to handle hotplug of large 
chunks of memory (large DIMM/NVDIMM, large CXL device) in one go, 
without the chance to add+online individual memory blocks incrementally.

That's also the reason why I didn't care so far to implement 
memmap-on-memory support for virito-mem: as we add+online individual 
(small) emmory blocks, the implementation effort for supporting 
memmap_on_memory was so far not warranted.

(it's a bit trickier for virtio-mem to implement :) )

-- 
Cheers

David / dhildenb


