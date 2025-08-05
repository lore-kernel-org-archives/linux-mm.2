Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D996EC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 09:58:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699416B0095; Tue,  5 Aug 2025 05:58:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 670826B0096; Tue,  5 Aug 2025 05:58:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55F236B009A; Tue,  5 Aug 2025 05:58:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 472706B0095
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 05:58:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C70C21355F5
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 09:58:20 +0000 (UTC)
X-FDA: 83742253560.28.054BAF5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id DCE3B40006
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 09:58:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Isu8XnYg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754387897; a=rsa-sha256;
	cv=none;
	b=CbKKY3CWkQaXirxXBF2zSOX5N1LMMlsmi9mhf1lqotOawbCRFhU+1fYX7rg/+Y6XkFdorW
	Ve7ixHJFPX1yeJJM65kpr8zqPD+xXK8FEeLZrDHH0CPnEs7X2OPVuxtuPCaOoZN2MstY+B
	zMnzSHkyS8pyJ4/OKxKaJcU9JwVfbpg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Isu8XnYg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754387897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zm/u8bmVSBWBP7KMq+8GNg/jH0DTBhPVQW1hnHzNiv8=;
	b=hJByC4ZJH8h9t1TI3+cP2T1sCUezYe4QWSU2Blo7x3Wn3LwaV9iSXlm8KNixA4YTsWHp1j
	VBj061Jnm8H590N6Sb+gAdby7HBt7G0wl3Aevv+iZPcfxh8yHQynKxqRBSJM1C18REoeLl
	yfyUsmtZq/ncoCI2C4O6zSjCuY5+FQk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754387895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zm/u8bmVSBWBP7KMq+8GNg/jH0DTBhPVQW1hnHzNiv8=;
	b=Isu8XnYggxaBh4yPf1FgNEmE1IFo9+tImEr4CTacd0NqXiuL0xLsY47XBMSEADeHu4MDSp
	3tlJdZfvEFdscJk+H+9RJe9auB3VSeGo4A0HIvTmOFnNKFMBPla7M+38bPmo8MpuOh02XM
	BsKbrU3+i+lYIbqDstmTmazYa0FSR2Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-9KZoJuHePFOzIxnVjzJxzw-1; Tue, 05 Aug 2025 05:58:14 -0400
X-MC-Unique: 9KZoJuHePFOzIxnVjzJxzw-1
X-Mimecast-MFC-AGG-ID: 9KZoJuHePFOzIxnVjzJxzw_1754387893
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-459e30e4477so2804455e9.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 02:58:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754387893; x=1754992693;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zm/u8bmVSBWBP7KMq+8GNg/jH0DTBhPVQW1hnHzNiv8=;
        b=XEnogDpXCAGtyYQVFy7keVqgtubWsNxCgMyMh/Lo93jFgdf++IIctoGgbJA/FZ10Z1
         a10DCnbQw0W5Q5D4L8LGYEx0UQrESlBVns+gL0tIcBb4Dohe7jbg/3/3zoKHx4Y39XNe
         D4cJP2rO/KXrSPM6W9Rx+dVY40pTxlYW/26hqJmygggOxsKuzRFD3vitWSGt8EO9Mto3
         ULnfk/Mor067n3N8S0UEhA0oH0Fviv52PDPSlDLf4iIetwK2oREL3aMgx1RCfRloMygf
         QQ0z4ruEql+GBqt+F/iANnKen4Rk6CqLlbe0MLNeiatFnOAsIKjzgXXxwMk2hHihuJnL
         SEYg==
X-Forwarded-Encrypted: i=1; AJvYcCUwxEeWnJ9poSpssNRXDGd2P5Ab8kDOO0wRLxaq5pvaHZXPTJk2wuHjBh9KVJekZJoDMo/GiJR97A==@kvack.org
X-Gm-Message-State: AOJu0Yxrc4sCO+jIE9ZZXS0bmwaHswH4rowlANNIl5XndYEH7O2RxXh7
	nnUF3vcB9a4kkASPKT1iQbxR6hcXQPV3Rbj7tD57i5fgUMCSMcYOKszOC3RDLjIkpCcIp5vz1je
	lt0P4mY3/rbIjHyBPkp5b4Hp+OEdOdkuGenlF5niEUgpFJCL1SVl0
X-Gm-Gg: ASbGncu+jrWzG8I7l3cbgVT/imE07VNfDFWxm864G8L6HJpwFQcTn1U5M9RFwNS7Ugw
	mlsqeEuTi5R7l4mxHA3T5OepR4QysIVir054cbD0EV068ymepNuzgmMSPHZLKP7i2Kz8hAfbuhs
	e1rcKQOgvuVgSL1PgjupRf3tSkduN9GjM3p432TzY77bRfmmKd9nL5tNuTeABV1oMdshyyRKa+1
	Sy6IR/4h6KxLW547rtpZ19YECXv6oRIN/uoVWXeKh6HSmEELY3it4gOWhT/jyB+B5Rpzkjqcfsf
	aPTDbvx5W9Dz73rkIh5VqtGonw0M0hA7dNZLQSIVN8lm72v63V+86kldALQwCMVvVapmGBg=
