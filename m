Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC350CDE000
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 22:41:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A43B6B0088; Wed, 24 Jun 2026 18:41:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77BB56B008A; Wed, 24 Jun 2026 18:41:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66CBB6B008C; Wed, 24 Jun 2026 18:41:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9506B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 18:41:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 993D4C2086
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 22:41:52 +0000 (UTC)
X-FDA: 84916280064.22.392F557
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id 98D8D40007
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 22:41:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WQ7kBTlO;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782340910;
	b=ZhHT0F49XwN8CcWrx2gHtRovZDBohAesasTe/nljNzLiJohR9E90nK+G4+KiuUM1WwzraM
	UV1frresqerEhjUVDNhwfudNDpMD2pEAwqab7Ob4toV+9bbMsaiWhtsH0YRjWennR10rZf
	0tgB2hqaODYikrt4k8yo0+0hXzQ+5A8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782340910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WJs/bqJV28nRmEFkkVv0HdnYQ72Ru/Q9zWNCjXeVDns=;
	b=12kn+eSeevn0itRpakXzwXylZTxfdJJJ9UBJpXoh33KBTEFPtBcHFg55oL3QaVc7UP8av/
	2v2eBpz870riJGeaVbNIrv8iXgJ6YP40v0aDf1q/nENyBO/GNN099pEdZETm/P7hGYjVFT
	YtCExOp2XY8mbnJUg7jE9rQPprIfTf4=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WQ7kBTlO;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4924593f45dso18253965e9.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:41:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782340909; cv=none;
        d=google.com; s=arc-20240605;
        b=SUazU4aqm9UMPcPd82b5vnAcGUIXPW7Z3jmWtUVPJBiHVDCzuh7fuC4YECSmkRQY3k
         y48uxAocm6UXZkX9X2jHHVGT9Q5hy+tqpe4IwsVy3pNOLWlifdIqxERI0s+DqARXoWhQ
         TILsduuyoUytzF4oXfzYITz8LqKMzP25t4YRVUwN4lHj7l7tG693Sl7kLPsELX5BsXjk
         nJtLPZPfM/Ngj0z4lDCNF/tmX3jMe7sJ8W5vT+znVHa333K2jEU7uxLOz55BI+XpBw5z
         fYvGtIKbfnn07Nc97kHbJeaz98RjA2cZdL/YEkSlGVpqk78z13S/F2x09jJ6ybAkYqGB
         IqTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WJs/bqJV28nRmEFkkVv0HdnYQ72Ru/Q9zWNCjXeVDns=;
        fh=5EhdyJGz0Ks3R2vIPOzoecyxyJh/2XlURXkMxKjJQcM=;
        b=LR22rmCyZYGVKU55yy3FjQQS04TBUukc1h6k0oZrt3MrFtPGU6c36cviHRLCXrXVEU
         FofmgjNzJF8KOkiSjowUt5QmNvqJ27fAHzyBKz52tF02y4bpSpFGwP7iOIXR9y8rTM+V
         IOC4NwF0tsEUyIH/sSW9/rjAijv+NyPbOe1XbqykgKSo84xPJvFX0vxFJtQ3itaQs6bU
         1JisrbtViPCK74TWxGywDavlLy3QQYv6l4HGiVFjOSKweB79sFu3peEeBHASK6XG3Ltg
         Z8vsqXtj3c8fi5x/okv5pMwGNBnH7927X8h1j4qtdtIsoGIqztkHbwzQFxBpmTMTOhQW
         5YOw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782340909; x=1782945709; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJs/bqJV28nRmEFkkVv0HdnYQ72Ru/Q9zWNCjXeVDns=;
        b=WQ7kBTlOlkl2q9ldac/OgPktWxgczvdjxyKkrT6tRs0Q48fs4pHEHHvznnvMIpR+8Y
         Y/M2vdc2OmLp1nY+Y47AQmpxONW2NEw0n6Y8qK+Ow42ah3bIpqet+Nm1Omgz4rbu+ngS
         1ftcru35qVL/wpG59FD8QLW4bQi02TKw00pGenOD8gVXkdWiO8kWRyZFYUNS1dT+Pavy
         rGnG7XkNR/yrWlypxDJH8+ewgUmhZ6MTb7rl4I5gBCfACAHnxiTFQsfnghQA4Qkhrm90
         hdymS4ooRxeIogYQuDiKIXDipb/WJWRbA/2cQEmYH0hQTwXuPtLOoTh3iXCgnRqCPt1g
         fWfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782340909; x=1782945709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WJs/bqJV28nRmEFkkVv0HdnYQ72Ru/Q9zWNCjXeVDns=;
        b=DJq6IrYPPPmvOiqBlfQYkha3AVp9eZ1ZvSjuqats6kFFt94H6ias6D/WH0akV42B0J
         +Byr7SaAQSkekdTtiS+cD+8WZa+88kOGLbTvtC4/Ew371Vyq9zWu/BEMKGyOqm0wudGO
         nDLW6XSXsUS4CwViFSzQfKxUT4J8EKaWPMONVIsR35m9VkUwt9px+eVtWCGAsn9R8acd
         sS+shxBk1/pmUYgEzHyE0p3Jj3LLScDpGj3ZdmGk1xMtbaJJhuke1pWhxO0ZVcHseXhA
         4hMx2tQi3CM8bZRUN2c5syPlmF/IahSm2nZavdK68pclDE+I2XoDAo51jl30w9ukuG9f
         NyKA==
