Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86EA0C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 292B98E001D; Wed, 23 Jul 2025 09:13:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243178E0002; Wed, 23 Jul 2025 09:13:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10B588E001D; Wed, 23 Jul 2025 09:13:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F37ED8E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:13:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A240C1DAF09
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:13:47 +0000 (UTC)
X-FDA: 83695571694.28.6A83ECD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4C0F818000F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:13:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VtOYgYQY;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753276425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WNsTttpzXt7BuB19w//5WAeWR9PeTbGdvwXUZjkwb7o=;
	b=zqjjWrZTo2W1oFG6hiFfsaccdk5Y0xHImk7i+IW49HeJd1y+mG2NcIV7kj7d5j+pj29Rq9
	LkOVfkyrMib5Nhd/P4fWgcB5o1EUfWV62aStzJ/8T6hPLvAXXnHQ7Dz+BLpJ9PxI5krVF3
	oisWSkHXcIJ4Pc2m/X7RKK9bwXYJzQ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753276425; a=rsa-sha256;
	cv=none;
	b=y0MfLRKSaUObvOt25qWOwCWQGZ933P81J33k4QOow/XUICM65mbDW9eT87Yphmo64HGGm7
	9glDUFQ3OjOr0kewT7dEi1nuF8tCpNGbaNprBo5qG2hg0GhVlLJFF1Ky7ZsIrWTG8SnDCF
	cWL4kPrrmPZZkc+GuUsGW/nb8xLlGmI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VtOYgYQY;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753276424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WNsTttpzXt7BuB19w//5WAeWR9PeTbGdvwXUZjkwb7o=;
	b=VtOYgYQY28x2A7bSkTwSlx0VXEBeYm6yVLhGBA41qHQqqQvTb1pBQ9/ruJvhPLqaSKJBsI
	idyRoHO62fcQN+HBN0ZE0uvBirznREMLi5oK/mQtm7aRP5GVgkaf1qCowYTj2WxSropID7
	1suu+3Lgvs4SAoeCBdxId9wNcGlZSuA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-99-UjV1GSlOPLiuUW64fyWSHg-1; Wed, 23 Jul 2025 09:13:43 -0400
X-MC-Unique: UjV1GSlOPLiuUW64fyWSHg-1
X-Mimecast-MFC-AGG-ID: UjV1GSlOPLiuUW64fyWSHg_1753276422
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45626e0d3e1so53839775e9.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:13:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753276422; x=1753881222;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WNsTttpzXt7BuB19w//5WAeWR9PeTbGdvwXUZjkwb7o=;
        b=Jpt37TPPjCVmnWv3+NCPf+SvuHrU22nS60o5scQNVOo7No49338+zFOqz6Z/dhlHmu
         CJVBgMlHrRhwYW/H1876i8BWDr4FIXwew/w9d2/p1r3CRsOlAsmhVnu2okndJr8YGi23
         R/pRwQGF6pn7D8UKnuJN7SvuVwPOGEVACuePpLXUOAlwLGDrtlq8Iwi8qD78J8x2oRzN
         SZxiS3Krg3ld02nEOGG+5jNy194Gce9BeU+2RZ0Hn8xGkrkJr+2xKgFyLXA7jH5bxTfe
         rS6v4V0UblF8/YdhlQjLFjaCn1cVtghVVsp6CYArlSm/4/Q5PiUz36E98L4Kd/rKPbLa
         9How==
X-Forwarded-Encrypted: i=1; AJvYcCWmwG/pPHC13zcipiT7nkWfLdESIE1QIb7Yw2TGnH2LTt0czCEMpRmxAwLSszRpkIR9r2R3CbXFDg==@kvack.org
X-Gm-Message-State: AOJu0YwRK9CHWoaeH3c/tiwdQv2wnjSQj9nkajpRQnOKSbIzGyM3fc+r
	e4N6WyhWfGxYmmJrkNt214zG7XfwgOgn92LZ55xidWafkAbBy4hVglODJYyaBvgwmauwi5cou1I
	jQi4hOaRwzVrL7R99144K3zibklLxkX9Pwv02OINQGfS3WOujB9Th
X-Gm-Gg: ASbGncveUte7JtEPegdNV6nzCvrTMncG3Swznzk4wJGYET9sfpeBllL1KdGuNh5KQFE
	n6HgImqupFabYjBerHDJXCX++oCA1P7sweGqKi0RpQcakxSURlw+aphcd/4Xw5Q2Ov89XHMqstX
	q0U3ujmiHlQUnZHQsdDwvYxlmvtdWVVmfYGgAqpG1zklPOhrRQiG/RFRz1ysQMVoxLnfxWhbii0
	Fee/DHsPpnHgl13vSDTGsSeXfzdI/oaKTbBNVGg+Sz7YhQt0QIE9qlzQ8g1iKqy5b+chY/2F7PY
	yB9hMwsYc3W4LV45CegahO3+bQroSHT8qnUaFdJVk80PY6m3/xTGweQQpzI3XEoMfP9T+5YTNWE
	hFPRcJCj9ZivgRjYu+d42pMszYrE8Fvqxn/wv7HOKlyT2fi7CQHo+x0Z30OckDuZj6Os=
X-Received: by 2002:a05:600c:6992:b0:43c:f8fe:dd82 with SMTP id 5b1f17b1804b1-45869580b01mr25222125e9.18.1753276421878;
        Wed, 23 Jul 2025 06:13:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHwYuDSBLOTHiVj0Wh3MHPmxHxu71mfC5e5j46cSfr2H+W9gY9MEaPOPTTU3x+pnNaIDwBYvQ==
