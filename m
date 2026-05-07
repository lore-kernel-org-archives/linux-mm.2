Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BE6ACD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 16:56:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2F716B0005; Thu,  7 May 2026 12:56:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB96F6B008A; Thu,  7 May 2026 12:56:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C597B6B008C; Thu,  7 May 2026 12:56:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B1CCF6B0005
	for <linux-mm@kvack.org>; Thu,  7 May 2026 12:56:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 50BA01C101C
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:56:16 +0000 (UTC)
X-FDA: 84741226752.29.9BF0817
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4C103C0016
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:56:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z4tlaB2p;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778172974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fxKJNK3JYOXtq/6RpdHSxauIPnnYNnrQjQPiGKEVycA=;
	b=lEYHFqdng8L1XiL8rE7BWIxkieojOcehE28Q0Kxfq2rjy1SGwIVsaarERXdmwt4jQ1wcEL
	ho1g0Wv+cV9ip03DgkAR75tL158vClVKDFmyiSML+W9csw2i8NOHCf27xxUyjI2u/Ez7Y9
	RdaPntW/Bb+edcp2QGDnp7QH0mjpshk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778172974; a=rsa-sha256;
	cv=pass;
	b=VAjQLjlezqey2H73mBizMGU3AMaewyzG9Sthtc5EqUF7oqYy4DuF2aT0Lz23BE2meA0bg5
	kNJG0ILlGFvrjLvb3GBAoVDPbTWuZvS+N1418nIW+hS5YxB9FDYHkNwNV8pUPddEuXqV1D
	VFAvE+2UNvU/JIMknkqkzfhU/kvd9Jo=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z4tlaB2p;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-9568159ee07so631869241.1
        for <linux-mm@kvack.org>; Thu, 07 May 2026 09:56:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778172973; cv=none;
        d=google.com; s=arc-20240605;
        b=Z/GBTyzn+Pr6+p42r2BE1p4pXbr+bWnzvC4zRaGQZeXT0w4aMYcWRrUGqrPUBZd2k+
         qNQtWsbyU1wBxf4V5O1+zw4uCCxD5rj80prxKjSFxCE3haMOD+dQ7fjfR+vI2d550sh3
         CMEK/aEoza5g+ZLuguB6nF0XACscZPD53YoTLGyf22ME3B6C8f/l8uae3qapXAKaS41N
         cDjpXq1iVo+JHiB9ZcrNX5+nE7nazZpiTQrm++E72e/kDdvgBOtHQrsfRiOyKY2Nci0F
         Oan3Gp06wK3mwEBVGaJAFaNFlwdMs7+gNailpkO/S7SsSROBh/Fn5zFyb8Xan+QlYVjE
         kvog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=fxKJNK3JYOXtq/6RpdHSxauIPnnYNnrQjQPiGKEVycA=;
        fh=7nAaBezcSgPtoZHxjsvPettPNX0x6ZLnWUulw+XtJEI=;
        b=RPBUwjJYETenzu46AXgzqwU1/DSP8RRit1jbGhphcHDKB7oqAWeruKfBvfxYI4LQIs
         lFjxd7HYjHTZ5ssXXhvD/VngImUco5lSZzpMrh9ODM9R//5VxecN8igLz180nTZgQL44
         2Mo3FydI8szmo4P6l9+C7mqRl70QK3euGYKMNelpOeIn/th8jVOz+ozJ3igohULnUmO3
         TtwRsNcmwVf1BMQ0eH8e9uTuBBLqM4gHRfrdrj1EWYODk91jzupSyQGmlFCvw6+UjOxU
         5YA3CklGCdeJCSSBKvmDydxCHsND8r4f857Zk570wUO0zQs782orj1NnDupEyihAJrpO
         zXDw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778172973; x=1778777773; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=fxKJNK3JYOXtq/6RpdHSxauIPnnYNnrQjQPiGKEVycA=;
        b=Z4tlaB2pM2ZuK1+2pH2Xx3j7kcSsjqhH6ZeH/CyCBNvimj8hDVjNMMvwO+VihkJqlO
         rpiaIKnxeG7Hv18TeE5qlk6ky0Jy3/r60oACTmicwupmw2+LOVM8rdzoV4hex4dtwweZ
         yMClG9jZScimpwEGc6cXDEK2B7QIQDgf7GUhtkymkHQ/rX5lpaxeScXi6pRas/YDLl7S
         pMXAc5pA8iVXKZOEioIYV0fGlr1zqHSTDfQY1PKuS+sYoUXYwhWy74YsIwV2iaMIGMJP
         mKSRTT5eVe9EPdGfe6X/VxWo14gy2XshE07X60XkuAb+win5QtZz/4uCtR0uzH6jces/
         OAVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778172973; x=1778777773;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fxKJNK3JYOXtq/6RpdHSxauIPnnYNnrQjQPiGKEVycA=;
        b=TKQ6AC1hLcBsPrNBUUYfgrljrvLj0KEti3So+PEiGzdsPM03JjfqkuQKiipv0qa6JC
         Oe0cluuwbbK7eczgCK9UPuuhDi6fKydTkAokfEU7WEhngfdYTKGbYthmfi3Eo1WBO5Dg
         nzV7xyFCozJeGuzF52eiBHyU5RhqWED/6fpJEeqo1Ntn9W/0iFe31RVyfb7hUpWTfgD6
         Q69YVBS4z1UspHFFztgP9wiHRDkF15AvgLsQ/D6s2vXC+qsTaGH4fhfs74DOozOLPHgK
         HvxWYNT9YArJb6t8glHsqHy9iQKv32Cpcl9p6TlfpNv6NhNefIRGgaf7ofVMU/ToBmfs
         kgGw==
