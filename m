Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 875F4C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 08:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AB0A6B0088; Fri,  8 Aug 2025 04:02:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235306B0089; Fri,  8 Aug 2025 04:02:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 123B66B008A; Fri,  8 Aug 2025 04:02:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 015866B0088
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 04:02:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9E56C1DEE7D
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:02:17 +0000 (UTC)
X-FDA: 83752847514.02.E0A4643
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 12501180007
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:02:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hSpE8Q0S;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754640135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BAno96tpxFYMgcAPgmjun2K1NToihw19tP0g9bAlXR0=;
	b=cSSZ4XFKeOgVKxeRZUGdgBqzJu641HURrRZDQF2wVKGqm83xvhXtgu8ggErFdT216EMp0K
	iK56rJDAwMEIrZE2dWZw6ew7zEZK4LOpn9jSMnB99afGiJghtfMPQF5yTR+Nir1Dbd5iB/
	8/9824IprFqXXrpswxtl1SPkw6VZ5CA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754640135; a=rsa-sha256;
	cv=none;
	b=jUvVDt353GgaWtRBMxqcXh1x2wRV7tC1E+69VyMu5+c+58oMDusvEJymZIwdo7IfuxnRy/
	Bhi8LBpBrSnKt6wRdQvyAPvkIZy/o9rGMxJVASHZUrsaO27QeaLZn345dpwhybZKpiAmPC
	UrasCBhWZjSLu9zmM5r/2yO8Fyx/CLE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hSpE8Q0S;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754640134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BAno96tpxFYMgcAPgmjun2K1NToihw19tP0g9bAlXR0=;
	b=hSpE8Q0SmGyTAMEdwCvQBPeXDEkzOyhI5GP80BwndfTjGp26YSZgKrAjGzmdrA2hyzPgUT
	FK73LXKN9YXJIVbcQofldbKErx3l5ZtOdQR6x1NGnCxjZDIbB222vJynJ3L5SFjN83WJBD
	mq9ZglC3TZ67WwPnmAHhR2lYgt92Ibo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-oZ477Hw7MViFkfVgWNtkow-1; Fri, 08 Aug 2025 04:02:13 -0400
X-MC-Unique: oZ477Hw7MViFkfVgWNtkow-1
X-Mimecast-MFC-AGG-ID: oZ477Hw7MViFkfVgWNtkow_1754640132
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-459d665a87aso13791305e9.1
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 01:02:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754640132; x=1755244932;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BAno96tpxFYMgcAPgmjun2K1NToihw19tP0g9bAlXR0=;
        b=Ir+IZMRiCmrQeKA8AiSPmt4rd8Y0TXBTh6+RnQ2VQ4N3qunal/Al/Ry7vz57A4OnqO
         l+YST0o230tk1XXzGF9HFFj7316EQrkR5ne7lgtbNpYfImhZWS5b8/tTVOpR+lfnsAB7
         zHelE7Dsu+KjOX5CYSEHN+nG2DZZC3dNTZs8V94jOvI4JcMeVILYr/+H5mZeYRTkgBL7
         N5McTv/7jh7ugd6B9q2Ii9I03SRAKbdmu1A3um92bYL3cf3mdOFgk64S3UnO2klxjwdk
         Cgia2YbOl551+CpBRjhGtAqRdCTioOb/aEtcHozjZOTb9k4RChQcm7m7/IX3ImdLd++9
         BFMg==
X-Forwarded-Encrypted: i=1; AJvYcCW/6Y9luhx7yKWg7DB/LxjUnmaK5kvSoYekLweleYhBVtDSIY5qwtMlJYlwuc2CHeCYHEa03HIyrg==@kvack.org
X-Gm-Message-State: AOJu0YzdjenxRXWU/34Kn5dIMWC4Ka32SDUw5zvhXmEfufdhdYCBflGz
	JRHIKeP62LqUiJNSOLW0mxRxDl4/F/QVbhTRE2eGfVVIzExaHybjks3fPgh5l0+chmOa/ssMEHj
	Hm2MG3qPpe0kciFqBxZPNf1IevLOKQ45jXKQh5V7ytBFD9CNdnRaf
X-Gm-Gg: ASbGncvqlbVuflqtnLC5eWeMVoWWXJVZtAqa28VulAYfmu+gIViXulmjf8GHMrN3l/n
	KOOXzLzwfbz2U+zE8Pjed3z8AwuO/S/T51w32NRbBIWvGzmPd/Qs45qpKu0a67CCSLiY9qNY4eC
	AvgKxdGi+X8fTWFaqcqVlQQ0YsFdV06YJl5tz1Ey36chNATzaQaO0T9ubpv9mOCdRWpQqOrzApK
	g0pIC2ZEPylgbqldjx6GFIwDw88fIbgdajDnLarSO6Po2/HXxst8zT50N3c5K5U1Zvd7SaTVFPR
	XXTB6ROq3LRh1BQI3g/I6MXh6afcvnxARk9FS6B42A2NXPWaPX9nPCb0zeYLQgOQCfFWkHM=
