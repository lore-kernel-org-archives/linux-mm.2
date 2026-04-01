Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8765C10F6FDB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 22:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEEBE6B0088; Wed,  1 Apr 2026 18:58:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9FD46B0089; Wed,  1 Apr 2026 18:58:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB55B6B008A; Wed,  1 Apr 2026 18:58:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BBDE06B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:58:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C3401401CB
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 22:58:12 +0000 (UTC)
X-FDA: 84611502024.01.BEB1617
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id C388C40017
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 22:58:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=14jJpOkz;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775084290; a=rsa-sha256;
	cv=none;
	b=BGqCPSEc+49V7CA0o1cxCAjC1YPIQpw/cRShAmxXopfjYhHTTQ03QjML5yX1wZ8dT/gaER
	sfmdlN8hFlyMiB8IyDyrWdREuZ65lZjztFvYfLm6V9oz9K+PQgqjaYh9vTr+t/7fpcE4RZ
	ziklvIi9DBHpVHPNeH9VhFmVdY2iisM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=14jJpOkz;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775084290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Ax6OyOJPRzEIdvZhxr4mr1+8sihIRwogoJhvmOLav8=;
	b=T6vM+m/tnEQgyeXGN4gemdo6vrq9PlEA6eL8h0D94UslQzNSgLU79VX8LTCkVtiWJSBc0L
	mwkrEN0otGjPDON/KcZ25JsXW+r6kFc89gBGQloAoiLdZX2cbPqVOewb8VQUPcUrQb7nLB
	tunqORdAOBEbA0rNDhR44I+rBmABROs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 284E960120;
	Wed,  1 Apr 2026 22:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A698C4CEF7;
	Wed,  1 Apr 2026 22:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775084289;
	bh=5+AWPMRlp1YZ68UahL/4QgZBokb03f3laQhyvrJ4g0A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=14jJpOkzTzELneqtiQa3oNlQerPW00SgWQfMK4aAwJ/+X3iY3Vltwaf4Ebm3/ii4J
	 ZqWC+ptp1pWFjlQ79UuG2SFCMDyFYYOIOJIEfeS6sKkj/i7hh8aPQEwVkNKo2JF/HQ
	 rtd8+aDfeMyMPsxBnK6ObE4DrAfVTwGKtygwv+HQ=
Date: Wed, 1 Apr 2026 15:58:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: David Carlier <devnexen@gmail.com>, Barry Song <21cnbao@gmail.com>,
 Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>, NeilBrown
 <neil@brown.name>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] mm/page_io: use sio->len for PSWPIN accounting in
 sio_read_complete()
Message-Id: <20260401155808.b91597fbc3c4dd1458c6ad85@linux-foundation.org>
In-Reply-To: <a8a8533c-992a-4ac5-a387-3cde8b6e40b5@kernel.org>
References: <20260330071229.14614-1-devnexen@gmail.com>
	<20260401074753.238053-1-devnexen@gmail.com>
	<a8a8533c-992a-4ac5-a387-3cde8b6e40b5@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C388C40017
X-Stat-Signature: 8ti363d8ci9jj7ic74iwwzq68fsgenuu
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775084290-931584
X-HE-Meta: U2FsdGVkX1+mZlyhkDMZk0nrHazQMkefNuaK9OYKXYliFEyRcGdjO4NTr4b1tgeBmeKbiCaAdsYRX3JN1vwCd/gvIMCe2WN584jDcjihJ15xp+eJxvEFWlgueA4Bf3k+eu0uoJW6HCNS7hhN7rcMCpu4Q6+WRALO6Msi+bkQUMAUBXCUlB559gKO/sdK5jmR1z/gM9HkU0Io0s0vt/TifM6+P0/xtqPnHdhI7CMXUy0a4RGsxT/01In//wNfnj/myf76G9w1sVY5ny890TCpvFyMkcjvz526ja1cJGz0IHF/eO6RyfUS66WiHxEVKsByWyAEuO/rt0I5aRjU21I51B0w6nr1CsDoxEHZNMXVuGSbIszesH3UwAEqEUEv4Ruu28PSm7P+41HlTITF1AsLW5Rj1ZEbDYE3pNQF28JFcSqQonxo0hUlwU2udzdPC/LIvkS4Q7zZxKPGmahtWauz3dHK1BcFIlIrij758ERKMOxJGiRuB8KAjvth19JuBJq+C6KkeOS/Tqe+TEsRR8m2UAArFxl8mMFBxj53yx0CrfcgVHH8jDD292m7mxokMLM9uA24qeIptlWVQ1pfvP5RzLBFa5sFlbh13QsLiVlAOdjFGWFjWF92YxVVKmT/QuecoWoBohLRgJcXqwgGf+5bSj7YiJDwlRs2nrr7TueGVl1hBcesVxO+55Y+GlGG0zC/PtPYKaPD1/AMHZk2tytDA/d+aq6mdB5mBjChS29Kvc5I2nyXDzc3X0hLHmQxZfBI/DANWOCb5F9tVmzKXzn/YjLGLZ9qjdSWQ4YzWUGU6vHFz2NDOIx22FEyPa+ziKX8+ZE8kfU5A7Tun2n2geb5yf5+0oXeQ1baPUlCz2PyAYEf3urRVpr5hUgIIq6mlkPAzUtE3yaXPrnS/HnBHFb5XV3tMO3H+mK9KJHjGqy3vAmewD9hiGaLgQ9bavTsYiYVMUO3IVlj1XZogBZd5Vv
 UjSDcD87
 LCgMM7/vA3bczThBo+KkaHv/qLQ0POml3ld4IwQzIMLVC3o9ks00kgwJWdtS7te5ipLRciBYxOLsHHGUMhT+Cegs0wuTXyNXBGZT+3Jbbv/8VcNCAfpBeHXH4gk/NS3+tBVd0P81UabgscwyyBGMhM5wXDa54Z0Z0pMhJkDxRHFnV4oZc9fu/eGqNpdUBrsjKSajGC4TdeM2ChhYyksHj4HWMwbHRwzACO1itPmOgyUD31zX2cKl8gEHiMUDtw+Zz0TGYBWeQitcQQ4Jg0GZl5MWldL7dSFJE/KxA3euDH6hU1dPUgy6ctGzwVGdgNPDEn5bWTXLZzhXHTFt06FlO+6VC1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 1 Apr 2026 10:32:30 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 4/1/26 09:47, David Carlier wrote:
> > sio_read_complete() uses sio->pages to account global PSWPIN vm events,
> > but sio->pages tracks the number of bvec entries (folios), not base
> > pages.
> > 
> > While large folios cannot currently reach this path (SWP_FS_OPS and
> > SWP_SYNCHRONOUS_IO are mutually exclusive, and mTHP swap-in allocation
> > is gated on SWP_SYNCHRONOUS_IO), the accounting is semantically
> > inconsistent with the per-memcg path which correctly uses
> > folio_nr_pages().
> > 
> > Use sio->len >> PAGE_SHIFT instead, which gives the correct base page
> > count since sio->len is accumulated via folio_size(folio).
> > 
> > Signed-off-by: David Carlier <devnexen@gmail.com>
> 
> For the next time: Please don't send new revisions as reply to other
> revisions :)

Also, altering the Subject: causes akpm confusion (not hard).  But
having accurate titles is more important than avoiding akpm confusion,
so there is that.

A little "what i changed since v2" note after the "---" separator is
helpful, please.

But I figured it out!   Thanks, I'll pop this into my after-rc1 pile.

