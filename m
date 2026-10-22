Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0BEB606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 17:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=EeJRvovc
Received: by kanga.kvack.org (Postfix)
	id C01C86B09AC; Thu, 22 Oct 2026 13:57:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB28C6B09AD; Thu, 22 Oct 2026 13:57:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0996B09AE; Thu, 22 Oct 2026 13:57:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 785836B09AC
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:57:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8990C0238
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:57:22 +0000 (UTC)
X-FDA: 85351019124.08.B6FA935
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id 17B16120008
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:57:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EeJRvovc;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792691841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8EgRcbuDfKORZQpY0utOTTMffHlpWo5to8q3utLizKM=;
	b=jW7bp9ASSo5DIMn8uh1XZc1+GNuAL3+/11I9bqSqWeO2nYaybSpEK8dJJ+yZt7jSMxP88m
	Pq8KSxanONFzx6H6GEEQxOwDCxr9i6PY1ZXb6jdiV0Q+IexvTyTQeKyJNUVW8drciG7Sdh
	a9RSQM4Zm0Kxl43WkzGaY56RJRmtvwY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EeJRvovc;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792691841;
	b=eLUSTs1OURD8dzIKYpwCI9HHA/AecINzRq6h/WGY6Mvf6tG0vH1OA8C7BKIKdbr2YaCUGM
	01rZTvopIbFQ/1jje+GJJUrGKd9TmDgo1OCFcF2ngAkc6nSl8SUZvzJ9w/GwfiwvT0U2Eq
	XZvkMnXnz3eJKUBhHW4gq9gLMV1VqmY=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc1d57602e8so45820a12.3
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792691840; x=1793296640; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8EgRcbuDfKORZQpY0utOTTMffHlpWo5to8q3utLizKM=;
        b=EeJRvovc5r/zh8xMVgDoqmmr0BrXAQah4hboan+wwpy5E3ru8OG63R3ShuK16tyNNT
         XWtWR1j3w8SEbtvEvuUs6Sioa+LXsltwhsCYsuFH+sYeYP6ByD7MqbXJn4HYPBjZXQFv
         gGsJ115hmrWlNb//bNIPgrSys2WZvEevsgSeBwbEjjB2lr0cZDCh7ABq3EgT6mccIgRs
         o2I6xpiEm6ltZK8gy1qTlAyU41xVjtOvvvv5vfjvmwDZMIn2OZ9rKFpVQUFxb5NWqL+t
         c4mvYmqae5l2e2AlsbeeqNdtv2qzqIUBeC2xcoltvIbZXSWTnIubb738N2rBd+sDySAM
         YC0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792691840; x=1793296640;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8EgRcbuDfKORZQpY0utOTTMffHlpWo5to8q3utLizKM=;
        b=CR0hR+x9m3FO4qEizdfRX01S7tcMLtyOlDdZkPaBJDCrrWcpzwGMNyFZmlzHNyYUq8
         ++BPJg2v3ZdXePakt/i6ly6lzio6SuG0Uj16riclU0+5o3XYuRDqgmWL8q5z8GmSfFRP
         z2DtvkkQubY7FgHLAa2SvaJ/MYrQ5mLL0dsaXKRZSHdOosRDVrn1tNTjyj7YnOf7M0g5
         Nldco+RKRX8ubWHaClhKoRuRyrludxTXPq2Eh7zjiBfbMzcXqGqcuMfCjboOPeROWxDN
         GmZTVOUo14liumjcrnuWJl1RGGaZehz7SMFEeAhheMIVaL0DRuV0CBi7p6kHpFEl0gyh
         N5QA==
X-Forwarded-Encrypted: i=1; AKwUvBxgMGQjBnCRudDFG+myNc0EKx3cL5mj/T6QcKAdC3GFpz8U4c6LWEr0zpazxAv60yICgD9m1Qdx9Q==@kvack.org
X-Gm-Message-State: AFq9FYL5429rrybq5ktS3m5gbn9b7weXBSVzs1/eZR7EKuGniyCLEfP5
	Kdo1AwHUntgQbmK7ZVVY8ZQqhhMorwLiwQPCniKkDzcCV5Q7dbiLImenF7tpedbkXA==
