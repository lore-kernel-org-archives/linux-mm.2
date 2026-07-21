Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21AC1C44520
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 00:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7F376B007B; Mon, 20 Jul 2026 20:56:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E57106B008A; Mon, 20 Jul 2026 20:56:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D96696B008C; Mon, 20 Jul 2026 20:56:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B29016B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:56:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2DE0B40295
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:56:40 +0000 (UTC)
X-FDA: 85010968560.16.F1E59A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9A46AA0010
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:56:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dZs8GWoQ;
	spf=pass (imf25.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784595398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rxLkcj4io5mat7iJ4TQ4Cf+pU0vkC9pH/Z7lbtKmZW8=;
	b=00VPcg8l6RqwyUI7m1tkMAxId3+IF7mL4bEA/eaOT00Ymlm2sld6OUexoPPZ+yOCTbioT0
	8xt7f+x3i4XH1qcn7CifXdQoo123928qtDgGVBPg5SMit2NgE2e2Zyc9lrJw4dx0ANh9ll
	nSUkhc5m/sppDRtR6psKF8eRTAIgJVc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dZs8GWoQ;
	spf=pass (imf25.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784595398;
	b=cCtVQgRX4JIIp9XG2s4XcHHc/AsEK/UiyATJCKyby6622hwLPgbtkhcnrCrbwxYPmDXqIW
	/DE+0vid/miwxPPzeerLoa44dZ+yJi/5Q/B2RYn2WvBKH9h6HoEb5x+CAH4r6/sXkarDES
	c4vQb3gLz/hA2fcY0OFzJStydsctBmc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0758760A7E;
	Tue, 21 Jul 2026 00:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6F61F00A3A;
	Tue, 21 Jul 2026 00:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784595397;
	bh=rxLkcj4io5mat7iJ4TQ4Cf+pU0vkC9pH/Z7lbtKmZW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dZs8GWoQlf9vtEVY9us8flp6pJcCYJnrB02p6Kp/zJ7g2OP0GUAVWE9uQ8m6pV7LS
	 RORNQw7+1et3BoW2yI7KeD7HpkbOAQh1Feh33fThSad8nZmdkoSwM0rCNyIBi8GAxq
	 0eNiquuMCW5k3b7q3tZqirWfgUeGNRpbtlB/Y+XzZST6DUcnBcQLolPfBNlNSYFH2S
	 UynVFYCMy9Uu6nB1uWhUi7bIqcYRQi8HfqgGjcCT5VxwXIdW/Vs9l2EVmyCgeOennE
	 nhlxib1k1LJmGxR/zMEObaLjLwUiHmTUhYmK4lmmdUeexoS9nRPJ4im3ObtNC3bame
	 jKnsfmLu9p5Wg==
From: Sasha Levin <sashal@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>,
	stable@vger.kernel.org,
	Yikai Zhao <yikai@z1k.dev>
Subject: Re: [PATCH] mm/damon/reclaim: fix typo in damon_reclaim_timer_fn()
Date: Mon, 20 Jul 2026 20:56:09 -0400
Message-ID: <20260720175500.0002-stable-reply@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260720094708.243937-1-aethernet65535@gmail.com>
References: <20260720094708.243937-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A46AA0010
X-Rspamd-Server: rspam01
X-Stat-Signature: cd3795k81gwg38kfahc6jmfnt16esao3
X-HE-Tag: 1784595398-370117
X-HE-Meta: U2FsdGVkX1+msIm+nLQiTJ3wNnXcTWRJFFtkdf1OB0TsFaZe5MUal7Ls7xIg/4SSA8Y/UYRhUMQyuMAWblTYb1yXSa9S+oDpcNg1nirZ/kHwnbGl/V+nXtL+Ku7P1hPyov/Wkq1IUrABs/az04cTORGIjBnSdRW74zR9Fa2Lcgtvq8GWum7iAaDhF0+Pt2v1uTrVk/42WEdB+n3l9Ff4myf2IAxKAxT2j1++eQTuWxzBA5Adns0tbyVI/VUIRT0WWPwKjMJHdkRA6DbESbsfE5lLoVlcbx7M7Z8VXU1/fckv9d/0h5YQ4EVo54UyhWXScdywvbSOmKaOSc0qH4L6yq908JrN97/liGAQnBF9ngiPcnMrZOQOtgxhpk3eA+TwpGehuOqURvTd6BDBSp3Vid0g1S/P/GESlzQi4Hp+X72NPq9LSAnLGvQRvXAsLTx5PL8sfRAW+0Ne+SRkuwAWHWN2mnPVgKrFwz7qGlJjXWVBniny1b08owt7EwBXJz15O79C4pENFdN8ygz26Eo+lT8BkzfuTtGpLfXx80GigtdReZAn4dDq4B+t52fjEqtPuRctUGCBfgLQ/VgaqghE03epobJ3mw0FNzSfIj4horMYwGwrqgrcFLCtmy4nRH71T3BvM9ETe21Aogdd38P3di+71aMDemZ63HQF9IA8RagpoTOifuZQSKezZuCrKSaukk/DyGuc4vO8y/mR/teiyJMnL99CuWPMJOZ56pn2okY3/nxaduirzMAzEPuRs9uvObG78dHbjclVREBUmVcg5No1D82vezZy2vMJ3OC0eV6GTS9chCuew+36ZoRBky0PAVoURIi9FP1Aum8owEUIBDcnfTVVlriMtDwsFuHCchjs/kmn+w8ud+D9FjlpKHIrXK8OAEIo6WO6LjQXvHd2Iui54jNZT3UdcwtvMc6UJ7vARkQRiAGKM1eFLucCEbeJkeTLEEIODcoZUwGNQRs
 P+DoKz6M
 OnBZn/PcIqLPPspQtt0TxVzbGli3EZEFyDprKArnxIAhoz7C+CDdDWuTraMn7sSRA9sbj27Ct5vaV+q8D+EzwTGZZQu7l/lB/hv4Nt+mGm3L4wRF0I1LWOEwngryMQbz03fPirywxc3+iv74Odxnv5Wakx1u6cq6MUBYTSs2190gA2HIb6gzoIuX0AhVSwU2VA2IPHM2EDOYwtHKz2iBnuu5WpLC04fkfd9vNIFktHtX924JSg0u9Y1tbYMuLSTZpx5X/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Commit 2f54908fae211 ("mm/damon/reclaim: detect and use fresh enabled
> and kdamond_pid values") introduced a typo in damon_reclaim_timer_fn()
> where '!=' was used instead of '==' (unlike damon_lru_sort_timer_fn()).

Queued for 6.1, thanks.

-- 
Thanks,
Sasha

