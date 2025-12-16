Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03429D609DE
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 19:58:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 405C96B0088; Tue, 16 Dec 2025 14:58:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39C5C6B0089; Tue, 16 Dec 2025 14:58:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29E9A6B008A; Tue, 16 Dec 2025 14:58:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 18EC76B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:58:21 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A36D55A67B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 19:58:20 +0000 (UTC)
X-FDA: 84226395960.24.D076077
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4785A120006
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 19:58:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="LfbZ/dD3";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765915098; a=rsa-sha256;
	cv=none;
	b=Rm47VQ5JUKBdOHhSCbGSMiRMhaXb1egOuA8a3us04DYKYpF09HgAq73EEAmGtcvRGiT6le
	8V5qoqCZkW3sv2udbiSa8eELisTMgNbmYMvEKqKVqGydhLpwWjdSA6D0xXotHHVnClailC
	LAzatj+8M5EQMnbr53qQqF5X+5Z/Rmw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="LfbZ/dD3";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765915098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WILoW472mfGqus7f3vqpilqOzoz0h+z/dztTyHfCBuA=;
	b=n4pcYBAgggfS8a3R1q7Bp31ywciWcbEjL9F8CXU8bf10ZOXi6PfARthaZ8L9bUawH2FQ7K
	xsaBKYPSn9q8LO6SCvErvuYT1CB15p+BXaPx43CbN40gyofAJg0u9urcfiMQYhk5LwLqyJ
	Fd7iRXUyCgwFLNolVgkp269AezfzRfU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765915097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WILoW472mfGqus7f3vqpilqOzoz0h+z/dztTyHfCBuA=;
	b=LfbZ/dD336KfjxZVrv6VkoZBrIeL1tnIqgl2HR96bxjQv3iXeO9uz0gPRDRe50gYeLrPs/
	XTJhZ8QIOLXthTy4HEXasrXeqX56y9LJimz7UGs5yDIDz7iMHslvM/V3kdvAInzS14BLas
	2f5z4zYOEymRwjQy5HFbJnMY8voQEAE=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-bB7k2heJM8i4ILWdQVxIpw-1; Tue, 16 Dec 2025 14:58:14 -0500
X-MC-Unique: bB7k2heJM8i4ILWdQVxIpw-1
X-Mimecast-MFC-AGG-ID: bB7k2heJM8i4ILWdQVxIpw_1765915093
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-29e6b269686so117027755ad.1
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:58:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765915093; x=1766519893;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WILoW472mfGqus7f3vqpilqOzoz0h+z/dztTyHfCBuA=;
        b=t+NcjjkzyXjbitk6SCtdwJYUuQM+3xqrRCvw+/zeXi1wCccBQvgiMgxsGFTUICP1bZ
         KEvbpSNAoN0B/7HQhuIE4HtXaoGk6K72qcorUUwRYOZHgATWy6ipLShDCn/YDDS5QYzH
         j/nhvqZs8bsI8YaRHn4NbZh+qI84yDG5SC9FnJEAM99S1jnP0ofE9++3v4QO+gDfrz0r
         wQbnCt7bn4hUA8y19XDzcnjvTl9SYT8t12Vj0Qq1aUUHhPv9lDLoTYgF/PE0kM8jkWAf
         7DRnYk2fhfyEw6RC4tvJCL4n5qh8u0JcAoiENBCkRVI3j0XtKC7jOvoZij7/0w9NETyz
         TMIw==
X-Forwarded-Encrypted: i=1; AJvYcCWOcu/oIFtcx2C/Elwwm8Qr979j8nzR111bwGcZ45smitzwQ9JHBKWhzAmWzg3BhbDAvptrNVQ4yQ==@kvack.org
X-Gm-Message-State: AOJu0Yz3D7Q+LnMpkPYTHf6dAMgdsYz33UNjR2ugw4kzzsnWrtlM8mPL
	KmVRUZPB8vhuIqgLLOBT/8s20TkeUqIvGl++KEs4juDnuvggCrJGvBR07UwBqOeYJ1xtL2fVv65
	kI9DWiviMEXhqsdPy/gSpfh2qeCv/dvyu85r+2HZECQA99/oPUAnk
