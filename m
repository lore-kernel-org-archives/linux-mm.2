Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 756A5D715DB
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 09:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D85D6B059B; Sat, 24 Jan 2026 04:22:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AF256B059C; Sat, 24 Jan 2026 04:22:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BB6C6B059D; Sat, 24 Jan 2026 04:22:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 44C176B059B
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 04:22:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB2FB1AF70A
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 09:22:33 +0000 (UTC)
X-FDA: 84366316986.10.F993730
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9C21A140008
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 09:22:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="jJdKJg/Y";
	spf=pass (imf26.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769246552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJIvyfyanGB9J6au1bCV2+bGjwvOLICjUu5CtLQtQkg=;
	b=PKmRl6gydmiPQPd/Lbz5S0GzadN6dQcP75Rcd4cD6D4dUQPZrlBbmJF4CiD+SMauHi26Ym
	CBrBjqvl9BnBmY0fX4QiKITtm9apfECmIToU7MKwIA4Kz2hOlmecd0PGjY1rEEIVuoO3lt
	xY1PMqe4GM4gQngJCqDB3L1E1IMT3lU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769246552; a=rsa-sha256;
	cv=none;
	b=nvvQunGFkPEXt7ZIU7eg/NQaLJLpO5XH0FWp+RqTOYr7RJkhpeaG7aB3pclgzuSIGdrOO2
	Du0RctUimnPddq6TfMzUwzDXjj5rBF+JtQguG5R0PFLT+wgYxFExXaCp+TJ1cDXU+LAUnh
	+JdXlDbn2d91VxsibisGWXFlHo4tQsE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="jJdKJg/Y";
	spf=pass (imf26.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769246547; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=JJIvyfyanGB9J6au1bCV2+bGjwvOLICjUu5CtLQtQkg=;
	b=jJdKJg/YACnJdaykw8f82QUI7lAfTu8ACkvAGoUUJv92nYDCQZfFSRTqHCtdpNSUAiBk/BkqtUJhf6vXemr5DyYQgJbJGCPV3BFZjIrgyXpBQO8TBwBCi85temLwJZEw9MM9jEkdvuy+9cfiLQLJxz2MK+dZYHEgM8dr6aMPEOE=
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Wxia0AB_1769246545 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 24 Jan 2026 17:22:26 +0800
Date: Sat, 24 Jan 2026 17:22:25 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com    >
To: Alexandra Winter <wintera@linux.ibm.com>
Cc: "D. Wythe" <alibuda@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dust Li <dust.li@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org,
	oliver.yang@linux.alibaba.com
Subject: Re: [PATCH net-next 1/3] net/smc: cap allocation order for SMC-R
 physically contiguous buffers
Message-ID: <20260124092225.GA85316@j66a10360.sqa.eu95>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-2-alibuda@linux.alibaba.com>
 <6f8de95e-b034-4ea8-a246-605047d142db@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f8de95e-b034-4ea8-a246-605047d142db@linux.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Rspamd-Queue-Id: 9C21A140008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: k9amt81bgrjo8gcxo3rcfd86zwbtmyn9
X-HE-Tag: 1769246550-699344
X-HE-Meta: U2FsdGVkX19HEDK+QGfga+4ocjjxMOADTt5jvIK7Ts7gXtt8d6wfjTTKkaLUACyKRVCiqkh2CJZATYzGAxt4uOftudLF7ZgEjMMmY+cJPLJ+z3Uw2pbojKwoGWIBQ/FFyNJmF+7fvS4WNe014ZY0rfOnbFcI+bi6LH1hxGI/SYXZf35QDaXI++ua6E8dna7y19GdvQQMNp3U1nnS36puCXRd6W3AvHznIdkFustjWvmRvvPV0/wZg23MXIdto2whKpHDgqiPjwFb48w7lnVsDxaaF5XT2opQEY1LTthU0qR0yJF+A+64DsmFuKAGmSXbl96JRB1ulriHLJ5ZjtKZToHPVUgPVm50/+bg+xgsGaY6W3/nrxVyTLmrVA0QYatrejBhVfMB4bqHqlgexOcqV93FuXYT2khDb4lKpV+kuMBN82xhtcHAjxW5RVaShgH4DJkL+vYWsso2qtxshWj41DmjOlaVUDdNbXRobzPm3UaMRR8fufHphTwvzVEA6B7qEj0jEoYSHulbdVcnm3FrKPOP+bgfdphW7j2VK5jhJYNekki/oNlZBqERqFzi5+lLT8MAlYTspJMr75bnxvk/0GbBTEFfXW3YyKmuqxyAi+uUQvRAN2sgNgSPQHqpoNC60kqP75ovhr9KQ1Of/AP4eJauUPv61T/PqA3S9xjdaJ10IL5EXM1ma/rl+p8ZKrUv1xjR0Nm8IH8m0h/2IeUT6CAVax/qLt4bKPrtqtFoGr62u3ZI3dSC2QdK3fVC7x59EM+MQ8ZGMGDIOnYRC7LEZ2/Il6ohMUDTm3zB6jQwbLAKQ86zsJ4yYXLjACmXy+YWH9jWjc0aSfyibS1EPELrG0Knf1Nywln1u6t3Ww4ewdSxyl9LYvDoTch3f4YweyPrl8CP182r+/CKq0/Yw/cZzzNbr5WSu/w2AvQREorkFqa/MzUtctjQpK8WpVZlRWQWOETj9usINhWCOpwnqTK
 AXE5VSEz
 hOoonyWOTiWuTrVWrPYvW3cBjaj29OL81aHLpS0pbBEOKiCf5PX/65h1vyLv9nE9LBOobe889MQ1jX8ST8sU6ncxgyKvGl1S2bxHHSi6X0jyXOroQnowNR6SyPo+xnPB9v52r4VxlTnrxm723fG6uYdD9ZjoSTta15WnL5Ky87rQTqJB2l01pIdwKEFrU453DhwOkZuq8BYHlUhixrYIJQ4d/A7M/svyPXIoKdY7ew7dJbdrBRYszvBNH3LuW674KFjHL3hZO7gI5Q/f4jFJaNjM20xt7ClSHl5tGop1VDfG7F50=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 11:54:37AM +0100, Alexandra Winter wrote:
> 
> 
> On 23.01.26 09:23, D. Wythe wrote:
> Describe your changes in imperative mood.
> https://docs.kernel.org/process/submitting-patches.html#describe-your-changes
> 
> 
> > For SMCR_PHYS_CONT_BUFS, the allocation order is now capped to
> > MAX_PAGE_ORDER, ensures the attempts to allocate the largest possible
> > physically contiguous chunk instead of failing with an invalid order,
> > which also avoid redundant "try-fail-degrade" cycles in __smc_buf_create().
> > 
> > For SMCR_MIXED_BUFS, If it's order exceeds MAX_PAGE_ORDER, skips the
> > doomed physical allocation attempt and fallback to virtual memory
> > immediately.
> > 
> 
> Proposal for a version in imperative mood (iiuc):
> "
> For SMCR_PHYS_CONT_BUFS, cap the allocation order to MAX_PAGE_ORDER. This
> ensures the attempts to allocate the largest possible physically contiguous
> chunk succeed, instead of failing with an invalid order. This also avoids
> redundant "try-fail-degrade" cycles in __smc_buf_create().
> 
> For SMCR_MIXED_BUFS, if its order exceeds MAX_PAGE_ORDER, skip the doomed
> physical allocation attempt and fallback to virtual memory immediately.
> "
> 
> 
> > Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> > Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> 
> Other than that: LGTM
> Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>

Hi Alexandra,

Thank you for your review and for providing the refined description.
I will use your suggested wording for the commit message in V2.

Best regards,
D. Wythe

