Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 787A2D35165
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 16:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666636B0005; Wed,  1 Apr 2026 12:42:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63DCA6B0088; Wed,  1 Apr 2026 12:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57A6C6B0089; Wed,  1 Apr 2026 12:42:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 475206B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 12:42:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 119D5BBC6D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:42:47 +0000 (UTC)
X-FDA: 84610555974.15.3571793
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6B4CD140016
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:42:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=gS1l8vrg;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf23.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775061765; a=rsa-sha256;
	cv=pass;
	b=4VlbyJFdbCp3JUwg/UIywmx7npUbapcRtZIXqZ3HzfuB3qsVLCGoAg4IQ5n6Y5QNvo1ruZ
	dL01zkCyzaBsQXNT4KU1jQb3gDszfAc/hm54qdt/HtR3zwggTAzif/Jpi4FavXkLdXd2ZA
	i21JsCRA/wZLpa0H4RiBB/stkXLjXm0=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=gS1l8vrg;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf23.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775061765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ee7IB3sG3A6o6v07YdioBswA142XX+M5oXr0+qG5dA=;
	b=UyPMtVGRmHTUreMC+PhBenaERCxvJgc2XMyNUpIYXK+9fAV2AN2W5xz84+HmT2BH2G7mb7
	p/VwDzpqTtPKjpyjuMzrXboGyMh6fVU0T8RYNrGnphdFEgY7UaVe+dfPtjvTkRwQrdeHGA
	xBNrhs4ndCNPfjzKVkOGauLwsvJCME4=
ARC-Seal: i=1; a=rsa-sha256; t=1775061750; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=bb/yXqq0bHQ2vuHknvY42FGP6fmIXNqy16FW33SjShUr8GibBPlxgYhY8LrF1k45pthJBVK5PRSIKgrj6Z7EHj86oLvEkcxD0VHlzOcI/U4l6rUTYDaQVViXPdcosQDSVG8TbWfGaIbK48JsvGVW0a9q8+tPosDWsDRUdUUGOCw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1775061750; h=Content-Type:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=8ee7IB3sG3A6o6v07YdioBswA142XX+M5oXr0+qG5dA=; 
	b=J4tLHYh5c0rQt1KMtV6MpOwcfLCOyRYcXsKTsP4JZCgTFttti5XveUIFNx5ZMahdQZ+rWs/Gyk354CddfV/FL3RAr68bnTXG98XQUHnHaVembCl19ILK944gfUR6hzkfyer29clYhz/LhnV2HdHeFjco9oUg2rg7AjZHQRFlTqI=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass header.from=<adi.sharma@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1775061750;
	s=zoho; d=zohomail.in; i=adi.sharma@zohomail.in;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-Id:Message-Id:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Reply-To;
	bh=8ee7IB3sG3A6o6v07YdioBswA142XX+M5oXr0+qG5dA=;
	b=gS1l8vrglnHM6ak5ftaiVCvipSDzmZZqJEmJspzXcVsEn1SuFRox2XOeg6NP7bXC
	1T/EAuh6AFhhmWtUauVkw0uvSICNXQuSRAR/zWlRrgS3SO7yxU6bGDjlUNj0G64L2ai
	JDCQbx+lfsAFcdmOHQlrld707XoGlLO+tTnvbI3Y=
Received: from mail.zoho.in by mx.zoho.in
	with SMTP id 1775061749709299.5877391692777; Wed, 1 Apr 2026 22:12:29 +0530 (IST)
Received: from  [14.139.128.34] by mail.zoho.in
	with HTTP;Wed, 1 Apr 2026 22:12:29 +0530 (IST)
Date: Wed, 01 Apr 2026 22:12:29 +0530
From: Aditya Sharma <adi.sharma@zohomail.in>
To: <david@kernel.org>
Cc: <linux-mm@kvack.org>, <akpm@linux-foundation.org>, <ljs@kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>,
	<linux-kernel@vger.kernel.org>
