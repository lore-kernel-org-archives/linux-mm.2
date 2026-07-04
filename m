Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46204C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 10:04:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D4CD6B00B5; Sat,  4 Jul 2026 06:04:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0876C6B00B6; Sat,  4 Jul 2026 06:04:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB6FE6B00B7; Sat,  4 Jul 2026 06:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C21336B00B5
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 06:04:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4FA4014044B
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 10:04:17 +0000 (UTC)
X-FDA: 84950658954.08.29DF7EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id B943920009
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 10:04:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UxoHJZwp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783159455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KbHzIWrPYpX4m4Z0NL+ODodGPfn2TyzbWTx1+qVPiOU=;
	b=F2R41v3CvPw0pq6z6yEIwhcDIKQiaH0TihUnv8qwFaR2PRNKaHGKzlyaS/t0zK2tW4jddv
	RPZ0VDlnDPLyr3YDWVfI0W5WKC0Ux1Ek3gavpuEhHCrTKw4lkmUGXkPljh5wALA+8h2MDF
	bGqyP5JrtK9QxMRKxZxQxzrrO7EmVPA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UxoHJZwp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783159455;
	b=pJm7f6qkqLw6oygqMe/kmTYbtfmIe3rDTOoRK/DYwsHP+aBSDqzxtrHfd+el0c+ochjmk5
	MUZY/QMMRUuHmJWYb92L/061JWaZmrycG8vmCJcAyOnmjveYKmWzhTUqy1Ti+L9Ud12i2L
	hy3kY5XPkeQ5ARKlMmf1iDx78xYCau4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B893841747;
	Sat,  4 Jul 2026 10:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEBA1F000E9;
	Sat,  4 Jul 2026 10:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783159454;
	bh=KbHzIWrPYpX4m4Z0NL+ODodGPfn2TyzbWTx1+qVPiOU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UxoHJZwpN/Dhv5pFptb4o2RUXH763dJbi5BKR5Nj631HZO5RdRcjY+LmussJc+bU0
	 R2enKPHE/+wAlxyq6LU1Pg353yo3vlhj9515zgRqLc2uI7ayOrWB8iOdWOuwNPby6W
	 n6i+4IxpbeEWmK5vLrqIxXs5R2bjnonBvNaUM5dYAiYyDqBqxwsJjBRg7h2pexeiuL
	 mg2daw2d3mVUgiFxilbNpDNgwip58ikJKGuc33EBP6Cf50kalsd9wyaXdcyMcPHiKG
	 xwzCetNHGTUqh+Zz432FRl1j2IArbSmpXqjDKbCFwShWtNr+oHB4+euOJ7Vtm0BQNf
	 yYnxqHhodaonw==
Date: Sat, 4 Jul 2026 13:04:02 +0300
From: Mike Rapoport <rppt@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usama.arif@linux.dev>, david@kernel.org,
	chrisl@kernel.org, kasong@tencent.com, ziy@nvidia.com,
	linux-mm@kvack.org, ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>, willy@infradead.org,
	youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com,
	shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
	baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, "Liam R. Howlett" <liam@infradead.org>,
	ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev, linux-kernel@vger.kernel.org,
	nphamcs@gmail.com, shikemeng@huaweicloud.com, kernel-team@meta.com
Subject: Re: [PATCH 0/6] mm: preparatory patches for PMD level swap entries
Message-ID: <akjakkURVyM4x1dt@kernel.org>
References: <akZis7j6xSjl8K_D@kernel.org>
 <20260703194502.102044-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703194502.102044-1-sj@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B943920009
