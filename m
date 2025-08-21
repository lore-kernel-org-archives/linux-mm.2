Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B32BCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 22:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 712D2940008; Thu, 21 Aug 2025 18:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69D128E0056; Thu, 21 Aug 2025 18:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53C97940008; Thu, 21 Aug 2025 18:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7118E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 18:07:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E3D2B83A19
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 22:07:21 +0000 (UTC)
X-FDA: 83802151482.05.E3D79BF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6088140011
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 22:07:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LHFAhJGJ;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755814039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Bfluc4WHEztZH8Nw6Ait0K3yXSc2CzthKd/5yCM448=;
	b=XUaqUKDNf8tH8pQ7a+dPurW+dwGKaBRPefi9JkEp9kK1+WZGONZ1TnER4g2QKx6RkLn455
	EqobwboFaPxuaOzB/zppq0gUOia8VVmIFYocJjzSDsy++zyuwe2Sv/ahckNuFJSmdavd1v
	1pgeSVvhiv2zSsCELYpRQpe4VcUnGr4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LHFAhJGJ;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755814039; a=rsa-sha256;
	cv=none;
	b=UNmFz1+9uc31s59tm2FDRj9xeN9FBavKBOquLw1xufMgPxtUcltAb5ItNQJaZ8NYojCwEv
	HGc6csxJ1MznpAz3VOg3tx62RsEtIRJZPR5WIzd7RlICa4Y/9sIAmqqOWgf57Llq3Vh3gk
	C39KhYQ71tE4pjsUo+1UbNXX2reNqrU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755814038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8Bfluc4WHEztZH8Nw6Ait0K3yXSc2CzthKd/5yCM448=;
	b=LHFAhJGJ06080jxi1w2/JtbQjDqAChooY46P0sM7H+7WHmVqWpUc+eF1pFVoIRdNDHugwC
	vsySkB5kXTE+JziUhB8QnfR/TnmgFTy2ezvxhwHyiOpaHtKaHZK6vANyUCBkOT7YsVu7Jy
	/6kZ8MMakhdEQpWkeMdmRp3YU9UZTFY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-RRKzPFswN0Oviv4NskMVfA-1; Thu, 21 Aug 2025 18:07:16 -0400
X-MC-Unique: RRKzPFswN0Oviv4NskMVfA-1
X-Mimecast-MFC-AGG-ID: RRKzPFswN0Oviv4NskMVfA_1755814035
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0cb0aaso11483435e9.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:07:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755814035; x=1756418835;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Bfluc4WHEztZH8Nw6Ait0K3yXSc2CzthKd/5yCM448=;
        b=jSn98LwvxOkExFb2TkQL+NfpQkF7QV3KO8ropGmoOyoeeMNHHa87uT+cqRY/Zbby/0
         GQNigR0vepCdp3xmNMCw79iH60gp/Ru9jGiMNJaOUX2luz1lJULeSj0oMAmb1fia9/CR
         zW0cJrztpIPn+yXK1/40zPk6d7rqoLRtn9h2QrYKWIWsHgCtK40iR9gBHMXjTNJZwOTy
         kGp0WZbvBM1V+QzeCeCmxGivA5Q5tgK9hAr6HfLf9IZ/f2FwoMbpUBars5eVRJpkEmDP
         RR2ytTwh6rcBixRCqkHzT09R+oNLzNDR8BFo7I0wKd1LXr2URsr3jwpA7RlNRnCrvlaD
         Wb1A==
X-Forwarded-Encrypted: i=1; AJvYcCVQCbpIWPDf/1mSYky5HYEG1ssQbJgDxHm6m2OCCSGM7s6iO+jH5Gd1qxE1URkSnUp+6td7UxgWtw==@kvack.org
X-Gm-Message-State: AOJu0Yzl0QkEC1XWYpuGoBMxoPM2wBGrcAZ8/TM2N/QCfc0Kbnw+SI5L
	NOVyiDOEOewZNMdCnyPB89YiXXeJWcT8B/JanfUd8m3W1UmDllAVkFusbFbo6Cf9sCnP/fOvXkM
	P8TgU9ZKDOtsroc7YI0se18JjuXfBn66jwqcdwj0hxXXwrZh3CC0o