Message-Id: <19d49eccfcb.5f815dde233268.9181527708613952801@zohomail.in>
In-Reply-To: <db246b9b-2cc4-4aff-b92b-537ca27c47c0@kernel.org>
References: <20260331142936.229667-1-adi.sharma@zohomail.in>,<20260331142936.229667-1-adi.sharma@zohomail.in> <db246b9b-2cc4-4aff-b92b-537ca27c47c0@kernel.org>
Subject: Re: [PATCH] mm: update stale locking comment in do_anonymous_page()
MIME-Version: 1.0
Content-Type: multipart/alternative; 
	boundary="----=_Part_1219391_1416074881.1775061749707"
Importance: medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Stat-Signature: ta9wez4uzguond3rwwamxx3wga7kzfq5
X-Rspamd-Queue-Id: 6B4CD140016
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775061764-971231
X-HE-Meta: U2FsdGVkX1+iWOJOayvS56cxzSVkBqOelnX6cDTm4kKMkz177GEA45zvwQPP1mj8kohz3VvoQriCuzryXNcF+O5X6C21+EoP5v/hj9HOwavgduhy5ISCQN8633T+OloV+4vwWPeF7wfuVjrng1uqXx4Z6bQ6NbIGtdaiHviw7a4luoNQsgt6EaTaA+7lve3vYTi2Yjpjdo3IQhh4eGcppBRTY1HEhpTsCHzcj2WwV6ycHK89SWNR5qRIG51C0HTAIerTopvPOIEjTWf3mFeGwxB3Lew59fwrC8V01rccH0hd6lwkLOHUw1hEiGV/aBM4Qqb4P3HX+PdRFYFWkQ+3xWOems5sTtCsesrci9r5E0C4J9C9cy9FFzoKtB8eQ/h+OG3GRrWNYHE/icw0A6W42sGUWwpKqdc/zWXwtMtef6HlSuRZil6FhYfYSUrHzwEMuu7tDQsAti7Q9BJ3SvwT8YVApyWoPpItHSbG6geC3RARMxSVxfRFFOT5J90jbuwgdIs+EWEN84GeEcMlNAHTwzl22gN+Su/3iT1z21cmQPPLcsCwVKjXFQgkmVitqhijn4UiR0WV2t0m/yiC0vJnlW5zLEhBuRwShLPHiAVoPmB23d8d4K2DiZMOozdKa3NUHAlQLQHA66zj/RLSnxVvtPjzTsNge9MDnN8DLSb4hRMBfUPLVw2ipHxmX4OJs7CfTF+uopoX2UbpVrkYEWsl+fXmidJIj3innrQ27YM8kzroaETSzsqdyXW0sWxfsaMzboWH4XezRX6aTdQGC/Sn2r4CARqcSoqG6LSlcpgGjU3jJTOqdYsOhLhtJFbjh3kjs5qeH3c1Kgxf8GwZwk73LrIZHss/5IJwtxPuWYXtdEhpsmW7DHAFtajB1kY+8s2U9+I/e/CNf3fCZWlasxTceJCg9F0B5V8+tZJnaThjhotekkmIJhrzxQRvZ7KARpJz6FPUyPyW1lGRXjJZcnI
 d8Sml6QB
 npybAsQgaKWsBLCLowwa0C+iRSf3wOh3o6J6DAffWeTUn8ZFxDI5zYWtctkf3cfopWC/LsEuRVr/rmEaMT/Zopg66Fd1EWq/cVx7b5IeCi+cXACnuMWyhD7SCVQ8cG4nBJYRc4m4gKFY9nKbbHSP/PTEccXkzohMoSwnpC8mvodNdStZAI6ZwbuHbCHoUv1klJ8SmO8Su9WTOVXJIQ/b25YKL9TywP+XCHrwSG5CkP25uAWEdRVw+9NrzBcPNk+RIFaao5Zllw+OFUuiwsXJQzR4r6D45Rd+sZtuFpEf+Yxl/7tz27O9hpGMAdrrHeM7RZ7HwpFW0xGTXxfvYzUtqcnjaxo7zuGZhGMK978xHr7gAD4W2wQDI937JHMwrMuEUzXw8jeQMDNpQCmVpk0XSvp48wmXcINar1j1wdLDtnA7f5nGwIu6KkE84P0yYRwIa6ApEE7aoiEXviu9MxwwQ7R5bbhG8J8ysgUtiScsA811wpOYJrIjkqUVN4XQvn602p2dvTtgP3n9aUuLm8n/o46bkAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

