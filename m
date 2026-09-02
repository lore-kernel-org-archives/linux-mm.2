Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1A70C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:25:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2FEF6B009E; Wed,  2 Sep 2026 10:25:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F06676B00A3; Wed,  2 Sep 2026 10:25:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E46D56B00A4; Wed,  2 Sep 2026 10:25:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C623D6B009E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:25:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5C0D51A022D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:25:20 +0000 (UTC)
X-FDA: 85169044800.14.AAD9E17
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id AF6011C000C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:25:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dd3okxwv;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788359118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dwH6CzjmhB+SmHrUUzJ8KL/hFq+AZimRbmxhGf36Cd4=;
	b=1moyJex78WSHBMQPav6/lkKfVWavj0RA/Ma7NwDSWR+RtXRz6yorJ3HxIJ1mPxxVFf3vBZ
	lU4/bnOiAV6dk0G1CnGFy1b0f+tOBVOMlVc9dLXZ9nRgFjpMPV1wSIslRAPjROAMBWyCdj
	SRNOSN6bytg1nl44BpR8ip4fd8kksGU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dd3okxwv;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788359118;
	b=LAAGKftBKsnqT8S8rXwC2l3kADQK+OVBGsGQzBdlfl3GehOxfCLhcHVboXAPfGgaEglV13
	B3BbVizKNB+80oG6wvlWC9tgzWThDbi7NVJ5FSWHhDkwKLWwG5GZqz2ndndt7uAcSr6KLm
	XhT4/k5DTalQ73pnWodmRErDcfoGpD0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 925C641969;
	Wed,  2 Sep 2026 14:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0131F00A3E;
	Wed,  2 Sep 2026 14:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788359117;
	bh=dwH6CzjmhB+SmHrUUzJ8KL/hFq+AZimRbmxhGf36Cd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dd3okxwvRWja7d9dxhaloYRzmW51U2RWUrlPNhitArb9FLFn/8CiJO80qz3SrZfac
	 2130tW2M+GIuNq8HyjRRg5idQqW9AwBD5cA4SXWyuvu8t4ZvuAi54oQ0wwYCZv1vYx
	 Qoio+2r/j41c6HH/CsD7IkCm2D2Y9BWUev3KpjwBlj74Io1nMsFLbBlQci5h5fOKyP
	 rBjGVMu4Y9VfTAC+Pi30uYrdX5zx79HHCokbzSeV0/cH/iqEO+Gl1y/6CzlIjZ2iUy
	 jWcIbB23ujFq6l0VbD8oqAv5S//E/oQxktCfQcCSLcxQQRGJKmMZ8c2D4eXimQida1
	 EbLsFTgaqo2lA==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/6] mm/damon: add kunit and selftests for probes and probe weights
Date: Wed,  2 Sep 2026 07:25:09 -0700
Message-ID: <20260902142510.87878-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902140313.85983-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kkcy7fd76yxyo3mmi3ayy86xgbxzngw4
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AF6011C000C
X-Rspam-User: 
X-HE-Tag: 1788359118-890147
X-HE-Meta: U2FsdGVkX18dBb5u1SBb9b98YzX0ki+8MqgbaKoTyQb+gqzHrzoxEKpEjC2PE7xClhtxCY6GrdUT6r/tFvcTwd9BMs3CnRQzH/I5xbNhidSVUaRNK58MwBmrmAvT7PA9v6EEx9URkPWmPkILbCJlpjA0RDFUymEj9N+tMc7MK3WRxuVwu9EWzwn++PxyOjp3rN06gnnukL0toMDAM2HvtCQx0200k9xLYN7bJ83giRx6yvIq8vDvdtQzYd6xpkt0dwbBQzCO6OfVacWWzdNNQNq/yz0yXACyeuhh5XTH36HBe0kGJ/Wn0/gyzHE5VDTMOwEheCgl6zM2tuWxEHGdAkfKs8E7WchE0RPwSlx1+FKBA9R5BGsy88kObkrqH/umPVwxNS4pRbacSo+bRFo+EbHHgYRPvdvERqnzJUQdVz3fItdPHlRcBWEJkBhvTNNCQsJGiZZ/hy3EObWkUINh/0f1Q+zMgHwz26DaOh8HrATaexi7ovSY050D/V0ryo6hkPPDlWZrxyKeeq7PybQ/YXKgafTmwgTy2uUVVkKPC2O7wlcBg7NvIfP1KCrm2EGDkW2O7n/5CgsSz9oNATRH5QQrojHqfbF+4mSDCn3twCcf6O22Fohu8iYyVTlB//lq93ltcBsXI51H/Y7zMAmnkPrbgjvG0nwpra34a8/3Bc4yL9v6C6qljmIoqD2soGELUNsY7dNVzuf5sAj9SwAXp9jSjRKZcO9pcUhdGafGYRhHZvXuhZxpuqRvgL8CLsULsWOw8IDTTg3mMts8c36s+2Bv2lLsPd2kUQWhCSsOr1rwWBJNMFzTE/j1YAGQftNVjems1z3H0UjltIqS1Qv1sifKEtiz6cJasntEODiQEwJjxWAB1JdlsgyzYc0JUKpTGNNgT3h1U+3ySCMIsyT0bPjAwG4emmztHyvhs10Gz25p2E1V6vgHEVyZ9AnmEqcUaPTO3/a3NI5p0VPgYOv
 WEG4UCBI
 jN/2MpT5evjppRV5PNkuVCQG+rXWHVwALKJA3aGvcNcCua48Ydg7n89CHMWK5WkvdhgqReFkDoHSeNifPHKb2hlp/G7ugvNPDJxAmjSUPnW1u/D+mZ9W6ok0rlIOzI0phCTk4Ev3jIkH8Eu21BydOpDYtk6wMlxyGbGSxbojHiTDjmSolcRfntb1YP10h31xkUZTGsNn/zq/zpZyWGTB3gd9sNkUEXfl+q1tG3WQjnsnKPKE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  2 Sep 2026 07:03:06 -0700 SJ Park <sj@kernel.org> wrote:

> DAMON recently introduced probes and probe weights.  Add kunit and
> selftests for ensuring the parameters for features can be set using the
> core API and the sysfs ABI, respectively.

Sashiko found no blocker for this series.  Sashiko sent findings to damon@
mailing list [1], and I replied to all the comments that have any potential
issue finding.  Please read those for details.

[1] https://lore.kernel.org/damon/


Thanks,
SJ

[...]

