Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC985CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 00:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32AE36B00A8; Tue,  9 Jun 2026 20:19:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 302586B00A9; Tue,  9 Jun 2026 20:19:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23EB46B00AA; Tue,  9 Jun 2026 20:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15F946B00A8
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:19:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD00E165077
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:19:48 +0000 (UTC)
X-FDA: 84862094856.02.BDDD0EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1F92F1C0007
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:19:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nJP47KD1;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781050787;
	b=ZolmR6BdvapySH5eTNBSaud6M9ydtFDIwKq5TPo6NqvdXjMyUh3TMTeELyuwWH2b88D+WA
	82RJtBvOVaouvwxNpmGPpcUBixssmbE8AR7DmaQe5OMNBxoyY4viCgV3mBz9f49LUCvEP1
	EdVNsjNZfTbKFRnKCzRluMbmYSVH/+k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nJP47KD1;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781050787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J6Qec06ssPjZ8KBpX5bHjrDWkBPXABIpPVj+yD4nsUw=;
	b=K5yplJL1Jl0y+39IWEMeF9CvK+DXgnKl6nHcObVrBRfHRBp29gN4dv4UHbVua7fxN/VKWJ
	Gcn12ixDD/kwD5WlaOW8hpe7Ab0jB49ZL0Q64kej7R8rfd4vTEZS7HamHtsKS0i9TuXt4O
	r9ni8mVmGfUFQkhhumYKmBtlOXwYoo8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6652E6024D;
	Wed, 10 Jun 2026 00:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C647E1F00893;
	Wed, 10 Jun 2026 00:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781050786;
	bh=J6Qec06ssPjZ8KBpX5bHjrDWkBPXABIpPVj+yD4nsUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJP47KD1xmj0+wbmArvRXxtJ0OtvRFbtwrAedhff3E+nr1a58A3hIDqqqkqDT2JbT
	 nWpaYSf9JEt9lRb/4xCqkqelm5WcHsEteiw26d3UAo1recuw6shcpx07tO9Z9S5GON
	 0gGNmsfODaPOMYQlArenuEs02ePfW4TfUIbQgekopwCiYj/XodVIsLDtRD3j3CprW3
	 MwoSH997YlEx00d1lBpFzB0Bwg9uLHA/awmtrFqI4880OSAET7y07GguP9dERmkPxb
	 wJWeR0mSFBFH89RYA8exc1D2TGfjGwpWtL+5pnJVKw6YQKOy+/HweqsNih5bK2wnBm
	 cx0VK6Rk5KnjQ==
From: SeongJae Park <sj@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	kernel-team@meta.com,
	longman@redhat.com,
	chenridong@huaweicloud.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rientjes@google.com,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	jackmanb@google.com,
	ziy@nvidia.com
Subject: Re: [PATCH] mm: constify oom_control, scan_control, and alloc_context nodemask
Date: Tue,  9 Jun 2026 17:19:36 -0700
Message-ID: <20260610001937.77371-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260609002919.3967782-1-gourry@gourry.net>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1F92F1C0007
X-Stat-Signature: 74s6yo99u6exy3xk681jotcqzgnrso6w
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781050786-473971
X-HE-Meta: U2FsdGVkX1/U7AKzC08qdfJPLA4eA89URe3uQdd2qi/8kdt8L3+v0WxN6xHbVXrASYt9F1od6PSTO4mS9VBuuDCongSrnjDKtgIgfbiF7hSmtQ5pZ9agG7OPlxFGmAqqNcC2Whywjcc9yvYvI2sCWdLabchZY8e8BMiZ2/CQpgksgzA5miX1CUczu6aEuHpvBQ+UejTsZ3H+EpRIZWYv2rBrFO/dXW1jOzIjY9jCLTet016V9MSMD6MHhIF46zHgfIWz3aodNblCauRdWRwVretQPinlHkS6e0+TzWIyggDBvdhpqbSMmC77W7vNKdZTr3xq2xPBGVYeYJ9Wk7cJGdaqVz0eCGSDlgyHEOdmKGTPI07NqPYEt/91gFW5WM3Ew98vqiY0AC6GXTIdm3n1SUxHdP+q+dxyfESbEoG9PnmWb065X0vRTH1hRQon9XAcmVrX03g/mTbmxmt0F2ETwQYMaAPVGUbfh+xnuk1jk2EHVUxL1SzkGWcKWBf1ZSSw/RBB2ZXPS+btQbhZvLVV5kYFjGcT0xtcp4ZK9TzisEQWKtpNkFG8KgU2e+S9yYzCoO5rN+rZ6GrnCvZKatWtKgrCqtFO4VWaoSv9+iRNxHHlv8FheV/DtXFhQfSgUb7+xIvAkHpo6xZvWUEtAzMb/XE8hW0yeTTmCKlYwZzQDA/IZqApern8Z6b2yHAyhVTk7RniUf46D+Zx6i4IbuS1jbikVCC8yYYzk1SA1aLsrv4lbFnQqbKmmwZJG0gW/yvZTtaMyAgtlrIoKPwkhoW1ctQKLLH44dyFeCQA7r/dMy0TMWG0UXKuH+CQTWfGwI1+wlBdkGN+EqXrxWVmhlVDIvq18hG13c7E6HaebfjCUq1FajbpYI8tvzIEPvp3f7i1YwSSHktIRtQm/Lu95bi14tA8d4Qhivs35qbtJE5ZAvHqQFtkZWIi+wEIkRWW3Rae4iBZMejEweSXSgGcwGx
 JWC2j5kJ
 OJePtVyq0DUKVLRrxUgNLoeT9vAXbHf0EVCKOOVTSuaF3CvQcUGIPevdT3z5//eYSI6mTKebTFO8e6SsAhdh8LfR8UQMk7jsh5NAS18V6lS2QaOJIJEHzauCO7Q20Fakl97cAF0MlbWYjdDg3Bh/rrab1+y8quJsDXpRbXaJfijxBHkWRz1E8tK7o+V1n1irbFHL0x0YSI1x8mK4lvEcY32Y6VISCVXNpILfFVER9F6wy9dOZdAFvxNuBRhkoIP493f5G3LCAs8HPELAnaCIo96QZ8rdNSEPksvGrUI7Qh9w3gPvCeW0ELxsbtt2CC1G318QSznz+v73WSZFmbPfeb1peNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  8 Jun 2026 20:29:19 -0400 Gregory Price <gourry@gourry.net> wrote:

> The nodemasks in these structures may come from a variety of sources,
> including tasks and cpusets - and should never be modified by any code
> when being passed around inside another context.

Nice work, I also confirmed I can built the kernel with this patch.

> 
> Signed-off-by: Gregory Price <gourry@gourry.net>

Tested-by: SeongJae Park <sj@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>

[...]
>  	/*
>  	 * The memory cgroup that hit its limit and as a result is the
> @@ -6599,7 +6599,7 @@ static bool allow_direct_reclaim(pg_data_t *pgdat)
>   * happens, the page allocator should not consider triggering the OOM killer.
>   */
>  static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
> -					nodemask_t *nodemask)
> +				    const nodemask_t *nodemask)

Seems the above indentation has changed for a rason that I have no clue, and
also introduced a line having both spaces and tabs.

Just thinking loud.


Thanks,
SJ

[...]

