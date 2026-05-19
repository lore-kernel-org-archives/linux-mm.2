Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71E93CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 16:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 905006B0005; Tue, 19 May 2026 12:19:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B62B6B0088; Tue, 19 May 2026 12:19:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CBCD6B008A; Tue, 19 May 2026 12:19:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD816B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:19:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4C77A06A0
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:19:34 +0000 (UTC)
X-FDA: 84784679868.08.6A3DD7E
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id D9D9B120012
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:19:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eUISvEmo;
	spf=pass (imf29.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779207573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jdWffGLnhun6kWebBUsOmepReVmyXGKzEVY8iVI8i2k=;
	b=HkmLmYVmH4So0UYNHjOqa815Y5ZU+QcTL41ZnlptLCE3QXYwZ74L4pLy+2z7EtMDOEy0kY
	mOPqVAiAQu2vbDMTfzUPDIsufzdCgtp6we3426EZIvYIc07HKSUlm/W6JuBgvPf5e5EG4L
	UbpPg9SSCfDNNp5+XxE3jRRlEIQvMSg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779207573; a=rsa-sha256;
	cv=none;
	b=1dm9zQPAubX/VSA26KFFQ/YbnxHoudwJmDXRXwolNXeVMrNFyBgNf4e/C1410tR8VpOjJ0
	/nsGrWUB7dHIMxpVRkJ+Oa57Te9v45eCwIxlxDdJye71CxDxcQGWgGVgrMRSbwBj9LxQSd
	31770JVubpYqcN7PW0+tbEi7xfeM2+c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eUISvEmo;
	spf=pass (imf29.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5a887ebb416so4577848e87.2
        for <linux-mm@kvack.org>; Tue, 19 May 2026 09:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779207571; x=1779812371; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jdWffGLnhun6kWebBUsOmepReVmyXGKzEVY8iVI8i2k=;
        b=eUISvEmo8Z1I9StNKCmACSzLCxPW1fG8P34ROuJS/liTHniiK7Z3qCyN5K50NAb0aE
         Ipfu/c+bIHXpGPo3Muprq2N2JpNt0+tZNmGpz1RKd9NNXHp068vOk/CxGlugDwRvl0PG
         6yezRjsSC+PUlu55oFZKt8SfxbdcAYalYPr/rqsVUKZwLWTNZ8LnOFB+AMNHIG61b+PG
         i4m7IneuTR/wEEB3RWxtVnJuRYKZk2F9bZKS7mB4BEHknL5BUW74TIf9YXPf36z1cbdj
         sOSuoeGkAHP2LZf/p5QEln8LPpFidgEWIbJeylS1S3pcsctFyg/DYnbGqJv/bBY8h/QD
         Hcrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779207571; x=1779812371;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jdWffGLnhun6kWebBUsOmepReVmyXGKzEVY8iVI8i2k=;
        b=b5KioRYNfncY1JX20CtN078dgqSlT23N4eTP18Rx4ueCXuRzfRZqDlPhErtaBnresu
         Ix/xidVTFpXlC+wU/bprq/GGCaJfO41xPeQFjaP5rJZ3n+JcvGmGnH6KmIt/ofJ+mWdE
         NpSUwzhJGgG070dNEdNt06tHXFHuQJwSqyn+5EMHveFdaw1ocObntpHDUTA9wqYzPv1k
         Q8AaZfX3k7rj8b6BbEP/FTcGMkEIXAH8OlOGTcc9vpDhkkwBfEQ1+3rnmbhWRF++eCBD
         E6+XHtSOjlUUN4pcwTWGqdIx1s+X0//7jk26vBDon/mO0x+CL+FLmyc+GxddwZ6VC50z
         oKOw==
X-Forwarded-Encrypted: i=1; AFNElJ/yyW/e+wZvEU6j68gKpFkXgrmtJwWAlH+1EOxeTaVefFipGhnh/FAMIrbUa2qJI8t1sciXgDmk4w==@kvack.org
X-Gm-Message-State: AOJu0YyyS44bxvgS9HR6N+13IB0UHYy5LDoRE/YfhkAVOnMKKmTd5SoM
	7TixP65PN/K8XU8jqnuLwxzDhROn9Ay+oMocpEvVfJXrOdgEA6A5tSr1
X-Gm-Gg: Acq92OE3f/gSysSjyCz/BAj9a7r2gYZ/MgSsqL4kpK4UykxMIaUm3ZqxeabPHi1UQ42
	GY3usnvVnqTdXAlUUOaOrTDb2AvDVeczxnwN4E1LUzQvwBSPaUWBx1zikp/UJVCHgHCXs2GQ2F2
	rUx7gwdYAMNM2BMNt835hgMFW7qqZHEyIn8F7SiRTZ+NlCVc/EPpyhOk12rtGP1LcMVjG6/YAJl
	Tt6OQvqoml1uFQ7FGFVH1L/6cmU9IoZfAcoj1A88Nj1xGbLs01VUZjyYQ2K8CPqxg8a/Xtxlvso
	ZNtvnXjUFepGLeXi0fE/KwBEnosr5h6Ueuxry055U5JN9dEw9Dt3CSNS15kyQ4Ls2ITNK31DxZu
	NnE40uvNA3cw3h42aDLBNW4kPb88bQcz//qMsrBXC9CzyVQcD/FOj4QPJsKrRyPeF
X-Received: by 2002:a05:6512:a83:b0:5a8:9135:127f with SMTP id 2adb3069b0e04-5aa0e623e0cmr4905486e87.17.1779207570700;
        Tue, 19 May 2026 09:19:30 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa1e78a9e9sm1387323e87.44.2026.05.19.09.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 09:19:30 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 19 May 2026 18:19:28 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	syzbot+8b12fc6e0fb139765b58@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/vmalloc: Do not trigger BUG() on BH disabled context
Message-ID: <agyNkKN9b1qcMpFS@milan>
References: <20260515153009.2296191-1-urezki@gmail.com>
 <20260518161012.6f92f9aca2a4db3776c536e1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518161012.6f92f9aca2a4db3776c536e1@linux-foundation.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D9D9B120012
X-Stat-Signature: t7ymk76gg4yu3wjx74eshict99hw54n6
X-Rspam-User: 
X-HE-Tag: 1779207572-330503
X-HE-Meta: U2FsdGVkX1/qPOQCsHdtPcJn6rKGfiB9ELElG5mY/7ulKK5LCcVekUb+YPjixQeS1I5aAmiNINlq5L/yVMfhn15MOL/FzcKXc4QC4naADVJBFe/PwfQrVYplRjwrnukpcd4h5WLN9ZHatBNPoeIF/LuJtWyTiFa60PEnBORWLvuBiD/qMue0uq5zNsgu5u1i05ewN8fJgAZvo6s9sn2qS/MLhFIECJiXUfb6OlDqcrfepSyblqGQCNoykuAdgtAMT22IaDbctPrSNOAsT7ilKbbQve27+8V79+CUbg+8uG9+ruycxhaoBuZTGEm87STGzpYtuhDsQHG1+MgBKCqmr4eX94CGxa1SzwrRdLPsbC2iFtxVMlgApFGuSQhJ6UTaZAGjcvPeNt0YjAB7U3bsNhyCGl7fdNwv+PK/Ouv2y2lQEj2RDNDQ+vLb8XgsgUjNq87X9hBWTLF9M04/B82JqzLZIePuTOGKJooh7ccTNjfmjY6H1X5h9JD6wpLmZkB9FhyBQFgvFj5I8Pmbd/k1oq7AMfUYXBvksrrAO8BuWrG838ClN4F7rml8gNpGmsxJl5Gaxc+w9P20wgAffXK5mFkApfQiYZticMfkpxkLys12lLIeOtl/us5bDW7tolJ0IJ5CQE+xY3lM6sOXCBj54pJnwiMzxTD3bVaI+Z5W8Uu8jQrUs1hGE6M4IwzbqDHatgfCEObe69kBzX9KZG7o+fAywJew8O1PiWm//zPj+sSgGYTy65FGQpELnNw3xl4+BZHw5XNbjJ4uCpld4v9dB2owRGWnchZVLCS3WpBEfp2Nvlf6vHqbqrpjoFDwEJzncYgDAKqODtbAwlC8/IJ8YDOqUGz8UvindL7ZLabI5YzTKRHNfPN5tPPMlNtdbq8GsBMH28bmc5hFbJuTi0T3fGp/Zt9CJIEzNu8TB26JznrtiQ3EbHxjogfQSktxQp89zayjOWlB6e9rjUN/DZE
 OhJQrtOO
 2emO1AK5pXGUw5ZbZhsL15/K9BSp2+GZO4sUViyzeg9DnZE4PWFMVgTCBJduXjMmHXVSVfY5X3D9/xLFkJE7qKpad+br+W9FFEjFJlIMp5K+pTgWYkuomZ040agTgLTVRAjYaWjkQHKj8hyp6XDwYW7FNAFOPngSXa2XPeMjKre16eTbMvnY5IgxNqR0V4tJgGnNfIWW30I+sbN8N6jr+iS+KrGFhP49M31YMvXOppDUPLKaEEaZJSj4sKLHix+gdf58vo5U1CCqIqL6tyOSMDdJW2/X4KqCyN9m6emd3nKVk2rtA7Q/HrJqa/LiPcj8MeFj7GWLd3oZAGBoaJR7eKLhi3bbLCrvsCway+4IhB13cdDXzeAsowsEzrppX4kOeeLHSk5H0lAKjRfZdNKweX+9o+uNwUq8KWdENzo3yB3uerp/uMkR8p8fCjDpJcUwRWRV7PYBpfy1okWQf/U7cNi3Py0PClBVuAjFfyRJ5q7tTbkeH6gw0SFT4anIu8dMaNZQmwcjNxyb8ycJ358m93Y2X2t41sq6oG36An0l4pRHy+itJ/wW9iriAt5LdJWRcaGvNj7Jr58ukL2w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 04:10:12PM -0700, Andrew Morton wrote:
> On Fri, 15 May 2026 17:30:09 +0200 "Uladzislau Rezki (Sony)" <urezki@gmail.com> wrote:
> 
> > __get_vm_area_node() currently triggers a BUG() if in_interrupt()
> > returns true. However, in_interrupt() also reports true when BH
> > are disabled.
> > 
> > The bridge code can call rhashtable_lookup_insert_fast() with
> > bottom halves disabled:
> > 
> > __vlan_add()
> >  -> br_fdb_add_local()
> >   spin_lock_bh(&br->hash_lock); <-- Disable BH
> >    -> fdb_add_local()
> >     -> fdb_create()
> >      -> rhashtable_lookup_insert_fast()
> >       -> kvmalloc()
> >        -> vmalloc()
> >         -> __get_vm_area_node()
> >          -> BUG_ON(in_interrupt())
> >   spin_unlock_bh(&br->hash_lock)
> > 
> > this triggers the BUG() despite the caller not being in NMI or
> > hard IRQ context.
> > 
> > Replace the in_interrupt() check with in_nmi() || in_hardirq().
> > 
> > Cc: Ido Schimmel <idosch@nvidia.com>
> > Fixes: c6307674ed82 ("mm: kvmalloc: add non-blocking support for vmalloc")
> 
> Was added in 6.19 so I assumed we want cc:stable on this.
> 
Thank you. Yep, we want cc:stable!

--
Uladzislau Rezki

