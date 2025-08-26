Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B25D7CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 11:15:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D58E38E00CC; Tue, 26 Aug 2025 07:15:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30718E00A8; Tue, 26 Aug 2025 07:15:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6D6A8E00CC; Tue, 26 Aug 2025 07:15:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4A708E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:15:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 673F95B40A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:15:03 +0000 (UTC)
X-FDA: 83818651686.13.0462AD7
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id 93D94120006
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:15:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ypKryOtx;
	spf=pass (imf29.hostedemail.com: domain of matteorizzo@google.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=matteorizzo@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756206901; a=rsa-sha256;
	cv=none;
	b=Eu4Dnc6IRlWKvpQ358dpinNdrg3O64Fzzs95+/S4NbAlHXquy4oMShG7a8uL5G3Qj3TrNQ
	tIbhjAmmR+m8J+2zdwZFdl0C/A94Tfss7OGiMqzWzvZfmco58JHlYlX4+Pjl3Zi0C3NjV3
	JdmdMdQf4vrfRcvqRrEZV+yVoQh13YA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ypKryOtx;
	spf=pass (imf29.hostedemail.com: domain of matteorizzo@google.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=matteorizzo@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756206901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yNKW1svPWQYfwzN+Mwhz8LUQicThZsVtWpSBP88B/Xg=;
	b=jzCx4cnx+QAewD0DT9iF5mp4nrIvTDNsU2qtoOE7ZtRyC4PmR1HvX1FAQrDFG52wVReppR
	jB1l+T6B5TRLgwqa4IBuvf0bN+ndVYChan5K0N11JzbiEgr4ZMpOcCD0S1D2wNXLfmLHgh
	cE9V6f4l47iRBBPnv+FhWzU8/VmM+Oc=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-70ddab8117cso310996d6.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756206900; x=1756811700; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yNKW1svPWQYfwzN+Mwhz8LUQicThZsVtWpSBP88B/Xg=;
        b=ypKryOtx7IpfjQ9CHzSM5/LhTsxayWaW5M7QRN53JKhUzWGpnKouBFGWSsxYQOR6Qx
         3oL2QM1AAqfmSva61hnPXi7mDNkILy9o9K0mydqm43p0zr6qSuJDWk4t8hlIdUBNJfTS
         pQw+sfuZhiEc5Ka+eOPnqD1oHZW1sPYYY8rHPjWZ7UgX/QuA4cuaGPXB4ovip/syiuyb
         dPMjF0qQn3H8hNyzXvCoplE6R9BMYkeTWYBWGZJxhUHN03N0yEPYfxWi2tFoWphIhP0y
         vyZAZ7LXSQXLhHLrEsDTtXqppmbcZyycrRkrjFhi1DzlbPfLOX4cmTwXaB++21JUDEyR
         Z9+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756206901; x=1756811701;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yNKW1svPWQYfwzN+Mwhz8LUQicThZsVtWpSBP88B/Xg=;
        b=B0gkkOd5Qnasn7XMQ746Y3p0E4o2fNITmZm81zv0Ls4BxFS0ChmxiQlLXQFd16ps78
         Xpzr4sXDprvpoPInMs5FGFOMux/IMP5nSxVtf4a/+PSSaO/WXL7uS9FWE5J4Kn5Vway9
         YfaqxXPxIATYoBUwYJGqIp/GFra7ZWs4VkzxRTWrl/sBJVTQ6vES6ghbIZsjJwEdjPz7
         u+BHaukf0pgeDuxHNfD9+C2Djfe/Lyq7kdDc3DRUEINGDtMnhm3asZW7crVGzWHWGCn2
         0IAnzp/W7a1Wv1aWcthK5YebeU+UhstwsymSNYr70QcINoy5Dr1SlL2wpw/2RH7x1ERr
         5OLA==
X-Forwarded-Encrypted: i=1; AJvYcCVBwOQJVmzFVM3hAqXBbnsrhiHw1Hn3e6xai60qDQFSM+m954iSuB+IWgufrHhHFEbheivgNBfJ4w==@kvack.org
X-Gm-Message-State: AOJu0Yx13+pQza8DAcKUbvDCrfLRX2fRpGYFXovckq9l/aW2iSKZOXy3
	uNlFrPrloHB5KFZeduA2yD4n60/iwFa0uMEaoDS3GstYWzYNKQl74T+9B1iPitxBdH4P2v4Q0//
	51/X5Cbk+/FUpJevlu49MjWOVyjJO2xK5FPBDPwzD
X-Gm-Gg: ASbGncsrgbmwMbOLuRyGzvH+OpJ0kJZFgu6THRwQvqWBs34gndyJTqPJZ/6v30P1Mmt
	BN5ib3hpYGCgkejvCKKzGRLfG3bT6+Z67R5uGeoF841q9qIlRr6wqsbRdAseGhg2uhnzIjcSf8c
	4NGW1i+VUh+a9bTMsZuq9HD9OentEOF2vGY5aBRRxaU2r2ZDPdwq87dLlc0BTPjVHbBSybx/eyJ
	TEhwJV6+rkm2ne3T0O+a3Vrtg5us3oA53HbKrtKTb0cGMCa8JYhqq0=
X-Google-Smtp-Source: AGHT+IGipSwQ9H+9lir4i7sthp7jXgbze4rk/DAEYQJrO9h7c1f6+7P3RPCSiB/lbUAJre41WiVi6jclfFNB3YTBRpg=
X-Received: by 2002:a05:6214:20e6:b0:70d:8665:3c5b with SMTP id
 6a1803df08f44-70d970b2b0dmr209892786d6.12.1756206899995; Tue, 26 Aug 2025
 04:14:59 -0700 (PDT)
MIME-Version: 1.0
References: <20250825154505.1558444-1-elver@google.com> <aKyT2UKmlznvN2jv@hyeyoo>
In-Reply-To: <aKyT2UKmlznvN2jv@hyeyoo>
From: Matteo Rizzo <matteorizzo@google.com>
Date: Tue, 26 Aug 2025 13:14:48 +0200
X-Gm-Features: Ac12FXyU3fT-SuKRuDR_nD8uSQNd7DGjj8J1BVXdXRtps1xhjblio7NMt2GtdbY
Message-ID: <CAHKB1wKZmp2Rpw0zry70i16-c3FVkwtb3-XpLs5P1s4eABDD=A@mail.gmail.com>
Subject: Re: [PATCH RFC] slab: support for compiler-assisted type-based slab
 cache partitioning
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Marco Elver <elver@google.com>, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Alexander Potapenko <glider@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andrey Konovalov <andreyknvl@gmail.com>, 
	David Hildenbrand <david@redhat.com>, David Rientjes <rientjes@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Florent Revest <revest@google.com>, 
	GONG Ruiqi <gongruiqi@huaweicloud.com>, Jann Horn <jannh@google.com>, 
	Kees Cook <kees@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, linux-hardening@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 93D94120006
X-Stat-Signature: q3mqkkryq8p9un46zd8uxrrdrd59s13b
X-Rspam-User: 
X-HE-Tag: 1756206901-236093
X-HE-Meta: U2FsdGVkX19EGsKk55ws1+AdxCDkIoLkV2Z1XwNRRAEm4clAKr9czh7Hg0fuvK1KIDjER7mt+nn2SQmEoiERuovqmOBLa9zOMThyCgd9lJMF3OZ90C/tdaxoYIoD3ufhiaVzA6dnhQpopUJ6GHgZQy1SHzB4syoAd09qk2+6zCeNVgs1qvR5LGJaNzbTCQ+mjxfYcvVS3K6EFdEnGeIpsbdK4cY9oDvIFWf0e/OhzO/qKHeT306iP5YaN32tkk/poIao/+8l6IrIL81OGAajQQ270UwFNrJPxWuy599X2FvQTfJDgs5LcUydxtQkq1A3W98t2eP0OGytSzyhcxleZlWk5FXv2IlJQT5v4AXyxYBCWtDXHj/UzcLYj+AuqfbrIuZJaot6e2Ryk2Gk+iglntZed7P3TPWCK5i8Ys1JJybSM+k2eanMj6F/p90oWUz1IcG5mGHxjmPwsO1wpi4He48a2WSFkka8/7kFZ3ZgaNOTtjujeGDKGjnu5EP91UjNi8DFpMyJm8QbvdOXSy3IXkqcMYWlqbgFRywZKxR9npgQ68FEzBhIEE/FzwIsB1NtCaQdLQszhUv/4OPXao+gUZPhiFx1zcjiSBIehLxTqSvAoABw8NahUWY6LPLv1F5+8EOoXdwINj455oGf3uN94FoAzbnx645ZmM2donBUyJNPICfMRhGTzqEkVjDiZxppXnliI8Q2OPXHUHouOFHRAFvxgTirGbhV63T49QNrVDQd/PXLWtVVEaRj1nSQgOlvETxcyYZXGt9GUTNYi0EPK2m+IW48E8NMYaAcFO5y7gpjQSCLy41u3apVcp+SfysB2oUTBtsUGkZJladn9tl/ZTMvEUpLfWqU9DFfnlZPF4dXrO0PE3Sa+8lx7ZSHSTHcRq2sUsAiEZICUw4YtrVbCqRHrwJIbGPrElSLa4HByEWgKIqxApMIxnxwRYKwi0zw8azy3YKr0373UrZnPY0
 xaKYMvVw
 Qv7bF8VsrpbH5KZZgIhrgduj2JVph8ZlZfqt0J2IrmMotA1JBc7WGIj4HWjytUQaw3Ce2bpYHAX+7KReIBSc8jKlJEd5ZO69mz1K33uYkko/p3O1bx7Gl2HCZoj09JcxIk88OyaJur0weEdvcBLWlgcz9drBVgBkYHPuynatBI4cJNP7EnuspD9/LHlrXJ5322xSHtDhDzx1zuLzf14uq4vZfXFnLZ60WZoYo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 Aug 2025 at 18:49, Harry Yoo <harry.yoo@oracle.com> wrote:
>
> Not relevant to this patch, but just wondering if there are
> any plans for SLAB_VIRTUAL?

I'm still working on it, I hope to submit a new version upstream soon.
There are a few issues with the current version (mainly virtual memory
exhaustion) that I would like to solve first.

Matteo

