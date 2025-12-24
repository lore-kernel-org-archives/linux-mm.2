Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 822EFE7545C
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 14:08:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBE2A6B0005; Wed, 24 Dec 2025 09:08:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9FC36B0088; Wed, 24 Dec 2025 09:08:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCC786B00B2; Wed, 24 Dec 2025 09:08:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCD186B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 09:08:36 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C0791A027E
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 14:08:36 +0000 (UTC)
X-FDA: 84254545032.29.6BCE6CA
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id 826FC1C0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 14:08:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bluJMVv0;
	spf=pass (imf18.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766585314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8bjhEK0QzLczMjuRWBE/VCHDC7iNUdHHs8usW38m9ZE=;
	b=Ke72W8XvTNMMSmDRBnE638+i/Va1OId488BXUtHCAowwtiX3mgtQSa3NijHCsNQcGzlyHL
	8iUKpd8QfzUWTvv4LWyg/isJ+SG8wUq9YgVYZrlUmVejKklERtTGxhFB4KY2NxZH/i73aT
	tFFBaxcRq17TzIGrrWYFD0ZkFREL+uA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bluJMVv0;
	spf=pass (imf18.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766585314; a=rsa-sha256;
	cv=none;
	b=hhChtbtmYFylU2f6d3tUmZ9+iV7PK/dr4vl7ZRmfSOm/fz08P4UazrKDmcAl4HswoM3ICo
	BFESWk51tUrADYjdTkar5+PSlb2+Y/D8dutXgKLptuPJM6ww4PJhKoDxuPf2hNKe5oeLP5
	YDpe/0Gsj9Q5R0cy3LCf70UoCYDdxUY=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47d1d8a49f5so27980055e9.3
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 06:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766585313; x=1767190113; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8bjhEK0QzLczMjuRWBE/VCHDC7iNUdHHs8usW38m9ZE=;
        b=bluJMVv0Kd42bcUMuixiVbziQ5qKRtFq5wUKHiG0svKQsqLGrNgAaCD4i5G8VQQg6H
         E3nxwntqlDhzSsgS93nthJ6zrgtSp1wIkuGY7j1TjytkNK92ThsGysi1mkZ7P1iOHaXH
         V+lgfi3KZcRvR/wiyBbaL0MtxzdnX5nOMXan0ltf+u3hi6Jz7lFuIk1l4zlpA9H1i8aU
         HMajKpIsI67AHR/P1RcSrBH8WIHk/cjik9rZQLI6SyRvNTAwpkphypIe5HRgsdyATVbf
         Pjvlu99sZX2kwAMPcESxcwDqs+/7l6VeQ3sRydOit1A0/49jKD1EeSD6MRAQv4TzWVEM
         ybnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766585313; x=1767190113;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8bjhEK0QzLczMjuRWBE/VCHDC7iNUdHHs8usW38m9ZE=;
        b=ubjZmGa73cnVqARcKCczWiBCo9TdrQG75TqGD4bhde7ogOr4hBdlIc6Dbw0/IJ1+e9
         Iogv3aWzL/3Wzz3nSbkrB3xUqJOGSHovmUCeLkO3bg6SxoD3Q1nK3DmDQqDFgq5UlpJo
         xV+3fUnr+/XS+wLNPmKxQN3uxjHHztS5warXKXj4qQjmKEkIQgc2Cumz1jOJm/uby2C8
         gs2go407z5z5xe+9vzwRXLm/xT/8/jIy1boQkXITyzQ3u5oogSusR7rhFbOaDSm9JD7A
         mWrrjaoRb6luLx5Frac/YFK5x0NtEutvmWN4r0gEx3ZbmxYhFq0iolTxUMt+upxKmjJd
         EAFw==
X-Forwarded-Encrypted: i=1; AJvYcCW2AnZvV/QbouzBYK+Y/H1IVrgirbarrs3M1mV4NfnpwoqUpSm7s60E1pLM5HaqOskWKZx4M6oSSQ==@kvack.org
X-Gm-Message-State: AOJu0YxW8y7TSULx9KljK//11kDqKLbQ7vHe6vBHVVMXKJREhNVtENcM
	J29pbU6xiOtUAc1sa3MQ6GSN/bROIyP4Q9grOwRTGUWDFwpO5HpPtyWX
X-Gm-Gg: AY/fxX52Jk9F9r5seR+V9oPOtBE37OMR0JedMU1eB92ReYh7mXP4V02uYKjmMxyw82W
	JZebQhy6rX2kPUVJJ4x1y/UrYgmeTIyw7MClB0hC6j+NQI69t5/Z6KMeHI3LjceA45n/iIpgykK
	Vi/Di6RKu8yRdYgF+z1t2dkgZ40NU2zLMEfd0DSCUiNgYPjuBavLfp++2Kd93T8HblZtdOpjnMi
	NkKr/Uzur72381zzcKmIccLT18qfI3mSIDtageSuRS2Tn01RIe78UtnF+kQ9di4HikBKzuO178T
	yBpMKlqoRIwbHtAyn/HR28CJmh453+p5Yd5NxmcYp0DnjiAy+aFC+SM6wJRk2Gb9q/77XWH+Zhd
	Rj3Mkf7hv3Mk23jhDOexXGVDidRpMhTfG0yrYHGFIGh1I9twVzCftrQcbUARicCe6Y7K7N1V2yw
	U0wN5OE25yzeB4I5mvoCbc+jAkmVO9Fr1qCupQMlem/ayqBgKUyEZwgQJBUpJz2g==
X-Google-Smtp-Source: AGHT+IGoql5I9yMQA2r3CYAfODFyPpJJLXYfKCLQChVMu7f/K4Oq1YRyKjJ9DFS4NIyuW/hVke7DHA==
X-Received: by 2002:a05:600c:4f4f:b0:46f:d682:3c3d with SMTP id 5b1f17b1804b1-47d1955187fmr230919435e9.13.1766585312533;
        Wed, 24 Dec 2025 06:08:32 -0800 (PST)
Received: from pumpkin (host-2-103-239-165.as13285.net. [2.103.239.165])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d192e88f5sm290811265e9.0.2025.12.24.06.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 06:08:32 -0800 (PST)
Date: Wed, 24 Dec 2025 14:08:29 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Lance Yang <ioworker0@gmail.com>
Cc: baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 akpm@linux-foundation.org, axelrasmussen@google.com,
 chandna.sahil@gmail.com, chengming.zhou@linux.dev, david@kernel.org,
 david@redhat.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com,
 nphamcs@gmail.com, rppt@kernel.org, shakeel.butt@linux.dev,
 surenb@google.com, vbabka@suse.cz, weixugc@google.com, willy@infradead.org,
 yosry.ahmed@linux.dev, yuanchu@google.com, zhengqi.arch@bytedance.com,
 Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v4 1/3] mm: pagewalk: simplify hugepage boundary
Message-ID: <20251224140829.2ec7bbae@pumpkin>
In-Reply-To: <20251224092332.53214-1-ioworker0@gmail.com>
References: <62a2d7ba-e7c3-4153-b227-c08802ca9e1c@linux.alibaba.com>
	<20251224092332.53214-1-ioworker0@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 826FC1C0005
X-Stat-Signature: 7c7k5op41619qup4sxyzoiauo1x4amyd
X-HE-Tag: 1766585314-937249
X-HE-Meta: U2FsdGVkX19DGiLPkYt5EBt5ehRXjTgYDOFFMRAfaSzyTwl44MWariNG8JCnAh3z4MuDZzF9wXwK1QJQMx/Bj+LEQd7JKUxGPSLaGRySHR3Vx8S3wjP34EZ539bgPMHrk9JpC1LEqtVeYVYv3+5/tpnErlFeStKUQudw4kSgK5NjRgqGePgMNm//q8XtsdFHyXhjuOCu5W0hExjY6ugol1yxX4aW705LwSS5Yz4ihNRufuCyxFToDxXVJQddtYTpMOMSQM/SR8j3Zot9JSP4dbJ9lvm24lo+D3rKBPTeXLL33zXXwNdZfnZbS7UlFas1yTtNVzlzBVdzIDyiFtoC2jyGpbx8wDZqzUU1c9wcUfpUDRh7V5m4T+de1CCEw923yLp6WOVVIeYYQxyZ5VwSxJWoFZwH0+wz//m9y9LqDMeIlJHqMvzagYr2zH6GTKUc3IyRqKoS07RvcUHlagt+aQglRLDoaXA8IYHn+5qR9nfrxbCENzQq0KXh8vbEPpZ5F2rcXIC7JkFNE4bHsH+OuictEbdy4RawwjxxCCGZ2HD8PVmFsC/LqFqe+SyJZkoWgU5V+p3l4y9p3tnAIkx+5vraNqaax5CJSjWpVvl9b8hWbhluhuAawZeXmCv78H1QBKfbkL5C/vJV9LQe5heK5r34B+etxOFj+apuMMVIT3Pw1IKLpFH10KOykv0aSB5NRvX9DOkbzIglSVy4cPwdEo7SmaxyEXRp1KQhStgbiXkFJI2qWpwucRyQ0/b7OjhLZfDyRcDCZK9ZgC6Fsy9JHJGzR46uqZefgISPech1lA6YJUIKMHcHMh2kUTF9MZPmmMya9pjoCqNNrmdk5IcRMdzHkpNEwSmitPxrFDdj18YXeuwiFAP82wzctzKeUcuelNKyHXwDOrUmf7fej+1S94flJxv4VSz3tLo/nXh0g4fAm00f16IroDWebCOCY0MiYLJjBMT3UuF2bSqigfB
 v1TsvLSN
 3p1qJI00aj15gBBkVq5E+Eej6XNvFQ+w5i9dv3F15vMPA98Su4ffsJlxrXUnCm3fEv6YOQO2knUYR5J7WhX0Z8dVS66zg/vlKqKKu/ciEC+VeZJY2UYmFIl4nOt3Tjt1gdervkHLQKauDVNMfbNYfwT/9d+hFaUGcC+/W2ckUxdumj05K6XLnZV7+5orFKnqLJSlsD7KCVv5RC5MhtCaSqKtDC1iavp6sxumM5koQ64fbbozIeyTT6j3juBVspKCHDUFr6espH3DDtP8wn/FSBLITDHgh44azW1wVI2B5YMycop6wTf+cjHuOD8iDW0WWTAVX07M4FPxbEYl2yhJpG9TV3TuYXx86EkPgr37jWd9MaRFk3dXWK12VC8AZ4xmTCeTeKYvvjTYys3O95T0aAX5r6fOo6Zvq8nUqozc14whduqSICA7Z2jbcHpYp5dDdbHRswh/nqW4VEPGrNoi6Nqk3AyB5pnMz72l8QmWmp27o+bAYE9iAbsDm7xbKCr1pSs+gOESoHbLrFcbfpMam6GfS7ypzUJ7Ph2Br3WAmiXXkIeTO34rr9k9rzMpWQ8Mb6F64xFJnqgXuWk1HInROA5iRvKs+3zOAP9ek
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Dec 2025 17:23:32 +0800
Lance Yang <ioworker0@gmail.com> wrote:

> From: Lance Yang <lance.yang@linux.dev>
> 
> 
> On Wed, 24 Dec 2025 15:50:34 +0800, Baolin Wang wrote:
> > Hi Andrew,
> > 
> > On 2025/11/28 15:01, Sahil Chandna wrote:  
> > > Replace hugepage boundary computation with ALIGN() helper instead of
> > > an open coded expression. This helps to improves code readability.
> > > 
> > > This was flagged by Coccinelle (misc/minmax.cocci) as an opportunity
> > > to use min(), after which the boundary computation was updated following
> > > review suggestions.
> > > 
> > > Found by: make coccicheck MODE=report M=mm/
> > > No functional change intended.
> > > 
> > > Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> > > Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
> > > Suggested-by: Matthew Wilcox <willy@infradead.org>
> > > Suggested-by: David Laight <david.laight.linux@gmail.com>
> > > Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
> > > ---
> > >   mm/pagewalk.c | 3 +--
> > >   1 file changed, 1 insertion(+), 2 deletions(-)
> > > 
> > > diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> > > index 9f91cf85a5be..9fd59d517f37 100644
> > > --- a/mm/pagewalk.c
> > > +++ b/mm/pagewalk.c
> > > @@ -312,8 +312,7 @@ static int walk_pgd_range(unsigned long addr, unsigned long end,
> > >   static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
> > >   				       unsigned long end)
> > >   {
> > > -	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
> > > -	return boundary < end ? boundary : end;
> > > +	return min(ALIGN(addr, huge_page_size(h)), end);
> > >   }  
> > 
> > Please drop this patch from the mm-new branch, as it causes 
> > 'run_vmtests.sh' to hang. Specifically, it leads to the system hanging 
> > when executing hugepage-vmemmap test, because the program falls into an 
> > infinite loop in walk_hugetlb_range() and cannot break out.  
> 
> Good catch! The problem is that ALIGN() returns addr itself when already
> aligned, causing the infinite loop ...

Using ALIGN(addr + 1, huge_page_size(h)) would work.
Although it could be (addr + 1) & ~huge_page_mask(h) which is probably
the easiest to understand.
Some of the 'helper' macros don't really make the code easier to read.
(And that includes a lot of uses of min().)

	David

> 
> > 
> > This patch does introduce functional changes and makes an incorrect 
> > assumption that the 'end' must be aligned to the hugepage size. However,   
> 
> Yep. This patch is not equivalent to the original code when addr is
> already aligned :)
> 
> > this is not necessarily the case. For example, see how pagemap_read() 
> > calculates the 'end':
> > 
> > "
> > end = start_vaddr + ((count / PM_ENTRY_BYTES) << PAGE_SHIFT);
> > "
> > 
> > Revert this patch, mm selftests work well.  


