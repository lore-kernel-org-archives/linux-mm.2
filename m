Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66800C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 07:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 515E96B0093; Wed,  8 Jul 2026 03:04:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ED746B0096; Wed,  8 Jul 2026 03:04:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 403966B009D; Wed,  8 Jul 2026 03:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 194946B0093
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:04:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 928BC4068A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:04:53 +0000 (UTC)
X-FDA: 84964722066.18.E5B490B
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf09.hostedemail.com (Postfix) with ESMTP id 45B2B140007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:04:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s6S5bdq9;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783494292;
	b=K7yVDR4ArGqgrkdESWUTyi5Nl0ofQTIqpWrIMEvIGpWAdNju4YoqyzprGvKqYX9jSRkOcG
	ZR14Vx++VAFwu+1GU0YqiwJ66BLXJxe0PHwT0vTAqQ14NVcEwepaJa7CrYXSLG+oxRT9UM
	iCKJHDxunQg4UlJVqVN1/RCceNWblPE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s6S5bdq9;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783494292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCF/5VMVj+s7tTG8SCjJp4FwBQLOszh3xeD8+sBaRHQ=;
	b=fWnYkpvgYpFCZqdOmbsZKM2WWpbbStv6kDd2UUFA3lCx0IL4Eg/Lk0thMcQBXl5Hq57q13
	Hp7ymEGGAKvj4GN+j1aZAVJb6LPR1JqzWChDyCEDnVadzKAPpTOrIs47Wo05nNfZSK6R6f
	zEaRblj0umclVNJTCz+kBIbOpcZsTNg=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783494289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CCF/5VMVj+s7tTG8SCjJp4FwBQLOszh3xeD8+sBaRHQ=;
	b=s6S5bdq9f/5x6Scinw0CfVE2GRbo6L9ITyYX55Ckui9HtVBiEpSF2FqE+lqc5ltUwzhMuC
	5OnLMsYTSuRf5LJyf9TGvOkViKB0ssb8a41Nr0SX9YQ7xQhUee/kAbHrqgR3vnyG5u7MdA
	ttoCcF2Zhb9fYNIGGlREeO7XFRk5Ai0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 3/4] mm: hugetlb: Return -ENOSPC on memcg charge failure
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260707-hugetlb-alloc-failure-fixes-v1-3-5bbd3a4b836d@google.com>
Date: Wed, 8 Jul 2026 15:04:13 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Nhat Pham <nphamcs@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Peter Xu <peterx@redhat.com>,
 Wupeng Ma <mawupeng1@huawei.com>,
 fvdl@google.com,
 rientjes@google.com,
 vannapurve@google.com,
 erdemaktas@google.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <DC666F9B-3C3E-4FD6-9F58-2A84FA17C56C@linux.dev>
References: <20260707-hugetlb-alloc-failure-fixes-v1-0-5bbd3a4b836d@google.com>
 <20260707-hugetlb-alloc-failure-fixes-v1-3-5bbd3a4b836d@google.com>
