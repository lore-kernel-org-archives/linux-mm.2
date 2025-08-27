Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 771F9CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 15:39:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7DA16B0023; Wed, 27 Aug 2025 11:39:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55446B0024; Wed, 27 Aug 2025 11:39:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 991E36B0025; Wed, 27 Aug 2025 11:39:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1A36B0023
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:39:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43B35160676
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:39:15 +0000 (UTC)
X-FDA: 83822946270.24.5B8C034
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0E1ABA0013
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:39:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=S1veYhNW;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf25.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756309153; a=rsa-sha256;
	cv=none;
	b=uE1VC6HEF04IciFItQnnvPte2XMztH+Aksn5IFv0SkuKagDG+DMxN0rR5WElY8ZbDPm4w5
	wFgkpfgMzGTQDXu0hjhXuY3YhUdwQo0T/g+r9ToZM39BxDuqv+crtxoi5OZfHYJRsTEfvb
	ghC5OIMW6bJzvrbE2LMDMLB2pwiwgnk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=S1veYhNW;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf25.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756309153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JAnl4bFn7YJIAJ0z1R6sCpDav1qEAvuA37AHDZnUHrQ=;
	b=I7jBTrnEla8nMMmZfKDHuJKz2G2CYV4MDApBKmsGazWp0GJrlXcbmmEvA7TvMIubpm0JNC
	XzSTNRKI0SBJozm3v9GYVaBI6Hc8FNHZnbZwe9rwQq2If7oAqayjgadQMprK2SZFfSm+K+
	b48OeGZaME3K32mNTfam3sna3AJSPRM=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-afebe21a1c0so187142566b.1
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756309151; x=1756913951; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JAnl4bFn7YJIAJ0z1R6sCpDav1qEAvuA37AHDZnUHrQ=;
        b=S1veYhNWF63GNVYZnxz1sQwvx9nJmOVEiv/Aa/ucLeRPMfwYRvFkeQ3CYZdHHkPsa8
         hIps3AN7kTG80mib7JGfu/GxCysMAyum7I8ujo5r2uWxPEfW8Dzm8lfc3wGOaZkoi87t
         /fMjjUvVjxoF8SZ5fRZyRZF5eNzJ82HzoHi62OtqFeb8avKB2Tl5ZNpbLCX+zZiuVFSi
         YRjnEN9j5dZSlle4Iwx+BoZ71FRRrP+9d3fLVvzMOmuKD5TmE2IsgUxBl3RcjV9E8+Tp
         c5yAS+dHXkCVpArIuhvpr01+uVn0bOZkZkNXB9F33TCHYxLHHBqaBkT5wAprlTXJtDYE
         vEsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756309151; x=1756913951;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JAnl4bFn7YJIAJ0z1R6sCpDav1qEAvuA37AHDZnUHrQ=;
        b=NDY2a3wFDy0GbNIhjWHp/Yz7NwPYLj6m3Ho9Q8lTGVfiK9MwKuf/nRc01MnpjNHqtE
         Ut/ubFgc43rJTokwUH1qFI31xUSrOKB0I2yZhJnIG4qN5M8u9fwKMwOuTCaZoy4lCs2r
         0OXkFoN+RyS3ARwO2txdqwBylRBB2Y0D0tfs90UCmMUIjDMcRK62eJxxVCNedt2zXSHg
         sC4JZvKWuY0HckSYW/aAOCqXU9zCnHq4TnirIKlClmqTcpVfKvgVqxlU74BaGdYaJ/51
         WU4JjXBypUe2axjShjMhON5y3k+hFhfR9uh3v2InctQ6kPhL+AO/myBEBAFV/K/PPJnX
         r1nw==
