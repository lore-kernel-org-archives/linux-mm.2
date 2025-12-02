Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38CA1CFD2F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 05:46:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694C66B0024; Tue,  2 Dec 2025 00:46:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66CE86B0026; Tue,  2 Dec 2025 00:46:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A9776B0027; Tue,  2 Dec 2025 00:46:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 496AB6B0024
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 00:46:05 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 51648132435
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:46:03 +0000 (UTC)
X-FDA: 84173445006.10.4704FA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id BACC340005
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:46:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oavEaRQ6;
	spf=pass (imf17.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764654360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LieKBkPT6izmdrVoak8cxH6p4/RA/uiy9pxqB3/s6MU=;
	b=MG+o6PCL/x1prGu9AoEfdjEIv/LmNtosieSqnlK5YEbvQ47DPu/PAPjKWXeIJafll+TG34
	IIt7EktyrGihyT7AGt4qsuOynk2aljGn3ioZiJLpBHOhOev8Qb2TTHDkZZJxz5y4aZVpl+
	uLx1q6S9/QCloM+2UwySy+zrkTkyH+M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oavEaRQ6;
	spf=pass (imf17.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764654360; a=rsa-sha256;
	cv=none;
	b=jCZS18m/bYzvEo+bDjOUBo1pwyjftZghOT7mFpLfaZp7eNOsuvXzHtGUjy+MzM6KA8vrw8
	p71l3crdOXUs0InLl9WNu221bTkJ+x4c04hdd/RVXQBs0vesUgln3/jQZt3O0su22CXF4I
	YZwoJUcZ2gl/S7LHmRWJ+nSfjw750AI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 433B6600AC;
	Tue,  2 Dec 2025 05:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46E2C113D0;
	Tue,  2 Dec 2025 05:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764654360;
	bh=5AGygSHnHPIFSS6YwKZVtMBnpy0dcQQb7F9JR6SgAkc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oavEaRQ6m5vpG10o/4HokVtjqL5IIEx93eAQR46W7PNtkXWLFsig92HRBCPvDhvVD
	 zccK2Fx1oD+pwkJEd2XfdvmBe8MN7mAFVHi+FqoSfKynFTsBidf/8k/iAhIhfdQ6w9
	 WvtXsGkU7cjK6n78m2d8Guj1BdXHNFD3M7b9Zl5TU3lG+j1UudrJaYTV08wYJLdqBH
	 P3dZSr00YFkOvD9Xnzoa94GLXqtR0EJQ1z3n4sOcqCRbsZdWI2gMHxtODSoRMeX0ww
	 hA4DID/7P2UriNCFX6ajoOvzRm7L3O+mXGbt6Lmt+Nyo4r4J+QQuENPBaiCcSlWBlp
	 cXmtSs0vqFdcw==
Date: Mon, 1 Dec 2025 19:45:58 -1000
From: Tejun Heo <tj@kernel.org>
To: Guopeng Zhang <zhangguopeng@kylinos.cn>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, mkoutny@suse.com, muchun.song@linux.dev,
	lance.yang@linux.dev, shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/3] selftests: cgroup: Enhance robustness with
 polling helpers
Message-ID: <aS59Fjm1iL5U3-Fn@slm.duckdns.org>
References: <20251124123816.486164-1-zhangguopeng@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124123816.486164-1-zhangguopeng@kylinos.cn>
X-Rspamd-Queue-Id: BACC340005
X-Rspamd-Server: rspam02
X-Stat-Signature: 8hhgde1qbqgxnf3asok5w65zcsk1ytoi
X-Rspam-User: 
X-HE-Tag: 1764654360-611506
X-HE-Meta: U2FsdGVkX1+nCMhd+3pT96NKoqCxA2eR5afBxyM3Fj0bHv4o7JU1RUN/+97fMU+JFCFHeL3ZgGM3UGgX3tQzYzIIU1Q9hZxnGi6gw07xbieAEq4MAkfU3Ukg+RT9f8ilKcUIO+Y2q4NqqG1PgeitEmjMZhVKB/HbqNc24/x9S6SAw3DcaaJO/83u7TOICeGmDcLKx3mi9T9URjPakfwqwBN1SkQOkqRbP8CUWrjFm0qVNsURI9Ir3uNCVJN4R6nTdRPyKE3Vo3OlVF6TeMoQ6p4OAxIfPvW/MVVCn8jasbEUHh102Xn/BKIzHGgQFrJDiYpplFo7jyp/ZqzWHFXXoNOc5f0P0xwMLsK/+ZZu3CS0I4pavq3mSu22UOI2dnWJBF59b9lCUsjqH6FC9epqgUPH9NdFsHsJA81X3prDyRu5U9iMTgpfS5QX9RWxjZrxN8OQpmNWiEXDfjcxYqlFFXM/49jeuNEzOGVY/s9VtlKHJzPIX5zhPhDh9Mgr/Sd0pbCA/5KhsuqRWHKlMbVm2qWlqMuEkFOwdPub43GEBpssecAq9R+Yh9QqwRv2GbRKvKszwvoxXjHqC7NRBFBRrNIzNCNFsbTLKywrH2ZwvdZZGsSy1PEBlqCNW74WhaLa6z9dXtz2QWHVvIpFOKoO6c9lf/Je4EFGi/I+X+T6XWzTAKo4LUO44EVI9LvOECrACiOtxAqPc6mblCO6xnygFVFCQOh2ETpDsq6qf+0ZZa9RtLqlIkFxs0s+PEuDzWMlxBPrlErSqVZt+q/7iENjGjkuEiQUWxBOJ/6RsOw4B093F1lRlYLP5GgUeOdUtyyhFwcyh31nhTpCjEcavkAKYvaCS6343OevKqgUuUNGpi9m1K3LP4b5EjSuy68/wf9u3MXgrzni9ISTnxWv8GYhoDmgxDCV4PRBG35kTUEeI8IAFSdOqZMkF27jYzOHn6P4cNQ3Z+/gJZ3lXXCwaFH
 Cp7bkXA4
 ppwcwZRUjS92+bQavo4UUBWxOLQlZfMh6eqAKwWzTFjKO4xcSBi/Zzjlj/AQK+I2SONmDFRFnH0Fu9MPqgyf0ZsbUZY8vm9cf69/kAtOUvZNtoNDiIr0Kaq2dY2Nx2lBXEYYV4t+iu8noPAZVHS/g05OZ9eWI/B31FbYPH0JK80qG2gjTScf3NXYauMCqk/51EhR5VK++QbkAQJWc7QB7IzHlZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 08:38:13PM +0800, Guopeng Zhang wrote:
> Hi all,
> 
> This patch series introduces improvements to the cgroup selftests by adding helper functions to better handle 
> asynchronous updates in cgroup statistics. These changes are especially useful for managing cgroup stats like 
> memory.stat and cgroup.stat, which can be affected by delays (e.g., RCPU callbacks and asynchronous rstat flushing).
> 
> v4:
>  - Patch 1/3: Adds the `cg_read_key_long_poll()` helper to poll cgroup keys with retries and configurable intervals.
>  - Patch 2/3: Updates `test_memcg_sock()` to use `cg_read_key_long_poll()` for handling delayed "sock" counter updates in memory.stat.
>  - Patch 3/3: Replaces `sleep` and retry logic in `test_kmem_dead_cgroups()` with `cg_read_key_long_poll()` for waiting on `nr_dying_descendants`.

Michal, if this looks good to you, I'll apply after the merge window.

Thanks.

-- 
tejun

