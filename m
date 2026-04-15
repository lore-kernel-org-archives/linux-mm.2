Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC0D6FA0C46
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 08:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F53F6B0092; Wed, 15 Apr 2026 04:28:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CC756B0093; Wed, 15 Apr 2026 04:28:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E23D6B0095; Wed, 15 Apr 2026 04:28:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6A96B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:28:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1AAAC1A8A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:28:08 +0000 (UTC)
X-FDA: 84660112656.21.BD24772
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id C5042C0006
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:28:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ca8IOlnC;
	spf=pass (imf28.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776241686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0MPHkT8FkNcBtLY+Pw7K92GBLHfnQFXFDeYyX4HYwxI=;
	b=VTb4PpfrJKsUPqwN8aiAHHa6zW4cksIJx3GRLhY9mIZvgW757CkKGlmV1wPN/V14vllDrr
	G2s1BRVjrBohFD+/x8eCaHggcYVWHDefVydrpT4tKQR2iwd+85Gcq5y+SaTlRFLCIDhpsV
	g5VuOdANjImSm5qKY0j6xwSqZ1bEiSU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ca8IOlnC;
	spf=pass (imf28.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776241686; a=rsa-sha256;
	cv=none;
	b=kQ4qp0ItkgvTuS4c5/U+0Khp36gVP8ovohlf+mTaNdWcrrZwBDnQj/Yv50gS4CkNLD4Ll8
	i7usBnHVzuS1GoRhHvunx7nnGDE59YNw+UM3ylXsVH4hw+dRhdduG4hAiXUdABh3XA0DQq
	NfG65AdpbP5ZRr4k3D3joMkTz87wRmM=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43cfd1f9fd1so4157456f8f.3
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776241685; x=1776846485; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0MPHkT8FkNcBtLY+Pw7K92GBLHfnQFXFDeYyX4HYwxI=;
        b=Ca8IOlnCXA/bxWOmAt53A06WM+LIEAw0jEulZ2ST/Urlv/V3Z7qhu5NTIDMG83ntYZ
         f5xK8tAnbEl+k5TPKqIZvD1K5bewmBViKIbf9Zmc0+SlPH/6r/JjtnCGA5GtTqOEiP4f
         oWS9wPumzaLbFpbMCb8qI+TV0rpDgFaXCegCi4V1zUsduNNBTdBVnXdpcs8h6Ykoti6Q
         71qL+K/T1nS5Vfcil8i0+Nq8LMentHogbOilLr2CB9L4uq+GamW1jQGdCKEqNIzzwWH2
         2GpUtpLwVy+3F2FEyT/vQvxHKVo0WqWDeVjB6o/t8V7COdJHTuPlrMgbWlHDFKL/v07g
         97Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776241685; x=1776846485;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0MPHkT8FkNcBtLY+Pw7K92GBLHfnQFXFDeYyX4HYwxI=;
        b=KiBUtB1Ce92o5JqLFXMYLjXdPvrwcAhmQwIfX9I66L7NyidqAeCLPJ6jKrXKR/codt
         s+w6y/lXDBL2UjNs9kagpyTwL6eKToU0nqWt6cO5DeD83yfkYug16rSW9BRVVLEbopAU
         QRF/VPHKBugOYyVwa+QAiPcitr0mJYjOpiuzARHmDumbQGKpzdxlZal3jxyJlNbc4IsP
         me6IG7qo0jffi5LKldeeeb1uYQDm/nK2GC2J06USg9ol7QKScrPJWa0vp3Vjqd5aaKa5
         I0IySZvozchl5WBKuNwTLcjhhskQN0oj2moeuB3glGgolRGtS9BG+XExvwUPJwAV1acN
         SOzg==
X-Forwarded-Encrypted: i=1; AFNElJ/X9NIlcCA5ZfgekPaC3fsJAdQwQXAy+f1X3nmrB3toqJARiyBGnDV3YxVi8rc+BGCB8x/REzcH9g==@kvack.org
X-Gm-Message-State: AOJu0YwuXqmm1iS8QPynRo1gI54XvKrySjHjUmCYdNNIzz4mafE1HMxn
	FhjTjhE9vA4e9D8p8Rf6fZR/aYnI7ecB4GVsRimZTWzRzHG0r9mmSexy
X-Gm-Gg: AeBDietLlth6ixjZq0XBfwc/QUOqaG4+jAFmBU3MK5mlEAGjc6Gt4W+u2F5yAg6rEN+
	BLt3Mi6hxiPKij6oh6MkYj0vhhMcEi9dIoVv2YP4O1Z1/ORgU3ewo7ceKE7OGRgsPk1aXoVTT3N
	WwZrTTVrgcR9pA9F5Ja0rgEbZIoQ+eIxXm13zrO16DTuptI0tva1oO6YELuc3GkOISLzHJ/DW4g
	MMpSdtGzVfHGlGGyh/VGUDyu8EiTORT+QLzvpYjNPbK4bw7sr3ZF3NIZhaPP3wp9rBShqIcaq1e
	lVYXRIAB8G6qi6vpWrnvSGJo9OEPS2u5igAHXhAJPR9LNEo9lrIBi5DFwTiF/mJt+XuBkYSG948
	526gmbQoHUKRwF+uxO6OXM0V/qu34EnYwe9zafQurqlV48Byka/Xp023AXORIGzjnQaiuRPVuhY
	WIhHJRuj6yEQECLumlIvt1eFxOXeSFSf2RzuQXlg8OKra3NCQJ8/MLHZm5vSv5uNbE
X-Received: by 2002:a05:6000:268a:b0:43d:7403:4b60 with SMTP id ffacd0b85a97d-43d74034c72mr20655235f8f.3.1776241684906;
        Wed, 15 Apr 2026 01:28:04 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead3564d8sm3573210f8f.10.2026.04.15.01.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 01:28:04 -0700 (PDT)
Date: Wed, 15 Apr 2026 09:28:02 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Dave Chinner <dgc@kernel.org>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, Christoph Hellwig <hch@lst.de>,
 Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>, "Matthew
 Wilcox (Oracle)" <willy@infradead.org>, Christian Brauner
 <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Carlos
 Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Jan Kara
 <jack@suse.cz>, Bart Van Assche <bvanassche@acm.org>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, Sandeep Dhavale <dhavale@google.com>
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
Message-ID: <20260415092802.5864c457@pumpkin>
In-Reply-To: <ad2RKNo2FGhpzJQp@dread>
References: <20260409160243.1008358-1-hch@lst.de>
	<20260409160243.1008358-9-hch@lst.de>
	<adl1iqhldFvJwSw-@dread>
	<7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com>
	<ad2RKNo2FGhpzJQp@dread>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ukqi1nydmyuxhdzpju5ap4fwhixgd7nz
X-Rspamd-Queue-Id: C5042C0006
X-Rspamd-Server: rspam09
X-HE-Tag: 1776241686-47565
X-HE-Meta: U2FsdGVkX1/nw6X64lw7vAni+nUOwIyQUyirNw+Oha6etCrQlvKxGFn+B3ZDgkp9c1OH3i+6xBPa9xQwjw0ZejKfzmkDBpC8gT0ysc1M1hRHXivdH3S2vcHUYs1T/3joSmP4XN/SSCiRCpB/svv63yYshBo779BQsD5H0xasYx+Y4X++M38D0TzypKcRfDO0GMs+w6WDaBdMFJdmpKIkSVo8NTF4HzZJyT16s4vyttBgey1mQQEsjxtO2MbcClTpVEGVCtU/+0B5LOMD0sQ+AbRqYhsn3iTyz8p+6y+S9w5vyfr/dnNVB/c7m0IL7opb6io0uNBfQ/oBXJ63zTxaGRmrtnsIFywAoIBjzH0FcdU2zjcbigKu1CwFjaQF11XgDc3ybxWRJUtV7erLVpqfO38iz5s7IyV/h5s0oY6JT9/9FLvkezDsKLMnOp39Omx83bVI648TuD/FKzp8Ew9OOr4e/FBiwaKcrsSujICNspZcqm2fX2v8azePjS+hjKeIk8ZVZhkcMl/gsnd1BaTzCYaoNVCM7mSBlRHyRQDYoKQ2FkC4SnS5IYdTtisQQyq6oKfys77Atsm7M9gda9Db9yPPdeZ0Gvo4fU0RSJUHJVTrtuYG3dFC6rQnKFVmTwgvVdvJZbGMCUow4q3jQr3gmXaLqgbk7dDPCmgQN1Z1VSLi6hmqcx+sIcFUBRAMv4dv0Ia07mpvUGVZbc37wVb1Pp2Nr7pjQXQszCKcuZ5Uj3KReiVjQUq34qNGJR4WSnpsWiS/+9DfrLzDBCdTtXa0yN2Yr9ZWrHQAiBtdkAPGy7u35CyD9OmQREt8DZoHPP4NZCTnb50cTlsIx4cKHWPWEk0BnVbZAeaXOE0ETQl/0saHzhPWWRhsnDS+Myu1GYRgxYnTuQyRWf688IVtw9zanb6bPZ/Otk+3lH5MNnsQrQCJAg35TI2xG6TZMVFoBQPqJmP7XVPQuX3g1h/DrHQ
 ypzZp1jS
 aT1I49jTa4VXmyyrvraMJYTteCmNIrOOyDVD3B3UcwXrPbNQguZ2tnM+F2USymPBkzuVlucwi5QogYBWDcPacjU+rPtbVAaLSpSfN56r1SBWVUl0Mayvpb6kQJtrlr825rCXDKahMXzx6xwa5GpckOv8wd+IJerQYIwEW6+Rb8CsWsMx0UqYtcVvEJDzoHmVXDqv4mAKf28n7b6LZHwz1FdPYCJT0xY5hjVRYh5G96Ayb4n5SQ2mUmj3berXgqc8jsamh2UPUodqA9L8CBIRRlWANIMCy29E/WOrWALyQmS1NIFmhUgO+1L0ZYEVR1grkN4/iWIqmNIMhcT4AQrKI+w0RUzc6MByxrRqrQ5nugJrGDnfFx2R/kfXyGH8RuV4p2nNmyAR8sttAe8nFTyM33S25r91d2P4u5Fw9hMqM4og524RFDPXvEtOsaiG8/Jl3s2AZgCAiHk6rCBgslZYEpy0fKMFUeDY8MMQ/OCnG7UDDE3CNE/RxhtFKc8dS/REHsBTaYqw1cXYWtvA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Apr 2026 10:58:16 +1000
Dave Chinner <dgc@kernel.org> wrote:

> On Sat, Apr 11, 2026 at 07:44:43AM +0800, Gao Xiang wrote:
> > 
> > 
> > On 2026/4/11 06:11, Dave Chinner wrote:  
> > > On Thu, Apr 09, 2026 at 06:02:21PM +0200, Christoph Hellwig wrote:  
> > > > Commit 3fffb589b9a6 ("erofs: add per-cpu threads for decompression as an
> > > > option") explains why workqueue aren't great for low-latency completion
> > > > handling.  Switch to a per-cpu kthread to handle it instead.  This code
> > > > is based on the erofs code in the above commit, but further simplified
> > > > by directly using a kthread instead of a kthread_work.
> > > > 
> > > > Signed-off-by: Christoph Hellwig <hch@lst.de>  
> > > 
> > > Can we please not go back to the (bad) old days of individual
> > > subsystems needing their own set of per-cpu kernel tasks just
> > > sitting around idle most of of the time?  The whole point of the
> > > workqueue infrastructure was to get rid of this widely repeated
> > > anti-pattern.
> > > 
> > > If there's a latency problem with workqueue scheduling, then we
> > > should be fixing that problem rather than working around it in every
> > > subsystem that thinkgs it has a workqueue scheduling latency
> > > issue...  
> > 
> > It has been "fixed" but never actually get fixed:
> > https://lore.kernel.org/r/CAB=BE-QaNBn1cVK6c7LM2cLpH_Ck_9SYw-YDYEnNrtwfoyu81Q@mail.gmail.com
> > 
> > and workqueues don't have any plan to introduce RT threads;  
> 
> They don't need to (or should) introduce RT threads. Per-cpu kernel
> threads already get priority over normal user tasks on scheduling
> decisions.  However, they do not pre-empt running kernel tasks of
> the same priority.
> 
> In general, kernel threads should not use RT scheduling at all - if
> the kernel uses RT prioprity tasks then that can interfere with user
> scheduled RT tasks. This is especially true in this case where a
> non-RT tasks issue the IO, and the IO completion is then scheduled
> with RT priority. IOWs, any unprivileged user can now impact the
> processing time available to, and the response latency of, other
> RT scheduled tasks the system is running.

But might not an IO for a use RT task be sat behind it in the
completion queue?
To avoid priority inversion you need to process the completions.
The non-RT task won't be rescheduled to issue a later request.
The only other way is to force that completion work be done in
the context of the thread that issued the request.

> 
> Tejun asked Sandeep if setting the workqueue thread priority to
> -19 through sysfs (i.e. making them higher priority than normal
> kernel threads) had the same effect on latency as using a dedicated
> per-cpu RT task thread. THere was no followup.
> 
> In theory, this should provide the same benefit, because what RT
> scheduling is doing is pre-empting any user and kernel task that was
> running when the interrupt was delivered to execute the completion
> task immediately.
> 
> Setting the workqueue to use kernel threads of a higher scheduler
> prioirty should do the same thing, without the need to use dedicated
> per-cpu RT threads.

We had a related issue with the network stack's use of softint and
threaded napi when trying to receive very high packet rate UDP traffic.
(IIRC something like 500000 200byte RTP audio packets every second.)
There is an absolute requirement to run the ethernet rx processing
in order to avoid dropping packets.
Now normally the code runs as 'softint' making it higher priority
that any user process, but under load it switches to using 'normal
priority' kernel threads which are basically low priority.
Similarly 'threaded napi' uses 'normal priority' threads.
The only we made it work was to manually change the threads to be
a low 'RT FIFO' priority so they got scheduled in preference to
all user processes.
A system may need some user RT threads with a lower priority than
these kernel threads and others with a higher priority.
So defaulting to a middling RT priority may be best.

	David


