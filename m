Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBE42CCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 06:17:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F0238E0036; Fri, 24 Oct 2025 02:17:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C7F18E0002; Fri, 24 Oct 2025 02:17:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50C518E0036; Fri, 24 Oct 2025 02:17:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 405FC8E0002
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 02:17:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E4221128ED0
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 06:16:58 +0000 (UTC)
X-FDA: 84031999716.09.C145076
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 509CF8000F
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 06:16:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kB1tTKiu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761286617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m0AcVAtlQf30OS10e7TvuivPvYIb9Yaf/5uhHu+5GdI=;
	b=XUWmQvX1+h3g9LweaMuIGNu7ZTaPxM99WQADnefc/WARS9BhFglVgzy/1dLz3A+K8oGAMQ
	2FuOPB0YxxGUGF0v0AY5cg7Bii1rn8q052+RNKut7ft/hgTErR6jqtFZ43x0HcaD+wvitM
	nOtczW9mfCQzt/LBIUilk/x5OvP7xOE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761286617; a=rsa-sha256;
	cv=none;
	b=cRFQ90ELP4/xrHk9ofG8O2E2fzdEZ065njjhSDWN96tKAcW2mT2BlfDsxQnZjH6XqPNugL
	Jg2Ib7ButqSe2BgWx+2Ny3s9IwAUW4lf/V0vCCCPfRS+Nr/cmbpZkpUlDX7uv8UO7dlNlx
	o/JzOKXKaJAhonbFgmbqq58a6+bzxWM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kB1tTKiu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 064BC452CB;
	Fri, 24 Oct 2025 06:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D15C4CEFF;
	Fri, 24 Oct 2025 06:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761286615;
	bh=J6WIkfXnPdWT+D0UqznjgN5ZqG6M9x/P4cC88zuW9ms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kB1tTKiuaZ4sHGOEBDene7o2a9UDxqLw/HjLZkhLhd9Dy3QAwHrIDBNiFftVHcdJo
	 gyuh9gdj92162HPyYBXCk8QciuYLejTYCOBQQlaVuMoiC8YPJ5RI9RKQPeUGwaaIgC
	 dydI51f47MEcnCighnQ+DsimDY2nqtrL2Z05UphmwfViM4gCdzYZuz/grMedBMzhLt
	 ErwD+OnIslmYeKISIEIWpjlV3VND5nxE7macxEFFju7EVaTllwmcYWt3VPlJkM6+ml
	 gUgQRR02ohL5AmMghYoAEe4dPh1O8pIzyDGn5TLhR0LGUlUOTxqnZeWZhcNkdzXgnn
	 J0TRiOAxRgm+A==
Date: Fri, 24 Oct 2025 09:16:47 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, akpm@linux-foundation.org,
	brauner@kernel.org, corbet@lwn.net, graf@amazon.com, jgg@ziepe.ca,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, masahiroy@kernel.org, ojeda@kernel.org,
	rdunlap@infradead.org, tj@kernel.org
Subject: Re: [PATCHv7 3/7] kho: drop notifiers
Message-ID: <aPsZzxmGjrJSzB4q@kernel.org>
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
 <20251022005719.3670224-4-pasha.tatashin@soleen.com>
 <mafs0ikg7fbez.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs0ikg7fbez.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 509CF8000F
