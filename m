Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDCCCCD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 05:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 293608E002B; Sun, 16 Nov 2025 00:47:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243888E0005; Sun, 16 Nov 2025 00:47:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 132DE8E002B; Sun, 16 Nov 2025 00:47:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F32298E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 00:47:07 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7DD54C08AF
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 05:47:07 +0000 (UTC)
X-FDA: 84115386894.04.652E48A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id DD2AC180005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 05:47:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f3PCgUrw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763272025; a=rsa-sha256;
	cv=none;
	b=pzN9yYpv20TIl1UBi4NJ9bxorwUx8rt4U70vk/UKPvFOtw7Y41i4L3LjYqdQcRiLcH6d1q
	6L+NqselTJsPauEgAtRUWsO19WW6cGCIKS6dnXGpou9/ZpLF6JGNuBzaDGWcHrx1AIRFrJ
	OgPu6tIBr22Kgawi/8n8L3gVdW+I2C4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f3PCgUrw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763272025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pjcLQP3ZDHp6twNylqR3Sw+tWbznJ8lJtAsn5ePnKEo=;
	b=DtT6Z7uXom4E8gHoH5aRVV7uhRz+4iJZKjbUcvcqaHBHo+26utaCCY1mmA63nsd6erQBlZ
	r3ABG1tGumY/eSOk6yt/5vi2G8s00magS6+VSTzs+aLc8QrG801HH8cUxRSO6VWjFECZUS
	xgmLQ3KSVIooFIPi0ntq4tkJaICmLyU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B5B060183;
	Sun, 16 Nov 2025 05:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BC3C4CEF1;
	Sun, 16 Nov 2025 05:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763272024;
	bh=VhOMKlmPNnj++jPAfsYIirLTiTxgnvzCapK9dNUeqh4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f3PCgUrwougN1zKXC/ev3tHuCXsaagLLqRXl/9tu2Vy+Q5BYNo60sdkckcgpRRkRU
	 QW4GB0Kd8l9K7CfxK6inwHkofGiAJW4FCHeX9iPcQVgo/2k1VUB/URuLhPJUhHeJMH
	 XjA7bpDP3ojHGNPeh2+YxcLCr3gLbA6dhQUbSqLpXKPoR8yD9tLi8PcEySBcqGGArm
	 3AwRNFOA6U+wc6hui7nDl+xEkKE4EQKLe51hmRd2T41pI/OG+VIwz3wOT+ChDSUKpD
	 Ze0N7ubs+fQL1k5c6JGtCaiVCWqdgSyrp78MXINMZtvweJweSkHQWElSAcwwUKdIY0
	 MZcJyLTcQl76Q==
Date: Sun, 16 Nov 2025 07:46:56 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, bhe@redhat.com, jasonmiu@google.com,
	arnd@arndb.de, coxu@redhat.com, dave@vasilevsky.ca,
	ebiggers@google.com, graf@amazon.com, kees@kernel.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 10/13] kho: Update FDT dynamically for subtree
 addition/removal
Message-ID: <aRllULpK1wxZyY23@kernel.org>
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
 <20251114190002.3311679-11-pasha.tatashin@soleen.com>
 <aRhKeXM5iAswD7oe@kernel.org>
 <CA+CK2bBnEKk_mQOCfDhnqbUCovLCKhFw-p54Q4_Sutk4oieOVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bBnEKk_mQOCfDhnqbUCovLCKhFw-p54Q4_Sutk4oieOVA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DD2AC180005
