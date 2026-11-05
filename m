Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B09C0606AA4C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Op6BjMZv
Received: by kanga.kvack.org (Postfix)
	id B24A76B05B2; Thu,  5 Nov 2026 05:14:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFC826B05B6; Thu,  5 Nov 2026 05:14:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A13926B05BA; Thu,  5 Nov 2026 05:14:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7719B6B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:14:29 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC1011A09D5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:14:28 +0000 (UTC)
X-FDA: 85400655816.24.8E05781
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1C91F40003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:14:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Op6BjMZv;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793873667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cJgR5aeVC9lcVT/bd47FaWkr+JwpenNCqv7QqD2q5Bs=;
	b=lDA3X3Fi8KPIC+NXkyv/viLAAdO+tk75+oJ46EWV8ykcwiFgi+7HOipFzj7N3eVCxMYZX2
	rY+77QlNSgDnJ+yululsvacgzR15M7ujw4qj+vvmxLErz7telMl68QZMJpCnmmYipStdGP
	ZtkSc1QUrbSZLX638bXXVLnY72xdWbI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Op6BjMZv;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793873667;
	b=8IDY01ULgszhspkYPbqCVNUL7zbdng9g+yJysXDMwjiyaD6OaXU7Bz9xGFRqEgw+Q3NbVf
	TvkXz0xXNLq8VqeRxHNkhvyUVz0hPg+/EoaPgDZ/k+PLVrCAs3FyEVgGKK9B4dunCe9LdH
	wYHPrbxxOml6J675iNt+esl0e/qd1dU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D76643C6B;
	Thu,  5 Nov 2026 10:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1671F000C1;
	Thu,  5 Nov 2026 10:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873666;
	bh=cJgR5aeVC9lcVT/bd47FaWkr+JwpenNCqv7QqD2q5Bs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Op6BjMZvEwsjuxoAUkC8Ls8ldus0yPgt/yQbWwZwQRMcFlVeybfv/RTgIihY90P0o
	 6hwtujh/xZC3KmXw8CKUVrH9CgBmz87hYk08c0RXE0JnYvLXt0neFtGpI3S1z9ihsG
	 tzfUumbxad+dX5WnRj5f9R1oN3EshlfEIH7griODZMkD0lhOWJTKO5QoQW3rbHExTi
	 7Y5Qe2uzFx4yjZmy+DYdTLx+ZWG1Hgk2KelHad79uAVveo8dALagy/j5GnNTUM+SKy
	 8J/nk4KICNKN3ZUxYzliP+GCsZaZ3nUW6vJ3vTG8JfWfH4DjMnnK3+i+QoLVHbSFz/
	 aWp+hd3ruMhdw==
Message-ID: <fc197480-ef57-4279-a48d-101f5f41f8d3@kernel.org>
Date: Thu, 5 Nov 2026 11:14:19 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm/memfd: handle GUP references reliably when
 write-sealing
