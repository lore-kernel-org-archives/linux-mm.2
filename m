Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7F2ACD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 19:51:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 176C96B0005; Mon, 18 May 2026 15:51:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1296D6B0088; Mon, 18 May 2026 15:51:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03F236B008C; Mon, 18 May 2026 15:51:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E71AF6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 15:51:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95A4FA0A50
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:51:57 +0000 (UTC)
X-FDA: 84781586274.08.DC04C15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id E8CBA1C000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:51:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A3KTXS+Q;
	spf=pass (imf21.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779133916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xcoZwd6NZEfUHZh7T//JHQ0H6dEGcLPgqCMFlRE4XCk=;
	b=DbCLuvaApoiuy5BP7Pj8YW6JPPUpLxvG5fWJThoKtRBvQsJl57ghIgRKl4xiPeteLhh7mQ
	9zvS2CjwMvmNgeaud57HI/E5FF5YFdKoS3pLVTS+uIG1aeifIyUDURM1CCLVwPgh/uQ+zG
	T76cdpLPjovB+kJijHHy27Uv7zqOpH0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A3KTXS+Q;
	spf=pass (imf21.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779133916; a=rsa-sha256;
	cv=none;
	b=OpwsVJGwEC6QCXUpPkgJ5pAjoTOr+LeyIY/GQpSpxdsOF/OJlT7W2s32wWxGndbRcFWrdP
	3xUlkh9ErqmiMT3LzGtgXQtGFmBsuiyqEfLHpF3m/f2GvT3GZyopIhAVorQhki5IxUUmUj
	uUAZPqb1KBClVWPe9umF4yA2yLRO95U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BCAAB43538;
	Mon, 18 May 2026 19:51:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71871C2BCB7;
	Mon, 18 May 2026 19:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779133914;
	bh=0EDZC3hd1XIo9RQYnoioqSdk6FylXyXD32g6lc8WK80=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A3KTXS+Q/AEBoZ4uNfNUsQ0k+ej9XaXq69rCQFPw1ygtZW43gGcEuMye/wWE45zdM
	 YMDY+mI9YFi+aDyqPtX65ur9P0c1QLANOG7IYdZsxcU5O4TksyH0HhEMICOGFtEsDu
	 NbqOY4ZUq2HB4h+bfnVdA26kN4pBS4xYv5DFT9gazLd16W7FbrqAVkcww8+KXOp2eb
	 jkLATaJa7wZKYa7Y3RhuUVAq34sssOBxg9XNnYenpE4Kl2gYVnA293XdgSXNGs1/Y7
	 aOE88cBDoObjjaZ5K6sWE4I1ly4Ftfz3HR+tVZRTJvCijUZ6tVmR9iJuQl7V3aRIho
	 Az/hnaRVwWgCA==
Date: Mon, 18 May 2026 09:51:53 -1000
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev,
	bpf@vger.kernel.org, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] sched_ext: Sub-allocator over kernel-claimed BPF
 arena pages
Message-ID: <agtt2dEjS4Qg7a_P@slm.duckdns.org>
References: <20260517211232.1670594-1-tj@kernel.org>
 <20260517211232.1670594-8-tj@kernel.org>
 <20260518072042.GP3102624@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518072042.GP3102624@noisy.programming.kicks-ass.net>
X-Stat-Signature: qrggtf9qo695oj6amkoek7mmfwbpyof4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E8CBA1C000A
X-Rspam-User: 
X-HE-Tag: 1779133915-303715
X-HE-Meta: U2FsdGVkX1+L+X3QwjObmi/HIcsrGB8EZGoUmETEw2+9CRX9QNziVXKsbi4EZpcYnpe0bukq41+7WxAuBWBIY0dp1FhuHkFBGquy2hjicvpouRqQHY23IbGEsq4HcyYkCEehZ5VYNAEi+kCMNrSXcMMJvG4JkbLj9mp7xsDxIRPwly3D4488XU25Qjfkbp+fB3nN3rS5tjxOLat5kRs6MVmX45ijf0MlsOT4RY7jTBCvsLEKlfeVIuByrxk7rwB6g7g2tcwgI3LCZ1l0uysGOobhdBDBC8aGq2pi6hFuA/dTER3JHHUyUuhADfQx2bdhysxZiHQZT8fZUpjQ9VujUpgNLN3R1bmqf+GQ/cR951vHIoKIDTrGKF8sU8BpCGmuKpWNM7iFWqyW3Ffgek2Qo3Ls/1xZXFop7/6dQG7eIos6oHPZY58DWf0d4ZxihdmAlfwPcegXTEM5Z78rakUvHjM3d3+2EyERPf2ptF25g7C27s2epL35qLPbv1tWDwuxZPzP8ypU9bLFb6ZyN7I8bdoMmUEpious5v3XlOWZcLJtEC4K0zWjB4JWqr39knBiqNh3bBxKLx2Tg1hSdX3Uj0Bg1im7M6DQGPzOuSMiQ2/EUAQeUhAKJS1KBWnxYgdDb/WqLBjkpW8kpVY+ZY4ae4V+GCW3nzXFJtxnG6fX2Gc2s/UZLM1SSD8zdSxaSwafDCVal2ruDXVtUQ75EsZMn4DNQCt7RWlUHJC7s+C8TMqlQ67bOJ5RTdRLjCOabVOwzLFtTQbFXyc1CPn1D90E6oS/lWLFWx9Hj/iCdH8yBwUF3fHRW/JgScPAf8XmkAIvgYOSz7D8ytAOEb8yZnnKBaH2wkrYArSPyD0tXaRzR/Qx7U7jMe/0sZ28MijI89kL2ffOskWYRcSsYvQB6cKe6Snq+YgL4PaoDix8+glJIKfcK7jHIf6Qekpm8iDLrN09tbOSV1J/NsTsId2KvBZ
 UcfiG4Ex
 QsEHwj/9+KPQkDyZ/Ov3WuwHThQPL/xMkvXQ1avnA1BUCfs3v2RVG044It32IQbXSJ2boXZzc/wS7FlIwfp5mgFE4O3RZIBF9vxCMsZ7hjYWKytimxz4XCKizyKXn25dwA9K3QTGOeEg6UeGfTzeyG3vWFC/9Ne8gYNwq4QxksTur0KntAe3jFBshUNhsU+tF/F+5QT6p4J4M0e6gXO2+4Dwy0QhgxgsHLlcYyzSE7SnexlpqdodXS2dEl1IXbciotcToheovYCz9g5s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Mon, May 18, 2026 at 09:20:42AM +0200, Peter Zijlstra wrote:
...
> Should this really be part of scx rather than be part of the bpf-arena
> thing proper?

It's just a layer on top of arena. If bpf folks are okay with it, I don't
see why it can't be a common utility thing on the bpf side.

Thanks.

-- 
tejun

