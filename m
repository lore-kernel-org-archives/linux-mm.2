Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 807CFC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 00:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CBE06B0093; Mon,  3 Aug 2026 20:01:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77BF96B0095; Mon,  3 Aug 2026 20:01:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69E3C6B0096; Mon,  3 Aug 2026 20:01:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 496A46B0093
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 20:01:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E090216084A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:01:15 +0000 (UTC)
X-FDA: 85061632110.05.D33DA03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4485BC0014
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:01:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IlBFQwNa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785801674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SrYwbPOy2yIk5FHEvKwglgY2XVDGPUlhU0jiXIg5xrg=;
	b=InLBo+9wZzX6D/xLkSlBa1bNcIQo+HCR95qTFrw5pETJYGEp1Y/9pkraF9bySzlEAjhD9/
	j8zsM8m+RA+n8KR2kU2j/47CKdXR65DFB/4EurnC52Js7PSnFUvIEB6gBegmTWBe4J3/qM
	5kLr6iOgIPHgCl6kRLx1L99kipUToms=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IlBFQwNa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785801674;
	b=fGpydqvC/DIVVsaOaGkCGr/WOS5/F0HDnYBpazAsdh+Fhg+6Rpy/QCjuhj6CGO9nOhheUi
	EZOWyPk6UfPgzAdsyMqF4StwaIuvYTmZKS7WnvCe+8ESMHPnvyvvdMa/YaVcLNigPLh83B
	+3ssdHCR1QA4cE4ol0aOyJk1QHps+jg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 586E24323B;
	Tue,  4 Aug 2026 00:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7141F000E9;
	Tue,  4 Aug 2026 00:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785801673;
	bh=SrYwbPOy2yIk5FHEvKwglgY2XVDGPUlhU0jiXIg5xrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IlBFQwNaqpm7L669/HlLVm5IY7RK+ZyhVhr2wlWZcfE2ruqfov3HOSfpBdMGygSEL
	 Mz5IxyTYcIE6mmym7kFHlk78ECyss49H3UmlJs47PvjVEABPcuZonRYiaIXkz7wSgY
	 vNxxceaNwYYZHRCewK1dgDKvO8eKikO4KniSDCr08v6CMzfHQgqbUCR55bMew/oOj7
	 LlZqfTJusXGFaiqbWnp7uKq9ObcF8BDR1KyyztH83FOQCxN/dblA4HlOG9qbFGUo1z
	 nN4wttmEw/3SMvdeYuH/JFNGblzW7mLMi5693/7fHWMEvYKgw1a5DTC2kJPAMpHDnR
	 Q6JoNH1Nk2H/Q==
From: SJ Park <sj@kernel.org>
To: pratmal@google.com
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH v4 2/2] selftests/mm: use pattern matching in .gitignore
Date: Mon,  3 Aug 2026 17:01:03 -0700
Message-ID: <20260804000104.88098-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260803221732.3651981-3-pratmal@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tbg8y91qa1odsdt4ezkbuw3uy9q7rdcq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4485BC0014
X-HE-Tag: 1785801674-684749
X-HE-Meta: U2FsdGVkX1871gjosCo2yXAIJXYpPUr4M6BY3sAWRKA4rWn+SCNFC354KUvWU3nAeCd0a7JGasqFp6JoTQ4Xqji+LeeMl3/O3BAM6mCff5+JxzNNHDH/Bhrp3FppPxUoZfvVzaSk9K15FcfxURWWEgS8OJQsr0OI5oDC56FSXtWzqmISlik9oEogJga9HZEAKMp6gGcoX24JfoW/geP7RBsZenPJvjXZDyuoTikdxZSsvAtcZWNvsgzhj+zm7jJxxupfKib9GDHScl6m788PM6skYMnqM/SRXHgOt3UoZbPifXHdao7uR88hXvCclxpa4cA0ZnKc1N8vPjtIJiQkKYOeCzHn8pq+B55QAQ3CvUNB/bxr0mNQDvVoyrbKrEE9FklwzLvRL/MxU2a21NmW+9Gx0Elq+oG8rmTQ1fvw4UZH4/P4bCjUGi8j6frDPYRadqxxSkqMlnx4DCiBepgTl3eElNYBNVJhMTtJbWuEAnFxAqaBwDzUT6tGgxeFO/MXBCtOOj5f4VGKBueEid/PYICZ6uWvNHWcpo05OiiBYaNNryGc/vuUxG6e8pwUdvaqdBZwVkpe90wOqKZTaQ0p1gDYD2L4dayW/E0kSowbX8iulXJS23ffl27IuRZtiEJSndy+JGKKEonmHtWYSZvN+3p675DsE+FDR+Qd111Ut3hfGgQcOfheJxugrMlW7AjTRenLLv8uMtOV07nwVWR1RhfWpwEr3H19p6/oy9Zy6pZafwFE8UlJNSNn+fXX61u5Jolz6xPH3lZ3fv1luxR4K2Vv4NG/fL1g1H3Ca93o5SGUvPmVTvCyhTI9NbHlKUF47H1GAcTnr1nqcdLPCIj6IvUSRK0U13lsIEaDSES71OQTPYeSVaqGJHHw+y5wWVqAlFW7zaE9lZJ8qW99o/fjjf/8XhQwkFvyqbpbkTdgBu0PvrAlZthdoyBmX62GlPQhVQxyWGxvQqQChmLQMaC
 NmfwMqJ/
 paKGLoRD8vM/TVCjc+YWNIjya1qHFeZDetUmV9tBPxNLo39Slyel/8rO96+CjVZE2oM9D/eoJTOk/uvu/1xQBn08RDTYNqFMBS3wKdKzQ1h7RxEzDLkUpLOtV1p+vGji3zAhgXt1ylEoOXjZIZOzCPmyOmgjQTUZbkKQrPMr+WQTfcNxwCHlcgiolQH9s3E+yS7d/5A57JQsc8w0+fdMvPkG5GYnLUuHRu/N6aGlbFXLSINTBwqhvngTeb14SrYKacGsSrJ1VYtLT4oMsMw5r2156ZfN1o3hOUatbbpgY4deFk7BKcLGnWtZknKEkruxaEw5U2bWCHRRFNJQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cc-ed Liam's up-to-date email address.

On Mon,  3 Aug 2026 22:17:32 +0000 pratmal@google.com wrote:

> From: Pratyush Mallick <pratmal@google.com>
> 
> The current .gitignore hardcodes each generated test binary by name,
> requiring updates every time a new test is added.
> 
> Switch to the pattern-matching approach similar to KVM:selftests.
> Ignore everything by default and then allow source extensions (.c, .h, .sh)
> and tracked non-source files.
> 
> Note that local_config.h was renamed to local_config.h_gen in a previous
> patch so that un-ignoring *.h files does not cause generated build
> artifacts to become untracked.

Looks nice and smart to me!

> 
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Pratyush Mallick <pratmal@google.com>

Reviewed-by: SJ Park <sj@kernel.org>

> ---
>  tools/testing/selftests/mm/.gitignore | 71 ++++-----------------------
>  1 file changed, 9 insertions(+), 62 deletions(-)

What a lovely diffstat. :)


Thanks,
SJ

[...]

