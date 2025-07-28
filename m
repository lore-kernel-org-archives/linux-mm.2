Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E701C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 12:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB9BE6B0088; Mon, 28 Jul 2025 08:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A69C46B0089; Mon, 28 Jul 2025 08:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9313D6B008A; Mon, 28 Jul 2025 08:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7E9076B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:27:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1DB921D96FF
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 12:27:10 +0000 (UTC)
X-FDA: 83713598220.12.03C3929
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 857D6100009
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 12:27:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FifeEIHH;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753705627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QnQuEJmQQe5QI9lnPew2rtDphQn82+YCCHj3hCzNitw=;
	b=3LfDwBAh6Ee+K72QbIzqZunN+C5IZbN0kMlOJ6tL9luhA/OQgYPwJQEGr1hHN8Zcm/m1eG
	nHCwWiZpB2Ij5hefy+pfjdKxD9prPqlB6+uYjM+6o/ih723oLryz48+zPhHTSMPCeW5Bk3
	bJNgUoZF8VzldTSja8aZQCNLZiY9Jbc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FifeEIHH;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753705627; a=rsa-sha256;
	cv=none;
	b=f4kKI4cIPTDQHYUDqPN9ZlvOqklbUkmbDa5WlE8h28VSxMpwS/N9iMhzvJ3XLgL0fXY3pZ
	TM3e3LEtukPe8igkSDoByjm1YqlfiGPkn5URwahdFjZuwYGbK4XZ6nnD87+w1lHRRLsaHH
	rN2qGFKxUwuoO6j+ry/ZRppIbW5tVi8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753705626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QnQuEJmQQe5QI9lnPew2rtDphQn82+YCCHj3hCzNitw=;
	b=FifeEIHHwSCFjyqm5aisaedY6kYuJGCBk/vQwIOTdfmILy90Z8QR9cSQQJGU7XGt0fim+o
	dDy7OeqlbmEUnIUuCj5tqxhuu77rAVtEEb0OmcP8XfpVLbhtyOXchuG8U+IbRZLDLTR/i+
	TxxpSIsUFuHukEvo12ph0U/u3vK5OI8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-601-3SgPJNj5OPaivQWoCqLvsA-1; Mon, 28 Jul 2025 08:27:05 -0400
X-MC-Unique: 3SgPJNj5OPaivQWoCqLvsA-1
X-Mimecast-MFC-AGG-ID: 3SgPJNj5OPaivQWoCqLvsA_1753705624
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4561611dc2aso29874935e9.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 05:27:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753705624; x=1754310424;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QnQuEJmQQe5QI9lnPew2rtDphQn82+YCCHj3hCzNitw=;
        b=pA12WBUOwoRXp7ZKxs4ufn1uNCsslwcj1jhC4XmenHj9Yt9Ez1YWDAECONeRCi6um0
         rchMPI090YsPcgrbw01MNJ4mJ+1to91qRud6Ushd1zwi7YS26PsLkcCV7Abb5Qx77ygi
         Im5hoUPa4lIfJGEhXpE/LykGVKeB+SrIckWyHtofg/cw818l9LntHDEU1qHpSIcHfm1B
         7VQr/NELK3C7Pya8M9S4IHcCy7PtXfiDb2EPFh6i39HTrlXgi0IgcIF93htwP7KDbyR3
         8WDNltLI6hD1R0qbMEPC6zulPo8y514BVEGNltKUjoJ93Hud8xyHqLNaMt748QMSbpSM
         BJIA==
X-Forwarded-Encrypted: i=1; AJvYcCXUBcZ1INZS6aoP4W6J2ES0k8zjJA2DWA6U5uUKnOOO8jNEQQ+U4WuQr1EntcDMx05fXBneFdzwAg==@kvack.org
X-Gm-Message-State: AOJu0Yw3lzAgO5yb1MeB21cOaNIYbsRL3cOsJbfsMQq1K37Mj3471Faq
	Sm6Q/tALnNzUplUcgill4HE+5UviiBGepKd6zGqjBdt38DETofmWLbacEzgkNLvQmVydwY9o9zQ
	Ka3VEZgmC97tDBNmJ6q3vicJEAHZyIQjuKnHLFstibc5b6vtV7hhy
