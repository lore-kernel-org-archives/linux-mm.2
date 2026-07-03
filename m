Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57AD4C43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 10:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29DF66B00B4; Fri,  3 Jul 2026 06:22:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 276EC6B00B5; Fri,  3 Jul 2026 06:22:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B1F76B00B6; Fri,  3 Jul 2026 06:22:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E3F656B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 06:22:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6AD0F404D1
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:22:05 +0000 (UTC)
X-FDA: 84947075010.09.91EEB89
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id 93A5D1C0003
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:22:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CMk4A1ly;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783074123;
	b=cbmDkmumRA93aPFrKz7RS81El7NA5dNqHojtWJBp1iOwsAycblGMtgFRm/Fj2kY/nwzCgl
	7t93v8NAwgMTOWlrrOcvDuxcKXiPPAZE9FD3UZbsaMZkWKlF5hdAxDqN0UuuDKCpDs5doP
	JO/HMshuTtdZ+ziP851FkEZHBguPDRA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783074123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UCfZx+03VuKV5KbdUrtfrc62wyaRC4jJXsUxJMuOZtE=;
	b=sdpO+DYbsXvgDhogKZVWJz3Kd0nA3uevEZzaVV88TMR+Fx3b/hgwWBZuZsk9R0lP7O0JVh
	uuP9EF3jnzuWRKBPABe1aXTvHGB6fDApWfMLbXGpT9sSUsE7ouOmW7X1j208ghnceGFGR9
	NC+Mc/lqLEKti15h4n6uaPtgZCSF2lM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CMk4A1ly;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783074120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UCfZx+03VuKV5KbdUrtfrc62wyaRC4jJXsUxJMuOZtE=;
	b=CMk4A1ly+G2fYCzb80TaV1guaJXcy6PlhSjXm3p4qWf1/R2OD8c9r4vd9eNv1x7a0QsWTl
	6kWJLBYz+9Di8HDqfoG42cZ62OTRvDw3DJ2HRNdjFrOze7VQgLt0rqclImDT+cPIfJf4AT
	WSc1439mr/Rg1tRkc2IiKavDdHBiyVs=
From: Lance Yang <lance.yang@linux.dev>
To: usama.arif@linux.dev
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	ying.huang@linux.alibaba.com,
	baoquan.he@linux.dev,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	liam@infradead.org,
	ryan.roberts@arm.com,
	vbabka@kernel.org,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com
Subject: Re: [PATCH 1/6] mm: add softleaf_to_pmd() and convert existing callers
Date: Fri,  3 Jul 2026 18:21:50 +0800
Message-Id: <20260703102150.5461-1-lance.yang@linux.dev>
In-Reply-To: <20260630164143.1595669-2-usama.arif@linux.dev>
References: <20260630164143.1595669-2-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: tkc899bgybyxxt55acokyi3des5yqkb6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 93A5D1C0003
X-HE-Tag: 1783074123-600751
X-HE-Meta: U2FsdGVkX19M3fenlp1KJpkRkzSxZPVqcaoql2z00wBKzRNHpEXgD9wQF1yFdrwQFWHkpUusrelcaT9HFyGNWReDzp1KRr7AnlH881PlQXoq+OEvShoXby0Xx4DZ4Sf2tQv/xPLn3ObCkgYBSvxMJY/OjujtTBGpHSWPa3kkCT8TkQJ2vy5Li9OvbNTjrWZwnGn9g9KDS9Uvgg87YxVA8F04qemEkLghieQ1c3ciX9UqniKsgc++rWroIOjMzq9brNHWbRK3zrXvgvDmJnU6p1bYFUhvLrfnYxD6ZjgAYjLHpoZOTPQ5SAyjTcmo92PcjvYB1nIclxGa2gABC1A3qK/VYfv15d3gByWxqv96IqDJtHELI1LhpvRy8c7V9sLfn23OdQsPurTuwzeqO2xb8EIm4pK6xjnE4fdCUpFtCnVfCQCddmh3b4fqpQL/6NK8VMXjFc8lpAuwNbKb267dmFAODowTdzpHgBAuPj7P0AOukOVt7PElMGTjYOidh+HVu8DymifqX2XVvw9zCWrDDr2C6HlRyWZF1v9ehH6T2uY64bZS4ywjAMItBwNXNx9HE9qrAME98ncYJeBvj2hkGnfL76xFBWntdkR3fYIR7eCDbmPDvEMxaau2I301cqC0OyGX5q+xqevrGwpj3NzBMr5WV+0j5/94c1j8Be7pVRW40ApZTfhrn1G20XTFC6ehSy5qxmHas3YV6e/Mqu8dHarY/19Ma6wUftqNxLTdEtdGCarWPfR7+WG6RVdYybLzI3USLJiDB7JqBK0DpSv9fREHAfHWEHs6XMM16YB2uiqZzeIO9L/7/JPNnYao8wmPOLmxAwxK3aP+IjFFGtFCGoorIraV76fC53K0CXdkDw8zVmAbgfsrr0mJkk1fzA+okmUEQJ1x9ECZ5dlFXSXzGeX/ccDd2W6d4kx51TW1d9pKqvuo58Sr1PiF0lQSitMdVhydf3GVMX166RRA88E
 Nx6IWl1e
 gUPyDfpUk5baju2OeZEjZ/MXdYRevg0VPmNrPPl4PnGMDhvRSizC1rrxKjW7BY7yYsOcMzJMPvI00uRa8uZ6uDPobJtVxCfnc0D7sSd98ypbT4AkHxNiUmQ7gM4JvcRVNjTTCFt2l/x9t6VdLFQkF5hHS5BPpmq7RREQqrF+p8zjzgH9VgAUwY+RLLLanWJ2tlgTL6V9w2ACz+ASRxo9dQe6n6dAQZSApIxLRr9qOgrhCY6maIAhA5bskqzaUJyv7ztqbJuQsEnkQlxZqtXGgfK9A+fn5xfmQ6g4fhnfqQDoG3NLV18ZDDmBEjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Jun 30, 2026 at 09:34:38AM -0700, Usama Arif wrote:
>Add softleaf_to_pmd() as the PMD counterpart to softleaf_to_pte(),
>completing the symmetry of the softleaf abstraction for page table
>leaf entries.
>
>The upcoming PMD swap entry support needs to construct PMD entries
>from swap entries. Converting existing swp_entry_to_pmd() callers
>to softleaf_to_pmd() in a prep patch keeps the feature patches
>focused on new functionality rather than mixing refactoring with
>new code.
>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Signed-off-by: Usama Arif <usama.arif@linux.dev>
>---

LGTM. Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

