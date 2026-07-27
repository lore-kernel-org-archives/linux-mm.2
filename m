Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA364C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 15:43:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C38A96B00D0; Mon, 27 Jul 2026 11:43:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE92B6B00D5; Mon, 27 Jul 2026 11:43:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADA636B00D6; Mon, 27 Jul 2026 11:43:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 843F66B00D0
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:43:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1206AA053A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:43:03 +0000 (UTC)
X-FDA: 85034975046.30.C779814
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 558A4140009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:43:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K7bzdiTw;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785166981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VuYOh1JKwZ2XJMarHuaV0AoNXdrVbwJIswnBoRs9oyk=;
	b=ZV531DFG3WuLE1uq8RgIleNQkRTGjS76tE6KekHaXEvA3A39Xuo47JMZr2uIgCbJobpdr/
	l0KzAs7LP+dQE50RkLtsamuLK8jd+imx0xABpgaFyMvSKGQ40GiKVFCmfaWrPkpIwP4jFm
	wgYkLJpxK2KNsD/bT/HgHllZZwPGyYU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K7bzdiTw;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785166981;
	b=bhqHpXdIdfvinjt+a2/0Yd9WalaC0DzBiif05wqMcRsaqM1WflVGPgIDUCSq9/NX8elEJW
	qIbv8M35ZVODffFGFaJ8w+Ux8bk0/5YKjAmXoZh90g4B4hm1fXmwq7yvmafM4jHiN+7sxt
	KXZIXIy8Byp1+aZTLROuxF1ierTwVsU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 318B841A2C;
	Mon, 27 Jul 2026 15:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450BA1F000E9;
	Mon, 27 Jul 2026 15:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785166980;
	bh=VuYOh1JKwZ2XJMarHuaV0AoNXdrVbwJIswnBoRs9oyk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K7bzdiTw7EEiKbDzCDfYrSNyDSx6kn1yiNvjDY7+aZLe3pToRFzi07hyIYh0136k0
	 nebhboEwxLm1CD7YDveJKi4hMxT8w9F5PR/5bkgxu5IEunRgik2BNNBYP/x1ZcL7j9
	 m1Fawbc5GExHBr+Gql4l4MwFPprf/L0SiYGdfLwl+XAesdtCKIoywZ07X6ifgFbvQm
	 8zDR3zkDcJP+ANGfQj00N5CC776nw5PvkeTxEDKZHIsn1MOOYpkIMdmcFjCZ0UQRmW
	 frBIvWjhkSU2wjVWnYjES2iqXjGrfrV+lpQq/496+XtQlc1A0LOdaY2mCxuMPEWEkq
	 IUfrJIdBf5tlw==
Date: Mon, 27 Jul 2026 16:42:43 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hengbin Zhang <uqbarz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [RFC PATCH v3] mm/thp: serialize huge-zero folio state
 transitions
Message-ID: <amd8LmZdA6SPMAtE@lucifer>
References: <4146d4f5-c8fb-42cf-9dc8-a9d4c26055da@kernel.org>
 <20260727154001.4102341-1-uqbarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727154001.4102341-1-uqbarz@gmail.com>
X-Rspamd-Queue-Id: 558A4140009
X-Rspam-User: 
X-Stat-Signature: 41c7jmpbnkkt7wspxpt8qcmssytiiqof
X-Rspamd-Server: rspam04
X-HE-Tag: 1785166981-350101
X-HE-Meta: U2FsdGVkX1+6+GGb5KCgw0GsjO44MYg1SABjF9F3907vfWRtRx/tkkpjYmnD6Zrg25R/U1Zv+CbZvLgcvSV2Osehv3h/CKnnnhM9q465yn3rVH48E3vpN3/qZsMUwgLGjd1jP+KNoGWxA4daTRf07CxgDOThwg0u+HzPqr47qmsA/2JJ7ig7RlaHQYCecVHTEiJY2ovKrB1G+CJEFDp9DG1WsIb7bfSWauDvYIkmOztUURhGYmy1taa4GmxOqYb8jxXd7qMXJToEdfw+6z9DFBEBTcWkw2HO9mxCt9fVf93xlMUoXmvbds9IrsSAyckJCVo6NfloZqgMs9DSJKcEcAGlBIPmsIjnNrothK+dSq5vMh9Ma5o1okzb1/1vJrRnRQBz+v93LPyA8zd/lRj1Xg10zmNG1jojnxTUkN7N5ZmrFSAMfF7JKgqUHdI9GUJRahSIlWEMcMUZf58FRrZ5f+MktVJEdxWGijKOjbIl+Z4iTbfjgnX8dbrZ4UsO4cej3QmBg4HR+5c96XYsyByM2KzLlyPV4kyx9sgH87oH0PDzheuESM+Uyay9DrMD2kcbKUEELeQxmOMBhIszT+PG/behy89RL9np5JpXMjpvLAl3YX7/J7FIaSFDosbzE/AIHQ2r2bVEm6yZrV8vsBa9x27RV+009PKpYnthmWrL1hGmfLtplG1EmZiGcbMGekdkwj05v9yNiHA08ZJglpViDBzp5zPPL2pqV2oJ70tADcYxmmGxZGsrpJuLkMJTYU9cKufdt/7R9LJ+mK6XYQoURFI3XVThOgkYXBLAk41bjMrIoBIVe7DctYGT9lHllWBNAVOgWAUNxuVLFoptsxBFaeG23hQ+VEzbFIyUAMIx6Y9AJEz1Ls0a/jboladhrhHd8KH/jQjvj0N9NmG7Jf6K3vbE31dYpkNGaiYAwF5z520irla9FPZquNMa2BeCScws/gIJC0llTBCHglLrrBM
 5+dcW4nu
 tAk41NghVQEq/fLSFvcCZjzF5C9mKDXuRNrc/NeNWABU6t2uAcehjLMXyKtQGFC+xigwheyFbiQ6+V31pwPVcCphVlgvch0U4E9eY7LAHr2t8Imn5mbmulGPhDoxwNlRe/YPaNATuL4R4jN0PyDlzjXy4Y+dE32xxlacrcX6LQei2ZAz1pSOUZUgawKLJ3kP0uj9F6vDM5LsK+3maDHsBImBC9tp5CzUTUWLus3rrpOOap9A8X/98KCr8UGsrorBkNpNY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please stop sending new revisions in response to review!

Respond to the review, then send the new revision as an entirely separate email.

Also do not respin this quickly, leave at least a delay of a day between respins
so people can have a chance to keep track and review, the workload is high
enough already.

Thanks, Lorenzo

