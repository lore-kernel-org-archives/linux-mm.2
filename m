Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90EF4CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 07:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6DF68E0002; Fri, 12 Sep 2025 03:31:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45848E0001; Fri, 12 Sep 2025 03:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0D218E0002; Fri, 12 Sep 2025 03:31:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD7088E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:31:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8D7571DF64A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:31:12 +0000 (UTC)
X-FDA: 83879777184.13.1A5C73F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0DD901A000C
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:31:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XPJ+rlWO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757662270; a=rsa-sha256;
	cv=none;
	b=Ax7wmzana8uwJwZgHcGh5Di3i/rhTdvkY9jBidnCwKjVB0HzD1lRT7m+S4FUUwp9p8dlup
	pgm9LDJ1jfOP8/b57ihkfuHgF0hHJRURjeu2bWSG0RvJjrJ2KANf9uzeS6GXaxcJh19tgO
	IJaRCpEXeJZnppPEtmLI3/28KGYTvf4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XPJ+rlWO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757662270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WmiBqy0L2WUHv+kOIrvdhPLSX42K2Mcyiy9ePRV90Tg=;
	b=ZiwGOaZWo38sNyVH71f6Ws2UUNIy4s/6Y4INrHh72eFeCPaZWEj96vWP/6td6rsnVPm6Ut
	LcQ1shCOqXC3nktoqX+rDQviSWlKq6njHNl7TMi3WSlNyl0ouNYDaNr4NxC6JCb/5W57hj
	19vHlduidC7Ol+CzVIX2ijK5O/Uwj3s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757662269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WmiBqy0L2WUHv+kOIrvdhPLSX42K2Mcyiy9ePRV90Tg=;
	b=XPJ+rlWO6TvKTU+lzNlPF00TRxhdv4rUjNnjcO1xbBvXtwoe0J3PD1KSa+EnJOBJrX5O+q
	M9qvbUkcxVckGDomnYMfGnvqkRWH3sW1f31+53ZVSQ4Yyc4Eaj5IcYeEbLoxZVs1YwVdck
	ZpfmhKSCVNukc1/gQc5WoopDlCpU2nQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-306-J3xBjsacPQ6lve9D9gKAAg-1; Fri, 12 Sep 2025 03:31:07 -0400
X-MC-Unique: J3xBjsacPQ6lve9D9gKAAg-1
X-Mimecast-MFC-AGG-ID: J3xBjsacPQ6lve9D9gKAAg_1757662266
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3e2055ce94bso1121674f8f.2
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 00:31:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757662266; x=1758267066;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WmiBqy0L2WUHv+kOIrvdhPLSX42K2Mcyiy9ePRV90Tg=;
        b=KqfzGaaLD4l6SZVmODRby2WE9gxHWQi/daSilU5XqPo10ItxMImVUlRw/GGqNf9RJ8
         3fdultUKBbpD/Q3aI70weKGyX7VlF2WMHwppW5Bq7NERWq2zESu5CN+Hfg3v6gQcNlLB
         yRGuid0HoM/zHLmGBJ2yR/rx6JkC8xhEcW+bwjgY6ltSUQw/Mma1JbIq2rI75jwXIjfP
         lzvg4Pv3bIDnP94T1s0TxZeQnQHm68G33ZF8GyB8987GpsyUkHPUmA/5nqKJyFsJswFh
         ELCCHDX17+7E69mjkfFSclaBQ22zJL2NXtqlLxqknsU0nOG1L9gTXZLjIc4WTdTukmBM
         TDsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqFXWeBu1r6bGs1x7lPbXEt44wJ1Y96DONPXSdg7OehLY9ojv9NzdL4V247esTfwQUGEOOKpfcbA==@kvack.org
X-Gm-Message-State: AOJu0YzCnKO6SnglMZpQdaKpEJWdyuSmPrGr7qrT7rwGQxRgJI/otj1m
	MNw8BZfPL2HrN+cR/4jk+lUqHqy5I2BR4loA7UGMubybt+ISWkCNDAqIdhjP4MrNo5ztupmRuR+
	B7DsxN/XMTUgSzVXD0eLnCM+p3Y3Qe4whgTNXuWUH7ypYaaGORtt8
