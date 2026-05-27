Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D545CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 16:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F25A6B00B2; Wed, 27 May 2026 12:07:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C9C26B00B4; Wed, 27 May 2026 12:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DFCF6B00B6; Wed, 27 May 2026 12:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8075D6B00B2
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:07:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 01D18161B73
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:07:19 +0000 (UTC)
X-FDA: 84813679440.01.D812155
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 05F0640003
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:07:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=OOwgLj7J;
	spf=pass (imf11.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779898038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=STKe203GtXAmunHIdMeMAq0fDblU9FAY1byc40VlLXM=;
	b=eEUIOkzqasmzhnWvnS374K4IB7AYJqtxhTa6zl7CeSp/uRtLmKjnw0Y4JYDCkw0iagLYOB
	toBvCOEIBtnxJSD2YguSiQjrCJJasYXzOob/rB9w4XkoTRfLm/HKfNl5Z92/efmgg3NYpY
	5CRA4cwFphKqVvRyhS7R0OhuIz6rd88=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779898038; a=rsa-sha256;
	cv=none;
	b=faRmHKFppQXLX5FEtYNHm7M+AR+aswfOCOxhG++3ndbRmv7a9soXeCTfzcyjh1OhU42HSL
	4SfJh0DRQPc2UsJGzGO4NbcMtHCdCgvSDb3DEopbfJbVVLPHc95iwOVnL+Ujxgn1U4TJ0s
	d5oTtkH42nISvis7ng5fzZGb0OZs0K4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=OOwgLj7J;
	spf=pass (imf11.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-914bbfc2464so421564185a.1
        for <linux-mm@kvack.org>; Wed, 27 May 2026 09:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1779898037; x=1780502837; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=STKe203GtXAmunHIdMeMAq0fDblU9FAY1byc40VlLXM=;
        b=OOwgLj7JpUB27JM0D+G/5yM6ZiS/eQzeUWKBtVsjaOoCvq0MaUTtdizpGkLV4hOObd
         V80IcOl8b4luFlbgmRz2xzGCcdbOo5p3MDXyr++SsdQdaUPzhbUT3GNmgJAyhdLnsqVE
         hyGDTBTE3OypC5FzNBz4TChSzXhlJm5Kp/b1j5hQXF4L2ZyXNopbdlI9ZlO9TEbeysLZ
         dmxQwAoov8oEtP6HgGzi10+tFbP03LmNTtpvXJLyy81l5RsB57YO1RXgfXYYr9IbgI2w
         WEL6FBjZk8nnQH82vtVlq4XWOvbCoxmvSc+PlCS6qU3l+uwI9dQnrzhUK8BqcVOuxLAf
         iYtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779898037; x=1780502837;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=STKe203GtXAmunHIdMeMAq0fDblU9FAY1byc40VlLXM=;
        b=HNJ8gexxxa4Z0MFNWJUfpkavGm571PMqeVjoN8C47evPqtL03xY0JtaJk5DR0O7FXk
         lVw0oPAex8etwJsnMod4USsaNmMTpaUDGF3Fk/RLngFPw+B6tfnLiYceNRN13RW4WOJ6
         ryDVihZueYSz76TyAj1dEM0YIulAoC/J2NIKcTajCCXFLDYzjeU/2j/GCxHtaHSzxnpb
         q6ckkwoK8EEOHZ69snQOjIt8R2ZZ6zjKMblTAS2jIcHmHaVdRsNdlpX8zVU6KTBXf4eH
         BZCY30svgEZJSnGb6gmMRm8JWkEtJ2LHrXC3z1ROx5gblryiYIrt3LBIiQf53q/G053n
         dRLw==
X-Forwarded-Encrypted: i=1; AFNElJ/G04Rx8IiIeeLwMialAr/RYCXi3MPmvDAoq+GifLkAIYozPKWHn4MkDtP3PjktZvHp6M70MLSmWA==@kvack.org
X-Gm-Message-State: AOJu0Yw9oMdBXwW7jzKP+BmQzhaDFpL74aPtdDrtFelMjnxyiKqyWZ/h
	n1EBbn5b2btDDLONgu7uqDwHjyNDVVzEXuaK7m9tgB9Etvk69AXd4aC6xruY14tmT3I=
X-Gm-Gg: Acq92OGVtaqjiOTpMPj8rJEPIVq3Jnd1TE8KcjiSXxVnw9XvpeJxv6kyOQha8UgO8Pc
	Qy2qLpdx3VIPYo/oOETxEHV+WRO2NqMc3zL/oJYuC7cVpzvrcb6YLnpLfcZAWmKc4dmjogu0DTs
	mZpMAmku6SgdXut7GQw/tpLs1KOi8+kKDlefUYOCKyeSBXepwCy/Z4YbgMwDO/ADeuwU8+VBfMU
	QmEZWe6yKJQEzbQUF2hWVpXxNm/BmTfURjQOWVGBOf7j1kv8mwpO2meNeHIJjV53ZzrNSRx0iBX
	4aiIjLe6xmJ4A/+D8FgnoXO703S6h5NMlgWCDmLh2g9jyqZZrjCxw+qrn89CfV/tZPVXjq8gRsw
	KEtvehuaeYA5aPaYCl8a0dqYDUh9YWx48F/Sqyq2mECLd0YIffOJ6XfKz6UOheiXce29AWjG4+b
	Pvbtl5llpv7ReSdG3NQgt61WkTzqhqo39XIKJlisec20OyopH6XWY0JvHTzdHix8xE++LaDLVAE
	abXGg==
X-Received: by 2002:a05:620a:1b89:b0:914:c246:aca0 with SMTP id af79cd13be357-914c246b146mr2808635885a.36.1779898037030;
        Wed, 27 May 2026 09:07:17 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914f86e8e13sm505133685a.2.2026.05.27.09.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 09:07:16 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wSGmq-0000000FI8B-0NaX;
	Wed, 27 May 2026 13:07:16 -0300
Date: Wed, 27 May 2026 13:07:16 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christoph Hellwig <hch@infradead.org>
Cc: "T.J. Mercier" <tjmercier@google.com>, maddy@linux.ibm.com,
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
Message-ID: <20260527160716.GN2487554@ziepe.ca>
References: <20260522225853.878411-1-tjmercier@google.com>
 <ahPqbfH54R3JJyaV@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahPqbfH54R3JJyaV@infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 05F0640003
X-Stat-Signature: 4yo1ggx4x76jrq13qxm46g3nitjyx5kp
X-Rspamd-Server: rspam06
X-HE-Tag: 1779898037-53835
X-HE-Meta: U2FsdGVkX19BFnWjku3fJZD2XvwONsWFJB4EHgLFTXzD3lRxrpsZUeeYmMDvrkQ5DwX/pCQFuAfz0b1ZQyBktg1d2ycETDdYV7YcW6CXNtDdyICfjr0EfPjtWLKgarNZaHvBjNgQHL8CCW3dim16uYU04xkGIJENopzSM22WZ/0KFansdUyx3Re4vOq75y5d7Ar8fbawvSIbqa109gSRqrFB1SRn8EY0xqG0JdSNf7mojC7qNNzCJLMat7DG9f9+h9yVUGRkR33+E7TDRrSgzJwdnZym1TRTJt/Qeyx6W0O25XFgaM1ZNtKTVqfLQAWoTGZn24zi0vu2HPVbv+XiVV4KjOTDJvFMcYTsp40WUIsZp+fA6anqOsDhLX3wKZT2/b4Wl+W1KvFUuDU3PSht1A69h+VepQyRbAhN0BGD8iB2sxpIId7DDuAusYM/TE76lnIq7s2P+aDOEyniAF8/G4ccMJ6aPSZE5/OqfLVkCt1j7QZ1Jlnlio6sDtB7GBcWZ5WC5YO4FGhwQO+3/a1//fn7g/rHkP6iRZHKRwvxjSfZSLFdErhF5JxPH8lg8rhBWUOPKUH1/IovFyVmDZjauW+RtQHcojEthBuYG4gswVG9QEVFFTJaiMldOMzeAI02AhfSuLRZQiXc/luFnS/jGurgW+YnIufeEKP3ZGUh4I6vEd1w2G01xgTmI7hJR2M3k9l2Ki9O6kEQYgy/ficYFHspj/3gV7HT4wm9asvswRPizoARYZZASK15kkgVVpIz1bCAUHdq5Gseb/3KenUa1Bq8OI/3tRtWp4P62ClDNzJUQM/MMWVCPImTSlJmNuTvmvW4NMeRlYOwJ9KLipBnWJ8aXeKA1bIVkM+mp2pSSRq3l3y0Mi+msXy7NnwSvixckpkxH2l31Kv/MRhLx1kunnNL+tIOWkak3S9gD+6x2VKCXZ4URPFJXdcR3dqSSqEREJgUUdGJnKFIcy0jWbq
 /mYAspVB
 QbVq8HOlipxObHGEzXmsl2DIqblkE4eu6RKFwQjVh6m7OVaRxwSVUARCMZ1a2VOJqeZLosI2eTc6YJss7ZlgSPmbU14uutgtplFJdGEwJO4KMVR6YaEzqI6/4QkU7wjc2bzSfrw7GvTpA1VJN3OWrLJD+Yb+WveUh0uzWceQ6CK0//haME1KttLCR2u82QrpXYGsi0igiRNUZ8hm7bE5WpMk5dXm5KuxGmjqNHeEIzPgE6wOz8iwbxh/rA12gRCxMz07/qWpCjFYvW+8WSrnl81+cgYTo1462a8dTiNmOq6B1ddFOXicu3F7um2vKCVzFXKrYyy6eRltOAbQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 24, 2026 at 11:21:33PM -0700, Christoph Hellwig wrote:
> On Fri, May 22, 2026 at 03:58:53PM -0700, T.J. Mercier wrote:
> > After commit fd55edff8a0a ("dma-buf: heaps: system: Turn the heap into a
> > module") the system dma-buf heaps can be built as a module. The
> > system_cc_shared heap uses set_memory_encrypted and set_memory_decrypted
> > but those functions are not exported on powerpc. This can result in a
> > build error like:
> 
> I'd much rather revert the above commit.  Yes, x86 has exported these
> since 2017, but that's a really bad idea, and we should fix it instead
> of spreading the export.
> 
> Setting memory decrypted is a dangerous operations and should only
> be available to core code.  We should have various allocators for
> decrypted code, but not export the functionality to random code.

At the very least an EXPORT_SYMBOL_NS.

Looks like there are about 3 modules using it already..

Jason

