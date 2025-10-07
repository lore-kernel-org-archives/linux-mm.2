Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79CBBCCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 16:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C11FC8E0010; Tue,  7 Oct 2025 12:27:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE9BF8E0003; Tue,  7 Oct 2025 12:27:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B005C8E0010; Tue,  7 Oct 2025 12:27:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9B6558E0003
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:27:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 42BEC1DE89E
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:27:14 +0000 (UTC)
X-FDA: 83971847988.05.7680184
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id 66E7A40012
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:27:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G7cBw8uG;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759854432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UBD2hSu0l0klHe2PgM26i3kvAILb+lcpLzVDDzltvlo=;
	b=xVEuA0t6K9HI5DgdGrrNVWMvpcfhXWCuFXoILtGf97D0x2Kidty+Djm+FQsYTUEmHmAX1d
	kaBLikJ2N9O/8L0O8RB5m3ySAvxp1r3lo7vpOxMt5bMitj9DyD4Kr0ochkQh3Y4btlajeK
	oFBYIYYC1eDbaZwykm8kDpel1GEF9kQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G7cBw8uG;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759854432; a=rsa-sha256;
	cv=none;
	b=MlQRLMv0xO4P6L6NXceV9dxiTxJnsrsJfp/yh8MgzVFiEfBsAFMt/CXxnvSZmvgLedcjap
	4anS9BtTLzvrN9dSpqzDHm2X6WaqYqsKQWHF0pwD5RqaCtmtZkoXUfauBHpt8YJSv9UeEp
	/Xlp+JLK5zEj+JEIVStPYesEK29WLV0=
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-9379a062ca8so233898839f.2
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 09:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759854431; x=1760459231; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UBD2hSu0l0klHe2PgM26i3kvAILb+lcpLzVDDzltvlo=;
        b=G7cBw8uGQUOd9hDMrkOxGIudi+IFA7KHHLIQoUMjl2D5Mam7bafguhugFwZ1V8anpH
         avbuRHAGvVjYsk3wFPLcLqlENNCUvvptGXWfgv0DNtB5BpMrFnwoRa5+OEjEzlpQAzAZ
         B0RabZT6+jNHrDua+dRLVbZOLJVqf31itAmYH4tgVVK798pQIFsV1t8FZY2PicEslLzJ
         0Hj2wNeON4EhmEmHXZBGoN00XwUWMlu7hb6s4DfisS287NZhz88P/yfATFswFS11NUhH
         cQWmJlZHPg8eWOPz0cTDajjE4Mflf1/xvEYCQrPop78tVeRMnq5AgTe3v7IX64iOy9U5
         9mQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759854431; x=1760459231;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UBD2hSu0l0klHe2PgM26i3kvAILb+lcpLzVDDzltvlo=;
        b=myR8ICRsMxAkO0asWnKdzQzhqEgysayF/jWlNKjns48CZVKuchlnzhHcw7BiL6EXom
         VztB3SqU0X7OcFSl6F9DrdPCdolMmL1TaoZzcAzybLAFiCzIP1eg3wxBTft3jhsdKeun
         U1xmWOozX3h54ZRH38k1NbHUyVSE0uJKBhtMM//F4R7KuF3Zp8EZhF1PlvTZCUs27tvy
         M/aXXzX4ZweqEpnMB8VBSh7lxwD6icPfjLmE60DoIGEaFAr5EmoeKO/LdGB6Ecj0f8Bp
         q3bMJUXdAIyHDxKw2KTCeWSfCP7o8vVnRZje3uqggLLL13f86AKtbRUyB6TeiSieT7MO
         7Wqg==
