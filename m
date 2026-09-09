Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02A8FC79FB9
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 11:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDF4D6B008A; Wed,  9 Sep 2026 07:21:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8FC66B0092; Wed,  9 Sep 2026 07:21:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA6CF6B0093; Wed,  9 Sep 2026 07:21:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B20C46B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:21:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4866D120199
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:21:16 +0000 (UTC)
X-FDA: 85193982552.03.3D618BE
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf05.hostedemail.com (Postfix) with ESMTP id 09F5510000C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:21:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=LUr8XyeN;
	spf=pass (imf05.hostedemail.com: domain of sh_def@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788952874;
	b=5Szs7SkXk2ojHIoEy+SlDxeDls55cPDkeD1ppP0CgN8NJFVFk9KWqMjEjPCG4B7CPAMAfx
	sSmu1DFUtOax7Ywi2Z3YwNkgip99JCq6qR0/kQCor9ctBhwVCuwL5YE+2SgqpZSfCWOGq4
	wayfszRSRz7bB+fhxj6tqdeg/to25iI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=LUr8XyeN;
	spf=pass (imf05.hostedemail.com: domain of sh_def@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788952874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OIAyl4+9WuxFicDuaMQcuZ5CFN1J9J/6GS7zLNL6wDw=;
	b=6imzNFTJ1NKcoJKAtjKQQ+rQTzpHc9hnKLhVIUCnexuV4wJMsu93IgpJfihG4MPMn8YWFN
	LT6v4R00Z/JMHBc9JpdhAB/8aBmag0/Oh52Ex1sYzFMh+lEqn2k3QSm89rfaNZFQuqG7eS
	JhSlYyVkaT3onWBxwrpfgHJTkRSWGnU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=OI
	Ayl4+9WuxFicDuaMQcuZ5CFN1J9J/6GS7zLNL6wDw=; b=LUr8XyeNZQnXdaBAn4
	py8csMlVVOPLVrPhKvVaywjrnbeERNTOd/cdN1SzyWeKf23M84GWv3CUimsuxb36
	cTJefsk47jpFDWX6gnpir8AzuoKMwBY+HV4nieEuhqbJjSHHZ3tFl1EPZLMPI1Q3
	FvY5ehT/PjxeNdcetLDZqCkEc=
Received: from localhost (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgCnESERQaFqJi3hQg--.17578S2;
	Wed, 09 Sep 2026 19:20:50 +0800 (CST)
From: Hui Su <sh_def@163.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Balbir Singh <balbirs@nvidia.com>,
	Zhi Wang <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gourry <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alex Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/migrate_device: avoid out-of-bounds writes for compound folios
Date: Wed,  9 Sep 2026 20:20:49 +0900
Message-ID: <20260909112049.3202956-1-sh_def@163.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <5ae7a11c-1db4-44cd-bf67-a98cfd5ca08b@kernel.org>
References: <20260817120758.669807-3-sh_def@163.com> <4ead5df7-f000-4087-83e4-13aae036e0b7@kernel.org> <apESOAPVzggWmbcJ@gsse-cloud1.jf.intel.com> <5ae7a11c-1db4-44cd-bf67-a98cfd5ca08b@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgCnESERQaFqJi3hQg--.17578S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CrWUGF1kWryUCrWDKF18AFb_yoW8Gw4Dpa
	4SgrZIyFsxWFWYkFnF9F48Xw1rWrsxJa4Yq3Z5Gr90ka1rJryFya40g3yDur17W3yIvrW8
	X3y2q34UCF15Aa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U5KsbUUUUU=
X-CM-SenderInfo: xvkbvvri6rljoofrz/xtbC6hJXtmqhQRJoxwAA3u
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 09F5510000C
X-Stat-Signature: fax5kmo8mow5hwa677kgraj69qqiqw8c
X-HE-Tag: 1788952872-448300
X-HE-Meta: U2FsdGVkX1+qrrHUaZFOrcoHn7guQYIGdRyW2pIugEwKUIfercBUC/1ntpg/XdjzuGFh5pzvyIZYNaZ4nnSmAnREMsMU4UFlZt2r+0+kTuRbb9pug9ZfgKW9Qnu2EXsgc8J/Bv0YAA99IvF7dGrwVG9qTY3P/kuwQzVbfjSDo5Oo5hFOrsfQ0U7MJgqlNZExgeN1fZJSO6LFkwXjf3volW89JVUEnjqn67zxON8hDnWT1DZlT2iGCOtOxHTRo45G+Q7//1p2rCQRNLbFPIp6T2+W9Vf4OcK2uvhF6bRbdr3qu3eFlfApPo3b4bX0489HKPMQBuP6ZHLLwhjXEFEqz27rZLS9sVUnkGdzVRwlUqCewoS0t7iNcGDDgu06MNLrW53TJeK1FDkyr3Xn3pXqtNrV/fCredG7dlGi+3CrA4xmgZUE84aV9gI1wU5CVKdvk274bfjD0zCm2walw9qsplrbt4wGJqxYZL+fhcnzv0HFykUeXIQi42zDKD6wCP4UcA+YSxnm4607kgQEO02x4IH5Dbr5aci7Asz67cvenWPoum0XDrePOe2seS9NnQph2q/L5nDkb6hPu77yH87yQctIyGAocUHjdtVROYBoHZZ/owQ8fpdls3sawcixMQMHwK5cqPQJw1ry9Y/mFxUdL2woGh9AEkMFkZej/MwQy32fWrE0tuPk3Osf+TtzxzGN3PI6vqVsvMpDq3yur4XpH2pz1aW72Wjh2VkfOno0R1v5ifzGeZPb1PPGEGQDXPdWY0WBPRZ3axuj83TYujZtYxqW5ZUOOgjMfQvrnWeGlqWWeDtdUQbEIy8GBjhOoiuLCHAAN3iHby9WP7jtBUYpKnWeWOI1QVYy5jo5GLDgB/L3fMrlRuGv/jy4GOjk05dTzVGvbXMSqEcLCy7hJL4NHyU+C6xmRx/HcREHgkbbl+R9ZdovLnB1xL9fh2FFeIjDFTodEXqLXYYcEyLbcxA
 FY6nJROc
 IAdHF3dAZROAbjFC16Itz2hnQLF5p6+22NqlaJNzO3cQPUFVdZKm5tyR9s1zkUkiosQvd1cLQeBtG6U/QmXBvXodi2aAqMRGpJ12pq/Yhs+May61waPcWAcBODx6llhgWHoZWHINzCCtETepP5eEm1/jb2XEB4Y85AC9AGrkZ+TzkHPpPU1hmUeAojO6F2wNKynfQQcHCO59LHsfm3eTBckz9aqZKIiKYguLr7qzhMVx20hk2SCrhdRitF6R4cD5z6GV9weUEcczg+c7YymzjYKHmPCnEyEpDAe85trs2cVky4tmYS9Z8iuHMK4a9kCj2Ex42lOaZ2SP7+fWW08Q4D8BogaEpPQii7FrZdH8vh+BiTXw7mKSb7SoJ4cOQ3kvudS84HuWywmB65j2KuzZEwzHJOWKH/E3Psqc+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 02:23:33PM +0200, David Hildenbrand (Arm) wrote:
> That's what I was thinking: because how should we partially migrate folios?
> Doesn't make sense :)
>
> If this cannot be triggered today, neither Fixes: nor CC: stable is appropriate.
>
> Agreed that we should just warn.

Hi David, Matthew,

Sorry, I missed this earlier.

This fix has already landed in mainline, but I agree that the API semantics
should be clarified. Partially migrating a compound folio does not make
sense. If the intended contract is that callers must not provide a range
that cuts through a compound folio, then treating such input as caller
misuse with an explicit WARN/error path sounds reasonable.

The reason I added the Fixes tag and Cc'd stable was that I observed an
actual KASAN out-of-bounds write with the HMM migrate_anon_huge_zero
selftest. The path was:

  dmirror_fops_release()
    -> dmirror_device_evict_chunk()
      -> migrate_device_range()

My intent was to prevent migrate_device_range() from writing past the
caller-provided src_pfns array when such an input is observed. That said,
silently stopping the collection is not necessarily the best API semantics
if this should be treated as caller misuse.

I will rerun the reproducer on current mainline and report back with the
result. If the preferred direction is to make this an explicit WARN/error
path instead, I can send a follow-up patch on top of mainline.

Thanks,
Hui


