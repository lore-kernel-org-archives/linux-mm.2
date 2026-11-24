Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62266606A329
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WzV0GS8z
Received: by kanga.kvack.org (Postfix)
	id 8257D6B0795; Tue, 24 Nov 2026 10:58:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D6976B0797; Tue, 24 Nov 2026 10:58:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C57D6B0798; Tue, 24 Nov 2026 10:58:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 482886B0795
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:58:14 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 87DD1A8955
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:58:12 +0000 (UTC)
X-FDA: 85470469224.27.72063C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id E9556180003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:58:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WzV0GS8z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795535891;
	b=ZZ464u6KjkLYHy0bcx1Hf7SEMpkzI4fWBa1glBEAZVCHFkxd+dVyQLHLW6YPsK9lfhiRGQ
	HToKleuTlv2YkjdBB31Lmr3BQLbcsxBquLT5lt5d4eBb4R1uITETWSNpGSqXmMclkmG/qP
	I1TnWxrVLg05zLBq4mX+H0X0Nzi5dAk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795535891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pIDEOjbq7+ZKjdjmkL/WuaSrdrNA5P329n5oCOdc1mI=;
	b=5f7vl0LUYD5muNci0dIleioAYd3Xg42HhIw5oTkaltnzL1KmTeQAZyKPPrV5wrdluj8mNf
	a/aNZhWonnSAmkO1g/Ylvi3f+4vLvtbGUJsAWTrzUydE6cAXNqycDzyhyy0Fiz9wvkkfKG
	eGouQMNU1kwcgRYFW5uhdZNv8zc6Zpw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WzV0GS8z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 81F93601DE;
	Tue, 24 Nov 2026 15:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68651F000D0;
	Tue, 24 Nov 2026 15:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795535889;
	bh=pIDEOjbq7+ZKjdjmkL/WuaSrdrNA5P329n5oCOdc1mI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WzV0GS8zHavb1OFv0CO1J+MIVGhMkE8wteCr9YvLcQ9aNqWJv8gqMkrMMPRSKkymt
	 BEkdel8+bZ8C3ox0N6XRuftLsrJF/RuPn9hdn6iRTeemIUKiSzp293OrBxf1TjiN9g
	 rWx2ZkO1flwawt/+BdqA0vsQeuUyIs8R/mzMjr2uIEMBofdv2mZXAGaErHrZVrku0G
	 6QV6jjJ1iYqHdqV6VUUF7OA/cAEmRb0W38AhpynJbExx3tVdVmK+g9BhloPm/ABYYW
	 0w+9rsA2vIlSz2/CJ9ie0OPwJEk2Z5wpOO+JSPiUbTrTwK1vBoKymKPjPrTn/qHuEn
	 c9xRac28REvvA==
Date: Tue, 24 Nov 2026 15:58:00 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vma: drop mm asynchronously in vma_start_read()
Message-ID: <awWz3nc_b8x3mIXq@gremlin>
References: <20261124-vma-read-lock-mmdrop-async-v1-1-257f99f551de@kernel.org>
 <awWLCZ-jBjSD7V3M@pedro-suse.tail5790ac.ts.net>
 <CAJuCfpGk6eYK43Unxo+O4ML5=GM_siZ9owp6oa9fO0ipZXVg-g@mail.gmail.com>
 <CAJuCfpEd1rz3P7fB7W_mHkyzbpq9TscRE+QNwvHdYME=WJj6cw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpEd1rz3P7fB7W_mHkyzbpq9TscRE+QNwvHdYME=WJj6cw@mail.gmail.com>
