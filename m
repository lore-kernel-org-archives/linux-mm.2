Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11381FF8850
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 03:39:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E0F26B0005; Sun, 26 Apr 2026 23:39:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1918B6B0088; Sun, 26 Apr 2026 23:39:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A8406B008A; Sun, 26 Apr 2026 23:39:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFF546B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 23:39:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F348C251F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:39:20 +0000 (UTC)
X-FDA: 84702930480.22.5C0F41F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id B6A4D1C0008
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:39:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=a7iLWY4Q;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777261158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G8JsllKxdAVln1wctaIpFX3+UWglY9rl9ieIEPiagB4=;
	b=71f1eE4xkwsgLsk3/ExiTFI7N7sYWnO6O7hAqkMM8sBB+Le/8ZK2hNlLSQp2EOLJi2t/GH
	4fUR8pDLMru05WfH8QMzwERbqVyiIk/1PLaDZBEe3Dfpm1OypGCTi6s5eqQO88Us4Tku6v
	4fOrzwUIQVTfw7Rc+uNoW629ZM2rnsE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=a7iLWY4Q;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777261158; a=rsa-sha256;
	cv=none;
	b=KqsNQZ1f+hsVeQNlSwMKmJfFa5y8tWde9v16QbhT9Z3bro/E/Tq9rpmjmbMwdTpgH3DSNd
	pYdtipWRJNpLMvsxpwxFBwFuKGWz0TgHUK7WUie/4m3LVYe/C/5WR1gD/W53fjMVGBTzAs
	fIuLdvJ6bqH1LgFrThQImFC+H7FDz5Y=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 18B641684;
	Sun, 26 Apr 2026 20:39:12 -0700 (PDT)
