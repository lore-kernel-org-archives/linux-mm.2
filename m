Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22702C5AC67
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 16:27:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0DD96B00C4; Sat,  8 Aug 2026 12:27:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BED16B00C5; Sat,  8 Aug 2026 12:27:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D67D6B00C6; Sat,  8 Aug 2026 12:27:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6995E6B00C4
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 12:27:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC544403FC
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 16:27:35 +0000 (UTC)
X-FDA: 85078632870.23.CA02392
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 542C240009
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 16:27:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oB2Y8P6i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786206454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mknf88l59jYGHy564b6wquM7BKXv1lWu2LkHGwW/3nI=;
	b=qfPr/efTTlcXWUWV0pRgl+48MQmmuz7rWl9x5rkapgc+bwN5etYe4jyPEXuvc4aYRqbheh
	M8eRHzC8hYooscir1sf619tRCGDTZzJw00w/60k1d1VQpk4ghICVh7JWuymo0nFKRIRj29
	ouDN0SwTAvBaw0k7amgmZZtxVfdprAw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oB2Y8P6i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786206454;
	b=E/P/E055jkueA50GY5dBql1PoaIx8ZYTq1J/61eSXTARdrBtg+DWRTILKD83RwOF2PReWp
	FVuadHPqzJEv1MHXrhZs4cN2KyI+BAEimDk8jophFWzWKUcDiRGbn5xNRfISxdpRZbFCc5
	egc/vDOkO+YwFbxQR0DN7fI3mRENC/Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9682E6001A
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 16:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3165A1F000E9;
	Sat,  8 Aug 2026 16:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786206453;
	bh=Mknf88l59jYGHy564b6wquM7BKXv1lWu2LkHGwW/3nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oB2Y8P6i7M3KVb+6+Z/Z5LZP2H7EBd8xQolKqmDNfimo30AInQxzeSCHrVV6fZBwo
	 IYMeuwH9IrBM6jkBf5md5U2jScC8m2wMFnoXrZu4RtqXGhllFckDLG52VlutPStfJZ
	 U/ozrlktpwsAB4SHVxrU7AF79bqNUSwxvw/Lnf/67kHCYre1OkqCsW3tuvJrQoruQ6
	 yD0oj/l4tycXWRpos5wcFrVB8EIKfsDFoa0fJnYgmrQ1FiE5XHkuJct9wbgFq3V1IX
	 5y29rviBQ2m6OwmNW6/IU1RvMsJIkLIs0qgBpXWwYr5zijg/JId9jWiUJr7iz4CSlg
	 OH+jlUY5NxdVQ==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [CFP] DAMON Nanoconference (aka BoF) at LPC'26
Date: Sat,  8 Aug 2026 09:27:24 -0700
Message-ID: <20260808162724.92408-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260806003357.92659-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 542C240009
X-Stat-Signature: i31x8swzcgfijn45osmu7dpjhcpqtnys
X-Rspam-User: 
X-HE-Tag: 1786206454-923393
X-HE-Meta: U2FsdGVkX1+O360PnkAleXyVpbveWvgDvgvk8TgNRyF/k4GL1ali4Qzu0ASqvjy7rowXsTrokog0BTg+bvB4TxF02RmjwJkzUr8j7sCbcoqiiG4Hfpy0NDyYG3zrU/5B4IwN/BdQfuiprth+Zl0MLt5ZuTe/xvSnXtBRTJu3J891ToZ17d2+Q/ipYdGfyOovnaR7xdcl0F7zb3iNQwOXI16gvWlijAbndq096jJikTBGMrpNIVHllE1k7Hub2L+bHYWRQu8nzdEbmcP390JnUvPUxp/fc5FNuYqI982Jpqsk6zB3hL59DwVQ7oIxWfzFA5+HHRwd80JItSj8sV8QWpr99cRenOuiujqy4Kjmg3umgMGIlk/Blv9ZoviNZL9rmhHgeWBDlZFxc4Mz//mwfnhht2Kbbd8ogPTcTVpI5OP5FR7SJyViT96Tlt5/6KLqhRK2hd92i2XiTdLWPDbNZtIq3NQs7YJVg2864lSLtbjVL2ignrAjL9j9021g+Q0jl/LWJYmh3jz/u5zP13hwzBST1qe2zv+eKJEv+cnHzZ9sqRZOjakdwVOm9sBFzcLul7Zzm68pJZivV3t4/ARZdVSfBMapi263FH2qANj8JGhI+KRkDLEpJ5ApNh7AuEx6JOMdC6BvwDbOxbpFRUMkEltsbQDoxBc4L6ihOiZB6EpPEmG7kzRM6tEGRvTP8eKf9fLIOyKqV0iMm4KBwFTqGM6V0z/ITQyDFqd2HJhz4XmRG4GYBqCfRdWRn+60OICXoisnjK7UhIOjX9STQgTkZzg0gs2zuIkOAoEL+ZOx53N8JXWWklhagGc3ERJzeyb+mCGP6Qx/T2sTTBDpCplEJL1MEbvU3SeR3fWdzmsWd1WTMwe03K1J/12IaDdcenoHR2EzsaToFLwDF4MdhB9knmTGZo/5q1uEKvoEmp8aCLUc5Yqm8ePkRzKbB69v3mZeZUYnjXXYDNctIEk3/Sm
 hG2yLJ1u
 /JlDFbAJY0YrQKvYlsa4uA8PaOypm68j+VTy1k71TFIrV2n9vC1pUnvyWGgLzgoimDZBj98FWXbEV+8HgLzSrQCaiRVWo95HFLb4HKVYEufPmv45QOm5r58uFtSqVIXTn16Br7np5ZqeDXoHJ61fXj5lQYpUl+eXPN6jljhby7o0GoMjB0CrPvqo/O2s0rHabsQ7GhMODzKO2KcYnELyMXUkbGSSvAbtvrf65m/zZPj8zrt9Ny6xfD1Je5aphXGm5cO/kIMcmt84E2MtGkAxjrAuC1BN9JaHw5dvxRhqgA3rG+2kUZNl4Krj96Lxfvxm+BNNVOFdqavA0luKZ1qdpBPxuiVGcBHjg1a+Ue0F6LVEZ7w1dMjlqDxYREtLJ981+DgWVrJxWzJhWwhpIWwYUjCmEcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  5 Aug 2026 17:33:57 -0700 SJ Park <sj@kernel.org> wrote:

> Hello community,
> 
> 
> We will have a DAMON BoF session [1] at LPC'26.  Because it is a BoF, I want to
> make it as casual as possible with many voices.  Hence inviting you.  You could
> think this as yet another version of our bi-weekly Beer/Coffee/Tea chat meeting
> series [2], or the first Nano-sized DAMON conference.
> 
> If you have any topics about DAMON that you want to present and discuss in the
> session, please send an email to me.
> 
> Example of topics include but not limited to:
> 
> - Your DAMON work that is recently landed, in progress/plan
> - Your DAMON usage and success/failure stories
> 
> Depending on the topic and number of proposals, I will try to give each topic
> 5-15 minutes.

We already got plenty number of proposals.  I'm closing the CFP.  Sorry for not
announcing an official proposal deadline in advance.  Please feel free to send
any DAMON topic, though.  We could extend the session to hallway track, evening
event or a later DAMON Beer/Coffee/Tea chat.  Also that will be helpful for
planning the next DAMON Conference.

> 
> 
> [1] https://lpc.events/event/20/contributions/2453/
> [2] https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing


Thanks,
SJ

