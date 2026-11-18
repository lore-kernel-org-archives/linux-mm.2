Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4DAE606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dVUdI3GB
Received: by kanga.kvack.org (Postfix)
	id CD8CC6B05BB; Wed, 18 Nov 2026 09:56:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB07C6B05BC; Wed, 18 Nov 2026 09:56:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BECFE6B05BD; Wed, 18 Nov 2026 09:56:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9E78B6B05BB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:56:24 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 278CA12079A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:56:24 +0000 (UTC)
X-FDA: 85448540688.17.FB45A84
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 665CC1C0009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:56:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dVUdI3GB;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795013782;
	b=6dWe5NTYvcvdgJkEzhQwAU8pcMvColPU7QEfTgZbqFDPamMO4MEcndMARB/2fy19oCmWTR
	JD/Ol738mirYZM99owH7J5TOqQTRT+aX8ARb2GKcswF7sy1l+VyICZ+wcd2TLdcUVVn5Yr
	zSQHQNgXkMoHH4Q1n67R/tVDznhiNQE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dVUdI3GB;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795013782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=adL7jX6Yj0zfzxNXCqGjb+oq/ba6DVUeZOr2j2Db+wc=;
	b=l57k5yovpA9CRou+f6nEZUE612OkGj8U2Xh75T/kbMjD0AFcsv+MdF2NK7ghB2SR0XvFay
	ScG7nWDwbezpkfZe/kelnJNsBo2ilc9VVOwwiku/wWT43IGtdOx6C20rw2jNUCa/7rZSXD
	c3ID9QNDE81CHowLhDoVxwTlMsGint4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 021F66229A;
	Wed, 18 Nov 2026 14:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CAE1F000C4;
	Wed, 18 Nov 2026 14:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795013781;
	bh=adL7jX6Yj0zfzxNXCqGjb+oq/ba6DVUeZOr2j2Db+wc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=dVUdI3GBPeIX5A4sxo1sodZL/BJP/U1IngusWrZbMa/dLnX8gGi9pZQkRGLNN+mYy
	 vNJBO1FJgg3LyUPMBfZI+MWsWAdltM4aGMdqv5bRM9/PbSn4z2w3Zz99fWoPapahCg
	 5jd/xFqF+o47NFgRJ1OkXNgvAtTiAWrILVEdu2bFlOf/t3cc4eDi+yBjiD16xSCWYL
	 74cv0lIsmrQAg6gHZ0ZhMI+WmVQRGBK4kPocSy5PA4P/q5GkprGW4QpDh4P7qHpI0v
	 ibXVyi3ABfcbjYGr+aPwXZqMIUAQNHp7wHVdG89ztZIj8zmwx8X3mA3e/Ha7k+6znI
	 KbceUgizfo6dA==
From: David Hildenbrand <david@kernel.org>
To: akpm@linux-foundation.org, david@kernel.org, 
 Yuanhe Shu <xiangzao@linux.alibaba.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>, 
 Kaitao Cheng <kaitao.cheng@linux.dev>, "Garg, Shivank" <shivankg@amd.com>, 
 vbabka@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org, 
 surenb@google.com, mhocko@suse.com, linmiaohe@huawei.com, 
 nao.horiguchi@gmail.com, ziy@nvidia.com, wangkefeng.wang@huawei.com, 
 tujinjiang@huawei.com, mgorman@techsingularity.net, chengkaitao@kylinos.cn, 
 muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261110112641.1196786-1-xiangzao@linux.alibaba.com>
References: <20261110112641.1196786-1-xiangzao@linux.alibaba.com>
Subject: Re: [PATCH v3] mm/highmem: refuse to copy hwpoisoned folios in the
 !copy_mc fallbacks
