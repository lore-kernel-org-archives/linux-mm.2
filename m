Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAA9AD38FF9
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:36:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A0AA6B0089; Wed, 14 Jan 2026 12:36:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4819C6B008A; Wed, 14 Jan 2026 12:36:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 380F56B0092; Wed, 14 Jan 2026 12:36:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 27E696B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:36:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1350C2226
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:36:37 +0000 (UTC)
X-FDA: 84331274034.07.2FB5602
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1655A12000D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:36:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=T4eteCYy;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768412196; a=rsa-sha256;
	cv=none;
	b=6UuiHjt4sK8y2WxddVW/d/xX1mKZMUW/TYa+9I/5GNzbSTlK5afq68MODx3oKXE0ziN0Iz
	If9YIZk5pxn3FCEDNVr9tYU9HqELb42U7DEFL/Z5logT1jv0xCcj5iPe6c+FPgcD2f/k3e
	jDJ72zTs7XKXtfRwSPig2thyof40Z7w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=T4eteCYy;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768412196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=figB8dzHwd2D0XvRaWeBpTz4+U95P61NoReY1arrqU0=;
	b=cx1fASej2GWfly/dhM0snaSZzwo+NDkfFtiQaZ5JM6rZTk4WqLGX1ee6xgV62kMX44zlYe
	bSo4ezeqlrG4Hyt2ifxiPPzTHcYZWngfKFKpMTq0hTAT0F+uBjhlew3eOjPXW93++AJ3+G
	sVRKUmo8qoe7zX29W6foWyfqmCjcEjg=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8b2ec756de0so6313385a.3
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768412195; x=1769016995; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=figB8dzHwd2D0XvRaWeBpTz4+U95P61NoReY1arrqU0=;
        b=T4eteCYyvvNXxbuf90RVbR3LzdfDr90NXBiou1/Qv8kmYOmSfVkF7QZIlf1dRl2KNB
         sKFK7ms1jQ2j743SnM+BhBghVB2sbnVBuJiNTjZxBbHZGB5HK6ieLvSUVfDobUyBDI8h
         h6OF8Mgn1goJTho3GAvWjIEm2jDEL3oVbFBQRVj2OdaKBUWFHP9EPj4Nhq4kaAjLmstU
         pA4Yf5985Gw7sWQFot8x4ZUATvijda4A/krr/6Jpik5E2VJgEJ/JtrDafxTCNUWje1Zb
         IfPN5NZmwNuzh0GsX82WqkLahueExKpzYmFDXXYno6Ha6XPn7g8nCF+qpODNihJaw49h
         oqEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768412195; x=1769016995;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=figB8dzHwd2D0XvRaWeBpTz4+U95P61NoReY1arrqU0=;
        b=B+g/NiK2WpLmGkQ2mragqyMUGg4RHm32zWEVdf4+tgnKzTn5Kg2IvRyvHvauYhJnc3
         73Mua8TF0LdsKzNxUjInpyT9IS5zzSkuzv8Tz8M9n8mzLyABeeB01fDhEY5wsG70/GkA
         MQj5N+g7QWQ2jvz5OXSl7/SKpmjb0mUDNoA6KzLKdVekstiMP0nGX7sCqowakRkAQXd5
         XKCFJhbeVFibbnfe6k27ZcQxP5JygP/lz5E69RNawlxzf6dFGf/u69wHI7vyz7GCozVn
         VEYCv3j8UZiebm8vznW1P2QPi8/4FVSad0OmsFJBRAVNax22QpQgIRuJmHuYuT1LyyRI
         wn8w==
X-Gm-Message-State: AOJu0Ywh5kSgl0ruI3OAA5ysM5jyDzk63JPpSUs90n8rzWWb+sMzNPxy
	sodGgVVqXn0arAKDnvseBBjelfav1ZNJi7HFoopZ3n06aYdU6pqg2UyQ1CfRlp4Jnlf1/o2CwF6
	2d1PtFGM=
X-Gm-Gg: AY/fxX7QjB7fZ905Z5LiQnpiv58a/MBl+l3lJu8issrrFBeW2Glg9BZL2zxBWk4oJHD
	iXCBOSWSbb3D1NFBHsQxSHBqUoBpSWrri//AqfIkML+quuOY/ejVxsUQlGEMvPozBw3NXKdTKNs
	Nz8Q50ZP15b/FHTDd2yUS5lVlbIg/CQDEjEhFHbP09jPYXbO69DsAYo4FS/c8v+tschY23n5+nk
	KnF/J2O7zUDPT3MZnTkmpOMXRrwOEP+s4/g3hbwMJNx4I8OlaO7x1k3T7jKWmL4FpWFlQN1u8zL
	uGBXJwdCwPNpMAc0JRGV9yysiOA6reWDLQkwG1FliCUIVVgCrXvymSyG1SYKvdtQx+4ztS0wtSV
	C2gAjIX7FUv3M6XfUlSZBxCmazPTZMnfAcD/xde5S2j52RgqOYETj2c3oJFvf49Og8seMGXqMmI
	6KMlckZh5qpEZtKNxY6qFWdR0WTO5ueaKCCpiHzxRk6XYKeeYcgWiFZkPWRjpO1PGTxewViA==
X-Received: by 2002:a05:620a:4502:b0:8b9:7a1a:8c73 with SMTP id af79cd13be357-8c52fb90a04mr537400485a.46.1768412195222;
        Wed, 14 Jan 2026 09:36:35 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c530a6bdbdsm200764785a.10.2026.01.14.09.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 09:36:34 -0800 (PST)
