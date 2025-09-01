Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2B41CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:05:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABE658E001E; Mon,  1 Sep 2025 09:04:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A963E8E000F; Mon,  1 Sep 2025 09:04:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 984F18E001E; Mon,  1 Sep 2025 09:04:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 816C68E000F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:04:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EDEE4C0822
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:03:59 +0000 (UTC)
X-FDA: 83840698998.11.7A18251
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7C6D114000D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:03:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S95nPi2+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756731837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4S/AvwRukxKIejg9tsdip6CFv4zbua8sXt7imfRAS/s=;
	b=SKZXBMM/w+5Au6kb/4uIOiSijYLXzuWSTMvk64hsKWE86XHOAd+CpA4EWuGF6+MckMNzqb
	WZwiXunAI9FBfeV/PVgsYQ80akW4VVKF4TIcGQ4mDda4QqlZm2E9ry8OJJ3azTiqRQ+zRy
	CIjDTi472S0E4CSNQ711h0bPend/XYQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S95nPi2+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756731837; a=rsa-sha256;
	cv=none;
	b=mlV6RAocgTgNOgpdtLayhPv1Iv9Qs8lS7B4ZpliWlh1Ew08/hcM3+21prpZz9kFN6Gz4HZ
	CT+PFt7NWKr227Vi+bMFzF1IQZ5Q8NACXWLr/ibqJm44/6bTnDPiUFV4+mkMx0bGor2gmH
	t5RtanonRZovgxKNtwCGqMtxt7vsKbQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756731836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4S/AvwRukxKIejg9tsdip6CFv4zbua8sXt7imfRAS/s=;
	b=S95nPi2+3yxUtBUbqS061/CRTlIjweqyL11HT95hE0K4nXMGvlB/IP2KIWrJlpB6NU/IWF
	5Oy+VIOHu+mCPyCwlX0VA7MPnqcsd9jskAOgqcFOmt8sOVTOwQ7+iJ9l07Kgz/+Zu9Uett
	w4IeapYL12p4UTWa3ttDTGbmrMW17ek=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-jLdsSNTuNtSw3lbvoQdvFA-1; Mon, 01 Sep 2025 09:03:55 -0400
X-MC-Unique: jLdsSNTuNtSw3lbvoQdvFA-1
X-Mimecast-MFC-AGG-ID: jLdsSNTuNtSw3lbvoQdvFA_1756731834
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b8a307c12so6214955e9.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 06:03:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756731834; x=1757336634;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4S/AvwRukxKIejg9tsdip6CFv4zbua8sXt7imfRAS/s=;
        b=sC6aLN1k5reaDHmZBZYlTvDTKAyLrmfxjDK9D1wxghyrzFJGfNjwzlvh/eNOx3LF6K
         lx1Yz8VCvkYrQ0dsn/FVI4dKcTqbk+LdZitpc0GZItL8AyMTfElRQnEG9gX5p2wOTV/i
         E4DpMI7l2+7Og1RGhvAW0coObS7HMwYPJl5ep8al5dV7LkmG3K0lkHUVzeCcotsPQEQ0
         9dwqNOy7hpFwCWbLMwN2pyosuvocK8KBR+KUBxE9j1Xli0zOjbIdxbwumsSnEkXb+jtU
         aZUaW61/EZQSHsayBY4RPhMNI7eNI7h2LjJSVfbI5+ZLD6pMXG5nyGMMIiPHLwUxnxfA
         ddpg==
X-Forwarded-Encrypted: i=1; AJvYcCWXbnGUTU4rMVlg+T7daP7TB4Qp99KvtZlV3KArTVAZoZrEqIdS3ft75lnXgeMmJe8Pg2Mn3UaitA==@kvack.org
X-Gm-Message-State: AOJu0Ywb43tE8u6/d6QzhxUrmsSszsZMohIwyVo3cSPH/8cgxhqYz2Cd
	M9R5LBVdBX9pDawf2mfoZT/yCDqOuYCmAAn/HjWSH92wt8H1m7lSkjoe+ttJyHlq5pD0BfOWSSA
	Y9YpGT8Qr9NmmNNVAmLiCVXKrGjgVGTTAutDVSjaqEuKXBApnEL6Y
