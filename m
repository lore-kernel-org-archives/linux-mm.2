Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD6D3F5A8CE
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 23:33:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A92A6B0088; Mon, 20 Apr 2026 19:33:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95A086B0089; Mon, 20 Apr 2026 19:33:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848DD6B008A; Mon, 20 Apr 2026 19:33:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71CFC6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:33:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E60861A0B30
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 23:33:47 +0000 (UTC)
X-FDA: 84680538894.08.EA7947C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id AABC740008
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 23:33:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XqNd5nZw;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776728025; a=rsa-sha256;
	cv=none;
	b=Gsaduo0PG3KSP4j242CqfzVBFHtVPHbIVDGt0Ioe920EeGcjSBJyqoYusx/kZHS1ZR/eOa
	3r7b2MpdYkhrO3VSNb+Fka7qHwa8gK/7D6tEfPlCDmV28IuZ25tMRsZtEAYAJ5FtPtqRKt
	KoAV+XgqsbFk6WbDU3GN6EDTYRi0S10=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XqNd5nZw;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776728025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Crl5IidACm0/Y50tYB/yaiHCDukvD9pxpf1tedSp32Q=;
	b=qJeneXkvf04r65XJ6zYg1soddg1olm5VWbwLHRHnSDLbGTgEt4Thkkbb168DxnrRxAIw9I
	MsC3MF7bJrZ9qezGEpdhWZYE3qVvxN3fxryvj0s8EV85gGSUdxoDuOio9/qr4rAcITPohO
	YTKX+DLbcnAW5AZBW13BkVwmzBjy/CY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776728024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Crl5IidACm0/Y50tYB/yaiHCDukvD9pxpf1tedSp32Q=;
	b=XqNd5nZw6uHDMoZFQVhicT6SAlbrCcS38jI4C5iqMj/oE0xoX66QaNSO2CyarHjDkI66vG
	/tYviE+Zxp27+J3bIc4oMAieV1exBZ+e49qHHotXxbqAFmglM69erGdoc2mSx8+YRDQN1Y
	HuTYFl+BIXV889OOc0wsIq5km7opkNk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-SvjnPUkmN52XJwRjTBRZPA-1; Mon, 20 Apr 2026 19:33:43 -0400
X-MC-Unique: SvjnPUkmN52XJwRjTBRZPA-1
X-Mimecast-MFC-AGG-ID: SvjnPUkmN52XJwRjTBRZPA_1776728022
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43fe4674d3eso3756991f8f.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:33:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776728022; x=1777332822;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Crl5IidACm0/Y50tYB/yaiHCDukvD9pxpf1tedSp32Q=;
        b=iLyA8jzUY05O1z7FdaWIogXGZ/2Zn8V7lJh0xgK7i+3m9SFiMek3Ax21qObns7oTyk
         7QafaqPRjboIg96BTryJqMIO7MkX3w+qfqYvbrEvwhajddJh+V14fHDFfzhSBm4znFsw
         u/S6/UOntmc5MWge+JrEW058aLyUmdqCgTl8XF3m18DOwmjC0IdfE0HT9AWfEBp7Qs7V
         PFrZ/ztRN+OcdxNJGBTGW8jct65zPBxqjPuZxcdR77njhFFJi6H43s8K5mXtFfPyyu8+
         uPupAGYrV4bjE9Wd82pzAxPkxTzWMoLpm1EjKxPEnwtsi2zLMwx7bptwEwPi/3baTH4c
         qbCw==
X-Forwarded-Encrypted: i=1; AFNElJ/XINgjxBtqH1fqxxDvPUsdRww3dUkrRcuB01xiqjfqpLyeOSolmwTdKWI8SJTj3s44wLyjZn8mtQ==@kvack.org
X-Gm-Message-State: AOJu0YwmWpGga6sdF8yjnePPuQEFYWX7Bk7ee0mNgiJ38pRP5QXBKqAW
	wo40yqitMxun3UwDJvAHrNUExHq4/IqOzGhV6z6/eVI8iQjQ9PsQIeJm8cb1kti60eoyrnrt+wl
	MkO+ei7xoQEYuoE/TkaTVczVDq9ZrZkfDcJqVlypQlnaWCwi70cIV
