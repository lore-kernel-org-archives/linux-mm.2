Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED015C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 20:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 780D78E0005; Wed,  6 Aug 2025 16:58:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 731218E0002; Wed,  6 Aug 2025 16:58:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 620188E0005; Wed,  6 Aug 2025 16:58:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4AE988E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:58:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CF9151A071E
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:58:33 +0000 (UTC)
X-FDA: 83747546106.30.E2AF9F0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9E93C140004
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:58:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RqDyPvtk;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754513911; a=rsa-sha256;
	cv=none;
	b=WDlQ0dk+DW6MsgQ6rAbpZh5OnUzVp4KkSFS7+J2NBwHk9lAvji/DaNX9om+WXFxJOQIcFw
	tu2/eu2h3K4xuDhKc9LNwUr3+R9RavZDo5CCmF+uN1siVuJT3YuZHmSvGhYcPFgAJS5B3w
	NIAhV9smYLHniqyjTkz3p3RCBlWb1pM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RqDyPvtk;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754513911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fFNdR9gJvxUJ76WkzFWy6OZiky5m3qPp0Fyvysc9k2k=;
	b=QNsYQBarsZ9RKbqebptWQmRzzXu7OLtK+zgKeg1YK+rJl27YnhMmxXSwn6RS/65o8qq21e
	jfwlaeD7wIGvLC/4E3s4tlXSRXZKhSgBZWIEX+AmKhfaJ+R47Hfp19sUvFVB9U484uaYaF
	y1ZHqQ+5bBlI7L03nYudi8QJTrC29DE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754513911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fFNdR9gJvxUJ76WkzFWy6OZiky5m3qPp0Fyvysc9k2k=;
	b=RqDyPvtk7mRYQFeZYbX4XVaO1ZfuPpuIZncu7aPnyVXPTNibSw8sv5iB4qKSq00dEkj9EW
	YyobAOLwSO+OQFYZJwEt+Ky30a5+whsvrJd1J5ImUInQJ9TlEZYfEBFORXvGspCdwKOqkP
	Fr8iJpnvGVNdWc8IJfdUrU1I99Czl3Q=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468-jLm8pdOeN9u7YYmjhUX0wQ-1; Wed, 06 Aug 2025 16:58:29 -0400
X-MC-Unique: jLm8pdOeN9u7YYmjhUX0wQ-1
X-Mimecast-MFC-AGG-ID: jLm8pdOeN9u7YYmjhUX0wQ_1754513909
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3e3fff9eb72so831055ab.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 13:58:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754513909; x=1755118709;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XL3JtSDnypcZCdbt3A90Mr99TpavO/k4/VrpLyiBez8=;
        b=XRGPnoXwtwH3+9Z8kCdCctJDSezjBFdikp3YHvmg4q/NkSTCnGohOMq4Kq+I+jtCYl
         tgag2jvkDudT9FwCJJ5vYZpBEOdtZckE12Joo35VPO8BzgmKTHO7F7+qdR9BoGkeJdkh
         G8LYgVW/6ETgn3TqXY11SVgO2BgJMfnw06BdOtmPcLgK2zomiVP3oTfad5X+D+rbdC3X
         zPIyk2AzGDQNRANvyNP5AwjMlA8UAPSs1gZxSwsi65Br1lIepracW/15Iu8uv5LOBco3
         uDdJI/SkopyVUh+ZSb9HpptsITLNJ24gWPMAbhvwp2Mq3RZ9xRyi6HbEZ2hVvexBZp44
         Q52w==
X-Forwarded-Encrypted: i=1; AJvYcCWYgvCl/n9uDTcLu3M7Utc/9AcFwceg6jwjiXXpMnVUTg/gQHLORgzwja5/z7QSrIWwghA1+A1Bmw==@kvack.org
X-Gm-Message-State: AOJu0Yx/qpZKqZY0cIMQ/qlVebQ6ks6w8ZkVnV4a57UZjQ6ktpseRFVX
	qen7Kzd/wxcgHahI1yn94SsE2PLLV1bVQjippMNlLcSHxJXysU2GAH0kMBaysivcCpIrrXTOmql
	sQwqVe7dM14wTvQbzJoVYOlwKunHcQ/7tpxiVkHTO3PnwBZ9ejp0x
