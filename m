Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B126CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 13:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B0308E0009; Mon, 20 Oct 2025 09:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6879E8E0005; Mon, 20 Oct 2025 09:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 576D28E0009; Mon, 20 Oct 2025 09:08:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 476E68E0005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:08:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E519D160111
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:08:31 +0000 (UTC)
X-FDA: 84018521622.03.DBDA29D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7EE8D8001C
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:08:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QdyFWhy9;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760965709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=moWrDlRplO9sVkiqQ7q8Ig4P2TB/yFGyx8VFSJzRlZw=;
	b=bS/qpp7H78TJwJAbGgjsEymtIYqvIRkb0YMG/m1yp5Kn7tSdFyaD50Wlfsn9SApdtQrENe
	nYon0c3mdcQyJ6C2RoDJ3x/RltUjWH+FNQJpDlvX5oo2O/K/72dtLuAVjDjRIn+zg2QyNd
	OG/ku3QJgX9orYtWvy0KAnrGm3oTJXI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QdyFWhy9;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760965709; a=rsa-sha256;
	cv=none;
	b=Uu5d3x4p9rE8gMTsZx3GqbFFui5LWJz/s8WudpxVzOvUEXZWcNGDMhiryjNm5ZZC/L/hNS
	j6xUJnWOpa6o9EJ1G2H0k6P09KZ87wpZadK3/3Z5+9nTOCYfb5Dke8hAGDcQcjbFOSoTLz
	0TIf2negOBolIFDs2HknDamnAHS+0tc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760965708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=moWrDlRplO9sVkiqQ7q8Ig4P2TB/yFGyx8VFSJzRlZw=;
	b=QdyFWhy9dK5wsQAJ92nComNqV+u7QtZTEpVK8McIPCGFCfiGdcj0PXBEa84yMaoQPBRX6L
	rZA7VZeAkbIhlzDtYyQJVEgOhvWdWaCAEMoS271rezoDC0WjPCalfIadVKHrq4ui2R6jiN
	HqYz9WtzyD2fsK3Xf56CbhxOGPKCQo0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-bIXVvTXVOcWKWuSE8KFMqg-1; Mon, 20 Oct 2025 09:08:27 -0400
X-MC-Unique: bIXVvTXVOcWKWuSE8KFMqg-1
X-Mimecast-MFC-AGG-ID: bIXVvTXVOcWKWuSE8KFMqg_1760965706
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42558f501adso1831735f8f.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:08:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760965706; x=1761570506;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=moWrDlRplO9sVkiqQ7q8Ig4P2TB/yFGyx8VFSJzRlZw=;
        b=UPggzyq5rpr3N2FYXrag9r10/N+2hkaojdaMAwHrgi1siuoo1nxF+UJl67pTe5BIzv
         r00vyNZRLNkthUmgF4E0+CwIfDdmQQA3KFVg8mvsdt3XDlr6y9YC3V7q0WF9xbwoAXwM
         hsY9DW4wODlPF67VK3hHY/kMusG+gX9HVjkZCsZuLh/w/X9rKL9n5Qq5SQwAazdLpuSe
         TRSoVaXw1cu5pj8VhsbIVqMMbz4mBnxRSbGuYDbY4fIs0YZ3h/XRmB5anHgbQJeu2lXr
         vkx74Eta8+WydB8nyNCv48pem8xV4nBZhKZsUxtVEx1DXdcVUe6WZoIs1Tt0rO9NxPt7
         ECyw==
X-Forwarded-Encrypted: i=1; AJvYcCX+OQX/z0f2mkhhGwviTznDeC6cWMnWlU/I8cuY9qRyPz1AWjFIpe1Hw6T85+z9V9wiB4UDcIEtmA==@kvack.org
X-Gm-Message-State: AOJu0YwYNXoO6TJy0N+En02ppIabtjF9tvnfwEaKB2j69ZjYjKIRdGKj
	AvrY4bfRS0jT8nd9sv0wf8DW0rpX9WYWXgsiFfxewbpBhGwkgvDfHc7sgQ3BE3jc2FpniObYBfp
	PP7a7tHbPKJTV+7KBVX8FtuARq3Rz3AT/qaxOkHW41ZuEjsrfEq+i
X-Gm-Gg: ASbGncvjv1aZ4Y9giSSCLYCsLMXr7LPSlxoUTY5cU5C0XM8Bm+pKOMZ4eWaD705Scx6
	oxNRtwKUf0ERad96yJ+qa+UNngvCyoV8GXSXzMrJT1XxX22Roq1oQZJg4yyF2PYtJyMGJ/EVTds
	cY5MAPipbmbC5NYMmn5KS5ZmQ+ucCNv43yZx2PiiucZnwWN+BrxRAvplm6GWEF/j7Cr9Fv2Ufwm
	hNMdcDl+XOtJkX2RA0GEICab56v8KHV73U7A51v1gMM4hLRel5O4+P26eOQX2OpGfWe+cBuo/cT
	cldCNz/PHon9F9zbnPwlJkTazlxrltD4FS8a2j3/+RM5T+yb2oxhkISuY0von6cpeSMuDhJbquX
	x7rWCkFWEiPnC5IpuPFvoPl0YezN3ynb0jM+7yqL7BOZ2ureioLP2/d9H+c4kEwh8nv/A22MAgF
	4EoaIh9uJFlR3yUEBYX9Zm6z0uvkw=