X-Forwarded-Encrypted: i=1; AJvYcCVAgMx1dhjl8DK2ZzAA0uwZAmyq0DABqhTpZrgNwofGmTJK+35nJQkooNwaOk8GCR0jgAh0+BN+NA==@kvack.org
X-Gm-Message-State: AOJu0Yw89qrF6KHIeOTZY346dlTyqOu/0nQM2QHR6ndPBPK/mJ6kGxI2
	mMj3sPnOZRDi6SpsrrJDNNWZvZYYB+OSsR3ubMQ/bSkIylUmorNLpJtq8i7YmrUXyqU73UXXhP9
	2kk9guFFj9zCPiQjZdHuyglupuduMPB5+Mhalzw3+0Q==
X-Gm-Gg: ASbGncsSTKp7Jv8BUi2zvXM0tJLpNVjlKTDpAlAK4iMn1NiTx2pOjZczCsQSP1UEqlT
	av5AKVkZzb7qHGoqKWi6OSinWwO+y6WtQdKd6WfYlDpjmwAvuQWo8yd3FPYwYCUt0mB/LFynZK0
	ARURUshYWl0/8pE0yqLf92DPyzq2d0ba25r1c2Fr/xNox7zFjGHG5RzGZWX2sWlMu+iObDHi4c1
	6tcQq1Y7tgmXJeuaopZOJYmVx+jORdhMro=
X-Google-Smtp-Source: AGHT+IGdZTnAyrn6Z1nHv93WNlDG10RZ+ZvGr0jvBPfBBuK4HkngyzikdQlggg44pAD9u9Bjt9B0ZaW9XCeU4ylDZhk=
X-Received: by 2002:a17:907:1c13:b0:afe:d62a:f04b with SMTP id
 a640c23a62f3a-afed62af6dbmr19395266b.3.1756309151468; Wed, 27 Aug 2025
 08:39:11 -0700 (PDT)
MIME-Version: 1.0
References: <2aa3f478-9c87-4102-b83e-bf235372d834@redhat.com>
 <20250827150330.280399-1-max.kellermann@ionos.com> <30f52bf5-ff37-4e22-ac57-7be0b03b1f51@lucifer.local>
In-Reply-To: <30f52bf5-ff37-4e22-ac57-7be0b03b1f51@lucifer.local>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 27 Aug 2025 17:38:59 +0200
X-Gm-Features: Ac12FXysXWZnAhbNSepM2Yi-H6asDq5I0w85BopTVtWfMwBbXkVe9E6qrywHqes
Message-ID: <CAKPOu+97BQs6Y_nJ4ONsciSb1=OC_jZ7s9W4ftN-Z378Q9cZ0w@mail.gmail.com>
Subject: Re: [PATCH v2] huge_mm.h: disallow is_huge_zero_folio(NULL)
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, chrisl@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E1ABA0013
X-Stat-Signature: ex9yomkmyygckmkf9ftbh755jf1hfin7
X-HE-Tag: 1756309152-293210
X-HE-Meta: U2FsdGVkX1+ghoo23cKerW5Gf9juXZEDQvOaCs7dsZGctfgLanBttCnDKG7NSGGin88btZigVTC9+1/iRIOwFqR9F8PUg0a4Pj+aqMEs6e+a64hMLRkQoRGqNo9dzibMiWL69YCji1A2HcVunULl/SS5t3P1lVf63Sy0qvlt9QSaI44znWXyysXgRMti5GtrWhdP9ytTyE/TG0wuSlhnB/c874vBKKafn7QvBykcAjCgXMokYrl+8W0kb/WimN0DILA4VcK9M+jMTp258QdZrVlEcG9y7X6193ZvxA9g8QDHECD6k/qjPLDA/oXnioRnuZv7caJauzLcdhAx6+mQ8dMIGkDnG2MZOh35kFC9aa8r4+ajYZrFXdk/IiEO49OLNlrnUUBygq1lVZt5gAm7rw8lA9oeUZikTXjlVYFlQXnMf9EGvDReyYfjBasfzUZXSVfQqewRMTU6aUGeOcQB4AxlCfQEqa/4IP2b3lP3KIE0aObZXphiP6pzQf5dwIeu1mSPJUQiVhrtAh5hrTjZZGoljnUGslKC+8TNhiTU6ODo44WapNPG8b0MBhkIY3/Xi2W2xNxA9sp5FgOjiyMGCAcQa9m5vBkLROPcrLEqz4t4l1AAL3JCVjjIGWOrS4xyJ1YLoGdoLDlfxxamY1f463aCNOMpkQwii0nL0cLiJ7oqENbF33QVtWq4k2qimzBg03ObSIewB8YqhqrdNU7VnRpzSWi0R3FABM/mXwE/RZwMr/Znx3Hvy4QVVOovk533wnfGFowfVvhdRTGO3A/2j7P1NCSfgpE9kr0D1TBMY9G6oZeysgHity1LyE2f4hOm7/7bVU/Js6VPnMCMsPt0l0R2kPcLVCeI+n3EhEe6MBrR0dK07qgKyLhRu0HGXKb1tgNlPelKhlEaS5q+CWvU576RPUXO2YvXoRsVBw5cDNW+76WPyYBuMSWC0vSA8btaz72bqVIfa9rZ4v0hor/
 HmvxVmhI
 9NqHmwDJrU2gTO0btaxQZLd8kK929NoVEEF7BS4KBto7+V2arx1TAy5FgwgxWd6pJqSMiPttMxe7ICTA5I3XS2Ns0Oz2I1y2RF+DmSH4asC80CzLp9M/CoObXyGteQewjcGBGma/d8q98kgCKHSFko1UrErJm/FrLkinmnH86VjPmfV2s2m29f+eQ3SwbdETp2Jy9+qKRpzXHOJ5M3ms3jx9MMvjAR5tUYUrp7qFDBFHTv2t8vOKkn6v5T6Wt2RgMNEeG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 5:21=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> > But if somebody really passes NULL, the function should not return
