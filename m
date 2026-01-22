Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21B61D6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:15:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EDD46B027E; Thu, 22 Jan 2026 13:15:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69B9E6B02B1; Thu, 22 Jan 2026 13:15:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59DD36B02E8; Thu, 22 Jan 2026 13:15:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45DC36B027E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:15:30 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB5F8C1D41
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:15:29 +0000 (UTC)
X-FDA: 84360402378.13.04D3B8C
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id ECA2220013
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:15:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=F0LC5JXE;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769105728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=azOk63yV7A5TybPiH/Lg4nzY0I8Pa0E2B+WL4X7922E=;
	b=HiPs0ZAXNlYwLUeLpihzoCwkp5kzwmsTrqV3AP4QcFufWFegTEQbSevAU+3oDWakX0ArQF
	2R5k9qae+VHsWlthBMimVF4uYdj6f7Awr6kpNlVREX79Qhuxsnw9qXKUHUNObPW5eQ6UuX
	llfwMIFf4wrlMHvTLcgeWhIBmoktHDc=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=F0LC5JXE;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769105728; a=rsa-sha256;
	cv=pass;
	b=3XYmLwrUw8LPTs3PMhtjJvI7zGpuDQU/jrRUqWrRR6VzbrReQuRvmkBbGs19FDo8t2CdTr
	ffg1PAr4bvT7Py+QaXyXyaS9kgHrHxLgR+KP7kNCycSyhR9StLti2BZI4NJxIv/w45kosO
	wUUOVqCEnzroaaiawBIEM33+raxHD5w=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64b9dfc146fso2199935a12.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:15:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769105726; cv=none;
        d=google.com; s=arc-20240605;
        b=R1XUxaKRQgRRdJ25HqgrxajK6gXTIWGyah2gd5El1XHWumf2to6qwm+4C2c4XwwaUa
         O9145vSHBzPj07peNzp1XC60g3SLrV2qTPDw2fJ3Y/v77RLI30YeY10uYdmDDqY3ci8l
         QXt/U2RBrQAB/1rhgpisHFyGA4nswvslvo8L6HTSCA7u/AKQW9J/cFyECDKEiW0B1qKt
         dtDfP3593z+3cevanoUk6DcokIW3kId54xVsOoh8AVKulGqtGMN06GlvHHndoJl+H5Fk
         dZ6Kic7us4e43Suk+SEtbZdhSQ3dvrZdLDOJKiOE9POEo++6ty6iZxavBDQVeSUXDsaj
         uRhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=azOk63yV7A5TybPiH/Lg4nzY0I8Pa0E2B+WL4X7922E=;
        fh=UhzsjzIY6P4MrJyjnUJveDkLDruppsuxZrUn3qcOxpY=;
        b=bPsXFpIvrJXiv40DOFvBPkgzHhiYWk71jp9fsdPf8mZZzZucuixfR6iHNWIbTadVPf
         9OzGyV3q62s+88nmmopo06+LnF6BnUV3XxQJfp/BN2jIoDvgttdir/jWp0Y8unBOb8nj
         LkBdoSKqjRYWiJSjQvZW1eGm1EpRvDftOno+WmDUU/cdLBm3oGJISNNNCKCeoVoIcRLc
         bbR9dfLxn+0lLi7Nfi2dm/LUyrkWkNf5jstRZs81vKxh+lhYFwt7gZXmpi+9hTvLuvak
         umcRM14gqU7KMyNOWoD25AGPl19FlgQ+dD11Yh2XadWQCjPfsU0HwI2D3unIkmEnDLVp
         mpfg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1769105726; x=1769710526; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=azOk63yV7A5TybPiH/Lg4nzY0I8Pa0E2B+WL4X7922E=;
        b=F0LC5JXEi9nSXnuxTQBuPmGyCtp+hqdqJlXa5ClkeQtB2DQu9mPkunI7a5VhO/iFnZ
         tPFZsx8eAmplDyadH6PI9UJ7Mo9BmyB0i8+Ui4uPW22VPP62H8V9KDXeBqIxVachJ/R1
         6TMaVWwLokKr9102/f5DDMHUN5bxZ5n2ddirD89VaU/2OsBNqGbBGBORhp8Nyx9FhPhE
         hA4qJ5XCm1+z1ZB0LgEgckmRPyNk/7Zu7x/8dhf8A5oMSwuhBUGt63//L6vDpAxuyikY
         oVe+usJ6/QlNq3pZSJRv7JGOt7j6tGkYr9nBRor37E37aUamGiOwhkvFOBYComrZxQ6s
         GdBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769105726; x=1769710526;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=azOk63yV7A5TybPiH/Lg4nzY0I8Pa0E2B+WL4X7922E=;
        b=bdpAU0FY0feNoS5ALzx5y45RVoNwK45m2b5FM/txlZrbmEl54IF9Eh/iei19WPOrs4
         ij6N9t14y2OeZ/9u0RRvxryzRnVWEHxe2aonne7FB2HdCestcBJdaam+NGxh0zqkJD8L
         3ZlBBMrKO0+hcEwLvL1CvB/2N9eEfk3MnJZE9nOtSHoe0R0KeOpvBcwYA58MgQma+GR9
         fxJWLWP+IcY4rXiDJFk8XtOR49jEFq2Oeem4cAmTTxJCYwSyaXNO4GIDQxCDiZHlTgo/
         OiW/VqTEaqdnO0625FXkYqbFxwVEGmkTP9h6vf4hhifWf9c98HsJu3Jc8U8YmU3NhKuC
         okoQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5kVC+x3FDafE3lKgMJBd+3zfHW7nghGVDYkBiCS93kIxRDNOmL65Z1Teq+X6Tq03nVy6vE34ztA==@kvack.org
