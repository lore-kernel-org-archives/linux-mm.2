Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02F4CCCD1AB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1FA68E001A; Wed, 22 Oct 2025 21:25:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981FB8E0012; Wed, 22 Oct 2025 21:25:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BEB78E001A; Wed, 22 Oct 2025 21:25:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 75DC28E0012
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:25:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D9E71298EA
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:25:46 +0000 (UTC)
X-FDA: 84027637092.28.16F74C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9188D140007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:25:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XViU0NHr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761182744; a=rsa-sha256;
	cv=none;
	b=U59VjulHPRRpdVcfOkYieLtJAudnjnrs2gKKeI89k3ed5eWZspfqJKeYK74vWxjA0nni/f
	Wv3ZJptOAiu7zN0RgKrcjrEWY8W2RopVl3RF8RDJqKO+VGp0NuJP3kKtI4sKtaha/W0N1n
	b/PturaRkPawIeZQrdUQp09huLmGbsA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XViU0NHr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761182744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R93wTuvZkP02f+1vLf7zNGg1h2fKEX74m+Z4+PMTfQ0=;
	b=tjbYoBHidCO79A1oJG8/k3EuJdEyY6ln5AmLw2Jfs4hNkhQgrp4Tr3GTrrGkc4Zj3lm2z0
	YnW2lxpILIMiGckmAUubNBK9KCZNMHtgCdOovXgDxJeGywiyi7/J3YWXc+0aHqmVCBjWCP
	tFsARVF2MqYbQqmYYiiwbBUN3p8bCOc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B98924A8DF;
	Thu, 23 Oct 2025 01:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A72EC4CEFF;
	Thu, 23 Oct 2025 01:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761182743;
	bh=K6zRg1CjAedGEmFhj0IW60penVdcjigiHWIj6JeYghw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XViU0NHrDt1Steby8mcv0Nh3QRh9omfLt4bf6GvlSEMKV5UcVHBT2foqct9/AcxvT
	 Ck6F1pBnNSFDTpzjJ6YINcSmcKkvEMe4e43/HzQjx0DwQC19vmHy+fAy9g2wDOWxck
	 nVDrdD38tmZC6VAOzMBbsKnyeDpr5Xk8D9dbTD2UOAjREwax8jKfzOYfviPS9rwGTi
	 us3tYf9kvHaw1VqFSDvkQVIWeD+l+Ns6+RMyN/RVUUPqKYDBNUyJKQK1bRu2RviOWl
	 sCoJPmKw8icGDTEJnk7cMD2/aimYoPIXOryOwYIjs1YaEJ/wuqoqdSQJaALNgu28i4
	 LP37n2Omj8F/Q==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Bijan Tabatabai <bijan311@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/9] Docs/ABI/damon: document obsolete_target sysfs file
Date: Wed, 22 Oct 2025 18:25:29 -0700
Message-ID: <20251023012535.69625-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251023012535.69625-1-sj@kernel.org>
References: <20251023012535.69625-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9188D140007
X-Stat-Signature: wxa74fnoex8sdtyzgnu4rinat7nws87p
X-HE-Tag: 1761182744-36539
X-HE-Meta: U2FsdGVkX1/2SEgviNB3IvFQuzlOY7uwVpjXluD9ycv34v6J0nvpO0gm57gXM20mlY81WAl88LQZU4qY6xu3u4rpkKRfKJHeX8IaHHbROSd/tXX0G/Wt0gKsRq73bP7BvsU0C8r0ai8cINy5cL6e6xpNn8vIgJqPB1YtCLwnthGGGNLoS4+tCzuTlNQgftYL6tDkie0h3P70Ge/jXclNY0x80nbk8tt7YN0PlM5Ku9U6LNIUqefHhFXjWi8UPT8f3Kjsv/HuvveTvTqPESi0xUDBoR4XHKU+eAlkiWWGt4Q3I+6dG5h/TqfJ8AYonNf0uVGAaQlVKW8YIflOAq8VXENE+eGcGEjLXxJjUXe+BAM2KKFDL/YZf6iXY9XBf+fVAKMVEmXpX0OijcC6PcH+o2520CGv5+tiV+TMhCfXW0lAuuIMixtkKzdUTIJ4p83/Srw/h0x5oDW/kg6XCdGc29BswMaPvVfvhZ62UN0ElcTelqQP6+bAfniFi0bjgWUBlQAkNO2Sq1707m3paKXZJa4Svs6ZXCQwxyoytYX/f31gSWywz6oHMI/Vu/hETIBmfsae87zLIQLIr4JlkVFlek/cXqJyBQFScNpYqDXjKImPoaQCdaBHblKJBJS1SrCmIYCnWepCYGBvInxq5dON34JDSUbCiqJtAw/0yOFL7nnV4uUkK/Oeafr254ytfsTmjnR09fVmA2cy4bSIvP4vHQ1Xsd6wGMVSm0akL1LtBjtL6D0Xl7GZwr4IO5x5uU79hOpSB+sJojD4Lg15XUOIHFYYn9TtIshpqe+dgz5RMcipFWCl0haQLDVfo0udTDamysMmls9LV6crfRWHRpJHodumJ5XYcv9H4UUwit1uFNlTzU0MvFoJmeaZAX9Bkd5WfeRW7fotHEQcwB/IU8AbCbC3JL0RxDrB7QorW2RL87P5PH6uxOwzykotheCzh5CpRb9EywJnnI1zLGWnAff
 eM7f2pjb
 D7VuRLIPNEB9r8nuN3/n/oStse9hI3dSdsSajiwhdx1HK11ztakTzfwCb4AnSnUzaO9aJ5qb9IO1WWCurH/W/OGFTcJX+BzinneUWLrrGXtfNyyuW0iL2qGYmNDifAuAYNVNJz0xlGcmaBIH7hEAdLG0rO/8jr5iNcudHQlnKvNTbrZTdvO3xa2KhMPFW4emZ5QwdWK5qapvXP9hm9NNhoswCwesMAR+OqmB5/D9YnRC6sRmb9BRUDjug88mLs7Sswwe1v4bggFtnMPRAP+HEm6nha+kM90A1JpOkfJfwQ9j4WZqp0ytVlp4moiWnx+J/EJsS9xE+ozA5GMKd+hyhqoFuug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the newly added obsolete_target DAMON
sysfs file.

Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Bijan Tabatabai <bijan311@gmail.com>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index dce6c2cda4e8..4fb8b7a6d625 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -164,6 +164,13 @@ Description:	Writing to and reading from this file sets and gets the pid of
 		the target process if the context is for virtual address spaces
 		monitoring, respectively.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/<T>/obsolete_target
+Date:		Oct 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		obsoleteness of the matching parameters commit destination
+		target.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/<T>/regions/nr_regions
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

