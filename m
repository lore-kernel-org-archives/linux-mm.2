Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53D7DC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 13:44:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DF396B0099; Mon, 24 Aug 2026 09:44:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 368A46B009B; Mon, 24 Aug 2026 09:44:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 257A06B009D; Mon, 24 Aug 2026 09:44:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 007B86B0099
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:44:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C972160148
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:44:10 +0000 (UTC)
X-FDA: 85136281860.17.DDBEA3B
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id CE3B180003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:44:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=o7BfykHz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of praan@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787579048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NxE7O9ZFmLE9ZVAOicUw4dBWt6/MseNUe3p/fLErz18=;
	b=5DPa7kuBMfT/eM2mA9vNBE0bon2qGSyjxAGztc6BS4ccoc7Lf68Fmm2+9zucNMH1SnU8uT
	Emtxb4JSl9LfWvLdSJlBjqG79lEqqWtcd1J/LM166oFB+XsKxsXp8bzhAjsqyKZG13g+pi
	h3KLUCNhAursWJZWzYipBoDN6/oc4E8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=o7BfykHz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of praan@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787579048;
	b=ZLtmYF8slRJMuy2udiFAw9a9gkHBLqIPZ35AxSKjgiOTTmYFCinXG5xmBJ8c3kB72Dux5G
	iBvWN2CRCETDoeo16IjF6tQNsTNmypl/dZUpYFXjnv3/dz6fua0fhCkiqvGV9OK4znbPAq
	R1MchVRs35TvEaIVdIwySCBu7moWQoY=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ccdf36f63dso158885ad.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787579048; x=1788183848; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NxE7O9ZFmLE9ZVAOicUw4dBWt6/MseNUe3p/fLErz18=;
        b=o7BfykHzroZcqHIhqc/aBgWCn7SwYJuIi0JtlcTF0zfTt1CSevy5mve971DwBHNQmI
         R5F77v8ZMkO1nNtPHmlRVs65W3nFBo+5LtLuujnYWdwEHX5UOGfruhVHfhe0vVuhjhIX
         d+hKot8I/c9K2ciXbKIx13REwPLIYLOsgxj3QlzYaVh72X8InzV78cKfWjiiaEtcdHJX
         78NdIXIVkh+cV5wv2yiz/IfPFUxBYbw1S+5ESJlI+vq0J1llarsHxbDlxmK80GshM4zj
         ACZmCJ8t7MqLb6Xp6FYrOmTfRnKLOPG/yZWa2lTbR6Oi5L/IKNeljb4V5rBHjxAsowXE
         CoEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787579048; x=1788183848;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NxE7O9ZFmLE9ZVAOicUw4dBWt6/MseNUe3p/fLErz18=;
        b=fT88ruZlSAvDJ47TvTpQb3zxFKSyruyFcRPj9/8p9eIVcUWFFWPzt2KFnQSNDsf6zl
         ozCSTG5Fy6IWxpyNDn1dPnogGNbSbHDotdVtGWNYfMrRWUHo74P4ZPHN0F4AyvzsCEmZ
         O8VMqo4M54S4q1nM8m2MIopWtikGez06d0t2KAj8hN7lEDuWnXs8DV8QI4m71MXkmFX7
         a9SKOC5+5QZTVKVqKl1mr2dYpRPHgGB1Egxg+CJK34Ckgo0/N0izM2asu9wzdUSWma+2
         MQz2fltulEh979lmnIH/pbEKRhKdscjEww7nhsCF+wAE15K86PyK8Xwm86YoCUcyI9NA
         IA7A==
X-Forwarded-Encrypted: i=1; AHgh+RoRNNBpA+hX560T2bSZbyfiqdWiGeWaiYVxSPfBTX0lnWvZjyY1ktwwlQ7K+KGVoFMYnGlanMEhhg==@kvack.org
X-Gm-Message-State: AFuF++nyC+P6RI2R45pPrKnANMKmFaBRpc1iCpWB7Z46ohHwd2C/KtCN
	xhnxrJ+L4jtxZ2KGZivE4vBMyE1MCOBpXpGCF2rB+mMKKocqIIvwfUkYiXVl1pbxXg==
X-Gm-Gg: AR+sD13rNZID2awZ7e7CDOcc4GsJxIZRQ2S3XUks/fChME+0Qi5UeWKmBPxCtloSUqP
	nbSeHv7nnGMQ/3yH7eE7N9qHeNKwn8DTPw8BaRokGrkQ0tgvoUfcADg5Ozyo8lksYSVN666TI8d
	gMvH+/w66awXwYz6OmgeVv3ixcAMrvsVn//Vn9AbmUaBLEB9ggSu0DAqgLN46ExqYvynjw/e7Lo
	rZ+c3IwCIghLBatZf74BCYSqz8Q2GIRUDXXguJ9MoMUrzqHFCYkJYY8/BeMC/0isfvJVN0EKsrZ
	9tB0L0JGLotqsHGehm5JICXuCbY/JSgjr4kXCSVef+FHkeemU00mhqKD9WujJckPkNk3o9Codgf
	s9i9vcEo4csMK0uSeRe7M04YxCgSKE5fDs4oPTt90SqeC9e56PORJRsqLNNF3n8ULWBucMcUtm4
	XH+91BH/Zbc8y37kOp7JofoOnuJ1wNcHiiPGzV2oEuBX9hHKxRPtMzkRWvF4Y88+HaxmT1Qb6m/
	My4djDFz8Y2BsfoZZDz8dw5Fg==