X-Received: by 2002:a05:600c:3b0c:b0:456:43d:1198 with SMTP id 5b1f17b1804b1-459f4f2d990mr13934495e9.32.1754640131831;
        Fri, 08 Aug 2025 01:02:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEgZzUg3wr1SifXE4t4yhDMq7cAU5j7L/vtRZVGMfKFh0NEsEhGPcGUTafUnKO5iZcAXqC1uw==
X-Received: by 2002:a05:600c:3b0c:b0:456:43d:1198 with SMTP id 5b1f17b1804b1-459f4f2d990mr13934055e9.32.1754640131356;
        Fri, 08 Aug 2025 01:02:11 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a580.dip0.t-ipconnect.de. [87.161.165.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e5862be7sm133209415e9.15.2025.08.08.01.02.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Aug 2025 01:02:10 -0700 (PDT)
Message-ID: <5b9c775c-35a1-4cd6-8387-00198e768b9a@redhat.com>
Date: Fri, 8 Aug 2025 10:02:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/userfaultfd: fix missing PTE unmap for non-migration
 entries
To: Sasha Levin <sashal@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com,
 aarcange@redhat.com, surenb@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20250630031958.1225651-1-sashal@kernel.org>
 <20250630175746.e52af129fd2d88deecc25169@linux-foundation.org>
 <a4d8b292-154a-4d14-90e4-6c822acf1cfb@redhat.com> <aG06QBVeBJgluSqP@lappy>
 <a8f863b1-ea06-4396-b4da-4dca41e3d9a5@redhat.com> <aItjffoR7molh3QF@lappy>
 <214e78a0-7774-4b1e-8d85-9a66d2384744@redhat.com> <aIzAj9xUOPCsmZEG@lappy>
 <593b222e-1a62-475c-9502-76e128d3625d@redhat.com> <aIzPPWTaf_88i8-a@lappy>
 <aJUDqqjCycGDn1Wg@lappy>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <aJUDqqjCycGDn1Wg@lappy>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: icDIz4sGp__O63JMy5t1v8mTF9r-KH2oDLN21UnGBWY_1754640132
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 12501180007
X-Stat-Signature: qrtnji7g87epgyubg99snupq4rct8f6k
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754640134-665654
X-HE-Meta: U2FsdGVkX19MgC6YSvZepnDwdCKrYErYZFwjVDU2WiaInQt78HRSjQ1MeYz4f+pzf8U9DMeIXCgfkOsAlY2B6L/Gha65cDQ9UrI7i2Xxy/9IXyyqRNl/W5slQZh7ZCT/xq/dT5H93hzH4LcstzAZY/quSJic9hBaXYxeUa4dzQjlOXqNr5LHEokoo8n61IW0vaVSs/x90lSuam0JX+QYFSwBOCu8O//VRfsJt6EFH9NIdWCvQ7EqRoI0CiDgz4UTwio7YrBrmDMTDUxl/TUPbY8h3LhXAoQ/294DPkvTXrGO3A8U6GbWY51XvwKR+MgufvCfw/Wh7IefFqV6qr7zNhrVE5AgGyp5/eBZUMDwOWqtK2S3JvNpSdTKBs2BdXpEiJ3qGlEehm4qihSvSmKVmUpWzmFZEpa6pyoLU9okbQL3v8HFiMT0jw899o8SvlUiXi2q5wKH9QMj4KQjfCvk+2gs6xK1gXacHzBSxsbQkq3OpAg9QMzAH31DSe7B95PYH8GAg/WazqFLZoL1409F2h2onEcRCnOGZwyGEjDAYD+HgHIElnWc9rq5sZqHyE6qSy+QLViFmO2pHcgPEUhuomHzOB6Oc/Y+uNyUhlZl0o1LAeyUd48BpPHh4SKfxsnqYcl36pnS/8GJzfnUEE6eHZ+pk2vgYi3TTN842GzKnxwZ1CqM/HJxn/bfylcaz0RXK26f7qrMoKtxavHdpZzTMCZa0p0hs3YPK230bm8Q8vbvY7qSy4FHSvwVvzJ4SWKsGzu2rLn6431RjlPBf0NLlQJuyeM7nWSReZ+SNRI0BLHa0xTUeAZCCHTIZHBBhf+A0FVkBCm7qLcvSPXlsg8wNs3PPHwrdbiJD8GMxIA3fuzIC1wdBjg2ANAZo7QOmGFNYyY+SPrCeLJM45Lhe9daOrp4LR4KBXWje1zfa94z+wO3H8nM0e8S/09RT3BXV31qvsG3rM6Hr/M9S7bsOPQ
 a72WwU40
 B8t1NIjd95HmLdE30urGPJeozGIIYggg3y/w5Dq+lV0ew4YAvSg15eyGNg6UkspVGwjwHeZoM+s4XDPQIliZtW0fKvBJkJz6HIW1/dW4ZWBgAVlq4LNGr2v0YimfHEVtDCWXlVTQnkRa2eodhUnGsxUFrDMw8g+vQPqb/2g50Axs9FDgmxVesAbHDFN45/XYH2/4SDeigG82CF4ka3Rpjs+X8C4p4KPn2ZpLofBsUX5B8KrEBLIbDD0eCfXInbpSz4lI0cc981FwhAn1p+wv08c7w5pZ/bmbLxsb++men4mStMbL3OH7+pjaWEojfBxbRPftn3tjEX0E8FEowmYVbnhAqoPI9M8v3EFhCwrb5/G5LfNOFnzddDBK0GrgkO9nHvY8oLS5RfDwDQrjNjeRI8o1pcyiAjt9tO8pRwulg9pbAYC0e0NkrO6CWcRsMR6pUbD79
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.08.25 21:51, Sasha Levin wrote:
> On Fri, Aug 01, 2025 at 10:29:17AM -0400, Sasha Levin wrote:
>> On Fri, Aug 01, 2025 at 04:06:14PM +0200, David Hildenbrand wrote:
>>> Sure, if it's prechecked by you no problem.
>>
>> Yup. Though I definitely learned a thing or two about Coccinelle patches
>> during this experiment.
> 
> Appologies if it isn't the case, but the two patches were attached to
> the previous mail and I suspect they might have been missed :)

