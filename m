Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE68DD5B874
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 00:12:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D4C16B0088; Mon, 15 Dec 2025 19:12:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96B3A6B0089; Mon, 15 Dec 2025 19:12:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86D5E6B008A; Mon, 15 Dec 2025 19:12:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FC2B6B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 19:12:18 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 011AA1A0149
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:12:17 +0000 (UTC)
X-FDA: 84223407156.08.6F00737
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id 20F8018000F
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:12:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=I00zHyzj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=vannapurve@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765843936; a=rsa-sha256;
	cv=pass;
	b=ExXhG33pwMQUDNh78Q6OdjJ2yk/FpZcDt/BQJYPN+T21fr+Za63WC4L1PvhxULQdYr8j/s
	UcaiG7wGCKKUJD6JBm3hn+GL5AtIwh0Hg3m4ugn4jjJxthcGOPzRYG1EW0J/J93DUQ+Mf7
	G8Jm7AwCC4/JeV8dIJxspN90X1u+l4o=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=I00zHyzj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=vannapurve@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765843936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=27wQsfuOXjJhJo74CLfXwuW+WvRgdLz0XpQKIZiK7fE=;
	b=lxcvWxMVvzLF3WdRFIrWYjtoLIqp1kJpFwmFgYpurWyEnp47aa2pcz6ulmCK2o82zoU/uX
	nzFNRTNA9v06XvFlrY7lWaRooWEhAIFXKzb1C4EaT/PVAa1G1hGVLrzCaAWFcndP285Dek
	c9Gw5D40llpxoHgYY+fKj7/WC7zMqDE=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29e7ec26e3dso46355ad.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:12:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765843935; cv=none;
        d=google.com; s=arc-20240605;
        b=T7i26uMM3s+F9i8n6v8Yc55pEOMpCjThG+Z2LAw2A2WOYrydbhp6mprKxfZwfKXsJh
         x4j1JXidDCDHHqICcJcvq8PD7FIYqv61Av06Z3ZPuVXSwzwhJg0ea8Kqx0X4HSV2TExJ
         SzmJLHk0FQkGh3yBeRriJtrE+fX98AMQe1GyZt1qBNqNwADRmTWCzgsuwgwkmv4xuetv
         W8oy4QML4IZsX/4+CbnlvvYfiQQAFo0qhkGTlOpOPcA5/zlEvBOT0ZMmsoyQqNFrE/Bz
         NEWwB8znj4y+9XG3uJE0f7Qm8UL0+OLGM0hsOk6jtSRalZ6CynPuKbFhv1LYJkLQEOyY
         s+/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=27wQsfuOXjJhJo74CLfXwuW+WvRgdLz0XpQKIZiK7fE=;
        fh=wzHPo+V/Q3XuOB8neYQZIumTRDn7B+0niSDwvixU0Xg=;
        b=cb5LFRVd0Yp1AFe8RwBAQuCGfxgcAXUgkQK2KVXvYlxYV9lxASxzNTtiUmp9M8j1DB
         kUNqaDDsaloQULGW8UkaoQn7gFtJBVlqsJkdOH4xqJHjx4STOv9OMEOCFrnJoHbrmQka
         isC/KD3ymLrCJgBFWBCfSxO6MABt2lVpD0KmPHGc6eOImpqQrfskY4hZuEfD3ee9bRQu
         1Ck+vP8VCkYyjbLuYFK9OTh0Gfms8jhDAU3sHz46mS8LOASB8326ejHOLxzm1f5/pt6J
         a83QrYjLEskFX+tOrpYd2mYn1v8JvtveTXH9OPhc+fOhCgB+GpNamZhsMrv+GmIGSFzf
         jsTw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765843935; x=1766448735; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=27wQsfuOXjJhJo74CLfXwuW+WvRgdLz0XpQKIZiK7fE=;
        b=I00zHyzjdDE+f7E1sUc441DjSRHW23Ww3/NXpEyo8KRUWN/4dWTBNUT3TgAFO2chYz
         ig8i4k78b0WOol5bPYzieQjqk3LBXLo/sI4J1Mjon6qqA0st/7PxC+TWSxgT3xDSMimo
         lcMGv0hpqNSflSZ+/XCkZgAf2z9TLvH6WBoIzIqm6Yp26WtF+d4HHRFu/cr1Q6gWKc85
         pROwCkbASOiUSA93KcIU/TFsJeHH1PDy17+Zp+xjXW/7bPOhos/xQDni4by4QtplZ6YZ
         ujWRhAPwfFs2fEUMMgH2MIeTUf5+8hJQJaCPEi3TbvqA+Vk/kuFVsxo4vUJ2av1qyHMZ
         CU4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765843935; x=1766448735;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=27wQsfuOXjJhJo74CLfXwuW+WvRgdLz0XpQKIZiK7fE=;
        b=FDk8BHiLXYE6JJZkCvahzy1HoeuvEoMN+MgmcGgpZd254PuE/SGx3HGKljjnlUL1nU
         TbopyCpX80SrHdVtBnvs1ZFoht3lsBRfZGfNFqEgKTbmpEfCkEK3wybo97udtB1qcYoH
         zeTOaRjw63iahMDCzWO8q1cMijfiw84yEhH+E995f80WpTVfy9jrd+CMIcMeiKfaNKJu
         73/JvYQmdqbqPxTa5KbgqYntZxdj6SDL4K20dvwhxEDeT+G6i4tDDWREbZphoX6cSNCP
         LU1+Ec7n7GXA7EmtlG8Ew1S2gJRUOb6wxkEXrZ5vw5h5X9ZaRpnxPoqDhzIPfz1mjT98
         Pp2A==