X-Stat-Signature: 1sxseep9wwjazak8qsfpogcquuxktah8
X-HE-Tag: 1763272025-167314
X-HE-Meta: U2FsdGVkX1/i/14ISfrpqqrTuoLMEqBV/Sk94jv6nPv2nU2++EVj3d9kktzlGNZ7woSW37+zIfEKcfbnSFMTRlmXOiA/zTttqwxMOiR9y5mJIFHFt1qSaDbTyuvqO8IbZC9olj+iPW8Yiham32JPQ6ZGtUhBFXEhY+yItjOgKxVrTKcgBnKzyHE7lIHkj5vixuIEe9F+BaC+eQa8ynvd9Nh17Jn8PH+bAgfWnzz6EA3HSPjLJlcEG7+yuoB+p05Ou8cTUeU0UR2oC9wiPlkBGRCxLMMOecW01k4n4xitRnYsDAF8oL7vCfhyqcC4/yF76KZw7eWKwgs/0+Rs0AyESI1nJo3cLYhvRrMjA0v6i2pHgr5g+0a0j9T/gZudz7V6ijYKOS6Qdmnp/8xmlEgCUUtbL5FIf13naf3zgdIU1nwByh11cMu3GosXsXlyIniIrR0kFDXHOKPM3q8C2ZFvCukRxzq2RZiE3up8kvBGVDP7GUxnPzKq6RbkjkPowAVCVWNLt0u8ngEiZ5KZoXmvshWPK98dXQt8Vr7MU02EOPoL7hmPKR2+pVMIw9xu1F6ahmTgCmW8RX0WtNs1/PBpEiOZs5HZTVaDwCnGwnrxpNw4JlERsGGiqx5h3oykUaR1Ptnsu5bI7HldfBiLsR66l3KSeTI5vweHiNI9welzs5yXjZRl+000xAp+iprpjy5SOBBtXDq6nYNSxteXDSWPcY58mcz+964vXOZRinTC7ersh3Zt0RiOIcfWvLxRdTVV+7Q8IUxhZWZmdBVdnXu2Dbtwao3+wXmg36TPhYi0p5hudOS4hCBK9plRHbx8iKLSRpfUNEiamap8tWx2D/kNCQ77wwroNV99wr28kUicgjhqHmevzhbGgL0vJrLbFEUp1Jlr3sV1mA0daGn8vDEPyRuXbEhc3dvUoRW+/fT7hxp58eeErGVFn0Lld3DVAZ9XdwWY6cvFQtteBGEdno6
 b8IeR7Zh
 iLepD1cd681rT3YuRH37CUk9gNakMZuEIWqQ49pI67EEDH0D4yw08zBjDbnRKqV1U7ZHWPZGySGj+e5vBbur+x3DFjh5YGCKKO2QsANdQzbeoBwRMt2hhL5asS/ZTXfWFYaVdkUD+p1laWmN3mToSkUb4fDlvtiikq87PuQUmiU2+j3kZCo1rILBBdkDB/3VLiv9pUQrKOkBYAGb2P3RmsnwR4nyL29TP4pDRrhfDw8ux9KFrFRTPfQyMoANxb92kq4PvW1DryYdqddo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 09:51:07AM -0500, Pasha Tatashin wrote:
> On Sat, Nov 15, 2025 at 4:40 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Fri, Nov 14, 2025 at 01:59:59PM -0500, Pasha Tatashin wrote:
> > > -     struct kho_sub_fdt *sub_fdt;
> > > +     phys_addr_t phys = virt_to_phys(fdt);
> > > +     void *root_fdt = kho_out.fdt;
> > > +     int err = -ENOMEM;
> > > +     int off, fdt_err;
> > >
> > > -     sub_fdt = kmalloc(sizeof(*sub_fdt), GFP_KERNEL);
> > > -     if (!sub_fdt)
> > > -             return -ENOMEM;
> > > +     guard(mutex)(&kho_out.lock);
> > > +
> > > +     fdt_err = fdt_open_into(root_fdt, root_fdt, PAGE_SIZE);
> > > +     if (fdt_err < 0)
> > > +             return err;
> > >
> > > -     INIT_LIST_HEAD(&sub_fdt->l);
> > > -     sub_fdt->name = name;
> > > -     sub_fdt->fdt = fdt;
> > > +     off = fdt_add_subnode(root_fdt, 0, name);
> >
> > Why not
> >         fdt_err = fdt_add_subnode()
> >
> > as I asked in v1 review?
> >
> 
> Oh, I missed that, there is a slight difference between the two:
> 'fdt_err' only contains FDT return value, i.e. error if negative. The
> 'off' on the other hand in the happy path contains subnode offset, and
> contains error only in the unhappy path. This is why I think it is a
> little cleaner to keep different name, however, if you still prefer
> re-using a single local variable for both, this is fix-up patch:
> 
> diff --git a/kernel/liveupdate/kexec_handover.c
> b/kernel/liveupdate/kexec_handover.c
> index 224bdf5becb6..81f60ccb2dc7 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -713,7 +713,7 @@ int kho_add_subtree(const char *name, void *fdt)
>         phys_addr_t phys = virt_to_phys(fdt);
>         void *root_fdt = kho_out.fdt;
>         int err = -ENOMEM;
> -       int off, fdt_err;
> +       int fdt_err;
> 
>         guard(mutex)(&kho_out.lock);
> 
> @@ -721,14 +721,14 @@ int kho_add_subtree(const char *name, void *fdt)
>         if (fdt_err < 0)
>                 return err;
> 
> -       off = fdt_add_subnode(root_fdt, 0, name);
> -       if (off < 0) {
> -               if (off == -FDT_ERR_EXISTS)
> +       fdt_err = fdt_add_subnode(root_fdt, 0, name);
> +       if (fdt_err < 0) {
> +               if (fdt_err == -FDT_ERR_EXISTS)
>                         err = -EEXIST;
>                 goto out_pack;
>         }
> 
> -       err = fdt_setprop(root_fdt, off, PROP_SUB_FDT, &phys, sizeof(phys));
> +       err = fdt_setprop(root_fdt, fdt_err, PROP_SUB_FDT, &phys, sizeof(phys));

I missed 'off' here, never mind

>         if (err < 0)
>                 goto out_pack;
> 

-- 
Sincerely yours,
Mike.

