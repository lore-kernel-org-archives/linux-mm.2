Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEAC6CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 17:11:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121486B0005; Tue,  2 Jun 2026 13:11:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D2126B0088; Tue,  2 Jun 2026 13:11:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB50D6B0092; Tue,  2 Jun 2026 13:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D69BB6B0005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:11:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 842C7A09C9
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:11:51 +0000 (UTC)
X-FDA: 84835614822.03.F75BDB5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id C85A440002
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:11:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Ak3zR7eS;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780420309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pcaxoqI0f7sOWzEqQgUXEtGFp48y+8Mb3okU4L2UxDA=;
	b=tPT8Cq2xdJHvY0xruvaIMy69y9iGovRVEukEtyGT9JYms5mCbsAMQhUzDYbK8l3ykgQSan
	gz2LQuAVFQbks9dZPqjTlhd1B05QXXKII78ijzxqB89Su/idLlUMWxQIa1H5dwKBrFxf5C
	LGE2758wkOVzoeGkBlaEabuDhpyy+lU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Ak3zR7eS;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780420309;
	b=1FNnpfcWLSLphcXqocLV7aiH297YbuWJVh1fOAymN9hs7IEtYSFboIWURVDvD/GpuZE9bF
	lVszsvvnoQY3y821hvJtMra/pIBZ9Y8vNwPeHumfrCFttYurIdUuqAY111BG+O7dlMge4+
	d2z1/hhzraBHhscIGffblPXxNCfPB9o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA62843890;
	Tue,  2 Jun 2026 17:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249931F00893;
	Tue,  2 Jun 2026 17:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780420308;
	bh=pcaxoqI0f7sOWzEqQgUXEtGFp48y+8Mb3okU4L2UxDA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Ak3zR7eSQ8XRn7FpSS1z0ceFI0BXPJvJNIfih/4tmhYRS84tWUH2ZDPkuhm5N3UX1
	 TicFJKCCSbYQWUlNxf+NWzu+8pIc8SVWD0H1yU8ArROQ8cBdrEP2s9lh92mptyO4GB
	 pLQ9J2DrF+KVNomVfNNciJoxnCyOPPROiZKhp5HQ=
Date: Tue, 2 Jun 2026 10:11:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Kaitao Cheng <kaitao.cheng@linux.dev>, Vlastimil Babka
 <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Liu Shixin <liushixin2@huawei.com>, David Hildenbrand
 <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v2] mm: page_isolation: avoid unsafe folio reads while
 scanning compound pages
Message-Id: <20260602101147.2892436f68fd383723c39855@linux-foundation.org>
In-Reply-To: <34F0943E-4ACD-4655-B9B8-41F658FCDB7E@nvidia.com>
References: <20260602130755.38794-1-kaitao.cheng@linux.dev>
	<34F0943E-4ACD-4655-B9B8-41F658FCDB7E@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C85A440002
X-Stat-Signature: t8rgxxydrbfzsf4qe6rk65shpnb6iwgp
X-Rspam-User: 
X-HE-Tag: 1780420309-165774
X-HE-Meta: U2FsdGVkX18h/Vt0iEJV6RUbuBpC2vvEGMbB1YwvuEJrzon5PSRytdv/9C8IDDg0a7bOc3+ZzWs7JWMpkwAriLtJNIJAPVXDkotQx48mM104pLzz6hcFwnfPlawNHi8Dpxj32stdkM83SfHfVEi0pG9mxAtezj10+ZQ+uIziHHYBTpwuMhEsbPNBVX+k3H/wvPF+HWE/yYI/AH6nPwBJjeGKyRYgRfjEfR+v39Sqx0hlUldUMtvG7k5NEdRUhLXy1bwfZs+imhAmoXHrBUeCsLlr5Hf5G/OqETRS5JNWyZFEnNVLmA4irjFOtR58EcCH6wrGR0IaDQkZBa+C8582XxYz+/PDRz6x/JdmvyHFEVBvALd1QGJWMA/z5GhAfrw0BUlKxU+vM07x4GOhiLXSEJTcZJ4Df9z4+mgtT84L/lkYwgXRSe8LE96t2UhVDXa3OxjxB3m41bQfH0V/n7pzAHNL0PvbB5ryS6lzv5ENALKmgAV+fkuVlNN9MjICxROXVMW2UnA4Uzug5HwNNaUd42VIHmVA/zcem0JTvtfwU5aAM+Q1GoLHEJ0TWk5hDY8BBikI8rXBbtQx2Q6q9mo/Yw/zXItEHVw/AVFd98zCjkhjYV4KAxuO9aqqojlPnUNfafvy37JBAuPGy8dc9kGEt5cQz0u5SCcnlvSILBDyuyE4vsyHvPyXAQK2kLxhw5HnOmsRsuzozd6lr2tuf8VvAnhQHRaMT2V5D5S5RGa4XfbkjVQ8sd5Vw1dMUj9yNJE6oYzcWUsOdBYpXdepqlUF3d9uV+Wc3BI2A42yv1VUG94knyoNJBYKmjxIJDQMmseXdARFC6d03YLpmTjFAWfSt/hmtV8MzTnq73hzHVBoBIMSentNiQKFIlGJXZ2AgjDIOK0Bvbz9TIWGtsVPLZ/reY2B1ncmON1v3eMHZHguJEl3ajK6CQRZP5YiFaOFh0niQz6Kw5m9POpoRgV/L6K
 YiI5cDS3
 fdiRll11qO6V4LlfAx7iqnryOfhYJpzCbYLWos4kTBlHTRmjoIJRJ6JSo5mVQYQD70fe8wPx/qXOQFGImuoPzjrTo2xkiX84A5hCsTRuQ9kSEotNewbA+l9x/iWJ0JteoxC7e6iB1XBOvOtKblCEiGLFyGEysZpWjFuN9pcBy0SRsG22Upr8fWBthD6P11+5zu89cCFalLTosBlxBHuiYtvnVWmroVan5X9iVS/VZnfmmar/yJ8qJDCBs8IVdb/cjd3T98jna3XPwtb1EJWLONwNdGTaewy61xPKcpUuJc2EE8o+w1De63OI4l+l9XeAXAfVzPqFEjx2ziQLqk6P0At2O+3/MFOjXH0JQ3QvvbJiZLBXfPtQ0lUNeuK7HgariERyQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 02 Jun 2026 11:02:41 -0400 Zi Yan <ziy@nvidia.com> wrote:

> > -		*step = folio_nr_pages(folio) - folio_page_idx(folio, page);
> > +		nr_pages = 1UL << order;
> > +		pfn = page_to_pfn(page);
> > +		*step = (pfn | (nr_pages - 1)) + 1 - pfn;
> >  		return false;
> >  	}
> 
> LGTM. Thanks.
> 
> Just a comment, order can be dropped and use
> nr_pages = compound_nr(&folio->page) instead:
> 1. order > MAX_FOLIO_ORDER -> nr_pages > MAX_FOLIO_NR_PAGES
> 2. PAGE_SIZE << order -> PAGE_SIZE * nr_pages.
> But it is not worth a new version.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks, I queued this.

What are we to make of Sashiko's question?
https://sashiko.dev/#/patchset/20260602130755.38794-1-kaitao.cheng@linux.dev