X-Forwarded-Encrypted: i=1; AFNElJ86BpY/T1a3pwzcFwsM+41QUWuiCC63ObT+ZaWw0gSt9i0D60e7PYNvhwBrrL7KMj/OJ+3hEj6tqQ==@kvack.org
X-Gm-Message-State: AOJu0YztRtpYRNNNXGFgcJAuMKZU8zs3LCtuBI/ckeOjvUpCC8N1UNuM
	8koXq6vAnDjYziD5UNSv3LuPMmI2fz4cCx1aIqc+6JczuLYWCqY8tdBNbVRHgYLoYp/KZoaklRD
	OqZBHXZL7GLp2oZ+mjDT66c0S7D2n59g=
X-Gm-Gg: AfdE7clDncU4m2TGkLEvHxabl+i+/PC8gkpfzQKOCkSQabAQDIkZc8Ge0hXuWQ0VfBR
	bbORKlJnf+6WqUu5rT9HyjK8/mgktWR0aXjdDaijEKcHRZA4FA2lbhzIhY8PVYrhWFcRHI+ExSz
	Ob/PCrX90s+U6Rv5rtaf40pXnnUeE70pGjElGM9ufpkrLmUyh8eIOHGcDJAgJ7NwHlG4ENjMcAj
	k09d0H13zkTRQSxmkQF8KGjWCEw3/uDo0su1E2H4SJD1blK+sIKKo1WNw8MUiDzXabKpiMdz2Xb
	3O0mZ9y/tVYrq801DEobI5afNgrEpY4p1KrMWIK+fYaeP05tLI5TXQQ=
X-Received: by 2002:a05:600c:2256:b0:492:5cb2:aa54 with SMTP id
 5b1f17b1804b1-4926087ba9fmr54723185e9.34.1782340909046; Wed, 24 Jun 2026
 15:41:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260612193738.2183968-1-nphamcs@gmail.com> <20260612193738.2183968-3-nphamcs@gmail.com>
 <ajnQxMY0W3VGyAUE@google.com>
