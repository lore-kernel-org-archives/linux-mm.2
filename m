Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B186C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 15:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9E066B0104; Mon, 17 Aug 2026 11:06:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E276F6B02AE; Mon, 17 Aug 2026 11:06:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D163C6B044C; Mon, 17 Aug 2026 11:06:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A46E46B0104
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:06:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 96FDB140326
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:06:30 +0000 (UTC)
X-FDA: 85111087740.07.6FEE1CC
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id B759C40013
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:06:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=CePP4w5d;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu;
	spf=pass (imf11.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.222.170 as permitted sender) smtp.mailfrom=stern@g.harvard.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786979188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2/V3k2+VTRCLX7oq3npgTgER/osmnRebYVR7TKEEakg=;
	b=wqtzD1dE9Oo0D9QFlD53t7Ml36ON+A3LQkaxY9xDrJw99DP2gdw5EFyvVwDkNcmnkINmL6
	jeQdt0jA2HB6kbYo/4Wf0ZZMMYRrHzJKfBYAnW0qfoRUk2VIvjvrzFFfVBxi99V8B/YUAi
	7vO58Yf5FN8mvKEdadbsinnSiHGlNNY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=CePP4w5d;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu;
	spf=pass (imf11.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.222.170 as permitted sender) smtp.mailfrom=stern@g.harvard.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786979188;
	b=dkX6ZMhOgMgD9i0pQZj1mcB/uGLgPGLQM6pvlBFOpH8Kt2xxeg2CBI6wWw7qjz4Y9BoRsj
	ScKxlRNhDhJIm1M/4D7+8MwPmFLqxUx0gdBvbSOVuthKR6WIFZ5f3c7QsbypB8uXml2ZLn
	Scili6KQQe4YxkoJVYYOdM4BceTN0Y0=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92f0b5ed131so285616385a.3
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1786979188; x=1787583988; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2/V3k2+VTRCLX7oq3npgTgER/osmnRebYVR7TKEEakg=;
        b=CePP4w5dxqCrKarGnS7XctdB12WSQyNpKfUNG3KdlCeGAWathRqlPr/GJBlQ1sp/0c
         nAunGOur0CQ4xh/gYVYuD+lS3lkTc9KmzEAQB7JX9bi7kLoddf+DN4m79SCx1oNraXV3
         TT2+R2KzOUxfXJFoGizVnVUrwsWkSft/Wx5njEtutc94/KEbqObs1RfJuKLLUqI/tXC1
         zWIzKwf3jHAfXrsDmz9VT5qIILmTfFVksuW+NqeCzgKl6FfHRBvYLXQ2uUAuu8sYop4I
         NXQg0pZUGGyzA/H8JmLoczcXkIi1ejpNig+3mI5eCdnhgoA3/rXc011XH4UBezp1zepp
         WauA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786979188; x=1787583988;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2/V3k2+VTRCLX7oq3npgTgER/osmnRebYVR7TKEEakg=;
        b=Hcegb0RiHufom3iLY6wILP/XN8ereh3oK36p8uVSq0BkNdVY137GwlgS4VDzBnccK+
         jGyuiOkJlyHKshEtID7iHx0/lk5tg7pZmxts2uBGSxOvyBGcXcDkypbYGKEAQ2VDGhVH
         xLmuS4bpUoUfQYZ+jM6JCvD7Qtr0W9rYgfUEsPiLvJNRgvMvxnmkq/oRPhgS1DfFxf21
         alWlPMEwTYNSv7LOuxp3+FADfNIkdKNmp5oDZPmRtFZKCrKOkbcC0MKco5nBsAECV7F/
         X2thqUsoyk72KSMwi5EPV6hQ1kzgt2mfkYhUQxY1sLSJh3WrH8SlWCvTD3N7CqqgQ8xo
         QcsQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrs1lTV0MpSDO7vhYrVGk5KiRtbTn54mivGR3Cvgmmm+VqMd2UjyXzGJTJOwvxKa5YO1z6UET17SA==@kvack.org
X-Gm-Message-State: AOJu0YzM36dRUsRRkLq5nvofrYAt3smFoZ4io/J5iOQEE7d7nOHaqS5s
	/VLI2vMWj94pZH3rZ9ngpVSMLx9OCpz1Ru9v7MYTALgO2DQgy/pXnQEAMnwklKrGIQ==
