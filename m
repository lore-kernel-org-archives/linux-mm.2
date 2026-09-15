Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13432C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:11:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A9746B008C; Tue, 15 Sep 2026 07:11:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15BA46B0092; Tue, 15 Sep 2026 07:11:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0726A6B0093; Tue, 15 Sep 2026 07:11:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D54FE6B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:11:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13FA81403D0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:11:03 +0000 (UTC)
X-FDA: 85215729606.21.9EE85A9
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6C997A0012
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:10:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dQ74nI3u;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789470661;
	b=ZOrIMLkxfraKdJGLgLq5EQxBQIw1b69dHDjtNwIGWphRJ2XGUmM/jwzwglvZVQ0kIj+QwM
	YhQ61eNpY6AydGkpa6yglttyAJm8yrBSoX+q9dHYgu9IWXCxCGsiUPr7oQpiTv1v9uH9V4
	xBtRkr8uIf6SSrXXfF8Ngm40J/Ney1M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dQ74nI3u;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789470661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WPWQIQn9lzFADUkfAvG7LmOwfRtCnNUmSA0rdT2Romc=;
	b=nB46eSYTQxbcO5ES+6JAhtjvS1lue7K6/slLOywkIAG918tVtZURyoKHiIehhl/nAXBcL0
	6+XMOriQc3ZNJa1VAfhFrAyHkMn7R2OxcEU5lHmxKfvq97wd4eKgW9BsR2aQTSxnbpG7ZZ
	1pkZhfw0Xlp60A5hjNN47vLpHyK4bbI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789470657; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WPWQIQn9lzFADUkfAvG7LmOwfRtCnNUmSA0rdT2Romc=;
	b=dQ74nI3ugGP/q8WO+6UgVcAOYIuQ2hvoqoXO1Qd//a8/FdqHhOY84eJrcDf6i1Y1VYn9a7w1Ho1AKq/dFrk+sh6Nw57j70Mymrr6FcmKnLynULPB9eO16xjzvOHyZ9XdCqw8br7iLxXFVt7rpbtKkZCH3Bs2Db6pzUZAEwL6Bw8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0XB1OOqh_1789470655;
Received: from 30.74.144.126(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XB1OOqh_1789470655 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 15 Sep 2026 19:10:55 +0800
Message-ID: <8781712e-e635-4879-bde7-2109e1ef88c0@linux.alibaba.com>
Date: Tue, 15 Sep 2026 19:10:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/12] mm/collapse: work out the orders a VMA allows
 once per VMA
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260910120238.2529819-1-kirill@shutemov.name>
 <20260910120238.2529819-11-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260910120238.2529819-11-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6C997A0012
X-Stat-Signature: h7y8ykzqtt9rwydji15bngqriu66pcxm
X-HE-Tag: 1789470659-846938
X-HE-Meta: U2FsdGVkX18d2n+dgLrbVoZU1ndrA9Lh2C8DRQy4p+tM1sA0AgbdpfI8lHg47lXAG2ktJBuHZGWPV7Mqux/+aR7oqNcthauBjlvJoKceYKCo062LXlxIAO2msrfnCqftk/Egh4wO0O7JtL1hYSirTOH+EWhFprENDdArNvkhqCAWA0qdP44WtBMwPF4LTSaZ/tXfKRmHlZc/eAExidVHI3+FsCcfb8KKG+b+F5P6zLYOYePc9Z4UaUmqi7SxSyUUERulxUyi6Un1/WrcmXcq3KkSYLJxXV3UEm8K9efP9f5BXgOPGj52zL8ZX0DlAX2SED8YzWEWU/NZBsZhhBQqD+nLVwkB0EtYvZ0tszzLCfTY7Bj7vGrdGBJ68s0LzI7DCi7ovg+LdZ2AeNQ9O7JMw5GCAOcSVdTsXvh9O81reovoDPEFaEgIAyEcD7JizJcZEUdrcVUwJR8Sy6HY0N8bb9l1u/hMgm7HD8+FGRdhGzywQrVtMNxyBotokHUEth5KxjA/k+q8fKQkgpZjIL+wYKgrSD1Za9ZU+I6Y5kMlZQeof5IZRJlEi/nBe/5cVdLsM+wext3q/HT9UL6w66oiZkFl0LTAOjP5ZhHywkCz+PHlY54yoCAdf4hdJs/6EaNpwhlW3JTzPaATscQVu8n4IOn9Q4qS9PtXv4OYqS4hP+Yq0Zu9UggF7+gStcow+o5Cs/Qe/24Xb7aUu/oemUdLAEPKdKQdyVdqk/dUP5nkYvStAkY/nuB/c3xuYqRPIZEDVypZRwA39iBx4SF45PdqLOB/o/unqp9cm86b8qzBP+JXBCzSmXu8JQdfRTznO14xc8IIjJV+mU03msGiH8fjgh4qCacBydKImdCzSQvtxDx/7PEUcqB2uZBAJROOHLaR2XlV1xM9FB/12ABzgqt3hu1z7oBtNpI3OPlCThRF0AMoNAHrkLssustyomR9vfDTi7Y155y3DcTgtPVK2pt
 8jS+R7L3
 mwEPsaKVWuVkOVmy9zh5pZh1kAZfybOPbxuRS/wRk0i/2tw9yFhFJNGKCnosqqLvsqnkZL5OE1p+ptOZz1w1CYql1q4WRXsUb2QWV/qkkE/grIBSrEtpBi2SnkrgtORzdaOTY3yAraDCo/gPDH8khZJY4b5RNRijbuTCSIGjeHwX4e6n9USkrM0IHNrzNwUAwLhofRcCgvw+JIkHJ+vDV3TU3NwXdJzcjDRte3MlrSL0VoO67sK9Tyji+292js3iPiCZMRuxpsEPvth4vv6yOPqcdcJFVrefdcDSLskGwiFuw6ugdZcWj3grphGDgvkQ/UF4wK3/pErDPWOidDfl1vHBrKF3Furcn237Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/10/26 8:02 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> The scan asked collapse_possible_orders() for every PTE table, for an
> answer that is a property of the VMA.  Both callers walk a VMA a table at
> a time, so let them work it out once and pass the mask in.  It is only
> good while the lock that produced it is held, so madvise_collapse() takes
> it again after every collapse.
> 
> The mask is then sampled once per VMA rather than once per table.  A thp
> enabled knob written during a walk takes effect one VMA later, and cannot
> widen a collapse: hugepage_vma_revalidate() tests the order again under
> the lock the collapse retakes.
> 
> Assisted-by: LLM
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

