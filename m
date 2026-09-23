Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2A9FC982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 01:59:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4233D6B0088; Tue, 22 Sep 2026 21:59:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D50A6B008A; Tue, 22 Sep 2026 21:59:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C65A6B008C; Tue, 22 Sep 2026 21:59:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 010116B0088
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 21:59:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 736004066A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 01:59:40 +0000 (UTC)
X-FDA: 85243370520.04.03169A2
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf26.hostedemail.com (Postfix) with ESMTP id A76B514000F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 01:59:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pMMXtSXa;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790128778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pUjXO0uskRHAPb0FNYBwdm7PFr+ea41NeGJqQkShqkw=;
	b=PCKYWNhZEjlcpWj6uIARIpZCPCcwo1kQ/Y5BYkaiFbv9Ule6yxTKN6B/PEdbfp7JNC7rBR
	GFYYnlDfCCDwXQGliDEs9hP6wVc836WXeYW4dHcrCseoS1rv1EZcLHN48Q0Ph77au8Y9rv
	Rni1SbY9FVQKtNaJsYZMP2b+3VHhnq0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pMMXtSXa;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790128778;
	b=HQ+aHKdOKDeKQOZbhzEQdKPknPycZXf9Rql0SnP9u9X93MnTgEDL2dI8QHOL7wUKtwmjXl
	n61UFKGpclEGNH00JYseCQLo7VBpdVHTqx0MKBGron2V0Vunria1oSdozevj24JnREQ9E3
	jVWXzt4D2a02XNbz5FW9JLkxKoB9cuM=
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-93910cadeafso32964785a.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790128778; x=1790733578; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pUjXO0uskRHAPb0FNYBwdm7PFr+ea41NeGJqQkShqkw=;
        b=pMMXtSXaPC8YU6aJ+ASjeB2+3DxwU3HVLwBHDB+Tksm9Vjyb0RtO04Qr3K/tJdrwDa
         4EfRWeAMeVGuCtswa/HaIWMCDRg3QFsxAC2tb/1lf3Zme32P3iBdMLi/K9dn01Q9FnIk
         gFFM5Vkmjyxpf5d5Vw7CrNZLy/R6nWLT+DLztnGoe3dfjnze893USBGQnJCwZADrGg1A
         5EjZilk3WMF83i85ram09+WNbJiJqpNNQtC3kiNFejoHeTjOwLtxZsGD147S/VxDAsGY
         YBJTIqy4bgxD/sdstmxR1d+SaJ8HpfKS8SXSkrzGqPer02Uff/m1OPAG+ySwFkaOL9T8
         SYzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790128778; x=1790733578;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pUjXO0uskRHAPb0FNYBwdm7PFr+ea41NeGJqQkShqkw=;
        b=CGCGGjLwycQfvNjdkdMFF42SSq+tTp1OeyTDufpdKaZvRtYbqMllJJPlQrYpyJqGyl
         8c4Jo8Jsthqfl5gQivBSqnocUdMk2JH3knDFpMQ7BmSDq6U/H9L7h7BDGfpyDs4xWcFw
         ZIpozbsLq1TZlsG9TUIxNkQOkapeYQiKAa60wmkyRf7uzdZcabfaQLOQwKIRCbYVHHVs
         +jXdSKrYK4fbd1mNRvCa7JkDSJSqKBNyDa8coPjRtPY5gq/ZZpQbDmA2Y5KUSKeRybY0
         x10M8/Cfw8gChBrmDTDj1ZDkG0yZQ0SaV6/MgR02NaOtAkkSCKRDQ6uLUwrmfYs/DJo7
         RtJQ==
X-Gm-Message-State: AFuF++kNnVm0duQ7esg3mzvBxAipD7ZSTj4VF3BRrfSbxXh2HljgmKIF
	+LSZB9bruZ2BlCCxCg91ZSjuUwOWw9LA6i3HXMkBHGoMM8I6zGzd6praqLNZiv/jOhI=
