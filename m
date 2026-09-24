Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35072C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:59:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FB066B00AE; Thu, 24 Sep 2026 03:59:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2866B00B0; Thu, 24 Sep 2026 03:59:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40FFA6B00B1; Thu, 24 Sep 2026 03:59:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DC646B00AE
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:59:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B62468025C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:59:31 +0000 (UTC)
X-FDA: 85247906142.17.B779B62
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 194201C0005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:59:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ITZboI8t;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790236770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=998uBd1XYYEP0ytxfXGnKoiJo1y3bsTMZfIe9aU14nE=;
	b=ZWlTl6WJ12FGaAQNjtl5kneH+l5+RL8FclTEA8UQxtq9xucfP2k+vAm/goY9RFanposIfZ
	DaenxTCOHb/BoE2oOMJdZ5G4jq11iUKIGmOFX8FPYenJt4DvVaFaj4eN5YJa4xmTJElmv5
	vgDN17krJpcbdKCFzbueJzFwvCgFLYI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ITZboI8t;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790236770;
	b=1tvqSoxWArkoH8B3TUjsW4VtbTE0WlWMPTxk0h4DzWV9G0KqZexKp0h/5QojETTxJeLSwI
	bDHlx8K3gsLVSyVeeiGX+/1N98vdl1o8pJsuaExhZ9IpLr8wSFZcT5VwX761g/6UvAUtW1
	rSdJCTOHZY2hJ1BKm32vhDDxqraGrhA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E3BC60211;
	Thu, 24 Sep 2026 07:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932251F000FF;
	Thu, 24 Sep 2026 07:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790236769;
	bh=998uBd1XYYEP0ytxfXGnKoiJo1y3bsTMZfIe9aU14nE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ITZboI8t4J2shJ445/0XNbKX8PK1mwZQjW709wnw7y1/PamU6i5luxP0tFN052Igc
	 jx/7Tac+V5gabRA6lkC5cYq5rAuliwCh9Mse7KUAmEHloPR9DUPy1YX7XSiS0GeDdD
	 Ik6SyfyeOTCLr/JI0W/ln7MWCurQWTEoy8zTecf/WwC1Tj5nVK6XOPVTzkD+nh4csl
	 Si+gg25/dtD9ZBPUSAkbCIPzUqxySnc0SjWfBSO+eLbV4cmnPApfA72M8oiCRniFLv
	 0lQawIPR9Gn1lhizwztBCOUvsVYZy/B2kuLYpQRVWPUP7XHP2gYbobtksqRGuLutx7
	 Y9yrbMaX88UhQ==
From: Mike Rapoport <rppt@kernel.org>
To: Tianyi Chen <hi@tychen.cc>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260923023126.1910311-1-hi@tychen.cc>
References: <20260923023126.1910311-1-hi@tychen.cc>
Subject: Re: [PATCH v2 0/4] memblock tests: fix BUILD=32 address
 conversions and warnings
Message-Id: <179023665438.508753.12271049963919722675.b4-ty@b4>
Date: Thu, 24 Sep 2026 10:57:34 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 194201C0005
X-Stat-Signature: dpgyhrpff6ak5nqs3y3pdyohg1xxs7ap
X-Rspam-User: 
X-HE-Tag: 1790236769-9533
X-HE-Meta: U2FsdGVkX185beCWcKCeXoY5deou2sA2xJJUS8EWzZM3lo5qYFCNZifHT9v47ESxFohnbyesK0w2p3vlb6H6ce4/PNI7KguBGqYP4F0PDSufBv54H+oEfuBWUqKSoMY1hMyuoO2gcS5FH5U2WK1Jjgzmymj3iSVgHD8ekFNsD1IirXo7jylVXtt7ji6V4vVQHzlTixrdW/Sfn7ilUOaVajsHczV90PiDyzZkhwK5v9bGx8Ca1pJhLUOl5LD0c23b2YNlL9cGk317pN+WG0E2UDPqcYG6305/g828U+GwJj+xA/taxelaJuxkwOopLae+yd4BWQYaLJkgYczfP0GWTcHgDyUTQLS1xdy02x+ZMEKrNS929SJjZtWuWazjpTmB+iRuVtMtNqT1ZL40wcdlOHh6G1YohL5D+nanhK+vnfb4TYf7r6J1xL/vwhf5QQIk8wuj1J/vNyDV/O8OzevHaw5ZyoKKIKOdLFFH8ZhSnHTq8z+HL2mI6LHS5Z1dxA5INoVUO9BgBTp0pF9v0ErwxL8IgIywP1IWbTNVaT/j7B/5Vq5HrFljIgOTHAew5M5XWQ5Jge5lJF9ONUqHtkAO9/8ohuyEKA3Ajsg0VZtq4FGefdrhKvzNkVaHM8IraoFEmM0uJx5tIgizjWyp8xJXymkod363+0ebS5/qEweRCxhJltyBca031Cl5I556fuqnJpfEPeYOEuW48FM+SmbVmgp9xWmW5spXdekPFcw7xiHDxvg8kfTxTi4MCId9aDryQR/KZ4n2o5OkR1qbr0OX7meQ0vmNnuAiv+nqJCfz+fqJUYU8i6Xr8jtDWIFusPbkSegTaIZX16P+BYjA/gQbJTSqRWwlh3JGlDNXQo1nyEVmNgpM9kcSfQM2wc9OWrPY3p67gK903FeJTW7sIVYYN7Kz8i4qGDDkAarCDY5B+3I+A7bNAMMFr5gLliNhl1lrByJ6qCs0UZQcMBHkbUc
 9Dp5So17
 dAcaKUg2qvjecMzkZrMmxxv1b3DvmAhW/gQ2mrKIukUWRU11dGTd//25svx5KrZVJY/miPcDpeqAj6i3EI/GQ/SvLloLnRknyTuYEg3EZSDTE9yPwLfZqlhOuJ4a/b7ykLqUrxBHbYHWJ7ZHdFT5/UQhCwEMjk+q0nv9ZrUtvDT1lqP0dmOe//BYR+4tFRC51B/3PpypecBGMCG/aGTT8sPlL5mfJ/CaUdno8mgXPsFLbllY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 23 Sep 2026 11:31:22 +0900, Tianyi Chen wrote:
> memblock tests: fix BUILD=32 address conversions and warnings
> 
> Fix the BUILD=32 physical-address truncation and sign-extension failures,
> and address the remaining GCC warnings reported during review.
> 
> Changes in v2:
> - Use memblock_phys_free() for all synthetic physical ranges in the basic
>   API tests, not only the maximum-address check.
> - Keep the dummy-memory address conversion fix unchanged.
> - Use __pa() in tools virt_to_phys() to avoid a pointer-size warning and
>   sign extension of 32-bit pointers with their top bit set.
> - Initialize end_rgn to avoid GCC's maybe-uninitialized warning.
> 
> [...]

Applied to for-next branch of memblock.git tree, thanks!

[1/4] memblock tests: use physical addresses for region removal
      commit: 9357596afac61154e7f54048c0add9f1293b9eba
[2/4] memblock tests: zero-extend simulated memory addresses
      commit: 6957416ae43de1830174f527b5b8cf737401a8dd
[3/4] tools: use __pa() in virt_to_phys()
      commit: a10f3a08d248fcb3006f587faf42437837fd12c6
[4/4] memblock: initialize the region merge end index
      commit: ba94f68b754985f77c3f6d3354df74952a1e0752

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: for-next

--
Sincerely yours,
Mike.