X-Gm-Gg: ASbGncuugM25y2Y+Mfu7RuJBJbxUk5aHTE7yIflWIKSQqolqA5fzDzZ5hNxscEXcNtN
	9/JlZ+Av57AdCmqlXKjCIkwEpOVyYM56d5PTekyuxo+HC+BObBQysbzte4MknC9PLZAl6d6WqFl
	JVKCsymbIKgRFmTesCEZjNq1ZmlcpP2z2IjkjG/zwx9zd6n5lDzBPGqHDcaE+7+39YaBWk6SJAD
	pdOwxORjijTxq8TPNsFXt9h5r7arKSur/NdxzamiwCo65/m6aTcOkhujiKlk8x7wAqM5I1IDCZL
	A32eDlO9uPz1k37kC1EAPJ8e3nuPwgiftXyOpP8N5vcMZk+AwFhhjoT7ZnVVjtsW/xF8aa5AXaf
	xwVACW0WECxeiYVhgQ5GBtMwX8aWSPZzfWfiQc4wI/HiPi1WwSCVAQrqpqSBG1A==
X-Received: by 2002:a05:600c:19cb:b0:458:6733:fb5c with SMTP id 5b1f17b1804b1-45b517d2751mr4525705e9.28.1755814034715;
        Thu, 21 Aug 2025 15:07:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCdNWpJy50z0nd/Fpc0VOpWtta1v9ivqu/vllJYD46m8IOxBRFwGBb/p/VrqibgyOrtAxOmQ==
