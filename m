Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5851C98332
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 15:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51BA16B0088; Sat, 26 Sep 2026 11:27:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A5176B008A; Sat, 26 Sep 2026 11:27:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BA866B008C; Sat, 26 Sep 2026 11:27:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 188046B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 11:27:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 76F2F140900
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 15:27:20 +0000 (UTC)
X-FDA: 85256292240.01.D338E7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id C85E7C0008
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 15:27:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=le8b+r2b;
	spf=pass (imf10.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790436438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l9IyOBupFWtulH+Gz9qmaU8NYVc08VS8DkkELT9Mkfc=;
	b=ySLVjwLnWNHvu/SnREZAnYtBz8/7CY1CkCNek+uzH1HTiFbFodSFb4HC58fowgAWWEmMx2
	PfWjQf2dq3Km/H1ub+avmYLEiFBuZBnqfL5FfNKYIDpW13T4Fac/n5MLT5pfRByRoNCUkU
	dROvldGXuzSAAH7KZk4kdBsiLQMVNYc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=le8b+r2b;
	spf=pass (imf10.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790436438;
	b=Uih5KHcMouU3ropdQPOULdaEJWvH+3ZHMJED4pBLrvtulI3kVaMtIZ27XTt0QgS/r7dviI
	L5zWJvvfqToc1Zken6VsM7CkoEIeRqSLOYe10JGQ85pL7cv02bEY7x5oOobNRLHeN71Rfv
	EyXNkfs7atMgj2DMGIuKSAk1HvZv1W8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3BAB6441FD;
	Sat, 26 Sep 2026 15:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAEC1F0089A;
	Sat, 26 Sep 2026 15:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790436437;
	bh=l9IyOBupFWtulH+Gz9qmaU8NYVc08VS8DkkELT9Mkfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=le8b+r2bMxTJJvIPIEoJyxlgKyLv5Xi0D5g6fZMHD2fRT1ubWC50+RnyemLdOGdY6
	 0Ood5cZooGoh+H7GWfSrYYtFzY5tl9BTaaCvVwwapvhNVR5DPgy0pbxSG4mnU6uFZG
	 tDBeB8YMHp6OCgQpp6kc9tY3tYiIEKboZepRTEdY8Ewc9H/Hsf2o0/AJKTBHAyyUMr
	 OFI9NpYYrVTmF7/bpqF82545RCYxVfGkiVPGfusvtuWkX7+qkAkiFTIWVQSy9VXjDL
	 p1IIYJmcCq9FnhMdukgBKJgjtaTjR6KWzWsW6LxKmXDBLnQEKJzjOp2TaeZ5eVmg6H
	 HcA/C5bdUY16A==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	linux-mm@kvack.org
Cc: Sasha Levin <sashal@kernel.org>,
	rppt@kernel.org,
	sayalip@linux.ibm.com,
	Luiz Capitulino <luizcap@redhat.com>
Subject: Re: [PATCH v6.18.y] selftests/mm: hugepage-mremap: fix mapping alignment
Date: Sat, 26 Sep 2026 11:26:57 -0400
Message-ID: <2026-09-26-daily-reply-0004-re-hugepage-mremap-alignment-6-18-bounce@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925172129.2962208-1-luizcap@redhat.com>
References: <20260925172129.2962208-1-luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C85E7C0008
X-Stat-Signature: gh9xsmrdgut7q59rxemqne711ckdgrsn
X-Rspam-User: 
X-HE-Tag: 1790436438-333298
X-HE-Meta: U2FsdGVkX1+rhO7T4NkKaY11cWuJta9pJNkpqoSjQejj6TBgnfjkpRUtfsecJ6zrHS29yNkljrClNL7dBvTxaRsnjthb0/TIBx7AEDiObKl2b/bgYTSwUGxLFpdTqwsVWLP+OKZleYZb/ODMmPOGgZA8UR8bQxn2Z6+DgviUniUFhZopMG8X3ZorSU8Fe6iuS8ZOjjKgiu4zV+J1UiYyqK+6SBnvNMBWK8TjRdiVW/eT7Py9M5vxaI7rbZW0IgoSqdMzowW8eaWH7RBcd3QzcI567YWXKyEMuTbsSUzLli/quBaktLtr/PTM01BAqECPn8YpfqWhNJCgzGGnTylWJ5vaCMm7WwJt1iz6woZk9k9dIQApb3YrsUx+nG59/LxYutg5mei0E3aMAs2bpOUly1LI4gE0UOa8thMkUQxJUerIW4eVDi9fsr+ssXfSsfU/FAOo1mVAozFWCIsdHGUh8KwS83zSssXSnGLLaBfHaTgUTFwko5bpt+CEl3HkmVOa8Jcgse8LfCe4OD+oVh9+bhhHRr7bmnhgXgxgZA6NYScpi0Hh680qkYlKEC7Ir7F/8qmsWLMR8GZRqcDKCrpXXCA8VIYAjLBzcBCY+5ZKcH369XM/+7iSZZE/2GYZroma8UHvpyBRpSrH+bVJ+KKPiF3y2sElk5T6vfN0xQh7BD3tzYXg9YvPJE8oSVQe5sIqXRvZ72rquqPJP9fG/MZuWs25gcyJ7BqlxvPHHDkQI7GtNQM7fJL8FYLRbglzAokpIUb8dGeozCD5bgsvKM5Xv/DGMvUYpelJlRtOsnpq8AroU3d+mP1eNzy+zXfvnJuuY1KuTJd7MNMPIv93Uo/4JAQAfd2u20TdW3mlbjwHTQpm7aiSMGPmpUrEaWx4AR3B93qBC8nDmOspaLvifyKPRHHD5Fkpy4S0sVmyj2I3KDLfzFwDMKz9PLFYTj+am39NeLg8muKKw1Hf024hqE9
 cme3fUhz
 +tqqMWKgOVjIreo+oN+RMMTUicmSOWS3owgWgoypGizw7LnostYoWZGm7LrOsBgXNEAsMV6kLStAj9ERGJs/xNWAK6zQVNsQCuHt/EeeXNTr/NI7M6JmHpn7tt4HzowY0E79SE9l+OsivHIX+XE5s26oaJjjc1ux0Ny8FWg7tY55IXQcvNGurumLmb3IPgZs5g3TDov1GKM/xthg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On upstream this was fixed by a914785f6349 ("selftests/mm: hugetlb-mremap:
> add setup of HugeTLB pages") as that commit aligns 'length' to the
> default HugeTLB page size as part of what it's doing. Since this commit
> is part of a 50+ patch series, we backport only the 'length' alignment
> bits to fix the test.

The change itself looks good, but the commit message has no upstream
reference line. The SHA only appears in the prose and the subject differs
from upstream, so the backport can't be matched to the upstream commit.

Could you send a v2 with

  commit a914785f6349da754e1226420bf4e51961956769 upstream.

as the first line of the body, with your explanation of the partial
backport below it?

>  2. This should apply to v6.12.y as well

6.12 has the same failure, so please send the v2 for both 6.18.y and
6.12.y.

-- 
Thanks,
Sasha

