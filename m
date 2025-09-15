Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1E89CAC58E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 09:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57A5B8E000C; Mon, 15 Sep 2025 05:07:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 550D98E0001; Mon, 15 Sep 2025 05:07:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 467428E000C; Mon, 15 Sep 2025 05:07:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3246A8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:07:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E58F91604EE
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:07:09 +0000 (UTC)
X-FDA: 83890905378.25.12532F1
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id E849E140005
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:07:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ap9BH66u;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757927228;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=02CsEXHhyvWGZjcZbX0sG+kkK7eMyznM+bDIjoFiLok=;
	b=23iLg4y7rA8zJyOAFxqjvZqiRe6OdQR5h5HCVjFskYBjqUEj2M3qMxJhUdIgO80k2r5L7k
	36aOxn/4JeHheuLsTNclqCJw9MoZ9aaXlZOzZR/ME0Xf5SXpRUUlHck09y6/u0yMGnsGqm
	OnD6zasURkqfyu+5huhU+rLWNCul0n0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ap9BH66u;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757927228; a=rsa-sha256;
	cv=none;
	b=5FK8w7KaGPdZamjyGHlnETAj7tUP25O3boZ8mC/he105V2iwMzNv+L4TVviDiw1NCJ6CHx
	0kXgGS0kyzV7Wrnis+UYQoEAsu+5IMIomYiYPGnjjULxX2RS0u1N2f7pR/bIylvcay5D9N
	k5FL5iFxJJn6dIHX5Vgxk15Vk/NsMmU=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-62f1987d44aso2203378a12.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 02:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757927225; x=1758532025; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=02CsEXHhyvWGZjcZbX0sG+kkK7eMyznM+bDIjoFiLok=;
        b=ap9BH66uBiuhev5nqDbNEpbHQh5ewayPTmGxevhtz9X2+RsFrvvgyEg5UOxZG5LcMx
         JK12ZPlL//SHh/Mtd7lGIAascUq/mxK07+aV6s8Qil6yRbUU32y/90ohBPnAWGEeS0Tu
         LTtoxU2hFelQfLsd9Nk0WSZrhwu5bGNPxPvNL22U5AiES+QMYmr2YzPWvLVwpoe6cox8
         ykQS0huQRvMhZFeVaoLOvQsCzD0ld+83345hG0/PHT93QOxWpu75sJE7IbdxXvPOd5cm
         kSpX/CFi4LHnzesYdN2X3AeKXhlv8BWrommHypQnd0aXE0XJx3oJolF+GFy7yXoDaX7G
         wqGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757927225; x=1758532025;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=02CsEXHhyvWGZjcZbX0sG+kkK7eMyznM+bDIjoFiLok=;
        b=hqw8Q0Nhv8m3oAZdy23dzDPuoXQbi1BBXNWaHDm2BrPJVPIR6sAxFhu7NO5gHzfdkp
         6hs+E79F7TtH+FkyyVIvrXeEkldWrvOVNfh0eglAQFlJRnhBYVi4OjM8eSjrRk7w33wd
         XjrcAiCucmCclZRNcEIIKTk79O3hHUJ9tsO/7rvUZjJDbu2KUPBExyM+eoIHW8nInWtg
         k9oFeWjP7qRQ8ho2OgDyihmW6vWfKpO+IgvEYD5HGKL2sWgHqWbbmaSDOk+xZwe+fwKm
         BWcP/XRZ2dY2GwnELG8kmb5nQByRZ4o6TIyQJ7SbTzwjfjVxA0XbSfysNRddrVQ8Qk7p
         AQdg==
X-Forwarded-Encrypted: i=1; AJvYcCU76dBZ0ZSpctrBo5CF0iIXBc35JzW0G5sRygPlPK2xVi2jF3qqlGiUNq43tJNXpQfimDpPPV6Rbw==@kvack.org
X-Gm-Message-State: AOJu0YzR5IRYsIYaNMsLJFwGXovb05ytOf4obld5rVNElTm3shwjfdBC
	s/OZxP9qkfDuNHy3tL8M1mBaOPH/4oZCzT2UYX0TzGKFFNj5zU6/6Fr8
