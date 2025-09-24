Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF188CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:32:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AA4F8E0008; Wed, 24 Sep 2025 07:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482658E0001; Wed, 24 Sep 2025 07:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BFB78E0008; Wed, 24 Sep 2025 07:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2AAA68E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:32:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE0EF1A06F1
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:32:53 +0000 (UTC)
X-FDA: 83923931826.21.DB98185
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id DD74C2000C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:32:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Hn0hExgL;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758713572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NX8NjcQF+BryCjLIXmBKXDQLrElZvP1c2SroDpG7CvE=;
	b=iur2gd1OaLZKS994ZiuX6UNCCUlulKikn6EwhD3+4l/Bmz3W/vLnfIwsVYWxSGyrVEJ0LD
	R/Ho3RkZ+miA9gQXrd7BorfZkrD9v4pxGurzkPHjyjSt4h6eAvcnGj96cS41XC6Fp6XwrF
	pa0grJc1eZoa2jyFvwsj1zz8sIDXFdQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758713572; a=rsa-sha256;
	cv=none;
	b=YYTaSE+xR1btZtTL8uIQaL/D0Ns+nwmmHAUsh7AFWSpqasUJ07Kxbp7hbiw53oRr+KO5U3
	rEbo2cCjLj08bjBPWEsci+5Kr+eU3ZvXgZdSQ4RtFh1dNdDni6RRlZLGa3rFBUT2O4+CpB
	RVVrUffxhP+3hRnAiPyyUrKLMLe0MBM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Hn0hExgL;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b28e1b87aa7so574070566b.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758713570; x=1759318370; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NX8NjcQF+BryCjLIXmBKXDQLrElZvP1c2SroDpG7CvE=;
        b=Hn0hExgLU5k08CK+embCMyg0sdaNT69GeuIjU9LXbX4Dn37gsXirmnsmPtVRN2POoy
         NS0oDME88XkhkkATO7gjX14F11mtGR7LKa2Z/C3pMeeujKRIDSvKaL9EvB+NDAXEPEGh
         1KnrWcpXbNzkfLJKNGy1eCyLrbeXu26NK+17BXvOlZb6AchxyyVMYMkUj8uHD42j83fT
         QzeCb5fqedgYoIIyIod3IoiVMeyRAyoxhUqB7R8vWMwqlUnvg9VF5UodpolHpeVjKHCk
         ndlvOZnfEH5QBxh6W/D2t1VWnTOnumBS4D6StoP6SwkXCxKFuuFQ3d+JA2IKenRV9tz4
         iVcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758713570; x=1759318370;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NX8NjcQF+BryCjLIXmBKXDQLrElZvP1c2SroDpG7CvE=;
        b=L0A2w6/8myBmLHsgsBiX6hNeI53f6EAxzGKewhO0/pLzNhaZlrEbk5meU+23w7JDDT
         LxqiahKJsfjC2szeI7FPsh+odcqU/JNsF4GwlulC6LqaPMsQ6ZTCTceRPxAdx+9oF5vA
         RL19YLWhK0lnPM6NedV/YTKQjZdHnnjAbq5bP5Pxq3Fa3Q/4mKuTwvzo3rrGn/zlDKuA
         f75wbnSXA7BdrpDo03TxfOg1/YM5+Z8nHrT+ybcLlZLtsEEpXE7fqadUEss8xyv03Szt
         1F8IYT0zxPUcrdCYlWvmnioLAlqs8giJBiI9ZzbtwwdZcnXgem0kCOhIhZ2NHk9sCUpQ
         BptA==
X-Forwarded-Encrypted: i=1; AJvYcCV5dLWwILHVyawBi5pGFJAGHkIkTzW73l5iSTsMS77CArJCFC4oKQT3gVQhGONBgUbn8DaMDUK8mQ==@kvack.org
X-Gm-Message-State: AOJu0Yzxfa45S/cYadfDxa/H2yxnF3PArplqEC+51QRi2l6TY71AB20A
	W/toteDZgtvfvmjjgBB8NFW5K8SdOsIdwyUXbdirf18mt+tZd90in5GwH9ywh0KmWgs=