X-Gm-Gg: ASbGncs2I5S3b0F1EVaVz04yEf421UQTnBWuzeFw1khDa6yT9YvzXvgZE/a04mRDo2W
	ynmgYuJjhgu0dgkd43uU4LO0USCGMQEUX7zsUwuENdFqZeOevJK6oOVzFlBRy9BgUAD/KVCWU+1
	e8bCi7up2yeuqOazAOhfvXgEhevNJ0KjpGJXrIu3SzSbTbb2TYUK73crTVIpd2ZComlIMOEcRbi
	wqpk+ybYnM9W5dxbCpUihxgA2hAX0RTOL9FUtv20AtJ2GckYSVj1I2LOVn6JoKu01L0av5d8taZ
	tc4IWmQGMeS1KQHtBx2usMoLvoGaZ7o7TG9zGj2jqoE=
X-Received: by 2002:a05:6e02:152e:b0:3e3:d2eb:52db with SMTP id e9e14a558f8ab-3e51b79eae2mr20687085ab.0.1754513909037;
        Wed, 06 Aug 2025 13:58:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEvMHObcGautLtJ7984K/wyyriLvMdPXmyUUT5V0nwJ7vFbNm7fOcxZIXtiLyBYuGHd6raZZQ==
X-Received: by 2002:a05:6e02:152e:b0:3e3:d2eb:52db with SMTP id e9e14a558f8ab-3e51b79eae2mr20686945ab.0.1754513908609;
        Wed, 06 Aug 2025 13:58:28 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50ab01e84desm2049992173.51.2025.08.06.13.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 13:58:27 -0700 (PDT)
Date: Wed, 6 Aug 2025 14:58:25 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>, Christoph Hellwig <hch@lst.de>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, Jens Axboe
 <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, Logan Gunthorpe
 <logang@deltatee.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin
 Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v1 01/10] PCI/P2PDMA: Remove redundant bus_offset from
 map state
Message-ID: <20250806145825.2654ee59.alex.williamson@redhat.com>
In-Reply-To: <c9b6237964b9606418af400bb6bec5178fcffff2.1754311439.git.leon@kernel.org>
References: <cover.1754311439.git.leon@kernel.org>
	<c9b6237964b9606418af400bb6bec5178fcffff2.1754311439.git.leon@kernel.org>
Organization: Red Hat
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DEUveq4xnkOGZqJyQYk3DiKtUfN62zTME4b7KsxRIsE_1754513909
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9E93C140004
X-Stat-Signature: kzdgw77sntgyqcw8a16uqt3en4fgzsem
X-Rspam-User: 
X-HE-Tag: 1754513911-200088
X-HE-Meta: U2FsdGVkX18hM2ypGfV77j3p9IVcoZ3nepI+cG+n9OngfIu/fFcNqbRx0XR57N1pedIpxeSe82/aCl2CILaiu8UPEXxbiQ5svV27XEqqw2VA7/txY20QSVpU0pxKZyHLEPbXxIDtVbpHPNibwfatJEyOtFTzdyjfhoXxcHK7tgaF8UiXuvyqTQAAqotqI4Ctgq8iP3iNxVZAwJU/EgB6ADl6MRbbCDwxy5nQxY7zXBRUDtE8HZpRMpCvkG6PcXuuENuZulrQQnXj0hxd2Ap7WwQ51wF8hr0xkImDyf0fWTl9T5kTqe74NmywMiC5Jr0j9+sFYILScJTzG5JtOBzbEBemF9wB8T/tUpntEicSAe3A4IhZ9veqN1yWjtw4aI46SiDD5vXqYXgD9mXrHnIUNBx0GOeaOIj/D8dXHzruT4bEfRMViHbtIOgfEymZUINrrlTkkg2swjZcIQoP8Tzvg5PtHgnrl0YWMS2hDc/4S6HPdNvpD2Aj5XegCPy+ZuEzvifdp5Lh3hkEvPXAStCz+jMIqetbhL/j9kaPfcWgsjkcR40yThxNX+o8Fa7f0aBBUrKmYGjerhrrVZ4KPpyciwl4ZD3tAcOhOmR1I3VSvS5Cui/D9rr7EdbXOzm6xD/3Mvhi3VOtskyj7VqFsuHRvogr07IhJpNZWpDBrFXtgTf2UP74UKLB/lg8eTflT1DnZOlohPmu3mJeJ6NSyZDDUwSWVhNaZGfU525XL8JOgAsX5jHd2Jqx0Q1+cWWLmfzQMI05Y2iB5IkyemnRyyCt4NKDHFdMt8nFnd0K54vbWh/eF642zGvBvEvKGQl4S8kzIuRgmt0kKfK+w2Dw6uoeAc7UlsFdIPCkvhwO+JE9HgYoWjepZa6LlT1REWb1qQKR4iJCZa82qzDXW2tKvTPlVpdeE8lsCMZ3wY4f/2Gp5SfgTpMDsHTfHJij5Qgt40VjlcLwDZRVKyLei+JiZvs
 PhPdklox
 X9Egx1B/UXNUzrYzN/s9gqwlzXWbMxbL6DhTrgJVhySCQTTVJyYA4LYcplWgIqIAIOJMiivt8zAjz9JyzLS966/WkSee+vyuhH4R7M9T7OfRLo+mrShjzWDuWRWKyvBSN5H5R/1gbll/Gw1bQUusQiXzN1KT0lldgP53EJ0oFYsXwgeafs1BEl/4Q8SDYr2A/VfLWIVaRERw7flHJDjOw6soluO6hOD8V+JXpOicsJASD5n1siuOQXH+STBE4XNBj3u5YBE6/RmBZRn10eEkN4oYqvQX/jrnWFSLG3pVv5600iVz5DsJpBhFcMXuPYpO8F5/jmVVRcwZ70ARKp3eoqDyfcIdZd2BKz314N4Cmyaqni4aTqf08N9/dQVV3FYFoK6RqO30GmipvWPCTrXlN0VhsIHCgftmumSEjDi8OipXthRE0XUomjcCTNOJK24qpb8t6KndpPESRl1Z53Y2mEveig4alexLCNnsxmwA/wx4X5VNa8u/FAxaTew7kJz6D/QFUC1l4aZpAwKedoOgp+F/qUDVJ1s3IigMMrjzdxuDxqXE41+z2yOwyWzcTkBld+Iq3Q8up4VVtiiWxyMb+iDgmiGlAhfuIxMRRQaZbmuS1Gr5KgUqtM6n+J+gvOugwuJ9B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  4 Aug 2025 16:00:36 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> Remove the bus_off field from pci_p2pdma_map_state since it duplicates
