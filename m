Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEB49109C059
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 18:52:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3269C6B0005; Wed, 25 Mar 2026 14:52:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FE146B0089; Wed, 25 Mar 2026 14:52:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23AD76B008A; Wed, 25 Mar 2026 14:52:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 121FA6B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:52:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B30CD5BDEA
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:51:59 +0000 (UTC)
X-FDA: 84585479958.01.0C98D52
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 00FBF4000D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:51:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LgRXez6Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774464718; a=rsa-sha256;
	cv=none;
	b=n2qTkKktY7ftdfuAeSWTw3dUhSw5816o+B9z8eTmMpDppFtscr0Ht6JyOL3VqaNu/PtRSx
	ic3yv2P8KUs7ekvUZ91l8V8+3J8gWYVZwCDtr3gI9ojxfoA15L3IKzUpVEE49pB2usyLdY
	nwpW1RSWbDn+eTY7oJtqzGWrrlU9ITo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LgRXez6Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774464718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IGbkqPR7BUhIQkkLi07Nyrzt7c7Vcite2KN5r8ANv9s=;
	b=KpKEcRBPZ6VQCexiMchBYfDcVTORWMNGq9LDPmodEL/3VSCI24n7FZpKtb1KoipI+MQkVK
	bwQju/QYf1R7eJVWpolDFALYNMRvNvC/hkKqN6bEfe9e9P8nBtX1HPGdV7SH+uPcRJOv61
	X1E6NyqDP/SJ2/BK47SCpPYdMK3t4KY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 084054432A;
	Wed, 25 Mar 2026 18:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA06C4CEF7;
	Wed, 25 Mar 2026 18:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774464716;
	bh=nKabycmD8hGlr8ej2ZDiLueAYeZuktU71Q2acHEXT6g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LgRXez6ZsmGXFcpqu/Y+DeLpqQglo39Ma1EdXqsgZBoSJAQo/KIDcNLfWXlcELFlD
	 2LXMtXZQjNJfmsCXmHbi1feqprwU4Q/ct0PW+Ab1K8ivIN+O74lCEvdEHZh8rQvzkU
	 mmhfb8H9/ZNeyoTla5pL7SlAwXBXbRKnA0bts71cOVF7YLV5qk9bljWobJSTIFJkTD
	 HCXb9olaOuz6vqjBXcpXvSJjdRtp5GlVywF1TrxPYHt9VDMXcmd8O/Y4kf6aht0Sz2
	 xURBufzzqX9OeRr+XBGXyy/E2jixymfjVr3uvDmn/V0tRQZ4BChvAK3l76DnCMGJyI
	 SnkniX6mz+5iw==
Date: Wed, 25 Mar 2026 20:51:49 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dmatlack@google.com,
	pratyush@kernel.org, skhawaja@google.com
Subject: Re: [PATCH v2 1/2] liveupdate: prevent double management of files
Message-ID: <acQuxXLN16puikaj@kernel.org>
References: <20260323203145.148057-1-pasha.tatashin@soleen.com>
 <20260323203145.148057-2-pasha.tatashin@soleen.com>
 <acP_6wY_HVMyTLHk@kernel.org>
 <CA+CK2bDNu4+eR1FPOeaN+rZf1GWkiFHCaHwvS8wCKUPJkmWKOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bDNu4+eR1FPOeaN+rZf1GWkiFHCaHwvS8wCKUPJkmWKOg@mail.gmail.com>
X-Stat-Signature: efdd3cbsob93a1rdynkmnu4hzu95iab4
X-Rspamd-Queue-Id: 00FBF4000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774464717-866240
X-HE-Meta: U2FsdGVkX181TyNvpi6p+n5ZMRNloyoOBGR1jsXJzRUypjSzROxv7bEyoCiL34OYJCbE0bFUU8bwUuvK8fuvFQhCyVfsrwxbfXSnHsSpsSBxdXXyDA5MoPYND2hXjtOUkARSGKJmL+Kvu6Ll++yUXJXkos7Ib5kDBPfXniKVF2KflCkHhlXKhM0EVlmJh+no9L6+Lj2HwQJSYtt2XQZhBrD2Oq4pFXF91d3T2kKV9ubAAZoebxWbZo+ZKn7HJLS0MORAogDb2+1KSyS4Dpc2FJjRcKM175lyyNCHmCsF8qcaQMvw9X5sHf2bziJ1X4hzPxEhmQkCax/tfLDV/CLJMoAG5xuKuiX56bHzvKKMIa/GcPnibYBYBVtMN5AQo1GnBxvKD/GMR54ZMpHo9xLjnenIfC2yqzctOhOpAV5wO4Mr8D6GdNrk1IeErGyhhDcWqPrN9wQeGvyjkWoZQp5Z1+LlEcUlgjheIBy/oDL4nuGzqK/0wl5jvTmksHZLtl87ABONa+SBQWFApd8bavnD+wysEviFQdypow9biE50Hec2LhWK5lGRrKHcf8Gw5BxfNBoVzfGXJ5yekiUz1yyRROyD4j7Wtm3ub0cROaP4DLE34XTKwBj9UQknCh3aqevp5eEN5EDSMw1jRA6YqzbRommKXwwx0gb4WvDTJSalzJfBlrO1e+gPu/IzYSsnQCNQMBuprKWYDM75OF33sfLpfhH1esgeoPHcs87SmqocI/vJSiEoor1Xf72Oufv4Pi3yXoQyyJ9Z5NBI5lvWQ9NgWdJD5NIAqv16HbdHu0Hqr8IyEVDV2ZdmYZZjoK+uDW/LWhQWRl6ZTS/B7ha5K0vhMecbnI+v9vvevqrOQ4X/h5qKIM9mPvlna307nVfOPqFRpxnKh5gSZQBkkQlZSM2N+CaSfefI65h/okgPMwkwbVzJch//cStMYE//1kMTk+LNP+Gv/PSX42RwY84dYQj
 G4FfIHes
 xnQ1M835bLB3NWD8wTm0h7sb1aw+WdGNsFRy093+swRpkgEgJdzA64H9wP/jaRiArfT5UqgJvvYTL4tVwLl8mby3jLftvODC87igawsFwUpfc7MSUHB2QxlDto93xOIZ+SxhU+EKUlzMJ3lsBPCdwZyxpqz2jYpQGQ+BQqSRMdgeJ0ySFOfuVQQgZoS5z/jWj+Qv7SYS2+sC3/aQNnHQPdgeyw+fBpek9UNjMDr4Vhm0D3VOJ2VXE0+1CRACkkBgmtHh1pkGCkGV7xwUNvAO/MjydcaS4mJ1IrYs/LIve7UacBYw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 12:15:53PM -0400, Pasha Tatashin wrote:
> On Wed, Mar 25, 2026 at 11:32 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Mon, Mar 23, 2026 at 08:31:44PM +0000, Pasha Tatashin wrote:
> > > Currently, LUO does not prevent the same file from being managed twice
> > > across different active sessions.
> > >
> > > Use a global xarray `luo_preserved_files_xa` to keep track of file
> >
> > Do we really need _xa suffix?
> 
> I liked it, because `luo_preserved_files` is a little too plain, and
> not self-descriptive. Anyways, I can change it.

Just reminded a bit of Hungarian notation, but I don't feel strongly :)
 
> Pasha

-- 
Sincerely yours,
Mike.

