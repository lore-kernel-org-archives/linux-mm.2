Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97349CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:26:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB6CB8E0014; Mon,  1 Sep 2025 04:26:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8EDA8E0002; Mon,  1 Sep 2025 04:26:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCB738E0014; Mon,  1 Sep 2025 04:26:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C94008E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:26:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 71C395B229
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:26:40 +0000 (UTC)
X-FDA: 83840000160.02.4E41171
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3B3D340008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:26:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=BAmcjtgZ;
	spf=pass (imf07.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756715198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Py4aYMpGJ+Qx0hCoeF6vFBXKDSrOB/Gzs4Mv6AoSQ7g=;
	b=p7mPRfAS6z0sMLlZnyPjZ1Pw9aipWGVRmnudiPwRSrPgZYduhEvCTLvn24u2kuU0VA5l4B
	OjroTS9jUmNUG+jY24Vv6XZJB9rtHibibV2xxV6n2HKxyhF/svIJ+FmuvaNdBe7zMR2hbn
	vlr7DuI3619bjG7O4qwMEDCqfaYgM4Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=BAmcjtgZ;
	spf=pass (imf07.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756715198; a=rsa-sha256;
	cv=none;
	b=veUohm0dT6iAeOvkz+q6kCKwQvK3EkPsvmIfI4OY1yvUtAzu3IpLEIoJQJ5eCbqwVuSpdB
	tHmqmU9CAFqG++iz4t4TiOHZZb1xamOuhOMqSS9nNpUw3D9Q418RLdmhW+KRef+bOeOoui
	Zzz0R14WCE2xcVfoYKkTKFwidIh0MfI=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-61cf429f4c2so6812730a12.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 01:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756715197; x=1757319997; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Py4aYMpGJ+Qx0hCoeF6vFBXKDSrOB/Gzs4Mv6AoSQ7g=;
        b=BAmcjtgZokaWzPypKkoGxzZrhSJk2uVKskzrkajyfYT87IyhSJONhQHekMqx/DDUOb
         ZJ6n85ftjAcpG5Mgd7J7s93+myh+bix/OKxt/k8PFWRsIcW4C0KE3EorvMkDngkKVsww
         P99MMlfYt4QbHyskYHPSVFczTPsrccmJNKxemFSt2/TuhlYS5HOSQXX/wM9ll9sxz4kH
         l2Xn2sIqL6XUnrtlPKYqdh4DRaX7ueNUE9n5gQdUhBORoj+XqAZb45ynMzy1xUNEWJLK
         dHIkdEhOwkc0TiS7Dzb9Kj6XwR1AEtgy8kS/psOWV1k8lnvyXbMS+xPQH1xjBIhn5suc
         I2CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756715197; x=1757319997;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Py4aYMpGJ+Qx0hCoeF6vFBXKDSrOB/Gzs4Mv6AoSQ7g=;
        b=WLqcPdeLkeqGQdYyjVNUZpeCW0eJjeNvLobHZ2wPZ7Gwq3m1mJ1GNLzTiVwUZgy5y1
         aiVuuQOxImB3SuGkB/D3p4HFBURpvqFW/5Dw6QroSoVPApQQktpa5L5xiYcWAS2ZkD5U
         72gkz3ajq67OnC+lFuNEXG94Um+oeUOaKevehZbg92iXtD9tYlBth4G4v7iziqg+P1wk
         vUL6/iJK8FM7rymqAfXWke9jAzT0AK3L9CsgB/v9dNUwzq59p3PDaOrtt83Dptf42JEu
         bmuVIryRXg25KVlRqHtdTvf0UQK5Migxd9Jsbrug7IxxofQ3YddIeEc5wCEIh+QS9ma3
         UkpA==
X-Forwarded-Encrypted: i=1; AJvYcCW4io+2nk3cS2/hKFxepShyArlgT2Toof8nOVqzGwp3CeiqEzCe7Y3Z+4xZpp7PKTyFt0OZmfqWbg==@kvack.org
X-Gm-Message-State: AOJu0Ywsci2cd5345zhwYQ8n0HS0zZ2HiH+uVxN229FganIP+dRxWVAK
	Ce5ssytNam/c/SB7HcLFC7wOatL8oboAici0zvEGoj1DXt6OgcilWWkuIMfGoH8yVgBRyGaXpB/
	IVIn5Juqc3Zlnxde3YVgce/iptkFG5ZdqyLAUi0lKsw==
X-Gm-Gg: ASbGncv/OiD5Oe7musbJGx8rY2+lqirYjVlwqMvGrGa+GBLCSfDcvdfFGqFeLuwukeS
	Z64c6O7Tre6vZj0eNJV5FmCba682d2oQjIIfLpxWvwzcc/RGeC06dcHbWs8vWYNqqhUHlooXWf7
	WsEcFnjvwiU4xNUoZjuAEO01qEEiJgF6qiN1vujVbs9nL9NaVKiEQKHEcr34h6umRIraomAVVUC
	7tebIEiWcsLdiF0ptnT7r0OQknMvsCUgc0qS5iIJA1ZkQ==
X-Google-Smtp-Source: AGHT+IGXI2msCnx78Su15PAuWs0lHjk7inVPkR/r276bsxb/xC5chRSN2HXFSJE+JAHHxBRmUSvk6/k36E+wpO629AI=
X-Received: by 2002:a17:906:f5a2:b0:b04:3955:10e2 with SMTP id
 a640c23a62f3a-b0439551a93mr112117066b.25.1756715196549; Mon, 01 Sep 2025
 01:26:36 -0700 (PDT)
MIME-Version: 1.0
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
 <20250831093918.2815332-2-max.kellermann@ionos.com> <day257vhz3o7hepucfz5itjvdtp2k36hkqdg7hckqleb4jxyku@rs4rs3zhl4hn>
 <CAKPOu+-ZjNr9hEir8H=C5C9ZwbS7ynY4PrJuvnxa-V425A+U3Q@mail.gmail.com> <e3ec5583-adf0-44c3-99c9-5a388c43fb7d@redhat.com>
In-Reply-To: <e3ec5583-adf0-44c3-99c9-5a388c43fb7d@redhat.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 1 Sep 2025 10:26:24 +0200
X-Gm-Features: Ac12FXylcJi3zihZv-FAs1g-1p6_jPE5gFpeWtm5gKkpVFqz2VdwhTrMBi47B6E
Message-ID: <CAKPOu+9CiT-5P--6TZcyq=jHLDhCa8LDh1AYjKr69+0shO8UrQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] mm/shmem: add `const` to lots of pointer parameters
To: David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org, 
	axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org, 
	hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3B3D340008
X-Stat-Signature: epzdoeo1a491x1eypk9ygxr76tp91w18
X-Rspam-User: 
X-HE-Tag: 1756715197-39484
X-HE-Meta: U2FsdGVkX1+qotOayT+0MzerMjWpBB4Es88u+OONA6uNmwJZTeOlZfBQDqBK6ulMSSFtZ+CR/nUs114RLWzLbnupFaSJbNBji/2+MsXtXsq81HJhYvh4WXErOWR1/gu/KViiaAwTkH1RMy+7uSWHZ40nHn68NLYO4DamSX1w7rxGiDlTl2Da0kxcnxA67VN3O4Q6nb6O6HEIghaqewXGC7BdNqYYdctLSOXZ8LvY6xv3ziG1UJWb5fBGA8h2ug61mVjs2RrCGCImkojJCoGZLY/+KrXOmbWuypSIK8C5GQkPjv3ebN54ZaPqWcrnNfM0MFPNiO77eAYPkHpkb5bYHXb8roWeyieRUG5LZlTSjiS4keQBhuKKT0b2bZtlZCrUanDRtyefyWVffqht94PQ/3GsedEaVTciug/zn/bHPT7bArLnt96VWjUJ+tCFrgWXL7CzkjZesEJ2bdU823PSDwyT9UwHdtKIHBp87FjTWtHgAxTRMS/Iw3tYABvF412YxiLfSPAiXT0+14kgycXUP/8mVJ0DUZgZOmLKCRHkXf0mnoTG0PxKJ6Or6zlLqeCqA+rVa/JY9C7fPE1tpHJ6u2ocDVQrjF2Ttn4CcWyzSnSZmFZr6jIeM8MqYZJdxKKFeub8tyKZbI9aMtvXsJPED0t3ji/ZanT7ZLcEQyPrXgpIq/LSIpCIA8nqcj4mjJqiYYP0Birvft6MknykxqT2tpchcqZaVhgSSMzdnWp2Oq2DUT1Tq6Qz/6rDR/Eqe1cxHNmySK4KoUtge1LkRs0GBak6NVjIpiFJS6xlKUwzhSEqSYjftREAjXJddHzppxHWDZvLUslJWmlg8pm+jQSCFTF91mqMVYKunC2g/7Gm2FJGI3kdg81AcMqp36XXtCZrEhELgb21MkvTlUFb12vLJ/OF3m2hwJLsuIbKqvFxCK9WzdREBVz3v7EzgBwyWOXY69ceXYyWJSv7V5ofnlG
 AEBfCXNE
 FKEDIQeg/gAEFBgFUOPJSoA5PxldW7cJTP3HJApIWNv04W69GSyYnFbFWeLORqhw70c/DJAJ4R1TRUOiHdosE1leuH5ptFdalcoQr2IXa34ef79pTbb+44tf0L6UZxVKbX0O5JLL7/rnv/7AuIssJKsiDV62l+vclN1r8/FIy2I6fwyCcwMLm41kULBLC4suoMjIITbRU35S9oQL1wFGmrH4hvv1y+TSFamohocNoGoPVX//wjJiCBvqg6Oqz/N/Fn2jpxliLF5wVLAVIYMNB7yMUjCrDCHJt8IfJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 10:20=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 01.09.25 10:05, Max Kellermann wrote:
> > On Mon, Sep 1, 2025 at 9:33=E2=80=AFAM Kiryl Shutsemau <kirill@shutemov=
.name> wrote:
> >>
> >> On Sun, Aug 31, 2025 at 11:39:07AM +0200, Max Kellermann wrote:
> >>> For improved const-correctness.
> >>
> >> It is not a proper commit message.
> >
> > I believe it is proper for something as trivial as this. I think
> > adding more text would just be noise, only wasting the time of people
> > reading it. But that is a matter of perspective: I expect every
> > competent C developer to know the concept of const-correctness.
> >
> > Do you believe the commit message of 29cfe7556bfd ("mm: constify more
> > page/folio tests") is "proper"?
> >
>
> "Constify shmem related test functions for improved const-correctness."

Mentioning "shmem" adds no information because that is already
mentioned in the subject. "Constify" is just as redundant, it's the
same as "adding const".

The only new piece of information here is "test". If you want, I can
change the subject to "mm/shmem: add `const` to pointer parameters of
test functions" and leave the body. Would that make the commit message
"proper", or do you insist on having redundant information in the
body?

