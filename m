Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7578CA5FA3
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 21:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAE816B008C; Mon, 28 Sep 2026 17:24:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E867A6B0092; Mon, 28 Sep 2026 17:24:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D75C66B0093; Mon, 28 Sep 2026 17:24:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B1BD46B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:24:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F846C02AF
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:24:31 +0000 (UTC)
X-FDA: 85264449942.13.49C0EC5
Received: from mail-qk2-f40.google.com (mail-qk2-f40.google.com [74.125.230.232])
	by imf20.hostedemail.com (Postfix) with ESMTP id 555691C000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:24:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=njL+CZTM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.232 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790630669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VwmjfRX30qlLvfHkzdIlAW1deTn0e9Rmr1qO2nmwcHo=;
	b=0J4wJ05YT2FYHpwMra4SBe8W9WZupmBmBiNkVQUCy53y8uSPJdO3MpqBmR452USgrv25we
	XP//Atg9TACIhWuPU0uofSoxLtjSERTzuRLjDzBPrEfgn/bPNLWyGjpTLVsSUmutEAJkMd
	eCdUqN4ryUaPHzoJqMI7k7ZrmjWzOUQ=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=njL+CZTM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.232 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790630669;
	b=X7FfhBqrVq1FQUlUrXLslgSq1aZvLOktWFUGddwQIShFrKFFmEUH93Av40dDllbHTDJQGK
	oMdwGQjFgwAFv1JHV7GKIi6PM0yIwkpdv9UIetbvaJO0zbZVetOwKGZngEMUUrioJmDeZE
	8PRLIyEatf50W9ahdZfq9stn/bnVMlw=
Received: by mail-qk2-f40.google.com with SMTP id d75a77b69052e-533289b43ebso28414191cf.3
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 14:24:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790630668; cv=none;
        d=google.com; s=arc-20260327;
        b=RAeAmmDwOso6HpHCorwUxs6Bj+GfrK8X9ETBXqsU9Cd2LYk3J2ktS4Wu8XWHsDLw9D
         Ilmk3ahE+0m+79W9coLAp/l9rcWyPJopyvcaDjK5IcgDt27ekDCMEM3hM4UDwObruqRm
         QYiBcWPACQ6p6jfzzxVoPWDn/okIhhTpt7YVdfPQVkbqvQinfH6oyFaimcWWMtBDYTeC
         ZROHZH3Cg2UCAHNbPj7Mo9dvGGRlTNBUfuMxnnYgcGqdr//wORaf1ijnQjsfxduEjv2Q
         V3j8+Lddj32OvH0VVnbggdsk5leJC641OoGeOgLt4gto2M6Vl4UOAWJ9qsB4mukpfbL0
         MP3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=VwmjfRX30qlLvfHkzdIlAW1deTn0e9Rmr1qO2nmwcHo=;
        fh=LMPUPEE3PVmamfTP6w4kq2h/4z8aFASLeJ+9COKgr0U=;
        b=Avqj725g+FZDM2rrPsPogWSxqLPDEKPNJurYENd9yPITFAEFcu1QPE4qvQz/Cjru1p
         ezdkqKKK7IdxQHsHTrIKr3qAVFqcum+NyYdoXVh8fI1fHkFavhMKcljy8h1To2k+dSP/
         /OtpGFXy+g2faKCphv1uLSuif5hH6fKpiK1ZPkI1ilfa8G1ACB+Q3RVMT+3jPhZOcqVi
         BWNJFNBs1fe/o39lUkHLKraoKYxYWOzI57T3eV5YIKZSPSJamiO7NXdQx5DtY1olzpV4
         EmmzH3BFmQCZ9DRfYeqwYcmz085P4OMgLHo+UXVlSiW4giIQj+Yi5ZGW+OQ0X0CZOysu
         ZfDw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790630668; x=1791235468; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VwmjfRX30qlLvfHkzdIlAW1deTn0e9Rmr1qO2nmwcHo=;
        b=njL+CZTM7xqKlv1VTNckS8Y9g2ol67f/2xJABvoR+vaWSV5H5N5kt7TfCEor9NDRTe
         O1MkX3VyI5imqCSL0B94PZf6bjBQ8+NEvbJl2DH9f1zVqkEeTXfikjCeplQrKke4YFEY
         eVyYgSfEnlAltTzlI9ELyY2mBdEFG9KGx5wJQe5Hn9msrcBWvxKfDGvzt2Pi1np6K1pP
         lIom4m1VlonmrT5dVdJovrp0Q1jG/1GIlLx9jhBTeocKdzE16Uk627EtGF61mVi1ap8N
         O9oFuVhtAw5UxfRx/2toARUu1ul0tjeMRO3AyMh9Ja5qDjbkPzlLqFKq3hrkyjUNAeur
         9d8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790630668; x=1791235468;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VwmjfRX30qlLvfHkzdIlAW1deTn0e9Rmr1qO2nmwcHo=;
        b=XTH4Yu1ZAprdFpxScbxCu1p90Brey6FGU21UAqhSTky2DdMoxth8Bjf7LSxrFrU7Wo
         CmGRW+zmgWAu+xS2AD02dG/yJihCP3NA/q0lCYQQ9DhmUj9/+IcOKmaarPLQp2tHlXJW
         m6XBk2K8sosNMNavLHhfuA7G4fap1lwr/Wx9AjLzNXr8r72iTWcDt2/J8auaORiRb6Kw
         VVotlzPRiE7zNvZQ7PcpYLrLEqNcl93KKoegA/RGmujcBTr85aVclM3HgZTKMb53u8gE
         u3TkbVWMOg06q78F5L73U+ZpDrd0SuWV27GsA7hEWQ/8GMCG0TVH1iT+LmlFr3XLJMBB
         wceA==
