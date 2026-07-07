Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2744FC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:40:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EBB76B00A4; Tue,  7 Jul 2026 09:40:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C2C46B00A5; Tue,  7 Jul 2026 09:40:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 100CD6B00A6; Tue,  7 Jul 2026 09:40:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E146E6B00A4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:40:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6CAA1168D8F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:40:38 +0000 (UTC)
X-FDA: 84962090556.27.E4E2373
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id C944DA0005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:40:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rt1U2lb9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783431636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bmqUt+g9FyWmU6ipf2GuV7nDUiq2yVCFHD4qz2spAaQ=;
	b=mlCf1OeP0eyF38JLiJiJFa5zdDX3SV3LWcJXfn/pJ7mckTS96mXoZTs6A3WbqaRREVNwYJ
	rBHfB4NrDeFwZXT/ipcOFPRby/+Sy49uOHrH1bT35GvNI3CdXcAdtjIedHj949fODISw7S
	vqMo2orz4TnZAqYXoMEPz4ZvsabXDzI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rt1U2lb9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783431636;
	b=MjWjnqLZE2qSGGtSWUmgutkO4ql/r8lBkh1zw7Ub0MQ8pAOtrkAHFFUstAhOCNT06pXIJg
	SfpyGidQdkQ4AQ6+PfPwjDCVOu4qfAp2zFYjAAyHnWAIbSBNt1AxjLgYvizb1XYO1O+XED
	4G44PNJ/vvmQbXcRV5hlew19crXhm1Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C57C43F63;
	Tue,  7 Jul 2026 13:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034A91F000E9;
	Tue,  7 Jul 2026 13:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783431635;
	bh=bmqUt+g9FyWmU6ipf2GuV7nDUiq2yVCFHD4qz2spAaQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rt1U2lb9H02UccHpTsgdX7JQcUo66j+coktV1nVn/mBIWyNGO3PhZsxunbAcW83Ka
	 54kp8+S5mjCXn5HtTbFjhDCYTzAdkkwPBpUFbX0whVqiC8ziFubhi2qlHdvdByzzms
	 4nk7JcTLdxAPhNaMIaOAMEP7QNAVNRRGmeyfScH9xe6waEQmbq1NpGJX8K/HDsBUo1
	 jZp37rBWM92UU7LoN9B13cTA39ZGzZ/6ZDrqSbEYvuEk2nbD/lABU1ulNRDnib41Nn
	 I/8pmobomED2Vl4XQIHtRfuJ7Fmt57A8Nf7iLZmzqpRpxKxZGyTtorI+eccftmIKR9
	 GazRqD5MT+VKQ==
Date: Tue, 7 Jul 2026 16:40:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Rich Felker <dalias@libc.org>, Thomas Gleixner <tglx@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>, linux-mm@kvack.org,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>, x86@kernel.org
Subject: Re: [PATCH v2 0/5] treewide: remove unreachable memblock_reserve()
 return value checks in early boot
Message-ID: <ak0BycosiHcaZLqg@kernel.org>
References: <20260706163753.193875-1-ekffu200098@gmail.com>
 <akyZ5DhIV_Grn1Kc@kernel.org>
 <CABFDxME7ig1SQDB39TUeUXoAOA2jSRhg6h-bm0kUHrHzGYeE-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABFDxME7ig1SQDB39TUeUXoAOA2jSRhg6h-bm0kUHrHzGYeE-A@mail.gmail.com>
