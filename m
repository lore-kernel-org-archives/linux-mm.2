Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6599F606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g96uGOli
Received: by kanga.kvack.org (Postfix)
	id 835B56B05B2; Tue, 17 Nov 2026 11:22:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E64F6B05B3; Tue, 17 Nov 2026 11:22:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D5876B05B9; Tue, 17 Nov 2026 11:22:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 49FBD6B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:22:20 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE408404EC
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:22:19 +0000 (UTC)
X-FDA: 85445128398.18.9F2F2D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2C437100002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:22:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g96uGOli;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794932538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+u0XvPm1yl8lpppCa0o7Ub3ZqbKbjWd/kwvQc+jK5VQ=;
	b=WFIiYDOdykjpTLHFeHmDlbdpCKf69oA0LINy8V8nrdLPeH3gc1KwwaBthiyMSiKvnDBQTr
	/d2dgyRNm9PaV1sm1QWAHqCKqn3vV1YYdew1YC/OkL00RY6UgLwkMwUpwwdOB5tXrbF3kU
	NADNObAI2E74NF5WlwEzzSHbff0RBEE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g96uGOli;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794932538;
	b=AfBKeH/9bxaLXbKpSC+oKLPPRBrktQlrUPrNjGjuzxHHT+LGqbfwrRg70jkX752axDQ4ee
	EaPrKwoVlfZ8YDXCRC3BEqPIa7qDEaqHzfotS1S4fZIpzVUgEQWo6xKz6QuWPa/ivJRa74
	dRp8Of4Byzw0jGOEpOM6KCKc1dvTD7A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 260986013B;
	Tue, 17 Nov 2026 16:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6DD1F000C4;
	Tue, 17 Nov 2026 16:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794932536;
	bh=+u0XvPm1yl8lpppCa0o7Ub3ZqbKbjWd/kwvQc+jK5VQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=g96uGOlizPLYBJJRsK+FTKMmsGeaNP9VPNN1fuNODhjDw/mG0D43hUdrwZTpddwXG
	 /Z0UTEUTIEf58Z4VAJm4t61vIFvRFe8eVZPefJ59dIlSrGdKf+6WU9weImo6EUMpxp
	 Nud1h3CYvt8I76Xw92EczkTMlNHu06zUMdsxIr87SjSunZHDXDbSygpMC2PxwFhGGQ
	 z+ogIJCU3dUL0HMPmecWdGOidfpaA7GjVehQQBsmfnrQ+e3SUhi37Xz2yx4dAqWIDU
	 FXg3tlRB32Jaigk0PJcQaM29bbqR2EJjTvUMCxZrq1+A4G6YR1XxJJi9KNsaMt3wJ+
	 Pb4XFPmAj2i5Q==
Message-ID: <7ae17206-829d-4fdb-afd0-cc14c5411b74@kernel.org>
Date: Tue, 17 Nov 2026 17:22:09 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm/memory: fix handling of PTE markers in
 insert_page_into_pte_locked()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Jingyi Sun <1045704958@qq.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>, Peter Xu <peterx@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev
References: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2C437100002
X-Stat-Signature: 8nia667srtw9keo8unmbbmun6kfxhwe3
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794932538-129738
X-HE-Meta: U2FsdGVkX19zp8uh6ZnGTR/ByhR5Mq/BxRMIedxKDYOApzo2H0k4iloH7l0wcMrs/oqo+98Fb/Y7vj0al5O/b2bzX3+XUW4jdeDprp/XJmkL9cpfH3qSvnjQVdE2LUbLSGuVIE6QUI96N8MUo0CHa+oqnRss++cl4NoTm5ZwyP7Jhbr7ibuScLzAQfPdjdtzPAyhN1stj1UHEFZeD4C5BhX+optOXWFbVeuirmnad5yeLPVl6+8Ib3+gWOqeFHKRkg8gymDXyp+4PAHImOhr+QZp9ZvStCL7Nhk4Yj6NzQdM27rbI+N8eMAnL3NOoyQhQtIPoxiOAfaUeiUb327Gy9uwk4BLeB3XIigO7ZRt9yYOEZS6D6IodqBI5qULbZU+IuyDEE6reoEIz0CX3ct1oYXnIz3b0rqK+zCv6EFNJGh9cXTzGJJuNc7p69NkIfKn9Bpft1f0vtAwZQBFCGOy+o8nT0GUWW4NE2qdNnOg5C081NWNew+83SdBw9Cx3cnN/ai2yKwpaY9J3l2AEnwDjjueWfMCyEsFIMFcwWVmOcrjUenM0Fgi4tQE2JXxIeHnLds8ZWU7UmOQShIsTvR8WzdGKD3Gg/mVuerLMRBEdmVYYzlyXFBGDF5IXpmO/gU2BkxyCfgULu4LAhK7hKN/vvy44ydAdWWROOjCgQQ69sOlUKA4/SiBBX0GSjTdiC2fcOcz91vaTI78ui7HR1TEMwUk/vLb3REXwr7ZywcJezE3Npf6XbVxXhT2SqeWac28bmx1QEPwwe47Sejop1p8J5LvSj8ME78+q/pRLqKQHbR1pn2nJXy2eESYdhKhLp2ZwAm/brR20O3hhlmbq3EqF5vwgpzIo3jMFPBMYnvpNudh46yKLiTpKEHo6xMWS2mle3IDAUnX8m37+p0QyyATxIYW62HXZvxCjqHHjPBsQTiScJdbQYCLJklgBuGSEL0JhcCzGp9Y7MsniTq/LfN
 Xt68VMBn
 O1j3xjHNGdYvL7R3MSxr0nvsrz223LwBo+iDyEfAQ359Ls2PpLNo8iZEttsTDN3cpsybOVI5csroxVYD9hpApzXCGZF3aC6BHho+pqbGokrDa4Kpk+tGIW0YOkibrk5sIHyRPHlYBJPz1t+Q7Ffpf8xlBmNEmRM32t/kQiypT40ZIXfkqs3hdr3oVKf7V7pqelzfGBx7MA/fjJetT+hjH0AaLSwrUbVchM4lNIjlwD+SiEsPNyUISIFG3BlM40UYc6oOnsuFPw5Fz+gkKgXiLdQkw7I74SR/ubgMBOLYqrGD4bswIQLRdEEoBA9TI5/z1xTGwTHHRWwncoTe5W4NTm8dvnq450GqFfvBo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 16:58, Mike Rapoport (Microsoft) wrote:
> Jingyi reported that a uffd-wp marker in a DAX mapping causes endless
> refaults on reads and SIGBUS on writes [1].
> 
> The root cause is that insert_page_into_pte_locked() treats every PTE that
> is not none as a present mapping. Besides uffd-wp markers, this also
> affects guard markers that MADV_GUARD_INSTALL can put into a DAX mapping
> concurrently with a write fault.
> 
> The first patch restructures insert_page_into_pte_locked() to make room
> for the fixes, the second patch fixes the reported issue and the third
> makes write faults back off on non-present PTEs.
> 
> Both issues were reproduced on ext4 with dax=always on emulated pmem, and
> the fixes were verified with these reproducers.
> selftests.
> 
> [1] https://lore.kernel.org/all/tencent_1874C71D4177A1624528043E008DB1A5EF05@qq.com
> 
> ---
> Mike Rapoport (Microsoft) (3):
>       mm/memory: install new PTEs first in insert_page_into_pte_locked()
>       mm/memory: replace uffd-wp markers in insert_page_into_pte_locked()
>       mm/memory: don't upgrade non-present PTEs in insert_page_into_pte_locked()
> 
>  mm/memory.c | 68 +++++++++++++++++++++++++++++++------------------------------
>  1 file changed, 35 insertions(+), 33 deletions(-)
> ---
> base-commit: 93d7a816a2df3e907e2719bd12b0073f1285fc5c
> change-id: 20261117-uffd-dax-async-wp-fix-867acc8dc78f
> 
> --
> Sincerely yours,
> Mike.


I have here a fix to disallow uffd on DAX entirely. It's completely broken.

I was staging it to send with others, but I can send it out separately.

-- 
Cheers,

David