In-Reply-To: <ajnQxMY0W3VGyAUE@google.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 24 Jun 2026 15:41:36 -0700
X-Gm-Features: AVVi8CcLr7H4jR5RtejdKP7Hpj9u7s-tS31S_dqbqyaFggMebkaysX3HiNPrzN4
Message-ID: <CAKEwX=PwOV1Oh8B=QyrfGXSR-Xu2wUBTE-VOQhXv9-YEhYGZEw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/7] mm, swap: support zswap and zeroswap as vswap backends
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ddw18gsmu4ppys7z35tu5y9zr8u6hnrn
X-Rspamd-Queue-Id: 98D8D40007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782340910-309046
X-HE-Meta: U2FsdGVkX19P/86vzHQgtcT3mojeH4FsdfUwyMJsxQ0q4TYAB+4jA7ABydovOtxDqOZDen1K6uTRCgNIvkekqbDvjzFn44OEgL37TZLoSHOCsRQ5SCQ9NGckc7TpRBy/Fuj6wzi+PIf3OyB4WTHEJCr0b6xAc8x9lrViqVtR8Q84YK3b8jICCA0ZOMLrUxcFmCGX+yq6aWg7Ldmxe9I8lMtcCUAJfJGDiCXKuhhuSt1iWXhilYSgNtvTL06kq3aWP27lRWPc5+HxHZjQ4QBGZJgGYH0JruBXaKr1HAK/d0FKsZTwf0M7q6eSS32Xe2DMEavtnrfR9F8zyzSPCdRqko6cjBxyJHVtgj+sP2s1NWZ2tE5kmtv9gXz3PVb9KFloldRYgammI2t4CVJQ3OfIe0PhbigAY788/K0nle+knYHmyMf4snLryj78mIvaLrRsBirTk6LnOJH8eapJp4b42MTL4AW6NrRon6dbwTnIEMXuavJcK8GBXkB9WMxYx/g9FgSESM4WhZpdg+ZG7RLshpVuTRVOl3j8IEPvZYoWZgbIAqXP7lhB8RDM524tSC4MnScKzcn1ZsxaX/rRrv4MEoeDh89OInekUP8kWFgzK1GbtnrkPZrPftMEcvYE5yj2vHTglBoJ5roxGqQbHqjnUhC5WKetyqy4EmhKEC0/ksN+QQ9Zb8Jhjr8IScHAMre/9803vfRkY9JHIv1HEnOTxLLWiKc0qI1+noeiCRytcYP4mCC0QPwqaXtgEfooW0nyPJJF27Ju+obFY1UQY3SR1kxH7ow1Xnm1gt92H19UhFubWVzGtgIVIFCkTGaOE5aOR/MMQvC9JMAQoOGmRiVE/WBCPKfm1WjjJdzNW0sL5DXZeLRsMgOGqV57sW6othMRqdF1PBXZeFXDDfj22crl82K999+2um3Bdj/7Wo9ADSZJ8ADzyK3pB8kZLHLSYnKBLk18n/sxKG7m1ibcESY
 IQjoa+D7
 NoZL+P60TtHhNPRjqglz7/0LIfLTvYz0UeTNl79JlaIm4mu4r2IdEYxFs08yZqtQBMRT1CuoVwvf9gG/+Vl3vapVVgJ6zGV1Cur6OpxFCytdleg5c7UfqEZjvq+aaCif5a8J6DESat0rRzrM+ZS+hkIYaq0QX0H+r+vTcH2b6k4quV2wyFiPGPI9p8GzwltMkkPkjQQUNWzBYq1CKMP316vO/vUQ3dOvKJ1dJz+Ba/B3EPD40uqaDg8F+XdyMYnefBVfjvGtGo6eDNJm6iSGu60jijS+V/bmaYXb5rgjj4fF5y30MQ67+ZEpfaWV6cmeM+/zYnRFFOD8sQKUhVD5YnoCvDpalKfSb4ldIkIlAzaBzkE48H/s3OtsLoSULjjnpuNMOSm0aUoRQp+bixEempRUB4MJFKfO5gWjg0BjmZGr6gmk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 5:18=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> [..]
> > @@ -1623,16 +1642,14 @@ int zswap_load(struct folio *folio)
> >       if (entry->objcg)
> >               count_objcg_events(entry->objcg, ZSWPIN, 1);
> >
> > -     /*
> > -      * We are reading into the swapcache, invalidate zswap entry.
> > -      * The swapcache is the authoritative owner of the page and
> > -      * its mappings, and the pressure that results from having two
> > -      * in-memory copies outweighs any benefits of caching the
> > -      * compression work.
> > -      */
>
> Forgot to ask, is dropping this comment intentional?

Ooops. Lemme restore it.

>
> >       folio_mark_dirty(folio);
> > -     xa_erase(tree, offset);
> > -     zswap_entry_free(entry);
> > +
> > +     if (swap_is_vswap(si)) {
> > +             folio_release_vswap_backing(folio);
> > +     } else {
> > +             xa_erase(swap_zswap_tree(swp), swp_offset(swp));
> > +             zswap_entry_free(entry);
> > +     }
> >
> >       folio_unlock(folio);
> >       return 0;
> > --
> > 2.53.0-Meta
> >

