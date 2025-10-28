Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8150ECCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 06:51:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E290E80127; Tue, 28 Oct 2025 02:51:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E00A4800E4; Tue, 28 Oct 2025 02:51:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D16DB80127; Tue, 28 Oct 2025 02:51:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9002800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 02:51:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 77F5214035C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:51:30 +0000 (UTC)
X-FDA: 84046601940.18.F8ED35E
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id 84C394000A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:51:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=osandov-com.20230601.gappssmtp.com header.s=20230601 header.b=XVG6BCy9
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761634288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=psj4jXCemJsZZUfGmvOoOf/gazxcdY/IyYfCWFGurIk=;
	b=Ez5m+1ujF5uVJJaOu5vBggsSbp3pEt+2FLq96ObZemsrysng5y2ZniaktM8GeIvJwCV4TR
	oEgzHedLtpp1hK45MWeaUzz8YJzU5AZFE4J0eGYm+IEPvWkruMCAnG3ent99+Zq6kH1sxY
	AVwxFEGJGkhPcrWpUGx6+2SqlGpL+Pc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761634288; a=rsa-sha256;
	cv=none;
	b=wwh0DR7WO4SpBfRuwR9K41haQeHFqkMyGJslC0AcGr+cFDOTO60rYIIquTX6BtATDnPVW5
	T1lhsjXNbek5tG6y7ExQTgJnK+iQXTlaNy8d1DC0e80jFsSiSuopOkcIEVChjCKQgwEegG
	aVQS4Bu7d65NLOJJ2lQKti7NscMxAwU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=osandov-com.20230601.gappssmtp.com header.s=20230601 header.b=XVG6BCy9;
	spf=none (imf07.hostedemail.com: domain of osandov@osandov.com has no SPF policy when checking 209.85.216.47) smtp.mailfrom=osandov@osandov.com;
	dmarc=none
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-339a0b9ed6cso1360745a91.3
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1761634287; x=1762239087; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=psj4jXCemJsZZUfGmvOoOf/gazxcdY/IyYfCWFGurIk=;
        b=XVG6BCy9bWQ4FZtqKM/HTEiZngJyOYY8I2A7ipO1q/SREtk8kCoOwLgeoCJbmytI2y
         lSrI9H6+LVqLS5IRpC2UKDp/FzQcxy5G4Fw0HiKXUSjSQFXQ/ok9etOIVNyKVyfD8wca
         eli488MTOKGujh9okU8jkB9G+JfzqyUb72ctuguvM++VtbWaEdyke0vv8NuUyQdf+XwC
         3kSI2jHZYPwlJDJ5/nIfp4d60fZaK3bZ6erbxjf6bkw/nWiAX4nhDYzsIsAPWUw6dQpX
         rKU5mjqUD9IxWG0TsmeleN+G+SQuWe7IN05kRuIEmyJkasyuKS6k3TiQCp7bdvLLMnNg
         prFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761634287; x=1762239087;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=psj4jXCemJsZZUfGmvOoOf/gazxcdY/IyYfCWFGurIk=;
        b=qjLM3lDvxaxQacy7iol0DHXUHvWUSRPThOTGXY/V6zuXiAz/RD/QvoNjNKAzPSFZK7
         81VszZ4DbWKFZDAMfJSvTqageeouarfMpg0HwC3AYuPeBv1lTlZ+4FfMRF/bFwvj2h93
         PVWli7ZKf+YX9hfTHLWLIOpTzzbl9aCTjBLqPHMS0Mr29V6rSgO+EPmCs1Y1RR1D8qFF
         fA8guQE4KEQDh11oVW3y6jQnPoX/F9puA/wO5LJgIQszJ+hJctEKAA/Lcx56SG1UUBKA
         pjiAAxQEL/zHWuW5Duau7SavX033Sp6wQREjIosRdv66v/79m5XukSfp++nxGwkXQTPC
         CLPA==
X-Forwarded-Encrypted: i=1; AJvYcCVIqvI5Iq4Rok+AlhOc8KL05HV51a2aYY5ZEuA2n6Mg/XJpEnTtDZTZuhkc+lZPVtaTHqcm7a9Tkw==@kvack.org
X-Gm-Message-State: AOJu0YwkaiePW6Z23SUY/bCaC6B3Bdh3ltl5BvvRNnYOfWpEdqvt3mGy
	PzQos77CpI0JZNbVbaR/e09Wrzw3HUaXhXXtkeNSbpx6UhOQBqQrLcMc9Rwj2vmIEaA5FFPWlav
	zEFgk
X-Gm-Gg: ASbGncseA03hG/r4joXv9qqAAbiXXSJEQo8j+UOH4pEInJoZTsRgSAfd+DbgvVS9VT1
	FArbFQYfzV+U8zZeviZqWEKxP8cgrY4Oue5UY9mY3LCZZllbwLcATqFpqWIrzdgSZtyVIIzX81S
	eCibb/wmnbOrKLeuiGNTfbJlj8FSWLoDli4EoFKtZWDqueVnDy6EK2uWYr8ZynPZqrTClk/QbHe
	GRBsF+Yj2IJ3UlX5Ulr4HzNEHgu3ds/X5yIccjxrvWWzsUQo70WOnhfwg8lFxn0yiBewQyGz/ic
	KMj94J7qUTInaNZyvPSvArwHhmUvLkHiIYoF1CDhZP4APrWbIZBTjisNBrRO2ll8LCmC8ve4AQS
	xUUs9N4CBuuM8puEEziR0aFbHyR5zlCbb8Iel1nZ5/nR/l+kLwXR2R1+T+A==
