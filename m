Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C482EA3C55
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 12:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7BD6B008C; Thu,  9 Apr 2026 08:27:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8E846B0092; Thu,  9 Apr 2026 08:27:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCC1D6B0093; Thu,  9 Apr 2026 08:27:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CC4A16B008C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:27:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6D92BC17EB
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:27:09 +0000 (UTC)
X-FDA: 84638942178.21.4791074
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 929A010000F
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:27:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NdjVnTZO;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775737627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U3oXadcBSvUPE7/YuHb+1ucWRDTMk1lo2RkRiHv3tFw=;
	b=GPrJ7qlpjBt9N1sgiQo9sf6gA1YF/08vDZxhwPzb9czwN+rH8s5wwNCo4Z5ou89Cavf96u
	SQbh7SQ7IkLuu/xzueo5xNsrMZwoU1F5l3SuANSemLcriYVP5dsJZ2npi+Oma8L3vKJa6V
	f/1NiwH0KRd3ZFLnc3EfxzYfjn6bV/Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NdjVnTZO;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775737627; a=rsa-sha256;
	cv=none;
	b=byvWybMR4hyNeu4VMfEvriiJv+9aNaMk38WeDBaQQTejNkFV8Pc4Z5bZHP3Vz24RrzDC+A
	XA2FmD+DMV0w+1wd0SST5TRxY/tieiVrJiqcPx8PWV2JDLGeoM6DihRaUuNwCKdncSv9iw
	y6KzJ6IhF8a7DkGkTUxq51kL+2jKdyI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775737624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U3oXadcBSvUPE7/YuHb+1ucWRDTMk1lo2RkRiHv3tFw=;
	b=NdjVnTZO0EcZ7FGk7OwErKClpXCrJ+wym/hO8gCDLMWoV5eueKOhD9JYuSZcti0C3TMPa2
	tYcbVnxIvqwmPYNY0w6Z19y987FYCm7U21aBrjHqLwVfB2votxdRpFYhODsC3aXvi/AdIW
	xmK0fuLVE3OqXp07QzLjF3PkSbzS0sM=
From: Lance Yang <lance.yang@linux.dev>
To: luizcap@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	npache@redhat.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v3 02/10] mm: introduce pgtable_has_pmd_leaves()
Date: Thu,  9 Apr 2026 20:26:54 +0800
Message-Id: <20260409122654.42622-1-lance.yang@linux.dev>
In-Reply-To: <b65d560458b2488f715b5afc1603d786e786ccf7.1775679721.git.luizcap@redhat.com>
References: <b65d560458b2488f715b5afc1603d786e786ccf7.1775679721.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: izzs8kfxhueubqykqoy316d5385frun5
X-Rspamd-Queue-Id: 929A010000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1775737626-160352
X-HE-Meta: U2FsdGVkX19j5TF6LRYYv7HTzH2jC7gXYYf91g4CQBSMcz+EXoiyolftcETyhKIhYM5+iEZkszu+ah3Yf2MQNyW6wVLrU1XihkIXl3iTAj1/EvliIp8uoDEU2U7RQqvEGLMVZ6zODx/1CzXjOP+CtCz/PNPE9aU9L/Ri0RxqdE/iP9gQhXACj/MZUW3EhZndkdR38ZPHhqhVA64SNGpDD7qQfuLW7HiDo226wcL70QFYWugKfSnH4QqyFRpgip7lyGJNv/HFvaA4IUQ38wxu+aXnXBCcGCeWeDq6EVs5dZOGo3aV/NyVAweAw+0tQCzn4AyuPGA4VtKb15SCWrZqJoQJnE4+6AX55i7kOtkwIe2C5fKUPgRcML9rqQwzv4fgVugYb/RtoEVpWfKJTdhIBHdHZyFQCGK1G1RcjVqnCorFJFkjJTiTMcuq2X3rOF4KynGvyq7OjVDBrgAyMbQB1H2XxCGjQS3/Nd9Gy08y/kzipK11AxowtG4Jrbj3uaRPQBDZI/5xIVgeBceu9QkzG6kBJPscjCzHwhb4ocpMmOQneismvlkg0/wOVDgT+7ku2PfY632CINfLwdThzUmsTxDzLQ1cx9gqf1u4HayE3NQaLpuxLGc4LXhHIxXsYG61iZ+ybNUYJDfb3i/Ww42Ky/8zajOukeXR6K4Bo8iETjFhjvWe0A5724pEMUOX9VDiuVwxn8KjFPkVr+I4mZ7Za2UA3rv9ChevlIrdLazFZgG+1GEcNNH/1j5xad0O6D+FOTM8r1oe+5JXJsYgL1jZ6TyrI1XuTX9/mvX6ZAD5mjNb0fbKfoTgwANF4UY82rcvNxaCR6ZGZxEiVOcC6x2P08LgF5NZhXTWjPndu5NqoImArq/ObZPhuD1W4qvOnEESCj7u1w5L0xL6TSIemZz3UnHA7Y6QxHvqUIQXjvDBkJeo/TpzZixhDK4KWO/kgG2/46xK+OuY1gUiDiyXEB8
 DDWvGlpE
 k6g+IBishYPukmQnZ/EzxR9+8vf4I/q2eUifB9cNSwQ+VsxH96beVEQOjVeADBaruAwwDQGjdWR+ehUem9aRNXHCrNWyrBcBRy66Jd3S5uSppLSUpNdpQVbXAD3AgARDXqoX3RkgXkO3gt5hhQITvgQIyfM8Y7kYUpt1H121oq4RqZHSJzVRa0TZ1EaMbDItaP2RVfMfW92+cM2YHh9jubnYFak9aSI1Y38jqZnaXxhAp+u41pUqbW3lNTNs6Tz0PK8f8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc THP

On Wed, Apr 08, 2026 at 04:22:57PM -0400, Luiz Capitulino wrote:
>Currently, we have two helpers that check for PMD-sized pages but have
>different names and slightly different semantics:
>
>- has_transparent_hugepage(): the name suggests it checks if THP is
>  enabled, but when CONFIG_TRANSPARENT_HUGEPAGE=y and the architecture
>  implements this helper, it actually checks if the CPU supports
>  PMD-sized pages
>
>- thp_disabled_by_hw(): the name suggests it checks if THP is disabled
>  by the hardware, but it just returns a cached value acquired with
>  has_transparent_hugepage(). This helper is used in fast paths
>
>This commit introduces a new helper called pgtable_has_pmd_leaves()
>which is intended to replace both has_transparent_hugepage() and
>thp_disabled_by_hw(). pgtable_has_pmd_leaves() has very clear semantics:
>it returns true if the CPU supports PMD-sized pages and false otherwise.
>It always returns a cached value, so it can be used in fast paths.

Set once at boot and then read in hot paths, would a static key be a
better fit there instead? Something like:

DEFINE_STATIC_KEY_FALSE(arch_has_pmd_leaves_key);
 
static inline bool pgtable_has_pmd_leaves(void)
{
	return static_branch_unlikely(&arch_has_pmd_leaves_key);
}
 
void __init init_arch_has_pmd_leaves(void)
{
	if (has_transparent_hugepage())
		static_branch_enable(&arch_has_pmd_leaves_key);
}

Cheers,
Lance