X-Gm-Gg: ASbGncuBSxjIQUzm4J1KrM19StlUYjSxmdzDfOR65mhliWwqOtKEthm75L3rf8qOpXb
	tsYNlBVHLCxwdlkBgefy1azHjttZkep/6wI9+ZcVNYk7NquKr9/ijw9oYKencxeKSn8jYNS5Imw
	lYgKkm99wzkbFvJV6JE6aEmt0s/1iW/GeKs3iDGbZwZWervat4wv/l3OXTqP/lYEq5axKA9rW5x
	BFZXazn+GgMtyJArVPsogiZ/FEIOmedkNfpuLnlbKWqfhURp2zLQvRQALLfxOmjKJ1YR6BZfFhZ
	3Rd+YSWrW6YKZ5QWBRVdYD9oJ4Wtelqq+s9tkd9E5OAulzhGvS/nC1XUj3dm4LkglQEkpR59lIw
	Pc/DctfsAPlqG4t6boOr92uHBHPCEU4ZuPhly8lheBg6ZGew9wPXAfsXDjoKS8XvXzRU=
X-Received: by 2002:a5d:5d02:0:b0:3e7:5e19:5ec3 with SMTP id ffacd0b85a97d-3e765a2dd2amr1433340f8f.41.1757662266420;
        Fri, 12 Sep 2025 00:31:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGvNIXBKO3q6si7Ysd4vKlJR6P6Qcpb2+dcH0QDR1TDVJzzqtFB6D3wBWW/HUyK+eg3VSV32A==
X-Received: by 2002:a5d:5d02:0:b0:3e7:5e19:5ec3 with SMTP id ffacd0b85a97d-3e765a2dd2amr1433313f8f.41.1757662265971;
        Fri, 12 Sep 2025 00:31:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607770c2sm5412795f8f.8.2025.09.12.00.31.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 00:31:05 -0700 (PDT)
Message-ID: <eb6e18c0-533f-4e77-a56f-60ab8cacc369@redhat.com>
Date: Fri, 12 Sep 2025 09:31:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: fix copy_hugetlb_page_range() to use
 ->pt_share_count
