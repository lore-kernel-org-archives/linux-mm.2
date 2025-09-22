Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF5F0CA100F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 23:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 573B18E0008; Mon, 22 Sep 2025 19:04:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523F58E0001; Mon, 22 Sep 2025 19:04:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43A368E0008; Mon, 22 Sep 2025 19:04:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C88C8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 19:04:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E21CD13A2AD
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:04:47 +0000 (UTC)
X-FDA: 83918417814.30.2E6DA3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 60DF84000E
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:04:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1dm75PcT;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758582286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ypj29T5bcHyqpElts2X2IdHMX3OQ7dKdyvkyWe1rA88=;
	b=4Dc1ajWHQ4KojGrSeNzL9OIE/kgG/S58VYBxp1pdPyD+ZSxWj+JmltRsvMbJwLPbK4fr8U
	7iu3AdJkfGjMIMLq2NwU8eOC14QM94ya/6s2BYo44NR/+JGByeF+Uoih8kldJ6yRb571Yk
	HSepEDi/b1ECWQTA9+8gzrxT4yG5lKw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758582286; a=rsa-sha256;
	cv=none;
	b=oyQs2M0HWd6bPLTrwLuI2IdVRYJjPDTT+kI3CZQyikk8HEvCn0289yoFlMd3/mIrerq/bd
	qy3PvNeDxSQ8E8ajPb1fi0HH8QYJf5RdsNdzpJbHQyC+kN98JjwLjR/uwsD7pdTjnnk6Rv
	QpQYWD8r6GXrM+HGoNFY3hTMejXxH04=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1dm75PcT;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DE41B44AA4;
	Mon, 22 Sep 2025 23:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2202AC4CEF0;
	Mon, 22 Sep 2025 23:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758582284;
	bh=uV1BEGwMril5Mf0IeyAdOLV9h4kg1knR4wxauKL6cjg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=1dm75PcTM0GNvvo8wLFKhZIacGv6nXR3yYxOxMiiOtNAj5M0ApnHtCXet/LFONcXF
	 ji2nZFqa7tlksRBYoJEHrP3xc4LSjX0yanqNESbjXkKP4HpEu76FhVnCIIDFprM4da
	 j7TY40fj8aHE552hd8tU1Zc6xpSMg3h/OtfFCRVw=
Date: Mon, 22 Sep 2025 16:04:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal
 Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
 Peilin Ye <yepeilin@google.com>, Kumar Kartikeya Dwivedi
 <memxor@gmail.com>, bpf@vger.kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Meta kernel team
 <kernel-team@meta.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] memcg: skip cgroup_file_notify if spinning is not
 allowed
Message-Id: <20250922160443.f48bb14e2d055e6e954cd874@linux-foundation.org>
In-Reply-To: <20250922220203.261714-1-shakeel.butt@linux.dev>
References: <20250922220203.261714-1-shakeel.butt@linux.dev>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 60DF84000E
X-Stat-Signature: r4wogt7b7s4gnayeazm8bbko7e8hk96q
X-Rspam-User: 
X-HE-Tag: 1758582286-106404
X-HE-Meta: U2FsdGVkX18btZUcimYWkIIAYozTsag5xwUduZ16d0yCApF9tsXqH4uVNNyjwUs5/LPEWRZCX2nDoEGalYElV9WEJTbCB5ar+64CKF6g06pAv20Z8MvbHcuIQ3zIeMemUR1JfJuk7+L8D5jpRsHVbcH3gCC6yIcauKAFGHWUlt57pgvFqjNMBdQIbPPkAuA3h077/3qleZSOu6kKnjthJitDGl6JmzfyKc2oStm8FlhcSIm7yNrwIkAzih5LYBeiJDuv0UXt2v5L9OOCRzTqmQmdU7BNxUPjqRXbTILA6MLTFaMRxVcG/lyleS6ss6tcB7EeqAnAIp0v5BOajF0CRSM3l/b9M6TeL87hMGLQWrAlQdJTP2k7Gd+jLIth+GRMWaIrUBE33PS+GSzw4lWi9kDqf1b2b53HGcxxA5YKmNUuwYpm+GFggINCRHCFfDEGqHvXqlFssAfnqBK+rHPcKUmWD6rrWvkI4ULMRwwM0KJot7EVItuV5j+GswO4ISgYvTZtjKwex3cMTOu5Qv2gqMuvY+Uz386nLtJvogBh2QZva3d2H4/fLAIaDxd4+iQGS0D9WRLxYlsLyRLPLloDItX800C62KJQVxibGB6cbGyY9d5lt7cbp1wUbT/eI2gX2vsUOigqybJsbHQMT0JLhg6O/tssUKvgKqWQTDVu3+npDCXbtaqqbmJyerjAZdwVGBxmOM3BsLnxInWQOI2ZGWT5LT1cUnR8fDH3pf5Jt/RnQbiq+tqMD8jwvm+xfn9Q866lxEjEpdSeTIMGGZbTt5wOZfLmhhjHOD/xNMwVBLn2nTLal5lave6KELUaQndwzDINDV0HPoVVYUc0XLkQHR2cuB7LEVQ2BagDubLgDcY7Tj3zyMYaOiBTDBU+H5OnnxRW3BKRmBQ/yBSVabzvUcXTdkcD9a1YSFtc5mlzbo3qkndLSWWDIyko/TJxai7tsSfCFgrJIBpz0EFxLDQ
 ttDZod+V
 enf8N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Sep 2025 15:02:03 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> Generally memcg charging is allowed from all the contexts including NMI
> where even spinning on spinlock can cause locking issues. However one
> call chain was missed during the addition of memcg charging from any
> context support. That is try_charge_memcg() -> memcg_memory_event() ->
> cgroup_file_notify().
> 
> The possible function call tree under cgroup_file_notify() can acquire
> many different spin locks in spinning mode. Some of them are
> cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let's
> just skip cgroup_file_notify() from memcg charging if the context does
> not allow spinning.
> 
> Alternative approach was also explored where instead of skipping
> cgroup_file_notify(), we defer the memcg event processing to irq_work
> [1]. However it adds complexity and it was decided to keep things simple
> until we need more memcg events with !allow_spinning requirement.
> 
> Link: https://lore.kernel.org/all/5qi2llyzf7gklncflo6gxoozljbm4h3tpnuv4u4ej4ztysvi6f@x44v7nz2wdzd/ [1]
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Michal Hocko <mhocko@suse.com>

Fixes a possible kernel deadlock, yes?

Is a cc:stable appropriate and can we identify a Fixes: target?

Thanks.

(Did it ever generate lockdep warnings?)