> > true - this isn't the huge zero folio after all!  However, if the
> > `huge_zero_folio` hasn't been allocated yet, it's NULL, and
> > is_huge_zero_folio(NULL) just happens to return true, which is a lie.
>
> Hmm seems like this is a bug under a bug. folio_put_refs() shouldn't be
> passed a folio batch of NULL's.

Agree! That was exactly my point - I was hunting down a bug that
sometimes caused folio_put_refs() to crash, but most of the time not
(when no zero huge page was allocated yet). And this randomness is
what I'd like to get rid of.

> Shouldn't we just put the VM_WARN_ON_ONCE() there?

Agree, but that was the 2/2 patch I dropped after David's objection.

> But I really don't think passing NULL to is_huge_zero_folio() is a valid
> enough situation to justify this?
>
> You've encountered a case where a bug caused folio_put_refs() to be calle=
d
> with an invalid parameter, then you're arbitrarily changing
> is_huge_zero_folio() so it would deref the folio and splat.

Actually, my v1 patch did not do that. Instead, it checked whether the
huge zero page was already allocated, in order to make
is_huge_zero_folio(NULL) to reliably return false, because NULL is not
the huge zero page. Then David disagreed and asked me to add
VM_WARN_ON_ONCE() instead.

> I really think the VM_WARN_ON_ONCE() should be in folios_put_refs() based
> on what you've said.

You only disagree with David, but not with me. I'm happy with either
way of dealing with this kind of bug/abuse.

> > +#include <linux/mmdebug.h> // for VM_WARN_ON_ONCE()
>
> Please don't do //.

In Linux-main, there are currently 432 comments documenting #include
lines. This is a pretty common coding style.

> This include is suspect though, huge_mm.h is included from mm.h and thus
> this very easily might break some arch that is weird about this stuff,
> because a ton of stuff includes mm.h including things that might absolute=
ly
> baulk at mmdebug.

What would you suggest doing instead, to make the VM_WARN_ON_ONCE()
macro available?

> I've had this kind of thing happen several times before.

I know, #includes in Linux are a big mess. A while ago, I tried to
help clean it up, but my effort was rejected by the kernel
maintainers. Which is a pity.

