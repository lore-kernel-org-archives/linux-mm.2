Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB7F7FEE4F0
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 21:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98DA66B0005; Sat, 28 Feb 2026 16:27:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93B1B6B0089; Sat, 28 Feb 2026 16:27:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 847596B008A; Sat, 28 Feb 2026 16:27:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6F4BB6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 16:27:03 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C8CE1B741C
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 21:27:03 +0000 (UTC)
X-FDA: 84495150726.10.E343F80
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3D52A20007
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 21:27:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d1g1ZRO0;
	spf=pass (imf13.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772314021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3u+tbCKuiO12lFJH2PgWftBt3LrL7T3icieNzOkjqcE=;
	b=0hizfQvIeCzUaQ2ss5oBUP2zzm5iWcq4nxHpY0iWxmqPSivgELghXO22UfpMqeqFFOsF0U
	2hxvPge50VZopGG/Hd6D+/QeDjY2XUpnwJ3YkaCYF4F6baQ2ljhR+oOV/MB/uzQiD49eui
	6MeN8rXIUnNX2nS5B8k3knmLw2zH7SA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772314021; a=rsa-sha256;
	cv=none;
	b=2YhOncZY97f2glMI74CV2m1nEV/iXWP6JOhf3T25GpEVCu1rpc4HCUqtHW3EcdNxOj6WyS
	DbhDD0Nqwu2Cl8utV7fkTg3ssJr+Y6kMRnjBpRv0UK/4CpQzR+M0A+p7daw8jKpz+Cd1dd
	a0jrJ7/Qx4jU2k5oTqGyqKZ1cCR8/Aw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d1g1ZRO0;
	spf=pass (imf13.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2aaf5d53eaaso22219905ad.0
        for <linux-mm@kvack.org>; Sat, 28 Feb 2026 13:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772314020; x=1772918820; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3u+tbCKuiO12lFJH2PgWftBt3LrL7T3icieNzOkjqcE=;
        b=d1g1ZRO0AmtPjyDBJKQLqpwfmUa7jz9AZhCsjSFhBNcG09Pm34gX6RysofRTkcM9Bk
         YaHZtL5+89z26blGRK0As/pkag33FEaIlx9O4+79Qz82JI0VPCviiRn33ATo8ziugc3P
         OVaZsCqcOvZTtKVw+gWVWF1pkDAbi+Wp3EfxPosqV9Aeei7d7Uq+GH7iV/f7pR6GgfvG
         c392yXfsXMrf1AircRRqDtdA5kpt1FA/ur/0hlHBYxuUv6lMR4IWC3wW3kVXOayjM+us
         Qcf6qo9dYSUnnXOE0nvCO4Xmxi4t0CqvCK3VXPh7Gm1WkgXe+GeQRETiJO3C3X1obKeK
         +yHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772314020; x=1772918820;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3u+tbCKuiO12lFJH2PgWftBt3LrL7T3icieNzOkjqcE=;
        b=we6twJc9qo0Xock/kR74qZHLgJG7csTaCq/yKa32fBy6IBdTa53B9UyUwjVoTPiBl/
         971XYcgVweeCCamdlEHflVg2h8LpMcIt4rj26EF72Yb8vl5mypcxMUkyMH4XnpbGYGYG
         7zkOakYyoxQDE4rGi+GD4fsqxzycF4MugaZxXMbYBy03k69EjzO+whSLlhpb/HPabveP
         0sA2juvLxDQd9ehlHGWHiIkhHsGY96bKQiVdDdgQ5lQBD5NQcilfsgHv/y+xwWRnDxPx
         uh/6kMK5BVYHvpqPhjJLQ5tyIPt7vzbuuVSx9paZ30IIJO1bfY4S7aH0qFsOrs8wMU75
         A32w==
X-Gm-Message-State: AOJu0Yyz8C0tIO53OsTUnp5rJskrw73/jz+yFzVnGyTun5O+nHZpYpR0
	K/NlQ6G0hDPP0n/2mpf9VgCsiFk64kCI0kJr+zYO+CV83WB8iwyjfebW
X-Gm-Gg: ATEYQzxx4ksLbG+rd8T9YPtAf/3zASjmAJyzQwiofM0vks3QpYJI4YRlVUGHUmWRL9v
	j+KxVMvg5uEey4iC6z01KtIUVaMx42kt7lnySrYtW75Wl7koBrB6VHwJZAEFBHs+kWv0XFUtd+I
	RsVU3z2I18aRXGd6YP6SjW5m7+a4au5gBWDpGNi9Z3yX9AHUJYkAQk8bA3H242IobAw3Mim9do2
	Hl9CfgtB8JlAcDyFYpWltp/pvKdunU26C0PeceLt027Pp4R7KgChE9MjTCDOhZ8zsUpVsfbiSuI
	9OvQdLiqtESnzB+17aqKGeDz33u7NGLJKVsx6qUuTPpdDoACE9TSryYDeOffzeQxL37PLCk/Fzp
	ccSIoH2m6utuAAa09f5YRxsJeyTSVxyABF1rz5+fNLZYxkUwEc6+xl1a78JMHrYk+TqgH/QQ9qM
	xUtZKUV+sTSq6EH4xc
X-Received: by 2002:a17:903:1aad:b0:2aa:ecec:a43d with SMTP id d9443c01a7336-2ae2e401f52mr62465095ad.21.1772314019931;
        Sat, 28 Feb 2026 13:26:59 -0800 (PST)
Received: from dw-tp ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae3e4e34e6sm26334335ad.30.2026.02.28.13.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Feb 2026 13:26:58 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org, kvm@vger.kernel.org, Alex Williamson <alex@shazbot.org>, Peter Xu <peterx@redhat.com>
Subject: Re: [RFC v1 2/2] powerpc/64s: Add support for huge pfnmaps
In-Reply-To: <87pl5qh3ye.ritesh.list@gmail.com>
Date: Sun, 01 Mar 2026 02:44:32 +0530
Message-ID: <87tsv0in9j.ritesh.list@gmail.com>
References: <0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list@gmail.com> <d159058a45ac5e225f2e64cc7c8bbbd1583e51f3.1772170860.git.ritesh.list@gmail.com> <abfbe83b-23fb-400d-9069-b8bf4ad21d95@kernel.org> <87pl5qh3ye.ritesh.list@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1ecsffy1yotznznazctqtwtzy9tak1ie
X-Rspamd-Queue-Id: 3D52A20007
X-Rspamd-Server: rspam03
X-HE-Tag: 1772314021-155150
X-HE-Meta: U2FsdGVkX1812wN739sdHap17Sb9J66zGHMk5IBp8oGSm6uWVgsSwOZhTKl7wXQ5UVcJua0+OlSu/LL4GcomCSb/Qq/RIt00mWtW35Ufl0DP2rItSgOnPQ/gzINykdTs2FK4RbC7SGz+0RWcXGH9JLEaMX7lZDXR4h4J5pgEavpky8V/1udzx94yCDnCTMiZ+gu14TIo57257Z2rYKcaFWGuz14Nh5HALA0R/EDzB/iaxHEuMr/XmZZuhlcdC/UW1HXgitQvgc8zbGe/rqrQjFu/lyMpLtKGaH2XTLxu/Mx4Rue9PcH3ho+fM+fyt1fd4WA9E0qsOPjS8HtjoVbv/Dp5zRWicXQ4D04dI1VelkfNKWivlsbDAQJkeLNB226GI/afYolA9tMB4kEyqZtaW0MJTtGFOBU11XgSYETV0qDRXDEib427ye2+2CbJv4Muk9YPpwnSEO01Kjsx3TvfvldFY+wYnoi4se8DMz/yg2VucZ36YFOO7azY5Ruz/J3L6s8o4Xw9O2Js4K0Htbjg/xFphSi+bjWfHk74biioAxNsRXSPyfskZTVLUPlzBrz5QIAWfdTf45x93N45ir9Yu1BpEskJYVwW3ghYu8QN9cA/hL/aIl9Ww6g4ef682XHYsPnAOMklldZn992NhOiQosojemJLOQwgau2buAPmXCkptjd7euu7VHRRsMZeC/bAI8vgNTWPJyQLysuOYcgVBWQBO95QwR/siAiZUYC+c3/j8nzpmb5O7Ad1bE87pHYlZ5MGYnkhScdhUbNZ+oumZctv3dvmuET9xjPRoP3CJW/A/clEizGQDnJ4ULA/PM3vNriYHFtterZe44e+HtPZ+jRQBd9ZPnAuwgjXGBQHF0EZ6FqD0HhX8goBts2IrNC/Urb9C7EF5ssOFJYYq71ATsdAmhWu8+/Z8T7IsfrDT9Tm9bo5eHD3GTYqNFXQ9UAbeGTxy/1AO0yVzcquUGk
 aNua2MEe
 MN3ZGsx9xu+ncgfByJOmFnz1dbQpKN9woeekiK9ewy8N/QhiGVFSFYST64u6QhUIs8kqh6YYDsMsn47wh9DrkfgSBgdeEXCBNfkeduBITmEaRYdUAyq31JIHRjaeKSV3TEVPJDznwzDdBAePXLgrCw1xt3Kz303/mbKZ5gZdoe287A5mr6gJGKaVbKxAaesMpJ1H+0tihIr8Hgk6iyPlA3/YNwDFxXWC/2DVOEQ5wnBXhpmkbk9ZhEJpL8CnRJDvqq9jmznqBxbAEMWGIfMHnJuaF5ePcB/g/bJ2e8NBMGCZBk3M5rr4KYXbh2V9pV27tghA/WS6uh/azGBe57832BeqNYXu0OLlkdxqEhZnh+TfaCRCFgw1E0Aup9FSds1KDUHM7CSZw28UcNxeVWIj+ZoiHgIxCEtyRmGS/BCIq2DTj/sdS+Ran/9m1uz9IUxkAG+0MtqN3glJJbY77LfeKvrNeaNxyDFfCdR9E+n8ZwDwjNc8pBX8q1N02sOshOpTwEWQtGhX/u9nNZ01wIGaZBIJS29QqCwxKBHFJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ritesh Harjani (IBM) <ritesh.list@gmail.com> writes:

> "Christophe Leroy (CS GROUP)" <chleroy@kernel.org> writes:
>
>> Le 27/02/2026 à 07:16, Ritesh Harjani (IBM) a écrit :
>>> This uses _RPAGE_SW2 bit for the PMD and PUDs similar to PTEs.
>>> This also adds support for {pte,pmd,pud}_pgprot helpers needed for
>>> follow_pfnmap APIs.
>>> 
>>> This allows us to extend the PFN mappings, e.g. PCI MMIO bars where
>>> it can grow as large as 8GB or even bigger, to map at PMD / PUD level.
>>> VFIO PCI core driver already supports fault handling at PMD / PUD level
>>> for more efficient BAR mappings.
>>> 
>>> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>>
>> Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
>>
>>
>
> Thanks for the review!
>
>>>   #define __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
>>>   extern int pmdp_set_access_flags(struct vm_area_struct *vma,
>>> diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
>>> index dcd3a88caaf6..2d27cb1c2334 100644
>>> --- a/arch/powerpc/include/asm/pgtable.h
>>> +++ b/arch/powerpc/include/asm/pgtable.h
>>> @@ -63,6 +63,18 @@ static inline pgprot_t pte_pgprot(pte_t pte)
>>>   	return __pgprot(pte_flags);
>>>   }
>>> 
>>> +#define pmd_pgprot pmd_pgprot
>>> +static inline pgprot_t pmd_pgprot(pmd_t pmd)
>>> +{
>>> +	return pte_pgprot(pmd_pte(pmd));
>>> +}
>>> +
>>> +#define pud_pgprot pud_pgprot
>>> +static inline pgprot_t pud_pgprot(pud_t pud)
>>> +{
>>> +	return pte_pgprot(pud_pte(pud));
>>> +}
>>> +
>
> In v2 - I will add above under #ifdef CONFIG_PPC_BOOK3S_64 
> to avoid build issues with 32-bit PPC.
>

On second thoughts, I am thinking maybe we should guard it with CONFIG_PPC64.  
Currently the build fails on 32-bit since no definitions of pmd_pte()
and pud_pte().  Though, we could open-code that, but I think as of
today, this only gets excercised from follow_pfnmap_start() which gates
it with VM_PFNMAP | VM_IO, which I think could only happen for THP which
is only true for book3s/64. 
But to keep the generic definitions of pXd_pgprot() and since pmd_pte()
and pud_pte() are anyways available on book3s/64 & nohash/64, so let's
just guard this with PPC64.

I will amend this change in RFC-v2 and will keep the RB from Christophe.


+#ifdef CONFIG_PPC64
+#define pmd_pgprot pmd_pgprot
+static inline pgprot_t pmd_pgprot(pmd_t pmd)
+{
+       return pte_pgprot(pmd_pte(pmd));
+}
+
+#define pud_pgprot pud_pgprot
+static inline pgprot_t pud_pgprot(pud_t pud)
+{
+       return pte_pgprot(pud_pte(pud));
+}
+#endif /* CONFIG_PPC64 */
+


-ritesh