Whoop's not used to reviewing attachments. I'll focus on the loongarch patch.

 From a547687db03ecfe13ddc74e452357df78f880255 Mon Sep 17 00:00:00 2001
From: Sasha Levin <sashal@kernel.org>
Date: Fri, 1 Aug 2025 09:17:04 -0400
Subject: [PATCH 2/2] LoongArch: fix kmap_local_page() LIFO ordering in
  copy_user_highpage()

The current implementation violates kmap_local_page()'s LIFO ordering
requirement by unmapping the pages in the same order they were mapped.

This was introduced by commit 477a0ebec101 ("LoongArch: Replace
kmap_atomic() with kmap_local_page() in copy_user_highpage()") when
converting from kmap_atomic() to kmap_local_page(). The original code
correctly unmapped in reverse order, but the conversion swapped the
mapping order while keeping the unmapping order unchanged, resulting
in a LIFO violation.

kmap_local_page() requires unmapping to be done in reverse order
(Last-In-First-Out). Currently we map vfrom and then vto, but unmap
vfrom and then vto, which is incorrect. This patch corrects it to
unmap vto first, then vfrom.

This issue was detected by the kmap_local_lifo.cocci semantic patch.

Fixes: 477a0ebec101 ("LoongArch: Replace kmap_atomic() with kmap_local_page() in copy_user_highpage()")
Co-developed-by: Claude claude-opus-4-20250514
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
  arch/loongarch/mm/init.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index c3e4586a7975..01c43f455486 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -47,8 +47,8 @@ void copy_user_highpage(struct page *to, struct page *from,
  	vfrom = kmap_local_page(from);
  	vto = kmap_local_page(to);
  	copy_page(vto, vfrom);
-	kunmap_local(vfrom);
  	kunmap_local(vto);
+	kunmap_local(vfrom);
  	/* Make sure this page is cleared on other CPU's too before using it */
  	smp_wmb();
  }
-- 
2.39.5


So, loongarch neither supports

a) Highmem

nor

b) ARCH_SUPPORTS_KMAP_LOCAL_FORCE_MAP, disabling DEBUG_KMAP_LOCAL_FORCE_MAP

Consequently __kmap_local_page_prot() will not do anything:

	if (!IS_ENABLED(CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP) && !PageHighMem(page))
		return page_address(page);


So there isn't anything to fix here and the whole patch subject+description should be
rewritten to focus on this being purely a cleanup -- unless I am missing
something important.

Also, please reduce the description to the absolute minimum, nobody wants to read the
same thing 4 times using slightly different words.

"LIFO ordering", "LIFO ordering", "unmapped in reverse order ... LIFO violation" ...
"reverse order (Last-In-First-Out)"


More importantly: is the LIFO semantics clearly documented somewhere? I read
Documentation/mm/highmem.rst

   Nesting kmap_local_page() and kmap_atomic() mappings is allowed to a certain
   extent (up to KMAP_TYPE_NR) but their invocations have to be strictly ordered
   because the map implementation is stack based. See kmap_local_page() kdocs
   (included in the "Functions" section) for details on how to manage nested
   mappings.

and that kind-of spells that out (strictly order -> stack based). I think one could
have clarified that a bit further.

Also, I would expect this to be mentioned in the docs of the relevant kmap functions,
and the pte map / unmap functions.

Did I miss that part or could we extend the function docs to spell that out?

-- 
Cheers,

David / dhildenb