X-Gm-Gg: ASbGnctsHKM5eHgjWaYsv0xk0O3bD/lzy4+d51JYraxLU21FLiQIKOtWwGK8loibfNa
	an6yK1O2WGJsB3kfIFMqhnZaRBvK/bO5/qzmIsSjbEMteqSwRSjb/SN6Cr6L0p4BrnHC8vuU/Qu
	vISykdT70VzHzIneiWjqSAVMNjci/YaoPwe6BC0WdF7CAHoC1wY0lTik7pPLBfblmd9WwaR2+14
	EMfcDjj0U5LA3yXoWEgThgl0jtdDR3sxouekU6o1ChORRQ9rDaPCVHaYTeqZV1vo5Ikq5cYam7W
	GkEBPJc/sxHff0ZFQcUBoixcmrHjzuEwYX0XEA9zpO+6LAxK1hpkEL0kDmRU+oOHs9PbF/FVmQB
	krVIbpRnf6JccpEfFbkjE18GpOIpqZgz3rXLXbIiJ54PPiSZnLtcjnf2YK4Qr8gic9Ds=
X-Received: by 2002:a05:600c:6089:b0:456:1752:2b39 with SMTP id 5b1f17b1804b1-4587666c5f8mr77032435e9.33.1753705624334;
        Mon, 28 Jul 2025 05:27:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6t+wpPuc6znKz8nZXvCG8hSmYbB+9cHwFq6tAmgHTss/ZYl4BlI0qI6FlX6v6tmq3ljU9SA==
