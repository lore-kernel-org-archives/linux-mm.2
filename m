Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 979B9C8303F
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 21:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C3AF8E0082; Mon, 25 Aug 2025 17:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99B728E0038; Mon, 25 Aug 2025 17:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D90C8E0082; Mon, 25 Aug 2025 17:30:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7AE7D8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 17:30:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 09D4814051C
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 21:30:31 +0000 (UTC)
X-FDA: 83816573862.22.14AF22E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 48E74C0008
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 21:30:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pbG8wmlh;
	spf=pass (imf22.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756157429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UqltlnGSk4HNPcqeZmUIYDpEiZRsrAJliAJ+0LGewSA=;
	b=Qzrt/INKaMLC5HJoLTHceCKj2dyNqNShpyZhYJZwSKOIL6lCULz1MKYIGLuxdX7sBjpWM/
	9McGHSNjuzrGOWQdUkYXjZIPApW4g6h+YfGzbMGRPqvilQKnV4oN0m3AyVoKV+lgAanXar
	cJLROIEUsQDDP4BlivsmFrd/cCwnTzU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pbG8wmlh;
	spf=pass (imf22.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756157429; a=rsa-sha256;
	cv=none;
	b=dn271II+mVIK2NHa016p3Zkb6lKZ2x6CcikSQQwz2X7N96t2YbXER4MLZGoqq7E+v1Ypej
	01gBbmQIpm3q51eJd3FzxhotORoWkUYHYXst2c/8+LSjGo0V7mXt0o5DeVqrolb3LMOzGR
	kx2Aq/K30q5EPpshW8KQfSXe+mtSz0s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F187E40BEC;
	Mon, 25 Aug 2025 21:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCB7C4CEED;
	Mon, 25 Aug 2025 21:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756157427;
	bh=GpvMZ0qAhXCQKnlOM3cfGnpFhmf7DlrrZY6C6LnJMBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pbG8wmlhX98AevAL7T100EjjUxx/DkwgY56m/0kpVaEMmboBt5R5f3z4E8ElGgq9L
	 rq9Zbt427TSgUaMiWzv5EFeF2CY2L0XxeqeYTWd+Uxfdbw5ofi49Y2/uSQ6zsqgIyp
	 /hW00aJyacKCH+VKN1IzmaklOwMBC2+NwPfRPjX5GDgnkXKL8LjSbEOLE9weg8bUaZ
	 TqF/nMY6ZSG67XCUqV47xmQaCsaHPiGJc9ZnJTZL8SWmKlM+NkFcNBLVT+A8gdJYZw
	 VFR9rsCRaPFJGQTsKZRZQSZP8GZN5xzZSh4ml+dCwBnAuc6M4AUQTBWOII+rsLS4f5
	 8j7CQJyeVKwTA==
From: Kees Cook <kees@kernel.org>
To: viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	Xichao Zhao <zhao.xichao@vivo.com>
Cc: Kees Cook <kees@kernel.org>,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] binfmt_elf: Replace offsetof() with struct_size() in fill_note_info()
Date: Mon, 25 Aug 2025 14:30:23 -0700
Message-Id: <175615741923.2091902.12040309987283385487.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250813115058.635742-1-zhao.xichao@vivo.com>
References: <20250813115058.635742-1-zhao.xichao@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nq9cwtattzyipy6o6xdget563ffaxeok
X-Rspam-User: 
X-Rspamd-Queue-Id: 48E74C0008
X-Rspamd-Server: rspam01
X-HE-Tag: 1756157429-628347
X-HE-Meta: U2FsdGVkX18PlPv27oly4qjHZnCJABcfW13CJnGVmIyfCgqZBUqLfYmC89WVK4R5mVldGPDNqsgC/XJFVUNXaxj4ReUA7AUqHWDzZkwCRbhWNlzRPsYcG8pet709ZLXbsPF2SMdKGVBjS6x04Y31oVDkNpGftbcCoG8su8BPfnl+X/Rf81BzoyF62NGMI+/k97/BYm3THJiD0LDfFg6KCpD34rX7qNGyAh/OtXLoDWjNMLzwWa1hrRc/d7L9KfxLlTxXuC9Uxl0rVVjwaEDo+viDITInAPwds4fQoPFxTQsQOwdE1oroljyKsobJzNbtZflUBA+QDerfw6syCRwKzZ6It8SYgrTb84Kik98vOaUdoQQxwq/BjslgopOVb4rrVoQ6XBbpdzvdscszHJuq2wuVbfXGwCpNMWvAbQVioUNhsaq9oNFVjQuUxclgBqwTbluPejaFSccq8LNyZQHuduxdtx4cm36whdEpXOoBuh9lgMk/hiFMAQAceWNGHiuJkPu3DcKEs2MDY36mwAV3n1iyLXVx+DJi3n7V6rs00qdKHFlwWPSr3KiC1/vCFpauIqhVNHN5/F7y4Pd0k5g6OIw/0um0oQtls9AeBz1mSt8zol85W0JuVLHCI9avMldRX360VCWh+h0LhpzvatEZLYb7vztOB7t8VlLIGc293lWV/Ei5VF2ujYzxLeuH21R/Bsn6cmN3F9KmyfMooq4jvGdljYa4AZSGLQ0oHAZHxZwXGYWc8zpQtH3qz6HPRng1Vb1IXHma8PW+rtFZhJAhvabzGhVNxzkXZ+qYrjkUceoy0ExrC8Ym+qLmfk4RqCEOTNDTeQB43vKQvvgZcxBU3XieVCw63e8hVtnqzx6Qwi5mRwW4U3d29lP/Qtiy4QuFb572KwNrCBysgnK1RU7RAIg61YW+BqRFkjeKcyE2tkuiAUqwnPOg9K6ZNi4J9TxdCUTkvMZZO1LLOXuw/nL
 MUQTkRxP
 AW/Ax3AvoNt0UJLllF7h4k4mPhz8DEamzR22pd47RpJyjj39oD28KgW3GYAuywMEcBnmitOsDbIngvWOls5WuX9qUCyyuZtrhzq04KNHjBiALxRsgKG/OQCrFebCbmVe60dSprHueEW0PkumAzW9iGugiSy50nQ0Y5i8fN27Lbc8sSECWfiOr/SpUVPwYdV4Ex229nBjiA00eIixyyUCY+8lYNxgvBHsIt0yta6DJ7Wguke86NtRahbrzuoZH7V/ciQpm6rBaS7MzgBi60sAgNFO+2L4Ot5/dY2RK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 Aug 2025 19:50:58 +0800, Xichao Zhao wrote:
> When dealing with structures containing flexible arrays, struct_size()
> provides additional compile-time checks compared to offsetof(). This
> enhances code robustness and reduces the risk of potential errors.
> 
> 

Applied to for-next/execve, thanks!

[1/1] binfmt_elf: Replace offsetof() with struct_size() in fill_note_info()
      https://git.kernel.org/kees/c/a728ce8ffbd2

Take care,

-- 
Kees Cook


