Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51341CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 19:19:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CF866B0005; Wed, 10 Jun 2026 15:19:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A6F56B0088; Wed, 10 Jun 2026 15:19:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E3956B008C; Wed, 10 Jun 2026 15:19:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 519D86B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:19:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D57E612026F
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 19:19:55 +0000 (UTC)
X-FDA: 84864967950.11.14CFB4E
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9DFE1A0010
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 19:19:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=JceC9ePc;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf25.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781119194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JysIXdHqb/AfYm9Wq38SegXh3xO5K+ZoKmjZT9fhfWE=;
	b=B0KmI8UdvsKE1oTknh/6jz3+DdQaszj3L2NmUVpo7W7JAKPSLbgrRUQme4hdafJnuDTeGb
	NAmiQFqBs/qYuiN8NH0FY/dkXkjwJwUziOHc87i+6fgL275j5T8xGY6jS+jdu3PdC7HHsy
	9WuXD32cc9mdCqupUt3h7bC6LJq0TbI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=JceC9ePc;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf25.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781119194;
	b=MO3bptpbrvo7WV0OScc0YSswFp9tx26M++gO8UsPw1NBAlkGGScX+O2JxXC2I3D4CR5crJ
	9QwhZHyMegkSfX7m+QCwW0eR2b0TRl9OSxpbXq6s6U0Ps7nznGJp0NASeaif0NsFvfbTUu
	+XCOzgY8zl01aQyuuYzIJbn98MkggNE=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4EBA340E0177;
	Wed, 10 Jun 2026 19:19:49 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 8nyn0l_YIkCi; Wed, 10 Jun 2026 19:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1781119179; bh=JysIXdHqb/AfYm9Wq38SegXh3xO5K+ZoKmjZT9fhfWE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JceC9ePcoFi7qjCMH22o5S3xFxLlydWzyZvW2u2eZHiksbHKuXbdnlx1p7ujPkotk
	 C6U9Up8ZdzWzvfl5udJAHcg3aUuEpkPEqQfE/CGCSQffYtmKnBguQ6WTj5WY4FQprz
	 kV+FpnxtiSQ0ivUNwWCVSZrJM1Hy1HoYuBh5r9Cco8R3hbMChgQrInyAdK+XhUy9PF
	 /UEj+kTvgroGGKCaoG7SwdwvyR/7DzCwqSW9d+iCodMCRxW8+psphgPVDq8ixaGDUB
	 E7T1v4mLvFr95/m3DqW6qxBPbxQuEOdb1hY3zfA1sZqitymqRXE4UrpkZB64mDuekD
	 Raqrr+fQ7MKy/jG8tQouQ3bqfof37zTlEZaeFNO78nEdLhQi+NgaPIFK12z5+lVNvr
	 3Ir2xmbh9mVSmV6m6buYFSw7v/EEWbJ0FXuqxR7+OOluS37N8Elk9L3NTDm7ODGKCA
	 NM9tHMpX6PhuDnI7dgOlgYafrusn2O2UbFI6Ap/ZApb1UeyiMQoi9oocL+K23R+k0Y
	 pIU3bYEMMK0Nqewco6E5Rv7TDUn0Ks7hioOYxvBhnx6sghZga+WLbk9gz1uL4KIBfC
	 NRqlI903GpRy75JLK1l+nska7lWTSoonARyvpSViO6PgrALz9sGL0dRvmL03edO1sc
	 IkpYbKVJMDMp8u/PzvVKuJoE=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8F43D40E01B5;
	Wed, 10 Jun 2026 19:19:23 +0000 (UTC)
Date: Wed, 10 Jun 2026 12:19:20 -0700
From: Borislav Petkov <bp@alien8.de>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de,
	dave.hansen@linux.intel.com, david@kernel.org, kees@kernel.org,
	linux-arch@vger.kernel.org, linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@redhat.com,
	rppt@kernel.org, tglx@kernel.org, x86@kernel.org
Subject: Re: [PATCH v4 6/8] string: introduce memcpy_streaming() helpers
Message-ID: <20260610191920.GBaim4uMX3z6OqJwHr@fat_crate.local>
References: <20260607190804.GAaiXBlGO2eRcfs1oB@fat_crate.local>
 <20260609120132.84323-1-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260609120132.84323-1-lizhe.67@bytedance.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: rpdf15n3dmizke58fy5mx7t8adpsqzn7
