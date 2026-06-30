Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C10C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:49:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 984286B00BC; Tue, 30 Jun 2026 00:49:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9358E6B00E0; Tue, 30 Jun 2026 00:49:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84CA66B00E1; Tue, 30 Jun 2026 00:49:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6217E6B00BC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:49:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E114B1C6AAF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:49:09 +0000 (UTC)
X-FDA: 84935349618.09.5A4C1D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 50F0A160003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:49:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OXsALoPP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782794948;
	b=OHF0Ds6n+736PFV6H55tSyhvtt3A4Jft3MqGs6Nz180jEWBgfUg97wC8/40i2RmLkkb7yD
	Ysb/YfGOD7mcC9Txadc/cRvIPgL0c1rf9nglZqX15F2E5piJDb0/KnCqVW+R8Yy0hd3ZsO
	PGhCoU4HaGbVnrtbWn8zc1otAjDcjCs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782794948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Gu0EQk5gYr7y/NtUz4uOMOtRGCLqMMs+lpokWiBqd4=;
	b=gbNnh1YOFeDGGY5yKx/7ukeUYRmLZVzxIICtaCuvAOvQLZuFXo8RvOc16zBazUc7ZaPFDo
	HmLbzQddyZeml6G4D6yZ1S4ntZPi8Z5WBXiNGBSmogDsF/C/PX5BCvDgiQUanwP1+IutHv
	ln/4iPEnjmhDBbvWRzjbjIiYQxCgJnQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OXsALoPP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD72760008;
	Tue, 30 Jun 2026 04:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBEE1F000E9;
	Tue, 30 Jun 2026 04:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782794947;
	bh=4Gu0EQk5gYr7y/NtUz4uOMOtRGCLqMMs+lpokWiBqd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OXsALoPPHIsa6NQcPP+tXlHn7YuGxrXgtyMWAySecQZLDwvTQCpU+Oc3EGhXvvMkm
	 h+U4MWcu9NaEgsQfrB3KSk0ImcwbuI+FPHE5Z+emmi3YDa5SfgXA0TIqSWjoqQV+91
	 19Pf3cAEzXXe+CXa3hHtA820a+SvArgioGRDZ7R7qxmT039MV9VYsgODpyZQv1R0TI
	 UjFeMlsSwxvPKEeSPb4+wjLzi3L9xUqo4n6xXeP6hDWa55STzaBbPRanhHfzuleM5H
	 WuuUimrJ6MTmsJK+CNrJ7dCKALsxYBgIYcytBsLrpxN9SzjEAIpdbmCXTKt+kvUOlT
	 3edw800F1KqFw==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 14/18] mm/damon/core: remove attrs param from damon_update_region_access_rate()
Date: Mon, 29 Jun 2026 21:48:58 -0700
Message-ID: <20260630044859.152347-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630040812.149729-15-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 50F0A160003
X-Rspam-User: 
X-Stat-Signature: crn99cdfm8nbwd9pe7xo4hnu49gkfyfu
X-HE-Tag: 1782794948-568484
X-HE-Meta: U2FsdGVkX1/+9+kG9uFHvZKfef33kUjP786uVIMv+tT4mmlqD7w9/yKzlo+fgRGCkJeGGxuMt8uyIFrTcQvT5skSOhMNxeR4pCgnmo66Jyi4wKdPPndiYOjH2AW84C7Nz6dtSLhvVcyRH/Ow31OWNto9hJkk2dNaUOufWxegyKMDcgHXoPwEnBkfDX1/BEWoPdH0qEX9mlRMYEjmV2nOgaRcO+77h3NEbAmfzaiS3N7aRP5tSysB5vFtaA8wHAUQk/eEcceiUEE1fs570yCs6U+xeHdPSWg/KVZkcsawyqUhpVI4VA+sLFlAtT1gy6zYrJebRZIOBDTo3tjaGr8Wy+Zpx2AD+KMAptqdKxeYaY1qmpBK2SyGuMkilwwSGixapQKIrYZ4qWpmfLBFctPq9D/44uQw/VW02feT96QFKUlNzsTM619zxJanNEgvM7Echa3nbLPFsoDbokjTiQ8+4kf1KTqr7bwps8REtiaslPo4Q5M9uuSiCD5/JiHyBddyAFCtR1ly4r9ke1CzqlJb7ndwOVMdBZTAdzb+1tFmJM+SP3ePEGPMjvPWpSl9awU/IN9RC+h2Mh6MsDKyYYdVFEE9KEog1asESCWPJtFyus9hjOVJKV9b4thEliB73+h8iGUKfIfXBo8eHewkBpB9mgChTZRTuhyXUGsp6M3A1AhujdJ3oiA8rU8AyXZK2uxh7UGo1Fxdm7lB5rCvJq0f4EwW8jBC6cwhWXQyVgZt1RV2Hex1leGBwjj+6Y7mkh5ognWEUueLacNYqSkThCoXluCva6c65Qu9AI+BdWLLR771sPJXpQsxg6p6aIuBKjCVhL920PN1zB0LE2NgVOGSVFwPfM6dilUZGJiRqqcMCwhLfcxXJPtBJQzA0dhl2fLmkzWiozJJvgXaqmdW6aYOJMFwmmGz6zYW/d7vpIZv1LO5b2JfHtx+FsDMOeuvMGuTE6hmaVRXFXEnv7b/xuX
 Fe5fhWFM
 YVMoNfqHyWc7BtnIeol6/enBehrHELEPx2qm55h74nr7h3nC0noJYrbR+/ljQf55aYWJdJ/DDWizCwPKcWHpn33N1p7nSwNYUnTbVGveKQxKcCkJ47qL0y8HquuZM1qhUe+rSx+gtENMmDPmVtTWdh+dBLeS4KTixXwRmwmcDIzLvjM5tk3pmycgq5b9GaFEcVNsXyA7KcRwIf9EPTJY6IAV3RN5cCFSQt6A5ndqPgjhRuIDtefsB8mqbzN0FhOLkbdLgrWkGx3XiuM3N+61JtdXLhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 21:08:07 -0700 SJ Park <sj@kernel.org> wrote:

> damon_region_access_rate() is not using attrs parameter.  Remove it.

The function name on the commit message here is wrong.  It is
damon_update_region_access_rate(), as you can show from the diff below.
Andrew, could you please fix this up when you pick this patch?  Let me know if
you prefer sending a new revision.

> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  include/linux/damon.h | 3 +--
>  mm/damon/core.c       | 4 +---
>  mm/damon/paddr.c      | 4 ++--
>  mm/damon/vaddr.c      | 6 +++---
>  4 files changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 87c1ff479da82..02ed47c558cc2 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -1016,8 +1016,7 @@ unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
>  
>  int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
>  		unsigned int nr_ranges, unsigned long min_region_sz);
> -void damon_update_region_access_rate(struct damon_region *r, bool accessed,
> -		struct damon_attrs *attrs);
> +void damon_update_region_access_rate(struct damon_region *r, bool accessed);

Above diff shows the correct function name.


Thanks,
SJ

[...]