X-Stat-Signature: cx56qxuaca8x38ueef3reb7k355pt9nz
X-Rspamd-Queue-Id: C944DA0005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783431636-821143
X-HE-Meta: U2FsdGVkX1+Txpb2SyyO3nz1QHiSqMVS+5RJbUQFACHX2X+eoC1vaeZpwSHNYvKXWjWflrSmZTWxNfh9HltSV70dmtOb2nE3DYbuQM5awnDQJPVEUQFAtg62Qzmj+ST6mFQf4Lh0k7dTy3ntGNHEuYTzsS2ADemohDetsmiOxDRmiCT/pSWw4ZWI++Q3Xw2TwBqlqjbl5tFCqkdO9O93IUbDTENSpQsRrKKtOmeC0Xv91612/1y10Uv9BDmhJ9NKjtZqwmELYhuSVG8G1ApuQlVi6fiDYm84zfDinQ1sY6ex93JFYZy2/LKjph9w9njlFhEjPGqfLjZJMZaE5097Eqw2rAOcIRXfCVqHbt1T+u7B1FwER6RqyyQpGaQ99hPc9dF5UNBdqCc4ZsBxSrV1oQ/YU7DeiUh/rjYZSHyo7fSEsG/JGpE8gKzQrJeSXV5Uh6lyLqGPVmGbhtwjxnssuoKo878ZQfkzX99f6PHvNQHKxdhq/REQAWXtFY8trYV1oKfb0pAvU69qB/EUd+tyVrjUWtqvXyB7T6Ep31g4GsbMgRWgraNn83DQlIskpfArb3LS+QfdGocyILCh27Veo5Ji7+PVP0zmICVoJoapqnGgrvYw2GcV5DpIupjnxSGyUFjalunmjgrODc+zPfAmuxPS0nogS4p5V/gtohMZXSGo+KUGDxNEa8zGCVLEWE3JwlSHl0xDDL9YPmTEHK5CEXvrlvFpr2RFIjDnMLxI4BjcmJamtLokm3iuEF+wHBAk2KP77AcHH4ZfAT33SQi0S0+48YiJMfpFFti0/VxHWJ7IrBTAAVVw5B7uv0/Pf5sFxouiKlzXsgd3X3WkwlSlWehSWqq3u9RWx1qEhnAkMlclIKat+wX6hDJJ03CeTRZxUPsblgN47Fqt39itSJbRVoGBTrR9SALOoZgjFdqN1SH/6IqMtDumG9ZsmDQIDyW9DprNVqWP7OW5Y1g9Cs6
 VfTH6OnK
 oOX9D5XeiTpRYh+DaNOE4TJq0TGsdf1o1IOIVfR1CNi+pa9+1+X2e8i8kcyNe3KsrBpo89JPYbkVoY4vMx0XntcoeoTQmyR1koevXlIzZRHtICHCqH42pO5Sd+6uHMHWsLvpDCz9/vEwUnkLFGbOegazWh7zG+dnqmZKIcGftbJ/ejvCEeRI7VJaZPDpv/1WEedAXFunIaI0x9LAKzIUgSX6jF/YQVMBSkZDP7HQhp5iuEoAll0vzhZqeTXOwdsX3JZhw70/aRtokUh0p3sxcAFPYhXkNZdI/mhPskkNJl71vFrj8nKBpKJpkEU2fVK7d5mRLQQBtURR76UA71O5UjErMZQebAtMNfxbz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 10:24:09PM +0900, Sang-Heon Jeon wrote:
> Hi Mike,
> 
> On Tue, Jul 7, 2026 at 3:17 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > Hi Sang-Heon,
> >
> > On Tue, Jul 07, 2026 at 01:37:48AM +0900, Sang-Heon Jeon wrote:
> > > memblock_reserve() can only return an error after memblock_allow_resize()
> > > has been called. Before that it either succeeds or panics, never returning
> > > an error.
> > >
> > > Before memblock_allow_resize() is called, the return value checks of
> > > memblock_reserve() are unreachable and can be removed.
> >
> > I'd rather keep these checks.
> >
> > Removing them relies on internal details of memblock_reserve() implementation
> > and the existing event sequence. If the code would move around relying on
> > panic in memblock_reserve() may not be correct.
> >
> > And the few bytes and cycles the change saves do not worth the churn.
> 
> Makes sense to me.
> 
> But most early boot callers of memblock_reserve() don't check the
> return value, so I thought we already rely on its internal behavior
> anyway. So the few remaining checks just looked a bit inconsistent to
> me.

In reality it's very unlikely for memblock_reserve() to fail, especially
after resize is allowed. 
And if it does fail, the system would trip on a memory error, usually
sooner than later.

> Would you still prefer to keep these checks? If so, I'm fine with
> dropping this patch series. It's not a big deal :)

Let's keep the checks as they are now.
 
> Best Regards,
> Sang-Heon Jeon

-- 
Sincerely yours,
Mike.

