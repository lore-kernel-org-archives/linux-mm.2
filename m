Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 328B7F589D5
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 13:38:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 736F36B0005; Thu, 23 Apr 2026 09:38:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E6B56B008A; Thu, 23 Apr 2026 09:38:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D5486B008C; Thu, 23 Apr 2026 09:38:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4BAF66B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:38:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D86F51A014C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:38:51 +0000 (UTC)
X-FDA: 84689926062.17.F366EE8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id F3943C0007
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:38:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="U9a5z/Cr";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776951530; a=rsa-sha256;
	cv=none;
	b=0pJziHU4dHIUUIGsne1s5EgsYwJprNestmjm2X8mLfAkvD6DY3cHhSi4z/wW9Ed+ygmBqB
	RarBlJUXVku+AhvkTQ5TnapRaNtC5bv2rWzlXq6AXrSrh6Yuh+sg4GEZ8y82b8/8NdkHyB
	D3xGzL2S2UzOBn/iDm44g3hoCeO6Qms=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="U9a5z/Cr";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776951530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4diHwapXUeRv9iFgtGbJEMGAXujqHqVpZe76ZOwy0N0=;
	b=kZFUwIYwTFlzBC+29JFZiSUabG5QTfEK1LlTQQCuvqslQ49lUQIRCiS2EzCtWNPtV33iFr
	VVuXAyqLoVFvpCkn023/oVevN75NCUNEKL7BJ+C9NgkdRanm/JqZnnpC8CVI8diFxu6A/P
	CVKW1UGMluweaCMBHZWP74tRKh7f+bo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DA190443A0;
	Thu, 23 Apr 2026 13:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03606C2BCAF;
	Thu, 23 Apr 2026 13:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776951528;
	bh=ICwDzIGe32smAh50GrVCkO16wFKiYn6OJO/XJNoFuLU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U9a5z/CraOHCdM4FWmGM8ORuy+wLAleTeIvQhY7DUJT4OKeogxfHQhJO/l0ObJhhh
	 sqfOqvM1ovEJ5hwPyGtzd9/1vlfiu0XZYYlV8VDZjC8ZxJ+dcoHEO66GS6o4qhGXjJ
	 gUfiYn38bQyRHBSQ4RdDuiCwl56U3UzzmsBK/LEmExExgq5qt4P2iXI0h9aCU33ys8
	 nSmoiK9I03l9Cl8G51/yHgWxltwfjGGC4X2Hx1AJsisg2eHKPV+OSUfzO9hCiOSFl+
	 3K9BnJ9Im1HXNbEh9jvsLZ8CEq8AAEk4gp8o7K0rgKWWYqcz1e00unSdU4t3T2PaSJ
	 iE1/Bzi236D6w==
Message-ID: <963b4f8e-b1cb-4e80-b14f-04a43fa15e9b@kernel.org>
Date: Thu, 23 Apr 2026 15:38:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] selftests/mm: respect build verbosity settings for
 32/64-bit targets
To: Li Wang <wangli.ahau@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260422080446.26020-1-wangli.ahau@gmail.com>
 <20260422080446.26020-2-wangli.ahau@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260422080446.26020-2-wangli.ahau@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F3943C0007