X-Gm-Message-State: AOJu0Yzkp+LuVLCqtbp6VG3I5laZBWMWUmuGooyL2voWrBUCtgiCntxN
	jpwGSHIuJfS+PerMiy45wLWUVf3RFJw78SbDw6Ri7UX8gvTIk1kil2na/zdoTqLi4PyW1r/e7iY
	N+9vQ9kYq+7TiVZXxIWJqw8GF+RN9h4baXY+uznGRAQ==
X-Gm-Gg: AZuq6aI8VSIDXPlmsfaA3NZU01ktKtsWe6PV2+gBGoVrNBPttFaV3zRH+gBsYPNvxCi
	dCksBlonw7W04bmpmiXfCMNPtM3DtfBQKjuGRUBb4rzBaMRJTnNA/nO2Azqu2nSRp2J9DYA4L92
	4doYeb32cUMI2PlOEjzG4XtW6u1FLqBMnJR1xfSeW5XC5lOcBe46pxkjdb1iphqDPyCl9LGowHv
	MLsSgM+B3ESN8q6sYSztyE9Q39hPBXjFLckZglUE41cOpvoEZGSejDnqoZCm8+mkZoxZeSfvr8q
	HPo9LchvCXlSELGC+ESNOvajMQ==
X-Received: by 2002:aa7:db50:0:b0:658:1350:1fd2 with SMTP id
 4fb4d7f45d1cf-65832eb76a5mr1835496a12.13.1769105726405; Thu, 22 Jan 2026
 10:15:26 -0800 (PST)
MIME-Version: 1.0
References: <202601211636.IRaejjdw-lkp@intel.com> <20260121123922.c0bb0ef8505c70b99998c324@linux-foundation.org>
In-Reply-To: <20260121123922.c0bb0ef8505c70b99998c324@linux-foundation.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 22 Jan 2026 13:14:49 -0500
X-Gm-Features: AZwV_QjkOt8rryPZqYSqx98LQ60wO70s9K8cucBSZwSM5UYoS1ViJ13uHLsVIOo
Message-ID: <CA+CK2bAyHHoUaT_4dTNK6AH2oyMMhs2sNhuW97hV4yRw7ie9Tg@mail.gmail.com>
Subject: Re: kernel/liveupdate/kexec_handover.c:994 kho_preserve_vmalloc()
 warn: missing error code 'err'
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, oe-kbuild@lists.linux.dev, lkp@intel.com, 
	oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Linux Memory Management List <linux-mm@kvack.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: ECA2220013
