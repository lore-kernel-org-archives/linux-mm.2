Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AACB6D74ECB
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 13:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F02C96B04CE; Fri, 23 Jan 2026 08:30:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED0F76B04D0; Fri, 23 Jan 2026 08:30:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCFC96B04D1; Fri, 23 Jan 2026 08:30:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CAED96B04CE
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:30:24 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6020EC1624
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:30:24 +0000 (UTC)
X-FDA: 84363312768.02.B38604B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 17A9B180006
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:30:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=imenJaq9;
	dkim=pass header.d=redhat.com header.s=google header.b=FDXwDpsM;
	spf=pass (imf24.hostedemail.com: domain of mripard@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769175022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q7Dwu+CNXtg5bTxCbEyb6A4+Vw/Acc988cNs3Meb1J8=;
	b=GNecB4n8PYDukeUOT1RmpDujPS23TNde/AAycOfuvmBVbCMMXHAmltxfBO1h8UAk0f4Gob
	/5XBlRQVgCaJw0H0zECHP+/uW8bYASEnHB7ZbhyK1hfmMI6V/kLamyr+VFH3voFzuvH/XI
	HkccbUKxCdWwE25LHV1N9IEB6GGHDLU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=imenJaq9;
	dkim=pass header.d=redhat.com header.s=google header.b=FDXwDpsM;
	spf=pass (imf24.hostedemail.com: domain of mripard@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769175022; a=rsa-sha256;
	cv=none;
	b=qi+yLtl/gZbQZBtmwv1PLJy3bMTG3Csq70vSgYhWSnGq/E40Zhn2EafPLmRE7ZHGt3xt7r
	uOCU1SOAgXkFhNL9VikT+Oze4RqY3I79iOSkfh5JhUIXy6lgiNdhNsgLPvqdcOU0d1azDh
	M1gtpgugBW5H44GcRo59ZFlzoeDjkKc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769175021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q7Dwu+CNXtg5bTxCbEyb6A4+Vw/Acc988cNs3Meb1J8=;
	b=imenJaq9hqA8JTO5L0oykHGIrZHtBodsiXHDT+sWDk/tTVbrXCka59ISDepMWa/3mr+qMv
	Fm9mQxCDfS8vtGHeqwaoxXC6D4sWxKiOLo00SAXwEHsxokJcYO97aZ6xVlpYxmfMgiQGeN
	YfzBGCo7onaSPjt3lqGyXXyLHkLXyqc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-Fao9cdKvNdeSzVmnoCIn_g-1; Fri, 23 Jan 2026 08:30:17 -0500
X-MC-Unique: Fao9cdKvNdeSzVmnoCIn_g-1
X-Mimecast-MFC-AGG-ID: Fao9cdKvNdeSzVmnoCIn_g_1769175017
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47edf8ba319so18674845e9.2
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 05:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769175016; x=1769779816; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q7Dwu+CNXtg5bTxCbEyb6A4+Vw/Acc988cNs3Meb1J8=;
        b=FDXwDpsMxifkFB3MZk9Vi5NSyFWAVEFSvxgi+2+ayGC9naD/WVuQf/aBWNvBOkRzqY
         oDjOIpI6JYcc6d3JHlA9g/+LKOiiROOIsFSlBuviopXS7XQKbaoJs0uI/wcnRU2giQa0
         Dedb2Mbjygwf1vW9Dy/o9fhH6OPYxupzyoZn3PiyJmZRf3l4x8CFd54EUSRdWfaBSDq6
         C/OgoHvR7k/RknF3XC5s5GOKd0AUA2bxwuyarx0xC6zLwzZ6K54wdeEp4gnccHuJ6vYL
         h/x3lEpla7Njbg8mdirtM++3KntcBBuysxy+9Ly2IMaBqRFqwp1IGp4740fMrclWCUge
         +EIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769175016; x=1769779816;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q7Dwu+CNXtg5bTxCbEyb6A4+Vw/Acc988cNs3Meb1J8=;
        b=KOEHoQHknkUgsMcHHyie34wDWWW5CLdE5nNmRYXve02jwpirA07TU8M9orDEeuEMWo
         kEFYkXHXl74fFJEa1GnPoMJNzZfsXVchLQ0CilKr26jlVrUpFHE+Rvm5iFHYxwADwQ+2
         0vLP7nnCUPDrdZ1M6z4TvZfrDz526Hj9rXXA6sr8DoBXB2S4ykrv3Gx190DJxUIt60nL
         jfhCgXZLrrrFnqmSekaEhrPayMgNGfO3QK8Aoq9glkrAuFfGpRlDlo2byAm24/AskBnt
         tvG/jZvtCBTT4et7uNIC032N8C2tvPSX4zdFmoHrjIBbpyarr8Dzfg2AvupKlHXuxm4U
         Mmgg==
X-Forwarded-Encrypted: i=1; AJvYcCWWFNmyq2K4+vYde4lzHz7lh8IXUSpf7grPOSaqfeOAsXkfcWGpJ0amBm+9DYJ4GAt0z764XX3IFQ==@kvack.org
X-Gm-Message-State: AOJu0Yw4KHUTMWqqwNiyHPaB5myQsmgcJlN5XUcqW9c+QNUrkYqdoqjI
	UUQxlb3ZyUAVpgsxoQOJEoQCjPuuvB+vtRNHnoOxQVy3pjNt6VGfn1l1o1M5VkX3ywmcZbzvpVi
	AfIHnAKEa98qMT11NL7DrlVwPO3PBh0wq4ej0B8BRK0WaYQVESVSA
X-Gm-Gg: AZuq6aIWVWHxov1946SBm58Ex5neo9SRn3gz+Ias8qX5S6zZdFT+fmNpes8ziAbis3t
	2I74eUhnjRpK15/wvrdbDYM/C3RZ7bM4T76VuOh/aXLIrLYXwLpq6F7FTq6yFfjON7bKmx9gSdx
	KRxVTSG/QdWw41AqjmKPOYuOew3huQs6CrWTyAMSFeiBsukeVQRwm68U9oD0nyevukpzk33voiv
	aBveRa0kVTMIrVdWMdghN01FnH6mjts9G0aSD1s3rjhzLQcx8u5muQzqhQNCh8usmGL4/pai4ST
	6A2A4wvQLEikP9BglP19033IfYBBAGdSr/W1u8+BR9sZlyDOOHyc9inDjWOR7A==
X-Received: by 2002:a05:600c:310b:b0:47d:73a4:45a7 with SMTP id 5b1f17b1804b1-4804c9b4d0dmr52292775e9.24.1769175016368;
        Fri, 23 Jan 2026 05:30:16 -0800 (PST)
X-Received: by 2002:a05:600c:310b:b0:47d:73a4:45a7 with SMTP id 5b1f17b1804b1-4804c9b4d0dmr52291525e9.24.1769175015283;
        Fri, 23 Jan 2026 05:30:15 -0800 (PST)
Received: from localhost ([2a01:e0a:b25:f902::ff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804db63817sm22696555e9.3.2026.01.23.05.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 05:30:14 -0800 (PST)
Date: Fri, 23 Jan 2026 14:30:14 +0100
From: Maxime Ripard <mripard@redhat.com>
To: Thierry Reding <thierry.reding@kernel.org>
Cc: David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
	dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 06/10] dma-buf: heaps: Add support for Tegra VPR
Message-ID: <20260123-meteoric-butterfly-of-imagination-fd691f@houat>
References: <20260122161009.3865888-1-thierry.reding@kernel.org>
 <20260122161009.3865888-7-thierry.reding@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="xayh7cobbiwzraak"
Content-Disposition: inline
In-Reply-To: <20260122161009.3865888-7-thierry.reding@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 17A9B180006
X-Stat-Signature: wdkte9eiok5zzeo94fianwq5mwgpkpz1
X-Rspam-User: 
X-HE-Tag: 1769175021-342237
X-HE-Meta: U2FsdGVkX1+2d+8Y3wlbjZFydzOeKIU+/iQ0h/BPppDxYPkzZlZuqoFI03nqVu73px8P03OnllgM/o1M/Z13LlY5KQ6cfmNH8DAJxlaj8fW1+VJ4AskJhvJaaagCqskk/gGEQVNy+6KyrKmcn2kYgl1fnBKd5QHtY+fFzJ2NAX0ku/sqjiW3vBSCptXaBl2qxcLZM4qyHSxmSKAVCm+u1NjS6jrdzrYN2DgH8GWlHN8bOKUEvIdWJB00UtUq/Tz6PyWLxCfUkSGm6aJOL4EpJtaTYSY2FCSGlNaodJtKDpPUsl8eYYuHWc1ciicMa6rb8w9UHbyEUrXEREPoEZqCpBC2qKdmjOCV6Y17pI7zytV7dw3xPWMqff4kvruVsoiWeyeKLM08yzg3rY2jAcVBUgJy7kRB8LdXV/QS6pUvqZAYZo74c2mhQ+DHV7M+zsf+dUdKXDIBfDLfN6dZuoHc62ZsI9+WcO0Dds7/Zmzuq7ZC8B3O4+9aM6QhENAT3yuhAbI/Y98tMDPUCz5HGNrKNCRmrLQx3/jTanT8Doeh3Sm7VECSZMFmIuQ5I/Ea/lgFqiJ7RAJ13AiXg2NL/3eh4eZdVYsktq+CnheUKCV19GCCkbfwlqnNMmTajBL5xXNnkR6UThtthQKtZ2swk5epIQTARnm3/RNi3+zfWg/exsw6P1ZmSXY+wqliSTl2NixqzEMCrMWalvZ1nUytGBc+rQ1kxco17zBqeBygWmHejh9Nog9BI82d8ulcTFNHlm5uufEdP8nfUIunkMi3M6rBZlAL+WmZaqPXtTmCuC7gdb54X3s848LBt/fKChv9Lof6C2NyeHoNxQXfnw562zr+sEDzmPmFLHHZU6RlnuB8jWMVI543oMLZnUCTzi22zcdXQ2LZZ4SWLpyJYpjngC8qk0tLXdgFoTM3+fp+NSXcnu6S4aEd1mgbYkpMlm/48UemxVXvgWg/BSmO+795fQR
 Iudgcl8M
 Blc2uwwNk/c8DlvOcuGCQvh2Br6Khb4ok+cjSCboAaXmW2XJW47QOZ7G7HxLIPIZncj9xoE9oauylGMPoOcO8ZQsQdipSUKr8SvlAjHQkBaBxQsO/wdWbXlESye7k9eHM0HoApnYS3S8h5CUcEcmyeFacfME4CPxORSN+ZRrE+UUmq4760VPjpO6SDt8C5a5J/MKy0NGSNodhtSfjsEluakrqKH0K6HZksqI91t/JgUxNH8ZPwBi06+1pQPTvA2gkE0LX8kjGKozFp0vi2/9ScV6hoEGMSqE0V1OFMKrmWyRs/OXbuj5fQwjPfypMOViKBwRsTiSx2xBr3w94TsVnHV961ga7nOflxAQuzjoR6ck4FGbTmEwzuHxLNE+fC8X/ZEPta3SB+kp2pveU42WjJt94UarS+Q04fm08FA1MXtfLdTEuD6veafw/ATyFoNwwJ93b/5D5DV6lz+kfUGjibdZakm194DcuVzOFFXR623h37w4/UAYkAXyuohqFOtm/u0X0h/yXgW58ZVvbrW3+x417d3zabc0he2RtGonao8eK1TT3JodJ8XapS54o+VTB9E0tKyoGV6SUaG5Zr6t6h4X2fCrH5FAP0cdPGy4aEBU29i0XaRr+MYE+0pjrcn80OWmQ3r2oY8ER1kyLh6nQ1FeIIu9FlByCJxAaNR+yYTE7PgCbF3TlvGNRn9cBC7SALhzB1TGMBG/kcvCNuGyTqrarOrYBPexIFPiNqx7MGSoeetM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--xayh7cobbiwzraak
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 06/10] dma-buf: heaps: Add support for Tegra VPR
MIME-Version: 1.0

Hi,

On Thu, Jan 22, 2026 at 05:10:05PM +0100, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>=20
> NVIDIA Tegra SoCs commonly define a Video-Protection-Region, which is a
> region of memory dedicated to content-protected video decode and
> playback. This memory cannot be accessed by the CPU and only certain
> hardware devices have access to it.
>=20
> Expose the VPR as a DMA heap so that applications and drivers can
> allocate buffers from this region for use-cases that require this kind
> of protected memory.
>=20
> VPR has a few very critical peculiarities. First, it must be a single
> contiguous region of memory (there is a single pair of registers that
> set the base address and size of the region), which is configured by
> calling back into the secure monitor. The memory region also needs to
> quite large for some use-cases because it needs to fit multiple video
> frames (8K video should be supported), so VPR sizes of ~2 GiB are
> expected. However, some devices cannot afford to reserve this amount
> of memory for a particular use-case, and therefore the VPR must be
> resizable.
>=20
> Unfortunately, resizing the VPR is slightly tricky because the GPU found
> on Tegra SoCs must be in reset during the VPR resize operation. This is
> currently implemented by freezing all userspace processes and calling
> invoking the GPU's freeze() implementation, resizing and the thawing the
> GPU and userspace processes. This is quite heavy-handed, so eventually
> it might be better to implement thawing/freezing in the GPU driver in
> such a way that they block accesses to the GPU so that the VPR resize
> operation can happen without suspending all userspace.
>=20
> In order to balance the memory usage versus the amount of resizing that
> needs to happen, the VPR is divided into multiple chunks. Each chunk is
> implemented as a CMA area that is completely allocated on first use to
> guarantee the contiguity of the VPR. Once all buffers from a chunk have
> been freed, the CMA area is deallocated and the memory returned to the
> system.
>=20
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Aside from the discussion on CMA, it doesn't look like the heap defines
anywhere the attributes of the allocated buffers this heap provides.

Maxime

--xayh7cobbiwzraak
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaXN35QAKCRAnX84Zoj2+
di8FAYCOkztgtjE43ySzEaa0yAsqQduekc23hd1d+jt1Rs7EtiAvzP+ciybiSQwk
DUzYoicBgP4Oh3gf3t211CT8YUccPrYQrrNg2xkUvpgMi28C/P9/n1V75W2MOChK
DyngiCfqgA==
=4Im3
-----END PGP SIGNATURE-----

--xayh7cobbiwzraak--


