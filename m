Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0841E7DEF3
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:10:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8CC26B00EC; Mon,  2 Feb 2026 10:10:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0F526B00ED; Mon,  2 Feb 2026 10:10:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1B826B00EE; Mon,  2 Feb 2026 10:10:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E71E6B00EC
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:10:12 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 34C09B6DA3
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:10:12 +0000 (UTC)
X-FDA: 84399852264.20.EAD241D
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf18.hostedemail.com (Postfix) with ESMTP id A02571C000E
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:10:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=k01wZvwp;
	spf=none (imf18.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770045010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YhYlGq9J1U3W7iskvXcfDWdu0+Euxsweuhz3tvtjc9A=;
	b=iIR604u8W7kyHsQk7yeOucVaAa0pVz9Iirgbr9yMgjJAXERA9UzucYns05NwfF4XmH0Ecr
	N74JFIy0ZqMTsD31kZRlFKMyPqH811rZtB1NNe9lLV7HK4ZMK1yvgdksWNKSg0wQed4l2V
	tlyvxu1BmFJ36JOvGvrc68fMd068Q/Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=k01wZvwp;
	spf=none (imf18.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770045010; a=rsa-sha256;
	cv=none;
	b=D/2jy5WM+zDxfPFP0B7B8T/EqQDCBPZ3OnzPOunW/3NiipyLggeRWy2g/Awxm71QDjlGsg
	8PH1gk5bEPC8zJ/5mcEoYdBfGLhNN3GtMs36eE2+GByqKIWbECjrLhhE4O4IQsT6iZRlMK
	yxBd+PYbjdCd+2tvMc4sCxhVfcMIhlQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=YhYlGq9J1U3W7iskvXcfDWdu0+Euxsweuhz3tvtjc9A=; b=k01wZvwp8VQxlykqY5Rd1ZTTs3
	Rt+jBGqWUBJbPnFvF0zgKcI2s61WtZT/Z5HD55/INFG/FnO865RN5AicoNkP/0a/2FizvO05IE0kV
	GJCOLzSmqXAulHS9WwmWuMgsHb+nVY0SGaKoxckw07L1DwOlZow+wQemz/ynHvQireP/jKT2E17O7
	UvCBgmQkTwe2kL1aymWFxp7gqO5B0rMbYSjhgRGvkJODNoxmgD4z7wzuqWgTXYVPNccc8M+wiVnZu
	DIH3myH4y89jaMbfHpqIYCoh1okEO4zUr9F/V04eVQaYFldJD/dx/h9MRz36IFoHLbC7+fPEPyogA
	xHcP8F0w==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmvYt-0000000EgHu-3LpA;
	Mon, 02 Feb 2026 15:10:00 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 1938C3008E2; Mon, 02 Feb 2026 16:09:58 +0100 (CET)
Date: Mon, 2 Feb 2026 16:09:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	aneesh.kumar@kernel.org, arnd@arndb.de, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, boris.ostrovsky@oracle.com,
	bp@alien8.de, dave.hansen@intel.com, dave.hansen@linux.intel.com,
	david@kernel.org, dev.jain@arm.com, hpa@zytor.com, hughd@google.com,
	ioworker0@gmail.com, jannh@google.com, jgross@suse.com,
	kvm@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, mingo@redhat.com, npache@redhat.com,
	npiggin@gmail.com, pbonzini@redhat.com, riel@surriel.com,
	ryan.roberts@arm.com, seanjc@google.com, shy828301@gmail.com,
	tglx@linutronix.de, virtualization@lists.linux.dev, will@kernel.org,
	x86@kernel.org, ypodemsk@redhat.com, ziy@nvidia.com
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
Message-ID: <20260202150957.GD1282955@noisy.programming.kicks-ass.net>
References: <20260202095414.GE2995752@noisy.programming.kicks-ass.net>
 <20260202110329.74397-1-lance.yang@linux.dev>
 <20260202125030.GB1395266@noisy.programming.kicks-ass.net>
 <c6fda7c2-ad54-416a-a869-1499c97c7bd7@linux.dev>
 <4700e7ba-8456-4a93-9e28-7e5a3ca2a1be@linux.dev>
 <20260202133713.GF1395266@noisy.programming.kicks-ass.net>
 <540adec9-c483-460a-a682-f2076cf015c2@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <540adec9-c483-460a-a682-f2076cf015c2@linux.dev>
X-Rspamd-Server: rspam12
X-Stat-Signature: iom8wsb7y1sc4qzkeuuhqgoo68i9tbsa
X-Rspamd-Queue-Id: A02571C000E
X-Rspam-User: 
X-HE-Tag: 1770045009-304538
X-HE-Meta: U2FsdGVkX19HKvvB8u0VJEzcp5oYXayDEBTrkqTAFZRWD6amVsH/bHA4EYMG4zNRZvvU0KBHCTXRxG7x4tsqtrBux3HewzKkBIwJV+9G8eDynYFDi7wfPh+Q3L6y5csZZskp7TtdZE/6KLOTYtakFGZ/Ysskzl7lQQfWgxj5x44zncIxjhHCMeG0X6Pw/QehjAnFFQ5wtQwe9FeI0h7PWGKj+9GsbXeR4/oYzHzLbYqoJHd1J6GSCYhSF9obrf3Vhy1Shhgc88Fv+pk4Pei/MnSOgaJwbyCkJwxF25b397RE6DmogLazfLdTyigPlUlWa0fEzyi/mGp0dE7brFXuiy8RHxO63jb+x2/MfqyuUYnS6tjh4hDyg/EqvvrVgidglXSfpLXa6mJ8FrHRtWyyJULXLy3Lvc53u5RrbCkzs2epm1SiCXKrkqEvTEpXDERfdvlFhSEe3e+hEaxR3H73kZM8IUGfLD/DoOkg6XiMO5V4LIQhqKZh5pKQK16dBjTrkgskOKQ+igOLTR8+2wyHnzTjx0RtlMqs/qXbQCpsV00Yg27HMC9gOJBgS51NKfrpX1o/60xyCJsSZS26JL3bs/CsjWdXYb6sGhucsCMwHpYQfeoEomYu61Mk/86lvCr6sbOLsnAsjZSvUhw3l8+mayl6dLyLXvv0kjxhk3v1rCXVAPgUv+GrxrpV9uYjrynK9HRIvK6DZu3kLV/4ftwbtCH/TOP1cwC82/QAFsLPj9dunVfYAJh5jtwtuJIstKUkE5FiAO5OJDpou4tUl2B3SVmtbWEr7So7XNpJHaxffQhgRB36W/5LJNV2TfpC7DnbkFw0RL68DmXjqPwdZkmjlhl8qzG+HyP9eHP0LGAzlpgLQ7crOArbQfF4V6x7ThXFPKAMaiW6g4UzUzt4OCLIkVKdEFSX3EAod9izPUtVJAwNgrn0kaN8TkVZaYQjAlssV887iWNXMBXqTF4ClWR
 tU4r7GyT
 7Dpv5n9EXxEKLGuB++PPiSVHX1enJI6LOIHiC0HSYR9OtsfEu0EBgsrHQOxyN0/1ZOwKEYr4HpC+XvDFTJIcsy5mUOnkr6OC6LV1PrR8dtmZlDmDt/UD2KSjGN2OzTZREpIWeIfAWcNzei2DmZNRUtLmee/XqR4bUurz7BY5OUsGeE8/K74UH2vgmWVLgUEduxcIrtchRaW65FRbbmojGm3mCgvRV+7UIMIhXXQ1n28sP/GA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 10:37:39PM +0800, Lance Yang wrote:
> 
> 
> On 2026/2/2 21:37, Peter Zijlstra wrote:
> > On Mon, Feb 02, 2026 at 09:07:10PM +0800, Lance Yang wrote:
> > 
> > > > > Right, but if we can use full RCU for PT_RECLAIM, why can't we do so
> > > > > unconditionally and not add overhead?
> > > > 
> > > > The sync (IPI) is mainly needed for unshare (e.g. hugetlb) and collapse
> > > > (khugepaged) paths, regardless of whether table free uses RCU, IIUC.
> > > 
> > > In addition: We need the sync when we modify page tables (e.g. unshare,
> > > collapse), not only when we free them. RCU can defer freeing but does
> > > not prevent lockless walkers from seeing concurrent in-place
> > > modifications, so we need the IPI to synchronize with those walkers
> > > first.
> > 
> > Currently PT_RECLAIM=y has no IPI; are you saying that is broken? If
> > not, then why do we need this at all?
> 
> PT_RECLAIM=y does have IPI for unshare/collapse — those paths call
> tlb_flush_unshared_tables() (for hugetlb unshare) and collapse_huge_page()
> (in khugepaged collapse), which already send IPIs today (broadcast to all
> CPUs via tlb_remove_table_sync_one()).
> 
> What PT_RECLAIM=y doesn't need IPI for is table freeing (
> __tlb_remove_table_one() uses call_rcu() instead). But table modification
> (unshare, collapse) still needs IPI to synchronize with lockless walkers,
> regardless of PT_RECLAIM.
> 
> So PT_RECLAIM=y is not broken; it already has IPI where needed. This series
> just makes those IPIs targeted instead of broadcast. Does that clarify?

Oh bah, reading is hard. I had missed they had more table_sync_one() calls,
rather than remove_table_one().

So you *can* replace table_sync_one() with rcu_sync(), that will provide
the same guarantees. Its just a 'little' bit slower on the update side,
but does not incur the read side cost.

I really think anything here needs to better explain the various
requirements. Because now everybody gets to pay the price for hugetlb
shared crud, while 'nobody' will actually use that.

