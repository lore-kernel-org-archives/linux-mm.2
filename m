Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F322AC87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 15:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E1B36B00A1; Fri,  8 Aug 2025 11:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B9D66B00A2; Fri,  8 Aug 2025 11:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CFB56B00A3; Fri,  8 Aug 2025 11:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C5B46B00A1
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:55:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 23B9A115959
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:55:54 +0000 (UTC)
X-FDA: 83754041028.10.957311C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 894FB20003
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:55:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bIBm+3A0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754668552; a=rsa-sha256;
	cv=none;
	b=Xg+/NQWcyMP+GUF2xMd4GI5TN+vcdTxzybUFwul4vY7w/+VZyzxJQqELOVrk7yQ/nz+WYT
	ZoIYNDz8A76r/vIbVozeKHjnfv0ozJK8io7Yb76KhKh4oSIAIxCZuc7w2XuzE2kHv1N5fh
	saTwU7bConGjFovymEZhdsqzpplTYUA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bIBm+3A0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754668552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qprk79rAX7DsdQZEG0BjTWwEshvWc03Sj1P9nLRIia4=;
	b=qedmrntikSTphpUq6WDdlLnqvTwhoA+0OHHJ5idIeczI+WBboniVBded7jwmDnJBYa70QV
	SxtuCKTZXYnXgeR6pdEJdM5Skq5A95jPXEuXKAr928q8pa1yKHHGad4MfRKMktKo+d7rwc
	lFvwlKp2so+LIkEhAjOBU3k4qxnzWp4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B1E9A601ED;
	Fri,  8 Aug 2025 15:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28054C4CEED;
	Fri,  8 Aug 2025 15:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754668551;
	bh=OcaDToPvu/EEOBIvyPIc8Gm5Mu+wySbfvpWzqrlXL+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bIBm+3A0Klj5Sv82WBkHb1TqKpq3M+wIq+lrWhvnofEF4mnMJQK9E1iVE3clQxS0P
	 9vmPwj+SQV7+4YUTsz3LJam4wh9+Vr9X0onjpO5PLxD04uTwL96IfcnRMFD//eYmhO
	 ULtzLOlIDMgFQ0r3M42O8QMHmo4Ed9gZrbIUrqRmhnhafepNQ8IiiQNOb7UunVsTMy
	 fuMi0LAVkhA7/K3iYRtCcdUU4ksvSKq0g0OyoGaqBqgGrEkxR1nD2Mz5l806nENWSp
	 n4Dk98zSKYakyYQsXgclRWUOaznM7r49o6rP32FS04CnknpBSlEZCrV4ez9rX1qjSg
	 TfNj9ppmTL5GQ==
Date: Fri, 8 Aug 2025 11:55:49 -0400
From: Sasha Levin <sashal@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com,
	aarcange@redhat.com, surenb@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: fix missing PTE unmap for non-migration
 entries
Message-ID: <aJYeBbkHsDECexWN@lappy>
References: <a4d8b292-154a-4d14-90e4-6c822acf1cfb@redhat.com>
 <aG06QBVeBJgluSqP@lappy>
 <a8f863b1-ea06-4396-b4da-4dca41e3d9a5@redhat.com>
 <aItjffoR7molh3QF@lappy>
 <214e78a0-7774-4b1e-8d85-9a66d2384744@redhat.com>
 <aIzAj9xUOPCsmZEG@lappy>
 <593b222e-1a62-475c-9502-76e128d3625d@redhat.com>
 <aIzPPWTaf_88i8-a@lappy>
 <aJUDqqjCycGDn1Wg@lappy>
 <5b9c775c-35a1-4cd6-8387-00198e768b9a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5b9c775c-35a1-4cd6-8387-00198e768b9a@redhat.com>
