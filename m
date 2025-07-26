Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D93C83F17
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 17:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B18BA6B0088; Sat, 26 Jul 2025 13:16:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9CD6B0089; Sat, 26 Jul 2025 13:16:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DF2C6B008A; Sat, 26 Jul 2025 13:16:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F0246B0088
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 13:16:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E527F1A0B4E
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 17:16:21 +0000 (UTC)
X-FDA: 83707069362.11.F9DE002
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3273E1C000D
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 17:16:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CHJEnOlq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753550180; a=rsa-sha256;
	cv=none;
	b=ZPplIXHeZVSNFY85s7XrwrcKcUKkxiMcZ65KwP8gkPKQaxDSDlwH2NkZAQDjKMVBrrpOs+
	LQb0ygGaWitOE4UgpYBjUQ7T8jk+mMzyxXVFErvo7CcnvoAjNBd80WrT1q38pHxOirGQRv
	Booj4UUeN0qOPXI/cyNhRhnSAdqI0EU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CHJEnOlq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753550180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Br3DyzKsNiOdZfD9w98DWzJsLWoRbkOk2Mg9mzfx9Ec=;
	b=IUNu6EbydEznA35C8f+eiMNu+KX4N2zrHTz2ToUvOodaYyqLjDdDlKy1CJLhJCCsNZVPOL
	1hR/HhiAVID8TZnNLSyZNC6i/l92K/yqX9yELYcrv3EPrq/NzV+LOHR5CSEy97jUqPdPIu
	IPe6R9PEj23xVsVyaIcz0n1j47V7mH4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4068C601EB;
	Sat, 26 Jul 2025 17:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A438C4CEED;
	Sat, 26 Jul 2025 17:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753550178;
	bh=lJoV30Lp8jeFkrHdcpX9lFWnSAxypLwuqXIyL1i3Cz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHJEnOlqIukFwK2kpQCRE/qZraohP2lhwc29t7If7eBUdDykZgnFgB5uYujezEj6T
	 gI5wjCBaV1/31W/THeDxjd9SXTsbjlUxJY552jkOkb9t3sC+j51k3uIPbMq7KqJXg/
	 KRiNpPLmXDkwKzlYHfX12ciC/ZnNLFI0Ikpu8n3eF0kD3w0HzqOM+CklYTkXOtjvbA
	 0Or7zIu9jQDF5g3S0HuOgvYWtVYTOAmIqNgDRRsBYcJ/uVdHCeiOKE8HBeXfoEEAtn
	 jW908qqMsgmnr2Q/7b8ChkyrqVK1scsxd5b+0xfGFb7ffp20ZE8jSJ6LjM1NlMIASR
	 34YnGnjqhVTVw==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	zuoze <zuoze1@huawei.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com