Message-Id: <179501377550.5042.12629270943219413525.b4-ty@b4>
Date: Wed, 18 Nov 2026 15:56:15 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 665CC1C0009
X-Stat-Signature: o6qdpfzzcpd8xobtmo9gfx7fh6tuuiyi
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795013782-35363
X-HE-Meta: U2FsdGVkX1+9qKit6FFsG7N/Fdh2K1tOeerJbAoQYkrHHxsRdSdZzbzNm7qHW4X0Bdi/gQMgWWtMS5SJ7DRnk2laaOpxuNUqD+oyqyhvrny3CrbcyN7Awq2UQSzbug9NIeyD0t1Dk7P3urG8/25EMC2EN9uekaTsW6DKrNF+s0bU3gxBEd8ky6wf1xSJY3R4cTYJTPKrD/ft2UptPRpQHPgtz/IzWBPlJj086dccFdHcij0u3M7NcA4coh7NopkY6ZmBYOdLkcGzIN7w8sbtL4No798ejrVy22fNRzbNllHM9XAh0JaLqNgPZa+NzsOAIKCy/rtxM/sA1WIlHjPzEVNQy7Ig8kukKsw/8Fv+rGxDhue2ZTuK9jPfD+wfQcTw30ff5cKTdBvVEhUQw0bTVS0Op1k2YY7wY/GHRKctk2S60dzCc2kHDWWNUxnmLTConQvdBMFEIHftRU9/R9811XTqTk6EDR/xt/v/Kp2kulBzWRb5vabifmfScf2o2SbPJo60o7nB6XXFO+New37qmD/hPJeg/cUa2zTy8A5B9gmPKdohxVh60Hg8acwjkMQWgusrs2gOcfOXhMWBXHSKdIxT9L1tAn41MiNtrYLC5zT+1CTqiPaE3CZXFZrpi7JpFD527UOhcufMRX7ehRi9IutP52YtzSZL7Kdkz81N7Y69XnXDjiZKIFGaQEJq4bYBqaUws+nATkvm4IVyCrsPVxaQzCEHXEJ7GD4//MXAcCcZzVJ1cGUG3Bl8zHSMhK7qP/DizoeQmDYzkcHtIiL0N87bndJ2a4jKxe60VWwVhtS1VNQRGGuPu+V85+IRZgqvNTRLAqXCOgqCRmf7rkPt2f3VUoaTSt5xVsEy3DoA8zxnKBFUtMGzrNTes5qeltTT9elI55KlBFapCKB/YZDD2/LExWOq2VvPPkH9iiKxI475D+KiPDc44zrA1eghai5oN5U0wBHbD0sNAYQWyBF
 vUh26Bc/
 4tRpz9u1RHubGvXg5se9Cz1nVIXQM04wMGDlFj4EjdLg2u1tXZfoVOu0rqsdL77lEmLBLzceboeTCL98yZk9NEXYzUiZpMTiEtaXyKeBMeyTf54RUEBoOrCl0r8DWQ0WfOlFF31rj6UStje02QVHAmBkKNB/HXWUneyQPVSfr5hY26x+EYjRvBkdyySSA3ceBNBnC2AoG7d5cKIzCI9Np1EbZtVcccGY6IjSld9ADzH1dd1habJZEEBPNZZuvEcP7wx5Y9mW36Xs9g7QILEpTGnG1KNYf3JDq7fwWnffczZjfX4xvOOkDfZgEbXKcJ+7s9P9DYcjUPeAO1NkIPQDgtrW+pN8oFyZKGaFO+lG+MAwFWYAjHQRGAvxgOShGnp1XW/Y1TZlecOlybKSTitR4/v1/3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 10 Nov 2026 19:26:41 +0800, Yuanhe Shu wrote:
> The !copy_mc fallbacks of copy_mc_user_highpage() and
> copy_mc_highpage() return 0 after a plain copy.  With PG_hwpoison
> set while the data stays readable, there is no fault to recover
> from: the copy completes, the destination folio carries no poison
> marker, and the poison is consumed silently.
> 
> Check the source page with is_page_hwpoison() in both fallbacks,
> before the copy, and return PAGE_SIZE, the not-copied-bytes
> convention of the real copy_mc paths, so the callers take their
> existing error paths.  On archs with copy_mc this code does not
> compile.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/highmem: refuse to copy hwpoisoned folios in the !copy_mc fallbacks
      https://git.kernel.org/mm/core/c/35c0195e

-- 
Cheers,

David


