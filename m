Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12E6FC61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 04:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B00776B00FC; Tue,  1 Sep 2026 00:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8FEE6B00FD; Tue,  1 Sep 2026 00:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9522C6B00FF; Tue,  1 Sep 2026 00:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F8C56B00FC
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:34:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE73DA0297
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:32 +0000 (UTC)
X-FDA: 85163927184.09.2D5B38A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 610A6100003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d4qUsh8V;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788237271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CpXkgOmW3GSwhrOkMdO/S1mj76NXWWV8m3WM4J70bcE=;
	b=AXTTFNH+epo9K3dFlO9/Qcr3VZ4scYXtgCuIY+8/C3od8Ly9M24TLQI/VEnBJzzFcrDjPl
	Vb7ZcVql+1ac7ab3I8/pg2HmcgsXhxGmP1NWx+dBNbVQ1SHiUmJ6aE3jp5gqBzi4lEiVsh
	8lPybMH4kcF06db2VXHy00d0+PmuVVA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d4qUsh8V;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788237271;
	b=wSJtMxfOHvTc5D4m2XvHNBEXqL5/gWmpjNXPb4zmK4/eeXlCqqb8OZoY0X0AmCiBTC6LQU
	2kum6+3AoTvAfrJ4rhK4sXFAHCmA+0+BU30TNXtN7DVLq7BVBiAG+PqoejM8mgMMiHKUht
	Tuw4YXkKs31H668MRW/U1jZ1J4slkig=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D16940176;
	Tue,  1 Sep 2026 04:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F3E1F00ACA;
	Tue,  1 Sep 2026 04:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788237271;
	bh=CpXkgOmW3GSwhrOkMdO/S1mj76NXWWV8m3WM4J70bcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d4qUsh8VH6LG0mrJ6UNN3Jmg4osXJJohaxTB0Tj3iJ77xaBCrcot88uzDIWSNkDZi
	 UEeh4znBav5abJT/ZG696xoT7Al9mWLGavrWxSRxE0tFzqDQ3fTGk/u3JZ+Q95ztEP
	 SLBmtPKBwaHdUmeq4fJOW8jQbnfWXbElgjXM/Xwqu8w0/uOpUb/Eay/Bcit2poEAeF
	 F2nC4/Id69cJkDxkrqC4I/zbYbB7lsBC0NvXzca7jfHBC62I5ex3SbseQ979G/hJgs
	 VftSP7PQYTafZz2PyBGVmlL458eRpXYo/vHjdBO1JPqKOUxp5CNsCVK/N/pn77+o53
	 h1NoDO/LgNPEA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 15/17] Docs/mm/damon/design: document probe preps
Date: Mon, 31 Aug 2026 21:34:11 -0700
Message-ID: <20260901043417.2165-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901043417.2165-1-sj@kernel.org>
References: <20260901043417.2165-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a4e9ks7gndb6stt9fod7eny5x6a9sbt4
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 610A6100003
X-Rspam-User: 
X-HE-Tag: 1788237271-158441
X-HE-Meta: U2FsdGVkX18kQ9O/q2Xcfnn56A1GBhTOE8kGH74YGyMHaezdoSUV7TG7/3UX+vWiXhlI7C5ZEMwaOW1eZOyRcy9Y8Yw9r6TzRmW7XY0EKx54meROlPxdugOTuu6VTPoIpC8n0alFIiY9W9O8C+UvmZb2Kg+MUs6eZoVSey/tBfo+K84rnv7D6F3L7CHd/JRAQcRq/7Tm/ODT+erL6AYC4cEkti30kVtoXe83ZpFlyxMAwLDliOMR3ahpXJD1IuvJTbO/FnxTU7uNdYtK3p9Eub8K0ZwIlcL0Cw4y1rURvn/2CXk+LPScQAp6a0GfuxVSGqJXtt7tKZO8l7c6qW4I/ytOFyENDBWb5pEcxxYQJ8izMh33Goj+CaruZ/+EcgVTt+PH6jEnxdnIAsCOOg+vWpW3d4EEueILDd9ZON7zRRrGRXGG+6edL+DQ6CVgCQpKkYCTgoq8gL0jdZ7CYY2CHIoEGg3OXnzCsZBd/+lF4+YF/BKwURlDmUuaY04UmqldTWK4jmT2p761DdRiocuF/YwYP2lQlhA4buWqcBmFHmv7LJdxVnVKijGFd0jRuBdeXPTpZ0D2ggAMmT7bdYjo6XH2QqOCvsbTt2KCrvwbzuLzb1HamgrDGE9fOrHq2Mni55O0xCjEUTXgSwvUV0ionIF162znPW5O50LqFBcTAbG2n9RVBLbdZZ3k2QxuWZa1RuFZgDWwhgY5Q07Npd/z5xCI7JfaLZWJOMcWdiDgWNaoaoqd1gGoaQ6we5ZcKjwHd9gcaOfKMBgOzd9OAXSXoAWaUUM2MI6FjGCdMBV23+UZMtQ3hRONLwVpXiuj79DFShwocnF5mkw505L3HQfJox2VdLm3Hpe40xJKhlbsAzqdCebc1nsvSeiREDbuSE5naA97J6Om6dE9V2Ldl/Q2rnqz/JTXa1Xqy1wszaqD59+i3AW7XpqXkoxlVCEpJWVkDcIJlZvh7nsQ21ad1ts
 dgm1i/So
 CdN7zdGul7XayQKjnOYsIdJ82mYzIEbpPfWe9eOFMVV5M2Pv4kqjaujG8oMgNkiVZOIIxbpLtq7fxDiD9aJGLdID19+A9fhnA6Sv7hAESbIIvbqjIaK7L7T9kxqqAtSEUCl3wSgjzyTuOFzXP4Wm4Qz5Bg/zJB+aALawRyS/PssIgxM2ieDDyolm8b6liKw2fX7+TWYTWzjtabAwmP8sRMf+/3SRj4yzABbXmIhof3og8tKs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added DAMON probe preps
feature.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 947d91ae24a39..d036340dae8af 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -309,6 +309,13 @@ Users can therefore know how much of a given DAMON region has a specific data
 attribute by reading the per-region per-probe probe hits counter after each
 aggregation interval.
 
+Users can optionally register probing preparation actions per probe.  If such
+actions are registered, DAMON applies the actions to each region's sampling
+memory before starting the next sampling interval.  Currently only one action,
+``set_pgidle`` is supported.  The action marks the page for the probing target
+memory as access-idle.  This can be useful to be used together with
+``pgidle_unset`` probe filter.
+
 This is a sampling based mechanism.  Hence, it is lightweight but the output
 may include some measurement errors.  The output should be used with good
 understanding of statistics.
-- 
2.47.3

