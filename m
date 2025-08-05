Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3619C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 20:03:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 222F68E0002; Tue,  5 Aug 2025 16:03:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D35C8E0001; Tue,  5 Aug 2025 16:03:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C2BF8E0002; Tue,  5 Aug 2025 16:03:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ED35F8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:03:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D44E57375
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 20:03:24 +0000 (UTC)
X-FDA: 83743778328.15.BA39D0B
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id D6648140010
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 20:03:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VlMgy07f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754424202; a=rsa-sha256;
	cv=none;
	b=yUVj7vRYVL4654qXMVyhn0RZwJszQI5DLxp0+MXdVM8qhkS++4qi+R6nncYzrPrv6GZ28K
	Vi0TbMjtcHFROd6vXB8UT5Xa4OKsVlnYcfWT5nhMIe2DM5B24r66xrfBhEtpWUx4dxoHua
	YPD0f4O4croPrdmsuyTaA3fc2mGqfvs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VlMgy07f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754424202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HURENJIwBW4HrYnDuyD6HC79md6aohHgiDH/gmZ6R4Y=;
	b=YPfRabfOujg1J+n3QwEN0W+XymvxVQlZlG5piy2j8b3fhTIPQX3qBwTYk83/5FeMtjdaSh
	s/kgexC5ZEWxCvFBQTpbCUBq7UkJGKf0IYjV5rXNh5Kw89tkKf7Sw6zGZ+5D85Ug3watd7
	SuWs7VTG79y+MuKL9f61xrGRBrN6SlA=
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e8da9b7386dso336135276.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 13:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754424202; x=1755029002; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HURENJIwBW4HrYnDuyD6HC79md6aohHgiDH/gmZ6R4Y=;
        b=VlMgy07fQ5SP//bTRxr4o52dK3D0VMc9mMiOFH6ACVY1Ct32R7BO7KzOE29awjBskQ
         wjbV3Q+ys5Tr6Cu/xbcrdW3FvgEoZkwxEoCSX1SF3bY3vV8XwhUabi4EYO2P7Vm7SqGu
         zfdV9l13chQU6iOvD05ZCtT5QckFG8yhE/DtJFT0IBTEIIKNaHl9ydZc+bcn9BaZhXRD
         e1/EAgUJ48vLm84Oxn3xBXL8oiSa9WfFQ0BAUQJPb7TnxufiO08u+Zuu0vV76dVlJFnk
         +O4I+8nsu+TnJgaJo8AikdHmHAiyJRRMgH4SDscPAPAjFGPZF3ouiJ6AsfTfhb3ZEC2v
         6hZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754424202; x=1755029002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HURENJIwBW4HrYnDuyD6HC79md6aohHgiDH/gmZ6R4Y=;
        b=c6TiycyVM56hgQncB0N/9YKyZMRUdVflc7cXMqsXrORu+Qkqden+XkyB5Lsz+PxHD2
         Z0f7iZ3FYDWB35OG1uxSwI83/FyrVLkEoEWDAg7Umnbt/MrKwo7YmxKNAh5at+hu/TYo
         TwbKC/ivXuyjKDIMAQb/48qy6cPMtMUpmFjUS09kO+5VQQI5u8OpPporG2xeoYf8dwL8
         7nSOFNeJy4y9jKDOp9BxrxJXUbZVukZza40u8YOh41SxFFWZ7ggnuAIdor28cNGlVTO8
         Vs2NKF8/DxUGMgXjjhWe1sTsRIlXwQzgjnJo+13LMnC/cVDJ0KYIPRSM+4rAgB9wd7S2
         ljqw==
X-Forwarded-Encrypted: i=1; AJvYcCWdCdyqGX7+WtPxOQPiNYcfiu5WQ4XaCdu9RIn98NX5pK26mTtHcIYGyFdKzFTSSkNaFp1w/ByOKw==@kvack.org
X-Gm-Message-State: AOJu0YzNhRIdzedLC+lKefoiPMB8uzqIcWPc4K0Nv8WeOzwytM1JV9vI
	sWDSFAo3sUoA3FBso5/hPfdY41SVH8Q4j/mjpAAuHfXR1iSUnctONtPG
