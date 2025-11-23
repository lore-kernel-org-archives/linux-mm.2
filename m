Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 804FCCFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 18:43:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DEE86B0088; Sun, 23 Nov 2025 13:43:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02BDB6B0030; Sun, 23 Nov 2025 13:43:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D24036B0030; Sun, 23 Nov 2025 13:43:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B5ECD6B0030
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 13:43:48 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 72C0D140175
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:48 +0000 (UTC)
X-FDA: 84142745736.30.EF04E4B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id F07F920003
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BjvbOznx;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763923427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oG+PIeFXbXMnnPcS4Aq15P3+6DAolJ+VdtdnRIKIFHs=;
	b=G8V/KkbWzmstZ3gFXQBXLC+OJKlu95vCghxfsluzH35Mp/UeFPqKdZrhlBZb1U4NGdsRbs
	wq/3eab+L4pBvtcoFnqVkD0w/NsEbaZ3VZQxe4FaQY55/VKXr4Rww6Q6EzLxfDQDlM9F44
	aJkQvKhmx+L+q1UQ56d6OdwNcEXoq3s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BjvbOznx;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763923427; a=rsa-sha256;
	cv=none;
	b=zH4QZVJMhaquNyOPEAfW3Fk5aUsuq1fT8hQQklQDeXYfQk92bYYUh1Euy7L3f1w5oMmFP3
	I2KKBQ4NCDJbKrMRipB3siX5DYuDa2O/qr0rXhw4QoAdGcr44lByuW5HHg2vp/uXIkMmsS
	opWTKimhT45b3SgBG3e6ApMPkcF3dRE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1652044301
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23A2C19422;
	Sun, 23 Nov 2025 18:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763923425;
	bh=kDwIvFb8VodbxVEv7dJbhD0yz/eOfjwBbqy33WSlBfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BjvbOznxo38hdVc7pIPFkgfrNu+WIMZYz0mAohaEy2nWJ54GQBMuSPhyqfb2lxsex
	 lkg73PzpS8fc0nixCljxRLfc9hx3clm7eM6zTewVD9dQcDjqO0ACcoYZdcwwLJdlhI
	 RCfMqWZ4BehSZ2m7P6kZPdSaSAp3n5NBu2HfqFwmTJDfOyzAZNH2FmZTWHHZixq4YW
	 iNKkFu9BkypGWj5kYxFtkIFo1mp0yGF2Mng7CylilvjlpYnVM7FoW5yL1vvsOGKnu0
	 FjAoJPbFuA7fcCJPwT7OOpKlOxl7xfbFs3Cws77mIDVTRQ2d+nwlkKOmQegXW85Tk6
	 VMqGJd3WTjEVQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 05/12] Docs/ABI/damon: update for nr_snapshots damos stat
Date: Sun, 23 Nov 2025 10:43:19 -0800
Message-ID: <20251123184329.85287-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251123184329.85287-1-sj@kernel.org>
References: <20251123184329.85287-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F07F920003
X-Stat-Signature: as387kye3yn9nkxdz3jiksuo718ghegx
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763923426-809788
X-HE-Meta: U2FsdGVkX1+Ef2/jArpM75U4lERA02m0Nrg+K0+k/+wJskA5ry3dbKFWKK7e6cZ06/t46NzJO7P2fNgF0HAFFDg2WGR6xJfqa/W3nnXN59Jb/F0K26MiA6V8THb+6rA4fHFr8AuU+4DvrtJ2XyVUaH/hi5LFyrLqZL2BLnZ5ZvhI1NJgNjWwDTymmITIQ0IkOQvbnlkzpWVbft2RHkLGY+cGXgc3hDDeVN3G32bPXzimDfyhKwUycoRyvZR+KM6dInaONZn3GtkdVISUVE5k6L8W7qakTRoOmw8qhCrQQFaS8entwhqfNYLDoHrRLJAfS80pXjuy/af/B4aAEgGJUV/93qYny6KaBFnI2Dsl4o6ZBTKtKozmvXGZfgXZTzygVXYe2qY2BcWHA2H3IyCiW4N77snZmAB94/KY7urk+UAeU+iMK6azGCjbf2sIdWGgMNcx+CYmnrK8uFm/91ipYqwfCCKpmB7INTcazxRPhHzYQgIyWaucP2DBsx6KS5APcBcuP81nA1mWvnJ+6pqLpTDyIAOLBKzYym+DCKMsSo6LQjccJoPw/VQT0BZQfcsqoMcvKxtqOAOJzpfzsWdLx4ZSMQ3GjpBtS5zU7hsz0J6m8UzAY4gNCRctwjknLG7AQGs0dwHzakzz2GKwYrPKBURTGEiBGPtugjvfuRr/dPKb275Q+s4seEeKmwmkCVxQOXyznOt0zpwenco/ZymEHwxhvG986i8AIdVUqroIfIIOJmEH8FODtVoP482aucxiGi+5otAcmEN2B23n3dwjCj16TyDR2/tENFBkza3HGVO4BJWhldRFxO9alokqeUXw3XaV79AoEqTDEfcz9msMikUUalrcVj/R1T5+pfhQDQ1TFprkjmbd4yYttBzBwqV4/tR5AtAhKvxr/tWe8aS+EP87B8HVBqdRAPyysogqz+PLdY1AuCz9rzH6i+FYTg4qYE17K+2aYnLr9NkiOyJ
 317H2tzN
 p8vUfa2Nnpcs3orB/jlxhgwH7g0FzeuUs/07H+SSRuShP9UwIwJjQh/Bzy8NRMGk+S8mT2+ZufCB04yw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the newly added damos stat, nr_snapshots.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 4fb8b7a6d625..8ec469eb4471 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -516,6 +516,12 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Reading this file returns the number of the exceed events of
 		the scheme's quotas.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/nr_snapshots
+Date:		Nov 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Reading this file returns the total number of DAMON snapshots
+		that the scheme has tried to be applied.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/total_bytes
 Date:		Jul 2023
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

