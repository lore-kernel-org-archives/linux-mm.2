Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD4EE606A32C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FexgPKnt
Received: by kanga.kvack.org (Postfix)
	id E517B6B05B1; Sat, 21 Nov 2026 16:19:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02FE6B05B4; Sat, 21 Nov 2026 16:19:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3FE26B05B9; Sat, 21 Nov 2026 16:19:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9FE9D6B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:19:33 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFFA6C04A1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:19:32 +0000 (UTC)
X-FDA: 85460392584.12.9EF8596
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 41634140009
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:19:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FexgPKnt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795295971;
	b=ZTBrR17f/uiqwc1F8REGiyXTapN+uKUlOtXFMnZZOKSzLbdn6JFOdel66J4LrxoNQF6aU3
	UOtOVrBu2gCjr3KeSCXAXcgOUROzQsw0miUnDUAn7B1OIYzi2NuCRem3Vng23UfrPCVZRj
	TA8uh3GVKuJnfwoJw5IuGiavZIbAlGw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795295971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WaTru+7iZeRykjuAQvPQ+D4kS8HXOpf8/kVMpoCZb+8=;
	b=yoPnVmWbnc1IZ5yDlVGfurz67IH+3d9/P5dSCATROpfOw/n0Dv900F8TXTT2/BD4kUGUNU
	HTpBF4nCycKw50CxMAes8GHpBBBPG/f2aYbNf4SsbQ/xA7E/Bt7HIv/GtX2VDa7dV1DY/I
	7uUptCnTjoxhWl9h9sEFA6SoAdzbRsM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FexgPKnt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0034F61448;
	Sat, 21 Nov 2026 21:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859841F000C6;
	Sat, 21 Nov 2026 21:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795295969;
	bh=WaTru+7iZeRykjuAQvPQ+D4kS8HXOpf8/kVMpoCZb+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FexgPKnt7v63zRWn1h3XidhzBo6LfdZo2iIrNwaykQrZj/PidCKyJqBEbhtma4t02
	 jkRQ2s5CXotH9rH/EXnhtatOaR8w/kqMVUrM2zVWhNWr74jCvGa9ZcFLh4ChxsXd3N
	 m7wPoNJTYOQWVuNv5lVTzxjQ+FEhWxAne/gTrv1WUHAUanyAsShlWnZOAFx3KKTE+S
	 /hJ+zNFFSbb/LKyQCPc3Krq13qY1y9VCypmoyS8q4PKPPUXzubvTFaYqypBGX+E0AP
	 WJfGOfR81TYSuOb6hBHvEF1kt8jXIBhco3o65JK3ud2mrbJQO4QlTPsSQ2QtV+mvIa
	 RxwyivuYK5qNA==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 14/27] mm/damon/paddr: support REPORT_MADE type probe filter
Date: Sat, 21 Nov 2026 13:19:20 -0800
Message-ID: <20261121211922.131352-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-227387@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 41634140009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: ihdntk731744hynzzgz714opz7gznt3c
X-HE-Tag: 1795295971-733553
X-HE-Meta: U2FsdGVkX19wzFobRUjBsPiJdA8RtZu9VDJt36vq+7jM57GpXCmQHP9tKv/5QVWIUW2U8TQ81ws7BPAe4Jl5nFRUst43YxbfHURAWAtNVGXJTZbPnQTKJjG6UwmiYcsdtpdcTwNrjsG0MfMLZuCSTa2L4wt9Bexd4AIIC5064rOlT0c9wfowwl6sTUEwJ1F1PByowdWvUk6w7NEDnt09BCWS45zbaxxNwDQqp2qr/if5tNfUQTTWLuW3ZBAvIWmYuYma23aSaMgODVb2OABv1nhTUwXtKa77e58cpu21qcAhwnNkx7OCJw+D50M1JNxvAJ5qLJmRUCddJ7kgnDClHWEF/AWAVnaXg1YfgCMeU8G4pBeTO5G0/DSfzT6XpenaGDBHCeeFOGXiPmsFrlewcJwcXR8UmYQMTKtN7XQWQQObNTWOuj4POZWmHHMWW1wdV20Q5xlPHVl1wfmcPn+SpHJP454z67xUihQUNLFGtBR45hkJq52eyKxXwOfRxcc2K0D1428LW0EdhnAv6TA/cgamlTi6uyMFUOMbfk5nFHzCR7Dsy2cy8HNv/UeoObhbcq6TD+x7QnZrCwjryYGsGvybVNwTTMmWmp9ng5Tlj7OVb/Q4lVjZJzBbmuwxdGdbjg+wPKTht7s1OiY8rL+pWdVqo6ysprKJaWC4mTgrvCkH8wkHYZPffSIi/kGpKFb8AZXI9/KbPc5cLvP/vPOcoTJlh5d8LP1xQF/ck2YH2ZA7lcorcr3cRTuGsXKRAjKS+QiAO/GWfCY8H0BYSM1mGUEvTZuGK0siDnV2bBmBVqqeE0QRUwPbEQ91MzxPy2+s76L7Viwrh3vk8dDQ1p95kQ0uRq1PfJ0GCk2ADH9pMdnZUqHnspyPf8xqSLdgJF2NCZ+jBE3FvmGTw9yAzwXYP8nQtcdgRQyH/0h87cXb/OPyLEwsDea+r8oDtk44s7/IASQ6BVxgCSaAXaLmo9A
 MpDDyP5T
 s0yyb4ggoGjPJTg+Od4chBm+rU/nZNu1MCWciGxaXTmiSaWYE8Mf2BD++4IVoDz4C7QRzvsbuil7CmLuYFL+KCQgGCLQl21ogz0+lfh0wR9smzDQJ89Dj0w/NF7raA8ZFHuMKEjMkySbhdPHwOX3hV62fNTeU1BpqghUvWjME0G8+jn2Xint4lynYGEPiRlkxC0w5mcHezmn8MgP+3TgOCO60ZSixNnHEAMHQzCZISwa+WwoXWN+ts+Pe3a9UzrqEK5UCBbbt9TU5W5fPTIyv2AURf+XiTMpPDGPt1aXqvbMVdZ+5WmoWVaeOd5PT2c5UjuQiWnttEZ3VMV5pNsrFU/Uyp3siu2R/ucQgYq1mh3tdHBJO9uQzY6dsKaDxoD2MJClj9f5rwyW1/KEAicVM/bPP6Gr3q7eDMsAz/QkrguJeS/l6Ch3j7tGDMgIFvfT3c4cW6W8NNPt5YGsb0a1E4aE5yj8wWNwc4m9Wi9/pcWksRw0ZT4sCpMf+28AgFe7vfxJBEsjLBSYMaea/Uag+IZIAIPHpYEqeruac6ltVXpCeAxhHN4eyNJWjwJM0yR6D9qHXhF6DOve5G1yDKCkUt52fVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 21:11:46 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/damon/paddr: 64-bit phys_addr_t truncation in
