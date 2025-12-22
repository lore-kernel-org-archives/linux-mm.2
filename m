Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EB6ED711D5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 09:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E56E6B008A; Mon, 22 Dec 2025 04:51:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09CB66B008C; Mon, 22 Dec 2025 04:51:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F359C6B0092; Mon, 22 Dec 2025 04:51:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E2B106B008A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 04:51:43 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79A0C59353
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 09:51:43 +0000 (UTC)
X-FDA: 84246640086.16.C882C72
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf10.hostedemail.com (Postfix) with ESMTP id 69586C0009
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 09:51:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qX1S3uFK;
	spf=pass (imf10.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766397101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MpKKa58KYJutS7Ehrala4lJrgG2jP9jtqPs4wRUrqUA=;
	b=sFEZo+7IKlKp19R4XQDviewtiFTRekLwycGEj9FNLC5zgyxYibUxd3tnq6MpbGwkFdYKPK
	QLCo23ojYOXnRM3lk3jfRVfVcqmPT/fw2hAqSUT9RVFeXENuyGpA0J0f7ES9oPrlMbog7G
	ICGTiq6XwjCEvrrWLgDF5ERG7zgXggs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766397101; a=rsa-sha256;
	cv=none;
	b=yu2j/+mHoC1nrKQlT3U2grajexibZo6QMzrdx6ndbH+UhSrUKr0sWAH2GPPcZIVU97vRmw
	+5NnYZ82p2tdlsqTCj+2/8BCXrbe1b5XcEKrHxvwZ14yAJNlB478qpHGtSUIdrn7CLLyMk
	emp3emWs/trNY4LOBlBNwpoM8phrms0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qX1S3uFK;
	spf=pass (imf10.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766397096; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=MpKKa58KYJutS7Ehrala4lJrgG2jP9jtqPs4wRUrqUA=;
	b=qX1S3uFKaj9WiADQrPkN/bbcWjRhXNRjvK5F8XESDolqDdOm0Y+tHKoEkGizWNw117wpqBk08VsfNG2Fz+nYMaDZhS1aKAulADiaEOWIhX2eNmtb4mslK8B/oGqGjxqLmIb1b687YGrwGvaHjynOfnKO0MMDL+Qll/z5fJW+rBw=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WvOk2iq_1766397094 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 22 Dec 2025 17:51:35 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: <akpm@linuxfoundation.org>,  <david@kernel.org>,  <ziy@nvidia.com>,
  <matthew.brost@intel.com>,  <joshua.hahnjy@gmail.com>,
  <rakie.kim@sk.com>,  <byungchul@sk.com>,  <gourry@gourry.net>,
  <apopple@nvidia.com>,  <mgorman@suse.de>,  <linux-mm@kvack.org>,
  <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH v2] mm/mempolicy: fix mpol_rebind_nodemask() for
 MPOL_F_NUMA_BALANCING
In-Reply-To: <20251222030456.2246728-1-tujinjiang@huawei.com> (Jinjiang Tu's
	message of "Mon, 22 Dec 2025 11:04:56 +0800")
References: <20251222030456.2246728-1-tujinjiang@huawei.com>
Date: Mon, 22 Dec 2025 17:51:32 +0800
Message-ID: <87ecomalp7.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: t6gujs7khctsn9negm4skesu5xt5hg5u
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 69586C0009
X-Rspam-User: 
X-HE-Tag: 1766397100-452746
X-HE-Meta: U2FsdGVkX1+yUr9e6coxPf2Kb1g23aj/IHuMKXMHxPxW8l7Eg1DlQddpp9iRqg/f4Hs3hScoh/18dyjsGxFPFMr51Ag/7YvltGVJSMAHF9TjleSayfWMrFqEMEFSOYdM7N95DjWuI8gtJvIAHYeUhpPNNzKip9IVm9KIinQq8xrBoh7tTmTtBVsxTeH/J5NiLnH2cQ1pX62XiCMW2BK/RteN+Qid2C3AsnOn5PNoG5dZR0mPd0M9cKSQhxk7UGzAH03rckEb7H6v7q6vm771bCQoB3uj8QRyzXYg/vwRfLZncLyoYR3ngydfp4mJsL+aWYhFHXIwppcgzwYCm9wtVOJe2bGzApf5FqukhJOPmldbhqNn7ZHvGjbSP7Xg9+anV1orrBw8v+l4NTTIfP2eT929QUZHif9JG33TVpQUdU9mvJnN3DsVFpD3DKWFsp9CpRuodrVIAXaeClQtTkPeafWvyskXDcy0ZSC0zc4mcDjx2xyx/ThUTOgGWTfcVnR8plwm+woxg7Ec1GQHI3edz/GGbHcOnBSbp8B8mgim45mlnRPU/X6CGffFdu+xlOW+DzFWDIa/EBoHXVCXobdo0YVHvkjbuETKyF9X67MYW5+ryFRZ++Zdm7b4g3JWlRuyUZkDYacsnmL5SQx/tLr/LsLJXv/Xy+T46Jd1lwWDlV7ZASqD2f0esbEXWiLBr95/ahqfvJF3TIc8cs8+SjH1XPWIB5NB7FsRWNcrqztD4SHs98AnuTpYFxXq6LmDwwTaREucBIZsq9U62t9aabGtpVZh13h/zbkbCPtWcdOPl3eAp5XzBwVZTcLMktYGFG7Qo43nIA1JbvIU7R975tloPaDj9ggp+Yt3997HWCmqhYvjUdcpWcg7hX727wV+95Lcs4TogJd99WkLhiW7efuDn4acV1ElKZyc68poUwksgy8MgHM3kxyyR3eSa3JdmQFcYnbuiBbb7qGGRAbObet
 dO50Hp4L
 mRkmwpQ/5QbXDgMp6tUwWtVQzUCPQKm6yiTVvmOSSRKtMznBvnNKR4l9FdZ2zDxtbxXyIzCv0Gdfp3hekx8KmMgB3madxgz0+hdAWFWk9Wnyl30mCNlbL36uQmbJjUV8NmNCAjRLL1y9BH2umDC4cDaAUFpuUkxCsh6LDxEqurp158FQCGdLChhoYjx9EuGm8gsDu7Wt2IOmeEBZmNA3fEsUr044k9Y4aQGBAU+ZPvwDQJoOWR9CQh8DnEgrrmqnQL3PZhV/iMZvy54NvAwtP+gc4TosLq1//PpJ6sQtxvOJKUAEyryZKg36pgiqYS2KtA1mvEciAk/BREQB1TGjgQmX458lyRvE1O/7qjM0mdniJm/hfvINz6eZQVO/bMQsCb/TbTFKEiUCaSu1LZREHOOt0cjqP4l0YTJuHLyJ4CUmfXuqofyNK68rufMOo+LNle9dtN8LurL3MG6C4TgJ072J38xMMe4Ugfdvz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Jinjiang,

Sorry, I found the patch description is still confusing for me.

Jinjiang Tu <tujinjiang@huawei.com> writes:

> commit bda420b98505 ("numa balancing: migrate on fault among multiple
> bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balancing
> for MPOL_BIND memory policy.

Is the following description better?  At least, I think we should
emphasize that MPOL_F_NUMA_BALANCING is set while both
MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES are cleared in the mode
parameter.

When an application calls set_mempolicy() with MPOL_F_NUMA_BALANCING set
but both MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES cleared,
mempolicy.w.cpuset_mems_allowed should be set to
cpuset_current_mems_allowed nodemask.  However, due to a bug in its
current implementation, mpol_store_user_nodemask() wrongly returns true,
causing mempolicy->w.user_nodemask to be incorrectly set to the
user-specified nodemask (or an empty nodemask).  Later, when the cpuset
of the application changes, mpol_rebind_nodemask() ends up rebinding
based on the user-specified nodemask rather than the cpuset_mems_allowed
nodemask as intended.

> when the cpuset of tasks changes, the mempolicy of the task is rebound
> by mpol_rebind_nodemask(). The intended rebinding behavior of
> MPOL_F_NUMA_BALANCING was the same as when neither MPOL_F_STATIC_NODES nor
> MPOL_F_RELATIVE_NODES flags are set. However, this commit breaks it.
>
> struct mempolicy has a union member as bellow:
>
>    union {
>        nodemask_t cpuset_mems_allowed; /* relative to these nodes */
>        nodemask_t user_nodemask;       /* nodemask passed by user */
>    } w;
>
> w.cpuset_mems_allowed and w.user_nodemask are both nodemask type and their
> difference is only what type of nodemask is stored. mpol_set_nodemask()
> initializes the union like below:
>
>    static int mpol_set_nodemask(...)
>    {
>         if (mpol_store_user_nodemask(pol))
>                 pol->w.user_nodemask = *nodes;
>         else
>                 pol->w.cpuset_mems_allowed = cpuset_current_mems_allowed;
>    }
>
> mpol_store_user_nodemask() returns true for MPOL_F_NUMA_BALANCING
> incorrectly and the union stores user-passed nodemask. Consequently,
> mpol_rebind_nodemask() ends up rebinding based on the user-passed nodemask
> rather than the cpuset_mems_allowed nodemask as intended.
>
> To fix this, only store the user nodemask if MPOL_F_STATIC_NODES or
> MPOL_F_RELATIVE_NODES is present.
>
> Fixes: bda420b98505 ("numa balancing: migrate on fault among multiple bound nodes")
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>

[snip]

---
Best Regards,
Huang, Ying

