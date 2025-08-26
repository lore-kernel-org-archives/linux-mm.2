Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05A68CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 07:42:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF168E00B8; Tue, 26 Aug 2025 03:42:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496E58E00A8; Tue, 26 Aug 2025 03:42:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 385788E00B8; Tue, 26 Aug 2025 03:42:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 26D378E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:42:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9950814065C
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:42:39 +0000 (UTC)
X-FDA: 83818116438.24.5F45B4D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 46ABE180012
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:42:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="iM/ajq/g";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756194157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z7i9YDbg96XPkSuor69lux2weqUhbZRVG7R4LIN4byE=;
	b=LJ7QcFZgIqRlzRvidoxceOFbzi7ywusgYuWeRzHgFBPFKt8sc0JOkoMxnYdc1styvCkfjN
	wbBju3gAcKqTngXsIV0OW6VbFibQX59VNvC2+uHuh0MWUPr4xcO22PmEgG/so8KdAQsha+
	bhWYTd3fTYlFgdlLWhEYph/V0RaR36g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="iM/ajq/g";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756194157; a=rsa-sha256;
	cv=none;
	b=u7MXVxyeDnbJTMOBEa8nmRAeO7u1Pm4PnnJVeQkbTrXdn/IjyGT706Ndjy2PSmoew6uaB6
	SddOqJv/sSRTGb4M1UXQjKlrKX+9aaNPVssrZLSy6oIFo1Jxd0TOqGxgXi+HNPn7oBiwmr
	M+h9/1XJJ9ZvpJTLgFS+0GU6rINCX8A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756194156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Z7i9YDbg96XPkSuor69lux2weqUhbZRVG7R4LIN4byE=;
	b=iM/ajq/geB/t4xXQEewZwBE22hBRkeIBFyUcfbwzjUSEco+EEN+fjbeaJICBKHz43TEVpm
	Q1yoatk1R46PVdWbPAl5Lu7zKm+3BOCP+rCO8FNb+ADBO8vFExgc9vUqm6fg/PfWOc9FWN
	9KBqde0m3n2w2SK35qrZW9iVUDPo3uw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-dMoj9Cf6NMi2uxowrMw3pw-1; Tue, 26 Aug 2025 03:42:34 -0400
X-MC-Unique: dMoj9Cf6NMi2uxowrMw3pw-1
X-Mimecast-MFC-AGG-ID: dMoj9Cf6NMi2uxowrMw3pw_1756194153
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-afe81959c3cso220965866b.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:42:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756194153; x=1756798953;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z7i9YDbg96XPkSuor69lux2weqUhbZRVG7R4LIN4byE=;
        b=rPCFqEe7HxTPwg9+KtgP7QIGUISmWj300J269Yre4bxqr9aXBgcwq10ZJ0C6UQ+G3D
         jWULJbM1wP5oocTcv4aXvgInhbE0MKFauMDmCiYMfIVVxfk5NTZayiN6n0/0xqcr8geP
         JZPIvdCzNbAETWgOUJfjnOyQuor8Vv+QH76WNkbU7ippSVtvo11BVFrvS0CVISsAJ88Y
         9dyh8v4gsE5w8m3IkuYTBhpy7Y+M4eZ0ANlEmnIENfkTnhrnPaKmGMWU+8OMvXr4RKA3
         TLoMov02n9FobHVH0NL/5GqEhe3Wsaz0/KwrTrZqMlvJpd5jF4fPdpUTpVoFyVCpND00
         MexA==
X-Forwarded-Encrypted: i=1; AJvYcCU2IvCFmItDM9VMS/olPeqm5O/3U9yvJc/TSIANYMNSCA3PspZpWwrrCJK8uGjpp7U+T1T7RNE5CQ==@kvack.org
X-Gm-Message-State: AOJu0YzSxRF+OLyxqJJzyl4iovXaN4KiI31HBTtGiii7f4I6tI/rci96
	ohb66Yrb72Y8TynEoqF4hqwAjpxzoW3iHQnKt2tr8RIu2TtIDmXu+5wGXe3SeqA2ttOYxW7x6jE
	NKH2TTqDXJCZ57YdeawaSOjmKdScwp3lr3/zZO6AolFmAf/2qmQcP
