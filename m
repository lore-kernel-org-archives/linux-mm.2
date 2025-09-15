Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79CF4CAC58F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 07:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A02008E0011; Mon, 15 Sep 2025 03:52:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B2468E0001; Mon, 15 Sep 2025 03:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87A2F8E0011; Mon, 15 Sep 2025 03:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F1FC8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:52:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1F60185BB7
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:52:51 +0000 (UTC)
X-FDA: 83890718142.18.9DBBB83
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id D4D4F140006
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:52:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YV91iMD5;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757922769;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5hnJTCaTToDURvtPvY3esH87qI6LmybrTifTS7w99hQ=;
	b=P23gSB0LTHAiDHPUomZbdg1/8dSEe+yDreYEbBhJ/mfYXmkj+KhnP0hJBREN/rrbN9osS+
	2AZuhupMQ/4MqU88ZatIz7TZ3P9jUX1m+xAjbimnc6Vg7/NZD+0SlJy8L2TQp40Bq2yRZE
	nI5AF4HIZ+MXdUmMwODlXa1cbx1kEsc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757922769; a=rsa-sha256;
	cv=none;
	b=5ojc94MqEOHW321cjVGLvUqGYYqbW97njONsPFfTyKQ43FAvn7Lw3UCSi/vnIxwjkQfaBN
	UKLl0y07M8g0R1NnoY6r9lCspuAknQYLHJ5ORvpWDxmRi54gNi5xehmWj15TkxSC6Ulpvk
	wgq/ayp4elQ6hUBu/HISHYAwONfLngA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YV91iMD5;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-62f125e5303so2142121a12.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 00:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757922767; x=1758527567; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5hnJTCaTToDURvtPvY3esH87qI6LmybrTifTS7w99hQ=;
        b=YV91iMD5QI2P1/98Td7LzesxzC7Ktzi5MmDkjw154gXCcPIMS7qc66GgeW6x0R4ZIj
         XCGEXhSdEp+yNI2M7Fb7Tmi5SBM554XWFwjlgp/Kupk0UeyFkrz/4laCQH/tKWRk+DQi
         c3RxpGjrgFHmM4wUvV3R1kHYHBrS8XJpohNLJxM4b9Weu0Dcm5LXJ1r1wtGHdyObeQQt
         1bOGOS13oPn6ARzHjPWHZLIJ7HqTG4H7sfzbiNAIZ40/S8SE5cgW01xWkGc3rckiTBL7
         nb/aDA182vfF1B4d/CCAc90+T3GY71v/wLeOprbp8RcnkQTvmIZZbLCw35f0W4lEVSXe
         LEjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757922767; x=1758527567;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5hnJTCaTToDURvtPvY3esH87qI6LmybrTifTS7w99hQ=;
        b=kbtspRvd3mwm4NTt2gVTZS+Kk0tL+i94k2IQ+VR5QazNaSjoZkst31XoMPY7WzVzK6
         q+tQUPVdiFROfMUIsKsKuUAj7WBfqy+BgsDRNr/GwwNeW8BUnBl7j8GmZkiEdst0JfoG
         3hMWieAWjtbb6mkMTUZEoRn/GjnBFcZ5wRLA3TKjJtDEOGE7fcMRE4aFkiSptKaXQxuH
         PJfl9AGHs7d6QDpSArG/CAWE1eOIKZv6O7jZf6BBvqgfjG+iyQHrq1MywNOW8yhF5GHE
         4M2lfufcFOuPbIhJCgSJOrU4ioctOtZrbzbGcIj4b7+fABOfXTMXvjvHG+29N3QG1IaW
         Tu8A==
X-Forwarded-Encrypted: i=1; AJvYcCWJNhbK1BXe3SyEdKcOXdRIN8qncwaZOPcfg9SZ05DL9yrp6xpJSUL0D2/XxVY86edDBUa7WNRkHg==@kvack.org
X-Gm-Message-State: AOJu0YxZELcvHyb/YOeWd/e7so7PdxwsALPUoPQIMYP0IocGVCHTx0ZM
	D6EAocDNVfTydaXh0bpFVTJSYavN2PzDyAntoUtUNQVj9t7XygiPeZ8R
X-Gm-Gg: ASbGncuhb2B+0cNLIgtxkCnn9LNzncxXziNHoUd6Dy6Up2+NohPCYf8FJ7kZiOeb0eI
	t98wZBKmDP/vVGu9EVXtacWv5XkmvAojyty24zaRV23w/GW+4q9jxUHoOWYBkKtC/C3+SzZpbwS
	s35YzcTnH+wM2eKuTWKnB1AzFGdc33SWpUlHW5MvinXJL3J49aNrfq5IAKWfxG+yLrFuQ3ve0se
	1KxdhvNhdm1gt7Ktq/+LJVKWLNoE6/pHvw4nxNbjYlHgsScOP6UtnnHxFvQkndvGuF+C0xTLE6w
	1BXpDRgyhd5rAG2cgtTT0yfiKjt7U6wBXoRApi/Vsb8rhkUOQtuBbC/+t7x4Di4mxqPcVfMjOEl
	aR1XgAJWE/q5d2j6mdn8zlA==