X-Rspamd-Server: rspam02
X-Stat-Signature: 5fwdmzzjeh5hjt1gp3pdgs6zespxot4r
X-HE-Tag: 1761286617-772525
X-HE-Meta: U2FsdGVkX1/61f1s93sgTbzE/EmIV7gFBA3j+4xgUCvRY9/bsZz6MN3wMLbKXKq+hG0Tr7q1B853PaARBk/hf67+kbkBSG1e0oax2sMAcg8Izair3qw0+UJdmfwEyJucs0jrQTHp4emo8UxG1fiUfQL9ybSy+PC2Gih6xpngqRkhwgb+03FLl7jctSKEzfpmbNdlkpwpfma4sCIytqG3DIecUmVUJouCj/QR/sFX60xnLjW/TH9Wkf6v/Aa5khb1DbApeRymTcEx+mtUR+vPbdTU6TUqHfyDF+dJ1qRQ4DDiJDAr4XMZWU3zsefBM6Kaehow2CZiNiStHjRi6eWWkYrJbdJOI9IjhL6tMjZDW7SiqbgvgG58mCPgaBKobyYlaXeHCJ6F58ZzbgyAQgXm5R2xqHIl8WvegH2QaI+2MEiEZcP5EmBzauJVX7Nw0MXcyE6KR9VzG2KKrd2UG6LjnWUcVp6dcnOevQcKbLFjzpV6CgC7cclJVB3I40l2gfV5g2+CEG21eKRtI98fKEwmy28wH3AlXZJiz1C3rl+zHigZWk8eSk1vQFNBI9v2+coNXKZHskDQkhhtxEqau1ZZif0Y3lvOg/FkKUvg9uTMqXN5FlrUlkKoYre+lURtQHH+UhMMkHPZDzTboLpNxP/ItKV8iJeDfLquW17qlEykCkreTvP0RUokA8VprFS1fCQcQMkaV/Y/dsgsBe7I+lV8yk6cy94HTIB1MC9egHHa5ECIBR711WGhjFaI/uk+Q8vEdDFv8ywrOvKwzZRqfVvu87IWLe1fNPF4JsISyODjoF5N99BVWWt0SmM4nbJiZ3FUWaywM/ocnfIhPFa6S1PaKmhUXPhQCAQPx7egl/2FJw1bwyCeZPKlp2LkTRxs+tnedr1IJOXRp+nRVo1BXvWFZhBMGR/PcctFmaf378IMRALRMIAe5cC9L5JnFr13KpFJUL2K63pLsC+Z4vulbrv
 SqRWWjAo
 ursEcLkmnlvmW8WTCXuZFq3h31KHNG6kRQy/xi9ZceI0rFsVETGTJNrciSck5fx7ItWtRWAXHxZ29kEAirP1p1fTkmInoUyTbfd9DnyN7PMnYxrXwXuHh2yn4AsHumV+lZIZAthbhMU8b8dLlzhoZWaizEEyHiXWoZq74n3uh9/vs6+yhoJgiE4mmI1+x7Sm+N2C2XMylcbudnl/sOn2m3lzuU54Kzk67JPo3RHD4aTM6i9vqjfbXPcU1KziW6U/vInjrqVVTPU93p6DijiH/LjINAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 01:01:08PM +0200, Pratyush Yadav wrote:
> Hi Pasha,
> 
> On Tue, Oct 21 2025, Pasha Tatashin wrote:
> 
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >
> > The KHO framework uses a notifier chain as the mechanism for clients to
> > participate in the finalization process. While this works for a single,
> > central state machine, it is too restrictive for kernel-internal
> > components like pstore/reserve_mem or IMA. These components need a
> > simpler, direct way to register their state for preservation (e.g.,
> > during their initcall) without being part of a complex,
> > shutdown-time notifier sequence. The notifier model forces all
> > participants into a single finalization flow and makes direct
> > preservation from an arbitrary context difficult.
> > This patch refactors the client participation model by removing the
> > notifier chain and introducing a direct API for managing FDT subtrees.
> >
> > The core kho_finalize() and kho_abort() state machine remains, but
> > clients now register their data with KHO beforehand.
> >

...

> > @@ -1280,7 +1298,7 @@ static __init int kho_init(void)
> >  	kho_enable = false;
> >  	return err;
> >  }
> > -late_initcall(kho_init);
> > +fs_initcall(kho_init);
> 
> Is this change related to this patch? Also, why fs_initcall?

memblock registers sub-fdt in late_initcall(), so we should have the root
fdt ready by then. 
  
> -- 
> Regards,
> Pratyush Yadav
> 

-- 
Sincerely yours,
Mike.