X-Stat-Signature: f7k53qk6sqce6si8eaucxgtf3y45w8t3
X-Rspam-User: 
X-Rspamd-Queue-Id: 894FB20003
X-Rspamd-Server: rspam02
X-HE-Tag: 1754668552-207396
X-HE-Meta: U2FsdGVkX187xGH1XLZ4DAQDV13JxaKVYbNibi1gLScwjv1EEflv5+Hk0JTexC8Eh08iqpx2rsJES9V1dGJS0muKNrSreryzbpsov3bhKzDovuIAutimaQuoeVFIr870dzlQRs96ab8+aFo/WP/b4iRYDGobRz/F+2L+E8APuBhGmRLWbHbrH/CTPRv10U6pPMX1vOOVQv4irqTsWI3gYoCCGaotsIDYLqjxR5q4Bdc+dpBV+6LivcO2h3EA5GVs3AYPt1oS8vpIFpeTMJdS058I4MKffeF1QbgNpx+AVhaGmKN4M3S4tzVqCX0vI5FoVpJzLuTE+OZWxvz/QHuGP8g4iLlpUI8vJcj3+AuklSSeZ927Qx31v7xRKbUAlFLFcrgFpvWZuIm5Q73x2UPUIJYvQ4KrauXUDZSfH4uJ73abDy3NIQBOl7Is32/o7X+Vgep+A/KSpjLObB35vyuPbmNodz7m+FWex1ou/xCQPbQnXWOY/rXoSV2oqfCjdF3f+gf0A7Jy1BvEGUHL2MLnnclJiU6eLhE8kV/UwlLI/7NIxb4q+CmEqkcF/W9t9ZYohdtjhy9GN+3XA0R/J2woQZDIYjCc8sdXER/o6XBD3yckY9+p63qZwdBrEoMVGPkp1sVusVyZnK/e2TuW3vXlP0gfKID21QaLZRv0W14bGFvFR7QeAyN7TzQZmz3ugMb9L2Y44I1b4EEEahOAm2FL3V90wd6iXtdTdhdLsQZJiAd7tSP+zzvPehJZ9ZwGSa/ZLrXNqLectCpu1kQu1HBhyAI+bso0GphNC3vgB76gdZoBefQ3kg+/LL6iiGVi0WOzAKjVa7U1xkihfKjw63ooPCaWwY7XouUYM30DIK28BR3BA5e7z3y4G6/lVoxgTwKqK7TTssVnelCWNoHX14oLIjOV8nyOijBa5/XJH+I8a1dHjGQAcTh1lOWc5+8MWRDhg1rGDMmLwfa5gmAR3Yt
 qstnqLe2
 byih++HWpHrKC4ZethkAiWyglR00VebYNc+ZSENMw2QLy/RZ7DFrd+VHzKVRNHuDY1hOyNUxlhI1zBzMI4OBMxYOcIUFxHLIPGgZBmmfFyB3USpHpEhYZtVQMB8Ge46roBrKeN8lEyb4WqMH1NKkrzVW5hhhAtWyRDaP/hN5itwLgH8P8PKlbdKRGG3zQSeZcUxINycOOgEh1H2jaZL14vAW75B5lLWQ6nqNC5h0JfT2Y9UK+7lHJ439SbRXHMgXo7G7GCyuMIFrfq8ao/G9XGTI8wg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 08, 2025 at 10:02:08AM +0200, David Hildenbrand wrote:
>On 07.08.25 21:51, Sasha Levin wrote:
>>On Fri, Aug 01, 2025 at 10:29:17AM -0400, Sasha Levin wrote:
>>>On Fri, Aug 01, 2025 at 04:06:14PM +0200, David Hildenbrand wrote:
>>>>Sure, if it's prechecked by you no problem.
>>>
>>>Yup. Though I definitely learned a thing or two about Coccinelle patches
>>>during this experiment.
>>
>>Appologies if it isn't the case, but the two patches were attached to
>>the previous mail and I suspect they might have been missed :)
>
>Whoop's not used to reviewing attachments. I'll focus on the loongarch patch.

Thank you for the review!

