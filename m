Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F365F45A0D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 23:25:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBEE46B0089; Fri, 10 Apr 2026 19:25:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B49B46B008A; Fri, 10 Apr 2026 19:25:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A37C46B0092; Fri, 10 Apr 2026 19:25:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E0D76B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 19:25:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3EA4FE3377
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:25:03 +0000 (UTC)
X-FDA: 84644228886.26.EBB5D0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8829440005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:25:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tECCPCUD;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775863501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v3DKl437iTM33FWCHvvGddG4Gsc0dgOm4N1Crxyvd74=;
	b=1Tcj6UJttEusLTA+/lvBf1WGF8yA1mcAo6L9/2JmP63IH3OlOKIyAb5KOL7VDLhpguPfvp
	hWJ7GS/fw9ArqDNuHya8mcBK+PcyLrHJixd20t7O9U+aMxPI3/xv82ZkKe9Jz3n4HIz/9D
	LSwn0MFoQumbXAIIHc2x47lm8F/LRBc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775863501; a=rsa-sha256;
	cv=none;
	b=yt8ITqu+NwRf677xkKXEo1A8ayQf0hreml2uvak+zKMxx52coQwu32ebmOqbwqN6NnFt6Y
	6k7qiglB0eIqqKiY3M+T6OfqUkoHMfwR/iOMTGD/Mzl0CKEEsS2VXuZgENhbmg3uYo6k8k
	uoxHZaAA4IeSo11FoaSeNp7DpRX0ymc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tECCPCUD;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C70543C6A;
	Fri, 10 Apr 2026 23:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DEEC19421;
	Fri, 10 Apr 2026 23:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775863500;
	bh=+IalQQSVLkm1NicZsSzlRzKKA9cFbUHRWgUtOU/SLp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tECCPCUDu/ZmHhakEQ6hhGRJWmxkPzaVYhali8b7i36NqVoBpuFeVLRHsGIsJeSXp
	 o4NzkSzntIR8ukU7vJrbOzmGkT9s3gJFX0Gt6k5OINQnrUsOwijD50QfV/dVVoLVDd
	 ZM95nTJC1JmA6oiaENdVSlaqq5ucQ0mlZAceuLh6XM2K6XCww+m7ubXkWd5i5pVNQn
	 oUYLniSl9Mj5YLy7k5wy4Bhu35qFz9TWiUPVhrF/tOq6PRnx7MR482rulIIpckfYG6
	 WkCMlh396rkcIFT8w5V3mPhEosgEus+osmMYG8D0Ae92AtDiVQ7RXJsNh1r0YpUZ/K
	 8rpi8wikQk32w==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: (sashiko review) [PATCH v4 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Fri, 10 Apr 2026 16:24:52 -0700
Message-ID: <20260410232452.88060-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410170051.51008-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: td6j5ghzdm9aezzujmzr1bx9wo3wpsfe
X-Rspamd-Queue-Id: 8829440005
X-Rspam-User: 
X-HE-Tag: 1775863501-68386
X-HE-Meta: U2FsdGVkX1+ENGKyJ8aIFav01IZh3Uoy2ee0+YSojKU5SAGliZRA43zz3DwXorACPEQG9V7F2rTuSY44ZPSiHzjPFKfLFgD58jXIJNS3F8o51vshaYj1JtScGj1Tc2YagOSYFU3XP25+Es9c9ke313bXPN2f2wk26ggXMTWgP2IW4g6RFrhYW7WqDF6ExDngnr/yO1Jp9s3AvLJGbYWi2f7vrz1ZCrtYy1p8VTuE8T9L7uTmNvu+7VTvaTuRuogTG6Q4K5RUS4fdRUsAPN1P5cEPuSf5tQzQungPZE62WQHFcYNE6CD9xxEPItgXPCRMMLi7uh2qwfayqU9zh4EM2FmV2h20XdFOc3fhZ+HAK8FZeUShKuZGGadzTn+wYzv982W7ISES7kz9GRHlLBNWwvAxDxlww6XHK98YuERVmhM4R6J8sD9TolmZM+22UCUE/2vtDsKePNWGvsHKXPmUZPVHQ4JDg+ImrsOw02GlhUAuvlOhtOzkOdVOheIce9iZjtDQflNQpPtlC5luiHAYskjoAP66XfBIltZRP7LD1MxjLVfRl9KLYSw1iaFe/x5iOXXG3FU/acHzXuiOQvO3LfMzehfAw7p4Yymt234YED8lfG2uUf7TvlgCWSOGlNfV+ugK0Vg5YljRbUD6QCUIPNuDFJIeqENpa8364nA6HLDYTh53k3NkIIF1HHCBusiI84W3Q7bAhJZ5VtaaZA7xChsx3P3jKE7wA9V3Y1xPals6ZXadhRSC3Z3Eii3OWbt20YBTcV+wapC2Up4fRd/I3NB6HB+V4JyydGERU+Nn7HUS1vDxqm5WSyrFSoq1dPLtl1vWBkHHVKPaem0/1s4JivC5QWOBp8esBB5EEnDNe09E/HrppErS0LxQ3aOQAaJuQjSt/iX2PFGz6peNDrGoT9ToZtRECEUBmnqfsRhagwZpKn/hZdr6Pu5cZjjDsoQivdRQ89IH9mGNlg+8mLL
 wvQuWXWe
 kif+XK7HGa15593WEfADtHZpMJe8yXr2CAmi1k2hiTZelTRohy8WMT8dE/OqGiiS07geMc7vBRhspzUDQzkEfjTIssTjllgHoR2Iw7ZMcLG2SQh2OaCQPXeTs6AeOV+upKQLT/REdLDik91DngHObvdXZ+NdvTpfoJYJe4yiP2Dl+1qjdAke9nbZVLF7bNQfH1ea5KMrJocUf2uXNikfbw0bWytzN/WdXhEol5dm6KGPMb4csOCGpM24nzy/LTGpqR4oPsfU10erHA33msSr/Y/ScafKk/IAB4xAGqvNfZQe/BIk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Andrew

On Fri, 10 Apr 2026 10:00:50 -0700 SeongJae Park <sj@kernel.org> wrote:
[...]
> 1. Let's hold this patch series.  Andrew, please don't merge this for now until
>    this discussion is completed.

For this.


Thanks,
SJ

[...]

