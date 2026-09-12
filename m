Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BBFCC88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 19:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE84F6B0093; Sat, 12 Sep 2026 15:18:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99406B0096; Sat, 12 Sep 2026 15:18:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63B06B0095; Sat, 12 Sep 2026 15:18:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 879836B0095
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 15:18:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2FFB51C24AD
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:18:18 +0000 (UTC)
X-FDA: 85206071076.23.AB1D27B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id A96E440004
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:18:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ou+P7NXI;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789240696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vOYEln47T2FyN4vw1wuAHSZbTpeajPzH83Ujt47M+Zg=;
	b=AmndFu+VnefAJK/GAf1GmelHin4nGTf+/U87j39JlMmsDxIadWwa0wkt5Z01Poew7wSghb
	fwasBupZOTdngrLu/MNTfnetIWQ4RDGuCACkpOOxxkIIfqNDpOJJ/RDmEFWCslfk4hfW10
	E4TjUibXbPF2Iy0VtaUiKUmW08MuRRc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ou+P7NXI;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789240696;
	b=MrNuirA72hQknYMYVGnX674849l0dA8MnlOHvZtnq7n74bj/Vl2pKg1GSlWlQ/zIhimyTJ
	gRIjaTXruhVZDFstEzwoREO1MFWtXOmjtoh45Bjh6vNEdcQoTQywt9hhGKzNsBfaUwhuI2
	DYShWRY0AQHHBPZyjR1Uk1M4xfrSR8M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 92C8A40416;
	Sat, 12 Sep 2026 19:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E201F00893;
	Sat, 12 Sep 2026 19:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789240695;
	bh=vOYEln47T2FyN4vw1wuAHSZbTpeajPzH83Ujt47M+Zg=;
	h=From:To:Cc:Subject:Date;
	b=Ou+P7NXIJR/S+2iTvxe+RbilEBP2hV3MFAWs4vaegoABZ5ejRgcMjRRpmvU39AYq2
	 e09ZImxHjfuKCJwenOe1KRXV0WoMJuoUZuvGyRYkjqoIHUgqgSaTxeJo9IpKMzNvcT
	 UBZmB0rKSDjqQPIDQb6FQcXEv60mDWgpnX+12OOCrIAty9ENEIkC4whQI6D+1oVq5U
	 JszFjfGs06m+gs5szf/27ILaaFZyfBfzykinB8V0lKD8onVhNB3PyVf4Ia0OkAlnz6
	 ZDG5CmNZkDi2FGBgrMp74HCM3d635rQea8s3cqnNZlYaqdkryX43kmajDu8BVibC9l
	 USASFmlwJxXFQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/8] mm/damon: move damos filter range arguments validation to core
Date: Sat, 12 Sep 2026 12:17:58 -0700
Message-ID: <20260912191807.138502-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: nwamnaosxfnc3u8fkhfunscd7fo85fkx
X-Rspamd-Queue-Id: A96E440004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789240696-679838
X-HE-Meta: U2FsdGVkX18nD2wsWyfpW6nbpWkEgfkwvehpA67+lp1KPw4yl7+QbdtiivV82ug0mF+y0rW+UFg66a7NZmX/5CKSqWMDZtr5GrHNxSbg4fzoCTUl1QBRYuk1EpwslZB8eOlezb191aKs7D5ADkfUe5DTz5cGZD2ki4lZPMigxoJXKfgl6XgW2mLHQMm6YLkcGG0Gv6XQI8+udkUSMCrE4edWnD9IWjjM16dyT1zaOU3prnWJYfm57jnd8XkJnCYRcSbVABxHz0ZT4/1l9csUy39ePlBCBN6GvbR0+btacEqBfP/CsHTYEA+nVYb5KA+/fTBH4NosGr+tuJ+f5oX/Nqj2Qx/GINIZM5EnKvx8jKEFsh2mzZ68dfiiCnZcK1r/5vSWnNLpCyC5Me8GaYg7rUEVJLj6q2odweooUgau515Z5ZjeQy9OuJFbJuHNORIufmFMusbql+fxUks7jAAZlXTd6LMAC75Tz16I5CH/kz+mRZ4T+0HoleGl33XXSMiMNSRMVB8s12WtE9fa7Qz1uY33VxTBLvocj6h/jVcgQMSOfXNA+uHHmyKp2d5Np0MxO1pgMJcgL47SlTTq/Gs6dPAslJWhFdcIWuFmM/1q3UVZ/u77BRaSSSa8TZ86z5eayuYEG0hpr/wVTK7XuXwi57GI8NH+gCiooHhgw5M3u+Uvp3BLTIR8AjpAf+lIfZiXmw0SdhJVslHPyuJKqt1Qw6uDuDftmHbAiqQvgOY2iDfhdK8iuDpMnsLnE1dGn3Vfa28En3kqnzPHVkhaI1vcwQqMJR1LXsVINmi0xAkWU7JerafodeL//quAoj+IOl707ATwRWbkmzvc24FkBgDXpUsK8lK6yWipU24PYiKK/28ejoFmV+2qRNN1PZbZjanE0qrPH3kWDzs8+2oEd+uSHlA56lv4uu6vVk6JG0iLtPZd2bOa8xOwKeMIwqpFfDfT0r99/CMl4U27lzLojd7
 5/WpaWKM
 nPBBgca2+8WCh5/oB+QFTkloixAD4b502rPCcrQflvYKJMgesH/2xsVXVg5RwK/NqaT9sDZzjYp/sfIkL9b16N6BexGneqHlNcYcxjzi4EMl55Cm8MEVqw8MTiiav6Kw0TEICMBRgHNAfIHDeKjFPhTT/+Pw8JNOB3TEIEkYRxiZLbTLaZDh2zZlQgkX9Y5YSEjqS8CB4Apb8mSE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS filter range arguments are being validated in the DAMON sysfs
interface.  Some of those have minor time-of-check to time-of-use
(TOCTOU) bugs.  In future, other callers might have duplicated
validations with similar bugs.

Fix the bugs and further refactor the code to move the validation to the
core layer.  Also add kunit test cases for the validations.

Patches 1 and 2 fix the existing TOCTOU bugs.  Patches 3 and 4 adds the
validation in the core layer.  Patch 5 drops the replicated validation
in DAMON sysfs interface.  Patch 6 further cleanup the code.  Patches 7
and 8 extends kunit tests to test the validation.

SJ Park (8):
  mm/damon/sysfs-schemes: read sysfs_filter->addr_range only once
  mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once
  mm/damon/core: return an error from damos_commit_filter_arg()
  mm/damon/core: disallow max < min damos filter range arguments commit
  mm/damon/sysfs-schemes: drop centralized filter range arg validations
  mm/damon/sysfs-schemes: use switch-case in add_scheme_filters()
  mm/damon/core-kunit: extend damos_commit_filter_for() for wrong input
  mm/damon/core-kunit: test invalid damos filter commits

 mm/damon/core.c             | 24 ++++++++++++++++-------
 mm/damon/sysfs-schemes.c    | 32 +++++++++++++------------------
 mm/damon/tests/core-kunit.h | 38 ++++++++++++++++++++++++++++---------
 3 files changed, 59 insertions(+), 35 deletions(-)


base-commit: ec1b9fab95fbfd9c5dbdfb841d91929c2cb63518
-- 
2.47.3

