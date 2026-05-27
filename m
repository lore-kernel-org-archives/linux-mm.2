Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39CE8CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 18:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 335626B014A; Wed, 27 May 2026 14:16:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30C476B014C; Wed, 27 May 2026 14:16:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D4816B014D; Wed, 27 May 2026 14:16:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 090046B014A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:16:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA5B91C1A82
	for <linux-mm@kvack.org>; Wed, 27 May 2026 18:16:29 +0000 (UTC)
X-FDA: 84814004898.20.85331DB
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf04.hostedemail.com (Postfix) with ESMTP id 10D554000E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 18:16:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="BSyfa/0G";
	spf=pass (imf04.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779905788; a=rsa-sha256;
	cv=none;
	b=wySBZ/ouDCesb87mQJKVyqG57x1TBv41bnKq0WEJWMz2FM21D4p/92qiuPQlpTBtxpBQb2
	R9gCHXAXJNnQs7z4wQHId3j7A/5Gvm6orfUDRgTqiMOkzXK+jRD0VXzgMeJbWWScxP6S5y
	JPR6trooPS8q0oS3HjN0vtwtFHuv8KA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="BSyfa/0G";
	spf=pass (imf04.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779905788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yKtFY4BBYMPRlzCIJJQtbW5x/y0DZW6pYUq+N5xMMmU=;
	b=MAPzKkrt7znElOwaVsWNCGivUUky/YtBvFof6kW6uCIgE+MBcGLeeCOept9UtdpkTiMoMp
	twbcoPU0S8nQFThmV8PY+9+nMQ5CwNfR/hs36skvtR/UlGVO7/7JXusNfCr/j7qfNUPFgH
	zCgxY9AREltdxrJV8maU1n2wO4C1lSM=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id AFB0B40E01B5;
	Wed, 27 May 2026 18:16:22 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id hOVssZXizJI1; Wed, 27 May 2026 18:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1779905772; bh=yKtFY4BBYMPRlzCIJJQtbW5x/y0DZW6pYUq+N5xMMmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BSyfa/0GmQmX7Oe2vHTD+nbiGKxsP0fxObUh9NlRN+UHJXUPOJ3yd/0nydBIT9yCf
	 pCR3EocFI14rWJT4k+n1HljCFvorak7nDVDyU2S7ucKOyUCPVd6jLVyfxZefXMz070
	 a+mMn2YRegoVBuE7qbIb2qaquDBnDh5byKQvsLttgNE9xdAfhrg88R4UdIQVUaCSqg
	 JfiCj3Jd+6AImBQHRBlIBx/52nnzWsU+3vzxtGW517fcKoh0DxEtqTd3STS3T1tykN
	 j0pcE+Zcqc+r3gTkadjgJaWDYea6f/aUn+Fvw2vouAeS4CCT6+kGyKgv885YAr7dCd
	 YxHlyYOzcDYSZVBwFJwotFPaNFJ6VTT/CJemzYjIgt7ZwHxqHaewpP/Jn1AYWSD2BI
	 fSfdj1h1l2pSliLhyA183HiVEvtEz5zHuSawQ0NaaZP7S3tUNLzM0KBcZUpnhOwXGO
	 uJwRhAn0sAI7G5JelmOgn4Txtqpkn2rXz66NBF3Nmg9vI5A/gcH0LdSsKv3yaY7dnT
	 ds/fIx6K/yI0ABhJxtqbmJ4WxM47LUo0XAVLdeBxb8R65K/G3iCP4ZzTvEUUg4/UsB
	 k9eWl+aoHEuKDH6sD0iPA7m41OQ1cbbfTjvZoGFC5aT4HS45feFtPF25igyXJRH7Es
	 mjsWNqk1Q0OcuQoAKpE4LrZg=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00:b8a3:f58e:8829:9ca6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E9F3740E00BA;
	Wed, 27 May 2026 18:15:51 +0000 (UTC)
Date: Wed, 27 May 2026 11:15:49 -0700
From: Borislav Petkov <bp@alien8.de>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@infradead.org>,
	"T.J. Mercier" <tjmercier@google.com>, maddy@linux.ibm.com,
	mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org,
	linuxppc-dev@lists.ozlabs.org, mripard@kernel.org,
	sumit.semwal@linaro.org, lkp@intel.com,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
	Dan Williams <djbw@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org
Subject: Re: [PATCH] powerpc: Export set_memory_encrypted and
 set_memory_decrypted
Message-ID: <20260527181549.GBahc01Xflm2yo5OqI@fat_crate.local>
References: <20260522225853.878411-1-tjmercier@google.com>
 <ahPqbfH54R3JJyaV@infradead.org>
 <20260527160716.GN2487554@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260527160716.GN2487554@ziepe.ca>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 10D554000E
X-Stat-Signature: hm19mdnd8xun4fpyfrgin5ae6wufozc1
X-HE-Tag: 1779905785-475376
X-HE-Meta: U2FsdGVkX1/ro7wvSmgpiFgjheGsCVaLiKLJon9RVZwMeGZbqJVDouytqyTHd98eyKVUgZkguu6GRNVjTfoiFasvHPJGbiwWpn7VZQv4u+Mb7j56cvH3+hOPTd6xbK59G7dtZMlrHPPI3kdTk5sYpQzYTvcrNNK+TUkqnTpHVdzNDrDtxrRfREnNYTKwWwXcPviat/vHYyM9WtFZoeKiG2CsuOqKfmdClgGoodZjHDAcETdmmX5gSRrsW3yQ8i2pAlmEZG5pEQ3PujF/ROzXDortz/CjK57rsu7n471qQzFtm/kqTSltH2lBVd8KYI6gN2KY7Yy6LEXpeEZpvV33CRIOm6P3U2T+WkQ87gyi0Z8vsveD+tneAT/kNHIXIwOD0R0egIyq6YlaelsCZHfxGTkcgmOhpdnuYNxg0U4VAKseYPD+0gtcai7UiOI9npoLETX3L99dmpK3xo/bSEMK3dNTMQRzWp7pMRAnGx3zxmS7ajEr3YnxfVwCgQfvQuYg/lPWI+kKH8VxKdq5KTXnmOBCIf0IvSs9dPAWqDbi3Br3nsZrAn4p0qQu70/kM5tcpLG7XoWgtIWClfKfERl+lcXK7ROQ8F5yRUIpJUsojGv7o4v51977Er8b+1grZDzLu1k7vqiRP1cs12cmJOyBs0UNn669GlfMqazs1esA3w2zNuNxCoqNeBc5ef1CnkBaQ32kmtlTP8R9vAwUI+JtYnIN0oiutGQ6/b8sj/Io9YrFH4isVDILXoPNWOVTcjVbPk2aodyHgpxWbHBeuLt4Tvc9LG59TnkTo0wyYvHjcqj2x0calZPo7KiwAsLLLdcDESmpE64Ip+YEQLtUtvkiZ5QRBJg4FTKm54QqTiSqIlSiZ8K7smC2bZ2njb66kHVavwu5OrgWkgBw9hITfYZVF8HxIZyr0ilTSApyA7sAUOreBLlctLd32CPhD1WwraCJfEP/3f2UIZEvAmnucbo
 BSlBc2cv
 /SxvdtAhCy+QGLSgVyF1Tdc3yoXurs9C7Q5wfg2+kCKXFu3cCY5N3fYuPW1XF3y1Kok9xIMoSPO+XZDFu4/089R9Qm/LX14rxHBu21PwJ0Z5v/sdd3MmgxyKj6uGJxxR0eaK9YvTFdfC3gwaXcQKU43ZvOcX0Gu0zUZ/OdxmbuSkeUaowSAuzpDS9x6VYVIjU3pHrq/2x1rmpefvcLyk+DipAohyMtucC+7dIXVYuJ8IgmBF67+MjWRQVEYXvbdyI57l1DYRFEgjtAwkgbx9zO4bI9AfoYUgC4Pl+R0zuR6iwSUkegZpdyuRYbzjmYwJWFiRZhQdjKEXaItf2aeeXFaw0Pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 01:07:16PM -0300, Jason Gunthorpe wrote:
> > Setting memory decrypted is a dangerous operations and should only
> > be available to core code.  We should have various allocators for
> > decrypted code, but not export the functionality to random code.
> 
> At the very least an EXPORT_SYMBOL_NS.
> 
> Looks like there are about 3 modules using it already..

Looks like more to me...

In any case, we exported them back then for some framebuffer things:

95cf9264d5f3 ("x86, drm, fbdev: Do not specify encrypted memory for video mappings")

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

