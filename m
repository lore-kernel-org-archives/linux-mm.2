Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2FF5CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 00:52:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 148578E000A; Wed, 22 Oct 2025 20:52:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11F6D8E0002; Wed, 22 Oct 2025 20:52:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05C638E000A; Wed, 22 Oct 2025 20:52:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB7E38E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:52:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8A87248F28
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 00:52:04 +0000 (UTC)
X-FDA: 84027552168.14.88E05EA
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9984AC000B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 00:52:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kzqXSyt2;
	spf=pass (imf22.hostedemail.com: domain of jasonmiu@google.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=jasonmiu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761180722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W8Jk8TbFz+c+orpz7oeJzw7HBha49CvaH4Ccjpa3WnU=;
	b=RD2hNrnixvaFplCuubK0znhWtkVxZneagD9nWy8HdtDzXAMyC9nK4ol77pLnUlng0dCze8
	fJrxpR+HAcJFoM3hRupP7ao/b7I0V9hREG03sJ4EL0nISfuj2kCC+vbv3+aktkugPnyVXT
	e+hbbrejh2vX6nRRd48RzuNvUeANPnQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761180722; a=rsa-sha256;
	cv=none;
	b=MoW7z9PPWY8Um389v2XBCQn2eqSv3WFx5KGSkjry6OUCUjqOcXohzWaSBR85LhZreZlmpS
	kxNF6F5VkHo3WixpjNsbJc1Ejc7nTdC7nNM5jw1fvBvIY9ExPJ8WQoBa1GnS8jC9LK7Y+2
	E2n/ZY9K/X5nCvHo0L33xSwV1lTdjag=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kzqXSyt2;
	spf=pass (imf22.hostedemail.com: domain of jasonmiu@google.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=jasonmiu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4298a028de6so80061f8f.0
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 17:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761180721; x=1761785521; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W8Jk8TbFz+c+orpz7oeJzw7HBha49CvaH4Ccjpa3WnU=;
        b=kzqXSyt2M5cjSCFjaZEFTHr3vOefk6DiKLIRX5OwBlNFCKBdMqZSWdpxyzE6WOu1mx
         i4e7LNK2boqPXpZiqgXkQFFRmw0jEdHr7Tt+ogBb0hvMjnXrtCWqmPe2yOY/3pULGuvH
         tYGO0jw/Hw0ygbcSzPZOpkARK/hRl4c5fxkDv29qwTYGlLs/XOd8G9Sj+U5tzh3lmTbf
         7eGRsiV0/0o6FazRdbmtYtScQ5Y+IHf3OrKTGF2ow460mBOkIrupdRFzvwOr82g8PzJz
         dEgZdAaiiFagWsTxD19DeZWrDWr36+WclfWsi9VkF8kQ4IqCax2mLOBoKcHoh8OKiJk0
         n9jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761180721; x=1761785521;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W8Jk8TbFz+c+orpz7oeJzw7HBha49CvaH4Ccjpa3WnU=;
        b=G7GgFR3HSqGcCiXy1Y5uCWSO9DCilGOY7JD34STQ5hGBTbEu/azn109RWHKWdKzd9f
         cgPCK/2k0rM/p5Ftbu9Jz6/hrucN8T5UToavFLxdeshCsnCRU3/9SFCjK3xxObe5QUK2
         5qeCYu6cyN4+SdJoWQn1N9dU3i+8YfJLh0Moum4Da/qEke+Bp5zX9EMXq8Y29ZkzwS72
         J+p6mdboT3UuAKAEAicXjjkfSpPKH2O86uqxqFYy84X485W6lbXONYbbkNzAIaPRT36b
         AAd0L8PF0VlmonWlpt9K+R3TaAjBTGILFTTcQ0XPV4f4NYfzUW4BWfFEltRf58N7U4Vn
         Xnsw==
X-Forwarded-Encrypted: i=1; AJvYcCXyzqbsM86eguToIOQqDnwVpNs8HrCPM5tQ9paRqFO3wvnIsoAtEdtNjC0twQGmVUbny++Tfj9UNw==@kvack.org
X-Gm-Message-State: AOJu0Yx9hUc3VF8edm3v6Qq6ktlZWIBsMihE9p07ZzKlrVlWxioyAUCZ
	Wq5NTBGn9C3Es69SB5K1mJrQCTsT33Kp9uvr7XMe70GJngluRQawqB7mq4ddzggmtE2fk0w16HI
	aSBd3iMP4dwG0kn1/e+/snG8ncRPBTSp5dVJX+0qK
X-Gm-Gg: ASbGncvL3iLf9BWPoETIrNAYNbHjSgrrbhmiJdAkM7lIbQfTjVLBZ3tpHr8UEmZUVcc
	Q4z0FBqe6iGNll3hhT60AqSfj3tj5tRbxTZzhtfVwGp53tzWVouiiDHN6ydHTjwhtlFGF7UeBfN
	KeaSn5eV88laQJafGbcd2h9HPgtGNjlxJZfSfNM7BXN46uUA57XvqHBCKa6htQ1ulOi6wbtRHDi
	uBK1wz/pnIQE/4BygAzDXOFYTl3X7I8+c+daAHkWUrnfo2l1eqqFlEMpnmvwh68M0vcUNRpo+6i
	6U5KSWhkloAAad8=
X-Google-Smtp-Source: AGHT+IFK/T7RW48hj+WP37N9B2l1dCUkOXONz78Rxgy6qFPZrqWAJdOfNPD+bEnJuzrg23GT3t2tLGdMLUv/EK5dHM0=
X-Received: by 2002:a05:6000:401f:b0:428:3d14:7378 with SMTP id
 ffacd0b85a97d-42856a824dbmr2474671f8f.24.1761180720791; Wed, 22 Oct 2025
 17:52:00 -0700 (PDT)
MIME-Version: 1.0
References: <20251020100306.2709352-1-jasonmiu@google.com> <20251020100306.2709352-2-jasonmiu@google.com>
 <CALzav=eqwTdzFhZLi_mWWXGuDBRwWQdBxQrzr4tN28ag8Zr_8Q@mail.gmail.com>
In-Reply-To: <CALzav=eqwTdzFhZLi_mWWXGuDBRwWQdBxQrzr4tN28ag8Zr_8Q@mail.gmail.com>
From: Jason Miu <jasonmiu@google.com>
Date: Wed, 22 Oct 2025 17:51:49 -0700
X-Gm-Features: AS18NWC_Hu82xF4WRuApY2_35h--MDrT0GhF0LG3r2mN6SSshPCeTMJF4FJ7YTM
Message-ID: <CAHN2nP+uiz5MMPTi5pBVF355_=GibgYf+6jQR1xVOAdtD-2aZA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] kho: Adopt KHO radix tree data structures
To: David Matlack <dmatlack@google.com>
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Rientjes <rientjes@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Vipin Sharma <vipinsh@google.com>, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: b8zdo8ph6krt3xb6z359xwsftjn84n1s
X-Rspam-User: 
X-Rspamd-Queue-Id: 9984AC000B
X-HE-Tag: 1761180722-738709
X-HE-Meta: U2FsdGVkX18B6vSflAhPlYsPxn8SjJ4/QCE52NC/+0+2cg9x1Fys8zv4r98UM1UQp4V8LH3xIrxFPEcfPk0gQ3FRXvs7qbKssDlwczab1mSytaRribvJfbm7yJfIEVbqZCjnEEmjrlTtatgJ9hDO2yXjiqKaXMKGJ3NGaDuQtIybaJfmCvcOn49XKXbqWf7+ugNWij7B1imB+uNnpqxxUENKWlUlp6v25GN+vcX73jwybyDMIsit7c/lehtNXWCT52tXwd6JhhEVDtAOb+lBuILCR8BHV3NZ/fztBLZ+7WghaJH+SIbKhZEAhFHQ+xKH0px1iYzDp5gdm8nd2IpiOMDcoCK3haqbji6+/J3RebQSpQNOnkL6fjPGzUCLEXnApWYbaEG92y0wQZB+29OAgijWWRExZ8zW8nSZYTHI/WbgiDmYFDv1EKP6BEqguStQvZiyo0HlJAOkNHPkTsPS19+gVFcRJBMjHsmmIBfMYwwFau/xuaVDqEN07Fz1fuPVeFahQ8z8YYqml/8W1lZDCxbfaiRmuSlMJzKmsunIqJfo2bLKxV+fX8HfXF9iTFpGE8d9EOP+4kTbNAGM5N7b4g31k/6Mn9NBpzdYg0I0mI3rhbkCNOOydZgxZqqq1HiFpqx1QgFCJxKSKs9uKvBk6TpD2G0JTh5BcjXSdOyjsx7SY0HTa1WVpjo+VNQyzuF8RcQ4Tp0i72g+7QWlwt3M+WEl5SYfM4QGf0k/A7+5hsQaLAOHfkzRj7os7s2ZWTD9vuE/eIiBkNfiz9wlVI3agYVVJB6pOEylVt8TS5OMYR0NffDj7zhfUL1AMHTTke+5bA1+ZQoCjO0MICgF3AZRGhMJGT/HpMgr38aLeqwD7Uxnd0fhwYRZwEtkb/siBn15dWI1zIocaPO6HGJlkwgM5r8ST5+F5v1yDf3RB0/qoV0Aky5tfMvIJftbYWvetICTY0I18MKE9CX0GG0gtRP
 hw/vT6Bg
 s/MAAu9wlDTE75Ch4WgbF1KwGpdonN/JUJk1jMjTR3fAe5e0ZIDEIRpgAVbrq1zKic8CwjkPiTLml4qRaZ81krkhEmH656fKcQAXtGyOVWSwA8jClLDJlW9SHfq+c/r5UQAmEakiyk2XdvpmmKSL9NTUZ3kiAWvmvs0AWlx+MwYUwVUDoONl4PTWeH7hnQlozmwdXXY89eFPZNJhTkXlUIN8EaPk7JrFx+ZRH/vqF6zxEY02s8ocMneOagtxbZwpytXiInG4o92ghKqTkUEFbC3XmPm4u2z31OckTd/PwY2VKm4Afw3eUPQvnnTwf0qmjmpb2tWr0jDfZ7NQ+Vp8s43uTGaoCkPqM24jcbkGySovQrE9ve1t2Xfp81++jdz0BIR6zpvbyfdah098=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 8:51=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Mon, Oct 20, 2025 at 3:03=E2=80=AFAM Jason Miu <jasonmiu@google.com> w=
rote:
> > diff --git a/include/linux/live_update/abi/kexec_handover.h b/include/l=
inux/live_update/abi/kexec_handover.h
> > new file mode 100644
>
> The need for this directory also came up in Vipin's VFIO series [1],
> so let's align on a directory we can all use.
>
> Should we s/live_update/liveupdate/ to align with the file/directory
> naming convention Pasha is using in LUO (no underscore)? [2]
>
> Otherwise, LGTM.
>
> [1] https://lore.kernel.org/kvm/20251018231126.GS3938986@ziepe.ca/
> [2] https://lore.kernel.org/lkml/20250929010321.3462457-1-pasha.tatashin@=
soleen.com/

Thanks for the suggestion. Yes, let's follow the convention in LUO
[1]. Will use "include/linux/liveupdate/abi/kexec_handover.h" in this
patch and share the "include/linux/liveupdate/abi/" path for
liveupdate components.

[1] https://lore.kernel.org/lkml/20250929010321.3462457-7-pasha.tatashin@so=
leen.com/

--
Jason Miu

