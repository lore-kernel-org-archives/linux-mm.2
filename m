Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 448ECF36B9A
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 00:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A7166B0088; Thu,  9 Apr 2026 20:18:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 630646B0089; Thu,  9 Apr 2026 20:18:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F8276B008A; Thu,  9 Apr 2026 20:18:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 38EDC6B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:18:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D35A1A02DF
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 00:18:45 +0000 (UTC)
X-FDA: 84640735410.21.61E9CE5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id D80631C0007
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 00:18:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iVS3MxUJ;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iVS3MxUJ;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775780324; a=rsa-sha256;
	cv=none;
	b=GSZdwCcWHsYloh9mzidzi1zOBxm2JmpiVIhoUIw9ld/6fDLci1j/l7h5J3M8rOey9ygvGH
	XY3Gx1m9bjziTY3siJh2jeXDM5Vk5AtjL90Y75O20ut66Nwx+UBOg0tpsGsUT8ioGL3XM1
	EOVDyoHkQi/KjslzVkgcB5ML8bTWr78=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775780324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V4WRlbU2LaFRx/kfFbsrD/NDQf+pfMbBQXDhpusFZ8A=;
	b=RF8FBxpH4H8yPFGvMrDy16QhluD72KA1vaAlFOpor0NydXBw32Y46SkOYdYH1VY7m8RP2v
	us17RwU30j23a73k95teMv8t6HM+E5YM5nBsM1NetExSjK6TttIvgm/2xmaH0WnYvh8HSf
	cc1TrAK+3NQpAFOeGFRbx52wveHbwAs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CAA8344450;
	Fri, 10 Apr 2026 00:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC02C4CEF7;
	Fri, 10 Apr 2026 00:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775780322;
	bh=/Q/ll9PivB5oIVa+0s1p+HhzrIQo6pfDmvHg0+GwGp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVS3MxUJnNfok8BEsH/dviiPNaVrgEYPvv7VzPpgVWHDeCJ5apJff9W6TCLKMuCfH
	 ikX8XHNSK3YAo3oHbI0ET0Cl98IsEB5z3mImJull7hPRg9oKvxpTVVPVvfe/dUuXOe
	 Ging1o40xnrKRKz7oPUf1valFg+7SHBpPU2a18Z557+sdalBIeAPr5wzx7Q7oW+fId
	 hJUjPMco/A0Hz37cUii1S01Jkj8XqT5iTRsJQbBjeoTgbCQzp5i2eJadrNE5RcI/D4
	 YJIQp/vlJ+fEVHTe4lSEt0Fm4Dtkwj67AqgRI5gDRzPAQrHObLssq5A7EWw0+/773r
	 y8QLSreSJKBaQ==
From: SeongJae Park <sj@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Ye Liu <liuye@kylinos.cn>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/khugepaged: use ALIGN helpers for PMD alignment
Date: Thu,  9 Apr 2026 17:18:33 -0700
Message-ID: <20260410001834.77924-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409014323.2385982-1-ye.liu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D80631C0007
X-Stat-Signature: wrcaasijyhfrkemrducyfdy6bwehn348
X-Rspam-User: 
X-HE-Tag: 1775780323-233143
X-HE-Meta: U2FsdGVkX18XXIF/8YMijJfHr/pGpm7zSvwNrFgoJn3qMoYwy3rnhsw7C7KejEvi6aNzJTdHWLpeiqbfEK3G/8jK+iZW9ulZcsU/rRZ2NnGep7r9rW47MEzwZo1AV9RmsDPNiuE8L0KqlAYbpf7jwK2n+7plZ+72oy0iuDypXcvIP9GPAd/dRUii4NzvAnylLXhQT1t9F9Qol37KwDuZU3jp5AFjC+pCjovqHzw3SEtneuOcnRcyJsv+hgUGD1ZXS8yU8D8n4a6QJYkT77QCSBbFMB0QBD/o7tUq2mXsBPRdeRpUO7R99uZATo4tZu+5SXh6RI+WQcM8VHw8aPe6MTvaG8i3gv2KmE7uhERAoePaayhH7MygjhIuKFlqesLBUDfEvtyAfxM4jBOhKvkoBaxy+L1avAKsrF6zDNpDz+PeTDSILICcF5SR3zmER0eeQ4Oxrq770X9MOnN8Tec4BCckqctWDJmAMt++YmTTUoink8PG9fOAFf2qHnxZyMdPtralm4/MPt/cUmMQlqIsgith8Pf5p8c+VIx5GNmH6aAOihv8K1U4Cwb6zaMFVkr/lBnCIKPGNhR5SubAUiM722BQHyQMacmtXMXWLQ4jHJUCOoCT5JD5tR4V4YsBOkhkjWHd+Ad8sjar0Zxei7yOqR2Ex3Bt+6KHaqVxuRpod5otYjZ01fFgH1gKfD8hb+LA4CVO4CWnfChw5vR2XJhK7QT90s26IsrLL6tG2GB7u9p+twEJGQ+Fsq+2GzYqkz01BkN+23O7jmhyupAUg2NCfSC4EIX4Yr/+mTgMiaMRDwPb3HWZ4aJTf7q8oLjQlOnzcZlEpamWnx3vQtWGSw3tEno8cloC80DuD9eIu38ifsYpQHea2om7SVg+eMghMLY7ZObeYQOVx94STQuTPvzgZxUypHaRq94XVJMS5fWz9siLEdJwFTS6LaZfW5MmvRoWgRjJiN8gnzHnKoFHLO5
 rIA4L1f3
 4spSDgIVLXGhxj/XQ6ABqYe6l0lc+d1U5M0KwjPbC4WiAhLHRpkq/Z9QnJFN0tAh5UTcapQvphbS+7k1L75p8qoDx4e9QbZfn8otIZ/9C1C82PHdpeRXeYab0D7ZW0+8eWTLWt9MksCPnZ8a5bRS81643ovLD6v+zo6puhBCZWzlrjTFyT2IP0XDV7JyXBB9izzVNLwsn+Utbtm+h96ZSHZ9ZosZBTk1ybRz/3kOnLLDJTG6c1285/CWhPtUX9XzBZN6E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Apr 2026 09:43:22 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> From: Ye Liu <liuye@kylinos.cn>
> 
> PMD alignment in khugepaged is currently implemented using a mix of
> rounding helpers and open-coded bitmask operations.
> 
> Use ALIGN() and ALIGN_DOWN() consistently for PMD-sized address range
> alignment, matching the preferred style for address and size handling.
> 
> No functional change intended.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

Reviewed-by: SeongJae Park <sj@kernel.org>

> 
> Changes in v2:
> - Switch to ALIGN()/ALIGN_DOWN() per David's suggestion.
> - Also convert collapse_scan_mm_slot() to keep PMD alignment helpers
>   consistent within khugepaged.
> - Update the changelog accordingly.
> - Link to v1:https://lore.kernel.org/all/20260408093534.2373007-1-ye.liu@linux.dev/

Nit.  Changelog should go to the commentary area [1].

[1] https://docs.kernel.org/process/submitting-patches.html#commentary


Thanks,
SJ

[...]