X-Gm-Gg: AYBFou3lYiJJnLpCiyr93r7veZtYmxj2IX47Vkr3R7lwlWII3TbMQYP/XVGh16cp5TD
	MmZW6EHK91LwocGuaglE5AvTQuPaptRko1bGL45SNEXxh0B8LcFUtjWqtEZKXXnYALAA/TBh3C7
	yQqGqxbxOM0yBs5ZhOaCNhSmtFqlcGEREHJRkqZ0s5mQKbPwbCwsu19q0O138Jipb8wqqnBIeYW
	HkXDhazINcYACNZLmOc5T//nhHtuuo+gm3pUeWLXbjq16/0mpOqiD9ebnyg1a/4+qwLGoXxcgmF
	S/2SJQno92WFPr8oCoGAOQYkc73o7u2SOZoG4ETawIUte4/OWr3yZtIF7tmr7Vc3c3UaU8xWl1Y
	xjdDO8NAwUnwhr+XrhWNqnwCxAYZd/WpWEZQGK4AjPZpocVkH3osejs4YFA+73ku256un1xqea0
	XBACfi1AjTWcrDpWdSOVkh9qmQlt3TZVoiduYiKzNJcDUS4G/XExTM8IlDURjhChNm5XyjQ2LOS
	XQZslR9g2B6VJ8e/Zc/KTsm4F92WaHMI7owWisYUbdn34xpgrvXgHtMP7ENIcrA4g==
X-Received: by 2002:a05:620a:3941:b0:939:6df7:73f1 with SMTP id af79cd13be357-93c251dd03fmr205767185a.51.1790128777754;
        Tue, 22 Sep 2026 18:59:37 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9140c45d3a7sm10691616d6.37.2026.09.22.18.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 18:59:37 -0700 (PDT)
Date: Tue, 22 Sep 2026 21:59:35 -0400
From: Gregory Price <gourry@gourry.net>
To: Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, rppt@kernel.org, 
	baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com
Subject: Re: [PATCH] mm/page_alloc: let the bulk and folio allocators carry
 alloc_flags
Message-ID: <arMxm4ia5Md-Zt4R@gourry-fedora-PF4VCD3F>
References: <20260914155115.439742-1-gourry@gourry.net>
 <20260922130558.48402-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922130558.48402-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A76B514000F