X-Gm-Gg: AYBFou1W3JAKD5JtizzipqD4Fsq5Znv2HVF4tiHqrn73EK1aP58CdbwfjH8Fby1bCZU
	toUc9VE8tWtmf5kv4RC2uuxxIs0qvtq0Ch6uHWgRIJfmcEOX7lUxqb6qaE5DVcg6EDx0sabmwCH
	uX7YuZ0q0+WP/PE60wlH47MXF3WizDKx8V9L+tsZIKv7DpoQJHwtglFx3hU82mLw/sEBuha3wMh
	kycZyC4uvTxh+J+lWg5hECk5BugvvinRWoikPeOtwJNPUlLpWo22YyUWXw5mStlGWM8INAm/N2R
	R4Lcky38cRWJoCvsSqgra26b7IeFXprrcTpfpNvnBaJUXEuOjnlxQTz2fAXjLsQRwrXizC1ez6n
	fZt0IU7kA5/Bbi3Pe8mXdpC2nS5eEosf3Y3rXXOBFEgM3RzGQ8oU7RyvY7EtPWEDNEtKuWTcYRT
	UYF/4ZD0gItyIjEVvgBA3fguG3wQno0VRyy0DqoRE8Y5LonA52mBhJx+i5kvZBR5hfADC3elQQc
	HOkfUFisD2IYmXSAsxl93eFfc5Ieg3IcdMn1FlqlBSgF9c1I9/evoOdxPFyk/8SgZnmTBRp45o9
	9o22dChEn8LfpdoWRqD1fQ==
X-Received: by 2002:a17:903:19ef:b0:2e9:61bf:6591 with SMTP id d9443c01a7336-2ea7c33be70mr1491705ad.45.1792691839016;
        Thu, 22 Oct 2026 10:57:19 -0700 (PDT)