X-Forwarded-Encrypted: i=1; AFNElJ94ZfyGwd6daT0Y/wK275vNkDWdXoqmeuZDrHSJrOTSVNLvEjjWIZj+fRNRKpC2iav6EatibtvtvQ==@kvack.org
X-Gm-Message-State: AOJu0YzR8yoogIF7AqCes/VL5ISYyAgsvQ341LLfs7OC3cXoz1s53lV7
	es5ZOLija/v5d110RBDjz2u6TT5O0MVs/TPi7hv18U32NVqQTyLPzLOK0z+vRHJYqx97OwFVIz7
	xiUlrPOWT+1C8jr+zu24bI5lcgCzntRDd1X8Wco29
X-Gm-Gg: AeBDietmPmANPK8/fwet5DxBhGqsNrPdsX5EKmoQiPbBFRPlOqP/sx1Wv2bFVnspm7C
	L5Q71Jdaam+0JgWpMOZCDNqdUDxO7cW0r5nXDIyD47dTgaThNem7ybksj/zWeOol4xC37esAcdH
	jSn+FvO+FQjfGv6oiYBce3pMjvc4YjwIrqSGjIPnf0sQKpWHcZBJHEgqoByDx6By+NL90u4azVM
	EWgPVoCJh1P29Ev5r3bAPaWxggL06vczDaAqC+2QOIw2OlFGgAKT+sqwgAjCDeApBGs+m7GUQlf
	jsne2KtdtO+6fJ84PB/nwJ6FojV9KSSm7oCPwzlYGrt9Jp9KEcgL8YjK+JElZoddMfIcAEcINVY
	G38he
X-Received: by 2002:a05:6102:3f52:b0:604:f29d:84be with SMTP id
 ada2fe7eead31-630f8e78530mr5085650137.3.1778172972306; Thu, 07 May 2026
 09:56:12 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 7 May 2026 09:56:11 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 7 May 2026 09:56:11 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <n5ce32wumzeiqqyqutom4apy2kqfetbvusc6j4k2xarsska5mw@klp5bmy7qhfm>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
 <20260428-gmem-inplace-conversion-v5-10-d8608ccfca22@google.com> <n5ce32wumzeiqqyqutom4apy2kqfetbvusc6j4k2xarsska5mw@klp5bmy7qhfm>