X-Rspamd-Server: rspam07
X-Stat-Signature: 8cerkcw3dnbycm84bkheukb9tq5nopyg
X-HE-Tag: 1769105727-271711
X-HE-Meta: U2FsdGVkX1/yAL0KsJ9YMNYji3KbEjKwwlTKk2epMU6MzN9QnviOyO318Iyq9YQrhZ338dZrTYa+NVG858wo1A1ZAsUwQyzFLUlwuWdsd2LmVzDoCujpsKnPU1XFMndUHVDgR/eMIZF0W4ZZz9FlYlvGwN0rHfy2LL9oT2supYCDVZwNZDQaEUJvxy3uorYndjafT7ethQYLCduyhMHlwvYh1hJyct3cUE8X/zSfbLeIcKmkIFPIU5jeoNtxT9N+91WHYrlRms3fRMc2sRD+315kxbD6LvwoXrJeIxR82Fj0pemaH+sGMKWjc1AlXAcjwIFUMU6sFnHX1u1xJyQHxLTfwWEFIlFfPBfeU6G5OWfZd1TtKDY7IeiCno+kbWMgPW+/UfhhxLAjfglQzEgfKj1ZSOxs7/hAWV69tm0lhDo/rxM3B1N/d+oB4DoISEtLzv8AKagboDOuhjqagNdrfGAGEQ0l4Xu3LihCHtMt4VY9vuQ0li3fGxPUC839bV4+Msy8lcQ91rRGpDzKSoNKByAxv2LoT18lHOeX8bLJEjZ2rcGfKTc9xWI597wDQIL5K8ftNKeNcckyta42mn5jODTIeYZ1gwhbZEpSolRhZ5vf3dNBk3KBdAu6rZgXVAS2qYJ9GeD21/iacpvy7Ku91r5HPdcfWTyTpZrNwJmAJcLH+0Y7hDBuy9ujm57aLaL+87d0lvsm+t8dIBCnVpwmmEtOTY+s3rUNvID97JVljeYyg3FS18wRQ4QxOfqWf8hEbtVhLFoAz2VEm1mSSYGBd24/Fnz5N2VrRk7yBwyXQpGC3VIgNhY/yoNI+h3fxN8qgQFPTOZY/4cD0KYbSr/YKZ63Bc4dWLm55moVKBNsEBDlKKHxsMaJJbst7r7oOq+OrXLd4DyS7brXV6ZF4cnZ7Sm4rGP8Yrzpxve1VXrZ8KBXtU5n0sAyCBCTVhZiomESufShN2qTn/PYJw5Jf1L
 BUnNeg5b
 KOEa3K8yjYevPQikBMZnTK1ovtLLDtNF7APIdXgJzsaet0++VmZp6/q10zRSnbG/IzyF6B/0s73EadCenCqfYRHWR1QbJdH/IkkBGVXp3R+Q8z5MPVbgOtAHIr4ZrkQ94jxVfNCGCw7gmrgXj5pdC/VBS74Iu7KrP/01fvodp8mnv2lV4TB0vzl3veHfRQnQ8BgBAS+C2hnaMcx+fE/qJ3Wfek+7mJnqSxjd5vAV1j5FZMZtDZfclNezf24RVxUxtZU+gKYkw5OaKkrNL433ZLhd9lM91Tbdl44ccPaJDJWThwS4Bk3mWWqEWYrgx5GzlVfKMobek2EqP33JX+4lZvJuVXYD0i+rZQV6VhjCMwherSmX3h3rXZwfrHZ5tAUKEj9QS4PU5EwT0sZSDYumszZA2S86amaTbNCOtXg9qKOlNLbE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> --- a/kernel/liveupdate/kexec_handover.c~a
> +++ a/kernel/liveupdate/kexec_handover.c
> @@ -1011,8 +1011,10 @@ int kho_preserve_vmalloc(void *ptr, stru
>                 chunk->phys[idx++] = phys;
>                 if (idx == ARRAY_SIZE(chunk->phys)) {
>                         chunk = new_vmalloc_chunk(chunk);
> -                       if (!chunk)
> +                       if (!chunk) {
> +                               err = -ENOMEM;
>                                 goto err_free;
> +                       }

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Thank you,
Pasha

