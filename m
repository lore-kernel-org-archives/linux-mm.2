Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D352C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41F486B0096; Fri, 18 Sep 2026 09:35:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CF306B0098; Fri, 18 Sep 2026 09:35:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1416B0099; Fri, 18 Sep 2026 09:35:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C62E6B0096
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:35:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A04A5140554
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:35:23 +0000 (UTC)
X-FDA: 85226979726.01.9AD936A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0B9C510000B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:35:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NFs+4SzP;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789738522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cyQRiAE1NzNRzDvuosLUWEsOKuA4c97+gPKm3HyuGhE=;
	b=7OLUkOAAX3tjMvtx7tmwdCtunJib6gJetHcSW4as9Th+vIfGf1FqC3Qu5P6uTml8UH4BfS
	4RYjqpugtiOVJyqdM86gNnhy4idA4AkhBLojrGq3KiyVF/bbASFx8FBlcmQThIbvCLeJ4w
	SGWVjlrZlGWxpWxuCBJWEJgIf9GkP4Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NFs+4SzP;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789738522;
	b=w/ekas5xIVJwo26LgyWaTLhfq03kPlPWMZahduzjzF3j5ueHnRrpVWoOtAsXHkKbFtLC0u
	VigjSMeZLdieB9aR23Be7sz/LNgoqu9hxJcyavELc+7xYicK6X6FOAt+9VDcz7LYKEOL8d
	FuL9X0whGi+3I79ctnatYdcQVkx05gc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 61CCA43AC4;
	Fri, 18 Sep 2026 13:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B341F000FF;
	Fri, 18 Sep 2026 13:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789738520;
	bh=cyQRiAE1NzNRzDvuosLUWEsOKuA4c97+gPKm3HyuGhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NFs+4SzP3Zxzh27IEibLV4nA2NjPaNTex8Yv8msHbXsxjYb2ro5LCgb044dh6KF5J
	 fRNsvQ0aBnxw9wxa72hLn2q4D7ZJB+BSIHe9lkLWHLccvNPBURe+ubn8ubCV+ITjov
	 7uHHiFF8FY+11JgkNAMY7+S9O3hdBLtLU7Y33aLoq30RB/5NRa6jl69Ug+o+D62sCn
	 3WZaGpcQEvAL3eSs1dHWmBT7a1AotKPKBtB9RsUXjXZgLd0LX1E3HtFEIjMG6njuB9
	 xldpItAz5jLOalBJjPcIjzyh8I9vcWXBT0fjx/OsfndFOwOFP+D2ocCHiy5EBJOkIM
	 GsBhwVE10dGaQ==
