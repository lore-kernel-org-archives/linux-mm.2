Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60973C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 01:28:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 240296B0095; Wed, 16 Sep 2026 21:28:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F1E16B0096; Wed, 16 Sep 2026 21:28:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 131096B0098; Wed, 16 Sep 2026 21:28:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD5966B0095
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:28:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DCC441401DC
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:28:27 +0000 (UTC)
X-FDA: 85221519054.10.4267C1D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5C98080003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:28:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gCUbDUZj;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789608506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+h1LZVMHdLO/1F+KdKe54DtOJ0v+YLXQMJ2Sf1hTygE=;
	b=e/3jiPgE3E3QF4+qr1eLYFSfzPfC7DQDtucu80tM4TxkJ43PlEgA1WSOYhS80lgzlGn77m
	tmw56vu3A/1VWHvtYsdo05BKqTTLaNZiARQFPQiOB0o4ViV5bGgIQdcotZjktAWKKpJ3+2
	jJHVkjfxJehsMeP/jovSr8BKf+jXi88=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789608506;
	b=u0LUkQDSzSALP/clp9xMxZaiX2kfOZFy03n75lMPqYQNp/2lnn03VhtVxxf42DUfjJ38Vy
	mONuUoj617aZkFCKxl3IBk9x2wHlqmhQWQ3HWisZPA6E3o83pWTkW2BgGnpceulhbXGB5P
	mvpCwCl6nX7Cwt+GdXohq1dITlzt8PM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gCUbDUZj;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C319C601FD;
	Thu, 17 Sep 2026 01:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5681F000FF;
	Thu, 17 Sep 2026 01:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789608505;
	bh=+h1LZVMHdLO/1F+KdKe54DtOJ0v+YLXQMJ2Sf1hTygE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gCUbDUZjCtGJH+c6yWWdXTaAuGUZiYJkbZDXlpJ3Jm1fF4sb99EU9A4qrB/wBCB+Z
	 a9oVpj9j5mC9MEn3QMOfphCCyMOqFrK5o+Hos1yumguo1UyA/BsWOkzpEO1bajm9cG
	 zHso1QXWI186VFn8kE2pK2SuilB6E0sbnNmMRmwQxGOCMeNQEcUxVOWin6f0CTCl0R
	 du7sHe7o7grMmm3yy62cobSOsxIWQfWX1p+utgYkkSND0rLv5cN57Qlyy4Josl5UeF
	 /m1J8dxyN9S7CnNc2UyqH4RQ5vfUK/4lg2FWD+26XgrAUkx8IAxXzUo7HMecR9Ieb3
	 IlRezqgx1lWOA==
From: SJ Park <sj@kernel.org>
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/2] mm/damon/core: fix the size charged for a filter-trimmed region
Date: Wed, 16 Sep 2026 18:28:17 -0700
Message-ID: <20260917012818.101391-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917003553.2465523-1-donggeunyoo.kernel@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5C98080003
X-Stat-Signature: 1uabnksnpi63yczatmx3rnc3aoofq9er
X-Rspam-User: 
X-HE-Tag: 1789608506-901842
X-HE-Meta: U2FsdGVkX1+SrFb2DlwilMrVS7zIr6XWX1xizH89KzeKHpV4lj12tW6RzQh946iQQM2gwcsurHUY/iyJh08uXv/II0way8jfwfItnklIskMCaFwjOymwz4S780/UkxYT8AsHWHxsOo9C9LuD0QhoZQXTn6FbHxTTdRc1Et/AvLTAMc3S/GUfBuCXl+xlGRKFKA2PMVUUvNT0EGo/IKXcrOFSYCjzp/Tj+ohoFo5eK1wea3CnOchDeQKgEEx2lz2Bra6pkTaiRThX6fEMM3Ae4oUGSRXBBys8r8HQ2wJVlpDGRLaRjA2YbzO5KXIP/RW3bxIgX3d3usHVMmmyZnA5p7bmuEYUqXt9NRN6yzA6UZy0G87xoFRBZiQnkXQm9y88p0HtNM1EVF/h35XF7SDrgVdDCxtu7tqUiSFD+71BQrQ8fSa5HtPyzTaM2GjTQHbW4beGWparOX8aEq+GKUaVSlGHMiX8iN5zDJa07SpLKbYUgl7lt19rPODAJ5qBP94xNOCIWm+mwySI8DRxiMXL/ofFO/hiEkd0hBaoAu/24m55LTFL8MaykDABKJaAG+Bt9uFguOPZsmlYua4bTqI/h5+CUOmVdRJaiYjsSlnEXdgmYvuikF8gNbRr1eQ1vnALG3m0+pvpFq7uboloP/48JRpJZ7+9fuZMBTMR2eqLj1aggjqrF52Tx7LwOGLCCsJfEzsy7yDd8rV3sXNkpKzdIT0GbQJoR5x4rPfs9WL83hBNSKWH0OpswdVOACC+py5YCiM66rg97J+mKbkGF7+Zrv7hrhdXHoL98eY4PxBr0Fc26cLH+lSQgzLj/EnQnPa0DAq+wsWOT/ZX80qFic+b6lRKAGwXpXXZGT39wfqqPz1B1jc448rrdrWV8Z+CDXewbCx8S7OAvTOTXYjQQ3BuHnMkqFccd8bNbj7BdtpNO7nE0L6INYTuBinbfJk5GJLJFZ+Kx3Zy0vPmRYA5oLV
 Q5tY2CnS
 3JS91dn3hBdd2CgRaM3mv+SyfJpuufFx+K70IC/SDLaz9buloH9Ju7Dr1F0wH0V++UGn05FoaPTID+z1mAiK87XKflyA8xOIrZVV3byyA/Yg2XVzU2JFA8GRGvTam1lhjYDBPUvgXfkudtL5a/HWjKFRwCVNPRGdrbQmiaJoyRREYbp7p9yxzXc4MXI6/byMg/N7romKlyouOdALVq733YLsGg54cI5AS7tId9pwIYq49HITOWcZyEA9GWw9azsNjuR/kcJiwJ9aOF9ToRzzH84PW/miKFCWFG+xufZeflSKhxLhZtxtCbHWuXtRtTzDV2+sX6+dJ3hji7R45UureC63zwV7Ct4Ce0Pp/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Donggeun,

On Thu, 17 Sep 2026 09:35:51 +0900 Donggeun Yoo <donggeunyoo.kernel@gmail.com> wrote:

> An address range DAMOS filter that partially overlaps a monitoring region
> splits it, so the scheme action reaches only one side of the boundary.
> damos_apply_scheme() reads the region size before that split and never
> re-reads it, so the quota charge and schemes/<S>/stats/sz_tried account for
> the whole original region.
> 
> Patch 1 re-reads the size after the core filters have run.  Patch 2 adds
> KUnit coverage for what the function charges and reports, for the trimmed
> cases and for the cases that must not change.

This series is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
ping me or directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