X-Stat-Signature: kyzsfdgznrhm9znx66wmerrhbsw5uzam
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776951529-524160
X-HE-Meta: U2FsdGVkX19FT86zamp/E9FE0v/Gg+Hrvd+dsGt+bBrcRdWVt+4cfA67HQPcArLG3Ekj8CkCQ7a6iVNMAz2eb2UWOeCF3krxDmGvse7ux9rOyGi46GOVhZf+xf0hHZHfbbNu0Fu/arfkYvvn6J6/j2hjJxSaY8xq4+I6PzHFmDDoH49d/2Jf2kFKsDF557unZyl6aCLCeAXnGWH/AwoIJBaYuuaVt7Pri9DjsMfNp4MGw0erMASMxNqQHNEvxKvpXRmmX71TyLOheEz1G6YeeDhJKBqcnL5Uolh+RCyPH2sT7bjsXnE6ab7M1CMEmU0F018pyy1xn5DGdWT9WVCJ0EpxWbp/LEX7qUnfPdHcqMA3vGiVXTMki4tkouQShKaL767pkb6Oui2z/BxgdUujsTB/+bZg1Zf6uS0LMaJE8MSf3UWGMMA5JeYfv0xkQgTPWOO3MJzlWYoX6m1eqJNjDfQy4sFDDJV6jxAvxmFJSkTJlStAkXt/EVSrDL/glplFKdEpxU5k6pUhAbpSF1RAy7SN62qFu0qMJjWQrH4pIr7TZzLcNr58B7WkimdS0oCO0pjaVzFp/gviRSGwRimr0czvP2SBJAZMhpQ4DRteoPDeV+qNrqzqPeyPdUghwQdvm93Ob27I8dWOPEr+Fb+yvwWRmvmu08QzbRl7WG9f4zVpdZIw8nyP0FGqzrXRhEWdsMqp4nPi6zt+93xtt+94YyRAmLrTEs/6a2A7N3K9KMFn/cY536EGkio/6+yQQSM/3P9oh8Wg9ikHjK16xF51Kp4XYU/8+ktBpaZCI1u5jJE/R3YpZOFuiu+duP7mL1xtm9C2bz6evwDd7gb9w7y+CtoDjO98EQsEq853WTmlvSeuKnhTN48cbr6GhTQvVnLhFRqpbk1zLGpdvOLQT3ctndpfM8ujzOo40Dfw8OA+o1H2LNJnQx1eqyKcJLO2tHo+E8+BKCgevCamHW82HI3
 ZEjUF2AX
 L6UK2aXwXGpTEfyrkg3XAcWMozP2o/85aHh1DOneGuw0xgycHePpLD04Fo2sXSzXZiGPdS/lHgfnqHnG0ZYiLU55ioi3tN5ziNZvYYQa1mw/ll23VHm2vi6nDbExq0Sihf5My0dy06uhFbVvtER6o1wOL57b66OSwRo5d7UL3DotFUTpt0upZnLyKGzPTCYW1bU7AiZa5i6hOOOQuqS2xZC+zR3r3+vAom2EqWRi/l60GuYyK+5oucFrP0kODIjfHHIOfSSpv/pbfvle6ZH8RbQi4MSFL/niIxg7LoGu18zeeqt/C7/XYMD+P9yEM/anxDPA9Vtd5RQdX78SiwtaZolnJeC6d8TuqkxsSBiNcERx2GgEn9s2XvvQMtRVC6LqMGLFQzhu2UQ1a7FiFz36rs4mhwxgs521I6Jgs5uLZ9DfV+szKj696Z/1axQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/22/26 10:04, Li Wang wrote:
> The 32-bit and 64-bit compilation rules invoke $(CC) directly, bypassing
> the $(Q) quiet prefix and $(call msg,...) helper used by the rest of the
> selftests build system. This causes these rules to always print the full
> compiler command line, even when V=0 (the default).
> 
> Wrap the commands with $(Q) and $(call msg,CC,,$@) to match the
> convention used by lib.mk, so that quiet and verbose builds behave
> consistently across all targets.
> 
> ==== Build logs ====
>   ...
>   CC       merge
>   CC       rmap
>   CC       soft-dirty
>   gcc -Wall -O2 -I /usr/src/25/tools/testing/selftests/../../..
>                 -isystem /usr/src/25/tools/testing/selftests/../../../usr/include
>                 -isystem /usr/src/25/tools/testing/selftests/../../../tools/include/uapi
>                 -Wunreachable-code -U_FORTIFY_SOURCE -no-pie -D_GNU_SOURCE=
>                 -I/usr/src/25/tools/testing/selftests/../../../tools/testing/selftests
>                 -m32 -mxsave  protection_keys.c vm_util.c thp_settings.c pkey_util.c
>                 -lrt -lpthread -lm -lrt -ldl -lm
>                 -o /usr/src/25/tools/testing/selftests/mm/protection_keys_32
>   gcc -Wall -O2 -I /usr/src/25/tools/testing/selftests/../../..
>                 -isystem /usr/src/25/tools/testing/selftests/../../../usr/include
>                 -isystem /usr/src/25/tools/testing/selftests/../../../tools/include/uapi
>                 -Wunreachable-code -U_FORTIFY_SOURCE -no-pie -D_GNU_SOURCE=
>                 -I/usr/src/25/tools/testing/selftests/../../../tools/testing/selftests
>                 -m32 -mxsave  pkey_sighandler_tests.c vm_util.c thp_settings.c pkey_util.c
>                 -lrt -lpthread -lm -lrt -ldl -lm
>                 -o /usr/src/25/tools/testing/selftests/mm/pkey_sighandler_tests_32
>   ...
> 
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Li Wang <wangli.ahau@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> ---

Great

Tested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