From: SJ Park <sj@kernel.org>
To: Karthikeyan KS <karthiproffesional@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon: document that a zero sample_interval is accepted
Date: Fri, 18 Sep 2026 06:35:12 -0700
Message-ID: <20260918133513.26828-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918131301.75879-1-karthiproffesional@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: pudfenjuux58tyuuwjzeuionwkqqcwpz
X-Rspamd-Queue-Id: 0B9C510000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1789738521-632813
X-HE-Meta: U2FsdGVkX19BgkQvU5X8nSYskKCNqiNsWvv4FwgQOO3POdaoiLKubulfyeJTwdUseBo0aBg/9Hb7rs3/DS0NfSBQkl2LDXtLVz7JkeZ2eeEGRz9LJWduRgGMoL/Dg/ZDwaGrdUA9/6+LoSObmeoVFs/Sq9WiNRcTP2LC8SEgrOG64vLbvrvL/C+iiMSenQlcC3aOyJBcBM2f6b82rLiwUQN9LD8R+UCMUEObHliFDVMWBhEjyo9G+BQwVD5gZBYZMSdmFonj7FHbjshXZNKnJVKslZndAFcgSGoQs97DLXUuKBbIKzfIhpbCJD0W0t62V91M5sraBFfl+mnSSWVIDy/LFCK58JQ4XLLVsLHFRD+SV8Vcn6PNHugLyl9K8n/TXlrplA/PXkHvpMCYSdRRGKTo4TSYMOaRc/v3TE41qslyl11Tlt/KukxmOUY2YxqbKmD4Oc7mFoAIkzMzefY42izSPbuuRhPyUEeFw2/MHm1HRavz67pVMZgyIEkNyqKyo0QeFthxJyaJD9MYHdSaKVqo+DzyRdKZnx7CZKx2HDc/qd02KAFLZ39Cyd14ZLyWXZiC1L//FYncJA7bI8w3eLvQnxuWf2SUaqxhymRQWkHlHCaV/iRYyna70JUjfvGsmzDMPsXptMsxkQMt4DUQKBsEl5BAabGFDeOHCFe7/ma9jTnpEv/z6Uus4Wjv7tYP9tQ6EITPNZkDE5z0niOWqHLuO1skplGDY+bYVTzJPR5kS2vbWUOYx47gZ9M8lJaEMokOsp8adW0A1ZbeR1K5DJHy/Y7C28PRrfuJp1Dy8/ZaHO6Bgc2poyn3r3pFiKmfmj/nuIi5LyTsGqb01MVC3Mz51UGPDG1xrXQZoFIOTqWC9tXJxyOzTkOiQ6AxaJHDlVyAYcunIFstl7UuDoXjPCezm4vEsJ5qnLEA4bc/f0fDU4fX7nbpmKVGv5cJKMRV6turXUPASb9knD3C7/i
 7p1krkBf
 9erZhARlKfwG3uNzIlVC8G4HIog55yP0JW+QlBX80N08GLe7t08/b+h417s9QrR7Xj100PBFuFJc5E/866d1RoDqaoV7EgybyJO1GfteCMx2mvu6tHWbLQ7dopbptRWlXeSJ6pZR3BjF+fOG10KRlSNtCxb2J6v+lAGDoKLEtQWHUc/PrgreqbaQGhV3mNJe2DiccxDA/Zg3vHiDEzpPMQCrS6oqSX/lktsz5y8ESasNue2/ddTXc+qmxKNYqxQnDwoawceDAshF72CpjJXp1vMWGveTVOdWuiYwGQqzhHhsSeELdinR/VKlYrrqbboB872AeUOsktAIIRiIWKWfEcFugRSzlZ+v5NuxOg7A099ueKEv/VPje5Qb3+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Karthikeyan,


From the next time, please don't post a new version of a patch as a reply to
the thread.  Post it as a new thread instead.  Also please add a links to the
previous revisions in the changelog [1].

On Fri, 18 Sep 2026 13:13:01 +0000 Karthikeyan KS <karthiproffesional@gmail.com> wrote:

> damon_set_attrs() accepts sample_interval == 0.  This was reported as
> a bug in v1 of this patch (rejecting it in damon_set_attrs()).  A
> similar patch was already declined for the same reason: a zero
> interval is intentionally supported [1].
> 
> Document the behavior instead of changing it.
> 
> [1] https://lore.kernel.org/all/20260722094304.3132750-1-dayou5941@163.com/

The patch itself looks good to me.

> 
> Signed-off-by: Karthikeyan KS <karthiproffesional@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [2] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

> ---
> 
> Hi SJ,
> 
> > I'd prefer adding a comment saying zero sampling interval is
> > accepted.  I think damon_attr kernel-doc comment is a good place
> > for adding that.
> 
> Adding comments instead of code changes.  Let me know if you'd
> rather the wording live somewhere else, or be phrased differently.
> 
> Changes from v1:
> - Dropped the damon_set_attrs() rejection and the KUnit cases that
>   tested it.
> - Added a kernel-doc note on struct damon_attrs's @sample_interval
>   instead.

Thank you for accepting my humble suggestion.

[1] https://docs.kernel.org/process/submitting-patches.html#commentary
[2] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees



Thanks,
SJ

[...]

