Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 469CCD1CDC6
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 12:24:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D71C6B0005; Sun,  7 Dec 2025 07:24:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6875B6B000C; Sun,  7 Dec 2025 07:24:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59DC06B000D; Sun,  7 Dec 2025 07:24:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 47C976B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 07:24:50 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E26A6590D8
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 12:24:49 +0000 (UTC)
X-FDA: 84192593898.06.174738E
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id ECACAC0007
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 12:24:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fqmF0hTR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of nadav.amit@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nadav.amit@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765110288; a=rsa-sha256;
	cv=none;
	b=taC4abgNbfTz9x/lv3qoXz4KffbQ51RbjTYR95ob3+gN/xQRia4iuNW5tl5+/szLsVjS+F
	cDB+lJSOsawKLUPjeRqq2sKIl3a3D3O3wdmgZVE9UHSNyqYTmnKDGRvb9h1h+ZYBHIhCnn
	8Crrb+HXZyLSyXf4ehn2aFJ1bDOhCZo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fqmF0hTR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of nadav.amit@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nadav.amit@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765110288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fl1kkKhpVPyl0p4GnJfcedu4IBpEFqXBvrIdqh+PkaI=;
	b=XuOI/HjhF2OmlPLNjsos1KeQePpLYFVn2E8ffP24XL6w+oVqfucEFyPOB+g2b6CALElRop
	wG4li+OpAM9B+Nb2sE8GyXh7g+E5PlgZm5kQw6eH4b80uIMs2utBvL3hVbWy3gQh0/RlFO
	qKhH6vXO8EpExOBXdOOrerkY5HWedbc=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47778b23f64so22015645e9.0
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 04:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765110286; x=1765715086; darn=kvack.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fl1kkKhpVPyl0p4GnJfcedu4IBpEFqXBvrIdqh+PkaI=;
        b=fqmF0hTRx1eLbucr/peHr8jCnBVn7eVw5nBDxcC25ezFkgFO6N1y0YZMc28DhuEHKm
         loZprh7R6Wgt7KV1gKtmCQ1jd2r7PjSMdHs8aGXHbmXBWo50Fmr8kG/PdVOTuuUqdc+O
         3hBPpBGlittezvwx6TTT9eb0QJRVaVIEIPXPtSFlqQuYtklmAMIa+Gik3U+PHTJv9lvo
         2BidRqt2h+8/+KdOYAgwP6CeVwE1KhlDyX34DepcMwBVu9PLIxvDhosmBTfS35Xd/Q8S
         cedccDPCqCkFFLekvjpD9yrFnD/bD8vOozVZx+VwiCQtG5BX2hPftnjJD+DKnqtfXWjV
         NKiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765110286; x=1765715086;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fl1kkKhpVPyl0p4GnJfcedu4IBpEFqXBvrIdqh+PkaI=;
        b=Eg7x57HGE8Yt3Us4D0OdOKTVp6GzgZNIma5lW9p61tEeIWYMC+0qqe1+CwPZbnlWNo
         PNYQmGH24eilPIN7GR+MI00vdnoP193rc3hD2oBoe6ZorHdtH+MRtm3kIBJEWsZgK+g6
         tEBpwi/Jiu25MN4wxlJOeSsU+UML06R34sYTz6UZkucrBW36pZfO5Mi/S566gUCNQm4A
         5KEbVJJx5JQ1sjJCqiQj1G8Hx1rRMH9CBg9SfoNafsOiL75AU6KxZQNnwcolI4TspHON
         sGTKx92BIrg+XafZ+af8XbaA5zd0qSjgzdWn7kYpR3lCq3ge23H3GaNU4YOcse5vdTfg
         7CQw==
X-Forwarded-Encrypted: i=1; AJvYcCUX6O/Oz17ticLPzbfqRFnbIiOKVz1sOHGbiYc894nIlg8SEzVCHnI/2uhyFXll0+2+DfZiuJylHQ==@kvack.org
X-Gm-Message-State: AOJu0YwJCK3m0bBmCKu/Fgy81e6Etd+trOLl2I4UWW1ULbJO4k5cE0t+
	DJVQhbH7P76wtMVWNSMjb40JyyMn2+acJfRYkPHjYCnSYFZQEkJfwQu42QwgI6cFti8=
