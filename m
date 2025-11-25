Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 049D0D0EE0D
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 17:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ED326B0096; Tue, 25 Nov 2025 12:42:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39E136B00A5; Tue, 25 Nov 2025 12:42:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B3C26B00A6; Tue, 25 Nov 2025 12:42:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 18BF06B0096
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 12:42:26 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB2531304D0
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 17:42:25 +0000 (UTC)
X-FDA: 84149848650.12.C9A9AF3
Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	by imf06.hostedemail.com (Postfix) with ESMTP id D018918000B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 17:42:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=wF4QPV5d;
	spf=pass (imf06.hostedemail.com: domain of miquel.raynal@bootlin.com designates 185.246.84.56 as permitted sender) smtp.mailfrom=miquel.raynal@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764092544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ysGRqycURmr/iQdWYzfFaT6MnWtMI8XUPzwUEMUZQjI=;
	b=w2e+gbPTol5If8PPfr9+BZkjTYnGgtcYoexBXwAdRQuOfZyEMRkoRU0LaB+hcxcnFRWyvP
	lr/xlf2Y5Q5e0YqP1dGb21kwht8rvCtmYe04geEfIWhwbrAI2kUf24dKMxtC8AdXh9StmR
	G2UUMwllpeNCwJb8OFfNbLCpu2dWw90=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764092544; a=rsa-sha256;
	cv=none;
	b=qYDPhDXFsZTw0zmooSjVLDwTOnzE1k9BhEvZopypvwZSFO+h3RBDZJFopxPYzX40fzE5ri
	TNs0b0/ECcrQAYPnT6CsxSbbELMjioIQi9X1LDinDyHh/2S48NajqIBxh7AGvCvkBFJYdf
	7t0rv6Q9rs6bsQWR8km/g1qAyG0YAjI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=wF4QPV5d;
	spf=pass (imf06.hostedemail.com: domain of miquel.raynal@bootlin.com designates 185.246.84.56 as permitted sender) smtp.mailfrom=miquel.raynal@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id D17111A1D33
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 17:42:21 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 98E5B606A1;
	Tue, 25 Nov 2025 17:42:21 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 25DE4102F0891;
	Tue, 25 Nov 2025 18:42:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1764092541; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=ysGRqycURmr/iQdWYzfFaT6MnWtMI8XUPzwUEMUZQjI=;
	b=wF4QPV5dCMiOJwq2UP5afRPlO3tL3q9ojLBJ6Q0dmEIj/h6QZ4mB4ixZOJmdZkmEDs0JQI
	dNAQPmWbBmh99dsa8Pd4HHaQmn4pb6JbbF2Dxdqz53CqJdtgIsr91yLbliSNAM6S7YgQvH
	w2Mkk1HQK2EZGRQtNPD4hWF9XPHNNpCmPmTZaljjobGadKbol8FAD0ECDV7KyFgViFCskL
	FDVr8qRQvJWBXoq7YkVMGrlUz7RaRB7Ds0nDBben5NLtGhIMWC4OD/UY6UBoX6W/WgaViT
	pI5fF3eAz6cuuwnNcaXJCe4SRJXD0i2TVYuT4VOEQa8OIqpYUTJYrtZemtO7nQ==
From: Miquel Raynal <miquel.raynal@bootlin.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: linux-mtd@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mailmap: update Pratyush Yadav's email address
In-Reply-To: <20251125173151.29430-1-pratyush@kernel.org> (Pratyush Yadav's
	message of "Tue, 25 Nov 2025 18:31:49 +0100")
References: <20251125173151.29430-1-pratyush@kernel.org>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Tue, 25 Nov 2025 18:42:19 +0100
Message-ID: <877bveuhz8.fsf@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Last-TLS-Session-Version: TLSv1.3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D018918000B
X-Stat-Signature: j7f1hk4bks8ekjejery4gpmb7kdi8e4d
X-HE-Tag: 1764092543-282333
X-HE-Meta: U2FsdGVkX18EsSLdZsp0ESiERt8/oX3i0Hci25w0cwev8NICiCTxkkZYE60gtY2sS8gqD6Kps11xKZEevaEfOLQzEYicTlPAMDWPAz2XnD1DIw567xvcuOaB7dci63VH5G52SkJY2jq5tDlJPbKehCCP8T+Hnp+fllBrQ/Vn4Wm21SyEaHSBQV8kKnhS+cE4Z5PqyFLcl4AKfjiIqOML5jBblx5CZzMisFVVudF+2KQY0ZU5p+3TdMsbC7/CAf3WHH4jJGq4qLMn43ifEkVPoDsEgKhLSYG1bLn6LNk2Dx/de+Hyj0lZ6wDRMdWfRCkbFDl54wwWBaljoM6lz/J+uwfkPcYyP4dMB7SWZ1fK6oAAD4kQWyVHxrPalwXNDfZrEVZFailbLwvwzgD0UgkWhuwiCcdqdHPYICLZTbz5QeT/DbbepO4Wx2Abghvnp2scXX9M56I6BRXEWUh72aOGf/yanbyM27EaDdYpZvpNlmQyoJXu8pgUrL0Ejjk4P2kfVHXRZdiiWw0IKwzMtOU4WuarrPSIensO9tZnLXNhK948JK+xZNbSwvaEO6P+u2YhbUzheNhFnwEfGk8nVTzcXoyqioo6Oh6c/9hDW8ynXpEq4kSekJQCgu6mZxwAzinEOSKMpn92xoDkhZAghLtvk7qoOCeHezcUzraPUMrIcSkCczBwWVO49wBVxovxD++jy6kYVd54ds6ohKKPP9TA/2ZfDhpwqaqyguywlVALp42GjW0R+z8hdJn8DjBfEVgwtOMoiYPtUbemkhvWptitWrvGJBY/4b2OXrNoSOROjg04MJbfnP7Ajlo4ymLVK+VjRpkxYasz/H9L/+lOp6wZFYRGQ8fIXIXndPych/7Edp/EbeUPN2dFwdsaJ6MhrFMQPV+AWOsv8vvXcXhoBaBMu2FgvP2lnoevyxwzgoPpzq+hvJHWsyAqJizFJQxlSbZpnc8OD/oqRxc8Jo+s3fP
 AZwLCs+x
 32tclaef/BvbwcRrqg911lmuhGP/xqY5gujug
X-Bogosity: Ham, tests=bogofilter, spamicity=0.112726, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Pratyush,

On 25/11/2025 at 18:31:49 +01, Pratyush Yadav <pratyush@kernel.org> wrote:

> I will stop having access to my Amazon email soon. Map it to my kernel
> email.
>
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
> ---
>
> Notes:
>     Sending this patch to linux-mtd@ and linux-mm@ since those two are the
>     lists I am most active on.
>     
>     I plan to take this patch through my SPI NOR tree [0]. Miquel, let me
>     know if you have any concerns with that.

No problem. Let it be part of the next MR.