X-Received: by 2002:a05:600c:6992:b0:43c:f8fe:dd82 with SMTP id 5b1f17b1804b1-45869580b01mr25221575e9.18.1753276421277;
        Wed, 23 Jul 2025 06:13:41 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f00:4000:a438:1541:1da1:723a? (p200300d82f004000a43815411da1723a.dip0.t-ipconnect.de. [2003:d8:2f00:4000:a438:1541:1da1:723a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca5d266sm16226012f8f.91.2025.07.23.06.13.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 06:13:40 -0700 (PDT)
Message-ID: <22b2f715-c64b-4c08-bdf9-10655a7791e2@redhat.com>
Date: Wed, 23 Jul 2025 15:13:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 03/22] KVM: x86: Select KVM_GENERIC_PRIVATE_MEM
 directly from KVM_SW_PROTECTED_VM
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250723104714.1674617-1-tabba@google.com>
 <20250723104714.1674617-4-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250723104714.1674617-4-tabba@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uJRiBP7JvJbmkWHnJRa3QpOIxMEG8ew41YV_s2fFF-Q_1753276422
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4C0F818000F
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: g37ahk5i7axira1yrz68c16hhs1yeuk8
X-HE-Tag: 1753276425-539609
X-HE-Meta: U2FsdGVkX189NnovCAZBJDwcOUG4c8MDxWAnhIk69OqEAo7ZwMZWJndP/3JfxCWQfLpcX644naT61R+oG23PR1AdNoPIDNTq0muSnPPbasgasIqydEfSemyrH7ZnqXC6uSSo2n4FdZr5QvCS3mdotIspPuLndR3dHvL5wniA58HMjNjcQn+Am0ZeEHkU4OWe0KuODIx+cw6ucm/GSqlG9tHQmMyJ8q6YfVd3PfZe5EIdCyYmH3/sFB4UP+iiffyNYcul4HZjnlCrfGMMxnzJezWzd0YLfyaOkgx9cIfGkCJ3kpAninqhYOBdR1PE5mYc9+KaDTAbYNl5JJ6SRMWNq63Lr9ohfAGqndqAqAlrtSbZRZDJhVdSgbx3csokwljZs0qiv/zOJ5gIe4FgQEeKIEBa9cWB6mq6UWJVd3IT2T2HTi512QJwVaIE6c2Ny5Lv64QMx3uQb+0FyFdx9AIWaN9vL8OFIJmfdcTuvVK3wKxFa/wewev7ZuZrAt8VKs/Gx3GjwOCfNU09hK/jVCd6vUGKdZB9Rr7H5ScnS1qK1HrXb0QBVDyfW4a8FZQ7RlRUCb4J3tDASdr1e79Pqdz6iGpXkLuTmpcCl/YMIUwHakDTiSy15S2uvt4AHnPeA/swalJ+TX5TYe716S7AP3xdEOdXZ2/YrLxW8zz5y7wxjRaLlFd+ah7/fws5qe9BLCH6BUWukNvFl/JwDcYlPAci0U3f7IX/Anr4KBaZ4Kx1ATh+E47M0xhTdjdaskpYFNon4PcvN9lfXXxdTTFcdYj7/mLEx1zV6P888cwlPA0BxzJG2K5bWxz0Gt/vAGAxksRzBEMb/9CaZTlLys9/hj/zsO4R74efBDSLlbsBWfAKgb6Dl8hQgano4jHM9fown1V+LxpApPrsbLC9NEb76veseBsxQlEzI45qhXVgUK9ivkKm6XzOYXBEX32m3Z6cc/jFTkoVycKhA6XnfzHvGhJ
 MYZ6E50M
 P+l/5wx75RXRStZmjMAmIcIyR4o+b7TlKW57CBj0WDXP6eDfgQIEwA8u2uaCCUPePP9dR40uco6CPLHLH4Ot5DYU1iHAKWwHKmydeIxC3e8W9i9OiaHp36QOPOvIczmgY+YBhX3zV8fD5dH1yzsKmqCMSOIJdwcOPgJmc0SmhRKnJ7yiCcfxkMsg65yKjDovR3G8t9r1MYDiwiGnnIGrKD06MSbWCkKS/KpJKBbLc36Al9+v1SH6xruOGj6ZbJ9cC/wrQKwOx4ljXISNnIV6Si4XihYKaZfKkiItwoyvwpFfM+mm5g5d4R7KY8HRurej3I/RK6WBj4ofozhPSHyXvauZPNw7Uf02VfwThK2eOlan0zX70OV3x7k2x90Jmb1kjDaFXQGNFUybfbhZSayVTnDVsf25nQmPmEHYQNfA14GBrC3HxzMyM4R0oldbFoVzBGRYwI7KmN/baJDUq3/rshOkNw57KgXhwQWNZsPN0cjJdBUwHve3NRPpfHbtsNH3rIDi58uf4MExtufSfwS4aTF/0bA+qp8NyS1MI/fePW7Y4eb326jX/3UoDwtSqTf96itt5eFA5S1hfSmVEr8UaLm78bQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.07.25 12:46, Fuad Tabba wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Now that KVM_SW_PROTECTED_VM doesn't have a hidden dependency on KVM_X86,
> select KVM_GENERIC_PRIVATE_MEM from within KVM_SW_PROTECTED_VM instead of
> conditionally selecting it from KVM_X86.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


