Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07DF1D26280
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 18:37:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 670176B0486; Tue, 20 Jan 2026 13:37:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63AAC6B0488; Tue, 20 Jan 2026 13:37:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554EB6B0489; Tue, 20 Jan 2026 13:37:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43D116B0486
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:37:21 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 11D6D140703
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:37:21 +0000 (UTC)
X-FDA: 84353199882.17.81C5484
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7D1FA40006
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:37:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nRcoUS6s;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768934238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ITCH5eSHHFlFzrcAyVSLkFWfLkiw7PkA+qDqwaON19g=;
	b=ocdGpixI8DD2u2h5VUs4e4wTPtWlCmwzI83QC4vArvu854LJofqvOwHHTae/1bEFRZKpMw
	vlY1Vc138SCpcXxMOirkItYFWnV7UJ559tdICOhOAmLxmL/6VVo0L+2gevi6XlyM/QdGwc
	p+srNjldFgoh+M08p3BHjmxUMt1cvCI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nRcoUS6s;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768934238; a=rsa-sha256;
	cv=none;
	b=ona8KBv+IW8nOG9/PPk0pZ8MWbxraSz6Wb9Frqlhdnp/9EKJ2BZEwJJpdozlda4Fb8FxiB
	Y1NnPLUT6NjO/x6VWDC3c2nmICaqnNhvN3g2mkYq6z3d4yEiYh5ezuAWj+3ieNa2g3hSqS
	WembZXzOyTyII86beFWuJrrNh1itblc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0925760010;
	Tue, 20 Jan 2026 18:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C598C16AAE;
	Tue, 20 Jan 2026 18:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768934237;
	bh=qMsPsLKr8lsKfYWwVgXUWfhbGnBcx6jUKbbl7LEcQak=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=nRcoUS6sAu6+BgNMiYePK91g1ZaWzvwxv7IPVSWT7+mEBsipRiebKmFM/UAH0eXpC
	 9SE9Xl+mi1vH/JrUI9JiIU3rkScWHMsXFjG0cuOUR+4bC8x63o8LELmLFV5BYdk+Zp
	 a/0CyanVVAAizhMAP2hYSqqIVzn+aocGIxop3dQXKWYOIF/C+dBcJb1q5beBRmGS9w
	 vKcapO/vc8FBqDBtOLn+DaBBpyRgXxbT1Q0YrCGhJc+H5II6chN5mbowEOldzZh94S
	 bk7yQKAL06Vj4wAjmCWmEynUSR6woff0aLxofTsDD6UsGKzT4L4CymQ63F2/5/QmwO
	 eTYDKs9FcfvUw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Evangelos Petrongonas <epetron@amazon.de>
Cc: Mike Rapoport <rppt@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  "Alexander Graf" <graf@amazon.com>,  Jason Miu <jasonmiu@google.com>,
  <linux-kernel@vger.kernel.org>,  <kexec@lists.infradead.org>,
  <linux-mm@kvack.org>,  <nh-open-source@amazon.com>
Subject: Re: [PATCH v2] kho: skip memoryless NUMA nodes when reserving
 scratch areas
In-Reply-To: <20260120175913.34368-1-epetron@amazon.de> (Evangelos
	Petrongonas's message of "Tue, 20 Jan 2026 17:59:11 +0000")
References: <20260120175913.34368-1-epetron@amazon.de>
Date: Tue, 20 Jan 2026 18:37:14 +0000
Message-ID: <2vxzecnkceqt.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: a7deha18zbqyjb93fk3tbmaajhxnnqfs
X-Rspamd-Queue-Id: 7D1FA40006
X-Rspamd-Server: rspam04
X-HE-Tag: 1768934238-267907
X-HE-Meta: U2FsdGVkX1/d3Z9X43XxskB0Awrp26eCTdOTfP4nbuuk1Rv+WQUrQYSFvfoZeESSlQDiiRJteLWVmJZgO+GOtC6x5X08cWYI07eJ7vmGxLUWJAWVTRguSLK3fQQRzpQRNbyZw8cYcvPkAiPyK6VM4/Axwkzgc7qDfQuAluIPzl6KmsqXkv9F/mI8scjyH7UqDEeuwRM2T4xEvNGhnKrmHBnRqcJJIVTH1xFXv80ioc1I+SrfWnvDDKXMYIgmTd90TCO34na/MeacIBPfrLZ82m71sZr2ss0W5imICgfLt6IZGwGs8w4llIUSytDyxaYkEoqrq+8rUY8YRluebngzRjNbl3l8eldEVZ/ELcRxashaFJwwkkesyTg9PMUFM0jpddonBrc4/2He7dqeSAt4TVWBAyqZ8ciEjzB3+da0CJwYELmi7h9+Huw9tP/8/P+mZ1OtH+uAnc+Kzu50A84D2z2MurKKNLZUSJ7DBFlBNx0ZvYVvTKsz7S1zoLuTqvCE3fuE85VeJhC3+tFAH7MdypTzCoSFrwFK6x/pfkSkVfrflLHdH/oa8S3GdmRh4xxrA3faVuSK1mnkAo5oVDjJGb8xC2gk6OIptrBZSeWG8I8CpNPzXYLcKrOUFrBabfdTBpANV/299fkc10Xz2FCGQaxDj6TMcVFusCBmBP84xU+ZPZL0c3VENtsmZ9eHKpn09aTkA+/aNyUZtYwQuBfq082zbcXqoKUGmosVlH7RfXpAtyrMDHubBU7JIt5O+wT0X0thl5w+afDvpIY7o7J36rQu6JeQhGQTrgfPUDXsgVtGiILmh88L+HxR9Zn/xwtwES27DXRsnGMfOcES1uW6whe9LpF5i4HocRBTtN0bEWHML6rzWiGzCFz0266enx0Fr/9mCaYSXT7/HtgWJ6gKpBvoSLMUqZPYveJtI0ITa7hAueBoMfZNTrtRhbHEXnN42kAym61sBsl5SURtIs7
 eJvnuUvq
 fOE+qrLC+NNAuRpNeFajq1gP8M5mK43I4QooQAXSEZ8Fv0SZXDoJ1dcIGVQnDsKNTI3AiQD4Vtfol+mbY7uqkWvJ+oiXjX62A7Dy5nqFUzqBo66iBoiyLb5wp/Rn6P6aHsL/7uWUjBJn92VHmPFgLh2p9YofLPhabp5nCxCQlPvk4s4CLIJeLU7cXWVsXXIYW51JZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20 2026, Evangelos Petrongonas wrote:

> kho_reserve_scratch() iterates over all online NUMA nodes to allocate
> per-node scratch memory. On systems with memoryless NUMA nodes (nodes
> that have CPUs but no memory), memblock_alloc_range_nid() fails because
> there is no memory available on that node. This causes KHO initialization
> to fail and kho_enable to be set to false.
>
> Some ARM64 systems have NUMA topologies where certain nodes contain only
> CPUs without any associated memory. These configurations are valid and
> should not prevent KHO from functioning.
>
> Fix this by only counting nodes that have memory (N_MEMORY state) and
> skip memoryless nodes in the per-node scratch allocation loop.
>
> Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

