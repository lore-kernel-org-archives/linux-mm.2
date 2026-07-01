Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4653DC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 01:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 136576B00A6; Tue, 30 Jun 2026 21:08:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E7DA6B00A8; Tue, 30 Jun 2026 21:08:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3F276B00A9; Tue, 30 Jun 2026 21:08:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBDE16B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:08:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 55C72140177
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:08:24 +0000 (UTC)
X-FDA: 84938422128.27.02C2D72
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id B5C1280009
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:08:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bQ6m7d/I";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782868102;
	b=nLEHhfFnan/txW5CwieAEr3yUXVsQnHHPQtuVnubg75wQGq2n0zpAN0Fx6rz8JJUFzWBgM
	YEoATWiRfmFeppoQtxdDpx6nUNKQGe2HhvyzazkiHcPd/mBXWLrJscscmoRSC9rO8MAPlZ
	/8nS+Ezx8Pa0aVlXfrq4N0EjUwqG2XQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782868102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l7NtdNId2yZYedn04+XbzeafC8xkayzTBJlg6/vczaI=;
	b=cFPIPE7x8svu5kkdlmEaiUFroRJTLcRMUdbGN2cCugW+46hlZjNAhEHQ+1/Wknsm8jDDT4
	ADSmnl08o1HaTCuJTITcWyHDY1oe5bjxvekpU34rVNtH3dJMjMiA0heDt7y3csis+BBn3m
	z43LfYbd/qJd6g2USv9Q58XdfevjO1A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bQ6m7d/I";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 165BE600AB;
	Wed,  1 Jul 2026 01:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EA91F000E9;
	Wed,  1 Jul 2026 01:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782868101;
	bh=l7NtdNId2yZYedn04+XbzeafC8xkayzTBJlg6/vczaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bQ6m7d/IypMudNG0ClR4/F6d2wvPfADidg9ROFa4/xfs8MsRnHrTX6sEenAXhAVJm
	 Mr8GHAUMspE2LoggB0WZ+oAkU1a5FLdD8tZF/C1W79KzChQnfnj9u9NUajgwYQP4NO
	 ZwDHC4FN+Ix8NNhmIOZ31ux9IAUc1D18FOTwJOiTMBkcnsnWhIoXzwSGWoTDPcPzGh
	 5lGL8/Cl5jfp840rUbVGapPokme8JYFOglKC09gKFMHfZbaOKh8OulA1PkyayfAP+s
	 xaZTZvX4KlEVuciw+z3ywgF4ld1H4C1xU2VAqrAR5QkQEvL2lVogkmcBScg0ZWUNdJ
	 CGyOY0Vgw3e6Q==
From: SJ Park <sj@kernel.org>
To: Igor Putko <igorpetindev@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/vaddr: check address space stability before VMA traversal
Date: Tue, 30 Jun 2026 18:08:13 -0700
Message-ID: <20260701010814.96836-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630152558.24063-1-igorpetindev@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B5C1280009
X-Rspam-User: 
X-Stat-Signature: adfia4xwsafg4ih5q16a9wkkpp3bopo1
X-HE-Tag: 1782868102-155969
X-HE-Meta: U2FsdGVkX18LE57BHaSI+iT5TLyqIg/5MNOxS6zP4CS8peh2AXZwEPuBlYW3OCJ2Ws6KdsiaCoIIXS2ZNR2zDEDbXO/stD56f7moSdmE2D420E9rronpBbBd0N5c+H1ZO/ekKXjnseqbLtSVYyR+yq5d+8GltVcVCowI5CRxDkVouieck1Kg189P5iWYn+M66Pt/sj+rSVGWPTUpfoYEN8Y09uiCqXVBQ1jj+yPiRi6/eQAHUhf8RnUlPGGIfpLw7moDGCE/ZtuunRcgPHXJNugFRPDCo1pNmYKKktJbRj1YLdgaABqXC++2PN19v6W8W9VOUEPbIt+2gSasf5anHOQRigtX1s0yuEyfKlufP+CLix0eSkxCx4ktaTZhjxSj2IPQ8n63kU4A8T5tPKqs/LYZAbVsyBf0er4EIILG0a+lSnVcmhplVbtldzum+K74yilUg+bi3EDlVxpmoQMqBk23By6vUnGF8bUc9R5bvyRg6ApM6lBPT/9Ppcs+T+KSq27RNus8EZAecl2QOGpUMxsTcIU8ZeoTLECMrl4cxNlrFETgm7KfgHg7h+/IdC7iiSZ+oqG2gr7w6Wy5nRsWiIe8duQ8t75tPmm75m/gBxuZAAyOoSxF0v3l0f8YBL/lt0D7Ps2FKCe6DvvHfdFTHzXe3rOoPFN96NOGTYDnyrFrvBwf0OHQdHVISkyMkqOrmx6ZXK2GzW1yVEIS4DQXREyCPiPPBVGHmI8ibymd8OkMJtR5upLKohFx2xTfcSe2t/ZAGjnAjLVFAXhrj+v7IpJEekN8XW0luoIfI7N551FGbwXiBY59hubBxXnvwgsaj59SDkSsYq0Hhg5mN9RsueArw80nEV7OTEKumrBpWsV/P5eTiS5PolyvM9+xC0KSUi78EZWitAMYmzsyCn0W4r4j5I6nYTbAZqd2xOcQIytvyUcB5IuSRJPqDAzVudF+iSKDNb2fmXUgA5WUDoB
 oAek9I1g
 EUZd2Tgi61kzRJSzX6sGHfr/9J53GDX66JcjyZ8MaLnNmxYVrkChxa5DpfeQM4OUHBFPDxnPq30Nwa86XKjE0+MChnt9yhxl7CO0YM0w1v1WoUSkai4xILCzUbbt6efGkA5jJrUZNMXhmM3ElnEyRzUkc+jXwpPyKWqSbirDuFS+x520whDNwcofXyoTe2vs5oSWnp9X0e2Ndp0DgBRmua9h82228vcabAScq8s+NilSSKqXhfoOQj+wiBUfQqeZamUNs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Jun 2026 18:25:58 +0300 Igor Putko <igorpetindev@gmail.com> wrote:

> In __damon_va_three_regions(), the VMA tree is traversed without
> checking if the address space is stable. If the OOM reaper runs
> concurrently, it may mark the mm as MMF_UNSTABLE and leave empty
> markers in the maple tree.

I initially thought this is correct, but...  Hasn't the series starting from
commit bed76bec3111 ("mm: relocate the page table ceiling and floor
definitions") fixed the issue?


Thanks,
SJ

[...]