X-Received: by 2002:a05:6000:400e:b0:3ec:c50c:7164 with SMTP id ffacd0b85a97d-42704d52205mr8980265f8f.15.1760965705693;
        Mon, 20 Oct 2025 06:08:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOWEFyGHBY86t4soh+6YJaEXaQ+BKGZnUjlT52XVKMGI8OZAyEcNPHq79jZdMa1ja0vidC4Q==
X-Received: by 2002:a05:6000:400e:b0:3ec:c50c:7164 with SMTP id ffacd0b85a97d-42704d52205mr8980235f8f.15.1760965705291;
        Mon, 20 Oct 2025 06:08:25 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00ba01bsm15038910f8f.41.2025.10.20.06.08.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 06:08:24 -0700 (PDT)
Message-ID: <3f680786-feff-4a43-8f32-7935e4c77a16@redhat.com>
Date: Mon, 20 Oct 2025 15:08:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/4] mm: mprotect: avoid unnecessary struct page
 accessing if pte_protnone()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Liam.Howlett@oracle.com, Sidhartha Kumar <sidhartha.kumar@oracle.com>
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
 <20251020061845.3347258-3-wangkefeng.wang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251020061845.3347258-3-wangkefeng.wang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3CcmhHwKlAyje5bX-b2S1X_9HNzxIjbdsqwGJg5_CCo_1760965706
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7EE8D8001C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: t6936c1fwjtg1enjyb3ahtpispa67h4a
X-HE-Tag: 1760965709-739132
X-HE-Meta: U2FsdGVkX1/eiVNd4MXOlxMYNkIVzcBvqDd9CX6HqcLGpQrxuYUPnQZe6ID+rI5dVJiLLoO+wEOHv1IaKKHLbsIAoaz7VMXwEzbeSHvx10Dv5ZOCRSIopNfJZCRmgU/IMo5fZ2K5qRYF+ZGhC7c+rHN7b4zKNyQPc/doYAOmlosg3oIjHZJK+Iy7mO+bj0SEtglG3lRrIYbE1fsmJILwZ7ZaasYBgwD/OS3f5xF5koyrpTURGWjff0IhneTOd+ws2pR/qXh93mVownNDHB9PNTn6MR9ZZxFscztB2ZiLVCZAnancCvcUzS6DdxjUKhvjKcvYviuFEDd3T3+QUpO0+qr11WSu07bjWyv/Jg3DpZRCbXzGLHYGkCONjlu3JmJZT/RrArIO57nROvrNSa8lJPGr8jUxw2Uh0GFnFmHwCmEuWTZ1/iPCJEms4ksEatveUmVfC51MSPK9WfANFWHQyN/Yrq8C1oLcO7RJ2cfWnyeYlYAuzbryNIdtGckSl+CIte9yIY1w4Fhlt82TIerd92AGutEGdzoo5GT4YeXxfy7ir6jad53r9PGZ5VaXcQMJi+fkn8cMleqLfBKrrmaV9qNzWOAeSfNc0sYF2zWO7MBEsOmghuQLPvsSk3GS28nrAd8WA/BiCBrd2r7WTU/RiFwwF0qsYQjdZki32x0vS4mvgQzB6axuEyfDp88AGZVVyQLrWBcRoGe6RDI8xhrX70trRljduPxpyKoOoWKdxFF3XNB8e8OFEMZDWpR4lpxki27/Zj2cpYXdZhmQcT5rXPMTd0rGBVAoWNhcvX9j6ewxPLSLgtZR5FG69zEW7OqAQarVCwTTOhhawueziR4pxD3NW4pKYgl1+3/ee25Wrv6UyTmouUUmXy/orL6nH3RFzPQpPsLSOrAv1DTmY2FiEIbtJi0eY25Uonqcck66o3Gg1Pn5G/hQTq5RFwb1/aMsxLjhouW3uSsUByfqDP9
 vKQ0N/Fr
 b4WZGo/C2wkt9l7t+v2afOq8fRc6LIkpeVTKwwK7t5jjhE4e1oUSKELbzIOp1Sbk7L1mhGgTgTO8Wx7qL8FqHcXyrhq14UAdFPI8Qial439QD3seh1HrSmv9dby2qObBt8M1eCpL9NVJdmZjn4VBgkncHpV+WmUvTjhB4vqvZXzWhlChcj9XYAzB6GsVhhOOkq6nhFCOk1Gdike17x4TrFQHuLs7eGftRD20sqbXxivU103h99Y2NppY3t0VdbacV3lBQWdvUqYhiMeJX8ueyPhqAQuLx4ql0o6HsIcmvi1QdZLXrbiQGk+rgahxe5a0yy04o8WBE7xfdn0rcf15pC/e/miGzQ7T/OAx007HmegVNIWW+8U1P+w9qQzl9mNslV9WcmfEULqm4vCKIexvJ8NaZS9Ndd80tCP8HIkTRt7Qbt2XpcXq550jVkxQZOhRgi+8rjjxrrqpDYq0UVaJKLLDuIQihn5P72Ub4+w4AHgzwuTRRQwQjwEKhphqCmf8ZI1Mwj6HzlPhl4PrunjuI17Eo71QJcU+2vwbfumoMh6m2FtOL/C5xVLDCG8zpFbOomVL0Hg0FIw5w28eAXMAg8OmL81V6nlkx+FIxahqt6lgx3AE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 08:18, Kefeng Wang wrote:
> If the pte_protnone() is true, we could avoid unnecessary struct page
> accessing and reduce cache footprint when scanning page tables for prot
> numa, there was a similar change before, see more commit a818f5363a0e
> ("autonuma: reduce cache footprint when scanning page tables").
> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