X-Gm-Gg: ASbGnctR7ge4D8oWdPaQcC+9yl3Ji/3VekgACQi1MRm4Vew3EkYuTpKPzmutmqxc5va
	3kOcAGSkXb4rwH1nyR8SzZ+Sunr46LQUcbFYUOEHvc6rSo+Qd0/0u/5Ul3UDzjjS8jLE0QapEIX
	m7UBogv8ivmv3MpY0UM+R7ecU78qQjbAyxsChXCdz8OckB7a3qjAjn64te6loo/6n5YGbJpIC1E
	ISqEdgvoQnEJMNv3cb3s+SF20Cjbuu8bUZnconj7NiOoTpe64K6AfsoOM29sS6FW3KVLzKy7FUY
	8dtA9LIPQsZ1OOiLvytqiLB19feKAsV/OxC8L56pqaN8Pj/VOqD0vLIltJXZzVIcV39Yf9Ge9yU
	dzhMLoiRHA0aKHRE8MS+dvP/XiYnTipSu5eF4BtNb350LHOkcZQkTVSbylN1MLQD9OqA=
X-Received: by 2002:a05:600c:3baa:b0:45b:8b3e:9f7b with SMTP id 5b1f17b1804b1-45b8b3ea15cmr36229275e9.3.1756731834036;
        Mon, 01 Sep 2025 06:03:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFeSZT/6o5qBMANLK7aNiFwK9ljYFxoG5c9Qiw88K7oLWWH6nH+zDcxN4lJDLm0Ugp6jdmQyg==
X-Received: by 2002:a05:600c:3baa:b0:45b:8b3e:9f7b with SMTP id 5b1f17b1804b1-45b8b3ea15cmr36228925e9.3.1756731833552;
        Mon, 01 Sep 2025 06:03:53 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf34491a65sm15061948f8f.56.2025.09.01.06.03.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 06:03:53 -0700 (PDT)
Message-ID: <0a0b0018-9427-4201-bf53-6aeb251bc482@redhat.com>
Date: Mon, 1 Sep 2025 15:03:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] selftests/mm: check content to see whether mremap
 corrupt data
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20250831022701.2595-1-richard.weiyang@gmail.com>
 <f8e942de-1a50-412e-9020-1bc901b4243b@redhat.com>
 <61E58B7C-23D0-49FE-8D0C-CE0B672114E2@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <61E58B7C-23D0-49FE-8D0C-CE0B672114E2@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cGiqCRDDC-UTyQx1HEq6v7sJEsjlqOr4kg8Ueta7enQ_1756731834
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7C6D114000D
X-Stat-Signature: nodd5xme76ue5xd6e7rqt9cjf5ux9d6n
X-Rspam-User: 
X-HE-Tag: 1756731837-676521
X-HE-Meta: U2FsdGVkX1+jxPKZ4fEzjzzRL08NiR+Z/bXX3YnyTEOK1v5p2UgpYtpfkBh7KM42fYor4duAE0+FL6oWlJkZG6QFc2it5uUz+GRSXI/CiRnSQIUGcV1VrAneRX2x9JMmO5oZ5oI/V0hB32zOUOdNyCDDyhkwhaEXGI9UqIf1hT7RCAVJ81uSLHkdCa/lTcB9vJkIT/MeXUhJdF1J5Yfl+wqAmzbkpPI09n15umFupIp4kzcd0XzwEfsk1xoFSlhJNHfT5y2hB0Iw7KzDm1EqP0+KiTifCwC0vWPYQsQMK3c4JmimEQDVW5tIyunf/8P9whoGvvFDa+d3iQYl4slspHsH42H+tLdcrJkO5UV5RaEWWPGaxiw4neeTJhWCSQbtp6653HntcXXQCut5NFWEUJFwyTVIuIrrDAh1MrboHRICaPExlGXuMnKJvlE6fQXLrINw1RgUtpflUQ2I98DavgTWUH/Z1RZgc8NFN0mmByLHTsWfXoEclOXmhrb26XF5QYN9gFq+vKiseCveqRKTCG8Qu1spzdI9xfAYvg9pnSDuyLNzjn8BWu4nM3QhK+3AADF682ciQFsDKZ8fp1KQ8Ji9x4UWV54zA12a8IrhgpnsB2QF8YCEocEy17OTjKcZ0WnQMurjn2shXFZF+4nlrhhiRwGVgAeEC4q7PhovcLV2C1BeNnEvOOoVamQhjy7LnzIbTqSZT/QGEtnYiddsYzpvadsi5dGW2ECq+N6dZftprOtrlE0mIEJJUlWX0j+lUB2JdA+1veJdz8Z98ttZTY5D66P+9nD1aPcn5Gfvlo6J2XqqdzTJ9xO/PKj6O/skB1dYs/j9fgaeyvUyy2KdJdQv2yvwPfjViAJs+6IKnNUnoykS1Z/Vcm8foAzUA88L+x1OukzP+6qsbrIEJAI0g/VKl9t5NN6SvQmkGwQHW0OgEaScAVrRxNBwXYiOMyhBi+Two+rEXmiZI+TkgFa
 xc8wrx9O
 xPtPYD+63u1q/IFdjrstIaraX/OiNbpDnfc8SNoIP4VAfIwqHJzOA3qB6K+NVZg40W1EplIxpktD01ChLcjNDW+ek24nOJ7BVeWyVPiHLDTzdPXimNpNLPQMqY35sz2Jg8p0DwNu002nYstKUYGTDqcPW0IRTKxJUyUmMEKuAsr2lflkgemZ8ntBp0dL2lY4z2q3ohWSdaj3CWnRwg7t1o10xwx+NPGek/D42cOVthCfDOENQn/B6MX2/F2+IZSiU/1qKqJfPpoZPISKeq4RcQMstkTFZ2Y41V6c186Fs1zLV33nf0JcD5fqBNz4pcw81r/KsF/+wsraqA1U7IZ0EDKY7l+umJ1cX7CO8PaEdcpwZ+/SFVZWVE93sEGi1KhsTpVx3VseRXUl7lvyOgBIFUlIziMWf7LphHo4qi2NYP3ApyFfzX9tjBTfjX3fB04tP/GKpQxJlbBT4l+soEEKDGRgiBEfEo2aBeRx2E9kYg+tuvILoCN00Za5XeTFZzr58A3tMmc23fbV5HG3JO+6PbY7kFwwdZBZ/qtmCgz8ddOyCrSphRW06LGXIWn6vOf6Evi0fXO60HzFrL6EUVi9N8E81/tM80PrkfQfhx55GfOhzCXw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 14:56, Zi Yan wrote:
