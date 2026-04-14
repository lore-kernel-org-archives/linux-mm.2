Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F5FCED7B96
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 09:35:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E64696B0088; Tue, 14 Apr 2026 05:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3C766B008A; Tue, 14 Apr 2026 05:35:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D522C6B0092; Tue, 14 Apr 2026 05:35:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5B916B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:35:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E9EF8BBB8
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:35:51 +0000 (UTC)
X-FDA: 84656654502.17.FFC2347
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id D13A040010
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:35:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A+opRLf2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776159349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AvSJqCzeVrzikF2W/HpNGbVwuNj2UZTNKKghqNKV3xI=;
	b=krflrM0oNbrHivjko24Yu/sSfa0PJqrMiU4poS1bMI51EGutqFJyWBsgkcg4O1SEzhUNuO
	BdbwQUzNauYgJtL7dlVnXNGhiyTAx0RiOlpOW98C2fEq42EZXpCQcNFmWQXKcNYsrU+c+G
	z9je9dIZzFa/aZOGeJOsnYdd3zJcI2s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776159349; a=rsa-sha256;
	cv=none;
	b=FsoPSoadOHT9AtbI0eA3zPhjg3O5+yqMmY8hX4JQiR3svzOV42xsNhZAnUc8dzvTLN9B11
	XIUCuplvnvKSjocZ84XqYbsfanXCmTibplFmq//9qXTnpqzwRTS6J3qD503XTVe2ok+Equ
	cHhS7zPlJRcN4R8PIJ5JFUv0JX2Qpc0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A+opRLf2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 19FFA6011F;
	Tue, 14 Apr 2026 09:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B375C19425;
	Tue, 14 Apr 2026 09:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776159348;
	bh=GQcAgbM3J373532SPtusBvcSD/X5zsXVrZEqHzWWWx4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=A+opRLf2qNjapfjlaE3JjURGvDtRYL7JDCQXA6w/F9BkkCWGcsbOC0e6yRwbsvpgD
	 WncjQxDTDm2+L7JapQIFXYejhKLhlzgbbzYDu3PwnWbTJU4obrByJ3A0tXV5bXpRfu
	 Fb7h4kBw5/gloA6NR/5yGa6Ya7wFnIgbmtGeEdjmw8tiJAcqJk1Fc93yii2rUII/fW
	 6S5yt77W64d7IZzQp7F+h+DwWNGsLiAXdXMUpYbcSnadxGLxyyHkK51waKACQy8WTg
	 GNaFeNFD+G/TLQckxZeaC1AmPUd1baRi81esUDpLokE84Q5GjZVTw8e4SPsVciR3Bv
	 FnFIjjdTwcKGg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org,  akpm@linux-foundation.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  dmatlack@google.com,  pratyush@kernel.org,
  skhawaja@google.com
Subject: Re: [PATCH v4 11/11] liveupdate: fix return value on session
 allocation failure
In-Reply-To: <20260413185127.128180-12-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Mon, 13 Apr 2026 18:51:27 +0000")
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
	<20260413185127.128180-12-pasha.tatashin@soleen.com>
Date: Tue, 14 Apr 2026 09:35:45 +0000
Message-ID: <2vxzmrz5995a.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: D13A040010
X-Stat-Signature: s5o778ur6wguhg4dt9sfyu44frymzxgi
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776159349-467974
X-HE-Meta: U2FsdGVkX19MMkpKoXmxu/uUWHyclYg1VgfXH963LfU+pO+GL8zjdjgjIbxjMsCyZf6qm/Vx3ghzPLetIGh2EtPmmCv53KtiSlfQ2B9pZhYBAxIplsze4bIR4FCguDpdHapw23LJf/g/HW7N1uNWOa2NVWx54fW3MM7rirXvgaG7ZdJlFRYvu7dgJA5ENcsrsJpOqsIqgjb6b4fNwF1UiRwuxgnQs1p4umfhJ+8e9RmcnKNxtjFOyT3KxAhEtClqyWdOwBz0WDJB1BkLjBuPoSrhUfxjQ8uqdt/oe1bXg+iN3lIbp+jfNBrGNMhaRQUDlvm0mee7gN4UU1UBda5O7o5tPY92iC+E88n6pdmNF+0OtG1BlGWr2osTbRscwzzg5SJL1jajvXDFXQ/DEvd3z4XCM4vpNBSJ30b3L2ByBABklSoApoWX0svOhkk53C0GTE5FUlJ85BGdpKaR1y1KPDKKM06CLYG3qirCS36giBzruz/JzR9xMnozCUcVaUbEHJuCqago6gJXjNxWBzYnVmTWS8ojBPcpgjE8RsUVVudy2yMoi34T8hhZS546MGJOtZHaGEk29D+6ID5RlnYIdjrjEzApf9vsvRgtGLwllYwYtGWXCJky615tNIsHu+wSehOFWwa7wcjTnNKg7pwvMoDaYCZSLsVrP6wDIaQvmHOfN8HUCc7HV1PVldjl4sVV2M6K0z+zkQwOAg6vsbRNpMvSGSpyYDfZPMB3n/dl5aqv1Zha96bjBEWpSqkBdve6e4HZt8AP+Ml0mwYqoQba+GS9D8+SmEbYmF2sQLjeJXfobcrHXfsBkZICMBVOY53aIX6ZX1Kwfr+8EmiZKgwI0HllF4PPLqEwLzwVLxQ/ttfbkNE3Rj/iJzhm4m9zujTZ22fV+4Njc1ZSCKlbBnWzukdcwDrAJRld4OaRHT121b858D6YyuwJMKJhcHJcJwM9xIrNsKcD/Tgbdm4QYMQ
 DLrOr0SW
 XPQGz2eNO8XhLBcr8ytj6D9YF3clBt3p3gyNs0OA/Pq//1b8Adgx/XzOFIns1aGIYpyUj5KGLVMJZ/NnqZ2udFQ1iEn5+FeOqaHX1rAJI5tFcgpamv0tHalcTBndEz8QVIINoufKUFn4KPye8QA67Sbw3wUXMBtxQSBeL2ULWSPxI6qCGlKUrxQRQ539WGbMPKj8jwA5iKk+uxeJkx+HM/55sBqBTfO4qBPMZSvms+FzQYGkQlMivd9Ankg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13 2026, Pasha Tatashin wrote:

> When session allocation fails during deserialization, the global 'err'
> variable was not updated before returning. This caused subsequent calls
> to luo_session_deserialize() to incorrectly report success.
>
> Ensure 'err' is set to the error code from PTR_ERR(session). This
> ensures that an error is correctly returned to userspace when it
> attempts to open /dev/liveupdate in the new kernel if deserialization
> failed.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

