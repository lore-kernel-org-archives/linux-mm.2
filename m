Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 315ACC5AC67
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 01:55:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 128706B008A; Tue, 11 Aug 2026 21:55:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100786B0092; Tue, 11 Aug 2026 21:55:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01D8C6B0093; Tue, 11 Aug 2026 21:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CEE246B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 21:55:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4656016029F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:55:35 +0000 (UTC)
X-FDA: 85090950630.13.07F227D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 96D4F20003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:55:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1I4J573t;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786499733;
	b=5qZKrSfH+S7ThcZppJ4MqquazSuvCq9HxcSWCH+64E263yhGM+q2jlHfl09kQ+yT7CFr9c
	MwoohqlJyWx2mMkmxBk4xdUJxYtXwX0jT7SAyIBUmEdjwvWX9uSlCIWJw63Iesa6S+hmk7
	vDZd1xMuGoqlfdD7jXI2ZjwkpGNg1yY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1I4J573t;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786499733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D3J/mfvgn9SmovtymddZ07bkV2x12Gnah16+sxIHr8M=;
	b=yCJAxsp8ybNjdymuSqaqDoDngtm9rHjQhNu7Hw/6blN165eGlG3k6d36hYOFHgt0cEWCIP
	biNPHlkLbA6Jv9vd5OAN7EkOWAA5VWUEbkVXlRXtHd2j6T5TZg2QlHEubbsnB6U/B/+u+w
	er+vxTTi+NbMN2gnlr0dicqfyONhUHc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E7ECA601E0;
	Wed, 12 Aug 2026 01:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF291F000E9;
	Wed, 12 Aug 2026 01:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786499732;
	bh=D3J/mfvgn9SmovtymddZ07bkV2x12Gnah16+sxIHr8M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=1I4J573tv8JASXk3UWDq6ARUNCxoHLr3ePLtFNJC94rmbe//f/8FRzX8NwlEYc2QV
	 G7KRrTcxZJAPzmWpTfo56U8JS6iAgU7r0bZGtHpx87c9bDa1vUCC1OzlgcSgB3CaKC
	 PdqmfnrD9F3eVyWWFbOFDCzhj4EYE6Av+bFlNLR8=
Date: Tue, 11 Aug 2026 18:55:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sourav Panda <souravpanda@google.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, usama.arif@linux.dev,
 shakeel.butt@linux.dev, wangkefeng.wang@huawei.com,
 anshuman.khandual@arm.com, david@kernel.org, surenb@google.com,
 fvdl@google.com, gthelen@google.com, hannes@cmpxchg.org, riel@surriel.com,
 sj@kernel.org, vbabka@suse.cz, mhocko@suse.com, bjackman@google.com,
 zi.yan@sent.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7] mm/hugetlb_cma: Fix null nodemask dereference in
 hugetlb_cma_alloc_frozen_folio
