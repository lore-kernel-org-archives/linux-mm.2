Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97AB9CD4F4A
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 18:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1ABD6B0005; Sun, 17 May 2026 14:36:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACBA16B0088; Sun, 17 May 2026 14:36:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BB106B008C; Sun, 17 May 2026 14:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 855F96B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 14:36:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4557340677
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:36:41 +0000 (UTC)
X-FDA: 84777767802.15.9DA96D3
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 62F82160006
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:36:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LXuwhsww;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779042999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lirFWsJ5C0bTd/R7aKsYhvTxoj04iUNEXEllFWQcIOE=;
	b=nXvkuH3gUuTngAk97d72x17ecq1dRm7YMkB33YGNomBF1EGxulsCcSmUzyV4k28UpwxQnn
	63tGBa1oB5P/vuHHgKSj9X3/zTFYXa2YPYnVhY+WvVMDCM31ULJfBv+5RhKHHUENhvuHiF
	uBaCuqqwFuax9ZufplmPkaijdIvz6LI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779042999; a=rsa-sha256;
	cv=none;
	b=0iejZroA6SeseNvuerwRbBhUqFZLhQxmwGiFTkZtSLAKr68QYkLfoS6YS+HNAQ36SCAyN9
	gnItNYxsgfkYuNOETWkkiqUy/MDnn+8kzkiyqsEgbPQIn4HTumhgET5j5tSgSKCHp3adlT
	mWoxEShhTNMEFUAfE0lnNs9KiecPKe8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LXuwhsww;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-91080895355so200445685a.3
        for <linux-mm@kvack.org>; Sun, 17 May 2026 11:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1779042998; x=1779647798; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lirFWsJ5C0bTd/R7aKsYhvTxoj04iUNEXEllFWQcIOE=;
        b=LXuwhswwMPbkFq8/eaj1pNOEXKb6QwUr8zU+nLDj1c/avHvZZ/cA83xaKj+DRHNLVq
         NYQ5khpSTVnMiZPN5NLwmda45WQKYHx88/vrRhtgal0hL1hNmHGXpcEbugVv97sXMASO
         AnvZw/ppJIFpA0xjViB6t9v92fR/a0IJ79ENp2lDoep13Xh8luSUMe5OOt4usV1Fgqmi
         2tGpgArDNNRiu8Ysq705gP7+RRgUk1jExwesVnNH/67CdfrRt0SqMwJt86MM1shrvPfm
         PZSxV4bwslKVU2fzJxcqY9qGcZRbt7b4uIsHXUq84HCZ0CYGob18H29u/znPkXQtdJf2
         oyaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779042998; x=1779647798;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lirFWsJ5C0bTd/R7aKsYhvTxoj04iUNEXEllFWQcIOE=;
        b=gNOhGAZiqEPx9o0qsjJHM8WSyDg6kNgicCmAmATAUloSOUa2Bc7mL1ENWHju7lMzVC
         0S9oodEDAzkwsRn/sTnJWrVXck/xQXVXJ22BtBTW7oUnIYUkj03KLwy0QyayBN51JFn0
         lT4o/rFS9kBuAcP2ZLpNmGEaEVnvsL11NKHv3ruDTqbGMpRYvpj4uJ7wW5sGRX2zaYtu
         MPH9R1i+PzTk+yNWIFAWh48MaPMsSUsHH9g6a87Kna68pq8poi3NOztfWQ0yoefMfb9N
         Qz3AFayAWhn/guH+kBK54t/J/GNxdk1E53yh6NfytGGTC1h3DCpmX+mrzRj6DfikK6vr
         shdg==
X-Forwarded-Encrypted: i=1; AFNElJ8qLbX8TWhpbI81BVc3KkWpu3gkKtPUpyKvAVQf7nY5kfgTwFmoj7RX77mYdsscUVF78i0YmiqxrA==@kvack.org
X-Gm-Message-State: AOJu0Yyg1PB95ujq3SwMLczL0MwOs/fg93uE3QD5EPLgtTVrdVnfmgJF
	n5iCfX0YY813QM5Ctx5a3088rnfKdTKMi+4CnBC9WzEe98CzNfhAwgEIuaYyOf2OKHE=