> On 1 Sep 2025, at 3:22, David Hildenbrand wrote:
> 
>> On 31.08.25 04:27, Wei Yang wrote:
>>
>> Subject: "selftests/mm: verify page content after remapping PMD through PTEs"
>>
>>> After mremap(), add a check on content to see whether mremap corrupt
>>> data.
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>
>>> ---
>>> v2: add check on content instead of just test backed folio
>>
>> I'm confused, don't we have that exact check later in the function?
>>
>> Your v1 might have been better, unless I am missing something.
>>
>>> ---
>>>    tools/testing/selftests/mm/split_huge_page_test.c | 6 +++++-
>>>    1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>>> index 10ae65ea032f..229b6dcabece 100644
>>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>>> @@ -423,10 +423,14 @@ static void split_pte_mapped_thp(void)
>>>     	/* smap does not show THPs after mremap, use kpageflags instead */
>>>    	thp_size = 0;
>>> -	for (i = 0; i < pagesize * 4; i++)
>>> +	for (i = 0; i < pagesize * 4; i++) {
>>> +		if (pte_mapped[i] != (char)i)
>>> +			ksft_exit_fail_msg("%ld byte corrupted\n", i);
>>> +
>>>    		if (i % pagesize == 0 &&
>>>    		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
>>>    			thp_size++;
>>> +	}
>>>     	if (thp_size != 4)
>>>    		ksft_exit_fail_msg("Some THPs are missing during mremap\n");
>>
>> I'm a bit confused with this test in general.
>>
>> We do a
>>
>> pte_mapped = mremap(one_page, pagesize, pagesize, MREMAP_MAYMOVE);
>>
>> which I read as a "NOP".
>>
>> Questions
>>
>> (a) Will this actually do anything? Also, maybe it does now, but can't the kernel just optimize that out in the future?
> 
> It remaps each subpage of 4 PMD THPs into a contiguous 2MB vaddr range and
> perform split on that range.

I'm afraid I am missing the "why".

I would have thought that a "split_pte_mapped_thp" test would want to pte-map THPs
to the see if they can be split.

Why is the mremap required? IOW, what exactly is the test trying to test that
exceeds "split_pte_mapped_thp" ?

-- 
Cheers

David / dhildenb


