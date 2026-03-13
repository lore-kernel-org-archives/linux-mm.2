Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E624E106FD9F
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 08:52:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 405A86B008A; Fri, 13 Mar 2026 04:52:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B3046B008C; Fri, 13 Mar 2026 04:52:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0E96B0092; Fri, 13 Mar 2026 04:52:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1ACF16B008A
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:52:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B255A1A0882
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:52:27 +0000 (UTC)
X-FDA: 84540423534.27.2F464AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2322C180008
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:52:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qadvyg24;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773391946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TmwiR5JbS+usss8ODrAL9jskrM3z8cFZvm5LV3mBIS4=;
	b=nOOCS7KbRk2o/Jc56LnedFBV2bZ8cGskuQ5xgAadw55oKcTYyjGSyZW3GfRF9GpRqHRFzl
	O/WaT/P51o6i4k3JYbdrdyoOaMirCiIoFgHO5ikcRV1UwZQzFV/jvBWsHTdCcOxfpR8zAH
	9lddGLo8eLZhqrENFwPxqOBF4i5Y9qk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qadvyg24;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773391946; a=rsa-sha256;
	cv=none;
	b=iLAAlHyREzlywDz3KhkNB5RtRmRwCT9R2b422W6FqgTaOuHu45kVD66jUCWJi0GkSJvrd8
	fd2F/Elad2qW9P36ftznstZX59Ou2SDqyo+949fAclgnDHdMvjpfzn5Uj9bW2vypCgWFsj
	nH359N5idPvbORG+hsIUs/6hCjVtmVE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 923FD60132;
	Fri, 13 Mar 2026 08:52:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF24C19421;
	Fri, 13 Mar 2026 08:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773391945;
	bh=48k43o44R/1vbm7ZEvmXByIBhou36tIdTyYZQ1Vswss=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Qadvyg2437vfW5DXSZvv+CTqQWYfifQQKqWfgWHaJ/5gs38GhaRMECVorotU98mC+
	 xy+q4cnZa34bPUgke9m0gPtLjLxLa3lwRB+wOovw7g5hF87Qt99FnCk0+XSHBIzDyp
	 UB4PvEnNrHzvEbv1BgArxECDF0c2D/aKqFExA1t/mYr9NrCb5yVV4eLL88Coz/q33f
	 xreztvIlCLTYme80VQxmFOvchlxqDGgXUYtEGoUGwQknBmWmmlRD8yuZQ4WtkyCrXg
	 9llfCseyBYDHAtXJyxn9YR9ky583XFOVCBFXYy0bwWFTKubLLxrA7nuEQceelko1Co
	 g0CriWexDKXaA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usamaarif642@gmail.com,
  SeongJae Park <sj@kernel.org>,  kernel-team@meta.com
Subject: Re: [PATCH v8 2/6] kho: rename fdt parameter to blob in
 kho_add/remove_subtree()
In-Reply-To: <20260309-kho-v8-2-c3abcf4ac750@debian.org> (Breno Leitao's
	message of "Mon, 09 Mar 2026 06:41:45 -0700")
References: <20260309-kho-v8-0-c3abcf4ac750@debian.org>
	<20260309-kho-v8-2-c3abcf4ac750@debian.org>
Date: Fri, 13 Mar 2026 08:52:21 +0000
Message-ID: <2vxzikb0glh6.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 2322C180008
X-Rspamd-Server: rspam08
X-Stat-Signature: nw18i18xbiu78cbua5fk1camtskcs89w
X-HE-Tag: 1773391946-609758
X-HE-Meta: U2FsdGVkX1+hDW0qnwhdqF5A+fduBQEg+7ADCnoqzc1md5vOye6Jo0/6xf2y8kDZ8qdK8o3z0OcDEFtBdRzwXWzDxzl7V1fAGr2rPhMuelrtKAItiNlVcd8zfLKEl7IPi+8JUrQhgYNmL86DA+EMhwMXCMChvt6BmAiwPn9LJtgSQw7TmgODyavoPLrETGxKcFLMcgfhJG7/L4rlq7zBjY+a5Msa0gAnJ5HWhZVdFq9aL8gozx5neY/pd/WbknLpGUx20Su+d5uykRJmm5lnkehtvbVYtIm7X7xEndVA3h9JwY+c5js9/1gtz7llug3p7p8E0W+8xgCOwGhRamlvgR52YCuGg7MVNfgyxGMGFEWBs4htO1W9xSTiyH64qE4oMX/ReGFv8AXJdXZoRuJeVYMYRnfBpsXJOnoe1pv/mXSiFRMOB8g82439gnRERdkC5VGoILyX3p1p59Oyg8sQVO9+dPc0RCwsM8QKKb99zIWmEND10WyXNzC7PuxRVPNvTIfCw8kg+wG2yLFcgwL1UW+GdmCXgoQuM0Gds+6eYTnww2R+WrvlezqKie5rAvjXLeQWmTJb8rkk7Vtobgt8uZQ9m27T2lSdWkEw3PcWok+RcekFcP8+k0j7td/b/1Tn+uqahejSp3sCGiSfkdNXYE0eD5IkEx9FpiQXrVTM1QmLPaqTmMr4p5YCRgRbkFrltM+X9UIq/GBqBGPX3ge12UJXdFv12xxaKOe99fb4CPMOpQknwFriJ2Pspx767xxBVsobWGnl7/9/i7n9rsrhDMnokzF1RbD2ExhMwGQ2yvtf1fOHNGPQN2eJ+2yr9TYBUF6lJEML4QVXmYaVEnfE69olavSXJ5FT0rrSH5diBM9Byhnu3SzjexByavJ2PJzqos3vEsZ99HgezcTJKF+lFsW8Wfr8igA2p0hzI/Sfo7+wyBTwj6T5tD4WxOdNW3Ew/0M6BAj11R+DighCC9p
 g9YaHpus
 nb9taXaMV4oo0VnPSdOHjZxL8roR3uXxyodk+k3rfO97a8Pk+UMi+mgPuj0c+4VY64ugP0kmFZtrKVnUANe78bLcsf4T7TmSH2LWTAYIqNIpbJc5t9G5/NKeWIEzIIbx1izu4PI2FiAPb3t3ai1wgVUwIUcCQz7usMpFtFSJWacF6jnSCYGUf7AzQk1q9alXo3JV8y+1vtYFDrZJu4RKMvKGGZ0kVl+mSJ1JSqAr44YIZOJBbGCiaHdE260DicuQa0NWI1i0mDjtyMBw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09 2026, Breno Leitao wrote:

> Since kho_add_subtree() now accepts arbitrary data blobs (not just
> FDTs), rename the parameter from 'fdt' to 'blob' to better reflect
> its purpose. Apply the same rename to kho_remove_subtree() for
> consistency.
>
> Also rename kho_debugfs_fdt_add() and kho_debugfs_fdt_remove() to
> kho_debugfs_blob_add() and kho_debugfs_blob_remove() respectively,
> with the same parameter rename from 'fdt' to 'blob'.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

