Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4F1DCA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 05:36:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DC426B0023; Fri, 29 Aug 2025 01:36:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08D306B0024; Fri, 29 Aug 2025 01:36:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBD8D6B0025; Fri, 29 Aug 2025 01:36:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D61346B0023
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 01:36:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2BD8D1DE194
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 05:36:44 +0000 (UTC)
X-FDA: 83828685528.24.D573C37
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5223E80008
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 05:36:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K21O8rmk;
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756445802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/7ABgTxwsaGc4hfk3OGe0GkOSvaX5N8CZX+Bz0AJlVE=;
	b=7d2B9kt1mKnq70UrL1QETMGujw2c6hbuYCDGaJN/l7v2/ZcC2EV6EausXyzDjtiI32RGC9
	nXjOASS0ubxrrWw0sjPYDVJU03VPhnfngo4TYx+/tYaXadO4E83Oun7eHrX6jr1OhNQON1
	npIRM8IcZ0voRLBMPSZX+65f939w6O4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K21O8rmk;
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756445802; a=rsa-sha256;
	cv=none;
	b=J7l/jIIvcUVyfwEUABWcK8wzY85puz9IpKX8qYb8695XiGoBz6zSn1lfN5IFSbtKkX5DFW
	Pryo9uNwiPUC6B1okRQSBKXa/jFcNsebBWj4Siri+5P4NghhpBC/Azp0ReaucyPQBxUHvh
	iS26gJIFDzdQwMhZTGmbz9W2EMatKn4=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-70bb007a821so21752056d6.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 22:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756445801; x=1757050601; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/7ABgTxwsaGc4hfk3OGe0GkOSvaX5N8CZX+Bz0AJlVE=;
        b=K21O8rmkbc0zqQBR/4g/JAumkznuLOl2hlT1rDtnjzwtFjlEHF83RVN/zhDTaqSD4w
         OyOb1qNNsG+RsNeTuPUnncuz8uDYykw6Wm1oVg3aGlCy6oaPjgSUlb4kN4NrB1MjKrwj
         U5LHtTNCBOZMppfhpft9Plfr5DOyf4SkE3bM/yruJt2CXFmc+CXghbYbMBEZOqCeBoMi
         9ZcmzWVGUHLIqrvGMSV+npQ4RoTT/DVztymA+bUzgGOC0DCgFxOv1KHDPgtIQ7IxIyPC
         lCdErQ5EsglVajv7zUdNZXOxmkxjyv4Mn2x0GGdCsQ2hx7qP/zKeIKKt/hZ9gVnkhUjR
         IX7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756445801; x=1757050601;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/7ABgTxwsaGc4hfk3OGe0GkOSvaX5N8CZX+Bz0AJlVE=;
        b=VJpE1Ui/ZNpPy9rU6Wa/Zm1Q/tvnptXdxj5eBmYot7SicCWnj+z3/cOPuv1cP2uDRR
         lqEHw7RnLgW8ANtNRLuRe4t40C4veIbexVzfUm1dt+Kvr7YpPmdIa4WuYCD2HXhB677h
         tYcejj8dfLK42MLeTuGNreobSdolRAFQLYyhOOOeBG1lfB8nFWamiTcYBw6yyyBCyyZf
         r3Wb0ETYvkdXNIsD/KHvGPOLIWcsk1W5LJ2s+q8HoeYuFy0RFNOXJuCCPEZtjMorIrK1
         /oJaUijW+ipXj7WpGr+qUWCzQpkpa+o+0HyuNJgSqunV/dM+UlR5GSyPhy/hCUGfM9oW
         AlIA==
X-Forwarded-Encrypted: i=1; AJvYcCUQQ6Kf1myPqy8M+WbWaor0jPQGnZIu8s4SaYh7k1h0K2A3Bpfk5xUsKx/8NOcDtfg3Dcd9Tekl+Q==@kvack.org
X-Gm-Message-State: AOJu0Yy9+NPgXL1Fgiim3DgtlMr8vm3I4MaqWmb6TinQX6VgnJ0AsM6s
	OuQQORjCXK+lTty1LtTrfQnG11ZtAP/PCoiJ2Tg4Y+AghPLJXXdU00YliiVPjiMFyZuLLTZ4tm6
	mVa8SXcUm0P/TZzsnMTDLcH3WaA+lOJA=
X-Gm-Gg: ASbGnctMrsfvC76Sf9IWp7yAgbhCDToqTrS5ndxV5lLyNrg6DC5KDFhV4HfSmHlf96j
	/3oH2r7GNygqj96S93JKkQL3bvNrT0KZunNWrLydRcLQchQ9kSgjL7e9eAC1hoHgsNQTJn5gTa0
	TwqKvQ66Q0mRkJRQ9rPfGCHXVZlh4pEG5eTyjLNQUHYGNWCqrGVMoNbEh5yC+K1fDsmnHq1l0Bn
	kPXJZbdpmo94w8gAEA2I6y4o3wXmP5m8N7ErS8A
X-Google-Smtp-Source: AGHT+IGq8OntLZha2E+RHRzjfT2kevRfQDBROpREspWyrgfBnKhulrj6jbFwS3r1qYQLbJVZUxHzKt/hQ0CwFQvkx/g=
X-Received: by 2002:a05:6214:18f4:b0:70d:eec2:cff2 with SMTP id
 6a1803df08f44-70deec2d983mr46345376d6.49.1756445801302; Thu, 28 Aug 2025
 22:36:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250826071948.2618-1-laoar.shao@gmail.com> <20250826071948.2618-2-laoar.shao@gmail.com>
 <CAGsJ_4wa0gC7FQmUP9HQxbacheKFRCqMbnfXwugeyOzhOS4McA@mail.gmail.com>