X-Received: by 2002:a05:600c:19cb:b0:458:6733:fb5c with SMTP id 5b1f17b1804b1-45b517d2751mr4525455e9.28.1755814034226;
        Thu, 21 Aug 2025 15:07:14 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f26:ba00:803:6ec5:9918:6fd? (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b50dc4c55sm12168905e9.4.2025.08.21.15.07.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 15:07:13 -0700 (PDT)
Message-ID: <3c214dff-9649-4015-840f-10de0e03ebe4@redhat.com>
Date: Fri, 22 Aug 2025 00:07:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/memory_hotplug: fix hwpoisoned large folio
 handling in do_migrate_range
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, "Pankaj Raghav (Samsung)"
 <kernel@pankajraghav.com>, Matthew Wilcox <willy@infradead.org>,
 Luis Chamberlain <mcgrof@kernel.org>, Jinjiang Tu <tujinjiang@huawei.com>,
 Oscar Salvador <osalvador@suse.de>, linmiaohe@huawei.com, mhocko@kernel.org,
 linux-mm@kvack.org, wangkefeng.wang@huawei.com
References: <61325284-d1d6-a973-8aa7-c0f226db95fa@huawei.com>
 <eb6a4203-1555-4aae-8320-99679cec90bc@redhat.com>
 <4c5d4fd5-5582-11d8-9fee-24828ac1913d@huawei.com>
 <8c9719f0-c072-40bb-b7f6-6f2cc41a31dc@redhat.com>
 <1D589FE5-3515-4ED5-B12E-D5CE23BA5D13@nvidia.com>
 <e505c25d-c4bf-4d87-8284-6aa0da2fd979@pankajraghav.com>
 <641F5B0B-2B48-46FA-AC58-3A8A4BEB1448@nvidia.com>
 <3702f6b0-27a9-4ca1-adbd-fb1e2985b2d3@redhat.com>
 <ocgxb3ggoaza3irdpea7xhcw3is4vbt24omy2qki36cxkmtecb@jpn7qtco3lvx>
 <345f7ae6-b2d6-44cd-b8b6-2bdd4b33e9d6@redhat.com>
 <CFAECEE9-24CE-42FD-8D55-FCE832D65DD3@nvidia.com>
 <A1B06D4B-5B39-47C3-94E9-93FE3F0A758D@nvidia.com>
 <c0f5492c-f9fe-48c8-98bc-d8cc8e7e00b3@redhat.com>
 <E0D87F2B-20AD-4AE4-943E-C126395C3CE5@nvidia.com>
 <66bc7274-ec2a-423a-8094-b8d4cc9438fe@redhat.com>
 <20250719192300.9e32c35ddc49f11c7954306b@linux-foundation.org>
 <a65acb01-282b-4b6e-979e-e3bc2fcd9b15@redhat.com>
 <20250820220212.bac0423a778d3b04b05d8bec@linux-foundation.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250820220212.bac0423a778d3b04b05d8bec@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: afh973EcJzKlWFoDG0LGa4nXT2s6gou-tdYhOWCWWHI_1755814035
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6088140011
X-Rspam-User: 
X-Stat-Signature: 9o9j1ockkfoxzwnh3op6hrs37azxce71
X-Rspamd-Server: rspam09
X-HE-Tag: 1755814039-250017
X-HE-Meta: U2FsdGVkX1/ooIY47dNu1T4LyrNAEvLeHGCDAsJybM+zhDJrrMuzaxl7bF+bUx9kyY2Qx5amAtZO0kTXzGmNRTHP9VDGT7vNc+5lfCyDiWBpRdzIXt4fq/n8w+c8r/d8+5X7XMUjkEvWae88n03UauwAfz/mjxONCGlsd4f0WLFyfMUfwuFjsM6TMeyAD6VACHO/hFVaIT4UtlIM0YkskeDBdWfBgCgLmrcsxzjBbtWiQhJSi3DATP19pZswARdZzI2PYKYRaUyJX1nzl0Og7F1JJNKpbgFQZjrJwExNQDWuAj4dLeT1vVEY9g4P3GLm3LhxcQFHMlNxoD0HGyOu3pAGu+bMWtDHJfTbACkGQx7PatDaiLtqa/Qo5ILPgscrt0iYmAclqHAJX+CZZ9lc/Uz525qps4J9hlfwecF7hKmM9En1oVG+qf+onc0dAUqzYm+w9kw8QaVf0hIqCMHxMl/sm5uy/k3vCHbfzhkC1E0rxQWHZC1qLpiqW5F256vCY3ebFeG+XUVFqAzGeFlqBMCo6+JtP7/mPjASvrJdTwpUK0x2ifcMm+4sFA4XJlIHDwWSgjpchHQxQONBcyTXkvI3aFNONX05zKUDg3BJ5NEHZU9wguaSJOaRtvhE/UG03gvuUyG4tIedjmJshsPa8l2mOxYlwVC9yB+ZGeJUbwG7isFAj7pV5xqRXFpIvjP7G1qgBo4pJLZY5wshjFo4/cnY/6Qe/WLo569dUK9NdNgQc6VMGXZ//PoDfnNV00rjnwuJ6xM00jagtYwt3iHBHDBPxtoHw7j7TzXn41YgGKJTQkzwoznvu+i6ol3PPixvbyg2V4VJTcKSfWkA7REdB/AyQ/q8auH4uYW7+Zd6AjdR5XBDg9cvDYa63h/3DRKsE3BOpD9aSXdAdJ7K1YlqYfIWNjFeHjQYiJpQya87dPEHAYVVU4liK9CBot4FEFAocJKbAxBz+tPp/EP+LCw
 Jjw1RqZn
 UvYKR84NgaIqbVmrYC/e0kX0rc+HURt90KkN4jsr4BHLE/FyPbC3g7l5SoORjS9y0aPDm3XowCRU3s+vOnmdAUNhm3mZmSYAstWbP1OamoiH0ohbDd+jvQCUAF68yGOC4RYjB1D6jUzhdTDfM+4SgsPsCwFl1AfafZylAk2sOUz8fg+rXyTbTpPwHgAa+qxCOrQWjb0EGP+Fze3OwHiBxnrUyPkyeMI6cnI5teyuKS1ZSurEih+sJdeuBoSLGO/bbSpRFJJpp4pGl3NvpcDs3JBisqhZuF2z80PIKJ4dTl6eTkxa0tjsQyJdxnylZOXItKu+0iAowFBUkqq223xS2v5hXJDDBnpj/lGzd/Li9UXrnqx0Y+StjR53a7+G1vRY+dubAN7ZsnE3GcmkYGIZWpuF9z1Gxn1VnEnKiG9PVj3DdyqDZPa1XoBn/hysMjwg+OF9+hFSbHXx2A1aLx6AGvPKgxQ4x2NbnFmGRLB3h6h6SzHQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.08.25 07:02, Andrew Morton wrote:
> On Tue, 22 Jul 2025 17:30:06 +0200 David Hildenbrand <david@redhat.com> wrote:
> 
>> On 20.07.25 04:23, Andrew Morton wrote:
>>>
>>> I continue to retain the original patch in mm-hotfixes as part of
>>> akpm's lame bug-tracking system.  3 weeks in -next.
>>>
>>> And I just added a cc:stable to it because December 2018.
>>>
>>> I don't expect many real-world users will be putting fake delays in
>>> memory_failure(), but it's there.
>>>
>>> So what do we do here?  Add a TODO, merge it under the
>>> better-than-it-was-before theory and move on?
>>
>> I would feel better if we could just not fail memory offlining. Memory
>> offlining is documented to loop forever if something bad happens, and
>> user space can cancel it.
>>
> 
> Pathetic monthly prod to keep this on people's radar.
> 

Let's do something minimal for now:

 From 403b2a375a10c17fd6e2aeffbe0fdaf623faa621 Mon Sep 17 00:00:00 2001
From: Jinjiang Tu <tujinjiang@huawei.com>
Date: Fri, 27 Jun 2025 20:57:47 +0800
Subject: [PATCH] mm/memory_hotplug: fix hwpoisoned large folio handling in
  do_migrate_range

In do_migrate_range(), the hwpoisoned folio may be large folio, which
can't be handled by unmap_poisoned_folio().

I can reproduce this issue in qemu after adding delay in memory_failure()

BUG: kernel NULL pointer dereference, address: 0000000000000000
Workqueue: kacpi_hotplug acpi_hotplug_work_fn
RIP: 0010:try_to_unmap_one+0x16a/0xfc0
  <TASK>
  rmap_walk_anon+0xda/0x1f0
  try_to_unmap+0x78/0x80
  ? __pfx_try_to_unmap_one+0x10/0x10
  ? __pfx_folio_not_mapped+0x10/0x10
  ? __pfx_folio_lock_anon_vma_read+0x10/0x10
  unmap_poisoned_folio+0x60/0x140
  do_migrate_range+0x4d1/0x600
  ? slab_memory_callback+0x6a/0x190
  ? notifier_call_chain+0x56/0xb0
  offline_pages+0x3e6/0x460
  memory_subsys_offline+0x130/0x1f0
  device_offline+0xba/0x110
  acpi_bus_offline+0xb7/0x130
  acpi_scan_hot_remove+0x77/0x290
  acpi_device_hotplug+0x1e0/0x240
  acpi_hotplug_work_fn+0x1a/0x30
  process_one_work+0x186/0x340

Besides, do_migrate_range() may be called between memory_failure set
hwpoison flag and isolate the folio from lru, so remove WARN_ON(). In other
places, unmap_poisoned_folio() is called when the folio is isolated, obey
it in do_migrate_range() too.

Fixes: b15c87263a69 ("hwpoison, memory_hotplug: allow hwpoisoned pages to be offlined")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
[ David: don't abort offlining, fixed typo, added comment ]
Signed-off-by: David Hildenbrand <david@redhat.com>
---
  mm/memory_hotplug.c | 10 ++++++++--
  1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 1f15af712bc34..74318c7877156 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1815,8 +1815,14 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
  			pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
  
  		if (folio_contain_hwpoisoned_page(folio)) {
-			if (WARN_ON(folio_test_lru(folio)))
-				folio_isolate_lru(folio);
+			/*
+			 * unmap_poisoned_folio() cannot handle large folios
+			 * in all cases yet.
+			 */
+			if (folio_test_large(folio) && !folio_test_hugetlb(folio))
+				goto put_folio;
+			if (folio_test_lru(folio) && !folio_isolate_lru(folio))
+				goto put_folio;
  			if (folio_mapped(folio)) {
  				folio_lock(folio);
  				unmap_poisoned_folio(folio, pfn, false);
-- 
2.50.1


Man oh man, is hwpoison handling a mess.

-- 
Cheers

David / dhildenb