Date: Wed, 14 Jan 2026 12:36:02 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kernel-team@meta.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com,
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, osalvador@suse.de, akpm@linux-foundation.org,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 8/8] dax/kmem: add memory notifier to block external
 state changes
Message-ID: <aWfUAiag6khaLJpq@gourry-fedora-PF4VCD3F>
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-9-gourry@gourry.net>
 <d1938a63-839b-44a5-a68f-34ad290fef21@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1938a63-839b-44a5-a68f-34ad290fef21@kernel.org>
X-Rspam-User: 
X-Stat-Signature: yk4ph1on6d61jya6kruq1wbzitq3558n
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1655A12000D
X-HE-Tag: 1768412195-559834
X-HE-Meta: U2FsdGVkX1/FI+Rgi83cqmeJ1gSJLc2FPyOxAtlGrxtmN+qYpu7YxZF8sYJLiAc2xNN3hssYG2TmCa8Y8K4bvJUlyTGU5ErSrijPVU7nMn4QGiOyOt+w0UrcRe7nu3NA+893xS2ipMTd6xbv8ZGWbUsd1pbA39rCs6W0SnQsyop+dqZQje26PNaS13X//hSLJjWz20QibFOuDAp5TzNjCoagwyt43WtFXEYP/EkTfSBcVFF0PWyUeis2jXoY1KRKMWoyKO/9XVuZQ2AoE4yCUVNvuiGG0oWG5XOl2VXi2qtW7uvBrPHIekIA0ExLJ/+zKMGx+evF/1uS1538p/kJ7TyMVyd6dZiiyd+FzWAcrYwdtUDPOXEd9xbRrxjAPR9bqsbAggj9JVqm7iVmSj6x39+Ani4d2AmgkXlIjrCWNyfzunk8JFKI+2KdZlklRaaUI3SVBVCIw1jP7h+GIWLUbo0YohN4flq12gYukUKNLt7PvjL6yzmwjrM194rd54Zw3QNtJJ5UQY+tWLei/vCaexKtnfsZrtTuhNA+MH7XrzyrxkBY5vkTQBnwrobTCNfY0Y8DhbwB8yAYolfAesyMKrit2Cs+OnJE3iGYLY2MzczhQ3Jp1SFD/8xLahpBeqUwRwecXt6RtPbWWoqEkvnNkSGgvwAQ3JR4xiFsiE3J9HrA8AE0jiG/PiX5nr2LPYnl+Adf9VRjRth59f1ZDDFyQHTwQ+ZEGWfFp6Vjbp/wIxA6LC4v7kzOJex+8EZLXyvwBabLsebPGJL8JzaPlikabT8VL2IqCesiriefGmNGLicYpXrtL7qSQ8LEO7009uXdwk9i29hhQmAQjsQMkYI2HbJkWDtXOEV2n3yJGPjwl/aHE2CAGA4UV2ReYKzdtwO0IK+a2JOQCXlKizfsV/nRwZf7uLHMSSHJewJuljXZeOKfUAW4sMg676wqfsfBM06ZoH15dt6JrTaEcFB9v/y
 sAS9eHz3
 RFk7tEepwU58Oau5rlalgPbz27bjrYdEOEd8rN2z8PGksuoQSq1m4fIRR5y3cGM7BjClJ95ap8ucDix0VYv6iJNf5I68ZrPAIrbIIuD6lB1HQ0L2iZBmSUDwzmILfDJAkOcYikDt4QkrA7B2ufgnknxSOySeLYQ/6XTb1tHN5Utc7QT7SsJ0hO3nhppToOt7dq4N/M714ulP1yKeN4pAQU7thLumG3xmKNMC2XyALMZLoHV/6eSgnm5KeI3CsmWu13qcLmr4luEp+t+XGI/TBDMnQArxqAn059OetqLyZlvZDaFkjuOmrEDERfupmD4RNFpr/sw0KlywFMdc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 10:44:08AM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/14/26 09:52, Gregory Price wrote:
> > Add a memory notifier to prevent external operations from changing the
> > online/offline state of memory blocks managed by dax_kmem. This ensures
> > state changes only occur through the driver's hotplug sysfs interface,
> > providing consistent state tracking and preventing races with auto-online
> > policies or direct memory block sysfs manipulation.
> > 
> > The notifier uses a transition protocol with memory barriers:
> >    - Before initiating a state change, set target_state then in_transition
> >    - Use a barrier to ensure target_state is visible before in_transition
> >    - The notifier checks in_transition, then uses barrier before reading
> >      target_state to ensure proper ordering on weakly-ordered architectures
> > 
> > The notifier callback:
> >    - Returns NOTIFY_DONE for non-overlapping memory (not our concern)
> >    - Returns NOTIFY_BAD if in_transition is false (block external ops)
> >    - Validates the memory event matches target_state (MEM_GOING_ONLINE
> >      for online operations, MEM_GOING_OFFLINE for offline/unplug)
> >    - Returns NOTIFY_OK only for driver-initiated operations with matching
> >      target_state
> > 
> > This prevents scenarios where:
> >    - Auto-online policies re-online memory the driver is trying to offline
> 
> Is this still a problem when using offline_and_remove_memory() ?
> 

I just remembered another reason I did this:  

echo offline > memoryN/state

This leaves the dax/hotplug state in an inconsistent state.

if you do the above for every block in a dax region, `daxN.M/hotplug`
still shows up as online.

This just hard-locks the state to consistent (unless an online/offline
fails along with its rollback).

The additional complexity seemed warranted for that, but if you're happy
to leave users to their footguns I'm not going to argue it.

---

I just realized this breaks the current ndctl pattern and would force
ndctl to convert to `hotplug` since memory block onlining will fail.

~Gregory

