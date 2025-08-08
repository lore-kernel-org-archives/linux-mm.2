Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94BECC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 20:23:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24B166B008A; Fri,  8 Aug 2025 16:23:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 222B76B0099; Fri,  8 Aug 2025 16:23:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138A66B009B; Fri,  8 Aug 2025 16:23:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E95466B008A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 16:23:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2330F160486
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 20:23:18 +0000 (UTC)
X-FDA: 83754714876.16.D531963
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 495DE140002
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 20:23:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UbwxZVjs;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754684594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qffYeRv+DqqEfz28gtOh91dhHjRzZPBAshXCIYuUUzk=;
	b=uw7/Gqu9PDwhRgRAoeboLi/rr86G0FbVF3ynG0o5i94qo15PrLcw9p8HL66pW3+Ew5ZPyl
	v2E4bc0l/U7QOu3CpQrnFUI5A40kmhZboEX9Dj8PvFwf9Fse8jIw8d0E13bVJ3O52ZViyl
	XP2MwTcS1h504LqkRAwwWWbkuHe+lrE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UbwxZVjs;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754684594; a=rsa-sha256;
	cv=none;
	b=yH4VGausMxLIWhgPRKEtZRH83CjRm/5TOy3rVWClPFEhsS5Oagnx1GHeVxchjl34mUNefn
	er+599Ibo9GndhHSoruU6X4ThpCPB46CO6psWJm0WtVMo1QESQYswEET8A9Rd21PWzDkMo
	ihOQ05AHeAI9vlBkUq89ODHcnBQ7PaY=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4b07cb2d13bso36007881cf.1
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 13:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754684593; x=1755289393; darn=kvack.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qffYeRv+DqqEfz28gtOh91dhHjRzZPBAshXCIYuUUzk=;
        b=UbwxZVjsnPN0oKfnuNPkA0FMHCFH1epQ3prN8yhiIzJ9o8FLbxAqfTT+bJObuCUxAM
         rpNLrN5k5o2U9rIEU4K225CwHFxTkOFKUO2YPLQ3Jy2RtQqWtXwGE1SKOIoGXKWQFnqB
         fj7EfsIW6IUY/vCepc4yWBMBjZ1wNWdJqoDZ9jyK/xTZWq9Jx0eHJHWmumSronGWkeas
         XfM2pTd5MHH3unHO4f0qbYDLCvf2ufiba1VjrtmtON+3h+y5vGEerFzGVPNTJsB95LDG
         TktBvWgBbDFUDEyM1/cwiS1+zz+wh7Ovi1lh8Gt6Ns9Ha5HCQXXJqjMtBgsIkYjXqrUx
         y5Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754684593; x=1755289393;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qffYeRv+DqqEfz28gtOh91dhHjRzZPBAshXCIYuUUzk=;
        b=lSialMSlDnwRq34pEi3rHtzKI2bLlJa8Uy+RbctEE1ZTIxGTA1FCUhKZl9gAenb+tY
         rFfC57HfL9k6fnis2EPHs6LG+sUs9Rfy2m2V6nVAa7kBRVZ6Zu+wRmVHU+JDjfAyw60R
         bBzpQ6JXnS5/IllAZ29cfuSMpfXKmzSazVKpyIhun5NTpIf1HbJBVZUGYWudhjY1prhG
         ofsWPBI1CNV+eQR46oilw4K1yjOmWy8DJV/4CBzV22uqgeDn1VHkUCSofdYIKnu5y0jP
         YB5gNbwptaB3PnexiAa9e4KtQ8zAh3UX7j4hJRyhePAhLSuivTNaIGW3InPI5od0SczT
         6XUg==
X-Forwarded-Encrypted: i=1; AJvYcCWGQnQ9FtWNWQrhZRjkX4o89MorGLl6h2D1x/unyjyDqGcN265qLCms3Tn0ZUQPc9BejFOxoeCRsQ==@kvack.org
X-Gm-Message-State: AOJu0Yz8HRu3x5T0yxrSUCHmfb0uNfVR5d9uqzVhEuegCTk1F0/oAFpS
	U3ElN7C9kpLty4ETZvodyfAaxHAJURTEch2bO5N02GnW5fW5NeMHwxRqBOk9ZcBMeooqIVV776z
	yIs4KnYDI3geOzsKjEyDkB6C0ME0nWmIufsUthPOWqA==
X-Gm-Gg: ASbGncsI8cRtzvx09cctzZcwZ02Sdk9pidHYNT/zWhy3KoL00YwNfBPgKD/hu0n2qo5
	VfTciFYnz3J7DZ+1qdS5VGOy703zD1AdpEusYaTU7n3tKcm8Ej6PqpJgt2F4lnVr13Dx2LI/5Rv
	tHODUq8epSEPTiLWHoAqIUEvRiTk4BCB0Wdex0moYqVflTmjcFHYBtuJoLeggKX63qJTHfgryJx
	/b1
X-Google-Smtp-Source: AGHT+IEAzSN3MsXLZMJqt6wu2Cu/Z9Yks4q60j6ZTc58+gOys6Rgr8NdSPHkKqE9760XDbit4QV9DAY9VZSc1qgDJcs=
X-Received: by 2002:a05:622a:4016:b0:4ab:536a:ad35 with SMTP id
 d75a77b69052e-4b0aedd7c07mr68881521cf.34.1754684593193; Fri, 08 Aug 2025
 13:23:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com> <20250807014442.3829950-30-pasha.tatashin@soleen.com>