X-Gm-Gg: ASbGnct7H/32szyJQ9mGazaGPtriCUEOGemaUBPzjdqGIY6BkefWyQkcy8aIcI/BL3Z
	igScJcK3zlh5nSCenioAZwb5giwb92kgiViZrWONMFnM/dsF1EQ2a3VjLtT6TDD6pRzUcRx2uFz
	TQtWR9iKvI/LJvIYTwFYX2EdkDFR58oR3kpSZKS6kE30kE2HH9mSIupSgZH3SuirW/KulSZgXfA
	ZNFysJsl72PYP4+b9wdI33gGGqTlohYNA+8q3PZNxO+fEXvJU+hqE7+BvMUkxF54PECjKVzgjPu
	ky6VA9eXFN8Y2AXc/z1akZ7GULFsGdNLMVhNVFUfZOrwvbxI2iKRkfcV7enyBHgW7HfH9rCL5wn
	k2xNfeMxJKv3FNIVQDZUDcGQLdKsrNWNi3w==
X-Google-Smtp-Source: AGHT+IGiVsBsNf8T6+SzsoJy2WrLWHd0LH4fCkQUx+oun3X9MnsQsjdxBgjfaa9AX/blGITfptbLtQ==
X-Received: by 2002:a17:906:7f90:b0:b33:a7d6:8b58 with SMTP id a640c23a62f3a-b33a7d68e0emr112550466b.16.1758713570389;
        Wed, 24 Sep 2025 04:32:50 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b1fc5f382b0sm1559287966b.2.2025.09.24.04.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 04:32:50 -0700 (PDT)
Date: Wed, 24 Sep 2025 13:32:49 +0200
From: Michal Hocko <mhocko@suse.com>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Dev Jain <dev.jain@arm.com>, Wei Yang <richard.weiyang@gmail.com>,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/page_alloc: fix alignment for
 alloc_contig_pages_noprof()
Message-ID: <aNPW4Ynrxyn23Ko8@tiehlicka>
References: <20250923001943.2479-1-richard.weiyang@gmail.com>
 <3BF1389C-4B8E-4F50-AB0B-F0D96833D387@nvidia.com>
 <5491dfda-862a-4c31-b64f-5339007a5302@arm.com>
 <09284390-5a1a-47e0-9929-0a5ba98c836e@redhat.com>
 <760C8EBD-9201-4680-8B9B-CAD7641A81C4@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <760C8EBD-9201-4680-8B9B-CAD7641A81C4@nvidia.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DD74C2000C