X-Stat-Signature: s47ff4qfzp3wrk5uhy6mruy8bw6mko7m
X-HE-Tag: 1790128778-431501
X-HE-Meta: U2FsdGVkX19yopItHV4graL7aKEiuf7NpiqAvl+0NU/t4BPBdu5uiyUq17ZaSv9RQRD6vruNjeHAu81WSwntgSrtspDCZSsk9e5kL8+9SM4XTuQmHL66CggE0MLej2biB9Ks7/j5jlgXOHbSIPZFqfJS1iroLxnYuc5kZST0B/yuBMY6wbFN9MSGUvRB8JY3O67SffHhkkze98Zm6JG1HImBS9L2do5MBC4sOgc8xeFVd1CDwJMWge3xAay2pIaCRDS6OMpRaSi1S/EZy/+23hCDqbQtYhBxfMI4WFfT20Em5O6oDKNhfhMI6ynPVCJCZN+ICZ2xRGrkyTbvYRcn8HXe3foopjpJdHkZZS4fmxckbPJJXb82WJblhZmwLCGUBn0SJZpgSu0zSq33GTx/drIiWXnUgCj92nBBVM3JOS6aUNbVdQTc9uKjl1hEq98tG4VAhDnX+HLZa/Miv5cD+JhAQvGWFg6w1mBZa51ZvAaF0Dm1n8BYGH3bfL9O3tGY6LyUHOg2M3Grf+W0XSsyIFHQxilOYtqwmUvNvZjV7BcIbu1KtXI31LSrdndq/W8ecmHxQYrpD3LE67wm8dE3gjWFgmjKhEmLQeGBDRKR4eckG/FIYYXFJnepy53gP+P/lIExpA9X7acK9lLnVHUQQn0jGo2XJHQgykv7aqQIt2Zuo5J1BZ5WW38qd/blaaDQILgZqPiGc5KT/AJRFGVeobscaTzSxI9gipx2oN39gxtbEOlris90v0sPEU9wAS1t+RHfWC5XOdciPgQThJkDe/f9UVx6i+vMw+Ju77uqmXZcsPQhn+YE4KA8FS4KbLhXF8ax3vktKuN9PThQvuDXvB/YhpEmede/nreU1ddjtTypqfWYntd69qc0GCD06c691fVuQp6im6Xd8GZ07OA8zHxDqDwIx3SMuWWTq8a24+Nmt9H9WSfay9JA8OKHJyJI2IXfPJ1P1vaSgAWV+CZ
 ErVYIKF+
 xCi6n2WRhL43LxUbA7O1v1OmbcXxPrfFQIu+fBNGJCL3D945kfickUdDNiseVMku+0aVmT+sEiLgYEQNZVicbY4c3mNqOPoC7EVyaQsjGGiALsgeCfp0/LXE998DJGtviiCugbpFLwTsJUCF4XC2bNp8qY5vR1bES2DK32Sx1XoCSglMjd4me5olcmpQ67/8cH1lLdSIvsOd/oA4n25YuthM3adDTd4B3oMRs9QK+FbnCTu18XKEHNZ3oFHsX507ylzDlR52F4Efg97h+RWYaH1XJfOCyqyTDjV0nfVyrRPcI7JxYQG4I4c9e7eRfIRZi5KnI8YuOltYq0wNq7tY7CANUbaclf6jM2TIxvaDjtZBmLHAyMcZndcgvk1L1m+byR6WeP5HDYrmexwresxuBl75xZngzvM4lELKT3ugTnQWvcVC0cDvpUFy9vBYQ/uKJS363
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 09:05:58PM +0800, Lance Yang wrote:
> 
> On Mon, Sep 14, 2026 at 11:51:14AM -0400, Gregory Price wrote:
> >__alloc_pages_noprof() takes an explicit alloc_flags, but the bulk and
> >folio entry points do not, so callers cannot select allocator behaviour
> >(e.g. an alternate zonelist) through them.
> >
> >Thread alloc_flags through both, matching __alloc_pages_noprof(), and
> >keep the flag-carrying primitives mm-internal (page_alloc.h) so the
> >public gfp.h wrappers stay flag-free:
> >
> > - add __alloc_pages_bulk_noprof(gfp, ..., alloc_flags) in page_alloc.h
> >   alloc_pages_bulk_noprof() becomes a wrapper passing ALLOC_DEFAULT
> >
> > - give __folio_alloc_noprof() an alloc_flags parameter and moves
> >   __folio_alloc_node_noprof() moves into page_alloc.h
> >   __folio_alloc_noprof() is no longer exported
> >
> >No functional change: every caller passes ALLOC_DEFAULT.
> 
> Yeah, but what if a caller passes ALLOC_NOLOCK in the future?
> 
> __alloc_pages_noprof() checks alloc_nolock_allowed() first, but
> __alloc_pages_bulk_noprof() can enter its fast path without that check.
> 
> That fast path can reach _deferred_grow_zone() or pcp_spin_trylock().
> Shouldn't we do the same check first?
> 
> Or am I missing something?
> 
> Cheers, Lance

There is some concern around NOLOCK here yes, in fact sashiko picked
this issue up and I've been poking at it.

I've actually been reworking this patch and pulled in changes from the
ALLOC_UNMAPPED series to address this all at once.  I've been developing
a page allocator unit-testing harness to help validate some assumptions
before I post it.

~Gregory

