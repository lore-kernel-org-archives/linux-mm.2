Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE017606A33E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 01:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=eAOG8pbb
Received: by kanga.kvack.org (Postfix)
	id 82E1F6B05B1; Mon, 26 Oct 2026 21:33:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DF8A6B05B2; Mon, 26 Oct 2026 21:33:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FBCC6B05B3; Mon, 26 Oct 2026 21:33:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 416A96B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:33:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 973FF1A08C3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 01:33:49 +0000 (UTC)
X-FDA: 85366684578.26.5BD9533
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf25.hostedemail.com (Postfix) with ESMTP id B0475A0003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 01:33:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eAOG8pbb;
	spf=pass (imf25.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793064827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AUKkIWQs2ewX67X4mBGfWX1vbhCjN0R0JPL42QDM2II=;
	b=r4Es9MElm6ORXrXzM7wjuPSNOMruQSVwZ2DsUCcW+Ww+aS4v79h0KCjsGuq/YTnSYPMSUs
	dKoegtbD+kAeW0NV/IoE2ae4H2ArrcmbUKXoKZgBRiEARzJZvcm8lFeYZ6qv5W/J8mKndn
	kXmnwSF7FMHRuXMZ0V+pCXVevuvUGmo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eAOG8pbb;
	spf=pass (imf25.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793064827;
	b=Dzi8KksqjpGCC/Gjv4BAFMjP8/h88VYe9omnb5aWTHghCIygI1fiwgcSWv0XB/HyOUbwHl
	WSIuIiadaU45+QM1QiKhjLPquyll12059u525v9l9kF6F2pSuzUV2eBPpDZpsno1YAnYkk
	PSwFOWKPmLraxIIQSdX9AlVcpLyzy4k=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793064824; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=AUKkIWQs2ewX67X4mBGfWX1vbhCjN0R0JPL42QDM2II=;
	b=eAOG8pbbSD7OQNP1Pwmk6qYGj4pSdvW5IHSHPccxqlzqaUFVTm7nfNhGuT8HgXX/CqYYXuwN7Cv3YfTq/mXmWIl6Xpmae41SBnDaVWVLj4maTw4bPLxGUGY5g6pnfr2XgBDrF+NV6akKMUTB2aXtv0BvRxlaa8d2FOMP0tXcEIk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XDc-YUR_1793064822;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0XDc-YUR_1793064822 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 09:33:43 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: "xiangzao@linux.alibaba.com" <xiangzao@linux.alibaba.com>,
  "rppt@kernel.org" <rppt@kernel.org>,  "wangkefeng.wang@huawei.com"
 <wangkefeng.wang@huawei.com>,  "chengkaitao@kylinos.cn"
 <chengkaitao@kylinos.cn>,  "vbabka@kernel.org" <vbabka@kernel.org>,
  "david@kernel.org" <david@kernel.org>,  "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>,  "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,  "surenb@google.com" <surenb@google.com>,
  "linux-mm@kvack.org" <linux-mm@kvack.org>,  "muchun.song@linux.dev"
 <muchun.song@linux.dev>,  "ziy@nvidia.com" <ziy@nvidia.com>,
  "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
  "liam@infradead.org" <liam@infradead.org>,  "linmiaohe@huawei.com"
 <linmiaohe@huawei.com>,  "mhocko@suse.com" <mhocko@suse.com>,
  "kaitao.cheng@linux.dev" <kaitao.cheng@linux.dev>,
  "tujinjiang@huawei.com" <tujinjiang@huawei.com>,
  "mgorman@techsingularity.net" <mgorman@techsingularity.net>,
  "ljs@kernel.org" <ljs@kernel.org>
Subject: Re: [PATCH] mm/highmem: refuse to copy hwpoisoned folios in the
 !copy_mc fallbacks
In-Reply-To: <2b2abc8718f1462f475d816437cdf65284698548.camel@amd.com> (Shivank
	Garg's message of "Mon, 26 Oct 2026 12:17:56 +0000")
References: <20261026025724.1430747-1-xiangzao@linux.alibaba.com>
	<87pkww7lnl.fsf@DESKTOP-5N7EMDA>
	<2b2abc8718f1462f475d816437cdf65284698548.camel@amd.com>
Date: Tue, 27 Oct 2026 09:33:41 +0800
Message-ID: <87h5i86i6i.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B0475A0003
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fwiik5zc91fuffoz8i8aubk6r9hgo3fq
X-HE-Tag: 1793064826-908802
X-HE-Meta: U2FsdGVkX18YXaSsfQmZpD+NPpShBcnP7SkLfp4gH7ahTCVI1hXGu0lNgBKGXTa8MTUryTcKYFa+X1umQ5AmSvMWylLDDDrRbustFdzTat6MGUbZsBju+0DHtaoRwuwvtKmThvEv8DkFiCEL3uHoUDWeb3aEVhfXj4KxulmxZEImCaH2HY8J1DnJkwpNcnQ0/cFpqt+ggg4iSCiPW473hZYlG+wIWUev6gK+NATYMmBx6IgS8T5cEBFOrt3rH0gSjj7+CILAlKZPcZ2hZiQO6n62eyRMIQPCZMmWTMWwvS5UYRw6tD5AdY2yK/mIDKbur+0pgJxQzO6jdpMJZnAVZWr1tgLdx6tzekJWuCOw6XcbjuosUh3sTOhntLk8qXuHwY2td7IBldrXs3i2hqz173plwM0ya3eS+71sQqx7Aa636VP12KJi/R86GzuB2dPnvscTrCRU/gAlR8iMPvWx8RSCIttmqSYMkGvlrEKRWN1lUuASfnliuaY5X+b5XAve5F4xZjuvleQeR2gfZchntkS3CAQQ1ZswUlLxyge+yvt7iWUjGA4EpRM35l+m2KRqGVnd6gvQrSCIRb88FWbAM44rmIJTgBXA646Uq9Z3Mf05Xp1WzZLUy23QDg6UtQQ+y8JTjGPGg05wXX3d8YSMZ0WZ51ruWODh1icsfX6VQ0Rt9TIBDSEgujVGafM9ACvvObMFkKUYNzV+v0ikbFPlZqNwYdgRP3p4jkWdj0dTa9X4gZnVdKyZJTVq4ura/cr07A8wPhxDUDn7sdKGfWLMUxz6SSR0tfGZ5r3NlZHZjK3e5knaVi2nsQ3lBYFDfUSrSp3vFTbOPA3CAvFW8upFAsFSZsgs5rPkjvBgGQFbayU+aSSdqfCeDwD80bqPH2RAq5ihbm6CTyh5Sns6OYKZLy0BBRVOmqYdfXqENd7fWJ12LfQN5rKbJVsbR25XFa3lLIDPiFUjCSHod/3TBIG
 pj9Kot03
 fwnG9S13eZ0JokgHTYBipinlQlgJ52awECBP1vPm6x2MrPW//CT5GPjMMfJqnFmLQtYFBV+7NQNoxitXjRiMjoGUmIwHOaZTpHp3JdxW/t7AdrZuNEqs2UgzVTzQHvzcaWq8MTmFblz4oHHQ+gYBLywOzbm5wNkA2MU6A/Jq+LIK6HIUe6g0QGVO9fY1fzW2zOtLbLvPgPusbDtcp0I1+B3XtfXewBaJry+n5Kzb+zPO4gN/2IADGmB8QabB9/lArk2QQdfjCIgnnweGw9OH0L96KWApn2IyvIpET7Uw4iuRnOSKphiHOE8N0EYEmwEvwWm3nmXL6fS6BXQMbrFzkVIIQfSo7TGVDfenEk7s1wuuObmwzydqY8AU0cDcni93DrVprWghF+HaJussUiiUQ9GWvbQyQIYtyzpSb1sz3NXuMHYwMTuU/oyygYuAtNITgC9a6a1AkBINU2zLi1E2w/Nno8A9iU9pdH4Xf3dBZyJIjvGBTyVGX0zOSivnyhUfePeYF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"Garg, Shivank" <shivankg@amd.com> writes:

> On Mon, 2026-10-26 at 19:21 +0800, Huang, Ying wrote:
>> Yuanhe Shu <xiangzao@linux.alibaba.com> writes:
>> 
>> > Where copy_mc_to_kernel is defined, copy_mc_user_highpage() and
>> > copy_mc_highpage() stop at a hardware error during the copy, report
>> > the not-copied bytes and queue the source page for memory_failure().
>> > The !copy_mc fallbacks return 0 after a plain copy instead.  With
>> > PG_hwpoison set while the data stays readable - software-injected
>> > poison (MADV_HWPOISON, the debugfs corrupt-pfn injector) or a
>> > transient hardware error - there is no fault to recover from: the
>> > copy completes, the destination folio carries no poison marker, and
>> > the poison is consumed silently, the same poison consumption
>> > commit 841a8bfcbad9 ("mm: prevent poison consumption when splitting
>> > THP") refused to risk on the split path.
>> 
>> As far as I know, software-injected poison is used for debugging only ,
>> so I don't think it's that important.  Hardware poison state in DDR is
>> sticky; that is, even a transient hardware error will cause a permanent
>> hardware poison state until a reset.
>> 
>> Therefore, the primary value of this patch should be to reduce machine
>> checks (and panics) during memory copies.  If so, we should place the
>> check code before copying.
>> 
>> > Check the source folio with folio_contain_hwpoisoned_page() in both
>> > fallbacks and return PAGE_SIZE, the not-copied-bytes convention of
>> > the real copy_mc paths, so the callers take their existing error
>> > paths: the COW and fork paths fail with -EHWPOISON, KSM and
>> > khugepaged abort, and folio_mc_copy() propagates to the migration
>> > core, where this composes with the separate migration-side checks.
>> > On archs with copy_mc this code does not compile.
>> > 
>> > The check runs after the copy: a check before it would leave open
>> > the window between itself and the copy.  A flag set before or during
>> > the copy is caught, whatever state the data is in.  A late software
>> > injection cannot have corrupted the completed copy, and a synchronous
>> > hardware error takes an arch without copy_mc down at the access; the
>> > residue no flag check, before or after, can catch is corruption whose
>> > hardware report lands after the last check.  Closing that would need
>> > architecture support, as discussed.
>> > 
>> > The fallbacks do not queue memory_failure() on refusal: the flag is
>> > already set, and memory failure either knows about the page or has
>> > abandoned it.
>> > 
>> > Suggested-by: "Huang, Ying" <ying.huang@linux.alibaba.com>
>> > Suggested-by: Kaitao Cheng <kaitao.cheng@linux.dev>
>> > Assisted-by: LLM
>> > Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
>> > Link: https://lore.kernel.org/r/877bjowf9i.fsf@DESKTOP-5N7EMDA/
>> > ---
>> >  include/linux/highmem.h | 9 +++++++++
>> >  1 file changed, 9 insertions(+)
>> > 
>> > diff --git a/include/linux/highmem.h b/include/linux/highmem.h
>> > index d7aac9de1c8a..f90f0c6204a4 100644
>> > --- a/include/linux/highmem.h
>> > +++ b/include/linux/highmem.h
>> > @@ -474,12 +474,21 @@ static inline int copy_mc_user_highpage(struct page *to, struct page *from,
>> >  					unsigned long vaddr, struct vm_area_struct *vma)
>> >  {
>> >  	copy_user_highpage(to, from, vaddr, vma);
>> > +	/*
>> > +	 * The flag can be set while the copy runs, so check after it;
>> > +	 * a flag landing later can no longer have corrupted this copy.
>> > +	 */
>> > +	if (folio_contain_hwpoisoned_page(page_folio(from)))
>> > +		return PAGE_SIZE;
>> 
>> Why not just use PageHWPoison()?
>
> This will miss out on hugetlb folios I think. is_page_hwpoison() is more
> appropriate as it covers hugetlb cases as well.

Yes, that is better.  Thanks for pointing that out.

---
Best Regards,
Huang, Ying

