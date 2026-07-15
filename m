Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22FBBC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 15:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B1A16B00AB; Wed, 15 Jul 2026 11:02:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 187DC6B00AE; Wed, 15 Jul 2026 11:02:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 052D66B00B1; Wed, 15 Jul 2026 11:02:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0C6F6B00AB
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:02:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B50C1C0114
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:02:16 +0000 (UTC)
X-FDA: 84991326672.01.E60CA8A
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id 543D9120019
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:02:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=c+1GHKgU;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.217.47 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784127734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nGecurzBYdjUfiEExv0oL4FVVbYZSUEIMh9OhYH+0R0=;
	b=eRnO8wMft1wdHY9eG24QG2Ji0tOhbof13r7I3Fi4zcYAtVIta/zpjPz+eRgEk3eNZsU6UU
	X6YpaxSGxuuAHtpGL0eOnF5OzSXJ8gLy+Ohkyjm718GpcL4jfd3rLrZyc8ykQWVLU1388s
	kWlWPuSF9/3NdBNb2IkAwHglKSVOL/k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=c+1GHKgU;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.217.47 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784127734;
	b=iBm+RajxZ3zlkkwuGaqU3UYJ4mo7hKUK/cfECQHErTmS/ObLGzhbAQBMXUn/jbfdsSGlbd
	LAevKQ+Enx3qS2tkoBo4eJaB3/Wruf0wgMTscJSXRNBgYmYJDRK7lrhz202TH2M9VhlBPq
	DpqX8D1MLHMbeKptJVR/oEGSl9KXHIA=
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-737f6e70678so3880083137.0
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 08:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1784127733; x=1784732533; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nGecurzBYdjUfiEExv0oL4FVVbYZSUEIMh9OhYH+0R0=;
        b=c+1GHKgUrV2VEG2iEH8W5VwQfd2yK8Jk8newZeU5YkuUAXe4pl9ZxpNNMypbHs1Sbe
         LkriiScc969j9MHe0PPx3F31qB8rnH4L+G5oJlTk8WO4AjiIMQLNxQ+7vMeYuEuWuVuM
         mvgGegTOxGu135zSodUvQpgT6B080uuKnHXeYQs16Sce5fUl+0xGkPZe5apT5meMqk2P
         mmV/OHPQyGxfOYzFDM2kDcmZbC0XNbvr/uEaL1AjWC+P0ZTe6Ooq1c7YsFx/I5FNuYoO
         QWCM3dCXEAMGI3+4d6/iouzjafBBMJ0Jfy7VJlK3hOb01fP/HwfCKpHKHoMDxC260pDE
         fX+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784127733; x=1784732533;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nGecurzBYdjUfiEExv0oL4FVVbYZSUEIMh9OhYH+0R0=;
        b=EQ/Gf7bweeIXFZpjMmXXxH/KdazJT1ad0/6PwPUWkJQY7NaoWO1Jvea62+pbsftJGL
         BpjZHoAojYhuq/2/4ouU7e0iGGFbYpFke3PVLzg8+E+gnNe4TfSZccI1GhjNKwpEjdfe
         bV2CZuw3ycBwv5m3SIx7xPz7vXXUYBDp3878/rjIVEieXd1nBicL3IdEeDOAlqBCynHl
         ++zwJge6EQ2tj6cGLWQt1EKIftt5ZkYBXdAsiFC0bGNoFEddrnUvqFG6/29Fq0DvjXKH
         ENL3M4fGFreY+0Mu32ara/DYzJ54LS/ZTc5QHYo0KWVd3RQ2oOYbd28ke9NGkxvh1Ipm
         sgxQ==
X-Forwarded-Encrypted: i=1; AHgh+RoyWkPUcJ8P+TcS7WiLQTFXXVXmAlBQZICjQpxOROYXA6dpRVkjlYDxZsmdt2DOBH0OkcliWr/CPg==@kvack.org
X-Gm-Message-State: AOJu0YzT+uHAn8dOoKJEmJB8tkzqINVtTciWceS/L0RjNigw/8NrvI2i
	zEKNCXEA74+464mMhpZJ/2LJzk9MgTrYmVj3C3OCmp78icIV8ERxhHc76JbRGWpZ5Uk=
X-Gm-Gg: AfdE7ckGWEoCELVYsfmEPDxtFPRwNi9woAIrTP29b8+JU49X/LVrJoIwZ62qnNrL9uR
	03Mys1PQGhWOUtRlkhVca0d6hC4pdICRg0rnMNVcWvFS8426qmvvoF+69VGEeymTc00WMXdKR/F
	dUjvjp4e+sgZTV6jCa5ZaJoC8fybaC/Q5tiTRjgAbUx3zOzIBCkI6xeoPwe1nJ1l4QzHwwQwgs9
	yoZmIZErFdwjs3Tcc+cFheF/kFN74kgSXG14PD7YizDEebkVzcEqJCC1DJiG2bFbxWZoHDhc1qI
	/qIHgriJ0dRl8COSP+M1VMJ1B+karN7upzUC/YzWUIck6DZpN/43QE70FmUQKpR0EdaQT4xELr+
	gQ/prQ8TWpS7ATUTwILPmh9y47lVG/EP6WNX083s6bPOZMkxxoHfM1uwkZSqB
