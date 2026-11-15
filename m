Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55B4D606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DTjLMC62
Received: by kanga.kvack.org (Postfix)
	id 74C756B05D3; Sun, 15 Nov 2026 15:29:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AEDA6B05D5; Sun, 15 Nov 2026 15:29:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5012D6B05D6; Sun, 15 Nov 2026 15:29:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CADA6B05D3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:14 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9620D1C41F3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:13 +0000 (UTC)
X-FDA: 85438492986.26.C0FF73E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id ED89F40003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DTjLMC62;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R78z6DX4Eb7n5m3aMS1vuBN9kYcpNJhnmoRj2a8fkoA=;
	b=inLtEWeMvSr18Yz+AxSBSRQZISqixaqCLr7yVh8QzjZgudbRmCk9dA+YJtMopY2sqjKvsZ
	lgXhvbMqNakfOIslagfTTfjf640CirvLLVAgUwlo2dYySlJiF2DAd31nn8X2UMYYXr8IVj
	LRnkJ05H00TD6ds8xl9zEkHVUzeGc9o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774552;
	b=7bcvRMJ1cygeqGMKS+2WDWL0JqTN+A949cvloRLLoISYEmT58tUy6113eAK89KThpzfppc
	eA7oY8lDczK74/hRqZ+QxALL51Wg86U3O6lFVTHGtIkiWb5wDUt/7hOMfBPvVrDRTKmybT
	I6K+b5B9Is9KXgowlS5fwQqQoQkWLSM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DTjLMC62;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8766F60DB3;
	Sun, 15 Nov 2026 20:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A121F000C7;
	Sun, 15 Nov 2026 20:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774551;
	bh=R78z6DX4Eb7n5m3aMS1vuBN9kYcpNJhnmoRj2a8fkoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DTjLMC621hUn/Ztl5qDfxHhBXSLZo3EXqZwM98+Ca6O3K0Mz2eR6WJDssEdG5oNwt
	 nYvY3YlnE3xz+kSl36+d3UaEjqv4gz4ZxONiyWNmFzljzLX9h6kgWdGh0GpNkTO4wI
	 d3mu6f+pQ2kC3nIQ/XcDOsdB7K0RD12s6DHeHZdxEDXXlZV1mjarguB93sRS0khyEV
	 jrVzJQc6Ym7KBYYUpt20dL40CWAawxxanzBhRonB2KHLlUX1jg58fPalptkPQxhKX+
	 iYdw4QMeNVuukoIvy+PFI5nEV3Ia9UYr5GFE8z1H4ZSaM2qofMuo03WNLitvpgIAfw
	 8RSFH/HbgOeyQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 26/27] Docs/admin-guide/mm/damon/usage: update for user_report report support
Date: Sun, 15 Nov 2026 12:28:44 -0800
Message-ID: <20261115202849.99134-27-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: qyn4t5rpf5tfe6ddag139176eaqjaudp
X-Rspamd-Queue-Id: ED89F40003
X-Rspam-User: 
X-HE-Tag: 1794774551-918159
X-HE-Meta: U2FsdGVkX19Hx6AYnogoCfb7XC9WppgDyirWlu/WNTUozjqCTQkmr1tzaTAsQeYRjLHG8Ga647F0fBdEu+ECrAVQWq2zjYmF+OH8nr/rAUOxXyOcO/kaBBTG1ijn3ppCDNz4X0kIj9Ed8CTEgFVcI3+9FVX0mUfe/aTGLaEj+0yHSMBzybdTiqQHlMQ61gp9tjTzdcnV5/dgiDCsyF/R2NKw47C1K4VkkVZCB1q5PgR3zYODGhSvKLmozOR7aXttJWHRl22CsnGvvImlX4gZFuCS8ZlilVTYnDk2PIrOVcSe3xv3S8Yvphi4GTwRbMFK+pz7e3h3lyhB5DYDeKMdBcRxB0tDkyx9HbtRWFG/gNX470orRlknDze7MbmXkJmUDbARgdjq++1dc3Cs+MKuyhoBTGblayNpXI5oJM26tjWmo9sFr+3VoMbE/TtSgPluEMeIbC2N7UVQ8fXunRusRpzA0U4kViLNZD1UWLAyo4VecSI9Cvu5DWvN7CzdS44jhibyXhuK7DR7ppyAIeSfWAR7dPovURHZgDIK/6oCH85/ZIm7ryNXdVnXkDLSPC3VTYG4W4a0ij5p/YwpnC3oabco/zr6AT3kIyZlOQgJdfM99Zy5JXefe7pV+B40Xw7zTKuQwzLymb/EyXL297Y4AuNp7fwsi3KUbkc2DNzJxX6Y3+U1r3Kc6SXHwNjzX4iiO9Q+lw2s2pF8C72wOUdaWExm9UrPK5l7ZN5+KnwF4R6P5DqumGMBOJubQWPKLFVKTZPu5JygRQ/Ovz1uvbFwXdZ0jrDRH3dyx0BxvHShx3qOLl5a0/2gaY+S2UVqtxpuawd0dR0ZyPmNAnFGgF2J/OMsnM7Yg0dqqw6LZlPZnH8x7Og07A93tCsd1b3WDoIL/o51gY1s99ylybGnnO52eXtpQirZ3hn0a9klFrKony2HGzk5mJtuT0mLwkcwcvp9FU1gT9+FRJQcaWUab8H
 ead3/Sz1
 6F4UJeV5y31WUUJcEutLZgajAqrqLutF+Lx67UUkCjUXR0gWMieqq5Xos8h+bwaE2VAo2C9NFyikoEpdU8y9jn3q/G2TbVJ6pLRqkSMtZXx5Yd1tAzziaGm2O7eNsIE42Tx2OrVb74Cp50VNi4iyOz26aZdiqdPpWEbtr+jEy65GQ2pIdYkXSMyV0CiyyOx45osjtkb4ttyRN8i3okLW0725xXzFbTeAqUn9lAfkpebQGBDoPktdmc9ZxcH2fNM11nnmnn1oStjv2rx2I0xumCbvO5s0rKIiMPjpyuz54VDw7J5yC9CjGj1tyYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON usage document for the newly added user_report type data
attribute report support.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index ce4e9e4c13276..4024dd4e92979 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -117,7 +117,7 @@ comma (",").
     │ │ ...
     │ reports/
     │ │ producers/nr_producers
-    │ │ │ 0/report_type,producer_state
+    │ │ │ 0/report_type,producer_state,addr_start,addr_end
     │ │ │ ...
 
 .. _sysfs_root:
@@ -767,6 +767,15 @@ Users can write below keywords for the producer to the file.
 
 - ``on``: Enable the producer.
 - ``off``: Disable the producer.
+- ``submit``: Generate and submit a new ``user_report`` type report, if
+  ``report_type`` is ``user_report``, and the producer is enabled.
+
+``addr_start`` and ``addr_end`` files are used only for ``user_report`` report
+type.  Those set the address range of memory to manually report .  Users can
+set the start and end address of the address range by writing the addresses to
+the files.  Note that it is open-end range (``[addr_start,addr_end)``) and
+therefore the end address is exclusive.  Reading the files shows the last
+successfully written input.
 
 .. _tracepoint:
 
-- 
2.47.3