X-Gm-Gg: AR+sD135zbmQg3K2sXMheaX3WZa3lMjpXEoe3KW8Biik87MBca7jq+6yygIhuhMRXcU
	F9OsYFfuDTjL9sEmOR2Fxzdd8DOSZQKD5tmQvZ8Nyb24fE4RUV5bBvsttgJpzAqI8lYQMaXfvbm
	9shmZQ20DV7uJEkjtrtccY+KBY3TNe08IxjVs77NFnHUpp/ss9QxpU1JM1oO7UMno2r41IqDM17
	5MUNuDlBQgQfWJLmpgZ6KDfbKKjXKbGO3Qu0oAcstt+eHzVJ8EjXWqTBVAV3S0ZGaotjy9y5rpf
	98dJOJSv/adm5wXIsUHPLlrN71lPytxiKLskGHjbQguqYmG3NLrV0ImC/X5Ly96EWtRQOEkrBJr
	wiojAfBEHSw1B9AU0ya/H+1/HpZ2pNJgUBl1ZxGbBJmPzOYY/OKbOZ0gYMQ+AckpQyGTkL6H0oG
	SQQ39m/G/4s1MPgrUTWgVGhsL+3tK19HaGlo1Q5+DU4buTKvenWCJ97gocxQYDAKYT/S/Pm6tK3
	Gy1D7eMgVtX18JK1P5fVqe1FXeuxASd
X-Received: by 2002:a05:620a:4787:b0:936:a749:5e5f with SMTP id af79cd13be357-936d2331748mr2194911785a.24.1786979187765;
        Mon, 17 Aug 2026 08:06:27 -0700 (PDT)
Received: from rowland.harvard.edu ([2607:fb60:1011:2006:2008:aeb7:73d7:d8ff])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-937033fb9d9sm65331385a.38.2026.08.17.08.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 08:06:27 -0700 (PDT)
Date: Mon, 17 Aug 2026 11:06:24 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
	apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
	gourry@gourry.net, joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	matthew.brost@intel.com, rakie.kim@sk.com,
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Message-ID: <7deabd9c-04d5-4a45-8b8a-39929c046152@rowland.harvard.edu>
References: <20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
 <DKQP5QC9XTDJ.3MI016NP0NPFY@nvidia.com>
 <02c2e5c7-0d78-4763-90ff-75fa87105fcb@rowland.harvard.edu>
 <DKQS9ADYVLN1.246LJPQ9QQYVP@nvidia.com>
 <9787b33b-b30e-4c5e-a0ee-7f14515c7166@rowland.harvard.edu>
 <DKQU9SQUIKDR.2KEZZPONJ1IJ7@nvidia.com>
 <20260816194213.0e813ed338144ebc81ed4050@linux-foundation.org>
 <472add4b-f16a-4b87-bbc3-98c8aa385cf5@rowland.harvard.edu>
 <EDCC14FA-F7D8-4F72-B780-37D09E26D16C@nvidia.com>
 <EECC6FB3-7559-4D22-B9DA-33E30E5EC181@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EECC6FB3-7559-4D22-B9DA-33E30E5EC181@nvidia.com>
