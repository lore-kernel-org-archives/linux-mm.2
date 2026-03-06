Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B06D2FCB61A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 15:54:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED40E6B0095; Fri,  6 Mar 2026 10:54:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E876C6B0099; Fri,  6 Mar 2026 10:54:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDE6F6B009D; Fri,  6 Mar 2026 10:54:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CDA1F6B0095
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:54:55 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7441FC235C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:54:55 +0000 (UTC)
X-FDA: 84516086550.19.5DDA45E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id BC03640005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:54:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p4jy2GCh;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772812493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B9nEEQgEUGdTj2XGuUXl4Hb+oaDFPS6N71aTCmPeeJk=;
	b=KDtvP5011lUEpAftU8sqeAXktapnweM9BBIyIbLdoVS5Lg6d7U0ucJkyAXO1zuH8gvPzW1
	D2xT++v7LIxfAXEBzoP2kaxBA7kKcQWeCqxa35a/1vjdQWgssghRLfg+65AOiF3lBfI3fg
	gfJuCK2Ti6sOCgarVw4RfGfxoPWJ/OI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p4jy2GCh;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772812493; a=rsa-sha256;
	cv=none;
	b=1d0O+jTObjl2oVMNzk8jtjIZNLu7B9Fvsyux2PbXsfx2Teqhrc1nBuK9t3GtdV9B7nOYy7
	1O6kG/yyJ3F1ylRQN9uCti/ECnxo4Onm5bNjhDAp9z9+gWGfT8FTa3PRlltWndumeR/MZe
	EhNmZWWoQCtR+s3ruhTFOqPsGpCvcZw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F30340936;
	Fri,  6 Mar 2026 15:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40A3C4CEF7;
	Fri,  6 Mar 2026 15:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772812492;
	bh=b6Q2vfwCcs0E5l+Cn9299eegQd0q/hpFvgEzI2+Enlc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p4jy2GChNGU3tNV8OYElXie3aNzB0SXD7lh9yXZvKz1zVKHOB/ZWGp67yIFiNq5mf
	 Fhce69xc6aXopB0jXkIAQbwBRa6F49TXpg6qSElR3asH5LWu83AgIOZq/hvqaULwCj
	 cZ+4oqg1GlBG/VhklOHArgoo+k0eGGzK8/Jl5b+s/ZbLNUDdXNCs4oFiUxekgTu9mS
	 aGMwLC12+GsaxeKj6VbFiUsT5i5QQ7paFf32c2u2V8bWKhy5pxy1Mg82t6aW4jxZkO
	 nF0jWTWWJiJ1H0ndGgHFrEcgvRhnpQ2v7XVCVLCVMZESVe5wkWQjaDZaDrFmHeiwTq
	 riKeL5Mi5/Mng==
Date: Fri, 6 Mar 2026 17:54:41 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@kernel.org>, linux-efi@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/efi: defer freeing of boot services memory
Message-ID: <aar4wRh3TRm1m0HJ@kernel.org>
References: <20260225065555.2471844-1-rppt@kernel.org>
 <7e4f6a4b-fe41-482d-a4cd-5a059e1626e6@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e4f6a4b-fe41-482d-a4cd-5a059e1626e6@app.fastmail.com>
X-Stat-Signature: iriy8amg83r4c8wnit13shte67xksegj
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: BC03640005
X-HE-Tag: 1772812493-761875
X-HE-Meta: U2FsdGVkX1+LsQxXYuyCzewJbwGWqcxJ8x8rp0YXiggVRPzI/orZY4abJAsS3uuhzDAoMXkNaB1uiQXEOTmFWe9egmKC3SYJIPOiLdgGaUQWUwUWJTis2sMG+1H7l/NETJaljGnYXKZGVk87Sur6JgLJtAeTZ3k8SjAL6sMCHV2WiPRH2/HHaDR7lpwpTQxOphvAsqLxiDuV9TWlthNxQO6z+Y+pPgi8HLrVZQA1FDczcQAtRgzomFswuDlaQ08zJoCXg6pcaof0bqad6Pw4tIq3DlsOU+NGT9k0gcL2P/S99raT40by6XerxgSHmMsKnErlzBoy0V6QGAShtVTsA/rHvEN+vee0sJaCy51DraXjvSzFdazHxPJOx8ZmVhjseDjZkVQPJfNkgBk06GdWZC9NTiw0M+rmuPsRyvzXnHdnQ1/IyoaVT0ApXx5/xdlu6lQCxotk/bgyuUcFXVs287pwwAaLTUU4r2VlBzL2B74GeN5yqTu/xgJ6dYxlsq+EZO09mFtFm3Ft5TxdKU52XwMN1wH8H24l62Sf1hDivWDKO3ETfKWbDhwEng7byK9IE0YNF5vnAEL16DMjrmyR/1e7k1XXvGUUmMp92txmmTZ3S+oPs3ptZ+Q8KO0uv26dQZMJdTrqrgBU4eRBLkLBqwtVQ3CrQ7CfBHkLsSnugXLbaDbpdUsCKS0Dds127GzCBs5IsP+d5DyxX2zBYs0RvjAjdrnmq2lgMitczVII1S1BLAemM8LiXRFLukTmbcKm7lt5yXkwkthkHKQ529G16bNJf6ZtEyBFLYUQf+TqZ64J5j2dHASzPRZl5+Huy47tGOlvBu5bLMoSsEytqMRardDF7P7nyR9QQaWWptkRHVDrBkyvYDplLdx8oFnNnC0fJW2OwWDZ3hAiN0jlH5JPb4Ifyv4oJZesPM2ug+/qF4Rz98q7fGeUZu4EuRQJz/jQxtlZDYMQX1ke6o3Yx13
 vb6eVaOA
 BXXnA53a8v3iH/L4+lAq22cWxse2MnBweT7dCW4htfRoBkKzOy5k1TaNnmZH7TDm7RX05J/Bmy5Kgz25KO1xiHkVp3C/Z+jR3j+RUUPvslBs1SauwCUss7PHPQ2+ybz5kY6mmCGU/5+6z85SLlKSpcyNwuKBnJU8Puk7r3FMfZNA4IMxq+/K1428ndv3mqg9/f4oHpgJSKrUQue9CD0J6w4XnyHk1vpGoBriGQB2t6OyScwPDIXc+PX22FVPyfvWYl4koaDDen3kctDpmhjKEVBGLjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 12:11:12PM +0100, Ard Biesheuvel wrote:
> 
> On Wed, 25 Feb 2026, at 07:55, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >
> > efi_free_boot_services() frees memory occupied by EFI_BOOT_SERVICES_CODE
> > and EFI_BOOT_SERVICES_DATA using memblock_free_late().
> >
> > There are two issue with that: memblock_free_late() should be used for
> > memory allocated with memblock_alloc() while the memory reserved with
> > memblock_reserve() should be freed with free_reserved_area().
> >
> > More acutely, with CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
> > efi_free_boot_services() is called before deferred initialization of the
> > memory map is complete.
> >
> > Benjamin Herrenschmidt reports that this causes a leak of ~140MB of
> > RAM on EC2 t3a.nano instances which only have 512MB or RAM.
> >
> 
> Putting a fixes tag referencing a patch that dates back to 2011 doesn't
> seem that useful here. Is this really an issue that goes all the way
> back? Or did a later change trigger the actual leak?

You are right, the leak was triggered later by addition of deferred
initialization of struct pages which is about 4.2 time.

So fixes tag is wrong indeed, but all the currently maintained stable
versions are affected.

-- 
Sincerely yours,
Mike.