In-Reply-To: <20250807014442.3829950-30-pasha.tatashin@soleen.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 8 Aug 2025 20:22:36 +0000
X-Gm-Features: Ac12FXwZELMUp6FmK0bakKcUqFiUYIIUNXgn4oPjuRKBZW9iuH-cHyWFuj5z7U0
Message-ID: <CA+CK2bAP-PWkYtZbw8ofhTgDaW3qoQkNob30wWSjidxEUTV4pg@mail.gmail.com>
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
To: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, pasha.tatashin@soleen.com, rppt@kernel.org, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, jrhilke@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 495DE140002
X-Rspamd-Server: rspam06
X-Stat-Signature: bshjbcuhy3kaxrm8xym4yk9msp7mkct4
X-HE-Tag: 1754684594-752705
X-HE-Meta: U2FsdGVkX1+OOe7sxvyvtQwnhD+aK/plwTK6JJgzvLs0fVJYUWpZSo3bqnPgTxYUg/iAdKkQmQyojUTxtCyyJSmbiINFH+wphh58UmTNLMIwR73EUTM7Ip37nd1gWtZnYLqU1IZv4bltLn8ZOyhp1DgZFLSkknlOC3IYYO5Oit0Jdqd7DXhA3QIQjyotHdeDqeWfZv0oFJslJR3FXmRUFvPPJUxPpL0mgdfS8jnt7/1W815Ey8EeqjIvfpCjQvwU5g4DbgWGGYYt1jjE0QW2ZlQwfEQVTclKRNv0t0fVJvc1rBIH7QWl/Pr/NTRBksZ0+8wUIXPQPza7PF4OgXescViHIbdTKqUFZzOLakdVUDJ7zXmsNCXTnEJMRue3XUVkobPZgtIBWyzlZ0p60n7xIlcf5K5DDh+p3l4XByKfGT5548lK4C9HatAt6RLOI3GoRdFl1EgdoTN8hkbeN3erUKHIJO98k//U9gA1yLwW74szU62f22dYB4Z+lI5MIIjsWRJYGgWTwwjwAqVawGh6ri10EQNtFclokddrfJu7TU+Co9myMDXGRvZ8F0PBtJNOLw9x5TWAkAFsx1ebGJG+nQ8EVGkMrvexW6acEsk3QMlQvES+x0qR0WPxEgvx8MyIe/k5j0R5TZbg9/yiLo8QfwCS68ywZQQdmVXQ21Dnzol0DyQxLEdBT4/GWsI8/6QBQ2ON6tFXWn5MYZmliB7rniwtEimNkS2lPcaeRnKT2k7z4Vp++LDMhgeYxbInZK+5DeRkS49gLfWhOxE+8wGfy/SlH/2b54wNfl2QLWLMymD0ifB6h4Lu8+DtZWy0tm7KFEbzLLnHS2CTgEU0Yq7Ko3E5ivbqNTquTVIrsew/HzWnOT1d+XpRVf8yIOIkDdfHLwAtI8chrO7NUtcq8TvZgI4DUiKMcKbg8iLWaJ0IzQWxzK83OkCkhe8KlpQNb7ILvfdBehGo6rfW9k3aGTl
 AMnNuUcq
 lLgI0Pdc0WCUwJhYhitIMUeN8DoduKf3GnbXDnE8eT7q/I63C+Q9f5N/2rk0aiDwaCiScaazL8IxFcSuwEbvuGc0o+CSo8uNvNQH0pof458C7CwCjYpGT/WfFP4Y7AlAWoSDWY7Z1rDXr/GQpzbcq4Ma6quCnVSgzKi9bMzWqEpDlR/SoA66Cw3gwnNvJ5EQwWntNQ3P6ZKIYIJqZdcZpVgRf+1Jw2nCHtHYVXe7QRAlvAYcYN9cwpzCsiz2vSZ23I1aU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +static int memfd_luo_preserve_folios(struct memfd_luo_preserved_folio *pfolios,
> +                                    struct folio **folios,
> +                                    unsigned int nr_folios)
> +{
> +       unsigned int i;

Should be 'long i'

Otherwise in err_unpreserve we get into an infinite loop. Thank you
Josh Hilke for noticing this.

Pasha

> +       int err;
> +
> +       for (i = 0; i < nr_folios; i++) {
> +               struct memfd_luo_preserved_folio *pfolio = &pfolios[i];
> +               struct folio *folio = folios[i];
> +               unsigned int flags = 0;
> +               unsigned long pfn;
> +
> +               err = kho_preserve_folio(folio);
> +               if (err)
> +                       goto err_unpreserve;
> +
> +               pfn = folio_pfn(folio);
> +               if (folio_test_dirty(folio))
> +                       flags |= PRESERVED_FLAG_DIRTY;
> +               if (folio_test_uptodate(folio))
> +                       flags |= PRESERVED_FLAG_UPTODATE;
> +
> +               pfolio->foliodesc = PRESERVED_FOLIO_MKDESC(pfn, flags);
> +               pfolio->index = folio->index;
> +       }
> +
> +       return 0;
> +
> +err_unpreserve:
> +       i--;
> +       for (; i >= 0; i--)
> +               WARN_ON_ONCE(kho_unpreserve_folio(folios[i]));
> +       return err;
> +}
> +

