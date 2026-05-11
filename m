Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E14ACD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D44FD6B00BA; Mon, 11 May 2026 12:53:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5326B0154; Mon, 11 May 2026 12:53:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEAED6B00BA; Mon, 11 May 2026 12:53:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ABA616B00BA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:53:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5CE4E1C001E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:53:10 +0000 (UTC)
X-FDA: 84755734140.04.75BC907
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id AB34720009
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:53:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ajJF1xjE;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778518388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/g8BO9FwD/md1Wd0joobDIMXZvGqsqfS43QpdDnutBU=;
	b=u1c/qOmAcQ01X+99neh8wlcQa+h2fLt2wdEbqic9WTdmEylLjJf+pKyZ43gLzZCU+l8ysF
	BskKIX5d0Tl9jYwFa710e0MTt4pveoBD96bMs0XN05gWInhZZcjHba/vhwLukqkTB4vaAJ
	jHxT7MUaFn2cG9Bc+vzFSbOBf8h6vvw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ajJF1xjE;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778518388; a=rsa-sha256;
	cv=none;
	b=UDW8onmI0ckRnq8zV/+q+TPJdWB06K3VAfjJX8Iih4TkV+T0jV45KgwcnZQVIsi54Cq2Hi
	8DzY3kq6W7sk8sslM3s9YuGuvBJgiE7VBXnmWfENkGu7WGx6RoZcnAiznjj9AX0rzj79pM
	jQAT+5gri2K5bGP7d+p2zzUpH97mVSk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A18C60103;
	Mon, 11 May 2026 16:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04924C2BCB0;
	Mon, 11 May 2026 16:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778518387;
	bh=wSrCs5UnMR4P3H76hMnvwVit9yGI7o6BnKDT+QqjiXE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ajJF1xjEckAWgdOWlX6Dz4ySD45UoXxyjeF5lP4rl6nLBlrqwZLhbSLSxcSzy0Njd
	 VwUrnri1baFETwpo7+m/vErAL4bym1yL0f/izF0AFVisuTtNWikCdhA2fWaVadZyty
	 N5SaN1RpOrSKmlAGKR9yWDfwY4yoOmsujcH22S/vZqtcbFwFPDG6CjP47a7UZiKzZ7
	 AavEVt3nyC2T183jyBVqhyxxg1OAwt4h16WogPPm0pRlVKk0Xv57WpvVQrTzeVX/xx
	 NqmUbz7U1Dg2PqkU/neAjQ6G8QmhG6I25MczxIES/cLPliYfF9ZRPznqFXV+50DMSL
	 cmdaRKH/g0oWQ==
Message-ID: <4456c6a3-93b5-4f47-9c04-f7953fcbd987@kernel.org>
Date: Mon, 11 May 2026 18:53:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/22] mm/page_alloc: don't overload migratetype in
 find_suitable_fallback()
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-9-28bf1bd54f41@google.com>
 <f7ead2e2-69b5-48ae-8f85-f875765c84c9@kernel.org>
 <DIFZYTWTSO6F.3IOKEDZ30FINL@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <DIFZYTWTSO6F.3IOKEDZ30FINL@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AB34720009
X-Stat-Signature: fuzcae313ofyawaga534o5soednupcf4
X-HE-Tag: 1778518388-106803
X-HE-Meta: U2FsdGVkX184U++Tj8+dBm/RgGkUOt+IjvwCUxus+XG8VWu6T8A4QVTlRzyydXhqXG5aA0mJfaCpHqshzXYXMCfepuL3VnkGDGdCU7OOoN9TWJMQMcoVrTjZjRe+9zGNk6dsty4M0UMOn47VWMAtk8QWEL44fd9a30MhDjdnzc4Kn/s26dE3r1l6bTa+Nzg750kRTfZJVPYXKXJl/FEUBRugCvJeLfvNBK5icY/Sreoo3g7dqOWUSJLdR3czic3amunIGZCYnRiob4DQSMEkwkK0ZeEbqH3PUAjZDEbnbSpdOWQv9Djbw1kJWqmM4iuUhnegfRymwl8F0GAzbMBaZtS3+L3nU+wzFWdnlR7bnBdoSYiZsimG40m6f7bJDK0mqXUWvCLQ+htfdoSEFUzViZ+V6YyTH4zJnpdIMZFK1lAKH3Phy5LkOWfW7BCaNsmSw1lDIwFVHo4WZ6fgwZKdzuquHMLb2GcYHdmY1Im4rrWYdNHEuiq7i1nbkfbPXWjadF6a6cpKkPgP6I6akmqM/xF+MKIRBGoJcosb77hgVnh78tZvgmOFvakZezTBiKOSRSGR64GXXNgCiYXVpiJHHs/TyRwEHx2zvj5yFYpDa2q1i/njxpIZd4HSLaZS29is037yWQa+HHwOKR3qVk/TA9qxE0TMXP+Bj34s3pPgfd8wOXQHs2OO+9pj4u7nsFfc+mH6qglTno0sn/SaNABJC1OeiEP06PhiZseVu4rQguKYM/noYwHrXsrHfaMtXj7SfPnbRqGkbFxsW+27UaNlXB3kvRHBVQpFQ/SAjOM2fAk6rs5j+FLl268P+DDFuV1l9nNDVTcNm/Gi1BJyW1BazLf0O7/JstA/4y8TbBkYcKL2GjLO8xTx6UfkdSemtpwnzXHuMAVUKW1/WnGztLjn6hvKJEXJYlwJT3Vn7oGzXbij+IC90ENTe/2SdwFIntH6A43HTXtoxH5wHbZd1tS
 e6t1ST5h
 zot6cTI0rE74j4QjVDenH/hzHQu28kIEGGpJuCt7lQ03bTt2xHlFDiizEurDfBlxeDCqvlR6CsQ6lNDn5Hvw3845uY1mzyRVZ2E7c1LCHzTTZha/P5AQl98qa+fzNuazads0vDLkvPIg4TkLmftLhoif5yHbWEeOW+xeA3MxwtEDGSptITvELJz3c9y563JcevL868+ISzuYgOB7xLtvt1GMN0o2cMHSFfdDttNTn4bAa8tQJCwAN4uKChBbOgGmzdQgxHVcHHUbXxPUHYvDQFV5OehjNABbHDAiMTpy4DWfF6q5uwLkKKvtaXQHfEvr/2PJ5JQ1EU07Vy5xtXeEy7MtUFKw0gFr1wVWr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 18:44, Brendan Jackman wrote:
> On Mon May 11, 2026 at 1:51 PM UTC, Vlastimil Babka (SUSE) wrote:
>> On 3/20/26 19:23, Brendan Jackman wrote:
>>> This function currently returns a signed integer that encodes status
>>> in-band, as negative numbers, along with a migratetype.
>>> 
>>> This function is about to be updated to a mode where this in-band
>>> signaling no longer makes sense. Therefore, switch to a more
>>> explicit/verbose style that encodes the status and migratetype
>>> separately.
>>> 
>>> In the spirit of making things more explicit, also create an enum to
>>> avoid using magic integer literals with special meanings. This enables
>>> documenting the values at their definition instead of in one of the
>>> callers.
>>> 
>>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>>
>> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> Thanks,
> 
> This and the prior patch could arguably just be considered independent
> cleanups, shall I send them on their own?

I guess why not, fewer patches in the patchset :) You're probably going to
need to rebase this on current mm tree anyway for the next posting?

> Equally if they feel like "churn" I'm happy to keep them in this
> patchset.


