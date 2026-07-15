Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29D15C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 04:41:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E5A26B0005; Wed, 15 Jul 2026 00:41:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 196186B0088; Wed, 15 Jul 2026 00:41:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0865E6B008C; Wed, 15 Jul 2026 00:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4C986B0005
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:41:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 382DB8037E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:41:26 +0000 (UTC)
X-FDA: 84989762172.15.7B20C5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 13352100005
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:41:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=W2reuqY6;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784090484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VXT4Aj8D0nBxWmP7AWbFJoCX0BgnTx7n4mqxGFSGxfY=;
	b=3g0ZZrZOJgsbsvPrh5h2FqhmoAR4c3BP2ztnXDDAkyiwjFmUglgkFVn8o25VC1l9l5Jyxs
	kT4dNpOK3YamL21L7PNNQHweH3R9dGyHcEht8GVV3Y8K9BKMRygjLejglG0b9nJYyqmiVw
	n15l5f0n2cmFJP4eEAz0Tcku2VBSsko=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=W2reuqY6;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784090484;
	b=b4cc0rk0f87N9JVpYBt9LNpGNrIKhCmjEgOujpS8Hj84QTqtjeNgnSyurqoGeHL8/L9khf
	MwYYe7BxZn4I+tpRui3k1lRotRAXkbXxbkCNuilxKa0mFM/XOTlUqlPyfmjgQFB4RbkZK3
	96q07HNC8XwX/cNdw4D1eDMCToaxr0Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B5121416D7;
	Wed, 15 Jul 2026 04:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6DD1F000E9;
	Wed, 15 Jul 2026 04:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784090482;
	bh=VXT4Aj8D0nBxWmP7AWbFJoCX0BgnTx7n4mqxGFSGxfY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=W2reuqY69WB9XdpPaCi4jiKfr5TQa2U+kzxJO7K9J0f3qhx7/IjmjTrR6e5qJyFE8
	 rm7HTdJqCChCdcMmL5cSFb+G6XX9EssXM6dN8TNTHvIdwczwXpEatn9/1Nlwr7siTF
	 mNm3eenCcrMwaXPZvYdLTxgsfQk1ibJvQh/DbA9A=
Date: Tue, 14 Jul 2026 21:41:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry
 Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>
Subject: Re: [PATCH v2 0/7] mm/khugepaged: several cleanups
Message-Id: <20260714214121.090238f5f0f318f8d82cbaa2@linux-foundation.org>
In-Reply-To: <20260715025941.1571316-1-npache@redhat.com>
References: <20260715025941.1571316-1-npache@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: x1xumderwpudexctw4po5agh1zn6i1me
X-Rspamd-Queue-Id: 13352100005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784090483-900712
X-HE-Meta: U2FsdGVkX1//uICjyT0Qm67+KDf6V4FXBmr3i1KBMr0hM7JnKW29jquJjY8YpgtBDw4iCZy3qkOHn2pwkPDbJfC1cZamTEQOZr3sYj38w/PH0KU4B7iv/sunWIA+4R4QKOimfMJ/slEWc+hILgJo74/TsULYQUFSkvMl8Z+AWRjAp21L+B6WsImoidzH4GGrlzB+EPStPuMoxcZ/XU0uTQfCQ0jN92GbRGsNh8oVKujep6+cx5RtifemLxxNsXxHBWkN62KqO3S5qhrKq8eAeIkaPkQsjJXPj+tjam2hlGgj+1/ZeV0CemAzIGr8T0JYGrNEe66ZyxDNFqiC5ETajFGjTx9m/uPoHw8j1lWT/EXErYf7sB2ekLLHA7I6MU+rojX9DUjTWY+dT1jGoLnYO+bOnIxb0lvLjZRBfhMNYR4SiGQR5W0y99oIwjC3PUuqK5GfrwBCjCewq4AM5WfGhm7qV5YPoevoWsDOk5iwMbQ7nZoEOHHkY2Z11A4aXgSIHiLcnuRyY2q6cc5XQmN9UCFlnbpURF9NmnpYcHD58+AUYzGgfPjP271vCQKaEdMiM4VyIBmOjtNpe6AKzh7XFelF4bssEULwLs1oUmF5HO6oivqUP0WpmTUJ3Irti3mmSE4Q2lB87wqLYQfLtNw/EDxOB3Ua6joy6d4JSv33sZNz1/CIeuXazttjr5CiaHhjYmOIE5mY/TIhWRYaAf74eQlbK8hc+fHEGzmCRC7u1bDHCkn6pvVU2uyQO9YStyQhC0Q7uPD2JJr4Zjc1b/pB3fr33AxkhSdxN9/hv09LpGGREYeuhAixbSkWu42HwNE02HN/bkkq3wm6o5XhZWjXN/mM0jawKOuB9atn280E5uP4ZiqjnFktMpqA7zqYk1hMzBReOifoxtaRnz160jrQLqnt2vVLpNO6cqu8LaFQ8s2WfP/0baRZ6hXBGk7DNIOqbftsD/bifjpuIukHxoR
 bTX3oNSb
 S6AJ3EzYvplqPDv169F51M8wXKnaUPdGKI8f8fkVCr0TDxgsFsfOrqUHWB6t2KgTJnZwza4Rcf3YaCfQbxDVGxULBaLA7/CH6kGqLOhEBF7HuE8sYvzKBia9Ep5U3VVYzJ7o6XPUvzXkcwF3z1CV6/XPy6Cq9kgDSZGgvBBdwC9La9+5qNIu36R/X7WfjjDBdnOw5TEJ9pbIet9QqWXGJRr/i3wmv1x3dB3732a+aSN+9ayQSISfJIV5r9Rzl5FEQ38Bsw4ENFmW7GXYOfodH+fEhBOX40SZZVBRKMoq+B6euxi6F3sBB3XmNxhvjsz0qSTTd0JcEzq6cEWXd30171esnLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 20:59:29 -0600 Nico Pache <npache@redhat.com> wrote:

> The following changes stem from a number of reviews during my khugepaged
> mTHP support series [1]. Some of these are minor code cleanups, issues or
> reviews that we decided to deferred to a followup series, or in the case
> of the more major patch of the series, changes [2] Lance Yang attempted
> while my series was in-flight and we decided to wait till later to try.
> 
> The first 3 patches introduce helper functions to increase code reuse and
> readability. This includes a per-scan state clearing function, extracting
> the young page check into a helper, and a count_collapse_event() function
> to reduce a repetative pattern used across mTHP collapse.
> 
> The 4th patch was the byproduct of me throwing Claude at all the
> comments in khugepaged verifying and looking for any outdated info.
> 
> The 5th patch is based on Lance Yang's commit series [2] trying to extract
> the PTE state checking into a helper function. This required a bit of
> rewriting due to differences after mTHP collapse was introduced. I also
> took into account the changes requested during his patches review cycle.
> 
> The remaining 2 patches were review points during my mTHP series that we
> agreed can be deferred to a later series.
> 
> Thank you to those whos reviews and work I leveraged to achieve these
> cleanups.

Sashiko seems to have a good point about [5/7]:
	https://sashiko.dev/#/patchset/20260715025941.1571316-1-npache@redhat.com

