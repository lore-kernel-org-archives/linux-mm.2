Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0412CFD376
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 23:37:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29E556B0012; Sun, 30 Nov 2025 18:37:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 275E66B0022; Sun, 30 Nov 2025 18:37:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18B776B0023; Sun, 30 Nov 2025 18:37:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0BF026B0012
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 18:37:12 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A947F13C3C8
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 23:37:11 +0000 (UTC)
X-FDA: 84168886662.08.A25345C
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id BF612160019
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 23:37:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Vc4Kzk4+;
	spf=none (imf08.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764545830;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6A6nRlbxu81E5DgNLqhZWyXWMrox8y4JunfkDrfG3Zw=;
	b=zUnUHtyNnMUkZALb2xN6r6IrhT0esy5pd1whiVDU5WWzghM7kTacE863MkJUM9/S18p3Fz
	ExgDemtjAa8YzfLk5dI4ioYSNVJX39xtPsn6dHMRj92w4QNT86mLMQwb2yGxFypG6m2ag/
	F8x2QNQjV0sMeqDXDbApoxFYu8RGiA0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764545830; a=rsa-sha256;
	cv=none;
	b=JJPTE8RFjnHNLtTbGBmtumNXNKjCsetkAfSGt9WhS/kJf3nzB3NEu5r/f8Y2L6N6+5PJgT
	Q5C8PM8LQHViB9QCyc6YXqCBoHgq72NWSItd+cPy5V/WFGsbd3n/C49CBpxYOoshmLXpVw
	kBsXoiTmqMaX833CypVZsdsvqdHedf4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Vc4Kzk4+;
	spf=none (imf08.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6A6nRlbxu81E5DgNLqhZWyXWMrox8y4JunfkDrfG3Zw=; b=Vc4Kzk4+jIE96zP+Grhjs8zm4A
	f6whS+K0GhxxDg8VB2bhDVc/HVy9YOH90cvf3N0JVpm4HOYwfT9whO8HUBQhP478rNs6HV3w2dOUZ
	uE5VZKKdHtPZuOJclMPU44XIF78AS9E3x35RhFGOCPvyEzYFE0H4zNJg/c2fEG2utFPKaQncZKK8S
	Hko9+2OL4/iaPkX/ITcipif3Gw112U7DPy59LPjllXxE8uJBmrNlPbUemzvQFRuR6RnLMVKrkefdN
	4suhWsrSALdLL7msS4Z4U33L/cymFcuvUL4ZXCOVNNh5i2137mwQH4qO0NNjx+WXgE5PcU5c5XHaG
	1I2eblNg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPqyk-000000015iv-2Ojl;
	Sun, 30 Nov 2025 23:37:18 +0000
Date: Sun, 30 Nov 2025 23:37:18 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, x86@kernel.org
Subject: Re: [RFC][alpha] saner vmalloc handling (was Re: [Bug report]
 hash_name() may cross page boundary and trigger sleep in RCU context)
Message-ID: <20251130233718.GY3538@ZenIV>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <20251126185545.GC3538@ZenIV>
 <c375dd22-8b46-404b-b0c2-815dbd4c5ec8@huaweicloud.com>
 <20251129033728.GH3538@ZenIV>
 <20251130030146.GN3538@ZenIV>
 <CAHk-=wjhgYWmSA0zyXxWr+5T5y_aLWkZLXj0i+xyhVz0Q4jL7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjhgYWmSA0zyXxWr+5T5y_aLWkZLXj0i+xyhVz0Q4jL7Q@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BF612160019
X-Stat-Signature: ptydmy9p8rxqdc6rcsnjyej1un3r5wmh
X-HE-Tag: 1764545829-179818
X-HE-Meta: U2FsdGVkX19XR78sPgNVrdnowZexkL7dpCV0o5/T1acDMdrf/3ixZMc+VcuUDsNLdmmjt+qkmB9HBr1IWg7AFVn/ffXcc8BJAZKJRBQatJA7w4E0f3Tsx8XlmRQ4RRTVyMAAKyQoc0qifvdklEqb0VoaQV1kxNtKrh0dJ3WiC70HjE7ywPMiDl9DuRtV+2Q3QlUX/0uZBFSOoygt85JMJMQgdgPxZ+MnXxNJ7W0ie0YUDrlKUSbihfUoL7mzG6Zv5/B6/w38TjbYGc3Viw6g/z95/oI7fwyFaumsFIDDcRa7YXHPmkrEP3S+7IrISJ5qK3sF8hmrULEkJlpjPpZ0fCY5Ajh3HQJA8GrMgB/35N7dz0+LCDaKbfKsuJNjUc9kql/ll9lq2ye61qsmvUt0zDhC7Hy5mwPES4Cfo9T0jO/m+aEmJY3cU7SA/Lss0U4HO542SUcjerQX0mvhPME1n4QyI7/xEe7OFw5l+ivTnD6C0UiJKY2RZ+ij2I2N9ZeOV5vlifxJzYTvuCsYMTnrCZc23ICG7MD4I5YE9uqAQrhQnXexdVymNwbEkI/9uHemmHoXHH0i2PIC3H4HgNMfwuXM9ULtHnl4vSlbUWeSC3cI3XkaoFqRBnA2f7ksCZJk8Jy8mkUs4JbOyIL4j75R74GwvcSmg5L96Nxp7onNEvIjvqBjbNAUulPpWMRmRkh609HgisHRQuIwOLil77ygp6bFV7dJFthuEVhNYuSuzeNMxm+LFsww+qrOWYKCMa7UjwegniR7U80XZ0tUtHvwb+lcjOcDnwwh+aD5WcJ2/PMoP/QG+zRYBq6/H+UpUxQHJ5dMknwzV7FWBr8iHoRttyMOkfGCo+QcT7+0k6w2Y4P05xyCyRP4ttJ1DXKEGXXtJKRdUZHTwJ3EP82e64dq2dmgFOe3cke1QzRUxzPuhKXqeEbaO1LKbiI1UcRlwoiYufrAqrk5h8+plpyvVfP
 N+2QQ8zN
 +oXgZFRH0JATj3IIEqMrEzMihdOFEctIcetVgBwGAt4Rs807IWuez+oYhXwuaO9QgqqMiWKt1rzIggWCjy/mvBSm8AbNVLkLuJ/UlyOJHAjToShyF/N7mHbP0BHDLSF/cNNB6sZakuHGnTrt+FV8tT1xiWp5xo1zxKAqcYaAVp+P7II9S/R41FOBeU6H8YbAKU/xwHAF6Tn3lXM+jPCfmPY9rc273sedcQMMlVPBThzb3NLt3vlfFgQHZwwlYCmtmQfEBCoRCFUhFmGm6bN8zZ4cq+yr9rsZg01OkouyAaZ7OuSoc3ekQEuxLMTvixMCSngGB5ZdUKEh403lTE7tZ6yO0lo95mM1eFbIEKMjZp/mXcnTY7yX0hfd/GBrdmFcC60D8Mzn8/1MdmXOTkhroNOOJ7HWmrxiThcRSl2V+f9BCgB1YbcDwSuoLUDUdLadugneXq/p5TM9nibkDoY0UCwEmDi4Y0bJU0c9TCI25DwOSXbEFk9jsNpYGh+nitHgvQ6YOHHsLt210o1hEX2ifLZxqmpIJFEg6eGRYMehsRXAAoY/YCoOR8ZBQiHe2Ruof3hfV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 30, 2025 at 02:16:13PM -0800, Linus Torvalds wrote:
> On Sat, 29 Nov 2025 at 19:01, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > +         Default is 8Gb total and under normal circumstances, this is so
> > +         far and above what is needed as to be laughable.  However, there are
> > +         certain applications (such as benchmark-grade in-kernel web serving)
> > +         that can make use of as much vmalloc space as is available.
> 
> I wonder if we even need the config variable?
> 
> Because this reads like the whole feature exists due to the old 'tux'
> web server thing (from the early 2000's - long long gone, never merged
> upstream).
> 
> So I'm not sure there are any actual real use-cases for tons of
> vmalloc space on alpha.
> 
> Anyway, I see no real objections to the patch, only a "maybe it could
> be cut down even more".

FWIW, I'm trying to figure out what's going on with amd64 in that area;
we used to do allocate-on-demand until 2020, when Joerg went for "let's
preallocate them" and killed arch_sync_kernel_mappings(), which got
reverted soon after, only to be brought back when Joerg had fixed the
bug in preallocation.  It stayed that way until this August, when
commit 6659d027998083fbb6d42a165b0c90dc2e8ba989
Author: Harry Yoo <harry.yoo@oracle.com>
Date:   Mon Aug 18 11:02:06 2025 +0900
 
     x86/mm/64: define ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings()

happened, with reference to this
commit 8d400913c231bd1da74067255816453f96cd35b0
Author: Oscar Salvador <osalvador@suse.de>
Date:   Thu Apr 29 22:57:19 2021 -0700
 
     x86/vmemmap: handle unpopulated sub-pmd ranges

What I don't understand is how does that manage to avoid the same race -
on #PF amd64 does not bother with vmalloc_fault logics.  Exact same
scenario with two vmalloc() on different CPUs would seem to apply here
as well...

Which callers of arch_sync_kernel_mappings() are involved?  If it's
anything in mm/vmalloc.c, I really don't see how that could be correct;
if it's about apply_to_page_range() and calls never hit vmalloc space,
we might be OK, but it would be nice to have described somewhere...

Am I missing something obvious here?  

