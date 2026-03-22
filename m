Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9142FFC72C4
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 15:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4E726B0096; Sun, 22 Mar 2026 11:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BED7A6B0093; Sun, 22 Mar 2026 11:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 979CC6B0096; Sun, 22 Mar 2026 11:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 781416B0093
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 11:57:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 34FBE136246
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:41 +0000 (UTC)
X-FDA: 84574154322.10.3FA41A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id BB365180006
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rx5CvT34;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774195059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gIFJcc/U/FGZ+jTSwAe0YId8k5d0mbeypzHr/bajX3E=;
	b=LswC8DgNDgbHjoKI6ynTN6HDPFo/4lpOwqqoJnSkyv40xQJod7QRDChv+mIFfi/iQO3X2c
	HpZgFQltEriiUB/lTUxwbzUnYK5klVM4gmQB/ZyWHOydOqkRslaU6NcqxV7NutFqhZk+AG
	lGJuUFw69hd5eBo33LL5uaQCRS5/eyU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774195059; a=rsa-sha256;
	cv=none;
	b=raO2WzyXbSvIXr/bT0XA5+Swyjns039ZlBTe/i5fimIVNX7j9WVCBeilQXhOnkVFVTl8et
	HP95owM93IG1v/Tjy6dAFxKHJMYH/L+S2UMABiH654lXJ4VSIMyK2HFnZqjbDVNzZ+HQo7
	RQmzkB6txIjOJ9Hac3hpfgsnFPcoSaI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rx5CvT34;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D94BE445B1;
	Sun, 22 Mar 2026 15:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB1DC2BCB2;
	Sun, 22 Mar 2026 15:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774195058;
	bh=qt20gza/ZGfZPnGlsbY2CkGg3eBlVlFouLw/z7b3qI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rx5CvT34RmOppQtu6QxfqLWQzRWwbcWgOty3/B822ykfngK25Ar5ud10emwDWJIzS
	 xrEbTwTN4Mx+Ijeq6WJ6Cfopp16atDTZN0nQ/OHcImSj1OlTi2Zs31rLD9SSMvBOUP
	 erd9CvY3+Rt/aaYAN9stVROOuOWyOuRAVQRbrDGv/ac7nryJP42qaCjaRszDv9iYF7
	 a+VXzrHsDhX3ny7VVnAM5c/lM4uZqcHI8g5ll/L2LUGj4cD5ei4CiRjVPasL4mABVv
	 7o8+fEfU1WfOa0hEGojJo8HqcsfbDBMjUKChQJfl/1aCCoUVAD3/Ji8qlovGLWLuH2
	 DhGyAe/DjdiQw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 03/10] Docs/mm/damon/design: update for context pause/resume feature
Date: Sun, 22 Mar 2026 08:57:17 -0700
Message-ID: <20260322155728.81434-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322155728.81434-1-sj@kernel.org>
References: <20260322155728.81434-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BB365180006
X-Stat-Signature: msu7z8kw84zy9r5kwpphpfd1bg6zqu16
X-Rspam-User: 
X-HE-Tag: 1774195059-706777
X-HE-Meta: U2FsdGVkX19T00koQSTGudJFh3u2GyWlFqkCfwNDp0vBnh5ANaat2/agynVsGTU1yMKM5JfihWhiK6LbbbIsCjDvOK5XpPgXu8OQRU0oyp4SNUcptJcvRFDOrM46fs37dy8mBt1DeXTGrkGM/uM0XSwbui+Q5ENh2PgXh0nmmG5n8hvKn4VAR6T261pG35kcNixliXBGtKH5qXgpAztrJuvVVlymFnwHpfEJ57nBlhnyNQeOTJG3d70M4AYaT9d6m3gD11jI7tzdRJejzNuM1l5V8BdklIArLtmew5N3hxGsyPEbfYgmwPgWuDWT/QYbhGPYNMlyZ1RGG4cq1cAfPKiY2ec0HbawtxP1asGVQ6pt1Thf7Qxl1LZiW3SKQaoIqce/LdXbd5ia+punNkjF2dhQFnCMBWwJF04byNUtPdjVqJqO5AUq15xIzIrePfdRaFCrr5hqtLGOzcuXhl4wkSfCpIHeKpsMf8PQpVXuBuC8y0CRjQM7V6zvx5C8qkFKywhIQ+IHOd50eyQzam+o0APa/9r3aaQXG6L6rMcVF7D51Mex5NDgruJjY70rjGD1Af0t08VUk/j1oJNYpFOkwbRBaGqHkSm4b7fpqJ1bjMgWKLvd0qLshD4VoNyq9g2TYu/TakNEjFnb6ZCpU6AW/+QFHohWpHwj0qSQ/5Hs54+0agqMmGQWNlGjVOk3JHUbYg8lpvRGVAU4Yl7Wudvgq9FdjsKzmema4i5Mujd8CrhnPou/opISByFQUsWFGZwKgRnZdtfEDji3eJUv22Lvw5LC3YRBl4asU7RQrqRTsl2dm1CxGzMxHd6JPXkHdOBKxwADyFtJUzWJMm8Al+i5wpjHwr0LMRWI/UfNg9Xvxjsavkpy7O95Cs+bcyeUtR6MlIXKi+La7u4BIGqCPf2yjgvxHQo8m4YgoE/17yF2ZXsEOOhOnyhysw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the context execution pause/resume
feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index afc7d52bda2f7..510ec6375178d 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -19,6 +19,13 @@ types of monitoring.
 To know how user-space can do the configurations and start/stop DAMON, refer to
 :ref:`DAMON sysfs interface <sysfs_interface>` documentation.
 
+Users can also request each context execution to be paused and resumed.  When
+it is paused, the kdamond does nothing other than applying online parameter
+update.
+
+To know how user-space can pause/resume each context, refer to :ref:`DAMON
+sysfs context <sysfs_context>` usage documentation.
+
 
 Overall Architecture
 ====================
-- 
2.47.3