X-Gm-Gg: ASbGncuK3Q8lGNpcxja9YxU2J4Rf2kV/sxD6iu2SqySY48padYBBR7O9jC3j+G6wKpZ
	4X1/Q88TNrRVwjlXZyW6XZJ8FnXD3TJWxTXaaJ+S2chvyufODmNiK+tKYIzD3EijGm8pTpBjr1P
	FL1l/9Cn3I4WkVuP02/ogzFxGU5lrxG1wvu6aq7h7hdxTYReQPvFWxkA1pMkBjsKT2tD/EjALqN
	FcS8luyx8lwYesWpxJqIIE3uQn8Bce8lX3UHWodjUnsYFaouoZlUHsLCY1WgDBysSWFeSos0bFJ
	10/kpcTm3h3PoBMtIbJFGLuQOZ4XtDKQy8Re7sYRyUbhqNPhe0ZgpfeLtJ8W4S1bixXNpTQ7+bq
	hr4gfqa1RP1fv9vD3D3O7c1cVkfusPZJQ
X-Google-Smtp-Source: AGHT+IFnzMQf5da51VExlk1Urn50FIjZRa8sDOuW02dJ1AnrX7pyCFyQYMgNkjSpbi1PpgHTIjcXag==
X-Received: by 2002:a05:690c:6b03:b0:71b:69b6:9438 with SMTP id 00721157ae682-71bca5db9acmr3454587b3.0.1754424201439;
        Tue, 05 Aug 2025 13:03:21 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:50::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71b5a3a9986sm33829937b3.12.2025.08.05.13.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 13:03:20 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	SeongJae Park <sj@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Alistair Popple <apopple@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v2] mempolicy: Clarify what zone reclaim means
Date: Tue,  5 Aug 2025 13:03:18 -0700
Message-ID: <20250805200319.1298046-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <871ppqy2v1.fsf@DESKTOP-5N7EMDA>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D6648140010
X-Stat-Signature: 9tjwwsdg93o7r3igscxtbhj6kx7pdpx4
X-HE-Tag: 1754424202-118417
X-HE-Meta: U2FsdGVkX1/fqKxh/HWNsVSr+js2wnyFssFiFaiILJm1i5G97IW4HyAkwlZK+PxOdIdI+qEqahYaErqs/UYJTriP8CqiwEQHLNiS6XDjCdZ1a3xgI5Vu8YLT8Ct8fbPH/Y/nszoWU6x5SDzUHcgRxDrKM22J87Cq42+/3KRXnsnK+C2nQUlyasYhYeP0MYbxcfiNFDf1qiPWD2eruS+TyBVB9/mMc2NDJ0W37P+FQ8VT67Hx54TGHiwJzjFPzf0c9af9W8aPG+0w2je9jTeTBUt4bFUstLWkTc26cl1QniftEa2A+EL35mwUXyEpJmam1StMTuplfebm78krS93Ing2XIc37845wDVglVSSHprQhfZRPpCgUOx3Rn7OCylkNCib23hpRFZrv5RV3yP4Aa4UcWxtJmIAx//nrR67RdQ6N+glnbsgEIwqosXYZmhwEJCMBFSPV5LRyJWN6abzWt1gRXpCAAnQwWqulFG9d11vb+saZilGLaM+AHXVbb9ZbYmPubyXVoY2VAwK1jeRunrDLtLJILqZp1u9ETCXsiNsrQ8OLYJU7jKHvIyC5emJsJ1IjwyNRiDuMgB5RMYUzh5JhBcJ4b8sAat847YAcDMnFF+VjDpppk8vodMDlhlBhjEr3ubIOMF92uT0n2RhRFU/FLJpmy8HGW9QgYLL+OFpk1dyR1R3qFzonJcZ/Up32SiriMP6PM9+RWGxHLBRSBpZNcipUkfHWsn86CMuFSedm+cS5M3FaHgeeqSGruTDf6j75qK1OyUER/NzmFFZMKmLeu9QRuN+Y9EmnvqPfXZor/X1rpDmufNUPAZCNZsR6rAxGK3pHfBemU0iKpKv3gFdNEPf9o9wu0V8S/u60fl2O26J/BXKp1LfSWC5Zbd6J8r97N8pKwMPVWjScsZ+5NSndJVY6m2OexwEvSTDRXzNjwOVjHrh7fEmPpYLuZ3bWobc6uFnlLBf12ooKLe9
 wqmaeCeI
 tdB1CrdJsnljB40z0zzjWVS1xhmotXz7x8QXnGresnXAQFiNSkvM+uIYcK7pVo32ZosKhTlstCsLICq4tj3mjWDbK3Dl1fO2pC9we8rifnvZkrHug60qaLfwhifcTiJgeVRWxPjzEGFgmAnI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 05 Aug 2025 09:27:30 +0800 "Huang, Ying" <ying.huang@linux.alibaba.com> wrote:

> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
> 
> > On Mon, 04 Aug 2025 09:24:31 +0800 "Huang, Ying" <ying.huang@linux.alibaba.com> wrote:
> >
> >> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
> >> 
> >> > On Fri, 01 Aug 2025 08:59:20 +0800 "Huang, Ying" <ying.huang@linux.alibaba.com> wrote:
> >> >
> >> >> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
> >> >> 
> >> >> > The zone_reclaim_mode API controls the reclaim behavior when a node runs out of
> >> >> > memory. Contrary to its user-facing name, it is internally referred to as
> >> >> > "node_reclaim_mode".
> >> >> >
> >> >> > This can be confusing. But because we cannot change the name of the API since
> >> >> > it has been in place since at least 2.6, let's try to be more explicit about
> >> >> > what the behavior of this API is. 
> >> >> >
> >> >> > Change the description to clarify what zone reclaim entails, and be explicit
> >> >> > about the RECLAIM_ZONE bit, whose purpose has led to some confusion in the
> >> >> > past already [1] [2].
> >> >> >
> >> >> > [1] https://lore.kernel.org/linux-mm/1579005573-58923-1-git-send-email-alex.shi@linux.alibaba.com/
> >> >> > [2] https://lore.kernel.org/linux-mm/20200626003459.D8E015CA@viggo.jf.intel.com/
> >> >> >
> >> >> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> >> >> > ---
> >> >> >  include/uapi/linux/mempolicy.h | 8 +++++++-
> >> >> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >> >> >
> >> >> > diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
> >> >> > index 1f9bb10d1a47..6c9c9385ff89 100644
> >> >> > --- a/include/uapi/linux/mempolicy.h
> >> >> > +++ b/include/uapi/linux/mempolicy.h
> >> >> > @@ -66,10 +66,16 @@ enum {
> >> >> >  #define MPOL_F_MORON	(1 << 4) /* Migrate On protnone Reference On Node */
> >> >> >  
> >> >> >  /*
> >> >> > + * Enabling zone reclaim means the page allocator will attempt to fulfill
> >> >> > + * the allocation request on the current node by triggering reclaim and
> >> >> > + * trying to shrink the current node.
> >> >> > + * Fallback allocations on the next candidates in the zonelist are considered
> >> >> > + * zone when reclaim fails to free up enough memory in the current node/zone.
> >> >> > + *
> >> >> >   * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
> >> >> >   * ABI.  New bits are OK, but existing bits can never change.
> >> >> 
> >> >> As far as I know, sysctl isn't considered kernel ABI now.  So, cghane
> >> >> this line too?
> >> >
> >> > Hi Ying, 
> >> >
> >> > Thank you for reviewing this patch!
> >> >
> >> > I didn't know that sysctl isn't considered a kernel ABI. If I understand your
> >> > suggestion correctly, I can rephrase the comment block above to something like this?
> >> >
> >> > - * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
> >> > - * ABI. New bits are OK, but existing bits can never change.
> >> > + * These bit locations are exposed in the vm.zone_reclaim_mode sysctl and
> >> > + * in /proc/sys/vm/zone_reclaim_mode. New bits are OK, but existing bits
> >> > + * can never change.
> >
> > Hi Ying,
> >
> >> Because it's not an ABI, I think that we could avoid to say "never".
> >
> > My personal opinion is that we should keep this warning, since there has
> > already been an example before where a developer tried to remove this bit [1],
> > and this broke some behavior for userspace configurations. However, if I
> > understand your comment correctly, you are suggesting that we should change
> > the wording to not include "never", since sysctls are no longer an ABI (and
> > therefore we should be OK to change what the values mean?)
> >
> > If that is the case, then I can send in another patch since I think the goals
> > are a bit different for the two patches. With that said, I think we should
> > keep the warning just to avoid any breakages in userspace, even if sysctl
> > might not be considered an ABI anymore (also I must have missed this, I didn't
> > know this at all!)
> 
> Sorry for confusing.  I agree that we shouldn't change the sysctl
> interface in most cases.  I just thought that we could soften the
> wording a little?  For example,
> 
> New bits are OK, but existing bits shouldn't be changed.
> 
> I think that it's still clear that we don't want to change the existing
> bits.
> 
> However, my English is poor.  So, my suggestion may not make sense.

Hi Ying, thank you again for the response!

No worries at all, it was my misunderstanding : -) This suggestion makes sense,
and I think it's small enough & relevant to the code block, so I'll also fold
this change into my patch as well. I'll send out the next version shortly!

Have a great day!
Joshua

Sent using hkml (https://github.com/sjp38/hackermail)