X-Gm-Gg: ASbGncv8/jyOlFfv2UGFMjWPQg1LyHC3KOF6Q1LCRiHG53pT1Qj1hVNEYeyJUxsR3cs
	hcMJrF9b3Ji1iUNisRp8n08tsU/LsXxmuASRzTwy/s+LMTk/JGEEBHtUMkRqXIvzF44FZ2LC/0l
	m5IEeUah3iDYFlhQ6BMVivT/SPCO+9fjSAfTAWPCf3RQpCNwoa+dOKA87Pj8UgD9RndOIkcwmlK
	7C+GZX/Elo4NFaAo5WcPzXseOasUgKX0a/zV7TSyin56J8app/ZCGXbsjrn2syxF3wxWmmrSYeD
	ragEfFoMm5xTFhS4QT1sB385+8Md9pgisGgHPV56fNIOz+GJMtWmWlBCsFzfBloKyAfiL/MTL6B
	iKKTRTr7mtToHmsp1sfXg6/OdJ6Ka07aDa36uJmPK0KiqzsCMpsphsEABGtddM2TY/UOzKyQOOC
	UxgcXjvoTTTg0f4HtcmdVV5wIokf42kCqGADiLOItv6A==
X-Google-Smtp-Source: AGHT+IFYNytRWOoRWAn3wuIAxlT2l9Sf9Gj3BBpCG6lKrrYKjNp1jrrzXLs8UNkcqC+phor02o5mjQ==
X-Received: by 2002:a05:600c:19cf:b0:46e:4586:57e4 with SMTP id 5b1f17b1804b1-47939e3a6c6mr53136075e9.24.1765110286247;
        Sun, 07 Dec 2025 04:24:46 -0800 (PST)