MIME-Version: 1.0
Date: Thu, 7 May 2026 09:56:11 -0700
X-Gm-Features: AVHnY4IiEmQejwyUzKbSGtsBzFH7WMpl699YC0dogi8imsP9-pFhPzVdvXeVDZc
Message-ID: <CAEvNRgF9+Gr7UVEq-E2SQEb_XOQQMOXy9F_A2tA=DbNV_fJ0EQ@mail.gmail.com>
Subject: Re: [PATCH RFC v5 10/53] KVM: guest_memfd: Add basic support for KVM_SET_MEMORY_ATTRIBUTES2
To: "Liam R. Howlett" <liam@infradead.org>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C103C0016
X-Rspamd-Server: rspam04
X-Stat-Signature: fe8wmshh4bdj58joiyx3rfpk1oiepa76
X-HE-Tag: 1778172974-277910
X-HE-Meta: U2FsdGVkX1+ASBGR7q2JVwKyj0Yua2x025ZMVODuO5iKvviCdoelwmDd1Feg7JNsHXwT23rhUtvXr0WN1FHOyPDBF7w9Rw3bezUlRuzJpconjy8LbcSIW2Dhls7l/eRH61q/3fr7i+Lri7JYiXErScWb5M+vm+AdIfVZKO74Homql1qfTrU9PE2blcuy40S4s5xem6rAPjYMXK4WysNJM1tuUH1eAG7GJWMPeeilW0brAGk3mw66Pn8qZjoD0gswxsaSS6HYwDOEhdL+U3FAyOngSseuvf92nfA9ubP4AEiBDT0q6lGXYkGKI/C30x8QHVgNJeTu2lHPvCEr/gQmg9xgqClj/4Pi/KaYin/5jCN38w2EzT/ick64RJDladpYC9bIOH1eP3AKZ9jBfX64ob2Le2ZGAE17NHVqASoUrs/cQsu5A/3XW2qTm/yCgCArRBlTdvK8dzarOnGSmRNSYybKcisMWUiXnyn1STTulCV7pXZ78Mdq7z6BUkXU4nrVDsIFzTp8vK+IuA0Tk4oxgjKuu/L4UJm6cSlDkAGJ3nrjbajISbDp24J+wECnHfCyLp+/qHBekNfXxSK6n7SmoEKe0LvwlpZ0W6BLvjYJaLhRyYbq2MANaYs+sTM1lReZNUYT+OO/AC/s+Pta5PghnSx3jIJuSK3z+/Z+PPnOkzKunRLmXV32S6lzBMf/TJLwdsMBMbXHmOnRBczDG1/K2x53tU6M4Iw6E+l2BW20YuzBHVe6DGBzTPgz9H7CSaG6h4057TmSlcASEnoA3g4sLKRX1UPb28BI8fEVGtYoK8bEIp+uUEnJthEkTbWzQnGuTfpIfehT9CJXNMTeTtWEP3pvuBgjQe8D2Iyd0n/XKdnj8N7DS7kwrb1/fnC3mvjCCO7oCMjGuJZ3x7iDLhPuQAbdUWenr5+fYAbUSj7JsJpuaZWPenHPDkKTKjt431Nhho76ivHZDlvcj9JHKSD
 yljjHcG7
 ywTMTCVNkWFYrWRXgiAblLuyRElb2lToUKsgMVB53x08rogGml7CgBKgAHDZV+nkaxgPNP6Psv0ywWm+GhIpmU4llqSQ5Jj1nMeREWp5iX3P4CpG499TIWk03NRSs+UIvk7t0rKA8NHy9UJKyHrS0SFMKByLIhy278oooZzGXhqQ2xoNIE0rPhiHaoK5zbsvJS2KN3LgqHwMYP3W24vkq98fSnuXjVHYmiQL1K+Yz0b9WlQAxn1HeMWBTeNp/VBw+dZHY4w1WnAj7a9hFA3coh7mdH9KVAEsFaF0qTR3gJPEKB8E8ZKXX2OFZZfLe2NQtRKWsr7Ryi/nAs4BmeJRuTuCc82Oo6kwz92x/2k1Sx5EXfh24y2PnolJVMqCkfYOayHwMEgICKXk/nlaaXJsaRf9KVifnlrygws5nrihg7YYvDRgC9wY+LVz8ZBFiapad/vRm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Liam R. Howlett" <liam@infradead.org> writes:

> On 26/04/28 04:25PM, Ackerley Tng via B4 Relay wrote:
>>
>> [...snip...]
>>
>> +/*
>> + * Preallocate memory for attributes to be stored on a maple tree, pointed to
>> + * by mas.  Adjacent ranges with attributes identical to the new attributes
>> + * will be merged.  Also sets mas's bounds up for storing attributes.
>> + *
>> + * This maintains the invariant that ranges with the same attributes will
>> + * always be merged.
>> + */
>> +static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
>> +				    pgoff_t start, size_t nr_pages)
>> +{
>> +	pgoff_t end = start + nr_pages;
>> +	pgoff_t last = end - 1;
>> +	void *entry;
>> +
>> +	/* Try extending range. entry is NULL on overflow/wrap-around. */
>> +	mas_set_range(mas, end, end);
>> +	entry = mas_find(mas, end);

Thank you for your reviews!

>
> Please read the documentation as I believe you have a bug here.  What
> happens if there is another range stored higher than end + 1?
>

The invariant in this maple tree is that contiguous ranges with the same
attribute are stored as a single range.

The goal of this first part is to get the entry at the index just after
the requested range, and see what the attribute there is. If that
attribute is what we're about to set, extend the requested range for
storing to the end of that range.

If there is another range higher than end + 1, with the invariant
maintained, that attribute has to be different than the attribute stored
at end. Hence, we only want to extend this requested range up till end.

> Do you have testing of these functions somewhere?
>

GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(indexing, 4) tests setting
attributes in ranges. If test_page is 2,

1. [0, 4) starts off shared (4 is the number of pages in the guest_memfd)
2. [2, 3) is converted to private
    => so the ranges should now be [0, 2), [2, 3), [3, 4)
3. [2, 3) is converted back to shared
    => so the ranges should now be [0, 4)

I verified this by inserting some trace_printk()s and inspecting manually.

>> +	if (entry && xa_to_value(entry) == attributes)
>> +		last = mas->last;
>> +
>> +	if (start > 0) {
>> +		mas_set_range(mas, start - 1, start - 1);
>> +		entry = mas_find(mas, start - 1);
>> +		if (entry && xa_to_value(entry) == attributes)
>> +			start = mas->index;
>> +	}
>> +
>> +	mas_set_range(mas, start, last);
>> +	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
>> +}
>> +
>>
>> [...snip...]
>>

