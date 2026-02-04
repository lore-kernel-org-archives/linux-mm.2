Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E235E8B386
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 01:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C1F76B0005; Tue,  3 Feb 2026 20:41:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 745C46B0088; Tue,  3 Feb 2026 20:41:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6522E6B0092; Tue,  3 Feb 2026 20:41:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E84D6B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 20:41:35 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 06EF1D5499
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 01:41:35 +0000 (UTC)
X-FDA: 84405072150.18.483F180
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5C1564000E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 01:41:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IJUu4vBu;
	spf=pass (imf01.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770169293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AON1FH9vV6mp5RGbv5FqV9U7t8Xesnw0qtmZBfwIB3o=;
	b=8jTQEyTmy3DFCm3nKWFVn2MZIPUt+JCgPQmIvuY8Y7i3iAFGaWzlGy+0aFqS8bQR2Close
	V31xmSz0+OsNov8ibW/IM969Tsa/LtRfVV9Vwvcb4Pj6Id+SEobngPI+0IqKSVaRLEelKb
	QOYlmMpjI5ZeDJ7sU4ExQV7OZ6V3UQk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IJUu4vBu;
	spf=pass (imf01.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770169293; a=rsa-sha256;
	cv=none;
	b=5CrivJGqXXSYZVUE6JNclteP2Aw6YDu60l8rke5HIkIO76UYAyMmtZ5j9i7LnM0DX59urp
	uvDNQFhmfHs/dkuixiAQe0LD4cXGIjsatXBQL8JH8yzD5HuuEJFaemtAhhOrsDOcWTUIIP
	xEEa+N4T8EU7GHqL8OTbpySQxymAeas=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E50860121;
	Wed,  4 Feb 2026 01:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420C4C116D0;
	Wed,  4 Feb 2026 01:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770169292;
	bh=Vq0qw7bLPYWCOFbIzYjqBxH1/TOLg0DR7mZvYyLwB/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJUu4vBuMrdZpNxx1HJlsQR51rsL2KXVtHYLPZAyCD0tPQmNjat2JnFPyew8Oosny
	 maozE1GWiQws8YXsnvIutk7tI/YWoqIlJRUCdZ4WBpYr7Xukh/++GItPk9aIau23lF
	 U/XN+VN8l5dN7F2bPDvjY7M6mGkjec4wKHIsvEjKH7FyNAMxxrMmXzZyijvKHcK1Yc
	 y6JIk35Q890eq1oU2ATT2Z9rGYYdK1K/w8laGBqrXCKZxJjn+o0SyMacei8HefcJ9j
	 auq5iXHkf2icyYR8rxEIW0VHeHdDfj78cFWyUcaHlLMWPHYWcB1EPhfOi0KzJFYJvO
	 S5N63Mp2bRQUQ==
From: Kees Cook <kees@kernel.org>
To: Titouan Ameline de Cadeville <titouan.ameline@gmail.com>
Cc: Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/tests: exec: drop duplicate bprm_stack_limits test vectors
Date: Tue,  3 Feb 2026 17:41:29 -0800
Message-Id: <177016928709.1724030.15636972485494972639.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260203175950.43710-1-titouan.ameline@gmail.com>
References: <20260203175950.43710-1-titouan.ameline@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xoqu1fzcmhdu4wi6a1jswnfjyr6ckao8
X-Rspamd-Queue-Id: 5C1564000E
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770169293-32920
X-HE-Meta: U2FsdGVkX1/x6at1JsXSun/0mNLUkxTGrZ7smH2QKLxJkpvC256AhHhMH2Qcdf2axbsDgwMfz9jby7KlOANdpP4dkVQpazB8J2yU1w1hHbmBcKas1JWxyRaU5xzHTouiuRvfVG1SNpRlNG3qVK4vlBug8r02w0v4++KfOSddRVGR/ytZ+LuLMx/zcfvVKfG+BZR0ZeTA7Jg/UkyuRC97unSMXto5vktVdM4i/OOuwbwxx63x7j1Wp2v+A/aoHInVoPIdGApi/efySd8i6CMybfo5J64nCDlXFGP0ae1qxqboBJXHAlWbidh0kFXiUw+sVl0J9T1NF894LIHAG0/I8Evv7TNWAqx4YvLZ/t4hfvvFtCTQ5H6vEsmH2/8AE1/3ru8SC57ebk3uVkAcnFGDoJTeIQiPrH98+xbsksXvTAbyGQJkW9BNyzAWMgpxG69EXNkXbAANDoNTApHmmqExT/HFsnlmZNhs3X9T3F8/YGUwqYt/2exFmYmwfd0pQLHNw+n4QwYd5bDleWbuiJu9ki17XlGVrpprFSHGcpfpEGXWK5WBX0rxADuEqyO0EEMy0n0QQ6F4zS2onKT3J5ynaqcj4qTK9bqoNm4qwbwXpc/M/gM+Kt0EF3LbxyBrDzUyGJRehm5CdNwBpUn4L7EAQ/QsfHjzQqfFg4qfrOYrBhBSbQXp8SFlyGpu4pC1XPSru8E11ZzWUvID3I3UQtbWUiSJUTT24tPSgaeydN9xjuOWHVe7UT4cfbUYcjxDmzkvd8BHC4WEBcc3PtQgps6WS0AyN/rsNqNQhRuBkEqe5Y0GW+iMj+UXDpigNlrOsMWqJG05TG++9DT73YisXMOaMdCIhLPmELgmMmbOCNqSYmc1UEMFMRFEiMsaTNKNuHPDIxgZJKf2TNU+rxdJntee/z9KW6dF/kmFxavD5EuAvqxBCrVnSEwe5Nu0r0U0455r4qumer6PahRdIPB5ykh
 6edrZdT7
 AcClE6a9AbYKhR+fdtNSh1kGSCOlZgSO6pTpwRFe5W+KD/gUqW5JN7Vcz4nTC/8GWy6w8APmeSFhfPbe9CUo318lKtDNEU8P1RIHp9Z8ACvy0eMLrsXccRqz5wtn3LtuZ1P4e1WdJI9f+i+JJcM94D5Q9A9J0JvDp3ZgHQRyBm/8JeELdUIMxVhj88z5HwglmOruXVv3meSz71W6FbBcmI2I+Z7eFgXgEKuOn2LuNHEH6VyZviKXmsQGHByQoPV1k6Rz52Th9aRk1qL0n88GvB8eNcnPrgz9m2Uw3lhfywOppxTIlDnhHs5jAEqumQjUGWbsB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 03 Feb 2026 18:59:50 +0100, Titouan Ameline de Cadeville wrote:
> Remove duplicate entries from the bprm_stack_limits KUnit test vector
> table. The duplicates do not add coverage and only increase test size.
> 
> 

Applied to for-next/execve, thanks!

[1/1] fs/tests: exec: drop duplicate bprm_stack_limits test vectors
      https://git.kernel.org/kees/c/46a03ea50b5f

Take care,

-- 
Kees Cook


