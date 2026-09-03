Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE235C61DD6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 03:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82DFF6B008A; Wed,  2 Sep 2026 23:14:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E0BF6B008C; Wed,  2 Sep 2026 23:14:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F4CF6B0092; Wed,  2 Sep 2026 23:14:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 44CAF6B008A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:14:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A993AC0410
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:14:07 +0000 (UTC)
X-FDA: 85170982134.22.93923CA
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id D6D7B20007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:14:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IhfVl18F;
	spf=pass (imf03.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788405245;
	b=g8sXW8MiieUi6Bd78Nk7NKVG+gcd/EcHZsM2hkgq3wqmlLi6P5quBhOrHW/nBTDhqpCboS
	zp2zk9dBhZ2t+8MEikdUC/iG6dXjOd/ViCsR7C/gHzBQYlsS1ifYCM4HWJGOv7sUevl0C0
	2uzO9A1gMMiyRHQPR2/n0MCcCNwTxBc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IhfVl18F;
	spf=pass (imf03.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788405245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vESU/1COBgvnCI0rsLCZoKytSIIaf3V11jedMnJg7JU=;
	b=hU1lBBLhzdvZq3G4tIgTZ5A0RFTZpU1TuGXHEskg3gIIFSHkq4tf7mUg6rBLtLmgCJ9Ydz
	5SKHP4yH0bJCQriha9e9YPHAsUZFs5wXsf4tzvj0HDbdbqTLRX6gtCZY6qlT3jaFRPyi+M
	6REg5astaC+IAFOpmBhtdWJfUFYDjV8=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2d53197d8b5so16997355ad.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 20:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788405245; x=1789010045; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vESU/1COBgvnCI0rsLCZoKytSIIaf3V11jedMnJg7JU=;
        b=IhfVl18Fmem9oxPI6gJlagJPsG1e1dr0D8tfGZCWt5fJ5yxpuYwk9DcV9nhs8kmaKy
         iWTkAWEIaa2wrnhJBtmFw9XiPFLP0kr0QqaF28qIvAJGK8D8QSilhh95tHc2ra6HbyR1
         NjwM//5YR6O3fvdDCLZCH0ufxyn4IsrjEQYpZmhdu8wpA3eXNngRpaE8Ry39aCWfVYZL
         OsF49ISG4CPKAGsd49yw1EJEKBu/REPT8tjZgdaJMYsgy7hb11Kw2c2bX9gGJkwxgaJ9
         bLG48YB7pPrXWlHUNmxy30K5pvUh+PaZ0f+/aTtUvg5bOL/fL46GWXm8KbDdDtHG0n0O
         sXhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788405245; x=1789010045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vESU/1COBgvnCI0rsLCZoKytSIIaf3V11jedMnJg7JU=;
        b=AAFYH98CuktumUMWcqK8WgouLjt1Ddr5sjV4WolvnO3OTgDCOBLl4G6blYvsGTb6gN
         SVCkWLnA4dQGUEz1Ri9fbpwQfJfInQqctu8T+242Bf0Hj6qRMJbqeKV1ScANtIwB7RDZ
         WSpjS5cjzeGSOCBx1ceJ3dWZTpm2K+nr3qJrRy54KA74XwZMYIoGpgTyb4RydUbElLFp
         2hVFt7gO0olyRqv2bXe4Dnx5mR66eW8kGGlBLbccq09CLnEWA2ePTnaXGomjzIRrsojQ
         HtSmczQ2HHEFyyShwYgNMfwVEYMVwsyhoWyKk4p/bcFgeI7vF6Qs8Xj+lnAMBCCDAzFp
         /Smw==
X-Forwarded-Encrypted: i=1; AKwUvBygwOwhcWgJQkrk2dHF7Nfd9jLGw7TAZXd67P6K0H0m07y+33PpSWnllyk7L/gQ5Ch3p3F90JXUBg==@kvack.org
X-Gm-Message-State: AFuF++l8c9Aa9RMWBhUtXMFSgEku3NIcKIh+R0t6gp1tdqaPbHxVKCTy
	KK9JsMNiJlcS1YTtG4ArAVAZqFzb0YYsph1bETSOT7AxrwX5QaywpylG
X-Gm-Gg: AYBFou3iqRMKLphJbCuXKD+jNzwOdFUdorhgGFk+rl5eQLPai23w87yEvEOjjN8soDJ
	AcA22hTZA+eluSsT4fbyNETn4gs0qTrOT1fCRiivBlZudi5IlY+gHJvGbjAoE/m/XcFdm6Owhhu
	3PgsY2Bf7WgUlENwIcJustMoTC0J+rhewklRigjCNGH0f2LLcG6glKSWCnluB1r/N0nBDuUhYJX
	fVe/DDCNQ/cNW/3bnzqBf//N5wEW2fOpQhMsXfYkXK+qntHCE3r2K8dLsTmFRoLX6RNFm1v3ZKS
	ouJfNG5Y1ULLlbM+docDJJoTddKY4XoSPkh56vfyPVAQmF2u4JoyK6e4V89agWiSnBhvApAlIxI
	Fxty6Z4XCc8hksfwesAhBUDFibkzyZO+NHdESvdI8x1ciiLB2IVASOub+AjXqq51bHUvbpyZKP/
	a84mo4cTUNYMZmWUictnQ/cyBy3l5V7e+WvGl1czo8ufJy+7NcIkKDIutLXKbRALeR6V/v4KEY9
	ii4HbtjhA3juBKkt+ETTl+e+m8j
X-Received: by 2002:a17:903:1aab:b0:2da:f1b1:56c4 with SMTP id d9443c01a7336-2daf1b16445mr104380145ad.3.1788405244535;
        Wed, 02 Sep 2026 20:14:04 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dafe0e0d5bsm2824825ad.12.2026.09.02.20.13.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 02 Sep 2026 20:14:04 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/4] mm/damon: fix misc bugs in kunit, quota goals and sysfs refresh_ms
Date: Thu,  3 Sep 2026 11:13:28 +0800
Message-ID: <20260903031345.82679-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902002725.108635-1-sj@kernel.org>
References: <20260902002725.108635-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D6D7B20007
X-Stat-Signature: rym4mm93gnompkia9wah9mkpojoymmq5
X-Rspam-User: 
X-HE-Tag: 1788405245-936736
X-HE-Meta: U2FsdGVkX1/udJmOdMiX2q+0uIL5+F8zk6so8cyrldyecUs5sBPfzfJoqqNvr7sZv5Pje1NxVlDj2CtcDgPP0gHgqjq32H+XL5O0sUsQi0tONFurnroDJLehm6HAHphMqIwkD0w1aftzSmJG4wEsTmGrcjY9aEeahFYFgGN163xpc9/HfVepzUhYvBALzGz8zldYev4LndvR47vLi39aLXk33i72S9P7MLxj8CrSKrJ1hrfSfJaF+9x4AeX1cLpKWvQaWzlpGN+ePjiR+QADeOM0h5BekDM/S8idtYaP1z30qI/OMpZ6D3wHSyM8j+B9dDWrMFov1fjxMvvHJfC1/CLoVDdYYPFQTVEIdy8SOhLIMoSbu6tRKMdenPqG12iosu6d/Ah/9m0ty10h9zz9V07i78oFVC3r459Sw8v8DYaHNoDUqc9rMBFQiXkpDi3+JV4UF4qXJpxPqff+/V4BWVAhVoLU5IE6CW+rXzmFoUqVtoR+X+ldNbjEq1G1qfgm4FHjJXgyUTO1qdjXdEFUsJTjbX/K73XX7glr51LfLqPmw+fWNh0X555hodJdjBvsjcO8K2WZJdnUjroeR/Ug6bvoxbTOH+HbtE0gGyXE/qAy3Jv506FYbZwbZcavPfUkeEY/0N8/Snc4wWLEu3eSFl4qWr0b++jHoOtpD9Y3nH7QgSDlrG3SupLHLqP7jsdQTy++AGxpfLqhtGjLu94fTYWMN2aEtLjF0J7XvdX+nd6o4Lhm/ZgZOar88nk2vGZNSHTZMbGXXyCGjYtOq9zMal2o+SDSS+iZWIQmPrEoVL5ABQQv45Eswtmxk1Wj05hTgtmSR7pqS7mGrtprw6nklnEM1fmAlRFMbVzIx7qMfjvXp8H/R13aYmiM/dyd9mVqT0W6IwWTyoUW6SfwvamfJUurkZnL3TGeCK3EtGqXF5aJn2G+VyFKIuTVaOtF91JXPdTFohlLNu9in+XQMjA
 XfTUItDR
 S7EYjq5Faz3IQJ3e5dSjtS+w18n+VzI3A2uF+6nEkqPfE7t5nihS1ZZJKs6UMSxzDw5UuDpvzChr6a5tPYWthn0FjsI229/pDj+PYYsVjPgpy0mVqYX7of4b7ptdx+4bPq+mU2DEGOnQkwQTOc+pFoFDzJm2FTvTLD54rwETZwvslHuQxDedG1XX4205zUAOINOiLkbZqeJFttCdF52ToIDSpAK1XUQhdXeXLvaY6smpyVsX2eVGZAg3eOXBPuAtPsU+GyBwPIvbt7bd1tglYxuEi52NhxAyDXDBq63nLFaH0OhdZ+ANUlDW3e3uzBKP1EVQm7kO/MiLzHJKPIRrc4JH9jmoNjoq9P2eQK6WgKV2rVMjxqgdS7eDsQYRwwWyeGzODUwXMb4cVKFlBXjig43DCA6iQCHrTS44slH4ythUvSV7uxGuP4bb5ynSAW0mQN3N5UVvu/rAqAMbwB/sRsG0ErdTjI3d9L1T0+t6/xjxrtxp0LJ62c5lFWSWwAK25xEI7QIMZTYhDqx1SFSzyDd/G4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

> Patch 1 fixes the DAMOS quota goals commit unit test to cover a
> mistakenly uncovered case.  Patches 2 and 3 fix the bugs in DAMOS PSI
> goal initialization and eligible_mem_bp online commit, respectively.
> Patch 4 fixes the bug in DAMON sysfs refresh_ms file handling.

I reviewed and tested the integrated four-patch series in mm-new:

  a20e38846efb..72dc8fdaae62

The integrated commits had stable patch-ids matching the posted patches.
DAMON KUnit passed 42/42 tests.  I also ran test-only eligible_mem_bp nid and
two-kdamond refresh-isolation regression cases; they passed 42/42 and 43/43
tests, respectively.  Both test-only changes were then removed and the
worktree returned clean at the unchanged series tip.

These were functional UML KUnit tests.  The fixes look good to me.

For the series:

Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Tested-by: Lian Wang <lianux.mm@gmail.com>

Thanks,
Lian

