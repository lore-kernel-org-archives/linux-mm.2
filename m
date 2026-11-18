Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBF52606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VR3qe+77
Received: by kanga.kvack.org (Postfix)
	id B6B406B05C0; Wed, 18 Nov 2026 09:49:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF4896B05C1; Wed, 18 Nov 2026 09:49:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BC976B05C2; Wed, 18 Nov 2026 09:49:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77F836B05C0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:49:05 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 04D411C3F25
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:49:04 +0000 (UTC)
X-FDA: 85448522250.12.1A3924F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3B1DEC0005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:49:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VR3qe+77;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795013343;
	b=Us5VZ8UELkYjxY3HPfd46leoehlCJh+Kr3NEzUtJvEiFM+cIoAjVxTkT6BpZWilLru9Gxf
	5u3mlNCgilZlag50QiZ80TZEbGf5+0F9XbrziGkMEuZfKLtS54IAUr4giHU6UGntDPrzP+
	2xwKRyUtQNGuYd8voJyWdM8YTsOjLeA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VR3qe+77;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795013343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PZokJnorHUfPz0LvehXK8KFnENmNkS3BGLFT/Y/rE4A=;
	b=epvFcgm7qVplpYb/oavY/uMyYatlXA/cIJR3m5N2tMk4jgohJURVpLsBWf+OdOvgKd0Kms
	hNhQZCSPLs06hzVb+jsFV2ObU9uOukLj2aXOTZtR1uLo2KHVYe8wenJVY+jjYPbYCGjwb4
	mExUhfeRYP0bWOkmmYBx3xXa9BA+SwE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B4CE4611CA;
	Wed, 18 Nov 2026 14:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7E41F000C4;
	Wed, 18 Nov 2026 14:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795013342;
	bh=PZokJnorHUfPz0LvehXK8KFnENmNkS3BGLFT/Y/rE4A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VR3qe+77ccdl0xKEuokgkGwSpXy6QaeznHkKjdy3wJhW7kxBcdy3SZv4isdntdUO0
	 aZaXW4yWl3sTWsKMlUU3Mj6XRoYA3fL3L1J0DZ6mHiJ87UjuscHAThmp6J+V+FnAsz
	 oJ276ar7LMWqQvlJ/xKUNOFqWAcBdJ4umUyUoDeG+bLpvnA/3TfDbVI0QMBDel+zQW
	 hpjkgP5pCPPYiUfausZBT4f+E02QVYTU+PX2OFktT5p61yNR6HU5O9qv3FfkOxbR0v
	 WVM6OMSplboT2246ivV62b5i63UiX9zBOZF4H5fPIcuVmV7kOXzol6qNzohpyVfoFs
	 5GHVrLdKBH9pA==
Message-ID: <4a1edf5e-2e15-4cd0-a032-5ad579111713@kernel.org>
Date: Wed, 18 Nov 2026 15:48:55 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] mm/memory: remove unused
 vmf_insert_mixed_mkwrite()
To: Sang-Heon Jeon <ekffu200098@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 "Jose A . Perez de Azpillaga" <azpijr@gmail.com>,
 "Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