To: ackerleytng@google.com
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 45B2B140007
X-Stat-Signature: 8t5d4mgfyytbcoq9u6cbc9di6xo9upxj
X-HE-Tag: 1783494291-557843
X-HE-Meta: U2FsdGVkX1+Oavu6Dcvh78U82w5M/qfHbfNZCJpnEbe98y/8Nk60U24JJWEdlS+X8k/mFumxtdOkLMm93zgmJocZvhToqzlOWG8MHU1oquxzkY55HO4e1/pInoX6DAc1YYN/dMkCBuYoJ/t5AmaB27NDxrE3W9oqVqRObUzfqevMveNJ/SwckTADxctbLsuXlrj8feRg5rTmlglDhzmpVgSYvICuRwvtL/RsZOfKvTYIW+VkoQFzyxKOwPrco927qm0q8uEqFyu1F4MT0O2EAgXvkc0F8x4u0EiiqrifM9gm2moD70ICNLNlJXf+p/s+YUfOP2mrF8I/aPlii/Is8TTefD/Ih5qeAGQmc8dojClkkVowC117yTRuUEu6n6EyWLfOLlFjUr/0C1xMbgzRsTKopStbXfWzRMSNHX0a2MqeMYnSzjlLPLSNWSxGeF9NxzGgdt6PI2WIBiS2pZHB39z1dJLBwNz+4aR4SYSQF9kNNRE3TE/xAH15qHEfQA/q7APwM5zlUG9ufioW5mN1uYrLwFGa9TFEdGDeA53Kjh2Q6YG2qfarx7o99Jqn37fxGvoFttXu2D72xZTUujioCjzXEd+DYToxO00JfCiKZn2f9IgcPxb3xTYDf6Ub3pU86o7dTmi0FqaMZcwfLgJvJaBDG4mUZE/f2C/YAZqL5rMkuUyWqbYG73PDWS2yj94PLxKUtz7arQKBwAVcoSU8STuL6f1ETO8dqQowHI9lTkBrYg041lOupJZGahQpr2Aqs6if1zCzdJJtKSlG/MeaFbFfwzTPXgenn7j/B09CwxKilOXWF+DhmhO42c0OYbX3GCkaEUEqJMQ1CbnYCgJgu8WEM0A90IV2HqzQGZABYDlcaQa2kkcLM6noliQmBg5KQYCTtGrt9f6dvJm9znS7dotjNMdSIZTYQcPJv8xuB0lq3dgQ6E8Naq8b229hnsSIgE663KfDdg5KuO+N2Tq
 tPNJrBXp
 hZx6KH7Pv6rJn9P8R85gkkyu2dA33jE6ksAc8N2Ejrmh6CWg/F3UVb284TT+4WNLNEkGVAN3hdVX+f4OJNSXKvRvuNxSpbHZjNiRpN+V/9zx7mI/UxwJFsx0q6dsMWJ8JbK6PoQHfOVpS6Rcuuep94LaD6Qt4k16Gv83yIwOoaT3qCpN7N69ce0rPXWHYoXa910tdNv838KNXnQQkXocmj8VAIb34ll6+AZ91s7XzbKvfBbDNSLhVNl0cQlAwrRf0E2V+BAmnv4jXWVGWrPpSzGGHiGVXfosZiwyfyi1FZrajKnaGsXDZYSyt4B7xnp8RZtdsgQm+RXcbcTs5JRgorDMuPD9IzCeY0QHEuYwihBDpX4A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 8, 2026, at 04:46, Ackerley Tng via B4 Relay =
<devnull+ackerleytng.google.com@kernel.org> wrote:
>=20
> From: Ackerley Tng <ackerleytng@google.com>
>=20
> When mem_cgroup_charge_hugetlb() fails with -ENOMEM, =
alloc_hugetlb_folio()
> currently propagates this error. This results in the page fault =
handler
> returning VM_FAULT_OOM.
>=20
> Because HugeTLB allocations are high-order and use =
__GFP_RETRY_MAYFAIL,
> they bypass the OOM killer. Returning VM_FAULT_OOM to the #PF handler
> without triggering the OOM killer (or having it make progress) leads =
to
> an infinite loop of retrying the fault.
>=20
> Avoid this loop by returning -ENOSPC when charging fails, which maps =
to
> VM_FAULT_SIGBUS, terminating the process cleanly.
>=20
> Make mem_cgroup_charge_hugetlb() fault handling use a common error =
handling
> path, the same handling used for =
hugetlb_cgroup_uncharge_cgroup{,_rsvd}(),
> which also don't trigger the OOM killer and hence opt to terminate the
> process with a SIGBUS.
>=20
> Fixes: 991135774c0e0 ("memcg/hugetlb: introduce =
mem_cgroup_charge_hugetlb")
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Please cc stable as well.

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