>   damon_pa_filter_match()
> --
> 
> commit 28e4b56e5a2332a155374f4f6e67e8b3da9ffb34
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/paddr: support REPORT_MADE type probe filter
> 
> This commit adds DAMON_FILTER_TYPE_REPORT_MADE probe filter support to the
> physical address space operation set by querying damon_report_exist() over
> the last sampling interval.
> 
> > diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> > index e89cb14ee17be..4003ae914f1a2 100644
> > --- a/mm/damon/paddr.c
> > +++ b/mm/damon/paddr.c
> > @@ -140,9 +140,10 @@ static void damon_pa_prep_probes(struct damon_ctx *ctx, bool set_samples)
> >  }
> >  
> >  static bool damon_pa_filter_match(struct damon_filter *filter,
> > -		struct folio *folio)
> > +		struct folio *folio, phys_addr_t pa, struct damon_ctx *ctx)
> >  {
> >  	bool matched = false;
> > +	struct damon_addr_range addr_range;
> >  
> >  	switch (filter->type) {
> >  	case DAMON_FILTER_TYPE_PGIDLE_UNSET:
> > @@ -157,19 +158,27 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
> >  		else
> >  			matched = damon_folio_young(folio) == false;
> >  		break;
> > +	case DAMON_FILTER_TYPE_REPORT_MADE:
> > +		addr_range.start = pa;
> > +		addr_range.end = pa + 1;
> > +		matched = damon_report_exist(filter->report_type, &addr_range,
> > +				jiffies -
> > +				usecs_to_jiffies(ctx->attrs.sample_interval));
> > +		break;
> 
> [Severity: Medium]
> Can assigning pa into addr_range.start and addr_range.end truncate 64-bit
> physical addresses on 32-bit CONFIG_PHYS_ADDR_T_64BIT kernels?
> 
> struct damon_addr_range uses unsigned long for start and end.  When
> monitoring physical addresses at or above 4 GiB with ctx->addr_unit scaling
> on a 32-bit PAE/LPAE system, the upper 32 bits of pa are dropped (and
> addr_range.end wraps to 0 when the lower 32 bits of pa are 0xffffffff), so
> damon_report_exist() matches against the wrong address range.

Good point.  We have addr_unit and damon_pa_core_addr() for the reason.  I will
use those in the next spin, like attached below.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261121210013.130397-1-sj@kernel.org?part=14
> 


Thanks,
SJ

=== >8 ===
From 73575b284234823e9b9f78d9bcd614ecba1ecc54 Mon Sep 17 00:00:00 2001
From: SJ Park <sj@kernel.org>
Date: Sat, 21 Nov 2026 13:16:36 -0800
Subject: [PATCH] mm/damon/paddr: convert physical address for report_made to
 core address

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 8cc5b249d69a0..be3283456009b 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -224,8 +224,8 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
                        matched = damon_folio_young(folio) == false;
                break;
        case DAMON_FILTER_TYPE_REPORT_MADE:
-               addr_range.start = pa;
-               addr_range.end = pa + 1;
+               addr_range.start = damon_pa_core_addr(pa, ctx->addr_unit);
+               addr_range.end = damon_pa_core_addr(pa + 1, ctx->addr_unit);
                matched = damon_report_exist(filter->report_type, &addr_range,
                                jiffies -
                                usecs_to_jiffies(ctx->attrs.sample_interval));
--
2.47.3



