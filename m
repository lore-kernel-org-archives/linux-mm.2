Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F41ECCAC58F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 07:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C8FE8E0003; Mon, 15 Sep 2025 03:56:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 379BF8E0001; Mon, 15 Sep 2025 03:56:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 241838E0003; Mon, 15 Sep 2025 03:56:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0EC9C8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:56:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A65FBB9B18
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:56:42 +0000 (UTC)
X-FDA: 83890727844.25.F323BFC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4D4BC4000A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:56:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M4ff+JAy;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757923000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gj31XhCFFIY/BiltQw0wfauZJctVPWZ+HEyjPF4AnEQ=;
	b=1XET0vhwwXTTu9yjteEPzmXosng+i1bnj0JWR13BpcIwkmvw3CFOMLPVjJk1p5aBJavbGc
	/T9uN9C2seeQDbgObPSmtv7KOCnvrf0T/Yq2amndQuDPP0OHEiUYbBn5JK+bxPZYra3HJu
	8X4Szh5AUpTuy4ybiUSp30uPL10QWE4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757923000; a=rsa-sha256;
	cv=none;
	b=UOYfYZwSsw4a68AIpLbl3ROG6KpedRjS5Vl9FHbV+WVzIVadwrgUXkrl4WSO02WVAU8kav
	OzfC9tMkJ+nSKWddV5OU/VHf9zCuwvIIJmmPxwStcxN0JVUq15EmIwhayRE9T0pAl7hCp4
	gVU7m/Dt2s3oqXNjniNV+QhH9s5M2YE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M4ff+JAy;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757922999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Gj31XhCFFIY/BiltQw0wfauZJctVPWZ+HEyjPF4AnEQ=;
	b=M4ff+JAyPFUhtJ/Bz6eG7/dBiT8xruUQpqz1JCp6mkaVjLpvrbPQhAD2VEsxvRBNL81zjy
	yZp+k7UcJ0bNJifVwfqOadMlm+aLw9bW4Nzf2tYCmz089GUukT8W2RMSLrzwVKNLfbleFc
	Ar7dhW7uXNw4csNsqULjFVMll1f1hYY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-dlsWR9E6NRqPuNEyOxESmg-1; Mon, 15 Sep 2025 03:56:38 -0400
X-MC-Unique: dlsWR9E6NRqPuNEyOxESmg-1
X-Mimecast-MFC-AGG-ID: dlsWR9E6NRqPuNEyOxESmg_1757922997
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45df9e11fc6so22691825e9.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 00:56:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757922997; x=1758527797;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gj31XhCFFIY/BiltQw0wfauZJctVPWZ+HEyjPF4AnEQ=;
        b=TT/PIDh9B8/zl1tpXKB07kvdEYjyQCpQEVVV6LCKxgdtRwRgEJShg2HGth3w2spuSz
         JYos2y26fA8+Q6tJQ/iS2Z23iQ+d+1LnczmIKMTzSabWp5yLfH3zrYbUuunuHKI8O4tP
         4h2TTYrztMNjhH9lwiTJeDSYUOj1KCTI3xQvCw+5N7TWQ6RqaxIt1V3XwF1vl7t1s1lk
         Gg3bEGgoRWFI+RTuynbFqALFd6qGdYud++MUkl89YS56163MzIjwMn7HZikkW2rWJMyl
         b6ltrDrBBAbW+sMNSNDlswoQe/BuIj5684jYc7c23OXVhbX0mKCztVhjNpAKJFLt510t
         X2hg==
X-Gm-Message-State: AOJu0YxlhbKVJkGLxALAFkpebG8DzuFu8mi9p/St53mVVBBjKeY0dy6T
	Xs2XNcGEABIiaH76dyZbOxDJOMX07UGyTm6hzjtUkfKIsaXWG6/jyfLTbkLKNCJXYDfKAREBEaV
	2mdHp/5x90sxPNT0PjiemFQXLtpapa7K5Po0x0L9t+K54IQIHLwrc
