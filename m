Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB899CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 09:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEB686B00C6; Fri, 26 Jun 2026 05:13:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC2DF6B00C8; Fri, 26 Jun 2026 05:13:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD92D6B00C9; Fri, 26 Jun 2026 05:13:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B73A6B00C6
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:13:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 29ADF1C27FD
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:13:23 +0000 (UTC)
X-FDA: 84921500286.05.743C4EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 76210140007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:13:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NqHWXIt1;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782465201;
	b=0vvYMLt1PAHduBEzn8SZ/bnFfopU3UGDyyZD4qm+LGIgbgqX6jl9DgjryTo285fxCBXQNQ
	MRrzYHnsOA8+Y/5nxcORI7nhBtrChYO51xxMOwBoL0d52z7Ubs8Sxj9Jpop82rb1+uqAQS
	Q5pXtZqoau6J6xgdoLD5IFdEq9zb9QY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782465201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d1b2qw8nsmAkyk6H8e8vUYLLTneV7YJzYUT3m5IrEcY=;
	b=NWHdieeXC+tPQKNO+iDXVUbvbkn4xxfiCiRFqklUfcLRPgu4sAX5CnR9ylmL5dNSJwzx4S
	KWJqrDj7NCUFTU8v8jCZQf/IWNZYYdoJDvcnMUKchI4xRzmwoUZcVDmqWnlFZQYcajYOHG
	Ar4MkqRkDIqRUkTN1Eqifand1Xk8pYg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NqHWXIt1;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D1E0560098;
	Fri, 26 Jun 2026 09:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E12B1F000E9;
	Fri, 26 Jun 2026 09:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782465200;
	bh=d1b2qw8nsmAkyk6H8e8vUYLLTneV7YJzYUT3m5IrEcY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NqHWXIt1XNXOV72J7dpoxM/bEsyjBqgHPRORUORYu10G+EdYTrNj7fCD//QvmfdV4
	 FY4RlVgxenPTsc/0L1umim1e9yUPyQTlTCykNqfMtyqdu8DJ5WJTv3EoI8Cgj1aFgN
	 RwgwhmGKmv8gFXwWp/VKf/uaApMOOTJuxt805ta92Sxy2owf25sQ3JwgZjDEjy3FhU
	 6JOXGfyop9Irk3IhRNVkWVZo3UM7jmA+N/OKEN2+DQp043JIeh5XLmGiNpuW7xprkR
	 ZWwWof6Z7cI/yH4tGjwYOhPnjnvzLSQJ5yGW3g9RY6qbhhWpa6DoWPGLNYy22ogfjZ
	 9s4p8Tl5SqrSA==
Message-ID: <05c1cfe5-ce78-43fa-aa8a-e08537b8583a@kernel.org>
Date: Fri, 26 Jun 2026 11:13:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm: move alloc tag to mm
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, hao.ge@linux.dev, jackmanb@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260625184857.2193482-1-surenb@google.com>
 <20260625184857.2193482-3-surenb@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260625184857.2193482-3-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3dkwm7gbmgs1cs6n8fcyoaj7kfzahdm1
X-Rspamd-Queue-Id: 76210140007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782465201-103231
X-HE-Meta: U2FsdGVkX1/vAJGAMTkahpnExo2RsAhgNrSh6IXQiyHEKZfDPv90wX947wzhvTB1JRHKJXdo2Jm+V99DJ1pNUzkWfnVeKfXmZunomXV9/7JmgzS/z1XMQab3wivMpWnoT7NJzAphty9cAflmSTsKChPslQbIm7rZrNRc+uyeMpODqz5FXkOLf8UbzwE0p0NEvj09NdZJCvVAibYXDzl66VkuZlR3/46/XydFaX97gZAFmyf2izkT2csamJi0DgQZW9aASrxCEueJd9hY8cUo/IKxUgVHJPC4cyZ3Q6+EhS/iffNsh8aPboSyvfzTe/PQCvQhK1t9Am1C4Au5tIj7s+94rqy32DaFdOBzezsEI07GaCh6zGMl/effCYcz4yZSgm8XUjpL7ZfX6MUymEnH3YV4rNICd1ChpJTFMKVqjdwPhP4o6H2reJhiVHdtAB/4B10luDjXDtHAJVJxH85vEeS+9mtdewwFHI3nIU9hHR5oe5GDZr1DGYVhxblxrBLyCdG/D498lqnheskQhZgCQQXZ9z2igi9FnB3fIu2CCBUQW85LiK2EXLkAPGSGD7mztK0GkNJtrG8MFSsHg78Nj+OW8ER0cv3G3DO9Vb+/InQKvuFObi/g4sGeeaW0ck6CBhcHhEDl58/0ecK9LiszOduBdtRB+gxSRH2rKLZHu2acY3Wqv5Z8akNfaf7g5B+1vrr86aFxrHf2Dvoc8f4MeOCI6momfVsMnyrfRwF5iEPNCSrOc6w6f4OtkjEwlx/46qFk3fBtpeNYK7+1vWnyjb/BcbsXqWq9FWBFz3X7pnEiB7TqN2Iq79Crvmp5w375u3vmqrIq0W6TD32jOIr2EppcMuXHABrDauPC5ZeLk4AJcxmt1C29IVLk3FhNSy4muK2imitwzwWI2yKW5+ZmdpZFo4DLPQmoGfO8ixs3iTVSvE3PY955FRDCtl7GrS+uGiNKWxviJoADOmT+tQ9
 /jgXxUsp
 oa6BpqvZkF271QEatb3M+tNOscy5JYwgDx1LKmG0nTaT8IKnKOubZ9l26D2p4Al4UhsORsNgRoL53VVu1oj7UaoV+ozewwPgqQpLTV4KoMdbtwtgCKUEi0PbKUoCkXf4fyPS3u5LMKXQ/xdJ299zJD5UAejvK0Hxz/BQJbMeuBF04vUs5t57A7t83LlJAdumJ4rOx9jaxGuHJ8jqoSOJRXyU95cJrCP2/oASQZ58NZSEH4Kw5DKhiBTdRtcmHCNy2iJIBr5FLUJsMQpHrNsGLNxb6LL054qYnQout3LtMPWsUr454k2D9crI0Mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 20:48, Suren Baghdasaryan wrote:
> From: Lorenzo Stoakes <ljs@kernel.org>
> 
> The alloc tagging work is really mm-specific, so move alloc_tag.c to mm/
> and additionally update the MAINTAINERS entry to place it within memory
> management and port over the Kconfig and Makefile code to mm.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  MAINTAINERS             | 20 ++++++++++----------
>  lib/Kconfig.debug       | 28 ----------------------------
>  lib/Makefile            |  1 -
>  mm/Kconfig.debug        | 28 ++++++++++++++++++++++++++++
>  mm/Makefile             |  1 +
>  {lib => mm}/alloc_tag.c |  0
>  6 files changed, 39 insertions(+), 39 deletions(-)
>  rename {lib => mm}/alloc_tag.c (100%)

Yes, this belongs into mm :)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