>From a547687db03ecfe13ddc74e452357df78f880255 Mon Sep 17 00:00:00 2001
>From: Sasha Levin <sashal@kernel.org>
>Date: Fri, 1 Aug 2025 09:17:04 -0400
>Subject: [PATCH 2/2] LoongArch: fix kmap_local_page() LIFO ordering in
> copy_user_highpage()
>
>The current implementation violates kmap_local_page()'s LIFO ordering
>requirement by unmapping the pages in the same order they were mapped.
>
>This was introduced by commit 477a0ebec101 ("LoongArch: Replace
>kmap_atomic() with kmap_local_page() in copy_user_highpage()") when
>converting from kmap_atomic() to kmap_local_page(). The original code
>correctly unmapped in reverse order, but the conversion swapped the
>mapping order while keeping the unmapping order unchanged, resulting
>in a LIFO violation.
>
>kmap_local_page() requires unmapping to be done in reverse order
>(Last-In-First-Out). Currently we map vfrom and then vto, but unmap
>vfrom and then vto, which is incorrect. This patch corrects it to
>unmap vto first, then vfrom.
>
>This issue was detected by the kmap_local_lifo.cocci semantic patch.
>
>Fixes: 477a0ebec101 ("LoongArch: Replace kmap_atomic() with kmap_local_page() in copy_user_highpage()")
>Co-developed-by: Claude claude-opus-4-20250514
>Signed-off-by: Sasha Levin <sashal@kernel.org>
>---
> arch/loongarch/mm/init.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
>index c3e4586a7975..01c43f455486 100644
>--- a/arch/loongarch/mm/init.c
>+++ b/arch/loongarch/mm/init.c
>@@ -47,8 +47,8 @@ void copy_user_highpage(struct page *to, struct page *from,
> 	vfrom = kmap_local_page(from);
> 	vto = kmap_local_page(to);
> 	copy_page(vto, vfrom);
>-	kunmap_local(vfrom);
> 	kunmap_local(vto);
>+	kunmap_local(vfrom);
> 	/* Make sure this page is cleared on other CPU's too before using it */
> 	smp_wmb();
> }
>-- 
>2.39.5
>
>
>So, loongarch neither supports
>
>a) Highmem
>
>nor
>
>b) ARCH_SUPPORTS_KMAP_LOCAL_FORCE_MAP, disabling DEBUG_KMAP_LOCAL_FORCE_MAP
>
>Consequently __kmap_local_page_prot() will not do anything:
>
>	if (!IS_ENABLED(CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP) && !PageHighMem(page))
>		return page_address(page);
>
>
>So there isn't anything to fix here and the whole patch subject+description should be
>rewritten to focus on this being purely a cleanup -- unless I am missing
>something important.
>
>Also, please reduce the description to the absolute minimum, nobody wants to read the
>same thing 4 times using slightly different words.
>
>"LIFO ordering", "LIFO ordering", "unmapped in reverse order ... LIFO violation" ...
>"reverse order (Last-In-First-Out)"

How about something like:

     LoongArch: cleanup kmap_local_page() usage in copy_user_highpage()
     
     Unmap kmap_local_page() mappings in reverse order to follow the
     function's LIFO specification. While LoongArch doesn't support
     highmem and these operations are no-ops, code should still adhere
     to the API requirements.
     
     Detected by kmap_local_lifo.cocci.
     
     Fixes: 477a0ebec101 ("LoongArch: Replace kmap_atomic() with kmap_local_page() in copy_user_highpage()")
     Signed-off-by: Sasha Levin <sashal@kernel.org>

>More importantly: is the LIFO semantics clearly documented somewhere? I read
>Documentation/mm/highmem.rst
>
>  Nesting kmap_local_page() and kmap_atomic() mappings is allowed to a certain
>  extent (up to KMAP_TYPE_NR) but their invocations have to be strictly ordered
>  because the map implementation is stack based. See kmap_local_page() kdocs
>  (included in the "Functions" section) for details on how to manage nested
>  mappings.
>
>and that kind-of spells that out (strictly order -> stack based). I think one could
>have clarified that a bit further.
>
>Also, I would expect this to be mentioned in the docs of the relevant kmap functions,
>and the pte map / unmap functions.
>
>Did I miss that part or could we extend the function docs to spell that out?

The docs for kmap_local_page() seem to cover it better, and give the
concrete example we're trying to fix here:

  * Requires careful handling when nesting multiple mappings because the map
  * management is stack based. The unmap has to be in the reverse order of
  * the map operation:
  *
  * addr1 = kmap_local_page(page1);
  * addr2 = kmap_local_page(page2);
  * ...
  * kunmap_local(addr2);
  * kunmap_local(addr1);
  *
  * Unmapping addr1 before addr2 is invalid and causes malfunction.

-- 
Thanks,
Sasha