X-Forwarded-Encrypted: i=1; AJvYcCWvJlM97YT3/3uiErxEqrYKBGoWZ3OYZu7faMRL3FrX6HxEsT7UOASS4xOGrItkBaQd1NAVvy+VSw==@kvack.org
X-Gm-Message-State: AOJu0YxPXWXFTssB+Rh8Bzw/TCasQYdsp4VNUPowFxVFqi7BdWlE1Irg
	FxAKTygHq5pDDSFr4pKCCXwBDQH6cIkynk7ZFD7+Kjt8Dw2eBkat4+v1G64HqBPmM1QBkM7e4LI
	efIxa0sVraPFBMCgRNaQ8wUmHHHhd27bWx8zmvCmT
X-Gm-Gg: AY/fxX5jBJFTWbxVPVELvrdhBTg9orGkp7RuljvWqcZrdYE5CHBIIvI0EhahNmhPhe3
	+OZJn1I/SrjmvXHWJjBYoOesK65iotE42/epPC9Yatb9S0d31xpwTF28wFZGFvMriwpH667j+5V
	GIITFOz7hxhE5PynVA45hWBhwC5zI/qyt6DVxH8y19KLbSga8ElHwUFyuHCeurVeCTo4LJzGpna
	4tFqXhNPeTwrd5/IK7fkuuKqwiowpjmpNbG9gi4VJ3qKRrS4aaveGLJsk5ALTRJ/WBMdz87wKsq
	sL0dRX1lPZAfFSCkVb0jrRsgZAPj
X-Google-Smtp-Source: AGHT+IFYx2fqkqoq7nwgp8s1TBunZASqxOa+paDvYopFfRkFHpqotvWma1Omazh+JGGMYTXawA8rx1OS57mP9gGziPM=
X-Received: by 2002:a05:7022:68a1:b0:120:5719:6249 with SMTP id
 a92af1059eb24-1205719637fmr3220c88.16.1765843934179; Mon, 15 Dec 2025
 16:12:14 -0800 (PST)
MIME-Version: 1.0
References: <20251215153411.3613928-1-michael.roth@amd.com> <20251215153411.3613928-2-michael.roth@amd.com>
In-Reply-To: <20251215153411.3613928-2-michael.roth@amd.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 15 Dec 2025 16:12:00 -0800
X-Gm-Features: AQt7F2ra9396Gr4eNuUU-K7XtTwtvJ-rm6VSQCRwWNTFPqW7whDLIsPPpRjnSlU
Message-ID: <CAGtprH95s5wL1=rSSpG7Cmj5HhJOftwJY7CP27WE-qmq7hr+XA@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] KVM: guest_memfd: Remove partial hugepage handling
 from kvm_gmem_populate()
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	seanjc@google.com, vbabka@suse.cz, ashish.kalra@amd.com, 
	liam.merwick@oracle.com, david@redhat.com, ackerleytng@google.com, 
	aik@amd.com, ira.weiny@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 20F8018000F
