Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1809DC61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:04:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB3906B008C; Wed,  2 Sep 2026 01:04:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5EA06B0092; Wed,  2 Sep 2026 01:04:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4DC86B0095; Wed,  2 Sep 2026 01:04:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 970D06B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:04:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F28E1C25C3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:04:39 +0000 (UTC)
X-FDA: 85167631878.20.0CE0792
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id 131D7A0006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:04:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iamJBXjY;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788325477;
	b=tKiL6tf8NozdMPW8frcpewQZ5ij146P2A25f3jKbLPICwQ3OanqMX+rJUUja5/sFiAYvcJ
	Bog3L/KxXTaIOv/qxBcpJ7uNelZioFiM1FxBZfBqXU+Estyi7UmgqrCKRFuzeadpmgbYzj
	6gOMbzkBaGdD3Ij9mbb8XpfxFA+uGnE=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iamJBXjY;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788325477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KeJQVDSbogynnxpMuf5nC3Gv1fLjaTff/br8PpcWI6E=;
	b=dLi65SdEHOrKQSzPteP6FDeGhRNDPL8MHVSBrBibj/sKAIHtZYK5HTmcKqghu6EjUCVsXg
	q7lsCovAV1WN9EOUkaKT2ibSfbiPsvp/5vH2UDXmM7w3FbtRU+NFsV2KdhbGZ8NY9TLSLP
	APPkTZbM9TpPe6Zburn+RbcZ6HitMoI=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48441a2ba14so603476f8f.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 22:04:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788325475; cv=none;
        d=google.com; s=arc-20260327;
        b=Nt0ekLWS9864PIoSP2Onjn/atMoWbvHH9vg/OPFG31Syfpo7xpVTFpeQTVX2LqIUIC
         n7oOQnoGp9+ML8eF6vZmYVR9TdUzxXAhXOaiNXZcfQ1RlkIjhUtRZqDrrf83v7pUb2c2
         7UjLOD3GBKf6IlH8xEhQ5+SLoN5iX6usvfw7EFQiNDYHm091FU6GJZ7wU2o/NJ4xIuWk
         1T7gC32S0FcFGImPukbTRMI68mRdlqWnbtzZxt9llK8qXmulvs6dEy6uvh94vS8+73V0
         dClA7LzxA4S7qkLGw37qbVCnjnDoDjIyU9WtGXQeaeiFq1MIXXJweewRkEn+dp4T/jgs
         hmgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KeJQVDSbogynnxpMuf5nC3Gv1fLjaTff/br8PpcWI6E=;
        fh=nNjIL2fEu2N6cXFtABwpIzfMHpDxiHlTbGB4/LTXZ2U=;
        b=HtgdbCwjs41SepHrsoaV7BYTUbKClbXttejJhuPD/tkX95LMgUsq+ulGACVRbZ+HYQ
         dmsNfQxkOSyGrm98lZwhz/5GVQZtTE+5CcMiAYQoAjuZglvebnkksKNQ2tMInQZ1W1rL
         7aukO+uIqGZxYdwI6kBLP1fzZqgt+kYDmScMn8xccyMP6ioRyqMDny2DxUBWB5lm2GlG
         NotTbnk24zTUBOVBFWyjff0im1cSHI+gTfUU8CjbBEQ6ogUsFsBA7ZRKO3dyR3qgrq3C
         v0ffmjVa74h2x9U36yGe0DQGXea+mOearWeNFwjQltZwfoLEHzdACXKyTV22Z2/z8Qva
         g0VA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788325475; x=1788930275; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KeJQVDSbogynnxpMuf5nC3Gv1fLjaTff/br8PpcWI6E=;
        b=iamJBXjYcog18jWV93gWT7kWFo6VbKJ3ekxCqBvmqh0RZCHPv/Qg8bvINE0Ai6X+uV
         53pY4tZwZcClWPz18q403+0MIYcB3A9t6PkOHU5L7P3fdEIAV+IsVaXoB+P1xwjhJSuT
         +iduhCM9S0FruSfNY0FXFZZPn7yu+pg+51UtlLbB8NwxV2AfeLZ71wkhPI1G4O4/X9GN
         x/lze983h44+kiPiJdogWPvGNEakyyCRLb50bXHOJlcBpJBn+cQ/f3wmREL9hHnWlqgC
         mgZh90NOCZH6xbfl4mCIVlF2tZKrppINldBwLI09d09NC3s/ORWu4QL0E/eQDRpSREA/
         hjrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788325475; x=1788930275;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KeJQVDSbogynnxpMuf5nC3Gv1fLjaTff/br8PpcWI6E=;
        b=nnhEzuFnpNwS4MXPMTScpAPQKAvSf40YRAlQZik2pyuTG2nHR6iKD9M8akqGauphBn
         2kHOntYgr56VkmCbG9O85CQENADGC6GrYteidoL2ABNf+yJbmRDHKIhGEuv0uR0BV85X
         iCaJYB+Nz4Dvk3dd/8QK1FAwntLRDVc21rESL8S9hLhiSms3FGkOvwVwOmcpc5H8ba3s
         cqVz+TQdQg67Fa5ABKIJDBmeKVC3X5+0b4I/c4UkFc0bhldDqSNVRbChq6Vzu0qEnDH4
         9Ix8i9Bn3K19izO531k0+hed9/8XkQAw+3+9FrpcDhM5NZDKDZPchEeRH0DF9Ub3BLp6
         5bjA==
