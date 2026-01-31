Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7899ED46C1D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 01:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 922A76B0088; Fri, 30 Jan 2026 20:56:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 904026B0089; Fri, 30 Jan 2026 20:56:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8305B6B008A; Fri, 30 Jan 2026 20:56:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7305A6B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 20:56:50 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 17333160612
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 01:56:50 +0000 (UTC)
X-FDA: 84390595380.14.DB600D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 61702180006
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 01:56:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ImRH2ypy;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769824608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HnOGHt56/YKiYs6zDcREh0MbRRqdPoncp/3wMRS3T30=;
	b=jIc1O6PFeLGOVKAepKcHz/ht2UhMXRLxcr8mkg8aAPA27/L+XfcV25+msXWcyu4+kCpMlk
	r0dCByObaSBm2e3uCPRYjn3kUQSlxrmmagU9jZoD89oI0eDFns/QTOsHvoMkfZUmBXcNxp
	ML889LWc//FBGHrRRquZKqq8gi/i7mc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769824608; a=rsa-sha256;
	cv=none;
	b=eQjKnRSQcdb8LUkhoL3YaDaXA0gA9eKFvVL5N/ScOAWZKByKqSkOI5kpgMg+i4gQtoURp5
	+OmuS0j8x/1V9nCs2xwL4q3x0m7lFOwMbPLMhoucmD4ySJfFmazohZXqdJWV/fHKgB2BzH
	AZR3Ku6rBKj2fkBjzEgguYrUyYM5c0Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ImRH2ypy;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 30C7540C2B;
	Sat, 31 Jan 2026 01:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04F0C4CEF7;
	Sat, 31 Jan 2026 01:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769824607;
	bh=TLqvCF4t7yFws2JJgVsnqE5uDHYvXZpXYYnuo6IsZgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ImRH2ypyq96835K/c6I0GkZRWdgWuU5RwayIfD9PzrnnYomfw1lbf8p9zc8aCk/gW
	 IwfGt4Ko+7YPompvYRPPsFjQ6cTqluHxz5RInklq0ujPYlBEH0tiS4kvpJzL/0Vb0A
	 /gPQZ4fB8WV90i4C9rEcHqC7V9XhpTIQrZaIhKoCPQoOABzDJoUG6bH1eb1lAxSpGK
	 UiyCtF43nbLbz/FhFri4Ad4D5BODCYy1ZFBDqI5HTVCyQKwQn6RcJksGtoAkhBl0pC
	 DRt5/kFpyfUWdlB5F/7m7sT2A/bxwr08I/RV40a1A9HXfRwouwIbDE1q18TpLNR7mN
	 RrZN/v1ysHjgQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	sunnanyong@huawei.com,
	Enze Li <lienze@kylinos.cn>
Subject: Re: [PATCH] mm/damon: unify address range representation with damon_addr_range
Date: Fri, 30 Jan 2026 17:56:41 -0800
Message-ID: <20260131015643.79158-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130033847.52289-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 61702180006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: z9ngcaepztkcmcwg7pfgxmjf3emp4zun
X-HE-Tag: 1769824608-80189
X-HE-Meta: U2FsdGVkX1+cOm8JhBKQcldQ5kmeLW2Uz9/uSzChK2H5+eV7GD7uUUapmcjJm+Zt7Rbxy6XooucRveHCE7hsYAt9LMVSFbEG0aUes4xAYA2Ghg+ZqJLzMWLkPGXbssqguVUb9dKij09B09o7wgaaVXtZE4Ffk/BS7uipqWecg3rsskCAEJaYN3PIFdB+2s95KqB7PWORreaNuKPpxvl8knOy0aNv2nCkyvmHLeY/aWbO7/ExZUDoHdp0m4Vj7+CRoiKLrbeNo/p5ZKITZLmb7QdnpNKm3cl3EM47YLcZL6gy8YtR94uyZvmTwQC8APR6G3PKEnQ1eluHeGxXEsbRoAWyLPjIapcP/V7rOPb0TZuzaT1Vt/HQysgG8AcaDp/8TDYyBbBU8wzSgJR5DfQCXLFbPYlGPIw1GAg/sFN34BLZwZqMqUUmQlBD3tkTkpA4k2/QKQgUDTiuPJk5iV7VFrmIW/EPqxzVWBVn5/B3YABTvlksP/bIFddRL8WuBsGk2Nav0AjK5aYFrwriicFjn7d8ykGYbvyGUyjpeEezuIUauekP4z+MtcvW9J26GL6sGrBCR2rQnW9u0VaW4d4GYfc7n6U/3AVIlPuCbPIVM/F9EiF08E1DpkS7EitcLNOIy6Xoey4cDQ+ROfQueIHE0H0OeNNqjUJovAA9w8Wryzk6xL+XmwsmWJdJnzWgqH4TX/XVQC1GxFOUxDx4CZWDqrlyRwsdmpwlAhOVoP1SDAd4auP9gSIYaYniKtQcJKLC7RwrzdllE6f3k5Fdn0Hibf1w6rA7lR8JKH1V37afv06YGXgAC8sv+pG1tIYDeUr2t1pIiCZI4xCciPkiG5X7yYHfnCSGIM8OQlhxkqg4SGD3ohJM0OnfSe8zYWdLLejBjjIdwQujbqxAEk6WzxgzlokAmwbztLGytUYwV/po3tGB60oJy43Vzwqluwlh7QNXcHyBpsaLRGD8dnqbkzZ
 rcI+nijB
 ELLw5PMzELptNOxhjMFfEP3faStLDm6dMAixf/LyX0HamDcf8jBARPNcvZxr1AyQKu9ARTVRvvTnmmxpud94l7DDf+tx4AsTmKpaF1zzbGGl9C2Zy3Vinjc4RgubScT2n/phKaJ+oqHijWw7lCGSxR/qsMJGbM0oo7UBbEgoa9dWkiLttpP+xKfWrSlSHzSGQBf15b4aLsfqfCSR1Aj6Gv9RhLTqhkfsQx8IodsOqgeYeNAE/x0VMaUtCbNZpAYF0Q/H2UW7WiVDuGXU3N6eo5jen2T8QRDrS8L4qdVWHM+5UEXzc10Xv72Rbk/fFE92+45kuoKOO9zOH1QYJi09GhN8kJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 29 Jan 2026 19:38:45 -0800 SeongJae Park <sj@kernel.org> wrote:

> Hello Quanmin,
> 
> On Fri, 30 Jan 2026 11:07:08 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
[...]
> > Actually, DAMON only actively searches for the biggest System RAM
> > address when the user does not set a monitoring region. In this case,
> > we always reset addr_unit to 1, which essentially restricts DAMON’s
> > monitorable address range to 0–UL. Therefore, the described situation
> > does not occur. For details, please refer to commit [1].
> 
> Again, you are correct.  There is no user scenario that can trigger the
> problematic situation in the real world.  Nevertheless, assigning
> 'resource_size_t' value to 'unsigned long' storage makes no sense, so I'm
> calling such things a bug.  Not impacting user world, but still a bug is a bug.

I was arguing it as a bug even though ABI users cannot trigger the overflow,
since damon_set_region_biggest_system_ram_default() is exposed to DAMON API
callers, and I was thinking a future caller of the function could trigger the
problem.  But I now realize the API function is safe from any call, since
damon_find_biggest_system_ram() is avoiding the case, by setting 'end'
parameter of walk_system_ram_res() as 'ULONG_MAX'.  Maybe it is not really
appropriate to call it a bug.

That said, I now think this as a room to improve for the readability of the
code.


Thanks,
SJ

[...]