X-Gm-Gg: Acq92OGccagnAL4VrvECQXyc4U+QaJ5EJht6h5jrd1JkwmPvWM+eDUbFk+kNNmEaGBp
	QtHYDRxby7/zcbZ6KQVYMWQSXD6R4SG617uffK8LuqXs5t7iL6nv3KocuBH953/5GqMyvyTkswy
	b5igKSNnuLioSIliuNZusPrhBoJwCCut7/gtwyV47rbpB8v1/CaItqpdek+/26PUm/m+okLWSAC
	+AO1sBHU0CBvGATk7zu6yTnYsvFoVrGxPbp8FLxWK9MkNr3M0VHBURtWMi3+ESiHbr6p3Ui+lNJ
	tqk50cDYbH8u+SlN27XD7bnPF/g7diYDXfhtDljn2hdWbkYkb0Fa13moSSzf+/THv+34bn/D6Aw
	rKEdEcEkTALqdXHPDp49ac4UZyx6Of7Ifp8bS0Yj48iuV/8syNPQXPLnYyojHtxbpZsqW8N5jt7
	ljTR2BTw4rmhgSs1WJO55d4Sm9qK+4FBEKVfCrZ8pWU+YD3dTnOJ8=
X-Received: by 2002:a05:620a:6cc6:b0:911:a9e4:8b04 with SMTP id af79cd13be357-911d1042fc0mr1877269085a.62.1779042998343;
        Sun, 17 May 2026 11:36:38 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf3584esm1221812385a.34.2026.05.17.11.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 11:36:37 -0700 (PDT)
Date: Sun, 17 May 2026 18:36:36 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	corbet@lwn.net, dmatlack@google.com, kexec@lists.infradead.org, 
	pratyush@kernel.org, skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH v2 01/10] liveupdate: centralize state management into
 struct luo_ser
Message-ID: <agoKAw9CQIVIhp2b@plex>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
 <20260514222628.931312-2-pasha.tatashin@soleen.com>
 <agn4z5ZrFBi9AIGw@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agn4z5ZrFBi9AIGw@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 62F82160006
X-Rspamd-Server: rspam04
X-Stat-Signature: pn94ggqfmsy1xyrngu465bwdaxifmgqn
X-HE-Tag: 1779042999-50739
X-HE-Meta: U2FsdGVkX1/a8Ig9ZOthpzAMK+v7d8q0fEKCZbCHHAV8CPFjJW8MB3V7kup44HnIQW2eHP9Oz6+AfllRcuyes8xyYNyVR5qGkMDc0xUHFmE9zsp+Cb/ujKMW63yNsoIVCSPQLVIe0UkOyzlHSf+Ugxj1Fo4nuFMrJtDhMhs6VQ1VW5KtfGxp0ijnUsEe32ncNfUSqIDNi9mi8F990ruY7nfC5oVTm3nNLdUmexWExlSuyeaAL/xeDdoJBMIqFlpOfjsGdkA4Mp0ad5A+ahNbHiaX9gLqfHMMvk33ad1gejKfxvWokuDvulOgXxhea111pqIYz4Zf/Mi5V45cpMW213M9koTSm7fiiDifJHO4y5oEKxO0Qmf9dAk5MbWGjC8WTq/fAU4xYADhSdrFz9RcA/R7fhjv4HKIMItzoZeunNb/CinFvicvG94W+tDnkbq11PUY9wVg8Zda0ZpCXO711nblw/I52lottNraB16k+2WO5EEvm/XmvG35L17MDztrRvECu1V5Ls5EF5OVKvM9ro7Bbma7yvMT1xHDD2TZTAl5gYHJlYHEgfbrKvhVBE7p5PM31EL8Ixr29RnFw2XmUQVuz4nRScN88AzM8CG555NJD21xHOD/BbfALV8QaZD383wpmFwshcME0EFlxapFpKk4Hv5v0RLvkuHwvm2XFGPpe989/daFfQi9cqGP5hy0/lD8Z3ibBXrPCQsIKB9tU6XHSQ/DWkycO4gNfoBWDQU96vDDkVVZJFAoJRROGStYGV+tNbSXO9rOa9ERnsSsXOIzAubnw+SpJ94gBFA94BBtxLHxmwPHdD3f5FDe9RpQdfwm9rCpe9B+PDemjCUIQS/FEH1FE0KFaIvvG3Y4Uvfn53rHcvZBRv8DHldZ5uYGx1rK5GycRDWnA0w7kulbLm+5Y6HDhDlM+MB886GsLP6e+1X/9aNLwd//x64QGnlRyCKSf5EkWJvLtZmz4Ji
 1eaXYJLP
 dlvOd/QXfggNrswTubus4n3KXy1ciOVG5B085CITGt7GPC7+bsAAkaO12xdKydjPwHhVjI6Euxt+ia/HtQD7jdiHKnlJnyMXU3twWTJ4xhPHxokSJv4A5L5iy49YEXHsgq+/3P0TNNXK4+EdVzEo9RoTxa1Q5Lb51eJmc6ikUOxjNqujEBeoWJDqX9gwoYnChnnCD6Ox20Iv6v89DmWZe3lnbqzs0fst21NrlYPmUqYzzmyTWXJV5cGcHV597LsUecfNOl71NpdLZBPDj/2AnfSOGOccFP8Q9G2jYQQjNSNov7Q6563mmyZzBIlEu53IGenZhA0k7w9x4bxw9tciLrOVEVmtiZT94JHSjAYg+lW34nRgAUJHrXsvRz2rn4D6HoHLcxQU8GNt68pYf+AZwT/LuyMHmuhKPGppfCoTbHsNIB8PSXe0eN8Hqp+CFlMTO5axzx0QEveQFEDTziNHtvukbcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-17 20:20, Mike Rapoport wrote:
