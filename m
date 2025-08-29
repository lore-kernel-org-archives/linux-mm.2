Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D55DDCA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 069F06B0022; Fri, 29 Aug 2025 19:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01A866B0025; Fri, 29 Aug 2025 19:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E51D16B0022; Fri, 29 Aug 2025 19:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C99576B0022
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:13:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 78EDBBC24B
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:13:55 +0000 (UTC)
X-FDA: 83831349630.12.FDD7DDB
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id A4CBB40008
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:13:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GpRQggpp;
	spf=pass (imf27.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756509233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xKMZJwDjsVTmitG4egl5rJvGJupwlZyvs6dgtCP+Rz8=;
	b=LZcOlOHMTgHBh3PlEuc+jVFmOvpeZ1NIYfKoVD9OQSvn53yr/Tt5plePTOtsAxrAX1rtxM
	SbkZkIFawUfrb8nFPBb8I8jF0hV+DM72Upf9AfA73i82uBRHsBqyYZ4hMRf9HHLarKO/Qp
	F1Z5L7ykkGO7UVglp1tg703kRbfTWK8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GpRQggpp;
	spf=pass (imf27.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756509233; a=rsa-sha256;
	cv=none;
	b=fct4nLH0CNOsWbPAPcrRwpX9qB5CX/zL9HtrBWp/e6450VIVH/FZrm7XQZzuNTZiKdlf1p
	vxLLyvy8ySE0NKQr82HTFEc46GwGpzbktpZKY9Q4nyrFcs9ZU3ZxuWgYUEqvrgFYhGpZZa
	Z2I3fp0f24VyzKOhxsLyMkrROhGV9nM=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b47173749dbso1948076a12.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756509232; x=1757114032; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xKMZJwDjsVTmitG4egl5rJvGJupwlZyvs6dgtCP+Rz8=;
        b=GpRQggppOeMFBjOHJBYcHns2s6h3FLmgR4mrRYH0Qgzi4seGfdk9/jPYgOYG2H+7N8
         5HuwYMsis3coBcQNQL8Sr7z2oum/5Rsg13q2tkfSoV5HPI8Sb9ek3JTpLr3w4veLUQps
         nz4QMLOcFwnb/6cQATx6XdSqCImBirQJnhMJ0w9v7KIDl5Q/N5oWBvo8zz38JWGUMfbh
         gDpPMNyTi69ovE+XO/tPoQ9X/KU1vj/xwedPZBCkq9/yBRh/IUgESukuOvZHiRa+3USX
         D/vsp3c3RYgf/5W9nzfQDnAPOrUbLsyAhXF/LkWWEjSWOVA7C7P2q7R3XEQWpd00cQ2y
         7Z9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756509232; x=1757114032;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xKMZJwDjsVTmitG4egl5rJvGJupwlZyvs6dgtCP+Rz8=;
        b=R3Z/3C9tQas/Hpl6TMp7kr6ClI8LEDFywoIhKMAHwhF3jsgpFM3jdCzzDN1YhKG0zh
         21kaAoQP3OJPT2fjvmo8d1S3FvvYg/5CcoGktYyC0wv1M0OPnzeR3I8EEXZF++U3L7pC
         bulcpQ62kiZ1/3LDHEB34MhbtU8Er34Q286M1YOA0Xfx8vOmQiQ4V0UFAJ0HeSH6z1mE
         Dum7N5qOba9Ekpw/s5jmV1NgEH1ywriymIfHOsHUcOfNNAVr0KBwhWzidu1qDAiYEn9m
         hAsA3uDTRoT8118yYeUYqZD3L4cgEqi7E4BA6dneTZqD8UNpdy7k6FLrRG3QRdJP4Oqy
         VYRw==
X-Forwarded-Encrypted: i=1; AJvYcCV9WcoRarSF8ba2q83bib8XRa/M8FOVa1hrNmSe6hmvfx5p+6dvr7BV4BbCK+cQfUmqZFW6ckEGwA==@kvack.org
X-Gm-Message-State: AOJu0Yy4e3ik9ElUF7f8jiAXsZa0x9NYxeDhUa2PL+usLhLdkbk0TwvZ
	QA7T6JimrN0ZfwRWRgxNjlIYHDIeKdtF6MHGLZenpxQwA+f1s1drXAqw
X-Gm-Gg: ASbGnct+1kfEeYtndFnRaTA5q55ozxtT3IO4JIiq1FAsA2Pz+4rffzaje36oAmbos5N
	WK3Vc3rO2RaQTxSdLHTUKTBe71X5nfMe/VpIECMjBH6/RRalfQWF81TPo535I0XmeioG5o4vJAG
	Xm1tgHlagZRiGnxiRlL7mtuZZVpNsFPavee9WqAm97ChJqZM8v3ixgLYthz/kTwFXl6NG3avfeg
	lcHSFxSal74bzTOVescMa/XwZDmDbyZ/wNGOFgqvOsqg0jfVoksZoyTRaJgSPgspD2TLqF1l6he
	z4ct6nl+m53ogm2p5vh9e557YZI7J45v8nS2o2vTemRQOI+bckt8vxvpV5uBR8b9A1Qph6A/A+q
	cIW4NWZ1d3pdsgQ8/dqXK61aNlzcs+mGP7THzKvxyTGuRi7Xwx0b0sFO+l8hEhChpbV2wJsqRW4
	8=
X-Google-Smtp-Source: AGHT+IF0f61mr7i9UbhN+swOmPYiYgbOjyDTF5MYXElz2G+ZdhxTXXCpM4fMd0JZVLu8lnyif4ht3w==
X-Received: by 2002:a17:903:228b:b0:246:a16c:5699 with SMTP id d9443c01a7336-24944b3d697mr3667125ad.61.1756509232549;
        Fri, 29 Aug 2025 16:13:52 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-327976b5074sm3401820a91.4.2025.08.29.16.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 16:13:52 -0700 (PDT)
Date: Fri, 29 Aug 2025 16:13:48 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com,
	yuanchu@google.com, willy@infradead.org, hughd@google.com,
	mhocko@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com
Subject: Re: [PATCH 07/12] parisc/sys_parisc.c: add `const` to
 mmap_upper_limit() parameter
Message-ID: <aLI0LHtS0i5GMnOe@fedora>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
 <20250829183159.2223948-8-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829183159.2223948-8-max.kellermann@ionos.com>
X-Stat-Signature: btkh57p9gwudn5n5hhcsbw5bdwzijqur
X-Rspam-User: 
X-Rspamd-Queue-Id: A4CBB40008
X-Rspamd-Server: rspam01
X-HE-Tag: 1756509233-438506
X-HE-Meta: U2FsdGVkX19OOTpmc2LoSBAJZrrjnqcGA6qKBlFU+l3gt1wVjB0hX9QQugsO/zNIKFdenDPL7osrsndZwLGKmZe1bsVTj2QzW0u0Vf/nVvjC9KxjN4V+WpVEdfPOQUNvEuRDFmKOyQXAT4x8/DCAOUCVaCi03B2TZoXxuoYXcbDlP2EvFoBEgK78jyzRUmURFrLo21UXs/veXliYcZefmA7H6Xx6geiEQG7kgYvKJSyOmLQudTIV4SO4c0oKSxTGuEbt+Tlb3i02U3uZSKdNu4fWKhK2pHwbNTFS7oPJvCLUvvBP+Pvm/mlOxtlANUGoq7ACitzhiuNqTSm49+vAohC+Xdgdo2dqxrvHf2dbAmhnM6vkLN9rID46RnPsi27lJEZK1hvP0PAZFs42A6BrVnFsmYSt/WMKhsYCEfzxERwvIKSGD0xoS1s5sAuhaArkZn2/Azgs1a4lZ2D5fpEwRRcxqAGQS/JyRDtJbL3Au3LeRqQ/rvxvFzr1rUdePOJ1XrDQpNN+KXljqc7JzpXahFSN8ZCLfWfk/WUyyGs9DUpDpVr0sldIJ8q8sW6O13Fq9xPROhGijQD1imEzEBgZ3FqDfFXbYYXPH/eioM/8D63XOGG3DQK1VjWytzFm28KD9KBLcTfe/vL6OTQalXnHeVDgPS+ErlZbaAkpssVwSq6koqzPSyqXFZXnQ0Togm6U6wKS7+/ycSCnfNsqkQKaiawLC4m4xxo/3yeVL2Lhs7OF0IcCyLTbP7R8xN6OCPUyO0gjzu+V6MY3rlrbr0HhuyM5VeWOhkB9wuDaUz/OSSCoWSFpPQ5Dc/oPs0oRu+fAQE0HESSMz5uyfCNbSdbIyJ85iztwzSa0qFzDL3L8BdqlyduTFyM1TlFu7Fyz7RQydxlQn2MBe0daXiXgcjzwTy09YJV3/lbyxIt3d5fsUDPN/Och++Qf6I9QoTxI3QKe1NDyYo8OEu3WkKks3vD
 nAKtsLtK
 VBkP4Zs3UrDM3ZGba4UO5FLIKshIFtmdx5PScGVJFGg9s8iV/0p+XVp1aTKZmblSpgMYZSzPxwIoSe7KX4Io0IWnBn3++Gbb7H7JgYVZ69GkZZVI9EXT4UqIjHLM5DvSGgtnAB7Xv78Gl3tvONB4m47EAOuh6RPzlFiEKrlleWXNhLL+wKjPHGYu4IOg+Fla3TdvFQkVbBnrGhllvRNG0UrzKf7nmB811+PvTUkTQBrpwtL4fGGsN9MS8hcAkJde36YXAaCz8hqaH1fxl0VxAnEEzSGfP314ktHbW9ysx6MHYBrFl+Lzf4DTt7aTOCjexOJgiXI2SrGac6zuxBPu9sbVhDrv7ji/VkTpOFNqS+gJPV5kOP+l27HwGY8zVeJZFRJ8YIgTkEJckpWPK1XpGF7fwtUfkf6YuZdmTy/mey/5De+bXUtIe6yMnFE1ME7NuT3ERbwON8uTP05MI8USi+Ncrztlebx8d3GmjbHEbrhq/dzEAssJ7bggJgE8zYKehXZIhWgtEf9RxEbz0AciyJ15elC6pD/8gpoZsErTVJ0YCg91ADDBQuubP3oNMrkJ4xIw6PgaRMAhxoMImdUw3wDI1Wg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 08:31:54PM +0200, Max Kellermann wrote:
> For improved const-correctness.  This piece is necessary to make the
> `rlim_stack` parameter to mmap_base() const.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

