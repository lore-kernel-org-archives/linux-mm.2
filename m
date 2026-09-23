Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CB41C9830E
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 17:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 967EE6B0088; Wed, 23 Sep 2026 13:23:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9179B6B008C; Wed, 23 Sep 2026 13:23:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 806716B0092; Wed, 23 Sep 2026 13:23:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5625B6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:23:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DBD7214086F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:23:37 +0000 (UTC)
X-FDA: 85245698874.03.4762EE1
Received: from mail-oi2-f43.google.com (mail-oi2-f43.google.com [74.125.231.235])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0163440005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:23:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=UODT2y6D;
	spf=pass (imf01.hostedemail.com: domain of jgg@ziepe.ca designates 74.125.231.235 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790184216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1FwE1NfmDw+YKo1XdhlQDW5TQG+slKv16o9ht1shLNo=;
	b=YnpV0MWDABtPThy8LJLvqxTvS+/dGY2d2hEO4H6J5NTSQ7deWAKArpCJjmlZF0OgD7q/BQ
	rt551Kpw8OsuSkQpiMYyLYAHhcLhBG5PWahmEC6AixpibgkEdlnXYESbTkhXKJG5L4NbhS
	N8+L9fIxm+vFpW6wb6eJJG4w5J2wGRQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=UODT2y6D;
	spf=pass (imf01.hostedemail.com: domain of jgg@ziepe.ca designates 74.125.231.235 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790184216;
	b=TGuaVibbnyUwuzLC41GOIk98edUeMuRAC9Qvp8EjUGucN2HXjKRBXlOuuTFEBJNpzGlKFM
	vlajSltnbwcACvZ+CpJu6DeDZnZqJ1yerHyRR/IvrZKaUBhc499HLpsHQzzgkkMZ5BM65U
	86b8bnbI2KEO1rOEs1NwHt0DE/wyous=
Received: by mail-oi2-f43.google.com with SMTP id 46e09a7af769-7f4f0d1779dso1184335a34.2
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1790184215; x=1790789015; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1FwE1NfmDw+YKo1XdhlQDW5TQG+slKv16o9ht1shLNo=;
        b=UODT2y6D0wXFFlnscOMnIY4oVKzvcW2mJogfFNeaQSrhjlBJWJ+62z60xV+6MeYM65
         ulF7qY/2u6yXbChHRH5JGr/mVEZJoLcZjJz8nYUC6fwBzK7qr0YKnjHtQOAwfwgznj8Y
         D5Ag4o5ykGzNN7x8XPzeX//PWqOL9SMCngNuH022bs/LTOBm0XR/VRbpzkxc3NWZOMMi
         BvDxlpNBAu7ATQUbCO+1rpk2q6Sr4SMcUsdnbMW+G7WkMJBUy8SRp2ff8edCWj/gFRy5
         h22nPCzRawqAExA2qe8TrTDoWt2H77WmbN16cLHrkzUGs8OI1IaBGo+PDGLs/2aXDJoT
         W9gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790184215; x=1790789015;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1FwE1NfmDw+YKo1XdhlQDW5TQG+slKv16o9ht1shLNo=;
        b=p4FyZKKo5KlZVXsTBYozPOrpdlXRwKAGc9Yd6JiokDx6QakOfrA1SHk1vbGolfe36Q
         ALNmW9cAFr2m1IpT0YxmFt/HzdOynFudpyEdyH9F+CG6GLQmNOE71jG/RhUaGQkLuH4Z
         SZ0BcVXvxNXepi/9+HjwdrfoSR6dORPWdIwhcXB2SyKng5vYvLs6flibn2a3xyk0jx+h
         rp5efO7qqd+dpu18dDae6ONi+aBuCh9lgZtkZ5Dld7EHUEsfmQuYg61j8/zY6yz7Kx6C
         GozogJdjqTTGxROh8YTa4tZWaFPH9WWDmVDnWkfecOKh63qalfEioEzekg4TzcKAH1YH
         2sDA==
X-Forwarded-Encrypted: i=1; AKwUvBxgjMgVlzkISQgt8LNp26cPbaraP6F3U4dgPimyQj0OUhjDMKn79fBUQAiT+s9PBubgBd8eBeGr/w==@kvack.org
X-Gm-Message-State: AFuF++kf1q1b7mWYpJ9ztRsDA9UevFZn2z38OqRNCQl+7Fhv5ojc6K9x
	j36IY6IVsCDFRSs8/30Nh3Xz8j0Hs3YKabS+bwiC0EW1DeFQUzrDwA359m5LFz/TkmU=
X-Gm-Gg: AYBFou0fnmegJysgH4zdHUmBXuG1w4J/mqp1Dn1EO0BFfjW5bY9efeK7s/btzOEofEI
	A/AKspDvMnjcXYbFqfykNiBMFIQ9WxILVZrBzS47QX7xfvIBcrPiYCbSXW2IdDtpCCdrBj2JKw7
	ndBNgFcn1+nuFI3joAOj02s973JOlGreXMPK0P3ANzjpSSsgJQZWT7i/ds5Pqju98IgIEMsJzTh
	iq824s22YF0hyQqqd3pHvIHBkZw1LfbXu99UJcoHATWh/5u0iFGw8QkiMukEOItSMmEZ4PtEoYU
	xVIoy/4sK//G2QIm6A6GeA23xkuKEF5+2SQXbYGLcE+OBYJiQ+NGWsn7yidyMt2z9ffZ/ukLODj
	neUUjFMF7dOMoh/tBNDOMrHihojjQsBjueIfNV9yQgU9jbwzl8f0XZN+LvPui9gvM/rCMscQ4lN
	BVBwdYmVfl/1uVXXFz771e0lpwRCUg2WKIeh594hlGl0bJ
X-Received: by 2002:a05:6808:1313:b0:4b5:5bfd:518f with SMTP id 5614622812f47-4d5b85af4d4mr3232472b6e.21.1790184214658;
        Wed, 23 Sep 2026 10:23:34 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4d5c522604asm2686648b6e.15.2026.09.23.10.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 10:23:34 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x9Qgv-0000000E9nH-0xvE;
	Wed, 23 Sep 2026 14:23:33 -0300
Date: Wed, 23 Sep 2026 14:23:33 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Kameron Carr <kameroncarr@linux.microsoft.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, mhklinux@outlook.com,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	christian.koenig@amd.com, Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
Message-ID: <20260923172333.GM1540250@ziepe.ca>
References: <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com>
 <yq5aik3w344o.fsf@kernel.org>
 <arOfD6syXOgQhZYA@arm.com>
 <yq5a5wzw2ree.fsf@kernel.org>
 <arOspFxWZ1DjgcAr@arm.com>
 <20260923130611.GF1540250@ziepe.ca>
 <yq5atsng10b2.fsf@kernel.org>
 <20260923152124.GG1540250@ziepe.ca>
 <5cbe0bde-47d8-41ca-b244-bc0329d0d066@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cbe0bde-47d8-41ca-b244-bc0329d0d066@linux.microsoft.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0163440005
X-Stat-Signature: nnu7sjj1yxn6kirr9ef54ej9zhpbpd5h
X-HE-Tag: 1790184215-73471
X-HE-Meta: U2FsdGVkX1/q3IqRvOEf4lh/0U1kQ5qwfzkoDaD7oygOheC+DpymWq0bmWI7pknoz5+hhoB7oDheBzgLbAQfux9GIo8Ah94fSFGE7Pkfq2fEScYDxmZOXTkJYdL31pvEIhMbFcokISgg9qhPB/zzRO5hoID9rWKbjyxc7OVGNllrXPlv98XV8SxSHXgOwVr1OXkN3G8l2TWKErhSZ4xhNAZ1ueGk5c4axH+U70kp2UzT9J/YSdyxCbRGuWyMWw7tVBOhktlN3jpLnGZ3MeMiPNYJr37/scwf5mP48UK6U7oXLtoPaoFVebwnUhIxVudPGHXt0g9H0BCUVyY7H1fBdEi5tbm4ZmITMFqrvzYHEp91LnGRKBXqm9qhzREPjo/D+zhCx+nz1vBOSeeGY7GazsMz/NMjqDx1AiDEpQ38IIyTsVPlEdfjS3DbgkHtwYhAMRdQCzQWIwZ0t3RPN00Eb3/o15zdowOk91ctT/ZS73xjEc9e9xxkyFrSBeqorIb9P/MVLGll/sB+wTv6ARvvCeCafXEH9ANvDg06VVjs1A3UcOrv/gyfQAtCq7xhA8XHWtgsgbgWvupidgdq37k7ChB7AidyTO9OETTTQEkyEAJcOjD9AZqz3KNdeaaB9X94eOuzLebx6+HTUTZy92fDFsqLW/Uw6r4XXp/h8FwI3QuKNRBIlyW+FFn1iaN6iV6q2ceW88/GXVXj+08mOb9r3QdSUahnwg3+DI9KpvP3Q1LPlsMm9d4w0iy1r9LfVIYLnrhlTOTTwjhRYBDITS7NS1dnsDcrUn5oq+gzZ1AjyI2LnUn4sZA8WDF9MJUp2W/N3goiNW603JC6PuByyeXg2y0mLv1O/XllSiaQn/2SzZoex1gehZtVShaXbDO1JQHz4lMl2ZLrvZgLl7m1aCysFnposWWo7bmzeYbWyN9MKlcapLkyydTL4jsB2sv3tqkIqirhsylvx4DRRCeO0gf
 mChup8rh
 a65X5NuioaeEZY/NxBo8UHGhBmK0JNt5+i9tsHsveWQ7py8N6+khfAvs9C7lvLukq1a4eq2q0MGIIbnJ66uSE7GTFgO7YS/+mKFqeP3wurabJJnUD9Rp+DQLNq70lQbzLKMThg9BQb3CWna22iTz1GE1l24/GFa4/fovSQIA665bwtL3PxyaOTvitEVuoh6xoY7YKmqQmuAYMb6WeZbAs52b9UWE+rRxXhziKhty0G/FZ5335dpbqsuGJWmFPqpGPW0sA0+Ed9MAbcV1Wnq8jRdEdNgqnTbCwZHp/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 09:28:54AM -0700, Kameron Carr wrote:
> On 9/23/2026 8:21 AM, Jason Gunthorpe wrote:
> > On Wed, Sep 23, 2026 at 08:28:57PM +0530, Aneesh Kumar K.V wrote:
> > 
> >> I'm also considering requiring the address passed to cc_make_shared() to
> >> be in the linear map. This is currently required by both TDX and CCA,
> >> while AMD SNP appears to support vmalloc addresses. The only user of
> >> that vmalloc support is Hyper-V VMBus GPADL setup
> >> (vmbus_establish_gpadl()). How should the generic CoCo shared-memory
> >> allocator handle this?
> > 
> > vmbus_establish_gpadl() is the the same wrong abstraction as the arch
> > code. Get rid of it and use vmbus_establish_gpadl_caller_decrypted():
> > 
> > 		pdata->recv_buf = vzalloc(RECV_BUFFER_SIZE);
> > 		if (!pdata->recv_buf) {
> > 			ret = -ENOMEM;
> > 			goto fail_free_ring;
> > 		}
> > 
> > 		ret = vmbus_establish_gpadl(channel, pdata->recv_buf,
> > 					    RECV_BUFFER_SIZE, &pdata->recv_gpadl);
> > 
> > 
> > So you made an allocator that returns folios, now you just need to
> > use that allocator to implement a kvzalloc wrapper. ARM can call vmap
> > on decrypted memory with pgprot_decrypted(), right?
> > 
> > Or maybe this can use vmbus_alloc_buffer(), it already does it.
> 
> Michael Kelley recently proposed [1] moving all ring buffer allocations
> to use vmbus_alloc_buffer(). If we move forward with this, it should
> remove the dependency on vmalloc support.

Even better vmbus_alloc_buffer() can use the new allocator API
directly so it doesn't need to open code the set_memory_decrypted arch
call.

Lets do it!

Jaon

