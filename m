Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43941CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 09:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AFE28E000D; Wed, 24 Sep 2025 05:35:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 887078E0001; Wed, 24 Sep 2025 05:35:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 775B88E000D; Wed, 24 Sep 2025 05:35:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 632BA8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:35:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F4741A073A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:35:29 +0000 (UTC)
X-FDA: 83923635978.26.7CE9544
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 16D8940006
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:35:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PjLa7RNG;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758706527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=flhIxF1CIU+NzbWxBZUv97V9hyecdhc5D6rGvoWWeM0=;
	b=Iu9tW/vkrPK0OWpBwWPdNVL/VybINMwinMAi5y80SSU4l/1RFIBaJBju9FFOVz8VkmKNjF
	fQtK2z+ijpN2hUEqSFNGuwAQ13trxDX/VtQpx9YY4ti9Mz6deWFbh/2ko99cNnvFSKwrJm
	TflQcdAh5BRY2b3Lo3iOZnvQOT2Olmk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PjLa7RNG;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758706527; a=rsa-sha256;
	cv=none;
	b=u1PFUo0yHtuO19tAP/Z/fYWq0B5k8tdlQAUTeHOfdCMlgO8h2HMAD5msWZQHEbbRVZ1PMc
	MGt9TrNexxD7EuJ4mmHr4yI1KuD+aPllCCN2olALDSpX1mIDIIBY/YWGv4EZMEtkkcvt7E
	l/6E2bTzyRxd2lH2+65OOJ0N7R6cG9c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758706526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=flhIxF1CIU+NzbWxBZUv97V9hyecdhc5D6rGvoWWeM0=;
	b=PjLa7RNGhxAfx/FKxV6tJ8st2fDLGLmuG36N1eDo3uc4NEILYgLYLNYal2iusYTT1WCxOx
	ySDfg7ycm2ZAmsbdUxlFJ+d17caKmz2v+nA5CRMo+J/30KBQNAKr4aEU//Bw1nstQQq+vF
	A6k3pHvNjYygt3DmI1vfV6fnFOSJEBk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-42-IFvxTQ9bOfiezAdRzIMNSQ-1; Wed, 24 Sep 2025 05:35:25 -0400
X-MC-Unique: IFvxTQ9bOfiezAdRzIMNSQ-1
X-Mimecast-MFC-AGG-ID: IFvxTQ9bOfiezAdRzIMNSQ_1758706524
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e28289629so2388825e9.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 02:35:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758706524; x=1759311324;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=flhIxF1CIU+NzbWxBZUv97V9hyecdhc5D6rGvoWWeM0=;
        b=Jk1yaZaaxQe0uiMchtRdEgmYo1BbjnW2x4Kl1RX+xoDygS657P1bOAl17++cgzTbAj
         gPXlmQPJxVbEYbXvc26NC2WuPk+xbb7miw93eRZQXD6jIWBdF6pefFvqaM9ji43RKmPN
         713s627TrkcRHA4EIlSI6P/2Mr1MW5qGetcZBttvi+eEm2fddnRswZC1J75oTzRK/NF/
         RVJ0O6+Z/7HKXy1FDDbROGa+xgjW4G5fgEcRvhToxT8z6UAkCuC4UWWJU08l9P//lF+f
         X5a2LcTgTAioYgqM9Vke9eXS/iU2+MJzzLl/Au5lj5E8SENNzkwurAWrKPknF8R27YJ3
         kKvg==
X-Gm-Message-State: AOJu0YyglfqZtewr3FFgPyxlyxBQmJ7HdoXbI91Z78xPxPlMJ8T0wX7R
	OdPk5eBbMVs9wlOPt07L0BG0VgDJKl4hqu9dRh1356y0Pd4sAWh6MhqahT9q1TFcov5SLBRqcpY
	SpkPMLRHyxeXI5Tpg/NeTF2PvHj8UVwNfSAJWxPwV5i8Z3VFk6pHJ