To: Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Rheinsberg <david@readahead.eu>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>
References: <20261103-fixes_core_2-v1-0-f332954f1df4@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261103-fixes_core_2-v1-0-f332954f1df4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cbx8ktdz4cxx18xuybxwxffniiwzsqnh
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 1C91F40003
X-HE-Tag: 1793873666-802021
X-HE-Meta: U2FsdGVkX18uR040Art+OdWDUzUPmOQv1twldoTeT1CMiFIZRl46PPFT+HxWLLfmm9Ue3mCGuNWF0MsIagpt8E1S41SqLxt+cR1JQC/7brT/cNapRhpTl6qPl+Pw2PXpGCFcyJi/24x/AX8t6vDIfyFeeE+YRNX02j4AfPkxXJ28EJC0FcbLB2U1XTvQzkibH9g66DYjouJ2VjWTgfzoLzgVnBWSKtsqmhSp7ukrC655IUKW+6ZsWxOzw5rH7MKdIfeqeMyqgauFYFj1lyfbzAMsYNuZtDT+tw657mpYSNENTy4khJOlroxuCpuT65sB/j0rQ26Qct94Z0R+c6+Xy3sCWXqsdubMoZx25h/fHe6Z4f7e3FRiv0+eIO1kIWeLsrdakyfV0BbPo0pTezRlUl8yrIQr1ElKWCJaVhk5Fh994txo03AC4/yprDwBXx9buHYg3spHOegV11B0JgFJAdMzVJJ9yhV4Hk8Ayjv1SwahMiMuiKi1m5bmP3yQCMACDpjlBqnip5pVZIlaS9IXBHo5vKfR71+VjtZHP7oj1YKPQNDMQU0W/97IIlmrBxkM8fcXPoWt+XTzMfLnqkJAeNVhF6cAH8SC+WSOt/C7Dm5ZNlXaKXq/U0ifIBM/nPdIKHQ5du9A1ZwaMob2M6/dTTTlrG1xgFIhO+9TxzTpxnifyz+O0izdSbNKqGgUoj6hG/0fw/SVEfNXZdx9vvNYi1uq8pVzObpJAIEgGl5MjuO6ZttbHAnY3OnvOXi0KNCLkLJzcxwakG/nPa+mUxwXEi/BHrk6vqpIto8eJqjLTyjM+zZePfgp5fnfiMw5v2XOdixjN+YKmiqLJB9rLCRDWqgBk+Jxa+av6TA52f/qFxUlUNXaLUIjaa/9T1pnLgN2vqGAIW1rnL5uYeM9F2JT5T4EcfoqBusjZP44tv9z3X8UzoVUpQ9pqDV32+k++tyPtCFWJbJ96VN4GcVAjTA
 pM4ORvi+
 zr7jJmEAFEBfWetBEXHWqV7YYMGUwK9YsXNblZe7pWx4O2GB510l9YOvZgIWbM+zC14dv9TSzjr/HuzYjac7vderYf/vn/9lGYeBTpFFinbcmuAGUXm8BXtXMUPRDp7VbF/AyyEJxIt8CIyRGxazpr2uKrpokxVfHSluLJRc5l2o/q75eU9cziRtD0TiUbKepGRphS3fTW1nX/sV7rVnzvATvPw7o08eCX5myv7yS3h6ghzAvOFDy49K88y3zNLkIYGC+CPKIVjCmyWXqz6nyk5BsavMENbwxKY6E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 19:31, David Hildenbrand (Arm) wrote:
> I spent way too much time on this, looking for better options. I think
> patch #1 fixes the most immediate issues but something like patch #2 is
> needed.
> 
> Long story short: someone can trigger a race such that we don't detect
> GUP references when write-sealing, allowing to modify content later.
> 
> Patch #1 handles pins reliably for folios with a pincount. Patch #2
> handles the remaining references, but can reject write-sealing with
> populated file mappings. vm.memfd_write_seal_mapped allows restoring the
> legacy behavior if needed.
> 
> All alternatives to patch #2 I tried ended up too complicated and nasty
> in corner cases. We should never have allowed write-sealing with
> existing file mappings.
> 
> Plenty of details in patch #2.
> 
> Did some testing on x86-64 without any surprises.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> David Hildenbrand (Arm) (2):
>       mm/memfd: handle GUP pins more reliably when write-sealing
>       mm/memfd: handle GUP references reliably when write-sealing
> 
>  Documentation/admin-guide/sysctl/vm.rst | 21 +++++++++++++++
>  mm/memfd.c                              | 45 ++++++++++++++++++++++++++++++++-
>  2 files changed, 65 insertions(+), 1 deletion(-)

I think patch #1 is uncontroversial. It would be good to get some options on #2.
With the current infrastructure we have, I don't really see a good way to tackle
this differently.

I'd assume CRIU+write-sealed-memfd+mlock is rather the corner case ... :)

-- 
Cheers,

David

