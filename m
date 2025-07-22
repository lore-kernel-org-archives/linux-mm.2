Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67252C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF8F48E0007; Tue, 22 Jul 2025 11:20:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E80038E0001; Tue, 22 Jul 2025 11:20:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D213C8E0007; Tue, 22 Jul 2025 11:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B8E208E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:20:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6AF0958EFB
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:20:32 +0000 (UTC)
X-FDA: 83692262304.28.B9C4DA5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id E84C98000A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:20:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="BCyM/fJT";
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753197630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UR686UB6W95T3RcYAhWHnco9tSypYtrsdOEb8UEkv7E=;
	b=eFs6MFKMmqE3eHwp6iJAP6lOWU1kU+pUhfwYd3xfdZxJO2sl5YguULOXmWWB5+isIWL716
	VKhczb2+o8N7QCj0E+2HPqe2Aucp2J6Cmu56xkkZ4faWH+UT3e/OJ8fyZwWhZorSqHUA8P
	zbHs0Bj3bAxPCmtDuwbyh1OZcHJP9aI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753197630; a=rsa-sha256;
	cv=none;
	b=lG43yzZtz3aurDRphpQ/yTQ65mpVle344GdKleIetZ8TizUY1q/ySv1+nXnsQQ/246VZVn
	JL1ZbtM/jQETxg07nVH4748TsQrNGFxNc9jUmRv7lmQlyzx11qL2OlZk0Cqd3If4XDHfzy
	rZzEYwvgFyvdDhiFa7g5gVOizn+O8hg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="BCyM/fJT";
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753197629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UR686UB6W95T3RcYAhWHnco9tSypYtrsdOEb8UEkv7E=;
	b=BCyM/fJTLec8DSK8VlC5rTRXteotCE2s9QEgC5jdDd1sPCMSlZywGQrq2/OyL4ojVjDlG+
	x56L7Kiwxovn+Ty5zAqyzIP0YObOlD3a9oFywJY0q4etj+VWjwc2+xdEOG6UyuUKBEBLs9
	lTu5OVpBd224x+nNP3sGNB6/CkTZJxg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-523-2PcJ03kMOaWMi4iLQOWN6w-1; Tue, 22 Jul 2025 11:20:28 -0400
X-MC-Unique: 2PcJ03kMOaWMi4iLQOWN6w-1
X-Mimecast-MFC-AGG-ID: 2PcJ03kMOaWMi4iLQOWN6w_1753197627
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-455ea9cb0beso43468545e9.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:20:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753197627; x=1753802427;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UR686UB6W95T3RcYAhWHnco9tSypYtrsdOEb8UEkv7E=;
        b=SwfxcxCLGuJBQNnwrycxOY+uM8ggjMSy0OQ6+Al9q9dbEtZsgvCGDiJn/6Qbxp3ENv
         Q6Jz4uFLFRKj0P4M2cQY0rOmidjkNWUtAr67d1/QRd5/xuet+h2Vw6NfpnsnuwKMRl6Z
         V5g5ZMr2RvoK5w4wz8xEGjJoHeBHqAMVyiZC77luZk/4aPrQR6Z3DDj3iOlkf98ukFO8
         2D8DZviedSKd5Vil/R9Ilm51UrU6vtcpD0npGJjsZPBgOZFaEiW3RvzLrMNYbBcBYHln
         FQfEisO4bE3ep5Lm0QeQYDkok8XHn7HQ4qsHLMu5HXNRxvpCYQjtHDRb4zwEinXpMTIG
         iBnw==
X-Forwarded-Encrypted: i=1; AJvYcCUuRZYbOP/SPNUpX/LhHfiYfUkL6j4iftmtFto4WMlWqiwC26N5DnIPkfIFbUbcfbsNiKXMOIs7ew==@kvack.org
X-Gm-Message-State: AOJu0YzX75t5woDRTCI9ds8fYX2cgf0yYAz8KjJHXzmQvOKJWW68o8Ih
	v+yr41pNedclvYhRgE4CdH749dhT7hEACi+QMCZxlkphD0Tpy48jJENQWvfuF9/B7zWfpK/v+rv
	042AuP2YPBiF5fHjJi4vE58V9sYjnGeuD18XP019mtCfDpwxnJ6Ai