X-Gm-Gg: ASbGnctXJha5+2loqdkwTESNnySBHlL526ETcvCIMYd2H0Q8MJoXZlGAyva3XzHDtM/
	BUx0OMtLkp1cwWOXLO1kTlalrAhtW1rizEBYpfklf/x5fAyIDclRPVlOSzSKBIt+wYGTWwz7Auk
	eLhfwIEe0vh9KEqtp1dd4wB+Ot9FjWIGY7ExOf1DVnKzki0VnvwuUgFm9vc0KHmZP/s91/tY94l
	bpMJCF/otQZQgnn4r/xSzZNvkT0yeNN3Z9xS6zy0hwUNHdYK2SBRBEi5AjdGfP36YppRdRsHn2+
	qrEoeZ/4v9uRnWeyJu77FldgdMP1YWP4z8NCrQ8FRDoMEc4m5n1N5cxPEyH2IbG3bTyAWdRjUoF
	ddD5hPnYbLPmEi/u3G4HsYzlAR4LqOJc7wjcL6Re+sCd37FY4rpYid4rl0nTdjvZ81g==
X-Received: by 2002:a05:600c:1c06:b0:46e:1aed:5d4d with SMTP id 5b1f17b1804b1-46e1d974911mr63588485e9.4.1758706523852;
        Wed, 24 Sep 2025 02:35:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFThKMKHx84L3kmCTQDKMTOxH3r1eeY8goxrNMqCHP9UjHV/l1aQBNnpvRWLpJ5sr8Wu9lKAA==
X-Received: by 2002:a05:600c:1c06:b0:46e:1aed:5d4d with SMTP id 5b1f17b1804b1-46e1d974911mr63588085e9.4.1758706523403;
        Wed, 24 Sep 2025 02:35:23 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a9ac55esm28081935e9.6.2025.09.24.02.35.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 02:35:22 -0700 (PDT)
Message-ID: <eb89e41b-c627-4a07-8388-8a3074ce0620@redhat.com>
Date: Wed, 24 Sep 2025 11:35:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3 1/2] mm/ksm: get mm_slot by mm_slot_entry() when slot
 is !NULL
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev
Cc: linux-mm@kvack.org, Kiryl Shutsemau <kirill@shutemov.name>,
 Dan Carpenter <dan.carpenter@linaro.org>