Received: from [10.164.148.37] (MacBook-Pro.blr.arm.com [10.164.148.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 956BF3F763;
	Sun, 26 Apr 2026 20:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777261157; bh=LCn0RaEC1G+RSX7YHBiuKpju1CY4aw/B8Hwl6UvdVVs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a7iLWY4QB8QkFuzmIeDOuDWqi+s4PDrdRofCrcgpwk7g0s79ucMCB53kHVem1hj2T
	 pSQCImk33dpBgQBRs2a5GPjNO98tgnqSqiwrUjeWuJ5Tt9BG/N4hCvQsUw154sQYGh
	 pPozkR//I3ob+wI5OyOxh8kYU1kfwlNXCDM5b8RY=
Message-ID: <440a7ae5-7070-46d2-8644-3fc2fa6a707f@arm.com>
Date: Mon, 27 Apr 2026 09:08:53 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] vmalloc: add __GFP_SKIP_KASAN support
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: arnd@arndb.de, kees@kernel.org, mingo@redhat.com, peterz@infradead.org,
 juri.lelli@redhat.com, vincent.guittot@linaro.org,
 akpm@linux-foundation.org, david@kernel.org, urezki@gmail.com,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, tglx@kernel.org, usama.anjum@arm.com,
 mathieu.desnoyers@efficios.com, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <20260424130157.3163009-1-dev.jain@arm.com>
 <20260424130157.3163009-2-dev.jain@arm.com> <aeyF-pEruWRMk5bS@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aeyF-pEruWRMk5bS@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B6A4D1C0008
X-Stat-Signature: qgpi96d5g9m1h1fcpyj88ecema5cjjbo
X-HE-Tag: 1777261158-722412
X-HE-Meta: U2FsdGVkX1/PRMurPQ7zYrIAwujbesB/Ft2F8DlXAeDMjgI/knH0FvsDrFl3QtTGlm1Ci/Zl8v3uLq8X79Zi2kE2JCnD9+ZTFZ3z5PhadZEZwxeJogdBGs/JpVUralQ7H02sXtQgXg9y83o1hlIFPuhqbm2ji6SCAu5UC9JlPRMibGv87k6q6cOetXIfAsNQgRpy4+VKOA0dlPMcAaVPz10X8MoK/Xw0VKu1nylhKDh3n6IC01tkkqO9RBPJkkBW/VJ6y/ogki/U8IB2VVu2g+qmXASyDfFd7skZe1cdQLO8eW51oyBQO7oHOtWxfcth80bSp12pcFDO6BFO47NBWwtAwUNKYwkEtnyadC9lT45jdspYVI85ovKXqgPmljnqwnAVgWS1RA75lk8bVnUFpy9ctmlwFirMC5ZfLojLUmi6vRFAigokpekPbEfE7JCdvzthbiIrZBwxz46fnBHk+M9urY82y0nZ17MEdvNkcc41Q0BH/+5ribeuMD0lxnb4Dab/bxW07uApTtyJ0dIWKmcYaaKTAXye/I+TK92AHEPcTBUK0deJGn817fLR8ONNRckvU0GymJ9mCGeNG6kJ6zHxo0x6O+QNdpR3DJGfORNi85/SJapW2Fg24onpv68W/4XhRZuXRjUY7T3c2ru5h2Oal8SQ5fKUE/gP77iIYC0RpxMCWrXhDJZgMB8zwh89IIQZCxtiLLiwdAlPvgb5Ay7OoIzSdrEeV/SkiekeJRk6ex5qu1f4+vPmXCocSBZGuQ2y+C6uNclvThAeEdlZNkGbACyePW2rgKIoZ5viXhQ9yU6F7ZMT6d7drIC198TaPrABfuexIF5Qw+T6p7fk48vVAcFVQJEMpyb8x84LNbplqgZ3dQdh3LMraCKgAjMo8jbXHh8A5TLwhC/iwpLdF5P1bRLH5K2zKqUPdl0jkLa/ROIW7rwdPpkBSRqkX7icpe0rvxm4vkrsyVuhds9
 eVJj0YBO
 K1yRdZcEYN3ZblnJJ7vEGtG90QC8IdBRlYP7xxYs8tShOX2Br4S8bvsHNKjHxG49WKpnFrh4499kCAkp986fXgNrmXoMF1H1G/3IXUIjJgKPl35EM/L8F0MofH00pTiqvUWiozBGlfcUODpIFtQ9jyl5pdr8Tbs725rIByd38WK1OEW6I9W2s4SD2wAINrn2t4ImyOdV5mIe4zLY+Nnkk46PY610lA0/6jcTv6oPYl7OjEOPJZW+O8CR3cOpTe/BTcazZo8ADdWje+zRrX0Jtq8bd0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/04/26 2:44 pm, Catalin Marinas wrote:
> On Fri, Apr 24, 2026 at 06:31:55PM +0530, Dev Jain wrote:
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index b31b208f6ecb3..c94fcb2725b6b 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -3939,7 +3939,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>>  				__GFP_NOFAIL | __GFP_ZERO |\
>>  				__GFP_NORETRY | __GFP_RETRY_MAYFAIL |\
>>  				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
>> -				GFP_USER | __GFP_NOLOCKDEP)
>> +				GFP_USER | __GFP_NOLOCKDEP | __GFP_SKIP_KASAN)
>>  
>>  static gfp_t vmalloc_fix_flags(gfp_t flags)
>>  {
>> @@ -3980,6 +3980,9 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
>>   *
>>   * %__GFP_NOWARN can be used to suppress failure messages.
>>   *
>> + * %__GFP_SKIP_KASAN can be used to skip unpoisoning of mapped pages
>> + * (when prot=%PAGE_KERNEL).
> 
> I just realised, if we go with this flag for vmalloc(), there's also a
> comment in gfp_types.h implying that pages are unpoisoned by
> kasan_unpoison_vmalloc() instead. This is no longer the case with this
> patch.
> 
> A VM_SKIP_KASAN flag may have been nicer but we already have
> THREADINFO_GFP and GFP_VMAP_STACK, so all those call sites would have to
> be moved to call the lower-level __vmalloc_node_range().

Yep we were discussing this only on v2, and realized the wider cleanup
is not trivial and should be made separately.

But I should change the documentation of GFP_SKIP_KASAN to say that
if it passed on to vmalloc then it will also skip unpoisoning.

> 


