Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 074BACA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 10:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2322F6B009F; Tue, 29 Sep 2026 06:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E36B6B00A0; Tue, 29 Sep 2026 06:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1206B6B00A1; Tue, 29 Sep 2026 06:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E2FE66B009F
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:34:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98C12C044C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:34:11 +0000 (UTC)
X-FDA: 85266439902.28.57DB413
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id F28D1120004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:34:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BkRAZzAA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790678050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yBXkg6lcF7PD3meg2Ejx15cUOLf+061n4vtekQxtgDo=;
	b=wN4aPnAK1PTIodLNz8k14fTpAJG2GnkeMnRZVXv8CMcgzGY3/PX8x6NRvsivDxKZCIcREc
	1qMpAUduT2YyPI5neQ8ifsGWtIuZaUNhOh4VKPDoBY5Zt7QVaQ1aVFrD3WPTs3vEz5FFbG
	PhfKSMBs4TpPkXjL2KUQ6zvx1kOB+Xc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BkRAZzAA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790678050;
	b=50XpfIMJQZDjXdag3zZitOF6bOuA5RGqEro/iLa7KYTy+nom/+x2uvw2fXbe9NCb7aqips
	3JDuNZH2yjeoKURegR6Bv7jvtWiWZvbzKSTMyHDu56xO+MLj52UPnw6e3szx32ZLPjr9C/
	qTZlYu105Zn2sTCh87/71pZUiZan3Bg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6BB0860008;
	Tue, 29 Sep 2026 10:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D041F000FF;
	Tue, 29 Sep 2026 10:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790678049;
	bh=yBXkg6lcF7PD3meg2Ejx15cUOLf+061n4vtekQxtgDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BkRAZzAAV8/v/ofwm68pL7D7X30D+pQbx4GcFkSEH39MsIDPvjYEs8+iarX+qTD3m
	 mMYFRfqWksoJomd5y2p/bfyMmxfpZsy8wEiD+kRWxk9dqFY1r0QwF0xFzAszOb24iI
	 kRmvwYdoE5heMF5W1AQrn4P88T8mlyoioR+Ztx3AwTcNMtTXoSAEoK1k834K1KAHHc
	 MOKzPZVDRj/tjwHLLrLCYw1yGuzqSXHRHPiHfZW18i3QRSpJT+zVr3hQBYbGRe2zhs
	 8MoVlGNYutWNuwSP1RHMnEDXsCgOnkhlP+eBBHtJ2tBdjVudqPeCBalzAj+MVvyBp1
	 Lu+IwyjQg0Rdw==
From: SJ Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/8] mm/damon/core: introduce damos_quota_goal->complement
Date: Tue, 29 Sep 2026 03:34:03 -0700
Message-ID: <20260929103404.48154-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <9e07dbdd-3b02-4175-b343-c8cb6f9885e0@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f6mk36xeopeezdeyn676r78zc3wyn3xx
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F28D1120004
X-HE-Tag: 1790678049-458313
X-HE-Meta: U2FsdGVkX1+InMQyC4ylQIuhH2i9Acw0AyB1EzEiuEA4n3BxwcJs48EtdD+GpaKhepi5M5hdPZAteLw+AlRz32fq13BBE4PPLRmWDSc3JJkmlMx831/207mhvku1pbT6e3Y87CuNh1vqsG/3DgxD1vejJhiJ/xz0Sp0rK+C12G7AR0oQr816gZmG81KgzagdSWY6v2NlmuEUeUvfuz2qEnT9pudaHMbcJKemcxR6h+5VQ4emMYjAaaYP5Af8sPQUkCUHmODNFGg0BPDxqyl8t89sZZfIUcPsYFr6sLhcAjQoQtuErVKdBkV6V7aSFmZYq/qjON+L8yveZhtekF9/d2Vs6ruaxSaIYYlQdYKYnjHoRfobYkpzR3qtlgPSs8l6aTvPYAikfctT4U/RdarVzWS6CSTtDd4cUfFZiHIoZ5HJwA/4XEamTLlx+gtF4Aw6z4p02B6SvLGrNd2+FsBYhBdH4NkqOFGVDf/AEdDYycBRSp8bt+tes1LPrRAtjtuk0kpb4+aj4cv+BGbBTzrZzSznD4dwNl6Su6ptmLSI5XxSzrafmFyu7kvqMvleVoNhFBgIl16wURNhKJtXn+4s/RQcgQo8bgpitBmw3L638sPMo7p0UVlXxF7ijoNtpfxlsM9dohuc9GU/Vx7+FSkZ9nQXo4B1AyBLc+hJD/4VgQJFOeh/CeQkmpBXOXt+Err6F91qL2L6uPzvEY6uD/5MbWVkuZtB2ZTQ3GctmA/kzMDM8NKMC49xBrOrRr+43MyhHaGSlGRL2k/RHIsgR/Cndg//2EZSvMSbPjDBzNS2kTi7W9SsvbK1bR5jhdXJkHIxa7h96dT8xg6+c2KfZAx7eWmOz97jjMZirElqHybO5N56RUigQCQAPISI2pEVk0oGYYYUitS7EHoKLP/cJP6q4wtQP7F8iuDZr3YVGUAzZVuM/7fB/2f+J7KK1wy6uEpiOF1bt6pQDfoB1+490HD
 8/87Gj2m
 C5P6xwILSyeYPknb+Pvs3F0BBg3KXClItNpgEqRkrPcW0Vrz8EWUNODF6gzb1WYxbB2ncgKFBSoO4HOKHDb6gLV8+ahFziS2a/hf20ytewcYeAup58ivMGNCXBAr3ni3L7K30B+9PbUc3SpOUtjmr0HUzM67M351Ms/2msXo3q4W9ChDHutFN3E5r8pnKjzv4mv5FgXFFnmty5pW63GVO2KGaChCqaIvSScXGwWUaCOzWKugcIxU8v0OvGtIx+m7dZPpdCTbN88hgTW+gQWtBCdO4Eyx9y0CS//aNkfiNmUUDMt/b8TJBsIM89g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Sep 2026 13:24:20 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> Hi SJ,
> 
> On 9/29/2026 11:01 AM, SJ Park wrote:
[...]
> > +	/* updte current_value to complemented value */
> There is a typo there. It should be "update".

Good catch, thank you.  Andrew, could you please fix it up when you take this?
Let me know if you prefer reposting.

> Also, what is the 
> purpose of this comment? It doesn't explain anything, which may
> not be obvious.> +

The purpose is explaining the code below does what the comment says.


Thanks,
SJ

[...]

