Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5398C87FCA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 01:24:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B3506B008A; Sun,  3 Aug 2025 21:24:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 264446B008C; Sun,  3 Aug 2025 21:24:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 179E56B0092; Sun,  3 Aug 2025 21:24:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9046B008A
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 21:24:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 71D6D11561D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 01:24:56 +0000 (UTC)
X-FDA: 83737330992.30.2F9DDE9
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf22.hostedemail.com (Postfix) with ESMTP id 80624C0005
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 01:24:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=esVDAqRU;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754270694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ngPeLVtN22D10xiauIRgXoZxyNy5qt56LuaZTotpsjc=;
	b=ngzVtzJp8gkn4bMf5fbYHgvqeSnJBEl2nmEo5Ywh0fLdzBdpHGNMWN1uUJr9CIvfGA1R+v
	W1jReWCoLb5doLIssGZRh8eX1iEcD5nT9mOEVZdRkFJZ8+bquNTlBeMa1V3y4LkVIpMtok
	pv98QhS1DR8ZtSu+65f28KdxvzgnkRY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754270694; a=rsa-sha256;
	cv=none;
	b=Ql3nZ86B/JAFWl0z2oGPtTBKR7DD3Uy3Je9ayT8llUfjbImRvyUIHeQ+3mZHxvgJtOMISS
	r9fz9Z8ZaTNeLWLH8VFfonNrdqDlxmjSBnJoubgg3dxkGeeaBprbLZVKy0qfsmjrQYaad7
	u1+8eLEhfwz1iVNYnb8pkselvnrgbeQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=esVDAqRU;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754270690; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=ngPeLVtN22D10xiauIRgXoZxyNy5qt56LuaZTotpsjc=;
	b=esVDAqRUhaIPgt+gG1YHdtiyWSYezMhYmIZVHLFSXCYfDaPOx01vswWJWOLL1WW6K8Qjz/CsLfVVt9QcOXu3LbuUQvn9dXnqur1AILk7s14aBQwypQVs0oZeIuqK/y6ceP3ZzqS/e6fxUBuOQTadHgQGsWGMX7lEkwxXkUUfC5c=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WktIPnF_1754270672 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 04 Aug 2025 09:24:48 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  SeongJae Park
 <sj@kernel.org>,  David Hildenbrand <david@redhat.com>,  Zi Yan
 <ziy@nvidia.com>,  Johannes Weiner <hannes@cmpxchg.org>,  Matthew Brost
 <matthew.brost@intel.com>,  Rakie Kim <rakie.kim@sk.com>,  Byungchul Park
 <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,  Alistair Popple
 <apopple@nvidia.com>,  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  kernel-team@meta.com
Subject: Re: [PATCH v2] mempolicy: Clarify what zone reclaim means
In-Reply-To: <20250801144840.2067350-1-joshua.hahnjy@gmail.com> (Joshua Hahn's
	message of "Fri, 1 Aug 2025 07:48:39 -0700")