X-Google-Smtp-Source: AGHT+IFexfDJiwsqeon/6lRgY/61fR03YmnIDMpYALp3seN/ceKZ1SeYGsExlHLpW7rSPgb1Om7wdg==
X-Received: by 2002:a17:90b:3912:b0:33b:cb9c:6f7b with SMTP id 98e67ed59e1d1-34027607154mr1674832a91.0.1761634287183;
        Mon, 27 Oct 2025 23:51:27 -0700 (PDT)
Received: from telecaster ([2620:10d:c090:400::5:1183])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a414049a44sm10331539b3a.35.2025.10.27.23.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 23:51:26 -0700 (PDT)
Date: Mon, 27 Oct 2025 23:51:25 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Israel Batista <linux@israelbatista.dev.br>
Cc: akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
	linux-debuggers@vger.kernel.org
Subject: Re: [PATCH] mm: Convert memory block states (MEM_*) macros to enum
Message-ID: <aQBn7Xsx2qi6YDWp@telecaster>
References: <20251026162156.12141-1-linux@israelbatista.dev.br>
 <aP-3dauwpc-Kq5Kh@telecaster>
 <391c924d-b6f4-429f-8190-b33e3b6a3942@israelbatista.dev.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <391c924d-b6f4-429f-8190-b33e3b6a3942@israelbatista.dev.br>
X-Rspamd-Server: rspam05
X-Stat-Signature: 5s94qaqadcjcxwkubqkcnqrxgic4mxtx
X-Rspam-User: 
X-Rspamd-Queue-Id: 84C394000A
X-HE-Tag: 1761634288-388855
X-HE-Meta: U2FsdGVkX1/dC/ncsnsI7MdfY1o3XeoNWujbf5QHh53Lb38NZIzAPbdE+PN2wtFewX3eHx5SigfIshziImWtAORjdSsPtwpCiGpvZR+i9Ea4r2UIvziEjbCmiD/14tFQaF3yJo2Wr6PhpXz2idar8GJwXCLDZeQ4dphJybb2G1jxRBeB6IpwZ+bSSZIGidU9cp5dYY0N4g7GzxKSpuKIfgJKaN/vnW36N3ZrBQjhCjVaonjiidH4LNBdLe/KzGZ5EHtmXknjhK/NYItm2DdlzcLWFL34rNmB2pA8w29Sr5C4vYvmqc43NoLbHrhhE4O8U0f6T2yYgKsjZE7ZhLkoNpLm7Tr9mwpkq90v4U+j0pV9QPY7VjjeUGnFSU82N355TfoICrDNhOvHKJhM6BjGfK0GWu+rpZgVWkYg3O1U6BUIlCDevfO5r9n3yP2rYOju/oP3PB3OlZKflcAJo4fKQevsVUgboECzybyhcxzwU4R8nU30eoEZW+qI6gkXaWdWyxhaUVs7OQOGIsQbfSUycqLDP8C0dLRK41ZrKRUomOVnqhEuMb1JPbV91kRtKwBgV9r6JhpVOfiNjys4aau1tqDVgK2BGm4fs5ePdyit1B2wv5YmyLARtw76N0SfhYis1MrjdpNi6OvKZyR+DCdLfDoQxzeXqZQF5SNPlRuzCZo7goDQD6DIsYpj2ykhwAaZbALHXZdp7E7jVEjNYzFYYWEIt4hM00yy6qRw0L2nKDJYeyIlT5uv8UtD+nC3wyaUYNSHvpehrXYs+e0EozTXMVSzU7x6sVHdgOfcWhgrdk3muGLUiAe6D0eW5QShdTMRW2N2SDLORw39gWiWFbpAMPZEvsZhziBeYysmvmGblTxTro0jvL7uc8iUgzwkj47LMpdRX3uWBmekQCOlaN55LY1VJuqFrZMcEFvd055iOMl4wRcCXfWOcwrp7v08+BpFvzYDCtRISn4AFzxyjp+
 qtQ3bhAs
 F30Z/Mj11jaJESVYDEdn1R9x4P6YQ0WgTXEPHLHhWekHTbpwJJ14AfParBio1vJAZmUSX0EcOaCvlQWEZw6H2Z5HFjHjkX/GonlAQ9Xs74GMNgKuJNPZmiudy89Ni6Jhur7d/4VHQdU+QZgLCN25ooSZawc3q1YseF9K9pQqpca/lx3HFM/ofot24F7tzUMpgRC2ClhjKrK995kon2Gn3KgvHARug6KsfNe1qiziC0GyB3AgNVQaGnJ7pX47ELCEHjZDhsYmm8VxiCy8L19Zdbe0tQr8zbRsZNVTD70V9IWR7noOrnS+B9lj8hZoBzblcc30l8NVOGxTN7zS/WGoOQqS1Os9h/fKUKqHQrLGHOS283yo4B28UlO0nN6W6+2i1ILAt+hJx/CUvVAzoyew7AlYlM1MB/bn6lI/vQMxiC8EgL/zV2Qc3ZiFcmrr/FxRvvLpG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000063, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 11:41:47PM +0000, Israel Batista wrote:
> 
> 
> On 10/27/25 15:18, Omar Sandoval wrote:
> > 
> > What kernel version is this patch based on? It doesn't apply on mainline
> > because it is missing a couple of definitions added in 6.9 by commit
> > c5f1e2d18909 ("mm/memory_hotplug: introduce
> > MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers").
> > 
> 
> Sorry, my bad. I mixed-up my local branches and created the patch from
> linux-next rather than Linus's tree. I will create a new patch with the
> proper changes.

Oh, linux-next is usually fine, too (different subsystems have different
preferences, and I don't know mm's preference). Regardless of what tree
you base it on, it's nice if you mention the base in the patch email
under the ---.

Thanks,
Omar

