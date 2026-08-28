Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2FC4C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 06:43:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 105E26B0095; Fri, 28 Aug 2026 02:43:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B6556B0096; Fri, 28 Aug 2026 02:43:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE79C6B0098; Fri, 28 Aug 2026 02:43:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CEADC6B0095
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:43:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F27712028A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:43:09 +0000 (UTC)
X-FDA: 85149736098.04.41CB06C
Received: from mta1.migadu.com (out-226.mta1.migadu.com [95.215.58.226])
	by imf15.hostedemail.com (Postfix) with ESMTP id 40A26A0003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:43:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iCGNMliT;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.226 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787899387;
	b=TS6fMVyyacxIGNH43Xci2dOm6cRRN5FkLF/XL/SJBCwtL4ARBmd/XoxzhQtgekYXhrstKF
	/WSDErcaK195+nkZ7aS850d4zW6DfPprQc8iUsm4fcqjXqkdvGzqkgqXpdLbGG8h4Ks5Tf
	JUq5kP4Huwt7EtiyyL3uGjFpd7sTsQY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787899387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZNtfx6agBLlrPlpxeCsTNHpQcr39KmjAna38UvE7dEs=;
	b=l3J22+eP7aTtI+p9bzPoVLADVAjv4u5wq2gEzlkgAXh3E7MJdQSpdPYUOf5voAeKP8TJZP
	e/O0Vq99QQ2fTO69br4pCCYcrB0a5yJbuOjmqT2b4Gr17uKP1oE4cNhjBtOlD8BHEQsBZ1
	3PgtG/psT/c0rym80bBhTGXl7f2AFPc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iCGNMliT;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.226 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=g/7QNbYwvj/vNshzviunkxO3++t5btxOR6mdxsQA7QE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787899386; v=1; x=1788504186;
 b=iCGNMliTQO+EGzy1Qjr2EwriuAOmRsWF2onNxff6y3CAVXwGZbkI/vS1LRfTACvaZtXIixIT
 9ma+xAroIntzA0iI+clBj+0hf5NLYccQ1B6e0pbMLXGbknWky1dzyuf4mbWjy2qigh7naEyECJH
 L31sQXtLOQbyfAH1Ukq9ZdH4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 687cbe4f83213111;
	Fri, 28 Aug 2026 06:42:55 +0000
X-Mizu-Trace-ID: 687cbe4f83213111
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2 2/2] mm/hugetlb: warn instead of silently bailing
 gigantic pages without runtime support
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260823044118.1097121-3-xialonglong2025@163.com>
Date: Fri, 28 Aug 2026 14:42:37 +0800
Cc: osalvador@suse.de,
 akpm@linux-foundation.org,
 david@kernel.org,
 mike.kravetz@oracle.com,
 mhocko@suse.com,
 linmiaohe@huawei.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 xialonglong@kylinos.cn
Content-Transfer-Encoding: 7bit
Message-Id: <2EC70FCF-D812-4FD2-9172-F2520FE931B2@linux.dev>
References: <20260823044118.1097121-1-xialonglong2025@163.com>
 <20260823044118.1097121-3-xialonglong2025@163.com>
To: Longlong Xia <xialonglong2025@163.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 40A26A0003
X-Stat-Signature: ws177o79hxt3s6hw3fwgcjo6qwz3rydt
X-HE-Tag: 1787899387-589535
X-HE-Meta: U2FsdGVkX1/LKHWSAi5iPDtDkJVs6s/uIREkw0AeRoKquWbqc3EWL7UcnR5rHI+pShPoMy0+saZb6uHk6MqjXoScdorrIoTo9ivYsuRo+Djy8aDOL41PqfNDwnJZm7WBVsBSFwT1PRqMCeeiRqEzxQ5UFZBLgm+sFKKs2vEDxGpM/8w9aPgD3P1uUu9ttSp9gVNmg5cI9tUGEWQET5StvrttJI9jZ1ijLSf6mooEBLPtu0LgwHn4I9d2a1QPPy45+c3CGbOV1MgqjoDHyGAav6MN/a/kqfKp5YIcgKLpwlVKs783nwRic3Oj8/yQTEddBfl0Bvfi2rq9LXzHqD2/ahEAfe4h1mKaE6uV/I/hMazfnRmyU0nUNlgGYs+T++E6l4wNkOAVxnALLtgnUjhya4HQPyYU+DSrYYAFfNYFiP+FWG9iYYOnAFwZetPhtp4VBUDKIEJTGmJtetQkknCH2x1XZKWP7j8B1LONm3JYK6TacKDmKcGVN9Qoa9MuSclY1YY1GnjpwTGL9T7Lherz+mR5wZwJ3Lx7/Zv/Jrzw5CeGrxDpsv2UuePK/UKXX+0yM8THWS41ZVqy8gFGTLiL9o7R92FYvGkTUyYC/NMmjU5XvAcA34LdAeeYnwjE7Jo4McFAMvXXBq79Fa/Exy678yIq+xbUQmOzINIKOOKwHk8IrVCLT3c7/ItE3s6V+X2XgieSlBXJMZg5SfZUviFcGKETGdvrZzza+QXoG8uCSq0VFCmJGpwDeSjlqRNYbzaogukBzzjH37xopoRq0Qx3GkPjHztgeNHJfAex/O+n3/IKfDeoKTveIy0ImHfsOyYPd+PUl++8uxCE1og5TA7X3vTlebgFYWha5E/PxBGpc1hujFkHufFVwLFVr59bJ3UT3L55PVp/gytByrhH2M29BNOqoYRVn/I4sutaXpl3PWQSNvcrHeTvIDRT0IZJ3yvr5aa2oie1yAfwvC/r0fF
 shzU574d
 XcsgMc6g7hMbQ4zsSH4ILjgGrnEiARz1aXXMZqpdZ2dSQOavEtOjH1y/b2RfbxzAvQpvoZO6Bi0VBerwsGVIfCNKwtCvmU5rnsgi0W05WBpXz1br56vpp+W5oCi0+cxhBtPbJMvlTx/qQwUOWnGKNA0J5ONl0TSe663k3UV+1IEdIAE1I7rS31q+ToAFMEhSxSuKAFNOzqFogAwxkTZWcjnqhUo2c9WxJmRMAAPGpmU4KBnJ8ikDc8Umyvb/Dp24DngT+p4lDO7pYnrBGSkqotKtKvcDzlhwvVnv3Z6UcWdKPLrfURW3Ky/AL0j1dBzQdMABa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 23, 2026, at 12:40, Longlong Xia <xialonglong2025@163.com> wrote:
> 
> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> remove_hugetlb_folio() and __update_and_free_hugetlb_folio() silently
> return for gigantic hstates that lack runtime freeing support. All
> callers should already filter such hstates upstream, so turn the
> silent bail into a VM_WARN_ON_ONCE to catch caller regressions
> instead of masking them.
> 
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