X-Gm-Gg: AY/fxX5UW6D2HJeyffB7nyeghaj+pvbAtp1jA6EG4PgxWVdH6DTFVlKCT24fhD7JlgR
	tuklqLHpQ8JjEcmquJTwPtYo2sVOwT+pxlSVIs8d8CxZngEihZcSrakNNSax4K5Q1L2OJIirU0n
	ATmLXKpafvFr7DANCfPSBSuJ+kIGAsmE1D92D0nquWdS9OV/vrH8PgdR2egesylV6bEELQ+NCW/
	L+n8Iy/pEe/sOlQRc/Q15R1EmhqE3i4VSbVHMwWPzseRInTgX0fDgntsAODCnfNQvUdDxFJM6Xr
	t2mmFz+kacjY9qwsjCjVfv1lguG7L/eocr27SjX8gOnuRe3qtavIU6RHwPTEkNQbSyZZIKqBUlI
	bz64=
X-Received: by 2002:a17:903:3bad:b0:297:d45b:6d97 with SMTP id d9443c01a7336-29f23e3618emr164955795ad.14.1765915093038;
        Tue, 16 Dec 2025 11:58:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHr2X5JE1VeyIh1e5EanKDeX9YYmMdGAHNX6spNNWVf22t0T9F/mXgE3FmtoXHqzC5TX7vXhg==
X-Received: by 2002:a17:903:3bad:b0:297:d45b:6d97 with SMTP id d9443c01a7336-29f23e3618emr164955555ad.14.1765915092528;
        Tue, 16 Dec 2025 11:58:12 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a094398ed0sm110452725ad.27.2025.12.16.11.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 11:58:11 -0800 (PST)
Date: Tue, 16 Dec 2025 14:58:03 -0500
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 4/4] vfio-pci: Best-effort huge pfnmaps with
 !MAP_FIXED mappings
Message-ID: <aUG5y60q03RedLwv@x1.local>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-5-peterx@redhat.com>
 <aTWqvfYHWWMgKHPQ@nvidia.com>
 <aTnbf_dtwOo_gaVM@x1.local>
 <20251216144224.GE6079@nvidia.com>
 <aUGCPN2ngvWMG2Ta@x1.local>
 <20251216190131.GI6079@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20251216190131.GI6079@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IOOuL7eb8apKct6GjK2XCWDmwvoVygrCY86PjX_7e70_1765915093
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4785A120006
X-Stat-Signature: 7q5gdugh6si89wgqe7m4xjrhbn7becmn
X-Rspam-User: 
X-HE-Tag: 1765915098-937910
X-HE-Meta: U2FsdGVkX1/RmR/fYz1vR3P8qhj26iMiFc/FL2IAwJlHiOkk7YwF4U1BrbIf2pRL1fDJ09p9wf8deAE5PeGDjj3qUEqtcW6rU/koavnQ1Tb6JXxzEJOZWCSHA6vCVKNBDUvEUh47el2YxvrTby1A9KvbtZ5XG4M2hkJFocGK/chOs6fpAZEqj03Ry+2PKwtijbl9T4LkhG7Mpfm2CIE8fXv1T9X6GQBEuljY/5kbQYBMHNul9ySEU7XDKCIUBarh1pg1H8Ct2BbJYEXlGsdiFBl23zNq/qX+69hIbFoe/3qmNj/AhVr83WmYG3pYIygnhtjXVGDy9sZHKrYmMh+3+77bq+6rDC21W9gCFjPibYs732R4izRf1zFe1MfD3OEREpuNDAX9LTs8rS4PX5yqDMR/xRGW8Rej3k7A405ojnaRuilTJK88pHdqzKKj2Qg6WJM1aMyvsFEsfgjLjcb7QlvSrydi8UH39gWGccoJsEnnqzKOnpamnl6kD4K7uyFFjNL5tpJypn4ExQ82kvsld4ZGgZmh+Mw7iyOPO55jClOm11SLIP6sSyOofQtD1IkeVkU/FjdjZO1Y3RlFpl4d6Ql3H0W2JKsWksjHjgXbkNylIOoO2DgR8nAJm62rJe/lX/RpSRDs006OJQl/DWzS+8qE4PfXHrDJGPhDcOpa2Ogr36bVG7T8++mXeOTsN2A68HkpmvWhI3Xvo5LTOblYu664XwLVG4RkVUni3Kr0+qHVCsGJq9sCnhwnijIkWH89KU4Kr1qp0LxEMqRThiI0UEpF0Fm75Ud1ppg3q3ebA6D4xHtKOX9xsv/F9J46k3AKM7ZTZZYOWeJ08iJjwT3cNJAnbLICCW3U175iGyBpkYai9MY3FSdwwWILjKbqLVxx/ZUEFjSx1QnIsYM1t52nfLgfIghvUGqi3r0blDB1WrbzoeUTuiW/P8zq7VFRrr74pBGTLBVz+EYgI7I5RQ/
 iK7WCD2e
 +DNWjAx+U7G18xADTao8z2JZOaungFe/z/8InvtRGgD02lFGwYMMt9SFnRjexqYQX2srUR94InxWxXAMCLaIUbjsnMY4jbeitVcEsXJHptW8ZUXNMHEgf1MX77dRH7Fx1l2rxm5U7rHYGk3SpBFeWNIZ/VMDA2RUwLxJblgEa0C8bMb3g1hoXAF1XFTbkfyGd70QeE9kNVeJ3usoQjS4f0du2r80m5ry+w6ARUiSwSeHdo0jMPr07IpHZNUDqXNR5ka9YwToXfY+YWb7GwOt/W58zQmiKsFrilJVAEbrX5L7eMTQWjfj3VRBEYrKHt9uwGf/8Oq8+Ib8KXSFesArCEJOmN529HlmVohIK3nnGkZQX4gHwIuPH3D8m/DagHEmkDsBn14IU6X3U35y7jINwiB28gqRLz81pniOCtQRCHswAbZ05HQ+7pgVrE6aoQa48/DnofKDFke9X4CICjErPe5uAkdoHwYq3v+0ZIDZ8N2IEJltmvpeWtrp7804zCBf524q+7d/LoV2anzuHwCtGXlmqR+RoQZKD9tdEvQAzMuVK27z32E/BjV8wuJrcmwP3zKp0IWCKX/PFIHJAWftTUb/kZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 03:01:31PM -0400, Jason Gunthorpe wrote:
> On Tue, Dec 16, 2025 at 11:01:00AM -0500, Peter Xu wrote:
> > Do we have any function that we can fetch the best mapping lower than a
> > specific order?
> 
> I'm not aware of anything

Maybe I can introduce a per-arch helper for it, then.  I'll see if I can
cover some tests from ARM side, or I'll enable x86_64 first so we can do it
in two steps.

> 
> > > None of this logic should be in drivers.
> > 
> > I still think it's the driver's decision to have its own macro controlling
> > the huge pfnmap behavior.  I agree with you core mm can have it, I don't
> > see it blocks the driver not returning huge order if huge pfnmap is turned
> > off.  VFIO-PCI currently indeed only depends directly on global THP
> > configs, but I don't see why it's strictly needed.  So I think it's fine if
> > a driver (even if global THP enabled for pmd/pud) deselect huge pfnmap for
> > other reasons, then here the order returned can still always be PSIZE for
> > the driver.  It's really not a huge deal to me.
> 
> All these APIs should be around the idea that the driver just returns
> what it has and the core mm places it into ptes. There is not a good
> reason drivers should be overriding this logic or doing their own
> thing.

I'll make sure the driver will not need to consider size of mapping that
arch would support.

> 
> > > Drivers shouldn't implement this alignment function without also
> > > implementing huge fault, it is pointless. Don't see a reason to add
> > > extra complexity.
> > 
> > It's not implementing the order hint without huge fault.  It's when both
> > are turned off in a kernel config.. then the order hint (even from driver
> > POV) shouldn't need to be reported.
> 
> No, it should still all be the same the core code just won't call the
> function.
> 
> > I don't know why you have so strong feeling on having a config check in
> > vfio-pci drivers is bad.
> 
> It is leaking MM details into drivers that should not be in drivers.

To me it still makes perfect sense here to pair with huge_fault(), and it's
driver knowledge alone.  It has nothing to do with leaking mm details.

I think I get your point above, maybe when the core mm fallback paths not
available yet we can mix things together. I'll see what I can do when
repost.

-- 
Peter Xu