> On Thu, May 14, 2026 at 10:26:19PM +0000, Pasha Tatashin wrote:
> > Transition the LUO to ABI v2, which centralizes state management into a
> > single struct luo_ser header.
> > 
> > Previously, LUO state was spread across multiple FDT properties and
> > subnodes. ABI v2 simplifies this by placing all core state, including
> > the liveupdate number and physical addresses for sessions and FLB
> > headers into a centralized struct luo_ser.
> > 
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  include/linux/kho/abi/luo.h      | 91 +++++++++++---------------------
> >  kernel/liveupdate/luo_core.c     | 59 ++++++++++++++-------
> >  kernel/liveupdate/luo_flb.c      | 65 ++++-------------------
> >  kernel/liveupdate/luo_internal.h |  8 +--
> >  kernel/liveupdate/luo_session.c  | 57 +++-----------------
> >  5 files changed, 93 insertions(+), 187 deletions(-)
> 
> This looks lovely :)
> 
> > @@ -115,27 +117,29 @@ static int __init luo_early_startup(void)
> >  		return -EINVAL;
> >  	}
> >  
> > -	ln_size = 0;
> > -	ptr = fdt_getprop(luo_global.fdt_in, 0, LUO_FDT_LIVEUPDATE_NUM,
> > -			  &ln_size);
> > -	if (!ptr || ln_size != sizeof(luo_global.liveupdate_num)) {
> > -		pr_err("Unable to get live update number '%s' [%d]\n",
> > -		       LUO_FDT_LIVEUPDATE_NUM, ln_size);
> > +	header_size = 0;
> > +	ptr = fdt_getprop(luo_global.fdt_in, 0, LUO_FDT_ABI_HEADER, &header_size);
> > +	if (!ptr || header_size != sizeof(u64)) {
> > +		pr_err("Unable to get ABI header '%s' [%d]\n",
> > +		       LUO_FDT_ABI_HEADER, header_size);
> >  
> >  		return -EINVAL;
> >  	}
> >  
> > -	luo_global.liveupdate_num = get_unaligned((u64 *)ptr);
> > +	luo_ser_pa = get_unaligned((u64 *)ptr);
> > +	luo_ser = phys_to_virt(luo_ser_pa);
> > +
> > +	luo_global.liveupdate_num = luo_ser->liveupdate_num;
> >  	pr_info("Retrieved live update data, liveupdate number: %lld\n",
> >  		luo_global.liveupdate_num);
> >  
> > -	err = luo_session_setup_incoming(luo_global.fdt_in);
> > +	err = luo_session_setup_incoming(luo_ser->sessions_pa);
> >  	if (err)
> >  		return err;
> >  
> > -	err = luo_flb_setup_incoming(luo_global.fdt_in);
> > +	luo_flb_setup_incoming(luo_ser->flbs_pa);
> 
> Sashiko asks: 
> 
>   Is there a leak of the preserved luo_ser memory here?
> 
>   The outgoing kernel allocates the header using kho_alloc_preserve(), but
>   luo_early_startup() returns without calling kho_restore_free() on the
>   luo_ser pointer once the fields have been processed. This results in an
>   unreleased memory reservation on every successful live update.
> 
> This seems preexisting, and we probably don't care enough, but still...

The freeing happen during finish, that was by design.

> 
> There were more comments by sashiko, didn't check them yet.

The other comment is stupid: yes, changing ABI prevents updating from 
older kernel.

>   
> > -	return err;
> > +	return 0;
> >  }
> >  
> >  static int __init liveupdate_early_init(void)
> > @@ -156,7 +160,8 @@ early_initcall(liveupdate_early_init);
> >  /* Called during boot to create outgoing LUO fdt tree */
> >  static int __init luo_fdt_setup(void)
> >  {
> > -	const u64 ln = luo_global.liveupdate_num + 1;
> > +	struct luo_ser *luo_ser;
> > +	u64 luo_ser_pa;
> >  	void *fdt_out;
> >  	int err;
> >  
> > @@ -166,27 +171,45 @@ static int __init luo_fdt_setup(void)
> >  		return PTR_ERR(fdt_out);
> >  	}
> >  
> > +	luo_ser = kho_alloc_preserve(sizeof(*luo_ser));
> > +	if (IS_ERR(luo_ser)) {
> > +		err = PTR_ERR(luo_ser);
> > +		goto exit_free_fdt;
> > +	}
> > +	luo_ser_pa = virt_to_phys(luo_ser);
> > +
> >  	err = fdt_create(fdt_out, LUO_FDT_SIZE);
> >  	err |= fdt_finish_reservemap(fdt_out);
> >  	err |= fdt_begin_node(fdt_out, "");
> >  	err |= fdt_property_string(fdt_out, "compatible", LUO_FDT_COMPATIBLE);
> > -	err |= fdt_property(fdt_out, LUO_FDT_LIVEUPDATE_NUM, &ln, sizeof(ln));
> > -	err |= luo_session_setup_outgoing(fdt_out);
> > -	err |= luo_flb_setup_outgoing(fdt_out);
> > +	err |= fdt_property(fdt_out, LUO_FDT_ABI_HEADER, &luo_ser_pa,
> > +			    sizeof(luo_ser_pa));
> >  	err |= fdt_end_node(fdt_out);
> >  	err |= fdt_finish(fdt_out);
> >  	if (err)
> > -		goto exit_free;
> > +		goto exit_free_luo_ser;
> > +
> > +	err = luo_session_setup_outgoing(&luo_ser->sessions_pa);
> > +	if (err)
> > +		goto exit_free_luo_ser;
> > +
> > +	err = luo_flb_setup_outgoing(&luo_ser->flbs_pa);
> > +	if (err)
> > +		goto exit_free_luo_ser;
> > +
> > +	luo_ser->liveupdate_num = luo_global.liveupdate_num + 1;
> >  
> >  	err = kho_add_subtree(LUO_FDT_KHO_ENTRY_NAME, fdt_out,
> >  			      fdt_totalsize(fdt_out));
> >  	if (err)
> > -		goto exit_free;
> > +		goto exit_free_luo_ser;
> 
> And here we also seem to leak memory allocated by sesttion/flb setup.
> 
> >  	luo_global.fdt_out = fdt_out;
> >  
> >  	return 0;
> >  
> > -exit_free:
> > +exit_free_luo_ser:
> > +	kho_unpreserve_free(luo_ser);
> > +exit_free_fdt:
> >  	kho_unpreserve_free(fdt_out);
> >  	pr_err("failed to prepare LUO FDT: %d\n", err);
> 
> -- 
> Sincerely yours,
> Mike.

