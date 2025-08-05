Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E2BC87FCF
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 01:27:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A7636B0096; Mon,  4 Aug 2025 21:27:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17FD06B00A3; Mon,  4 Aug 2025 21:27:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BC7C6B00A4; Mon,  4 Aug 2025 21:27:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F10C46B0096
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 21:27:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D39DBC9FA
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 01:27:51 +0000 (UTC)
X-FDA: 83740967142.09.6F6DD16
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf07.hostedemail.com (Postfix) with ESMTP id 66CBC40007
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 01:27:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fwKIOlub;
	spf=pass (imf07.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754357269; a=rsa-sha256;
	cv=none;
	b=fJQnGJIM/MC8ZZ4zeHLdobt7cmnjFpH/c5syoK9janOc2e6y1fbbL+F3VZtt8GjYeKUkFv
	OhzoXd/lik2kUy/wX8WZ6EVJAOYoXj7AaKq3Ti4lCjb3vmimwDf0Q1HMn8HCHdNk7qj/mp
	ULNomJ+3FYpUoSV3P7NcjmwU9MoSqz8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fwKIOlub;
	spf=pass (imf07.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754357269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cZXKId3PeNNKVOXuI9328ERbsEKYr4cnkti2rofiC30=;
	b=CSLmWYd6hnWNOsqkoyk8nZX3QgRwoWzuoqWYRl4GNmdwoKln9EAYgXVkgNN1Vzcezh5bU+
	+jPtTmf7Fyv0u7RasAlzOjLPnH8WkWD3ngEdizmU24LG3ihNvKP3FLZlbkLAva7uyOh3IA
	CquSWj0sYKvqgpe7nMn5j1Y6WHRjmFY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754357264; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=cZXKId3PeNNKVOXuI9328ERbsEKYr4cnkti2rofiC30=;
	b=fwKIOlubHlVY0IM0L5d0jWgAW+W2vDZexJ4mXa+mlMeiZncTdZq4aBCHiI6nBGdcMCZIngnqQaaL7iQn89osxYyuWO9/yDrJE6a0ZW0oy/6O0RzixYTNlcNEfEeR9qBgyjjDOXbQaBUpe8NPjlgXAvjylTGX9WAlYjbXgY8anWs=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0Wl3-62P_1754357262 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 05 Aug 2025 09:27:43 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  SeongJae Park
 <sj@kernel.org>,  David Hildenbrand <david@redhat.com>,  Zi Yan
 <ziy@nvidia.com>,  Johannes Weiner <hannes@cmpxchg.org>,  Matthew Brost
 <matthew.brost@intel.com>,  Rakie Kim <rakie.kim@sk.com>,  Byungchul Park
 <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,  Alistair Popple
 <apopple@nvidia.com>,  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  kernel-team@meta.com, Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v2] mempolicy: Clarify what zone reclaim means
In-Reply-To: <20250804144200.1047918-1-joshua.hahnjy@gmail.com> (Joshua Hahn's
	message of "Mon, 4 Aug 2025 07:41:59 -0700")
References: <20250804144200.1047918-1-joshua.hahnjy@gmail.com>
Date: Tue, 05 Aug 2025 09:27:30 +0800
Message-ID: <871ppqy2v1.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 66CBC40007
X-Stat-Signature: c4bkpmm653ky4xwo6cfbnsximjj4gwt3
X-HE-Tag: 1754357268-512201
X-HE-Meta: U2FsdGVkX18yVaAsYt4QH4j5y1DZEdS7+ENwAh7RrNzYQAUNWcSXAlYJqn9vLspx1KKx6LWvpuSiz25shzEwNcAKzQvqmt+Zn5XtbGQPqjGHufFcg/F2VtDsKnVWPYzfCulS498ILhgUiU++4kaiMv6utxDYtZnL0TaYnQpIeWVHVKRgfxchYmFMTXM0NHyQ6PKEpKjvR/vVHpbS/yYIhxzgNixVFePYoO1AsL9Z1V/gpFvaykjsSVKfsOTqPCqVA9LJpOcL1xscJPhrOcAInWTjYhgECBjy2pRFVBuSB2lmIWnNXJXhtFXFqNOIYmdslKbLaRHCKmssEppREFGSHYMYRilQNOpKqXsp6WRXgVOWKUUXl1SvY5RAQ7REoSmvYkv8STKvyMDDESKSx1kgKV+HAzFGRVRHIeUMVhTGzhcBnW91qni8/4glHyr4Hcxn+0VT871N4CkIxkCXBd7/Nywr3Xv+6mljkRKax574ZH+kEa9oVa1E711As0pPGaJpNPQcEq2H/Yr8FZqVvcgCCXR1bxOtuBVV6YKvb02HrxIm3NfOTg4O95/4tu4WXZo6jwAkBmZcziuCX4jRZvEl3ul8regDPZeKl2WjWk8xuhkqg5XSoXgQ6Bnoa7cy8858kTx/xY9jff5YqnSby2Icc6ZnARWS5MvuG/rqTNYRYsX32NuqBosy48erRrjjaFJhd5dl3qi13hIVtMrkv+VLLuJNmkc8SluLS+jJUs93sODWAXQAbsUhrqB+PY8H5GagebmMS5w7ZERZewg0tWrc3yK3sPEgYfAQoOB8pAq50tlxsN53t6TfS+ODnwmNJpEfY0PTWj52oNsg+zlDEhIMvz4Mj17PlNFkWblR02LyDiuMW3RY+AI47Ac5lTbgDJqI2EDWfapk8EHQgiM5+YVWlJnbdBoPgk5OO0ci8jLVIF9L7vEp7i9ieJktLtxS2HAQt7VhdlMGiiiRRNqQ/Rt
 8ZHPnuqu
 utOxYs0jgbZPEWVcJLxnL1kK8bLWBCL00v2Jgdpi0tUVScsRXPTAHVG6DPCOh+vbDXSYrmJC8S8r4m/7dE7xlG6jlE5M9kwkTup03Y6qcJAoRK8ujkf7rAiAwP+GxheH7WJbvMCTIHad5LCmIdhFqSRA0OLS4ScfZVdcLuHaTi5ZYG+OFLOZ6pkkwr6hsXy3yRYCFvh9rPUZXXZFkidjrHKkL+37HpjzTjp51MzxRYud8Q2yRm7vS8lTnTTlh4XABt7J3JZu+JvGAF72V9FcUI8VqBGnnwfpEOgFDDJymLGhxIwX+8Xaovx2uBURWdi1vP3qG6AuL2Gp8PtLCE/+lvmhOeQK8MIdInM1ZizcraOaIKp+74FBwZIuC307Vywx275Xg8IGr/Qp+URolytP1N/PGlg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Joshua Hahn <joshua.hahnjy@gmail.com> writes:

> On Mon, 04 Aug 2025 09:24:31 +0800 "Huang, Ying" <ying.huang@linux.alibaba.com> wrote:
>
>> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
>> 
>> > On Fri, 01 Aug 2025 08:59:20 +0800 "Huang, Ying" <ying.huang@linux.alibaba.com> wrote:
>> >
>> >> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
>> >> 
>> >> > The zone_reclaim_mode API controls the reclaim behavior when a node runs out of
>> >> > memory. Contrary to its user-facing name, it is internally referred to as
>> >> > "node_reclaim_mode".
>> >> >
>> >> > This can be confusing. But because we cannot change the name of the API since
>> >> > it has been in place since at least 2.6, let's try to be more explicit about
>> >> > what the behavior of this API is. 
>> >> >
>> >> > Change the description to clarify what zone reclaim entails, and be explicit
>> >> > about the RECLAIM_ZONE bit, whose purpose has led to some confusion in the
>> >> > past already [1] [2].
>> >> >
>> >> > [1] https://lore.kernel.org/linux-mm/1579005573-58923-1-git-send-email-alex.shi@linux.alibaba.com/
>> >> > [2] https://lore.kernel.org/linux-mm/20200626003459.D8E015CA@viggo.jf.intel.com/
>> >> >
>> >> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>> >> > ---
>> >> >  include/uapi/linux/mempolicy.h | 8 +++++++-
>> >> >  1 file changed, 7 insertions(+), 1 deletion(-)
>> >> >
>> >> > diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
>> >> > index 1f9bb10d1a47..6c9c9385ff89 100644
>> >> > --- a/include/uapi/linux/mempolicy.h
>> >> > +++ b/include/uapi/linux/mempolicy.h
>> >> > @@ -66,10 +66,16 @@ enum {
>> >> >  #define MPOL_F_MORON	(1 << 4) /* Migrate On protnone Reference On Node */
>> >> >  
>> >> >  /*
>> >> > + * Enabling zone reclaim means the page allocator will attempt to fulfill
>> >> > + * the allocation request on the current node by triggering reclaim and
>> >> > + * trying to shrink the current node.
>> >> > + * Fallback allocations on the next candidates in the zonelist are considered
>> >> > + * zone when reclaim fails to free up enough memory in the current node/zone.
>> >> > + *
>> >> >   * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
>> >> >   * ABI.  New bits are OK, but existing bits can never change.
>> >> 
>> >> As far as I know, sysctl isn't considered kernel ABI now.  So, cghane
>> >> this line too?
>> >
>> > Hi Ying, 
>> >
>> > Thank you for reviewing this patch!
>> >
>> > I didn't know that sysctl isn't considered a kernel ABI. If I understand your
>> > suggestion correctly, I can rephrase the comment block above to something like this?
>> >
>> > - * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
>> > - * ABI. New bits are OK, but existing bits can never change.
>> > + * These bit locations are exposed in the vm.zone_reclaim_mode sysctl and
>> > + * in /proc/sys/vm/zone_reclaim_mode. New bits are OK, but existing bits
>> > + * can never change.
>
> Hi Ying,
>
>> Because it's not an ABI, I think that we could avoid to say "never".
>
> My personal opinion is that we should keep this warning, since there has
> already been an example before where a developer tried to remove this bit [1],
> and this broke some behavior for userspace configurations. However, if I
> understand your comment correctly, you are suggesting that we should change
> the wording to not include "never", since sysctls are no longer an ABI (and
> therefore we should be OK to change what the values mean?)
>
> If that is the case, then I can send in another patch since I think the goals
> are a bit different for the two patches. With that said, I think we should
> keep the warning just to avoid any breakages in userspace, even if sysctl
> might not be considered an ABI anymore (also I must have missed this, I didn't
> know this at all!)

Sorry for confusing.  I agree that we shouldn't change the sysctl
interface in most cases.  I just thought that we could soften the
wording a little?  For example,

New bits are OK, but existing bits shouldn't be changed.

I think that it's still clear that we don't want to change the existing
bits.

However, my English is poor.  So, my suggestion may not make sense.

>> > Thanks again for your review Ying, I hope you have a good day : -)
>> 
>> Welcome!  You too!
>> 
>> With some trivial tweak, please feel free to add my
>> 
>> Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
>> 
>> in the future version.
>
> Thank you for your review Ying! Since there is a question remaining about what
> to do with the "never" statement, I will wait to send out a v3 with your
> review : -) 

---
Best Regards,
Huang, Ying