X-Stat-Signature: nbtc8m9a865em6jpzd1nixsxbbnw1rhe
X-Rspam-User: 
X-HE-Tag: 1765843935-45377
X-HE-Meta: U2FsdGVkX18C1QBMCUtUN8RH7ZT/9SznOf1xeVkTdQw5RNujWTp/66F1ZVt8vpYvXwYPEcnDRXElm9MY1qMFw2oo2Yg+nD2WsJJLf70BeqwaoUSJfMQks+XHD99VYMM+yhWTmehDR1Kg42VIoU3I9htY4F5NT67jdYTRpXH/4Y6J0j1w/xmdcd5cmQxdzRhws4LJG4rxbl0zdfah4domCVbfXkoAiO9wfKU69SgVgjXwoqVzMDGfwsBegyU9e6zm1nhgJqIwt0cRKeGAYNmYRCKAQhrttWfMC2aEOpb4VvmSWvTFv94as1npDMrd6POv8Feh2fqrRBLEGmNvYzopu//WwJYoBko6wufQOoIWDxBTuY3eSfybU3fvfdmke0OSnB3BBmL2uZon4pU0I2Emr8ZPh9Zrw6xhVrKVgDEfCPKncrgwlvv5pgULDyIeEELDV+YsrzWtOs4vOPVGSDe+lW+Rf52XK3sbii98KMZGOmN9Zp8wYvGjmTtCGp4XKvO3teMBQ+NfVhD0RBKb5+utYt2vcVw2iglLFK3TN7xlE45FnFa1MH2CJnjDDUjIJVkl/Tpe2N7yTnXikqPSQrkDpdmlNg4jJS8XT4kWSBBOqm1i9liVxCRRi+r6H0t0WDJwvFFMRpQ6cdsyQaPNzF0an1E+ARLXpO8ZN/Z6LAUNbC+P7D6Y1ZFRFhLDpDI+DaRA3m8SvHZ8SSuBL/EkjbbSzN4vLH+SA3+p3KDi4bb75kRESKMXeRCqB4jJm8IQoxxKaEF5Fr6H1H3qZLvZQkmrRt/9N8DzP0oNIvGqFv84qTVBBCPT2w8CWFiHwFvpXv9TY5ztvZ65RICHAPdQdZUd50G/AF4pr+qBnV/yUB+gYMC1N2ECHMxkpzxkbq2hYs79zYQ2iGkCRkGajfYa9EqyZaILX7wqnJgLW76K6zfPR+1L7CLeDCwhMuIHjsGANuHTPQSPZ/eVC7zCUSNHHAU
 27iAlbnw
 R2mk3oXTKWCbiSlUoFJCEpi9lYEHHJUgBguBv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 7:35=E2=80=AFAM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> kvm_gmem_populate(), and the associated post-populate callbacks, have
> some limited support for dealing with guests backed by hugepages by
> passing the order information along to each post-populate callback and
> iterating through the pages passed to kvm_gmem_populate() in
> hugepage-chunks.
>
> However, guest_memfd doesn't yet support hugepages, and in most cases
> additional changes in the kvm_gmem_populate() path would also be needed
> to actually allow for this functionality.
>
> This makes the existing code unecessarily complex, and makes changes
> difficult to work through upstream due to theoretical impacts on
> hugepage support that can't be considered properly without an actual
> hugepage implementation to reference. So for now, remove what's there
> so changes for things like in-place conversion can be
> implemented/reviewed more efficiently.
>
> Suggested-by: Vishal Annapurve <vannapurve@google.com>
> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Tested-By: Vishal Annapurve <vannapurve@google.com>

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index fdaea3422c30..9dafa44838fe 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -151,6 +151,15 @@ static struct folio *kvm_gmem_get_folio(struct inode=
 *inode, pgoff_t index)
>                                          mapping_gfp_mask(inode->i_mappin=
g), policy);
>         mpol_cond_put(policy);
>
> +       /*
> +        * External interfaces like kvm_gmem_get_pfn() support dealing
> +        * with hugepages to a degree, but internally, guest_memfd curren=
tly
> +        * assumes that all folios are order-0 and handling would need
> +        * to be updated for anything otherwise (e.g. page-clearing
> +        * operations).
> +        */
> +       WARN_ON_ONCE(folio_order(folio));

I am not sure if this WARN_ON adds any value. i.e. The current code
can't hit it. This note concerns future efforts to add hugepage
support and could be omitted altogether from the current
implementation.

> +
>         return folio;
>  }
>

