Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F5C2C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 11:33:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 939636B008A; Wed, 22 Jul 2026 07:33:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C3496B008C; Wed, 22 Jul 2026 07:33:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D026B0092; Wed, 22 Jul 2026 07:33:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D47C6B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:33:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF11EC0162
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:33:53 +0000 (UTC)
X-FDA: 85016203146.03.B73820A
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1FDBE40009
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:33:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bnRUuMB5;
	spf=pass (imf01.hostedemail.com: domain of hank20010209@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=hank20010209@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784720032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lxBwVWRrpNduEO0ca1Z4JijkhZ7cZaOkNn5k5o4dK5Y=;
	b=SaUvinDj6OTk01bJh5pqV+ZryKW7hAg39hKRBsC23D0MtfZaVWkHUOWtA6PkQ63DIAMu7x
	YG9w3hYE2L/EOG/YScmftbirGKeGJcK6QOSgFJzK/QF8RxzMQ8xWGXLhbM/DMRLs43zmcO
	1ZDb9voiqV/d1B3hyj3Pd3dNY0Q4oEg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784720032;
	b=tA6WxI5iWMwWyoTgFyFv2rJz6yy96si3rIb5vUbBxiagxBLAOM03I9VvQITPZ+N373Clpy
	sCXg7ShXXoBdoZpG5PJTS0bCyRhtcsQk9nFoYU6GkIeetLLjmMaFJipAztj7dmobj/MSj9
	BstJnXhj2wo9W5ZjGt/eNe1AFeW2zjU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bnRUuMB5;
	spf=pass (imf01.hostedemail.com: domain of hank20010209@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=hank20010209@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ccdb73f0e1so85166645ad.3
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784720031; x=1785324831; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lxBwVWRrpNduEO0ca1Z4JijkhZ7cZaOkNn5k5o4dK5Y=;
        b=bnRUuMB5ncNC8l8NFq+Aa76m+pIKUkWQJ7a6JrzGG/oO8dhLvEc8V3aAo3Sam+Isp7
         waxQjQUQ9Eo1RNkXduCB6WCtkpcRAzDEGrN2Wl/YRWvg1xRgq0T6DymefEi+MCwUqME7
         WcrgMydg48wB2lKPFWgLA1fI+v3Jhs5Vf09z0N69e03iXgmD6l7+KDonSY9uiGcbCvHt
         hmH0/waklakKGi1sA2amhg90VI70LR1pBcrefTqh/JUyq2BGHn5yZoQeCFUsDiq+AcPp
         Oih5pm9pBvAvsmm24Eg2sa0qKIvBdTvCjeO7h2SuEb30B1hzG24Zahc3ztOtGXYuMUXH
         dhuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784720031; x=1785324831;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lxBwVWRrpNduEO0ca1Z4JijkhZ7cZaOkNn5k5o4dK5Y=;
        b=LhMwDR696FhOdfNNhCFZWkS6XVKJgEt0KFXDIXRVr3o01AZieSWixnO4gM8Dtyy1n6
         MURSQllKQh4YksOcbm8Bxg4HlvRK7PVrWbTS/mwMvPrFP4ElDrFe20CH2AYXU97qTrdT
         2X/Rh5aIXOi/XS+GOajJWGyghMxg5CVAkglaGfBvNAFPqGfMnCnSuI3ubk6qUz6/BHUr
         u6yINpwWEN21esXyf3hYZwbYmYUujkGsRFe4RwMjncPkVwrAbF57hbc41Un1dozqfKgH
         MkzV3ykHOJFIaFKcQ0A5mQT34kwTKXjdgljVe8r+G++VZiik0SbNhKMfAMN+oEZE8iFg
         ZG5A==
X-Forwarded-Encrypted: i=1; AHgh+Rr0qyQpjN7uqaBCeieckNcqG+YEuRI07FzTuzuOVyk5XbzJb5QZ6Itleh5saN6OR9qLU4c/RO1EFA==@kvack.org
X-Gm-Message-State: AOJu0YybMGqu6dbplBWdeecY7t7VwQKKr9yyp2Ln6nU8KoJxgc2ZDFJF
	Z3LLid8Pru1UfvWC5L7vKsjDs2etTBdgHeYj1/Qj9yidCm0vI56YIkGF
X-Gm-Gg: AR+sD10SjXF2r2aQsG0Pt9AHGkC2yqHKy4fHz4+a2KiEUWNMhCSO7o5mRpQ/p+L8gK+
	igDH6u8hpPBRq+5i9Exm5iAU87ew+pQm1jJbbq7OstlUPohvWHu5ZinJIbDU1MIZEUGPS2L0jT9
	DPRCZS8KUb3kMCX5OVcjaA9P4OzVI0mr5wA+f0/AZBsTorO/c+IipbX/ZROxTIAReR8gGzL7k/3
	EhOi61V5ee5wv+PXVutMHElc31i0G8NoqEHqJV0BhJGbx4brsXu7BVQE8KuL/uHj7Pae82oMW3Q
	q9HdQlLGb+TkFWAfpdGoGpINJ39rKsdcshnHAhGPI0dMr9UKrfYmYPYzlQNyjHOiN4+Mdyq/LTG
	cvbemT9w3pwZ/xg+nL7piQL6Jl4p0happOijMjYrwMpV4xhkdKAg0fdhNuMGsZIXiR3Y/72RUU0
	4qBELVfkkiI/aq2513Bg==
X-Received: by 2002:a05:6a21:7008:b0:3bf:a0e5:999f with SMTP id adf61e73a8af0-3c3ad7a439fmr25423558637.22.1784720030853;
        Wed, 22 Jul 2026 04:33:50 -0700 (PDT)
Received: from apt.tailc82bd0.ts.net ([140.123.97.23])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbb8f1c376esm980979a12.29.2026.07.22.04.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 04:33:50 -0700 (PDT)
From: Cheng-Han Wu <hank20010209@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	Cheng-Han Wu <hank20010209@gmail.com>
Subject: [PATCH 0/2] mm/damon/core: remove unused helper functions
Date: Wed, 22 Jul 2026 19:33:36 +0800
Message-ID: <20260722113338.302603-1-hank20010209@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1FDBE40009
X-Stat-Signature: icy9xncpqunanjdcxzonbfp4zz87dtqz
X-HE-Tag: 1784720031-421953
X-HE-Meta: U2FsdGVkX1+PbZ0lI81LdAUc6WgjSeCUb2xc9lg3H2VhSfExkxmGEPBHuZMAynnuHGbuIE92j8RE4SDlEdHZFZA9b/i0M+30qLP23VI2frVjAItZo4WbknVU+sOnIabTgh6swqyH/lGYwFwhowpMtCbbmb2xSSNEf0Sd+fNx1f6eHrEJB7LF7rHhWDjGork6NCkdZCfOSP4jBdOvFKHwqdyZr4DACj+9I4ed3ibF8KNvebykL3R7Px5YUbe5ViPRIx52nQpyWoozd4RSFu1KRkoVmBEu+Eqf89GpDvM753Ewy4uEi//ZQG0ABIWGcNJfJY74qA9YpJM6Z20Pd57pQ0HnACbEb4XqdTnsGBf9oiWe+rdSaHZr8oo+Ymm4lwpDQXT5Uvixj97D5t8xtmfRPw2vlmYbr3/9Vg8xlVNypjLk8cBegbmO1xwoOTOhQozJHFl2RwOQO6d0ockavdwpyK2xjIiXxQMYACteu+/Y8TbRzg7M1HIUuDIZ9YgJi8BS4ij9ZKm+RvctGCBd9EmuYgifIM80RpLNBQyq1uSokwvA84rzMjVUB/jdRYwRoxJFzoiV1Te9oIWPphoC55hCbSzwJZ+wLuyEks/X0rmahYU5o9wJNCxCmCFORu6ML5XgShoTKlL+SMMbynf7SQ/uTZNPa+I+QeycZ0B0ZJB9VVr0kN8Oiggk7q+wY/Ssafg9MxjHaB5d7AzdWUhIA0z/FNG/wtgP5nm+e9VlXiV9yuHG7uwPSw9OARJ/IR1GRbvJ7aRadbThKCCTt5592JS9QDhQPOiXJ/6GF9GedkZNNizgp6Z9v7dCyWFeG//h7i5irtPSdHzsO+7YTFhzUHFkizduJCtncQ994bvQshvZUWYAG3j1Wix8fhgOf3LMX0sk2bTmfGCW3moaXSnKRf1Rwr+vagd8fwq8dqEEkFmgquPy+FhXBNdVHJje8DlJ8le9VjZvR9hBTmx9Ao6X3jT
 B2hQXNR4
 kqC148aIMavjXU6ImrqTKFbJXjoG+qDPPGI9nrmKsg6sFmCrHGRYU/WdfSvfphEF+tcZCuP749ytll5+O1hZx9zkYIvVPdXm10kIZS7JcWlqvFA62ItVoKPPZcPF/gbetQfpHhjzgNMjr2eei8iYAW8Tnj6cUVV06MuLDkZx9EzRoZSV1hW9RolwRDTyaY14+mYdWcqn1e58ucLYd8s8GzlllCJpwahgw3HmdfbMH2AXlFFqgad1xz2QEzjc0WvOzFe72+Hy5LJjBTn8iUvU2hmLy79wnJx61NfXo/g0m+hkYVmyntQjyDtjLEOS1P/JpyGUaagU4UdYW2vmJQfkZqu7lxSgvCcd9Hw8uNDU/5WodV2oznH/FE8knDYgGiEgvtzcY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both damon_targets_empty() and damon_nr_running_ctxs() have had no
in-tree users since commit 5ec4333b1967 ("mm/damon: remove DAMON
debugfs interface") removed their remaining callers.

Remove the unused declarations and definitions.

Tested with:
  make O=../linux-build-mm W=1 mm/damon

Cheng-Han Wu (2):
  mm/damon/core: remove unused damon_targets_empty()
  mm/damon/core: remove unused damon_nr_running_ctxs()

 include/linux/damon.h |  2 --
 mm/damon/core.c       | 19 -------------------
 2 files changed, 21 deletions(-)


base-commit: 5e0603ba185af6754422ad28b646798686b6caf6
-- 
2.52.0