Received: from google.com (192.150.203.35.bc.googleusercontent.com. [35.203.150.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea7b34dadbsm1687675ad.26.2026.10.22.10.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 10:57:18 -0700 (PDT)
Date: Thu, 22 Oct 2026 17:57:15 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Tarun Sahu <tarunsahu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de,
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com,
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org,
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com,
	will@kernel.org, Alexander Graf <graf@amazon.com>,
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, linux-pci@vger.kernel.org,
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/4] liveupdate: Select file handler by name in
 the preserve ioctl
Message-ID: <atpOe-blcgW-uDd4@google.com>
References: <20261021152527.375070-1-tarunsahu@google.com>
 <20261021152527.375070-3-tarunsahu@google.com>
 <CA+CK2bCnS8wcVDbOymBGeJB6pDUkknOpF22EynbwSV=D5=J4ow@mail.gmail.com>
 <atlEdhPjlyTPDWmG@google.com>
 <CA+CK2bAxgtx2gZ-UE2HqwAU8=h9K5RE3xozBs1njgLo1-CaPvA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bAxgtx2gZ-UE2HqwAU8=h9K5RE3xozBs1njgLo1-CaPvA@mail.gmail.com>
X-Rspamd-Queue-Id: 17B16120008
X-Stat-Signature: bjxo44kdt4gkey579egr48jr1dbhskke
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792691840-748556
X-HE-Meta: U2FsdGVkX1+7nYsfSRAo7b1GPJ5cmNcXrcsowAXir/N/hVCYbxVSjLr5MIhEp2hBgWAHWXiQhfUeE04miasPpzyx/jrwhSTKS9sQOkH5DpnDLEn9UND0ufKiQ0AnwXnHOf7PQ3P6londHVP6s1gX1TQl13whxEELVgQEdFbtYMCC2a8v8g0xFkNN47auzsnsHBzgUZxfy2lFzwAqLip3kr/7mVeITQOYwDv5whP690aA0vm+gcHW0etHY8ln0SNswwAxWsaHp+i6aBbTmJn/+1FXrE3guIVGr/RhUlr9mIn1/c4FGcTGKLFvxKEbc4q06titma27zqbzCKLNQXG0poLWoDyhBWYyJM/+RSfysdCe/1lj5UrlfSkHz4AiLAzWMQ4atxB5/i6bYHOAiTP7uxNQ2YkjLxfB2Pxln/xQSq4yMp8J0C6n9ARxNsFVfuQmklJiqiWNK0D9oEuaFZ+mnzJQaFS/VtmEZjWwyXNAYMWr8VnTHHPp+GmOBs8bnclnXjB/UoF60X5usSljG4vE53k4OUYsCEOVIWbXvCwuAysBt9M0LIyxoWk1wOlZq1frzv4DFOsotfiWdifw+MRrua7Ld8B2pE2DmwDTNpw3VQ/s0+x0JRIxEDU9Ayg6uI5oA5cugkj8MgjEF4rmCDkvbr9TUKQ9U2NJGf0nrtLCe1udg7bT+I5oYiKBrTMqdq/uJ9UB+cyU667KJV7zgMtuZfJQmQ9vzH7vrNLaOaqMcqV8atFwsoWxCmPfSjvlpV6ctAiOb16GUvU+b3VhiC95n3dvBX52S65DHzBpbkU/4Wh+cZTKoEabyuPATuKuq/HWkd2ojpLAgviYhlqlvGxEYU9FLfsTFr0IiwsEruwoMpp7fdOi1vbRdFHc/AITuXulx95J3HcwsLIFX8DjlFC7J/dkf6EbIFtRwS/nLegpWZLYnsaulUR68oQ7LgcpeGJGbHyU/+dM18l7UakFgfP
 qFU3n7VN
 Ge8Ef6kAt8PnS3CmnSd037y4mFpvYBsGJlZUsLssCInYYi9dq7DyNRvXSkS83+L+DOmn7+3jXJrpAwLHfIYeR2aV0SXeQO+HHpq7O3BSOiol19Kg1vE1wEjiyghYPA3wH8vdCVJnM6ZNQAS/ZBangWj5S+X4+vV2YeKWh6FifyrIUAZb22U2kINnhbKjAzQUQ7EGMYcLo32LUpDgF/dIQ2tdAyPgHaZS0d4Z0swLnbTmKRLSCNLDxY1SctuFb07uhbAa0ERE1ziDyOfAvotS+uRqwjn3KwH5wF0l4KFo/ZwUNMLrMiZVSeZwLA3BnfPxOyK43QAAbVHexNFTI6psI+uHjyOgUxHwsF9VCPL4bc+o4p173V6uKZ9kxbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-21 09:14 PM, Pasha Tatashin wrote:
> On Wed, Oct 21, 2026 at 7:02 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On 2026-10-21 01:17 PM, Pasha Tatashin wrote:
> > > On Wed, Oct 21, 2026 at 11:25 AM Tarun Sahu <tarunsahu@google.com> wrote:
> > > >
> > > > Currently luo_preserve_file() iterates over luo_file_handler_list and
> > > > picks the first registered handler whose .can_preserve() callback
> > > > returns true. When a subsystem introduces a new, backwards-incompatible
> > > > file handler alongside an existing one for the same file type, userspace
> > > > has no way to choose which handler preserves a file descriptor, nor can
> > > > the kernel keep the existing rollback-safe handler as the default while
> > > > allowing callers to opt into the new handler.
> > >
> > > That is not how it will work. If we are in the .can_preserve() call,
> > > it means the user has already decided which file handlers to use. We
> > > need to do that before any preservation happens; otherwise, we could
> > > run into conflicts on FLBs i.e. FH of different version require
> > > different FLBs.
> > >
> > > Therefore, there should be a luoctl call (i.e via a new ioctl to set
> > > compatability) that provides the kernel with the specs file of the
> > > target kernel we are updating to, allowing the kernel to select the
> > > compatible file handlers. Since .can_preserve() is called when the
> > > user is already preserving files, the specification must have already
> > > been supplied, or the kernel should fall back to using the default
> > > (i.e., latest) file handlers.
> >
> > I don't think that is the right direction. IMO the kernel should not be
> > choosing which file handler to use, userspace should be. If userspace
> > gets it wrong and chooses a file handler the next kernel does not
> > support, that's on them.
> >
> > The problem with the kernel making a decision about file handlers is
> > then userspace does not know what arguments to pass in. We are adding
> > custom per-file handler arguments to PRESERVE_FD and RETRIEVE_FD. If the
> > kernel is picking which file handler to use, say for a memfd, then
> > userspace doesn't know which arguments to pass in.
> 
> It is not the kernel deciding on its own which handler to use; it is
> the system admin (or host orchestrator) that configures LUO before the
> LU process starts, because the sysadmin knows what kernel we are
> rebooting into and the LUO specs of that target kernel. Meanwhile, the
> process calling PRESERVE_FD (e.g., a VMM) only knows about its own FDs
> and should not have to track target kernel serialization versions.
> 
> Also, the PRESERVE_FD and RETRIEVE_FD arguments are uABI tied to the
> FD type, not to a specific internal handler version. They are stable,
> and we can expand them the same way any ioctl argument is expanded
> (via size and flags), without ever shrinking or breaking them. We
> should not play the game of providing completely different uABI
> argument structs for different versions of a file handler. If a caller
> passes a new feature in the uABI args that the currently configured
> file handler version does not support, PRESERVE_FD simply returns
> -EOPNOTSUPP, just like any other extensible ioctl.

If we require that PRESERVE_FD and RETRIEVE_FD uAPI is stable across
different file handlers for the same file type, then my concern is
resolved.

> More generally, we are rebooting the host into a single target kernel,
> so compatibility is a session-level property, not a per-FD property.
> If we need an upfront global ioctl anyway, configuring the target
> compatibility upfront in one place is much cleaner than exposing FLBs
> to userspace and splitting version selection between a global ioctl
> and per-FD PRESERVE_FD calls.

That's a good point. Ok let's not do per-FD FH selection.