Received: from smtpclient.apple ([212.59.70.42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47933aef61fsm148718095e9.7.2025.12.07.04.24.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Dec 2025 04:24:44 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCH v1 4/4] mm/hugetlb: fix excessive IPI broadcasts when
 unsharing PMD tables using mmu_gather
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <0914A8DB-447C-4E62-B151-62E5E4E99749@gmail.com>
Date: Sun, 7 Dec 2025 14:24:32 +0200
Cc: linux-kernel@vger.kernel.org,
 linux-arch@vger.kernel.org,
 linux-mm@kvack.org,
 Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>,
 Laurence Oberman <loberman@redhat.com>,
 Prakash Sangappa <prakash.sangappa@oracle.com>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C9D5EFFF-05D9-435C-96C1-4B13134E2904@gmail.com>
References: <20251205213558.2980480-1-david@kernel.org>
 <20251205213558.2980480-5-david@kernel.org>
 <0914A8DB-447C-4E62-B151-62E5E4E99749@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
X-Mailer: Apple Mail (2.3864.200.81.1.6)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ECACAC0007
X-Stat-Signature: wm3hm8dpyouascocmqg691w6wnd57h8b
X-Rspam-User: 
X-HE-Tag: 1765110287-307096
X-HE-Meta: U2FsdGVkX18GRSA2YCOpB/xnNnjh8ZZlYUuoUB7HV3sALFv5Axjwf4PqxgsURjxmgPX3hKnmS372TN2eltb6f5XblYJWBMOOfCe0IIyzWPCCM3CxSmd80vZHmMdVmKjvtYE5mWfRuCMiwgdbC5MaHvOMAtU7QgkN945EZvEVEU1C8zWF3sf+G2ID+j0YmUu4AM5ZpUdq/NnIHdxoDTZ1rh2hv/AW5JqpXGPKEpA1IsVHOLg2IVa9QZdJrP4tD+F1poo6ApFjDfB9FxJ4hrIRRLQuTU/wRS5SYUN4OiEbLgd/87ZER8SfQWIp7hg5RvRDSvVM3To2XUA+4G0bdEz4nASf+S5i0Hn+/+eeUFEFuEQ49QMNcns032SDAAhkIPDjdTKBC3fpTdxsQWj5yYFAawn5dJXZTJhqX9D4ZoqgrOsTHTopzlQP3yutqnZgRAGAbpOQ6kpjdZ0x7Z0PxsqsD7HnB2hWLgEMbEk1en0cGFjCxvG114AGsJVsXr9z3eKjeASp5Z5HC/BpMYYIscLqV1NBmyzUM+wKVX4+rcxxuEDzCruKPsC3sVFxBf5PE+Df9uMswCCCCQ5LC8L+cyDGMlheO/7Ggbo8S/8yY/7A4zbApI89iKCowOU8d2TGzCeaPxF+nmKIjIH6svBh9ck6RLre47SxgXufMLgOc/80J6xaLdr8zBs4aEGmDHH3qTweEND9Qe/dCtSCzyv6/tOcTrjqJRIzKS+lLw4WmsjYNKPAzNiKTqX0AyS4nPixMdBfRGCoeY3wMv+mh2zJJHqlzu5/WkM5aD7iBHbPv2mSHS0Wx5FB4Xyy7nWfE1pm+oajmfLC+eQ+beY75CSJxLddGLab7/vzDR2Q5IuD0QSSsqFXV1fNcl8z2RtSD01s/hqk7tUP1d14o0ON5IeRtyQ2p9BNZn8dQuvj1X/vG5X+vfceEIAtiSsfDBcZmqmy++DPZPvid4TrghNFRA2PDgB
 4g5b9vZv
 AA27+ABbRPWLg82BUAWEvGcR7r43IMyBYIt5F9V3xBagh4O/Cu5KGiG95ACvx0thWzsHxWnyBENCFqQDdUkPBSDc0uJgvbZ7PVAqPZBZy/9y8p0RR/ozNkkcPNS18qr5VdkxQpK8BNzyV5AhPi03+SNPc9DmJB0GwrQQ8yfK9MshRAI11Nam0+iYJq5m/FU9jvM9oiTswCWiH7tdvQc1aaos6IWEql2vRUMpUvjcRHrOptdou/qYu8n8IyJ6ZTTasNjySDWeChGSYh6rqKduTTLznNYivl3/tppbw+JGnW5WeKPyeFDipPDC0GxHvtoCmkRaW4kHnyAvG92s8N0B/68FBt8XYOWmqycoHglMfjV++LtnlRT1fixem6Nw3ZwmFxnPL6DHJGIZAsVuhTmgsJi2Sm0nYeVEzjMEg5uyvcegzSCb2KG5Z6xlBplQdlRiOv7ur0qxFa5cWRQeDbklat/Wy54EhjSaunynA5BX5IAMnN76xEN0L7xRwyzwu2kfuFiE6VGS1klciQOnRDDdxUBzBKx2GFyzHhOhjdcW9yVApUGrxWap6DmJiVcoL4akqlXrfJQMwQG0g9tI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On 7 Dec 2025, at 14:15, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
>=20
>> On 5 Dec 2025, at 23:35, David Hildenbrand (Red Hat) =
<david@kernel.org> wrote:
>>=20
>> @@ -400,6 +411,7 @@ static inline void __tlb_reset_range(struct =
mmu_gather *tlb)
>>=20
>=20
> @@ -400,6 +411,7 @@ static inline void __tlb_reset_range(struct =
mmu_gather *tlb)
> 	tlb->cleared_pmds =3D 0;
> 	tlb->cleared_puds =3D 0;
> 	tlb->cleared_p4ds =3D 0;
> +	tlb->unshared_tables =3D 0;
> 	/*
> 	 * Do not reset mmu_gather::vma_* fields here, we do not
> 	 * call into tlb_start_vma() again to set them if there is an
>=20
> I understand you don=E2=80=99t want to initialize =
fully_unshared_tables here, but
> tlb_gather_mmu() needs to happen somewhere. So you probably want it to
> take place in tlb_gather_mmu(), no?

To clarify my messed up response: the code needs to initialize =
fully_unshared_tables
somewhere during tlb_gather_mmu() invocation.