X-Stat-Signature: p976g3bi6fyernqot5bfgtoc7gcrnym1
X-Rspamd-Queue-Id: B759C40013
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786979188-365834
X-HE-Meta: U2FsdGVkX19u4lsP3u7HrBZozt3yRc3ja40n6pZR/E8jAkceL5+PPJCjPz/6TUFs+eY6BRJVLMC9r2HdwkS2wzuC1kEj0I4d0rvNQpprSXiMv9KFdXXay/jcEcWJHhmvOhBcTnMOwvDT5wJ5mabXvBCrmsWYBMRhZDB9hs6yoT6DlRs2Zr6rKQXd5bOWw2mRQuDxlCcJYPC34AknughH+SeI1uvN3+5SvJ0sV8GgSLloLa2ddQUE8p2qlfBFyKJ06+DU5QPbUwUpAbk7F4E+c57PovOerQjzf93MWmNJcONJw/eby605oSmh2Ksfk5WzwwgENxEE1U8WbRd7QiesubZkTR5LOyvnDKdJv/cKLCIbkqmGtyNWyMnWcvgNYJbRqCIc+YYbIehxKFtyZ2tVJUxi4gJwzxLIyujvB4yNK0NWipz3aFx2UQoW1282oju2qlcH99kMN5J6ubFNlVsRHTNPxr5Kg8vQNlwYw+V1+4G9dKFh4MyyOEqE0Lutv/ssmI9yXdKBE1uAofy+ADWlyiU7Vn/PDPhfl6Z4nZLW6cyDiDkYf9mEb02dN/2AihojTQxIO7dPREQ7/waJ7tq3/G+IDnehXfIoMvFf1aYdNEts5Xm86AIrQ+nU+u5Y53Mka2QqbvzCb7xShmh5Kj5H/4UVGPCj3fL6/hQrc38LpOYZcKCpMy75YSLNexnsF6d4arS19MoEf8hvQeqtTPEGh7OZkiTifvpimV/EFMJksoNqk5lCPiesFpK/hama0abMEyGwfAt+Hhmk+cHUdENi9r1QTmbRQhkHCfVb/wUUXmZdXhoMgNYjdy06M/sp+pPfr6C9svUfKmh3PnziCexv/PqTbSXBBHH8AuKSoibhallzpCgBI6RIx77bE6wLz+8fSMkA0hLY4m66zgQGmNVsLcMx7F5T9Tg6a6+5ux0Td/WH0hXm9Pn00nRvFnxf4cmdFDO+YN5RNo57PBxPasc
 fuTMKdAi
 GIyHazd8FetnkCDiUVBL+AVlc9yT9X4SYNw2U5fNWZWsFo1mJaD9U7fv70383EYKEqkhGFLXpJxoZ3cF3DuY8bH576SnVV0LcoVlafjGAadhJOFYgcbxqlHmlZNcG6+lTN0o0ABF+SVsYWrhIRd9A14xMScJUWT07NB+v1yZkMtwrbiaOA7zymQGIUXlo3NFuFyaI0Hn5F8GJ8+tEC1jn/tkYYYNf75lfbpVYXUuiWbHT8OLNaTGSR8mTtusYGLOqmdnxiwwfAQcnHYRWhemyoXoRL6oLP8kycWWuhvmd1p6lq54/XFj/511a4/FspfyZgXyTOAEztlbD9Xbr1ZIRm9U40rsVfsDtRjbelgJTcSq5JB7xQ8WRDjea/9V66fxv9grAj2RHEJxpS5vXrCEXPzoitcKZLIfSettSrgWtONzTSSiRRuwYjELFz2WuhBa8i0jnHLZRkqjmdRq1S7lgNEjVhivN4XznXKSQnhxneHN2+8wIhmru7NtpvodoibxZZPhfClFPPLO3Zi4b6jjGqKQ7yObfQlTHpoXBBcsRj4LtkdQlZECzERpGmxahJDeRt2LyO7nvteznmn/jf2nTbesWHxi2vVOfo7SeQeu2IiTWHczz4oUPDVaVFPEr3EC+aMH3nITFcNoEuONtQQ4r6amszz6Sde50HLW31fKEBmd4b+HQpLeGBa3niFvMQCZqpgCKEgllFdETBekj9vo5rWFXGnq70v0fxmuzNpZXa1gWOZGFOtE9PspmfrRSL0uyNpIjv48uWlQYhi4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 10:37:29AM -0400, Zi Yan wrote:
> On 17 Aug 2026, at 10:34, Zi Yan wrote:
> > But the warning here is when kernel user wants buddy allocator to give
> > what it cannot allocate, a page order > MAX_PAGE_ORDER. The warning
> > tells that kernel user please ask for a reasonably sized memory.

That's fine, but it doesn't have to be done in a way that will crash 
many systems.

> > The issue here is that the inode.c code passes the user input len without
> > checking to page allocator code. Capping that is a minimal requirement
> > to prevent untrusted userspace input getting into trusted kernel space code
> > easily.

I disagree.  If the memory allocators are so fragile that userspace can 
break into the kernel just by asking for too much memory, the allocators 
should be fixed.

Furthermore, it's generally recognized that library routines such as 
kmalloc() should check their own inputs rather than relying on their 
callers to do this work for them.

> >>> Why are we emitting a WARN if an allocation fails, given that this will
> >>> often panic the kernel?  Should we on the core MM side dial that back
> >>> to a pr_warn() and a helpful backtrace?
> >>
> >> I think that would be a very good idea.  Only the caller knows whether
> >> an allocation failure will leave the system in an unstable state; the
> >> library routine shouldn't try to make this decision on its own.
> >
> > In this case, the WARN is emitted not because of an allocation failure,
> > but an invalid input to buddy allocator (order > MAX_PAGE_ORDER). The
> > WARN is for kernel developers, telling them their code is asking too much
> > free memory and core MM cannot handle it. Suppressing that means
> > code outside MM can abuse page allocator. Code like doing
> > alloc_pages(MAX_PAGE_ORDER + 1, __GFP_NOFAIL | __GFP_NOWARN) should not
> > exist, instead of just getting pr_warn() and failures.

Again, I disagree with some of the details of this argument in this 
context.  For instance, if all kernel developers are supposed to know 
that they shouldn't ask kmalloc() for more than MAX_PAGE_ORDER at the 
risk of provoking a WARN, if this is such an important restriction, then 
shouldn't this requirement be mentioned in the kerneldoc for kmalloc()?

Regardless, if it is important to let kernel developers know that their 
code is doing something wrong, why not make the WARN conditional on 
CONFIG_EXPERT or something similar?  In other words, prevent it from 
crashing production systems.

Alan Stern