X-Received: by 2002:a17:902:d592:b0:2ca:bf8e:360b with SMTP id d9443c01a7336-2d673b9e9f2mr9511405ad.9.1787579047148;
        Mon, 24 Aug 2026 06:44:07 -0700 (PDT)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d676792e1fsm18085525ad.28.2026.08.24.06.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 06:44:06 -0700 (PDT)
Date: Mon, 24 Aug 2026 13:43:57 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v8 09/12] PCI: liveupdate: Adopt ARI Forwarding Enable on
 preserved bridges
Message-ID: <aoxKnSgUp0m625EX@google.com>
References: <20260728221007.2098560-1-dmatlack@google.com>
 <20260728221007.2098560-10-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728221007.2098560-10-dmatlack@google.com>
X-Stat-Signature: 8ndwsje7s997pxrxqj91cmr5tuo5kft4
X-Rspamd-Queue-Id: CE3B180003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787579048-243444
X-HE-Meta: U2FsdGVkX1/VR7U1pY9A0w3su/EuRGXZOLeKXJTLlYBjJXX9o633KvwDDS1JDDX8H1Xx2fn8RvcRDXiygUP00H6Hw93VJDzu08uUAWcWVKoxNGMfuQSsxUwXmeC8wXr7Zizl8ja0nFWSWvE5P1pwfhIOu6iDkgMYS5KoX6WVQBgKqMsGYDHEOnBLSiSOu9ZI6c9dKGBEyKDT7FOILwIlGaULyJZjoDhAPd9bZ0iZdJqn5uev1o/1VP8+t1fTDKXGB+z86XQAgwjdon+k/L6Xx3HqtoLq0sHFZsLYfZ63iPVb3F1OtOyTeoBprEpXdyUGcDTBQ1+uKE2Mpov1fmqobbHgFAlvTsIK5gQAYjc5dR4QphlYGfAgQJ8ad+5v12I5HPyzuf/nhXr4AnBd3cgqmkjEj6UqpKZPzlHpibKQoToP7ccuJ7Uy3+vyGNE/vwhROmfVYXdHXTRY1DZwV85N+FOobuvNABpiTKiJKp8DUYqVYEvRWnmzSH4mcdBKrhzTNscsD104pYRYKeuhJzkxGXqXD0q/EudQaUZqMuwM76mjpkRhyu34oW1tNempk1VROZVWHJkvD7sax8RjBfE3aW32Bz1fhLjngUcryykRShUnJaGpJ7c2qqPGd1t8U5vzalsuAgM169k4lUj+yHp8hqYoW/PBCbfxRukgAJmbGf9KOlluJ6timwiQW0g7KFz6ZNx6sJzea9s0MxsujUzLT1KCU8yMWP1DX2D4qD4WbSL7eyYYVs5eG+JtJF6WpJwdaDCEW9m0O1D11nraiGimrEDCUbJjp79WllEZxVPtj/FHHuah147tOU445gIjyHRBCzse79c6NdUnU6/CpFEV4CP3+Fzr+iow+te09oaYSwB9VrV3qF+9y0PPCdrLK1OBFlEqAbA1kyn0BqvWPwOvym3N9QV8u1jizcMaB0ie12HF2m+9nlv7rvDpwqK7ZewWnfGx+OedPgtRd8lbwT/
 FoRuplmr
 BZDV7S+utVnQYmJOAudUNWbZyHLdxryqFTvHnONRN4BXqtLbFSdbTcRQEIwHNVwg4WScYD1Tm+G8qyLjjyIStXYPdwJQXVBHiCpNE57EtJ6slsZN92LkD2abP/7YlCh8EEnothhnEvd2NfG34r/4Bh1Gu8jm4hfwun4rZ59B4tXryItPSpclMYYlnLvyrBLNIy+eej3Pd4y0aX/3oqv3lpdD1Zj6ndie+FX8blqdqg+xreoUKoANbDLS3K7uswFGbOti/utNuJynfF2ySRH2Xt+SZ7PPNpV9upsDzIptw3zdB6ic+R5yGiuDyee5xUnmYWsIj56kGGuYBw9o2CIwCvxcb6fCzYR4QdIZR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 10:10:03PM +0000, David Matlack wrote:
> Adopt the ARI Forwarding Enable bit on preserved bridges and update
> pci_dev->ari_enabled accordingly during a Live Update. This ensures that
> the preserved devices on the bridge's secondary bus can be identified
> with the same expanded 8-bit function number after a Live Update.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

