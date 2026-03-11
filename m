Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3266E1062894
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 12:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1748D6B0005; Wed, 11 Mar 2026 08:45:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11EAF6B0089; Wed, 11 Mar 2026 08:45:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 016D76B008A; Wed, 11 Mar 2026 08:45:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D21D36B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:45:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 71A6A8889D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:45:43 +0000 (UTC)
X-FDA: 84533753766.01.EA32574
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf12.hostedemail.com (Postfix) with ESMTP id 60D7440006
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:45:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="VT/3kzUi";
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773233141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yP/ZBBLN23AWwEEAdVB0ZzTgoRWK0abJkbcKiseHvC4=;
	b=Qu3/IrEoNpLowEHNysjqt6STNyuwU4BThhLGoMSLfkvWl0tGvDdpB8SPZDhTi0G7a0YqvE
	KXrly15Y2l4GfN6gx8SveKbEsufZkzCJxRbwwnkmfNlEjm7RRdwugVrRsfi2MwSxMLC2Vf
	LaiJiBDhFz7itBI6CQoeuca2wzqeHnU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773233141; a=rsa-sha256;
	cv=none;
	b=W2qB7LTEGYqQs+pK8+qxDdOGeyny3OrCOM2UAI0xagdHK0EYhOusEFVkDAGMgqtPWGJo58
	QzhRDuefKdX50jPnws0AXXn65Wcrj1GCONLuKVmSXi+ZpSoEQBmQ1bYwl9BnIhUlI1EvsL
	UaZutkudDfcKCjXAh4jPF015q45X5nw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="VT/3kzUi";
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-439c9bdc1eeso4532860f8f.3
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773233140; x=1773837940; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yP/ZBBLN23AWwEEAdVB0ZzTgoRWK0abJkbcKiseHvC4=;
        b=VT/3kzUiqRWolEt/0Yp34CGqvo58LJpWGFmxQtC//+FKbWU+jvHJzjoMLmnrA44roy
         TvDfGCF6E+WSP+XIJjY5B8T7+s6B+QSKooWnyspTQhKniTAdH3zeyJklw6JYorZ8QzME
         2lcU19cy5DYAChphlkekSOrm9OA+s4LvlXUXM9I3bO7go5xgwF8fgkUD7RZusblxduA9
         TgN0wkgC6igg2uB/6BdNMPK7tzNzFGonv2X+q3T6V7/6ZO7tJbQ+mEEi91Os0xM0x5kq
         RMkfzlfXKldrjiYe9XbvCoGw8Jeb2mH2KAtEUGtKDKIZ2sRxhzwbyIGoxWTJqBcNDiTL
         fxSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773233140; x=1773837940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yP/ZBBLN23AWwEEAdVB0ZzTgoRWK0abJkbcKiseHvC4=;
        b=S7/4hUagDyc63RLVrMVVbRhd4C1AD3ssBkdgajUTvz9LGSYmXuqr30hAB82PJD6Saf
         RO1uARZPP/u2cIokAMiarKtTygGGKU/Y0vva7eGAU0dVBLA6DKH7cgwacQ1F82ae+hsn
         GfzlNiJeEeOENJAQOh+TlbsBxZYXvFYuf56cftMa6pdOutXPeSaIuELsFsaDHT4zCOu+
         1nS5u4JUA6+hwTBlg8Q0tkt8sl5G1MCdNAsv+gxEdpTjxm5wiRqMvRjNzdm2OXEMez4s
         DLrjhybIftA2u1HqY6ZR1xUx6mYrePCRt6kWYJVwaX7Q71gCUohmf3YEiYvsl6h+H49n
         Bg7A==
X-Forwarded-Encrypted: i=1; AJvYcCUvNayi017wfqxfGPNB2l0jticZBykws9b333Cvxdi2tA6ThIUzpaJk2nSDBxA6s92+ilGTpwYbMg==@kvack.org
X-Gm-Message-State: AOJu0YwaIFzMzF0NOZA5CMPPAapqqzULjSHRHuICmxjYiXs1XDGqd601
	fXby+nvPaRbL69d5Jl+EQxzYZUOl+37E7zZpd0YuuqbpghOzk3WsxDkbusEVbYp5960=
