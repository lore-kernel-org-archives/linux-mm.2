Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6DE4FEE4ED
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 16:50:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF78B6B0088; Sat, 28 Feb 2026 11:50:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7ACA6B0089; Sat, 28 Feb 2026 11:50:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A867E6B008A; Sat, 28 Feb 2026 11:50:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 95AE46B0088
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 11:50:10 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 437F7136754
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 16:50:10 +0000 (UTC)
X-FDA: 84494452980.30.DD92DE4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id BA7AB120005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 16:50:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FYw9u4Jy;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772297408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5+oKtiHzbfn5GHYSJre66xfZK1GaD/iUFRedDrG2H6c=;
	b=4oI9lCaO3fWpLHq9t7B0HtJLsWBp0uKsA++MbY88FBTM7Cv6j1Tg9DOjmANAW8jF3oOmJf
	U5gLjGsl+tUC+yGkrrvubagwYPDFqazPAcmveAZw6/5X28h8G1pdhUCQfEW8PpmczjvI+6
	vae5d2hAN1v/zGsoaFzeVAhVQPVfCUA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FYw9u4Jy;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772297408; a=rsa-sha256;
	cv=none;
	b=ddi8CEr9h9UT6ZgK2MTY22nDlVKVaLGpR9qdi+wF98kMHJPVLs6DyM+KPEYgX5LWj4ZMmj
	eXa4NfoniOymUwx9gFc9qMxtWy4KeAeLQlsm0liPPsMhDlxxH0dC6zOIBkivOq5pnan75C
	gyCOLYZBJfid4E+75FXQsMwe4QGY4do=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9606B44535;
	Sat, 28 Feb 2026 16:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45306C116D0;
	Sat, 28 Feb 2026 16:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772297407;
	bh=EKQhU9MFTHfsLUytyRShr1nIh18ZLFNPpAoVEawueIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FYw9u4JyY6IrjZ+viPaZhpv445h12H08bmsKim9gDxQEEoQBx1U/lWp+6b2wsU7VY
	 /J2vJyAfpJTNB1U+Fu66WudIsqY6Pu51sgPNtYLjNThG4MhY4d0cmCh8PGbhTAliE7
	 hIezCvoesoIVE6+xRk5gSX8tCRdr7ESRj92vazq8WMApe20OPqUZkj367zixcGYMrg
	 iXcwnX33D7XigvEo5XXl7wzg6mtV3bD/FFmz2q/Qfd9mjZ5b9zJsUIOxZI+gjguYJF
	 /wdgME4lFkmzdiT4CSFba0bE78J276XhXpsTTKJ6Uu/5Hz/cSHcfASvav0Ov6OoqNG
	 2IyKmtuqiDysA==
From: SeongJae Park <sj@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/events: Replace READ_ONCE() with standard pgtable accessors
Date: Sat, 28 Feb 2026 08:49:58 -0800
Message-ID: <20260228164959.39672-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260227062744.2215491-1-anshuman.khandual@arm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BA7AB120005
X-Stat-Signature: 9xxfjf1istpwq1ete6pu1dn4z9h7tyfg
X-Rspam-User: 
X-HE-Tag: 1772297408-530028
X-HE-Meta: U2FsdGVkX18q8otl+ASkhGGG9NcDd/KxTSc68AcThKCLj8KTfxaA7tlJd8TiUBrb5T4dfYYVAPJJj8AIXShqLkKOU86O4XF1XZO1xnN2mxZ7eAHtPP6JbWmwumdz5UPyPZIhfZnGayz73LOdGDZlYAfUAf8LyjynBXKGMQHNbcsTrPcxhLqyUFYZZOZRJUEevh0BUvewbQzqyxCE1ajlmxKN2ILM1jiIHbLLTtpi4K2eZ7FMGhUL5zmwCDZ+SsPA2LuB5nPCnMyEwZZiV7ZQip7Gps2NFwhczo2g553XykwvTbYbh3YVHQbtjFFZf0ndvhbbpGHVphHByCj5OBBEEeZ84vtZKXKNBtGRpU3y/Ry8dYvFo/JgF3rP8cbvoi1KbwV71EzSf4z2oimeCKmjlfLExcPUoHz6/X4VAyKPn5h3zTLkw1QPt4YbHFnsfX1PSPbRPbvu0BUOTA4piSLTQMz5BcAFqlm7OUyT1w04V4hVsE3aebh88HLjAdVdsS14hsOdUgHeMhfRwu09d5R0GSvdZHiTps65K3IOlNWLgk//5Hu08gpaxWm60mJHajKtyhcmh3cmMUJ5uRjNKa4BDwOlCf0umCtZTFkCiqXGs2WIL25vJJTGHGaXQXBDoZhuNzPa6kmVQYwKwaFyZYlygDsJa9vQFl2HtrTnb5yw76lwcoObuZ/RUO3RmCxPWcJ/dfgOyLA4ODWjoQpRG7eAERiB9IUOOfCEUfwj+2e0FoSfjb9xvX594fTmvAOu4Uw8OFUwT6UorFMW13HxrNbLIjqKl0Pig5MT297PUJHIRayfhNuh8W71R7uv3Zqx6RUY/UhpzIfu9zzuLs9xI2VtmGvk6aRjjYNTQsWaBsbayQwsd7GmF1dbiOYZr9CzXT6zQP0h85Vou+A3+UDeUREd/OOM2DBjQF0ZCH+r44qKwomD3VoXprOEYWn98l833hFE0UHAD+eOEwLra8qQ/sZ
 5voDhK/m
 c30N8ZE/C8CPdLaET1Bi9G09M9u9bPhzCG1exJzqL8xunLME=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Feb 2026 06:27:44 +0000 Anshuman Khandual <anshuman.khandual@arm.com> wrote:

> Replace raw READ_ONCE() dereferences of pgtable entries with corresponding
> standard page table accessors pxdp_get() in perf_get_pgtable_size(). These
> accessors default to READ_ONCE() on platforms that don't override them. So
> there is no functional change on such platforms.
> 
> However arm64 platform is being extended to support 128 bit page tables via
> a new architecture feature i.e FEAT_D128 in which case READ_ONCE() will not
> provide required single copy atomic access for 128 bit page table entries.
> Although pxdp_get() accessors can later be overridden on arm64 platform to
> extend required single copy atomicity support on 128 bit entries.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: linux-perf-users@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