X-Rspamd-Queue-Id: 9DFE1A0010
X-HE-Tag: 1781119193-426587
X-HE-Meta: U2FsdGVkX18npdUdgEL25ThhipQlsYPrJgnunHMdivzDSFbmT6sYhAyg6FFTde6NFj297RqJ6ACWFpgQlInunfBTP3O2pV9CrnmoidgX8/Wdje4+bfSjNDcBrKOebajTF8U+ISSJgvdcyHV5Jk/qjBQ3HlbMduwEtQNEaFbFUeGVNH5RZ3+QTHw1Sfu50nqbG01dcQOF+Yh27coz+aMxdflTTojASBY1zM2yqo8oMyzKPR34SIq7ObRodA+7VRx8MTnWiAjqKYP15UupQFX20ZONVXGq7pYi8T3yvaSH8aJ3PH4KvGDZXZxLDTZPtII7k9VqWd4ZOZNBgKY6wblx+aTcD0dLChDcnzvdfv9MJViYsbUraUhe84R6Bk5658uHtqaSOb0OqMbruD2GBHpkLmwf4XrEvg9FVF7YIKqRmpWIO4h3muaFHftL5Yxz58Wc3kaqGT9iTV8z6XlZ6JdJoKcwuKhVZP14FVPn2cCnnLETdt3fRKd+3l2N5Z0iH1pV0hLdXcsyWwYVLxi2LbWDMrxAwZyHp1XTk6phkf0mEWEPvSPAKQ47PZRrx6WmGJKAZ19U/f6/oHsF8vq7Hk1S/boxnxlsSE8hSv3tZ2H0+RMVtAhcFH7SAa2oRLXR9z254oNuj6Dlfa84YWvB1g13q3ey3+BOONRDvtrmRRswRkszr7HkeSjBNAROjyTvQijpIZwKlxPH34dS3HPz6IuBMpCDU/FgPEN84DOzRRrjXcz30ka6U1PFddxRfqZ0IWlXf9UrHyEJQg3v3FKt35w6ei3t/PuPDhQiVqte4PXxd2Y4eE/TBM97fo0V/Du4WasjcRyYyTYD54QvJuar25nJ0OJrQ+I5zAm0ixvpdjagUl502m4haAvXLltmf7jiBgZD3V2vT01DLFhyTZCQUUoMc2Cb7wL7UbVqpMgGb3K7GixYUwCk6d/pVSkqOMj6ULang3PBp2A3rtuB+jVYBJJ
 j/0a8Jh1
 jVstL9n9tLBfl3GCi/sfHoGLQqmUju/K6HEqJ41xKGv6HQG05d43JrTvZ5JCqGvsuBpBmurADRMcGYJKu9qTjCMVQh6fDP+9af4cQY/rSlNlGoxL5Y0ve1f3SRcd33p3De99E0JJhbZ7P6mG6X0XFYVzO2GsmLyXZ50DQJoRlmep2N4WWgyE+EPEwsnnAIJhQmqDDyf/XJIKj5NTsP6Ev81rtYoAXJM0DrgzbBXJHcQlqJn+DsWWnsDAB8yac5C8MPD7MQz4CgTzPl9Xhyh43gW52FfWbRdK6fXfKiDgOh0kfepbFwyIoMEF5KeGqR/fVHxLr/zGd6DsUM/B5wjo5686T5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 08:01:32PM +0800, Li Zhe wrote:
> That said, I see your layering point. If arch/x86/include/asm/string.h
> is the preferred place for the arch-visible wrapper, I can move the
> wrapper there in the next revision while keeping the x86_64-specific
> implementation details in string_64.h.

No, 64-bit only's fine. We don't put any new features into 32-bit already
anyway but that wasn't clear from the commit message what your goal is.

> Thinking about it more, I agree that this is hard to justify for a
> generic helper. For this series, what really matters is that the
> struct page copies in patch 8 can use the existing x86
> memcpy_flushcache() fastpaths where that is beneficial; I do not need
> patch 6 to impose extra selection policy on unrelated callers.

What I am asking is, you need to show numbers why those helpers exist.

Your 0th message is talking about measuring this in VMs. If this workload is
not VM-specific, then those numbers don't matter. They're just handwaving.

So I'd need a good justification why we need the changes before we go any
further.

HTH.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