X-Received: by 2002:a05:600c:4ecd:b0:459:e048:af42 with SMTP id 5b1f17b1804b1-459e048af80mr27344255e9.24.1754387892698;
        Tue, 05 Aug 2025 02:58:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHu9rgyjmk0uonkMuGZyFuLrvh1XIgvJwkQbJZTilgPx9GuSO2bLOzz+iugEJg9v4l3IBuIMg==
X-Received: by 2002:a05:600c:4ecd:b0:459:e048:af42 with SMTP id 5b1f17b1804b1-459e048af80mr27343985e9.24.1754387892256;
        Tue, 05 Aug 2025 02:58:12 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a26f.dip0.t-ipconnect.de. [87.161.162.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c48de68sm18520294f8f.67.2025.08.05.02.58.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 02:58:11 -0700 (PDT)
Message-ID: <486c5773-c7fa-4e19-b429-90823ed2f7d5@redhat.com>
Date: Tue, 5 Aug 2025 11:58:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/page_alloc: Add PCP list for THP CMA
To: Juan Yescas <jyescas@google.com>
Cc: akash.tyagi@mediatek.com, Andrew Morton <akpm@linux-foundation.org>,
 angelogioacchino.delregno@collabora.com, hannes@cmpxchg.org,
 Brendan Jackman <jackmanb@google.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
 Linux Memory Management List <linux-mm@kvack.org>, matthias.bgg@gmail.com,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, wsd_upstream@mediatek.com,
 Zi Yan <ziy@nvidia.com>, Kalesh Singh <kaleshsingh@google.com>,
 "T.J. Mercier" <tjmercier@google.com>,
 Isaac Manjarres <isaacmanjarres@google.com>
References: <CAJDx_rgzkZognxWzOXJ-ZxdTtUaM3FT6bmpkwxMz03XiX3fKAQ@mail.gmail.com>
 <d395b14a-9a84-4f25-b4f0-45e8500fc5fe@redhat.com>
 <CAJDx_rgrp1TpOt-iDcsSGRTL=qZZsK_dpKL1bSkyunPGcGXt5g@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <CAJDx_rgrp1TpOt-iDcsSGRTL=qZZsK_dpKL1bSkyunPGcGXt5g@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 99PJRLx3qm2JZbnzR6aLOOxHeic7eAScQqT0U7AKWDY_1754387893
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DCE3B40006
X-Stat-Signature: 4pieramuhw7qqrkct4dbq9axyt164ddn
X-HE-Tag: 1754387895-156255
X-HE-Meta: U2FsdGVkX19w1JkYjLbJssc4iJR3Urd+foaj/T0p7HFof0nwd8ttO2w5zA2jidVZ6eGZLVTPsAVABOYFcGXR46Rd0+DsHHK/PZs3OMDCt4YdrCNkM6EOGOf11Gz8/iFVe4Z8Aph5yc/cYEM7l7CKIqRgWLND5j4ad+eJ+XCggKsmpK8Z165aOosx4VbR4MxvjYeWmAAMfq1d6dRSNcQekJR7mAts1xhAAhUxLKcrWdvJeOKKbBAtGwmqy58ubvVYxQuvX5/XixfMPdak2kHYtjg4U70MOIVu/rpaM48235Pxu4ZKtLuXoaNrj5MGTPX/y/g01aP6VUB9jaUyCucVrXeI6Gkiy9G7cMPA7pHKSO9aG1WGLNQ96i3KCQwNHWDCb3hnsZd2FP7P8A1E+gsr3W8gd3aPm+oebOSdfHwEYXBgNt3klthFDnmKNJ4zqiAq6MMtZ4QeNRx/VCRmu5fl4lmjlNL7FjT+oron8eFMorVuO4XhaIPQZf1ZrcW9YIt2fsyIL50bQkB9gwZKYmXON2lP9A+77/jkM8X7Pk0Qic3iXlECBRSmg2D9ChH7ZKMy2V0rAbxqT64+Ea3g6iZfdvgMVnhsQBXzOCs9c91Q7ffW5WGOfejwkGLBgF++wqM2Z3PXSa55s3d8Q6H9IoqGe0rU9brZNv6Lww1U7TDCGRFbRPiG7bQD15g8A3AXdaCGYIDPkA8y0J9jCXqg6e+PpJ254/9KnAIAa7UPJcc1P+ztMYm194Rs19+z89/oLzPl+xKa4Nok49CXC0GfFuvBxIPlMLpr//G5gXS2PQlnw0XzrzaNDsscgwBDY7YtCDc1oPAhUbA/ADuF2vM+Y7NoH9qgEaaY7K/BAlOTqd16LNZM2i5gpF/9yvPp8d4ClrIvesUbI3byjufvx67CJImqbbh+sJMACgA8TH1xvJT1MVMUMa4ZgojYvdPRZL/g2cz6W0qXiC0LrNUGwYyZ9mb
 oZlywox5
 IgyGyjixWbfDseBtkGqvUpT7lLvOwzbklcdkDw+FUStS5qV/1tPCURdU1xG696UZIfsoyy7h6SHaJo8tB7yqjuJb7P6LzkAUQnKYtHGwzF50y6bgwVNb/8v6VeNWrx+qX+8RPYrFMvYV/UTgW9JxglHt+64at3scsYWxU4dwlyo5Ir/buPOUAPuI2DgsKeJblhJhJ93FgR6g8enuKu8gFPlePB0w0mLUeDHDsfAFDQd/qJ+u7WZUfWrLLf8/uocGCsSxMl+VbSLFa0uFkOKM3HxrVfJHn8QlhPXHteCrdpjsHylZjLSo1m/C4urhsTxPCznLkvAyzqnAVrVPgsKRYTaLYbZ8Kpntg/86S9evHKbXHJJGxy4sFNo9KEJIoGSVqbZxjAnKkjF+5w/VxJTSaRRwwl4uDykwfeX9NobYYSuKHEgvvarJ9NLI2DTUMbR+GeQgn9sb8lM8imruUZXF7nno60xGk6L9og9Um8EOGq0Xt/GxSHRIclq9LGmsDxVVXtAqxIxQG5l3I/hqZWKckvWZxPTLX+xCpOcD06RMCzAnatxHDkVeKj6wvCVZXkoNU9XK02wYLJtgf2aCPCYzrJn1cGlWSUSpPOynsEgNVpcrBkMi3aFjcV4DwaLukMgrKyxNlKUfighmQuL5DrtzjwPgZgjPgfusxWHtc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.08.25 03:22, Juan Yescas wrote:
> On Mon, Aug 4, 2025 at 11:50 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 04.08.25 20:20, Juan Yescas wrote:
>>> Hi David/Zi,
>>>
>>> Is there any reason why the MIGRATE_CMA pages are not in the PCP lists?
>>>
>>> There are many devices that need fast allocation of MIGRATE_CMA pages,
>>> and they have to get them from the buddy allocator, which is a bit
>>> slower in comparison to the PCP lists.
>>>
>>> We also have cases where the MIGRATE_CMA memory requirements are big.
>>> For example, GPUs need MIGRATE_CMA memory in the ranges of 30MiB to 500MiBs.
>>> These cases would benefit if we have THPs for CMAs.
>>>
>>> Could we add the support for MIGRATE_CMA pages on the PCP and THP lists?
>>
>> Remember how CMA memory is used:
>>
>> The owner allocates it through cma_alloc() and friends, where the CMA
>> allocator will try allocating *specific physical memory regions* using
>> alloc_contig_range(). It doesn't just go ahead and pick a random CMA
>> page from the buddy (or PCP) lists. Doesn't work (just imagine having
>> different CMA areas etc).
>>
>> Anybody else is free to use CMA pages for MOVABLE allocations. So we
>> treat them as being MOVABLE on the PCP.
>>
>> Having a separate CMA PCP list doesn't solve or speedup anything, really.
>>
> 
> Thanks David for the quick overview.
> 
>> I still have no clue what this patch here tried to solve: it doesn't
>> make any sense.
>>
> 
> The story started with this out of tree patch that is part of Android.
> 
> https://lore.kernel.org/lkml/cover.1604282969.git.cgoldswo@codeaurora.org/T/#u
> 
> This patch introduced the __GFP_CMA flag that allocates pages from
> MIGRATE_MOVABLE
> or MIGRATE_CMA. What it happens then, it is that the MIGRATE_MOVABLE
> pages in the
> PCP lists were consumed pretty fast. To solve this issue, the PCP
> MIGRATE_CMA list was added.
> This list is initialized by rmqueue_bulk() when it is empty. That's
> how we end up with the PCP MIGRATE_CMA list
> in Android. In addition to this, the THP list for MIGRATE_MOVABLE was
> allowed to contain
> MIGRATE_CMA pages. This is causing THP MIGRATE_CMA pages to be used
> for THP MIGRATE_MOVABLE
> making later allocations from THP MIGRATE_CMA to fail.

Okay, so this patch here really is not suitable for the upstream kernel 
as is. It's purely targeted at the OOT Android patch.

> 
> These workarounds are mainly because we need to solve this issue upstream:
> 
> - When devices reserve big blocks of MIGRATE_CMA pages, the
> underutilized MIGRATE_CMA
> can fall back to MIGRATE_MOVABLE and these pages can be pinned, so if
> we require MIGRATE_CMA
> pages, the allocations might fail.
> 
> I remember that you presented the problem in LPC. Were you able to
> make some progress on that?

There is the problem of CMA pages getting allocated by someone for a 
MOVABLE allocation, to then short-term pin it for DMA. Long-term 
pinnings are disallowed (we just recently fixed a bug where we 
accidentally allowed it).

One concern is that a steady stream of short-term pinnings can turn such 
pages unmovable. We discussed ideas on how to handle that, but there is 
no solution upstream yet.

-- 
Cheers,

David / dhildenb


