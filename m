Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26186CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 12:55:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 163C76B008C; Thu, 15 Oct 2026 08:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13B146B0092; Thu, 15 Oct 2026 08:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 050426B0095; Thu, 15 Oct 2026 08:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE59D6B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:55:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7D73340983
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:55:34 +0000 (UTC)
X-FDA: 85324856988.30.1EED5FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8023E10000C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:55:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jTiix9Xg;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792068932;
	b=wnb6G7LEiN2IuKH3vp3EEDtN6Akd++2m9K3s/wcmUMrvYd5+pM/LaTrlvavMpn0+F0A9/E
	rZ1+X8VEM1KjkrGhXKu4oBtQVooQ+vp6EK2XPt8RFLbkxE8ifzwsFYn75yrp6vcD/xXPK7
	zG32ZZpwQEhgmPId56I+xSxZV/2c7rE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jTiix9Xg;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792068932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=clp57vnClQVP+nCheYCqZXPNnTl55WO/xc0j2+TAHUA=;
	b=Ma6hmzu6CIp0P18dqyGIJQcNUupgpM4w5E1rygPyeMA11HjK2lv7OqHAUsYx1YNlQCABq1
	kzEAGmg2+ckn8jgEYSMCpXXSx5XqMcTCcM7mhK4bvkap183EuZUiDxKN/R3DGhgVy2dWfW
	IyF/4OiqqpiLBlKhoxhFukit/VFSlSQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01EDD601F7;
	Thu, 15 Oct 2026 12:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FF31F000C4;
	Thu, 15 Oct 2026 12:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792068931;
	bh=clp57vnClQVP+nCheYCqZXPNnTl55WO/xc0j2+TAHUA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jTiix9XgOAqINvZR6bBWHZkWxkukxvVWHBigSvYyttYP4WCdUAK3ug6NfdyHF0Xom
	 6CElzymUseQSn99vTklK0xyJoKCdJuC4jKujZlICBkJwe4umY6OUwcelJmMWNaAPW6
	 xmfjAGsw+JX8kt0coGIqQ53dWGbaZx/OqBuCfdNVzw3B4wcTlDBy3T27/AMrBOX4GX
	 YoV2lgw8DQkl9/aP3/rzA8p1yOg4nlnL4E3I1B+IMSYTZ0GeM6aotR8vbEtL2fXA0x
	 gquDnP9jiclizoXw09TJTXFFnKduBNvMQE/pEKRLQGV7FV8okTDUV/6gpTRTSL9W9q
	 MoLASdh0CoWUQ==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.ams.internal (Postfix) with ESMTP id 98E18198004A;
	Thu, 15 Oct 2026 08:55:26 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Thu, 15 Oct 2026 08:55:29 -0400
X-ME-Sender: <xms:Ps3QauruKha1RaTfSbJorefQoWrO5sC1GZTxGDEtT6iwvRfoXTnxNA>
    <xme:Ps3QavAbGBJLEN6dY-z20ZQ6DtGwyMVrPgKtNQrxjV-a_4_Myh7Pmbz94QaVFS-Eu
    vmiA7kGkPTVTYeENlib_vXjh2JE4EV3TaWejBE3zRlVm9KElicDjAA>
X-ME-Received: <xmr:Ps3QaseGMDjM_RzxtK5GG3WzyCjra6Si_TRxn-EASt6Gg2a6jyWWK3JrM6M>
X-ME-Proxy-Cause: dmFkZTENeah5jCyIIexJsBjsOW84TqH2gO5rqiAOue2liPsjxhJZVfheu5qG/L9bNI7vZP
    O56axSZ1Wv+bTUUudMcDhq8xMBTsA7tgGR/i3ipoz6XNgpJ8FASKYlVpoWG55dt0ppMuMe
    c9UrZ/xlGXys176GvhcEKtHQ/ed0Rj8PJD+28gZatuRokFMbBB1hCyDumbQerfaqidDsU9
    9h31i+E4VRHRE8eXq00ymlPNkbhhutz5ixoC1ggrRIo6Jb9JjFLIHyGaOOqdgQtzmbYv+M
    VI3K/8qaxFK/Fezlj/6k3b3fWpdpMMzbtWmoN+b3zurRSSR8fiqqa6hkYACGX4hI3WgoPt
    IirMy5el1faMQe1WSd0dX9YsMwuu5yeN9bde+mswRyZSJKUDjBlnFQSe8AJJ5ywzeDEvEI
    aGnUbIMhtUFDHoOwLND8Zb08YrUQU21VVlWqXe/A5IcMcYZn0oAujblX+iYCNNyuEj7lQL
    Cy2ESt1imr0U35qn3Tb/p6kjom1TAS7L/mwHMDO+NDSTb867rANutnqTlXYDz0HMmilFUJ
    3CfgqtLOYct/PZnalIpHy+/41L+LY1Bo1MSpO8UFb47vo+Kvjr5KnQjRjNqfd12rWpoWS3
    FhunUymkYp9bH229QCAlwcww0dzWLmJ4t4daxRfL2nkJT5ua7SC1q0RtDpOw