References: <20250801144840.2067350-1-joshua.hahnjy@gmail.com>
Date: Mon, 04 Aug 2025 09:24:31 +0800
Message-ID: <8734a7zxo0.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Queue-Id: 80624C0005
X-Stat-Signature: 8uxricxi8rrheqprdcidrtmbeyqm9dzz
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754270693-136219
X-HE-Meta: U2FsdGVkX18zV4Jpbm6KPJYcza/FONUMY+Q0+aTYsCWEg9Ym3jLPC1WIleGqZHVCLtCSmEP942if1ZT/bIWc2VBIdDsyCO3Uh95zszsNUczDIqpCPPQhtJcqiTy5pQJ8AzuVTHM0r2cld5zXsDM7Q1RJddnbxJvoBpZp10fnbMYRVFBYH8vR8jeWGrMPdNcCRpv3ZXKjq2RGapyXrMeogk1bpPkjpj4B5x4AxZOqVn95adv3+RP5tIB2ld+r6tPOO6IgJvViKlb9A+GHhnF1u9SXWGr9lBuyl5gbRbz4jfmd00tVdctQB8IzOcrHgL6FsfSIhk4KQmjbtmC0qCLD8dr9KzMgSNeZVT0jxAmeRWO38skx9ovtqkEYQpVoQgi8I3wquuECclVvfdrT1UWnrXRpwNTVPiNxLlFt5TPYDhEH7fdEbpOhCmtwm+5rdTr3nASVoapfmaz+URjaRkbp79pjZyO93P3fVyNzGy5NvAEg3g5t+f/sU7T7MLJJjgVFE/x5hSXLWDSd77qOtt6FkP3JgJRz9k1r52Q8f0DF67iv6Wc8dz39aApyxhkN76Q5EoUp56l0OdkZvCkymO3mDj+jkvcv+qpnaNhpRrggfM2+lhjCKvCaudiUEoLEJL1M9dYL+iaGsZwOrfgO3MhJoq1ihRPCOyPP5Oy30RjEgKRpgwNrLYqcrHlx2L2mKPXCa/9nHyE8kjvAMOTanJB8Rx1CtlE/UJ7fgIueGhCqa2J3oCoUpOBoaIzNxC3YXX8ail9pHpX1yTlT150e/w5b2hj19lUJ5WrCr1vo+G9ZtFc/nQ8zTJN90ThcNcSsNuCCwZKgm8iPZcXy98FlI2trqdKKSQFIJwnfJbFAzkEoPgN5uEr15TJOVfb5pNjgMlfnFM2SAo4K1vUa/XaJPBswALRq0+rpSfhKdxKLSCSfFU83A91XcyzPOuIiXswOOYauXtf4h8gDAAETuLax/Ri
 Zi8RG3sb
 bo13urWJmcPnBbe2URzmIfRkHGopt3FDrEZw/dyceojGEraS++ZBjiHEplNz6h+N32Fuj7LZRsojW/MUG0+VEyHXaXL9ShHYDfODxkguJ4aVInai92UD9/gmGJNV20wRJiNjkbs2Z8qAVfLKMR31mex06J3yfM+LcRVQ/yJB2USqMnFVE7esKHNL4iKxGxV857hewImUVExNChJ2Ipw86QvGY5uhNTB00cL2bgWFCKLBCqBfz8fAgHf7r4RtQZ3F9/5s4WdD+TV29CGfeEuSyJvv209+1+Vl314jX3elZ1ZJImZ1fm+Us4tj2bmoJnh5mlyMHToglVxZrSJhRac5cRJZvD+VifV3V6oz674s06TeEjhQdaIHaQmuMGskNdTTQZLVh47ns2NmkhEonP6n6vqW/Og==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Joshua Hahn <joshua.hahnjy@gmail.com> writes:

> On Fri, 01 Aug 2025 08:59:20 +0800 "Huang, Ying" <ying.huang@linux.alibaba.com> wrote:
>
>> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
>> 
>> > The zone_reclaim_mode API controls the reclaim behavior when a node runs out of
>> > memory. Contrary to its user-facing name, it is internally referred to as
>> > "node_reclaim_mode".
>> >
>> > This can be confusing. But because we cannot change the name of the API since
>> > it has been in place since at least 2.6, let's try to be more explicit about
>> > what the behavior of this API is. 
>> >
>> > Change the description to clarify what zone reclaim entails, and be explicit
>> > about the RECLAIM_ZONE bit, whose purpose has led to some confusion in the
>> > past already [1] [2].
>> >
>> > [1] https://lore.kernel.org/linux-mm/1579005573-58923-1-git-send-email-alex.shi@linux.alibaba.com/
>> > [2] https://lore.kernel.org/linux-mm/20200626003459.D8E015CA@viggo.jf.intel.com/
>> >
>> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>> > ---
>> >  include/uapi/linux/mempolicy.h | 8 +++++++-
>> >  1 file changed, 7 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
>> > index 1f9bb10d1a47..6c9c9385ff89 100644
>> > --- a/include/uapi/linux/mempolicy.h
>> > +++ b/include/uapi/linux/mempolicy.h
>> > @@ -66,10 +66,16 @@ enum {
>> >  #define MPOL_F_MORON	(1 << 4) /* Migrate On protnone Reference On Node */
>> >  
>> >  /*
>> > + * Enabling zone reclaim means the page allocator will attempt to fulfill
>> > + * the allocation request on the current node by triggering reclaim and
>> > + * trying to shrink the current node.
>> > + * Fallback allocations on the next candidates in the zonelist are considered
>> > + * zone when reclaim fails to free up enough memory in the current node/zone.
>> > + *
>> >   * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
>> >   * ABI.  New bits are OK, but existing bits can never change.
>> 
>> As far as I know, sysctl isn't considered kernel ABI now.  So, cghane
>> this line too?
>
> Hi Ying, 
>
> Thank you for reviewing this patch!
>
> I didn't know that sysctl isn't considered a kernel ABI. If I understand your
> suggestion correctly, I can rephrase the comment block above to something like this?
>
> - * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
> - * ABI. New bits are OK, but existing bits can never change.
> + * These bit locations are exposed in the vm.zone_reclaim_mode sysctl and
> + * in /proc/sys/vm/zone_reclaim_mode. New bits are OK, but existing bits
> + * can never change.

Because it's not an ABI, I think that we could avoid to say "never".

> Thanks again for your review Ying, I hope you have a good day : -)

Welcome!  You too!

With some trivial tweak, please feel free to add my

Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>

in the future version.

---
Best Regards,
Huang, Ying