X-Gm-Gg: AeBDiesct9rfO0kMbLLIMs5IL+mhtWHid9yAwX+XqghJg5KNqyovgw1sTWUoyacsk4K
	vOCFVOc9U5Z5BE5Aq+QZQ+faVOvHDUI4LmNqqIH0hbDT99VfNOAhOmEYq1gX+O1bR2lEi0stMCF
	Lq7uRL+9NJJ/43dBYKQcCc+nRg1DYyutZQL4aSZ0QeYKFGxpjy4/E5Ylj2nmHmLY7adTIMSwV8x
	KcdQ4Hb0mDAXiOlfM7Pf4ZWQ/rlBVKo9B8Yc9JdkVb6R9d4SektE6PxNre9tqLkOo7ZpLwNpQWO
	9K2iRN652iMiNXbiKPbByiVYRkiyccVXDvaYAJUHP/j7CgLY55+wdFriqZLSefCOBvfUa1cTpvy
	ozLwN6KkJ6scGCYSW92v4YGYT59wA5lzKyYIiHbVnBkwKuw6SYEiieA==
X-Received: by 2002:a05:600c:5294:b0:486:fa35:aef2 with SMTP id 5b1f17b1804b1-488fb73d53bmr206894905e9.4.1776728022104;
        Mon, 20 Apr 2026 16:33:42 -0700 (PDT)
X-Received: by 2002:a05:600c:5294:b0:486:fa35:aef2 with SMTP id 5b1f17b1804b1-488fb73d53bmr206894725e9.4.1776728021660;
        Mon, 20 Apr 2026 16:33:41 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488ffc558f2sm191637225e9.1.2026.04.20.16.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 16:33:41 -0700 (PDT)
Date: Mon, 20 Apr 2026 19:33:38 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH RFC v2 00/18] mm/virtio: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <20260420192037-mutt-send-email-mst@kernel.org>
References: <cover.1776689093.git.mst@redhat.com>
 <c199e47d-b2fd-42f3-9e50-c47c848dc72f@kernel.org>
MIME-Version: 1.0
In-Reply-To: <c199e47d-b2fd-42f3-9e50-c47c848dc72f@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: R5txeax7jBLrYCPruF2YQavLhyMfkmhEFWl88Nd6jqo_1776728022
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Stat-Signature: g4cqsk6r5qooq7hwywd7jc6dnqxh3baa
X-Rspam-User: 
X-Rspamd-Queue-Id: AABC740008
X-HE-Tag: 1776728025-935759
X-HE-Meta: U2FsdGVkX19Fn27IbfNcwUcMTBCXDDDUVrwwZLY9trAp/McAnqcwn6CQlIXzmJAgi0XGf8iklHLCznaldyHfmcPlJO1hBFoz7aIiBll1UQO8LjxZrkQQEHMZRoqObPEUdJaSYILbBwSekbl15RPN17z4RHcBBnwnQ7k7k/ipRty1ljCY/kj5Dxcx8ijFhLIrTZuN9pFroCmuCqUf6XN3LCLiP3U5CK6oTZUulbrqeyceqvoKoc6ZojFXRDPT3QZY9i/FWrO2q1YHltgC14jFBR/4qMx8zrylEN3URX6UiE6nKAcHWK7rD9Gf3BRT+rVRG0BojIZOVwQDxoS5hPXEZgXTGMrPDBHdV4XpefRV+nuL9S5z/Wkh0f2FmFxnyxIYt9aaOaVsN9A+IGVqesxSMNlSe3a8KCeRIQAK6xMC+/FQNTvcSdPVqgCYmYxWXp+W6Su5zUo92vzIvWTZfS4xjKxJaaHX9YEIjN1vNTRQvjH//hl/5a/8V3IgvYVIaN106Y74PegHRtqGoRaf6UN5eHt4U8NKLlTWIyI6Z9H4RwjimYYWqrBYflSn+o9Hw8gXsnQCrtawOJKWe/xMY/A4tOLcIFFWKW7U64Ad1DOT/3v+CwJ72HSzy+kMU2EE5JndpRzHXTYeEBmUOqD6SJ2sBEFa0DyGYVzVPhlyJUsrtR3n3OqEu7urKpXrpkBLEw7o59KwM7FW09keQAsmQGV5uOS9co7vBlQjaYwjEvhlOfFHPHBfwcs8rB9GUtNnJ2PHUBbx07PPbW7aVgmuUyYEmwv5r4IrIecgWeEJg48FWruCXNRBTW9L2P9ZP9nGh7yFBNVletd8CpKNWh01AEhtVFoBiyeejt6vagvjgsRaqjf7YWoF+02/ebJr+Pmnt/+4W5ObEdVbWtspQJy5e5BXAo7KOfipe7n7YDU8aU6IcntP8MtZG+K5dxShRtjUtvC4YLZsP86od8vARxtDo6I
 +GRvMltg
 YccU6hEW2V7ctvbbUaNj0VpYhYoYYnvlscbD8MC9qqGW49UBYkJ+vBZnyDWYl4YS/hdKMTfVSU9exl6V1/vbiA7Wd7sqmtSPmbKArZqxgh2kSyUEvulE4m/cXw7pOYdJRzMG0i43Od4CBiuXxGLYo3UkTrpDYu9eOyhQBsh0zoe5L7ZOMr2knRj8xtbB/4qiTXfN/+s0Jpq9z4jgg4ELeiV3dAuVzVpag88AMhGJCaMiiBarBZJI9lU5ToMo+q5v58QH4X5OY9pw26kZi/od9gLcVYp0T2Mu42IJ+spg5/48eXykuJWcDanTnQMNpay8Dyvw7gqpG7WBEcxvg7X59sfP67TeAXFfB2XBf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 08:20:57PM +0200, David Hildenbrand (Arm) wrote:
> On 4/20/26 14:51, Michael S. Tsirkin wrote:
> > 
> 
> Hi!
> 
> > 
> > v2 - this is an attempt to address David Hildenbrand's comments:
> > overloading GFP and using page->private, support for
> > balloon deflate.
> > 
> > I hope this one is acceptable, API wise.
> > 
> > I also went ahead and implemented an alternative approach
> > that David suggested:
> > using GFP_ZERO to zero userspace pages.
> > The issue is simple: on some architectures, one has to know the
> > userspace fault address in order to flush the cache.
> > 
> > So, I had to propagate the fault address everywhere.
> 
> As I said, that might not be necessary. vma_alloc_folio() is the
> interface we mostly care about in that regard.
>

I'm not sure I follow what "might not be necessary". We need a fault
address so zeroing can be effective wrt cache. Since you asked that it's
done deep in post alloc hook, the address has to propagate all over mm.


> > A lot of churn, and my concern is, if we miss even one
> > place, silent, subtle data corruption will result and only
> > on some arches (x86 will be fine).
> 
> Which would *already* be the case of you use folio_alloc(GFP_ZERO)
> instead of magical vma_alloc_folio() + folio_zero_user().
> 
> I don't really see how vma_alloc_folio_hints() -- that also consumes the
> address -- is any better in that regard?

By itself, it is not. But the issue is propagating the address from
there all over mm. If we miss even one place - we get a subtle cache
corruption on non x86.



hints are exactly that - if we forget to set them, all that happens
is that we do an extra zeroing. That is all.

> When we just do the right thing with vma_alloc_folio(GFP_ZERO), at least
> vma_alloc_folio() users will not accidentally do the wrong thing by
> forgetting to use folio_zero_user().


Well, it's simply that
1. if you plain forget folio_zero_user you get non zero on all arches
2. we *already* have folio_zero_user in place




> > 
> > Still, you can view that approach here:
> > https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git gfp_zero
> > 
> > David, if you still feel I should switch to that approach,
> > let me know. Personally, I'd rather keep that as a separate
> > project from this optimization.
> I'd prefer if we extend vma_alloc_folio() to just handle GFP_ZERO for us.

Pls take a look at that tree then. What do you think of that approach?
Better? If you want it in form of patches, I can post them
in private or on list.

Let me know, I don't have a problem with that approach - I tested
it and the performance is the same.  But the issue is that there's lot
of paths that have to propagate the fault address. It took me a while to
even find them all (assuming I found them all).


I also note that we need a flag for free in order to implement
balloon deflate as you asked. Here, I reused the hints.



> But let's hear other opinions first.
> 
> -- 
> Cheers,
> 
> David