X-Forwarded-Encrypted: i=1; AJvYcCWwgnZllXpyuBrYzijbrT3294mvVQ6DRybzoHroOG8MYPs2yj2lbVoYkyvYl+6k7R3Ftnll1I9Ybg==@kvack.org
X-Gm-Message-State: AOJu0YwkeG0463+fbm2TFXgW4bG5xP7IMQ0KqobA+ZFiT2ORxlUywo20
	g59RULHl6c5zN+dmm1J+yZwS8WuJIY9OMudX7KFsAEgWtR4J0rOarpXpxNUbpLRasnEyinwk4i2
	d8TcJU6tbP777E/HB8l6f20SAwOttX/s=
X-Gm-Gg: ASbGncvCHi11QGuOPRfKMHOgkQQ8En/t/zcrnxe6ssZ33gNZ/OVUZvo00wtj0cFdYjJ
	EezmDepAhwIjkg8yeG2ng/CVvJULYob4coKs6WR2//rRv8SG8smrXjVIg49NoLBk6qX+nifunZe
	laEz8DyOY6s4rmE6+8pN12rdcApfqNhKFBhJZG9B1m9FgbBXuLQjYJW10phq33kUe7BLK038tGr
	K+DiuW58FPpDX4Xf0dwRLObz62d
X-Google-Smtp-Source: AGHT+IGLCFTglTAa2kP1ck6r7iG/OBxuOc/X5vnBoy2Ox8YpkFznUIu4nAdIvA5gwoNVKy9bdZ/E6m0Pbw/Ia4pBasM=
X-Received: by 2002:a05:6e02:2581:b0:426:e20b:f5d4 with SMTP id
 e9e14a558f8ab-42e7ad16b0bmr217493585ab.10.1759854431265; Tue, 07 Oct 2025
 09:27:11 -0700 (PDT)
MIME-Version: 1.0
References: <aOPDRmk2Zd20qxfk@shell.ilvokhin.com>
In-Reply-To: <aOPDRmk2Zd20qxfk@shell.ilvokhin.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 7 Oct 2025 09:26:59 -0700
X-Gm-Features: AS18NWDyUXxAHm2OhgOIQBVisQRhBDWipv0GA7qDF0rBOZJ41WWj-kV3nnRnazA
Message-ID: <CAKEwX=O2CMnufzuU7n32BD+SD5Oapmct=YGUUQFZ=2w+u2kGvA@mail.gmail.com>
Subject: Re: [PATCH v2] mm: skip folio_activate() for mlocked folios
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kairui Song <kasong@tencent.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Chris Li <chrisl@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 66E7A40012
X-Stat-Signature: ru8i5c8fqcbxcrfojb3ye51dhxkczbph
X-Rspam-User: 
X-HE-Tag: 1759854432-132550
X-HE-Meta: U2FsdGVkX1+zy1S7kUNwzuMwKrbZKyJtiw0b7l/m8YNpDFXiynV3M0kBOw2cG5QgoTNf5D+Kr86hvRBZPLRlGqjdx1/OJViK8NLrPnX77/VACE3rA1LhSo2j6E0bA5y0uJvrilDP/uxwGBQK2XqYqaBu5SXi4CIQMB8Uy+yJB0eDPtDAfNs0pXaLpEqOHer2iopusTvyrJVr4ATVvvtNUMRHDcnEUDSat0FVj9M16yf4iQvz3rRH9la+H7BFmFkBVzqzpXVetX8RC60Mh0oTO/tJI7MFv8aQbHk/FQ+mJ2Dw7rMej0ReE+pOu+FX+zhgqHsuow714l3Fs8imC/DT99TS9tJ7EPNF9+AXTKlFHD+9w81sHAWHFdfF1DLezFNmD2alm4B85uLETKtTVUBWhpzKh+/7sfBVjBW7BBruybWSkdAyX3PMqpMi0sio38OFl9hBaAYY/q54cpzIDWEXh56VGqRcLQLEXrj6B2u6l3HjpDtMBgiF7VlC96vF4EvP2SdLPlcPppyC2D4ZvO0T225PZJUEUbAD4N1fC2V5cXZowbYO9b0y9gY3CdXspgZZBhScFavVY152YMn4hljXJqcPeMsKe04GkVXYyZMKj2KWb5OA7+TNP2S3rJtowRp9UOfxCT5hnnDqCZGZOKiWydMmNUFREKbxCrR5dYZKab3pSklihbt+KTBykuPUUyble3n2YU9OyxsyDs5l+7RiHICUP6J+zhDTjaxIZimL6d4GTxflcaOOFL+pndPr4BJS3oiMyxV/KKzb5Pt1GsZwtdi7byDoJnMA+i76hcaMO/wDzjMabjDdJ7FHPl0pxbYYcCu7yyWPgIHnjbA6dVsxE61AvaAJvLVjuCeg089ztgSMccszOEFM1dBnESNmnGzg1ApcgV8pnlCEShd06wVru6zO0eUJGS5mcg00nndVs4HXlwaZvrQ0DIiEoi8fwIOrNAZ9DLLFUEYzcQXHsjf
 uEoIpl/m
 2NyWBhDNlN2zu1xQDa8KamQ+4MWJhGefOL6TpxjdN7hpKenvRIYc5DmSgQ103xFRDZA6vnwkABgXQ9pY0B4lBzJSC1yrkKFUdmk+llAwMK/hZayyONtvaCPpD97N5t25RDU8c4EBYP4JcukilFQlDc+ay6FW5mH0jywgycbVhU9DEGZLNxN1RoOSRRaBXOs7iG2MIZaWXHA2/XeFVV4NgaMH8Kn5OTMCDNDaPO4wXjCLJ+bwfcErn7Ff+bRK/UgIKVBD/9owb9+g+5NFyLycaFlXJMMAg4JpHbKs9ju1ez7EtotdIGM9OaPLvra0GB9PSqwq05bRx38p8NSmUS/FRTV9izLpUtuPP+rWraf7UYUvdwcGz7XqHA1bmUFumMTTZYi+5UyatE14CxgS9B6hN9zUGXn8wdq9o6ug7FReEK0H4R169Oty/iEEIaVYYeUMOrloIIvKvotWhHjx/3jY8gYNbuhX3mTOufIh7bbfTJPH+escJf/yRjmd/Y10/Uqh6EWCi7raaRrwxNDD4YRznRhgMxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 6, 2025 at 6:25=E2=80=AFAM Dmitry Ilvokhin <d@ilvokhin.com> wro=