X-Gm-Gg: ASbGncuVK2t3D9xjkLPfoDMFPl1nBmGqoHnPsgUmnrVv9DjLsnTyi/DWT/GMzS3PEWp
	eijeVvlhQR0YLm4G9p8vtpGBgqxYJ6xCBnhsdGU+ljOyXto5ylLCegApdSZ1Au+i29YrKE+CjNc
	0ziw/1Zm6+g6U9mS/hua5FUEIzpu1M+6PYDO80cqknmbmVVjAawLFfeSyomqqxiZK2gxHZbev7d
	CZV/EDux3IW+pKvdZgMfagBEPaZISzk8iZebIZCOqxaxciqjCeWUCTZ/zoDi7WsIgRmBnCBPfS1
	jmkTp+g2bSYZ1BPXBy1q+Ps+jA2g8O4I56TP9B9itQOhUZb+zHqtwK1jdI7HbEZ5W5634bx5+/9
	AZzEjSKVffu0y1lN45F3SSz6ZUK9R5d19TWkTxVg1NzVfyp/tH7PnRjU4kNGsFh1+DQY=
X-Received: by 2002:a05:600c:4f4b:b0:450:d01f:de6f with SMTP id 5b1f17b1804b1-456340160d3mr221374545e9.15.1753197626668;
        Tue, 22 Jul 2025 08:20:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHa43nqfLMQERCC1j/wmVHQ7UtK8l0NZCMFbPH2YHsoDOoAl1UMnjReWSKUBgR3S4TG9WNPmw==
X-Received: by 2002:a05:600c:4f4b:b0:450:d01f:de6f with SMTP id 5b1f17b1804b1-456340160d3mr221373905e9.15.1753197625794;
        Tue, 22 Jul 2025 08:20:25 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:de00:1efe:3ea4:63ba:1713? (p200300d82f28de001efe3ea463ba1713.dip0.t-ipconnect.de. [2003:d8:2f28:de00:1efe:3ea4:63ba:1713])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4586144f80asm38163855e9.1.2025.07.22.08.20.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 08:20:25 -0700 (PDT)
Message-ID: <2dae19aa-7913-4350-b031-38d00a20057f@redhat.com>
Date: Tue, 22 Jul 2025 17:20:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V9 2/7] mm/filemap: Add NUMA mempolicy support to
 filemap_alloc_folio()
To: Shivank Garg <shivankg@amd.com>, seanjc@google.com, vbabka@suse.cz,
 willy@infradead.org, akpm@linux-foundation.org, shuah@kernel.org,
 pbonzini@redhat.com, brauner@kernel.org, viro@zeniv.linux.org.uk
Cc: ackerleytng@google.com, paul@paul-moore.com, jmorris@namei.org,
 serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com, tabba@google.com,
 vannapurve@google.com, chao.gao@intel.com, bharata@amd.com, nikunj@amd.com,
 michael.day@amd.com, shdhiman@amd.com, yan.y.zhao@intel.com,
 Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com, michael.roth@amd.com,
 aik@amd.com, jgg@nvidia.com, kalyazin@amazon.com, peterx@redhat.com,
 jack@suse.cz, rppt@kernel.org, hch@infradead.org, cgzones@googlemail.com,
 ira.weiny@intel.com, rientjes@google.com, roypat@amazon.co.uk,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 kent.overstreet@linux.dev, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 chao.p.peng@intel.com, amit@infradead.org, ddutile@redhat.com,
 dan.j.williams@intel.com, ashish.kalra@amd.com, gshan@redhat.com,
 jgowans@amazon.com, pankaj.gupta@amd.com, papaluri@amd.com,
 yuzhao@google.com, suzuki.poulose@arm.com, quic_eberman@quicinc.com,
 aneeshkumar.kizhakeveetil@arm.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-coco@lists.linux.dev
