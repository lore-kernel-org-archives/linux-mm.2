Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F992E7E343
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 08:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB5736B0089; Fri,  3 Apr 2026 04:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8DA76B008A; Fri,  3 Apr 2026 04:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACBDD6B008C; Fri,  3 Apr 2026 04:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E88C6B0089
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 04:34:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6DFFA8C089
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 08:34:47 +0000 (UTC)
X-FDA: 84616583814.19.9F1FB35
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E20D3140004
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 08:34:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sVBUQzA2;
	spf=pass (imf09.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775205285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l51i+Q86XZaSND+LCQy3ejLxZmxuUh3n/xH7YF+YpTs=;
	b=Numj98TIp2cJIRpWZpjt7CmHr7AFLAzOKRuehSTM8qzftSi7mJJMDFnMPwnBH31YXKAbJh
	UoCkNjc0lP8QD6y+7c7+qxNJiH2mqF3MbykdbQLJEI8HbgvQOozmtdfYMaL6LNmvmVKAqT
	THpn8EtzHQGS6tFmFTJD4jfEy1W1YDo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775205285; a=rsa-sha256;
	cv=none;
	b=w9kPZYuvg4j28Tqh1et+11/WbI7PGB/2Gm0DU1Ap9V1XHRPNCaeVMh2JjJH2A+6bWNKTom
	r+jzbr43qHORJdb9KyqOQkwF0s5OvftCC0mc+gRp1VGxQR1pujFIEEZ06e9aDsITLs1P1c
	wGmFN66yaUSrZruosji9BnpmhsM9L8w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sVBUQzA2;
	spf=pass (imf09.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3503760123;
	Fri,  3 Apr 2026 08:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0B8C4CEF7;
	Fri,  3 Apr 2026 08:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775205284;
	bh=HxmyUkEJdsgiYE7mTiTaJhkgxPe+vdxNd1hQ1Zq9ErQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=sVBUQzA2/Y6Ptaodai9+vkxJiQLM5QgMagi2cAQkRttEu7mMdzgSA0wfnq92LGkOD
	 yY9YKUNDHiDuz60uojW/baEFle2jgDJTt8eyhjtSwjTwLNVvbMkKd8UPFaJeUKYm6g
	 MjoR1rKdkSHUtqxoW+jAp+wSMlF0tmi6vS3QLb7vBTmsUMWJKMpwgMaBgjGx9tJpvt
	 TM1B9eZ2llwlhtb6aFj+bL/5NIcwB7oxovjJBNdsvwwlgkUek+wIHCOrNobY2JIeeA
	 +KY2G43yMFMGrvgs3xdwmi9T0tWJrWbLdZY1eykpPyhsvmcljg7dc3lOo/iHiTFB5c
	 l2+oq1RchzHSQ==
Date: Fri, 3 Apr 2026 02:34:42 -0600 (MDT)
From: Paul Walmsley <pjw@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@kernel.org>, Mark Brown <broonie@kernel.org>, 
    Deepak Gupta <debug@rivosinc.com>, 
    Rick Edgecombe <rick.p.edgecombe@intel.com>, Will Deacon <will@kernel.org>, 
    Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
    Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
    Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
    Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
    "H. Peter Anvin" <hpa@zytor.com>, linux-arm-kernel@lists.infradead.org, 
    linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
    linux-mm@kvack.org
Subject: Re: [PATCH v2 3/5] riscv: shstk: Use the new common vm_mmap_shadow_stack()
 helper
In-Reply-To: <20260225161404.3157851-4-catalin.marinas@arm.com>
Message-ID: <f9665842-cc7e-cb9f-680b-3c18d785c218@kernel.org>
References: <20260225161404.3157851-1-catalin.marinas@arm.com> <20260225161404.3157851-4-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Stat-Signature: 5m4sm3hh3r1ushncqk5a4zfdu6gt5c5s
X-Rspamd-Queue-Id: E20D3140004
X-Rspam-User: 
X-HE-Tag: 1775205285-838489
X-HE-Meta: U2FsdGVkX1/f120/1+9dtzS7ppcC8sorJuRhYNSn1W0A5u86p8x/aqUuxqzuEVREqMmKtxlHg5u22CYwEUZTMRTv2crzYsdtYGD4Za3JnLtImqUo9bKZUCOnS0uAPxSsmyfggOC9IKx0WnWpiTtzCLkRw6UmCYs9BaoHnFivwdUachXFW4Xkt7lxyB6i1Q25rusBf6th+RTqc7fpvWro43oQnbGwMpnrjG2zwlJS/64X48H946FmL3LmdZC2qluDcmdumHbc1IUYR1eDa6OHh6GyZAWUDyQNJJxQFBx4+fSQX7q3yCbMjJTHT1tZh8QEzYvaUwaFSuWUHtwz1z8AAefPgCQiF7b00OBnCzhTcpSK9kaOtQj96B8upslnzNWcUnW00+1SA01jam/+fhFNLRGCc95Z6D5YxL6YFM8ntMrdtTJWQ4vXJdv33Wv6kicD5juBAllvz0D7xWHRclJWOWeaDtm6Nv1usQqeW0/3dJeiydXkOOXW7QiAebbTSu0nJ+MFXm6sJ8sBnJEFvEAY2o8ZjAhtPxMfuGR2LEX49ee8PfB+/NDnrkLs7EHPAs0Aj02jm3CFgjgGP3rm8U3Mt13GnH42jDDzV949N0vBLk3BNbcobnGOwlTe88yEqU6VtUw9hIJXCsRsL8vN9P9HPVyS5BdYuBOHopcp9Yhkb4uPLqs9VWKafIjeVBihgapwHjEZy6pU40z6hKL8fQ4a1OrNv5JmlDU4OOgwsqBqJP1fOqLGX87eUYfQMDSniU909g5bsy/qhxAahe6pm0Ginb1wlVNfHTOzdfJKC3R3t3S6nYG2yYOTnYDVKVdzBn0uGkX/ln4o35FqlXSsFMWrPECD58Iqr8b0jnUv7z8C+l1bf9w7+1+Al5eMXIFEQtSpzwrrl7qtn5zy081JUcFDi3BMWwRcWp90n0dJScUCAzHMKNmCK5J71+h5MAAsd2ty30QJjbTGbPmIOFq+zEI
 RyHrA5Kw
 mqC/VL0nyDoThcjeTEK3CFjG+zN1DFckl20Kllw/NhCvzwNSZaPtD4FiYb8YCORpaHUTvMdCJl8ZLtg5y5om7ux0rVUD86r/OKKg9tdLMJwCJ9+IWj+/5XIACAidarBgLwQyWvg49EjkonRE72klZVmM39+o7PsrVWcuPaQm6pfA3UsFgCGJibsAerPIr3up8dEDkJsJqProFD45n26IuGW+Z/sCY8oiyVaqzaBd/iW9nApxf4zepzS68tO/gJRUe7fkF5qNucySQ451Zij3p7c6cO87cXlxZeqllCqpP6SBZ8jB5MV8XqXwRXwEqDIdDdf5lHCYzWyMUiT75AzUxvwezI0J4AT2cXjWoci1n4ZIvlDWSqyD5QXhysdsFzNhoqrfAV3F1rGNrB5YF/AU9bQY1ZBf4/olUC7YhyaA2H4nWQ5W8Zkv+Hhul/Efw+j6CeHH8tyeIBRuAunRGM8WhasmIlFoeQOvsqSKFQQ9CeA89+EC3V4keKiegxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Feb 2026, Catalin Marinas wrote:

> Replace part of the allocate_shadow_stack() content with a call to
> vm_mmap_shadow_stack(). There is no functional change.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Tested-by: Deepak Gupta <debug@rivosinc.com>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Cc: Paul Walmsley <pjw@kernel.org>
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Cc: Albert Ou <aou@eecs.berkeley.edu>
> Cc: Alexandre Ghiti <alex@ghiti.fr>

Acked-by: Paul Walmsley <pjw@kernel.org>


- Paul