X-Forwarded-Encrypted: i=1; AKwUvByzVQIFiu5kP18hjx01iul2LMltfyxY8Tdiw2VtyK9+7rGCb6cF45pUlAWpYzKJwKZD4DGJ4XYy9g==@kvack.org
X-Gm-Message-State: AFuF++n7nBpqK4/QM0plUChwshbyPGDrIaYxF2YzwSfn1erjuD7FcI9M
	wP6WTt85BShFrX2cubYhjYqG5ShUjW1IYH4xiwZNgrdsPJMExMvnXb9cjDM/wi8wjKaHP6zp/fh
	0eYuu0AlNXXQwtjqEhnKpQEGgCbYTSJtVq387eDxg
X-Gm-Gg: AYBFou06F0RUHHTReBfRMIG8ihCSfZb/IKoQ8yHhwKfWlFlBXi84lorpjUqpGxNpg1f
	qU+giHhnSMcz/AEh6BVRT26nZv3hTKOwvkHOebm2BdS8cIbievGoe+H7v6Ii8rIR5jb8aAODz7T
	GmxvQcArfyphFWa66tX1dhVlKsgCOEEwGqirBd07+BYMELJ5rrfXFvWkBuex5Ez60r4NjXBOmBp
	3L+9XVCqY777JsuBHAOU1KLtQ6tDIhxsHVKcSiABwtUD5IIFxgw+kSs+W5ivC6N9v6upO+LotqR
	XbcegGBri3bOkvntUdkDu/IwYU4B6Aj1+uSGHGpqF5Tyzwe/3IaOzl8HMkoVihzDsQpWqxAblzW
	iPmt9+NHyFSDgR7QX5u8knoW11pH72rJSQjlJGO+A5w==
X-Received: by 2002:a05:6214:2c08:b0:910:6d8f:a2b0 with SMTP id
 6a1803df08f44-9142f78af11mr227967976d6.31.1790630667515; Mon, 28 Sep 2026
 14:24:27 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 28 Sep 2026 14:24:26 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 28 Sep 2026 14:24:26 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260825090827.64550-1-iprintercanon@gmail.com>
References: <20251117224701.1279139-1-ackerleytng@google.com>
 <20260824194755.216000-1-iprintercanon@gmail.com> <aoyqIBz1EoY0R8qw@casper.infradead.org>
 <b682a12f-ac03-4032-851a-f4f7ced4ffa0@kernel.org> <20260825090827.64550-1-iprintercanon@gmail.com>
MIME-Version: 1.0
Date: Mon, 28 Sep 2026 14:24:26 -0700
X-Gm-Features: AclHuK-TDRyZzfWZa_wtY0yn_v3V9XO6Vja5ihTxfsBMk6gZzeWu994aItDlqUM
Message-ID: <CAEvNRgEQdasV3i4xcs6WCgrOjxDvrZWHqaPa6OVKqShW9iOQxw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] Extend xas_split* to support splitting
 arbitrarily large entries