Subject: Re: [RFC PATCH] mm/damon: add full LPAE support for memory monitoring above 4GB
Date: Sat, 26 Jul 2025 10:16:16 -0700
Message-Id: <20250726171616.53704-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <527714dd-0e33-43ab-bbbd-d89670ba79e7@huawei.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3273E1C000D
X-Stat-Signature: 9n6syhyiimjhz51jzgs7xqrtqdx4k88c
X-HE-Tag: 1753550180-417878
X-HE-Meta: U2FsdGVkX1/NTWEZnU+KpVl1TsYvk5YItPjM2WCZB2UbkIqw2+IxYjycLeoWGXMvlnRJSmG8ilv67Gn0GqkzO6wFpz3vzhJ0G9PJJ12W8auFBXJ3J9K1JDh+HmG4LWT3Jim7ZJ669F495nOPaN9nNC4OwxlkVyDD71tp5jVOtrrcbyWfFgXDsxTzVufsXq0Y8O8jWwMAx83gMfpDhkzjzj5m2Yb2LOGecrpkLLkmhzeu8JjPRNjx26vH4qJdnyuZHoInkbiC9uxbXOI6U7TbQFX8hq+vVrnTxaxYP56jasmS95DLSOB2cDhRJP5Ww2iegDovjuEzKwpW8YMKWvzpYW1PPNSp2JN4uU6K1FhDP4jFfL19CUgg5ayF5jpbtMUK+XI9PNM6+teIjGQEdv52FpoFGfxnrQw3BjeAy4Q6rUzW+yFMR4suFJ3X1HgXmVDeUae1KXwEmP2S7T+aGQNNTlvIZqV/8E+WBph3QHbaEEU1iqMlEx1IupnaQCxVFG6zaVxkzGaWVOeS1KB9cCBWzCQObgT7yuUuoIT3Zk3lisYMiRtYRrZ33zvnV6Oka1Sbmj78kRehBxZpIUY20nM/xIi6VuBizMYUXt5yPzFDObcS/DnOJtq8JyfiFx/8PNpVEnT48APNqIcSGZ97Xv00GmZTKVkgqyV57/3opBCpZ1i1svsyhoakRLwe3mpfE33Km5KxmIzroZXBfW2RHNG4Q6fULB0b9GFji2t3ZUMEbk4PsvhqENNt9vTWA4sLkxN7Y5olSntJmqC4ebOlNqf7cwsD+ZQ4sQvrD9UvXlLA2xlUaujCmtsTlQmARFeWDxBrerLboi4honsxF1QrXr+vHUp8+YXJisRLpMmjmUV8ATIAVwgnvJJ4C6N0ySTeMhKElcjEyQUrxRDVngu75CypLp/pZUMRI1xOiv4oKJZEHnGFqjABqjMOKbXWDBz9i/rKqLJQGxG5ILOTPmx7keu
 QA0sFrP5
 40d/WVnVmfzLf8eDs64KPaYCYskBm6hxKy+Wh+lZteXYdG+I+g1Y1TSvj4dqIqxYA111FCk3ZFplWW9uBmNXWE400haj2fDvrAuhZVGKjPdK+dny44i5B/qMZABcHBU6oQpevMaDP8L4JCc6y0f+hT1iwWYe+hp53htgtXCKC6E0W+o/8gxZH+1KFxzWj4AeR4T3+4TSKxV7owD5TKYMylofYsrnrvAUgjXqo6M69iqT7IQF471NrUNf6J6E5CO3TUQIeoMm/dbkDoFY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Quanmin,

On Sat, 26 Jul 2025 11:14:19 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> 
> 在 2025/7/26 4:22, SeongJae Park 写道:
> > On Fri, 25 Jul 2025 11:15:22 +0800 zuoze <zuoze1@huawei.com> wrote:
> >
> >>
> >> 在 2025/4/23 1:43, SeongJae Park 写道:
> >>> On Tue, 22 Apr 2025 19:50:11 +0800 zuoze <zuoze1@huawei.com> wrote:
> >>>
> >>> [...]
> >>>> Thanks for the patches - I’ve noted the RFC series and user-space
> >>>> updates. Apologies for the delay; I’ll prioritize reviewing these soon
> >>>> to verify they meet the intended tracking goals. Appreciate your
> >>>> patience.
> >>> No worry.  Please take your time and let me know if there is anything I can
> >>> help.
> >>>
> >>> I think we can improve the user-space tool support better for usability.  For
> >>> example, it could find LPAE case, set addr_unit parameter, and convert
> >>> user-input and output address ranges on its own.  But hopefully the current
> >>> support allows simple tests of the kernel side change, and we could do such
> >>> improvement after the kernel side change is made.
> >>>
> >>>
> >> Hi SJ,
> >>
> >> Apologies for the delayed response. We've verified your patch in our
> >> environment and confirmed it supports LPAE address monitoring.
> > No worry, thank you for testing that :)
> >
> >> However,
> >> we observed some anomalies in the reclaim functionality. During code
> >> review, we identified a few issues:
> >>
> >> The semantic meaning of damon_region changed after addr_unit was
> >> introduced. The units in damon_addr_range may no longer represent bytes
> >> directly.
> > You're right, and this is an intended change.
> >
> >> The size returned by damon_sz_region() now requires multiplication by
> >> addr_unit to get the actual byte count.
> > Again, this is an intended change.  damon_sz_region() callers should aware this
> > semantic and updated accordingly, if it could make a real problem otherwise.
> > If you found such changes required cases that this patch series is missing,
> > could you please list up?
> >
> >> Heavy usage of damon_sz_region() and DAMON_MIN_REGION likely requires
> >> addr_unit-aware adjustments throughout the codebase. While this approach
> >> works, it would involve considerable changes.
> > It has been a while since I wrote this patch series, but at least while writing
> > it, I didn't find such required changes.  Of course I should missed something,
> > though.  As I mentioned above, could you please list such changes required
> > parts that makes problem?  That would be helpful at finding the path forward.
> >
> >> What's your perspective on
> >> how we should proceed?
> > Let's see the list of required additional changes with why those are required
> > (what problems can happen if such chadnges are not made), and discuss.
> 
> Hi SJ,
> 
> Thank you for your email reply. Let's discuss the impacts introduced after
> incorporating addr_unit. First of all, it's essential to clarify that the
> definition of damon_addr_range (in damon_region) has changed, we will now use
> damon_addr_range * addr_unit to calculate physical addresses.
> 
> I've noticed some issues, in mm/damon/core.c:
> 
>   damos_apply_scheme()
>       ...
>       unsigned long sz = damon_sz_region(r);  // the unit of 'sz' is no longer bytes.
>       ...
>       if (c->ops.apply_scheme)
>           if (quota->esz && quota->charged_sz + sz > quota->esz)
>               sz = ALIGN_DOWN(quota->esz - quota->charged_sz,
>                       DAMON_MIN_REGION);  // the core issue lies here.
>           ...
>           quota->charged_sz += sz;    // note the units.
>       ...
>       update_stat:
>           // 'sz' should be multiplied by addr_unit:
>           damos_update_stat(s, sz, sz_applied, sz_ops_filter_passed);
> 
> Currently, DAMON_MIN_REGION is defined as PAGE_SIZE, therefore aligning
> sz downward to DAMON_MIN_REGION is likely unreasonable. Meanwhile, the unit
> of sz in damos_quota is also not bytes, which necessitates updates to comments
> and user documentation. Additionally, the calculation involving DAMON_MIN_REGION
> requires reconsideration. Here are a few examples:
> 
>   damos_skip_charged_region()
>       ...
>       sz_to_skip = ALIGN_DOWN(quota->charge_addr_from -
>                       r->ar.start, DAMON_MIN_REGION);
>       ...
>       if (damon_sz_region(r) <= DAMON_MIN_REGION)
>                       return true;
>       sz_to_skip = DAMON_MIN_REGION;
> 
>   damon_region_sz_limit()
>         ...
>       if (sz < DAMON_MIN_REGION)
>           sz = DAMON_MIN_REGION;