X-Stat-Signature: 1m874bya5b3m3twia8bbsgs5ym8miytj
X-HE-Tag: 1783159455-791227
X-HE-Meta: U2FsdGVkX1/qFejbwM4XBodNUgnqxFLD8X0KnOjpdkkDXlSO6PGxFOK8HBDRVZoA2229yTfaTQasOut8JLU71GZOs/z+dPB/+nmUsJiH7miu4Giv9hVwYZlde0sUK6z6Fpjz0r8NMe1BLbN7yZTm2TLdSWDkaphGkvFYOkGsKxqbtjvoZelgqHZ3glWvEFFtvdeR1QYKoY3c3dqn8MgYfk2nkLieB8XjTjsgRYK97/OcbZCEoKHCYDgR0v+4Ebx89qZrpQ6giMfw2bGg2js/DaXayRjWoTpBPnDkWLYC74aoPlQO286KvQPgdDfSCF/7PmDioRiaxr3dY6lbqnJB/RmrtD+4RiC4pd/0iPWKiWXaXfr0p1RovLvC9ZKwGCbH570p2dv4WYqD5VOBbgF1d2SInPpSCfA3HqLgkoH6inxKIn1MeKhbl+kxiV0hWuHHixM/avywds7Zi9+9bEFmu+nUeEvpEZjweHOnYYWRP/pKm2DFY9FPCi6RwPaGGY8KYWqabGAeDFYrryjCopa/JdNihcjTuSOqwnWkVOFXnPwdtCvN7AzpMEVTLIhqEpXPuCeR2e7FvIjlw6qfnDpD/SxqkLM2VIj9MxJ6fFrleYE1hR9msVrodm5TpCwiupWlh5hIJNfd5z5bfZ5+CcPQeIPr1iCdx15SfqDZwwxNFToWhvqRgJmarVP2AY3639ozZVqZotz4TLll9PWOXxm+R9g0COsGBitoFwJUE8tOXeglE9yucx0f3u9p0HZnPJFT5e8jWKmsdDGLWqmfEclVDg8cmIzImhBKlilg1paIuZWe4EJq3AkIpDSTGse8NR5mmzaKTI2VpEenT0LJlSkp3EK91ulB9excAySZin3auKHKSKNvzgPFLoQLa/AqAeqZjeKUwAT4fEksAgf1P9Ni5cZVOLwQoZOivHMI/trf+klvHmMqj/22K8ecHo+0hlbLJlTO71Xtz7nXnLwv0HR
 TabFlK1o
 Z80p4+5AfjnwKy+rs0IA02lTG46MP5s2wXlM0gCigcxk+M5yIVyrTaj9VUlAaIcVtqBOribtRhrb8MB2vAU+admC8B3nv/Lg6BNaiCL68PsOuGPQVhTFrurcThHHoXHcDSSQkDxWhW1RVHdu0rvwWTXyEFCaqgDmJ6N+0yubus+tJFcAacmfIH8mqLDkPoZggtbk8xHC/BCMWpsJnzqopVEhQXtCKuVVCvvLW6z3DuSWa6b6DGDfCVA5G7wjVvl3J6nkuBWmDQvPMAtgaDJxQ6BlI7RhbrA8RzjGmyJBKHf6kIqA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On Fri, Jul 03, 2026 at 12:45:01PM -0700, SJ Park wrote:
> On Thu, 2 Jul 2026 16:08:03 +0300 Mike Rapoport <rppt@kernel.org> wrote:
> > 
> > CI grabs patches from patchwork and tries to apply them to one of the three
> > bases: mm-unstable, mm-new or the latest Linus' commit merged into mm.git.
> > 
> > If patches apply, the other bases are not checked. 
> > 
> > This patches applied cleanly to mm-unstable and successfully passed (at
> > least once :) )
> > https://github.com/linux-mm/linux-mm/actions/runs/28544575927/
> 
> Awesome!
> 
> I found the CI script (mm-ci) on the GitHub organization.  Is the repo open to
> contributions?

Yes :)

> If so, between GitHub PR and patches to linux-mm@ what is more
> preferred?

The way it works, all testing update should go to mm-ci. There is a bot
that takes them from there and generates PRs inn linux-mm that include
patches and the CI files.

> Seems it is not running DAMON specific tests, and I want to add
> DAMON kunit test to the test set as a first step (DAMO selftest is bit flaky on
> some systems), if people don't mind.

Patches are welcome :)

If DAMON selftest is flaky let's keep it out for now please, otherwise it
would cause too much noise.
 
> I or someone else may also want to add more tests like Cc list checking [1] in
> future.
> 
> [1] https://lore.kernel.org/20260703190421.100480-1-sj@kernel.org

Yeah, I think it would be helpful. 

> Thanks,
> SJ

-- 
Sincerely yours,
Mike.

