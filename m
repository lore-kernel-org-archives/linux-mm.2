Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 392C9C98304
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 00:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22EE86B008C; Wed, 23 Sep 2026 20:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DFDC6B0092; Wed, 23 Sep 2026 20:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CED76B0093; Wed, 23 Sep 2026 20:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA82E6B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 20:14:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 79F0C1A018A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 00:14:45 +0000 (UTC)
X-FDA: 85246734930.05.0123264
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 027F3180003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 00:14:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UlkEXpSe;
	spf=pass (imf16.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790208883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Arg2o/O+mZYGRcJkQWOkHlb3811XT5pVkK165f7ivAA=;
	b=fTQmCJ66hbqDtWVm/CnJjsXs1fcnZgiS4UYbi5Vu6hxktK7npBO6mAemSUhLUIC8yIUqhI
	iE+o2QWlNX60v4hUbP87GnyQLqQly65xbKpfAlDJsg+6Ht2Xfz7zXlJUE86lS3xOBW99Uh
	Ha2dbKtXys/mnve5IAc0df1YOPICbf8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UlkEXpSe;
	spf=pass (imf16.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790208883;
	b=kFmJbTKZnE8eLb8WyBCiMnK1AdL2MH1t6w3GBw1beh7nE3NLRjGwhNNahbi6wBGWgjsHen
	4Z9Ghv/TK5Dm8KQagJ0RxpYfVoYbu1exsZOg/Km1pBD97YnFT7ZhYA7y/SCEHb8Qf3dSCg
	5xYdlX5caaGPMS4sh5h8nqThK/HqF5Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790208882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Arg2o/O+mZYGRcJkQWOkHlb3811XT5pVkK165f7ivAA=;
	b=UlkEXpSe2r7qu6cP/zgHrpLu1+wX1GFQSpS1YRb7fg1guexESfyStDod+j7bhrX6TA+oIY
	LuArFhmPQoy7+TscPPEW38IfRAtXUM7/MtqfI9NGO+RAhpP4nFmpv0OVGk7Yie9atQiFSx
	TLk3pO2zw5nFhpVtjBvUxkBHixTJqQ4=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-4nT1tYfbMLaXc-bTVcUOug-1; Wed, 23 Sep 2026 20:14:39 -0400
X-MC-Unique: 4nT1tYfbMLaXc-bTVcUOug-1
X-Mimecast-MFC-AGG-ID: 4nT1tYfbMLaXc-bTVcUOug_1790208878
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-3a58fef21b3so5794331fa.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:14:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790208877; x=1790813677;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Arg2o/O+mZYGRcJkQWOkHlb3811XT5pVkK165f7ivAA=;
        b=xoz8nxieFrpr12OsF5JiaIXIcnUMIieHgUsjXWWXvUFRbAs8RWW+8wAXhwrCgrH7ss
         dbhgSX4a42RnXzGCSd7PsvQ9FErDB3NXb0sBRuqCqkEoRDWxYIhhjHRkWtXE9aTHplgt
         DlmxGuQ8AAZfDT2IlGQqYwWlmjvfn76xpzPBBBA1NVmUdDuXqQGCEvmCQj6UHIvFb2UM
         EpdlVlJhFXqoI6jxv90fGkKP7PbrfGSlBpEyRK1AtwGV1WYVjmiE7k+py434aC8MHoiT
         JtjPLJ1RYbgg4WrbSqd/ZAvL/rSFjKSwebywrneMw9uV3/5/gok3l5oe5hsEiWTbMD3u
         besw==
X-Gm-Message-State: AFuF++nQBE0Hk80+d+wuW428gqgYdDACH8Px70jRYtOi4ubkH7/1NKEV
	+s4Q0cq7UBpTig4pRiF/VQPLudKcLbJKp+U7H2Uk5sSBhpzQ6hlL113acLNLEfeRcb45fUYZMVi
	c8o7Z689J+RNZsda0TVEIrgyn8KZhjj7ZXqOryZn5vP5aONNfs34=
X-Gm-Gg: AYBFou3Gb9HIBIQWUZDEV40130b682Zv+39d8wnr+FA5CsppXcPd6wyO+UzG8xziSMr
	d6I2EBifP5Y0fsooekA7PrkSB170coKcR9OcNleajV2enSEP6tIoBPJhDn4AoEmOOvVluPpUvSB
	iRcRo0KCAaIpC4D5I+6tbCI5igZkdR4YlVlCkLMQ+CtNoG7f7Cst+p/2atHFe615EwND5RPf0Se
	xf533OtUGpNh/Uf/jcHXsNyNS4UtKp8QY5Wv3omvROjkJ09CA6q8+L9FIdWLEgts0NqhUyH33Yf
	HqT/Vk5uqi0vL3zL2GgnZeWDSLWQB66v/RhtRDI0Dn3wo+ufO7q7UOmkHCzgKmb/b1rjXJ6vpw5
	nn2Obmho2VOOQHDTqp2IhJTsPCCSLsP4=
X-Received: by 2002:a05:651c:15c4:20b0:3a3:7680:67f9 with SMTP id 38308e7fff4ca-3a63c2edc6amr1104641fa.24.1790208877424;
        Wed, 23 Sep 2026 17:14:37 -0700 (PDT)
X-Received: by 2002:a05:651c:15c4:20b0:3a3:7680:67f9 with SMTP id 38308e7fff4ca-3a63c2edc6amr1104501fa.24.1790208876835;
        Wed, 23 Sep 2026 17:14:36 -0700 (PDT)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a63bdbc5dfsm2340611fa.5.2026.09.23.17.14.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 17:14:36 -0700 (PDT)
Message-ID: <205181b9-9677-4fcb-873c-732a503fabd9@redhat.com>
Date: Thu, 24 Sep 2026 03:14:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/12] [PATCH v14 00/12] migrate on fault for device pages
To: Jason Gunthorpe <jgg@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
References: <20260922053421.4092027-1-mpenttil@redhat.com>
 <20260922192726.90dec3c4c77b8c9063dbf218@linux-foundation.org>
 <5b1d0fa6-d183-446e-bc52-56e0afd3f398@redhat.com>
 <20260923141936.d1f9e5b85355f0bdc6a6ecd2@linux-foundation.org>
 <20260923232402.GI2545495@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20260923232402.GI2545495@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gDKZysi9qDqA22wC2bZmPznYiPgC3OscatwDaerYoaI_1790208878
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 027F3180003
X-Stat-Signature: tonro1mo9d11jmztk85dmock4ptoqqro
X-HE-Tag: 1790208882-212353
X-HE-Meta: U2FsdGVkX18wbYH+THwWifZLk52zKUGa7eOnPm8U+BESCDwFSkg3k2jTUmlGT4qczQ6tDWcUSbn+l9I+W9DVFNAPCaIrtjsCzoSFGEKgXSzskM34Gm3Ss9pMo91DXnsBLsV+/N1a/3TQe81qGJQoa0IQsUsg6nET7L+DGcWE0tlwPfF5aGebfSchKc1Bn2H7yAQCSM+oTY/MuVBCLKPiv10RjtgTrIM1nAuPZlUMRgJHCxk7T1fB5MUo7jOXl5evBngdCKJiCa02S4hBlFz4BpE5tq81JvHnzDqVOPZlFDm6YMib0zobP5cRL1wkRhPmXJX18+BvEvbVCV/8AsS2J3mQUAGC/x53uv3Gsjqj/49rCW226xCw69sdacn1pid1SY9G9efSKbU+41ngYAdwWl8cMLHLcEISK0T5bRXR47xORNS60h2Sxrxakj9XKbByfeF90nrDKfmdrUxAxsLN62uh7RsbqYinXXJxV4OdkNyfn9J9Ws7KWrKVF4YVPHAj24qntpSv6edhM2uosBI/JX6Sqsop+1xf4a88pqBT5TV8SFxJNdk6yZcaaZkkBnPlxXF5LKrGbq9Hm0ja6ZzQMrReNcjNwGy29ifoQjxFmovh8FHkba9nabmhneAzMtUCbFJo4xZCanH597yT/ewZnMhIDVheIbmfMmlwx4CZam1euPZ8I7aFq0KdjH9DcVzyu0Xf1xX5xhHGmSi+szRP3Ij9xL/5seLzzVGIMikKwUaJqUfX4/X/WnwalwPNDD3udKaq5yp34mHd0Q9Pe2oLIoi6mGf25QzkKO4tyVWDghSGZEI+xq7F+3WXow7AXu0gaiaoY0riRe5Cp9ntLVs06YPnU/vHbxZ4kKsMjnL5vJkU2zPe384in9APhGn8MVtWkDya8/EpuXZszhIjjXKkjiYW55fPrRpTjF4RYW0jdPsqgBvSQ2+yz1WnzsK9r5qoFUEXmcostu3BjpYAsBG
 GHGd/Hx2
 bkJTAH6xt7mi8QB9kkjH0yanXA/s6ltWtmnOyrVhZz2ildThZwmhzMlMSphjBWkmjIeGmfO4XR576gbUnqpz2xL7oiY42pQp6s7T9K5wqmO/y2B+FvAFJZGWXLM8rUPjBTCDFIsD/7qvYBx0NHi+d4h4D5fYm5xQgXdDigN64bGls3tfOt6RdaS0xoj3oeD2lPX6iuWo08VSf2GgW5exM24TLgs9TtFZHqwI3MGNcHnC7u3omb2lhv1PRj4g2B6/smoABBLBiQmlP0Y0W5ZVG4AU4DZN+75dUOulDXpAqLg1zL0j5/XIFU8a5v13y6Isryq5UMqVee5ix4vlUUYHAAfujmj5nLFYOqX7MMToL6tnFRL0LuzKCvnLddAG7+4YngKOg1oDpTLALf1kaQxY1c/KMfVvWH7K0Y5oBR2vTs5/mdukvBojALeT+B2o8Rp65TItcEnaUhbESbQjyMFJ+3S+B8FTksfyyvOCwJDfXDqQ5/+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/24/26 02:24, Jason Gunthorpe wrote:

> On Wed, Sep 23, 2026 at 02:19:36PM -0700, Andrew Morton wrote:
>> On Wed, 23 Sep 2026 08:29:34 +0300 Mika Penttilä <mpenttil@redhat.com> wrote:
>>
>>>>> migration). It is also tricky to code correctly. One page table walk
>>>>> could costs over 1000 cpu cycles on X86-64, which is a significant hit.
>>>>>
>>>>> We should be able to walk the page table once, faulting
>>>>> pages in as required and replacing them with migration entries if
>>>>> requested.
>>>> Sounds sensible.
>>>>
>>>>> Tested in X86-64 VM with HMM test device, passing the selftests.
>>>>> For performance, the migrate throughput tests from the selftests
>>>>> show similar numbers (within error margin) as unmodified kernel.
>>>> But no performance benefits are demonstrated?
>>> There are no performance regressions for current tests.
>>> Real benefits come if want to do migrate on fault.
>>> For migrate on fault today missing pages are collected as not-present and
>>> the caller has to fault them and re-run migrate_vma_setup(); folding 
>>> HMM_PFN_REQ_FAULT into the collecting walk removes that extra
>>> fault+retry round-trip, dropping two page table walks. Page table walks
>>> are not cheap. Not to mention simplified implementation for driver.
>>> Also, the vma looked up as part of the walk is readily available for
>>> migration, eliminating the need for explicit vma lookup - one more
>>> performance benefit. Net effect two saved page table walks and
>>> one vma lookup.
>> It certainly sounds that this series will result in performance
>> improvements, but have those improvements been quantified?
>>
>>> This series also addresses the vanished/reborn page table while
>>> collecting problem which can crash current implementation.
>> Oh.  I didn't get that message from the v14 changelogs, and crashes in
>> the current implementation are not what we want.  In fact, addressing
>> those is more important than speeding things up.
> Yeah, what is this about?
>
> The series still has lots of sashiko remarks, are they legit?

Some of them are legit some not. This was actually the first time sashiko
managed to apply the series. I will address all the remarks in v15 soon.

>
> Jason

--Mika


>


