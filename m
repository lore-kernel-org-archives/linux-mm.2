Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 351E0D111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 21:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B8236B002C; Thu, 27 Nov 2025 16:24:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 867F86B002D; Thu, 27 Nov 2025 16:24:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 758296B002E; Thu, 27 Nov 2025 16:24:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 637336B002C
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 16:24:04 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EDA6EC02B6
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 21:24:03 +0000 (UTC)
X-FDA: 84157664766.12.A59FBC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 64AD640011
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 21:24:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pi5zZzTq;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764278642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yjpJUUoYcT9E1Pv9O/X4VtBSUspOpoxBx77rmi3qC2M=;
	b=6wtZUevEzNl/z6Okucz/5Cn1vu+SjT04AZ+DyuGi27s8Eh2xJ0Q7Jgqbm950aEUWC9tmmq
	ItNhsx/rXEx5w0khonsSD949VdjCqC+Fk20+ocl+gg0hL3UK8P7Louz+V/VEsue4fWOTJy
	CE0uniDRG0gyulkN+O0PVbOrjIXoyJc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764278642; a=rsa-sha256;
	cv=none;
	b=m/0kt5teRXMPOtjMlIKE+Li0KiJXX+HNzaqcJxZ4FvBHcdPt8iGhQAReU5nb5eTo36livr
	Uzz9L4hABKdgKxV4vQne2/DqI/7jmzYugWyeNUQXlRpnRJ4R7cSI2/NoZJkPotKxgQhtzO
	FrTyYotGGqGSZMcf40VMV9aOw63umug=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pi5zZzTq;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D6F4A60242;
	Thu, 27 Nov 2025 21:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40ABC4CEF8;
	Thu, 27 Nov 2025 21:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764278641;
	bh=yH/wtcAV6O4TXHY15jOrEqjEKaH/XttUxP9fxCUpyAw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=pi5zZzTqDOEpMGzuZHAWMQCMQ4dycETXBy9ybVcWIB9vDDq5NnK6JbsvqXMVA9Ocd
	 gUSsJwUBMlqMW5TP5vT7VzjIsTbXVhMx0tZ82/d+d4QPmkSJa4DDP1LtIOx60oBqKx
	 B0Ic6r/YCp1+5MFd5z47jihUn2ERurVKmv05rrNlndMfMi3vzyOAz96T4GAGl+LBBH
	 iFn5TboMTTFjB2DDGbZRlJoC8gXDrdrZ8qO8GGcZ9sDDzMM4mpCUsSHTowMhtln/fH
	 w3iW7NszipuWNo08N+bLGvJR7uOmGhWEWvGJ1LlsjY5auYKs7+ROJpUQ7da2j0PeyQ
	 bJ2+QppA1h14w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: rppt@kernel.org,  Andrew Morton <akpm@linux-foundation.org>,
  kas@kernel.org,  changyuanl@google.com,  graf@amazon.com,
  leitao@debian.org,  thevlad@meta.com,  pratyush@kernel.org,
  dave.hansen@linux.intel.com,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] mm/memblock: remove CONFIG_MEMBLOCK_KHO_SCRATCH
 option
In-Reply-To: <20251127203724.3177621-2-usamaarif642@gmail.com> (Usama Arif's
	message of "Thu, 27 Nov 2025 20:33:19 +0000")
References: <20251127203724.3177621-1-usamaarif642@gmail.com>
	<20251127203724.3177621-2-usamaarif642@gmail.com>
Date: Thu, 27 Nov 2025 22:23:54 +0100
Message-ID: <86ikevyxsl.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 64AD640011
X-Stat-Signature: t5gcn7kdkwbacm5bmu69fx4c3pwdpnbd
X-HE-Tag: 1764278642-974796
X-HE-Meta: U2FsdGVkX18daOmR/23qEhtaOxxZwu8YmXf4wxDZgDrW9+80d7YQEvjgw3p2RQMi7AP3CEPuXxLIheJLmMR6511a0JLEiI3StL/alakucKZRqEUCw+TCRzS0ZeWMRx3uQtb4B7dSGNSXfgXyFJH2RSK7qlYbV9zFxyl/iMp+Lu/ujs2sMEWPnSKeCqc5x/z54GHaIg3aEnu88wojKtvjapsSGpduBVxse/gNN2ZL6uVvFRp+Wk5oCGrio13Ir3CFYteL4rfoCIOcXIShD+pOO4oMDvhZfLBq4PpXJFCTfgTJYWx+0LoSozesPtL70kunugDPMYFCmp5exV3TclPO9LDIz0wusDDnfgEG+mh4w+zr5p5okxiYnSnZCPpePx+/dOhYIHJefFN4GB1GdeHEBwEQ/ZpK49DtWuQeAiKumjuLs4TPH0VpvIF+8Cuvvz8IDu7VbAvz7rbrV5nx2JMg0KFj9QTmBh/DYyD+ydVYUdA9I5PUzsN7SfQKnUBJzRomMBtPLywmYLQQgoo9AY9bj98q5+Ujn9BEwLdvvNqMQHQWO3vkqxJ9aAfTmbYHYFKVx+8a9k+ePEgWK9xJS838BiQuE/HSkA8U+WLADExTEe+PCq/TvhcwVtVAr3SbplvVIqy0wD+pTImPyvyb/3kcThQUp6uxzwD+4rwOSeDGpmepKkrBWTq/8RPeJin/YdmWJDQUxqDmWz37wKhL5v7+l1hQ2FQpngbrOypK1molB36jcObqyv8nRRAYrlD765aX4e3J1fWShXoi2PztQX3tY+HCyr78hX7KFBNeM18XbMg/5z/RhAJyX3g7gBGqQTWGS6qFWhBg4I6KaV4uJkwlyS68a+CdqorRr6uNMklvpXqbbxzXxaXpogNxfWpa44GBHAWxJvxnKffEltsMPjgWtMR6H+TiuPKNwNCmkZ4goc3L2V2G1W1HEu5TcMaOK0JAhmxTHzurMZrUtfajWfO
 24XzcSTw
 8wFwDj3fN+LEn4sdetk79/8lO2BVQuVSxwqDPhgO14SGbT9EFLpHd41YZI0fXxmv8l0JG0CKncx6BxyXZEel7wPx3L4G96niN8y7vsLa6XXhc0Zsj+g1Z7MJmSN/HhuFncUTuKMcgwfB46iucU6RId+XMT7pqCb4V/8DlYukD+R1cfZBsKv2vw85a0Stsmec6OJUCboTqDQEVf4a1r4hFruibJ1mwOLnQOZEGlrKX+gd+9PZizfvkxdz0olk1qeVoSqtUHtOSRHzSNAU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27 2025, Usama Arif wrote:

> The only defconfig that selects this is CONFIG_KEXEC_HANDOVER.
> Replace CONFIG_MEMBLOCK_KHO_SCRATCH with CONFIG_KEXEC_HANDOVER
> to simplify code.
> No functional change intended.
>
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

