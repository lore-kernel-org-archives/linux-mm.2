Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A468C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 01:31:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD8766B00A4; Sat,  4 Jul 2026 21:31:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C63A26B00A6; Sat,  4 Jul 2026 21:31:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B51606B00A8; Sat,  4 Jul 2026 21:31:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 842FC6B00A4
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 21:31:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC428C3A7F
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 01:31:46 +0000 (UTC)
X-FDA: 84952996212.24.5F319E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2073E180003
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 01:31:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="V5Xw/l5g";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783215105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EHtF6h9gaVNf3CA52e458glPtDGJQnWrkUX2Zs49eIw=;
	b=WBOMY6ZAvOZu9bgsMDoykN59mqv4wPO9MqueId9DqY4iR5az4pLgaVOvfS1C9wp8ZJt8gt
	SJGqhgRas/4pliExOYypH/Vnyo3R729qDGEph/aNH6Td6DzsddME5lx3jbx3CmLum+ismC
	jdryeb4KqUVRlv0+XIuqhg8bcC08n3U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="V5Xw/l5g";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783215105;
	b=oUpLYxsKE3zBEAmICFktFUVwY+BdC6cQqR3wdXaFdRDtojU+lmJ3QP3Ldor6Povg6L3CcM
	AgwoXHuH5Z7vyOFomqSKujQku0U7ngcfBcSSjAByIf3XyDCYXDQniQ9nUEsX2puas5i5lj
	C7qa10RbWsPf4wLrlQT6kEAwCsTLSkU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DDFC4402F6;
	Sun,  5 Jul 2026 01:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4331F000E9;
	Sun,  5 Jul 2026 01:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783215103;
	bh=EHtF6h9gaVNf3CA52e458glPtDGJQnWrkUX2Zs49eIw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=V5Xw/l5gLPByGFI1MUXJOXOIFaXxjjlNAIxOcHZVYCEUSjznSVkh+7mt5bqIq22BT
	 +Q7LnihUoVbXWY+IcBQ0zOsQE63esJmWwg3t5Ffgq2QQn1cLWHf4x01qIEA2ROA6Jw
	 M2/l8CnOmjg4G8Vkn1v43UFFVVjmqyfkn7DGj2FY=
Date: Sat, 4 Jul 2026 18:31:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: david@kernel.org, chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org,
 ziy@nvidia.com, linux-mm@kvack.org, ying.huang@linux.alibaba.com, Baoquan
 He <baoquan.he@linux.dev>, willy@infradead.org, youngjun.park@lge.com,
 hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
 alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, "Liam R . Howlett"
 <liam@infradead.org>, ryan.roberts@arm.com, Vlastimil Babka
 <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org,
 nphamcs@gmail.com, shikemeng@huaweicloud.com, kernel-team@meta.com
Subject: Re: [PATCH 0/6] mm: preparatory patches for PMD level swap entries
Message-Id: <20260704183142.240ad7323db51d64a98c8e0e@linux-foundation.org>
In-Reply-To: <20260703174832.55655-1-usama.arif@linux.dev>
References: <20260630164143.1595669-1-usama.arif@linux.dev>
	<20260703174832.55655-1-usama.arif@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3qgocewhrggkd15cabrbb7x9g5s7793w