X-Forwarded-Encrypted: i=1; AKwUvByvN7UDshrK2HPqFQw6dg3l7o4i4Arnfr6BEP5PJf73bSPYrdHwhsvvalakGEX/2dPsaNMe5Jzo7Q==@kvack.org
X-Gm-Message-State: AFuF++kU4QlF808Mzz70pvy7deA8YhbRu98F1Bv72jUvj27aXiakF3ep
	fW5bxRjXKEzg1X9NLAnkiKQRMw3gaMvA+/TyB/XyermZnUnawQg118ODaThszeWjVRoMDRkr8IE
	faVrd7chbdxANCaXJ3UHUYJOTL4TUqn4=
X-Gm-Gg: AYBFou0bq88qWCFoyFwvpj9bAajBgHbZ2Loj6jvkt8hhvJWs2BspN/OpLCXN57GJpQH
	O/BduXoH73zP9Rxv+DwFc0bieWwkizhkLLrRgd2T/g3cdWwgQV6Ys8dUjQqy51G9bdAhyc6iRqH
	au5pruZE4qzW9AHvD8cshH5lilsIuatDbOcBPn5thjwa3++LH7w5qiszm5JQ/s1viGW8gY6ytAJ
	wFXNG4G7eSDFOXhy0ki4AcidvUVza4HTx2PAimvxlVk+EVZlZ3iH5gEcr83KGE3Icr0cXKkD07G
	fI6FqBrkycQ0pwR1kmJsOGpxzR2PNIC2Mgh/s88zZyGj3CfsnpiHzMJa4VYCGqxONYBCsMUQl9r
	R/c9cAILq2wDv4vcu9nXiy0E9/Pl/
X-Received: by 2002:a05:6000:260a:b0:482:ea99:6166 with SMTP id
 ffacd0b85a97d-48488df7809mr3404647f8f.7.1788325475488; Tue, 01 Sep 2026
 22:04:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260901232834.22221-1-joannelkoong@gmail.com> <CAO9r8zOTd5HjbDfMXuh+VHLGCAkHwyKx4CV-rjgBuxTpEZ6THw@mail.gmail.com>