X-Rspamd-Queue-Id: E9556180003
X-Stat-Signature: t4iauctgttox4s76aahxwfmxjqu494em
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795535890-586560
X-HE-Meta: U2FsdGVkX1+06rZ+nwddk/nhOFdlXm+nZfX8B3yxyj+vt0wqfo3moC5wHG1jLiC7z2YWXuaPIzMHJZbtAMQfXcfR/yjSxvR0WiHK/SwQtC93HeMWafvNF/rD79xyzTX35p36RHsDI4uxg1GisxTxpECOp1L634hN/+xrc5ILCEVDGRsVNwGqM10tbSYi5m9t9erdJe+D5HLstyIzb9szOt7SoWAg+15Y81qK3MYrrRIU+IxSc9ED7CYPxy324E1pGO62dn1OFZCZHP+K391hjyJtxO7s10Qaa8BGMIXXuerbCAgmWxXW+JXRrihxwWbYlJOp4WlbSE3yVBewLnJbkubQK0QJhTAeEj8ApX9ObxFboIgBr5RPkM8FoTGumtSD5waREOQx8QDS6kQ6vO/Zlh63cVagGllOJopxXYfGFjHzgW0a08bmJmREgF8G9RiQuSak3MUATo8JCTBCJDzZjviV4HuDs3dBhjs4jy6eMNvWK+zWlw4jkz5PGAw8zHR7AxPTpEJ7NqX7qPwsuFfyK3QhRfrATaDA8E+IzFybZgAOoFF3WXxxGOz+iVx+zThvWprP5GD5iNCv65KcGmQA1gZqNOVHMoIZ7gguNPo/5HjHP+P4mgVKWSmNTsGYoy++kugUiYokGoQcnoNh7mkxGjz2wIj8fmFhsWWl5/+tCLwiXMOfudQs9yNhyx9MXBNyBL5H6QdvqZR+d/yqUAqRFIMqeVWmOPVdbQiLl9ytpdrRrFZ8u993X3m3y4vbICgtkKpH7+Pu+qGYgXRWGwZVtnGV5Di+S8WGke2ZR7gPO4bVgyVJKWeO3Wq6u4gsB6s2HdcRFrVYGooZ0LHMJcE2lzJrknGtn+UlqE0EcPlC+aphySy6l2pTPZw+jn9rrfKw9dIKCS1oMhJMhbkGlTQlTtBm8rURVcCYF4mMSTP8hdknKdwNMrEeA6JBWun39VvNGfeg9GjQ/xHUL9xzxIu
 DnppJWf9
 5tdTXF9wA06/NLtLbel6tZDHx8LHpYLIHuuitQDTEIAZqjUbZbFgFi8HP7RLdEQB+sWQGFWoyTsXOiM7Q/yCXzZWvglQJ9gwqWvAGjfPgVz9tyTGh9nQ8ZtfE2cvb7II81WIW+T2VABJXusgYr5pESk/BBYP3LSHcyrQFwLE5Y9fZ31DfdtmjGw10sYCzmqhVR96xmJ5d77Nkc5xdmnGkMYGuHo1xbaKYgxbtCn+Kb8CtTDHq0frCEauVpIlzHdqoVNT1SWXtKozLunRIommnAXgoOY57Nw3h/69xOAhSxR8w9xcRwuLUbmA+Ycy8ceSxllA+Qf+jXEIaVR8PuicJIxTi7q1t2LViLqMSEZ4lje8aFQAjFQuRPFCkIrys8ZUjqCMoUJEXDBHbfYsj60oqhgcjdAznTg7Z3XVjCi9Mo4iJaWBWk8kuMmE0fEQxi+111F2fJ83/IBMQeYYkMwU7T+/9lPUevk8bXwUMnQ3N1IuN6DaBrfaR4Hy/JRc9644wZdrU7ST5gk2/7cxXifcjq93h2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 07:51:42AM -0800, Suren Baghdasaryan wrote:
> Actually, VMAs are allocated from a SLAB_TYPESAFE_BY_RCU slub. With
> that RCU unlocking move you don't need other_mm copy and the comment
> that comes with it. VMA won't be freed until RCU lock is dropped.

Yeah but they can be reassigned? They won't be _freed_ until a grace period but
they can go back to the slab and then allocated elsewhere  right?

--
Cheers, Lorenzo

