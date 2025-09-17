Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4370CCAC5A0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 16:19:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BCFF8E0055; Wed, 17 Sep 2025 12:19:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96C3D8E0002; Wed, 17 Sep 2025 12:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 833E28E0055; Wed, 17 Sep 2025 12:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6D28D8E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:19:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2A0CD85343
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:19:21 +0000 (UTC)
X-FDA: 83899252122.25.3ADDDD0
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4FED2C0004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:19:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AC2xeu1M;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758125959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sbkMBeVkd2QsX19NXxvq/zinXbb8IJRh0dyhEXqRclg=;
	b=MpeTRwB0E0+4HmL4gxryVX6m2ossOhvXo0+uP+5nFbTV986z0wHFFqjIMT0d35+V9Rpbru
	cJklZegVYCw7KnqvyVhQtNkUGRzjIAUay1qKsCq5HC1XyB5805LBoZVwyG4c2/X1o/9LLW
	R/zMVImwRKnZb9PAtrIB6CAQmobdSGs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758125959; a=rsa-sha256;
	cv=none;
	b=CVx8OPnnWg94+4rKUeg6VHb1eUIE7xnSmYEyh65QSa01l92mPI/8mTW69FUR7N2Qo8DCPS
	G6UWSl0WsRLjw3JLESeGGeqY+J+AURyZ564LZiNrKpL9hqDIGtl58FQd1Kw4IsrJ1eUOVC
	/n5FYIAH760aLOA6QGVZAFDDafensuU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AC2xeu1M;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4b5e35453acso80036661cf.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1758125958; x=1758730758; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sbkMBeVkd2QsX19NXxvq/zinXbb8IJRh0dyhEXqRclg=;
        b=AC2xeu1M6vi0XA96vhLTwgNKzqTvaZbW+z8bYL6Zy4RrRpFpoFOD8d+WpT0iUKMHBP
         3w2eqwWeY+xj5leyOecQ5ikx22vczSpNNeejChdMzM9SHTLvb/Jhc+ylYG0aXSQUEIRD
         cw7Q6Kkov38ZjKw4pXKpGqvgLHNqkA3fAzT3xWSGPKVJnM68tl1BJQxtXukcX+8r3wQc
         9E8qV0xBmYoOraJ5qWfHRGsZpij49pfgmTSXT53n9PIY0lnmdG21N8Hf8yNQnZQDMsE1
         bvirPNtvaRxn6C2SOTkW/K7JgFISwscejKuzpz2esFDDV0Op0mrHDDZ309eQmmuyhk9a
         sU/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758125958; x=1758730758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sbkMBeVkd2QsX19NXxvq/zinXbb8IJRh0dyhEXqRclg=;
        b=sHfjB3g10qT5MYaa/Ynz78rfYtcXWUn1XhWLICNxiFSC9b1KEsAspQoOlGDKKm3a7r
         2rv5ISY9H0xjBQn0+43sczvE3cHRAY6s6vvIqzk5cp0WVA8+Fd8vALDBXdlZqdlR0I2a
         QCLcfu4q2rCcotqVn3YjLg7GlvyR7aS9fYAmOSjJUSzbolf6UPLFo6r3as6vWW0clJB7
         nN9d8CaHKvWBAv3BR99CKa4kPdTOksmH3/2mxp8jLUjUzm2RFxygMVcUsmpLwaU7ucX/
         2Ia8Y6QAE2sUH8AtmvHmtbUeWlRij+QYMbgsQPj0Qvsf1qMHODGpnXnmZ1ltZXhMOCNn
         pHNg==
X-Forwarded-Encrypted: i=1; AJvYcCXqYoG7++1u7D97FfGyq4YI7SqKubfwNURL2qORpiv7nXcPZ6038AAh0AyCgOEgCTZ0s6+XkTMjsw==@kvack.org
X-Gm-Message-State: AOJu0YziDswt3ZEZnYyvuvNxdJtiY1XDkEC4wF7z5t0kNynZLakRzN1L
	PSxpYUgXqiGDGvijCGJW6timANtZUaBLSTTvFTHtdFAj9ywhB63JWeo4AZJysQVM0rmJjAQqcR+
	NKou4NnVDp7NYzJfG4e+oIYhT3gC2qUpo0CrV8pfX/w==
X-Gm-Gg: ASbGnctq7dOD9eLjmpWkBr+Uo3Rca7xZkh3s3JvmvYbNyq2ztBatcCLM/Ik/KEZv63q
	53o9fynwUhVJ5+S4hj1w16LKEaLorC2H2tPNmZN2OvDNSGX6CuYalz9ToDrGVi/89Rk3P8nA5RO
	v/8OidcvANMYTVH9bBrveNr3FfiKSa2bn/zAzyauwWDowUgL7wxXA/M5VSre+IiYQpzn61YlBaG
	3Ib
X-Google-Smtp-Source: AGHT+IGRAvd1PnnWvQJ8F4H+1eu57qvinrMS4TrUKO+pmpvMdhYGbF64WQPsfAaGR7+V69bkpqWp7J6cB8kByry08wM=
X-Received: by 2002:a05:622a:48d:b0:4b7:a44f:5263 with SMTP id
 d75a77b69052e-4ba6cd712ccmr33213531cf.71.1758125958222; Wed, 17 Sep 2025
 09:19:18 -0700 (PDT)