To: jane.chu@oracle.com, harry.yoo@oracle.com, osalvador@suse.de,
 liushixin2@huawei.com, muchun.song@linux.dev, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250909184357.569259-1-jane.chu@oracle.com>
 <e9b34151-0879-4900-af9f-2ce0dbb678a6@redhat.com>
 <2fa7aa11-6521-40f3-9934-aba275154ca2@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <2fa7aa11-6521-40f3-9934-aba275154ca2@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dpdETwErHN30xAQX2crPhemGgy-3iRutENE8s6brasM_1757662266
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0DD901A000C
X-Stat-Signature: xoapq1gb4uumdcj3ggfbhfjtjyxczkxc
X-Rspam-User: 
X-HE-Tag: 1757662269-784728
X-HE-Meta: U2FsdGVkX19JC22BgVynDQ+H7l2LTGqrzSQQnprhxydoQvJiplgeB9OZhP52xXTeQDc1//hX8g4FZ1bAh/RMV6JX5CtsTUoSTb4ALreqg/6/xeiE0NZoj39qq/DCnFuFdtK+jMfZYBbykn2ahv23rE4NBpXrBTbPwiikm57WDsmPbgVuSfC8rIL0n/Ha/2/qtLz68yi4S8j5OXREb10MNNZBMKXYZS+W8rj9DJzTRqWdQxzOvMZukPnZue9qnI5NFc99sC55ItuHEZJwsEVbO1+8mdatzlFYOXzp9vfYSKkOyr128RPhOFP2Jpu4Kiuwi9mn++hwkAbgawJkc4275YY6h5RH6tqrZvP2EPF29+972yWg6QlZIkH7pkddw6JUfKTDuTtqhaM0OLx+aNhmrzpq1c+shfdT6sAFTFvILPltbrpy3U6yppj6P3gf9z7b+EFOG9DZGfe7x0x1NLqCUPHu7W2nnH0Vc91EIpOLmJvR++K5PUKgkr1Ci+p/B3QZ9Md8ZO/W1hgO1qUVHsCcP2gXozkSyz1KAMfdO+xoJ5p+EySL7xDRcHnaO4PP9wQ+6ko0fhHidrMAYtkumtTJZteLirvhfUgyqqGa4S3inmRy269b9Spk0/GkSOugtSSObzFjCGcE4WHmMzlpANQAbC/HYyHodZeuIhTByiDmv0YQ9/rNI/CYhbJD66HkZ+uksNelzWHWwU6kQsQmZvoCuKZ54QtWhCWfoQ9tf/EiNe5OJ1DDlMoGicCeROax5KZnEe2djf0J84Olmxk8QJ4+IY/kCCq/k/21SOj8QXrAZpuL2iPshrlJ/EWghOCrlsMRofLZ7DEbeR3AWx4XQZnxuoV8TyAw8O6QqqRqoRYLCqbzb9PYO4jpC67pQ/bZ7gjY0kAubJsZ828BIxorld/cJCFcLiwdVa94mFN8ZT94tuZjwXLa6L/HWNMpcslRXysjVSp9L/crv3IF3SZryoF
 Pfvgw7XJ
 7hzVowVgBiEUSfcgpObpcAs/dvwFpRhkbYgJHuvEGsVfOZRT6xUyIOT5/n3JOPVgp5o3RLQ+DAgYElzk8rJaFoftOJCrVfDPePfyAvZbKeDsCaLjIzxtXxnI1vBcaVNbrCwJAgccus8oSlEDtUeyUNgGWDN3Vzxqk9Vaz5Dj2yBDdmviMEr/7bzByhVDvPl7be4PhWNGWp3ptZ+xcvhBxXMgPeBHkg1YqCvOPu6DHzDkI1MR0/soHCWQOndrtue6eCt5t0BYAZmNNrcIrCKcvK0Cv8CC/ofauMwszOQLAuyLZX57zolB3CJBRr2DN5fUT8P8eLNC1mYIZZrODCftGyb1VUGWCtZIOPw7lVLblzJvCNpgkX08ZHUdhNCiP4hheuYy9v3ZM2JPg7k6oyLvryoKN9TvBPFffZsTy6uY6e+Kc1eIkIm5OZUWSmyMunT3IfDHd9GgCnbKI9J2i2Z6gVvdIQxRA2h64eM8DyDale6EwtIJSAK+mhD5bVi5rvz3eSVU58wQb9TutQ98=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.09.25 21:54, jane.chu@oracle.com wrote:
> 
> On 9/9/2025 11:45 PM, David Hildenbrand wrote:
> [..]
>>> -        /*
>>> -         * If the pagetables are shared don't copy or take references.
>>> -         *
>>> -         * dst_pte == src_pte is the common case of src/dest sharing.
>>> -         * However, src could have 'unshared' and dst shares with
>>> -         * another vma. So page_count of ptep page is checked instead
>>> -         * to reliably determine whether pte is shared.
>>> -         */
>>> -        if (page_count(virt_to_page(dst_pte)) > 1) {
>>> +#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
>>> +        /* If the pagetables are shared don't copy or take
>>> references. */
>>
>> Why remove so much of the original comment?
> 
> Because, this part of checking has already advanced from the "dst_pte ==
> src_pte" to "page_count() > 1" to ->pt_share_count > 0, it seems cleaner
> to just keep an one liner comment.
> That said, if you feel the comments should be kept, I'd be happy to
> restore them with a bit revision.

Well, the comment explains why checking the pte pointers is insufficient 
and why there is a corner case where the pointers differ but we still 
want to unshare. :)

But yeah, I agree that reading the code it's clear: if dst is already 
shared, just don't do anything.

I would probably rephrase the comment to something simpler like

"/* If the pagetables are shared, there is nothing to do. */

If you resend, please add a comment to the patch description like "While 
at it, simplify the comment, the details are not actually relevant anymore".

-- 
Cheers

David / dhildenb


