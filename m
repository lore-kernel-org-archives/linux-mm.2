Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54F4B606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VWFx9/ql
Received: by kanga.kvack.org (Postfix)
	id 71ECC6B05B3; Mon,  9 Nov 2026 07:44:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F6C36B05B4; Mon,  9 Nov 2026 07:44:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60C676B05B5; Mon,  9 Nov 2026 07:44:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 42EE06B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:44:03 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB54B1C3F99
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:44:02 +0000 (UTC)
X-FDA: 85415547924.20.F380C6F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3BCB640003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:44:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VWFx9/ql";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794228241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9WF7SN6lbeuFA789rbuEJdyaWPZuqzeKt74v1Wc17ys=;
	b=mfJvbe6TDHYfxd5T+j5x97tyFcqw5Js7YoSP0qQ87nvRwPmrdA7lhjms50466/kRjrBU3Z
	q9KuZMJu9vBGKwH+8AQk8abKqio8hH7xEXt4gBR2vSQUH7hlxLVBt7yBWGNM2rFeCUpWUP
	rXhs+AZrU+Wfoq/6BSyVVaisXH3exE4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VWFx9/ql";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794228241;
	b=biULtq3fT3GK+X3PV8xurT9INrRHvweO89NUBKxOyGesZPTT7j+XZ298txF4f+YC2UAxNR
	BNNqSsTZTpucXrwMtTaUV4iY1yzTxKv3QXylVo7/yPwS7xMG+iDsEFv+pmYAxa+vwuqV0f
	AmCTWSnehf9GRKjko5WbhyvGCmt637w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BAA142E2D;
	Mon,  9 Nov 2026 12:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317C01F0089F;
	Mon,  9 Nov 2026 12:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794228240;
	bh=9WF7SN6lbeuFA789rbuEJdyaWPZuqzeKt74v1Wc17ys=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=VWFx9/qlUoVvodjLHZolX9Ee8Mev/BXauygvqmz6hz45TIE8/UUW/zLKpKV8G9u33
	 /sjxNzJfUsXDBC553xd+2mi6MPEIeTp7A9JChYrlXm/CvtsiavZnjEyBXmi3tDcFFS
	 2aY3uSA2bCuBywUTCnv1e3s6l/ZuVgWsoUNf7r/4Mj7z383Lzxk2hJRcGeWCwYOQ82
	 MkacpiyQs9DQ3sQt1JGWISYJqjobt/9dkeYG07q5NJnPtI3oIDNnZ0+kPxQjaadeUL
	 vKeXg5miig1/6BMpFK6NbxRAnlziyoYDFQVWK754jMPto+6nn8Wv8J89pHUhS/dGe+
	 pldbWbKclFuuA==
From: David Hildenbrand <david@kernel.org>
To: akpm@linux-foundation.org, david@kernel.org, xu.xin@linux.dev, 
 chengming.zhou@linux.dev, liam@infradead.org, ljs@kernel.org, 
 vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, kees@kernel.org, 
 ziy@nvidia.com, gourry@gourry.net, anthony.yznaga@oracle.com, 
 linux-mm@kvack.org, Jinjiang Tu <tujinjiang@huawei.com>
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
In-Reply-To: <20261106013906.2229780-1-tujinjiang@huawei.com>
References: <20261106013906.2229780-1-tujinjiang@huawei.com>
Subject: Re: [PATCH] mm/ksm: fix ksm_exit() deadlock on exec error path
Message-Id: <179422823590.6074.10687799085993242560.b4-ty@b4>
Date: Mon, 09 Nov 2026 13:43:55 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3BCB640003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 44prk5jrf7yqttk9mn4xkeh59moyoyge
X-HE-Tag: 1794228241-807338
X-HE-Meta: U2FsdGVkX1/JL/fsbcTniJIzZZHFFG7s3UQawiPtQWbYW3JBAxSpaw8r6U4uJ87uMTuZNx4Lz2EeBvGB5npeZsiO/kLO7YHBbutaGoY/ifrATCmLR28xjxTNH7UNMbwrvgr6TN+hu7u/6jQ5Z/+/YoZztN8xMZ72uPW+SoBKUE4AQAxDpLOraHGP5QKf21uGuIAChJV3x/BeiRftA4YVyjAXa7kynq5vGytWbxPP+7BlVl8Mvm2TuhMVdO84eSANZST6nOl2JxBF1Qyyu33wf9YYLO8RSaa+PIsf2CP3qWatrrJV6J+8Np2o1ys9tKbdeUebTriYa+iNlQFwDWIYUsOViu0Z77yM7FD7pDq/cVSUCxsm+/D0Vau2f+YjUKZaMeA8hpG/3gGtYTOUpb2rvdFDvh0b/UdOFWYmh6oDq1Sd+JB8IMCpfGYgDTe5ldzCH6Gv7Oy1w/m04rYp+oXek1qZYHxsQ1b1IeW/plSONXi0KckpDEFqcLAZh571gPrseHSJkwvhhNgYC0sI7XtdNdEZcYhmnp7x0+zZ05v9NY7Y/CgzJRKKS4tln58cuDZNMlQCvL0yeWGEQa3hobIVq3BTjkwGYtpO5Q7nvIlKCyNU+joKUEcJQbLzAAq2gCsyZXaEQYR7DeZcCeOoYuuqFHXsekCz8xbtzF+KvhaIIIDM7Et9UVPlvdgDGpUnWP3k36hedGwZ+OZT0tzIaFlxzJIhaJ5uu6HdnPiAdye2IvNtjEM1t8yxuObjAg3UnXXLu+8s0607PQmcj+gWVMapzsC8HDqUsyt3mFVf3jRrue0mQzvZwxztsxD4qewYeQpquq3EeiBFAPT5OfZz9q8v6l6WS+wJaiqNZiHHL3O4T4NkAbrZrUveXV50Ytg9THRt6c0JbgPYoa5aCRqbhFSnmE82ZgbAmreBCzfxp6kl2ID6v9OzHEBvE5LWdPKHlG85ozX3UFHM9d22EqgFGad
 IaB7lWGG
 W1WT/c0fEOo5OrVRhBSFVNeIZrCi/5+uWi9rECF9kmKIOgvTE4NZZeJPHp9yWj6dwcBizAsPUE6N1HwNB1vCjwV6221rsRLU2zNmEu8Xg/L+PRoyTfsoDDopGWiVi1p0ASg6mhhRTq9VyVEVHfh6mqIj6s69kHIjFqhZ2tW2VyzljXkDTbZLER5pu7nIhtyZl1a+6k6XQD7OCKJ3s8GVoC+zLWDVwotxbCGstt6mdGY0U/832byHyXGxgkzQ55XpTTZjdIxVBiEt1gdsmBFwg2Nx9DmKkl0oW+/+V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 06 Nov 2026 09:39:06 +0800, Jinjiang Tu wrote:
> create_init_stack_vma() registers the new mm with ksmd via ksm_execve()
> while holding mmap_write_lock(), and calls ksm_exit() before dropping the
> lock. When insert_vm_struct() fails, __ksm_exit() takes mmap_write_lock()
> again when the mm is ksmd's current scan cursor, leading to deadlock.
> 
> The early registration is no longer needed after commit 590c03ca6a3f
> ("mm/ksm: fix exec/fork inheritance support for prctl"). ksm_vma_flags()
> calls __ksm_enter() when the first mergeable VMA is created. Remove
> ksm_execve() and its stubs.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: ksm-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/ksm: fix ksm_exit() deadlock on exec error path
      https://git.kernel.org/mm/core/c/fbcdf9e8

-- 
Cheers,

David