------=_Part_1219391_1416074881.1775061749707
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Sorry about that. The comment was AI assisted and probably too long. I had this confusion myself spending half a day debugging only to realise that the comment was stale. Will send an updated patch with a concise comment



Aditya





---- On Wed, 01 Apr 2026 16:22:17 +0530 David Hildenbrand (Arm) <david@kernel.org> wrote ----



On 3/31/26 16:29, Aditya Sharma wrote: 
> The comment above do_anonymous_page() dates back to 2005 and describes 
> the pre-per-VMA-lock world where mmap_lock was always held on entry. 
> Since CONFIG_PER_VMA_LOCK was introduced (6.4), the fault handler now 
> has a fast path that enters holding only a per-VMA read lock, with 
> mmap_lock not held at all. 
> 
> Update the comment to describe both entry contexts accurately. 
> 
> Signed-off-by: Aditya Sharma < mailto:adi.sharma@zohomail.in > 
> --- 
>  mm/memory.c | 22 +++++++++++++++++++--- 
>  1 file changed, 19 insertions(+), 3 deletions(-) 
> 
> diff --git a/mm/memory.c b/mm/memory.c 
> index c65e82c86..cc8dbbaea 100644 
> --- a/mm/memory.c 
> +++ b/mm/memory.c 
> @@ -5210,9 +5210,25 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf) 
>  } 
> 
>  /* 
> - * We enter with non-exclusive mmap_lock (to exclude vma changes, 
> - * but allow concurrent faults), and pte mapped but not yet locked. 
> - * We return with mmap_lock still held, but pte unmapped and unlocked. 
> + * We enter in one of two locking contexts: 
> + * 
> + * 1) VMA lock path (FAULT_FLAG_VMA_LOCK set): 
> + *    Entered holding a read lock on the faulting VMA (vma_start_read), 
> + *    but NOT holding mmap_lock. This is the fast path introduced with 
> + *    per-VMA locking (CONFIG_PER_VMA_LOCK). If this function cannot 
> + *    complete the fault (e.g. needs to wait on I/O or encounters a 
> + *    condition requiring the mm lock), it must return VM_FAULT_RETRY 
> + *    and the caller will fall back to the mmap_lock path below. 
> + * 
> + * 2) mmap_lock path (FAULT_FLAG_VMA_LOCK not set): 
> + *    Entered holding a non-exclusive (read) lock on mmap_lock, which 
> + *    excludes VMA tree modifications but allows concurrent faults on 
> + *    other VMAs. No per-VMA lock is held. 
> + * 
> + * In both cases, on entry the pte is mapped but not yet locked. 
> + * On return, the pte is unmapped and unlocked, and whichever of 
> + * the above locks was held on entry is still held (mmap_lock is 
> + * not dropped, VMA read lock is not dropped, rather, the caller releases it). 
>   */ 
>  static vm_fault_t do_anonymous_page(struct vm_fault *vmf) 
>  { 
 
Was this AI generated? 
 
I don't think we want to have such a wall of text for each and every 
function that can be called with VMA lock or mmap lock in read mode. 
 
-- 
Cheers, 
 
David
------=_Part_1219391_1416074881.1775061749707
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"><html><head>=
<meta content=3D"text/html;charset=3DUTF-8" http-equiv=3D"Content-Type"></h=
ead><body ><div style=3D"font-family: Verdana; font-size: 11pt;"><div dir=
=3D"ltr" style=3D"text-align: left;">Sorry about that. The comment was AI a=
ssisted and probably too long. I had this confusion myself spending half a =
day debugging only to realise that the comment was stale. Will send an upda=
ted patch with a concise comment<br></div><div dir=3D"ltr" style=3D"text-al=
ign: left;"><br></div><div dir=3D"ltr" style=3D"text-align: left;">Aditya</=
div><div><br></div><div data-zbluepencil-ignore=3D"true"><div><br><br></div=
><div class=3D"replyHeader">---- On Wed, 01 Apr 2026 16:22:17 +0530 <b>Davi=
d Hildenbrand (Arm) &lt;david@kernel.org&gt;</b> wrote ----<br></div><div><=
br></div><blockquote style=3D"margin:0 0 0 0"><div>On 3/31/26 16:29, Aditya=
 Sharma wrote: <br>&gt; The comment above do_anonymous_page() dates back to=
 2005 and describes <br>&gt; the pre-per-VMA-lock world where mmap_lock was=
 always held on entry. <br>&gt; Since CONFIG_PER_VMA_LOCK was introduced (6=
.4), the fault handler now <br>&gt; has a fast path that enters holding onl=
y a per-VMA read lock, with <br>&gt; mmap_lock not held at all. <br>&gt; <b=
r>&gt; Update the comment to describe both entry contexts accurately. <br>&=
gt; <br>&gt; Signed-off-by: Aditya Sharma &lt;<a href=3D"mailto:adi.sharma@=
zohomail.in" target=3D"_blank">adi.sharma@zohomail.in</a>&gt; <br>&gt; --- =
<br>&gt;  mm/memory.c | 22 +++++++++++++++++++--- <br>&gt;  1 file changed,=
 19 insertions(+), 3 deletions(-) <br>&gt; <br>&gt; diff --git a/mm/memory.=
c b/mm/memory.c <br>&gt; index c65e82c86..cc8dbbaea 100644 <br>&gt; --- a/m=
m/memory.c <br>&gt; +++ b/mm/memory.c <br>&gt; @@ -5210,9 +5210,25 @@ stati=
c struct folio *alloc_anon_folio(struct vm_fault *vmf) <br>&gt;  } <br>&gt;=
 <br>&gt;  /* <br>&gt; - * We enter with non-exclusive mmap_lock (to exclud=
e vma changes, <br>&gt; - * but allow concurrent faults), and pte mapped bu=
t not yet locked. <br>&gt; - * We return with mmap_lock still held, but pte=
 unmapped and unlocked. <br>&gt; + * We enter in one of two locking context=
s: <br>&gt; + * <br>&gt; + * 1) VMA lock path (FAULT_FLAG_VMA_LOCK set): <b=
r>&gt; + *    Entered holding a read lock on the faulting VMA (vma_start_re=
ad), <br>&gt; + *    but NOT holding mmap_lock. This is the fast path intro=
duced with <br>&gt; + *    per-VMA locking (CONFIG_PER_VMA_LOCK). If this f=
unction cannot <br>&gt; + *    complete the fault (e.g. needs to wait on I/=
O or encounters a <br>&gt; + *    condition requiring the mm lock), it must=
 return VM_FAULT_RETRY <br>&gt; + *    and the caller will fall back to the=
 mmap_lock path below. <br>&gt; + * <br>&gt; + * 2) mmap_lock path (FAULT_F=
LAG_VMA_LOCK not set): <br>&gt; + *    Entered holding a non-exclusive (rea=
d) lock on mmap_lock, which <br>&gt; + *    excludes VMA tree modifications=
 but allows concurrent faults on <br>&gt; + *    other VMAs. No per-VMA loc=
k is held. <br>&gt; + * <br>&gt; + * In both cases, on entry the pte is map=
ped but not yet locked. <br>&gt; + * On return, the pte is unmapped and unl=
ocked, and whichever of <br>&gt; + * the above locks was held on entry is s=
till held (mmap_lock is <br>&gt; + * not dropped, VMA read lock is not drop=
ped, rather, the caller releases it). <br>&gt;   */ <br>&gt;  static vm_fau=
lt_t do_anonymous_page(struct vm_fault *vmf) <br>&gt;  { <br> <br>Was this =
AI generated? <br> <br>I don't think we want to have such a wall of text fo=
r each and every <br>function that can be called with VMA lock or mmap lock=
 in read mode. <br> <br>-- <br>Cheers, <br> <br>David <br></div></blockquot=
e></div><div><br></div></div><br></body></html>
------=_Part_1219391_1416074881.1775061749707--