Message-Id: <20260811185531.b8e3fb91c51713b2f29bc1f0@linux-foundation.org>
In-Reply-To: <20260811052909.475635-1-souravpanda@google.com>
References: <20260811052909.475635-1-souravpanda@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 96D4F20003
X-Stat-Signature: pxhm7d787r499s3rd143qrut94h8bf7a
X-HE-Tag: 1786499733-519801
X-HE-Meta: U2FsdGVkX19PzUBcw6X3i1dro8GoQJzrOPWvO0JXIW419LjQcbIANHY4u+A69s7AQhWbchJxpwokUtykbUuesLcev6XgGxloiRbz82ZlpZGrqyePm/MRdvOv9y7MdWzBURCra4OaliyVzPI8LfxzP+86iqDY9h58qGMyI9OXMmbNvz6N50aV+PpEj2Cq7vo2MD+exZQdNRhN7xBTMQpoLMLVKX/wOlANNg9d4S8PS4T4/reoa8Z5NRu2H1QV0Uw4ooSH77/xPCCAfe7auQ1DmWMVDhwImJWs7wVSkHBgN1AcOELdNhIC10fvfJ5v8ekFnHtTUZaBjghUgcp7aGiIw2cGFxKhw1jSA7BfNM3HcA+2TCKkqr9aQBnHo4/NObSMRexBRwwOa2V+9tuSeFRLkwfYYnWPZB7stnGw35crKZbCwZ9bJdkezVVfJfF8pmoj0Zofn2ZgxMHROSSy+cbLGwIwPHV0d90ht3pPADKxUk7sIr5lV1yf9ggVS20+5o6IHVM+Ob9CFuckbcQTP8187aaIYmgg+NSGMegXiDNa2l4BKJlCeMnm/iDUyrIBSr02KxHAb1LaJyLUm9+aejyWvOMZpA4y3blzZpSdsipFrziuM82E9LPpZW3NHTRFIhOdqD+p08xeKCGoz+IXflOwoMBsaeKNBSorjFIDbdR2sCq6S9vUxcMC0OAVK4SGi06XxyqGfGm2Ah8Al/ZtyQcSfu2OoHh3OMxSVHg+ipmtVu5iPENqv7oZD1JKCganniH/iLIUKf512QtlPjwPLoHmC1wUWLrgt7AYAqgsa8+L4OPkjOiuM9/hU0iV8BTNcEFgeXhGJCAMjc/3pk4anzPBRz8q0msVG1ugCgLyfW95nh+jAw4QqBo7/L2wJfTQtmKj2+1FbV3R3XfPQye7SsttiPbRNfwxKwd/+8tujk+8LCoth3Xa2N2bO17oYdnAIsFvgl6xv4cxL4h3jdJt3zF
 8kExpEsx
 fUzFPLYvvqfONxYMTZB0qtCQ11SNyNgxPI73bu0zB3+3skGjcyy5lQQdMAKi5+Yi2QYhJ/9r+DlK80bdVVq9I0sWtsKPvmQw2J8EIqGO8Qu6szW9QLEwR3ceuwG+MetdBUbGr7InxCEjGT8FbPpnRUXwILANjwlFuHE506aB0E9olx+L+pcZnXTOjlMgKAaDYFx/HozfJhe1xCNeg2Eb1ymco8kPnSQEsZ/Z2NJD5zoXmtrFIB4+h6rs0i0hb7otORtnatSRZJTgdmgagArNOJDIZZBoFVSCZhXOxjFdxygYpCJqO9Efpn0VC6qHvWfnC43Pi/4ZsQ2ZV/IvbpzdvX8q9XehaVaRtjknLhfdDuty6TsJnIQsmPS0pbzvBPTlG+7sm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 05:29:09 +0000 Sourav Panda <souravpanda@google.com> wrote:

> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
> alloc_gigantic_frozen_folio().
> 
> Additionally, hugetlb_cma_alloc_frozen_folio() previously attempted
> allocation on hugetlb_cma[nid] without verifying if nid is included in
> the caller's nodemask. Adding a node_isset(nid, *nodemask) check ensures
> the initial preferred node allocation honors the memory policy / nodemask.
> 
> However, hugetlb_cma_alloc_frozen_folio() dereferences the nodemask in
> node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
> leading to a null pointer dereference kernel panic when nodemask is NULL.
> 
> Fix this by checking if nodemask is NULL in
> hugetlb_cma_alloc_frozen_folio() and defaulting it to
> cpuset_current_mems_allowed. Enclose the allocation attempts within
> the cpuset seqcount retry loop so that if the cpuset changes concurrently
> during allocation, the attempts are retried using the updated nodemask.
> This ensures that the initial node check and fallback loop safely honor
> the task's cpuset without violating cpuset constraints or causing NULL
> pointer dereferences or unexpected allocation failures.
> 
> From a userspace perspective, this bug allows an unprivileged user to
> crash the kernel (trigger a panic) by requesting a gigantic hugepage
> allocation with MPOL_PREFERRED_MANY on a system where CMA is only
> configured on a subset of NUMA nodes.

Thanks.  Sashio might have found another thing with MPOL_PREFERRED_MANY
and CMA:

	https://sashiko.dev/#/patchset/20260811052909.475635-1-souravpanda@google.com



We're days away from 7.2 and I do dislike sending hotfixes upstream at
such a late stage.  I expect I'll upstream this and a few other
hotfixes after 7.2 is released.  It'll all end up in the same place.

I would still upstream hotfixes which address added-in-this-cycle bugs,
but there aren't any of those at present.