X-Gm-Gg: ASbGncsUb2zGKDY5qBE+DjqQbyhZxsTtzpnD3rPOpkI06BhueuW59Mlu89UzlewNpY4
	4bumlxPuqqY6JtY8WpZsuuW9zyChv4LmgPVNKyQfSMH17enGofvZm4hCWOnj3U/wi3hvMwUB/NT
	nhCuYyipv6Kf5ZzB2vb6xwswIYUVuGsj60VpncLzYmAc8btvQkx9t9IZtdzR9HdI/MtNVmPUHsD
	h6OPJhGa7la7lzm45pZU5uPKHikLCk9dST/dTnQyZVmgRmI3ZxhLjqb6+lxd3LzZ/awiY7v1LVs
	SCNu19KJITwe9LatUA3SJbEFB5V2XGJHyNJSQf0BgIEEOIstDwiVylXdcL/VUUtMxK1bq4nTWoV
	kqqyh4yJwOD7MWw6DOpKLUbrSP0nwkZQs+spwvCzEkB4=
X-Google-Smtp-Source: AGHT+IEMPr3U3aNURQFRNDrRi5ggxRF07y1aJx8PzJa2JuY7eSdS4eI9JvY2k9FlVUGmBJpDxnFX2Q==
X-Received: by 2002:a05:6402:24d2:b0:62c:5e9e:3ef2 with SMTP id 4fb4d7f45d1cf-62ed8410e58mr9721722a12.18.1757927224704;
        Mon, 15 Sep 2025 02:07:04 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62f41fd18a1sm1496990a12.9.2025.09.15.02.07.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Sep 2025 02:07:04 -0700 (PDT)
Date: Mon, 15 Sep 2025 09:07:03 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, akpm@linux-foundation.org,
	chengming.zhou@linux.dev, npache@redhat.com, ryan.roberts@arm.com,
	xu.xin16@zte.com.cn, baohua@kernel.org, Liam.Howlett@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
Message-ID: <20250915090703.le7zutd7yrurij4b@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250914000026.17986-1-richard.weiyang@gmail.com>
 <ae30fc02-c573-46bc-a5f6-935f256149e2@arm.com>
 <cf5d6ff7-faa4-469e-9e32-b90c75b8194f@linux.dev>
 <463716f5-be12-4d78-9432-779e3f11460c@arm.com>
 <62680957-e9aa-40ad-893d-885bd01e1117@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62680957-e9aa-40ad-893d-885bd01e1117@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E849E140005
X-Stat-Signature: fwan3ey6a3pqpfxr9uunt7neni3z3144
X-HE-Tag: 1757927227-698525
X-HE-Meta: U2FsdGVkX18xNFWc+OclE0dG7NMgJwywyZ9jXXrJHRECoxgX89+K4HdIP5IsN1wN3IWCsvFruFu8V8Lnw7KByl2tWaRE6gBSRXXxnK9I1LCVhB1wLZzGz4VlBWOkIsZoTTR2l/9PNRVr7o6M12GYW0hK4y44TJRaspgUPn609V9mFQoAFThJucgkcBzJ6m+dF1LE+1CnSjKytT92ctpYXsvNAK9Zsg7yjdXEnU+6sEkiT1gpBM7CwjQjHzPPe5AjVB4o7zG2Hujj5Khwyu2c6bINAaOLov0O/eYlkdkHS8WcFx7VRzIA5mpGZmKJ07RrfFRnsSbF1S3Iqe7bh7A6kN7Ze7P5uEm1cn8HcJOnAKcaQ4ugt8UhZvD4/KDCz6s32jKGrtQ6MHhtqqw2PvU8BApOMHrJ3kJiqM3BT8eZU1eVTxp7YXS936HLK7Z6UieE0h535q8JF17tpuYNsHbAD6i/bfjZzmgyyiphSf0Q1L3yVLPi2xlJhn5rpZqRnXxDNU63cpOZVmR7x6nEx9hBPcPuWMpydqx8pNCwJr+DWFNVmr/vuscxjVpijCFOquZi7J0UqMGpC2erag9ahOuUGxcnudsmll49aPmnaYpVW6yVl8T9c/PLiYmQZkJAz1FSq29L/6ezAFW0du7h+BS7eKfz2I16qz5ya9zgyqX+Zg3/pyyAuxXS5uQQmVkVpu1+PZgRl/rwFUx+CrwK2+TA6S2habdT/uPLv0/miCLh5zFZ3D4IDQy5Ccs/0WdiO7QWCVk8EkB1qYJ+tCf6z4S9/nt+qA/yVqsP4U6/SgsEPUyImLhQAWjU8bgjBjzh5DKkpf8mD+RLhzLZpxxke64h4AssPPJLACTu1qXpxYeQNha70ThX8mHgGFNbGQfjOUnOLRT5fAwaPuhfQoE39pX9XjwfyAul3OtDR+Gfx+MzhVuJfiLGEoZfqnlNvJI1d8QaS5h8KEBPMLYQ6TUM1Jg
 vaWdEXAV
 BJFyFX0MtHyvMFoxcXtW1ZMzJ4InjILUwaF1v4ZEW3R2ifaOCxk2hA/Lzp1wsVt70KTp8fbCGjWc1dqXup4zJMFYN4YC6dBq+d0uKTQtcerdqeXNIbEEyxrX5bGwMbtZT71E5+SMB2dTRCx3+rylGDnex3+5pZUe4H9IDpjUo1ilvzu8WCN7DERcZAe1REZ05l1aZvONOOHDee8kiG7nY1G3vDUMkOfKZRAVWPYx4JwZ4PSvf8Tm7LFbeKD+bCtnGq6r5dmZiPDd1TlGs3FaeXPM7f6zO6ZmL3Mrmg6USmvNPPeSMh5pdthIevgaelVxB0J4cOB3oNrQEidTon5PMVvg5dgJPmUlOMWpX8nJkrWlArLWlv/gzzded41QAbSgIfcreDvpT/IcrH78i1lbSUnGP8vZZ9uxrvRuW0FcTz3+ojbJ9rTr8ahGVtVVZN+YJrxrY8a4E49xdfPnYncjx1M4BzPx81zbyynCHfRFpOUPiAClBgAQAEOWxbhWmZ97Bu5a72643hUZvU0o86VsyY5IZFggvotqgRsex13jC0tcs9CprtWnZIMVFKZedus9aXYNBsN1NSDGFwnoYAqEYvoraopenVbL3cTTnpXvIbxs38AHz7pLIhOOp17xKbutrORN41gp1/JSG6HhMVBEhEnhUd86tz4NHCiERj1w5cBGFX2dt02sTW5rk8sl8cP8KlrgWl3H0bOqhlB6LzTScxJ9nXMEkgP9h8Nd7ztN3ItCumra6VEm/jf/QLTczXF3nzzVypKLb8sRCuXrvJP9JJlMTMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 09:56:34AM +0200, David Hildenbrand wrote:
>On 14.09.25 09:29, Dev Jain wrote:
>> 
>> On 14/09/25 12:33 pm, Lance Yang wrote:
>> > 
>> > 
>> > On 2025/9/14 14:21, Dev Jain wrote:
>> > > 
>> > > On 14/09/25 5:30 am, Wei Yang wrote:
>> > > > When using mm_slot in ksm/khugepaged, there is code snip like:
>> > > > 
>> > > >        slot = mm_slot_lookup(mm_slots_hash, mm);
>> > > >        mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>> > > >        if (mm_slot && ..) {
>> > > >        }
>> > > > 
>> > > > This is only valid when mm_slot is the first element of its wrapper
>> > > > structure, otherwise a NULL slot would converted to a mm_slot with
>> > > > negative value. And current code thinks it is valid and continue.
>> > > 
>> > > Shouldn't you fix the code for the case when you can't find the slot
>> > > in the hashtable, i.e slot == NULL? Like, if (!slot) return.
>> > 
>> > Right. For khugepaged specifically, the slot == NULL case in
>> > __khugepaged_exit() (only user of mm_slot_lookup) should probably
>> > be treated as a kernel BUG for new.
>> > 
>> > But I'm not sure if the same logic applies to KSM ;)
>> 
>> I haven't seen the KSM analogue, but restricting the position of an element
>> 
>> in a struct to make the code work should imply that the code is wrong in
>> 
>> the first place :)
>
>I agree. If mm_slot_lookup() returns NULL we just just handle that cleanly like
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 6b40bdfd224c3..70a32d59d7d2f 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -488,11 +488,13 @@ void __khugepaged_exit(struct mm_struct *mm)
>        spin_lock(&khugepaged_mm_lock);
>        slot = mm_slot_lookup(mm_slots_hash, mm);
>-       mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
>-       if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
>-               hash_del(&slot->hash);
>-               list_del(&slot->mm_node);
>-               free = 1;
>+       if (slot) {
>+               mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
>+               if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {

Ok I got the plan.

One nit, we don't need to check mm_slot here, right?

>+                       hash_del(&slot->hash);
>+                       list_del(&slot->mm_node);
>+                       free = 1;
>+               }
>        }
>        spin_unlock(&khugepaged_mm_lock);
>
>If mm_slot_lookup() is not expected to ever return NULL, then a VM_WARN_ON_ONCE
>might be sufficient to document that this is guaranteed.
>
>IIUC, MMF_VM_HUGEPAGE might be set in __khugepaged_enter() in case
>
>(a) test_and_set_bit() succeeds
>
>but
>
>(b) mm_slot_alloc() fails
>
>In that case we could get NULL.
>
>
>It is rather weird to leave the flag set in case mm_slot_alloc() failed ...

Yes...

>
>-- 
>Cheers
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me

