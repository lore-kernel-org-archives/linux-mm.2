Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0D85C624D6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:10:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D15C16B0092; Wed,  2 Sep 2026 10:10:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC66E6B0095; Wed,  2 Sep 2026 10:10:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB5836B0096; Wed,  2 Sep 2026 10:10:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 913796B0092
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:10:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 215A912022B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:10:11 +0000 (UTC)
X-FDA: 85169006622.03.DECDA2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 88761160014
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:10:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LAhB4egW;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788358209;
	b=Q4vYmeuAfHJSJl0L5ObBFn+eGHosww5hTKXL7dSQbqoNW3Y6n/5ODZlp7V5MZW4uGhOS+/
	7M6Y+8qPefkGGcPe9rAq35AN+MpsvZlXLQD3Equys4WlmUSEqlWeOnONBtmfeCNTP25Lfy
	cD7gK/InArTZeQjJF6Xm+itnMgVShB4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788358209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oihjsCCaHvHV7Ff/eBY5FAk8c0jiEhpNBZtjuRbpKTc=;
	b=KUWaui6WZqbr77TNFKflm5urMiKWCeRLwfRQ1Rp9ojj6aFnYSMSEpPUnwxPBj1vtViJNwh
	ZnF2MW3xS2erSKSn/5aFWcB/yyngm0ijA8nvIcfFgKN8JUm/qc7DBXIX2OFY0sy5pYXC+r
	2cugN/39HDZzmX37ND46l4cdmd/NBlk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LAhB4egW;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 955FB41232;
	Wed,  2 Sep 2026 14:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B551F000E9;
	Wed,  2 Sep 2026 14:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788358208;
	bh=oihjsCCaHvHV7Ff/eBY5FAk8c0jiEhpNBZtjuRbpKTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LAhB4egWDVKTZbo/WjNpEn1Ptf02oJWczukKKktsE1y2dTGpRlXs4Np28vHY1QNHI
	 K+S1q2j2GIlwhDnAUWDXKjFmrUYPPAh6o0YFjC+AzGuJfuOu4GS8oQibhtbpI6jLt6
	 ZIdMAkFVc8n8B9DeyY1F7iWv51s1kYW1bK8XERhVA3xLT8mKHeCz5pUP4qd8dPHN4p
	 YHIJG5tykKEbSVIdhLiEEHuEHgwROeUnDx31ozmjtbOdH4Mta57efgCv36ezivH5KX
	 p9pPj8kNZvyVDSwFrUkvSEAesHaRzBKqM6s8NoICC3VJaFxXypTOwM+6aAB6DIROZw
	 fYWRdlCPXI9Og==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2.1] mm/damon/core: fix false positive in damos_quota_is_full() when esz is zero
Date: Wed,  2 Sep 2026 07:10:00 -0700
Message-ID: <20260902141001.86733-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902084445.27170-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 88761160014
X-Stat-Signature: ot5ow6s4kzc6w1naqbw4n9q6xjej8ayf
X-HE-Tag: 1788358209-78679
X-HE-Meta: U2FsdGVkX19Bm4/1ZpBrFTRFH2g5lvUUG9yIqzjbAjf1yAYTqlNewmQUDY+RJwcOuAKfrKMIY2ByQtC+HfJyr5WC55wN3fGmtbIfjI0AG0AHQfbj1Nxb/ptWpwdunwedZobtJpp+cIOeEiqH/TLM3HFxubwGwLda/zjk0dKZZxRf0nTK9Jn3aR3Xs2vJ51zEkpwuQgzSJcE499Zk4IKf3Cs2wVcZTsTgueTQp4WqCY7OIiVnJSn6LqYXXtgCglpC+LPqZU2qjw/yaWD2Yt9uKNbCZgUiAzeAvca/GS9GvfYWjlAjwvd6VFoYTgh1OwGhrBD9WInZ+a9xvNzAX6bvb4RDLMvcne4VLk+QgjmBrsjVkH1ghDtti0b4qc23brmpLxHPP5WrBn0s9gDw/jTAtTaHHbSccw4Pm6GM5h26IlWkBAiCW2siVwiCs/oYsLA6JoqsRCBPS8kv6p9Mt6QN1CzU2e2n+TRPyofNM9qwOB7PDz0wFk2a1/MsjY6kyLYGz743HWqQFUOXRStchx6CZT0the7kU03DOHtukrX/o/FTZjDHiywY8FfeA1/TiV51CxewSy418GXE9U6cHFqpOypALkhp32F60cQC+L1smtKAUDZSmklLE43d5daWSsh5FHDxsh1STnuN9HDL/2nc0L5gJ74/hH0t97K+uUyqjZe5ZGPIs9w/t3dzPpcNembURQK4C9onMCIMsChO9NVZTbFKOgWh2rqzFXOWxpG0Wud3eoj3NLaLLpa38yqYqX8tER+d/jmW7Ugq9bbSiHIbbIaz3SmwsiWB6TflYV3Kwa1vCGILFUYS9lUEpjFpVAvaSX31LocMcdhtDNqSvdWgQkDw3aMQMZpd46H/ptat3CTZthpX1MMZ2Tza5WJUAywDJ7D4hTT98W4C+LotijVPloheo2U7aFVjiA9I4qKS3KA9btOrIN1aLKC7W2ZFv7BgvGfRVps6H+AAZtvo0Sx
 GE5cvnHI
 f5GdoFEf7nt97MkMX1fhyKTHMU6u0BNXHfx1EWpsAkeOt7ez0MaPHmEZGpLqXa4/viVbUif/j0rRpA0u5V61BRR6QKRLhwAH9CoTwOdEi+6OVuLF1qTeeD4UEslL59j1yk/FKppIVjvfTtxVmh7wZ49HZ6LCPwIT4F/j+rZfi2SIwVX3QTOgLJTpoRxGb6BoDETPC6rdAKVmWsYcNZwY0PuadlfJIpdd7FWBTUaixpAtonUDmLt5t+3MnMw94GdTfxQ5eo3DI0OdjKIM8obHLLKtZ8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  2 Sep 2026 16:44:45 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> When setting goal_tuner to 'temporal', if the goal is achieved,
> quota->esz_bp will be set to zero.  In this case, damos_quota_is_full()
> will always return true, even if no regions have been tried to apply at
> all.  This causes qt_exceeds to increase unexpectedly.

To me, this looks logically correct.  Could this cause any user issue?


Thanks,
SJ

[...]