X-Stat-Signature: pq5cr3jo5igixsb9w3tm6ryxucw5adt4
X-Rspam-User: 
X-HE-Tag: 1758713571-245190
X-HE-Meta: U2FsdGVkX1+CAW/cu8vUyV4CeE1WbIFsvJ9w6iczr3thFUxvamDoI3dIXEP0+fy8gTwWhUtI+y9CXv4KvKJwGqw38r5PgQE6G9zwGKVJHIPyXp9vfoBr9XrtJ8/8eK6MSm629y9sXSZpbdD52Mhrv0RHcnCeU0yJ6GDamIzOS6TBA0QaCTyh53yCfY99JQS/iosWwK3SvNm6K0H8QhAbYd0n4ENIdCrSxd0PtXhVuuFl2AU2vxhSeBKUMkmta5jRtQ1iSXwGEj0k6taFjRsCw8AjJr8M0IcaUZEnG2vo32/AemeIJkOhuJeXXFz+U8IUPNu3RtWHICnlFGMJAx7chKXyOfzGdrhEz1BuNpdD4qAn3+LRzaRRB6bAe3DsDsokupycR6Ts0yU5myJ0pbOGm6axXxpPN8tZCxtdpOr5JitlKRmP8QDAuAkcu522NriRsTUwfe0Us4wsbg2SmE8ug6jLD8ne3DWKvjX0OEsbOjQExJ1Zh6YSpdIZE3U00wSySDUCUIAYd+DClVp6ANh9eycwzXeSzfFuJrHgCELKdCRPt9ZNcv4/yabSzJCK60AA3aPJVLyw7lKKpEdV5o/2CTjQ7+TYQz/b4+RS+H32DUwF4ZEkmMMSGEzw+9xVqcaSdhEuQ15Ih3FeT4xKjMV7dkEfUtfIf8ATfPxgUYj31EjmamzNSy45MVWmFEWU6EsSW5Wf4BI2bzZNFusgL4d1xv4SFHE7iDUZqs4W6wlrU2cmAadJDdXyDRywAqmkdO5FdxX7eYWvob2lyXr0/M9wQDj3fjNEsGyci1xRoop/WmK+BL3xl21Bkif0vuoCjw/L+MYIr/HeUl9tGOzQhx8Q6ZB2/Hq3rZI8g7sTlhVAnraqrjXLPcJxuv0lzb2lB6S8X+If8yKAz78ykdgfmVfaYV5nkc1rU/lHNVxeWglVhPR6WHiUjvqWLGNXFC9zFTrGc/+6xBE+W6MybTzp1F/
 IM8EvY8n
 0Qt5X5lnW77xpcTILWjVhOJ6UwWheG/Q5+GxDh2YiRAGrzLibkThX1tiibQfcuzyE/xK3bsXZO+M09VC5e5xfNWePf4pFNti2hYM/g3n8jS7xfwdyjl7+5Wsr8MqYiVCPkNUU+s83+ILCFQoTMje4zmPN6WMAnZESd8pabVwLjG/hl03J1ROypAXOO+T5bLDmBRAojB4GHc/5N1bh3OwfdRdcYUE8E3g7gYfRzvbdwcmLQhGS1ye19m4LCiAsRYA0YKP3pymbzplOYeCvRXK7waHPmky/uOS5oq8/2GpCec9AIdaDfoFNneZMLCa3bMm/NOoKBcRr7ttzcTmvNIhDVi90IP1+UCm227yAjStaaj1rxgUCd/hyLuDFraj1Trbi2BNmiQDDvbpj0hjlMWvoliFbY9d3CGKQmRSmbA779FPdfbyJDau9SEoWQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 23-09-25 11:07:28, Zi Yan wrote:
> On 23 Sep 2025, at 3:48, David Hildenbrand wrote:
> 
> > On 23.09.25 09:06, Anshuman Khandual wrote:
> >> On 23/09/25 7:16 AM, Zi Yan wrote:
> >>> On 22 Sep 2025, at 20:19, Wei Yang wrote:
> >>>
> >>>> Commit 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
> >>>> introduced generic method for alloc_contig_pages(). But the alignment
> >>>> calculation seems wrong.
> >>>>
> >>>> Since ALIGN() only accept power of two value, while nr_pages could be
> >>>> any positive one, the result is not defined.
> >>>
> >>> The result would not be any value lower than zone->zone_start_pfn,
> >>> so the worst case is getting an unaligned PFN range. I guess
> >>> most of the time nr_pages would be power of 2.
> >>
> >> Agreed.
> >>
> >> Also as Dev had pointed out earlier, this function gives no
> >> guarantee on alignment of non-power-of-2 requests. Hence I
> >> don't have a strong opinion either way, but does it really
> >> qualify for a "Fixes:" tag ?
> >
> > I'd say if there is nothing to fix, then this patch is not required.
> >
> > What likely does make sense would be that a non-power-of-2 would be aligned to the smallest contained power of 2.
> >
> > E.g., a 6 MiB request would be aligned to 2 MiB instead of multiples of 6 MiB.
> >
> > Not sure what the existing ALIGN would do with that ...
> 
> Something like the code below:
> 
> pfn = ALIGN(zone->zone_start_pfn, rounddown_pow_of_two(nr_pages));

Please let's not try to fix a non-existent problem here. If there is no
alignement requirement then make sure we document it and drop the
existing ALIGN which doesn't seem to serve any actual purpose rather
than make the code more subtle and more obscure for no known reason.
-- 
Michal Hocko
SUSE Labs

