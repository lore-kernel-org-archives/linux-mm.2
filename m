Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C630E606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 14:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WNWQtX+P
Received: by kanga.kvack.org (Postfix)
	id CFFD46B05B5; Mon, 26 Oct 2026 10:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD72E6B05B6; Mon, 26 Oct 2026 10:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BED116B05B7; Mon, 26 Oct 2026 10:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C3F56B05B5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:55:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2767F140766
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:55:27 +0000 (UTC)
X-FDA: 85365075894.06.D42F2F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6CE6D40005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:55:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WNWQtX+P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793026525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xDYkR81v1FXKX7hQ987wVCMZMH9j6xoRUxeWj33C+RE=;
	b=VTkWeBM1aQMqv8/AONLwNhIPpDqfSulbux9zJ0eqI9/dYM71kDP1D7drBo66U0dTQo35/M
	s9CUi37Dq22V1yKDSSpP7x130P9L/bubl0VT7YMTGgFy2byJOrsufsvhEw9ZX+AebmWSNl
	kpGFuCNJ2KNUaHwiaFqTmddV6lkqaUM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WNWQtX+P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793026525;
	b=zJD9ASqcMVXzhdfXgM7tNaldOVzLLnCQ9HJQygo3u7DwVB+wMGJQCNdJkRbFo5wTD2WDlt
	smG0JyAmZ7qmqwxJx4V6Bo1i6DNZhGKmHTZQHGPPMJK+7VKfh2VgwfUbCL1iubpv7VOD8a
	Ekvk7yxiSNHqdyA1X3a80YdmwytQKb8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 99FBA4220A;
	Mon, 26 Oct 2026 14:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF951F01825;
	Mon, 26 Oct 2026 14:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793026524;
	bh=xDYkR81v1FXKX7hQ987wVCMZMH9j6xoRUxeWj33C+RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WNWQtX+PN5J8vdWyESKw+fllDOWalQg1EdkuFJCADxw3GPaO47QNuFMMFyz4U0wxl
	 xj9tXXjXpBU2aA438T5CGyQptalK9bbQWLwkP/3z6fDvh0JLi98k3K0enW3ro8N2WY
	 4I+gk3AnUl1ObIIIAm+xJylZyCmiB22BiU73BN1r4A0qr1uRUSz+EmicEe6H5jDYpR
	 3UUM9RGJiNdMTWvzWj8UUPgcFPGO0Kv2vT6ll7KxDKCfXDp0r5AWh25M7CypjnHY0k
	 udJ6xpCapuv4yOfN47wbdC16tD5+/I/gKp+Ca7Mgl6ajYp8KDG0EMc4SALpzrV9H8V
	 eOtyCS1rYVxIQ==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Manuel Ebner <manuelebnerli@mailbox.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] Docs/mm/damon/api: fix verb form
Date: Mon, 26 Oct 2026 07:55:16 -0700
Message-ID: <20261026145517.150888-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179301327249.2.1896995843401183120.damon-docs-grammar-6@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6CE6D40005
X-Stat-Signature: 1y7mgziieobnx51edy8j3rhjko3g9r36
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793026525-732486
X-HE-Meta: U2FsdGVkX1/PJO1SxM0um0rirGZ3760EyYjYV0o5/LoFTfS44ec5wLi2pqePxc61cF00wtwiKsFlSacTna7O/scQusoMHwlfZWujBW1NltbRCQ9bd5ppV6wxKSeDvh7j7ahv+/mxKKarQoqa1ZmQCJ7aPHi0w0RvKpQj94/cTq+Nue7kPI1VX6IVcRRhlSferjuUG+4jX7Bsoxx5ix/uN141qc1Z6H642rs8eZ1dZm+7Pv0WsdXQPNZyqDiUeLFMNg68ujnB5kXNAeawkVCgHz0yqBxQOodRq+cyEkEbaq4lO3qIIPajxEUXXC/1ALH493NmWICnueLo8dk3tZJD5EatvtnPPVipZjkzVaKRfczA/YC7dWW/4tXrujox06OwL10uKHohy0IAz6R/UP6Jvcb4995AVSHnNEir6WAAI8BFmLST2QX6fmsBP05Wdg9U4IMrLm+onSaHWJ9K0d5hbyvvO/75Cjn0HlwfyxIhjUe6TjvAH7pQJxyzFbDgX+7o0Z5iLo9pQp7cdfC+X5NLjQ41RIMCCvlJWlwIIG+OPECHJFmvHV6PhiAwWSF0gfBdd5DJKhZepLso+AfnytJDRMqeVClYCP3OlGX2L9eJwREmREt/wqse0Ti+XDWcwihgy8rwZ1vWNsLx4FIJO2dwizr0e6ytHR048KgNI9eFOfeHOXtPD8lIBR3GLnFK+EmnYMPx+lk1O/Im8oKNhkT+0O6uwZJyARicAfKWLvOHTyeSpJZ5lUOgj8GPaJk594go7NzTK58guz4VAT5JWuEPQ7VQeqlit+Snh4bz3mNhmA0mtcEA4WiN+hEeSIQsrKAul2suxj1cFVOp+dAHg7PxURAT1lclnNB0OCfdLL/Ok2pt1EDyn+b7hNrZmTF8VLB+rcgD78DqTYVIZjdqG79CfpAuiu/aFuaINo1EJFgQQcV3P7Qg0JbJSkdwY9MkoepOcTHKaFgUWGQDGce5oHk
 0cRhrz19
 pdUhcqyopTVMXs0Z2S9fsSrwXLPE+qsD9bSsCSvn+PPS1qu0/GkdNjJCIKznyYTl0cpjOQO/qGzbWBHOGaps2kQ6ZSQsJZn6irCm3lxlT8Wr2hdatHkv85Y3R9aZCFxuNEQ61fxOUZ2N2ebtafg+d/yd4rLEyhRRtgiuid422MfXON5rsb980rtqJVhBrP08Ep9vMVGCEmy6BxCeDBW9lfiIZubXA8kfBHbYQ0dUqylV18bP2VbHhUSASXrUf29UCQYEwYl8qOau9veU0ft8WxyM4Iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 26 Oct 2026 22:14:38 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> It should be "All you need to do is include", not "including".
> 
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