X-Gm-Gg: ATEYQzwVls+8I82r1ZfG2ogQ7HF8r/H4z4763pNZ1pJp79pYxv1DVxLIEoLJfuZa1Sf
	Z65BugGVhqD0sc+0vS0d1vhCf57ja3/6rqDrpcWkzropxR2If+q7igf5J0dxi5gTrBV4PJXedxF
	X8UgDCp4qOghv49AF4p/c6EJmg0q8EIZsWwIuKCSZH78SiRbxI8Lh+MG+tXaeEdDqSWqd9vxHNF
	pUUuATSnR0LMpJ1iH9CAm/LHe0gWlSJTZIbEYcZ0lSYcFrumiIORl5LfcInsw2IBUkEoC6zJYnv
	h/pbzSTQJX8UvpxijH0KHJLBnT47LN1B9UHw87woZPod1LhLqoWtG4RB+r7z/khD0mCqsuasG4I
	TwSjEt8qGk8v/cGpnr0FaoNG3K3lUNyeN/tgDuRqOibv/rTphtd/jzAdyp3j7daXAO/eNxesaXX
	7xpzL3lRB9PdvT8++16dE1XKfufs939gwF+Ior
X-Received: by 2002:a05:6000:2584:b0:439:cd26:ce0c with SMTP id ffacd0b85a97d-439f8200be0mr4368266f8f.17.1773233139665;
        Wed, 11 Mar 2026 05:45:39 -0700 (PDT)
Received: from localhost (109-81-87-209.rct.o2.cz. [109.81.87.209])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fc0ba972sm1404494f8f.24.2026.03.11.05.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 05:45:39 -0700 (PDT)
Date: Wed, 11 Mar 2026 13:45:38 +0100
From: Michal Hocko <mhocko@suse.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mikulas Patocka <mpatocka@redhat.com>, linux-mm@kvack.org,
	Vishal Moola <vishal.moola@gmail.com>, Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmalloc: support __GFP_RETRY_MAYFAIL and __GFP_NORETRY
Message-ID: <abFj8gwNrpv0qQsJ@tiehlicka>
References: <20260302114740.2668450-1-urezki@gmail.com>
 <20260302114740.2668450-2-urezki@gmail.com>
 <a8010888-ce49-9232-f132-338de8e18cee@redhat.com>
 <aaXcLRdhq0IyoNIG@tiehlicka>
 <20260310155914.9c03a9f4cc2f433fc741e222@linux-foundation.org>
 <abEq9eX3-7yeNHVB@pc636>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abEq9eX3-7yeNHVB@pc636>
X-Stat-Signature: cp9b7qamx3y3ozs3wrzcz9z4meayc8rc
X-Rspam-User: 
X-Rspamd-Queue-Id: 60D7440006
X-Rspamd-Server: rspam12
X-HE-Tag: 1773233141-98983
X-HE-Meta: U2FsdGVkX18LbB6vBZMqLufaNsicirst+sIZGtss/wEwm87XsVCzcqMPdMuu1enupiO73sic9h7cZyFZigh4i8PLUqUA69jkThlPF4JTRIfBKuPuueK+XEuOw1UqKQtXJVjWhS7hsQx0mfrVzTFfQcKKHKrxsGYmZiCC1Cg3bBSryWXxkNrKAvhRRTErHaV+ZePSLnpk2328/ijlfWxF/csXB8x4AmlqYSAO756CUPrWBZNN8cIww+aI8RSMYhWntbUwiubdBnPFqmgR3uaV9I8bcjBPuIz/7dzgrqVf5P/X4ohWJSFPnCnSQkl+lRBBBheKQrSQP5bI7iT/czEuJP06Bmsr9PZY3CK0NgNVzOE3vKtJ/oT7z03Ed4erq3uZIlb5Cs/ETosiACONBo4p9vr/hlzvqqr7k2J3mNMBIZYM8F0UrwuvuydZhKTzTuHkehoLvaea1n9UvX2k+vQezyRXmXx5m0Kg3eb1LT5FdFNybl5aN5xOaQfX8JQ73Ffm9osm/3PtQ1FdQ2pb5y4mqkjaPCmRM1kfxKjLKDAROEusJYYmT6pYxFxlV/RwuH233sbHpEWAz9gr02VKU2sBqu2BGOQr/z+/SAnBCuuLin21V9qbrYjGNQmwikG0LaKJ46Rn27oNqLkl+F0iJFYV4Ep9pdlLXR/r4V94+k8hu8uiPvkUTNKPKNISJ2mK7TDvNjsN0tShYMpw1jj1534h2bbx+neroK/syuE1XziKLastsVPjpZaGyCxchMlY2HTeUpxab8o86NDTIlNtFluXTy6YUnoDBmNQ4zeCIfQkPDrgIXVA/TxsaPm8r68SKAL8U56DRRHJ6dJJpt+2AMRvnNHyamntfO/0CpuY6rxmcgYhsMv/1Kq2pTaN8DvQf8Pz7gQY96NNASd15b2yU9h93KgIl8RX7MAl5OxXACrEBn0gJIsteYJcjXtRVgq0AykoY5jTR6hZcqPRKMfuhiw
 7OJL8/Tf
 7ozj34Q7RFpwKTje1QkdeHIlaNk7QTJ8zBPTNn6WnDczrV0amm1I6zFLcyk1yFrHXtml8VteMWozgZiPeNXhGkpIjDTAzFo7sz95BqXWysZwHYgUs+OhYkpE9+pzbjwhlbVI0DYofXxvSlzi2mBfeHFHAjy8wRDlB1wKWCAWzb86LNXJJwRiRGQoZvkY7H3+F7JiTXamAsyEhu84BQEmx/9UGu7S6cYEAOcdpBacYoSfE3tTx9IbwU3MHJDisgdYKF7jjFiNR++b3jdyi71EQikHHffDw1dNMihz1qHyUDf7lKusCr6WvPoy3H0P760lxzkomsLSgWnOFradiaGd8y59W20zaj87B5faGREiy05kPc87bF+JogkwTkbQ/65OgQEW7jWdtNKG0Yfm+ALefTCjZHug5C/oRBWQS+DLH1PdamTDaX1oONC2xMIdC1F1g9Cfk0o6NbhvdgyTPMYHRvLlV+vu/4iSK2uqXXFXZNZ2Md6+814pscORdmwMmomreeefHelPhZ+SdQ8HGE4MPMcxyTRWrfaR7hQGAq/3Y7Pqq+n7giXHDDwA/9A6OR5WKtpNIZr2qeSzcvrJAhmx4c1/+WKGYHNssa6zqgFux12DumhdL8HTKC1hBXHoopxWlA8bIEk1tPOg/bOPsnnNQzvgjgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 11-03-26 09:42:29, Uladzislau Rezki wrote:
> On Tue, Mar 10, 2026 at 03:59:14PM -0700, Andrew Morton wrote:
> > On Mon, 2 Mar 2026 19:51:25 +0100 Michal Hocko <mhocko@suse.com> wrote:
> > 
> > > > I wouldn't do this because:
> > > > 
> > > > 1. it makes the __GFP_RETRY_MAYFAIL allocations unreliable.
> > > 
> > > __GFP_RETRY_MAYFAIL doesn't provide any reliability. It just promisses
> > > to not OOM while trying hard. I believe this implementation doesn't
> > > break that promise.
> > > 
> > > > 2. The comment at memalloc_noreclaim_save says that it may deplete memory 
> > > > reserves: "This should only be used when the caller guarantees the 
> > > > allocation will allow more memory to be freed very shortly, i.e. it needs 
> > > > to allocate some memory in the process of freeing memory, and cannot 
> > > > reclaim due to potential recursion."
> > > 
> > > yes, this allocation clearly doesn't guaratee to free more memory. That
> > > comment is rather dated. Anyway, the crux is to make sure that the
> > > allocation is not unbound. The idea behind this decision is that the
> > > page tables are only a tiny fraction of the resulting memory allocated.
> > > Moreover this virtually allocated space is recycled so over time there
> > > should be less and less of page tables allocated as well.
> > >  
> > > > I think that the cleanest solution to this problem would be to get rid of 
> > > > PF_MEMALLOC_NOFS and PF_MEMALLOC_NOIO and instead introduce two per-thread 
> > > > variables "gfp_t set_flags" and "gfp_t clear_flags" and set and clear gfp 
> > > > flags according to them in the allocator: "gfp = (gfp | 
> > > > current->set_flags) & ~current->clear_flags";
> > > 
> > > We've been through discussions like this one way too many times and the
> > > conclusion is that, no this will not work. The gfp space we have and
> > > need to support without rewriting a large part of the kernel is simply
> > > incompatible with a more sane interface. Yeah, I hate that as well but
> > > here we are. We need to be creative to keep sensible and not introduce
> > > even more weirdness to the interface.
> > 
> > Was that an ack?
> > 
> > I'm still sitting on Mikulas's "mm: allow __GFP_RETRY_MAYFAIL in
> > vmalloc", which has
> > 
> > 	Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
> > 	Acked-by: SeongJae Park <sj@kernel.org>
> > 	Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > 
> > I'm unsure how to proceed here?
> >
> IMO, we should drop the patch as it is not complete and replace it by the

Yes, that patch is not really correct as it allows to trigger OOM killer
during pte allocation.
 
> [PATCH] vmalloc: support __GFP_RETRY_MAYFAIL and __GFP_NORETRY
> 
> https://lore.kernel.org/lkml/20260302114740.2668450-2-urezki@gmail.com/

ack
-- 
Michal Hocko
SUSE Labs