X-ME-Proxy: <xmx:Ps3QahDY9OLuq4Lvb5ErDpmJPkc-ntt6m5HfzKAf_cwYGHr-vtHSlw>
    <xmx:Ps3QagRokeyqCDKS9Jozm5Fc2a-hFwELMmlV99lOPj_JVTIXwkhi_g>
    <xmx:Ps3QalcR0uZZ_zK5Dv32EWTxhRkvmoZLTPh11jjmBfbipPPVpVKTMA>
    <xmx:Ps3Qajoi2LZk8-4njLtYjq9AisXNOOdY5kyVToTAVtJd40WLKewlZg>
    <xmx:Ps3QalbxEL27mxEe6tb0xbg8C-QSzpxw4S6szaBMM0dOmOjW0So4a51i>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Oct 2026 08:55:25 -0400 (EDT)
Date: Thu, 15 Oct 2026 13:55:24 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v3] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Message-ID: <atDMN5MoGrwJNpAj@thinkstation>
References: <20261009125503.126202-1-kas@kernel.org>
 <15a9e03e-c748-4e51-b8cc-583a3610c897@kernel.org>
 <20261012192834.6934ef85444dee4a60d6d876@linux-foundation.org>
 <as5q14OsbK2CmOrh@thinkstation>
 <20261014202936.GC371161@cmpxchg.org>
 <78238103-3a7f-432c-b1df-bd14d7cf4bb1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78238103-3a7f-432c-b1df-bd14d7cf4bb1@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8023E10000C
X-Stat-Signature: ejofz75qs8q5ai1xhimj7w99afdmgifp
X-HE-Tag: 1792068932-915037
X-HE-Meta: U2FsdGVkX1+H6KdjsSW3in+JVHuCe/CVXVpu3Ck+Usral1BkwipDAWnmE928jDokp3R4P6KTOSF9SttMNksMum0xDAJlkNtigdtoNEeCgXrFxhKEKlTCoCjChxjhopKXGXVHFR7Oh7bXznIMrzknLf9mNQgOls1/XiC67JuYbDdKp2DuWJzTNDwV+qpU2Y2BLu9i1dqVrWbIkW7au8ptLMPlNaO9sDKCRvEPqmFZTrf9c0huAheHE+U4UVj9iwVMZA2O7ovOLgceH6MDzn7M47QezY7KjBe9qjs8slLaNrSEq99m7Rl2/bkuwJYZq/7oSEmtALcgifCDemmaqOssxW3pYhAVfMq3Ha8PnGNlfYBu6SrXMKFFHe0dnD1L7jv0kgRWRqJR1iahwjTbObEho1M4DtFX6+LKzEJOHFc8W3HsEAyMapox2qblgY11jfEST9HhrM03QmqNIzv0NXO7Y/Dh5tLDw6MxHSCq/N0uKga76pAp/5kAJGnB4i2W/xmAgZWvy+rReILtrUoxDgvHBMWtrb9rQY61ygRegDYzhvilFRAgnwTeYU7TP9IvhzlmneFz7xKeQkEgW+/ELjc9UhqOScjBh9EVTVpH+JSkPa/Ilxy3vsPsC0wZGH/gFsRegYq/Uy0A01OxBe5IU6QxciT5LmUYuWrfPYES8sC/xj48Ie1nK8f6Pm3dOF5kDW1dITPVtpJcIEdtqNTH7n1f2lo3oSFbo3NDY9W+6QBsLse4VZIhjtMsZAuEn3Y2x+NwRQZwVHUXQ1RVML5m9Z3VhvpDbUIbb+TLuvomD0v3DokWIG4WJWJvvGaYuR86408DfUJDRyUBDUiTGcRL8JtTUD+zD8vpJdJMUhNMzi5x1y58+IW0UwxToxkataLvCAM1Ab0XwVLPkaEq9hXAJziSTDFU5Ospg5r5qS6YZGC+EwWbHGhnLosigr0bxcStjJqXXitFLNkYnOJI1U0/meM
 pEX2EnyB
 WDfJTjT4S0lVSU/jmVvyXfSIRNNHJiO35qY4PrVCcrtSOt836e8T8CMwpMs5Sw/TidIRS0xd0rsbbhEXylKx7eWikIdUVW4+TRDgLrxbeVGgcS6dnr83CirSijtUxP2OroJzNzUmhcTeoJYLKHbv6WZFilYFU9eGL2b4FHaIRZ/VHANxAfLg2QPey5W7N+Mk8RoyQinoH3CeZQ81XCjTHV0rP0/ANSd30AcQ5KAjZtEEOh+E8ANNNNIR3kApE9ZdIPjMvUjIu4S00266gjhixyanE4YDdZ/Rox/qnQxta3ZcRKNUN7jnuKQADTO0Sxnz5yrt0DUXkDrPJRM0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 09:16:36AM +0200, Vlastimil Babka (SUSE) wrote:
> > And agree 7.4-rc1 with CC stable is fine. Sadly, not sure if anyone
> > but Meta is using the feature right now.
> 
> I thought it was there for a long time but it was only added in 2025 :) At
> least the enterprise world is slow to adopt things, AFAICS.

I was thinking to propose a patch after merge window to make defrag_mode
default. Do you think it is too early? I don't think it is ever going
to be truly stabilized without wider exposure.

We also discussed with Johannes to make a stricter (defrag_mode=2?) mode
that will not give up on fragmentation ever, but OOM instead.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

