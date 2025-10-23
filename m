Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E644CCCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AC7B8E001C; Wed, 22 Oct 2025 21:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E0F28E0012; Wed, 22 Oct 2025 21:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F7788E001C; Wed, 22 Oct 2025 21:25:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EB0BD8E0012
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:25:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A84F413BFA3
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:25:47 +0000 (UTC)
X-FDA: 84027637134.30.0987783
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0C7DF40004
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:25:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OntKqQFK;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761182746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZpwJZOd7yqtxYdsg9OdSwCybxkWwGHM+qLZxcmnkpg=;
	b=OxHFGg61VM8uzT5GSgnjo/ZQtrqbGictj65z7o+BosRSxEne3DgK6rCWlmO42PWpMMYJnz
	w9Qmzb5NwyiK2WKj+YzCscyRwcMubzUf2D4WKFQcvS/huyMnvvxjmBbeE1xraovH9v3YMN
	M804AqY3qCuMXE5hq4KlJuzWlxPjzhM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OntKqQFK;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761182746; a=rsa-sha256;
	cv=none;
	b=tweGYB4j/Gk9UfBd3g50BwdUzyHWWT60++/zh9Cn+Pfkwn60aY9vT3kLTqRGz8pvA/Qkri
	XgVT69lAncn03AwfZPo9mqUecu7srwzTU1uuwRa07mQHMqr3w3fdnLS+UJFFZqBiAk7PTP
	XOsYQlxfqRwoHw7+oW+IHdgZqWX6gO8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 440DE4A8F0;
	Thu, 23 Oct 2025 01:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9905AC116C6;
	Thu, 23 Oct 2025 01:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761182745;
	bh=P5iwpdgt+gTVzJnYLVnDYTD/06YxCQbWf1lq1vcjQO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OntKqQFKQ90pkuMEJ/uMDhG0j6Z4ILHt3/h9jCwhJn2XcLvEVzlucWwTQpii3YZa8
	 5OfOQMYEDdnpuEP4tcfbtcnasRYknDfI+5i6KPvinOCIHztJQHZmJJCLZYjDFh7PgD
	 S6AkvF6lUdeJnjfMSm7ou4zLMZ406faHMxVfXLGrGwkY68iVu+8RQK0m0gAndhZvXQ
	 1iWvSs0961w0nv43EfNMFsQWSY/gF/6yOUR33+Xs7daJcDK5EdK5xPzEarQI7Schyn
	 HGrgGHA9Beb8bSqZkRsUHbYL73Oe2C8h2jj7E8H5DYBGKVZC9Lf9Kv1W/l2kI3UBx1
	 WzP6VWC66XNIg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Bijan Tabatabai <bijan311@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 7/9] drgn_dump_damon_status: dump damon_target->obsolete
Date: Wed, 22 Oct 2025 18:25:31 -0700
Message-ID: <20251023012535.69625-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251023012535.69625-1-sj@kernel.org>
References: <20251023012535.69625-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0C7DF40004
X-Stat-Signature: ops1bfft5kf5ysxaewrpjf4kugfth6mc
X-Rspam-User: 
X-HE-Tag: 1761182745-420662
X-HE-Meta: U2FsdGVkX18KHLH3Qa6H0krL2ZbIFk+sh4puBHAZTcFuqKJUgK7+XIoLioNzE+4cdDzvVF3A6/PyjhXAuGzaAsyUoIbYB15YXJk++7j/DWKkpKioaGWayRuPjYG4Jm+amyqdAvF+P0gi374wsiqg5Ystg0dXTqnkO0RaEVPS9HGUxgmguxhU+QqfLMJA2fwfvjMOtKyKbxpN4ZbaeeT4UCKRiAUcrHKGCE+2Y5ygpBj9hffoSBs4ykC1AcJCx8eFaHVhLCVogjK8swTR+XMIbvYDMOY7tI+0BQVbe1tWz6ghMWLFG8EEIkeWouZBBAW2+GjTmuulo3RUCsILaI9Xu5wyPK8XT/oJ9fn7PIZTjTiD7wpXveF6yjsTgy491GIPE8HJ0aHQjXdwVoD0ifL20A3I/WsxS9qgC2eu3penAc1IZeGNLw+eQChitDW7sfrYnudR/BG66y6VSumo4JC4Vuwl9mnuLEtsURcfPX/vdC9L/bZDPuYYG/VsXejDSmTO4dEGno8l9K4nxSLL6g4YaoGXtUp1H7GjWsZs8ErmcJByDjCOjxzcOy2x3eU8YknnqV22qT0N+Tirh6ijlM3wNcfjliyFfxjfRrYsgNXxtxAcCTt5fSnx5qAagL9TABUgn/L/Ngfa082/cpmVZG2U69H42NwbcbvqLdryN6aGcogUnCSoLACPkXRKyw0HaaqpqFPCV/8VMgElC4Ha9LwdKet/AA9D7adzz/8V1xaV6LgIWb6z45629tyHo2dFy+Y0VZi0I8CxmaNCHw2q+VFk4JZjkYeWBkcCTbtx09lDYG/E1HQlUsvQVDNV8vChqRgoWo4x5+UHQmsClpk2FxdzZZlvdu89GH3veqVfWbLpFBtaFKtVLUfUDkh5iQ45wyNwcYQ8NBGAfD6QTWV49KT+VeyetdXHJ8R3UfNGBZF83esh4KVzGY7E5WFd6iLwZHCtDpgvwq14Y4/+1BPsdn9
 wgZuyVSw
 s6W0iEGktbTWg4MyCCUPqOJ+vK0+g9+ueBRSgrl6B5BgotlbgiXNmFpeXTKqJQzC+Op7eNZPMzX0CPKQNdVX+27sdkgVGSkkEB/YcMZK+OTT0MSe7DQqY+FGN+4sv5LnoGqlKxtcTVfRzDm72zS8v/yEjMR/S6WxoCWfSiquV++gRCdmrNlcCg7VdgvstpocckN4Sz9jru0Y74LvTmeBJ1FrrJutNjDAXyQrwnxEvObu2157Jy8QAPyGFyoqTFgQJoYSbWcLPiR4JxuBy2OpBOpS2hA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A new field of damon_target for pin-point target removal, namely
obsolete, has newly been added.  Extend drgn_dump_damon_status.py to
dump it, for easily writing a future DAMON selftests of it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/drgn_dump_damon_status.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/drgn_dump_damon_status.py b/tools/testing/selftests/damon/drgn_dump_damon_status.py
index 7233369a3a44..cb4fdbe68acb 100755
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py
+++ b/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -73,6 +73,7 @@ def target_to_dict(target):
         ['pid', int],
         ['nr_regions', int],
         ['regions_list', regions_to_list],
+        ['obsolete', bool],
         ])
 
 def targets_to_list(targets):
-- 
2.47.3