References: <20250713174339.13981-2-shivankg@amd.com>
 <20250713174339.13981-5-shivankg@amd.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250713174339.13981-5-shivankg@amd.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qiT5nq_OFf-nUbZOhq_HpzDWqZf51fdpBKL_iVEnLFQ_1753197627
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E84C98000A
X-Stat-Signature: bb3yk5k7jxjcp1b7ebtuy87xmozj9fbg
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753197629-316207
X-HE-Meta: U2FsdGVkX1+81ACr4keJCqm/vrrqlk6d19ugGKIX2BAGEJ4vLW0gotmg3Lqdc49TivUA2oOFn/Z3jhB4pqkZWay8VYFofoAWvspMmhGLTK0YOf3UZvgVJ6LSaAJpuj7T1LAqBg+tvJegLeYctS+J1yR4FwSJFmtNqnzN3OV6V/dBuW+6sKwb5EhdCcf90h12fsXKvo6XBKi6hbO4URy7QmO72qoL526JPzEtOlQ15nkmovEvDTaRPjvituo/WwB1o2tSrvKfY04qQOTC0WhyHJLN8K3CyC8wGA/IkwDmuMJYcru0nJYY3mkNfNNfqzQWV4hT2Sl7mE+MKKAPouC9mSTChF9vvKjlwXSn6aZ1p7N3barfB5teb2Yokflbl+685zjaAFXUiK6mYTw7ewls59ORqbtofMvVnGQCJYuvNkEXEDeAF/O7XbfdPyM29hsLOEP7ST+HRwpr6VoYGp/RoEgUcrQC3L+bEL/eZr2z1fa0dZiBjZcdkggYphQarV7vMbmF69hyEZcBR3KGb4MBmrIl21W14oDEbD87YxQlpSdk1TGXDkm4RaskDqWQKcxj9oTQgjUfogEnKOYE3TfxZ9nEESDV9LUepYvrETYZNrvy7VlpeSX/YdWnC7OoSwj/LJv88SY5pq4SpzK0sm4qQjoVrmjrxaUzpDRznwWtGGCNopRM+886fNaWgHGal7J0hp3wVDTOmXtE9TNGATIJWm1vShoxBwDkLThzAdQ0zz8raUYF6Y1BppYr11fG2s4gkczR5tesx+qV7ql1vlKTuC839DSAjYDaJ0OZ0HRTvjA+ZLqGxYzKJ2OOBmMgqYC4sMOXAYua4rych15KtUf2KQ6hdjWTkcSBgEja2LWnBVscziSaA4Db4aEV/+gJQ8YJeesxmD7L/QDNcyx0hikuzGI42gQsmk8+Ky/7OjkyGgSvlzPGgQcWKjRrSQKFfn/6rYNnHFWNkRvZqu1qhGT
 Vs+x5VuN
 vjsMd/bXTeFHXSb9Vx0onD/qaPZC1uv1OsateIYzoQf8rhXiXSa5z6825+SRLB0OP/3tvT2c/bTaqA62sbyjKNfAAE1uHiiCzQasVuPKNfKKh3T0/sQP9HhkbdT3oA2g97L1nwwW6gzxtuBENFqt3/TU8cjVinnZ/yKHQ/26Q25bfjcuzUeOw7IUhTEHNi7lRVF/ueae/3sIK7aNhOXOr2KTNSdXtZaazUE1IXTRwP7SODNMrQRUudPRs3APWzavDxRmAFQte+kWhXSidedQQK+6aE/kszPTYFuMVnXJzry4rfDyikAKPzV/5uVniJqTqsgwfDm/idiD4gP7TQBj1Lzc95l/0EmFSLq74//+ga4ok+pkxvCcb11yJPHkjrJknt63x68010lYH6MmQOVHd1/h7E65ntlib6imTks70bAa6QApS4jsou7h5mfqKBwdd0AipQ9uYSk+TqrD9x7fbq8I4R4a8rF2yNi2ep9e0vfjxf5jJGWJH9ADOWH5o8Jo21rPw6qH+A4/yvAPjXrzUfqCrMX8MmN69ynf3iSFmHcHYGXQXohhmDLEfrv4mE2/stVv7CT9Buf4Hw+O4h9UK02gFhGpi+8bNaxeqkF/iwkwAAc99MLKZq8/am2FtMOymtCGB6TJzojM9iJw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.07.25 19:43, Shivank Garg wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Add a mempolicy parameter to filemap_alloc_folio() to enable NUMA-aware
> page cache allocations. This will be used by upcoming changes to
> support NUMA policies in guest-memfd, where guest_memory need to be
> allocated NUMA policy specified by VMM.
> 
> All existing users pass NULL maintaining current behavior.
> 
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