References: <20250924004854.29889-1-richard.weiyang@gmail.com>
 <20250924004854.29889-2-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZoEEwEIAEQCGwMCF4ACGQEFCwkIBwICIgIG
 FQoJCAsCBBYCAwECHgcWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaJzangUJJlgIpAAKCRBN
 3hD3AP+DWhAxD/9wcL0A+2rtaAmutaKTfxhTP0b4AAp1r/eLxjrbfbCCmh4pqzBhmSX/4z11
 opn2KqcOsueRF1t2ENLOWzQu3Roiny2HOU7DajqB4dm1BVMaXQya5ae2ghzlJN9SIoopTWlR
 0Af3hPj5E2PYvQhlcqeoehKlBo9rROJv/rjmr2x0yOM8qeTroH/ZzNlCtJ56AsE6Tvl+r7cW
 3x7/Jq5WvWeudKrhFh7/yQ7eRvHCjd9bBrZTlgAfiHmX9AnCCPRPpNGNedV9Yty2Jnxhfmbv
 Pw37LA/jef8zlCDyUh2KCU1xVEOWqg15o1RtTyGV1nXV2O/mfuQJud5vIgzBvHhypc3p6VZJ
 lEf8YmT+Ol5P7SfCs5/uGdWUYQEMqOlg6w9R4Pe8d+mk8KGvfE9/zTwGg0nRgKqlQXrWRERv
 cuEwQbridlPAoQHrFWtwpgYMXx2TaZ3sihcIPo9uU5eBs0rf4mOERY75SK+Ekayv2ucTfjxr
 Kf014py2aoRJHuvy85ee/zIyLmve5hngZTTe3Wg3TInT9UTFzTPhItam6dZ1xqdTGHZYGU0O
 otRHcwLGt470grdiob6PfVTXoHlBvkWRadMhSuG4RORCDpq89vu5QralFNIf3EysNohoFy2A
 LYg2/D53xbU/aa4DDzBb5b1Rkg/udO1gZocVQWrDh6I2K3+cCs7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20250924004854.29889-2-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WxbhSY8uSad8fnuKlf_qHyw9ap31dG7rb1lOCwtoz2o_1758706524
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tziosshe7hz8719qqzsitsreijbusghj
X-Rspam-User: 
X-Rspamd-Queue-Id: 16D8940006
X-Rspamd-Server: rspam04
X-HE-Tag: 1758706526-161127
X-HE-Meta: U2FsdGVkX19jbuYqpmmW5xlyGlYgag8N6TOsOvBZt15MTEVDf33HWRifXBBzOGpLjSQR6JVTc3g/nV7ixjMAkJA5UJtO59bQgLW/DGQVzNiU0qY8xUOx38xmq5E/zgWv+bXyDA+/Uiv2OCgzJXSwF+W8iq7wMoND4SlXGVXHJgdsnwGyQ2a37fgRdMJD3LWoupYTeSuvGPVC40mUTgCGBsqXlPckPKolYXn3fz9glQsw9LUrcdtvcNjXJYPFNc93R49UqF1EH216cTGxst+8YZ7nsy6c02dCdKctII0ebsrZCIorvib/PW3aBvElNxLk0CJwLXKrc6d0C8tnyG30vcNtnNdfhXZq3OqkfK0np62TbfvvvmQXkbE1OvTdhHlT3+U0/PX+cf8bkjJqiihYAfLmrNi7zES7PIM92kFwY9Czhe87IlXoLTg1fAS61ONH4DoGuwdtLFL6UZYAqnv2xxyry6nY8KL+i9pT3pMj9LQlzScMP6vE673nc3XHgY/gN/XHyrpg1KkuI4gr6kVN2zELh46YAt3THUGpFd1w/z7CWPZzofRQkIwPZhGyDOe+vVn5rq1RwdCUloXj8d2mkN1sxbO5MKJZDb5jT0wzyazmaqGXoc1cWlMeoTmr/ffb+y05C2DY18lHFNoDZdVK0BMZGdSsrpGhjTvfw4NEKh6GpMPqIkZ+gFImlAuJ3JfabydWX1MGq9KP8z1BLar5DIxWXXkbt7SMNUWESyRzC95RvULoi2i5tjpHqla4UpTW/ld+DOBTBX9PaJRl9zrsrDYzEa8JGvkzntcyVvKR5XuavkTlDl4kJhvc6b601uHBobVRCby8DUk5/nqjhLimgxgS7vy9LJQVjGx2PH28r2jFkXVs4YCuGUMmz1+RJP9nJL6s7CDS8re7ch8kGfAPhem0AD9sABdWOQDtypiaG8R3ez6TEHzlfLUyGF11DMhgQtUNkEEb3R4hd1A+39o
 nfTb0lia
 DhcixNhvINosgxURqCuHKP72GNHlHvuD1qCYOBDZbiUg1fQasYOsMwkhZpicwXTuraION9QXnFz0t7Nzo2LHdyBayi1lITzfC+f/SwuR7hOXd62bkOMI5r1o28P854wgloWoVhdax1OEOxTiFK0UBBgcGBBDmG4WkeOekIOKSW9hDCM7b5L+rS7OOWqga130oYYW0pd202Kr4O5dEiy8TdSafC1nrHEQJh8cc3vDUFVC39zMpn3b0hajP7GgcYpQWmIMjihsLF38KgccrpoiG/uL0EbzcyfD+uuQhKJ/YeM47mRJ/rGeVL6cG6XbGARKiyB68ULO9b9bJWm8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 02:48, Wei Yang wrote:
> Patch series "mm_slot: fix the usage of mm_slot_entry", v2.
> 

That should be dropped.

Subject: "mm/ksm: don't call mm_slot_entry() when the slot is NULL"

> When using mm_slot in ksm, there is code like:
> 
>       slot = mm_slot_lookup(mm_slots_hash, mm);
>       mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>       if (mm_slot && ..) {
>       }
> 
> The mm_slot_entry() won't return a valid value if slot is NULL generally.
> But currently it works since slot is the first element of struct
> ksm_mm_slot.
> 
> To reduce the ambiguity and make it robust, access mm_slot_entry() when
> slot is !NULL.

"... only call mm_slot_entry() when we have a valid slot."

-- 
Cheers

David / dhildenb


