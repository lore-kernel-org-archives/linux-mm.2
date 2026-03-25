Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54FFF109E530
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 23:59:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B868D6B0089; Wed, 25 Mar 2026 19:59:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B37526B008C; Wed, 25 Mar 2026 19:59:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4D7C6B0092; Wed, 25 Mar 2026 19:59:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 96CE86B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:59:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 234F0160AE4
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:59:34 +0000 (UTC)
X-FDA: 84586255068.04.AF3B947
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7C8A18000F
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:59:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NfI7TnYV;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774483172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t3hyIQXguCalIbD10RUToHhOERJxGEvCTtNShxMC57k=;
	b=AwNcUPIa4wqpOp4m2iFp70p3RmctTuMX1khhYsfS68oTh/OHQ2TjrCbq21dfRne6y+3Jnr
	vGPepb0+93e/ygyG0ibFiOKGQM9sel1rtkbwb59EaX2leu4y3gAXFE92hJEcLLEgCKcpCD
	zxM3Hnhgu+S/3cvXshKtMSZ1Fs7lwXU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774483172; a=rsa-sha256;
	cv=none;
	b=kf0eAIraIAXnpi47VQGl6mF3tBD18WFqRlcOu6+YWiqDtyBipXHPIO7m35lvq34C+5nCvU
	W+EYpxdw8smWfturZZis02a1ZKvoCaGRo9QDwV6eG3jrgJdbrnqJxUOw+/ebb3dWGx/Hqf
	SzXsK+QLnjUkgMMlyoEM9/azS+nJkng=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NfI7TnYV;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E2BC460053;
	Wed, 25 Mar 2026 23:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C412C4CEF7;
	Wed, 25 Mar 2026 23:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774483171;
	bh=Ia+YtXVLsyftT2gQjhtcxVdiFisfZe6MrM3hQLVJS/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NfI7TnYVxBB8YFjdv6ubD4x/YqmK9rNwmFtuovjFyEFXhdVvFVcgXYhB7mengXFVS
	 CoAnoRdKS75d0n8EMgmV9G/Mnh2KMiCk399SvwoxAkz5DqqB/nxh5AGp+mMQaQMbBR
	 DYUG+YCkz4hjL+X82HFJFBx5NrfU7ypDn/O+cff1ElCSSTwWGGD5x1bgyn0aCB9e+3
	 KcXQ6yPCk8+b1PKNsPvkIcmRV43Uhwo416oSo2xlLnwrxnBGon7gbZZKLOC3eWXhkE
	 HYNf0reHugTzcpz4IroYwtesCkccT6tEqKKLYnTw2AiAL183vrcBbzflrw+gmaVs5L
	 nS7dZk90Ic8jA==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: (sashiko status) [PATCH] mm/damon/core: deduplicate core and ops filter commit functions
Date: Wed, 25 Mar 2026 16:59:28 -0700
Message-ID: <20260325235928.76076-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260325204250.254364-1-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 38ucuupu99yrigu5rdm9q3kxiqm3tamr
X-Rspamd-Queue-Id: 7C8A18000F
X-Rspam-User: 
X-HE-Tag: 1774483172-143987
X-HE-Meta: U2FsdGVkX1/m/Uh52rTlPi2Y3KHG3h6qBkBvM78M5435dHz/KMkfOyCpHhArlgviDydpbcsJW5uhM5Fw2VroBNkSpArAUMCYAasBIm8K+2jU8T7uhmtmIe65EPApLJza/VxHgRauFgaV4tzMp7gGQoq9YrfDAg5F/Kg9lozsLUdltlc6g5vAfduwKOefXUeF8Vq2MUUJc22VdLb/5v+TIEY1PkiP+c7xCnDl5JzJ4t7YtUy3OcLaEZW20kGYk2kkmEtwQTLVumgCrRa9+Fh2v233vXfp2TxK2Lfi2ZSa5A283fUigS8Vw76LwFrekGqIGem3/e9ukCxwIEYB12A70XhlmJzBLagDABaZvvym/EMwcM9F9hAa60eVEiBhnh7ItcAqQIcoAOHlccJM/jCTNfHjIoQ8LeRARtoUH5RZ0nYePjsKViUbBnLov5wTLLyn0DZdUUmLdoVYI5mAuyMtXsCbDblmE2sYQRISiirUE7lwGsyNP/+lwAVKceHsShoTuGhz7f6VaZVuj/SBn/vqdt2zBYLpdXhg3msFrredeuyPCP3/1yj68iJ1VsKSP+DiNGB2DjmYLmqaFJQAJ25y1G6M5H1JsgCWbV6MC7goB0u5c6m080WajT4WQdtTk3f2jG1LZjLF+9Gtg+xAByMZYJrinSoJakHtM5VtxdOm+3ca5IqaM+/QLSkJhUcC9jVL5xTb6gYRKsAUpKb9rCc3xM24bYlYhQj29twKE4uFBqX5m53adTei2E9JvWY7elP2genz3r5p3TdZilMyzqHlbRxKD/VLfO3DAgVLIRHANe/IH4/W/ZjFdIFLqtMrJZhtGtEuqfEqEkkyU36HLVzI0+3T5XbsCGqKi2cw9Hev2rc4xJLnCN63DXyAS1jESuVvxvl00KGfyDFBhjjEk5cGP2UWqgFDMJEwogQKZ8VpVNyM/CjeO5dB9Fg/xoY8d+ssyb7qw08fu9e9ZytrD07
 ilrFJZVa
 lec+EDYzUgvqpKzZ6+lJ+/XVflRsSe75EpRRxJx2LmD41o5BXfWbaR6Y8FYnZ43ZRNHeG9qo41y81oXhgITiVuGFilvI3EBgzVMLCmEDldsJvNPHcbfJZlJf8hy5stvXvbpEgBeBqDD8+mxvoYoSQ+3lYhbC+yz3HOBAyAN65TL6wLAsDKXzGS/x6wbb5iZ3RT1E+LvAg37eTHLX8MbKIFvJVlCP+rjvHOhzZzXZRchOUc1s5nLwn+/GKJMnk9QNua2vxDe6399J1R9UjQ8tm0GRF46QgTWZqTw2rqGVgVv86RtrtenFywZ5yAllIBwoIWp+AGOO50rWlixNBqttdcYRwh02sFdeasVwU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko.dev review status for this thread.

# review url: https://sashiko.dev/#/patchset/20260325204250.254364-1-objecting@objecting.org

- [PATCH] mm/damon/core: deduplicate core and ops filter commit functions
  - status: Reviewed
  - review: No issues found.

# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --thread_status --for_forwarding \
#             20260325204250.254364-1-objecting@objecting.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

