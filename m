Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96930FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 13:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C7906B008C; Thu, 30 Apr 2026 09:06:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09FA56B0092; Thu, 30 Apr 2026 09:06:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF7126B0093; Thu, 30 Apr 2026 09:06:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD29E6B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:06:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7AA961A0C13
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:04:48 +0000 (UTC)
X-FDA: 84715241856.16.CC8EF30
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf13.hostedemail.com (Postfix) with ESMTP id D067920014
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:04:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WsjyOm2h;
	spf=pass (imf13.hostedemail.com: domain of li.wang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777554282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uDExBGJ1iHFzE1+M5f2gg1Hy6mF0tMQr+a7AadJt5vk=;
	b=lN67WgkjEBDdQhzuf7qpPAZigQ+Qj4WcDinzrpcYIvqfDjPgVs8p0yppk9+CKKEpuw80gv
	l5pl9GSojQolyFpaSFnmMJh57/id0ZRSvO7boX8otubEmsT5F2Bg2kiHqej/RvOSxHRUVx
	WhfknZybQjtWucIESiml+D1ZtdSQUvg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WsjyOm2h;
	spf=pass (imf13.hostedemail.com: domain of li.wang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777554282; a=rsa-sha256;
	cv=none;
	b=llAJY9gtHEHYpRbnbDcggoHBLUkHIsAF8htQlpGtbdY4LmM6y6x6M3A3UNkc9Q36Y+Nxu1
	/Cl3VMEOy7UDy6fxehukVoT6B4Q4AVOnOg4vzQ1z3CSh9rb3BqfSB+EdInvME//lHLuwLJ
	6Jy/Lq2UzHfnRcj5gqToDcYMBrQIXto=
Date: Thu, 30 Apr 2026 21:04:30 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777554279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uDExBGJ1iHFzE1+M5f2gg1Hy6mF0tMQr+a7AadJt5vk=;
	b=WsjyOm2h0YAycZDR5kiNh/spTi79Rzyrar8FrMDPTk1dG9O54ia+/wp+ub+W/WB0OC5M/L
	mwmMp+cZOf5su/zNIj/uXXEGdP1hZ0fJ+mHedReUpuXBPmTiuwgLlmTsy2edJFuUciNVOo
	RbFNXMnmYzUJKl6f0jGtWn2GW+mCdQ8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Li Wang <li.wang@linux.dev>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 01/54] selftests/mm: hugetlb-read-hwpoison: add SIGBUS
 handler
Message-ID: <afNTXvC_vXnwkNny@linux.dev>
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-2-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428204240.1924129-2-rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D067920014
X-Stat-Signature: uot3chbwqd9h67hjx1hjixs8ayd84j31
X-HE-Tag: 1777554281-676961
X-HE-Meta: U2FsdGVkX1/iKSV4sbwLL5sFjb0tZLwL+g9bgCpccq9+cBeuF/Ue91dbQxsqVASJO3uDPY8lswtUTpIqnkiy0r4EqxrDtKnuj3vVjTx80ND+hP3COiFhCVHLU36/+B8fHI1ByuTR8s3iF90nUM/j9TmkAowkAXG1VGwWqdVgbvjiJ6aDlvLjhR08vAksfFVhyaF8nzXWyauZ5QAOC5TP40VLd46QD+oZfhfzkIva9uukk+cfcYhOOQJhqJqAysLOtzVM2SllSS0yqDzsjKKZUkF1sQjkX7Q0RN1IKBF7+EBO29AP2kenz4EgMj9hXY/MEA7NGVQ3jhqHIu3BUBwnnndTs00Wh1UE50XAqv5TJM5vw6gRWnpp2T9u+HFzswQSujfal4T30inr22zVl30XVVwdGoJgsGfUHLq8eS5m9KxWhE+qu0dS9nAZ9wWOfRpCDoTfIAEsQ8nljb1Jh3B7xyjzxMu/dCsJBEl4dli7TpWoGd6eFNrWxvHZYLL6lg6wmKl1icoKVmbyukmWviGDqZ8uAVeUlU1+5aXDPvBypgjZ8Nq8vgtH4U8XTIHzrd2R2LCbLlDgGswrc9OY8Y+AscjQJBSuOk06cAP/hmOOEcud7IDD0Zxan4WE10TWw5h9Mzmj5WFkN5jijf8v2lvCLLGg46+6XPQnfg/sv6Z0rht0npFe5mOBzYgi3EEMh6Gq0sXR5Luc5cNscJK3Ln8tRdxzUPsWew2vK6yTsT98+HFOA4KN8wcR4BzuqmCfZUgMtmS3y2H7GnMI6+LnOGluaz4WdMkFFUeHDi2Wmx6dGlrhLJ9Bw18BIqifVaq76YJZVw/+J3DiHzI82K3Ii2ksksVkzhEY2iXlYQAjNAdBnh1mGZGDl/7xdhppXELAUD2tTsN8FKzJzLsJmbPO0Fd4t3H/YTi8CQ2auFRYYkMXpRy2TPv2Aj4zAzWUUwG5+K11oDCbJz3nb8dIQTu8inz
 zQZ3OqnC
 rv3uumI667IzgxY/9+k7LJJErrg9nNHC67fdUvy7Lg6l/PjCv9UNhimKm5yqNK0FgJaNWgxd07M9R6d7PaMErBqdWUcppUIib2Q2R3UxrcX5XDQIBVfut9V+2DUvNB4jOeD310m7PgGkRMOAZzLl1gBiQwjLNDcS/DY8uXBwZ31H4pUk1EnJ+vPIcQXxJctb6N9mRVhp/43vVH1YIaG5c7YwJFsOCr2lLlAQjTKta60PfMl6RgXQUnFcI/0y7YNFautFrj+Mskkkmv96Tesmlzrhr5xnn7zo4ZqZw/8y9iZuxIDY/ErQ0ScSKkRAqVLzDL9lT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mike Rapoport wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Access of poisoned memory causes SIGBUS, which terminates the
> hugetlb-read-hwpoison test prematurely.
> 
> Add a dummy SIGBUS handler to allow the test to continue regardless of
> SIGBUS.
> 
> Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Tested-by: Li Wang <li.wang@linux.dev>
Reviewed-by: Li Wang <li.wang@linux.dev>

-- 
Regards,
Li Wang