te:
>
> __mlock_folio() does not move folio to unevicable LRU, when
> folio_activate() removes folio from LRU.
>
> To prevent this case also check for folio_test_mlocked() in
> folio_mark_accessed(). If folio is not yet marked as unevictable, but
> already marked as mlocked, then skip folio_activate() call to allow
> __mlock_folio() to make all necessary updates. It should be safe to skip
> folio_activate() here, because mlocked folio should end up in
> unevictable LRU eventually anyway.
>
> To observe the problem mmap() and mlock() big file and check Unevictable
> and Mlocked values from /proc/meminfo. On freshly booted system without
> any other mlocked memory we expect them to match or be quite close.
>
> See below for more detailed reproduction steps. Source code of stat.c is
> available at [1].
>
>   $ head -c 8G < /dev/urandom > /tmp/random.bin
>
>   $ cc -pedantic -Wall -std=3Dc99 stat.c -O3 -o /tmp/stat
>   $ /tmp/stat
>   Unevictable:     8389668 kB
>   Mlocked:         8389700 kB
>
>   Need to run binary twice. Problem does not reproduce on the first run,
>   but always reproduces on the second run.
>
>   $ /tmp/stat
>   Unevictable:     5374676 kB
>   Mlocked:         8389332 kB
>
> [1]: https://gist.github.com/ilvokhin/e50c3d2ff5d9f70dcbb378c6695386dd
>
> Co-developed-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Usama Arif <usamaarif642@gmail.com>

Acked-by: Nhat Pham <nphamcs@gmail.com>

