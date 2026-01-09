Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF394D1680D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 11:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DB4F6B0089; Fri,  9 Jan 2026 06:00:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09C596B008A; Fri,  9 Jan 2026 06:00:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EACD26B008C; Fri,  9 Jan 2026 06:00:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D7E416B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 06:00:19 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9CD5E13B0DB
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 11:00:19 +0000 (UTC)
X-FDA: 84312131358.08.D21E386
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id C332B40010
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 11:00:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.161.44 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767956416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f/6iWbujFBrlTFnG4dRuDFLWYCP8VJP2uP91YBHVEL4=;
	b=K2yRMfYGxyhFrxtK+z+qvV4qKEDoFFhRBHAaXBz66R+Y5AG8RJcrMowiM++V6xccL2wXSY
	M0AoiWEfbOJPHpOfHe4VHyec5TSIPJogrMWm93slUzCmMF7wwXuyRtIKWcAA6lomLh8FGd
	YcVhQI+FYg5XcUm/1FaXgiTzTJ/gGEE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.161.44 as permitted sender) smtp.mailfrom=breno.debian@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767956416; a=rsa-sha256;
	cv=none;
	b=qYebzMcsx8/sm8hiu116cLKExdoJF2XRdAWvEQHe5obftzlbDTuUx0cQi0pV6TvnWu4Z/I
	LFKlbtcYUQbeHZQXrHQtI59ADQgcK/tnkJhodneb0PVVpjqTwNZeDWifY/FI9YNCjazRl7
	NJBfn/3SeVCMNb8QobgELEC+wpNwQW8=
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-65e943048afso1514685eaf.0
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 03:00:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767956416; x=1768561216;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f/6iWbujFBrlTFnG4dRuDFLWYCP8VJP2uP91YBHVEL4=;
        b=xGvnqnuiFo5IfrR8+dEe4DnCjvY4jGaVvWJP/H55q5zh9HUWz1UKZRczgLqcHPigGa
         HTu3pzrkSww98oYNzehoJ4R6FB+0xPhSHGuvBZxPkbSpKCtMj/KuQxvv+oUrV0hFFgz7
         zacA5zC/R2N/LVNef4eAC/Ptz1pm6BXazrL3M9RJb0rfhv5h948+7ANM29y6NZsNrOui
         1y7PhVRXR6OZzcsu2c0H+RZjSidjupToB/S9+E0LjLTQni3E45ODWdtcmi//I8NciOLV
         1vtMhVTiXrN0yjOa+uSr91VSKrgGqW3bC5wN1EuCP40FoelRShPYQ870aL/kQvb9LrOZ
         7gZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUu/wZTBG89GHHIbkCkPXaIbHdUWEf4UnN/ZgS9gkn00MCO8y6jBu3rl2PMeQwoxVMarzcu57Oofw==@kvack.org
X-Gm-Message-State: AOJu0Ywkf3nvT2MHRcWmfD2xaVRu2LbsEbzrp+OC3ckd+ESxfqEoFVpv
	OAy5gjL5/vp4V+OqNWzgDPu6rB1DL5AHvpAWysHxjmWVlTNehFV7CWRJ
X-Gm-Gg: AY/fxX7GyI8zjsU9a5vn7lyvez7CNw06iKTsDmZuh0nID0DuCsEVLdaxTyBABIrKDC6
	6hiYjV80AbVOYRZTelZfm7j7ZKxf+CMkxliiiB6FV2jz40hdEnsq35Cm5Jn+gM+WytS6aptpp+q
	jbhpgQiV2jcT3HJDpAGS7xEtCh8wMlzpw9pC6538AmyMv77k4e3iP5aascKqfDUVhCsfb/IG1Yk
	qiTZz6CBPqdg18xmXf1XeLRQO38WRl7/dJYFxrVgBrOcd8I56XmPM6Ay8eWWd2gxxYkbyage/8V
	w3vaTFsuq05BnbsdUWWsvhSU9cD6K+W3c/muzK8UtPJzQ40lfvqmT/6h+yoTO/AQZ2OdYdxgXXB
	JcKjteO57LsdG2Eh7i04/JhcDieWJX1MXKaFdQLJfQ02D4jOaQ2QdCRYFIYsDDI7p6+Rka/8o5F
	ne
X-Google-Smtp-Source: AGHT+IFvXLe/It5565N/35dsaUIB8FUSICn3qXesqYXq21i8YhGvS8IG1SWviYeAa1Jn5CUJ0FMtFQ==
X-Received: by 2002:a4a:d99a:0:b0:659:890b:3f9 with SMTP id 006d021491bc7-65f54ed6f33mr3313854eaf.4.1767956415667;
        Fri, 09 Jan 2026 03:00:15 -0800 (PST)