In-Reply-To: <CAO9r8zOTd5HjbDfMXuh+VHLGCAkHwyKx4CV-rjgBuxTpEZ6THw@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 1 Sep 2026 22:04:23 -0700
X-Gm-Features: AcwNN1WnU7HEpDTsnhuHBNOj_YFTBtEsrMXSe0lpTN9YaSozig1ywRedLbNVFmY
Message-ID: <CAJnrk1bFG5X-pQK2UX8Eu_bPTqD7KLn6cqek9uifrriDBrPLfQ@mail.gmail.com>
Subject: Re: [PATCH v1] mm/memcontrol: drop non-hierarchical memcg-wide stats
 in non-v1 kernels
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 131D7A0006
X-Stat-Signature: s9npnieg6erw8bep9gmc1qcu3i6moon6
X-Rspam-User: 
X-HE-Tag: 1788325476-467804
X-HE-Meta: U2FsdGVkX1/nPlOvs+OVWhZBpAef7zu13Sp9Vus2KjOONHK4Z4ESQvQcrxkoNmIX7bg432g1fNatSEleALOwH9e48Ypj9FPr53odebv/Wdf32BGY94q1A0aRWnEAXZA4yOv7RsuCm6hInQfJGj71yLSwBUrVEfFApsr8CDZrRI4NBrXGwG6yU3PgAeRjb8u5PFdFPWXOKWg5mWtUzf1T9/tNzNHM6tQ/XzOxn34iNz8OToyvltEmsSYes4LzN7mb0tgzxEkc4xITSvGpVwO+H4Awr0S1Rmh0gW1fIIhpVnEm34kxG9nxrZl8k0Z3taS1ujJrqx3GS0zOlsjryfjRoUxbGnVVqU7e99z1xmH4QYXqsZO/VTFstlFWU2Jn+Tpfg0kJ3Vqwc8h96fmPaTviZuK6DMQd4sv803wgRVDMKfnWGYgB7xbDcWvKDQr9uavtT77VL7tHKpeFM3Njv3hziHcnWxJyeCRR8MCh3wtV4U7Y7cPJrKI2Rvm1uw8Dn7BhK9SB2c2piOzaTxDgq5SiQx9aIm9SpvPgnI04IXxMVb0XDibgc51y+jGW3lUJKkmJO//eEH5D6BFc3x41RGSrhKMF86HAxOhmuj22AmsNYldB4IBGFiv3fSTq6urWipLrukNioYnfISTxdrThg/dqmwiIPIVWozEAjvchqZqPC15ILFjXU4WHnYc+62ehCjm/fhm1MR4Kmapcxcmpt0B6IAudJmTeCeWaUzdSE+KgUz9K3WHCRU8rXAigksLjmGyAnyRQMCJT4akHtFtA11whuLHRZ4mnoU5KjmOsZHUzYqi70VRWCyrVlgdgq+Q2OQn1MmiQW73TLe6r9NhFphqkTU02SOHZHnnawwsgM0wEzSS3GKQ+cuPezKY0vc5nTAn7vx4tZkN/tbK9G5kAMMpqRN0UWr/V3BQZKez5wyEsd5W7DWlGtkEDCI+afJ2FGJQl65XC0P1MfaieFlJ7SMH
 5Btvi4jg
 v59YIYhoRtk4q4dw6LIqzUck6KVH+1HqmBwpcBFb5SC4n/QJpNU7jzrrKfIA/pb41SdJe0sPKzYPw4VbTv5lRURV9G8eyuUzPaisb+opD9XyRaPyNIiN9nPn0Bfyr7RJHH6QOLuDDJ/xwxU/Xr5XY1b+eFi7VcvV2N377DfZiAblErUSMdpkNxNEPexw830VSQ2JTLWfVE6glqS78yrOZZRU/StmsHiuY1sjXUZuyI+TLL0vGw0R5i+++lbDClM5Fc271txVmjvxzLcxVpPijk2iF35KisxEFEyFKlHV5TtmHnfS60zaCPSujKAtNIVqGDnQLCq+x79TYBHh/60lt8AQgl2rlpGUEXI24gfR/CiuI/k775Em7k3Ty7QhFtprlvmhVp2p0uhnCOS+Ttjlsql49K/V7nWTvGuMNkYEZ9IcJYCo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 1, 2026 at 4:42=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> > +/*
> > + * The non-hierarchical memcg-wide counters are read back only by the =
legacy
> > + * memory.stat and by reparenting on offline, both of which are v1-onl=
y.
> > + */
> > +#ifdef CONFIG_MEMCG_V1
>
> Can we query the boot parameter instead of the config option here?
> IIUC this should work even if v1 is only disabled at boot.

This seems like a good idea to me. Maybe we should take it one step
further and gate it behind cgroup_subsys_on_dfl() to cover any
CONFIG_MEMCG_V1=3Dy kernel that doesn't use/mount v1? Not a memcg expert
but afaict, if the kernel then switches from default (v2) to legacy
(v1), we could populate the state_local and events_local arrays from
the aggregated state / events arrays in a .bind callback since
switching from v2 to v1 is only allowed if there's no memcg subtrees.

Thanks,
Joanne

