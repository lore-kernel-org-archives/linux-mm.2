Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6986DD29C33
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 15:09:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C08EB6B025C; Mon, 19 Jan 2026 10:09:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B96216B025F; Mon, 19 Jan 2026 10:09:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A987C6B0260; Mon, 19 Jan 2026 10:09:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 97D8A6B025C
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:09:40 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 51750140169
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 15:09:40 +0000 (UTC)
X-FDA: 84349047720.16.BBEBC23
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id 58B6714000F
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 15:09:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VR7lvvml;
	spf=pass (imf26.hostedemail.com: domain of smostafa@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768835378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9UYprNeVIjPbdEC/Vthez+8t5RhTWtuHYzI22TL9Cf8=;
	b=m/VHr63es7c9i3F1Pv0vpygzkQfmOtZVOqHb+GMhW5w4icKp8hOEGzF2JFetsXqE87hEkt
	mOee4RPVa/QIhS5nFqoHKw0PCZAGjoU+W/19s1C/mwPIm31UFls9xiEevY/WSNvEf+Flhk
	Da3JEBc0TVgx8B0lj9F5pNtuFu6HiPU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VR7lvvml;
	spf=pass (imf26.hostedemail.com: domain of smostafa@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768835378; a=rsa-sha256;
	cv=pass;
	b=skOKrUklLOnf7w8/u+H0P8l0fzYncTKGxB7BAjZyNZ9qa4ny3U71XD9OUpyJybKPHC68mp
	JrD88vyvq62bHueP/Nx7xO7QX+ekkRlEBWui8PfqiolKFjp+OwlYnQqIctePPHNsXECKud
	SS6eX0a98sWlttVMegVI5NZ2oUYhKVM=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64baa44df99so11400a12.0
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 07:09:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768835377; cv=none;
        d=google.com; s=arc-20240605;
        b=ACy7cig5WCvn9c2rPH39UmtwhZWRestANe68ubxSJcK+zRFdZUvGmHHw5TzlDQXJOZ
         T9muPMDDjZ7MJEDsZlfWifG/qk09XEfjOaQWaTwxh7ztKAN+8+Sx9CnPW4pV5QSVtTGG
         6c3iHKGHmX/fm0RKVyYVg27o6z/LD7sFH2rMTifUDtAitVgyKgauoK/SX4ypwbv5O36a
         8L+Y8NnW81GciSDncFfGdCWgkAEHB/SlIuMOMNy58KSwEVt/2WgpXdaliW0q+iTrGGek
         9eyp+RA+YcQw4NpcvaO7I/T63ydIx3Axe0dQEFGig4NNHz3K0aA1rbJ7aM7Mlukx+fFw
         VrQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9UYprNeVIjPbdEC/Vthez+8t5RhTWtuHYzI22TL9Cf8=;
        fh=qUQaTQfYsz0dk7ltB6Zt823feya5Gn1FZqjMXRBQkLI=;
        b=Rpci0upTW1MShGdTkDzuWbo4644HQYJSaBs/KtPkq4/eGzlKjcnyKe3FHmBAA+odyf
         W2LLjVfXcyRZoE0yBzEIQorEF680O2E+qGG7D1tC64Hvet2Aiwj37dez+Sx14sS+iPtj
         +xJBRrygThcqNluc4jc3WZcQtqMdwoY3Ky+Bmf2GnWbVPOAotdG0w8oKFTHARKa1vemi
         ICOmhI7jq63p9xRgiO1YJSd+7LLuNJkAGqQ5kL0zeCfe7BqNzH0Y4Jnjx/s4y/2SW9Mc
         Fx6gmcpEBlGd5J67QNf3u0akTJhdy37arkDGDI6QzxHlInQS0Cfo91uu4MbmFcbIJr1W
         yv8w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768835377; x=1769440177; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9UYprNeVIjPbdEC/Vthez+8t5RhTWtuHYzI22TL9Cf8=;
        b=VR7lvvmlgwJD+E17oVb08SX9/iHjcfD62xs1ABK7WhPsO1VtjAZ5c1EXtPE157QDit
         OP1y6QgdRfzdK5vt/UWrEBUfD81zSIlFIC476FqT5n8NP/4+GRpHtY/dNZ7qZRdaw0kA
         wi+ZZP+cmaDo9Wgo5R+xKcTx3h8raAoQ50gYI3Nx/tAme3hiRsqPZq+zjDCYzZmsVZd1
         H7YnYMDk7Lh6O0ZuUbDk8ykdxsmf8QKyGLNI6Gx2YLNsdAatG4vFvpusn3vqhcuItnTE
         JK49sGMBsC1e776rlgCjHzmWPNOsh/SjbLinmGsz/JfZOeXBdo+FEYTsxf6NgTRJwU4S
         ZbFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768835377; x=1769440177;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9UYprNeVIjPbdEC/Vthez+8t5RhTWtuHYzI22TL9Cf8=;
        b=ur6VProDPK7OpsVf58fCx5Rc3fBMGu9oG13C0kbZU1FZ7LkafWDF7FPtDAcNo4ZVCv
         3oSQaBgDnybgn/aFzIU3yrFAoc1TK4mxyvAiwZKmnaMRASDfcyHShXIl2u9WVLvc19Ct
         cLZ42uQEo/V8rfgNPG8jwVKazUiyJ8VwYU4SRV9+zF+HKOTSiQ3l3oXCNXmcY5Wx+Pen
         7ONUlmHfpjMIwO+Bg+DxtRdqPaUXXkrWo961Bv26TVuHKwqrf6eNJpaH7e8csc7OnYjX
         gEkc8FPgc6AJ0nxX28/2EVrWkseqDED63rMi+kGhMmpHKYJmFBUn3vUV0g4PHauR6szZ
         H/Kg==
X-Gm-Message-State: AOJu0YxdxOrxxCGurC1pUvYCZ+OnLAGDXYzRkkYQuUCcTzLIT/UwcpXf
	rQjZN7oHBm2LvwX1VSrP7l/6MS4KS9wZy2pUmiqtAYAhOThcuuJmcBWEzL7lXlzVcPVgeG+iw1v
	Y1163RPNlof14wPEywPJOV1o1LqSZ9+Lok4G4pJ2F
X-Gm-Gg: AZuq6aLDh/XKkkfKSXOoAmjIN9chS00Uwg2GshnUG5FAgF8dsPqbR0WDHuCwgs737ZB
	8Nz1ZyZsepdFMA8e3Ave/ajG75M2M0PU1wRldhgF4WtrL2ooRzjk24Hqu7d2K5ZS9v4RjFlRpGn
	mVJh42qGdwbFWaBrXNPpv0yl6TkkWr0KyTMjxbZtRBRdedvruFXPHGaIceiYFySRG9zI6QNiEzp
	LUZzxySMtP9OPAwg4HeyrLLfzkrvgD9T4yXv/c8v/d8CdWCdcfikbLQots4EcIvfgi4anZDqouM
	YddpTw==
X-Received: by 2002:a05:6402:518e:b0:655:c10d:70c1 with SMTP id
 4fb4d7f45d1cf-6560b278fa6mr65248a12.8.1768835376417; Mon, 19 Jan 2026
 07:09:36 -0800 (PST)
MIME-Version: 1.0
References: <20260119142246.3821052-1-smostafa@google.com> <bca59694-6b09-4839-8577-c8ac4420eb56@kernel.org>
In-Reply-To: <bca59694-6b09-4839-8577-c8ac4420eb56@kernel.org>
From: Mostafa Saleh <smostafa@google.com>
Date: Mon, 19 Jan 2026 15:09:21 +0000
X-Gm-Features: AZwV_QjVeUiz0Q-zd8xi5T7pPmQe5X_A7eWLr5iRgluDvbc3fWR971kZpw8m3kA
Message-ID: <CAFgf54paL1O22-crK-RufOzwYBqQ-CU4BD6=h30WOOfdA2__Vg@mail.gmail.com>
Subject: Re: [PATCH 0/2] iommu: debug-pagealloc: Remove pfn_valid() usage
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org, will@kernel.org, 
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	rppt@kernel.org, xiaqinxin@huawei.com, baolu.lu@linux.intel.com, 
	rdunlap@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 58B6714000F
X-Stat-Signature: 497aezxnw7jdwnns9ft49swci1rnc4s6
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768835378-769289
X-HE-Meta: U2FsdGVkX1+pJEbTmuank9h9P9ysl10ybOFFh5DHaa7uG5r5jDmbo91Zy+NrnAmEdZ8zE/zxBJWpJOUxdpoH3UXpYBmrR972uXfc8UaWNg1U7GfhBmDuBB60C4fvJ8VvXAxWxd3H4l9ZDT/5ontqhoRn8OMeQxiRGMDfSK1FS8Lv5FjbfSigcW90oGreKQpoxt1Toe6MTOuPp9LPwhfLzntq434Jts8ANZST4h/rUEdYnQrxd9t/X98QxIrrDEg4v0qwubs/thJJ3EyiOBLr12EZ5k+G6ExcOHZo8sFOz8bn0I4WI+wQ8MA91F4bamC4es0AZ8JMRfUTZYaDrVpJVaeSDtXAYCr1dOSkL4VTNGQJGTU394IMKwHPIoCgMjZK7BCQjC7fkX+sl63O2juw/rPNF229VwQBNI6Sg/NZC9SHUxIIrfQqJJekFxd2iHIdMrEskpsrsDCaswPts5V2A+zA7Sy2bUyMSM6qtes3BSDP1pwrhwmjOam5ziFe2xCxPSjE24tABfK5TlFUnETlwZbFW4voERxZNhNRAdcGusX/9ntR446yC9F1P3HF8/gR/FzHa4Ho3oP80xC+LxdtcsV6pfQ+7/QT/+Zm+DbcIVUQUpyQII6C5lWWnYFP5drGADyFPmi2VLUSuaWkJLI93L7KrAmm3rWioEux85OyCP5l6sYNXVz/hPe5IkvlytlOe9LZttCRKp6ZILSkHObVerWlpAliTQzE36uVZ89fbMp0pOfFJ7m2plCkizTDsA53hJeOeIsY6eA32z46BfDmreOzl2XK7JFYQyVfczDBHNe6zxRcRAhKIa5AJr60h+RxObDz11ILhqzelyFQTYXUXWKqVI+ggsVY9FIY9mz86gXHP2ZRCV6iB8vPHZRZAIwbn257++6oj9ObWMT8fc0MgVzW4eI7JgsrbQL5AR35r9EJF8NUmqnwE3FDx009/fVyQhZxMAby3ty+1wq372E
 jKF1HwQS
 Ko2c4vJ5xQhaoSeOaDuNwcZoj4wayDZp5OWVCjJiV3L+UgoVikKiAQa1Oy+Uwd8CJrs6h8/qg7HiSeRVoofz1R1jHchuP96jC/G1OlhApUL7Jsfhhftgl4im4u6Js+g6IiX1kyDcwOUWHmJkZY9rf+ofmjIL5t+wd6XLlFBuPGJi/PcFAX9n6OuPWsPfpLwz1NoJoCkF8U7wRiqA/cwHGIHkOnDiQeSFBRPl79fBafZljxmNPzuZ7HnubhtOFcaaZMJWOqIadNS/5n5/vVzGBOGLYM4W5efRX/6AMvSEaaOfkSK57SeQZ4AzhpPfcTDpkRUpRvavLbk5mFfuIvV3BdufzmaivqgkmY5nsvODQL3acFxeICxVSd/U/uVn9T1v+f03lYlGJfGVg89JTniueBBF8s7eeLi0Q4UXsv2AgLr3niTQx4N58LmnFxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 2:27=E2=80=AFPM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> On 1/19/26 15:22, Mostafa Saleh wrote:
> > This is a small fix for the new config IOMMU_DEBUG_PAGEALLOC based
> > on the discussion:
> > https://lore.kernel.org/linux-iommu/CAFgf54pBAUm3ao-UJksiuGKtvv4wzRyFq_=
uKwLe0H1ettO4DLQ@mail.gmail.com/
> >
> > Where it was concluded that pfn_valid() is not enough to validate
> > physical addresses before access to page_ext.
> >
> > The first patch introduces a new function in page_ext that takes a
> > physical address as an argument, and the second patch uses it instead
> > of calling pfn_valid() and phys_to_page()
> >
> > Benchmarks with the new implementation can be found in:
> > https://lore.kernel.org/linux-iommu/20260114164322.787125-1-smostafa@go=
ogle.com/
> >
> > This series applies to iommu/core tree.
>
> This is part of v7 [1], right? Can't we just apply v7 instead or are the
> commit IDs already stable?
>

It should be stable according to Will:
https://lore.kernel.org/linux-iommu/20260114164322.787125-1-smostafa@google=
.com/T/#m59d0b455e3f2160cb6f9980a0ae65bc481c53898

Thanks,
Mostafa

> [1] https://lkml.kernel.org/r/20260114164322.787125-1-smostafa@google.com
>
> --
> Cheers
>
> David

