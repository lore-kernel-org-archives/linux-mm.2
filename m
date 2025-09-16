Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63C72CAC59B
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 18:31:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1D0C8E0008; Tue, 16 Sep 2025 14:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCD4A8E0001; Tue, 16 Sep 2025 14:31:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABC808E0008; Tue, 16 Sep 2025 14:31:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 962158E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:31:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45B97C02D7
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:31:33 +0000 (UTC)
X-FDA: 83895956466.25.C7501DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id C75BEA0029
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:31:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A9gb090R;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758047491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tuswn5DYxGin+2DEQZkeKtqy3rOmUocNay51t5rLa4Y=;
	b=QEyzi8yOhhdR5zJNuj9FGwJHn0WTmTsDrQnHkuDdROOEJZAxFZiijp/iHCGwDjgnfqPv7j
	m05sNTuePg3KMaTaFHpuxMjGMYOcB8g0TsOsFRv2M0uhVXsSC5nMtg0YqhFR1bCjUPpETL
	BOJmZTEb+QDzvRaKnK0pdoTofxgdWpg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A9gb090R;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758047491; a=rsa-sha256;
	cv=none;
	b=QmxX5E06mmc8/uzYEX+HSdRbhftmXoO9yzhTu2fs6d4wmQsJNfd8GukxZaembd19xhfeSK
	iczAasBxi36se9Dr+afEBTHrJr/5ehXMYEqwMmVb0tGKgUnajqSf21LdCD0XzuY+kEtpeW
	SNiWlP3oOb85sxUVEbYc6ZamA25Y144=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D6FC601B3;
	Tue, 16 Sep 2025 18:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA99EC4CEEB;
	Tue, 16 Sep 2025 18:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758047490;
	bh=zRA7NzE2dfOJUv7we74p+H9MxXbTZALm/bBalZg7Shw=;
	h=From:To:Cc:Subject:Date:From;
	b=A9gb090RsE07mCO9Y33W/36nq4GLOSQVtHGp+4RNpeKz96L1yb8NUM5809CbwhRhN
	 IxmkXRoJL9LJBtYW8PNSiCMb+C0wRjwa6Vvzwy3w9+CqKJTJK/eJ7IgbjpUqJuqxs1
	 kBa5QnQrlM+Gdx+iZ7O99oOSbab8DRCV+dljqnZcDyeOqPJUq2t7WgbzP4avJ/D9L9
	 4Ut5iyrgsFTWrUzSWnoj0ql+UkexNrn1YZAYyAqS389OOhSzTWef1ZE2bSRYBIPgiM
	 367w6e3Y9Vf47Cb6YyFvKam+Bs5P5Jmc/3tKQsWrEQ3uDYS1Z9WSaC5JzIREKSZvK1
	 eQ5Vj07ObeI+w==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] mm/damon/stat: expose auto-tuned intervals and non-idle ages
Date: Tue, 16 Sep 2025 11:31:25 -0700
Message-Id: <20250916183127.65708-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C75BEA0029
X-Rspamd-Server: rspam05
X-Stat-Signature: uo4ufoa8c8m88yi6i81jnrosntk5mggq
X-Rspam-User: 
X-HE-Tag: 1758047491-251880
X-HE-Meta: U2FsdGVkX1/73LBoZYjbdVXI/XlZwE3klw++GnenX1NmD10xfmwv8uPNf9qPiU3NgJV031jhalDkc5094OQlAwVTHQiZiDMKoSqPZkyDEsVB4NEuIA20orIsmSsqU4Uf/O8vFvfFqW01QawyQCDr5POb/j+lyudx6lWLoAlrs6uIX/wZ2KdLVYJQ6C7KOX/gxAUhnPjR51RL3AjQyXVA4uHZ+/Y3K4BJZ7uQOYWKcddVjZMB07nGScCMmhnaaHo+DD5rBGkPxaM/SiN5YP/ZCDeJOVyl9dnyGIN8vwC1VSLbOW0OhWw+y0YzpqDtsSYIFAcbmjo0XUHgQmh0lTmI3Zfn0Ipe3jyJNNMDs/a6Do9lYtRaETfNNP5oxqZ3U62kO9dltc9OdXCCUkNSePQjdrSKpgwgqKTx62ORqTEyxuthYB0Xg2KnbXDJof7LyFF0AzloL+woZKpZLh5PsT1LxGt0RYviD8bcniyE6je9eb0sJSSjQf/CfHcqoFTVwLisSKJai5kl9UQq6HCi2X6n9IjieKwmGCLJodWv7kXiyQoV3pZPJqBL7pL49KaGdOsbMwJV1NoFLDmWkEYSYx0di3Ukh99ml511IV+nryZnz6ebF3P0r0VRiXE//og62ogs0FvRwqxBPxFt0WrrF0PN9NQmteQrAhuxb7q3DBqMWY38kJQ4Rt4O0rVseEqWyrhgjbuY7A4rB51oK70gK+qL8vH/wKDZabkhT2idCkc7/mNYPJawF2zlnVIc+PuXW9xNyS5dNpPLSenYPNwBUhZEffYUmnCZ9pSq9kN+1ImX+gl8sCkZB2R3Myr+zZWA8sceJ69sMERqXzWAm+QuAQZrRkpeE9OPtipoL6s0WyNv+1HQOUjudr671Pe2bS2mmN5npIBAksYosN36t/SEfI/LGlm0OOyRFdczvIYjLK7Xit4WK8+dFPaYhXPM4CxSpOk0sCA8+X27vPxCYKmFLI2
 /tGIxnvr
 Kgj5OGaD64m+Euz8PHK1KcVvX3U1yVLPw3xgOTDQJjuXWF52f1I3yd9f+aG8NXtNyllh3dl41r+vc/8XfTzgfdReIUDE73EEGM1ViXQ2eQL5RigqKH7Chp3wnNFxI81v6HFQ0RzzIMjNvhp504MaXx7n9U/qpRBC7dBTksTsDGLfJEmodUfj1HpT7EsZwratmHAm4Ktn4sgd2em9aPwAe90cVfd/Dmo7YteK6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_STAT is intentionally providing limited information for easy
consumption of the information.  From production fleet level usages,
below limitations are found, though.

The aggregation interval of DAMON_STAT represents the granularity of the
memory_idle_ms_percentiles.  But the interval is auto-tuned and not
exposed to users, so users cannot know the granularity.

All memory regions of non-zero (positive) nr_accesses are treated as
having zero idle time.  A significant portion of production systems have
such zero idle time.  Hence breakdown of warm and hot data is nearly
impossible.

Make following changes to overcome the limitations.  Expose the
auto-tuned aggregation interval with a new parameter named
aggr_interval_us.  Expose the age of non-zero nr_accesses (how long >0
access frequency the region retained) regions as a negative idle time.

Changes from RFC
(https://lore.kernel.org/20250910040022.168223-1-sj@kernel.org)
- Rebase on latest mm-new
- Wordsmith commit messages

SeongJae Park (2):
  mm/damon/stat: expose the current tuned aggregation interval
  mm/damon/stat: expose negative idle time

 mm/damon/stat.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)


base-commit: ae4745146347aef91dc328d1d9a39f0643ee244d
-- 
2.39.5