X-Gm-Gg: ASbGncu6+HpD57xdR75DytpGtiIvdd0XtH6jvXrvUj7QEq0iB2GbSvzaDjbr3hpoBhy
	d/tdo0iQ93uNxZCP17umsPKtheuSswsC/olA744z5mWybVXzSVfRSbS0BJW4rCHV6ELlKW2KyM5
	/q5zG3FqYdb5ZOOOfXF9KNkf0swkjz7ui2EE/7bJaAKQwYGuPj4CTv0S25sfws4HEbci9i3J3Qm
	TjyXVq8xu1Ktuv30Xh6qU6D20Wa73tyi05fEFDw3yKSMYvf69mKJCWNh6d3QU1zcDNbezEe0Lwy
	kOc9teH1N7s8r/DnGJTBiFaWWqNAA8j588jQiXwD1oi1mqa9PB8RgPKunhyNc8QApUvXJpQ2NuE
	nzoTX7h6Gbxcs/wTzzkQpyfEsUT4dl0zSQhvgCQxPr6lSsHASF5HosrXawokk2Ynp13Q=
X-Received: by 2002:a05:600c:4fd3:b0:45f:2922:2aef with SMTP id 5b1f17b1804b1-45f29222d65mr47331615e9.28.1757922996895;
        Mon, 15 Sep 2025 00:56:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFd9A3po3LcKhdElspGnaMeXhYXzFPy50CRR4cTmxI9J3TSmPUgYcBZO1tqX2HBHDKMZ+nbIA==
X-Received: by 2002:a05:600c:4fd3:b0:45f:2922:2aef with SMTP id 5b1f17b1804b1-45f29222d65mr47331395e9.28.1757922996454;
        Mon, 15 Sep 2025 00:56:36 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ea287a72ccsm4555895f8f.40.2025.09.15.00.56.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 00:56:36 -0700 (PDT)
Message-ID: <62680957-e9aa-40ad-893d-885bd01e1117@redhat.com>
Date: Mon, 15 Sep 2025 09:56:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
To: Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
 Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, lorenzo.stoakes@oracle.com,
 akpm@linux-foundation.org, chengming.zhou@linux.dev, npache@redhat.com,
 ryan.roberts@arm.com, xu.xin16@zte.com.cn, baohua@kernel.org,
 Liam.Howlett@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com
References: <20250914000026.17986-1-richard.weiyang@gmail.com>
 <ae30fc02-c573-46bc-a5f6-935f256149e2@arm.com>
 <cf5d6ff7-faa4-469e-9e32-b90c75b8194f@linux.dev>
 <463716f5-be12-4d78-9432-779e3f11460c@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <463716f5-be12-4d78-9432-779e3f11460c@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PU5gNc6PnR256SPvz1pZRX6akNrZF4UW63Nx0pKgFYU_1757922997
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4pxnh585q9ioz76714kqhwbgusz7cjpr
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D4BC4000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1757923000-578286
X-HE-Meta: U2FsdGVkX1819pmwO8jPNs39pe1Ne1AQcPMlzDa0m4oQK21GvUtNW0B1viGrn/VvjUdRu0K6ijyDeAW7MtapSbRKfJQ01j0SQLNgZesKb50VF+58AOWveroEmigLsZg3DbHcLCATQ7UxFPPUnaqTcTsmhY28JYEDPYoTEI91nwRKnH8CyPAKzw0l2AEyw2fjEpR5JHHsJsosfndGXcoxw2rFBHhWNUfQSjwVQZvcyM4msACmFaG3mgv5XmF6d5UwxkOcFlTbSZgSfk8tdY43jB/fbuskSUS1LwNPXv//9Nh7jNwJyXpSsVrvTfrrdLkMvEAvaBLhF58M5PCJFjl0NfeavcDAgoHXsf/Mg6nC6PFY41i/oAisTOjYyHTmrkm7qxgs2qs4LEW6HFHn9Sey7XgloNoRaNKt95L2prpHV3/oHQrF1Z2n3tR6xzeIYZQnuBLhMXYyx53rhsWOgKXAfytFA4vZb0r+cTMSh8+C/O5SPhMPbQrcjpWwAfweSrhYgp2rQtRwVNvaHQroD4cwa99rpBU0fSVTQoEbn+YeL3Dt6mBPL6W8vxwVm04WbX9D/bPVZxJPL5kWeOTfZvN3IHFVV2RPVaQfrqj0X5BzjmMa0fALaKQOH0aUfdpsUvkVtMVy8APwo+kwNMmi4Sxdyq4qXM51C1SEb+mbUuM5wMum44wBLfLBi7+NEuEL2GRVAo5zp/m4Jf9N/bYBjZJAs4hDPY+GprD2a0eZG2H1rJRO40EnasU/Kuutoim7Cpn74u4G4zyFVKP0m6Q+AlhmFeEgZp/kPgp/ui7VqA/2DOnNoT1ibUa2PynA3KIp9At+REIEtJ3ii4GrU81pRLYe89vgBz9GFcX6VaNse1znUdSsimvrd8reP2sGPiD4ZixnYQQCuCOx4hlpClmxVpMTy3NMol6EGvkF33ax+pTuUk55XbrrUJSUolANCyJwSpBQ6+oBEXdizs0hj0cxPOd
 VvjcBxaZ
 TKqtoyOzCNAbkMVi29u0WSKqwILiv0oKqCftIpdhyJGmWjS3I4Hew4/lqRClyaf+6E50ZUzGgufC79SEI6DrhG3G97izr3RTUJ8VKsjk9w0OqnnJ4918/nfymOWf5BEcIZhO8LDDXuHL4CQasbIXjkskY3kieq7hppGlMoKjMpi9uLglG2hkB/TWc9o2piOqTGBh9D1P+Tkl+JWp4fgOqqus9e/sn6sQSnx2vT1bwLIN+qSiUoWdFzVkogJefyM/SUj1cMkKyvSVmRs2yDSma9ab0BtIOTyjeODurcrSegUrNO/kMJR8R+SQATK+GeCljFaCMq0qvUxtitk0AK7jWEJSK3+0vjQPARa9V2g3BES+ohBOja5paCWsPcARlfxLyu4m3OiaMqIwhgyE25x+1Df/bUv2ecZEOsyhkmpHi3Zi3wZ1uZXbGjOtsYc+sHdPQlX+0ObF2/WsicBLzoHFNzc3sepwmj90OLv0LqBeHWMQt/iA2pWWRClAd63+4YZFa+jyVC53ZZ53LT/p5upllAErU7XRzz4MyYiKjULdONjJktdfiiiZC2pMcymOf1c1kkOwSnZG6jTJAV/g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.09.25 09:29, Dev Jain wrote:
