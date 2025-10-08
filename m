Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04AE1CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 08:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A4798E0017; Wed,  8 Oct 2025 04:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47C9C8E0002; Wed,  8 Oct 2025 04:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36AC98E0017; Wed,  8 Oct 2025 04:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 250B28E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:28:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CC55D8781C
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:28:33 +0000 (UTC)
X-FDA: 83974270506.24.62A13DB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6F86F4000F
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:28:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IviSIUKh;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759912111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lgA+tVTVFPOH/IagYGfwbQiNMHCdePGaYyMYs/mQ1ng=;
	b=qD/gmJjUrN8EKEkvzvPEoRM74nPw+wohYvWJUAW22fz4OfZip+bSRwiMQFxiTFV38dmqLG
	tPbLuM7hx8wPNxqbStqDr7qUdU2pAN83Qloj+CBJIsT4UKOVn/z6pCUcgLgb2TQH71rdrD
	Senmiex61Mu/7sXW+Ehk5CMkjf+F5i8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IviSIUKh;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759912111; a=rsa-sha256;
	cv=none;
	b=13BaB+P4YhYele234d71tnQjdzF1XKXE61SvPG5ZrwuKexmf2RmEOvyPmIrgP/J0G9XRAf
	QbBJWopFVgqAgJ4+u0a5+jOt4/hkttO947bB+Kx4/AX0bN7oxgvLDMSyEHdtOM49xsCImJ
	nST6I5dNyaPqestgqR+rN/CTkkJ7UTs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759912110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lgA+tVTVFPOH/IagYGfwbQiNMHCdePGaYyMYs/mQ1ng=;
	b=IviSIUKh7eQJJGh3wCbBTVHgFMMIQksxjKG2UrCAdWJVGdCdZMFog6F7HbbgDvbDhcpEmr
	ofH+zVY+16Jz60JhPvYVtZoJgHOV8zi0BkcL8+ckWhicwbhiI9WQL5kp6NkhuiPu5EFjMY
	Y5Ki+i2gvfwmrZ7lGHj5CeInxuXE0ZQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-363-w1ap0l86NQG5rrAK80Jxog-1; Wed, 08 Oct 2025 04:28:27 -0400
X-MC-Unique: w1ap0l86NQG5rrAK80Jxog-1
X-Mimecast-MFC-AGG-ID: w1ap0l86NQG5rrAK80Jxog_1759912106
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ee10a24246so3685878f8f.3
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 01:28:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759912106; x=1760516906;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lgA+tVTVFPOH/IagYGfwbQiNMHCdePGaYyMYs/mQ1ng=;
        b=iTpGNPjoWzhBklGVclTVAP8LlMqNVBtsAOr926VnC8LckB34Hn/yIklUThWLLBbSHA
         df8q/DXRkvTcqGw1I3HvxrtvHb08ijmOBimMqjifscXLIqZq+Jr22/0nVwCHRgqtg4hz
         CIXxFS+UnKP3UpKMDWbY0v/f6FaywENpfhAFliMO2ytQUgxKHDMknNoFn1EArTDoLeC2
         gypZqN77Km7Zffo/ref1DQWDMcrpc3Eh6AUiypWKUdGdSGJG8BpPjcga9A+c/pbsvPjD
         qq9e2OVwEfnmHUph4Sh+bUYGha030ovILUqoAimDjMwNJigj97MrWFulsJR2imPZfQCj
         20JA==
X-Forwarded-Encrypted: i=1; AJvYcCWdL9qj6jbHo7QDExNA7T08eVsi5Y1ypyAleO1S6ScCS/yMy1YVHaG6hwGJk+cqSMXZIo4gsZ1QBQ==@kvack.org
X-Gm-Message-State: AOJu0YxVjJPDDePiuwLZlsxDXusVRtav6McMt3417+lHQcpdZyK//Kio
	S0M1BJsfSRX3oNm8UWOunNRgdvpSYLvr6B1TasgonZQE3WqSMP49j0IV2nIgVD3yjfnXNXQd2NJ
	cssMXT+fll74dduDJP9mHtn6aq4XmF7x4nk+j+Y7xrJCZTOXyErpB
X-Gm-Gg: ASbGncvm9uI+Qs6a/MaZMXUicip8oK/X1n0n3gnyW81WH4XKwWCyhIhCCZaD1nPgKXd
	AAout4cJoL7Ns37lSAbAwwoKVzPRIWyI37bZasfdzziVe9KkLOqoudyzP136ypE0KiAK9eTemEk
	82cDvQxiLXoxj5SQvTmJ/JiD89nrBfdlcTq2QHRiX3xqgL7Xf2J6PbZrTYuu7b8czRVhAwVp7Fy
	LwOahegh4qttZkDOLe6xytC/LQHTkW3SvKYUkooDuj5MY/gQ6xRp+7JL5oN7bGeGlSHhpu880zV
	AAorfhvtrPn9Yi8tHBhkbgcJ+5WK4Gc/kXZybCjau+NkkcmJUmprOzwL1k4uUmmyoc0Q+sUKQQH
	FJTLi61d2
