Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C8BED14892
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 02:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69EDF6B0088; Wed,  7 Jan 2026 21:23:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64D266B0092; Wed,  7 Jan 2026 21:23:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54E366B0093; Wed,  7 Jan 2026 21:23:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 42A146B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:23:52 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F11671A0557
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 02:23:51 +0000 (UTC)
X-FDA: 84307201062.27.FE2E408
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 14960180003
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 02:23:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TuJ3SoL5;
	spf=pass (imf24.hostedemail.com: domain of seakeel@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=seakeel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767839030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6WPMqEgbiq/1nCGoqJgHIPGVbxZP1MvEMarO5Hdi07w=;
	b=W1jguFte4i9UK6BVbpEbL5mK08atb47PeZY0F9H6nhzbUyvNhRga7OevRy04jnuNgU7qop
	mN/NzvMIS9CpyuhlutEGFecuifqlOBn/S/sf6aBqYmezxoyWirRHacD/KYhsGsaxDptnMe
	LlSt2wGnCGI6ksq/DmcjGgCJwawFZuM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TuJ3SoL5;
	spf=pass (imf24.hostedemail.com: domain of seakeel@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=seakeel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767839030; a=rsa-sha256;
	cv=none;
	b=eD3ijMWbMkeWyKVpLgDVejcPZyPmwvfq7371ZQXcOeyBXcgwgB3A8D+mUwwH+a42s7tZ0W
	ui9K2RmrUmAKZBWMUWnAoIy44j/qrWj4MpJGL7zEhmtiF99vtGG98FT8j+K2n3Y583+jw1
	61aZqL3bwnOkJ2LNa9gbfmdWFqjkH9c=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-78fc4425b6bso28748667b3.1
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 18:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767839029; x=1768443829; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6WPMqEgbiq/1nCGoqJgHIPGVbxZP1MvEMarO5Hdi07w=;
        b=TuJ3SoL5x10tNIKvRmdXFCQLBYVnMJAi3rM1rtOMPT0h2V/4JRmuDJTO0ztOb6p6BJ
         pfUPoiCtU8zt7WQIgxlH97ZiQ87me71jaAahpYARenVieS16OpFXIGerPKQMdzsJ/l/W
         L+nhIP5ibJZ7nmeKuZQfLUSoIb4DQe1rGwFjuipoNXsebh8g51UXg6h8OK0yMhHnB09c
         agpzWcMsJ0OYL9E8WBQo78zk85SpD5JArDPioZ/kGoJ3wm5/rQyBZugn8NxeCkV4qt5c
         kRhIbQhmHMttfaDBcYa96wT+WvufEW4Dx/7AL+eCZfXXZW/bt+gq7hHVnIDQuDif81bh
         90Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767839029; x=1768443829;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6WPMqEgbiq/1nCGoqJgHIPGVbxZP1MvEMarO5Hdi07w=;
        b=Vvx0hd3YwB8FKOaCNZAA4wyBSEq52MfagpvRW+kb9O1uUoypqLuJDo4ygHDGEn/c73
         Shyu+zE+UzN4+QJjUJ8IWI/dAjFcH2FqcGOANIllBwQpCSU2IKqZg5prE0a03MOtZTv+
         xitMHreuW0S9sIcQ6Wf2H9Ubz1LyVubuSpgme4PMVWRPWSfa+Ic1rwjxdW+nHd4bXXLR
         IhEDg7qkuGCLA6ryE+9la/sp1tVSpLh/2Ktc3xIzpMb8hH4d628+dlPByrcqx4sFCupk
         sEa1VcG8evz4fID971CoN0n3MZAx6XVy5YI/LtgE3Blfzi43SsP7ZEdIYESemtZWyGzX
         Jipw==
X-Forwarded-Encrypted: i=1; AJvYcCUyIZddBpBTJsQmntvr1Z/uAgtWDjZ9ISf5tBWh3GiV7DT4K55xycxig4kP5bbZaIuMG0jnh/XIlg==@kvack.org
X-Gm-Message-State: AOJu0YxqzORyYZcgoLL6fANrWpxq4tKw1xXexZWw8R/1l0sTI8TUG5+B
	G0wUPQ2tfyvSCQijROxAizHTVzQY+T0y/IWAqbeG0Wl1g0g+KN6G7oKW
X-Gm-Gg: AY/fxX629ctoBTV0TcAW4IC0tZ0jMjuwiccRtU2y7rjZ9Skc/z3oMsPvddesEUToDJK
	gC6CEgIjNgWJLoQlXaRgF7o+7H+MdDAHLKW06EWPCiCdTAwIyIQqdfNNO7YyYpjknva7LmY+4V7
	pLlkB8LYnJDPXUgxi7w81f6DeamGwpe92MsMA4vSOmM+ZH+iMFTCbFqUHehiie5FG3P1suIV2vV
	pKLxgdSxPqjUrAyFQILLoggLnuJGDQrPTGGYoJq0u0wo2BVHr3jztcfO71y4xFcAnFfLZ4BwX12
	tLEz58k7RKNwaHruFBf2M1BfLcdQrz3icGE0zcrpMSZK5VsdsNK/8fTd0iBnODZxVYwtyN7wx94
	3jyOd40Y0KdjqzOZoPllex5pvWTOzAmVRnYt+p2x4R9SwaWT70r9pjtRXuJPDAcgAS6fVMjy1W6
	/Mi8Jj0fv5L2VExJQdtj/mKcKvSWwwTD6mYvZnCA==
X-Google-Smtp-Source: AGHT+IGgMpL+kZMdvF4ADTgetvjR8KjnRPwe3Xe2CKlVvJLk69qHA2NQZ4MxPPVQYhnVGWyKjWzQjw==
X-Received: by 2002:a05:690e:1c06:b0:644:6b68:f126 with SMTP id 956f58d0204a3-64716cacb29mr3927712d50.77.1767839028925;
        Wed, 07 Jan 2026 18:23:48 -0800 (PST)
Received: from [192.168.2.226] (104.194.78.75.16clouds.com. [104.194.78.75])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-790ae603282sm21321087b3.13.2026.01.07.18.23.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 18:23:48 -0800 (PST)
Message-ID: <1d110134-89ab-474b-bca6-cfbfd4b5057f@gmail.com>
Date: Thu, 8 Jan 2026 10:23:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/pgtable: convert pgtable_t to ptdesc pointer
To: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>, alexs@kernel.org,
 Richard Henderson <richard.henderson@linaro.org>,
 Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>,
 Vineet Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Guo Ren <guoren@kernel.org>,
 Brian Cain <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, Geert Uytterhoeven <geert@linux-m68k.org>,
 Michal Simek <monstr@monstr.eu>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Dinh Nguyen <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Yoshinori Sato
 <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 "open list:ALPHA PORT" <linux-alpha@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:SYNOPSYS ARC ARCHITECTURE" <linux-snps-arc@lists.infradead.org>,
 "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
 "open list:MMU GATHER AND TLB INVALIDATION" <linux-arch@vger.kernel.org>,
 "open list:MMU GATHER AND TLB INVALIDATION" <linux-mm@kvack.org>,
 "open list:C-SKY ARCHITECTURE" <linux-csky@vger.kernel.org>,
 "open list:QUALCOMM HEXAGON ARCHITECTURE" <linux-hexagon@vger.kernel.org>,
 "open list:LOONGARCH" <loongarch@lists.linux.dev>,
 "open list:M68K ARCHITECTURE" <linux-m68k@lists.linux-m68k.org>,
 "open list:MIPS" <linux-mips@vger.kernel.org>,
 "open list:OPENRISC ARCHITECTURE" <linux-openrisc@vger.kernel.org>,
 "open list:PARISC ARCHITECTURE" <linux-parisc@vger.kernel.org>,
 "open list:RISC-V ARCHITECTURE" <linux-riscv@lists.infradead.org>,
 "open list:SUPERH" <linux-sh@vger.kernel.org>,
 "open list:USER-MODE LINUX (UML)" <linux-um@lists.infradead.org>
References: <20260107064642.15771-1-alexs@kernel.org>
 <aV4h5vQUNXn5cpMY@kernel.org>
 <080e493a-e4f1-4c97-a3e1-f76f126b5213@gmail.com>
 <aV5yIuGi9Ni5YP5E@casper.infradead.org>
Content-Language: en-US
From: Alex Shi <seakeel@gmail.com>
In-Reply-To: <aV5yIuGi9Ni5YP5E@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: n4pop5pd9m39ukicquhdi8wnucj7htp7
X-Rspam-User: 
X-Rspamd-Queue-Id: 14960180003
X-HE-Tag: 1767839029-595618
X-HE-Meta: U2FsdGVkX1+Yg+EATH9d/9fXpE80gOKtrDp4pVbB1FXI/EYU7NFja9MHNZmRSSVQL62+ySLZ1ICt4xYXXZ0fe1QQupHuitFQAbtIE46PCEU7NSZNdyJzY9WMTswDm96rvNII3xueAi/SEYM6h/hj5gMYwhpH0QWKPzXyIOHBdNLSPFyAq6+9bGZW0zvkrWMytR+YhLwNVjDnBu8/2FQqMRD2Q2toZU55wsKD+f0Bv8kG5mVxm25aXTyelv/s7i30ejX+LNwsSYfvGp80Yfi7wH4eNSvnOQvEIwVZAJ0B6XA/SOJh5pB4EcvnG99Ak9tN3J0t4W7T9Daww9DMf2vySB7X6UPDUuWt8YLU87JTtgajLKhpFFkakBTfw6XqC4FnQwvzGEing1Zsgaui1eD+GwI868JaBhCXDtc0E2umISXSovETLkccFA7Of+38rMRfdfZuGHaJbi6ZAVzZgi1eVyWLnMlGny9VpciJokaQuWYT6Nodj7ubO4/1WOp+ItDlYAAefI/P5nUSN9v2uh8Epmmt5VaUK8EoDHrRUYShaU4CV5/4sO7X2mpA174wqJNFcpoYEqqqfGbbi6lYQhbhZisMxY0zqD8qcOK+Ey4ueZBcXb8b1RDZU7h8RsAaYGcGtBQjMYrLXWjwfTMzbU5JWtPkq7DTdxzKDAqk1DKd7H/UKTxLun6FvaXyMTxX8P1CflbooH6Q3iF6EAS0T9yKprBV9XndCc7FCMDM8s94Ey7nKuvxcmnMQerk1Pwi0MbuWthM6xTuasQFFCJBLVdBAaLyLSz7cZanyv/n3cmJRBKbmnei2pBuS+6u2OrnKUTdh9yIiTSAfFc+/pXUO/RPXw/x/OskF7Hi7skhx5Cbo5hWV0/JgaHc4nV/7sdB0s/YegVTcgju/XI/VuE5lGXepcRuP0BqZZP9PPj85ksY6IXJtpaj2ZwlnzacqBT/JBZXLwlv/nbKjakn+g8laqa
 Z9J0yA8r
 J05Gqc5WjvfZCFeAPlY+T+gOmrAAekZgSsxgxBxfyqYwW9KLpunN++s6tC3YK/+jV0lCvgvgD6F4QVxWu6qNjJBAnFrKFwv7wNUT/zrqrcK6KK9rjEFDJhnZ2j/yB5MB0CIIL2fk6mtdRitlyYjoL5q63Tn1itzMTwnrhOUm7b/MBhtMv7ONWjK19En/umzWvnulGt5b5/py5609xbPeKDwottT5PYVRgMRB/E7O2st+rYDaGoYQxDCy5XeAAIDjgCrU6jQosYBQQkEPTJaWIQHeWdT5XJFPH2ggn48Qo+3R9XZlZ+ScoUosYakF0FhmemsBeCwS+zvANpWnmuQzg4aF5R+GxAahloAyq5yxKmEjxArjxir/SC+HJghUhGVmn4kmWdT9Slbphb7st9t7oJzpjpbZLTTR0PHYcq3Ia29WF3ov3/A33j59/2B4ON+IjxXyvQYFXuLue2JDmX/NxIqh/R96zth7jIXn1fmcEZUBj2V0TzeXsNFApJ9cCadd5Gfwh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/7 22:48, Matthew Wilcox wrote:
> On Wed, Jan 07, 2026 at 05:28:36PM +0800, Alex Shi wrote:
>> Right, I will fix this. and sent the 2nd version.
> No, the patch is stupid and wrong.  Don't send a v2.  You seem to have a
> hairtrigger resend, so I'm trying to prevent a v2 being sent instead of
> sending a patient reply.

Hi Matthew,

I hear you—no v2 will be sent.
but sorry for a bit confusing, what's your expected fix? is the too 
quick resenting? or the direction to alignment pgtable_t with ptdesc is 
wrong?

If it's the first. the new change for review address Mike's concern.
diff --git a/arch/arm/include/asm/pgalloc.h b/arch/arm/include/asm/pgalloc.h
index a17f01235c29..a204c3ac800a 100644
--- a/arch/arm/include/asm/pgalloc.h
+++ b/arch/arm/include/asm/pgalloc.h
@@ -94,13 +94,13 @@ pte_alloc_one_kernel(struct mm_struct *mm)
  static inline pgtable_t
  pte_alloc_one(struct mm_struct *mm)
  {
-       struct page *pte;
+       struct ptdesc *pte;

         pte = __pte_alloc_one(mm, GFP_PGTABLE_USER | PGTABLE_HIGHMEM);
         if (!pte)
                 return NULL;
-       if (!PageHighMem(pte))
-               clean_pte_table(page_address(pte));
+       if (!PageHighMem(ptdesc_page(pte)))
+               clean_pte_table(ptdesc_address(pte));
         return pte;
  }

@@ -141,7 +141,7 @@ pmd_populate(struct mm_struct *mm, pmd_t *pmdp, 
pgtable_t ptep)
         else
                 prot = _PAGE_USER_TABLE;

-       __pmd_populate(pmdp, page_to_phys(ptep), prot);
+       __pmd_populate(pmdp, page_to_phys(ptdesc_page(ptep)), prot);
  }

  #endif /* CONFIG_MMU */