X-Rspamd-Queue-Id: 2073E180003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783215105-870478
X-HE-Meta: U2FsdGVkX1/LCuI3EF+SUQOGjdRyNUuk3K1yDtH7iqk8cjz9+B1wGY/1qZ+hCN0HRPOK2yvVDNOp6Z+rQb2xo0KrL1G/T4osqmPWhgFaALPZCXsUj8qnf1ZnPSugs3O45EGk/xcoM3LKIpoSVjUpNmPl45nTqQC4iz7wYFWUZQWBSeSQLn+kRlaFrtezKuEpWJgGDQYEdBnQVlt8IKcGkEStGfNPLxjvv4gbvQxFCw/j4D72R28DfJvXdkTG1Lu904vQli6nucLm62y9i7XsUhY//vyXYIeb07ymCuvKkND+P4G1w5WLbqamEdWiGaxte331fwcwJW55AjQgngzrVSzUJ4l11hapQvuxpRSGB5LAuaeVdJQeUlyw68uER5veL2ZgbnrsKpPBo+bLtD71J3XiY3mekcyeXfQHU3XD3Jq3OHFZcL4uDwojzS0ai8AUVeBzWNFTK2fnrWSAFw5Bj5+FzAXbyIohjgvH0UFKrtDlHMPjHKFlpJuf7900hxOMQnmu+9+zrMpzrgjm0v5OlNc1X18ixrDt4iZBt603yoyNTnwmijTXP9vhkZmsJKYN1rEnsMvJObmZT/Qrb2fmKPuOk83tAfqMJBgK9wBOe+O54fbcqUWd+8+X/WhF1ZV4yS6mByAHNEUU7izZ/kWXdlmEN5XjDdGJyPsCOO6LcS1ho0ZYD+rOU82RDg3ddp7ZYCtvIKV/VQa5+lAIPsssmR8aRTOIKj4AHuoBOAhCSFx7T8GOmF1PyHYzIxlSJzBDC/cBs0NKSFNM5rmpOgtM747+0Zo+eKGFEA3QxUmf12jGIoiJIY5tHR/6qT1szVVm7nleteBtO/Q6BvJ6NkbDPThI/gH4k+FJiu0udNp724ADhwDFBfcAC5smqi39XvIVMz2LEWBVx5a2ce5NkW/oWP1M3sf8/xLBqWuPKqahvi3BhsZl9JJIGrU+pU9WhIv6sFntqsEtkiVFecWlWOc
 FUBjhMUf
 GsZunvnxRdLVU5ay1pydxmVQzUTytMlBaF4sgF7i8TaCdJ5zmZwISvMC8+4q8gGBylZk2M6Woo/pQFXN20KP3aapoaI4SVrKOaHiafE5H04gPgJbtOvhPwoKPjMvhxhM6b3XhIabZnV6GK9ui0wP7agwrxdVUlW4WKJY2xqeWkGyOb9Y3OxHnD83dunsigz3o4IMe4irxOPRIhP608BvXmkf0l3r2yFoOfh+nb5p+VbHeIRLLHq+GOCCGsJ/zQKZZLDz2U5OjUiQeNgQhIIVzikeoEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  3 Jul 2026 10:48:31 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> On Tue, 30 Jun 2026 09:34:37 -0700 Usama Arif <usama.arif@linux.dev> wrote:
> 
> > This is the preparatory part of the PMD page table swapin work.  The
> > full PMD swap entry series has been split into two parts:
> > 
> >   1. this preparatory series, which contains the first 6 patches. Zi [1]
> >      and Lance [2] suggested to separate this out from the core series.
> >   2. the PMD swap entry core series, which depends on this one. I will
> >      send this once the preparatory series is merged in mm-new as v3
> >      as the combined is currently at v2 [1].
> >      I have not marked this prep series as v3, as its not really adding
> >      support for PMD swap entries.
> > 
> > This series does not introduce PMD swap entries and does not install any
> > new page-table entry type.  It only cleans up existing PMD softleaf
> > helpers and call sites so the follow-up PMD swap entry series can be
> > smaller and easier to review.
> > 
> 
> Hi Andrew,
> 
> The series only needs 2 small changes:
> 
> Removing a comment:
> https://lore.kernel.org/all/157838aa-1518-46b5-8734-feab2c42ee2a@kernel.org/
> 
> and s/CONFIG_ARCH_SUPPORTS_PMD/CONFIG_ARCH_HAS_PMD_SOFTLEAVES/
> in the last patch:
> https://lore.kernel.org/all/e37df165-8de0-4924-ba19-0d43a6b7d36e@kernel.org/
> 
> I am always torn between sending a fixlet on the existing series or a
> new revision.
> Just wanted to check what is easiest for you and your preference
> in situations like above?

Oh boy.

Historically my preference was for little fixups - so I and every one
else could see what changed.  Mainly to avoid invalidating prior review
efforts.  It's comforting to have the thing stabilized, unaltered and
to see the little fixies getting smaller and less frequent.

But this process tended to make people's heads spin - mainly, I
suspect, those who hadn't reviewed the earlier versions!

So nowadays if I receive a wholesale replacement I handle all this by
dropping v6, adding v7 then replying with a heres-what-you-changed
diff.  For the earlier reviewers and for author to double-check that
they really meant to do that.  I have yet to receive feedback about
this, of either polarity.

In this particular case, whatever you prefer.  If it's to be a full
replacement, please do include the v0->v1 summary below the ---
separator.