Thank you for this kind and detailed explanation of the issue!  I understand
adopting addr_unit would make DAMON_MINREGION 'addr_unit * 4096' bytes, and it
is not a desired result when 'addr_unit' is large.  For example, if 'addr_unit'
is set as 4096, the access monitoring and operation schemes will work in only
>16 MiB granularity at the best.

> 
> Now I can think of two approaches, one is to keep sz in bytes, this requires
> modifications to many other call sites that use these two functions (at least
> passing the corresponding ctx->addr_unit. By the way, should we restrict the
> input of addr_unit?):
> 
>   damos_apply_scheme()
>       ...
>   -    unsigned long sz = damon_sz_region(r);
>   +    unsigned long sz = damon_sz_region(r) * c->addr_unit;
>       ...
>   -    damon_split_region_at(t, r, sz);
>   +    damon_split_region_at(t, r, sz / c->addr_unit);
> 
> The second approach is to divide by addr_unit when applying DAMON_MIN_REGION,
> and revert to byte units for statistics, this approach seems to involve
> significant changes as well:
> 
>   damos_apply_scheme()
>       ...
>       sz = ALIGN_DOWN(quota->esz - quota->charged_sz,
>   -                    DAMON_MIN_REGION);
>   +                    DAMON_MIN_REGION / c->addr_unit);
>       ...
>   update_stat:
>   -    damos_update_stat(s, sz, sz_applied, sz_ops_filter_passed);
>   +    damos_update_stat(s, sz, sz_applied * c->addr_unit, sz_ops_filter_passed);
> 
> These are my observations. What's your perspective on how we should proceed? Looking
> forward to your reply.

I think the second approach is better.  But I want to avoid changing every
DAMON_MIN_REGION usage.  What about changing DAMON_MIN_REGION as 'max(4096 /
addr_unit, 1)' instead?  Specifically, we can change DAMON_MIN_REGION from a
global macro value to per-context variable (a field of damon_ctx), and set it
accordingly when the parameters are set.

For stats, I think the users should aware of the fact DAMON is working with the
addr_unit, so they should multiply addr_unit to the stats to get bytes
information.  So, I think the stats update in kernel is not really required.
DAMON user-space tool may need to be updated accordingly, though.

I didn't take time to think about all corner cases, so I may missing something.
Please let me knwo if you find such missing things.


Thanks,
SJ

[...]

