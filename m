Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B281ECD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 17:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E2496B0005; Mon, 25 May 2026 13:07:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0925A6B0093; Mon, 25 May 2026 13:07:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9C2F6B0096; Mon, 25 May 2026 13:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4AF26B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:07:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7881EC05DC
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:07:44 +0000 (UTC)
X-FDA: 84806574048.10.6769D8F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 273671C0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:07:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZU0dvcZS;
	spf=pass (imf18.hostedemail.com: domain of vdubeyko@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vdubeyko@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779728862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bQpQr0JjL82H2nIQzETTKVEBOyaYAjIK/HdNyKEHU4Y=;
	b=TTSCjhP5ktRlPy9kj0Sx3E2OGcqwEyH/IPAVuuPd+sIFE/O+wJUSil7w06CsppYSuUkdBo
	tWL65nobVQIC77dZ82S8boU1d67758ZaiL9mzhcJF8uLweg8d9WC5Ga4Y+79XnHsxUTddc
	IHJTQRfugrQYy2KZ4H5zIAr5aGlPv/c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779728862; a=rsa-sha256;
	cv=none;
	b=5aQzW/+7sCpo/hgi2cdlC3lJRv4zYA/AocKGuM4XFFf71g8LTuICEDwK+surU63basRW71
	99sxzJkSv6/wehl11tMQ36ganS5PEFbNpLp22hm24XaR0mtj2pvCCUktbjesUZdWAPsEk3
	sexkqR5naMSnAXkSCVksXuZGPW663vM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZU0dvcZS;
	spf=pass (imf18.hostedemail.com: domain of vdubeyko@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vdubeyko@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779728861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bQpQr0JjL82H2nIQzETTKVEBOyaYAjIK/HdNyKEHU4Y=;
	b=ZU0dvcZSMDF8n+FaBHKHnfeR04HOCTyN3XZbRdVt94/sv7ieGBX7Q+MUPBtWAehFopw30w
	pGIkLSaiv5N58D1LlgZ9BahEX7WCSB0AWehI9pbqDdG9UXO2S6Q0CRDY4jYOJ+yLy9QZKt
	WOJV6IMNX/4oQMdd7fJRXJodJ0LFdEA=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-WtNWStQ9MNGS4YulKtHsdA-1; Mon, 25 May 2026 13:07:40 -0400
X-MC-Unique: WtNWStQ9MNGS4YulKtHsdA-1
X-Mimecast-MFC-AGG-ID: WtNWStQ9MNGS4YulKtHsdA_1779728859
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-7bdd1ef8648so162385777b3.0
        for <linux-mm@kvack.org>; Mon, 25 May 2026 10:07:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779728859; x=1780333659;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QQ8f0KL2cvJbeqS1wq3el83kZ9Z8vH79ZAL6r1+vgks=;
        b=PSBrktV87R+jyAE93D/HY0QpTcBvYKtpyKo6OBBWXEWuDzRJTobM4kylHE7XAX6vUL
         bqN6TjVtccTVXorP93aQ+K5qSvL4vcmH3pRhF3rnYh0k/DUEpldxe7bzYdypHGAtrQeq
         WI3gcBFAwZAOWP+Kt3mHWFTjbrDMGqrp17z/rvJ8tGpQT2nsbe1D5HlQHwRUBnONvvB+
         mHzH86axarkERtI6fjNBikZVKa+Bk2BZo4KD1UZ3b6CmFprdEvgHzZNtWZH+adSkdVzf
         O3NGx5cnNxW/133EhXy/ebJAdRKzdyzpAJiFPVWXTCXLogvN3zA7xXW8xySbVg2HIZSe
         pEkA==
X-Forwarded-Encrypted: i=1; AFNElJ+TCZJAuDu634x/w9X1QWy2Rwm7khYRoGYGTcKy4LloHiCZTxZaQtAJhl7qYLcXxDgAOvYl2nYAxQ==@kvack.org
X-Gm-Message-State: AOJu0YzZFXL9qtSeqcXKPluSzNzaMfbRjjG+QKtDKA3GaJ8orPQ5ohde
	noiZYkdi2XibhmIRg+oO+sAXZsjX5oEFn8wOTXAINSnqV0Mo5mqs+zSLup4JovpxvKyreysmXfh
	Jrymr+3Ww1WSK9HWsvWXETthYpfp7A8mfX8xGX1jHVLqHsHYPGPh9
X-Gm-Gg: Acq92OE7b+yEzbr/kdCgn69ByFsp8JH/1Z4iEFL50DKL5Vv6FD8YjfDwfsTZEKjfJwh
	TTaZAyHtNkhJMyndCHscVQ2GxTJWB5qKtbTmnDkRacMPQJyjLnBAYBE4IBwYDfxa1Z2T9BhFsT2
	L+xEECyvz66NGJJwsUcNt0FY/dtqpAE8leVOfDQ3CbJDPMKtwn32z8oqKWBoq4GUCXnXg4hczFG
	wQkxrY7w9kwkZqEqTHvSu1kg6ZoL+wuD0cfczE1Af7S9aHyZ2LiLJduK8v1V9xRL21M+ZHDabW+
	iE9WtSyRPEZ1DZnNxjPIBmEc4qTMETeHbpDnKgCcNeWhJ6OWFxZHJTFcvLF3wWY4Xg39/qx+tmI
	jkFcvA25IB3YO0u01zBE+G+qaRQflw8SqjIShzhX49zAYDXVqraPf
X-Received: by 2002:a05:690c:3708:b0:7bf:9648:8c5c with SMTP id 00721157ae682-7d3345da2e5mr155237857b3.18.1779728859446;
        Mon, 25 May 2026 10:07:39 -0700 (PDT)
X-Received: by 2002:a05:690c:3708:b0:7bf:9648:8c5c with SMTP id 00721157ae682-7d3345da2e5mr155237227b3.18.1779728858828;
        Mon, 25 May 2026 10:07:38 -0700 (PDT)
Received: from li-4c4c4544-0032-4210-804c-c3c04f423534.ibm.com ([2600:1700:6476:1430::29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7d389813ea8sm48480087b3.4.2026.05.25.10.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 10:07:38 -0700 (PDT)
Message-ID: <1bb537f6dc36b00788b613fb8f71579478418457.camel@redhat.com>
Subject: Re: [PATCH 04/17] nilfs2: replace get_zeroed_page() with kzalloc()
From: Viacheslav Dubeyko <vdubeyko@redhat.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Jan Kara <jack@suse.com>,
  Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph Qi
 <joseph.qi@linux.alibaba.com>,  Ryusuke Konishi
 <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>, Trond
 Myklebust	 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck
 Lever	 <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
 NeilBrown	 <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai
 Ngo	 <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Alexander Viro	
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
	 <jack@suse.cz>, Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o
 <tytso@mit.edu>,  Miklos Szeredi <miklos@szeredi.hu>, Andreas Hindborg
 <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>,  Kees Cook
 <kees@kernel.org>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, 
	linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org
Date: Mon, 25 May 2026 10:07:34 -0700
In-Reply-To: <20260523-b4-fs-v1-4-275e36a83f0e@kernel.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
	 <20260523-b4-fs-v1-4-275e36a83f0e@kernel.org>
User-Agent: Evolution 3.60.0 (3.60.0-1.fc44app2)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HzulBqQk4LAj0MDel_CkaiCI1ymnqpkTNpujJBnG5YY_1779728859
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: 9fk6513aaoo5usn65gkbur1hhg5pjxiz
X-Rspamd-Queue-Id: 273671C0005
X-Rspam-User: 
X-HE-Tag: 1779728861-37940
X-HE-Meta: U2FsdGVkX1+xZoK2YdcGrgE512QtbRaA5GmE9Adm1UAY6Usb5StY8Q/f1BCC9LoL/+/RK8ohwXZB7PHVzsi2c6p/B/GF95dQLGgOl78lVyU/rZCH4DSfo9rWU3xZRoeu1rdBYq/Me25+7Opn7uEHjgofGZ8t50A/NWlYPXIY/CUEkFjvDOyVEEovfHYe1mvs/8G/B5O7KY8N8zUjHoU45vScIAO3sJmOxvyMRFdOgN3/pCAineCDlWssVU8kFN29RR3lYGMBOhaGakBG0aBrBqk/aDDXn1gs6P3MUd1VyCntdRU1u3q6UgIl3K8PQL9fHuTDX4auVqyq7KG/Y4u78xZFxUQ0oBV6B0aH6DAzujVPtXjho5ovJsQG/OoREL95Ji5bwbQszvI9Q4Rwg50u0i/6IBgZE7hkTTl/r7RcZsCs5U7kKyHIisUTKciZ+ABJwr0K5cUNYsl85S2dTvbgCNFJxlrvR7RqGp3jjY/0EpQxArhd/gcua2kg7ZGdALfpgD1knzDZ+kBvGHkubc9nTKLm1niKMZJWnpgMHq3ElTpot9rZCb6xdS9Wxoon6WaOzPr4+lAtagMkpMVnMIX1OzETqy2IHSW2DQ53nOpCqTqNN9gFw+O2NMLSbuxOK1XeeaHRRhEDNZTso7z/vadxLSlFUc1jVze6E9pYbPpC0r/LL7PhyBsaLBcAmhs1+ZYOJGNswBmoyNBRhK89aNb+AinrvErYk9bYk4jWUlH3TANOfZ9Gl5RKabu3+Sng5CdhBdyvzExIHP+vz9J8ov7PiwZ32rs/nbBJLpO5tsCnkBhlP9aD++fSaFv4UmHG3AfdX2iBPcrqEJ3hUdh6IgczzyMCYH4KNytsutwnQIDKs6g/xm/zj66efJwrniKc/kHjR0BnEPCuDGx//gq5jgG8n1F5t0wkZrvQLj4KOC5Q89sYRCPP/hQkcnBfxCtHue8mK6EPoPE/wxEiHfEvG6f
 8IYzJ0va
 MQlhQA9vxWX8DDVrlRq7Irdr4U+cJIjb1u8d2SuC6PNXqwoNlKZhDpi6A7wVdWUFUI+nK/S7ncb4Pm+DHsWqCiPn0SCiLSlKvPMaxyic0qJRdeVvdKKipkD0pPhBVCjCb7XNnDyM6RgluXXvEAdd2qRej4BrZHFAX8vasdXXzVRXBbZWDbIsLotWF6w+wehtwDWXOsXVpA4TtUHW1Kp0RKR7cevulInx0xuwIn7F8QDu8pUmNPb2Et7NJUMk0dJRcArymNPZnMcOz55q0b/zDS2qK/FFOU/EnizG7Xq9bNsUBYpWu3A+SR1/U0k+EfSpDThptFS1rV2Z6RI4/Sp3dNZbeswlXSBzf/oc9GXPB9Sq7EmnVO1krVaMrks1sZpmxadM4zYfsOzLSl0+BK20SVSvNV82osNL0qxHU4fkBQat4ed1ksRqNm5E6NxuoLWt0UEKWh1+uxAnVj+hf/g31m3ooPmhfhHDyWqHTZJz6hwk5ikyFVUR31E6Y42o02P0YA2fAzfjr8YAD5pUPMI1ampl3kzb4BCHg7dv3ZoD+i8WYcYS4ajLDUVhjCZ74cwJLRJZPuxKJ1Hot2HZ4HOJukBLx8cSbjsECrrP1NTbhtraDQqXg/+agvElOgaKGcOIYKhFG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 2026-05-23 at 20:54 +0300, Mike Rapoport (Microsoft) wrote:
> nilfs_ioctl_wrap_copy() allocates a temporary buffer with
> get_zeroed_page().
>=20
> kzalloc() is a better API for such use and it also provides better
> scalability and more debugging possibilities.
>=20
> Replace use of get_zeroed_page() with kzalloc().
>=20
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  fs/nilfs2/ioctl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index e0a606643e87..b73f2c5d10f0 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -69,7 +69,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilf=
s,
>  =09if (argv->v_index > ~(__u64)0 - argv->v_nmembs)
>  =09=09return -EINVAL;
> =20
> -=09buf =3D (void *)get_zeroed_page(GFP_NOFS);
> +=09buf =3D kzalloc(PAGE_SIZE, GFP_NOFS);
>  =09if (unlikely(!buf))
>  =09=09return -ENOMEM;
>  =09maxmembs =3D PAGE_SIZE / argv->v_size;
> @@ -107,7 +107,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *ni=
lfs,
>  =09}
>  =09argv->v_nmembs =3D total;
> =20
> -=09free_pages((unsigned long)buf, 0);
> +=09kfree(buf);
>  =09return ret;
>  }
> =20

Makes sense to me.

Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>

Thanks,
Slava.


