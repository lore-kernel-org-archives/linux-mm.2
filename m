Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA30AC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A45816B00EB; Mon, 29 Jun 2026 09:34:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A8596B00ED; Mon, 29 Jun 2026 09:34:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 871916B00EF; Mon, 29 Jun 2026 09:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 589306B00EB
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:34:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE827A0100
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:34:09 +0000 (UTC)
X-FDA: 84933043818.27.0B81756
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0872EC0009
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:34:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Wi1AmJ1e;
	spf=pass (imf22.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782740048;
	b=VHOHURdqsfO+jPeXKYmkbc/9Zuyx/jZ2jlvScAaJ/ab9GRpxPs9r88YbrDE73rIbvDSRKz
	+qbN9UkMn0O4kCaIVSYQrCyGzeixAlloT9Yud5eJMEZcM7fzYt2JRyjL6EsRCsrhuNQavl
	WtFPu31GFUjSo5Cv6tVUiSrOojHchKc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782740048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWnLWnmmIYuiG4wckNud855w6MzP81jV1onPDpYtMjQ=;
	b=QRyKCMeTBoNC1mfDkHtdQbZBkU/OmE6KjjIp4C+UcmYfbBjt31CUo+fCbkUzPSt+AYfR6z
	H3rJrQ3efk/yoztjm16UmSeSGfhAzy3l39YObFEBu4ZdTvXTVLg5VEaQPjVPvH2OJzOHzI
	XZgFbuOfD7kfTgTB/55Dhi70mUGaYUo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Wi1AmJ1e;
	spf=pass (imf22.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493a613571eso12154495e9.3
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782740046; x=1783344846; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EWnLWnmmIYuiG4wckNud855w6MzP81jV1onPDpYtMjQ=;
        b=Wi1AmJ1e75U3nJDAqLXmqs2+l1uIzAFtxxR7jtcD2IIT8xs7ds8MarfL28/wgsfEMA
         NrrwjKN2ge6auUS0QPJaL4athG3H/B+ckjb63GoRsnvWLTrxgy9ubC8QwUG7ULeYibhN
         zFItkGZ3aXvMgpShz/kYAbCt/IUqhZzQkepTwvX1tnb93nct8Q1SSdGiLMfVThMYwbpD
         l0jFh86CkU3p8z5yBqe6f/lqCVWutYlmI5Z+SLYeMKhzs6rcZCUahz+5OZhl9PJ7YZ9O
         KT0sDRW3YOs+VNJegeWNME7+8mDPEO2+1ogmxLPtRBnoaosOzp5T+nOnqwzV8gGuCNEu
         xG1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782740046; x=1783344846;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EWnLWnmmIYuiG4wckNud855w6MzP81jV1onPDpYtMjQ=;
        b=IsA9Kb1upX4JsaH6V5SHNTS7oXCXELdKwUDSK2tLA23N/nBTtvnzan2ilDCo3kVm97
         pz6DWHXbNK+xbO0F9n6TrviZ+WTVbfWp6b9ibB7jJzTwjgiKb0aCA09Svhm1kQdgDd4r
         gs4dCWl95pJvApZ7Xq59ZyFvdibqKomXiaCOuLNcpcsIaFgVID03330rgMUqIEaN5M0D
         xJocvaksA7lEq11eUJ8uh6Xc8NJ/Uu0xFa3rMxvcQ6CLKgyXjU2x1sdXlw0QdCYamNsX
         3/5S8QBeemHJN4VhYY0+v2jqGUmqxgpXHEMGrkY/qTJpGZa05Nn/teO2vy5Qg+zj02QM
         HX7w==
X-Forwarded-Encrypted: i=1; AFNElJ/SdI93c26BlMAoQUtyyL1/G7tQa2BF2TqBoZT8W56ZTAsjMxSe1bRN33coaJBDDEjn6ht1H/fJ4g==@kvack.org
X-Gm-Message-State: AOJu0YxZ1jXL9RHytf7hpmgXYYwVOzv7xmQR4hH2OZ+wTw8CNHBoHole
	dGbe/CTjYyHCH4FGUsyYjBkBx57MdvxpkT3LYto/Ft77QML+sYAL+i3VrXO8RscPRMA=
X-Gm-Gg: AfdE7clMulGCIFiwnxnIcb/W3glerORyRnwkrItEMP8Pf3JquxYlEtOQPOmfA2nf+Gh
	eQHFVaxpSuCpzox+SsHIts1rOS+31HB6wJsEoZalZwT8U2W183xXbnQfiMNr27zNSA8BlIyXR4l
	kINSXdY1ZNtTPufn/+SkHAOF4T37iRWh8J+n0uMlVgQTzyqlXMwFshGpITsIaNAZPsyNk8zh0WR
	v3RlbCRuA+2ZMTHOOkooNdWDo8Qlvhizw5h3aRVIKLT0PCHcC+rGlMqpuk4aRFwwN8UZW1YmLcv
	W3Dp5lIlMbIOnsG3G9xYSwNHOfwxu5X7ksTKs/lUeTEnMzcYFlXlqt1j0WLZUvvBrgPX+uQOJBF
	Hj/kAHvQ4/hyQ+ic6AUenV/N38PjqDDGDlGqUUJQ1IyE2cMbM4T06FrdtJUPPXzkaj7vLThqRRz
	pBb+U2o6UdeGLEjJBkMA==
X-Received: by 2002:a05:600c:34c2:b0:492:53e8:3bc1 with SMTP id 5b1f17b1804b1-492668858d0mr266307595e9.17.1782740046575;
        Mon, 29 Jun 2026 06:34:06 -0700 (PDT)
Received: from localhost.localdomain ([62.77.90.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49268ffe204sm322532645e9.7.2026.06.29.06.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 06:34:05 -0700 (PDT)
Date: Mon, 29 Jun 2026 15:34:03 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	linux-mm@kvack.org, hannes@cmpxchg.org, tj@kernel.org, shakeel.butt@linux.dev, 
	roman.gushchin@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] mm/vmpressure: split v1 userspace eventfd code
 into vmpressure-v1.c
Message-ID: <akJzXU52XJ9-F2IB@localhost.localdomain>
References: <20260629130042.2649505-1-usama.arif@linux.dev>
 <20260629130042.2649505-3-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="o2pdfa6ez77chn7m"
Content-Disposition: inline
In-Reply-To: <20260629130042.2649505-3-usama.arif@linux.dev>
X-Stat-Signature: fexxjbio7stdr1p66iimgz7egpxp1ji5
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0872EC0009
X-HE-Tag: 1782740047-586245
X-HE-Meta: U2FsdGVkX19NosYC110S7k7fv3LEljpxIlq7NFvoKet219wdDR2n+wc0yCVtsC62JgwrIwhB7hejShOdCGbd+3HbVZ2lSLS/ja+hh5vNEbyYV6fzMf223FEhBGzovu6QFVD9y3g4Wa2iooZM6R8puE5EroUts9EYw/TCo1KWFYveFePjNOYTDWRguf1MB9Yev/KUQaTVUgX49iaIi4/9A7ybo3VoiP1rUQnKtjLYiIUyuSv8C71JE8hO6V0WEFUjfM6Zz5DhBfzfXngRB5UoMoXFpHsV8h8AkvfNC2G/WfqnsfM7blm6OMxpabUxmDGI8+s9x0S7ZcF00fgUYeMmbpfZ5dGwodx62Nt+pcVADLcQ2IL33pHv5vy/GaeGlrnXlQKKV2A/vrBumPBpH5VvogMBHdVCX7+OJG19O28TzaDhueKAA+9E3Q6FrgCK48ed4/45qfmBZ539UIKOUrMXPhwe7fl8OoFCPKIt209h1kJtpANrMg1EeHYDjO9w0xrvtKKBuslTIrk0BznX3kx1fS5YgnUM7OUAPX/1oYXPvttftwfv4dnPGDGwts/wY4x9etDQQQRvRbm3kQ2CvKALzOF0GhZ72juok4xPR7QcDPAbTrsM3zY87SoasDeUiPPfP0aRcHyduk2VQkcLbPOH2RUR0XMJIfcu8ylosqBhSRqZ/WV1zECruwaZOC3q/rPXSc3oJZZ0LUvjtsUF31K/xv7B9UZYStP40iAAKnfx9jhjmJknfrwDedb+yw1Q5M0iHX7jtQtVUyS5qkqeKvl+ZWUkDwRiwoRQH0M3eE3X8P3H55jf1AYvkCrDpYFGjiajqpd1thDwWdEZo5QEhWk9MXOL2TpCQZIzdWcQcPrWGBFDNY/M+zqck/qCizz2u7cK0fKb5CWHgM38HdI3w+Rk4xqSKJTa189NF1w9K4YlEu2NcNzLemsmZHaQKUANlnMgqZTfaABCyvOsj7n4ffQ
 wCxDcR5D
 v39QAiC0GpHyQhJINFlqFOgyv9xV469ZKpHRX9X6X3drt2Lvk0in8zD/IeXkcKjtbU2VAYOxRN4dc+lIxRTedFW9wK9DLNEqd88uPrMhdtFryhcCb1D51SxG8RVdXBKMDDUPDQuhJ+21WWpXosVerCURHe5TX67BICBHSVECaR7MM+oMr9TZH4NVOt4510JwgFPwc8Fc6OlZV8vvkX+3iZpPMC84NSu/zgLcc13VkFkI8ulplOLtk5YIbdb6R2/kolM3zeOpGNJ4wVCmXE1cWODMynKXRL03i7Jwo3w1CN1C9NVZRrVqy4U7yvKKmURBBJYOHC0PdYLLp67MNvhJeu1rtySVU0+P9EiVLlqccLBkh92FWIpY5sRt1HvCuHJZWMtZ8oBSZWaEKb/04VJc5wOSQDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--o2pdfa6ez77chn7m
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH v2 2/2] mm/vmpressure: split v1 userspace eventfd code
 into vmpressure-v1.c
MIME-Version: 1.0

On Mon, Jun 29, 2026 at 05:59:37AM -0700, Usama Arif <usama.arif@linux.dev> wrote:
> This split is the first step toward eventually making vmpressure
> CONFIG_MEMCG_V1 only. The v2 in-kernel socket pressure path
> (tree=false) cannot be removed today immediately: PSI is not an
> exact replacement for vmpressure, and switching networking socket-buffer
> back-off to PSI

(Here I understand PSI is a different and differntly scope metric) but
what does it mean when you write that tree=false cannot be removed but
the other patch bails out from vmpressure() (i.e. nothing is updated
anyway)?

Thanks,
Michal

--o2pdfa6ez77chn7m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCakJ0RxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AgFPgD+JZC2Ru4dZyck6LkO3pM6
3H5HDVhUScIWPmMTNxGATCUA/i2bkM9tfKRLXJkcr8IqKXvQtu1C3cOkS6gDBRPc
+0YI
=7mf0
-----END PGP SIGNATURE-----

--o2pdfa6ez77chn7m--