X-Received: by 2002:a05:6102:d87:b0:737:9edc:36f6 with SMTP id ada2fe7eead31-7458757b204mr4167130137.26.1784127732764;
        Wed, 15 Jul 2026 08:02:12 -0700 (PDT)
Received: from ziepe.ca ([159.2.72.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd50e0811sm196100666d6.3.2026.07.15.08.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 08:02:11 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wk17i-00000000TXQ-3Nvp;
	Wed, 15 Jul 2026 12:02:10 -0300
Date: Wed, 15 Jul 2026 12:02:10 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, airlied@gmail.com,
	akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org, corbet@lwn.net,
	dakr@kernel.org, kees@kernel.org, leon@kernel.org,
	liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
	lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 0/4] mm/hmm: Clarify notifier retry state and scope
 HMM timeouts
Message-ID: <20260715150210.GA3846105@ziepe.ca>
References: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
 <4300f09b-8f93-4605-b072-7c09a82cb16e@kernel.org>
 <alecaJ1FUso39D9k@skinsburskii>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alecaJ1FUso39D9k@skinsburskii>
X-Rspamd-Queue-Id: 543D9120019
X-Stat-Signature: yrryqmid834t6wzo1kkenwwxsdkwcs1i
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784127734-817472
X-HE-Meta: U2FsdGVkX1/OEQg2zoRGCpcjvTfFq/1ZNx3QPnnI3226strCHozy1N0D2CAvP1sw74RsN03xe5uMXJEk/szqF3oUQUGZl1KfJrULJM27b3xPwLLHJuckanJZqHzCV9tMI8bu97RRwTD4LaMjK5ZN6/8j0DB0OjUP7ugZuLieTgcymtd2KeCESiu03jhVKFyvDefOxIt0nYyf6sHzARABPGsuTrSE+ujaOB0Bre6mAfAYVaDnLFZ69r7ZIDK9NfK84Vng3hFlUf0DReSnfG3zR7degSRuC/3x9etffzfMQfKqb6/lUeqXFmHj54clTU5Lc/4pb8LPHJEVpnkXe9nUMVp2BuWthoJZSW7p9eO0uMGUhQEnKNIlyw6yAtO3nMYWVFRapWRgZRHLyPJK0u5QIem4FmC2jhpR65A743Cio9TQdAzKTcwBnNrWtS8qcrJAKHu0/fD+vKvJh1Bb3IwvgyHdVreBonzOPOvh3bGc9DDfI3WgEN2JcaJ7Ja2jmpfzdYkv9nxAUTm6sCaRM0/owBGcjRYLKGMTGPZQv9UGRJVGqnLJ21W9/8S6Z5+9r6L7thAY4PmRAWCvAOAKcFS6tFC8BXf5pQJYmWlW0rcMinCDow0cOaDLnBGY2HUAeZ95mjgKImlNeniAlEx1pJ5sRBGIi11miemwZhXKxSnUZ5s4yCHL/O41rKnOcESEaOSnEtn0ae7JUgxhMT41UxqI1CA9F/7r72rcDcde6pZrEJlTT2DdQQjYeRx3PWKzyc9BvNdGQVAJZU7fu/+QlsYmFsoS5A4wMDxxfQyPuIjbfeCFabqPc8alrusIlNsp1owPwy8MKF06oSp9hnBoa9aLqVNSoirdThXdbMkdTZNGjjopvc5/vfNfixESwalE9fC1ezTl1Ynyz//rZ/rb9QRZ1jeidTZacSVRJTKlwcaGwIDD2mIqDoqLcCYElIXxb5YREr+gKgEuocw4es/Flui
 4Nsr9+MU
 ZWeMhIX8YcZMtxGzaP4AOmJLFD5NtkO1qtbbqUUlurz4oZDQj1BXbyDLcUlE+jglx61X1d+0QfCAOqcpo1O3XPODrN0capMlSgX2/Y8+zOpLgbFKi501aoqZ0iZ5IN3HpYKpXrsCGpD5paeRTFhaeTD+j9Cv5fTIl7c1kTsCqMddto3nXjPRl9t3ikjj54tUWXaM8MnyUhsG+sJvARrKSNoiWwWpb/XjNzXRr2AQRnKQYRKjkOZqsW7DiHIRbvqL24bcDz/mQVkaHki3J/j2WupuBuN199NxhEfnV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 07:42:48AM -0700, Stanislav Kinsburskii wrote:

> > > Stanislav Kinsburskii (4):
> > >       fixup! mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support
> > >       fixup! drm/nouveau: use hmm_range_fault_unlocked_timeout() for SVM faults
> > >       fixup! accel/amdxdna: use hmm_range_fault_unlocked_timeout() for range population
> > >       fixup! drm/gpusvm: use hmm_range_fault_unlocked_timeout() for range faults
> > 
> > Why a fixup series instead of properly resending the full thing?
> > 
> 
> The goal was to get a Sashiko review, and v8 has already been applied to
> both `mm-new` and `linux-next`.

I think if you send the whole thing with a base-commit tag that
specifies a real base commit in linux-next sashiko should work

Jason