Received: from gmail.com ([2a03:2880:10ff:a::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65f48ccea34sm3950618eaf.13.2026.01.09.03.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 03:00:15 -0800 (PST)
Date: Fri, 9 Jan 2026 03:00:13 -0800
From: Breno Leitao <leitao@debian.org>
To: SeongJae Park <sj@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
	usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, riel@surriel.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 0/2] kho: history: track previous kernel version and
 kexec boot count
Message-ID: <irmvsaihncn5pj62iylpqsp4idauakyoiy2xhazh5huomnveb7@qhgrjmbkb55q>
References: <20260108-kho-v3-0-b1d6b7a89342@debian.org>
 <20260109014559.68677-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109014559.68677-1-sj@kernel.org>
X-Rspamd-Queue-Id: C332B40010
X-Stat-Signature: pqc1di9njmpj7d6odwnixp7mqkx9rgu9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1767956416-421840
X-HE-Meta: U2FsdGVkX19pPpqyzCJ5YmGaNYyXza3w+MLfgUn20SV1oW80UxNEe25OvW55D5AVpsu8c4NJCxKikFacOndyIVc/5tAeCf0KaN0WbzYBMybx7D6bGI91uWW2bbVk8kj197P6kudLPd9y0y82TqlYemcZp+ZmmUqd4DU9dcxHqkONT5xOeFcKlnMiP9raJCJ8+CCG2hPrcoXhgcO0pNsZskCmntCKnjyY1deKv3p4tDuKBzlZNevFu6gm7TQPAR1UCMogqGNH28S1Sdv5QBD0Pr7mTTm1Agm43bDDSytqSGs5e7E5z14IcMAaIRWPmgHY8CMr+/3VABBEZxRlX31GTyGiN+Dhy01B6IRHu+Lz/Tx3Wsx5KvvMfoNM2Ul7HpBzwMeeCxby8BdoGINjvVLDpoT/7LMXtmNyKPuO/3vKdAdtodZO+qcG7mWCNg/Nh66HJP6I/EwlpBUoMqIMQzinR56+t7PFFLePpizz1s1jemAzKUCGLBGhrt5nWX597/docjWLddQxmQXQI4iNz0vGHEzVsV9NQepG7K5KHJQ2JFdUvhgugErKc4MkpD/mhoJ59DEMR7Se6N2h5FsZC4Wa3ajyY1MFI+WczEA59Qu5fpLGBpogLR43cgpGz2CvQxA7lREOVHSyvEkVtcqHJHjN5QlbC1GwUX91TNsQpgYheA0o8uApfBZ0ETTUdbZQHD97H5/QE9uer2eCJVukMneAZWW9UiHRRcUYJqbCjqvXB/Sl6T2TjKkbqQp/DUPPuA3jcUFFSuskVk9p7LI0CfuL5jNTK2lq1QGzsb14vZB+thGsAwwszfm9fOEE51VsWvqlK9fCSnfLxk9JWJBSCxWw700IyyMhp1D0fn8Eej+nOOOJaqoRVDtuZvMl7U+PAqe479Pc89oN82cMcIkD06Dh2SqdOpCyVcYzF2rEnJOKw2OVX3pRvG1XboGMabsUmByC+7PpyYXCHLTfUhAiD2n
 8g1IQwUk
 waVT7ikPn+cUuawW3w1pjptuvhDkDJa6fm3pqtHaJ23AB8ERFyA/g7RaxpNnAa9AUzGYu5yuQnu3mpwIOg4BpFpWfB07hIbbC2FDAdUCZxC2QgUJW8HzH507KJtD8NqPm6yhhJnR439kbwA1iX05hGsQt1B8tlJqwTMeaqkCVHmLCUEUX1yegc732YPGQ94y9MmaKhYdakw5tkhPtFxNdjSWJshRP9OCMGmEcABezqvinGsCY/6QlbaVmoTK1PRvF7zWmVp77CeEsn1aV3rWVJtC/BhNtrlsgiKuhVW07ivuockaZL2pe4BiV/mkC8+fUChInAbEOvS1B6XaY5V0EhZq7LFZO5tD1RlZXi7H7ER8fJa3JqA/jxfc8JkfAASEXPO+TQtBCIQSMOyC2Mm9yGv/L/nNCqaflezFsbGVJbViYPZI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello SJ,

On Thu, Jan 08, 2026 at 05:45:58PM -0800, SeongJae Park wrote:
> On Thu, 08 Jan 2026 08:40:57 -0800 Breno Leitao <leitao@debian.org> wrote:
> 
> > Use Kexec Handover (KHO) to pass the previous kernel's version string
> > and the number of kexec reboots since the last cold boot to the next
> > kernel, and print it at boot time.
> > 
> > Example
> > =======
> > 	[    0.000000] Linux version 6.19.0-rc3-upstream-00047-ge5d992347849
> > 	...
> >         [    0.000000] KHO: exec from: 6.19.0-rc4-next-20260107upstream-00004-g3071b0dc4498 (count 1)
> 
> Nit.  The above snippet uses tabs for first two lines, while the third line
> uses spaces.  I don't really mind this of course, please feel free to ignore.
> I just wanted to prove I did read your cover letter ;)

Thanks for reading it very carefully.

[...]
> Sounds this feature will be useful!  Thank you for detailed cover letter.
> 
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> The patches also look good to me.  For the series,
> 
> Acked-by: SeongJae Park <sj@kernel.org>
> 
> > ---
> > Changes from v1 to RFC
> 
> Nit.  You mean "from RFC (v1) to v2"?  Again, I don't really mind this trivial
> thing, so please feel free to ignore.

Ack, my fault here. I am using b4, and I need to learn how to deal with 
RFC -> V1 ambiguity better.

If there is a need to update this patchset, I will get them fixed in the
next version.

Thanks for the review,
--breno