X-Received: by 2002:a05:6000:1ac8:b0:3ee:1118:df81 with SMTP id ffacd0b85a97d-42666abb532mr1522622f8f.13.1759912106363;
        Wed, 08 Oct 2025 01:28:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEU7A/ilDozaFzXNrA4EK/JkMpcDnq8RVYdbBoUgVDvboLxb5QtC0kI8nRYuU9+KmgVx5jgmw==
X-Received: by 2002:a05:6000:1ac8:b0:3ee:1118:df81 with SMTP id ffacd0b85a97d-42666abb532mr1522597f8f.13.1759912105942;
        Wed, 08 Oct 2025 01:28:25 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f0853sm29247216f8f.50.2025.10.08.01.28.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 01:28:25 -0700 (PDT)
Message-ID: <7723a2c7-3750-44f7-9eb5-4ef64b64fbb8@redhat.com>
Date: Wed, 8 Oct 2025 10:28:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 mm-new 03/11] mm: thp: add support for BPF based THP
 order selection
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, Johannes Weiner
 <hannes@cmpxchg.org>, usamaarif642@gmail.com,
 gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 David Rientjes <rientjes@google.com>, Jonathan Corbet <corbet@lwn.net>,
 21cnbao@gmail.com, Shakeel Butt <shakeel.butt@linux.dev>,
 Tejun Heo <tj@kernel.org>, lance.yang@linux.dev,
 Randy Dunlap <rdunlap@infradead.org>, bpf <bpf@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
References: <20250930055826.9810-1-laoar.shao@gmail.com>
 <20250930055826.9810-4-laoar.shao@gmail.com>
 <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com>
 <27e002e3-b39f-40f9-b095-52da0fbd0fc7@redhat.com>
 <CALOAHbBFNNXHdzp1zNuD530r9ZjpQF__wGWyAdR7oDLvemYSMw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CALOAHbBFNNXHdzp1zNuD530r9ZjpQF__wGWyAdR7oDLvemYSMw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YdZgjqc0F8XkuqCtJElPCsntEMWZRNQscLAnXAFIBzQ_1759912106
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6F86F4000F
X-Stat-Signature: ars7ojb6afxejsq44mst4botjggen4h4
X-Rspam-User: 
X-HE-Tag: 1759912111-652305
X-HE-Meta: U2FsdGVkX1+YI7UYpNWDNb+G+Iv+szak+RikaQOgJ8JdGWuEAviOKD3WDZKMvoDp9wqGpIky1er8xGpqJ0fSE1QPdFTZPpurpNkDHZnvYIhWNztgnkW9H9+y9mRhcnccIQdkI2Jt1tC7rpITjE3pU5DlmfqJ1atTvmO5gL9N+Rbshrp3lvLn0yQK8JvDbMQIlIZJ1NNst67Lxh9r6e2+tZq31BpzsCwXA5TtU4BcsAL3ipZJqMbul/fX9QvwyiQB/487jBqyFZiwsdJtT/So271RXg9pfKniOGyjLO7cFjf8Ln6/h+ho5SgRhDMm1ohZOhvTEEVSEdPfmNo8Q1XrLmye0Vlc1sAyrFZtn5oO+W2abJbFK7zSmGKAdrYHaUukq7b0+RTE1nmuEHdXKOWs/ig+wLDz3svMUGIpapuxrIJpCxRzgcQD83SAR3GbZznEztwr5mg2gTwIrjWfC2BtnYroPSKMFamVsRVQAHWoUQaxM9NKW/NTy39iwGwvq4tUrvIG3jSdAzkoy09RLkdnF/tFOFI3Etu5vqpGZFWb/QJKcplCDiE51R6LXIPve8+rGBLGhZWDLXwFq0fK5qOOPcQOJ+k/9JdGh2Mho5MVhiHpyZWe6NYGVAseGmu/YDM8ztSet7wGYblE4xDzxfS/NQo1PZyD4+2B70bWYdYlimyqUVj2hgnnvzypdHTqrp9qqv4yw2nxiCdpBUp+xLL0HCnyljXdHcMWsYEBQ7tAP8kXiiCmfxhobANxvWj+HbP+4Tz9Duz1ohN/T0DfM5xVC0TPaA5tUaYWHP7ukOOVtSdGR0P7+bnFrCl821B7OR8gCNOf9nyA798RnmUuDAJQ+aUkyWwOBdb8FW3UzTilxvb8eD0iUkty3hO3RN9fg2eLPoZi2PlHq4D/273xu4/Rnr3MBTgkFakSM/klSHCBdqT27AOl951EsvMjJlYYSYuUjNsumBxfSCOTxTqWUe7
 pK+NdHXz
 d5IBkY7/uN/wDZQVQUNKWOl7k0dtCTYcV2c465Bf9RjnpMfsqcTLzjk2BywU5ij9xTc+XxBQ3jKfsI2+CKegTdcBm7vcWdIyqjrYeSIb4ABfGltViupw0rKN3R0QyTDOqgZG6cVS5fYIL4Y+IoTV4sCJUHQQK8V9tgz7JfWl35HQhkgmnDrcJ0nK+OT5E88wQp7MC5YD29qc6laIG/iIEX0+BOErM6+3e7IusczA5+as8b4fmBnf/jrpb4TCAJPkhC+7osmU9H1/5sC3iOy8m1TXnZt4Iqya3C1nbZIuHZ5CC/6m6dJqaQoqZYJbaag72tzD/dzoi93w6PINPqqg8plraXIN2tJV9p0e6Mckq4v7s5tZ59me1GhEuebzY6z1MdLVv7ZKmHvYWAqtIuNUxJd0jNOxBwCnahw60LJ/kQJROuEcTRT6rMDuWoOEKnGCRR+v0/On1FjGBBywCvOO9AKkeddl9KOL9H3zNv3iFtFUEOOyKhGM3EbBIEy8m5930j8tO01NzWO+NrRRmXYFEJkdA6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.10.25 10:18, Yafang Shao wrote:
> On Wed, Oct 8, 2025 at 4:08 PM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 03.10.25 04:18, Alexei Starovoitov wrote:
>>> On Mon, Sep 29, 2025 at 10:59 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>>>>
>>>> +unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
>>>> +                                     enum tva_type type,
>>>> +                                     unsigned long orders)
>>>> +{
>>>> +       thp_order_fn_t *bpf_hook_thp_get_order;
>>>> +       int bpf_order;
>>>> +
>>>> +       /* No BPF program is attached */
>>>> +       if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
>>>> +                     &transparent_hugepage_flags))
>>>> +               return orders;
>>>> +
>>>> +       rcu_read_lock();
>>>> +       bpf_hook_thp_get_order = rcu_dereference(bpf_thp.thp_get_order);
>>>> +       if (WARN_ON_ONCE(!bpf_hook_thp_get_order))
>>>> +               goto out;
>>>> +
>>>> +       bpf_order = bpf_hook_thp_get_order(vma, type, orders);
>>>> +       orders &= BIT(bpf_order);
>>>> +
>>>> +out:
>>>> +       rcu_read_unlock();
>>>> +       return orders;
>>>> +}
>>>
>>> I thought I explained it earlier.
>>> Nack to a single global prog approach.
>>
>> I agree. We should have the option to either specify a policy globally,
>> or more refined for cgroups/processes.
>>
>> It's an interesting question if a program would ever want to ship its
>> own policy: I can see use cases for that.
>>
>> So I agree that we should make it more flexible right from the start.
> 
> To achieve per-process granularity, the struct-ops must be embedded
> within the mm_struct as follows:
> 
> +#ifdef CONFIG_BPF_MM
> +struct bpf_mm_ops {
> +#ifdef CONFIG_BPF_THP
> +       struct bpf_thp_ops bpf_thp;
> +#endif
> +};
> +#endif
> +
>   /*
>    * Opaque type representing current mm_struct flag state. Must be accessed via
>    * mm_flags_xxx() helper functions.
> @@ -1268,6 +1281,10 @@ struct mm_struct {
>   #ifdef CONFIG_MM_ID
>                  mm_id_t mm_id;
>   #endif /* CONFIG_MM_ID */
> +
> +#ifdef CONFIG_BPF_MM
> +               struct bpf_mm_ops bpf_mm;
> +#endif
>          } __randomize_layout;
> 
> We should be aware that this will involve extensive changes in mm/.

That's what we do on linux-mm :)

It would be great to use Alexei's feedback/experience to come up with 
something that is flexible for various use cases.

So I think this is likely the right direction.

It would be great to evaluate which scenarios we could unlock with this 
(global vs. per-process vs. per-cgroup) approach, and how 
extensive/involved the changes will be.

If we need a slot in the bi-weekly mm alignment session to brainstorm, 
we can ask Dave R. for one in the upcoming weeks.

-- 
Cheers

David / dhildenb