MIME-Version: 1.0
References: <20250917025019.1585041-1-jasonmiu@google.com> <20250917025019.1585041-2-jasonmiu@google.com>
 <20250917122158.GC1086830@nvidia.com>
In-Reply-To: <20250917122158.GC1086830@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 17 Sep 2025 12:18:39 -0400
X-Gm-Features: AS18NWDMazE060QNWHKjDg0IshqlUPi2ez4c84o8JlbYF6kbzA9fUlhLDhAngT8
Message-ID: <CA+CK2bBbSSyCDAAgThDSSwH0WdOeHz-eVgB-1bdiwsDtTSE5pg@mail.gmail.com>
Subject: Re: [RFC v1 1/4] kho: Introduce KHO page table data structures
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Miu <jasonmiu@google.com>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
	Changyuan Lyu <changyuanl@google.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Joel Granados <joel.granados@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Mario Limonciello <mario.limonciello@amd.com>, 
	Mike Rapoport <rppt@kernel.org>, Petr Mladek <pmladek@suse.com>, 
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Steven Chen <chenste@linux.microsoft.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4FED2C0004
X-Stat-Signature: 4dpscjzttk6ghdziqjmjr8y1cbr1qerd
X-Rspam-User: 
X-HE-Tag: 1758125959-465479
X-HE-Meta: U2FsdGVkX18T/9MjD+l8nX0Yfs+KE7bXEQEynMxAdj6h27fgHY8uhIAgeWbbUcnCnNxZ4LGPQkg/ArW91p/M0y8pN4n9RdPmcPRq4z51M6uWYVUaZ+TengSW94/XmM+PisndWFqNgL7SF7NfCEmd70T8eNuRtnEtChAEE6wbrHjhSIvqAxxrXUJlp84AjvvjOAyKEQICoJE7nDHjQzYxqxI6kgd1qOE9kjK32duHcAvBPadok2gjD4UL2vmhKEZNV63avbWwZd6CGkcXyxa63co898Z2q1MMAjq/1UvrPUKRj59FWw5PoSRYVe7lHt8+qPZ1WktiEy9uG+rJGoJ9VUS06XNAcrrsqhYnNnlqnKCkYfFQnd5bCzeoq4FDQr5tcbtDRUwgHOqSmtuQQKJCO155vOqcevq0hjzaFLy1yQCIj0XXqXXeMGqMixGS0F/qSb4IQkrGqWSuAScEwQpmhL2pSQQq+XLN2dIiDi8NWjaCubx6E+1htaN3k5ujMhpTFQgtlSmTzrf+h4U28FBzf1YMTX1ql40tU1L9y2dJv+JpWYECMAqsWa2JiDQR4hhyRA5JXG2zdZiwb8NoQstPkhB8eh2fhfKtiUfTjA5JDOsnCsYXnxbAyNC0tgRxUMdFDcf6qEgXWfTa3D2gfFo1V+6+veFXIU9RU2O9p++Ox6C/9P1lYzlAolGQY0RqOj57zHGZr3hW34LizYfjrASgzbrrnZZHo2MKRn5nRDgy6M2e+6vNch40QxaD01FRrre4ExLIyeuB3qxvTD6FLz5N1Lrq3Ym9k9swZpCVc0AA3lTkJU3dcGFcScNbrhfle0CFDJjFJK7ip8ZdH/dlhro3dsFlyuxvj1IYJzLAEzz1uWMU4z+CfBMSCN8cuBTwszzLYhTII+7P4/3aBmnEhQDRZoloFY6TCuOh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 8:22=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Tue, Sep 16, 2025 at 07:50:16PM -0700, Jason Miu wrote:
> > + * kho_order_table
> > + * +-------------------------------+--------------------+
> > + * | 0 order| 1 order| 2 order ... | HUGETLB_PAGE_ORDER |
> > + * ++------------------------------+--------------------+
> > + *  |
> > + *  |
> > + *  v
> > + * ++------+
> > + * |  Lv6  | kho_page_table
> > + * ++------+
>
> I seem to remember suggesting this could be simplified without the
> special case 7h level table table for order.
>
> Encode the phys address as:
>
> (order << 51) | (phys >> (PAGE_SHIFT + order))

Why 51 and not 52, this limits to 63bit address space, is it not?

>
> Then you don't need another table for order, the 64 bits encode
> everything consistently. Order can't be > 52 so it is
> only 6 bits, meaning the result fits into at most 57 bits.
>

Hi Jason,

Nice packing. That's a really clever bit-packing scheme to create a
unified address space.

I like the idea, but I'm trying to find the benefits compared to the
current per-order tree approach.

1. Packing adds a slight performance overhead for higher orders. With
the current approach, preserving higher order pages only requires a
3/4-level page table. With bit-packing proposal we will always have
extra loads during preserve/unpreserve operations.

2. It also adds insignificant memory overhead, as extra levels will
have a couple extra pages.

3. It slightly complicates the logic in the new kernel. Instead of
simply iterating a known tree for a specific order, the boot-time
walker would need to reconstruct the per-order subtrees, and walk
them.

Perhaps I'm missing a key benefit of the unified tree? The current
approach might not be as elegant as having everything packed into the
same page table but it seems to be OK to me, and easy to understand.

Pasha

