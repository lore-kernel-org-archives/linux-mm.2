Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AA67C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EF9E6B008C; Mon, 31 Aug 2026 11:07:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A0CE6B0095; Mon, 31 Aug 2026 11:07:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B7026B009B; Mon, 31 Aug 2026 11:07:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3985D6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:07:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B244DA31EB
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:07:00 +0000 (UTC)
X-FDA: 85161892200.10.C09F22E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 41B17140011
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:06:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UETTYhjR;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788188819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=f4iZoQApQIfopJT8EkqZwFe8+jFo1ysNs7WLaErjg9A=;
	b=NiRpayi56CyeHYip36+iu0qd9nfDDyxxvwOhKT3t//C5legRlZjh5wIiR1gbeoFLgGwwOo
	CdPCijdP/fkzlWKiWk/D7JlUoYDMq/qf6nH67GmOsokRJodyn05FoZu5jmJaybOz/NUWwr
	vboOs0dOErOb96fRHSQheDtPBEgtO0Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788188819;
	b=Ko11Kh5KUtGKqCSIKjQwJoq2q0G3tdwhenpiDuABbIurWxjzPrPQDz34Kn4kiJOWUrAnch
	Nq8tccN/4wAfKbxvDe9tDzEHieQQr8WSeuc2MjxRovCxLJ7YZ0Ud0iD9sgZ9YNu14vT8sE
	XAzex6x+zpjYkswm0/X5tFS7WUM++d0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UETTYhjR;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B4BB360120;
	Mon, 31 Aug 2026 15:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2641A1F000E9;
	Mon, 31 Aug 2026 15:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788188818;
	bh=f4iZoQApQIfopJT8EkqZwFe8+jFo1ysNs7WLaErjg9A=;
	h=From:To:Cc:Subject:Date;
	b=UETTYhjR1rTXv97DdzXd4cNx6xYLQVULNS4zG+oBtyJsqv+07TzNV73TUu3nwkFXA
	 AVtE6H6Pmjk8cWrfo7SDBCOO/ZcQQEuHEuE94YCQiv6k5ZWVuXhNbwboKuxck9hCeZ
	 kYuVySqZCoD/Tfw5wlqkrsTr0QcwiDLiz51k3uieIDmCdOtYn2t41OrjeaPIeZqCzC
	 Bde08XvKxrSddVM3nnD1+hxa2koiRvD6z8Oloh1M4esG6f8GVlzumukBP9N85+VFfq
	 Tnz56xumE6HiEqo/+VVgbxCz1Pc3eN7OEPoPxUSsTEDoY+ivpog0KyzQE2N4VWz6Bh
	 I3e/5a5w4YYGg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/2] mm/damon: add kunit tests for probe_hits handling and probe params validation
Date: Mon, 31 Aug 2026 08:06:47 -0700
Message-ID: <20260831150650.84829-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 41B17140011
X-Stat-Signature: oqi5jdwgxiyutbqe44bpynm177c6a65h
X-HE-Tag: 1788188819-357242
X-HE-Meta: U2FsdGVkX1/kEGsLpGKOM8iFlgmC5xhbwN1AvvVL6LpAPXNwN2wPj9b7KB0fAwRMOMTruNHlwKYXmG1s8VGwgNgQV7Pix0Uz+UG/nxMMt627tnGaeKq2xC+HkHbj36sOvNnjr3355GzN1ezTgg9fSQQAlPjh6DSOsk99NoHAOc8WNFl+eGjmb7DpP4H4BkLr3MUQXJkuTpuEdiJuCnKp5/54Z5TQfS3hXTbPfRMwL1jhYdxZCt+0kl/50u+y6hwBToCQMXsm40xOAAJQ3lewgRt3uK18jsY/GZKgWWwV20xtHQrqln7Hw8dmEtSwE8781fIzR1npiU8fbIFeklqjgUdQ69qh49AK+YfaT0gTs9BQgTPIlTHmVz6lLXp/j0NQiDjbCpZURZxUkJwDQQx6nzMJJd0Wy9HzQwRUdpBdLJc/VTq1Uv2TNa/TaYaP+Z9NjpNzZkupsMAIRW2b86/awVN/+onVWuY545plenE9s1dzT2cE0R1E9el3fc5BV78BY11e4xFZikUAZBV0r0nFkVt18KHN5Y19nNLfPob+eP4iwyU0yPQsFHvKbGt5bg+SzXHDWeV+Dr4qDSRjjNADvVI2742oWtEh3YeU4Iew0xRxWYQdCAvxq8fEPTfTqYjAZ0/GgA+RLusacX1HANV1X9YOAw6/ShBAT8mvmukr9O7dUj9Vj926bnxSb1rGVeBDrMGNK4CfSQ+XUpD7cc+2qxTjvHRm0dwSvzdoj31W2Bo0JLjwxFGzKBUv3s2jbK2jsNgHavZh1DWsPGHMNbZvne35c9FlTa1U+t4cazpNWVnzQF6abU3ixeR3uLO50/qH67pAXwuegLXKuNgEIRbWgf/i6L7Gh2jL20NwGYLusZmQLTkVseNA8+ZLBE7scpsPdihatvjC6kcSvfsOoBJ2/cTPKkUViCFem1ZPjHaBKT6XQtSQP2PvnXyF6+QgT+XzjyKZ0bdF2FWFk1Ylcew
 XVlJ55wc
 VRWgsdL4GbsKSerTuiXaEyjt/4Yg0zVaybeZ0wUq/0O85Id/rHCLR5LCEZiWP3H/6bNSlxnfiG6HIvBZVEAUOEXiqiZZ+MygNha/kvHyetneN5eCq87pJnKcus5AGZqTu6bjoputy4iMk3+i4pp9SSa7NYdDhcZOAz2awf6rFMCnlHWAGFIkCACSwaapbfAtFRBYgfeiHlwc38aWQiJxa/vsXwmaSzOM1oVszUnw1iaUA31D5Mmje2/s66xbyOiPcCO0BBIXGONr23I4ncQsrjN0yOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON recently introduced probes and probe weights. Add kunit tests
for the propagation of probe_hits at region split and merge, and the
rejection of invalid probe parameters by damon_valid_probe_params().

Changes from v1
- v1: https://lore.kernel.org/20260818034552.11975-1-jasonangelov@ucla.edu
- Collec R-b: from SJ.
- Rebase to latest mm-new.

Jason Angelov (2):
  mm/damon/core-kunit: test probe_hits handling at region split and
    merge
  mm/damon/core-kunit: test damon_valid_probe_params()

 mm/damon/tests/core-kunit.h | 64 +++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)


base-commit: e87656db0d5bae45056740ce6fc5d41e182013f4
-- 
2.47.3

