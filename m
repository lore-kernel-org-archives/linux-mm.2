Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDAC1C79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 00:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68B456B008A; Wed,  9 Sep 2026 20:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63C086B0093; Wed,  9 Sep 2026 20:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 503286B0095; Wed,  9 Sep 2026 20:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1EA746B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 20:58:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F433403A8
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:58:32 +0000 (UTC)
X-FDA: 85196042064.21.0FA7FC0
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf27.hostedemail.com (Postfix) with ESMTP id E3BB440002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:58:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e2Q+I4jb;
	spf=pass (imf27.hostedemail.com: domain of 3tQCiagYKCJoM84HD6AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--seanjc.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3tQCiagYKCJoM84HD6AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789001910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xgzlS1uxnCbzGMH5pUkXS6DY1hZkFu32UCS9PdpFsuk=;
	b=nyhzNjqqoj0vPFoh0+R7vJRVJjeecO1X6m1wtA2Kju81cuxYYggB2LrAVbRBx1ClV6Z681
	PMtrJRbYCg/zWf7FzmqhshjS9m28BKqDDz0SLeHfgqYSfDOEZ3ZvhZ4zAffankau+t2C9C
	H8FbAQWbcGvprbOTjzv0NXR0OOE8W78=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e2Q+I4jb;
	spf=pass (imf27.hostedemail.com: domain of 3tQCiagYKCJoM84HD6AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--seanjc.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3tQCiagYKCJoM84HD6AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789001910;
	b=Wi5LFIvUsZTC0I6InHFRSWwRYRzVTngsktu0+REbRFE0fb53D6Zv9hv+P5t1EM+MdMMz2I
	1rTgmrC5icDtn5xtRCXYDA8uW7+v+2bqNRRWle57lmvaFml2GAaNSokht1JLUvYVRgtpld
	8rWZvCkjnpF0lCzbPCs+b3HgoniZ2m0=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2db3b126c9fso65366075ad.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 17:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789001910; x=1789606710; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xgzlS1uxnCbzGMH5pUkXS6DY1hZkFu32UCS9PdpFsuk=;
        b=e2Q+I4jbbuNj8DyRDIA/N3PkquCytreuYz9sdXvoEXab04uqVcJFoqB7r+8eYWbG+f
         XL8CeESVk1f/R2jO6CBKIb7FsR/O4Gx8iRx3zG30o8ic7xoldLTqks74xU8wVLt/cNWV
         FzwjnkekZCICfiT2jtQHnpFFEpJiq2nPAk1fs56q7ciyuDJe3MInbXW4tNNmZp/eK31W
         03aGyWuicWTKmnHEA88aXTTq4bpyTkpo5qxLheuGAhQeOR+W9/vNoSQlsW0thkI0pu9z
         Vh0q5PN7ig9jFxVZA4oGPdA6fEAJVilyRgdWriO+NzihUhUyIflh/eO8v64lc9WvMy3E
         x6og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789001910; x=1789606710;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xgzlS1uxnCbzGMH5pUkXS6DY1hZkFu32UCS9PdpFsuk=;
        b=Hr3iERqotEDtln0b3sqcFGh73Pgs9TsFrur1tUbIpG9DjMETr0dGd/iGA98PtvZ3Bn
         qS1jR3rcnbU0923xkE7Tad6wpyD1Ch9IXjRgUl2FYZZcdByk0GZcGbtVzWEXcHbSbACI
         HH0ibsHBElRCOdmsTClqBAIwKY42g0GHXqNLGmDn210EA9psuJqOq4xkGB/1Al/WVMJ9
         zpP8n655AZ2eYav16uuL7NKKHLFNq8JhDBV2ufs6q2fHKTvwSKdJnW0LumQDhqJLk97Z
         dWq7pOCThrpNot3a9bbcgWo2qisd0Rq/12ep2Y++b6+ZaWHhO15wFvFURDMuHgKNub6C
         wATA==
X-Forwarded-Encrypted: i=1; AKwUvByi24enlWA7/m9CN0f1jZKBHau6S0OaTZKrvRqKqLRavNaj4RUdQdFpxAM0VTzpR6jGDkuV+FSVVg==@kvack.org
X-Gm-Message-State: AFuF++m4SKxg2ArEUHBgYoeBRa5N3YCZPwJaf/Sbu+9sapmSW/d6Xfkl
	6Jm1IUSM1918uhm4rPAuJ+mUwpT5WfPNA2LgH+9Iq8j9I6p+4aENWBeQdjItyRekomyPRQbksqm
	bg3EwbA==
X-Received: from plsk18.prod.google.com ([2002:a17:902:ba92:b0:2d2:c22c:7b8a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cf10:b0:2d9:3636:d01a
 with SMTP id d9443c01a7336-2db126669d3mr557854145ad.15.1789001909390; Wed, 09
 Sep 2026 17:58:29 -0700 (PDT)
Date: Wed, 9 Sep 2026 17:58:28 -0700
In-Reply-To: <20260905012403.GX4157646@nvidia.com>
Mime-Version: 1.0
References: <20260903023452.721732-1-loganodell@google.com>
 <20260904160009.GV4157646@nvidia.com> <aptFFYqcSiBdMLE8@google.com> <20260905012403.GX4157646@nvidia.com>
Message-ID: <aqIAtOoew-_6jw29@google.com>
Subject: Re: [RFC PATCH 0/3] liveupdate: Move to feature flags for LUO and
 memfd ABI compatibility
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Matlack <dmatlack@google.com>, Logan Odell <loganodell@google.com>, arnd@arndb.de, 
	pasha.tatashin@soleen.com, rppt@kernel.org, pratyush@kernel.org, 
	graf@amazon.com, akpm@linux-foundation.org, pbonzini@redhat.com, 
	maz@kernel.org, oupton@kernel.org, bhelgaas@google.com, alex@shazbot.org, 
	kevin.tian@intel.com, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-pci@vger.kernel.org, iommu@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E3BB440002
X-Stat-Signature: zxhfydi5p9ihdjzzcpi7zc86kicnjut4
X-Rspam-User: 
X-HE-Tag: 1789001910-103845
X-HE-Meta: U2FsdGVkX1+1aMcR7RKHv7LFePnxon3c5tkuLYLwgB3y5SlEcrJxLplJcThcNn8efIYJEBtPg3Rh4LlzseAZbBKXQ7vXS5c0qzmxGvrIqcbeLEQH9PZD9UsCUdjdt0JEs59UPnnnKJBQsFVQeY5YvuCu/0JG6wRbaMNrc/bOLz2qpfE6vrotpNd/mvkUS91QSUMZFxqS+3rpHR4dE8VbqVDC4taY9ioml60KskDP90D6qEpiqQgf22d69qsypxx4EV7CTuXyRWWf/GxIUq3M1gtSR4pgeBChaqzk/7HtYKkh6Vf8gp3Ing5kGI1vLeMkPG4DJj1mn+a1XPC2Np42s6KvzO0/H+VaGn9W7LRPURX6LkdKC1irGVOAoclawcMLIommkZaNx5MHp0c7U6512upWEDoioCrDzn4Sa2s2pW5ZcZMmZTUUXOx64XEyjrGSPSIvc4EBLgav1ZAamqaEVXifJw2/H6NsDl1EgC8swyszh4/VTOgmGTcVfkUAJLwrqp5QrhGGDMqwzgvAQsSmIf2qIr/XoRGhKnADh/5MOt6Sn/j4MDvo6lw0q+3GyBi2bIo37n6agZASb5epM5vU+hoYA+Pehp5NqTebFUwJ4PjkWJmv2qXvO5nQX5K2/qJMtsPBTH9MptiKmtJUfAo6UJDn7L2RmyVuEoMkxgjnoryS5XqaaT3gsc32VSBepuxtQoOBJEw2YJ6FiwlP4cYoMqbU2caXfQNlhqauogR0QFc4rK2jSgH1o9BNtpH+f8x1fKOanluwvpYU331BYp3v16iMIfYWZPUwOffNgaIwfa6qLycyrSuB997MKDFiiL/MmyEAPoPvMaOnZuqwIhrhbPduGPPTvVkEwSZtAM4Mw0DCj2K7Ca4J/nU9uGP8/SxXQFa1OOwZU4sg8DavM+aUVQP8qY3azb9mkTRwtODzA1F97tzaBjAYDA6nup5sW0baDDAARC5i/TvyHSjD3Xj
 DWqooNr5
 e2EIKkAKOzdW0S5KvpLXlsXJq7mtjjfn51NF+1T0TOC/+Fs1sDdlHFuSCb96vzdwcnVAOXZHqXJMRRxl61t/Ac7ygEmcvVgxZEBd/UrrXWqCO2bsnLpa/6xz9zeixT4tRlxWPd2Cfp7oB/afI2cvbByruEON6QVUfwLPF+/Ogdgappi1ru3ys7DblIs6o1l8h/XnGazAIGOq3xTfsBy8eQW5AOypRqaSgfKt+R+vRnhCSq2cdOu65slEV9Ib2iLr7BIvuPPuaNFyeVv4N6oPYEziEccqUI7kLnnAEslmgtiKGo/tr1lBGEV0RBmq/33zgBeaiPf1u10iwrCkzX1RPoqWXH+kZR+4nDF/F6FVDIgG4yF217vtvgwXNyT5Pz4izrGcM3tODgP3UD+lJjh5LGFxK5e31C3lGeJhDCIA/QKvGX9BnB4zzj7AHn/PycDaWsOQyMlXYUAafyId/ia/iamIB2Y6nxi3oQbjSs8VzLdIzZIDFtGhxubaOLDh5RgjW6epBHq1pRDL0RuquGDeZcVie6IK99hWtcPyrOd/hG4BMTXFhpszdIPtrdcM5tzGSfLX8+CFZTKmoOZwrrTlT22ibPldYaZb+F1pG1XJVAqwflMxaim361+6e/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026, Jason Gunthorpe wrote:
> On Fri, Sep 04, 2026 at 10:24:21PM +0000, David Matlack wrote:
> 
> > The proposal here (which is inspired by the KVM UAPI) is to ensure every
> > LUO ABI struct has 2 properties:
> > 
> >  1. A field to encode options/features (e.g. u64 flags).
> >  2. A way way to grow without breaking backward compatibility (e.g. so
> >     we can add new fields).
> > 
> > Each flag can mean whatever it needs to. e.g. It can indicate the
> > precence of one or more fields (i.e. new fields in the struct), or it
> > can mean a field now has a different meaning (i.e. union in the struct).
> > 
> > This would enable adding support for new features without breaking
> > backward compatibility. Downstream users would have to ensure their
> > kernel does not start using a new feature while it can still rollback to
> > a version that does not support the new feature.
> 
> This was never the biggest problem. The main issue was the functional
> behaviors of the kernel that cannot be represented simply as data in a
> struct with some flag bits.
> 
> Like for instance kernel A supports memfd folio sizes far larger than
> kernel B because we fixed MAX_ORDER. You can't fix that just with
> simplistic flags.

Can you elaborate on why the folio sizes matter?  Honest question, because I don't
understand why the serialization format wouldn't express things as "N contiguous
pages starting at PFN X".  Then the implementation would rebuild its folios as
appropriate.

I could see things like HugeTLB not working if someone booted the kernel with
support for only 1GiB pages and then tried to feed it payload with sub-1GiB ranges.
But to me, those sorts of things fall into the "well yeah, don't do that" category.