In-Reply-To: <CAGsJ_4wa0gC7FQmUP9HQxbacheKFRCqMbnfXwugeyOzhOS4McA@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 29 Aug 2025 13:36:05 +0800
X-Gm-Features: Ac12FXzur8PyRFGmxf0SsAofO8ehtJn06i2WVKKAJDTji0n-pHUGNLV1GMbF8dk
Message-ID: <CALOAHbApA9oUR2f27=HnsJASekTR+4tiBaXu1opy=CgLmogNWQ@mail.gmail.com>
Subject: Re: [PATCH v6 mm-new 01/10] mm: thp: add support for BPF based THP
 order selection
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com, 
	rientjes@google.com, corbet@lwn.net, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5223E80008
X-Stat-Signature: 7redxbjqts86jc8aguyqed8haehkajwx
X-Rspam-User: 
X-HE-Tag: 1756445802-167233
X-HE-Meta: U2FsdGVkX1+y3/Y0WlUSq82YArW1xrX6VNJ5X+DWbAR90G19EfkMsHso8FEXAwBEONh3GVYI/TsesOTDcrSSDeCZDIcTiy7vJLR3xdJHH9IwOdAgxJzuuBw0YdJrc8FXHW6Nx8Xa6aEo8g3HO5lDFLVLLagOvuBNK/iALBPrGPsQpqsQGTsLP2OiOaU7x9b5MREMyVKsuukidZfaDvBvWBCoB/sVVRydlXsHbh4CcleTvvTHt1hnOFS+zgrFTsWCqnwWL14rlHOvGMKaBtF2eKDa8mhvtkVHlN4oMyAYbqSGqprd8olMdrXMpqhuhtwLH3rJehq+biVDnNJifuHwgXNnP3MN9EPwJoiG0O4a/YC54uUOjSFCANIERuUDPcH1XxGzvgJ+ZNltUpVKHjxvqtfjeh6lvXs6qZm98XJpi0xrELdWdPenrnNWqWAkakqFnCAlotFkTHAEmuZ3nSKsvaID1uPnnSxGBJ3BNtj0D7RswXlXGF0tSpedaB0UXscGo6kaPGqEbv230gqte/LdDQWpgam3mdCRb6lhKrtz8teqSiod+YhCG0X0+KdkNIXM2VoO9PFWKfaKe/bUyKLAVg+oy32Qhh1Ef2JYXqBqsC0y1oDSD44H9glRlWt+48HeTgn07931wRZYqBKZse85zfSzHH72DAT/0lgSF9gOCZtITv3Icq4wP1nHH0tF50Pmwv/kMppaCDKPJI5iLFO350pOhRyXozQxOoXEGYor25+yKNV5an6QRmqtEN2TYPhvnz3/d8GDCMOj3LiM95r7i83bmaMtUB5gGujyfoDx2WHIUZ9mnqPOOghAWR9xJjXLHVrSPZ6fIM4L/PQ1we9ZqGuagGghOM3V1wFNOxmacn18jnOjnnLypCiUxakpL2eNn36HL/xo7HN2r6bQdnoul4bq77Y7mq6Z3JFkyVe0nuH4D2aYgWMb8HvFo3RE+Vz9rAwRuYM6ADEEwd9aRIC
 0lIZOlDO
 2edEiOCXk7BfHP4n4Nq5Ja5lMXXLWsr7CAis7e4jAxdvJ34sAvxOwsik7i6poAvVJjPQTot8LlRU7oN3GFKeWUDhIUNz0jD+1z3G4+SVlmfBxaYisPEIuRnrzFvO79ywsE24TDgZ7VvRMXapC23nqSJgsrba+I8akYqAFP/75Vw8Obxy0jTzU2mEuZKdhP9AkPp/NaEd2oDY+uVD4JDoovP6wWejvemh0FoxVC0FhmBSk7+7c43TxbvUlWw0PY5/2QnXI4Fnsv/YCxtqxJ2lWPl30h3a+i2SgZQf55nJB1rKnxIfx8/EdGWBrz9YZgcozmQw6EeDR4+VetJjvJjzr+7RVyZK1bdTSJVixEyAt6wQ8GYimGLVjheCuB2hputgGZiDNLIhFmVGp20IgTCyYapDDev475y81XZ8/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 12:56=E2=80=AFPM Barry Song <21cnbao@gmail.com> wro=
te:
>
> On Tue, Aug 26, 2025 at 3:43=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com=
> wrote:
> [...]
>
> > @@ -4510,13 +4510,18 @@ static struct folio *alloc_swap_folio(struct vm=
_fault *vmf)
> >         if (!zswap_never_enabled())
> >                 goto fallback;
> >
> > +       suggested_orders =3D get_suggested_order(vma->vm_mm, vma, vma->=
vm_flags,
> > +                                              TVA_PAGEFAULT,
> > +                                              BIT(PMD_ORDER) - 1);
>
> Can we separate this case from the normal anonymous page faults below?
> We=E2=80=99ve observed that swapping in large folios can lead to more
> swap thrashing for some workloads- e.g. kernel build. Consequently,
> some workloads
> might prefer swapping in smaller folios than those allocated by
> alloc_anon_folio().

make sense to me.
Perhaps we can add a new tva_type such as TVA_SWAP for this case.

--=20
Regards
Yafang

