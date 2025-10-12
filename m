Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80117CCD187
	for <linux-mm@archiver.kernel.org>; Sun, 12 Oct 2025 23:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3310F8E0005; Sun, 12 Oct 2025 19:57:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E1D68E0002; Sun, 12 Oct 2025 19:57:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CF6B8E0005; Sun, 12 Oct 2025 19:57:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 071098E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 19:57:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71AA7C01FD
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 23:57:44 +0000 (UTC)
X-FDA: 83991127248.04.F953262
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	by imf19.hostedemail.com (Postfix) with ESMTP id B7D171A000E
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 23:57:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=y54K1WIi;
	spf=pass (imf19.hostedemail.com: domain of rientjes@google.com designates 209.85.214.194 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760313462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5nQm7KXYGnqdcO+aK8U+JklMZ1nJvHqyddKFebpClpY=;
	b=gtaqdl/XxtOh5TKjcnw5JNGpb9KA7GAUS+yZ1EqJuheSxZdCbngn6rhPK+GMXA29tpS0YK
	0DQkHrFlPRP5OoQ7qmsSCYPtvf/1FtO2IzbPwRTIURCwRTsCAtBwYGwUVlqnAlU0W21E1b
	4TxDcn4Shhgn7anaxopMJDMZx3DRT/g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=y54K1WIi;
	spf=pass (imf19.hostedemail.com: domain of rientjes@google.com designates 209.85.214.194 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760313462; a=rsa-sha256;
	cv=none;
	b=O9bArI6QdrIdkmv7vyY6NL+cOV1Y22D3dS7I0CzLUQN7qg+SlJIBwUCXFumeZ4xAVKSLU3
	NHpxB+zD6lyybjaZVpBX8o07ZkQWacf6LDDmunYMj471s3qiYI8vSVcZjORlOyrQXCyFTK
	2ArMj99pmECcODV7nCHViAFGEf6lIsA=
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2731ff54949so230245ad.1
        for <linux-mm@kvack.org>; Sun, 12 Oct 2025 16:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760313461; x=1760918261; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5nQm7KXYGnqdcO+aK8U+JklMZ1nJvHqyddKFebpClpY=;
        b=y54K1WIi1oR0C5QGEm9En4xoyOVJhRSTkUYVTEjaEZosCRuV2zR4w+scQdvNrLFtYM
         wHlbPzNmmHJwRMa5PcCKzCjJ+zG78Qioit119FGahSJ17irT1wCI/cIFGdLcEfc4tZlg
         aiJQjOIq0rgwhS4mc3JrtCr2laW6fl1t7+443aeVDpHRX042Em4Nbdhu2jbRQhcnF1Gw
         SVZ9QvB8xnR0SwQSq16TO5FX2CmhUO1XaeEVuEIfp0zbpWA4xZAc3sCXpoZ3ExqgZENC
         3ZQ+iBI74KeetMdh7I2hZ+qzGnFoC3nrmwHZDxn86lIzzfkFTq4ErL3EYrQgr6WFa6KX
         81Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760313461; x=1760918261;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5nQm7KXYGnqdcO+aK8U+JklMZ1nJvHqyddKFebpClpY=;
        b=VDYLuWpi1sqEbfH2VlC4xfH28VZTddE/HdQFOj0k8TNjYlHFS76L7nBY8na8DcAPZs
         8b115cP7uG3rpTbeBhCfsK4Paw2a5YrR5GzR88kdVRWPUMJ4oap9RoxYLbXEYpC6Q6nO
         Isba1jm47mrBrzDVvMGNRFyEkD16g90i/roFFMbwj632pTa0CfAbeAxfUZ62TV32Q4dG
         f+Pbktw02gIAYfuJoShci7Dwp8UPUdtf5sK5xesKaFivI4FUTR/BWBUUivanaKGqYgCL
         sNYOY2lmfYyEJH249WX49KyRCMi0LxnIlAq968f5OMJb9GHnpGgt+No8PXxxFwUiwK7e
         PU4A==
X-Gm-Message-State: AOJu0YyrD3jCP7XHjMQAMhIqHFRbycb/Qs9toAGc777BieGmwaLIwt6t
	W9DdD1BIF5Ohs03Q58AYAq8kIhhsRfGmlXJBk9dAUIFi9yNA9JLAATNFYQo0uiJdyA==
X-Gm-Gg: ASbGnctWMHHKiFK//uwv+XA9jOX7q6AgiQtEmgTRV+7zx5V3Ai6TSpC4IfmNN9JGLAp
	wcJpm953MegUB2qA6BSKJjgFHrX8mTwpbNaDdYtkWObKtlhbb1EyaVR59XQwTbOF2osqKugUiJz
	LaBf2V/9RZ6nFCvvnXWLxU//JTAjQ/s29D0C4rLlizgYf78B8KMG0d1rDhmEFDW4vMVNfBUgpGl
	TQGYA11iwVXDGt2jA7sz+yR9jbTt0NXRitSaHfvG+mMI3rfU0K/0lIOP/eqcsWBEfX1tBr41IJ7
	fYlKqkZQEOLv/1vvseLZyUyrSoTDi+5ts5fkGcV6i5xKCxJd3xpBiDfkhTTTLHyn3gfSfP+HazO
	NzAr9fcwqNFpvitjZXMfJwk4PV+gjpDOBR+sKO1vpdAALPK2+jOwQaYrv6ODnMPL8I87/GLYztj
	i4LxrX6xtm+PfrVgAZW9nrP6mH+FmHwAraZyJehXhVMCdnYGuZhVFkkjBPQ3cYYSByHPk7TUM=
X-Google-Smtp-Source: AGHT+IHGA0sKciQs/c5E995rDfiiuhjgfyqwD521DvX0pdBh3UAfB9mcbBQJXpIhM5ZQaBO+Zeo+6Q==
X-Received: by 2002:a17:903:2b0f:b0:266:b8a2:f5d8 with SMTP id d9443c01a7336-290276bc052mr22752615ad.14.1760313460815;
        Sun, 12 Oct 2025 16:57:40 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:d38e:e48:4bd1:f89d] ([2a00:79e0:2eb0:8:d38e:e48:4bd1:f89d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b61b12756sm10057775a91.25.2025.10.12.16.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Oct 2025 16:57:40 -0700 (PDT)
Date: Sun, 12 Oct 2025 16:57:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Alexander Graf <graf@amazon.com>, 
    Anthony Yznaga <anthony.yznaga@oracle.com>, 
    Dave Hansen <dave.hansen@intel.com>, David Hildenbrand <david@redhat.com>, 
    David Matlack <dmatlack@google.com>, 
    Frank van der Linden <fvdl@google.com>, James Gowans <jgowans@amazon.com>, 
    Jason Gunthorpe <jgg@nvidia.com>, Junaid Shahid <junaids@google.com>, 
    Mike Rapoport <rppt@kernel.org>, 
    Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
    Pasha Tatashin <tatashin@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
    Praveen Kumar <kpraveen.lkml@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
    Vishal Annapurve <vannapurve@google.com>, 
    "Woodhouse, David" <dwmw@amazon.co.uk>
cc: linux-mm@kvack.org, kexec@lists.infradead.org
Subject: [Hypervisor Live Update] Notes from October 6, 2025
Message-ID: <8d58869a-6587-8106-3518-a8a70784ce11@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B7D171A000E
X-Stat-Signature: 9fop3giue44naq7oygmfa1i53ouqa4s4
X-Rspam-User: 
X-HE-Tag: 1760313462-990102
X-HE-Meta: U2FsdGVkX1++pqzEVe+V7eCfZAvKa8KLV3Ta135ihhc40Bu8dCtaR7dV5u8ALfvyGs2M3tw22HBTL64mWEF0MFKF2GtAbabKyaq2+boXaSKj7+og4MCIinEuIm96AyKJ+RTjDM8f2wFi1b4SYCyBhaIZ+FTRIxNwgFmATaM14xTXnkQrzg42Ko7xw9qfrwbhvIR+JRNR7Tg4uvdC6ERyJoaG6pc3s7jq1MeNekwkFI7O8ggkn+vMUjdUCltd8T4xquIu4y8/ObZNNxLf1zcxSI6fVmGWBEhhkc//pmSb3FMSem5ap445r6Y5CHHZw4wCpWhYOg9lF7RKjjYxhuyS01AlSOyDYn7uGul6bPeC/jFw5yzQt/F6ho7S7fAzodo7prJickJ7ij9It1WZ+sJosE//LVamzOp/opW18e1vOu78uD5a96vFgf2b6rbxS/rBloARLUJDWJFY5GV6dzaOBaCXL1ZhbgZCcsmcJh/Zg9ubDvfWCtAuA9j+BDjUbTAXgDfx+p3gl2TCxMKThp9YBMb4LAr5CVJn1/RvOd96tivePcH0+hpN8WAb1yMaHcIRngQio6itv8puV0ajCmLlCLOfkbQN//v+Li/MaVHDo+W2jDss2v3kl3EBMN1Mh0AfRttHOABvQEUvTgsAWINTPkiQ0XEi9KOecDeS7kMJ2AS3YfJdp5pADSrLTyP2hJ0mi7TO6ZJabZoOrCPfU4nZwXERNhYXf7qEqxbhhyzw8XSMrGKQighXP0Ml4JEpCnvRRZgppF6wj6jAOQGYUmD8NfJKtgK3L6ht/CIxNSWwIMbq71uryRtzzs6wEQJyGkd5cQ73cBuDMQ6aterSA8EwVTFZzohnQy+d9vHEOZm9oKTI2scg8PjEBvE9RS6gDj5B7TCcGw5jjv0mh/P/T1CnjHvsyav/3Y4s5bAnw2DKrSn2saNP6+C1fnKtfiMNhh7oQif8ABREtNjpaEEnMlK
 JvkRzXGO
 TkasCDz2+C98qX6rxHgNaOy8CcPMQ6PPu8VWzc9vD0cOVLuz0DGNgKLu8S3/NmDobLvF/Mv/C3bkvzzLxvYCWCsMbDOBlleYSdRAcDftky40+k4mYdHksmGmN6hW69gctYEA6hwShl3fJ4VSeK6MlvmSJMymJ5oNCAqgR7UrWR0SXvLA78XlrAifxRNDuA4QT0ENRqO5nxaw/8iEuLi7E4EvHT1LWMB/5+xSz49JPPzZ80P4+tZtyhM0e/GBOgVqKRb19l/+bywD91/wZgoMkyddPHjEnJT0xWIthakfU2lHJjaSoO3PG1nZgahLnvrZzkU5+9Wi1ezS3WcC25U176T3Ntj3TPIpUTJ+Gg6tf7kWjZ95f+gDZhf58MkriF4BZHtAiuLXBlIM/J2sJ4hxC7dCMr7qF0p2sb9NgV9Us3Ua9qj5fJfK9RlFzaN8KbB2cyB9FdOWXq6lNgXScQ2TDZf/GYWWnGIZ1e8HPuozzk/7Xu1MIyyhCULVeFk6J3yTpQ1KJNc6ISOxinO0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Hypervisor Live Update call that happened 
on Monday, October 6.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Pasha started off with LUO v4 discussion points.  As discovered during 
iommu preservation series review, we needed dependency tracking for 
situations where one fd depends on a resource.  There are two options for 
this dependency tracking:

 - Option 1: when the fd is preserved with a callback, can_preserve(),
   which determines if it can be preserved (and all dependencies are
   already preserved)
 - Option 2: when we go into prepare(), we check the inter dependencies,
   which also allows for cross dependencies (A depending on B, B depending
   on A)

In Option 1, userspace must declare which dependencies must be grabbed in 
which order; this is not a requirement for Option 2.  Pratyush suggested 
to start we could go with Option 1, including for unpreserve.

Pratyush suggested there may be an Option 3 where LUO preserves a group of 
fds, and they get checked as an entire unit (similar to fdbox).  Pasha 
said that grouping restore is not possible, same as session grouping.  
Praveen Kumar suggested that ordering is important; Pasha agreed, but said 
that the question was when this happens: during preserve or during 
prepare.

Jason suggested that preserve would need to know the dependenices at that 
time (Option 1).  He said that we wouldn't be able to allow the memfd to 
become mutable until all the fds are put back on it; the sequencing would 
require the ordering to be establised at the time of preserve.  

Pasha suggested that when we go to prepare phase, it is likely fine to 
have them in a different order as long as we are 100% sure that the memfd 
is going to be serialized.  Jason said when the memfd is frozen, we can't 
have inconsistencies; the iommu can take the page pin but you can still 
ftruncate() the memfd and that will make the memory delay freed by the 
iommu.

The conclusion then was that Option 2 was not possible, we need to know 
the right sequence before prepare.  Prepare would likely need to do its 
work in the same order that can_preserve() was called.  Pratyush said LUO 
v4 already had per-fd freezing so we could force userspace to do it; for 
example, when you preserve iommufd you just force userspace to first 
preserve and prepare the memfd that is dependent on it.  In this case, the 
kernel is just checking and enforcing this.

The consensus was to check the depedencies when you do the ioctl and then 
fail the ioctl if needed; userspace does all the ordering required. 

----->o-----
Pasha asked if we still want userspace to provide tokens, which was 
previously needed because we had global fd preservation; now, each session 
has a token that starts at zero: whatever was preserved first has token 0, 
what was preserved second has token 1, etc.  Jason suggested against the 
kernel issuing tokens again: the token allowed predecessor and successor 
VMMs to have an ABI where they can say this object is this thing with this 
token, and they can then pull it out with that token.

Pratyush asked what we want to solve with kernel issued tokens.  Pasha 
suggested we might be able to use tokens for ordering.  Pratyush said if 
userspace uses tokens then they can use the same scheme.  We decided that 
tokens should be removed from ordering.

----->o-----
There was discussion on whether sessions should be removed entirely or 
not.  Pasha noted that iommu required a subsystem because it requires 
cross file descriptor data during boot.  Jason suggested not expressing it 
as a subsystem with callbacks; the goal is that the first thread that gets 
to serialize the iommu synchronously creates the serialization data under 
a LUO lock, the next thread gets the serial data under a LUO lock and may 
make a little change.  We likely don't want to track this as part of a 
subsystem abstraction.

Pasha said that with no callback, for iommu, what we'd want is a call into 
LUO during boot to ask for the data.  Jason suggested this may be correct 
but was focused more on the suspend side.  He said during probe we'd have 
to ask for the early boot data if it exists.

Pasha was going to propose an RFC discussion usptream on the APIs for 
this.

----->o-----
Andrey discussed the current status of his KSTATE work.  He wanted to 
describe what should be preserved without requiring major subsystem 
changes.  He suggested a description in common code that parses the 
description and saves and restores with versioning.

For example, for struct a, the struct kstate_description would include the 
min_version_id that we can restore from.  It includes a state list and a 
list of fields to preserve.  The KSTATE data format includes a magic 
number, state_id, version_id, instance_id, and then the size of the data 
for preservation.  The states are then repeated.

This includes fields versioning; when data is added, the version is bumped 
for the field.  This allows for making compatible changes for the new 
kernel.  Jason was against the idea of throwing away data; the idea is 
that if the old kernel included data then it would be wrong for the new 
kernel to then throw it away.  Andrey suggested bumping the 
min_version_id.  Ben Chaney suggested it will be useful for adding a new 
field that the old kernel did not support.

Jason said that if data was changed, there would likely need to be a 
significant code flow change associated with it; a recent example is the 
vmalloc patch series that ended up in being a significant change.

----->o-----
Next meeting will be on Monday, October 20 at 8am PDT (UTC-7), everybody
is welcome: https://meet.google.com/rjn-dmzu-hgq

Topics for the next meeting:

 - follow up in fd dependency checking and this happening at the time of
   preserve rather than prepare (Option 1)
 - follow up on not relying on subsystems in LUO and the APIs on both
   sides of the live update for getting data needed
 - update on latest status of LUO and next steps for merge into akpm's
   tree
 - update on the status of stateless KHO RFC patches that should simplify
   LUO support
 - update on memfd preservation, vmalloc support, and 1GB limitation
 - discuss guest_memfd preservation use cases for Confidential Computing
   and any current work happening on it, including overlap with memfd
   preservation being worked on by Pratyush
   + discuss any use cases for Confidential Computing where folios may
     need to be split after being marked as preserved during brown out
 - [15 min] summarize upstream iommu persistence discussion and surface
   any misalignment
 - later: testing methodology to allow downstream consumers to qualify
   that live update works from one version to another
 - later: reducing blackout window during live update

Please let me know if you'd like to propose additional topics for
discussion, thank you!