To: Artem Lytkin <iprintercanon@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>, Kiryl Shutsemau <kas@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: c5mhnokbzh5b7ostt7qyaxtbxwh8r73t
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 555691C000B
X-HE-Tag: 1790630669-16915
X-HE-Meta: U2FsdGVkX19wqcQ5/M3p8J0tgoFm8++VTSuM8Wh+gsNkcVu4hfD1/EAl7gYuits4W4Fgc8POkrz9UhyaZodOKrJ1d0JujebBa0y2V699VwdqTWFCX/j78dJgeuXtn2vs1awNUIYnWzRRIYJQXHcoHeB3Y4fiHYEkH79cthBEhBKpkokbWy3yWAZ4k6Ch+/QrtrORdBmdJEvixXj2Q4UDHwI+vC4cRJNOueOplJOkkZNX1FKhVFH2wz3C5NMh80qHuydknV4+kbDofZg6tTm0ca3yXeQ26CYf/LikJ4jq2JPVhOePsw5oXpR2j1U1fIGnK+7/+lFkEU3kxl6UuLIL74gLdLNdYlNLDjoCF1TcGyZh0YayL8kxETgsDPA4UZ0KoAwkX9hqbtDJbd15hhURT/azSXNnkpFW+weSiqLSukqkYB9UL4Lz0+QhfD7uDM27YwaWU6qDFRFUpIjHOTTlrb71IYd9g9Zi7UJBPn3UkH8F9CJmw03wgAjBbphef2i5kquGALelkO/+2pVSGskg1o1uUtD1u/o6CrohfccQHQSEbd/6Z/HabPG1obp6rIoHPDN2bkZnweNyfBYiWME6cw/niOq0/vY4qMY1Q7PzMEsxe5bAnOa8ws81siFM8jxhaNZ0c+DyghaFc4etL9OpF0fJtrrvdwEOobWJOkjixTZ750o0bJwk7kPHkQGdUUU6pA2UFgMq5mpoAAJD7AQ4CIlCD6HXDBuY02fCnqXGdsT8hjdhV/He/CQzHjyy2NfD78HGLcbodit/5ETum9d6Y9pOjxLzMKYPUojI10aIqpoWzSZVwLLv4ds8enN1dGkNVvJo1U7vhvPgyQLtmyR06OtjiJWCD17nHXfYd+f8M/RGnnFBRW1TrGiq34eMsiFmUSCqAKsJed9mwUtL8mIiOKy0oDCrjK4rLYmwfK2GE8VNpe7fQ0u45nTdQDnuUTW6U+gmeGrwuJJquxJtqv8
 mvbuQEQc
 yD2AWVmISVa1vBNxOA58N8Fg2fTltO/LLaS3/34QHUdgqbS1Zr4KNSivZgBhuW7u29nuaI/TpT2njd1WACgzfMajf2KVjeywAsAPXBSy7OpEnZA+SY81oROd51LlCYkgSeNmt2UU2qmWtH+bzSQNS5hkjw4TGWdRYO5nhVU/P7jDI7ajBhg4RGX+9qbczr00O58dWeDVkDLP3ZIw6d06YpWAP384I1mL6KTip65HjhvZ5R4GV05l5kSiYN/l7huH2PSvAicErcLmYW1BIc/JTILc0Qx9YwW2k+3XfvO6EiDU8VaSfoi8JogqPD1JJayMGblZujvFnevQH8mg6U1nwdpbeafmHk7SFpBSVYNWpVcp+5wo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Artem Lytkin <iprintercanon@gmail.com> writes:

> On Tue, Aug 25, 2026 at 10:31:34AM +0200, David Hildenbrand (Arm) wrote:
>> > IOW is this driven by a real need, or just some completionist thing?
>>
>> I heard some use cases using 512M THPs on arm64 to back VMs, but it's mostly
>> anon pages, and not really ordinary pagecache.
>
> No real need on my side. I took the pagemap.h comment and the selftest
> skips as an invitation, and the one 64K user I can find on the list
> (Meta, in Kiryl's collapse RFC) says mTHP is what they want. Dropping
> the arm64 angle.
>
>> But a buddy-like split is clearly preferable. (or avoiding splitting in the
>> first place :) )
>
> That path exists as xas_try_split(). What's left is the uniform split to
> order 0 that __folio_split() still does through xas_split_alloc(), and
> the only one asking for it past order 11 is guest_memfd. That's
> Ackerley's call; if he wants the rebase I'll do the mechanical part.
>
> Artem

Thanks for the interest, for now my plan is to figure out some other
ways of handling this, like the buddy-like split. guest_memfd has quite
a lot to go before we get to this stage requiring the xarray changes
too, so I'll defer this till later :)