X-Gm-Gg: ASbGncsxNuvE7O+pPyuYfIWD68hVkvShGA/T+Wn9VMMHfLrleTubVGtbOYpDjjd+7Be
	qPjuSeIXFQU4sQgA5LoFGAPNfDR85NXMTGnmuUZmANbP4c4d3q2gzht7Hk/CK4QbeLb1Vw8TKAQ
	+ODjTDiNm9pZjbq/9rrkpmL/yZ9ymQYqO4FEGCfXKdwCkgmRKLoSHjpjNIVPsbO4dhQ6bm/fx8F
	+aN7lJrSpANcUos9J4phksdT3UalNwrOBrzNKmqiMhlFB5rG6E+pADdGX9vzjwn4pgwt5N/KMxF
	QlX4R2drmGiOMxCyb7OqGRoiPlyhe/OJQ1KldUbwyubC2kodH3InQ/Ne2OcqiUnZZ/g23b3CQQ=
	=
X-Received: by 2002:a17:907:3f08:b0:ae6:f163:5d75 with SMTP id a640c23a62f3a-afe28ffbfcemr1407481366b.11.1756194152782;
        Tue, 26 Aug 2025 00:42:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFlXdN5Emxb0ONjeXO0an5VSsBo5+DtdMvl/wre4Bq+MCj3yWiGfw8uKRt2GgJjy2gdrHrI8A==
X-Received: by 2002:a17:907:3f08:b0:ae6:f163:5d75 with SMTP id a640c23a62f3a-afe28ffbfcemr1407477966b.11.1756194152305;
        Tue, 26 Aug 2025 00:42:32 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe75109c4bsm458246966b.70.2025.08.26.00.42.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 00:42:31 -0700 (PDT)