> information already available in the pgmap structure. The bus_offset
> is only used in one location (pci_p2pdma_bus_addr_map) and is always
> identical to pgmap->bus_offset.
>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/pci/p2pdma.c       | 1 -
>  include/linux/pci-p2pdma.h | 3 +--
>  2 files changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index da5657a020074..274bb7bcc0bc5 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -1009,7 +1009,6 @@ void __pci_p2pdma_update_state(struct pci_p2pdma_ma=
p_state *state,
>  {
>  =09state->pgmap =3D page_pgmap(page);
>  =09state->map =3D pci_p2pdma_map_type(state->pgmap, dev);
> -=09state->bus_off =3D to_p2p_pgmap(state->pgmap)->bus_offset;
>  }
> =20
>  /**
> diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
> index 075c20b161d98..b502fc8b49bf9 100644
> --- a/include/linux/pci-p2pdma.h
> +++ b/include/linux/pci-p2pdma.h
> @@ -146,7 +146,6 @@ enum pci_p2pdma_map_type {
>  struct pci_p2pdma_map_state {
>  =09struct dev_pagemap *pgmap;
>  =09enum pci_p2pdma_map_type map;
> -=09u64 bus_off;
>  };
> =20
>  /* helper for pci_p2pdma_state(), do not use directly */
> @@ -186,7 +185,7 @@ static inline dma_addr_t
>  pci_p2pdma_bus_addr_map(struct pci_p2pdma_map_state *state, phys_addr_t =
paddr)
>  {
>  =09WARN_ON_ONCE(state->map !=3D PCI_P2PDMA_MAP_BUS_ADDR);
> -=09return paddr + state->bus_off;
> +=09return paddr + to_p2p_pgmap(state->pgmap)->bus_offsetf;
>  }
> =20
>  #endif /* _LINUX_PCI_P2P_H */

Looks like you're relying on this bogus code getting resolved in the
next patch...

In file included from kernel/dma/direct.c:16:
./include/linux/pci-p2pdma.h: In function =E2=80=98pci_p2pdma_bus_addr_map=
=E2=80=99:
./include/linux/pci-p2pdma.h:188:24: error: implicit declaration of functio=
n =E2=80=98to_p2p_pgmap=E2=80=99 [-Wimplicit-function-declaration]
  188 |         return paddr + to_p2p_pgmap(state->pgmap)->bus_offsetf;
      |                        ^~~~~~~~~~~~
./include/linux/pci-p2pdma.h:188:50: error: invalid type argument of =E2=80=
=98->=E2=80=99 (have =E2=80=98int=E2=80=99)
  188 |         return paddr + to_p2p_pgmap(state->pgmap)->bus_offsetf;
      |                                                  ^~
./include/linux/pci-p2pdma.h:189:1: error: control reaches end of non-void =
function [-Werror=3Dreturn-type]
  189 | }
      | ^

to_p2p_pgmap() is a static function and struct pci_p2pdma_pagemap
doesn't have a bus_offsetf member.  Thanks,

Alex