References: <20261002160535.661399-1-ekffu200098@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261002160535.661399-1-ekffu200098@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3B1DEC0005
X-Stat-Signature: e8bbk9xfferwoupdeswykdqjcaucx6xf
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795013343-492421
X-HE-Meta: U2FsdGVkX1/hupv6dCnrAjREhz+T+JdRJ+MiExQ5LV21it+Gdi9I1puUbCLygiayc12Z1YwpEZX17qCQcl4yBFqI3IL28WgOxACpEOCogbkQvnWDTmbk6++KaFJhaM+BZocsu4mtF4suUggKpCuCiO2HLiup/OqAN6DJgbG/eyFZGVCe6+5/ZJ7FnLpSjJHHrSTlA8n/s9wY6kbHJ/XD6PYc4x80mOpSP0meZjf8AkZEnou5m4z3cts+SVmAIfzmABpfPkEXgooQw9y7UcbFE6sxOTwSzLTv7e5KTfau4O78FNg9rEYiBRmmOd9H4t3+YNMdV9Z/TzOwDHWkaoNtW8iynns9Actg+A47lyonKz1VF3EPgIQOqfWkvbxjdkOQQJTjVS8vyJpFJC4C2iCHDFLcaLzzNrWGSVNJapiBf9F4+R3J5cuTn6RoCT+5HqQHTBVUlZel5AlEmSXCCXT7C6EPwnF4C6/biENinQvxgNY3vI7dhnC22d+O1Y2oDjWiiDyVmWQfulwGIM/ysnxwb8pf97gTyVmUgJCgtR9Si8UNpXECbd3qpfBBlXJSGXWZEb0LOWZoh8Y+LeWlre9eU5kM9X0UPU7W4lzx6xP3soncmVcGkmAXtsGn0r13ex2asAW0B13+hPOgydFZqCmhV6BLTPoBtistmL2Paq2+dQs001cDfaByQJ4x9LnuIkBlwTEAZI8G5tPNcs7BmJlNDHe0WgpS4utnUqozZOJZd2B44C/Mp5zpUMtox13rC/gF5XceRs1hf1u6t0imQn31kfDcLUex/av8MNhVym3ZroX2NggIfhKKLwEbFamCUs8gVRYaK9wAMKqIaBJbxdqUTefc2AGMtN+rgLNSL4DHj3bzT+cCd+fj/2+fEqFpgNklMapqtSWecFEcxl1Yk9zmaki64ucvfU82OP72A01dAl2CeXDazwtLk0gGJVEP0fvU2Gwnmrozhb3o1lo02F2
 pvZMq9SZ
 NKU22JIiTo+1GT1wAY88WkbwSyAMuTrnpyDXS65/Xe3pEaNlZiWVtDJjpB+e0gWP89fZ1xG8nSn26mzjx3v839D73J0/l9gzGNf/3D44sIsMMZZSqrPowESwpR9ZbseF+pzexlwxdHSZSAFcp345RCL6Af2mTzcoJBVsN1U7GUHzwWHccCW1LN2ryzSPnOhudFPuY6g9LeeaksnG8dTN0o9ju8/94SznkKIYvbwxQOq29lJu5ziYXmAXMPqRjzFNdATmNFdCxkrU3D+sCSFTLoOgZnbWWaNAe/9fB10Ma9cdK5l8fEuXNERgUCc9RkEfF5JkXQVmlFPDfmAbNWsHqxLejfcWO9a9QS6To
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/2/26 18:05, Sang-Heon Jeon wrote:
> Hello,
> 
> Since commit 38607c62b34b ("fs/dax: properly refcount fs dax pages"),
> vmf_insert_mixed_mkwrite() has no callers. This series removes it and
> the mkwrite handling that only it used.
> 
> Patch 1 removes the function.
> 
> Patch 2 removes the mkwrite argument, which is then always false. It
> also removes the unreachable code in insert_pfn().
> 
> Patch 3 merges __vm_insert_mixed() into vmf_insert_mixed().
> 
> No functional change.
> 
> ---
> Changes from v1 [1]
> - Split into three patches for easier review
> - Move the comment about -EBUSY handling above the check in
>   __vm_insert_mixed()
> 
> [1] https://lore.kernel.org/all/20260929143707.450805-1-ekffu200098@gmail.com/
> ---
> 
> Sang-Heon Jeon (3):
>   mm/memory: remove unused vmf_insert_mixed_mkwrite()
>   mm/memory: remove the mkwrite argument from __vm_insert_mixed()
>   mm/memory: merge __vm_insert_mixed() into vmf_insert_mixed()

Hi Andrew,

please drop these changes, I'll queue them myself after applying a fix from Mike
in that area.

-- 
Cheers,

David