X-Received: by 2002:a05:600c:6089:b0:456:1752:2b39 with SMTP id 5b1f17b1804b1-4587666c5f8mr77032195e9.33.1753705623840;
        Mon, 28 Jul 2025 05:27:03 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f47:2b00:c5f3:4053:2918:d17c? (p200300d82f472b00c5f340532918d17c.dip0.t-ipconnect.de. [2003:d8:2f47:2b00:c5f3:4053:2918:d17c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4586eef77e8sm114032575e9.3.2025.07.28.05.27.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 05:27:03 -0700 (PDT)
Message-ID: <1f8d924d-3554-43a6-a75e-66a08d1ce7b9@redhat.com>
Date: Mon, 28 Jul 2025 14:27:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
To: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>
References: <aIcxs2nk3RNWWbD6@localhost.localdomain>
 <aIc5XxgkbAwF6wqE@tiehlicka>
 <2f24e725-cddb-41c5-ba87-783930efb2aa@redhat.com>
 <aIc9DQ1PwsbiOQwc@tiehlicka>
 <79919ace-9cd2-4600-9615-6dc26ba19e19@redhat.com>
 <aIdqVNCY-XMNICng@tiehlicka>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <aIdqVNCY-XMNICng@tiehlicka>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _Z4AWMChb213pwVgNw5WMOJZAYRNk5V1fAdMrGRIXmc_1753705624
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: eia7e3kw5p1kwoipo77rredpg13pcdq9
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 857D6100009
X-Rspam-User: 
X-HE-Tag: 1753705627-636594
X-HE-Meta: U2FsdGVkX19hgh61dIYsYfLe143JADNchXXVw6NVwLhddQErk4u1BPFHa9Zdxv6uEKmDNT/pJhp38ZtIfAyw6D+gPeGB6N5EmMGLfq+/bFPND31JMx2FA3Tijz07f3oqlFND8jnLKZ/XLJ+PRs+3XZhkkZA/4it0BHI1a3lEe0KhlbxRvRl1IU/2SEtIsbC9yYlKUBqjuc29YbTNPjoZA4L10jFmhJDE/GSEkfFZ9xDGkI5Q/GKZHJJKCn+LUgFr472KHFou+ZrZG10Ww7Py1ZTcvTsVcuCmRFnMRjPfnq3WAbnFwsPiKtE17x/QMduqoOkcVJUOamxhB+71M8F5i4orv9HT/EHWymiLnY8F4tliI9yPRMI+WWBUf/CAYWDYfgR85G8pL8lmjvpmbvFSPz9V/m19WzddLRfTIL6Vs824DXkUMhfMhNiPS2BE03qduHI3ISDzvOrNZ24fU9VohKCEs3lgJHkO1vI5+aZLYoc4sQowtqX8KZL8fEz6Bpe5M9sI+G1e9iPO635eXLvKXZs+RO5YpZ4oSmJwgNFFcPeqRxqvn9rHN6c2o7HrSB12mUKncWVdlcd7G58oWLT3gBehJx3fVNsyBaP37fyPRTLme2tK1oqYuS1nM3cLWJcE1BdFwCd1rBFr5vzKycErRBlOqw4BfOI9UQ4TiOvR/t25AdlDgxKe+qH05PEYas0X0WXC7BtuRSGSqVkG5p9cHKeOKe7ph937MkskboXdHLhzEbYdKAjfu5svXda8Z91H8PNYiLYV3bzx+DSaQM4HpTn9WvRG2KoDPX787E4Lt3uPpcPoKzA/IMT3jAxgMCEPh1imdSN06KOdCdYzQEgWCTR2//G8ESr4w3hzhkyClnO/6Jol4hBPklnOuKqfKy4AoKeVOQhxV0LQlLWWOccwQFGo2V2qZIdFmlmaJi3rFJGcHokIytacgwSr5iskUBZZi8eKewL8sk56gchInxO
 B4tSuSQ7
 zwC24NaPPaEq3XJv9aNGBpnLZh84ZxjoMH8tSslTSQOre9kgOSqQBJGx9tfbU3GJt6FYlOLWUDrBejDLtHoeogG7H6a6q7/Q7Q9K0GT2CtLxNhxZdIzcQixjPDGAsaUbiiWyTEVXnfbv20BZYxjQoiUn5EQGLVWKSfWlwX4b+AxINMa1PSldQmtE5j6KhwboKNIAKfGhr1DX/sOeKTeVYJ/gVbhCMzdspGFPXeJBzngu8HwiG5WlwGvevHe7Msd6oagj5wtgJdS5zs+Y39Y1MFh/R5amnLWIEpjUpPhXpcZ/iItPZoxzGp+dQ4Xc3j08ZYbOAocqs3ekmiS40Xvq73sda3pDM/RiMUxL+7FR3igGlzmVJyC6rI6F6Qt/tl1AhwFa/FaPfEEq/3U20sfDwpBo1Hg/wYLZrvr940euB7a2zterXz6MUqTtG8Ki/9D+M6PkbWGum/uFdGzTOcwGCXmh5mGMgMrCZloLixuWagc50JDXOOp8qvE40rHoE/vIbEq9J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.07.25 14:17, Michal Hocko wrote:
> On Mon 28-07-25 11:10:44, David Hildenbrand wrote:
>> On 28.07.25 11:04, Michal Hocko wrote:
>>> On Mon 28-07-25 10:53:08, David Hildenbrand wrote:
> [...]
>>>> daxctl wants to online memory itself. We want to keep that memory offline
>>>> from a kernel perspective and let daxctl handle it in this case.
>>>>
>>>> We have that problem in RHEL where we currently require user space to
>>>> disable udev rules so daxctl "can win".
>>>
>>> ... this is the result. Those shouldn't really race. If udev is suppose
>>> to see the device then only in its entirity so regular memory block
>>> based onlining rules shouldn't even see that memory. Or am I completely
>>> missing the picture?
>>
>> We can't break user space, which relies on individual memory blocks.
> 
> We do have userspace which onlines specific memory blocks and we cannot
> break that. But do we have any userspace that wants to online CXL like
> memory (or in general dax like memory) that would need to operate on
> those memory blocks with that kind of granularity?

I'm afraid that ship has sailed.

> 
> In other words what would break if we didn't expose CXL memory through
> memory blocks in sysfs?

I think the whole libdaxctl handling for onlining memory is based on that.

-- 
Cheers,

David / dhildenb