> 
> On 14/09/25 12:33 pm, Lance Yang wrote:
>>
>>
>> On 2025/9/14 14:21, Dev Jain wrote:
>>>
>>> On 14/09/25 5:30 am, Wei Yang wrote:
>>>> When using mm_slot in ksm/khugepaged, there is code snip like:
>>>>
>>>>        slot = mm_slot_lookup(mm_slots_hash, mm);
>>>>        mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>>>>        if (mm_slot && ..) {
>>>>        }
>>>>
>>>> This is only valid when mm_slot is the first element of its wrapper
>>>> structure, otherwise a NULL slot would converted to a mm_slot with
>>>> negative value. And current code thinks it is valid and continue.
>>>
>>> Shouldn't you fix the code for the case when you can't find the slot
>>> in the hashtable, i.e slot == NULL? Like, if (!slot) return.
>>
>> Right. For khugepaged specifically, the slot == NULL case in
>> __khugepaged_exit() (only user of mm_slot_lookup) should probably
>> be treated as a kernel BUG for new.
>>
>> But I'm not sure if the same logic applies to KSM ;)
> 
> I haven't seen the KSM analogue, but restricting the position of an element
> 
> in a struct to make the code work should imply that the code is wrong in
> 
> the first place :)

I agree. If mm_slot_lookup() returns NULL we just just handle that cleanly like

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 6b40bdfd224c3..70a32d59d7d2f 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -488,11 +488,13 @@ void __khugepaged_exit(struct mm_struct *mm)
  
         spin_lock(&khugepaged_mm_lock);
         slot = mm_slot_lookup(mm_slots_hash, mm);
-       mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
-       if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
-               hash_del(&slot->hash);
-               list_del(&slot->mm_node);
-               free = 1;
+       if (slot) {
+               mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
+               if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
+                       hash_del(&slot->hash);
+                       list_del(&slot->mm_node);
+                       free = 1;
+               }
         }
         spin_unlock(&khugepaged_mm_lock);
  

If mm_slot_lookup() is not expected to ever return NULL, then a VM_WARN_ON_ONCE
might be sufficient to document that this is guaranteed.

IIUC, MMF_VM_HUGEPAGE might be set in __khugepaged_enter() in case

(a) test_and_set_bit() succeeds

but

(b) mm_slot_alloc() fails

In that case we could get NULL.


It is rather weird to leave the flag set in case mm_slot_alloc() failed ...

-- 
Cheers

David / dhildenb