X-Google-Smtp-Source: AGHT+IFR5aTDqd8h1+SCUtxeUI+UM0TiVJ/KbpZ41Tpcsrb+0x/UyaCmJ9qIU31ZArMtCPDzmPpUjA==
X-Received: by 2002:a05:6402:1d49:b0:62f:3531:d905 with SMTP id 4fb4d7f45d1cf-62f3531dcb2mr3091728a12.0.1757922767172;
        Mon, 15 Sep 2025 00:52:47 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62efb5b8b0asm5178091a12.20.2025.09.15.00.52.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Sep 2025 00:52:46 -0700 (PDT)
Date: Mon, 15 Sep 2025 07:52:46 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org, chengming.zhou@linux.dev, ryan.roberts@arm.com,
	baohua@kernel.org, xu.xin16@zte.com.cn, dev.jain@arm.com,
	npache@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
Message-ID: <20250915075246.r6w7rm2p222leslg@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250914000026.17986-1-richard.weiyang@gmail.com>
 <3a1adf4c-9931-4cdb-a024-37c856b1702b@linux.dev>
 <20250915014738.slkw4nwihb4aavas@master>
 <e368ffcc-0de9-4c8c-8e9c-6cbf8cdd22ee@redhat.com>
 <20250915074231.xnjzoqozqihqetwm@master>
 <107d29f2-9474-4e58-8dd1-a1e8b552f4f7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <107d29f2-9474-4e58-8dd1-a1e8b552f4f7@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D4D4F140006
X-Stat-Signature: 7stojindpn8fotaxrrxha1dhuf13dhor
X-Rspam-User: 
X-HE-Tag: 1757922768-222920
X-HE-Meta: U2FsdGVkX1+WlfNCabadvu5JfLX8q3MS4lDmWNKPBBEhyLV1AAk4pqLPtKr5lZg2sEXU6eNUUmDA8IQCIhH8qQX7/7r76k1pOMJas6WJZ1eIGlRizelpsEurR7XAF6pG74ajUEGH77W9fnPeoKyz+ykHiky1U3c9TBtQt0nCsHO6DbQ5C5MGtf+I2km2PeQJcTF6mlVkqX0BmjUou13PsFIVRTn7bUAqJZ5IzdfpBPtb8sDM/WKiL9zU5awlg9AeU1529fpJRYWoVN7ihRkuoTgzbZT7urG7sO94yBsipxlSMOIXfIkH8G+AdX1MGOIrWAbwDkRitfNihifScTcf1eDHMTosQlAXv5wVmQDmUS4hzIhlQRH82gjruJefVYsq4N5hav9sOzbk7s9ifhcqdFrk/5Gsfoo9V8KbD1cZ5et/R9rKoNJHEcsHzi3vYIIfyRfivVWEhP5rEg+mqHvtn9eJ6DnIGvR7n1d1c3TLhzjcLUshQtWz6w2sj8+1aUo6zsZDsfqx4kGJKlQIF7kjiABNH4ybCDD2qin05VT2ZfO0VRcGwfE3lwqJVc6uf5ZUnxAEjIAUfhEpWVmjJfheYASYm7Pa/4u1OrR8IHNdqN81Lhv/MqCO5kND7io8toHRlxZ7SL5IeWXWUULKDSxjwVpxI6W7wFiwBELGajU6xgRxzjupNeQh3uK84uy7pwvtu+EqutNsj9q+EChBvJyVGTGRBIjIWZpwupznmhrWlBiP8h0Dk9/9gqISE7DDjRjP/HFvw/yg84mdHQXajbXomWTVJZTs1N9Fplh0lxTaj70Qxlh558xprbNoa/N349s6MVrwnDFx4hlg+am9Hulmo5VUNns9G6Z1cBniml0rZMW+E50jfvyacCknzLZcq49gHi+lbMWL7I9eJlxC1SxCiGA/kh5vW5yKkAcOJPJX7wet5cKVq7xEbc4vFS/pRNvZ/6I0ir1F5SKFOHcq8zn
 +nW8sdgt
 ZBq6kj8SDjgpO7iwOvb7n3FlSCurg1bD2H+mqd2cP4EQ/gCoI+pHuWxG3iwNDPoJFfxi99+qwW0y7CKgXE7G9McQ2SLXo1c93hIPM5E10V0eGYFGxDiyh2cnzOT3yGiagKwu+J7T0hj9e388a6MyswYK4nIOscUZRIHjwX4i2K85D6HPqqDriQ9TDwYwB51jKJbJFT+/cWZDalIDsm9typSDAR1z9hdn5cbTuPtHFdifRF6O13LRS91/b0MuOlNzBo0ZZXbaoT57B3FpXFV3guX7vz+Ao5Z09bP2Hl6jHufda5U8ARHz5sDNmgYg0cngDn0o6jvE1/gQa+bv+5cGkXM0eTZjxdlinbiaOHbanyfBmQ+bHxDPszY4eTukQgUVqKifMOuTsApR+xZ6CcWl/Cppg9yblBzkp6MymE/1YOsNt1jJ9D1BO248i5I4LICGhfSXXT3gvNR0zqcM6c5Gsk1qDaPRKgn345/mCqSEYjTtNuSEPBjBKyC8j2UbJDyroUH9A2+raGSkk1YIUCK5Hk4eigZmY/49bGrKxvkLJ02JeEamCcilz5BrqQWCxat0vmX4JnwUzZoVaAydhS3zmk5L5hJgZP8+9LxHNPxhwr1Sxm1FLq7JNh1A6aDEWYRb8cK5AV1kpvE31aDDSLP50S7edJBwQB+KpuapT5qWzegslQztBoun9XmeTNNPQ5flCOKYyMabs0lpnQlqUNeWkzJAbv7HQcsKqUnZvsHExScHc9hrLYVLq1fGlefdZmxJ4ewU3zTtm0W4MHmw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 09:48:55AM +0200, David Hildenbrand wrote:
>On 15.09.25 09:42, Wei Yang wrote:
>> On Mon, Sep 15, 2025 at 09:32:27AM +0200, David Hildenbrand wrote:
>> > On 15.09.25 03:47, Wei Yang wrote:
>> > > On Sun, Sep 14, 2025 at 01:05:48PM +0800, Lance Yang wrote:
>> > > > Hi Wei,
>> > > > 
>> > > > On 2025/9/14 08:00, Wei Yang wrote:
>> > > > > When using mm_slot in ksm/khugepaged, there is code snip like:
>> > > > > 
>> > > > > 	slot = mm_slot_lookup(mm_slots_hash, mm);
>> > > > > 	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>> > > > > 	if (mm_slot && ..) {
>> > > > > 	}
>> > > > > 
>> > > > > This is only valid when mm_slot is the first element of its wrapper
>> > > > > structure, otherwise a NULL slot would converted to a mm_slot with
>> > > > > negative value. And current code thinks it is valid and continue.
>> > > > > 
>> > > > > Current code works since mm_slot is the first element, but make sure it
>> > > > > won't be disturbed.
>> > > > 
>> > > > Good catch! That's indeed quite brittle ;)
>> > > > 
>> > > > Just one nit below.
>> > > > 
>> > > > > 
>> > > > > Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> > > > > ---
>> > > > >     mm/khugepaged.c | 5 ++++-
>> > > > >     mm/ksm.c        | 5 ++++-
>> > > > >     2 files changed, 8 insertions(+), 2 deletions(-)
>> > > > > 
>> > > > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> > > > > index af5f5c80fe4e..668e74ad33b7 100644
>> > > > > --- a/mm/khugepaged.c
>> > > > > +++ b/mm/khugepaged.c
>> > > > > @@ -108,7 +108,7 @@ struct collapse_control {
>> > > > >      * @slot: hash lookup from mm to mm_slot
>> > > > >      */
>> > > > >     struct khugepaged_mm_slot {
>> > > > > -	struct mm_slot slot;
>> > > > > +	struct mm_slot slot;	/* keep it the first element */
>> > > > >     };
>> > > > >     /**
>> > > > > @@ -2382,6 +2382,9 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>> > > > >     	struct vm_area_struct *vma;
>> > > > >     	int progress = 0;
>> > > > > +	BUILD_BUG_ON_MSG(mm_slot_entry(NULL, struct khugepaged_mm_slot, slot),
>> > > > > +			"slot should be the first element");
>> > > > > +
>> > > > 
>> > > > I wonder if this BUILD_BUG_ON_MSG() in khugepaged_scan_mm_slot() would
>> > > > be better placed in khugepaged_init(), like you did in ksm_init()?
>> > > 
>> > > khugepaged_mm_slot is defined in khugepaged.c, maybe we don't want to export
>> > > it.
>> > > 
>> > 
>> > We should probably just use a static_assert right nxt to the struct and make
>> > sure that offsetof(struct khugepaged_mm_slot, slot) == 0 ?
>> > 
>> 
>> I am ok with this, but Dev suggest to fix in the code.
>> 
>> Hmm... both works to me.
>
>Right, if it can just be made working without requiring it to be the first
>entry, we should do that instead.
>

Got it, thanks.

>-- 
>Cheers
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me

