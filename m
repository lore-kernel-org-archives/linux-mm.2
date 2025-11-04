Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FEF2CCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 22:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B1B68E0006; Tue,  4 Nov 2025 17:24:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53B6A8E0002; Tue,  4 Nov 2025 17:24:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42ACD8E0006; Tue,  4 Nov 2025 17:24:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2BC498E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 17:24:49 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B006B13B90C
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 22:24:48 +0000 (UTC)
X-FDA: 84074355456.18.24D0AE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 202E34000F
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 22:24:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=k55W2weX;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762295087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpmP2QSasD5XfVIE6tKGS6pWqnTcZZqJix+CcMAzMCM=;
	b=PVQOKqtD2wnx/KyA27AIncnrFhOIIt5JIu02aJlANQtzLj/Ckry//qXAFviVzLQ6FHGcjc
	b5VUHlz2cWMWX4FORHw+q8zZd9akoahh8uleUUgi46M+FvRncZc0VeSp7mQhiK5OtEUO6Z
	B8OJGBSj8qv+BHJCbDkIX13EJdV7Vrs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=k55W2weX;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762295087; a=rsa-sha256;
	cv=none;
	b=vQ9Q54DUuHmRrNdv+IZBqOclUBqOJV2i4py8zuqchpM3GB5dv03QxDuwtGK1ZrM7FkaS9e
	yLs+D/GAjl5dzB2p+vzK2IkRi7slxCVDDH19oJtMjPxSJPsf4aJZFr04SYTqjRwLvporEi
	fXlzus4U+1p/3GJg1sstOuBlyeu1Frw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5CAE0601ED;
	Tue,  4 Nov 2025 22:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEE9C4CEF7;
	Tue,  4 Nov 2025 22:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762295086;
	bh=LtiM9kM1E4WpynYnWVmMW5Swio+KvwnsEioEDooha5I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=k55W2weXz5QLrUx7/EGmnM9f9o1yd7C9lmRdx4eUCBvC+3r1zZjn/y3JezTbd+QSF
	 N9LcGAsObgVsQl8lbvzWuuY8/ozHgV88sYmGgMLVmlbir61lBizHUb095JnbZjQH22
	 o6/Zm0QMhqwCFQXzXM9Ru7MzXh4YHGiRgoGHxhyA=
Date: Tue, 4 Nov 2025 14:24:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: YoungJun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song
 <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li
 <chrisl@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm: swap: remove duplicate nr_swap_pages
 decrement in get_swap_page_of_type()
Message-Id: <20251104142445.47e68d38b36c81aa304b55cc@linux-foundation.org>
In-Reply-To: <aQoR0MxfITbuj9sF@yjaykim-PowerEdge-T330>
References: <20251102082456.79807-1-youngjun.park@lge.com>
	<20251103185608.84b2d685fe0ae4596307b878@linux-foundation.org>
	<aQoR0MxfITbuj9sF@yjaykim-PowerEdge-T330>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 202E34000F
X-Stat-Signature: k5nc7rxed5izpo1gew4x3f6gibfprwyt
X-Rspam-User: 
X-HE-Tag: 1762295086-400667
X-HE-Meta: U2FsdGVkX1+J4mb2S3uRefmIePT+7s02v3qNe7gsI7Dk5lJLsAa7H+sBXiODDHgVEHFc/b38y7DwqR3o+SKX45+9livv6yWyv+V3TbZ9aZeuj6eQ6LlQOgTGtNXN5ua62TvOGs1pHzNp0E4VZIPM2dp4wBywO8nFtuAfIsxgKc20atoU3LdDukEl3BkWT/V3iNNHphke2KRggT6aEJh/KC6183NHnHpvzrtCnp7Gf9LIogON2d1sRvQm3XoSpffVR5Kala/+zE2bYz4MpMw+YyIpJ/VBZh63TCevJIWyTsSwlGmyNX4dtRhL6h0MOha9G7P9gcqdTVAHVrvQj//uw0ARMrq8ifMKHSLQCruOx4dLpnk1IIswxsmt/88HF+M3lhTBUO868PDIHg/agGi9slHS4ButnCGOPYT3uRxgwFNKM/Lr+6VscIsv0der0BIDO+cLudjefSJPSNRCHMWBhUe8msaKW9FBYrW62mq3em0ekrNzeXAg8LDvcsydZkpDsu7Vm8tgyCLRPtB3s0RpGusRS0djylIWSOqLvCt+5dlhvJHBew53L9o4DcJGwQVj+hItBkrPTcQeB8aOo6r9yrpVepq1nV27krwRKMtcV8uCjtPLbXWUEyGP4l3tcaq3ZtglUSLCV6mAOdRQV2IiwBC880g5w6KiG29s0LfriMQgwVQZC/YeBfmyAiM14cJBW47asDgmf6CfhDCfvDooa2l9zcGKW8wvObOLR9qd3bxcGG+ZuHWt3nbmvDURjzh1VY7NS//yIaKuQS1D+NPX62JfaQ9Jf8R9gnoOFc2OjwYfKbtFLE9KHRpd64HAZ87UOkbJyL8s+y7gcQ2qOOg/F+Aq5P445AqqEeJNcEzELNCdgu/2Ji71g9RMvVtTw9FCMC7Uw1FysRrBWO/WwrUZKBgbtRWZWcO8JIyTM+NbFPPMn1tBbmR5+0BNGdzAPN9sh2jLb8r0ffWcAOCQWtb
 /MLakxlp
 x9JFQ7gMbey1v3LHYOul4JZxIk8DxtSSwR8LseRifmMKBl4Zh/4eW9NHBWTDw13fpWCT8s/offsL/WSO9HbbBC4w+NnEVRHpRXx1Mk0gzD2MRA3dlZjDgnU1VoEam9g3Ie8TIHQtnMoI27d8Hybf3YozBVJl7BQikFv0raD31JptdhIYGHhPYh9+N2SCX5MDR3DnD9UKrM4lw2kkoICp8h+GH5N384GtB589a+pcPcytMYtSlC6rbgs8CsV9C3gyqyEVle2shxtrmcsKvlAGneOaUN3QZmV/vQycUF45+4TUOp8IJZjhce9nSWGUMWrenP/omtDuZGfEGD4u++AjynSNAKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 4 Nov 2025 23:46:40 +0900 YoungJun Park <youngjun.park@lge.com> wrote:

> > Can we please have a description of the userspace-visible runtime
> > effects of the bug?
> > > Fixes: 4f78252da887 ("mm: swap: move nr_swap_pages counter decrement from folio_alloc_swap() to swap_range_alloc()")
> > > Cc: stable@vger.kernel.org # v6.17-rc1
> > 
> > Especially when proposing a backport.
> > 
> > Thanks.
> 
> Hi Andrew,
> 
> Thank you for picking up the patch. Since it's already in mm-hotfixes-unstable,
> I'm providing the elaboration here rather than sending v3.
> 
> As a representative userspace-visible runtime example of the impact,
> /proc/meminfo reports increasingly inaccurate SwapFree values. The
> discrepancy grows with each swap allocation, and during hibernation when
> large amounts of memory are written to swap, the reported value can deviate
> significantly from actual available swap space, misleading users and
> monitoring tools. 

Great, thanks, very helpful.  I pasted that into the mm.git copy of
this patch.