Message-ID: <d8f723c4-4cb0-431d-9df2-ba4ec74c7b43@redhat.com>
Date: Tue, 26 Aug 2025 09:42:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 mm-new 00/10] mm, bpf: BPF based THP order selection
To: Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, hannes@cmpxchg.org, usamaarif642@gmail.com,
 gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org,
 daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com,
 rientjes@google.com, corbet@lwn.net
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org
References: <20250826071948.2618-1-laoar.shao@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250826071948.2618-1-laoar.shao@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hxAwPyAUQEz1DzGPelCuZV-IeaVeZAPr4t-IyE_8QOg_1756194153
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 46ABE180012
X-Stat-Signature: agmiri7f6bt8ubpszcahbpxrrs5zf9p5
X-Rspam-User: 
X-HE-Tag: 1756194157-798566
X-HE-Meta: U2FsdGVkX1+y41pyktbdVtEf6Rkrg2uXhpUee+W82xgfMmUFhqR/0mcVAWZo1vu2qqU6eTXcoza18BhSgMs0QWgaKR2XVAtDZOULM5kscU0e02VKF4rmRVpIedMeYe98lv1hRNijoswykT7iR9JlpE6nsTo4ljwTAjh7XCC3kZ+tVZVcT4W318/ChqrNXgozpUKNRmpbeAfMwtT/s394PQNxw3oq5hVONLD2IZwemmYdNxnhhI1v8lp22XB1upgiSqrnPLXEpn6t5HIbqQ0ZdZXbwxel1tnulq2mU+gbasR/ZKcN8/qh7EUCPn1+OsN+1BU6GBBpmamRbY2/BD7MEqtCpL7pymobvCzqrPgWnlz1Qvk/d9RqOOW86TMLyT8B5Tq2+DHMD1DupfL2wODRUjhlOl+qM3gog9ECRkuuQGMLmW+ePFYfrFuTpdKlADZVAPZwgbXA0VLuz6w7VUbOHtWX45OQQdWBlfAmyHCJI6OFzGHO0+01jzIGaATFSmgQ3k85c7SqpDYaOSB97IbFF32E/ZWDbBMED/ZGVBP5ZN5WwkafbPHHNLVCW7krPx1n7uUaLYWp3b66HcE6q6HvSh7Gi773FyxtrH2bi9mus368IbFgvi06nWkLS/gPaiyqgGtZFYFBlTvx43EJWW/mdctHFlNo5BKqeUBKKPHm8pQzkVxCpQrYMrQ3eHOkmPm3eW2+wZMs+Yr5iE5AoqBjm6vgprMZA9yq3Ir3H3HjsFJ7mxD82e45I3mhqGLOocUdMdBpIEi6BICY1nxItMl1E4bVuhDbTquCfDqiT8WlMqzbYlLxXz1WnpnB6gh99JDJ/RwTqAGi28eXBSnlNWl4UDvJbob2lOs6BgBsvbtdemu5ProkYbMePlUgqwGeZhOxzwij4MHSIZWN+i36V1UA00gx93q+yTa0ggEMzpAj9qgoaU070IgVYSx0Mt7iydBA5REgAPbkNueOscMhGaj
 NcXZHdcH
 8BRE53kX9HZcngXsu8GydnbO7aRy2lYQgOPiAv4NjTrGezKr3W/Y6dQJEWnE8BfxLT4tz0/tMc+/F8LEcEK1mYcbHv2vZsWDUwugQ8pdc/a3IVFDcNvUvdmV3ZPce3hzqRVkcvVqpFRopRcKCQ447umis/AsQmnVPR4FUcE8w2MEgVPxHpNdgqlHdglOK56CYzlsJBihTF65ynhjIZbWCVM9RjL6KHtP+JvxyhkvmzsAwBVrP5d/yHGMMyBA7JackQLl2Wzmr06FpZU4bQImmA6qPrIRhiQfRPq8UE4e9YgfbzK57rz/krVAeccrbUI3YNmMP6aivE12MTj0DLNTq/+vpwd/lvejPmjFfBG2ySFYLAs1SaiZ9ytFZ+Vt7pe6/acdAyS7IXdfpppHq2+WjrYThNP56b09OSxM0b0JksGRtOncxLYZ9nvzsZ2T+Co4d4Dn/EBQwc4k41oELPCkMwE5PHJDc3xVHOSmK2sbhRq5i0+a3vAi2D6hwCRgy5bx8tEEXWpUC3BfDpmdpEIEz/VAq4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.08.25 09:19, Yafang Shao wrote:
> Background
> ==========
> 
> Our production servers consistently configure THP to "never" due to
> historical incidents caused by its behavior. Key issues include:
> - Increased Memory Consumption
>    THP significantly raises overall memory usage, reducing available memory
>    for workloads.
> 
> - Latency Spikes
>    Random latency spikes occur due to frequent memory compaction triggered
>    by THP.
> 
> - Lack of Fine-Grained Control
>    THP tuning is globally configured, making it unsuitable for containerized
>    environments. When multiple workloads share a host, enabling THP without
>    per-workload control leads to unpredictable behavior.
> 
> Due to these issues, administrators avoid switching to madvise or always
> modes—unless per-workload THP control is implemented.
> 
> To address this, we propose BPF-based THP policy for flexible adjustment.
> Additionally, as David mentioned [0], this mechanism can also serve as a
> policy prototyping tool (test policies via BPF before upstreaming them).

There is a lot going on and most reviewers (including me) are fairly 
busy right now, so getting more detailed review could take a while.

This topic sounds like a good candidate for the bi-weekly MM alignment 
session.

Would you be interested in presenting the current bpf interface, how to 
use it,  drawbacks, todos, ... in that forum?

David Rientjes, who organizes this meeting, is already on Cc.

-- 
Cheers

David / dhildenb


